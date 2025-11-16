# Invoice Module - Complete Flow Documentation

## 📋 Executive Summary

**Module**: `invoice.prisma`  
**Pattern**: BH (Base Hybrid) - Tenant + Global  
**Purpose**: Revenue recognition and accounts receivable management  
**Models**: 18 models  
**Integration**: Estimate, Project, Payment, Billing, GL  

---

## 🎯 Strategic Purpose

The Invoice module is the **revenue recognition entry point** in the financial value chain. It maintains **1:1:1 immutable traceability** with Estimate and Project through shared `globalId`, enabling complete audit trails from initial quote through payment collection.

### Key Business Objectives

1. **Revenue Recognition**: Accurate, compliant revenue tracking
2. **AR Management**: Streamlined collections and aging reports
3. **Progress Billing**: Support for milestone and progress-based invoicing
4. **Retainage Management**: Construction-specific retainage tracking
5. **Client Communication**: No-login public links for payment
6. **Financial Integration**: Seamless GL posting and reconciliation

---

## 🏗️ Module Architecture

### Model Count: 18 Models

#### Parent Model (1)
- **Invoice** - Main invoice header (BH pattern, Actor relations enabled)

#### Child Models (17)
1. **InvoiceLineItem** - Billable items/services
2. **InvoiceTax** - Tax calculations and jurisdictions
3. **InvoiceDiscount** - Discounts applied to invoice
4. **InvoiceFee** - Fees, overheads, finance charges
5. **InvoiceRetainage** - Construction retainage withholding
6. **InvoiceProgress** - Progress billing tracking
7. **InvoiceMilestone** - Milestone-based billing
8. **InvoicePaymentApplication** - Payment allocation tracking
9. **InvoiceAttachment** - Documents, PDFs, supporting files
10. **InvoiceComment** - Internal collaboration notes
11. **InvoiceRevision** - Immutable snapshots of changes
12. **InvoiceAdjustment** - Post-invoice corrections
13. **InvoiceCredit** - Credit memos and returns
14. **InvoiceDebit** - Debit memos and additional charges
15. **InvoiceHistory** - Audit trail events
16. **InvoicePublicLink** - No-login client payment links
17. **InvoiceReminder** - Automated payment reminders

---

## 🔄 1:1:1 Traceability Flow

### Global ID Pattern

```
Estimate.globalId === Project.globalId === Invoice.globalId

Same globalId across all three modules = Immutable audit trail
```

### Document Number Continuity

```
Estimate.estimateNumber  → "EST-2025-00123"
Project.projectNumber    → "EST-2025-00123" (inherited)
Invoice.invoiceNumber    → "EST-2025-00123" (inherited)

Same number across entire lifecycle for client consistency
```

### Data Flow

```
ESTIMATE (Approved) → AUTO-GENERATE → INVOICE
     │                                      │
     ├─ EstimateLineItem  ────────►  InvoiceLineItem
     ├─ EstimateTax       ────────►  InvoiceTax
     ├─ EstimateDiscount  ────────►  InvoiceDiscount
     ├─ EstimateFee       ────────►  InvoiceFee
     └─ EstimateAttachment ───────►  InvoiceAttachment (optional)

PROJECT (Completed Work) → PROGRESS INVOICE
     │
     ├─ ProjectTask (% complete) ──► InvoiceLineItem (billed %)
     ├─ ProjectMilestone (reached) ► InvoiceMilestone (triggered)
     └─ ActualCosts vs Budget ─────► Profitability tracking
```

---

## 📊 Invoice Model - Complete Structure

### Identity & Tenant Isolation

```prisma
id       String @id @default(uuid(7)) @db.Uuid
tenantId String @db.Uuid
globalId String @db.Uuid  // 1:1:1 with Estimate/Project
```

### Business Identity

```prisma
invoiceNumber      String   @db.VarChar(50)    // EST-2025-00123 (inherited)
invoiceDate        DateTime @db.Timestamptz(6) // Issue date
dueDate            DateTime @db.Timestamptz(6) // Payment due date
title              String   @db.VarChar(255)   // Invoice description
referenceCode      String?  @db.VarChar(100)   // PO number, etc.
description        String?  @db.Text
termsAndConditions String?  @db.Text           // Legal terms
```

### Triple Status Dimension

```prisma
status            InvoiceStatus         @default(DRAFT)
paymentStatus     InvoicePaymentStatus  @default(UNPAID)
collectionStatus  InvoiceCollectionStatus @default(CURRENT)
```

