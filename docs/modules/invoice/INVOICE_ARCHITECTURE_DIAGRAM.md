# 📊 Invoice Model - Arquitectura Visual

## 🏗️ Diagrama de Estructura Completa

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            INVOICE (Parent Model)                            │
│                           Pattern: BH (Base Hybrid)                          │
│                        Revenue Recognition Entry Point                       │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                │                     │                     │
                ▼                     ▼                     ▼
        ┌───────────────┐     ┌───────────────┐   ┌──────────────┐
        │   IDENTITY    │     │   LIFECYCLE   │   │ GOVERNANCE   │
        ├───────────────┤     ├───────────────┤   ├──────────────┤
        │ id (UUID v7)  │     │ status        │   │ auditCorr... │
        │ tenantId      │     │ paymentStatus │   │ dataClass... │
        │ globalId ⭐   │     │ collection... │   │ retention... │
        │               │     │ version       │   │ metadata     │
        │               │     │ createdAt     │   │ recordSrc    │
        │               │     │ updatedAt     │   │ timezone     │
        │               │     │ deletedAt     │   │              │
        └───────────────┘     └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         ACTOR ATTRIBUTION (Enabled)                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ createdByActorId → Actor  |  updatedByActorId → Actor  |  deletedByActorId  │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUSINESS DIMENSIONS                                │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► 📄 BUSINESS IDENTITY
        │   ├── invoiceNumber (EST-2025-00123 - inherited from Estimate)
        │   ├── invoiceDate
        │   ├── dueDate
        │   ├── title
        │   ├── referenceCode
        │   ├── description
        │   └── termsAndConditions
        │
        ├─► 👥 CRM LINKAGE (Corrected Model Names)
        │   ├── crmAccountId → Account (REQUIRED)
        │   ├── crmContactId → Contact (optional)
        │   └── billToAddressId → AccountAddress (optional)
        │
        ├─► 🔗 SOURCE LINKAGE (1:1:1 Traceability)
        │   ├── globalId (same as Estimate & Project)
        │   ├── sourceEstimateId → Estimate (via globalId)
        │   ├── sourceProjectId → Project (via globalId)
        │   └── contractId → Contract (optional)
        │
        ├─► 👤 OWNERSHIP
        │   ├── ownerMemberId → Member
        │   └── paymentTermsId → PaymentTerms
        │
        ├─► 📊 STATUS (Triple Dimension)
        │   ├── status (InvoiceStatus) - Primary workflow
        │   ├── paymentStatus (InvoicePaymentStatus) - Payment tracking
        │   └── collectionStatus (InvoiceCollectionStatus) - AR aging
        │
        ├─► 📅 EVENT TIMESTAMPS
        │   ├── issueDate
        │   ├── sentToClientAt
        │   ├── clientViewedAt
        │   ├── firstPaymentAt
        │   ├── fullyPaidAt
        │   ├── voidedAt
        │   ├── writtenOffAt
        │   ├── lastReminderAt
        │   └── nextReminderAt
        │
        ├─► 💰 FINANCIAL TOTALS (Denormalized)
        │   ├── currencyCode
        │   ├── subtotalAmount
        │   ├── discountAmount
        │   ├── taxAmount
        │   ├── feeAmount
        │   ├── retainageAmount ⭐ (construction-specific)
        │   ├── retainagePercentage ⭐
        │   ├── totalAmount
        │   ├── amountPaid
        │   ├── amountDue
        │   ├── lineItemCount
        │   └── totalQuantity
        │
        ├─► 📊 PAYMENT TRACKING
        │   ├── lastPaymentDate
        │   ├── lastPaymentAmount
        │   ├── paymentCount
        │   ├── partialPaymentAllowed
        │   └── earlyPaymentDiscount
        │
        ├─► 🏗️ BILLING TYPE & PROGRESS
        │   ├── billingType (STANDARD, PROGRESS, MILESTONE, RECURRING, etc.)
        │   ├── progressPercentage
        │   ├── cumulativeBilledAmount
        │   ├── previouslyBilledAmount
        │   ├── currentPeriodAmount
        │   └── milestoneId → ProjectMilestone
        │
        ├─► ⚙️ BEHAVIOR FLAGS
        │   ├── isRecurring
        │   ├── isProgress
        │   ├── isMilestone
        │   ├── isRetainage
        │   ├── isFinal
        │   ├── isVoided
        │   ├── isWrittenOff
        │   ├── autoSendReminders
        │   ├── allowPartialPayment
        │   └── requiresApproval
        │
        └─► 🔗 EXTERNAL MODULE REFS
            ├── approvalRequestId → ApprovalRequest
            ├── eSignatureEnvelopeId → ESignatureEnvelope
            └── numberSequenceAllocationId

