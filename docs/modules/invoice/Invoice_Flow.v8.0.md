# 📊 INVOICE Module - Complete Flow Documentation v8.0

**Version:** 8.0  
**Last Updated:** November 17, 2025  
**Aligned with:** Invoice_Architecture_Diagram_v8.0_CORRECTED.md  
**Module:** `invoice.prisma`

---

## 📋 Executive Summary

**Pattern**: BH (Base Hybrid) - Tenant + Global  
**Purpose**: Revenue recognition and accounts receivable management  
**Models**: 17 models (1 parent + 16 children)  
**Integration**: Estimate, Project, Payment, Billing, GL, Approvals, E-Signature  
**Timeline**: 14-week phased implementation

### Key Business Objectives

1. ✅ **Revenue Recognition**: Transform approved estimates into legally binding invoices
2. ✅ **AR Management**: Automated aging, collections, and payment tracking
3. ✅ **Progress Billing**: AIA G702/G703 compliant construction billing
4. ✅ **Retainage Management**: Industry-standard withholding and release workflows
5. ✅ **Client Communication**: No-login public payment links with mobile optimization
6. ✅ **Financial Integration**: Real-time GL posting and cash application

---

## 🏗️ Module Architecture Overview

### Model Inventory (17 Models)

#### 🎯 Parent Model (1) - Pattern BH
- **Invoice** - Core financial document with 70+ fields, triple status dimension, Actor relations enabled

#### 💰 Financial Components (4) - Pattern A
1. **InvoiceLineItem** - Billable items/services inherited from EstimateLineItem
2. **InvoiceTax** - Tax calculations, jurisdictions, exemptions
3. **InvoiceDiscount** - Early payment, volume, promotional discounts
4. **InvoiceFee** - Late fees, processing charges, administrative costs

#### 🏗️ Billing Specializations (3) - Pattern A
5. **InvoiceRetainage** - Construction retainage withholding and release
6. **InvoiceProgress** - Progress billing with AIA compliance
7. **InvoiceMilestone** - Milestone-based billing triggers

#### 💳 Payment & Collections (3) - Pattern A
8. **InvoicePaymentApplication** - Payment-to-invoice allocation tracking
9. **InvoiceReminder** - Automated multi-channel payment reminders
10. **InvoicePublicLink** - Secure no-login payment portal links

#### 📋 Supporting Entities (6) - Pattern A
11. **InvoiceRevision** - Immutable change snapshots
12. **InvoiceAdjustment** - Post-invoice corrections
13. **InvoiceCredit** - Credit memos and returns
14. **InvoiceDebit** - Debit memos and additional charges
15. **InvoiceAttachment** - Documents, PDFs, receipts, signatures
16. **InvoiceComment** - Internal collaboration notes
17. **InvoiceHistory** - Comprehensive audit trail events

---

## 🔄 1:1:1 Immutable Traceability

### The Golden Thread

```
ESTIMATE (globalId: 01HZQ...)
    ├── estimateNumber: EST-2025-001
    ├── Client approves
    └── Admin approves
         │
         ▼
    AUTO-GENERATE
         │
         ▼
PROJECT (globalId: 01HZQ...) ◄─── Same globalId
    ├── projectNumber: EST-2025-001 ◄─── Same number
    ├── Tasks from line items
    └── Tracks % completion
         │
         ▼
    BILLING TRIGGER
         │
         ▼
INVOICE (globalId: 01HZQ...) ◄─── Same globalId
    ├── invoiceNumber: EST-2025-001 ◄─── Same number
    ├── sourceEstimateId → Estimate
    ├── relatedProjectId → Project
    └── Payment collection
         │
         ▼
PAYMENT (references Invoice)
    ├── InvoicePaymentApplication
    ├── Cash applied to AR
    └── GL reconciliation
```

### Traceability Guarantees

- ✅ **Immutable Numbers**: `estimateNumber = projectNumber = invoiceNumber`
- ✅ **Shared Identity**: Same `globalId` across all three entities
- ✅ **Audit Trail**: Every change tracked with actor attribution
- ✅ **Regulatory Compliance**: SOX, GDPR, industry-specific requirements
- ✅ **Data Integrity**: Cannot delete Estimate/Project if Invoice exists

---

## 📊 Invoice Lifecycle Flow

### Phase 1: Invoice Creation

#### Trigger Option A: Auto-Generate from Approved Estimate
```
ESTIMATE.status = APPROVED (client + internal)
    │
    ├── System prompts: "Auto-create Invoice?"
    │
    └── If YES:
         │
         ├─► Create Invoice:
         │    ├── Copy globalId from Estimate
         │    ├── invoiceNumber = estimateNumber
         │    ├── sourceEstimateId = Estimate.id
         │    ├── crmAccountId, crmContactId (inherit)
         │    ├── billToAddressId (inherit)
         │    └── status = DRAFT
         │
         ├─► Create InvoiceLineItem (for each EstimateLineItem):
         │    ├── Copy description, quantity, unitPrice
         │    ├── Set sourceEstimateLineItemId
         │    └── Calculate lineTotal
         │
         ├─► Create InvoiceTax (for each EstimateTax):
         │    └── Copy tax rules and amounts
         │
         ├─► Create InvoiceDiscount (for each EstimateDiscount):
         │    └── Copy discount configuration
         │
         ├─► Create InvoiceFee (for each EstimateFee):
         │    └── Copy fee structure
         │
         ├─► Calculate Totals:
         │    ├── subtotalAmount = SUM(lineItems.lineTotal)
         │    ├── taxAmount = SUM(taxes.taxAmount)
         │    ├── discountAmount = SUM(discounts.discountAmount)
         │    ├── feeAmount = SUM(fees.feeAmount)
         │    ├── totalAmount = subtotal + tax - discount + fee
         │    └── amountDue = totalAmount - amountPaid
         │
         └─► Log History:
              └── InvoiceHistory: INVOICE_AUTO_CREATED
```

