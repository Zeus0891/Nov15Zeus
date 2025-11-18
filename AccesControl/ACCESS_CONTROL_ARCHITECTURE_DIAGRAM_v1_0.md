# 📊 Access Control Module - Arquitectura Visual

**Version:** 1.0  
**Last Updated:** November 17, 2025  
**Module**: accesscontrol.prisma  
**Aligned with**: Estimate v8.0, Invoice v8.0, Project v2.0, Inventory v1.0, Expense v1.0  
**Total Models**: 12

---

## 🏗️ Diagrama de Estructura Completa

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Role (Reference Entity)                            │
│                            Pattern: A (Lightweight)                          │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                │                     │                     │
                ▼                     ▼                     ▼
        ┌───────────────┐     ┌───────────────┐   ┌──────────────┐
        │   IDENTITY    │     │   LIFECYCLE   │   │ GOVERNANCE   │
        ├───────────────┤     ├───────────────┤   ├──────────────┤
        │ id (UUID v7)  │     │ isActive      │   │ auditCorr... │
        │ tenantId      │     │ createdAt     │   │ metadata     │
        │               │     │ updatedAt     │   │              │
        │               │     │ deletedAt     │   │              │
        └───────────────┘     └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         ACTOR ATTRIBUTION (Enabled)                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ createdByActorId → Actor  |  updatedByActorId → Actor  |  deletedByActorId  │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUSINESS DIMENSIONS                                │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► 📄 ROLE IDENTITY
        │   ├── roleName (REQUIRED, unique per tenant)
        │   ├── roleCode (system identifier)
        │   ├── description
        │   └── displayName
        │
        ├─► 📊 ROLE TYPE
        │   ├── roleType (SYSTEM|CUSTOM|TEMPLATE)
        │   ├── roleCategory (ADMIN|MANAGER|USER|VIEWER|FIELD|INTEGRATION)
        │   └── hierarchyLevel (0-10, for role precedence)
        │
        ├─► 🏢 SCOPE
        │   ├── scopeType (TENANT|PROJECT|DEPARTMENT|CUSTOM)
        │   ├── isGlobalRole (applies to all resources)
        │   └── isInheritable (cascade to child resources)
        │
        ├─► 🔒 PERMISSIONS
        │   ├── permissionCount (denormalized)
        │   └── hasWildcardPermission (*.*)
        │
        └─► ⚙️ BEHAVIOR FLAGS
            ├── isActive
            ├── isSystemRole (cannot be deleted)
            ├── isTemplate (can be cloned)
            ├── requiresMFA (enforce multi-factor)
            ├── allowSelfAssignment
            └── isDefault (auto-assigned to new members)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         CHILD RELATIONS (2 types)                            │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► RolePermission[] (permission assignments)
        └─► MemberRole[] (member assignments)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         INDEX STRATEGY (10 indexes)                          │
└─────────────────────────────────────────────────────────────────────────────┘

    🔑 PRIMARY CONSTRAINTS (2)
       ├── [tenantId, id]
       └── [tenantId, roleName]

    🔍 COMMON FILTERS (3)
       ├── [tenantId, roleType]
       ├── [tenantId, roleCategory]
       └── [tenantId, isActive]

    ⏰ TEMPORAL (2 BRIN)
       ├── [createdAt]
       └── [updatedAt]

    📈 GOVERNANCE (3)
       ├── [tenantId, auditCorrelationId]
       ├── [tenantId, isSystemRole]
       └── [tenantId, deletedAt]