┌─────────────────────────────────────────────────────────────────────────────┐
│                         CHILD RELATIONS (17 types)                           │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► InvoiceLineItem[] ⭐ (billable items/services)
        │   └── Links to source: EstimateLineItem, ProjectTask
        │
        ├─► InvoiceTax[] (tax calculations)
        ├─► InvoiceDiscount[] (discounts applied)
        ├─► InvoiceFee[] (fees/overhead/finance charges)
        │
        ├─► InvoiceRetainage[] ⭐ (construction retainage withholding)
        │   ├── retainagePercentage (5-10%)
        │   ├── cumulativeRetainage
        │   ├── releasedAmount
        │   └── remainingRetainage
        │
        ├─► InvoiceProgress[] (progress billing tracking)
        ├─► InvoiceMilestone[] (milestone-based billing)
        │
        ├─► InvoicePaymentApplication[] ⭐ (payment allocation)
        │   └── Links Payment → Invoice
        │
        ├─► InvoiceAttachment[] (PDFs, docs, supporting files)
        ├─► InvoiceComment[] (internal collaboration)
        │
        ├─► InvoiceRevision[] (immutable snapshots)
        ├─► InvoiceAdjustment[] (post-invoice corrections)
        ├─► InvoiceCredit[] (credit memos/returns)
        ├─► InvoiceDebit[] (debit memos/additional charges)
        │
        ├─► InvoiceHistory[] (audit trail events)
        │
        ├─► InvoicePublicLink[] ⭐ (no-login payment links)
        │   ├── Secure token
        │   ├── View tracking
        │   ├── Payment options
        │   └── Mobile-friendly
        │
        └─► InvoiceReminder[] ⭐ (automated payment reminders)
            ├── Scheduled delivery
            ├── Multi-channel (email/SMS)
            ├── Escalation rules
            └── Success tracking

┌─────────────────────────────────────────────────────────────────────────────┐
│                    CROSS-MODULE RELATIONS (via globalId)                     │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► FROM: Estimate (1:1:1 via globalId)
        │   └── Auto-generated on approval
        │       ├── Same globalId
        │       ├── Same invoiceNumber = estimateNumber
        │       ├── EstimateLineItem → InvoiceLineItem
        │       ├── EstimateTax → InvoiceTax
        │       ├── EstimateDiscount → InvoiceDiscount
        │       └── EstimateFee → InvoiceFee
        │
        ├─► FROM: Project (1:1:1 via globalId)
        │   └── Progress/Milestone billing
        │       ├── Same globalId
        │       ├── ProjectTask.percentComplete → InvoiceLineItem.progressPercentage
        │       └── ProjectMilestone.reached → InvoiceMilestone
        │
        ├─► TO: Payment (1:many)
        │   └── Payment application
        │       ├── Payment created
        │       ├── InvoicePaymentApplication links
        │       ├── amountPaid updated
        │       ├── amountDue recalculated
        │       └── paymentStatus updated
        │
        ├─► TO: GeneralLedger (accounting entries)
        │   └── GL posting
        │       ├── Debit: AR
        │       ├── Credit: Revenue
        │       └── Transaction tracking
        │
        └─► TO: ChangeOrder (modifications)
            └── Scope changes reflected
                ├── New line items added
                ├── Amounts adjusted
                └── Change order audit trail

┌─────────────────────────────────────────────────────────────────────────────┐
│                           1:1:1 TRACEABILITY FLOW                            │
└─────────────────────────────────────────────────────────────────────────────┘

    globalId: "01HZQ..."     globalId: "01HZQ..."     globalId: "01HZQ..."
         │                        │                        │
         ▼                        ▼                        ▼
    ┌─────────┐              ┌─────────┐              ┌─────────┐
    │ESTIMATE │─────────────►│ PROJECT │─────────────►│ INVOICE │
    └─────────┘              └─────────┘              └─────────┘
         │                        │                        │
    EST-2025-001            EST-2025-001            EST-2025-001
    (estimateNumber)        (projectNumber)         (invoiceNumber)
         │                        │                        │
         │                        │                        ▼
         │                        │                   ┌─────────┐
         │                        │                   │ PAYMENT │
         │                        │                   └─────────┘
         │                        │                        │
         │                        │                   Payment applied
         │                        │                   via InvoicePaymentApplication
         │                        │                        │
         └────────────────────────┴────────────────────────┘
                                  │
                           IMMUTABLE AUDIT TRAIL
                    All share same globalId forever

┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATUS FLOW DIAGRAM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    PRIMARY WORKFLOW (status):

    DRAFT
      │
      ▼
    PENDING_APPROVAL ──────► (rejected) ──► Back to DRAFT
      │
      ▼
    APPROVED
      │
      ▼
    SENT ──────────► sentToClientAt set
      │              InvoicePublicLink created
      ▼
    VIEWED ─────────► clientViewedAt set
      │
      ├──► Payment received (partial) ──► PARTIALLY_PAID
      │                                        │
      │                                        ▼
      └──► Payment received (full) ────► PAID ──► fullyPaidAt set
                                                   │
                                                   ▼
                                              (optional)
                                                CLOSED

    PARALLEL PATHS:

    If dueDate passed & amountDue > 0:
      └──► OVERDUE ──► collections workflow

    Manual actions:
      ├──► VOIDED ──► voidedAt set
      └──► WRITTEN_OFF ──► writtenOffAt set

┌─────────────────────────────────────────────────────────────────────────────┐
│                      PAYMENT STATUS FLOW (Dimension 2)                       │
└─────────────────────────────────────────────────────────────────────────────┘

    UNPAID
      │
      ├──► First payment < totalAmount ──► PARTIAL
      │                                       │
      │                                       ├──► Additional payments
      │                                       │    └──► Still < total ──► PARTIAL
      │                                       │
      │                                       └──► Total reached ──► PAID
      │
      └──► First payment = totalAmount ──► PAID
                                             │
                                             ├──► Payment > totalAmount ──► OVERPAID
                                             │                              (create credit)
                                             │
                                             └──► Payment refunded ──► REFUNDED

┌─────────────────────────────────────────────────────────────────────────────┐
│                   COLLECTION STATUS / AR AGING (Dimension 3)                 │
└─────────────────────────────────────────────────────────────────────────────┘

    Timeline from dueDate:

    Day 0: CURRENT
      │
    Day 1-30: OVERDUE_30
      │         ├── Reminder: "Payment overdue"
      │         └── Action: First collection call
      │
    Day 31-60: OVERDUE_60
      │         ├── Reminder: "Second notice"
      │         └── Action: Account review
      │
    Day 61-90: OVERDUE_90
      │         ├── Reminder: "Final notice"
      │         └── Action: Collections manager review
      │
    Day 91-120: OVERDUE_120
      │         ├── Reminder: "Pre-collections"
      │         └── Action: Legal review initiated
      │
    Day 121+: COLLECTIONS
      │         ├── Sent to collections agency
      │         └── Legal action considered
      │
    Terminal: WRITTEN_OFF
              └── Bad debt recognition

┌─────────────────────────────────────────────────────────────────────────────┐
│                         PAYMENT REMINDER WORKFLOW                            │
└─────────────────────────────────────────────────────────────────────────────┘

    INVOICE SENT (status = SENT)
      │
      ├── autoSendReminders = true
      │   │
      │   ▼
      │   Create InvoiceReminder schedule:
      │   ├── 7 days before due: PAYMENT_DUE
      │   ├── Due date: PAYMENT_DUE
      │   ├── 3 days after due: OVERDUE
      │   ├── 15 days after due: OVERDUE
      │   ├── 30 days after due: FINAL_NOTICE
      │   └── 45 days after due: Escalate
      │
      └── Reminder Execution Loop:
          │
          ├── Check scheduledAt
          │   │
          │   ▼
          │   If time reached & status = SCHEDULED:
          │   ├── deliveryMethod = EMAIL
          │   │   ├── Get emailTemplateId
          │   │   ├── Send via EmailEngine
          │   │   ├── Track emailMessageId
          │   │   └── sentAt = now
          │   │
          │   ├── deliveryMethod = SMS
          │   │   ├── Get smsTemplateId
          │   │   ├── Send via SMSEngine
          │   │   ├── Track smsMessageId
          │   │   └── sentAt = now
          │   │
          │   ├── deliveryMethod = BOTH
          │   │   └── Execute both channels
          │   │
          │   └── status = SENT
          │
          └── If payment received:
              ├── Cancel future reminders
              ├── Send THANK_YOU reminder (optional)
              └── lastReminderAt = now

