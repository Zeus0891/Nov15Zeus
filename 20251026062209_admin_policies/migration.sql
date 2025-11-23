-- ADMIN policies for all tables with tenantId
-- Generated automatically
-- Tables with soft delete include deletedAt condition in SELECT/UPDATE USING
-- INSERT and DELETE do NOT validate deletedAt

-- ================================================================================

-- Note: Invoice uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_invoice" ON public."Invoice";

CREATE POLICY "rls_admin_select_invoice"
ON public."Invoice"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_invoice" ON public."Invoice";

CREATE POLICY "rls_admin_insert_invoice"
ON public."Invoice"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_invoice" ON public."Invoice";

CREATE POLICY "rls_admin_update_invoice"
ON public."Invoice"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_invoice" ON public."Invoice";

CREATE POLICY "rls_admin_delete_invoice"
ON public."Invoice"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: CreditMemo uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_creditmemo" ON public."CreditMemo";

CREATE POLICY "rls_admin_select_creditmemo"
ON public."CreditMemo"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_creditmemo" ON public."CreditMemo";

CREATE POLICY "rls_admin_insert_creditmemo"
ON public."CreditMemo"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_creditmemo" ON public."CreditMemo";

CREATE POLICY "rls_admin_update_creditmemo"
ON public."CreditMemo"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_creditmemo" ON public."CreditMemo";

CREATE POLICY "rls_admin_delete_creditmemo"
ON public."CreditMemo"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: CreditMemoLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_creditmemoline" ON public."CreditMemoLine";

CREATE POLICY "rls_admin_select_creditmemoline"
ON public."CreditMemoLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_creditmemoline" ON public."CreditMemoLine";

CREATE POLICY "rls_admin_insert_creditmemoline"
ON public."CreditMemoLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_creditmemoline" ON public."CreditMemoLine";

CREATE POLICY "rls_admin_update_creditmemoline"
ON public."CreditMemoLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_creditmemoline" ON public."CreditMemoLine";

CREATE POLICY "rls_admin_delete_creditmemoline"
ON public."CreditMemoLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Payment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_payment" ON public."Payment";

CREATE POLICY "rls_admin_select_payment"
ON public."Payment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_payment" ON public."Payment";

CREATE POLICY "rls_admin_insert_payment"
ON public."Payment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_payment" ON public."Payment";

CREATE POLICY "rls_admin_update_payment"
ON public."Payment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_payment" ON public."Payment";

CREATE POLICY "rls_admin_delete_payment"
ON public."Payment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PurchaseOrder uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_purchaseorder" ON public."PurchaseOrder";

CREATE POLICY "rls_admin_select_purchaseorder"
ON public."PurchaseOrder"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_purchaseorder" ON public."PurchaseOrder";

CREATE POLICY "rls_admin_insert_purchaseorder"
ON public."PurchaseOrder"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_purchaseorder" ON public."PurchaseOrder";

CREATE POLICY "rls_admin_update_purchaseorder"
ON public."PurchaseOrder"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_purchaseorder" ON public."PurchaseOrder";

CREATE POLICY "rls_admin_delete_purchaseorder"
ON public."PurchaseOrder"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: APBill uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_apbill" ON public."APBill";

CREATE POLICY "rls_admin_select_apbill"
ON public."APBill"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_apbill" ON public."APBill";

CREATE POLICY "rls_admin_insert_apbill"
ON public."APBill"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_apbill" ON public."APBill";

CREATE POLICY "rls_admin_update_apbill"
ON public."APBill"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_apbill" ON public."APBill";

CREATE POLICY "rls_admin_delete_apbill"
ON public."APBill"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ExpenseReport uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_expensereport" ON public."ExpenseReport";

CREATE POLICY "rls_admin_select_expensereport"
ON public."ExpenseReport"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_expensereport" ON public."ExpenseReport";

CREATE POLICY "rls_admin_insert_expensereport"
ON public."ExpenseReport"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_expensereport" ON public."ExpenseReport";

CREATE POLICY "rls_admin_update_expensereport"
ON public."ExpenseReport"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_expensereport" ON public."ExpenseReport";

CREATE POLICY "rls_admin_delete_expensereport"
ON public."ExpenseReport"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Expense uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_expense" ON public."Expense";

CREATE POLICY "rls_admin_select_expense"
ON public."Expense"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_expense" ON public."Expense";

CREATE POLICY "rls_admin_insert_expense"
ON public."Expense"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_expense" ON public."Expense";

CREATE POLICY "rls_admin_update_expense"
ON public."Expense"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_expense" ON public."Expense";

CREATE POLICY "rls_admin_delete_expense"
ON public."Expense"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Project uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_project" ON public."Project";

CREATE POLICY "rls_admin_select_project"
ON public."Project"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_project" ON public."Project";

CREATE POLICY "rls_admin_insert_project"
ON public."Project"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_project" ON public."Project";

CREATE POLICY "rls_admin_update_project"
ON public."Project"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_project" ON public."Project";

CREATE POLICY "rls_admin_delete_project"
ON public."Project"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantSettings uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantsettings" ON public."TenantSettings";

CREATE POLICY "rls_admin_select_tenantsettings"
ON public."TenantSettings"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantsettings" ON public."TenantSettings";

CREATE POLICY "rls_admin_insert_tenantsettings"
ON public."TenantSettings"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantsettings" ON public."TenantSettings";

CREATE POLICY "rls_admin_update_tenantsettings"
ON public."TenantSettings"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantsettings" ON public."TenantSettings";

CREATE POLICY "rls_admin_delete_tenantsettings"
ON public."TenantSettings"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantMetrics uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantmetrics" ON public."TenantMetrics";

CREATE POLICY "rls_admin_select_tenantmetrics"
ON public."TenantMetrics"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantmetrics" ON public."TenantMetrics";

CREATE POLICY "rls_admin_insert_tenantmetrics"
ON public."TenantMetrics"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantmetrics" ON public."TenantMetrics";

CREATE POLICY "rls_admin_update_tenantmetrics"
ON public."TenantMetrics"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantmetrics" ON public."TenantMetrics";

CREATE POLICY "rls_admin_delete_tenantmetrics"
ON public."TenantMetrics"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantFeatureFlag uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantfeatureflag" ON public."TenantFeatureFlag";

CREATE POLICY "rls_admin_select_tenantfeatureflag"
ON public."TenantFeatureFlag"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantfeatureflag" ON public."TenantFeatureFlag";

CREATE POLICY "rls_admin_insert_tenantfeatureflag"
ON public."TenantFeatureFlag"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantfeatureflag" ON public."TenantFeatureFlag";

CREATE POLICY "rls_admin_update_tenantfeatureflag"
ON public."TenantFeatureFlag"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantfeatureflag" ON public."TenantFeatureFlag";

CREATE POLICY "rls_admin_delete_tenantfeatureflag"
ON public."TenantFeatureFlag"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantBillingAccount uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantbillingaccount" ON public."TenantBillingAccount";

CREATE POLICY "rls_admin_select_tenantbillingaccount"
ON public."TenantBillingAccount"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantbillingaccount" ON public."TenantBillingAccount";

CREATE POLICY "rls_admin_insert_tenantbillingaccount"
ON public."TenantBillingAccount"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantbillingaccount" ON public."TenantBillingAccount";

CREATE POLICY "rls_admin_update_tenantbillingaccount"
ON public."TenantBillingAccount"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantbillingaccount" ON public."TenantBillingAccount";

CREATE POLICY "rls_admin_delete_tenantbillingaccount"
ON public."TenantBillingAccount"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantSubscription uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantsubscription" ON public."TenantSubscription";

CREATE POLICY "rls_admin_select_tenantsubscription"
ON public."TenantSubscription"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantsubscription" ON public."TenantSubscription";

CREATE POLICY "rls_admin_insert_tenantsubscription"
ON public."TenantSubscription"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantsubscription" ON public."TenantSubscription";

CREATE POLICY "rls_admin_update_tenantsubscription"
ON public."TenantSubscription"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantsubscription" ON public."TenantSubscription";

CREATE POLICY "rls_admin_delete_tenantsubscription"
ON public."TenantSubscription"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantUsageRecord uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantusagerecord" ON public."TenantUsageRecord";

CREATE POLICY "rls_admin_select_tenantusagerecord"
ON public."TenantUsageRecord"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantusagerecord" ON public."TenantUsageRecord";

CREATE POLICY "rls_admin_insert_tenantusagerecord"
ON public."TenantUsageRecord"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantusagerecord" ON public."TenantUsageRecord";

CREATE POLICY "rls_admin_update_tenantusagerecord"
ON public."TenantUsageRecord"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantusagerecord" ON public."TenantUsageRecord";

CREATE POLICY "rls_admin_delete_tenantusagerecord"
ON public."TenantUsageRecord"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantAuditLog uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantauditlog" ON public."TenantAuditLog";

CREATE POLICY "rls_admin_select_tenantauditlog"
ON public."TenantAuditLog"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantauditlog" ON public."TenantAuditLog";

CREATE POLICY "rls_admin_insert_tenantauditlog"
ON public."TenantAuditLog"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantauditlog" ON public."TenantAuditLog";

CREATE POLICY "rls_admin_update_tenantauditlog"
ON public."TenantAuditLog"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantauditlog" ON public."TenantAuditLog";

CREATE POLICY "rls_admin_delete_tenantauditlog"
ON public."TenantAuditLog"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantEvent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantevent" ON public."TenantEvent";

CREATE POLICY "rls_admin_select_tenantevent"
ON public."TenantEvent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantevent" ON public."TenantEvent";

CREATE POLICY "rls_admin_insert_tenantevent"
ON public."TenantEvent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantevent" ON public."TenantEvent";

CREATE POLICY "rls_admin_update_tenantevent"
ON public."TenantEvent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantevent" ON public."TenantEvent";

CREATE POLICY "rls_admin_delete_tenantevent"
ON public."TenantEvent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ContractTemplate uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_contracttemplate" ON public."ContractTemplate";

CREATE POLICY "rls_admin_select_contracttemplate"
ON public."ContractTemplate"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_contracttemplate" ON public."ContractTemplate";

CREATE POLICY "rls_admin_insert_contracttemplate"
ON public."ContractTemplate"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_contracttemplate" ON public."ContractTemplate";

CREATE POLICY "rls_admin_update_contracttemplate"
ON public."ContractTemplate"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_contracttemplate" ON public."ContractTemplate";

CREATE POLICY "rls_admin_delete_contracttemplate"
ON public."ContractTemplate"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TermsTemplate uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_termstemplate" ON public."TermsTemplate";

CREATE POLICY "rls_admin_select_termstemplate"
ON public."TermsTemplate"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_termstemplate" ON public."TermsTemplate";

CREATE POLICY "rls_admin_insert_termstemplate"
ON public."TermsTemplate"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_termstemplate" ON public."TermsTemplate";

CREATE POLICY "rls_admin_update_termstemplate"
ON public."TermsTemplate"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_termstemplate" ON public."TermsTemplate";

CREATE POLICY "rls_admin_delete_termstemplate"
ON public."TermsTemplate"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EncryptionProfile uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_encryptionprofile" ON public."EncryptionProfile";

CREATE POLICY "rls_admin_select_encryptionprofile"
ON public."EncryptionProfile"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_encryptionprofile" ON public."EncryptionProfile";

CREATE POLICY "rls_admin_insert_encryptionprofile"
ON public."EncryptionProfile"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_encryptionprofile" ON public."EncryptionProfile";

CREATE POLICY "rls_admin_update_encryptionprofile"
ON public."EncryptionProfile"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_encryptionprofile" ON public."EncryptionProfile";

CREATE POLICY "rls_admin_delete_encryptionprofile"
ON public."EncryptionProfile"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DataRetentionPolicy uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_dataretentionpolicy" ON public."DataRetentionPolicy";

CREATE POLICY "rls_admin_select_dataretentionpolicy"
ON public."DataRetentionPolicy"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_dataretentionpolicy" ON public."DataRetentionPolicy";

CREATE POLICY "rls_admin_insert_dataretentionpolicy"
ON public."DataRetentionPolicy"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_dataretentionpolicy" ON public."DataRetentionPolicy";

CREATE POLICY "rls_admin_update_dataretentionpolicy"
ON public."DataRetentionPolicy"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_dataretentionpolicy" ON public."DataRetentionPolicy";

CREATE POLICY "rls_admin_delete_dataretentionpolicy"
ON public."DataRetentionPolicy"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: NumberSequence uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_numbersequence" ON public."NumberSequence";

CREATE POLICY "rls_admin_select_numbersequence"
ON public."NumberSequence"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_numbersequence" ON public."NumberSequence";

CREATE POLICY "rls_admin_insert_numbersequence"
ON public."NumberSequence"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_numbersequence" ON public."NumberSequence";

CREATE POLICY "rls_admin_update_numbersequence"
ON public."NumberSequence"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_numbersequence" ON public."NumberSequence";

CREATE POLICY "rls_admin_delete_numbersequence"
ON public."NumberSequence"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DocumentGroup uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_documentgroup" ON public."DocumentGroup";

CREATE POLICY "rls_admin_select_documentgroup"
ON public."DocumentGroup"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_documentgroup" ON public."DocumentGroup";

CREATE POLICY "rls_admin_insert_documentgroup"
ON public."DocumentGroup"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_documentgroup" ON public."DocumentGroup";

CREATE POLICY "rls_admin_update_documentgroup"
ON public."DocumentGroup"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_documentgroup" ON public."DocumentGroup";

CREATE POLICY "rls_admin_delete_documentgroup"
ON public."DocumentGroup"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SignatureEvent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_signatureevent" ON public."SignatureEvent";

CREATE POLICY "rls_admin_select_signatureevent"
ON public."SignatureEvent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_signatureevent" ON public."SignatureEvent";

CREATE POLICY "rls_admin_insert_signatureevent"
ON public."SignatureEvent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_signatureevent" ON public."SignatureEvent";

CREATE POLICY "rls_admin_update_signatureevent"
ON public."SignatureEvent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_signatureevent" ON public."SignatureEvent";

CREATE POLICY "rls_admin_delete_signatureevent"
ON public."SignatureEvent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EventProjection uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_eventprojection" ON public."EventProjection";

CREATE POLICY "rls_admin_select_eventprojection"
ON public."EventProjection"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_eventprojection" ON public."EventProjection";

CREATE POLICY "rls_admin_insert_eventprojection"
ON public."EventProjection"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_eventprojection" ON public."EventProjection";

CREATE POLICY "rls_admin_update_eventprojection"
ON public."EventProjection"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_eventprojection" ON public."EventProjection";

CREATE POLICY "rls_admin_delete_eventprojection"
ON public."EventProjection"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EventSnapshot uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_eventsnapshot" ON public."EventSnapshot";

CREATE POLICY "rls_admin_select_eventsnapshot"
ON public."EventSnapshot"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_eventsnapshot" ON public."EventSnapshot";

CREATE POLICY "rls_admin_insert_eventsnapshot"
ON public."EventSnapshot"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_eventsnapshot" ON public."EventSnapshot";

CREATE POLICY "rls_admin_update_eventsnapshot"
ON public."EventSnapshot"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_eventsnapshot" ON public."EventSnapshot";

CREATE POLICY "rls_admin_delete_eventsnapshot"
ON public."EventSnapshot"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Session uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_session" ON public."Session";

CREATE POLICY "rls_admin_select_session"
ON public."Session"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_session" ON public."Session";

CREATE POLICY "rls_admin_insert_session"
ON public."Session"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_session" ON public."Session";

CREATE POLICY "rls_admin_update_session"
ON public."Session"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_session" ON public."Session";

CREATE POLICY "rls_admin_delete_session"
ON public."Session"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AuthFactor uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_authfactor" ON public."AuthFactor";

CREATE POLICY "rls_admin_select_authfactor"
ON public."AuthFactor"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_authfactor" ON public."AuthFactor";

CREATE POLICY "rls_admin_insert_authfactor"
ON public."AuthFactor"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_authfactor" ON public."AuthFactor";

CREATE POLICY "rls_admin_update_authfactor"
ON public."AuthFactor"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_authfactor" ON public."AuthFactor";

CREATE POLICY "rls_admin_delete_authfactor"
ON public."AuthFactor"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PasswordResetToken uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_passwordresettoken" ON public."PasswordResetToken";

CREATE POLICY "rls_admin_select_passwordresettoken"
ON public."PasswordResetToken"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_passwordresettoken" ON public."PasswordResetToken";

CREATE POLICY "rls_admin_insert_passwordresettoken"
ON public."PasswordResetToken"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_passwordresettoken" ON public."PasswordResetToken";

CREATE POLICY "rls_admin_update_passwordresettoken"
ON public."PasswordResetToken"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_passwordresettoken" ON public."PasswordResetToken";

CREATE POLICY "rls_admin_delete_passwordresettoken"
ON public."PasswordResetToken"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ApiKey uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_apikey" ON public."ApiKey";

CREATE POLICY "rls_admin_select_apikey"
ON public."ApiKey"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_apikey" ON public."ApiKey";

CREATE POLICY "rls_admin_insert_apikey"
ON public."ApiKey"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_apikey" ON public."ApiKey";

CREATE POLICY "rls_admin_update_apikey"
ON public."ApiKey"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_apikey" ON public."ApiKey";

CREATE POLICY "rls_admin_delete_apikey"
ON public."ApiKey"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: UserDevice uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_userdevice" ON public."UserDevice";

CREATE POLICY "rls_admin_select_userdevice"
ON public."UserDevice"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_userdevice" ON public."UserDevice";

CREATE POLICY "rls_admin_insert_userdevice"
ON public."UserDevice"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_userdevice" ON public."UserDevice";

CREATE POLICY "rls_admin_update_userdevice"
ON public."UserDevice"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_userdevice" ON public."UserDevice";

CREATE POLICY "rls_admin_delete_userdevice"
ON public."UserDevice"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Member uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_member" ON public."Member";

CREATE POLICY "rls_admin_select_member"
ON public."Member"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_member" ON public."Member";

CREATE POLICY "rls_admin_insert_member"
ON public."Member"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_member" ON public."Member";

CREATE POLICY "rls_admin_update_member"
ON public."Member"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_member" ON public."Member";

CREATE POLICY "rls_admin_delete_member"
ON public."Member"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MemberSettings uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_membersettings" ON public."MemberSettings";

CREATE POLICY "rls_admin_select_membersettings"
ON public."MemberSettings"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_membersettings" ON public."MemberSettings";

CREATE POLICY "rls_admin_insert_membersettings"
ON public."MemberSettings"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_membersettings" ON public."MemberSettings";

CREATE POLICY "rls_admin_update_membersettings"
ON public."MemberSettings"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_membersettings" ON public."MemberSettings";

CREATE POLICY "rls_admin_delete_membersettings"
ON public."MemberSettings"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MemberRole uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_memberrole" ON public."MemberRole";

CREATE POLICY "rls_admin_select_memberrole"
ON public."MemberRole"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_memberrole" ON public."MemberRole";

CREATE POLICY "rls_admin_insert_memberrole"
ON public."MemberRole"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_memberrole" ON public."MemberRole";

CREATE POLICY "rls_admin_update_memberrole"
ON public."MemberRole"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_memberrole" ON public."MemberRole";

CREATE POLICY "rls_admin_delete_memberrole"
ON public."MemberRole"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MemberDocument uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_memberdocument" ON public."MemberDocument";

CREATE POLICY "rls_admin_select_memberdocument"
ON public."MemberDocument"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_memberdocument" ON public."MemberDocument";

CREATE POLICY "rls_admin_insert_memberdocument"
ON public."MemberDocument"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_memberdocument" ON public."MemberDocument";

CREATE POLICY "rls_admin_update_memberdocument"
ON public."MemberDocument"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_memberdocument" ON public."MemberDocument";

CREATE POLICY "rls_admin_delete_memberdocument"
ON public."MemberDocument"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ServiceAccount uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_serviceaccount" ON public."ServiceAccount";

CREATE POLICY "rls_admin_select_serviceaccount"
ON public."ServiceAccount"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_serviceaccount" ON public."ServiceAccount";

CREATE POLICY "rls_admin_insert_serviceaccount"
ON public."ServiceAccount"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_serviceaccount" ON public."ServiceAccount";

CREATE POLICY "rls_admin_update_serviceaccount"
ON public."ServiceAccount"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_serviceaccount" ON public."ServiceAccount";

CREATE POLICY "rls_admin_delete_serviceaccount"
ON public."ServiceAccount"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ServiceAccountKey uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_serviceaccountkey" ON public."ServiceAccountKey";

CREATE POLICY "rls_admin_select_serviceaccountkey"
ON public."ServiceAccountKey"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_serviceaccountkey" ON public."ServiceAccountKey";

CREATE POLICY "rls_admin_insert_serviceaccountkey"
ON public."ServiceAccountKey"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_serviceaccountkey" ON public."ServiceAccountKey";

CREATE POLICY "rls_admin_update_serviceaccountkey"
ON public."ServiceAccountKey"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_serviceaccountkey" ON public."ServiceAccountKey";

CREATE POLICY "rls_admin_delete_serviceaccountkey"
ON public."ServiceAccountKey"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Role uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_role" ON public."Role";

CREATE POLICY "rls_admin_select_role"
ON public."Role"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_role" ON public."Role";

CREATE POLICY "rls_admin_insert_role"
ON public."Role"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_role" ON public."Role";

CREATE POLICY "rls_admin_update_role"
ON public."Role"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_role" ON public."Role";

CREATE POLICY "rls_admin_delete_role"
ON public."Role"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RolePermission uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_rolepermission" ON public."RolePermission";

CREATE POLICY "rls_admin_select_rolepermission"
ON public."RolePermission"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_rolepermission" ON public."RolePermission";

CREATE POLICY "rls_admin_insert_rolepermission"
ON public."RolePermission"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_rolepermission" ON public."RolePermission";

CREATE POLICY "rls_admin_update_rolepermission"
ON public."RolePermission"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_rolepermission" ON public."RolePermission";

CREATE POLICY "rls_admin_delete_rolepermission"
ON public."RolePermission"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: IdentityProviderConnection uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_identityproviderconnection" ON public."IdentityProviderConnection";

CREATE POLICY "rls_admin_select_identityproviderconnection"
ON public."IdentityProviderConnection"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_identityproviderconnection" ON public."IdentityProviderConnection";

CREATE POLICY "rls_admin_insert_identityproviderconnection"
ON public."IdentityProviderConnection"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_identityproviderconnection" ON public."IdentityProviderConnection";