```

---

## 🔐 Permission (Reference Entity)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Permission (Reference Entity)                         │
│                            Pattern: A (Lightweight)                          │
└─────────────────────────────────────────────────────────────────────────────┘

    IDENTITY
    ├── id (UUID v7)
    └── tenantId (GLOBAL permissions have null tenantId)

    PERMISSION IDENTITY
    ├── permissionName (REQUIRED, unique)
    ├── permissionCode (e.g., "estimate:create")
    ├── description
    └── displayName

    RESOURCE & ACTION
    ├── resourceType (ESTIMATE|PROJECT|INVOICE|EXPENSE|etc.)
    ├── actionType (CREATE|READ|UPDATE|DELETE|APPROVE|EXPORT)
    ├── resourcePattern (e.g., "estimate:*", "project:123", "*:*")
    └── actionPattern (e.g., "estimate:create,read,update")

    SCOPE
    ├── scopeLevel (TENANT|PROJECT|DEPARTMENT|RESOURCE|FIELD)
    ├── requiresOwnership (can only act on own records)
    └── requiresExplicitGrant (cannot be inherited)

    PERMISSION CATEGORIES
    └── category (CORE|FINANCIAL|OPERATIONAL|ADMINISTRATIVE|REPORTING)

    STATUS
    ├── isActive
    ├── isSystemPermission (cannot be deleted)
    └── isDeprecated

    DEPENDENCIES
    ├── dependsOnPermissions[] (array of permission codes)
    └── conflictsWithPermissions[] (mutually exclusive)

    EXAMPLES:
    ├── estimate:create (Create estimates)
    ├── estimate:approve:internal (Internal approval)
    ├── project:read:all (Read all projects in tenant)
    ├── invoice:delete:own (Delete own invoices only)
    └── *:* (Super admin - all permissions)

    INDEXES (8)
    ├── [tenantId, id]
    ├── [tenantId, permissionName]
    ├── [tenantId, permissionCode]
    ├── [tenantId, resourceType]
    ├── [tenantId, actionType]
    ├── [tenantId, scopeLevel]
    ├── [tenantId, isActive]
    └── [tenantId, deletedAt]
```

---

## 🔗 RolePermission (Junction Table)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      RolePermission (Pattern A - Junction)                   │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATIONS
    ├── roleId → Role
    └── permissionId → Permission

    GRANT DETAILS
    ├── grantedAt
    ├── grantedByActorId → Actor
    └── expiresAt (optional, for temporary grants)

    CONSTRAINTS
    └── constraints (JSON) - Additional conditions
        Examples:
        - { "projects": ["proj-123", "proj-456"] }
        - { "maxAmount": 10000 }
        - { "departments": ["engineering"] }

    STATUS
    └── isActive (can be temporarily disabled)

    INDEXES (5)
    ├── [tenantId, roleId]
    ├── [tenantId, permissionId]
    ├── [tenantId, roleId, permissionId] (unique)
    ├── [expiresAt]
    └── [isActive]
```

---

## 👤 MemberRole (Pattern A - Junction)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       MemberRole (Pattern A - Junction)                      │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATIONS
    ├── memberId → Member
    └── roleId → Role

    ASSIGNMENT DETAILS
    ├── assignedAt
    ├── assignedByActorId → Actor
    ├── expiresAt (optional, for temporary assignments)
    └── assignmentReason

    SCOPE (Optional Resource Restriction)
    ├── scopeType (PROJECT|DEPARTMENT|LOCATION|CUSTOM)
    ├── scopeResourceType
    ├── scopeResourceId
    └── scopeConditions (JSON)
        Examples:
        - { "projectIds": ["proj-123"] } - PM only for specific project
        - { "departmentCode": "ENG" } - Manager only for Engineering
        - { "locationIds": ["loc-1", "loc-2"] } - Supervisor for specific sites

    STATUS
    ├── isActive
    └── isPrimary (primary role for user)

    INDEXES (7)
    ├── [tenantId, id]
    ├── [tenantId, memberId]
    ├── [tenantId, roleId]
    ├── [tenantId, memberId, roleId] (unique if no scope)
    ├── [expiresAt]
    ├── [isActive]
    └── [isPrimary]
```

---

