import { Request, Response, NextFunction } from 'express';

export interface TenantRequest extends Request {
  tenantId?: string;
}

export const tenantMiddleware = async (
  req: TenantRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    // Extract tenant from subdomain, header, or token
    const tenantDomain = req.hostname.split('.')[0]; // For subdomain-based multitenancy
    const tenantHeader = req.headers['x-tenant-id'] as string; // For header-based multitenancy
    
    // Priority: header > subdomain
    const tenantIdentifier = tenantHeader || tenantDomain;
    
    if (!tenantIdentifier) {
      res.status(400).json({ error: 'Tenant identifier is required' });
      return;
    }

    // You can add tenant validation logic here
    req.tenantId = tenantIdentifier;
    next();
  } catch (error) {
    res.status(500).json({ error: 'Error processing tenant information' });
  }
};
