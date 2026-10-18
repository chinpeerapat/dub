import type { PoolClient } from "pg";
import { transaction } from "./postgres";

type Options = {
  nx?: boolean;
  xx?: boolean;
  ex?: number;
  px?: number;
  keepTtl?: boolean;
};
type Entry = { value: any; expires_at: Date | null };
type Command = { name: string; args: any[] };
const keyList = (args: any[]) => args.flat().map(String);

export class PostgresCache {
  async execute(name: string, args: any[], client?: PoolClient): Promise<any> {
    if (!client) return transaction((tx) => this.execute(name, args, tx));
    const key = String(args[0]);
    // Locks also cover absent keys, which is essential for NX and rate limiting.
    await client.query(
      "SELECT pg_advisory_xact_lock(hashtextextended($1, 0))",
      [key],
    );
    const read = async (k = key): Promise<Entry | undefined> => {
      const { rows } = await client!.query(
        "SELECT value, expires_at FROM dub_runtime.cache WHERE key=$1 AND (expires_at IS NULL OR expires_at>now())",
        [k],
      );
      return rows[0];
    };
    const entry = await read();
    const value = entry?.value;
    const array: any[] = Array.isArray(value) ? value : [];
    const write = async (v: any, expiry = entry?.expires_at ?? null) => {
      await client!.query(
        "INSERT INTO dub_runtime.cache(key,value,expires_at) VALUES($1,$2::jsonb,$3) ON CONFLICT(key) DO UPDATE SET value=excluded.value,expires_at=excluded.expires_at",
        [key, JSON.stringify(v), expiry],
      );
    };
    switch (name.toLowerCase()) {
      case "get":
        return value ?? null;
      case "exists":
        return entry ? 1 : 0;
      case "set": {
        const opts: Options = args[2] ?? {};
        if ((opts.nx && entry) || (opts.xx && !entry)) return null;
        const ttl = opts.px ?? (opts.ex ? opts.ex * 1000 : undefined);
        await write(
          args[1],
          ttl
            ? new Date(Date.now() + ttl)
            : opts.keepTtl
              ? entry?.expires_at
              : null,
        );
        return "OK";
      }
      case "getdel":
        if (entry)
          await client.query("DELETE FROM dub_runtime.cache WHERE key=$1", [
            key,
          ]);
        return value ?? null;
      case "del": {
        const { rowCount } = await client.query(
          "DELETE FROM dub_runtime.cache WHERE key=ANY($1::text[])",
          [keyList(args)],
        );
        return rowCount ?? 0;
      }
      case "expire":
      case "pexpire": {
        if (!entry) return 0;
        await write(
          value,
          new Date(
            Date.now() + Number(args[1]) * (name === "expire" ? 1000 : 1),
          ),
        );
        return 1;
      }
      case "incr":
      case "incrby":
      case "zincrby": {
        if (name === "zincrby") {
          const map = value ?? {};
          map[args[2]] = Number(map[args[2]] ?? 0) + Number(args[1]);
          await write(map);
          return map[args[2]];
        }
        const n = Number(value ?? 0) + Number(args[1] ?? 1);
        await write(n);
        return n;
      }
      case "hget":
        return value?.[args[1]] ?? null;
      case "hgetall":
        return value ?? null;
      case "hmget":
        return Object.fromEntries(
          keyList(args.slice(1)).map((field) => [
            field,
            value?.[field] ?? null,
          ]),
        );
      case "hset":
      case "hsetnx": {
        const map = value ?? {};
        if (name === "hsetnx") {
          if (Object.hasOwn(map, args[1])) return 0;
          map[args[1]] = args[2];
          await write(map);
          return 1;
        }
        const fields = args[1];
        const added = Object.keys(fields).filter(
          (field) => !Object.hasOwn(map, field),
        ).length;
        await write({ ...map, ...fields });
        return added;
      }
      case "hdel": {
        const map = value ?? {};
        let removed = 0;
        for (const field of keyList(args.slice(1))) {
          if (Object.hasOwn(map, field)) {
            delete map[field];
            removed++;
          }
        }
        await write(map);
        return removed;
      }
      case "sadd":
      case "srem": {
        const set = new Set(value ?? []);
        const before = set.size;
        for (const item of args.slice(1).flat())
          name === "sadd" ? set.add(item) : set.delete(item);
        await write([...set]);
        return Math.abs(set.size - before);
      }
      case "sismember":
        return array.includes(args[1]) ? 1 : 0;
      case "smismember":
        return args
          .slice(1)
          .flat()
          .map((v) => (array.includes(v) ? 1 : 0));
      case "smembers":
        return value ?? [];
      case "lpush":
      case "rpush": {
        const list = value ?? [];
        const items = args.slice(1).flat();
        name === "lpush"
          ? list.unshift(...items.reverse())
          : list.push(...items);
        await write(list);
        return list.length;
      }
      case "lrange":
        return (value ?? []).slice(
          Number(args[1]),
          Number(args[2]) === -1 ? undefined : Number(args[2]) + 1,
        );
      case "lpop": {
        const list = value ?? [];
        const out =
          args[1] === undefined
            ? list.shift() ?? null
            : list.splice(0, Number(args[1]));
        await write(list);
        return out;
      }
      case "rename": {
        if (!entry) throw new Error("Cache key does not exist");
        await client.query("DELETE FROM dub_runtime.cache WHERE key=$1", [
          String(args[1]),
        ]);
        await client.query("UPDATE dub_runtime.cache SET key=$2 WHERE key=$1", [
          key,
          String(args[1]),
        ]);
        return "OK";
      }
      case "xadd": {
        const seq = await client.query(
          "SELECT nextval('dub_runtime.stream_sequence')::text AS id",
        );
        const id = `${Date.now()}-${seq.rows[0].id}`;
        await write({ ...(value ?? {}), [id]: args[2] });
        return id;
      }
      case "xrange":
      case "xrevrange": {
        const reverse = name === "xrevrange";
        const [start, end] = reverse ? [args[2], args[1]] : [args[1], args[2]];
        const order = (a: string, b: string) => {
          const [am, as] = a.split("-").map(Number);
          const [bm, bs] = b.split("-").map(Number);
          return am - bm || as - bs;
        };
        let entries = Object.entries(value ?? {})
          .filter(
            ([id]) =>
              (start === "-" || start === "0" || order(id, start) >= 0) &&
              (end === "+" || order(id, end) <= 0),
          )
          .sort(([a], [b]) => order(a, b));
        if (reverse) entries.reverse();
        const count = typeof args[3] === "object" ? args[3]?.count : args[3];
        return Object.fromEntries(entries.slice(0, count ?? entries.length));
      }
      case "xdel": {
        const stream = value ?? {};
        let count = 0;
        for (const id of keyList(args.slice(1))) {
          if (Object.hasOwn(stream, id)) {
            delete stream[id];
            count++;
          }
        }
        await write(stream);
        return count;
      }
      default:
        throw new Error(`Unsupported PostgreSQL cache operation: ${name}`);
    }
  }
  get<T = string>(key: string): Promise<T | null> {
    return this.execute("get", [key]);
  }
  set<T = unknown>(
    key: string,
    value: T,
    options?: Options,
  ): Promise<"OK" | null> {
    return this.execute("set", [key, value, options]);
  }
  mget<T = unknown[]>(...keys: any[]): Promise<T> {
    return Promise.all(keys.flat().map((key) => this.get(key))) as Promise<T>;
  }
  del(...keys: any[]): Promise<number> {
    return this.execute("del", keys);
  }
  getdel<T = string>(key: string): Promise<T | null> {
    return this.execute("getdel", [key]);
  }
  hgetall<T = Record<string, unknown>>(key: string): Promise<T | null> {
    return this.execute("hgetall", [key]);
  }
  hget<T = string>(key: string, field: string): Promise<T | null> {
    return this.execute("hget", [key, field]);
  }
  hmget<T = Record<string, unknown>>(
    key: string,
    ...fields: string[]
  ): Promise<T | null> {
    return this.execute("hmget", [key, ...fields]);
  }
  hset(key: string, fields: object): Promise<number> {
    return this.execute("hset", [key, fields]);
  }
  hsetnx(key: string, field: string, value: any): Promise<number> {
    return this.execute("hsetnx", [key, field, value]);
  }
  hdel(key: string, ...fields: string[]): Promise<number> {
    return this.execute("hdel", [key, ...fields]);
  }
  sadd(key: string, ...members: any[]): Promise<number> {
    return this.execute("sadd", [key, ...members]);
  }
  srem(key: string, ...members: any[]): Promise<number> {
    return this.execute("srem", [key, ...members]);
  }
  sismember(key: string, member: any): Promise<number> {
    return this.execute("sismember", [key, member]);
  }
  smismember(key: string, members: any[]): Promise<number[]> {
    return this.execute("smismember", [key, members]);
  }
  smembers<T = string>(key: string): Promise<T[]> {
    return this.execute("smembers", [key]);
  }
  lpush(key: string, ...items: any[]): Promise<number> {
    return this.execute("lpush", [key, ...items]);
  }
  rpush(key: string, ...items: any[]): Promise<number> {
    return this.execute("rpush", [key, ...items]);
  }
  lrange<T = string>(key: string, start: number, end: number): Promise<T[]> {
    return this.execute("lrange", [key, start, end]);
  }
  lpop<T = unknown>(key: string, count?: number): Promise<T | null> {
    return this.execute("lpop", [key, count]);
  }
  incr(key: string): Promise<number> {
    return this.execute("incr", [key]);
  }
  incrby(key: string, n: number): Promise<number> {
    return this.execute("incrby", [key, n]);
  }
  zincrby(key: string, n: number, member: string): Promise<number> {
    return this.execute("zincrby", [key, n, member]);
  }
  expire(key: string, seconds: number): Promise<number> {
    return this.execute("expire", [key, seconds]);
  }
  exists(key: string): Promise<number> {
    return this.execute("exists", [key]);
  }
  rename(key: string, to: string): Promise<string> {
    return this.execute("rename", [key, to]);
  }
  xadd(
    key: string,
    id: string,
    value: any,
    ..._options: any[]
  ): Promise<string> {
    return this.execute("xadd", [key, id, value]);
  }
  xrange<T = Record<string, any>>(
    key: string,
    start: string,
    end: string,
    count?: any,
  ): Promise<T> {
    return this.execute("xrange", [key, start, end, count]);
  }
  xrevrange<T = Record<string, any>>(
    key: string,
    start: string,
    end: string,
    count?: any,
  ): Promise<T> {
    return this.execute("xrevrange", [key, start, end, count]);
  }
  xdel(key: string, ...ids: string[]): Promise<number> {
    return this.execute("xdel", [key, ...ids]);
  }
  async scan(
    cursor: number,
    options: { match?: string; count?: number } = {},
  ): Promise<[string, string[]]> {
    const { postgres } = await import("./postgres");
    const { rows } = await postgres.query(
      "SELECT key FROM dub_runtime.cache WHERE (expires_at IS NULL OR expires_at>now()) AND key LIKE $1 ESCAPE '' ORDER BY key LIMIT $2 OFFSET $3",
      [
        (options.match ?? "*").replace(/%/g, "\\%").replace(/\*/g, "%"),
        options.count ?? 100,
        cursor,
      ],
    );
    return [
      rows.length < (options.count ?? 100) ? "0" : String(cursor + rows.length),
      rows.map((r) => r.key),
    ];
  }
  async eval(_script: string, keys: string[], args: any[]): Promise<number> {
    if (
      keys.length !== 1 ||
      args.length !== 1 ||
      !_script.includes('redis.call("del"')
    )
      throw new Error("Only compare-and-delete is supported");
    return transaction(async (client) => {
      await client.query(
        "SELECT pg_advisory_xact_lock(hashtextextended($1,0))",
        [keys[0]],
      );
      const { rowCount } = await client.query(
        "DELETE FROM dub_runtime.cache WHERE key=$1 AND value=$2::jsonb",
        [keys[0], JSON.stringify(args[0])],
      );
      return rowCount ?? 0;
    });
  }
  pipeline() {
    const commands: Command[] = [];
    const proxy: any = new Proxy(
      {},
      {
        get: (_target, name: string) =>
          name === "exec"
            ? () =>
                transaction(async (client) => {
                  const keys = [
                    ...new Set(
                      commands.flatMap((c) =>
                        c.name === "del"
                          ? keyList(c.args)
                          : [String(c.args[0])],
                      ),
                    ),
                  ].sort();
                  for (const key of keys)
                    await client.query(
                      "SELECT pg_advisory_xact_lock(hashtextextended($1,0))",
                      [key],
                    );
                  const results: any[] = [];
                  for (const c of commands)
                    results.push(await this.execute(c.name, c.args, client));
                  return results;
                })
            : (...args: any[]) => {
                commands.push({ name, args });
                return proxy;
              },
      },
    );
    return proxy;
  }
}