**Status Dimensions**:
1. **status**: Workflow state (DRAFT → SENT → PAID → CLOSED)
2. **paymentStatus**: Payment tracking (UNPAID → PARTIAL → PAID → OVERPAID)
3. **collectionStatus**: AR aging (CURRENT → OVERDUE_30 → OVERDUE_60 → OVERDUE_90 → COLLECTIONS)

### CRM Linkage (CORRECTED Model Names)

```prisma
// Client account (REQUIRED)
crmAccountId String @db.Uuid
crmAccount Account @relation(fields: [tenantId, crmAccountId], references: [tenantId, id], onDelete: Restrict)

// Primary contact (OPTIONAL)
crmContactId String? @db.Uuid
crmContact Contact? @relation(fields: [tenantId, crmContactId], references: [tenantId, id], onDelete: SetNull)

// Billing address (OPTIONAL override)
billToAddressId String? @db.Uuid
billToAddress AccountAddress? @relation(fields: [tenantId, billToAddressId], references: [tenantId, id], onDelete: SetNull)
```

### Source Linkage (1:1:1 Traceability)

```prisma
// Link to source estimate (via globalId)
sourceEstimateId String? @db.Uuid
sourceEstimate Estimate? @relation(fields: [tenantId, sourceEstimateId], references: [tenantId, id], onDelete: Restrict)

// Link to source project (via globalId)
sourceProjectId String? @db.Uuid
sourceProject Project? @relation(fields: [tenantId, sourceProjectId], references: [tenantId, id], onDelete: Restrict)

// Optional linked contract
contractId String? @db.Uuid
contract Contract? @relation(fields: [tenantId, contractId], references: [tenantId, id], onDelete: SetNull)
```

### Financial Totals (Denormalized for Performance)

```prisma
currencyCode   String  @db.Char(3)         // ISO 4217 (USD, EUR, CAD)

subtotalAmount Decimal @default(0) @db.Decimal(12, 2) // Sum of line items
discountAmount Decimal @default(0) @db.Decimal(12, 2) // Total discounts
taxAmount      Decimal @default(0) @db.Decimal(12, 2) // Total taxes
feeAmount      Decimal @default(0) @db.Decimal(12, 2) // Total fees

// Construction-specific
retainageAmount      Decimal @default(0) @db.Decimal(12, 2) // Amount withheld
retainagePercentage  Decimal? @db.Decimal(5, 2)             // Default 5-10%

// Grand totals
totalAmount          Decimal @default(0) @db.Decimal(12, 2) // Amount due
amountPaid           Decimal @default(0) @db.Decimal(12, 2) // Payments received
amountDue            Decimal @default(0) @db.Decimal(12, 2) // Balance remaining

// Analytics
lineItemCount        Int     @default(0)
totalQuantity        Decimal @default(0) @db.Decimal(10, 4)
```

### Payment Tracking

```prisma
// Payment terms
paymentTermsId String? @db.Uuid
paymentTerms PaymentTerms? @relation(fields: [tenantId, paymentTermsId], references: [tenantId, id], onDelete: SetNull)

// Payment tracking
lastPaymentDate      DateTime? @db.Timestamptz(6)
lastPaymentAmount    Decimal?  @db.Decimal(12, 2)
paymentCount         Int       @default(0)
partialPaymentAllowed Boolean  @default(true)
earlyPaymentDiscount Decimal?  @db.Decimal(5, 2) // 2% if paid within 10 days
```

### Billing Type & Progress

```prisma
billingType InvoiceBillingType @default(STANDARD)

// STANDARD: One-time invoice
// PROGRESS: Percentage-based billing
// MILESTONE: Milestone-triggered billing
// RECURRING: Subscription/service contracts
// TIME_AND_MATERIALS: T&M billing
// RETAINAGE_RELEASE: Final retainage invoice

// Progress billing (when billingType = PROGRESS)
progressPercentage      Decimal? @db.Decimal(5, 2) // % complete
cumulativeBilledAmount  Decimal? @db.Decimal(12, 2) // Total billed to date
previouslyBilledAmount  Decimal? @db.Decimal(12, 2) // Prior invoices
currentPeriodAmount     Decimal? @db.Decimal(12, 2) // This invoice

// Milestone billing (when billingType = MILESTONE)
milestoneId String? @db.Uuid
milestone ProjectMilestone? @relation(fields: [tenantId, milestoneId], references: [tenantId, id], onDelete: SetNull)
```

