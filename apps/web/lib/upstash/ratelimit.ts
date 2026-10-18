import { transaction } from "../backend/postgres";

type Duration = `${number} ${"ms" | "s" | "m" | "h" | "d"}`;
export const ratelimit = (requests = 10, duration: Duration = "10 s") => {
  async function check(identifier: string, consume: boolean) {
    const [amount, unit] = duration.split(" ");
    const windowMs =
      Number(amount) *
      ({ ms: 1, s: 1000, m: 60000, h: 3600000, d: 86400000 }[unit] ?? 0);
    if (!(windowMs > 0) || requests < 1)
      throw new Error("Invalid rate limit policy");
    const key = `ratelimit:${requests}:${duration}:${identifier}`;
    return transaction(async (client) => {
      await client.query(
        "SELECT pg_advisory_xact_lock(hashtextextended($1,0))",
        [key],
      );
      const { rows } = await client.query(
        "SELECT value FROM dub_runtime.cache WHERE key=$1 AND expires_at>now()",
        [key],
      );
      const now = Date.now();
      const hits: number[] = (rows[0]?.value ?? []).filter(
        (time: number) => time > now - windowMs,
      );
      const success = hits.length < requests;
      if (success && consume) hits.push(now);
      await client.query(
        "INSERT INTO dub_runtime.cache(key,value,expires_at) VALUES($1,$2::jsonb,$3) ON CONFLICT(key) DO UPDATE SET value=excluded.value,expires_at=excluded.expires_at",
        [key, JSON.stringify(hits), new Date(now + windowMs)],
      );
      return {
        success,
        limit: requests,
        remaining: Math.max(0, requests - hits.length),
        reset: (hits[0] ?? now) + windowMs,
        pending: Promise.resolve(),
      };
    });
  }
  return {
    limit: (identifier: string) => check(identifier, true),
    getRemaining: (identifier: string) => check(identifier, false),
  };
};
