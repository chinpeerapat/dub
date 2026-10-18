import { after } from "next/server";
// Next.js owns the post-response lifecycle on a long-running Node server.
export function waitUntil(promise: Promise<unknown>) {
  after(() => promise);
}