## 📋 AccessPolicy (Pattern A - Advanced Rules)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       AccessPolicy (Pattern A - Config)                      │
└─────────────────────────────────────────────────────────────────────────────┘

    POLICY IDENTITY
    ├── policyName (unique)
    ├── policyCode
    ├── description
    └── displayName

    POLICY TYPE
    ├── policyType (RBAC|ABAC|RULE_BASED|TEMPORAL|CONDITIONAL)
    └── enforcementMode (ENFORCE|AUDIT|PERMISSIVE)

    RESOURCE TARGET
    ├── resourceType (ESTIMATE|PROJECT|INVOICE|EXPENSE|DOCUMENT|etc.)
    ├── resourcePattern (glob pattern, e.g., "project:*")
    └── resourceScope (TENANT|PROJECT|DEPARTMENT)

    ACTION TARGET
    ├── actionType (CREATE|READ|UPDATE|DELETE|APPROVE|EXPORT)
    ├── actionPattern
    └── allowedActions[] (array)

    EFFECT
    ├── effect (ALLOW|DENY)
    └── priority (for conflict resolution, higher wins)

    CONDITIONS
    └── Has many AccessPolicyCondition (evaluated at runtime)

    STATUS
    ├── isActive
    ├── isSystemPolicy (cannot be deleted)
    └── effectiveFromDate, effectiveUntilDate

    EXAMPLES:
    ├── "Project Managers can approve estimates under $50K"
    ├── "Users can only edit their own expense reports"
    ├── "Deny invoice deletion after approval"
    └── "Allow document export only during business hours"

    INDEXES (8)
    ├── [tenantId, id]
    ├── [tenantId, policyName]
    ├── [tenantId, policyType]
    ├── [tenantId, resourceType]
    ├── [tenantId, effect]
    ├── [tenantId, isActive]
    ├── [priority]
    └── [effectiveFromDate, effectiveUntilDate]
```

---

## ⚙️ AccessPolicyCondition (Pattern A - Child)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                  AccessPolicyCondition (Pattern A - Child)                   │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── accessPolicyId → AccessPolicy

    CONDITION IDENTITY
    ├── conditionName
    └── conditionType (ATTRIBUTE|TEMPORAL|RESOURCE|CONTEXT|CUSTOM)

    CONDITION EXPRESSION
    ├── attributeName (e.g., "project.status", "user.department")
    ├── operator (EQUALS|NOT_EQUALS|GREATER_THAN|LESS_THAN|IN|NOT_IN|
    │              CONTAINS|STARTS_WITH|REGEX|EXISTS)
    ├── value (comparison value)
    └── values[] (for IN/NOT_IN operators)

    LOGICAL OPERATORS
    ├── logicalOperator (AND|OR|NOT)
    └── conditionGroup (for complex expressions)

    EXAMPLES:
    ├── project.totalAmount < 50000
    ├── estimate.status IN ['DRAFT', 'PENDING_APPROVAL']
    ├── user.department == resource.department
    ├── currentTime BETWEEN '09:00' AND '17:00'
    └── user.roles CONTAINS 'PROJECT_MANAGER'

    STATUS
    └── isActive

    INDEXES (4)
    ├── [tenantId, accessPolicyId]
    ├── [conditionType]
    ├── [attributeName]
    └── [isActive]
```

---

## 🔍 AccessScope (Pattern A - Resource Scope)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      AccessScope (Pattern A - Reference)                     │
└─────────────────────────────────────────────────────────────────────────────┘

    SCOPE IDENTITY
    ├── scopeName (unique)
    ├── scopeCode
    └── description

    SCOPE DEFINITION
    ├── scopeType (TENANT|PROJECT|DEPARTMENT|LOCATION|TEAM|CUSTOM)
    ├── resourceType (what this scope applies to)
    └── scopeLevel (0-10, for hierarchy)

    HIERARCHY
    ├── parentScopeId → AccessScope (hierarchical scopes)
    └── scopePath (materialized path, e.g., "/tenant/dept/team")

    RESOURCE FILTER
    ├── resourceFilter (JSON query for filtering)
    └── includeSubScopes (inherit to children)

    EXAMPLES:
    ├── "Engineering Department" (all engineering projects)
    ├── "West Region" (all projects in western states)
    ├── "Premium Projects" (projects > $1M)
    └── "Active Projects" (status = ACTIVE)

    STATUS
    └── isActive

    INDEXES (6)
    ├── [tenantId, id]
    ├── [tenantId, scopeName]
    ├── [tenantId, scopeType]
    ├── [tenantId, parentScopeId]
    ├── [scopePath] (for hierarchy queries)
    └── [isActive]