┌─────────────────────────────────────────────────────────────────────────────┐
│                       PROGRESS BILLING WORKFLOW                              │
└─────────────────────────────────────────────────────────────────────────────┘

    PROJECT SETUP
      │
      ├── Define ProjectTask with budgets
      ├── Set billing schedule (monthly, milestones, etc.)
      └── Configure retainage (if applicable)
      │
      ▼
    PERIOD 1 (e.g., Month 1)
      │
      ├── Track ProjectTask.percentComplete
      │   ├── Task A: 30% complete
      │   ├── Task B: 50% complete
      │   └── Task C: 10% complete
      │
      ├── Calculate billable amount:
      │   ├── Task A: $10,000 * 30% = $3,000
      │   ├── Task B: $5,000 * 50% = $2,500
      │   ├── Task C: $8,000 * 10% = $800
      │   └── Subtotal: $6,300
      │
      ├── Apply retainage (10%):
      │   ├── Retainage: $6,300 * 10% = $630
      │   └── Net billing: $6,300 - $630 = $5,670
      │
      ├── Create Invoice:
      │   ├── billingType = PROGRESS
      │   ├── progressPercentage = 20% (overall project)
      │   ├── cumulativeBilledAmount = $5,670
      │   ├── previouslyBilledAmount = $0
      │   ├── currentPeriodAmount = $5,670
      │   └── Create InvoiceRetainage record
      │
      └── Send to client
      │
      ▼
    PERIOD 2 (e.g., Month 2)
      │
      ├── Track additional progress:
      │   ├── Task A: 60% (30% → 60%)
      │   ├── Task B: 100% (50% → 100%)
      │   └── Task C: 40% (10% → 40%)
      │
      ├── Calculate NEW billable:
      │   ├── Task A: $10,000 * (60%-30%) = $3,000
      │   ├── Task B: $5,000 * (100%-50%) = $2,500
      │   ├── Task C: $8,000 * (40%-10%) = $2,400
      │   └── Subtotal: $7,900
      │
      ├── Apply retainage:
      │   ├── Retainage: $7,900 * 10% = $790
      │   └── Net billing: $7,900 - $790 = $7,110
      │
      ├── Create Invoice:
      │   ├── progressPercentage = 45% (overall)
      │   ├── cumulativeBilledAmount = $12,780 ($5,670 + $7,110)
      │   ├── previouslyBilledAmount = $5,670
      │   ├── currentPeriodAmount = $7,110
      │   └── Update cumulative retainage
      │
      └── Continue until 100%
      │
      ▼
    FINAL INVOICE (100% complete)
      │
      ├── Bill remaining work (100% - previous %)
      ├── Create retainage release invoice:
      │   ├── billingType = RETAINAGE_RELEASE
      │   ├── Release all withheld retainage
      │   ├── retainageAmount = $1,420 (cumulative)
      │   └── isFinal = true
      │
      └── Close project billing

┌─────────────────────────────────────────────────────────────────────────────┐
│                       MILESTONE BILLING WORKFLOW                             │
└─────────────────────────────────────────────────────────────────────────────┘

    PROJECT SETUP
      │
      ├── Define ProjectMilestone:
      │   ├── Milestone 1: Foundation Complete ($15,000)
      │   ├── Milestone 2: Framing Complete ($20,000)
      │   ├── Milestone 3: Rough-In Complete ($18,000)
      │   ├── Milestone 4: Final Inspection ($12,000)
      │   └── Milestone 5: Project Closeout ($10,000)
      │
      └── Set trigger conditions
      │
      ▼
    MILESTONE 1 REACHED
      │
      ├── ProjectMilestone.status = COMPLETED
      ├── Trigger: Auto-create invoice
      │   ├── billingType = MILESTONE
      │   ├── milestoneId = linked
      │   ├── totalAmount = $15,000
      │   └── Create InvoiceMilestone record
      │
      ├── Attach deliverables:
      │   ├── Photos
      │   ├── Inspection reports
      │   └── Sign-offs
      │
      └── Send invoice
      │
      ▼
    MILESTONE 2 REACHED
      │
      └── Repeat process
      │
      ▼
    Continue for each milestone...
      │
      ▼
    FINAL MILESTONE (Closeout)
      │
      ├── Include any retainage release
      ├── isFinal = true
      └── Close project

