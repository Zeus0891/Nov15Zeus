# 🚀 GitHub Copilot Instructions for Nov15Zeus ERP

## 📋 Project Overview
This is a **multi-tenant ERP system** built with **Prisma ORM** and **PostgreSQL**. Follow these instructions for consistent, production-ready code generation that aligns with our enterprise architecture.

**📊 Architecture Scale**: 622 total models across 3 scopes:
- **Global Models**: 33 tables (shared across all tenants)
- **Hybrid Models**: 20 tables (tenant-scoped with global linkage) 
- **Tenant Models**: 569 tables (tenant-isolated business data)

See complete model inventory in [`Tables.v2.md`](../structure/Tables.v2.md)
See complete estimate flow [`Estimate_Flow_CORRECTED.md`](../files2/Estimate_Flow_Corrected.md)
See complete Estimate diagram in [`ESTIMATE_ARCHITECTURE_DIAGRAM.md`](../files2/ESTIMATE_ARCHITECTURE_DIAGRAM.md)

---

## 🏗️ Core Architecture Principles

### Multi-Tenant Pattern (Global / Tenant / Hybrid Scopes)

#### **Global Models** (No tenantId)
Identity and system-wide entities that exist across all tenants (33 models):
```prisma
model Actor {
  id String @id @default(uuid(7)) @db.Uuid
  // NO tenantId - global scope
}
model User {
  id String @id @default(uuid(7)) @db.Uuid  
  // NO tenantId - global scope
}
model Tenant {
  id String @id @default(uuid(7)) @db.Uuid
  // NO tenantId - root entity
}
```

**Complete Global Models**: AIModel, AIModelVersion, AIPromptTemplate, AccessResource, AccountLockout, Actor, AuthFactor, AuthFactorChallenge, IdentityProvider, PasswordResetToken, Permission, RecoveryCode, SSOSession, SecurityEvent, Session, Tenant, TenantBranding, TenantComplianceSetting, TenantDomain, TenantFeatureFlag, TenantHistoryEvent, TenantModule, TenantSettings, TenantSubscription, TenantUsageRecord, User, UserApiKey, UserDevice, UserDeviceHistory, UserHistoryEvent, UserInvitation, UserProfile, UserSetting

#### **Tenant-Scoped Models** (Have tenantId)
Business entities that belong to specific tenants (569 models):
```prisma
model Member {
  id String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid  // ✅ Tenant-scoped
  @@unique([tenantId, id])  // Required for tenant isolation
}
```

**Examples**: AIAction, AIJob, AccessPolicy, BankAccount, CRMAccount, CRMContact, Employee, ExpenseReport, InventoryItem, Member, ProjectTask, PurchaseOrder, Timesheet, WorkOrder, etc. (see complete list in Tables.v2.md)

#### **Hybrid Models (BH Pattern)**
Tenant-scoped but with global linkage for cross-tenant traceability (20 models):
```prisma
model Estimate {
  id String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  globalId String @db.Uuid  // ✅ Cross-tenant 1:1:1 traceability
  @@unique([tenantId, id])
  @@unique([tenantId, globalId])
  @@index([globalId])  // Global lookups
}
```

**Complete Hybrid Models**: CRMEmail, CRMMessageThread, ChangeOrder, CustomerPortalSession, CustomerPortalUser, Dashboard, Document, ESignatureEnvelope, EmailCampaign, EmailMessage, Estimate, IntegrationWebhookDelivery, Invoice, MessageThread, Notification, PhoneCall, Project, RFI, SMSMessage, Submittal

### Relationship Patterns by Model Scope

#### **Tenant-to-Tenant Relations** (Composite Keys)
```prisma
// Between tenant-scoped models - use composite keys
estimate Estimate @relation(fields: [tenantId, estimateId], references: [tenantId, id], onDelete: Cascade)
```

#### **Tenant-to-Global Relations** (Simple Keys)
```prisma
// From tenant model to global model - use simple key only
createdByActorId String? @db.Uuid
createdByActor Actor? @relation("EstimateCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
```