```

---

## 🔗 AccessScopeAssignment (Pattern A - Junction)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                 AccessScopeAssignment (Pattern A - Junction)                 │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATIONS
    ├── accessScopeId → AccessScope
    └── Polymorphic relation:
        ├── memberRoleId → MemberRole OR
        ├── roleId → Role OR
        └── memberId → Member

    ASSIGNMENT DETAILS
    ├── assignedAt
    ├── assignedByActorId → Actor
    └── expiresAt

    GRANT TYPE
    ├── grantType (DIRECT|INHERITED|CONDITIONAL)
    └── inheritedFrom (if inherited from parent scope)

    STATUS
    └── isActive

    PURPOSE:
    Assigns scopes to roles or members, limiting what resources
    they can access within their permissions.

    Example: Project Manager role with scope "West Region Projects"
    → Can manage projects, but only in west region

    INDEXES (6)
    ├── [tenantId, id]
    ├── [tenantId, accessScopeId]
    ├── [tenantId, memberRoleId]
    ├── [tenantId, roleId]
    ├── [expiresAt]
    └── [isActive]
```

---

## 📦 AccessResource (Pattern A - Resource Registry)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AccessResource (Pattern A - Registry)                     │
└─────────────────────────────────────────────────────────────────────────────┘

    RESOURCE IDENTITY
    ├── resourceType (ESTIMATE|PROJECT|INVOICE|EXPENSE|DOCUMENT|etc.)
    ├── resourceId (UUID of the actual resource)
    └── resourceName (display name)

    RESOURCE METADATA
    ├── resourcePath (hierarchical path)
    ├── resourceOwnerMemberId → Member
    ├── resourceTenantId
    └── resourceMetadata (JSON - custom attributes)

    ACCESS CONTROL
    ├── isPublic (publicly accessible)
    ├── isShared (shared with other members)
    ├── defaultAccessLevel (READ|WRITE|ADMIN|NONE)
    └── inheritFromParent (inherit parent resource permissions)

    PARENT RESOURCE
    ├── parentResourceType
    └── parentResourceId
        Example: EstimateLineItem inherits from Estimate

    STATUS
    └── isActive

    PURPOSE:
    Centralized registry of all access-controlled resources
    Enables resource-level permission checks

    INDEXES (8)
    ├── [tenantId, id]
    ├── [tenantId, resourceType, resourceId] (unique)
    ├── [tenantId, resourceType]
    ├── [tenantId, resourceOwnerMemberId]
    ├── [resourcePath] (for hierarchy queries)
    ├── [parentResourceType, parentResourceId]
    ├── [isPublic]
    └── [isActive]
```

---

## 📊 AccessAuditEvent (Pattern A - Audit Trail)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   AccessAuditEvent (Pattern A - Audit Trail)                 │
└─────────────────────────────────────────────────────────────────────────────┘

    EVENT IDENTITY
    ├── eventId (UUID v7)
    └── eventTimestamp

    ACTOR INFO
    ├── actorId → Actor
    ├── actorType (USER|SERVICE_ACCOUNT|SYSTEM)
    ├── actorIpAddress
    ├── actorUserAgent
    └── actorLocation (geolocation)

    ACCESS ATTEMPT
    ├── resourceType
    ├── resourceId
    ├── actionType (CREATE|READ|UPDATE|DELETE|APPROVE|etc.)
    └── actionDescription

    DECISION
    ├── accessDecision (ALLOWED|DENIED|ERROR)
    ├── decisionReason
    ├── matchedPolicyId → AccessPolicy (which policy determined outcome)
    ├── matchedRoleId → Role
    └── matchedPermissionId → Permission

    CONTEXT
    ├── requestId (correlation)
    ├── sessionId
    ├── requestPath (API endpoint)
    ├── requestMethod (GET|POST|PUT|DELETE)
    └── requestPayload (JSON - sensitive data redacted)

    SECURITY
    ├── isSuspicious (flagged by anomaly detection)
    ├── riskScore (0-100)
    └── securityEventId → SecurityEvent (if security incident)

    COMPLIANCE
    └── retentionUntilDate (regulatory compliance)

    PURPOSE:
    Complete audit trail of all access control decisions
    Required for: SOX, GDPR, HIPAA, PCI-DSS compliance

    INDEXES (12)
    ├── [tenantId, eventTimestamp] BRIN
    ├── [tenantId, actorId, eventTimestamp]
    ├── [tenantId, resourceType, resourceId]
    ├── [tenantId, actionType]
    ├── [tenantId, accessDecision]
    ├── [requestId]
    ├── [sessionId]
    ├── [isSuspicious]
    ├── [riskScore]
    ├── [eventTimestamp] BRIN (for partitioning)
    ├── [actorIpAddress]
    └── [retentionUntilDate]
```

