/**
 * 🏛️ RBAC Constants v8.3 - Phase 1 Generated
 * BeeSmart Pro Construction ERP
 *
 * Generated from: rbac.schema.v8.3.yml
 * Generated on: 2025-11-18T20:32:50.523Z
 *
 * PHASE 1 SCOPE:
 * - 5 active internal roles
 * - 10 total roles (including external)
 * - 137 total permissions
 * - Baseline permissions only (critical permissions via TenantSettings)
 */

// ============================================================================
// ROLE ENUMS
// ============================================================================

/**
 * Phase 1 Active Internal Roles
 */
export enum ActiveInternalRole {
  ADMIN = 'ADMIN',
  PROJECT_MANAGER = 'PROJECT_MANAGER',
  WORKER = 'WORKER',
  DRIVER = 'DRIVER',
  VIEWER = 'VIEWER',
}

/**
 * All Roles (Internal + External)
 */
export enum RoleType {
  ADMIN = 'ADMIN',
  PROJECT_MANAGER = 'PROJECT_MANAGER',
  WORKER = 'WORKER',
  DRIVER = 'DRIVER',
  VIEWER = 'VIEWER',
  CLIENT_OWNER = 'CLIENT_OWNER',
  CLIENT_MANAGER = 'CLIENT_MANAGER',
  CLIENT_VIEWER = 'CLIENT_VIEWER',
  VENDOR = 'VENDOR',
  GUEST = 'GUEST',
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
  TENANT_READ = 'tenant:read',
  TENANT_UPDATE = 'tenant:update',
  TENANT_MANAGE_MODULES = 'tenant:manage:modules',
  TENANT_MANAGE_FEATURES = 'tenant:manage:features',
  IDENTITY_INVITE_USER = 'identity:invite:user',
  IDENTITY_READ_TENANT_USERS = 'identity:read:tenant_users',
  IDENTITY_UPDATE_TENANT_USERS = 'identity:update:tenant_users',
  IDENTITY_READ_OWN = 'identity:read:own',
  IDENTITY_UPDATE_OWN = 'identity:update:own',
  MEMBERSHIP_MANAGE_ROLES = 'membership:manage:roles',
  MEMBERSHIP_READ_TENANT_MEMBERS = 'membership:read:tenant_members',
  MEMBERSHIP_UPDATE_TENANT_MEMBERS = 'membership:update:tenant_members',
  ACCESSCONTROL_READ = 'accesscontrol:read',
  ACCESSCONTROL_UPDATE_TENANT_ROLES = 'accesscontrol:update:tenant_roles',
  ACCESSCONTROL_MANAGE_SERVICE_ACCOUNTS = 'accesscontrol:manage:service_accounts',
  ESTIMATE_CREATE = 'estimate:create',
  ESTIMATE_LIST = 'estimate:list',
  ESTIMATE_READ = 'estimate:read',
  ESTIMATE_UPDATE = 'estimate:update',
  ESTIMATE_SEND = 'estimate:send',
  ESTIMATE_LIST_OWN = 'estimate:list:own',
  ESTIMATE_READ_OWN = 'estimate:read:own',
  ESTIMATE_UPDATE_OWN = 'estimate:update:own',
  ESTIMATE_SEND_OWN = 'estimate:send:own',
  ESTIMATE_DELETE = 'estimate:delete',
  ESTIMATE_APPROVE = 'estimate:approve',
  ESTIMATE_DELETE_OWN = 'estimate:delete:own',
  ESTIMATE_READ_PROFIT = 'estimate:read:profit',
  INVOICE_CREATE = 'invoice:create',
  INVOICE_LIST = 'invoice:list',
  INVOICE_READ = 'invoice:read',
  INVOICE_UPDATE = 'invoice:update',
  INVOICE_SEND = 'invoice:send',
  INVOICE_LIST_OWN = 'invoice:list:own',
  INVOICE_READ_OWN = 'invoice:read:own',
  INVOICE_UPDATE_OWN = 'invoice:update:own',
  INVOICE_SEND_OWN = 'invoice:send:own',
  INVOICE_DELETE = 'invoice:delete',
  INVOICE_APPROVE = 'invoice:approve',
  INVOICE_WRITEOFF = 'invoice:writeoff',
  INVOICE_DELETE_OWN = 'invoice:delete:own',
  INVOICE_READ_PROFIT = 'invoice:read:profit',
  PROJECT_CREATE = 'project:create',
  PROJECT_LIST = 'project:list',
  PROJECT_READ = 'project:read',
  PROJECT_UPDATE = 'project:update',
  PROJECT_ASSIGN_PM = 'project:assign:pm',
  PROJECT_ASSIGN_WORKER = 'project:assign:worker',
  PROJECT_ASSIGN_DRIVER = 'project:assign:driver',
  PROJECT_CREATE_OWN = 'project:create:own',
  PROJECT_LIST_OWN = 'project:list:own',
  PROJECT_READ_OWN = 'project:read:own',
  PROJECT_UPDATE_OWN = 'project:update:own',
  PROJECT_READ_TEAM = 'project:read:team',
  PROJECT_READ_SCHEDULE = 'project:read:schedule',
  PROJECT_LIST_ASSIGNED = 'project:list:assigned',
  PROJECT_READ_ASSIGNED = 'project:read:assigned',
  PROJECT_LIST_DELIVERY_ASSIGNED = 'project:list:delivery_assigned',
  PROJECT_READ_DELIVERY_INFO = 'project:read:delivery_info',
  PROJECT_DELETE = 'project:delete',
  PROJECT_READ_FINANCIAL = 'project:read:financial',
  TASK_CREATE = 'task:create',
  TASK_LIST = 'task:list',
  TASK_READ = 'task:read',
  TASK_UPDATE = 'task:update',
  TASK_DELETE = 'task:delete',
  TASK_ASSIGN_WORKER = 'task:assign:worker',
  TASK_ASSIGN_DRIVER = 'task:assign:driver',
  TASK_CREATE_PROJECT = 'task:create:project',
  TASK_LIST_PROJECT = 'task:list:project',
  TASK_READ_PROJECT = 'task:read:project',
  TASK_UPDATE_PROJECT = 'task:update:project',
  TASK_LIST_ASSIGNED = 'task:list:assigned',
  TASK_READ_ASSIGNED = 'task:read:assigned',
  TASK_UPDATE_OWN = 'task:update:own',
  TASK_LIST_DELIVERY = 'task:list:delivery',
  TASK_READ_DELIVERY = 'task:read:delivery',
  TASK_UPDATE_DELIVERY = 'task:update:delivery',
  EXPENSES_CREATE = 'expenses:create',
  EXPENSES_LIST = 'expenses:list',
  EXPENSES_READ = 'expenses:read',
  EXPENSES_UPDATE = 'expenses:update',
  EXPENSES_DELETE = 'expenses:delete',
  EXPENSES_APPROVE = 'expenses:approve',
  EXPENSES_LIST_PROJECT = 'expenses:list:project',
  EXPENSES_READ_PROJECT = 'expenses:read:project',
  EXPENSES_CREATE_OWN = 'expenses:create:own',
  EXPENSES_LIST_OWN = 'expenses:list:own',
  EXPENSES_READ_OWN = 'expenses:read:own',
  EXPENSES_CREATE_DELIVERY = 'expenses:create:delivery',
  TIME_READ_TENANT = 'time:read:tenant',
  TIME_CORRECT_TENANT = 'time:correct:tenant',
  TIME_READ_OWN = 'time:read:own',
  TIME_CREATE_OWN_ENTRY = 'time:create:own_entry',
  SCHEDULING_CREATE = 'scheduling:create',
  SCHEDULING_READ = 'scheduling:read',
  SCHEDULING_UPDATE = 'scheduling:update',
  SCHEDULING_READ_OWN = 'scheduling:read:own',
  PAYROLL_READ_TENANT = 'payroll:read:tenant',
  PAYROLL_RUN = 'payroll:run',
  PAYROLL_UPDATE = 'payroll:update',
  PAYROLL_READ_OWN = 'payroll:read:own',
  INVENTORY_CREATE_ITEM = 'inventory:create:item',
  INVENTORY_LIST = 'inventory:list',
  INVENTORY_READ = 'inventory:read',
  INVENTORY_UPDATE_ITEM = 'inventory:update:item',
  INVENTORY_ADJUST_QUANTITY = 'inventory:adjust:quantity',
  INVENTORY_INVESTIGATE_LOSS = 'inventory:investigate:loss',
  INVENTORY_READ_DELIVERY_ITEMS = 'inventory:read:delivery_items',
  CRM_CREATE = 'crm:create',
  CRM_LIST = 'crm:list',
  CRM_READ = 'crm:read',
  CRM_UPDATE = 'crm:update',
  CRM_DELETE = 'crm:delete',
  DOCUMENTS_CREATE = 'documents:create',
  DOCUMENTS_LIST = 'documents:list',
  DOCUMENTS_READ = 'documents:read',
  DOCUMENTS_UPDATE = 'documents:update',
  DOCUMENTS_DELETE = 'documents:delete',
  DOCUMENTS_LIST_PROJECT = 'documents:list:project',
  DOCUMENTS_READ_PROJECT = 'documents:read:project',
  DOCUMENTS_UPLOAD_PROJECT = 'documents:upload:project',
  DOCUMENTS_COMMENT_PROJECT = 'documents:comment:project',
  DOCUMENTS_LIST_ASSIGNED = 'documents:list:assigned',
  DOCUMENTS_READ_ASSIGNED = 'documents:read:assigned',
  DOCUMENTS_UPLOAD_ASSIGNED = 'documents:upload:assigned',
  DOCUMENTS_UPLOAD_DELIVERY = 'documents:upload:delivery',
  DOCUMENTS_READ_DELIVERY = 'documents:read:delivery',
  AI_ASK = 'ai:ask',
  AI_ASSIST_TENANT = 'ai:assist:tenant',
  AI_GENERATE_FINANCIAL_REPORT = 'ai:generate:financial_report',
  AI_GENERATE_PROJECT_REPORT = 'ai:generate:project_report',
  AI_ASSIST_PROJECT = 'ai:assist:project',
  AI_ASSIST_TASK = 'ai:assist:task',
  AI_ASSIST_DELIVERY = 'ai:assist:delivery',
  AI_GENERATE_DEMO_REPORT = 'ai:generate:demo_report',
  ANALYTICS_READ_TENANT_KPIS = 'analytics:read:tenant_kpis',
}

