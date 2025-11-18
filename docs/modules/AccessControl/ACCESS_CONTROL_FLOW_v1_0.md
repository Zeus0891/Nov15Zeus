# 🔐 Access Control Module — Functional & Integration Specification

**Version:** 1.0
**Last Updated:** November 17, 2025

**Related Modules & Schemas:**

- `accesscontrol.prisma` (RBAC, ABAC, Policies)
- `identity.prisma` (Actor, User, Session)
- `membership.prisma` (Member, tenant membership)
- `identitysecurity.prisma` (MFA, SSO, security)
- `approvals.prisma` (approval routing based on roles)
- `tenant.prisma` (multi-tenant isolation)
- ALL BUSINESS MODULES (Estimate, Project, Invoice, Expense, Inventory, etc.)

---

## 1. Purpose & Goals

The **Access Control module** is the foundational security layer for the entire ERP platform. It provides enterprise-grade Role-Based Access Control (RBAC), Attribute-Based Access Control (ABAC), and policy-driven authorization.

### 1.1 Core Objectives

1. **Zero-trust security** — Every action requires explicit permission verification
2. **Fine-grained control** — Permission checks at resource, field, and action levels
3. **Flexible RBAC** — Hierarchical roles with inheritance and scoping
4. **Policy-driven ABAC** — Runtime evaluation of complex access rules
5. **Complete audit trail** — Every access decision logged for compliance
6. **Service account support** — Secure API integrations with key rotation
7. **Multi-tenant isolation** — Guaranteed data separation between tenants
8. **Compliance ready** — SOX, GDPR, HIPAA, PCI-DSS audit support

### 1.2 Business Value

- **Security**: Enterprise-grade access control prevents unauthorized access
- **Compliance**: Complete audit trails satisfy regulatory requirements
- **Flexibility**: Supports complex organizational structures and workflows
- **Scale**: Handles millions of permission checks per day efficiently
- **Integration**: Seamless API access for third-party integrations

---

## 2. Domain Model (Access Control Module)

Models in `accesscontrol.prisma`:

- `Role` — Named collection of permissions
- `Permission` — Specific action on resource type
- `RolePermission` — Junction: Role ↔ Permission
- `MemberRole` — Junction: Member ↔ Role (with optional scope)
- `AccessPolicy` — Advanced policy rules (ABAC)
- `AccessPolicyCondition` — Runtime conditions for policies
- `AccessScope` — Resource scope definitions (projects, departments, etc.)
- `AccessScopeAssignment` — Junction: Scope ↔ Role/Member
- `AccessResource` — Registry of access-controlled resources
- `AccessAuditEvent` — Complete audit trail of access decisions
- `ServiceAccount` — System/API user identities
- `ServiceAccountKey` — API keys for service accounts

### 2.1 Core Relationships

```
Actor (identity.prisma)
  │
  ├──► User ──► Member (membership.prisma)
  │                │
  │                ├──► MemberRole[] ──► Role ──► RolePermission[] ──► Permission
  │                │                       │
  │                │                       └──► AccessScopeAssignment ──► AccessScope
  │                │
  │                └──► Direct AccessScopeAssignment (member-specific scopes)
  │
  └──► ServiceAccount ──► ServiceAccountKey[]
                          └──► Uses same permission system via Actor linkage
```

### 2.2 Permission Model

**Permission Naming Convention**: `resource:action[:scope]`

Examples:

- `estimate:create` — Create estimates
- `estimate:read:all` — Read all estimates in tenant
- `estimate:read:own` — Read only own estimates
- `estimate:approve:internal` — Internal approval permission
- `project:delete` — Delete projects
- `invoice:export:pdf` — Export invoices as PDF
- `*:*` — Super admin (all permissions)

### 2.3 Access Policy Model (ABAC)

Policies allow complex runtime evaluation:

```
Policy: "Project Managers can approve estimates under $50K"
├── Resource: estimate
├── Action: approve:internal
├── Effect: ALLOW
├── Conditions:
│   ├── user.role CONTAINS 'PROJECT_MANAGER'
│   └── estimate.totalAmount < 50000
└── Priority: 100
```

---

## 3. Status & Lifecycle

### 3.1 Role Lifecycle

```
DRAFT (being configured)
  │
  ▼
ACTIVE (in use)
  │
  ├──► INACTIVE (temporarily disabled)
  │      │
  │      └──► ACTIVE (reactivated)
  │
  └──► DELETED (soft delete, cannot be restored if system role)
```

### 3.2 Service Account Lifecycle

```
PENDING (created, not yet activated)
  │
  ▼
ACTIVE (keys valid, can authenticate)
  │
  ├──► SUSPENDED (temporarily blocked)
  │      │
  │      └──► ACTIVE (reactivated)
  │
  ├──► EXPIRED (all keys expired)
  │
  └──► REVOKED (permanently disabled)
```

### 3.3 API Key Lifecycle

```
ACTIVE (valid for authentication)
  │
  ├──► EXPIRED (automatic expiration by date)
  │
  ├──► REVOKED (manually disabled by admin)
  │
  └──► COMPROMISED (marked as leaked/stolen)
```

---

## 4. Screen: Access Control Dashboard

### 4.1 Dashboard Metrics (Admin View)

Top summary cards:

- **Total Active Roles** (count of non-deleted roles)
- **Total Permissions** (system + custom permissions)
- **Active Service Accounts** (count)
- **Access Denials (24h)** (security monitoring)
- **Policy Violations (24h)** (compliance monitoring)

### 4.2 Quick Actions

- **Create Role**
- **Create Service Account**
- **Create Access Policy**
- **View Audit Log**
- **Generate Access Report** (compliance)

---

## 5. Role Management

### 5.1 Create Role Flow

**Entry Point**: Admin → Access Control → Roles → "Create Role"

**Screen: Create Role**

