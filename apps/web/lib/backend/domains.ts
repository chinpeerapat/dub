import { APP_DOMAIN, SHORT_DOMAIN } from "@dub/utils";
import { resolve4, resolveCname } from "node:dns/promises";

export function configuredDomains() {
  return new Set(
    [
      SHORT_DOMAIN,
      new URL(APP_DOMAIN).hostname,
      ...(process.env.CUSTOM_DOMAINS || "").split(","),
    ]
      .map((value) => value.trim().toLowerCase())
      .filter(Boolean),
  );
}
export async function domainStatus(domain: string): Promise<any> {
  const name = domain.toLowerCase();
  if (!configuredDomains().has(name))
    return {
      name,
      verified: false,
      error: {
        code: "domain_not_configured",
        message:
          "Configure this domain in CUSTOM_DOMAINS and the HTTPS proxy before adding it.",
      },
    };
  if (name.endsWith(".localhost")) return { name, verified: true };
  const cname = process.env.NEXT_PUBLIC_CUSTOM_DOMAIN_CNAME;
  const address = process.env.NEXT_PUBLIC_CUSTOM_DOMAIN_A_RECORD;
  const matches = await Promise.allSettled([
    cname
      ? resolveCname(name).then((records) =>
          records.some(
            (record) =>
              record.replace(/\.$/, "").toLowerCase() === cname.toLowerCase(),
          ),
        )
      : Promise.resolve(false),
    address
      ? resolve4(name).then((records) => records.includes(address))
      : Promise.resolve(false),
  ]);
  return {
    name,
    verified: matches.some(
      (result) => result.status === "fulfilled" && result.value,
    ),
  };
}
