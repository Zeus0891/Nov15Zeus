/**
 * 🏛️ BeeSmart Pro Hybrid Service Examples v8.1
 * Production-ready service implementations using Hybrid RLS Engine
 *
 * Demonstrates simplified interface patterns while maintaining enterprise features
 */

import { PrismaClient } from "@prisma/client";
import {
  initializeHybridRLS,
  RLSSecurityError,
  RLSValidationError,
  withProjectRLS,
  withRoleRLS,
  withTenantRLS,
  type AdvancedSecurityContext,
} from "./withRLS-hybrid";

// Initialize the RLS engine
const prisma = new PrismaClient();
const rlsEngine = initializeHybridRLS(prisma);

// ============================================================================
// ESTIMATE SERVICE - Simple Interface Pattern
// ============================================================================

export class EstimateService {
  /**
   * 🚀 SIMPLE: Standard CRUD using tenant-scoped RLS
   */
  async findEstimates(tenantId: string, actorId: string, filters: any = {}) {
    return withTenantRLS(tenantId, actorId, async (tx) => {
      return tx.estimate.findMany({
        where: {
          tenantId,
          deletedAt: null,
          ...filters,
        },
        include: {
          sections: true,
          lineItems: true,
          attachments: true,
        },
        orderBy: {
          createdAt: "desc",
        },
      });
    });
  }

  /**
   * 🚀 SIMPLE: Create estimate with basic validation
   */
  async createEstimate(tenantId: string, actorId: string, data: any) {
    return withTenantRLS(tenantId, actorId, async (tx) => {
      // Generate estimate number
      const count = await tx.estimate.count({ where: { tenantId } });
      const estimateNumber = `EST-${new Date().getFullYear()}-${String(
        count + 1
      ).padStart(5, "0")}`;

      return tx.estimate.create({
        data: {
          ...data,
          tenantId,
          estimateNumber,
          globalId: data.globalId || crypto.randomUUID(),
          createdByActorId: actorId,
          status: "DRAFT",
        },
        include: {
          sections: true,
          lineItems: true,
        },
      });
    });
  }

  /**
   * 🚀 ADVANCED: Approval workflow using role-based RLS
   */
  async approveEstimate(ctx: AdvancedSecurityContext, estimateId: string) {
    return withRoleRLS(
      ctx,
      async (tx, context) => {
        // Role-based approval logic
        if (context.roleHierarchy > 4) {
          // Below ESTIMATOR level
          throw new RLSSecurityError(
            "Insufficient privileges to approve estimates",
            context,
            "APPROVAL_DENIED"
          );
        }

        const estimate = await tx.estimate.findUnique({
          where: { tenantId_id: { tenantId: ctx.tenantId, id: estimateId } },
        });

        if (!estimate) {
          throw new Error("Estimate not found");
        }

        if (estimate.status !== "SUBMITTED") {
          throw new Error("Estimate must be submitted before approval");
        }

        // Financial controllers and above can approve any amount
        // Project managers need secondary approval for high-value estimates
        let requiresSecondaryApproval = false;
        if (context.roleHierarchy >= 3 && estimate.totalAmount > 50000) {
          requiresSecondaryApproval = true;
        }

        const updatedEstimate = await tx.estimate.update({
          where: { tenantId_id: { tenantId: ctx.tenantId, id: estimateId } },
          data: {
            status: requiresSecondaryApproval
              ? "PENDING_SECONDARY_APPROVAL"
              : "APPROVED",
            approvedAt: requiresSecondaryApproval ? null : new Date(),
            approvedByActorId: requiresSecondaryApproval ? null : ctx.actorId,
            requiresSecondaryApproval,
            updatedByActorId: ctx.actorId,
          },
        });

        // Auto-create project if approved and flag is set
        if (
          updatedEstimate.status === "APPROVED" &&
          updatedEstimate.autoCreateProjectOnApproval
        ) {
          await this.autoCreateProject(tx, updatedEstimate, ctx);
        }

        return updatedEstimate;
      },
      { enableAudit: true }
    );
  }

