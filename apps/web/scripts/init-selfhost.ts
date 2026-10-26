import { PrismaClient } from "@prisma/client";
import { spawnSync } from "node:child_process";
import { readFile } from "node:fs/promises";
import { Pool } from "pg";
import { supabaseServiceRoleKey } from "../lib/backend/supabase-key";

async function main() {
  const admin = new Pool({ connectionString: process.env.ADMIN_DATABASE_URL });
  if (!process.env.ADMIN_DATABASE_URL || !process.env.DATABASE_APP_PASSWORD)
    throw new Error(
      "ADMIN_DATABASE_URL and DATABASE_APP_PASSWORD are required for initialization",
    );
  try {
    const { rows } = await admin.query(
      "SELECT 1 FROM pg_roles WHERE rolname='dub_app'",
    );
    if (!rows.length) {
      const statement = await admin.query(
        "SELECT format('CREATE ROLE dub_app LOGIN PASSWORD %L',$1::text) AS sql",
        [process.env.DATABASE_APP_PASSWORD],
      );
      await admin.query(statement.rows[0].sql);
    }
    const membership = await admin.query(
      "SELECT format('GRANT dub_app TO %I',current_user) AS sql",
    );
    await admin.query(membership.rows[0].sql);
    await admin.query(
      "CREATE SCHEMA IF NOT EXISTS dub AUTHORIZATION dub_app; CREATE SCHEMA IF NOT EXISTS dub_runtime AUTHORIZATION dub_app; REVOKE ALL ON SCHEMA dub,dub_runtime FROM PUBLIC;",
    );
    await admin.query("ALTER ROLE dub_app SET search_path TO dub,public");
    // These schemas are deliberately absent from PostgREST's exposed schemas.
    await admin.query(await readFile("deploy/runtime.sql", "utf8"));
    await admin.query(
      "GRANT USAGE ON SCHEMA dub_runtime TO dub_app; GRANT ALL ON ALL TABLES IN SCHEMA dub_runtime TO dub_app; GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA dub_runtime TO dub_app;",
    );
    const migrated = spawnSync(
      "pnpm",
      [
        "--filter",
        "web",
        "exec",
        "prisma",
        "migrate",
        "deploy",
        "--schema=prisma/schema",
      ],
      { stdio: "inherit", env: process.env },
    );
    if (migrated.status !== 0) throw new Error("Database migration failed");
    await admin.query(
      "REVOKE ALL ON SCHEMA dub,dub_runtime FROM anon,authenticated; REVOKE ALL ON ALL TABLES IN SCHEMA dub FROM anon,authenticated;",
    );
  } finally {
    await admin.end();
  }
  const prisma = new PrismaClient();
  try {
    const systemId = "cl7pj5kq4006835rbjlt2ofka";
    await prisma.project.upsert({
      where: { id: systemId },
      create: {
        id: systemId,
        name: "Default links",
        slug: "system",
        billingCycleStart: 1,
        plan: "enterprise",
        linksLimit: 2147483647,
        usageLimit: 2147483647,
      },
      update: {},
    });
    const domain = process.env.NEXT_PUBLIC_SHORT_DOMAIN;
    if (!domain) throw new Error("NEXT_PUBLIC_SHORT_DOMAIN is required");
    await prisma.domain.upsert({
      where: { slug: domain },
      create: {
        slug: domain,
        projectId: systemId,
        verified: true,
        primary: true,
      },
      update: { verified: true },
    });
  } finally {
    await prisma.$disconnect();
  }
  for (const [name, isPublic] of [
    [process.env.STORAGE_PUBLIC_BUCKET, true],
    [process.env.STORAGE_PRIVATE_BUCKET, false],
  ] as const) {
    if (!name) throw new Error("Storage bucket names are required");
    const response = await fetch(
      `${process.env.SUPABASE_STORAGE_URL || `${process.env.SUPABASE_URL}/storage/v1`}/bucket`,
      {
        method: "POST",
        headers: {
          authorization: `Bearer ${supabaseServiceRoleKey()}`,
          "content-type": "application/json",
        },
        signal: AbortSignal.timeout(30000),
        body: JSON.stringify({
          id: name,
          name,
          public: isPublic,
          file_size_limit: 52428800,
        }),
      },
    );
    const result = await response.json();
    if (
      !response.ok &&
      result.statusCode !== "409" &&
      result.statusCode !== 409 &&
      !String(result.error).includes("Duplicate")
    )
      throw new Error(
        `Could not create storage bucket ${name}: ${JSON.stringify(result)}`,
      );
  }
  console.log("Self-hosted database and storage initialized.");
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
