const path = require("path");
const { withPlausibleProxy } = require("next-plausible");

// Suppress specific external package warnings
const originalConsoleWarn = console.warn;
console.warn = (...args) => {
  const message = args.join(" ");
  if (
    message.includes("Package mongodb can't be external") ||
    message.includes("Package pg can't be external") ||
    message.includes("Package sqlite3 can't be external") ||
    message.includes("Package typeorm can't be external") ||
    message.includes("matches serverExternalPackages") ||
    message.includes("Try to install it into the project directory")
  ) {
    return; // Suppress these warnings
  }
  originalConsoleWarn.apply(console, args);
};

/** @type {import('next').NextConfig} */
module.exports = withPlausibleProxy({
  src: "https://plausible.io/js/pa-T9BPIqC3D0XQFZnP1vHfN.js",
  scriptPath: "/_proxy/plausible/script.js",
  apiPath: "/_proxy/plausible/event",
})({
  distDir: process.env.NEXT_DIST_DIR || ".next",
  output: "standalone",
  // Image URL validation also runs in the browser; this base URL is public.
  env: {
    STORAGE_BASE_URL:
      process.env.STORAGE_BASE_URL ||
      "http://localhost:8000/storage/v1/object/public/public",
  },
  outputFileTracingRoot: path.join(__dirname, "../.."),
  reactStrictMode: false,
  transpilePackages: ["prettier", "shiki", "@dub/email"],
  serverExternalPackages: ["@boxyhq/saml-jackson"],
  outputFileTracingIncludes: {
    "/api/auth/saml/token": [
      "./node_modules/jose/**/*",
      "./node_modules/openid-client/**/*",
    ],
  },
  experimental: {
    cpus: 2,
    webpackBuildWorker: true,
    webpackMemoryOptimizations: true,
    optimizePackageImports: [
      "@dub/email",
      "@dub/ui",
      // Disabled: causes "Module not found: chunk-WKSJXYEU.mjs" on Vercel due to tsup's chunked output
      // "@dub/utils",
      "@team-plain/typescript-sdk",
    ],
    serverActions: {
      bodySizeLimit: "4mb",
    },
  },
  webpack: (config, { webpack, isServer }) => {
    if (isServer) {
      config.plugins.push(
        // mute errors for unused typeorm deps
        new webpack.IgnorePlugin({
          resourceRegExp:
            /(^@google-cloud\/spanner|^@mongodb-js\/zstd|^aws-crt|^aws4$|^pg-native$|^mongodb-client-encryption$|^@sap\/hana-client$|^@sap\/hana-client\/extension\/Stream$|^snappy$|^react-native-sqlite-storage$|^bson-ext$|^cardinal$|^kerberos$|^hdb-pool$|^sql.js$|^sqlite3$|^better-sqlite3$|^ioredis$|^typeorm-aurora-data-api-driver$|^pg-query-stream$|^oracledb$|^mysql$|^snappy\/package\.json$|^cloudflare:sockets$)/,
        }),
      );
    }

    config.module = {
      ...config.module,
      exprContextCritical: false,
    };

    return config;
  },
  images: {
    remotePatterns: [
      ...(process.env.STORAGE_BASE_URL
        ? [
            {
              protocol: new URL(process.env.STORAGE_BASE_URL).protocol.replace(
                ":",
                "",
              ),
              hostname: new URL(process.env.STORAGE_BASE_URL).hostname,
              port: new URL(process.env.STORAGE_BASE_URL).port,
            },
          ]
        : []),
      {
        hostname: "assets.dub.co", // for Dub's static assets
      },
      {
        hostname: "dubassets.com", // for Dub's user generated images
      },
      {
        hostname: "dev.dubassets.com", // dev bucket
      },
      {
        hostname: "www.google.com",
      },
      {
        hostname: "avatar.vercel.sh",
      },
      {
        hostname: "faisalman.github.io",
      },
      {
        hostname: "api.dicebear.com",
      },
      {
        hostname: "pbs.twimg.com",
      },
      {
        hostname: "lh3.googleusercontent.com",
      },
      {
        hostname: "avatars.githubusercontent.com",
      },
      {
        hostname: "media.cleanshot.cloud", // only for staging purposes
      },
    ],
  },
  async headers() {
    return [
      {
        source: "/:path*",
        headers: [
          {
            key: "Referrer-Policy",
            value: "no-referrer-when-downgrade",
          },
          {
            key: "X-DNS-Prefetch-Control",
            value: "on",
          },
          {
            key: "X-Frame-Options",
            value: "DENY",
          },
        ],
      },
      {
        source: "/embed/:path*",
        headers: [
          {
            key: "Content-Security-Policy",
            value: "frame-ancestors *",
          },
        ],
      },
    ];
  },
  async redirects() {
    return [];
  },
  async rewrites() {
    return [
      // for dub proxy
      {
        source: "/_proxy/dub/script.js",
        destination: "https://www.dubcdn.com/analytics/script.js",
      },
      {
        source: "/_proxy/dub/track/:path*",
        destination: `${process.env.NEXT_PUBLIC_API_URL || "http://api.localhost:8888"}/track/:path*`,
      },
    ];
  },
});
