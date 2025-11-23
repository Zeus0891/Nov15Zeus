-- ================================================================================
-- 🏛️ ADMIN RLS Pattern - Production Version (Prisma Compatible)
-- Pattern: ADMIN = Tenant Owner with CRUD access to ALL tenant-scoped tables
-- Scope: HYBRID + TENANT modules only (excludes GLOBAL modules)
-- Field Names: Uses Prisma quoted identifiers (camelCase) for compatibility
-- ================================================================================

-- PRODUCTION ADMIN Pattern optimized for Prisma + PostgreSQL + Neon
-- Example: Estimate table (HYBRID module with soft delete)

-- SELECT Policy (filters deletedAt)
DROP POLICY IF EXISTS "rls_admin_select_estimate" ON public."estimate";

CREATE POLICY "rls_admin_select_estimate"
ON public."estimate"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  -- Role check first (fastest)
  app.is_admin()
  -- Tenant isolation (indexed) - Prisma field names
  AND "tenantId" = app.current_tenant_id()
  -- Soft delete filter (for SELECT only) - Prisma field names
  AND "deletedAt" IS NULL
);

-- INSERT Policy (no deletedAt check)
DROP POLICY IF EXISTS "rls_admin_insert_estimate" ON public."estimate";

CREATE POLICY "rls_admin_insert_estimate"
ON public."estimate"
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  -- Note: No deletedAt check for INSERT (new records)
);

-- UPDATE Policy (only active records; allows soft delete)
DROP POLICY IF EXISTS "rls_admin_update_estimate" ON public."estimate";

CREATE POLICY "rls_admin_update_estimate"
ON public."estimate"
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  AND "deletedAt" IS NULL  -- Can only update non-deleted records
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  -- Note: Allow setting deletedAt in WITH CHECK (for soft delete)
);

-- DELETE Policy (only tenant match; allows hard delete)
DROP POLICY IF EXISTS "rls_admin_delete_estimate" ON public."estimate";

CREATE POLICY "rls_admin_delete_estimate"
ON public."estimate"
AS RESTRICTIVE
FOR DELETE
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  -- Note: No deletedAt check for DELETE (allow hard delete of soft-deleted records)
);-- ================================================================================
-- PATTERN VARIATIONS FOR DIFFERENT TABLE TYPES
-- ================================================================================

-- 1) Tables WITHOUT soft delete (most TENANT tables)
-- Example: Role table

DROP POLICY IF EXISTS "rls_admin_select_role" ON public."role";
CREATE POLICY "rls_admin_select_role"
ON public."role"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
  -- No deletedAt check needed
);

-- 2) Tables with OWNERSHIP pattern (createdByActorId)
-- ADMIN can see ALL, but other roles only their own
-- Example: Document table

DROP POLICY IF EXISTS "rls_admin_select_document" ON public."document";
CREATE POLICY "rls_admin_select_document"
ON public."document"
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  "tenantId" = app.current_tenant_id()
  AND (
    app.is_admin()  -- ADMIN sees everything in tenant
    OR "createdByActorId" = app.current_actor_id()  -- Others see only their own
  )
  AND "deletedAt" IS NULL
);

-- 3) GLOBAL tables (NO tenant_id) - ADMIN has NO access
-- These are system tables managed by platform
-- Example: User, Tenant, Permission tables
-- NO policies needed - ADMIN cannot access these

-- ================================================================================
-- PERFORMANCE OPTIMIZATIONS
-- ================================================================================

-- Ensure these indexes exist for performance (Prisma field names):
-- CREATE INDEX CONCURRENTLY idx_estimate_tenant_deleted ON estimate("tenantId", "deletedAt");
-- CREATE INDEX CONCURRENTLY idx_estimate_tenant_id ON estimate("tenantId") WHERE "deletedAt" IS NULL;

-- ================================================================================
-- VALIDATION QUERIES (Run these to test)
-- ================================================================================

-- Test ADMIN access (should work)
-- SET app.current_tenant_id = 'your-tenant-uuid';
-- SET app.current_roles = 'ADMIN';
-- SELECT * FROM estimate LIMIT 5;

-- Test non-ADMIN access (should be empty/restricted)
-- SET app.current_roles = 'VIEWER';
-- SELECT * FROM estimate LIMIT 5;-- ================================================================================
-- DEPLOYMENT NOTES
-- ================================================================================

-- 1. Run this AFTER app helpers are created
-- 2. Test with sample data before production
-- 3. Monitor query performance with pg_stat_statements
-- 4. Consider policy naming convention: rls_{role}_{operation}_{table}
