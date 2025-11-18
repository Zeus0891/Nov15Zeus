# 🔄 AI Module Suite - Operational Flow Documentation (Part 2)

**Continuation of AI_FLOW_v1_0.md**

---

## 6. FLOW: Expense Receipt Auto-Processing

### Overview
Streamlined flow showing how uploaded receipts are automatically processed and converted into expense line items with minimal user interaction.

### Flow Diagram (Simplified)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    COMPLETE RECEIPT PROCESSING FLOW                          │
└─────────────────────────────────────────────────────────────────────────────┘

Employee uploads receipt photo from mobile app
     │
     ▼
Document Upload (same as Flow 5, Step 1-2)
     │
     ▼
AIJob Queued → Background Worker

WORKER EXECUTION:
  
  STEP 1: OCR Processing
    ├─── Extract text from receipt image
    ├─── Identify: Merchant, Date, Items, Total
    └─── Create AIOCRResult record
  
  STEP 2: Classification
    ├─── AI determines: RECEIPT (95% confidence)
    └─── Create AIClassificationResult
  
  STEP 3: Structured Extraction
    ├─── Extract:
    │    {
    │      "merchant": "Home Depot",
    │      "date": "2025-11-15",
    │      "total": 89.47,
    │      "tax": 7.38,
    │      "items": [
    │        { "description": "Paint - Interior", "price": 29.99 },
    │        { "description": "Brushes - 3pk", "price": 15.99 },
    │        { "description": "Primer", "price": 28.99 }
    │      ],
    │      "paymentMethod": "VISA *1234",
    │      "category": "MATERIALS"
    │    }
    └─── Create AIExtractionResult
  
  STEP 4: Auto-Create Expense (if policy allows)
    ├─── Check: Tenant setting "autoCreateExpenses" = true
    ├─── Check: Amount < tenant's "autoApprovalLimit" ($500)
    ├─── Create ExpenseReport:
    │    └─── status: "DRAFT"
    ├─── Create ExpenseLine for each item
    └─── Link Document to ExpenseReport
  
  STEP 5: Category Classification (AI)
    ├─── AI analyzes items: ["Paint", "Brushes", "Primer"]
    ├─── AI suggests: category = "MATERIALS", subcategory = "PAINT"
    ├─── Apply to ExpenseLines
    └─── If project mentioned in receipt: link to project
  
  STEP 6: Compliance Check
    ├─── Check expense policy:
    │    ├─── Requires receipt? ✓ Have it
    │    ├─── Within policy limits? ✓ $89.47 < $500
    │    ├─── Merchant approved? ✓ Home Depot in approved list
    │    └─── Category allowed? ✓ MATERIALS allowed for employee role
    ├─── If all pass: Mark as "READY_FOR_APPROVAL"
    └─── If violations: Mark as "NEEDS_REVIEW"
  
  STEP 7: Notify Employee
    └─── Push notification: "Receipt processed! Review and submit."

Employee Reviews & Submits:
  ├─── Mobile app shows expense with pre-filled data
  ├─── Employee adds: Project linkage, notes
  ├─── Employee submits for approval
  └─── Expense enters approval workflow

TIME SAVINGS:
  Manual entry: ~10 minutes
  AI processing: ~30 seconds
  Employee review: ~1 minute
  Total: 90% time reduction
```

---

## 7. FLOW: AIPlaybook Multi-Step Workflow Execution

### Overview
AIPlaybooks orchestrate complex multi-step workflows that combine AI actions with business logic, approvals, and error handling.

### Example Playbook: "Complete Project Financial Analysis"

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              AIPLAYBOOK: Complete Project Financial Analysis                 │
└─────────────────────────────────────────────────────────────────────────────┘

Playbook Configuration:
  playbookName: "Complete Project Financial Analysis"
  triggerType: SCHEDULED
  executionMode: SEQUENTIAL
  rollbackOnFailure: true

Trigger: Every Monday at 6:00 AM for all active projects

┌─────────────────────────────────────────────────────────────────────────────┐
│                    PLAYBOOK EXECUTION FLOW                                   │
└─────────────────────────────────────────────────────────────────────────────┘

START PLAYBOOK → Create AIPlaybookRun record

STEP 1: Load Project Financial Data
  Type: BUSINESS_LOGIC
  ├─── Query: All projects with status = "ACTIVE"
  ├─── Load: Budget, Actual Costs, Invoices
  ├─── Output: projectFinancialData[]
  └─── Status: SUCCESS → Continue to Step 2

STEP 2: Calculate Cost Metrics (AI-Assisted)
  Type: AI_ACTION
  actionCode: "project.calculate_financial_metrics"
  ├─── Input: projectFinancialData from Step 1
  ├─── AI Processing:
  │    └─── For each project:
  │         ├─── Calculate profit margin
  │         ├─── Calculate budget variance
  │         ├─── Calculate schedule variance
  │         └─── Identify cost anomalies
  ├─── Output: financialMetrics[]
  └─── Status: SUCCESS → Continue to Step 3

STEP 3: Identify At-Risk Projects (AI)
  Type: AI_ACTION
  actionCode: "project.identify_risks"
  ├─── Input: financialMetrics from Step 2
  ├─── AI Analysis:
  │    └─── Criteria:
  │         ├─── Profit margin < 5% → CRITICAL
  │         ├─── Budget overrun > 15% → HIGH RISK
  │         ├─── Schedule delay > 2 weeks → MEDIUM RISK
  ├─── Output: atRiskProjects[] with risk scores
  └─── Status: SUCCESS → Continue to Step 4

STEP 4: Generate Insights for At-Risk Projects
  Type: AI_ACTION
  actionCode: "project.generate_insights"
  ├─── Input: atRiskProjects from Step 3
  ├─── Loop: For each at-risk project
  │    └─── Execute AIAction: "project.deep_analysis"
  │         ├─── Create AIInsight record
  │         ├─── Create AIPrediction (completion date)
  │         ├─── Create AIRecommendation (corrective actions)
  │         └─── Create AIAnomaly (cost overruns)
  ├─── Output: insights[] (25 insights generated)
  └─── Status: SUCCESS → Continue to Step 5

STEP 5: Generate Executive Summary (AI)
  Type: AI_ACTION
  actionCode: "project.generate_summary_report"
  ├─── Input: All insights from Step 4
  ├─── AI Report Generation:
  │    └─── Create comprehensive PDF report:
  │         ├─── Executive Summary
  │         ├─── Project-by-Project Analysis
  │         ├─── Key Risks & Recommendations
  │         └─── Financial Projections
  ├─── Output: reportPDF
  └─── Status: SUCCESS → Continue to Step 6

STEP 6: Send Report to Leadership (CONDITIONAL)
  Type: BUSINESS_LOGIC (with condition)
  conditionExpression: "atRiskProjects.length > 0"
  ├─── Condition: TRUE (we have at-risk projects)
  ├─── Action: Send email to executives
  │    ├─── To: CFO, COO, CEO
  │    ├─── Subject: "Weekly Project Financial Analysis - 5 At-Risk Projects"
  │    ├─── Body: Executive summary + link to full report
  │    └─── Attachment: reportPDF
  └─── Status: SUCCESS → Continue to Step 7

STEP 7: Create Action Items for Project Managers
  Type: BUSINESS_LOGIC
  ├─── For each at-risk project:
  │    └─── Create Task for Project Manager:
  │         ├─── Title: "Review Financial Issues - Project #{number}"
  │         ├─── Description: Link to AIInsight
  │         ├─── DueDate: Today + 2 days
  │         ├─── Priority: HIGH
  │         └─── Assignee: Project Manager
  ├─── Output: tasks[] (5 tasks created)
  └─── Status: SUCCESS → Continue to Step 8

STEP 8: Update Project Risk Scores
  Type: BUSINESS_LOGIC
  ├─── Update each project record:
  │    └─── project.riskScore = calculated from insights
  │         project.riskLevel = HIGH/MEDIUM/LOW
  │         project.lastRiskAssessment = now()
  └─── Status: SUCCESS → PLAYBOOK COMPLETE

END PLAYBOOK → Update AIPlaybookRun: status = "COMPLETED"

┌─────────────────────────────────────────────────────────────────────────────┐
│                    PLAYBOOK EXECUTION RESULTS                                │
└─────────────────────────────────────────────────────────────────────────────┘

Execution Summary:
  ├─── Total Duration: 4 minutes 32 seconds
  ├─── Steps Executed: 8/8
  ├─── Steps Succeeded: 8
  ├─── Steps Failed: 0
  ├─── Projects Analyzed: 42
  ├─── At-Risk Projects Identified: 5
  ├─── Insights Generated: 25
  ├─── Recommendations Created: 35
  ├─── Tasks Created: 5
  ├─── Emails Sent: 3 (to executives)
  ├─── AI Tokens Consumed: 45,000
  └─── Total Cost: $1.35

Business Impact:
  ├─── Manual analysis time saved: ~6 hours
  ├─── Risks identified early: 5 projects
  ├─── Potential loss prevention: $45,000 (est.)
  └─── Leadership informed: same-day insights
```