---

## 🔑 ServiceAccount (Pattern A - System User)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     ServiceAccount (Pattern A - Identity)                    │
└─────────────────────────────────────────────────────────────────────────────┘

    IDENTITY
    ├── id (UUID v7)
    └── tenantId

    ACCOUNT IDENTITY
    ├── serviceAccountName (unique)
    ├── serviceAccountEmail (e.g., sa-integration@tenant.com)
    ├── description
    └── displayName

    ACCOUNT TYPE
    ├── accountType (API_INTEGRATION|WEBHOOK|CRON_JOB|SYSTEM_SERVICE)
    └── serviceCategory (EXTERNAL_INTEGRATION|INTERNAL_AUTOMATION|
                         DATA_SYNC|REPORTING|MONITORING)

    ACTOR LINKAGE
    └── actorId → Actor (service accounts ARE actors)

    OWNERSHIP
    ├── createdByMemberId → Member
    └── ownerMemberId → Member (who manages this account)

    PERMISSIONS
    ├── Has many MemberRole (via Actor → Member mapping)
    └── Has many ServiceAccountKey (API keys)

    IP RESTRICTIONS
    ├── allowedIpAddresses[] (whitelist)
    └── allowedDomains[] (for webhooks)

    RATE LIMITING
    ├── requestsPerMinute
    ├── requestsPerHour
    └── requestsPerDay

    STATUS
    ├── status (ACTIVE|SUSPENDED|REVOKED|EXPIRED)
    ├── isActive
    ├── activatedAt
    ├── suspendedAt
    ├── revokedAt
    └── expiresAt

    SECURITY
    ├── lastUsedAt
    ├── lastAccessIp
    └── failedAuthCount

    EXAMPLES:
    ├── "Stripe Webhook Handler"
    ├── "Nightly Backup Service"
    ├── "Mobile App Integration"
    └── "Data Sync - QuickBooks"

    INDEXES (8)
    ├── [tenantId, id]
    ├── [tenantId, serviceAccountName]
    ├── [tenantId, serviceAccountEmail]
    ├── [tenantId, accountType]
    ├── [tenantId, status]
    ├── [actorId]
    ├── [expiresAt]
    └── [lastUsedAt]
```

---

## 🔐 ServiceAccountKey (Pattern A - API Keys)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   ServiceAccountKey (Pattern A - API Keys)                   │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── serviceAccountId → ServiceAccount

    KEY IDENTITY
    ├── keyId (public identifier)
    ├── keyName (e.g., "Production API Key")
    └── keyDescription

    KEY MATERIAL (Encrypted)
    ├── keyHash (bcrypt of actual key)
    ├── keyPrefix (e.g., "sk_live_" - visible to user)
    └── keyLastFourDigits (for identification)

    SCOPE
    ├── scopePermissions[] (subset of service account permissions)
    └── scopeResources[] (limit to specific resources)

    LIFECYCLE
    ├── createdAt
    ├── createdByActorId → Actor
    ├── expiresAt
    ├── lastRotatedAt
    └── rotationPolicy (NEVER|30_DAYS|60_DAYS|90_DAYS|180_DAYS|365_DAYS)

    STATUS
    ├── status (ACTIVE|EXPIRED|REVOKED|COMPROMISED)
    ├── isActive
    └── revokedAt

    USAGE TRACKING
    ├── lastUsedAt
    ├── usageCount
    ├── lastAccessIp
    └── lastAccessLocation

    SECURITY
    ├── allowedIpAddresses[] (whitelist, can override service account)
    ├── requiresMTLS (mutual TLS required)
    └── isCompromised (marked if leaked)

    PURPOSE:
    API keys for service account authentication
    Similar to AWS IAM Access Keys

    SECURITY BEST PRACTICES:
    ├── Keys are hashed (never stored in plain text)
    ├── Actual key shown ONLY on creation (one time)
    ├── Automatic expiration enforced
    ├── IP whitelisting supported
    └── Usage tracked for anomaly detection

    INDEXES (8)
    ├── [tenantId, id]
    ├── [tenantId, serviceAccountId]
    ├── [keyId] (for lookups during auth)
    ├── [keyHash] (for validation)
    ├── [status]
    ├── [expiresAt]
    ├── [lastUsedAt]
    └── [isActive]
```