┌─────────────────────────────────────────────────────────────────────────────┐
│                         DATA FLOW DIAGRAM                                    │
└─────────────────────────────────────────────────────────────────────────────┘

    1. CREATE INVOICE (Auto from Estimate)
       ├── Estimate.status = APPROVED
       ├── autoCreateInvoiceOnApproval = true
       ├── Copy globalId
       ├── Set invoiceNumber = estimateNumber
       ├── Copy crmAccountId, crmContactId
       ├── Copy line items, taxes, discounts, fees
       ├── status = DRAFT
       └── Link sourceEstimateId

    2. CREATE INVOICE (Manual)
       ├── Generate new globalId
       ├── Generate invoiceNumber via NumberSequence
       ├── Select crmAccountId (required)
       ├── Set invoiceDate, dueDate
       ├── status = DRAFT
       └── Begin adding line items

    3. ADD LINE ITEMS
       ├── InvoiceLineItem (description, quantity, unitPrice)
       ├── Calculate: lineAmount = quantity * unitPrice
       ├── Link to source (EstimateLineItem or ProjectTask)
       ├── Set sortOrder
       └── Update invoice.subtotalAmount

    4. APPLY TAXES
       ├── InvoiceTax (taxName, taxRate, taxableAmount)
       ├── Calculate: taxAmount = taxableAmount * taxRate
       ├── Can be line-level or header-level
       └── Update invoice.taxAmount

    5. APPLY DISCOUNTS
       ├── InvoiceDiscount (discountType, amount or %)
       ├── Calculate discount amount
       └── Update invoice.discountAmount

    6. APPLY FEES
       ├── InvoiceFee (feeType, amount)
       ├── Finance charges, late fees, etc.
       └── Update invoice.feeAmount

    7. CALCULATE RETAINAGE (if construction)
       ├── InvoiceRetainage (retainagePercentage)
       ├── Calculate: retainageAmount = subtotal * percentage
       ├── Track cumulativeRetainage
       └── Update invoice.retainageAmount

    8. FINALIZE TOTALS
       ├── totalAmount = subtotalAmount - discountAmount + taxAmount + feeAmount - retainageAmount
       ├── amountDue = totalAmount - amountPaid
       └── lineItemCount = COUNT(InvoiceLineItem)

    9. INTERNAL APPROVAL (if required)
       ├── requiresApproval = true
       ├── Create ApprovalRequest
       ├── status = PENDING_APPROVAL
       └── Wait for approval

    10. SEND TO CLIENT
        ├── status = APPROVED
        ├── Create InvoicePublicLink
        │   ├── Generate secure token
        │   ├── Set expiresAt (optional)
        │   └── allowOnlinePayment = true
        ├── Send email via EmailEngine
        ├── sentToClientAt = now
        ├── status = SENT
        └── Schedule payment reminders

    11. CLIENT INTERACTION
        ├── Client opens link
        │   ├── clientViewedAt = now
        │   ├── status = VIEWED
        │   ├── Track IP, device, user agent
        │   └── InvoicePublicLink.viewCount++
        │
        └── Client initiates payment
            ├── Redirect to payment gateway
            ├── Process payment
            └── Create Payment record

    12. PAYMENT RECEIVED
        ├── Create Payment
        ├── Create InvoicePaymentApplication
        │   ├── Link paymentId → invoiceId
        │   ├── Set appliedAmount
        │   └── Set applicationDate
        │
        ├── Update Invoice:
        │   ├── amountPaid += appliedAmount
        │   ├── amountDue = totalAmount - amountPaid
        │   ├── paymentCount++
        │   ├── lastPaymentDate = now
        │   └── lastPaymentAmount = appliedAmount
        │
        ├── Update paymentStatus:
        │   ├── If amountDue = 0: PAID
        │   ├── If 0 < amountDue < totalAmount: PARTIAL
        │   └── If amountPaid > totalAmount: OVERPAID
        │
        └── If fully paid:
            ├── fullyPaidAt = now
            ├── status = PAID
            ├── Cancel future reminders
            └── Send thank you email

    13. GL POSTING (Accrual when sent)
        ├── Create GLJournal
        ├── GLJournalLine: Debit AR = totalAmount
        ├── GLJournalLine: Credit Revenue = totalAmount
        └── Post to ledger

    14. GL POSTING (Cash when paid)
        ├── Create GLJournal
        ├── GLJournalLine: Debit Cash = amountPaid
        ├── GLJournalLine: Credit AR = amountPaid
        └── Update receivable ledger