### Error Handling in Playbooks

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ERROR HANDLING SCENARIOS                                  │
└─────────────────────────────────────────────────────────────────────────────┘

SCENARIO 1: AI API Rate Limit Hit (Step 2)
  ├─── Error: 429 Too Many Requests from OpenAI
  ├─── Retry Policy: Exponential backoff
  │    ├─── Retry 1: Wait 5 seconds → RETRY
  │    ├─── Retry 2: Wait 10 seconds → RETRY
  │    └─── Retry 3: Wait 20 seconds → SUCCESS
  └─── Result: Step continues successfully

SCENARIO 2: Data Validation Failure (Step 3)
  ├─── Error: Financial data missing for Project #23
  ├─── Action: Skip project, log warning
  ├─── Continue: Process remaining projects
  └─── Result: 41/42 projects analyzed (95% success)

SCENARIO 3: Critical Step Failure (Step 5)
  ├─── Error: Report generation crashed (out of memory)
  ├─── Playbook Setting: rollbackOnFailure = true
  ├─── Action: ROLLBACK
  │    ├─── Delete insights created in Step 4
  │    ├─── Restore project states
  │    └─── Mark playbook as FAILED
  ├─── Notification: Alert DevOps team
  └─── Result: Clean state, ready for retry

SCENARIO 4: Timeout (Step 4 taking too long)
  ├─── Error: Step execution > maxExecutionTime (10 minutes)
  ├─── Action: Cancel remaining processing
  ├─── Save partial results: Insights for 15/25 projects
  ├─── Mark step as TIMEOUT
  └─── Result: Partial success, manual review required
```

---

## 8. FLOW: Proactive Insight Generation (Background Jobs)

### Overview
Background jobs run on schedules to proactively analyze data and generate insights before users even ask.

### Example: Daily Financial Health Check

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SCHEDULED JOB: Daily Financial Health Check               │
└─────────────────────────────────────────────────────────────────────────────┘

Trigger: Cron schedule - Every day at 5:00 AM
Job Type: INSIGHT_GENERATION
Priority: 8 (high priority)

┌─────────────────────────────────────────────────────────────────────────────┐
│                    JOB EXECUTION FLOW                                        │
└─────────────────────────────────────────────────────────────────────────────┘

Job Starts → Update status: RUNNING

PHASE 1: Data Collection (5 minutes)
  ├─── Load all tenants with active subscription
  ├─── For each tenant:
  │    └─── Collect:
  │         ├─── All invoices from last 30 days
  │         ├─── All projects (active + recently completed)
  │         ├─── All expenses from last 30 days
  │         ├─── Payment history
  │         └─── Bank account balances
  └─── Result: financialData[] for 150 tenants

PHASE 2: AI Analysis (15 minutes)
  ├─── Process tenants in batches of 10
  ├─── For each tenant:
  │    
  │    ANALYSIS 1: Invoice Aging
  │      ├─── AI identifies overdue invoices
  │      ├─── Calculates: Days Sales Outstanding (DSO)
  │      ├─── Predicts: Which invoices likely to be paid late
  │      └─── Creates: AIInsight if DSO > target
  │    
  │    ANALYSIS 2: Cash Flow Projection
  │      ├─── AI predicts cash flow for next 30 days
  │      ├─── Factors: Upcoming invoices, due expenses, payment patterns
  │      ├─── Creates: AIForecast
  │      └─── Creates: AIInsight if negative cash flow predicted
  │    
  │    ANALYSIS 3: Profit Margin Trend
  │      ├─── AI analyzes profit margins over last 6 months
  │      ├─── Detects declining trend
  │      ├─── Creates: AITrend
  │      └─── Creates: AIInsight if margin declining
  │    
  │    ANALYSIS 4: Expense Anomalies
  │      ├─── AI identifies unusual expenses
  │      ├─── Compares to historical patterns
  │      ├─── Creates: AIAnomaly for outliers
  │      └─── Creates: AIInsight if potential fraud detected
  │    
  │    ANALYSIS 5: Revenue Forecast
  │      ├─── AI predicts next month's revenue
  │      ├─── Based on: Pipeline, historical close rates, seasonality
  │      ├─── Creates: AIPrediction
  │      └─── Creates: AIInsight if forecast below target
  │    
  └─── Result: 750 insights generated across 150 tenants

PHASE 3: Prioritization & Filtering (2 minutes)
  ├─── Filter out low-confidence insights (<0.7)
  ├─── Filter out duplicate insights
  ├─── Rank insights by:
  │    ├─── Severity (CRITICAL > HIGH > MEDIUM)
  │    ├─── Financial impact (larger $ impact = higher priority)
  │    └─── Urgency (time-sensitive issues first)
  └─── Result: 320 high-priority insights

PHASE 4: Notification Generation (3 minutes)
  ├─── Group insights by tenant
  ├─── For each tenant:
  │    └─── Determine notification strategy:
  │         ├─── CRITICAL insights → Immediate email + SMS
  │         ├─── HIGH insights → Email + in-app notification
  │         ├─── MEDIUM insights → In-app notification only
  │         └─── LOW insights → Daily digest only
  ├─── Create notification records
  └─── Queue for delivery

PHASE 5: Dashboard Updates (1 minute)
  ├─── Update dashboard metrics for each tenant
  ├─── Refresh: Financial health score, risk indicators
  └─── Cache results for fast dashboard loading

Job Completes → Update status: COMPLETED

┌─────────────────────────────────────────────────────────────────────────────┐
│                    JOB RESULTS & IMPACT                                      │
└─────────────────────────────────────────────────────────────────────────────┘

Execution Summary:
  ├─── Total Duration: 26 minutes
  ├─── Tenants Analyzed: 150
  ├─── Insights Generated: 750
  ├─── High-Priority Insights: 320
  ├─── Critical Alerts: 12
  ├─── Notifications Sent: 485
  ├─── AI Tokens Consumed: 2.3M
  └─── Total Cost: $69.00

Business Value:
  ├─── Early Warning: 12 critical financial issues detected
  ├─── Cash Flow Warnings: 8 companies alerted to negative cash flow
  ├─── Fraud Detection: 2 potential fraudulent expenses flagged
  ├─── Revenue at Risk: $850K identified (projects with declining margins)
  └─── Proactive Value: Issues surfaced before they became crises

Example Critical Alert:
  ┌────────────────────────────────────────────────────────────┐
  │  🚨 CRITICAL: Negative Cash Flow Predicted                 │
  ├────────────────────────────────────────────────────────────┤
  │  Company: Smith Construction LLC                           │
  │                                                            │
  │  Your cash flow is projected to go negative in 12 days:   │
  │                                                            │
  │  Current Balance: $45,000                                  │
  │  Upcoming Expenses: $78,000                                │
  │  Expected Income: $32,000                                  │
  │  Projected Balance: -$1,000 (Nov 29)                      │
  │                                                            │
  │  Recommendations:                                          │
  │  1. Accelerate collection on Invoice #342 ($25K)          │
  │  2. Delay payment to Vendor XYZ ($15K)                    │
  │  3. Consider short-term credit line                       │
  │                                                            │
  │  [View Full Analysis] [Take Action]                       │
  └────────────────────────────────────────────────────────────┘
```

