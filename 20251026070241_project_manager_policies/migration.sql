-- ============================================================================
-- BEGIN TRANSACTION WRAPPER
-- Ensures atomic creation of all RLS policies for PROJECT_MANAGER
-- If any policy creation fails, the entire batch will rollback
-- ============================================================================

BEGIN;

-- ============================================================================ 
-- 🚀 START OF PROJECT_MANAGER POLICY CREATION 
-- ============================================================================

-- ============================================================================
-- PROJECT_MANAGER RLS POLICIES - Multi-Tenant Security Implementation
-- Auto-generated from RBAC.schema.v7.yml PROJECT_MANAGER permissions
-- Pattern: IDEMPOTENT PL/pgSQL - Safe for production deployment
-- Date: 2025-10-05
-- ============================================================================
--
-- ✨ IDEMPOTENT PATTERN: Uses pg_policies system table to check existence
-- 🚀 PRODUCTION-READY: Safe for Neon, Supabase, and repeated deployments
-- 🔒 SECURITY: app.is_project_manager() + tenant isolation + soft delete awareness
-- 📋 CONDITIONAL: TenantSettings toggles documented at bottom
-- 🌍 GLOBAL TABLES EXCLUDED: 34 tables without tenantId automatically skipped
--
-- PROJECT_MANAGER Role Check Function:
-- Uses app.is_project_manager() helper from 004_helpers.sql
--
-- ============================================================================

-- ============================================================================
-- ACCOUNT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_account'
      AND schemaname = 'public'
      AND tablename = 'Account'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_account';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_account"
      ON public."Account"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_account';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_account'
      AND schemaname = 'public'
      AND tablename = 'Account'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_account';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_account"
      ON public."Account"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_account';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_account'
      AND schemaname = 'public'
      AND tablename = 'Account'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_account';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_account"
      ON public."Account"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_account';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_account'
      AND schemaname = 'public'
      AND tablename = 'Account'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_account';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_account"
      ON public."Account"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_account';
  END IF;
END $$;


-- ============================================================================
-- ACCOUNTADDRESS POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_accountaddress'
      AND schemaname = 'public'
      AND tablename = 'AccountAddress'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_accountaddress';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_accountaddress"
      ON public."AccountAddress"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_accountaddress';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_accountaddress'
      AND schemaname = 'public'
      AND tablename = 'AccountAddress'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_accountaddress';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_accountaddress"
      ON public."AccountAddress"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_accountaddress';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_accountaddress'
      AND schemaname = 'public'
      AND tablename = 'AccountAddress'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_accountaddress';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_accountaddress"
      ON public."AccountAddress"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_accountaddress';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_accountaddress'
      AND schemaname = 'public'
      AND tablename = 'AccountAddress'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_accountaddress';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_accountaddress"
      ON public."AccountAddress"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_accountaddress';
  END IF;
END $$;


-- ============================================================================
-- APIKEY POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_apikey'
      AND schemaname = 'public'
      AND tablename = 'ApiKey'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_apikey';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_apikey"
      ON public."ApiKey"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_apikey';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_apikey'
      AND schemaname = 'public'
      AND tablename = 'ApiKey'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_apikey';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_apikey"
      ON public."ApiKey"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_apikey';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_apikey'
      AND schemaname = 'public'
      AND tablename = 'ApiKey'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_apikey';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_apikey"
      ON public."ApiKey"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_apikey';
  END IF;
END $$;


-- ============================================================================
-- APPROVALDECISION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_approvaldecision'
      AND schemaname = 'public'
      AND tablename = 'ApprovalDecision'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_approvaldecision';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_approvaldecision"
      ON public."ApprovalDecision"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_approvaldecision';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_approvaldecision'
      AND schemaname = 'public'
      AND tablename = 'ApprovalDecision'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_approvaldecision';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_approvaldecision"
      ON public."ApprovalDecision"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_approvaldecision';
  END IF;
END $$;


-- ============================================================================
-- APPROVALREQUEST POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_approvalrequest'
      AND schemaname = 'public'
      AND tablename = 'ApprovalRequest'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_approvalrequest';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_approvalrequest"
      ON public."ApprovalRequest"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_approvalrequest';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_approvalrequest'
      AND schemaname = 'public'
      AND tablename = 'ApprovalRequest'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_approvalrequest';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_approvalrequest"
      ON public."ApprovalRequest"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_approvalrequest';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_approvalrequest'
      AND schemaname = 'public'
      AND tablename = 'ApprovalRequest'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_approvalrequest';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_approvalrequest"
      ON public."ApprovalRequest"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_approvalrequest';
  END IF;
END $$;


-- ============================================================================
-- APPROVALRULE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_approvalrule'
      AND schemaname = 'public'
      AND tablename = 'ApprovalRule'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_approvalrule';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_approvalrule"
      ON public."ApprovalRule"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_approvalrule';
  END IF;
END $$;


-- ============================================================================
-- ASSET POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_asset'
      AND schemaname = 'public'
      AND tablename = 'Asset'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_asset';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_asset"
      ON public."Asset"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_asset';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_asset'
      AND schemaname = 'public'
      AND tablename = 'Asset'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_asset';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_asset"
      ON public."Asset"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_asset';
  END IF;
END $$;


-- ============================================================================
-- ASSETASSIGNMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_assetassignment'
      AND schemaname = 'public'
      AND tablename = 'AssetAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_assetassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_assetassignment"
      ON public."AssetAssignment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_assetassignment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_assetassignment'
      AND schemaname = 'public'
      AND tablename = 'AssetAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_assetassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_assetassignment"
      ON public."AssetAssignment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_assetassignment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_assetassignment'
      AND schemaname = 'public'
      AND tablename = 'AssetAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_assetassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_assetassignment"
      ON public."AssetAssignment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_assetassignment';
  END IF;
END $$;


-- ============================================================================
-- ATTACHMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_attachment'
      AND schemaname = 'public'
      AND tablename = 'Attachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_attachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_attachment"
      ON public."Attachment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_attachment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_attachment'
      AND schemaname = 'public'
      AND tablename = 'Attachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_attachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_attachment"
      ON public."Attachment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_attachment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_attachment'
      AND schemaname = 'public'
      AND tablename = 'Attachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_attachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_attachment"
      ON public."Attachment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_attachment';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_attachment'
      AND schemaname = 'public'
      AND tablename = 'Attachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_attachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_attachment"
      ON public."Attachment"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_attachment';
  END IF;
END $$;


-- ============================================================================
-- AUTHFACTOR POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_authfactor'
      AND schemaname = 'public'
      AND tablename = 'AuthFactor'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_authfactor';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_authfactor"
      ON public."AuthFactor"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_authfactor';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_authfactor'
      AND schemaname = 'public'
      AND tablename = 'AuthFactor'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_authfactor';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_authfactor"
      ON public."AuthFactor"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_authfactor';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_authfactor'
      AND schemaname = 'public'
      AND tablename = 'AuthFactor'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_authfactor';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_authfactor"
      ON public."AuthFactor"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_authfactor';
  END IF;
END $$;


-- ============================================================================
-- BID POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_bid'
      AND schemaname = 'public'
      AND tablename = 'Bid'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_bid';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_bid"
      ON public."Bid"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_bid';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_bid'
      AND schemaname = 'public'
      AND tablename = 'Bid'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_bid';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_bid"
      ON public."Bid"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_bid';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_bid'
      AND schemaname = 'public'
      AND tablename = 'Bid'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_bid';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_bid"
      ON public."Bid"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_bid';
  END IF;
END $$;


-- ============================================================================
-- CHANGEORDER POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_changeorder'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrder'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_changeorder';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_changeorder"
      ON public."ChangeOrder"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_changeorder';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_changeorder'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrder'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_changeorder';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_changeorder"
      ON public."ChangeOrder"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_changeorder';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_changeorder'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrder'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_changeorder';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_changeorder"
      ON public."ChangeOrder"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_changeorder';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_changeorder'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrder'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_changeorder';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_changeorder"
      ON public."ChangeOrder"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_changeorder';
  END IF;
