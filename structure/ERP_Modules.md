# ERP Modules Documentation

Consolidated documentation for ERP modules extracted from the `/modules` directory.

Note: This document defines the canonical target module/model layout for the ERP. It is derived from the `/modules` directory and may also include forward-looking modules and models that are not yet implemented but are intended as the reference design.

## accesscontrol.prisma

// Original module name: AccessControl

Strategic purpose: Role- and attribute-based access enforcement with granular scopes, policies, and complete auditing across the ERP.

Notes:

- Supports RBAC and ABAC with `resource.action` permissions.
- Authorization is evaluated in the context of a tenant `Member` (or `ServiceAccount`) rather than raw `User` records.
- Permissions are defined globally and attached to tenant-scoped roles.
- Immutable audit trail for compliance, security, and forensics.

| Model                | Scope  | Parent | Description |
|----------------------|--------|--------|-------------|
| Role                 | Tenant | Yes    | Tenant-scoped role definitions (Admin, PM, AP Clerk, Customer, Vendor, etc.) with hierarchical inheritance and metadata. |
| Permission           | Global | Yes    | Global catalog of fine-grained permissions following the `resource.action` convention (e.g., `estimate.view`, `invoice.create`, `project.manage`). |
| RolePermission       | Tenant | No     | Many-to-many mapping between tenant `Role` records and `Permission` entries, with optional allow/deny flags and effective periods. |
| MemberRole           | Tenant | No     | Assignment of roles to `Member` records (and, where applicable, `ServiceAccount`) with temporal validity, primary-role flags, and reason codes. |
| AccessPolicy         | Tenant | Yes    | ABAC policy definitions evaluated in addition to RBAC, using member attributes, resource attributes, environment, and custom business rules. |
| AccessPolicyCondition| Tenant | No     | Atomic conditions (attribute, operator, value) combined into policies to express complex authorization logic. |
| AccessScope          | Tenant | Yes    | Multi-dimensional scoping (tenant, project, department, cost center, location, account, vendor) that can be bound to roles and members. |
| AccessScopeAssignment| Tenant | No     | Scope boundary assignments linking `MemberRole` or `ServiceAccount` identities to one or more `AccessScope` records for least-privilege enforcement. |
| AccessResource       | Global | No     | Registry of permissionable resource types and optional concrete instances enabling object-level access control and policy targeting. |
| AccessAuditEvent     | Tenant | No     | Immutable audit trail of access checks: initiator `Actor`/`Member`, resource, decision, policies evaluated, and correlation IDs. |
| ServiceAccount       | Tenant | Yes    | Non-human identity anchored to a tenant (integrations, automations, background jobs) that participates in AccessControl similarly to a `Member`. |
| ServiceAccountKey    | Tenant | No     | Credentials/API keys bound to a `ServiceAccount` with scopes, rotation history, and revocation metadata. |

## aicore.prisma

// Original module name: AI — Core

Strategic purpose: Model registry, orchestration, automation, and execution primitives for AI-driven processes (models, prompts, playbooks, jobs, and embeddings).

Notes:

- Central registry of models and versions with capability and cost metadata.
- Prompt templates, playbooks and action definitions for repeatable automations.
- Async job management, artifacts, and embedding storage for semantic services.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AIModel                | Global | Yes    | Registry of available AI models (GPT, Claude, Llama, vision/proprietary) with capability definitions, cost structures, and performance characteristics                      |
| AIModelVersion         | Global | No     | Version tracking for models (semantic versions, fine-tuned variants, compatibility notes)                                                                                   |
| AIPromptTemplate       | Global | No     | Parametric prompt templates for summarization, extraction, classification, entity recognition, and decision support                                                         |
| AIAction               | Tenant | Yes    | Configurable AI automations (e.g., auto-generate estimates, detect anomalies, generate project tasks, extract invoice line items) with triggers and execution rules         |
| AIActionRun            | Tenant | No     | Execution records for AI actions capturing inputs, outputs, duration, confidence scores, status, and errors                                                                 |
| AIPlaybook             | Tenant | Yes    | Multi-step AI workflow orchestrations chaining actions (sequential/conditional) for complete document and data pipelines                                                    |
| AIPlaybookStep         | Tenant | No     | Individual playbook steps including branching, retries, error handling, and data transformation                                                                             |
| AIEmbedding            | Tenant | No     | Vector embeddings for semantic search, similarity, clustering, and recommendations                                                                                          |
| AIJob                  | Tenant | Yes    | Asynchronous AI jobs for batch processing, bulk analysis, training, and scheduled tasks with monitoring and retry                                                           |
| AIJobArtifact          | Tenant | No     | Generated outputs from AI jobs (JSON, processed files, reports, intermediate artifacts)                                                                                     |

## aidocument.prisma

// Original module name: AI — Document Intelligence

Strategic purpose: OCR, document processing, extraction, classification, semantic indexing, and chunk-level embeddings for hybrid search and downstream analysis.

Notes:

- OCR and extraction pipelines with confidence and positional metadata.
- Document indexing with chunking and vector embeddings for semantic retrieval.
- Document history and attachment lineage for traceability.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AIDocumentIndex        | Tenant | Yes    | Searchable document corpus with semantic chunking, vector embeddings, and metadata extraction for hybrid retrieval                                                          |
| AIDocumentChunk        | Tenant | No     | Segmented document fragments with embedded vectors and relevance scoring for efficient retrieval                                                                            |
| AIOCRResult            | Tenant | No     | OCR results for scanned PDFs, images, and handwritten documents with confidence and positional data                                                                         |
| AIExtractionResult     | Tenant | No     | Structured extraction outputs (entities, line items, totals, dates, parties, terms) from unstructured content                                                               |
| AIClassificationResult | Tenant | No     | Automatic document-type classification (invoice, PO, contract, receipt, estimate, etc.) with confidence                                                                     |
| AIDocumentAttachment   | Tenant | No     | Original files processed by AI with storage references and processing lineage                                                                                               |
| AIDocumentHistoryEvent | Tenant | No     | Full processing timeline: OCR, extraction, classification, reprocessing, and quality iterations                                                                             |
| AIAnnotation           | Tenant | No     | Markups: bounding boxes, highlights, semantic tags for training and validation                                                                                              |
| AIEntity               | Tenant | No     | Extracted named entities (vendors, customers, amounts, dates, locations, items) with confidence and sources                                                                 |
| AIInsightFeedback      | Tenant | No     | Human feedback and corrections for reinforcement and accuracy tracking                                                                                                      |

## aiinsights.prisma

// Original module name: AI — Insights & Analytics

Strategic purpose: Business insights, predictions, recommendations, anomaly detection, trend analysis, and scenario modeling driven by AI and statistical engines.

Notes:

- Insight artifacts and history for governance and remediation.
- Predictions, forecasts, trend series, anomalies, and what-if simulations for planning.
- Attachments and human feedback for validation and audit.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AIInsight              | Tenant | Yes    | AI-generated business insights (overpriced lines, schedule risks, margin erosion, vendor anomalies)                                                                         |
| AIInsightHistory       | Tenant | No     | Temporal evolution of insights with updated confidence, actions taken, and outcomes                                                                                         |
| AIPrediction           | Tenant | No     | Predictive outputs (CTC forecasts, schedule risk, revenue, expenses, cash flow) with confidence intervals                                                                   |
| AIRecommendation       | Tenant | No     | Prescriptive suggestions (crew sizing, material reorder timing, schedule optimization, vendor selection, risk mitigation)                                                   |
| AIAnomaly              | Tenant | No     | Statistical/pattern anomaly detection (high invoices, shrinkage, inefficiency, data quality issues)                                                                         |
| AITrend                | Tenant | No     | Temporal and categorical trend detection (cost, productivity, win rate, market)                                                                                             |
| AIForecast             | Tenant | No     | Time-series projections (revenue, cost, utilization, timelines, demand) with scenario modeling                                                                              |
| AIWhatIfRun            | Tenant | No     | Scenario simulations (crew size, material prices, weather delays, scope changes) and impact analyses                                                                        |
| AIInsightAttachment    | Tenant | No     | Supporting charts, reports, references, and justification artifacts for insights                                                                                            |

## approvals.prisma

Strategic purpose: Central approvals engine reused across Projects, Estimates, Change Orders, Invoices, and POs with configurable, auditable workflows.

Notes:

- Multi-level workflows (sequential/parallel) with thresholds and rules.
- Escalations and SLAs for overdue approvals.
- Condition-based routing using document attributes and risk.
- Full auditability with user attribution and timestamps.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ApprovalRequest       | Tenant | Yes    | Universal approval container for any entity (estimate, invoice, CO, PO), supporting configurable routing, delegation, and deadlines                                                                                               |
| ApprovalRule          | Tenant | No     | Business rules establishing approval requirements by amount, department, document type, risk thresholds, contract values, and composite criteria                                                                                  |
| ApprovalLevel         | Tenant | No     | Tier definitions supporting sequential and parallel chains (operational, management, executive, final sign-off)                                                                                                                   |
| ApprovalDecision      | Tenant | No     | Approver actions: approve, reject, request changes, conditional approval; includes timestamps, digital signatures, comments, and delegation records                                                                                |
| ApprovalAssignment    | Tenant | No     | Dynamic assignment of responsibilities to users, roles, departments, or external parties with routing based on org hierarchy and availability                                                                                      |
| ApprovalStep          | Tenant | No     | Workflow steps defining progression, required actions, timeouts, skip conditions, dependencies, and parallelization                                                                                                               |
| ApprovalEscalation    | Tenant | No     | Automated escalations when SLAs are exceeded with notifications, reassignments, escalation chains, and override procedures                                                                                                         |
| ApprovalCondition     | Tenant | No     | Data-driven conditional routing using attributes (amount thresholds, variances, customer risk scores) and custom rules                                                                                                             |
| ApprovalAttachment    | Tenant | No     | Supporting documentation and evidence (source docs, memos, financials) required for decisions                                                                                                                                     |
| ApprovalHistoryEvent  | Tenant | No     | Comprehensive audit trail of submission, routing, decisions, escalations, cancellations, and completion with full attribution                                                                                                     |

## billing.prisma

Strategic purpose: Enterprise billing and AR with progress/milestone/T&M billing, retainage, deposits, payment application, aging, and collections.

Notes:

- Multiple billing methods (T&M, milestone, % complete) with retainage.
- AR ledger with payment application and aging snapshots.
- Dunning/collections with audit history of billing lifecycle.
- Integrates with projects and milestones for billing triggers.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BillingSchedule             | Tenant | Yes    | Master billing configuration defining T&M, milestone, % complete, deposit structures, retainage terms, and timing aligned with deliverables                                                                                      |
| BillingMilestone            | Tenant | No     | Project-linked billing events (e.g., 50% rough-in, concrete pour, framing complete, final walkthrough) with verification rules                                                                                                   |
| BillingProgress             | Tenant | No     | Percentage of completion billing (AIA G702/G703) tracking work completed, stored materials, retainage, and current payment calculations                                                                                           |
| BillingRetainage            | Tenant | No     | Retention management holding specified percentages until milestones/completion with release schedules and reductions                                                                                                              |
| BillingDeposit              | Tenant | No     | Upfront deposits/down payments/prepaid work applied against future invoices with contractual handling                                                                                                                            |
| BillingAdjustment           | Tenant | No     | Post-billing modifications (credits, debits, rebills, price corrections) with full auditability                                                                                                                                  |
| ReceivableLedger            | Tenant | Yes    | Comprehensive AR ledger tracking charges, credits, payments, adjustments, write-offs, and balances per customer with aging and collection status                                                                                 |
| ReceivablePaymentApplication| Tenant | No     | Payment allocation mapping to invoices supporting partials, over/pretpayments, and multi-invoice application with automation                                                                                                      |
| ReceivableAgingSnapshot     | Tenant | No     | Point-in-time AR aging (current, 0–30, 31–60, 61–90, 90+) for forecasting and collection prioritization                                                                                                                          |
| BillingHistoryEvent         | Tenant | No     | Lifecycle audit: generated, delivered, due, received, overdue, collection actions, dunning notices, partials, settlement                                                                                                         |

## changeorder.prisma

// Original module name: ChangeOrder

Strategic purpose: Formal contract modifications managing scope, cost, and schedule changes with approvals, documentation, and auditability.

Notes:

- Full lifecycle from identification to approval and billing.
- Cost and schedule impact analysis with milestone effects.
- Linked RFIs, drawings, calculations, and client correspondence.
- Versioned revisions prior to final approval.
- Approval workflows are orchestrated through the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.) instead of ChangeOrder-specific approval tables.

| Model                   | Scope  | Parent | Description                                                                                                                                                                  |
| ----------------------- | ------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ChangeOrder             | Hybrid | Yes    | Formal contract modification documenting scope/cost/time changes, origin/justification, pricing method (fixed or T&M), client authorization, and links to source estimate and active project |
| ChangeOrderLineItem     | Tenant | No     | Detailed change impacts (labor, materials, equipment, subcontract, markup) with variance against original budget                                                            |
| ChangeOrderReason       | Tenant | No     | Categorized reasons (owner request, field condition, design change, code update, RFI clarification) for trend analysis and dispute resolution                               |
| ChangeOrderImpact       | Tenant | No     | Financial impact analysis (positive/negative) across direct (materials, labor, equipment) and indirect (overhead, general conditions, margin) costs                         |
| ChangeOrderScheduleImpact | Tenant | No   | Critical path and milestone impacts (days added/recovered, affected deliverables, resource reallocation, substantial completion modifications)                              |
| ChangeOrderScope        | Tenant | No     | Comprehensive scope statement including work added/deleted, inclusions, exclusions, performance/spec references, and integration with existing contract scope              |
| ChangeOrderAttachment   | Tenant | No     | Evidence and support (as-built photos, revised drawings, engineering calcs, sketches, RFIs, specs, client correspondence)                                                   |
| ChangeOrderRevision     | Tenant | No     | Version control over negotiation iterations (V1, V2, V3) tracking cost/scope evolution to final approval                                                                    |
| ChangeOrderHistoryEvent | Tenant | No     | Complete lifecycle audit from identification and proposal to review, negotiation, approval/rejection, contract incorporation, and billing integration                       |

## crmcore.prisma

// Original module name: CRM — Core

Strategic purpose: Nucleus of customer/account data — master accounts, contacts, addresses, activities, tagging, and audit history enabling CRM-driven sales and service workflows.

Notes:

- Canonical account and contact records linked to billing, projects, and interactions.
- External participants with portal access are represented as `Member` records of type EXTERNAL_CLIENT / PARTNER and linked back to CRM accounts/contacts via the membership directory.
- Support for multiple address types and rich interaction logging with attachments.
- Tagging and activity tables for segmentation and operational tasks.