---

## 9. FLOW: Semantic Search & RAG (Retrieval Augmented Generation)

### Overview
AI-powered semantic search allows users to find information using natural language, with context-aware responses generated using RAG.

### Example: "What did we discuss about weather delays on Project #34?"

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SEMANTIC SEARCH + RAG FLOW                                │
└─────────────────────────────────────────────────────────────────────────────┘

User Query: "What did we discuss about weather delays on Project #34?"
     │
     ▼
POST /api/ai/search
     {
       "query": "What did we discuss about weather delays on Project #34?",
       "context": {
         "module": "PROJECT",
         "resourceId": "34"
       }
     }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: QUERY EMBEDDING GENERATION                        │
└─────────────────────────────────────────────────────────────────────────────┘

Generate Query Embedding:
  const queryEmbedding = await generateEmbedding({
    text: "What did we discuss about weather delays on Project #34?",
    model: "text-embedding-ada-002"
  });
  
  // Returns: vector of 1536 dimensions
  // queryEmbedding = [0.012, -0.034, 0.056, ...]

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: VECTOR SIMILARITY SEARCH                          │
└─────────────────────────────────────────────────────────────────────────────┘

Search Embeddings Database:
  
  // PostgreSQL with pgvector extension
  const semanticResults = await db.$queryRaw`
    SELECT 
      e.id,
      e.sourceType,
      e.sourceId,
      e.sourceContent,
      e.sourceMetadata,
      1 - (e.embeddingVector <=> ${queryEmbedding}::vector) as similarity
    FROM AIEmbedding e
    WHERE e.tenantId = ${ctx.tenantId}
      AND e.isActive = true
      AND e.sourceType IN ('DOCUMENT', 'NOTE', 'MESSAGE', 'TASK', 'PROJECT')
    ORDER BY e.embeddingVector <=> ${queryEmbedding}::vector
    LIMIT 10
  `;
  
  // Results (top 5 by similarity):
  // [
  //   {
  //     sourceType: "PROJECT_NOTE",
  //     sourceContent: "Weather delay on Nov 12-14. Rain prevented exterior work 
  //                     for 3 days. Rescheduled drywall crew for next week.",
  //     similarity: 0.89
  //   },
  //   {
  //     sourceType: "WEATHER_IMPACT_EVENT",
  //     sourceContent: "Heavy rain on Nov 12-14 caused 3-day delay. Estimated 
  //                     cost impact: $2,400 in crew downtime.",
  //     similarity: 0.87
  //   },
  //   {
  //     sourceType: "MESSAGE",
  //     sourceContent: "Client called about weather delays. Explained situation 
  //                     and revised timeline. Client understanding.",
  //     similarity: 0.82
  //   },
  //   {
  //     sourceType: "TASK_COMMENT",
  //     sourceContent: "Drywall task delayed due to weather. New start date: Nov 16",
  //     similarity: 0.78
  //   },
  //   {
  //     sourceType: "DOCUMENT_CHUNK",
  //     sourceContent: "Email from weather service warning of storm approaching. 
  //                     Recommend moving equipment under cover.",
  //     similarity: 0.75
  //   }
  // ]

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: LOAD FULL CONTEXT FOR TOP RESULTS                │
└─────────────────────────────────────────────────────────────────────────────┘

Hydrate Results:
  const fullContextResults = await Promise.all(
    semanticResults.map(async (result) => {
      switch (result.sourceType) {
        case "PROJECT_NOTE":
          return await db.projectNote.findUnique({
            where: { id: result.sourceId },
            include: { project: true, createdByActor: true }
          });
        
        case "WEATHER_IMPACT_EVENT":
          return await db.weatherImpactEvent.findUnique({
            where: { id: result.sourceId },
            include: { project: true, weatherCondition: true }
          });
        
        case "MESSAGE":
          return await db.message.findUnique({
            where: { id: result.sourceId },
            include: { thread: true, createdByActor: true }
          });
        
        // ... etc
      }
    })
  );

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: RAG - CONTEXT-AWARE RESPONSE GENERATION           │
└─────────────────────────────────────────────────────────────────────────────┘

Build RAG Prompt:
  const ragContext = fullContextResults.map(r => ({
    type: r.sourceType,
    date: r.createdAt,
    author: r.createdByActor?.displayName,
    content: r.sourceContent
  }));
  
  const ragPrompt = {
    "model": "gpt-4-turbo",
    "messages": [
      {
        "role": "system",
        "content": `You are an AI assistant helping users find information in 
                    their ERP system. Use the provided context to answer questions 
                    accurately. Always cite which source you're referencing.`
      },
      {
        "role": "user",
        "content": `User Question: "${userQuery}"
                    
                    Context from database:
                    ${JSON.stringify(ragContext, null, 2)}
                    
                    Please answer the question using the context provided. 
                    Be specific and cite sources.`
      }
    ],
    "temperature": 0.3
  };
  
  const aiResponse = await callLLM(ragPrompt);

