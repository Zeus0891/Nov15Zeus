#!/usr/bin/env node

/**
 * 🏛️ RBAC Generator v8.3 - Phase 1 Clean Implementation
 * BeeSmart Pro Construction ERP
 *
 * PHASE 1 UPDATES:
 * ✅ 5 internal roles only (ADMIN, PROJECT_MANAGER, WORKER, DRIVER, VIEWER)
 * ✅ Baseline vs critical permissions separation
 * ✅ Clean TypeScript constants generation
 * ✅ Prisma seed data for Phase 1 roles only
 * ✅ Validation report with Phase 1 metrics
 * ✅ CLI interface for easy usage
 */

import * as fs from "fs";
import * as yaml from "js-yaml";
import * as path from "path";

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

interface RBACSchema {
  rbac_version: string;
  generated_date: string;
  compatibility: string;
  description: string;
  security_configuration: {
    role_hierarchy_convention: string;
    hierarchy_range: string;
    permission_strategy: string;
    total_permissions: number;
    naming_convention: string;
    security_layers: string[];
    phase1_focus: {
      internal_roles: number;
      baseline_permissions: string;
      critical_permissions: string;
      external_roles: string;
    };
  };
  domains: Array<{
    key: string;
    description: string;
  }>;
  roles: Array<{
    code: string;
    hierarchy: number;
    display_name: string;
    description: string;
    role_type: "INTERNAL" | "EXTERNAL";
    phase1_status: "ACTIVE" | "PRESERVED";
    business_context?: {
      typical_users?: string[];
      access_scope?: string;
      use_cases?: string[];
      financial_scope?: string;
      critical_note?: string;
      enforcement_critical?: string;
    };
  }>;
  permissions: Record<string, string[]>;
  role_grants: Record<string, { permissions: string[] }>;
  critical_permissions?: {
    description: string;
    approvals: string[];
    financial_insights: string[];
    administrative: string[];
    tenant_settings_flags: string[];
  };
  validation: {
    total_roles: number;
    active_internal_roles: number;
    external_roles: number;
    total_permissions: number;
    baseline_permissions: number;
    critical_permissions: number;
    permission_format: string;
    hierarchy_range: string;
    yaml_valid: boolean;
    phase1_ready: boolean;
  };
}

interface ValidationResult {
  isValid: boolean;
  errors: string[];
  warnings: string[];
  metrics: {
    totalRoles: number;
    activeInternalRoles: number;
    externalRoles: number;
    totalPermissions: number;
    baselinePermissions: number;
    criticalPermissions: number;
    orphanedPermissions: number;
    rolesWithoutPermissions: number;
  };
}

// ============================================================================
// RBAC GENERATOR CLASS
// ============================================================================

export class RBACGeneratorV83 {
  private schema: RBACSchema | null = null;
  private schemaPath: string;
  private outputDir: string;

  constructor(
    schemaPath: string = "./rbac.schema.v8.3.yml",
    outputDir: string = "./generated"
  ) {
    this.schemaPath = schemaPath;
    this.outputDir = outputDir;
  }

