// ======================================================================
// FILE: prisma/schemas/templates/BASE_TEMPLATES.prisma
// Purpose: Enterprise base templates (BT, BH, BG) for an ERP multitenant
// Updated: 2025-11
//
// Cómo usar con Tables.md:
// - Para cada nombre de tabla en Tables.md:
//   • Si está en "Hybrid Tables": usa el template BH y REEMPLAZA `ExampleHybridEntity`.
//   • Si está en "Global Tables": usa el template BG y REEMPLAZA `ExampleGlobalEntity`.
//   • Si está en "Tenant Tables": usa el template BT y REEMPLAZA `ExampleTenantEntity`.
// - Sustituye los nombres de modelo y, si aplica, activa los bloques opcionales.
// - Mantén `generator` y `datasource` en `_base.prisma`.
//
// Convenciones clave (mejores prácticas Nov-2025):
// - BT (Tenant): siempre @@unique([tenantId, id]) y relación Tenant @ Cascade.
// - BH (Hybrid): requiere tenantId + globalId y @@unique([tenantId, globalId]).
// - BG (Global): sin tenantId; índices operativos básicos (status, deletedAt, createdAt BRIN).
// - onDelete: Cascade (dueño Tenant) | SetNull (FK opcionales) | Restrict (FK requeridas).
// - Índices: tenant-first en BT/BH; BRIN(createdAt) en tablas grandes.
// - Actor relations: SOLO en entidades PADRE críticas (no en hijos masivos).
// - Observabilidad (traceId, metadata, etc.): activar SOLO donde aporte valor real.
// ======================================================================


// ======================================================
// BT — Base Tenant (entidad perteneciente a un tenant)
// REEMPLAZA: ExampleTenantEntity -> <ModelName>
// ======================================================
model ExampleTenantEntity {
  // 🆔 Identidad & Tenant
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  // 📊 Ciclo de vida
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  // 👤 Auditoría mínima (UUIDs; relaciones a Actor solo en PADRES críticos)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Gobernanza
  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("INTERNAL") @db.VarChar(50)
  // retentionPolicy    RetentionPolicy?  // descomenta si tu módulo lo usa

  // 🔎 Observabilidad (OPCIONAL: activa solo si aporta valor)
  // traceId      String? @db.VarChar(64)
  // spanId       String? @db.VarChar(32)
  // authContext  String? @db.Text
  // hashToken    String? @db.VarChar(255) // indexa por tenant si lo consultas
  // metadata     Json?   @db.JsonB
  // recordSource String? @db.VarChar(50)  // API, IMPORT, SYSTEM
  // timezone     String? @db.VarChar(50)

  // 🔗 Relaciones requeridas
  tenant Tenant @relation("TenantToExampleTenantEntity", fields: [tenantId], references: [id], onDelete: Cascade)

  // 👥 Relaciones a Actor (ACTIVA SOLO en PADRES críticos)
  // createdByActor Actor? @relation("ExampleTenantEntityCreatedBy", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("ExampleTenantEntityUpdatedBy", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("ExampleTenantEntityDeletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // 🗂️ Índices & restricciones (tenant-first)
  @@unique([tenantId, id])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([tenantId, auditCorrelationId])
  @@index([tenantId, dataClassification])

  // Activa SOLO si usas estos campos:
  // @@index([tenantId, hashToken])
  // @@index([tenantId, recordSource])
  // @@index([tenantId, timezone])
  // @@index([metadata], type: Gin)

  // @@map("example_tenant_entities") // opcional: snake_case
}


// ======================================================
// BH — Base Hybrid (tenant-scoped + referencia global)
// Un registro por tenant por cada globalId (override/parametrización)
// REEMPLAZA: ExampleHybridEntity -> <ModelName>
// ======================================================
model ExampleHybridEntity {
  // 🆔 Identidad, Tenant y Global
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  globalId String @db.Uuid   // referencia a entidad BG

  // 📊 Ciclo de vida
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  // 👤 Auditoría mínima (UUIDs; relaciones a Actor solo en PADRES críticos)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Gobernanza
  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("INTERNAL") @db.VarChar(50)

  // 🔎 Observabilidad (OPCIONAL)
  // traceId      String? @db.VarChar(64)
  // spanId       String? @db.VarChar(32)
  // authContext  String? @db.Text
  // hashToken    String? @db.VarChar(255)
  // metadata     Json?   @db.JsonB
  // recordSource String? @db.VarChar(50)
  // timezone     String? @db.VarChar(50)

  // 🔗 Relaciones requeridas
  tenant Tenant @relation("TenantToExampleHybridEntity", fields: [tenantId], references: [id], onDelete: Cascade)

  // Relación a la entidad Global (ajusta el modelo real BG)
  // global ExampleGlobalEntity @relation(fields: [globalId], references: [id], onDelete: Restrict)

  // 👥 Relaciones a Actor (ACTIVA SOLO en PADRES críticos)
  // createdByActor Actor? @relation("ExampleHybridEntityCreatedBy", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("ExampleHybridEntityUpdatedBy", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("ExampleHybridEntityDeletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // 🗂️ Índices & restricciones
  @@unique([tenantId, globalId])   // un override por globalId en cada tenant
  @@index([globalId])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([tenantId, auditCorrelationId])
  @@index([tenantId, dataClassification])

  // Activa SOLO si usas estos campos:
  // @@index([tenantId, hashToken])
  // @@index([tenantId, recordSource])
  // @@index([tenantId, timezone])
  // @@index([metadata], type: Gin)

  // @@map("example_hybrid_entities")
}


