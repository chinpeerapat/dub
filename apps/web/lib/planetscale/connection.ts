import { postgres } from "../backend/postgres";
import { postgresSql } from "../backend/sql";

// Kept as a compatibility interface for callers; all queries now use PostgreSQL.
export const conn = {
  async execute<T = Record<string, any>>(sql: string, values: unknown[] = []) {
    let index = 0;
    const text = postgresSql(sql)
      .replace(/\?/g, () => `$${++index}`)
      .replace(/JSON_ARRAYAGG\(/gi, "json_agg(");
    const result = await postgres.query({ text, values });
    return {
      rows: result.rows as T[],
      rowsAffected: result.rowCount ?? 0,
      insertId: null,
    };
  },
};
