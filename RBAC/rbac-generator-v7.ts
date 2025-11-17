#!/usr/bin/env tsx
// ============================================================================
// RBAC Generator v7 - Enterprise Multi-Tenant ERP
// Auto-generates TypeScript files, SQL seeds, and middleware from RBAC.schema.v7.yml
// Based on reference generator but adapted for our v7 schema structure
// Date: October 5, 2025
// ============================================================================

import * as fs from "fs";
import * as path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ============================================================================
// RBAC Schema v7 Structure Interfaces
// ============================================================================
interface RBACSchemaV7 {
  version: number;
  description: string;
  roles: Record<string, string[]>;
  permissions: Record<string, PermissionDefinition>;
}

interface PermissionDefinition {
  name: string;
  description: string;
  domain: string;
  action: string;
  resource: string;
}

export class RBACGeneratorV7 {
  private schema!: RBACSchemaV7;
  private roles: string[] = [];
  private permissions: PermissionDefinition[] = [];

  constructor(schemaPath: string = "../../RBAC.schema.v7.yml") {
    const fullPath = path.resolve(__dirname, schemaPath);
    console.log(`📖 Reading RBAC schema from: ${fullPath}`);

    if (!fs.existsSync(fullPath)) {
      throw new Error(`RBAC schema file not found: ${fullPath}`);
    }

    const yamlContent = fs.readFileSync(fullPath, "utf8");
    this.parseSchema(yamlContent);
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

  // ============================================================================
  // GENERATE PERMISSIONS FILE
  // ============================================================================
  generatePermissionsFile(): string {
    console.log("📝 Generating permissions.ts...");

    let content = `// ============================================================================\n`;
    content += `// RBAC Permissions System v7 - Auto-generated\n`;
    content += `// Generated from RBAC.schema.v7.yml\n`;
    content += `// Date: ${new Date().toISOString().split("T")[0]}\n`;
    content += `// ============================================================================\n\n`;

    content += `export const PERMISSIONS = {\n`;

    // Group permissions by domain
    const groupedPermissions = this.groupPermissionsByDomain();

    for (const [domain, perms] of Object.entries(groupedPermissions)) {
      content += `  // ============================================================================\n`;
      content += `  // ${domain.toUpperCase()}\n`;
      content += `  // ============================================================================\n`;

      for (const perm of perms) {
        const key = this.permissionToKey(perm.resource, perm.action);
        content += `  ${key}: '${perm.resource}.${perm.action}',\n`;
      }
      content += `\n`;
    }

    content += `} as const;\n\n`;
    content += `export type Permission = typeof PERMISSIONS[keyof typeof PERMISSIONS];\n\n`;

    // Add permission categories
    content += `// ============================================================================\n`;
    content += `// Permission Categories\n`;
    content += `// ============================================================================\n`;
    content += `export const PERMISSION_CATEGORIES = {\n`;

    for (const [domain, perms] of Object.entries(groupedPermissions)) {
      const categoryKey = domain.toUpperCase().replace(/[^A-Z]/g, "_");
      content += `  ${categoryKey}: [\n`;
      for (const perm of perms) {
        const key = this.permissionToKey(perm.resource, perm.action);
        content += `    PERMISSIONS.${key},\n`;
      }
      content += `  ],\n`;
    }

    content += `} as const;\n\n`;

    // Add permission details
    content += `// ============================================================================\n`;
    content += `// Permission Details\n`;
    content += `// ============================================================================\n`;
    content += `export const PERMISSION_DETAILS: Record<Permission, { name: string; description: string; domain: string }> = {\n`;

    for (const perm of this.permissions) {
      const key = `${perm.resource}.${perm.action}`;
      content += `  '${key}': {\n`;
      content += `    name: '${perm.name}',\n`;
      content += `    description: '${perm.description}',\n`;
      content += `    domain: '${perm.domain}'\n`;
      content += `  },\n`;
    }

    content += `};\n`;

    return content;
  }

  // ============================================================================
  // GENERATE ROLES FILE
  // ============================================================================
  generateRolesFile(): string {
    console.log("📝 Generating roles.ts...");

    let content = `// ============================================================================\n`;
    content += `// RBAC Roles System v7 - Auto-generated\n`;
    content += `// Generated from RBAC.schema.v7.yml\n`;
    content += `// Date: ${new Date().toISOString().split("T")[0]}\n`;
    content += `// ============================================================================\n\n`;

    content += `import { PERMISSIONS } from './permissions';\n\n`;

    // Role constants
    content += `export const ROLES = {\n`;
    for (const role of this.roles) {
      content += `  ${role}: '${role}',\n`;
    }
    content += `} as const;\n\n`;

    content += `export type Role = typeof ROLES[keyof typeof ROLES];\n\n`;

    // Role permissions mapping
    content += `// ============================================================================\n`;
    content += `// Role Permissions Mapping\n`;
    content += `// ============================================================================\n`;
    content += `export const ROLE_PERMISSIONS: Record<Role, string[]> = {\n`;

    for (const role of this.roles) {
      const permissions = this.schema.roles[role] || [];

      // For ADMIN, grant all defined permissions to eliminate duplication and ensure full coverage
      if (role === 'ADMIN') {
        content += `  [ROLES.${role}]: Object.values(PERMISSIONS) as string[],\n`;
        continue;
      }

      content += `  [ROLES.${role}]: [\n`;
      for (const perm of permissions) {
        content += `    '${perm}',\n`;
      }
      content += `  ],\n`;
    }

    content += `};\n\n`;

    // Role descriptions
    content += `// ============================================================================\n`;
    content += `// Role Descriptions\n`;
    content += `// ============================================================================\n`;
    content += `export const ROLE_DESCRIPTIONS: Record<Role, string> = {\n`;
    content += `  [ROLES.ADMIN]: 'System administrator with complete access to all tenant data and operations',\n`;
    content += `  [ROLES.PROJECT_MANAGER]: 'Project manager with ability to manage projects, estimates, team members, and approve operations within tenant scope',\n`;
    content += `  [ROLES.WORKER]: 'Field worker with access to assigned projects, tasks, time tracking, and expense reporting within tenant scope',\n`;
    content += `  [ROLES.DRIVER]: 'Driver with access to assigned delivery tasks, time tracking, and mobile operations within tenant scope',\n`;
    content += `  [ROLES.VIEWER]: 'Read-only access for reporting, training and demonstration purposes within tenant scope',\n`;
    content += `};\n\n`;

    // Role hierarchy
    content += `// ============================================================================\n`;
    content += `// Role Hierarchy (for permission inheritance)\n`;
    content += `// ============================================================================\n`;
    content += `export const ROLE_HIERARCHY: Record<Role, number> = {\n`;
    content += `  [ROLES.ADMIN]: 5,\n`;
    content += `  [ROLES.PROJECT_MANAGER]: 4,\n`;
    content += `  [ROLES.WORKER]: 3,\n`;
    content += `  [ROLES.DRIVER]: 2,\n`;
    content += `  [ROLES.VIEWER]: 1,\n`;
    content += `};\n`;

    return content;
  }

  // ============================================================================
  // GENERATE SQL SEED FILE
  // ============================================================================
  generateSeedFile(): string {
    console.log("📝 Generating rbac-v7.sql...");

    let content = `-- ============================================================================\n`;
    content += `-- RBAC Seed Data v7 - Auto-generated\n`;
    content += `-- Generated from RBAC.schema.v7.yml\n`;
    content += `-- Date: ${new Date().toISOString().split("T")[0]}\n`;
    content += `-- ============================================================================\n`;
    content += `-- This file contains parameterized SQL for seeding RBAC data\n`;
    content += `-- Parameters will be replaced by seed-rbac-v7.ts at runtime\n`;
    content += `-- ============================================================================\n\n`;

    // Insert permissions (global - no tenantId)
    content += `-- ============================================================================\n`;
    content += `-- INSERT PERMISSIONS (Global - No Tenant)\n`;
    content += `-- ============================================================================\n`;

    for (const perm of this.permissions) {
      const permKey = `${perm.resource}.${perm.action}`;
      const permIdParam = this.permissionToIdParam(perm.resource, perm.action);

      content += `INSERT INTO "Permission" (\n`;
      content += `  "id", "code", "name", "description", "category", "status", "version", "createdAt", "updatedAt"\n`;
      content += `) VALUES (\n`;
      content += `  :${permIdParam}, '${permKey}', '${perm.name}', '${perm.description}', '${perm.domain}',\n`;
      content += `  'ACTIVE', 1, NOW(), NOW()\n`;
      content += `) ON CONFLICT ("code") DO NOTHING;\n\n`;
    }

    // Insert roles (per tenant)
    content += `-- ============================================================================\n`;
    content += `-- INSERT ROLES (Per Tenant)\n`;
    content += `-- ============================================================================\n`;

    for (const role of this.roles) {
      const roleIdParam = `role_${role.toLowerCase()}_id`;
      const description = this.getRoleDescription(role);

      content += `INSERT INTO "Role" (\n`;
      content += `  "id", "tenantId", "code", "name", "description", "status", "version", "createdAt", "updatedAt"\n`;
      content += `) VALUES (\n`;
      content += `  :${roleIdParam}, :tenantId, '${role}', '${this.formatRoleName(
        role
      )}', '${description}',\n`;
      content += `  'ACTIVE', 1, NOW(), NOW()\n`;
      content += `) ON CONFLICT ("tenantId", "code") DO NOTHING;\n\n`;
    }

    // Insert role permissions
    content += `-- ============================================================================\n`;
    content += `-- INSERT ROLE PERMISSIONS (Per Tenant)\n`;
    content += `-- ============================================================================\n`;

    for (const role of this.roles) {
      const roleIdParam = `role_${role.toLowerCase()}_id`;
      // For ADMIN, seed with ALL defined permissions to match generated code mapping
      const permissions =
        role === 'ADMIN'
          ? this.permissions.map((p) => `${p.resource}.${p.action}`)
          : this.schema.roles[role] || [];

      content += `-- ${role} Role Permissions\n`;
      for (const permKey of permissions) {
        const [resource, action] = permKey.split(".");
        const permIdParam = this.permissionToIdParam(resource, action);
        const rpIdParam = `rp_${role.toLowerCase()}_${resource.toLowerCase()}_${action}`;

        content += `INSERT INTO "RolePermission" (\n`;
        content += `  "id", "tenantId", "roleId", "permissionId", "memberId", "status", "version", "createdAt", "updatedAt"\n`;
        content += `) VALUES (\n`;
        content += `  :${rpIdParam}, :tenantId, :${roleIdParam}, :${permIdParam}, NULL,\n`;
        content += `  'ACTIVE', 1, NOW(), NOW()\n`;
        content += `) ON CONFLICT ("tenantId", "roleId", "permissionId", "memberId") DO NOTHING;\n`;
      }
      content += `\n`;
    }

    return content;
  }

  // ============================================================================
  // GENERATE MIDDLEWARE FILE
  // ============================================================================
  generateMiddlewareFile(): string {
    console.log("📝 Generating rbac middleware...");

    let content = `// ============================================================================\n`;
    content += `// RBAC Middleware v7 - Auto-generated\n`;
    content += `// Generated from RBAC.schema.v7.yml\n`;
    content += `// Multi-tenant aware permission checking\n`;
    content += `// Date: ${new Date().toISOString().split("T")[0]}\n`;
    content += `// ============================================================================\n\n`;

    content += `import { Request, Response, NextFunction } from 'express';\n`;
    content += `import { ROLES, ROLE_PERMISSIONS, ROLE_HIERARCHY, Role } from '../roles';\n`;
    content += `import { Permission } from '../permissions';\n\n`;

    // Extend Express Request interface
    content += `// ============================================================================\n`;
    content += `// TypeScript Interface Extensions\n`;
    content += `// ============================================================================\n`;
    content += `declare global {\n`;
    content += `  namespace Express {\n`;
    content += `    interface Request {\n`;
    content += `      user?: {\n`;
    content += `        id?: string;\n`;
    content += `        tenantId?: string;\n`;
    content += `        role?: Role;\n`;
    content += `        permissions?: string[];\n`;
    content += `        [key: string]: any;\n`;
    content += `      };\n`;
    content += `      tenant?: {\n`;
    content += `        id?: string;\n`;
    content += `        name?: string;\n`;
    content += `        [key: string]: any;\n`;
    content += `      };\n`;
    content += `    }\n`;
    content += `  }\n`;
    content += `}\n\n`;

    // Permission checking functions
    content += `// ============================================================================\n`;
    content += `// Permission Checking Functions\n`;
    content += `// ============================================================================\n`;
    content += `export function checkPermission(role: Role, permission: Permission): boolean {\n`;
    content += `  const rolePermissions = ROLE_PERMISSIONS[role] || [];\n`;
    content += `  return rolePermissions.includes(permission);\n`;
    content += `}\n\n`;

    content += `export function checkAnyPermission(role: Role, permissions: Permission[]): boolean {\n`;
    content += `  return permissions.some(permission => checkPermission(role, permission));\n`;
    content += `}\n\n`;

    content += `export function checkAllPermissions(role: Role, permissions: Permission[]): boolean {\n`;
    content += `  return permissions.every(permission => checkPermission(role, permission));\n`;
    content += `}\n\n`;

    // Role hierarchy checking
    content += `export function hasHigherOrEqualRole(userRole: Role, requiredRole: Role): boolean {\n`;
    content += `  const userLevel = ROLE_HIERARCHY[userRole] || 0;\n`;
    content += `  const requiredLevel = ROLE_HIERARCHY[requiredRole] || 0;\n`;
    content += `  return userLevel >= requiredLevel;\n`;
    content += `}\n\n`;

    // Tenant isolation check
    content += `export function checkTenantAccess(userTenantId: string, requiredTenantId: string): boolean {\n`;
    content += `  return userTenantId === requiredTenantId;\n`;
    content += `}\n\n`;

    // Main middleware factory
    content += `// ============================================================================\n`;
    content += `// Express Middleware Factories\n`;
    content += `// ============================================================================\n`;
    content += `export function requirePermission(permission: Permission) {\n`;
    content += `  return (req: Request, res: Response, next: NextFunction) => {\n`;
    content += `    try {\n`;
    content += `      const userRole = req.user?.role as Role;\n`;
    content += `      const userTenantId = req.user?.tenantId;\n`;
    content += `      \n`;
    content += `      if (!userRole) {\n`;
    content += `        res.status(401).json({ error: 'Unauthorized - No role assigned' });\n        return;\n`;
    content += `      }\n\n`;
    content += `      if (!userTenantId) {\n`;
    content += `        res.status(401).json({ error: 'Unauthorized - No tenant context' });\n        return;\n`;
    content += `      }\n\n`;
    content += `      if (!checkPermission(userRole, permission)) {\n`;
    content += `        res.status(403).json({ \n`;
    content += `          error: 'Forbidden - Insufficient permissions',\n`;
    content += `          required: permission,\n`;
    content += `          userRole\n`;
    content += `        });\n`;
    content += `        return;\n`;
    content += `      }\n\n`;
    content += `      next();\n`;
    content += `    } catch (error) {\n`;
    content += `      console.error('Permission check error:', error);\n`;
    content += `      res.status(500).json({ error: 'Internal server error' });\n`;
    content += `      return;\n`;
    content += `    }\n`;
    content += `  };\n`;
    content += `}\n\n`;

    // Role-specific middleware for each role
    for (const role of this.roles) {
      const functionName = `require${
        role.charAt(0) +
        role
          .slice(1)
          .toLowerCase()
          .replace(/_(.)/g, (_, letter) => letter.toUpperCase())
      }`;
      content += `export function ${functionName}() {\n`;
      content += `  return (req: Request, res: Response, next: NextFunction) => {\n`;
      content += `    try {\n`;
      content += `      const userRole = req.user?.role as Role;\n`;
      content += `      const userTenantId = req.user?.tenantId;\n`;
      content += `      \n`;
      content += `      if (!userRole || !userTenantId) {\n`;
      content += `        res.status(401).json({ error: 'Unauthorized - Missing authentication' });\n        return;\n`;
      content += `      }\n\n`;
  content += `      if (!hasHigherOrEqualRole(userRole, ROLES.${role})) {\n`;
  content += `        res.status(403).json({ \n`;
  content += `          error: 'Forbidden - ${role} role required',\n`;
  content += `          userRole,\n`;
  content += `          required: ROLES.${role}\n`;
  content += `        });\n`;
  content += `        return;\n`;
  content += `      }\n\n`;
      content += `      next();\n`;
      content += `    } catch (error) {\n`;
      content += `      console.error('Role check error:', error);\n`;
      content += `      res.status(500).json({ error: 'Internal server error' });\n      return;\n`;
      content += `    }\n`;
      content += `  };\n`;
      content += `}\n\n`;
    }

    return content;
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  private groupPermissionsByDomain(): Record<string, PermissionDefinition[]> {
    const grouped: Record<string, PermissionDefinition[]> = {};

    for (const perm of this.permissions) {
      const domain = perm.domain || "general";
      if (!grouped[domain]) {
        grouped[domain] = [];
      }
      grouped[domain].push(perm);
    }

    return grouped;
  }

  private permissionToKey(resource: string, action: string): string {
    return `${resource.toUpperCase()}_${action.toUpperCase()}`;
  }

  private permissionToIdParam(resource: string, action: string): string {
    return `permission_${resource.toLowerCase()}_${action.toLowerCase()}_id`;
  }

  private formatRoleName(role: string): string {
    return role
      .split("_")
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
      .join(" ");
  }

  private getRoleDescription(role: string): string {
    const descriptions: Record<string, string> = {
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
    return descriptions[role] || `Role for ${role.toLowerCase()}`;
  }

  // ============================================================================
  // MAIN GENERATION METHOD
  // ============================================================================
  generateFiles(): void {
    console.log("\n🏗️  Starting RBAC file generation...\n");

    const permissionsContent = this.generatePermissionsFile();
    const rolesContent = this.generateRolesFile();
    const middlewareContent = this.generateMiddlewareFile();
    const seedContent = this.generateSeedFile();

    // Create output directories
    const rbacDir = path.join(__dirname, "../../src/rbac");
    const middlewareDir = path.join(rbacDir, "middleware");
    const seedDir = path.join(__dirname, "../../prisma/seed");

    [rbacDir, middlewareDir, seedDir].forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`📁 Created directory: ${dir}`);
      }
    });

