# Tenant_Module.md

**Module:** `tenant.prisma`
**Version:** v9.0
**Phase:** Phase 1 – Internal Members Only
**Status:** ✅ **ALIGNED** with RBAC v9.0 + RLS v9.0
**Last Updated:** November 18, 2025
**Aligned with:**

- **RBAC v9.0**: 5 roles, 156 permissions, 7 TenantSettings PM flags
- **RLS v9.0**: `withRLS-v9.ts` engine with specialized wrappers
- **Identity / IdentitySecurity**: Universal Actor Pattern integration
- **Membership**: Member-to-tenant relationship and role assignments
- **AccessControl**: Complete RBAC v9.0 integration and audit logging
- **All Business Modules**: Tenant isolation via tenantId + RLS policies
  - Core: Estimate, Invoice, Project (1:1:1 globalId traceability)
  - Operations: CRM, Inventory, Expenses, Scheduling, Payroll
  - Intelligence: AI, Analytics, Documents
  - Governance: Approvals, Contracts, Compliance

---

## 1. Purpose & Scope

The **Tenant module** is the **control plane** of the ERP Enterprise Platform. It defines:

- Which organizations exist as **tenants** in the system.
- How those tenants are **isolated** and **identified**.
- What **modules, feature flags, and subscription plans** are enabled per tenant.
- How each tenant is **branded**, **routed** (domains), and **governed** for compliance.
- A complete **audit trail** of tenant-level changes.

It is the root of the multi-tenant model: every tenant-scoped record in other modules (Estimate, Invoice, Project, CRM, Inventory, etc.) ultimately hangs off a single `Tenant.id`. :contentReference[oaicite:1]{index=1}

---

## 2. High-Level Architecture

### 2.1 Tenant in the Platform Stack

Conceptually, the platform stack is:

- **Layer 1 – Identity & Membership & Tenant**
  - `User` → `Actor` (global identity) → `Member` (actor in a tenant) → `Tenant`.
- **Layer 2 – AccessControl / RBAC v9.0**
  - Global `Role`, `Permission`, `RolePermission`; per-tenant `MemberRole`.
- **Layer 3 – RLS v9.0**
  - PostgreSQL Row Level Security; `withRLS-v9` sets `current_tenant_id` / `current_actor_id`.
- **Layer 4 – Business Modules**
  - `estimate.prisma`, `invoice.prisma`, `projectsCore.prisma`, `crmcore.prisma`, `inventoryCore.prisma`, `expensecore.prisma`, `schedulingCore.prisma`, `payroll.prisma`, etc. :contentReference[oaicite:2]{index=2}

All business tables that belong to a customer organization have a `tenantId` foreign key to `Tenant.id`. RLS policies and RBAC permissions operate **per tenant**.

### 2.2 Module Composition (`tenant.prisma`)

The Tenant module consists of the following models: :contentReference[oaicite:3]{index=3}

- `Tenant`
- `TenantSettings`
- `TenantSubscription`
- `TenantUsageRecord`
- `TenantDomain`
- `TenantBranding`
- `TenantModule`
- `TenantFeatureFlag`
- `TenantComplianceSetting`
- `TenantHistoryEvent`

---

## 3. Data Model Overview

At a high level:

- **Tenant** is the master record of an organization.
- **TenantSettings** stores behavioral and critical configuration per tenant.
- **TenantSubscription** and **TenantUsageRecord** control licensing and billing.
- **TenantDomain** and **TenantBranding** control routing and theming.
- **TenantModule** and **TenantFeatureFlag** govern what functionality is available per tenant.
- **TenantComplianceSetting** controls regulatory and retention policies.
- **TenantHistoryEvent** provides an immutable audit trail of tenant-level changes.

All these tables are **tenant control-plane** and are accessed almost exclusively by tenant **ADMIN** users (and internal ops tools).

---

## 4. Model-by-Model Design

