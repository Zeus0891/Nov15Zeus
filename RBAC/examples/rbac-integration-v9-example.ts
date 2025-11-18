/**
 * 🏛️ BeeSmart Pro RBAC v9.0 Integration Example
 * Demonstrates complete integration with Phase 1 internal member roles
 *
 * Features:
 * - 5 internal roles (ADMIN, PROJECT_MANAGER, WORKER, DRIVER, VIEWER)
 * - 140 explicit permissions across 18 domains
 * - TenantSettings integration for PM critical permissions
 * - Express.js middleware with comprehensive error handling
 * - Type-safe permission checking with utilities
 */

import express, { NextFunction, Request, Response } from "express";
import {
  CRITICAL_PM_PERMISSIONS,
  getRolePermissions,
  hasHigherOrEqualAuthority,
  PERMISSIONS,
  ROLE_CODES,
  ROLE_HIERARCHY,
  roleHasPermission,
  type Permission,
  type PMGatingFlags,
  type RoleCode,
} from "../generated-v9/rbac-constants";

// ============================================================================
// TYPES & INTERFACES
// ============================================================================

interface AuthenticatedUser {
  id: string;
  tenantId: string;
  email: string;
  role: RoleCode;
  actorId: string;
  memberId?: string;
}

interface AuthContext {
  user: AuthenticatedUser;
  tenantId: string;
  actorId: string;
}

interface AuthenticatedRequest extends Request {
  ctx: AuthContext;
}

interface TenantService {
  getPMGatingFlags(tenantId: string): Promise<PMGatingFlags>;
  getSetting<T>(tenantId: string, key: string): Promise<T>;
}

// ============================================================================
// TENANT SETTINGS SERVICE
// ============================================================================

class TenantSettingsService implements TenantService {
  async getPMGatingFlags(tenantId: string): Promise<PMGatingFlags> {
    // In real implementation, fetch from database
    // This is a mock showing default settings
    return {
      pmCanApproveEstimates: false,
      pmCanApproveInvoices: false,
      pmCanApproveChangeOrders: false,
      pmCanSeeProjectFinancials: false,
      pmCanDeleteOwnEstimates: false,
      pmCanDeleteOwnInvoices: false,
      pmCanDeleteOwnChangeOrders: false,
    };
  }

  async getSetting<T>(tenantId: string, key: string): Promise<T> {
    const flags = await this.getPMGatingFlags(tenantId);
    return (flags as any)[key];
  }
}

const tenantService = new TenantSettingsService();

// ============================================================================
// PERMISSION UTILITIES
// ============================================================================

/**
 * Check if a permission is critical for PROJECT_MANAGER role
 */
function isCriticalPMPermission(permission: Permission): boolean {
  return (
    CRITICAL_PM_PERMISSIONS.APPROVALS.includes(permission) ||
    CRITICAL_PM_PERMISSIONS.DELETES.includes(permission) ||
    CRITICAL_PM_PERMISSIONS.FINANCIAL_VISIBILITY.includes(permission)
  );
}

/**
 * Map permission to TenantSettings flag key
 */
function mapPermissionToSettingFlag(
  permission: Permission
): keyof PMGatingFlags | null {
  const mapping: Record<string, keyof PMGatingFlags> = {
    [PERMISSIONS.ESTIMATE.APPROVE]: "pmCanApproveEstimates",
    [PERMISSIONS.INVOICE.APPROVE]: "pmCanApproveInvoices",
    [PERMISSIONS.CHANGEORDER.APPROVE]: "pmCanApproveChangeOrders",
    [PERMISSIONS.ESTIMATE.READ_PROFIT]: "pmCanSeeProjectFinancials",
    [PERMISSIONS.INVOICE.READ_PROFIT]: "pmCanSeeProjectFinancials",
    [PERMISSIONS.PROJECT.READ_FINANCIAL]: "pmCanSeeProjectFinancials",
    [PERMISSIONS.ANALYTICS.READ_TENANT_KPIS]: "pmCanSeeProjectFinancials",
    [PERMISSIONS.ESTIMATE.DELETE_OWN]: "pmCanDeleteOwnEstimates",
    [PERMISSIONS.INVOICE.DELETE_OWN]: "pmCanDeleteOwnInvoices",
    [PERMISSIONS.CHANGEORDER.DELETE_OWN]: "pmCanDeleteOwnChangeOrders",
  };

  return mapping[permission] || null;
}

