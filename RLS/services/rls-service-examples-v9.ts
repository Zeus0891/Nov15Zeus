/**
 * 🚀 BeeSmart Pro RLS Service Examples v9.0
 * Practical implementation examples for all major ERP services
 *
 * Aligned with RBAC Generator v9.0:
 * - 5 internal roles with specific hierarchy levels
 * - TenantSettings integration for PM permissions
 * - Phase 1 focused architecture
 *
 * @version 9.0
 * @phase Phase 1 - Internal Members Only
 * @date November 18, 2025
 */

import { PrismaClient } from "@prisma/client";
import {
  withAdminRLS,
  withPMRLS,
  withProjectRLS,
  withRLS,
  withRoleRLS,
  type RoleSecurityContext,
  type SecurityContext,
} from "../withRLS-v9";

// ============================================================================
// SERVICE BASE CLASSES
// ============================================================================

/**
 * Base service class with RLS integration
 * All services should extend this for consistent security
 */
export abstract class BaseRLSService {
  constructor(protected prisma: PrismaClient) {}

  /**
   * Standard operation with basic tenant isolation
   */
  protected async withStandardRLS<T>(
    context: SecurityContext,
    operation: (tx: any) => Promise<T>
  ): Promise<T> {
    return withRLS(this.prisma, context, operation);
  }

  /**
   * Role-based operation with full context validation
   */
  protected async withRoleBasedRLS<T>(
    context: RoleSecurityContext,
    operation: (tx: any, ctx: RoleSecurityContext) => Promise<T>
  ): Promise<T> {
    const result = await withRoleRLS(this.prisma, context, operation);
    return result.data;
  }
}

// ============================================================================
// ESTIMATE SERVICE EXAMPLES
// ============================================================================

export class EstimateService extends BaseRLSService {
  /**
   * 📋 LIST ESTIMATES - Standard tenant-scoped query
   * Most common pattern: basic tenant isolation
   */
  async listEstimates(context: SecurityContext, filters?: any) {
    return this.withStandardRLS(context, async (tx) => {
      return tx.estimate.findMany({
        where: {
          tenantId: context.tenantId,
          deletedAt: null,
          ...filters,
        },
        include: {
          crmAccount: true,
          sections: {
            include: {
              lineItems: true,
            },
          },
        },
        orderBy: { createdAt: "desc" },
      });
    });
  }

  /**
   * 🔍 GET ESTIMATE DETAILS - Role-based with financial visibility
   * Shows different data based on user role
   */
  async getEstimateDetails(context: RoleSecurityContext, estimateId: string) {
    return this.withRoleBasedRLS(context, async (tx, ctx) => {
      const baseWhere = {
        tenantId: ctx.tenantId,
        id: estimateId,
        deletedAt: null,
      };

      // Role-based data visibility
      const includeOptions: any = {
        crmAccount: true,
        sections: {
          include: {
            lineItems: true,
          },
        },
        attachments: true,
      };

      // Financial data only for PM+ roles
      if (ctx.roleHierarchy <= 2) {
        // ADMIN, PROJECT_MANAGER
        includeOptions.pricing = true;
        includeOptions.taxes = true;
        includeOptions.fees = true;
      }

      // Full audit trail only for ADMIN
      if (ctx.role === "ADMIN") {
        includeOptions.historyEvents = true;
        includeOptions.comments = true;
      }

      return tx.estimate.findUnique({
        where: baseWhere,
        include: includeOptions,
      });
    });
  }

  /**
   * ✏️ CREATE ESTIMATE - Basic creation with auto-assignment
   */
  async createEstimate(context: SecurityContext, data: any) {
    return this.withStandardRLS(context, async (tx) => {
      // Auto-generate estimate number
      const sequenceResult = await tx.$queryRaw`
        SELECT nextval('estimate_sequence') as next_number
      `;
      const nextNumber = sequenceResult[0].next_number;

      return tx.estimate.create({
        data: {
          ...data,
          tenantId: context.tenantId,
          estimateNumber: `EST-${new Date().getFullYear()}-${String(
            nextNumber
          ).padStart(6, "0")}`,
          createdByActorId: context.actorId,
          status: "DRAFT",
        },
        include: {
          crmAccount: true,
          sections: true,
        },
      });
    });
  }

