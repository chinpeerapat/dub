export {
  databaseQueue as qstash,
  databaseQueue as qstashWithoutBypass,
} from "../backend/queue";
export const CRON_BATCH_SIZE = 100;
export const PRISMA_UPDATEMANY_LIMIT = 250;
