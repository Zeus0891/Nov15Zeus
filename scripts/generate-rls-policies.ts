#!/usr/bin/env npx tsx

/**
 * 🏛️ RLS Policy Generator for BeeSmart ERP (ADMIN ROLE)
 *
 * ✔ Neon-safe     (NO SET ROLE, NO OWNER TO)
 * ✔ Prisma-safe   (shadow DB compatible)
 * ✔ Auto-detect soft delete by checking `deletedAt` in Prisma models
 * ✔ Auto-detect ownership by checking `createdByActorId`
 * ✔ Auto-detect tenant tables by presence of `tenantId`
 * ✔ Uses TO PUBLIC + app.is_admin() checks
 *
 * Pattern:
 *   • 1 migration file por rol (este archivo = ADMIN)
 *   • 1 policy por rol + comando (SELECT/INSERT/UPDATE/DELETE)
 *   • Policies PERMISSIVE (sin AS RESTRICTIVE) para permitir OR entre roles
 *
 * Usage:
 *    npx tsx scripts/generate-rls-policies.ts
 */

import fs from "fs";
import path from "path";

// ============================================================================
// CONFIG
// ============================================================================

const PRISMA_SCHEMAS_DIR = "./prisma/schemas";
const OUTPUT_FILE = "./prisma/migrations/rls_policies_admin_generated.sql";
const BACKUP_FILE = `./prisma/migrations/rls_policies_admin_backup_${Date.now()}.sql`;

// GLOBAL modules to exclude (NO tenantId, NO RLS)
const GLOBAL_MODULES = [
  "identityCore.prisma",
  "identityAuthN.prisma",
  "platformRegistry.prisma",
  "publicLinkEngine.prisma",
  "identityAuthZ.prisma",
];

// ============================================================================
// TYPES
// ============================================================================

interface TableInfo {
  name: string;
  hasSoftDelete: boolean;
  hasOwnership: boolean;
  module: string;
}

// ============================================================================
// EXTRACT TABLE INFO FROM PRISMA
// ============================================================================

function extractTablesFromSchemas(): TableInfo[] {
  const tables: TableInfo[] = [];

  const schemaFiles = fs
    .readdirSync(PRISMA_SCHEMAS_DIR)
    .filter((f) => f.endsWith(".prisma"))
    .filter((f) => !GLOBAL_MODULES.includes(f));

  for (const file of schemaFiles) {
    const filePath = path.join(PRISMA_SCHEMAS_DIR, file);
    const content = fs.readFileSync(filePath, "utf8");

    const modelMatches = content.matchAll(/model\s+(\w+)\s*{([^}]+)}/g);

    for (const match of modelMatches) {
      const modelName = match[1];
      const body = match[2];

      // Tenant tables: must have tenantId
      if (!body.includes("tenantId")) continue;

      // Auto-convert PascalCase → snake_case
      const tableName = modelName
        .replace(/([A-Z]+)([A-Z][a-z])/g, "$1_$2")
        .replace(/([a-z\d])([A-Z])/g, "$1_$2")
        .toLowerCase();

      const hasSoftDelete = body.includes("deletedAt");
      const hasOwnership = body.includes("createdByActorId");

      tables.push({
        name: tableName,
        hasSoftDelete,
        hasOwnership,
        module: file,
      });
    }
  }

  return tables;
}

// ============================================================================
// RLS POLICY TEMPLATES
// ============================================================================

const TO_ROLE = "PUBLIC"; // Neon-safe, Prisma-safe

function generateSelectPolicy(t: TableInfo): string {
  const soft = t.hasSoftDelete ? '\n  AND "deletedAt" IS NULL' : "";
  return `
-- SELECT Policy for ${t.name}
DROP POLICY IF EXISTS "rls_admin_select_${t.name}" ON public."${t.name}";

CREATE POLICY "rls_admin_select_${t.name}"
ON public."${t.name}"
FOR SELECT
TO ${TO_ROLE}
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()${soft}
);`;
}

function generateInsertPolicy(t: TableInfo): string {
  return `
-- INSERT Policy for ${t.name}
DROP POLICY IF EXISTS "rls_admin_insert_${t.name}" ON public."${t.name}";

CREATE POLICY "rls_admin_insert_${t.name}"
ON public."${t.name}"
FOR INSERT
TO ${TO_ROLE}
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);`;
}

function generateUpdatePolicy(t: TableInfo): string {
  const soft = t.hasSoftDelete ? '\n  AND "deletedAt" IS NULL' : "";
  return `
-- UPDATE Policy for ${t.name}
DROP POLICY IF EXISTS "rls_admin_update_${t.name}" ON public."${t.name}";

CREATE POLICY "rls_admin_update_${t.name}"
ON public."${t.name}"
FOR UPDATE
TO ${TO_ROLE}
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()${soft}
)
WITH CHECK (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);`;
}

function generateDeletePolicy(t: TableInfo): string {
  return `
-- DELETE Policy for ${t.name}
DROP POLICY IF EXISTS "rls_admin_delete_${t.name}" ON public."${t.name}";

CREATE POLICY "rls_admin_delete_${t.name}"
ON public."${t.name}"
FOR DELETE
TO ${TO_ROLE}
USING (
  app.is_admin()
  AND "tenantId" = app.current_tenant_id()
);`;
}

function generateTablePolicies(t: TableInfo): string {
  return `
-- ================================================================================
-- 🏛️ ADMIN Policies for ${t.name} (${t.module})
-- Soft Delete: ${t.hasSoftDelete ? "YES" : "NO"} | Ownership: ${
    t.hasOwnership ? "YES" : "NO"
  }
-- ================================================================================
${generateSelectPolicy(t)}
${generateInsertPolicy(t)}
${generateUpdatePolicy(t)}
${generateDeletePolicy(t)}
`;
}

// ============================================================================
// MAIN GENERATION LOGIC
// ============================================================================

function generateRLSPolicies(): void {
  const tables = extractTablesFromSchemas();

  const header = `-- ================================================================================
-- 🏛️ BeeSmart ERP - ADMIN RLS Policies (Auto-Generated)
-- ================================================================================
-- Generated: ${new Date().toISOString()}
-- Total Tenant Tables: ${tables.length}
-- Pattern: ADMIN = Full CRUD within tenant
-- Pattern: 1 migration per role, 1 policy per role+command, policies PERMISSIVE
-- Neon-safe (NO SET ROLE), Prisma-safe, helper-aligned
-- ================================================================================

BEGIN;
`;

  const footer = `
COMMIT;

-- Debug:
-- SELECT app.debug_claims();
`;

  const sql =
    header + tables.map((t) => generateTablePolicies(t)).join("\n") + footer;

  // Backup old file if exists
  if (fs.existsSync(OUTPUT_FILE)) {
    fs.copyFileSync(OUTPUT_FILE, BACKUP_FILE);
  }

  fs.writeFileSync(OUTPUT_FILE, sql);

  console.log("✅ RLS policies generated for ADMIN!");
  console.log("📄 File:", OUTPUT_FILE);
}

if (require.main === module) generateRLSPolicies();

export { extractTablesFromSchemas, generateRLSPolicies };