### Event Timestamps (Business Events)

```prisma
issueDate       DateTime  @default(now()) @db.Timestamptz(6) // When invoice issued
sentToClientAt  DateTime? @db.Timestamptz(6) // When sent to client
clientViewedAt  DateTime? @db.Timestamptz(6) // When client opened link
firstPaymentAt  DateTime? @db.Timestamptz(6) // First payment received
fullyPaidAt     DateTime? @db.Timestamptz(6) // Fully paid timestamp
voidedAt        DateTime? @db.Timestamptz(6) // If voided
writtenOffAt    DateTime? @db.Timestamptz(6) // If written off as bad debt
lastReminderAt  DateTime? @db.Timestamptz(6) // Last reminder sent
nextReminderAt  DateTime? @db.Timestamptz(6) // Next reminder scheduled
```

### Behavior Flags

```prisma
isRecurring        Boolean @default(false) // Recurring invoice
isProgress         Boolean @default(false) // Progress billing
isMilestone        Boolean @default(false) // Milestone billing
isRetainage        Boolean @default(false) // Retainage invoice
isFinal            Boolean @default(false) // Final invoice flag
isVoided           Boolean @default(false) // Voided flag
isWrittenOff       Boolean @default(false) // Bad debt write-off
autoSendReminders  Boolean @default(true)  // Auto-send payment reminders
allowPartialPayment Boolean @default(true) // Accept partial payments
requiresApproval   Boolean @default(false) // Internal approval required
```

### External Module Integration

```prisma
// Approvals module
approvalRequestId String? @db.Uuid
approvalRequest ApprovalRequest? @relation(fields: [tenantId, approvalRequestId], references: [tenantId, id], onDelete: SetNull)

// E-signature module
eSignatureEnvelopeId String? @db.Uuid
eSignatureEnvelope ESignatureEnvelope? @relation(fields: [tenantId, eSignatureEnvelopeId], references: [tenantId, id], onDelete: SetNull)

// Number sequence
numberSequenceAllocationId String? @db.Uuid
```

### Ownership & Assignment

```prisma
ownerMemberId String? @db.Uuid
ownerMember Member? @relation(fields: [tenantId, ownerMemberId], references: [tenantId, id], onDelete: SetNull)
```

### Governance Fields

```prisma
auditCorrelationId String?                      @db.Uuid
dataClassification InvoiceDataClassification   @default(CONFIDENTIAL)
retentionPolicy    RetentionPolicy?
metadata           Json?                         @db.JsonB
recordSource       String?                       @db.VarChar(50)
timezone           String?                       @db.VarChar(50)
```

---

## 🔗 Child Models Overview

### InvoiceLineItem

**Purpose**: Individual billable items/services

```prisma
model InvoiceLineItem {
  id          String  @id @default(uuid(7)) @db.Uuid
  tenantId    String  @db.Uuid
  invoiceId   String  @db.Uuid
  
  // Source tracking (1:1:1 traceability)
  sourceEstimateLineItemId String? @db.Uuid
  sourceProjectTaskId      String? @db.Uuid
  
  // Item details
  itemType        InvoiceLineItemType @default(PRODUCT) // PRODUCT, SERVICE, LABOR, MATERIAL, EQUIPMENT
  itemCode        String?  @db.VarChar(100)
  description     String   @db.Text
  
  // Quantity & pricing
  quantity        Decimal  @db.Decimal(10, 4)
  unitPrice       Decimal  @db.Decimal(12, 2)
  unitOfMeasure   String?  @db.VarChar(50)
  
  // Calculated amounts
  lineAmount      Decimal  @db.Decimal(12, 2) // quantity * unitPrice
  discountAmount  Decimal  @default(0) @db.Decimal(12, 2)
  taxAmount       Decimal  @default(0) @db.Decimal(12, 2)
  totalAmount     Decimal  @db.Decimal(12, 2)
  
  // Progress billing
  progressPercentage  Decimal? @db.Decimal(5, 2)
  billedToDate        Decimal? @db.Decimal(12, 2)
  previouslyBilled    Decimal? @db.Decimal(12, 2)
  currentBilling      Decimal? @db.Decimal(12, 2)
  
  // Sorting & grouping
  sortOrder       Int      @default(0)
  sectionId       String?  @db.Uuid
  
  // Cost tracking (for margin analysis)
  costAmount      Decimal? @db.Decimal(12, 2)
  markupPercentage Decimal? @db.Decimal(5, 2)
  
  // Lifecycle
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt @db.Timestamptz(6)
  deletedAt DateTime? @db.Timestamptz(6)
  
  // Governance (UUID only - no Actor relations for child)
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  
  // Relations
  invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
  attachments InvoiceLineItemAttachment[]
  
  @@unique([tenantId, id])
  @@index([tenantId, invoiceId])
  @@index([tenantId, sourceEstimateLineItemId])
  @@index([tenantId, sourceProjectTaskId])
  @@index([tenantId, sectionId])
  @@index([tenantId, itemType])
  
  @@map("invoice_line_items")
}
```

