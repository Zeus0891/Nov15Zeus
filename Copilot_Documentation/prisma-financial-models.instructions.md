---
applyTo: "prisma/schemas/{estimate,invoice,project,billing,payment*}.prisma"
excludeAgent: ""
---

# Financial Module Prisma Patterns

**Purpose**: Enforce consistency across financial modules (Estimate, Invoice, Project, Billing, Payments)  
**Scope**: Financial documents, revenue cycle, billing, AR  
**Last Updated**: November 16, 2025

---

## 🚨 CRITICAL: CRM Model Names (Always Use CRM Prefix)

**Source of Truth**: `Modules_Structure.md` lines 48-50

```
## crmcore.prisma
CRMAccount  ← Correct model name
CRMContact  ← Correct model name
CRMAddress  ← Correct model name
```

### ✅ CORRECT Usage:
```prisma
// Field names (no prefix)
crmAccountId    String  @db.Uuid
crmContactId    String? @db.Uuid
billToAddressId String? @db.Uuid

// Model names (WITH CRM prefix)
crmAccount CRMAccount @relation(
  "EstimateAccount",
  fields: [tenantId, crmAccountId],
  references: [tenantId, id],
  onDelete: Restrict
)

crmContact CRMContact? @relation(
  "EstimateContact",
  fields: [tenantId, crmContactId],
  references: [tenantId, id],
  onDelete: SetNull
)
```

### ❌ WRONG Usage (Don't Do This):
```prisma
// ❌ These models don't exist
crmAccount Account @relation(...)
crmContact Contact @relation(...)
billToAddress AccountAddress? @relation(...)
```

---

## 📊 Cross-Module Consistency Rules

### 1. Governance Fields (Same Names, Module-Specific Enums)

**Pattern**: Field names identical, enum types module-specific

```prisma
// ✅ CORRECT - Same field names everywhere
auditCorrelationId String?   @db.Uuid
retentionPolicy    RetentionPolicy?
metadata           Json?      @db.JsonB
timezone           String?    @db.VarChar(50)

// Module-specific enums (Estimate example)
dataClassification EstimateDataClassification @default(CONFIDENTIAL)
recordSource       EstimateRecordSource?

// Invoice uses different enum types
dataClassification InvoiceDataClassification @default(CONFIDENTIAL)
recordSource       InvoiceRecordSource?

// Project uses different enum types
dataClassification ProjectDataClassification @default(CONFIDENTIAL)
recordSource       ProjectRecordSource?
```

**Rule**: NEVER mix enums between modules. Keep field names identical.

---

### 2. CRM Linkage (Exact Field Names, Correct Model Names)

**Pattern**: Standard CRM field set for all revenue documents

```prisma
// ✅ CORRECT - Use these exact field names
crmAccountId    String  @db.Uuid  // REQUIRED for revenue docs
crmContactId    String? @db.Uuid  // OPTIONAL
billToAddressId String? @db.Uuid  // OPTIONAL
ownerMemberId   String? @db.Uuid  // OPTIONAL

// Relations (always use CRM* model names)
crmAccount CRMAccount @relation(
  "ModuleNameAccount",
  fields: [tenantId, crmAccountId],
  references: [tenantId, id],
  onDelete: Restrict  // Financial anchor
)

crmContact CRMContact? @relation(
  "ModuleNameContact",
  fields: [tenantId, crmContactId],
  references: [tenantId, id],
  onDelete: SetNull   // Optional reference
)

billToAddress CRMAddress? @relation(
  "ModuleNameBillToAddress",
  fields: [tenantId, billToAddressId],
  references: [tenantId, id],
  onDelete: SetNull
)

ownerMember Member? @relation(
  "ModuleNameOwner",
  fields: [tenantId, ownerMemberId],
  references: [tenantId, id],
  onDelete: SetNull
)
```

**Critical Notes**:
- `crmAccountId` is REQUIRED (not nullable) for all revenue documents
- Always use composite keys `[tenantId, fieldId] → [tenantId, id]`
- Financial anchors (crmAccount) use `onDelete: Restrict`
- Optional references use `onDelete: SetNull`

---

### 3. Financial Header Totals (Aligned Types Across Modules)

**Pattern**: Identical precision and defaults for monetary fields