END $$;


-- ============================================================================
-- CHANGEORDERAPPROVAL POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_changeorderapproval'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrderApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_changeorderapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_changeorderapproval"
      ON public."ChangeOrderApproval"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_changeorderapproval';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_changeorderapproval'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrderApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_changeorderapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_changeorderapproval"
      ON public."ChangeOrderApproval"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_changeorderapproval';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_changeorderapproval'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrderApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_changeorderapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_changeorderapproval"
      ON public."ChangeOrderApproval"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_changeorderapproval';
  END IF;
END $$;


-- ============================================================================
-- CHANGEORDERLINE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_changeorderline'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrderLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_changeorderline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_changeorderline"
      ON public."ChangeOrderLine"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_changeorderline';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_changeorderline'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrderLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_changeorderline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_changeorderline"
      ON public."ChangeOrderLine"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_changeorderline';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_changeorderline'
      AND schemaname = 'public'
      AND tablename = 'ChangeOrderLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_changeorderline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_changeorderline"
      ON public."ChangeOrderLine"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_changeorderline';
  END IF;
END $$;


-- ============================================================================
-- CHANNEL POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_channel'
      AND schemaname = 'public'
      AND tablename = 'Channel'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_channel';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_channel"
      ON public."Channel"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_channel';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_channel'
      AND schemaname = 'public'
      AND tablename = 'Channel'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_channel';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_channel"
      ON public."Channel"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_channel';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_channel'
      AND schemaname = 'public'
      AND tablename = 'Channel'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_channel';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_channel"
      ON public."Channel"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_channel';
  END IF;
END $$;


-- ============================================================================
-- CHANNELMEMBER POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_channelmember'
      AND schemaname = 'public'
      AND tablename = 'ChannelMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_channelmember';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_channelmember"
      ON public."ChannelMember"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_channelmember';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_channelmember'
      AND schemaname = 'public'
      AND tablename = 'ChannelMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_channelmember';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_channelmember"
      ON public."ChannelMember"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_channelmember';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_channelmember'
      AND schemaname = 'public'
      AND tablename = 'ChannelMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_channelmember';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_channelmember"
      ON public."ChannelMember"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_channelmember';
  END IF;
END $$;


-- ============================================================================
-- CLOCKINCLOCKOUT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_clockinclockout'
      AND schemaname = 'public'
      AND tablename = 'ClockInClockOut'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_clockinclockout';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_clockinclockout"
      ON public."ClockInClockOut"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_clockinclockout';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_clockinclockout'
      AND schemaname = 'public'
      AND tablename = 'ClockInClockOut'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_clockinclockout';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_clockinclockout"
      ON public."ClockInClockOut"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_clockinclockout';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_clockinclockout'
      AND schemaname = 'public'
      AND tablename = 'ClockInClockOut'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_clockinclockout';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_clockinclockout"
      ON public."ClockInClockOut"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_clockinclockout';
  END IF;
END $$;


-- ============================================================================
-- CONTACT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_contact'
      AND schemaname = 'public'
      AND tablename = 'Contact'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_contact';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_contact"
      ON public."Contact"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_contact';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_contact'
      AND schemaname = 'public'
      AND tablename = 'Contact'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_contact';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_contact"
      ON public."Contact"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_contact';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_contact'
      AND schemaname = 'public'
      AND tablename = 'Contact'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_contact';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_contact"
      ON public."Contact"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_contact';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_contact'
      AND schemaname = 'public'
      AND tablename = 'Contact'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_contact';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_contact"
      ON public."Contact"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_contact';
  END IF;
END $$;


-- ============================================================================
-- CONTRACT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_contract'
      AND schemaname = 'public'
      AND tablename = 'Contract'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_contract';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_contract"
      ON public."Contract"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_contract';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_contract'
      AND schemaname = 'public'
      AND tablename = 'Contract'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_contract';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_contract"
      ON public."Contract"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_contract';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_contract'
      AND schemaname = 'public'
      AND tablename = 'Contract'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_contract';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_contract"
      ON public."Contract"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_contract';
  END IF;
END $$;


-- ============================================================================
-- CONTRACTTEMPLATE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_contracttemplate'
      AND schemaname = 'public'
      AND tablename = 'ContractTemplate'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_contracttemplate';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_contracttemplate"
      ON public."ContractTemplate"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_contracttemplate';
  END IF;
END $$;


-- ============================================================================
-- COSTCENTER POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_costcenter'
      AND schemaname = 'public'
      AND tablename = 'CostCenter'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_costcenter';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_costcenter"
      ON public."CostCenter"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_costcenter';
  END IF;
END $$;


-- ============================================================================
-- DAILYLOG POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_dailylog'
      AND schemaname = 'public'
      AND tablename = 'DailyLog'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_dailylog';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_dailylog"
      ON public."DailyLog"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_dailylog';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_dailylog'
      AND schemaname = 'public'
      AND tablename = 'DailyLog'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_dailylog';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_dailylog"
      ON public."DailyLog"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_dailylog';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_dailylog'
      AND schemaname = 'public'
      AND tablename = 'DailyLog'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_dailylog';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_dailylog"
      ON public."DailyLog"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_dailylog';
  END IF;
END $$;


-- ============================================================================
-- DASHBOARDDEFINITION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_dashboarddefinition'
      AND schemaname = 'public'
      AND tablename = 'DashboardDefinition'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_dashboarddefinition';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_dashboarddefinition"
      ON public."DashboardDefinition"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_dashboarddefinition';
  END IF;
END $$;


-- ============================================================================
-- DIRECTCHAT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_directchat'
      AND schemaname = 'public'
      AND tablename = 'DirectChat'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_directchat';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_directchat"
      ON public."DirectChat"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_directchat';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_directchat'
      AND schemaname = 'public'
      AND tablename = 'DirectChat'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_directchat';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_directchat"
      ON public."DirectChat"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_directchat';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_directchat'
      AND schemaname = 'public'
      AND tablename = 'DirectChat'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_directchat';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_directchat"
      ON public."DirectChat"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_directchat';
  END IF;
END $$;


-- ============================================================================
-- DIRECTMESSAGE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_directmessage';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_directmessage';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_directmessage';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_directmessage';
  END IF;
END $$;


-- ============================================================================
-- ESTIMATE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_estimate'
      AND schemaname = 'public'
      AND tablename = 'Estimate'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_estimate';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_estimate"
      ON public."Estimate"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_estimate';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_estimate'
      AND schemaname = 'public'
      AND tablename = 'Estimate'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_estimate';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_estimate"
      ON public."Estimate"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_estimate';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_estimate'
      AND schemaname = 'public'
      AND tablename = 'Estimate'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_estimate';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_estimate"
      ON public."Estimate"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_estimate';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_estimate'
      AND schemaname = 'public'
      AND tablename = 'Estimate'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_estimate';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_estimate"
      ON public."Estimate"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_estimate';
  END IF;
END $$;


-- ============================================================================
-- ESTIMATEAPPROVAL POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_estimateapproval'
      AND schemaname = 'public'
      AND tablename = 'EstimateApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_estimateapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_estimateapproval"
      ON public."EstimateApproval"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_estimateapproval';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_estimateapproval'
      AND schemaname = 'public'
      AND tablename = 'EstimateApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_estimateapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_estimateapproval"
      ON public."EstimateApproval"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_estimateapproval';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_estimateapproval'
      AND schemaname = 'public'
      AND tablename = 'EstimateApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_estimateapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_estimateapproval"
      ON public."EstimateApproval"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_estimateapproval';
  END IF;
END $$;