### InvoiceTax

**Purpose**: Tax calculations and jurisdiction tracking

```prisma
model InvoiceTax {
  id              String  @id @default(uuid(7)) @db.Uuid
  tenantId        String  @db.Uuid
  invoiceId       String  @db.Uuid
  
  // Tax details
  taxName         String  @db.VarChar(100)  // "Sales Tax", "VAT", etc.
  taxJurisdiction String? @db.VarChar(100)  // "California", "EU", etc.
  taxRate         Decimal @db.Decimal(7, 4) // 8.25% = 0.0825
  
  // Applied to
  taxableAmount   Decimal @db.Decimal(12, 2) // Base amount taxed
  taxAmount       Decimal @db.Decimal(12, 2) // Calculated tax
  
  // Line-level or header-level
  invoiceLineItemId String? @db.Uuid
  
  // Compliance
  taxCode         String? @db.VarChar(50)
  taxExempt       Boolean @default(false)
  exemptionReason String? @db.VarChar(255)
  
  // Lifecycle
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt @db.Timestamptz(6)
  
  // Relations
  invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
  
  @@unique([tenantId, id])
  @@index([tenantId, invoiceId])
  @@index([tenantId, taxJurisdiction])
  
  @@map("invoice_taxes")
}
```

### InvoiceRetainage

**Purpose**: Construction retainage withholding tracking

```prisma
model InvoiceRetainage {
  id                      String  @id @default(uuid(7)) @db.Uuid
  tenantId                String  @db.Uuid
  invoiceId               String  @db.Uuid
  
  // Retainage calculation
  retainagePercentage     Decimal @db.Decimal(5, 2) // 5-10% typical
  baseAmount              Decimal @db.Decimal(12, 2) // Amount subject to retainage
  retainageAmount         Decimal @db.Decimal(12, 2) // Amount withheld
  
  // Cumulative tracking
  cumulativeRetainage     Decimal @db.Decimal(12, 2) // Total withheld to date
  previouslyReleased      Decimal @default(0) @db.Decimal(12, 2)
  currentRelease          Decimal @default(0) @db.Decimal(12, 2)
  remainingRetainage      Decimal @db.Decimal(12, 2)
  
  // Release tracking
  isReleased              Boolean @default(false)
  releasePercentage       Decimal? @db.Decimal(5, 2)
  releasedAt              DateTime? @db.Timestamptz(6)
  releaseReason           String? @db.VarChar(255)
  
  // Lifecycle
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt @db.Timestamptz(6)
  
  // Relations
  invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
  
  @@unique([tenantId, id])
  @@index([tenantId, invoiceId])
  @@index([tenantId, isReleased])
  
  @@map("invoice_retainage")
}
```

### InvoicePublicLink

**Purpose**: No-login client payment links (like Estimate)

```prisma
model InvoicePublicLink {
  id               String   @id @default(uuid(7)) @db.Uuid
  tenantId         String   @db.Uuid
  invoiceId        String   @db.Uuid
  
  // Secure access
  token            String   @unique @db.VarChar(255) // Secure random token
  shortCode        String?  @unique @db.VarChar(20)  // Short link: /pay/ABC123
  
  // Access control
  isActive         Boolean  @default(true)
  expiresAt        DateTime? @db.Timestamptz(6)
  maxViews         Int?     // Optional view limit
  viewCount        Int      @default(0)
  
  // Tracking
  firstViewedAt    DateTime? @db.Timestamptz(6)
  lastViewedAt     DateTime? @db.Timestamptz(6)
  firstPaymentAt   DateTime? @db.Timestamptz(6)
  
  // Client info (captured on first view)
  clientIpAddress  String?  @db.VarChar(45)
  clientUserAgent  String?  @db.Text
  clientDevice     String?  @db.VarChar(100)
  
  // Payment options
  allowOnlinePayment Boolean @default(true)
  allowBankTransfer  Boolean @default(true)
  allowCheck         Boolean @default(false)
  
  // Lifecycle
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt @db.Timestamptz(6)
  
  // Governance
  createdByActorId String? @db.Uuid
  
  // Relations
  invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
  
  @@unique([tenantId, id])
  @@index([tenantId, invoiceId])
  @@index([token])
  @@index([shortCode])
  @@index([tenantId, isActive])
  
  @@map("invoice_public_links")
}
```

