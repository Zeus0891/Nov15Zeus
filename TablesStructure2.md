# Tables Structure & Enterprise Prisma Schema Guide

> Source of truth for how **all new and existing tables** in this ERP should be modeled in Prisma. It encodes our multi‑tenant, RLS‑friendly, audit‑first, performance‑aware conventions — and explains **when/how** to use cross‑relations to `Member` / `Actor` (and when **not** to).

---

## 1) Core Conventions (recap)

- **Multi‑tenant keying**
  - Every model carries `tenantId String @db.Uuid` and relates to `Tenant` with `onDelete: Cascade`.
  - Cross‑module references are **composite**: `[tenantId, foreignId] -> [tenantId, id]` to enforce tenant isolation under RLS.
- **Primary keys**
  - `id String @id @default(uuid(7)) @db.Uuid` (UUIDv7). Keep `uuid_v7_function.sql` applied.
  - Use a separate `globalId String @unique @db.Uuid` only when the entity must be referenced **cross‑tenant** or externally.
- **Enterprise base fields**
  - `status` enum (domain‑specific), `version Int @default(1)`
  - `createdAt now()` and `updatedAt @updatedAt` as `@db.Timestamptz(6)`
  - Soft delete: `deletedAt` + audit actor ids: `createdByActorId`, `updatedByActorId`, `deletedByActorId` (all `String? @db.Uuid`)
  - Governance: `auditCorrelationId`, `dataClassification`, `retentionPolicy`
  - Optional: `metadata Json?`, `tags String[]` when the model benefits from them (do **not** add blindly).
  - Avoid globally unique tech fields (e.g., `hashToken @unique`) unless necessary; prefer `@@unique([tenantId, hashToken])` to reduce global index contention.
- **Types & Postgres features**
  - Use `@db.Citext` for human/natural keys that should be case‑insensitive (codes, numbers, emails).
  - Money totals: `@db.Decimal(12, 2)` by default; adjust precision as needed.
  - Dates: use `@db.Date` for date‑only; `@db.Timestamptz(6)` for instants.
  - Ensure extensions are enabled via migration: `uuid-ossp`, `citext`, `pg_trgm`, `pg_stat_statements`, `btree_gist`, `btree_gin`.
- **Indexes & constraints (RLS‑aware)**
  - Always `@@unique([tenantId, id])` (fast tenant filters).
  - Natural keys unique per tenant, e.g. `@@unique([tenantId, invoiceNumber])`.
  - Time‑series or heavy insert models: `@@index([createdAt], type: Brin)`.
  - Operational indexes should start with `tenantId` (status, soft delete, FKs, etc.).
  - For cross-tenant lineage, add both: `@@index([tenantId, globalId])` and `@@index([globalId])`.

---

## 2) Delete Semantics (Cascade vs SetNull vs Restrict vs NoAction)

- **Cascade**: for strict ownership trees (e.g., `Tenant` → child entities; `Invoice` → `InvoiceLineItem`).
- **SetNull**: for **optional** historical references you want to keep even if the parent goes away (e.g., `approvedByMemberId`, or `createdByActorId` **if** it is modeled with an FK relation). **The referenced field in the child must be optional** if you use `SetNull` to avoid Prisma warnings.
- **Restrict**: for core financial or legal links you must not break (e.g., `Invoice` → `Account`).
- **NoAction**: only when the DB already enforces desired behavior or for legacy/compat layers; prefer the three above for clarity.

**Important: Composite Keys and SetNull**

When using composite foreign keys `[tenantId, foreignId]` with `onDelete: SetNull`, Prisma will show warnings because `tenantId` is always required. **This is expected and acceptable.** The warnings are cosmetic only:

- At runtime, PostgreSQL will successfully set **both** `tenantId` and the foreign key ID to NULL when the referenced record is deleted
- The foreign key field itself is optional (e.g., `crmContactId String? @db.Uuid`)
- This correctly represents "optional and removable" domain semantics

