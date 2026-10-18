import { createHmac, randomUUID, timingSafeEqual } from "node:crypto";
import type { PoolClient } from "pg";
import { postgres, transaction } from "./postgres";

export type PublishRequest = {
  url: string;
  body?: any;
  serializedBody?: string;
  method?: string;
  headers?: Record<string, string>;
  delay?: number | string;
  notBefore?: number;
  retries?: number;
  deduplicationId?: string;
  queueName?: string;
  label?: string;
  callback?: string;
  failureCallback?: string;
  flowControl?: {
    key: string;
    parallelism?: number;
    rate?: number;
    period?: number | string;
  };
  [key: string]: any;
};
export type PublishBatchRequest<T = any> = PublishRequest & { body?: T };
export function durationSeconds(value: number | string | undefined): number {
  if (value === undefined) return 0;
  if (typeof value === "number") return value;
  const match = value.match(/^(\d+(?:\.\d+)?)\s*(ms|s|m|h|d)?$/);
  if (!match) throw new Error(`Invalid duration: ${value}`);
  return (
    Number(match[1]) *
    ({ ms: 0.001, s: 1, m: 60, h: 3600, d: 86400 }[match[2] || "s"] ?? 1)
  );
}
export function jobSignature(body: string, timestamp: string, path: string) {
  const secret = process.env.INTERNAL_JOB_SECRET;
  if (!secret) throw new Error("INTERNAL_JOB_SECRET is required");
  return createHmac("sha256", secret)
    .update(`${timestamp}\n${path}\n${body}`)
    .digest("hex");
}
export function verifyJobRequest(req: Request, body: string) {
  const timestamp = req.headers.get("x-dub-job-timestamp") || "";
  const signature = req.headers.get("x-dub-job-signature") || "";
  if (
    !/^\d+$/.test(timestamp) ||
    Math.abs(Date.now() - Number(timestamp)) > 300000 ||
    !/^[a-f0-9]{64}$/.test(signature)
  )
    return false;
  const expected = jobSignature(
    body,
    timestamp,
    new URL(req.url).pathname + new URL(req.url).search,
  );
  return timingSafeEqual(
    Buffer.from(signature, "hex"),
    Buffer.from(expected, "hex"),
  );
}

export class DatabaseQueue {
  async publishJSON(
    request: PublishRequest,
    client?: PoolClient,
  ): Promise<{ messageId: string }> {
    if (request.flowControl?.rate && !client)
      return transaction((tx) => this.publishJSON(request, tx));
    const target = new URL(request.url);
    if (
      !["http:", "https:"].includes(target.protocol) ||
      target.username ||
      target.password
    )
      throw new Error(
        "Job destination must be an HTTP URL without credentials",
      );
    const id = randomUUID();
    const available = new Date(
      request.notBefore
        ? request.notBefore * 1000
        : Date.now() + durationSeconds(request.delay) * 1000,
    );
    if (request.flowControl?.rate && client) {
      const period = durationSeconds(request.flowControl.period ?? 1);
      if (request.flowControl.rate <= 0 || period <= 0)
        throw new Error("Invalid job flow-control rate");
      const slot = await client.query(
        `INSERT INTO dub_runtime.flow_slot(key,next_at) VALUES($1,now()+($2*interval '1 second'))
        ON CONFLICT(key) DO UPDATE SET next_at=GREATEST(dub_runtime.flow_slot.next_at,now())+($2*interval '1 second')
        RETURNING next_at-($2*interval '1 second') AS dispatch_at`,
        [request.flowControl.key, period / request.flowControl.rate],
      );
      if (slot.rows[0].dispatch_at > available)
        available.setTime(slot.rows[0].dispatch_at.getTime());
    }
    const { rows } = await (client ?? postgres).query(
      `INSERT INTO dub_runtime.delivery(id,request,available_at,max_attempts,dedupe_key,queue_key,parallelism)
      VALUES($1,$2::jsonb,$3,$4,$5,$6,$7)
      ON CONFLICT(dedupe_key) DO UPDATE SET dedupe_key=excluded.dedupe_key RETURNING id`,
      [
        id,
        JSON.stringify({
          ...request,
          // JSONB normalizes object key order; signatures require the exact bytes.
          serializedBody: JSON.stringify(request.body ?? {}),
        }),
        available,
        (request.retries ?? 5) + 1,
        request.deduplicationId ?? null,
        request.queueName ?? request.flowControl?.key ?? null,
        request.queueName ? 1 : request.flowControl?.parallelism ?? 10,
      ],
    );
    return { messageId: rows[0].id };
  }
  batchJSON(requests: PublishRequest[]) {
    return Promise.all(requests.map((request) => this.publishJSON(request)));
  }
  queue({ queueName }: { queueName: string }) {
    return {
      enqueueJSON: (request: PublishRequest) =>
        this.publishJSON({ ...request, queueName }),
    };
  }
  messages = {
    get: async (id: string): Promise<Record<string, any>> => {
      const { rows } = await postgres.query(
        "SELECT * FROM dub_runtime.delivery WHERE id=$1",
        [id],
      );
      return rows[0] ?? {};
    },
    delete: async (id: string) => {
      await postgres.query(
        "UPDATE dub_runtime.delivery SET status='cancelled' WHERE id=$1 AND status IN ('pending','running')",
        [id],
      );
    },
  };
}
export const databaseQueue = new DatabaseQueue();
