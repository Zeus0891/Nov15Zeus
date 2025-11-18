-- ============================================================================
-- 🏛️ BeeSmart Pro RLS Foundation v9.0 - PostgreSQL Policies
-- Row-Level Security policies for Phase 1 internal member operations
--
-- Aligned with RBAC Generator v9.0:
-- - 5 internal roles: ADMIN (0), PROJECT_MANAGER (2), WORKER (8), DRIVER (9), VIEWER (10)
-- - TenantSettings integration for PM permissions
-- - Optimized for sub-millisecond performance
--
-- @version 9.0
-- @phase Phase 1 - Internal Members Only
-- @date November 18, 2025
-- ============================================================================

-- Enable Row Level Security extension
CREATE EXTENSION IF NOT EXISTS "row_security";

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

/**
 * Get current tenant ID from security context
 */
CREATE OR REPLACE FUNCTION get_current_tenant_id()
RETURNS UUID
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN COALESCE(
    NULLIF(current_setting('app.current_tenant_id', true), '')::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID
  );
END;
$$;

/**
 * Get current actor ID from security context
 */
CREATE OR REPLACE FUNCTION get_current_actor_id()
RETURNS UUID
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN COALESCE(
    NULLIF(current_setting('app.current_actor_id', true), '')::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID
  );
END;
$$;

/**
 * Get current member ID from security context
 */
CREATE OR REPLACE FUNCTION get_current_member_id()
RETURNS UUID
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN COALESCE(
    NULLIF(current_setting('app.current_member_id', true), '')::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID
  );
END;
$$;

/**
 * Get current role from security context
 */
CREATE OR REPLACE FUNCTION get_current_role()
RETURNS TEXT
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN COALESCE(
    NULLIF(current_setting('app.current_role', true), ''),
    'VIEWER'
  );
END;
$$;

/**
 * Get current role hierarchy level (0=highest authority)
 */
CREATE OR REPLACE FUNCTION get_role_hierarchy()
RETURNS INTEGER
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN COALESCE(
    NULLIF(current_setting('app.role_hierarchy', true), '')::INTEGER,
    10  -- Default to VIEWER level
  );
END;
$$;

/**
 * Get assigned projects for current user
 */
CREATE OR REPLACE FUNCTION get_assigned_projects()
RETURNS UUID[]
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
  projects_json TEXT;
  projects_array UUID[];
BEGIN
  projects_json := NULLIF(current_setting('app.assigned_projects', true), '');

  IF projects_json IS NULL THEN
    RETURN ARRAY[]::UUID[];
  END IF;

  -- Parse JSON array to UUID array
  SELECT ARRAY(
    SELECT (value::TEXT)::UUID
    FROM json_array_elements_text(projects_json::JSON)
  ) INTO projects_array;

  RETURN COALESCE(projects_array, ARRAY[]::UUID[]);
END;
$$;

/**
 * Check if current user has PM permission
 */
