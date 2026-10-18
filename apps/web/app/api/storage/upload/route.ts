import { verifyUpload } from "@/lib/backend/storage";
import { storage } from "@/lib/storage";
import { decideQuarantine } from "@/lib/storage/magic-bytes";

export async function PUT(req: Request) {
  let token;
  try {
    token = verifyUpload(new URL(req.url).searchParams.get("token") || "");
  } catch {
    return new Response("Invalid or expired upload URL", { status: 401 });
  }
  const type =
    req.headers.get("content-type")?.split(";")[0] ||
    "application/octet-stream";
  if (token.contentType && type !== token.contentType)
    return new Response("Content type mismatch", { status: 400 });
  const limit = Math.min(
    token.contentLength ?? 25 * 1024 * 1024,
    100 * 1024 * 1024,
  );
  const reader = req.body?.getReader();
  if (!reader) return new Response("Empty file", { status: 400 });
  const chunks: Uint8Array[] = [];
  let length = 0;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    length += value.length;
    if (length > limit) {
      await reader.cancel();
      return new Response("File exceeds upload limit", { status: 413 });
    }
    chunks.push(value);
  }
  if (token.contentLength && length !== token.contentLength)
    return new Response("Content length mismatch", { status: 400 });
  const bytes = Buffer.concat(chunks);
  const decision = decideQuarantine({
    key: token.key,
    contentType: type,
    bytes: new Uint8Array(bytes.subarray(0, 4100)),
  });
  if (decision.action === "quarantine")
    return new Response("File contents do not match the declared type", {
      status: 415,
    });
  await storage.upload({
    key: token.key,
    bucket: token.bucket,
    body: bytes,
    opts: { contentType: type },
  });
  return new Response(null, { status: 200 });
}
