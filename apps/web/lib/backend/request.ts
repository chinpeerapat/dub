// Only trust forwarded identity headers when a trusted ingress is configured.
export function ipAddress(req: Request): string | undefined {
  if (process.env.TRUST_PROXY !== "true") return undefined;
  return req.headers.get("x-forwarded-for")?.split(",")[0].trim() || undefined;
}
export function geolocation(req: Request) {
  const trusted = process.env.TRUST_PROXY === "true";
  const header = (key: string) =>
    trusted ? req.headers.get(key) || undefined : undefined;
  return {
    country: header("x-geo-country"),
    city: header("x-geo-city"),
    countryRegion: header("x-geo-region"),
    region: header("x-geo-region"),
    continent: header("x-geo-continent"),
    latitude: header("x-geo-latitude"),
    longitude: header("x-geo-longitude"),
    postalCode: header("x-geo-postal-code"),
  };
}

// A bounded process-local fallback remains available during database outages.
import { LRUCache } from "lru-cache";
const fallbackCache = new LRUCache<string, object | string | number>({
  max: 10000,
});
export function getCache() {
  return {
    async get(key: string) {
      return fallbackCache.get(key) ?? null;
    },
    async set(key: string, value: any, options: { ttl?: number } = {}) {
      fallbackCache.set(key, value, { ttl: (options.ttl ?? 300) * 1000 });
    },
    async delete(key: string) {
      fallbackCache.delete(key);
    },
  };
}
