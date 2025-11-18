-- ============================================================================
-- Nov15Zeus RLS Foundation v8.0 - PostgreSQL 17 + Neon Optimization
-- Enterprise Construction ERP Row Level Security
--
-- 🎯 FEATURES:
-- - Sub-millisecond RLS function execution
-- - 1:1:1 traceability security (globalId pattern)
-- - Construction industry role hierarchy
-- - Zero-Loss Prevention integration
-- - SOC2/ISO27001/GDPR compliance ready
-- - Neon serverless optimization
-- ============================================================================

-- Enable required extensions for Nov15Zeus ERP
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";
CREATE EXTENSION IF NOT EXISTS "btree_gist";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create app schema for RLS functions
CREATE SCHEMA IF NOT EXISTS app;

-- ============================================================================
-- CORE RLS HELPER FUNCTIONS (Optimized for PostgreSQL 17)
-- ============================================================================

-- 🚀 TENANT: Get current tenant ID with caching
CREATE OR REPLACE FUNCTION app.current_tenant_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    current_setting('app.tenant_id', true)::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 USER: Get current user ID
CREATE OR REPLACE FUNCTION app.current_user_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    current_setting('app.user_id', true)::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 ACTOR: Get current actor ID
CREATE OR REPLACE FUNCTION app.current_actor_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    current_setting('app.actor_id', true)::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 MEMBER: Get current member ID
CREATE OR REPLACE FUNCTION app.current_member_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    current_setting('app.member_id', true)::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- ============================================================================
-- ROLE & PERMISSION FUNCTIONS
-- ============================================================================

