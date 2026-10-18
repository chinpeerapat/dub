import identifiers from "./sql-identifiers.json";

const names = new Set(identifiers);
// Quote existing Prisma identifiers without touching string literals, parameters,
// SQL keywords, or function names. Values always remain bound parameters.
export function postgresSql(sql: string): string {
  return sql.replace(
    /'(?:''|[^'])*'|"(?:""|[^"])*"|`([^`]+)`|\b[A-Za-z_][A-Za-z_0-9]*\b/g,
    (token, quoted, offset) => {
      if (quoted) return `"${quoted}"`;
      if (token.startsWith("'") || token.startsWith('"')) return token;
      const tail = sql.slice(offset + token.length);
      if (!names.has(token) && /^\s*\(/.test(tail)) return token;
      return names.has(token) || /[a-z][A-Z]|[A-Z][a-z]/.test(token)
        ? `"${token}"`
        : token;
    },
  );
}
