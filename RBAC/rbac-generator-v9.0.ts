#!/usr/bin/env node

/**
 * 🏛️ BeeSmart Pro RBAC Generator v9.0
 * Phase 1 - Internal Members Only
 *
 * SOURCE OF TRUTH: rbac_permissions_v3.md
 * SCHEMA: rbac_schema_v9.0.yml
 *
 * Features:
 * - TypeScript constant generation with full type safety
 * - Prisma seed file generation for Role + Permission + RolePermission
 * - Complete permission catalog validation
 * - Role hierarchy validation
 * - No wildcards - all permissions explicit
 * - Integration with RLS + TenantSettings hybrid model
 * - Phase 1 focus: 5 internal roles only
 *
 * Usage:
 *   npx tsx rbac-generator-v9.0.ts
 *   npx tsx rbac-generator-v9.0.ts --validate-only
 *   npx tsx rbac-generator-v9.0.ts --output-dir ./generated
 */

import { program } from "commander";
import * as fs from "fs";
import * as yaml from "js-yaml";
import * as path from "path";

// ============================================================================
// TYPES & INTERFACES
// ============================================================================

interface RBACSchema {
  rbac_version: string;
  generated_date: string;
  compatibility: string;
  phase: string;
  source_document: string;
  conventions_aligned: boolean;
  description: string;
  security_configuration: SecurityConfiguration;
  domains: Domain[];
  actions: string[];
  subactions: string[];
  roles: Role[];
  permission_catalog: Record<string, string[]>;
  role_grants: Record<string, RoleGrant>;
  critical_permissions?: CriticalPermissions;
  validation: ValidationConfig;
}

interface SecurityConfiguration {
  role_hierarchy_convention: string;
  hierarchy_range: string;
  phase_1_roles: number;
  permission_strategy: string;
  naming_convention: string;
  security_layers: string[];
  design_principles: string[];
  compliance_standards: string[];
}

interface Domain {
  key: string;
  description: string;
  module?: string;
}

interface Role {
  code: string;
  hierarchy: number;
  display_name: string;
  description: string;
  role_type: "INTERNAL" | "EXTERNAL";
  business_context: {
    typical_users: string[];
    access_scope: string;
    use_cases: string[];
  };
  critical_permissions_note?: string;
  enforcement_note?: string;
  exclusions?: string[];
}

interface RoleGrant {
  note: string;
  permissions: string[];
  critical_permissions_gated_by?: string;
  enforcement?: string;
}

interface CriticalPermissions {
  PROJECT_MANAGER_ELEVATED: {
    note: string;
    gating_mechanism: string;
    approvals: CriticalPermission[];
    deletes: CriticalPermission[];
    financial_visibility: CriticalPermission[];
  };
}

interface CriticalPermission {
  permission: string;
  gated_by: string;
}

interface ValidationConfig {
  source_document: string;
  phase: string;
  total_roles: number;
  total_permissions: number;
  total_granted_admin: number;
  total_granted_pm: number;
  total_granted_worker: number;
  total_granted_driver: number;
  total_granted_viewer: number;
  critical_permissions_cataloged: number;
  permission_format: string;
  hierarchy_range: string;
  wildcard_usage: string;
  yaml_valid: boolean;
  production_ready: boolean;
  rls_enforced: boolean;
  tenant_settings_integration: boolean;
}

interface PermissionMetadata {
  domain: string;
  action: string;
  subaction: string | null;
  full_permission: string;
}

interface GenerationResult {
  permissions: PermissionMetadata[];
  roles: Role[];
  rolePermissions: Record<string, string[]>;
  criticalPermissions: string[];
  validation: {
    total_permissions: number;
    total_roles: number;
    permissions_per_role: Record<string, number>;
    hierarchy_valid: boolean;
    naming_valid: boolean;
    critical_permissions_count: number;
  };
}

// ============================================================================
// CLI CONFIGURATION
// ============================================================================

program
  .name("rbac-generator-v9.0")
  .description("BeeSmart Pro RBAC Generator - Phase 1 Internal Members")
  .version("9.0.0")
  .option(
    "-s, --schema <path>",
    "Path to RBAC schema YAML file",
    "./rbac_schema_v9.0.yml"
  )
  .option(
    "-o, --output-dir <path>",
    "Output directory for generated files",
    "./generated"
  )
  .option("--validate-only", "Only validate schema without generating files")
  .option("--verbose", "Enable verbose logging")
  .parse(process.argv);

