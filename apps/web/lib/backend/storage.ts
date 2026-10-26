import { createHmac, timingSafeEqual } from "node:crypto";
import { assertSafeStorageKey } from "../storage/assert-safe-storage-key";
import { supabaseServiceRoleKey } from "./supabase-key";

export type UploadToken = {
  key: string;
  bucket: "public" | "private";
  expires: number;
  contentType?: string;
  contentLength?: number;
};
function secret() {
  const value = process.env.INTERNAL_JOB_SECRET;
  if (!value) throw new Error("INTERNAL_JOB_SECRET is required");
  return value;
}
export function signUpload(payload: UploadToken) {
  const value = Buffer.from(JSON.stringify(payload)).toString("base64url");
  return `${value}.${createHmac("sha256", secret()).update(value).digest("base64url")}`;
}
export function verifyUpload(token: string): UploadToken {
  const [value, signature, ...rest] = token.split(".");
  if (rest.length || !value || !signature)
    throw new Error("Invalid upload token");
  const expected = createHmac("sha256", secret())
    .update(value)
    .digest("base64url");
  if (
    signature.length !== expected.length ||
    !timingSafeEqual(Buffer.from(signature), Buffer.from(expected))
  )
    throw new Error("Invalid upload token");
  const payload = JSON.parse(
    Buffer.from(value, "base64url").toString(),
  ) as UploadToken;
  if (
    !Number.isFinite(payload.expires) ||
    payload.expires < Date.now() ||
    !["public", "private"].includes(payload.bucket)
  )
    throw new Error("Upload token expired or invalid");
  assertSafeStorageKey(payload.key);
  return payload;
}
export async function storageRequest(path: string, init: RequestInit = {}) {
  const base = process.env.SUPABASE_URL;
  const key = supabaseServiceRoleKey();
  if (!base || !key)
    throw new Error(
      "SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY (or SUPABASE_ROOT_SECRET) are required",
    );
  const headers = new Headers(init.headers);
  headers.set("authorization", `Bearer ${key}`);
  headers.set("apikey", key);
  return fetch(
    `${process.env.SUPABASE_STORAGE_URL || `${base.replace(/\/$/, "")}/storage/v1`}${path}`,
    { ...init, headers, signal: AbortSignal.timeout(30000) },
  );
}
export const objectPath = (bucket: string, key: string) =>
  `${encodeURIComponent(bucket)}/${key.split("/").map(encodeURIComponent).join("/")}`;
export class SupabaseObjectClient {
  async fetch(url: string, init: RequestInit = {}) {
    const parsed = new URL(url);
    const [bucket, ...parts] = parsed.pathname.replace(/^\//, "").split("/");
    const key = parts.join("/");
    if (init.method === "DELETE")
      return storageRequest(`/object/${bucket}`, {
        method: "DELETE",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ prefixes: [decodeURIComponent(key)] }),
      });
    return storageRequest(
      `/object/${init.method === "PUT" ? "" : "authenticated/"}${bucket}/${key}`,
      {
        ...init,
        method: init.method === "PUT" ? "POST" : init.method,
        headers: {
          ...Object.fromEntries(new Headers(init.headers)),
          "x-upsert": "true",
        },
      },
    );
  }
}