```prisma
// ✅ CORRECT - Use exact same types
currencyCode   String  @db.Char(3)  // ISO 4217: USD, EUR, CAD
subtotalAmount Decimal @default(0) @db.Decimal(12, 2)
discountAmount Decimal @default(0) @db.Decimal(12, 2)
taxAmount      Decimal @default(0) @db.Decimal(12, 2)
feeAmount      Decimal @default(0) @db.Decimal(12, 2)
totalAmount    Decimal @default(0) @db.Decimal(12, 2)
totalQuantity  Decimal @default(0) @db.Decimal(10, 4)
lineItemCount  Int     @default(0)

// Project-specific additions (budget vs actual)
budgetedAmount Decimal @default(0) @db.Decimal(12, 2)
actualAmount   Decimal @default(0) @db.Decimal(12, 2)
committedAmount Decimal @default(0) @db.Decimal(12, 2)
varianceAmount Decimal @default(0) @db.Decimal(12, 2)
```

**Financial Precision Standards**:
- Money: `@db.Decimal(12, 2)` - max $9,999,999,999.99
- Quantities: `@db.Decimal(10, 4)` - max 999,999.9999
- Rates/Percentages: `@db.Decimal(8, 4)` - max 9999.9999%
- Exchange Rates: `@db.Decimal(10, 6)` - max 9999.999999

**Currency Defaults**:
- Estimate: No default (user must specify)
- Invoice: `@default("USD")` (business requirement)
- Project: Inherited from Estimate

---

### 4. Event Timestamps (No @default(now()) - Application Layer Sets)

**Pattern**: Business event timestamps set by application, not database

```prisma
// ✅ CORRECT - Nullable, no database default
issueDate      DateTime? @db.Timestamptz(6)
sentToClientAt DateTime? @db.Timestamptz(6)
clientViewedAt DateTime? @db.Timestamptz(6)

// For Invoice
invoiceDate    DateTime? @db.Timestamptz(6)
dueDate        DateTime? @db.Timestamptz(6)
paidAt         DateTime? @db.Timestamptz(6)

// For Project
startedAt      DateTime? @db.Timestamptz(6)
completedAt    DateTime? @db.Timestamptz(6)
closedAt       DateTime? @db.Timestamptz(6)
```

**Why No @default(now())**:
- Business events happen at specific moments (not creation time)
- `issueDate` is when document issued to client (not when row created)
- `sentToClientAt` is when email sent (may be days after creation)
- Application layer sets these at appropriate business event

**Lifecycle Timestamps DO use @default(now())**:
```prisma
// ✅ Technical timestamps use defaults
createdAt DateTime @default(now()) @db.Timestamptz(6)
updatedAt DateTime @updatedAt @db.Timestamptz(6)
deletedAt DateTime? @db.Timestamptz(6)  // Soft delete (no default)
```

---

### 5. Cross-Module Relations (Estimate ↔ Invoice ↔ Project)

**Pattern**: 1:1:1 traceability via globalId + explicit FKs

```prisma
// Estimate model
model Estimate {
  // ... fields ...
  
  // Relations to Invoice (one-to-many)
  invoices Invoice[] @relation("EstimateToInvoices")
  
  // Relations to Project (one-to-one via globalId)
  projects Project[] @relation("EstimateToProjects")
}

// Invoice model
model Invoice {
  // ... fields ...
  
  // Source estimate (optional - invoices can exist without estimates)
  sourceEstimateId String? @db.Uuid
  sourceEstimate Estimate? @relation(
    "EstimateToInvoices",
    fields: [tenantId, sourceEstimateId],
    references: [tenantId, id],
    onDelete: SetNull  // Invoice survives estimate deletion
  )
  
  // Related project (optional)
  relatedProjectId String? @db.Uuid
  relatedProject Project? @relation(
    "ProjectToInvoices",
    fields: [tenantId, relatedProjectId],
    references: [tenantId, id],
    onDelete: SetNull
  )
}

// Project model
model Project {
  // ... fields ...
  
  // Source estimate (one-to-one via globalId)
  sourceEstimateId String? @db.Uuid
  sourceEstimate Estimate? @relation(
    "EstimateToProjects",
    fields: [tenantId, sourceEstimateId],
    references: [tenantId, id],
    onDelete: Restrict  // Cannot delete estimate if project exists
  )
  
  // Generated invoices (one-to-many)
  invoices Invoice[] @relation("ProjectToInvoices")
}
```

**1:1:1 Traceability Rules**:
1. All three share same `globalId` (immutable)
2. `estimateNumber === projectNumber === invoiceNumber`
3. Project MUST reference sourceEstimateId (cannot exist without approved estimate)
4. Invoice MAY reference sourceEstimateId and/or relatedProjectId
5. Use `onDelete: Restrict` for critical anchors, `SetNull` for optional