| Model                   | Scope  | Parent | Description |
|-------------------------|--------|--------|-------------|
| CRMAccount              | Tenant | Yes    | Primary customer account representing companies, owners, property managers, or homeowner associations with billing, project, and portal-linkage metadata. |
| CRMContact              | Tenant | No     | Person-level contacts associated to accounts with roles (owner, site supervisor, billing contact) and optional linkage to a `Member` when that person has login access. |
| CRMAddress              | Tenant | No     | Multiple address types per account/contact: billing, jobsite, shipping, corporate. |
| CRMInteraction          | Tenant | No     | Logged interactions (calls, meetings, emails, visits) with metadata, `Actor`/`Member` attribution, and links to accounts and contacts. |
| CRMInteractionAttachment| Tenant | No     | Files, photos, recordings, and documents attached to interactions for evidence and context. |
| CRMNote                 | Tenant | No     | Internal notes and commentary tied to accounts, contacts, or interactions; never exposed directly to external portal users. |
| CRMTag                  | Tenant | Yes    | Tagging taxonomy (VIP, Commercial, Repeat Customer, At-Risk) for segmentation and operational filtering. |
| CRMAccountTag           | Tenant | No     | Many-to-many mapping between `CRMAccount` and `CRMTag`. |
| CRMActivity             | Tenant | No     | Actionable tasks and reminders (follow-ups, proposals, meetings) tied to accounts or contacts, with ownership and due dates. |
| CRMHistoryEvent         | Tenant | No     | Timeline events capturing creates, updates, interactions, notes, segmentation changes, and lifecycle state changes. |

## crmcommunication.prisma

// Original module name: CRM — Communication

Strategic purpose: Omnichannel customer communication — emails, SMS, calls, and messaging threads with delivery, history, and compliance tracking.

Notes:

- Email, SMS, and voice call storage with attachments and delivery logs.
- Conversation threads and read receipts for collaborative workflows.
- Participants in threads are normalized to `Member` and/or CRM contact/account records for auditability.
- Provider configuration for external gateway integration (Twilio, Sendgrid, etc.).

| Model                   | Scope  | Parent | Description |
|-------------------------|--------|--------|-------------|
| CRMEmail                | Hybrid | Yes    | Email records (sent/received) with headers, bodies, delivery/audit information, and links to CRM entities. |
| CRMEmailAttachment      | Tenant | No     | Attachments for emails (documents, proposals, images). |
| CRMSMS                  | Tenant | No     | SMS message records and delivery status linked to contacts or members. |
| CRMPhoneCall            | Tenant | No     | Phone call logs with duration, participants, and summary notes; integrates with recordings and CRM interactions. |
| CRMPhoneCallRecording   | Tenant | No     | Call recordings or references to stored audio for compliance or review. |
| CRMMessageThread        | Hybrid | Yes    | Conversation threads across channels with participants, thread-level metadata, and linkage to CRM accounts/projects. |
| CRMMessageParticipant   | Tenant | No     | Participants in message threads, normalized to `Member` (when portal or internal users are involved) and/or CRM contacts/accounts for off-platform recipients. |
| CRMChannel              | Tenant | No     | Communication channel registry (email, SMS, phone, in-app). |
| CRMNotificationSetting  | Tenant | No     | Customer notification preferences and channel opt-ins, keyed by contact and optionally `Member`. |
| CRMNotificationEvent    | Tenant | No     | Delivery and engagement events for notifications (sent, delivered, opened) with attribution to the triggering `Actor`/`Member`. |

## crmrelationships.prisma

// Original module name: CRM — Relationships

Strategic purpose: Model complex account hierarchies, partner networks, households, and contact roles to represent real-world organizational structures.

Notes:

- Parent/child account hierarchies and household grouping for residential customers.
- Relationship types for partners, subsidiaries, decision-makers, and influencers.
- When relationship participants have login access, they are linked to `Member` records to unify identity and authorization.
- Attachment and history tables for governance and audits.

| Model                     | Scope  | Parent | Description |
|---------------------------|--------|--------|-------------|
| CRMAccountRelationship    | Tenant | Yes    | Account-to-account relationships (parent/subsidiary, GC→Subcontractor) for complex organization mapping. |
| CRMContactRole            | Tenant | No     | Role definitions for contacts (Decision Maker, Billing Contact, Site Contact) referenced by CRM contacts and members. |
| CRMAccountHierarchy       | Tenant | No     | Multi-level account hierarchy model including roll-up flags and reporting metadata. |
| CRMHousehold              | Tenant | Yes    | Household grouping for residential customers with household-level attributes (credit profile, preferences). |
| CRMHouseholdMember        | Tenant | No     | Individuals within a household (spouse, partner, co-owner) mapped to CRM contacts and optionally to `Member` records for portal access. |
| CRMDecisionMaker          | Tenant | No     | Designated decision-maker contact for high-value opportunities with optional linkage to a `Member`. |
| CRMInfluencer             | Tenant | No     | Secondary influencers (architect, consultant) impacting decisions, optionally linked to members or contacts. |
| CRMPartner                | Tenant | No     | Partner entities such as vendors, consultants, or referral networks with links to vendor records and `Member` entries when they have portal access. |
| CRMRelationshipAttachment | Tenant | No     | Relationship artifacts (org charts, diagrams, agreements) attached to relationship records. |
| CRMRelationshipHistoryEvent| Tenant| No     | Timeline of changes to relationship mappings and roles with `Actor` attribution. |

## customerportal.prisma

// Original module name: CustomerPortal

Strategic purpose: Secure customer-facing portal delivering access to invoices, estimates, project views, messages, and payments on top of the global identity and membership model.

Notes:

- Portal authentication uses global `User` from `identityCore`; tenant context and permissions are derived from `Member` records of type EXTERNAL_CLIENT / PARTNER.
- No separate credential store is maintained in the portal; `CustomerPortalUser` is a portal profile bound to a `Member` plus CRM entities.
- Fine-grained view permissions for invoices, projects, estimates, and documents are enforced via AccessControl using `Member` and scopes.
- Stored payment methods and messaging between customer and company are audited with `Actor`/`Member` attribution.

| Model                       | Scope  | Parent | Description |
|-----------------------------|--------|--------|-------------|
| CustomerPortalUser          | Hybrid | Yes    | Portal profile for an external `Member` (client/owner/partner) with UI preferences, linked CRM account/contact references, and status; authentication is via global `User`. |
| CustomerPortalSession       | Hybrid | No     | Portal session records referencing global `Session` and resolving to a `Member` context, with device metadata, IP, and expiration. |
| CustomerPortalAccess        | Tenant | No     | High-level portal feature entitlements (invoices, projects, files, messages, estimates) bound to a `Member` and backed by AccessControl roles/policies. |
| CustomerPortalProjectView   | Tenant | No     | Per-project portal view permissions tying `Member`/portal users to project summaries and available actions. |
| CustomerPortalEstimateView  | Tenant | No     | Access records for estimates exposed to specific external members for review/approval. |
| CustomerPortalInvoiceView   | Tenant | No     | Access records for invoices and payment status visible to customers, including masking of internal-only fields. |
| CustomerPortalPaymentMethod | Tenant | No     | Tokenized stored payment instruments (cards, ACH, wallets) associated with a `Member` and CRM account for reuse within the portal. |
| CustomerPortalMessage       | Tenant | No     | Messages exchanged between customer and company tied to projects, accounts, or estimates, referencing sender/recipient `Member` records. |
| CustomerPortalDocument      | Tenant | No     | Documents exposed to customers (contracts, plans, photos) with access metadata and links back to core document records. |
| CustomerPortalHistoryEvent  | Tenant | No     | Portal activity events (login, view, download, pay, message send) for audit, analytics, and support. |

## analytics.prisma

// Original module name: Analytics Core

Strategic purpose: Configurable dashboards, visualizations, datasets and analytics primitives for operational and executive insights.

Notes:

- Core analytics datasets, metrics, dimensions and saved queries.
- Dashboard definition, widgets, user views, scheduling and sharing.
- Insight entities for automated and manual observations.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AnalyticsDataset        | Tenant | Yes    | Source dataset definitions used by dashboards and analytics (job costing, schedule, inventory)                                                                                 |
| AnalyticsDatasetField   | Tenant | No     | Field schema for datasets including semantic type and datatype                                                                                                                 |
| AnalyticsCube           | Tenant | No     | Pre-aggregated OLAP cube or snapshot for high-performance queries                                                                                                              |
| AnalyticsMetric         | Tenant | No     | KPI definitions and calculation logic (revenue, cost variance, utilization)                                                                                                   |
| AnalyticsDimension      | Tenant | No     | Dimensions used for slicing (time, project, cost code)                                                                                                                         |
| AnalyticsFilter         | Tenant | No     | Saved filters for reuse across widgets and dashboards                                                                                                                          |
| AnalyticsQuery          | Tenant | No     | Cached or persisted queries powering widgets                                                                                                                                  |
| AnalyticsInsight        | Tenant | No     | Insights generated by analytics or AI engines                                                                                                                                  |
| AnalyticsInsightHistoryEvent|Tenant| No    | Timeline for insights and derived actions                                                                                                                                     |
| AnalyticsAttachment     | Tenant | No     | Exported artifacts (CSV/Excel/PDF) for dashboards                                                                                                                              |

## dashboards.prisma

// Original module name: Dashboards & Visualizations

Strategic purpose: User-facing dashboards, widget configuration, layout management and sharing for role-based insights.

Notes:

- Dashboard containers, widgets, templates, schedules, bookmarks and sharing controls.
- User-personalized layouts and folder organization.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Dashboard               | Hybrid | Yes    | Root dashboard entity containing widgets, metadata and access controls                                                                                                        |
| DashboardWidget         | Tenant | No     | Individual widget types (chart, table, KPI, map) with config                                                                                                                   |
| DashboardWidgetConfig   | Tenant | No     | Stored configuration for widget filters, fields and display options                                                                                                           |
| DashboardUserView       | Tenant | No     | User-specific dashboard layout and preferences                                                                                                                                |
| DashboardSchedule       | Tenant | No     | Scheduled snapshot/email jobs for dashboards                                                                                                                                    |
| DashboardBookmark       | Tenant | No     | Saved views and bookmarks                                                                                                                                                      |
| DashboardSharing        | Tenant | No     | Sharing records for teams, roles, or external users                                                                                                                            |
| DashboardTemplate       | Tenant | No     | Pre-built dashboard templates for common use cases                                                                                                                              |
| DashboardFolder         | Tenant | No     | Foldering/organization for dashboards                                                                                                                                        |
| DashboardHistoryEvent   | Tenant | No     | Audit events for dashboard changes and usage                                                                                                                                    |

## documentscore.prisma

// Original module name: Documents — Core

Strategic purpose: File storage, versioning, permissions, sharing and collaboration for project and administrative documents.

Notes:

- Core document entity, foldering, versioning, revisions and comments.
- Permissions, share links and history for governance.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Document                | Hybrid | Yes    | Primary file entity representing documents, drawings, contracts, submittals                                                                                                   |
| DocumentFolder          | Tenant | No     | Folder hierarchy for organizing documents                                                                                                                                     |
| DocumentVersion         | Tenant | No     | Version records for documents                                                                                                                                                 |
| DocumentRevision        | Tenant | No     | Submitted revision records                                                                                                                                                    |
| DocumentComment         | Tenant | No     | Discussion comments attached to documents                                                                                                                                     |
| DocumentTag             | Tenant | No     | Labels and tagging for categorization                                                                                                                                         |
| DocumentShareLink       | Tenant | No     | External shareable link records with expiry and permissions                                                                                                                    |
| DocumentPermission      | Tenant | No     | ACL entries governing access per user/team                                                                                                                                     |
| DocumentAttachment      | Tenant | No     | Supplemental files attached to documents                                                                                                                                       |
| DocumentHistoryEvent    | Tenant | No     | Audit timeline for document events                                                                                                                                            |

## documentsai.prisma

// Original module name: Documents — OCR & AI

Strategic purpose: OCR, extraction, classification, chunking and embedding for semantic search and automated data capture.

Notes:

- OCR results, AI extraction outputs, annotation and indexing for document analytics.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| DocumentOCRResult       | Tenant | No     | OCR raw text and positional metadata                                                                                                                                          |
| DocumentAIExtraction    | Tenant | No     | Structured extraction outputs (entities, amounts, line items)                                                                                                                  |
| DocumentAIClassification| Tenant | No     | Document type classification                                                                                                                                                  |
| DocumentAnnotation      | Tenant | No     | Bounding boxes and markups used for training and validation                                                                                                                    |
| DocumentIndex           | Tenant | No     | Search index for documents and chunks                                                                                                                                         |
| DocumentChunk           | Tenant | No     | Chunked document fragments for retrieval                                                                                                                                      |
| DocumentEmbedding       | Tenant | No     | Vector embeddings for semantic similarity                                                                                                                                      |
| DocumentTrainingSample  | Tenant | No     | Labeled samples used to retrain extraction/classification models                                                                                                               |
| DocumentAIModel         | Tenant | No     | Reference to AI model/version used for processing                                                                                                                              |
| DocumentAIHistory       | Tenant | No     | Audit history for document AI processing                                                                                                                                      |

## esignature.prisma

// Original module name: ESignature

Strategic purpose: Enterprise e-signature workflow handling envelopes, recipients, fields, notifications and audit trails.

Notes:

- Envelope-based signing, recipient actions, field placement, and signature workflows.
- Full audit trail and notification/reminder system.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ESignatureEnvelope      | Hybrid | Yes    | Envelope container for one or more documents to be signed                                                                                                                     |
| ESignatureDocument      | Tenant | No     | Documents included in the envelope                                                                                                                                           |
| ESignatureRecipient     | Tenant | No     | Signer records and routing information                                                                                                                                        |
| ESignatureRecipientAction|Tenant | No     | Actions taken by recipients (sign, approve, decline)                                                                                                                          |
| ESignatureField         | Tenant | No     | Signature fields, initials, dates and field metadata                                                                                                                          |
| ESignatureAuditTrail    | Tenant | No     | Immutable audit events for signature actions                                                                                                                                  |
| ESignatureWorkflowStep  | Tenant | No     | Ordered workflow steps for signing                                                                                                                                           |
| ESignatureAttachment    | Tenant | No     | Attachments associated with signature requests                                                                                                                                |
| ESignatureNotification  | Tenant | No     | Reminder and notification records                                                                                                                                             |
| ESignatureHistoryEvent  | Tenant | No     | Timeline of envelope events                                                                                                                                                   |

## messaging.prisma

// Original module name: Communications — Messaging / Chat

Strategic purpose: Real-time and threaded messaging for collaboration across users, crews, and external partners — includes attachments, reactions, visibility rules, and audit history.

Notes:

- Threaded conversations (1:1, group, channel) with participation and read receipts.
- Attachments, reactions, mentions, pins and visibility rules for project contexts.
- Audit trail for edits/deletes and message history.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MessageThread           | Hybrid | Yes    | Conversation container (1:1, group, project channel) with metadata and participants                                                                                             |
| Message                 | Tenant | No     | Individual message payloads: text, files, emojis, audio                                                                                                                         |
| MessageParticipant      | Tenant | No     | Participants in a thread (users, accounts, system bots)                                                                                                                         |
| MessageAttachment       | Tenant | No     | Files attached to messages (images, PDFs, audio)                                                                                                                               |
| MessageReaction         | Tenant | No     | Reactions applied to messages (emoji, statuses)                                                                                                                                |
| MessageMention          | Tenant | No     | Mention records linking users or teams referenced in messages                                                                                                                   |
| MessageVisibilityRule   | Tenant | No     | Fine-grained visibility rules by role, project, or guest access                                                                                                                |
| MessageReadReceipt      | Tenant | No     | Per-user read status for messages                                                                                                                                                |
| MessagePin              | Tenant | No     | Pinned messages for quick reference                                                                                                                                            |
| MessageHistoryEvent     | Tenant | No     | Audit of edits, deletes, and system events for messages                                                                                                                         |