/**
 * Comprehensive permission check with TenantSettings support
 */
async function checkPermission(
  ctx: AuthContext,
  permission: Permission
): Promise<{ hasPermission: boolean; reason?: string }> {
  const { user, tenantId } = ctx;

  // Check baseline RBAC permission
  const hasBaseline = roleHasPermission(user.role, permission);

  // For non-PM roles, baseline check is sufficient
  if (user.role !== ROLE_CODES.PROJECT_MANAGER) {
    return {
      hasPermission: hasBaseline,
      reason: hasBaseline
        ? undefined
        : `Role ${user.role} does not have permission ${permission}`,
    };
  }

  // For PM role, check if permission is critical
  if (!isCriticalPMPermission(permission)) {
    // Non-critical permission - use baseline RBAC
    return {
      hasPermission: hasBaseline,
      reason: hasBaseline
        ? undefined
        : `Role PROJECT_MANAGER does not have baseline permission ${permission}`,
    };
  }

  // Critical permission - check TenantSettings
  const settingKey = mapPermissionToSettingFlag(permission);
  if (!settingKey) {
    return {
      hasPermission: false,
      reason: `Critical permission ${permission} not mapped to TenantSettings flag`,
    };
  }

  const hasElevatedPermission = await tenantService.getSetting<boolean>(
    tenantId,
    settingKey
  );
  return {
    hasPermission: hasElevatedPermission,
    reason: hasElevatedPermission
      ? undefined
      : `Critical permission ${permission} not enabled (${settingKey} = false)`,
  };
}

// ============================================================================
// RBAC MIDDLEWARE
// ============================================================================

/**
 * Middleware to require specific permission with TenantSettings support
 */
export const requirePermission = (permission: Permission) => {
  return async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const ctx = req.ctx;
      if (!ctx) {
        return res.status(401).json({
          error: "Authentication required",
          code: "AUTH_REQUIRED",
        });
      }

      const result = await checkPermission(ctx, permission);

      if (!result.hasPermission) {
        return res.status(403).json({
          error: "Insufficient permissions",
          code: "PERMISSION_DENIED",
          required: permission,
          role: ctx.user.role,
          reason: result.reason,
        });
      }

      next();
    } catch (error) {
      console.error("Permission check failed:", error);
      res.status(500).json({
        error: "Permission check failed",
        code: "PERMISSION_CHECK_ERROR",
      });
    }
  };
};

/**
 * Middleware to require minimum role hierarchy level
 */
export const requireMinimumRole = (minimumRole: RoleCode) => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    const ctx = req.ctx;
    if (!ctx) {
      return res.status(401).json({
        error: "Authentication required",
        code: "AUTH_REQUIRED",
      });
    }

    if (!hasHigherOrEqualAuthority(ctx.user.role, minimumRole)) {
      return res.status(403).json({
        error: "Insufficient role authority",
        code: "ROLE_AUTHORITY_DENIED",
        required: minimumRole,
        current: ctx.user.role,
        hierarchy: {
          required: ROLE_HIERARCHY[minimumRole],
          current: ROLE_HIERARCHY[ctx.user.role],
        },
      });
    }

    next();
  };
};

/**
 * Middleware to allow only specific roles
 */
export const requireExactRoles = (...allowedRoles: RoleCode[]) => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    const ctx = req.ctx;
    if (!ctx) {
      return res.status(401).json({
        error: "Authentication required",
        code: "AUTH_REQUIRED",
      });
    }

    if (!allowedRoles.includes(ctx.user.role)) {
      return res.status(403).json({
        error: "Role not allowed",
        code: "ROLE_NOT_ALLOWED",
        allowed: allowedRoles,
        current: ctx.user.role,
      });
    }

    next();
  };
};