#### Trigger Option B: Manual Invoice Creation
```
User: "Create New Invoice"
    │
    ├─► Create Invoice:
    │    ├── Generate new globalId
    │    ├── Generate invoiceNumber via NumberSequence
    │    ├── SELECT crmAccountId (REQUIRED)
    │    ├── SELECT crmContactId (optional)
    │    ├── Set invoiceDate, dueDate
    │    └── status = DRAFT
    │
    ├─► User adds InvoiceLineItem manually:
    │    ├── Enter description, quantity, unitPrice
    │    ├── Optional: link to ProjectTask
    │    └── Calculate lineTotal
    │
    └─► Calculate totals (same as above)
```

#### Trigger Option C: Progress Billing from Project
```
PROJECT reaches billing milestone
    │
    ├── Calculate earned value:
    │    ├── Task A: 60% complete × $10,000 budget = $6,000
    │    ├── Task B: 100% complete × $5,000 budget = $5,000
    │    └── Total earned: $11,000
    │
    ├── Subtract previously billed:
    │    └── Current period billing: $11,000 - $7,500 = $3,500
    │
    ├── Apply retainage (10%):
    │    └── Net invoice: $3,500 - $350 = $3,150
    │
    ├─► Create Invoice:
    │    ├── billingType = PROGRESS
    │    ├── relatedProjectId = Project.id
    │    ├── progressPercentage = 65%
    │    ├── cumulativeBilledAmount = $11,000
    │    ├── previouslyBilledAmount = $7,500
    │    ├── currentPeriodAmount = $3,500
    │    └── Create InvoiceRetainage record
    │
    └─► Create InvoiceProgress record:
         └── Track AIA G702/G703 compliance data
```

---

### Phase 2: Internal Approval (if required)

```
Invoice: requiresApproval = true
    │
    ├─► Trigger Approval Workflow:
    │    ├── Create ApprovalRequest:
    │    │    ├── sourceType = "INVOICE"
    │    │    ├── sourceId = Invoice.id
    │    │    ├── amount = Invoice.totalAmount
    │    │    └── Generate approval chain
    │    │
    │    ├── Apply Approval Rules:
    │    │    ├── Amount threshold ($10K requires Finance)
    │    │    ├── Discount > 15% requires VP approval
    │    │    ├── Credit memo requires Controller
    │    │    └── Retainage release requires PM + Finance
    │    │
    │    └── Invoice.status = PENDING_APPROVAL
    │
    ├─► Approval Decision Loop:
    │    │
    │    ├── IF APPROVED:
    │    │    ├── ApprovalDecision.decision = APPROVED
    │    │    ├── Invoice.status = APPROVED
    │    │    └── InvoiceHistory: INTERNAL_APPROVED
    │    │
    │    └── IF REJECTED:
    │         ├── ApprovalDecision.decision = REJECTED
    │         ├── Invoice.status = DRAFT
    │         ├── InvoiceHistory: INTERNAL_REJECTED
    │         └── Notify creator with rejection reason
    │
    └─► Ready for client delivery
```

---

### Phase 3: Send to Client

```
Invoice.status = APPROVED
    │
    ├─► User action: "Send to Client"
    │
    ├─► Create InvoicePublicLink:
    │    ├── Generate secure token (cryptographically random)
    │    ├── Set expiresAt (optional, e.g., 90 days)
    │    ├── allowOnlinePayment = true
    │    ├── allowDownloadPDF = true
    │    └── publicUrl = "https://app.erp.com/invoice/{token}"
    │
    ├─► Generate Invoice PDF:
    │    ├── Company branding
    │    ├── Invoice header (number, dates, amounts)
    │    ├── Line items table
    │    ├── Taxes, discounts, fees breakdown
    │    ├── Payment terms
    │    └── Payment instructions
    │
    ├─► Create InvoiceAttachment:
    │    ├── attachmentType = INVOICE_PDF
    │    ├── fileName = "Invoice_EST-2025-001.pdf"
    │    └── Store in document management
    │
    ├─► Send Email Notification:
    │    ├── Create EmailMessage (emailengine.prisma)
    │    ├── TO: Invoice.crmContact.email
    │    ├── Subject: "Invoice #EST-2025-001 from [Company]"
    │    ├── Body: Template with public link
    │    ├── Attach PDF
    │    └── Track emailMessageId
    │
    ├─► Update Invoice:
    │    ├── status = SENT
    │    ├── sentToClientAt = NOW()
    │    └── InvoiceHistory: INVOICE_SENT
    │
    └─► Schedule Payment Reminders:
         │
         └─► Create InvoiceReminder records:
              ├── Reminder 1: 7 days before due (PAYMENT_DUE_SOON)
              ├── Reminder 2: Due date (PAYMENT_DUE)
              ├── Reminder 3: 3 days after due (OVERDUE)
              ├── Reminder 4: 15 days after due (SECOND_NOTICE)
              ├── Reminder 5: 30 days after due (FINAL_NOTICE)
              └── Reminder 6: 45 days after due (COLLECTIONS)
```

---

### Phase 4: Client Interaction (Public Link)

