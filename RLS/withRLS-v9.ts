/**
 * 🏛️ BeeSmart Pro RLS Engine v9.0 - Phase 1
 * Row-Level Security engine optimized for Phase 1 internal member operations
 *
 * Aligned with RBAC Generator v9.0:
 * - 5 internal roles: ADMIN, PROJECT_MANAGER, WORKER, DRIVER, VIEWER
 * - 140 explicit permissions across 18 domains
 * - TenantSettings integration for critical PM permissions
 * - Production-ready performance and security
 *
 * @version 9.0
 * @phase Phase 1 - Internal Members Only
 * @date November 18, 2025
 */

import { Prisma, PrismaClient } from "@prisma/client";

// RBAC v9.0 Integration
// Import RBAC constants for role hierarchy validation:
// import { ROLE_CODES, ROLE_HIERARCHY } from '../RBAC/generated-v9/rbac-constants';

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

/**
 * Basic security context for standard operations (90% of use cases)
 */
export interface SecurityContext {
  tenantId: string;
  actorId: string;
  memberId: string;
  sessionId?: string;
  requestId?: string;
}

/**
 * Extended security context for role-based operations
 */
export interface RoleSecurityContext extends SecurityContext {
  role: "ADMIN" | "PROJECT_MANAGER" | "WORKER" | "DRIVER" | "VIEWER";
  roleHierarchy: 0 | 2 | 8 | 9 | 10; // Phase 1 hierarchy levels
  assignedProjects?: string[];

  // PM-specific context (when role = PROJECT_MANAGER)
  pmPermissions?: {
    canApproveEstimates?: boolean;
    canApproveInvoices?: boolean;
    canApproveChangeOrders?: boolean;
    canSeeProjectFinancials?: boolean;
    canDeleteOwnEstimates?: boolean;
    canDeleteOwnInvoices?: boolean;
    canDeleteOwnChangeOrders?: boolean;
  };
}

/**
 * Operation result with performance metrics
 */
export interface RLSOperationResult<T> {
  data: T;
  executionTime: number;
  context: {
    tenantId: string;
    actorId: string;
    role?: string;
    permissions?: string[];
  };
}

/**
 * RLS operation options
 */
export interface RLSOptions {
  timeout?: number;
  enableMetrics?: boolean;
  enableAudit?: boolean;
  logLevel?: "ERROR" | "WARN" | "INFO" | "DEBUG";
}

// ============================================================================
// ERROR CLASSES
// ============================================================================

export class RLSValidationError extends Error {
  constructor(
    message: string,
    public readonly context: Partial<SecurityContext>,
    public readonly field?: string
  ) {
    super(message);
    this.name = "RLSValidationError";
  }
}

export class RLSSecurityError extends Error {
  constructor(
    message: string,
    public readonly context: Partial<SecurityContext>,
    public readonly violationType: string
  ) {
    super(message);
    this.name = "RLSSecurityError";
  }
}

export class RLSPermissionError extends Error {
  constructor(
    message: string,
    public readonly context: Partial<SecurityContext>,
    public readonly requiredPermission: string
  ) {
    super(message);
    this.name = "RLSPermissionError";
  }
}

// ============================================================================
// VALIDATION UTILITIES
// ============================================================================

function validateSecurityContext(ctx: SecurityContext): void {
  if (!ctx.tenantId || !isValidUUID(ctx.tenantId)) {
    throw new RLSValidationError("Invalid tenantId", ctx, "tenantId");
  }
  if (!ctx.actorId || !isValidUUID(ctx.actorId)) {
    throw new RLSValidationError("Invalid actorId", ctx, "actorId");
  }
  if (!ctx.memberId || !isValidUUID(ctx.memberId)) {
    throw new RLSValidationError("Invalid memberId", ctx, "memberId");
  }
}

function validateRoleContext(ctx: RoleSecurityContext): void {
  validateSecurityContext(ctx);

  const validRoles: Array<RoleSecurityContext["role"]> = [
    "ADMIN",
    "PROJECT_MANAGER",
    "WORKER",
    "DRIVER",
    "VIEWER",
  ];
  if (!validRoles.includes(ctx.role)) {
    throw new RLSValidationError(`Invalid role: ${ctx.role}`, ctx, "role");
  }

  const validHierarchies = [0, 2, 8, 9, 10];
  if (!validHierarchies.includes(ctx.roleHierarchy)) {
    throw new RLSValidationError(
      `Invalid role hierarchy: ${ctx.roleHierarchy}`,
      ctx,
      "roleHierarchy"
    );
  }
}

function isValidUUID(uuid: string): boolean {
  const uuidRegex =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  return uuidRegex.test(uuid);
}

// ============================================================================
// CORE RLS FUNCTIONS
// ============================================================================

/**
 * 🚀 STANDARD: Basic tenant-scoped RLS for most operations
 * Use this for 90% of standard CRUD operations
 */