### Identity & Audit Standards
- Primary key: `id String @id @default(uuid(7)) @db.Uuid`
- Timestamps: `@db.Timestamptz(6)` for all DateTime fields
- Actor audit: `createdByActorId?`, `updatedByActorId?`, `deletedByActorId?` (all `String? @db.Uuid`)
- Governance: `auditCorrelationId`, `dataClassification`, `retentionPolicy`

---

## 🔗 Delete Semantics (Critical Rules)

### `onDelete: Cascade` - Ownership Trees
Use when child cannot exist without parent:
```prisma
// Parent owns children completely
invoiceLineItems InvoiceLineItem[] // child model
// In InvoiceLineItem:
invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
```

### `onDelete: SetNull` - Optional Historical References
Use for optional references that should survive parent deletion:
```prisma
// Optional contact (can be removed)
crmContactId String? @db.Uuid  // ✅ MUST be optional
crmContact CRMContact? @relation("EstimateContact", fields: [tenantId, crmContactId], references: [tenantId, id], onDelete: SetNull)  // ✅ Correct - preserves record when contact deleted
```

**CRITICAL**: When using composite keys with SetNull, Prisma warnings about required `tenantId` are **EXPECTED and CORRECT**. DO NOT change to Restrict/NoAction to silence warnings.

### `onDelete: Restrict` - Financial/Legal Anchors
Use when relationship must never be broken:
```prisma
// Account must exist for invoice (financial integrity)
crmAccountId String @db.Uuid  // Required field
crmAccount CRMAccount @relation("EstimateAccount", fields: [tenantId, crmAccountId], references: [tenantId, id], onDelete: Restrict)  // ✅ Prevents account deletion if invoices exist
```

### `onDelete: NoAction` - Legacy/Special Cases
Use only when DB/external systems handle integrity:
```prisma
// Special business logic handles this relationship
specialRef SpecialEntity? @relation(fields: [tenantId, specialId], references: [tenantId, id], onDelete: NoAction)
```

---

## 👤 Actor & Member Relations Patterns

### Pattern A: Lightweight Audit (Supporting Entities)
Use for **supporting/auxiliary models** - IDs only, no Prisma relations:
```prisma
model EstimateComment {
  // Audit IDs only - no relations
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid  
  deletedByActorId String? @db.Uuid
  
  // NO Actor relations - Pattern A
  // Keep Actor/Member models lean for non-critical entities
}

model EstimateAttachment {
  // Same Pattern A - lightweight audit for attachments
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
}
```

### Pattern B: Full Cross-Relations (Critical Financial Entities)
Use for **critical revenue/financial entities** including all line-item financial models:
```prisma
model Estimate {  // Critical revenue entity
  // Actor audit with full relations
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // Full cross-relations (Pattern B)
  createdByActor Actor? @relation("EstimateCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  updatedByActor Actor? @relation("EstimateUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  deletedByActor Actor? @relation("EstimateDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)
}

model EstimateLineItem {  // Critical business entity with attachments
  // Same Pattern B implementation
  createdByActor Actor? @relation("EstimateLineItemCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  updatedByActor Actor? @relation("EstimateLineItemUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  deletedByActor Actor? @relation("EstimateLineItemDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)
}

model EstimateTax {  // Financial child entity - Pattern A
  // Actor audit IDs only (no cross-relations)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // NO Actor relations - Pattern A keeps Actor model lean
}

model EstimateDiscount {  // Financial child entity - Pattern A for Actor, Pattern B for Member approval
  // Actor audit (Pattern A - IDs only)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // NO Actor cross-relations - Pattern A for audit
  
  // Member approval workflow (tenant-scoped composite key)
  approvedByMemberId String? @db.Uuid
  approvedByMember Member? @relation("EstimateDiscountApprover", fields: [tenantId, approvedByMemberId], references: [tenantId, id], onDelete: SetNull)  // ✅ Preserves discount when member deactivated
}
```

