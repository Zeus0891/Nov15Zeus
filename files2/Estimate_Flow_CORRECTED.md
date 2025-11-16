# 🧮 Estimate Module — Functional & Integration Specification

**Version:** 1.0
**Last Updated:** November 15, 2025

**Related Modules & Schemas:** 

* `estimate.prisma` (Estimate domain)
* `crmcore.prisma` (accounts/contacts)
* `projectsCore.prisma`, `projectTaskScheduling.prisma` (projects & tasks)
* `invoice.prisma`, `billing.prisma`, `paymentsARCashApplication.prisma`
* `changeorder.prisma`
* `approvals.prisma`
* `esignature.prisma`
* `emailengine.prisma`, `notifications.prisma`, `customerportal.prisma`
* `accesscontrol.prisma`, `membership.prisma`, `tenant.prisma`, `identity.prisma`

---

## 1. Purpose & Goals

The **Estimate module** is the entry point for revenue origination. It allows internal users to:

* Create, revise, and compare estimates.
* Attach a tenant account/client.
* Collaborate internally via comments.
* Send a **public, no-login link** to customers for review.
* Orchestrate internal approvals.
* Capture customer approval (with or without e-signature).
* Automatically spawn **Projects** and **Invoices** once admin approves.
* Drive future **Change Orders** and keep 1:1 traceability Estimate → Project → Invoice.

The primary business objectives:

1. **Fast and accurate estimating.**
2. **Single source of truth** for agreed scope and pricing.
3. **Immutable financial trail** from estimate through execution and billing.
4. **Delightful customer experience** (no account required, mobile-friendly).

---

## 2. Domain Model (Estimate Module)

Models in `estimate.prisma`:

* `Estimate`
* `EstimateRevision`
* `EstimateSection`
* `EstimateLineItem`
* `EstimateTax`
* `EstimateDiscount`
* `EstimateFee`
* `EstimateTerm`
* `EstimateAssumption`
* `EstimateExclusion`
* `EstimateAlternate`
* `EstimateAttachment`
* `EstimateComment`
* `EstimateComparison`
* `EstimateHistoryEvent`
* `EstimatePublicLink` 

### 2.1 Core Relationships (Conceptual)

> This is conceptual; the actual Prisma schema will follow your base templates.

* **Estimate**

  * belongs to `Tenant`
  * references **client/account** in `Account` (and optionally `Contact`)
  * has many:

    * `EstimateRevision` (immutable snapshots)
    * `EstimateSection`
    * `EstimateLineItem`
    * `EstimateTax`, `EstimateDiscount`, `EstimateFee`
    * `EstimateTerm`, `EstimateAssumption`, `EstimateExclusion`, `EstimateAlternate`
    * `EstimateComment`
    * `EstimateHistoryEvent`
    * `EstimateComparison` (optional, for bid comparison)
    * `EstimatePublicLink`
  * links outward to:

    * `Project` (projectsCore)
    * `Invoice` (invoice)
    * `ChangeOrder` (changeorder)
    * `ApprovalRequest` (approvals)
    * `ESignatureEnvelope` (esignature)
    * `Notification` (notifications)
    * `EmailMessage` (emailengine)
    * `CustomerPortal*` (customerportal)

* **EstimateLineItem**

  * belongs to `Estimate` and optionally `EstimateSection`
  * has many `EstimateAttachment` (line-item scoped, up to 5 images)
  * later maps to:

    * `ProjectTask` (projectTaskScheduling)
    * `InvoiceLineItem` (invoice)

* **EstimateAttachment**

  * belongs to **EstimateLineItem** (not the header)
  * attachments are inherited downstream into:

    * `ProjectTaskAttachment`
    * `InvoiceAttachment` (optional, depending on config)

* **EstimateRevision**

  * belongs to `Estimate`
  * contains a frozen snapshot of all commercial terms (sections, line items, totals, taxes, etc.)
  * used for “what changed vs last revision” comparisons and audit.

* **EstimatePublicLink**

  * 1:1 with current active revision of an Estimate OR 1:N per revision (configurable; recommended: 1 active link per estimate).
  * backs public URL flow: view → approve → decline.
  * stores:

    * secure token
    * expiration date
    * view metadata
    * client actions (approved/declined timestamps, IP, device)

---

## 3. Status & Lifecycle

### 3.1 Estimate Statuses

Define an enum in `estimate.prisma` (conceptually):

