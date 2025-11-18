# 🔄 AI Module Suite - Operational Flow Documentation

**Version:** 1.0  
**Last Updated:** November 17, 2025  
**Modules**: aicore.prisma, aidocument.prisma, aiinsights.prisma  
**Integration Scope**: Platform-wide AI intelligence across all business modules  
**Security Pattern**: RLS-enforced, permission-gated, fully audited

---

## 📋 TABLE OF CONTENTS

1. [Core Flow: AI Agent Navigation & Command Execution](#1-core-flow-ai-agent-navigation--command-execution)
2. [Flow: Estimate Pricing Intelligence](#2-flow-estimate-pricing-intelligence)
3. [Flow: Invoice Financial Analysis](#3-flow-invoice-financial-analysis)
4. [Flow: Project Schedule Intelligence](#4-flow-project-schedule-intelligence)
5. [Flow: Document OCR & Intelligent Extraction](#5-flow-document-ocr--intelligent-extraction)
6. [Flow: Expense Receipt Auto-Processing](#6-flow-expense-receipt-auto-processing)
7. [Flow: AIPlaybook Multi-Step Workflow Execution](#7-flow-aiplaybook-multi-step-workflow-execution)
8. [Flow: Proactive Insight Generation (Background Jobs)](#8-flow-proactive-insight-generation-background-jobs)
9. [Flow: Semantic Search & RAG (Retrieval Augmented Generation)](#9-flow-semantic-search--rag-retrieval-augmented-generation)
10. [Flow: What-If Scenario Analysis](#10-flow-what-if-scenario-analysis)
11. [Security & Permission Enforcement](#11-security--permission-enforcement)
12. [Audit Trail & Actor Attribution](#12-audit-trail--actor-attribution)
13. [Error Handling & Retry Logic](#13-error-handling--retry-logic)
14. [Cost Tracking & Rate Limiting](#14-cost-tracking--rate-limiting)

---

## 1. CORE FLOW: AI Agent Navigation & Command Execution

### Overview
The AI Agent enables natural language interaction with the ERP platform. Users issue commands like "Create an estimate for Project #34" or "Send Invoice #21 to the client", and the AI translates these into secure, permission-gated business operations.

### Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: USER ISSUES NATURAL LANGUAGE COMMAND              │
└─────────────────────────────────────────────────────────────────────────────┘

User Types: "Create an estimate for Project #34 and send it to the client"
     │
     ▼
Frontend Chat Interface
     │
     ├─── Captures: userInput, sessionId, actorId
     ├─── Generates: requestId (UUID v7)
     └─── Sends to: POST /api/ai/agent/execute
     
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: BACKEND RECEIVES & VALIDATES                      │
└─────────────────────────────────────────────────────────────────────────────┘

Backend API Handler:
  1. Extract context from request
     ├─── ctx.actorId (from auth token)
     ├─── ctx.memberId (from session)
     ├─── ctx.tenantId (from actor/member)
     └─── ctx.sessionId
  
  2. Permission Check
     └─── requirePermission(ctx, "ai:agent:use")
          ├─── Checks: Member has Role with "ai:agent:use" permission
          ├─── Enforces: Tenant subscription includes AI features
          └─── FAILS → 403 Forbidden (cannot proceed)
  
  3. Extract request parameters
     ├─── userInput: string
     ├─── conversationHistory?: Message[] (for context)
     └─── targetModule?: string (optional hint: ESTIMATE, INVOICE, etc.)

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: INTENT CLASSIFICATION (AI CALL #1)                │
└─────────────────────────────────────────────────────────────────────────────┘

Intent Classifier:
  1. Load default AI model
     └─── Query: AIModel WHERE tenantId IN (ctx.tenantId, NULL) 
                         AND isDefault = true 
                         AND isActive = true
          ├─── Priority: Tenant-specific model first, then global
          └─── Example: "gpt-4-turbo" (global model)
  
  2. Load prompt template
     └─── Query: AIPromptTemplate WHERE templateCode = "intent_classification"
          └─── systemPrompt: "You are an intent classifier for a construction ERP..."
          └─── userPromptTemplate: "Classify this user request: {{userInput}}"
  
  3. Build LLM request
     {
       "model": "gpt-4-turbo",
       "messages": [
         {
           "role": "system",
           "content": "You are an intent classifier. Analyze user input and 
                       return JSON with: targetModule, operation, parameters"
         },
         {
           "role": "user",
           "content": "Create an estimate for Project #34 and send it to client"
         }
       ],
       "response_format": { "type": "json_object" },
       "temperature": 0.1
     }
  
  4. Call external LLM API
     POST https://api.openai.com/v1/chat/completions
     Headers:
       ├─── Authorization: Bearer {encrypted_api_key}
       └─── Content-Type: application/json
  
  5. Parse LLM response
     {
       "targetModule": "ESTIMATE",
       "operation": "create_and_send",
       "parameters": {
         "projectId": "34",
         "sendToClient": true
       },
       "confidence": 0.95
     }
  
  6. Log AI call (async, non-blocking)
     └─── Create AIActionRun record (for audit)
          ├─── aiActionId: null (no specific action yet)
          ├─── aiModelId: {model used}
          ├─── inputPrompt: {user input}
          ├─── outputStructured: {parsed intent}
          ├─── executionStatus: SUCCESS
          ├─── inputTokenCount, outputTokenCount, costAmount
          └─── actorId, memberId, tenantId, requestId

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: RESOLVE AIACTION FROM INTENT                      │
└─────────────────────────────────────────────────────────────────────────────┘

Action Resolver:
  1. Query for matching AIAction
     └─── Query: AIAction WHERE tenantId = ctx.tenantId
                          AND targetModule = "ESTIMATE"
                          AND actionCode = "estimate.create_and_send"
                          AND isActive = true
     
  2. Validate AIAction found
     └─── If NOT FOUND → Query for generic action or return error
     
  3. Load AIAction configuration
     ├─── aiActionId
     ├─── actionName: "Create and Send Estimate"
     ├─── requiredPermission: "estimate:create"
     ├─── requiredParams: ["projectId"]
     ├─── aiModelId: (which AI model to use)
     ├─── promptTemplateId: (which prompt template)
     └─── useFunctionCalling: true

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 5: PERMISSION CHECK FOR BUSINESS OPERATION           │
└─────────────────────────────────────────────────────────────────────────────┘

Permission Enforcement (CRITICAL):
  1. Check business permission
     └─── requirePermission(ctx, aiAction.requiredPermission)
          ├─── In this case: "estimate:create"
          ├─── Validates: Actor has Role → RolePermission → Permission
          └─── FAILS → 403 Forbidden
               └─── Response: "You don't have permission to create estimates"
  
  2. Validate required parameters
     └─── requiredParams: ["projectId"]
          ├─── Parsed: projectId = "34"
          └─── Validation: projectId is valid UUID or number
  
  3. Load related entities (with RLS)
     └─── Query: Project WHERE id = "34" (RLS automatically enforces tenantId)
          ├─── SUCCESS → Project found, belongs to tenant
          └─── NOT FOUND → "Project #34 not found or access denied"

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 6: EXECUTE BUSINESS OPERATION (with RLS)             │
└─────────────────────────────────────────────────────────────────────────────┘

Business Operation Execution:
  
  // Wrap entire operation in RLS context
  await withRLS(ctx, async (db) => {
    
    // STEP 6A: Load Project (RLS enforced)
    const project = await db.project.findUnique({
      where: { id: projectId },
      include: { 
        client: true,
        projectBudgetLineItems: true 
      }
    });
    // RLS ensures: tenantId matches ctx.tenantId
    
    if (!project) {
      throw new Error("Project not found");
    }
    
    // STEP 6B: Create Estimate (Pattern BH)
    const estimate = await db.estimate.create({
      data: {
        // Identity
        id: uuidv7(),
        tenantId: ctx.tenantId,
        globalId: uuidv7(), // Hybrid pattern
        
        // Actor Attribution
        createdByActorId: ctx.actorId,
        updatedByActorId: ctx.actorId,
        
        // Business Data
        estimateNumber: await generateEstimateNumber(db, ctx.tenantId),
        projectId: project.id,
        accountId: project.clientAccountId,
        contactId: project.primaryContactId,
        status: "DRAFT",
        estimateDate: new Date(),
        validUntil: addDays(new Date(), 30),
        
        // Description from AI
        description: `Estimate for ${project.projectName}`,
        
        // Initial financial values
        subtotal: 0,
        taxTotal: 0,
        total: 0,
        
        // Metadata
        metadata: {
          createdBy: "AI_AGENT",
          aiRequestId: requestId
        }
      }
    });
    
    // STEP 6C: Copy budget line items to estimate line items
    const lineItemsToCreate = project.projectBudgetLineItems.map((budgetItem, index) => ({
      id: uuidv7(),
      tenantId: ctx.tenantId,
      estimateId: estimate.id,
      createdByActorId: ctx.actorId,
      updatedByActorId: ctx.actorId,
      
      lineNumber: index + 1,
      description: budgetItem.description,
      quantity: budgetItem.quantity,
      unitOfMeasure: budgetItem.unit,
      unitPrice: budgetItem.estimatedCost,
      subtotal: budgetItem.quantity * budgetItem.estimatedCost,
      taxable: true,
      
      metadata: {
        copiedFromBudgetLineId: budgetItem.id
      }
    }));
    
    await db.estimateLineItem.createMany({
      data: lineItemsToCreate
    });
    
    // STEP 6D: Calculate totals
    const lineSubtotal = lineItemsToCreate.reduce((sum, item) => sum + item.subtotal, 0);
    const taxRate = 0.0825; // Could be loaded from TenantSettings
    const taxAmount = lineSubtotal * taxRate;
    const totalAmount = lineSubtotal + taxAmount;
    
    await db.estimate.update({
      where: { id: estimate.id },
      data: {
        subtotal: lineSubtotal,
        taxTotal: taxAmount,
        total: totalAmount,
        updatedByActorId: ctx.actorId
      }
    });
    
    // STEP 6E: If user requested "send to client"
    if (parsedIntent.parameters.sendToClient) {
      
      // Generate public link (no-login access)
      const publicLink = await db.estimatePublicLink.create({
        data: {
          id: uuidv7(),
          tenantId: ctx.tenantId,
          estimateId: estimate.id,
          createdByActorId: ctx.actorId,
          
          linkToken: generateSecureToken(32),
          expiresAt: addDays(new Date(), 30),
          isActive: true,
          viewCount: 0,
          
          allowedActions: ["VIEW", "COMMENT"],
          metadata: {
            createdBy: "AI_AGENT"
          }
        }
      });
      
      // Create email notification
      await db.notification.create({
        data: {
          id: uuidv7(),
          tenantId: ctx.tenantId,
          createdByActorId: ctx.actorId,
          
          notificationType: "ESTIMATE_SENT",
          recipientType: "EXTERNAL",
          recipientEmail: project.client.primaryEmail,
          
          subject: `Estimate ${estimate.estimateNumber} from ${ctx.tenant.displayName}`,
          message: `Please review the attached estimate.`,
          
          metadata: {
            estimateId: estimate.id,
            publicLinkUrl: `https://app.example.com/public/estimate/${publicLink.linkToken}`
          },
          
          status: "PENDING"
        }
      });
      
      // Update estimate status
      await db.estimate.update({
        where: { id: estimate.id },
        data: {
          status: "SENT",
          sentAt: new Date(),
          sentByActorId: ctx.actorId,
          updatedByActorId: ctx.actorId
        }
      });
    }
    
    // STEP 6F: Create EstimateHistoryEvent (audit trail)
    await db.estimateHistoryEvent.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        estimateId: estimate.id,
        actorId: ctx.actorId,
        
        eventType: "CREATED",
        eventDescription: "Estimate created by AI Agent",
        
        changesSummary: {
          createdBy: "AI_AGENT",
          projectId: project.id,
          lineItemCount: lineItemsToCreate.length,
          total: totalAmount
        },
        
        eventTimestamp: new Date()
      }
    });
    
    return { estimate, publicLink };
  });
  // End of RLS-wrapped transaction

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 7: AI GENERATES RESPONSE FOR USER                    │
└─────────────────────────────────────────────────────────────────────────────┘

Response Generation (AI CALL #2):
  1. Build context for AI
     {
       "businessOperation": "COMPLETED",
       "estimateId": "{uuid}",
       "estimateNumber": "EST-2025-0042",
       "projectName": "Kitchen Remodel",
       "clientName": "John Smith",
       "totalAmount": 12500.00,
       "lineItemCount": 15,
       "status": "SENT",
       "publicLinkGenerated": true
     }
  
  2. Load response template
     └─── AIPromptTemplate: "agent_response_generator"
          └─── systemPrompt: "Generate a friendly, professional response..."
  
  3. Call LLM
     POST https://api.openai.com/v1/chat/completions
     {
       "model": "gpt-4-turbo",
       "messages": [
         {
           "role": "system",
           "content": "Generate friendly response confirming completion..."
         },
         {
           "role": "user",
           "content": "Operation completed: {{context}}"
         }
       ],
       "temperature": 0.7
     }
  
  4. LLM Response
     "I've created Estimate #EST-2025-0042 for the Kitchen Remodel project 
      with 15 line items totaling $12,500.00. The estimate has been sent to 
      John Smith via email with a secure viewing link. The client can view 
      and comment on the estimate without logging in. Is there anything else 
      you'd like me to do with this estimate?"

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 8: LOG COMPLETE AI ACTION RUN                        │
└─────────────────────────────────────────────────────────────────────────────┘

Comprehensive Audit Log:
  await db.aiActionRun.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      
      // Execution Context
      aiActionId: aiAction.id,
      actorId: ctx.actorId,
      memberId: ctx.memberId,
      sessionId: ctx.sessionId,
      requestId: requestId,
      correlationId: correlationId,
      
      // Input
      inputPrompt: "Create an estimate for Project #34 and send to client",
      inputParameters: {
        projectId: "34",
        sendToClient: true
      },
      parsedIntent: {
        targetModule: "ESTIMATE",
        operation: "create_and_send",
        confidence: 0.95
      },
      inputTokenCount: 45,
      
      // AI Processing
      aiModelId: aiModel.id,
      modelVersion: "gpt-4-turbo-2024-11-01",
      promptTemplateId: promptTemplate.id,
      systemPrompt: "{full system prompt}",
      temperature: 0.7,
      
      // Output
      outputText: "{AI response text}",
      outputStructured: {
        estimateId: estimate.id,
        estimateNumber: estimate.estimateNumber,
        totalAmount: estimate.total
      },
      outputTokenCount: 120,
      confidence: 0.98,
      
      // Execution Results
      executionStatus: "SUCCESS",
      businessOperationStatus: "EXECUTED",
      targetResourceType: "Estimate",
      targetResourceId: estimate.id,
      resultMessage: "Estimate created and sent successfully",
      
      // Timing
      startedAt: executionStartTime,
      completedAt: new Date(),
      durationMs: Date.now() - executionStartTime,
      aiLatencyMs: llmCallDuration,
      businessLogicLatencyMs: businessOperationDuration,
      
      // Cost
      inputTokensCharged: 45,
      outputTokensCharged: 120,
      costAmount: (45 * 0.00003) + (120 * 0.00006), // $0.00855
      costCurrency: "USD",
      
      // Metadata
      metadata: {
        projectId: project.id,
        clientAccountId: project.clientAccountId,
        publicLinkGenerated: true
      }
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 9: RETURN RESPONSE TO USER                           │
└─────────────────────────────────────────────────────────────────────────────┘

API Response:
  {
    "success": true,
    "message": "I've created Estimate #EST-2025-0042...",
    "data": {
      "estimateId": "{uuid}",
      "estimateNumber": "EST-2025-0042",
      "status": "SENT",
      "total": 12500.00,
      "viewUrl": "/estimates/{uuid}"
    },
    "aiMetadata": {
      "requestId": "{uuid}",
      "tokensUsed": 165,
      "cost": 0.00855,
      "executionTimeMs": 2450
    }
  }

Frontend Display:
  ├─── Shows AI response in chat
  ├─── Displays created estimate card with link
  ├─── Shows "Sent to client" badge
  └─── Offers quick actions: "View Estimate", "Edit", "Create Another"
```

### Security Checkpoints

```
SECURITY ENFORCEMENT POINTS:

1. API Gateway
   └─── Authentication: Bearer token validation
   └─── Rate limiting: 100 requests/hour per user

2. Permission Check #1
   └─── requirePermission(ctx, "ai:agent:use")
   └─── Validates: User can use AI features

3. Permission Check #2
   └─── requirePermission(ctx, "estimate:create")
   └─── Validates: User can create estimates

4. RLS Enforcement (automatic)
   └─── All database queries filtered by tenantId
   └─── Project query: WHERE tenantId = ctx.tenantId
   └─── Estimate creation: tenantId = ctx.tenantId

5. Actor Attribution (automatic)
   └─── createdByActorId: ctx.actorId
   └─── Every entity tracks who created it

6. Audit Logging (automatic)
   └─── AIActionRun: Complete execution trace
   └─── EstimateHistoryEvent: Business-level audit
   └─── AccessAuditEvent: Security audit (if configured)
```

---

## 2. FLOW: Estimate Pricing Intelligence

### Overview
AI-powered pricing intelligence analyzes estimate line items and provides market-based pricing recommendations by querying external pricing databases and analyzing historical estimates.

### Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TRIGGER: User Creating/Editing Estimate                   │
└─────────────────────────────────────────────────────────────────────────────┘

User Action: Adds line item "Drywall installation - 1000 sq ft"
     │
     ▼
Frontend: Detects line item addition
     │
     ├─── Option A: Auto-trigger (if enabled in settings)
     └─── Option B: User clicks "Get AI Pricing Suggestions"
     
     ▼
POST /api/ai/estimate/pricing-intelligence
     {
       "estimateId": "{uuid}",
       "lineItemIds": ["{uuid1}", "{uuid2}"], // Or all line items
       "location": {
         "city": "Dallas",
         "state": "TX",
         "zipCode": "75201"
       }
     }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: LOAD ESTIMATE CONTEXT                             │
└─────────────────────────────────────────────────────────────────────────────┘

Backend Handler:
  1. Permission check
     └─── requirePermission(ctx, "estimate:read")
  
  2. Load estimate with RLS
     await withRLS(ctx, async (db) => {
       const estimate = await db.estimate.findUnique({
         where: { id: estimateId },
         include: {
           estimateLineItems: {
             where: lineItemIds.length > 0 
               ? { id: { in: lineItemIds } } 
               : undefined,
             orderBy: { lineNumber: 'asc' }
           },
           project: {
             include: {
               projectLocation: true
             }
           },
           account: true
         }
       });
       
       return estimate;
     });
  
  3. Validate estimate found
     └─── If NOT FOUND → 404 Error

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: QUERY AIACTION FOR PRICING                        │
└─────────────────────────────────────────────────────────────────────────────┘

Action Resolver:
  const aiAction = await db.aiAction.findFirst({
    where: {
      tenantId: ctx.tenantId,
      actionCode: "estimate.pricing_intelligence",
      isActive: true
    },
    include: {
      aiModel: true,
      promptTemplate: true
    }
  });
  
  Permission check:
    └─── requirePermission(ctx, aiAction.requiredPermission)
         └─── e.g., "estimate:ai_pricing"

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: PREPARE LINE ITEMS FOR AI ANALYSIS                │
└─────────────────────────────────────────────────────────────────────────────┘

Data Preparation:
  const lineItemsForAnalysis = estimate.estimateLineItems.map(item => ({
    lineNumber: item.lineNumber,
    description: item.description,
    quantity: item.quantity,
    unitOfMeasure: item.unitOfMeasure,
    currentUnitPrice: item.unitPrice,
    currentSubtotal: item.subtotal,
    category: item.category, // E.g., "DRYWALL", "PAINT", "LABOR"
  }));
  
  const context = {
    location: {
      city: estimate.project.projectLocation.city,
      state: estimate.project.projectLocation.state,
      zipCode: estimate.project.projectLocation.zipCode
    },
    projectType: estimate.project.projectType,
    projectSize: estimate.project.squareFootage,
    estimateDate: estimate.estimateDate,
    lineItems: lineItemsForAnalysis
  };

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: AI ANALYZES LINE ITEMS (AI CALL #1)               │
└─────────────────────────────────────────────────────────────────────────────┘

AI Analysis Phase 1: Extract Material/Labor Categories
  
  LLM Request:
    {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "system",
          "content": "You are a construction cost analyst. Analyze estimate 
                      line items and extract standardized material/labor categories."
        },
        {
          "role": "user",
          "content": `Analyze these line items and return structured JSON:
          
          ${JSON.stringify(lineItemsForAnalysis, null, 2)}
          
          For each line item, return:
          {
            "lineNumber": number,
            "materialCategory": string, // Standardized category
            "laborCategory": string,    // Standardized category
            "unit": string,              // Standardized unit
            "searchTerms": [string]      // Keywords for pricing lookup
          }`
        }
      ],
      "response_format": { "type": "json_object" },
      "temperature": 0.2
    }
  
  LLM Response:
    {
      "analysis": [
        {
          "lineNumber": 1,
          "materialCategory": "DRYWALL_STANDARD_1_2_INCH",
          "laborCategory": "DRYWALL_INSTALLATION_INTERIOR",
          "unit": "SQFT",
          "searchTerms": ["drywall", "sheetrock", "gypsum board", "1/2 inch"]
        },
        {
          "lineNumber": 2,
          "materialCategory": "PAINT_INTERIOR_PREMIUM",
          "laborCategory": "PAINTING_INTERIOR_WALLS",
          "unit": "SQFT",
          "searchTerms": ["interior paint", "premium", "latex", "wall paint"]
        }
      ]
    }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 5: EXTERNAL PRICING LOOKUP                           │
└─────────────────────────────────────────────────────────────────────────────┘

Pricing Data Sources (Multi-Strategy):
  
  STRATEGY A: External API (RSMeans, HomeAdvisor, etc.)
    For each analyzed line item:
      1. Call external pricing API
         POST https://api.rsmeans.com/v1/pricing/lookup
         {
           "category": "DRYWALL_STANDARD_1_2_INCH",
           "location": {
             "city": "Dallas",
             "state": "TX",
             "zipCode": "75201"
           },
           "unit": "SQFT",
           "date": "2025-11-17"
         }
      
      2. Parse response
         {
           "materialCost": {
             "low": 0.45,
             "average": 0.58,
             "high": 0.72,
             "unit": "SQFT"
           },
           "laborCost": {
             "low": 1.20,
             "average": 1.55,
             "high": 1.95,
             "unit": "SQFT"
           },
           "totalCost": {
             "low": 1.65,
             "average": 2.13,
             "high": 2.67,
             "unit": "SQFT"
           },
           "dataSource": "RSMeans 2025 Q4",
           "confidence": 0.92
         }
  
  STRATEGY B: Historical Estimate Analysis (Internal)
    Query similar past estimates:
      const similarEstimates = await db.estimateLineItem.findMany({
        where: {
          tenantId: ctx.tenantId,
          category: "DRYWALL",
          description: {
            contains: "drywall"
          },
          createdAt: {
            gte: subMonths(new Date(), 12) // Last 12 months
          }
        },
        select: {
          unitPrice: true,
          quantity: true,
          subtotal: true,
          estimate: {
            select: {
              status: true,
              project: {
                select: {
                  projectLocation: true
                }
              }
            }
          }
        }
      });
      
    Calculate statistics:
      {
        "internalPricing": {
          "count": 24,
          "averageUnitPrice": 2.05,
          "minUnitPrice": 1.45,
          "maxUnitPrice": 2.85,
          "medianUnitPrice": 2.10,
          "standardDeviation": 0.35
        }
      }
  
  STRATEGY C: AI Web Search (Fallback)
    If APIs unavailable, use web search:
      1. Search: "drywall installation cost per sqft Dallas TX 2025"
      2. AI extracts pricing from search results
      3. Lower confidence score (0.6-0.7)

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 6: AI GENERATES PRICING RECOMMENDATIONS (AI CALL #2) │
└─────────────────────────────────────────────────────────────────────────────┘

AI Synthesis:
  LLM Request:
    {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "system",
          "content": "You are a construction pricing advisor. Compare current 
                      estimate pricing against market data and provide recommendations."
        },
        {
          "role": "user",
          "content": `Generate pricing recommendations:
          
          Current Estimate Line Items:
          ${JSON.stringify(lineItemsForAnalysis, null, 2)}
          
          Market Data:
          ${JSON.stringify(externalPricingData, null, 2)}
          
          Internal Historical Data:
          ${JSON.stringify(internalPricingStats, null, 2)}
          
          Provide:
          1. Comparison of current price vs market
          2. Specific recommendations (increase/decrease/keep)
          3. Confidence level for each recommendation
          4. Reasoning
          5. Risk assessment (profit risk if current price too low)`
        }
      ],
      "temperature": 0.3
    }
  
  LLM Response:
    {
      "recommendations": [
        {
          "lineNumber": 1,
          "description": "Drywall installation - 1000 sq ft",
          "currentUnitPrice": 1.80,
          "marketAverage": 2.13,
          "internalAverage": 2.05,
          "recommendation": "INCREASE",
          "suggestedUnitPrice": 2.10,
          "suggestedPriceRange": {
            "low": 1.95,
            "high": 2.25
          },
          "variance": -15.5, // % below market
          "confidence": 0.89,
          "reasoning": "Current pricing is 15.5% below market average. 
                        Internal historical data shows $2.05/sqft average. 
                        Recommend increasing to $2.10 to maintain 15% profit margin.",
          "profitRisk": "MEDIUM",
          "profitRiskDetails": "At current price, profit margin estimated at 8%. 
                                 Target margin is 15%."
        }
      ],
      "overallSummary": "3 of 12 line items priced below market average. 
                         Estimated profit loss: $1,250 if not adjusted.",
      "totalCurrentEstimate": 12500.00,
      "totalRecommendedEstimate": 14200.00,
      "potentialAdditionalRevenue": 1700.00
    }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 7: CREATE AIPREDICTION & AIINSIGHT RECORDS           │
└─────────────────────────────────────────────────────────────────────────────┘

Store AI Analysis:
  await withRLS(ctx, async (db) => {
    
    // Create AIInsight
    const insight = await db.aiInsight.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        insightType: "FINANCIAL",
        insightCategory: "PRICING_OPPORTUNITY",
        insightTitle: "Estimate Pricing Below Market Average",
        
        sourceType: "ESTIMATE",
        sourceId: estimate.id,
        relatedEntities: {
          projectId: estimate.projectId,
          accountId: estimate.accountId
        },
        
        aiModelId: aiAction.aiModelId,
        generatedAt: new Date(),
        confidenceScore: 0.89,
        
        insightText: "Analysis shows 3 of 12 line items priced below market. 
                      Recommended adjustments could increase revenue by $1,700 
                      while maintaining competitive pricing.",
        
        insightData: {
          recommendations: aiRecommendations.recommendations,
          overallSummary: aiRecommendations.overallSummary
        },
        
        keyMetrics: {
          totalCurrentEstimate: 12500.00,
          totalRecommendedEstimate: 14200.00,
          potentialAdditionalRevenue: 1700.00,
          lineItemsAnalyzed: 12,
          lineItemsBelowMarket: 3
        },
        
        severity: "MEDIUM",
        priority: 7,
        requiresAction: false,
        
        status: "NEW"
      }
    });
    
    // Create AIPrediction for each line item
    for (const rec of aiRecommendations.recommendations) {
      await db.aiPrediction.create({
        data: {
          id: uuidv7(),
          tenantId: ctx.tenantId,
          createdByActorId: ctx.actorId,
          
          aiInsightId: insight.id,
          
          predictionType: "COST",
          predictedValue: {
            lineNumber: rec.lineNumber,
            suggestedUnitPrice: rec.suggestedUnitPrice,
            suggestedPriceRange: rec.suggestedPriceRange
          },
          confidence: rec.confidence,
          
          baselineValue: {
            currentUnitPrice: rec.currentUnitPrice
          },
          trend: rec.recommendation === "INCREASE" ? "INCREASING" : "STABLE",
          variance: rec.variance,
          
          predictionHorizon: 0, // Current pricing, not future prediction
          
          metadata: {
            marketAverage: rec.marketAverage,
            internalAverage: rec.internalAverage,
            reasoning: rec.reasoning
          }
        }
      });
    }
    
    // Create AIRecommendation
    await db.aiRecommendation.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        aiInsightId: insight.id,
        
        recommendationText: "Review and adjust pricing for line items 1, 5, and 8 
                             to align with market averages and maintain target 
                             profit margins.",
        recommendationType: "ADJUST",
        priority: 7,
        estimatedImpact: "MEDIUM",
        estimatedEffort: "LOW",
        
        canAutoExecute: false, // Pricing decisions need human approval
        requiresApproval: true,
        
        status: "PENDING"
      }
    });
    
    return insight;
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 8: LOG AI ACTION RUN                                 │
└─────────────────────────────────────────────────────────────────────────────┘

Complete Audit Trail:
  await db.aiActionRun.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      aiActionId: aiAction.id,
      actorId: ctx.actorId,
      memberId: ctx.memberId,
      requestId: requestId,
      
      inputPrompt: "Analyze pricing for estimate line items",
      inputParameters: {
        estimateId: estimate.id,
        lineItemIds: lineItemIds,
        location: context.location
      },
      inputTokenCount: 450,
      
      aiModelId: aiAction.aiModelId,
      outputStructured: aiRecommendations,
      outputTokenCount: 890,
      
      executionStatus: "SUCCESS",
      businessOperationStatus: "EXECUTED",
      targetResourceType: "AIInsight",
      targetResourceId: insight.id,
      
      startedAt: startTime,
      completedAt: new Date(),
      durationMs: Date.now() - startTime,
      
      costAmount: calculateAICost(450, 890, aiModel),
      costCurrency: "USD"
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 9: RETURN RESULTS TO USER                            │
└─────────────────────────────────────────────────────────────────────────────┘

API Response:
  {
    "success": true,
    "insightId": "{uuid}",
    "recommendations": [
      {
        "lineNumber": 1,
        "description": "Drywall installation - 1000 sq ft",
        "currentPrice": "$1,800.00",
        "suggestedPrice": "$2,100.00",
        "variance": "-15.5%",
        "status": "BELOW_MARKET",
        "confidence": "HIGH",
        "reasoning": "Current pricing is 15.5% below market average..."
      }
    ],
    "summary": {
      "totalCurrentEstimate": "$12,500.00",
      "totalRecommendedEstimate": "$14,200.00",
      "potentialIncrease": "$1,700.00",
      "profitImpact": "+7% margin improvement"
    }
  }

Frontend Display:
  ┌──────────────────────────────────────────────────────┐
  │  💡 AI Pricing Insights                              │
  ├──────────────────────────────────────────────────────┤
  │  Your estimate is priced 13.6% below market average  │
  │                                                      │
  │  📊 Line Items Analysis:                             │
  │  ├─ ⚠️  Line 1: Drywall - $300 below market         │
  │  ├─ ⚠️  Line 5: Paint - $450 below market           │
  │  ├─ ⚠️  Line 8: Labor - $950 below market           │
  │  └─ ✅ 9 other items priced competitively            │
  │                                                      │
  │  💰 Potential Additional Revenue: $1,700             │
  │                                                      │
  │  [Apply All Suggestions] [Review Line by Line]       │
  └──────────────────────────────────────────────────────┘
```

---

## 3. FLOW: Invoice Financial Analysis

### Overview
AI analyzes invoice financial metrics to identify profit margin issues, cost overruns, and potential losses before invoice is sent to client.

### Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TRIGGER: Invoice Created or User Query                    │
└─────────────────────────────────────────────────────────────────────────────┘

Trigger Option A: Automatic Analysis (Background)
  └─── When: Invoice status changes to "DRAFT_COMPLETE"
  └─── Creates: AIJob for batch analysis

Trigger Option B: User Query
  User asks: "What is the profit margin of Invoice #42?"
  └─── Executes: Real-time AI analysis

Let's follow Option B (User Query):

User Types: "What is the profit margin of Invoice #42? Are there any warnings?"
     │
     ▼
POST /api/ai/agent/query
     {
       "query": "What is the profit margin of Invoice #42?",
       "context": {
         "module": "INVOICE"
       }
     }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: INTENT CLASSIFICATION                             │
└─────────────────────────────────────────────────────────────────────────────┘

AI Intent Classifier:
  LLM Response:
    {
      "intent": "FINANCIAL_ANALYSIS",
      "targetModule": "INVOICE",
      "operation": "profit_margin_analysis",
      "parameters": {
        "invoiceNumber": "42",
        "metricsRequested": ["profit_margin", "warnings", "risk_assessment"]
      }
    }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: RESOLVE INVOICE & LOAD FINANCIAL DATA             │
└─────────────────────────────────────────────────────────────────────────────┘

Backend Handler:
  await withRLS(ctx, async (db) => {
    
    // Find invoice by number
    const invoice = await db.invoice.findFirst({
      where: {
        tenantId: ctx.tenantId,
        invoiceNumber: { contains: "42" }
      },
      include: {
        invoiceLineItems: true,
        invoiceTaxes: true,
        invoiceFees: true,
        invoiceDiscounts: true,
        project: {
          include: {
            projectBudget: true,
            projectBudgetLineItems: true,
            
            // CRITICAL: Load actual costs
            projectTasks: {
              include: {
                workOrders: {
                  include: {
                    workOrderLabor: true,
                    workOrderMaterial: true
                  }
                }
              }
            },
            
            // Purchase orders for material costs
            purchaseOrders: {
              include: {
                purchaseOrderLineItems: true,
                purchaseOrderReceipts: true
              }
            },
            
            // Expense reports for project
            expenseReports: {
              include: {
                expenseLines: true
              }
            }
          }
        },
        estimate: {
          include: {
            estimateLineItems: true
          }
        }
      }
    });
    
    return invoice;
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: CALCULATE ACTUAL COSTS                            │
└─────────────────────────────────────────────────────────────────────────────┘

Cost Calculation Engine:
  
  // Labor Costs (from Work Orders)
  const laborCosts = invoice.project.projectTasks
    .flatMap(task => task.workOrders)
    .flatMap(wo => wo.workOrderLabor)
    .reduce((sum, labor) => {
      return sum + (labor.hoursWorked * labor.hourlyRate);
    }, 0);
  
  // Material Costs (from Purchase Orders)
  const materialCosts = invoice.project.purchaseOrders
    .flatMap(po => po.purchaseOrderLineItems)
    .filter(item => item.receiptStatus === "RECEIVED")
    .reduce((sum, item) => {
      return sum + (item.quantity * item.unitPrice);
    }, 0);
  
  // Other Expenses (from Expense Reports)
  const otherExpenses = invoice.project.expenseReports
    .flatMap(report => report.expenseLines)
    .filter(line => line.status === "APPROVED")
    .reduce((sum, line) => sum + line.amount, 0);
  
  // Subcontractor Costs (from Invoices received)
  const subcontractorCosts = await db.invoice.findMany({
    where: {
      tenantId: ctx.tenantId,
      projectId: invoice.projectId,
      invoiceType: "RECEIVED", // Vendor invoices
      status: { in: ["PAID", "PENDING"] }
    }
  }).then(invoices => 
    invoices.reduce((sum, inv) => sum + inv.total, 0)
  );
  
  // Total Actual Cost
  const totalActualCost = 
    laborCosts + 
    materialCosts + 
    otherExpenses + 
    subcontractorCosts;
  
  // Invoice Revenue
  const invoiceRevenue = invoice.total;
  
  // Calculate Metrics
  const profitAmount = invoiceRevenue - totalActualCost;
  const profitMargin = (profitAmount / invoiceRevenue) * 100;
  
  const financialMetrics = {
    invoiceRevenue: invoiceRevenue,
    totalActualCost: totalActualCost,
    profitAmount: profitAmount,
    profitMargin: profitMargin,
    
    costBreakdown: {
      laborCosts: laborCosts,
      materialCosts: materialCosts,
      otherExpenses: otherExpenses,
      subcontractorCosts: subcontractorCosts
    },
    
    // Compare to estimate
    originalEstimate: invoice.estimate?.total || null,
    estimateVariance: invoice.estimate 
      ? ((invoiceRevenue - invoice.estimate.total) / invoice.estimate.total) * 100
      : null,
    
    // Compare to budget
    projectBudget: invoice.project.projectBudget?.totalBudget || null,
    budgetVariance: invoice.project.projectBudget
      ? ((totalActualCost - invoice.project.projectBudget.totalBudget) / 
         invoice.project.projectBudget.totalBudget) * 100
      : null
  };

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: AI FINANCIAL ANALYSIS                             │
└─────────────────────────────────────────────────────────────────────────────┘

AI Analysis:
  LLM Request:
    {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "system",
          "content": "You are a construction financial analyst. Analyze invoice 
                      financial metrics and identify risks, warnings, and recommendations."
        },
        {
          "role": "user",
          "content": `Analyze this invoice:
          
          Invoice: #INV-2025-042
          Project: Kitchen Remodel
          Client: John Smith Construction
          
          Financial Metrics:
          ${JSON.stringify(financialMetrics, null, 2)}
          
          Tenant Settings:
          - Target Profit Margin: 15%
          - Warning Threshold: <10%
          - Critical Threshold: <5%
          
          Provide:
          1. Profit margin assessment
          2. Identify any warnings or red flags
          3. Cost anomalies
          4. Comparison to estimate/budget
          5. Risk level (LOW/MEDIUM/HIGH/CRITICAL)
          6. Specific recommendations`
        }
      ],
      "temperature": 0.2
    }
  
  LLM Response:
    {
      "analysis": {
        "profitMarginAssessment": {
          "actualMargin": 8.2,
          "targetMargin": 15.0,
          "status": "BELOW_TARGET",
          "severity": "HIGH",
          "variance": -6.8
        },
        
        "warnings": [
          {
            "type": "LOW_PROFIT_MARGIN",
            "severity": "HIGH",
            "message": "Profit margin of 8.2% is significantly below target of 15%",
            "impact": "Potential loss of $3,400 compared to target"
          },
          {
            "type": "LABOR_COST_OVERRUN",
            "severity": "MEDIUM",
            "message": "Labor costs are 22% above original estimate",
            "impact": "Labor overrun: $2,800"
          },
          {
            "type": "BUDGET_EXCEEDED",
            "severity": "MEDIUM",
            "message": "Project costs exceeded budget by 15%",
            "impact": "Budget variance: +$5,500"
          }
        ],
        
        "costAnomalies": [
          {
            "category": "LABOR",
            "issue": "Labor costs significantly higher than estimated",
            "estimatedLabor": 12500.00,
            "actualLabor": 15300.00,
            "variance": "+22.4%",
            "possibleCauses": [
              "Project took longer than estimated",
              "Overtime required",
              "Scope creep without change order"
            ]
          }
        ],
        
        "comparisonToEstimate": {
          "originalEstimate": 50000.00,
          "finalInvoice": 52000.00,
          "variance": "+4.0%",
          "assessment": "Invoice amount is close to estimate, but profit margin 
                         eroded by cost overruns not passed to client"
        },
        
        "riskAssessment": {
          "overallRisk": "HIGH",
          "financialRisk": "HIGH",
          "clientRelationshipRisk": "LOW",
          "cashFlowRisk": "MEDIUM",
          "reasoning": "Low profit margin threatens project profitability. 
                        If pattern continues, company will operate at loss."
        },
        
        "recommendations": [
          {
            "priority": "IMMEDIATE",
            "action": "Review labor efficiency and identify why 22% overrun occurred",
            "expectedImpact": "Prevent similar overruns on future projects"
          },
          {
            "priority": "HIGH",
            "action": "Consider change order for scope creep (if applicable)",
            "expectedImpact": "Potential to recover $2,000-3,000"
          },
          {
            "priority": "MEDIUM",
            "action": "Implement tighter project tracking for labor hours",
            "expectedImpact": "Reduce labor overruns by 10-15%"
          },
          {
            "priority": "LOW",
            "action": "Document lessons learned for estimating",
            "expectedImpact": "Improve future estimate accuracy"
          }
        ],
        
        "narrativeSummary": "Invoice #INV-2025-042 shows a concerning profit margin 
                             of only 8.2%, well below your target of 15%. The primary 
                             driver is a 22% labor cost overrun ($2,800 above estimate), 
                             likely due to the project taking longer than anticipated. 
                             While the invoice amount is close to the original estimate 
                             (+4%), the increased costs have eroded profitability. 
                             
                             This represents a financial risk - if this pattern continues, 
                             you'll be operating at a loss. Immediate review of labor 
                             efficiency is recommended, along with investigating potential 
                             scope creep that wasn't captured in a change order."
      }
    }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 5: CREATE AI INSIGHTS & ANOMALIES                    │
└─────────────────────────────────────────────────────────────────────────────┘

Store Analysis Results:
  await withRLS(ctx, async (db) => {
    
    // Create primary AIInsight
    const insight = await db.aiInsight.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        insightType: "FINANCIAL",
        insightCategory: "MARGIN_ANALYSIS",
        insightTitle: "Low Profit Margin Warning - Invoice #INV-2025-042",
        
        sourceType: "INVOICE",
        sourceId: invoice.id,
        relatedEntities: {
          projectId: invoice.projectId,
          accountId: invoice.accountId
        },
        
        aiModelId: aiAction.aiModelId,
        generatedAt: new Date(),
        confidenceScore: 0.94,
        
        insightText: aiAnalysis.analysis.narrativeSummary,
        
        insightData: {
          profitMarginAssessment: aiAnalysis.analysis.profitMarginAssessment,
          warnings: aiAnalysis.analysis.warnings,
          costAnomalies: aiAnalysis.analysis.costAnomalies,
          financialMetrics: financialMetrics
        },
        
        keyMetrics: {
          profitMargin: financialMetrics.profitMargin,
          profitAmount: financialMetrics.profitAmount,
          targetMargin: 15.0,
          marginVariance: -6.8,
          laborOverrun: 2800.00,
          budgetVariance: 15.0
        },
        
        visualizationData: {
          chartType: "PROFIT_MARGIN_COMPARISON",
          data: {
            target: 15.0,
            actual: 8.2,
            industry: 12.5
          }
        },
        
        severity: "HIGH",
        priority: 9,
        requiresAction: true,
        suggestedActions: [
          "Review labor costs",
          "Check for scope creep",
          "Consider change order"
        ],
        
        status: "NEW",
        expiresAt: addDays(new Date(), 30)
      }
    });
    
    // Create AIAnomaly for labor overrun
    const laborAnomaly = await db.aiAnomaly.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        aiInsightId: insight.id,
        
        anomalyType: "COST",
        detectedValue: financialMetrics.costBreakdown.laborCosts,
        expectedValue: 12500.00, // From estimate
        deviationPercentage: 22.4,
        detectedAt: new Date(),
        
        significanceScore: 0.88,
        isPotentialError: false,
        requiresInvestigation: true,
        
        metadata: {
          category: "LABOR",
          cause: "Project duration exceeded estimate",
          impact: "Reduced profit margin by 6.8 percentage points"
        }
      }
    });
    
    // Create AIRecommendations
    for (const rec of aiAnalysis.analysis.recommendations) {
      await db.aiRecommendation.create({
        data: {
          id: uuidv7(),
          tenantId: ctx.tenantId,
          createdByActorId: ctx.actorId,
          
          aiInsightId: insight.id,
          
          recommendationText: rec.action,
          recommendationType: "REVIEW",
          priority: rec.priority === "IMMEDIATE" ? 10 : 
                    rec.priority === "HIGH" ? 8 :
                    rec.priority === "MEDIUM" ? 5 : 3,
          estimatedImpact: rec.priority === "IMMEDIATE" ? "HIGH" : "MEDIUM",
          estimatedEffort: "MEDIUM",
          
          canAutoExecute: false,
          requiresApproval: false,
          
          status: "PENDING",
          
          metadata: {
            expectedImpact: rec.expectedImpact
          }
        }
      });
    }
    
    // Create AITrend if we have historical data
    const historicalMargins = await db.invoice.findMany({
      where: {
        tenantId: ctx.tenantId,
        projectId: { not: null },
        status: { in: ["PAID", "SENT"] },
        createdAt: {
          gte: subMonths(new Date(), 6)
        }
      },
      select: {
        invoiceNumber: true,
        total: true,
        createdAt: true,
        project: {
          select: {
            // Would need to calculate actual costs for each
          }
        }
      },
      take: 50
    });
    
    // If we detect declining margin trend
    if (historicalMargins.length >= 10) {
      await db.aiTrend.create({
        data: {
          id: uuidv7(),
          tenantId: ctx.tenantId,
          createdByActorId: ctx.actorId,
          
          aiInsightId: insight.id,
          
          trendType: "DOWNWARD",
          trendScope: "PROJECT",
          trendStrength: 0.72,
          trendDuration: 180, // days
          
          startValue: 14.5, // Profit margin 6 months ago
          endValue: 8.2,    // Current profit margin
          changePercentage: -43.4,
          
          projectedValue: 6.1, // If trend continues
          projectionTimeframe: 90, // days
          
          metadata: {
            warningMessage: "Profit margins declining over last 6 months",
            urgency: "HIGH"
          }
        }
      });
    }
    
    return insight;
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 6: GENERATE USER-FRIENDLY RESPONSE                   │
└─────────────────────────────────────────────────────────────────────────────┘

AI Response Generation:
  LLM Request (final synthesis):
    {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "system",
          "content": "You are a financial advisor. Convert technical analysis 
                      into clear, actionable advice for a construction business owner."
        },
        {
          "role": "user",
          "content": `The user asked: "What is the profit margin of Invoice #42? 
                       Are there any warnings?"
                       
                       Analysis Results:
                       ${JSON.stringify(aiAnalysis, null, 2)}
                       
                       Generate a clear, professional response that:
                       1. Directly answers the profit margin question
                       2. Explains warnings in plain language
                       3. Provides actionable next steps
                       4. Is empathetic but honest about risks`
        }
      ],
      "temperature": 0.7
    }
  
  LLM Response:
    "Invoice #INV-2025-042 has a profit margin of **8.2%**, which is concerning 
     because it's significantly below your target of 15%.
     
     Here are the key warnings:
     
     ⚠️ **High Priority Issues:**
     - Your labor costs ran 22% over estimate ($2,800 higher than planned)
     - This reduced your profit margin by nearly 7 percentage points
     - The project exceeded budget by 15% overall
     
     💡 **What This Means:**
     If this pattern continues across projects, you'll struggle to maintain 
     profitability. On a $52,000 invoice, you're earning $3,400 less than target.
     
     📋 **Recommended Actions:**
     1. **Immediate:** Review why labor took 22% longer than estimated
     2. **This Week:** Check if there was scope creep that wasn't captured in a 
        change order - you may be able to recover $2-3K
     3. **Going Forward:** Implement daily labor tracking to catch overruns early
     
     The good news: Your invoice amount is close to the estimate (+4%), so the 
     client relationship isn't at risk. This is an internal cost control issue 
     that you can address.
     
     Would you like me to generate a detailed cost breakdown or help you review 
     the labor records?"

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 7: RETURN TO USER WITH VISUALIZATION                 │
└─────────────────────────────────────────────────────────────────────────────┘

API Response:
  {
    "success": true,
    "message": "{AI-generated response}",
    "insightId": "{uuid}",
    "data": {
      "profitMargin": 8.2,
      "profitAmount": 4264.00,
      "targetMargin": 15.0,
      "riskLevel": "HIGH",
      "warnings": [
        {
          "type": "LOW_PROFIT_MARGIN",
          "severity": "HIGH",
          "message": "Profit margin below target"
        }
      ],
      "recommendations": [...]
    },
    "visualization": {
      "type": "PROFIT_MARGIN_GAUGE",
      "data": {
        "current": 8.2,
        "target": 15.0,
        "industry": 12.5,
        "zones": {
          "critical": [0, 5],
          "warning": [5, 10],
          "acceptable": [10, 15],
          "excellent": [15, 25]
        }
      }
    }
  }

Frontend Display:
  ┌──────────────────────────────────────────────────────────┐
  │  🤖 AI Financial Analysis: Invoice #INV-2025-042         │
  ├──────────────────────────────────────────────────────────┤
  │                                                          │
  │  Profit Margin: 8.2% ⚠️                                  │
  │  ┌────────────────────────────────────────┐             │
  │  │░░░░░░░░░░░░░░                          │             │
  │  │ Critical  Warning  Acceptable Excellent │             │
  │  └────────────────────────────────────────┘             │
  │         0%    5%    10%   15%   20%   25%               │
  │                                                          │
  │  ⚠️  HIGH PRIORITY WARNINGS                              │
  │  • Labor costs 22% over estimate (+$2,800)              │
  │  • Profit margin 6.8% below target (-$3,400)            │
  │  • Project exceeded budget by 15%                       │
  │                                                          │
  │  💡 RECOMMENDED ACTIONS                                  │
  │  1. Review labor efficiency (Why 22% overrun?)          │
  │  2. Check for scope creep (Potential recovery: $2-3K)   │
  │  3. Implement daily labor tracking                      │
  │                                                          │
  │  [View Full Analysis] [Download Report] [Dismiss]       │
  └──────────────────────────────────────────────────────────┘
```

---

## 4. FLOW: Project Schedule Intelligence

### Overview
AI analyzes project schedule, task progress, and resource allocation to predict completion dates, identify delays, and recommend corrective actions.

### Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TRIGGER: Scheduled Analysis or User Query                 │
└─────────────────────────────────────────────────────────────────────────────┘

Trigger Option A: Daily Scheduled AIJob
  └─── Cron: Every day at 6:00 AM
  └─── Analyzes: All active projects

Trigger Option B: User Query
  User asks: "Is Project #34 on schedule?"

Let's follow Option B:

User Types: "Is Project #34 on schedule? When will it be completed?"
     │
     ▼
POST /api/ai/agent/query
     {
       "query": "Is Project #34 on schedule? When will it be completed?",
       "context": {
         "module": "PROJECT"
       }
     }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: LOAD PROJECT SCHEDULE DATA                        │
└─────────────────────────────────────────────────────────────────────────────┘

Backend Handler:
  await withRLS(ctx, async (db) => {
    
    const project = await db.project.findFirst({
      where: {
        tenantId: ctx.tenantId,
        OR: [
          { id: "34" },
          { projectNumber: { contains: "34" } }
        ]
      },
      include: {
        // Schedule data
        projectTasks: {
          include: {
            projectTaskAssignments: {
              include: {
                employee: true,
                member: true
              }
            },
            projectTaskDependencies: true
          },
          orderBy: { startDate: 'asc' }
        },
        
        projectMilestones: {
          orderBy: { targetDate: 'asc' }
        },
        
        projectSchedule: {
          include: {
            projectScheduleItems: true
          }
        },
        
        // Progress tracking
        projectProgress: {
          orderBy: { recordedAt: 'desc' },
          take: 30 // Last 30 days
        },
        
        // Work orders (actual work done)
        workOrders: {
          include: {
            workOrderTasks: true
          },
          where: {
            status: { in: ["COMPLETED", "IN_PROGRESS"] }
          }
        },
        
        // Weather delays
        weatherImpactEvents: {
          where: {
            eventDate: {
              gte: project.startDate
            }
          }
        },
        
        // Change orders (scope changes)
        changeOrders: {
          where: {
            status: "APPROVED"
          },
          include: {
            changeOrderScheduleImpacts: true
          }
        }
      }
    });
    
    return project;
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: CALCULATE SCHEDULE METRICS                        │
└─────────────────────────────────────────────────────────────────────────────┘

Schedule Analysis Engine:
  
  // Calculate overall progress
  const totalTasks = project.projectTasks.length;
  const completedTasks = project.projectTasks.filter(
    t => t.status === "COMPLETED"
  ).length;
  const inProgressTasks = project.projectTasks.filter(
    t => t.status === "IN_PROGRESS"
  ).length;
  const percentComplete = (completedTasks / totalTasks) * 100;
  
  // Calculate planned vs actual
  const today = new Date();
  const projectDuration = differenceInDays(
    project.endDate,
    project.startDate
  );
  const daysElapsed = differenceInDays(today, project.startDate);
  const plannedPercentComplete = (daysElapsed / projectDuration) * 100;
  
  // Schedule Performance Index (SPI)
  const SPI = percentComplete / plannedPercentComplete;
  // SPI > 1.0 = ahead of schedule
  // SPI = 1.0 = on schedule
  // SPI < 1.0 = behind schedule
  
  // Identify late tasks
  const lateTasks = project.projectTasks.filter(task => {
    if (task.status === "COMPLETED") return false;
    return task.dueDate && task.dueDate < today;
  });
  
  // Calculate critical path
  const criticalPathTasks = calculateCriticalPath(project.projectTasks);
  
  // Analyze late critical path tasks (high priority)
  const lateCriticalTasks = criticalPathTasks.filter(task => 
    lateTasks.some(lt => lt.id === task.id)
  );
  
  // Check milestone status
  const upcomingMilestones = project.projectMilestones.filter(
    m => m.targetDate >= today && m.targetDate <= addDays(today, 30)
  );
  const atRiskMilestones = upcomingMilestones.filter(milestone => {
    const tasksForMilestone = project.projectTasks.filter(
      t => t.milestoneId === milestone.id
    );
    const allComplete = tasksForMilestone.every(t => t.status === "COMPLETED");
    return !allComplete;
  });
  
  // Factor in weather delays
  const weatherDelayDays = project.weatherImpactEvents.reduce(
    (sum, event) => sum + (event.delayDays || 0), 0
  );
  
  // Factor in change orders
  const changeOrderDelayDays = project.changeOrders
    .flatMap(co => co.changeOrderScheduleImpacts)
    .reduce((sum, impact) => sum + (impact.delayDays || 0), 0);
  
  // Predicted completion date (simple linear projection)
  const averageDailyProgress = percentComplete / daysElapsed;
  const daysRemaining = (100 - percentComplete) / averageDailyProgress;
  const predictedCompletionDate = addDays(today, daysRemaining);
  
  const scheduleMetrics = {
    projectStatus: {
      percentComplete: percentComplete,
      plannedPercentComplete: plannedPercentComplete,
      variance: percentComplete - plannedPercentComplete,
      SPI: SPI,
      scheduleStatus: SPI >= 0.95 ? "ON_TRACK" : 
                      SPI >= 0.85 ? "MINOR_DELAY" :
                      SPI >= 0.70 ? "SIGNIFICANT_DELAY" : "CRITICAL_DELAY"
    },
    
    timeline: {
      startDate: project.startDate,
      plannedEndDate: project.endDate,
      currentDate: today,
      daysElapsed: daysElapsed,
      totalProjectDays: projectDuration,
      daysRemaining: differenceInDays(project.endDate, today),
      predictedCompletionDate: predictedCompletionDate,
      delayDays: differenceInDays(predictedCompletionDate, project.endDate)
    },
    
    taskMetrics: {
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      inProgressTasks: inProgressTasks,
      notStartedTasks: totalTasks - completedTasks - inProgressTasks,
      lateTasks: lateTasks.length,
      criticalPathTasks: criticalPathTasks.length,
      lateCriticalTasks: lateCriticalTasks.length
    },
    
    milestones: {
      total: project.projectMilestones.length,
      upcoming: upcomingMilestones.length,
      atRisk: atRiskMilestones.length
    },
    
    impactFactors: {
      weatherDelayDays: weatherDelayDays,
      changeOrderDelayDays: changeOrderDelayDays,
      totalDelayDays: weatherDelayDays + changeOrderDelayDays
    }
  };

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: AI SCHEDULE ANALYSIS                              │
└─────────────────────────────────────────────────────────────────────────────┘

AI Analysis:
  LLM Request:
    {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "system",
          "content": "You are a construction project manager and schedule analyst. 
                      Analyze project schedule metrics and provide insights on 
                      delays, risks, and corrective actions."
        },
        {
          "role": "user",
          "content": `Analyze this project schedule:
          
          Project: Kitchen Remodel (#34)
          
          Schedule Metrics:
          ${JSON.stringify(scheduleMetrics, null, 2)}
          
          Late Critical Path Tasks:
          ${JSON.stringify(lateCriticalTasks, null, 2)}
          
          At-Risk Milestones:
          ${JSON.stringify(atRiskMilestones, null, 2)}
          
          Provide:
          1. Clear answer: Is project on schedule?
          2. Predicted completion date with confidence interval
          3. Root causes of any delays
          4. Impact assessment (cost, client satisfaction)
          5. Specific recommendations to get back on track
          6. Resource needs (additional crew, equipment)`
        }
      ],
      "temperature": 0.2
    }
  
  LLM Response:
    {
      "analysis": {
        "scheduleStatus": {
          "isOnSchedule": false,
          "status": "MINOR_DELAY",
          "summary": "Project is running 12 days behind original schedule"
        },
        
        "completion": {
          "predictedDate": "2026-01-27",
          "originalDate": "2026-01-15",
          "delayDays": 12,
          "confidence": {
            "low": "2026-01-24",     // Best case
            "median": "2026-01-27",  // Most likely
            "high": "2026-02-03"     // Worst case
          },
          "confidenceLevel": 0.82
        },
        
        "rootCauses": [
          {
            "cause": "Weather Delays",
            "impact": "5 days",
            "description": "Rain and cold weather stopped exterior work for 5 days",
            "isControllable": false
          },
          {
            "cause": "Task Underestimation",
            "impact": "4 days",
            "description": "Drywall and electrical tasks took longer than estimated",
            "isControllable": true
          },
          {
            "cause": "Material Delivery Delays",
            "impact": "3 days",
            "description": "Custom cabinets arrived 3 days late",
            "isControllable": "partially"
          }
        ],
        
        "criticalPathIssues": [
          {
            "task": "Drywall installation",
            "status": "IN_PROGRESS",
            "daysLate": 4,
            "impact": "Blocking painting and trim work",
            "priority": "CRITICAL"
          },
          {
            "task": "Electrical rough-in",
            "status": "NOT_STARTED",
            "daysLate": 2,
            "impact": "Required before drywall completion",
            "priority": "HIGH"
          }
        ],
        
        "impactAssessment": {
          "costImpact": {
            "estimatedCost": 3500.00,
            "breakdown": {
              "laborExtension": 2400.00,
              "equipmentRental": 600.00,
              "overhead": 500.00
            }
          },
          "clientSatisfactionRisk": "MEDIUM",
          "contractualRisk": "LOW", // Not past contractual deadline yet
          "recommendations": "Notify client proactively of revised timeline"
        },
        
        "recommendations": [
          {
            "priority": "IMMEDIATE",
            "action": "Add 1 additional drywall crew",
            "expectedImpact": "Reduce delay by 6 days",
            "cost": 1800.00,
            "timeframe": "Start tomorrow"
          },
          {
            "priority": "HIGH",
            "action": "Expedite electrical rough-in",
            "expectedImpact": "Unblock drywall completion",
            "cost": 600.00,
            "timeframe": "Complete within 2 days"
          },
          {
            "priority": "MEDIUM",
            "action": "Pre-order all remaining materials now",
            "expectedImpact": "Prevent future delays",
            "cost": 0,
            "timeframe": "Within 1 week"
          }
        ],
        
        "resourceNeeds": {
          "labor": [
            {
              "role": "Drywall Installer",
              "quantity": 2,
              "duration": "3 days",
              "cost": 1800.00
            }
          ],
          "equipment": [],
          "materials": [
            {
              "item": "Expedite cabinet delivery",
              "urgency": "HIGH"
            }
          ]
        },
        
        "milestonesAtRisk": [
          {
            "milestone": "Drywall Complete",
            "targetDate": "2025-12-15",
            "projectedDate": "2025-12-19",
            "riskLevel": "HIGH",
            "recommendation": "Add crew to recover 4 days"
          }
        ]
      }
    }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: CREATE AI INSIGHTS & PREDICTIONS                  │
└─────────────────────────────────────────────────────────────────────────────┘

Store Analysis:
  await withRLS(ctx, async (db) => {
    
    // Create primary AIInsight
    const insight = await db.aiInsight.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        insightType: "OPERATIONAL",
        insightCategory: "SCHEDULE_DELAY",
        insightTitle: "Project #34 Running 12 Days Behind Schedule",
        
        sourceType: "PROJECT",
        sourceId: project.id,
        
        aiModelId: aiAction.aiModelId,
        generatedAt: new Date(),
        confidenceScore: 0.82,
        
        insightText: "Kitchen Remodel project is running 12 days behind the 
                      original completion date. Primary causes: weather delays (5 days), 
                      task underestimation (4 days), and material delays (3 days). 
                      Critical path tasks (drywall, electrical) are blocking progress.",
        
        insightData: aiAnalysis.analysis,
        
        keyMetrics: {
          percentComplete: scheduleMetrics.projectStatus.percentComplete,
          SPI: scheduleMetrics.projectStatus.SPI,
          delayDays: 12,
          predictedCompletionDate: aiAnalysis.analysis.completion.predictedDate,
          costImpact: 3500.00
        },
        
        visualizationData: {
          chartType: "GANTT_WITH_DELAYS",
          data: {
            originalSchedule: project.projectTasks,
            actualProgress: /* ... */,
            criticalPath: criticalPathTasks
          }
        },
        
        severity: "MEDIUM",
        priority: 7,
        requiresAction: true,
        suggestedActions: [
          "Add drywall crew",
          "Expedite electrical work",
          "Notify client"
        ],
        
        status: "NEW"
      }
    });
    
    // Create AIPrediction for completion date
    await db.aiPrediction.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        aiInsightId: insight.id,
        
        predictionType: "COMPLETION_DATE",
        predictedValue: {
          date: aiAnalysis.analysis.completion.predictedDate,
          confidenceInterval: aiAnalysis.analysis.completion.confidence
        },
        confidence: 0.82,
        timeHorizon: differenceInDays(
          new Date(aiAnalysis.analysis.completion.predictedDate),
          today
        ),
        
        baselineValue: {
          originalDate: project.endDate
        },
        trend: "INCREASING", // Delay increasing
        variance: 12, // days
        
        metadata: {
          factors: aiAnalysis.analysis.rootCauses,
          assumptions: [
            "No additional weather delays",
            "Recommended resources added",
            "No new scope changes"
          ]
        }
      }
    });
    
    // Create AIRecommendations
    for (const rec of aiAnalysis.analysis.recommendations) {
      await db.aiRecommendation.create({
        data: {
          id: uuidv7(),
          tenantId: ctx.tenantId,
          createdByActorId: ctx.actorId,
          
          aiInsightId: insight.id,
          
          recommendationText: rec.action,
          recommendationType: "ADJUST",
          priority: rec.priority === "IMMEDIATE" ? 10 :
                    rec.priority === "HIGH" ? 8 : 5,
          estimatedImpact: "HIGH",
          estimatedEffort: "MEDIUM",
          
          canAutoExecute: false,
          requiresApproval: true,
          
          status: "PENDING",
          
          metadata: {
            expectedImpact: rec.expectedImpact,
            cost: rec.cost,
            timeframe: rec.timeframe
          }
        }
      });
    }
    
    // Create AITrend for schedule performance
    await db.aiTrend.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        aiInsightId: insight.id,
        
        trendType: "DOWNWARD",
        trendScope: "PROJECT",
        trendStrength: 0.68,
        trendDuration: daysElapsed,
        
        startValue: 1.0, // SPI started at 1.0 (on schedule)
        endValue: scheduleMetrics.projectStatus.SPI, // Current SPI
        changePercentage: (scheduleMetrics.projectStatus.SPI - 1.0) * 100,
        
        projectedValue: scheduleMetrics.projectStatus.SPI * 0.95, // Could worsen
        projectionTimeframe: 14, // days
        
        metadata: {
          metric: "Schedule Performance Index (SPI)",
          warningMessage: "Schedule performance declining over project duration"
        }
      }
    });
    
    return insight;
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 5: GENERATE USER RESPONSE                            │
└─────────────────────────────────────────────────────────────────────────────┘

AI Response:
  "Project #34 (Kitchen Remodel) is **running 12 days behind schedule**.
  
  📊 **Current Status:**
  - Completion: 48% (should be 60% by now)
  - Schedule Performance Index: 0.80 (below 1.0 = delayed)
  - Predicted Completion: January 27, 2026 (original: January 15)
  
  🔍 **Why the Delay?**
  1. **Weather delays** (5 days) - Rain stopped exterior work
  2. **Underestimated tasks** (4 days) - Drywall taking longer than planned
  3. **Material delays** (3 days) - Custom cabinets arrived late
  
  ⚠️ **Critical Issues:**
  - Drywall installation is 4 days behind (blocking all finish work)
  - Electrical rough-in hasn't started (needed before drywall wraps)
  
  💰 **Impact:**
  - Additional cost: $3,500 (labor extension, equipment rental)
  - Client satisfaction risk: MEDIUM
  - You're not past contractual deadline yet
  
  ✅ **What You Should Do:**
  1. **Tomorrow**: Add 1 more drywall crew ($1,800) - recover 6 days
  2. **This Week**: Expedite electrical rough-in ($600) - unblock drywall
  3. **Now**: Notify client of revised timeline (proactive communication)
  4. **Soon**: Pre-order all remaining materials to prevent future delays
  
  If you implement recommendations #1 and #2, you can reduce the delay from 
  12 days to about 6 days, completing around January 21st instead of January 27th.
  
  Would you like me to:
  - Generate a revised project schedule?
  - Draft a client communication about the delay?
  - Create work orders for the additional crew?"

Frontend Display:
  ┌──────────────────────────────────────────────────────────────┐
  │  📅 Schedule Analysis: Project #34 - Kitchen Remodel         │
  ├──────────────────────────────────────────────────────────────┤
  │                                                              │
  │  Status: ⚠️  12 Days Behind Schedule                         │
  │                                                              │
  │  ┌────────────────────────────────────────────────┐         │
  │  │ Progress: ██████████░░░░░░░░░░░░ 48%            │         │
  │  │ Expected: ████████████████░░░░░░ 60%            │         │
  │  └────────────────────────────────────────────────┘         │
  │                                                              │
  │  Predicted Completion: Jan 27, 2026 (was Jan 15)           │
  │                                                              │
  │  🔴 CRITICAL DELAYS                                          │
  │  • Drywall installation: 4 days late                        │
  │  • Electrical rough-in: Not started (blocking)              │
  │                                                              │
  │  💡 RECOMMENDED ACTIONS                                      │
  │  1. Add drywall crew (-6 days, $1,800)                      │
  │  2. Expedite electrical (-2 days, $600)                     │
  │  3. Notify client of revised timeline                       │
  │                                                              │
  │  Impact if actions taken: Complete by Jan 21 (6 day delay)  │
  │                                                              │
  │  [View Full Analysis] [Generate Schedule] [Create WOs]      │
  └──────────────────────────────────────────────────────────────┘
```

---

## 5. FLOW: Document OCR & Intelligent Extraction

### Overview
AI processes uploaded documents (invoices, receipts, contracts, blueprints) to extract text, classify document type, and parse structured data for auto-population.

### Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TRIGGER: User Uploads Document                            │
└─────────────────────────────────────────────────────────────────────────────┘

User Action: Uploads PDF invoice from vendor
     │
     ▼
Frontend: File upload component
     │
     ├─── File: vendor-invoice.pdf (2.3 MB)
     ├─── Context: "Expense Report" module
     └─── Sends to: POST /api/documents/upload
     
POST /api/documents/upload
     Headers:
       Authorization: Bearer {token}
     Body (multipart/form-data):
       file: {binary PDF data}
       context: "EXPENSE"
       autoProcess: true

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: DOCUMENT UPLOAD & STORAGE                         │
└─────────────────────────────────────────────────────────────────────────────┘

Backend Handler:
  1. Permission check
     └─── requirePermission(ctx, "document:upload")
  
  2. Validate file
     ├─── Check file size (max 25 MB)
     ├─── Check file type (PDF, PNG, JPG, JPEG, TIFF)
     └─── Scan for malware (ClamAV or similar)
  
  3. Upload to storage
     const fileKey = `${ctx.tenantId}/documents/${uuidv7()}.pdf`;
     await s3.putObject({
       Bucket: "erp-documents",
       Key: fileKey,
       Body: fileBuffer,
       ContentType: "application/pdf",
       Metadata: {
         tenantId: ctx.tenantId,
         uploadedBy: ctx.actorId,
         originalFilename: "vendor-invoice.pdf"
       }
     });
  
  4. Create Document record
     await withRLS(ctx, async (db) => {
       const document = await db.document.create({
         data: {
           id: uuidv7(),
           tenantId: ctx.tenantId,
           createdByActorId: ctx.actorId,
           updatedByActorId: ctx.actorId,
           
           documentName: "vendor-invoice.pdf",
           documentType: "UNKNOWN", // Will be classified by AI
           fileSize: 2400000, // bytes
           mimeType: "application/pdf",
           
           storageProvider: "AWS_S3",
           storageKey: fileKey,
           storageUrl: `https://s3.amazonaws.com/erp-documents/${fileKey}`,
           
           status: "UPLOADED",
           
           metadata: {
             uploadContext: "EXPENSE",
             autoProcessRequested: true
           }
         }
       });
       
       return document;
     });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: CREATE AI DOCUMENT INDEX & QUEUE JOB              │
└─────────────────────────────────────────────────────────────────────────────┘

AI Processing Setup:
  await withRLS(ctx, async (db) => {
    
    // Create AIDocumentIndex
    const aiDocIndex = await db.aiDocumentIndex.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        sourceDocumentId: document.id,
        sourceType: "EXPENSE", // From upload context
        documentName: document.documentName,
        documentUrl: document.storageUrl,
        
        processingStatus: "PENDING",
        
        aiModelId: getDefaultAIModel(ctx.tenantId, "DOCUMENT_PROCESSING"),
        extractionStrategy: "OCR", // Will do OCR first
        confidenceThreshold: 0.75,
        
        pageCount: null, // Will be determined
        fileSize: document.fileSize,
        mimeType: document.mimeType,
        language: "en" // Default, will be detected
      }
    });
    
    // Create AIJob for background processing
    const aiJob = await db.aiJob.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        jobName: `Process Document: ${document.documentName}`,
        jobType: "DOCUMENT_PROCESSING",
        
        triggeredBy: "MANUAL",
        triggeredByActorId: ctx.actorId,
        
        inputParameters: {
          aiDocumentIndexId: aiDocIndex.id,
          documentId: document.id,
          processingSteps: [
            "OCR",
            "CLASSIFICATION",
            "EXTRACTION",
            "EMBEDDING"
          ]
        },
        
        priority: 7, // Medium-high priority
        maxExecutionMinutes: 10,
        
        status: "PENDING",
        progressPercentage: 0
      }
    });
    
    return { aiDocIndex, aiJob };
  });
  
  // Queue job for background worker
  await jobQueue.enqueue({
    jobId: aiJob.id,
    type: "AI_DOCUMENT_PROCESSING",
    payload: {
      aiDocumentIndexId: aiDocIndex.id,
      documentId: document.id
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: BACKGROUND WORKER - OCR PROCESSING                │
└─────────────────────────────────────────────────────────────────────────────┘

Background Worker Picks Up Job:
  
  // Update job status
  await db.aiJob.update({
    where: { id: aiJob.id },
    data: {
      status: "RUNNING",
      startedAt: new Date(),
      progressPercentage: 10,
      currentStep: "OCR Processing"
    }
  });
  
  // Update document index status
  await db.aiDocumentIndex.update({
    where: { id: aiDocIndex.id },
    data: {
      processingStatus: "PROCESSING"
    }
  });
  
  // Download document from S3
  const documentBuffer = await s3.getObject({
    Bucket: "erp-documents",
    Key: document.storageKey
  }).then(res => res.Body);
  
  // Convert PDF to images (one per page)
  const pdfImages = await convertPDFToImages(documentBuffer);
  // pdfImages = [
  //   { pageNumber: 1, imageBuffer: Buffer },
  //   { pageNumber: 2, imageBuffer: Buffer }
  // ]
  
  // Perform OCR on each page
  for (const page of pdfImages) {
    
    // Call external OCR service (Google Vision, AWS Textract, etc.)
    const ocrResult = await performOCR({
      provider: "GOOGLE_VISION",
      imageBuffer: page.imageBuffer,
      language: "en"
    });
    
    // ocrResult structure:
    // {
    //   fullText: "ABC SUPPLY\n123 Main St\nInvoice #12345...",
    //   confidence: 0.95,
    //   words: [
    //     { text: "ABC", confidence: 0.98, boundingBox: {x, y, width, height} },
    //     { text: "SUPPLY", confidence: 0.97, boundingBox: {x, y, width, height} },
    //     ...
    //   ],
    //   lines: [...],
    //   paragraphs: [...],
    //   tables: [
    //     {
    //       rows: [
    //         { cells: ["Description", "Qty", "Price", "Total"] },
    //         { cells: ["Lumber", "100", "$12.50", "$1,250.00"] }
    //       ]
    //     }
    //   ]
    // }
    
    // Store OCR result
    await db.aIOCRResult.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        aiDocumentIndexId: aiDocIndex.id,
        
        ocrEngine: "GOOGLE_VISION",
        ocrVersion: "v1",
        processedAt: new Date(),
        processingTimeMs: ocrResult.processingTime,
        
        rawText: ocrResult.fullText,
        confidence: ocrResult.confidence,
        language: ocrResult.language,
        characterCount: ocrResult.fullText.length,
        
        pageNumber: page.pageNumber,
        pageText: ocrResult.fullText,
        pageConfidence: ocrResult.confidence,
        
        words: ocrResult.words,
        lines: ocrResult.lines,
        paragraphs: ocrResult.paragraphs,
        tables: ocrResult.tables,
        
        lowConfidenceWordCount: ocrResult.words.filter(w => w.confidence < 0.7).length,
        unreliableRegions: ocrResult.words
          .filter(w => w.confidence < 0.7)
          .map(w => w.boundingBox),
        requiresReview: ocrResult.confidence < 0.85
      }
    });
    
    // Create document chunks for search/RAG
    const chunks = chunkText(ocrResult.fullText, {
      maxChunkSize: 500, // characters
      overlap: 50 // character overlap between chunks
    });
    
    for (const [index, chunk] of chunks.entries()) {
      await db.aiDocumentChunk.create({
        data: {
          id: uuidv7(),
          tenantId: ctx.tenantId,
          createdByActorId: ctx.actorId,
          
          aiDocumentIndexId: aiDocIndex.id,
          
          chunkNumber: index + 1,
          pageNumber: page.pageNumber,
          chunkHash: crypto.createHash('sha256').update(chunk.text).digest('hex'),
          
          chunkText: chunk.text,
          chunkSize: chunk.text.length,
          tokenCount: estimateTokenCount(chunk.text),
          
          contextBefore: chunk.contextBefore,
          contextAfter: chunk.contextAfter,
          
          searchableText: normalizeForSearch(chunk.text),
          keywords: extractKeywords(chunk.text)
        }
      });
    }
  }
  
  // Update job progress
  await db.aiJob.update({
    where: { id: aiJob.id },
    data: {
      progressPercentage: 40,
      currentStep: "OCR Complete"
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: DOCUMENT CLASSIFICATION (AI)                      │
└─────────────────────────────────────────────────────────────────────────────┘

AI Classification:
  
  // Combine all OCR text
  const fullDocumentText = await db.aIOCRResult.findMany({
    where: { aiDocumentIndexId: aiDocIndex.id },
    orderBy: { pageNumber: 'asc' }
  }).then(results => 
    results.map(r => r.rawText).join('\n\n')
  );
  
  // Call AI for classification
  const aiModel = await db.aiModel.findUnique({
    where: { id: aiDocIndex.aiModelId }
  });
  
  const classificationPrompt = {
    "model": aiModel.modelName,
    "messages": [
      {
        "role": "system",
        "content": `You are a document classifier. Classify documents into these types:
                    - INVOICE (vendor invoice)
                    - RECEIPT (expense receipt)
                    - CONTRACT (legal contract)
                    - ESTIMATE (estimate/quote)
                    - BLUEPRINT (technical drawing)
                    - PERMIT (building permit)
                    - REPORT (project report)
                    - OTHER
                    
                    Return JSON with:
                    {
                      "documentType": "...",
                      "confidence": 0.0-1.0,
                      "reasoning": "...",
                      "alternativeTypes": [{type, confidence}]
                    }`
      },
      {
        "role": "user",
        "content": `Classify this document:\n\n${fullDocumentText.substring(0, 2000)}`
      }
    ],
    "response_format": { "type": "json_object" },
    "temperature": 0.1
  };
  
  const classificationResponse = await callLLMAPI(
    aiModel.apiEndpoint,
    aiModel.apiKeyEncrypted,
    classificationPrompt
  );
  
  // classificationResponse:
  // {
  //   "documentType": "INVOICE",
  //   "confidence": 0.96,
  //   "reasoning": "Document contains: vendor name, invoice number, line items 
  //                 with prices, total amount, due date - all indicators of vendor invoice",
  //   "alternativeTypes": [
  //     { "type": "RECEIPT", "confidence": 0.03 },
  //     { "type": "ESTIMATE", "confidence": 0.01 }
  //   ]
  // }
  
  // Store classification
  await db.aiClassificationResult.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      createdByActorId: ctx.actorId,
      
      aiDocumentIndexId: aiDocIndex.id,
      
      predictedClass: classificationResponse.documentType,
      confidence: classificationResponse.confidence,
      classifierModel: aiModel.id,
      classifiedAt: new Date(),
      
      allPredictions: classificationResponse.alternativeTypes,
      features: {
        documentLength: fullDocumentText.length,
        hasInvoiceNumber: /invoice\s*#?\s*\d+/i.test(fullDocumentText),
        hasTotal: /total|amount\s+due/i.test(fullDocumentText),
        hasLineItems: /description|qty|quantity|price/i.test(fullDocumentText)
      },
      reasoning: classificationResponse.reasoning,
      
      manuallyVerified: false
    }
  });
  
  // Update document type
  await db.document.update({
    where: { id: document.id },
    data: {
      documentType: classificationResponse.documentType
    }
  });
  
  await db.aiDocumentIndex.update({
    where: { id: aiDocIndex.id },
    data: {
      documentType: classificationResponse.documentType
    }
  });
  
  // Update job progress
  await db.aiJob.update({
    where: { id: aiJob.id },
    data: {
      progressPercentage: 60,
      currentStep: "Classification Complete"
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 5: STRUCTURED DATA EXTRACTION (AI)                   │
└─────────────────────────────────────────────────────────────────────────────┘

AI Data Extraction:
  
  // Based on classification, use appropriate extraction template
  const extractionPrompt = buildExtractionPrompt(
    classificationResponse.documentType,
    fullDocumentText
  );
  
  // For INVOICE type:
  const invoiceExtractionPrompt = {
    "model": aiModel.modelName,
    "messages": [
      {
        "role": "system",
        "content": `You are a data extraction expert. Extract structured data 
                    from vendor invoices. Return JSON with:
                    {
                      "vendorName": "...",
                      "vendorAddress": {...},
                      "invoiceNumber": "...",
                      "invoiceDate": "YYYY-MM-DD",
                      "dueDate": "YYYY-MM-DD",
                      "purchaseOrderNumber": "..." or null,
                      "lineItems": [
                        {
                          "lineNumber": 1,
                          "description": "...",
                          "quantity": number,
                          "unitPrice": number,
                          "total": number
                        }
                      ],
                      "subtotal": number,
                      "tax": number,
                      "total": number,
                      "paymentTerms": "...",
                      "notes": "..."
                    }
                    
                    Extract ALL line items. Be precise with numbers.`
      },
      {
        "role": "user",
        "content": `Extract data from this invoice:\n\n${fullDocumentText}`
      }
    ],
    "response_format": { "type": "json_object" },
    "temperature": 0.1
  };
  
  const extractionResponse = await callLLMAPI(
    aiModel.apiEndpoint,
    aiModel.apiKeyEncrypted,
    invoiceExtractionPrompt
  );
  
  // extractionResponse:
  // {
  //   "vendorName": "ABC Supply Co.",
  //   "vendorAddress": {
  //     "street": "123 Industrial Blvd",
  //     "city": "Dallas",
  //     "state": "TX",
  //     "zipCode": "75201"
  //   },
  //   "invoiceNumber": "INV-2025-8842",
  //   "invoiceDate": "2025-11-15",
  //   "dueDate": "2025-12-15",
  //   "purchaseOrderNumber": "PO-2025-0156",
  //   "lineItems": [
  //     {
  //       "lineNumber": 1,
  //       "description": "2x4x8 Lumber - Premium Grade",
  //       "quantity": 100,
  //       "unitPrice": 8.50,
  //       "total": 850.00
  //     },
  //     {
  //       "lineNumber": 2,
  //       "description": "1/2\" Drywall Sheets 4x8",
  //       "quantity": 50,
  //       "unitPrice": 12.25,
  //       "total": 612.50
  //     }
  //   ],
  //   "subtotal": 1462.50,
  //   "tax": 120.66,
  //   "total": 1583.16,
  //   "paymentTerms": "Net 30",
  //   "notes": "Delivery to job site #34"
  // }
  
  // Validate extraction
  const validationErrors = validateExtraction(extractionResponse, {
    requiredFields: ["vendorName", "invoiceNumber", "invoiceDate", "total"],
    numericFields: ["subtotal", "tax", "total"],
    dateFields: ["invoiceDate", "dueDate"]
  });
  
  const validationStatus = validationErrors.length === 0 ? "VALID" : 
                           validationErrors.some(e => e.severity === "ERROR") ? "INVALID" :
                           "NEEDS_REVIEW";
  
  // Store extraction result
  const extraction = await db.aiExtractionResult.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      createdByActorId: ctx.actorId,
      
      aiDocumentIndexId: aiDocIndex.id,
      
      extractionType: "INVOICE",
      extractionModel: aiModel.id,
      extractionPrompt: invoiceExtractionPrompt.messages[0].content,
      extractedAt: new Date(),
      
      extractedData: extractionResponse,
      confidence: 0.91, // Overall confidence
      validationStatus: validationStatus,
      validationErrors: validationErrors,
      
      fieldConfidences: {
        vendorName: 0.98,
        invoiceNumber: 0.99,
        invoiceDate: 0.95,
        total: 0.89,
        lineItems: 0.87
      }
    }
  });
  
  // Update job progress
  await db.aiJob.update({
    where: { id: aiJob.id },
    data: {
      progressPercentage: 80,
      currentStep: "Extraction Complete"
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 6: GENERATE EMBEDDINGS (Optional)                    │
└─────────────────────────────────────────────────────────────────────────────┘

Embedding Generation (for semantic search):
  
  // Get all document chunks
  const chunks = await db.aiDocumentChunk.findMany({
    where: { aiDocumentIndexId: aiDocIndex.id }
  });
  
  // Generate embeddings for each chunk
  for (const chunk of chunks) {
    
    // Call embedding model (OpenAI ada-002, etc.)
    const embeddingResponse = await callEmbeddingAPI({
      model: "text-embedding-ada-002",
      input: chunk.chunkText
    });
    
    // embeddingResponse: { embedding: [0.012, -0.034, 0.056, ...] }
    // 1536 dimensions for ada-002
    
    // Store embedding
    const embedding = await db.aiEmbedding.create({
      data: {
        id: uuidv7(),
        tenantId: ctx.tenantId,
        createdByActorId: ctx.actorId,
        
        sourceType: "DOCUMENT",
        sourceId: aiDocIndex.id,
        sourceContent: chunk.chunkText,
        sourceMetadata: {
          chunkId: chunk.id,
          pageNumber: chunk.pageNumber,
          chunkNumber: chunk.chunkNumber
        },
        
        embeddingVector: embeddingResponse.embedding,
        vectorDimensions: 1536,
        modelUsed: "text-embedding-ada-002",
        modelVersion: "2",
        
        chunkIndex: chunk.chunkNumber,
        chunkSize: chunk.chunkSize,
        contextBefore: chunk.contextBefore,
        contextAfter: chunk.contextAfter,
        
        searchCount: 0,
        isActive: true,
        needsReindex: false
      }
    });
    
    // Link back to chunk
    await db.aiDocumentChunk.update({
      where: { id: chunk.id },
      data: {
        embeddingId: embedding.id,
        hasEmbedding: true
      }
    });
  }
  
  // Update job progress
  await db.aiJob.update({
    where: { id: aiJob.id },
    data: {
      progressPercentage: 95,
      currentStep: "Embeddings Generated"
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 7: FINALIZE & NOTIFY USER                            │
└─────────────────────────────────────────────────────────────────────────────┘

Finalization:
  
  // Update AIDocumentIndex status
  await db.aiDocumentIndex.update({
    where: { id: aiDocIndex.id },
    data: {
      processingStatus: "COMPLETED",
      processedAt: new Date(),
      processingTimeMs: Date.now() - startTime,
      
      pageCount: pdfImages.length
    }
  });
  
  // Complete AIJob
  await db.aiJob.update({
    where: { id: aiJob.id },
    data: {
      status: "COMPLETED",
      completedAt: new Date(),
      progressPercentage: 100,
      currentStep: "Complete",
      
      itemsProcessed: 1,
      itemsSucceeded: 1,
      itemsFailed: 0,
      
      outputSummary: {
        documentType: classificationResponse.documentType,
        confidence: classificationResponse.confidence,
        pageCount: pdfImages.length,
        extractedFields: Object.keys(extractionResponse).length,
        embeddingsGenerated: chunks.length
      },
      resultMessage: "Document processed successfully"
    }
  });
  
  // Create AIJobArtifact with extracted data (for download)
  const artifactData = {
    documentId: document.id,
    documentName: document.documentName,
    classification: classificationResponse,
    extraction: extractionResponse,
    ocrSummary: {
      totalPages: pdfImages.length,
      totalCharacters: fullDocumentText.length,
      averageConfidence: 0.95
    }
  };
  
  const artifactJSON = JSON.stringify(artifactData, null, 2);
  const artifactKey = `${ctx.tenantId}/ai-artifacts/${aiJob.id}_extraction.json`;
  
  await s3.putObject({
    Bucket: "erp-documents",
    Key: artifactKey,
    Body: Buffer.from(artifactJSON),
    ContentType: "application/json"
  });
  
  await db.aiJobArtifact.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      createdByActorId: ctx.actorId,
      
      aiJobId: aiJob.id,
      
      artifactName: "extraction_result.json",
      artifactType: "JSON",
      description: "Extracted invoice data",
      
      fileUrl: `https://s3.amazonaws.com/erp-documents/${artifactKey}`,
      fileName: "extraction_result.json",
      fileSize: Buffer.from(artifactJSON).length,
      mimeType: "application/json",
      storageProvider: "S3",
      
      contentSummary: "Structured invoice data extracted from PDF",
      recordCount: extractionResponse.lineItems.length,
      metadata: {
        documentType: classificationResponse.documentType
      },
      
      isPublic: false,
      isActive: true
    }
  });
  
  // Send notification to user
  await db.notification.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      createdByActorId: "SYSTEM",
      
      notificationType: "DOCUMENT_PROCESSED",
      recipientType: "INTERNAL",
      recipientActorId: ctx.actorId,
      
      subject: "Document Processed: vendor-invoice.pdf",
      message: `Your document has been processed successfully.
                
                Document Type: ${classificationResponse.documentType}
                Extracted: ${extractionResponse.vendorName} - Invoice #${extractionResponse.invoiceNumber}
                Total Amount: $${extractionResponse.total}
                
                Click to review and approve the extracted data.`,
      
      actionUrl: `/documents/${document.id}/review`,
      actionLabel: "Review Extraction",
      
      metadata: {
        documentId: document.id,
        aiDocumentIndexId: aiDocIndex.id,
        extractionId: extraction.id
      },
      
      status: "PENDING"
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 8: USER REVIEWS & APPROVES                           │
└─────────────────────────────────────────────────────────────────────────────┘

User Workflow:
  
  1. User receives notification
  2. Opens document review page
  3. Sees:
     ┌────────────────────────────────────────────────────────────┐
     │  📄 Document Review: vendor-invoice.pdf                    │
     ├────────────────────────────────────────────────────────────┤
     │                                                            │
     │  Classification: INVOICE (96% confident)                   │
     │                                                            │
     │  Extracted Data:                                           │
     │  ├─ Vendor: ABC Supply Co.                                │
     │  ├─ Invoice #: INV-2025-8842                              │
     │  ├─ Date: 2025-11-15                                      │
     │  ├─ Due Date: 2025-12-15                                  │
     │  ├─ PO Number: PO-2025-0156                               │
     │  └─ Total: $1,583.16                                      │
     │                                                            │
     │  Line Items (2):                                           │
     │  1. 2x4x8 Lumber - 100 @ $8.50 = $850.00                  │
     │  2. Drywall Sheets - 50 @ $12.25 = $612.50               │
     │                                                            │
     │  [✓ Approve & Create Expense] [✏️ Edit] [❌ Reject]        │
     └────────────────────────────────────────────────────────────┘
  
  4. User clicks "Approve & Create Expense"
  5. Backend creates ExpenseReport + ExpenseLines from extracted data
  6. Marks extraction as verified:
     
     await db.aiExtractionResult.update({
       where: { id: extraction.id },
       data: {
         validationStatus: "VALID"
       }
     });
     
     await db.aiClassificationResult.update({
       where: { id: classification.id },
       data: {
         manuallyVerified: true,
         verifiedByActorId: ctx.actorId,
         verifiedAt: new Date()
       }
     });
  
  7. User feedback (improves AI over time):
     
     await db.aiInsightFeedback.create({
       data: {
         id: uuidv7(),
         tenantId: ctx.tenantId,
         actorId: ctx.actorId,
         
         feedbackType: "EXTRACTION_ACCURACY",
         targetType: "AI_EXTRACTION",
         targetId: extraction.id,
         
         rating: 5, // 1-5 stars
         comment: "Perfect extraction, all data correct",
         wasHelpful: true,
         
         metadata: {
           documentType: "INVOICE",
           fieldsCorrect: ["vendorName", "invoiceNumber", "lineItems", "total"],
           fieldsIncorrect: []
         }
       }
     });
```

---

*Due to length constraints, I'll create a continuation for the remaining flows in the next response. The document continues with:*

- Flow 6: Expense Receipt Auto-Processing
- Flow 7: AIPlaybook Multi-Step Workflow Execution
- Flow 8: Proactive Insight Generation (Background Jobs)
- Flow 9: Semantic Search & RAG
- Flow 10: What-If Scenario Analysis
- Security & Permission Enforcement
- Audit Trail & Actor Attribution
- Error Handling & Retry Logic
- Cost Tracking & Rate Limiting

[View AI Flow Documentation Part 1](computer:///mnt/user-data/outputs/AI_FLOW_v1_0.md)

I'll create a continuation file now.