-- ============================================================================
-- ESTIMATEATTACHMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_estimateattachment'
      AND schemaname = 'public'
      AND tablename = 'EstimateAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_estimateattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_estimateattachment"
      ON public."EstimateAttachment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_estimateattachment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_estimateattachment'
      AND schemaname = 'public'
      AND tablename = 'EstimateAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_estimateattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_estimateattachment"
      ON public."EstimateAttachment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_estimateattachment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_estimateattachment'
      AND schemaname = 'public'
      AND tablename = 'EstimateAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_estimateattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_estimateattachment"
      ON public."EstimateAttachment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_estimateattachment';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_estimateattachment'
      AND schemaname = 'public'
      AND tablename = 'EstimateAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_estimateattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_estimateattachment"
      ON public."EstimateAttachment"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_estimateattachment';
  END IF;
END $$;


-- ============================================================================
-- ESTIMATELINEITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_estimatelineitem'
      AND schemaname = 'public'
      AND tablename = 'EstimateLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_estimatelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_estimatelineitem"
      ON public."EstimateLineItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_estimatelineitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_estimatelineitem'
      AND schemaname = 'public'
      AND tablename = 'EstimateLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_estimatelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_estimatelineitem"
      ON public."EstimateLineItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_estimatelineitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_estimatelineitem'
      AND schemaname = 'public'
      AND tablename = 'EstimateLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_estimatelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_estimatelineitem"
      ON public."EstimateLineItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_estimatelineitem';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_estimatelineitem'
      AND schemaname = 'public'
      AND tablename = 'EstimateLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_estimatelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_estimatelineitem"
      ON public."EstimateLineItem"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_estimatelineitem';
  END IF;
END $$;


-- ============================================================================
-- EXPENSE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_expense'
      AND schemaname = 'public'
      AND tablename = 'Expense'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_expense';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_expense"
      ON public."Expense"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_expense';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_expense'
      AND schemaname = 'public'
      AND tablename = 'Expense'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_expense';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_expense"
      ON public."Expense"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_expense';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_expense'
      AND schemaname = 'public'
      AND tablename = 'Expense'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_expense';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_expense"
      ON public."Expense"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_expense';
  END IF;
END $$;


-- ============================================================================
-- EXPENSELINE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_expenseline'
      AND schemaname = 'public'
      AND tablename = 'ExpenseLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_expenseline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_expenseline"
      ON public."ExpenseLine"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_expenseline';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_expenseline'
      AND schemaname = 'public'
      AND tablename = 'ExpenseLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_expenseline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_expenseline"
      ON public."ExpenseLine"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_expenseline';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_expenseline'
      AND schemaname = 'public'
      AND tablename = 'ExpenseLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_expenseline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_expenseline"
      ON public."ExpenseLine"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_expenseline';
  END IF;
END $$;


-- ============================================================================
-- EXPENSERECEIPT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_expensereceipt'
      AND schemaname = 'public'
      AND tablename = 'ExpenseReceipt'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_expensereceipt';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_expensereceipt"
      ON public."ExpenseReceipt"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_expensereceipt';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_expensereceipt'
      AND schemaname = 'public'
      AND tablename = 'ExpenseReceipt'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_expensereceipt';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_expensereceipt"
      ON public."ExpenseReceipt"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_expensereceipt';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_expensereceipt'
      AND schemaname = 'public'
      AND tablename = 'ExpenseReceipt'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_expensereceipt';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_expensereceipt"
      ON public."ExpenseReceipt"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_expensereceipt';
  END IF;
END $$;


-- ============================================================================
-- EXPORTJOB POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_exportjob'
      AND schemaname = 'public'
      AND tablename = 'ExportJob'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_exportjob';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_exportjob"
      ON public."ExportJob"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_exportjob';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_exportjob'
      AND schemaname = 'public'
      AND tablename = 'ExportJob'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_exportjob';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_exportjob"
      ON public."ExportJob"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_exportjob';
  END IF;
END $$;


-- ============================================================================
-- FILEOBJECT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_fileobject'
      AND schemaname = 'public'
      AND tablename = 'FileObject'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_fileobject';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_fileobject"
      ON public."FileObject"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_fileobject';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_fileobject'
      AND schemaname = 'public'
      AND tablename = 'FileObject'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_fileobject';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_fileobject"
      ON public."FileObject"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_fileobject';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_fileobject'
      AND schemaname = 'public'
      AND tablename = 'FileObject'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_fileobject';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_fileobject"
      ON public."FileObject"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_fileobject';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_fileobject'
      AND schemaname = 'public'
      AND tablename = 'FileObject'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_fileobject';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_fileobject"
      ON public."FileObject"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_fileobject';
  END IF;
END $$;


-- ============================================================================
-- INSPECTION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_inspection'
      AND schemaname = 'public'
      AND tablename = 'Inspection'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_inspection';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_inspection"
      ON public."Inspection"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_inspection';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_inspection'
      AND schemaname = 'public'
      AND tablename = 'Inspection'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_inspection';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_inspection"
      ON public."Inspection"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_inspection';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_inspection'
      AND schemaname = 'public'
      AND tablename = 'Inspection'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_inspection';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_inspection"
      ON public."Inspection"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_inspection';
  END IF;
END $$;


-- ============================================================================
-- INSPECTIONAPPROVAL POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_inspectionapproval'
      AND schemaname = 'public'
      AND tablename = 'InspectionApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_inspectionapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_inspectionapproval"
      ON public."InspectionApproval"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_inspectionapproval';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_inspectionapproval'
      AND schemaname = 'public'
      AND tablename = 'InspectionApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_inspectionapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_inspectionapproval"
      ON public."InspectionApproval"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_inspectionapproval';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_inspectionapproval'
      AND schemaname = 'public'
      AND tablename = 'InspectionApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_inspectionapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_inspectionapproval"
      ON public."InspectionApproval"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_inspectionapproval';
  END IF;
END $$;


-- ============================================================================
-- INSPECTIONITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_inspectionitem'
      AND schemaname = 'public'
      AND tablename = 'InspectionItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_inspectionitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_inspectionitem"
      ON public."InspectionItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_inspectionitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_inspectionitem'
      AND schemaname = 'public'
      AND tablename = 'InspectionItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_inspectionitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_inspectionitem"
      ON public."InspectionItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_inspectionitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_inspectionitem'
      AND schemaname = 'public'
      AND tablename = 'InspectionItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_inspectionitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_inspectionitem"
      ON public."InspectionItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_inspectionitem';
  END IF;
END $$;


-- ============================================================================
-- INVENTORYCOUNT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_inventorycount'
      AND schemaname = 'public'
      AND tablename = 'InventoryCount'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_inventorycount';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_inventorycount"
      ON public."InventoryCount"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_inventorycount';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_inventorycount'
      AND schemaname = 'public'
      AND tablename = 'InventoryCount'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_inventorycount';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_inventorycount"
      ON public."InventoryCount"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_inventorycount';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_inventorycount'
      AND schemaname = 'public'
      AND tablename = 'InventoryCount'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_inventorycount';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_inventorycount"
      ON public."InventoryCount"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_inventorycount';
  END IF;
END $$;


-- ============================================================================
-- INVENTORYITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_inventoryitem'
      AND schemaname = 'public'
      AND tablename = 'InventoryItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_inventoryitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_inventoryitem"
      ON public."InventoryItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_inventoryitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_inventoryitem'
      AND schemaname = 'public'
      AND tablename = 'InventoryItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_inventoryitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_inventoryitem"
      ON public."InventoryItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_inventoryitem';
  END IF;
END $$;


-- ============================================================================
-- INVENTORYTRANSACTION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_inventorytransaction'
      AND schemaname = 'public'
      AND tablename = 'InventoryTransaction'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_inventorytransaction';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_inventorytransaction"
      ON public."InventoryTransaction"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_inventorytransaction';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_inventorytransaction'
      AND schemaname = 'public'
      AND tablename = 'InventoryTransaction'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_inventorytransaction';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_inventorytransaction"
      ON public."InventoryTransaction"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_inventorytransaction';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_inventorytransaction'
      AND schemaname = 'public'
      AND tablename = 'InventoryTransaction'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_inventorytransaction';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_inventorytransaction"
      ON public."InventoryTransaction"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_inventorytransaction';
  END IF;