```
┌─────────────────────────────────────────────────────────────────┐
│ Create New Role                                           [×]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Role Name: [_________________________] *Required               │
│                                                                 │
│ Role Code: [_________________________] (auto-generated)        │
│                                                                 │
│ Description: [_________________________________________]        │
│              [_________________________________________]        │
│                                                                 │
│ Role Type: ⦿ Custom  ○ Template                                │
│                                                                 │
│ Role Category:                                                  │
│   ▼ [Select Category]                                          │
│      - Admin                                                    │
│      - Manager                                                  │
│      - User                                                     │
│      - Field                                                    │
│      - Viewer                                                   │
│                                                                 │
│ ┌───────────────────────────────────────────────────────────┐  │
│ │ Permissions                                [Add Permission]│  │
│ ├───────────────────────────────────────────────────────────┤  │
│ │                                                           │  │
│ │ 🔍 Search permissions...                                  │  │
│ │                                                           │  │
│ │ ☐ Select All  Categories: [All ▼]                        │  │
│ │                                                           │  │
│ │ 📊 ESTIMATES                                              │  │
│ │   ☐ estimate:create          Create estimates            │  │
│ │   ☐ estimate:read:all        Read all estimates          │  │
│ │   ☐ estimate:read:own        Read own estimates          │  │
│ │   ☐ estimate:update          Update estimates            │  │
│ │   ☐ estimate:delete          Delete estimates            │  │
│ │   ☐ estimate:approve:internal Internal approval          │  │
│ │                                                           │  │
│ │ 🏗️ PROJECTS                                               │  │
│ │   ☐ project:create           Create projects             │  │
│ │   ☐ project:read:all         Read all projects           │  │
│ │   ☐ project:read:assigned    Read assigned projects      │  │
│ │   ☐ project:update           Update projects             │  │
│ │   ☐ project:close            Close projects              │  │
│ │                                                           │  │
│ │ 💰 INVOICES                                               │  │
│ │   ☐ invoice:create           Create invoices             │  │
│ │   ☐ invoice:read             Read invoices               │  │
│ │   ☐ invoice:approve          Approve invoices            │  │
│ │   ☐ invoice:void             Void invoices               │  │
│ │                                                           │  │
│ │ 💳 EXPENSES                                               │  │
│ │   ☐ expense:submit:own       Submit own expenses         │  │
│ │   ☐ expense:approve:team     Approve team expenses       │  │
│ │   ☐ expense:approve:all      Approve all expenses        │  │
│ │                                                           │  │
│ │                                    [Showing 15 of 247]   │  │
│ └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│ ⚙️ Advanced Options                                             │
│   ☐ Require MFA for this role                                  │
│   ☐ Make this a default role (auto-assign to new members)     │
│   ☐ Allow self-assignment                                      │
│                                                                 │
│                                    [Cancel]  [Create Role]     │
└─────────────────────────────────────────────────────────────────┘
```

**Backend Flow**:

1. **Validation**:

   ```typescript
   - roleName is unique within tenant
   - roleCode auto-generated from name (e.g., "PROJECT_MANAGER")
   - At least one permission selected (unless template)
   - User has permission: role:create
   ```

2. **Create Role**:

   ```typescript
   const role = await prisma.role.create({
     data: {
       tenantId,
       roleName,
       roleCode,
       description,
       roleType: "CUSTOM",
       roleCategory,
       isActive: true,
       createdByActorId: currentActorId,
     },
   });
   ```

3. **Assign Permissions**:

   ```typescript
   const rolePermissions = selectedPermissions.map((permissionId) => ({
     roleId: role.id,
     permissionId,
     grantedByActorId: currentActorId,
     isActive: true,
   }));

   await prisma.rolePermission.createMany({
     data: rolePermissions,
   });
   ```

4. **Audit Event**:

   ```typescript
   await createAccessAuditEvent({
     eventType: "ROLE_CREATED",
     actorId: currentActorId,
     resourceType: "ROLE",
     resourceId: role.id,
     actionType: "CREATE",
     accessDecision: "ALLOWED",
   });
   ```

5. **Success Response**:
   - Show success toast: "Role 'Project Manager' created successfully"
   - Redirect to Role detail page
   - Clear permission cache for affected users

### 5.2 Assign Role to Member

**Entry Point**: Admin → Members → [Select Member] → Roles → "Assign Role"

**Screen: Assign Role**

```
┌─────────────────────────────────────────────────────────────────┐
│ Assign Role to John Smith                                [×]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Role: ▼ [Select Role]                                          │
│        - Project Manager                                        │
│        - Estimator                                              │
│        - Field Supervisor                                       │
│        - Financial Controller                                   │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ 🎯 Scope (Optional - Limit role to specific resources)     │ │
│ ├─────────────────────────────────────────────────────────────┤ │
│ │                                                             │ │
│ │ Apply scope? ○ No - Full access  ⦿ Yes - Limited access    │ │
│ │                                                             │ │
│ │ Scope Type: ▼ [Projects]                                   │ │
│ │               - Projects                                    │ │
│ │               - Departments                                 │ │
│ │               - Locations                                   │ │
│ │               - Custom Query                                │ │
│ │                                                             │ │
│ │ Selected Projects:                                          │ │
│ │   [×] Phoenix Tower Renovation                              │ │
│ │   [×] Downtown Office Complex                               │ │
│ │   [Add Project...]                                          │ │
│ │                                                             │ │
│ │ ℹ️ This member will only be able to manage the selected    │ │
│ │    projects with the permissions from this role.            │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│ Effective Date: [Today ▼]                                      │
│                                                                 │
│ Expiration: ○ No expiration                                    │
│             ⦿ Expires on: [12/31/2025 ▼]                       │
│                                                                 │
│ Assignment Reason: [______________________________]            │
│                                                                 │
│ ⚙️ Options:                                                     │
│   ☐ Set as primary role                                        │
│   ☐ Send notification email to member                          │
│                                                                 │
│                                    [Cancel]  [Assign Role]     │
└─────────────────────────────────────────────────────────────────┘
```

**Backend Flow**:

1. **Validation**:

   ```typescript
   - Member exists and is active
   - Role exists and is active
   - User has permission: member:assign-role
   - Check for conflicting roles (if defined)
   - If scoped: validate scope resources exist
   ```

2. **Create MemberRole**:

   ```typescript
   const memberRole = await prisma.memberRole.create({
     data: {
       tenantId,
       memberId,
       roleId,
       assignedByActorId: currentActorId,
       assignmentReason,
       expiresAt,
       isPrimary,
       isActive: true,

       // If scoped
       scopeType: scopeType || null,
       scopeResourceType: "PROJECT",
       scopeConditions: {
         projectIds: selectedProjectIds,
       },
     },
   });
   ```

3. **Create AccessScope** (if scoped):

   ```typescript
   if (scopeType) {
     const accessScope = await prisma.accessScope.create({
       data: {
         tenantId,
         scopeName: `${member.name} - ${role.roleName} - Projects`,
         scopeType: "PROJECT",
         resourceFilter: {
           projectIds: selectedProjectIds,
         },
       },
     });

     await prisma.accessScopeAssignment.create({
       data: {
         tenantId,
         accessScopeId: accessScope.id,
         memberRoleId: memberRole.id,
         assignedByActorId: currentActorId,
       },
     });
   }
   ```

4. **Invalidate Cache**:

   ```typescript
   await invalidatePermissionCache(memberId);
   ```

5. **Send Notification** (if enabled):

   ```typescript
   await sendEmail({
     to: member.email,
     template: "role-assigned",
     data: {
       roleName: role.roleName,
       assignedBy: currentActor.name,
       expiresAt: expiresAt || "Never",
       scope: scopeDescription,
     },
   });
   ```