CREATE POLICY "rls_admin_update_identityproviderconnection"
ON public."IdentityProviderConnection"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_identityproviderconnection" ON public."IdentityProviderConnection";

CREATE POLICY "rls_admin_delete_identityproviderconnection"
ON public."IdentityProviderConnection"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Worker uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_worker" ON public."Worker";

CREATE POLICY "rls_admin_select_worker"
ON public."Worker"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_worker" ON public."Worker";

CREATE POLICY "rls_admin_insert_worker"
ON public."Worker"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_worker" ON public."Worker";

CREATE POLICY "rls_admin_update_worker"
ON public."Worker"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_worker" ON public."Worker";

CREATE POLICY "rls_admin_delete_worker"
ON public."Worker"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Employment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_employment" ON public."Employment";

CREATE POLICY "rls_admin_select_employment"
ON public."Employment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_employment" ON public."Employment";

CREATE POLICY "rls_admin_insert_employment"
ON public."Employment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_employment" ON public."Employment";

CREATE POLICY "rls_admin_update_employment"
ON public."Employment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_employment" ON public."Employment";

CREATE POLICY "rls_admin_delete_employment"
ON public."Employment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PositionAssignment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_positionassignment" ON public."PositionAssignment";

CREATE POLICY "rls_admin_select_positionassignment"
ON public."PositionAssignment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_positionassignment" ON public."PositionAssignment";

CREATE POLICY "rls_admin_insert_positionassignment"
ON public."PositionAssignment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_positionassignment" ON public."PositionAssignment";

CREATE POLICY "rls_admin_update_positionassignment"
ON public."PositionAssignment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_positionassignment" ON public."PositionAssignment";

CREATE POLICY "rls_admin_delete_positionassignment"
ON public."PositionAssignment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: JobProfileAssignment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_jobprofileassignment" ON public."JobProfileAssignment";

CREATE POLICY "rls_admin_select_jobprofileassignment"
ON public."JobProfileAssignment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_jobprofileassignment" ON public."JobProfileAssignment";

CREATE POLICY "rls_admin_insert_jobprofileassignment"
ON public."JobProfileAssignment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_jobprofileassignment" ON public."JobProfileAssignment";

CREATE POLICY "rls_admin_update_jobprofileassignment"
ON public."JobProfileAssignment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_jobprofileassignment" ON public."JobProfileAssignment";

CREATE POLICY "rls_admin_delete_jobprofileassignment"
ON public."JobProfileAssignment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: CompensationPlan uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_compensationplan" ON public."CompensationPlan";

CREATE POLICY "rls_admin_select_compensationplan"
ON public."CompensationPlan"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_compensationplan" ON public."CompensationPlan";

CREATE POLICY "rls_admin_insert_compensationplan"
ON public."CompensationPlan"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_compensationplan" ON public."CompensationPlan";

CREATE POLICY "rls_admin_update_compensationplan"
ON public."CompensationPlan"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_compensationplan" ON public."CompensationPlan";

CREATE POLICY "rls_admin_delete_compensationplan"
ON public."CompensationPlan"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: CompensationComponent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_compensationcomponent" ON public."CompensationComponent";

CREATE POLICY "rls_admin_select_compensationcomponent"
ON public."CompensationComponent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_compensationcomponent" ON public."CompensationComponent";

CREATE POLICY "rls_admin_insert_compensationcomponent"
ON public."CompensationComponent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_compensationcomponent" ON public."CompensationComponent";

CREATE POLICY "rls_admin_update_compensationcomponent"
ON public."CompensationComponent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_compensationcomponent" ON public."CompensationComponent";

CREATE POLICY "rls_admin_delete_compensationcomponent"
ON public."CompensationComponent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayGroupAssignment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_paygroupassignment" ON public."PayGroupAssignment";

CREATE POLICY "rls_admin_select_paygroupassignment"
ON public."PayGroupAssignment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_paygroupassignment" ON public."PayGroupAssignment";

CREATE POLICY "rls_admin_insert_paygroupassignment"
ON public."PayGroupAssignment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_paygroupassignment" ON public."PayGroupAssignment";

CREATE POLICY "rls_admin_update_paygroupassignment"
ON public."PayGroupAssignment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_paygroupassignment" ON public."PayGroupAssignment";

CREATE POLICY "rls_admin_delete_paygroupassignment"
ON public."PayGroupAssignment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BenefitEnrollment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_benefitenrollment" ON public."BenefitEnrollment";

CREATE POLICY "rls_admin_select_benefitenrollment"
ON public."BenefitEnrollment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_benefitenrollment" ON public."BenefitEnrollment";

CREATE POLICY "rls_admin_insert_benefitenrollment"
ON public."BenefitEnrollment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_benefitenrollment" ON public."BenefitEnrollment";

CREATE POLICY "rls_admin_update_benefitenrollment"
ON public."BenefitEnrollment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_benefitenrollment" ON public."BenefitEnrollment";

CREATE POLICY "rls_admin_delete_benefitenrollment"
ON public."BenefitEnrollment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BenefitDependent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_benefitdependent" ON public."BenefitDependent";

CREATE POLICY "rls_admin_select_benefitdependent"
ON public."BenefitDependent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_benefitdependent" ON public."BenefitDependent";

CREATE POLICY "rls_admin_insert_benefitdependent"
ON public."BenefitDependent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_benefitdependent" ON public."BenefitDependent";

CREATE POLICY "rls_admin_update_benefitdependent"
ON public."BenefitDependent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_benefitdependent" ON public."BenefitDependent";

CREATE POLICY "rls_admin_delete_benefitdependent"
ON public."BenefitDependent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: LeaveOfAbsence uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_leaveofabsence" ON public."LeaveOfAbsence";

CREATE POLICY "rls_admin_select_leaveofabsence"
ON public."LeaveOfAbsence"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_leaveofabsence" ON public."LeaveOfAbsence";

CREATE POLICY "rls_admin_insert_leaveofabsence"
ON public."LeaveOfAbsence"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_leaveofabsence" ON public."LeaveOfAbsence";

CREATE POLICY "rls_admin_update_leaveofabsence"
ON public."LeaveOfAbsence"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_leaveofabsence" ON public."LeaveOfAbsence";

CREATE POLICY "rls_admin_delete_leaveofabsence"
ON public."LeaveOfAbsence"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AbsenceBalance uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_absencebalance" ON public."AbsenceBalance";

CREATE POLICY "rls_admin_select_absencebalance"
ON public."AbsenceBalance"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_absencebalance" ON public."AbsenceBalance";

CREATE POLICY "rls_admin_insert_absencebalance"
ON public."AbsenceBalance"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_absencebalance" ON public."AbsenceBalance";

CREATE POLICY "rls_admin_update_absencebalance"
ON public."AbsenceBalance"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_absencebalance" ON public."AbsenceBalance";

CREATE POLICY "rls_admin_delete_absencebalance"
ON public."AbsenceBalance"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PerformanceReview uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_performancereview" ON public."PerformanceReview";

CREATE POLICY "rls_admin_select_performancereview"
ON public."PerformanceReview"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_performancereview" ON public."PerformanceReview";

CREATE POLICY "rls_admin_insert_performancereview"
ON public."PerformanceReview"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_performancereview" ON public."PerformanceReview";

CREATE POLICY "rls_admin_update_performancereview"
ON public."PerformanceReview"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_performancereview" ON public."PerformanceReview";

CREATE POLICY "rls_admin_delete_performancereview"
ON public."PerformanceReview"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PerformanceGoal uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_performancegoal" ON public."PerformanceGoal";

CREATE POLICY "rls_admin_select_performancegoal"
ON public."PerformanceGoal"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_performancegoal" ON public."PerformanceGoal";

CREATE POLICY "rls_admin_insert_performancegoal"
ON public."PerformanceGoal"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_performancegoal" ON public."PerformanceGoal";

CREATE POLICY "rls_admin_update_performancegoal"
ON public."PerformanceGoal"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_performancegoal" ON public."PerformanceGoal";

CREATE POLICY "rls_admin_delete_performancegoal"
ON public."PerformanceGoal"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Certification uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_certification" ON public."Certification";

CREATE POLICY "rls_admin_select_certification"
ON public."Certification"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_certification" ON public."Certification";

CREATE POLICY "rls_admin_insert_certification"
ON public."Certification"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_certification" ON public."Certification";

CREATE POLICY "rls_admin_update_certification"
ON public."Certification"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_certification" ON public."Certification";

CREATE POLICY "rls_admin_delete_certification"
ON public."Certification"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TrainingEnrollment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_trainingenrollment" ON public."TrainingEnrollment";

CREATE POLICY "rls_admin_select_trainingenrollment"
ON public."TrainingEnrollment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_trainingenrollment" ON public."TrainingEnrollment";

CREATE POLICY "rls_admin_insert_trainingenrollment"
ON public."TrainingEnrollment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_trainingenrollment" ON public."TrainingEnrollment";

CREATE POLICY "rls_admin_update_trainingenrollment"
ON public."TrainingEnrollment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_trainingenrollment" ON public."TrainingEnrollment";

CREATE POLICY "rls_admin_delete_trainingenrollment"
ON public."TrainingEnrollment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Leave uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_leave" ON public."Leave";

CREATE POLICY "rls_admin_select_leave"
ON public."Leave"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_leave" ON public."Leave";

CREATE POLICY "rls_admin_insert_leave"
ON public."Leave"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_leave" ON public."Leave";

CREATE POLICY "rls_admin_update_leave"
ON public."Leave"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_leave" ON public."Leave";

CREATE POLICY "rls_admin_delete_leave"
ON public."Leave"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Position uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_position" ON public."Position";

CREATE POLICY "rls_admin_select_position"
ON public."Position"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_position" ON public."Position";

CREATE POLICY "rls_admin_insert_position"
ON public."Position"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_position" ON public."Position";

CREATE POLICY "rls_admin_update_position"
ON public."Position"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_position" ON public."Position";

CREATE POLICY "rls_admin_delete_position"
ON public."Position"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PositionBudget uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_positionbudget" ON public."PositionBudget";

CREATE POLICY "rls_admin_select_positionbudget"
ON public."PositionBudget"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_positionbudget" ON public."PositionBudget";

CREATE POLICY "rls_admin_insert_positionbudget"
ON public."PositionBudget"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_positionbudget" ON public."PositionBudget";

CREATE POLICY "rls_admin_update_positionbudget"
ON public."PositionBudget"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_positionbudget" ON public."PositionBudget";

CREATE POLICY "rls_admin_delete_positionbudget"
ON public."PositionBudget"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: JobProfile uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_jobprofile" ON public."JobProfile";

CREATE POLICY "rls_admin_select_jobprofile"
ON public."JobProfile"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_jobprofile" ON public."JobProfile";

CREATE POLICY "rls_admin_insert_jobprofile"
ON public."JobProfile"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_jobprofile" ON public."JobProfile";

CREATE POLICY "rls_admin_update_jobprofile"
ON public."JobProfile"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_jobprofile" ON public."JobProfile";

CREATE POLICY "rls_admin_delete_jobprofile"
ON public."JobProfile"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: JobFamily uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_jobfamily" ON public."JobFamily";

CREATE POLICY "rls_admin_select_jobfamily"
ON public."JobFamily"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_jobfamily" ON public."JobFamily";

CREATE POLICY "rls_admin_insert_jobfamily"
ON public."JobFamily"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_jobfamily" ON public."JobFamily";

CREATE POLICY "rls_admin_update_jobfamily"
ON public."JobFamily"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_jobfamily" ON public."JobFamily";

CREATE POLICY "rls_admin_delete_jobfamily"
ON public."JobFamily"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Grade uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_grade" ON public."Grade";

CREATE POLICY "rls_admin_select_grade"
ON public."Grade"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_grade" ON public."Grade";

CREATE POLICY "rls_admin_insert_grade"
ON public."Grade"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_grade" ON public."Grade";

CREATE POLICY "rls_admin_update_grade"
ON public."Grade"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_grade" ON public."Grade";

CREATE POLICY "rls_admin_delete_grade"
ON public."Grade"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayGroup uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_paygroup" ON public."PayGroup";

CREATE POLICY "rls_admin_select_paygroup"
ON public."PayGroup"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_paygroup" ON public."PayGroup";

CREATE POLICY "rls_admin_insert_paygroup"
ON public."PayGroup"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_paygroup" ON public."PayGroup";

CREATE POLICY "rls_admin_update_paygroup"
ON public."PayGroup"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_paygroup" ON public."PayGroup";

CREATE POLICY "rls_admin_delete_paygroup"
ON public."PayGroup"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayCalendar uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_paycalendar" ON public."PayCalendar";

CREATE POLICY "rls_admin_select_paycalendar"
ON public."PayCalendar"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_paycalendar" ON public."PayCalendar";

CREATE POLICY "rls_admin_insert_paycalendar"
ON public."PayCalendar"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_paycalendar" ON public."PayCalendar";

CREATE POLICY "rls_admin_update_paycalendar"
ON public."PayCalendar"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_paycalendar" ON public."PayCalendar";

CREATE POLICY "rls_admin_delete_paycalendar"
ON public."PayCalendar"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: OrgUnit uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_orgunit" ON public."OrgUnit";

CREATE POLICY "rls_admin_select_orgunit"
ON public."OrgUnit"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_orgunit" ON public."OrgUnit";

CREATE POLICY "rls_admin_insert_orgunit"
ON public."OrgUnit"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_orgunit" ON public."OrgUnit";

CREATE POLICY "rls_admin_update_orgunit"
ON public."OrgUnit"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_orgunit" ON public."OrgUnit";

CREATE POLICY "rls_admin_delete_orgunit"
ON public."OrgUnit"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Department uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_department" ON public."Department";

CREATE POLICY "rls_admin_select_department"
ON public."Department"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_department" ON public."Department";

CREATE POLICY "rls_admin_insert_department"
ON public."Department"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_department" ON public."Department";

CREATE POLICY "rls_admin_update_department"
ON public."Department"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_department" ON public."Department";

CREATE POLICY "rls_admin_delete_department"
ON public."Department"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: CostCenter uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_costcenter" ON public."CostCenter";

CREATE POLICY "rls_admin_select_costcenter"
ON public."CostCenter"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_costcenter" ON public."CostCenter";

CREATE POLICY "rls_admin_insert_costcenter"
ON public."CostCenter"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_costcenter" ON public."CostCenter";

CREATE POLICY "rls_admin_update_costcenter"
ON public."CostCenter"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_costcenter" ON public."CostCenter";

CREATE POLICY "rls_admin_delete_costcenter"
ON public."CostCenter"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Location uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_location" ON public."Location";

CREATE POLICY "rls_admin_select_location"
ON public."Location"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_location" ON public."Location";

CREATE POLICY "rls_admin_insert_location"
ON public."Location"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_location" ON public."Location";

CREATE POLICY "rls_admin_update_location"
ON public."Location"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_location" ON public."Location";

CREATE POLICY "rls_admin_delete_location"
ON public."Location"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: HolidayCalendar uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_holidaycalendar" ON public."HolidayCalendar";

CREATE POLICY "rls_admin_select_holidaycalendar"
ON public."HolidayCalendar"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_holidaycalendar" ON public."HolidayCalendar";

CREATE POLICY "rls_admin_insert_holidaycalendar"
ON public."HolidayCalendar"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_holidaycalendar" ON public."HolidayCalendar";

CREATE POLICY "rls_admin_update_holidaycalendar"
ON public."HolidayCalendar"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_holidaycalendar" ON public."HolidayCalendar";

CREATE POLICY "rls_admin_delete_holidaycalendar"
ON public."HolidayCalendar"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Account uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_account" ON public."Account";

CREATE POLICY "rls_admin_select_account"
ON public."Account"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_account" ON public."Account";

CREATE POLICY "rls_admin_insert_account"
ON public."Account"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_account" ON public."Account";

CREATE POLICY "rls_admin_update_account"
ON public."Account"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_account" ON public."Account";

CREATE POLICY "rls_admin_delete_account"
ON public."Account"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Contact uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_contact" ON public."Contact";

CREATE POLICY "rls_admin_select_contact"
ON public."Contact"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_contact" ON public."Contact";

CREATE POLICY "rls_admin_insert_contact"
ON public."Contact"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_contact" ON public."Contact";

CREATE POLICY "rls_admin_update_contact"
ON public."Contact"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_contact" ON public."Contact";

CREATE POLICY "rls_admin_delete_contact"
ON public."Contact"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AccountAddress uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_accountaddress" ON public."AccountAddress";

CREATE POLICY "rls_admin_select_accountaddress"
ON public."AccountAddress"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_accountaddress" ON public."AccountAddress";

CREATE POLICY "rls_admin_insert_accountaddress"
ON public."AccountAddress"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_accountaddress" ON public."AccountAddress";

CREATE POLICY "rls_admin_update_accountaddress"
ON public."AccountAddress"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_accountaddress" ON public."AccountAddress";

CREATE POLICY "rls_admin_delete_accountaddress"
ON public."AccountAddress"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Contract uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_contract" ON public."Contract";

CREATE POLICY "rls_admin_select_contract"
ON public."Contract"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_contract" ON public."Contract";

CREATE POLICY "rls_admin_insert_contract"
ON public."Contract"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_contract" ON public."Contract";

CREATE POLICY "rls_admin_update_contract"
ON public."Contract"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_contract" ON public."Contract";

CREATE POLICY "rls_admin_delete_contract"
ON public."Contract"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Lead uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_lead" ON public."Lead";

CREATE POLICY "rls_admin_select_lead"
ON public."Lead"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_lead" ON public."Lead";

CREATE POLICY "rls_admin_insert_lead"
ON public."Lead"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_lead" ON public."Lead";

CREATE POLICY "rls_admin_update_lead"
ON public."Lead"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_lead" ON public."Lead";

CREATE POLICY "rls_admin_delete_lead"
ON public."Lead"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: LeadActivity uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_leadactivity" ON public."LeadActivity";

CREATE POLICY "rls_admin_select_leadactivity"
ON public."LeadActivity"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_leadactivity" ON public."LeadActivity";

CREATE POLICY "rls_admin_insert_leadactivity"
ON public."LeadActivity"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_leadactivity" ON public."LeadActivity";

CREATE POLICY "rls_admin_update_leadactivity"
ON public."LeadActivity"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_leadactivity" ON public."LeadActivity";

CREATE POLICY "rls_admin_delete_leadactivity"
ON public."LeadActivity"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Opportunity uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_opportunity" ON public."Opportunity";

CREATE POLICY "rls_admin_select_opportunity"
ON public."Opportunity"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_opportunity" ON public."Opportunity";

CREATE POLICY "rls_admin_insert_opportunity"
ON public."Opportunity"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_opportunity" ON public."Opportunity";

CREATE POLICY "rls_admin_update_opportunity"
ON public."Opportunity"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_opportunity" ON public."Opportunity";

CREATE POLICY "rls_admin_delete_opportunity"
ON public."Opportunity"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: OpportunityStage uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_opportunitystage" ON public."OpportunityStage";

CREATE POLICY "rls_admin_select_opportunitystage"
ON public."OpportunityStage"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_opportunitystage" ON public."OpportunityStage";

CREATE POLICY "rls_admin_insert_opportunitystage"
ON public."OpportunityStage"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_opportunitystage" ON public."OpportunityStage";

CREATE POLICY "rls_admin_update_opportunitystage"
ON public."OpportunityStage"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_opportunitystage" ON public."OpportunityStage";

CREATE POLICY "rls_admin_delete_opportunitystage"
ON public."OpportunityStage"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: OpportunityLineItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_opportunitylineitem" ON public."OpportunityLineItem";

CREATE POLICY "rls_admin_select_opportunitylineitem"
ON public."OpportunityLineItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_opportunitylineitem" ON public."OpportunityLineItem";

CREATE POLICY "rls_admin_insert_opportunitylineitem"
ON public."OpportunityLineItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_opportunitylineitem" ON public."OpportunityLineItem";

CREATE POLICY "rls_admin_update_opportunitylineitem"
ON public."OpportunityLineItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_opportunitylineitem" ON public."OpportunityLineItem";

CREATE POLICY "rls_admin_delete_opportunitylineitem"
ON public."OpportunityLineItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Quote uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_quote" ON public."Quote";

CREATE POLICY "rls_admin_select_quote"
ON public."Quote"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_quote" ON public."Quote";

CREATE POLICY "rls_admin_insert_quote"
ON public."Quote"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_quote" ON public."Quote";

CREATE POLICY "rls_admin_update_quote"
ON public."Quote"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_quote" ON public."Quote";

CREATE POLICY "rls_admin_delete_quote"
ON public."Quote"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: QuoteLineItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_quotelineitem" ON public."QuoteLineItem";

CREATE POLICY "rls_admin_select_quotelineitem"
ON public."QuoteLineItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_quotelineitem" ON public."QuoteLineItem";

CREATE POLICY "rls_admin_insert_quotelineitem"
ON public."QuoteLineItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_quotelineitem" ON public."QuoteLineItem";

CREATE POLICY "rls_admin_update_quotelineitem"
ON public."QuoteLineItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_quotelineitem" ON public."QuoteLineItem";

CREATE POLICY "rls_admin_delete_quotelineitem"
ON public."QuoteLineItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Activity uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_activity" ON public."Activity";

CREATE POLICY "rls_admin_select_activity"
ON public."Activity"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_activity" ON public."Activity";

CREATE POLICY "rls_admin_insert_activity"
ON public."Activity"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_activity" ON public."Activity";

CREATE POLICY "rls_admin_update_activity"
ON public."Activity"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_activity" ON public."Activity";

CREATE POLICY "rls_admin_delete_activity"
ON public."Activity"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ActivityAttachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_activityattachment" ON public."ActivityAttachment";

CREATE POLICY "rls_admin_select_activityattachment"
ON public."ActivityAttachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_activityattachment" ON public."ActivityAttachment";

CREATE POLICY "rls_admin_insert_activityattachment"
ON public."ActivityAttachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_activityattachment" ON public."ActivityAttachment";

CREATE POLICY "rls_admin_update_activityattachment"
ON public."ActivityAttachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_activityattachment" ON public."ActivityAttachment";

CREATE POLICY "rls_admin_delete_activityattachment"
ON public."ActivityAttachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantPriceList uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantpricelist" ON public."TenantPriceList";

CREATE POLICY "rls_admin_select_tenantpricelist"
ON public."TenantPriceList"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantpricelist" ON public."TenantPriceList";