```
Client clicks public link
    │
    ├─► Load Invoice Public Page:
    │    ├── Validate token (not expired, valid format)
    │    ├── Load Invoice data
    │    ├── Track view:
    │    │    ├── InvoicePublicLink.viewCount++
    │    │    ├── InvoicePublicLink.lastViewedAt = NOW()
    │    │    ├── Capture IP address
    │    │    ├── Capture user agent (device/browser)
    │    │    └── Capture geolocation (optional)
    │    │
    │    └── Update Invoice:
    │         ├── status = VIEWED
    │         ├── clientViewedAt = NOW()
    │         └── InvoiceHistory: CLIENT_VIEWED
    │
    ├─► Client sees:
    │    ├── Invoice header (company, number, dates)
    │    ├── Bill to information
    │    ├── Line items with quantities and prices
    │    ├── Subtotal, taxes, discounts, fees
    │    ├── Total amount due
    │    ├── Payment terms
    │    └── Action buttons
    │
    └─► Client Actions:
         │
         ├─► Option 1: Download PDF
         │    ├── Generate/retrieve PDF
         │    └── Track download event
         │
         ├─► Option 2: Make Payment
         │    │
         │    ├── Redirect to payment gateway
         │    ├── Select payment method:
         │    │    ├── Credit card
         │    │    ├── ACH/Bank transfer
         │    │    ├── Wire transfer
         │    │    └── Check (offline)
         │    │
         │    ├── Enter payment details
         │    ├── Process payment
         │    └── Return to success page
         │
         └─► Option 3: Request Changes
              ├── Open comment form
              ├── Submit feedback
              └── Create InvoiceComment (clientVisible = true)
```

---

### Phase 5: Payment Processing

```
Payment Gateway: Transaction Successful
    │
    ├─► Create Payment record:
    │    ├── paymentMethod (CREDIT_CARD, ACH, etc.)
    │    ├── paymentAmount
    │    ├── paymentDate = NOW()
    │    ├── gatewayTransactionId
    │    ├── crmAccountId (from Invoice)
    │    └── status = COMPLETED
    │
    ├─► Create InvoicePaymentApplication:
    │    ├── invoiceId = Invoice.id
    │    ├── paymentId = Payment.id
    │    ├── appliedAmount (full or partial)
    │    ├── applicationDate = NOW()
    │    └── notes
    │
    ├─► Update Invoice:
    │    ├── amountPaid += appliedAmount
    │    ├── amountDue = totalAmount - amountPaid
    │    ├── paymentCount++
    │    ├── lastPaymentDate = NOW()
    │    ├── lastPaymentAmount = appliedAmount
    │    │
    │    ├── Update paymentStatus:
    │    │    ├── IF amountDue = 0: PAID
    │    │    ├── IF 0 < amountDue < totalAmount: PARTIAL
    │    │    └── IF amountPaid > totalAmount: OVERPAID
    │    │
    │    └── Update status:
    │         ├── IF paymentStatus = PAID:
    │         │    ├── status = PAID
    │         │    ├── fullyPaidAt = NOW()
    │         │    └── Cancel future reminders
    │         │
    │         └── IF paymentStatus = PARTIAL:
    │              └── status = PARTIALLY_PAID
    │
    ├─► Log History:
    │    └── InvoiceHistory: PAYMENT_RECEIVED
    │
    ├─► GL Posting (Cash Basis):
    │    ├── Create GLJournal
    │    ├── Debit: Cash Account = amountPaid
    │    ├── Credit: Accounts Receivable = amountPaid
    │    └── Post to ledger
    │
    └─► Send Notifications:
         ├── Email to client: "Payment received - Thank you"
         ├── Email to finance team: "Payment processed"
         └── Update dashboard KPIs
```

---

### Phase 6: Collections & Reminders

#### Automated Reminder Engine
```
CRON Job: Daily at 9:00 AM (tenant timezone)
    │
    ├─► Query InvoiceReminder:
    │    └── WHERE scheduledAt <= NOW() AND status = SCHEDULED
    │
    └─► For each reminder:
         │
         ├─► Load Invoice:
         │    └── Check current status (skip if PAID/VOIDED)
         │
         ├─► Determine Delivery Method:
         │    ├── EMAIL: Send via EmailEngine
         │    ├── SMS: Send via SMSEngine  
         │    └── BOTH: Send via both channels
         │
         ├─► EMAIL Delivery:
         │    ├── Get emailTemplateId (based on reminderType)
         │    ├── Personalize template:
         │    │    ├── {invoiceNumber}
         │    │    ├── {totalAmount}
         │    │    ├── {amountDue}
         │    │    ├── {dueDate}
         │    │    └── {publicLinkUrl}
         │    ├── Send via EmailEngine
         │    ├── Track emailMessageId
         │    └── sentVia = EMAIL
         │
         ├─► SMS Delivery:
         │    ├── Get smsTemplateId
         │    ├── Personalize template (limited chars)
         │    ├── Send via SMSEngine
         │    ├── Track smsMessageId
         │    └── sentVia = SMS
         │
         ├─► Update Reminder:
         │    ├── status = SENT
         │    ├── sentAt = NOW()
         │    ├── deliveredAt (if confirmed)
         │    └── responseReceived (if replied)
         │
         ├─► Update Invoice:
         │    ├── lastReminderAt = NOW()
         │    ├── nextReminderAt = (next scheduled reminder)
         │    └── InvoiceHistory: REMINDER_SENT
         │
         └─► Escalation Logic:
              │
              ├── IF reminderType = FINAL_NOTICE:
              │    ├── Create Notification for collections manager
              │    └── Flag for manual review
              │
              └── IF reminderType = COLLECTIONS:
                   ├── collectionStatus = COLLECTIONS
                   ├── Create task for collections team
                   └── Consider legal action workflow
```