// ======================================================
// BG — Base Global (maestros compartidos; sin tenantId)
// REEMPLAZA: ExampleGlobalEntity -> <ModelName>
// ======================================================
model ExampleGlobalEntity {
  // 🆔 Identidad
  id String @id @default(uuid(7)) @db.Uuid

  // 📊 Ciclo de vida
  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  // 👤 Auditoría mínima (UUIDs; relaciones a Actor solo si es crítico global)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // 🧠 Gobernanza
  auditCorrelationId String? @db.Uuid
  dataClassification String   @default("PUBLIC") @db.VarChar(50)
  // retentionPolicy    RetentionPolicy?

  // 🔎 Observabilidad (OPCIONAL)
  // traceId      String? @db.VarChar(64)
  // spanId       String? @db.VarChar(32)
  // authContext  String? @db.Text
  // hashToken    String? @db.VarChar(255)
  // metadata     Json?   @db.JsonB
  // recordSource String? @db.VarChar(50)

  // 👥 Relaciones a Actor (ACTIVA SOLO si aplica)
  // createdByActor Actor? @relation("ExampleGlobalEntityCreatedBy", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // updatedByActor Actor? @relation("ExampleGlobalEntityUpdatedBy", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  // deletedByActor Actor? @relation("ExampleGlobalEntityDeletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)

  // 🗂️ Índices & restricciones (sin tenant)
  @@index([status])
  @@index([deletedAt])
  @@index([createdAt], type: Brin)
  @@index([auditCorrelationId])
  @@index([dataClassification])

  // Activa SOLO si usas estos campos:
  // @@index([hashToken])
  // @@index([recordSource])
  // @@index([metadata], type: Gin)

  // @@map("example_global_entities")
}


// ======================================================================
// 📌 FK Patterns — Snippets listos para copiar en tus tablas generadas
// ======================================================================

// 1) RELACIÓN TENANT-SCOPED (composite) — OPTIONAL + SetNull
//    Usa este patrón para referenciar padres BT desde BT/BH.
//    Mantiene RLS-friendly joins y borrado seguro.
model _ExampleOptionalRef {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  parentId String? @db.Uuid
  parent   ExampleTenantEntity? @relation(fields: [tenantId, parentId], references: [tenantId, id], onDelete: SetNull)

  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  @@unique([tenantId, id])
  @@index([tenantId, parentId])
}

// 2) RELACIÓN TENANT-SCOPED (composite) — REQUIRED + Restrict
//    Úsalo cuando la FK NO es nullable. Evita SetNull en requeridas.
model _ExampleRequiredRef {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  parentId String @db.Uuid
  parent   ExampleTenantEntity @relation(fields: [tenantId, parentId], references: [tenantId, id], onDelete: Restrict)

  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  @@unique([tenantId, id])
  @@index([tenantId, parentId])
}

// 3) RELACIÓN A GLOBAL (BG) — FK simple (sin tenantId)
//    Úsala desde BT/BH a maestros globales (p. ej., Currency, PaymentTerm global).
model _ExampleGlobalRef {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  globalThingId String? @db.Uuid
  globalThing   ExampleGlobalEntity? @relation(fields: [globalThingId], references: [id], onDelete: Restrict)

  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  @@unique([tenantId, id])
  @@index([globalThingId])
}

// 4) ENTIDAD HIJO de ALTO VOLUMEN (sin relaciones a Actor; UUIDs sí)
//    Úsalo para line items, attachments, logs, etc.
model _ExampleChildLightweight {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid

  status    String   @default("ACTIVE")
  version   Int      @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt       @db.Timestamptz(6)
  deletedAt DateTime?                 @db.Timestamptz(6)

  // Audit UUIDs (sin relaciones @relation para performance)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid

  // Parent BT composite FK
  parentId String @db.Uuid
  parent   ExampleTenantEntity @relation(fields: [tenantId, parentId], references: [tenantId, id], onDelete: Cascade)

  tenant Tenant @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  @@unique([tenantId, id])
  @@index([tenantId, parentId])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
}