CREATE POLICY "rls_admin_insert_tenantpricelist"
ON public."TenantPriceList"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantpricelist" ON public."TenantPriceList";

CREATE POLICY "rls_admin_update_tenantpricelist"
ON public."TenantPriceList"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantpricelist" ON public."TenantPriceList";

CREATE POLICY "rls_admin_delete_tenantpricelist"
ON public."TenantPriceList"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TenantPriceOverride uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_tenantpriceoverride" ON public."TenantPriceOverride";

CREATE POLICY "rls_admin_select_tenantpriceoverride"
ON public."TenantPriceOverride"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_tenantpriceoverride" ON public."TenantPriceOverride";

CREATE POLICY "rls_admin_insert_tenantpriceoverride"
ON public."TenantPriceOverride"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_tenantpriceoverride" ON public."TenantPriceOverride";

CREATE POLICY "rls_admin_update_tenantpriceoverride"
ON public."TenantPriceOverride"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_tenantpriceoverride" ON public."TenantPriceOverride";

CREATE POLICY "rls_admin_delete_tenantpriceoverride"
ON public."TenantPriceOverride"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Estimate uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimate" ON public."Estimate";

CREATE POLICY "rls_admin_select_estimate"
ON public."Estimate"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimate" ON public."Estimate";

CREATE POLICY "rls_admin_insert_estimate"
ON public."Estimate"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimate" ON public."Estimate";

CREATE POLICY "rls_admin_update_estimate"
ON public."Estimate"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimate" ON public."Estimate";

CREATE POLICY "rls_admin_delete_estimate"
ON public."Estimate"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateRevision uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimaterevision" ON public."EstimateRevision";

CREATE POLICY "rls_admin_select_estimaterevision"
ON public."EstimateRevision"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimaterevision" ON public."EstimateRevision";

CREATE POLICY "rls_admin_insert_estimaterevision"
ON public."EstimateRevision"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimaterevision" ON public."EstimateRevision";

CREATE POLICY "rls_admin_update_estimaterevision"
ON public."EstimateRevision"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimaterevision" ON public."EstimateRevision";

CREATE POLICY "rls_admin_delete_estimaterevision"
ON public."EstimateRevision"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateLineItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimatelineitem" ON public."EstimateLineItem";

CREATE POLICY "rls_admin_select_estimatelineitem"
ON public."EstimateLineItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimatelineitem" ON public."EstimateLineItem";

CREATE POLICY "rls_admin_insert_estimatelineitem"
ON public."EstimateLineItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimatelineitem" ON public."EstimateLineItem";

CREATE POLICY "rls_admin_update_estimatelineitem"
ON public."EstimateLineItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimatelineitem" ON public."EstimateLineItem";

CREATE POLICY "rls_admin_delete_estimatelineitem"
ON public."EstimateLineItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateTax uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimatetax" ON public."EstimateTax";

CREATE POLICY "rls_admin_select_estimatetax"
ON public."EstimateTax"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimatetax" ON public."EstimateTax";

CREATE POLICY "rls_admin_insert_estimatetax"
ON public."EstimateTax"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimatetax" ON public."EstimateTax";

CREATE POLICY "rls_admin_update_estimatetax"
ON public."EstimateTax"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimatetax" ON public."EstimateTax";

CREATE POLICY "rls_admin_delete_estimatetax"
ON public."EstimateTax"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateDiscount uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimatediscount" ON public."EstimateDiscount";

CREATE POLICY "rls_admin_select_estimatediscount"
ON public."EstimateDiscount"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimatediscount" ON public."EstimateDiscount";

CREATE POLICY "rls_admin_insert_estimatediscount"
ON public."EstimateDiscount"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimatediscount" ON public."EstimateDiscount";

CREATE POLICY "rls_admin_update_estimatediscount"
ON public."EstimateDiscount"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimatediscount" ON public."EstimateDiscount";

CREATE POLICY "rls_admin_delete_estimatediscount"
ON public."EstimateDiscount"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateTerm uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimateterm" ON public."EstimateTerm";

CREATE POLICY "rls_admin_select_estimateterm"
ON public."EstimateTerm"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimateterm" ON public."EstimateTerm";

CREATE POLICY "rls_admin_insert_estimateterm"
ON public."EstimateTerm"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimateterm" ON public."EstimateTerm";

CREATE POLICY "rls_admin_update_estimateterm"
ON public."EstimateTerm"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimateterm" ON public."EstimateTerm";

CREATE POLICY "rls_admin_delete_estimateterm"
ON public."EstimateTerm"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateAttachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimateattachment" ON public."EstimateAttachment";

CREATE POLICY "rls_admin_select_estimateattachment"
ON public."EstimateAttachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimateattachment" ON public."EstimateAttachment";

CREATE POLICY "rls_admin_insert_estimateattachment"
ON public."EstimateAttachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimateattachment" ON public."EstimateAttachment";

CREATE POLICY "rls_admin_update_estimateattachment"
ON public."EstimateAttachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimateattachment" ON public."EstimateAttachment";

CREATE POLICY "rls_admin_delete_estimateattachment"
ON public."EstimateAttachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimateapproval" ON public."EstimateApproval";

CREATE POLICY "rls_admin_select_estimateapproval"
ON public."EstimateApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimateapproval" ON public."EstimateApproval";

CREATE POLICY "rls_admin_insert_estimateapproval"
ON public."EstimateApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimateapproval" ON public."EstimateApproval";

CREATE POLICY "rls_admin_update_estimateapproval"
ON public."EstimateApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimateapproval" ON public."EstimateApproval";

CREATE POLICY "rls_admin_delete_estimateapproval"
ON public."EstimateApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Bid uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_bid" ON public."Bid";

CREATE POLICY "rls_admin_select_bid"
ON public."Bid"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_bid" ON public."Bid";

CREATE POLICY "rls_admin_insert_bid"
ON public."Bid"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_bid" ON public."Bid";

CREATE POLICY "rls_admin_update_bid"
ON public."Bid"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_bid" ON public."Bid";

CREATE POLICY "rls_admin_delete_bid"
ON public."Bid"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BidInvitation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_bidinvitation" ON public."BidInvitation";

CREATE POLICY "rls_admin_select_bidinvitation"
ON public."BidInvitation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_bidinvitation" ON public."BidInvitation";

CREATE POLICY "rls_admin_insert_bidinvitation"
ON public."BidInvitation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_bidinvitation" ON public."BidInvitation";

CREATE POLICY "rls_admin_update_bidinvitation"
ON public."BidInvitation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_bidinvitation" ON public."BidInvitation";

CREATE POLICY "rls_admin_delete_bidinvitation"
ON public."BidInvitation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BidSubmission uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_bidsubmission" ON public."BidSubmission";

CREATE POLICY "rls_admin_select_bidsubmission"
ON public."BidSubmission"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_bidsubmission" ON public."BidSubmission";

CREATE POLICY "rls_admin_insert_bidsubmission"
ON public."BidSubmission"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_bidsubmission" ON public."BidSubmission";

CREATE POLICY "rls_admin_update_bidsubmission"
ON public."BidSubmission"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_bidsubmission" ON public."BidSubmission";

CREATE POLICY "rls_admin_delete_bidsubmission"
ON public."BidSubmission"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BidComparison uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_bidcomparison" ON public."BidComparison";

CREATE POLICY "rls_admin_select_bidcomparison"
ON public."BidComparison"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_bidcomparison" ON public."BidComparison";

CREATE POLICY "rls_admin_insert_bidcomparison"
ON public."BidComparison"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_bidcomparison" ON public."BidComparison";

CREATE POLICY "rls_admin_update_bidcomparison"
ON public."BidComparison"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_bidcomparison" ON public."BidComparison";

CREATE POLICY "rls_admin_delete_bidcomparison"
ON public."BidComparison"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateComment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimatecomment" ON public."EstimateComment";

CREATE POLICY "rls_admin_select_estimatecomment"
ON public."EstimateComment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimatecomment" ON public."EstimateComment";

CREATE POLICY "rls_admin_insert_estimatecomment"
ON public."EstimateComment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimatecomment" ON public."EstimateComment";

CREATE POLICY "rls_admin_update_estimatecomment"
ON public."EstimateComment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimatecomment" ON public."EstimateComment";

CREATE POLICY "rls_admin_delete_estimatecomment"
ON public."EstimateComment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EstimateHistoryEvent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_estimatehistoryevent" ON public."EstimateHistoryEvent";

CREATE POLICY "rls_admin_select_estimatehistoryevent"
ON public."EstimateHistoryEvent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_estimatehistoryevent" ON public."EstimateHistoryEvent";

CREATE POLICY "rls_admin_insert_estimatehistoryevent"
ON public."EstimateHistoryEvent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_estimatehistoryevent" ON public."EstimateHistoryEvent";

CREATE POLICY "rls_admin_update_estimatehistoryevent"
ON public."EstimateHistoryEvent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_estimatehistoryevent" ON public."EstimateHistoryEvent";

CREATE POLICY "rls_admin_delete_estimatehistoryevent"
ON public."EstimateHistoryEvent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InvoiceLineItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_invoicelineitem" ON public."InvoiceLineItem";

CREATE POLICY "rls_admin_select_invoicelineitem"
ON public."InvoiceLineItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_invoicelineitem" ON public."InvoiceLineItem";

CREATE POLICY "rls_admin_insert_invoicelineitem"
ON public."InvoiceLineItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_invoicelineitem" ON public."InvoiceLineItem";

CREATE POLICY "rls_admin_update_invoicelineitem"
ON public."InvoiceLineItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_invoicelineitem" ON public."InvoiceLineItem";

CREATE POLICY "rls_admin_delete_invoicelineitem"
ON public."InvoiceLineItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InvoiceTax uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_invoicetax" ON public."InvoiceTax";

CREATE POLICY "rls_admin_select_invoicetax"
ON public."InvoiceTax"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_invoicetax" ON public."InvoiceTax";

CREATE POLICY "rls_admin_insert_invoicetax"
ON public."InvoiceTax"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_invoicetax" ON public."InvoiceTax";

CREATE POLICY "rls_admin_update_invoicetax"
ON public."InvoiceTax"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_invoicetax" ON public."InvoiceTax";

CREATE POLICY "rls_admin_delete_invoicetax"
ON public."InvoiceTax"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InvoiceAttachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_invoiceattachment" ON public."InvoiceAttachment";

CREATE POLICY "rls_admin_select_invoiceattachment"
ON public."InvoiceAttachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_invoiceattachment" ON public."InvoiceAttachment";

CREATE POLICY "rls_admin_insert_invoiceattachment"
ON public."InvoiceAttachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_invoiceattachment" ON public."InvoiceAttachment";

CREATE POLICY "rls_admin_update_invoiceattachment"
ON public."InvoiceAttachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_invoiceattachment" ON public."InvoiceAttachment";

CREATE POLICY "rls_admin_delete_invoiceattachment"
ON public."InvoiceAttachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PaymentSchedule uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_paymentschedule" ON public."PaymentSchedule";

CREATE POLICY "rls_admin_select_paymentschedule"
ON public."PaymentSchedule"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_paymentschedule" ON public."PaymentSchedule";

CREATE POLICY "rls_admin_insert_paymentschedule"
ON public."PaymentSchedule"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_paymentschedule" ON public."PaymentSchedule";

CREATE POLICY "rls_admin_update_paymentschedule"
ON public."PaymentSchedule"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_paymentschedule" ON public."PaymentSchedule";

CREATE POLICY "rls_admin_delete_paymentschedule"
ON public."PaymentSchedule"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DunningNotice uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_dunningnotice" ON public."DunningNotice";

CREATE POLICY "rls_admin_select_dunningnotice"
ON public."DunningNotice"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_dunningnotice" ON public."DunningNotice";

CREATE POLICY "rls_admin_insert_dunningnotice"
ON public."DunningNotice"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_dunningnotice" ON public."DunningNotice";

CREATE POLICY "rls_admin_update_dunningnotice"
ON public."DunningNotice"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_dunningnotice" ON public."DunningNotice";

CREATE POLICY "rls_admin_delete_dunningnotice"
ON public."DunningNotice"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PaymentApplication uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_paymentapplication" ON public."PaymentApplication";

CREATE POLICY "rls_admin_select_paymentapplication"
ON public."PaymentApplication"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_paymentapplication" ON public."PaymentApplication";

CREATE POLICY "rls_admin_insert_paymentapplication"
ON public."PaymentApplication"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_paymentapplication" ON public."PaymentApplication";

CREATE POLICY "rls_admin_update_paymentapplication"
ON public."PaymentApplication"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_paymentapplication" ON public."PaymentApplication";

CREATE POLICY "rls_admin_delete_paymentapplication"
ON public."PaymentApplication"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Refund uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_refund" ON public."Refund";

CREATE POLICY "rls_admin_select_refund"
ON public."Refund"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_refund" ON public."Refund";

CREATE POLICY "rls_admin_insert_refund"
ON public."Refund"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_refund" ON public."Refund";

CREATE POLICY "rls_admin_update_refund"
ON public."Refund"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_refund" ON public."Refund";

CREATE POLICY "rls_admin_delete_refund"
ON public."Refund"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Chargeback uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_chargeback" ON public."Chargeback";

CREATE POLICY "rls_admin_select_chargeback"
ON public."Chargeback"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_chargeback" ON public."Chargeback";

CREATE POLICY "rls_admin_insert_chargeback"
ON public."Chargeback"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_chargeback" ON public."Chargeback";

CREATE POLICY "rls_admin_update_chargeback"
ON public."Chargeback"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_chargeback" ON public."Chargeback";

CREATE POLICY "rls_admin_delete_chargeback"
ON public."Chargeback"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ChargebackEvidence uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_chargebackevidence" ON public."ChargebackEvidence";

CREATE POLICY "rls_admin_select_chargebackevidence"
ON public."ChargebackEvidence"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_chargebackevidence" ON public."ChargebackEvidence";

CREATE POLICY "rls_admin_insert_chargebackevidence"
ON public."ChargebackEvidence"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_chargebackevidence" ON public."ChargebackEvidence";

CREATE POLICY "rls_admin_update_chargebackevidence"
ON public."ChargebackEvidence"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_chargebackevidence" ON public."ChargebackEvidence";

CREATE POLICY "rls_admin_delete_chargebackevidence"
ON public."ChargebackEvidence"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InvoicePayment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_invoicepayment" ON public."InvoicePayment";

CREATE POLICY "rls_admin_select_invoicepayment"
ON public."InvoicePayment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_invoicepayment" ON public."InvoicePayment";

CREATE POLICY "rls_admin_insert_invoicepayment"
ON public."InvoicePayment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_invoicepayment" ON public."InvoicePayment";

CREATE POLICY "rls_admin_update_invoicepayment"
ON public."InvoicePayment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_invoicepayment" ON public."InvoicePayment";

CREATE POLICY "rls_admin_delete_invoicepayment"
ON public."InvoicePayment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PaymentMethodToken uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_paymentmethodtoken" ON public."PaymentMethodToken";

CREATE POLICY "rls_admin_select_paymentmethodtoken"
ON public."PaymentMethodToken"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_paymentmethodtoken" ON public."PaymentMethodToken";

CREATE POLICY "rls_admin_insert_paymentmethodtoken"
ON public."PaymentMethodToken"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_paymentmethodtoken" ON public."PaymentMethodToken";

CREATE POLICY "rls_admin_update_paymentmethodtoken"
ON public."PaymentMethodToken"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_paymentmethodtoken" ON public."PaymentMethodToken";

CREATE POLICY "rls_admin_delete_paymentmethodtoken"
ON public."PaymentMethodToken"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Payout uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_payout" ON public."Payout";

CREATE POLICY "rls_admin_select_payout"
ON public."Payout"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_payout" ON public."Payout";

CREATE POLICY "rls_admin_insert_payout"
ON public."Payout"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_payout" ON public."Payout";

CREATE POLICY "rls_admin_update_payout"
ON public."Payout"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_payout" ON public."Payout";

CREATE POLICY "rls_admin_delete_payout"
ON public."Payout"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BankAccount uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_bankaccount" ON public."BankAccount";

CREATE POLICY "rls_admin_select_bankaccount"
ON public."BankAccount"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_bankaccount" ON public."BankAccount";

CREATE POLICY "rls_admin_insert_bankaccount"
ON public."BankAccount"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_bankaccount" ON public."BankAccount";

CREATE POLICY "rls_admin_update_bankaccount"
ON public."BankAccount"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_bankaccount" ON public."BankAccount";

CREATE POLICY "rls_admin_delete_bankaccount"
ON public."BankAccount"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BankStatementLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_bankstatementline" ON public."BankStatementLine";

CREATE POLICY "rls_admin_select_bankstatementline"
ON public."BankStatementLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_bankstatementline" ON public."BankStatementLine";

CREATE POLICY "rls_admin_insert_bankstatementline"
ON public."BankStatementLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_bankstatementline" ON public."BankStatementLine";

CREATE POLICY "rls_admin_update_bankstatementline"
ON public."BankStatementLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_bankstatementline" ON public."BankStatementLine";

CREATE POLICY "rls_admin_delete_bankstatementline"
ON public."BankStatementLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Reconciliation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_reconciliation" ON public."Reconciliation";

CREATE POLICY "rls_admin_select_reconciliation"
ON public."Reconciliation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_reconciliation" ON public."Reconciliation";

CREATE POLICY "rls_admin_insert_reconciliation"
ON public."Reconciliation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_reconciliation" ON public."Reconciliation";

CREATE POLICY "rls_admin_update_reconciliation"
ON public."Reconciliation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_reconciliation" ON public."Reconciliation";

CREATE POLICY "rls_admin_delete_reconciliation"
ON public."Reconciliation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: VendorContact uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_vendorcontact" ON public."VendorContact";

CREATE POLICY "rls_admin_select_vendorcontact"
ON public."VendorContact"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_vendorcontact" ON public."VendorContact";

CREATE POLICY "rls_admin_insert_vendorcontact"
ON public."VendorContact"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_vendorcontact" ON public."VendorContact";

CREATE POLICY "rls_admin_update_vendorcontact"
ON public."VendorContact"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_vendorcontact" ON public."VendorContact";

CREATE POLICY "rls_admin_delete_vendorcontact"
ON public."VendorContact"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: VendorDocument uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_vendordocument" ON public."VendorDocument";

CREATE POLICY "rls_admin_select_vendordocument"
ON public."VendorDocument"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_vendordocument" ON public."VendorDocument";

CREATE POLICY "rls_admin_insert_vendordocument"
ON public."VendorDocument"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_vendordocument" ON public."VendorDocument";

CREATE POLICY "rls_admin_update_vendordocument"
ON public."VendorDocument"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_vendordocument" ON public."VendorDocument";

CREATE POLICY "rls_admin_delete_vendordocument"
ON public."VendorDocument"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RequestForQuote uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_requestforquote" ON public."RequestForQuote";

CREATE POLICY "rls_admin_select_requestforquote"
ON public."RequestForQuote"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_requestforquote" ON public."RequestForQuote";

CREATE POLICY "rls_admin_insert_requestforquote"
ON public."RequestForQuote"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_requestforquote" ON public."RequestForQuote";

CREATE POLICY "rls_admin_update_requestforquote"
ON public."RequestForQuote"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_requestforquote" ON public."RequestForQuote";

CREATE POLICY "rls_admin_delete_requestforquote"
ON public."RequestForQuote"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RFQLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_rfqline" ON public."RFQLine";

CREATE POLICY "rls_admin_select_rfqline"
ON public."RFQLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_rfqline" ON public."RFQLine";

CREATE POLICY "rls_admin_insert_rfqline"
ON public."RFQLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_rfqline" ON public."RFQLine";

CREATE POLICY "rls_admin_update_rfqline"
ON public."RFQLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_rfqline" ON public."RFQLine";

CREATE POLICY "rls_admin_delete_rfqline"
ON public."RFQLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RFQResponse uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_rfqresponse" ON public."RFQResponse";

CREATE POLICY "rls_admin_select_rfqresponse"
ON public."RFQResponse"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_rfqresponse" ON public."RFQResponse";

CREATE POLICY "rls_admin_insert_rfqresponse"
ON public."RFQResponse"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_rfqresponse" ON public."RFQResponse";

CREATE POLICY "rls_admin_update_rfqresponse"
ON public."RFQResponse"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_rfqresponse" ON public."RFQResponse";

CREATE POLICY "rls_admin_delete_rfqresponse"
ON public."RFQResponse"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RFQResponseLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_rfqresponseline" ON public."RFQResponseLine";

CREATE POLICY "rls_admin_select_rfqresponseline"
ON public."RFQResponseLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_rfqresponseline" ON public."RFQResponseLine";

CREATE POLICY "rls_admin_insert_rfqresponseline"
ON public."RFQResponseLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_rfqresponseline" ON public."RFQResponseLine";

CREATE POLICY "rls_admin_update_rfqresponseline"
ON public."RFQResponseLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_rfqresponseline" ON public."RFQResponseLine";

CREATE POLICY "rls_admin_delete_rfqresponseline"
ON public."RFQResponseLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PurchaseOrderApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_purchaseorderapproval" ON public."PurchaseOrderApproval";

CREATE POLICY "rls_admin_select_purchaseorderapproval"
ON public."PurchaseOrderApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_purchaseorderapproval" ON public."PurchaseOrderApproval";

CREATE POLICY "rls_admin_insert_purchaseorderapproval"
ON public."PurchaseOrderApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_purchaseorderapproval" ON public."PurchaseOrderApproval";

CREATE POLICY "rls_admin_update_purchaseorderapproval"
ON public."PurchaseOrderApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_purchaseorderapproval" ON public."PurchaseOrderApproval";

CREATE POLICY "rls_admin_delete_purchaseorderapproval"
ON public."PurchaseOrderApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: GoodsReceipt uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_goodsreceipt" ON public."GoodsReceipt";

CREATE POLICY "rls_admin_select_goodsreceipt"
ON public."GoodsReceipt"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_goodsreceipt" ON public."GoodsReceipt";

CREATE POLICY "rls_admin_insert_goodsreceipt"
ON public."GoodsReceipt"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_goodsreceipt" ON public."GoodsReceipt";

CREATE POLICY "rls_admin_update_goodsreceipt"
ON public."GoodsReceipt"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_goodsreceipt" ON public."GoodsReceipt";

