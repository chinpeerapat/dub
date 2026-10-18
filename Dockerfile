# syntax=docker/dockerfile:1.7
FROM node:24-bookworm-slim AS base
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates openssl && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@9.15.9 --activate
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED=1

FROM base AS dependencies
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,id=dub-pnpm,target=/root/.local/share/pnpm/store pnpm fetch --frozen-lockfile
COPY . .
RUN --mount=type=cache,id=dub-pnpm,target=/root/.local/share/pnpm/store pnpm install --offline --frozen-lockfile

FROM dependencies AS tools
RUN DATABASE_URL=postgresql://build:build@localhost/postgres?schema=dub pnpm --filter web exec prisma generate --schema=prisma/schema
RUN pnpm exec turbo run build --filter=web^...
RUN pnpm --filter web run build:deployment

FROM tools AS build
ENV NODE_OPTIONS=--max-old-space-size=8192
ARG NEXT_PUBLIC_APP_URL
ARG NEXT_PUBLIC_API_URL
ARG NEXT_PUBLIC_PARTNERS_URL
ARG NEXT_PUBLIC_ADMIN_URL
ARG NEXT_PUBLIC_SHORT_DOMAIN
ARG NEXT_PUBLIC_CUSTOM_DOMAIN_CNAME
ARG NEXT_PUBLIC_CUSTOM_DOMAIN_A_RECORD
ARG STORAGE_BASE_URL
ENV NEXT_PUBLIC_APP_URL=$NEXT_PUBLIC_APP_URL NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL NEXT_PUBLIC_PARTNERS_URL=$NEXT_PUBLIC_PARTNERS_URL NEXT_PUBLIC_ADMIN_URL=$NEXT_PUBLIC_ADMIN_URL NEXT_PUBLIC_SHORT_DOMAIN=$NEXT_PUBLIC_SHORT_DOMAIN NEXT_PUBLIC_CUSTOM_DOMAIN_CNAME=$NEXT_PUBLIC_CUSTOM_DOMAIN_CNAME NEXT_PUBLIC_CUSTOM_DOMAIN_A_RECORD=$NEXT_PUBLIC_CUSTOM_DOMAIN_A_RECORD STORAGE_BASE_URL=$STORAGE_BASE_URL
RUN DATABASE_URL=postgresql://build:build@localhost/postgres?schema=dub pnpm exec turbo run build --filter=web...

FROM base AS runtime
ENV NODE_ENV=production HOSTNAME=0.0.0.0 PORT=3000
COPY --from=build --chown=node:node /app/apps/web/.next/standalone ./
COPY --from=build --chown=node:node /app/apps/web/.next/static ./apps/web/.next/static
COPY --from=build --chown=node:node /app/apps/web/public ./apps/web/public
COPY --from=tools --chown=node:node /app/apps/web/.deployment ./apps/web/.deployment
USER node
EXPOSE 3000
CMD ["node", "apps/web/server.js"]
