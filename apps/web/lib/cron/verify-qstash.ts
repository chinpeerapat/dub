import { DubApiError } from "../api/errors";
import { verifyJobRequest } from "../backend/queue";
export const verifyQstashSignature = async ({
  req,
  rawBody,
}: {
  req: Request;
  rawBody: string;
}) => {
  if (!verifyJobRequest(req, rawBody))
    throw new DubApiError({
      code: "unauthorized",
      message: "Invalid background job signature.",
    });
};
