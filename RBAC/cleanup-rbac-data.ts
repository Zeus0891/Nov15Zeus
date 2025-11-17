#!/usr/bin/env tsx
// ============================================================================
// RBAC Database Cleanup - Remove Legacy RBAC Data
// Removes any RBAC data that was seeded previously since we now use
// application-layer only approach (no database seeding needed)
// Date: October 5, 2025
// ============================================================================

/// <reference types="node" />
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

interface CleanupStats {
  permissionsDeleted: number;
  rolePermissionsDeleted: number;
  rolesDeleted: number;
  errors: string[];
}

export class RBACDatabaseCleanup {
  async checkExistingRBACData(): Promise<void> {
    console.log("🔍 Checking existing RBAC data in database...\n");

    try {
      // Check Permissions
      const permissionCount = await prisma.permission.count();
      console.log(`📄 Permissions: ${permissionCount} records`);

      if (permissionCount > 0) {
        const samplePermissions = await prisma.permission.findMany({
          take: 5,
          select: { code: true, name: true, category: true },
        });
        console.log("   Sample permissions:");
        samplePermissions.forEach((p: any) => {
          console.log(`     - ${p.code}: ${p.name} (${p.category})`);
        });
      }

      // Check Roles
      const roleCount = await prisma.role.count();
      console.log(`\n👥 Roles: ${roleCount} records`);

      if (roleCount > 0) {
        const rolesByTenant = await prisma.role.groupBy({
          by: ["tenantId"],
          _count: { id: true },
          orderBy: { _count: { id: "desc" } },
          take: 10,
        });
        console.log("   Roles by tenant:");
        rolesByTenant.forEach((r: any) => {
          console.log(`     - Tenant ${r.tenantId}: ${r._count.id} roles`);
        });
      }

      // Check RolePermissions
      const rolePermissionCount = await prisma.rolePermission.count();
      console.log(`\n🔗 RolePermissions: ${rolePermissionCount} records`);

      if (rolePermissionCount > 0) {
        const rpByTenant = await prisma.rolePermission.groupBy({
          by: ["tenantId"],
          _count: { id: true },
          orderBy: { _count: { id: "desc" } },
          take: 10,
        });
        console.log("   Role-Permissions by tenant:");
        rpByTenant.forEach((rp: any) => {
          console.log(
            `     - Tenant ${rp.tenantId}: ${rp._count.id} assignments`
          );
        });
      }

      // Summary
      const totalRBACRecords =
        permissionCount + roleCount + rolePermissionCount;
      console.log(`\n📊 Total RBAC records: ${totalRBACRecords}`);

      if (totalRBACRecords > 0) {
        console.log(
          `\n⚠️  Found existing RBAC data that should be cleaned up.`
        );
        console.log(`    Since we now use application-layer only approach,`);
        console.log(`    this database data is not needed and can be removed.`);
      } else {
        console.log(`\n✅ No RBAC data found in database - all clean!`);
      }
    } catch (error: any) {
      console.error("❌ Error checking RBAC data:", error.message);
    }
  }

  async cleanupRBACData(dryRun: boolean = true): Promise<CleanupStats> {
    console.log(
      `🧹 ${dryRun ? "DRY RUN - " : ""}Cleaning up RBAC data from database...\n`
    );

    const stats: CleanupStats = {
      permissionsDeleted: 0,
      rolePermissionsDeleted: 0,
      rolesDeleted: 0,
      errors: [],
    };

    try {
      // Step 1: Count what we'll delete
      const permissionCount = await prisma.permission.count();
      const rolePermissionCount = await prisma.rolePermission.count();
      const roleCount = await prisma.role.count();

      console.log(
        `📋 Records to be ${dryRun ? "deleted (DRY RUN)" : "DELETED"}:`
      );
      console.log(`   - Permissions: ${permissionCount}`);
      console.log(`   - RolePermissions: ${rolePermissionCount}`);
      console.log(`   - Roles: ${roleCount}`);
      console.log("");

      if (dryRun) {
        console.log(`🔍 DRY RUN - No actual changes will be made`);
        console.log(`   Run with --execute flag to perform actual cleanup`);
        stats.permissionsDeleted = permissionCount;
        stats.rolePermissionsDeleted = rolePermissionCount;
        stats.rolesDeleted = roleCount;
        return stats;
      }

      // Step 2: Delete in correct order (foreign key constraints)
      console.log("🗑️  Deleting RolePermissions...");
      const deletedRolePermissions = await prisma.rolePermission.deleteMany({});
      stats.rolePermissionsDeleted = deletedRolePermissions.count;
      console.log(
        `   ✅ Deleted ${stats.rolePermissionsDeleted} role-permission assignments`
      );

      console.log("🗑️  Deleting Roles...");
      const deletedRoles = await prisma.role.deleteMany({});
      stats.rolesDeleted = deletedRoles.count;
      console.log(`   ✅ Deleted ${stats.rolesDeleted} roles`);

      console.log("🗑️  Deleting Permissions...");
      const deletedPermissions = await prisma.permission.deleteMany({});
      stats.permissionsDeleted = deletedPermissions.count;
      console.log(`   ✅ Deleted ${stats.permissionsDeleted} permissions`);

      console.log(`\n🎉 Cleanup completed successfully!`);
    } catch (error: any) {
      console.error(`❌ Error during cleanup:`, error.message);
      stats.errors.push(error.message);
    }

    return stats;
  }