### InvoiceReminder

**Purpose**: Automated payment reminder tracking

```prisma
model InvoiceReminder {
  id                 String   @id @default(uuid(7)) @db.Uuid
  tenantId           String   @db.Uuid
  invoiceId          String   @db.Uuid
  
  // Reminder details
  reminderType       InvoiceReminderType @default(PAYMENT_DUE)
  daysBeforeDue      Int?     // Send 7 days before due
  daysAfterDue       Int?     // Send 3 days after due
  
  // Status
  status             ReminderStatus @default(SCHEDULED)
  scheduledAt        DateTime  @db.Timestamptz(6)
  sentAt             DateTime? @db.Timestamptz(6)
  failedAt           DateTime? @db.Timestamptz(6)
  failureReason      String?   @db.Text
  
  // Delivery
  deliveryMethod     String    @db.VarChar(20) // EMAIL, SMS, BOTH
  recipientEmail     String?   @db.VarChar(255)
  recipientPhone     String?   @db.VarChar(20)
  
  // Template
  emailTemplateId    String?   @db.Uuid
  smsTemplateId      String?   @db.Uuid
  
  // Tracking
  emailMessageId     String?   @db.Uuid
  smsMessageId       String?   @db.Uuid
  
  // Lifecycle
  createdAt DateTime @default(now()) @db.Timestamptz(6)
  updatedAt DateTime @updatedAt @db.Timestamptz(6)
  
  // Relations
  invoice Invoice @relation(fields: [tenantId, invoiceId], references: [tenantId, id], onDelete: Cascade)
  
  @@unique([tenantId, id])
  @@index([tenantId, invoiceId])
  @@index([tenantId, status])
  @@index([scheduledAt])
  
  @@map("invoice_reminders")
}

enum InvoiceReminderType {
  PAYMENT_DUE       // Before due date
  OVERDUE           // After due date
  FINAL_NOTICE      // Last reminder before collections
  THANK_YOU         // Payment received
  CUSTOM            // Custom reminder
}

enum ReminderStatus {
  SCHEDULED
  SENT
  FAILED
  CANCELLED
}
```

---

## 📊 Status Enums

### InvoiceStatus (Primary Workflow)

```prisma
enum InvoiceStatus {
  DRAFT                    // User creating invoice
  PENDING_APPROVAL         // Internal approval required
  APPROVED                 // Internally approved
  SENT                     // Sent to client
  VIEWED                   // Client opened invoice
  PARTIALLY_PAID           // Some payment received
  PAID                     // Fully paid
  OVERDUE                  // Past due date
  IN_COLLECTIONS           // Sent to collections
  VOIDED                   // Invoice cancelled
  WRITTEN_OFF              // Bad debt write-off
  DELETED                  // Soft deleted
}
```

### InvoicePaymentStatus

```prisma
enum InvoicePaymentStatus {
  UNPAID         // No payment received
  PARTIAL        // Partially paid
  PAID           // Fully paid
  OVERPAID       // Overpayment (credit)
  REFUNDED       // Payment refunded
}
```

### InvoiceCollectionStatus (AR Aging)

```prisma
enum InvoiceCollectionStatus {
  CURRENT        // Not yet due or within terms
  OVERDUE_30     // 1-30 days overdue
  OVERDUE_60     // 31-60 days overdue
  OVERDUE_90     // 61-90 days overdue
  OVERDUE_120    // 91-120 days overdue
  COLLECTIONS    // Sent to collections
  WRITTEN_OFF    // Bad debt
}
```

### InvoiceBillingType

```prisma
enum InvoiceBillingType {
  STANDARD             // One-time invoice
  PROGRESS             // Progress/percentage billing
  MILESTONE            // Milestone-triggered
  RECURRING            // Subscription/service
  TIME_AND_MATERIALS   // T&M billing
  RETAINAGE_RELEASE    // Final retainage
  CREDIT_MEMO          // Credit/return
  DEBIT_MEMO           // Additional charges
}
```

### InvoiceLineItemType

