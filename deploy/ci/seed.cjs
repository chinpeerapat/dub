// Disposable CI fixtures only; the deployment initializer never creates users.
const { PrismaClient } = require("../../apps/web/node_modules/@prisma/client");
const { hash } = require("../../apps/web/node_modules/bcryptjs");

async function main() {
  const prisma = new PrismaClient();
  try {
    const user = await prisma.user.create({
      data: {
        email: "selfhost-smoke@example.test",
        name: "Self-host smoke",
        emailVerified: new Date(),
        passwordHash: await hash("SelfhostTest-2026!", 12),
        defaultWorkspace: "selfhost-smoke",
      },
    });
    await prisma.project.create({
      data: {
        id: "selfhost-smoke",
        slug: "selfhost-smoke",
        name: "Self-host smoke",
        billingCycleStart: 1,
        users: { create: { userId: user.id, role: "owner" } },
        defaultDomains: { create: {} },
      },
    });
  } finally {
    await prisma.$disconnect();
  }
  const base = process.env.SUPABASE_STORAGE_URL;
  const headers = {
    authorization: `Bearer ${process.env.SUPABASE_SERVICE_ROLE_KEY}`,
  };
  const response = await fetch(`${base}/object/public/ci-storage.txt`, {
    method: "POST",
    headers: { ...headers, "content-type": "text/plain" },
    body: "selfhost-storage-smoke",
    signal: AbortSignal.timeout(30000),
  });
  if (!response.ok) throw new Error(`Storage upload: ${response.status}`);
  const download = await fetch(
    `${process.env.SUPABASE_URL}/storage/v1/object/public/public/ci-storage.txt`,
    { signal: AbortSignal.timeout(30000) },
  );
  if (!download.ok || (await download.text()) !== "selfhost-storage-smoke")
    throw new Error("Public storage download failed");
  const removed = await fetch(`${base}/object/public`, {
    method: "DELETE",
    headers: { ...headers, "content-type": "application/json" },
    body: JSON.stringify({ prefixes: ["ci-storage.txt"] }),
    signal: AbortSignal.timeout(30000),
  });
  if (!removed.ok) throw new Error(`Storage deletion: ${removed.status}`);
  console.log("Disposable account and Storage smoke checks ready.");
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