**Critical Rule**: Do NOT change `onDelete: SetNull` to `Restrict` or `NoAction` just to silence Prisma warnings. The schema must match the domain model and architecture diagram requirements, not editor diagnostics.

**Examples of correct SetNull usage with composite keys:**
```prisma
// Optional contact reference - can be deleted without blocking
crmContactId String? @db.Uuid
crmContact CRMContact? @relation("EstimateContact", 
  fields: [tenantId, crmContactId], 
  references: [tenantId, id], 
  onDelete: SetNull) // ✅ Correct - Prisma warning is acceptable

// Optional owner reference - member can be deactivated
ownerMemberId String? @db.Uuid
ownerMember Member? @relation("EstimateOwner", 
  fields: [tenantId, ownerMemberId], 
  references: [tenantId, id], 
  onDelete: SetNull) // ✅ Correct - preserves estimate when member deleted
```  

---

## 3) Using `Member` and `Actor` cross‑relations (decision guide)

We use **two audit patterns**:

### A. **Lightweight audit IDs only** (default for most modules)
- Keep: `createdByActorId?`, `updatedByActorId?`, `deletedByActorId?` as **bare UUIDs only**.
- **Do not** declare Prisma relations to `Actor` or `Member` in these modules.
- Rationale: avoids exploding reverse collections on `Actor`/`Member`, reduces migration churn and complexity. You still have the IDs for forensics.

**Use this for:** `room-plan`, content/notes, low‑risk operational logs, auxiliary configs, most catalog tables.

### B. **Full cross‑relations** (only for **critical** modules)
- Add named relations to `Actor` **or** `Member` with `onDelete: SetNull` (and make the FK field optional). Example:
  ```prisma
  createdByActorId String? @db.Uuid
  createdByActor   Actor?  @relation("InvoiceCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  ```
- Provide **named back‑relations** on `Actor`/`Member` (e.g., `InvoicesCreated Invoice[] @relation("InvoiceCreatedByActor")`).  
- **Only apply to**: finance (`Invoice`, `APBill`, `Payment`), revenue (`Estimate`, `ChangeOrder`), HR/payroll, security/audit models.
- **Note**: When using composite keys `[tenantId, foreignId]` with `SetNull`, Prisma warnings are expected and should be ignored. The domain semantics are correct.

**Do not mix** both patterns in the same module unless there is a compliance reason. Prefer consistency per module.

---

## 4) Base Templates (copy‑ready)

### 4.1 Base tenant entity
```prisma
model ExampleEntity {
  // Identity & audit
  id               String        @id @default(uuid(7)) @db.Uuid
  tenantId         String        @db.Uuid
  status           ExampleStatus @default(DRAFT)
  version          Int           @default(1)
  createdAt        DateTime      @default(now()) @db.Timestamptz(6)
  updatedAt        DateTime      @updatedAt @db.Timestamptz(6)
  deletedAt        DateTime?     @db.Timestamptz(6)
  createdByActorId String?       @db.Uuid
  updatedByActorId String?       @db.Uuid
  deletedByActorId String?       @db.Uuid
  auditCorrelationId String?     @db.Uuid
  dataClassification String      @default("CONFIDENTIAL") @db.VarChar(50)
  retentionPolicy    RetentionPolicy?

  // Business
  name        String        @db.VarChar(255)
  code        String?       @db.Citext
  description String?
  metadata    Json?
  tags        String[]

  // Relations
  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  // Indexes
  @@unique([tenantId, id])
  // @@unique([tenantId, code]) // if code is the natural key
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([updatedAt], type: Brin)
}
```

### 4.2 Junction (N:M) RLS‑safe
```prisma
model AtoB {
  id        String   @id @default(uuid(7)) @db.Uuid
  tenantId  String   @db.Uuid
  aId       String   @db.Uuid
  bId       String   @db.Uuid
  createdAt DateTime @default(now()) @db.Timestamptz(6)

  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)
  a      A      @relation(fields: [tenantId, aId], references: [tenantId, id], onDelete: Cascade)
  b      B      @relation(fields: [tenantId, bId], references: [tenantId, id], onDelete: Cascade)

  @@unique([tenantId, aId, bId])
  @@index([tenantId, aId])
  @@index([tenantId, bId])
}
```

