import { timingSafeEqual } from "node:crypto";
import { DubApiError } from "../api/errors";
import { verifyJobRequest } from "../backend/queue";
export const verifyVercelSignature = async (req: Request) => {
  if (req.headers.has("x-dub-job-signature") && verifyJobRequest(req, ""))
    return;
  const secret = process.env.CRON_SECRET;
  const auth = req.headers.get("authorization") || "";
  const expected = `Bearer ${secret}`;
  if (
    !secret ||
    auth.length !== expected.length ||
    !timingSafeEqual(Buffer.from(auth), Buffer.from(expected))
  )
    throw new DubApiError({
      code: "unauthorized",
      message: "Invalid cron authorization.",
    });
};