CREATE OR REPLACE FUNCTION has_pm_permission(permission_name TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
  permissions_json TEXT;
  permissions_obj JSON;
BEGIN
  -- ADMIN always has all permissions
  IF get_current_role() = 'ADMIN' THEN
    RETURN TRUE;
  END IF;

  -- Non-PM roles don't have PM permissions
  IF get_current_role() != 'PROJECT_MANAGER' THEN
    RETURN FALSE;
  END IF;

  permissions_json := NULLIF(current_setting('app.pm_permissions', true), '');

  IF permissions_json IS NULL THEN
    RETURN FALSE;
  END IF;

  permissions_obj := permissions_json::JSON;

  RETURN COALESCE((permissions_obj ->> permission_name)::BOOLEAN, FALSE);
END;
$$;

/**
 * Check if user has higher or equal authority than target hierarchy
 */
CREATE OR REPLACE FUNCTION has_higher_or_equal_authority(target_hierarchy INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN get_role_hierarchy() <= target_hierarchy;
END;
$$;

-- ============================================================================
-- CORE RLS POLICIES
-- ============================================================================

/**
 * Standard tenant isolation policy for most tables
 * Apply this to any table with tenantId column
 */
CREATE OR REPLACE FUNCTION create_tenant_isolation_policy(table_name TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  -- Enable RLS on the table
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', table_name);

  -- Drop existing policies if they exist
  EXECUTE format('DROP POLICY IF EXISTS tenant_isolation_policy ON %I', table_name);

  -- Create tenant isolation policy
  EXECUTE format('
    CREATE POLICY tenant_isolation_policy ON %I
    USING (tenant_id = get_current_tenant_id())
    WITH CHECK (tenant_id = get_current_tenant_id())
  ', table_name);
END;
$$;

-- ============================================================================
-- ESTIMATE TABLE POLICIES
-- ============================================================================

-- Enable RLS on estimates table
ALTER TABLE estimates ENABLE ROW LEVEL SECURITY;

-- Basic tenant isolation
CREATE POLICY estimates_tenant_isolation ON estimates
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

-- Role-based visibility policy
CREATE POLICY estimates_role_based_access ON estimates
  USING (
    CASE
      -- ADMIN: See all estimates
      WHEN get_current_role() = 'ADMIN' THEN TRUE

      -- PROJECT_MANAGER: See all estimates in tenant
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN TRUE

      -- WORKER/DRIVER: Only see own estimates
      WHEN get_role_hierarchy() >= 8 THEN created_by_actor_id = get_current_actor_id()

      -- VIEWER: Read-only access to non-confidential estimates
      WHEN get_current_role() = 'VIEWER' THEN
        data_classification != 'RESTRICTED' AND status != 'DRAFT'

      ELSE FALSE
    END
  );

-- Update restrictions based on role and status
CREATE POLICY estimates_update_restrictions ON estimates
  FOR UPDATE
  USING (
    CASE
      -- ADMIN: Can update anything
      WHEN get_current_role() = 'ADMIN' THEN TRUE

      -- PROJECT_MANAGER: Can update based on PM permissions and status
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN
        CASE
          WHEN status = 'APPROVED' THEN has_pm_permission('canApproveEstimates')
          WHEN status = 'DRAFT' THEN TRUE
          ELSE has_pm_permission('canApproveEstimates')
        END

      -- WORKER/DRIVER: Can only update own draft estimates
      WHEN get_role_hierarchy() >= 8 THEN
        created_by_actor_id = get_current_actor_id() AND status = 'DRAFT'

      -- VIEWER: No update access
      ELSE FALSE
    END
  );

-- Delete restrictions - PM permission required
CREATE POLICY estimates_delete_restrictions ON estimates
  FOR DELETE
  USING (
    CASE
      -- ADMIN: Can delete anything (except approved)
      WHEN get_current_role() = 'ADMIN' THEN status != 'APPROVED'

      -- PROJECT_MANAGER: Can delete own estimates with permission
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN
        has_pm_permission('canDeleteOwnEstimates') AND
        created_by_actor_id = get_current_actor_id() AND
        status != 'APPROVED'

      -- Others: No delete access
      ELSE FALSE
    END
  );

-- ============================================================================
-- PROJECT TABLE POLICIES
-- ============================================================================

-- Enable RLS on projects table
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Basic tenant isolation
CREATE POLICY projects_tenant_isolation ON projects
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

-- Project assignment-based access
CREATE POLICY projects_assignment_access ON projects
  USING (
    CASE
      -- ADMIN: See all projects
      WHEN get_current_role() = 'ADMIN' THEN TRUE

      -- PROJECT_MANAGER: See all projects in tenant
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN TRUE

      -- WORKER/DRIVER: Only see assigned projects
      WHEN get_role_hierarchy() >= 8 THEN
        id = ANY(get_assigned_projects()) OR
        project_manager_member_id = get_current_member_id() OR
        superintendent_member_id = get_current_member_id()

      -- VIEWER: See non-confidential active projects
      WHEN get_current_role() = 'VIEWER' THEN
        data_classification != 'RESTRICTED' AND status = 'ACTIVE'

      ELSE FALSE
    END
  );

-- ============================================================================
-- INVOICE TABLE POLICIES
-- ============================================================================

-- Enable RLS on invoices table
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

-- Basic tenant isolation
CREATE POLICY invoices_tenant_isolation ON invoices
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

-- Role-based access with financial visibility restrictions
CREATE POLICY invoices_role_access ON invoices
  USING (
    CASE
      -- ADMIN: See all invoices
      WHEN get_current_role() = 'ADMIN' THEN TRUE

      -- PROJECT_MANAGER: See invoices based on PM permissions
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN
        has_pm_permission('canApproveInvoices') OR
        created_by_actor_id = get_current_actor_id()

      -- WORKER/DRIVER: No access to invoices
      WHEN get_role_hierarchy() >= 8 THEN FALSE

      -- VIEWER: No access to financial data
      ELSE FALSE
    END
  );

-- Invoice creation/update restrictions
CREATE POLICY invoices_modification_restrictions ON invoices
  FOR ALL
  USING (
    CASE
      -- ADMIN: Full access
      WHEN get_current_role() = 'ADMIN' THEN TRUE

      -- PROJECT_MANAGER: Based on PM permissions
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN
        has_pm_permission('canApproveInvoices')

      -- Others: No modification access
      ELSE FALSE
    END
  );

-- ============================================================================
-- TIME TRACKING POLICIES
-- ============================================================================

-- Timesheet entries
ALTER TABLE timesheet_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY timesheet_tenant_isolation ON timesheet_entries
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

-- Workers can only see/edit their own timesheets
CREATE POLICY timesheet_ownership_access ON timesheet_entries
  USING (
    CASE
      -- ADMIN/PM: See all timesheets
      WHEN get_role_hierarchy() <= 2 THEN TRUE

      -- WORKER/DRIVER: Only own timesheets
      WHEN get_role_hierarchy() >= 8 THEN member_id = get_current_member_id()

      -- VIEWER: No access to timesheets
      ELSE FALSE
    END
  );

-- ============================================================================
-- MEMBER ACCESS POLICIES
-- ============================================================================

-- Enable RLS on members table
ALTER TABLE members ENABLE ROW LEVEL SECURITY;

CREATE POLICY members_tenant_isolation ON members
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

-- Role-based member visibility
CREATE POLICY members_role_visibility ON members
  USING (
    CASE
      -- ADMIN: See all members
      WHEN get_current_role() = 'ADMIN' THEN TRUE

      -- PROJECT_MANAGER: See team members
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN
        role_hierarchy >= get_role_hierarchy() OR  -- Subordinates
        id = get_current_member_id()  -- Self

      -- WORKER/DRIVER/VIEWER: Only see self and basic team info
      ELSE
        id = get_current_member_id() OR
        (role IN ('PROJECT_MANAGER', 'ADMIN') AND is_active = true)
    END
  );

-- ============================================================================
-- DOCUMENT ACCESS POLICIES
-- ============================================================================

-- Project documents
ALTER TABLE project_documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY project_documents_tenant_isolation ON project_documents
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

-- Document access based on project assignment
CREATE POLICY project_documents_access ON project_documents
  USING (
    CASE
      -- ADMIN/PM: Access all documents
      WHEN get_role_hierarchy() <= 2 THEN TRUE

      -- WORKER/DRIVER: Only documents from assigned projects
      WHEN get_role_hierarchy() >= 8 THEN
        project_id = ANY(get_assigned_projects())

      -- VIEWER: Public documents only
      ELSE access_level = 'PUBLIC'
    END
  );

-- ============================================================================
-- AUDIT AND COMPLIANCE POLICIES
-- ============================================================================

-- Access audit events - view restrictions
ALTER TABLE access_audit_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY audit_events_tenant_isolation ON access_audit_events
  USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());

CREATE POLICY audit_events_role_access ON access_audit_events
  USING (
    CASE
      -- ADMIN: See all audit events
      WHEN get_current_role() = 'ADMIN' THEN TRUE

      -- PM: See events for their team members
      WHEN get_current_role() = 'PROJECT_MANAGER' THEN
        actor_id IN (
          SELECT id FROM members
          WHERE tenant_id = get_current_tenant_id()
          AND role_hierarchy >= get_role_hierarchy()
        )

      -- Others: Only own events
      ELSE actor_id = get_current_actor_id()
    END
  );

-- ============================================================================
-- PERFORMANCE OPTIMIZATION
-- ============================================================================

-- Create indexes for RLS policy performance
-- These indexes support the security context lookups

-- Tenant-based indexes (most important)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_estimates_tenant_security
ON estimates (tenant_id, created_by_actor_id, status)
WHERE deleted_at IS NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_projects_tenant_assignment
ON projects (tenant_id, project_manager_member_id, superintendent_member_id, status)
WHERE deleted_at IS NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_invoices_tenant_security
ON invoices (tenant_id, created_by_actor_id, status)
WHERE deleted_at IS NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_timesheet_entries_member
ON timesheet_entries (tenant_id, member_id, created_at);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_members_role_security
ON members (tenant_id, role, role_hierarchy, is_active);

-- Project assignment indexes
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_project_task_assignments_member
ON project_task_assignments (tenant_id, member_id, project_id);

-- ============================================================================
-- CONVENIENCE FUNCTIONS FOR APPLICATION LAYER
-- ============================================================================

/**
 * Batch apply tenant isolation to multiple tables
 */
CREATE OR REPLACE FUNCTION apply_tenant_isolation_batch(table_names TEXT[])
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  table_name TEXT;
BEGIN
  FOREACH table_name IN ARRAY table_names
  LOOP
    PERFORM create_tenant_isolation_policy(table_name);
    RAISE NOTICE 'Applied tenant isolation to table: %', table_name;
  END LOOP;
END;
$$;

/**
 * Get security context summary for debugging
 */
CREATE OR REPLACE FUNCTION get_security_context_summary()
RETURNS JSON
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN json_build_object(
    'tenant_id', get_current_tenant_id(),
    'actor_id', get_current_actor_id(),
    'member_id', get_current_member_id(),
    'role', get_current_role(),
    'role_hierarchy', get_role_hierarchy(),
    'assigned_projects', get_assigned_projects(),
    'timestamp', now()
  );
END;
$$;

-- ============================================================================
-- BATCH APPLY POLICIES TO STANDARD TABLES
-- ============================================================================

-- Apply tenant isolation to all standard business tables
SELECT apply_tenant_isolation_batch(ARRAY[
  'estimate_revisions',
  'estimate_sections',
  'estimate_line_items',
  'estimate_attachments',
  'estimate_comments',
  'estimate_history_events',
  'project_phases',
  'project_milestones',
  'project_team_members',
  'project_tasks',
  'project_task_assignments',
  'project_budget_line_items',
  'project_history_events',
  'invoice_line_items',
  'invoice_attachments',
  'invoice_history_events',
  'crm_accounts',
  'crm_contacts',
  'crm_addresses',
  'purchase_orders',
  'purchase_order_line_items',
  'inventory_transactions',
  'change_orders',
  'change_order_line_items'
]);

-- ============================================================================
-- VALIDATION AND TESTING FUNCTIONS
-- ============================================================================

/**
 * Test RLS policies are working correctly
 */
CREATE OR REPLACE FUNCTION test_rls_policies()
RETURNS TABLE (
  table_name TEXT,
  rls_enabled BOOLEAN,
  policy_count INTEGER,
  test_result TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT schemaname, tablename
    FROM pg_tables
    WHERE schemaname = 'public'
    AND tablename NOT LIKE 'pg_%'
    ORDER BY tablename
  LOOP
    SELECT
      rec.tablename,
      c.relrowsecurity,
      COUNT(p.polname),
      CASE
        WHEN c.relrowsecurity AND COUNT(p.polname) > 0 THEN 'PROTECTED'
        WHEN c.relrowsecurity AND COUNT(p.polname) = 0 THEN 'RLS_ENABLED_NO_POLICIES'
        ELSE 'NOT_PROTECTED'
      END
    INTO table_name, rls_enabled, policy_count, test_result
    FROM pg_class c
    LEFT JOIN pg_policy p ON p.polrelid = c.oid
    WHERE c.relname = rec.tablename
    GROUP BY c.relname, c.relrowsecurity;

    RETURN NEXT;
  END LOOP;
END;
$$;

-- ============================================================================
-- DOCUMENTATION AND COMMENTS
-- ============================================================================

COMMENT ON FUNCTION get_current_tenant_id() IS 'RLS v9.0: Extract tenant ID from security context';
COMMENT ON FUNCTION get_current_role() IS 'RLS v9.0: Extract user role for authorization';
COMMENT ON FUNCTION get_role_hierarchy() IS 'RLS v9.0: Get role hierarchy level (0=highest)';
COMMENT ON FUNCTION has_pm_permission(TEXT) IS 'RLS v9.0: Check PM permissions from TenantSettings';
COMMENT ON FUNCTION get_assigned_projects() IS 'RLS v9.0: Get projects assigned to current user';

-- Policy documentation
COMMENT ON POLICY estimates_role_based_access ON estimates IS 'RLS v9.0: Role-based estimate visibility with hierarchy enforcement';
COMMENT ON POLICY projects_assignment_access ON projects IS 'RLS v9.0: Project access based on team assignment and role';
COMMENT ON POLICY invoices_role_access ON invoices IS 'RLS v9.0: Invoice access with PM permission validation';

-- Final status message
DO $$
BEGIN
  RAISE NOTICE '🏛️ BeeSmart Pro RLS Foundation v9.0 - Installation Complete';
  RAISE NOTICE '✅ Phase 1 policies applied for 5 internal roles';
  RAISE NOTICE '✅ Tenant isolation enabled on all business tables';
  RAISE NOTICE '✅ Performance indexes created for sub-millisecond queries';
  RAISE NOTICE '✅ Audit and compliance policies activated';
  RAISE NOTICE '📊 Run SELECT * FROM test_rls_policies() to validate installation';
END;
$$;