#### AR Aging Automation
```
CRON Job: Daily at midnight (tenant timezone)
    │
    ├─► Query all open invoices:
    │    └── WHERE amountDue > 0 AND deletedAt IS NULL
    │
    └─► For each invoice:
         │
         ├─► Calculate days overdue:
         │    └── daysPastDue = DATEDIFF(NOW(), dueDate)
         │
         ├─► Update collectionStatus:
         │    ├── IF daysPastDue <= 0: CURRENT
         │    ├── IF 1 <= daysPastDue <= 30: OVERDUE_30
         │    ├── IF 31 <= daysPastDue <= 60: OVERDUE_60
         │    ├── IF 61 <= daysPastDue <= 90: OVERDUE_90
         │    ├── IF 91 <= daysPastDue <= 120: OVERDUE_120
         │    └── IF daysPastDue > 120: COLLECTIONS
         │
         ├─► Update primary status (if not already paid):
         │    └── IF daysPastDue > 0 AND status != OVERDUE:
         │         ├── status = OVERDUE
         │         └── InvoiceHistory: STATUS_CHANGED_OVERDUE
         │
         └─► Trigger escalation:
              ├── IF NEW overdue bucket reached:
              │    ├── Create Notification for AR team
              │    └── Log escalation event
              │
              └── IF collectionStatus = COLLECTIONS AND not sent to agency:
                   └── Create workflow for external collections
```

---

### Phase 7: Adjustments & Corrections

#### Invoice Adjustment (Post-Invoice Changes)
```
User: "Create Adjustment for Invoice #EST-2025-001"
    │
    ├─► Validation:
    │    ├── Invoice exists and not VOIDED
    │    ├── User has adjustment permission
    │    └── Reason code required
    │
    ├─► Create InvoiceAdjustment:
    │    ├── adjustmentType (LINE_ITEM_CORRECTION, TAX_CORRECTION, etc.)
    │    ├── adjustmentAmount (positive or negative)
    │    ├── reasonCode
    │    ├── description
    │    ├── approvalRequired = true (if amount > threshold)
    │    └── status = PENDING_APPROVAL
    │
    ├─► IF approvalRequired:
    │    ├── Create ApprovalRequest
    │    ├── Route to appropriate approvers
    │    └── Wait for approval
    │
    ├─► Upon approval:
    │    ├── Update Invoice totals:
    │    │    ├── totalAmount += adjustmentAmount
    │    │    ├── amountDue = totalAmount - amountPaid
    │    │    └── Recalculate paymentStatus
    │    │
    │    ├─► Create InvoiceRevision:
    │    │    ├── Capture snapshot BEFORE adjustment
    │    │    ├── revisionNumber++
    │    │    └── changeReason = adjustment description
    │    │
    │    ├── InvoiceHistory: ADJUSTMENT_APPLIED
    │    │
    │    └─► Notify client (if material):
    │         ├── Send updated invoice
    │         └── Explain adjustment
    │
    └─► GL Impact:
         ├── Create GLJournal for adjustment
         ├── Debit/Credit based on adjustment type
         └── Update AR balance
```

#### Credit Memo
```
User: "Create Credit Memo for Invoice #EST-2025-001"
    │
    ├─► Reason codes:
    │    ├── CUSTOMER_RETURN
    │    ├── PRICING_ERROR
    │    ├── BILLING_ERROR
    │    ├── GOODWILL_CREDIT
    │    └── OTHER
    │
    ├─► Create InvoiceCredit:
    │    ├── creditMemoNumber (generate new number)
    │    ├── creditAmount
    │    ├── creditReason
    │    ├── refundMethod (REFUND, CREDIT_BALANCE, OFFSET_FUTURE)
    │    └── status = PENDING_APPROVAL
    │
    ├─► Approval workflow:
    │    └── Route based on amount and reason
    │
    ├─► Upon approval:
    │    ├── Update Invoice:
    │    │    ├── amountPaid += creditAmount (if offset)
    │    │    ├── amountDue = totalAmount - amountPaid
    │    │    └── Recalculate paymentStatus
    │    │
    │    ├─► IF refundMethod = REFUND:
    │    │    ├── Create Payment (negative amount)
    │    │    └── Process refund to customer
    │    │
    │    ├─► IF refundMethod = CREDIT_BALANCE:
    │    │    └── Apply to customer's account balance
    │    │
    │    └─► IF refundMethod = OFFSET_FUTURE:
    │         └── Create unapplied credit for future invoices
    │
    └─► GL Posting:
         ├── Reverse revenue (if applicable)
         ├── Reduce AR
         └── Track refund liability
```

#### Debit Memo (Additional Charges)
```
User: "Create Debit Memo for Invoice #EST-2025-001"
    │
    ├─► Reason codes:
    │    ├── LATE_FEE
    │    ├── RESTOCKING_FEE
    │    ├── ADDITIONAL_WORK
    │    ├── CHANGE_ORDER_BILLING
    │    └── OTHER
    │
    ├─► Create InvoiceDebit:
    │    ├── debitMemoNumber
    │    ├── debitAmount
    │    ├── debitReason
    │    ├── billingDescription
    │    └── status = PENDING_APPROVAL
    │
    ├─► Approval workflow
    │
    ├─► Upon approval:
    │    ├── Update Invoice:
    │    │    ├── totalAmount += debitAmount
    │    │    ├── amountDue += debitAmount
    │    │    └── Create InvoiceFee (if late fee)
    │    │
    │    ├─► Create InvoiceRevision (snapshot)
    │    │
    │    └── InvoiceHistory: DEBIT_MEMO_APPLIED
    │
    └─► Notify client:
         └── Send updated invoice with debit explanation
```

---

### Phase 8: Voiding & Write-offs