---

## 🔄 ACCESS CONTROL FLOW DIAGRAMS

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PERMISSION CHECK FLOW                                │
└─────────────────────────────────────────────────────────────────────────────┘

    User attempts action on resource
              │
              ▼
    ┌─────────────────────────┐
    │ Identify Actor          │  ← From session/API key
    │ (User or ServiceAccount)│
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Load Member + Roles     │  ← Get all MemberRole
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Load Role Permissions   │  ← Get all RolePermission
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Check Direct Permission │  ← Does user have permission?
    └──────────┬──────────────┘
               │
               ├──► YES ──► Continue to Policy Check
               │
               ▼
    ┌─────────────────────────┐
    │ Check Access Policies   │  ← Evaluate AccessPolicy + Conditions
    └──────────┬──────────────┘
               │
               ├──► ALLOW ──► GRANT ACCESS
               │
               ├──► DENY ──► DENY ACCESS
               │
               ▼
    ┌─────────────────────────┐
    │ Log AccessAuditEvent    │  ← Record decision
    └──────────┬──────────────┘
               │
               ▼
    Return decision to caller

EXAMPLE: Can user approve estimate EST-2025-001?

1. Actor: User (John Smith)
2. Member: Has MemberRole → "Project Manager"
3. Role Permissions:
   - estimate:read ✓
   - estimate:update ✓
   - estimate:approve:internal ✓
4. Direct Permission Check: ✓ PASS
5. Access Policy Check:
   - Policy: "PMs can approve estimates under $50K"
   - Conditions:
     * estimate.totalAmount < 50000 → TRUE ($35K)
     * user.role == 'PROJECT_MANAGER' → TRUE
   - Effect: ALLOW
6. Decision: ✓ ALLOWED
7. Audit Event Created:
   - accessDecision: ALLOWED
   - matchedPolicyId: policy-123
   - matchedPermissionId: perm-456

┌─────────────────────────────────────────────────────────────────────────────┐
│                         ROLE ASSIGNMENT FLOW                                 │
└─────────────────────────────────────────────────────────────────────────────┘

    Admin assigns role to member
              │
              ▼
    ┌─────────────────────────┐
    │ Validate Request        │
    │ - Role exists?          │
    │ - Member exists?        │
    │ - Has permission?       │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Check Conflicts         │  ← Conflicting roles?
    └──────────┬──────────────┘
               │
               ├──► Conflict ──► Abort with error
               │
               ▼
    ┌─────────────────────────┐
    │ Create MemberRole       │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Apply AccessScope       │  ← Optional resource restrictions
    │ (if specified)          │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Invalidate Cache        │  ← Clear permission cache
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Send Notification       │  ← Notify member of new role
    └──────────┬──────────────┘
               │
               ▼
    Return success

┌─────────────────────────────────────────────────────────────────────────────┐
│                      SERVICE ACCOUNT KEY ROTATION                            │
└─────────────────────────────────────────────────────────────────────────────┘

    Key approaching expiration (7 days)
              │
              ▼
    ┌─────────────────────────┐
    │ Send Warning Email      │  ← To service account owner
    └──────────┬──────────────┘
               │
    User/System generates new key
              │
              ▼
    ┌─────────────────────────┐
    │ Create ServiceAccountKey│
    │ - Generate random key   │
    │ - Hash and store        │
    │ - Set expiration        │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Display Key ONE TIME    │  ← User must save immediately
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Update Integration      │  ← User updates their app config
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Verify New Key Works    │  ← Test API calls
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Revoke Old Key          │  ← Old key no longer valid
    └──────────┬──────────────┘
               │
               ▼
    Rotation complete