const options = program.opts();

// ============================================================================
// LOGGING UTILITIES
// ============================================================================

const log = {
  info: (msg: string) => console.log(`ℹ️  ${msg}`),
  success: (msg: string) => console.log(`✅ ${msg}`),
  warn: (msg: string) => console.log(`⚠️  ${msg}`),
  error: (msg: string) => console.error(`❌ ${msg}`),
  debug: (msg: string) => {
    if (options.verbose) console.log(`🔍 ${msg}`);
  },
  section: (title: string) =>
    console.log(`\n${"=".repeat(70)}\n${title}\n${"=".repeat(70)}`),
};

// ============================================================================
// SCHEMA LOADING & VALIDATION
// ============================================================================

function loadSchema(schemaPath: string): RBACSchema {
  log.section("📋 Loading RBAC Schema");
  log.info(`Reading schema from: ${schemaPath}`);

  if (!fs.existsSync(schemaPath)) {
    log.error(`Schema file not found: ${schemaPath}`);
    process.exit(1);
  }

  try {
    const schemaContent = fs.readFileSync(schemaPath, "utf8");
    const schema = yaml.load(schemaContent) as RBACSchema;

    log.success(`Schema loaded successfully`);
    log.info(`Version: ${schema.rbac_version}`);
    log.info(`Phase: ${schema.phase}`);
    log.info(`Source: ${schema.source_document}`);

    return schema;
  } catch (error) {
    log.error(`Failed to parse YAML: ${error}`);
    process.exit(1);
  }
}