export async function withRLS<T>(
  prisma: PrismaClient,
  ctx: SecurityContext,
  fn: (tx: Prisma.TransactionClient) => Promise<T>
): Promise<T> {
  validateSecurityContext(ctx);

  return prisma.$transaction(
    async (tx) => {
      // Set basic RLS context variables
      await tx.$executeRawUnsafe(
        `SELECT set_config('app.current_tenant_id', $1, true)`,
        ctx.tenantId
      );
      await tx.$executeRawUnsafe(
        `SELECT set_config('app.current_actor_id', $1, true)`,
        ctx.actorId
      );
      await tx.$executeRawUnsafe(
        `SELECT set_config('app.current_member_id', $1, true)`,
        ctx.memberId
      );

      // Set session tracking
      if (ctx.sessionId) {
        await tx.$executeRawUnsafe(
          `SELECT set_config('app.current_session_id', $1, true)`,
          ctx.sessionId
        );
      }

      return fn(tx);
    },
    {
      timeout: 30000,
      isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
    }
  );
}

/**
 * 🚀 ROLE-BASED: RLS with role hierarchy and permission context
 * Use this for operations that need role-based access control
 */
export async function withRoleRLS<T>(
  prisma: PrismaClient,
  ctx: RoleSecurityContext,
  fn: (
    tx: Prisma.TransactionClient,
    context: RoleSecurityContext
  ) => Promise<T>,
  options?: RLSOptions
): Promise<RLSOperationResult<T>> {
  validateRoleContext(ctx);
  const startTime = Date.now();

  const result = await prisma.$transaction(
    async (tx) => {
      // Set comprehensive RLS context
      await setRoleContext(tx, ctx);

      // Execute the operation
      const data = await fn(tx, ctx);

      // Optional audit logging
      if (options?.enableAudit) {
        await logRLSAudit(tx, ctx, Date.now() - startTime);
      }

      return data;
    },
    {
      timeout: options?.timeout || 30000,
      isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
    }
  );

  return {
    data: result,
    executionTime: Date.now() - startTime,
    context: {
      tenantId: ctx.tenantId,
      actorId: ctx.actorId,
      role: ctx.role,
      permissions: ctx.pmPermissions
        ? Object.keys(ctx.pmPermissions)
        : undefined,
    },
  };
}

/**
 * 🚀 PROJECT-SCOPED: RLS for project-specific operations
 * Use this for operations that are scoped to specific projects
 */
export async function withProjectRLS<T>(
  prisma: PrismaClient,
  ctx: RoleSecurityContext,
  projectId: string,
  fn: (tx: Prisma.TransactionClient, context: RoleSecurityContext) => Promise<T>
): Promise<T> {
  validateRoleContext(ctx);

  // Validate project access based on role
  if (ctx.roleHierarchy >= 8) {
    // WORKER, DRIVER levels - must be assigned to project
    if (!ctx.assignedProjects?.includes(projectId)) {
      throw new RLSSecurityError(
        `Access denied to project ${projectId}`,
        ctx,
        "PROJECT_ACCESS_DENIED"
      );
    }
  }

  return prisma.$transaction(async (tx) => {
    await setRoleContext(tx, ctx);

    // Set project-specific context
    await tx.$executeRawUnsafe(
      `SELECT set_config('app.current_project_id', $1, true)`,
      projectId
    );

    return fn(tx, ctx);
  });
}

// ============================================================================
// CONVENIENCE FUNCTIONS
// ============================================================================

/**
 * Simple tenant-scoped operation (most common use case)
 */
export async function withTenantRLS<T>(
  prisma: PrismaClient,
  tenantId: string,
  actorId: string,
  fn: (tx: Prisma.TransactionClient) => Promise<T>
): Promise<T> {
  return withRLS(
    prisma,
    {
      tenantId,
      actorId,
      memberId: actorId, // Assume actor = member for simplicity
    },
    fn
  );
}

/**
 * Admin-only operation (highest privilege level)
 */
export async function withAdminRLS<T>(
  prisma: PrismaClient,
  ctx: RoleSecurityContext,
  fn: (tx: Prisma.TransactionClient) => Promise<T>
): Promise<T> {
  if (ctx.role !== "ADMIN" || ctx.roleHierarchy !== 0) {
    throw new RLSSecurityError(
      "Admin privileges required",
      ctx,
      "INSUFFICIENT_PRIVILEGES"
    );
  }

  return withRoleRLS(prisma, ctx, async (tx) => fn(tx)).then(
    (result) => result.data
  );
}

/**
 * Project Manager operation with TenantSettings validation
 */