/**
 * Permission Domains
 */
export enum Domain {
  TENANT = 'tenant',
  IDENTITY = 'identity',
  MEMBERSHIP = 'membership',
  ACCESSCONTROL = 'accesscontrol',
  ESTIMATE = 'estimate',
  INVOICE = 'invoice',
  PROJECT = 'project',
  TASK = 'task',
  EXPENSES = 'expenses',
  TIME = 'time',
  SCHEDULING = 'scheduling',
  PAYROLL = 'payroll',
  INVENTORY = 'inventory',
  CRM = 'crm',
  DOCUMENTS = 'documents',
  AI = 'ai',
  ANALYTICS = 'analytics',
}

// ============================================================================
// ROLE HIERARCHY MAP
// ============================================================================

/**
 * Role Hierarchy (0 = highest privilege)
 */
export const ROLE_HIERARCHY: Record<RoleType, number> = {
  [RoleType.ADMIN]: 0,
  [RoleType.PROJECT_MANAGER]: 2,
  [RoleType.WORKER]: 8,
  [RoleType.DRIVER]: 9,
  [RoleType.VIEWER]: 10,
  [RoleType.CLIENT_OWNER]: 6,
  [RoleType.CLIENT_MANAGER]: 7,
  [RoleType.CLIENT_VIEWER]: 8,
  [RoleType.VENDOR]: 7,
  [RoleType.GUEST]: 10,
};