### 4.3 Catalog / lookup (no soft delete)
```prisma
model ReasonCode {
  id        String   @id @default(uuid(7)) @db.Uuid
  tenantId  String   @db.Uuid
  code      String   @db.Citext
  label     String   @db.VarChar(255)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt @db.Timestamptz(6)

  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  @@unique([tenantId, code])
  @@index([createdAt], type: Brin)
}
```

### 4.4 Financial document (shared numbering)
```prisma
model InvoiceLike {
  id               String   @id @default(uuid(7)) @db.Uuid
  tenantId         String   @db.Uuid
  status           DocStatus @default(DRAFT)
  version          Int      @default(1)
  createdAt        DateTime  @default(now()) @db.Timestamptz(6)
  updatedAt        DateTime  @updatedAt @db.Timestamptz(6)
  deletedAt        DateTime? @db.Timestamptz(6)
  createdByActorId String?   @db.Uuid
  updatedByActorId String?   @db.Uuid
  deletedByActorId String?   @db.Uuid
  auditCorrelationId String? @db.Uuid
  dataClassification String  @default("CONFIDENTIAL") @db.VarChar(50)
  retentionPolicy    RetentionPolicy?

  documentGroupId String? @db.Uuid        // shared 1:1 numbering group
  docNumber       String  @db.Citext

  subtotal       Decimal @db.Decimal(12, 2)
  taxAmount      Decimal @default(0) @db.Decimal(12, 2)
  discountAmount Decimal @default(0) @db.Decimal(12, 2)
  totalAmount    Decimal @db.Decimal(12, 2)
  balanceAmount  Decimal @db.Decimal(12, 2)

  currency     String   @default("USD") @db.VarChar(3)
  exchangeRate Decimal? @db.Decimal(10, 6)

  tenant        Tenant        @relation(fields: [tenantId], references: [id], onDelete: Cascade)
  documentGroup DocumentGroup? @relation(fields: [tenantId, documentGroupId], references: [tenantId, id], onDelete: SetNull)

  @@unique([tenantId, id])
  @@unique([tenantId, docNumber])
  @@index([tenantId, createdAt], type: Brin)
}
```

---

## 5) Module‑specific notes

### 5.0 ERP modules → audit pattern map (quick picklist)

| Module (ERP area)                         | Recommended Pattern | Cross‑relations target | Notes                                                                           |
| ----------------------------------------- | ------------------- | ---------------------- | ------------------------------------------------------------------------------- |
| Room‑Plan (RoomScanSession, RoomModel, …) | A                   | None (IDs only)        | Keep `createdByActorId?`/`updatedByActorId?`/`deletedByActorId?` as UUIDs only. |
| AI (ml jobs, embeddings, features)        | A                   | None (IDs only)        | Operational/aux data; avoid reverse lists on Actor/Member.                      |
| Analytics/Observability                   | A                   | None (IDs only)        | Logs, metrics, jobs – lightweight audit.                                        |
| Approvals                                 | B                   | Actor/Member           | Named relations + back‑relations; SetNull with optional FKs.                    |
| Finance: Invoicing (AR)                   | B                   | Actor                  | Full audit trail required.                                                      |
| Finance: AP (Bills)                       | B                   | Actor                  | Full audit trail required.                                                      |
| Revenue: Estimates/Change Orders          | B                   | Actor                  | Traceability and approvals.                                                     |
| Payroll / Time & Payroll                  | B                   | Actor/Member           | Compliance/audit workloads.                                                     |
| Financial Ledger                          | B                   | Actor                  | Governance and forensics.                                                       |
| Tax / Compliance                          | B                   | Actor                  | Regulatory evidence.                                                            |