  /**
   * 📝 UPDATE ESTIMATE - Role-based with status restrictions
   */
  async updateEstimate(
    context: RoleSecurityContext,
    estimateId: string,
    data: any
  ) {
    return this.withRoleBasedRLS(context, async (tx, ctx) => {
      // Check current estimate status and ownership
      const currentEstimate = await tx.estimate.findUnique({
        where: { tenantId: ctx.tenantId, id: estimateId },
        select: { status: true, createdByActorId: true },
      });

      if (!currentEstimate) {
        throw new Error("Estimate not found");
      }

      // Business rules based on role and status
      if (currentEstimate.status === "APPROVED") {
        // Only ADMIN can modify approved estimates
        if (ctx.role !== "ADMIN") {
          throw new Error("Cannot modify approved estimates");
        }
      }

      if (currentEstimate.status === "DRAFT") {
        // WORKER/DRIVER can only edit their own draft estimates
        if (
          ctx.roleHierarchy >= 8 &&
          currentEstimate.createdByActorId !== ctx.actorId
        ) {
          throw new Error("Can only edit own draft estimates");
        }
      }

      return tx.estimate.update({
        where: { tenantId: ctx.tenantId, id: estimateId },
        data: {
          ...data,
          updatedByActorId: ctx.actorId,
        },
      });
    });
  }

  /**
   * ✅ APPROVE ESTIMATE - PM permission validation with TenantSettings
   */
  async approveEstimate(context: RoleSecurityContext, estimateId: string) {
    // Use PM-specific RLS with TenantSettings validation
    return withPMRLS(
      this.prisma,
      context,
      "canApproveEstimates", // Required PM permission
      async (tx) => {
        // Verify estimate is in approvable state
        const estimate = await tx.estimate.findUnique({
          where: { tenantId: context.tenantId, id: estimateId },
          select: { status: true, totalAmount: true },
        });

        if (!estimate) {
          throw new Error("Estimate not found");
        }

        if (estimate.status !== "SUBMITTED") {
          throw new Error("Estimate must be submitted for approval");
        }

        // Update estimate status
        const approvedEstimate = await tx.estimate.update({
          where: { tenantId: context.tenantId, id: estimateId },
          data: {
            status: "APPROVED",
            approvedAt: new Date(),
            approvedByActorId: context.actorId,
          },
        });

        // Auto-generate project if enabled
        if (approvedEstimate.autoCreateProjectOnApproval) {
          await this.autoCreateProject(tx, context, approvedEstimate);
        }

        return approvedEstimate;
      }
    );
  }

  /**
   * 🗑️ DELETE ESTIMATE - PM permission with ownership validation
   */
  async deleteEstimate(context: RoleSecurityContext, estimateId: string) {
    return withPMRLS(
      this.prisma,
      context,
      "canDeleteOwnEstimates",
      async (tx) => {
        const estimate = await tx.estimate.findUnique({
          where: { tenantId: context.tenantId, id: estimateId },
          select: { createdByActorId: true, status: true },
        });

        if (!estimate) {
          throw new Error("Estimate not found");
        }

        // PM can only delete their own estimates (unless ADMIN)
        if (
          context.role !== "ADMIN" &&
          estimate.createdByActorId !== context.actorId
        ) {
          throw new Error("Can only delete own estimates");
        }

        // Cannot delete approved estimates
        if (estimate.status === "APPROVED") {
          throw new Error("Cannot delete approved estimates");
        }

        return tx.estimate.update({
          where: { tenantId: context.tenantId, id: estimateId },
          data: {
            deletedAt: new Date(),
            deletedByActorId: context.actorId,
          },
        });
      }
    );
  }

  /**
   * Helper: Auto-create project from approved estimate
   */
  private async autoCreateProject(
    tx: any,
    context: SecurityContext,
    estimate: any
  ) {
    return tx.project.create({
      data: {
        tenantId: context.tenantId,
        globalId: estimate.globalId, // 1:1:1 traceability
        projectNumber: estimate.estimateNumber,
        projectName: estimate.title,
        sourceEstimateId: estimate.id,
        status: "PLANNING",
        totalBudgetedCost: estimate.totalAmount,
        createdByActorId: context.actorId,
      },
    });
  }
}

// ============================================================================
// PROJECT SERVICE EXAMPLES
// ============================================================================