#### Void Invoice
```
User: "Void Invoice #EST-2025-001"
    │
    ├─► Validation:
    │    ├── No payments received (amountPaid = 0)
    │    ├── User has void permission
    │    └── Void reason required
    │
    ├─► Update Invoice:
    │    ├── isVoided = true
    │    ├── status = VOIDED
    │    ├── voidedAt = NOW()
    │    ├── voidedByActorId = current user
    │    └── voidReason
    │
    ├─► Cancel reminders:
    │    └── UPDATE InvoiceReminder SET status = CANCELLED
    │
    ├─► InvoiceHistory: INVOICE_VOIDED
    │
    └─► GL Reversal:
         ├── IF already posted to GL:
         │    ├── Create reversing journal entry
         │    ├── Debit: Revenue
         │    └── Credit: AR
         │
         └── Mark invoice as "do not report" in financial statements
```

#### Write-off (Bad Debt)
```
User: "Write off Invoice #EST-2025-001"
    │
    ├─► Validation:
    │    ├── Invoice is OVERDUE with collectionStatus = COLLECTIONS
    │    ├── Collections efforts documented
    │    ├── User has write-off permission
    │    └── Approval required (always)
    │
    ├─► Create ApprovalRequest:
    │    ├── approvalType = BAD_DEBT_WRITEOFF
    │    ├── Require Controller + CFO approval
    │    └── Attach collections documentation
    │
    ├─► Upon approval:
    │    ├── Update Invoice:
    │    │    ├── isWrittenOff = true
    │    │    ├── status = WRITTEN_OFF
    │    │    ├── writtenOffAt = NOW()
    │    │    ├── writtenOffAmount = amountDue
    │    │    └── Keep amountDue visible for reporting
    │    │
    │    ├── InvoiceHistory: INVOICE_WRITTEN_OFF
    │    │
    │    └─► GL Posting:
    │         ├── Create GLJournal
    │         ├── Debit: Bad Debt Expense = writtenOffAmount
    │         ├── Credit: Allowance for Doubtful Accounts = writtenOffAmount
    │         └── Reduce AR (contra account method)
    │
    └─► Reporting:
         ├── Include in bad debt expense reports
         ├── Track write-off recovery (if paid later)
         └── Tax implications (consult accounting)
```

---

## 🏗️ Advanced Billing Workflows

### Progress Billing (AIA G702/G703 Compliance)

```
Monthly Billing Cycle for Construction Project
    │
    ├─► PROJECT STATUS:
    │    ├── Total contract value: $100,000
    │    ├── Retainage: 10%
    │    ├── Previously billed: $45,000
    │    └── Retainage withheld: $4,500
    │
    ├─► CURRENT PERIOD PROGRESS:
    │    │
    │    ├── Task A (Framing):
    │    │    ├── Budget: $20,000
    │    │    ├── Previous %: 50% ($10,000 billed)
    │    │    ├── Current %: 90% (40% gain)
    │    │    └── Current billing: $20,000 × 40% = $8,000
    │    │
    │    ├── Task B (Plumbing):
    │    │    ├── Budget: $15,000
    │    │    ├── Previous %: 0%
    │    │    ├── Current %: 60%
    │    │    └── Current billing: $15,000 × 60% = $9,000
    │    │
    │    └── Task C (Electrical):
    │         ├── Budget: $12,000
    │         ├── Previous %: 100% (complete)
    │         ├── Current %: 100%
    │         └── Current billing: $0 (already billed)
    │
    ├─► CALCULATE BILLING:
    │    ├── Current period work: $8,000 + $9,000 = $17,000
    │    ├── Apply retainage: $17,000 × 10% = $1,700
    │    └── Net invoice: $17,000 - $1,700 = $15,300
    │
    ├─► CREATE INVOICE:
    │    ├── billingType = PROGRESS
    │    ├── progressPercentage = 62% (overall project)
    │    ├── currentPeriodAmount = $17,000
    │    ├── previouslyBilledAmount = $45,000
    │    ├── cumulativeBilledAmount = $62,000
    │    ├── totalAmount = $15,300 (after retainage)
    │    │
    │    ├─► Create InvoiceProgress:
    │    │    ├── Link to AIA G702 data
    │    │    ├── Store schedule of values
    │    │    └── Track earned value
    │    │
    │    └─► Create InvoiceRetainage:
    │         ├── currentPeriodRetainage = $1,700
    │         ├── cumulativeRetainage = $6,200
    │         └── retainagePercentage = 10%
    │
    └─► SEND TO CLIENT:
         ├── Include AIA G702 (Application for Payment)
         ├── Include AIA G703 (Schedule of Values)
         ├── Attach progress photos
         └── Request payment
```

### Milestone Billing

```
PROJECT SETUP with 5 Milestones
    │
    ├── Milestone 1: Foundation Complete ($15,000)
    ├── Milestone 2: Framing Complete ($20,000)
    ├── Milestone 3: Rough-In Complete ($18,000)
    ├── Milestone 4: Final Inspection ($12,000)
    └── Milestone 5: Project Closeout ($10,000)
         │
         └── Total: $75,000

MILESTONE 1 REACHED
    │
    ├─► ProjectMilestone status = COMPLETED
    │    ├── completedAt = NOW()
    │    ├── verifiedByMemberId = Inspector
    │    └── Deliverables uploaded
    │
    ├─► TRIGGER Auto-Invoice Creation:
    │    │
    │    ├── Create Invoice:
    │    │    ├── billingType = MILESTONE
    │    │    ├── milestoneId = Milestone 1 ID
    │    │    ├── totalAmount = $15,000
    │    │    └── description = "Milestone 1 - Foundation Complete"
    │    │
    │    ├─► Create InvoiceMilestone:
    │    │    ├── milestoneName = "Foundation Complete"
    │    │    ├── targetDate = 2025-11-01
    │    │    ├── completionDate = 2025-10-28 (3 days early!)
    │    │    ├── completionCriteria = "All foundation poured and cured"
    │    │    ├── deliverableVerified = true
    │    │    └── paymentTrigger = "Upon inspection approval"
    │    │
    │    └─► Attach Deliverables:
    │         ├── Create InvoiceAttachment: Inspection report
    │         ├── Create InvoiceAttachment: Progress photos
    │         └── Create InvoiceAttachment: Material certifications
    │
    └─► SEND INVOICE:
         ├── Email to client with milestone documentation
         ├── Public payment link
         └── Payment terms: Net 30
```

