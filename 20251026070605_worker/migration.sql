-- ============================================================================
-- BEGIN TRANSACTION WRAPPER
-- Ensures atomic creation of all RLS policies for WORKER
-- If any policy creation fails, the entire batch will rollback
-- ============================================================================

BEGIN;

-- ============================================================================ 
-- 🚀 START OF WORKER POLICY CREATION 
-- ============================================================================

-- ============================================================================
-- WORKER RLS POLICIES - Multi-Tenant Security Implementation
-- Auto-generated from RBAC.schema.v7.yml WORKER permissions
-- Pattern: IDEMPOTENT PL/pgSQL - Safe for production deployment
-- Date: 2025-10-05
-- ============================================================================
--
-- ✨ IDEMPOTENT PATTERN: Uses pg_policies system table to check existence
-- 🚀 PRODUCTION-READY: Safe for Neon, Supabase, and repeated deployments
-- 🔒 SECURITY: app.is_worker() + tenant isolation + soft delete awareness
-- 📋 CONDITIONAL: TenantSettings toggles documented at bottom
-- 🌍 GLOBAL TABLES EXCLUDED: 34 tables without tenantId automatically skipped
--
-- WORKER Role Check Function:
-- Uses app.is_worker() helper from 004_helpers.sql
--
-- ============================================================================

-- ============================================================================
-- ASSET POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_asset'
      AND schemaname = 'public'
      AND tablename = 'Asset'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_asset';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_asset"
      ON public."Asset"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_asset';
  END IF;
END $$;


-- ============================================================================
-- ASSETASSIGNMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_assetassignment'
      AND schemaname = 'public'
      AND tablename = 'AssetAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_assetassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_assetassignment"
      ON public."AssetAssignment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_assetassignment';
  END IF;
END $$;


-- ============================================================================
-- ATTACHMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_attachment'
      AND schemaname = 'public'
      AND tablename = 'Attachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_attachment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_attachment"
      ON public."Attachment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_attachment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_attachment'
      AND schemaname = 'public'
      AND tablename = 'Attachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_attachment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_attachment"
      ON public."Attachment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_attachment';
  END IF;
END $$;


-- ============================================================================
-- CHANNEL POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_channel'
      AND schemaname = 'public'
      AND tablename = 'Channel'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_channel';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_channel"
      ON public."Channel"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_channel';
  END IF;
END $$;


-- ============================================================================
-- CHANNELMEMBER POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_channelmember'
      AND schemaname = 'public'
      AND tablename = 'ChannelMember'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_channelmember';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_channelmember"
      ON public."ChannelMember"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_channelmember';
  END IF;
END $$;


-- ============================================================================
-- CLOCKINCLOCKOUT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_clockinclockout'
      AND schemaname = 'public'
      AND tablename = 'ClockInClockOut'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_clockinclockout';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_clockinclockout"
      ON public."ClockInClockOut"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_clockinclockout';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_clockinclockout'
      AND schemaname = 'public'
      AND tablename = 'ClockInClockOut'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_clockinclockout';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_clockinclockout"
      ON public."ClockInClockOut"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_clockinclockout';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_clockinclockout'
      AND schemaname = 'public'
      AND tablename = 'ClockInClockOut'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_clockinclockout';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_clockinclockout"
      ON public."ClockInClockOut"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_clockinclockout';
  END IF;
END $$;


-- ============================================================================
-- DAILYLOG POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_dailylog'
      AND schemaname = 'public'
      AND tablename = 'DailyLog'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_dailylog';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_dailylog"
      ON public."DailyLog"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_dailylog';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_dailylog'
      AND schemaname = 'public'
      AND tablename = 'DailyLog'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_dailylog';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_dailylog"
      ON public."DailyLog"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_dailylog';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_dailylog'
      AND schemaname = 'public'
      AND tablename = 'DailyLog'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_dailylog';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_dailylog"
      ON public."DailyLog"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_dailylog';
  END IF;