function validateSchema(schema: RBACSchema): boolean {
  log.section("🔍 Validating Schema");

  let isValid = true;

  // Validate phase
  if (schema.phase !== "PHASE_1_INTERNAL_MEMBERS") {
    log.error(`Invalid phase: ${schema.phase}. Expected: PHASE_1_INTERNAL_MEMBERS`);
    isValid = false;
  } else {
    log.success("Phase validation passed");
  }

  // Validate source document
  if (schema.source_document !== "rbac_permissions_v3.md") {
    log.warn(`Source document mismatch: ${schema.source_document}`);
  } else {
    log.success("Source document reference valid");
  }

  // Validate roles count (Phase 1: exactly 5 roles)
  if (schema.roles.length !== 5) {
    log.error(`Expected 5 roles for Phase 1, found: ${schema.roles.length}`);
    isValid = false;
  } else {
    log.success(`Role count correct: ${schema.roles.length} roles`);
  }

  // Validate role hierarchy
  const hierarchies = schema.roles.map((r) => r.hierarchy).sort((a, b) => a - b);
  const expectedHierarchies = [0, 2, 8, 9, 10];
  if (JSON.stringify(hierarchies) !== JSON.stringify(expectedHierarchies)) {
    log.error(`Invalid hierarchies. Expected: ${expectedHierarchies}, Found: ${hierarchies}`);
    isValid = false;
  } else {
    log.success("Role hierarchy validation passed");
  }

  // Validate role codes
  const roleCodes = schema.roles.map((r) => r.code).sort();
  const expectedRoles = ["ADMIN", "DRIVER", "PROJECT_MANAGER", "VIEWER", "WORKER"];
  if (JSON.stringify(roleCodes) !== JSON.stringify(expectedRoles)) {
    log.error(`Invalid role codes. Expected: ${expectedRoles}, Found: ${roleCodes}`);
    isValid = false;
  } else {
    log.success("Role codes validation passed");
  }

  // Validate all roles are INTERNAL
  const externalRoles = schema.roles.filter((r) => r.role_type !== "INTERNAL");
  if (externalRoles.length > 0) {
    log.error(`Phase 1 should only have INTERNAL roles. Found EXTERNAL: ${externalRoles.map(r => r.code).join(", ")}`);
    isValid = false;
  } else {
    log.success("All roles are INTERNAL (Phase 1 compliant)");
  }

  // Validate permission naming convention
  log.debug("Validating permission naming convention...");
  const allPermissions = extractAllPermissions(schema);
  let invalidPermissions = 0;
  
  allPermissions.forEach((perm) => {
    if (!isValidPermissionFormat(perm)) {
      log.warn(`Invalid permission format: ${perm}`);
      invalidPermissions++;
    }
  });

  if (invalidPermissions > 0) {
    log.warn(`Found ${invalidPermissions} permissions with non-standard format`);
  } else {
    log.success("All permissions follow domain:action:subaction convention");
  }

  // Validate no wildcards
  const wildcards = allPermissions.filter((p) => p.includes("*"));
  if (wildcards.length > 0) {
    log.error(`Found wildcards (not allowed in Phase 1): ${wildcards.join(", ")}`);
    isValid = false;
  } else {
    log.success("No wildcards found (all permissions explicit)");
  }

  // Validate permission catalog exists
  if (!schema.permission_catalog) {
    log.error("Missing permission_catalog in schema");
    isValid = false;
  } else {
    const catalogSize = Object.values(schema.permission_catalog)
      .flat()
      .length;
    log.success(`Permission catalog found: ${catalogSize} permissions`);
  }

  // Validate role grants
  if (!schema.role_grants) {
    log.error("Missing role_grants in schema");
    isValid = false;
  } else {
    const grantedRoles = Object.keys(schema.role_grants);
    const definedRoles = schema.roles.map((r) => r.code);
    
    grantedRoles.forEach((role) => {
      if (!definedRoles.includes(role)) {
        log.error(`Role grant for undefined role: ${role}`);
        isValid = false;
      }
    });
    
    if (isValid) {
      log.success("All role grants reference defined roles");
    }
  }

  // Validate critical permissions for PROJECT_MANAGER
  if (schema.critical_permissions) {
    const criticalPerms = [
      ...schema.critical_permissions.PROJECT_MANAGER_ELEVATED.approvals.map(p => p.permission),
      ...schema.critical_permissions.PROJECT_MANAGER_ELEVATED.deletes.map(p => p.permission),
      ...schema.critical_permissions.PROJECT_MANAGER_ELEVATED.financial_visibility.map(p => p.permission),
    ];

    // Ensure critical permissions are in catalog but NOT in PM grants
    const pmGrants = schema.role_grants.PROJECT_MANAGER?.permissions || [];
    const criticalInGrants = criticalPerms.filter(p => pmGrants.includes(p));
    
    if (criticalInGrants.length > 0) {
      log.error(`Critical permissions should NOT be granted to PM by default: ${criticalInGrants.join(", ")}`);
      isValid = false;
    } else {
      log.success("Critical PM permissions correctly excluded from default grants");
    }

    // Ensure critical permissions are in catalog
    const catalogPerms = extractAllPermissions(schema);
    const missingInCatalog = criticalPerms.filter(p => !catalogPerms.includes(p));
    
    if (missingInCatalog.length > 0) {
      log.error(`Critical permissions missing from catalog: ${missingInCatalog.join(", ")}`);
      isValid = false;
    } else {
      log.success("All critical permissions present in catalog");
    }
  }

  log.section("📊 Validation Summary");
  if (isValid) {
    log.success("✅ Schema validation PASSED - Production ready");
  } else {
    log.error("❌ Schema validation FAILED - Errors must be fixed");
  }

  return isValid;
}

function isValidPermissionFormat(permission: string): boolean {
  // Valid formats:
  // domain:action
  // domain:action:subaction
  const parts = permission.split(":");
  return parts.length >= 2 && parts.length <= 3;
}

function extractAllPermissions(schema: RBACSchema): string[] {
  const permissions = new Set<string>();

  // From permission catalog
  if (schema.permission_catalog) {
    Object.values(schema.permission_catalog).forEach((perms) => {
      perms.forEach((p) => permissions.add(p));
    });
  }

  // From role grants
  if (schema.role_grants) {
    Object.values(schema.role_grants).forEach((grant) => {
      grant.permissions.forEach((p) => permissions.add(p));
    });
  }

  return Array.from(permissions).sort();
}

// ============================================================================
// PERMISSION PROCESSING
// ============================================================================

function parsePermission(permission: string): PermissionMetadata {
  const parts = permission.split(":");
  return {
    domain: parts[0],
    action: parts[1],
    subaction: parts[2] || null,
    full_permission: permission,
  };
}

function processPermissions(schema: RBACSchema): PermissionMetadata[] {
  log.section("🔧 Processing Permissions");

  const allPermissions = extractAllPermissions(schema);
  const processedPermissions = allPermissions.map(parsePermission);

  log.success(`Processed ${processedPermissions.length} unique permissions`);

  // Group by domain
  const byDomain: Record<string, number> = {};
  processedPermissions.forEach((p) => {
    byDomain[p.domain] = (byDomain[p.domain] || 0) + 1;
  });

  log.info("Permissions by domain:");
  Object.entries(byDomain)
    .sort((a, b) => b[1] - a[1])
    .forEach(([domain, count]) => {
      log.info(`  ${domain}: ${count} permissions`);
    });

  return processedPermissions;
}

