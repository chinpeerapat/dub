export const revalidate = 3600;

// Build the image before a database exists; populate ISR pages on first request.
export async function generateStaticParams(): Promise<
  { segments: string[] }[]
> {
  return [];
}