END $$;


-- ============================================================================
-- DIRECTCHAT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_directchat'
      AND schemaname = 'public'
      AND tablename = 'DirectChat'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_directchat';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_directchat"
      ON public."DirectChat"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_directchat';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_directchat'
      AND schemaname = 'public'
      AND tablename = 'DirectChat'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_directchat';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_directchat"
      ON public."DirectChat"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_directchat';
  END IF;
END $$;


-- ============================================================================
-- DIRECTMESSAGE POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_directmessage';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_directmessage';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_directmessage';
  END IF;
END $$;

-- DELETE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_delete_directmessage'
      AND schemaname = 'public'
      AND tablename = 'DirectMessage'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_delete_directmessage';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_delete_directmessage"
      ON public."DirectMessage"
      AS RESTRICTIVE
      FOR DELETE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_delete_directmessage';
  END IF;
END $$;


-- ============================================================================
-- EXPENSE POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_expense'
      AND schemaname = 'public'
      AND tablename = 'Expense'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_expense';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_expense"
      ON public."Expense"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_expense';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_expense'
      AND schemaname = 'public'
      AND tablename = 'Expense'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_expense';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_expense"
      ON public."Expense"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_expense';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_expense'
      AND schemaname = 'public'
      AND tablename = 'Expense'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_expense';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_expense"
      ON public."Expense"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_expense';
  END IF;
END $$;


-- ============================================================================
-- EXPENSELINE POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_expenseline'
      AND schemaname = 'public'
      AND tablename = 'ExpenseLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_expenseline';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_expenseline"
      ON public."ExpenseLine"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_expenseline';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_expenseline'
      AND schemaname = 'public'
      AND tablename = 'ExpenseLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_expenseline';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_expenseline"
      ON public."ExpenseLine"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_expenseline';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_expenseline'
      AND schemaname = 'public'
      AND tablename = 'ExpenseLine'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_expenseline';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_expenseline"
      ON public."ExpenseLine"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_expenseline';
  END IF;
END $$;


-- ============================================================================
-- EXPENSERECEIPT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_expensereceipt'
      AND schemaname = 'public'
      AND tablename = 'ExpenseReceipt'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_expensereceipt';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_expensereceipt"
      ON public."ExpenseReceipt"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_expensereceipt';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_expensereceipt'
      AND schemaname = 'public'
      AND tablename = 'ExpenseReceipt'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_expensereceipt';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_expensereceipt"
      ON public."ExpenseReceipt"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_expensereceipt';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_expensereceipt'
      AND schemaname = 'public'
      AND tablename = 'ExpenseReceipt'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_expensereceipt';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_expensereceipt"
      ON public."ExpenseReceipt"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_expensereceipt';
  END IF;
END $$;


-- ============================================================================
-- FILEOBJECT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_fileobject'
      AND schemaname = 'public'
      AND tablename = 'FileObject'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_fileobject';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_fileobject"
      ON public."FileObject"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_fileobject';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_fileobject'
      AND schemaname = 'public'
      AND tablename = 'FileObject'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_fileobject';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_fileobject"
      ON public."FileObject"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_fileobject';
  END IF;
END $$;


-- ============================================================================
-- INVENTORYITEM POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_inventoryitem'
      AND schemaname = 'public'
      AND tablename = 'InventoryItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_inventoryitem';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_inventoryitem"
      ON public."InventoryItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_inventoryitem';
  END IF;
END $$;


-- ============================================================================
-- INVENTORYTRANSACTION POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_inventorytransaction'
      AND schemaname = 'public'
      AND tablename = 'InventoryTransaction'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_inventorytransaction';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_inventorytransaction"
      ON public."InventoryTransaction"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_inventorytransaction';
  END IF;
END $$;


