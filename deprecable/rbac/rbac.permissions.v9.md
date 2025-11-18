# RBAC Permissions Specification – Phase 1 (Internal Members)

**Platform:** BeeSmart Pro ERP
**Scope:** Internal member roles for Tenant-level access control (Phase 1)
**Status:** Source of Truth for RBAC schema v8.x and generator

This document defines the **canonical role and permission model** for Phase 1 of the ERP platform. It is used to drive:

- `rbac_schema_v9.0.yml`
- `rbac-generator-v9.0.ts`
- `rbac-constants.ts`
- `rbac-seed.ts`

In this phase we focus on **internal member roles** only, with full multi-tenant isolation enforced via **PostgreSQL RLS + withRLS wrapper**.

---

## 1. Design Principles

1. **Multi-tenant isolation first**
   All access is constrained by `tenantId` via RLS. RBAC controls _what_ a user may do; RLS controls _which rows_ they see or modify.

2. **Minimal, explicit roles**
   Phase 1 uses only five internal roles:

   - `ADMIN`
   - `PROJECT_MANAGER`
   - `WORKER`
   - `DRIVER`
   - `VIEWER` (sandbox only)

3. **Permission naming convention**

   All permissions MUST follow:

   ```txt
   <domain>:<action>[:<subaction>]
   ```

Examples:

- `estimate:create`
- `project:assign:worker`
- `invoice:read:own`
- `time:create:own_entry`
- `project:read:delivery_info`

Domains are aligned with modules, e.g.:
`tenant`, `accesscontrol`, `identity`, `membership`, `estimate`, `invoice`, `project`, `task`,
`expenses`, `inventory`, `scheduling`, `time`, `payroll`, `crm`, `documents`, `ai`, `analytics`.

4. **Static RBAC + runtime toggles**

   - RBAC defines **potential capabilities** (permission catalog + role grants).
   - Tenant-level toggles (in `TenantSettings`) gate **critical actions** (e.g. PM approvals, financial visibility) in services.
   - A future **AccessPolicy** engine will centralize these rules; Phase 1 enforces them directly in application services.

5. **Phase 1 hierarchies**

   Internal role hierarchy (lower number = more authority):

   - `ADMIN` – `0`
   - `PROJECT_MANAGER` – `2`
   - `WORKER` – `8`
   - `DRIVER` – `9`
   - `VIEWER` – `10`

---

## 2. Roles Overview

Phase 1 internal member roles:

1. **ADMIN** – Tenant owner. Full CRUD over tenant-level business data and configuration. No platform/system powers.
2. **PROJECT_MANAGER** – Broad but scoped manager. Access limited to own/assigned estimates, invoices, projects and tasks. Critical actions gated by TenantSettings.
3. **WORKER** – Field/office execution role. Works on assigned tasks and projects, manages own time and expenses only.
4. **DRIVER** – Delivery/logistics role. Very narrow scope: delivery tasks, delivery-related info, own time and expenses.
5. **VIEWER** – Read-only sandbox role. Can only access sandbox tenants; no write operations.

Each role is defined with:

- **Baseline permissions** – always granted.
- **Critical / elevated permissions** – exist in catalog but not granted by default.
- **Explicit exclusions** – clear boundaries for what the role cannot do.

---

## 3. ADMIN – Tenant Owner

**Role:** `ADMIN`
**Hierarchy:** `0`
**Description:**
Tenant owner; the user who signs up and creates the tenant. Has full control of business data and tenant configuration **within their own tenant**. Does not have platform-wide / system-level powers.

### 3.1 Baseline Permissions

#### Tenant Management (tenant.prisma → `tenant`)

- `tenant:read`
- `tenant:update`
- `tenant:manage:modules`
- `tenant:manage:features`

#### Identity & Membership (identity.prisma, membership.prisma → `identity`, `membership`)