### 4.1 `Tenant`

**Responsibility**

`Tenant` is the **root organizational entity** in the system. Every tenant-scoped row anywhere in the ERP references `Tenant.id`.

**Key responsibilities**

- Represent a customer organization (construction company, professional service provider, etc.).
- Track lifecycle:
  - `status`: `trial`, `active`, `suspended`, `closed`.
  - Onboarding and closure timestamps.
- Serve as the anchor for:
  - `TenantSettings`
  - `TenantSubscription`
  - `TenantModule` / `TenantFeatureFlag`
  - `TenantDomain` / `TenantBranding`
  - `TenantComplianceSetting`
  - `TenantHistoryEvent`

**Typical core fields (conceptual)**

- `id` – UUID.
- `name`, `legalName`, `industry`, `companySize`.
- `status` – enum (`TRIAL`, `ACTIVE`, `SUSPENDED`, `CLOSED`).
- `isSandbox` – bool; used for VIEWER sandbox tenants.
- `createdAt`, `updatedAt`, `deletedAt?`.
- `createdByActorId`, `updatedByActorId`.

**RBAC / RLS**

- Only **ADMIN** (role hierarchy 0) has `tenant:update`, `tenant:manage:*` permissions.
- All reads/writes of tenant information run through `withRLS-v9`, which ensures:
  - `tenant.id = current_tenant_id` for non-system contexts.
- System and back-office operations can use a special system context (bypassing tenant filters) for provisioning, but those paths are tightly controlled and audited.

---

### 4.2 `TenantSettings`

**Responsibility**

Key-value and structured configuration that control **behavior** of the tenant environment, including security-sensitive switches.

**Examples**

- Locale / region: default `timezone`, `currency`, `dateFormat`.
- Business defaults: default payment terms, numbering schemes for estimates/invoices/projects.
- **Dynamic RBAC toggles** (consumed by PM flows and RLS - 7 critical permissions from RBAC v9.0):
  - `pmCanApproveEstimates` (gates: estimate:approve)
  - `pmCanApproveInvoices` (gates: invoice:approve)
  - `pmCanApproveChangeOrders` (gates: changeorder:approve)
  - `pmCanSeeProjectFinancials` (gates: project:read:financials, cost analysis)
  - `pmCanDeleteOwnEstimates` (gates: estimate:delete:own)
  - `pmCanDeleteOwnInvoices` (gates: invoice:delete:own)
  - `pmCanDeleteOwnChangeOrders` (gates: changeorder:delete:own)
- Feature behavior: enabling certain workflows or AI capabilities.

**Interactions**

- **AccessControl / RBAC v9**:
  - RBAC v9.0 defines 156 explicit permissions across 18 domains
  - PROJECT_MANAGER role has base operational permissions (hierarchy level 2)
  - Critical permissions (approve, delete, financials) exist in catalog but are **gated by TenantSettings**
  - Services implement two-step validation:
    1. Check RBAC: `await rbac.hasPermission(roleCode, 'estimate:approve')`
    2. Check TenantSettings: `settings.pmCanApproveEstimates === true`
    3. Proceed only if both checks succeed
- **RLS v9.0 Engine (withRLS-v9.ts)**:
  - `withRLS()`: Basic tenant isolation for standard operations
  - `withRoleRLS()`: Role-based operations with hierarchy validation
  - `withPMRLS()`: Specialized PROJECT_MANAGER wrapper with TenantSettings context
  - PM permission flags loaded from TenantSettings and injected into security context
  - PostgreSQL RLS policies enforce `tenantId = current_tenant_id()`

**RBAC / RLS**

- Write operations on `TenantSettings` require `tenant:manage:settings`.
- Read operations typically allow ADMIN and possibly some read-only roles (e.g. EXECUTIVE in future phases).

---

### 4.3 `TenantSubscription`

**Responsibility**

Represents the **commercial relationship** with the tenant:

