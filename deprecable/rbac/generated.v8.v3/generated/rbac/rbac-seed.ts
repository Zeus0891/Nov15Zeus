/**
 * 🏛️ Nov15Zeus RBAC Prisma Seed v8.2
 * Generated from rbac.schema.v8.2.yml
 * Generated: 2025-11-18T17:34:57.144Z
 * 
 * ⚠️ DO NOT EDIT - This file is auto-generated
 * Update rbac.schema.v8.2.yml and regenerate instead
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedRBACData() {
  console.log('🌱 Seeding RBAC data...');

  // Clean existing RBAC data
  await prisma.rolePermission.deleteMany({});
  await prisma.permission.deleteMany({});
  await prisma.role.deleteMany({});
  console.log('🧹 Cleaned existing RBAC data');

  // Create permissions
  const permissions = await prisma.permission.createMany({
    data: [
      {
        code: 'accesscontrol:assign',
        name: 'Assign accesscontrol',
        description: 'Assign operations on accesscontrol',
        domain: 'accesscontrol',
        action: 'assign',
      },
      {
        code: 'accesscontrol:create',
        name: 'Create accesscontrol',
        description: 'Create operations on accesscontrol',
        domain: 'accesscontrol',
        action: 'create',
      },
      {
        code: 'accesscontrol:delete',
        name: 'Delete accesscontrol',
        description: 'Delete operations on accesscontrol',
        domain: 'accesscontrol',
        action: 'delete',
      },
      {
        code: 'accesscontrol:read',
        name: 'Read accesscontrol',
        description: 'Read operations on accesscontrol',
        domain: 'accesscontrol',
        action: 'read',
      },
      {
        code: 'accesscontrol:revoke',
        name: 'Revoke accesscontrol',
        description: 'Revoke operations on accesscontrol',
        domain: 'accesscontrol',
        action: 'revoke',
      },
      {
        code: 'accesscontrol:update',
        name: 'Update accesscontrol',
        description: 'Update operations on accesscontrol',
        domain: 'accesscontrol',
        action: 'update',
      },
      {
        code: 'ai:analyze',
        name: 'Analyze ai',
        description: 'Analyze operations on ai',
        domain: 'ai',
        action: 'analyze',
      },
      {
        code: 'ai:process',
        name: 'Process ai',
        description: 'Process operations on ai',
        domain: 'ai',
        action: 'process',
      },
      {
        code: 'ai:read',
        name: 'Read ai',
        description: 'Read operations on ai',
        domain: 'ai',
        action: 'read',
      },
      {
        code: 'crm:create',
        name: 'Create crm',
        description: 'Create operations on crm',
        domain: 'crm',
        action: 'create',
      },
      {
        code: 'crm:delete',
        name: 'Delete crm',
        description: 'Delete operations on crm',
        domain: 'crm',
        action: 'delete',
      },
      {
        code: 'crm:export',
        name: 'Export crm',
        description: 'Export operations on crm',
        domain: 'crm',
        action: 'export',
      },
      {
        code: 'crm:import',
        name: 'Import crm',
        description: 'Import operations on crm',
        domain: 'crm',
        action: 'import',
      },
      {
        code: 'crm:read',
        name: 'Read crm',
        description: 'Read operations on crm',
        domain: 'crm',
        action: 'read',
      },
      {
        code: 'crm:update',
        name: 'Update crm',
        description: 'Update operations on crm',
        domain: 'crm',
        action: 'update',
      },
      {
        code: 'documents:create',
        name: 'Create documents',
        description: 'Create operations on documents',
        domain: 'documents',
        action: 'create',
      },
      {
        code: 'documents:delete',
        name: 'Delete documents',
        description: 'Delete operations on documents',
        domain: 'documents',
        action: 'delete',
      },
      {
        code: 'documents:export',
        name: 'Export documents',
        description: 'Export operations on documents',
        domain: 'documents',
        action: 'export',
      },
      {
        code: 'documents:read',
        name: 'Read documents',
        description: 'Read operations on documents',
        domain: 'documents',
        action: 'read',
      },
      {
        code: 'documents:read:assigned',
        name: 'Read documents (assigned)',
        description: 'Read operations on documents with assigned scope',
        domain: 'documents',
        action: 'read',
        subaction: 'assigned',
      },
      {
        code: 'documents:read:public',
        name: 'Read documents (public)',
        description: 'Read operations on documents with public scope',
        domain: 'documents',
        action: 'read',
        subaction: 'public',
      },
      {
        code: 'documents:update',
        name: 'Update documents',
        description: 'Update operations on documents',
        domain: 'documents',
        action: 'update',
      },
      {
        code: 'estimate:approve',
        name: 'Approve estimate',
        description: 'Approve operations on estimate',
        domain: 'estimate',
        action: 'approve',
      },
      {
        code: 'estimate:convert',
        name: 'Convert estimate',
        description: 'Convert operations on estimate',
        domain: 'estimate',
        action: 'convert',
      },
      {
        code: 'estimate:create',
        name: 'Create estimate',
        description: 'Create operations on estimate',
        domain: 'estimate',
        action: 'create',
      },
      {
        code: 'estimate:delete',
        name: 'Delete estimate',
        description: 'Delete operations on estimate',
        domain: 'estimate',
        action: 'delete',
      },
      {
        code: 'estimate:export',
        name: 'Export estimate',
        description: 'Export operations on estimate',
        domain: 'estimate',
        action: 'export',
      },
      {
        code: 'estimate:read',
        name: 'Read estimate',
        description: 'Read operations on estimate',
        domain: 'estimate',
        action: 'read',
      },
      {
        code: 'estimate:read:own',
        name: 'Read estimate (own)',
        description: 'Read operations on estimate with own scope',
        domain: 'estimate',
        action: 'read',
        subaction: 'own',
      },
      {
        code: 'estimate:reject',
        name: 'Reject estimate',
        description: 'Reject operations on estimate',
        domain: 'estimate',
        action: 'reject',
      },
      {
        code: 'estimate:send',
        name: 'Send estimate',
        description: 'Send operations on estimate',
        domain: 'estimate',
        action: 'send',
      },
      {
        code: 'estimate:update',
        name: 'Update estimate',
        description: 'Update operations on estimate',
        domain: 'estimate',
        action: 'update',
      },
      {
        code: 'estimate:update:status',
        name: 'Update estimate (status)',
        description: 'Update operations on estimate with status scope',
        domain: 'estimate',
        action: 'update',
        subaction: 'status',
      },
      {
        code: 'expenses:approve',
        name: 'Approve expenses',
        description: 'Approve operations on expenses',
        domain: 'expenses',
        action: 'approve',
      },
      {
        code: 'expenses:create',
        name: 'Create expenses',
        description: 'Create operations on expenses',
        domain: 'expenses',
        action: 'create',
      },
      {
        code: 'expenses:create:own',
        name: 'Create expenses (own)',
        description: 'Create operations on expenses with own scope',
        domain: 'expenses',
        action: 'create',
        subaction: 'own',
      },
      {
        code: 'expenses:delete',
        name: 'Delete expenses',
        description: 'Delete operations on expenses',
        domain: 'expenses',
        action: 'delete',
      },
      {
        code: 'expenses:read',
        name: 'Read expenses',
        description: 'Read operations on expenses',
        domain: 'expenses',
        action: 'read',
      },
      {
        code: 'expenses:read:own',
        name: 'Read expenses (own)',
        description: 'Read operations on expenses with own scope',
        domain: 'expenses',
        action: 'read',
        subaction: 'own',
      },
      {
        code: 'expenses:reject',
        name: 'Reject expenses',
        description: 'Reject operations on expenses',
        domain: 'expenses',
        action: 'reject',
      },
      {
        code: 'expenses:update',
        name: 'Update expenses',
        description: 'Update operations on expenses',
        domain: 'expenses',
        action: 'update',
      },
      {
        code: 'expenses:update:own',
        name: 'Update expenses (own)',
        description: 'Update operations on expenses with own scope',
        domain: 'expenses',
        action: 'update',
        subaction: 'own',
      },
      {
        code: 'identity:create',
        name: 'Create identity',
        description: 'Create operations on identity',
        domain: 'identity',
        action: 'create',
      },
      {
        code: 'identity:delete',
        name: 'Delete identity',
        description: 'Delete operations on identity',
        domain: 'identity',
        action: 'delete',
      },
      {
        code: 'identity:read',
        name: 'Read identity',
        description: 'Read operations on identity',
        domain: 'identity',
        action: 'read',
      },
      {
        code: 'identity:read:own',
        name: 'Read identity (own)',
        description: 'Read operations on identity with own scope',
        domain: 'identity',
        action: 'read',
        subaction: 'own',
      },
      {
        code: 'identity:update',
        name: 'Update identity',
        description: 'Update operations on identity',
        domain: 'identity',
        action: 'update',
      },
      {
        code: 'identity:update:own',
        name: 'Update identity (own)',
        description: 'Update operations on identity with own scope',
        domain: 'identity',
        action: 'update',
        subaction: 'own',
      },
      {
        code: 'inventory:adjust',
        name: 'Adjust inventory',
        description: 'Adjust operations on inventory',
        domain: 'inventory',
        action: 'adjust',
      },
      {
        code: 'inventory:adjust:quantity',
        name: 'Adjust inventory (quantity)',
        description: 'Adjust operations on inventory with quantity scope',
        domain: 'inventory',
        action: 'adjust',
        subaction: 'quantity',
      },
      {
        code: 'inventory:assign',
        name: 'Assign inventory',
        description: 'Assign operations on inventory',
        domain: 'inventory',
        action: 'assign',
      },
      {
        code: 'inventory:create',
        name: 'Create inventory',
        description: 'Create operations on inventory',
        domain: 'inventory',
        action: 'create',
      },
      {
        code: 'inventory:process',
        name: 'Process inventory',
        description: 'Process operations on inventory',
        domain: 'inventory',
        action: 'process',
      },
      {
        code: 'inventory:read',
        name: 'Read inventory',
        description: 'Read operations on inventory',
        domain: 'inventory',
        action: 'read',
      },
      {
        code: 'inventory:reconcile',
        name: 'Reconcile inventory',
        description: 'Reconcile operations on inventory',
        domain: 'inventory',
        action: 'reconcile',
      },
      {
        code: 'inventory:update',
        name: 'Update inventory',
        description: 'Update operations on inventory',
        domain: 'inventory',
        action: 'update',
      },
      {
        code: 'invoice:approve',
        name: 'Approve invoice',
        description: 'Approve operations on invoice',
        domain: 'invoice',
        action: 'approve',
      },
      {
        code: 'invoice:create',
        name: 'Create invoice',
        description: 'Create operations on invoice',
        domain: 'invoice',
        action: 'create',
      },
      {
        code: 'invoice:delete',
        name: 'Delete invoice',
        description: 'Delete operations on invoice',
        domain: 'invoice',
        action: 'delete',
      },
      {
        code: 'invoice:export',
        name: 'Export invoice',
        description: 'Export operations on invoice',
        domain: 'invoice',
        action: 'export',
      },
      {
        code: 'invoice:pay',
        name: 'Pay invoice',
        description: 'Pay operations on invoice',
        domain: 'invoice',
        action: 'pay',
      },
      {
        code: 'invoice:read',
        name: 'Read invoice',
        description: 'Read operations on invoice',
        domain: 'invoice',
        action: 'read',
      },
      {
        code: 'invoice:read:own',
        name: 'Read invoice (own)',
        description: 'Read operations on invoice with own scope',
        domain: 'invoice',
        action: 'read',
        subaction: 'own',
      },
      {
        code: 'invoice:send',
        name: 'Send invoice',
        description: 'Send operations on invoice',
        domain: 'invoice',
        action: 'send',
      },
      {
        code: 'invoice:update',
        name: 'Update invoice',
        description: 'Update operations on invoice',
        domain: 'invoice',
        action: 'update',
      },
      {
        code: 'invoice:update:status',
        name: 'Update invoice (status)',
        description: 'Update operations on invoice with status scope',
        domain: 'invoice',
        action: 'update',
        subaction: 'status',
      },
      {
        code: 'payroll:approve',
        name: 'Approve payroll',
        description: 'Approve operations on payroll',
        domain: 'payroll',
        action: 'approve',
      },
      {
        code: 'payroll:create',
        name: 'Create payroll',
        description: 'Create operations on payroll',
        domain: 'payroll',
        action: 'create',
      },
      {
        code: 'payroll:export',
        name: 'Export payroll',
        description: 'Export operations on payroll',
        domain: 'payroll',
        action: 'export',
      },
      {
        code: 'payroll:process',
        name: 'Process payroll',
        description: 'Process operations on payroll',
        domain: 'payroll',
        action: 'process',
      },
      {
        code: 'payroll:read',
        name: 'Read payroll',
        description: 'Read operations on payroll',
        domain: 'payroll',
        action: 'read',
      },
      {
        code: 'payroll:read:own',
        name: 'Read payroll (own)',
        description: 'Read operations on payroll with own scope',
        domain: 'payroll',
        action: 'read',
        subaction: 'own',
      },
      {
        code: 'payroll:update',
        name: 'Update payroll',
        description: 'Update operations on payroll',
        domain: 'payroll',
        action: 'update',
      },
      {
        code: 'project:assign',
        name: 'Assign project',
        description: 'Assign operations on project',
        domain: 'project',
        action: 'assign',
      },
      {
        code: 'project:assign:employee',
        name: 'Assign project (employee)',
        description: 'Assign operations on project with employee scope',
        domain: 'project',
        action: 'assign',
        subaction: 'employee',
      },
      {
        code: 'project:close',
        name: 'Close project',
        description: 'Close operations on project',
        domain: 'project',
        action: 'close',
      },
      {
        code: 'project:create',
        name: 'Create project',
        description: 'Create operations on project',
        domain: 'project',
        action: 'create',
      },
      {
        code: 'project:delete',
        name: 'Delete project',
        description: 'Delete operations on project',
        domain: 'project',
        action: 'delete',
      },
      {
        code: 'project:read',
        name: 'Read project',
        description: 'Read operations on project',
        domain: 'project',
        action: 'read',
      },
      {
        code: 'project:read:assigned',
        name: 'Read project (assigned)',
        description: 'Read operations on project with assigned scope',
        domain: 'project',
        action: 'read',
        subaction: 'assigned',
      },
      {
        code: 'project:reopen',
        name: 'Reopen project',
        description: 'Reopen operations on project',
        domain: 'project',
        action: 'reopen',
      },
      {
        code: 'project:update',
        name: 'Update project',
        description: 'Update operations on project',
        domain: 'project',
        action: 'update',
      },
      {
        code: 'project:update:budget',
        name: 'Update project (budget)',
        description: 'Update operations on project with budget scope',
        domain: 'project',
        action: 'update',
        subaction: 'budget',
      },
      {
        code: 'project:update:status',
        name: 'Update project (status)',
        description: 'Update operations on project with status scope',
        domain: 'project',
        action: 'update',
        subaction: 'status',
      },
      {
        code: 'scheduling:assign',
        name: 'Assign scheduling',
        description: 'Assign operations on scheduling',
        domain: 'scheduling',
        action: 'assign',
      },
      {
        code: 'scheduling:create',
        name: 'Create scheduling',
        description: 'Create operations on scheduling',
        domain: 'scheduling',
        action: 'create',
      },
      {
        code: 'scheduling:delete',
        name: 'Delete scheduling',
        description: 'Delete operations on scheduling',
        domain: 'scheduling',
        action: 'delete',
      },
      {
        code: 'scheduling:read',
        name: 'Read scheduling',
        description: 'Read operations on scheduling',
        domain: 'scheduling',
        action: 'read',
      },
      {
        code: 'scheduling:read:own',
        name: 'Read scheduling (own)',
        description: 'Read operations on scheduling with own scope',
        domain: 'scheduling',
        action: 'read',
        subaction: 'own',
      },
      {
        code: 'scheduling:update',
        name: 'Update scheduling',
        description: 'Update operations on scheduling',
        domain: 'scheduling',
        action: 'update',
      },
      {
        code: 'scheduling:update:own',
        name: 'Update scheduling (own)',
        description: 'Update operations on scheduling with own scope',
        domain: 'scheduling',
        action: 'update',
        subaction: 'own',
      },
    ],
  });
  console.log('✅ Created 91 permissions');

  // Create roles
  const roles = await prisma.role.createMany({
    data: [
      {
        code: 'ADMIN',
        name: 'Administrator',
        description: 'System administrator with full platform access',
        hierarchy: 0,
        roleType: 'INTERNAL',
        accessScope: 'All systems and data',
        status: 'ACTIVE',
      },
      {
        code: 'EXECUTIVE',
        name: 'Executive',
        description: 'C-level executive with strategic oversight',
        hierarchy: 1,
        roleType: 'INTERNAL',
        accessScope: 'Strategic reports and high-level operations',
        status: 'ACTIVE',
      },
      {
        code: 'PROJECT_MANAGER',
        name: 'Project Manager',
        description: 'Project oversight and team management',
        hierarchy: 2,
        roleType: 'INTERNAL',
        accessScope: 'Assigned projects and teams',
        status: 'ACTIVE',
      },
      {
        code: 'FINANCE_CONTROLLER',
        name: 'Finance Controller',
        description: 'Financial oversight and approval authority',
        hierarchy: 2,
        roleType: 'INTERNAL',
        accessScope: 'All financial data and approvals',
        status: 'ACTIVE',
      },
      {
        code: 'HR_MANAGER',
        name: 'HR Manager',
        description: 'Human resources and employee management',
        hierarchy: 3,
        roleType: 'INTERNAL',
        accessScope: 'Employee data and HR processes',
        status: 'ACTIVE',
      },
      {
        code: 'ESTIMATOR',
        name: 'Estimator',
        description: 'Estimate creation and cost analysis',
        hierarchy: 4,
        roleType: 'INTERNAL',
        accessScope: 'Estimates and pricing data',
        status: 'ACTIVE',
      },
      {
        code: 'ACCOUNTING',
        name: 'Staff Accountant',
        description: 'Accounting operations and transaction processing',
        hierarchy: 5,
        roleType: 'INTERNAL',
        accessScope: 'Transaction-level financial data',
        status: 'ACTIVE',
      },
      {
        code: 'SCHEDULER',
        name: 'Scheduler',
        description: 'Resource and time scheduling management',
        hierarchy: 5,
        roleType: 'INTERNAL',
        accessScope: 'Scheduling and resource allocation',
        status: 'ACTIVE',
      },
      {
        code: 'INVENTORY_MANAGER',
        name: 'Inventory Manager',
        description: 'Materials and inventory management',
        hierarchy: 5,
        roleType: 'INTERNAL',
        accessScope: 'Inventory and materials data',
        status: 'ACTIVE',
      },
      {
        code: 'PAYROLL_MANAGER',
        name: 'Payroll Manager',
        description: 'Payroll processing and management',
        hierarchy: 6,
        roleType: 'INTERNAL',
        accessScope: 'Payroll and compensation data',
        status: 'ACTIVE',
      },
      {
        code: 'CLIENT_OWNER',
        name: 'Client Owner',
        description: 'Client company owner with project oversight',
        hierarchy: 6,
        roleType: 'EXTERNAL',
        accessScope: 'Own projects and invoices',
        status: 'ACTIVE',
      },
      {
        code: 'CLIENT_MANAGER',
        name: 'Client Manager',
        description: 'Client project management and coordination',
        hierarchy: 7,
        roleType: 'EXTERNAL',
        accessScope: 'Assigned projects and documentation',
        status: 'ACTIVE',
      },
      {
        code: 'VENDOR',
        name: 'Vendor/Supplier',
        description: 'External vendor or supplier access',
        hierarchy: 7,
        roleType: 'EXTERNAL',
        accessScope: 'Relevant purchase orders and contracts',
        status: 'ACTIVE',
      },
      {
        code: 'WORKER',
        name: 'Field Worker',
        description: 'Field operations and task execution',
        hierarchy: 8,
        roleType: 'INTERNAL',
        accessScope: 'Assigned tasks and personal records',
        status: 'ACTIVE',
      },
      {
        code: 'CLIENT_VIEWER',
        name: 'Client Viewer',
        description: 'Client stakeholder with limited access',
        hierarchy: 8,
        roleType: 'EXTERNAL',
        accessScope: 'Public project information',
        status: 'ACTIVE',
      },
      {
        code: 'VIEWER',
        name: 'Internal Viewer',
        description: 'Read-only access for internal stakeholders',
        hierarchy: 9,
        roleType: 'INTERNAL',
        accessScope: 'Limited read-only access',
        status: 'ACTIVE',
      },
      {
        code: 'GUEST',
        name: 'Guest User',
        description: 'Temporary or demo access',
        hierarchy: 10,
        roleType: 'EXTERNAL',
        accessScope: 'Demo/sandbox environment only',
        status: 'ACTIVE',
      },
    ],
  });
  console.log('✅ Created 17 roles');

  // Create role permissions
  const rolePermissionData = [];

  // ADMIN permissions
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'accesscontrol:assign',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'accesscontrol:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'accesscontrol:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'accesscontrol:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'accesscontrol:revoke',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'accesscontrol:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'ai:analyze',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'ai:process',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'ai:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'crm:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'crm:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'crm:export',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'crm:import',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'crm:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'crm:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'documents:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'documents:export',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'documents:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'documents:read:public',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'documents:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:approve',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:convert',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:export',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:read:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:reject',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:send',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'estimate:update:status',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:approve',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:create:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:read:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:reject',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'expenses:update:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'identity:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'identity:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'identity:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'identity:read:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'identity:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'identity:update:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:adjust',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:adjust:quantity',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:assign',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:process',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:reconcile',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'inventory:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:approve',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:export',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:pay',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:read:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:send',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'invoice:update:status',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'payroll:approve',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'payroll:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'payroll:export',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'payroll:process',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'payroll:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'payroll:read:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'payroll:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:assign',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:assign:employee',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:close',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:reopen',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:update:budget',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'project:update:status',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'scheduling:assign',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'scheduling:create',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'scheduling:delete',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'scheduling:read',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'scheduling:read:own',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'scheduling:update',
  });
  rolePermissionData.push({
    roleCode: 'ADMIN',
    permissionCode: 'scheduling:update:own',
  });

  // EXECUTIVE permissions
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'ai:analyze',
  });
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'ai:read',
  });
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'estimate:read',
  });
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'expenses:read',
  });
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'invoice:read',
  });
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'payroll:read',
  });
  rolePermissionData.push({
    roleCode: 'EXECUTIVE',
    permissionCode: 'project:read',
  });

  // PROJECT_MANAGER permissions
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'crm:read',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'crm:update',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'documents:update',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'estimate:approve',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'estimate:convert',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'estimate:create',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'estimate:export',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'estimate:read',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'estimate:send',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'estimate:update',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'invoice:create',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'invoice:export',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'invoice:read',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'invoice:send',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:assign',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:assign:employee',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:close',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:create',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:read',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:reopen',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:update',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:update:budget',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'project:update:status',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'scheduling:assign',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'scheduling:create',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'scheduling:read',
  });
  rolePermissionData.push({
    roleCode: 'PROJECT_MANAGER',
    permissionCode: 'scheduling:update',
  });

  // FINANCE_CONTROLLER permissions
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'estimate:approve',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'estimate:read',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'expenses:approve',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'expenses:read',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'expenses:reject',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'invoice:approve',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'invoice:create',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'invoice:export',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'invoice:pay',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'invoice:read',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'invoice:send',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'invoice:update',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'payroll:approve',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'payroll:export',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'payroll:read',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'project:read',
  });
  rolePermissionData.push({
    roleCode: 'FINANCE_CONTROLLER',
    permissionCode: 'project:update:budget',
  });

  // HR_MANAGER permissions
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'documents:update',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'identity:create',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'identity:read',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'identity:update',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'payroll:create',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'payroll:export',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'payroll:process',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'payroll:read',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'payroll:update',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'scheduling:read',
  });
  rolePermissionData.push({
    roleCode: 'HR_MANAGER',
    permissionCode: 'scheduling:update',
  });

  // ESTIMATOR permissions
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'crm:read',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'estimate:create',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'estimate:export',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'estimate:read',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'estimate:send',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'estimate:update',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'estimate:update:status',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'inventory:read',
  });
  rolePermissionData.push({
    roleCode: 'ESTIMATOR',
    permissionCode: 'project:read',
  });

  // ACCOUNTING permissions
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'expenses:create',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'expenses:read',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'expenses:update',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'invoice:create',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'invoice:export',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'invoice:pay',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'invoice:read',
  });
  rolePermissionData.push({
    roleCode: 'ACCOUNTING',
    permissionCode: 'invoice:update',
  });

  // SCHEDULER permissions
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'identity:read',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'project:read',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'project:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'scheduling:assign',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'scheduling:create',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'scheduling:delete',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'scheduling:read',
  });
  rolePermissionData.push({
    roleCode: 'SCHEDULER',
    permissionCode: 'scheduling:update',
  });

  // INVENTORY_MANAGER permissions
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:adjust',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:adjust:quantity',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:assign',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:create',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:process',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:read',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:reconcile',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'inventory:update',
  });
  rolePermissionData.push({
    roleCode: 'INVENTORY_MANAGER',
    permissionCode: 'project:read',
  });

  // PAYROLL_MANAGER permissions
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'documents:read',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'identity:read',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'payroll:create',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'payroll:export',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'payroll:process',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'payroll:read',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'payroll:update',
  });
  rolePermissionData.push({
    roleCode: 'PAYROLL_MANAGER',
    permissionCode: 'scheduling:read',
  });

  // WORKER permissions
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'documents:create',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'documents:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'expenses:create:own',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'expenses:read:own',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'expenses:update:own',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'identity:read:own',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'identity:update:own',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'project:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'scheduling:read:own',
  });
  rolePermissionData.push({
    roleCode: 'WORKER',
    permissionCode: 'scheduling:update:own',
  });

  // VIEWER permissions
  rolePermissionData.push({
    roleCode: 'VIEWER',
    permissionCode: 'documents:read:public',
  });
  rolePermissionData.push({
    roleCode: 'VIEWER',
    permissionCode: 'estimate:read',
  });
  rolePermissionData.push({
    roleCode: 'VIEWER',
    permissionCode: 'invoice:read',
  });
  rolePermissionData.push({
    roleCode: 'VIEWER',
    permissionCode: 'project:read',
  });

  // CLIENT_OWNER permissions
  rolePermissionData.push({
    roleCode: 'CLIENT_OWNER',
    permissionCode: 'documents:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_OWNER',
    permissionCode: 'documents:read:public',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_OWNER',
    permissionCode: 'estimate:approve',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_OWNER',
    permissionCode: 'estimate:read:own',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_OWNER',
    permissionCode: 'invoice:pay',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_OWNER',
    permissionCode: 'invoice:read:own',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_OWNER',
    permissionCode: 'project:read:assigned',
  });

  // CLIENT_MANAGER permissions
  rolePermissionData.push({
    roleCode: 'CLIENT_MANAGER',
    permissionCode: 'documents:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_MANAGER',
    permissionCode: 'documents:read:public',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_MANAGER',
    permissionCode: 'estimate:read:own',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_MANAGER',
    permissionCode: 'invoice:read:own',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_MANAGER',
    permissionCode: 'project:read:assigned',
  });

  // CLIENT_VIEWER permissions
  rolePermissionData.push({
    roleCode: 'CLIENT_VIEWER',
    permissionCode: 'documents:read:public',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_VIEWER',
    permissionCode: 'estimate:read:own',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_VIEWER',
    permissionCode: 'invoice:read:own',
  });
  rolePermissionData.push({
    roleCode: 'CLIENT_VIEWER',
    permissionCode: 'project:read:assigned',
  });

  // VENDOR permissions
  rolePermissionData.push({
    roleCode: 'VENDOR',
    permissionCode: 'documents:read:assigned',
  });
  rolePermissionData.push({
    roleCode: 'VENDOR',
    permissionCode: 'inventory:read',
  });
  rolePermissionData.push({
    roleCode: 'VENDOR',
    permissionCode: 'invoice:create',
  });
  rolePermissionData.push({
    roleCode: 'VENDOR',
    permissionCode: 'project:read:assigned',
  });

  // GUEST permissions
  rolePermissionData.push({
    roleCode: 'GUEST',
    permissionCode: 'documents:read:public',
  });
  rolePermissionData.push({
    roleCode: 'GUEST',
    permissionCode: 'project:read:public',
  });

  await prisma.rolePermission.createMany({
    data: rolePermissionData,
  });
  console.log('✅ Created role-permission mappings');

  console.log('🎉 RBAC data seeded successfully!');
}

// Execute if run directly
if (require.main === module) {
  seedRBACData()
    .catch((e) => {
      console.error('❌ Error seeding RBAC data:', e);
      process.exit(1);
    })
    .finally(async () => {
      await prisma.$disconnect();
    });
}