CREATE POLICY "rls_admin_delete_goodsreceipt"
ON public."GoodsReceipt"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: GoodsReceiptLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_goodsreceiptline" ON public."GoodsReceiptLine";

CREATE POLICY "rls_admin_select_goodsreceiptline"
ON public."GoodsReceiptLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_goodsreceiptline" ON public."GoodsReceiptLine";

CREATE POLICY "rls_admin_insert_goodsreceiptline"
ON public."GoodsReceiptLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_goodsreceiptline" ON public."GoodsReceiptLine";

CREATE POLICY "rls_admin_update_goodsreceiptline"
ON public."GoodsReceiptLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_goodsreceiptline" ON public."GoodsReceiptLine";

CREATE POLICY "rls_admin_delete_goodsreceiptline"
ON public."GoodsReceiptLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BillApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_billapproval" ON public."BillApproval";

CREATE POLICY "rls_admin_select_billapproval"
ON public."BillApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_billapproval" ON public."BillApproval";

CREATE POLICY "rls_admin_insert_billapproval"
ON public."BillApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_billapproval" ON public."BillApproval";

CREATE POLICY "rls_admin_update_billapproval"
ON public."BillApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_billapproval" ON public."BillApproval";

CREATE POLICY "rls_admin_delete_billapproval"
ON public."BillApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: BillPayment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_billpayment" ON public."BillPayment";

CREATE POLICY "rls_admin_select_billpayment"
ON public."BillPayment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_billpayment" ON public."BillPayment";

CREATE POLICY "rls_admin_insert_billpayment"
ON public."BillPayment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_billpayment" ON public."BillPayment";

CREATE POLICY "rls_admin_update_billpayment"
ON public."BillPayment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_billpayment" ON public."BillPayment";

CREATE POLICY "rls_admin_delete_billpayment"
ON public."BillPayment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ExpenseLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_expenseline" ON public."ExpenseLine";

CREATE POLICY "rls_admin_select_expenseline"
ON public."ExpenseLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_expenseline" ON public."ExpenseLine";

CREATE POLICY "rls_admin_insert_expenseline"
ON public."ExpenseLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_expenseline" ON public."ExpenseLine";

CREATE POLICY "rls_admin_update_expenseline"
ON public."ExpenseLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_expenseline" ON public."ExpenseLine";

CREATE POLICY "rls_admin_delete_expenseline"
ON public."ExpenseLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ExpenseApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_expenseapproval" ON public."ExpenseApproval";

CREATE POLICY "rls_admin_select_expenseapproval"
ON public."ExpenseApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_expenseapproval" ON public."ExpenseApproval";

CREATE POLICY "rls_admin_insert_expenseapproval"
ON public."ExpenseApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_expenseapproval" ON public."ExpenseApproval";

CREATE POLICY "rls_admin_update_expenseapproval"
ON public."ExpenseApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_expenseapproval" ON public."ExpenseApproval";

CREATE POLICY "rls_admin_delete_expenseapproval"
ON public."ExpenseApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventoryitem" ON public."InventoryItem";

CREATE POLICY "rls_admin_select_inventoryitem"
ON public."InventoryItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventoryitem" ON public."InventoryItem";

CREATE POLICY "rls_admin_insert_inventoryitem"
ON public."InventoryItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventoryitem" ON public."InventoryItem";

CREATE POLICY "rls_admin_update_inventoryitem"
ON public."InventoryItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventoryitem" ON public."InventoryItem";

CREATE POLICY "rls_admin_delete_inventoryitem"
ON public."InventoryItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryAttachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventoryattachment" ON public."InventoryAttachment";

CREATE POLICY "rls_admin_select_inventoryattachment"
ON public."InventoryAttachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventoryattachment" ON public."InventoryAttachment";

CREATE POLICY "rls_admin_insert_inventoryattachment"
ON public."InventoryAttachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventoryattachment" ON public."InventoryAttachment";

CREATE POLICY "rls_admin_update_inventoryattachment"
ON public."InventoryAttachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventoryattachment" ON public."InventoryAttachment";

CREATE POLICY "rls_admin_delete_inventoryattachment"
ON public."InventoryAttachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryLocation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventorylocation" ON public."InventoryLocation";

CREATE POLICY "rls_admin_select_inventorylocation"
ON public."InventoryLocation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventorylocation" ON public."InventoryLocation";

CREATE POLICY "rls_admin_insert_inventorylocation"
ON public."InventoryLocation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventorylocation" ON public."InventoryLocation";

CREATE POLICY "rls_admin_update_inventorylocation"
ON public."InventoryLocation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventorylocation" ON public."InventoryLocation";

CREATE POLICY "rls_admin_delete_inventorylocation"
ON public."InventoryLocation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryBin uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventorybin" ON public."InventoryBin";

CREATE POLICY "rls_admin_select_inventorybin"
ON public."InventoryBin"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventorybin" ON public."InventoryBin";

CREATE POLICY "rls_admin_insert_inventorybin"
ON public."InventoryBin"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventorybin" ON public."InventoryBin";

CREATE POLICY "rls_admin_update_inventorybin"
ON public."InventoryBin"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventorybin" ON public."InventoryBin";

CREATE POLICY "rls_admin_delete_inventorybin"
ON public."InventoryBin"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryTransaction uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventorytransaction" ON public."InventoryTransaction";

CREATE POLICY "rls_admin_select_inventorytransaction"
ON public."InventoryTransaction"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventorytransaction" ON public."InventoryTransaction";

CREATE POLICY "rls_admin_insert_inventorytransaction"
ON public."InventoryTransaction"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventorytransaction" ON public."InventoryTransaction";

CREATE POLICY "rls_admin_update_inventorytransaction"
ON public."InventoryTransaction"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventorytransaction" ON public."InventoryTransaction";

CREATE POLICY "rls_admin_delete_inventorytransaction"
ON public."InventoryTransaction"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryReservation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventoryreservation" ON public."InventoryReservation";

CREATE POLICY "rls_admin_select_inventoryreservation"
ON public."InventoryReservation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventoryreservation" ON public."InventoryReservation";

CREATE POLICY "rls_admin_insert_inventoryreservation"
ON public."InventoryReservation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventoryreservation" ON public."InventoryReservation";

CREATE POLICY "rls_admin_update_inventoryreservation"
ON public."InventoryReservation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventoryreservation" ON public."InventoryReservation";

CREATE POLICY "rls_admin_delete_inventoryreservation"
ON public."InventoryReservation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryCount uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventorycount" ON public."InventoryCount";

CREATE POLICY "rls_admin_select_inventorycount"
ON public."InventoryCount"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventorycount" ON public."InventoryCount";

CREATE POLICY "rls_admin_insert_inventorycount"
ON public."InventoryCount"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventorycount" ON public."InventoryCount";

CREATE POLICY "rls_admin_update_inventorycount"
ON public."InventoryCount"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventorycount" ON public."InventoryCount";

CREATE POLICY "rls_admin_delete_inventorycount"
ON public."InventoryCount"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryCountLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventorycountline" ON public."InventoryCountLine";

CREATE POLICY "rls_admin_select_inventorycountline"
ON public."InventoryCountLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventorycountline" ON public."InventoryCountLine";

CREATE POLICY "rls_admin_insert_inventorycountline"
ON public."InventoryCountLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventorycountline" ON public."InventoryCountLine";

CREATE POLICY "rls_admin_update_inventorycountline"
ON public."InventoryCountLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventorycountline" ON public."InventoryCountLine";

CREATE POLICY "rls_admin_delete_inventorycountline"
ON public."InventoryCountLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AssetAssignment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_assetassignment" ON public."AssetAssignment";

CREATE POLICY "rls_admin_select_assetassignment"
ON public."AssetAssignment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_assetassignment" ON public."AssetAssignment";

CREATE POLICY "rls_admin_insert_assetassignment"
ON public."AssetAssignment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_assetassignment" ON public."AssetAssignment";

CREATE POLICY "rls_admin_update_assetassignment"
ON public."AssetAssignment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_assetassignment" ON public."AssetAssignment";

CREATE POLICY "rls_admin_delete_assetassignment"
ON public."AssetAssignment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AssetDepreciation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_assetdepreciation" ON public."AssetDepreciation";

CREATE POLICY "rls_admin_select_assetdepreciation"
ON public."AssetDepreciation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_assetdepreciation" ON public."AssetDepreciation";

CREATE POLICY "rls_admin_insert_assetdepreciation"
ON public."AssetDepreciation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_assetdepreciation" ON public."AssetDepreciation";

CREATE POLICY "rls_admin_update_assetdepreciation"
ON public."AssetDepreciation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_assetdepreciation" ON public."AssetDepreciation";

CREATE POLICY "rls_admin_delete_assetdepreciation"
ON public."AssetDepreciation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AssetDocument uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_assetdocument" ON public."AssetDocument";

CREATE POLICY "rls_admin_select_assetdocument"
ON public."AssetDocument"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_assetdocument" ON public."AssetDocument";

CREATE POLICY "rls_admin_insert_assetdocument"
ON public."AssetDocument"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_assetdocument" ON public."AssetDocument";

CREATE POLICY "rls_admin_update_assetdocument"
ON public."AssetDocument"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_assetdocument" ON public."AssetDocument";

CREATE POLICY "rls_admin_delete_assetdocument"
ON public."AssetDocument"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AssetMeterReading uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_assetmeterreading" ON public."AssetMeterReading";

CREATE POLICY "rls_admin_select_assetmeterreading"
ON public."AssetMeterReading"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_assetmeterreading" ON public."AssetMeterReading";

CREATE POLICY "rls_admin_insert_assetmeterreading"
ON public."AssetMeterReading"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_assetmeterreading" ON public."AssetMeterReading";

CREATE POLICY "rls_admin_update_assetmeterreading"
ON public."AssetMeterReading"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_assetmeterreading" ON public."AssetMeterReading";

CREATE POLICY "rls_admin_delete_assetmeterreading"
ON public."AssetMeterReading"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: LossInvestigation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_lossinvestigation" ON public."LossInvestigation";

CREATE POLICY "rls_admin_select_lossinvestigation"
ON public."LossInvestigation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_lossinvestigation" ON public."LossInvestigation";

CREATE POLICY "rls_admin_insert_lossinvestigation"
ON public."LossInvestigation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_lossinvestigation" ON public."LossInvestigation";

CREATE POLICY "rls_admin_update_lossinvestigation"
ON public."LossInvestigation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_lossinvestigation" ON public."LossInvestigation";

CREATE POLICY "rls_admin_delete_lossinvestigation"
ON public."LossInvestigation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: LossInvestigationFinding uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_lossinvestigationfinding" ON public."LossInvestigationFinding";

CREATE POLICY "rls_admin_select_lossinvestigationfinding"
ON public."LossInvestigationFinding"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_lossinvestigationfinding" ON public."LossInvestigationFinding";

CREATE POLICY "rls_admin_insert_lossinvestigationfinding"
ON public."LossInvestigationFinding"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_lossinvestigationfinding" ON public."LossInvestigationFinding";

CREATE POLICY "rls_admin_update_lossinvestigationfinding"
ON public."LossInvestigationFinding"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_lossinvestigationfinding" ON public."LossInvestigationFinding";

CREATE POLICY "rls_admin_delete_lossinvestigationfinding"
ON public."LossInvestigationFinding"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ReturnReminder uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_returnreminder" ON public."ReturnReminder";

CREATE POLICY "rls_admin_select_returnreminder"
ON public."ReturnReminder"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_returnreminder" ON public."ReturnReminder";

CREATE POLICY "rls_admin_insert_returnreminder"
ON public."ReturnReminder"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_returnreminder" ON public."ReturnReminder";

CREATE POLICY "rls_admin_update_returnreminder"
ON public."ReturnReminder"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_returnreminder" ON public."ReturnReminder";

CREATE POLICY "rls_admin_delete_returnreminder"
ON public."ReturnReminder"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ReturnReminderAttempt uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_returnreminderattempt" ON public."ReturnReminderAttempt";

CREATE POLICY "rls_admin_select_returnreminderattempt"
ON public."ReturnReminderAttempt"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_returnreminderattempt" ON public."ReturnReminderAttempt";

CREATE POLICY "rls_admin_insert_returnreminderattempt"
ON public."ReturnReminderAttempt"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_returnreminderattempt" ON public."ReturnReminderAttempt";

CREATE POLICY "rls_admin_update_returnreminderattempt"
ON public."ReturnReminderAttempt"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_returnreminderattempt" ON public."ReturnReminderAttempt";

CREATE POLICY "rls_admin_delete_returnreminderattempt"
ON public."ReturnReminderAttempt"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DistributedLock uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_distributedlock" ON public."DistributedLock";

CREATE POLICY "rls_admin_select_distributedlock"
ON public."DistributedLock"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_distributedlock" ON public."DistributedLock";

CREATE POLICY "rls_admin_insert_distributedlock"
ON public."DistributedLock"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_distributedlock" ON public."DistributedLock";

CREATE POLICY "rls_admin_update_distributedlock"
ON public."DistributedLock"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_distributedlock" ON public."DistributedLock";

CREATE POLICY "rls_admin_delete_distributedlock"
ON public."DistributedLock"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryTransactionChain uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventorytransactionchain" ON public."InventoryTransactionChain";

CREATE POLICY "rls_admin_select_inventorytransactionchain"
ON public."InventoryTransactionChain"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventorytransactionchain" ON public."InventoryTransactionChain";

CREATE POLICY "rls_admin_insert_inventorytransactionchain"
ON public."InventoryTransactionChain"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventorytransactionchain" ON public."InventoryTransactionChain";

CREATE POLICY "rls_admin_update_inventorytransactionchain"
ON public."InventoryTransactionChain"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventorytransactionchain" ON public."InventoryTransactionChain";

CREATE POLICY "rls_admin_delete_inventorytransactionchain"
ON public."InventoryTransactionChain"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayrollItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_payrollitem" ON public."PayrollItem";

CREATE POLICY "rls_admin_select_payrollitem"
ON public."PayrollItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_payrollitem" ON public."PayrollItem";

CREATE POLICY "rls_admin_insert_payrollitem"
ON public."PayrollItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_payrollitem" ON public."PayrollItem";

CREATE POLICY "rls_admin_update_payrollitem"
ON public."PayrollItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_payrollitem" ON public."PayrollItem";

CREATE POLICY "rls_admin_delete_payrollitem"
ON public."PayrollItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayrollTax uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_payrolltax" ON public."PayrollTax";

CREATE POLICY "rls_admin_select_payrolltax"
ON public."PayrollTax"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_payrolltax" ON public."PayrollTax";

CREATE POLICY "rls_admin_insert_payrolltax"
ON public."PayrollTax"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_payrolltax" ON public."PayrollTax";

CREATE POLICY "rls_admin_update_payrolltax"
ON public."PayrollTax"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_payrolltax" ON public."PayrollTax";

CREATE POLICY "rls_admin_delete_payrolltax"
ON public."PayrollTax"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayrollAdjustment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_payrolladjustment" ON public."PayrollAdjustment";

CREATE POLICY "rls_admin_select_payrolladjustment"
ON public."PayrollAdjustment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_payrolladjustment" ON public."PayrollAdjustment";

CREATE POLICY "rls_admin_insert_payrolladjustment"
ON public."PayrollAdjustment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_payrolladjustment" ON public."PayrollAdjustment";

CREATE POLICY "rls_admin_update_payrolladjustment"
ON public."PayrollAdjustment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_payrolladjustment" ON public."PayrollAdjustment";

CREATE POLICY "rls_admin_delete_payrolladjustment"
ON public."PayrollAdjustment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayrollPayment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_payrollpayment" ON public."PayrollPayment";

CREATE POLICY "rls_admin_select_payrollpayment"
ON public."PayrollPayment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_payrollpayment" ON public."PayrollPayment";

CREATE POLICY "rls_admin_insert_payrollpayment"
ON public."PayrollPayment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_payrollpayment" ON public."PayrollPayment";

CREATE POLICY "rls_admin_update_payrollpayment"
ON public."PayrollPayment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_payrollpayment" ON public."PayrollPayment";

CREATE POLICY "rls_admin_delete_payrollpayment"
ON public."PayrollPayment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayStatement uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_paystatement" ON public."PayStatement";

CREATE POLICY "rls_admin_select_paystatement"
ON public."PayStatement"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_paystatement" ON public."PayStatement";

CREATE POLICY "rls_admin_insert_paystatement"
ON public."PayStatement"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_paystatement" ON public."PayStatement";

CREATE POLICY "rls_admin_update_paystatement"
ON public."PayStatement"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_paystatement" ON public."PayStatement";

CREATE POLICY "rls_admin_delete_paystatement"
ON public."PayStatement"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ClockInClockOut uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_clockinclockout" ON public."ClockInClockOut";

CREATE POLICY "rls_admin_select_clockinclockout"
ON public."ClockInClockOut"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_clockinclockout" ON public."ClockInClockOut";

CREATE POLICY "rls_admin_insert_clockinclockout"
ON public."ClockInClockOut"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_clockinclockout" ON public."ClockInClockOut";

CREATE POLICY "rls_admin_update_clockinclockout"
ON public."ClockInClockOut"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_clockinclockout" ON public."ClockInClockOut";

CREATE POLICY "rls_admin_delete_clockinclockout"
ON public."ClockInClockOut"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: OvertimeRule uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_overtimerule" ON public."OvertimeRule";

CREATE POLICY "rls_admin_select_overtimerule"
ON public."OvertimeRule"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_overtimerule" ON public."OvertimeRule";

CREATE POLICY "rls_admin_insert_overtimerule"
ON public."OvertimeRule"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_overtimerule" ON public."OvertimeRule";

CREATE POLICY "rls_admin_update_overtimerule"
ON public."OvertimeRule"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_overtimerule" ON public."OvertimeRule";

CREATE POLICY "rls_admin_delete_overtimerule"
ON public."OvertimeRule"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Allowance uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_allowance" ON public."Allowance";

CREATE POLICY "rls_admin_select_allowance"
ON public."Allowance"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_allowance" ON public."Allowance";

CREATE POLICY "rls_admin_insert_allowance"
ON public."Allowance"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_allowance" ON public."Allowance";

CREATE POLICY "rls_admin_update_allowance"
ON public."Allowance"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_allowance" ON public."Allowance";

CREATE POLICY "rls_admin_delete_allowance"
ON public."Allowance"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Deduction uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_deduction" ON public."Deduction";

CREATE POLICY "rls_admin_select_deduction"
ON public."Deduction"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_deduction" ON public."Deduction";

CREATE POLICY "rls_admin_insert_deduction"
ON public."Deduction"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_deduction" ON public."Deduction";

CREATE POLICY "rls_admin_update_deduction"
ON public."Deduction"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_deduction" ON public."Deduction";

CREATE POLICY "rls_admin_delete_deduction"
ON public."Deduction"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Reimbursement uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_reimbursement" ON public."Reimbursement";

CREATE POLICY "rls_admin_select_reimbursement"
ON public."Reimbursement"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_reimbursement" ON public."Reimbursement";

CREATE POLICY "rls_admin_insert_reimbursement"
ON public."Reimbursement"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_reimbursement" ON public."Reimbursement";

CREATE POLICY "rls_admin_update_reimbursement"
ON public."Reimbursement"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_reimbursement" ON public."Reimbursement";

CREATE POLICY "rls_admin_delete_reimbursement"
ON public."Reimbursement"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ApprovalRule uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_approvalrule" ON public."ApprovalRule";

CREATE POLICY "rls_admin_select_approvalrule"
ON public."ApprovalRule"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_approvalrule" ON public."ApprovalRule";

CREATE POLICY "rls_admin_insert_approvalrule"
ON public."ApprovalRule"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_approvalrule" ON public."ApprovalRule";

CREATE POLICY "rls_admin_update_approvalrule"
ON public."ApprovalRule"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_approvalrule" ON public."ApprovalRule";

CREATE POLICY "rls_admin_delete_approvalrule"
ON public."ApprovalRule"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ApprovalRequest uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_approvalrequest" ON public."ApprovalRequest";

CREATE POLICY "rls_admin_select_approvalrequest"
ON public."ApprovalRequest"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_approvalrequest" ON public."ApprovalRequest";

CREATE POLICY "rls_admin_insert_approvalrequest"
ON public."ApprovalRequest"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_approvalrequest" ON public."ApprovalRequest";

CREATE POLICY "rls_admin_update_approvalrequest"
ON public."ApprovalRequest"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_approvalrequest" ON public."ApprovalRequest";

CREATE POLICY "rls_admin_delete_approvalrequest"
ON public."ApprovalRequest"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ApprovalDecision uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_approvaldecision" ON public."ApprovalDecision";

CREATE POLICY "rls_admin_select_approvaldecision"
ON public."ApprovalDecision"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_approvaldecision" ON public."ApprovalDecision";

CREATE POLICY "rls_admin_insert_approvaldecision"
ON public."ApprovalDecision"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_approvaldecision" ON public."ApprovalDecision";

CREATE POLICY "rls_admin_update_approvaldecision"
ON public."ApprovalDecision"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_approvaldecision" ON public."ApprovalDecision";

CREATE POLICY "rls_admin_delete_approvaldecision"
ON public."ApprovalDecision"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ReasonCode uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_reasoncode" ON public."ReasonCode";

CREATE POLICY "rls_admin_select_reasoncode"
ON public."ReasonCode"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_reasoncode" ON public."ReasonCode";

CREATE POLICY "rls_admin_insert_reasoncode"
ON public."ReasonCode"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_reasoncode" ON public."ReasonCode";

CREATE POLICY "rls_admin_update_reasoncode"
ON public."ReasonCode"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_reasoncode" ON public."ReasonCode";

CREATE POLICY "rls_admin_delete_reasoncode"
ON public."ReasonCode"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: FraudPolicy uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_fraudpolicy" ON public."FraudPolicy";

CREATE POLICY "rls_admin_select_fraudpolicy"
ON public."FraudPolicy"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_fraudpolicy" ON public."FraudPolicy";

CREATE POLICY "rls_admin_insert_fraudpolicy"
ON public."FraudPolicy"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_fraudpolicy" ON public."FraudPolicy";

CREATE POLICY "rls_admin_update_fraudpolicy"
ON public."FraudPolicy"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_fraudpolicy" ON public."FraudPolicy";

CREATE POLICY "rls_admin_delete_fraudpolicy"
ON public."FraudPolicy"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: FraudPolicyRule uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_fraudpolicyrule" ON public."FraudPolicyRule";