**Opposite Relations Required**: When using Pattern B, MUST add back-relations:
```prisma
// In Actor model (identity.prisma) - Global scope, no tenantId
model Actor {
  // Pattern B relations - only for critical parent entities
  estimatesCreated Estimate[] @relation("EstimateCreatedByActor")
  estimatesUpdated Estimate[] @relation("EstimateUpdatedByActor") 
  estimatesDeleted Estimate[] @relation("EstimateDeletedByActor")
  
  estimateLineItemsCreated EstimateLineItem[] @relation("EstimateLineItemCreatedByActor")
  estimateLineItemsUpdated EstimateLineItem[] @relation("EstimateLineItemUpdatedByActor")
  estimateLineItemsDeleted EstimateLineItem[] @relation("EstimateLineItemDeletedByActor")
  
  // NO relations for Pattern A entities (EstimateTax, EstimateDiscount, EstimateFee, etc.)
  // This keeps Actor model lean and prevents relation bloat
}

// In Member model (membership.prisma) - Tenant-scoped
model Member {
  id String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // Business workflow relations (approval chains)
  ownedEstimates    Estimate[]         @relation("EstimateOwner")
  approvedDiscounts EstimateDiscount[] @relation("EstimateDiscountApprover")
  approvedFees      EstimateFee[]      @relation("EstimateFeeApprover")
}
```

---

## 📊 Pattern Decision Guide

| Module/Entity Type | Pattern | Actor Relations | Example Models |
|-------------------|---------|-----------------|----------------|
| **Critical Revenue** | B | Full relations | `Estimate`, `EstimateLineItem` |
| **Financial Line Items** | A | IDs only | `EstimateTax`, `EstimateDiscount`, `EstimateFee` |
| **Content/Notes** | A | IDs only | `EstimateComment`, `EstimateAssumption` |
| **Attachments** | A | IDs only | `EstimateAttachment`, `EstimateExclusion` |
| **Room Planning** | A | IDs only | `RoomModel`, `RoomScanSession` |
| **AI/Analytics** | A | IDs only | ML jobs, embeddings |

---

## 🗂️ Model Templates

### Standard Tenant-Scoped Entity Template
```prisma
model ExampleEntity {
  // 🆔 Identity & Tenant
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // 📊 Lifecycle
  status    ExampleStatus @default(DRAFT)
  version   Int           @default(1)
  createdAt DateTime      @default(now()) @db.Timestamptz(6)
  updatedAt DateTime      @updatedAt @db.Timestamptz(6)
  deletedAt DateTime?     @db.Timestamptz(6)
  
  // 👤 Actor Attribution (Pattern A - IDs only)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // 🧠 Governance
  auditCorrelationId String? @db.Uuid
  dataClassification EstimateDataClassification @default(CONFIDENTIAL)
  retentionPolicy    RetentionPolicy?
  recordSource       String? @db.VarChar(50)
  
  // 💼 Business Fields
  name        String  @db.VarChar(255)
  description String? @db.Text
  metadata    Json?   @db.JsonB
  
  // Parent relationship (optional - remove if not needed)
  parentId String? @db.Uuid
  
  // 🔗 Relations
  tenant   Tenant @relation("TenantToExampleEntity", fields: [tenantId], references: [id], onDelete: Cascade)
  parent   Parent? @relation(fields: [tenantId, parentId], references: [tenantId, id], onDelete: SetNull)
  
  // 📏 Constraints & Indexes
  @@unique([tenantId, id])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([tenantId, parentId])  // Parent relationship
  @@index([createdAt], type: Brin)
  @@index([tenantId, auditCorrelationId])
  @@map("example_entities")
}
```

### Global Entity Template (No tenantId)
```prisma
model GlobalEntity {
  // 🆔 Identity (Global scope - no tenantId)
  id String @id @default(uuid(7)) @db.Uuid
  
  // 📊 Lifecycle
  status    GlobalEntityStatus @default(ACTIVE)
  version   Int                @default(1)
  createdAt DateTime           @default(now()) @db.Timestamptz(6)
  updatedAt DateTime           @updatedAt @db.Timestamptz(6)
  deletedAt DateTime?          @db.Timestamptz(6)
  
  // 👤 Actor Attribution (Optional for global entities)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // 🧠 Governance
  auditCorrelationId String? @db.Uuid
  dataClassification EstimateDataClassification @default(PUBLIC)
  
  // 💼 Business Fields
  name        String  @db.VarChar(255)
  description String? @db.Text
  
  // 📏 Constraints & Indexes (No tenant scoping)
  @@index([status])
  @@index([deletedAt])
  @@index([createdAt], type: Brin)
  @@map("global_entities")
}
```

