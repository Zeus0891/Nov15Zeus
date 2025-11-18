#!/usr/bin/env node

/**
 * 🏛️ Nov15Zeus RBAC Generator v8.2
 * Enterprise-grade RBAC code generation for Nov15Zeus ERP
 *
 * Features:
 * - TypeScript constant generation with type safety
 * - Prisma seed file generation
 * - Permission validation and expansion
 * - Role hierarchy validation
 * - Wildcard expansion for ADMIN role
 * - Integration with AccessPolicy + RLS hybrid model
 *
 * Usage:
 *   npx tsx RBAC/rbac-generator-v8.2.ts
 *   npx tsx RBAC/rbac-generator-v8.2.ts --validate-only
 *   npx tsx RBAC/rbac-generator-v8.2.ts --output-dir ./generated
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
  conventions_aligned: boolean;
  description: string;
  security_configuration: SecurityConfiguration;
  domains: Domain[];
  actions: string[];
  subactions: string[];
  roles: Role[];
  permissions: Record<string, string[]>;
  role_grants: Record<string, RoleGrant>;
  validation: ValidationConfig;
}

interface SecurityConfiguration {
  role_hierarchy_convention: string;
  hierarchy_range: string;
  permission_strategy: string;
  estimated_permissions: number;
  naming_convention: string;
  security_layers: string[];
  compliance_standards: string[];
}

interface Domain {
  key: string;
  description: string;
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
}

interface RoleGrant {
  permissions: string[];
  note?: string;
}

interface ValidationConfig {
  total_roles: number;
  total_permissions: number;
  permission_format: string;
  hierarchy_range: string;
  wildcard_usage: string;
  yaml_valid: boolean;
  production_ready: boolean;
}

interface ExpandedPermission {
  domain: string;
  action: string;
  subaction?: string;
  full_permission: string;
}

interface GenerationResult {
  permissions: ExpandedPermission[];
  roles: Role[];
  rolePermissions: Record<string, string[]>;
  validation: {
    totalPermissions: number;
    totalRoles: number;
    validationErrors: string[];
    warnings: string[];
  };
}

// ============================================================================
// RBAC GENERATOR CLASS
// ============================================================================

export class RBACGeneratorV82 {
  private schema: RBACSchema;
  private outputDir: string;
  private verbose: boolean;

  constructor(
    schemaPath: string,
    outputDir: string = "./generated",
    verbose: boolean = false
  ) {
    this.outputDir = outputDir;
    this.verbose = verbose;

    try {
      const schemaContent = fs.readFileSync(schemaPath, "utf8");
      this.schema = yaml.load(schemaContent) as RBACSchema;
      this.log(`✅ Loaded RBAC schema v${this.schema.rbac_version}`);
    } catch (error) {
      throw new Error(`Failed to load RBAC schema: ${error.message}`);
    }
  }

  /**
   * Main generation entry point
   */
  async generate(): Promise<GenerationResult> {
    this.log("🚀 Starting RBAC generation...");

    // 1. Validate schema
    const validation = this.validateSchema();
    if (validation.validationErrors.length > 0) {
      throw new Error(
        `Schema validation failed:\n${validation.validationErrors.join("\n")}`
      );
    }

    // 2. Expand permissions
    const expandedPermissions = this.expandPermissions();
    this.log(`📋 Expanded ${expandedPermissions.length} permissions`);

    // 3. Process roles and grants
    const processedRoles = this.processRoles();
    const rolePermissions = this.expandRolePermissions(expandedPermissions);
    this.log(`👥 Processed ${processedRoles.length} roles`);

    // 4. Generate output files
    await this.generateTypeScriptConstants(expandedPermissions, processedRoles);
    await this.generatePrismaSeed(
      expandedPermissions,
      processedRoles,
      rolePermissions
    );
    await this.generateValidationReport(
      expandedPermissions,
      processedRoles,
      validation
    );

    const result: GenerationResult = {
      permissions: expandedPermissions,
      roles: processedRoles,
      rolePermissions,
      validation: {
        totalPermissions: expandedPermissions.length,
        totalRoles: processedRoles.length,
        validationErrors: validation.validationErrors,
        warnings: validation.warnings,
      },
    };

    this.log("✅ RBAC generation completed successfully!");
    return result;
  }

  /**
   * Validate only (no generation)
   */
  validateOnly(): ValidationConfig {
    const validation = this.validateSchema();

    if (validation.validationErrors.length > 0) {
      console.error("❌ Schema validation failed:");
      validation.validationErrors.forEach((error) =>
        console.error(`  - ${error}`)
      );
      process.exit(1);
    }

    if (validation.warnings.length > 0) {
      console.warn("⚠️ Schema warnings:");
      validation.warnings.forEach((warning) => console.warn(`  - ${warning}`));
    }

    console.log("✅ Schema validation passed!");
    return this.schema.validation;
  }

  /**
   * Validate RBAC schema structure and content
   */
  private validateSchema(): { validationErrors: string[]; warnings: string[] } {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Check required fields
    if (!this.schema.rbac_version) errors.push("Missing rbac_version");
    if (!this.schema.domains || this.schema.domains.length === 0) {
      errors.push("Missing or empty domains array");
    }
    if (!this.schema.roles || this.schema.roles.length === 0) {
      errors.push("Missing or empty roles array");
    }
    if (!this.schema.permissions) errors.push("Missing permissions object");
    if (!this.schema.role_grants) errors.push("Missing role_grants object");

    // Validate naming convention
    const expectedFormat = "domain:action:subaction";
    if (
      this.schema.security_configuration?.naming_convention !== expectedFormat
    ) {
      errors.push(`Naming convention should be '${expectedFormat}'`);
    }

    // Validate role hierarchy
    const roles = this.schema.roles || [];
    const hierarchies = roles.map((r) => r.hierarchy);
    const minHierarchy = Math.min(...hierarchies);
    const maxHierarchy = Math.max(...hierarchies);

    if (minHierarchy !== 0) {
      errors.push("Role hierarchy should start at 0 (highest privilege)");
    }

    if (maxHierarchy > 10) {
      warnings.push(
        `Role hierarchy extends beyond 10 (current max: ${maxHierarchy})`
      );
    }

    // Validate unique role codes
    const roleCodes = roles.map((r) => r.code);
    const duplicateRoles = roleCodes.filter(
      (code, index) => roleCodes.indexOf(code) !== index
    );
    if (duplicateRoles.length > 0) {
      errors.push(`Duplicate role codes found: ${duplicateRoles.join(", ")}`);
    }

    // Validate permission format
    if (this.schema.permissions) {
      for (const [domain, perms] of Object.entries(this.schema.permissions)) {
        for (const perm of perms) {
          if (!this.isValidPermissionFormat(perm)) {
            errors.push(
              `Invalid permission format: ${perm} (expected domain:action or domain:action:subaction)`
            );
          }
        }
      }
    }

    // Validate role grants reference valid roles
    if (this.schema.role_grants) {
      for (const roleCode of Object.keys(this.schema.role_grants)) {
        if (!roleCodes.includes(roleCode)) {
          errors.push(`Role grant references unknown role: ${roleCode}`);
        }
      }
    }

    return { validationErrors: errors, warnings };
  }

  /**
   * Expand all permissions from domain definitions
   */
  private expandPermissions(): ExpandedPermission[] {
    const expanded: ExpandedPermission[] = [];

    if (!this.schema.permissions) return expanded;

    for (const [domain, permissions] of Object.entries(
      this.schema.permissions
    )) {
      for (const permission of permissions) {
        const parsed = this.parsePermission(permission);
        if (parsed) {
          expanded.push({
            domain: parsed.domain,
            action: parsed.action,
            subaction: parsed.subaction,
            full_permission: permission,
          });
        }
      }
    }

    return expanded.sort((a, b) =>
      a.full_permission.localeCompare(b.full_permission)
    );
  }

  /**
   * Process and validate roles
   */
  private processRoles(): Role[] {
    return this.schema.roles
      .sort((a, b) => a.hierarchy - b.hierarchy) // Sort by hierarchy (0 = highest)
      .map((role) => ({
        ...role,
        // Ensure required fields have defaults
        role_type: role.role_type || "INTERNAL",
        business_context: role.business_context || {
          typical_users: [],
          access_scope: "Unknown",
          use_cases: [],
        },
      }));
  }

  /**
   * Expand role permissions, handling wildcards for ADMIN
   */
  private expandRolePermissions(
    allPermissions: ExpandedPermission[]
  ): Record<string, string[]> {
    const rolePermissions: Record<string, string[]> = {};

    for (const [roleCode, grant] of Object.entries(this.schema.role_grants)) {
      const permissions: string[] = [];

      for (const permission of grant.permissions) {
        if (permission.includes("*")) {
          // Handle wildcards (only for ADMIN)
          if (roleCode === "ADMIN") {
            const wildcardExpanded = this.expandWildcard(
              permission,
              allPermissions
            );
            permissions.push(...wildcardExpanded);
          } else {
            console.warn(
              `⚠️ Wildcard permission '${permission}' found in non-ADMIN role '${roleCode}' - skipping`
            );
          }
        } else {
          // Regular permission
          if (this.isValidPermissionFormat(permission)) {
            permissions.push(permission);
          } else {
            console.warn(
              `⚠️ Invalid permission format '${permission}' in role '${roleCode}' - skipping`
            );
          }
        }
      }

      // Remove duplicates and sort
      rolePermissions[roleCode] = [...new Set(permissions)].sort();
    }

    return rolePermissions;
  }

  /**
   * Expand wildcard permissions (e.g., "crm:*" -> all CRM permissions)
   */
  private expandWildcard(
    wildcardPermission: string,
    allPermissions: ExpandedPermission[]
  ): string[] {
    const [domain, action] = wildcardPermission.split(":");

    if (action === "*") {
      // Domain wildcard: "crm:*"
      return allPermissions
        .filter((p) => p.domain === domain)
        .map((p) => p.full_permission);
    }

    // If it's just "*", return all permissions (ADMIN only)
    if (wildcardPermission === "*") {
      return allPermissions.map((p) => p.full_permission);
    }

    return [];
  }

  /**
   * Generate TypeScript constants file
   */
  private async generateTypeScriptConstants(
    permissions: ExpandedPermission[],
    roles: Role[]
  ): Promise<void> {
    const lines: string[] = [];

    // Header
    lines.push("/**");
    lines.push(" * 🏛️ Nov15Zeus RBAC Constants v8.2");
    lines.push(" * Generated from rbac.schema.v8.2.yml");
    lines.push(` * Generated: ${new Date().toISOString()}`);
    lines.push(" * ");
    lines.push(" * ⚠️ DO NOT EDIT - This file is auto-generated");
    lines.push(" * Update rbac.schema.v8.2.yml and regenerate instead");
    lines.push(" */");
    lines.push("");

    // Domains enum
    lines.push(
      "// ============================================================================"
    );
    lines.push("// DOMAINS");
    lines.push(
      "// ============================================================================"
    );
    lines.push("export const RBAC_DOMAINS = {");
    const domains = [...new Set(permissions.map((p) => p.domain))].sort();
    domains.forEach((domain) => {
      lines.push(`  ${domain.toUpperCase()}: '${domain}',`);
    });
    lines.push("} as const;");
    lines.push("");
    lines.push(
      "export type RBACDomain = typeof RBAC_DOMAINS[keyof typeof RBAC_DOMAINS];"
    );
    lines.push("");

    // Roles enum
    lines.push(
      "// ============================================================================"
    );
    lines.push("// ROLES");
    lines.push(
      "// ============================================================================"
    );
    lines.push("export const RBAC_ROLES = {");
    roles.forEach((role) => {
      lines.push(`  ${role.code}: '${role.code}',`);
    });
    lines.push("} as const;");
    lines.push("");
    lines.push(
      "export type RBACRole = typeof RBAC_ROLES[keyof typeof RBAC_ROLES];"
    );
    lines.push("");

    // Role hierarchy
    lines.push(
      "// ============================================================================"
    );
    lines.push("// ROLE HIERARCHY (0 = highest privilege)");
    lines.push(
      "// ============================================================================"
    );
    lines.push("export const RBAC_ROLE_HIERARCHY = {");
    roles.forEach((role) => {
      lines.push(`  ${role.code}: ${role.hierarchy},`);
    });
    lines.push("} as const;");
    lines.push("");

    // Role metadata
    lines.push(
      "// ============================================================================"
    );
    lines.push("// ROLE METADATA");
    lines.push(
      "// ============================================================================"
    );
    lines.push("export const RBAC_ROLE_METADATA = {");
    roles.forEach((role) => {
      lines.push(`  ${role.code}: {`);
      lines.push(`    code: '${role.code}',`);
      lines.push(`    hierarchy: ${role.hierarchy},`);
      lines.push(`    displayName: '${role.display_name}',`);
      lines.push(`    description: '${role.description}',`);
      lines.push(`    roleType: '${role.role_type}',`);
      lines.push(`    accessScope: '${role.business_context.access_scope}',`);
      lines.push(`  },`);
    });
    lines.push("} as const;");
    lines.push("");

    // Permissions enum
    lines.push(
      "// ============================================================================"
    );
    lines.push("// PERMISSIONS");
    lines.push(
      "// ============================================================================"
    );
    lines.push("export const RBAC_PERMISSIONS = {");
    permissions.forEach((perm) => {
      const constantName = perm.full_permission
        .toUpperCase()
        .replace(/:/g, "_");
      lines.push(`  ${constantName}: '${perm.full_permission}',`);
    });
    lines.push("} as const;");
    lines.push("");
    lines.push(
      "export type RBACPermission = typeof RBAC_PERMISSIONS[keyof typeof RBAC_PERMISSIONS];"
    );
    lines.push("");

    // Permission validation utility
    lines.push(
      "// ============================================================================"
    );
    lines.push("// UTILITY FUNCTIONS");
    lines.push(
      "// ============================================================================"
    );
    lines.push("");
    lines.push("/**");
    lines.push(
      " * Check if a role has higher or equal privilege than another role"
    );
    lines.push(" * (Lower hierarchy number = higher privilege)");
    lines.push(" */");
    lines.push("export function hasHigherOrEqualPrivilege(");
    lines.push("  userRole: RBACRole,");
    lines.push("  requiredRole: RBACRole");
    lines.push("): boolean {");
    lines.push("  const userHierarchy = RBAC_ROLE_HIERARCHY[userRole];");
    lines.push(
      "  const requiredHierarchy = RBAC_ROLE_HIERARCHY[requiredRole];"
    );
    lines.push("  return userHierarchy <= requiredHierarchy;");
    lines.push("}");
    lines.push("");

    lines.push("/**");
    lines.push(
      " * Validate permission format (domain:action or domain:action:subaction)"
    );
    lines.push(" */");
    lines.push(
      "export function isValidPermissionFormat(permission: string): boolean {"
    );
    lines.push("  const parts = permission.split(':');");
    lines.push(
      "  return parts.length >= 2 && parts.length <= 3 && parts.every(part => part.length > 0);"
    );
    lines.push("}");
    lines.push("");

    lines.push("/**");
    lines.push(" * Parse permission into components");
    lines.push(" */");
    lines.push("export function parsePermission(permission: string): {");
    lines.push("  domain: string;");
    lines.push("  action: string;");
    lines.push("  subaction?: string;");
    lines.push("} | null {");
    lines.push("  if (!isValidPermissionFormat(permission)) return null;");
    lines.push("  const [domain, action, subaction] = permission.split(':');");
    lines.push("  return { domain, action, subaction };");
    lines.push("}");
    lines.push("");

    // Statistics
    lines.push(
      "// ============================================================================"
    );
    lines.push("// SCHEMA STATISTICS");
    lines.push(
      "// ============================================================================"
    );
    lines.push("export const RBAC_STATS = {");
    lines.push(`  version: '${this.schema.rbac_version}',`);
    lines.push(`  generatedAt: '${new Date().toISOString()}',`);
    lines.push(`  totalDomains: ${domains.length},`);
    lines.push(`  totalRoles: ${roles.length},`);
    lines.push(`  totalPermissions: ${permissions.length},`);
    lines.push(
      `  hierarchyRange: '${this.schema.security_configuration.hierarchy_range}',`
    );
    lines.push(
      `  namingConvention: '${this.schema.security_configuration.naming_convention}',`
    );
    lines.push("} as const;");

    // Write file
    const outputPath = path.join(this.outputDir, "rbac-constants.ts");
    await this.ensureDirectoryExists(this.outputDir);
    fs.writeFileSync(outputPath, lines.join("\n"));
    this.log(`📝 Generated TypeScript constants: ${outputPath}`);
  }

  /**
   * Generate Prisma seed file
   */
  private async generatePrismaSeed(
    permissions: ExpandedPermission[],
    roles: Role[],
    rolePermissions: Record<string, string[]>
  ): Promise<void> {
    const lines: string[] = [];

    // Header
    lines.push("/**");
    lines.push(" * 🏛️ Nov15Zeus RBAC Prisma Seed v8.2");
    lines.push(" * Generated from rbac.schema.v8.2.yml");
    lines.push(` * Generated: ${new Date().toISOString()}`);
    lines.push(" * ");
    lines.push(" * ⚠️ DO NOT EDIT - This file is auto-generated");
    lines.push(" * Update rbac.schema.v8.2.yml and regenerate instead");
    lines.push(" */");
    lines.push("");
    lines.push("import { PrismaClient } from '@prisma/client';");
    lines.push("");
    lines.push("const prisma = new PrismaClient();");
    lines.push("");

    // Seed function
    lines.push("export async function seedRBACData() {");
    lines.push("  console.log('🌱 Seeding RBAC data...');");
    lines.push("");

    // Clean existing data
    lines.push("  // Clean existing RBAC data");
    lines.push("  await prisma.rolePermission.deleteMany({});");
    lines.push("  await prisma.permission.deleteMany({});");
    lines.push("  await prisma.role.deleteMany({});");
    lines.push("  console.log('🧹 Cleaned existing RBAC data');");
    lines.push("");

    // Create permissions
    lines.push("  // Create permissions");
    lines.push("  const permissions = await prisma.permission.createMany({");
    lines.push("    data: [");
    permissions.forEach((perm) => {
      lines.push("      {");
      lines.push(`        code: '${perm.full_permission}',`);
      lines.push(`        name: '${this.generatePermissionName(perm)}',`);
      lines.push(
        `        description: '${this.generatePermissionDescription(perm)}',`
      );
      lines.push(`        domain: '${perm.domain}',`);
      lines.push(`        action: '${perm.action}',`);
      if (perm.subaction) {
        lines.push(`        subaction: '${perm.subaction}',`);
      }
      lines.push("      },");
    });
    lines.push("    ],");
    lines.push("  });");
    lines.push(
      `  console.log('✅ Created ${permissions.length} permissions');`
    );
    lines.push("");

    // Create roles
    lines.push("  // Create roles");
    lines.push("  const roles = await prisma.role.createMany({");
    lines.push("    data: [");
    roles.forEach((role) => {
      lines.push("      {");
      lines.push(`        code: '${role.code}',`);
      lines.push(`        name: '${role.display_name}',`);
      lines.push(`        description: '${role.description}',`);
      lines.push(`        hierarchy: ${role.hierarchy},`);
      lines.push(`        roleType: '${role.role_type}',`);
      lines.push(
        `        accessScope: '${role.business_context.access_scope}',`
      );
      lines.push("        status: 'ACTIVE',");
      lines.push("      },");
    });
    lines.push("    ],");
    lines.push("  });");
    lines.push(`  console.log('✅ Created ${roles.length} roles');`);
    lines.push("");

    // Create role permissions
    lines.push("  // Create role permissions");
    lines.push("  const rolePermissionData = [];");
    lines.push("");
    for (const [roleCode, perms] of Object.entries(rolePermissions)) {
      lines.push(`  // ${roleCode} permissions`);
      perms.forEach((permission) => {
        lines.push("  rolePermissionData.push({");
        lines.push(`    roleCode: '${roleCode}',`);
        lines.push(`    permissionCode: '${permission}',`);
        lines.push("  });");
      });
      lines.push("");
    }

    lines.push("  await prisma.rolePermission.createMany({");
    lines.push("    data: rolePermissionData,");
    lines.push("  });");
    lines.push(`  console.log('✅ Created role-permission mappings');`);
    lines.push("");

    lines.push("  console.log('🎉 RBAC data seeded successfully!');");
    lines.push("}");
    lines.push("");

    // Main execution
    lines.push("// Execute if run directly");
    lines.push("if (require.main === module) {");
    lines.push("  seedRBACData()");
    lines.push("    .catch((e) => {");
    lines.push("      console.error('❌ Error seeding RBAC data:', e);");
    lines.push("      process.exit(1);");
    lines.push("    })");
    lines.push("    .finally(async () => {");
    lines.push("      await prisma.$disconnect();");
    lines.push("    });");
    lines.push("}");

    // Write file
    const outputPath = path.join(this.outputDir, "rbac-seed.ts");
    await this.ensureDirectoryExists(this.outputDir);
    fs.writeFileSync(outputPath, lines.join("\n"));
    this.log(`🌱 Generated Prisma seed: ${outputPath}`);
  }

  /**
   * Generate validation report
   */
  private async generateValidationReport(
    permissions: ExpandedPermission[],
    roles: Role[],
    validation: { validationErrors: string[]; warnings: string[] }
  ): Promise<void> {
    const lines: string[] = [];

    lines.push("# 📊 RBAC Schema Validation Report v8.2");
    lines.push("");
    lines.push(`**Generated**: ${new Date().toISOString()}`);
    lines.push(`**Schema Version**: ${this.schema.rbac_version}`);
    lines.push(
      `**Validation Status**: ${
        validation.validationErrors.length === 0 ? "✅ PASSED" : "❌ FAILED"
      }`
    );
    lines.push("");

    // Statistics
    lines.push("## 📈 Statistics");
    lines.push("");
    lines.push("| Metric | Count |");
    lines.push("|--------|-------|");
    lines.push(
      `| Total Domains | ${
        [...new Set(permissions.map((p) => p.domain))].length
      } |`
    );
    lines.push(`| Total Roles | ${roles.length} |`);
    lines.push(`| Total Permissions | ${permissions.length} |`);
    lines.push(
      `| Internal Roles | ${
        roles.filter((r) => r.role_type === "INTERNAL").length
      } |`
    );
    lines.push(
      `| External Roles | ${
        roles.filter((r) => r.role_type === "EXTERNAL").length
      } |`
    );
    lines.push(
      `| Hierarchy Range | ${Math.min(
        ...roles.map((r) => r.hierarchy)
      )}-${Math.max(...roles.map((r) => r.hierarchy))} |`
    );
    lines.push("");

    // Validation results
    if (validation.validationErrors.length > 0) {
      lines.push("## ❌ Validation Errors");
      lines.push("");
      validation.validationErrors.forEach((error) => {
        lines.push(`- ${error}`);
      });
      lines.push("");
    }

    if (validation.warnings.length > 0) {
      lines.push("## ⚠️ Warnings");
      lines.push("");
      validation.warnings.forEach((warning) => {
        lines.push(`- ${warning}`);
      });
      lines.push("");
    }

    // Domain breakdown
    lines.push("## 🏗️ Domain Breakdown");
    lines.push("");
    const domainCounts = permissions.reduce((acc, perm) => {
      acc[perm.domain] = (acc[perm.domain] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    lines.push("| Domain | Permissions |");
    lines.push("|--------|-------------|");
    Object.entries(domainCounts)
      .sort(([, a], [, b]) => b - a)
      .forEach(([domain, count]) => {
        lines.push(`| ${domain} | ${count} |`);
      });
    lines.push("");

    // Role hierarchy
    lines.push("## 👥 Role Hierarchy");
    lines.push("");
    lines.push("| Role | Hierarchy | Type | Description |");
    lines.push("|------|-----------|------|-------------|");
    roles
      .sort((a, b) => a.hierarchy - b.hierarchy)
      .forEach((role) => {
        lines.push(
          `| ${role.code} | ${role.hierarchy} | ${role.role_type} | ${role.description} |`
        );
      });

    // Write file
    const outputPath = path.join(this.outputDir, "rbac-validation-report.md");
    await this.ensureDirectoryExists(this.outputDir);
    fs.writeFileSync(outputPath, lines.join("\n"));
    this.log(`📊 Generated validation report: ${outputPath}`);
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  private isValidPermissionFormat(permission: string): boolean {
    const parts = permission.split(":");
    return (
      parts.length >= 2 &&
      parts.length <= 3 &&
      parts.every((part) => part.length > 0)
    );
  }

  private parsePermission(
    permission: string
  ): { domain: string; action: string; subaction?: string } | null {
    if (!this.isValidPermissionFormat(permission)) return null;
    const [domain, action, subaction] = permission.split(":");
    return { domain, action, subaction };
  }

  private generatePermissionName(perm: ExpandedPermission): string {
    let name = `${perm.action.charAt(0).toUpperCase() + perm.action.slice(1)} ${
      perm.domain
    }`;
    if (perm.subaction) {
      name += ` (${perm.subaction})`;
    }
    return name;
  }

  private generatePermissionDescription(perm: ExpandedPermission): string {
    let desc = `${
      perm.action.charAt(0).toUpperCase() + perm.action.slice(1)
    } operations on ${perm.domain}`;
    if (perm.subaction) {
      desc += ` with ${perm.subaction} scope`;
    }
    return desc;
  }

  private async ensureDirectoryExists(dir: string): Promise<void> {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
      this.log(`📁 Created directory: ${dir}`);
    }
  }

  private log(message: string): void {
    if (this.verbose) {
      console.log(message);
    }
  }
}

// ============================================================================
// CLI INTERFACE
// ============================================================================

if (require.main === module) {
  program
    .name("rbac-generator-v8.2")
    .description(
      "Nov15Zeus RBAC Generator v8.2 - Enterprise RBAC code generation"
    )
    .version("8.2.0")
    .option(
      "-s, --schema <path>",
      "Path to RBAC schema file",
      "./RBAC/rbac.schema.v8.2.yml"
    )
    .option("-o, --output <dir>", "Output directory", "./generated/rbac")
    .option("-v, --verbose", "Verbose output", false)
    .option("--validate-only", "Validate schema only (no generation)", false);

  program.parse();

  const options = program.opts();

  try {
    const generator = new RBACGeneratorV82(
      options.schema,
      options.output,
      options.verbose
    );

    if (options.validateOnly) {
      generator.validateOnly();
    } else {
      generator
        .generate()
        .then((result) => {
          console.log("");
          console.log("🎉 RBAC Generation Complete!");
          console.log("");
          console.log("📊 Summary:");
          console.log(`  - Permissions: ${result.validation.totalPermissions}`);
          console.log(`  - Roles: ${result.validation.totalRoles}`);
          console.log(`  - Output Directory: ${options.output}`);
          console.log("");
          console.log("📁 Generated Files:");
          console.log("  - rbac-constants.ts (TypeScript constants)");
          console.log("  - rbac-seed.ts (Prisma seed data)");
          console.log("  - rbac-validation-report.md (Validation report)");

          if (result.validation.warnings.length > 0) {
            console.log("");
            console.log("⚠️ Warnings:");
            result.validation.warnings.forEach((warning) => {
              console.log(`  - ${warning}`);
            });
          }
        })
        .catch((error) => {
          console.error("❌ Generation failed:", error.message);
          process.exit(1);
        });
    }
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

export default RBACGeneratorV82;