┌─────────────────────────────────────────────────────────────────────────────┐
│                         INDEX STRATEGY (35+ indexes)                         │
└─────────────────────────────────────────────────────────────────────────────┘

    🔑 PRIMARY CONSTRAINTS (3)
       ├── [tenantId, id]
       ├── [tenantId, globalId]
       └── [tenantId, invoiceNumber]

    🌐 GLOBAL LINKAGE (1)
       └── [globalId] ← Cross-tenant 1:1:1 traceability

    📊 STATUS FILTERS (3)
       ├── [tenantId, status]
       ├── [tenantId, paymentStatus]
       └── [tenantId, collectionStatus]

    🔍 COMMON FILTERS (5)
       ├── [tenantId, crmAccountId] ⭐ (critical - customer lookup)
       ├── [tenantId, ownerMemberId]
       ├── [tenantId, sourceEstimateId]
       ├── [tenantId, sourceProjectId]
       └── [tenantId, deletedAt]

    ⏰ TEMPORAL (3 BRIN)
       ├── [invoiceDate] ← Common filter/sort
       ├── [dueDate] ← Collections workflow
       └── [createdAt] ← Audit queries

    💰 FINANCIAL QUERIES (4)
       ├── [tenantId, totalAmount] ← Revenue reports
       ├── [tenantId, amountDue] ← AR reports
       ├── [tenantId, amountPaid] ← Cash reports
       └── [tenantId, retainageAmount] ← Construction tracking

    📅 DATE-BASED FILTERS (4)
       ├── [tenantId, sentToClientAt]
       ├── [tenantId, fullyPaidAt]
       ├── [tenantId, nextReminderAt] ← Reminder scheduling
       └── [tenantId, lastReminderAt]

    📈 ANALYTICS & GOVERNANCE (2)
       ├── [tenantId, auditCorrelationId]
       └── [tenantId, dataClassification]

    👥 CRM LOOKUPS (2)
       ├── [tenantId, crmContactId]
       └── [tenantId, billToAddressId]

    🔗 EXTERNAL MODULES (4)
       ├── [tenantId, approvalRequestId]
       ├── [tenantId, eSignatureEnvelopeId]
       ├── [tenantId, contractId]
       └── [tenantId, milestoneId]

    🏗️ BILLING TYPE FILTERS (5)
       ├── [tenantId, billingType]
       ├── [tenantId, isProgress]
       ├── [tenantId, isMilestone]
       ├── [tenantId, isRetainage]
       └── [tenantId, isFinal]

    ⚙️ BEHAVIOR FLAGS (3)
       ├── [tenantId, isVoided]
       ├── [tenantId, isWrittenOff]
       └── [tenantId, autoSendReminders]

    🔧 GOVERNANCE & EXTENSIBILITY (2)
       ├── [tenantId, timezone]
       └── [metadata] GIN

┌─────────────────────────────────────────────────────────────────────────────┐
│                         AR AGING REPORT DIAGRAM                              │
└─────────────────────────────────────────────────────────────────────────────┘

    Customer: ABC Construction Inc.
    Report Date: 2025-11-16

    ┌────────────────┬──────────┬──────────┬──────────┬──────────┬───────────┐
    │ Invoice #      │ Current  │ 1-30 Days│ 31-60 Days│61-90 Days│ 90+ Days │
    ├────────────────┼──────────┼──────────┼──────────┼──────────┼───────────┤
    │ EST-2025-001   │ $5,000   │          │          │          │           │
    │ EST-2025-015   │          │ $3,500   │          │          │           │
    │ EST-2025-023   │          │          │ $2,800   │          │           │
    │ EST-2024-089   │          │          │          │ $1,200   │           │
    │ EST-2024-056   │          │          │          │          │ $4,500    │
    ├────────────────┼──────────┼──────────┼──────────┼──────────┼───────────┤
    │ TOTALS         │ $5,000   │ $3,500   │ $2,800   │ $1,200   │ $4,500    │
    │ % of Total     │   29.4%  │   20.6%  │   16.5%  │    7.1%  │   26.5%   │
    └────────────────┴──────────┴──────────┴──────────┴──────────┴───────────┘
    
    TOTAL OUTSTANDING: $17,000
    
    COLLECTION ACTIONS:
    ├── Current ($5,000): Monitor
    ├── 1-30 Days ($3,500): Send reminder
    ├── 31-60 Days ($2,800): Phone call
    ├── 61-90 Days ($1,200): Collections manager review
    └── 90+ Days ($4,500): ⚠️ ESCALATE TO COLLECTIONS