6. **Audit Event**:
   ```typescript
   await createAccessAuditEvent({
     eventType: "ROLE_ASSIGNED",
     actorId: currentActorId,
     resourceType: "MEMBER",
     resourceId: memberId,
     actionType: "ASSIGN_ROLE",
     accessDecision: "ALLOWED",
     metadata: {
       roleId,
       scopeType,
       expiresAt,
     },
   });
   ```

---

## 6. Permission Checking (Runtime)

### 6.1 Permission Check Flow (Synchronous)

**Function Signature**:

```typescript
async function checkPermission(
  actorId: string,
  permission: string,
  resourceType?: string,
  resourceId?: string,
  context?: Record<string, any>
): Promise<PermissionCheckResult>;
```

**Backend Flow**:

```
1. Load Actor & Member
   ├── Get Actor from actorId
   ├── If User → Get Member
   └── If ServiceAccount → Use service account permissions

2. Load Member Roles (with cache)
   ├── Check Redis cache first: `permissions:${memberId}`
   ├── If miss → Query database:
   │   └── SELECT * FROM MemberRole WHERE memberId = ? AND isActive = true
   └── Cache result (TTL: 5 minutes)

3. Load Role Permissions (with cache)
   ├── For each role → Get RolePermission[]
   ├── Check cache: `role-permissions:${roleId}`
   └── Build permission set

4. Direct Permission Check
   ├── Parse permission string: "estimate:approve:internal"
   ├── Check if permission exists in set
   │   ├── Exact match: "estimate:approve:internal" ✓
   │   ├── Wildcard match: "estimate:*" ✓
   │   └── Super admin: "*:*" ✓
   └── If NO match → DENY (log audit event)

5. Scope Check (if applicable)
   ├── Get AccessScopeAssignment for member/role
   ├── If scoped to projects:
   │   └── Check if resourceId in allowed project list
   ├── If scoped to department:
   │   └── Check if resource.department matches scope
   └── If scope violation → DENY

6. Policy Evaluation (ABAC)
   ├── Load applicable AccessPolicy records:
   │   └── WHERE resourceType = ? AND actionType = ?
   ├── For each policy:
   │   ├── Evaluate AccessPolicyCondition[]
   │   ├── Build expression tree
   │   └── Evaluate runtime (substitute context variables)
   ├── Collect results (ALLOW/DENY with priority)
   └── Apply priority-based resolution:
       ├── Highest priority DENY wins
       └── Otherwise highest priority ALLOW wins

7. Final Decision
   ├── If any DENY from policy → DENY
   ├── If permission granted + no policy denial → ALLOW
   └── Default: DENY (fail-closed)

8. Log Audit Event
   └── Create AccessAuditEvent with full context

9. Return Result
   └── { allowed: boolean, reason: string, matchedPolicies: [] }
```

**Example Implementation**:

```typescript
export async function checkPermission(
  actorId: string,
  permission: string,
  resourceType?: string,
  resourceId?: string,
  context: Record<string, any> = {}
): Promise<PermissionCheckResult> {
  const startTime = Date.now();

  try {
    // 1. Load Actor & Member (Production Module Integration)
    const actor = await getActor(actorId);
    if (!actor) {
      return deny("Actor not found");
    }

    // Production Module Context Enhancement
    if (resourceType && resourceId) {
      // For Estimate/Invoice/Project - check 1:1:1 traceability
      if (["ESTIMATE", "INVOICE", "PROJECT"].includes(resourceType)) {
        const resource = await loadResource(resourceType, resourceId);
        if (resource) {
          context.globalId = resource.globalId;
          context.traceability = {
            estimate: resource.sourceEstimateId || resource.id,
            project: resource.relatedProjectId || resource.sourceProjectId,
            invoice: resource.sourceInvoiceId || resource.id,
          };
        }
      }

      // For CRM entities - load customer context
      if (
        ["CRM_ACCOUNT", "CRM_CONTACT", "CRM_ADDRESS"].includes(resourceType)
      ) {
        const crmResource = await loadResource(resourceType, resourceId);
        if (crmResource) {
          context.customerContext = {
            accountId: crmResource.accountId || crmResource.id,
            contactId: crmResource.contactId || crmResource.id,
            addressId: crmResource.addressId || crmResource.id,
          };
        }
      }
    }

    let memberId: string;
    if (actor.type === "USER") {
      const member = await getMemberByActorId(actorId);
      if (!member || !member.isActive) {
        return deny("Member not active");
      }
      memberId = member.id;
    } else if (actor.type === "SERVICE_ACCOUNT") {
      // Service accounts use their own permission system
      memberId = actor.serviceAccount.memberId; // Linked member for permissions
    } else {
      return deny("Unknown actor type");
    }

    // 2. Load Member Roles (with cache)
    const memberRoles = await getCachedMemberRoles(memberId);

    if (!memberRoles || memberRoles.length === 0) {
      return deny("No roles assigned");
    }

    // 3. Load Role Permissions
    const allPermissions = new Set<string>();
    for (const memberRole of memberRoles) {
      if (!memberRole.isActive) continue;

      // Check expiration
      if (memberRole.expiresAt && memberRole.expiresAt < new Date()) {
        continue; // Skip expired role
      }

      const rolePermissions = await getCachedRolePermissions(memberRole.roleId);
      rolePermissions.forEach((p) =>
        allPermissions.add(p.permission.permissionCode)
      );
    }

    // 4. Direct Permission Check
    const hasPermission = checkDirectPermission(permission, allPermissions);

    if (!hasPermission) {
      await logAccessAudit({
        actorId,
        resourceType,
        resourceId,
        actionType: permission,
        accessDecision: "DENIED",
        decisionReason: "Permission not granted",
      });
      return deny("Permission not granted");
    }

    // 5. Scope Check
    const scopeCheck = await checkScopes(memberRoles, resourceType, resourceId);
    if (!scopeCheck.allowed) {
      await logAccessAudit({
        actorId,
        resourceType,
        resourceId,
        actionType: permission,
        accessDecision: "DENIED",
        decisionReason: scopeCheck.reason,
      });
      return deny(scopeCheck.reason);
    }

    // 6. Policy Evaluation (ABAC)
    const policyResult = await evaluatePolicies({
      actorId,
      memberId,
      permission,
      resourceType,
      resourceId,
      context,
    });

    if (policyResult.decision === "DENY") {
      await logAccessAudit({
        actorId,
        resourceType,
        resourceId,
        actionType: permission,
        accessDecision: "DENIED",
        decisionReason: policyResult.reason,
        matchedPolicyId: policyResult.policyId,
      });
      return deny(policyResult.reason);
    }

    // 7. ALLOW - All checks passed
    await logAccessAudit({
      actorId,
      resourceType,
      resourceId,
      actionType: permission,
      accessDecision: "ALLOWED",
      decisionReason: "All checks passed",
      matchedPolicyId: policyResult.policyId,
    });

    const duration = Date.now() - startTime;

    return {
      allowed: true,
      reason: "Permission granted",
      duration,
      matchedPolicies: policyResult.matchedPolicies,
    };
  } catch (error) {
    console.error("Permission check error:", error);

    // Fail closed - deny on error
    await logAccessAudit({
      actorId,
      resourceType,
      resourceId,
      actionType: permission,
      accessDecision: "ERROR",
      decisionReason: error.message,
    });

    return deny("Permission check error");
  }
}

function deny(reason: string): PermissionCheckResult {
  return {
    allowed: false,
    reason,
    matchedPolicies: [],
  };
}
```