  async verifyCleanup(): Promise<void> {
    console.log("\n🔍 Verifying cleanup...");

    try {
      const permissionCount = await prisma.permission.count();
      const roleCount = await prisma.role.count();
      const rolePermissionCount = await prisma.rolePermission.count();

      console.log(`📊 Remaining records:`);
      console.log(`   - Permissions: ${permissionCount}`);
      console.log(`   - Roles: ${roleCount}`);
      console.log(`   - RolePermissions: ${rolePermissionCount}`);

      const totalRemaining = permissionCount + roleCount + rolePermissionCount;

      if (totalRemaining === 0) {
        console.log(`\n✅ Cleanup verification passed - all RBAC data removed`);
      } else {
        console.log(
          `\n⚠️  Warning: ${totalRemaining} RBAC records still remain`
        );
      }
    } catch (error: any) {
      console.error("❌ Error verifying cleanup:", error.message);
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
  const command = args[0] || "check";
  const execute = args.includes("--execute");
  const dryRun = !execute;

  console.log("🧹 RBAC Database Cleanup Tool");
  console.log(
    "🎯 Purpose: Remove legacy RBAC data since we use application-layer only\n"
  );

  const cleanup = new RBACDatabaseCleanup();

  try {
    switch (command) {
      case "check":
        console.log("🔍 CHECK MODE - Analyzing existing RBAC data\n");
        await cleanup.checkExistingRBACData();
        break;

      case "clean":
        if (dryRun) {
          console.log("🔍 DRY RUN MODE - No actual changes will be made\n");
        } else {
          console.log("⚠️  EXECUTE MODE - Will permanently delete RBAC data\n");
          console.log("   Press Ctrl+C within 5 seconds to cancel...");
          await new Promise((resolve) => setTimeout(resolve, 5000));
        }

        const stats = await cleanup.cleanupRBACData(dryRun);

        if (!dryRun) {
          await cleanup.verifyCleanup();
        }

        console.log(`\n📊 Cleanup Summary:`);
        console.log(
          `   - Permissions: ${stats.permissionsDeleted} ${
            dryRun ? "(would be deleted)" : "deleted"
          }`
        );
        console.log(
          `   - RolePermissions: ${stats.rolePermissionsDeleted} ${
            dryRun ? "(would be deleted)" : "deleted"
          }`
        );
        console.log(
          `   - Roles: ${stats.rolesDeleted} ${
            dryRun ? "(would be deleted)" : "deleted"
          }`
        );

        if (stats.errors.length > 0) {
          console.log(`   - Errors: ${stats.errors.length}`);
          stats.errors.forEach((error, i) => {
            console.log(`     ${i + 1}. ${error}`);
          });
        }
        break;

      case "verify":
        console.log("✅ VERIFY MODE - Checking if database is clean\n");
        await cleanup.verifyCleanup();
        break;

      default:
        console.log(
          "Usage: tsx scripts/cleanup-rbac-data.ts [command] [options]"
        );
        console.log("\nCommands:");
        console.log("  check    Check existing RBAC data (default)");
        console.log("  clean    Clean up RBAC data");
        console.log("  verify   Verify cleanup was successful");
        console.log("\nOptions:");
        console.log(
          "  --execute   Actually perform the cleanup (default is dry-run)"
        );
        console.log("\nExamples:");
        console.log("  tsx scripts/cleanup-rbac-data.ts check");
        console.log(
          "  tsx scripts/cleanup-rbac-data.ts clean           # dry-run"
        );
        console.log(
          "  tsx scripts/cleanup-rbac-data.ts clean --execute # actual cleanup"
        );
        break;
    }
  } catch (error: any) {
    console.error("❌ Fatal error:", error.message);
    process.exit(1);
  } finally {
    await cleanup.cleanup();
  }
}

// Execute if run directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}

export default RBACDatabaseCleanup;
