import { PostgresSearchIndex } from "../backend/search";
// Text search is local to PostgreSQL; no external embedding service is required.
export const vectorIndex = new PostgresSearchIndex("docs");
export const emojiVectorIndex = new PostgresSearchIndex<{
  emoji: string;
  label: string;
}>("emoji");