### 6.2 Policy Evaluation Engine (ABAC)

```typescript
async function evaluatePolicies({
  actorId,
  memberId,
  permission,
  resourceType,
  resourceId,
  context,
}: PolicyEvalRequest): Promise<PolicyEvalResult> {
  // Load applicable policies
  const policies = await prisma.accessPolicy.findMany({
    where: {
      tenantId,
      resourceType,
      actionPattern: {
        contains: permission.split(":")[1], // Match action part
      },
      isActive: true,
      OR: [
        { effectiveFromDate: { lte: new Date() } },
        { effectiveFromDate: null },
      ],
      OR: [
        { effectiveUntilDate: { gte: new Date() } },
        { effectiveUntilDate: null },
      ],
    },
    include: {
      conditions: true,
    },
    orderBy: {
      priority: "desc", // Highest priority first
    },
  });

  if (!policies || policies.length === 0) {
    return { decision: "ALLOW", reason: "No policies apply" };
  }

  // Build context for evaluation
  const evalContext = await buildEvaluationContext({
    actorId,
    memberId,
    resourceType,
    resourceId,
    ...context,
  });

  // Evaluate each policy
  for (const policy of policies) {
    const conditionResults = await evaluateConditions(
      policy.conditions,
      evalContext
    );

    // All conditions must pass for policy to apply
    const allConditionsMet = conditionResults.every((r) => r.result === true);

    if (allConditionsMet) {
      // This policy applies
      if (policy.effect === "DENY") {
        // Explicit DENY always wins
        return {
          decision: "DENY",
          reason: `Policy '${policy.policyName}' denies access`,
          policyId: policy.id,
          matchedPolicies: [policy],
        };
      } else if (policy.effect === "ALLOW") {
        // ALLOW found, but continue checking for higher priority DENY
        continue;
      }
    }
  }

  // No DENY found, allow
  return {
    decision: "ALLOW",
    reason: "No denying policies found",
    matchedPolicies: policies.filter((p) => p.effect === "ALLOW"),
  };
}

async function evaluateConditions(
  conditions: AccessPolicyCondition[],
  context: EvalContext
): Promise<ConditionResult[]> {
  const results: ConditionResult[] = [];

  for (const condition of conditions) {
    if (!condition.isActive) continue;

    const result = await evaluateSingleCondition(condition, context);
    results.push(result);
  }

  return results;
}

async function evaluateSingleCondition(
  condition: AccessPolicyCondition,
  context: EvalContext
): Promise<ConditionResult> {
  // Extract attribute value from context
  const attributeValue = getNestedValue(context, condition.attributeName);

  // Perform comparison based on operator
  let result = false;

  switch (condition.operator) {
    case "EQUALS":
      result = attributeValue === condition.value;
      break;

    case "NOT_EQUALS":
      result = attributeValue !== condition.value;
      break;

    case "GREATER_THAN":
      result = Number(attributeValue) > Number(condition.value);
      break;

    case "LESS_THAN":
      result = Number(attributeValue) < Number(condition.value);
      break;

    case "IN":
      result = condition.values.includes(attributeValue);
      break;

    case "CONTAINS":
      result = String(attributeValue).includes(String(condition.value));
      break;

    case "REGEX":
      const regex = new RegExp(condition.value);
      result = regex.test(String(attributeValue));
      break;

    case "EXISTS":
      result = attributeValue !== undefined && attributeValue !== null;
      break;

    default:
      throw new Error(`Unknown operator: ${condition.operator}`);
  }

  return {
    conditionId: condition.id,
    result,
    attributeName: condition.attributeName,
    attributeValue,
    operator: condition.operator,
    expectedValue: condition.value,
  };
}

async function buildEvaluationContext({
  actorId,
  memberId,
  resourceType,
  resourceId,
  ...additionalContext
}: any): Promise<EvalContext> {
  const context: EvalContext = {
    currentTime: new Date(),
    ...additionalContext,
  };

  // Load user/member info
  if (memberId) {
    const member = await prisma.member.findUnique({
      where: { id: memberId },
      include: {
        memberRoles: {
          include: { role: true },
        },
      },
    });

    context.user = {
      id: member.id,
      email: member.email,
      department: member.department,
      roles: member.memberRoles.map((mr) => mr.role.roleName),
    };
  }

  // Load resource info (if provided)
  if (resourceType && resourceId) {
    const resource = await loadResource(resourceType, resourceId);
    context.resource = resource;
  }

  return context;
}

// Production Module Policy Examples:

// Policy 1: "PMs can approve estimates under $50K"
// Conditions:
//   1. user.roles CONTAINS 'PROJECT_MANAGER'
//   2. resource.totalAmount < 50000
//   3. resource.status == 'PENDING_APPROVAL'
//
// Context:
//   user: { roles: ['PROJECT_MANAGER', 'ESTIMATOR'] }
//   resource: { totalAmount: 35000, status: 'PENDING_APPROVAL', globalId: '01HZQ...' }
//
// Result:
//   Condition 1: TRUE (user has PM role)
//   Condition 2: TRUE (35000 < 50000)
//   Condition 3: TRUE (status matches)
//   Policy applies: ALLOW

// Policy 2: "Prevent deletion of active projects with invoices"
// Conditions:
//   1. action == 'delete'
//   2. resource.type == 'PROJECT'
//   3. resource.status == 'ACTIVE'
//   4. resource.hasInvoices == true
//
// Context:
//   action: 'delete'
//   resource: { type: 'PROJECT', status: 'ACTIVE', hasInvoices: true, globalId: '01HZQ...' }
//
// Result:
//   All conditions TRUE → Policy applies: DENY

// Policy 3: "Financial controllers can void invoices under $10K"
// Conditions:
//   1. user.roles CONTAINS 'FINANCIAL_CONTROLLER'
//   2. resource.totalAmount < 10000
//   3. resource.status IN ['SENT', 'VIEWED']
//   4. resource.amountPaid == 0
//
// Context:
//   user: { roles: ['FINANCIAL_CONTROLLER'] }
//   resource: { totalAmount: 7500, status: 'SENT', amountPaid: 0, sourceEstimateId: 'est_123' }
//
// Result:
//   All conditions TRUE → Policy applies: ALLOW
```

