# 🚀 GitHub Copilot Instructions for Nov15Zeus ERP

**Version**: 2.1
**Last Updated**: November 17, 2025
**Project**: Multi-Tenant Construction ERP Platform

## 🤖 AI Agent Hierarchy

### Primary Agent: Claude 4

- **File**: `CLAUDE.md` (root level)
- **Role**: Architecture, complex refactoring, documentation
- **Authority**: HIGHEST - patterns are canonical

### Secondary Agent: GitHub Copilot (You)

- **File**: This file
- **Role**: Autocomplete, simple suggestions, PR reviews
- **Authority**: Follow Claude 4 patterns

**Rule**: NEVER contradict Claude-generated code or documentation.

---

## 📋 Project Overview

This is a **multi-tenant ERP system** built with **Prisma ORM** and **PostgreSQL**. Follow these instructions for consistent, production-ready code generation that aligns with our enterprise architecture.

## 📚 Detailed Instructions

See complete model inventory in [`Modules_Structure.md`](../structure/Modules_Structure.md)
See complete project flow [`PROJECT_FLOW.md`](../docs/modules/projects/PROJECT_FLOW.md)
See complete project diagram [`PROJECT_ARCHITECTURE_DIAGRAM.md`](../docs/modules/projects/PROJECT_ARCHITECTURE_DIAGRAM.md)

For full AI guidance see: **`CLAUDE.md`** (root level)
For financial Prisma models see: **`.github/instructions/prisma-financial-models.instructions.md`**

## 📊 ACTIVE MODULE DEVELOPMENT: PROJECTS

**Current Focus**: Implementing Project module suite (projectsCore, projectTaskScheduling, projectRisk)
**Architecture Reference**: `docs/modules/projects/PROJECT_ARCHITECTURE_DIAGRAM.md`
**Flow Reference**: `docs/modules/projects/PROJECT_FLOW.md`

### 🎯 Project Module Suite Requirements

- **Pattern**: BH (Base Hybrid) - Tenant + Global for 1:1:1 traceability
- **Models**: 30 models total across 3 schemas (10 + 10 + 10)
- **Integration**: Estimate, Invoice, Change Orders, HR, Inventory, Scheduling
- **Timeline**: Multi-phase implementation with bidirectional relations

### 🔍 Before Working on Project Module:

1. ✅ **Audit Architecture**: Review `PROJECT_ARCHITECTURE_DIAGRAM.md` for complete 30-model structure
2. ✅ **Understand Flow**: Study `PROJECT_FLOW.md` for work execution and delivery workflows
3. ✅ **Check 1:1:1 Traceability**: Ensure `globalId` consistency with Estimate and Invoice
4. ✅ **Verify Triple Status**: Implement project, budget, and schedule status dimensions
5. ✅ **Follow Actor Pattern B**: Project uses full Actor relations (critical operational entity)

## 📋 Project Overview

Multi-tenant ERP system for construction contractors and field services.

- **Tech Stack**: Node.js, TypeScript, Prisma ORM, PostgreSQL (Neon), tRPC
- **Scale**: 622 models across 54+ modules
- **Architecture**: Multi-tenant SaaS with hybrid tenancy patterns

## 🚨 CRITICAL: Before ANY Prisma Changes

1. ✅ Check `structure/Modules_Structure.md` for correct model names
2. ✅ CRM models are: `CRMAccount`, `CRMContact`, `CRMAddress` (NOT Account/Contact)
3. ✅ Apply Cross-Module Consistency Rules (see CLAUDE.md and financial instructions)
4. ✅ Use proper multi-tenant patterns (Global/Tenant/Hybrid BH)
5. ✅ Follow Actor Pattern A (IDs only) or B (full relations)

## 🏗️ Multi-Tenant Architecture Patterns

### Model Scopes

**Global** (no tenantId):

- Actor, User, Tenant, Permission, etc.
- Simple UUID primary key

**Tenant-Scoped** (has tenantId):

- All business entities
- Required: `@@unique([tenantId, id])`

**Hybrid BH** (tenantId + globalId):

- Estimate, Invoice, Project (cross-tenant traceability)
- Required: `@@unique([tenantId, globalId])` + `@@index([globalId])`

### Composite Keys for Tenant Relations