- Plan, billing cadence, limits (members, projects, storage), and status.

**Examples**

- `planCode`: `FREE`, `STARTER`, `PRO`, `ENTERPRISE`.
- `billingCycle`: `MONTHLY`, `ANNUAL`.
- `status`: `trial`, `active`, `past_due`, `canceled`.
- `trialEndsAt`, `renewalDate`.
- Seats and resource limits: `maxMembers`, `maxProjects`, `maxStorageMB`.

**Interactions**

- **Billing / Payments** modules:
  - External billing provider (Stripe, etc.) maps to `TenantSubscription` via webhooks.
  - Payment status changes update `TenantSubscription.status` and may propagate to `Tenant.status`.
- **Feature enforcement**:
  - Service layer checks `TenantSubscription` before allowing certain actions (e.g. creating new Members, enabling AI modules, etc.).
- **Analytics / Dashboards**:
  - Usage vs limits is surfaced in admin dashboards.

**RBAC / RLS**

- Only ADMIN and internal billing ops can update subscription.
- Reads by ADMIN via `tenant:read:subscription` (if you choose to expose it explicitly).

---

### 4.4 `TenantUsageRecord`

**Responsibility**

Captures **aggregated usage metrics** for a tenant, typically per time window (daily, monthly).

**Examples of metrics**

- Number of Estimates, Invoices, Projects, active Members.
- Storage used (MB/GB).
- API calls, AI tokens.
- Jobs executed (scheduling runs, AI insight jobs, etc.).

**Interactions**

- **Billing / Analytics**:
  - Used for usage-based billing or overage alerts.
  - Feeds dashboards and health metrics.
- **TenantSubscription**:
  - Usage compared to plan limits at runtime.

**RBAC / RLS**

- Read-only for ADMIN (and internal ops).
- Writes are typically performed by background jobs, not by user actions.

---

### 4.5 `TenantDomain`

**Responsibility**

Tenant-specific domain / subdomain mappings for **routing** and **white-labeling**.

**Examples**

- `primaryDomain` – e.g. `acme.beesmart.app`.
- `customDomain` – e.g. `portal.acme.com`.
- Verification state: `pending`, `verified`, `failed`.
- DNS verification tokens or CNAME records.

**Interactions**

- **Edge / gateway**:
  - Incoming host header is resolved to a `TenantDomain`.
  - That resolution determines `tenantId` for downstream RLS.
- **Tenant**:
  - Domain changes create `TenantHistoryEvent` entries.

**RBAC / RLS**

- Only ADMIN has `tenant:manage:domains`.
- Reads can be public from the routing layer, but all admin UIs respect RBAC and RLS.

---

### 4.6 `TenantBranding`

**Responsibility**

Controls the **visual identity** of the tenant’s environment.

**Examples**

- Logos (main logo, favicon).
- Color palette and typography.
- PDF template presets for Estimates and Invoices.
- Email theme branding.

**Interactions**

- **Documents / e-Signature / Email Engine**:
  - All outbound artifacts (PDFs, emails, portal views) use `TenantBranding`.
- **Customer Portal**:
  - Portal UI skins per tenant.

**RBAC / RLS**

- Only ADMIN has `tenant:manage:branding`.
- Read access may be needed by many modules; it is inexpensive and can be cached.

---

### 4.7 `TenantModule`

**Responsibility**

Defines which **major ERP modules** are enabled for the tenant. :contentReference[oaicite:4]{index=4}

**Examples**

Each row might include:

- `tenantId`
- `moduleCode` – e.g.:
  - `ESTIMATE`, `INVOICE`, `PROJECT`, `CRM`, `INVENTORY`, `EXPENSES`, `PAYROLL`, `SCHEDULING`, `AI`, `ANALYTICS`, etc.
- `status`: `enabled`, `disabled`, `pilot`.
- `enabledAt`, `disabledAt`.

**Interactions**