## emailengine.prisma

// Original module name: Communications — Email Engine

Strategic purpose: Enterprise email backend integrated with CRM and projects — supports templates, campaigns, threading, delivery logs, and bounce handling.

Notes:

- Store emails, recipients, attachments, send logs and bounce tracking.
- Link email threads to projects, RFIs, invoices and other entities.
- Support bulk campaigns and template reuse.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| EmailMessage            | Hybrid | Yes    | Email stored in ERP with headers, body, and thread links                                                                                                                       |
| EmailRecipient          | Tenant | No     | Recipient rows for To/CC/BCC with delivery status                                                                                                                              |
| EmailAttachment         | Tenant | No     | Files attached to emails                                                                                                                                                       |
| EmailTemplate           | Tenant | No     | Reusable email templates                                                                                                                                                       |
| EmailCampaign           | Hybrid | No     | Campaign container for bulk sends linked to CRM audiences                                                                                                                      |
| EmailAccount            | Tenant | No     | SMTP/IMAP account configuration and credentials (secured)                                                                                                                      |
| EmailThreadLink         | Tenant | No     | Links between emails and domain entities (project, RFI, invoice)                                                                                                                |
| EmailSendLog            | Tenant | No     | Delivery logs and diagnostic info for sent messages                                                                                                                            |
| EmailBounce             | Tenant | No     | Bounce tracking for failed deliveries                                                                                                                                          |
| EmailHistoryEvent       | Tenant | No     | Timeline of changes, resends, and actions related to emails                                                                                                                     |

## smscalls.prisma

// Original module name: Communications — SMS & Calls

Strategic purpose: SMS and telephony integration for notifications, two-way messaging, and call recording with provider management.

Notes:

- SMS inbound/outbound records and media attachments.
- Call sessions with recordings, IVR menus, queues, and number pools.
- Configurable providers (Twilio, Plivo) per tenant.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SMSMessage              | Hybrid | Yes    | Inbound/outbound SMS message records with status and metadata                                                                                                                   |
| SMSAttachment           | Tenant | No     | Media attached to SMS messages                                                                                                                                                 |
| SMSHistoryEvent         | Tenant | No     | Timeline events for SMS (sent, delivered, failed)                                                                                                                              |
| PhoneCall               | Hybrid | Yes    | Call session record with participants, duration, and linkage to entities                                                                                                       |
| PhoneCallRecording      | Tenant | No     | Reference to stored call audio or transcript                                                                                                                                   |
| PhoneCallHistoryEvent   | Tenant | No     | Call lifecycle events (start, hold, transfer, end)                                                                                                                             |
| PhoneIVRMenu            | Tenant | No     | IVR menu definitions for automated call routing                                                                                                                                |
| PhoneQueue              | Tenant | No     | Call queue configuration for support/dispatch                                                                                                                                    |
| PhoneNumberPool         | Tenant | No     | Managed phone numbers owned by tenant                                                                                                                                          |
| CommunicationProvider   | Tenant | No     | External provider configurations (Twilio, Vonage, Plivo)                                                                                                                       |

## compliance.prisma

Strategic purpose: Track regulatory and contractual compliance requirements, evidence, audits, training, and remediation actions across projects and vendors.

Notes:

- Define compliance requirements and attach certificates/COIs/permits.
- Periodic checks, violations, correction actions and formal audits.
- Training records and full compliance history for reporting and insurance.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ComplianceRequirement   | Tenant | Yes    | Legal or contractual requirement (OSHA, codes, permits, bonding) with linkage to projects and contracts                                                                        |
| ComplianceDocument      | Tenant | No     | Certifications, COIs, permits, SDS, inspection reports                                                                                                                         |
| ComplianceCheck         | Tenant | No     | Periodic or event-driven compliance checks and results                                                                                                                         |
| ComplianceViolation     | Tenant | No     | Recorded violations when requirements are not met                                                                                                                              |
| ComplianceCorrectionAction| Tenant| No     | Actions to remediate violations with ownership and due dates                                                                                                                   |
| ComplianceAudit         | Tenant | Yes    | Formal audit events (internal/external)                                                                                                                                       |
| ComplianceAuditFinding  | Tenant | No     | Findings from audits with severity and remediation guidance                                                                                                                    |
| ComplianceTrainingRecord| Tenant | No     | Training completions and certifications (OSHA, safety modules)                                                                                                                 |
| ComplianceAttachment    | Tenant | No     | Documents linked to requirements, audits, or violations                                                                                                                        |
| ComplianceHistory       | Tenant | No     | Full timeline of compliance activities, checks, audits, and remediation                                                                                                        |

## contracts.prisma

Strategic purpose: Manage master contracts, scopes, terms, deliverables, milestones, amendments, signatures, and contract-level compliance.

Notes:

- Master contract record with scopes, terms, and deliverables.
- Amendments and signatures with evidence attachments.
- Contract-level compliance and history tracking separate from change orders.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Contract                | Tenant | Yes    | Master contract record (customer or subcontractor) with value, scope, term, type and lifecycle status                                                                           |
| ContractScope           | Tenant | No     | Description of inclusions and exclusions for the contract                                                                                                                     |
| ContractTerm            | Tenant | No     | Legal terms and conditions including payment terms, insurance, and warranties                                                                                                  |
| ContractDeliverable     | Tenant | No     | Deliverables associated to contract (phases, deliverable descriptions)                                                                                                        |
| ContractMilestone       | Tenant | No     | Milestones tied to payments or progress                                                                                                                                       |
| ContractAmendment       | Tenant | No     | Amendments to contract-level details (distinct from Change Orders)                                                                                                             |
| ContractAttachment      | Tenant | No     | Signatures, exhibits, schedules, drawings, and exhibits                                                                                                                         |
| ContractSignature       | Tenant | No     | Digital signature records for parties and internal approvers                                                                                                                   |
| ContractCompliance      | Tenant | No     | Insurance, bonding and licensing records tied to the contract                                                                                                                  |
| ContractHistoryEvent    | Tenant | No     | Activity log: issued, negotiated, signed, amended, expired                                                                                                                      |

## estimate.prisma

Strategic purpose: Comprehensive estimating system with versioning, sections, line items, taxes, discounts, alternates, approvals, and public sharing links for client review.

Notes:

- Revision history with immutable snapshots for audit trails and comparison analysis.
- Sectioned estimates with granular line-item details, taxes, fees, assumptions, and exclusions.
- Template-based estimation and public links for client review and acceptance workflows.
- Approval workflows for estimates are orchestrated through the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.) instead of module-specific `EstimateApproval` tables.

| Model                | Scope  | Parent | Description                                                                                                                                      |
| -------------------- | ------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Estimate             | Hybrid | Yes    | Master estimate entity representing formal cost opportunity with customer, status, totals, margin, active revision, and ownership assignment    |
| EstimateRevision     | Tenant | No     | Immutable revision snapshots capturing point-in-time estimate state for audit trails and comparison workflows                                   |
| EstimateSection      | Tenant | No     | Section groupings within revisions organizing estimate by trade or category (Plumbing, Electrical, Excavation, etc.)                           |
| EstimateLineItem     | Tenant | No     | Individual cost components with quantity, unit cost, markup, margin, item type, unit of measure, and extended calculations                      |
| EstimateTax          | Tenant | No     | Tax calculations applied at revision or line level including sales tax, VAT, environmental fees, and local assessments                          |
| EstimateDiscount     | Tenant | No     | Discount applications at estimate or section level with percentage or fixed amount reductions                                                   |
| EstimateFee          | Tenant | No     | Additional charges including overhead, contingency fees, general conditions, and management fees                                                |
| EstimateTerm         | Tenant | No     | Contractual and payment terms included with estimate submissions for client acceptance                                                          |
| EstimateAssumption   | Tenant | No     | Declared assumptions for scope clarity and risk mitigation (access requirements, site conditions, material availability)                        |
| EstimateExclusion    | Tenant | No     | Explicit scope exclusions and items not covered by the estimate                                                                                 |
| EstimateAlternate    | Tenant | No     | Optional alternates and value engineering options with associated cost implications                                                             |
| EstimateAttachment   | Tenant | No     | Supporting documents including drawings, specifications, BOQs, photos, and reference materials                                                  |
| EstimateComment      | Tenant | No     | Internal comments and discussions for collaboration and decision tracking                                                                       |
| EstimateComparison   | Tenant | No     | Comparison containers for analyzing multiple bids, revisions, and competitive assessments                                                       |
| EstimateHistoryEvent | Tenant | No     | Comprehensive audit trail capturing estimate lifecycle events, status changes, and stakeholder activities                                      |
| EstimatePublicLink   | Tenant | No     | Public access links enabling client review, acceptance, and feedback collection without system access                                          |

## expensecore.prisma

// Original module name: expensesCore

Strategic purpose: Employee expense management with comprehensive reporting, receipt handling, policy enforcement, approvals, and reimbursement processing.

Notes:

- Expense reports containing multiple line items with receipt attachment and policy validation.
- Automated policy enforcement with violation detection and escalation workflows.
- Integration with reimbursement processing and financial reporting systems.
- Approval workflows for expense reports are orchestrated through the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.) instead of module-specific `ExpenseApproval` tables.

| Model                  | Scope  | Parent | Description                                                                                                                                  |
| ---------------------- | ------ | ------ | -------------------------------------------------------------------------------------------------------------------------------------------- |
| ExpenseReport          | Tenant | Yes    | Employee-submitted expense containers with departmental allocation, project linkage, approval status, and reimbursement tracking            |
| ExpenseLine            | Tenant | No     | Individual expense items including mileage, meals, lodging, materials with categorization and receipt requirements                          |
| ExpenseCategory        | Tenant | No     | Expense classification taxonomy for reporting and policy application (Meals, Travel, Office Supplies, Fuel, Lodging)                        |
| ExpenseReceipt         | Tenant | No     | Receipt images and metadata with OCR integration for automated data extraction and validation                                               |
| ExpensePolicy          | Tenant | No     | Business rules and spending limits including daily maximums, mileage rates, and category restrictions                                       |
| ExpensePolicyViolation | Tenant | No     | Automated violation detection for policy breaches including amount limits, missing receipts, and unauthorized vendors                       |
| ExpensePayment         | Tenant | No     | Reimbursement records linking to payroll systems and corporate card reconciliation processes                                                |
| ExpenseAttachment      | Tenant | No     | Supplemental documentation including emails, supporting files, and additional evidence                                                      |
| ExpenseHistoryEvent    | Tenant | No     | Complete timeline tracking submission, review, approval, rejection, and reimbursement activities (with approvals linked via Approvals module)|

## expenses.prisma

Strategic purpose: Corporate credit card management with transaction feeds, automated reconciliation, receipt capture, and dispute resolution capabilities.

Notes:

- Bank feed integration for real-time transaction import and processing.
- Automated matching between card transactions and expense reports with manual override capabilities.
- Vendor categorization and spending limit enforcement with alert mechanisms.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| CorpCard                | Tenant | Yes    | Corporate credit card entities assigned to employees with spending limits and usage monitoring                                                                              |
| CorpCardTransaction     | Tenant | No     | Raw transaction imports from bank feeds and payment processors with merchant details and categorization                                                                     |
| CorpCardReconciliation  | Tenant | No     | Matching records linking expense report lines to corresponding card transactions for automated reconciliation                                                               |
| CorpCardLimit           | Tenant | No     | Spending limit definitions including daily, weekly, and monthly caps with category-specific restrictions                                                                    |
| CorpCardDispute         | Tenant | No     | Disputed transaction records with resolution tracking and supporting documentation management                                                                                |
| CorpCardVendor          | Tenant | No     | Known vendor registry with categorization for accelerated reconciliation and policy enforcement                                                                             |
| CorpCardReceipt         | Tenant | No     | Receipt images captured directly through mobile applications and linked to card transactions                                                                                |
| CorpCardAttachment      | Tenant | No     | Monthly statements, exported files, and additional supporting documentation                                                                                                 |
| CorpCardHistoryEvent    | Tenant | No     | Audit trail for card lifecycle events including assignment, limit changes, suspension, and closure activities                                                              |

## generalledger.prisma

// Original module name: generalLedger

Strategic purpose: Core financial accounting infrastructure with chart of accounts, fiscal period management, journal entries, and trial balance snapshots for statutory reporting.

Notes:

- Comprehensive chart of accounts supporting multi-dimensional segmentation and hierarchical organization.
- Fiscal year and period management with configurable calendars and closing procedures.
- Manual journal entry capabilities with approval workflows and audit trails.
- Approval workflows for journals are orchestrated through the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.) — no GL-specific approval tables.

| Model                  | Scope  | Parent | Description                                                                                                                                  |
|------------------------|--------|--------|----------------------------------------------------------------------------------------------------------------------------------------------|
| GLAccount              | Tenant | Yes    | Chart of accounts structure encompassing assets, liabilities, equity, revenue, and expense classifications with hierarchical organization   |
| GLAccountCategory      | Tenant | No     | High-level account groupings including Assets, Liabilities, Equity, Income, and Expense for financial statement organization                |
| GLAccountSegment       | Tenant | No     | Optional multi-dimensional segmentation supporting department, location, division, and project-based reporting requirements                 |
| GLFiscalYear           | Tenant | No     | Fiscal year boundary definitions with configurable start dates and closing procedures                                                       |
| GLFiscalPeriod         | Tenant | No     | Fiscal periods within years supporting monthly, 4-4-5, and custom calendar configurations with opening and closing controls                |
| GLJournal              | Tenant | Yes    | Manual journal entry containers for adjusting entries, accruals, and corrections, with approval routing via the central Approvals module   |
| GLJournalLine          | Tenant | No     | Individual debit and credit lines within journal entries with account allocation and dimensional analysis                                   |
| GLPostingBatch         | Tenant | No     | Transaction posting batches for controlled financial data processing and audit trail maintenance                                            |
| GLTrialBalanceSnapshot | Tenant | No     | Point-in-time trial balance captures for reporting, analysis, and audit preparation                                                         |
| GLHistoryEvent         | Tenant | No     | Comprehensive audit trail for chart of accounts modifications, period management, and journal entry activities                             |

## accountingtransaction.prisma

// Original module name: accountingTransaction

Strategic purpose: Universal transaction processing system normalizing all financial events including invoices, payments, journal entries, and allocations with comprehensive audit capabilities.

Notes:

- Unified transaction model supporting accounts receivable, accounts payable, inventory, payroll, and general ledger entries.
- Source document linkage maintaining traceability to originating business transactions.
- Multi-dimensional allocation support for cost center, department, and project accounting.
- Approval workflows for high-risk or high-value transactions are orchestrated through the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.), not a module-specific `TransactionApproval` table.