/**
 * Active Internal Role Hierarchy
 */
export const ACTIVE_INTERNAL_ROLE_HIERARCHY: Record<ActiveInternalRole, number> = {
  [ActiveInternalRole.ADMIN]: 0,
  [ActiveInternalRole.PROJECT_MANAGER]: 2,
  [ActiveInternalRole.WORKER]: 8,
  [ActiveInternalRole.DRIVER]: 9,
  [ActiveInternalRole.VIEWER]: 10,
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
  [RoleType.ADMIN]: {
        "code": "ADMIN",
        "hierarchy": 0,
        "display_name": "Administrator",
        "description": "Tenant owner with full CRUD on all tenant data, no platform/system power",
        "role_type": "INTERNAL",
        "phase1_status": "ACTIVE",
        "business_context": {
            "typical_users": [
                "Tenant Owners",
                "Company Owners",
                "Business Administrators"
            ],
            "access_scope": "All tenant business data and configuration",
            "use_cases": [
                "Tenant management",
                "User administration",
                "Full business operations"
            ],
            "financial_scope": "Complete tenant financial visibility and control"
        }
    },
  [RoleType.PROJECT_MANAGER]: {
        "code": "PROJECT_MANAGER",
        "hierarchy": 2,
        "display_name": "Project Manager",
        "description": "Broad but scoped access to own/assigned projects, critical actions gated by TenantSettings",
        "role_type": "INTERNAL",
        "phase1_status": "ACTIVE",
        "business_context": {
            "typical_users": [
                "Project Managers",
                "Construction Managers",
                "Site Supervisors"
            ],
            "access_scope": "Own/assigned projects, estimates, invoices, tasks",
            "use_cases": [
                "Project execution",
                "Team coordination",
                "Client communication"
            ],
            "financial_scope": "Project-level financial visibility, no tenant-wide profit/KPIs",
            "critical_note": "Approval and financial insight permissions gated by TenantSettings"
        }
    },
  [RoleType.WORKER]: {
        "code": "WORKER",
        "hierarchy": 8,
        "display_name": "Worker",
        "description": "Execution role for tasks, own time/expenses, assigned project visibility only",
        "role_type": "INTERNAL",
        "phase1_status": "ACTIVE",
        "business_context": {
            "typical_users": [
                "Field Workers",
                "Technicians",
                "Office Staff",
                "Contractors"
            ],
            "access_scope": "Assigned tasks, own time/expenses, assigned project operational details",
            "use_cases": [
                "Task execution",
                "Time tracking",
                "Progress reporting",
                "Expense submission"
            ],
            "financial_scope": "No financial data access"
        }
    },
  [RoleType.DRIVER]: {
        "code": "DRIVER",
        "hierarchy": 9,
        "display_name": "Driver",
        "description": "Delivery/logistics role with minimal project info and delivery task focus",
        "role_type": "INTERNAL",
        "phase1_status": "ACTIVE",
        "business_context": {
            "typical_users": [
                "Delivery Drivers",
                "Logistics Staff",
                "Couriers",
                "Delivery Personnel"
            ],
            "access_scope": "Delivery tasks, delivery project info, own time/expenses, delivery docs",
            "use_cases": [
                "Delivery execution",
                "Basic time logging",
                "Delivery documentation"
            ],
            "financial_scope": "No financial data access"
        }
    },
  [RoleType.VIEWER]: {
        "code": "VIEWER",
        "hierarchy": 10,
        "display_name": "Viewer",
        "description": "Read-only sandbox-only role for demo/training, NEVER for production tenants",
        "role_type": "INTERNAL",
        "phase1_status": "ACTIVE",
        "business_context": {
            "typical_users": [
                "Demo Users",
                "Trainees",
                "Prospects",
                "Evaluators"
            ],
            "access_scope": "Read-only access in sandbox tenants ONLY",
            "use_cases": [
                "Product demonstration",
                "Training",
                "System evaluation"
            ],
            "financial_scope": "Demo financial data only (sandbox environment)",
            "enforcement_critical": "MUST be enforced via RLS - no production tenant access allowed"
        }
    },
  [RoleType.CLIENT_OWNER]: {
        "code": "CLIENT_OWNER",
        "hierarchy": 6,
        "display_name": "Client Owner",
        "description": "Client company owner with project oversight",
        "role_type": "EXTERNAL",
        "phase1_status": "PRESERVED"
    },
  [RoleType.CLIENT_MANAGER]: {
        "code": "CLIENT_MANAGER",
        "hierarchy": 7,
        "display_name": "Client Manager",
        "description": "Client project management and coordination",
        "role_type": "EXTERNAL",
        "phase1_status": "PRESERVED"
    },
  [RoleType.CLIENT_VIEWER]: {
        "code": "CLIENT_VIEWER",
        "hierarchy": 8,
        "display_name": "Client Viewer",
        "description": "Client stakeholder with limited access",
        "role_type": "EXTERNAL",
        "phase1_status": "PRESERVED"
    },
  [RoleType.VENDOR]: {
        "code": "VENDOR",
        "hierarchy": 7,
        "display_name": "Vendor/Supplier",
        "description": "External vendor or supplier access",
        "role_type": "EXTERNAL",
        "phase1_status": "PRESERVED"
    },
  [RoleType.GUEST]: {
        "code": "GUEST",
        "hierarchy": 10,
        "display_name": "Guest User",
        "description": "Temporary or demo access",
        "role_type": "EXTERNAL",
        "phase1_status": "PRESERVED"
    },
};