- **Business modules**:
  - Service layer checks `TenantModule` before executing a module’s critical operations.
  - UI uses it to show/hide entire module sections.
- **TenantSubscription**:
  - Subscription plan may drive which modules can be enabled.

**RBAC / RLS**

- Only ADMIN has `tenant:manage:modules`.
- Reads are common across all services.

---

### 4.8 `TenantFeatureFlag`

**Responsibility**

Fine-grained **feature toggles** and experiments at the tenant level.

**Examples**

- `featureKey`:
  - `aiPricingSuggestions`
  - `zeroLossDashboard`
  - `advancedScheduling`
  - `newEstimateUI`
- `isEnabled`, `variant`, `rolloutStrategy`.

**Interactions**

- **Business logic and AI**:
  - Feature flags may gate certain code paths or AI prompts.
- **A/B testing (future phase)**:
  - Combined with analytics to evaluate feature performance.

**RBAC / RLS**

- Usually managed only by ADMIN or internal ops (depending on feature type).
- Reads are frequent and can be cached.

---

### 4.9 `TenantComplianceSetting`

**Responsibility**

Holds tenant-specific **compliance and retention configuration**.

**Examples**

- Data retention periods:
  - `retention.estimateMonths`
  - `retention.invoiceYears`
  - `retention.documentsYears`
- PII policies:
  - `maskPIIInLogs`
  - `exportControls` (what data can be exported).
- Data residency:
  - `dataRegion`, `requireEUDataResidency`.

**Interactions**

- **Compliance / Legal modules**:
  - `compliance.prisma`, `taxcompliance.prisma`, etc., may read this configuration.
- **Background jobs**:
  - Archiving / deletion jobs read these settings to purge or anonymize old data.

**RBAC / RLS**

- Only ADMIN (and possibly a Compliance Officer role in the future) can update.
- Reads may be used internally for enforcement and audit processes.

---

### 4.10 `TenantHistoryEvent`

**Responsibility**

Immutable **event log** for all tenant-level changes.

**Examples**

Event types:

- `TENANT_CREATED`
- `TENANT_UPDATED`
- `TENANT_STATUS_CHANGED`
- `TENANT_SETTINGS_UPDATED`
- `TENANT_SUBSCRIPTION_UPDATED`
- `TENANT_MODULE_ENABLED` / `TENANT_MODULE_DISABLED`
- `TENANT_FEATURE_FLAG_UPDATED`
- `TENANT_COMPLIANCE_UPDATED`
- `TENANT_DOMAIN_ADDED` / `TENANT_DOMAIN_VERIFIED`
- `TENANT_BRANDING_UPDATED`
- `TENANT_SUSPENDED` / `TENANT_CLOSED`

**Interactions**

- **Support / Admin tooling**:
  - Tenant-level timeline for debugging and audits.
- **Compliance**:
  - Combined with `AccessAuditEvent` to show who changed tenant-level configuration and when.

**RBAC / RLS**

- Readable by ADMIN and internal ops.
- Append-only; write operations are performed whenever a tenant-level entity changes.

---

## 5. Integration with Other Core Modules

### 5.1 Identity & IdentitySecurity

From `identity.prisma` / `identitysecurity.prisma`: :contentReference[oaicite:5]{index=5}

- `Actor` – global identity used for:
  - `createdByActorId`, `updatedByActorId` in Tenant module tables.
- `User`, `Session`, `UserProfile` – auth and profile for human users.
- `TenantIdentityProvider`, `IdentityProvider` – SSO providers per tenant (if present).

**Integration**

- When a new tenant is created:
  - A `User` + `Actor` are created.
  - That Actor becomes a `Member` of the new `Tenant` with ADMIN role.
- IdentitySecurity ensures secure authentication; Tenant module decides what environment that identity has access to.

---

### 5.2 Membership

From `membership.prisma`: :contentReference[oaicite:6]{index=6}