// ============================================================================
// ENHANCED PERMISSION MIDDLEWARE
// ============================================================================

/**
 * Advanced middleware that supports multiple permission patterns
 */
export const requireAnyPermission = (...permissions: Permission[]) => {
  return async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const ctx = req.ctx;
      if (!ctx) {
        return res.status(401).json({
          error: "Authentication required",
          code: "AUTH_REQUIRED",
        });
      }

      // Check if user has ANY of the specified permissions
      const results = await Promise.all(
        permissions.map((permission) => checkPermission(ctx, permission))
      );

      const hasAnyPermission = results.some((result) => result.hasPermission);

      if (!hasAnyPermission) {
        return res.status(403).json({
          error:
            "Insufficient permissions - none of the required permissions available",
          code: "PERMISSION_DENIED",
          required: permissions,
          role: ctx.user.role,
          results: results.map((result, index) => ({
            permission: permissions[index],
            hasPermission: result.hasPermission,
            reason: result.reason,
          })),
        });
      }

      next();
    } catch (error) {
      console.error("Permission check failed:", error);
      res.status(500).json({
        error: "Permission check failed",
        code: "PERMISSION_CHECK_ERROR",
      });
    }
  };
};

/**
 * Middleware requiring ALL specified permissions
 */
export const requireAllPermissions = (...permissions: Permission[]) => {
  return async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const ctx = req.ctx;
      if (!ctx) {
        return res.status(401).json({
          error: "Authentication required",
          code: "AUTH_REQUIRED",
        });
      }

      // Check if user has ALL of the specified permissions
      const results = await Promise.all(
        permissions.map((permission) => checkPermission(ctx, permission))
      );

      const failedPermissions = results
        .map((result, index) => ({ permission: permissions[index], ...result }))
        .filter((result) => !result.hasPermission);

      if (failedPermissions.length > 0) {
        return res.status(403).json({
          error:
            "Insufficient permissions - not all required permissions available",
          code: "PERMISSION_DENIED",
          required: permissions,
          role: ctx.user.role,
          failed: failedPermissions.map((fp) => ({
            permission: fp.permission,
            reason: fp.reason,
          })),
        });
      }

      next();
    } catch (error) {
      console.error("Permission check failed:", error);
      res.status(500).json({
        error: "Permission check failed",
        code: "PERMISSION_CHECK_ERROR",
      });
    }
  };
};

// ============================================================================
// BUSINESS LOGIC SERVICES
// ============================================================================

/**
 * Example Estimate Service with RBAC integration
 */
class EstimateService {
  async createEstimate(ctx: AuthContext, data: any) {
    // Permission already checked by middleware
    console.log(
      `Creating estimate for tenant ${ctx.tenantId} by actor ${ctx.actorId}`
    );

    // Business logic here
    return {
      id: "est_123",
      ...data,
      createdBy: ctx.actorId,
      tenantId: ctx.tenantId,
    };
  }

  async approveEstimate(ctx: AuthContext, estimateId: string) {
    // Permission already checked by middleware (including TenantSettings for PM)
    console.log(`Approving estimate ${estimateId} for tenant ${ctx.tenantId}`);

    // Business logic here
    return {
      id: estimateId,
      status: "APPROVED",
      approvedBy: ctx.actorId,
      approvedAt: new Date(),
    };
  }

  async getEstimateProfit(ctx: AuthContext, estimateId: string) {
    // Permission already checked by middleware (critical permission for PM)
    console.log(`Getting profit data for estimate ${estimateId}`);

    // Business logic here
    return {
      estimateId,
      totalCost: 100000,
      totalRevenue: 125000,
      grossProfit: 25000,
      margin: 0.2,
    };
  }
}

const estimateService = new EstimateService();

// ============================================================================
// ROUTE DEFINITIONS
// ============================================================================

const app = express();

