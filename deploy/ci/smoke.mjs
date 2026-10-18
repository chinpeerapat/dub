import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";

const compose = [
  "compose",
  "-f",
  "compose.yml",
  "-f",
  "deploy/ci/compose.yml",
  "--env-file",
  ".env.selfhost",
];
function run(args) {
  execFileSync("docker", [...compose, ...args], {
    stdio: "inherit",
    timeout: 600000,
  });
}
run(["up", "-d", "--no-build", "--wait", "--wait-timeout", "300"]);
run(["exec", "-T", "db", "createdb", "-U", "postgres", "dub_test_backend"]);
const testUrl = new URL(process.env.ADMIN_DATABASE_URL);
testUrl.pathname = "/dub_test_backend";
testUrl.searchParams.set("schema", "dub");
run([
  "run",
  "--rm",
  "--no-deps",
  "-T",
  "-e",
  `DATABASE_URL=${testUrl}`,
  "migrate",
  "pnpm",
  "--filter",
  "web",
  "test:backend",
]);
run([
  "run",
  "--rm",
  "--no-deps",
  "-T",
  "migrate",
  "node",
  "deploy/ci/seed.cjs",
]);

const cookies = new Map();
const origin = "http://localhost:8888";
async function request(path, options = {}) {
  const headers = new Headers(options.headers);
  if (cookies.size)
    headers.set(
      "cookie",
      [...cookies].map(([key, value]) => `${key}=${value}`).join("; "),
    );
  const response = await fetch(new URL(path, origin), {
    ...options,
    headers,
    redirect: "manual",
    signal: AbortSignal.timeout(30000),
  });
  for (const cookie of response.headers.getSetCookie()) {
    const pair = cookie.split(";")[0];
    const separator = pair.indexOf("=");
    cookies.set(pair.slice(0, separator), pair.slice(separator + 1));
  }
  return response;
}
const health = await request("/api/health");
assert.equal(health.status, 200);
const loginPage = await request("/login");
assert.equal(loginPage.status, 200, "Login page must render");
assert.match(await loginPage.text(), /<html/);
const anonymous = await request("/api/links?workspaceId=selfhost-smoke");
assert.equal(
  anonymous.status,
  401,
  "Workspace data must require authentication",
);
const csrf = await request("/api/auth/csrf").then((response) =>
  response.json(),
);
const signedIn = await request("/api/auth/callback/credentials", {
  method: "POST",
  headers: { "content-type": "application/x-www-form-urlencoded" },
  body: new URLSearchParams({
    csrfToken: csrf.csrfToken,
    email: "selfhost-smoke@example.test",
    password: "SelfhostTest-2026!",
    callbackUrl: `${origin}/selfhost-smoke`,
    json: "true",
  }),
});
assert.equal(signedIn.status, 200, "Credentials login must succeed");
const authResult = await signedIn.json();
assert.ok(
  !authResult.url?.includes("error="),
  "Credentials login returned an error",
);
const session = await request("/api/auth/session").then((response) =>
  response.json(),
);
assert.equal(session.user?.email, "selfhost-smoke@example.test");

const created = await request("/api/links?workspaceId=selfhost-smoke", {
  method: "POST",
  headers: { "content-type": "application/json" },
  body: JSON.stringify({
    key: "docker-smoke",
    url: "https://example.com/ci",
  }),
});
assert.equal(
  created.status,
  200,
  `Create link failed: ${await created.clone().text()}`,
);
const link = await created.json();
assert.ok(link.id);
assert.equal(
  link.domain,
  "go.localhost",
  "Use the configured short domain when omitted",
);
const list = await request("/api/links?workspaceId=selfhost-smoke");
assert.equal(list.status, 200);
assert.ok((await list.json()).some((item) => item.id === link.id));
const redirect = await fetch(`${origin}/docker-smoke`, {
  headers: { host: "go.localhost" },
  redirect: "manual",
  signal: AbortSignal.timeout(30000),
});
assert.ok([301, 302, 307, 308].includes(redirect.status));
assert.equal(redirect.headers.get("location"), "https://example.com/ci");
const analytics = await request(
  "/api/analytics?workspaceId=selfhost-smoke&interval=24h&event=clicks&groupBy=count",
);
assert.equal(
  analytics.status,
  200,
  `Analytics failed: ${await analytics.clone().text()}`,
);
console.log(
  "Standalone smoke passed: login HTML, authenticated session, protected workspace, create/list link, short redirect, and analytics.",
);
