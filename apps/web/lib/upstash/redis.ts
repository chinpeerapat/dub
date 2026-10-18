import { PostgresCache } from "../backend/cache";
// Existing cache consumers share PostgreSQL rather than separate Redis services.
export const redis = new PostgresCache();
export const redisGlobal = redis;
export const redisGlobalWithTimeout = redis;
