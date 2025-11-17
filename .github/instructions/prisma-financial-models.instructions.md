---
applyTo: "prisma/schemas/{estimate,invoice,project,billing,payment*}.prisma"
excludeAgent: []
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
crmAccount CRMAccount @relation("EstimateAccount", fields: [tenantId, crmAccountId], references: [tenantId, id], onDelete: Restrict)

crmContact CRMContact? @relation("EstimateContact", fields: [tenantId, crmContactId], references: [tenantId, id], onDelete: SetNull)
```

### ❌ WRONG Usage (Don't Do This):
```prisma
// ❌ These models don't exist
crmAccount Account @relation(...)
crmContact Contact @relation(...)
billToAddress AccountAddress @relation(...)

// ❌ Wrong field references
account Account @relation(...)
contact Contact @relation(...)
```

**Why This Matters**: The ERP uses CRM* prefixed models to avoid naming conflicts with accounting/financial Account models.

---

## ⚡ Cross-Module Consistency Rules

**CRITICAL**: When working on Estimate/Invoice/Project modules, these fields MUST be aligned:

### 1. Governance Fields (Shared Names, Module-Specific Enums)

```prisma
// ✅ KEEP THESE FIELD NAMES IDENTICAL across core entities
auditCorrelationId String? @db.Uuid
retentionPolicy    RetentionPolicy?
metadata           Json?   @db.JsonB  
timezone           String? @db.VarChar(50)

// ✅ MODULE-SPECIFIC enums (don't cross-pollinate)
dataClassification EstimateDataClassification @default(CONFIDENTIAL)  // Estimate
dataClassification InvoiceDataClassification @default(CONFIDENTIAL)   // Invoice
recordSource       EstimateRecordSource?                              // Estimate  
recordSource       InvoiceRecordSource?                               // Invoice
```

**Rule**: Field names identical, enum types module-specific.

### 2. CRM Linkage Fields (Exact Alignment Required)

```prisma
// ✅ REUSE these exact field definitions when they represent same concept
crmAccountId    String  @db.Uuid       // ALWAYS required for revenue docs
crmContactId    String? @db.Uuid       // ALWAYS optional  
billToAddressId String? @db.Uuid       // ALWAYS optional
ownerMemberId   String? @db.Uuid       // ALWAYS optional

// ✅ Relations must use CRM* model names
crmAccount CRMAccount @relation(fields: [tenantId, crmAccountId], references: [tenantId, id], onDelete: Restrict)

crmContact CRMContact? @relation(fields: [tenantId, crmContactId], references: [tenantId, id], onDelete: SetNull)

billToAddress CRMAddress? @relation(fields: [tenantId, billToAddressId], references: [tenantId, id], onDelete: SetNull)
```

### 3. Financial Header Totals (Precision Alignment)

```prisma  
// ✅ EXACT alignment for shared financial concepts
currencyCode   String  @db.Char(3)                    // Module-specific defaults OK
subtotalAmount Decimal @default(0) @db.Decimal(12, 2) // Money precision
discountAmount Decimal @default(0) @db.Decimal(12, 2)
taxAmount      Decimal @default(0) @db.Decimal(12, 2) 
feeAmount      Decimal @default(0) @db.Decimal(12, 2)
totalAmount    Decimal @default(0) @db.Decimal(12, 2)
totalQuantity  Decimal @default(0) @db.Decimal(10, 4) // Quantity precision
lineItemCount  Int     @default(0)
```

**Financial Precision Standards**:
- **Money**: `@db.Decimal(12, 2)` → $999,999,999,999.99 max
- **Quantities**: `@db.Decimal(10, 4)` → 999,999.9999 max  
- **Rates/Percentages**: `@db.Decimal(8, 4)` → 9999.9999% max
- **Currency Codes**: `@db.Char(3)` → ISO 4217 standard

### 4. Event Timestamps (Business Events, Not Tech Events)

```prisma
// ✅ CANONICAL definitions - nullable, no @default(now())
issueDate      DateTime? @db.Timestamptz(6)  // Document issued to client
sentToClientAt DateTime? @db.Timestamptz(6)  // Client interaction event
clientViewedAt DateTime? @db.Timestamptz(6)  // Client engagement tracking
```

**Rule**: Business event timestamps are nullable with NO @default(now()) because they represent specific business events, not technical creation times.

### 5. Cross-Module Relations (Stable Patterns)

```prisma
// ✅ CANONICAL pattern for Estimate ↔ Invoice linkage
// Estimate side:
invoices Invoice[] @relation("EstimateToInvoices")

// Invoice side:  
sourceEstimate Estimate? @relation("EstimateToInvoices", fields: [tenantId, sourceEstimateId], references: [tenantId, id], onDelete: SetNull)
```

**1:1:1 Traceability Pattern**:
```prisma
// All three models share same globalId for immutable traceability
model Estimate {
  globalId String @db.Uuid  // Generated once
  estimateNumber String     // EST-2025-001
}

model Project {
  globalId String @db.Uuid          // Same as Estimate.globalId
  sourceEstimateId String? @db.Uuid
  projectNumber String              // EST-2025-001 (inherited)
}

