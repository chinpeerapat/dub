import { randomUUID } from "node:crypto";
import schedules from "../../vercel.json";
import { postgres, transaction } from "./postgres";
import { databaseQueue, jobSignature, type PublishRequest } from "./queue";

type Delivery = {
  id: string;
  request: PublishRequest;
  attempts: number;
  max_attempts: number;
  lease_token: string;
};
export async function claimDelivery(): Promise<Delivery | null> {
  return transaction(async (client) => {
    await client.query(
      "SELECT pg_advisory_xact_lock(hashtextextended('dub:delivery:claim',0))",
    );
    await client.query(
      "UPDATE dub_runtime.delivery SET status=CASE WHEN attempts>=max_attempts THEN 'failed' ELSE 'pending' END,locked_until=NULL WHERE status='running' AND locked_until<now()",
    );
    const { rows } =
      await client.query(`SELECT d.id FROM dub_runtime.delivery d WHERE d.status='pending' AND d.available_at<=now() AND d.attempts<d.max_attempts
      AND (d.queue_key IS NULL OR (SELECT count(*) FROM dub_runtime.delivery active WHERE active.queue_key=d.queue_key AND active.status='running')<d.parallelism)
      ORDER BY d.available_at,d.created_at FOR UPDATE SKIP LOCKED LIMIT 1`);
    if (!rows[0]) return null;
    const lease = randomUUID();
    const result = await client.query(
      "UPDATE dub_runtime.delivery SET status='running',attempts=attempts+1,locked_until=now()+interval '15 minutes',lease_token=$2 WHERE id=$1 RETURNING *",
      [rows[0].id, lease],
    );
    return result.rows[0];
  });
}
function internalTarget(url: URL) {
  const origins = [
    process.env.NEXT_PUBLIC_APP_URL,
    process.env.NEXT_PUBLIC_API_URL,
    process.env.NEXT_PUBLIC_PARTNERS_URL,
    process.env.APP_INTERNAL_URL,
  ]
    .filter(Boolean)
    .map((value) => new URL(value!).origin);
  return origins.includes(url.origin);
}
export async function deliver(job: Delivery) {
  const request = job.request;
  const url = new URL(request.url);
  const internal = internalTarget(url);
  const destination = internal
    ? new URL(
        url.pathname + url.search,
        process.env.APP_INTERNAL_URL || "http://web:3000",
      )
    : url;
  const method = request.method || "POST";
  const body =
    method === "GET" || method === "HEAD"
      ? ""
      : request.serializedBody ?? JSON.stringify(request.body ?? {});
  const headers = new Headers(request.headers);
  headers.set("content-type", "application/json");
  // Never send infrastructure credentials to customer webhook URLs.
  if (internal) {
    headers.set("host", url.host);
    headers.set("x-dub-message-id", job.id);
    const timestamp = String(Date.now());
    headers.set("x-dub-job-timestamp", timestamp);
    headers.set(
      "x-dub-job-signature",
      jobSignature(body, timestamp, url.pathname + url.search),
    );
    headers.set(
      "x-dub-final-attempt",
      String(job.attempts >= job.max_attempts),
    );
  }
  let response: Response | undefined;
  let result = "";
  const heartbeat = setInterval(() => {
    void postgres
      .query(
        "UPDATE dub_runtime.delivery SET locked_until=now()+interval '15 minutes' WHERE id=$1 AND lease_token=$2 AND status='running'",
        [job.id, job.lease_token],
      )
      .catch(console.error);
  }, 30000);
  try {
    response = await fetch(destination, {
      method,
      headers,
      body: body || undefined,
      redirect: "manual",
      signal: AbortSignal.timeout(Number(process.env.JOB_TIMEOUT_MS || 600000)),
    });
    result = (await response.text()).slice(0, 64000);
    if (!response.ok)
      throw new Error(`HTTP ${response.status}: ${result.slice(0, 1000)}`);
    const status = response.status;
    await transaction(async (client) => {
      const updated = await client.query(
        "UPDATE dub_runtime.delivery SET status='completed',completed_at=now(),locked_until=NULL WHERE id=$1 AND lease_token=$2 AND status='running' RETURNING id",
        [job.id, job.lease_token],
      );
      if (updated.rowCount && request.callback)
        await callback(request.callback, job, status, result, client);
    });
  } catch (error) {
    const final = job.attempts >= job.max_attempts;
    const retry = Number(response?.headers.get("retry-after"));
    const delay =
      Number.isFinite(retry) && retry > 0
        ? Math.min(retry, 86400)
        : Math.min(2 ** job.attempts, 3600);
    await transaction(async (client) => {
      const updated = await client.query(
        "UPDATE dub_runtime.delivery SET status=$3,last_error=$4,available_at=now()+($5*interval '1 second'),locked_until=NULL WHERE id=$1 AND lease_token=$2 AND status='running' RETURNING id",
        [
          job.id,
          job.lease_token,
          final ? "failed" : "pending",
          String(error).slice(0, 4000),
          delay,
        ],
      );
      if (updated.rowCount && final && request.failureCallback)
        await callback(
          request.failureCallback,
          job,
          response?.status ?? 599,
          result,
          client,
        );
    });
    console.error("job.delivery_failed", {
      id: job.id,
      attempt: job.attempts,
      final,
      error: String(error),
    });
  } finally {
    clearInterval(heartbeat);
  }
}
async function callback(
  url: string,
  job: Delivery,
  status: number,
  body: string,
  client?: import("pg").PoolClient,
) {
  await databaseQueue.publishJSON(
    {
      url,
      body: {
        status,
        body: Buffer.from(body).toString("base64"),
        sourceMessageId: job.id,
        messageId: job.id,
        url: job.request.url,
        sourceBody: Buffer.from(
          job.request.serializedBody ?? JSON.stringify(job.request.body ?? {}),
        ).toString("base64"),
        retried: job.attempts - 1,
      },
      deduplicationId: `callback:${job.id}:${status}`,
    },
    client,
  );
}
function cronField(pattern: string, value: number) {
  return pattern.split(",").some((part) => {
    const [range, stepString] = part.split("/");
    const step = Number(stepString || 1);
    const [start, end] =
      range === "*" ? [0, 100] : range.split("-").map(Number);
    return (
      value >= start && value <= (end ?? start) && (value - start) % step === 0
    );
  });
}
export function cronMatches(pattern: string, date: Date) {
  const fields = pattern.split(" ");
  const values = [
    date.getUTCMinutes(),
    date.getUTCHours(),
    date.getUTCDate(),
    date.getUTCMonth() + 1,
    date.getUTCDay(),
  ];
  return (
    fields.length === 5 &&
    fields.every((field, index) => cronField(field, values[index]))
  );
}
const defaultSchedules = new Set([
  "/api/cron/domains/verify",
  "/api/cron/streams/send-link-clicked-webhooks",
  "/api/cron/streams/update-click-stats",
  "/api/cron/streams/update-workspace-links-usage",
  "/api/cron/streams/update-partner-stats",
  "/api/cron/queue/retry",
  "/api/cron/campaigns/queue-scheduled",
]);
export async function scheduleCrons(now = new Date()) {
  const enabled = process.env.ENABLED_CRON_PATHS
    ? new Set(process.env.ENABLED_CRON_PATHS.split(","))
    : defaultSchedules;
  const minute = Math.floor(now.getTime() / 60000);
  for (const cron of schedules.crons)
    if (enabled.has(cron.path) && cronMatches(cron.schedule, now))
      await databaseQueue.publishJSON({
        url: `${process.env.NEXT_PUBLIC_APP_URL}${cron.path}`,
        method: "GET",
        deduplicationId: `cron:${cron.path}:${minute}`,
        retries: 2,
      });
}
export async function runWorker() {
  let stopping = false;
  const active = new Set<Promise<void>>();
  const concurrency = Number(process.env.WORKER_CONCURRENCY || 5);
  process.once("SIGTERM", () => {
    stopping = true;
  });
  process.once("SIGINT", () => {
    stopping = true;
  });
  let lastMinute = -1;
  let lastCleanup = 0;
  console.info("PostgreSQL job worker started");
  while (!stopping) {
    try {
      const minute = Math.floor(Date.now() / 60000);
      if (minute !== lastMinute) {
        await scheduleCrons();
        lastMinute = minute;
      }
      if (Date.now() - lastCleanup > 10000) {
        await postgres.query(
          "INSERT INTO dub_runtime.cache(key,value,expires_at) VALUES('worker:heartbeat',to_jsonb(now()),now()+interval '1 minute') ON CONFLICT(key) DO UPDATE SET value=excluded.value,expires_at=excluded.expires_at",
        );
        await postgres.query(
          "DELETE FROM dub_runtime.cache WHERE expires_at<now()",
        );
        await postgres.query(
          "DELETE FROM dub_runtime.delivery WHERE completed_at<now()-interval '7 days'",
        );
        lastCleanup = Date.now();
      }
      if (active.size >= concurrency) {
        await Promise.race(active);
        continue;
      }
      const job = await claimDelivery();
      if (job) {
        const task = deliver(job)
          .catch(console.error)
          .finally(() => active.delete(task));
        active.add(task);
        continue;
      }
    } catch (error) {
      console.error("worker.poll_failed", error);
    }
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }
  await Promise.allSettled(active);
  await postgres.end();
}
