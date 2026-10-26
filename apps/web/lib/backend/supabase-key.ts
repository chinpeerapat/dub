import { createHmac } from "node:crypto";

// Railway's Supabase template (6ixfalls/supabase) derives every Supabase
// credential from one ROOT_SECRET. Deriving the same legacy HS256 service-role
// key here lets deployments reference ROOT_SECRET instead of copying a key.
// Must match secrets.Derive at derivation version supabase-secrets/v1.
const DERIVATION_VERSION = "supabase-secrets/v1";
const ISSUED_AT = 1_700_000_000;
const EXPIRES_AT = 4_102_444_800;

function hkdf(rootSecret: string, label: string, length: number) {
  const prk = createHmac("sha256", DERIVATION_VERSION)
    .update(rootSecret)
    .digest();
  let output = Buffer.alloc(0);
  let previous = Buffer.alloc(0);
  for (let counter = 1; output.length < length; counter++) {
    previous = createHmac("sha256", prk)
      .update(previous)
      .update(label)
      .update(Buffer.from([counter]))
      .digest();
    output = Buffer.concat([output, previous]);
  }
  return output.subarray(0, length);
}

export function deriveServiceRoleKey(rootSecret: string) {
  if (Buffer.byteLength(rootSecret) < 32)
    throw new Error("SUPABASE_ROOT_SECRET must contain at least 32 bytes");
  const jwtSecret = hkdf(rootSecret, "jwt-secret", 30).toString("base64");
  const header = Buffer.from('{"alg":"HS256","typ":"JWT"}').toString(
    "base64url",
  );
  const body = Buffer.from(
    JSON.stringify({
      role: "service_role",
      iss: "supabase",
      iat: ISSUED_AT,
      exp: EXPIRES_AT,
    }),
  ).toString("base64url");
  const content = `${header}.${body}`;
  return `${content}.${createHmac("sha256", jwtSecret).update(content).digest("base64url")}`;
}

let derived: { root: string; key: string } | undefined;
export function supabaseServiceRoleKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY)
    return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const root = process.env.SUPABASE_ROOT_SECRET;
  if (!root) return undefined;
  if (derived?.root !== root)
    derived = { root, key: deriveServiceRoleKey(root) };
  return derived.key;
}
