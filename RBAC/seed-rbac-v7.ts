#!/usr/bin/env tsx
// ============================================================================
// RBAC Seed Script v7 - Enterprise Multi-Tenant ERP
// Seeds roles and permissions from RBAC.schema.v7.yml via Prisma operations
// Completely rewritten to solve foreign key constraint issues
// Date: October 5, 2025
// ============================================================================

/// <reference types="node" />
import fs from "fs";
import path from "path";
import { PrismaClient } from "@prisma/client";
import { randomUUID } from "crypto";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Initialize Prisma client
const prisma = new PrismaClient();

interface SeedOptions {
  tenantId?: string;
  dryRun?: boolean;
  verbose?: boolean;
}

interface PermissionDefinition {
  name: string;
  description: string;
  domain: string;
  action: string;
  resource: string;
}

interface SchemaStructure {
  version: number;
  description: string;
  roles: Record<string, string[]>;
  permissions: Record<string, PermissionDefinition>;
}

export class RBACSeederV7 {
  private schema: SchemaStructure;
  private roles: string[];
  private permissions: PermissionDefinition[];
  private options: SeedOptions;

  constructor(options: SeedOptions = {}) {
    this.options = {
      dryRun: false,
      verbose: false,
      ...options,
    };

    this.schema = { version: 0, description: "", roles: {}, permissions: {} };
    this.roles = [];
    this.permissions = [];

    this.loadSchema();
  }

  private loadSchema(): void {
    const schemaPath = path.resolve(__dirname, "../../RBAC.schema.v7.yml");

    if (!fs.existsSync(schemaPath)) {
      throw new Error(`RBAC schema file not found: ${schemaPath}`);
    }

    const yamlContent = fs.readFileSync(schemaPath, "utf8");
    this.parseSchema(yamlContent);

    if (this.options.verbose) {
      console.log(`📖 Loaded RBAC schema from: ${schemaPath}`);
    }
  }

