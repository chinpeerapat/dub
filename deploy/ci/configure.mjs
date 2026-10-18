import { execFileSync } from "node:child_process";
import { appendFileSync, readFileSync } from "node:fs";
import { parseEnv } from "node:util";

execFileSync(process.execPath, ["deploy/setup.mjs"], { stdio: "inherit" });
appendFileSync(".env.selfhost", "HTTP_PORT=18080\nHTTPS_PORT=18443\n");
for (const [name, value] of Object.entries(
  parseEnv(readFileSync(".env.selfhost", "utf8")),
)) {
  if (value && /SECRET|PASSWORD|TOKEN|KEY|DATABASE_URL/.test(name)) {
    console.log(`::add-mask::${value}`);
  }
}
