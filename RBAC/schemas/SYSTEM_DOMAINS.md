# 🌐 SYSTEM DOMAINS (GLOBAL)
## Authoritative Classification for BeeSmart ERP

**Date**: 2025-11-19  
**Version**: 1.0  
**Classification**: GLOBAL (No `tenantId`, System-Wide)

---

## 🎯 Definition: GLOBAL/SYSTEM Tables

Tables that:
- **NO `tenantId` field**
- **NO RLS policies**
- **Shared across ALL tenants**
- **System-level infrastructure only**

These are the **ONLY** tables that exist at the platform level.

---

## 📋 GLOBAL DOMAIN: identity_core (4 tables)

### Module: `identity.prisma`

**WHY GLOBAL**: Core identity system - Users exist before tenant membership

| Table | Purpose |
|-------|---------|
| `Actor` | System-wide actor identity (can be User or ServiceAccount) |
| `User` | System-wide user accounts (created at signup, before tenant membership) |
| `Session` | Authentication sessions (system-wide) |
| `UserApiKey` | API keys for programmatic access (system-wide) |

**IMPORTANT**: The following are **NOT global** (they are tenant-scoped):
- ❌ `UserProfile` - Tenant-specific profile data
- ❌ `UserSetting` - Tenant-specific user settings
- ❌ `UserInvitation` - Tenant-specific invitations
- ❌ `UserHistoryEvent` - Tenant-specific audit trail

---

## 🔐 GLOBAL DOMAIN: identity_security (10 tables)

### Module: `identitysecurity.prisma`

**WHY GLOBAL**: Security infrastructure shared across all tenants

| Table | Purpose |
|-------|---------|
| `IdentityProvider` | SSO providers (Google, Microsoft, Okta, etc.) - system catalog |
| `AuthFactor` | Authentication factors (system-wide MFA) |
| `AuthFactorChallenge` | MFA challenges (system-wide) |
| `PasswordResetToken` | Password reset tokens (system-wide) |
| `AccountLockout` | Account security lockouts (system-wide) |
| `SecurityEvent` | Security audit events (system-wide) |
| `SSOSession` | SSO session tracking (system-wide) |
| `RecoveryCode` | Account recovery codes (system-wide) |
| `UserDevice` | Device tracking for security (system-wide) |
| `UserDeviceHistory` | Device history audit (system-wide) |

**IMPORTANT**: The following is **tenant-scoped**:
- ❌ `TenantIdentityProvider` - Tenant-specific SSO configuration (has `tenantId`)

---

## 🛡️ GLOBAL DOMAIN: accesscontrol (2 tables)

### Module: `accesscontrol.prisma`

**WHY GLOBAL**: Permission catalog is system-wide

| Table | Purpose |
|-------|---------|
| `Permission` | System-wide permission definitions (e.g., "estimate:create", "invoice:approve") |
| `AccessResource` | System-wide resource type definitions |

**IMPORTANT**: The following are **tenant-scoped**:
- ❌ `Role` - Tenant-specific role instances
- ❌ `RolePermission` - Tenant-specific role-permission mappings
- ❌ `MemberRole` - Tenant-specific member-role assignments
- ❌ `AccessPolicy` - Tenant-specific access policies
- ❌ All other accesscontrol tables

---

## 🏢 GLOBAL DOMAIN: platform_tenant_registry (1 table)

### Module: `tenant.prisma`

**WHY GLOBAL**: Tenant catalog itself is global

| Table | Purpose |
|-------|---------|
| `Tenant` | Tenant registry - the catalog of all tenants in the system |

**IMPORTANT**: The following are **tenant-scoped**:
- ❌ `TenantSettings` - Tenant-specific settings (has `tenantId`)
- ❌ `TenantSubscription` - Tenant-specific subscription (has `tenantId`)
- ❌ `TenantUsageRecord` - Tenant-specific usage (has `tenantId`)
- ❌ All other tenant configuration tables

---

## 📊 SUMMARY

