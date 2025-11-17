# 🔧 Technical Implementation Guide

**Version**: 1.0  
**Last Updated**: November 17, 2025  
**Target Audience**: Development Teams, Technical Architects, DevOps  
**Prerequisites**: Node.js, TypeScript, PostgreSQL, Prisma knowledge

---

## 📋 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Technology Stack](#technology-stack)
3. [Database Architecture](#database-architecture)
4. [Module Implementation Pattern](#module-implementation-pattern)
5. [Actor Attribution Implementation](#actor-attribution-implementation)
6. [1:1:1 Traceability Implementation](#111-traceability-implementation)
7. [Multi-Tenant Architecture](#multi-tenant-architecture)
8. [API Design Patterns](#api-design-patterns)
9. [Testing Strategy](#testing-strategy)
10. [Deployment Architecture](#deployment-architecture)

---

## 🏗️ Architecture Overview

### System Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                     CLIENT LAYER                             │
│  Web App (React) │ Mobile Apps (iOS/Android) │ API Clients  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   API GATEWAY LAYER                          │
│         tRPC Router │ REST API │ GraphQL (optional)          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  APPLICATION LAYER                           │
│  Business Logic │ Validation │ Authorization │ Workflows     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    DATA ACCESS LAYER                         │
│           Prisma ORM │ Query Builders │ Transactions         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    DATABASE LAYER                            │
│  PostgreSQL 17 on Neon │ RLS Policies │ Indexes │ Triggers  │
└─────────────────────────────────────────────────────────────┘
```

---

## 💻 Technology Stack

### Core Technologies

**Backend**:
- Node.js 20+ (LTS)
- TypeScript 5.3+
- Express.js 4.18+
- tRPC 10.x (type-safe API)
- Prisma 5.18+ (ORM with UUIDv7 support)
- Zod 3.x (validation)

**Database**:
- PostgreSQL 17
- Neon (serverless PostgreSQL)
- pgvector (for AI embeddings)
- pg_cron (scheduled jobs)

**Frontend** (if applicable):
- React 18+
- Next.js 14+ (App Router)
- TanStack Query (React Query)
- Tailwind CSS 3.x
- shadcn/ui components

**Infrastructure**:
- Docker & Docker Compose
- AWS/Vercel/Railway (deployment options)
- Redis (caching & sessions)
- S3-compatible storage (files/attachments)

---

## 🗄️ Database Architecture

### Prisma Schema Organization

```
/prisma/
├── schema.prisma                 # Main schema file
├── base-templates/
│   ├── BASE_TEMPLATES.prisma    # Pattern templates (BH, B, A)
│   └── README.md                # Pattern documentation
├── modules/
│   ├── accesscontrol.prisma
│   ├── estimate.prisma
│   ├── invoice.prisma
│   ├── projectsCore.prisma
│   ├── projectTaskScheduling.prisma
│   ├── projectRisk.prisma
│   ├── inventoryCore.prisma
│   ├── inventoryTransactions.prisma
│   ├── inventoryControl.prisma
│   ├── crmcore.prisma
│   ├── ... (50+ more modules)
│   └── identity.prisma
└── migrations/
    └── [timestamp]_migration_name/
```

### Base Templates

**Pattern BH (Base Hybrid)** - For parent entities with globalId:
```prisma
model ExampleBH {
  // IDENTITY (BH Pattern - Hybrid Tenant + Global)
  id               String    @id @default(uuid(7)) @db.Uuid
  tenantId         String    @db.Uuid
  globalId         String    @db.Uuid @default(uuid(7))
  
  // BH Constraints (CRITICAL)
  @@unique([tenantId, id])
  @@unique([tenantId, globalId])
  @@index([globalId]) // Cross-tenant queries
  
  // LIFECYCLE
  createdAt        DateTime  @default(now()) @db.Timestamptz(6)
  updatedAt        DateTime  @updatedAt @db.Timestamptz(6)
  deletedAt        DateTime? @db.Timestamptz(6)
  
  // GOVERNANCE
  auditCorrelationId  String?  @db.Uuid
  dataClassification  String?  @db.VarChar(50)
  retentionPolicy     String?  @db.VarChar(50)
  recordSource        String?  @db.VarChar(100)
  metadata            Json?    @db.JsonB
  timezone            String?  @db.VarChar(50)
  
  // ACTOR ATTRIBUTION (Pattern B - Full Relations)
  createdByActorId    String   @db.Uuid
  updatedByActorId    String   @db.Uuid
  deletedByActorId    String?  @db.Uuid
  
  createdByActor   Actor  @relation("ExampleBH_createdBy", fields: [createdByActorId], references: [id], onDelete: Restrict)
  updatedByActor   Actor  @relation("ExampleBH_updatedBy", fields: [updatedByActorId], references: [id], onDelete: Restrict)
  deletedByActor   Actor? @relation("ExampleBH_deletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)
  
  // TENANT RELATION
  tenant  Tenant  @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // BUSINESS FIELDS
  // ... your domain-specific fields here
  
  // INDEXES
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  @@index([updatedAt], type: Brin)
  @@index([tenantId, auditCorrelationId])
  
  @@map("example_bh")
}
```

**Pattern B (Full Actor Relations)** - For critical entities:
```prisma
model ExampleB {
  // IDENTITY (Tenant Pattern)
  id               String    @id @default(uuid(7)) @db.Uuid
  tenantId         String    @db.Uuid
  
  @@unique([tenantId, id])
  
  // LIFECYCLE
  createdAt        DateTime  @default(now()) @db.Timestamptz(6)
  updatedAt        DateTime  @updatedAt @db.Timestamptz(6)
  deletedAt        DateTime? @db.Timestamptz(6)
  
  // GOVERNANCE
  auditCorrelationId  String?  @db.Uuid
  dataClassification  String?  @db.VarChar(50)
  retentionPolicy     String?  @db.VarChar(50)
  metadata            Json?    @db.JsonB
  
  // ACTOR ATTRIBUTION (Pattern B - Full Relations)
  createdByActorId    String   @db.Uuid
  updatedByActorId    String   @db.Uuid
  deletedByActorId    String?  @db.Uuid
  
  createdByActor   Actor  @relation("ExampleB_createdBy", fields: [createdByActorId], references: [id], onDelete: Restrict)
  updatedByActor   Actor  @relation("ExampleB_updatedBy", fields: [updatedByActorId], references: [id], onDelete: Restrict)
  deletedByActor   Actor? @relation("ExampleB_deletedBy", fields: [deletedByActorId], references: [id], onDelete: SetNull)
  
  // TENANT RELATION
  tenant  Tenant  @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // BUSINESS FIELDS
  // ... your domain-specific fields here
  
  @@index([tenantId, deletedAt])
  @@index([createdAt], type: Brin)
  
  @@map("example_b")
}
```

**Pattern A (Lightweight)** - For child/supporting entities:
```prisma
model ExampleA {
  // IDENTITY (Tenant Pattern)
  id               String    @id @default(uuid(7)) @db.Uuid
  tenantId         String    @db.Uuid
  
  @@unique([tenantId, id])
  
  // LIFECYCLE
  createdAt        DateTime  @default(now()) @db.Timestamptz(6)
  updatedAt        DateTime  @updatedAt @db.Timestamptz(6)
  deletedAt        DateTime? @db.Timestamptz(6)
  
  // ACTOR ATTRIBUTION (Pattern A - IDs Only)
  createdByActorId    String   @db.Uuid
  updatedByActorId    String   @db.Uuid
  deletedByActorId    String?  @db.Uuid
  
  // NO Actor relations (lightweight)
  
  // TENANT RELATION
  tenant  Tenant  @relation(fields: [tenantId], references: [id], onDelete: Restrict)
  
  // PARENT RELATION (always required for Pattern A)
  parentId  String  @db.Uuid
  parent    ExampleB  @relation(fields: [tenantId, parentId], references: [tenantId, id], onDelete: Cascade)
  
  // BUSINESS FIELDS
  // ... your domain-specific fields here
  
  @@index([tenantId, parentId])
  @@index([tenantId, deletedAt])
  
  @@map("example_a")
}
```

---

## 🎯 Module Implementation Pattern

### Standard Module Structure

```typescript
/src/modules/estimate/
├── estimate.types.ts           # TypeScript types
├── estimate.validation.ts      # Zod schemas
├── estimate.constants.ts       # Enums and constants
├── estimate.service.ts         # Business logic
├── estimate.router.ts          # tRPC router
├── estimate.mapper.ts          # DTO mappings
├── estimate.queries.ts         # Complex queries
├── estimate.utils.ts           # Helper functions
└── submodules/
    ├── revision/
    ├── section/
    ├── lineItem/
    └── publicLink/
```

### Example Service Implementation

```typescript
// estimate.service.ts
import { TRPCError } from '@trpc/server';
import { prisma } from '@/lib/prisma';
import type { CreateEstimateInput, EstimateWithDetails } from './estimate.types';

export class EstimateService {
  /**
   * Create new estimate with full traceability
   */
  async create(
    input: CreateEstimateInput,
    actorId: string,
    tenantId: string
  ): Promise<EstimateWithDetails> {
    // Generate globalId for 1:1:1 traceability
    const globalId = await this.generateGlobalId();
    
    // Generate estimate number via NumberSequence
    const estimateNumber = await this.generateEstimateNumber(tenantId);
    
    // Create estimate with transaction
    return await prisma.$transaction(async (tx) => {
      // Create parent estimate
      const estimate = await tx.estimate.create({
        data: {
          // Identity (BH Pattern)
          tenantId,
          globalId,
          
          // Business Identity
          estimateNumber,
          title: input.title,
          description: input.description,
          
          // CRM Linkage
          crmAccountId: input.crmAccountId,
          crmContactId: input.crmContactId,
          
          // Ownership
          ownerMemberId: input.ownerMemberId || actorId,
          
          // Status
          status: 'DRAFT',
          approvalStatus: 'NOT_SUBMITTED',
          clientStatus: 'NOT_SENT',
          
          // Financial
          currencyCode: input.currencyCode || 'USD',
          
          // Actor Attribution (Pattern B)
          createdByActorId: actorId,
          updatedByActorId: actorId,
          
          // Audit
          auditCorrelationId: crypto.randomUUID(),
        },
        include: {
          crmAccount: true,
          crmContact: true,
          ownerMember: true,
        },
      });
      
      // Create initial revision (snapshot)
      await tx.estimateRevision.create({
        data: {
          tenantId,
          estimateId: estimate.id,
          revisionNumber: 1,
          snapshotData: estimate,
          createdByActorId: actorId,
          updatedByActorId: actorId,
        },
      });
      
      // Create history event
      await tx.estimateHistoryEvent.create({
        data: {
          tenantId,
          estimateId: estimate.id,
          eventType: 'ESTIMATE_CREATED',
          eventData: { estimateNumber, globalId },
          createdByActorId: actorId,
          updatedByActorId: actorId,
        },
      });
      
      return estimate;
    });
  }
  
  /**
   * Auto-generate Project and Invoice on approval
   */
  async convertToProjectAndInvoice(
    estimateId: string,
    tenantId: string,
    actorId: string,
    options: {
      createProject: boolean;
      createInvoice: boolean;
    }
  ): Promise<{
    project?: Project;
    invoice?: Invoice;
  }> {
    return await prisma.$transaction(async (tx) => {
      // Get estimate with all line items
      const estimate = await tx.estimate.findUnique({
        where: { tenantId_id: { tenantId, id: estimateId } },
        include: {
          sections: true,
          lineItems: {
            include: {
              attachments: true,
            },
          },
          taxes: true,
          discounts: true,
          fees: true,
        },
      });
      
      if (!estimate) {
        throw new TRPCError({
          code: 'NOT_FOUND',
          message: 'Estimate not found',
        });
      }
      
      if (estimate.status !== 'APPROVED') {
        throw new TRPCError({
          code: 'PRECONDITION_FAILED',
          message: 'Estimate must be approved before conversion',
        });
      }
      
      let project: Project | undefined;
      let invoice: Invoice | undefined;
      
      // Create Project (if requested)
      if (options.createProject) {
        project = await tx.project.create({
          data: {
            // CRITICAL: Use same globalId for 1:1:1 traceability
            tenantId,
            globalId: estimate.globalId,
            
            // CRITICAL: Use same number for document continuity
            projectNumber: estimate.estimateNumber,
            projectName: estimate.title,
            description: estimate.description,
            
            // Link to source
            sourceEstimateId: estimate.id,
            
            // CRM Linkage (inherit from estimate)
            // crmAccountId: estimate.crmAccountId, // [Future]
            // crmContactId: estimate.crmContactId, // [Future]
            
            // Status
            status: 'PLANNING',
            budgetStatus: 'ON_BUDGET',
            scheduleStatus: 'ON_SCHEDULE',
            
            // Financial (inherit from estimate)
            totalBudgetedCost: estimate.totalCostAmount,
            contractValue: estimate.totalAmount,
            
            // Actor Attribution
            createdByActorId: actorId,
            updatedByActorId: actorId,
          },
        });
        
        // Create ProjectPhases from EstimateSections
        for (const section of estimate.sections) {
          await tx.projectPhase.create({
            data: {
              tenantId,
              projectId: project.id,
              phaseName: section.sectionName,
              description: section.description,
              sortOrder: section.sortOrder,
              createdByActorId: actorId,
              updatedByActorId: actorId,
            },
          });
        }
        
        // Create ProjectTasks from EstimateLineItems
        for (const lineItem of estimate.lineItems) {
          const task = await tx.projectTask.create({
            data: {
              tenantId,
              projectId: project.id,
              taskName: lineItem.itemName,
              description: lineItem.itemDescription,
              quantity: lineItem.quantity,
              budgetedAmount: lineItem.lineTotal,
              // If lineItem has inventoryItemId, preserve it
              inventoryItemId: lineItem.inventoryItemId,
              createdByActorId: actorId,
              updatedByActorId: actorId,
            },
          });
          
          // Copy attachments to ProjectTaskAttachment
          for (const attachment of lineItem.attachments) {
            await tx.projectTaskAttachment.create({
              data: {
                tenantId,
                taskId: task.id,
                fileName: attachment.fileName,
                fileUrl: attachment.fileUrl,
                fileSize: attachment.fileSize,
                mimeType: attachment.mimeType,
                createdByActorId: actorId,
                updatedByActorId: actorId,
              },
            });
          }
        }
        
        // Update estimate flags
        await tx.estimate.update({
          where: { tenantId_id: { tenantId, id: estimateId } },
          data: {
            hasProject: true,
            convertedAt: new Date(),
            updatedByActorId: actorId,
          },
        });
      }
      
      // Create Invoice (if requested)
      if (options.createInvoice) {
        invoice = await tx.invoice.create({
          data: {
            // CRITICAL: Use same globalId for 1:1:1 traceability
            tenantId,
            globalId: estimate.globalId,
            
            // CRITICAL: Use same number
            invoiceNumber: estimate.estimateNumber,
            title: estimate.title,
            description: estimate.description,
            
            // Link to source
            sourceEstimateId: estimate.id,
            relatedProjectId: project?.id,
            
            // CRM Linkage (inherit)
            crmAccountId: estimate.crmAccountId,
            crmContactId: estimate.crmContactId,
            billToAddressId: estimate.billToAddressId,
            
            // Status
            status: 'DRAFT',
            paymentStatus: 'UNPAID',
            collectionStatus: 'CURRENT',
            
            // Financial (inherit)
            currencyCode: estimate.currencyCode,
            subtotalAmount: estimate.subtotalAmount,
            taxAmount: estimate.taxAmount,
            discountAmount: estimate.discountAmount,
            feeAmount: estimate.feeAmount,
            totalAmount: estimate.totalAmount,
            amountDue: estimate.totalAmount,
            
            // Dates
            invoiceDate: new Date(),
            dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
            
            // Actor Attribution
            createdByActorId: actorId,
            updatedByActorId: actorId,
          },
        });
        
        // Create InvoiceLineItems from EstimateLineItems
        for (const lineItem of estimate.lineItems) {
          await tx.invoiceLineItem.create({
            data: {
              tenantId,
              invoiceId: invoice.id,
              description: lineItem.itemName,
              detailedDescription: lineItem.itemDescription,
              quantity: lineItem.quantity,
              unitPrice: lineItem.unitPrice,
              lineTotal: lineItem.lineTotal,
              sourceEstimateLineItemId: lineItem.id,
              inventoryItemId: lineItem.inventoryItemId,
              sortOrder: lineItem.sortOrder,
              createdByActorId: actorId,
              updatedByActorId: actorId,
            },
          });
        }
        
        // Create InvoiceTax from EstimateTax
        for (const tax of estimate.taxes) {
          await tx.invoiceTax.create({
            data: {
              tenantId,
              invoiceId: invoice.id,
              taxName: tax.taxName,
              taxRate: tax.taxRate,
              taxAmount: tax.taxAmount,
              createdByActorId: actorId,
              updatedByActorId: actorId,
            },
          });
        }
        
        // Create InvoiceDiscount from EstimateDiscount
        for (const discount of estimate.discounts) {
          await tx.invoiceDiscount.create({
            data: {
              tenantId,
              invoiceId: invoice.id,
              discountName: discount.discountName,
              discountType: discount.discountType,
              discountValue: discount.discountValue,
              discountAmount: discount.discountAmount,
              createdByActorId: actorId,
              updatedByActorId: actorId,
            },
          });
        }
        
        // Create InvoiceFee from EstimateFee
        for (const fee of estimate.fees) {
          await tx.invoiceFee.create({
            data: {
              tenantId,
              invoiceId: invoice.id,
              feeName: fee.feeName,
              feeAmount: fee.feeAmount,
              createdByActorId: actorId,
              updatedByActorId: actorId,
            },
          });
        }
        
        // Update estimate flags
        await tx.estimate.update({
          where: { tenantId_id: { tenantId, id: estimateId } },
          data: {
            hasInvoice: true,
            status: 'CONVERTED',
            convertedAt: new Date(),
            updatedByActorId: actorId,
          },
        });
      }
      
      // Create history events
      if (project) {
        await tx.estimateHistoryEvent.create({
          data: {
            tenantId,
            estimateId: estimate.id,
            eventType: 'PROJECT_AUTO_CREATED',
            eventData: { projectId: project.id, projectNumber: project.projectNumber },
            createdByActorId: actorId,
            updatedByActorId: actorId,
          },
        });
      }
      
      if (invoice) {
        await tx.estimateHistoryEvent.create({
          data: {
            tenantId,
            estimateId: estimate.id,
            eventType: 'INVOICE_AUTO_CREATED',
            eventData: { invoiceId: invoice.id, invoiceNumber: invoice.invoiceNumber },
            createdByActorId: actorId,
            updatedByActorId: actorId,
          },
        });
      }
      
      return { project, invoice };
    });
  }
  
  // Helper methods
  private async generateGlobalId(): Promise<string> {
    // UUIDv7 is generated by Prisma with uuid(7) default
    // This is just a placeholder for any custom logic
    return crypto.randomUUID(); // Will be overridden by Prisma uuid(7)
  }
  
  private async generateEstimateNumber(tenantId: string): Promise<string> {
    // Call NumberSequence service to generate sequential number
    // Format: EST-2025-00123
    const sequence = await NumberSequenceService.getNext(
      tenantId,
      'ESTIMATE',
      'EST'
    );
    return sequence.formattedNumber;
  }
}
```

---

## 🔐 Actor Attribution Implementation

### Actor Context Middleware

```typescript
// middleware/actor-context.ts
import { TRPCError } from '@trpc/server';
import type { Context } from '@/server/context';

export async function actorContextMiddleware(opts: {
  ctx: Context;
  next: () => Promise<any>;
}) {
  const { ctx } = opts;
  
  // Ensure user is authenticated
  if (!ctx.session?.user?.id) {
    throw new TRPCError({
      code: 'UNAUTHORIZED',
      message: 'Authentication required',
    });
  }
  
  // Get Actor ID (User or ServiceAccount)
  const actorId = await getActorIdForUser(ctx.session.user.id);
  
  if (!actorId) {
    throw new TRPCError({
      code: 'INTERNAL_SERVER_ERROR',
      message: 'Actor not found for authenticated user',
    });
  }
  
  // Add to context
  return opts.next({
    ctx: {
      ...ctx,
      actorId,
      tenantId: ctx.session.tenantId,
    },
  });
}

async function getActorIdForUser(userId: string): Promise<string> {
  // Actor can be User or ServiceAccount
  const actor = await prisma.actor.findFirst({
    where: {
      OR: [
        { user: { id: userId } },
        { serviceAccount: { userId } },
      ],
    },
  });
  
  return actor?.id;
}
```

### Usage in Services

```typescript
// Always pass actorId to create/update operations
const estimate = await estimateService.create(
  input,
  ctx.actorId,  // From context
  ctx.tenantId   // From context
);

// Actor relations are automatically populated in Prisma
const estimate = await prisma.estimate.findUnique({
  where: { /* ... */ },
  include: {
    createdByActor: {
      include: {
        user: { select: { name: true, email: true } },
      },
    },
    updatedByActor: {
      include: {
        user: { select: { name: true, email: true } },
      },
    },
  },
});

// Output:
// estimate.createdByActor.user.name -> "John Doe"
// estimate.updatedByActor.user.email -> "john@example.com"
```

---

## 🔗 1:1:1 Traceability Implementation

### Global ID Strategy

```typescript
// utils/traceability.ts

/**
 * Verify 1:1:1 traceability across Estimate → Project → Invoice
 */
export async function verifyTraceability(
  globalId: string,
  tenantId: string
): Promise<{
  estimate: Estimate | null;
  project: Project | null;
  invoice: Invoice | null;
  isValid: boolean;
  documentNumber: string | null;
}> {
  const [estimate, project, invoice] = await Promise.all([
    prisma.estimate.findFirst({
      where: { tenantId, globalId },
      select: { id: true, estimateNumber: true, status: true },
    }),
    prisma.project.findFirst({
      where: { tenantId, globalId },
      select: { id: true, projectNumber: true, status: true },
    }),
    prisma.invoice.findFirst({
      where: { tenantId, globalId },
      select: { id: true, invoiceNumber: true, status: true },
    }),
  ]);
  
  // Verify that document numbers match (if entities exist)
  const documentNumbers = new Set([
    estimate?.estimateNumber,
    project?.projectNumber,
    invoice?.invoiceNumber,
  ].filter(Boolean));
  
  const isValid = documentNumbers.size <= 1; // All numbers should be identical
  const documentNumber = documentNumbers.values().next().value || null;
  
  return {
    estimate,
    project,
    invoice,
    isValid,
    documentNumber,
  };
}

/**
 * Trace from any entity back to origin
 */
export async function traceToOrigin(
  entityType: 'estimate' | 'project' | 'invoice',
  entityId: string,
  tenantId: string
): Promise<TraceabilityChain> {
  let globalId: string;
  
  // Get globalId from the entity
  switch (entityType) {
    case 'estimate':
      const estimate = await prisma.estimate.findUnique({
        where: { tenantId_id: { tenantId, id: entityId } },
        select: { globalId: true },
      });
      globalId = estimate.globalId;
      break;
    case 'project':
      const project = await prisma.project.findUnique({
        where: { tenantId_id: { tenantId, id: entityId } },
        select: { globalId: true },
      });
      globalId = project.globalId;
      break;
    case 'invoice':
      const invoice = await prisma.invoice.findUnique({
        where: { tenantId_id: { tenantId, id: entityId } },
        select: { globalId: true },
      });
      globalId = invoice.globalId;
      break;
  }
  
  // Get all related entities
  return verifyTraceability(globalId, tenantId);
}
```

---

## 🏢 Multi-Tenant Architecture

### Row-Level Security (RLS)

```sql
-- Enable RLS on all tenant-scoped tables
ALTER TABLE estimate ENABLE ROW LEVEL SECURITY;
ALTER TABLE project ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoice ENABLE ROW LEVEL SECURITY;

-- Create policy to enforce tenant isolation
CREATE POLICY tenant_isolation_policy ON estimate
  USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY tenant_isolation_policy ON project
  USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY tenant_isolation_policy ON invoice
  USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```

### Prisma Middleware for Tenant Isolation

```typescript
// middleware/tenant-middleware.ts
prisma.$use(async (params, next) => {
  const tenantId = getCurrentTenantId(); // From request context
  
  // Automatically inject tenantId for all queries
  if (params.action === 'findMany' || params.action === 'findFirst') {
    params.args.where = {
      ...params.args.where,
      tenantId,
    };
  }
  
  if (params.action === 'create') {
    params.args.data = {
      ...params.args.data,
      tenantId,
    };
  }
  
  // Set PostgreSQL session variable for RLS
  await prisma.$executeRaw`SET app.current_tenant_id = ${tenantId}`;
  
  return next(params);
});
```

---

## 🧪 Testing Strategy

### Unit Tests

```typescript
// __tests__/estimate.service.test.ts
import { EstimateService } from '@/modules/estimate/estimate.service';
import { prismaMock } from '@/test/prisma-mock';

describe('EstimateService', () => {
  const service = new EstimateService();
  const mockActorId = '01HZQTEST1234567890ABCDEFGH';
  const mockTenantId = '01HZQTEST1234567890TENANT1';
  
  describe('create', () => {
    it('should create estimate with proper globalId', async () => {
      const input = {
        title: 'Test Estimate',
        crmAccountId: '01HZQTEST1234567890ACCOUNT1',
        ownerMemberId: mockActorId,
      };
      
      prismaMock.estimate.create.mockResolvedValue({
        id: '01HZQTEST1234567890ESTIM01',
        globalId: '01HZQTEST1234567890GLOBAL1',
        estimateNumber: 'EST-2025-001',
        // ... other fields
      });
      
      const result = await service.create(input, mockActorId, mockTenantId);
      
      expect(result.globalId).toBeDefined();
      expect(result.estimateNumber).toMatch(/^EST-\d{4}-\d{5}$/);
      expect(result.createdByActorId).toBe(mockActorId);
    });
  });
  
  describe('convertToProjectAndInvoice', () => {
    it('should maintain globalId across all entities', async () => {
      const estimateId = '01HZQTEST1234567890ESTIM01';
      const globalId = '01HZQTEST1234567890GLOBAL1';
      
      // Mock estimate with approved status
      prismaMock.estimate.findUnique.mockResolvedValue({
        id: estimateId,
        globalId,
        estimateNumber: 'EST-2025-001',
        status: 'APPROVED',
        // ... other fields
      });
      
      const result = await service.convertToProjectAndInvoice(
        estimateId,
        mockTenantId,
        mockActorId,
        { createProject: true, createInvoice: true }
      );
      
      expect(result.project.globalId).toBe(globalId);
      expect(result.invoice.globalId).toBe(globalId);
      expect(result.project.projectNumber).toBe('EST-2025-001');
      expect(result.invoice.invoiceNumber).toBe('EST-2025-001');
    });
  });
});
```

### Integration Tests

```typescript
// __tests__/integration/estimate-to-invoice-flow.test.ts
describe('Estimate → Project → Invoice Flow', () => {
  it('should maintain complete traceability', async () => {
    // 1. Create estimate
    const estimate = await createTestEstimate({
      title: 'Kitchen Remodel',
      lineItems: [
        { itemName: 'Cabinets', quantity: 12, unitPrice: 500 },
        { itemName: 'Countertops', quantity: 1, unitPrice: 3500 },
      ],
    });
    
    expect(estimate.globalId).toBeDefined();
    expect(estimate.estimateNumber).toBeDefined();
    
    // 2. Approve estimate
    await approveEstimate(estimate.id);
    
    // 3. Convert to project and invoice
    const { project, invoice } = await convertEstimate(estimate.id);
    
    // 4. Verify traceability
    expect(project.globalId).toBe(estimate.globalId);
    expect(invoice.globalId).toBe(estimate.globalId);
    expect(project.projectNumber).toBe(estimate.estimateNumber);
    expect(invoice.invoiceNumber).toBe(estimate.estimateNumber);
    
    // 5. Verify data inheritance
    expect(project.sourceEstimateId).toBe(estimate.id);
    expect(invoice.sourceEstimateId).toBe(estimate.id);
    expect(invoice.relatedProjectId).toBe(project.id);
    
    // 6. Verify line items copied
    const projectTasks = await getProjectTasks(project.id);
    const invoiceLineItems = await getInvoiceLineItems(invoice.id);
    
    expect(projectTasks).toHaveLength(2);
    expect(invoiceLineItems).toHaveLength(2);
    
    // 7. Verify financial totals match
    expect(invoice.totalAmount).toBe(estimate.totalAmount);
  });
});
```

---

## 🚀 Deployment Architecture

### Production Infrastructure

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  api:
    image: erp-api:latest
    replicas: 3
    environment:
      DATABASE_URL: ${DATABASE_URL}
      REDIS_URL: ${REDIS_URL}
      NODE_ENV: production
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      
  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
      
volumes:
  redis-data:
```

### Environment Variables

```env
# .env.production
DATABASE_URL="postgresql://user:pass@neon.tech:5432/erp_prod?schema=public"
REDIS_URL="redis://redis:6379"
NODE_ENV="production"

# JWT
JWT_SECRET="your-super-secret-key-here"
JWT_EXPIRES_IN="7d"

# File Storage (S3-compatible)
S3_ENDPOINT="https://s3.amazonaws.com"
S3_BUCKET="erp-files-prod"
S3_ACCESS_KEY="your-access-key"
S3_SECRET_KEY="your-secret-key"

# Email
SMTP_HOST="smtp.sendgrid.net"
SMTP_PORT=587
SMTP_USER="apikey"
SMTP_PASS="your-sendgrid-api-key"

# Stripe (for payments)
STRIPE_SECRET_KEY="sk_live_..."
STRIPE_WEBHOOK_SECRET="whsec_..."
```

---

## 📊 Performance Optimization

### Query Optimization

```typescript
// Use select to limit fields
const estimates = await prisma.estimate.findMany({
  select: {
    id: true,
    estimateNumber: true,
    title: true,
    totalAmount: true,
    status: true,
  },
  where: { tenantId, deletedAt: null },
  take: 50,
});

// Use cursor pagination for large datasets
const estimates = await prisma.estimate.findMany({
  where: { tenantId },
  take: 50,
  skip: 1, // Skip the cursor
  cursor: { id: lastEstimateId },
  orderBy: { createdAt: 'desc' },
});

// Use indexes effectively
// Query on indexed field: [tenantId, status]
const activeEstimates = await prisma.estimate.findMany({
  where: {
    tenantId,
    status: { in: ['DRAFT', 'PENDING_INTERNAL_APPROVAL'] },
  },
});
```

### Caching Strategy

```typescript
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

// Cache frequently accessed data
async function getEstimate(id: string, tenantId: string) {
  const cacheKey = `estimate:${tenantId}:${id}`;
  
  // Check cache first
  const cached = await redis.get(cacheKey);
  if (cached) {
    return JSON.parse(cached);
  }
  
  // Query database
  const estimate = await prisma.estimate.findUnique({
    where: { tenantId_id: { tenantId, id } },
  });
  
  // Cache for 5 minutes
  await redis.setex(cacheKey, 300, JSON.stringify(estimate));
  
  return estimate;
}

// Invalidate cache on update
async function updateEstimate(id: string, tenantId: string, data: any) {
  const estimate = await prisma.estimate.update({
    where: { tenantId_id: { tenantId, id } },
    data,
  });
  
  // Invalidate cache
  await redis.del(`estimate:${tenantId}:${id}`);
  
  return estimate;
}
```

---

## 🔒 Security Best Practices

### Input Validation

```typescript
import { z } from 'zod';

// Define strict schemas
export const CreateEstimateSchema = z.object({
  title: z.string().min(1).max(500),
  description: z.string().max(5000).optional(),
  crmAccountId: z.string().uuid(),
  crmContactId: z.string().uuid().optional(),
  currencyCode: z.string().length(3).default('USD'),
  lineItems: z.array(z.object({
    itemName: z.string().min(1).max(255),
    quantity: z.number().positive(),
    unitPrice: z.number().positive(),
  })).min(1),
});

// Use in router
export const estimateRouter = t.router({
  create: t.procedure
    .input(CreateEstimateSchema)
    .mutation(async ({ input, ctx }) => {
      // Input is type-safe and validated
      return estimateService.create(input, ctx.actorId, ctx.tenantId);
    }),
});
```

### SQL Injection Prevention

```typescript
// NEVER do this (vulnerable to SQL injection)
const result = await prisma.$queryRaw`
  SELECT * FROM estimate WHERE tenant_id = ${tenantId} AND title = ${userInput}
`;

// ALWAYS use parameterized queries
const result = await prisma.$queryRaw`
  SELECT * FROM estimate 
  WHERE tenant_id = ${tenantId} 
    AND title = ${userInput}
`; // Prisma automatically parameterizes

// Or better yet, use Prisma Client (preferred)
const result = await prisma.estimate.findMany({
  where: {
    tenantId,
    title: userInput, // Automatically safe
  },
});
```

---

**Document Version**: 1.0  
**Last Updated**: November 17, 2025  
**Next Review**: March 2026