### Retainage Release (Final Invoice)

```
PROJECT 100% COMPLETE
    │
    ├─► Verify completion:
    │    ├── All tasks 100% complete
    │    ├── Final inspection passed
    │    ├── Punch list cleared
    │    └── Client sign-off received
    │
    ├─► CALCULATE RETAINAGE RELEASE:
    │    ├── Total contract: $100,000
    │    ├── Previously billed: $90,000 (90%)
    │    ├── Cumulative retainage: $9,000 (10% of $90K)
    │    ├── Final work: $10,000 (10% remaining)
    │    ├── Final work retainage: $1,000
    │    └── TOTAL TO RELEASE: $9,000 + $1,000 = $10,000
    │
    ├─► CREATE FINAL INVOICE:
    │    ├── billingType = RETAINAGE_RELEASE
    │    ├── isFinal = true
    │    ├── description = "Final Invoice - Retainage Release"
    │    ├── totalAmount = $10,000
    │    │
    │    ├─► Create InvoiceRetainage:
    │    │    ├── releaseType = FINAL_RELEASE
    │    │    ├── releasedAmount = $10,000
    │    │    ├── cumulativeRetainage = $10,000
    │    │    ├── remainingRetainage = $0
    │    │    └── releaseConditions = "Project completion + sign-off"
    │    │
    │    └─► Attach Final Documents:
    │         ├── Final inspection report
    │         ├── Lien waivers (all subcontractors)
    │         ├── Warranty documents
    │         ├── As-built drawings
    │         └── O&M manuals
    │
    └─► SEND WITH E-SIGNATURE:
         ├── Create ESignatureEnvelope
         ├── Require client signature on lien waiver
         ├── Require contractor signature
         └── Release payment upon full execution
```

---

## 💳 Payment Integration Flows

### Online Payment (Credit Card)

```
Client clicks "Pay Now" on public link
    │
    ├─► Payment Portal Page:
    │    ├── Display invoice summary
    │    ├── Show amount due
    │    ├── Payment method options:
    │    │    ├── Credit Card (Visa, MC, Amex, Discover)
    │    │    ├── ACH / Bank Transfer
    │    │    └── Wire Transfer (instructions)
    │    │
    │    └── Allow partial payment (if enabled)
    │
    ├─► Client selects Credit Card:
    │    ├── Enter card details (tokenized input)
    │    ├── Enter billing address
    │    ├── Security verification (CVV, ZIP)
    │    └── Click "Process Payment"
    │
    ├─► PAYMENT GATEWAY INTEGRATION:
    │    │
    │    ├── Call PaymentGateway.createCharge():
    │    │    ├── amount = Invoice.amountDue
    │    │    ├── currency = Invoice.currencyCode
    │    │    ├── customerId = CRMAccount.id
    │    │    ├── paymentMethod = tokenized card
    │    │    └── metadata = {invoiceId, invoiceNumber}
    │    │
    │    ├─► Gateway Response:
    │    │    ├── SUCCESS:
    │    │    │    ├── transactionId
    │    │    │    ├── authorizationCode
    │    │    │    ├── settledAmount
    │    │    │    └── processingFee
    │    │    │
    │    │    └── FAILURE:
    │    │         ├── errorCode
    │    │         ├── errorMessage
    │    │         └── Return to payment form with error
    │
    ├─► CREATE PAYMENT RECORD (if success):
    │    ├── paymentMethod = CREDIT_CARD
    │    ├── paymentAmount = charge amount
    │    ├── paymentDate = NOW()
    │    ├── gatewayTransactionId
    │    ├── gatewayResponse (JSON)
    │    ├── processingFee
    │    └── status = COMPLETED
    │
    ├─► CREATE INVOICE PAYMENT APPLICATION:
    │    ├── Apply payment to invoice
    │    └── Update invoice totals
    │
    └─► SUCCESS PAGE:
         ├── Display confirmation message
         ├── Show receipt
         ├── Email receipt to client
         └── Offer PDF download
```

### ACH / Bank Transfer

```
Client selects ACH payment
    │
    ├─► ACH Setup Page:
    │    ├── Enter bank account details:
    │    │    ├── Account holder name
    │    │    ├── Routing number
    │    │    ├── Account number
    │    │    └── Account type (checking/savings)
    │    │
    │    └── Micro-deposit verification (optional):
    │         ├── Send 2 small deposits
    │         ├── Client verifies amounts
    │         └── Activate bank account
    │
    ├─► INITIATE ACH TRANSFER:
    │    │
    │    ├── Call PaymentGateway.createACHDebit():
    │    │    ├── amount
    │    │    ├── bankAccount (tokenized)
    │    │    └── metadata
    │    │
    │    └─► Gateway schedules transfer:
    │         ├── Processing time: 3-5 business days
    │         └── status = PENDING
    │
    ├─► CREATE PAYMENT RECORD:
    │    ├── paymentMethod = ACH
    │    ├── paymentAmount
    │    ├── paymentDate = NOW()
    │    ├── expectedSettlementDate = NOW() + 5 days
    │    └── status = PENDING
    │
    ├─► WEBHOOK LISTENER (Settlement):
    │    │
    │    ├── Gateway calls webhook: payment.succeeded
    │    ├── Update Payment: status = COMPLETED
    │    ├── Update Invoice totals
    │    └── Send confirmation email
    │
    └─► FAILURE HANDLING:
         ├── Gateway calls webhook: payment.failed
         ├── Update Payment: status = FAILED
         ├── Create InvoiceHistory: ACH_FAILED
         ├── Notify client and finance team
         └── Offer alternative payment method
```