### Financial Entity Template (Pattern B)
```prisma
model CriticalFinancialEntity {
  // 🆔 Identity & Tenant
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // 📊 Lifecycle
  status    FinancialEntityStatus @default(ACTIVE)
  version   Int                   @default(1)
  createdAt DateTime              @default(now()) @db.Timestamptz(6)
  updatedAt DateTime              @updatedAt @db.Timestamptz(6)
  deletedAt DateTime?             @db.Timestamptz(6)
  
  // 👤 Actor Attribution (Pattern B - Full relations)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // Full actor cross-relations (tenant-to-global)
  createdByActor Actor? @relation("EntityCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  updatedByActor Actor? @relation("EntityUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  deletedByActor Actor? @relation("EntityDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)
  
  // 🧠 Governance
  auditCorrelationId String? @db.Uuid
  dataClassification EstimateDataClassification @default(CONFIDENTIAL)
  retentionPolicy    RetentionPolicy?
  recordSource       String? @db.VarChar(50)
  
  // Member relations for approvals (tenant-to-tenant composite key)
  approvedByMemberId String? @db.Uuid
  approvedByMember Member? @relation("EntityApprover", fields: [tenantId, approvedByMemberId], references: [tenantId, id], onDelete: SetNull)
    
  // 💰 Financial Fields
  totalAmount Decimal @default(0) @db.Decimal(12, 2)
  currencyCode String @default("USD") @db.Char(3)
  
  // 🔗 Relations
  tenant Tenant @relation("TenantToCriticalFinancialEntity", fields: [tenantId], references: [id], onDelete: Restrict)
  
  // 📏 Constraints & Indexes
  @@unique([tenantId, id])
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  @@index([tenantId, approvedByMemberId])
  @@map("critical_financial_entities")
}
```

---

## 💰 Financial Field Standards

### Money & Decimals
```prisma
// Standard financial precision
totalAmount    Decimal @default(0) @db.Decimal(12, 2)  // Standard money
taxRate        Decimal @default(0) @db.Decimal(8, 4)   // Percentage rates  
quantity       Decimal @db.Decimal(10, 4)              // Quantities
exchangeRate   Decimal? @db.Decimal(10, 6)             // Currency rates
```

### Currency & Internationalization
```prisma
currencyCode String @default("USD") @db.Char(3)        // ISO 4217
timezone     String? @db.VarChar(50)                   // Timezone context
```

---

## 🔍 Indexing Strategy

### Required Indexes (Always Include)
```prisma
@@unique([tenantId, id])                    // Primary constraint
@@index([tenantId, status])                 // Status filtering
@@index([tenantId, deletedAt])              // Soft delete filtering
@@index([createdAt], type: Brin)            // Temporal clustering
@@index([tenantId, auditCorrelationId])     // Governance queries
@@index([tenantId, dataClassification])     // Data governance
```

### Business Logic Indexes
```prisma
@@index([tenantId, parentId])               // Parent relationship
@@index([tenantId, ownerMemberId])          // Ownership queries
@@index([tenantId, approvedByMemberId])     // Approval tracking
@@index([metadata], type: Gin)             // JSON search
```

---

## ⚠️ Common Anti-Patterns to Avoid

### ❌ Wrong Delete Semantics
```prisma
// DON'T: SetNull with required field
requiredField String @db.Uuid  // Required but using SetNull
parent Parent? @relation(fields: [requiredField], references: [id], onDelete: SetNull)

// DON'T: Cascade on critical financial links  
account Account @relation(fields: [accountId], references: [id], onDelete: Cascade)
```

### ❌ Mixing Audit Patterns
```prisma
// DON'T: Mix Pattern A and B in same module
model BadExample {
  createdByActorId String? @db.Uuid          // Pattern A (IDs only)
  createdByActor Actor? @relation(...)       // Pattern B (relations) - INCONSISTENT!
}
```

### ❌ Missing Opposite Relations
```prisma
// DON'T: Declare relation without opposite
model Child {
  parent Parent @relation("ChildToParent", ...)  // Missing opposite on Parent!
}
```

