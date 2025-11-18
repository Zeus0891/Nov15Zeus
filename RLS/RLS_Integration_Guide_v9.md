# 🚀 BeeSmart Pro RLS Engine v9.0 - Integration Guide

**Version:** 9.0
**Phase:** Phase 1 - Internal Members Only
**Date:** November 18, 2025
**Alignment:** RBAC Generator v9.0

---

## 📋 Quick Start Guide

### Installation

1. **Apply Database Policies**

```sql
-- Run the foundation SQL script
\i rls-foundation-v9.sql

-- Verify installation
SELECT * FROM test_rls_policies();
```

2. **Install TypeScript Engine**

```typescript
import { withRLS, withRoleRLS, type SecurityContext } from "./withRLS-v9";
```

3. **Initialize Services**

```typescript
import { ServiceFactory } from "./services/rls-service-examples-v9";

const serviceFactory = new ServiceFactory(prisma);
const estimateService = serviceFactory.createEstimateService();
```

### Basic Usage

```typescript
// Standard operation (90% of use cases)
const estimates = await withRLS(
  prisma,
  { tenantId, actorId, memberId },
  async (tx) => {
    return tx.estimate.findMany({
      where: { tenantId, status: "DRAFT" },
    });
  }
);

// Role-based operation
const result = await withRoleRLS(
  prisma,
  {
    tenantId,
    actorId,
    memberId,
    role: "PROJECT_MANAGER",
    roleHierarchy: 2,
    pmPermissions: { canApproveEstimates: true },
  },
  async (tx, ctx) => {
    return tx.estimate.update({
      where: { id: estimateId },
      data: { status: "APPROVED" },
    });
  }
);
```

---

## 🏗️ Architecture Integration

### Service Layer Pattern

```typescript
export class EstimateService extends BaseRLSService {
  async listEstimates(context: SecurityContext) {
    return this.withStandardRLS(context, async (tx) => {
      return tx.estimate.findMany({
        where: { tenantId: context.tenantId },
      });
    });
  }

  async approveEstimate(context: RoleSecurityContext, id: string) {
    return withPMRLS(
      this.prisma,
      context,
      "canApproveEstimates",
      async (tx) => {
        return tx.estimate.update({
          where: { id },
          data: { status: "APPROVED", approvedAt: new Date() },
        });
      }
    );
  }
}
```

### Controller Integration

```typescript
export class EstimateController {
  async approveEstimate(req, res) {
    try {
      const context = this.createSecurityContext(req.user);
      const result = await this.estimateService.approveEstimate(
        context,
        req.params.id
      );
      res.json({ success: true, data: result });
    } catch (error) {
      res.status(403).json({
        error: error.message,
        type: error.name,
      });
    }
  }
}
```

---

## 🔒 Security Context Creation

### From JWT Token

```typescript
function createSecurityContext(jwtPayload: any): RoleSecurityContext {
  return {
    tenantId: jwtPayload.tenantId,
    actorId: jwtPayload.actorId,
    memberId: jwtPayload.memberId,
    role: jwtPayload.role,
    roleHierarchy: jwtPayload.roleHierarchy,
    sessionId: jwtPayload.sessionId,
    assignedProjects: jwtPayload.assignedProjects,
    pmPermissions: jwtPayload.pmPermissions,
  };
}
```

### Middleware Integration

```typescript
export const rlsMiddleware = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.replace("Bearer ", "");
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Create security context
    req.securityContext = createSecurityContext(decoded);

    // Validate role hierarchy
    if (!isValidRoleHierarchy(decoded.role, decoded.roleHierarchy)) {
      throw new Error("Invalid role/hierarchy combination");
    }

    next();
  } catch (error) {
    res.status(401).json({ error: "Authentication required" });
  }
};
```

---

## 🎯 Role-Based Access Patterns

### Role Hierarchy (Phase 1)

| Role                | Hierarchy | Access Pattern                                              |
| ------------------- | --------- | ----------------------------------------------------------- |
| **ADMIN**           | 0         | Full system access, bypass most restrictions                |
| **PROJECT_MANAGER** | 2         | Department-level access, PM permissions from TenantSettings |
| **WORKER**          | 8         | Own data + assigned projects/tasks                          |
| **DRIVER**          | 9         | Own routes + deliveries                                     |
| **VIEWER**          | 10        | Read-only dashboard access                                  |

### Common Access Patterns