### 5.1 RoomPlan module (RoomScanSession, RoomModel, RoomObject, RoomSurface, RoomAnnotation, RoomExport, RoomMeasurement, RoomPlanPreset, RoomProcessingJob, RoomScanFile)
- **Audit pattern:** **A** (IDs only). Keep `createdByActorId?`, `updatedByActorId?`, `deletedByActorId?` as UUIDs with **no** Prisma relations to `Actor`/`Member`.
- Foreign keys to core modules (`Project`, `Estimate`, `DocumentGroup`) use composite `[tenantId, ...]` with `onDelete: Restrict` (for integrity) or `SetNull` if optional.
- Example (finalized) **RoomModel**:

```prisma
model RoomModel {
  // Identity & audit
  id                 String          @id @default(uuid(7)) @db.Uuid
  tenantId           String          @db.Uuid
  status             RoomModelStatus @default(ACTIVE) // example enum for lifecycle of generated geometry
  version            Int             @default(1)
  createdAt          DateTime        @default(now()) @db.Timestamptz(6)
  updatedAt          DateTime        @updatedAt @db.Timestamptz(6)
  deletedAt          DateTime?       @db.Timestamptz(6)
  auditCorrelationId String?         @db.Uuid
  dataClassification String          @default("CONFIDENTIAL") @db.VarChar(50)
  retentionPolicy    RetentionPolicy?

  // Actor audit (IDs only — no cross-relations for RoomPlan)
  createdByActorId   String?         @db.Uuid
  updatedByActorId   String?         @db.Uuid
  deletedByActorId   String?         @db.Uuid

  // Business
  sessionId          String?         @db.Uuid
  projectId          String?         @db.Uuid
  estimateId         String?         @db.Uuid
  documentGroupId    String?         @db.Uuid

  modelName          String          @db.VarChar(255)
  modelType          RoomModelType
  modelUrl           String?         @db.VarChar(2048)
  polygonCount       Int?
  surfaceArea        Decimal?        @db.Decimal(12, 2)
  volume             Decimal?        @db.Decimal(12, 2)
  unit               MeasurementUnit @default(METER)
  generatedAt        DateTime?       @db.Timestamptz(6)
  metadata           Json?
  tags               String[]

  // Relations (composite, tenant-scoped)
  tenant          Tenant           @relation(fields: [tenantId], references: [id], onDelete: Cascade)
  roomScanSession RoomScanSession? @relation(fields: [tenantId, sessionId], references: [tenantId, id], onDelete: SetNull)
  project         Project?         @relation(fields: [tenantId, projectId], references: [tenantId, id], onDelete: SetNull)
  estimate        Estimate?        @relation(fields: [tenantId, estimateId], references: [tenantId, id], onDelete: SetNull)
  documentGroup   DocumentGroup?   @relation(fields: [tenantId, documentGroupId], references: [tenantId, id], onDelete: SetNull)

  // Children
  RoomSurface     RoomSurface[]
  RoomObject      RoomObject[]
  RoomAnnotation  RoomAnnotation[]
  RoomExport      RoomExport[]
  RoomMeasurement RoomMeasurement[]

  // Indexes
  @@unique([tenantId, id])
  @@index([tenantId, sessionId])
  @@index([tenantId, projectId])
  @@index([tenantId, estimateId])
  @@index([tenantId, documentGroupId])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
}
```

> Note: Because we do **not** add Actor/Member back‑relations in RoomPlan, there are **no** reverse lists on `Actor`/`Member` (keeps those models lean).

### 5.2 Critical finance & payroll modules
- Use audit pattern **B** (full cross‑relations). Provide explicit named back‑relations on `Actor` or `Member`.
- Ensure FK fields used with `onDelete: SetNull` are **optional** to satisfy Prisma’s validator.
- Lock critical parent links with `onDelete: Restrict` where appropriate (e.g., `Invoice` → `Account`).

---

## 6) Validator Pitfalls & How to Fix

- **Prisma warning: “SetNull with required field”**  
  Make the FK field optional (`...?`) or switch to `NoAction`/`Restrict` as appropriate.

- **“Missing opposite relation field” errors**  
  When you add a relation (pattern **B**), you **must** add the **matching back‑relation** on the referenced model with the **same `@relation("Name")`**. If you’re using pattern **A**, do **not** declare the relation at all — just keep the UUID field.