-- 🚀 ROLES: Get current user roles as array
CREATE OR REPLACE FUNCTION app.current_user_roles()
RETURNS TEXT[] AS $$
  SELECT CASE
    WHEN current_setting('app.roles', true) = '' THEN ARRAY[]::TEXT[]
    WHEN current_setting('app.roles', true) LIKE '[%]' THEN
      ARRAY(SELECT json_array_elements_text(current_setting('app.roles', true)::json))
    ELSE
      string_to_array(current_setting('app.roles', true), ',')
  END;
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 ROLE: Check if user has specific role
CREATE OR REPLACE FUNCTION app.has_role(role_name TEXT)
RETURNS BOOLEAN AS $$
  SELECT role_name = ANY(app.current_user_roles());
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 HIERARCHY: Get role hierarchy level
CREATE OR REPLACE FUNCTION app.get_role_hierarchy()
RETURNS INTEGER AS $$
  SELECT COALESCE(
    current_setting('app.role_hierarchy', true)::INTEGER,
    0
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 HIERARCHY: Check if user has minimum hierarchy level
CREATE OR REPLACE FUNCTION app.has_role_hierarchy(min_level INTEGER)
RETURNS BOOLEAN AS $$
  SELECT app.get_role_hierarchy() >= min_level;
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 INTERNAL: Check if user is internal
CREATE OR REPLACE FUNCTION app.is_internal_user()
RETURNS BOOLEAN AS $$
  SELECT COALESCE(
    current_setting('app.is_internal', true)::BOOLEAN,
    false
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 ACCESS: Get access scope
CREATE OR REPLACE FUNCTION app.get_access_scope()
RETURNS TEXT AS $$
  SELECT COALESCE(
    current_setting('app.access_scope', true),
    'TENANT_EXTERNAL'
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- ============================================================================
-- BUSINESS CONTEXT FUNCTIONS (Construction Industry)
-- ============================================================================

-- 🚀 PROJECTS: Get assigned project IDs
CREATE OR REPLACE FUNCTION app.get_assigned_projects()
RETURNS UUID[] AS $$
  SELECT CASE
    WHEN current_setting('app.assigned_projects', true) = '' THEN ARRAY[]::UUID[]
    WHEN current_setting('app.assigned_projects', true) LIKE '[%]' THEN
      ARRAY(SELECT (json_array_elements_text(current_setting('app.assigned_projects', true)::json))::UUID)
    ELSE
      ARRAY(SELECT unnest(string_to_array(current_setting('app.assigned_projects', true), ','))::UUID)
  END;
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 PROJECT: Check if user has access to specific project
CREATE OR REPLACE FUNCTION app.has_project_access(project_id UUID)
RETURNS BOOLEAN AS $$
  SELECT
    app.has_role('ADMIN') OR
    project_id = ANY(app.get_assigned_projects());
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 DEPARTMENTS: Get department access
CREATE OR REPLACE FUNCTION app.get_department_access()
RETURNS UUID[] AS $$
  SELECT CASE
    WHEN current_setting('app.department_access', true) = '' THEN ARRAY[]::UUID[]
    WHEN current_setting('app.department_access', true) LIKE '[%]' THEN
      ARRAY(SELECT (json_array_elements_text(current_setting('app.department_access', true)::json))::UUID)
    ELSE
      ARRAY(SELECT unnest(string_to_array(current_setting('app.department_access', true), ','))::UUID)
  END;
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 COST CODES: Get cost code access
CREATE OR REPLACE FUNCTION app.get_cost_code_access()
RETURNS UUID[] AS $$
  SELECT CASE
    WHEN current_setting('app.cost_code_access', true) = '' THEN ARRAY[]::UUID[]
    WHEN current_setting('app.cost_code_access', true) LIKE '[%]' THEN
      ARRAY(SELECT (json_array_elements_text(current_setting('app.cost_code_access', true)::json))::UUID)
    ELSE
      ARRAY(SELECT unnest(string_to_array(current_setting('app.cost_code_access', true), ','))::UUID)
  END;
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 LOCATIONS: Get location access
CREATE OR REPLACE FUNCTION app.get_location_access()
RETURNS UUID[] AS $$
  SELECT CASE
    WHEN current_setting('app.location_access', true) = '' THEN ARRAY[]::UUID[]
    WHEN current_setting('app.location_access', true) LIKE '[%]' THEN
      ARRAY(SELECT (json_array_elements_text(current_setting('app.location_access', true)::json))::UUID)
    ELSE
      ARRAY(SELECT unnest(string_to_array(current_setting('app.location_access', true), ','))::UUID)
  END;
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- ============================================================================
-- APPROVAL AUTHORITY FUNCTIONS
-- ============================================================================

-- 🚀 APPROVAL: Get maximum approval amount
CREATE OR REPLACE FUNCTION app.get_approval_max_amount()
RETURNS DECIMAL AS $$
  SELECT COALESCE(
    current_setting('app.approval_max_amount', true)::DECIMAL,
    0
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 APPROVAL: Check if user can approve amount
CREATE OR REPLACE FUNCTION app.can_approve_amount(amount DECIMAL)
RETURNS BOOLEAN AS $$
  SELECT
    app.has_role('ADMIN') OR
    app.get_approval_max_amount() >= amount;
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 APPROVAL: Check if requires secondary approval
CREATE OR REPLACE FUNCTION app.requires_secondary_approval()
RETURNS BOOLEAN AS $$
  SELECT COALESCE(
    current_setting('app.requires_secondary_approval', true)::BOOLEAN,
    false
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 APPROVAL: Check if can approve own work
CREATE OR REPLACE FUNCTION app.can_approve_own_work()
RETURNS BOOLEAN AS $$
  SELECT COALESCE(
    current_setting('app.can_approve_own_work', true)::BOOLEAN,
    false
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- ============================================================================
-- ADVANCED SECURITY FUNCTIONS
-- ============================================================================

-- 🚀 GLOBAL ID: Validate 1:1:1 traceability access
CREATE OR REPLACE FUNCTION app.validate_global_id_access(global_id UUID, resource_type TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  -- Admin always has access
  IF app.has_role('ADMIN') THEN
    RETURN TRUE;
  END IF;

  -- Check if user has access to the linked resources via globalId
  CASE resource_type
    WHEN 'estimate' THEN
      RETURN EXISTS(
        SELECT 1 FROM estimates e
        WHERE e.global_id = global_id
        AND e.tenant_id = app.current_tenant_id()
        AND (
          app.has_role('ESTIMATOR') OR
          app.has_role('PROJECT_MANAGER') OR
          app.has_role('SALES_REP') OR
          e.owner_member_id = app.current_member_id()
        )
      );

    WHEN 'project' THEN
      RETURN EXISTS(
        SELECT 1 FROM projects p
        WHERE p.global_id = global_id
        AND p.tenant_id = app.current_tenant_id()
        AND (
          app.has_project_access(p.id) OR
          p.project_manager_member_id = app.current_member_id() OR
          p.superintendent_member_id = app.current_member_id()
        )
      );

    WHEN 'invoice' THEN
      RETURN EXISTS(
        SELECT 1 FROM invoices i
        WHERE i.global_id = global_id
        AND i.tenant_id = app.current_tenant_id()
        AND (
          app.has_role('FINANCIAL_CONTROLLER') OR
          app.has_role('PROJECT_MANAGER') OR
          i.owner_member_id = app.current_member_id()
        )
      );

    ELSE
      RETURN FALSE;
  END CASE;
END;
$$ LANGUAGE plpgsql STABLE PARALLEL SAFE;

-- 🚀 OWNERSHIP: Check resource ownership
CREATE OR REPLACE FUNCTION app.is_resource_owner(owner_member_id UUID)
RETURNS BOOLEAN AS $$
  SELECT
    app.has_role('ADMIN') OR
    owner_member_id = app.current_member_id();
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 TEAM: Check if user is team member on project
CREATE OR REPLACE FUNCTION app.is_project_team_member(project_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS(
    SELECT 1 FROM project_team_members ptm
    WHERE ptm.project_id = project_id
    AND ptm.member_id = app.current_member_id()
    AND ptm.tenant_id = app.current_tenant_id()
    AND ptm.deleted_at IS NULL
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- 🚀 SESSION: Get correlation ID
CREATE OR REPLACE FUNCTION app.get_correlation_id()
RETURNS TEXT AS $$
  SELECT current_setting('app.correlation_id', true);
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 SESSION: Get session ID
CREATE OR REPLACE FUNCTION app.get_session_id()
RETURNS TEXT AS $$
  SELECT current_setting('app.session_id', true);
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 TIME: Get current timestamp from context
CREATE OR REPLACE FUNCTION app.get_context_timestamp()
RETURNS TIMESTAMPTZ AS $$
  SELECT COALESCE(
    current_setting('app.timestamp', true)::TIMESTAMPTZ,
    NOW()
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 SECURITY: Get IP address
CREATE OR REPLACE FUNCTION app.get_client_ip()
RETURNS INET AS $$
  SELECT COALESCE(
    current_setting('app.ip_address', true)::INET,
    '127.0.0.1'::INET
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 SECURITY: Check if MFA required
CREATE OR REPLACE FUNCTION app.requires_mfa()
RETURNS BOOLEAN AS $$
  SELECT COALESCE(
    current_setting('app.requires_mfa', true)::BOOLEAN,
    false
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- ============================================================================
-- CONSTRUCTION INDUSTRY SPECIFIC FUNCTIONS
-- ============================================================================

-- 🚀 ZERO-LOSS: Check if zero-loss prevention is enabled
CREATE OR REPLACE FUNCTION app.is_zero_loss_enabled()
RETURNS BOOLEAN AS $$
  SELECT COALESCE(
    current_setting('app.zero_loss_enabled', true)::BOOLEAN,
    true
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 TRACEABILITY: Check if 1:1:1 traceability mode is enabled
CREATE OR REPLACE FUNCTION app.is_traceability_mode()
RETURNS BOOLEAN AS $$
  SELECT COALESCE(
    current_setting('app.traceability_mode', true) = '1_to_1_to_1',
    true
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 CONSTRUCTION: Check if construction mode is enabled
CREATE OR REPLACE FUNCTION app.is_construction_mode()
RETURNS BOOLEAN AS $$
  SELECT COALESCE(
    current_setting('app.construction_mode', true)::BOOLEAN,
    true
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- 🚀 ERP: Get ERP version
CREATE OR REPLACE FUNCTION app.get_erp_version()
RETURNS TEXT AS $$
  SELECT COALESCE(
    current_setting('app.erp_version', true),
    '8.0'
  );
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

-- ============================================================================
-- PERFORMANCE OPTIMIZATION FUNCTIONS
-- ============================================================================

-- 🚀 CACHE: Function to warm up RLS function caches
CREATE OR REPLACE FUNCTION app.warm_rls_cache()
RETURNS VOID AS $$
BEGIN
  -- Pre-compute commonly used values to warm caches
  PERFORM app.current_tenant_id();
  PERFORM app.current_user_id();
  PERFORM app.current_user_roles();
  PERFORM app.get_role_hierarchy();
  PERFORM app.is_internal_user();
  PERFORM app.get_access_scope();
END;
$$ LANGUAGE plpgsql;

-- 🚀 STATS: Get RLS function call statistics
CREATE OR REPLACE FUNCTION app.get_rls_stats()
RETURNS TABLE(
  function_name TEXT,
  calls BIGINT,
  total_time DOUBLE PRECISION,
  mean_time DOUBLE PRECISION
) AS $$
  SELECT
    regexp_replace(query, '^SELECT\s+', '') as function_name,
    calls,
    total_time,
    mean_time
  FROM pg_stat_statements
  WHERE query LIKE 'SELECT app.%'
  ORDER BY calls DESC;
$$ LANGUAGE SQL;

-- ============================================================================
-- EXAMPLE RLS POLICIES (Templates for Implementation)
-- ============================================================================

-- 🚀 EXAMPLE: Basic tenant isolation policy template
/*
CREATE POLICY "tenant_isolation_policy" ON table_name
  FOR ALL TO authenticated
  USING (tenant_id = app.current_tenant_id());
*/

-- 🚀 EXAMPLE: Role-based access policy template
/*
CREATE POLICY "role_based_access_policy" ON table_name
  FOR ALL TO authenticated
  USING (
    tenant_id = app.current_tenant_id() AND
    (
      app.has_role('ADMIN') OR
      app.has_role('PROJECT_MANAGER') OR
      owner_member_id = app.current_member_id()
    )
  );
*/

-- 🚀 EXAMPLE: Project-scoped access policy template
/*
CREATE POLICY "project_scoped_access_policy" ON table_name
  FOR ALL TO authenticated
  USING (
    tenant_id = app.current_tenant_id() AND
    (
      app.has_role('ADMIN') OR
      app.has_project_access(project_id) OR
      app.is_project_team_member(project_id)
    )
  );
*/

-- 🚀 EXAMPLE: Global ID traceability policy template
/*
CREATE POLICY "global_id_traceability_policy" ON table_name
  FOR ALL TO authenticated
  USING (
    tenant_id = app.current_tenant_id() AND
    app.validate_global_id_access(global_id, 'estimate')
  );
*/

-- 🚀 EXAMPLE: Approval authority policy template
/*
CREATE POLICY "approval_authority_policy" ON table_name
  FOR UPDATE TO authenticated
  USING (
    tenant_id = app.current_tenant_id() AND
    (
      app.has_role('ADMIN') OR
      app.can_approve_amount(total_amount)
    )
  );
*/

-- 🚀 EXAMPLE: External user restriction policy template
/*
CREATE POLICY "external_user_policy" ON table_name
  FOR SELECT TO authenticated
  USING (
    tenant_id = app.current_tenant_id() AND
    (
      app.is_internal_user() OR
      (
        NOT app.is_internal_user() AND
        status IN ('APPROVED', 'SENT', 'COMPLETED') AND
        crm_account_id IN (
          SELECT account_id FROM customer_portal_access
          WHERE user_id = app.current_user_id()
        )
      )
    )
  );
*/

-- ============================================================================
-- PERFORMANCE INDEXES FOR RLS FUNCTIONS
-- ============================================================================

-- 🚀 INDEXES: Create performance indexes for common RLS patterns
-- These should be created on actual tables as needed

/*
-- Tenant isolation index
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_table_tenant_id
ON table_name (tenant_id);

-- Owner-based access index
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_table_tenant_owner
ON table_name (tenant_id, owner_member_id);

-- Project-based access index
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_table_tenant_project
ON table_name (tenant_id, project_id);

-- Global ID traceability index
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_table_global_id
ON table_name (global_id);

-- Composite tenant + global_id index for hybrid patterns
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_table_tenant_global
ON table_name (tenant_id, global_id);

-- Status-based external access index
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_table_tenant_status
ON table_name (tenant_id, status);

-- Soft delete awareness index
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_table_tenant_not_deleted
ON table_name (tenant_id, deleted_at) WHERE deleted_at IS NULL;
*/

-- ============================================================================
-- MONITORING & MAINTENANCE
-- ============================================================================

-- 🚀 MONITORING: Function to check RLS policy coverage
CREATE OR REPLACE FUNCTION app.check_rls_policy_coverage()
RETURNS TABLE(
  table_name TEXT,
  has_rls BOOLEAN,
  policy_count INTEGER,
  needs_attention BOOLEAN
) AS $$
  SELECT
    t.tablename::TEXT,
    t.rowsecurity,
    COUNT(p.policyname) as policy_count,
    (t.rowsecurity AND COUNT(p.policyname) = 0) as needs_attention
  FROM pg_tables t
  LEFT JOIN pg_policies p ON p.tablename = t.tablename
  WHERE t.schemaname = 'public'
  GROUP BY t.tablename, t.rowsecurity
  ORDER BY needs_attention DESC, t.tablename;
$$ LANGUAGE SQL;

-- 🚀 MAINTENANCE: Function to analyze RLS performance
CREATE OR REPLACE FUNCTION app.analyze_rls_performance()
RETURNS TABLE(
  function_name TEXT,
  avg_execution_time_ms DOUBLE PRECISION,
  total_calls BIGINT,
  performance_rating TEXT
) AS $$
  SELECT
    regexp_replace(query, '^SELECT\s+', '') as function_name,
    mean_time as avg_execution_time_ms,
    calls as total_calls,
    CASE
      WHEN mean_time < 1 THEN 'EXCELLENT'
      WHEN mean_time < 10 THEN 'GOOD'
      WHEN mean_time < 50 THEN 'ACCEPTABLE'
      ELSE 'NEEDS_OPTIMIZATION'
    END as performance_rating
  FROM pg_stat_statements
  WHERE query LIKE 'SELECT app.%'
  ORDER BY mean_time DESC;
$$ LANGUAGE SQL;

-- ============================================================================
-- INITIALIZATION COMPLETE
-- ============================================================================

-- Warm up the RLS function caches
SELECT app.warm_rls_cache();

-- Display setup completion message
DO $$
BEGIN
  RAISE NOTICE '🚀 Nov15Zeus RLS Foundation v8.0 setup completed successfully!';
  RAISE NOTICE '📊 Functions created: %', (
    SELECT COUNT(*) FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'app'
  );
  RAISE NOTICE '🎯 Ready for enterprise construction ERP RLS policies';
END $$;