| Domain | Module | Table Count |
|--------|--------|-------------|
| `identity_core` | `identity.prisma` | 4 |
| `identity_security` | `identitysecurity.prisma` | 10 |
| `accesscontrol` | `accesscontrol.prisma` | 2 |
| `platform_tenant_registry` | `tenant.prisma` | 1 |
| **TOTAL GLOBAL TABLES** | | **17** |

---

## 🚨 Critical Principles

### 1. **GLOBAL = Absolute Minimum**
Only tables that **must** be shared across all tenants belong here.

### 2. **External Interaction ≠ Global**
Tables do NOT become global just because:
- External clients interact with them
- They have public links
- They represent external entities (CRM)
- They have `globalId` for traceability

### 3. **CustomerPortal is NOT Global**
- `CustomerPortalUser` is **tenant-scoped**
- External users access tenant data via token-based public links OR portal RBAC
- Portal RBAC is separate from internal RBAC

### 4. **CRM is NOT Global**
- `CRMAccount`, `CRMContact` represent **external parties**
- But the tables are **tenant-scoped** (have `tenantId`)
- External parties don't access these tables directly

### 5. **Public Links Are Access Mechanism, Not Security Domain**
```
Estimate (tenant table, has tenantId)
  └── EstimatePublicLink (tenant table, token-based access)
      └── External client accesses via token URL
          └── NO RBAC needed
          └── NO global access needed
          └── RLS bypass via public context
```

---

## 🔄 Identity Flow: Global → Tenant

```
GLOBAL CONTEXT:
├── User created (global, no tenant)
├── User logs in → Session (global)
└── User selects/creates Tenant

TENANT CONTEXT:
├── Member created (links User → Tenant)
├── MemberRole assigned (links Member → Role)
├── Role has Permissions (tenant-scoped)
└── All business operations use Member context
```

---

## ✅ Validation Checklist

For a table to be GLOBAL, it must satisfy **ALL** of these:

- [ ] Has **NO** `tenantId` field
- [ ] Is **NOT** tenant-specific in any way
- [ ] Is shared **identically** across all tenants
- [ ] Is **infrastructure** (identity, security, permissions, tenant registry)
- [ ] Cannot function with tenant isolation

If **ANY** answer is "No", the table is **TENANT-SCOPED**.

---

## 📝 Usage Notes

### For Database Schema:
```sql
-- GLOBAL tables (no RLS)
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email TEXT NOT NULL,
  -- NO tenantId
);

-- TENANT tables (with RLS)
CREATE TABLE estimates (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL, -- RLS enforced
  global_id UUID NOT NULL, -- For traceability, not security
  -- ...
);

CREATE POLICY estimate_isolation ON estimates
  USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```

### For RBAC Schema:
```yaml
domains:
  # GLOBAL domains (no tenant context needed)
  - key: "system"
    description: "System administration (global)"
    
  # TENANT domains (all business modules)
  - key: "estimate"
    description: "Estimate management"
    tenant_scoped: true
```

### For API Services:
```typescript
// GLOBAL context
const user = await db.users.findUnique({ where: { id } });

// TENANT context (with RLS)
const estimates = await withRLS(ctx, async (db) => {
  return db.estimates.findMany(); // Automatically filtered by tenantId
});

// PUBLIC link context (bypasses RBAC, respects resource scope)
const estimate = await getEstimateByPublicToken(token);
```

---

## 🎓 Key Architectural Insights

### 1. **BeeSmart uses 2-tier security model**:
- **GLOBAL**: System infrastructure (17 tables)
- **TENANT**: All business data (595+ tables)

### 2. **No "hybrid" classification**:
- There is no middle tier
- Either system-wide OR tenant-scoped
- Clean separation

### 3. **External access is orthogonal**:
- Public links = token-based access mechanism
- CustomerPortal = separate RBAC domain (still tenant-scoped)
- Neither changes table classification

### 4. **RLS is simple**:
```sql
-- GLOBAL: No RLS policy
-- TENANT: Single RLS policy on tenantId
```

---

**Generated**: 2025-11-19  
**Status**: ✅ AUTHORITATIVE  
**Next**: See `TENANT_DOMAINS.yml` for all business modules