```

---

## 🔗 CROSS-MODULE INTEGRATIONS

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         INTEGRATION ARCHITECTURE                             │
└─────────────────────────────────────────────────────────────────────────────┘

    ACCESS CONTROL → IDENTITY
    ══════════════════════════
    Role/Permission → Actor (who has what access)
    MemberRole.memberId → Member
    ServiceAccount.actorId → Actor
    
    ACCESS CONTROL → ALL MODULES
    ═════════════════════════════
    Every secured operation checks permissions:
    - Estimate creation → estimate:create permission
    - Project approval → project:approve permission
    - Invoice deletion → invoice:delete permission
    - Expense submission → expense:submit permission
    
    ACCESS CONTROL → APPROVALS
    ══════════════════════════
    ApprovalRequest → Role assignments determine approvers
    Policy conditions determine approval routing
    
    ACCESS CONTROL → AUDIT
    ══════════════════════
    AccessAuditEvent → Complete audit trail
    Links to SecurityEvent for incidents
    Required for compliance (SOX, GDPR, HIPAA)
```

---

## ✅ SYSTEM ROLES (Pre-Configured)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         STANDARD ROLE HIERARCHY                              │
└─────────────────────────────────────────────────────────────────────────────┘

    SUPER_ADMIN (hierarchyLevel: 0)
    ├── Permission: *:* (all permissions)
    ├── Scope: Tenant-wide
    ├── Cannot be deleted
    └── Auto-assigned to tenant owner

    ADMIN (hierarchyLevel: 1)
    ├── Permissions: All except system configuration
    ├── Scope: Tenant-wide
    └── Can manage other roles (except SUPER_ADMIN)

    FINANCIAL_CONTROLLER (hierarchyLevel: 2)
    ├── Permissions:
    │   ├── estimate:*, invoice:*, expense:*, payment:*
    │   ├── project:read, project:financials
    │   └── reports:financial
    └── Scope: All financial operations

    PROJECT_MANAGER (hierarchyLevel: 3)
    ├── Permissions:
    │   ├── project:*, estimate:read, invoice:read
    │   ├── expense:approve (for team)
    │   └── timesheet:approve
    └── Scope: Assigned projects only

    ESTIMATOR (hierarchyLevel: 4)
    ├── Permissions:
    │   ├── estimate:create, estimate:read, estimate:update
    │   ├── estimate:approve:submit (request approval)
    │   └── project:read (limited)
    └── Scope: Own estimates + assigned

    FIELD_SUPERVISOR (hierarchyLevel: 5)
    ├── Permissions:
    │   ├── project:read, project:update (assigned)
    │   ├── timesheet:create, timesheet:approve (crew)
    │   ├── expense:submit (own)
    │   └── inventory:issue, inventory:return
    └── Scope: Assigned projects + crews

    EMPLOYEE (hierarchyLevel: 8)
    ├── Permissions:
    │   ├── timesheet:create (own)
    │   ├── expense:create (own)
    │   ├── project:read (assigned)
    │   └── document:read (public)
    └── Scope: Own records only

    VIEWER (hierarchyLevel: 9)
    ├── Permissions:
    │   └── *:read (limited visibility)
    └── Scope: Public documents only

    INTEGRATION (hierarchyLevel: 10)
    ├── Permissions: Custom per integration
    ├── Type: ServiceAccount
    └── Scope: API access only
```

---

**Document Version:** 1.0  
**Document Status:** ✅ Production-Ready  
**Alignment Status:** ✅ Fully Aligned with Platform Standards  
**Pattern Compliance:** ✅ Pattern A (all models - foundational)  
**Integration Validation:** ✅ All cross-module references validated  
**Next Review:** Upon schema changes or feature additions