| Model                   | Scope  | Parent | Description                                                                                                                                  |
|-------------------------|--------|--------|----------------------------------------------------------------------------------------------------------------------------------------------|
| Transaction             | Tenant | Yes    | Universal financial event container representing all monetary activities including sales, purchases, payments, and adjustments             |
| TransactionLine         | Tenant | No     | Individual debit and credit components with account assignments and dimensional attributes                                                  |
| TransactionSourceLink   | Tenant | No     | Traceability links connecting transactions to source documents including invoices, purchase orders, and payroll runs                       |
| TransactionType         | Tenant | No     | Transaction categorization including Revenue, Accounts Payable, Accounts Receivable, Inventory Adjustments, and Payroll classifications    |
| TransactionBatch        | Tenant | No     | Grouping mechanism for related transactions processed together with batch-level controls and validation                                    |
| TransactionAttachment   | Tenant | No     | Supporting documentation including invoices, receipts, contracts, and approval evidence with version control                               |
| TransactionReversal     | Tenant | No     | Reversal entry management for error correction and period adjustments with audit trail preservation                                        |
| TransactionAllocation   | Tenant | No     | Cost distribution across multiple dimensions including departments, cost centers, projects, and locations                                  |
| TransactionHistoryEvent | Tenant | No     | Comprehensive audit trail capturing transaction lifecycle including creation, modification, approval routing, and posting activities       |

## banking.prisma

Strategic purpose: Bank account management with automated feed integration, reconciliation processing, and cash flow monitoring for comprehensive treasury operations.

Notes:

- Multi-bank connectivity through standardized APIs and file-based feeds with automated transaction import.
- Sophisticated reconciliation engine with rule-based matching and exception handling capabilities.
- Cash position monitoring and inter-account transfer management for optimal liquidity control.
- Approval workflows for sensitive operations (e.g., large `BankTransfer`) are orchestrated through the central **Approvals** module, not banking-specific approval tables.

| Model                  | Scope  | Parent | Description                                                                                                                                  |
|------------------------|--------|--------|----------------------------------------------------------------------------------------------------------------------------------------------|
| BankAccount            | Tenant | Yes    | Company bank account registry with account details, balances, and connectivity configuration for automated processing                      |
| BankTransaction        | Tenant | No     | Imported bank feed transactions with merchant details, amounts, and categorization for reconciliation processing                           |
| BankReconciliation     | Tenant | Yes    | Monthly reconciliation sessions linking bank statement items to ERP transactions with variance analysis                                    |
| BankReconciliationItem | Tenant | No     | Individual matching records between bank transactions and ERP entries with confidence scoring and manual override capabilities             |
| BankFeedConnection     | Tenant | No     | Integration connectivity configurations for Plaid, Stripe, ACH gateways, and direct bank APIs with authentication management              |
| BankStatement          | Tenant | No     | Monthly statement storage with metadata extraction and transaction detail preservation                                                      |
| BankRule               | Tenant | No     | Automated categorization and matching rules for recurring transactions and vendor identification                                           |
| BankTransfer           | Tenant | No     | Inter-account transfer records with linkage to approvals via the central Approvals module and cash flow impact tracking                    |
| BankDeposit            | Tenant | No     | Deposit documentation and batch processing with source transaction linkage and clearing management                                         |
| BankHistoryEvent       | Tenant | No     | Comprehensive audit trail for banking operations including account setup, reconciliation activities, and configuration changes             |

## taxcompliance.prisma

// Original module name: tax&AccountingCompliance

Strategic purpose: Tax jurisdiction management with automated rate calculation, liability tracking, filing preparation, and exemption certificate handling for comprehensive tax compliance.

Notes:

- Multi-jurisdictional tax rate management supporting state, county, and municipal tax authorities with automated updates.
- Sales tax liability calculation and reporting with automated filing preparation and submission capabilities.
- Exemption certificate management with validation workflows and compliance monitoring.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| TaxJurisdiction         | Tenant | No     | Tax authority definitions encompassing federal, state, county, and municipal jurisdictions with regulatory requirements                                                     |
| TaxRate                 | Tenant | No     | Current and historical tax rates by jurisdiction with effective date management and automatic rate update capabilities                                                      |
| TaxCode                 | Tenant | No     | Tax classification codes applied to products and services for automated tax calculation and compliance reporting                                                           |
| TaxRule                 | Tenant | No     | Business logic mapping products and services to tax codes with conditional application based on customer location and transaction type                                     |
| TaxLiability            | Tenant | No     | Accrued tax obligations by jurisdiction and period with automated calculation and adjustment capabilities                                                                   |
| TaxPayment              | Tenant | No     | Tax payment records to authorities with confirmation numbers, payment dates, and reconciliation to liability accounts                                                      |
| TaxReturn               | Tenant | No     | Filed tax return documentation with submission dates, amounts, and authority acknowledgment records                                                                        |
| TaxFilingAttachment     | Tenant | No     | Supporting documentation for tax filings including schedules, worksheets, and audit defense materials                                                                     |
| TaxExemptionCertificate | Tenant | No     | Customer exemption certificates with validation status, expiration tracking, and compliance verification workflows                                                         |
| TaxHistoryEvent         | Tenant | No     | Comprehensive audit trail for tax processing activities including rate changes, filing submissions, and compliance reviews                                                |

## hrcore.prisma

// Original module name: hrCore

Strategic purpose: Employee record management with comprehensive worker lifecycle, skills, documentation, and organizational structure maintenance.

Notes:

- `Employee` is the HR representation of an internal worker within a tenant and is always linked 1:1 to a `Member` of type INTERNAL.
- A single natural person may have multiple `Employee` records across tenants but only one global `User` in `identityCore`.
- HR data flows into time & attendance, payroll, safety, and compliance; it is not used directly for authentication or authorization.

| Model               | Scope  | Parent | Description |
|---------------------|--------|--------|-------------|
| Employee            | Tenant | Yes    | Master employee/worker record linked to a `Member` (INTERNAL) capturing personal data, identifiers, employment status, and primary HR attributes. |
| EmployeeAddress     | Tenant | No     | Managed addresses for employees (home, mailing, emergency) with effective dating and privacy flags. |
| EmployeeContact     | Tenant | No     | Contact channels (phone, email, emergency contacts) for HR and safety communication. |
| EmployeePosition    | Tenant | No     | Employee's position or job assignment within the organization, including effective dates and reporting relationships. |
| EmployeeDepartment  | Tenant | No     | Department / org unit assignments for employees, including cost center metadata and hierarchy references. |
| EmployeeCompensation| Tenant | No     | Compensation records for employees (base, overtime rules, allowances) feeding payroll and budget planning. |
| EmployeeStatus      | Tenant | No     | Employment status records (active, leave, terminated, seasonal) with reasons and effective periods. |
| EmployeeSkill       | Tenant | No     | Skills, certifications, and qualifications associated to employees with proficiency levels and expiry. |
| EmployeeDocument    | Tenant | No     | HR documents and attachments (contracts, compliance forms, licenses) linked to employees. |
| EmployeeHistoryEvent| Tenant | No     | Audited lifecycle events for employees (hire, promotion, pay change, leave, termination) with `Actor`/`Member` attribution. |

## payroll.prisma

// Original module name: payrollEngine

Strategic purpose: Comprehensive payroll processing system with earnings calculation, tax computation, benefits administration, and regulatory compliance capabilities.

Notes:

- Automated payroll run execution with multi-pay-period support and complex earning calculations.
- Integrated tax calculation supporting federal, state, and local tax obligations with automatic updates.
- Benefits administration with deduction management and direct deposit capabilities.
- Approval workflows for payroll runs are orchestrated through the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.), not payroll-specific approval tables.

| Model                | Scope  | Parent | Description                                                                                                                                 |
|----------------------|--------|--------|---------------------------------------------------------------------------------------------------------------------------------------------|
| PayrollRun           | Tenant | Yes    | Payroll cycle execution container managing pay period processing, calculation status, and approval routing via the central Approvals module with audit controls |
| PayrollEarning       | Tenant | No     | Individual earning components including regular wages, overtime, bonuses, commissions, and special payments with calculation rules and tax implications          |
| PayrollDeduction     | Tenant | No     | Payroll deductions including benefits, garnishments, retirement contributions, and voluntary deductions with regulatory compliance tracking                      |
| PayrollTax           | Tenant | No     | Tax calculations and withholdings by jurisdiction including federal, state, local, and FICA taxes with detailed breakdowns per employee                         |
| PayrollCalendar      | Tenant | No     | Pay period definitions supporting weekly, bi-weekly, semi-monthly, and monthly cycles with holiday and processing date management                                |
| PayrollBenefit       | Tenant | No     | Employee benefit configurations including health, dental, vision, retirement plans, and flexible spending accounts with enrollment and cost management          |
| PayrollGarnishment   | Tenant | No     | Court-ordered garnishments including child support, wage garnishments, and tax levies with calculation rules and compliance tracking                             |
| PayrollCheck         | Tenant | No     | Physical and electronic paycheck records with check numbers, payment amounts, and delivery method tracking                                                       |
| PayrollDirectDeposit | Tenant | No     | Direct deposit configurations and processing records with bank account information, split allocations, and transaction confirmations                            |
| PayrollHistoryEvent  | Tenant | No     | Comprehensive audit trail for payroll processing activities including run execution, corrections, and regulatory reporting                                       |

## timeattendance.prisma

// Original module name: time&attendance

Strategic purpose: Time tracking and attendance management with timesheet processing, overtime calculation, break monitoring, and location verification capabilities.

Notes:

- Digital timesheet management with project and cost code allocation for accurate job costing.
- GPS location tracking and geo-fencing for field employee time validation and compliance.
- Automated overtime calculation with break compliance monitoring.
- Timesheet approvals are handled via the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.), not a `TimesheetApproval` table.

| Model                | Scope  | Parent | Description                                                                                                                                   |
|----------------------|--------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| Timesheet            | Tenant | Yes    | Employee timesheet container organizing daily and weekly time entries with project allocation and approval status driven by the Approvals module |
| TimesheetEntry       | Tenant | No     | Individual time entries with start/end times, project assignments, cost codes, and work description with duration calculations                |
| TimesheetBreak       | Tenant | No     | Break period tracking for compliance with labor regulations including meal breaks, rest periods, and unpaid time classifications             |
| TimesheetOvertime    | Tenant | No     | Overtime calculation records with rate differentials and regulatory compliance tracking, including flags for entries requiring approval      |
| TimesheetGeoLocation | Tenant | No     | GPS location snapshots for time entry validation with coordinates, accuracy ratings, and geo-fence compliance verification                   |
| TimesheetSignature   | Tenant | No     | Digital signature records for employee and manager timesheet approvals with timestamp and authentication verification                        |
| TimesheetAdjustment  | Tenant | No     | Manual timesheet corrections and adjustments with reason codes, authorization levels, and audit trail preservation                           |
| TimesheetExport      | Tenant | No     | Export records for payroll and general ledger integration with batch processing status and reconciliation tracking                           |
| TimesheetHistoryEvent| Tenant | No     | Comprehensive audit trail for timesheet lifecycle including submissions, approvals, corrections, and system integrations                     |

## identity.prisma

// Original module name: identityCore

Strategic purpose: Foundational global identity system providing single sign-on across tenants, session management, personal API keys, and global-level profile/state.

Notes:

- `User` is global and never carries `tenantId`; a single person can belong to many tenants via `Member` records in the membership directory.
- All authentication flows (password, SSO, MFA) terminate at `User`; authorization is evaluated in **AccessControl** using `Member`/`ServiceAccount` and scopes.
- `Tenant` lifecycle and configuration is owned by the **tenant** module; `identityCore` only references tenants indirectly via membership.
- Platform-wide audit uses `Actor` to uniformly reference humans (`User`/`Member`) and non-humans (`ServiceAccount`).

| Model           | Scope  | Parent | Description |
|-----------------|--------|--------|-------------|
| Actor           | Global | Yes    | Canonical "who did it" identity used across audit/event tables, referencing either a `User`, a `Member`, or a `ServiceAccount`. |
| User            | Global | Yes    | Global authentication principal with login identifiers, credential state, verification flags, and base contact info. |
| Session         | Global | Yes    | Web/mobile/API session for a `User` with token identifiers, device hints, geo/IP, and linkage to an optional current `Member` context. |
| UserProfile     | Global | No     | Non-security global profile fields (display name, avatar, locale, time zone preferences) reused across tenants when tenant-specific overrides are absent. |
| UserSetting     | Global | No     | Key/value store for cross-tenant user feature flags and preferences that are not tenant-specific. |
| UserApiKey      | Global | Yes    | Personal access tokens linked to `User` and optionally pre-bound default `Member`/tenant contexts; further constrained by AccessControl scopes and roles. |
| UserInvitation  | Global | No     | Global invitations sent via email/phone, tracking source tenant, intended role/type, and mapping to one or more `Member` records when accepted. |
| UserHistoryEvent| Global | No     | Immutable history of major identity events: sign-ups, verification, merges, deactivation/reactivation, consent, and security-related changes. |

## membership.prisma

// Original module name: membershipDirectory

Strategic purpose: Tenant-level membership and directory of all internal and external participants. Bridges global `User` identities to tenants, HR employees, CRM accounts/contacts, vendors, and portal participants.

Notes:

- `Member` is the canonical representation of "a person (or external actor) inside a tenant" and is always tenant-scoped.
- Members can be INTERNAL (employees/staff), EXTERNAL_CLIENT (customers/owners), EXTERNAL_VENDOR (vendors/subcontractors), PARTNER, or GUEST.
- Every interactive action in a tenant should resolve to a `Member` (or `ServiceAccount`) for audit, RBAC, and scoping.
- HR and CRM modules link their person/company records back to `Member` to avoid duplicate login-centric entities.

| Model               | Scope  | Parent | Description |
|---------------------|--------|--------|-------------|
| Member              | Tenant | Yes    | Tenant-level membership linking a global `User` to a `Tenant`, including type (INTERNAL, EXTERNAL_CLIENT, EXTERNAL_VENDOR, PARTNER, GUEST), status, and primary org/project associations. |
| MemberSettings      | Tenant | No     | Per-tenant preferences for a `Member` (language, time zone, notification settings, default landing views) distinct from global `UserSetting`. |
| MemberInvitation    | Tenant | No     | Tenant-specific invitations that create or attach to a `Member`, capturing inviter, intended member type, and initial role suggestions. |
| MemberExternalLink  | Tenant | No     | Links a `Member` to domain entities such as `CRMAccount`, `CRMContact`, vendor/supplier records, or subcontractor companies to support external participant scenarios. |
| MemberDocument      | Tenant | No     | Documents tied to membership (NDAs, portal terms acceptance, identity verification artifacts) distinct from HR employment documents. |
| MemberHistoryEvent  | Tenant | No     | Audited membership lifecycle events (invited, joined, activated, role changes, disabled, removed) with `Actor` attribution. |

## identitysecurity.prisma

// Original module name: identitySecurity

Strategic purpose: Advanced security for global identity — MFA, SSO, device trust, recovery, and security events — layered on top of `identityCore` and reused across tenants.

Notes:

- All security artifacts attach to the global `User` (and `Actor`) rather than directly to tenant membership.
- Tenant-specific enforcement rules (e.g., required MFA level, allowed IdPs) are configured through AccessControl policies and membership configuration.
- Supports passwordless, WebAuthn, TOTP, SMS/email MFA, and federated SSO (OIDC/SAML).

| Model                | Scope  | Parent | Description |
|----------------------|--------|--------|-------------|
| IdentityProvider     | Global | Yes    | Global catalog of supported identity providers (OIDC/SAML) including metadata, endpoints, certificates, and capabilities. |
| TenantIdentityProvider| Tenant| No     | Tenant-specific SSO bindings linking a `Tenant` to one or more `IdentityProvider` entries with domain rules, provisioning modes, and enforcement flags. |
| AuthFactor           | Global | Yes    | MFA factor registered for a `User` (TOTP, WebAuthn, SMS, email, push) with status, device binding, and last-used metadata. |
| AuthFactorChallenge  | Global | No     | Individual MFA challenge attempt including factor used, context, result, risk score, and correlation IDs. |
| PasswordResetToken   | Global | No     | Password/credential reset tokens with expiry, one-time use semantics, anti-phishing metadata, and linkage to the requesting `Actor`. |
| AccountLockout       | Global | No     | Lockout state and counters for a `User` based on failed authentications, risk signals, or administrative action. |
| SecurityEvent        | Global | No     | High-volume security event log capturing sign-ins, factor enrollments, device changes, anomalous activity, and admin actions. |
| SSOSession           | Global | No     | Federated sign-in session with external identity providers, token state, and correlation with core `Session` records. |
| RecoveryCode         | Global | No     | Offline MFA recovery codes for a `User`, stored hashed with usage tracking and regeneration history. |
| UserDevice           | Global | Yes    | Known device fingerprints and trust state for a `User` with risk scores, last-seen metadata, and linkages to `SecurityEvent` records. |
| UserDeviceHistory    | Global | No     | History of device usage and trust-level changes used for anomaly detection and investigations. |

## integrationsCore.prisma

Strategic purpose: External system integration management providing connection orchestration, data mapping, field transformation, and comprehensive error handling for seamless third-party connectivity.

Notes:

- Comprehensive integration provider catalog with OAuth token management and secure credential storage.
- Flexible data mapping and field transformation engine supporting complex business logic and data conversion rules.
- Robust error handling and connection monitoring with automated retry mechanisms and audit capabilities.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IntegrationConnection   | Tenant | Yes    | Active connections to external services with provider configuration, credential management, scope definitions, and connection status monitoring                          |
| IntegrationProvider     | Tenant | No     | External service provider catalog including Stripe, QuickBooks, Google Workspace, Microsoft 365, and custom API endpoints with capability definitions                   |
| IntegrationOAuthToken   | Tenant | No     | OAuth authentication tokens with refresh capabilities, scope management, and automatic renewal for maintaining persistent connections                                     |
| IntegrationApiKey       | Tenant | No     | Secure API key storage with encryption, rotation capabilities, and usage monitoring for services requiring API key authentication                                        |
| IntegrationMapping      | Tenant | No     | Data mapping configurations linking ERP entities to external system objects with field-level mapping and transformation rules                                            |
| IntegrationFieldTransform| Tenant | No    | Field transformation rules including data type conversion, formatting, concatenation, conditional logic, and validation for seamless data exchange                      |
| IntegrationEvent        | Tenant | No     | Internal event generation for triggering synchronization processes with payload definition and routing configurations                                                     |
| IntegrationError        | Tenant | No     | Integration error tracking including authentication failures, mapping errors, API timeouts, and data validation issues with resolution workflows                        |
| IntegrationAttachment   | Tenant | No     | Integration-related file storage including API payloads, response logs, configuration snapshots, and debugging artifacts                                                 |
| IntegrationConnectionHistory| Tenant | No   | Connection lifecycle audit trail including establishment, reconnection, token refresh, and configuration changes with troubleshooting support                           |

## integrationsSyncEngine.prisma

Strategic purpose: Real-time synchronization engine managing bidirectional data flows, webhook processing, queue management, and automated retry mechanisms for reliable system integration.

Notes:

- Asynchronous job processing with comprehensive logging and status tracking for batch and real-time synchronization scenarios.
- Webhook management supporting both outbound notifications and inbound event processing with delivery guarantees.
- Intelligent retry policies with rate limiting, exponential backoff, and failure escalation for maximum reliability.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IntegrationSyncJob      | Tenant | Yes    | Synchronization job execution container managing batch processing, status tracking, and completion workflows with error recovery                                         |
| IntegrationSyncLog      | Tenant | No     | Detailed synchronization execution logs with success/failure status, data volumes, processing times, and error diagnostics                                               |
| IntegrationWebhook      | Tenant | Yes    | Outbound webhook configuration and management for notifying external systems of ERP events with payload customization and delivery tracking                             |
| IntegrationWebhookDelivery| Hybrid | No   | Webhook delivery attempt tracking with HTTP response codes, retry attempts, and failure analysis for ensuring reliable event notification                               |
| IntegrationInboundWebhook| Tenant | No    | Inbound webhook processing for receiving events from external systems with validation, routing, and processing status tracking                                           |
| IntegrationQueueItem    | Tenant | No     | Synchronization queue management with FIFO processing, priority handling, and dead letter queue support for failed items                                                |
| IntegrationRateLimit    | Tenant | No     | Rate limiting enforcement per provider with quota tracking, reset timers, and throttling mechanisms to prevent API abuse                                                |
| IntegrationRetryPolicy  | Tenant | No     | Retry policy definitions with exponential backoff, maximum attempt limits, and failure escalation rules for robust error handling                                       |
| IntegrationSchemaVersion| Tenant | No     | Schema version management for API endpoints and data mappings with backward compatibility and migration support                                                          |
| IntegrationHistoryEvent | Tenant | No     | Comprehensive audit trail for synchronization engine activities including job execution, webhook processing, and system health monitoring                               |

## inventoryCore.prisma

Strategic purpose: Master inventory data management providing item cataloging, location hierarchy, stock level tracking, and supplier relationship management for comprehensive inventory control.

Notes:

- Comprehensive item master data with categorization, specifications, and multi-unit-of-measure support for diverse inventory types.
- Hierarchical location management supporting warehouses, bins, mobile locations, and job sites with flexible organization structures.
- Supplier relationship management with preferred vendor tracking, pricing history, and procurement optimization capabilities.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| InventoryItem           | Tenant | Yes    | Master item catalog with SKU management, specifications, part numbers, weight, dimensions, and unit-of-measure definitions                                                |
| InventoryCategory       | Tenant | No     | Item categorization taxonomy supporting hierarchical classification for lumber, electrical, tools, plumbing, HVAC, and consumable materials                             |
| InventoryLocation       | Tenant | Yes    | Storage location hierarchy including warehouses, job sites, trucks, trailers, containers, and rooms with address and capacity information                               |
| InventoryBin            | Tenant | No     | Sub-location definitions within primary locations including shelves, racks, zones, and specific storage positions with capacity and accessibility controls              |
| InventoryUnitOfMeasure  | Tenant | No     | Unit-of-measure registry supporting each, feet, yards, pounds, gallons, boxes, pallets, and custom units with conversion factors                                        |
| InventoryStock          | Tenant | No     | Real-time stock level tracking by item and location with quantity on-hand, committed, reserved, and available calculations                                               |
| InventorySupplier       | Tenant | No     | Supplier registry for procurement management with contact information, terms, and performance tracking capabilities                                                       |
| InventoryItemVendor     | Tenant | No     | Item-specific vendor relationships with preferred supplier rankings, vendor part numbers, pricing agreements, and lead time information                                  |
| InventoryAttachment     | Tenant | No     | Item documentation including product images, specification sheets, safety data sheets, installation manuals, and warranty information                                    |
| InventoryHistoryEvent   | Tenant | No     | Comprehensive audit trail for inventory master data changes including item creation, updates, location modifications, and supplier relationship changes                  |

## inventoryTransactions.prisma

Strategic purpose: Comprehensive inventory movement tracking system managing all stock transactions including adjustments, transfers, receipts, returns, and cycle counts with complete audit trails.

Notes:

- Universal transaction framework supporting inbound receipts, outbound issues, location transfers, and manual adjustments with flexible transaction types.
- Multi-location transfer capabilities supporting warehouse-to-jobsite movements with in-transit tracking and delivery confirmation.
- Integrated cycle counting with variance analysis, investigation workflows, and automatic stock adjustments for inventory accuracy.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| InventoryTransaction    | Tenant | Yes    | Universal inventory movement container supporting inbound, outbound, transfer, and adjustment transactions with comprehensive tracking                                    |
| InventoryTransactionLine| Tenant | No     | Individual transaction line items with item identification, quantities, locations, bins, unit costs, and transaction reason codes                                        |
| InventoryAdjustment     | Tenant | No     | Manual inventory adjustments for shrinkage, damage, corrections, and write-offs with authorization levels and supporting documentation                                    |
| InventoryTransfer       | Tenant | Yes    | Inter-location transfer management for warehouse-to-jobsite, truck-to-truck, and facility-to-facility movements with shipment tracking                                  |
| InventoryTransferLine   | Tenant | No     | Transfer line items with item details, quantities, source and destination locations, and delivery status tracking                                                        |
| InventoryReturn         | Tenant | Yes    | Return transaction management for defective items, overstock, and vendor returns with reason codes and condition assessments                                             |
| InventoryReturnLine     | Tenant | No     | Return line items with item identification, return quantities, condition codes, and disposition instructions for restocking or disposal                                  |
| InventoryCount          | Tenant | Yes    | Physical inventory count sessions including cycle counts, annual counts, and spot counts with count team assignments and scheduling                                      |
| InventoryCountLine      | Tenant | No     | Count line items with expected versus actual quantities, variance analysis, and investigation triggers for significant discrepancies                                     |
| InventoryTransactionHistory| Tenant | No   | Comprehensive audit trail for all inventory movements with user attribution, timestamps, system integration, and compliance reporting                                    |

## inventoryControl.prisma

Strategic purpose: Advanced inventory control system providing loss prevention, audit management, reservation control, and automated reordering for zero-loss inventory management and operational efficiency.

Notes:

- Proactive loss prevention with investigation workflows, root cause analysis, and corrective action tracking for shrinkage reduction.
- Comprehensive audit capabilities with variance analysis, discrepancy investigation, and accountability measures for inventory accuracy.
- Intelligent inventory planning with safety stock management, reorder point automation, and demand forecasting integration.

| Model                   | Scope  | Parent | Description |
|----------------------   |--------|--------|-------------|
| InventoryLossEvent      | Tenant | Yes    | Loss incident documentation for missing, stolen, damaged, or obsolete inventory with impact assessment and recovery tracking                                              |
| InventoryLossCause      | Tenant | No     | Root cause classification for inventory losses including theft, misplacement, damage, spoilage, and administrative errors with prevention strategies                     |
| InventoryLossInvestigation| Tenant | No   | Investigation management with assigned investigators, findings documentation, responsible party identification, and corrective action implementation                       |
| InventoryAudit          | Tenant | Yes    | Comprehensive inventory audit sessions with scope definition, team assignments, and compliance verification for accuracy assurance                                       |
| InventoryAuditLine      | Tenant | No     | Audit line item results with count verification, condition assessment, location validation, and exception reporting for detailed analysis                                |
| InventoryReservation    | Tenant | No     | Item reservation management for projects, work orders, and purchase commitments with allocation tracking and release mechanisms                                          |
| InventoryCommitment     | Tenant | No     | Committed inventory allocation to specific jobs, tasks, or customers with delivery scheduling and fulfillment tracking                                                   |
| InventoryReorderPoint   | Tenant | No     | Automated reordering threshold management with demand analysis, lead time consideration, and supplier integration for optimal stock levels                              |
| InventorySafetyStock    | Tenant | No     | Minimum stock level definitions with seasonal adjustments, demand variability analysis, and service level target maintenance                                            |
| InventoryControlHistory | Tenant | No     | Control system audit trail including alert generation, threshold modifications, investigation activities, and compliance reporting for continuous improvement             |

## invoice.prisma

Strategic purpose: Comprehensive billing and accounts receivable system with multi-billing methods, payment tracking, credit management, and automated collection capabilities.

Notes:

- Flexible billing approaches including progress billing, milestone-based invoicing, and retainage management for construction projects.
- Advanced payment application with partial payments, credits, debits, and adjustment tracking for complete financial reconciliation.
- Automated collection workflows with reminder systems, public payment links, and comprehensive approval processes.
- Invoice approvals (when required) are orchestrated through the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.), not invoice-specific approval tables.

| Model                    | Scope  | Parent | Description                                                                                                                                 |
|--------------------------|--------|--------|---------------------------------------------------------------------------------------------------------------------------------------------|
| Invoice                  | Hybrid | Yes    | Master billing document with customer information, amounts, terms, status, and comprehensive payment tracking capabilities                 |
| InvoiceLineItem          | Tenant | No     | Individual billing line items for labor, materials, equipment, and subcontract work with quantity, rate, and extended amount calculations |
| InvoiceTax               | Tenant | No     | Tax calculations applied to invoice with jurisdiction-specific rates, exemptions, and compliance reporting requirements                    |
| InvoiceDiscount          | Tenant | No     | Discount applications including early payment discounts, volume discounts, and promotional reductions, with optional approval routing via the Approvals module |
| InvoiceFee               | Tenant | No     | Additional charges and fees applied to invoices including late fees, processing charges, and administrative costs                          |
| InvoiceRetainage         | Tenant | No     | Construction retainage management with percentage calculations, release schedules, and compliance with contractual retention requirements  |
| InvoiceProgress          | Tenant | No     | Progress billing support with percentage completion calculations, earned value tracking, and milestone-based billing capabilities          |
| InvoiceMilestone         | Tenant | No     | Milestone-based billing with predefined payment schedules, deliverable completion tracking, and automated invoice generation              |
| InvoicePaymentApplication| Tenant | No     | Payment allocation records linking received payments to specific invoices with partial payment handling and cash application tracking      |
| InvoiceAttachment        | Tenant | No     | Supporting documentation including timesheets, photos, receipts, labor records, and customer signatures with version control              |
| InvoiceComment           | Tenant | No     | Internal comments and customer communication threads with timestamp tracking and collaboration capabilities                               |
| InvoiceRevision          | Tenant | No     | Invoice revision tracking with version history, change documentation, and audit trail preservation for billing transparency               |
| InvoiceAdjustment        | Tenant | No     | Post-invoice adjustments including corrections, additions, and modifications, with optional approval requirements via the Approvals module and financial impact tracking |
| InvoiceCredit            | Tenant | No     | Credit memo management for refunds, rework, errors, and customer satisfaction adjustments with accounts receivable impact                 |
| InvoiceDebit             | Tenant | No     | Debit memo processing for additional charges, corrections, and supplemental billing with customer notification and optional approval workflows via the Approvals module |
| InvoiceHistory           | Tenant | No     | Comprehensive activity timeline including creation, delivery, payment, disputes, and resolution with stakeholder attribution              |
| InvoicePublicLink        | Tenant | No     | Secure public access URLs enabling customer invoice review, approval, and online payment without system access requirements               |
| InvoiceReminder          | Tenant | No     | Automated collection and reminder system with escalating communication schedules, dunning processes, and customer relationship management |