```typescript
// 1. Own Data Only (WORKER/DRIVER)
if (ctx.roleHierarchy >= 8 && ownerId !== ctx.actorId) {
  throw new RLSSecurityError("Access denied");
}

// 2. Project Assignment Required
if (ctx.roleHierarchy >= 8 && !ctx.assignedProjects?.includes(projectId)) {
  throw new RLSSecurityError("Not assigned to project");
}

// 3. PM Permission Required
if (ctx.role === "PROJECT_MANAGER" && !ctx.pmPermissions?.canApproveEstimates) {
  throw new RLSPermissionError("PM permission not enabled");
}
```

---

## 💰 TenantSettings Integration

### PM Permission Validation

```typescript
// Service method with PM permission check
async approveEstimate(context: RoleSecurityContext, id: string) {
  return withPMRLS(
    this.prisma,
    context,
    'canApproveEstimates', // Required permission
    async (tx) => {
      // Permission validated automatically
      return tx.estimate.update({
        where: { id },
        data: { status: 'APPROVED' }
      });
    }
  );
}
```

### Dynamic Permission Loading

```typescript
async loadPMPermissions(tenantId: string, memberId: string): Promise<PMPermissions> {
  const settings = await prisma.tenantSettings.findUnique({
    where: { tenantId },
    select: {
      pmCanApproveEstimates: true,
      pmCanApproveInvoices: true,
      pmCanApproveChangeOrders: true,
      pmCanSeeProjectFinancials: true,
      pmCanDeleteOwnEstimates: true,
      pmCanDeleteOwnInvoices: true,
      pmCanDeleteOwnChangeOrders: true,
    }
  });

  return {
    canApproveEstimates: settings?.pmCanApproveEstimates ?? false,
    canApproveInvoices: settings?.pmCanApproveInvoices ?? false,
    canApproveChangeOrders: settings?.pmCanApproveChangeOrders ?? false,
    canSeeProjectFinancials: settings?.pmCanSeeProjectFinancials ?? false,
    canDeleteOwnEstimates: settings?.pmCanDeleteOwnEstimates ?? false,
    canDeleteOwnInvoices: settings?.pmCanDeleteOwnInvoices ?? false,
    canDeleteOwnChangeOrders: settings?.pmCanDeleteOwnChangeOrders ?? false,
  };
}
```

---

## 📊 Performance Optimization

### Query Optimization

```typescript
// ✅ GOOD: Use RLS functions with proper indexes
const estimates = await tx.estimate.findMany({
  where: {
    tenantId: context.tenantId, // Uses idx_estimates_tenant_security
    status: "DRAFT", // Combined in index
    createdByActorId: context.actorId, // Part of security index
  },
});

// ❌ AVOID: Complex filtering that bypasses indexes
const estimates = await tx.estimate.findMany({
  where: {
    OR: [{ status: "DRAFT" }, { status: "SUBMITTED" }],
  },
});
```

### Connection Pooling

```typescript
// Configure Prisma for optimal RLS performance
const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL,
    },
  },
  log: ["query", "info", "warn", "error"],
  // Optimize for RLS context switching
  __internal: {
    engine: {
      connectTimeout: 30000,
      pool: {
        size: 10,
        timeout: 30000,
      },
    },
  },
});
```

### Batch Operations

```typescript
// Use single transaction for multiple related operations
async createEstimateWithLineItems(context: SecurityContext, data: any) {
  return withRLS(this.prisma, context, async (tx) => {
    // Create estimate
    const estimate = await tx.estimate.create({
      data: {
        ...data.estimate,
        tenantId: context.tenantId
      }
    });

    // Create sections
    const sections = await Promise.all(
      data.sections.map(section =>
        tx.estimateSection.create({
          data: {
            ...section,
            tenantId: context.tenantId,
            estimateId: estimate.id
          }
        })
      )
    );

    // Create line items
    const lineItems = await Promise.all(
      data.lineItems.map(item =>
        tx.estimateLineItem.create({
          data: {
            ...item,
            tenantId: context.tenantId,
            estimateId: estimate.id
          }
        })
      )
    );

    return { estimate, sections, lineItems };
  });
}
```

---

## 🛡️ Error Handling

### RLS Error Types

```typescript
try {
  await estimateService.approveEstimate(context, estimateId);
} catch (error) {
  switch (error.name) {
    case "RLSValidationError":
      // Invalid input parameters
      res.status(400).json({
        error: "Invalid request parameters",
        field: error.field,
        context: error.context,
      });
      break;

    case "RLSSecurityError":
      // Access denied, insufficient privileges
      res.status(403).json({
        error: "Access denied",
        violationType: error.violationType,
        context: error.context,
      });
      break;

    case "RLSPermissionError":
      // Specific permission missing
      res.status(403).json({
        error: "Permission required",
        requiredPermission: error.requiredPermission,
        context: error.context,
      });
      break;

    default:
      // Generic error
      res.status(500).json({
        error: "Internal server error",
      });
  }
}
```