- `Member` – `actorId + tenantId`; the bridge between global identity and tenant context.
- `MemberSettings`, `MemberInvitation`, `MemberDocument`, etc.

**Integration**

- `Member.tenantId` is a foreign key to `Tenant.id`.
- All Member operations rely on Tenant module for:
  - Whether the tenant is `active` or `suspended`.
  - Which modules/features are enabled for that tenant.

---

### 5.3 AccessControl (RBAC v9)

From `accesscontrol.prisma`: :contentReference[oaicite:7]{index=7}

- `Role`, `Permission`, `RolePermission`, `MemberRole`.
- `AccessAuditEvent`, `ServiceAccount`, `ServiceAccountKey`.

**Integration**

- `MemberRole.memberId` → `Member` (which already has `tenantId`).
- Tenant module governs:
  - Who may create additional Members (through `tenant:manage:members` if you define it).
  - Which modules are visible; RBAC controls which actions are allowed inside those modules.

In **Phase 1**, AccessPolicy/ABAC tables (`AccessPolicy`, `AccessPolicyCondition`, `AccessScope`, etc.) are defined but not active; enforcement is done purely via RBAC + TenantSettings + RLS.

---

### 5.4 Business Modules (Estimate, Invoice, Project, etc.)

From multiple `*.prisma` modules (Estimate, Invoice, Projects, CRM, Inventory, Expenses, Scheduling, Payroll, AI, Analytics). :contentReference[oaicite:8]{index=8}

**Integration pattern**

- Each tenant-scoped business table includes `tenantId` referencing `Tenant.id`.
- RLS policies use `tenantId = current_tenant_id()` to enforce isolation.
- Tenant module configuration impacts:
  - Whether the module is usable (`TenantModule`).
  - How it behaves (defaults from `TenantSettings`).
  - Whether certain advanced features are enabled (`TenantFeatureFlag`).
  - Compliance behavior (retention, masking via `TenantComplianceSetting`).

---

## 6. Security Model (RBAC + RLS + Tenant)

### 6.1 RBAC v9.0 Integration

Core principles for Tenant module aligned with RBAC v9.0:

**Role Hierarchy** (0=Highest Authority):

- **ADMIN** (hierarchy 0): Tenant-scoped owner with full control
  - `tenant:manage:*` permissions for all tenant control-plane operations
  - Can update all TenantSettings, TenantModule, TenantFeatureFlag, TenantDomain, TenantBranding
  - **No cross-tenant access** - strictly isolated to their own tenant
- **PROJECT_MANAGER** (hierarchy 2): Limited tenant configuration access
  - Read access to TenantSettings for operational needs
  - **No write access** to tenant control-plane in Phase 1
  - Critical permissions gated by TenantSettings flags
- **WORKER/DRIVER/VIEWER** (hierarchy 8-10): **No tenant control-plane access**
  - May read branding/localization settings for UI purposes
  - Zero administrative capabilities

**Permission Catalog Integration**:

- 156 explicit permissions across 18 domains (from RBAC v9.0)
- Tenant domain: `tenant:manage:settings`, `tenant:manage:modules`, `tenant:manage:branding`
- PROJECT_MANAGER critical permissions controlled via 7 TenantSettings flags
- All tenant operations logged in AccessAuditEvent

### 6.2 RLS

- All tenant-scoped tables in other modules enforce:
  - `tenantId = current_tenant_id`.
- In Tenant module itself, RLS ensures:
  - A tenant ADMIN only sees their own `Tenant` and its control-plane tables.
- System operations use a privileged context and are heavily audited.

### 6.3 RLS v9.0 Engine Integration (withRLS-v9.ts)

**Basic Tenant Operations** (90% of use cases):