// ============================================================================
// ROLE PERMISSIONS MAP
// ============================================================================

/**
 * Role Permissions (Baseline Only)
 */
export const ROLE_PERMISSIONS: Record<string, Permission[]> = {
  'ADMIN': [
    Permission.TENANT_READ,
    Permission.TENANT_UPDATE,
    Permission.TENANT_MANAGE_MODULES,
    Permission.TENANT_MANAGE_FEATURES,
    Permission.IDENTITY_INVITE_USER,
    Permission.IDENTITY_READ_TENANT_USERS,
    Permission.IDENTITY_UPDATE_TENANT_USERS,
    Permission.IDENTITY_READ_OWN,
    Permission.IDENTITY_UPDATE_OWN,
    Permission.MEMBERSHIP_MANAGE_ROLES,
    Permission.MEMBERSHIP_READ_TENANT_MEMBERS,
    Permission.MEMBERSHIP_UPDATE_TENANT_MEMBERS,
    Permission.ACCESSCONTROL_READ,
    Permission.ACCESSCONTROL_UPDATE_TENANT_ROLES,
    Permission.ACCESSCONTROL_MANAGE_SERVICE_ACCOUNTS,
    Permission.ESTIMATE_CREATE,
    Permission.ESTIMATE_LIST,
    Permission.ESTIMATE_READ,
    Permission.ESTIMATE_UPDATE,
    Permission.ESTIMATE_DELETE,
    Permission.ESTIMATE_SEND,
    Permission.ESTIMATE_APPROVE,
    Permission.ESTIMATE_LIST_OWN,
    Permission.ESTIMATE_READ_OWN,
    Permission.ESTIMATE_UPDATE_OWN,
    Permission.ESTIMATE_SEND_OWN,
    Permission.ESTIMATE_DELETE_OWN,
    Permission.ESTIMATE_READ_PROFIT,
    Permission.INVOICE_CREATE,
    Permission.INVOICE_LIST,
    Permission.INVOICE_READ,
    Permission.INVOICE_UPDATE,
    Permission.INVOICE_DELETE,
    Permission.INVOICE_SEND,
    Permission.INVOICE_APPROVE,
    Permission.INVOICE_WRITEOFF,
    Permission.INVOICE_LIST_OWN,
    Permission.INVOICE_READ_OWN,
    Permission.INVOICE_UPDATE_OWN,
    Permission.INVOICE_SEND_OWN,
    Permission.INVOICE_DELETE_OWN,
    Permission.INVOICE_READ_PROFIT,
    Permission.PROJECT_CREATE,
    Permission.PROJECT_LIST,
    Permission.PROJECT_READ,
    Permission.PROJECT_UPDATE,
    Permission.PROJECT_DELETE,
    Permission.PROJECT_ASSIGN_PM,
    Permission.PROJECT_ASSIGN_WORKER,
    Permission.PROJECT_ASSIGN_DRIVER,
    Permission.PROJECT_READ_FINANCIAL,
    Permission.PROJECT_CREATE_OWN,
    Permission.PROJECT_LIST_OWN,
    Permission.PROJECT_READ_OWN,
    Permission.PROJECT_UPDATE_OWN,
    Permission.PROJECT_READ_TEAM,
    Permission.PROJECT_READ_SCHEDULE,
    Permission.TASK_CREATE,
    Permission.TASK_LIST,
    Permission.TASK_READ,
    Permission.TASK_UPDATE,
    Permission.TASK_DELETE,
    Permission.TASK_ASSIGN_WORKER,
    Permission.TASK_ASSIGN_DRIVER,
    Permission.TASK_CREATE_PROJECT,
    Permission.TASK_LIST_PROJECT,
    Permission.TASK_READ_PROJECT,
    Permission.TASK_UPDATE_PROJECT,
    Permission.EXPENSES_CREATE,
    Permission.EXPENSES_LIST,
    Permission.EXPENSES_READ,
    Permission.EXPENSES_UPDATE,
    Permission.EXPENSES_DELETE,
    Permission.EXPENSES_APPROVE,
    Permission.EXPENSES_LIST_PROJECT,
    Permission.EXPENSES_READ_PROJECT,
    Permission.TIME_READ_TENANT,
    Permission.TIME_CORRECT_TENANT,
    Permission.TIME_READ_OWN,
    Permission.TIME_CREATE_OWN_ENTRY,
    Permission.SCHEDULING_CREATE,
    Permission.SCHEDULING_READ,
    Permission.SCHEDULING_UPDATE,
    Permission.SCHEDULING_READ_OWN,
    Permission.PAYROLL_READ_TENANT,
    Permission.PAYROLL_RUN,
    Permission.PAYROLL_UPDATE,
    Permission.PAYROLL_READ_OWN,
    Permission.INVENTORY_CREATE_ITEM,
    Permission.INVENTORY_LIST,
    Permission.INVENTORY_READ,
    Permission.INVENTORY_UPDATE_ITEM,
    Permission.INVENTORY_ADJUST_QUANTITY,
    Permission.INVENTORY_INVESTIGATE_LOSS,
    Permission.CRM_CREATE,
    Permission.CRM_LIST,
    Permission.CRM_READ,
    Permission.CRM_UPDATE,
    Permission.CRM_DELETE,
    Permission.DOCUMENTS_CREATE,
    Permission.DOCUMENTS_LIST,
    Permission.DOCUMENTS_READ,
    Permission.DOCUMENTS_UPDATE,
    Permission.DOCUMENTS_DELETE,
    Permission.DOCUMENTS_LIST_PROJECT,
    Permission.DOCUMENTS_READ_PROJECT,
    Permission.DOCUMENTS_UPLOAD_PROJECT,
    Permission.DOCUMENTS_COMMENT_PROJECT,
    Permission.AI_ASK,
    Permission.AI_ASSIST_TENANT,
    Permission.AI_GENERATE_FINANCIAL_REPORT,
    Permission.AI_GENERATE_PROJECT_REPORT,
    Permission.AI_ASSIST_PROJECT,
    Permission.ANALYTICS_READ_TENANT_KPIS,
  ],
  'PROJECT_MANAGER': [
    Permission.IDENTITY_READ_OWN,
    Permission.IDENTITY_UPDATE_OWN,
    Permission.ESTIMATE_CREATE,
    Permission.ESTIMATE_LIST_OWN,
    Permission.ESTIMATE_READ_OWN,
    Permission.ESTIMATE_UPDATE_OWN,
    Permission.ESTIMATE_SEND_OWN,
    Permission.INVOICE_CREATE,
    Permission.INVOICE_LIST_OWN,
    Permission.INVOICE_READ_OWN,
    Permission.INVOICE_UPDATE_OWN,
    Permission.INVOICE_SEND_OWN,
    Permission.PROJECT_CREATE_OWN,
    Permission.PROJECT_LIST_OWN,
    Permission.PROJECT_READ_OWN,
    Permission.PROJECT_UPDATE_OWN,
    Permission.PROJECT_ASSIGN_WORKER,
    Permission.PROJECT_ASSIGN_DRIVER,
    Permission.PROJECT_READ_TEAM,
    Permission.PROJECT_READ_SCHEDULE,
    Permission.TASK_CREATE_PROJECT,
    Permission.TASK_LIST_PROJECT,
    Permission.TASK_READ_PROJECT,
    Permission.TASK_UPDATE_PROJECT,
    Permission.TASK_ASSIGN_WORKER,
    Permission.TASK_ASSIGN_DRIVER,
    Permission.EXPENSES_LIST_PROJECT,
    Permission.EXPENSES_READ_PROJECT,
    Permission.TIME_READ_OWN,
    Permission.TIME_CREATE_OWN_ENTRY,
    Permission.PAYROLL_READ_OWN,
    Permission.SCHEDULING_READ_OWN,
    Permission.DOCUMENTS_LIST_PROJECT,
    Permission.DOCUMENTS_READ_PROJECT,
    Permission.DOCUMENTS_UPLOAD_PROJECT,
    Permission.DOCUMENTS_COMMENT_PROJECT,
    Permission.AI_ASK,
    Permission.AI_ASSIST_PROJECT,
    Permission.AI_GENERATE_PROJECT_REPORT,
  ],
  'WORKER': [
    Permission.IDENTITY_READ_OWN,
    Permission.IDENTITY_UPDATE_OWN,
    Permission.PROJECT_LIST_ASSIGNED,
    Permission.PROJECT_READ_ASSIGNED,
    Permission.TASK_LIST_ASSIGNED,
    Permission.TASK_READ_ASSIGNED,
    Permission.TASK_UPDATE_OWN,
    Permission.EXPENSES_CREATE_OWN,
    Permission.EXPENSES_LIST_OWN,
    Permission.EXPENSES_READ_OWN,
    Permission.TIME_READ_OWN,
    Permission.TIME_CREATE_OWN_ENTRY,
    Permission.SCHEDULING_READ_OWN,
    Permission.DOCUMENTS_LIST_ASSIGNED,
    Permission.DOCUMENTS_READ_ASSIGNED,
    Permission.DOCUMENTS_UPLOAD_ASSIGNED,
    Permission.AI_ASK,
    Permission.AI_ASSIST_TASK,
  ],
  'DRIVER': [
    Permission.IDENTITY_READ_OWN,
    Permission.IDENTITY_UPDATE_OWN,
    Permission.PROJECT_LIST_DELIVERY_ASSIGNED,
    Permission.PROJECT_READ_DELIVERY_INFO,
    Permission.TASK_LIST_DELIVERY,
    Permission.TASK_READ_DELIVERY,
    Permission.TASK_UPDATE_DELIVERY,
    Permission.INVENTORY_READ_DELIVERY_ITEMS,
    Permission.EXPENSES_CREATE_DELIVERY,
    Permission.EXPENSES_LIST_OWN,
    Permission.EXPENSES_READ_OWN,
    Permission.TIME_READ_OWN,
    Permission.TIME_CREATE_OWN_ENTRY,
    Permission.SCHEDULING_READ_OWN,
    Permission.DOCUMENTS_UPLOAD_DELIVERY,
    Permission.DOCUMENTS_READ_DELIVERY,
    Permission.AI_ASK,
    Permission.AI_ASSIST_DELIVERY,
  ],
  'VIEWER': [
    Permission.ESTIMATE_READ,
    Permission.ESTIMATE_LIST,
    Permission.INVOICE_READ,
    Permission.INVOICE_LIST,
    Permission.PROJECT_READ,
    Permission.PROJECT_LIST,
    Permission.CRM_READ,
    Permission.CRM_LIST,
    Permission.INVENTORY_READ,
    Permission.INVENTORY_LIST,
    Permission.EXPENSES_READ,
    Permission.EXPENSES_LIST,
    Permission.SCHEDULING_READ,
    Permission.TIME_READ_OWN,
    Permission.PAYROLL_READ_OWN,
    Permission.DOCUMENTS_READ,
    Permission.DOCUMENTS_LIST,
    Permission.AI_ASK,
    Permission.AI_GENERATE_DEMO_REPORT,
  ],
  'CLIENT_OWNER': [
    Permission.PROJECT_READ_ASSIGNED,
    Permission.INVOICE_READ_OWN,
    Permission.DOCUMENTS_READ_ASSIGNED,
  ],
  'CLIENT_MANAGER': [
    Permission.PROJECT_READ_ASSIGNED,
    Permission.DOCUMENTS_READ_ASSIGNED,
  ],
  'CLIENT_VIEWER': [
    Permission.PROJECT_READ_ASSIGNED,
  ],
  'VENDOR': [
    Permission.PROJECT_READ_ASSIGNED,
    Permission.INVENTORY_READ,
    Permission.DOCUMENTS_READ_ASSIGNED,
  ],
  'GUEST': [
    Permission.PROJECT_READ,
    Permission.DOCUMENTS_READ,
  ],
};

