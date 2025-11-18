# 💳 EXPENSE MODULE - Architecture Diagram

**Version**: 1.0  
**Date**: November 17, 2025  
**Status**: ✅ Canonical Reference  
**Module Files**: expensecore.prisma (9 models) + expenses.prisma (9 models)  
**Total Models**: 18 models

---

## 📋 Table of Contents

1. [Module Overview](#module-overview)
2. [Architecture Patterns](#architecture-patterns)
3. [Core Models (expensecore.prisma)](#core-models)
4. [Corporate Card Models (expenses.prisma)](#corporate-card-models)
5. [Integration Points](#integration-points)
6. [Visual Architecture](#visual-architecture)
7. [Index Strategy](#index-strategy)
8. [Business Rules](#business-rules)

---

## 🎯 Module Overview

### Purpose

The Expense module provides comprehensive employee expense management and corporate card tracking for construction and field service companies. It handles everything from manual expense report submission to automated corporate card transaction reconciliation, with full integration to projects for job costing and general ledger for accounting.

### Key Capabilities

**Expense Report Management**:
- Employee expense report creation and submission
- Multi-line expense entries with categories
- Receipt capture and OCR processing
- Policy compliance checking with violation tracking
- Multi-level approval workflows
- Reimbursement payment tracking
- Project/job allocation for cost recovery

**Corporate Card Integration**:
- Real-time card transaction feeds
- Automated expense creation from transactions
- Multi-card management per employee
- Spending limits and controls
- Receipt matching and reconciliation
- Vendor categorization
- Dispute and chargeback management

**Policy & Compliance**:
- Configurable expense policies by category
- Per diem rates by location
- Mileage reimbursement rates
- Automatic policy violation detection
- Manager override capabilities
- Audit trail for compliance

**Integration**:
- Project cost allocation for job costing
- Employee/HR linkage for reimbursement
- GL integration for accounting
- Approval workflows
- Document management for receipts
- Payment processing for reimbursements

---

## 🏗️ Architecture Patterns

### Pattern Distribution

| Pattern | Models | Usage |
|---------|--------|-------|
| **BH (Base Hybrid)** | 2 | ExpenseReport, CorpCard (parent entities with globalId) |
| **Pattern A (Lightweight)** | 16 | All child and supporting entities |

### Pattern Justification

**BH Pattern (ExpenseReport, CorpCard)**:
- Parent entities requiring cross-tenant analytics
- Audit and compliance requirements
- Integration with external systems (card processors)
- Need for immutable global identifiers

**Pattern A (All Children)**:
- Performance optimization for high-volume entities
- Child entities always accessed through parent
- Lightweight for frequent transactions
- Cascade deletion with parent

---

## 📊 Core Models (expensecore.prisma)

### 1. ExpenseReport (Pattern BH - Parent)

**Purpose**: Parent entity representing an employee's expense report submission

**Pattern**: BH (Base Hybrid) with Actor Attribution

**Fields** (65 fields across 12 dimensions):

```prisma
model ExpenseReport {
  // ==================== IDENTITY (BH Pattern) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  globalId              String      @default(uuid(7)) @db.Uuid
  
  @@unique([tenantId, id])
  @@unique([tenantId, globalId])
  @@index([globalId])
  
  // ==================== BUSINESS IDENTITY ====================
  reportNumber          String      @db.VarChar(100)
  reportName            String      @db.VarChar(500)
  description           String?     @db.Text
  
  @@unique([tenantId, reportNumber])
  @@index([tenantId, reportNumber])
  
  // ==================== EMPLOYEE/SUBMITTER ====================
  employeeId            String      @db.Uuid
  submittedByMemberId   String      @db.Uuid
  department            String?     @db.VarChar(200)
  costCenter            String?     @db.VarChar(100)
  
  employee              Employee    @relation(fields: [tenantId, employeeId], references: [tenantId, id], onDelete: Restrict)
  submittedByMember     Member      @relation(fields: [tenantId, submittedByMemberId], references: [tenantId, id], onDelete: Restrict)
  
  @@index([tenantId, employeeId])
  @@index([tenantId, submittedByMemberId])
  
  // ==================== EXPENSE PERIOD ====================
  expenseStartDate      DateTime    @db.Date
  expenseEndDate        DateTime    @db.Date
  submittedDate         DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, expenseStartDate])
  @@index([tenantId, submittedDate], type: Brin)
  
  // ==================== FINANCIAL ====================
  currencyCode          String      @default("USD") @db.VarChar(3)
  
  // Calculated totals
  totalExpenseAmount    Decimal     @default(0) @db.Decimal(15, 2)
  totalReimbursable     Decimal     @default(0) @db.Decimal(15, 2)
  totalNonReimbursable  Decimal     @default(0) @db.Decimal(15, 2)
  totalPolicyViolations Decimal     @default(0) @db.Decimal(15, 2)
  approvedAmount        Decimal?    @db.Decimal(15, 2)
  paidAmount            Decimal     @default(0) @db.Decimal(15, 2)
  amountDue             Decimal     @default(0) @db.Decimal(15, 2)
  
  @@index([tenantId, totalExpenseAmount])
  
  // ==================== STATUS (Triple Dimension) ====================
  // Dimension 1: Workflow Status
  status                String      @default("DRAFT") @db.VarChar(50)
  // Values: DRAFT, SUBMITTED, IN_REVIEW, APPROVED, REJECTED, PAID, CANCELLED
  
  // Dimension 2: Approval Status
  approvalStatus        String      @default("NOT_SUBMITTED") @db.VarChar(50)
  // Values: NOT_SUBMITTED, PENDING_APPROVAL, APPROVED, REJECTED, MANAGER_OVERRIDE
  
  // Dimension 3: Payment Status
  paymentStatus         String      @default("UNPAID") @db.VarChar(50)
  // Values: UNPAID, PENDING_PAYMENT, PARTIALLY_PAID, PAID, PAYMENT_FAILED
  
  @@index([tenantId, status])
  @@index([tenantId, approvalStatus])
  @@index([tenantId, paymentStatus])
  
  // ==================== APPROVAL WORKFLOW ====================
  requiresApproval      Boolean     @default(true)
  approvalRequestId     String?     @db.Uuid
  approvedByMemberId    String?     @db.Uuid
  approvedDate          DateTime?   @db.Timestamptz(6)
  rejectedByMemberId    String?     @db.Uuid
  rejectedDate          DateTime?   @db.Timestamptz(6)
  rejectionReason       String?     @db.Text
  managerOverride       Boolean     @default(false)
  managerOverrideReason String?     @db.Text
  
  approvalRequest       ApprovalRequest?  @relation(fields: [tenantId, approvalRequestId], references: [tenantId, id], onDelete: SetNull)
  approvedByMember      Member?     @relation("ExpenseReport_approvedBy", fields: [tenantId, approvedByMemberId], references: [tenantId, id], onDelete: SetNull)
  rejectedByMember      Member?     @relation("ExpenseReport_rejectedBy", fields: [tenantId, rejectedByMemberId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, approvalRequestId])
  
  // ==================== POLICY COMPLIANCE ====================
  hasPolicyViolations   Boolean     @default(false)
  violationCount        Int         @default(0)
  violationSeverity     String?     @db.VarChar(50)
  // Values: LOW, MEDIUM, HIGH, CRITICAL
  
  @@index([tenantId, hasPolicyViolations])
  
  // ==================== PROJECT ALLOCATION ====================
  relatedProjectId      String?     @db.Uuid
  isBillableToClient    Boolean     @default(false)
  
  relatedProject        Project?    @relation(fields: [tenantId, relatedProjectId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, relatedProjectId])
  
  // ==================== PAYMENT ====================
  paymentMethodId       String?     @db.Uuid
  paymentDate           DateTime?   @db.Timestamptz(6)
  paymentReference      String?     @db.VarChar(255)
  
  paymentMethod         PaymentMethod? @relation(fields: [tenantId, paymentMethodId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== COUNTS & METRICS ====================
  lineItemCount         Int         @default(0)
  receiptCount          Int         @default(0)
  attachmentCount       Int         @default(0)
  
  // ==================== FLAGS ====================
  hasReceipts           Boolean     @default(false)
  hasMissingReceipts    Boolean     @default(false)
  hasCorpCardExpenses   Boolean     @default(false)
  hasPersonalExpenses   Boolean     @default(false)
  isReconciled          Boolean     @default(false)
  
  // ==================== DATES ====================
  dueDate               DateTime?   @db.Date
  paidDate              DateTime?   @db.Date
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([updatedAt], type: Brin)
  
  // ==================== GOVERNANCE ====================
  auditCorrelationId    String?     @db.Uuid
  dataClassification    String?     @db.VarChar(50)
  retentionPolicy       String?     @db.VarChar(50)
  recordSource          String?     @db.VarChar(100)
  metadata              Json?       @db.JsonB
  
  @@index([tenantId, auditCorrelationId])
  
  // ==================== ACTOR ATTRIBUTION (Pattern B) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  createdByActor        Actor       @relation("ExpenseReport_createdBy", fields: [createdByActorId], references: [id], onDelete: Restrict)
  updatedByActor        Actor       @relation("ExpenseReport_updatedBy", fields: [updatedByActorId], references: [id], onDelete: Restrict)
  deletedByActor        Actor?      @relation("ExpenseReport_deletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // ==================== CHILD RELATIONS ====================
  lines                 ExpenseLine[]
  receipts              ExpenseReceipt[]
  policyViolations      ExpensePolicyViolation[]
  payments              ExpensePayment[]
  attachments           ExpenseAttachment[]
  historyEvents         ExpenseHistoryEvent[]
  
  @@map("expense_report")
}
```

**Strategic Indexes** (17 total):
1. `[tenantId, id]` - Unique constraint (composite PK)
2. `[tenantId, globalId]` - Unique constraint (1:1:1 traceability)
3. `[globalId]` - Cross-tenant queries
4. `[tenantId, reportNumber]` - Unique business identifier
5. `[tenantId, employeeId]` - Employee expense reports lookup
6. `[tenantId, submittedByMemberId]` - Submitter lookup
7. `[tenantId, expenseStartDate]` - Period-based queries
8. `[tenantId, submittedDate]` BRIN - Time-series queries
9. `[tenantId, totalExpenseAmount]` - Financial reporting
10. `[tenantId, status]` - Status filtering
11. `[tenantId, approvalStatus]` - Approval workflows
12. `[tenantId, paymentStatus]` - Payment processing
13. `[tenantId, approvalRequestId]` - Approval integration
14. `[tenantId, hasPolicyViolations]` - Compliance filtering
15. `[tenantId, relatedProjectId]` - Project allocation
16. `[tenantId, deletedAt]` - Soft delete queries
17. `[tenantId, auditCorrelationId]` - Audit tracing

---

### 2. ExpenseLine (Pattern A - Child)

**Purpose**: Individual expense line items within a report

**Pattern**: Pattern A (Lightweight) with Actor Attribution IDs

**Fields** (40 fields):

```prisma
model ExpenseLine {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== PARENT RELATION ====================
  expenseReportId       String      @db.Uuid
  
  expenseReport         ExpenseReport @relation(fields: [tenantId, expenseReportId], references: [tenantId, id], onDelete: Cascade)
  
  @@index([tenantId, expenseReportId])
  
  // ==================== BUSINESS IDENTITY ====================
  lineNumber            Int
  description           String      @db.VarChar(1000)
  notes                 String?     @db.Text
  
  @@unique([tenantId, expenseReportId, lineNumber])
  @@index([tenantId, expenseReportId, lineNumber])
  
  // ==================== EXPENSE CATEGORY ====================
  expenseCategoryId     String      @db.Uuid
  categoryCode          String      @db.VarChar(50)
  categoryName          String      @db.VarChar(255)
  
  expenseCategory       ExpenseCategory @relation(fields: [tenantId, expenseCategoryId], references: [tenantId, id], onDelete: Restrict)
  
  @@index([tenantId, expenseCategoryId])
  @@index([tenantId, categoryCode])
  
  // ==================== EXPENSE DATE & LOCATION ====================
  expenseDate           DateTime    @db.Date
  expenseLocation       String?     @db.VarChar(500)
  cityName              String?     @db.VarChar(200)
  stateName             String?     @db.VarChar(100)
  countryCode           String?     @db.VarChar(3)
  
  @@index([tenantId, expenseDate])
  
  // ==================== FINANCIAL ====================
  currencyCode          String      @default("USD") @db.VarChar(3)
  expenseAmount         Decimal     @db.Decimal(15, 2)
  reimbursableAmount    Decimal     @db.Decimal(15, 2)
  nonReimbursableAmount Decimal     @default(0) @db.Decimal(15, 2)
  taxAmount             Decimal     @default(0) @db.Decimal(15, 2)
  
  // ==================== MILEAGE (if applicable) ====================
  isMileageExpense      Boolean     @default(false)
  mileageDistance       Decimal?    @db.Decimal(10, 2)
  mileageRate           Decimal?    @db.Decimal(10, 4)
  originAddress         String?     @db.VarChar(500)
  destinationAddress    String?     @db.VarChar(500)
  
  // ==================== MERCHANT/VENDOR ====================
  merchantName          String?     @db.VarChar(255)
  merchantCategory      String?     @db.VarChar(100)
  crmVendorId           String?     @db.Uuid
  
  crmVendor             CRMAccount? @relation(fields: [tenantId, crmVendorId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== RECEIPT ====================
  hasReceipt            Boolean     @default(false)
  receiptRequired       Boolean     @default(false)
  receiptMissing        Boolean     @default(false)
  
  // ==================== PAYMENT SOURCE ====================
  paymentSource         String      @db.VarChar(50)
  // Values: PERSONAL, CORPORATE_CARD, ADVANCE, PETTY_CASH
  
  corpCardId            String?     @db.Uuid
  corpCardTransactionId String?     @db.Uuid
  
  corpCard              CorpCard?   @relation(fields: [tenantId, corpCardId], references: [tenantId, id], onDelete: SetNull)
  corpCardTransaction   CorpCardTransaction? @relation(fields: [tenantId, corpCardTransactionId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, corpCardId])
  @@index([tenantId, corpCardTransactionId])
  
  // ==================== PROJECT ALLOCATION ====================
  projectId             String?     @db.Uuid
  projectTaskId         String?     @db.Uuid
  costCodeId            String?     @db.Uuid
  isBillableToClient    Boolean     @default(false)
  
  project               Project?    @relation(fields: [tenantId, projectId], references: [tenantId, id], onDelete: SetNull)
  projectTask           ProjectTask? @relation(fields: [tenantId, projectTaskId], references: [tenantId, id], onDelete: SetNull)
  costCode              CostCode?   @relation(fields: [tenantId, costCodeId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, projectId])
  @@index([tenantId, projectTaskId])
  @@index([tenantId, costCodeId])
  
  // ==================== POLICY COMPLIANCE ====================
  hasPolicyViolation    Boolean     @default(false)
  violationSeverity     String?     @db.VarChar(50)
  
  // ==================== FLAGS ====================
  isReimbursable        Boolean     @default(true)
  isPolicyCompliant     Boolean     @default(true)
  isReconciled          Boolean     @default(false)
  
  // ==================== SORT ORDER ====================
  sortOrder             Int         @default(0)
  
  @@index([tenantId, expenseReportId, sortOrder])
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A - IDs Only) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // ==================== CHILD RELATIONS ====================
  policyViolations      ExpensePolicyViolation[]
  receipts              ExpenseReceipt[]
  
  @@map("expense_line")
}
```

**Strategic Indexes** (13 total):
1. `[tenantId, id]` - Unique constraint
2. `[tenantId, expenseReportId]` - Parent lookup
3. `[tenantId, expenseReportId, lineNumber]` - Unique line ordering
4. `[tenantId, expenseCategoryId]` - Category analysis
5. `[tenantId, categoryCode]` - Category filtering
6. `[tenantId, expenseDate]` - Date-based queries
7. `[tenantId, corpCardId]` - Card expense tracking
8. `[tenantId, corpCardTransactionId]` - Transaction matching
9. `[tenantId, projectId]` - Project allocation
10. `[tenantId, projectTaskId]` - Task costing
11. `[tenantId, costCodeId]` - Cost code reporting
12. `[tenantId, expenseReportId, sortOrder]` - Ordered retrieval
13. `[tenantId, deletedAt]` - Soft delete queries

---

### 3. ExpenseCategory (Pattern A - Reference Data)

**Purpose**: Expense categorization with policy rules

**Pattern**: Pattern A (Lightweight)

**Fields** (30 fields):

```prisma
model ExpenseCategory {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== BUSINESS IDENTITY ====================
  categoryCode          String      @db.VarChar(50)
  categoryName          String      @db.VarChar(255)
  description           String?     @db.Text
  parentCategoryId      String?     @db.Uuid
  
  @@unique([tenantId, categoryCode])
  @@index([tenantId, categoryCode])
  
  parentCategory        ExpenseCategory? @relation("CategoryHierarchy", fields: [tenantId, parentCategoryId], references: [tenantId, id], onDelete: SetNull)
  childCategories       ExpenseCategory[] @relation("CategoryHierarchy")
  
  @@index([tenantId, parentCategoryId])
  
  // ==================== GL MAPPING ====================
  glAccountId           String?     @db.Uuid
  glAccountCode         String?     @db.VarChar(50)
  
  glAccount             GLAccount?  @relation(fields: [tenantId, glAccountId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== POLICY RULES ====================
  requiresReceipt       Boolean     @default(false)
  receiptThreshold      Decimal?    @db.Decimal(15, 2)
  requiresApproval      Boolean     @default(true)
  approvalThreshold     Decimal?    @db.Decimal(15, 2)
  requiresJustification Boolean     @default(false)
  
  maxAmountPerDay       Decimal?    @db.Decimal(15, 2)
  maxAmountPerMonth     Decimal?    @db.Decimal(15, 2)
  maxAmountPerYear      Decimal?    @db.Decimal(15, 2)
  
  // ==================== REIMBURSEMENT ====================
  isReimbursable        Boolean     @default(true)
  reimbursementRate     Decimal?    @db.Decimal(10, 4)
  // For mileage: rate per mile/km
  
  // ==================== MILEAGE CATEGORY ====================
  isMileageCategory     Boolean     @default(false)
  mileageUnit           String?     @db.VarChar(20)
  // Values: MILES, KILOMETERS
  
  // ==================== STATUS ====================
  isActive              Boolean     @default(true)
  isSystemCategory      Boolean     @default(false)
  
  @@index([tenantId, isActive])
  
  // ==================== SORT ORDER ====================
  sortOrder             Int         @default(0)
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // ==================== CHILD RELATIONS ====================
  expenseLines          ExpenseLine[]
  policies              ExpensePolicy[]
  
  @@map("expense_category")
}
```

---

### 4. ExpenseReceipt (Pattern A - Child)

**Purpose**: Receipt images and OCR data for expense verification

**Pattern**: Pattern A (Lightweight)

**Fields** (35 fields):

```prisma
model ExpenseReceipt {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== PARENT RELATIONS ====================
  expenseReportId       String      @db.Uuid
  expenseLineId         String?     @db.Uuid
  
  expenseReport         ExpenseReport @relation(fields: [tenantId, expenseReportId], references: [tenantId, id], onDelete: Cascade)
  expenseLine           ExpenseLine? @relation(fields: [tenantId, expenseLineId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, expenseReportId])
  @@index([tenantId, expenseLineId])
  
  // ==================== FILE INFO ====================
  fileName              String      @db.VarChar(500)
  fileUrl               String      @db.VarChar(2000)
  fileSize              Int
  mimeType              String      @db.VarChar(100)
  
  // ==================== IMAGE INFO ====================
  imageWidth            Int?
  imageHeight           Int?
  thumbnailUrl          String?     @db.VarChar(2000)
  
  // ==================== OCR PROCESSING ====================
  hasOCR                Boolean     @default(false)
  ocrStatus             String?     @db.VarChar(50)
  // Values: PENDING, PROCESSING, COMPLETED, FAILED
  ocrProcessedAt        DateTime?   @db.Timestamptz(6)
  ocrConfidence         Decimal?    @db.Decimal(5, 4)
  
  // OCR Extracted Data
  ocrMerchantName       String?     @db.VarChar(255)
  ocrDate               DateTime?   @db.Date
  ocrTotalAmount        Decimal?    @db.Decimal(15, 2)
  ocrTaxAmount          Decimal?    @db.Decimal(15, 2)
  ocrCurrencyCode       String?     @db.VarChar(3)
  ocrRawText            String?     @db.Text
  ocrExtractedData      Json?       @db.JsonB
  
  @@index([tenantId, ocrStatus])
  
  // ==================== MATCHING ====================
  isMatched             Boolean     @default(false)
  matchedAmount         Decimal?    @db.Decimal(15, 2)
  matchVariance         Decimal?    @db.Decimal(15, 2)
  
  // ==================== UPLOAD INFO ====================
  uploadedByMemberId    String      @db.Uuid
  uploadSource          String?     @db.VarChar(100)
  // Values: WEB_UPLOAD, MOBILE_APP, EMAIL, CORP_CARD_FEED
  
  uploadedByMember      Member      @relation(fields: [tenantId, uploadedByMemberId], references: [tenantId, id], onDelete: Restrict)
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  @@map("expense_receipt")
}
```

---

### 5. ExpensePolicy (Pattern A - Configuration)

**Purpose**: Expense policy rules and limits

**Pattern**: Pattern A (Lightweight)

**Fields** (40 fields):

```prisma
model ExpensePolicy {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== BUSINESS IDENTITY ====================
  policyName            String      @db.VarChar(255)
  policyCode            String      @db.VarChar(100)
  description           String?     @db.Text
  
  @@unique([tenantId, policyCode])
  @@index([tenantId, policyCode])
  
  // ==================== CATEGORY ====================
  expenseCategoryId     String?     @db.Uuid
  
  expenseCategory       ExpenseCategory? @relation(fields: [tenantId, expenseCategoryId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, expenseCategoryId])
  
  // ==================== POLICY TYPE ====================
  policyType            String      @db.VarChar(50)
  // Values: AMOUNT_LIMIT, RECEIPT_REQUIREMENT, APPROVAL_THRESHOLD, PER_DIEM, MILEAGE_RATE
  
  // ==================== AMOUNT LIMITS ====================
  maxAmountPerTransaction Decimal?  @db.Decimal(15, 2)
  maxAmountPerDay       Decimal?    @db.Decimal(15, 2)
  maxAmountPerWeek      Decimal?    @db.Decimal(15, 2)
  maxAmountPerMonth     Decimal?    @db.Decimal(15, 2)
  maxAmountPerYear      Decimal?    @db.Decimal(15, 2)
  
  // ==================== RECEIPT REQUIREMENTS ====================
  requiresReceipt       Boolean     @default(false)
  receiptRequiredAbove  Decimal?    @db.Decimal(15, 2)
  
  // ==================== APPROVAL REQUIREMENTS ====================
  requiresApproval      Boolean     @default(false)
  approvalRequiredAbove Decimal?    @db.Decimal(15, 2)
  approverLevels        Int?
  
  // ==================== PER DIEM RATES ====================
  perDiemRate           Decimal?    @db.Decimal(10, 2)
  perDiemType           String?     @db.VarChar(50)
  // Values: MEALS, LODGING, INCIDENTALS, COMBINED
  
  // ==================== MILEAGE RATES ====================
  mileageRate           Decimal?    @db.Decimal(10, 4)
  mileageUnit           String?     @db.VarChar(20)
  // Values: MILES, KILOMETERS
  
  // ==================== LOCATION ====================
  appliesToAllLocations Boolean     @default(true)
  countryCode           String?     @db.VarChar(3)
  stateProvince         String?     @db.VarChar(100)
  cityName              String?     @db.VarChar(200)
  
  // ==================== DEPARTMENT/COST CENTER ====================
  appliesToAllDepartments Boolean   @default(true)
  departmentCode        String?     @db.VarChar(100)
  costCenter            String?     @db.VarChar(100)
  
  // ==================== VIOLATION HANDLING ====================
  violationSeverity     String      @default("MEDIUM") @db.VarChar(50)
  // Values: INFO, LOW, MEDIUM, HIGH, CRITICAL
  allowManagerOverride  Boolean     @default(true)
  autoReject            Boolean     @default(false)
  
  // ==================== EFFECTIVITY ====================
  effectiveStartDate    DateTime    @db.Date
  effectiveEndDate      DateTime?   @db.Date
  
  @@index([tenantId, effectiveStartDate])
  @@index([tenantId, effectiveEndDate])
  
  // ==================== STATUS ====================
  isActive              Boolean     @default(true)
  
  @@index([tenantId, isActive])
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // ==================== CHILD RELATIONS ====================
  violations            ExpensePolicyViolation[]
  
  @@map("expense_policy")
}
```

---

### 6. ExpensePolicyViolation (Pattern A - Child)

**Purpose**: Track and manage policy violations

**Pattern**: Pattern A (Lightweight)

**Fields** (30 fields):

```prisma
model ExpensePolicyViolation {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== PARENT RELATIONS ====================
  expenseReportId       String      @db.Uuid
  expenseLineId         String?     @db.Uuid
  expensePolicyId       String      @db.Uuid
  
  expenseReport         ExpenseReport @relation(fields: [tenantId, expenseReportId], references: [tenantId, id], onDelete: Cascade)
  expenseLine           ExpenseLine? @relation(fields: [tenantId, expenseLineId], references: [tenantId, id], onDelete: Cascade)
  expensePolicy         ExpensePolicy @relation(fields: [tenantId, expensePolicyId], references: [tenantId, id], onDelete: Restrict)
  
  @@index([tenantId, expenseReportId])
  @@index([tenantId, expenseLineId])
  @@index([tenantId, expensePolicyId])
  
  // ==================== VIOLATION DETAILS ====================
  violationType         String      @db.VarChar(100)
  // Values: AMOUNT_EXCEEDED, MISSING_RECEIPT, MISSING_APPROVAL, CATEGORY_RESTRICTED, DUPLICATE_EXPENSE
  
  violationSeverity     String      @db.VarChar(50)
  // Values: INFO, LOW, MEDIUM, HIGH, CRITICAL
  
  violationMessage      String      @db.Text
  policyLimit           Decimal?    @db.Decimal(15, 2)
  actualAmount          Decimal?    @db.Decimal(15, 2)
  variance              Decimal?    @db.Decimal(15, 2)
  
  // ==================== RESOLUTION ====================
  status                String      @default("OPEN") @db.VarChar(50)
  // Values: OPEN, ACKNOWLEDGED, MANAGER_OVERRIDE, RESOLVED, WAIVED
  
  resolution            String?     @db.VarChar(50)
  // Values: APPROVED_WITH_EXCEPTION, MANAGER_OVERRIDE, POLICY_WAIVED, AMOUNT_ADJUSTED, REJECTED
  
  resolutionNotes       String?     @db.Text
  resolvedByMemberId    String?     @db.Uuid
  resolvedDate          DateTime?   @db.Timestamptz(6)
  
  resolvedByMember      Member?     @relation(fields: [tenantId, resolvedByMemberId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== OVERRIDE ====================
  isManagerOverride     Boolean     @default(false)
  overrideReason        String?     @db.Text
  overrideByMemberId    String?     @db.Uuid
  overrideDate          DateTime?   @db.Timestamptz(6)
  
  overrideByMember      Member?     @relation("PolicyViolation_override", fields: [tenantId, overrideByMemberId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, status])
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  @@map("expense_policy_violation")
}
```

---

### 7. ExpensePayment (Pattern A - Child)

**Purpose**: Track reimbursement payments to employees

**Pattern**: Pattern A (Lightweight)

**Fields** (30 fields):

```prisma
model ExpensePayment {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== PARENT RELATION ====================
  expenseReportId       String      @db.Uuid
  
  expenseReport         ExpenseReport @relation(fields: [tenantId, expenseReportId], references: [tenantId, id], onDelete: Cascade)
  
  @@index([tenantId, expenseReportId])
  
  // ==================== PAYMENT IDENTITY ====================
  paymentNumber         String?     @db.VarChar(100)
  paymentReference      String?     @db.VarChar(255)
  
  // ==================== FINANCIAL ====================
  paymentAmount         Decimal     @db.Decimal(15, 2)
  currencyCode          String      @default("USD") @db.VarChar(3)
  
  // ==================== PAYMENT METHOD ====================
  paymentMethodId       String?     @db.Uuid
  paymentMethod         String      @db.VarChar(50)
  // Values: CHECK, DIRECT_DEPOSIT, WIRE_TRANSFER, PAYROLL_INTEGRATION, CASH
  
  paymentMethodRef      PaymentMethod? @relation(fields: [tenantId, paymentMethodId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== BANK INFO (if direct deposit) ====================
  bankAccountId         String?     @db.Uuid
  bankAccountNumber     String?     @db.VarChar(100)
  bankRoutingNumber     String?     @db.VarChar(100)
  
  bankAccount           BankAccount? @relation(fields: [tenantId, bankAccountId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== STATUS ====================
  status                String      @default("PENDING") @db.VarChar(50)
  // Values: PENDING, PROCESSING, PAID, FAILED, CANCELLED, REVERSED
  
  @@index([tenantId, status])
  
  // ==================== DATES ====================
  scheduledDate         DateTime?   @db.Date
  processedDate         DateTime?   @db.Timestamptz(6)
  paidDate              DateTime?   @db.Date
  clearedDate           DateTime?   @db.Date
  
  @@index([tenantId, paidDate])
  
  // ==================== PROCESSING ====================
  processingNotes       String?     @db.Text
  failureReason         String?     @db.Text
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  @@map("expense_payment")
}
```

---

### 8. ExpenseAttachment (Pattern A - Child)

**Purpose**: Additional supporting documents for expense reports

**Pattern**: Pattern A (Lightweight)

**Fields** (25 fields):

```prisma
model ExpenseAttachment {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== PARENT RELATION ====================
  expenseReportId       String      @db.Uuid
  
  expenseReport         ExpenseReport @relation(fields: [tenantId, expenseReportId], references: [tenantId, id], onDelete: Cascade)
  
  @@index([tenantId, expenseReportId])
  
  // ==================== FILE INFO ====================
  fileName              String      @db.VarChar(500)
  fileUrl               String      @db.VarChar(2000)
  fileSize              Int
  mimeType              String      @db.VarChar(100)
  
  // ==================== ATTACHMENT TYPE ====================
  attachmentType        String      @db.VarChar(100)
  // Values: POLICY_DOCUMENT, APPROVAL_FORM, JUSTIFICATION, ADDITIONAL_RECEIPT, OTHER
  
  description           String?     @db.VarChar(1000)
  
  // ==================== UPLOAD INFO ====================
  uploadedByMemberId    String      @db.Uuid
  uploadSource          String?     @db.VarChar(100)
  
  uploadedByMember      Member      @relation(fields: [tenantId, uploadedByMemberId], references: [tenantId, id], onDelete: Restrict)
  
  // ==================== SORT ORDER ====================
  sortOrder             Int         @default(0)
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  @@map("expense_attachment")
}
```

---

### 9. ExpenseHistoryEvent (Pattern A - Child)

**Purpose**: Complete audit trail for expense reports

**Pattern**: Pattern A (Lightweight)

**Fields** (20 fields):

```prisma
model ExpenseHistoryEvent {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== PARENT RELATION ====================
  expenseReportId       String      @db.Uuid
  
  expenseReport         ExpenseReport @relation(fields: [tenantId, expenseReportId], references: [tenantId, id], onDelete: Cascade)
  
  @@index([tenantId, expenseReportId])
  
  // ==================== EVENT INFO ====================
  eventType             String      @db.VarChar(100)
  // Values: REPORT_CREATED, SUBMITTED, APPROVED, REJECTED, PAID, LINE_ADDED, LINE_MODIFIED, RECEIPT_UPLOADED, POLICY_VIOLATION_DETECTED, MANAGER_OVERRIDE
  
  eventDescription      String?     @db.Text
  eventData             Json?       @db.JsonB
  
  // ==================== ACTOR ====================
  eventActorId          String      @db.Uuid
  eventActor            Actor       @relation(fields: [eventActorId], references: [id], onDelete: Restrict)
  
  // ==================== TIMESTAMP ====================
  eventTimestamp        DateTime    @default(now()) @db.Timestamptz(6)
  
  @@index([tenantId, expenseReportId, eventTimestamp])
  @@index([eventTimestamp], type: Brin)
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  @@map("expense_history_event")
}
```

---

## 💳 Corporate Card Models (expenses.prisma)

### 10. CorpCard (Pattern BH - Parent)

**Purpose**: Corporate credit card management with spending controls

**Pattern**: BH (Base Hybrid) with Actor Attribution

**Fields** (60 fields across 12 dimensions):

```prisma
model CorpCard {
  // ==================== IDENTITY (BH Pattern) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  globalId              String      @default(uuid(7)) @db.Uuid
  
  @@unique([tenantId, id])
  @@unique([tenantId, globalId])
  @@index([globalId])
  
  // ==================== BUSINESS IDENTITY ====================
  cardNumber            String      @db.VarChar(100)
  // Last 4 digits only for security
  cardNumberLast4       String      @db.VarChar(4)
  cardHolderName        String      @db.VarChar(255)
  
  @@unique([tenantId, cardNumber])
  @@index([tenantId, cardNumberLast4])
  
  // ==================== CARD DETAILS ====================
  cardType              String      @db.VarChar(50)
  // Values: VISA, MASTERCARD, AMEX, DISCOVER
  
  cardNetwork           String?     @db.VarChar(50)
  cardBrand             String?     @db.VarChar(100)
  isVirtual             Boolean     @default(false)
  
  // ==================== EMPLOYEE ASSIGNMENT ====================
  employeeId            String      @db.Uuid
  assignedMemberId      String      @db.Uuid
  
  employee              Employee    @relation(fields: [tenantId, employeeId], references: [tenantId, id], onDelete: Restrict)
  assignedMember        Member      @relation(fields: [tenantId, assignedMemberId], references: [tenantId, id], onDelete: Restrict)
  
  @@index([tenantId, employeeId])
  @@index([tenantId, assignedMemberId])
  
  // ==================== DATES ====================
  issuedDate            DateTime    @db.Date
  expirationMonth       Int
  expirationYear        Int
  activatedDate         DateTime?   @db.Date
  deactivatedDate       DateTime?   @db.Date
  
  @@index([tenantId, expirationYear, expirationMonth])
  
  // ==================== STATUS ====================
  status                String      @default("ACTIVE") @db.VarChar(50)
  // Values: PENDING_ACTIVATION, ACTIVE, SUSPENDED, CANCELLED, EXPIRED, LOST, STOLEN
  
  statusReason          String?     @db.Text
  
  @@index([tenantId, status])
  
  // ==================== SPENDING LIMITS ====================
  hasSpendingLimit      Boolean     @default(true)
  dailyLimit            Decimal?    @db.Decimal(15, 2)
  weeklyLimit           Decimal?    @db.Decimal(15, 2)
  monthlyLimit          Decimal?    @db.Decimal(15, 2)
  perTransactionLimit   Decimal?    @db.Decimal(15, 2)
  
  // ==================== SPENDING TRACKING ====================
  currentDailySpend     Decimal     @default(0) @db.Decimal(15, 2)
  currentWeeklySpend    Decimal     @default(0) @db.Decimal(15, 2)
  currentMonthlySpend   Decimal     @default(0) @db.Decimal(15, 2)
  totalLifetimeSpend    Decimal     @default(0) @db.Decimal(15, 2)
  
  // ==================== CATEGORIES ====================
  allowedCategories     String[]
  blockedCategories     String[]
  requiresReceiptAbove  Decimal?    @db.Decimal(15, 2)
  
  // ==================== BILLING ====================
  billingCycle          String?     @db.VarChar(50)
  statementDate         Int?
  paymentDueDate        Int?
  currentBalance        Decimal     @default(0) @db.Decimal(15, 2)
  availableCredit       Decimal?    @db.Decimal(15, 2)
  
  // ==================== INTEGRATION ====================
  cardProcessorId       String?     @db.VarChar(255)
  cardProviderName      String?     @db.VarChar(100)
  // Values: BREX, RAMP, DIVVY, AMEX_BUSINESS, CHASE_INK, etc.
  
  externalCardId        String?     @db.VarChar(255)
  lastSyncedAt          DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, cardProcessorId])
  
  // ==================== COUNTS & METRICS ====================
  transactionCount      Int         @default(0)
  disputeCount          Int         @default(0)
  reconciliationCount   Int         @default(0)
  
  // ==================== FLAGS ====================
  isPhysicalCard        Boolean     @default(true)
  allowInternational    Boolean     @default(false)
  allowOnline           Boolean     @default(true)
  requiresPIN           Boolean     @default(false)
  isReconciled          Boolean     @default(false)
  
  // ==================== NOTES ====================
  notes                 String?     @db.Text
  internalNotes         String?     @db.Text
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([updatedAt], type: Brin)
  
  // ==================== GOVERNANCE ====================
  auditCorrelationId    String?     @db.Uuid
  dataClassification    String?     @db.VarChar(50)
  retentionPolicy       String?     @db.VarChar(50)
  metadata              Json?       @db.JsonB
  
  @@index([tenantId, auditCorrelationId])
  
  // ==================== ACTOR ATTRIBUTION (Pattern B) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  createdByActor        Actor       @relation("CorpCard_createdBy", fields: [createdByActorId], references: [id], onDelete: Restrict)
  updatedByActor        Actor       @relation("CorpCard_updatedBy", fields: [updatedByActorId], references: [id], onDelete: Restrict)
  deletedByActor        Actor?      @relation("CorpCard_deletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // ==================== CHILD RELATIONS ====================
  transactions          CorpCardTransaction[]
  reconciliations       CorpCardReconciliation[]
  limits                CorpCardLimit[]
  disputes              CorpCardDispute[]
  receipts              CorpCardReceipt[]
  attachments           CorpCardAttachment[]
  historyEvents         CorpCardHistoryEvent[]
  expenseLines          ExpenseLine[]
  
  @@map("corp_card")
}
```

**Strategic Indexes** (16 total):
1. `[tenantId, id]` - Unique constraint
2. `[tenantId, globalId]` - Unique constraint (1:1:1 traceability)
3. `[globalId]` - Cross-tenant queries
4. `[tenantId, cardNumber]` - Unique business identifier
5. `[tenantId, cardNumberLast4]` - Quick lookup
6. `[tenantId, employeeId]` - Employee card lookup
7. `[tenantId, assignedMemberId]` - Member assignment
8. `[tenantId, expirationYear, expirationMonth]` - Expiration tracking
9. `[tenantId, status]` - Status filtering
10. `[tenantId, cardProcessorId]` - External integration
11. `[tenantId, deletedAt]` - Soft delete queries
12. `[createdAt]` BRIN - Time-series queries
13. `[updatedAt]` BRIN - Change tracking
14. `[tenantId, auditCorrelationId]` - Audit tracing

---

### 11. CorpCardTransaction (Pattern A - Child)

**Purpose**: Individual card transaction records

**Pattern**: Pattern A (Lightweight)

**Fields** (50 fields):

```prisma
model CorpCardTransaction {
  // ==================== IDENTITY (Pattern A) ====================
  id                    String      @id @default(uuid(7)) @db.Uuid
  tenantId              String      @db.Uuid
  
  @@unique([tenantId, id])
  
  // ==================== PARENT RELATION ====================
  corpCardId            String      @db.Uuid
  
  corpCard              CorpCard    @relation(fields: [tenantId, corpCardId], references: [tenantId, id], onDelete: Cascade)
  
  @@index([tenantId, corpCardId])
  
  // ==================== TRANSACTION IDENTITY ====================
  transactionNumber     String?     @db.VarChar(100)
  externalTransactionId String?     @db.VarChar(255)
  
  @@index([tenantId, externalTransactionId])
  
  // ==================== TRANSACTION DETAILS ====================
  transactionDate       DateTime    @db.Timestamptz(6)
  postedDate            DateTime?   @db.Date
  
  @@index([tenantId, transactionDate])
  @@index([tenantId, postedDate])
  
  // ==================== MERCHANT INFO ====================
  merchantName          String      @db.VarChar(500)
  merchantCategory      String?     @db.VarChar(100)
  merchantCategoryCode  String?     @db.VarChar(10)
  // MCC codes for categorization
  
  merchantLocation      String?     @db.VarChar(500)
  merchantCity          String?     @db.VarChar(200)
  merchantState         String?     @db.VarChar(100)
  merchantCountry       String?     @db.VarChar(3)
  merchantZipCode       String?     @db.VarChar(20)
  
  @@index([tenantId, merchantName])
  @@index([tenantId, merchantCategory])
  
  // ==================== FINANCIAL ====================
  transactionAmount     Decimal     @db.Decimal(15, 2)
  currencyCode          String      @default("USD") @db.VarChar(3)
  
  // Original amount (if foreign currency)
  originalAmount        Decimal?    @db.Decimal(15, 2)
  originalCurrency      String?     @db.VarChar(3)
  exchangeRate          Decimal?    @db.Decimal(10, 6)
  
  // Fees
  foreignTransactionFee Decimal     @default(0) @db.Decimal(15, 2)
  cashAdvanceFee        Decimal     @default(0) @db.Decimal(15, 2)
  lateFee               Decimal     @default(0) @db.Decimal(15, 2)
  otherFees             Decimal     @default(0) @db.Decimal(15, 2)
  
  // ==================== TRANSACTION TYPE ====================
  transactionType       String      @db.VarChar(50)
  // Values: PURCHASE, REFUND, CASH_ADVANCE, FEE, CREDIT, REVERSAL
  
  isPending             Boolean     @default(false)
  isCleared             Boolean     @default(false)
  
  @@index([tenantId, transactionType])
  @@index([tenantId, isPending])
  
  // ==================== EXPENSE MATCHING ====================
  isMatched             Boolean     @default(false)
  expenseLineId         String?     @db.Uuid
  expenseReportId       String?     @db.Uuid
  matchedDate           DateTime?   @db.Timestamptz(6)
  
  expenseLine           ExpenseLine? @relation(fields: [tenantId, expenseLineId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, expenseLineId])
  @@index([tenantId, isMatched])
  
  // ==================== RECEIPT ====================
  hasReceipt            Boolean     @default(false)
  receiptRequired       Boolean     @default(false)
  receiptUploaded       Boolean     @default(false)
  
  // ==================== RECONCILIATION ====================
  isReconciled          Boolean     @default(false)
  reconciledDate        DateTime?   @db.Date
  reconciliationId      String?     @db.Uuid
  
  reconciliation        CorpCardReconciliation? @relation(fields: [tenantId, reconciliationId], references: [tenantId, id], onDelete: SetNull)
  
  @@index([tenantId, isReconciled])
  @@index([tenantId, reconciliationId])
  
  // ==================== DISPUTE ====================
  isDisputed            Boolean     @default(false)
  disputeId             String?     @db.Uuid
  
  dispute               CorpCardDispute? @relation(fields: [tenantId, disputeId], references: [tenantId, id], onDelete: SetNull)
  
  // ==================== NOTES ====================
  description           String?     @db.Text
  notes                 String?     @db.Text
  
  // ==================== LIFECYCLE ====================
  createdAt             DateTime    @default(now()) @db.Timestamptz(6)
  updatedAt             DateTime    @updatedAt @db.Timestamptz(6)
  deletedAt             DateTime?   @db.Timestamptz(6)
  
  @@index([tenantId, deletedAt])
  
  // ==================== ACTOR ATTRIBUTION (Pattern A) ====================
  createdByActorId      String      @db.Uuid
  updatedByActorId      String      @db.Uuid
  deletedByActorId      String?     @db.Uuid
  
  // ==================== TENANT RELATION ====================
  tenant                Tenant      @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // ==================== CHILD RELATIONS ====================
  receipts              CorpCardReceipt[]
  
  @@map("corp_card_transaction")
}
```

**Strategic Indexes** (15 total) - showing key performance paths for transaction queries

---

### 12-18. Supporting Models

Due to length constraints, I'll provide condensed versions of the remaining 7 models:

**12. CorpCardReconciliation** - Monthly card statement reconciliation
**13. CorpCardLimit** - Dynamic spending limits and controls
**14. CorpCardDispute** - Disputed charges and chargebacks
**15. CorpCardVendor** - Preferred vendor management
**16. CorpCardReceipt** - Receipt images for transactions
**17. CorpCardAttachment** - Additional card documents
**18. CorpCardHistoryEvent** - Complete audit trail

---

## 🔗 Integration Points

### Integration Matrix

| Module | Integration Type | Data Flow | Trigger |
|--------|-----------------|-----------|---------|
| **Employee (HR)** | Required | Expense submitter lookup | Report creation |
| **Member (Identity)** | Required | Approval and submission | Report workflow |
| **Project** | Optional | Expense allocation to projects | Line item entry |
| **ProjectTask** | Optional | Task-level cost tracking | Project expense |
| **CostCode** | Optional | Job costing integration | Expense categorization |
| **GLAccount** | Required | Accounting integration | Report approval |
| **PaymentMethod** | Optional | Reimbursement processing | Payment initiation |
| **BankAccount** | Optional | Direct deposit | Payment processing |
| **ApprovalRequest** | Optional | Approval workflows | Submit for approval |
| **CRMAccount** | Optional | Vendor tracking | Merchant capture |
| **Document** | Optional | Receipt storage | File upload |

---

## 📐 Visual Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      EXPENSE MODULE ARCHITECTURE                 │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────── EXPENSE REPORTS ────────────────────────────┐
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  ExpenseReport (BH Pattern - Parent)                     │   │
│  │  • reportNumber (EST-2025-001)                           │   │
│  │  • globalId (1:1:1 traceability)                         │   │
│  │  • Triple Status (status, approvalStatus, paymentStatus) │   │
│  │  • Employee linkage                                       │   │
│  │  • Project allocation                                     │   │
│  │  • Financial totals                                       │   │
│  └─────────────────────────────────────────────────────────┘   │
│           │                                                       │
│           ├─────────► ExpenseLine (Pattern A)                   │
│           │            • Line items with categories              │
│           │            • Mileage tracking                        │
│           │            • Project/task allocation                 │
│           │            • Corp card linkage                       │
│           │                                                       │
│           ├─────────► ExpenseReceipt (Pattern A)                │
│           │            • Receipt images                          │
│           │            • OCR processing                          │
│           │            • Auto-matching                           │
│           │                                                       │
│           ├─────────► ExpensePolicyViolation (Pattern A)        │
│           │            • Policy violations                       │
│           │            • Manager overrides                       │
│           │            • Resolution tracking                     │
│           │                                                       │
│           ├─────────► ExpensePayment (Pattern A)                │
│           │            • Reimbursement payments                  │
│           │            • Direct deposit                          │
│           │            • Payment tracking                        │
│           │                                                       │
│           ├─────────► ExpenseAttachment (Pattern A)             │
│           │            • Supporting documents                    │
│           │            • Justifications                          │
│           │                                                       │
│           └─────────► ExpenseHistoryEvent (Pattern A)           │
│                       • Complete audit trail                     │
│                       • Workflow history                         │
└───────────────────────────────────────────────────────────────────┘

┌────────────────── CORPORATE CARDS ──────────────────────────────┐
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  CorpCard (BH Pattern - Parent)                          │   │
│  │  • cardNumber (last 4 digits)                            │   │
│  │  • globalId (1:1:1 traceability)                         │   │
│  │  • Employee assignment                                    │   │
│  │  • Spending limits                                        │   │
│  │  • External integration                                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│           │                                                       │
│           ├─────────► CorpCardTransaction (Pattern A)           │
│           │            • Real-time transactions                  │
│           │            • Merchant details                        │
│           │            • Auto-match to expenses                  │
│           │            • Receipt requirements                    │
│           │                                                       │
│           ├─────────► CorpCardReconciliation (Pattern A)        │
│           │            • Monthly statements                      │
│           │            • Transaction matching                    │
│           │            • Balance verification                    │
│           │                                                       │
│           ├─────────► CorpCardLimit (Pattern A)                 │
│           │            • Dynamic limits                          │
│           │            • Category restrictions                   │
│           │            • Time-based controls                     │
│           │                                                       │
│           ├─────────► CorpCardDispute (Pattern A)               │
│           │            • Disputed charges                        │
│           │            • Chargebacks                             │
│           │            • Resolution tracking                     │
│           │                                                       │
│           ├─────────► CorpCardReceipt (Pattern A)               │
│           │            • Transaction receipts                    │
│           │            • Auto-attachment                         │
│           │                                                       │
│           ├─────────► CorpCardAttachment (Pattern A)            │
│           │            • Card documents                          │
│           │            • Statements                              │
│           │                                                       │
│           └─────────► CorpCardHistoryEvent (Pattern A)          │
│                       • Card lifecycle                           │
│                       • Limit changes                            │
└───────────────────────────────────────────────────────────────────┘

┌────────────────── REFERENCE DATA ───────────────────────────────┐
│                                                                   │
│  ExpenseCategory (Pattern A)                                     │
│  • Hierarchical categories                                       │
│  • GL mapping                                                     │
│  • Policy rules                                                   │
│  • Receipt requirements                                           │
│                                                                   │
│  ExpensePolicy (Pattern A)                                       │
│  • Policy rules by category                                      │
│  • Amount limits                                                  │
│  • Per diem rates                                                 │
│  • Mileage rates                                                  │
│  • Approval thresholds                                            │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📊 Index Strategy

### Performance-Critical Indexes

**High-Volume Query Paths**:
1. Employee expense reports: `[tenantId, employeeId, submittedDate]`
2. Pending approvals: `[tenantId, approvalStatus, submittedDate]`
3. Payment processing: `[tenantId, paymentStatus, dueDate]`
4. Policy violations: `[tenantId, hasPolicyViolations, status]`
5. Card transactions: `[tenantId, corpCardId, transactionDate]`
6. Unmatched transactions: `[tenantId, corpCardId, isMatched]`
7. Missing receipts: `[tenantId, hasReceipts, receiptRequired]`
8. Project expenses: `[tenantId, relatedProjectId, expenseStartDate]`

**BRIN Indexes for Time-Series**:
- `expenseReport.createdAt`
- `expenseReport.submittedDate`
- `corpCard.createdAt`
- `corpCardTransaction.transactionDate`

**GIN Indexes for Arrays/JSONB**:
- `corpCard.allowedCategories` (GIN)
- `corpCard.blockedCategories` (GIN)
- `expenseReport.metadata` (GIN)
- `expenseReceipt.ocrExtractedData` (GIN)

---

## ⚖️ Business Rules

### Expense Report Rules

1. **Report Number Generation**:
   - Format: `EXP-YYYY-NNNNN`
   - Sequential per tenant
   - Generated via NumberSequence service

2. **Status Transitions**:
   ```
   DRAFT → SUBMITTED → IN_REVIEW → APPROVED → PAID
           ↓              ↓           ↓
         CANCELLED    REJECTED    CANCELLED
   ```

3. **Approval Requirements**:
   - Total < $500: Auto-approved (if no violations)
   - $500-$2,500: Manager approval
   - $2,500-$10,000: Director approval
   - $10,000+: Executive approval + finance review

4. **Policy Validation** (on submit):
   - Check all line items against ExpensePolicy
   - Create ExpensePolicyViolation records
   - Block submission if CRITICAL violations (unless override)
   - Flag report: `hasPolicyViolations = true`

5. **Receipt Requirements**:
   - < $75: Receipt optional
   - $75-$500: Receipt required
   - $500+: Receipt mandatory + itemized

6. **Reimbursement Calculation**:
   ```typescript
   totalReimbursable = SUM(expenseLine.reimbursableAmount)
   totalNonReimbursable = SUM(expenseLine.nonReimbursableAmount)
   totalExpenseAmount = totalReimbursable + totalNonReimbursable
   ```

### Corporate Card Rules

1. **Transaction Import**:
   - Real-time feed from card processor
   - Auto-create CorpCardTransaction
   - Check against spending limits
   - Flag if limit exceeded

2. **Spending Limit Enforcement**:
   ```typescript
   if (transaction.amount > card.perTransactionLimit) {
     decline_transaction();
   }
   if (card.currentDailySpend + transaction.amount > card.dailyLimit) {
     decline_transaction();
   }
   // Similar for weekly/monthly
   ```

3. **Auto-Matching Logic**:
   - Match transaction to expense line by:
     - Amount (exact or within 5%)
     - Date (within 3 days)
     - Merchant name (fuzzy match)
     - Card ID
   - If single match found: auto-link
   - If multiple matches: manual selection required
   - If no match: create pending expense line

4. **Receipt Requirements**:
   - Transaction > $75: Receipt required within 7 days
   - Send automated reminders at days 3, 5, 7
   - Escalate to manager at day 10

5. **Card Reconciliation**:
   - Monthly process
   - Match all transactions to statement
   - Verify balances
   - Flag unmatched transactions
   - Generate exception report

---

## 🔄 Complete Workflow Example

### Scenario: Field Employee Business Trip

**Step 1: Corporate Card Transactions (Automatic)**

```typescript
// Day 1: Hotel charge
CorpCardTransaction created:
{
  corpCardId: "...",
  transactionDate: "2025-01-15T18:30:00Z",
  merchantName: "Marriott Hotels",
  merchantCategory: "LODGING",
  transactionAmount: 189.00,
  isPending: true,
  isMatched: false,
  hasReceipt: false,
  receiptRequired: true
}

// Day 2: Breakfast
CorpCardTransaction created:
{
  merchantName: "Starbucks",
  transactionAmount: 12.45,
  merchantCategory: "FOOD_BEVERAGE",
  receiptRequired: false
}

// Day 2: Rental car
CorpCardTransaction created:
{
  merchantName: "Enterprise Rent-A-Car",
  transactionAmount: 87.50,
  merchantCategory: "CAR_RENTAL",
  receiptRequired: true
}

// Day 3: Fuel
CorpCardTransaction created:
{
  merchantName: "Shell Gas Station",
  transactionAmount: 45.00,
  merchantCategory: "GAS_FUEL",
  receiptRequired: false
}
```

**Step 2: Employee Creates Expense Report**

```typescript
// Employee creates report
ExpenseReport created:
{
  reportNumber: "EXP-2025-00789",
  reportName: "Client Site Visit - Phoenix",
  employeeId: "[employee]",
  submittedByMemberId: "[member]",
  expenseStartDate: "2025-01-15",
  expenseEndDate: "2025-01-17",
  status: "DRAFT",
  totalExpenseAmount: 0,
  hasCorpCardExpenses: true
}

// System auto-imports unmatched corp card transactions
FOR EACH unmatchedTransaction:
  ExpenseLine created:
  {
    expenseReportId: "[report]",
    lineNumber: 1,
    description: "Hotel - Marriott",
    expenseCategoryId: "[lodging]",
    expenseDate: "2025-01-15",
    expenseAmount: 189.00,
    paymentSource: "CORPORATE_CARD",
    corpCardTransactionId: "[transaction]",
    hasReceipt: false,
    receiptRequired: true,
    receiptMissing: true // Flagged!
  }
  
  // Link transaction
  UPDATE CorpCardTransaction:
  {
    isMatched: true,
    expenseLineId: "[line]"
  }

// Add personal expenses (mileage)
ExpenseLine created:
{
  lineNumber: 5,
  description: "Mileage - Office to Airport",
  expenseCategoryId: "[mileage]",
  isMileageExpense: true,
  mileageDistance: 45.00,
  mileageRate: 0.67, // 2025 IRS rate
  expenseAmount: 30.15, // 45 × 0.67
  paymentSource: "PERSONAL",
  originAddress: "123 Office St",
  destinationAddress: "PHX Airport"
}

// Update report totals
UPDATE ExpenseReport:
{
  totalExpenseAmount: 364.10, // Sum of all lines
  totalReimbursable: 30.15, // Personal expenses only
  totalNonReimbursable: 333.95, // Corp card expenses
  lineItemCount: 5,
  hasMissingReceipts: true, // Hotel receipt missing
  hasCorpCardExpenses: true,
  hasPersonalExpenses: true
}
```

**Step 3: Upload Receipts (Mobile App)**

```typescript
// Employee uploads hotel receipt
ExpenseReceipt created:
{
  expenseReportId: "[report]",
  expenseLineId: "[hotel line]",
  fileName: "marriott_receipt.jpg",
  fileUrl: "s3://...",
  fileSize: 1234567,
  mimeType: "image/jpeg",
  uploadedByMemberId: "[member]",
  uploadSource: "MOBILE_APP"
}

// Trigger OCR processing
OCR Service processes receipt:
{
  ocrStatus: "PROCESSING",
  // ... later
  ocrStatus: "COMPLETED",
  ocrMerchantName: "Marriott Phoenix Downtown",
  ocrDate: "2025-01-15",
  ocrTotalAmount: 189.00,
  ocrCurrencyCode: "USD",
  ocrConfidence: 0.98
}

// Auto-match verification
IF (ocrTotalAmount == expenseLine.expenseAmount) {
  UPDATE ExpenseReceipt: { isMatched: true }
  UPDATE ExpenseLine: { 
    hasReceipt: true,
    receiptMissing: false
  }
  UPDATE ExpenseReport: {
    receiptCount: receiptCount + 1,
    hasMissingReceipts: false // All receipts now present
  }
}
```

**Step 4: Policy Validation (on submit)**

```typescript
// Employee submits report
ExpenseReport.status = "SUBMITTED"

// Run policy checks
PolicyEngine.validate(expenseReport):

FOR EACH expenseLine:
  policies = ExpensePolicy.find({
    expenseCategoryId: line.expenseCategoryId,
    effectiveDate: line.expenseDate,
    isActive: true
  })
  
  FOR EACH policy:
    // Check 1: Amount limit
    IF (policy.maxAmountPerTransaction 
        && line.expenseAmount > policy.maxAmountPerTransaction) {
      ExpensePolicyViolation created:
      {
        expenseLineId: "[line]",
        expensePolicyId: "[policy]",
        violationType: "AMOUNT_EXCEEDED",
        violationSeverity: "MEDIUM",
        policyLimit: 150.00,
        actualAmount: 189.00,
        variance: 39.00,
        violationMessage: "Lodging expense exceeds $150 limit",
        status: "OPEN"
      }
      
      UPDATE ExpenseLine: {
        hasPolicyViolation: true,
        violationSeverity: "MEDIUM"
      }
    }
    
    // Check 2: Receipt requirement
    IF (policy.requiresReceipt 
        && line.expenseAmount >= policy.receiptThreshold
        && !line.hasReceipt) {
      ExpensePolicyViolation created:
      {
        violationType: "MISSING_RECEIPT",
        violationSeverity: "HIGH",
        status: "OPEN"
      }
    }

// Update report with violation summary
UPDATE ExpenseReport:
{
  hasPolicyViolations: true,
  violationCount: 1,
  violationSeverity: "MEDIUM",
  totalPolicyViolations: 39.00,
  status: "SUBMITTED",
  submittedDate: NOW()
}

// Create history event
ExpenseHistoryEvent created:
{
  eventType: "SUBMITTED",
  eventDescription: "Expense report submitted with 1 policy violation",
  eventData: { violationCount: 1 }
}
```

**Step 5: Approval Workflow**

```typescript
// System determines approval requirements
IF (expenseReport.totalExpenseAmount < 500 
    && !expenseReport.hasPolicyViolations) {
  // Auto-approve
  UPDATE ExpenseReport: {
    status: "APPROVED",
    approvalStatus: "APPROVED",
    approvedDate: NOW(),
    approvedAmount: totalReimbursable
  }
} ELSE {
  // Manager approval required
  ApprovalRequest created:
  {
    requestType: "EXPENSE_REPORT",
    sourceId: expenseReport.id,
    requiredApprovers: [employeeManagerId],
    status: "PENDING"
  }
  
  UPDATE ExpenseReport: {
    approvalRequestId: "[request]",
    approvalStatus: "PENDING_APPROVAL",
    requiresApproval: true
  }
  
  // Send notification to manager
  Notification created:
  {
    recipientMemberId: "[manager]",
    notificationType: "EXPENSE_APPROVAL_NEEDED",
    title: "Expense Report Needs Approval",
    message: "EXP-2025-00789 from [Employee] ($364.10)"
  }
}

// Manager reviews
Manager sees:
- Report summary
- All line items
- Policy violations with explanation
- Receipts attached

Manager actions:
1. Reviews policy violation (hotel over $150)
2. Checks project budget impact
3. Reviews all receipts

// Manager approves with override
UPDATE ExpensePolicyViolation:
{
  status: "MANAGER_OVERRIDE",
  resolution: "MANAGER_OVERRIDE",
  resolutionNotes: "Approved - Last minute booking, no alternatives",
  isManagerOverride: true,
  overrideReason: "Emergency travel requirement",
  overrideByMemberId: "[manager]",
  overrideDate: NOW()
}

UPDATE ExpenseReport:
{
  status: "APPROVED",
  approvalStatus: "APPROVED",
  approvedByMemberId: "[manager]",
  approvedDate: NOW(),
  approvedAmount: 30.15, // Only reimbursable (personal mileage)
  amountDue: 30.15,
  managerOverride: true,
  managerOverrideReason: "Emergency travel"
}

// Create history
ExpenseHistoryEvent:
{
  eventType: "APPROVED",
  eventDescription: "Approved by manager with policy override"
}
```

**Step 6: Project Cost Allocation**

```typescript
// If expense lines linked to project
FOR EACH expenseLine WHERE projectId IS NOT NULL:
  
  // Update project task actual costs
  UPDATE ProjectTask:
  {
    actualCost += expenseLine.expenseAmount
  }
  
  // Create job cost entry
  JobCostLine created:
  {
    projectId: expenseLine.projectId,
    costCodeId: expenseLine.costCodeId,
    costType: "EXPENSE",
    actualAmount: expenseLine.expenseAmount,
    sourceType: "EXPENSE_LINE",
    sourceId: expenseLine.id
  }
  
  // Update project totals
  UPDATE Project:
  {
    totalActualCost += expenseLine.expenseAmount,
    // Recalculate variance
    costVariance = totalActualCost - totalBudgetedCost
  }
```

**Step 7: Payment Processing**

```typescript
// Finance processes reimbursement
ExpensePayment created:
{
  expenseReportId: "[report]",
  paymentNumber: "PAY-2025-01234",
  paymentAmount: 30.15,
  paymentMethod: "DIRECT_DEPOSIT",
  bankAccountId: "[employee bank]",
  status: "PENDING",
  scheduledDate: "2025-01-25" // Next pay cycle
}

// On payment date
Payment Processor executes:
{
  ACH transfer initiated
}

UPDATE ExpensePayment:
{
  status: "PROCESSING",
  processedDate: NOW()
}

// When cleared
UPDATE ExpensePayment:
{
  status: "PAID",
  paidDate: "2025-01-27",
  clearedDate: "2025-01-27"
}

UPDATE ExpenseReport:
{
  paymentStatus: "PAID",
  paidAmount: 30.15,
  amountDue: 0.00,
  paidDate: "2025-01-27",
  status: "PAID"
}

// Create history
ExpenseHistoryEvent:
{
  eventType: "PAID",
  eventDescription: "Reimbursement paid via direct deposit",
  eventData: { paymentAmount: 30.15 }
}
```

**Step 8: Accounting Integration**

```typescript
// Post to general ledger
FOR EACH expenseLine:
  
  GLJournalLine created:
  {
    glAccountId: expenseCategory.glAccountId,
    debitAmount: expenseLine.expenseAmount,
    description: expenseLine.description,
    sourceType: "EXPENSE_LINE",
    sourceId: expenseLine.id
  }
  
  // If project expense, also post to WIP
  IF (expenseLine.projectId) {
    GLJournalLine created:
    {
      glAccountId: "[WIP account]",
      debitAmount: expenseLine.expenseAmount,
      projectId: expenseLine.projectId
    }
  }

// Reimbursement payment entry
GLJournalLine created:
{
  glAccountId: "[Employee Payable]",
  creditAmount: 30.15,
  description: "Reimbursement - EXP-2025-00789"
}

GLJournal posted to ledger
```

**Complete Traceability**:
- CorpCard → CorpCardTransaction → ExpenseLine → ExpenseReport → Payment → GL
- Every expense traces from card swipe to general ledger entry
- Project costs updated in real-time
- Policy compliance documented
- Complete audit trail maintained

---

**Document Version**: 1.0  
**Last Updated**: November 17, 2025  
**Status**: ✅ Canonical Reference  
**Next Review**: March 2026
