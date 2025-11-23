# ADMIN Recommended Permissions (Phase 1 — Tenant Owner)

Purpose

- Canonical, Phase 1–aligned permission set for `ADMIN` (tenant owner).
- Maps to domains and verbs defined in `RBAC_Schema.v10.yml`.
- All permissions are tenant‑scoped via RLS; no system/platform access.
- Analytics domain intentionally omitted in Phase 1 (future expansion).

Notes

- Domain keys MUST match module names exactly.
- Naming: `domain:action[:subaction]` (lowercase).
- This list is a recommendation; adopt/trim based on business policy.

---

## Tenant

- `tenant:read`
- `tenant:update`
- `tenant:manage:modules`
- `tenant:manage:features`

## AccessControl

- `accesscontrol:read`
- `accesscontrol:update:tenant_roles`
- `accesscontrol:manage:service_accounts`

## Identity

- `identity:invite:user`
- `identity:read:tenant_users`
- `identity:update:tenant_users`

## Membership

- `membership:manage:roles`
- `membership:read:tenant_members`
- `membership:update:tenant_members`

## Estimate

- `estimate:create`
- `estimate:list`
- `estimate:read`
- `estimate:update`
- `estimate:delete`
- `estimate:send`
- `estimate:approve`

## Invoice

- `invoice:create`
- `invoice:list`
- `invoice:read`
- `invoice:update`
- `invoice:delete`
- `invoice:send`
- `invoice:approve`
- `invoice:writeoff`

## Project (projectsCore, projectTaskScheduling, projectRisk)

- `project:create`
- `project:list`
- `project:read`
- `project:update`
- `project:delete`
- `project:assign:pm`
- `project:assign:worker`
- `project:assign:driver`
- `project:read:financial`

## Task

- `task:create`
- `task:list`
- `task:read`
- `task:update`
- `task:delete`
- `task:assign:worker`
- `task:assign:driver`

## Expenses (expensecore, expenses)

- `expenses:create`
- `expenses:list`
- `expenses:read`
- `expenses:update`
- `expenses:delete`
- `expenses:approve`

## Inventory (inventoryCore, inventoryTransactions, inventoryControl)

- `inventory:create:item`
- `inventory:list`
- `inventory:read`
- `inventory:update:item`
- `inventory:adjust:quantity`
- `inventory:investigate:loss`

## Scheduling (schedulingCore, scheduling)

- `scheduling:create`
- `scheduling:read`
- `scheduling:update`

## Time

- `time:read:tenant`
- `time:correct:tenant`

## Payroll

- `payroll:read:tenant`
- `payroll:run`
- `payroll:update`

## CRM (crmcore, crmcommunication, crmrelationships)

- `crm:create`
- `crm:list`
- `crm:read`
- `crm:update`
- `crm:delete`

## Documents (documentscore, documentsai)

- `documents:create`
- `documents:list`
- `documents:read`
- `documents:update`
- `documents:delete`
- `documents:upload:project`
- `documents:upload:assigned`
- `documents:upload:delivery`
- `documents:comment:project`

## Change Order

- `changeorder:approve`
- `changeorder:delete`
  (If you prefer scoped delete: `changeorder:delete:own`)

## AI (aicore, aiinsights, aidocument)

- `ai:ask`
- `ai:assist:tenant`
- `ai:generate:project_report`
- `ai:generate:financial_report`

---

Out of Scope for Phase 1

- Analytics: no permissions recommended in Phase 1.
- Platform/system operations: not available to ADMIN.

Implementation Hint

- Add these under `role_grants.ADMIN.permissions` in `RBAC_Schema.v10.yml`.
- Keep all names lowercase and tenant‑scoped; RLS enforces isolation.