END $$;


-- ============================================================================
-- INVOICE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_invoice'
      AND schemaname = 'public'
      AND tablename = 'Invoice'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_invoice';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_invoice"
      ON public."Invoice"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_invoice';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_invoice'
      AND schemaname = 'public'
      AND tablename = 'Invoice'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_invoice';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_invoice"
      ON public."Invoice"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_invoice';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_invoice'
      AND schemaname = 'public'
      AND tablename = 'Invoice'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_invoice';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_invoice"
      ON public."Invoice"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_invoice';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_invoice'
      AND schemaname = 'public'
      AND tablename = 'Invoice'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_invoice';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_invoice"
      ON public."Invoice"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_invoice';
  END IF;
END $$;


-- ============================================================================
-- INVOICELINEITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_invoicelineitem'
      AND schemaname = 'public'
      AND tablename = 'InvoiceLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_invoicelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_invoicelineitem"
      ON public."InvoiceLineItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_invoicelineitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_invoicelineitem'
      AND schemaname = 'public'
      AND tablename = 'InvoiceLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_invoicelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_invoicelineitem"
      ON public."InvoiceLineItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_invoicelineitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_invoicelineitem'
      AND schemaname = 'public'
      AND tablename = 'InvoiceLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_invoicelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_invoicelineitem"
      ON public."InvoiceLineItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_invoicelineitem';
  END IF;
END $$;


-- ============================================================================
-- LEAD POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_lead'
      AND schemaname = 'public'
      AND tablename = 'Lead'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_lead';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_lead"
      ON public."Lead"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_lead';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_lead'
      AND schemaname = 'public'
      AND tablename = 'Lead'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_lead';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_lead"
      ON public."Lead"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_lead';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_lead'
      AND schemaname = 'public'
      AND tablename = 'Lead'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_lead';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_lead"
      ON public."Lead"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_lead';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_lead'
      AND schemaname = 'public'
      AND tablename = 'Lead'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_lead';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_lead"
      ON public."Lead"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_lead';
  END IF;
END $$;


-- ============================================================================
-- LEADACTIVITY POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_leadactivity'
      AND schemaname = 'public'
      AND tablename = 'LeadActivity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_leadactivity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_leadactivity"
      ON public."LeadActivity"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_leadactivity';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_leadactivity'
      AND schemaname = 'public'
      AND tablename = 'LeadActivity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_leadactivity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_leadactivity"
      ON public."LeadActivity"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_leadactivity';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_leadactivity'
      AND schemaname = 'public'
      AND tablename = 'LeadActivity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_leadactivity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_leadactivity"
      ON public."LeadActivity"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_leadactivity';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_leadactivity'
      AND schemaname = 'public'
      AND tablename = 'LeadActivity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_leadactivity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_leadactivity"
      ON public."LeadActivity"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_leadactivity';
  END IF;
END $$;


-- ============================================================================
-- LEAVE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_leave'
      AND schemaname = 'public'
      AND tablename = 'Leave'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_leave';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_leave"
      ON public."Leave"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_leave';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_leave'
      AND schemaname = 'public'
      AND tablename = 'Leave'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_leave';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_leave"
      ON public."Leave"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_leave';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_leave'
      AND schemaname = 'public'
      AND tablename = 'Leave'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_leave';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_leave"
      ON public."Leave"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_leave';
  END IF;
END $$;


-- ============================================================================
-- LEAVEOFABSENCE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_leaveofabsence'
      AND schemaname = 'public'
      AND tablename = 'LeaveOfAbsence'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_leaveofabsence';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_leaveofabsence"
      ON public."LeaveOfAbsence"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_leaveofabsence';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_leaveofabsence'
      AND schemaname = 'public'
      AND tablename = 'LeaveOfAbsence'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_leaveofabsence';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_leaveofabsence"
      ON public."LeaveOfAbsence"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_leaveofabsence';
  END IF;
END $$;


-- ============================================================================
-- LOCATION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_location'
      AND schemaname = 'public'
      AND tablename = 'Location'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_location';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_location"
      ON public."Location"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_location';
  END IF;
END $$;


-- ============================================================================
-- MEMBER POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_member'
      AND schemaname = 'public'
      AND tablename = 'Member'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_member';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_member"
      ON public."Member"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_member';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_member'
      AND schemaname = 'public'
      AND tablename = 'Member'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_member';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_member"
      ON public."Member"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_member';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_member'
      AND schemaname = 'public'
      AND tablename = 'Member'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_member';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_member"
      ON public."Member"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_member';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_member'
      AND schemaname = 'public'
      AND tablename = 'Member'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_member';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_member"
      ON public."Member"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_member';
  END IF;
END $$;


-- ============================================================================
-- MEMBERDOCUMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_memberdocument'
      AND schemaname = 'public'
      AND tablename = 'MemberDocument'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_memberdocument';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_memberdocument"
      ON public."MemberDocument"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_memberdocument';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_memberdocument'
      AND schemaname = 'public'
      AND tablename = 'MemberDocument'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_memberdocument';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_memberdocument"
      ON public."MemberDocument"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_memberdocument';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_memberdocument'
      AND schemaname = 'public'
      AND tablename = 'MemberDocument'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_memberdocument';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_memberdocument"
      ON public."MemberDocument"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_memberdocument';
  END IF;
END $$;


-- ============================================================================
-- MEMBERROLE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_memberrole'
      AND schemaname = 'public'
      AND tablename = 'MemberRole'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_memberrole';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_memberrole"
      ON public."MemberRole"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_memberrole';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_memberrole'
      AND schemaname = 'public'
      AND tablename = 'MemberRole'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_memberrole';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_memberrole"
      ON public."MemberRole"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_memberrole';
  END IF;
END $$;


-- ============================================================================
-- MEMBERSETTINGS POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_membersettings'
      AND schemaname = 'public'
      AND tablename = 'MemberSettings'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_membersettings';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_membersettings"
      ON public."MemberSettings"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_membersettings';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_membersettings'
      AND schemaname = 'public'
      AND tablename = 'MemberSettings'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_membersettings';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_membersettings"
      ON public."MemberSettings"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_membersettings';
  END IF;
END $$;


-- ============================================================================
-- NOTIFICATION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_notification'
      AND schemaname = 'public'
      AND tablename = 'Notification'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_notification';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_notification"
      ON public."Notification"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_notification';
  END IF;
END $$;


-- ============================================================================
-- NOTIFICATIONPREFERENCE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_notificationpreference'
      AND schemaname = 'public'
      AND tablename = 'NotificationPreference'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_notificationpreference';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_notificationpreference"
      ON public."NotificationPreference"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_notificationpreference';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_notificationpreference'
      AND schemaname = 'public'
      AND tablename = 'NotificationPreference'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_notificationpreference';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_notificationpreference"
      ON public."NotificationPreference"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_notificationpreference';
  END IF;
END $$;


-- ============================================================================
-- OPPORTUNITY POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_opportunity'
      AND schemaname = 'public'
      AND tablename = 'Opportunity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_opportunity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_opportunity"
      ON public."Opportunity"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_opportunity';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_opportunity'
      AND schemaname = 'public'
      AND tablename = 'Opportunity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_opportunity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_opportunity"
      ON public."Opportunity"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_opportunity';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_opportunity'
      AND schemaname = 'public'
      AND tablename = 'Opportunity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_opportunity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_opportunity"
      ON public."Opportunity"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_opportunity';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_opportunity'
      AND schemaname = 'public'
      AND tablename = 'Opportunity'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_opportunity';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_opportunity"
      ON public."Opportunity"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_opportunity';
  END IF;