```prisma
enum InvoiceLineItemType {
  PRODUCT     // Physical product
  SERVICE     // Service/labor
  LABOR       // Labor hours
  MATERIAL    // Construction materials
  EQUIPMENT   // Equipment rental
  PERMIT      // Permits/fees
  OVERHEAD    // Overhead allocation
  TRAVEL      // Travel expenses
  CUSTOM      // Custom item
}
```

---

## 🔄 Business Workflows

### Workflow 1: Standard Invoice Creation

```
1. CREATE INVOICE (from Estimate or Manual)
   ├── Auto-generate if estimate.autoCreateInvoiceOnApproval = true
   ├── Copy globalId from Estimate
   ├── Copy invoiceNumber from estimateNumber
   ├── Set status = DRAFT
   └── Copy line items, taxes, discounts, fees

2. ADD/EDIT LINE ITEMS
   ├── InvoiceLineItem (quantity, price, description)
   ├── Calculate lineAmount = quantity * unitPrice
   ├── Apply discounts
   ├── Calculate taxes
   └── Update invoice totals (denormalized)

3. INTERNAL APPROVAL (if required)
   ├── requiresApproval = true
   ├── Create ApprovalRequest
   ├── status = PENDING_APPROVAL
   └── Wait for approval decision

4. SEND TO CLIENT
   ├── Create InvoicePublicLink (secure token)
   ├── Send email via EmailEngine
   ├── sentToClientAt = now
   ├── status = SENT
   └── Schedule automatic reminders

5. CLIENT INTERACTION
   ├── Client opens link → clientViewedAt
   ├── status = VIEWED
   └── Client initiates payment

6. PAYMENT RECEIVED
   ├── Create Payment record
   ├── Create InvoicePaymentApplication
   ├── Update amountPaid
   ├── Calculate amountDue
   ├── Update paymentStatus (PARTIAL or PAID)
   ├── If fully paid: fullyPaidAt = now
   └── status = PAID

7. ACCOUNTING INTEGRATION
   ├── Post to GL (debit AR, credit Revenue)
   ├── Create Transaction records
   ├── Update customer receivable ledger
   └── Update aging reports
```

### Workflow 2: Progress Billing

```
1. CREATE PROGRESS INVOICE
   ├── billingType = PROGRESS
   ├── Link to sourceProjectId
   ├── Set progressPercentage (e.g., 40%)
   └── status = DRAFT

2. CALCULATE PROGRESS AMOUNTS
   FOR EACH ProjectTask:
   ├── Get task.percentComplete
   ├── Calculate: totalBudget * percentComplete
   ├── Subtract: previouslyBilledAmount
   ├── Create InvoiceLineItem with currentBilling
   └── Track billedToDate cumulatively

3. APPLY RETAINAGE (if applicable)
   ├── Create InvoiceRetainage
   ├── retainagePercentage = 10% (typical)
   ├── retainageAmount = subtotal * 0.10
   ├── Reduce totalAmount by retainageAmount
   └── Track cumulativeRetainage

4. SEND & COLLECT
   ├── Follow standard workflow (steps 3-7 above)
   └── Update project billing status

5. SUBSEQUENT PROGRESS INVOICES
   ├── Create new Invoice
   ├── Set previouslyBilledAmount from prior invoices
   ├── Bill only new progress
   └── Update cumulative totals

6. FINAL INVOICE
   ├── Bill remaining 100% - previouslyBilled
   ├── Create retainage release invoice
   ├── billingType = RETAINAGE_RELEASE
   ├── Release all withheld retainage
   └── isFinal = true
```

### Workflow 3: Milestone Billing

```
1. PROJECT SETUP
   ├── Define ProjectMilestone records
   ├── Assign dollar amounts to each milestone
   ├── Set trigger conditions
   └── Link to invoice templates

2. MILESTONE REACHED
   ├── ProjectMilestone.status = COMPLETED
   ├── Trigger: Auto-create invoice
   ├── billingType = MILESTONE
   └── Link milestoneId

3. INVOICE GENERATION
   ├── Use milestone.billingAmount
   ├── Create InvoiceMilestone record
   ├── Attach required deliverables
   └── status = DRAFT

4. APPROVAL & DELIVERY
   ├── Internal approval
   ├── Client sign-off (optional)
   └── Send invoice
```

### Workflow 4: Payment Reminders