### ❌ Global Unique Constraints
```prisma
// DON'T: Global uniqueness (breaks multi-tenancy)
@@unique([code])  // Global constraint

// DO: Tenant-scoped uniqueness  
@@unique([tenantId, code])  // ✅ Proper multi-tenant constraint
```

---

## 🚀 Business Logic Guidelines

### Status Enums
Always use enums for status fields:
```prisma
enum EstimateStatus {
  DRAFT
  PENDING_INTERNAL_APPROVAL
  PENDING_CLIENT_REVIEW
  CLIENT_APPROVED
  APPROVED
  CONVERTED
  CANCELED
  DELETED
}
```

### Lifecycle Events
Track major transitions:
```prisma
model EstimateHistoryEvent {
  eventType EstimateEventType  // ESTIMATE_CREATED, CLIENT_APPROVED, etc.
  timestamp DateTime @default(now()) @db.Timestamptz(6)
  actorId   String? @db.Uuid
  metadata  Json? @db.JsonB
}
```

### Attachment Patterns
Line-item scoped attachments (up to 5):
```prisma
model EstimateAttachment {
  // 🆔 Identity & Tenant
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // 📊 Lifecycle
  createdAt DateTime  @default(now()) @db.Timestamptz(6)
  updatedAt DateTime  @updatedAt @db.Timestamptz(6)
  deletedAt DateTime? @db.Timestamptz(6)
  
  // 👤 Pattern A - IDs only
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // 💼 Business Fields
  parentType    EstimateAttachmentParent @default(LINE_ITEM)
  lineItemId    String? @db.Uuid  // Line-item scoped
  estimateId    String @db.Uuid   // Required parent estimate
  attachmentUrl String @db.VarChar(2048)
  fileName      String @db.VarChar(255)
  fileSize      Int?
  mimeType      String? @db.VarChar(100)
  
  // 🔗 Relations
  tenant   Tenant   @relation("TenantToEstimateAttachment", fields: [tenantId], references: [id], onDelete: Cascade)
  estimate Estimate @relation(fields: [tenantId, estimateId], references: [tenantId, id], onDelete: Cascade)
  
  // 📏 Constraints & Indexes
  @@unique([tenantId, id])
  @@index([tenantId, lineItemId])  // Line item attachments
  @@index([tenantId, estimateId])  // Estimate attachments
  @@map("estimate_attachments")
}
```

---

## 📝 Code Generation Examples

When generating Prisma models, follow these patterns:

### For Critical Parent Entities (Pattern B)
```prisma
// Pattern B - Critical parent entities with full Actor relations
model Estimate {
  id String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // Pattern B: Full Actor relations for critical revenue entity
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  createdByActor Actor? @relation("EstimateCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  updatedByActor Actor? @relation("EstimateUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  deletedByActor Actor? @relation("EstimateDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)
  
  // Business fields...
}
```

### For Financial Child Entities (Pattern A)
```prisma
// Pattern A - Financial child entities (IDs only audit)
model EstimateTax {
  id String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // Lifecycle
  status EstimateTaxStatus @default(ACTIVE)
  version Int @default(1)
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt @db.Timestamptz(6)
  deletedAt DateTime? @db.Timestamptz(6)
  
  // Pattern A: Actor audit IDs only (no cross-relations)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // Governance
  auditCorrelationId String? @db.Uuid
  dataClassification EstimateDataClassification @default(CONFIDENTIAL)
  retentionPolicy RetentionPolicy?
  recordSource String? @db.VarChar(50)
  
  // Business fields
  estimateId String @db.Uuid
  taxName String @db.VarChar(100)
  taxRate Decimal @default(0) @db.Decimal(8, 4)
  taxAmount Decimal @default(0) @db.Decimal(12, 2)
  
  // Relations
  tenant Tenant @relation("TenantToEstimateTax", fields: [tenantId], references: [id], onDelete: Restrict)
  estimate Estimate @relation(fields: [tenantId, estimateId], references: [tenantId, id], onDelete: Cascade)
  
  @@unique([tenantId, id])
  @@index([tenantId, estimateId])
  @@map("estimate_taxes")
}

model EstimateDiscount {
  // Pattern A for Actor audit + Member approval workflow
  id String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // Pattern A: Actor audit IDs only (no cross-relations)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // Member approval (tenant-scoped composite key)
  approvedByMemberId String? @db.Uuid
  approvedByMember Member? @relation("EstimateDiscountApprover", fields: [tenantId, approvedByMemberId], references: [tenantId, id], onDelete: SetNull)
    
  // Business fields
  estimateId String @db.Uuid
  discountName String @db.VarChar(100)
  discountAmount Decimal @default(0) @db.Decimal(12, 2)
  
  // Relations
  tenant Tenant @relation("TenantToEstimateDiscount", fields: [tenantId], references: [id], onDelete: Restrict)
  estimate Estimate @relation(fields: [tenantId, estimateId], references: [tenantId, id], onDelete: Cascade)
  
  @@unique([tenantId, id])
  @@index([tenantId, estimateId])
  @@map("estimate_discounts")
}
```

