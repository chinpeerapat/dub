import { createHmac, randomBytes } from "node:crypto";
import { existsSync, writeFileSync } from "node:fs";
const domainIndex = process.argv.indexOf("--domain");
const domain = domainIndex >= 0 ? process.argv[domainIndex + 1] : undefined;
if (existsSync(".env.selfhost"))
  throw new Error(
    ".env.selfhost already exists; keep its secrets and edit it directly.",
  );
if (domain && !/^[a-z0-9.-]+\.[a-z]{2,}$/i.test(domain))
  throw new Error("Pass a DNS domain, e.g. --domain example.com");
const secret = () => randomBytes(32).toString("hex");
const jwtSecret = secret();
const jwt = (role) => {
  const header = Buffer.from(
    JSON.stringify({ alg: "HS256", typ: "JWT" }),
  ).toString("base64url");
  const payload = Buffer.from(
    JSON.stringify({
      role,
      iss: "supabase",
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + 10 * 365 * 86400,
    }),
  ).toString("base64url");
  return `${header}.${payload}.${createHmac("sha256", jwtSecret).update(`${header}.${payload}`).digest("base64url")}`;
};
const dbPassword = secret();
const appPassword = secret();
const app = domain ? `https://app.${domain}` : "http://localhost:8888";
const api = domain ? `https://api.${domain}` : "http://api.localhost:8888";
const storage = domain ? `https://storage.${domain}` : "http://localhost:8000";
const values = {
  POSTGRES_HOST: "db",
  POSTGRES_PORT: "5432",
  POSTGRES_DB: "postgres",
  POSTGRES_PASSWORD: dbPassword,
  DATABASE_PORT: "55432",
  DATABASE_APP_PASSWORD: appPassword,
  DATABASE_URL: `postgresql://dub_app:${appPassword}@db:5432/postgres?schema=dub`,
  ADMIN_DATABASE_URL: `postgresql://postgres:${dbPassword}@db:5432/postgres`,
  JWT_SECRET: jwtSecret,
  JWT_EXPIRY: "3600",
  ANON_KEY: jwt("anon"),
  SERVICE_ROLE_KEY: jwt("service_role"),
  SUPABASE_SERVICE_ROLE_KEY: jwt("service_role"),
  SUPABASE_URL: "http://gateway:8000",
  SUPABASE_STORAGE_URL: "http://storage:5000",
  SUPABASE_PUBLIC_URL: storage,
  STORAGE_PUBLIC_BUCKET: "public",
  STORAGE_PRIVATE_BUCKET: "private",
  STORAGE_BASE_URL: `${storage}/storage/v1/object/public/public`,
  IMGPROXY_AUTO_WEBP: "true",
  GLOBAL_S3_BUCKET: "stub",
  STORAGE_TENANT_ID: "stub",
  REGION: "local",
  S3_PROTOCOL_ACCESS_KEY_ID: secret(),
  S3_PROTOCOL_ACCESS_KEY_SECRET: secret(),
  PGRST_DB_SCHEMAS: "public,storage",
  PGRST_DB_MAX_ROWS: "1000",
  PGRST_JWT_SECRET: jwtSecret,
  NEXTAUTH_URL: app,
  NEXTAUTH_SECRET: secret(),
  ENCRYPTION_KEY: randomBytes(32).toString("base64"),
  CRON_SECRET: secret(),
  INTERNAL_JOB_SECRET: secret(),
  NEXT_PUBLIC_APP_URL: app,
  NEXT_PUBLIC_API_URL: api,
  NEXT_PUBLIC_PARTNERS_URL: domain
    ? `https://partners.${domain}`
    : "http://partners.localhost:8888",
  NEXT_PUBLIC_ADMIN_URL: domain
    ? `https://admin.${domain}`
    : "http://admin.localhost:8888",
  NEXT_PUBLIC_SHORT_DOMAIN: domain ? `go.${domain}` : "go.localhost",
  APP_HOST: domain ? `app.${domain}` : "app.localhost",
  API_HOST: domain ? `api.${domain}` : "api.localhost",
  PARTNERS_HOST: domain ? `partners.${domain}` : "partners.localhost",
  ADMIN_HOST: domain ? `admin.${domain}` : "admin.localhost",
  SHORT_HOST: domain ? `go.${domain}` : "go.localhost",
  STORAGE_HOST: domain ? `storage.${domain}` : "storage.localhost",
  CUSTOM_DOMAINS: "",
  AUTH_COOKIE_DOMAIN: domain ? `.${domain}` : "",
  TRUST_PROXY: domain ? "true" : "false",
  APP_INTERNAL_URL: "http://web:3000",
  WORKER_CONCURRENCY: "5",
  NEXT_PUBLIC_CUSTOM_DOMAIN_CNAME: domain ? `go.${domain}` : "go.localhost",
  NEXT_PUBLIC_CUSTOM_DOMAIN_A_RECORD: "",
  SMTP_HOST: "",
  SMTP_PORT: "587",
  SMTP_USER: "",
  SMTP_PASSWORD: "",
  SMTP_FROM: domain ? `Dub <noreply@${domain}>` : "Dub <noreply@localhost>",
};
writeFileSync(
  ".env.selfhost",
  Object.entries(values)
    .map(
      ([key, value]) =>
        `${key}=${value.includes(" ") ? JSON.stringify(value) : value}`,
    )
    .join("\n") + "\n",
  { mode: 0o600 },
);
console.log(
  "Created .env.selfhost with unique secrets. Configure SMTP and DNS, then follow deploy/README.md.",
);