END $$;


-- ============================================================================
-- OPPORTUNITYLINEITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_opportunitylineitem'
      AND schemaname = 'public'
      AND tablename = 'OpportunityLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_opportunitylineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_opportunitylineitem"
      ON public."OpportunityLineItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_opportunitylineitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_opportunitylineitem'
      AND schemaname = 'public'
      AND tablename = 'OpportunityLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_opportunitylineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_opportunitylineitem"
      ON public."OpportunityLineItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_opportunitylineitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_opportunitylineitem'
      AND schemaname = 'public'
      AND tablename = 'OpportunityLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_opportunitylineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_opportunitylineitem"
      ON public."OpportunityLineItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_opportunitylineitem';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_opportunitylineitem'
      AND schemaname = 'public'
      AND tablename = 'OpportunityLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_opportunitylineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_opportunitylineitem"
      ON public."OpportunityLineItem"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_opportunitylineitem';
  END IF;
END $$;


-- ============================================================================
-- OPPORTUNITYSTAGE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_opportunitystage'
      AND schemaname = 'public'
      AND tablename = 'OpportunityStage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_opportunitystage';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_opportunitystage"
      ON public."OpportunityStage"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_opportunitystage';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_opportunitystage'
      AND schemaname = 'public'
      AND tablename = 'OpportunityStage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_opportunitystage';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_opportunitystage"
      ON public."OpportunityStage"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_opportunitystage';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_opportunitystage'
      AND schemaname = 'public'
      AND tablename = 'OpportunityStage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_opportunitystage';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_opportunitystage"
      ON public."OpportunityStage"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_opportunitystage';
  END IF;
END $$;


-- ============================================================================
-- PAYMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_payment'
      AND schemaname = 'public'
      AND tablename = 'Payment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_payment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_payment"
      ON public."Payment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_payment';
  END IF;
END $$;


-- ============================================================================
-- PAYMENTSCHEDULE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_paymentschedule'
      AND schemaname = 'public'
      AND tablename = 'PaymentSchedule'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_paymentschedule';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_paymentschedule"
      ON public."PaymentSchedule"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_paymentschedule';
  END IF;
END $$;


-- ============================================================================
-- PAYROLLITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_payrollitem'
      AND schemaname = 'public'
      AND tablename = 'PayrollItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_payrollitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_payrollitem"
      ON public."PayrollItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_payrollitem';
  END IF;
END $$;


-- ============================================================================
-- PAYROLLRUN POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_payrollrun'
      AND schemaname = 'public'
      AND tablename = 'PayrollRun'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_payrollrun';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_payrollrun"
      ON public."PayrollRun"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_payrollrun';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_payrollrun'
      AND schemaname = 'public'
      AND tablename = 'PayrollRun'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_payrollrun';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_payrollrun"
      ON public."PayrollRun"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_payrollrun';
  END IF;
END $$;


-- ============================================================================
-- PROJECT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_project'
      AND schemaname = 'public'
      AND tablename = 'Project'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_project';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_project"
      ON public."Project"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_project';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_project'
      AND schemaname = 'public'
      AND tablename = 'Project'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_project';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_project"
      ON public."Project"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_project';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_project'
      AND schemaname = 'public'
      AND tablename = 'Project'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_project';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_project"
      ON public."Project"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_project';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_project'
      AND schemaname = 'public'
      AND tablename = 'Project'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_project';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_project"
      ON public."Project"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_project';
  END IF;
END $$;


-- ============================================================================
-- PROJECTBUDGETLINE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projectbudgetline'
      AND schemaname = 'public'
      AND tablename = 'ProjectBudgetLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projectbudgetline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projectbudgetline"
      ON public."ProjectBudgetLine"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projectbudgetline';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projectbudgetline'
      AND schemaname = 'public'
      AND tablename = 'ProjectBudgetLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projectbudgetline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projectbudgetline"
      ON public."ProjectBudgetLine"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projectbudgetline';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projectbudgetline'
      AND schemaname = 'public'
      AND tablename = 'ProjectBudgetLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projectbudgetline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projectbudgetline"
      ON public."ProjectBudgetLine"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projectbudgetline';
  END IF;
END $$;


-- ============================================================================
-- PROJECTFINANCIALSNAPSHOT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projectfinancialsnapshot'
      AND schemaname = 'public'
      AND tablename = 'ProjectFinancialSnapshot'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projectfinancialsnapshot';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projectfinancialsnapshot"
      ON public."ProjectFinancialSnapshot"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projectfinancialsnapshot';
  END IF;
END $$;


-- ============================================================================
-- PROJECTLOCATION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projectlocation'
      AND schemaname = 'public'
      AND tablename = 'ProjectLocation'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projectlocation';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projectlocation"
      ON public."ProjectLocation"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projectlocation';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projectlocation'
      AND schemaname = 'public'
      AND tablename = 'ProjectLocation'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projectlocation';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projectlocation"
      ON public."ProjectLocation"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projectlocation';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projectlocation'
      AND schemaname = 'public'
      AND tablename = 'ProjectLocation'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projectlocation';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projectlocation"
      ON public."ProjectLocation"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projectlocation';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projectlocation'
      AND schemaname = 'public'
      AND tablename = 'ProjectLocation'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projectlocation';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projectlocation"
      ON public."ProjectLocation"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projectlocation';
  END IF;
END $$;


-- ============================================================================
-- PROJECTMEMBER POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projectmember'
      AND schemaname = 'public'
      AND tablename = 'ProjectMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projectmember';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projectmember"
      ON public."ProjectMember"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projectmember';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projectmember'
      AND schemaname = 'public'
      AND tablename = 'ProjectMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projectmember';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projectmember"
      ON public."ProjectMember"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projectmember';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projectmember'
      AND schemaname = 'public'
      AND tablename = 'ProjectMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projectmember';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projectmember"
      ON public."ProjectMember"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projectmember';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projectmember'
      AND schemaname = 'public'
      AND tablename = 'ProjectMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projectmember';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projectmember"
      ON public."ProjectMember"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projectmember';
  END IF;
END $$;


-- ============================================================================
-- PROJECTNOTE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projectnote'
      AND schemaname = 'public'
      AND tablename = 'ProjectNote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projectnote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projectnote"
      ON public."ProjectNote"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projectnote';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projectnote'
      AND schemaname = 'public'
      AND tablename = 'ProjectNote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projectnote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projectnote"
      ON public."ProjectNote"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projectnote';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projectnote'
      AND schemaname = 'public'
      AND tablename = 'ProjectNote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projectnote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projectnote"
      ON public."ProjectNote"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projectnote';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projectnote'
      AND schemaname = 'public'
      AND tablename = 'ProjectNote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projectnote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projectnote"
      ON public."ProjectNote"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projectnote';
  END IF;
END $$;


-- ============================================================================
-- PROJECTPHASE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projectphase'
      AND schemaname = 'public'
      AND tablename = 'ProjectPhase'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projectphase';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projectphase"
      ON public."ProjectPhase"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projectphase';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projectphase'
      AND schemaname = 'public'
      AND tablename = 'ProjectPhase'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projectphase';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projectphase"
      ON public."ProjectPhase"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projectphase';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projectphase'
      AND schemaname = 'public'
      AND tablename = 'ProjectPhase'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projectphase';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projectphase"
      ON public."ProjectPhase"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projectphase';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projectphase'
      AND schemaname = 'public'
      AND tablename = 'ProjectPhase'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projectphase';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projectphase"
      ON public."ProjectPhase"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projectphase';
  END IF;
END $$;


