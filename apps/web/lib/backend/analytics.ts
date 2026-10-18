import { randomUUID } from "node:crypto";
import type { z } from "zod/v4";
import { postgres, transaction } from "./postgres";

type Params = Record<string, any>;
const dimensions: Record<string, string> = {
  continents: "continent",
  countries: "country",
  regions: "region",
  cities: "city",
  devices: "device",
  browsers: "browser",
  os: "os",
  referers: "referer",
  referer_urls: "referer_url",
  triggers: "trigger",
  trigger: "trigger",
  event_names: "event_name",
  top_base_urls: "base_url",
  top_links: "link_id",
  top_urls: "url",
  top_folders: "folder_id",
  top_domains: "domain",
  top_partners: "partner_id",
  top_groups: "partner_group_id",
  utm_sources: "utm_source",
  utm_mediums: "utm_medium",
  utm_campaigns: "utm_campaign",
  utm_terms: "utm_term",
  utm_contents: "utm_content",
};
const metadataFields = new Set([
  "folder_id",
  "partner_id",
  "partner_group_id",
  "tenant_id",
  "program_id",
  "tag_ids",
  "partner_tag_ids",
]);
const singular = (value: string) =>
  ({ clicks: "click", leads: "lead", sales: "sale" })[value] ?? value;
const datasource = (value: string) => `dub_${singular(value)}_events`;
const time = (value: any) => {
  const d = value
    ? new Date(
        /[zZ]|[+-]\d\d:\d\d$/.test(value)
          ? value
          : `${String(value).replace(" ", "T")}Z`,
      )
    : new Date();
  if (!Number.isFinite(d.getTime()))
    throw new Error("Invalid analytics timestamp");
  return d;
};

export async function ingestEvents(source: string, events: Params[]) {
  return transaction(async (client) => {
    for (const event of events) {
      const utm: Record<string, string> = {};
      try {
        const url = new URL(event.url || "");
        for (const key of [
          "utm_source",
          "utm_medium",
          "utm_campaign",
          "utm_term",
          "utm_content",
        ])
          utm[key] = url.searchParams.get(key) || "";
      } catch {}
      const payload = {
        ...event,
        utm,
        timestamp: time(
          event.timestamp ||
            (source === "dub_links_metadata" ? event.created_at : undefined),
        )
          .toISOString()
          .replace("T", " ")
          .replace("Z", ""),
      };
      const id = String(
        source === "dub_links_metadata"
          ? event.link_id
          : event.event_id || event.click_id || event.id || randomUUID(),
      );
      await client.query(
        `INSERT INTO dub_runtime.event(source,id,occurred_at,payload) VALUES($1,$2,$3,$4::jsonb)
        ON CONFLICT(source,id) DO UPDATE SET occurred_at=excluded.occurred_at,payload=excluded.payload`,
        [source, id, time(payload.timestamp), JSON.stringify(payload)],
      );
    }
    return { successful_rows: events.length, quarantined_rows: 0 };
  });
}

