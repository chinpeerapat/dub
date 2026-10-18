import { domainStatus } from "@/lib/backend/domains";
import { assertValidDomainFormat } from "./utils";
export const getVercelDomainResponse = async (domain: string) => {
  assertValidDomainFormat(domain);
  return domainStatus(domain);
};
export const getDomainResponse = getVercelDomainResponse;