-- ============================================================================
-- LEAVE POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_leave'
      AND schemaname = 'public'
      AND tablename = 'Leave'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_leave';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_leave"
      ON public."Leave"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_leave';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_leave'
      AND schemaname = 'public'
      AND tablename = 'Leave'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_leave';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_leave"
      ON public."Leave"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_leave';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_leave'
      AND schemaname = 'public'
      AND tablename = 'Leave'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_leave';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_leave"
      ON public."Leave"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_leave';
  END IF;
END $$;


-- ============================================================================
-- MEMBER POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_member'
      AND schemaname = 'public'
      AND tablename = 'Member'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_member';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_member"
      ON public."Member"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_member';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_member'
      AND schemaname = 'public'
      AND tablename = 'Member'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_member';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_member"
      ON public."Member"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_member';
  END IF;
END $$;


-- ============================================================================
-- MEMBERDOCUMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_memberdocument'
      AND schemaname = 'public'
      AND tablename = 'MemberDocument'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_memberdocument';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_memberdocument"
      ON public."MemberDocument"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_memberdocument';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_memberdocument'
      AND schemaname = 'public'
      AND tablename = 'MemberDocument'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_memberdocument';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_memberdocument"
      ON public."MemberDocument"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_memberdocument';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_memberdocument'
      AND schemaname = 'public'
      AND tablename = 'MemberDocument'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_memberdocument';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_memberdocument"
      ON public."MemberDocument"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_memberdocument';
  END IF;
END $$;


-- ============================================================================
-- MEMBERSETTINGS POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_membersettings'
      AND schemaname = 'public'
      AND tablename = 'MemberSettings'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_membersettings';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_membersettings"
      ON public."MemberSettings"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_membersettings';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_membersettings'
      AND schemaname = 'public'
      AND tablename = 'MemberSettings'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_membersettings';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_membersettings"
      ON public."MemberSettings"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_membersettings';
  END IF;
END $$;


-- ============================================================================
-- NOTIFICATION POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_notification'
      AND schemaname = 'public'
      AND tablename = 'Notification'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_notification';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_notification"
      ON public."Notification"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_notification';
  END IF;
END $$;


-- ============================================================================
-- NOTIFICATIONPREFERENCE POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_notificationpreference'
      AND schemaname = 'public'
      AND tablename = 'NotificationPreference'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_notificationpreference';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_notificationpreference"
      ON public."NotificationPreference"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_notificationpreference';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_notificationpreference'
      AND schemaname = 'public'
      AND tablename = 'NotificationPreference'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_notificationpreference';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_notificationpreference"
      ON public."NotificationPreference"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_notificationpreference';
  END IF;
END $$;


-- ============================================================================
-- PAYSTATEMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_paystatement'
      AND schemaname = 'public'
      AND tablename = 'PayStatement'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_paystatement';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_paystatement"
      ON public."PayStatement"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_paystatement';
  END IF;
END $$;


-- ============================================================================
-- PAYROLLITEM POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_payrollitem'
      AND schemaname = 'public'
      AND tablename = 'PayrollItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_payrollitem';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_payrollitem"
      ON public."PayrollItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_payrollitem';
  END IF;
END $$;


-- ============================================================================
-- PAYROLLRUN POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_payrollrun'
      AND schemaname = 'public'
      AND tablename = 'PayrollRun'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_payrollrun';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_payrollrun"
      ON public."PayrollRun"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_payrollrun';
  END IF;
END $$;


-- ============================================================================
-- PROJECT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_project'
      AND schemaname = 'public'
      AND tablename = 'Project'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_project';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_project"
      ON public."Project"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_project';
  END IF;
END $$;


-- ============================================================================
-- PROJECTLOCATION POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_projectlocation'
      AND schemaname = 'public'
      AND tablename = 'ProjectLocation'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_projectlocation';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_projectlocation"
      ON public."ProjectLocation"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_projectlocation';
  END IF;
END $$;