```prisma
// ✅ CORRECT
estimate Estimate @relation(fields: [tenantId, estimateId], references: [tenantId, id], onDelete: Cascade)
```

## ⚡ Cross-Module Consistency Rules

**CRITICAL**: When touching core models (Estimate, Invoice, Project), maintain alignment:

### 1. Governance Fields (Same Names, Module-Specific Enums)

```prisma
// ✅ IDENTICAL field names across modules
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

### 2. CRM Linkage Fields (EXACT field names, CORRECT model names)

```prisma
// ✅ CORRECT field names
crmAccountId    String  @db.Uuid  // Links to CRMAccount
crmContactId    String? @db.Uuid  // Links to CRMContact
billToAddressId String? @db.Uuid  // Links to CRMAddress

// ✅ CORRECT relations
crmAccount CRMAccount @relation(fields: [tenantId, crmAccountId], references: [tenantId, id], onDelete: Restrict)

// ❌ WRONG - These models don't exist
crmAccount Account @relation(...)
crmContact Contact @relation(...)
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

### 4. Event Timestamps (Business Events, Not Tech Events)

```prisma
// ✅ CANONICAL definitions - nullable, no @default(now())
issueDate      DateTime? @db.Timestamptz(6)  // Document issued to client
sentToClientAt DateTime? @db.Timestamptz(6)  // Client interaction event
clientViewedAt DateTime? @db.Timestamptz(6)  // Client engagement tracking
```

### 5. Cross-Module Relations (Stable Patterns)

```prisma
// ✅ CANONICAL pattern for Estimate ↔ Invoice linkage
// Estimate side:
invoices Invoice[] @relation("EstimateToInvoices")

// Invoice side:
sourceEstimate Estimate? @relation("EstimateToInvoices", fields: [tenantId, sourceEstimateId], references: [tenantId, id], onDelete: SetNull)
```

### 📊 Project Module Suite Specific Patterns

#### **30 Project Models Structure (3 Schemas)**:

```
🎯 projectsCore.prisma (10 models):
   • Project (Pattern BH - Parent with 1:1:1 linkage + Full Actor relations)
   • ProjectPhase, ProjectMilestone, ProjectTeamMember, ProjectLocation (Pattern A)
   • ProjectBudget, ProjectBudgetLineItem, ProjectDocument, ProjectAttachment, ProjectHistoryEvent (Pattern A)

📋 projectTaskScheduling.prisma (10 models):
   • ProjectTask (Pattern A - Core work items inherited from EstimateLineItem)
   • ProjectTaskAssignment, ProjectTaskDependency, ProjectSchedule, ProjectScheduleItem (Pattern A)
   • ProjectCriticalPath, ProjectBaseline, ProjectChecklistItem, ProjectTaskComment, ProjectTaskAttachment (Pattern A)

⚠️ projectRisk.prisma (10 models):
   • ProjectRisk, ProjectIssue, ProjectDecision, ProjectDailyLog (Pattern A)
   • ProjectDailyLogLabor, ProjectDailyLogEquipment, ProjectDailyLogMaterial, ProjectDailyLogPhoto (Pattern A)
   • ProjectProgress, ProjectNote (Pattern A)
```

#### **Triple Status Dimension**:

```prisma
// Primary project workflow status
status ProjectStatus @default(PLANNING)
// PLANNING → IN_PROGRESS → ON_HOLD → COMPLETED → CANCELED → CLOSED

// Budget management status
budgetStatus ProjectBudgetStatus @default(DRAFT)
// DRAFT → APPROVED → MONITORING → OVER_BUDGET → CLOSED

// Schedule tracking status
scheduleStatus ProjectScheduleStatus @default(ON_TRACK)
// ON_TRACK → AHEAD → DELAYED → CRITICAL → RECOVERED
```

#### **1:1:1 Traceability Requirements**:

```prisma
// CRITICAL: Same globalId across all three entities
// Estimate.globalId === Project.globalId === Invoice.globalId
// estimateNumber === projectNumber === invoiceNumber

model Project {
  globalId String @db.Uuid  // MUST match Estimate.globalId
  sourceEstimateId String? @db.Uuid  // Links back to approved estimate
  projectNumber String @db.VarChar(50)  // MUST match Estimate.estimateNumber
  // Bidirectional relations with Estimate and Invoice
}
```

#### **Project Execution Flow**:

```typescript
// Project creation from approved estimate
1. Estimate.status = APPROVED → Auto-create Project
2. EstimateSection → ProjectPhase (with WBS)
3. EstimateLineItem → ProjectTask (with scheduling)
4. EstimateAttachment → ProjectTaskAttachment (visual documentation)
5. Project.status = IN_PROGRESS → Begin execution tracking
```

#### **Business Event Timestamps (Nullable)**:

```prisma
// Project lifecycle events - NO @default(now())
plannedStartDate     DateTime? @db.Timestamptz(6)
plannedEndDate       DateTime? @db.Timestamptz(6)
actualStartDate      DateTime? @db.Timestamptz(6)
actualEndDate        DateTime? @db.Timestamptz(6)
baselineStartDate    DateTime? @db.Timestamptz(6)
baselineEndDate      DateTime? @db.Timestamptz(6)
forecastEndDate      DateTime? @db.Timestamptz(6)
```

### 🚨 NEVER DO:

- ❌ Create near-duplicate flags: `partialPaymentAllowed` + `allowPartialPayment`
- ❌ Mirror entire models between modules
- ❌ Change shared field names/types without cross-module validation
- ❌ Add @default(now()) to business event timestamps
- ❌ Use different composite key patterns for tenant relations

### ✅ ALWAYS DO:

- ✅ Search existing schema before adding new fields
- ✅ Reuse canonical names for cross-cutting concerns
- ✅ Keep module-specific logic contained within modules
- ✅ Validate field alignment when touching core models
- ✅ Use composite keys `[tenantId, foreignId] → [tenantId, id]` for relations

## 💰 Financial Standards

- Money: `@db.Decimal(12, 2)`
- Quantities: `@db.Decimal(10, 4)`
- Percentages: `@db.Decimal(8, 4)`
- Currency: `String @db.Char(3)` (ISO 4217)

## 🔗 Delete Semantics

- **Cascade**: Child can't exist without parent (ownership trees)
- **SetNull**: Optional historical references (survive parent deletion)
- **Restrict**: Financial/legal anchors (NEVER delete)

## 👤 Actor Attribution Patterns

### Pattern A: Lightweight Audit (Supporting Entities)

Use for comments, attachments, child financial entities:

```prisma
model EstimateComment {
  // Actor audit IDs only - no relations
  createdByActorId String? @db.Uuid
  updatedByActorId String? @db.Uuid
  deletedByActorId String? @db.Uuid
}
```

### Pattern B: Full Cross-Relations (Critical Financial Entities)

Use for Estimate, Invoice, Project, EstimateLineItem, InvoiceLineItem:

```prisma
model Estimate {
  // Actor audit with full relations
  createdByActorId String? @db.Uuid
  createdByActor Actor? @relation("EstimateCreatedByActor", fields: [createdByActorId], references: [id], onDelete: SetNull)
  // ... other actor relations
}
```

## ✅ Quick Validation Checklist

### General Prisma Changes:

- [ ] Model scope correct (Global/Tenant/Hybrid BH)?
- [ ] CRM models use correct names (CRM\* prefix)?
- [ ] Cross-module fields aligned (governance, CRM, financial)?
- [ ] Composite keys for tenant relations?
- [ ] Delete semantics appropriate?
- [ ] Actor pattern consistent (A or B)?

### Project Module Suite Specific:

- [ ] **1:1:1 Traceability**: globalId matches Estimate/Invoice?
- [ ] **Triple Status**: Project, budget, and schedule status dimensions implemented?
- [ ] **Actor Relations**: Project parent uses Pattern B (full relations)?
- [ ] **Child Models**: All supporting entities use Pattern A (IDs only)?
- [ ] **Business Events**: Timeline timestamps nullable, no @default(now())?
- [ ] **Work Breakdown**: EstimateSection → ProjectPhase inheritance correct?
- [ ] **Task Structure**: EstimateLineItem → ProjectTask inheritance with attachments?
- [ ] **Budget Tracking**: Cost variance and progress calculations implemented?
- [ ] **Schedule Management**: Critical path and baseline tracking present?
- [ ] **Integration**: Links to HR, Inventory, Change Orders, Customer Portal?

---

**For comprehensive rules, see `CLAUDE.md` and modular instructions in `.github/instructions/`**