export async function withPMRLS<T>(
  prisma: PrismaClient,
  ctx: RoleSecurityContext,
  requiredPermission: keyof NonNullable<RoleSecurityContext["pmPermissions"]>,
  fn: (tx: Prisma.TransactionClient) => Promise<T>
): Promise<T> {
  // Allow ADMIN to bypass PM restrictions
  if (ctx.role === "ADMIN") {
    return withRoleRLS(prisma, ctx, async (tx) => fn(tx)).then(
      (result) => result.data
    );
  }

  // Validate PM permissions
  if (ctx.role !== "PROJECT_MANAGER") {
    throw new RLSPermissionError(
      "Project Manager role required",
      ctx,
      requiredPermission
    );
  }

  if (!ctx.pmPermissions?.[requiredPermission]) {
    throw new RLSPermissionError(
      `PM permission not enabled: ${requiredPermission}`,
      ctx,
      requiredPermission
    );
  }

  return withRoleRLS(prisma, ctx, async (tx) => fn(tx)).then(
    (result) => result.data
  );
}

// ============================================================================
// INTERNAL HELPER FUNCTIONS
// ============================================================================

async function setRoleContext(
  tx: Prisma.TransactionClient,
  ctx: RoleSecurityContext
): Promise<void> {
  // Basic context
  await tx.$executeRawUnsafe(
    `SELECT set_config('app.current_tenant_id', $1, true)`,
    ctx.tenantId
  );
  await tx.$executeRawUnsafe(
    `SELECT set_config('app.current_actor_id', $1, true)`,
    ctx.actorId
  );
  await tx.$executeRawUnsafe(
    `SELECT set_config('app.current_member_id', $1, true)`,
    ctx.memberId
  );

  // Role context
  await tx.$executeRawUnsafe(
    `SELECT set_config('app.current_role', $1, true)`,
    ctx.role
  );
  await tx.$executeRawUnsafe(
    `SELECT set_config('app.role_hierarchy', $1, true)`,
    ctx.roleHierarchy.toString()
  );

  // Project assignments
  if (ctx.assignedProjects) {
    await tx.$executeRawUnsafe(
      `SELECT set_config('app.assigned_projects', $1, true)`,
      JSON.stringify(ctx.assignedProjects)
    );
  }

  // PM permissions context
  if (ctx.pmPermissions) {
    await tx.$executeRawUnsafe(
      `SELECT set_config('app.pm_permissions', $1, true)`,
      JSON.stringify(ctx.pmPermissions)
    );
  }

  // Session tracking
  if (ctx.sessionId) {
    await tx.$executeRawUnsafe(
      `SELECT set_config('app.current_session_id', $1, true)`,
      ctx.sessionId
    );
  }
}

async function logRLSAudit(
  tx: Prisma.TransactionClient,
  ctx: RoleSecurityContext,
  executionTime: number
): Promise<void> {
  try {
    await tx.accessAuditEvent.create({
      data: {
        tenantId: ctx.tenantId,
        actorId: ctx.actorId,
        eventType: "RLS_OPERATION",
        resourceType: "DATABASE",
        actionType: "QUERY",
        accessDecision: "ALLOWED",
        executionTimeMs: executionTime,
        contextData: {
          role: ctx.role,
          roleHierarchy: ctx.roleHierarchy,
          sessionId: ctx.sessionId,
          requestId: ctx.requestId,
          assignedProjects: ctx.assignedProjects,
          pmPermissions: ctx.pmPermissions,
        },
      },
    });
  } catch (error) {
    // Audit logging failure shouldn't break the operation
    console.error("RLS audit logging failed:", error);
  }
}

// ============================================================================
// ROLE HIERARCHY UTILITIES
// ============================================================================

/**
 * Check if role has higher or equal authority than target role
 */
export function hasHigherOrEqualAuthority(
  currentHierarchy: number,
  targetHierarchy: number
): boolean {
  return currentHierarchy <= targetHierarchy; // Lower number = higher authority
}

/**
 * Get all roles that have lower authority than the given role
 */
export function getSubordinateRoles(
  hierarchy: number
): Array<{ role: string; hierarchy: number }> {
  const allRoles = [
    { role: "ADMIN", hierarchy: 0 },
    { role: "PROJECT_MANAGER", hierarchy: 2 },
    { role: "WORKER", hierarchy: 8 },
    { role: "DRIVER", hierarchy: 9 },
    { role: "VIEWER", hierarchy: 10 },
  ];

  return allRoles.filter((r) => r.hierarchy > hierarchy);
}

/**
 * Validate role hierarchy for approval workflows
 */
export function canApprove(
  approverHierarchy: number,
  requiredLevel: number
): boolean {
  return approverHierarchy <= requiredLevel;
}

// ============================================================================
// EXPORTS
// ============================================================================

export {
  withAdminRLS,
  withPMRLS,
  withProjectRLS,
  withRLS,
  withRoleRLS,
  withTenantRLS,
  type RLSOperationResult,
  type RLSOptions,
  type RoleSecurityContext,
  type SecurityContext,
};