export class ProjectService extends BaseRLSService {
  /**
   * 📋 LIST PROJECTS - Role-based with assignment filtering
   */
  async listProjects(context: RoleSecurityContext, filters?: any) {
    return this.withRoleBasedRLS(context, async (tx, ctx) => {
      let whereClause: any = {
        tenantId: ctx.tenantId,
        deletedAt: null,
        ...filters,
      };

      // WORKER/DRIVER: Only see assigned projects
      if (ctx.roleHierarchy >= 8 && ctx.assignedProjects) {
        whereClause.id = { in: ctx.assignedProjects };
      }

      return tx.project.findMany({
        where: whereClause,
        include: {
          projectManager: true,
          superintendent: true,
          phases: {
            include: {
              tasks: true,
            },
          },
        },
        orderBy: { createdAt: "desc" },
      });
    });
  }

  /**
   * 🎯 GET PROJECT DASHBOARD - Project-scoped with role-based visibility
   */
  async getProjectDashboard(context: RoleSecurityContext, projectId: string) {
    return withProjectRLS(this.prisma, context, projectId, async (tx, ctx) => {
      const dashboardData: any = {
        project: await tx.project.findUnique({
          where: { tenantId: ctx.tenantId, id: projectId },
          include: {
            phases: {
              include: {
                tasks: {
                  where:
                    ctx.roleHierarchy >= 8
                      ? {
                          // WORKER/DRIVER: Only see assigned tasks
                          assignments: {
                            some: { memberId: ctx.memberId },
                          },
                        }
                      : undefined,
                },
              },
            },
          },
        }),
      };

      // Financial data for PM+ roles only
      if (ctx.roleHierarchy <= 2) {
        dashboardData.budget = await tx.projectBudget.findMany({
          where: { tenantId: ctx.tenantId, projectId },
        });

        dashboardData.costSummary = await tx.projectBudgetLineItem.groupBy({
          by: ["costCategory"],
          where: { tenantId: ctx.tenantId, projectId },
          _sum: {
            budgetedAmount: true,
            actualCost: true,
          },
        });
      }

      // Recent activity for all roles
      dashboardData.recentActivity = await tx.projectHistoryEvent.findMany({
        where: { tenantId: ctx.tenantId, projectId },
        orderBy: { createdAt: "desc" },
        take: 10,
      });

      return dashboardData;
    });
  }

  /**
   * ⏰ LOG TIME - Worker time tracking with validation
   */
  async logTime(
    context: RoleSecurityContext,
    projectId: string,
    taskId: string,
    timeData: any
  ) {
    // Workers can only log time for assigned projects/tasks
    return withProjectRLS(this.prisma, context, projectId, async (tx, ctx) => {
      // Verify task assignment for WORKER/DRIVER
      if (ctx.roleHierarchy >= 8) {
        const assignment = await tx.projectTaskAssignment.findFirst({
          where: {
            tenantId: ctx.tenantId,
            taskId,
            memberId: ctx.memberId,
          },
        });

        if (!assignment) {
          throw new Error("Not assigned to this task");
        }
      }

      // Create timesheet entry
      return tx.timesheetEntry.create({
        data: {
          ...timeData,
          tenantId: ctx.tenantId,
          memberId: ctx.memberId,
          projectId,
          taskId,
          createdByActorId: ctx.actorId,
        },
      });
    });
  }

  /**
   * 📊 UPDATE TASK PROGRESS - Role-based progress updates
   */
  async updateTaskProgress(
    context: RoleSecurityContext,
    projectId: string,
    taskId: string,
    progressData: { percentComplete: number; notes?: string }
  ) {
    return withProjectRLS(this.prisma, context, projectId, async (tx, ctx) => {
      // Business rules for progress updates
      let allowUpdate = false;

      if (ctx.roleHierarchy <= 2) {
        // ADMIN, PROJECT_MANAGER: Can update any task
        allowUpdate = true;
      } else if (ctx.roleHierarchy >= 8) {
        // WORKER, DRIVER: Can only update assigned tasks
        const assignment = await tx.projectTaskAssignment.findFirst({
          where: {
            tenantId: ctx.tenantId,
            taskId,
            memberId: ctx.memberId,
          },
        });
        allowUpdate = !!assignment;
      }

      if (!allowUpdate) {
        throw new Error("Not authorized to update this task");
      }

      // Update task progress
      const updatedTask = await tx.projectTask.update({
        where: { tenantId: ctx.tenantId, id: taskId },
        data: {
          percentComplete: progressData.percentComplete,
          updatedByActorId: ctx.actorId,
        },
      });

      // Add progress note if provided
      if (progressData.notes) {
        await tx.projectTaskComment.create({
          data: {
            tenantId: ctx.tenantId,
            taskId,
            commentText: progressData.notes,
            commentType: "PROGRESS_UPDATE",
            createdByActorId: ctx.actorId,
          },
        });
      }

      // Recalculate project completion percentage
      await this.recalculateProjectProgress(tx, ctx.tenantId, projectId);

      return updatedTask;
    });
  }