-- ============================================================================
-- PROJECTREPORT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projectreport'
      AND schemaname = 'public'
      AND tablename = 'ProjectReport'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projectreport';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projectreport"
      ON public."ProjectReport"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projectreport';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projectreport'
      AND schemaname = 'public'
      AND tablename = 'ProjectReport'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projectreport';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projectreport"
      ON public."ProjectReport"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projectreport';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projectreport'
      AND schemaname = 'public'
      AND tablename = 'ProjectReport'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projectreport';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projectreport"
      ON public."ProjectReport"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projectreport';
  END IF;
END $$;


-- ============================================================================
-- PROJECTTASK POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projecttask'
      AND schemaname = 'public'
      AND tablename = 'ProjectTask'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projecttask';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projecttask"
      ON public."ProjectTask"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projecttask';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projecttask'
      AND schemaname = 'public'
      AND tablename = 'ProjectTask'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projecttask';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projecttask"
      ON public."ProjectTask"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projecttask';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projecttask'
      AND schemaname = 'public'
      AND tablename = 'ProjectTask'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projecttask';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projecttask"
      ON public."ProjectTask"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projecttask';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projecttask'
      AND schemaname = 'public'
      AND tablename = 'ProjectTask'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projecttask';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projecttask"
      ON public."ProjectTask"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projecttask';
  END IF;
END $$;


-- ============================================================================
-- PROJECTTASKASSIGNMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projecttaskassignment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projecttaskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projecttaskassignment"
      ON public."ProjectTaskAssignment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projecttaskassignment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projecttaskassignment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projecttaskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projecttaskassignment"
      ON public."ProjectTaskAssignment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projecttaskassignment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projecttaskassignment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projecttaskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projecttaskassignment"
      ON public."ProjectTaskAssignment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projecttaskassignment';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projecttaskassignment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projecttaskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projecttaskassignment"
      ON public."ProjectTaskAssignment"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projecttaskassignment';
  END IF;
END $$;


-- ============================================================================
-- PROJECTTASKCOMMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projecttaskcomment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskComment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projecttaskcomment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projecttaskcomment"
      ON public."ProjectTaskComment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projecttaskcomment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projecttaskcomment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskComment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projecttaskcomment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projecttaskcomment"
      ON public."ProjectTaskComment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projecttaskcomment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projecttaskcomment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskComment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projecttaskcomment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projecttaskcomment"
      ON public."ProjectTaskComment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projecttaskcomment';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projecttaskcomment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskComment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projecttaskcomment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projecttaskcomment"
      ON public."ProjectTaskComment"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projecttaskcomment';
  END IF;
END $$;


-- ============================================================================
-- PROJECTTASKDEPENDENCY POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_projecttaskdependency'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_projecttaskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_projecttaskdependency"
      ON public."ProjectTaskDependency"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_projecttaskdependency';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_projecttaskdependency'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_projecttaskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_projecttaskdependency"
      ON public."ProjectTaskDependency"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_projecttaskdependency';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_projecttaskdependency'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_projecttaskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_projecttaskdependency"
      ON public."ProjectTaskDependency"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_projecttaskdependency';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_projecttaskdependency'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_projecttaskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_projecttaskdependency"
      ON public."ProjectTaskDependency"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_projecttaskdependency';
  END IF;
END $$;


-- ============================================================================
-- PUNCHLIST POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_punchlist'
      AND schemaname = 'public'
      AND tablename = 'PunchList'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_punchlist';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_punchlist"
      ON public."PunchList"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_punchlist';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_punchlist'
      AND schemaname = 'public'
      AND tablename = 'PunchList'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_punchlist';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_punchlist"
      ON public."PunchList"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_punchlist';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_punchlist'
      AND schemaname = 'public'
      AND tablename = 'PunchList'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_punchlist';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_punchlist"
      ON public."PunchList"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_punchlist';
  END IF;
END $$;


-- ============================================================================
-- PUNCHLISTITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_punchlistitem'
      AND schemaname = 'public'
      AND tablename = 'PunchListItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_punchlistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_punchlistitem"
      ON public."PunchListItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_punchlistitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_punchlistitem'
      AND schemaname = 'public'
      AND tablename = 'PunchListItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_punchlistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_punchlistitem"
      ON public."PunchListItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_punchlistitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_punchlistitem'
      AND schemaname = 'public'
      AND tablename = 'PunchListItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_punchlistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_punchlistitem"
      ON public."PunchListItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_punchlistitem';
  END IF;
END $$;


-- ============================================================================
-- PURCHASEORDER POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_purchaseorder'
      AND schemaname = 'public'
      AND tablename = 'PurchaseOrder'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_purchaseorder';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_purchaseorder"
      ON public."PurchaseOrder"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_purchaseorder';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_purchaseorder'
      AND schemaname = 'public'
      AND tablename = 'PurchaseOrder'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_purchaseorder';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_purchaseorder"
      ON public."PurchaseOrder"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_purchaseorder';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_purchaseorder'
      AND schemaname = 'public'
      AND tablename = 'PurchaseOrder'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_purchaseorder';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_purchaseorder"
      ON public."PurchaseOrder"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_purchaseorder';
  END IF;
END $$;


-- ============================================================================
-- PURCHASEORDERLINE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_purchaseorderline'
      AND schemaname = 'public'
      AND tablename = 'PurchaseOrderLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_purchaseorderline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_purchaseorderline"
      ON public."PurchaseOrderLine"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_purchaseorderline';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_purchaseorderline'
      AND schemaname = 'public'
      AND tablename = 'PurchaseOrderLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_purchaseorderline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_purchaseorderline"
      ON public."PurchaseOrderLine"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_purchaseorderline';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_purchaseorderline'
      AND schemaname = 'public'
      AND tablename = 'PurchaseOrderLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_purchaseorderline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_purchaseorderline"
      ON public."PurchaseOrderLine"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_purchaseorderline';
  END IF;
END $$;


-- ============================================================================
-- QUOTE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_quote'
      AND schemaname = 'public'
      AND tablename = 'Quote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_quote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_quote"
      ON public."Quote"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_quote';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_quote'
      AND schemaname = 'public'
      AND tablename = 'Quote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_quote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_quote"
      ON public."Quote"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_quote';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_quote'
      AND schemaname = 'public'
      AND tablename = 'Quote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_quote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_quote"
      ON public."Quote"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_quote';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_quote'
      AND schemaname = 'public'
      AND tablename = 'Quote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_quote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_quote"
      ON public."Quote"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_quote';
  END IF;
END $$;


-- ============================================================================
-- QUOTELINEITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_quotelineitem'
      AND schemaname = 'public'
      AND tablename = 'QuoteLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_quotelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_quotelineitem"
      ON public."QuoteLineItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_quotelineitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_quotelineitem'
      AND schemaname = 'public'
      AND tablename = 'QuoteLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_quotelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_quotelineitem"
      ON public."QuoteLineItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_quotelineitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_quotelineitem'
      AND schemaname = 'public'
      AND tablename = 'QuoteLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_quotelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_quotelineitem"
      ON public."QuoteLineItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_quotelineitem';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_quotelineitem'
      AND schemaname = 'public'
      AND tablename = 'QuoteLineItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_quotelineitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_quotelineitem"
      ON public."QuoteLineItem"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_quotelineitem';
  END IF;
END $$;


-- ============================================================================
-- RFI POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_rfi'
      AND schemaname = 'public'
      AND tablename = 'RFI'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_rfi';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_rfi"
      ON public."RFI"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_rfi';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_rfi'
      AND schemaname = 'public'
      AND tablename = 'RFI'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_rfi';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_rfi"
      ON public."RFI"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_rfi';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_rfi'
      AND schemaname = 'public'
      AND tablename = 'RFI'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_rfi';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_rfi"
      ON public."RFI"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_rfi';
  END IF;
END $$;


-- ============================================================================
-- RFIREPLY POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_rfireply'
      AND schemaname = 'public'
      AND tablename = 'RFIReply'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_rfireply';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_rfireply"
      ON public."RFIReply"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_rfireply';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_rfireply'
      AND schemaname = 'public'
      AND tablename = 'RFIReply'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_rfireply';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_rfireply"
      ON public."RFIReply"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_rfireply';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_rfireply'
      AND schemaname = 'public'
      AND tablename = 'RFIReply'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_rfireply';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_rfireply"
      ON public."RFIReply"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_rfireply';
  END IF;