## jobCosting.prisma

Strategic purpose: Project-based cost accounting system providing real-time cost tracking, budget management, forecasting, and profitability analysis with industry-standard cost code integration.

Notes:

- CSI MasterFormat compatible cost coding system supporting standardized construction and service industry cost classifications.
- Real-time cost capture and allocation across labor, materials, equipment, and subcontract categories with budget variance analysis.
- Comprehensive forecasting capabilities with cost-to-complete projections and profitability optimization recommendations.
- Budget and major cost changes can be gated by the central **Approvals** module when required (no job-cost-specific approval tables).

| Model               | Scope  | Parent | Description                                                                                                                                      |
|---------------------|--------|--------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| CostCode            | Tenant | Yes    | Standardized cost code hierarchy supporting CSI MasterFormat classifications with custom extensions for industry-specific requirements          |
| CostCategory        | Tenant | No     | High-level cost categorization including labor, materials, equipment, subcontract, and overhead with reporting and analysis groupings           |
| CostType            | Tenant | No     | Cost classification types distinguishing between budgeted, committed, actual, and forecasted costs for comprehensive financial analysis         |
| CostCenter          | Tenant | No     | Organizational cost allocation points including departments, divisions, and profit centers for cross-project cost distribution                  |
| JobCostLedger       | Tenant | Yes    | Master cost ledger containing all project-related financial transactions with real-time cost accumulation and reporting capabilities            |
| JobCostLine         | Tenant | No     | Individual cost transaction records with detailed allocation information including quantities, rates, extended amounts, and cost code assignments |
| JobCostBudget       | Tenant | Yes    | Project budget container with original budget, approved changes, and current budget tracking for comprehensive financial planning               |
| JobCostBudgetLine   | Tenant | No     | Budget line items by cost code with quantity and amount budgets, variance tracking, and optional approval routing via the central Approvals module |
| JobCostForecast     | Tenant | No     | Cost-to-complete forecasting with projected final costs, variance analysis, and profitability projections for proactive project management      |
| JobCostHistoryEvent | Tenant | No     | Comprehensive audit trail for cost transactions, budget modifications, and forecast updates with user attribution and change documentation      |

## maintenanceService.prisma

Strategic purpose: Subscription-based service contract management with recurring maintenance scheduling, automated billing, customer retention, and service delivery optimization.

Notes:

- Flexible service contract templates supporting monthly, seasonal, and custom recurring schedules with automated task generation.
- Integrated payment processing with stored payment methods, automatic renewal management, and subscription billing capabilities.
- Customer retention tools including cancellation management, renewal optimization, and service quality tracking.
- Any required approvals (e.g., high-value contracts, price changes, cancellations with financial impact) are handled through the central **Approvals** module.

| Model                       | Scope  | Parent | Description                                                                                                                                         |
|----------------------------|--------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| ServiceContract            | Tenant | Yes    | Master service contract entity with customer agreements, terms, pricing, and recurring service schedule management                                 |
| ServiceContractPlan        | Tenant | No     | Service contract templates defining standard offerings including monthly, bi-annual, and seasonal maintenance plans with pricing and task definitions |
| ServiceContractSchedule    | Tenant | No     | Recurring service scheduling with frequency rules, next service dates, and automated appointment generation for proactive maintenance delivery     |
| ServiceContractTask        | Tenant | No     | Predefined maintenance tasks for each service visit including inspections, cleaning, replacements, and testing with completion tracking             |
| ServiceContractPricing     | Tenant | No     | Contract pricing structures with tiered pricing, discounts, promotional rates, and escalation schedules for revenue optimization                    |
| ServiceContractPaymentMethod| Tenant | No    | Stored payment methods including credit cards and ACH accounts with tokenization, expiration tracking, and payment processing integration           |
| ServiceContractRenewal     | Tenant | No     | Contract renewal management with automatic renewal settings, notification schedules, and optional approval workflows orchestrated via the Approvals module |
| ServiceContractCancelation | Tenant | No     | Contract cancellation processing with reason tracking, retention offers, and financial settlement procedures                                        |
| ServiceContractNotification| Tenant | No     | Automated customer communication including service reminders, renewal notices, and payment notifications via email and SMS                          |
| ServiceContractHistoryEvent| Tenant | No     | Comprehensive contract lifecycle tracking including creation, modifications, renewals, cancellations, and service delivery history                  |

## notifications.prisma

Strategic purpose: Enterprise notification system providing multi-channel alert delivery, user preference management, automated notification rules, and comprehensive delivery tracking across all business processes.

Notes:

- Multi-channel delivery supporting email, SMS, push notifications, and in-app alerts with user preference management and delivery optimization.
- Rule-based notification automation with trigger conditions, template management, and intelligent routing for business process integration.
- Comprehensive delivery tracking with retry mechanisms, failure handling, and performance analytics for reliable communication.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Notification            | Hybrid | Yes    | Master notification entity with message content, recipient information, delivery channel specifications, and status tracking                                             |
| NotificationPreference  | Tenant | No     | User notification preferences including channel selection, frequency settings, digest options, and do-not-disturb schedules                                             |
| NotificationChannel     | Tenant | No     | Delivery channel definitions including email, SMS, push notifications, and in-app alerts with configuration and capability management                                    |
| NotificationTemplate    | Tenant | No     | Reusable message templates with variable substitution, multi-language support, and content versioning for consistent communication                                       |
| NotificationDelivery    | Tenant | No     | Delivery attempt tracking with status updates, retry counts, failure reasons, and delivery confirmation for comprehensive audit trails                                   |
| NotificationDigest      | Tenant | No     | Digest notification management with daily and weekly summaries, content aggregation, and personalized delivery scheduling                                                |
| NotificationRule        | Tenant | No     | Automated notification triggers with condition evaluation, business rule integration, and escalation procedures for proactive communication                             |
| NotificationQueueItem   | Tenant | No     | Notification delivery queue management with priority handling, batch processing, and retry scheduling for reliable message delivery                                      |
| NotificationAttachment  | Tenant | No     | Notification file attachments including images, PDFs, and reports with secure delivery and access control                                                               |
| NotificationHistoryEvent| Tenant | No    | Comprehensive notification lifecycle tracking including creation, delivery attempts, user interactions, and system performance analytics                                 |

## paymentsARCashApplication.prisma

Strategic purpose: Comprehensive payment processing and accounts receivable management system with multi-gateway support, cash application, reconciliation, and dispute resolution capabilities.

Notes:

- Multi-payment method support including credit cards, ACH, checks, wire transfers, and cash with gateway integration.
- Advanced cash application with partial payment handling, unapplied credit management, and comprehensive reconciliation workflows.
- Integrated dispute management with chargeback handling, refund processing, and payment gateway transaction tracking.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Payment                 | Tenant | Yes    | Master payment record with customer information, amount, payment method, status tracking, and comprehensive audit capabilities                                            |
| PaymentMethod           | Tenant | No     | Payment method configurations including credit cards, ACH accounts, checks, wire transfers, and cash with tokenization and security features                             |
| PaymentGatewayTransaction| Tenant | No    | Gateway transaction records from Stripe, Authorize.net, Square, PayPal with transaction IDs, status, and response data                                                   |
| PaymentApplication      | Tenant | No     | Line-level payment application to invoices supporting partial payments, overpayments, and complex allocation scenarios                                                   |
| PaymentUnapplied        | Tenant | No     | Unapplied payment balance tracking for open credits, overpayments, and future invoice application with aging and management                                               |
| PaymentRefund           | Tenant | No     | Refund transaction management including chargebacks, reversals, and customer refunds with gateway integration and status tracking                                         |
| PaymentReconciliation   | Tenant | No     | Bank reconciliation for received payments with matching algorithms, variance analysis, and automated clearing processes                                                   |
| PaymentDispute          | Tenant | No     | Dispute management for credit card chargebacks, ACH returns, and payment challenges with resolution tracking and documentation                                           |
| PaymentAttachment       | Tenant | No     | Payment supporting documentation including receipts, check images, authorization forms, and transaction confirmations                                                     |
| PaymentHistoryEvent     | Tenant | No     | Comprehensive payment lifecycle audit trail including receipt, application, reversal, refund, and dispute activities with stakeholder attribution                      |

## procurementPo.prisma

Strategic purpose: Complete procurement lifecycle management from requisition through purchase order execution, receipt verification, and vendor payment integration with comprehensive approval workflows.

Notes:

- End-to-end procurement process supporting requisitions, purchase orders, receipts, and returns.
- Multi-level approvals for requisitions and POs are orchestrated via the central **Approvals** module (`ApprovalRequest`, `ApprovalDecision`, etc.), not mediante tablas específicas de procurement.
- Vendor management integration with purchase order tracking, delivery confirmation, and cost impact analysis for project budgeting.
- Comprehensive receipt verification with quantity matching, quality control, and automated invoice processing integration.

| Model                    | Scope  | Parent | Description                                                                                                                                         |
|--------------------------|--------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| PurchaseOrder            | Tenant | Yes    | Master purchase order entity with vendor information, terms, delivery requirements, and comprehensive status tracking capabilities                  |
| PurchaseOrderLineItem    | Tenant | No     | Purchase order line items with materials, equipment, services, and subcontract details including quantities, pricing, and delivery specifications  |
| PurchaseRequisition      | Tenant | Yes    | Internal purchase requisition for materials and services with budgeting context and linkage to approval workflows managed by the central Approvals module |
| PurchaseRequisitionItem  | Tenant | No     | Requisition line items with detailed specifications, quantities, preferred vendors, and budget allocation information                               |
| PurchaseOrderReceipt     | Tenant | Yes    | Goods received documentation with delivery verification, quantity confirmation, and quality inspection results                                      |
| PurchaseOrderReceiptItem | Tenant | No     | Receipt line items with received quantities, condition assessment, variance analysis, and acceptance or rejection decisions                         |
| PurchaseOrderReturn      | Tenant | No     | Return merchandise authorization with return reasons, vendor coordination, and credit or replacement tracking                                       |
| PurchaseOrderAttachment  | Tenant | No     | Purchase order documentation including vendor invoices, packing slips, delivery receipts, photos, and specification documents                      |
| PurchaseOrderHistoryEvent| Tenant | No     | Comprehensive audit trail for purchase order lifecycle including creation, approval routing via Approvals, transmission, receipt, invoicing, and payment activities |

## projectsCore.prisma

Strategic purpose: Master project management system providing project definition, phase management, team coordination, budget control, and comprehensive project lifecycle tracking.

Notes:

- Hierarchical project organization with phases, milestones, and location-based work breakdown for comprehensive project structure.
- Integrated team management with role-based assignments, responsibility tracking, and collaboration capabilities.
- Master budget control with line-item detail, change management, and real-time cost tracking integration.
- Any required approvals (e.g., project creation, major budget changes, milestone sign-offs) are handled via the central **Approvals** module.

| Model                 | Scope  | Parent | Description                                                                                                                                 |
|-----------------------|--------|--------|---------------------------------------------------------------------------------------------------------------------------------------------|
| Project               | Hybrid | Yes    | Master project entity with scope definition, financial tracking, stakeholder information, and comprehensive lifecycle management capabilities |
| ProjectPhase          | Tenant | No     | High-level project phases including pre-construction, execution, finishing, and closeout with milestone integration and progress tracking   |
| ProjectMilestone      | Tenant | No     | Critical project deliverables and checkpoints with date tracking, completion criteria, and optional approval routing via the Approvals module |
| ProjectTeamMember     | Tenant | No     | Project team assignments including project managers, superintendents, estimators, engineers, and field personnel with role-based access control |
| ProjectLocation       | Tenant | No     | Geographic and spatial project organization including buildings, floors, zones, and units with hierarchical location management            |
| ProjectBudget         | Tenant | Yes    | Master project budget container with original budget, approved changes, and current budget tracking for comprehensive financial control    |
| ProjectBudgetLineItem | Tenant | No     | Detailed budget line items by cost category with quantity and cost tracking, variance analysis, and change order integration               |
| ProjectDocument       | Tenant | No     | Project-level document management including contracts, specifications, permits, and regulatory documentation with version control          |
| ProjectAttachment     | Tenant | No     | Project file management including drawings, photos, reports, and reference materials with categorization and access control               |
| ProjectHistoryEvent   | Tenant | No     | Comprehensive project audit trail capturing all project-level changes, decisions, and milestone achievements with stakeholder attribution |

## projectTaskScheduling.prisma

Strategic purpose: Advanced project scheduling and task management system with dependency tracking, critical path analysis, and resource optimization for efficient project execution.

Notes:

- Comprehensive task management with assignment tracking, dependency management, and critical path analysis for schedule optimization.
- Gantt chart and timeline management with baseline tracking, schedule variance analysis, and automated scheduling updates.
- Resource allocation and task assignment with workload balancing and collaboration features for team coordination.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ProjectTask             | Tenant | Yes    | Individual work items with scope definition, duration estimates, resource requirements, and completion tracking capabilities                                              |
| ProjectTaskAssignment   | Tenant | No     | Task assignment management with worker allocation, responsibility definition, and workload tracking for resource optimization                                             |
| ProjectTaskDependency   | Tenant | No     | Task relationship management with predecessor/successor logic, constraint types, and critical path impact analysis                                                       |
| ProjectSchedule         | Tenant | Yes    | Master project schedule container with timeline management, milestone integration, and schedule optimization capabilities                                                 |
| ProjectScheduleItem     | Tenant | No     | Individual schedule elements representing Gantt chart bars with start/end dates, duration, and progress tracking                                                         |
| ProjectCriticalPath     | Tenant | No     | Critical path analysis with task flagging, schedule impact assessment, and optimization recommendations for project acceleration                                          |
| ProjectBaseline         | Tenant | No     | Saved schedule baselines for variance analysis, change tracking, and schedule performance measurement against original plans                                              |
| ProjectChecklistItem    | Tenant | No     | Task completion checklists with requirement definitions, completion criteria, and quality assurance integration                                                          |
| ProjectTaskComment      | Tenant | No     | Task-level communication and collaboration with threaded discussions, status updates, and stakeholder coordination                                                       |
| ProjectTaskAttachment   | Tenant | No     | Task-specific documentation including photos, drawings, specifications, and reference materials with version control and access management                               |

## projectRisk.prisma

Strategic purpose: Project risk management and daily logging system providing risk assessment, issue tracking, decision documentation, and comprehensive project activity recording.

Notes:

- Proactive risk management with impact assessment, mitigation planning, and continuous monitoring for project success.
- Comprehensive daily logging with labor, equipment, and material tracking for accurate project documentation and cost control.
- Decision tracking and issue management with resolution workflows and stakeholder accountability for project governance.
- When a risk, issue, or decision requires formal approval (e.g., high-impact mitigation plans), routing is handled via the central **Approvals** module (ApprovalRequest, ApprovalDecision, etc.), not via module-specific approval tables.

