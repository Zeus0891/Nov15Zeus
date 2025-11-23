Guía de diseño para todas las tablas del ERP:

* **GLOBAL**: Sin `tenantId`. Infraestructura de plataforma (identidad, authN, catálogo de permisos, registry de tenants, PublicLinkEngine, etc.).
* **TENANT**: Lleva `tenantId`. Datos internos del inquilino. Todo lo que está bajo RLS.
* **HYBRID**: Lleva `tenantId` + `globalId`. Datos del inquilino que también se exponen al exterior mediante `PublicLinkEngine` / Customer Portal.
  `globalId` es un **Business Global Identifier**, no un `FK` a una tabla GLOBAL.

En todos los casos usamos:

* `uuid(7)` para `id` (orden temporal para mejores BRIN/índices).
* Campos de ciclo de vida consistentes.
* Audit minimalista con IDs de `Actor` (y relaciones opcionales comentadas).
* Campos de gobernanza (`auditCorrelationId`, `dataClassification`).
* Índices tenant-first para RLS.

---

## 1. BASE TENANT ENTITY (BT)

> Usa este patrón para cualquier tabla **TENANT**: módulos internos, config de tenant, HR, finanzas, etc.

```prisma
model ExampleTenantEntity {
  // 🆔 Identity & Tenant
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  // 📊 Lifecycle
  status    String    @default("ACTIVE")  // usa un enum si lo necesitas
  version   Int       @default(1)
  createdAt DateTime  @default(now())     @db.Timestamptz(6)
  updatedAt DateTime  @updatedAt          @db.Timestamptz(6)
  deletedAt DateTime?                      @db.Timestamptz(6)

  // 👤 Minimal audit (solo UUIDs; relaciones a Actor SOLO en entidades PARENT críticas)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Governance
  auditCorrelationId String? @db.Uuid               // para correlacionar flujos multi-módulo
  dataClassification String  @default("INTERNAL") @db.VarChar(50)
  // retentionPolicy    RetentionPolicy?            // descomenta si tu módulo lo usa

  // 🔎 Observability (OPCIONAL: descomenta SOLO si agrega valor real)
  // traceId      String? @db.VarChar(64)
  // spanId       String? @db.VarChar(32)
  // authContext  String? @db.Text
  // hashToken    String? @db.VarChar(255)          // añade índice por tenant si lo consultas
  // metadata     Json?   @db.JsonB
  // recordSource String? @db.VarChar(50)           // API, IMPORT, SYSTEM
  // timezone     String? @db.VarChar(50)

  // 🔗 Required relations
  // tenant Tenant @relation("TenantToExampleTenantEntity", fields: [tenantId], references: [id], onDelete: Cascade)

  // 👥 Actor relations (ENABLE ONLY for CRITICAL PARENT entities)
  // createdByActor Actor? @relation("ExampleTenantEntityCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("ExampleTenantEntityUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("ExampleTenantEntityDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // Enable ONLY if you use these fields:
  // @@index([tenantId, hashToken])
  // @@index([tenantId, recordSource])
  // @@index([tenantId, timezone])
  // @@index([metadata], type: Gin)

  // 🗂️ Indexes & constraints (tenant-first)
  @@unique([tenantId, id])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([tenantId, auditCorrelationId])
  @@index([tenantId, dataClassification])

  // Ajusta el nombre de tabla física
  @@map("example_tenant_entity")
}
```

---

## 2. BASE HYBRID ENTITY (BH)

> Usa este patrón para tablas HYBRID: `Estimate`, `Invoice`, `Project`, `ChangeOrder`, `RFI`, `Submittal`, `Contract`, `Document`, etc.
> Lleva `tenantId` + `globalId`.
> **`globalId` es un ID de negocio compartido**, no un `FK` ni referencia al módulo GLOBAL.

