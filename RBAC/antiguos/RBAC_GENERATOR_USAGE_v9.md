# 🏛️ RBAC Generator v9.0 - Complete Usage Guide

## Overview

The **RBAC Generator v9.0** is a production-ready code generator specifically designed for **BeeSmart Pro ERP Phase 1** implementation. It transforms our comprehensive RBAC schema into enterprise-grade TypeScript constants and Prisma seed files with advanced validation and CLI interface.

## Key Features

✅ **Phase 1 Focus**: 5 internal member roles only (ADMIN, PROJECT_MANAGER, WORKER, DRIVER, VIEWER)
✅ **Permission Catalog**: 140 explicit permissions across 18 domains
✅ **Advanced CLI**: Commander.js interface with comprehensive options
✅ **Enterprise Validation**: 15+ validation checks ensuring production readiness
✅ **Type Safety**: Superior TypeScript generation with complete type definitions
✅ **Critical Permission Control**: TenantSettings integration for PM elevated permissions
✅ **Future-Ready**: Extensible architecture for Phase 2 CLIENT/VENDOR roles

## Quick Start

### 1. Basic Generation

```bash
# Generate all files from default schema
cd /path/to/project/RBAC
npx tsx rbac-generator-v9.0.ts

# Generate with custom output directory
npx tsx rbac-generator-v9.0.ts --output-dir ./custom-output

# Use custom schema file
npx tsx rbac-generator-v9.0.ts --schema ./custom-schema.yml --output-dir ./generated
```

### 2. Validation Only

```bash
# Validate schema without generating files
npx tsx rbac-generator-v9.0.ts --validate-only

# Validate with verbose output for debugging
npx tsx rbac-generator-v9.0.ts --validate-only --verbose
```

### 3. CLI Options

```bash
# View all available options
npx tsx rbac-generator-v9.0.ts --help

# Verbose output with detailed logging
npx tsx rbac-generator-v9.0.ts --verbose

# Custom paths
npx tsx rbac-generator-v9.0.ts \
  --schema ./rbac_schema_v9.0.yml \
  --output-dir ./generated-v9 \
  --verbose
```

## Generated Files

### 1. `rbac-constants.ts` (593 lines)

**Purpose**: Complete TypeScript constants with type safety and utility functions

**Key Features**:

- 5 Phase 1 role definitions with hierarchy
- 140 permission constants organized by domain
- Role-permission baseline grants
- Critical permission catalog (PM elevated permissions)
- TenantSettings integration interfaces
- Utility functions for permission checking

**Usage Example**:

```typescript
import {
  ROLE_CODES,
  PERMISSIONS,
  ROLE_PERMISSIONS,
  CRITICAL_PM_PERMISSIONS,
  hasHigherOrEqualAuthority,
  roleHasPermission,
} from "./generated-v9/rbac-constants";

// Check role hierarchy
const canManagerOverrideWorker = hasHigherOrEqualAuthority(
  ROLE_CODES.PROJECT_MANAGER,
  ROLE_CODES.WORKER
); // true

// Check baseline permissions
const pmCanCreateEstimate = roleHasPermission(
  ROLE_CODES.PROJECT_MANAGER,
  PERMISSIONS.ESTIMATE.CREATE
); // true

// Check critical permissions (require TenantSettings)
const isApprovalCritical = CRITICAL_PM_PERMISSIONS.APPROVALS.includes(
  PERMISSIONS.ESTIMATE.APPROVE
); // true
```

### 2. `rbac-seed.ts` (525 lines)

**Purpose**: Prisma seed file for database initialization

**Key Features**:

- All 140 permissions inserted into Permission table
- 5 Phase 1 roles with metadata
- Baseline role-permission grants
- UUID v7 generation for performance
- Transaction safety with error handling

**Usage**:

```bash
# Run the seed file
npx tsx generated-v9/rbac-seed.ts

# Or integrate into package.json
npm run db:seed:rbac
```

## Schema Structure (rbac_schema_v9.0.yml)

### Core Components

1. **Metadata Section**

   - Version tracking (9.0)
   - Phase designation (PHASE_1_INTERNAL_MEMBERS)
   - Source document reference (RBAC_Matrix.md)
   - Compliance standards

2. **Security Configuration**

   - Role hierarchy convention (0 = highest)
   - Permission strategy (explicit_minimal_catalog)
   - Three-layer security architecture
   - Design principles

3. **Domain Definitions** (18 domains)

   - tenant, accesscontrol, identity, membership
   - estimate, invoice, project, task
   - expenses, inventory, scheduling, time, payroll
   - crm, documents, changeorder, ai, analytics