```
1. INVOICE SENT
   ├── autoSendReminders = true
   ├── Create InvoiceReminder schedule
   └── Based on payment terms

2. REMINDER SCHEDULE
   ├── 7 days before due: PAYMENT_DUE reminder
   ├── Due date: PAYMENT_DUE reminder
   ├── 3 days after due: OVERDUE reminder
   ├── 15 days after due: OVERDUE reminder
   ├── 30 days after due: FINAL_NOTICE reminder
   └── 45 days after due: Escalate to collections

3. REMINDER DELIVERY
   ├── Check InvoiceReminder.scheduledAt
   ├── If time reached & status = SCHEDULED:
   │   ├── Send email via EmailEngine
   │   ├── Send SMS (optional)
   │   ├── Update sentAt
   │   └── status = SENT
   └── Track delivery success/failure

4. PAYMENT RECEIVED
   ├── Cancel future reminders
   ├── Send THANK_YOU reminder
   └── Update lastReminderAt

5. ESCALATION
   ├── If FINAL_NOTICE sent and no payment:
   │   ├── collectionStatus = COLLECTIONS
   │   ├── Notify collections team
   │   └── Create collection task
```

---

## 🔗 Cross-Module Integration

### With Estimate Module

```
Estimate (approved) → Invoice (auto-generated)

Data Mapping:
├── globalId (same)
├── invoiceNumber = estimateNumber
├── crmAccountId (same)
├── crmContactId (same)
├── billToAddressId (same)
├── subtotalAmount (same)
├── taxAmount (same)
├── discountAmount (same)
├── totalAmount (same)
└── Line items copied 1:1
```

### With Project Module

```
Project (in progress) → Invoice (progress billing)

Data Mapping:
├── globalId (same)
├── invoiceNumber = projectNumber
├── ProjectTask.percentComplete → InvoiceLineItem.progressPercentage
├── ProjectMilestone.reached → InvoiceMilestone.triggered
└── Actuals tracking for cost analysis
```

### With Payment Module

```
Invoice → Payment → InvoicePaymentApplication

Flow:
1. Payment created (amount, method, date)
2. InvoicePaymentApplication links payment to invoice
3. Invoice.amountPaid updated
4. Invoice.amountDue recalculated
5. Invoice.paymentStatus updated
6. If fully paid: Invoice.status = PAID
```

### With General Ledger

```
Invoice (sent) → GL Transaction (AR recognition)

Journal Entry (Accrual):
Debit:  Accounts Receivable  $10,000
Credit: Revenue                      $10,000

Invoice (paid) → GL Transaction (cash received)

Journal Entry (Cash):
Debit:  Cash/Bank            $10,000
Credit: Accounts Receivable          $10,000
```

### With Billing Module

```
BillingSchedule → Invoice (recurring billing)

Setup:
1. Create BillingSchedule (monthly, quarterly, annual)
2. Define BillingMilestone triggers
3. Set auto-generation rules

Execution:
1. BillingSchedule triggers invoice creation
2. Invoice inherits from schedule
3. Auto-send enabled
4. Next invoice scheduled
```

---

## 📊 AR Aging & Collections

### Aging Calculation

```typescript
// Pseudo-code for aging calculation
function calculateAgingBucket(invoice: Invoice): InvoiceCollectionStatus {
  const daysOverdue = daysSince(invoice.dueDate);
  
  if (invoice.paymentStatus === 'PAID') {
    return 'CURRENT';
  }
  
  if (daysOverdue <= 0) {
    return 'CURRENT';
  } else if (daysOverdue <= 30) {
    return 'OVERDUE_30';
  } else if (daysOverdue <= 60) {
    return 'OVERDUE_60';
  } else if (daysOverdue <= 90) {
    return 'OVERDUE_90';
  } else if (daysOverdue <= 120) {
    return 'OVERDUE_120';
  } else {
    return 'COLLECTIONS';
  }
}
```

### Aging Report Structure

```sql
-- AR Aging Summary by Customer
SELECT 
  crmAccountId,
  SUM(CASE WHEN collectionStatus = 'CURRENT' THEN amountDue ELSE 0 END) as current,
  SUM(CASE WHEN collectionStatus = 'OVERDUE_30' THEN amountDue ELSE 0 END) as overdue_30,
  SUM(CASE WHEN collectionStatus = 'OVERDUE_60' THEN amountDue ELSE 0 END) as overdue_60,
  SUM(CASE WHEN collectionStatus = 'OVERDUE_90' THEN amountDue ELSE 0 END) as overdue_90,
  SUM(CASE WHEN collectionStatus = 'OVERDUE_120' THEN amountDue ELSE 0 END) as overdue_120,
  SUM(amountDue) as total_outstanding
FROM invoices
WHERE tenantId = $1
  AND deletedAt IS NULL
  AND paymentStatus != 'PAID'
GROUP BY crmAccountId
ORDER BY total_outstanding DESC;
```

