import { domainStatus } from "@/lib/backend/domains";
import { assertValidDomainFormat } from "./utils";
export const addDomainToVercel = async (
  domain: string,
  _options?: { redirectToApex?: boolean },
): Promise<any> => {
  assertValidDomainFormat(domain);
  return domainStatus(domain);
};
