import { createHmac } from "node:crypto";
import { readFile } from "node:fs/promises";
import { createServer } from "node:http";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { tokenCache } from "../../lib/auth/token-cache";
import { ingestEvents, queryEvents } from "../../lib/backend/analytics";
import { PostgresCache } from "../../lib/backend/cache";
import { postgres } from "../../lib/backend/postgres";
import {
  DatabaseQueue,
  jobSignature,
  verifyJobRequest,
} from "../../lib/backend/queue";
import { postgresSql } from "../../lib/backend/sql";
import { signUpload, verifyUpload } from "../../lib/backend/storage";
import { claimDelivery, cronMatches, deliver } from "../../lib/backend/worker";
import { serve } from "../../lib/backend/workflow";
import { referralsEmbedToken } from "../../lib/embed/referrals/token-class";
import { ratelimit } from "../../lib/upstash/ratelimit";
import { createWebhookSignature } from "../../lib/webhook/signature";

beforeAll(async () => {
  if (!process.env.DATABASE_URL?.includes("dub_test"))
    throw new Error(
      "Use a disposable database whose name starts with dub_test",
    );
  process.env.INTERNAL_JOB_SECRET = "test-only-job-secret";
  await postgres.query(await readFile("../../deploy/runtime.sql", "utf8"));
});
beforeEach(async () => {
  await postgres.query(
    "TRUNCATE dub_runtime.cache,dub_runtime.event,dub_runtime.delivery,dub_runtime.workflow_step,dub_runtime.flow_slot",
  );
});
afterAll(async () => {
  await postgres.end();
});