CREATE POLICY "rls_admin_select_fraudpolicyrule"
ON public."FraudPolicyRule"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_fraudpolicyrule" ON public."FraudPolicyRule";

CREATE POLICY "rls_admin_insert_fraudpolicyrule"
ON public."FraudPolicyRule"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_fraudpolicyrule" ON public."FraudPolicyRule";

CREATE POLICY "rls_admin_update_fraudpolicyrule"
ON public."FraudPolicyRule"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_fraudpolicyrule" ON public."FraudPolicyRule";

CREATE POLICY "rls_admin_delete_fraudpolicyrule"
ON public."FraudPolicyRule"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: FraudPolicyScope uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_fraudpolicyscope" ON public."FraudPolicyScope";

CREATE POLICY "rls_admin_select_fraudpolicyscope"
ON public."FraudPolicyScope"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_fraudpolicyscope" ON public."FraudPolicyScope";

CREATE POLICY "rls_admin_insert_fraudpolicyscope"
ON public."FraudPolicyScope"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_fraudpolicyscope" ON public."FraudPolicyScope";

CREATE POLICY "rls_admin_update_fraudpolicyscope"
ON public."FraudPolicyScope"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_fraudpolicyscope" ON public."FraudPolicyScope";

CREATE POLICY "rls_admin_delete_fraudpolicyscope"
ON public."FraudPolicyScope"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AnomalySignal uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_anomalysignal" ON public."AnomalySignal";

CREATE POLICY "rls_admin_select_anomalysignal"
ON public."AnomalySignal"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_anomalysignal" ON public."AnomalySignal";

CREATE POLICY "rls_admin_insert_anomalysignal"
ON public."AnomalySignal"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_anomalysignal" ON public."AnomalySignal";

CREATE POLICY "rls_admin_update_anomalysignal"
ON public."AnomalySignal"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_anomalysignal" ON public."AnomalySignal";

CREATE POLICY "rls_admin_delete_anomalysignal"
ON public."AnomalySignal"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AnomalySignalFeature uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_anomalysignalfeature" ON public."AnomalySignalFeature";

CREATE POLICY "rls_admin_select_anomalysignalfeature"
ON public."AnomalySignalFeature"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_anomalysignalfeature" ON public."AnomalySignalFeature";

CREATE POLICY "rls_admin_insert_anomalysignalfeature"
ON public."AnomalySignalFeature"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_anomalysignalfeature" ON public."AnomalySignalFeature";

CREATE POLICY "rls_admin_update_anomalysignalfeature"
ON public."AnomalySignalFeature"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_anomalysignalfeature" ON public."AnomalySignalFeature";

CREATE POLICY "rls_admin_delete_anomalysignalfeature"
ON public."AnomalySignalFeature"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AnomalyCase uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_anomalycase" ON public."AnomalyCase";

CREATE POLICY "rls_admin_select_anomalycase"
ON public."AnomalyCase"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_anomalycase" ON public."AnomalyCase";

CREATE POLICY "rls_admin_insert_anomalycase"
ON public."AnomalyCase"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_anomalycase" ON public."AnomalyCase";

CREATE POLICY "rls_admin_update_anomalycase"
ON public."AnomalyCase"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_anomalycase" ON public."AnomalyCase";

CREATE POLICY "rls_admin_delete_anomalycase"
ON public."AnomalyCase"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AnomalyCaseAction uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_anomalycaseaction" ON public."AnomalyCaseAction";

CREATE POLICY "rls_admin_select_anomalycaseaction"
ON public."AnomalyCaseAction"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_anomalycaseaction" ON public."AnomalyCaseAction";

CREATE POLICY "rls_admin_insert_anomalycaseaction"
ON public."AnomalyCaseAction"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_anomalycaseaction" ON public."AnomalyCaseAction";

CREATE POLICY "rls_admin_update_anomalycaseaction"
ON public."AnomalyCaseAction"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_anomalycaseaction" ON public."AnomalyCaseAction";

CREATE POLICY "rls_admin_delete_anomalycaseaction"
ON public."AnomalyCaseAction"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DelegationGrant uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_delegationgrant" ON public."DelegationGrant";

CREATE POLICY "rls_admin_select_delegationgrant"
ON public."DelegationGrant"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_delegationgrant" ON public."DelegationGrant";

CREATE POLICY "rls_admin_insert_delegationgrant"
ON public."DelegationGrant"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_delegationgrant" ON public."DelegationGrant";

CREATE POLICY "rls_admin_update_delegationgrant"
ON public."DelegationGrant"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_delegationgrant" ON public."DelegationGrant";

CREATE POLICY "rls_admin_delete_delegationgrant"
ON public."DelegationGrant"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DelegationConstraint uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_delegationconstraint" ON public."DelegationConstraint";

CREATE POLICY "rls_admin_select_delegationconstraint"
ON public."DelegationConstraint"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_delegationconstraint" ON public."DelegationConstraint";

CREATE POLICY "rls_admin_insert_delegationconstraint"
ON public."DelegationConstraint"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_delegationconstraint" ON public."DelegationConstraint";

CREATE POLICY "rls_admin_update_delegationconstraint"
ON public."DelegationConstraint"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_delegationconstraint" ON public."DelegationConstraint";

CREATE POLICY "rls_admin_delete_delegationconstraint"
ON public."DelegationConstraint"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Channel uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_channel" ON public."Channel";

CREATE POLICY "rls_admin_select_channel"
ON public."Channel"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_channel" ON public."Channel";

CREATE POLICY "rls_admin_insert_channel"
ON public."Channel"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_channel" ON public."Channel";

CREATE POLICY "rls_admin_update_channel"
ON public."Channel"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_channel" ON public."Channel";

CREATE POLICY "rls_admin_delete_channel"
ON public."Channel"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ChannelMember uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_channelmember" ON public."ChannelMember";

CREATE POLICY "rls_admin_select_channelmember"
ON public."ChannelMember"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_channelmember" ON public."ChannelMember";

CREATE POLICY "rls_admin_insert_channelmember"
ON public."ChannelMember"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_channelmember" ON public."ChannelMember";

CREATE POLICY "rls_admin_update_channelmember"
ON public."ChannelMember"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_channelmember" ON public."ChannelMember";

CREATE POLICY "rls_admin_delete_channelmember"
ON public."ChannelMember"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Message uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_message" ON public."Message";

CREATE POLICY "rls_admin_select_message"
ON public."Message"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_message" ON public."Message";

CREATE POLICY "rls_admin_insert_message"
ON public."Message"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_message" ON public."Message";

CREATE POLICY "rls_admin_update_message"
ON public."Message"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_message" ON public."Message";

CREATE POLICY "rls_admin_delete_message"
ON public."Message"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MessageAttachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_messageattachment" ON public."MessageAttachment";

CREATE POLICY "rls_admin_select_messageattachment"
ON public."MessageAttachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_messageattachment" ON public."MessageAttachment";

CREATE POLICY "rls_admin_insert_messageattachment"
ON public."MessageAttachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_messageattachment" ON public."MessageAttachment";

CREATE POLICY "rls_admin_update_messageattachment"
ON public."MessageAttachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_messageattachment" ON public."MessageAttachment";

CREATE POLICY "rls_admin_delete_messageattachment"
ON public."MessageAttachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MessageRead uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_messageread" ON public."MessageRead";

CREATE POLICY "rls_admin_select_messageread"
ON public."MessageRead"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_messageread" ON public."MessageRead";

CREATE POLICY "rls_admin_insert_messageread"
ON public."MessageRead"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_messageread" ON public."MessageRead";

CREATE POLICY "rls_admin_update_messageread"
ON public."MessageRead"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_messageread" ON public."MessageRead";

CREATE POLICY "rls_admin_delete_messageread"
ON public."MessageRead"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DirectChat uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_directchat" ON public."DirectChat";

CREATE POLICY "rls_admin_select_directchat"
ON public."DirectChat"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_directchat" ON public."DirectChat";

CREATE POLICY "rls_admin_insert_directchat"
ON public."DirectChat"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_directchat" ON public."DirectChat";

CREATE POLICY "rls_admin_update_directchat"
ON public."DirectChat"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_directchat" ON public."DirectChat";

CREATE POLICY "rls_admin_delete_directchat"
ON public."DirectChat"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DirectMessage uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_directmessage" ON public."DirectMessage";

CREATE POLICY "rls_admin_select_directmessage"
ON public."DirectMessage"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_directmessage" ON public."DirectMessage";

CREATE POLICY "rls_admin_insert_directmessage"
ON public."DirectMessage"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_directmessage" ON public."DirectMessage";

CREATE POLICY "rls_admin_update_directmessage"
ON public."DirectMessage"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_directmessage" ON public."DirectMessage";

CREATE POLICY "rls_admin_delete_directmessage"
ON public."DirectMessage"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DirectMessageRead uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_directmessageread" ON public."DirectMessageRead";

CREATE POLICY "rls_admin_select_directmessageread"
ON public."DirectMessageRead"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_directmessageread" ON public."DirectMessageRead";

CREATE POLICY "rls_admin_insert_directmessageread"
ON public."DirectMessageRead"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_directmessageread" ON public."DirectMessageRead";

CREATE POLICY "rls_admin_update_directmessageread"
ON public."DirectMessageRead"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_directmessageread" ON public."DirectMessageRead";

CREATE POLICY "rls_admin_delete_directmessageread"
ON public."DirectMessageRead"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ExternalShareLink uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_externalsharelink" ON public."ExternalShareLink";

CREATE POLICY "rls_admin_select_externalsharelink"
ON public."ExternalShareLink"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_externalsharelink" ON public."ExternalShareLink";

CREATE POLICY "rls_admin_insert_externalsharelink"
ON public."ExternalShareLink"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_externalsharelink" ON public."ExternalShareLink";

CREATE POLICY "rls_admin_update_externalsharelink"
ON public."ExternalShareLink"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_externalsharelink" ON public."ExternalShareLink";

CREATE POLICY "rls_admin_delete_externalsharelink"
ON public."ExternalShareLink"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: external_share_audits uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_external_share_audits" ON public."external_share_audits";

CREATE POLICY "rls_admin_select_external_share_audits"
ON public."external_share_audits"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_external_share_audits" ON public."external_share_audits";

CREATE POLICY "rls_admin_insert_external_share_audits"
ON public."external_share_audits"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_external_share_audits" ON public."external_share_audits";

CREATE POLICY "rls_admin_update_external_share_audits"
ON public."external_share_audits"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_external_share_audits" ON public."external_share_audits";

CREATE POLICY "rls_admin_delete_external_share_audits"
ON public."external_share_audits"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: weather_alerts uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_weather_alerts" ON public."weather_alerts";

CREATE POLICY "rls_admin_select_weather_alerts"
ON public."weather_alerts"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_weather_alerts" ON public."weather_alerts";

CREATE POLICY "rls_admin_insert_weather_alerts"
ON public."weather_alerts"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_weather_alerts" ON public."weather_alerts";

CREATE POLICY "rls_admin_update_weather_alerts"
ON public."weather_alerts"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_weather_alerts" ON public."weather_alerts";

CREATE POLICY "rls_admin_delete_weather_alerts"
ON public."weather_alerts"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: weather_risk_factors uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_weather_risk_factors" ON public."weather_risk_factors";

CREATE POLICY "rls_admin_select_weather_risk_factors"
ON public."weather_risk_factors"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_weather_risk_factors" ON public."weather_risk_factors";

CREATE POLICY "rls_admin_insert_weather_risk_factors"
ON public."weather_risk_factors"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_weather_risk_factors" ON public."weather_risk_factors";

CREATE POLICY "rls_admin_update_weather_risk_factors"
ON public."weather_risk_factors"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_weather_risk_factors" ON public."weather_risk_factors";

CREATE POLICY "rls_admin_delete_weather_risk_factors"
ON public."weather_risk_factors"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: weather_watches uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_weather_watches" ON public."weather_watches";

CREATE POLICY "rls_admin_select_weather_watches"
ON public."weather_watches"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_weather_watches" ON public."weather_watches";

CREATE POLICY "rls_admin_insert_weather_watches"
ON public."weather_watches"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_weather_watches" ON public."weather_watches";

CREATE POLICY "rls_admin_update_weather_watches"
ON public."weather_watches"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_weather_watches" ON public."weather_watches";

CREATE POLICY "rls_admin_delete_weather_watches"
ON public."weather_watches"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: weather_alert_deliveries uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_weather_alert_deliveries" ON public."weather_alert_deliveries";

CREATE POLICY "rls_admin_select_weather_alert_deliveries"
ON public."weather_alert_deliveries"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_weather_alert_deliveries" ON public."weather_alert_deliveries";

CREATE POLICY "rls_admin_insert_weather_alert_deliveries"
ON public."weather_alert_deliveries"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_weather_alert_deliveries" ON public."weather_alert_deliveries";

CREATE POLICY "rls_admin_update_weather_alert_deliveries"
ON public."weather_alert_deliveries"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_weather_alert_deliveries" ON public."weather_alert_deliveries";

CREATE POLICY "rls_admin_delete_weather_alert_deliveries"
ON public."weather_alert_deliveries"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: weather_incidents uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_weather_incidents" ON public."weather_incidents";

CREATE POLICY "rls_admin_select_weather_incidents"
ON public."weather_incidents"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_weather_incidents" ON public."weather_incidents";

CREATE POLICY "rls_admin_insert_weather_incidents"
ON public."weather_incidents"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_weather_incidents" ON public."weather_incidents";

CREATE POLICY "rls_admin_update_weather_incidents"
ON public."weather_incidents"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_weather_incidents" ON public."weather_incidents";

CREATE POLICY "rls_admin_delete_weather_incidents"
ON public."weather_incidents"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIPromptTemplate uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiprompttemplate" ON public."AIPromptTemplate";

CREATE POLICY "rls_admin_select_aiprompttemplate"
ON public."AIPromptTemplate"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiprompttemplate" ON public."AIPromptTemplate";

CREATE POLICY "rls_admin_insert_aiprompttemplate"
ON public."AIPromptTemplate"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiprompttemplate" ON public."AIPromptTemplate";

CREATE POLICY "rls_admin_update_aiprompttemplate"
ON public."AIPromptTemplate"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiprompttemplate" ON public."AIPromptTemplate";

CREATE POLICY "rls_admin_delete_aiprompttemplate"
ON public."AIPromptTemplate"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIJob uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aijob" ON public."AIJob";

CREATE POLICY "rls_admin_select_aijob"
ON public."AIJob"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aijob" ON public."AIJob";

CREATE POLICY "rls_admin_insert_aijob"
ON public."AIJob"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aijob" ON public."AIJob";

CREATE POLICY "rls_admin_update_aijob"
ON public."AIJob"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aijob" ON public."AIJob";

CREATE POLICY "rls_admin_delete_aijob"
ON public."AIJob"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIJobArtifact uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aijobartifact" ON public."AIJobArtifact";

CREATE POLICY "rls_admin_select_aijobartifact"
ON public."AIJobArtifact"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aijobartifact" ON public."AIJobArtifact";

CREATE POLICY "rls_admin_insert_aijobartifact"
ON public."AIJobArtifact"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aijobartifact" ON public."AIJobArtifact";

CREATE POLICY "rls_admin_update_aijobartifact"
ON public."AIJobArtifact"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aijobartifact" ON public."AIJobArtifact";

CREATE POLICY "rls_admin_delete_aijobartifact"
ON public."AIJobArtifact"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIInsight uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiinsight" ON public."AIInsight";

CREATE POLICY "rls_admin_select_aiinsight"
ON public."AIInsight"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiinsight" ON public."AIInsight";

CREATE POLICY "rls_admin_insert_aiinsight"
ON public."AIInsight"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiinsight" ON public."AIInsight";

CREATE POLICY "rls_admin_update_aiinsight"
ON public."AIInsight"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiinsight" ON public."AIInsight";

CREATE POLICY "rls_admin_delete_aiinsight"
ON public."AIInsight"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIInsightFeedback uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiinsightfeedback" ON public."AIInsightFeedback";

CREATE POLICY "rls_admin_select_aiinsightfeedback"
ON public."AIInsightFeedback"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiinsightfeedback" ON public."AIInsightFeedback";

CREATE POLICY "rls_admin_insert_aiinsightfeedback"
ON public."AIInsightFeedback"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiinsightfeedback" ON public."AIInsightFeedback";

CREATE POLICY "rls_admin_update_aiinsightfeedback"
ON public."AIInsightFeedback"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiinsightfeedback" ON public."AIInsightFeedback";

CREATE POLICY "rls_admin_delete_aiinsightfeedback"
ON public."AIInsightFeedback"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIDocumentIndex uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aidocumentindex" ON public."AIDocumentIndex";

CREATE POLICY "rls_admin_select_aidocumentindex"
ON public."AIDocumentIndex"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aidocumentindex" ON public."AIDocumentIndex";

CREATE POLICY "rls_admin_insert_aidocumentindex"
ON public."AIDocumentIndex"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aidocumentindex" ON public."AIDocumentIndex";

CREATE POLICY "rls_admin_update_aidocumentindex"
ON public."AIDocumentIndex"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aidocumentindex" ON public."AIDocumentIndex";

CREATE POLICY "rls_admin_delete_aidocumentindex"
ON public."AIDocumentIndex"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIDocumentChunk uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aidocumentchunk" ON public."AIDocumentChunk";

CREATE POLICY "rls_admin_select_aidocumentchunk"
ON public."AIDocumentChunk"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aidocumentchunk" ON public."AIDocumentChunk";

CREATE POLICY "rls_admin_insert_aidocumentchunk"
ON public."AIDocumentChunk"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aidocumentchunk" ON public."AIDocumentChunk";

CREATE POLICY "rls_admin_update_aidocumentchunk"
ON public."AIDocumentChunk"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aidocumentchunk" ON public."AIDocumentChunk";

CREATE POLICY "rls_admin_delete_aidocumentchunk"
ON public."AIDocumentChunk"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIEmbedding uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiembedding" ON public."AIEmbedding";

CREATE POLICY "rls_admin_select_aiembedding"
ON public."AIEmbedding"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiembedding" ON public."AIEmbedding";

CREATE POLICY "rls_admin_insert_aiembedding"
ON public."AIEmbedding"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiembedding" ON public."AIEmbedding";

CREATE POLICY "rls_admin_update_aiembedding"
ON public."AIEmbedding"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiembedding" ON public."AIEmbedding";

CREATE POLICY "rls_admin_delete_aiembedding"
ON public."AIEmbedding"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIPlaybook uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiplaybook" ON public."AIPlaybook";

CREATE POLICY "rls_admin_select_aiplaybook"
ON public."AIPlaybook"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiplaybook" ON public."AIPlaybook";

CREATE POLICY "rls_admin_insert_aiplaybook"
ON public."AIPlaybook"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiplaybook" ON public."AIPlaybook";

CREATE POLICY "rls_admin_update_aiplaybook"
ON public."AIPlaybook"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiplaybook" ON public."AIPlaybook";

CREATE POLICY "rls_admin_delete_aiplaybook"
ON public."AIPlaybook"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIPlaybookStep uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiplaybookstep" ON public."AIPlaybookStep";

CREATE POLICY "rls_admin_select_aiplaybookstep"
ON public."AIPlaybookStep"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiplaybookstep" ON public."AIPlaybookStep";

CREATE POLICY "rls_admin_insert_aiplaybookstep"
ON public."AIPlaybookStep"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiplaybookstep" ON public."AIPlaybookStep";

CREATE POLICY "rls_admin_update_aiplaybookstep"
ON public."AIPlaybookStep"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiplaybookstep" ON public."AIPlaybookStep";

CREATE POLICY "rls_admin_delete_aiplaybookstep"
ON public."AIPlaybookStep"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIAction uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiaction" ON public."AIAction";

CREATE POLICY "rls_admin_select_aiaction"
ON public."AIAction"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiaction" ON public."AIAction";

CREATE POLICY "rls_admin_insert_aiaction"
ON public."AIAction"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiaction" ON public."AIAction";

CREATE POLICY "rls_admin_update_aiaction"
ON public."AIAction"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiaction" ON public."AIAction";

CREATE POLICY "rls_admin_delete_aiaction"
ON public."AIAction"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIActionRun uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiactionrun" ON public."AIActionRun";

CREATE POLICY "rls_admin_select_aiactionrun"
ON public."AIActionRun"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiactionrun" ON public."AIActionRun";

CREATE POLICY "rls_admin_insert_aiactionrun"
ON public."AIActionRun"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiactionrun" ON public."AIActionRun";

CREATE POLICY "rls_admin_update_aiactionrun"
ON public."AIActionRun"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiactionrun" ON public."AIActionRun";

CREATE POLICY "rls_admin_delete_aiactionrun"
ON public."AIActionRun"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AIAssistantProfile uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_aiassistantprofile" ON public."AIAssistantProfile";

CREATE POLICY "rls_admin_select_aiassistantprofile"
ON public."AIAssistantProfile"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_aiassistantprofile" ON public."AIAssistantProfile";

CREATE POLICY "rls_admin_insert_aiassistantprofile"
ON public."AIAssistantProfile"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_aiassistantprofile" ON public."AIAssistantProfile";

CREATE POLICY "rls_admin_update_aiassistantprofile"
ON public."AIAssistantProfile"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_aiassistantprofile" ON public."AIAssistantProfile";

CREATE POLICY "rls_admin_delete_aiassistantprofile"
ON public."AIAssistantProfile"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectLedgerEntry uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectledgerentry" ON public."ProjectLedgerEntry";

CREATE POLICY "rls_admin_select_projectledgerentry"
ON public."ProjectLedgerEntry"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectledgerentry" ON public."ProjectLedgerEntry";

CREATE POLICY "rls_admin_insert_projectledgerentry"
ON public."ProjectLedgerEntry"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectledgerentry" ON public."ProjectLedgerEntry";

CREATE POLICY "rls_admin_update_projectledgerentry"
ON public."ProjectLedgerEntry"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectledgerentry" ON public."ProjectLedgerEntry";

CREATE POLICY "rls_admin_delete_projectledgerentry"
ON public."ProjectLedgerEntry"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ForecastSnapshot uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_forecastsnapshot" ON public."ForecastSnapshot";

CREATE POLICY "rls_admin_select_forecastsnapshot"
ON public."ForecastSnapshot"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_forecastsnapshot" ON public."ForecastSnapshot";