// Mock authentication middleware (in real app, this would validate JWT/session)
const authenticateUser = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => {
  // Mock authentication - in real app, extract from JWT/session
  req.ctx = {
    user: {
      id: "user_123",
      tenantId: "tenant_abc",
      email: "pm@company.com",
      role: ROLE_CODES.PROJECT_MANAGER,
      actorId: "actor_456",
      memberId: "member_789",
    },
    tenantId: "tenant_abc",
    actorId: "actor_456",
  };
  next();
};

// ============================================================================
// ESTIMATE ROUTES
// ============================================================================

// Create estimate - requires basic permission
app.post(
  "/estimates",
  authenticateUser,
  requirePermission(PERMISSIONS.ESTIMATE.CREATE),
  async (req: AuthenticatedRequest, res: Response) => {
    try {
      const estimate = await estimateService.createEstimate(req.ctx, req.body);
      res.json(estimate);
    } catch (error) {
      res.status(500).json({ error: "Failed to create estimate" });
    }
  }
);

// Approve estimate - requires critical permission (TenantSettings check for PM)
app.post(
  "/estimates/:id/approve",
  authenticateUser,
  requirePermission(PERMISSIONS.ESTIMATE.APPROVE),
  async (req: AuthenticatedRequest, res: Response) => {
    try {
      const estimate = await estimateService.approveEstimate(
        req.ctx,
        req.params.id
      );
      res.json(estimate);
    } catch (error) {
      res.status(500).json({ error: "Failed to approve estimate" });
    }
  }
);

// Get estimate profit - requires critical financial permission
app.get(
  "/estimates/:id/profit",
  authenticateUser,
  requirePermission(PERMISSIONS.ESTIMATE.READ_PROFIT),
  async (req: AuthenticatedRequest, res: Response) => {
    try {
      const profit = await estimateService.getEstimateProfit(
        req.ctx,
        req.params.id
      );
      res.json(profit);
    } catch (error) {
      res.status(500).json({ error: "Failed to get estimate profit" });
    }
  }
);

// ============================================================================
// PROJECT ROUTES
// ============================================================================

// Assign project manager - requires specific role hierarchy
app.post(
  "/projects/:id/assign-pm",
  authenticateUser,
  requireMinimumRole(ROLE_CODES.ADMIN), // Only ADMIN can assign PM
  async (req: AuthenticatedRequest, res: Response) => {
    res.json({ message: "Project manager assigned" });
  }
);

// Assign worker - multiple roles can do this
app.post(
  "/projects/:id/assign-worker",
  authenticateUser,
  requireAnyPermission(
    PERMISSIONS.PROJECT.ASSIGN_PM, // PM can assign
    PERMISSIONS.PROJECT.ASSIGN_WORKER // or specific assign permission
  ),
  async (req: AuthenticatedRequest, res: Response) => {
    res.json({ message: "Worker assigned" });
  }
);

// View project financials - critical permission
app.get(
  "/projects/:id/financials",
  authenticateUser,
  requirePermission(PERMISSIONS.PROJECT.READ_FINANCIAL),
  async (req: AuthenticatedRequest, res: Response) => {
    res.json({
      projectId: req.params.id,
      budget: 500000,
      actualCost: 450000,
      variance: 50000,
    });
  }
);

// ============================================================================
// ADMIN ROUTES
// ============================================================================

// Tenant management - ADMIN only
app.get(
  "/admin/tenant-settings",
  authenticateUser,
  requireExactRoles(ROLE_CODES.ADMIN),
  async (req: AuthenticatedRequest, res: Response) => {
    const settings = await tenantService.getPMGatingFlags(req.ctx.tenantId);
    res.json(settings);
  }
);

// Update PM permissions - ADMIN only with multiple required permissions
app.put(
  "/admin/pm-permissions",
  authenticateUser,
  requireExactRoles(ROLE_CODES.ADMIN),
  requireAllPermissions(
    PERMISSIONS.TENANT.MANAGE_FEATURES,
    PERMISSIONS.ACCESSCONTROL.UPDATE_TENANT_ROLES
  ),
  async (req: AuthenticatedRequest, res: Response) => {
    res.json({ message: "PM permissions updated" });
  }
);

