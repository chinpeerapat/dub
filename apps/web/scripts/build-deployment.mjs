import { build } from "esbuild";
import { mkdir } from "node:fs/promises";
await mkdir(".deployment", { recursive: true });
for (const [name, entry] of [
  ["worker", "scripts/worker.ts"],
  ["init", "scripts/init-selfhost.ts"],
]) {
  await build({
    entryPoints: [entry],
    outfile: `.deployment/${name}.cjs`,
    bundle: true,
    platform: "node",
    format: "cjs",
    target: "node24",
    external: ["pg-native", "@prisma/client"],
    logLevel: "info",
  });
}