* `DRAFT` – User working on it; not yet sent to customer.
* `PENDING_INTERNAL_APPROVAL` – Submitted to internal approvers.
* `PENDING_CLIENT_REVIEW` – Sent to client, waiting on client.
* `CLIENT_APPROVED` – Client approved via public link or signature.
* `CLIENT_DECLINED` – Client explicitly declined.
* `INTERNAL_REJECTED` – Internal approver rejected.
* `APPROVED` – Both sides satisfied; final internal approval granted.
* `CONVERTED` – Estimate has generated a Project and Invoice.
* `CANCELED` – No longer valid, superseded, or withdrawn.
* `DELETED` – Soft-delete flag set; visible only with special filters.

> UI translations:
>
> * **Draft** → `DRAFT`
> * **Saved** → `DRAFT` + `lastSavedAt`
> * **Pending approval** → `PENDING_INTERNAL_APPROVAL` or `PENDING_CLIENT_REVIEW`
> * **Approved** → `APPROVED` or `CONVERTED`
> * **Deleted** → `DELETED` with `deletedAt != null`

### 3.2 Key Lifecycle Events

Each major transition writes an `EstimateHistoryEvent`:

* `ESTIMATE_CREATED`
* `ESTIMATE_UPDATED`
* `REVISION_CREATED`
* `INTERNAL_APPROVAL_REQUESTED`
* `INTERNAL_APPROVED`
* `INTERNAL_REJECTED`
* `CLIENT_REVIEW_LINK_SENT`
* `CLIENT_VIEWED`
* `CLIENT_APPROVED`
* `CLIENT_DECLINED`
* `PROJECT_AUTO_CREATED`
* `INVOICE_AUTO_CREATED`
* `CHANGE_ORDER_CREATED`
* `STATUS_CHANGED`
* `ESTIMATE_DELETED`

---

## 4. Screen: Estimate List (Domain Entry)

When the user enters the **Estimate** domain:

### 4.1 Metrics & KPIs

Top summary cards (per-tenant, respecting permissions):

* **Total Estimates (last 30 days)**
* **Total Open Value** (sum of estimates not declined/canceled)
* **Won Value** (client approved & internally approved)
* **Conversion Rate** (Estimates → Projects)
* **Average Cycle Time** (created → client approval)

These metrics will aggregate over `Estimate` and `EstimateRevision` (for timestamps and totals).

### 4.2 Filters

Filter bar (multi-select chips + dropdowns):

* **Status:**

  * Draft
  * Pending internal approval
  * Pending client review
  * Approved
  * Declined
  * Deleted
* **Date Range:**

  * CreatedAt, LastUpdatedAt, or SentToClientAt
* **Account/Client** (from Account / Contact)
* **Owner/Estimator** (Member)
* **Project (if already converted)**

Behind the scenes, filters map to `Estimate.status`, `Estimate.deletedAt`, `Estimate.clientAccountId`, etc.

---

## 5. Estimate Form UX & Behavior

### 5.1 Header Fields

* **Non-editable Estimate Number**

  * Generated on first save, using tenant-specific sequence (e.g. `EST-2025-00123`).
  * Stored in `Estimate.estimateNumber` and reused consistently for traceability.

* **Client / Account Selection**

  * Button: **“Add account / client”**
  * Behavior:

    1. Opens a modal with:

       * list of `Account` (with search, filters).
       * list of primary `Contact` per account.
    2. Option **“Create new client”**:

       * creates `Account` (and optionally `Contact`) via `crmcore.prisma`.
    3. Once selected:

       * `Estimate.crmAccountId` is set.
       * `Estimate.crmContactId` optionally set.
       * Client details are displayed on the estimate header (name, address, email, phone).

* **High-level Fields**

  * `title` or `estimateName`
  * `validUntil` (expiration)
  * `currency`
  * `status` (controlled by flow, not free-form)
  * `ownerMemberId` (who owns this estimate)
  * optional `linkedProjectId` if created from an existing project.

### 5.2 Line Items & Sections

* **EstimateSection**

  * Logical groupings (e.g., “Plumbing”, “Electrical”).
  * Optional; line items can exist without a section.

* **EstimateLineItem**

  * Fields (minimum):

    * `itemName` (used later as `ProjectTask.name`)
    * `itemDescription` (used later as `ProjectTask.description`)
    * `quantity`
    * `unitPrice`
    * `lineTotal` (quantity × unitPrice, or derived)
    * `sortOrder`
    * optional: `costCodeId` (JobCosting integration), `unitOfMeasure`, `category`.
  * **Attachments**:

    * Inline component per row: **“Add images (max 5)”**
    * Up to 5 `EstimateAttachment` records per line item (photos, drawings, etc.)
    * These are **inherited into auto-generated ProjectTasks** as `ProjectTaskAttachment`.