### Validation Helpers

```typescript
function validateSecurityContext(ctx: SecurityContext): void {
  if (!ctx.tenantId || !isValidUUID(ctx.tenantId)) {
    throw new RLSValidationError("Invalid tenantId", ctx, "tenantId");
  }

  if (!ctx.actorId || !isValidUUID(ctx.actorId)) {
    throw new RLSValidationError("Invalid actorId", ctx, "actorId");
  }

  if (!ctx.memberId || !isValidUUID(ctx.memberId)) {
    throw new RLSValidationError("Invalid memberId", ctx, "memberId");
  }
}
```

---

## 📋 Testing and Debugging

### Unit Testing

```typescript
describe("EstimateService RLS", () => {
  let service: EstimateService;
  let mockContext: RoleSecurityContext;

  beforeEach(() => {
    service = new EstimateService(mockPrisma);
    mockContext = {
      tenantId: "tenant-123",
      actorId: "actor-456",
      memberId: "member-789",
      role: "PROJECT_MANAGER",
      roleHierarchy: 2,
      pmPermissions: { canApproveEstimates: true },
    };
  });

  it("should allow PM to approve estimates with permission", async () => {
    const result = await service.approveEstimate(mockContext, "estimate-id");
    expect(result.status).toBe("APPROVED");
  });

  it("should deny approval without PM permission", async () => {
    mockContext.pmPermissions = { canApproveEstimates: false };

    await expect(
      service.approveEstimate(mockContext, "estimate-id")
    ).rejects.toThrow(RLSPermissionError);
  });
});
```

### Debug Utilities

```typescript
// Enable RLS debugging
process.env.RLS_DEBUG = "true";

// Get security context summary
const summary = await prisma.$queryRaw`SELECT get_security_context_summary()`;
console.log("Security Context:", summary);

// Test RLS policies
const policies = await prisma.$queryRaw`SELECT * FROM test_rls_policies()`;
console.table(policies);
```

---

## 🔄 Migration and Deployment

### Database Migration

```sql
-- migration.sql
-- Add RLS to new table
ALTER TABLE new_table ENABLE ROW LEVEL SECURITY;

CREATE POLICY new_table_tenant_isolation ON new_table
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

-- Add performance index
CREATE INDEX CONCURRENTLY idx_new_table_tenant_security
ON new_table (tenant_id, created_by_actor_id)
WHERE deleted_at IS NULL;
```

### Production Deployment

```bash
# 1. Deploy database changes
npm run migrate:deploy

# 2. Verify RLS policies
npm run rls:test

# 3. Deploy application code
npm run deploy

# 4. Validate system health
npm run health:check
```

### Zero-Downtime Updates

```typescript
// Use feature flags for gradual rollout
const useRLSv9 = await featureFlags.isEnabled("rls-v9", context.tenantId);

if (useRLSv9) {
  return withRoleRLS(prisma, context, operation);
} else {
  return withRLSv8(prisma, context, operation);
}
```

---

## 📊 Monitoring and Observability

### Performance Metrics

```typescript
// Built-in performance tracking
const result = await withRoleRLS(prisma, context, operation, {
  enableMetrics: true,
});

console.log(`Execution time: ${result.executionTime}ms`);
```

### Security Monitoring

```typescript
// Audit logging
const result = await withRoleRLS(prisma, context, operation, {
  enableAudit: true,
});

// Query audit events
const securityEvents = await prisma.accessAuditEvent.findMany({
  where: {
    tenantId: context.tenantId,
    eventType: "RLS_OPERATION",
    createdAt: { gte: yesterday },
  },
});
```

---

## 🏆 Best Practices

### Do's ✅

- **Always use RLS functions** for database operations
- **Validate security context** before operations
- **Use appropriate RLS level** (standard/role/project)
- **Handle RLS errors gracefully** with proper HTTP status codes
- **Test with different roles** and permission combinations
- **Monitor performance** and optimize queries

### Don'ts ❌

- **Don't bypass RLS** with raw queries unless absolutely necessary
- **Don't hardcode role checks** in application logic
- **Don't ignore validation errors** - they indicate security issues
- **Don't use complex OR conditions** that bypass indexes
- **Don't forget to test** permission edge cases
- **Don't expose internal error details** to clients

---

## 📚 Additional Resources

- **Security Context Guide**: Understanding JWT payload structure
- **Performance Tuning**: Database optimization for RLS
- **Testing Strategies**: Comprehensive security testing approaches
- **Deployment Guide**: Zero-downtime RLS updates
- **Troubleshooting**: Common issues and solutions

---

**Prepared by**: Senior Security Architect
**Review Date**: December 2025
**Classification**: Internal - Development Teams Only