- `identity:invite:user`
- `identity:read:tenant_users`
- `identity:update:tenant_users`
- `membership:manage:roles`
- `membership:read:tenant_members`
- `membership:update:tenant_members`

#### AccessControl (accesscontrol.prisma → `accesscontrol`)

- `accesscontrol:read`
- `accesscontrol:update:tenant_roles`
- `accesscontrol:manage:service_accounts`

#### Estimates (estimate.prisma → `estimate`)

- `estimate:create`
- `estimate:list`
- `estimate:read`
- `estimate:update`
- `estimate:delete`
- `estimate:send`
- `estimate:approve`

#### Invoices (invoice.prisma → `invoice`)

- `invoice:create`
- `invoice:list`
- `invoice:read`
- `invoice:update`
- `invoice:delete`
- `invoice:send`
- `invoice:approve`
- `invoice:writeoff`

#### Projects (projectCore + related → `project`)

- `project:create`
- `project:list`
- `project:read`
- `project:update`
- `project:delete`
- `project:assign:pm`
- `project:assign:worker`
- `project:assign:driver`
- `project:read:financial`

#### Tasks (task engine → `task`)

- `task:create`
- `task:list`
- `task:read`
- `task:update`
- `task:delete`
- `task:assign:worker`
- `task:assign:driver`

#### Expenses (expenses modules → `expenses`)

- `expenses:create`
- `expenses:list`
- `expenses:read`
- `expenses:update`
- `expenses:delete`
- `expenses:approve`

#### Inventory (inventory modules → `inventory`)

- `inventory:create:item`
- `inventory:list`
- `inventory:read`
- `inventory:update:item`
- `inventory:adjust:quantity`
- `inventory:investigate:loss`

#### Scheduling & Time (schedulingCore, timeattendance → `scheduling`, `time`)

- `scheduling:create`
- `scheduling:read`
- `scheduling:update`
- `time:read:tenant`
- `time:correct:tenant`

#### Payroll (payroll.prisma → `payroll`)

- `payroll:read:tenant`
- `payroll:run`
- `payroll:update`

#### CRM (crm modules → `crm`)

- `crm:create`
- `crm:list`
- `crm:read`
- `crm:update`
- `crm:delete`

#### Documents (documentscore → `documents`)

- `documents:create`
- `documents:list`
- `documents:read`
- `documents:update`
- `documents:delete`

#### AI (aicore, aiinsights → `ai`, `analytics`)

- `ai:ask`
- `ai:assist:tenant`
- `ai:generate:project_report`
- `ai:generate:financial_report`
- `analytics:read:tenant_kpis`

### 3.2 Exclusions

Admin **cannot**:

- Perform any `system:*` or cross-tenant operations (those belong to a separate platform-level SuperAdmin, out of scope for Phase 1).
- Access other tenants’ data (RLS ensures tenant scoping).
- Manage infrastructure (migrations, platform billing provider configuration, global webhooks registry, etc.).

---

## 4. PROJECT_MANAGER – Scoped Operational Manager

**Role:** `PROJECT_MANAGER`
**Hierarchy:** `2`
**Description:**
Internal member responsible for managing projects, estimates, invoices, tasks and teams **within their own scope**. Access is limited to **own/assigned** data. Critical financial and approval capabilities are **not** granted by default and are controlled via `TenantSettings` in this phase.

### 4.1 Baseline Permissions (Always Granted)

#### Estimates (scope: own/managed only)

- `estimate:create`
- `estimate:list:own`
- `estimate:read:own`
- `estimate:update:own`
- `estimate:send:own`

#### Invoices (scope: own/managed only)

- `invoice:create`
- `invoice:list:own`
- `invoice:read:own`
- `invoice:update:own`
- `invoice:send:own`

#### Projects (scope: projects where PM is assigned)

- `project:create:own`
- `project:list:own`
- `project:read:own`
- `project:update:own`
- `project:assign:worker`
- `project:assign:driver`
- `project:assign:task`
- `project:read:team`
- `project:read:schedule`

