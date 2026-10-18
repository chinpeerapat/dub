export const configureVercelNameservers = async (_domain: string) => {
  throw new Error(
    "Configure DNS with your domain provider. Automated domain registration is unavailable in this deployment.",
  );
};
