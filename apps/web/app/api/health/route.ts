import { postgres } from "@/lib/backend/postgres";
export const dynamic = "force-dynamic";
export async function GET() {
  try {
    await postgres.query("SELECT 1 FROM dub_runtime.cache LIMIT 1");
    return Response.json({ status: "ok" });
  } catch {
    return Response.json({ status: "unavailable" }, { status: 503 });
  }
}