CREATE POLICY "rls_admin_insert_forecastsnapshot"
ON public."ForecastSnapshot"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_forecastsnapshot" ON public."ForecastSnapshot";

CREATE POLICY "rls_admin_update_forecastsnapshot"
ON public."ForecastSnapshot"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_forecastsnapshot" ON public."ForecastSnapshot";

CREATE POLICY "rls_admin_delete_forecastsnapshot"
ON public."ForecastSnapshot"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ForecastLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_forecastline" ON public."ForecastLine";

CREATE POLICY "rls_admin_select_forecastline"
ON public."ForecastLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_forecastline" ON public."ForecastLine";

CREATE POLICY "rls_admin_insert_forecastline"
ON public."ForecastLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_forecastline" ON public."ForecastLine";

CREATE POLICY "rls_admin_update_forecastline"
ON public."ForecastLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_forecastline" ON public."ForecastLine";

CREATE POLICY "rls_admin_delete_forecastline"
ON public."ForecastLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ScenarioPlan uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_scenarioplan" ON public."ScenarioPlan";

CREATE POLICY "rls_admin_select_scenarioplan"
ON public."ScenarioPlan"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_scenarioplan" ON public."ScenarioPlan";

CREATE POLICY "rls_admin_insert_scenarioplan"
ON public."ScenarioPlan"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_scenarioplan" ON public."ScenarioPlan";

CREATE POLICY "rls_admin_update_scenarioplan"
ON public."ScenarioPlan"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_scenarioplan" ON public."ScenarioPlan";

CREATE POLICY "rls_admin_delete_scenarioplan"
ON public."ScenarioPlan"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ScenarioAssumption uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_scenarioassumption" ON public."ScenarioAssumption";

CREATE POLICY "rls_admin_select_scenarioassumption"
ON public."ScenarioAssumption"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_scenarioassumption" ON public."ScenarioAssumption";

CREATE POLICY "rls_admin_insert_scenarioassumption"
ON public."ScenarioAssumption"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_scenarioassumption" ON public."ScenarioAssumption";

CREATE POLICY "rls_admin_update_scenarioassumption"
ON public."ScenarioAssumption"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_scenarioassumption" ON public."ScenarioAssumption";

CREATE POLICY "rls_admin_delete_scenarioassumption"
ON public."ScenarioAssumption"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ScenarioWhatIfRun uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_scenariowhatifrun" ON public."ScenarioWhatIfRun";

CREATE POLICY "rls_admin_select_scenariowhatifrun"
ON public."ScenarioWhatIfRun"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_scenariowhatifrun" ON public."ScenarioWhatIfRun";

CREATE POLICY "rls_admin_insert_scenariowhatifrun"
ON public."ScenarioWhatIfRun"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_scenariowhatifrun" ON public."ScenarioWhatIfRun";

CREATE POLICY "rls_admin_update_scenariowhatifrun"
ON public."ScenarioWhatIfRun"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_scenariowhatifrun" ON public."ScenarioWhatIfRun";

CREATE POLICY "rls_admin_delete_scenariowhatifrun"
ON public."ScenarioWhatIfRun"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ScheduleRisk uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_schedulerisk" ON public."ScheduleRisk";

CREATE POLICY "rls_admin_select_schedulerisk"
ON public."ScheduleRisk"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_schedulerisk" ON public."ScheduleRisk";

CREATE POLICY "rls_admin_insert_schedulerisk"
ON public."ScheduleRisk"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_schedulerisk" ON public."ScheduleRisk";

CREATE POLICY "rls_admin_update_schedulerisk"
ON public."ScheduleRisk"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_schedulerisk" ON public."ScheduleRisk";

CREATE POLICY "rls_admin_delete_schedulerisk"
ON public."ScheduleRisk"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RiskFactor uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_riskfactor" ON public."RiskFactor";

CREATE POLICY "rls_admin_select_riskfactor"
ON public."RiskFactor"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_riskfactor" ON public."RiskFactor";

CREATE POLICY "rls_admin_insert_riskfactor"
ON public."RiskFactor"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_riskfactor" ON public."RiskFactor";

CREATE POLICY "rls_admin_update_riskfactor"
ON public."RiskFactor"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_riskfactor" ON public."RiskFactor";

CREATE POLICY "rls_admin_delete_riskfactor"
ON public."RiskFactor"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MitigationAction uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_mitigationaction" ON public."MitigationAction";

CREATE POLICY "rls_admin_select_mitigationaction"
ON public."MitigationAction"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_mitigationaction" ON public."MitigationAction";

CREATE POLICY "rls_admin_insert_mitigationaction"
ON public."MitigationAction"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_mitigationaction" ON public."MitigationAction";

CREATE POLICY "rls_admin_update_mitigationaction"
ON public."MitigationAction"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_mitigationaction" ON public."MitigationAction";

CREATE POLICY "rls_admin_delete_mitigationaction"
ON public."MitigationAction"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: GLAccount uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_glaccount" ON public."GLAccount";

CREATE POLICY "rls_admin_select_glaccount"
ON public."GLAccount"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_glaccount" ON public."GLAccount";

CREATE POLICY "rls_admin_insert_glaccount"
ON public."GLAccount"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_glaccount" ON public."GLAccount";

CREATE POLICY "rls_admin_update_glaccount"
ON public."GLAccount"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_glaccount" ON public."GLAccount";

CREATE POLICY "rls_admin_delete_glaccount"
ON public."GLAccount"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: JournalEntry uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_journalentry" ON public."JournalEntry";

CREATE POLICY "rls_admin_select_journalentry"
ON public."JournalEntry"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_journalentry" ON public."JournalEntry";

CREATE POLICY "rls_admin_insert_journalentry"
ON public."JournalEntry"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_journalentry" ON public."JournalEntry";

CREATE POLICY "rls_admin_update_journalentry"
ON public."JournalEntry"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_journalentry" ON public."JournalEntry";

CREATE POLICY "rls_admin_delete_journalentry"
ON public."JournalEntry"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: JournalLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_journalline" ON public."JournalLine";

CREATE POLICY "rls_admin_select_journalline"
ON public."JournalLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_journalline" ON public."JournalLine";

CREATE POLICY "rls_admin_insert_journalline"
ON public."JournalLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_journalline" ON public."JournalLine";

CREATE POLICY "rls_admin_update_journalline"
ON public."JournalLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_journalline" ON public."JournalLine";

CREATE POLICY "rls_admin_delete_journalline"
ON public."JournalLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SnapshotCube uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_snapshotcube" ON public."SnapshotCube";

CREATE POLICY "rls_admin_select_snapshotcube"
ON public."SnapshotCube"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_snapshotcube" ON public."SnapshotCube";

CREATE POLICY "rls_admin_insert_snapshotcube"
ON public."SnapshotCube"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_snapshotcube" ON public."SnapshotCube";

CREATE POLICY "rls_admin_update_snapshotcube"
ON public."SnapshotCube"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_snapshotcube" ON public."SnapshotCube";

CREATE POLICY "rls_admin_delete_snapshotcube"
ON public."SnapshotCube"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SnapshotCubePartition uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_snapshotcubepartition" ON public."SnapshotCubePartition";

CREATE POLICY "rls_admin_select_snapshotcubepartition"
ON public."SnapshotCubePartition"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_snapshotcubepartition" ON public."SnapshotCubePartition";

CREATE POLICY "rls_admin_insert_snapshotcubepartition"
ON public."SnapshotCubePartition"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_snapshotcubepartition" ON public."SnapshotCubePartition";

CREATE POLICY "rls_admin_update_snapshotcubepartition"
ON public."SnapshotCubePartition"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_snapshotcubepartition" ON public."SnapshotCubePartition";

CREATE POLICY "rls_admin_delete_snapshotcubepartition"
ON public."SnapshotCubePartition"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MetricSnapshot uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_metricsnapshot" ON public."MetricSnapshot";

CREATE POLICY "rls_admin_select_metricsnapshot"
ON public."MetricSnapshot"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_metricsnapshot" ON public."MetricSnapshot";

CREATE POLICY "rls_admin_insert_metricsnapshot"
ON public."MetricSnapshot"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_metricsnapshot" ON public."MetricSnapshot";

CREATE POLICY "rls_admin_update_metricsnapshot"
ON public."MetricSnapshot"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_metricsnapshot" ON public."MetricSnapshot";

CREATE POLICY "rls_admin_delete_metricsnapshot"
ON public."MetricSnapshot"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: KPIAggregate uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_kpiaggregate" ON public."KPIAggregate";

CREATE POLICY "rls_admin_select_kpiaggregate"
ON public."KPIAggregate"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_kpiaggregate" ON public."KPIAggregate";

CREATE POLICY "rls_admin_insert_kpiaggregate"
ON public."KPIAggregate"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_kpiaggregate" ON public."KPIAggregate";

CREATE POLICY "rls_admin_update_kpiaggregate"
ON public."KPIAggregate"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_kpiaggregate" ON public."KPIAggregate";

CREATE POLICY "rls_admin_delete_kpiaggregate"
ON public."KPIAggregate"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ReportDefinition uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_reportdefinition" ON public."ReportDefinition";

CREATE POLICY "rls_admin_select_reportdefinition"
ON public."ReportDefinition"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_reportdefinition" ON public."ReportDefinition";

CREATE POLICY "rls_admin_insert_reportdefinition"
ON public."ReportDefinition"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_reportdefinition" ON public."ReportDefinition";

CREATE POLICY "rls_admin_update_reportdefinition"
ON public."ReportDefinition"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_reportdefinition" ON public."ReportDefinition";

CREATE POLICY "rls_admin_delete_reportdefinition"
ON public."ReportDefinition"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DashboardDefinition uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_dashboarddefinition" ON public."DashboardDefinition";

CREATE POLICY "rls_admin_select_dashboarddefinition"
ON public."DashboardDefinition"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_dashboarddefinition" ON public."DashboardDefinition";

CREATE POLICY "rls_admin_insert_dashboarddefinition"
ON public."DashboardDefinition"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_dashboarddefinition" ON public."DashboardDefinition";

CREATE POLICY "rls_admin_update_dashboarddefinition"
ON public."DashboardDefinition"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_dashboarddefinition" ON public."DashboardDefinition";

CREATE POLICY "rls_admin_delete_dashboarddefinition"
ON public."DashboardDefinition"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ExportJob uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_exportjob" ON public."ExportJob";

CREATE POLICY "rls_admin_select_exportjob"
ON public."ExportJob"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_exportjob" ON public."ExportJob";

CREATE POLICY "rls_admin_insert_exportjob"
ON public."ExportJob"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_exportjob" ON public."ExportJob";

CREATE POLICY "rls_admin_update_exportjob"
ON public."ExportJob"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_exportjob" ON public."ExportJob";

CREATE POLICY "rls_admin_delete_exportjob"
ON public."ExportJob"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ExportArtifact uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_exportartifact" ON public."ExportArtifact";

CREATE POLICY "rls_admin_select_exportartifact"
ON public."ExportArtifact"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_exportartifact" ON public."ExportArtifact";

CREATE POLICY "rls_admin_insert_exportartifact"
ON public."ExportArtifact"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_exportartifact" ON public."ExportArtifact";

CREATE POLICY "rls_admin_update_exportartifact"
ON public."ExportArtifact"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_exportartifact" ON public."ExportArtifact";

CREATE POLICY "rls_admin_delete_exportartifact"
ON public."ExportArtifact"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: IntegrationConnector uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_integrationconnector" ON public."IntegrationConnector";

CREATE POLICY "rls_admin_select_integrationconnector"
ON public."IntegrationConnector"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_integrationconnector" ON public."IntegrationConnector";

CREATE POLICY "rls_admin_insert_integrationconnector"
ON public."IntegrationConnector"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_integrationconnector" ON public."IntegrationConnector";

CREATE POLICY "rls_admin_update_integrationconnector"
ON public."IntegrationConnector"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_integrationconnector" ON public."IntegrationConnector";

CREATE POLICY "rls_admin_delete_integrationconnector"
ON public."IntegrationConnector"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: IntegrationConnection uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_integrationconnection" ON public."IntegrationConnection";

CREATE POLICY "rls_admin_select_integrationconnection"
ON public."IntegrationConnection"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_integrationconnection" ON public."IntegrationConnection";

CREATE POLICY "rls_admin_insert_integrationconnection"
ON public."IntegrationConnection"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_integrationconnection" ON public."IntegrationConnection";

CREATE POLICY "rls_admin_update_integrationconnection"
ON public."IntegrationConnection"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_integrationconnection" ON public."IntegrationConnection";

CREATE POLICY "rls_admin_delete_integrationconnection"
ON public."IntegrationConnection"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: IntegrationSecret uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_integrationsecret" ON public."IntegrationSecret";

CREATE POLICY "rls_admin_select_integrationsecret"
ON public."IntegrationSecret"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_integrationsecret" ON public."IntegrationSecret";

CREATE POLICY "rls_admin_insert_integrationsecret"
ON public."IntegrationSecret"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_integrationsecret" ON public."IntegrationSecret";

CREATE POLICY "rls_admin_update_integrationsecret"
ON public."IntegrationSecret"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_integrationsecret" ON public."IntegrationSecret";

CREATE POLICY "rls_admin_delete_integrationsecret"
ON public."IntegrationSecret"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: IntegrationMapping uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_integrationmapping" ON public."IntegrationMapping";

CREATE POLICY "rls_admin_select_integrationmapping"
ON public."IntegrationMapping"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_integrationmapping" ON public."IntegrationMapping";

CREATE POLICY "rls_admin_insert_integrationmapping"
ON public."IntegrationMapping"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_integrationmapping" ON public."IntegrationMapping";

CREATE POLICY "rls_admin_update_integrationmapping"
ON public."IntegrationMapping"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_integrationmapping" ON public."IntegrationMapping";

CREATE POLICY "rls_admin_delete_integrationmapping"
ON public."IntegrationMapping"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SyncJob uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_syncjob" ON public."SyncJob";

CREATE POLICY "rls_admin_select_syncjob"
ON public."SyncJob"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_syncjob" ON public."SyncJob";

CREATE POLICY "rls_admin_insert_syncjob"
ON public."SyncJob"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_syncjob" ON public."SyncJob";

CREATE POLICY "rls_admin_update_syncjob"
ON public."SyncJob"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_syncjob" ON public."SyncJob";

CREATE POLICY "rls_admin_delete_syncjob"
ON public."SyncJob"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SyncLog uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_synclog" ON public."SyncLog";

CREATE POLICY "rls_admin_select_synclog"
ON public."SyncLog"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_synclog" ON public."SyncLog";

CREATE POLICY "rls_admin_insert_synclog"
ON public."SyncLog"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_synclog" ON public."SyncLog";

CREATE POLICY "rls_admin_update_synclog"
ON public."SyncLog"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_synclog" ON public."SyncLog";

CREATE POLICY "rls_admin_delete_synclog"
ON public."SyncLog"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SyncState uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_syncstate" ON public."SyncState";

CREATE POLICY "rls_admin_select_syncstate"
ON public."SyncState"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_syncstate" ON public."SyncState";

CREATE POLICY "rls_admin_insert_syncstate"
ON public."SyncState"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_syncstate" ON public."SyncState";

CREATE POLICY "rls_admin_update_syncstate"
ON public."SyncState"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_syncstate" ON public."SyncState";

CREATE POLICY "rls_admin_delete_syncstate"
ON public."SyncState"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ChangeVector uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_changevector" ON public."ChangeVector";

CREATE POLICY "rls_admin_select_changevector"
ON public."ChangeVector"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_changevector" ON public."ChangeVector";

CREATE POLICY "rls_admin_insert_changevector"
ON public."ChangeVector"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_changevector" ON public."ChangeVector";

CREATE POLICY "rls_admin_update_changevector"
ON public."ChangeVector"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_changevector" ON public."ChangeVector";

CREATE POLICY "rls_admin_delete_changevector"
ON public."ChangeVector"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ConflictLog uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_conflictlog" ON public."ConflictLog";

CREATE POLICY "rls_admin_select_conflictlog"
ON public."ConflictLog"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_conflictlog" ON public."ConflictLog";

CREATE POLICY "rls_admin_insert_conflictlog"
ON public."ConflictLog"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_conflictlog" ON public."ConflictLog";

CREATE POLICY "rls_admin_update_conflictlog"
ON public."ConflictLog"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_conflictlog" ON public."ConflictLog";

CREATE POLICY "rls_admin_delete_conflictlog"
ON public."ConflictLog"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: FileObject uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_fileobject" ON public."FileObject";

CREATE POLICY "rls_admin_select_fileobject"
ON public."FileObject"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_fileobject" ON public."FileObject";

CREATE POLICY "rls_admin_insert_fileobject"
ON public."FileObject"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_fileobject" ON public."FileObject";

CREATE POLICY "rls_admin_update_fileobject"
ON public."FileObject"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_fileobject" ON public."FileObject";

CREATE POLICY "rls_admin_delete_fileobject"
ON public."FileObject"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Attachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_attachment" ON public."Attachment";

CREATE POLICY "rls_admin_select_attachment"
ON public."Attachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_attachment" ON public."Attachment";

CREATE POLICY "rls_admin_insert_attachment"
ON public."Attachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_attachment" ON public."Attachment";

CREATE POLICY "rls_admin_update_attachment"
ON public."Attachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_attachment" ON public."Attachment";

CREATE POLICY "rls_admin_delete_attachment"
ON public."Attachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AttachmentLink uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_attachmentlink" ON public."AttachmentLink";

CREATE POLICY "rls_admin_select_attachmentlink"
ON public."AttachmentLink"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_attachmentlink" ON public."AttachmentLink";

CREATE POLICY "rls_admin_insert_attachmentlink"
ON public."AttachmentLink"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_attachmentlink" ON public."AttachmentLink";

CREATE POLICY "rls_admin_update_attachmentlink"
ON public."AttachmentLink"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_attachmentlink" ON public."AttachmentLink";

CREATE POLICY "rls_admin_delete_attachmentlink"
ON public."AttachmentLink"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ESignatureEnvelope uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_esignatureenvelope" ON public."ESignatureEnvelope";

CREATE POLICY "rls_admin_select_esignatureenvelope"
ON public."ESignatureEnvelope"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_esignatureenvelope" ON public."ESignatureEnvelope";

CREATE POLICY "rls_admin_insert_esignatureenvelope"
ON public."ESignatureEnvelope"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_esignatureenvelope" ON public."ESignatureEnvelope";

CREATE POLICY "rls_admin_update_esignatureenvelope"
ON public."ESignatureEnvelope"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_esignatureenvelope" ON public."ESignatureEnvelope";

CREATE POLICY "rls_admin_delete_esignatureenvelope"
ON public."ESignatureEnvelope"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ESignatureRecipient uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_esignaturerecipient" ON public."ESignatureRecipient";

CREATE POLICY "rls_admin_select_esignaturerecipient"
ON public."ESignatureRecipient"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_esignaturerecipient" ON public."ESignatureRecipient";

CREATE POLICY "rls_admin_insert_esignaturerecipient"
ON public."ESignatureRecipient"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_esignaturerecipient" ON public."ESignatureRecipient";

CREATE POLICY "rls_admin_update_esignaturerecipient"
ON public."ESignatureRecipient"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_esignaturerecipient" ON public."ESignatureRecipient";

CREATE POLICY "rls_admin_delete_esignaturerecipient"
ON public."ESignatureRecipient"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SignatureSession uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_signaturesession" ON public."SignatureSession";

CREATE POLICY "rls_admin_select_signaturesession"
ON public."SignatureSession"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_signaturesession" ON public."SignatureSession";

CREATE POLICY "rls_admin_insert_signaturesession"
ON public."SignatureSession"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_signaturesession" ON public."SignatureSession";

CREATE POLICY "rls_admin_update_signaturesession"
ON public."SignatureSession"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_signaturesession" ON public."SignatureSession";

CREATE POLICY "rls_admin_delete_signaturesession"
ON public."SignatureSession"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SignatureIntent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_signatureintent" ON public."SignatureIntent";

CREATE POLICY "rls_admin_select_signatureintent"
ON public."SignatureIntent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_signatureintent" ON public."SignatureIntent";

CREATE POLICY "rls_admin_insert_signatureintent"
ON public."SignatureIntent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_signatureintent" ON public."SignatureIntent";

CREATE POLICY "rls_admin_update_signatureintent"
ON public."SignatureIntent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_signatureintent" ON public."SignatureIntent";

CREATE POLICY "rls_admin_delete_signatureintent"
ON public."SignatureIntent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SignatureArtifact uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_signatureartifact" ON public."SignatureArtifact";

CREATE POLICY "rls_admin_select_signatureartifact"
ON public."SignatureArtifact"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_signatureartifact" ON public."SignatureArtifact";

CREATE POLICY "rls_admin_insert_signatureartifact"
ON public."SignatureArtifact"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_signatureartifact" ON public."SignatureArtifact";

CREATE POLICY "rls_admin_update_signatureartifact"
ON public."SignatureArtifact"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_signatureartifact" ON public."SignatureArtifact";

CREATE POLICY "rls_admin_delete_signatureartifact"
ON public."SignatureArtifact"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Notification uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_notification" ON public."Notification";

CREATE POLICY "rls_admin_select_notification"
ON public."Notification"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_notification" ON public."Notification";

CREATE POLICY "rls_admin_insert_notification"
ON public."Notification"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_notification" ON public."Notification";

CREATE POLICY "rls_admin_update_notification"
ON public."Notification"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_notification" ON public."Notification";

CREATE POLICY "rls_admin_delete_notification"
ON public."Notification"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: NotificationPreference uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_notificationpreference" ON public."NotificationPreference";

CREATE POLICY "rls_admin_select_notificationpreference"
ON public."NotificationPreference"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_notificationpreference" ON public."NotificationPreference";

CREATE POLICY "rls_admin_insert_notificationpreference"
ON public."NotificationPreference"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_notificationpreference" ON public."NotificationPreference";

CREATE POLICY "rls_admin_update_notificationpreference"
ON public."NotificationPreference"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_notificationpreference" ON public."NotificationPreference";

CREATE POLICY "rls_admin_delete_notificationpreference"
ON public."NotificationPreference"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: WebhookEndpoint uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_webhookendpoint" ON public."WebhookEndpoint";

CREATE POLICY "rls_admin_select_webhookendpoint"
ON public."WebhookEndpoint"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_webhookendpoint" ON public."WebhookEndpoint";