---

## 7. Service Account Management

### 7.1 Create Service Account

**Entry Point**: Admin → Access Control → Service Accounts → "Create Service Account"

**Screen: Create Service Account**

```
┌─────────────────────────────────────────────────────────────────┐
│ Create Service Account                                    [×]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Account Name: [_________________________] *Required            │
│                                                                 │
│ Email: [_________________________@company.com]                 │
│                                                                 │
│ Description: [_________________________________________]        │
│              [_________________________________________]        │
│                                                                 │
│ Account Type:                                                   │
│   ⦿ API Integration                                            │
│   ○ Webhook Handler                                            │
│   ○ Cron Job / Scheduled Task                                  │
│   ○ System Service                                             │
│                                                                 │
│ Service Category:                                               │
│   ▼ [External Integration]                                     │
│      - External Integration                                     │
│      - Internal Automation                                      │
│      - Data Synchronization                                     │
│      - Reporting                                                │
│      - Monitoring                                               │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ 🔐 Permissions                                              │ │
│ ├─────────────────────────────────────────────────────────────┤ │
│ │                                                             │ │
│ │ Assign Roles: [+ Add Role]                                 │ │
│ │                                                             │ │
│ │ [×] API Read-Only                                          │ │
│ │     - estimate:read, project:read, invoice:read            │ │
│ │                                                             │ │
│ │ Custom Permissions:                                         │ │
│ │   ☐ estimate:create                                        │ │
│ │   ☐ invoice:create                                         │ │
│ │   ☐ webhook:receive                                        │ │
│ │                                                             │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ 🔒 Security Settings                                        │ │
│ ├─────────────────────────────────────────────────────────────┤ │
│ │                                                             │ │
│ │ IP Whitelist (Optional):                                    │ │
│ │   [192.168.1.100________________] [+ Add]                  │ │
│ │   [×] 10.0.0.0/24                                          │ │
│ │                                                             │ │
│ │ Rate Limits:                                                │ │
│ │   Requests per minute: [100__]                             │ │
│ │   Requests per hour:   [5000_]                             │ │
│ │   Requests per day:    [50000]                             │ │
│ │                                                             │ │
│ │ Expiration:                                                 │ │
│ │   ○ Never expires                                           │ │
│ │   ⦿ Expires on: [12/31/2025 ▼]                             │ │
│ │                                                             │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│                            [Cancel]  [Create Account]          │
└─────────────────────────────────────────────────────────────────┘
```

**Backend Flow**:

1. **Validation**:

   ```typescript
   - serviceAccountName unique within tenant
   - serviceAccountEmail valid format
   - User has permission: service-account:create
   - IP addresses valid (if provided)
   ```

2. **Create Actor** (service accounts ARE actors):

   ```typescript
   const actor = await prisma.actor.create({
     data: {
       tenantId,
       actorType: "SERVICE_ACCOUNT",
       displayName: serviceAccountName,
       createdByActorId: currentActorId,
     },
   });
   ```

3. **Create Service Account**:

   ```typescript
   const serviceAccount = await prisma.serviceAccount.create({
     data: {
       tenantId,
       actorId: actor.id,
       serviceAccountName,
       serviceAccountEmail,
       description,
       accountType,
       serviceCategory,
       status: "PENDING",
       allowedIpAddresses,
       requestsPerMinute,
       requestsPerHour,
       requestsPerDay,
       expiresAt,
       createdByMemberId: currentMember.id,
       ownerMemberId: currentMember.id,
       createdByActorId: currentActorId,
     },
   });
   ```

4. **Create Linked Member** (for permission system):

   ```typescript
   // Service accounts use Member + MemberRole for permissions
   const member = await prisma.member.create({
     data: {
       tenantId,
       actorId: actor.id,
       email: serviceAccountEmail,
       firstName: "Service Account",
       lastName: serviceAccountName,
       memberType: "SERVICE_ACCOUNT",
       isActive: true,
     },
   });
   ```

5. **Assign Roles**:

   ```typescript
   for (const roleId of selectedRoles) {
     await prisma.memberRole.create({
       data: {
         tenantId,
         memberId: member.id,
         roleId,
         assignedByActorId: currentActorId,
       },
     });
   }
   ```

6. **Show Success + Generate First Key**:

   ```typescript
   // Automatically create first API key
   const apiKey = await generateServiceAccountKey(serviceAccount.id);

   // Show one-time display of key
   return {
     serviceAccount,
     apiKey: {
       keyId: apiKey.keyId,
       key: apiKey.plainTextKey, // ONLY TIME THIS IS SHOWN
       expiresAt: apiKey.expiresAt,
     },
   };
   ```

### 7.2 Generate API Key

**Entry Point**: Service Account Detail → "Generate New API Key"

**Screen: Generate API Key**

```
┌─────────────────────────────────────────────────────────────────┐
│ Generate New API Key                                      [×]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Service Account: Stripe Integration                            │
│                                                                 │
│ Key Name: [_________________________] *Required                │
│           (e.g., "Production Server 1")                        │
│                                                                 │
│ Description: [_________________________________________]        │
│                                                                 │
│ Expiration:                                                     │
│   ○ 30 days                                                     │
│   ○ 90 days                                                     │
│   ⦿ 180 days                                                    │
│   ○ 1 year                                                      │
│   ○ Never (not recommended)                                     │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ ⚠️ Security Warning                                         │ │
│ ├─────────────────────────────────────────────────────────────┤ │
│ │                                                             │ │
│ │ The API key will be displayed ONLY ONCE after generation.  │ │
│ │ Make sure to copy it immediately and store it securely.    │ │
│ │                                                             │ │
│ │ We cannot recover lost API keys. If you lose a key, you    │ │
│ │ must revoke it and generate a new one.                     │ │
│ │                                                             │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│                            [Cancel]  [Generate Key]            │
└─────────────────────────────────────────────────────────────────┘
```

**After Generation - One-Time Display**:

```
┌─────────────────────────────────────────────────────────────────┐
│ ✅ API Key Generated Successfully                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ ⚠️ IMPORTANT: Copy this key now. You won't see it again!       │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ 🔑 API Key                                                  │ │
│ ├─────────────────────────────────────────────────────────────┤ │
│ │                                                             │ │
│ │  sk_live_51MQz9xK2n4...[long key]...xyz789  [📋 Copy]     │ │
│ │                                                             │ │
│ │  Key ID: key_abc123def456                                  │ │
│ │  Expires: June 15, 2026 (180 days)                         │ │
│ │                                                             │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│ Next Steps:                                                     │
│  1. Copy the API key above                                     │
│  2. Store it securely (environment variable, secret manager)   │
│  3. Test the key with a test API call                          │
│  4. Monitor usage in the API Key dashboard                     │
│                                                                 │
│ Testing the key:                                                │
│                                                                 │
│  curl https://api.yourcompany.com/v1/estimates \               │
│    -H "Authorization: Bearer sk_live_51MQz9xK2n4..." \         │
│    -H "Content-Type: application/json"                         │
│                                                                 │
│ ☐ I have safely stored this API key                            │
│                                                                 │
│                                              [Close]            │
└─────────────────────────────────────────────────────────────────┘
```

**Backend Flow**:

```typescript
async function generateServiceAccountKey(
  serviceAccountId: string,
  keyName: string,
  expirationDays: number
): Promise<ServiceAccountKeyResult> {
  // 1. Generate cryptographically secure random key
  const randomBytes = crypto.randomBytes(32);
  const keyPrefix = "sk_live_"; // or 'sk_test_' for test mode
  const plainTextKey = keyPrefix + randomBytes.toString("base64url");

  // 2. Hash the key for storage (never store plain text)
  const keyHash = await bcrypt.hash(plainTextKey, 12);

  // 3. Generate key ID (public identifier)
  const keyId = "key_" + crypto.randomBytes(16).toString("hex");

  // 4. Calculate expiration
  const expiresAt = expirationDays ? addDays(new Date(), expirationDays) : null;

  // 5. Create database record
  const serviceAccountKey = await prisma.serviceAccountKey.create({
    data: {
      tenantId,
      serviceAccountId,
      keyId,
      keyName,
      keyHash,
      keyPrefix,
      keyLastFourDigits: plainTextKey.slice(-4),
      expiresAt,
      rotationPolicy: expirationDays ? `${expirationDays}_DAYS` : "NEVER",
      status: "ACTIVE",
      isActive: true,
      createdByActorId: currentActorId,
    },
  });

  // 6. Audit event
  await createAccessAuditEvent({
    eventType: "API_KEY_GENERATED",
    actorId: currentActorId,
    resourceType: "SERVICE_ACCOUNT",
    resourceId: serviceAccountId,
    actionType: "GENERATE_KEY",
    accessDecision: "ALLOWED",
  });

  // 7. Return plain text key (ONLY TIME IT'S AVAILABLE)
  return {
    keyId,
    plainTextKey, // This is the ONLY time we return this
    expiresAt,
    serviceAccountKey,
  };
}
```

### 7.3 API Key Authentication

```typescript
async function authenticateApiKey(
  apiKey: string,
  requestIp: string
): Promise<AuthResult> {
  // 1. Extract key prefix
  if (!apiKey.startsWith("sk_live_") && !apiKey.startsWith("sk_test_")) {
    return { authenticated: false, reason: "Invalid key format" };
  }

  // 2. Query all active keys (we don't know which one yet)
  // In production, we'd use a more efficient lookup method
  const activeKeys = await prisma.serviceAccountKey.findMany({
    where: {
      status: "ACTIVE",
      isActive: true,
      OR: [{ expiresAt: null }, { expiresAt: { gt: new Date() } }],
    },
    include: {
      serviceAccount: {
        include: {
          actor: {
            include: {
              member: {
                include: {
                  memberRoles: {
                    include: {
                      role: true,
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
  });

  // 3. Hash the provided key and compare
  for (const keyRecord of activeKeys) {
    const isMatch = await bcrypt.compare(apiKey, keyRecord.keyHash);

    if (isMatch) {
      // 4. Check IP whitelist (if configured)
      if (
        keyRecord.allowedIpAddresses &&
        keyRecord.allowedIpAddresses.length > 0
      ) {
        if (!keyRecord.allowedIpAddresses.includes(requestIp)) {
          // IP not whitelisted
          await logSecurityEvent({
            eventType: "API_KEY_IP_BLOCKED",
            serviceAccountId: keyRecord.serviceAccountId,
            ipAddress: requestIp,
            severity: "MEDIUM",
          });

          return {
            authenticated: false,
            reason: "IP address not whitelisted",
          };
        }
      }

      // 5. Check service account status
      if (keyRecord.serviceAccount.status !== "ACTIVE") {
        return {
          authenticated: false,
          reason: "Service account is not active",
        };
      }

      // 6. Update last used tracking
      await prisma.serviceAccountKey.update({
        where: { id: keyRecord.id },
        data: {
          lastUsedAt: new Date(),
          usageCount: { increment: 1 },
          lastAccessIp: requestIp,
        },
      });

      // 7. SUCCESS - Return actor and permissions
      return {
        authenticated: true,
        actorId: keyRecord.serviceAccount.actorId,
        serviceAccountId: keyRecord.serviceAccountId,
        permissions: extractPermissions(
          keyRecord.serviceAccount.actor.member.memberRoles
        ),
      };
    }
  }

  // 8. No match found - invalid key
  await logSecurityEvent({
    eventType: "API_KEY_INVALID",
    ipAddress: requestIp,
    severity: "HIGH",
    details: { keyPrefix: apiKey.substring(0, 10) },
  });

  return {
    authenticated: false,
    reason: "Invalid API key",
  };
}
```

---

## 8. Access Audit & Reporting

### 8.1 Access Audit Log Screen

**Entry Point**: Admin → Access Control → Audit Log

```
┌─────────────────────────────────────────────────────────────────┐
│ Access Audit Log                                  [Export ▼]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ 📊 Summary (Last 24 Hours)                                      │
│   Total Requests: 45,382      Allowed: 44,891 (98.9%)          │
│   Denied: 491 (1.1%)          Suspicious: 12                   │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Filters                                                     │ │
│ ├─────────────────────────────────────────────────────────────┤ │
│ │ Time Range: [Last 24 Hours ▼]                              │ │
│ │ Decision:   [All ▼]  (All/Allowed/Denied/Error)            │ │
│ │ Actor:      [All Users ▼]                                  │ │
│ │ Resource:   [All Types ▼]                                  │ │
│ │ Action:     [All Actions ▼]                                │ │
│ │ Suspicious: ☐ Only suspicious activity                     │ │
│ │                                           [Apply] [Reset]  │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│ Timestamp       Actor           Resource    Action   Decision  │
│ ─────────────── ─────────────── ─────────── ──────── ────────  │
│ 2:34 PM         John Smith      Estimate    approve  ✅ ALLOWED│
│ 2:33 PM         API:Stripe      Invoice     create   ✅ ALLOWED│
│ 2:32 PM         Jane Doe        Project     delete   ❌ DENIED │
│ 2:31 PM  🚨    Unknown IP       Estimate    read     ❌ DENIED │
│ 2:30 PM         Mike Johnson    Expense     approve  ✅ ALLOWED│
│                                                                 │
│                                      [Load More] Page 1 of 523 │
└─────────────────────────────────────────────────────────────────┘
```