    // Write files
    const files = [
      {
        path: path.join(rbacDir, "permissions.ts"),
        content: permissionsContent,
      },
      { path: path.join(rbacDir, "roles.ts"), content: rolesContent },
      { path: path.join(middlewareDir, "rbac.ts"), content: middlewareContent },
      { path: path.join(seedDir, "rbac-v7.sql"), content: seedContent },
    ];

    files.forEach(({ path: filePath, content }) => {
      fs.writeFileSync(filePath, content);
      console.log(`✅ Generated: ${filePath}`);
    });

    console.log("\n🎉 RBAC files generated successfully!");
    console.log("\n📊 Summary:");
    console.log(`   - Roles: ${this.roles.length}`);
    console.log(`   - Permissions: ${this.permissions.length}`);
    console.log(`   - Files generated: ${files.length}`);
    console.log("\n🔄 Next steps:");
    console.log("   1. Run: tsx scripts/seed-rbac-v7.ts run");
    console.log("   2. Verify: tsx scripts/seed-rbac-v7.ts verify");
  }

  // ============================================================================
  // VALIDATION METHOD
  // ============================================================================
  validateSchema(): boolean {
    console.log("\n🔍 Validating RBAC schema...\n");

    let isValid = true;
    const issues: string[] = [];

    // Check if we have roles
    if (this.roles.length === 0) {
      issues.push("❌ No roles found in schema");
      isValid = false;
    } else {
      console.log(
        `✅ Found ${this.roles.length} roles: ${this.roles.join(", ")}`
      );
    }

    // Check if we have permissions
    if (this.permissions.length === 0) {
      issues.push("❌ No permissions found in schema");
      isValid = false;
    } else {
      console.log(`✅ Found ${this.permissions.length} permissions`);
    }

    // Check role-permission mappings
    for (const role of this.roles) {
      const rolePermissions = this.schema.roles[role] || [];
      if (rolePermissions.length === 0) {
        issues.push(`⚠️  Role ${role} has no permissions assigned`);
      } else {
        console.log(`✅ Role ${role}: ${rolePermissions.length} permissions`);
      }
    }

    // Check for orphaned permissions
    const usedPermissions = new Set<string>();
    Object.values(this.schema.roles).forEach((perms) =>
      perms.forEach((perm) => usedPermissions.add(perm))
    );

    const definedPermissions = new Set(
      this.permissions.map((p) => `${p.resource}.${p.action}`)
    );

    const orphaned = [...usedPermissions].filter(
      (perm) => !definedPermissions.has(perm)
    );
    if (orphaned.length > 0) {
      issues.push(
        `⚠️  Orphaned permissions (used but not defined): ${orphaned.join(
          ", "
        )}`
      );
    }

    const unused = [...definedPermissions].filter(
      (perm) => !usedPermissions.has(perm)
    );
    if (unused.length > 0) {
      console.log(
        `ℹ️  Unused permissions (defined but not assigned): ${unused.length} permissions`
      );
    }

    if (issues.length > 0) {
      console.log("\n🚨 Schema validation issues:");
      issues.forEach((issue) => console.log(`   ${issue}`));
    }

    if (isValid) {
      console.log("\n✅ Schema validation passed!");
    }

    return isValid;
  }
}

// ============================================================================
// CLI EXECUTION
// ============================================================================
if (import.meta.url === `file://${process.argv[1]}`) {
  const args = process.argv.slice(2);
  const command = args[0];

  try {
    const generator = new RBACGeneratorV7();

    switch (command) {
      case "validate":
        console.log("🔍 RBAC Schema Validation Mode\n");
        const isValid = generator.validateSchema();
        process.exit(isValid ? 0 : 1);

      case "generate":
      default:
        console.log("🏗️  RBAC Generator v7 - Enterprise Multi-Tenant ERP\n");

        if (!generator.validateSchema()) {
          console.log(
            "\n❌ Schema validation failed. Fix issues before generating files."
          );
          process.exit(1);
        }

        generator.generateFiles();
        break;
    }
  } catch (error) {
    console.error("❌ Error:", (error as Error).message);
    process.exit(1);
  }
}