// ============================================================================
// ROLE PROCESSING
// ============================================================================

function processRoles(schema: RBACSchema): Record<string, string[]> {
  log.section("👥 Processing Role Grants");

  const rolePermissions: Record<string, string[]> = {};

  Object.entries(schema.role_grants).forEach(([roleCode, grant]) => {
    rolePermissions[roleCode] = grant.permissions;
    log.info(`${roleCode}: ${grant.permissions.length} permissions`);
    
    if (grant.critical_permissions_gated_by) {
      log.debug(`  ⚠️  ${grant.critical_permissions_gated_by}`);
    }
  });

  return rolePermissions;
}

// ============================================================================
// TYPESCRIPT CONSTANTS GENERATION
// ============================================================================

function generateTypeScriptConstants(result: GenerationResult): string {
  log.section("📝 Generating TypeScript Constants");

  const timestamp = new Date().toISOString();

  let output = `/**
 * 🏛️ RBAC Constants - AUTO-GENERATED
 * 
 * Generated: ${timestamp}
 * Phase: Phase 1 - Internal Members Only
 * Source: rbac_schema_v9.0.yml
 * Generator: rbac-generator-v9.0.ts
 * 
 * ⚠️  DO NOT EDIT THIS FILE MANUALLY
 * Regenerate using: npx tsx rbac-generator-v9.0.ts
 */

// ============================================================================
// ROLE CODES - Phase 1 Internal Members
// ============================================================================

export const ROLE_CODES = {
  // Tenant Owner (Hierarchy 0)
  ADMIN: "ADMIN",
  
  // Scoped Manager (Hierarchy 2)
  PROJECT_MANAGER: "PROJECT_MANAGER",
  
  // Execution Roles (Hierarchy 8-9)
  WORKER: "WORKER",
  DRIVER: "DRIVER",
  
  // Read-Only Sandbox (Hierarchy 10)
  VIEWER: "VIEWER",
} as const;

export type RoleCode = (typeof ROLE_CODES)[keyof typeof ROLE_CODES];

// ============================================================================
// ROLE HIERARCHY - 0 is Highest Authority
// ============================================================================

export const ROLE_HIERARCHY: Record<RoleCode, number> = {
${result.roles.map((r) => `  ${r.code}: ${r.hierarchy},`).join("\n")}
} as const;

// ============================================================================
// ROLE METADATA
// ============================================================================

export interface RoleMetadata {
  code: RoleCode;
  hierarchy: number;
  displayName: string;
  description: string;
  roleType: "INTERNAL" | "EXTERNAL";
}

export const ROLE_METADATA: Record<RoleCode, RoleMetadata> = {
${result.roles
  .map(
    (r) => `  ${r.code}: {
    code: "${r.code}",
    hierarchy: ${r.hierarchy},
    displayName: "${r.display_name}",
    description: "${r.description}",
    roleType: "${r.role_type}",
  },`
  )
  .join("\n")}
} as const;

// ============================================================================
// DOMAIN CODES
// ============================================================================

export const DOMAINS = {
  TENANT: "tenant",
  ACCESSCONTROL: "accesscontrol",
  IDENTITY: "identity",
  MEMBERSHIP: "membership",
  ESTIMATE: "estimate",
  INVOICE: "invoice",
  PROJECT: "project",
  TASK: "task",
  EXPENSES: "expenses",
  INVENTORY: "inventory",
  SCHEDULING: "scheduling",
  TIME: "time",
  PAYROLL: "payroll",
  CRM: "crm",
  DOCUMENTS: "documents",
  CHANGEORDER: "changeorder",
  AI: "ai",
  ANALYTICS: "analytics",
} as const;

export type Domain = (typeof DOMAINS)[keyof typeof DOMAINS];

// ============================================================================
// PERMISSION CONSTANTS - Complete Catalog
// ============================================================================

export const PERMISSIONS = {
${generatePermissionConstants(result.permissions)}
} as const;

export type Permission = (typeof PERMISSIONS)[keyof typeof PERMISSIONS];

// ============================================================================
// ROLE PERMISSIONS - Baseline Grants
// ============================================================================

export const ROLE_PERMISSIONS: Record<RoleCode, readonly Permission[]> = {
${Object.entries(result.rolePermissions)
  .map(
    ([role, perms]) =>
      `  ${role}: [\n${perms.map((p) => `    "${p}",`).join("\n")}\n  ],`
  )
  .join("\n")}
} as const;

// ============================================================================
// CRITICAL PERMISSIONS - Not Granted by Default to PM
// ============================================================================

/**
 * These permissions exist in the catalog but are NOT granted to PROJECT_MANAGER
 * by default. They require TenantSettings flags to enable.
 */
export const CRITICAL_PM_PERMISSIONS = {
  APPROVALS: [
${result.criticalPermissions
  .filter((p) => p.includes(":approve"))
  .map((p) => `    "${p}",`)
  .join("\n")}
  ],
  
  DELETES: [
${result.criticalPermissions
  .filter((p) => p.includes(":delete:"))
  .map((p) => `    "${p}",`)
  .join("\n")}
  ],
  
  FINANCIAL_VISIBILITY: [
${result.criticalPermissions
  .filter((p) => p.includes(":read:profit") || p.includes(":read:financial") || p.includes("analytics"))
  .map((p) => `    "${p}",`)
  .join("\n")}
  ],
} as const;

// ============================================================================
// TENANT SETTINGS FLAGS - PM Gating Flags
// ============================================================================

/**
 * TenantSettings boolean flags that control critical PM permissions
 */
export interface PMGatingFlags {
  pmCanApproveEstimates: boolean;
  pmCanApproveInvoices: boolean;
  pmCanApproveChangeOrders: boolean;
  pmCanSeeProjectFinancials: boolean;
  pmCanDeleteOwnEstimates: boolean;
  pmCanDeleteOwnInvoices: boolean;
  pmCanDeleteOwnChangeOrders: boolean;
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/**
 * Check if a role has higher or equal authority than another role
 */
export function hasHigherOrEqualAuthority(
  role1: RoleCode,
  role2: RoleCode
): boolean {
  return ROLE_HIERARCHY[role1] <= ROLE_HIERARCHY[role2];
}

/**
 * Get all permissions for a role (baseline grants only)
 */
export function getRolePermissions(role: RoleCode): readonly Permission[] {
  return ROLE_PERMISSIONS[role] || [];
}

/**
 * Check if a role has a specific permission (baseline check only)
 */
export function roleHasPermission(
  role: RoleCode,
  permission: Permission
): boolean {
  return ROLE_PERMISSIONS[role]?.includes(permission) ?? false;
}

/**
 * Get role metadata
 */
export function getRoleMetadata(role: RoleCode): RoleMetadata {
  return ROLE_METADATA[role];
}

// ============================================================================
// VALIDATION STATISTICS
// ============================================================================

export const RBAC_STATS = {
  totalRoles: ${result.roles.length},
  totalPermissions: ${result.permissions.length},
  criticalPermissions: ${result.criticalPermissions.length},
  permissionsPerRole: {
${Object.entries(result.validation.permissions_per_role)
  .map(([role, count]) => `    ${role}: ${count},`)
  .join("\n")}
  },
  phase: "PHASE_1_INTERNAL_MEMBERS",
  generatedAt: "${timestamp}",
} as const;
`;

  log.success("TypeScript constants generated");
  return output;
}