  /**
   * Load and validate RBAC schema
   */
  async loadSchema(): Promise<void> {
    try {
      const schemaContent = fs.readFileSync(this.schemaPath, "utf8");
      this.schema = yaml.load(schemaContent) as RBACSchema;

      if (!this.schema) {
        throw new Error("Failed to parse RBAC schema");
      }

      console.log(`✅ Loaded RBAC schema v${this.schema.rbac_version}`);
      console.log(
        `📊 ${this.schema.validation.active_internal_roles} active internal roles, ${this.schema.validation.total_permissions} permissions`
      );
    } catch (error) {
      throw new Error(
        `Failed to load schema: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }

  /**
   * Validate schema structure and business rules
   */
  validateSchema(): ValidationResult {
    if (!this.schema) {
      return {
        isValid: false,
        errors: ["Schema not loaded"],
        warnings: [],
        metrics: this.getEmptyMetrics(),
      };
    }

    const errors: string[] = [];
    const warnings: string[] = [];

    // Validate Phase 1 requirements
    const activeInternalRoles = this.schema.roles.filter(
      (role) => role.role_type === "INTERNAL" && role.phase1_status === "ACTIVE"
    );

    if (activeInternalRoles.length !== 5) {
      errors.push(
        `Expected 5 active internal roles, found ${activeInternalRoles.length}`
      );
    }

    const expectedRoles = [
      "ADMIN",
      "PROJECT_MANAGER",
      "WORKER",
      "DRIVER",
      "VIEWER",
    ];
    const actualRoles = activeInternalRoles.map((role) => role.code);
    const missingRoles = expectedRoles.filter(
      (role) => !actualRoles.includes(role)
    );

    if (missingRoles.length > 0) {
      errors.push(`Missing required roles: ${missingRoles.join(", ")}`);
    }

    // Validate role hierarchy
    const hierarchyErrors = this.validateRoleHierarchy();
    errors.push(...hierarchyErrors);

    // Validate permissions format
    const permissionErrors = this.validatePermissionFormat();
    errors.push(...permissionErrors);

    // Validate role grants
    const grantErrors = this.validateRoleGrants();
    errors.push(...grantErrors);

    // Generate metrics
    const metrics = this.calculateMetrics();

    // Phase 1 specific validations
    if (this.schema.security_configuration.phase1_focus.internal_roles !== 5) {
      warnings.push("Phase 1 focus should be 5 internal roles");
    }

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
      metrics,
    };
  }

  /**
   * Generate TypeScript constants
   */
  generateTypeScriptConstants(): string {
    if (!this.schema) {
      throw new Error("Schema not loaded");
    }

    const activeInternalRoles = this.schema.roles.filter(
      (role) => role.role_type === "INTERNAL" && role.phase1_status === "ACTIVE"
    );

    const allRoles = this.schema.roles;
    const allPermissions = this.getAllPermissions();

    const constants = `/**
 * 🏛️ RBAC Constants v8.3 - Phase 1 Generated
 * BeeSmart Pro Construction ERP
 *
 * Generated from: rbac.schema.v8.3.yml
 * Generated on: ${new Date().toISOString()}
 *
 * PHASE 1 SCOPE:
 * - ${activeInternalRoles.length} active internal roles
 * - ${allRoles.length} total roles (including external)
 * - ${allPermissions.length} total permissions
 * - Baseline permissions only (critical permissions via TenantSettings)
 */

// ============================================================================
// ROLE ENUMS
// ============================================================================

/**
 * Phase 1 Active Internal Roles
 */
export enum ActiveInternalRole {
${activeInternalRoles
  .map((role) => `  ${role.code} = '${role.code}',`)
  .join("\n")}
}

/**
 * All Roles (Internal + External)
 */
export enum RoleType {
${allRoles.map((role) => `  ${role.code} = '${role.code}',`).join("\n")}
}

/**
 * Role Type Categories
 */
export enum RoleCategory {
  INTERNAL = 'INTERNAL',
  EXTERNAL = 'EXTERNAL',
}

/**
 * Phase 1 Status
 */
export enum Phase1Status {
  ACTIVE = 'ACTIVE',
  PRESERVED = 'PRESERVED',
}

// ============================================================================
// PERMISSION ENUMS
// ============================================================================

/**
 * All System Permissions
 */
export enum Permission {
${allPermissions
  .map(
    (permission) =>
      `  ${this.permissionToEnumName(permission)} = '${permission}',`
  )
  .join("\n")}
}

/**
 * Permission Domains
 */
export enum Domain {
${this.schema.domains
  .map((domain) => `  ${domain.key.toUpperCase()} = '${domain.key}',`)
  .join("\n")}
}

// ============================================================================
// ROLE HIERARCHY MAP
// ============================================================================

/**
 * Role Hierarchy (0 = highest privilege)
 */
export const ROLE_HIERARCHY: Record<RoleType, number> = {
${allRoles
  .map((role) => `  [RoleType.${role.code}]: ${role.hierarchy},`)
  .join("\n")}
};

/**
 * Active Internal Role Hierarchy
 */
export const ACTIVE_INTERNAL_ROLE_HIERARCHY: Record<ActiveInternalRole, number> = {
${activeInternalRoles
  .map((role) => `  [ActiveInternalRole.${role.code}]: ${role.hierarchy},`)
  .join("\n")}
};

// ============================================================================
// ROLE METADATA
// ============================================================================

export interface RoleMetadata {
  code: string;
  hierarchy: number;
  display_name: string;
  description: string;
  role_type: RoleCategory;
  phase1_status: Phase1Status;
  business_context?: {
    typical_users?: string[];
    access_scope?: string;
    use_cases?: string[];
    financial_scope?: string;
  };
}

/**
 * Complete Role Metadata
 */
export const ROLE_METADATA: Record<RoleType, RoleMetadata> = {
${allRoles
  .map(
    (role) =>
      `  [RoleType.${role.code}]: ${JSON.stringify(
        {
          code: role.code,
          hierarchy: role.hierarchy,
          display_name: role.display_name,
          description: role.description,
          role_type: role.role_type,
          phase1_status: role.phase1_status,
          business_context: role.business_context,
        },
        null,
        4
      ).replace(/\n/g, "\n    ")},`
  )
  .join("\n")}
};

// ============================================================================
// ROLE PERMISSIONS MAP
// ============================================================================

/**
 * Role Permissions (Baseline Only)
 */
export const ROLE_PERMISSIONS: Record<string, Permission[]> = {
${Object.entries(this.schema.role_grants)
  .map(
    ([role, grants]) =>
      `  '${role}': [\n${grants.permissions
        .map(
          (permission) =>
            `    Permission.${this.permissionToEnumName(permission)},`
        )
        .join("\n")}\n  ],`
  )
  .join("\n")}
};

// ============================================================================
// CRITICAL PERMISSIONS
// ============================================================================

/**
 * Critical Permissions (NOT granted by default to PROJECT_MANAGER)
 */
export const CRITICAL_PERMISSIONS = {
  APPROVALS: [
${
  this.schema.critical_permissions?.approvals
    .map(
      (permission) => `    Permission.${this.permissionToEnumName(permission)},`
    )
    .join("\n") || ""
}
  ],
  FINANCIAL_INSIGHTS: [
${
  this.schema.critical_permissions?.financial_insights
    .map(
      (permission) => `    Permission.${this.permissionToEnumName(permission)},`
    )
    .join("\n") || ""
}
  ],
  ADMINISTRATIVE: [
${
  this.schema.critical_permissions?.administrative
    .map(
      (permission) => `    Permission.${this.permissionToEnumName(permission)},`
    )
    .join("\n") || ""
}
  ],
};

/**
 * TenantSettings Flags for Critical Permissions
 */
export const TENANT_SETTINGS_FLAGS = [
${
  this.schema.critical_permissions?.tenant_settings_flags
    .map((flag) => `  '${flag}',`)
    .join("\n") || ""
}
];

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/**
 * Check if role has permission (baseline only)
 */
export function hasPermission(role: RoleType, permission: Permission): boolean {
  const rolePermissions = ROLE_PERMISSIONS[role] || [];
  return rolePermissions.includes(permission);
}

/**
 * Get role hierarchy level
 */
export function getRoleHierarchy(role: RoleType): number {
  return ROLE_HIERARCHY[role] || 10; // Default to lowest privilege
}

/**
 * Check if role is higher in hierarchy (lower number = higher privilege)
 */
export function isHigherRole(role1: RoleType, role2: RoleType): boolean {
  return getRoleHierarchy(role1) < getRoleHierarchy(role2);
}

/**
 * Get all permissions for a role
 */
export function getRolePermissions(role: RoleType): Permission[] {
  return ROLE_PERMISSIONS[role] || [];
}

/**
 * Check if role is active in Phase 1
 */
export function isActiveInternalRole(role: RoleType): boolean {
  const metadata = ROLE_METADATA[role];
  return metadata?.role_type === RoleCategory.INTERNAL && metadata?.phase1_status === Phase1Status.ACTIVE;
}

/**
 * Get active internal roles only
 */
export function getActiveInternalRoles(): RoleType[] {
  return Object.values(RoleType).filter(isActiveInternalRole);
}

// ============================================================================
// CONSTANTS SUMMARY
// ============================================================================

export const RBAC_SUMMARY = {
  VERSION: '${this.schema.rbac_version}',
  GENERATED_DATE: '${new Date().toISOString()}',
  TOTAL_ROLES: ${allRoles.length},
  ACTIVE_INTERNAL_ROLES: ${activeInternalRoles.length},
  EXTERNAL_ROLES: ${allRoles.filter((r) => r.role_type === "EXTERNAL").length},
  TOTAL_PERMISSIONS: ${allPermissions.length},
  BASELINE_PERMISSIONS: ${this.schema.validation.baseline_permissions},
  CRITICAL_PERMISSIONS: ${this.schema.validation.critical_permissions},
  PHASE1_READY: ${this.schema.validation.phase1_ready},
};

export default {
  ActiveInternalRole,
  RoleType,
  RoleCategory,
  Phase1Status,
  Permission,
  Domain,
  ROLE_HIERARCHY,
  ACTIVE_INTERNAL_ROLE_HIERARCHY,
  ROLE_METADATA,
  ROLE_PERMISSIONS,
  CRITICAL_PERMISSIONS,
  TENANT_SETTINGS_FLAGS,
  hasPermission,
  getRoleHierarchy,
  isHigherRole,
  getRolePermissions,
  isActiveInternalRole,
  getActiveInternalRoles,
  RBAC_SUMMARY,
};
`;

    return constants;
  }

  /**
   * Generate Prisma seed data
   */
  generatePrismaSeed(): string {
    if (!this.schema) {
      throw new Error("Schema not loaded");
    }

    const activeInternalRoles = this.schema.roles.filter(
      (role) => role.role_type === "INTERNAL" && role.phase1_status === "ACTIVE"
    );

    const allRoles = this.schema.roles;
    const allPermissions = this.getAllPermissions();

    const seed = `/**
 * 🏛️ RBAC Prisma Seed v8.3 - Phase 1 Generated
 * BeeSmart Pro Construction ERP
 *
 * Generated from: rbac.schema.v8.3.yml
 * Generated on: ${new Date().toISOString()}
 *
 * PHASE 1 SEED DATA:
 * - ${activeInternalRoles.length} active internal roles
 * - ${allRoles.length} total roles
 * - ${allPermissions.length} permissions
 * - Baseline permissions only
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// ============================================================================
// ROLE SEED DATA
// ============================================================================

export const roleSeeds = [
${allRoles
  .map(
    (role) => `  {
    code: '${role.code}',
    name: '${role.display_name}',
    description: '${role.description}',
    hierarchy: ${role.hierarchy},
    roleType: '${role.role_type}',
    isActive: ${role.phase1_status === "ACTIVE"},
    phase1Status: '${role.phase1_status}',
    businessContext: ${JSON.stringify(
      role.business_context || {},
      null,
      6
    ).replace(/\n/g, "\n    ")},
  },`
  )
  .join("\n")}
];

// ============================================================================
// PERMISSION SEED DATA
// ============================================================================

export const permissionSeeds = [
${allPermissions
  .map((permission) => {
    const [domain, action, subaction] = permission.split(":");
    return `  {
    code: '${permission}',
    domain: '${domain}',
    action: '${action}',
    subaction: ${subaction ? `'${subaction}'` : "null"},
    description: '${this.getPermissionDescription(permission)}',
    isBaseline: ${this.isBaselinePermission(permission)},
    isCritical: ${this.isCriticalPermission(permission)},
  },`;
  })
  .join("\n")}
];

// ============================================================================
// ROLE PERMISSION GRANTS (Baseline Only)
// ============================================================================

export const rolePermissionSeeds = [
${Object.entries(this.schema.role_grants)
  .flatMap(([roleCode, grants]) =>
    grants.permissions.map(
      (permission) =>
        `  { roleCode: '${roleCode}', permissionCode: '${permission}', isBaseline: true },`
    )
  )
  .join("\n")}
];

// ============================================================================
// DOMAIN SEED DATA
// ============================================================================

export const domainSeeds = [
${this.schema.domains
  .map(
    (domain) => `  {
    code: '${domain.key}',
    name: '${domain.key.charAt(0).toUpperCase() + domain.key.slice(1)}',
    description: '${domain.description}',
  },`
  )
  .join("\n")}
];

// ============================================================================
// SEED EXECUTION FUNCTIONS
// ============================================================================

/**
 * Seed roles
 */
export async function seedRoles() {
  console.log('🔄 Seeding roles...');

  for (const roleData of roleSeeds) {
    await prisma.role.upsert({
      where: { code: roleData.code },
      update: {
        name: roleData.name,
        description: roleData.description,
        hierarchy: roleData.hierarchy,
        roleType: roleData.roleType,
        isActive: roleData.isActive,
      },
      create: roleData,
    });
  }

  console.log(\`✅ Seeded \${roleSeeds.length} roles\`);
}

/**
 * Seed permissions
 */
export async function seedPermissions() {
  console.log('🔄 Seeding permissions...');

  for (const permissionData of permissionSeeds) {
    await prisma.permission.upsert({
      where: { code: permissionData.code },
      update: {
        domain: permissionData.domain,
        action: permissionData.action,
        subaction: permissionData.subaction,
        description: permissionData.description,
        isBaseline: permissionData.isBaseline,
        isCritical: permissionData.isCritical,
      },
      create: permissionData,
    });
  }

  console.log(\`✅ Seeded \${permissionSeeds.length} permissions\`);
}

/**
 * Seed domains
 */
export async function seedDomains() {
  console.log('🔄 Seeding domains...');

  for (const domainData of domainSeeds) {
    await prisma.domain.upsert({
      where: { code: domainData.code },
      update: {
        name: domainData.name,
        description: domainData.description,
      },
      create: domainData,
    });
  }

  console.log(\`✅ Seeded \${domainSeeds.length} domains\`);
}

/**
 * Seed role permissions (baseline only)
 */
export async function seedRolePermissions() {
  console.log('🔄 Seeding role permissions...');

  // Clear existing role permissions
  await prisma.rolePermission.deleteMany({});

  for (const rpData of rolePermissionSeeds) {
    await prisma.rolePermission.create({
      data: {
        role: { connect: { code: rpData.roleCode } },
        permission: { connect: { code: rpData.permissionCode } },
        isBaseline: rpData.isBaseline,
      },
    });
  }

  console.log(\`✅ Seeded \${rolePermissionSeeds.length} role permissions\`);
}

/**
 * Main seed function
 */
export async function seedRBAC() {
  try {
    console.log('🚀 Starting RBAC Phase 1 seed...');

    await seedDomains();
    await seedRoles();
    await seedPermissions();
    await seedRolePermissions();

    console.log('✅ RBAC Phase 1 seed completed successfully!');
    console.log(\`📊 Summary: \${roleSeeds.length} roles, \${permissionSeeds.length} permissions, \${rolePermissionSeeds.length} grants\`);

  } catch (error) {
    console.error('❌ RBAC seed failed:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

// Run seed if called directly
if (require.main === module) {
  seedRBAC().catch(console.error);
}

export default {
  roleSeeds,
  permissionSeeds,
  rolePermissionSeeds,
  domainSeeds,
  seedRoles,
  seedPermissions,
  seedDomains,
  seedRolePermissions,
  seedRBAC,
};
`;

    return seed;
  }

  /**
   * Generate validation report
   */
  generateValidationReport(): string {
    if (!this.schema) {
      throw new Error("Schema not loaded");
    }

    const validation = this.validateSchema();
    const allPermissions = this.getAllPermissions();

    const report = `# 🏛️ RBAC Validation Report v8.3 - Phase 1

**Generated**: ${new Date().toISOString()}
**Schema Version**: ${this.schema.rbac_version}
**Status**: ${validation.isValid ? "✅ VALID" : "❌ INVALID"}

## 📊 Phase 1 Metrics

| Metric | Value | Target | Status |
|--------|-------|---------|---------|
| **Active Internal Roles** | ${validation.metrics.activeInternalRoles} | 5 | ${
      validation.metrics.activeInternalRoles === 5 ? "✅" : "❌"
    } |
| **Total Roles** | ${validation.metrics.totalRoles} | 10 | ${
      validation.metrics.totalRoles === 10 ? "✅" : "❌"
    } |
| **External Roles** | ${validation.metrics.externalRoles} | 5 | ${
      validation.metrics.externalRoles === 5 ? "✅" : "❌"
    } |
| **Total Permissions** | ${validation.metrics.totalPermissions} | 145 | ${
      validation.metrics.totalPermissions >= 140 ? "✅" : "❌"
    } |
| **Baseline Permissions** | ${
      validation.metrics.baselinePermissions
    } | ~120 | ${validation.metrics.baselinePermissions >= 100 ? "✅" : "❌"} |
| **Critical Permissions** | ${
      validation.metrics.criticalPermissions
    } | ~25 | ${validation.metrics.criticalPermissions >= 10 ? "✅" : "❌"} |
| **Orphaned Permissions** | ${validation.metrics.orphanedPermissions} | 0 | ${
      validation.metrics.orphanedPermissions === 0 ? "✅" : "❌"
    } |

## 🎯 Phase 1 Active Internal Roles

${this.schema.roles
  .filter(
    (role) => role.role_type === "INTERNAL" && role.phase1_status === "ACTIVE"
  )
  .map(
    (role) =>
      `### ${role.code} (Hierarchy: ${role.hierarchy})
- **Display Name**: ${role.display_name}
- **Description**: ${role.description}
- **Permissions**: ${
        this.schema!.role_grants[role.code]?.permissions.length || 0
      }
- **Access Scope**: ${role.business_context?.access_scope || "Not specified"}
- **Financial Scope**: ${
        role.business_context?.financial_scope || "Not specified"
      }
`
  )
  .join("\n")}

## 📋 Permission Summary by Domain

${this.schema.domains
  .map((domain) => {
    const domainPermissions = allPermissions.filter((p) =>
      p.startsWith(domain.key + ":")
    );
    return `### ${domain.key.toUpperCase()} Domain
- **Total Permissions**: ${domainPermissions.length}
- **Description**: ${domain.description}
- **Permissions**: ${domainPermissions.join(", ")}
`;
  })
  .join("\n")}

## 🔒 Critical Permissions (NOT Granted by Default)

### Approval Permissions
${
  this.schema.critical_permissions?.approvals.map((p) => `- ${p}`).join("\n") ||
  "None defined"
}

### Financial Insight Permissions
${
  this.schema.critical_permissions?.financial_insights
    .map((p) => `- ${p}`)
    .join("\n") || "None defined"
}

### Administrative Permissions
${
  this.schema.critical_permissions?.administrative
    .map((p) => `- ${p}`)
    .join("\n") || "None defined"
}

### TenantSettings Flags
${
  this.schema.critical_permissions?.tenant_settings_flags
    .map((flag) => `- ${flag}`)
    .join("\n") || "None defined"
}

## ⚠️ Validation Results

${
  validation.errors.length > 0
    ? `### ❌ Errors (${validation.errors.length})
${validation.errors.map((error) => `- ${error}`).join("\n")}`
    : "### ✅ No Errors Found"
}

${
  validation.warnings.length > 0
    ? `### ⚠️ Warnings (${validation.warnings.length})
${validation.warnings.map((warning) => `- ${warning}`).join("\n")}`
    : "### ✅ No Warnings"
}

## 🚀 Phase 1 Readiness

- [${
      this.schema.validation.phase1_ready ? "x" : " "
    }] Schema marked as Phase 1 ready
- [${
      validation.metrics.activeInternalRoles === 5 ? "x" : " "
    }] Exactly 5 active internal roles
- [${
      validation.metrics.orphanedPermissions === 0 ? "x" : " "
    }] No orphaned permissions
- [${validation.isValid ? "x" : " "}] All validations passed
- [${
      validation.metrics.criticalPermissions > 0 ? "x" : " "
    }] Critical permissions defined

## 📈 Comparison with Previous Versions

| Version | Total Roles | Internal Roles | Permissions | Focus |
|---------|-------------|----------------|-------------|-------|
| v8.2 | 18 | 13 | 400+ | Enterprise Complete |
| v8.3-phase1 | ${validation.metrics.totalRoles} | ${
      validation.metrics.activeInternalRoles
    } | ${validation.metrics.totalPermissions} | Phase 1 Simplified |

## 🎯 Next Steps

1. **If Valid**: Generate TypeScript constants and Prisma seeds
2. **Update Generator**: Ensure rbac-generator-v8.3.ts is aligned
3. **Database Migration**: Update role table with Phase 1 roles only
4. **TenantSettings**: Implement critical permission toggles
5. **Testing**: Validate Phase 1 role permissions in application

---

**Generated by**: RBAC Generator v8.3
**Source Schema**: rbac.schema.v8.3.yml
**Validation**: ${validation.isValid ? "✅ PASSED" : "❌ FAILED"}
`;

    return report;
  }

  // ============================================================================
  // PRIVATE HELPER METHODS
  // ============================================================================

  private validateRoleHierarchy(): string[] {
    if (!this.schema) return [];

    const errors: string[] = [];

    for (const role of this.schema.roles) {
      if (role.hierarchy < 0 || role.hierarchy > 10) {
        errors.push(
          `Role ${role.code} has invalid hierarchy ${role.hierarchy} (must be 0-10)`
        );
      }
    }

    return errors;
  }

  private validatePermissionFormat(): string[] {
    if (!this.schema) return [];

    const errors: string[] = [];
    const allPermissions = this.getAllPermissions();

    for (const permission of allPermissions) {
      const parts = permission.split(":");
      if (parts.length < 2 || parts.length > 3) {
        errors.push(
          `Invalid permission format: ${permission} (expected domain:action[:subaction])`
        );
      }
    }

    return errors;
  }

  private validateRoleGrants(): string[] {
    if (!this.schema) return [];

    const errors: string[] = [];
    const allPermissions = this.getAllPermissions();

    for (const [roleCode, grants] of Object.entries(this.schema.role_grants)) {
      // Check if role exists
      const role = this.schema.roles.find((r) => r.code === roleCode);
      if (!role) {
        errors.push(`Role grant for non-existent role: ${roleCode}`);
        continue;
      }

      // Check if permissions exist
      for (const permission of grants.permissions) {
        if (!allPermissions.includes(permission)) {
          errors.push(
            `Role ${roleCode} has non-existent permission: ${permission}`
          );
        }
      }
    }

    return errors;
  }

  private calculateMetrics(): ValidationResult["metrics"] {
    if (!this.schema) return this.getEmptyMetrics();

    const totalRoles = this.schema.roles.length;
    const activeInternalRoles = this.schema.roles.filter(
      (role) => role.role_type === "INTERNAL" && role.phase1_status === "ACTIVE"
    ).length;
    const externalRoles = this.schema.roles.filter(
      (role) => role.role_type === "EXTERNAL"
    ).length;

    const allPermissions = this.getAllPermissions();
    const totalPermissions = allPermissions.length;

    const grantedPermissions = new Set(
      Object.values(this.schema.role_grants).flatMap(
        (grants) => grants.permissions
      )
    );
    const orphanedPermissions = allPermissions.filter(
      (p) => !grantedPermissions.has(p)
    ).length;

    const rolesWithoutPermissions = Object.keys(this.schema.role_grants).filter(
      (roleCode) => this.schema!.role_grants[roleCode].permissions.length === 0
    ).length;

    const baselinePermissions = this.schema.validation.baseline_permissions;
    const criticalPermissions = this.schema.validation.critical_permissions;

    return {
      totalRoles,
      activeInternalRoles,
      externalRoles,
      totalPermissions,
      baselinePermissions,
      criticalPermissions,
      orphanedPermissions,
      rolesWithoutPermissions,
    };
  }

  private getAllPermissions(): string[] {
    if (!this.schema) return [];

    return Object.values(this.schema.permissions).flat();
  }

  private getEmptyMetrics(): ValidationResult["metrics"] {
    return {
      totalRoles: 0,
      activeInternalRoles: 0,
      externalRoles: 0,
      totalPermissions: 0,
      baselinePermissions: 0,
      criticalPermissions: 0,
      orphanedPermissions: 0,
      rolesWithoutPermissions: 0,
    };
  }

  private permissionToEnumName(permission: string): string {
    return permission
      .replace(/:/g, "_")
      .replace(/[^a-zA-Z0-9_]/g, "_")
      .toUpperCase();
  }

  private getPermissionDescription(permission: string): string {
    const [domain, action, subaction] = permission.split(":");
    let description = `${action} ${domain}`;
    if (subaction) {
      description += ` (${subaction})`;
    }
    return description;
  }

  private isBaselinePermission(permission: string): boolean {
    if (!this.schema?.critical_permissions) return true;

    const criticalPermissions = [
      ...this.schema.critical_permissions.approvals,
      ...this.schema.critical_permissions.financial_insights,
      ...this.schema.critical_permissions.administrative,
    ];

    return !criticalPermissions.includes(permission);
  }

  private isCriticalPermission(permission: string): boolean {
    return !this.isBaselinePermission(permission);
  }

  // ============================================================================
  // PUBLIC API METHODS
  // ============================================================================

  /**
   * Generate all outputs
   */
  async generateAll(): Promise<void> {
    await this.loadSchema();

    const validation = this.validateSchema();
    if (!validation.isValid) {
      console.error("❌ Schema validation failed:");
      validation.errors.forEach((error) => console.error(`  - ${error}`));
      return;
    }

    // Ensure output directory exists
    if (!fs.existsSync(this.outputDir)) {
      fs.mkdirSync(this.outputDir, { recursive: true });
    }

    // Generate TypeScript constants
    const constants = this.generateTypeScriptConstants();
    fs.writeFileSync(path.join(this.outputDir, "rbac-constants.ts"), constants);
    console.log("✅ Generated rbac-constants.ts");

    // Generate Prisma seed
    const seed = this.generatePrismaSeed();
    fs.writeFileSync(path.join(this.outputDir, "rbac-seed.ts"), seed);
    console.log("✅ Generated rbac-seed.ts");

    // Generate validation report
    const report = this.generateValidationReport();
    fs.writeFileSync(
      path.join(this.outputDir, "rbac-validation-report.md"),
      report
    );
    console.log("✅ Generated rbac-validation-report.md");

    console.log("🎉 RBAC Phase 1 generation completed successfully!");
    console.log(
      `📊 Generated ${validation.metrics.activeInternalRoles} active roles with ${validation.metrics.totalPermissions} permissions`
    );
  }
}

// ============================================================================
// CLI INTERFACE
// ============================================================================

async function main() {
  const args = process.argv.slice(2);
  const command = args[0] || "generate";

  const schemaPath =
    args.find((arg) => arg.startsWith("--schema="))?.split("=")[1] ||
    "./rbac.schema.v8.3.yml";
  const outputDir =
    args.find((arg) => arg.startsWith("--output="))?.split("=")[1] ||
    "./generated";

  const generator = new RBACGeneratorV83(schemaPath, outputDir);

  try {
    switch (command) {
      case "generate":
      case "all":
        await generator.generateAll();
        break;

      case "validate":
        await generator.loadSchema();
        const validation = generator.validateSchema();
        console.log(
          validation.isValid ? "✅ Schema is valid" : "❌ Schema is invalid"
        );
        if (!validation.isValid) {
          validation.errors.forEach((error) => console.error(`  - ${error}`));
        }
        break;

      case "constants":
        await generator.loadSchema();
        const constants = generator.generateTypeScriptConstants();
        fs.writeFileSync(path.join(outputDir, "rbac-constants.ts"), constants);
        console.log("✅ Generated rbac-constants.ts");
        break;

      case "seed":
        await generator.loadSchema();
        const seed = generator.generatePrismaSeed();
        fs.writeFileSync(path.join(outputDir, "rbac-seed.ts"), seed);
        console.log("✅ Generated rbac-seed.ts");
        break;

      case "report":
        await generator.loadSchema();
        const report = generator.generateValidationReport();
        fs.writeFileSync(
          path.join(outputDir, "rbac-validation-report.md"),
          report
        );
        console.log("✅ Generated rbac-validation-report.md");
        break;

      case "help":
        console.log(`
🏛️ RBAC Generator v8.3 - Phase 1

Usage: node rbac-generator-v8.3.js [command] [options]

Commands:
  generate, all    Generate all outputs (default)
  validate         Validate schema only
  constants        Generate TypeScript constants only
  seed             Generate Prisma seed only
  report           Generate validation report only
  help             Show this help

Options:
  --schema=<path>  Path to schema file (default: ./rbac.schema.v8.3.yml)
  --output=<dir>   Output directory (default: ./generated)

Examples:
  node rbac-generator-v8.3.js
  node rbac-generator-v8.3.js validate
  node rbac-generator-v8.3.js generate --output=./src/rbac/generated
  node rbac-generator-v8.3.js constants --schema=./custom-schema.yml
        `);
        break;

      default:
        console.error(`❌ Unknown command: ${command}`);
        console.log(
          'Run "node rbac-generator-v8.3.js help" for usage information'
        );
        process.exit(1);
    }
  } catch (error) {
    console.error(
      "❌ Generation failed:",
      error instanceof Error ? error.message : String(error)
    );
    process.exit(1);
  }
}

// Run CLI if called directly
if (require.main === module) {
  main().catch(console.error);
}

export default RBACGeneratorV83;