AI Generated Response:
  "Based on your project records, there were several weather-related discussions 
   about Project #34:
   
   **Weather Delay Event (Nov 12-14):**
   Heavy rain prevented exterior work for 3 days. The weather impact assessment 
   estimated a cost impact of $2,400 in crew downtime.
   
   **Project Manager's Note (Nov 14):**
   The team rescheduled the drywall crew for the following week due to the delay. 
   This pushed back the overall timeline by approximately 3 days.
   
   **Client Communication (Nov 15):**
   You spoke with the client about the weather delays. According to the message 
   thread, you explained the situation and provided a revised timeline. The client 
   was understanding of the circumstances.
   
   **Task Updates:**
   The drywall task was specifically delayed, with a new start date set for 
   November 16th.
   
   In summary: A 3-day weather delay occurred from November 12-14 due to heavy 
   rain, causing approximately $2,400 in cost impact and requiring timeline 
   adjustments. The client was informed and was understanding.
   
   Would you like me to pull up the detailed weather impact report or the client 
   communication thread?"

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 5: LOG SEARCH & UPDATE EMBEDDINGS                    │
└─────────────────────────────────────────────────────────────────────────────┘

Track Search Usage:
  // Update search count on retrieved embeddings
  await db.aiEmbedding.updateMany({
    where: {
      id: { in: semanticResults.map(r => r.id) }
    },
    data: {
      searchCount: { increment: 1 },
      lastSearchedAt: new Date()
    }
  });
  
  // Log search for analytics
  await db.aiSearchLog.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      actorId: ctx.actorId,
      
      searchQuery: userQuery,
      searchType: "SEMANTIC",
      resultsCount: semanticResults.length,
      topSimilarityScore: semanticResults[0].similarity,
      
      executionTimeMs: searchDuration,
      tokensUsed: ragPrompt.tokens,
      costAmount: 0.002 // embedding + LLM call
    }
  });
```

---

## 10. FLOW: What-If Scenario Analysis

### Overview
AI-powered scenario modeling allows users to simulate different business decisions and see projected outcomes.

### Example: "What if I add 2 more crew members to Project #34?"

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    WHAT-IF SCENARIO ANALYSIS FLOW                            │
└─────────────────────────────────────────────────────────────────────────────┘

User Query: "What if I add 2 more crew members to Project #34?"
     │
     ▼
POST /api/ai/what-if
     {
       "projectId": "34",
       "scenarioName": "Add 2 Crew Members",
       "changes": [
         {
           "variable": "laborForce",
           "currentValue": 5,
           "newValue": 7
         }
       ]
     }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: LOAD BASELINE PROJECT DATA                        │
└─────────────────────────────────────────────────────────────────────────────┘

Load Current State:
  const project = await db.project.findUnique({
    where: { id: projectId },
    include: {
      projectTasks: true,
      projectSchedule: true,
      projectBudget: true,
      projectTeamMembers: true
    }
  });
  
  const baselineMetrics = {
    currentCrewSize: 5,
    currentDailyLaborCost: 2000, // $400/person/day * 5
    estimatedCompletionDate: "2026-01-27",
    totalBudget: 75000,
    spentToDate: 35000,
    remainingBudget: 40000,
    percentComplete: 48,
    daysRemaining: 42
  };

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: AI SCENARIO SIMULATION                            │
└─────────────────────────────────────────────────────────────────────────────┘

AI Simulation:
  const simulationPrompt = {
    "model": "gpt-4-turbo",
    "messages": [
      {
        "role": "system",
        "content": `You are a construction project management expert. Simulate 
                    the impact of project changes. Use industry-standard 
                    productivity metrics and provide realistic projections.`
      },
      {
        "role": "user",
        "content": `Simulate this scenario:
                    
                    Current State:
                    ${JSON.stringify(baselineMetrics, null, 2)}
                    
                    Proposed Change:
                    Add 2 additional crew members (5 → 7)
                    
                    Calculate:
                    1. New completion date (consider: learning curve, coordination overhead)
                    2. Additional labor cost
                    3. Impact on budget
                    4. Overall project savings/losses
                    5. Risk factors
                    
                    Assumptions:
                    - New crew members at $400/day each
                    - 10% productivity loss for first 3 days (onboarding)
                    - 15% coordination overhead with larger crew
                    - Standard construction productivity rates
                    
                    Provide realistic projections with ranges (best/likely/worst case).`
      }
    ],
    "temperature": 0.2
  };
  
  const aiSimulation = await callLLM(simulationPrompt);

AI Simulation Results:
  {
    "projectedOutcome": {
      "completionDate": {
        "best": "2026-01-15",      // -12 days
        "likely": "2026-01-19",     // -8 days
        "worst": "2026-01-24"       // -3 days
      },
      "timeReduction": {
        "best": 12,
        "likely": 8,
        "worst": 3
      }
    },
    
    "costImpact": {
      "additionalLaborCost": {
        "best": 8400,    // 21 days * 2 crew * $400 (best case: more efficient)
        "likely": 11200, // 28 days * 2 crew * $400
        "worst": 13600   // 34 days * 2 crew * $400 (worst case: less efficient)
      },
      "coordinationOverhead": 1500, // Additional PM time
      "totalAdditionalCost": {
        "best": 9900,
        "likely": 12700,
        "worst": 15100
      }
    },
    
    "budgetImpact": {
      "currentRemainingBudget": 40000,
      "projectedSpend": {
        "withoutChange": 41000,  // Would exceed budget by $1K
        "withChange": 52700      // Additional $12.7K
      },
      "budgetStatus": "OVER_BUDGET",
      "overageAmount": 12700
    },
    
    "netImpact": {
      "timeValue": {
        "description": "Each day saved is worth ~$500 in overhead + client goodwill",
        "daysaved": 8,
        "value": 4000
      },
      "additionalCost": 12700,
      "netCost": -8700, // Negative = net cost
      "worthIt": false,
      "reasoning": "Adding crew will cost $8,700 more than time savings value. 
                    Only worth it if client satisfaction or contractual deadline 
                    is critical."
    },
    
    "riskFactors": [
      {
        "risk": "Coordination Complexity",
        "probability": 0.7,
        "impact": "15% productivity loss with 7-person crew",
        "mitigation": "Assign dedicated crew lead for coordination"
      },
      {
        "risk": "Budget Overrun",
        "probability": 0.9,
        "impact": "$12.7K additional cost",
        "mitigation": "Negotiate change order with client or absorb cost"
      },
      {
        "risk": "Quality Issues",
        "probability": 0.3,
        "impact": "Rushed work may reduce quality",
        "mitigation": "Maintain quality checkpoints"
      }
    ],
    
    "recommendations": [
      {
        "priority": 1,
        "recommendation": "DON'T add crew unless client will cover additional cost",
        "reasoning": "Financial analysis shows $8.7K net loss"
      },
      {
        "priority": 2,
        "recommendation": "If must accelerate: Add 1 crew member instead of 2",
        "reasoning": "1 crew member = $6,300 cost, saves 4-5 days, better ROI"
      },
      {
        "priority": 3,
        "recommendation": "Negotiate change order to cover acceleration costs",
        "reasoning": "Client may value earlier completion at $15K premium"
      }
    ]
  }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: STORE SCENARIO ANALYSIS                           │
└─────────────────────────────────────────────────────────────────────────────┘

Save What-If Analysis:
  const whatIfRun = await db.aiWhatIfRun.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      createdByActorId: ctx.actorId,
      
      scenarioName: "Add 2 Crew Members",
      scenarioDescription: "Evaluate impact of adding 2 crew members to 
                             accelerate project completion",
      
      baseResourceType: "PROJECT",
      baseResourceId: project.id,
      baselineMetrics: baselineMetrics,
      
      changedVariables: [
        {
          variable: "crewSize",
          from: 5,
          to: 7,
          type: "LABOR"
        }
      ],
      assumptionsList: [
        "New crew at $400/day",
        "10% productivity loss first 3 days",
        "15% coordination overhead"
      ],
      
      projectedOutcome: aiSimulation.projectedOutcome,
      impactAnalysis: aiSimulation.netImpact,
      costImpact: aiSimulation.costImpact,
      scheduleImpact: aiSimulation.timeReduction,
      riskImpact: aiSimulation.riskFactors,
      
      aiModelId: aiModel.id,
      simulationConfidence: 0.78,
      
      metadata: {
        recommendations: aiSimulation.recommendations
      }
    }
  });
  
  // Create AIInsight from analysis
  await db.aiInsight.create({
    data: {
      id: uuidv7(),
      tenantId: ctx.tenantId,
      createdByActorId: ctx.actorId,
      
      insightType: "OPERATIONAL",
      insightCategory: "SCENARIO_ANALYSIS",
      insightTitle: "What-If: Add 2 Crew Members - Not Recommended",
      
      sourceType: "PROJECT",
      sourceId: project.id,
      
      insightText: aiSimulation.recommendations[0].recommendation,
      insightData: aiSimulation,
      
      keyMetrics: {
        additionalCost: 12700,
        timeSavings: 8,
        netImpact: -8700,
        worthIt: false
      },
      
      severity: "MEDIUM",
      priority: 6,
      requiresAction: false
    }
  });

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: PRESENT RESULTS TO USER                           │
└─────────────────────────────────────────────────────────────────────────────┘

Frontend Display:
  ┌────────────────────────────────────────────────────────────┐
  │  🎯 What-If Analysis: Add 2 Crew Members                   │
  ├────────────────────────────────────────────────────────────┤
  │                                                            │
  │  ⏱️  TIME IMPACT                                            │
  │  Current Completion: Jan 27, 2026                          │
  │  New Completion: Jan 19, 2026 (likely)                    │
  │  Time Saved: 8 days                                        │
  │                                                            │
  │  💰 COST IMPACT                                             │
  │  Additional Labor: $11,200                                 │
  │  Coordination Overhead: $1,500                             │
  │  Total Additional Cost: $12,700                            │
  │                                                            │
  │  📊 NET ANALYSIS                                            │
  │  Time Value: $4,000 (8 days × $500/day)                   │
  │  Additional Cost: $12,700                                  │
  │  Net Result: -$8,700 (net loss)                           │
  │                                                            │
  │  ⚠️  RISKS                                                  │
  │  • Budget will exceed by $12.7K (70% confidence)          │
  │  • Coordination complexity increases (15% productivity loss) │
  │  • Quality may suffer with rushed work (30% risk)         │
  │                                                            │
  │  ✅ RECOMMENDATION: NOT RECOMMENDED                         │
  │  Financial analysis shows this will cost more than        │
  │  the time savings are worth. Consider:                    │
  │  1. Add only 1 crew member (better ROI)                   │
  │  2. Negotiate change order with client to cover cost      │
  │  3. Accept current timeline                               │
  │                                                            │
  │  [Run Different Scenario] [View Details] [Dismiss]        │
  └────────────────────────────────────────────────────────────┘

User Can Explore:
  ├─── "What if I add only 1 crew member?"
  ├─── "What if material costs increase 10%?"
  ├─── "What if client approves change order for $15K?"
  └─── "What if we work weekends for 2 weeks?"
```