```typescript
// Standard tenant-scoped operation
await withRLS(
  prisma,
  {
    tenantId,
    actorId,
    memberId,
    sessionId,
    requestId,
  },
  async (tx) => {
    // Automatic tenant isolation via RLS policies
    const settings = await tx.tenantSettings.findMany({
      where: { settingCategory: "RBAC" },
    });
    return settings;
  }
);
```

**Role-Based Operations** with hierarchy validation:

```typescript
// PROJECT_MANAGER operations with TenantSettings integration
await withPMRLS(
  prisma,
  {
    tenantId,
    actorId,
    memberId,
    role: "PROJECT_MANAGER",
    roleHierarchy: 2,
    assignedProjects: ["proj-1", "proj-2"],
    pmPermissions: {
      canApproveEstimates: true, // from TenantSettings.pmCanApproveEstimates
      canSeeProjectFinancials: false, // from TenantSettings.pmCanSeeProjectFinancials
      canDeleteOwnEstimates: true, // from TenantSettings.pmCanDeleteOwnEstimates
    },
  },
  async (tx) => {
    // PM-scoped operations with dynamic permission enforcement
    return tx.estimate.update({
      where: { id: estimateId },
      data: { status: "APPROVED" },
    });
  }
);
```

**System Operations** (tenant administration):

```typescript
// System context for tenant provisioning (heavily audited)
await withSystemRLS(
  prisma,
  {
    systemActorId: "system-provisioner",
    operation: "TENANT_PROVISIONING",
    auditContext: { requestId, correlationId },
  },
  async (tx) => {
    // Cross-tenant operations for system administration
    return tx.tenant.create({ data: newTenantData });
  }
);
```

---

## 7. Key Flows (High-Level Summary)

1. **Tenant Provisioning**

   - Create `User` + `Actor`.
   - Create `Tenant` + `TenantSettings` + `TenantSubscription` (trial) + `TenantModule` defaults + `TenantFeatureFlag` defaults + `TenantComplianceSetting`.
   - Create `Member` + `MemberRole` (ADMIN).
   - Log `TenantHistoryEvent (TENANT_CREATED)`.

2. **Tenant Configuration**

   - ADMIN updates settings, modules, feature flags, branding, domains, compliance.
   - Each change writes `TenantHistoryEvent` and relevant `AccessAuditEvent`.

3. **Subscription & Usage**

   - External billing updates `TenantSubscription`.
   - Background jobs update `TenantUsageRecord`.
   - Service layer enforces limits at runtime.

4. **Suspension & Closure**

   - Changing `Tenant.status` (suspended/closed) affects login and write operations.
   - Compliance jobs reference `TenantComplianceSetting` to purge/archive data.

---

## 8. Phase 1 vs Future Phases

- **Phase 1 (current - ✅ IMPLEMENTED)**:

  - Tenant module with 10 models as described above
  - **RBAC v9.0**: 5 internal roles, 156 explicit permissions, code-generated constants
  - **RLS v9.0**: `withRLS-v9.ts` engine with role-based wrappers
  - **TenantSettings Integration**: 7 critical PM permissions dynamically controlled
  - **Multi-tenant Isolation**: PostgreSQL RLS policies + automatic tenant context
  - **Production Ready**: Enterprise-grade security and performance

- **Phase 2 (planned)**:

  - External roles (CLIENT, VENDOR, SUBCONTRACTOR)
  - AccessPolicy/ABAC engine migration from TenantSettings
  - Advanced TenantFeatureFlag experimentation and A/B testing
  - Enhanced compliance frameworks and audit integration
  - Mobile API security extensions

---

---

## 9. RBAC v9.0 + RLS v9.0 Integration Patterns

### 9.1 Complete PM Permission Resolution Flow

**Two-Stage Validation** (aligned with RBAC v9.0 schema):

