import { PrismaPg } from "@prisma/adapter-pg";
import { Prisma, PrismaClient } from "@prisma/client";
import { postgresConfig } from "../backend/postgres";
import { postgresSql } from "../backend/sql";

const createBaseClient = () =>
  new PrismaClient({
    adapter: new PrismaPg(postgresConfig, { schema: "dub" }),
    omit: {
      user: { passwordHash: true },
    },
  });

type AppPrismaClient = ReturnType<typeof createBaseClient>;
const prismaClientSingleton = (): AppPrismaClient =>
  createBaseClient().$extends({
    query: {
      $queryRaw({ args, query }) {
        if (args && "strings" in args) {
          const strings = args.strings.map(postgresSql);
          return query(
            Prisma.sql(
              Object.assign(strings, { raw: strings }),
              ...args.values,
            ),
          );
        }
        return query(args);
      },
      $executeRaw({ args, query }) {
        if (args && "strings" in args) {
          const strings = args.strings.map(postgresSql);
          return query(
            Prisma.sql(
              Object.assign(strings, { raw: strings }),
              ...args.values,
            ),
          );
        }
        return query(args);
      },
    },
  }) as unknown as AppPrismaClient;

type OmittedPrismaClient = ReturnType<typeof prismaClientSingleton>;

declare global {
  var prisma: OmittedPrismaClient | undefined;
}

export const prisma = global.prisma ?? prismaClientSingleton();

if (process.env.NODE_ENV !== "production") {
  global.prisma = prisma;
}

export const sanitizeFullTextSearch = (search: string) => {
  // remove unsupported characters for full text search
  return search.replace(/[*+\-()~@%<>!=?:]/g, "").trim();
};
