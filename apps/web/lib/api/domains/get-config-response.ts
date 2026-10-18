import { domainStatus } from "@/lib/backend/domains";
import { assertValidDomainFormat } from "./utils";
export const getConfigResponse = async (domain: string) => {
  assertValidDomainFormat(domain);
  const status = await domainStatus(domain);
  return { misconfigured: !status.verified, conflicts: [], ...status };
};