```typescript
// Stage 1: RBAC Permission Check
const hasBasePermission = await rbac.hasPermission(
  memberRoles,
  "estimate:approve"
);

if (!hasBasePermission) {
  throw new ForbiddenError("estimate:approve not granted to role");
}

// Stage 2: TenantSettings Dynamic Flag Check
const tenantSetting = await prisma.tenantSettings.findFirst({
  where: {
    tenantId,
    settingKey: "pmCanApproveEstimates",
  },
});

if (!tenantSetting?.settingValue) {
  throw new ForbiddenError("PM approval disabled in tenant settings");
}

// Both checks passed - proceed with operation
```

### 9.2 TenantSettings → RBAC Mapping

**7 Critical PM Permissions** (from RBAC v9.0 schema):

| TenantSettings Flag          | RBAC Permission           | Gated Operation            |
| ---------------------------- | ------------------------- | -------------------------- |
| `pmCanApproveEstimates`      | `estimate:approve`        | Estimate approval workflow |
| `pmCanApproveInvoices`       | `invoice:approve`         | Invoice approval workflow  |
| `pmCanApproveChangeOrders`   | `changeorder:approve`     | Change order approval      |
| `pmCanSeeProjectFinancials`  | `project:read:financials` | Cost/profit visibility     |
| `pmCanDeleteOwnEstimates`    | `estimate:delete:own`     | Own estimate deletion      |
| `pmCanDeleteOwnInvoices`     | `invoice:delete:own`      | Own invoice deletion       |
| `pmCanDeleteOwnChangeOrders` | `changeorder:delete:own`  | Own change order deletion  |

### 9.3 RLS v9.0 Context Injection

**PM Context with TenantSettings**:

```typescript
// Automatic TenantSettings loading for PM operations
const pmContext = await loadPMContext(tenantId, memberId);

await withPMRLS(
  prisma,
  {
    tenantId,
    actorId,
    memberId,
    role: "PROJECT_MANAGER",
    roleHierarchy: 2,
    assignedProjects,
    pmPermissions: pmContext.permissions, // Loaded from TenantSettings
  },
  async (tx) => {
    // PM operations with full context
  }
);
```

**Context Loading Function**:

```typescript
async function loadPMContext(tenantId: string, memberId: string) {
  const settings = await prisma.tenantSettings.findMany({
    where: {
      tenantId,
      settingKey: {
        in: [
          "pmCanApproveEstimates",
          "pmCanApproveInvoices",
          "pmCanApproveChangeOrders",
          "pmCanSeeProjectFinancials",
          "pmCanDeleteOwnEstimates",
          "pmCanDeleteOwnInvoices",
          "pmCanDeleteOwnChangeOrders",
        ],
      },
    },
  });

  return {
    permissions: {
      canApproveEstimates: getBooleanSetting(settings, "pmCanApproveEstimates"),
      canApproveInvoices: getBooleanSetting(settings, "pmCanApproveInvoices"),
      canApproveChangeOrders: getBooleanSetting(
        settings,
        "pmCanApproveChangeOrders"
      ),
      canSeeProjectFinancials: getBooleanSetting(
        settings,
        "pmCanSeeProjectFinancials"
      ),
      canDeleteOwnEstimates: getBooleanSetting(
        settings,
        "pmCanDeleteOwnEstimates"
      ),
      canDeleteOwnInvoices: getBooleanSetting(
        settings,
        "pmCanDeleteOwnInvoices"
      ),
      canDeleteOwnChangeOrders: getBooleanSetting(
        settings,
        "pmCanDeleteOwnChangeOrders"
      ),
    },
  };
}
```

---

## This `Tenant_Module.md` specification is the **canonical reference** for how the Tenant module is structured, what each table does, and how it integrates with Identity, Membership, AccessControl (RBAC v9), RLS v9, and all tenant-scoped business modules in the ERP Enterprise Platform.

**Document Status:** ✅ **FULLY ALIGNED** with RBAC v9.0 + RLS v9.0
**Integration Status:** ✅ **PRODUCTION READY** - All specifications implemented
**Version:** v9.0 - Phase 1 Internal Members Complete