END $$;


-- ============================================================================
-- RFQLINE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_rfqline'
      AND schemaname = 'public'
      AND tablename = 'RFQLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_rfqline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_rfqline"
      ON public."RFQLine"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_rfqline';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_rfqline'
      AND schemaname = 'public'
      AND tablename = 'RFQLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_rfqline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_rfqline"
      ON public."RFQLine"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_rfqline';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_rfqline'
      AND schemaname = 'public'
      AND tablename = 'RFQLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_rfqline';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_rfqline"
      ON public."RFQLine"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_rfqline';
  END IF;
END $$;


-- ============================================================================
-- REPORTDEFINITION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_reportdefinition'
      AND schemaname = 'public'
      AND tablename = 'ReportDefinition'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_reportdefinition';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_reportdefinition"
      ON public."ReportDefinition"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_reportdefinition';
  END IF;
END $$;


-- ============================================================================
-- REQUESTFORQUOTE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_requestforquote'
      AND schemaname = 'public'
      AND tablename = 'RequestForQuote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_requestforquote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_requestforquote"
      ON public."RequestForQuote"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_requestforquote';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_requestforquote'
      AND schemaname = 'public'
      AND tablename = 'RequestForQuote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_requestforquote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_requestforquote"
      ON public."RequestForQuote"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_requestforquote';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_requestforquote'
      AND schemaname = 'public'
      AND tablename = 'RequestForQuote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_requestforquote';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_requestforquote"
      ON public."RequestForQuote"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_requestforquote';
  END IF;
END $$;


-- ============================================================================
-- ROLE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_role'
      AND schemaname = 'public'
      AND tablename = 'Role'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_role';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_role"
      ON public."Role"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_role';
  END IF;
END $$;


-- ============================================================================
-- ROLEPERMISSION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_rolepermission'
      AND schemaname = 'public'
      AND tablename = 'RolePermission'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_rolepermission';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_rolepermission"
      ON public."RolePermission"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_rolepermission';
  END IF;
END $$;


-- ============================================================================
-- SCHEDULE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_schedule'
      AND schemaname = 'public'
      AND tablename = 'Schedule'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_schedule';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_schedule"
      ON public."Schedule"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_schedule';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_schedule'
      AND schemaname = 'public'
      AND tablename = 'Schedule'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_schedule';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_schedule"
      ON public."Schedule"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_schedule';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_schedule'
      AND schemaname = 'public'
      AND tablename = 'Schedule'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_schedule';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_schedule"
      ON public."Schedule"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_schedule';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_schedule'
      AND schemaname = 'public'
      AND tablename = 'Schedule'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_schedule';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_schedule"
      ON public."Schedule"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_schedule';
  END IF;
END $$;


-- ============================================================================
-- SCHEDULEEXCEPTION POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_scheduleexception'
      AND schemaname = 'public'
      AND tablename = 'ScheduleException'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_scheduleexception';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_scheduleexception"
      ON public."ScheduleException"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_scheduleexception';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_scheduleexception'
      AND schemaname = 'public'
      AND tablename = 'ScheduleException'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_scheduleexception';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_scheduleexception"
      ON public."ScheduleException"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_scheduleexception';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_scheduleexception'
      AND schemaname = 'public'
      AND tablename = 'ScheduleException'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_scheduleexception';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_scheduleexception"
      ON public."ScheduleException"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_scheduleexception';
  END IF;
END $$;


-- ============================================================================
-- SUBMITTAL POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_submittal'
      AND schemaname = 'public'
      AND tablename = 'Submittal'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_submittal';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_submittal"
      ON public."Submittal"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_submittal';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_submittal'
      AND schemaname = 'public'
      AND tablename = 'Submittal'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_submittal';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_submittal"
      ON public."Submittal"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_submittal';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_submittal'
      AND schemaname = 'public'
      AND tablename = 'Submittal'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_submittal';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_submittal"
      ON public."Submittal"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_submittal';
  END IF;
END $$;


-- ============================================================================
-- SUBMITTALAPPROVAL POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_submittalapproval'
      AND schemaname = 'public'
      AND tablename = 'SubmittalApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_submittalapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_submittalapproval"
      ON public."SubmittalApproval"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_submittalapproval';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_submittalapproval'
      AND schemaname = 'public'
      AND tablename = 'SubmittalApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_submittalapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_submittalapproval"
      ON public."SubmittalApproval"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_submittalapproval';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_submittalapproval'
      AND schemaname = 'public'
      AND tablename = 'SubmittalApproval'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_submittalapproval';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_submittalapproval"
      ON public."SubmittalApproval"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_submittalapproval';
  END IF;
END $$;


-- ============================================================================
-- SUBMITTALITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_submittalitem'
      AND schemaname = 'public'
      AND tablename = 'SubmittalItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_submittalitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_submittalitem"
      ON public."SubmittalItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_submittalitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_submittalitem'
      AND schemaname = 'public'
      AND tablename = 'SubmittalItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_submittalitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_submittalitem"
      ON public."SubmittalItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_submittalitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_submittalitem'
      AND schemaname = 'public'
      AND tablename = 'SubmittalItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_submittalitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_submittalitem"
      ON public."SubmittalItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_submittalitem';
  END IF;
END $$;


-- ============================================================================
-- TASK POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_task'
      AND schemaname = 'public'
      AND tablename = 'Task'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_task';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_task"
      ON public."Task"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_task';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_task'
      AND schemaname = 'public'
      AND tablename = 'Task'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_task';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_task"
      ON public."Task"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_task';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_task'
      AND schemaname = 'public'
      AND tablename = 'Task'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_task';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_task"
      ON public."Task"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_task';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_task'
      AND schemaname = 'public'
      AND tablename = 'Task'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_task';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_task"
      ON public."Task"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_task';
  END IF;
END $$;


-- ============================================================================
-- TASKASSIGNMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_taskassignment'
      AND schemaname = 'public'
      AND tablename = 'TaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_taskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_taskassignment"
      ON public."TaskAssignment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_taskassignment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_taskassignment'
      AND schemaname = 'public'
      AND tablename = 'TaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_taskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_taskassignment"
      ON public."TaskAssignment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_taskassignment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_taskassignment'
      AND schemaname = 'public'
      AND tablename = 'TaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_taskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_taskassignment"
      ON public."TaskAssignment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_taskassignment';
  END IF;
END $$;


-- ============================================================================
-- TASKATTACHMENT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_taskattachment'
      AND schemaname = 'public'
      AND tablename = 'TaskAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_taskattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_taskattachment"
      ON public."TaskAttachment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_taskattachment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_taskattachment'
      AND schemaname = 'public'
      AND tablename = 'TaskAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_taskattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_taskattachment"
      ON public."TaskAttachment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_taskattachment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_taskattachment'
      AND schemaname = 'public'
      AND tablename = 'TaskAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_taskattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_taskattachment"
      ON public."TaskAttachment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_taskattachment';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_taskattachment'
      AND schemaname = 'public'
      AND tablename = 'TaskAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_taskattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_taskattachment"
      ON public."TaskAttachment"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_taskattachment';
  END IF;
END $$;


-- ============================================================================
-- TASKCHECKLISTITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_taskchecklistitem'
      AND schemaname = 'public'
      AND tablename = 'TaskChecklistItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_taskchecklistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_taskchecklistitem"
      ON public."TaskChecklistItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_taskchecklistitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_taskchecklistitem'
      AND schemaname = 'public'
      AND tablename = 'TaskChecklistItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_taskchecklistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_taskchecklistitem"
      ON public."TaskChecklistItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_taskchecklistitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_taskchecklistitem'
      AND schemaname = 'public'
      AND tablename = 'TaskChecklistItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_taskchecklistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_taskchecklistitem"
      ON public."TaskChecklistItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_taskchecklistitem';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_taskchecklistitem'
      AND schemaname = 'public'
      AND tablename = 'TaskChecklistItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_taskchecklistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_taskchecklistitem"
      ON public."TaskChecklistItem"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_taskchecklistitem';
  END IF;
