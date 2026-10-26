# Deploying on Railway

This layout runs the self-hosted fork on Railway with the community
[Supabase template](https://railway.com/deploy/supabase) (`supabase`, maintained
by 6ixfalls) for PostgreSQL, Storage, and the Envoy gateway. Dub keeps NextAuth;
the template's Auth, Realtime, Studio, Supavisor, and Meta services are not used
by Dub and can be removed to save cost.

## Services

| Service                          | Source                                                                    | Notes                                                                                      |
| -------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Supabase template services       | `railway.com/deploy/supabase`                                             | Postgres 17 (`supabase/postgres` image), Storage on a Railway bucket, Envoy public gateway |
| `migrate`                        | this repo, `DOCKER_TARGET=tools`                                          | start `node apps/web/.deployment/init.cjs`, restart `ON_FAILURE`; reruns safely on deploy  |
| `web`                            | this repo (`Dockerfile`, default stage)                                   | `HOSTNAME=::`, `PORT=3000`, healthcheck `/api/health`                                      |
| `worker`                         | this repo (`Dockerfile`, default stage)                                   | start `node apps/web/.deployment/worker.cjs`                                               |
| `api`, `partners`, `admin`, `go` | this repo, `RAILWAY_DOCKERFILE_PATH=deploy/railway/host-proxy.Dockerfile` | Caddy forwarders to `web`; watch pattern `deploy/railway/**`                               |

Railway gives each service one generated domain, while Dub routes by hostname.
The four forwarders each own one hostname and pass the original `Host` header to
`web` over private networking. With a custom domain, attach `app`, `api`,
`partners`, `admin`, and the short domain directly to `web` instead and delete
the forwarders.

## Variables

`web`, `worker`, and `migrate` share the variables from `deploy/setup.mjs`, with
these Railway-specific values. Generated secrets (`DATABASE_APP_PASSWORD`,
`NEXTAUTH_SECRET`, `ENCRYPTION_KEY`, `CRON_SECRET`, `INTERNAL_JOB_SECRET`) live
on `web`; `worker` and `migrate` reference them as `${{web.NAME}}`.

- `DATABASE_URL=postgresql://dub_app:${{DATABASE_APP_PASSWORD}}@${{Postgres.RAILWAY_PRIVATE_DOMAIN}}:5432/postgres?schema=dub`
- `ADMIN_DATABASE_URL=${{Postgres.POSTGRES_PRIVATE_URL}}` (`migrate` only)
- `SUPABASE_URL=http://${{Envoy.RAILWAY_PRIVATE_DOMAIN}}:8000`
- `SUPABASE_STORAGE_URL=http://${{"Supabase Storage".RAILWAY_PRIVATE_DOMAIN}}:5000`
- `SUPABASE_PUBLIC_URL=https://${{Envoy.RAILWAY_PUBLIC_DOMAIN}}`;
  `STORAGE_BASE_URL` is that URL plus `/storage/v1/object/public/public`
- `SUPABASE_ROOT_SECRET=${{"Supabase Studio".ROOT_SECRET}}`: the template
  derives its JWT secret and keys from `ROOT_SECRET`, and Dub derives the same
  service-role key from it (`apps/web/lib/backend/supabase-key.ts`). An explicit
  `SUPABASE_SERVICE_ROLE_KEY` takes precedence.
- Public origins reference each service's domain, e.g.
  `NEXT_PUBLIC_APP_URL=https://${{web.RAILWAY_PUBLIC_DOMAIN}}` and
  `NEXT_PUBLIC_SHORT_DOMAIN=${{go.RAILWAY_PUBLIC_DOMAIN}}`.
- `APP_INTERNAL_URL=http://${{web.RAILWAY_PRIVATE_DOMAIN}}:3000`
- `TRUST_PROXY=true`, `CLIENT_IP_HEADER=x-real-ip`, `TRUST_GEO_HEADERS=false`:
  Railway's edge always overwrites `X-Real-IP` but passes client-supplied
  `X-Forwarded-For` and `X-Geo-*` headers through.
- `NEXT_PUBLIC_*` and `STORAGE_BASE_URL` are build arguments; redeploy `web` and
  `worker` after changing them.

Configure `SMTP_*` (or `RESEND_API_KEY`) before signing up; email verification
codes cannot be delivered otherwise.

## Notes

- The template exposes Postgres through a public TCP proxy. Remove it in the
  Postgres service's networking settings if you do not need external access.
- Railway's dependency scanner blocks builds that contain known-vulnerable
  packages; keep `next` patched.
- Back up the Postgres volume and the Storage bucket together.
