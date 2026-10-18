-- Application infrastructure is private to server-side database connections.
CREATE SCHEMA IF NOT EXISTS dub_runtime;
REVOKE ALL ON SCHEMA dub_runtime FROM PUBLIC;
CREATE TABLE IF NOT EXISTS dub_runtime.cache (
  key text PRIMARY KEY,
  value jsonb NOT NULL,
  expires_at timestamptz
);
CREATE INDEX IF NOT EXISTS cache_expiry ON dub_runtime.cache(expires_at) WHERE expires_at IS NOT NULL;
CREATE SEQUENCE IF NOT EXISTS dub_runtime.stream_sequence;
CREATE TABLE IF NOT EXISTS dub_runtime.event (
  source text NOT NULL,
  id text NOT NULL,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  payload jsonb NOT NULL,
  PRIMARY KEY(source,id)
);
CREATE INDEX IF NOT EXISTS event_workspace_time ON dub_runtime.event((payload->>'workspace_id'),occurred_at,source);
CREATE INDEX IF NOT EXISTS event_link_time ON dub_runtime.event((payload->>'link_id'),occurred_at,source);
CREATE INDEX IF NOT EXISTS event_customer ON dub_runtime.event((payload->>'customer_id'),source);
CREATE INDEX IF NOT EXISTS event_payload ON dub_runtime.event USING gin(payload jsonb_path_ops);
CREATE TABLE IF NOT EXISTS dub_runtime.delivery (
  id text PRIMARY KEY,
  request jsonb NOT NULL,
  available_at timestamptz NOT NULL DEFAULT now(),
  status text NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','running','completed','failed','cancelled')),
  attempts integer NOT NULL DEFAULT 0,
  max_attempts integer NOT NULL DEFAULT 6,
  dedupe_key text UNIQUE,
  queue_key text,
  parallelism integer NOT NULL DEFAULT 10,
  locked_until timestamptz,
  last_error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);
CREATE INDEX IF NOT EXISTS delivery_pending ON dub_runtime.delivery(available_at) WHERE status='pending';
CREATE INDEX IF NOT EXISTS delivery_queue ON dub_runtime.delivery(queue_key,status);
CREATE TABLE IF NOT EXISTS dub_runtime.workflow_step (
  workflow_id text NOT NULL,
  name text NOT NULL,
  result jsonb NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(workflow_id,name)
);
CREATE TABLE IF NOT EXISTS dub_runtime.search_document (
  namespace text NOT NULL,
  id text NOT NULL,
  content text NOT NULL,
  metadata jsonb NOT NULL DEFAULT '{}',
  PRIMARY KEY(namespace,id)
);
CREATE INDEX IF NOT EXISTS search_document_content ON dub_runtime.search_document USING gin(to_tsvector('simple',content));
REVOKE ALL ON ALL TABLES IN SCHEMA dub_runtime FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA dub_runtime FROM PUBLIC;
ALTER TABLE dub_runtime.delivery ADD COLUMN IF NOT EXISTS lease_token text;
-- Reserve dispatch times for provider flow-control limits across all workers.
CREATE TABLE IF NOT EXISTS dub_runtime.flow_slot (
  key text PRIMARY KEY,
  next_at timestamptz NOT NULL
);
REVOKE ALL ON dub_runtime.flow_slot FROM PUBLIC;