PM can see:

- Contract value of the project, estimate, invoice (top line)
- Overall project value

But **not** global tenant-level profitability.

#### Tasks (under PM’s projects)

- `task:create:project`
- `task:list:project`
- `task:read:project`
- `task:update:project`
- `task:assign:worker`
- `task:assign:driver`

#### Expenses (project-related, summary-level)

- `expenses:list:project`
- `expenses:read:project` _(summary, not tenant-wide details)_

#### Personal Time / Payroll / Schedule

- `time:create:own_entry`
- `time:read:own`
- `payroll:read:own`
- `scheduling:read:own`

#### Documents (project-scoped)

- `documents:list:project`
- `documents:read:project`
- `documents:upload:project`
- `documents:comment:project`

#### AI

- `ai:ask`
- `ai:assist:project`
- `ai:generate:project_report`

### 4.2 Critical / Elevated Permissions (Cataloged, Not Granted by Default)

These permissions must exist in the global permission catalog but **must not** be granted to `PROJECT_MANAGER` by default.

They are controlled via `TenantSettings` flags in Phase 1 (and later via AccessPolicy).

#### Approvals & Deletes

- `estimate:approve`
- `estimate:delete:own`
- `invoice:approve`
- `invoice:delete:own`
- `changeorder:approve`
- `changeorder:delete:own`

Typical gating flags (in `TenantSettings`):

- `pmCanApproveEstimates`
- `pmCanApproveInvoices`
- `pmCanApproveChangeOrders`

#### Financial Insight Permissions

- `project:read:financial`
- `estimate:read:profit`
- `invoice:read:profit`
- `analytics:read:tenant_kpis`

Typical gating flag:

- `pmCanSeeProjectFinancials`

In Phase 1, these checks live in services (RBAC + TenantSettings). In a later phase, they will be enforced by `AccessPolicy`.

### 4.3 Explicit Exclusions

Project Manager **must not** have:

- Any `tenant:*` permissions (Tenant, TenantSettings, TenantSubscription, TenantModule, etc.).
- Any `accesscontrol:*` permissions.
- Any `identity:*` permissions (no global user management).
- CRM ownership / sales pipeline management (`crm:*`) beyond what is explicitly granted (currently none).
- Inventory adjustments or loss investigations: `inventory:adjust:*`, `inventory:investigate:*`.
- Global scheduling creation: `scheduling:create:global`.
- Tenant-level time or payroll: `time:read:tenant`, `payroll:run`, `payroll:update`.
- Any system-level or cross-tenant permissions.

---

## 5. WORKER – Field / Office Execution Role

**Role:** `WORKER`
**Hierarchy:** `8`
**Description:**
Internal member executing tasks in the field or office. Can see and act only on assigned projects and tasks, plus their own time and expenses. No access to financial approvals or tenant configuration.

### 5.1 Baseline Permissions

#### Projects

- `project:list:assigned`
- `project:read:assigned` _(operational details only for assigned projects)_

#### Tasks

- `task:list:assigned`
- `task:read:assigned`
- `task:update:status:own`

#### Expenses

- `expenses:create:own`
- `expenses:list:own`
- `expenses:read:own`

#### Time & Scheduling

- `time:create:own_entry`
- `time:read:own`
- `scheduling:read:own`

#### Documents

- `documents:list:assigned`
- `documents:read:assigned`
- `documents:upload:assigned`

#### AI

- `ai:ask`
- `ai:assist:task`

### 5.2 Exclusions

Worker **must not** have:

- Any `estimate:*` permissions.
- Any `invoice:*` permissions.
- Any `crm:*` permissions.
- Any `accesscontrol:*`, `identity:*`, `tenant:*` permissions.
- Any inventory adjustments: `inventory:adjust:*`, `inventory:update:item`.
- Scheduling for others.
- Payroll access for others.
- Any approvals (estimates, invoices, expenses, change orders).

---