---

## 📊 Triple Status Dimension

### Primary Workflow Status
```
DRAFT → PENDING_APPROVAL → APPROVED → SENT → VIEWED → PAID → CLOSED
                    │                              │
                    ▼                              ▼
                 REJECTED                      OVERDUE
                                                  │
                                                  ▼
                                             COLLECTIONS
```

### Payment Status (Independent)
```
UNPAID → PARTIAL → PAID
           │        │
           │        ▼
           │    OVERPAID
           │        │
           ▼        ▼
       REFUNDED ← CREDITED
```

### Collection Status (AR Aging)
```
CURRENT → OVERDUE_30 → OVERDUE_60 → OVERDUE_90 → OVERDUE_120 → COLLECTIONS
                                                                      │
                                                                      ▼
                                                                 WRITTEN_OFF
```

---

## 📊 Reporting & Analytics

### AR Aging Report

```sql
-- Conceptual query for AR aging buckets
SELECT 
  a.accountName,
  i.invoiceNumber,
  i.invoiceDate,
  i.dueDate,
  i.totalAmount,
  i.amountPaid,
  i.amountDue,
  DATEDIFF(CURRENT_DATE, i.dueDate) as daysPastDue,
  i.collectionStatus,
  
  -- Aging buckets
  CASE 
    WHEN DATEDIFF(CURRENT_DATE, i.dueDate) <= 0 THEN i.amountDue
    ELSE 0 
  END as current,
  
  CASE 
    WHEN DATEDIFF(CURRENT_DATE, i.dueDate) BETWEEN 1 AND 30 THEN i.amountDue
    ELSE 0 
  END as overdue_30,
  
  CASE 
    WHEN DATEDIFF(CURRENT_DATE, i.dueDate) BETWEEN 31 AND 60 THEN i.amountDue
    ELSE 0 
  END as overdue_60,
  
  CASE 
    WHEN DATEDIFF(CURRENT_DATE, i.dueDate) BETWEEN 61 AND 90 THEN i.amountDue
    ELSE 0 
  END as overdue_90,
  
  CASE 
    WHEN DATEDIFF(CURRENT_DATE, i.dueDate) > 90 THEN i.amountDue
    ELSE 0 
  END as overdue_90_plus

FROM Invoice i
JOIN CRMAccount a ON i.crmAccountId = a.id
WHERE 
  i.tenantId = :tenantId
  AND i.amountDue > 0
  AND i.deletedAt IS NULL
  AND i.isVoided = false
ORDER BY a.accountName, i.invoiceDate;
```

### Revenue Recognition Report

```sql
-- Revenue by billing type
SELECT 
  i.billingType,
  COUNT(*) as invoiceCount,
  SUM(i.totalAmount) as totalRevenue,
  SUM(i.amountPaid) as collectedRevenue,
  SUM(i.amountDue) as outstandingAR,
  AVG(DATEDIFF(i.fullyPaidAt, i.invoiceDate)) as avgDaysToPayment

FROM Invoice i
WHERE 
  i.tenantId = :tenantId
  AND i.invoiceDate BETWEEN :startDate AND :endDate
  AND i.deletedAt IS NULL
  AND i.isVoided = false
GROUP BY i.billingType
ORDER BY totalRevenue DESC;
```

### Payment Performance Metrics

```sql
-- KPIs for payment tracking
SELECT 
  -- Volume metrics
  COUNT(*) as totalInvoices,
  COUNT(CASE WHEN paymentStatus = 'PAID' THEN 1 END) as paidInvoices,
  COUNT(CASE WHEN paymentStatus = 'PARTIAL' THEN 1 END) as partiallyPaidInvoices,
  COUNT(CASE WHEN paymentStatus = 'UNPAID' THEN 1 END) as unpaidInvoices,
  
  -- Amount metrics
  SUM(totalAmount) as totalBilled,
  SUM(amountPaid) as totalCollected,
  SUM(amountDue) as totalOutstanding,
  
  -- Performance metrics
  (SUM(amountPaid) / SUM(totalAmount) * 100) as collectionRate,
  AVG(DATEDIFF(fullyPaidAt, invoiceDate)) as avgDaysToPayment,
  AVG(DATEDIFF(CURRENT_DATE, dueDate)) as avgDaysPastDue

FROM Invoice
WHERE 
  tenantId = :tenantId
  AND invoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
  AND deletedAt IS NULL
  AND isVoided = false;
```

---

## 🔧 Technical Implementation Notes

### Index Strategy Summary

**Primary Performance Indexes:**
- `[tenantId, id]` - Primary key constraint
- `[tenantId, globalId]` - 1:1:1 traceability lookups
- `[tenantId, invoiceNumber]` - Document number searches
- `[globalId]` - Cross-tenant integration queries
- `[tenantId, crmAccountId]` - Customer invoice lists (most common query)
- `[tenantId, status]` - Workflow filtering
- `[tenantId, paymentStatus]` - Payment tracking
- `[tenantId, collectionStatus]` - AR aging reports