* **Totals & Charges**

  * `EstimateTax` – Lines for tax rules applied.
  * `EstimateDiscount` – Per-estimate or per-section discounts.
  * `EstimateFee` – Overhead, contingency, other fees.
  * Calculated totals:

    * Subtotal
    * Taxes
    * Discounts
    * Fees
    * Grand Total

### 5.3 Commercial Conditions

* **EstimateTerm** – Payment & legal terms.
* **EstimateAssumption** – Business assumptions (e.g., “Assumes indoor work only”).
* **EstimateExclusion** – Explicit exclusions (e.g., “Excludes permit fees”).
* **EstimateAlternate** – Optional alternates or options (e.g., “Upgrade to premium materials”).

### 5.4 Comments & History

* **EstimateComment**

  * Internal-only comments (per-tenant, visible to staff).
* **EstimateHistoryEvent**

  * System-generated events; optionally shown in a “Timeline” tab.

---

## 6. Approvals & E-Signature Flow

### 6.1 Internal Approval (Approvals Module)

**Module:** `approvals.prisma` 

* On **“Send for internal approval”**:

  * Create `ApprovalRequest` linked to `Estimate`:

    * `ApprovalRequest.sourceType = "ESTIMATE"`
    * `ApprovalRequest.sourceId = Estimate.id`
    * `ApprovalRequest.amount = Estimate.totalAmount`
  * Generate `ApprovalRule` / `ApprovalLevel` based on:

    * Amount thresholds
    * Role (e.g., PM, Finance)
    * Cost center or project type
  * Status moves: `DRAFT` → `PENDING_INTERNAL_APPROVAL`.

* When the last required `ApprovalDecision` is **approved**:

  * `Estimate.status`:

    * If client approval is still pending: `PENDING_CLIENT_REVIEW`.
    * If client already approved (rare, e.g. quick path): `APPROVED`.
  * Log `INTERNAL_APPROVED` in `EstimateHistoryEvent`.

* If **rejected**:

  * `Estimate.status = INTERNAL_REJECTED`
  * Record reason from `ApprovalDecision`.

### 6.2 Client Review via Public Link

**Module:** `EstimatePublicLink`, `emailengine.prisma`, `customerportal.prisma` 

* Action: **“Send to client”**

  * Generates (or reuses) `EstimatePublicLink`:

    * `estimateId`
    * `token` (secure, random)
    * `expiresAt`
  * Creates `EmailMessage` (emailengine) addressed to client contact:

    * Includes secure URL: `https://app.example.com/estimate/{token}`
  * Optionally creates `CustomerPortalEstimateView` (for portal users).

* Public page capabilities (no login required):

  * View estimate header (client info, number, total).
  * View sections, line items, alternates, assumptions, exclusions.
  * Download as PDF.
  * Actions:

    * **Approve**
    * **Decline**
    * Optional **“Request Changes”** (write-only comments).

* Recording client actions:

  * On **Approve**:

    * `EstimatePublicLink.clientApprovedAt` set.
    * `Estimate.status`:

      * If internal approval pending: `CLIENT_APPROVED` and create/update `ApprovalRequest` or mark ready.
      * If internal approval done already: `APPROVED`.
    * Create `EstimateHistoryEvent.CLIENT_APPROVED`.
  * On **Decline**:

    * `Estimate.status = CLIENT_DECLINED`
    * Reason/note stored.
    * History event logged.

### 6.3 E-Signature Integration (Optional)

**Module:** `esignature.prisma` 

Configurable option on client approval step:

* When user toggles **“Require e-signature”**:

  * Create `ESignatureEnvelope`:

    * `sourceType = "ESTIMATE"`
    * `sourceId = Estimate.id`
  * Create `ESignatureDocument` representing the estimate PDF.
  * Create `ESignatureRecipient` with client email/name.
  * Envelope link is included in public view OR via a dedicated email.
  * `Estimate.status` remains `PENDING_CLIENT_REVIEW` until:

    * Envelope fully signed → `CLIENT_APPROVED`.
* `ESignatureAuditTrail` provides tamper-proof record for compliance.

---

## 7. Project Auto-Generation Flow

**Modules:** `projectsCore.prisma`, `projectTaskScheduling.prisma` 

Trigger: After **client approval** and **admin (internal) approval** are both satisfied:

1. System prompts admin:

   > “Do you want to auto-create a Project from this Estimate?”
   > Buttons: **Yes** / **No**

2. If **Yes**:

   * Create `Project`:

     * Inherit:

       * `estimateId`
       * `tenantId`
       * `projectNumber` = same sequence or derived from `Estimate.estimateNumber`.
       * `crmAccountId`, `crmContactId`
       * `currency`, `totalBudget` from estimate totals.
       * `ownerMemberId` from estimate owner.
   * For each **EstimateSection**:

     * Optionally create `ProjectPhase` (mapping by name).
   * For each **EstimateLineItem**:

     * Create `ProjectTask`:

       * `name = EstimateLineItem.itemName`
       * `description = EstimateLineItem.itemDescription`
       * `estimatedHours` or `quantity` as appropriate.
       * Link to `Project` and optionally to related `CostCode`.
     * For each `EstimateAttachment` on the line item:

       * Create `ProjectTaskAttachment` referencing original file.

3. Status update:

   * `Estimate.status = CONVERTED` (or `APPROVED` + flag `hasProject = true`).
   * `Project` stores `sourceEstimateId` to maintain traceability.
   * History events:

     * `PROJECT_AUTO_CREATED` on Estimate and Project.

---

## 8. Invoice Auto-Generation Flow

**Modules:** `invoice.prisma`, `billing.prisma`, `paymentsARCashApplication.prisma` 

Trigger: Same approval condition as project:

* After admin confirms:

  > “Also auto-generate an Invoice?” **(Yes/No)**

If **Yes**:

1. Create `Invoice`:

   * Inherit:

     * `tenantId`
     * `invoiceNumber` **= `Estimate.estimateNumber`** (or a strict mapping via shared sequence to preserve 1:1 traceability).
     * `crmAccountId`, `crmContactId`
     * `currency`
     * Billing address from CRM account/contact.
   * Link:

     * `sourceEstimateId = Estimate.id`
     * `projectId` if project was also auto-created.

2. Line Item Mapping:

   * For each `EstimateLineItem`:

     * Create `InvoiceLineItem` with:

       * `description = itemName + " – " + itemDescription` (or two fields).
       * `quantity`, `unitPrice`, `lineTotal`.
   * For `EstimateTax`, `EstimateDiscount`, `EstimateFee`: map to corresponding:

     * `InvoiceTax`
     * `InvoiceDiscount`
     * `InvoiceFee`
   * Optionally map `EstimateAttachment` into `InvoiceAttachment` (commonly only the PDF of the estimate is attached).

3. Payment Setup:

   * `InvoicePaymentApplication` records will be created later when **Payment** is received.
   * Payment terms:

     * Inherit from `EstimateTerm` where type = `PAYMENT`.

4. Status & Audit:

   * `Estimate.status` remains `CONVERTED`.
   * `Invoice.status` starts as `DRAFT` or `OPEN`.
   * History events:

     * `INVOICE_AUTO_CREATED` on Estimate & Invoice.

---

## 9. Change Order Flow Connected to Estimate

**Module:** `changeorder.prisma` 

### 9.1 Who can initiate?

* **Client**:

  * From public estimate link or portal, selects **“Request change”**.
  * Creates a draft `ChangeOrder` or at least a “Change Request” that is converted by staff.
* **Admin / Internal User**:

  * From Estimate or Project view: **“Create change order”**.

### 9.2 Change Order Structure

`ChangeOrder` links to:

* `Estimate` (source of original scope/pricing).
* `Project` (if already created).
* Optionally `Invoice` (if billing already started).

Other models used:

* `ChangeOrderLineItem` – delta line items (additions/reductions).
* `ChangeOrderReason`, `ChangeOrderImpact`, `ChangeOrderScheduleImpact`, `ChangeOrderScope`, `ChangeOrderAttachment`, `ChangeOrderRevision`, `ChangeOrderHistoryEvent`.

### 9.3 Financial Impact

* Change order expresses **deltas**:

  * Additional line items.
  * Quantity/price adjustments for existing line items.
  * Schedule changes.
* Once approved:

  * `ProjectBudget` and `ProjectTask`s can be updated.
  * `Invoice`:

    * If invoice already exists:

      * Show **Change Order section** with extra charges or credits.
      * Extra invoice lines may be added from `ChangeOrderLineItem`.
    * If no invoice yet:

      * The **auto-generated invoice** (from original estimate) will incorporate the new totals.

### 9.4 Approval Flow