```prisma
model ExampleHybridEntity {
  // 🆔 Identity, Tenant & Global Business Identifier
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  /// globalId: Global business identifier shared across Estimate/Project/Invoice/CO/etc.
  /// Not a foreign key. Not a reference to a GLOBAL module.
  /// Used for cross-module traceability, PublicLinkEngine analytics, and Portal visibility.
  globalId String @db.Uuid

  // 📊 Lifecycle
  status    String    @default("ACTIVE")
  version   Int       @default(1)
  createdAt DateTime  @default(now())     @db.Timestamptz(6)
  updatedAt DateTime  @updatedAt          @db.Timestamptz(6)
  deletedAt DateTime?                      @db.Timestamptz(6)

  // 👤 Minimal audit (solo UUIDs)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Governance
  auditCorrelationId String? @db.Uuid
  dataClassification String  @default("CONFIDENTIAL") @db.VarChar(50)

  // 🔎 Observability (OPCIONAL)
  // traceId      String? @db.VarChar(64)
  // spanId       String? @db.VarChar(32)
  // authContext  String? @db.Text
  // hashToken    String? @db.VarChar(255)
  // metadata     Json?   @db.JsonB
  // recordSource String? @db.VarChar(50)
  // timezone     String? @db.VarChar(50)

  // 🔗 Required relations
  // tenant Tenant @relation("TenantToExampleHybridEntity", fields: [tenantId], references: [id], onDelete: Cascade)

  // NOTA: globalId NO es FK. Si en algún caso necesitas un FK real, crea otro campo
  // por ejemplo: contractId, projectId, etc.

  // 👥 Actor relations (ENABLE ONLY for CRITICAL PARENT entities)
  // createdByActor Actor? @relation("ExampleHybridEntityCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("ExampleHybridEntityUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("ExampleHybridEntityDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // Enable ONLY if you use these fields:
  // @@index([tenantId, hashToken])
  // @@index([tenantId, recordSource])
  // @@index([tenantId, timezone])
  // @@index([metadata], type: Gin)

  // 🗂️ Indexes & constraints
  // un documento por globalId en cada tenant (ajusta según tu caso)
  @@unique([tenantId, globalId])
  @@unique([tenantId, id])
  @@index([globalId])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([tenantId, auditCorrelationId])
  @@index([tenantId, dataClassification])

  @@map("example_hybrid_entity")
}
```

---

## 3. BASE GLOBAL ENTITY (BG)

> Usa este patrón para tablas **GLOBAL**: `User`, `Actor`, `Session`, `Permission`, `AccessResource`, `Tenant`, `PublicLinkTemplate`, etc.
> No llevan `tenantId`.

```prisma
model ExampleGlobalEntity {
  // 🆔 Identity (no tenantId)
  id String @id @default(uuid(7)) @db.Uuid

  // 📊 Lifecycle
  status    String    @default("ACTIVE")
  version   Int       @default(1)
  createdAt DateTime  @default(now())     @db.Timestamptz(6)
  updatedAt DateTime  @updatedAt          @db.Timestamptz(6)
  deletedAt DateTime?                      @db.Timestamptz(6)

  // 👤 Minimal audit (UUIDs only)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Governance
  auditCorrelationId String? @db.Uuid
  dataClassification String  @default("PUBLIC") @db.VarChar(50)
  // retentionPolicy    RetentionPolicy?

  // 🔎 Observability (OPCIONAL)
  // traceId      String? @db.VarChar(64)
  // spanId       String? @db.VarChar(32)
  // authContext  String? @db.Text
  // hashToken    String? @db.VarChar(255)
  // metadata     Json?   @db.JsonB
  // recordSource String? @db.VarChar(50)

  // 👥 Actor relations (ENABLE ONLY for truly critical global entities)
  // createdByActor Actor? @relation("ExampleGlobalEntityCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("ExampleGlobalEntityUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("ExampleGlobalEntityDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // Enable ONLY if you use these fields:
  // @@index([hashToken])
  // @@index([recordSource])
  // @@index([metadata], type: Gin)

  // 🗂️ Indexes & constraints (global)
  @@index([status])
  @@index([deletedAt])
  @@index([createdAt], type: Brin)
  @@index([auditCorrelationId])
  @@index([dataClassification])

  @@map("example_global_entity")
}
```

---

## Cómo usar este archivo

1. **TENANT model nuevo**

   * Copia `ExampleTenantEntity` → renombra el modelo y el `@@map`.
   * Añade tus campos de negocio debajo de los bloques de comentarios.
   * Mantén `tenantId`, lifecycle, audit y governance tal cual.

2. **HYBRID model nuevo (con `globalId`)**

   * Copia `ExampleHybridEntity` → renombra modelo y `@@map`.
   * Usa `globalId` **solo como business identifier**, no como FK.
   * Añade tus campos (ej. `name`, `totalAmount`, `statusDomain`, etc.).

3. **GLOBAL model nuevo**

   * Copia `ExampleGlobalEntity` → renombra modelo y `@@map`.
   * No añadas `tenantId`.
   * Ajusta `dataClassification` si es más sensible (`INTERNAL`, `CONFIDENTIAL`, etc.).

4. **Opcionales**

   * Solo descomenta trazas (`traceId`, `metadata`, etc.) si vas a usarlas de verdad.
   * Solo añade relaciones a `Actor` en entidades críticas (User-level, seguridad, documentos legales clave).

Con este archivo puedes eliminar los dos templates anteriores y quedarte solo con este como **fuente de verdad** para todas las nuevas tablas.
