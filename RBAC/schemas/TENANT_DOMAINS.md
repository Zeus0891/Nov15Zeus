# 🏢 TENANT DOMAINS
## Authoritative Classification for BeeSmart ERP

**Date**: 2025-11-19  
**Version**: 1.0  
**Classification**: TENANT (Has `tenantId`, RLS-Isolated)

---

## 🎯 Definition: TENANT Tables

Tables that:
- **ALWAYS have `tenantId` field**
- **ALWAYS have RLS policies enforced**
- **Tenant-isolated** (one tenant cannot see another's data)
- **All business operations**

These represent **ALL business modules** in the ERP.

---

## 📊 SUMMARY

| Category | Module Count | Table Count |
|----------|--------------|-------------|
| **Identity & Membership (Tenant Context)** | 2 | 10 |
| **Access Control (Tenant Context)** | 1 | 10 |
| **Core Business Documents** | 3 | 51 |
| **CRM & External Parties** | 4 | 40 |
| **Financial Management** | 8 | 81 |
| **Project Management** | 5 | 39 |
| **Human Resources & Payroll** | 3 | 29 |
| **Inventory & Procurement** | 4 | 38 |
| **Quality & Safety** | 4 | 30 |
| **Construction-Specific** | 6 | 60 |
| **Communication & Collaboration** | 5 | 50 |
| **AI & Automation** | 3 | 29 |
| **Analytics & Reporting** | 2 | 20 |
| **Integration & Sync** | 2 | 20 |
| **Compliance & Governance** | 2 | 20 |
| **Scheduling & Time** | 3 | 29 |
| **Documents & E-Signature** | 3 | 29 |
| **Weather Intelligence** | 2 | 20 |
| **Tenant Configuration** | 1 | 9 |
| **Notifications** | 1 | 10 |
| **TOTAL TENANT TABLES** | **62 modules** | **607 tables** |

---

## 🔐 TENANT DOMAIN CATEGORIES

---

### 1️⃣ IDENTITY & MEMBERSHIP (Tenant Context)

These bridge global User to tenant-specific Member.

#### identity.prisma (4 tenant tables)
**WHY TENANT**: Tenant-specific user data and settings

- `UserProfile` - Tenant-specific profile data
- `UserSetting` - Tenant-specific user preferences
- `UserInvitation` - Tenant-specific user invitations
- `UserHistoryEvent` - Tenant-specific audit trail

#### membership.prisma (6 tables)
**WHY TENANT**: Bridges global User → tenant Member

- `Member` ⭐ **Key Bridge**: `User` (global) → `Member` (tenant context)
- `MemberSettings` - Member preferences within tenant
- `MemberInvitation` - Member invitations (tenant-scoped)
- `MemberExternalLink` - External links for members
- `MemberDocument` - Member documents
- `MemberHistoryEvent` - Member history

---

### 2️⃣ ACCESS CONTROL (Tenant Context)

#### accesscontrol.prisma (10 tenant tables)
**WHY TENANT**: Tenant-specific roles and policies

- `Role` - Tenant-specific role instances (uses global Permission)
- `RolePermission` - Maps global Permission → tenant Role
- `MemberRole` - Maps Member → Role (tenant context)
- `AccessPolicy` - Tenant-specific access policies
- `AccessPolicyCondition` - Policy conditions
- `AccessScope` - Access scopes
- `AccessScopeAssignment` - Scope assignments
- `AccessAuditEvent` - Audit events
- `ServiceAccount` - Tenant service accounts
- `ServiceAccountKey` - Service account keys

#### identitysecurity.prisma (1 tenant table)
**WHY TENANT**: Tenant-specific SSO configuration

- `TenantIdentityProvider` - Tenant-specific SSO config

---

### 3️⃣ CORE BUSINESS DOCUMENTS

These are the primary revenue-generating documents.

#### estimate.prisma (16 tables)
**WHY TENANT**: Tenant business documents (NOT hybrid despite external access)

- `Estimate` ⭐ **Has public links, still tenant-scoped**
- `EstimateRevision` - Immutable snapshots
- `EstimateSection` - Logical groupings
- `EstimateLineItem` - Work items
- `EstimateTax` - Tax calculations
- `EstimateDiscount` - Discounts
- `EstimateFee` - Fees/overhead
- `EstimateTerm` - Payment/delivery terms
- `EstimateAssumption` - Assumptions
- `EstimateExclusion` - Exclusions
- `EstimateAlternate` - Alternatives
- `EstimateAttachment` - Documents
- `EstimateComment` - Internal comments
- `EstimateComparison` - Bid comparisons
- `EstimateHistoryEvent` - Audit trail
- `EstimatePublicLink` ⭐ **Token-based external access (tenant-scoped)**

#### invoice.prisma (18 tables)
**WHY TENANT**: Tenant invoices (NOT hybrid despite payment links)

- `Invoice` ⭐ **Has public links, still tenant-scoped**
- `InvoiceLineItem` - Line items
- `InvoiceTax` - Tax calculations
- `InvoiceDiscount` - Discounts
- `InvoiceFee` - Fees
- `InvoiceRetainage` - Retainage
- `InvoiceProgress` - Progress billing
- `InvoiceMilestone` - Milestone billing
- `InvoicePaymentApplication` - Payment application
- `InvoiceAttachment` - Documents
- `InvoiceComment` - Comments
- `InvoiceRevision` - Revisions
- `InvoiceAdjustment` - Adjustments
- `InvoiceCredit` - Credit memos
- `InvoiceDebit` - Debit memos
- `InvoiceHistory` - History
- `InvoicePublicLink` ⭐ **Token-based payment access (tenant-scoped)**
- `InvoiceReminder` - Payment reminders

#### changeorder.prisma (9 tables)
**WHY TENANT**: Tenant change orders

- `ChangeOrder` - Change orders
- `ChangeOrderLineItem` - Line items
- `ChangeOrderReason` - Reasons
- `ChangeOrderImpact` - Impact analysis
- `ChangeOrderScheduleImpact` - Schedule impact
- `ChangeOrderScope` - Scope changes
- `ChangeOrderAttachment` - Documents
- `ChangeOrderRevision` - Revisions
- `ChangeOrderHistoryEvent` - History

#### billing.prisma (10 tables)
**WHY TENANT**: Tenant billing operations

- `BillingSchedule` - Billing schedules
- `BillingMilestone` - Milestones
- `BillingProgress` - Progress billing
- `BillingRetainage` - Retainage
- `BillingDeposit` - Deposits
- `BillingAdjustment` - Adjustments
- `ReceivableLedger` - Receivables ledger
- `ReceivablePaymentApplication` - Payment application
- `ReceivableAgingSnapshot` - Aging analysis
- `BillingHistoryEvent` - History

---

### 4️⃣ CRM & EXTERNAL PARTIES

**IMPORTANT**: These represent external entities but are **tenant-scoped tables**.

#### crmcore.prisma (10 tables)
**WHY TENANT**: Tenant data ABOUT external clients (NOT hybrid)

- `CRMAccount` ⭐ **Represents external clients, but tenant-scoped table**
- `CRMContact` ⭐ **Represents external contacts, but tenant-scoped table**
- `CRMAddress` - External party addresses
- `CRMInteraction` - Interactions with external parties
- `CRMInteractionAttachment` - Interaction documents
- `CRMNote` - Notes about external parties
- `CRMTag` - Tags
- `CRMAccountTag` - Account tagging
- `CRMActivity` - Activities
- `CRMHistoryEvent` - History

#### crmcommunication.prisma (10 tables)
**WHY TENANT**: Tenant communication records with external parties

- `CRMEmail` - Emails to/from external parties
- `CRMEmailAttachment` - Email attachments
- `CRMSMS` - SMS messages
- `CRMPhoneCall` - Phone calls
- `CRMPhoneCallRecording` - Call recordings
- `CRMMessageThread` - Message threads
- `CRMMessageParticipant` - Participants
- `CRMChannel` - Communication channels
- `CRMNotificationSetting` - Notification preferences
- `CRMNotificationEvent` - Notification events

#### crmrelationships.prisma (10 tables)
**WHY TENANT**: Tenant-tracked external relationships

- `CRMAccountRelationship` - Account relationships
- `CRMContactRole` - Contact roles
- `CRMAccountHierarchy` - Account hierarchies
- `CRMHousehold` - Household groupings
- `CRMHouseholdMember` - Household members
- `CRMDecisionMaker` - Decision makers
- `CRMInfluencer` - Influencers
- `CRMPartner` - Partners
- `CRMRelationshipAttachment` - Documents
- `CRMRelationshipHistoryEvent` - History

#### customerportal.prisma (10 tables)
**WHY TENANT**: External users accessing tenant data (tenant-scoped)

- `CustomerPortalUser` ⭐ **External users, but tenant-scoped**
- `CustomerPortalSession` - Portal sessions
- `CustomerPortalAccess` - Access control
- `CustomerPortalProjectView` - Project visibility
- `CustomerPortalEstimateView` - Estimate visibility
- `CustomerPortalInvoiceView` - Invoice visibility
- `CustomerPortalPaymentMethod` - Payment methods
- `CustomerPortalMessage` - Messages
- `CustomerPortalDocument` - Documents
- `CustomerPortalHistoryEvent` - History

---

### 5️⃣ FINANCIAL MANAGEMENT

#### generalledger.prisma (10 tables)
- `GLAccount`
- `GLAccountCategory`
- `GLAccountSegment`
- `GLFiscalYear`
- `GLFiscalPeriod`
- `GLJournal`
- `GLJournalLine`
- `GLPostingBatch`
- `GLTrialBalanceSnapshot`
- `GLHistoryEvent`

#### accountingtransaction.prisma (9 tables)
- `Transaction`
- `TransactionLine`
- `TransactionSourceLink`
- `TransactionType`
- `TransactionBatch`
- `TransactionAttachment`
- `TransactionReversal`
- `TransactionAllocation`
- `TransactionHistoryEvent`

#### banking.prisma (10 tables)
- `BankAccount`
- `BankTransaction`
- `BankReconciliation`
- `BankReconciliationItem`
- `BankFeedConnection`
- `BankStatement`
- `BankRule`
- `BankTransfer`
- `BankDeposit`
- `BankHistoryEvent`

#### taxcompliance.prisma (10 tables)
- `TaxJurisdiction`
- `TaxRate`
- `TaxCode`
- `TaxRule`
- `TaxLiability`
- `TaxPayment`
- `TaxReturn`
- `TaxFilingAttachment`
- `TaxExemptionCertificate`
- `TaxHistoryEvent`

#### paymentsARCashApplication.prisma (10 tables)
**WHY TENANT**: Tenant payment processing

- `Payment` - Payments (from external clients, but tenant-scoped)
- `PaymentMethod` - Payment methods
- `PaymentGatewayTransaction` - Gateway transactions
- `PaymentApplication` - Payment application
- `PaymentUnapplied` - Unapplied payments
- `PaymentRefund` - Refunds
- `PaymentReconciliation` - Reconciliation
- `PaymentDispute` - Disputes
- `PaymentAttachment` - Documents
- `PaymentHistoryEvent` - History

#### expensecore.prisma (9 tables)
- `ExpenseReport`
- `ExpenseLine`
- `ExpenseCategory`
- `ExpenseReceipt`
- `ExpensePolicy`
- `ExpensePolicyViolation`
- `ExpensePayment`
- `ExpenseAttachment`
- `ExpenseHistoryEvent`

#### expenses.prisma (9 tables)
- `CorpCard`
- `CorpCardTransaction`
- `CorpCardReconciliation`
- `CorpCardLimit`
- `CorpCardDispute`
- `CorpCardVendor`
- `CorpCardReceipt`
- `CorpCardAttachment`
- `CorpCardHistoryEvent`

#### jobCosting.prisma (10 tables)
- `CostCode`
- `CostCategory`
- `CostType`
- `CostCenter`
- `JobCostLedger`
- `JobCostLine`
- `JobCostBudget`
- `JobCostBudgetLine`
- `JobCostForecast`
- `JobCostHistoryEvent`

---

### 6️⃣ PROJECT MANAGEMENT

#### projectsCore.prisma (10 tables)
**WHY TENANT**: Tenant projects (shared with clients via portal, still tenant-scoped)

- `Project` ⭐ **Shared with clients via CustomerPortal, still tenant-scoped**
- `ProjectPhase`
- `ProjectMilestone`
- `ProjectTeamMember`
- `ProjectLocation`
- `ProjectBudget`
- `ProjectBudgetLineItem`
- `ProjectDocument`
- `ProjectAttachment`
- `ProjectHistoryEvent`

#### projectTaskScheduling.prisma (10 tables)
- `ProjectTask`
- `ProjectTaskAssignment`
- `ProjectTaskDependency`
- `ProjectSchedule`
- `ProjectScheduleItem`
- `ProjectCriticalPath`
- `ProjectBaseline`
- `ProjectChecklistItem`
- `ProjectTaskComment`
- `ProjectTaskAttachment`

#### projectRisk.prisma (10 tables)
- `ProjectRisk`
- `ProjectIssue`
- `ProjectDecision`
- `ProjectDailyLog`
- `ProjectDailyLogLabor`
- `ProjectDailyLogEquipment`
- `ProjectDailyLogMaterial`
- `ProjectDailyLogPhoto`
- `ProjectProgress`
- `ProjectNote`

#### tasks.prisma (10 tables)
- `Task`
- `TaskAssignment`
- `TaskChecklistItem`
- `TaskComment`
- `TaskAttachment`
- `TaskReminder`
- `TaskDependency`
- `TaskLabel`
- `TaskLabelAssignment`
- `TaskHistoryEvent`

#### workOrders.prisma (10 tables)
- `WorkOrder`
- `WorkOrderTask`
- `WorkOrderAssignment`
- `WorkOrderMaterial`
- `WorkOrderLabor`
- `WorkOrderNote`
- `WorkOrderAttachment`
- `WorkOrderSignature`
- `WorkOrderInvoiceLink`
- `WorkOrderHistoryEvent`

---

### 7️⃣ HUMAN RESOURCES & PAYROLL

#### hrcore.prisma (10 tables)
- `Employee`
- `EmployeeAddress`
- `EmployeeContact`
- `EmployeePosition`
- `EmployeeDepartment`
- `EmployeeCompensation`
- `EmployeeStatus`
- `EmployeeSkill`
- `EmployeeDocument`
- `EmployeeHistoryEvent`

#### payroll.prisma (10 tables)
- `PayrollRun`
- `PayrollEarning`
- `PayrollDeduction`
- `PayrollTax`
- `PayrollCalendar`
- `PayrollBenefit`
- `PayrollGarnishment`
- `PayrollCheck`
- `PayrollDirectDeposit`
- `PayrollHistoryEvent`

#### timeattendance.prisma (9 tables)
- `Timesheet`
- `TimesheetEntry`
- `TimesheetBreak`
- `TimesheetOvertime`
- `TimesheetGeoLocation`
- `TimesheetSignature`
- `TimesheetAdjustment`
- `TimesheetExport`
- `TimesheetHistoryEvent`

---

### 8️⃣ INVENTORY & PROCUREMENT

#### inventoryCore.prisma (10 tables)
- `InventoryItem`
- `InventoryCategory`
- `InventoryLocation`
- `InventoryBin`
- `InventoryUnitOfMeasure`
- `InventoryStock`
- `InventorySupplier`
- `InventoryItemVendor`
- `InventoryAttachment`
- `InventoryHistoryEvent`

#### inventoryTransactions.prisma (10 tables)
- `InventoryTransaction`
- `InventoryTransactionLine`
- `InventoryAdjustment`
- `InventoryTransfer`
- `InventoryTransferLine`
- `InventoryReturn`
- `InventoryReturnLine`
- `InventoryCount`
- `InventoryCountLine`
- `InventoryTransactionHistory`

#### inventoryControl.prisma (10 tables)
- `InventoryLossEvent`
- `InventoryLossCause`
- `InventoryLossInvestigation`
- `InventoryAudit`
- `InventoryAuditLine`
- `InventoryReservation`
- `InventoryCommitment`
- `InventoryReorderPoint`
- `InventorySafetyStock`
- `InventoryControlHistory`

#### procurementPo.prisma (9 tables)
**WHY TENANT**: Purchase orders to external vendors, but tenant-scoped

- `PurchaseOrder` - POs to external vendors (tenant-scoped)
- `PurchaseOrderLineItem`
- `PurchaseRequisition`
- `PurchaseRequisitionItem`
- `PurchaseOrderReceipt`
- `PurchaseOrderReceiptItem`
- `PurchaseOrderReturn`
- `PurchaseOrderAttachment`
- `PurchaseOrderHistoryEvent`

---

### 9️⃣ QUALITY & SAFETY

#### quality.prisma (10 tables)
- `QualityInspection`
- `QualityInspectionItem`
- `QualityNonConformance`
- `QualityNonConformanceAction`
- `QualityPunchListItem`
- `QualityMaterialTest`
- `QualityMaterialTestResult`
- `QualityStandard`
- `QualityAttachment`
- `QualityInspectionHistory`

#### safety.prisma (10 tables)
- `SafetyIncident`
- `SafetyIncidentPerson`
- `SafetyIncidentInvestigation`
- `SafetyIncidentCorrectiveAction`
- `SafetyInspection`
- `SafetyInspectionItem`
- `SafetyHazard`
- `SafetyTrainingRecord`
- `SafetyWeatherRisk`
- `SafetyIncidentHistoryEvent`

#### compliance.prisma (10 tables)
- `ComplianceRequirement`
- `ComplianceDocument`
- `ComplianceCheck`
- `ComplianceViolation`
- `ComplianceCorrectionAction`
- `ComplianceAudit`
- `ComplianceAuditFinding`
- `ComplianceTrainingRecord`
- `ComplianceAttachment`
- `ComplianceHistory`

#### zeroLoss.prisma (10 tables)
- `ZeroLossEvent`
- `ZeroLossItem`
- `ZeroLossCause`
- `ZeroLossInvestigation`
- `ZeroLossCorrectiveAction`
- `ZeroLossAnalytics`
- `ZeroLossAlert`
- `ZeroLossAuditTrail`
- `ZeroLossPreventionPlan`
- `ZeroLossHistoryEvent`

---

### 🔟 CONSTRUCTION-SPECIFIC

#### submittals.prisma (10 tables)
**WHY TENANT**: Submittals to external parties, but tenant-scoped

- `Submittal` - Sent to external reviewers (tenant-scoped)
- `SubmittalItem`
- `SubmittalReview`
- `SubmittalAttachment`
- `SubmittalStatus`
- `SubmittalSpecSection`
- `SubmittalReviewer`
- `SubmittalWorkflowStep`
- `SubmittalDistribution`
- `SubmittalHistoryEvent`

#### RFI.prisma (10 tables)
**WHY TENANT**: RFIs with external parties, but tenant-scoped

- `RFI` - Sent to/from external parties (tenant-scoped)
- `RFIQuestion`
- `RFIResponse`
- `RFIAttachment`
- `RFIComment`
- `RFIStatus`
- `RFICategory`
- `RFIImpact`
- `RFIRecipient`
- `RFIHistoryEvent`

#### roomModel.prisma (10 tables)
- `RoomModel`
- `RoomModelWall`
- `RoomModelOpening`
- `RoomModelSurface`
- `RoomModelItem`
- `RoomModelMeasurement`
- `RoomModelTakeoff`
- `RoomModelCostMapping`
- `RoomModelAttachment`
- `RoomModelHistoryEvent`

#### roomScanner.prisma (10 tables)
- `RoomScanSession`
- `RoomScanFrame`
- `RoomScanPointCloud`
- `RoomScanMesh`
- `RoomScanSemanticLabel`
- `RoomScanProcessing`
- `RoomScanCalibration`
- `RoomScanMetadata`
- `RoomScanOutput`
- `RoomScanHistoryEvent`

#### contracts.prisma (10 tables)
**WHY TENANT**: Contracts with external parties, but tenant-scoped

- `Contract` - With external parties (tenant-scoped)
- `ContractScope`
- `ContractTerm`
- `ContractDeliverable`
- `ContractMilestone`
- `ContractAmendment`
- `ContractAttachment`
- `ContractSignature`
- `ContractCompliance`
- `ContractHistoryEvent`

#### maintenanceService.prisma (10 tables)
- `ServiceContract`
- `ServiceContractPlan`
- `ServiceContractSchedule`
- `ServiceContractTask`
- `ServiceContractPricing`
- `ServiceContractPaymentMethod`
- `ServiceContractRenewal`
- `ServiceContractCancelation`
- `ServiceContractNotification`
- `ServiceContractHistoryEvent`

---

### 1️⃣1️⃣ COMMUNICATION & COLLABORATION

#### messaging.prisma (10 tables)
- `MessageThread`
- `Message`
- `MessageParticipant`
- `MessageAttachment`
- `MessageReaction`
- `MessageMention`
- `MessageVisibilityRule`
- `MessageReadReceipt`
- `MessagePin`
- `MessageHistoryEvent`

#### emailengine.prisma (10 tables)
**WHY TENANT**: Tenant email operations (to/from external, but tenant-scoped)

- `EmailMessage` - To/from external parties (tenant-scoped)
- `EmailRecipient`
- `EmailAttachment`
- `EmailTemplate`
- `EmailCampaign`
- `EmailAccount`
- `EmailThreadLink`
- `EmailSendLog`
- `EmailBounce`
- `EmailHistoryEvent`

#### smscalls.prisma (10 tables)
**WHY TENANT**: Tenant SMS/call operations

- `SMSMessage` - To/from external parties (tenant-scoped)
- `SMSAttachment`
- `SMSHistoryEvent`
- `PhoneCall`
- `PhoneCallRecording`
- `PhoneCallHistoryEvent`
- `PhoneIVRMenu`
- `PhoneQueue`
- `PhoneNumberPool`
- `CommunicationProvider`

#### esignature.prisma (10 tables)
**WHY TENANT**: Tenant e-signature operations

- `ESignatureEnvelope` - With external signers (tenant-scoped)
- `ESignatureDocument`
- `ESignatureRecipient`
- `ESignatureRecipientAction`
- `ESignatureField`
- `ESignatureAuditTrail`
- `ESignatureWorkflowStep`
- `ESignatureAttachment`
- `ESignatureNotification`
- `ESignatureHistoryEvent`

#### documentscore.prisma (10 tables)
- `Document`
- `DocumentFolder`
- `DocumentVersion`
- `DocumentRevision`
- `DocumentComment`
- `DocumentTag`
- `DocumentShareLink`
- `DocumentPermission`
- `DocumentAttachment`
- `DocumentHistoryEvent`

---

### 1️⃣2️⃣ AI & AUTOMATION

#### aicore.prisma (10 tables)
- `AIModel`
- `AIModelVersion`
- `AIPromptTemplate`
- `AIAction`
- `AIActionRun`
- `AIPlaybook`
- `AIPlaybookStep`
- `AIEmbedding`
- `AIJob`
- `AIJobArtifact`

#### aidocument.prisma (10 tables)
- `AIDocumentIndex`
- `AIDocumentChunk`
- `AIOCRResult`
- `AIExtractionResult`
- `AIClassificationResult`
- `AIDocumentAttachment`
- `AIDocumentHistoryEvent`
- `AIAnnotation`
- `AIEntity`
- `AIInsightFeedback`

#### aiinsights.prisma (9 tables)
- `AIInsight`
- `AIInsightHistory`
- `AIPrediction`
- `AIRecommendation`
- `AIAnomaly`
- `AITrend`
- `AIForecast`
- `AIWhatIfRun`
- `AIInsightAttachment`

---

### 1️⃣3️⃣ ANALYTICS & REPORTING

#### analytics.prisma (10 tables)
- `AnalyticsDataset`
- `AnalyticsDatasetField`
- `AnalyticsCube`
- `AnalyticsMetric`
- `AnalyticsDimension`
- `AnalyticsFilter`
- `AnalyticsQuery`
- `AnalyticsInsight`
- `AnalyticsInsightHistoryEvent`
- `AnalyticsAttachment`

#### dashboards.prisma (10 tables)
- `Dashboard`
- `DashboardWidget`
- `DashboardWidgetConfig`
- `DashboardUserView`
- `DashboardSchedule`
- `DashboardBookmark`
- `DashboardSharing`
- `DashboardTemplate`
- `DashboardFolder`
- `DashboardHistoryEvent`

---

### 1️⃣4️⃣ INTEGRATION & SYNC

#### integrationsCore.prisma (10 tables)
**WHY TENANT**: Tenant integrations with external systems

- `IntegrationConnection` - To external systems (tenant-scoped)
- `IntegrationProvider`
- `IntegrationOAuthToken`
- `IntegrationApiKey`
- `IntegrationMapping`
- `IntegrationFieldTransform`
- `IntegrationEvent`
- `IntegrationError`
- `IntegrationAttachment`
- `IntegrationConnectionHistory`

#### integrationsSyncEngine.prisma (10 tables)
- `IntegrationSyncJob`
- `IntegrationSyncLog`
- `IntegrationWebhook`
- `IntegrationWebhookDelivery`
- `IntegrationInboundWebhook`
- `IntegrationQueueItem`
- `IntegrationRateLimit`
- `IntegrationRetryPolicy`
- `IntegrationSchemaVersion`
- `IntegrationHistoryEvent`

---

### 1️⃣5️⃣ COMPLIANCE & GOVERNANCE

#### approvals.prisma (10 tables)
- `ApprovalRequest`
- `ApprovalRule`
- `ApprovalLevel`
- `ApprovalDecision`
- `ApprovalAssignment`
- `ApprovalStep`
- `ApprovalEscalation`
- `ApprovalCondition`
- `ApprovalAttachment`
- `ApprovalHistoryEvent`

#### documentsai.prisma (10 tables)
- `DocumentOCRResult`
- `DocumentAIExtraction`
- `DocumentAIClassification`
- `DocumentAnnotation`
- `DocumentIndex`
- `DocumentChunk`
- `DocumentEmbedding`
- `DocumentTrainingSample`
- `DocumentAIModel`
- `DocumentAIHistory`

---

### 1️⃣6️⃣ SCHEDULING & TIME

#### schedulingCore.prisma (10 tables)
- `Schedule`
- `ScheduleItem`
- `ScheduleAssignment`
- `ScheduleAvailability`
- `ScheduleTimeOff`
- `ScheduleException`
- `ScheduleShift`
- `ScheduleResource`
- `ScheduleNote`
- `ScheduleHistoryEvent`

#### scheduling.prisma (10 tables)
- `ScheduleConstraint`
- `ScheduleConstraintRule`
- `ScheduleOptimizationRun`
- `ScheduleOptimizationResult`
- `ScheduleConflictingItem`
- `ScheduleTravelTime`
- `ScheduleWeatherAdjustment`
- `ScheduleForecast`
- `ScheduleCapacity`
- `ScheduleAIRecommendation`

---

### 1️⃣7️⃣ WEATHER INTELLIGENCE

#### weatherIntelligenceCore.prisma (10 tables)
- `WeatherStation`
- `WeatherObservation`
- `WeatherForecast`
- `WeatherAlert`
- `WeatherCondition`
- `WeatherDataSource`
- `WeatherAttachment`
- `WeatherSensor`
- `WeatherSensorReading`
- `WeatherHistoryEvent`

#### weatherImpactAlerts.prisma (10 tables)
- `WeatherImpactRule`
- `WeatherImpactCondition`
- `WeatherProjectForecast`
- `WeatherImpactEvent`
- `WeatherImpactTask`
- `WeatherImpactNotification`
- `WeatherDelayRecommendation`
- `WeatherRiskAssessment`
- `WeatherMitigation`
- `WeatherImpactHistoryEvent`

---

### 1️⃣8️⃣ TENANT CONFIGURATION

#### tenant.prisma (9 tenant tables)
**WHY TENANT**: Tenant-specific configuration (not the Tenant registry itself)

- `TenantSettings` - Tenant-specific settings
- `TenantSubscription` - Subscription details
- `TenantUsageRecord` - Usage tracking
- `TenantDomain` - Custom domains
- `TenantBranding` - Branding configuration
- `TenantModule` - Module enablement
- `TenantFeatureFlag` - Feature flags
- `TenantComplianceSetting` - Compliance settings
- `TenantHistoryEvent` - Audit trail

---

### 1️⃣9️⃣ NOTIFICATIONS

#### notifications.prisma (10 tables)
- `Notification`
- `NotificationPreference`
- `NotificationChannel`
- `NotificationTemplate`
- `NotificationDelivery`
- `NotificationDigest`
- `NotificationRule`
- `NotificationQueueItem`
- `NotificationAttachment`
- `NotificationHistoryEvent`

---

## 🔑 CRITICAL PRINCIPLES

### 1. **ALL business data is tenant-scoped**

Every single business operation in the ERP is tenant-isolated:
```sql
CREATE TABLE estimates (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL, -- ALWAYS present
  -- ... other fields
);

-- RLS policy enforced
CREATE POLICY estimate_isolation ON estimates
  USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```

### 2. **External interaction does NOT change classification**

Tables remain tenant-scoped even when:
- External clients interact via public links
- External parties are represented (CRM)
- Payments come from external sources
- Documents are shared with external parties
- E-signatures involve external signers

### 3. **Public links are access mechanism, not security domain**

```
Estimate (tenant table)
  └── EstimatePublicLink (tenant table, has tenantId)
      └── token: "secure-random-token"
      └── External client accesses: /public/estimate/:token
          └── Backend validates token
          └── Backend loads Estimate (bypasses RBAC, respects resource scope)
          └── Client can view/approve/decline
          └── NO RBAC needed
          └── NO global access needed
```

### 4. **Customer Portal uses separate RBAC domain**

```
Internal RBAC:
├── ADMIN, PROJECT_MANAGER, WORKER, DRIVER, VIEWER
└── Use Member context

External Portal RBAC:
├── CLIENT, VENDOR, PARTNER
└── Use CustomerPortalUser context
└── Different API layer
└── Different permission model
└── Still tenant-scoped tables
```

### 5. **CRM represents external, but tables are tenant-scoped**

```
CRMAccount (tenant table, has tenantId)
  └── Represents: External client company
  └── Accessed by: Internal members via RBAC
  └── NOT accessed by: External clients directly
  
External client interaction:
  └── Via EstimatePublicLink, InvoicePublicLink
  └── Via CustomerPortal (if enabled)
  └── NOT via direct CRMAccount access
```

---

## ✅ VALIDATION CHECKLIST

For a table to be TENANT-SCOPED:

- [x] Has `tenantId` field
- [x] Has RLS policy enforcing tenant isolation
- [x] Belongs to a business module
- [x] Is NOT part of global identity/security infrastructure
- [x] Is NOT the Tenant registry itself

If **ALL** are checked, it's TENANT-SCOPED.

---

## 📊 GRAND TOTALS

| Classification | Table Count | Percentage |
|---------------|-------------|------------|
| **GLOBAL** | 17 | 2.7% |
| **TENANT** | 607 | 97.3% |
| **TOTAL** | **624** | **100%** |

---

## 🎓 KEY ARCHITECTURAL INSIGHTS

### BeeSmart's 2-Tier Model

```
┌─────────────────────────────────────────┐
│         GLOBAL (17 tables)              │
│  • User, Actor, Session                 │
│  • IdentityProvider, AuthFactor         │
│  • Permission, AccessResource           │
│  • Tenant (registry)                    │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│         TENANT (607 tables)             │
│  • ALL business modules                 │
│  • Estimate, Invoice, Project           │
│  • CRM, CustomerPortal                  │
│  • Everything else                      │
└─────────────────────────────────────────┘
```

### External Access Patterns

```
1. PUBLIC LINKS (No-login):
   ┌─────────────┐
   │   Client    │
   └──────┬──────┘
          │ GET /public/estimate/:token
          ▼
   ┌─────────────┐
   │  Token Auth │
   └──────┬──────┘
          │ Valid token → Load Estimate
          ▼
   ┌─────────────┐
   │  Estimate   │ (tenant table)
   └─────────────┘

2. CUSTOMER PORTAL (Portal RBAC):
   ┌─────────────┐
   │   Client    │
   └──────┬──────┘
          │ Login to portal
          ▼
   ┌──────────────────┐
   │ Portal Auth      │
   │ Role: CLIENT     │ (separate from internal RBAC)
   └──────┬───────────┘
          │ Portal API (tenant context)
          ▼
   ┌─────────────────┐
   │ Tenant Data     │ (filtered by portal permissions)
   └─────────────────┘
```

---

**Generated**: 2025-11-19  
**Status**: ✅ AUTHORITATIVE  
**Total Tables**: 607 tenant-scoped tables across 62 modules