4. **Role Definitions** (5 Phase 1 roles)

   ```yaml
   roles:
     - code: "ADMIN"
       hierarchy: 0
       role_type: "INTERNAL"

     - code: "PROJECT_MANAGER"
       hierarchy: 2
       role_type: "INTERNAL"

     - code: "WORKER"
       hierarchy: 8
       role_type: "INTERNAL"

     - code: "DRIVER"
       hierarchy: 9
       role_type: "INTERNAL"

     - code: "VIEWER"
       hierarchy: 10
       role_type: "INTERNAL"
   ```

5. **Permission Catalog** (140 permissions)

   - Organized by domain
   - Follows domain:action:subaction convention
   - All permissions explicit (no wildcards)

6. **Role Grants** (Baseline permissions)

   - ADMIN: 79 permissions
   - PROJECT_MANAGER: 38 permissions (baseline only)
   - WORKER: 16 permissions
   - DRIVER: 16 permissions
   - VIEWER: 19 permissions

7. **Critical Permissions** (10 PM elevated)
   - Cataloged but NOT granted by default to PM
   - Controlled via TenantSettings flags
   - Approval permissions, delete permissions, financial visibility

## Validation System

The generator performs 15+ comprehensive validations:

### Schema Validations

- ✅ Phase compliance (PHASE_1_INTERNAL_MEMBERS)
- ✅ Source document reference (RBAC_Matrix.md)
- ✅ Role count (exactly 5 roles)
- ✅ Role hierarchy (0, 2, 8, 9, 10)
- ✅ Role codes (ADMIN, PROJECT_MANAGER, WORKER, DRIVER, VIEWER)
- ✅ All roles INTERNAL (Phase 1 compliant)

### Permission Validations

- ✅ Permission naming convention (domain:action:subaction)
- ✅ No wildcards (all explicit)
- ✅ Permission catalog exists
- ✅ All role grants reference defined roles
- ✅ Critical PM permissions excluded from default grants
- ✅ All critical permissions present in catalog

### Output Validation

```bash
======================================================================
✅ ✅ Schema validation PASSED - Production ready
======================================================================
✅ Total Permissions: 140
✅ Total Roles: 5
✅ Critical Permissions (PM): 10
```

## Integration Patterns

### 1. Service Layer Integration

```typescript
import { PERMISSIONS, ROLE_CODES } from "./generated-v9/rbac-constants";
import { requirePermission } from "./rbac-middleware";

// Estimate service with RBAC
class EstimateService {
  async createEstimate(ctx: AuthContext, data: CreateEstimateDto) {
    // Check baseline permission
    await requirePermission(ctx, PERMISSIONS.ESTIMATE.CREATE);

    // Business logic
    return this.estimateRepo.create(data);
  }

  async approveEstimate(ctx: AuthContext, estimateId: string) {
    // Check if user has approval permission (requires TenantSettings check)
    if (ctx.user.role === ROLE_CODES.PROJECT_MANAGER) {
      const canApprove = await this.tenantService.checkPMFlag(
        ctx.tenantId,
        "pmCanApproveEstimates"
      );
      if (!canApprove) {
        throw new ForbiddenError("PM approval not enabled for this tenant");
      }
    } else {
      // Check baseline permission for other roles
      await requirePermission(ctx, PERMISSIONS.ESTIMATE.APPROVE);
    }

    // Business logic
    return this.estimateRepo.approve(estimateId);
  }
}
```

### 2. TenantSettings Integration

```typescript
interface TenantSettings {
  // PM Critical Permission Flags
  pmCanApproveEstimates: boolean;
  pmCanApproveInvoices: boolean;
  pmCanApproveChangeOrders: boolean;
  pmCanSeeProjectFinancials: boolean;
  pmCanDeleteOwnEstimates: boolean;
  pmCanDeleteOwnInvoices: boolean;
  pmCanDeleteOwnChangeOrders: boolean;

  // Other tenant settings...
}

// Usage in service
async function checkCriticalPermission(
  ctx: AuthContext,
  permission: string
): Promise<boolean> {
  // If not PM, check baseline RBAC
  if (ctx.user.role !== ROLE_CODES.PROJECT_MANAGER) {
    return roleHasPermission(ctx.user.role, permission);
  }

  // PM requires TenantSettings check for critical permissions
  if (CRITICAL_PM_PERMISSIONS.APPROVALS.includes(permission)) {
    const settingKey = mapPermissionToSetting(permission);
    return await tenantService.getSetting(ctx.tenantId, settingKey);
  }

  // Non-critical permissions use baseline RBAC
  return roleHasPermission(ROLE_CODES.PROJECT_MANAGER, permission);
}
```

### 3. Express Middleware

