import { postgres } from "../backend/postgres";
export async function deleteTinybirdCustomerEvents({
  customerId,
}: {
  customerId: string;
}) {
  if (!customerId.startsWith("cus_")) throw new Error("Invalid customer ID");
  await postgres.query(
    "DELETE FROM dub_runtime.event WHERE source IN ('dub_lead_events','dub_sale_events') AND payload->>'customer_id'=$1",
    [customerId],
  );
}
