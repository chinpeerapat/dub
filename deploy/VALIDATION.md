# Validation notes

Validated locally on 2026-10-18:

- The application-wide TypeScript check passed on the final refactor.
- The PostgreSQL integration suite passed 20 tests: locks, expiry, OTP consumption, shared rate limits, hashes/sets/streams, cached API/embed tokens, event deduplication, workspace isolation, metadata filtering, empty time buckets, delivery leasing, retries and success/failure callbacks, signed webhook bytes and credential isolation, workflow checkpoints, flow-control scheduling, upload signatures, Prisma/raw SQL, enum binding, transaction rollback, JSON filtering, password-hash omission, and long destination URLs.
- The complete Prisma schema initialized an empty PostgreSQL database. The follow-up index migration also applied successfully.
- Real self-hosted Supabase PostgreSQL, PostgREST, Storage, and imgproxy services reached healthy status using the included Compose definitions.
- The initializer created the restricted application role, private schemas, default short domain, and public/private buckets.
- Supabase Storage upload, object metadata reads, and deletion passed against the actual Storage API.
- The worker and initializer bundle builds passed.
- Both root and compatibility Compose configurations parsed successfully.
- Changed source files were formatted, and `git diff --check` passed.

The full Next.js production build did not complete on the 8 GB validation Mac. The last attempt was stopped after 20 minutes of heavy swapping, without a reported compilation error. Next.js build workers and memory optimizations have since been enabled; a successful build with that configuration remains required.

The complete Docker application image, full application-stack startup, and browser sign-in/link-management smoke test are **not production-verified**. Run the documented Docker build on a larger runner and verify those flows before deploying for users.

Database containers and the application build were run separately to reduce memory contention. Test services are stopped. This session's generated local configuration and database were archived outside the repository so the next setup begins with a fresh database.
