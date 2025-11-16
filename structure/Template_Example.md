Nice, let’s wire this up. I’ll use the **AccessControl** module as the concrete example and show how its main models would look when instantiated from your **BT / BH / BG + FK** templates.

> These are illustrative snippets, not a full file. They show how to *apply* your base templates in a real module.

---

## 1. AccessControl module using BT / BG + FK patterns

Imagine a file like:
`prisma/schemas/access_control.prisma`

### 1.1 Global catalog: `Permission` (BG template)

This is your **BG — Base Global** template applied to `Permission`:

```prisma
/// Global permission catalog (resource.action), shared across all tenants.
/// Based on: ExampleGlobalEntity (BG template).
model Permission {
  // 🆔 Identidad
  id String @id @default(uuid(7)) @db.Uuid

  // Domain fields
  key         String @unique @db.VarChar(150) // e.g. "invoice.create"
  resource    String @db.VarChar(100)         // e.g. "invoice"
  action      String @db.VarChar(50)          // e.g. "create"
  description String? @db.Text
  category    String? @db.VarChar(100)        // e.g. "Billing", "Projects"

  // 📊 Ciclo de vida
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  // 👤 Auditoría mínima
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Gobernanza
  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("INTERNAL") @db.VarChar(50)

  // 👥 Relaciones a Actor (ACTIVA SOLO si aplica)
  // createdByActor Actor? @relation("PermissionCreatedBy", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("PermissionUpdatedBy", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("PermissionDeletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // 🗂️ Índices & restricciones
  @@index([status])
  @@index([deletedAt])
  @@index([createdAt], type: Brin)
  @@index([auditCorrelationId])
  @@index([dataClassification])
  @@index([resource, action])
}
```

Key points:

* Direct application of **BG**.
* `dataClassification` overridden to `"INTERNAL"` instead of `"PUBLIC"` because this is security metadata.

---

### 1.2 Tenant catalog: `Role` (BT template)

This is your **BT — Base Tenant** template applied to a tenant-scoped role:

```prisma
/// Tenant-scoped role (Admin, ProjectManager, APClerk, Customer, Vendor, etc.)
/// Based on: ExampleTenantEntity (BT template).
model Role {
  // 🆔 Identidad & Tenant
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  // Domain fields
  code        String @db.VarChar(100) // e.g. "TENANT_ADMIN", "PROJECT_MANAGER"
  name        String @db.VarChar(150)
  description String? @db.Text
  isSystem    Boolean @default(false) // true => managed by platform, not tenant

  // 📊 Ciclo de vida
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  // 👤 Auditoría mínima (UUIDs)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Gobernanza
  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("INTERNAL") @db.VarChar(50)

  // 🔗 Relaciones requeridas
  tenant Tenant @relation("TenantToRole", fields: [tenantId], references: [id], onDelete: Cascade)

  // 👥 Relaciones a Actor (ACTIVA SOLO si es crítico)
  // createdByActor Actor? @relation("RoleCreatedBy", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("RoleUpdatedBy", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("RoleDeletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // Children
  rolePermissions RolePermission[]
  memberRoles     MemberRole[]
  scopeAssignments AccessScopeAssignment[]

  // 🗂️ Índices & restricciones
  @@unique([tenantId, id])
  @@unique([tenantId, code])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([tenantId, auditCorrelationId])
  @@index([tenantId, dataClassification])
}
```

---

### 1.3 Join: `RolePermission` (BT join + FK patterns)

This is a **tenant join** between `Role` (BT) and `Permission` (BG).

Here we’re using a BT-like pattern but trimmed for join semantics:

```prisma
/// Mapping between tenant Role and global Permission.
/// Based loosely on BT + FK pattern (_ExampleRequiredRef).
model RolePermission {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  roleId       String @db.Uuid
  permissionId String @db.Uuid

  // Domain flags
  effect       String @default("ALLOW") @db.VarChar(16) // ALLOW / DENY
  validFrom    DateTime? @db.Timestamptz(6)
  validUntil   DateTime? @db.Timestamptz(6)

  // Lightweight lifecycle (no status/deletedAt if you want it slimmer)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  createdByActorId String? @db.Uuid

  // FKs
  tenant     Tenant     @relation(fields: [tenantId], references: [id], onDelete: Cascade)
  role       Role       @relation(fields: [tenantId, roleId], references: [tenantId, id], onDelete: Cascade)
  permission Permission @relation(fields: [permissionId], references: [id], onDelete: Restrict)

  @@unique([tenantId, roleId, permissionId])
  @@index([tenantId, roleId])
  @@index([permissionId])
  @@index([createdAt], type: Brin)
}
```

Note:

* This is **BT-ish** but lighter: no `status`, no `deletedAt`.
* Uses the FK patterns:

  * Composite `[tenantId, roleId]` → Role.
  * Simple `[permissionId]` → global Permission.

If you prefer full BT, you can add `status`, `deletedAt`, `version` as in `ExampleTenantEntity`.

---

### 1.4 Join: `MemberRole` (BT join between Member and Role)

This connects `Member` (from `membershipDirectory`) with `Role`.

```prisma
/// Role assignment to a Member (or future: to a ServiceAccount).
/// Based on BT join pattern (_ExampleRequiredRef).
model MemberRole {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  memberId String @db.Uuid
  roleId   String @db.Uuid

  // Domain fields
  isPrimary   Boolean  @default(false)
  grantedAt   DateTime @default(now()) @db.Timestamptz(6)
  revokedAt   DateTime? @db.Timestamptz(6)
  reason      String?  @db.VarChar(255)

  // Lightweight audit
  grantedByActorId String? @db.Uuid
  revokedByActorId String? @db.Uuid

  // FKs
  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)
  member Member @relation(fields: [tenantId, memberId], references: [tenantId, id], onDelete: Cascade)
  role   Role   @relation(fields: [tenantId, roleId], references: [tenantId, id], onDelete: Cascade)

  @@unique([tenantId, id])
  @@index([tenantId, memberId])
  @@index([tenantId, roleId])
  @@index([tenantId, isPrimary])
}
```

This is your `_ExampleRequiredRef` pattern in action, but with two parents (Member, Role).

---

### 1.5 Parent: `AccessScope` (BT template)

A tenant-scoped “scope definition” is a perfect BT parent:

```prisma
/// Multi-dimensional scope (project, department, cost center, account, vendor, etc.).
/// Based on: ExampleTenantEntity (BT template).
model AccessScope {
  // 🆔 Identidad & Tenant
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  // Domain fields
  key         String @db.VarChar(150) // e.g. "PROJECT:123", "DEPARTMENT:HR"
  type        String @db.VarChar(50)  // PROJECT / DEPARTMENT / COST_CENTER / ACCOUNT / VENDOR
  displayName String @db.VarChar(150)
  description String? @db.Text

  // 📊 Ciclo de vida
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  // 👤 Auditoría mínima
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Gobernanza
  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("INTERNAL") @db.VarChar(50)

  tenant Tenant @relation("TenantToAccessScope", fields: [tenantId], references: [id], onDelete: Cascade)

  // Children
  assignments AccessScopeAssignment[]

  @@unique([tenantId, id])
  @@unique([tenantId, key])
  @@index([tenantId, type])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
}
```

---

### 1.6 Child: `AccessScopeAssignment` (BT child / child lightweight)

Assignments of scopes to `MemberRole` and/or `ServiceAccount`:

