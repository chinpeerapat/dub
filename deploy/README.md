# Self-hosted Dub with Supabase

This fork targets a **fresh PostgreSQL database**. It keeps Prisma and NextAuth and replaces PlanetScale, Upstash Redis/QStash, Tinybird, and S3 credentials with PostgreSQL infrastructure and Supabase Storage. It does not import an existing MySQL installation.

The included Supabase database/Storage services are pinned to upstream commit `7425d4930528931400fb3e656e860b1094cb224e`. Unused Auth, Studio, Realtime, Functions, and pooler services are omitted. Supabase Storage uses a persistent Docker volume; no external object-storage account is required.

## Start

Requirements: Docker with Compose v2.20+ (for `include`), Node.js 24 to generate configuration, DNS access for a public deployment, and an SMTP service for email verification and password resets. The Docker builder allows an 8 GB Node heap; use a builder with additional memory for Docker and the OS (16 GB or more is recommended). The production build did not complete on the 8 GB validation Mac. Runtime memory requirements have not been benchmarked.

From the repository root:

```sh
node deploy/setup.mjs --domain example.com
# Edit .env.selfhost: SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASSWORD, SMTP_FROM
# Set NEXT_PUBLIC_CUSTOM_DOMAIN_A_RECORD to the server's public IPv4 address.
docker compose --env-file .env.selfhost up -d --build
```

Create DNS records for `app`, `api`, `partners`, `admin`, `go`, and `storage` under your domain, pointing to your server. Ports 80 and 443 must reach Caddy for HTTPS certificates. `HTTP_PORT` and `HTTPS_PORT` change host bindings when another proxy is already installed; ensure that proxy forwards public traffic correctly. Keep the generated secrets when rebuilding or updating. The setup script refuses to overwrite an existing configuration.

For a local smoke test, omit `--domain`. The app listens at `http://localhost:8888`; storage is served at `http://localhost:8000/storage/v1`. To test host routing and short links locally, use hosts pointing to 127.0.0.1 and configure public origins consistently. Local short links use the HTTPS Caddy endpoint and require trusting Caddy's local CA. Do not enable `TRUST_PROXY` for a directly exposed app port.

The `migrate` service creates a dedicated `dub_app` database role, applies checked-in Prisma migrations, creates private runtime tables, seeds the default short domain, and creates public/private Storage buckets. It is safe to rerun for the same installation. It does not create demo users or sample partner data. Sign up through the app after configuring email.

## What runs

- `db`: Supabase PostgreSQL, containing the app's private `dub` schema and private `dub_runtime` schema.
- `rest`, `storage`, `imgproxy`: upstream Supabase Storage dependencies.
- `web`: Next.js standalone server; also handles signed uploads and job endpoints.
- `worker`: durable job delivery, retry handling, scheduled jobs, and expired-cache cleanup.
- `gateway`: Caddy HTTPS and public Storage routing.
- `migrate`: one-time initialization and schema upgrades, using the separate administrative connection.

Visitor location defaults to unknown. Geographic targeting requires trusted GeoIP headers from your ingress; this deployment does not invent a visitor location or depend on Vercel geolocation.

Only Caddy is intended for public ingress. PostgreSQL and the direct app/debug port are bound to the host's loopback interface. Do not expose Docker's internal service ports. Server-only credentials are never placed in `NEXT_PUBLIC_*` variables.

## Behavior and limits

Public origins and the short domain are build-time configuration. Rebuild the image after changing them; run the same values in the container. Set `AUTH_COOKIE_DOMAIN` only when the app and partner site should share sessions under a domain you control.

Cache values, sliding rate limits, event streams, and workflow checkpoints now live in PostgreSQL. The cache interface retains its old internal `lib/upstash` import paths to minimize changes to business logic; it does not call Upstash. Search uses PostgreSQL full-text matching rather than hosted semantic embeddings.

Analytics ingestion is idempotent by event ID. Analytics queries use PostgreSQL event tables instead of Tinybird pipes. This implementation targets smaller installations. Benchmark your traffic and retention requirements before large deployments. The old scripts under `scripts/tinybird` are maintenance scripts for the upstream hosted installation and are not part of this deployment.

Job delivery is **at least once**. Handlers must remain idempotent, especially payment and email side effects. Workflow steps checkpoint completed results; a process failure between a side effect and its checkpoint can repeat that step. Failed deliveries remain in `dub_runtime.delivery` with an error; inspect and replay them deliberately after fixing their cause. Completed deliveries are retained for seven days for deduplication and inspection.

The worker enables domain verification, click/webhook/stat streams, queue retry, and scheduled campaigns by default. `ENABLED_CRON_PATHS` accepts a comma-separated list to override that set; available paths/schedules are in `apps/web/vercel.json`. Enable payment, domain-registration, and external-integration jobs only after configuring their providers. They are not required to run link management.

Custom domains must be explicitly listed in `CUSTOM_DOMAINS` and added to Caddy's site list. Point their DNS to the deployment using the configured A record or CNAME. The application verifies DNS; it does not buy domains or edit a hosting provider's account. Automated domain purchasing/nameserver management is unavailable.

Supabase Storage upload URLs are issued by the app. The upload route verifies signatures, expiration, declared size/type, and applicable magic-byte rules before storing bytes. Private downloads use Supabase-signed download URLs. Authenticated clients do not receive the service-role key. The application retains NextAuth; no Supabase Auth migration is needed.

## Operations

```sh
docker compose --env-file .env.selfhost ps
docker compose --env-file .env.selfhost logs --tail=100 web worker migrate
docker compose --env-file .env.selfhost up -d --build
```

Back up **both** PostgreSQL and the `dub-selfhost_storage-data` Docker volume, along with `.env.selfhost` and Caddy's persistent volumes. Preserve `ENCRYPTION_KEY`; changing it prevents decrypting stored secrets. Test restoration into a separate installation. Stopping the stack preserves the database directory and storage volume. Never delete them or run `down --volumes` as an upgrade step.

Schedule backups on the host. The upstream PlanetScale backup endpoint returns `501` in this fork. A database archive can be created with `docker compose --env-file .env.selfhost exec -T db pg_dump -U postgres -Fc postgres > backup.dump`; protect the archive and also save database roles and the persistent volumes. A database archive alone does not contain uploaded files.

The runtime database schemas are not exposed by PostgREST, and `anon`/`authenticated` have no grants on them. Keep that separation when adding Supabase features. Configure optional integrations (Stripe, OAuth, AI, etc.) only if needed; their provider-specific features still require those services.

## Development checks

```sh
pnpm install --frozen-lockfile
DATABASE_URL='postgresql://.../dub_test_backend?schema=dub' pnpm --filter web test:backend
pnpm --filter web build:deployment
pnpm exec turbo run build --filter=web...
```

Backend tests require a disposable database with `dub_test` in its name and truncate only `dub_runtime` tables in that database.

## GitHub build validation

The `Self-hosted Docker` workflow runs on pushes to `selfhost/**` branches and supports manual dispatch. It builds the actual tools and production images, initializes an empty Supabase stack, runs the backend integration suite, and checks login, link creation/listing, short redirects, analytics, and Storage. Its generated credentials and test accounts are disposable; it needs no repository secrets and does not deploy or publish an image. The workflow stops its stack and removes its test volumes when finished.