function generatePermissionConstants(permissions: PermissionMetadata[]): string {
  const grouped: Record<string, PermissionMetadata[]> = {};

  permissions.forEach((p) => {
    if (!grouped[p.domain]) {
      grouped[p.domain] = [];
    }
    grouped[p.domain].push(p);
  });

  const domainBlocks = Object.entries(grouped)
    .sort((a, b) => a[0].localeCompare(b[0]))
    .map(([domain, perms]) => {
      const permLines = perms
        .sort((a, b) => a.full_permission.localeCompare(b.full_permission))
        .map((p) => {
          const constName = p.full_permission
            .toUpperCase()
            .replace(/:/g, "_")
            .replace(/-/g, "_");
          return `  ${constName}: "${p.full_permission}",`;
        })
        .join("\n");

      return `  // ${domain.toUpperCase()} Domain\n${permLines}`;
    });

  return domainBlocks.join("\n\n");
}

// ============================================================================
// PRISMA SEED GENERATION
// ============================================================================

function generatePrismaSeed(
  schema: RBACSchema,
  result: GenerationResult
): string {
  log.section("🌱 Generating Prisma Seed");

  const timestamp = new Date().toISOString();

  let output = `/**
 * 🌱 RBAC Seed Data - AUTO-GENERATED
 * 
 * Generated: ${timestamp}
 * Phase: Phase 1 - Internal Members Only
 * Source: rbac_schema_v9.0.yml
 * Generator: rbac-generator-v9.0.ts
 * 
 * ⚠️  DO NOT EDIT THIS FILE MANUALLY
 * Regenerate using: npx tsx rbac-generator-v9.0.ts
 * 
 * This seed file creates:
 * 1. All permissions from the catalog
 * 2. All Phase 1 roles (5 internal roles)
 * 3. Role-Permission grants (baseline only)
 * 
 * Note: Critical PM permissions are cataloged but NOT granted by default
 */

import { PrismaClient } from "@prisma/client";
import { v7 as uuidv7 } from "uuid";

const prisma = new PrismaClient();

// ============================================================================
// PERMISSION CATALOG - All Permissions
// ============================================================================

const PERMISSIONS = [
${result.permissions.map((p) => `  "${p.full_permission}",`).join("\n")}
];

// ============================================================================
// ROLES - Phase 1 Internal Members
// ============================================================================

const ROLES = [
${result.roles
  .map(
    (r) => `  {
    code: "${r.code}",
    hierarchy: ${r.hierarchy},
    displayName: "${r.display_name}",
    description: "${r.description}",
    roleType: "${r.role_type}",
  },`
  )
  .join("\n")}
];

// ============================================================================
// ROLE PERMISSIONS - Baseline Grants
// ============================================================================

const ROLE_PERMISSIONS: Record<string, string[]> = {
${Object.entries(result.rolePermissions)
  .map(
    ([role, perms]) =>
      `  ${role}: [\n${perms.map((p) => `    "${p}",`).join("\n")}\n  ],`
  )
  .join("\n")}
};

// ============================================================================
// SEED EXECUTION
// ============================================================================

async function seedRBAC() {
  console.log("🌱 Starting RBAC seed...");

  try {
    // Step 1: Create all permissions
    console.log("\\n📝 Creating permissions...");
    let permissionCount = 0;

    for (const permissionCode of PERMISSIONS) {
      await prisma.permission.upsert({
        where: { permissionCode },
        update: {},
        create: {
          id: uuidv7(),
          permissionCode,
          description: \`Permission for \${permissionCode}\`,
          isActive: true,
        },
      });
      permissionCount++;
    }

    console.log(\`✅ Created/verified \${permissionCount} permissions\`);

    // Step 2: Create all roles
    console.log("\\n👥 Creating roles...");
    let roleCount = 0;

    for (const role of ROLES) {
      await prisma.role.upsert({
        where: { roleCode: role.code },
        update: {
          hierarchy: role.hierarchy,
          displayName: role.displayName,
          description: role.description,
          roleType: role.roleType,
        },
        create: {
          id: uuidv7(),
          roleCode: role.code,
          hierarchy: role.hierarchy,
          displayName: role.displayName,
          description: role.description,
          roleType: role.roleType,
          isActive: true,
        },
      });
      roleCount++;
    }

    console.log(\`✅ Created/verified \${roleCount} roles\`);

    // Step 3: Create role-permission grants
    console.log("\\n🔗 Creating role-permission grants...");
    let grantCount = 0;

    for (const [roleCode, permissions] of Object.entries(ROLE_PERMISSIONS)) {
      // Get role
      const role = await prisma.role.findUnique({
        where: { roleCode },
      });

      if (!role) {
        console.error(\`❌ Role not found: \${roleCode}\`);
        continue;
      }

      // Delete existing grants for this role (idempotent seed)
      await prisma.rolePermission.deleteMany({
        where: { roleId: role.id },
      });

      // Create new grants
      for (const permissionCode of permissions) {
        const permission = await prisma.permission.findUnique({
          where: { permissionCode },
        });

        if (!permission) {
          console.error(\`❌ Permission not found: \${permissionCode}\`);
          continue;
        }

        await prisma.rolePermission.create({
          data: {
            id: uuidv7(),
            roleId: role.id,
            permissionId: permission.id,
          },
        });
        grantCount++;
      }

      console.log(\`  \${roleCode}: \${permissions.length} permissions granted\`);
    }

    console.log(\`\\n✅ Created \${grantCount} role-permission grants\`);

    // Summary
    console.log("\\n" + "=".repeat(70));
    console.log("📊 RBAC Seed Summary");
    console.log("=".repeat(70));
    console.log(\`Permissions: \${permissionCount}\`);
    console.log(\`Roles: \${roleCount}\`);
    console.log(\`Role-Permission Grants: \${grantCount}\`);
    console.log(\`Phase: PHASE_1_INTERNAL_MEMBERS\`);
    console.log("=".repeat(70));
    console.log("\\n✅ RBAC seed completed successfully!\\n");
  } catch (error) {
    console.error("\\n❌ RBAC seed failed:", error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

// Execute seed
seedRBAC()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
`;

  log.success("Prisma seed generated");
  return output;
}