END $$;


-- ============================================================================
-- TASKDEPENDENCY POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_taskdependency'
      AND schemaname = 'public'
      AND tablename = 'TaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_taskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_taskdependency"
      ON public."TaskDependency"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_taskdependency';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_taskdependency'
      AND schemaname = 'public'
      AND tablename = 'TaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_taskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_taskdependency"
      ON public."TaskDependency"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_taskdependency';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_taskdependency'
      AND schemaname = 'public'
      AND tablename = 'TaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_taskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_taskdependency"
      ON public."TaskDependency"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_taskdependency';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_taskdependency'
      AND schemaname = 'public'
      AND tablename = 'TaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_taskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_taskdependency"
      ON public."TaskDependency"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_taskdependency';
  END IF;
END $$;


-- ============================================================================
-- TENANTAUDITLOG POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_tenantauditlog'
      AND schemaname = 'public'
      AND tablename = 'TenantAuditLog'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_tenantauditlog';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_tenantauditlog"
      ON public."TenantAuditLog"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_tenantauditlog';
  END IF;
END $$;


-- ============================================================================
-- TENANTFEATUREFLAG POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_tenantfeatureflag'
      AND schemaname = 'public'
      AND tablename = 'TenantFeatureFlag'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_tenantfeatureflag';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_tenantfeatureflag"
      ON public."TenantFeatureFlag"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_tenantfeatureflag';
  END IF;
END $$;


-- ============================================================================
-- TENANTMETRICS POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_tenantmetrics'
      AND schemaname = 'public'
      AND tablename = 'TenantMetrics'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_tenantmetrics';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_tenantmetrics"
      ON public."TenantMetrics"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_tenantmetrics';
  END IF;
END $$;


-- ============================================================================
-- TENANTSETTINGS POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_tenantsettings'
      AND schemaname = 'public'
      AND tablename = 'TenantSettings'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_tenantsettings';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_tenantsettings"
      ON public."TenantSettings"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_tenantsettings';
  END IF;
END $$;


-- ============================================================================
-- TENANTUSAGERECORD POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_tenantusagerecord'
      AND schemaname = 'public'
      AND tablename = 'TenantUsageRecord'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_tenantusagerecord';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_tenantusagerecord"
      ON public."TenantUsageRecord"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_tenantusagerecord';
  END IF;
END $$;


-- ============================================================================
-- TERMSTEMPLATE POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_termstemplate'
      AND schemaname = 'public'
      AND tablename = 'TermsTemplate'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_termstemplate';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_termstemplate"
      ON public."TermsTemplate"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_termstemplate';
  END IF;
END $$;


-- ============================================================================
-- TIMESHEET POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_timesheet'
      AND schemaname = 'public'
      AND tablename = 'Timesheet'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_timesheet';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_timesheet"
      ON public."Timesheet"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_timesheet';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_timesheet'
      AND schemaname = 'public'
      AND tablename = 'Timesheet'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_timesheet';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_timesheet"
      ON public."Timesheet"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_timesheet';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_timesheet'
      AND schemaname = 'public'
      AND tablename = 'Timesheet'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_timesheet';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_timesheet"
      ON public."Timesheet"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_timesheet';
  END IF;
END $$;


-- ============================================================================
-- TIMESHEETENTRY POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_timesheetentry'
      AND schemaname = 'public'
      AND tablename = 'TimesheetEntry'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_timesheetentry';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_timesheetentry"
      ON public."TimesheetEntry"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_timesheetentry';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_timesheetentry'
      AND schemaname = 'public'
      AND tablename = 'TimesheetEntry'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_timesheetentry';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_timesheetentry"
      ON public."TimesheetEntry"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_timesheetentry';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_timesheetentry'
      AND schemaname = 'public'
      AND tablename = 'TimesheetEntry'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_timesheetentry';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_timesheetentry"
      ON public."TimesheetEntry"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_timesheetentry';
  END IF;
END $$;


-- ============================================================================
-- VENDOR POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_vendor'
      AND schemaname = 'public'
      AND tablename = 'Vendor'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_vendor';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_vendor"
      ON public."Vendor"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_vendor';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_vendor'
      AND schemaname = 'public'
      AND tablename = 'Vendor'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_vendor';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_vendor"
      ON public."Vendor"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_vendor';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_vendor'
      AND schemaname = 'public'
      AND tablename = 'Vendor'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_vendor';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_vendor"
      ON public."Vendor"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_vendor';
  END IF;
END $$;


-- ============================================================================
-- VENDORCONTACT POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_vendorcontact'
      AND schemaname = 'public'
      AND tablename = 'VendorContact'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_vendorcontact';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_vendorcontact"
      ON public."VendorContact"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_vendorcontact';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_vendorcontact'
      AND schemaname = 'public'
      AND tablename = 'VendorContact'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_vendorcontact';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_vendorcontact"
      ON public."VendorContact"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_vendorcontact';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_vendorcontact'
      AND schemaname = 'public'
      AND tablename = 'VendorContact'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_vendorcontact';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_vendorcontact"
      ON public."VendorContact"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_vendorcontact';
  END IF;
END $$;


-- ============================================================================
-- WBSITEM POLICIES (PROJECT_MANAGER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_select_wbsitem'
      AND schemaname = 'public'
      AND tablename = 'WBSItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_select_wbsitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_select_wbsitem"
      ON public."WBSItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_select_wbsitem';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_insert_wbsitem'
      AND schemaname = 'public'
      AND tablename = 'WBSItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_insert_wbsitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_insert_wbsitem"
      ON public."WBSItem"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_insert_wbsitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_update_wbsitem'
      AND schemaname = 'public'
      AND tablename = 'WBSItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_update_wbsitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_update_wbsitem"
      ON public."WBSItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_update_wbsitem';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_project_manager_delete_wbsitem'
      AND schemaname = 'public'
      AND tablename = 'WBSItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_project_manager_delete_wbsitem';
    EXECUTE $policy$
      CREATE POLICY "rls_project_manager_delete_wbsitem"
      ON public."WBSItem"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_project_manager()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_project_manager_delete_wbsitem';
  END IF;
END $$;


-- ============================================================================
-- CONDITIONAL PERMISSIONS NOTES (PROJECT_MANAGER)
-- ============================================================================
--
-- The following permissions are conditional based on TenantSettings:
--
-- 1. allowPmSoftDelete:
--    - Project.soft_delete, Project.restore
--    - ProjectTask.soft_delete
--
-- 2. allowPmTimeApproval:
--    - Leave.approve, Leave.reject
--    - Timesheet.approve, Timesheet.reject
--    - LeaveOfAbsence.approve, LeaveOfAbsence.reject
--
-- 3. allowPmEstimateApproval:
--    - Estimate.approve, Estimate.reject
--
-- 4. allowPmChangeOrderApproval:
--    - ChangeOrder.approve, ChangeOrder.reject
--
-- 5. allowPmScheduleSwapApproval:
--    - ScheduleException.approve, ScheduleException.reject
--
-- These conditions should be implemented in application logic
-- or as additional policy constraints.
--
-- ============================================================================


-- ============================================================================ 
-- ✅ END OF PROJECT_MANAGER POLICY CREATION 
-- ============================================================================

COMMIT;

-- ============================================================================
-- ✅ TRANSACTION COMPLETED SUCCESSFULLY
-- If you see this message, all policies were applied or skipped correctly
-- ============================================================================