---

## 🎯 Key Performance Indicators (KPIs)

### Invoice Metrics

```
1. Days Sales Outstanding (DSO)
   = (Accounts Receivable / Total Credit Sales) × Days in Period
   Target: < 45 days

2. Collection Effectiveness Index (CEI)
   = (Beginning AR + Credit Sales - Ending AR) / (Beginning AR + Credit Sales - Ending Current AR) × 100
   Target: > 85%

3. Average Days to Payment
   = AVG(fullyPaidAt - sentToClientAt)
   Target: < 30 days

4. First-Time Payment Rate
   = (Invoices paid without reminders / Total invoices) × 100
   Target: > 70%

5. Overdue Invoice Rate
   = (Overdue invoices / Total outstanding invoices) × 100
   Target: < 15%

6. Bad Debt Rate
   = (Written-off amount / Total invoiced) × 100
   Target: < 2%

7. Electronic Payment Adoption
   = (Online payments / Total payments) × 100
   Target: > 80%
```

---

## 🚀 Competitive Advantages

### vs Procore
✅ **Retainage tracking** - Built-in retainage management  
✅ **Progress billing** - Native support for % complete billing  
✅ **1:1:1 traceability** - Estimate → Project → Invoice immutable  
✅ **No-login payments** - Public payment links (no portal required)  

### vs BuilderTrend
✅ **GL integration** - Native accounting integration  
✅ **Multi-dimensional status** - Triple status tracking (workflow + payment + collections)  
✅ **Automated reminders** - Smart payment reminder engine  
✅ **Milestone billing** - Event-triggered invoicing  

### vs ServiceTitan
✅ **Construction-specific** - Retainage, progress, milestones  
✅ **Enterprise compliance** - Immutable audit trails  
✅ **Actor relations** - Full accountability chain  
✅ **Advanced analytics** - Built-in KPI tracking  

---

## ✅ Implementation Checklist

### Phase 1: Core Invoice (Week 1-2)
- [ ] Invoice parent model
- [ ] InvoiceLineItem
- [ ] InvoiceTax
- [ ] InvoiceDiscount
- [ ] InvoiceFee
- [ ] Status enums
- [ ] Basic CRUD operations

### Phase 2: Payment Integration (Week 3)
- [ ] InvoicePaymentApplication
- [ ] Payment status updates
- [ ] GL integration
- [ ] Receivable ledger updates

### Phase 3: Construction Features (Week 4)
- [ ] InvoiceRetainage
- [ ] InvoiceProgress
- [ ] InvoiceMilestone
- [ ] Progress billing calculations

### Phase 4: Client Features (Week 5)
- [ ] InvoicePublicLink
- [ ] No-login payment pages
- [ ] Client view tracking
- [ ] Online payment integration

### Phase 5: Automation (Week 6)
- [ ] InvoiceReminder
- [ ] Automated reminder scheduling
- [ ] Email/SMS delivery
- [ ] Collections escalation

### Phase 6: Advanced Features (Week 7-8)
- [ ] InvoiceRevision (immutable snapshots)
- [ ] InvoiceAdjustment
- [ ] InvoiceCredit/Debit
- [ ] AR aging reports
- [ ] KPI dashboards

---

## 📋 Testing Requirements

### Unit Tests
- [ ] Invoice creation from estimate
- [ ] Line item calculations
- [ ] Tax calculations
- [ ] Discount applications
- [ ] Retainage calculations
- [ ] Progress billing math
- [ ] Payment application logic
- [ ] Aging bucket calculation

### Integration Tests
- [ ] Estimate → Invoice flow
- [ ] Project → Invoice flow
- [ ] Invoice → Payment flow
- [ ] Invoice → GL posting
- [ ] Email reminder delivery
- [ ] Public link generation
- [ ] Multi-currency support

### Performance Tests
- [ ] Bulk invoice generation (1000+ invoices)
- [ ] Payment application at scale
- [ ] AR aging report performance
- [ ] Index optimization validation

---

**Prepared by**: Claude (Anthropic)  
**Date**: 2025-11-16  
**Version**: 1.0  
**Status**: Production-Ready Documentation