-- ============================================================================
-- PROJECTNOTE POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_projectnote'
      AND schemaname = 'public'
      AND tablename = 'ProjectNote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_projectnote';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_projectnote"
      ON public."ProjectNote"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_projectnote';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_projectnote'
      AND schemaname = 'public'
      AND tablename = 'ProjectNote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_projectnote';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_projectnote"
      ON public."ProjectNote"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_projectnote';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_projectnote'
      AND schemaname = 'public'
      AND tablename = 'ProjectNote'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_projectnote';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_projectnote"
      ON public."ProjectNote"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_projectnote';
  END IF;
END $$;


-- ============================================================================
-- PROJECTTASK POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_projecttask'
      AND schemaname = 'public'
      AND tablename = 'ProjectTask'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_projecttask';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_projecttask"
      ON public."ProjectTask"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_projecttask';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_projecttask'
      AND schemaname = 'public'
      AND tablename = 'ProjectTask'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_projecttask';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_projecttask"
      ON public."ProjectTask"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_projecttask';
  END IF;
END $$;


-- ============================================================================
-- PROJECTTASKASSIGNMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_projecttaskassignment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_projecttaskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_projecttaskassignment"
      ON public."ProjectTaskAssignment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_projecttaskassignment';
  END IF;
END $$;


-- ============================================================================
-- PROJECTTASKCOMMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_projecttaskcomment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskComment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_projecttaskcomment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_projecttaskcomment"
      ON public."ProjectTaskComment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_projecttaskcomment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_projecttaskcomment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskComment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_projecttaskcomment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_projecttaskcomment"
      ON public."ProjectTaskComment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_projecttaskcomment';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_projecttaskcomment'
      AND schemaname = 'public'
      AND tablename = 'ProjectTaskComment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_projecttaskcomment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_projecttaskcomment"
      ON public."ProjectTaskComment"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_projecttaskcomment';
  END IF;
END $$;


-- ============================================================================
-- SCHEDULE POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_schedule'
      AND schemaname = 'public'
      AND tablename = 'Schedule'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_schedule';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_schedule"
      ON public."Schedule"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_schedule';
  END IF;
END $$;


-- ============================================================================
-- SCHEDULEEXCEPTION POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_scheduleexception'
      AND schemaname = 'public'
      AND tablename = 'ScheduleException'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_scheduleexception';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_scheduleexception"
      ON public."ScheduleException"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_scheduleexception';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_scheduleexception'
      AND schemaname = 'public'
      AND tablename = 'ScheduleException'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_scheduleexception';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_scheduleexception"
      ON public."ScheduleException"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_scheduleexception';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_scheduleexception'
      AND schemaname = 'public'
      AND tablename = 'ScheduleException'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_scheduleexception';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_scheduleexception"
      ON public."ScheduleException"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_scheduleexception';
  END IF;
END $$;


-- ============================================================================
-- TASK POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_task'
      AND schemaname = 'public'
      AND tablename = 'Task'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_task';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_task"
      ON public."Task"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_task';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_task'
      AND schemaname = 'public'
      AND tablename = 'Task'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_task';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_task"
      ON public."Task"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_task';
  END IF;
END $$;


-- ============================================================================
-- TASKASSIGNMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_taskassignment'
      AND schemaname = 'public'
      AND tablename = 'TaskAssignment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_taskassignment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_taskassignment"
      ON public."TaskAssignment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_taskassignment';
  END IF;
END $$;


-- ============================================================================
-- TASKATTACHMENT POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_taskattachment'
      AND schemaname = 'public'
      AND tablename = 'TaskAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_taskattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_taskattachment"
      ON public."TaskAttachment"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_taskattachment';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_taskattachment'
      AND schemaname = 'public'
      AND tablename = 'TaskAttachment'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_taskattachment';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_taskattachment"
      ON public."TaskAttachment"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_taskattachment';
  END IF;
END $$;


