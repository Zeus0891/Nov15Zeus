/**
 * 🏛️ BeeSmart Pro RBAC Constants v8.2
 * Generated from rbac.schema.v8.2.yml
 * Generated: 2025-11-18T17:54:39.732Z
 *
 * ⚠️ DO NOT EDIT - This file is auto-generated
 * Update rbac.schema.v8.2.yml and regenerate instead
 */

// ============================================================================
// DOMAINS
// ============================================================================
export const RBAC_DOMAINS = {
  ACCESSCONTROL: "accesscontrol",
  AI: "ai",
  CRM: "crm",
  DOCUMENTS: "documents",
  ESTIMATE: "estimate",
  EXPENSES: "expenses",
  IDENTITY: "identity",
  INVENTORY: "inventory",
  INVOICE: "invoice",
  PAYROLL: "payroll",
  PROJECT: "project",
  SCHEDULING: "scheduling",
} as const;

export type RBACDomain = (typeof RBAC_DOMAINS)[keyof typeof RBAC_DOMAINS];

// ============================================================================
// ROLES
// ============================================================================
export const RBAC_ROLES = {
  ADMIN: "ADMIN",
  EXECUTIVE: "EXECUTIVE",
  PROJECT_MANAGER: "PROJECT_MANAGER",
  FINANCE_CONTROLLER: "FINANCE_CONTROLLER",
  HR_MANAGER: "HR_MANAGER",
  ESTIMATOR: "ESTIMATOR",
  ACCOUNTING: "ACCOUNTING",
  SCHEDULER: "SCHEDULER",
  INVENTORY_MANAGER: "INVENTORY_MANAGER",
  PAYROLL_MANAGER: "PAYROLL_MANAGER",
  CLIENT_OWNER: "CLIENT_OWNER",
  CLIENT_MANAGER: "CLIENT_MANAGER",
  VENDOR: "VENDOR",
  WORKER: "WORKER",
  CLIENT_VIEWER: "CLIENT_VIEWER",
  VIEWER: "VIEWER",
  GUEST: "GUEST",
} as const;

export type RBACRole = (typeof RBAC_ROLES)[keyof typeof RBAC_ROLES];

// ============================================================================
// ROLE HIERARCHY (0 = highest privilege)
// ============================================================================
export const RBAC_ROLE_HIERARCHY = {
  ADMIN: 0,
  EXECUTIVE: 1,
  PROJECT_MANAGER: 2,
  FINANCE_CONTROLLER: 2,
  HR_MANAGER: 3,
  ESTIMATOR: 4,
  ACCOUNTING: 5,
  SCHEDULER: 5,
  INVENTORY_MANAGER: 5,
  PAYROLL_MANAGER: 6,
  CLIENT_OWNER: 6,
  CLIENT_MANAGER: 7,
  VENDOR: 7,
  WORKER: 8,
  CLIENT_VIEWER: 8,
  VIEWER: 9,
  GUEST: 10,
} as const;