// ============================================================================
// UTILITY ROUTES
// ============================================================================

// Get user's permissions
app.get(
  "/me/permissions",
  authenticateUser,
  async (req: AuthenticatedRequest, res: Response) => {
    const baselinePermissions = getRolePermissions(req.ctx.user.role);
    const pmFlags =
      req.ctx.user.role === ROLE_CODES.PROJECT_MANAGER
        ? await tenantService.getPMGatingFlags(req.ctx.tenantId)
        : null;

    res.json({
      role: req.ctx.user.role,
      hierarchy: ROLE_HIERARCHY[req.ctx.user.role],
      baselinePermissions: Array.from(baselinePermissions),
      criticalPermissions: pmFlags,
      totalPermissions: baselinePermissions.length,
    });
  }
);

// Validate permission
app.post(
  "/validate-permission",
  authenticateUser,
  async (req: AuthenticatedRequest, res: Response) => {
    const { permission } = req.body;

    try {
      const result = await checkPermission(req.ctx, permission);
      res.json({
        permission,
        hasPermission: result.hasPermission,
        reason: result.reason,
        role: req.ctx.user.role,
      });
    } catch (error) {
      res.status(400).json({ error: "Invalid permission" });
    }
  }
);

// ============================================================================
// ERROR HANDLING
// ============================================================================

app.use((error: Error, req: Request, res: Response, next: NextFunction) => {
  console.error("Application error:", error);
  res.status(500).json({
    error: "Internal server error",
    code: "INTERNAL_ERROR",
  });
});

// ============================================================================
// EXPORT & STARTUP
// ============================================================================

export { app, requireExactRoles, requireMinimumRole, requirePermission };

// For testing/development
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(
      `🏛️ BeeSmart Pro RBAC v9.0 Example Server running on port ${PORT}`
    );
    console.log(`\nExample endpoints:`);
    console.log(
      `POST /estimates - Create estimate (requires ${PERMISSIONS.ESTIMATE.CREATE})`
    );
    console.log(
      `POST /estimates/:id/approve - Approve estimate (requires ${PERMISSIONS.ESTIMATE.APPROVE})`
    );
    console.log(
      `GET  /estimates/:id/profit - View profit (requires ${PERMISSIONS.ESTIMATE.READ_PROFIT})`
    );
    console.log(`GET  /me/permissions - View user permissions`);
    console.log(`POST /validate-permission - Test permission validation`);
  });
}

// ============================================================================
// TESTING UTILITIES
// ============================================================================

export const testUtils = {
  /**
   * Create test context for different roles
   */
  createTestContext: (
    role: RoleCode,
    tenantId = "test_tenant"
  ): AuthContext => ({
    user: {
      id: `user_${role.toLowerCase()}`,
      tenantId,
      email: `${role.toLowerCase()}@test.com`,
      role,
      actorId: `actor_${role.toLowerCase()}`,
    },
    tenantId,
    actorId: `actor_${role.toLowerCase()}`,
  }),

  /**
   * Test permission checking for all roles
   */
  testPermissionForAllRoles: async (permission: Permission) => {
    const roles = Object.values(ROLE_CODES);
    const results: Array<{
      role: RoleCode;
      hasPermission: boolean;
      reason?: string;
    }> = [];

    for (const role of roles) {
      const ctx = testUtils.createTestContext(role);
      const result = await checkPermission(ctx, permission);
      results.push({
        role,
        hasPermission: result.hasPermission,
        reason: result.reason,
      });
    }

    return results;
  },
};

// Example usage of test utilities
if (process.env.NODE_ENV === "test") {
  // Test estimate creation permission across all roles
  testUtils
    .testPermissionForAllRoles(PERMISSIONS.ESTIMATE.CREATE)
    .then((results) => {
      console.log("Permission test results for ESTIMATE.CREATE:");
      results.forEach((result) => {
        console.log(
          `${result.role}: ${result.hasPermission ? "✅" : "❌"} ${
            result.reason || ""
          }`
        );
      });
    });
}
