# Validation notes

Validated on 2026-10-18, locally and on GitHub Actions using Ubuntu x64:

- The actual production Docker image built successfully, including the full Next.js production build and standalone output.
- An empty Supabase stack initialized successfully. PostgreSQL, PostgREST, Storage, imgproxy, the Next.js server, and the worker reached healthy status.
- The initializer created the restricted application role, private schemas, default short domain, and public/private buckets, then applied both checked-in Prisma migrations.
- All 20 PostgreSQL integration tests passed inside the Docker tools image against the Supabase PostgreSQL service. They cover cache concurrency/expiry, shared rate limits, structured tokens, analytics isolation/filtering, durable delivery/retries/callbacks, signed webhook bytes, internal Host headers, workflow checkpoints, upload signatures, Prisma/raw SQL, enum binding, transaction rollback, JSON filtering, password-hash omission, and long URLs.
- HTTP smoke checks passed for rendered login HTML, protected workspace data, password authentication and session cookies, link creation without an explicit domain, link listing, short-link redirects, and analytics.
- Chromium signed in through the two-step email/password form and displayed the persisted short link in the workspace without uncaught page errors.
- Real Supabase Storage upload, public download, and deletion passed.
- The application-wide TypeScript check and the worker/initializer bundle builds passed.
- Both root and compatibility Compose configurations parsed successfully. Changed source files were formatted, and `git diff --check` passed.

Evidence: [successful GitHub Actions run](https://github.com/chinpeerapat/dub/actions/runs/39138057447), application commit `f1746480aa`.

The 8 GB validation Mac could not complete the full production build under memory pressure; the GitHub runner completed it. Runtime capacity and production traffic have not been benchmarked. CI uses local HTTP origins and disposable credentials; public DNS/HTTPS and SMTP delivery must be configured for the deployment environment.

CI stops its stack and removes test volumes when finished. The deployment initializer creates no test users or sample partner data. This session's local test configuration and database were archived outside the repository, and its local test services are stopped.