  private parseSchema(yamlContent: string): void {
    console.log("🔍 Parsing RBAC.schema.v7.yml...");

    const lines = yamlContent.split("\n");
    this.roles = [];
    this.permissions = [];

    let currentSection = "";
    let currentRole = "";
    let currentDomain = "";
    let inPermissionsSection = false;
    let inRoleSection = false;

    // First pass: extract roles and their permissions
    const rolePermissions: Record<string, string[]> = {};

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      const originalLine = lines[i];
      const indentation = originalLine.length - originalLine.trimStart().length;

      // Detect permissions section start
      if (line === "permissions:") {
        inPermissionsSection = true;
        inRoleSection = false;
        currentSection = "permissions";
        continue;
      }

      // If we're in permissions section
      if (inPermissionsSection) {
        // Detect role sections (2 spaces indentation)
        if (
          indentation === 2 &&
          line.match(/^(ADMIN|PROJECT_MANAGER|WORKER|DRIVER|VIEWER):$/)
        ) {
          currentRole = line.replace(":", "");
          if (!this.roles.includes(currentRole)) {
            this.roles.push(currentRole);
            rolePermissions[currentRole] = [];
          }
          inRoleSection = true;
          currentSection = "role";
          continue;
        }

        // Detect domain sections (4 spaces indentation)
        if (
          inRoleSection &&
          indentation === 4 &&
          line.endsWith(":") &&
          !line.startsWith("-")
        ) {
          currentDomain = line.replace(":", "");
          continue;
        }

        // Parse individual permissions (6 or 8 spaces indentation)
        if (
          inRoleSection &&
          currentRole &&
          (indentation === 6 || indentation === 8)
        ) {
          const match = line.match(/^\s*-\s+(.+?)(?:\s*#.*)?$/);
          if (match) {
            let permissionCode = match[1].trim();
            // Remove any trailing comments
            permissionCode = permissionCode.split("#")[0].trim();

            if (permissionCode && permissionCode.includes(".")) {
              rolePermissions[currentRole].push(permissionCode);

              // Create permission definition
              const [resource, action] = permissionCode.split(".");
              if (resource && action) {
                // Check if we already have this permission
                const existingPerm = this.permissions.find(
                  (p) => p.resource === resource && p.action === action
                );

                if (!existingPerm) {
                  // Generate a descriptive name and description
                  const name = this.generatePermissionName(resource, action);
                  const description = this.generatePermissionDescription(
                    resource,
                    action
                  );

                  this.permissions.push({
                    name,
                    description,
                    domain: currentDomain || "general",
                    action,
                    resource,
                  });
                }
              }
            }
          }
        }
      }
    }

    // Build final schema structure
    this.schema = {
      version: 7,
      description: "Production-Ready Multi-tenant ERP RBAC System",
      roles: rolePermissions,
      permissions: this.permissions.reduce((acc, perm) => {
        acc[`${perm.resource}.${perm.action}`] = perm;
        return acc;
      }, {} as Record<string, PermissionDefinition>),
    };

    console.log(`✅ Parsed schema successfully:`);
    console.log(`   - Roles: ${this.roles.length}`);
    console.log(`   - Permissions: ${this.permissions.length}`);
    console.log(
      `   - Role definitions: ${Object.keys(this.schema.roles).length}`
    );
  }

  private generatePermissionName(resource: string, action: string): string {
    const actionNames: Record<string, string> = {
      read: "View",
      create: "Create",
      update: "Update",
      soft_delete: "Delete",
      hard_delete: "Permanently Delete",
      restore: "Restore",
      activate: "Activate",
      deactivate: "Deactivate",
      assign: "Assign",
      unassign: "Unassign",
      transfer: "Transfer",
      approve: "Approve",
      reject: "Reject",
      send: "Send",
      export: "Export",
      publish: "Publish",
      archive: "Archive",
      duplicate: "Duplicate",
      lock: "Lock",
      unlock: "Unlock",
      submit: "Submit",
      review: "Review",
      sync: "Synchronize",
      process: "Process",
      implement: "Implement",
      assess: "Assess",
      mitigate: "Mitigate",
      resolve: "Resolve",
      investigate: "Investigate",
      execute: "Execute",
      allocate: "Allocate",
      deallocate: "Deallocate",
      grant: "Grant",
      revoke: "Revoke",
      complete: "Complete",
    };

    const actionName =
      actionNames[action] || action.charAt(0).toUpperCase() + action.slice(1);
    const resourceName = resource.replace(/([A-Z])/g, " $1").trim();

    return `${actionName} ${resourceName}`;
  }

  private generatePermissionDescription(
    resource: string,
    action: string
  ): string {
    const actionDescriptions: Record<string, string> = {
      read: "View and access",
      create: "Create new",
      update: "Modify existing",
      soft_delete: "Delete (soft)",
      hard_delete: "Permanently delete",
      restore: "Restore deleted",
      activate: "Activate",
      deactivate: "Deactivate",
      assign: "Assign",
      unassign: "Remove assignment of",
      transfer: "Transfer ownership of",
      approve: "Approve",
      reject: "Reject",
      send: "Send",
      export: "Export data for",
      publish: "Publish",
      archive: "Archive",
      duplicate: "Duplicate",
      lock: "Lock",
      unlock: "Unlock",
      submit: "Submit",
      review: "Review",
      sync: "Synchronize",
      process: "Process",
      implement: "Implement",
      assess: "Assess",
      mitigate: "Mitigate",
      resolve: "Resolve",
      investigate: "Investigate",
      execute: "Execute",
      allocate: "Allocate",
      deallocate: "Deallocate",
      grant: "Grant access to",
      revoke: "Revoke access to",
      complete: "Mark as complete",
    };

    const actionDesc = actionDescriptions[action] || action;
    const resourceName = resource
      .replace(/([A-Z])/g, " $1")
      .trim()
      .toLowerCase();

    return `${actionDesc} ${resourceName} records within tenant scope`;
  }

  async getAllTenants(): Promise<
    Array<{ id: string; name: string; slug: string }>
  > {
    try {
      const tenants = await prisma.tenant.findMany({
        where: {
          deletedAt: null,
          status: "ACTIVE",
        },
        select: {
          id: true,
          name: true,
          slug: true,
        },
      });

      return tenants;
    } catch (error) {
      console.error("❌ Error fetching tenants:", error);
      return [];
    }
  }

  async seedTenant(
    tenantId: string
  ): Promise<{ success: boolean; stats: any }> {
    const stats = {
      permissionsCreated: 0,
      rolesCreated: 0,
      rolePermissionsCreated: 0,
      errors: 0,
    };

    try {
      console.log(`🌱 Seeding RBAC data for tenant: ${tenantId}`);

      if (this.options.dryRun) {
        console.log("🔍 DRY RUN MODE - No actual changes will be made");
        // Show what would be created
        const rbacData = this.parseRBACForPrisma();
        console.log(
          `   📊 Would create: ${rbacData.permissions.length} permissions, ${rbacData.roles.length} roles, ${rbacData.rolePermissions.length} role-permissions`
        );
        return { success: true, stats };
      }

      // Use Prisma operations instead of raw SQL for better error handling
      await this.seedTenantWithPrisma(tenantId, stats);

      console.log(`   ✅ Successfully seeded tenant ${tenantId}`);
      return { success: true, stats };
    } catch (error: any) {
      console.error(`   ❌ Failed to seed tenant ${tenantId}:`, error.message);
      return { success: false, stats };
    }
  }

  private async seedTenantWithPrisma(
    tenantId: string,
    stats: any
  ): Promise<void> {
    // Parse RBAC schema to get structured data
    const rbacData = this.parseRBACForPrisma();

    console.log(
      `   📊 Seeding: ${rbacData.permissions.length} permissions, ${rbacData.roles.length} roles, ${rbacData.rolePermissions.length} role-permissions`
    );

    // STEP 1: Insert all permissions (global - no tenantId) in one transaction
    console.log(
      `   📝 Step 1: Inserting ${rbacData.permissions.length} permissions...`
    );

    await prisma.$transaction(
      async (tx: any) => {
        for (const permission of rbacData.permissions) {
          try {
            await tx.permission.upsert({
              where: { code: permission.code },
              update: {},
              create: {
                id: permission.id,
                code: permission.code,
                name: permission.name,
                description: permission.description,
                category: permission.category,
                status: "ACTIVE",
                version: 1,
                createdAt: new Date(),
                updatedAt: new Date(),
              },
            });
            stats.permissionsCreated++;
          } catch (error: any) {
            if (!error.message?.includes("duplicate")) {
              console.error(
                `   ⚠️  Permission error (${permission.code}):`,
                error.message
              );
            }
          }
        }
      },
      {
        timeout: 60000, // 1 minute for permissions
      }
    );

    // STEP 2: Insert all roles for this tenant in separate transaction
    console.log(
      `   📝 Step 2: Inserting ${rbacData.roles.length} roles for tenant...`
    );

    await prisma.$transaction(
      async (tx: any) => {
        for (const role of rbacData.roles) {
          try {
            await tx.role.upsert({
              where: {
                tenantId_code: {
                  tenantId: tenantId,
                  code: role.code,
                },
              },
              update: {},
              create: {
                id: role.id,
                tenantId: tenantId,
                code: role.code,
                name: role.name,
                description: role.description,
                status: "ACTIVE",
                version: 1,
                createdAt: new Date(),
                updatedAt: new Date(),
              },
            });
            stats.rolesCreated++;
          } catch (error: any) {
            if (!error.message?.includes("duplicate")) {
              console.error(`   ⚠️  Role error (${role.code}):`, error.message);
            }
          }
        }
      },
      {
        timeout: 30000, // 30 seconds for roles
      }
    );

    // STEP 3: Insert role-permission relationships in batches
    console.log(
      `   📝 Step 3: Inserting ${rbacData.rolePermissions.length} role-permission relationships in batches...`
    );

    const batchSize = 500; // Process 500 role-permissions per batch
    const batches = [];

    for (let i = 0; i < rbacData.rolePermissions.length; i += batchSize) {
      batches.push(rbacData.rolePermissions.slice(i, i + batchSize));
    }

    console.log(
      `   📦 Processing ${batches.length} batches of up to ${batchSize} role-permissions each...`
    );

    for (let batchIndex = 0; batchIndex < batches.length; batchIndex++) {
      const batch = batches[batchIndex];
      console.log(
        `   📦 Batch ${batchIndex + 1}/${batches.length} - ${
          batch.length
        } role-permissions`
      );

      await prisma.$transaction(
        async (tx: any) => {
          for (const rp of batch) {
            try {
              await tx.rolePermission.upsert({
                where: {
                  tenantId_roleId_permissionId_memberId_resourceType_resourceId:
                    {
                      tenantId: tenantId,
                      roleId: rp.roleId,
                      permissionId: rp.permissionId,
                      memberId: null,
                      resourceType: null,
                      resourceId: null,
                    },
                },
                update: {},
                create: {
                  id: rp.id,
                  tenantId: tenantId,
                  roleId: rp.roleId,
                  permissionId: rp.permissionId,
                  status: "ACTIVE",
                  version: 1,
                  createdAt: new Date(),
                  updatedAt: new Date(),
                },
              });
              stats.rolePermissionsCreated++;
            } catch (error: any) {
              if (!error.message?.includes("duplicate")) {
                console.error(`   ⚠️  RolePermission error:`, error.message);
                stats.errors++;
              }
            }
          }
        },
        {
          timeout: 60000, // 1 minute per batch
        }
      );
    }
  }

  private parseRBACForPrisma() {
    const permissions: Array<{
      id: string;
      code: string;
      name: string;
      description: string;
      category: string;
    }> = [];
    const roles: Array<{
      id: string;
      code: string;
      name: string;
      description: string;
    }> = [];
    const rolePermissions: Array<{
      id: string;
      roleId: string;
      permissionId: string;
    }> = [];

    // Create consistent ID maps
    const permissionIds = new Map<string, string>();
    const roleIds = new Map<string, string>();

    // Generate permissions with consistent IDs
    for (const perm of this.permissions) {
      const permCode = `${perm.resource}.${perm.action}`;
      const permId = randomUUID();

      permissionIds.set(permCode, permId);

      permissions.push({
        id: permId,
        code: permCode,
        name: perm.name,
        description: perm.description,
        category: perm.domain,
      });
    }

    // Generate roles with consistent IDs
    const roleDescriptions = {
      ADMIN:
        "System administrator with complete access to all tenant data and operations",
      PROJECT_MANAGER:
        "Project manager with ability to manage projects, estimates, team members, and approve operations within tenant scope",
      WORKER:
        "Field worker with access to assigned projects, tasks, time tracking, and expense reporting within tenant scope",
      DRIVER:
        "Driver with access to assigned delivery tasks, time tracking, and mobile operations within tenant scope",
      VIEWER:
        "Read-only access for reporting, training and demonstration purposes within tenant scope",
    };

    for (const role of this.roles) {
      const roleId = randomUUID();
      roleIds.set(role, roleId);

      roles.push({
        id: roleId,
        code: role,
        name: role
          .split("_")
          .map(
            (word) => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
          )
          .join(" "),
        description:
          roleDescriptions[role as keyof typeof roleDescriptions] ||
          `Role for ${role.toLowerCase()}`,
      });
    }

    // Generate role-permission relationships
    for (const role of this.roles) {
      const roleId = roleIds.get(role);
      const rolePerms = this.schema.roles[role] || [];

      for (const permCode of rolePerms) {
        const permissionId = permissionIds.get(permCode);

        if (roleId && permissionId) {
          rolePermissions.push({
            id: randomUUID(),
            roleId,
            permissionId,
          });
        } else {
          console.warn(
            `   ⚠️  Missing ID mapping: role=${role}, perm=${permCode}`
          );
        }
      }
    }

    return { permissions, roles, rolePermissions };
  }

  async seedAllTenants(): Promise<void> {
    try {
      console.log("🏗️  Starting RBAC seed for all tenants...\n");

      // Get all tenants
      const tenants = await this.getAllTenants();

      if (tenants.length === 0) {
        console.log(
          "⚠️  No active tenants found. Creating seed data requires at least one tenant."
        );
        return;
      }

      console.log(`📋 Found ${tenants.length} active tenant(s):`);
      tenants.forEach((tenant) => {
        console.log(`   - ${tenant.name} (${tenant.slug}) - ${tenant.id}`);
      });
      console.log("");

      const totalStats = {
        tenantsProcessed: 0,
        tenantsSuccess: 0,
        tenantsFailed: 0,
        totalPermissions: 0,
        totalRoles: 0,
        totalRolePermissions: 0,
        totalErrors: 0,
      };

      // Seed each tenant
      for (const tenant of tenants) {
        totalStats.tenantsProcessed++;

        const result = await this.seedTenant(tenant.id);

        if (result.success) {
          totalStats.tenantsSuccess++;
          totalStats.totalPermissions += result.stats.permissionsCreated;
          totalStats.totalRoles += result.stats.rolesCreated;
          totalStats.totalRolePermissions +=
            result.stats.rolePermissionsCreated;
        } else {
          totalStats.tenantsFailed++;
        }

        totalStats.totalErrors += result.stats.errors;
      }

      // Print summary
      console.log("\n" + "=".repeat(70));
      console.log("📊 RBAC SEED SUMMARY");
      console.log("=".repeat(70));
      console.log(`Tenants processed: ${totalStats.tenantsProcessed}`);
      console.log(`  ✅ Success: ${totalStats.tenantsSuccess}`);
      console.log(`  ❌ Failed: ${totalStats.tenantsFailed}`);
      console.log(`Permissions created: ${totalStats.totalPermissions}`);
      console.log(`Roles created: ${totalStats.totalRoles}`);
      console.log(
        `Role-Permission assignments: ${totalStats.totalRolePermissions}`
      );
      console.log(`Errors encountered: ${totalStats.totalErrors}`);
      console.log("=".repeat(70));

      if (totalStats.tenantsFailed === 0) {
        console.log("🎉 All tenants seeded successfully!");
      } else {
        console.log(
          `⚠️  ${totalStats.tenantsFailed} tenant(s) failed to seed. Check logs above.`
        );
      }
    } catch (error: any) {
      console.error("❌ Fatal error during seeding:", error.message);
      throw error;
    }
  }

  async verify(): Promise<boolean> {
    try {
      console.log("🔍 Verifying RBAC seed data...\n");

      const tenants = await this.getAllTenants();

      if (tenants.length === 0) {
        console.log("⚠️  No tenants found to verify.");
        return false;
      }

      let allValid = true;

      for (const tenant of tenants) {
        console.log(`🔍 Verifying tenant: ${tenant.name} (${tenant.id})`);

        try {
          // Check permissions (global)
          const permissionCount = await prisma.permission.count({
            where: { status: "ACTIVE" },
          });

          // Check roles for this tenant
          const roleCount = await prisma.role.count({
            where: {
              tenantId: tenant.id,
              status: "ACTIVE",
            },
          });

          // Check role-permission assignments for this tenant
          const rolePermCount = await prisma.rolePermission.count({
            where: {
              tenantId: tenant.id,
              status: "ACTIVE",
            },
          });

          console.log(`   📊 Permissions: ${permissionCount} (global)`);
          console.log(`   📊 Roles: ${roleCount}`);
          console.log(`   📊 Role-Permissions: ${rolePermCount}`);

          // Validate expected counts
          const expectedRoles = 5; // ADMIN, PROJECT_MANAGER, WORKER, DRIVER, VIEWER

          if (roleCount < expectedRoles) {
            console.log(
              `   ⚠️  Expected at least ${expectedRoles} roles, found ${roleCount}`
            );
            allValid = false;
          }

          if (permissionCount < 1000) {
            // We expect ~1651 permissions
            console.log(
              `   ⚠️  Expected at least 1000 permissions, found ${permissionCount}`
            );
            allValid = false;
          }

          if (rolePermCount < 100) {
            // Should have many role-permission assignments
            console.log(
              `   ⚠️  Expected at least 100 role-permission assignments, found ${rolePermCount}`
            );
            allValid = false;
          }

          if (
            roleCount === expectedRoles &&
            permissionCount >= 1000 &&
            rolePermCount >= 100
          ) {
            console.log(`   ✅ Tenant ${tenant.name} verification passed`);
          }
        } catch (error: any) {
          console.error(
            `   ❌ Verification failed for tenant ${tenant.name}:`,
            error.message
          );
          allValid = false;
        }

        console.log("");
      }

      if (allValid) {
        console.log("✅ All tenants verified successfully!");
        return true;
      } else {
        console.log("❌ Some tenants failed verification. Check logs above.");
        return false;
      }
    } catch (error: any) {
      console.error("❌ Fatal error during verification:", error.message);
      return false;
    }
  }

  async cleanup(): Promise<void> {
    await prisma.$disconnect();
  }
}

// ============================================================================
// CLI EXECUTION
// ============================================================================
async function main() {
  const args = process.argv.slice(2);
  const command = args[0] || "help";

  // Parse options
  const options: SeedOptions = {
    dryRun: args.includes("--dry-run"),
    verbose: args.includes("--verbose"),
    tenantId: args
      .find((arg: string) => arg.startsWith("--tenant="))
      ?.split("=")[1],
  };

  const seeder = new RBACSeederV7(options);

  try {
    switch (command) {
      case "run":
        console.log("🌱 RBAC Seeder v7 - Enterprise Multi-Tenant ERP");
        if (options.dryRun) {
          console.log("🔍 DRY RUN MODE - No actual changes will be made\n");
        }

        if (options.tenantId) {
          console.log(`🎯 Seeding specific tenant: ${options.tenantId}\n`);
          await seeder.seedTenant(options.tenantId);
        } else {
          await seeder.seedAllTenants();
        }
        break;

      case "verify":
        console.log("🔍 RBAC Verifier v7 - Enterprise Multi-Tenant ERP\n");
        const isValid = await seeder.verify();
        process.exit(isValid ? 0 : 1);
        break;

      case "help":
      default:
        console.log("🌱 RBAC Seeder v7 - Enterprise Multi-Tenant ERP");
        console.log("");
        console.log("Usage: tsx scripts/seed-rbac-v7.ts <command> [options]");
        console.log("");
        console.log("Commands:");
        console.log("  run          Seed RBAC data for all tenants");
        console.log("  verify       Verify RBAC data integrity");
        console.log("  help         Show this help message");
        console.log("");
        console.log("Options:");
        console.log(
          "  --dry-run    Show what would be done without making changes"
        );
        console.log("  --verbose    Enable verbose logging");
        console.log("  --tenant=ID  Seed only specific tenant");
        console.log("");
        console.log("Examples:");
        console.log("  tsx scripts/seed-rbac-v7.ts run");
        console.log("  tsx scripts/seed-rbac-v7.ts run --dry-run");
        console.log("  tsx scripts/seed-rbac-v7.ts verify");
        console.log("  tsx scripts/seed-rbac-v7.ts run --tenant=uuid-here");
        break;
    }
  } catch (error: any) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  } finally {
    await seeder.cleanup();
  }
}

// Execute if run directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}

export default RBACSeederV7;