  /**
   * Helper: Recalculate project progress
   */
  private async recalculateProjectProgress(
    tx: any,
    tenantId: string,
    projectId: string
  ) {
    const progressData = await tx.projectTask.aggregate({
      where: { tenantId, projectId },
      _avg: { percentComplete: true },
      _count: true,
    });

    await tx.project.update({
      where: { tenantId, id: projectId },
      data: {
        percentComplete: progressData._avg.percentComplete || 0,
        totalTaskCount: progressData._count,
      },
    });
  }
}

// ============================================================================
// INVOICE SERVICE EXAMPLES
// ============================================================================

export class InvoiceService extends BaseRLSService {
  /**
   * 💰 CREATE INVOICE - PM operation with approval validation
   */
  async createInvoice(context: RoleSecurityContext, invoiceData: any) {
    return withPMRLS(
      this.prisma,
      context,
      "canApproveInvoices", // PM must have invoice permissions
      async (tx) => {
        // Auto-generate invoice number
        const sequenceResult = await tx.$queryRaw`
          SELECT nextval('invoice_sequence') as next_number
        `;
        const nextNumber = sequenceResult[0].next_number;

        return tx.invoice.create({
          data: {
            ...invoiceData,
            tenantId: context.tenantId,
            invoiceNumber: `INV-${new Date().getFullYear()}-${String(
              nextNumber
            ).padStart(6, "0")}`,
            status: "DRAFT",
            createdByActorId: context.actorId,
          },
          include: {
            lineItems: true,
            crmAccount: true,
          },
        });
      }
    );
  }

  /**
   * 📤 SEND INVOICE TO CLIENT - PM operation with client portal integration
   */
  async sendInvoiceToClient(context: RoleSecurityContext, invoiceId: string) {
    return withPMRLS(this.prisma, context, "canApproveInvoices", async (tx) => {
      // Update invoice status
      const invoice = await tx.invoice.update({
        where: { tenantId: context.tenantId, id: invoiceId },
        data: {
          status: "SENT",
          sentToClientAt: new Date(),
          sentByActorId: context.actorId,
        },
        include: { crmAccount: true },
      });

      // Create public viewing link
      const publicLink = await tx.invoicePublicLink.create({
        data: {
          tenantId: context.tenantId,
          invoiceId,
          linkToken: this.generateSecureToken(),
          expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
          allowedViews: 100,
          createdByActorId: context.actorId,
        },
      });

      // TODO: Send email to client with public link
      // await this.emailService.sendInvoiceToClient(invoice, publicLink);

      return { invoice, publicLink };
    });
  }

  /**
   * Helper: Generate secure token for public links
   */
  private generateSecureToken(): string {
    return Buffer.from(
      `${Date.now()}-${Math.random().toString(36).substring(2)}`
    ).toString("base64url");
  }
}

// ============================================================================
// ADMIN SERVICE EXAMPLES
// ============================================================================

export class AdminService extends BaseRLSService {
  /**
   * 🔧 TENANT CONFIGURATION - Admin-only operations
   */
  async updateTenantSettings(context: RoleSecurityContext, settingsData: any) {
    return withAdminRLS(this.prisma, context, async (tx) => {
      return tx.tenantSettings.upsert({
        where: { tenantId: context.tenantId },
        create: {
          ...settingsData,
          tenantId: context.tenantId,
          createdByActorId: context.actorId,
        },
        update: {
          ...settingsData,
          updatedByActorId: context.actorId,
        },
      });
    });
  }