```prisma
/// Bind scopes to MemberRole or ServiceAccount for least-privilege enforcement.
/// Based on: _ExampleChildLightweight (tenant child).
model AccessScopeAssignment {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  // Parent scope
  scopeId String @db.Uuid
  scope   AccessScope @relation(fields: [tenantId, scopeId], references: [tenantId, id], onDelete: Cascade)

  // One of these will be set (enforce at application-level):
  memberRoleId      String? @db.Uuid
  serviceAccountId  String? @db.Uuid

  memberRole     MemberRole?    @relation(fields: [tenantId, memberRoleId], references: [tenantId, id], onDelete: Cascade)
  serviceAccount ServiceAccount? @relation(fields: [tenantId, serviceAccountId], references: [tenantId, id], onDelete: Cascade)

  // Lifecycle & audit (child-lightweight)
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  @@unique([tenantId, id])
  @@index([tenantId, scopeId])
  @@index([tenantId, memberRoleId])
  @@index([tenantId, serviceAccountId])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
}
```

This one is almost exactly `_ExampleChildLightweight` with a couple of extra FKs.

---

### 1.7 Global: `AccessResource` (BG template again)

Global registry of resource types (for ABAC):

```prisma
/// Global registry of permissionable resources (types + optional instance keys).
/// Based on: ExampleGlobalEntity (BG template).
model AccessResource {
  id String @id @default(uuid(7)) @db.Uuid

  // Domain fields
  type        String @db.VarChar(100) // e.g. "PROJECT", "INVOICE", "ESTIMATE"
  subtype     String? @db.VarChar(100)
  description String? @db.Text

  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("INTERNAL") @db.VarChar(50)

  // createdByActor Actor? @relation("AccessResourceCreatedBy", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // ...

  @@index([status])
  @@index([deletedAt])
  @@index([createdAt], type: Brin)
  @@index([auditCorrelationId])
  @@index([dataClassification])
  @@index([type, subtype])
}
```

---

### 1.8 Tenant parent: `ServiceAccount` + `ServiceAccountKey` (BT + child)

`ServiceAccount` uses BT; `ServiceAccountKey` uses the child pattern.

```prisma
/// Non-human identity owned by a tenant.
/// Based on: ExampleTenantEntity (BT template).
model ServiceAccount {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  name        String @db.VarChar(150)
  description String? @db.Text
  isActive    Boolean @default(true)

  // BT lifecycle & audit
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("INTERNAL") @db.VarChar(50)

  tenant Tenant @relation("TenantToServiceAccount", fields: [tenantId], references: [id], onDelete: Cascade)

  keys          ServiceAccountKey[]
  scopeAssignments AccessScopeAssignment[]

  @@unique([tenantId, id])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
}

/// API keys / credentials for a ServiceAccount.
/// Based on: _ExampleChildLightweight.
model ServiceAccountKey {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  serviceAccountId String @db.Uuid
  name             String @db.VarChar(150)
  hashedKey        String @db.VarChar(255)
  expiresAt        DateTime? @db.Timestamptz(6)
  lastUsedAt       DateTime? @db.Timestamptz(6)

  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  tenant         Tenant         @relation(fields: [tenantId], references: [id], onDelete: Cascade)
  serviceAccount ServiceAccount @relation(fields: [tenantId, serviceAccountId], references: [tenantId, id], onDelete: Cascade)

  @@unique([tenantId, id])
  @@index([tenantId, serviceAccountId])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
}
```

---

## 2. What this illustrates

* **BT (ExampleTenantEntity)** is being used for:

  * `Role`, `AccessScope`, `ServiceAccount` (and can be for `AccessPolicy`, etc.).
* **BG (ExampleGlobalEntity)** is being used for:

  * `Permission`, `AccessResource`, other global catalogs.
* **FK snippets**:

  * Composite tenant FKs `[tenantId, parentId]` for tenant parents (`Role`, `Member`, `AccessScope`, `ServiceAccount`).
  * Simple FKs for global references (`Permission`, `AccessResource`).
* **Child template**:

  * Used for `AccessScopeAssignment` and `ServiceAccountKey`.

If you’d like, next we can do the same exercise for **CRM** (e.g., `CRMAccount`, `CRMContact`, `CRMAccountTag`, `CRMAccountPriceOverride` as BH) to show BT/BH/BG patterns in a more business-facing module.