* Each `ChangeOrder` triggers a **new approval workflow** via `approvals.prisma`.
* Optional e-signature via `ESignatureEnvelope` for formal acceptance.
* On final approval:

  * Update:

    * `ChangeOrder.status`
    * `Estimate`’s derived totals or mark as “has change orders”.
  * Log `CHANGE_ORDER_CREATED` and `CHANGE_ORDER_APPROVED` in `EstimateHistoryEvent`.

---

## 10. Payments & Collections in Context of Estimate

Though payments don’t happen directly on `Estimate`, the Estimate **drives** the first Invoice:

**Modules:** `paymentsARCashApplication.prisma`, `billing.prisma`, `banking.prisma` 

* When Invoice (created from Estimate) is **paid**:

  * `Payment` is created and linked to `Invoice` via `PaymentApplication`.
  * In analytics, this is tracked back to:

    * `sourceEstimateId` on Invoice.
* KPIs influenced:

  * **Estimate → Cash conversion time** (created → fully paid).
  * Estimate “win rate” (client approved & at least one payment).

---

## 11. Notifications & Communications

**Modules:** `notifications.prisma`, `emailengine.prisma`, `smscalls.prisma`, `messaging.prisma`, `customerportal.prisma` 

Events that should trigger notifications:

* Estimate created (optional, to estimator or team).
* Estimate submitted for internal approval.
* Estimate approved/rejected internally.
* Estimate sent to client (email + portal notification).
* Client viewed estimate (FYI).
* Client approved/declined.
* Project auto-created.
* Invoice auto-created.
* Change order created / approved.

Each notification can map to:

* `Notification` record with:

  * `sourceType` = "ESTIMATE"
  * `sourceId` = Estimate.id
* `EmailMessage` for email delivery.
* `SMSMessage` when configured.
* In-app messages via `MessageThread` (internal chat).

---

## 12. Access Control & Security

**Modules:** `accesscontrol.prisma`, `membership.prisma`, `identity.prisma` 

* All Estimate entities are tenant-scoped (`tenantId`).
* Primary actors:

  * `Member` (internal)
  * `ServiceAccount` (for automation)
  * External client via `CustomerPortalUser` or anonymous link (limited actions).

Role examples:

* **Estimator**:

  * Can create/edit estimates in `DRAFT`.
  * Can send for internal approval.
* **Approver (PM/Finance/Admin)**:

  * Can approve/reject internal approval requests.
  * Can trigger project/invoice auto-generation.
* **Client (external)**:

  * Can view `Estimate` via `EstimatePublicLink`.
  * Can approve/decline and sign (if e-signature enabled).
* **View-only roles**:

  * Read-only access to estimate list & detail.

Row Level Security (RLS):

* All queries must filter on `tenantId`.
* Members can only see estimates for tenants they belong to.

---

## 13. Auditability & History

* Each write operation creates an `EstimateHistoryEvent` with:

  * `eventType`
  * `timestamp`
  * `actorId` / `memberId`
  * `before` and `after` snapshots (if needed).
* `DomainEvent` (global event-sourcing table, if present) should receive events:

  * `EstimateCreated`
  * `EstimateUpdated`
  * `EstimateApprovedInternally`
  * `EstimateApprovedByClient`
  * `EstimateConvertedToProject`
  * `EstimateConvertedToInvoice`
  * `ChangeOrderCreated`
* These events drive:

  * Audit dashboards.
  * BI / analytics.
  * Downstream syncing (e.g., to external accounting systems).

---

## 14. Summary

From a senior-architect perspective, the **Estimate module** sits at the heart of your ERP’s revenue lifecycle:

1. **User opens Estimate domain** → sees KPIs + filtered grid.
2. **Creates/edits estimate** → selects or creates client, adds line items (with per-line attachments), terms, and alternates.
3. **Internal approvals** via `approvals.prisma`.
4. **Client review** via **public link** (no login), optional **e-signature** via `esignature.prisma`.
5. On dual approval:

   * Optional **auto-project generation** with tasks from line items.
   * Optional **auto-invoice generation** reusing estimate number for 1:1 traceability.
6. **Change orders** modify scope mid-stream while preserving original estimate and updating project & invoice.
7. **Payments** on invoices roll up to estimate performance metrics.
8. All actions are **audited, tenant-scoped, and permission-controlled**, with rich notifications and analytics.

If you want, next step I can do is drill down into **one concrete flow** (for example: exact events, DB fields, and API endpoints for “Send to client → client approves → auto-create project + invoice”) so you can start implementing from front-end to backend without guessing.