## 6. DRIVER – Delivery / Logistics Role

**Role:** `DRIVER`
**Hierarchy:** `9`
**Description:**
Internal member focused on deliveries and logistics. Needs minimal access to project and task information related to deliveries, plus the ability to log their own time and delivery-related expenses.

### 6.1 Baseline Permissions

#### Projects (Delivery-Scoped)

- `project:list:delivery_assigned`
- `project:read:delivery_info`

  - Job site address
  - Date/time window
  - Project name/reference
  - PM contact info

#### Tasks (Delivery)

- `task:list:delivery`
- `task:read:delivery`
- `task:update:status:delivery`

#### Inventory (Delivery Items Only)

- `inventory:read:delivery_items`

#### Expenses

- `expenses:create:delivery`
- `expenses:list:own`
- `expenses:read:own`

#### Time & Scheduling

- `time:create:own_entry`
- `time:read:own`
- `scheduling:read:own`

#### Documents

- `documents:upload:delivery`
- `documents:read:delivery`

#### AI

- `ai:ask`
- `ai:assist:delivery`

### 6.2 Exclusions

Driver **must not** have:

- Full project read: no `project:read` beyond `delivery_info`.
- Task access outside delivery tasks.
- Any `estimate:*`, `invoice:*`, or `crm:*` permissions.
- Inventory adjustments or stock control.
- Scheduling for others.
- Any approval permissions.

---

## 7. VIEWER – Sandbox-Only Read-Only Role

**Role:** `VIEWER`
**Hierarchy:** `10`
**Description:**
Read-only role used for demos and learning in **sandbox tenants only**. No write operations, no real production data access. Enforcement of sandbox-only behavior is done via RLS and tenant flags (`Tenant.isSandbox = true`).

### 7.1 Baseline Permissions (Sandbox Tenants Only)

#### Core Business Data

- `estimate:read`
- `estimate:list`
- `invoice:read`
- `invoice:list`
- `project:read`
- `project:list`
- `crm:read`
- `crm:list`
- `inventory:read`
- `inventory:list`
- `expenses:read`
- `expenses:list`

#### Time / Scheduling / Payroll (Demo Context Only)

- `scheduling:read`
- `time:read`
- `payroll:read`

#### Documents

- `documents:read`
- `documents:list`

#### AI

- `ai:ask`
- `ai:generate:demo_report`

### 7.2 Exclusions

Viewer **must not**:

- Perform any create/update/delete/approve/send operations (no CRUD globally).
- Access any tenant where `Tenant.isSandbox = false`.
- Manage AccessControl, Identity, or Tenant-level configuration.
- Affect real billing, external integrations, or production data.

---

## 8. Usage Notes

1. **RBAC Schema (`rbac.schema.v8.x.yml`)**

   - All permissions listed above must be present in the global `permissions` catalog.
   - Roles must be defined with the hierarchies given.
   - Role → permission grants must follow the baseline definitions here.
   - Critical/elevated permissions for `PROJECT_MANAGER` must be cataloged but not granted by default.

2. **TenantSettings (Phase 1)**

   Example flags (per tenant):

   - `pmCanApproveEstimates`
   - `pmCanApproveInvoices`
   - `pmCanApproveChangeOrders`
   - `pmCanSeeProjectFinancials`

   Application services must combine:

   - `requirePermission(ctx, 'estimate:approve')`
   - plus checks on `TenantSettings` flags
   - plus RLS context (`withRLS`) to ensure row-level isolation.

3. **AccessPolicy (Future Phase)**

   When the AccessPolicy engine is introduced, the logic currently implemented in application services using TenantSettings will be migrated to declarative policies that:

   - Read TenantSettings
   - Read member attributes, roles, scopes
   - Evaluate per-resource conditions
   - Produce allow/deny decisions

---

This document is the **single source of truth** for internal RBAC in Phase 1.
Any schema, generator, or seed changes must be validated against this specification.