  /**
   * Auto-create project from approved estimate
   */
  private async autoCreateProject(
    tx: any,
    estimate: any,
    ctx: AdvancedSecurityContext
  ) {
    const projectData = {
      tenantId: estimate.tenantId,
      globalId: estimate.globalId, // 1:1:1 traceability
      projectNumber: estimate.estimateNumber, // Same number
      projectName: estimate.title,
      description: estimate.description,
      sourceEstimateId: estimate.id,
      status: "PLANNING",
      budgetStatus: "ON_BUDGET",
      scheduleStatus: "ON_SCHEDULE",
      totalBudgetedCost: estimate.totalAmount,
      currencyCode: estimate.currencyCode,
      crmAccountId: estimate.crmAccountId,
      crmContactId: estimate.crmContactId,
      createdByActorId: ctx.actorId,
    };

    return tx.project.create({
      data: projectData,
    });
  }
}

// ============================================================================
// PROJECT SERVICE - Advanced Pattern with Role Context
// ============================================================================

export class ProjectService {
  /**
   * 🚀 ADVANCED: Project access with role-based filtering
   */
  async findProjects(ctx: AdvancedSecurityContext, filters: any = {}) {
    return withRoleRLS(ctx, async (tx, context) => {
      let whereClause: any = {
        tenantId: ctx.tenantId,
        deletedAt: null,
        ...filters,
      };

      // Role-based project filtering
      if (context.roleHierarchy >= 7) {
        // FIELD_SUPERVISOR and below
        // Can only see assigned projects
        whereClause.OR = [
          { projectManagerMemberId: ctx.memberId },
          { superintendentMemberId: ctx.memberId },
          {
            teamMembers: {
              some: { memberId: ctx.memberId, isActive: true },
            },
          },
        ];
      } else if (context.roleHierarchy >= 4) {
        // ESTIMATOR and above
        // Can see projects in their department or that they manage
        if (context.departmentAccess && context.departmentAccess.length > 0) {
          whereClause.OR = [
            { projectManagerMemberId: ctx.memberId },
            // Add department-based filtering if needed
          ];
        }
      }
      // ADMIN and above can see all projects (no additional filtering)

      return tx.project.findMany({
        where: whereClause,
        include: {
          phases: {
            where: { deletedAt: null },
            orderBy: { phaseNumber: "asc" },
          },
          milestones: {
            where: { deletedAt: null },
            orderBy: { targetDate: "asc" },
          },
          teamMembers: {
            where: { isActive: true },
            include: {
              member: {
                select: {
                  id: true,
                  firstName: true,
                  lastName: true,
                  email: true,
                },
              },
            },
          },
        },
        orderBy: {
          createdAt: "desc",
        },
      });
    });
  }

  /**
   * 🚀 ADVANCED: Update project with approval workflow
   */
  async updateProject(
    ctx: AdvancedSecurityContext,
    projectId: string,
    data: any
  ) {
    return withRoleRLS(
      ctx,
      async (tx, context) => {
        const project = await tx.project.findUnique({
          where: { tenantId_id: { tenantId: ctx.tenantId, id: projectId } },
        });

        if (!project) {
          throw new Error("Project not found");
        }

        // Check if user can modify this project
        const canModify =
          context.roleHierarchy <= 3 || // PROJECT_MANAGER and above
          project.projectManagerMemberId === ctx.memberId ||
          project.superintendentMemberId === ctx.memberId;

        if (!canModify) {
          throw new RLSSecurityError(
            "Insufficient privileges to modify this project",
            context,
            "PROJECT_ACCESS_DENIED"
          );
        }

        // Sensitive fields require higher privileges
        const sensitiveFields = [
          "contractValue",
          "totalBudgetedCost",
          "status",
        ];
        const hasSensitiveChanges = sensitiveFields.some(
          (field) => field in data
        );

        if (hasSensitiveChanges && context.roleHierarchy > 2) {
          throw new RLSSecurityError(
            "Financial updates require FINANCIAL_CONTROLLER or higher privileges",
            context,
            "FINANCIAL_ACCESS_DENIED"
          );
        }

        return tx.project.update({
          where: { tenantId_id: { tenantId: ctx.tenantId, id: projectId } },
          data: {
            ...data,
            updatedByActorId: ctx.actorId,
          },
        });
      },
      { enableAudit: true }
    );
  }