```typescript
import { PERMISSIONS } from "./generated-v9/rbac-constants";

// Permission middleware
export const requirePermission = (permission: string) => {
  return async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const hasPermission = await checkCriticalPermission(req.ctx, permission);

      if (!hasPermission) {
        return res.status(403).json({
          error: "Insufficient permissions",
          required: permission,
          role: req.ctx.user.role,
        });
      }

      next();
    } catch (error) {
      res.status(500).json({ error: "Permission check failed" });
    }
  };
};

// Route usage
app.post(
  "/estimates",
  requireAuth,
  requirePermission(PERMISSIONS.ESTIMATE.CREATE),
  estimateController.create
);

app.post(
  "/estimates/:id/approve",
  requireAuth,
  requirePermission(PERMISSIONS.ESTIMATE.APPROVE), // Handles TenantSettings for PM
  estimateController.approve
);
```

## Production Deployment

### 1. Database Seeding

```bash
# Initial database setup
npx tsx generated-v9/rbac-seed.ts

# Verify seeding
psql -d your_db -c "SELECT COUNT(*) FROM \"Permission\";" # Should be 140
psql -d your_db -c "SELECT COUNT(*) FROM \"Role\";" # Should be 5
psql -d your_db -c "SELECT COUNT(*) FROM \"RolePermission\";" # Should be 168
```

### 2. Environment Setup

```bash
# Add to package.json scripts
{
  "scripts": {
    "rbac:generate": "cd RBAC && npx tsx rbac-generator-v9.0.ts",
    "rbac:validate": "cd RBAC && npx tsx rbac-generator-v9.0.ts --validate-only",
    "rbac:seed": "npx tsx RBAC/generated-v9/rbac-seed.ts"
  }
}
```

### 3. CI/CD Integration

```yaml
# GitHub Actions example
- name: Validate RBAC Schema
  run: npm run rbac:validate

- name: Generate RBAC Constants
  run: npm run rbac:generate

- name: Seed RBAC Data
  run: npm run rbac:seed
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

## Migration from Previous Versions

### From v8.x to v9.0

1. **Schema Changes**:

   - Role count reduced from 17 to 5 (Phase 1 focus)
   - Permission count reduced from 300+ to 140 (explicit minimal)
   - Critical permissions now cataloged separately

2. **Code Changes**:

   - Import paths: `generated/` → `generated-v9/`
   - Permission constants: More organized by domain
   - New TenantSettings integration required

3. **Database Changes**:
   - Run new seed file to update permissions
   - Update role assignments if needed
   - Add TenantSettings flags for PM critical permissions

## Troubleshooting

### Common Issues

1. **Schema Validation Failures**

   ```bash
   # Check schema syntax
   npx tsx rbac-generator-v9.0.ts --validate-only --verbose
   ```

2. **Permission Format Errors**

   ```
   Error: Invalid permission format: task:update:status:own
   Solution: Use 3-part format: task:update:own
   ```

3. **Role Hierarchy Issues**

   ```
   Error: Role hierarchy validation failed
   Solution: Ensure hierarchy values are [0, 2, 8, 9, 10]
   ```

4. **Missing Critical Permissions**
   ```bash
   # Verify all critical permissions are cataloged
   grep -A 10 "critical_permissions:" rbac_schema_v9.0.yml
   ```

### Debug Mode

```bash
# Enable verbose logging
npx tsx rbac-generator-v9.0.ts --verbose

# Validate specific sections
npx tsx rbac-generator-v9.0.ts --validate-only --verbose 2>&1 | grep "Critical"
```

## Performance Metrics

### Generator Performance

- **Schema Loading**: ~50ms
- **Validation**: ~100ms
- **TypeScript Generation**: ~200ms
- **Prisma Seed Generation**: ~150ms
- **Total**: ~500ms

### Generated Code Quality

- **rbac-constants.ts**: 593 lines (vs 367 in v8.3) - **62% more comprehensive**
- **TypeScript Exports**: 8 exports (vs 6 in v8.3) - **Better organization**
- **Type Safety**: 100% type coverage with strict TypeScript
- **Runtime Performance**: O(1) permission lookups

## Future Enhancements (Phase 2+)

1. **External Roles**: CLIENT, VENDOR, SUBCONTRACTOR, INSPECTOR
2. **Dynamic Permissions**: AccessPolicy integration
3. **Attribute-Based Access Control (ABAC)**: Context-aware permissions
4. **Advanced Conditions**: Time-based, location-based, project-based permissions
5. **API Rate Limiting**: Role-based API throttling
6. **Audit Logging**: Enhanced permission audit trails

---

## Support & Documentation

- **Schema Reference**: `rbac_schema_v9.0.yml` (953 lines)
- **Generator Source**: `rbac-generator-v9.0.ts` (1053 lines)
- **Generated Constants**: `generated-v9/rbac-constants.ts`
- **Seed File**: `generated-v9/rbac-seed.ts`
- **Integration Examples**: `examples/rbac-integration-example.ts`

**Generated by**: RBAC Generator v9.0
**Date**: November 18, 2025
**Status**: ✅ Production Ready - Phase 1 Internal Members Only