┌─────────────────────────────────────────────────────────────────────────────┐
│                         KEY INNOVATIONS                                      │
└─────────────────────────────────────────────────────────────────────────────┘

    ⭐ 1:1:1 IMMUTABLE TRACEABILITY
       └── Estimate.globalId === Project.globalId === Invoice.globalId
           ├── Same document number across lifecycle
           ├── Cannot be broken - audit trail forever
           └── Regulatory compliance (SOX, GDPR)

    ⭐ CONSTRUCTION RETAINAGE MANAGEMENT
       └── InvoiceRetainage tracking
           ├── Withholding % (5-10% typical)
           ├── Cumulative tracking across progress invoices
           ├── Release triggers and schedules
           └── Final retainage invoice

    ⭐ TRIPLE STATUS DIMENSION
       └── Independent tracking:
           ├── status (workflow: DRAFT → SENT → PAID)
           ├── paymentStatus (payment: UNPAID → PARTIAL → PAID)
           └── collectionStatus (aging: CURRENT → OVERDUE → COLLECTIONS)

    ⭐ NO-LOGIN PAYMENT LINKS
       └── InvoicePublicLink with:
           ├── Secure token (no customer portal required)
           ├── Mobile-friendly payment page
           ├── Multiple payment methods
           ├── View tracking & analytics
           └── IP/device fingerprinting

    ⭐ AUTOMATED PAYMENT REMINDERS
       └── InvoiceReminder system:
           ├── Multi-channel (email + SMS)
           ├── Smart scheduling (before/after due)
           ├── Escalation rules
           ├── Template-based messaging
           └── Delivery tracking

    ⭐ PROGRESS & MILESTONE BILLING
       └── Construction-specific billing:
           ├── Percentage-based progress billing
           ├── Milestone-triggered invoicing
           ├── Cumulative vs. current period tracking
           └── Integration with project % complete

    ⭐ AR AGING AUTOMATION
       └── Automatic aging bucket calculation:
           ├── Real-time collectionStatus updates
           ├── Aging reports by customer
           ├── Collections workflow triggers
           └── Bad debt write-off process

    ⭐ PAYMENT APPLICATION TRACKING
       └── InvoicePaymentApplication:
           ├── Links Payment → Invoice (1:many)
           ├── Partial payment support
           ├── Overpayment handling (create credit)
           ├── Unapplied cash tracking
           └── GL reconciliation

```

## 🎯 Conclusión Visual

Este diagrama muestra la **arquitectura completa** del módulo Invoice:

1. ✅ **70+ campos** organizados en 15 dimensiones lógicas
2. ✅ **35+ indexes** estratégicos para performance
3. ✅ **17 child models** para estructura completa
4. ✅ **Cross-module relations** con 1:1:1 traceability
5. ✅ **Triple status dimension** (workflow + payment + collections)
6. ✅ **Construction-specific features** (retainage, progress, milestones)
7. ✅ **Automated reminders** con smart scheduling
8. ✅ **AR aging automation** con collections workflow

### Comparison: Invoice vs Estimate

| Feature | Estimate | Invoice |
|---------|----------|---------|
| Purpose | Quote/Proposal | Bill for payment |
| Pattern | BH (Hybrid) | BH (Hybrid) ✅ |
| Actor Relations | Enabled ✅ | Enabled ✅ |
| Status Dimensions | 3 (workflow + approval + client) | 3 (workflow + payment + collections) |
| Child Models | 15 | 17 |
| Payment Integration | ❌ | ✅ Payment, GL |
| Retainage | Basic | Advanced tracking |
| Public Links | View/Approve | View/Pay |
| Reminders | ❌ | Automated system |
| AR Aging | ❌ | Automatic buckets |
| GL Posting | ❌ | Full integration |

**PRODUCTION-READY** para implementación inmediata.

---

**Preparado por**: Claude (Anthropic)  
**Fecha**: 2025-11-16  
**Versión**: 1.0