  /**
   * 🚀 SIMPLE: Project-scoped task operations
   */
  async findProjectTasks(
    tenantId: string,
    actorId: string,
    projectIds: string[]
  ) {
    return withProjectRLS(tenantId, actorId, projectIds, async (tx) => {
      return tx.projectTask.findMany({
        where: {
          tenantId,
          projectId: { in: projectIds },
          deletedAt: null,
        },
        include: {
          assignments: {
            where: { isActive: true },
            include: {
              member: {
                select: { firstName: true, lastName: true, email: true },
              },
            },
          },
          attachments: true,
          comments: {
            orderBy: { createdAt: "desc" },
            take: 5,
          },
        },
        orderBy: [{ projectId: "asc" }, { wbsCode: "asc" }],
      });
    });
  }
}

// ============================================================================
// INVOICE SERVICE - Financial Operations with Approval Context
// ============================================================================

export class InvoiceService {
  /**
   * 🚀 SIMPLE: Standard invoice operations
   */
  async findInvoices(tenantId: string, actorId: string, filters: any = {}) {
    return withTenantRLS(tenantId, actorId, async (tx) => {
      return tx.invoice.findMany({
        where: {
          tenantId,
          deletedAt: null,
          ...filters,
        },
        include: {
          lineItems: true,
          payments: true,
          attachments: true,
        },
        orderBy: {
          issueDate: "desc",
        },
      });
    });
  }

  /**
   * 🚀 ADVANCED: Invoice approval with financial controls
   */
  async approveInvoice(ctx: AdvancedSecurityContext, invoiceId: string) {
    return withRoleRLS(
      ctx,
      async (tx, context) => {
        // Only financial roles can approve invoices
        if (context.roleHierarchy > 6) {
          // Below ACCOUNTANT level
          throw new RLSSecurityError(
            "Insufficient privileges to approve invoices",
            context,
            "FINANCIAL_APPROVAL_DENIED"
          );
        }

        const invoice = await tx.invoice.findUnique({
          where: { tenantId_id: { tenantId: ctx.tenantId, id: invoiceId } },
        });

        if (!invoice) {
          throw new Error("Invoice not found");
        }

        // Approval authority checks
        const maxAmount = context.approvalAuthority?.maxAmount || 0;
        const requiresSecondary =
          context.approvalAuthority?.requiresSecondaryApproval || false;

        if (invoice.totalAmount > maxAmount) {
          throw new RLSSecurityError(
            `Invoice amount exceeds approval authority (${maxAmount})`,
            context,
            "APPROVAL_LIMIT_EXCEEDED"
          );
        }

        // Can't approve own work unless explicitly allowed
        const canApproveOwnWork =
          context.approvalAuthority?.canApproveOwnWork || false;
        if (invoice.createdByActorId === ctx.actorId && !canApproveOwnWork) {
          throw new RLSSecurityError(
            "Cannot approve own invoice",
            context,
            "SELF_APPROVAL_DENIED"
          );
        }

        return tx.invoice.update({
          where: { tenantId_id: { tenantId: ctx.tenantId, id: invoiceId } },
          data: {
            status: requiresSecondary
              ? "PENDING_SECONDARY_APPROVAL"
              : "APPROVED",
            approvedAt: requiresSecondary ? null : new Date(),
            approvedByActorId: requiresSecondary ? null : ctx.actorId,
            updatedByActorId: ctx.actorId,
          },
        });
      },
      { enableAudit: true }
    );
  }