---

## 🎯 Module-Specific Patterns

### Estimate Module
```prisma
// Triple Status Dimension
status         EstimateStatus         @default(DRAFT)
approvalStatus EstimateApprovalStatus @default(PENDING)
clientStatus   EstimateClientStatus   @default(NOT_SENT)

// Conversion tracking
convertedToProjectAt DateTime? @db.Timestamptz(6)
convertedToInvoiceAt DateTime? @db.Timestamptz(6)

// Behavior flags
autoCreateProjectOnApproval Boolean @default(false)
autoCreateInvoiceOnApproval Boolean @default(false)
```

### Invoice Module
```prisma
// Triple Status Dimension
status            InvoiceStatus            @default(DRAFT)
paymentStatus     InvoicePaymentStatus     @default(UNPAID)
collectionStatus  InvoiceCollectionStatus  @default(CURRENT)

// Payment tracking
amountPaid    Decimal @default(0) @db.Decimal(12, 2)
amountDue     Decimal @default(0) @db.Decimal(12, 2)
balanceAmount Decimal @default(0) @db.Decimal(12, 2)

// Billing type
billingType InvoiceBillingType @default(STANDARD)
// STANDARD, PROGRESS, MILESTONE, RECURRING, TIME_AND_MATERIALS
```

### Project Module
```prisma
// Triple Status Dimension
status         ProjectStatus         @default(PLANNING)
budgetStatus   ProjectBudgetStatus   @default(ON_BUDGET)
scheduleStatus ProjectScheduleStatus @default(ON_SCHEDULE)

// Timeline (Planned vs Baseline vs Actual)
plannedStartDate   DateTime? @db.Timestamptz(6)
plannedEndDate     DateTime? @db.Timestamptz(6)
baselineStartDate  DateTime? @db.Timestamptz(6)
baselineEndDate    DateTime? @db.Timestamptz(6)
actualStartDate    DateTime? @db.Timestamptz(6)
actualEndDate      DateTime? @db.Timestamptz(6)

// Budget vs Actual tracking
budgetedAmount Decimal @default(0) @db.Decimal(12, 2)
actualAmount   Decimal @default(0) @db.Decimal(12, 2)
varianceAmount Decimal @default(0) @db.Decimal(12, 2)
```

---

## ✅ Validation Checklist (Before Committing)

When touching ANY financial module model:

- [ ] CRM models use correct names (CRMAccount, CRMContact, CRMAddress)
- [ ] Governance fields use same names, module-specific enums
- [ ] CRM field names exact (crmAccountId, crmContactId, billToAddressId)
- [ ] Financial header fields use aligned types (@db.Decimal(12, 2))
- [ ] Event timestamps nullable, no @default(now())
- [ ] Cross-module relations use correct relation names
- [ ] Composite keys for tenant relations `[tenantId, foreignId] → [tenantId, id]`
- [ ] Delete semantics appropriate (Cascade/SetNull/Restrict)
- [ ] BH pattern if needed (globalId + unique constraints + index)

---

## 🚫 Common Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Wrong CRM Model Names
```prisma
// ❌ WRONG
crmAccount Account @relation(...)

// ✅ CORRECT
crmAccount CRMAccount @relation(...)
```

### ❌ Anti-Pattern 2: Inconsistent Field Names
```prisma
// ❌ WRONG - Estimate uses 'total', Invoice uses 'totalAmount'
// Estimate
total Decimal @db.Decimal(12, 2)

// Invoice
totalAmount Decimal @db.Decimal(12, 2)

// ✅ CORRECT - Both use 'totalAmount'
totalAmount Decimal @db.Decimal(12, 2)
```

### ❌ Anti-Pattern 3: Business Event with @default(now())
```prisma
// ❌ WRONG
issueDate DateTime @default(now()) @db.Timestamptz(6)

// ✅ CORRECT
issueDate DateTime? @db.Timestamptz(6)
```

### ❌ Anti-Pattern 4: Simple Keys on Tenant Relations
```prisma
// ❌ WRONG
estimate Estimate @relation(
  fields: [estimateId],
  references: [id]
)

// ✅ CORRECT
estimate Estimate @relation(
  fields: [tenantId, estimateId],
  references: [tenantId, id]
)
```

---

**End of Financial Module Instructions**

For general Prisma patterns, see `.github/copilot-instructions.md`  
For CRM-specific patterns, see `prisma-crm-models.instructions.md`  
For actor patterns, see `actor-patterns.instructions.md`