**Temporal Indexes (BRIN):**
- `[invoiceDate]` - Revenue reports by period
- `[dueDate]` - Collections workflow
- `[createdAt]` - Audit queries

**Financial Indexes:**
- `[tenantId, totalAmount]` - Revenue analysis
- `[tenantId, amountDue]` - AR balance queries
- `[tenantId, nextReminderAt]` - Reminder scheduling

### Calculation Rules

**Invoice Totals:**
```typescript
subtotalAmount = SUM(lineItems.lineTotal)
taxAmount = SUM(taxes.taxAmount)
discountAmount = SUM(discounts.discountAmount)
feeAmount = SUM(fees.feeAmount)
retainageAmount = SUM(retainage.retainageAmount)

totalAmount = subtotalAmount 
            + taxAmount 
            - discountAmount 
            + feeAmount 
            - retainageAmount

amountDue = totalAmount - amountPaid
```

**Payment Status Logic:**
```typescript
if (amountPaid === 0) {
  paymentStatus = 'UNPAID'
} else if (amountPaid >= totalAmount) {
  paymentStatus = 'PAID'
  if (amountPaid > totalAmount) {
    // Create credit for overpayment
    paymentStatus = 'OVERPAID'
  }
} else {
  paymentStatus = 'PARTIAL'
}
```

**Collection Status Logic:**
```typescript
const daysPastDue = dateDiff(currentDate, dueDate)

if (daysPastDue <= 0) {
  collectionStatus = 'CURRENT'
} else if (daysPastDue <= 30) {
  collectionStatus = 'OVERDUE_30'
} else if (daysPastDue <= 60) {
  collectionStatus = 'OVERDUE_60'
} else if (daysPastDue <= 90) {
  collectionStatus = 'OVERDUE_90'
} else if (daysPastDue <= 120) {
  collectionStatus = 'OVERDUE_120'
} else {
  collectionStatus = 'COLLECTIONS'
}
```

---

## 🎯 Success Metrics & KPIs

### Financial Performance
- **Days Sales Outstanding (DSO)**: Target < 45 days
- **Collection Efficiency**: Target > 95%
- **Invoice Accuracy Rate**: Target > 99.5%
- **Bad Debt Ratio**: Target < 2%

### Operational Performance
- **Invoice Generation Time**: Target < 5 seconds
- **Payment Application Speed**: Target < 2 seconds
- **AR Report Generation**: Target < 30 seconds
- **Email Delivery Success Rate**: Target > 98%

### Customer Experience
- **Public Link Usage Rate**: Target > 80%
- **Mobile Payment Completion**: Target > 90%
- **Reminder Effectiveness**: Target > 25% payment rate
- **Customer Satisfaction Score**: Target > 4.5/5

---

## 📋 Implementation Checklist

### Phase 1: Core Entity (2 weeks)
- [ ] Invoice model with 70+ fields (Pattern BH)
- [ ] Actor attribution with full cross-relations
- [ ] Triple status dimension enums
- [ ] 35+ strategic indexes
- [ ] CRUD API endpoints
- [ ] Unit tests for calculations

### Phase 2: Financial Components (3 weeks)
- [ ] InvoiceLineItem with EstimateLineItem inheritance
- [ ] InvoiceTax calculation engine
- [ ] InvoiceDiscount with approval integration
- [ ] InvoiceFee management
- [ ] Financial totals aggregation
- [ ] Currency support

### Phase 3: Billing Specializations (4 weeks)
- [ ] InvoiceRetainage with construction compliance
- [ ] InvoiceProgress with AIA G702/G703
- [ ] InvoiceMilestone with project triggers
- [ ] Progress billing calculation engine
- [ ] Retainage release workflows
- [ ] Milestone automation

### Phase 4: Payment & Collections (3 weeks)
- [ ] InvoicePaymentApplication
- [ ] Payment gateway integration (Stripe/Square)
- [ ] InvoiceReminder multi-channel system
- [ ] InvoicePublicLink secure token generation
- [ ] AR aging automation
- [ ] Collections workflow

### Phase 5: Supporting Systems (2 weeks)
- [ ] InvoiceRevision change tracking
- [ ] InvoiceAdjustment with approvals
- [ ] InvoiceCredit/InvoiceDebit memos
- [ ] InvoiceAttachment document management
- [ ] InvoiceComment collaboration
- [ ] InvoiceHistory comprehensive audit

**Total Timeline: 14 weeks**

---

## 🔗 Cross-Module Dependencies

### Required Integrations
- ✅ **estimate.prisma** - Source data inheritance
- ✅ **projectsCore.prisma** - Progress tracking
- ✅ **crmcore.prisma** - Customer data (CRMAccount, CRMContact, CRMAddress)
- ✅ **approvals.prisma** - Approval workflows
- ✅ **paymentsARCashApplication.prisma** - Payment processing
- ✅ **billing.prisma** - AR ledger integration
- ✅ **generalledger.prisma** - GL posting
- ✅ **emailengine.prisma** - Email notifications
- ✅ **smscalls.prisma** - SMS reminders
- ✅ **esignature.prisma** - Document signing
- ✅ **customerportal.prisma** - Portal integration
- ✅ **notifications.prisma** - System notifications
- ✅ **identity.prisma** - Actor attribution
- ✅ **membership.prisma** - Ownership tracking
- ✅ **tenant.prisma** - Multi-tenant isolation

---

**Document Status**: Production-Ready  
**Next Steps**: Begin Phase 1 implementation  
**Owner**: Finance & Development Teams  
**Review Date**: 2025-12-01