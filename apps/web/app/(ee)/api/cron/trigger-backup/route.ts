import { withCron } from "@/lib/cron/with-cron";

export const dynamic = "force-dynamic";

// Database and volume backups belong to the deployment host.
export const GET = withCron(async () =>
  Response.json(
    {
      message:
        "Configure PostgreSQL and Storage volume backups on the host. See deploy/README.md.",
    },
    { status: 501 },
  ),
);
