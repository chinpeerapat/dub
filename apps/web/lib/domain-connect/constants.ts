export const DUB_CUSTOM_DOMAIN_A_RECORD =
  process.env.NEXT_PUBLIC_CUSTOM_DOMAIN_A_RECORD || "";
export const DUB_CUSTOM_DOMAIN_CNAME =
  process.env.NEXT_PUBLIC_CUSTOM_DOMAIN_CNAME ||
  process.env.NEXT_PUBLIC_SHORT_DOMAIN ||
  "go.localhost";

export const DOMAIN_CONNECT_PROVIDER_ID = "dub.co";
export const DOMAIN_CONNECT_KEY_HOST = "_dck1";
export const DEFAULT_DC_SERVICE_APEX = "links-apex";
export const DEFAULT_DC_SERVICE_SUBDOMAIN = "links-subdomain";
export const DEFAULT_DC_SERVICE_EMAIL = "email";