### For Supporting Entities (Pattern A)
```prisma
// Pattern A - Supporting entities (comments, attachments, etc.)
model EstimateComment {
  id String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // Pattern A: IDs only - no Actor relations
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // Business fields
  estimateId String @db.Uuid
  commentText String @db.Text
  isInternal Boolean @default(true)
  
  // Relations
  tenant Tenant @relation("TenantToEstimateComment", fields: [tenantId], references: [id], onDelete: Cascade)
  estimate Estimate @relation(fields: [tenantId, estimateId], references: [tenantId, id], onDelete: Cascade)
  
  @@unique([tenantId, id])
  @@index([tenantId, estimateId])
  @@map("estimate_comments")
}
```

---

## ✅ Validation Checklist

Before generating any Prisma model, ensure:

### Multi-Tenant Compliance
- [ ] Correct scope: Global (no tenantId), Tenant-scoped (has tenantId), or Hybrid (tenantId + globalId)
- [ ] Tenant-scoped models have `@@unique([tenantId, id])` constraint
- [ ] Composite foreign keys use `[tenantId, foreignId]` format for tenant-to-tenant relations
- [ ] Simple foreign keys for tenant-to-global relations (Actor, User references)

### Relationship & Delete Semantics  
- [ ] Appropriate delete semantics: Cascade (ownership), SetNull (optional), Restrict (financial integrity)
- [ ] Actor audit pattern consistently applied (Pattern A vs B, not mixed within same module)
- [ ] Opposite relations declared when using Pattern B (full Actor cross-relations)
- [ ] Member approval relations use composite keys `[tenantId, memberId]`

### Data Standards
- [ ] Proper indexing strategy: tenant scoping, status filtering, temporal clustering
- [ ] Enum types for all status/classification fields (no plain strings)
- [ ] Financial fields use correct Decimal precision (`@db.Decimal(12, 2)` for money)
- [ ] Timestamps use `@db.Timestamptz(6)` with proper defaults
- [ ] Governance fields: auditCorrelationId, dataClassification enum, retentionPolicy

---

## 🎯 Success Metrics

Code generated following these instructions should:
- ✅ Pass Prisma validation without errors
- ✅ Show only expected SetNull warnings (ignore composite key warnings)
- ✅ Maintain proper multi-tenant isolation
- ✅ Enable efficient RLS queries
- ✅ Support comprehensive audit trails
- ✅ Follow enterprise governance standards

---

## 🔧 Development Notes

### Expected Prisma Warnings
```
Warning: Using `onDelete: SetNull` with composite foreign keys may cause issues
```
**This warning is EXPECTED and CORRECT**. Our architecture prioritizes:
1. **Domain Semantics**: Optional references should survive parent deletion
2. **Business Continuity**: Historical records remain intact when related entities are removed
3. **Multi-tenant Integrity**: Composite keys ensure proper tenant isolation under RLS

**Action**: Ignore these warnings. Do NOT change to `Restrict` or `NoAction` to silence them.

### Common Prisma Commands
```bash
# Generate client after schema changes
npx prisma generate

# Create and apply migration  
npx prisma migrate dev --name "feature-name"

# Reset development database (DEV ONLY)
npx prisma migrate reset --force

# View database in Prisma Studio
npx prisma studio
```

Remember: **The schema prioritizes enterprise domain semantics over editor diagnostics**. Business requirements drive technical implementation, not tooling preferences.