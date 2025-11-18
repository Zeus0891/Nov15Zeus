# 💳 EXPENSE MODULE - Business Flow Documentation

**Version**: 1.0  
**Date**: November 17, 2025  
**Status**: ✅ Canonical Reference  
**Related Documents**: EXPENSE_ARCHITECTURE_DIAGRAM.md  
**Module Coverage**: expensecore.prisma (9 models) + expenses.prisma (9 models)

---

## 📋 Table of Contents

1. [Module Overview](#module-overview)
2. [Core Workflows](#core-workflows)
3. [Corporate Card Workflows](#corporate-card-workflows)
4. [Integration Workflows](#integration-workflows)
5. [Policy & Compliance](#policy--compliance)
6. [Advanced Features](#advanced-features)
7. [Best Practices](#best-practices)
8. [Implementation Guide](#implementation-guide)

---

## 🎯 Module Overview

### Purpose & Scope

The Expense module manages the complete employee expense and corporate card lifecycle from submission through reimbursement, with full integration to projects for job costing and accounting for financial reporting. It provides automated policy enforcement, receipt management, and comprehensive audit trails.

### Key Business Problems Solved

**1. Manual Expense Report Hell**
- **Problem**: Employees fill out paper forms or Excel spreadsheets, attach paper receipts, wait weeks for approval and reimbursement
- **Solution**: Mobile-first expense entry with photo receipt capture, automated policy validation, digital approval workflows, and direct deposit reimbursement

**2. Corporate Card Chaos**
- **Problem**: Card statements don't match expenses, receipts go missing, reconciliation takes days
- **Solution**: Real-time transaction import, auto-matching to expenses, receipt requirements enforced, monthly reconciliation automated

**3. Policy Violation Nightmare**
- **Problem**: No visibility into violations until audit time, managers overwhelmed with exception reviews
- **Solution**: Automated policy checks on submission, clear violation flagging, manager override workflows, complete audit trail

**4. Project Cost Invisibility**
- **Problem**: Project expenses hidden in general overhead, can't track true project profitability
- **Solution**: Expense line items allocated to projects/tasks, real-time cost updates, billable expense tracking, job costing integration

**5. Accounting Reconciliation**
- **Problem**: Manual GL entry, mismatched categories, missing documentation
- **Solution**: Automated GL posting from approved expenses, category-to-account mapping, complete documentation attached

### Module Statistics

**18 Total Models**:
- 2 BH (Base Hybrid) parent entities: ExpenseReport, CorpCard
- 16 Pattern A (Lightweight) child entities
- 100+ total indexes for optimal performance
- Complete Actor Attribution across all entities

---

## 🔄 Core Workflows

### Workflow 1: Manual Expense Report Creation

**Trigger**: Employee incurs business expenses (meals, travel, supplies, etc.)

**Actors**:
- Employee (submitter)
- Manager (approver)
- Finance Team (payment processor)

**Process Flow**:

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Create Expense Report                               │
└─────────────────────────────────────────────────────────────┘

Employee Action:
→ Clicks "New Expense Report"
→ Enters report details:
  - Report name: "Client Site Visit - Phoenix"
  - Expense period: Jan 15-17, 2025
  - Purpose: "Project kickoff meeting"

System Action:
→ ExpenseReport created:
  {
    reportNumber: "EXP-2025-00789" // Auto-generated via NumberSequence
    globalId: "01HZQEXPREPORT1234567890ABC" // UUIDv7
    employeeId: "[current employee]"
    submittedByMemberId: "[current member]"
    expenseStartDate: "2025-01-15"
    expenseEndDate: "2025-01-17"
    status: "DRAFT"
    approvalStatus: "NOT_SUBMITTED"
    paymentStatus: "UNPAID"
    totalExpenseAmount: 0
    createdByActorId: "[actor]"
  }

→ ExpenseHistoryEvent created:
  {
    eventType: "REPORT_CREATED"
    eventDescription: "Expense report created"
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Add Expense Line Items                              │
└─────────────────────────────────────────────────────────────┘

Employee Action:
→ Adds line item for hotel:
  - Category: "Lodging"
  - Date: Jan 15, 2025
  - Merchant: "Marriott Phoenix Downtown"
  - Amount: $189.00
  - Description: "Hotel for client meeting"
  - Upload receipt photo (via mobile app or web)

System Action:
→ ExpenseLine created:
  {
    tenantId: "[tenant]"
    id: "[uuid7]"
    expenseReportId: "[report]"
    lineNumber: 1 // Auto-incremented
    description: "Hotel - Marriott Phoenix"
    expenseCategoryId: "[lodging category]"
    categoryCode: "LODGING"
    categoryName: "Lodging"
    expenseDate: "2025-01-15"
    expenseLocation: "Phoenix, AZ"
    cityName: "Phoenix"
    stateName: "Arizona"
    countryCode: "USA"
    expenseAmount: 189.00
    reimbursableAmount: 189.00 // Full amount
    nonReimbursableAmount: 0.00
    paymentSource: "PERSONAL" // Paid with personal card
    hasReceipt: false // Will be uploaded
    receiptRequired: true // Based on policy
    isReimbursable: true
    isPolicyCompliant: true // Will be validated
    sortOrder: 1
  }

→ ExpenseReceipt created (from photo upload):
  {
    expenseReportId: "[report]"
    expenseLineId: "[line]"
    fileName: "marriott_receipt.jpg"
    fileUrl: "s3://erp-receipts/tenant-123/..."
    fileSize: 1234567
    mimeType: "image/jpeg"
    uploadedByMemberId: "[member]"
    uploadSource: "MOBILE_APP"
    hasOCR: false // Will be processed
    ocrStatus: "PENDING"
  }

→ Trigger OCR Processing (async):
  - AI OCR Service extracts:
    • Merchant name
    • Date
    • Total amount
    • Tax amount
    • Line items
    • Currency
  
→ Update ExpenseReceipt:
  {
    hasOCR: true
    ocrStatus: "COMPLETED"
    ocrMerchantName: "Marriott Phoenix Downtown"
    ocrDate: "2025-01-15"
    ocrTotalAmount: 189.00
    ocrConfidence: 0.98 // 98% confidence
    ocrRawText: "[full text extraction]"
    ocrExtractedData: {
      lineItems: [...]
      paymentMethod: "VISA ****1234"
    }
  }

→ Auto-match OCR to expense line:
  IF (ocrTotalAmount matches expenseAmount) {
    ExpenseReceipt.isMatched = true
    ExpenseLine.hasReceipt = true
    ExpenseLine.receiptMissing = false
  }

→ Update ExpenseReport totals:
  {
    totalExpenseAmount: 189.00
    totalReimbursable: 189.00
    lineItemCount: 1
    receiptCount: 1
    hasReceipts: true
  }

Employee continues adding more line items:
→ Meals (breakfast, lunch, dinner): $85.25
→ Ground transportation (Uber): $45.00
→ Parking: $30.00
→ Mileage (office to airport and back): $60.30

Special handling for mileage:
→ ExpenseLine (mileage):
  {
    description: "Mileage - Office to PHX Airport (round trip)"
    expenseCategoryId: "[mileage category]"
    isMileageExpense: true
    mileageDistance: 90.00 // 45 miles each way
    mileageRate: 0.67 // 2025 IRS standard mileage rate
    expenseAmount: 60.30 // 90 × 0.67
    originAddress: "123 Main St, Office City"
    destinationAddress: "Phoenix Sky Harbor Airport"
    paymentSource: "PERSONAL"
  }

Final Report Totals:
→ Update ExpenseReport:
  {
    totalExpenseAmount: 409.55
    totalReimbursable: 409.55 // All personal expenses
    totalNonReimbursable: 0.00
    lineItemCount: 5
    receiptCount: 5
    hasReceipts: true
    hasMissingReceipts: false
    hasPersonalExpenses: true
    hasCorpCardExpenses: false
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Project Allocation (Optional)                       │
└─────────────────────────────────────────────────────────────┘

IF (expenses are for a project):
  Employee Action:
  → Selects project for each line item
  → Marks if billable to client
  
  System Action:
  → Update ExpenseLine:
    {
      projectId: "[project uuid]"
      projectTaskId: "[task uuid]" // Optional
      costCodeId: "[cost code]" // e.g., "Travel & Entertainment"
      isBillableToClient: true // Will be invoiced to client
    }
  
  → Update ExpenseReport:
    {
      relatedProjectId: "[project uuid]"
      isBillableToClient: true
    }

┌─────────────────────────────────────────────────────────────┐
│ STEP 4: Policy Validation & Submission                      │
└─────────────────────────────────────────────────────────────┘

Employee Action:
→ Reviews report summary
→ Clicks "Submit for Approval"

System Action:
→ Run policy validation engine

PolicyEngine.validate(expenseReport):

  // Load active policies for date range
  policies = ExpensePolicy.findMany({
    where: {
      tenantId: expenseReport.tenantId,
      isActive: true,
      effectiveStartDate <= expenseReport.expenseStartDate,
      OR: [
        { effectiveEndDate: null },
        { effectiveEndDate >= expenseReport.expenseEndDate }
      ]
    }
  })

  FOR EACH expenseLine IN expenseReport.lines:
    
    // Find applicable policies for this line
    linePolices = policies.filter(p => 
      p.expenseCategoryId == line.expenseCategoryId ||
      p.appliesToAllCategories
    )
    
    FOR EACH policy IN linePolicies:
      
      // Violation 1: Amount exceeds limit
      IF (policy.maxAmountPerTransaction 
          && line.expenseAmount > policy.maxAmountPerTransaction) {
        
        ExpensePolicyViolation created:
        {
          expenseReportId: "[report]"
          expenseLineId: "[line]"
          expensePolicyId: "[policy]"
          violationType: "AMOUNT_EXCEEDED"
          violationSeverity: policy.violationSeverity // e.g., "MEDIUM"
          violationMessage: "Lodging expense of $189.00 exceeds policy limit of $150.00"
          policyLimit: 150.00
          actualAmount: 189.00
          variance: 39.00
          status: "OPEN"
        }
        
        UPDATE ExpenseLine:
        {
          hasPolicyViolation: true
          violationSeverity: "MEDIUM"
          isPolicyCompliant: false
        }
      }
      
      // Violation 2: Missing receipt
      IF (policy.requiresReceipt 
          && line.expenseAmount >= policy.receiptRequiredAbove
          && !line.hasReceipt) {
        
        ExpensePolicyViolation created:
        {
          violationType: "MISSING_RECEIPT"
          violationSeverity: "HIGH"
          violationMessage: "Receipt required for expenses over $75.00"
          status: "OPEN"
        }
      }
      
      // Violation 3: Duplicate expense check
      duplicates = ExpenseLine.findMany({
        where: {
          employeeId: line.employeeId,
          expenseDate: line.expenseDate,
          merchantName: line.merchantName,
          expenseAmount: line.expenseAmount,
          id: { not: line.id }
        }
      })
      
      IF (duplicates.length > 0) {
        ExpensePolicyViolation created:
        {
          violationType: "DUPLICATE_EXPENSE"
          violationSeverity: "CRITICAL"
          violationMessage: "Possible duplicate expense detected"
        }
      }

  // Calculate violation summary
  violations = expenseReport.policyViolations
  
  totalViolationAmount = SUM(violations.variance)
  maxSeverity = MAX(violations.violationSeverity)
  
  → Update ExpenseReport:
    {
      status: "SUBMITTED"
      approvalStatus: "PENDING_APPROVAL"
      submittedDate: NOW()
      hasPolicyViolations: violations.length > 0
      violationCount: violations.length
      violationSeverity: maxSeverity
      totalPolicyViolations: totalViolationAmount
    }

→ Create history event:
  ExpenseHistoryEvent:
  {
    eventType: "SUBMITTED"
    eventDescription: "Expense report submitted with 1 policy violation"
    eventData: {
      violationCount: 1,
      totalAmount: 409.55
    }
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 5: Approval Workflow                                   │
└─────────────────────────────────────────────────────────────┘

System Action:
→ Determine approval requirements

ApprovalRouter.determineApprovers(expenseReport):
  
  // Load approval policies
  approvalThreshold = ExpensePolicy.findFirst({
    where: { policyType: "APPROVAL_THRESHOLD" }
  })
  
  IF (expenseReport.totalExpenseAmount < 500 
      && !expenseReport.hasPolicyViolations) {
    // Auto-approve small, compliant reports
    return AUTO_APPROVE
  }
  
  IF (expenseReport.totalExpenseAmount < 2500) {
    // Manager approval only
    return [employee.managerId]
  }
  
  IF (expenseReport.totalExpenseAmount < 10000) {
    // Manager + Director
    return [employee.managerId, employee.directorId]
  }
  
  IF (expenseReport.totalExpenseAmount >= 10000) {
    // Executive approval + finance review
    return [employee.vicePresidentId, financeDirectorId]
  }

→ Create ApprovalRequest:
  {
    requestType: "EXPENSE_REPORT"
    sourceType: "ExpenseReport"
    sourceId: expenseReport.id
    requesterMemberId: expenseReport.submittedByMemberId
    requiredApprovers: [managerId]
    approvalLevels: 1
    status: "PENDING"
    dueDate: NOW() + 3 days
  }

→ Update ExpenseReport:
  {
    requiresApproval: true
    approvalRequestId: "[request]"
    approvalStatus: "PENDING_APPROVAL"
  }

→ Send notification to manager:
  Notification created:
  {
    recipientMemberId: "[manager]"
    notificationType: "EXPENSE_APPROVAL_NEEDED"
    priority: "MEDIUM"
    title: "Expense Report Needs Approval"
    message: "EXP-2025-00789 from John Smith ($409.55) - 1 policy violation"
    actionUrl: "/expenses/reports/[id]/approve"
  }

Manager Action:
→ Receives notification
→ Opens expense report
→ Reviews:
  - Report summary
  - All line items with receipts
  - Policy violations
  - Project allocation
  - Historical spending patterns

Manager sees policy violation:
→ ExpensePolicyViolation:
  {
    violationType: "AMOUNT_EXCEEDED"
    violationMessage: "Lodging expense of $189.00 exceeds policy limit of $150.00"
    violationSeverity: "MEDIUM"
    policyLimit: 150.00
    actualAmount: 189.00
    variance: 39.00
  }

Manager Decision Options:
1. APPROVE (with or without override)
2. REJECT (with reason)
3. REQUEST MORE INFO

Scenario A: Manager Approves with Override
→ Manager Action:
  - Reviews hotel receipt
  - Confirms this was emergency booking (conference hotel sold out)
  - Approves with policy override

→ System Action:
  UPDATE ExpensePolicyViolation:
  {
    status: "MANAGER_OVERRIDE"
    resolution: "MANAGER_OVERRIDE"
    resolutionNotes: "Approved - Emergency booking, conference hotel sold out, no alternatives available in reasonable distance"
    isManagerOverride: true
    overrideReason: "Emergency travel requirement"
    overrideByMemberId: "[manager]"
    overrideDate: NOW()
    resolvedByMemberId: "[manager]"
    resolvedDate: NOW()
  }
  
  UPDATE ApprovalRequest:
  {
    status: "APPROVED"
    approvedDate: NOW()
  }
  
  UPDATE ExpenseReport:
  {
    status: "APPROVED"
    approvalStatus: "APPROVED"
    approvedByMemberId: "[manager]"
    approvedDate: NOW()
    approvedAmount: 409.55 // Full amount approved
    amountDue: 409.55
    managerOverride: true
    managerOverrideReason: "Emergency travel requirement"
  }
  
  ExpenseHistoryEvent created:
  {
    eventType: "APPROVED"
    eventDescription: "Approved by manager with policy override"
    eventData: {
      approverName: "Manager Name",
      overrideApplied: true,
      approvedAmount: 409.55
    }
  }

→ Send notification to employee:
  {
    notificationType: "EXPENSE_APPROVED"
    message: "Your expense report EXP-2025-00789 has been approved. Reimbursement will be processed in the next pay cycle."
  }

Scenario B: Manager Rejects
→ Manager Action:
  - Finds duplicate expense from previous trip
  - Rejects report

→ System Action:
  UPDATE ApprovalRequest:
  {
    status: "REJECTED"
    rejectedDate: NOW()
    rejectionReason: "Duplicate expense - same hotel charge appears in EXP-2025-00734"
  }
  
  UPDATE ExpenseReport:
  {
    status: "REJECTED"
    approvalStatus: "REJECTED"
    rejectedByMemberId: "[manager]"
    rejectedDate: NOW()
    rejectionReason: "Duplicate expense found"
  }
  
  ExpenseHistoryEvent:
  {
    eventType: "REJECTED"
    eventDescription: "Rejected by manager - duplicate expense"
  }

→ Employee can revise and resubmit:
  UPDATE ExpenseReport: { status: "DRAFT" }
  Employee removes duplicate line
  Resubmits

┌─────────────────────────────────────────────────────────────┐
│ STEP 6: Payment Processing                                  │
└─────────────────────────────────────────────────────────────┘

Finance Team Action:
→ Reviews approved expense reports
→ Queues for payment batch

System Action:
→ ExpensePayment created:
  {
    expenseReportId: "[report]"
    paymentNumber: "PAY-2025-01234" // Auto-generated
    paymentAmount: 409.55
    currencyCode: "USD"
    paymentMethod: "DIRECT_DEPOSIT"
    bankAccountId: "[employee bank account]"
    status: "PENDING"
    scheduledDate: "2025-01-31" // Next pay cycle
  }

→ Update ExpenseReport:
  {
    paymentStatus: "PENDING_PAYMENT"
    paymentMethodId: "[payment method]"
    dueDate: "2025-01-31"
  }

On scheduled payment date:
→ Payment Processor (Stripe/ACH):
  - Initiate direct deposit
  - ACH transfer: $409.55 to employee bank account

→ Update ExpensePayment:
  {
    status: "PROCESSING"
    processedDate: NOW()
  }

When payment clears (typically 1-2 business days):
→ Webhook from payment processor

→ Update ExpensePayment:
  {
    status: "PAID"
    paidDate: "2025-02-01"
    clearedDate: "2025-02-01"
  }

→ Update ExpenseReport:
  {
    status: "PAID"
    paymentStatus: "PAID"
    paidAmount: 409.55
    amountDue: 0.00
    paidDate: "2025-02-01"
  }

→ ExpenseHistoryEvent:
  {
    eventType: "PAID"
    eventDescription: "Reimbursement paid via direct deposit"
    eventData: {
      paymentAmount: 409.55,
      paymentMethod: "DIRECT_DEPOSIT",
      paymentDate: "2025-02-01"
    }
  }

→ Send notification to employee:
  {
    notificationType: "EXPENSE_PAID"
    message: "Your reimbursement of $409.55 for EXP-2025-00789 has been deposited to your account."
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 7: Accounting Integration                              │
└─────────────────────────────────────────────────────────────┘

When expense report approved:
→ Create GL Journal Entry

GLJournal created:
{
  journalNumber: "JE-2025-05678"
  journalDate: "2025-01-20" // Approval date
  description: "Expense Report EXP-2025-00789 - John Smith"
  sourceType: "ExpenseReport"
  sourceId: "[expense report id]"
}

FOR EACH expenseLine IN approvedExpenseReport:
  
  // Get GL account from expense category
  glAccount = expenseLine.expenseCategory.glAccount
  
  GLJournalLine created:
  {
    glJournalId: "[journal]"
    glAccountId: glAccount.id
    glAccountCode: "6200" // Travel & Entertainment
    debitAmount: expenseLine.expenseAmount
    creditAmount: 0.00
    description: expenseLine.description
    departmentCode: expenseReport.department
    costCenter: expenseReport.costCenter
    sourceType: "ExpenseLine"
    sourceId: expenseLine.id
  }
  
  // If project expense, also post to WIP
  IF (expenseLine.projectId) {
    GLJournalLine created:
    {
      glAccountId: "[WIP account id]"
      glAccountCode: "1500" // Work in Progress
      debitAmount: expenseLine.expenseAmount
      creditAmount: 0.00
      projectId: expenseLine.projectId
      costCodeId: expenseLine.costCodeId
    }
  }

// Credit side: Employee Payable
GLJournalLine created:
{
  glAccountId: "[Employee Payable account]"
  glAccountCode: "2100"
  debitAmount: 0.00
  creditAmount: 409.55 // Total reimbursable
  description: "Employee reimbursement payable - EXP-2025-00789"
}

→ Post journal to GL:
  UPDATE GLJournal: { status: "POSTED", postedDate: NOW() }

When payment made:
→ Create cash disbursement entry

GLJournal created:
{
  journalNumber: "CD-2025-03456"
  journalDate: "2025-02-01" // Payment date
  description: "Employee reimbursement payment - EXP-2025-00789"
}

GLJournalLine created:
{
  // Debit: Employee Payable (clear the liability)
  glAccountCode: "2100"
  debitAmount: 409.55
  creditAmount: 0.00
}

GLJournalLine created:
{
  // Credit: Cash/Bank
  glAccountCode: "1010"
  debitAmount: 0.00
  creditAmount: 409.55
}

→ Post to GL

┌─────────────────────────────────────────────────────────────┐
│ STEP 8: Project Cost Integration                            │
└─────────────────────────────────────────────────────────────┘

When expense report approved:
→ Update project costs

FOR EACH expenseLine WHERE projectId IS NOT NULL:
  
  // Update ProjectTask actual cost
  UPDATE ProjectTask:
  {
    actualCost += expenseLine.expenseAmount
    lastCostUpdate: NOW()
  }
  
  // Create JobCostLine entry
  JobCostLine created:
  {
    tenantId: "[tenant]"
    projectId: expenseLine.projectId
    costCodeId: expenseLine.costCodeId
    costCategory: "EXPENSE"
    costType: "ACTUAL"
    description: expenseLine.description
    actualAmount: expenseLine.expenseAmount
    isBillable: expenseLine.isBillableToClient
    transactionDate: expenseLine.expenseDate
    sourceType: "ExpenseLine"
    sourceId: expenseLine.id
  }
  
  // Update Project totals
  UPDATE Project:
  {
    totalActualCost += expenseLine.expenseAmount
  }
  
  // Recalculate project variance
  costVariance = project.totalActualCost - project.totalBudgetedCost
  costVariancePercent = (costVariance / totalBudgetedCost) × 100
  
  UPDATE Project:
  {
    costVariance: costVariance
    costVariancePercent: costVariancePercent
  }
  
  // Update budget status
  IF (costVariancePercent > 10) {
    UPDATE Project: { budgetStatus: "OVER_BUDGET" }
    
    // Send alert to PM
    Notification:
    {
      recipientMemberId: project.projectManagerId
      notificationType: "PROJECT_BUDGET_ALERT"
      priority: "HIGH"
      message: "Project over budget by ${costVariance} ({costVariancePercent}%)"
    }
  }
  
  // If billable expense, create invoice line item
  IF (expenseLine.isBillableToClient) {
    // Mark for inclusion in next progress billing
    ProjectBillableExpense created:
    {
      projectId: expenseLine.projectId
      expenseLineId: expenseLine.id
      amount: expenseLine.expenseAmount
      isBilled: false
      markupPercentage: 15.0 // Company markup policy
      billingAmount: expenseLine.expenseAmount × 1.15
    }
  }
```

**Complete Flow Duration**: 5-10 business days from submission to payment
**Success Metrics**:
- 95%+ expense reports submitted within 7 days of incurrence
- Average approval time: <24 hours
- Payment cycle: 3-5 business days from approval
- Policy compliance rate: 92%+ after first 90 days

---

### Workflow 2: Corporate Card Expense Automation

**Trigger**: Employee makes purchase with corporate card

**Actors**:
- Card Processor (Brex, Ramp, Divvy, etc.)
- Employee (card holder)
- Automated system processes

**Process Flow**:

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Real-Time Transaction Feed                          │
└─────────────────────────────────────────────────────────────┘

Employee Action:
→ Swipes corporate card at merchant
→ Transaction: $45.67 at Shell Gas Station

Card Processor (e.g., Brex):
→ Processes transaction
→ Sends webhook to ERP platform:
  POST /webhooks/corp-card/transaction
  {
    externalTransactionId: "brex_txn_abc123",
    cardId: "brex_card_xyz789",
    cardNumberLast4: "4242",
    merchantName: "SHELL GAS STATION #1234",
    merchantCategory: "GAS_FUEL",
    merchantCategoryCode: "5541", // MCC code
    transactionDate: "2025-01-20T14:35:22Z",
    amount: 45.67,
    currency: "USD",
    status: "pending"
  }

System Action:
→ Lookup CorpCard by external card ID:
  corpCard = CorpCard.findFirst({
    where: {
      tenantId: "[tenant]",
      externalCardId: "brex_card_xyz789"
    }
  })

→ Check spending limits BEFORE creating transaction:
  currentDailySpend = corpCard.currentDailySpend
  newDailySpend = currentDailySpend + 45.67
  
  IF (corpCard.dailyLimit && newDailySpend > corpCard.dailyLimit) {
    // Limit exceeded - notify employee and manager
    Notification:
    {
      recipientMemberId: corpCard.assignedMemberId
      notificationType: "CARD_LIMIT_EXCEEDED"
      priority: "HIGH"
      message: "Daily spending limit exceeded: $${newDailySpend} of $${corpCard.dailyLimit}"
    }
    
    // Flag transaction for review
    requiresReview = true
  }

→ Create CorpCardTransaction:
  {
    corpCardId: corpCard.id
    externalTransactionId: "brex_txn_abc123"
    transactionNumber: "CCT-2025-12345" // Auto-generated
    transactionDate: "2025-01-20T14:35:22Z"
    postedDate: null // Not yet posted
    merchantName: "Shell Gas Station #1234"
    merchantCategory: "GAS_FUEL"
    merchantCategoryCode: "5541"
    merchantLocation: "Phoenix, AZ"
    transactionAmount: 45.67
    currencyCode: "USD"
    transactionType: "PURCHASE"
    isPending: true
    isCleared: false
    isMatched: false
    hasReceipt: false
    receiptRequired: false // Under $75 threshold
    isReconciled: false
  }

→ Update CorpCard spending trackers:
  UPDATE CorpCard:
  {
    currentDailySpend += 45.67
    currentWeeklySpend += 45.67
    currentMonthlySpend += 45.67
    totalLifetimeSpend += 45.67
    transactionCount += 1
    lastSyncedAt: NOW()
  }

→ Send notification to employee:
  {
    notificationType: "CARD_TRANSACTION"
    message: "Corporate card transaction: $45.67 at Shell Gas Station"
    actionUrl: "/expenses/card-transactions/[id]"
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Smart Auto-Matching                                 │
└─────────────────────────────────────────────────────────────┘

System Action (async job, runs every 15 minutes):
→ AutoMatchEngine.matchTransactions()

FOR EACH unmatchedTransaction IN CorpCardTransaction:
  WHERE isMatched = false AND isPending = false:
  
  // Find potential matching expense lines
  potentialMatches = ExpenseLine.findMany({
    where: {
      employeeId: transaction.corpCard.employeeId,
      expenseAmount: {
        gte: transaction.transactionAmount × 0.95, // ±5% tolerance
        lte: transaction.transactionAmount × 1.05
      },
      expenseDate: {
        gte: transaction.transactionDate - 3 days,
        lte: transaction.transactionDate + 3 days
      },
      corpCardTransactionId: null // Not already matched
    }
  })
  
  // Score matches
  FOR EACH match IN potentialMatches:
    score = 0
    
    // Amount match (0-50 points)
    amountDiff = ABS(match.expenseAmount - transaction.transactionAmount)
    amountScore = MAX(0, 50 - (amountDiff × 10))
    score += amountScore
    
    // Date match (0-30 points)
    daysDiff = ABS(match.expenseDate - transaction.transactionDate)
    dateScore = MAX(0, 30 - (daysDiff × 10))
    score += dateScore
    
    // Merchant name match (0-20 points)
    merchantSimilarity = fuzzyMatch(
      transaction.merchantName,
      match.merchantName
    )
    score += merchantSimilarity × 20
    
    match.matchScore = score
  
  // Sort by score
  potentialMatches.sortByDesc('matchScore')
  bestMatch = potentialMatches[0]
  
  IF (bestMatch && bestMatch.matchScore >= 70) {
    // Auto-match!
    UPDATE CorpCardTransaction:
    {
      isMatched: true
      expenseLineId: bestMatch.id
      expenseReportId: bestMatch.expenseReportId
      matchedDate: NOW()
    }
    
    UPDATE ExpenseLine:
    {
      corpCardId: transaction.corpCardId
      corpCardTransactionId: transaction.id
      paymentSource: "CORPORATE_CARD"
      isReimbursable: false // Corp card = not reimbursable
      reimbursableAmount: 0.00
      nonReimbursableAmount: expenseAmount
    }
    
    // Update report totals
    UPDATE ExpenseReport:
    {
      hasCorpCardExpenses: true
      totalReimbursable -= expenseAmount
      totalNonReimbursable += expenseAmount
      // totalExpenseAmount unchanged
    }
    
    // Notify employee of successful match
    Notification:
    {
      notificationType: "TRANSACTION_MATCHED"
      message: "Card transaction auto-matched to expense report EXP-2025-00789"
    }
  }
  ELSE IF (potentialMatches.length > 1 && bestMatch.matchScore >= 50) {
    // Multiple possible matches - needs manual selection
    Notification:
    {
      notificationType: "TRANSACTION_NEEDS_MATCH"
      priority: "MEDIUM"
      message: "Card transaction requires manual matching - multiple possibilities found"
      actionUrl: "/expenses/card-transactions/[id]/match"
    }
  }
  ELSE {
    // No match found - auto-create expense line
    AutoCreateExpenseLine(transaction)
  }

AutoCreateExpenseLine(transaction):
  
  // Determine expense category from MCC code
  category = ExpenseCategory.findFirst({
    where: {
      merchantCategoryCode: transaction.merchantCategoryCode
    }
  })
  
  IF (!category) {
    // Default to "General" category
    category = ExpenseCategory.findFirst({
      where: { categoryCode: "GENERAL" }
    })
  }
  
  // Find or create draft expense report for this employee
  draftReport = ExpenseReport.findFirst({
    where: {
      employeeId: transaction.corpCard.employeeId,
      status: "DRAFT",
      expenseStartDate <= transaction.transactionDate,
      expenseEndDate >= transaction.transactionDate
    }
  })
  
  IF (!draftReport) {
    // Create new draft report for this week
    weekStart = startOfWeek(transaction.transactionDate)
    weekEnd = endOfWeek(transaction.transactionDate)
    
    draftReport = ExpenseReport.create({
      reportNumber: "[auto-generated]"
      reportName: "Card Expenses - Week of ${weekStart}"
      employeeId: transaction.corpCard.employeeId
      submittedByMemberId: transaction.corpCard.assignedMemberId
      expenseStartDate: weekStart
      expenseEndDate: weekEnd
      status: "DRAFT"
    })
  }
  
  // Create expense line from transaction
  ExpenseLine.create({
    expenseReportId: draftReport.id
    lineNumber: draftReport.lineItemCount + 1
    description: transaction.merchantName
    expenseCategoryId: category.id
    categoryCode: category.categoryCode
    categoryName: category.categoryName
    expenseDate: transaction.transactionDate
    expenseLocation: transaction.merchantLocation
    merchantName: transaction.merchantName
    merchantCategory: transaction.merchantCategory
    expenseAmount: transaction.transactionAmount
    reimbursableAmount: 0.00 // Corp card
    nonReimbursableAmount: transaction.transactionAmount
    paymentSource: "CORPORATE_CARD"
    corpCardId: transaction.corpCardId
    corpCardTransactionId: transaction.id
    hasReceipt: false
    receiptRequired: transaction.transactionAmount > 75.00
    receiptMissing: transaction.transactionAmount > 75.00
    isReimbursable: false
  })
  
  // Update transaction
  UPDATE CorpCardTransaction:
  {
    isMatched: true
    expenseLineId: "[new line id]"
    expenseReportId: draftReport.id
    matchedDate: NOW()
  }
  
  // Update report
  UPDATE ExpenseReport:
  {
    totalExpenseAmount += transaction.transactionAmount
    totalNonReimbursable += transaction.transactionAmount
    lineItemCount += 1
    hasCorpCardExpenses: true
    hasMissingReceipts: transaction.transactionAmount > 75.00
  }
  
  // Notify employee
  Notification:
  {
    notificationType: "EXPENSE_LINE_CREATED"
    message: "Expense line created from card transaction: $${transaction.transactionAmount} at ${transaction.merchantName}"
    actionUrl: "/expenses/reports/${draftReport.id}"
  }
  
  // If receipt required, send reminder
  IF (transaction.transactionAmount > 75.00) {
    ScheduledNotification.create({
      recipientMemberId: transaction.corpCard.assignedMemberId
      notificationType: "RECEIPT_REMINDER"
      scheduledFor: NOW() + 3 days
      message: "Receipt required for $${transaction.transactionAmount} expense at ${transaction.merchantName}"
    })
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Receipt Upload & Matching                           │
└─────────────────────────────────────────────────────────────┘

Employee Action (via mobile app):
→ Receives notification about receipt requirement
→ Opens mobile app
→ Navigates to pending transactions
→ Sees: "Receipt required for $45.67 at Shell Gas Station"
→ Takes photo of receipt
→ Uploads

System Action:
→ CorpCardReceipt created:
  {
    corpCardId: "[card]"
    corpCardTransactionId: "[transaction]"
    fileName: "shell_receipt_20250120.jpg"
    fileUrl: "s3://..."
    fileSize: 987654
    mimeType: "image/jpeg"
    uploadedByMemberId: "[member]"
    uploadSource: "MOBILE_APP"
    hasOCR: false
    ocrStatus: "PENDING"
  }

→ Trigger OCR processing (async)

→ Update CorpCardTransaction:
  {
    hasReceipt: true
    receiptUploaded: true
  }

→ If transaction matched to expense line:
  ExpenseReceipt created:
  {
    expenseReportId: "[report]"
    expenseLineId: "[line]"
    fileName: "shell_receipt_20250120.jpg"
    fileUrl: "[same S3 url]"
    // Link to corp card receipt
    sourceCorpCardReceiptId: "[corp card receipt]"
  }
  
  UPDATE ExpenseLine:
  {
    hasReceipt: true
    receiptMissing: false
  }
  
  UPDATE ExpenseReport:
  {
    receiptCount += 1
    hasMissingReceipts: (check if any lines still missing receipts)
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 4: Monthly Reconciliation                              │
└─────────────────────────────────────────────────────────────┘

Trigger: End of billing cycle (typically monthly)

System Action:
→ Card processor sends statement

→ Create CorpCardReconciliation:
  {
    corpCardId: "[card]"
    reconciliationNumber: "REC-2025-01-4242" // Card last 4 + month
    statementPeriodStart: "2025-01-01"
    statementPeriodEnd: "2025-01-31"
    statementDate: "2025-02-01"
    statementBalance: 2,456.78
    status: "PENDING"
  }

→ Load all transactions for period:
  transactions = CorpCardTransaction.findMany({
    where: {
      corpCardId: "[card]"
      transactionDate: {
        gte: "2025-01-01"
        lte: "2025-01-31"
      }
    }
  })

→ Calculate totals:
  totalTransactionAmount = SUM(transactions.transactionAmount)
  totalMatched = COUNT(transactions WHERE isMatched = true)
  totalUnmatched = COUNT(transactions WHERE isMatched = false)
  totalMissingReceipts = COUNT(transactions WHERE receiptRequired = true AND hasReceipt = false)

→ Update CorpCardReconciliation:
  {
    transactionCount: transactions.length
    totalTransactionAmount: totalTransactionAmount
    matchedCount: totalMatched
    unmatchedCount: totalUnmatched
    missingReceiptCount: totalMissingReceipts
    
    // Variance analysis
    variance: ABS(statementBalance - totalTransactionAmount)
    isBalanced: variance < 0.01 // Allow 1 cent rounding
  }

→ Generate reconciliation report:
  IF (unmatchedCount > 0) {
    status = "NEEDS_REVIEW"
    
    // Send to finance team
    Notification:
    {
      recipientRole: "FINANCE_MANAGER"
      notificationType: "CARD_RECONCILIATION_REVIEW"
      priority: "HIGH"
      message: "${unmatchedCount} unmatched transactions need review for card ending in ${card.cardNumberLast4}"
      actionUrl: "/expenses/reconciliations/[id]"
    }
  }
  
  IF (missingReceiptCount > 0) {
    // Escalate to employee and manager
    Notification:
    {
      recipientMemberId: card.assignedMemberId
      notificationType: "RECEIPT_OVERDUE"
      priority: "HIGH"
      message: "${missingReceiptCount} receipts are overdue for card ending in ${card.cardNumberLast4}"
    }
    
    Notification:
    {
      recipientMemberId: card.employee.managerId
      notificationType: "RECEIPT_ESCALATION"
      message: "Employee ${employee.name} has ${missingReceiptCount} missing receipts"
    }
  }
  
  IF (isBalanced && unmatchedCount == 0 && missingReceiptCount == 0) {
    // Perfect reconciliation!
    UPDATE CorpCardReconciliation:
    {
      status: "COMPLETED"
      reconciledDate: NOW()
      reconciledByActorId: "[system actor]"
    }
    
    // Mark all transactions as reconciled
    UPDATE CorpCardTransaction:
    {
      isReconciled: true
      reconciledDate: NOW()
      reconciliationId: "[reconciliation id]"
    }
    WHERE corpCardId = "[card]"
      AND transactionDate BETWEEN period dates
  }

Finance Team Action (if review needed):
→ Opens reconciliation
→ Reviews unmatched transactions
→ Manually matches or creates expense lines
→ Follows up on missing receipts
→ Marks reconciliation complete

→ Update CorpCardReconciliation:
  {
    status: "COMPLETED"
    reconciledDate: NOW()
    reconciledByActorId: "[finance team member]"
    notes: "All transactions reconciled, 2 missing receipts waived"
  }
```

**Automation Benefits**:
- 85%+ transactions auto-matched
- Receipt upload rate: 95%+ within 3 days
- Reconciliation time: <2 hours vs. 2 days manual
- Employee time saved: 90%+ reduction

---

## 🔗 Integration Workflows

### Integration 1: Project Cost Allocation

**Purpose**: Allocate expenses to projects for accurate job costing and client billing

**Data Flow**:
```
ExpenseLine → ProjectTask → JobCostLine → Project
     ↓              ↓             ↓           ↓
 Approved      Actual Cost   Cost Tracking  Variance
```

**Implementation**:
```typescript
async function allocateExpenseToProject(
  expenseLineId: string,
  projectId: string,
  projectTaskId: string,
  costCodeId: string,
  isBillable: boolean
): Promise<void> {
  
  // Update expense line
  await prisma.expenseLine.update({
    where: { id: expenseLineId },
    data: {
      projectId,
      projectTaskId,
      costCodeId,
      isBillableToClient: isBillable
    }
  })
  
  // Wait for expense approval before updating project
  const expenseLine = await prisma.expenseLine.findUnique({
    where: { id: expenseLineId },
    include: {
      expenseReport: true
    }
  })
  
  if (expenseLine.expenseReport.status !== 'APPROVED') {
    // Not yet approved, exit
    return
  }
  
  // Update ProjectTask actual cost
  await prisma.projectTask.update({
    where: { id: projectTaskId },
    data: {
      actualCost: {
        increment: expenseLine.expenseAmount
      },
      lastCostUpdate: new Date()
    }
  })
  
  // Create JobCostLine entry
  await prisma.jobCostLine.create({
    data: {
      projectId,
      costCodeId,
      costCategory: 'EXPENSE',
      costType: 'ACTUAL',
      description: expenseLine.description,
      actualAmount: expenseLine.expenseAmount,
      isBillable,
      transactionDate: expenseLine.expenseDate,
      sourceType: 'ExpenseLine',
      sourceId: expenseLine.id,
      tenantId: expenseLine.tenantId,
      createdByActorId: expenseLine.updatedByActorId,
      updatedByActorId: expenseLine.updatedByActorId
    }
  })
  
  // Recalculate project totals
  const projectTotals = await prisma.jobCostLine.aggregate({
    where: { projectId },
    _sum: { actualAmount: true }
  })
  
  const project = await prisma.project.findUnique({
    where: { id: projectId },
    select: { totalBudgetedCost: true }
  })
  
  const totalActualCost = projectTotals._sum.actualAmount
  const costVariance = totalActualCost - project.totalBudgetedCost
  const costVariancePercent = (costVariance / project.totalBudgetedCost) × 100
  
  await prisma.project.update({
    where: { id: projectId },
    data: {
      totalActualCost,
      costVariance,
      costVariancePercent,
      budgetStatus: costVariancePercent > 10 ? 'OVER_BUDGET' :
                    costVariancePercent < -5 ? 'UNDER_BUDGET' :
                    'ON_BUDGET'
    }
  })
  
  // If billable, mark for inclusion in next invoice
  if (isBillable) {
    await prisma.projectBillableExpense.create({
      data: {
        projectId,
        expenseLineId,
        amount: expenseLine.expenseAmount,
        isBilled: false,
        markupPercentage: 15.0, // Company policy
        billingAmount: expenseLine.expenseAmount × 1.15,
        tenantId: expenseLine.tenantId,
        createdByActorId: expenseLine.updatedByActorId,
        updatedByActorId: expenseLine.updatedByActorId
      }
    })
  }
}
```

---

## 📊 Best Practices

### 1. Expense Report Best Practices

**Report Creation**:
- Submit expenses within 7 days of incurrence
- Group expenses by trip or project
- Use descriptive report names
- Add business purpose in description

**Receipt Management**:
- Upload receipts immediately after purchase
- Use mobile app for on-the-go capture
- Verify OCR accuracy
- Keep original receipts for 7 years (compliance)

**Policy Compliance**:
- Review company policies before incurring expenses
- Pre-approve large expenses with manager
- Document business purpose for all expenses
- Request policy exceptions before submitting

### 2. Corporate Card Best Practices

**Card Usage**:
- Use for business expenses only
- Stay within spending limits
- Upload receipts within 3 days
- Review statements monthly

**Security**:
- Report lost/stolen cards immediately
- Never share card numbers
- Use virtual cards for online purchases
- Enable transaction notifications

### 3. Manager Approval Best Practices

**Review Process**:
- Approve within 24 hours
- Review all receipts
- Verify business purpose
- Check policy compliance
- Document override reasons

**Exception Handling**:
- Use manager override judiciously
- Document all exceptions
- Communicate with employees
- Review patterns monthly

---

## 🎯 Implementation Guide

### Phase 1: Core Expense Reports (Weeks 1-2)

**Setup**:
1. Configure expense categories
2. Set up expense policies
3. Map categories to GL accounts
4. Configure approval workflows

**Testing**:
- Create test expense reports
- Upload receipt samples
- Test policy validation
- Verify approval workflows

### Phase 2: Corporate Cards (Weeks 3-4)

**Setup**:
1. Integrate with card processor
2. Import existing cards
3. Assign cards to employees
4. Configure spending limits

**Testing**:
- Test real-time transaction feed
- Verify auto-matching logic
- Test receipt requirements
- Perform test reconciliation

### Phase 3: Project Integration (Week 5)

**Setup**:
1. Map expense categories to cost codes
2. Configure billable markup rates
3. Set up project allocation workflows

**Testing**:
- Allocate expenses to projects
- Verify cost updates
- Test billable expense tracking

### Phase 4: Go-Live (Week 6+)

**Rollout**:
1. Train employees on mobile app
2. Train managers on approval process
3. Train finance on reconciliation
4. Monitor and optimize

---

**Document Version**: 1.0  
**Last Updated**: November 17, 2025  
**Status**: ✅ Canonical Reference  
**Next Review**: March 2026