export async function queryEvents(pipe: string, p: Params): Promise<Params[]> {
  const values: any[] = [];
  const bind = (value: any) => {
    values.push(value);
    return `$${values.length}`;
  };
  const where: string[] = [];
  const field = (key: string) =>
    metadataFields.has(key)
      ? `COALESCE(m.payload->>'${key}','')`
      : `COALESCE(e.payload->>'${key}','')`;
  const arrayFilter = (expr: string, value: any, operator?: string) => {
    const list = Array.isArray(value) ? value : [value];
    if (!list.length) return;
    where.push(
      `${operator === "NOT IN" ? "NOT " : ""}(${expr}=ANY(${bind(list.map(String))}::text[]))`,
    );
  };
  const numeric = (key: string) =>
    `COALESCE(NULLIF(e.payload->>'${key}',''),'0')::numeric`;
  if (p.workspaceId)
    where.push(`${field("workspace_id")}=${bind(p.workspaceId)}`);
  if (p.start) where.push(`e.occurred_at>=${bind(time(p.start))}`);
  if (p.end) where.push(`e.occurred_at<=${bind(time(p.end))}`);
  for (const [param, key] of Object.entries({
    linkId: "link_id",
    linkIds: "link_id",
    domain: "domain",
    partnerId: "partner_id",
    folderId: "folder_id",
    groupId: "partner_group_id",
    tenantId: "tenant_id",
    programId: "program_id",
    customerId: "customer_id",
    customerIds: "customer_id",
    clickId: "click_id",
    eventName: "event_name",
    webhookId: "webhook_id",
    importId: "import_id",
    id: "id",
    routePattern: "route_pattern",
    method: "method",
    statusCode: "status_code",
    tokenId: "token_id",
    requestId: "request_id",
    requestType: "request_type",
    postbackId: "postback_id",
  })) {
    if (p[param] !== undefined && p[param] !== null && p[param] !== "")
      arrayFilter(field(key), p[param], p[`${param}Operator`]);
  }
  for (const [param, key] of [
    ["tagId", "tag_ids"],
    ["partnerTagId", "partner_tag_ids"],
  ]) {
    if (p[param]?.length)
      where.push(
        `${p[`${param}Operator`] === "NOT IN" ? "NOT " : ""}(COALESCE(m.payload->'${key}','[]'::jsonb) ?| ${bind(Array.isArray(p[param]) ? p[param] : [p[param]])}::text[])`,
      );
  }
  if (p.root !== undefined)
    where.push(`${field("key")} ${p.root ? "=" : "<>"} '_root'`);
  if (p.saleType) where.push(`${field("sale_type")}=${bind(p.saleType)}`);
  for (const key of [
    "country",
    "region",
    "continent",
    "city",
    "device",
    "browser",
    "os",
    "trigger",
    "referer",
  ])
    if (p[key]) arrayFilter(field(key), p[key]);
  for (const filter of typeof p.filters === "string"
    ? JSON.parse(p.filters)
    : p.filters ?? []) {
    const filterField = filter.field ?? filter.operand;
    const key =
      ({ refererUrl: "referer_url", eventName: "event_name" } as Params)[
        filterField
      ] ?? filterField;
    let expr: string;
    if (/^metadata\.[\w.]+$/.test(key))
      expr = `(CASE WHEN (e.payload->>'metadata') ~ '^\\s*\\{' THEN (e.payload->>'metadata')::jsonb ELSE '{}'::jsonb END #>> ${bind(key.slice(9).split("."))}::text[])`;
    else if (/^[a-z_]+$/.test(key))
      expr = key.startsWith("utm_")
        ? `e.payload->'utm'->>'${key}'`
        : field(key);
    else throw new Error("Unsupported analytics filter field");
    if (filter.operand) {
      const operators: Record<string, string> = {
        equals: "=",
        notEquals: "<>",
        greaterThan: ">",
        lessThan: "<",
        greaterThanOrEqual: ">=",
        lessThanOrEqual: "<=",
      };
      const operator = operators[filter.operator];
      if (!operator) throw new Error("Unsupported metadata comparison");
      const number = Number(filter.value);
      if (!["=", "<>"].includes(operator) && Number.isFinite(number))
        where.push(
          `(CASE WHEN ${expr} ~ '^-?[0-9]+([.][0-9]+)?$' THEN (${expr})::numeric END) ${operator} ${bind(number)}`,
        );
      else where.push(`${expr} ${operator} ${bind(String(filter.value))}`);
      continue;
    }
    const list = filter.values ?? [];
    if (["IN", "NOT IN", "=", "!="].includes(filter.operator))
      arrayFilter(
        expr,
        list,
        ["NOT IN", "!="].includes(filter.operator) ? "NOT IN" : "IN",
      );
    else if (
      ["LIKE", "NOT LIKE", "ILIKE", "NOT ILIKE"].includes(filter.operator)
    )
      where.push(
        `(${list.map((value: string) => `${expr} ${filter.operator} ${bind(value)}`).join(filter.operator.startsWith("NOT") ? " AND " : " OR ") || "TRUE"})`,
      );
    else
      throw new Error(
        `Unsupported analytics filter operator: ${filter.operator}`,
      );
  }
  const isAnalytics =
    /^v[234]_/.test(pipe) && !pipe.includes("customer_events");
  if (isAnalytics) {
    const eventType = p.eventType ?? "composite";
    const sources =
      pipe === "v4_usage" && p.resource === "links"
        ? ["dub_links_metadata"]
        : eventType === "composite"
          ? ["dub_click_events", "dub_lead_events", "dub_sale_events"]
          : [datasource(eventType)];
    where.push(`e.source=ANY(${bind(sources)}::text[])`);
  } else {
    const sources: Record<string, string[]> = {
      get_click_event: ["dub_click_events"],
      get_lead_event: ["dub_lead_events"],
      get_lead_events: ["dub_lead_events"],
      v2_customer_events: ["dub_lead_events", "dub_sale_events"],
      get_webhook_events: ["dub_webhook_events"],
      get_postback_events: ["dub_postback_events"],
      get_import_error_logs: ["dub_import_error_logs"],
      get_api_logs: ["dub_api_logs"],
      get_api_log_by_id: ["dub_api_logs"],
      get_api_logs_count: ["dub_api_logs"],
      get_api_logs_timeseries: ["dub_api_logs"],
      get_audit_logs: ["dub_audit_logs"],
    };
    const list = sources[pipe];
    if (!list) throw new Error(`Unknown analytics query: ${pipe}`);
    where.push(`e.source=ANY(${bind(list)}::text[])`);
  }
  // Filter against current link metadata without granting cross-workspace access.
  const from = `FROM dub_runtime.event e LEFT JOIN dub_runtime.event m ON m.source='dub_links_metadata' AND m.id=e.payload->>'link_id' WHERE ${where.join(" AND ") || "TRUE"}`;
  const measures = `count(*) FILTER(WHERE e.source='dub_click_events')::float8 AS clicks,count(*) FILTER(WHERE e.source='dub_lead_events')::float8 AS leads,count(*) FILTER(WHERE e.source='dub_sale_events')::float8 AS sales,COALESCE(sum(${numeric("amount")}) FILTER(WHERE e.source='dub_sale_events'),0)::float8 AS "saleAmount"`;
  let sql: string;
  if (pipe === "v4_count")
    sql = `SELECT 'count' AS "groupByField",${measures} ${from}`;
  else if (pipe === "v4_timeseries") {
    const granularity = ["minute", "hour", "day", "week", "month"].includes(
      p.granularity,
    )
      ? p.granularity
      : "day";
    const totals = `SELECT to_char(date_trunc(${bind(granularity)},e.occurred_at AT TIME ZONE ${bind(p.timezone || "UTC")}), 'YYYY-MM-DD HH24:MI:SS') AS "groupByField",${measures} ${from} GROUP BY 1`;
    if (p.start && p.end) {
      const start = bind(time(p.start));
      const end = bind(time(p.end));
      const zone = bind(p.timezone || "UTC");
      sql = `WITH totals AS (${totals}) SELECT to_char(bucket,'YYYY-MM-DD HH24:MI:SS') AS "groupByField",COALESCE(t.clicks,0)::float8 AS clicks,COALESCE(t.leads,0)::float8 AS leads,COALESCE(t.sales,0)::float8 AS sales,COALESCE(t."saleAmount",0)::float8 AS "saleAmount" FROM generate_series(date_trunc('${granularity}',${start}::timestamptz AT TIME ZONE ${zone}),date_trunc('${granularity}',${end}::timestamptz AT TIME ZONE ${zone}),interval '1 ${granularity}') bucket LEFT JOIN totals t ON t."groupByField"=to_char(bucket,'YYYY-MM-DD HH24:MI:SS') ORDER BY 1 LIMIT 10000`;
    } else sql = totals + " ORDER BY 1";
  } else if (
    pipe === "v4_group_by" ||
    pipe === "v4_group_by_link_metadata" ||
    pipe === "v3_group_by_link_country"
  ) {
    const group =
      p.groupBy ??
      (pipe === "v3_group_by_link_country" ? "top_links" : "countries");
    const key = dimensions[group];
    let expr = key?.startsWith("utm_")
      ? `COALESCE(e.payload->'utm'->>'${key}','')`
      : key === "base_url"
        ? `split_part(${field("url")},'?',1)`
        : key
          ? field(key)
          : "";
    if (["top_link_tags", "top_partner_tags"].includes(group))
      expr = `jsonb_array_elements_text(COALESCE(m.payload->'${group === "top_link_tags" ? "tag_ids" : "partner_tag_ids"}','[]'::jsonb))`;
    if (!expr) throw new Error(`Unsupported analytics group: ${group}`);
    const extra =
      group === "cities" || group === "regions"
        ? `,${field("country")} AS country,${field("region")} AS region`
        : pipe === "v3_group_by_link_country"
          ? `,${field("country")} AS country`
          : "";
    sql = `SELECT ${expr} AS "groupByField"${extra},${measures} ${from} GROUP BY 1${extra ? (extra.includes("AS region") ? ",2,3" : ",2") : ""} ORDER BY clicks DESC,sales DESC LIMIT ${bind(Math.min(Number(p.limit) || 100, 10000))}`;
  } else if (pipe === "v4_events" || pipe === "v2_customer_events") {
    sql = `SELECT e.payload, e.source ${from} ORDER BY e.occurred_at ${p.order === "asc" ? "ASC" : "DESC"},e.id LIMIT ${bind(Math.min(Number(p.limit) || 100, 10000))} OFFSET ${bind(Number(p.offset) || 0)}`;
  } else if (pipe === "v4_usage") {
    // Usage is based on retained events rather than billing counters.
    const granularity = ["minute", "hour", "day", "month"].includes(
      p.granularity,
    )
      ? p.granularity
      : "day";
    const group =
      p.groupBy === "folder_id" || p.groupBy === "domain"
        ? p.groupBy
        : undefined;
    sql = `SELECT to_char(date_trunc(${bind(granularity)},e.occurred_at AT TIME ZONE ${bind(p.timezone || "UTC")}), 'YYYY-MM-DD HH24:MI:SS') AS date,${group ? `${field(group)} AS ${group},` : ""}count(*)::float8 AS value ${from} GROUP BY 1${group ? ",2" : ""} ORDER BY 1`;
  } else if (pipe === "get_api_logs_count") {
    const key = (
      {
        routePattern: "route_pattern",
        method: "method",
        statusCode: "status_code",
      } as Params
    )[p.groupBy];
    sql = `SELECT ${key ? `${field(key)} AS "${p.groupBy}",` : ""}count(*)::float8 AS count ${from}${key ? " GROUP BY 1" : ""}`;
  } else if (pipe === "get_api_logs_timeseries") {
    const granularity = ["minute", "hour", "day"].includes(p.granularity)
      ? p.granularity
      : "hour";
    const bucket = `date_trunc(${bind(granularity)},e.occurred_at AT TIME ZONE ${bind(p.timezone || "UTC")})`;
    const status = numeric("status_code");
    sql = `SELECT to_char(${bucket},'YYYY-MM-DD HH24:MI:SS') AS date,to_char(${bucket}+interval '1 ${granularity}','YYYY-MM-DD HH24:MI:SS') AS "dateEnd",count(*) FILTER(WHERE ${status} BETWEEN 200 AND 299)::float8 AS "status2xx",count(*) FILTER(WHERE ${status} BETWEEN 400 AND 499)::float8 AS "status4xx",count(*) FILTER(WHERE ${status} BETWEEN 500 AND 599)::float8 AS "status5xx",count(*) FILTER(WHERE ${status}<200 OR ${status} BETWEEN 300 AND 399)::float8 AS "statusOther" ${from} GROUP BY 1,2 ORDER BY 1`;
  } else
    sql = `SELECT e.payload,e.source ${from} ORDER BY e.occurred_at DESC LIMIT ${bind(Math.min(Number(p.limit) || 1000, 10000))} OFFSET ${bind(Number(p.offset) || 0)}`;
  const { rows } = await postgres.query(sql, values);
  return rows.map((row) => {
    if (!row.payload)
      return pipe === "v3_group_by_link_country"
        ? { ...row, link_id: row.groupByField }
        : row;
    const payload = row.payload;
    const event =
      row.source === "dub_click_events"
        ? "click"
        : row.source === "dub_lead_events"
          ? "lead"
          : row.source === "dub_sale_events"
            ? "sale"
            : undefined;
    return {
      ...payload,
      ...(event ? { event } : {}),
      region_processed:
        payload.country && payload.region
          ? `${payload.country}-${payload.region}`
          : payload.region ?? null,
      referer_url_processed: payload.referer_url?.split("?")[0] ?? null,
    };
  });
}

export class PostgresAnalytics {
  buildIngestEndpoint<S extends z.ZodType>({
    datasource,
    event,
  }: {
    datasource: string;
    event: S;
    wait?: boolean;
  }) {
    return async (input: z.input<S> | z.input<S>[]) => {
      const events = (Array.isArray(input) ? input : [input]).map(
        (item) => event.parse(item) as Params,
      );
      return ingestEvents(datasource, events);
    };
  }
  buildPipe<P extends z.ZodType, D extends z.ZodType>({
    pipe,
    parameters,
    data,
  }: {
    pipe: string;
    parameters: P;
    data: D;
  }) {
    return async (
      input: z.input<P>,
      _options?: unknown,
    ): Promise<{ data: z.output<D>[]; rows: number }> => {
      const params = parameters.parse(input) as Params;
      const rows = await queryEvents(pipe, params);
      return { data: rows.map((row) => data.parse(row)), rows: rows.length };
    };
  }
}