| Model                    | Scope  | Parent | Description                                                                                                                                  |
|--------------------------|--------|--------|----------------------------------------------------------------------------------------------------------------------------------------------|
| ProjectRisk              | Tenant | No     | Risk identification and assessment with impact analysis, probability ratings, mitigation strategies, and continuous monitoring capabilities |
| ProjectIssue             | Tenant | No     | Issue tracking and resolution management with priority assignment, owner responsibility, and escalation procedures for project obstacle removal |
| ProjectDecision          | Tenant | No     | Formal decision documentation including RFI responses, change approvals, and management decisions with authority attribution and impact analysis |
| ProjectDailyLog          | Tenant | Yes    | Daily project activity logging with weather conditions, work performed, issues encountered, and progress documentation                      |
| ProjectDailyLogLabor     | Tenant | No     | Daily labor tracking with crew assignments, hours worked, productivity metrics, and cost code allocation for accurate job costing           |
| ProjectDailyLogEquipment | Tenant | No     | Daily equipment usage logging with equipment identification, hours operated, maintenance needs, and cost allocation tracking                |
| ProjectDailyLogMaterial  | Tenant | No     | Daily material tracking with deliveries received, quantities used, waste documentation, and inventory impact for material management       |
| ProjectDailyLogPhoto     | Tenant | No     | Daily photo documentation with progress photos, issue documentation, safety observations, and quality verification images                   |
| ProjectProgress          | Tenant | No     | Project progress tracking with percentage completion updates, milestone achievement, and schedule performance measurement                   |
| ProjectNote              | Tenant | No     | General project notes and observations with categorization, stakeholder communication, and historical reference capabilities                |

## quality.prisma

Strategic purpose: Comprehensive quality management system providing inspection workflows, non-conformance tracking, corrective action management, and material testing integration for project quality assurance.

Notes:

- Structured inspection processes with checklist management, pass/fail tracking, and photographic documentation for quality verification.
- Non-conformance management with corrective action tracking, responsibility assignment, and resolution verification for continuous improvement.
- Material testing integration with lab results, compliance verification, and specification adherence for construction quality standards.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| QualityInspection       | Tenant | Yes    | Formal inspection events including pre-construction, progress, and final inspections with comprehensive checklist management and result tracking                         |
| QualityInspectionItem   | Tenant | No     | Individual inspection checklist items with pass/fail status, photographic evidence, notes, and corrective action requirements                                            |
| QualityNonConformance   | Tenant | Yes    | Non-conformance incident tracking for workmanship issues, specification deviations, and code violations with impact assessment and resolution management                 |
| QualityNonConformanceAction| Tenant | No   | Corrective action management with task assignments, deadlines, responsible parties, and completion verification for quality issue resolution                             |
| QualityPunchListItem    | Tenant | No     | Project closeout punch list management with item identification, responsibility assignment, completion tracking, and customer sign-off integration                       |
| QualityMaterialTest     | Tenant | No     | Material testing coordination including concrete strength tests, compaction verification, and system performance testing with scheduling and result tracking            |
| QualityMaterialTestResult| Tenant | No    | Test result documentation with laboratory data, field measurements, pass/fail determinations, and compliance verification against specifications                         |
| QualityStandard         | Tenant | No     | Quality standards and reference documentation including installation standards, specification sections, and regulatory code references                                    |
| QualityAttachment       | Tenant | No     | Quality-related documentation including inspection photos, test reports, certificates, and reference drawings with categorization and access control                     |
| QualityInspectionHistory| Tenant | No     | Comprehensive audit trail for quality activities including inspection results, decision changes, and corrective action completion with stakeholder attribution          |

## RFI.prisma

Strategic purpose: Request for Information management system facilitating communication between field, office, architecture, and engineering teams with comprehensive question tracking and resolution workflows.

Notes:

- Structured RFI workflow supporting question submission, response management, and impact assessment with stakeholder coordination.
- Integration with change orders, submittals, and document management for comprehensive project communication tracking.
- Multi-disciplinary support with category management, priority handling, and automated notification systems.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RFI                     | Hybrid | Yes    | Master RFI entity with question details, responsible parties, discipline classification, priority assignment, and comprehensive status tracking                          |
| RFIQuestion             | Tenant | No     | Detailed question text with context information, referenced documents, and scope clarification for accurate response preparation                                         |
| RFIResponse             | Tenant | No     | Formal response from architects, engineers, or general contractors with potential impacts on change orders, submittals, and schedule adjustments                        |
| RFIAttachment           | Tenant | No     | Supporting documentation including photos, drawings, PDFs, sketches, and reference materials for comprehensive communication                                             |
| RFIComment              | Tenant | No     | Internal conversation management with threaded discussions, stakeholder coordination, and decision documentation                                                         |
| RFIStatus               | Tenant | No     | Configurable status definitions including Open, Pending, Answered, and Closed with workflow progression tracking                                                        |
| RFICategory             | Tenant | No     | Discipline categorization including Structural, MEP, Architectural, Electrical with specialized routing and expertise assignment                                         |
| RFIImpact               | Tenant | No     | Impact assessment declarations including cost implications, scope changes, and schedule effects for project planning integration                                         |
| RFIRecipient            | Tenant | No     | Recipient management for RFI distribution with role-based access, notification preferences, and stakeholder accountability                                              |
| RFIHistoryEvent         | Tenant | No     | Comprehensive timeline tracking including submission, review, response, and closure activities with complete audit trail and stakeholder attribution                   |

## roomModel.prisma

Strategic purpose: Digital twin room modeling system providing automated geometry extraction, surface analysis, item detection, and takeoff generation for accurate estimating and project planning.

Notes:

- Comprehensive room geometry modeling with walls, openings, surfaces, and detected items for complete spatial understanding.
- Automated takeoff generation with material quantity calculations directly mapped to estimate line items for streamlined estimating workflows.
- AI-powered item detection with semantic labeling for fixtures, appliances, and building components with cost mapping integration.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RoomModel               | Tenant | Yes    | Master room model entity with geometry data, surface definitions, item inventory, and comprehensive metadata with estimate and project integration                       |
| RoomModelWall           | Tenant | No     | Wall geometry with dimensions, orientation, material properties, and layer information for accurate spatial modeling and material calculations                           |
| RoomModelOpening        | Tenant | No     | Door, window, and niche definitions with dimensional data, material specifications, and type classifications for comprehensive opening management                        |
| RoomModelSurface        | Tenant | No     | Surface analysis including floors, ceilings, wall surfaces with finish schedules, tile layouts, and material specifications for detailed takeoffs                       |
| RoomModelItem           | Tenant | No     | AI-detected items including sinks, toilets, cabinets, electrical outlets, lights, HVAC components with semantic identification and spatial coordinates                  |
| RoomModelMeasurement    | Tenant | No     | Generated measurements including distances, clearances, wall lengths, surface areas, and volumes for comprehensive spatial analysis                                      |
| RoomModelTakeoff        | Tenant | No     | Automated quantity takeoffs for tile, paint, flooring, drywall, and fixtures with direct mapping to estimate line items for streamlined cost estimation               |
| RoomModelCostMapping    | Tenant | No     | Cost mapping configurations linking detected elements to estimate templates and pricing structures for automated cost calculation                                        |
| RoomModelAttachment     | Tenant | No     | Model supporting documentation including scan data, reference photos, and analysis reports with version control and access management                                    |
| RoomModelHistoryEvent   | Tenant | No     | Model lifecycle tracking including creation, modifications, analysis updates, and integration activities with comprehensive audit trails                                |

## roomScanner.prisma

Strategic purpose: Advanced room scanning system providing LiDAR, AR, and photogrammetry integration with intelligent processing pipelines for automated room model generation and semantic analysis.

Notes:

- Multi-device scanning support including LiDAR, ARKit, photogrammetry with high-accuracy reconstruction and semantic labeling capabilities.
- Intelligent processing pipeline converting raw scan data to structured room models with automated feature detection and classification.
- Real-time scanning with frame-by-frame capture, point cloud reconstruction, and mesh generation for comprehensive spatial documentation.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RoomScanSession         | Tenant | Yes    | Scanning session container with device information, accuracy profiles, project linkage, and comprehensive status tracking through capture and processing                |
| RoomScanFrame           | Tenant | No     | Individual scan frames with depth maps, RGB images, pose data, and confidence metrics for accurate reconstruction and analysis                                           |
| RoomScanPointCloud      | Tenant | No     | Reconstructed point cloud data with normalization, filtering, and optimization for accurate geometric representation and further processing                             |
| RoomScanMesh            | Tenant | No     | Generated 3D mesh from point cloud data optimized for AI analysis, feature extraction, and semantic labeling processes                                                  |
| RoomScanSemanticLabel   | Tenant | No     | AI-powered semantic classification identifying walls, floors, ceilings, doors, windows, and fixtures with confidence scoring and validation                             |
| RoomScanProcessing      | Tenant | No     | Processing pipeline management with stage tracking, error handling, and quality assurance for reliable scan-to-model conversion                                        |
| RoomScanCalibration     | Tenant | No     | Device calibration data and accuracy metrics ensuring consistent scan quality and measurement precision across different devices and environments                       |
| RoomScanMetadata        | Tenant | No     | Scan metadata including environmental conditions, device settings, operator information, and quality metrics for comprehensive documentation                            |
| RoomScanOutput          | Tenant | No     | Processing output management with generated files, analysis results, and export formats for integration with modeling and estimation systems                           |
| RoomScanHistoryEvent    | Tenant | No     | Comprehensive scanning lifecycle tracking including capture, processing, analysis, and integration activities with complete audit trail                                |

## safety.prisma

Strategic purpose: Comprehensive safety management system providing incident tracking, investigation workflows, hazard identification, and weather risk integration for proactive workplace safety assurance.

Notes:

- Complete incident management with investigation workflows, corrective action tracking, and regulatory compliance for comprehensive safety oversight.
- Proactive hazard identification with inspection schedules, training record management, and safety certification tracking for prevention-focused safety programs.
- Weather risk integration providing automated safety alerts and risk mitigation for weather-dependent construction and field operations.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SafetyIncident          | Tenant | Yes    | Safety incident documentation including type classification, severity assessment, location details, and comprehensive investigation management                            |
| SafetyIncidentPerson    | Tenant | No     | Personnel involvement tracking for employees and subcontractor workers with injury details, witness information, and contact data                                        |
| SafetyIncidentInvestigation| Tenant | No   | Formal incident investigation with root cause analysis, contributing factors, and evidence collection for comprehensive incident understanding                           |
| SafetyIncidentCorrectiveAction| Tenant | No | Corrective action management with task assignments, implementation timelines, and effectiveness verification for incident prevention                                     |
| SafetyInspection        | Tenant | Yes    | Safety inspection scheduling and execution with checklist management, finding documentation, and follow-up action tracking                                              |
| SafetyInspectionItem    | Tenant | No     | Inspection checklist items with pass/fail status, photographic evidence, corrective action requirements, and compliance verification                                    |
| SafetyHazard            | Tenant | No     | Hazard identification and management including exposed wiring, fall risks, wet surfaces with risk assessment and mitigation tracking                                    |
| SafetyTrainingRecord    | Tenant | No     | Training certification management including OSHA compliance, fall protection, equipment safety with expiration tracking and renewal requirements                        |
| SafetyWeatherRisk       | Tenant | No     | Weather-related safety risk management with automated alerts for high winds, extreme temperatures, precipitation with activity restrictions and protocols              |
| SafetyIncidentHistoryEvent| Tenant | No   | Comprehensive incident lifecycle tracking including reporting, investigation, corrective actions, and closure with complete audit trail and regulatory compliance      |

## schedulingCore.prisma

Strategic purpose: Global scheduling engine providing comprehensive calendar management, resource allocation, availability tracking, and assignment coordination for enterprise-wide scheduling optimization.

Notes:

- Universal scheduling framework supporting projects, employees, equipment, and resources with comprehensive availability and exception management.
- Multi-resource assignment capabilities with shift management, time-off tracking, and overtime coordination for optimal resource utilization.
- Integration-ready architecture supporting project tasks, work orders, appointments, and milestones with unified scheduling workflows.
- Formal approvals for certain schedule changes (e.g., overtime-heavy shifts or sensitive time-off) can be orchestrated via the central **Approvals** module.

| Model                | Scope  | Parent | Description                                                                                                                                   |
|----------------------|--------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| Schedule             | Tenant | Yes    | Master scheduling container supporting projects, employees, and equipment with comprehensive calendar management and resource coordination    |
| ScheduleItem         | Tenant | No     | Individual scheduled events including tasks, work orders, appointments, and milestones with duration, priority, and resource requirements     |
| ScheduleAssignment   | Tenant | No     | Resource assignment management linking personnel, crews, and equipment to scheduled items with role definitions and responsibility tracking  |
| ScheduleAvailability | Tenant | No     | Resource availability management for employees, crews, and equipment with capacity tracking and utilization optimization                     |
| ScheduleTimeOff      | Tenant | No     | Time-off management including vacations, sick leave, and personal time; may link to approval workflows driven by the Approvals module where required |
| ScheduleException    | Tenant | No     | Schedule exception handling for holidays, job site closures, weather risks, and emergency situations with automatic rescheduling capabilities |
| ScheduleShift        | Tenant | No     | Work shift definitions including morning, full-day, and night shifts with overtime rules and break scheduling integration                    |
| ScheduleResource     | Tenant | No     | Schedulable resource registry including personnel, crews, equipment, and subcontractors with capability definitions and availability tracking |
| ScheduleNote         | Tenant | No     | Schedule annotation system with event-specific notes, instructions, and communication for enhanced coordination and information sharing       |
| ScheduleHistoryEvent | Tenant | No     | Comprehensive scheduling audit trail capturing all schedule changes, assignments, cancellations, and optimizations with stakeholder attribution |

## scheduling.prisma

Strategic purpose: Advanced scheduling optimization system providing AI-driven schedule improvements, constraint management, conflict resolution, and automated scheduling recommendations for maximum efficiency.

Notes:

- Intelligent constraint management with business rules, resource limitations, and dependency tracking for realistic scheduling optimization.
- AI-powered optimization algorithms providing automatic schedule improvements, conflict resolution, and capacity balancing for operational excellence.
- Weather integration and travel time optimization with predictive scheduling adjustments and real-time schedule adaptation capabilities.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ScheduleConstraint      | Tenant | Yes    | Scheduling constraint definitions including resource conflicts, availability limitations, business hours, and dependency rules for realistic schedule optimization      |
| ScheduleConstraintRule  | Tenant | No     | Specific constraint conditions with metrics, operators, and thresholds for automated constraint evaluation and enforcement                                               |
| ScheduleOptimizationRun | Tenant | Yes    | AI-driven optimization execution with algorithm selection, performance metrics, and improvement recommendations for continuous scheduling enhancement                     |
| ScheduleOptimizationResult| Tenant | No   | Optimization outcome tracking with reassignments, new time slots, conflict resolutions, and efficiency improvements for informed decision making                       |
| ScheduleConflictingItem | Tenant | No     | Schedule conflict identification and management with overlapping events, resource disputes, and resolution tracking for proactive conflict resolution                  |
| ScheduleTravelTime      | Tenant | No     | Travel time calculation and optimization for crew and equipment movement between job sites with route optimization and scheduling integration                           |
| ScheduleWeatherAdjustment| Tenant | No    | Weather-based schedule adjustments with automatic rescheduling, risk mitigation, and resource reallocation for weather-dependent operations                            |
| ScheduleForecast        | Tenant | No     | Schedule demand forecasting with capacity planning, resource requirement prediction, and workload balancing for proactive resource management                          |
| ScheduleCapacity        | Tenant | No     | Resource capacity management by crew, team, and equipment with utilization tracking and optimization recommendations for maximum productivity                           |
| ScheduleAIRecommendation| Tenant | No     | AI-generated scheduling recommendations with optimization suggestions, efficiency improvements, and performance enhancement opportunities                                 |

