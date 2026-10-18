import { PrismaClient } from "@prisma/client";
import { randomBytes } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { afterAll, beforeAll, expect, it } from "vitest";
import { postgres } from "../../lib/backend/postgres";
import { conn } from "../../lib/planetscale/connection";
import { prisma } from "../../lib/prisma";

beforeAll(async () => {
  if (!process.env.DATABASE_URL?.includes("dub_test"))
    throw new Error("Use a disposable dub_test database");
  const { rows } = await postgres.query(
    "SELECT to_regclass('dub.\"Project\"') AS name",
  );
  if (!rows[0].name) {
    await postgres.query("CREATE SCHEMA IF NOT EXISTS dub");
    const folder = (await readdir("prisma/schema/migrations")).find((name) =>
      /^\d/.test(name),
    );
    if (!folder) throw new Error("Initial migration is missing");
    await postgres.query(
      await readFile(
        `prisma/schema/migrations/${folder}/migration.sql`,
        "utf8",
      ),
    );
  }
  const lookup = await postgres.query(
    "SELECT to_regclass('dub.\"Link_projectId_url_idx\"') AS name",
  );
  if (lookup.rows[0].name) {
    const folder = (await readdir("prisma/schema/migrations")).find((name) =>
      name.endsWith("portable_link_lookup"),
    );
    if (folder)
      await postgres.query(
        await readFile(
          `prisma/schema/migrations/${folder}/migration.sql`,
          "utf8",
        ),
      );
  }
});
afterAll(async () => {
  await prisma.$disconnect();
  await postgres.end();
});

it("runs the complete schema, preserves raw-query bindings and aliases, and omits password hashes", async () => {
  const id = "test-prisma-project";
  const project = await prisma.project.upsert({
    where: { id },
    create: {
      id,
      slug: id,
      name: "Searchable Workspace",
      billingCycleStart: 1,
    },
    update: {},
  });
  const rows = await prisma.$queryRaw<
    { id: string; displayName: string }[]
  >`SELECT id, name AS displayName FROM Project WHERE id=${project.id}`;
  expect(rows).toEqual([{ id, displayName: "Searchable Workspace" }]);
  const injection = await conn.execute("SELECT id FROM Project WHERE id = ?", [
    "' OR 1=1 --",
  ]);
  expect(injection.rows).toEqual([]);
  const user = await prisma.user.upsert({
    where: { email: "backend-test@example.test" },
    create: { email: "backend-test@example.test", passwordHash: "test-only" },
    update: {},
  });
  expect(user).not.toHaveProperty("passwordHash");
  const visible = await prisma.project.findMany({
    where: { name: { contains: "searchable", mode: "insensitive" } },
  });
  expect(visible.some((row) => row.id === id)).toBe(true);
});

it("supports PostgreSQL JSON filters used by integrations", async () => {
  const direct = new PrismaClient();
  try {
    const id = "test-prisma-project";
    await direct.project.update({
      where: { id },
      data: {
        store: {
          team: { id: "team-test" },
          attributes: [{ attribute: "partnerJoined", operator: "IS" }],
        },
      },
    });
    expect(
      await direct.project.count({
        where: { id, store: { path: ["team", "id"], equals: "team-test" } },
      }),
    ).toBe(1);
    expect(
      await direct.project.count({
        where: {
          id,
          store: {
            path: ["attributes"],
            array_contains: [{ attribute: "partnerJoined" }],
          },
        },
      }),
    ).toBe(1);
  } finally {
    await direct.$disconnect();
  }
});

it("accepts long destination URLs without a PostgreSQL index size failure", async () => {
  const url = `https://example.com/?q=${randomBytes(3000).toString("hex")}`;
  await prisma.domain.upsert({
    where: { slug: "backend-test.localhost" },
    create: { slug: "backend-test.localhost", verified: true },
    update: {},
  });
  await prisma.link.upsert({
    where: { id: "backend-long-url" },
    create: {
      id: "backend-long-url",
      domain: "backend-test.localhost",
      key: "long",
      shortLink: "https://backend-test.localhost/long",
      url,
    },
    update: { url },
  });
  expect(
    (await prisma.link.findUnique({ where: { id: "backend-long-url" } }))?.url,
  ).toBe(url);
});

it("binds enum filters and keeps raw SQL inside Prisma transactions", async () => {
  const result = await prisma.$queryRaw<
    { id: string }[]
  >`SELECT id FROM Project WHERE environment=${"production"} AND id=${"test-prisma-project"}`;
  expect(result).toEqual([{ id: "test-prisma-project" }]);
  const before = await prisma.project.findUniqueOrThrow({
    where: { id: "test-prisma-project" },
  });
  await expect(
    prisma.$transaction(async (tx) => {
      await tx.$executeRaw`UPDATE Project SET name=${"rolled back"} WHERE id=${before.id}`;
      throw new Error("rollback-test");
    }),
  ).rejects.toThrow("rollback-test");
  expect(
    (await prisma.project.findUniqueOrThrow({ where: { id: before.id } })).name,
  ).toBe(before.name);
});