// ============================================================================
// ROLE METADATA
// ============================================================================
export const RBAC_ROLE_METADATA = {
  ADMIN: {
    code: "ADMIN",
    hierarchy: 0,
    displayName: "Administrator",
    description: "System administrator with full platform access",
    roleType: "INTERNAL",
    accessScope: "All systems and data",
  },
  EXECUTIVE: {
    code: "EXECUTIVE",
    hierarchy: 1,
    displayName: "Executive",
    description: "C-level executive with strategic oversight",
    roleType: "INTERNAL",
    accessScope: "Strategic reports and high-level operations",
  },
  PROJECT_MANAGER: {
    code: "PROJECT_MANAGER",
    hierarchy: 2,
    displayName: "Project Manager",
    description: "Project oversight and team management",
    roleType: "INTERNAL",
    accessScope: "Assigned projects and teams",
  },
  FINANCE_CONTROLLER: {
    code: "FINANCE_CONTROLLER",
    hierarchy: 2,
    displayName: "Finance Controller",
    description: "Financial oversight and approval authority",
    roleType: "INTERNAL",
    accessScope: "All financial data and approvals",
  },
  HR_MANAGER: {
    code: "HR_MANAGER",
    hierarchy: 3,
    displayName: "HR Manager",
    description: "Human resources and employee management",
    roleType: "INTERNAL",
    accessScope: "Employee data and HR processes",
  },
  ESTIMATOR: {
    code: "ESTIMATOR",
    hierarchy: 4,
    displayName: "Estimator",
    description: "Estimate creation and cost analysis",
    roleType: "INTERNAL",
    accessScope: "Estimates and pricing data",
  },
  ACCOUNTING: {
    code: "ACCOUNTING",
    hierarchy: 5,
    displayName: "Staff Accountant",
    description: "Accounting operations and transaction processing",
    roleType: "INTERNAL",
    accessScope: "Transaction-level financial data",
  },
  SCHEDULER: {
    code: "SCHEDULER",
    hierarchy: 5,
    displayName: "Scheduler",
    description: "Resource and time scheduling management",
    roleType: "INTERNAL",
    accessScope: "Scheduling and resource allocation",
  },
  INVENTORY_MANAGER: {
    code: "INVENTORY_MANAGER",
    hierarchy: 5,
    displayName: "Inventory Manager",
    description: "Materials and inventory management",
    roleType: "INTERNAL",
    accessScope: "Inventory and materials data",
  },
  PAYROLL_MANAGER: {
    code: "PAYROLL_MANAGER",
    hierarchy: 6,
    displayName: "Payroll Manager",
    description: "Payroll processing and management",
    roleType: "INTERNAL",
    accessScope: "Payroll and compensation data",
  },
  CLIENT_OWNER: {
    code: "CLIENT_OWNER",
    hierarchy: 6,
    displayName: "Client Owner",
    description: "Client company owner with project oversight",
    roleType: "EXTERNAL",
    accessScope: "Own projects and invoices",
  },
  CLIENT_MANAGER: {
    code: "CLIENT_MANAGER",
    hierarchy: 7,
    displayName: "Client Manager",
    description: "Client project management and coordination",
    roleType: "EXTERNAL",
    accessScope: "Assigned projects and documentation",
  },
  VENDOR: {
    code: "VENDOR",
    hierarchy: 7,
    displayName: "Vendor/Supplier",
    description: "External vendor or supplier access",
    roleType: "EXTERNAL",
    accessScope: "Relevant purchase orders and contracts",
  },
  WORKER: {
    code: "WORKER",
    hierarchy: 8,
    displayName: "Field Worker",
    description: "Field operations and task execution",
    roleType: "INTERNAL",
    accessScope: "Assigned tasks and personal records",
  },
  CLIENT_VIEWER: {
    code: "CLIENT_VIEWER",
    hierarchy: 8,
    displayName: "Client Viewer",
    description: "Client stakeholder with limited access",
    roleType: "EXTERNAL",
    accessScope: "Public project information",
  },
  VIEWER: {
    code: "VIEWER",
    hierarchy: 9,
    displayName: "Internal Viewer",
    description: "Read-only access for internal stakeholders",
    roleType: "INTERNAL",
    accessScope: "Limited read-only access",
  },
  GUEST: {
    code: "GUEST",
    hierarchy: 10,
    displayName: "Guest User",
    description: "Temporary or demo access",
    roleType: "EXTERNAL",
    accessScope: "Demo/sandbox environment only",
  },
} as const;