  /**
   * 📊 SYSTEM ANALYTICS - Admin-only with full tenant data
   */
  async getSystemAnalytics(context: RoleSecurityContext) {
    return withAdminRLS(this.prisma, context, async (tx) => {
      const analytics = {
        // User activity
        userStats: await tx.member.groupBy({
          by: ["role"],
          where: { tenantId: context.tenantId },
          _count: true,
        }),

        // Project stats
        projectStats: await tx.project.groupBy({
          by: ["status"],
          where: { tenantId: context.tenantId },
          _count: true,
          _sum: {
            totalBudgetedCost: true,
            totalActualCost: true,
          },
        }),

        // Financial summary
        financialSummary: await tx.invoice.aggregate({
          where: { tenantId: context.tenantId },
          _sum: {
            totalAmount: true,
            amountPaid: true,
          },
          _count: true,
        }),

        // Security events
        securityEvents: await tx.accessAuditEvent.groupBy({
          by: ["eventType"],
          where: {
            tenantId: context.tenantId,
            createdAt: {
              gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // Last 7 days
            },
          },
          _count: true,
        }),
      };

      return analytics;
    });
  }

  /**
   * 🏢 BULK USER MANAGEMENT - Admin-only operations
   */
  async bulkUpdateUserRoles(
    context: RoleSecurityContext,
    updates: Array<{ memberId: string; newRole: string; newHierarchy: number }>
  ) {
    return withAdminRLS(this.prisma, context, async (tx) => {
      const results = [];

      for (const update of updates) {
        // Validate role hierarchy
        const validCombinations = [
          { role: "ADMIN", hierarchy: 0 },
          { role: "PROJECT_MANAGER", hierarchy: 2 },
          { role: "WORKER", hierarchy: 8 },
          { role: "DRIVER", hierarchy: 9 },
          { role: "VIEWER", hierarchy: 10 },
        ];

        const isValid = validCombinations.some(
          (combo) =>
            combo.role === update.newRole &&
            combo.hierarchy === update.newHierarchy
        );

        if (!isValid) {
          throw new Error(
            `Invalid role/hierarchy combination: ${update.newRole}/${update.newHierarchy}`
          );
        }

        // Update member role
        const updatedMember = await tx.member.update({
          where: { tenantId: context.tenantId, id: update.memberId },
          data: {
            role: update.newRole,
            roleHierarchy: update.newHierarchy,
            updatedByActorId: context.actorId,
          },
        });

        results.push(updatedMember);
      }

      return results;
    });
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/**
 * Example: Initialize services with proper context
 */
export class ServiceFactory {
  constructor(private prisma: PrismaClient) {}

  createEstimateService() {
    return new EstimateService(this.prisma);
  }

  createProjectService() {
    return new ProjectService(this.prisma);
  }

  createInvoiceService() {
    return new InvoiceService(this.prisma);
  }

  createAdminService() {
    return new AdminService(this.prisma);
  }

  /**
   * Helper: Create security context from JWT token
   */
  createSecurityContext(token: any): RoleSecurityContext {
    return {
      tenantId: token.tenantId,
      actorId: token.actorId,
      memberId: token.memberId,
      role: token.role,
      roleHierarchy: token.roleHierarchy,
      sessionId: token.sessionId,
      assignedProjects: token.assignedProjects,
      pmPermissions: token.pmPermissions,
    };
  }
}

// ============================================================================
// CONTROLLER INTEGRATION EXAMPLE
// ============================================================================

/**
 * Example Express.js controller with RLS integration
 */
export class EstimateController {
  constructor(
    private estimateService: EstimateService,
    private serviceFactory: ServiceFactory
  ) {}

  async listEstimates(req: any, res: any) {
    try {
      // Extract security context from JWT
      const context = this.serviceFactory.createSecurityContext(req.user);

      // Service handles all RLS logic
      const estimates = await this.estimateService.listEstimates(
        context,
        req.query
      );

      res.json({
        success: true,
        data: estimates,
        meta: {
          tenantId: context.tenantId,
          role: context.role,
          count: estimates.length,
        },
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        error: error.message,
        type: error.name,
      });
    }
  }

  async approveEstimate(req: any, res: any) {
    try {
      const context = this.serviceFactory.createSecurityContext(req.user);
      const { estimateId } = req.params;

      const approvedEstimate = await this.estimateService.approveEstimate(
        context,
        estimateId
      );

      res.json({
        success: true,
        data: approvedEstimate,
        message: "Estimate approved successfully",
      });
    } catch (error) {
      // RLS errors provide context for debugging
      res.status(error.name === "RLSPermissionError" ? 403 : 400).json({
        success: false,
        error: error.message,
        type: error.name,
        context: error.context,
      });
    }
  }
}

export {
  AdminService,
  BaseRLSService,
  EstimateController,
  EstimateService,
  InvoiceService,
  ProjectService,
  ServiceFactory,
};