- **Naming collisions in relations**  
  Give stable, explicit **relation names** (e.g., `"InvoiceCreatedByActor"`) to avoid accidental merges when you later add more relations.

---

## 7) Checklist for New Tables

- Keys & multi‑tenancy
  - `id uuid(7)` + `tenantId`
  - `Tenant` relation on cascade
  - `@@unique([tenantId, id])`
  - Consider `globalId` only for cross‑tenant visibility
- Governance & audit
  - `createdAt` / `updatedAt @updatedAt` (timestamptz(6))
  - Ensure all timestamp instants use `@db.Timestamptz(6)` consistently across models and examples
  - Soft delete fields if needed
  - Audit IDs (`createdByActorId`, etc.). Choose **A** or **B** pattern per module.
  - `auditCorrelationId`, `dataClassification`, `retentionPolicy` if governed data
  - **Pattern B rule:** If you declare relations to `Actor`/`Member`, you **must** add the matching back‑relation on the other model with the same `@relation("…")` name to avoid P1012
  - **SetNull rule:** `onDelete: SetNull` requires the FK field to be **optional** (`...?`). Otherwise Prisma will warn.
  - **Financial/legal anchors:** Default to `onDelete: Restrict` + **soft delete** on the parent to preserve audit trails.
- Constraints & indexes
  - Lead indexes with `tenantId`
  - Always index composite foreign keys used in relations: e.g. `@@index([tenantId, accountId])`, `@@index([tenantId, projectId])`, etc.
  - **RLS checklist:** All composite FKs must start with `[tenantId, ...]` and have corresponding tenant-first indexes for RLS performance.
  - Natural key uniqueness per tenant (citext preferred)
  - BRIN on `createdAt` where it helps
  - Human numbering: if you add a `*Number` field (e.g., `docNumber @db.Citext`), require `@@unique([tenantId, docNumber])`; when sharing sequences across docs, add a `DocumentGroup` relation and index it
- Types
  - Citext for human keys; Decimal for money; Date vs Timestamptz appropriately
  - Arrays for `tags` when useful, not mandatory
- Delete semantics
  - Cascade ownership trees
  - SetNull for optional histories (make FK optional)
  - Restrict for financial/legal integrity
- Migrations
  - Ensure extensions migration is applied before tables
  - Keep `uuid_v7_function.sql` in bootstrap set

---

## 8) Quick Reference: When to use cross‑relations

| Area                           | Pattern | Cross‑relations? | Notes                            |
| ------------------------------ | ------- | ---------------- | -------------------------------- |
| RoomPlan (RoomModel, etc.)     | A       | **No**           | IDs only; keep Actor/Member lean |
| Content/Notes/Docs aux         | A       | **No**           | Historical UUIDs are enough      |
| Finance (Invoice/AP/AR)        | B       | **Yes**          | Named relations + back‑relations |
| Revenue (Estimate/ChangeOrder) | B       | **Yes**          | Enforce SetNull with optional FK |
| HR/Payroll                     | B       | **Yes**          | Compliance/audit workloads       |
| Security/Audit trails          | B       | **Yes**          | Forensics and governance         |

---

## 9) Appendix: Minimal enums

```prisma
enum ExampleStatus {
  DRAFT
  ACTIVE
  INACTIVE
  ARCHIVED
}
enum DocStatus {
  DRAFT
  SENT
  PARTIALLY_PAID
  PAID
  VOID
  CANCELLED
}
```

---
**When to use onDelete: Cascade vs SetNull vs Restrict vs NoAction**
- Cascade: strict ownership trees (e.g., Tenant → children)
- SetNull: optional historical references (make FK optional)
- Restrict: core financial/legal links
- NoAction: only when DB already enforces desired behavior
¡Excelente pregunta! (Y minúscula corrección: en Prisma los valores son **Cascade**, **SetNull**, **Restrict** y **NoAction**).

# ¿Cuándo usar cada `onDelete`?

