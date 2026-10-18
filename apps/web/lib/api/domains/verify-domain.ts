import { domainStatus } from "@/lib/backend/domains";
import { assertValidDomainFormat } from "./utils";
export const verifyDomain = async (domain: string) => {
  assertValidDomainFormat(domain);
  return domainStatus(domain);
};
export const verifyDomainWithRetry = async (
  domain: string,
  _options?: { attempts?: number; delayMs?: number },
) => verifyDomain(domain);
