// Ingress configuration is owned by the deployment; removing an app domain does
// not alter certificates or DNS belonging to other workspaces.
export const removeDomainFromVercel = async (_domain: string) => null;
