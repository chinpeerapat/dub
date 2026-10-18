import { postgres } from "./postgres";
import { databaseQueue, durationSeconds, verifyJobRequest } from "./queue";

export class WorkflowRetryAfterError extends Error {
  constructor(
    message: string,
    public retryAfter: string,
  ) {
    super(message);
  }
}
export class Client {
  constructor(_options?: unknown) {}
  async trigger(requests: TriggerOptions[]) {
    return Promise.all(
      requests.map(async (request) => {
        const id = request.workflowRunId || crypto.randomUUID();
        await databaseQueue.publishJSON({
          ...request,
          headers: { ...request.headers, "x-dub-workflow-id": id },
          deduplicationId: `workflow:${id}`,
        });
        return { workflowRunId: id };
      }),
    );
  }
}
export type TriggerOptions = import("./queue").PublishRequest & {
  workflowRunId?: string;
};
type Context<T> = {
  requestPayload: T;
  workflowRunId: string;
  run<R>(name: string, fn: () => Promise<R>): Promise<R>;
};
export function serve<T = any>(
  handler: (context: Context<T>) => Promise<any>,
  options: {
    initialPayloadParser?: (payload: any) => T;
    failureFunction?: (args: {
      context: Context<T>;
      failStatus: number;
      failResponse: string;
      failHeaders: Record<string, string>;
    }) => Promise<any>;
  } = {},
) {
  return {
    POST: async (req: Request) => {
      const body = await req.text();
      if (!verifyJobRequest(req, body))
        return new Response("Unauthorized", { status: 401 });
      const id = req.headers.get("x-dub-workflow-id");
      if (!id) return new Response("Missing workflow id", { status: 400 });
      const context: Context<T> = {
        workflowRunId: id,
        requestPayload: options.initialPayloadParser
          ? options.initialPayloadParser(JSON.parse(body))
          : JSON.parse(body),
        async run<R>(name: string, fn: () => Promise<R>) {
          const { rows } = await postgres.query(
            "SELECT result FROM dub_runtime.workflow_step WHERE workflow_id=$1 AND name=$2",
            [id, name],
          );
          if (rows[0]) return rows[0].result.value as R;
          const result = await fn();
          await postgres.query(
            "INSERT INTO dub_runtime.workflow_step(workflow_id,name,result) VALUES($1,$2,$3::jsonb) ON CONFLICT DO NOTHING",
            [id, name, JSON.stringify({ value: result ?? null })],
          );
          return result;
        },
      };
      try {
        await handler(context);
        return Response.json({ workflowRunId: id });
      } catch (error) {
        if (req.headers.get("x-dub-final-attempt") === "true")
          await options.failureFunction?.({
            context,
            failStatus: 500,
            failResponse: String(error),
            failHeaders: {},
          });
        return new Response(String(error), {
          status: 503,
          headers:
            error instanceof WorkflowRetryAfterError
              ? { "retry-after": String(durationSeconds(error.retryAfter)) }
              : {},
        });
      }
    },
  };
}