---

## 11. SECURITY & PERMISSION ENFORCEMENT

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    MULTI-LAYER SECURITY ARCHITECTURE                         │
└─────────────────────────────────────────────────────────────────────────────┘

LAYER 1: API GATEWAY
  ├─── Authentication: Bearer token validation
  ├─── Rate Limiting: 100 requests/hour per user
  ├─── DDoS Protection: CloudFlare/AWS WAF
  └─── IP Whitelist: Optional per tenant

LAYER 2: PERMISSION GATES
  ├─── AI Feature Access
  │    └─── requirePermission(ctx, "ai:agent:use")
  │         └─── Checks: RolePermission → Permission: "ai:agent:use"
  │    
  ├─── Business Operation Permissions
  │    └─── requirePermission(ctx, "estimate:create")
  │         └─── Each AIAction specifies requiredPermission
  │    
  ├─── Data Access Permissions
  │    └─── requirePermission(ctx, "project:read")
  │         └─── Before loading project data for AI analysis
  │    
  └─── Admin Permissions
       └─── requirePermission(ctx, "ai:model:configure")
            └─── For configuring AI models, prompts

LAYER 3: ROW-LEVEL SECURITY (RLS)
  ├─── Automatic Tenant Isolation
  │    └─── ALL queries automatically filtered by tenantId
  │         Example: WHERE tenantId = ctx.tenantId
  │    
  ├─── RLS Wrapper Pattern
  │    └─── await withRLS(ctx, async (db) => {
  │             // All DB operations here enforce RLS
  │         });
  │    
  └─── Prevents: Cross-tenant data leakage
       └─── Even if SQL injection, RLS prevents access to other tenants

LAYER 4: ACTOR ATTRIBUTION
  ├─── Every AI Operation Tracked
  │    ├─── AIActionRun.actorId = ctx.actorId
  │    ├─── AIActionRun.memberId = ctx.memberId
  │    └─── AIActionRun.sessionId = ctx.sessionId
  │    
  ├─── Every Entity Created by AI
  │    ├─── Estimate.createdByActorId = ctx.actorId
  │    ├─── Invoice.createdByActorId = ctx.actorId
  │    └─── Full 1:1:1 traceability
  │    
  └─── Audit Trail
       └─── Who ran which AI action, when, and what was created

LAYER 5: DATA ENCRYPTION
  ├─── API Keys (at rest)
  │    └─── AIModel.apiKeyEncrypted (AES-256)
  │    
  ├─── Sensitive Extractions
  │    └─── AIExtractionResult with PII (encrypted)
  │    
  └─── TLS in Transit
       └─── All API calls over HTTPS

