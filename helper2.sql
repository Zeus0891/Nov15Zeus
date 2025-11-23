-- ==========================================================
-- 🚀 ERP Multi-tenant RLS Helpers (PostgreSQL / Neon Cloud)
-- ==========================================================

CREATE SCHEMA IF NOT EXISTS app;

-- === JWT claims ===
CREATE OR REPLACE FUNCTION app.jwt() RETURNS jsonb
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(current_setting('request.jwt.claims', true)::jsonb, '{}'::jsonb)
$$;

-- === Tenant ===
CREATE OR REPLACE FUNCTION app.current_tenant_id() RETURNS uuid
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    NULLIF(current_setting('app.current_tenant_id', true), '')::uuid,
    NULLIF(app.jwt()->>'tenantId','')::uuid,
    NULLIF(app.jwt()->>'tenant_id','')::uuid
  )
$$;

-- === Member ===
CREATE OR REPLACE FUNCTION app.current_member_id() RETURNS uuid
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    NULLIF(current_setting('app.current_member_id', true), '')::uuid,
    NULLIF(app.jwt()->>'memberId','')::uuid,
    NULLIF(app.jwt()->>'member_id','')::uuid
  )
$$;

-- === User ===
CREATE OR REPLACE FUNCTION app.current_user_id() RETURNS uuid
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    NULLIF(current_setting('app.current_user_id', true), '')::uuid,
    NULLIF(app.jwt()->>'sub','')::uuid
  )
$$;

-- === Actor (para auditoría) ===
CREATE OR REPLACE FUNCTION app.current_actor_id() RETURNS uuid
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(app.current_member_id(), app.current_user_id())
$$;

-- ==========================================================
-- Roles Helpers
-- ==========================================================

-- === Roles actuales ===
CREATE OR REPLACE FUNCTION app.current_roles() RETURNS text[]
LANGUAGE sql STABLE AS $$
  SELECT CASE
    WHEN COALESCE(current_setting('app.current_roles', true), '') <> ''
      THEN string_to_array(current_setting('app.current_roles', true), ',')
    WHEN COALESCE(app.jwt()->>'roles','') <> ''
      THEN string_to_array(app.jwt()->>'roles', ',')
    WHEN COALESCE(app.jwt()->>'role','') <> ''
      THEN ARRAY[app.jwt()->>'role']::text[]
    ELSE ARRAY[]::text[]
  END
$$;

-- === Tiene algún rol ===
CREATE OR REPLACE FUNCTION app.has_any_role(roles text[]) RETURNS boolean
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(app.current_roles(), ARRAY[]::text[]) && roles
$$;

-- === Tiene un rol específico ===
CREATE OR REPLACE FUNCTION app.has_role(role text) RETURNS boolean
LANGUAGE sql STABLE AS $$
  SELECT role = ANY(COALESCE(app.current_roles(), ARRAY[]::text[]))
$$;

-- === Tiene todos los roles indicados ===
CREATE OR REPLACE FUNCTION app.has_all_roles(roles text[]) RETURNS boolean
LANGUAGE sql STABLE AS $$
  SELECT array_length(roles, 1) > 0
   AND roles <@ COALESCE(app.current_roles(), ARRAY[]::text[])
$$;

-- === Roles específicos comunes ===
CREATE OR REPLACE FUNCTION app.is_admin() RETURNS boolean
LANGUAGE sql STABLE AS $$ SELECT app.has_role('ADMIN') $$;

CREATE OR REPLACE FUNCTION app.is_project_manager() RETURNS boolean
LANGUAGE sql STABLE AS $$ SELECT app.has_role('PROJECT_MANAGER') $$;

CREATE OR REPLACE FUNCTION app.is_worker() RETURNS boolean
LANGUAGE sql STABLE AS $$ SELECT app.has_role('WORKER') $$;

CREATE OR REPLACE FUNCTION app.is_driver() RETURNS boolean
LANGUAGE sql STABLE AS $$ SELECT app.has_role('DRIVER') $$;

CREATE OR REPLACE FUNCTION app.is_viewer() RETURNS boolean
LANGUAGE sql STABLE AS $$ SELECT app.has_role('VIEWER') $$;

-- ==========================================================
-- Debug Utility (Optional)
-- ==========================================================
CREATE OR REPLACE FUNCTION app.debug_claims() RETURNS jsonb
LANGUAGE sql STABLE AS $$
  SELECT jsonb_build_object(
    'tenant_id', app.current_tenant_id(),
    'member_id', app.current_member_id(),
    'user_id', app.current_user_id(),
    'actor_id', app.current_actor_id(),
    'roles', app.current_roles()
  )
$$;