// ============================================================================
// FILE WRITING
// ============================================================================

function writeGeneratedFiles(
  outputDir: string,
  constantsContent: string,
  seedContent: string
) {
  log.section("💾 Writing Generated Files");

  // Create output directory
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
    log.info(`Created output directory: ${outputDir}`);
  }

  // Write TypeScript constants
  const constantsPath = path.join(outputDir, "rbac-constants.ts");
  fs.writeFileSync(constantsPath, constantsContent, "utf8");
  log.success(`Wrote: ${constantsPath}`);

  // Write Prisma seed
  const seedPath = path.join(outputDir, "rbac-seed.ts");
  fs.writeFileSync(seedPath, seedContent, "utf8");
  log.success(`Wrote: ${seedPath}`);

  log.info(`\nGenerated files written to: ${outputDir}`);
}

// ============================================================================
// MAIN EXECUTION
// ============================================================================

async function main() {
  log.section("🏛️ BeeSmart Pro RBAC Generator v9.0");
  log.info("Phase 1 - Internal Members Only");
  log.info(`Source: rbac_permissions_v3.md`);

  try {
    // Load schema
    const schema = loadSchema(options.schema);

    // Validate schema
    const isValid = validateSchema(schema);
    if (!isValid) {
      log.error("Schema validation failed. Aborting generation.");
      process.exit(1);
    }

    if (options.validateOnly) {
      log.success("Validation complete. Exiting (--validate-only mode)");
      return;
    }

    // Process permissions
    const permissions = processPermissions(schema);

    // Process roles
    const rolePermissions = processRoles(schema);

    // Extract critical permissions
    const criticalPermissions: string[] = [];
    if (schema.critical_permissions) {
      const crit = schema.critical_permissions.PROJECT_MANAGER_ELEVATED;
      criticalPermissions.push(
        ...crit.approvals.map((p) => p.permission),
        ...crit.deletes.map((p) => p.permission),
        ...crit.financial_visibility.map((p) => p.permission)
      );
    }

    // Build result
    const result: GenerationResult = {
      permissions,
      roles: schema.roles,
      rolePermissions,
      criticalPermissions,
      validation: {
        total_permissions: permissions.length,
        total_roles: schema.roles.length,
        permissions_per_role: Object.fromEntries(
          Object.entries(rolePermissions).map(([role, perms]) => [
            role,
            perms.length,
          ])
        ),
        hierarchy_valid: true,
        naming_valid: true,
        critical_permissions_count: criticalPermissions.length,
      },
    };

    // Generate TypeScript constants
    const constantsContent = generateTypeScriptConstants(result);

    // Generate Prisma seed
    const seedContent = generatePrismaSeed(schema, result);

    // Write files
    writeGeneratedFiles(options.outputDir, constantsContent, seedContent);

    // Final summary
    log.section("✅ Generation Complete");
    log.success(`Total Permissions: ${result.validation.total_permissions}`);
    log.success(`Total Roles: ${result.validation.total_roles}`);
    log.success(`Critical Permissions (PM): ${result.validation.critical_permissions_count}`);
    log.info(`\nFiles generated in: ${options.outputDir}`);
    log.info("Next steps:");
    log.info("  1. Review generated files");
    log.info("  2. Run: npx tsx generated/rbac-seed.ts");
    log.info("  3. Import RBAC constants in your services");
    log.info("  4. Implement TenantSettings checks for PM critical permissions");
  } catch (error) {
    log.error(`Generation failed: ${error}`);
    process.exit(1);
  }
}

// Execute
main();