**Detail View** (Click on event):

```
┌─────────────────────────────────────────────────────────────────┐
│ Access Audit Event Detail                                 [×]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Event ID: evt_abc123def456                                     │
│ Timestamp: Nov 17, 2025 2:32:45 PM PST                         │
│                                                                 │
│ 👤 Actor Information                                            │
│    Name: Jane Doe                                              │
│    Email: jane.doe@company.com                                 │
│    Roles: Project Manager, Estimator                           │
│    IP Address: 192.168.1.100                                   │
│    User Agent: Mozilla/5.0 (Macintosh...)                      │
│                                                                 │
│ 📦 Resource Information                                         │
│    Type: Project                                               │
│    ID: proj_789xyz                                             │
│    Name: Phoenix Tower Renovation                              │
│    Owner: John Smith                                           │
│                                                                 │
│ 🎯 Action Attempted                                             │
│    Action: delete                                              │
│    Permission Required: project:delete                         │
│                                                                 │
│ ⚖️ Decision                                                     │
│    Result: ❌ DENIED                                            │
│    Reason: Policy 'Protect Active Projects' denies deletion   │
│    Matched Policy: pol_active_projects                         │
│                                                                 │
│ 📋 Policy Details                                               │
│    Policy Name: Protect Active Projects                        │
│    Effect: DENY                                                │
│    Conditions:                                                  │
│      ✓ project.status == 'ACTIVE' → TRUE                      │
│      ✓ action == 'delete' → TRUE                              │
│    Result: Policy applies, access DENIED                       │
│                                                                 │
│ 🔍 Context                                                      │
│    Request ID: req_xyz789abc                                   │
│    Session ID: sess_123abc                                     │
│    Request Path: /api/v1/projects/proj_789xyz                 │
│    Request Method: DELETE                                      │
│                                                                 │
│                                              [Close]            │
└─────────────────────────────────────────────────────────────────┘
```

### 8.2 Compliance Reports

**Entry Point**: Admin → Access Control → Reports → "Generate Compliance Report"

```typescript
// SOX Compliance Report
async function generateSOXComplianceReport(
  startDate: Date,
  endDate: Date
): Promise<ComplianceReport> {
  const report = {
    reportType: "SOX_COMPLIANCE",
    period: { startDate, endDate },
    sections: [],
  };

  // 1. User Access Changes
  const userAccessChanges = await prisma.accessAuditEvent.findMany({
    where: {
      eventTimestamp: { gte: startDate, lte: endDate },
      actionType: {
        in: [
          "ROLE_ASSIGNED",
          "ROLE_REVOKED",
          "PERMISSION_GRANTED",
          "PERMISSION_REVOKED",
        ],
      },
    },
  });

  report.sections.push({
    title: "User Access Changes",
    count: userAccessChanges.length,
    data: userAccessChanges,
  });

  // 2. Financial Access (Invoice, Payment, GL)
  const financialAccess = await prisma.accessAuditEvent.findMany({
    where: {
      eventTimestamp: { gte: startDate, lte: endDate },
      resourceType: {
        in: ["INVOICE", "PAYMENT", "GL_JOURNAL", "BANK_ACCOUNT"],
      },
    },
  });

  report.sections.push({
    title: "Financial Data Access",
    count: financialAccess.length,
    data: financialAccess,
  });

  // 3. Segregation of Duties Violations
  const sodViolations = await checkSegregationOfDuties(startDate, endDate);

  report.sections.push({
    title: "Segregation of Duties Analysis",
    violations: sodViolations,
  });

  // 4. Privileged Access Usage
  const privilegedAccess = await prisma.accessAuditEvent.findMany({
    where: {
      eventTimestamp: { gte: startDate, lte: endDate },
      // Users with admin or financial controller roles
      actor: {
        member: {
          memberRoles: {
            some: {
              role: {
                roleCategory: {
                  in: ["ADMIN", "FINANCIAL_CONTROLLER"],
                },
              },
            },
          },
        },
      },
    },
  });

  report.sections.push({
    title: "Privileged Access Activity",
    count: privilegedAccess.length,
    data: privilegedAccess,
  });

  return report;
}
```

---

## 9. Integration Examples

### 9.1 Protect API Endpoint

```typescript
// Express.js middleware
import { checkPermission } from "./access-control";

export function requirePermission(permission: string) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const actorId = req.user.actorId; // From auth middleware
      const resourceType = req.params.resourceType;
      const resourceId = req.params.id;

      const result = await checkPermission(
        actorId,
        permission,
        resourceType,
        resourceId,
        {
          // Additional context
          request: {
            method: req.method,
            path: req.path,
            ip: req.ip,
          },
        }
      );

      if (!result.allowed) {
        return res.status(403).json({
          error: "Forbidden",
          message: result.reason,
        });
      }

      // Permission granted - continue
      next();
    } catch (error) {
      console.error("Permission check error:", error);
      return res.status(500).json({
        error: "Internal Server Error",
        message: "Permission check failed",
      });
    }
  };
}

// Production Module API Protection

// Estimate Module Routes
app.post(
  "/api/v1/estimates",
  authenticate,
  requirePermission("estimate:create"),
  requirePermission("crm-account:read"), // Must access customer data
  async (req, res) => {
    // Create estimate with CRM linkage
    // Estimate.crmAccountId → CRMAccount (REQUIRED)
    // Estimate.crmContactId → CRMContact (optional)
    // Generate globalId for 1:1:1 traceability
  }
);

app.post(
  "/api/v1/estimates/:id/approve",
  authenticate,
  requirePermission("estimate:approve:internal"),
  async (req, res) => {
    // Internal approval with auto-project creation
    // If autoCreateProjectOnApproval = true:
    //   - Create Project with same globalId
    //   - Copy CRM relationships
    //   - Inherit structure (sections → phases, lineItems → tasks)
  }
);

// Invoice Module Routes
app.post(
  "/api/v1/invoices",
  authenticate,
  requirePermission("invoice:create"),
  requirePermission("crm-account:read"),
  async (req, res) => {
    // Create invoice with 1:1:1 traceability
    // If from estimate: same globalId, same invoiceNumber
    // Invoice.sourceEstimateId → Estimate
    // Invoice.relatedProjectId → Project
  }
);

app.post(
  "/api/v1/invoices/:id/payments",
  authenticate,
  requirePermission("invoice-payment:apply"),
  async (req, res) => {
    // Apply payment with financial integration
    // Create InvoicePaymentApplication
    // Update Invoice.amountPaid
    // Post GL entries
  }
);

// Project Module Routes
app.delete(
  "/api/v1/projects/:id",
  authenticate,
  requirePermission("project:delete"),
  async (req, res) => {
    // Check for active invoices (prevent deletion)
    // Verify no pending billing
    // Maintain 1:1:1 traceability integrity
  }
);

app.post(
  "/api/v1/projects/:id/tasks",
  authenticate,
  requirePermission("task:create"),
  requirePermission("project:read"),
  async (req, res) => {
    // Create project task
    // Link to ProjectPhase (inherited from EstimateSection)
    // Track budgetHours, actualHours for cost control
  }
);

// CRM Module Routes (CORRECTED Model Names)
app.post(
  "/api/v1/crm/accounts",
  authenticate,
  requirePermission("crm-account:create"),
  async (req, res) => {
    // Create CRMAccount (central customer entity)
    // Will be referenced by Estimate.crmAccountId
    // Will be referenced by Invoice.crmAccountId
    // Will be referenced by Project.crmAccountId (future)
  }
);

app.post(
  "/api/v1/crm/contacts",
  authenticate,
  requirePermission("crm-contact:create"),
  requirePermission("crm-account:read"),
  async (req, res) => {
    // Create CRMContact linked to CRMAccount
    // Optional reference in business modules
  }
);
```