// ============================================================================
// PERMISSIONS
// ============================================================================
export const RBAC_PERMISSIONS = {
  ACCESSCONTROL_ASSIGN: "accesscontrol:assign",
  ACCESSCONTROL_CREATE: "accesscontrol:create",
  ACCESSCONTROL_DELETE: "accesscontrol:delete",
  ACCESSCONTROL_READ: "accesscontrol:read",
  ACCESSCONTROL_REVOKE: "accesscontrol:revoke",
  ACCESSCONTROL_UPDATE: "accesscontrol:update",
  AI_ANALYZE: "ai:analyze",
  AI_PROCESS: "ai:process",
  AI_READ: "ai:read",
  CRM_CREATE: "crm:create",
  CRM_DELETE: "crm:delete",
  CRM_EXPORT: "crm:export",
  CRM_IMPORT: "crm:import",
  CRM_READ: "crm:read",
  CRM_UPDATE: "crm:update",
  DOCUMENTS_CREATE: "documents:create",
  DOCUMENTS_DELETE: "documents:delete",
  DOCUMENTS_EXPORT: "documents:export",
  DOCUMENTS_READ: "documents:read",
  DOCUMENTS_READ_ASSIGNED: "documents:read:assigned",
  DOCUMENTS_READ_PUBLIC: "documents:read:public",
  DOCUMENTS_UPDATE: "documents:update",
  ESTIMATE_APPROVE: "estimate:approve",
  ESTIMATE_CONVERT: "estimate:convert",
  ESTIMATE_CREATE: "estimate:create",
  ESTIMATE_DELETE: "estimate:delete",
  ESTIMATE_EXPORT: "estimate:export",
  ESTIMATE_READ: "estimate:read",
  ESTIMATE_READ_OWN: "estimate:read:own",
  ESTIMATE_REJECT: "estimate:reject",
  ESTIMATE_SEND: "estimate:send",
  ESTIMATE_UPDATE: "estimate:update",
  ESTIMATE_UPDATE_STATUS: "estimate:update:status",
  EXPENSES_APPROVE: "expenses:approve",
  EXPENSES_CREATE: "expenses:create",
  EXPENSES_CREATE_OWN: "expenses:create:own",
  EXPENSES_DELETE: "expenses:delete",
  EXPENSES_READ: "expenses:read",
  EXPENSES_READ_OWN: "expenses:read:own",
  EXPENSES_REJECT: "expenses:reject",
  EXPENSES_UPDATE: "expenses:update",
  EXPENSES_UPDATE_OWN: "expenses:update:own",
  IDENTITY_CREATE: "identity:create",
  IDENTITY_DELETE: "identity:delete",
  IDENTITY_READ: "identity:read",
  IDENTITY_READ_OWN: "identity:read:own",
  IDENTITY_UPDATE: "identity:update",
  IDENTITY_UPDATE_OWN: "identity:update:own",
  INVENTORY_ADJUST: "inventory:adjust",
  INVENTORY_ADJUST_QUANTITY: "inventory:adjust:quantity",
  INVENTORY_ASSIGN: "inventory:assign",
  INVENTORY_CREATE: "inventory:create",
  INVENTORY_PROCESS: "inventory:process",
  INVENTORY_READ: "inventory:read",
  INVENTORY_RECONCILE: "inventory:reconcile",
  INVENTORY_UPDATE: "inventory:update",
  INVOICE_APPROVE: "invoice:approve",
  INVOICE_CREATE: "invoice:create",
  INVOICE_DELETE: "invoice:delete",
  INVOICE_EXPORT: "invoice:export",
  INVOICE_PAY: "invoice:pay",
  INVOICE_READ: "invoice:read",
  INVOICE_READ_OWN: "invoice:read:own",
  INVOICE_SEND: "invoice:send",
  INVOICE_UPDATE: "invoice:update",
  INVOICE_UPDATE_STATUS: "invoice:update:status",
  PAYROLL_APPROVE: "payroll:approve",
  PAYROLL_CREATE: "payroll:create",
  PAYROLL_EXPORT: "payroll:export",
  PAYROLL_PROCESS: "payroll:process",
  PAYROLL_READ: "payroll:read",
  PAYROLL_READ_OWN: "payroll:read:own",
  PAYROLL_UPDATE: "payroll:update",
  PROJECT_ASSIGN: "project:assign",
  PROJECT_ASSIGN_EMPLOYEE: "project:assign:employee",
  PROJECT_CLOSE: "project:close",
  PROJECT_CREATE: "project:create",
  PROJECT_DELETE: "project:delete",
  PROJECT_READ: "project:read",
  PROJECT_READ_ASSIGNED: "project:read:assigned",
  PROJECT_REOPEN: "project:reopen",
  PROJECT_UPDATE: "project:update",
  PROJECT_UPDATE_BUDGET: "project:update:budget",
  PROJECT_UPDATE_STATUS: "project:update:status",
  SCHEDULING_ASSIGN: "scheduling:assign",
  SCHEDULING_CREATE: "scheduling:create",
  SCHEDULING_DELETE: "scheduling:delete",
  SCHEDULING_READ: "scheduling:read",
  SCHEDULING_READ_OWN: "scheduling:read:own",
  SCHEDULING_UPDATE: "scheduling:update",
  SCHEDULING_UPDATE_OWN: "scheduling:update:own",
} as const;

export type RBACPermission =
  (typeof RBAC_PERMISSIONS)[keyof typeof RBAC_PERMISSIONS];

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/**
 * Check if a role has higher or equal privilege than another role
 * (Lower hierarchy number = higher privilege)
 */
export function hasHigherOrEqualPrivilege(
  userRole: RBACRole,
  requiredRole: RBACRole
): boolean {
  const userHierarchy = RBAC_ROLE_HIERARCHY[userRole];
  const requiredHierarchy = RBAC_ROLE_HIERARCHY[requiredRole];
  return userHierarchy <= requiredHierarchy;
}

/**
 * Validate permission format (domain:action or domain:action:subaction)
 */
export function isValidPermissionFormat(permission: string): boolean {
  const parts = permission.split(":");
  return (
    parts.length >= 2 &&
    parts.length <= 3 &&
    parts.every((part) => part.length > 0)
  );
}

/**
 * Parse permission into components
 */
export function parsePermission(permission: string): {
  domain: string;
  action: string;
  subaction?: string;
} | null {
  if (!isValidPermissionFormat(permission)) return null;
  const [domain, action, subaction] = permission.split(":");
  return { domain, action, subaction };
}

// ============================================================================
// SCHEMA STATISTICS
// ============================================================================
export const RBAC_STATS = {
  version: "8.2",
  generatedAt: "2025-11-18T17:54:39.733Z",
  totalDomains: 12,
  totalRoles: 17,
  totalPermissions: 91,
  hierarchyRange: "0-10",
  namingConvention: "domain:action:subaction",
} as const;