// ============================================================================
// CRITICAL PERMISSIONS
// ============================================================================

/**
 * Critical Permissions (NOT granted by default to PROJECT_MANAGER)
 */
export const CRITICAL_PERMISSIONS = {
  APPROVALS: [
    Permission.ESTIMATE_APPROVE,
    Permission.ESTIMATE_DELETE_OWN,
    Permission.INVOICE_APPROVE,
    Permission.INVOICE_DELETE_OWN,
  ],
  FINANCIAL_INSIGHTS: [
    Permission.PROJECT_READ_FINANCIAL,
    Permission.ESTIMATE_READ_PROFIT,
    Permission.INVOICE_READ_PROFIT,
    Permission.ANALYTICS_READ_TENANT_KPIS,
  ],
  ADMINISTRATIVE: [
    Permission.PROJECT_DELETE,
    Permission.EXPENSES_APPROVE,
  ],
};

/**
 * TenantSettings Flags for Critical Permissions
 */
export const TENANT_SETTINGS_FLAGS = [
  'pmCanApproveEstimates',
  'pmCanApproveInvoices',
  'pmCanSeeProfit',
  'pmCanDeleteProjects',
  'pmCanApproveExpenses',
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
  VERSION: '8.3-phase1',
  GENERATED_DATE: '2025-11-18T20:32:50.524Z',
  TOTAL_ROLES: 10,
  ACTIVE_INTERNAL_ROLES: 5,
  EXTERNAL_ROLES: 5,
  TOTAL_PERMISSIONS: 137,
  BASELINE_PERMISSIONS: 120,
  CRITICAL_PERMISSIONS: 25,
  PHASE1_READY: true,
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
