// Explicit origins make the same application portable across Docker deployments.
export const APP_DOMAIN =
  process.env.NEXT_PUBLIC_APP_URL || "http://localhost:8888";
export const API_DOMAIN =
  process.env.NEXT_PUBLIC_API_URL || "http://api.localhost:8888";
export const PARTNERS_DOMAIN =
  process.env.NEXT_PUBLIC_PARTNERS_URL || "http://partners.localhost:8888";
export const ADMIN_DOMAIN =
  process.env.NEXT_PUBLIC_ADMIN_URL || "http://admin.localhost:8888";
export const SHORT_DOMAIN =
  process.env.NEXT_PUBLIC_SHORT_DOMAIN || "go.localhost";
export const API_HOSTNAMES = new Set([new URL(API_DOMAIN).host]);
export const ADMIN_HOSTNAMES = new Set([new URL(ADMIN_DOMAIN).host]);
export const PARTNERS_HOSTNAMES = new Set([new URL(PARTNERS_DOMAIN).host]);
export const isAppHostname = (hostname: string) =>
  hostname === new URL(APP_DOMAIN).host;
export const APP_DOMAIN_WITH_NGROK =
  process.env.NEXT_PUBLIC_NGROK_URL || APP_DOMAIN;
export const PARTNERS_DOMAIN_WITH_NGROK =
  process.env.NEXT_PUBLIC_NGROK_URL || PARTNERS_DOMAIN;

export const DUB_LOGO = "https://assets.dub.co/logo.png";
export const DUB_LOGO_SQUARE = "https://assets.dub.co/logo-square.png";
export const DUB_QR_LOGO = "https://assets.dub.co/logo.png";
export const DUB_WORDMARK = "https://assets.dub.co/wordmark.png";
export const DUB_THUMBNAIL = "https://assets.dub.co/thumbnail.jpg";

export const DUB_WORKSPACE_ID = "cl7pj5kq4006835rbjlt2ofka";
export const ACME_WORKSPACE_ID = "clrei1gld0002vs9mzn93p8ik";
export const ACME_PROGRAM_ID = "prog_CYCu7IMAapjkRpTnr8F1azjN";
export const DEMO_WORKSPACE_ID = "ws_1M0ZVT8Y8C8J2GXFC125KGYCQ";
export const DEMO_PROGRAM_ID = "prog_1M14W60JQ1ZQY65X6694D45W0";
export const LEGAL_WORKSPACE_ID = "clrflia0j0000vs7sqfhz9c7q";
export const LEGAL_USER_ID = "clqei1lgc0000vsnzi01pbf47";

export const R2_URL = process.env.STORAGE_BASE_URL || "https://dubassets.com";

// Network program (TODO: Update this)
export const NETWORK_WORKSPACE_ID = "ws_1KRHGNRSY2YZQZD96H5S85VX6";
export const NETWORK_PROGRAM_ID = "prog_1KRHH2Y9XZJTJDSCD7B5NXECG";
export const NETWORK_PROGRAM_SLUG = "network";
export const NETWORK_PROGRAM_DEFAULT_GROUP_ID = "grp_1KRHH2YV0GH8AN57T1S9W9CBE";
export const NETWORK_PROGRAM_DEFAULT_SALE_REWARD_ID =
  "rw_1KRHH2YVWP5TVHC30CZE5JVK7";
export const NETWORK_USER_ID = "cl7p1s07k000687rbuhpwqkqa";