model Invoice {
  globalId String @db.Uuid          // Same as Estimate.globalId  
  sourceEstimateId String? @db.Uuid
  invoiceNumber String              // EST-2025-001 (inherited)
}
```

---

## 🚨 Anti-Patterns (Never Do These)

### ❌ DO NOT Mirror Models Between Modules
```prisma
// ❌ WRONG - Don't duplicate entire models
model EstimateLineItem { ... }
model InvoiceLineItem { ... }  // Exact copy
model ProjectTask { ... }      // Exact copy
```

**Instead**: Only align shared concepts, keep module-specific logic separate.

### ❌ DO NOT Create Near-Duplicate Fields
```prisma
// ❌ WRONG - Confusing variants
partialPaymentAllowed Boolean
allowPartialPayment   Boolean  // Near-duplicate!

// ✅ CORRECT - Single canonical field
partialPaymentAllowed Boolean
```

### ❌ DO NOT Use Different CRM Field Patterns
```prisma
// ❌ WRONG - Inconsistent patterns
// Estimate module:
crmAccountId String @db.Uuid

// Invoice module:
customerAccountId String @db.Uuid  // Different name!

// ✅ CORRECT - Consistent across modules
crmAccountId String @db.Uuid  // Same field name everywhere
```

### ❌ DO NOT Add @default(now()) to Business Timestamps
```prisma
// ❌ WRONG - Business events shouldn't auto-populate
issueDate      DateTime @default(now()) @db.Timestamptz(6)
sentToClientAt DateTime @default(now()) @db.Timestamptz(6)

// ✅ CORRECT - Explicitly set when business event occurs
issueDate      DateTime? @db.Timestamptz(6)
sentToClientAt DateTime? @db.Timestamptz(6)
```

### ❌ DO NOT Use Wrong Composite Key Patterns
```prisma
// ❌ WRONG - Inconsistent composite key pattern
invoice Invoice @relation(fields: [invoiceId, tenantId], references: [id, tenantId], onDelete: Cascade)

// ✅ CORRECT - Consistent pattern: tenantId first
invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
```

---

## ✅ Required Patterns for Financial Models

### Multi-Tenant Scope Identification
```prisma
// Financial models are typically Tenant-scoped or Hybrid BH
model FinancialEntity {
  id       String @id @default(uuid(7)) @db.Uuid
  tenantId String @db.Uuid
  
  // For Hybrid BH (Estimate, Invoice, Project):
  globalId String @db.Uuid  // Cross-tenant traceability
  
  @@unique([tenantId, id])
  @@unique([tenantId, globalId])  // Hybrid BH only
  @@index([globalId])             // Hybrid BH only
}
```

### Actor Attribution (Pattern B for Financial Entities)
```prisma
// Financial entities use Pattern B (full Actor relations)
model Estimate {
  // Actor audit with full cross-relations
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  createdByActor Actor? @relation("EstimateCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  updatedByActor Actor? @relation("EstimateUpdatedByActor", fields: [updatedByActorId], references: [id], onDelete: SetNull)
  deletedByActor Actor? @relation("EstimateDeletedByActor", fields: [deletedByActorId], references: [id], onDelete: SetNull)
}

// Child financial entities use Pattern A (IDs only)
model EstimateTax {
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
  
  // NO Actor relations - keeps Actor model lean
}
```

### Delete Semantics for Financial Relationships
```prisma
// Financial integrity - use Restrict
crmAccount CRMAccount @relation(fields: [tenantId, crmAccountId], references: [tenantId, id], onDelete: Restrict)

// Optional historical - use SetNull
crmContact CRMContact? @relation(fields: [tenantId, crmContactId], references: [tenantId, id], onDelete: SetNull)

// Ownership trees - use Cascade
invoiceLineItems InvoiceLineItem[]
// In InvoiceLineItem:
invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
```

### Required Indexes for Financial Models
```prisma
// Standard financial indexes
@@unique([tenantId, id])                     // Primary constraint
@@unique([tenantId, documentNumber])         // Business identifier
@@index([tenantId, crmAccountId])            // Customer lookups (most common)
@@index([tenantId, status])                  // Status filtering
@@index([tenantId, totalAmount])             // Financial reporting
@@index([tenantId, deletedAt])               // Soft delete filtering
@@index([createdAt], type: Brin)             // Temporal queries
@@index([tenantId, auditCorrelationId])      // Governance compliance

// For Hybrid BH models:
@@index([globalId])                          // Cross-tenant traceability
```

---

## 📋 Financial Model Validation Checklist

Before committing any changes to financial Prisma schemas:

- [ ] **CRM Models**: Used CRMAccount, CRMContact, CRMAddress (not Account/Contact)?
- [ ] **Field Alignment**: Governance fields identical across modules?
- [ ] **Financial Precision**: Money uses Decimal(12,2), quantities use Decimal(10,4)?
- [ ] **Business Timestamps**: No @default(now()) on business event fields?
- [ ] **Composite Keys**: Pattern is [tenantId, foreignId] → [tenantId, id]?
- [ ] **Delete Semantics**: Financial integrity (Restrict), optional (SetNull), ownership (Cascade)?
- [ ] **Actor Pattern**: Pattern B for parent entities, Pattern A for children?
- [ ] **Cross-Module**: No duplicate field names with different meanings?
- [ ] **Indexes**: All required financial indexes present?
- [ ] **Multi-Tenant**: Proper tenant isolation with @@unique([tenantId, id])?

---

## 🎯 Success Criteria

When these patterns are followed:
- ✅ Financial modules maintain perfect consistency
- ✅ CRM integrations work seamlessly  
- ✅ Cross-module reporting is reliable
- ✅ Audit trails are comprehensive
- ✅ Performance is optimized
- ✅ Multi-tenant isolation is guaranteed

**Remember**: Financial data integrity is non-negotiable. When in doubt, choose the more restrictive approach.