## submittals.prisma

Strategic purpose: Submittal management system providing review workflows for materials, products, shop drawings, and design documentation with specification compliance tracking.

Notes:

- Complete submittal lifecycle management from submission through review and final disposition with multi-stakeholder processes and revision tracking.
- Specification section integration with CSI MasterFormat compatibility for standardized construction document management and compliance verification.
- Automated workflow management with reviewer assignments, distribution lists, and review sequences for efficient project communication.
- When a submittal’s disposition must go through formal company approval (e.g., high-risk or high-value items), this can be mirrored in the central **Approvals** module instead of using a dedicated `SubmittalApproval` table.

| Model                 | Scope  | Parent | Description                                                                                                  |
|-----------------------|--------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Submittal             | Hybrid | Yes    | Master submittal entity for materials, shop drawings, samples, and product data requiring review with comprehensive tracking capabilities              |
| SubmittalItem         | Tenant | No     | Individual submittal components with detailed specifications, quantities, and review requirements for granular tracking and management                  |
| SubmittalReview       | Tenant | No     | Review records capturing architect/engineer/GC decisions (approved, revise, rejected) with detailed feedback; may be linked to generic ApprovalRequests where needed |
| SubmittalAttachment   | Tenant | No     | Supporting documentation including drawings, photos, safety data sheets, and product data with version control and access management                    |
| SubmittalStatus       | Tenant | No     | Status management with standardized workflow stages including draft, submitted, under review, approved, and rejected                                    |
| SubmittalSpecSection  | Tenant | No     | Specification section linkage with CSI MasterFormat integration for standardized construction specification compliance and reference                    |
| SubmittalReviewer     | Tenant | No     | Reviewer assignment management with role-based responsibilities, expertise areas, and authority ranges                                                  |
| SubmittalWorkflowStep | Tenant | No     | Review sequence management with step-by-step workflow progression from general contractor through architect and engineer reviews                        |
| SubmittalDistribution | Tenant | No     | Distribution list management for stakeholder notification, document sharing, and communication coordination throughout the review process               |
| SubmittalHistoryEvent | Tenant | No     | Complete submittal lifecycle audit trail including submission, reviews, approvals, rejections, and revisions with comprehensive stakeholder attribution |

## tasks.prisma

Strategic purpose: Global task management system providing comprehensive task assignment, tracking, and collaboration capabilities superior to standalone project management tools with ERP integration.

Notes:

- Enterprise task management with assignment tracking, dependency management, and collaboration features integrated across all ERP modules and business processes.
- Comprehensive task organization with checklists, attachments, comments, and labeling systems for detailed task management and team coordination.
- Automated reminder systems with due date tracking, overdue notifications, and daily summaries for proactive task completion and accountability.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Task                    | Tenant | Yes    | Master task entity with comprehensive assignment, due date, priority, and linked entity integration across all ERP modules for unified task management                  |
| TaskAssignment          | Tenant | No     | Multi-personnel task assignment with responsibility definition, workload tracking, and collaboration coordination for team-based task execution                         |
| TaskChecklistItem       | Tenant | No     | Internal task breakdown with subtask management, completion tracking, and progress monitoring for detailed task execution and quality assurance                        |
| TaskComment             | Tenant | No     | Task communication with threaded discussions, status updates, and stakeholder coordination for comprehensive task collaboration and documentation                       |
| TaskAttachment          | Tenant | No     | Task-related document management with file sharing, version control, and access permissions for comprehensive task documentation and reference                          |
| TaskReminder            | Tenant | No     | Automated reminder system with pre-due notifications, overdue alerts, and daily summaries for proactive task management and deadline compliance                        |
| TaskDependency          | Tenant | No     | Task relationship management with predecessor/successor logic, blocking dependencies, and workflow coordination for complex task sequence management                    |
| TaskLabel               | Tenant | No     | Configurable task categorization with custom labels, priority indicators, and organizational tags for enhanced task organization and filtering                         |
| TaskLabelAssignment     | Tenant | No     | Many-to-many task and label relationships with flexible categorization, search optimization, and reporting capabilities for advanced task organization                 |
| TaskHistoryEvent        | Tenant | No     | Comprehensive task lifecycle audit trail including creation, assignments, status changes, and completion with complete accountability and performance tracking         |

## tenant.prisma

Strategic purpose: Multi-tenant platform management system providing comprehensive tenant onboarding, configuration, subscription management, and compliance oversight for enterprise SaaS operations.

Notes:

- Complete multi-tenant architecture with tenant isolation, subscription management, and feature flag control for scalable SaaS delivery.
- Comprehensive tenant customization including branding, domain management, and localization settings for white-label capabilities.
- Advanced usage tracking and compliance management with GDPR, CCPA, and data retention policy enforcement for regulatory adherence.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Tenant                  | Global | Yes    | Master tenant organization entity with subscription plans, status tracking, domain management, and comprehensive configuration capabilities                               |
| TenantSettings          | Global | No     | Tenant configuration management including timezone, locale, fiscal year, tax defaults, currency, and numbering conventions for localized operations                     |
| TenantSubscription      | Global | No     | Subscription plan management with tier definitions, module enablement, usage limits, pricing, and renewal tracking for revenue optimization                              |
| TenantUsageRecord       | Global | No     | Usage metrics tracking including API calls, storage consumption, transaction volumes, and feature utilization for billing and analytics                                  |
| TenantDomain            | Global | No     | Domain verification and management supporting custom domains and subdomains for branding and SSO integration                                                            |
| TenantBranding          | Global | No     | Brand customization including logos, color schemes, email templates, and custom styling for white-label presentation                                                     |
| TenantModule            | Global | No     | Module activation management controlling feature availability and access permissions for subscription-based feature delivery                                             |
| TenantFeatureFlag       | Global | No     | Feature flag management for A/B testing, experimental features, and gradual rollout capabilities with tenant-specific control                                           |
| TenantComplianceSetting | Global | No     | Compliance configuration including GDPR, CCPA, data retention policies, backup requirements, and legal framework adherence                                              |
| TenantHistoryEvent      | Global | No     | Comprehensive tenant lifecycle audit trail including plan changes, module activations, configuration updates, and compliance activities                                 |

## weatherIntelligenceCore.prisma

Strategic purpose: Advanced weather data collection and analysis system providing real-time observations, forecasting, and alert capabilities for weather-dependent business operations.

Notes:

- Multi-source weather data integration including NOAA, commercial APIs, and IoT sensors for comprehensive weather intelligence and accuracy.
- Real-time observation and forecasting capabilities with historical data retention for trend analysis and predictive modeling.
- Official weather alert integration with severe weather warnings, advisories, and watches for proactive risk management and safety protocols.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| WeatherStation          | Tenant | Yes    | Weather data source management including NOAA stations, commercial APIs, and on-site IoT stations with reliability and accuracy tracking                                 |
| WeatherObservation      | Tenant | No     | Historical weather data including temperature, humidity, wind speed, precipitation, and atmospheric conditions for trend analysis and verification                        |
| WeatherForecast         | Tenant | No     | Future weather predictions with hourly and daily forecasts including probability assessments and confidence intervals for planning accuracy                              |
| WeatherAlert            | Tenant | No     | Official weather alerts including severe thunderstorm warnings, tornado watches, flood advisories, and extreme temperature alerts with severity classifications          |
| WeatherCondition        | Tenant | No     | Current weather condition classifications including clear, cloudy, rainy, snowy, and stormy conditions with standardized categorization                                  |
| WeatherDataSource       | Tenant | No     | Data provider management including API configurations, rate limits, reliability metrics, and cost tracking for optimal data sourcing                                    |
| WeatherAttachment       | Tenant | No     | Weather visualization including radar images, storm tracking maps, precipitation charts, and satellite imagery for comprehensive situational awareness                   |
| WeatherSensor           | Tenant | No     | On-site IoT weather sensor management including wind meters, moisture sensors, temperature probes, and barometric pressure devices                                       |
| WeatherSensorReading    | Tenant | No     | Real-time sensor data collection with timestamp accuracy, calibration tracking, and data validation for reliable on-site weather monitoring                             |
| WeatherHistoryEvent     | Tenant | No     | Weather system audit trail including data source changes, sensor maintenance, alert processing, and system performance monitoring                                        |

## weatherImpactAlerts.prisma

Strategic purpose: Intelligent weather impact analysis system providing automated risk assessment, project impact prediction, and proactive scheduling recommendations for weather-dependent operations.

Notes:

- Rule-based weather impact engine with customizable thresholds for different trades, activities, and safety requirements for precise risk management.
- Automated notification system with multi-channel alerts, rescheduling recommendations, and stakeholder communication for proactive project management.
- Project-specific weather forecasting with location-based predictions and timeline integration for accurate impact assessment and planning optimization.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| WeatherImpactRule       | Tenant | Yes    | Weather impact rules defining when conditions affect specific work activities with customizable thresholds for trades, safety, and operational requirements             |
| WeatherImpactCondition  | Tenant | No     | Granular rule conditions with metric definitions, operators, and threshold values for precise weather impact determination and automated decision making                 |
| WeatherProjectForecast  | Tenant | No     | Project-specific weather forecasting with location-based predictions and timeline integration for accurate project planning and risk assessment                          |
| WeatherImpactEvent      | Tenant | Yes    | Weather impact incidents generated when conditions affect project activities with severity assessment and recommended actions for stakeholder awareness                  |
| WeatherImpactTask       | Tenant | No     | Specific project tasks affected by weather events with impact severity, delay estimates, and recommended mitigation actions for project schedule management             |
| WeatherImpactNotification| Tenant | No    | Multi-channel notifications including email, push, in-app, and SMS alerts with weather warnings and rescheduling recommendations for proactive communication           |
| WeatherDelayRecommendation| Tenant | No   | Automated scheduling recommendations including rescheduling options, alternative activities, and resource reallocation for weather-related disruptions                  |
| WeatherRiskAssessment   | Tenant | No     | Continuous risk evaluation with probability calculations, impact severity ratings, and mitigation strategies for informed decision making                                |
| WeatherMitigation       | Tenant | No     | Mitigation action tracking including protective measures, equipment securing, and safety protocols with implementation status and effectiveness monitoring               |
| WeatherImpactHistoryEvent| Tenant | No   | Comprehensive weather impact audit trail including event generation, notification delivery, action implementation, and outcome tracking for continuous improvement       |

## workOrders.prisma

Strategic purpose: Comprehensive work order and field service management system providing dispatching, mobile field operations, resource tracking, and customer interaction capabilities.

Notes:

- Complete work order lifecycle management from creation through completion with dispatching, assignment, and mobile field support equivalent to leading field service platforms.
- Integrated resource tracking including materials, labor, and equipment with real-time inventory impact and billing integration for accurate job costing.
- Customer interaction features including digital signatures, photo documentation, and service completion verification for professional service delivery.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| WorkOrder               | Tenant | Yes    | Master work order entity for maintenance, repair, installation, and service calls with comprehensive lifecycle management and customer integration                       |
| WorkOrderTask           | Tenant | No     | Individual work order tasks including diagnosis, installation, testing, and cleanup with completion tracking and quality verification                                    |
| WorkOrderAssignment     | Tenant | No     | Technician and crew assignment management with scheduling, dispatch coordination, and availability tracking for optimal resource utilization                            |
| WorkOrderMaterial       | Tenant | No     | Material usage tracking with inventory integration, cost allocation, and stock impact management for accurate job costing and inventory control                         |
| WorkOrderLabor          | Tenant | No     | Labor time tracking including regular hours, overtime, and premium time with rate calculations and payroll integration for comprehensive cost management                |
| WorkOrderNote           | Tenant | No     | Internal and field notes with timestamp tracking, technician observations, and customer communication for comprehensive service documentation                            |
| WorkOrderAttachment     | Tenant | No     | Service documentation including before/after photos, diagnostic videos, completion certificates, and reference materials for quality assurance                          |
| WorkOrderSignature      | Tenant | No     | Customer signature capture with digital authentication, service completion verification, and legal compliance for professional service delivery                          |
| WorkOrderInvoiceLink    | Tenant | No     | Billing integration linking work orders to generated invoices with cost allocation, billing status, and payment tracking for revenue management                        |
| WorkOrderHistoryEvent   | Tenant | No     | Complete work order audit trail including creation, dispatch, progress updates, completion, and billing activities with comprehensive stakeholder tracking             |

## zeroLoss.prisma

Strategic purpose: Advanced material loss prevention and detection system providing comprehensive loss tracking, investigation workflows, and preventive analytics for zero-loss inventory management.

Notes:

- Proactive loss detection with root cause analysis, investigation management, and corrective action tracking for comprehensive material loss prevention.
- Multi-location loss tracking across warehouses, job sites, trucks, and procurement with detailed item-level analysis and financial impact assessment.
- Predictive analytics and trend analysis with loss pattern identification, risk assessment, and prevention recommendations for continuous improvement.

| Model                   | Scope  | Parent |                                                Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ZeroLossEvent           | Tenant | Yes    | Master loss incident record documenting material, tool, and equipment losses with comprehensive impact assessment and investigation management                            |
| ZeroLossItem            | Tenant | No     | Specific items involved in loss events with expected versus actual quantities, loss calculations, and source location tracking for detailed impact analysis             |
| ZeroLossCause           | Tenant | No     | Root cause categorization including theft, damage, misplacement, administrative errors, and vendor issues for analytical reporting and prevention strategies             |
| ZeroLossInvestigation   | Tenant | No     | Formal investigation management with investigator assignments, interview documentation, evidence collection, and conclusion reporting for comprehensive loss analysis     |
| ZeroLossCorrectiveAction| Tenant | No     | Corrective action tracking with implementation timelines, responsible parties, and effectiveness verification for prevention-focused loss management                     |
| ZeroLossAnalytics       | Tenant | No     | Loss trend analysis with pattern identification, cost impact assessment, and prevention opportunity analysis for strategic loss reduction planning                       |
| ZeroLossAlert           | Tenant | No     | Automated loss detection alerts with threshold monitoring, anomaly detection, and stakeholder notification for proactive loss prevention                                |
| ZeroLossAuditTrail      | Tenant | No     | Comprehensive audit documentation with investigation timelines, evidence preservation, and compliance reporting for regulatory adherence and accountability             |
| ZeroLossPreventionPlan  | Tenant | No     | Prevention strategy management with risk mitigation plans, security improvements, and process enhancements for systematic loss reduction                                 |
| ZeroLossHistoryEvent    | Tenant | No     | Complete loss management audit trail including detection, investigation, corrective actions, and prevention implementation with performance tracking and improvement    |