CREATE POLICY "rls_admin_insert_webhookendpoint"
ON public."WebhookEndpoint"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_webhookendpoint" ON public."WebhookEndpoint";

CREATE POLICY "rls_admin_update_webhookendpoint"
ON public."WebhookEndpoint"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_webhookendpoint" ON public."WebhookEndpoint";

CREATE POLICY "rls_admin_delete_webhookendpoint"
ON public."WebhookEndpoint"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: WebhookEvent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_webhookevent" ON public."WebhookEvent";

CREATE POLICY "rls_admin_select_webhookevent"
ON public."WebhookEvent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_webhookevent" ON public."WebhookEvent";

CREATE POLICY "rls_admin_insert_webhookevent"
ON public."WebhookEvent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_webhookevent" ON public."WebhookEvent";

CREATE POLICY "rls_admin_update_webhookevent"
ON public."WebhookEvent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_webhookevent" ON public."WebhookEvent";

CREATE POLICY "rls_admin_delete_webhookevent"
ON public."WebhookEvent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: WebhookDelivery uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_webhookdelivery" ON public."WebhookDelivery";

CREATE POLICY "rls_admin_select_webhookdelivery"
ON public."WebhookDelivery"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_webhookdelivery" ON public."WebhookDelivery";

CREATE POLICY "rls_admin_insert_webhookdelivery"
ON public."WebhookDelivery"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_webhookdelivery" ON public."WebhookDelivery";

CREATE POLICY "rls_admin_update_webhookdelivery"
ON public."WebhookDelivery"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_webhookdelivery" ON public."WebhookDelivery";

CREATE POLICY "rls_admin_delete_webhookdelivery"
ON public."WebhookDelivery"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: OutboxMessage uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_outboxmessage" ON public."OutboxMessage";

CREATE POLICY "rls_admin_select_outboxmessage"
ON public."OutboxMessage"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_outboxmessage" ON public."OutboxMessage";

CREATE POLICY "rls_admin_insert_outboxmessage"
ON public."OutboxMessage"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_outboxmessage" ON public."OutboxMessage";

CREATE POLICY "rls_admin_update_outboxmessage"
ON public."OutboxMessage"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_outboxmessage" ON public."OutboxMessage";

CREATE POLICY "rls_admin_delete_outboxmessage"
ON public."OutboxMessage"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InAppAnnouncement uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inappannouncement" ON public."InAppAnnouncement";

CREATE POLICY "rls_admin_select_inappannouncement"
ON public."InAppAnnouncement"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inappannouncement" ON public."InAppAnnouncement";

CREATE POLICY "rls_admin_insert_inappannouncement"
ON public."InAppAnnouncement"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inappannouncement" ON public."InAppAnnouncement";

CREATE POLICY "rls_admin_update_inappannouncement"
ON public."InAppAnnouncement"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inappannouncement" ON public."InAppAnnouncement";

CREATE POLICY "rls_admin_delete_inappannouncement"
ON public."InAppAnnouncement"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SystemLog uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_systemlog" ON public."SystemLog";

CREATE POLICY "rls_admin_select_systemlog"
ON public."SystemLog"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_systemlog" ON public."SystemLog";

CREATE POLICY "rls_admin_insert_systemlog"
ON public."SystemLog"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_systemlog" ON public."SystemLog";

CREATE POLICY "rls_admin_update_systemlog"
ON public."SystemLog"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_systemlog" ON public."SystemLog";

CREATE POLICY "rls_admin_delete_systemlog"
ON public."SystemLog"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: JobSchedule uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_jobschedule" ON public."JobSchedule";

CREATE POLICY "rls_admin_select_jobschedule"
ON public."JobSchedule"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_jobschedule" ON public."JobSchedule";

CREATE POLICY "rls_admin_insert_jobschedule"
ON public."JobSchedule"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_jobschedule" ON public."JobSchedule";

CREATE POLICY "rls_admin_update_jobschedule"
ON public."JobSchedule"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_jobschedule" ON public."JobSchedule";

CREATE POLICY "rls_admin_delete_jobschedule"
ON public."JobSchedule"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: JobRun uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_jobrun" ON public."JobRun";

CREATE POLICY "rls_admin_select_jobrun"
ON public."JobRun"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_jobrun" ON public."JobRun";

CREATE POLICY "rls_admin_insert_jobrun"
ON public."JobRun"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_jobrun" ON public."JobRun";

CREATE POLICY "rls_admin_update_jobrun"
ON public."JobRun"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_jobrun" ON public."JobRun";

CREATE POLICY "rls_admin_delete_jobrun"
ON public."JobRun"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ErrorReport uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_errorreport" ON public."ErrorReport";

CREATE POLICY "rls_admin_select_errorreport"
ON public."ErrorReport"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_errorreport" ON public."ErrorReport";

CREATE POLICY "rls_admin_insert_errorreport"
ON public."ErrorReport"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_errorreport" ON public."ErrorReport";

CREATE POLICY "rls_admin_update_errorreport"
ON public."ErrorReport"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_errorreport" ON public."ErrorReport";

CREATE POLICY "rls_admin_delete_errorreport"
ON public."ErrorReport"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DataSubject uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_datasubject" ON public."DataSubject";

CREATE POLICY "rls_admin_select_datasubject"
ON public."DataSubject"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_datasubject" ON public."DataSubject";

CREATE POLICY "rls_admin_insert_datasubject"
ON public."DataSubject"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_datasubject" ON public."DataSubject";

CREATE POLICY "rls_admin_update_datasubject"
ON public."DataSubject"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_datasubject" ON public."DataSubject";

CREATE POLICY "rls_admin_delete_datasubject"
ON public."DataSubject"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DataAccessRequest uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_dataaccessrequest" ON public."DataAccessRequest";

CREATE POLICY "rls_admin_select_dataaccessrequest"
ON public."DataAccessRequest"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_dataaccessrequest" ON public."DataAccessRequest";

CREATE POLICY "rls_admin_insert_dataaccessrequest"
ON public."DataAccessRequest"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_dataaccessrequest" ON public."DataAccessRequest";

CREATE POLICY "rls_admin_update_dataaccessrequest"
ON public."DataAccessRequest"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_dataaccessrequest" ON public."DataAccessRequest";

CREATE POLICY "rls_admin_delete_dataaccessrequest"
ON public."DataAccessRequest"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DataErasureRequest uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_dataerasurerequest" ON public."DataErasureRequest";

CREATE POLICY "rls_admin_select_dataerasurerequest"
ON public."DataErasureRequest"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_dataerasurerequest" ON public."DataErasureRequest";

CREATE POLICY "rls_admin_insert_dataerasurerequest"
ON public."DataErasureRequest"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_dataerasurerequest" ON public."DataErasureRequest";

CREATE POLICY "rls_admin_update_dataerasurerequest"
ON public."DataErasureRequest"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_dataerasurerequest" ON public."DataErasureRequest";

CREATE POLICY "rls_admin_delete_dataerasurerequest"
ON public."DataErasureRequest"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: LegalHold uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_legalhold" ON public."LegalHold";

CREATE POLICY "rls_admin_select_legalhold"
ON public."LegalHold"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_legalhold" ON public."LegalHold";

CREATE POLICY "rls_admin_insert_legalhold"
ON public."LegalHold"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_legalhold" ON public."LegalHold";

CREATE POLICY "rls_admin_update_legalhold"
ON public."LegalHold"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_legalhold" ON public."LegalHold";

CREATE POLICY "rls_admin_delete_legalhold"
ON public."LegalHold"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RetentionSchedule uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_retentionschedule" ON public."RetentionSchedule";

CREATE POLICY "rls_admin_select_retentionschedule"
ON public."RetentionSchedule"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_retentionschedule" ON public."RetentionSchedule";

CREATE POLICY "rls_admin_insert_retentionschedule"
ON public."RetentionSchedule"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_retentionschedule" ON public."RetentionSchedule";

CREATE POLICY "rls_admin_update_retentionschedule"
ON public."RetentionSchedule"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_retentionschedule" ON public."RetentionSchedule";

CREATE POLICY "rls_admin_delete_retentionschedule"
ON public."RetentionSchedule"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DataLineageEvent uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_datalineageevent" ON public."DataLineageEvent";

CREATE POLICY "rls_admin_select_datalineageevent"
ON public."DataLineageEvent"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_datalineageevent" ON public."DataLineageEvent";

CREATE POLICY "rls_admin_insert_datalineageevent"
ON public."DataLineageEvent"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_datalineageevent" ON public."DataLineageEvent";

CREATE POLICY "rls_admin_update_datalineageevent"
ON public."DataLineageEvent"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_datalineageevent" ON public."DataLineageEvent";

CREATE POLICY "rls_admin_delete_datalineageevent"
ON public."DataLineageEvent"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DataLineageEdge uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_datalineageedge" ON public."DataLineageEdge";

CREATE POLICY "rls_admin_select_datalineageedge"
ON public."DataLineageEdge"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_datalineageedge" ON public."DataLineageEdge";

CREATE POLICY "rls_admin_insert_datalineageedge"
ON public."DataLineageEdge"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_datalineageedge" ON public."DataLineageEdge";

CREATE POLICY "rls_admin_update_datalineageedge"
ON public."DataLineageEdge"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_datalineageedge" ON public."DataLineageEdge";

CREATE POLICY "rls_admin_delete_datalineageedge"
ON public."DataLineageEdge"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectPhase uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectphase" ON public."ProjectPhase";

CREATE POLICY "rls_admin_select_projectphase"
ON public."ProjectPhase"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectphase" ON public."ProjectPhase";

CREATE POLICY "rls_admin_insert_projectphase"
ON public."ProjectPhase"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectphase" ON public."ProjectPhase";

CREATE POLICY "rls_admin_update_projectphase"
ON public."ProjectPhase"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectphase" ON public."ProjectPhase";

CREATE POLICY "rls_admin_delete_projectphase"
ON public."ProjectPhase"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: WBSItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_wbsitem" ON public."WBSItem";

CREATE POLICY "rls_admin_select_wbsitem"
ON public."WBSItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_wbsitem" ON public."WBSItem";

CREATE POLICY "rls_admin_insert_wbsitem"
ON public."WBSItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_wbsitem" ON public."WBSItem";

CREATE POLICY "rls_admin_update_wbsitem"
ON public."WBSItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_wbsitem" ON public."WBSItem";

CREATE POLICY "rls_admin_delete_wbsitem"
ON public."WBSItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectTask uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projecttask" ON public."ProjectTask";

CREATE POLICY "rls_admin_select_projecttask"
ON public."ProjectTask"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projecttask" ON public."ProjectTask";

CREATE POLICY "rls_admin_insert_projecttask"
ON public."ProjectTask"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projecttask" ON public."ProjectTask";

CREATE POLICY "rls_admin_update_projecttask"
ON public."ProjectTask"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projecttask" ON public."ProjectTask";

CREATE POLICY "rls_admin_delete_projecttask"
ON public."ProjectTask"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectTaskAssignment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projecttaskassignment" ON public."ProjectTaskAssignment";

CREATE POLICY "rls_admin_select_projecttaskassignment"
ON public."ProjectTaskAssignment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projecttaskassignment" ON public."ProjectTaskAssignment";

CREATE POLICY "rls_admin_insert_projecttaskassignment"
ON public."ProjectTaskAssignment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projecttaskassignment" ON public."ProjectTaskAssignment";

CREATE POLICY "rls_admin_update_projecttaskassignment"
ON public."ProjectTaskAssignment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projecttaskassignment" ON public."ProjectTaskAssignment";

CREATE POLICY "rls_admin_delete_projecttaskassignment"
ON public."ProjectTaskAssignment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectTaskChecklistItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projecttaskchecklistitem" ON public."ProjectTaskChecklistItem";

CREATE POLICY "rls_admin_select_projecttaskchecklistitem"
ON public."ProjectTaskChecklistItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projecttaskchecklistitem" ON public."ProjectTaskChecklistItem";

CREATE POLICY "rls_admin_insert_projecttaskchecklistitem"
ON public."ProjectTaskChecklistItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projecttaskchecklistitem" ON public."ProjectTaskChecklistItem";

CREATE POLICY "rls_admin_update_projecttaskchecklistitem"
ON public."ProjectTaskChecklistItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projecttaskchecklistitem" ON public."ProjectTaskChecklistItem";

CREATE POLICY "rls_admin_delete_projecttaskchecklistitem"
ON public."ProjectTaskChecklistItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectTaskDependency uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projecttaskdependency" ON public."ProjectTaskDependency";

CREATE POLICY "rls_admin_select_projecttaskdependency"
ON public."ProjectTaskDependency"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projecttaskdependency" ON public."ProjectTaskDependency";

CREATE POLICY "rls_admin_insert_projecttaskdependency"
ON public."ProjectTaskDependency"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projecttaskdependency" ON public."ProjectTaskDependency";

CREATE POLICY "rls_admin_update_projecttaskdependency"
ON public."ProjectTaskDependency"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projecttaskdependency" ON public."ProjectTaskDependency";

CREATE POLICY "rls_admin_delete_projecttaskdependency"
ON public."ProjectTaskDependency"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectTaskAttachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projecttaskattachment" ON public."ProjectTaskAttachment";

CREATE POLICY "rls_admin_select_projecttaskattachment"
ON public."ProjectTaskAttachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projecttaskattachment" ON public."ProjectTaskAttachment";

CREATE POLICY "rls_admin_insert_projecttaskattachment"
ON public."ProjectTaskAttachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projecttaskattachment" ON public."ProjectTaskAttachment";

CREATE POLICY "rls_admin_update_projecttaskattachment"
ON public."ProjectTaskAttachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projecttaskattachment" ON public."ProjectTaskAttachment";

CREATE POLICY "rls_admin_delete_projecttaskattachment"
ON public."ProjectTaskAttachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectTaskComment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projecttaskcomment" ON public."ProjectTaskComment";

CREATE POLICY "rls_admin_select_projecttaskcomment"
ON public."ProjectTaskComment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projecttaskcomment" ON public."ProjectTaskComment";

CREATE POLICY "rls_admin_insert_projecttaskcomment"
ON public."ProjectTaskComment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projecttaskcomment" ON public."ProjectTaskComment";

CREATE POLICY "rls_admin_update_projecttaskcomment"
ON public."ProjectTaskComment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projecttaskcomment" ON public."ProjectTaskComment";

CREATE POLICY "rls_admin_delete_projecttaskcomment"
ON public."ProjectTaskComment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Task uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_task" ON public."Task";

CREATE POLICY "rls_admin_select_task"
ON public."Task"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_task" ON public."Task";

CREATE POLICY "rls_admin_insert_task"
ON public."Task"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_task" ON public."Task";

CREATE POLICY "rls_admin_update_task"
ON public."Task"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_task" ON public."Task";

CREATE POLICY "rls_admin_delete_task"
ON public."Task"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TaskAssignment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_taskassignment" ON public."TaskAssignment";

CREATE POLICY "rls_admin_select_taskassignment"
ON public."TaskAssignment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_taskassignment" ON public."TaskAssignment";

CREATE POLICY "rls_admin_insert_taskassignment"
ON public."TaskAssignment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_taskassignment" ON public."TaskAssignment";

CREATE POLICY "rls_admin_update_taskassignment"
ON public."TaskAssignment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_taskassignment" ON public."TaskAssignment";

CREATE POLICY "rls_admin_delete_taskassignment"
ON public."TaskAssignment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TaskChecklistItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_taskchecklistitem" ON public."TaskChecklistItem";

CREATE POLICY "rls_admin_select_taskchecklistitem"
ON public."TaskChecklistItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_taskchecklistitem" ON public."TaskChecklistItem";

CREATE POLICY "rls_admin_insert_taskchecklistitem"
ON public."TaskChecklistItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_taskchecklistitem" ON public."TaskChecklistItem";

CREATE POLICY "rls_admin_update_taskchecklistitem"
ON public."TaskChecklistItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_taskchecklistitem" ON public."TaskChecklistItem";

CREATE POLICY "rls_admin_delete_taskchecklistitem"
ON public."TaskChecklistItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TaskDependency uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_taskdependency" ON public."TaskDependency";

CREATE POLICY "rls_admin_select_taskdependency"
ON public."TaskDependency"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_taskdependency" ON public."TaskDependency";

CREATE POLICY "rls_admin_insert_taskdependency"
ON public."TaskDependency"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_taskdependency" ON public."TaskDependency";

CREATE POLICY "rls_admin_update_taskdependency"
ON public."TaskDependency"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_taskdependency" ON public."TaskDependency";

CREATE POLICY "rls_admin_delete_taskdependency"
ON public."TaskDependency"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TaskAttachment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_taskattachment" ON public."TaskAttachment";

CREATE POLICY "rls_admin_select_taskattachment"
ON public."TaskAttachment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_taskattachment" ON public."TaskAttachment";

CREATE POLICY "rls_admin_insert_taskattachment"
ON public."TaskAttachment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_taskattachment" ON public."TaskAttachment";

CREATE POLICY "rls_admin_update_taskattachment"
ON public."TaskAttachment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_taskattachment" ON public."TaskAttachment";

CREATE POLICY "rls_admin_delete_taskattachment"
ON public."TaskAttachment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Schedule uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_schedule" ON public."Schedule";

CREATE POLICY "rls_admin_select_schedule"
ON public."Schedule"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_schedule" ON public."Schedule";

CREATE POLICY "rls_admin_insert_schedule"
ON public."Schedule"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_schedule" ON public."Schedule";

CREATE POLICY "rls_admin_update_schedule"
ON public."Schedule"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_schedule" ON public."Schedule";

CREATE POLICY "rls_admin_delete_schedule"
ON public."Schedule"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ResourceAllocation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_resourceallocation" ON public."ResourceAllocation";

CREATE POLICY "rls_admin_select_resourceallocation"
ON public."ResourceAllocation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_resourceallocation" ON public."ResourceAllocation";

CREATE POLICY "rls_admin_insert_resourceallocation"
ON public."ResourceAllocation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_resourceallocation" ON public."ResourceAllocation";

CREATE POLICY "rls_admin_update_resourceallocation"
ON public."ResourceAllocation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_resourceallocation" ON public."ResourceAllocation";

CREATE POLICY "rls_admin_delete_resourceallocation"
ON public."ResourceAllocation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Milestone uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_milestone" ON public."Milestone";

CREATE POLICY "rls_admin_select_milestone"
ON public."Milestone"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_milestone" ON public."Milestone";

CREATE POLICY "rls_admin_insert_milestone"
ON public."Milestone"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_milestone" ON public."Milestone";

CREATE POLICY "rls_admin_update_milestone"
ON public."Milestone"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_milestone" ON public."Milestone";

CREATE POLICY "rls_admin_delete_milestone"
ON public."Milestone"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MilestoneDependency uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_milestonedependency" ON public."MilestoneDependency";

CREATE POLICY "rls_admin_select_milestonedependency"
ON public."MilestoneDependency"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_milestonedependency" ON public."MilestoneDependency";

CREATE POLICY "rls_admin_insert_milestonedependency"
ON public."MilestoneDependency"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_milestonedependency" ON public."MilestoneDependency";

CREATE POLICY "rls_admin_update_milestonedependency"
ON public."MilestoneDependency"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_milestonedependency" ON public."MilestoneDependency";

CREATE POLICY "rls_admin_delete_milestonedependency"
ON public."MilestoneDependency"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: MilestoneStakeholder uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_milestonestakeholder" ON public."MilestoneStakeholder";

CREATE POLICY "rls_admin_select_milestonestakeholder"
ON public."MilestoneStakeholder"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_milestonestakeholder" ON public."MilestoneStakeholder";

CREATE POLICY "rls_admin_insert_milestonestakeholder"
ON public."MilestoneStakeholder"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_milestonestakeholder" ON public."MilestoneStakeholder";

CREATE POLICY "rls_admin_update_milestonestakeholder"
ON public."MilestoneStakeholder"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_milestonestakeholder" ON public."MilestoneStakeholder";

CREATE POLICY "rls_admin_delete_milestonestakeholder"
ON public."MilestoneStakeholder"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ScheduleException uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_scheduleexception" ON public."ScheduleException";

CREATE POLICY "rls_admin_select_scheduleexception"
ON public."ScheduleException"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_scheduleexception" ON public."ScheduleException";

CREATE POLICY "rls_admin_insert_scheduleexception"
ON public."ScheduleException"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_scheduleexception" ON public."ScheduleException";

CREATE POLICY "rls_admin_update_scheduleexception"
ON public."ScheduleException"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_scheduleexception" ON public."ScheduleException";

CREATE POLICY "rls_admin_delete_scheduleexception"
ON public."ScheduleException"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Timesheet uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_timesheet" ON public."Timesheet";

CREATE POLICY "rls_admin_select_timesheet"
ON public."Timesheet"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_timesheet" ON public."Timesheet";

CREATE POLICY "rls_admin_insert_timesheet"
ON public."Timesheet"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_timesheet" ON public."Timesheet";

CREATE POLICY "rls_admin_update_timesheet"
ON public."Timesheet"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_timesheet" ON public."Timesheet";

CREATE POLICY "rls_admin_delete_timesheet"
ON public."Timesheet"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TimesheetEntry uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_timesheetentry" ON public."TimesheetEntry";

CREATE POLICY "rls_admin_select_timesheetentry"
ON public."TimesheetEntry"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_timesheetentry" ON public."TimesheetEntry";

CREATE POLICY "rls_admin_insert_timesheetentry"
ON public."TimesheetEntry"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_timesheetentry" ON public."TimesheetEntry";

CREATE POLICY "rls_admin_update_timesheetentry"
ON public."TimesheetEntry"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_timesheetentry" ON public."TimesheetEntry";

CREATE POLICY "rls_admin_delete_timesheetentry"
ON public."TimesheetEntry"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: TimesheetApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_timesheetapproval" ON public."TimesheetApproval";

CREATE POLICY "rls_admin_select_timesheetapproval"
ON public."TimesheetApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_timesheetapproval" ON public."TimesheetApproval";

CREATE POLICY "rls_admin_insert_timesheetapproval"
ON public."TimesheetApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_timesheetapproval" ON public."TimesheetApproval";

CREATE POLICY "rls_admin_update_timesheetapproval"
ON public."TimesheetApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_timesheetapproval" ON public."TimesheetApproval";

CREATE POLICY "rls_admin_delete_timesheetapproval"
ON public."TimesheetApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectRisk uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectrisk" ON public."ProjectRisk";