-- ============================================================================
-- TASKCHECKLISTITEM POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_taskchecklistitem'
      AND schemaname = 'public'
      AND tablename = 'TaskChecklistItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_taskchecklistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_taskchecklistitem"
      ON public."TaskChecklistItem"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_taskchecklistitem';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_taskchecklistitem'
      AND schemaname = 'public'
      AND tablename = 'TaskChecklistItem'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_taskchecklistitem';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_taskchecklistitem"
      ON public."TaskChecklistItem"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_taskchecklistitem';
  END IF;
END $$;


-- ============================================================================
-- TASKDEPENDENCY POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_taskdependency'
      AND schemaname = 'public'
      AND tablename = 'TaskDependency'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_taskdependency';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_taskdependency"
      ON public."TaskDependency"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_taskdependency';
  END IF;
END $$;


-- ============================================================================
-- TIMESHEET POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_timesheet'
      AND schemaname = 'public'
      AND tablename = 'Timesheet'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_timesheet';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_timesheet"
      ON public."Timesheet"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_timesheet';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_timesheet'
      AND schemaname = 'public'
      AND tablename = 'Timesheet'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_timesheet';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_timesheet"
      ON public."Timesheet"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_timesheet';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_timesheet'
      AND schemaname = 'public'
      AND tablename = 'Timesheet'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_timesheet';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_timesheet"
      ON public."Timesheet"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_timesheet';
  END IF;
END $$;


-- ============================================================================
-- TIMESHEETENTRY POLICIES (WORKER)
-- ============================================================================

-- SELECT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_select_timesheetentry'
      AND schemaname = 'public'
      AND tablename = 'TimesheetEntry'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_select_timesheetentry';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_select_timesheetentry"
      ON public."TimesheetEntry"
      AS RESTRICTIVE
      FOR SELECT
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_select_timesheetentry';
  END IF;
END $$;

-- INSERT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_insert_timesheetentry'
      AND schemaname = 'public'
      AND tablename = 'TimesheetEntry'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_insert_timesheetentry';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_insert_timesheetentry"
      ON public."TimesheetEntry"
      AS RESTRICTIVE
      FOR INSERT
      TO authenticated
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_insert_timesheetentry';
  END IF;
END $$;

-- UPDATE
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'rls_worker_update_timesheetentry'
      AND schemaname = 'public'
      AND tablename = 'TimesheetEntry'
  ) THEN
    RAISE NOTICE '🆕 Creating policy: rls_worker_update_timesheetentry';
    EXECUTE $policy$
      CREATE POLICY "rls_worker_update_timesheetentry"
      ON public."TimesheetEntry"
      AS RESTRICTIVE
      FOR UPDATE
      TO authenticated
      USING (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      )
      WITH CHECK (
        app.is_worker()
        AND "tenantId" = app.current_tenant_id()
        AND "deletedAt" IS NULL
      );
    $policy$;
  ELSE
    RAISE NOTICE '✅ Policy already exists: rls_worker_update_timesheetentry';
  END IF;
END $$;


-- ============================================================================
-- CONDITIONAL PERMISSIONS NOTES (WORKER)
-- ============================================================================
--
-- The following permissions are conditional based on TenantSettings:
--
-- 1. allowWorkerTimeEntry:
--    - Timesheet.create, Timesheet.update
--    - TimesheetEntry.create, TimesheetEntry.update
--
-- 2. allowWorkerTaskAssignment:
--    - Task.assign, Task.unassign
--    - ProjectTask.assign, ProjectTask.unassign
--
-- 3. allowWorkerExpenseSubmission:
--    - Expense.create, Expense.update, Expense.submit
--    - ExpenseReceipt.create, ExpenseReceipt.update
--
-- These conditions should be implemented in application logic
-- or as additional policy constraints.
--
-- ============================================================================


-- ============================================================================ 
-- ✅ END OF WORKER POLICY CREATION 
-- ============================================================================

COMMIT;

-- ============================================================================
-- ✅ TRANSACTION COMPLETED SUCCESSFULLY
-- If you see this message, all policies were applied or skipped correctly
-- ============================================================================