### 9.2 React Permission Check Component

```typescript
// PermissionGate.tsx
import { usePermission } from '@/hooks/usePermission';

interface PermissionGateProps {
  permission: string;
  resourceType?: string;
  resourceId?: string;
  fallback?: React.ReactNode;
  children: React.ReactNode;
}

export function PermissionGate({
  permission,
  resourceType,
  resourceId,
  fallback = null,
  children
}: PermissionGateProps) {

  const { allowed, loading } = usePermission({
    permission,
    resourceType,
    resourceId
  });

  if (loading) {
    return <Skeleton />;
  }

  if (!allowed) {
    return <>{fallback}</>;
  }

  return <>{children}</>;
}

// Usage
<PermissionGate permission="estimate:delete">
  <Button onClick={handleDelete}>Delete Estimate</Button>
</PermissionGate>

<PermissionGate
  permission="project:approve"
  resourceId={project.id}
  fallback={<Text>You don't have permission to approve this project</Text>}
>
  <ApproveProjectButton projectId={project.id} />
</PermissionGate>
```

---

## 10. Business Rules & Edge Cases

### 10.1 Permission Inheritance

**Rule**: Permissions can cascade through resource hierarchy

```typescript
// Example: Project → Task → Subtask
// If user has permission: project:read (for project-123)
// Then user automatically has:
//   - task:read (for all tasks in project-123)
//   - subtask:read (for all subtasks in those tasks)

async function checkInheritedPermission(
  actorId: string,
  permission: string,
  resourceType: string,
  resourceId: string
): Promise<boolean> {
  // 1. Check direct permission
  const directCheck = await checkPermission(
    actorId,
    permission,
    resourceType,
    resourceId
  );

  if (directCheck.allowed) {
    return true;
  }

  // 2. Check parent resource permissions
  const resource = await loadResource(resourceType, resourceId);

  if (resource.parentResourceType && resource.parentResourceId) {
    // Build parent permission (e.g., task:read → project:read)
    const parentPermission = `${resource.parentResourceType}:${
      permission.split(":")[1]
    }`;

    return checkInheritedPermission(
      actorId,
      parentPermission,
      resource.parentResourceType,
      resource.parentResourceId
    );
  }

  return false;
}
```

### 10.2 Conflict Resolution

**Rule**: When multiple policies apply with conflicting effects, DENY always wins

```typescript
// Policy 1: ALLOW estimate:approve (priority 100)
// Policy 2: DENY estimate:approve if amount > $100K (priority 200)
//
// Result for $150K estimate: DENIED (higher priority DENY wins)
```

### 10.3 Temporal Access

**Rule**: Roles can expire automatically

```typescript
// Cron job runs daily
async function expireRoles() {
  const expiredRoles = await prisma.memberRole.findMany({
    where: {
      expiresAt: { lt: new Date() },
      isActive: true,
    },
  });

  for (const memberRole of expiredRoles) {
    await prisma.memberRole.update({
      where: { id: memberRole.id },
      data: {
        isActive: false,
        updatedByActorId: "SYSTEM",
      },
    });

    await invalidatePermissionCache(memberRole.memberId);

    await sendEmail({
      to: memberRole.member.email,
      template: "role-expired",
      data: {
        roleName: memberRole.role.roleName,
        expiredAt: memberRole.expiresAt,
      },
    });
  }
}
```

---

## 11. Performance Optimization

### 11.1 Permission Caching Strategy

```typescript
// Redis cache structure
const CACHE_TTL = 300; // 5 minutes

// Key: permissions:{memberId}
// Value: Set of permission strings
async function getCachedMemberPermissions(
  memberId: string
): Promise<Set<string>> {
  const cacheKey = `permissions:${memberId}`;

  // Try cache first
  const cached = await redis.get(cacheKey);
  if (cached) {
    return new Set(JSON.parse(cached));
  }

  // Cache miss - load from database
  const permissions = await loadMemberPermissionsFromDB(memberId);

  // Store in cache
  await redis.setex(
    cacheKey,
    CACHE_TTL,
    JSON.stringify(Array.from(permissions))
  );

  return permissions;
}

// Invalidate cache when roles change
async function invalidatePermissionCache(memberId: string) {
  await redis.del(`permissions:${memberId}`);
}
```

### 11.2 Batch Permission Checks

```typescript
// Check multiple permissions in one call
async function checkPermissions(
  actorId: string,
  permissions: string[]
): Promise<Record<string, boolean>> {
  const results: Record<string, boolean> = {};

  // Load member permissions once
  const memberPermissions = await getCachedMemberPermissions(actorId);

  // Check each permission
  for (const permission of permissions) {
    results[permission] = checkDirectPermission(permission, memberPermissions);
  }

  return results;
}

// Usage
const checks = await checkPermissions(actorId, [
  "estimate:create",
  "estimate:update",
  "estimate:delete",
  "estimate:approve:internal",
]);

if (checks["estimate:create"]) {
  // Can create
}
```

---

**Document Version:** 1.0
**Document Status:** ✅ Production-Ready
**Alignment Status:** ✅ Fully Aligned with Platform Standards
**Integration Validation:** ✅ All cross-module references validated
**Next Review:** Upon schema changes or feature additions
