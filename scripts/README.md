# 🏛️ RLS Policy Generator

Automatic RLS policy generation for BeeSmart ERP multi-tenant architecture.

## 🚀 Quick Start

```bash
# Validate schemas first
npm run validate:schemas

# Generate RLS policies
npm run generate:rls

# Apply to database
psql -f prisma/migrations/rls_policies_admin_generated.sql $DATABASE_URL
```

## 📋 What It Does

### Automatic Policy Generation

- ✅ Scans all HYBRID + TENANT modules (excludes GLOBAL)
- ✅ Generates 4 policies per table (SELECT, INSERT, UPDATE, DELETE)
- ✅ Handles soft delete patterns automatically
- ✅ Uses Prisma-compatible quoted identifiers

### ADMIN Pattern Applied

```sql
-- Generated for each tenant-scoped table:
CREATE POLICY "rls_admin_select_estimate"
ON public."estimate" AS RESTRICTIVE FOR SELECT TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL  -- Only if table has soft delete
);
```

## 🔧 Configuration

### Soft Delete Tables

Automatically detected or configured in:

```typescript
const SOFT_DELETE_TABLES = [
  "estimate",
  "invoice",
  "project",
  "change_order",
  // Add more as needed
];
```

### Module Exclusions

GLOBAL modules are excluded automatically:

```typescript
const GLOBAL_MODULES = [
  "identityCore.prisma",
  "identityAuthN.prisma",
  "platformRegistry.prisma",
  "publicLinkEngine.prisma",
  "identityAuthZ.prisma",
];
```

## 📊 Output

### Generated File Structure

```sql
-- Header with metadata
-- Individual table policies (4 per table)
-- Validation queries
-- Statistics summary
```

### Statistics Example

```
✅ Generated RLS policies successfully!
📊 Statistics:
   • Total tables: 147
   • Total policies: 588
   • Soft delete tables: 23
   • Ownership tables: 45
```

## 🧪 Validation

### Pre-Generation Validation

```bash
npm run validate:schemas
```

Checks for:

- ✅ Proper `tenantId` fields
- ✅ GLOBAL vs TENANT classification
- ✅ HYBRID pattern compliance
- ✅ Naming consistency

### Post-Generation Testing

```sql
-- Test ADMIN access
SET app.current_tenant_id = 'uuid-here';
SET app.current_roles = 'ADMIN';
SELECT COUNT(*) FROM estimate;

-- Test isolation
SET app.current_roles = 'VIEWER';
SELECT COUNT(*) FROM estimate; -- Should be 0
```

## ⚡ Performance

### Optimized Policies

- Role check first (fastest)
- Indexed tenant isolation
- Minimal conditions

### Required Indexes

```sql
-- Auto-suggested in generated file
CREATE INDEX CONCURRENTLY idx_estimate_tenant_deleted
ON estimate("tenantId", "deletedAt");
```

## 🔒 Security Features

### RESTRICTIVE Policies

- All policies use `AS RESTRICTIVE`
- Maximum security by default
- Explicit permissions required

### Tenant Isolation

- Every policy validates `tenantId`
- Uses `app.current_tenant_id()` helper
- Zero cross-tenant data leakage

## 📂 File Structure

```
scripts/
├── generate-rls-policies.ts     # Main generator
├── validate-prisma-schemas.ts   # Schema validator
├── package.json                 # NPM scripts
└── README.md                   # This file

Generated Output:
prisma/migrations/
└── rls_policies_admin_generated.sql
```

## 🚨 Important Notes

### Prerequisites

1. ✅ App helpers must be created first
2. ✅ RLS must be enabled on tables
3. ✅ Proper JWT/role configuration

### Deployment

1. 🧪 Test in development first
2. 📊 Monitor query performance
3. 🔄 Backup existing policies
4. 🎯 Apply during maintenance window

### Next Steps After Generation

1. Review generated SQL file
2. Test with sample data
3. Apply to development database
4. Validate tenant isolation
5. Monitor performance metrics
6. Deploy to production