  /**
   * 🚀 SIMPLE: Progress billing from project milestones
   */
  async createProgressInvoice(
    tenantId: string,
    actorId: string,
    projectId: string,
    milestoneId: string
  ) {
    return withTenantRLS(tenantId, actorId, async (tx) => {
      const milestone = await tx.projectMilestone.findUnique({
        where: { tenantId_id: { tenantId, id: milestoneId } },
        include: {
          project: true,
        },
      });

      if (!milestone || milestone.projectId !== projectId) {
        throw new Error("Milestone not found or not associated with project");
      }

      if (!milestone.isBillingMilestone) {
        throw new Error("Milestone is not configured for billing");
      }

      if (milestone.status !== "COMPLETED") {
        throw new Error("Milestone must be completed before billing");
      }

      // Generate invoice number (same as project number)
      const invoiceNumber = milestone.project.projectNumber;

      const invoice = await tx.invoice.create({
        data: {
          tenantId,
          globalId: milestone.project.globalId, // 1:1:1 traceability
          invoiceNumber,
          title: `Progress Invoice - ${milestone.milestoneName}`,
          description: `Billing for completed milestone: ${milestone.milestoneName}`,
          billingType: "MILESTONE",
          sourceProjectId: projectId,
          relatedMilestoneId: milestoneId,
          subtotalAmount: milestone.billingAmount || 0,
          totalAmount: milestone.billingAmount || 0,
          currencyCode: milestone.project.currencyCode || "USD",
          status: "DRAFT",
          createdByActorId: actorId,
        },
      });

      // Create invoice line item for the milestone
      await tx.invoiceLineItem.create({
        data: {
          tenantId,
          invoiceId: invoice.id,
          description: milestone.milestoneName,
          quantity: 1,
          unitPrice: milestone.billingAmount || 0,
          lineTotal: milestone.billingAmount || 0,
          createdByActorId: actorId,
        },
      });

      return invoice;
    });
  }
}

// ============================================================================
// INVENTORY SERVICE - Field Operations with Location Context
// ============================================================================

export class InventoryService {
  /**
   * 🚀 SIMPLE: Inventory lookup with location filtering
   */
  async findInventoryItems(
    tenantId: string,
    actorId: string,
    locationId?: string
  ) {
    return withTenantRLS(tenantId, actorId, async (tx) => {
      const whereClause: any = {
        tenantId,
        isActive: true,
      };

      if (locationId) {
        whereClause.stock = {
          some: {
            locationId,
            quantity: { gt: 0 },
          },
        };
      }

      return tx.inventoryItem.findMany({
        where: whereClause,
        include: {
          category: true,
          stock: {
            where: locationId ? { locationId } : undefined,
            include: {
              location: true,
              bin: true,
            },
          },
          suppliers: {
            include: {
              supplier: true,
            },
          },
        },
        orderBy: {
          itemName: "asc",
        },
      });
    });
  }

  /**
   * 🚀 ADVANCED: Field inventory transfer with role validation
   */
  async transferInventory(
    ctx: AdvancedSecurityContext,
    itemId: string,
    fromLocationId: string,
    toLocationId: string,
    quantity: number,
    projectId?: string
  ) {
    return withRoleRLS(
      ctx,
      async (tx, context) => {
        // Field supervisors and above can transfer inventory
        if (context.roleHierarchy > 7) {
          throw new RLSSecurityError(
            "Insufficient privileges for inventory transfers",
            context,
            "INVENTORY_TRANSFER_DENIED"
          );
        }

        // Validate inventory availability
        const fromStock = await tx.inventoryStock.findUnique({
          where: {
            tenantId_itemId_locationId: {
              tenantId: ctx.tenantId,
              itemId,
              locationId: fromLocationId,
            },
          },
        });

        if (!fromStock || fromStock.quantity < quantity) {
          throw new Error("Insufficient inventory quantity");
        }

        // Create transfer transaction
        const transfer = await tx.inventoryTransfer.create({
          data: {
            tenantId: ctx.tenantId,
            transferNumber: `TRF-${Date.now()}`,
            fromLocationId,
            toLocationId,
            status: "PENDING",
            requestedByMemberId: ctx.memberId,
            projectId,
            createdByActorId: ctx.actorId,
          },
        });

        // Create transfer line
        await tx.inventoryTransferLine.create({
          data: {
            tenantId: ctx.tenantId,
            transferId: transfer.id,
            itemId,
            requestedQuantity: quantity,
            createdByActorId: ctx.actorId,
          },
        });

        // If field supervisor, auto-approve small transfers
        if (context.roleHierarchy === 7 && quantity <= 10) {
          // Auto-approve limit
          await tx.inventoryTransfer.update({
            where: { tenantId_id: { tenantId: ctx.tenantId, id: transfer.id } },
            data: {
              status: "APPROVED",
              approvedAt: new Date(),
              approvedByMemberId: ctx.memberId,
            },
          });

          // Execute the transfer
          await this.executeTransfer(tx, ctx, transfer.id);
        }

        return transfer;
      },
      { enableAudit: true }
    );
  }

