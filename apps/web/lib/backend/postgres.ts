import { Pool, type PoolClient } from "pg";

// A lazy pool keeps build-time module evaluation independent of live services.
const globalPg = globalThis as unknown as { dubPostgres?: Pool };
export const postgresConfig = {
  connectionString: process.env.DATABASE_URL?.replace(
    /([?&])schema=[^&]*&?/,
    "$1",
  ).replace(/[?&]$/, ""),
  options: "-c search_path=dub,public",
  max: Number(process.env.DATABASE_POOL_SIZE || 10),
  connectionTimeoutMillis: 5000,
  statement_timeout: Number(process.env.DATABASE_STATEMENT_TIMEOUT_MS || 30000),
};
export const postgres = globalPg.dubPostgres ?? new Pool(postgresConfig);
globalPg.dubPostgres = postgres;

export async function transaction<T>(
  fn: (client: PoolClient) => Promise<T>,
): Promise<T> {
  const client = await postgres.connect();
  try {
    await client.query("BEGIN");
    const value = await fn(client);
    await client.query("COMMIT");
    return value;
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  } finally {
    client.release();
  }
}