LAYER 6: AI-SPECIFIC SAFEGUARDS
  ├─── Prompt Injection Prevention
  │    ├─── Sanitize user input
  │    ├─── Separate system prompt from user content
  │    └─── No raw user input in system prompts
  │    
  ├─── Output Validation
  │    ├─── Validate AI responses before execution
  │    ├─── Reject outputs that contain SQL, scripts
  │    └─── Confidence thresholds (reject <0.7)
  │    
  ├─── Resource Limits
  │    ├─── Max tokens per request: 8,000
  │    ├─── Max requests per hour: 100/user
  │    └─── Max concurrent AI jobs: 5/tenant
  │    
  └─── Human-in-the-Loop
       └─── High-impact operations require approval
            └─── requiresApproval flag on AIAction

┌─────────────────────────────────────────────────────────────────────────────┐
│                    PERMISSION DECISION TREE                                  │
└─────────────────────────────────────────────────────────────────────────────┘

User requests AI operation
  │
  ├─► Check: Is user authenticated?
  │    └─► NO → 401 Unauthorized
  │
  ├─► Check: Does tenant have AI features enabled?
  │    └─► NO → 403 Forbidden: "AI features not enabled"
  │
  ├─► Check: Does user have "ai:agent:use" permission?
  │    └─► NO → 403 Forbidden: "No permission to use AI"
  │
  ├─► Check: Does AIAction require specific permission?
  │    └─► YES → Check: Does user have that permission?
  │         └─► NO → 403 Forbidden: "No permission for this action"
  │
  ├─► Check: Does operation access data?
  │    └─► YES → Check: Does user have read permission for that data?
  │         └─► NO → 403 Forbidden: "No access to this data"
  │
  ├─► Check: Does operation modify data?
  │    └─► YES → Check: Does user have write permission?
  │         └─► NO → 403 Forbidden: "No permission to modify"
  │
  ├─► Check: Is tenant within usage limits?
  │    └─► NO → 429 Too Many Requests: "Monthly AI limit exceeded"
  │
  └─► ✅ ALLOW → Execute with RLS + Actor attribution
```

---

## 12. AUDIT TRAIL & ACTOR ATTRIBUTION

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    COMPLETE AUDIT TRAIL ARCHITECTURE                         │
└─────────────────────────────────────────────────────────────────────────────┘

LEVEL 1: AI OPERATION AUDIT (AIActionRun)
  Every AI action execution is logged:
  
  AIActionRun Record Contains:
    ├─── Who: actorId, memberId, sessionId, ipAddress
    ├─── What: aiActionId, actionCode, operation performed
    ├─── When: startedAt, completedAt, durationMs
    ├─── Input: inputPrompt, inputParameters, inputTokenCount
    ├─── Processing: aiModelId, promptTemplateId, temperature
    ├─── Output: outputText, outputStructured, outputTokenCount
    ├─── Result: executionStatus, businessOperationStatus
    ├─── Target: targetResourceType, targetResourceId
    ├─── Cost: costAmount, tokensCharged
    └─── Error: errorCode, errorMessage (if failed)
  
  Queryable:
    ├─── "Show all AI operations by John Smith"
    ├─── "Show all failed AI operations in last 7 days"
    ├─── "Show AI cost by user this month"
    └─── "Show what AI created Estimate #42"

LEVEL 2: BUSINESS ENTITY AUDIT
  Every entity created/modified by AI tracks attribution:
  
  Estimate (created by AI):
    ├─── createdByActorId → Actor
    ├─── metadata: { createdBy: "AI_AGENT", aiRequestId: "{uuid}" }
    └─── EstimateHistoryEvent:
         └─── eventType: "CREATED"
              eventDescription: "Created by AI Agent"
              changesSummary: { aiActionRunId: "{uuid}" }
  
  Invoice (analyzed by AI):
    └─── InvoiceHistoryEvent:
         └─── eventType: "AI_ANALYSIS"
              eventDescription: "Profit margin analysis performed"
              changesSummary: { aiInsightId: "{uuid}" }

LEVEL 3: ACCESS AUDIT (Optional - High Security Tenants)
  AccessAuditEvent logs:
    ├─── Every API call
    ├─── Every permission check
    ├─── Every data access
    └─── Every AI operation
  
  Enables:
    ├─── SOX compliance
    ├─── HIPAA audit trail
    ├─── Security investigations
    └─── Intrusion detection

LEVEL 4: AI COST TRACKING
  Per-Tenant Cost Dashboard:
    ├─── AIActionRun aggregation:
         └─── SUM(costAmount) GROUP BY tenantId, DATE(startedAt)
    ├─── Shows: Daily/Monthly AI spend
    ├─── Shows: Cost by action type
    ├─── Shows: Cost by user
    └─── Alerts when approaching limits

AUDIT QUERY EXAMPLES:

  1. "Who created Estimate #42?"
     SELECT 
       e.estimateNumber,
       a.displayName as createdBy,
       e.createdAt,
       CASE 
         WHEN e.metadata->>'createdBy' = 'AI_AGENT' THEN 'AI Agent'
         ELSE 'Manual'
       END as creationType,
       e.metadata->>'aiRequestId' as aiRequestId
     FROM Estimate e
     JOIN Actor a ON e.createdByActorId = a.id
     WHERE e.estimateNumber = 'EST-2025-0042';
  
  2. "Show all AI operations that modified Project #34"
     SELECT 
       ar.actionCode,
       ar.startedAt,
       a.displayName as performedBy,
       ar.executionStatus,
       ar.resultMessage
     FROM AIActionRun ar
     JOIN Actor a ON ar.actorId = a.id
     WHERE ar.targetResourceId = '34'
       AND ar.targetResourceType = 'Project'
     ORDER BY ar.startedAt DESC;
  
  3. "AI cost by user this month"
     SELECT 
       a.displayName,
       COUNT(*) as aiOperations,
       SUM(ar.inputTokenCount + ar.outputTokenCount) as totalTokens,
       SUM(ar.costAmount) as totalCost
     FROM AIActionRun ar
     JOIN Actor a ON ar.actorId = a.id
     WHERE ar.tenantId = ?
       AND ar.startedAt >= DATE_TRUNC('month', CURRENT_DATE)
     GROUP BY a.id, a.displayName
     ORDER BY totalCost DESC;
  
  4. "What insights were generated for Invoice #42?"
     SELECT 
       i.insightTitle,
       i.insightType,
       i.severity,
       i.generatedAt,
       i.confidenceScore,
       a.displayName as generatedBy
     FROM AIInsight i
     JOIN Actor a ON i.createdByActorId = a.id
     WHERE i.sourceType = 'INVOICE'
       AND i.sourceId = '42'
     ORDER BY i.severity DESC, i.generatedAt DESC;
```

---

## 13. ERROR HANDLING & RETRY LOGIC

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    COMPREHENSIVE ERROR HANDLING STRATEGY                     │
└─────────────────────────────────────────────────────────────────────────────┘

ERROR CATEGORIES & RESPONSES:

1. AUTHENTICATION/AUTHORIZATION ERRORS (4xx)
   ├─── 401 Unauthorized → Token invalid/expired
   │    └─► Action: Redirect to login, refresh token
   │    └─► Retry: NO
   │
   ├─── 403 Forbidden → No permission
   │    └─► Action: Show permission error, contact admin
   │    └─► Retry: NO
   │
   └─── 429 Too Many Requests → Rate limit exceeded
        └─► Action: Wait and retry with exponential backoff
        └─► Retry: YES (after delay)

