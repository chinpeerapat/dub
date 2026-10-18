import { postgres } from "./postgres";
export class PostgresSearchIndex<M = Record<string, any>> {
  constructor(private namespace: string) {}
  async query<T = M>(options: {
    data?: string;
    topK: number;
    includeMetadata?: boolean;
    [key: string]: any;
  }) {
    const { rows } = await postgres.query(
      `SELECT id, metadata, ts_rank_cd(to_tsvector('simple',content),plainto_tsquery('simple',$2)) AS score FROM dub_runtime.search_document WHERE namespace=$1 AND to_tsvector('simple',content) @@ plainto_tsquery('simple',$2) ORDER BY score DESC LIMIT $3`,
      [this.namespace, options.data ?? "", options.topK],
    );
    return rows as { id: string; score: number; metadata: T }[];
  }
  async upsert(
    input:
      | { id: string; data?: string; metadata?: M }
      | { id: string; data?: string; metadata?: M }[],
  ) {
    for (const item of Array.isArray(input) ? input : [input])
      await postgres.query(
        "INSERT INTO dub_runtime.search_document(namespace,id,content,metadata) VALUES($1,$2,$3,$4::jsonb) ON CONFLICT(namespace,id) DO UPDATE SET content=excluded.content,metadata=excluded.metadata",
        [
          this.namespace,
          item.id,
          item.data ?? "",
          JSON.stringify(item.metadata ?? {}),
        ],
      );
    return "Success";
  }
}
