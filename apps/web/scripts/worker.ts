import { postgres } from "../lib/backend/postgres";
import { runWorker } from "../lib/backend/worker";
async function main() {
  if (process.argv.includes("--health")) {
    const { rows } = await postgres.query(
      "SELECT 1 FROM dub_runtime.cache WHERE key='worker:heartbeat' AND expires_at>now()",
    );
    await postgres.end();
    process.exit(rows.length ? 0 : 1);
  } else await runWorker();
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