## 1) `onDelete: Cascade` — “si muere el padre, mueren sus hijos”

**Úsalo para relaciones de **propiedad estricta** (ownership tree)** donde el hijo no tiene sentido sin el padre.

* **Ejemplos en tu ERP**

  * `Tenant -> *` (casi todos los hijos): `onDelete: Cascade`
  * `Account -> AccountAddress[]`: `onDelete: Cascade`
  * `Invoice -> InvoiceLineItem[]`: `onDelete: Cascade`
* **Ventaja:** limpieza automática; evita huérfanos.
* **Riesgo:** borrado masivo accidental si no hay soft-delete. En críticos, combina con `deletedAt` y borra lógico primero.

```prisma
AccountAddress AccountAddress[] // hijo
// en AccountAddress
Account Account @relation(fields: [tenantId, accountId], references: [tenantId, id], onDelete: Cascade)
```

---

## 2) `onDelete: SetNull` — "si muere el padre, el vínculo se borra; el hijo queda"

**Úsalo para referencias **opcionales/históricas** que quieres conservar aunque desaparezca el padre.**
**Regla:** el campo FK **debe ser opcional** (`...?`) o Prisma te advertirá.

**IMPORTANTE - Composite Keys y Prisma Warnings:**

Cuando usas `onDelete: SetNull` con claves compuestas `[tenantId, foreignId]`, Prisma mostrará advertencias porque `tenantId` es requerido. **Estas advertencias son esperadas y deben ser ignoradas**:

- ✅ El comportamiento es **correcto** a nivel de base de datos
- ✅ PostgreSQL establecerá ambos campos (`tenantId` y `foreignId`) a NULL cuando se elimine el registro padre
- ✅ Esto representa correctamente la semántica del dominio: "opcional y removible"
- ⚠️ **NO cambies** `SetNull` a `Restrict` o `NoAction` solo para silenciar las advertencias
- ⚠️ El esquema debe coincidir con los requisitos del modelo de dominio, no con los diagnósticos del editor

* **Ejemplos en tu ERP**

  * Auditoría a `Actor`/`Member` (Pattern B): `createdByActorId?` con `onDelete: SetNull`
  * Referencias opcionales cross-module: `crmContactId?`, `billToAddressId?`, `ownerMemberId?`
  * Catálogos/globales no críticos: `paymentTermId?`, `territoryId?`, `customerSegmentId?`
  * Vínculos "resultado de" (cuando no son ancla legal): `Lead.convertedOpportunityId?`
  * Integraciones externas opcionales: `approvalRequestId?`, `eSignatureEnvelopeId?`
* **Ventaja:** preserva el registro hijo.
* **Riesgo:** puedes perder contexto si el padre se borra. Mantén trazas (`auditCorrelationId`, `hashToken`) si es sensible.

```prisma
// Ejemplo con clave simple
createdByActorId String? @db.Uuid
createdByActor   Actor?  @relation("AccountCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)

// Ejemplo con clave compuesta (genera warning - es esperado y correcto)
crmContactId String? @db.Uuid
crmContact CRMContact? @relation("EstimateContact", 
  fields: [tenantId, crmContactId], 
  references: [tenantId, id], 
  onDelete: SetNull) // ✅ Correcto - warning ignorable
```

---

## 3) `onDelete: Restrict` — “no permitas borrar el padre si tiene hijos”

**Úsalo para **anclas legales/financieras** donde **no debe romperse** la relación.**
Impide el `DELETE` del padre mientras existan hijos referenciándolo.

* **Ejemplos en tu ERP**

  * `Invoice -> Account` (si la factura requiere a su Account histórico intacto)
  * `LedgerEntry -> AccountingPeriod`
  * Cualquier documento fiscal/auditable que **no** debe sobrevivir sin su ancla
* **Ventaja:** protección fuerte de integridad.
* **Riesgo:** bloquea borrados; exige **soft delete** o archivado en el padre.

```prisma
accountId String @db.Uuid
Account   Account @relation(fields: [tenantId, accountId], references: [tenantId, id], onDelete: Restrict)
```