  /**
   * Execute inventory transfer with stock updates
   */
  private async executeTransfer(
    tx: any,
    ctx: AdvancedSecurityContext,
    transferId: string
  ) {
    const transfer = await tx.inventoryTransfer.findUnique({
      where: { tenantId_id: { tenantId: ctx.tenantId, id: transferId } },
      include: {
        lines: true,
      },
    });

    for (const line of transfer.lines) {
      // Reduce from stock
      await tx.inventoryStock.update({
        where: {
          tenantId_itemId_locationId: {
            tenantId: ctx.tenantId,
            itemId: line.itemId,
            locationId: transfer.fromLocationId,
          },
        },
        data: {
          quantity: { decrement: line.requestedQuantity },
        },
      });

      // Add to destination (upsert in case location doesn't have this item)
      await tx.inventoryStock.upsert({
        where: {
          tenantId_itemId_locationId: {
            tenantId: ctx.tenantId,
            itemId: line.itemId,
            locationId: transfer.toLocationId,
          },
        },
        update: {
          quantity: { increment: line.requestedQuantity },
        },
        create: {
          tenantId: ctx.tenantId,
          itemId: line.itemId,
          locationId: transfer.toLocationId,
          quantity: line.requestedQuantity,
        },
      });
    }

    // Mark transfer as completed
    await tx.inventoryTransfer.update({
      where: { tenantId_id: { tenantId: ctx.tenantId, id: transferId } },
      data: {
        status: "COMPLETED",
        completedAt: new Date(),
      },
    });
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/**
 * 🚀 Example: Simple tenant-scoped operations
 */
export async function exampleSimpleOperations() {
  const tenantId = "tenant-123";
  const actorId = "actor-456";

  const estimateService = new EstimateService();

  // Simple read operation
  const estimates = await estimateService.findEstimates(tenantId, actorId, {
    status: "APPROVED",
  });

  // Simple create operation
  const newEstimate = await estimateService.createEstimate(tenantId, actorId, {
    title: "Office Renovation Project",
    description:
      "Complete office renovation including HVAC, electrical, and flooring",
    crmAccountId: "account-789",
    totalAmount: 75000,
  });

  console.log("✅ Simple operations completed:", {
    estimates: estimates.length,
    newEstimate: newEstimate.id,
  });
}

/**
 * 🚀 Example: Advanced role-based operations
 */
export async function exampleAdvancedOperations() {
  const ctx: AdvancedSecurityContext = {
    tenantId: "tenant-123",
    actorId: "actor-456",
    memberId: "member-789",
    roles: ["PROJECT_MANAGER"],
    roleHierarchy: 3,
    assignedProjects: ["project-001", "project-002"],
    approvalAuthority: {
      maxAmount: 100000,
      canApproveOwnWork: false,
    },
    enableAudit: true,
  };

  const estimateService = new EstimateService();
  const projectService = new ProjectService();

  // Advanced approval operation
  const approvalResult = await estimateService.approveEstimate(
    ctx,
    "estimate-123"
  );

  // Role-based project filtering
  const projects = await projectService.findProjects(ctx, {
    status: "ACTIVE",
  });

  console.log("✅ Advanced operations completed:", {
    approvalResult: approvalResult.data,
    executionTime: approvalResult.executionTime,
    projects: projects.data?.length,
  });
}

/**
 * 🚀 Example: Error handling
 */
export async function exampleErrorHandling() {
  const ctx: AdvancedSecurityContext = {
    tenantId: "tenant-123",
    actorId: "actor-456",
    memberId: "member-789",
    roles: ["EMPLOYEE"], // Low privilege role
    roleHierarchy: 8,
  };

  const estimateService = new EstimateService();

  try {
    // This should fail due to insufficient privileges
    await estimateService.approveEstimate(ctx, "estimate-123");
  } catch (error) {
    if (error instanceof RLSSecurityError) {
      console.log("🔒 Security error caught:", {
        message: error.message,
        violationType: error.violationType,
        context: error.context,
      });
    } else if (error instanceof RLSValidationError) {
      console.log("❌ Validation error caught:", {
        message: error.message,
        field: error.field,
      });
    } else {
      console.log("💥 Unexpected error:", error.message);
    }
  }
}

// Export all services
export { EstimateService, InventoryService, InvoiceService, ProjectService };