describe("PostgreSQL infrastructure", () => {
  const cache = new PostgresCache();
  it("has one winner for concurrent NX locks and only lets its owner release", async () => {
    const winners = await Promise.all(
      Array.from({ length: 20 }, (_, index) =>
        cache.set("lock", String(index), { nx: true, ex: 60 }),
      ),
    );
    expect(winners.filter(Boolean)).toHaveLength(1);
    const token = await cache.get<string>("lock");
    expect(await cache.eval('redis.call("del")', ["lock"], ["other"])).toBe(0);
    expect(await cache.get("lock")).toBe(token);
    expect(await cache.eval('redis.call("del")', ["lock"], [token])).toBe(1);
  });
  it("expires values and consumes OTPs atomically", async () => {
    await cache.set("otp", "123456", { px: 1 });
    await new Promise((resolve) => setTimeout(resolve, 5));
    expect(await cache.get("otp")).toBeNull();
    await cache.set("otp", "123456");
    const reads = await Promise.all([cache.getdel("otp"), cache.getdel("otp")]);
    expect(reads.filter(Boolean)).toEqual(["123456"]);
  });
  it("enforces a shared sliding rate limit under concurrency", async () => {
    const limiter = ratelimit(5, "1 m");
    const results = await Promise.all(
      Array.from({ length: 20 }, () => limiter.limit("same-user")),
    );
    expect(results.filter((result) => result.success)).toHaveLength(5);
    expect((await limiter.limit("another-user")).success).toBe(true);
  });
  it("preserves cache objects, hashes, sets, and stream order", async () => {
    await cache.hset("hash", { a: { id: 1 }, b: false });
    expect(await cache.hmget("hash", "a", "missing")).toEqual({
      a: { id: 1 },
      missing: null,
    });
    await cache.sadd("set", "a", "a", "b");
    expect(await cache.smembers("set")).toEqual(["a", "b"]);
    const a = await cache.xadd("stream", "*", { amount: 1 });
    const b = await cache.xadd("stream", "*", { amount: 2 });
    expect(Object.keys(await cache.xrange("stream", "-", "+"))).toEqual([a, b]);
    await cache.xdel("stream", a);
    expect(Object.keys(await cache.xrange("stream", "-", "+"))).toEqual([b]);
  });
  it("reads cached API and embed tokens as structured values", async () => {
    const token = {
      user: {
        id: "test-user",
        name: "Test",
        email: "test@example.test",
        isMachine: false,
      },
      scopes: "links.read",
    };
    await tokenCache.set({ hashedKey: "test-hash", token });
    expect(await tokenCache.get({ hashedKey: "test-hash" })).toEqual(token);
    const props = { programId: "test-program", partnerId: "test-partner" };
    const embed = await referralsEmbedToken.create(props);
    expect(await referralsEmbedToken.get(embed.publicToken)).toEqual(props);
  });
  it("stores analytics idempotently and isolates workspace queries", async () => {
    await ingestEvents("dub_click_events", [
      {
        click_id: "click-1",
        workspace_id: "a",
        link_id: "link-a",
        country: "TH",
        timestamp: "2026-10-18T10:00:00Z",
      },
      {
        click_id: "click-2",
        workspace_id: "b",
        link_id: "link-b",
        country: "US",
        timestamp: "2026-10-18T10:00:00Z",
      },
    ]);
    await ingestEvents("dub_click_events", [
      {
        click_id: "click-1",
        workspace_id: "a",
        link_id: "link-a",
        country: "TH",
        timestamp: "2026-10-18T10:00:00Z",
      },
    ]);
    await ingestEvents("dub_sale_events", [
      {
        event_id: "sale-1",
        workspace_id: "a",
        link_id: "link-a",
        amount: 4500,
        timestamp: "2026-10-18T10:01:00Z",
      },
    ]);
    expect(
      await queryEvents("v4_count", {
        workspaceId: "a",
        eventType: "composite",
      }),
    ).toEqual([
      {
        groupByField: "count",
        clicks: 1,
        leads: 0,
        sales: 1,
        saleAmount: 4500,
      },
    ]);
    const rows = await queryEvents("v4_group_by", {
      workspaceId: "a",
      eventType: "clicks",
      groupBy: "countries",
    });
    expect(rows[0].groupByField).toBe("TH");
    expect(
      (
        await queryEvents("v4_count", {
          workspaceId: "a",
          filters: JSON.stringify([
            { field: "country", operator: "IN", values: ["US"] },
          ]),
        })
      )[0].clicks,
    ).toBe(0);
  });
  it("filters analytics using current link metadata", async () => {
    await ingestEvents("dub_links_metadata", [
      { link_id: "l", workspace_id: "a", partner_id: "p", folder_id: "folder" },
    ]);
    await ingestEvents("dub_click_events", [
      { click_id: "c", workspace_id: "a", link_id: "l" },
    ]);
    expect(
      (
        await queryEvents("v4_count", {
          workspaceId: "a",
          folderId: ["folder"],
        })
      )[0].clicks,
    ).toBe(1);
    expect(
      (
        await queryEvents("v4_count", {
          workspaceId: "b",
          folderId: ["folder"],
        })
      )[0].clicks,
    ).toBe(0);
  });
  it("deduplicates deliveries and leases each message to one worker", async () => {
    const queue = new DatabaseQueue();
    const request = {
      url: "https://app.example.com/api/job",
      body: { a: 1 },
      deduplicationId: "same",
      queueName: "serial",
    };
    const a = await queue.publishJSON(request);
    const b = await queue.publishJSON(request);
    expect(a).toEqual(b);
    await queue.publishJSON({ ...request, deduplicationId: "next" });
    const claims = await Promise.all([claimDelivery(), claimDelivery()]);
    expect(claims.filter(Boolean)).toHaveLength(1);
    await postgres.query(
      "UPDATE dub_runtime.delivery SET locked_until=now()-interval '1 second' WHERE status='running'",
    );
    const retry = await claimDelivery();
    expect(retry?.id).toBe(claims.find(Boolean)?.id);
    expect(retry?.attempts).toBe(2);
  });
  it("delays scheduled jobs and rejects unsigned or replayed requests", async () => {
    const queue = new DatabaseQueue();
    await queue.publishJSON({ url: "https://example.com", delay: 60 });
    expect(await claimDelivery()).toBeNull();
    const timestamp = String(Date.now());
    const body = '{"a":1}';
    const signature = jobSignature(body, timestamp, "/api/job");
    const req = new Request("https://app.example.com/api/job", {
      headers: {
        "x-dub-job-timestamp": timestamp,
        "x-dub-job-signature": signature,
      },
    });
    expect(verifyJobRequest(req, body)).toBe(true);
    expect(verifyJobRequest(req, '{"a":2}')).toBe(false);
    expect(
      verifyJobRequest(new Request("https://app.example.com/api/job"), body),
    ).toBe(false);
    const old = String(Date.now() - 600000);
    expect(
      verifyJobRequest(
        new Request(req, {
          headers: {
            "x-dub-job-timestamp": old,
            "x-dub-job-signature": jobSignature(body, old, "/api/job"),
          },
        }),
        body,
      ),
    ).toBe(false);
  });
  it("delivers signed jobs, retries failures, and persists callbacks", async () => {
    let calls = 0;
    let verified = false;
    let messageId: string | undefined;
    const server = createServer(async (req, res) => {
      let body = "";
      for await (const chunk of req) body += chunk;
      verified = verifyJobRequest(
        new Request(`http://127.0.0.1${req.url}`, {
          headers: req.headers as Record<string, string>,
        }),
        body,
      );
      calls++;
      messageId = req.headers["x-dub-message-id"] as string;
      res.statusCode = calls === 1 || req.url === "/api/fail" ? 503 : 200;
      res.end(calls === 1 ? "retry" : "ok");
    });
    await new Promise<void>((resolve) =>
      server.listen(0, "127.0.0.1", resolve),
    );
    const address = server.address() as { port: number };
    process.env.NEXT_PUBLIC_APP_URL = "https://app.example.com";
    process.env.APP_INTERNAL_URL = `http://127.0.0.1:${address.port}`;
    try {
      const queue = new DatabaseQueue();
      await queue.publishJSON({
        url: "https://app.example.com/api/job",
        body: { value: 1 },
        callback: "https://app.example.com/api/callback",
      });
      await deliver((await claimDelivery())!);
      expect(verified).toBe(true);
      expect(messageId).toBeTruthy();
      expect(
        (await postgres.query("SELECT status FROM dub_runtime.delivery"))
          .rows[0].status,
      ).toBe("pending");
      await postgres.query(
        "UPDATE dub_runtime.delivery SET available_at=now()",
      );
      await deliver((await claimDelivery())!);
      const states = (
        await postgres.query(
          "SELECT status,request FROM dub_runtime.delivery ORDER BY created_at",
        )
      ).rows;
      expect(states[0].status).toBe("completed");
      expect(states[1].request.url).toContain("/api/callback");
      expect(
        Buffer.from(states[1].request.body.body, "base64").toString(),
      ).toBe("ok");
      await postgres.query("DELETE FROM dub_runtime.delivery");
      await queue.publishJSON({
        url: "https://app.example.com/api/fail",
        retries: 0,
        failureCallback: "https://app.example.com/api/failed",
      });
      await deliver((await claimDelivery())!);
      const failure = (
        await postgres.query(
          "SELECT status,request FROM dub_runtime.delivery ORDER BY created_at",
        )
      ).rows;
      expect(failure[0].status).toBe("failed");
      expect(failure[1].request.url).toContain("/api/failed");
      expect(failure[1].request.body.status).toBe(503);
    } finally {
      await new Promise<void>((resolve, reject) =>
        server.close((error) => (error ? reject(error) : resolve())),
      );
      delete process.env.NEXT_PUBLIC_APP_URL;
      delete process.env.APP_INTERNAL_URL;
    }
  });
  it("reserves flow-control slots across concurrent publishers", async () => {
    const queue = new DatabaseQueue();
    await Promise.all(
      Array.from({ length: 3 }, (_, index) =>
        queue.publishJSON({
          url: "https://example.com/job",
          body: { index },
          flowControl: { key: "rate-test", rate: 1, period: "10s" },
        }),
      ),
    );
    const rows = (
      await postgres.query(
        "SELECT available_at FROM dub_runtime.delivery ORDER BY available_at",
      )
    ).rows;
    expect(
      rows[1].available_at.getTime() - rows[0].available_at.getTime(),
    ).toBeGreaterThanOrEqual(9900);
    expect(
      rows[2].available_at.getTime() - rows[1].available_at.getTime(),
    ).toBeGreaterThanOrEqual(9900);
  });
  it("preserves signed webhook bytes and forwards only customer credentials", async () => {
    const payload = { longerKey: { nestedFirst: 1, a: 2 }, id: "event" };
    const signature = await createWebhookSignature("customer-secret", payload);
    let received = "";
    let headers: Record<string, any> = {};
    const server = createServer(async (req, res) => {
      for await (const chunk of req) received += chunk;
      headers = req.headers;
      res.end("ok");
    });
    await new Promise<void>((resolve) =>
      server.listen(0, "127.0.0.1", resolve),
    );
    const address = server.address() as { port: number };
    try {
      await new DatabaseQueue().publishJSON({
        url: `http://127.0.0.1:${address.port}/webhook`,
        body: payload,
        headers: {
          "Dub-Signature": signature,
          Authorization: "Basic customer",
        },
      });
      await deliver((await claimDelivery())!);
      expect(received).toBe(JSON.stringify(payload));
      expect(headers["dub-signature"]).toBe(
        createHmac("sha256", "customer-secret").update(received).digest("hex"),
      );
      expect(headers.authorization).toBe("Basic customer");
      expect(headers["x-dub-job-signature"]).toBeUndefined();
    } finally {
      await new Promise<void>((resolve, reject) =>
        server.close((error) => (error ? reject(error) : resolve())),
      );
    }
  });
  it("resumes workflows without replaying completed steps", async () => {
    let first = 0;
    let second = 0;
    const workflow = serve(async (context) => {
      const value = await context.run("first", async () => {
        first++;
        return { value: 7 };
      });
      expect(value.value).toBe(7);
      await context.run("second", async () => {
        if (++second === 1) throw new Error("temporary failure");
      });
    });
    const body = JSON.stringify({ input: "test" });
    const request = () => {
      const timestamp = String(Date.now());
      return new Request("https://app.example.com/workflow", {
        method: "POST",
        body,
        headers: {
          "x-dub-workflow-id": "workflow-test",
          "x-dub-job-timestamp": timestamp,
          "x-dub-job-signature": jobSignature(body, timestamp, "/workflow"),
        },
      });
    };
    expect((await workflow.POST(request())).status).toBe(503);
    expect((await workflow.POST(request())).status).toBe(200);
    expect(first).toBe(1);
    expect(second).toBe(2);
  });
  it("fills empty time buckets and applies metadata comparisons", async () => {
    await ingestEvents("dub_lead_events", [
      {
        event_id: "metadata-lead",
        workspace_id: "a",
        link_id: "l",
        metadata: JSON.stringify({ score: 20 }),
        timestamp: "2026-10-18T10:05:00Z",
      },
    ]);
    const rows = await queryEvents("v4_timeseries", {
      workspaceId: "a",
      eventType: "leads",
      granularity: "hour",
      start: "2026-10-18T09:00:00Z",
      end: "2026-10-18T11:00:00Z",
      filters: JSON.stringify([
        { operand: "metadata.score", operator: "greaterThan", value: "10" },
      ]),
    });
    expect(rows.map((row) => row.leads)).toEqual([0, 1, 0]);
    const excluded = await queryEvents("v4_count", {
      workspaceId: "a",
      eventType: "leads",
      filters: JSON.stringify([
        { operand: "metadata.score", operator: "lessThan", value: "10" },
      ]),
    });
    expect(excluded[0].leads).toBe(0);
  });
  it("binds upload URLs to their path, bucket, limits and expiration", () => {
    const payload = {
      key: "messages/file.png",
      bucket: "private" as const,
      contentType: "image/png",
      contentLength: 1024,
      expires: Date.now() + 60000,
    };
    const signed = signUpload(payload);
    expect(verifyUpload(signed)).toEqual(payload);
    expect(() => verifyUpload(`${signed}x`)).toThrow();
    expect(() =>
      verifyUpload(signUpload({ ...payload, expires: Date.now() - 1 })),
    ).toThrow();
  });
  it("quotes Prisma names without modifying literal values", () => {
    expect(
      postgresSql(
        "SELECT partnerId AS partnerName FROM Partner WHERE email='Partner' AND id=$1",
      ),
    ).toBe(
      'SELECT "partnerId" AS "partnerName" FROM "Partner" WHERE "email"=\'Partner\' AND "id"=$1',
    );
    expect(postgresSql("INSERT INTO User(id,email) VALUES($1,$2)")).toBe(
      'INSERT INTO "User"("id","email") VALUES($1,$2)',
    );
    expect(cronMatches("*/5 * * * *", new Date("2026-10-18T10:15:00Z"))).toBe(
      true,
    );
    expect(cronMatches("*/5 * * * *", new Date("2026-10-18T10:16:00Z"))).toBe(
      false,
    );
  });
});