2. LLM API ERRORS
   ├─── 429 Rate Limit (OpenAI/Gemini)
   │    └─► Action: Exponential backoff retry
   │    └─► Retry Strategy:
   │         ├─► Attempt 1: Wait 5s → RETRY
   │         ├─► Attempt 2: Wait 10s → RETRY
   │         ├─► Attempt 3: Wait 20s → RETRY
   │         └─► Attempt 4: FAIL, log error
   │    └─► Fallback: Try different model if configured
   │
   ├─── 500 Server Error (LLM provider down)
   │    └─► Action: Immediate retry 2x, then fail
   │    └─► Fallback: Switch to backup provider
   │    └─► Notification: Alert DevOps
   │
   ├─── 400 Bad Request (invalid input)
   │    └─► Action: NO RETRY
   │    └─► Log: Full request/response for debugging
   │    └─► User Message: "AI processing failed. Please try rephrasing."
   │
   └─── Timeout (>30s)
        └─► Action: Cancel request, mark as TIMEOUT
        └─► Retry: YES (1 retry only)
        └─► User Message: "Request took too long. Please try again."

3. DATA VALIDATION ERRORS
   ├─── Missing Required Data
   │    └─► Action: NO RETRY
   │    └─► Response: 400 Bad Request with details
   │    └─► Example: "Project #34 not found"
   │
   ├─── Invalid AI Output
   │    └─► Action: Retry with modified prompt (1x)
   │    └─► Example: AI returns malformed JSON
   │    └─► Fallback: Use lower confidence threshold
   │
   └─── Business Logic Validation Failed
        └─► Action: NO RETRY
        └─► Example: "Cannot create estimate: Client has overdue invoices"
        └─► Roll back any partial changes

4. DATABASE ERRORS
   ├─── Deadlock
   │    └─► Action: Automatic retry (PostgreSQL handles)
   │    └─► Max retries: 3
   │
   ├─── Connection Lost
   │    └─► Action: Reconnect and retry
   │    └─► Max retries: 5
   │
   └─► Constraint Violation
        └─► Action: NO RETRY
        └─► Log error, return user-friendly message

5. BACKGROUND JOB ERRORS
   ├─── Job Timeout
   │    └─► Action: Cancel, mark as TIMEOUT
   │    └─► Save partial results if possible
   │    └─► Notification: Alert job owner
   │
   ├─► Job Crash
   │    └─► Action: Automatic retry from queue
   │    └─► Max retries: 3
   │    └─► Exponential backoff: 1min, 5min, 15min
   │
   └─► Job Failure
        └─► Action: Mark as FAILED
        └─► Notification: Alert job owner with error details
        └─► Manual retry option available

┌─────────────────────────────────────────────────────────────────────────────┐
│                    RETRY IMPLEMENTATION PATTERN                              │
└─────────────────────────────────────────────────────────────────────────────┘

Exponential Backoff Function:
  async function retryWithBackoff<T>(
    operation: () => Promise<T>,
    options: {
      maxRetries: number;
      initialDelayMs: number;
      maxDelayMs: number;
      backoffMultiplier: number;
    }
  ): Promise<T> {
    let lastError: Error;
    
    for (let attempt = 0; attempt <= options.maxRetries; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error;
        
        // Don't retry on certain errors
        if (isNonRetryableError(error)) {
          throw error;
        }
        
        // Last attempt, throw
        if (attempt === options.maxRetries) {
          throw error;
        }
        
        // Calculate delay
        const delay = Math.min(
          options.initialDelayMs * Math.pow(options.backoffMultiplier, attempt),
          options.maxDelayMs
        );
        
        // Log retry attempt
        logger.warn(`Attempt ${attempt + 1} failed, retrying in ${delay}ms`, {
          error: error.message
        });
        
        // Wait before retry
        await sleep(delay);
      }
    }
    
    throw lastError;
  }

Usage Example:
  const aiResponse = await retryWithBackoff(
    () => callLLMAPI(prompt),
    {
      maxRetries: 3,
      initialDelayMs: 1000,
      maxDelayMs: 30000,
      backoffMultiplier: 2
    }
  );

┌─────────────────────────────────────────────────────────────────────────────┐
│                    ERROR LOGGING & MONITORING                                │
└─────────────────────────────────────────────────────────────────────────────┘

Structured Error Logging:
  await db.aiActionRun.create({
    data: {
      ...baseData,
      executionStatus: "FAILURE",
      errorCode: error.code,
      errorMessage: error.message,
      errorStack: error.stack,
      retryCount: attempt,
      metadata: {
        requestId: ctx.requestId,
        correlationId: ctx.correlationId,
        llmProvider: "OPENAI",
        llmModel: "gpt-4-turbo",
        llmStatusCode: error.statusCode,
        llmResponseHeaders: error.headers
      }
    }
  });

Monitoring Alerts:
  ├─── Alert: AI Error Rate > 5%
  │    └─► Notify: DevOps team
  │    └─► Action: Investigate LLM provider issues
  │
  ├─── Alert: Specific Action Failing > 10x in 1 hour
  │    └─► Notify: AI team + DevOps
  │    └─► Action: Disable action, investigate
  │
  └─── Alert: Cost Spike (>2x normal)
       └─► Notify: Engineering lead
       └─► Action: Check for runaway jobs, token usage