---

## 4) `onDelete: NoAction` — “deja que la BD/las políticas externas decidan”

**Úsalo cuando:**

* Ya manejas integridad vía **RLS, triggers o lógica de app**, y no quieres que Prisma/meta-datos toquen cascadas.

* Necesitas compatibilidad con datos legados o rutas de migración.

* Quieres fallar por FK a nivel DB **solo si aplica** (similar a `Restrict` en muchos motores), pero sin semántica explícita.

* **Ejemplos**

  * Relaciones entre módulos con políticas específicas donde no quieres side-effects automáticos.
  * Vínculos que a veces se permiten romper vía proceso batch controlado.

```prisma
primaryRep Member? @relation("AccountPrimaryRep",
  fields: [tenantId, primaryRepMemberId], references: [tenantId, id], onDelete: NoAction)
```

---

# Patrón de decisión (rápido)

1. **¿El hijo no tiene sentido sin el padre?** → **Cascade**
2. **¿El hijo debe sobrevivir si el padre se va y la FK es opcional?** → **SetNull**
3. **¿La relación es ancla legal/financiera que no se puede romper?** → **Restrict**
4. **¿Caso especial/legacy/políticas externas?** → **NoAction**

---

# Anti-patrones y tips

* **No uses `SetNull` con FK requerida** → Prisma te avisará. Haz la FK `...?`.
  * **Excepción**: Con claves compuestas `[tenantId, foreignId]`, Prisma advertirá sobre `tenantId` requerido **pero esto es correcto**. El campo FK (`foreignId`) debe ser opcional. Las advertencias se pueden ignorar.
* **Evita `Cascade` en entidades críticas** (facturas, asientos) → usa `Restrict` + soft-delete.
* **Tenancy primero**: todas las FKs compuestas deben iniciar con `[tenantId, …]` e índices que reflejen eso.
* **Consistencia por módulo**: aplica **Pattern A** (IDs sólo) o **Pattern B** (relaciones a Actor/Member) de forma uniforme.
* **Soft-delete**: en árboles con `Cascade`, normalmente **borra lógico** en el padre; si requieres borrar físico, hazlo en un job controlado.
* **Prisma warnings vs Domain correctness**: Prioriza la semántica del dominio sobre los diagnósticos del editor. `SetNull` con composite keys genera warnings esperados.

---

# Ejemplos concretos en tu ERP

**Owned child (propiedad):**
`Account -> AccountAddress[]` → `onDelete: Cascade`

**Catálogo global opcional:**
`Account.paymentTermId? -> PaymentTerm` → `onDelete: SetNull`

**Ancla financiera:**
`Invoice.accountId -> Account` → `onDelete: Restrict`

**Asignación CRM que quieres controlar tú:**
`Lead.assignedToMemberId? -> Member` → `onDelete: NoAction` (o `SetNull` si prefieres liberar la asignación)

**Referencias opcionales cross-module (composite keys):**
```prisma
// Estimate → CRM Contact (opcional, removible)
crmContactId String? @db.Uuid
crmContact CRMContact? @relation("EstimateContact", 
  fields: [tenantId, crmContactId], 
  references: [tenantId, id], 
  onDelete: SetNull) // ✅ Correcto - Prisma warning esperado

// Estimate → Member Owner (opcional, removible)
ownerMemberId String? @db.Uuid  
ownerMember Member? @relation("EstimateOwner",
  fields: [tenantId, ownerMemberId],
  references: [tenantId, id],
  onDelete: SetNull) // ✅ Correcto - permite desactivar member

// Estimate → External Modules (opcional, removible)  
approvalRequestId String? @db.Uuid
approvalRequest ApprovalRequest? @relation("EstimateApprovalRequest",
  fields: [tenantId, approvalRequestId],
  references: [tenantId, id],
  onDelete: SetNull) // ✅ Correcto - permite archivar aprobaciones
```

---
**This guide supersedes earlier drafts and should be the single reference for modeling choices across modules.**