CREATE POLICY "rls_admin_select_projectrisk"
ON public."ProjectRisk"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectrisk" ON public."ProjectRisk";

CREATE POLICY "rls_admin_insert_projectrisk"
ON public."ProjectRisk"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectrisk" ON public."ProjectRisk";

CREATE POLICY "rls_admin_update_projectrisk"
ON public."ProjectRisk"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectrisk" ON public."ProjectRisk";

CREATE POLICY "rls_admin_delete_projectrisk"
ON public."ProjectRisk"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectIssue uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectissue" ON public."ProjectIssue";

CREATE POLICY "rls_admin_select_projectissue"
ON public."ProjectIssue"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectissue" ON public."ProjectIssue";

CREATE POLICY "rls_admin_insert_projectissue"
ON public."ProjectIssue"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectissue" ON public."ProjectIssue";

CREATE POLICY "rls_admin_update_projectissue"
ON public."ProjectIssue"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectissue" ON public."ProjectIssue";

CREATE POLICY "rls_admin_delete_projectissue"
ON public."ProjectIssue"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectDocument uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectdocument" ON public."ProjectDocument";

CREATE POLICY "rls_admin_select_projectdocument"
ON public."ProjectDocument"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectdocument" ON public."ProjectDocument";

CREATE POLICY "rls_admin_insert_projectdocument"
ON public."ProjectDocument"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectdocument" ON public."ProjectDocument";

CREATE POLICY "rls_admin_update_projectdocument"
ON public."ProjectDocument"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectdocument" ON public."ProjectDocument";

CREATE POLICY "rls_admin_delete_projectdocument"
ON public."ProjectDocument"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectExternalAccess uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectexternalaccess" ON public."ProjectExternalAccess";

CREATE POLICY "rls_admin_select_projectexternalaccess"
ON public."ProjectExternalAccess"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectexternalaccess" ON public."ProjectExternalAccess";

CREATE POLICY "rls_admin_insert_projectexternalaccess"
ON public."ProjectExternalAccess"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectexternalaccess" ON public."ProjectExternalAccess";

CREATE POLICY "rls_admin_update_projectexternalaccess"
ON public."ProjectExternalAccess"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectexternalaccess" ON public."ProjectExternalAccess";

CREATE POLICY "rls_admin_delete_projectexternalaccess"
ON public."ProjectExternalAccess"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectLocation uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectlocation" ON public."ProjectLocation";

CREATE POLICY "rls_admin_select_projectlocation"
ON public."ProjectLocation"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectlocation" ON public."ProjectLocation";

CREATE POLICY "rls_admin_insert_projectlocation"
ON public."ProjectLocation"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectlocation" ON public."ProjectLocation";

CREATE POLICY "rls_admin_update_projectlocation"
ON public."ProjectLocation"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectlocation" ON public."ProjectLocation";

CREATE POLICY "rls_admin_delete_projectlocation"
ON public."ProjectLocation"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RFI uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_rfi" ON public."RFI";

CREATE POLICY "rls_admin_select_rfi"
ON public."RFI"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_rfi" ON public."RFI";

CREATE POLICY "rls_admin_insert_rfi"
ON public."RFI"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_rfi" ON public."RFI";

CREATE POLICY "rls_admin_update_rfi"
ON public."RFI"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_rfi" ON public."RFI";

CREATE POLICY "rls_admin_delete_rfi"
ON public."RFI"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: RFIReply uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_rfireply" ON public."RFIReply";

CREATE POLICY "rls_admin_select_rfireply"
ON public."RFIReply"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_rfireply" ON public."RFIReply";

CREATE POLICY "rls_admin_insert_rfireply"
ON public."RFIReply"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_rfireply" ON public."RFIReply";

CREATE POLICY "rls_admin_update_rfireply"
ON public."RFIReply"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_rfireply" ON public."RFIReply";

CREATE POLICY "rls_admin_delete_rfireply"
ON public."RFIReply"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Submittal uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_submittal" ON public."Submittal";

CREATE POLICY "rls_admin_select_submittal"
ON public."Submittal"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_submittal" ON public."Submittal";

CREATE POLICY "rls_admin_insert_submittal"
ON public."Submittal"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_submittal" ON public."Submittal";

CREATE POLICY "rls_admin_update_submittal"
ON public."Submittal"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_submittal" ON public."Submittal";

CREATE POLICY "rls_admin_delete_submittal"
ON public."Submittal"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SubmittalApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_submittalapproval" ON public."SubmittalApproval";

CREATE POLICY "rls_admin_select_submittalapproval"
ON public."SubmittalApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_submittalapproval" ON public."SubmittalApproval";

CREATE POLICY "rls_admin_insert_submittalapproval"
ON public."SubmittalApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_submittalapproval" ON public."SubmittalApproval";

CREATE POLICY "rls_admin_update_submittalapproval"
ON public."SubmittalApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_submittalapproval" ON public."SubmittalApproval";

CREATE POLICY "rls_admin_delete_submittalapproval"
ON public."SubmittalApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: SubmittalItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_submittalitem" ON public."SubmittalItem";

CREATE POLICY "rls_admin_select_submittalitem"
ON public."SubmittalItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_submittalitem" ON public."SubmittalItem";

CREATE POLICY "rls_admin_insert_submittalitem"
ON public."SubmittalItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_submittalitem" ON public."SubmittalItem";

CREATE POLICY "rls_admin_update_submittalitem"
ON public."SubmittalItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_submittalitem" ON public."SubmittalItem";

CREATE POLICY "rls_admin_delete_submittalitem"
ON public."SubmittalItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: DailyLog uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_dailylog" ON public."DailyLog";

CREATE POLICY "rls_admin_select_dailylog"
ON public."DailyLog"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_dailylog" ON public."DailyLog";

CREATE POLICY "rls_admin_insert_dailylog"
ON public."DailyLog"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_dailylog" ON public."DailyLog";

CREATE POLICY "rls_admin_update_dailylog"
ON public."DailyLog"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_dailylog" ON public."DailyLog";

CREATE POLICY "rls_admin_delete_dailylog"
ON public."DailyLog"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PunchList uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_punchlist" ON public."PunchList";

CREATE POLICY "rls_admin_select_punchlist"
ON public."PunchList"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_punchlist" ON public."PunchList";

CREATE POLICY "rls_admin_insert_punchlist"
ON public."PunchList"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_punchlist" ON public."PunchList";

CREATE POLICY "rls_admin_update_punchlist"
ON public."PunchList"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_punchlist" ON public."PunchList";

CREATE POLICY "rls_admin_delete_punchlist"
ON public."PunchList"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PunchListItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_punchlistitem" ON public."PunchListItem";

CREATE POLICY "rls_admin_select_punchlistitem"
ON public."PunchListItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_punchlistitem" ON public."PunchListItem";

CREATE POLICY "rls_admin_insert_punchlistitem"
ON public."PunchListItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_punchlistitem" ON public."PunchListItem";

CREATE POLICY "rls_admin_update_punchlistitem"
ON public."PunchListItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_punchlistitem" ON public."PunchListItem";

CREATE POLICY "rls_admin_delete_punchlistitem"
ON public."PunchListItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Inspection uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inspection" ON public."Inspection";

CREATE POLICY "rls_admin_select_inspection"
ON public."Inspection"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inspection" ON public."Inspection";

CREATE POLICY "rls_admin_insert_inspection"
ON public."Inspection"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inspection" ON public."Inspection";

CREATE POLICY "rls_admin_update_inspection"
ON public."Inspection"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inspection" ON public."Inspection";

CREATE POLICY "rls_admin_delete_inspection"
ON public."Inspection"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InspectionApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inspectionapproval" ON public."InspectionApproval";

CREATE POLICY "rls_admin_select_inspectionapproval"
ON public."InspectionApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inspectionapproval" ON public."InspectionApproval";

CREATE POLICY "rls_admin_insert_inspectionapproval"
ON public."InspectionApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inspectionapproval" ON public."InspectionApproval";

CREATE POLICY "rls_admin_update_inspectionapproval"
ON public."InspectionApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inspectionapproval" ON public."InspectionApproval";

CREATE POLICY "rls_admin_delete_inspectionapproval"
ON public."InspectionApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InspectionItem uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inspectionitem" ON public."InspectionItem";

CREATE POLICY "rls_admin_select_inspectionitem"
ON public."InspectionItem"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inspectionitem" ON public."InspectionItem";

CREATE POLICY "rls_admin_insert_inspectionitem"
ON public."InspectionItem"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inspectionitem" ON public."InspectionItem";

CREATE POLICY "rls_admin_update_inspectionitem"
ON public."InspectionItem"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inspectionitem" ON public."InspectionItem";

CREATE POLICY "rls_admin_delete_inspectionitem"
ON public."InspectionItem"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectFinancialSnapshot uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectfinancialsnapshot" ON public."ProjectFinancialSnapshot";

CREATE POLICY "rls_admin_select_projectfinancialsnapshot"
ON public."ProjectFinancialSnapshot"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectfinancialsnapshot" ON public."ProjectFinancialSnapshot";

CREATE POLICY "rls_admin_insert_projectfinancialsnapshot"
ON public."ProjectFinancialSnapshot"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectfinancialsnapshot" ON public."ProjectFinancialSnapshot";

CREATE POLICY "rls_admin_update_projectfinancialsnapshot"
ON public."ProjectFinancialSnapshot"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectfinancialsnapshot" ON public."ProjectFinancialSnapshot";

CREATE POLICY "rls_admin_delete_projectfinancialsnapshot"
ON public."ProjectFinancialSnapshot"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectBudgetLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectbudgetline" ON public."ProjectBudgetLine";

CREATE POLICY "rls_admin_select_projectbudgetline"
ON public."ProjectBudgetLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectbudgetline" ON public."ProjectBudgetLine";

CREATE POLICY "rls_admin_insert_projectbudgetline"
ON public."ProjectBudgetLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectbudgetline" ON public."ProjectBudgetLine";

CREATE POLICY "rls_admin_update_projectbudgetline"
ON public."ProjectBudgetLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectbudgetline" ON public."ProjectBudgetLine";

CREATE POLICY "rls_admin_delete_projectbudgetline"
ON public."ProjectBudgetLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectMember uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectmember" ON public."ProjectMember";

CREATE POLICY "rls_admin_select_projectmember"
ON public."ProjectMember"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectmember" ON public."ProjectMember";

CREATE POLICY "rls_admin_insert_projectmember"
ON public."ProjectMember"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectmember" ON public."ProjectMember";

CREATE POLICY "rls_admin_update_projectmember"
ON public."ProjectMember"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectmember" ON public."ProjectMember";

CREATE POLICY "rls_admin_delete_projectmember"
ON public."ProjectMember"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectNote uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectnote" ON public."ProjectNote";

CREATE POLICY "rls_admin_select_projectnote"
ON public."ProjectNote"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectnote" ON public."ProjectNote";

CREATE POLICY "rls_admin_insert_projectnote"
ON public."ProjectNote"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectnote" ON public."ProjectNote";

CREATE POLICY "rls_admin_update_projectnote"
ON public."ProjectNote"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectnote" ON public."ProjectNote";

CREATE POLICY "rls_admin_delete_projectnote"
ON public."ProjectNote"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectReport uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectreport" ON public."ProjectReport";

CREATE POLICY "rls_admin_select_projectreport"
ON public."ProjectReport"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectreport" ON public."ProjectReport";

CREATE POLICY "rls_admin_insert_projectreport"
ON public."ProjectReport"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectreport" ON public."ProjectReport";

CREATE POLICY "rls_admin_update_projectreport"
ON public."ProjectReport"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectreport" ON public."ProjectReport";

CREATE POLICY "rls_admin_delete_projectreport"
ON public."ProjectReport"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ProjectInventoryTransaction uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_projectinventorytransaction" ON public."ProjectInventoryTransaction";

CREATE POLICY "rls_admin_select_projectinventorytransaction"
ON public."ProjectInventoryTransaction"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_projectinventorytransaction" ON public."ProjectInventoryTransaction";

CREATE POLICY "rls_admin_insert_projectinventorytransaction"
ON public."ProjectInventoryTransaction"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_projectinventorytransaction" ON public."ProjectInventoryTransaction";

CREATE POLICY "rls_admin_update_projectinventorytransaction"
ON public."ProjectInventoryTransaction"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_projectinventorytransaction" ON public."ProjectInventoryTransaction";

CREATE POLICY "rls_admin_delete_projectinventorytransaction"
ON public."ProjectInventoryTransaction"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ChangeOrder uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_changeorder" ON public."ChangeOrder";

CREATE POLICY "rls_admin_select_changeorder"
ON public."ChangeOrder"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_changeorder" ON public."ChangeOrder";

CREATE POLICY "rls_admin_insert_changeorder"
ON public."ChangeOrder"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_changeorder" ON public."ChangeOrder";

CREATE POLICY "rls_admin_update_changeorder"
ON public."ChangeOrder"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_changeorder" ON public."ChangeOrder";

CREATE POLICY "rls_admin_delete_changeorder"
ON public."ChangeOrder"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ChangeOrderLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_changeorderline" ON public."ChangeOrderLine";

CREATE POLICY "rls_admin_select_changeorderline"
ON public."ChangeOrderLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_changeorderline" ON public."ChangeOrderLine";

CREATE POLICY "rls_admin_insert_changeorderline"
ON public."ChangeOrderLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_changeorderline" ON public."ChangeOrderLine";

CREATE POLICY "rls_admin_update_changeorderline"
ON public."ChangeOrderLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_changeorderline" ON public."ChangeOrderLine";

CREATE POLICY "rls_admin_delete_changeorderline"
ON public."ChangeOrderLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ChangeOrderApproval uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_changeorderapproval" ON public."ChangeOrderApproval";

CREATE POLICY "rls_admin_select_changeorderapproval"
ON public."ChangeOrderApproval"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_changeorderapproval" ON public."ChangeOrderApproval";

CREATE POLICY "rls_admin_insert_changeorderapproval"
ON public."ChangeOrderApproval"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_changeorderapproval" ON public."ChangeOrderApproval";

CREATE POLICY "rls_admin_update_changeorderapproval"
ON public."ChangeOrderApproval"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_changeorderapproval" ON public."ChangeOrderApproval";

CREATE POLICY "rls_admin_delete_changeorderapproval"
ON public."ChangeOrderApproval"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ChangeOrderDocument uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_changeorderdocument" ON public."ChangeOrderDocument";

CREATE POLICY "rls_admin_select_changeorderdocument"
ON public."ChangeOrderDocument"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_changeorderdocument" ON public."ChangeOrderDocument";

CREATE POLICY "rls_admin_insert_changeorderdocument"
ON public."ChangeOrderDocument"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_changeorderdocument" ON public."ChangeOrderDocument";

CREATE POLICY "rls_admin_update_changeorderdocument"
ON public."ChangeOrderDocument"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_changeorderdocument" ON public."ChangeOrderDocument";

CREATE POLICY "rls_admin_delete_changeorderdocument"
ON public."ChangeOrderDocument"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Vendor uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_vendor" ON public."Vendor";

CREATE POLICY "rls_admin_select_vendor"
ON public."Vendor"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_vendor" ON public."Vendor";

CREATE POLICY "rls_admin_insert_vendor"
ON public."Vendor"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_vendor" ON public."Vendor";

CREATE POLICY "rls_admin_update_vendor"
ON public."Vendor"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_vendor" ON public."Vendor";

CREATE POLICY "rls_admin_delete_vendor"
ON public."Vendor"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PurchaseOrderLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_purchaseorderline" ON public."PurchaseOrderLine";

CREATE POLICY "rls_admin_select_purchaseorderline"
ON public."PurchaseOrderLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_purchaseorderline" ON public."PurchaseOrderLine";

CREATE POLICY "rls_admin_insert_purchaseorderline"
ON public."PurchaseOrderLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_purchaseorderline" ON public."PurchaseOrderLine";

CREATE POLICY "rls_admin_update_purchaseorderline"
ON public."PurchaseOrderLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_purchaseorderline" ON public."PurchaseOrderLine";

CREATE POLICY "rls_admin_delete_purchaseorderline"
ON public."PurchaseOrderLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: APBillLine uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_apbillline" ON public."APBillLine";

CREATE POLICY "rls_admin_select_apbillline"
ON public."APBillLine"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_apbillline" ON public."APBillLine";

CREATE POLICY "rls_admin_insert_apbillline"
ON public."APBillLine"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_apbillline" ON public."APBillLine";

CREATE POLICY "rls_admin_update_apbillline"
ON public."APBillLine"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_apbillline" ON public."APBillLine";

CREATE POLICY "rls_admin_delete_apbillline"
ON public."APBillLine"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: ExpenseReceipt uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_expensereceipt" ON public."ExpenseReceipt";

CREATE POLICY "rls_admin_select_expensereceipt"
ON public."ExpenseReceipt"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_expensereceipt" ON public."ExpenseReceipt";

CREATE POLICY "rls_admin_insert_expensereceipt"
ON public."ExpenseReceipt"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_expensereceipt" ON public."ExpenseReceipt";

CREATE POLICY "rls_admin_update_expensereceipt"
ON public."ExpenseReceipt"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_expensereceipt" ON public."ExpenseReceipt";

CREATE POLICY "rls_admin_delete_expensereceipt"
ON public."ExpenseReceipt"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: InventoryAdjustment uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_inventoryadjustment" ON public."InventoryAdjustment";

CREATE POLICY "rls_admin_select_inventoryadjustment"
ON public."InventoryAdjustment"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_inventoryadjustment" ON public."InventoryAdjustment";

CREATE POLICY "rls_admin_insert_inventoryadjustment"
ON public."InventoryAdjustment"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_inventoryadjustment" ON public."InventoryAdjustment";

CREATE POLICY "rls_admin_update_inventoryadjustment"
ON public."InventoryAdjustment"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_inventoryadjustment" ON public."InventoryAdjustment";

CREATE POLICY "rls_admin_delete_inventoryadjustment"
ON public."InventoryAdjustment"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: Asset uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_asset" ON public."Asset";

CREATE POLICY "rls_admin_select_asset"
ON public."Asset"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_asset" ON public."Asset";

CREATE POLICY "rls_admin_insert_asset"
ON public."Asset"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_asset" ON public."Asset";

CREATE POLICY "rls_admin_update_asset"
ON public."Asset"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_asset" ON public."Asset";

CREATE POLICY "rls_admin_delete_asset"
ON public."Asset"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: AssetMaintenance uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_assetmaintenance" ON public."AssetMaintenance";

CREATE POLICY "rls_admin_select_assetmaintenance"
ON public."AssetMaintenance"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_assetmaintenance" ON public."AssetMaintenance";

CREATE POLICY "rls_admin_insert_assetmaintenance"
ON public."AssetMaintenance"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_assetmaintenance" ON public."AssetMaintenance";

CREATE POLICY "rls_admin_update_assetmaintenance"
ON public."AssetMaintenance"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_assetmaintenance" ON public."AssetMaintenance";

CREATE POLICY "rls_admin_delete_assetmaintenance"
ON public."AssetMaintenance"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: PayrollRun uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_payrollrun" ON public."PayrollRun";

CREATE POLICY "rls_admin_select_payrollrun"
ON public."PayrollRun"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_payrollrun" ON public."PayrollRun";

CREATE POLICY "rls_admin_insert_payrollrun"
ON public."PayrollRun"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_payrollrun" ON public."PayrollRun";

CREATE POLICY "rls_admin_update_payrollrun"
ON public."PayrollRun"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_payrollrun" ON public."PayrollRun";

CREATE POLICY "rls_admin_delete_payrollrun"
ON public."PayrollRun"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: EmailTemplate uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_emailtemplate" ON public."EmailTemplate";

CREATE POLICY "rls_admin_select_emailtemplate"
ON public."EmailTemplate"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_emailtemplate" ON public."EmailTemplate";

CREATE POLICY "rls_admin_insert_emailtemplate"
ON public."EmailTemplate"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_emailtemplate" ON public."EmailTemplate";

CREATE POLICY "rls_admin_update_emailtemplate"
ON public."EmailTemplate"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_emailtemplate" ON public."EmailTemplate";

CREATE POLICY "rls_admin_delete_emailtemplate"
ON public."EmailTemplate"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: external_data_policies uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_external_data_policies" ON public."external_data_policies";

CREATE POLICY "rls_admin_select_external_data_policies"
ON public."external_data_policies"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_external_data_policies" ON public."external_data_policies";

CREATE POLICY "rls_admin_insert_external_data_policies"
ON public."external_data_policies"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_external_data_policies" ON public."external_data_policies";

CREATE POLICY "rls_admin_update_external_data_policies"
ON public."external_data_policies"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_external_data_policies" ON public."external_data_policies";

CREATE POLICY "rls_admin_delete_external_data_policies"
ON public."external_data_policies"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: redaction_rules uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_redaction_rules" ON public."redaction_rules";

CREATE POLICY "rls_admin_select_redaction_rules"
ON public."redaction_rules"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_redaction_rules" ON public."redaction_rules";

CREATE POLICY "rls_admin_insert_redaction_rules"
ON public."redaction_rules"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_redaction_rules" ON public."redaction_rules";

CREATE POLICY "rls_admin_update_redaction_rules"
ON public."redaction_rules"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_redaction_rules" ON public."redaction_rules";

CREATE POLICY "rls_admin_delete_redaction_rules"
ON public."redaction_rules"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- ================================================================================

-- Note: watermark_policies uses soft delete (deletedAt)
-- Role: ADMIN

-- SELECT
DROP POLICY IF EXISTS "rls_admin_select_watermark_policies" ON public."watermark_policies";

CREATE POLICY "rls_admin_select_watermark_policies"
ON public."watermark_policies"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
);

-- INSERT
DROP POLICY IF EXISTS "rls_admin_insert_watermark_policies" ON public."watermark_policies";

CREATE POLICY "rls_admin_insert_watermark_policies"
ON public."watermark_policies"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- UPDATE
DROP POLICY IF EXISTS "rls_admin_update_watermark_policies" ON public."watermark_policies";

CREATE POLICY "rls_admin_update_watermark_policies"
ON public."watermark_policies"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

-- DELETE
DROP POLICY IF EXISTS "rls_admin_delete_watermark_policies" ON public."watermark_policies";

CREATE POLICY "rls_admin_delete_watermark_policies"
ON public."watermark_policies"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);