```

---

## 14. COST TRACKING & RATE LIMITING

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AI COST MANAGEMENT ARCHITECTURE                           │
└─────────────────────────────────────────────────────────────────────────────┘

COST CALCULATION:

Per-Request Cost:
  inputCost = inputTokenCount × costPerInputToken
  outputCost = outputTokenCount × costPerOutputToken
  totalCost = inputCost + outputCost
  
  Example (GPT-4 Turbo):
    inputTokens: 450
    outputTokens: 890
    costPerInputToken: $0.00003 ($0.03 / 1K tokens)
    costPerOutputToken: $0.00006 ($0.06 / 1K tokens)
    
    inputCost = 450 × 0.00003 = $0.0135
    outputCost = 890 × 0.00006 = $0.0534
    totalCost = $0.0669

Cost Storage:
  AIActionRun.costAmount = 0.0669
  AIActionRun.costCurrency = "USD"
  AIActionRun.inputTokensCharged = 450
  AIActionRun.outputTokensCharged = 890

Aggregated Cost Tracking:
  // Real-time denormalization
  AIModel.totalTokensInput += 450
  AIModel.totalTokensOutput += 890
  AIModel.totalCost += 0.0669
  AIModel.totalRequests += 1

┌─────────────────────────────────────────────────────────────────────────────┐
│                    RATE LIMITING STRATEGY                                    │
└─────────────────────────────────────────────────────────────────────────────┘

LEVEL 1: Per-User Rate Limit
  Limit: 100 AI requests per hour per user
  
  Implementation:
    const userRequestCount = await redis.incr(
      `ai:ratelimit:user:${ctx.actorId}:${currentHour}`
    );
    await redis.expire(
      `ai:ratelimit:user:${ctx.actorId}:${currentHour}`,
      3600 // 1 hour
    );
    
    if (userRequestCount > 100) {
      throw new RateLimitError("AI request limit exceeded. Try again in 1 hour.");
    }

LEVEL 2: Per-Tenant Token Limit
  Limit: 1M tokens per month per tenant (configurable)
  
  Implementation:
    const tenantMonthlyTokens = await db.aiActionRun.aggregate({
      where: {
        tenantId: ctx.tenantId,
        startedAt: {
          gte: startOfMonth(new Date())
        }
      },
      _sum: {
        inputTokensCharged: true,
        outputTokensCharged: true
      }
    });
    
    const totalTokens = 
      (tenantMonthlyTokens._sum.inputTokensCharged || 0) +
      (tenantMonthlyTokens._sum.outputTokensCharged || 0);
    
    if (totalTokens > tenant.aiMonthlyTokenLimit) {
      throw new RateLimitError(
        "Monthly AI token limit exceeded. Upgrade plan or wait until next month."
      );
    }

LEVEL 3: Per-Model Rate Limit (External API Limits)
  Limit: Respect OpenAI/Gemini rate limits
  
  Implementation:
    const modelRequestCount = await redis.incr(
      `ai:ratelimit:model:${aiModel.id}:${currentMinute}`
    );
    await redis.expire(
      `ai:ratelimit:model:${aiModel.id}:${currentMinute}`,
      60 // 1 minute
    );
    
    if (modelRequestCount > aiModel.requestsPerMinute) {
      // Queue request or wait
      await queueAIRequest({
        requestId: ctx.requestId,
        aiModelId: aiModel.id,
        payload: requestPayload
      });
      
      return {
        status: "QUEUED",
        message: "Request queued due to rate limit",
        estimatedWaitTime: 30 // seconds
      };
    }

LEVEL 4: Cost Alerts
  Tenant AI Budget: $500/month
  
  Alert Thresholds:
    ├─── 50% budget used ($250) → Info email
    ├─── 80% budget used ($400) → Warning email
    ├─── 90% budget used ($450) → Critical alert
    └─── 100% budget used ($500) → Auto-disable AI, require upgrade
  
  Implementation:
    const monthlySpend = await getMonthlyAICost(ctx.tenantId);
    const budget = tenant.aiMonthlyBudget || 500;
    const percentUsed = (monthlySpend / budget) * 100;
    
    if (percentUsed >= 100) {
      await disableAIForTenant(ctx.tenantId);
      await sendAlert({
        type: "CRITICAL",
        message: "AI budget exceeded. AI features disabled."
      });
    } else if (percentUsed >= 90) {
      await sendAlert({
        type: "WARNING",
        message: "AI budget 90% used. $50 remaining."
      });
    }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    COST OPTIMIZATION STRATEGIES                              │
└─────────────────────────────────────────────────────────────────────────────┘

1. Prompt Optimization
   ├─── Use concise prompts (reduce input tokens)
   ├─── Request concise responses (reduce output tokens)
   └─► Savings: 20-30% token reduction

2. Model Selection
   ├─── Use cheaper models for simple tasks
   │    └─► GPT-3.5 for classification ($0.0015/1K vs $0.03/1K)
   ├─── Use expensive models only for complex reasoning
   │    └─► GPT-4 for financial analysis, recommendations
   └─► Savings: 60-70% cost reduction on simple tasks

3. Caching
   ├─── Cache AI responses for identical inputs
   ├─── Cache embeddings (don't regenerate)
   └─► Savings: 80-90% on repeated queries

4. Batch Processing
   ├─── Process multiple items in single request
   │    └─► "Analyze these 10 invoices" vs 10 separate calls
   └─► Savings: 50% reduction in API overhead

5. Async Background Jobs
   ├─── Non-urgent analysis runs overnight (off-peak)
   ├─── Batch insights generation
   └─► Savings: Better resource utilization

┌─────────────────────────────────────────────────────────────────────────────┐
│                    COST TRANSPARENCY & REPORTING                             │
└─────────────────────────────────────────────────────────────────────────────┘

Tenant AI Usage Dashboard:
  ┌────────────────────────────────────────────────────────────┐
  │  📊 AI Usage & Cost - November 2025                        │
  ├────────────────────────────────────────────────────────────┤
  │                                                            │
  │  Budget: $500/month                                        │
  │  Used: $347.82 (69.6%)                                     │
  │  Remaining: $152.18                                        │
  │  ┌──────────────────────────────────────────┐             │
  │  │███████████████████████████░░░░░░░░░░░░░░│             │
  │  └──────────────────────────────────────────┘             │
  │                                                            │
  │  📈 Daily Spend                                            │
  │  ├─ Nov 17: $23.45                                        │
  │  ├─ Nov 16: $18.92                                        │
  │  └─ Nov 15: $31.78                                        │
  │                                                            │
  │  🔝 Top Cost Drivers                                       │
  │  1. Invoice Financial Analysis: $89.23 (26%)              │
  │  2. Estimate Pricing Intelligence: $67.45 (19%)           │
  │  3. Document OCR Processing: $54.32 (16%)                 │
  │                                                            │
  │  👥 Usage by User                                          │
  │  1. John Smith: $98.45 (28%)                              │
  │  2. Jane Doe: $76.23 (22%)                                │
  │  3. Bob Johnson: $45.67 (13%)                             │
  │                                                            │
  │  [View Detailed Report] [Upgrade Plan] [Settings]         │
  └────────────────────────────────────────────────────────────┘
```

---

**END OF AI FLOW DOCUMENTATION**

**Document Version:** 1.0  
**Document Status:** ✅ Production-Ready  
**Total Page Count:** 2 documents (Part 1 + Part 2)  
**Coverage:** Complete operational flows for all AI modules  
**Next Steps:** Implementation, testing, production deployment

---

## 📚 QUICK REFERENCE INDEX

**Core Flows:**
1. AI Agent Navigation & Command Execution → Part 1
2. Estimate Pricing Intelligence → Part 1
3. Invoice Financial Analysis → Part 1
4. Project Schedule Intelligence → Part 1
5. Document OCR & Extraction → Part 1
6. Expense Receipt Auto-Processing → Part 2
7. AIPlaybook Multi-Step Workflows → Part 2
8. Proactive Insight Generation → Part 2
9. Semantic Search & RAG → Part 2
10. What-If Scenario Analysis → Part 2

**Critical Systems:**
11. Security & Permission Enforcement → Part 2
12. Audit Trail & Actor Attribution → Part 2
13. Error Handling & Retry Logic → Part 2
14. Cost Tracking & Rate Limiting → Part 2

**Related Documents:**
- AI_ARCHITECTURE_DIAGRAM_v1_0.md (architectural overview)
- ERP_Modules.md (module structure)
- Estimate_Flow.v8.md (estimate patterns)
- Invoice_Flow.v8.0.md (invoice patterns)
- PROJECT_FLOW.md (project patterns)
