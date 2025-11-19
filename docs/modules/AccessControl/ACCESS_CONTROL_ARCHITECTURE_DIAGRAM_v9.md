# 📊 Access Control Module v9.0 - Architecture Visual Diagram

**Version:** 9.0
**Last Updated:** November 18, 2025
**Integration**: RBAC v9.0 + RLS v9.0 + Actor Pattern + TenantSettings
**Phase:** Phase 1 - Internal Members Only
**Total Models**: 26 (AccessControl: 12 + Identity: 8 + Membership: 6)
**Total Permissions**: 156 explicit permissions across 18 domains
**Source of Truth**: rbac_schema_v9.0.yml

---

## 🏗️ Complete v9.0 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           UNIVERSAL IDENTITY LAYER                           │
│                              Actor Pattern Foundation                        │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                │                     │                     │
                ▼                     ▼                     ▼
        ┌───────────────┐     ┌───────────────┐   ┌──────────────┐
        │   IDENTITY    │     │   LIFECYCLE   │   │ GOVERNANCE   │
        ├───────────────┤     ├───────────────┤   ├──────────────┤
        │ id (Global)   │     │ isActive      │   │ auditCorr... │
        │ actorType     │     │ isVerified    │   │ securityScore│
        │ actorName     │     │ lastActionAt  │   │ riskIndicators│
        │ actorCode     │     │ createdAt     │   │ metadata     │
        │               │     │ updatedAt     │   │              │
        └───────────────┘     └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    ACTOR POLYMORPHIC RELATIONS (1:1)                         │
├─────────────────────────────────────────────────────────────────────────────┤
│ Actor → User (Human Identity)     |  Actor → ServiceAccount (API Identity)  │
│ • Authentication credentials      |  • API key management                   │
│ • Profile data & preferences      |  • IP restrictions & rate limits       │
│ • Session management              |  • Usage tracking & rotation            │
│ • Device tracking                 |  • Service integration                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         ACTOR → MEMBER BRIDGE (1:M)                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ Universal Actor Identity → Tenant-Specific Member Context                    │
│ • Cross-tenant attribution       |  • Tenant-scoped permissions             │
│ • Global audit trail             |  • Role assignments                      │
│ • Business entity attribution    |  • Organizational structure              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🎭 Actor Model (Universal Identity Foundation)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            Actor (Global Identity)                           │
│                          Pattern: Universal Foundation                       │
└─────────────────────────────────────────────────────────────────────────────┘

    GLOBAL IDENTITY (Cross-Tenant)
    ├── id (UUID v7) - Global unique identifier
    └── NO tenantId - Shared across all tenants

    ACTOR CLASSIFICATION
    ├── actorType (USER|SERVICE_ACCOUNT) - Polymorphic type
    ├── actorName (Display name from User or ServiceAccount)
    ├── actorCode (Optional unique code)
    └── description (Actor description)

    SECURITY ATTRIBUTES
    ├── isActive (Can perform actions)
    ├── isVerified (Identity verified)
    ├── isSuspended (Temporarily disabled)
    ├── securityScore (0.00-1.00 security rating)
    ├── riskIndicators[] (Security risk flags)
    └── complianceFlags[] (Compliance markers)

    ACTIVITY TRACKING
    ├── totalActions (Total actions performed)
    ├── lastActionAt (Last activity timestamp)
    └── lastActionTenantId (Last tenant context)

    POLYMORPHIC RELATIONS (1:1)
    ├── user (User identity - human)
    └── serviceAccount (ServiceAccount identity - API)

    CROSS-TENANT RELATIONS (1:M)
    └── members[] (Tenant memberships)

    UNIVERSAL ATTRIBUTION (Pattern B entities)
    ├── estimatesCreated[] @relation("EstimateCreatedByActor")
    ├── estimatesUpdated[] @relation("EstimateUpdatedByActor")
    ├── estimatesDeleted[] @relation("EstimateDeletedByActor")
    ├── projectsCreated[] @relation("ProjectCreatedByActor")
    ├── projectsUpdated[] @relation("ProjectUpdatedByActor")
    ├── projectsDeleted[] @relation("ProjectDeletedByActor")
    ├── invoicesCreated[] @relation("InvoiceCreatedByActor")
    ├── invoicesUpdated[] @relation("InvoiceUpdatedByActor")
    └── invoicesDeleted[] @relation("InvoiceDeletedByActor")

    INDEXES (11)
    ├── [actorType]
    ├── [isActive]
    ├── [lastActionAt]
    ├── [status]
    ├── [securityScore]
    ├── [createdAt]
    ├── [deletedAt]
    ├── [metadata] (Gin)
    ├── [tags] (Gin)
    └── [riskIndicators] (Gin)
```

---

## 👤 User Model (Human Identity)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              User (Human Identity)                           │
│                            Pattern: Global with Actor Link                   │
└─────────────────────────────────────────────────────────────────────────────┘

    ACTOR LINKAGE
    ├── id (UUID v7)
    └── actorId → Actor (1:1 relationship)

    AUTHENTICATION CREDENTIALS
    ├── email (unique globally)
    ├── emailVerified
    ├── passwordHash (bcrypt)
    ├── passwordSalt
    ├── phone, phoneVerified
    └── MFA settings (mfaEnabled, mfaSecret, backupCodes)

    PROFILE DATA
    ├── firstName, lastName, displayName
    ├── profilePictureUrl
    ├── timezone, locale, dateFormat, timeFormat
    └── Contact preferences (emailNotifications, smsNotifications, pushNotifications)

    SECURITY TRACKING
    ├── lastLoginAt, lastLoginIp
    ├── lastPasswordChangeAt
    ├── failedLoginAttempts, lockedUntil
    ├── maxActiveSessions, requireDeviceAuth
    └── securityScore

    ACCOUNT HEALTH
    ├── isEmailBouncing, isPhoneBouncing
    └── Account status tracking

    RELATED ENTITIES
    ├── profile → UserProfile (1:1)
    ├── settings → UserSetting[] (1:M)
    ├── sessions → Session[] (1:M)
    ├── devices → UserDevice[] (1:M)
    ├── invitations → UserInvitation[] (1:M)
    └── apiKeys → UserApiKey[] (1:M)

    INDEXES (10)
    ├── [email]
    ├── [phone]
    ├── [status]
    ├── [lastLoginAt]
    ├── [isEmailBouncing]
    ├── [actorId]
    ├── [createdAt]
    ├── [deletedAt]
    └── [metadata] (Gin)
```

---

## 🏢 Member Model (Tenant-Scoped Identity)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Member (Tenant-Scoped Identity)                     │
│                             Pattern: Tenant + Actor Bridge                   │
└─────────────────────────────────────────────────────────────────────────────┘

    TENANT ISOLATION
    ├── id (UUID v7)
    └── tenantId (REQUIRED - tenant isolation)

    ACTOR BRIDGE
    └── actorId → Actor (Universal identity link)

    BUSINESS PROFILE
    ├── memberCode (Internal employee ID)
    ├── jobTitle, department, team, costCenter
    ├── startDate, endDate, probationEndDate
    ├── managerId → Member (reporting structure)
    └── managerActorId → Actor (cross-tenant manager)

    WORK INFORMATION
    ├── workEmail, workPhone, extension, workLocation
    ├── workingHoursStart, workingHoursEnd
    ├── workingDays[], timezone
    ├── payrollId, employeeType, billableRate
    └── memberType (EMPLOYEE|CONTRACTOR|CONSULTANT|TEMP)

    SECURITY CLASSIFICATION
    ├── securityLevel (STANDARD|ELEVATED|RESTRICTED)
    ├── accessLevel (NORMAL|LIMITED|EXTENDED)
    └── Permission flags (canCreateProjects, canApproveTimesheets, etc.)

    STATISTICS & ACTIVITY
    ├── totalProjectsAssigned, totalTasksCompleted
    ├── totalBillableHours, averageTaskRating
    ├── lastLoginAt, lastProjectActivityAt
    └── lastTimesheetSubmitAt

    MEMBER-SPECIFIC ENTITIES
    ├── memberRoles → MemberRole[] (role assignments)
    ├── settings → MemberSettings[] (tenant preferences)
    ├── invitations → MemberInvitation[] (invitation history)
    ├── documents → MemberDocument[] (member documents)
    └── Cross-module relations (projects, tasks, timesheets, etc.)

    INDEXES (15)
    ├── [tenantId, id]
    ├── [tenantId, actorId] (unique)
    ├── [tenantId, memberCode] (unique if provided)
    ├── [tenantId, status]
    ├── [tenantId, memberType]
    ├── [tenantId, department]
    ├── [tenantId, managerId]
    ├── [tenantId, startDate]
    ├── [tenantId, jobTitle]
    ├── [actorId] (cross-tenant lookups)
    ├── [workEmail]
    ├── [securityLevel]
    ├── [lastLoginAt]
    ├── [createdAt]
    ├── [deletedAt]
    └── [metadata] (Gin)
```

---

## 🎭 Role Model (RBAC v9.0 Foundation)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Role (RBAC v9.0 Foundation)                     │
│                                Pattern: Tenant-Scoped                        │
└─────────────────────────────────────────────────────────────────────────────┘

    TENANT ISOLATION
    ├── id (UUID v7)
    └── tenantId (REQUIRED)

    RBAC v9.0 INTEGRATION
    ├── roleCode (ADMIN|PROJECT_MANAGER|WORKER|DRIVER|VIEWER)
    ├── roleName (Display name)
    ├── roleDescription
    ├── roleType (INTERNAL|EXTERNAL)
    └── hierarchy (0=highest, 10=lowest - RBAC v9.0 standard)

    ROLE CONFIGURATION
    ├── isSystemRole (Cannot be modified/deleted)
    ├── isActive (Can be assigned)
    ├── isDefault (Auto-assign to new members)
    ├── maxMembers (Optional member limit)
    └── version (Role versioning)

    SECURITY FLAGS
    ├── requireMFA (MFA required for this role)
    └── allowSelfAssign (Members can self-assign)

    5-ROLE HIERARCHY (Phase 1)
    ├── ADMIN (hierarchy: 0) - Full tenant access
    ├── PROJECT_MANAGER (hierarchy: 2) - Project management + TenantSettings
    ├── WORKER (hierarchy: 8) - Task execution and time tracking
    ├── DRIVER (hierarchy: 9) - Mobile app, deliveries, field operations
    └── VIEWER (hierarchy: 10) - Read-only access

    RELATED ENTITIES
    ├── permissions → RolePermission[] (permission grants)
    ├── memberRoles → MemberRole[] (member assignments)
    └── auditEvents → AccessAuditEvent[] (audit trail)

    INDEXES (8)
    ├── [tenantId, id]
    ├── [tenantId, roleCode] (unique)
    ├── [tenantId, isActive]
    ├── [tenantId, hierarchy]
    ├── [tenantId, isSystemRole]
    ├── [tenantId, roleType]
    ├── [tenantId, deletedAt]
    └── [metadata] (Gin)
```

---

## 🔑 Permission Model (Granular Access Control)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Permission (Granular Access Control)                 │
│                               Pattern: Global Registry                       │
└─────────────────────────────────────────────────────────────────────────────┘

    GLOBAL IDENTITY
    └── id (UUID v7) - NO tenantId (shared across tenants)

    PERMISSION DEFINITION (RBAC v9.0 Standard)
    ├── permissionCode (estimate:create, project:read:all, etc.)
    ├── permissionName (Human-readable name)
    └── permissionDescription (Detailed description)

    PERMISSION STRUCTURE (domain:action:scope)
    ├── domain (estimate, project, invoice, crm, etc.) - 18 domains
    ├── action (create, read, update, delete, approve, etc.)
    └── scope (all, own, assigned, team)

    PERMISSION METADATA
    ├── isSystemPermission (Cannot be modified)
    ├── isActive (Can be granted)
    ├── riskLevel (LOW|MEDIUM|HIGH|CRITICAL)
    └── version (Permission versioning)

   156 GRANULAR PERMISSIONS (Phase 1) — explicit, no wildcards
   Domain Distribution (Phase 1):
   ├── Tenant
   ├── AccessControl
   ├── Identity
   ├── Membership
   ├── Estimate
   ├── Invoice
   ├── Project
   ├── Task
   ├── Expenses
   ├── Inventory
   ├── Scheduling
   ├── Time
   ├── Payroll
   ├── CRM
   ├── Documents
   ├── ChangeOrder
   ├── AI
   ├── Analytics


    RELATED ENTITIES
    ├── rolePermissions → RolePermission[] (role grants)
    └── auditEvents → AccessAuditEvent[] (usage tracking)

    INDEXES (7)
    ├── [domain]
    ├── [action]
    ├── [scope]
    ├── [isActive]
    ├── [riskLevel]
    ├── [deletedAt]
    └── [metadata] (Gin)
```

---

## 🔗 RolePermission Model (Permission Grants)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          RolePermission (Permission Grants)                  │
│                                Pattern: Tenant Junction                      │
└─────────────────────────────────────────────────────────────────────────────┘

    TENANT ISOLATION
    ├── id (UUID v7)
    └── tenantId (REQUIRED)

    CORE RELATIONS
    ├── roleId → Role
    └── permissionId → Permission

    GRANT PERIOD
    ├── grantedAt (When granted)
    ├── revokedAt (When revoked)
    └── expiresAt (Expiration date)

    GRANT DETAILS
    ├── isActive (Currently effective)
    ├── grantReason (Why granted)
    ├── revokeReason (Why revoked)
    └── version (Grant versioning)

    ACTOR ATTRIBUTION (Pattern A)
    ├── createdByActorId → Actor (Who granted)
    ├── updatedByActorId → Actor (Who modified)
    └── revokedByActorId → Actor (Who revoked)

    RELATED ENTITIES
    ├── tenant → Tenant
    ├── role → Role
    └── permission → Permission

    INDEXES (7)
    ├── [tenantId, id]
    ├── [tenantId, roleId, permissionId] (unique grant)
    ├── [tenantId, roleId]
    ├── [tenantId, permissionId]
    ├── [tenantId, isActive]
    ├── [tenantId, expiresAt]
    ├── [tenantId, revokedAt]
    └── [metadata] (Gin)
```

---

## 👥 MemberRole Model (Role Assignments)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           MemberRole (Role Assignments)                      │
│                                Pattern: Tenant Junction                      │
└─────────────────────────────────────────────────────────────────────────────┘

    TENANT ISOLATION
    ├── id (UUID v7)
    └── tenantId (REQUIRED)

    CORE RELATIONS
    ├── memberId → Member
    └── roleId → Role

    ASSIGNMENT PERIOD
    ├── assignedAt (When assigned)
    ├── revokedAt (When revoked)
    └── expiresAt (Expiration date)

    ASSIGNMENT DETAILS
    ├── isActive (Currently effective)
    ├── isPrimary (Primary role for UI)
    ├── assignReason (Why assigned)
    └── revokeReason (Why revoked)

    ASSIGNMENT SCOPE (Optional)
    ├── scopeType (PROJECT|DEPARTMENT|LOCATION)
    ├── scopeValue (Specific scope identifier)
    └── Role can be limited to specific projects/departments

    ACTOR ATTRIBUTION (Pattern A)
    ├── createdByActorId → Actor (Who assigned)
    ├── updatedByActorId → Actor (Who modified)
    └── revokedByActorId → Actor (Who revoked)

    RELATED ENTITIES
    ├── tenant → Tenant
    ├── member → Member
    └── role → Role

    INDEXES (9)
    ├── [tenantId, id]
    ├── [tenantId, memberId, roleId, scopeType, scopeValue] (unique assignment)
    ├── [tenantId, memberId]
    ├── [tenantId, roleId]
    ├── [tenantId, isActive]
    ├── [tenantId, isPrimary]
    ├── [tenantId, expiresAt]
    ├── [tenantId, scopeType]
    └── [metadata] (Gin)
```

---

## 🤖 ServiceAccount Model (API Identity)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ServiceAccount (API Identity)                        │
│                              Pattern: Tenant + Actor Link                    │
└─────────────────────────────────────────────────────────────────────────────┘

    TENANT ISOLATION
    ├── id (UUID v7)
    └── tenantId (REQUIRED)

    SERVICE IDENTITY
    ├── serviceAccountName (Display name)
    ├── serviceAccountCode (Unique code)
    ├── description (Purpose description)
    └── actorId → Actor (Universal identity link)

    SERVICE CONFIGURATION
    ├── serviceType (API|INTEGRATION|SYSTEM|WEBHOOK)
    ├── allowedIpRanges[] (IP restrictions)
    ├── allowedDomains[] (Domain restrictions)
    └── rateLimitTier (BASIC|STANDARD|PREMIUM)

    SECURITY SETTINGS
    ├── isActive
    ├── requiresApproval (Require approval for key generation)
    ├── maxActiveKeys (Maximum concurrent keys)
    └── keyRotationDays (Automatic rotation period)

    LIFECYCLE TRACKING
    ├── activatedAt, suspendedAt
    ├── lastUsedAt
    └── Usage statistics (totalRequests, failedRequests, lastRequestAt)

    RELATED ENTITIES
    ├── tenant → Tenant
    ├── actor → Actor
    ├── apiKeys → ServiceAccountKey[]
    └── auditEvents → AccessAuditEvent[]

    INDEXES (8)
    ├── [tenantId, id]
    ├── [tenantId, serviceAccountCode] (unique)
    ├── [tenantId, serviceType]
    ├── [tenantId, isActive]
    ├── [tenantId, lastUsedAt]
    ├── [tenantId, status]
    ├── [actorId]
    └── [metadata] (Gin)
```

---

## 🔐 ServiceAccountKey Model (API Key Management)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      ServiceAccountKey (API Key Management)                  │
│                                Pattern: Tenant Child                         │
└─────────────────────────────────────────────────────────────────────────────┘

    TENANT ISOLATION
    ├── id (UUID v7)
    └── tenantId (REQUIRED)

    PARENT RELATION
    └── serviceAccountId → ServiceAccount

    KEY DETAILS
    ├── keyName (Human-readable name)
    ├── keyHash (Hashed key - never store plain)
    ├── keyPrefix (First few chars for identification)
    └── keyFingerprint (SHA256 fingerprint)

    KEY SECURITY
    ├── algorithm (HS256 default)
    ├── expiresAt (Expiration date)
    ├── lastUsedAt, lastUsedFrom (IP address)
    └── Usage statistics (usageCount, failureCount)

    KEY CONFIGURATION
    ├── isActive, canRotate
    ├── scopes[] (Permitted scopes)
    └── Security tracking

    LIFECYCLE STATES
    └── status (ACTIVE|EXPIRED|REVOKED|COMPROMISED)

    RELATED ENTITIES
    ├── tenant → Tenant
    ├── serviceAccount → ServiceAccount
    └── auditEvents → AccessAuditEvent[]

    INDEXES (9)
    ├── [tenantId, id]
    ├── [tenantId, serviceAccountId]
    ├── [tenantId, isActive]
    ├── [tenantId, expiresAt]
    ├── [tenantId, lastUsedAt]
    ├── [keyPrefix]
    ├── [keyHash] (unique - for auth)
    ├── [keyFingerprint] (unique)
    ├── [status]
    └── [metadata] (Gin)
```

---

## 📊 AccessAuditEvent Model (Complete Audit Trail)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      AccessAuditEvent (Complete Audit Trail)                 │
│                               Pattern: Tenant Audit                          │
└─────────────────────────────────────────────────────────────────────────────┘

    TENANT ISOLATION
    ├── id (UUID v7)
    └── tenantId (REQUIRED)

    EVENT ATTRIBUTION
    ├── actorId → Actor (Who performed action)
    ├── memberId → Member (Member context)
    ├── serviceAccountId → ServiceAccount (API context)
    └── sessionId (Session tracking)

    EVENT DETAILS
    ├── eventType (PERMISSION_CHECK|ROLE_ASSIGN|KEY_USAGE|etc.)
    ├── resourceType (estimate|project|invoice|etc.)
    ├── resourceId (Specific resource accessed)
    └── actionType (create|read|update|delete|approve)

    ACCESS DECISION
    ├── accessDecision (ALLOWED|DENIED|ERROR)
    ├── denialReason (Why access was denied)
    ├── policyMatched (RESERVED - Future AccessPolicy/ABAC phase)
    ├── rbacDecision (Phase 1: RBAC + TenantSettings result)
    └── executionTimeMs (Performance tracking)

    CONTEXT DATA
    ├── ipAddress, userAgent, referrer
    ├── requestMethod, requestPath
    └── contextData (JSON - additional context)

    PERMISSION CONTEXT
    ├── roleId → Role (Role used for decision)
    ├── permissionId → Permission (Permission checked)
    └── serviceAccountKeyId → ServiceAccountKey (API key used)

    RISK ASSESSMENT
    ├── riskScore (0.00-1.00)
    ├── riskFactors[] (Risk indicators)
    └── tags[] (Event categorization)

    COMPLIANCE
    ├── retentionUntilDate (Regulatory compliance)
    └── dataClassification (AUDIT level)

    RELATED ENTITIES
    ├── tenant → Tenant
    ├── actor → Actor
    ├── member → Member
    ├── serviceAccount → ServiceAccount
    ├── role → Role
    ├── permission → Permission
    └── serviceAccountKey → ServiceAccountKey

    INDEXES (12 + Partitioning)
    ├── [tenantId, id]
    ├── [tenantId, actorId]
    ├── [tenantId, eventType]
    ├── [tenantId, resourceType]
    ├── [tenantId, accessDecision]
    ├── [tenantId, eventTimestamp] BRIN
    ├── [tenantId, riskScore]
    ├── [ipAddress]
    ├── [sessionId]
    ├── [contextData] (Gin)
    ├── [tags] (Gin)
    ├── [retentionUntilDate]
    └── Monthly partitioning for performance
```

---

## 🔄 RBAC v9.0 + RLS v9.0 Integration Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         INTEGRATED SECURITY FLOW                             │
└─────────────────────────────────────────────────────────────────────────────┘

    1. AUTHENTICATION
       ├── User/API → Extract Actor context
       ├── Actor → Get Member(s) for tenant(s)
       ├── Member → Get active MemberRole(s)
       ├── MemberRole → Get Role(s) + hierarchy
       └── Create SecurityContext with Actor + Member + Roles

    2. PERMISSION CHECK (RBAC v9.0)
       ├── Check base permission (domain:action:scope)
       ├── Apply role hierarchy (0=Admin → 10=Viewer)
       ├── Check dynamic PM permissions (TenantSettings)
       ├── Validate role expiration and scope
       └── Return permission decision

    3. RESOURCE ACCESS (RLS v9.0)
       ├── Apply database-level RLS policies
       ├── Automatic tenant isolation (tenantId filter)
       ├── Role-based resource filtering
       ├── Ownership rules (createdByActorId matching)
       └── Return filtered query results

    4. AUDIT LOGGING
       ├── Log permission check result
       ├── Track Actor attribution
       ├── Record security context
       ├── Calculate risk score
       └── Create AccessAuditEvent

EXAMPLE SECURITY FLOW:
    User: John Smith (Actor: actor-123)
    Member: member-456 (Tenant: construction-co)
    Role: PROJECT_MANAGER (hierarchy: 2)

    Action: Approve estimate EST-2025-001

    1. RBAC Check:
       ├── Base permission: estimate:approve ✓
       ├── Role hierarchy: PM can approve ✓
       ├── TenantSettings: pmCanApproveEstimates = true ✓
       └── Decision: ALLOWED

    2. RLS Filter:
       ├── tenantId = 'construction-co' ✓
       ├── Role-based: PM can see assigned projects ✓
       ├── Ownership: EST-2025-001 assigned to PM ✓
       └── Resource access: GRANTED

    3. Audit Event:
       ├── actorId: actor-123
       ├── eventType: ESTIMATE_APPROVE
       ├── accessDecision: ALLOWED
       ├── roleId: role-pm
       └── riskScore: 0.15 (low risk)

┌─────────────────────────────────────────────────────────────────────────────┐
│                       TENATSETTINGS DYNAMIC PERMISSIONS                      │
└─────────────────────────────────────────────────────────────────────────────┘

    PROJECT_MANAGER Dynamic Permissions (per tenant):

    TenantSettings Configuration (10 Critical PM Permissions):
    ├── pmCanApproveEstimates: boolean → estimate:approve
    ├── pmCanApproveInvoices: boolean → invoice:approve
    ├── pmCanApproveChangeOrders: boolean → changeorder:approve
    ├── pmCanSeeProjectFinancials: boolean → project:read:financial
    ├── pmCanDeleteOwnEstimates: boolean → estimate:delete:own
    ├── pmCanDeleteOwnInvoices: boolean → invoice:delete:own
    ├── pmCanDeleteOwnChangeOrders: boolean → changeorder:delete:own
    ├── pmCanSeeEstimateProfit: boolean → estimate:read:profit
    ├── pmCanSeeInvoiceProfit: boolean → invoice:read:profit
    └── pmCanSeeChangeOrderProfit: boolean → changeorder:read:profit

    Permission Resolution:
    1. Check if member has PROJECT_MANAGER role
    2. If yes, query TenantSettings for PM permissions
    3. Combine base RBAC permissions + dynamic permissions
    4. Cache result for performance (5-minute TTL)
    5. Apply combined permissions in security checks

    Example:
    Base RBAC:
    ├── project:read, project:update, project:assign-team ✓

    + TenantSettings (if pmCanApproveEstimates = true):
    ├── estimate:approve ✓

    = Final permissions:
    ├── project:read, project:update, project:assign-team
    └── estimate:approve (dynamic)
```

---

## 🏗️ CROSS-MODULE INTEGRATION (v9.0 Architecture)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    V9.0 CROSS-MODULE INTEGRATION ARCHITECTURE                │
└─────────────────────────────────────────────────────────────────────────────┘

    🎭 UNIVERSAL ACTOR ATTRIBUTION
    ═══════════════════════════════════════════════════════════════════════════
    Pattern B Entities (Critical Business Entities):
    ├── Estimate.createdByActorId → Actor @relation("EstimateCreatedByActor")
    ├── Estimate.updatedByActorId → Actor @relation("EstimateUpdatedByActor")
    ├── Estimate.deletedByActorId → Actor @relation("EstimateDeletedByActor")
    ├── Project.createdByActorId → Actor @relation("ProjectCreatedByActor")
    ├── Project.updatedByActorId → Actor @relation("ProjectUpdatedByActor")
    ├── Project.deletedByActorId → Actor @relation("ProjectDeletedByActor")
    ├── Invoice.createdByActorId → Actor @relation("InvoiceCreatedByActor")
    ├── Invoice.updatedByActorId → Actor @relation("InvoiceUpdatedByActor")
    └── Invoice.deletedByActorId → Actor @relation("InvoiceDeletedByActor")

    Pattern A Entities (Supporting Entities):
    ├── EstimateLineItem.createdByActorId → Actor (UUID only)
    ├── ProjectTask.createdByActorId → Actor (UUID only)
    ├── InvoiceLineItem.createdByActorId → Actor (UUID only)
    └── All other business entities (lightweight audit)

    🔒 RLS v9.0 AUTOMATIC ENFORCEMENT
    ═══════════════════════════════════════════════════════════════════════════
    Database-Level Security (Applied Automatically):

    Tenant Isolation:
    ├── WHERE tenantId = current_tenant_id()

    Role-Based Access:
    ├── Admin (hierarchy 0): Access to all tenant data
    ├── Project Manager (hierarchy 2): Assigned projects + team data
    ├── Worker (hierarchy 8): Assigned tasks + own timesheets
    ├── Driver (hierarchy 9): Delivery tasks + mobile app data
    └── Viewer (hierarchy 10): Read-only public data

    Ownership Rules:
    ├── Own records: WHERE createdByActorId = current_actor_id()
    ├── Team records: WHERE project_team_member(current_member_id())
    └── Public records: WHERE visibility = 'PUBLIC'

    Example RLS Policy (Projects):
    CREATE POLICY project_access_policy ON projects
    FOR ALL TO rls_user USING (
        tenantId = current_tenant_id() AND (
            -- Admin: all projects
            current_role_hierarchy() <= 0 OR
            -- PM: assigned projects
            (current_role_hierarchy() <= 2 AND
             is_project_manager(id, current_member_id())) OR
            -- Worker: task assignments
            (current_role_hierarchy() <= 8 AND
             has_project_task_assignment(id, current_member_id()))
        )
    );

    🏢 TENANT-SPECIFIC CONFIGURATION
    ═══════════════════════════════════════════════════════════════════════════
    TenantSettings Integration:

    Dynamic PM Permissions:
    ├── Construction Co A: PMs can approve estimates up to $50K
    ├── Construction Co B: PMs cannot approve any estimates
    ├── Construction Co C: PMs can approve estimates + invoices
    └── Per-tenant flexibility without code changes

    Role Configuration:
    ├── Enable/disable roles per tenant
    ├── Customize role names and descriptions
    ├── Set role-specific limits (max projects, approval amounts)
    └── Configure workflow requirements

    📊 COMPLETE AUDIT TRAIL (Compliance-Ready)
    ═══════════════════════════════════════════════════════════════════════════
    AccessAuditEvent captures:

    Business Operations:
    ├── Estimate creation/approval/conversion
    ├── Project task assignments and completions
    ├── Invoice generation and payment application
    ├── Time tracking and expense submissions
    └── Document access and modifications

    Security Events:
    ├── Role assignments and revocations
    ├── Permission grants and denials
    ├── API key usage and rotation
    ├── Failed authentication attempts
    └── Suspicious activity detection

    Compliance Requirements:
    ├── SOX: Segregation of duties and approval workflows
    ├── GDPR: Data access logging and right to be forgotten
    ├── SOC 2: Security controls and monitoring
    └── Industry-specific: Construction, healthcare, finance
```

---

## ✅ V9.0 SYSTEM ROLES (Phase 1 - 5 Internal Roles)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         V9.0 ROLE HIERARCHY (Phase 1)                       │
└─────────────────────────────────────────────────────────────────────────────┘

    ADMIN (roleCode: ADMIN, hierarchy: 0)
    ├── Permission Count: 71/156 (45%)
    ├── Scope: Tenant owner with full control within their own tenant only
    ├── Key Permissions:
    │   ├── tenant:read, tenant:update, tenant:manage:modules
    │   ├── identity:invite:user, membership:manage:roles
    │   ├── Full estimate, invoice, project CRUD (all business operations)
    │   ├── payroll:read:tenant, inventory:adjust:quantity
    │   └── No platform-wide or cross-tenant powers
    ├── Cannot be deleted (isSystemRole: true)
    ├── RLS enforced: tenantId filtering always applied
    └── Auto-assigned to tenant owner

    PROJECT_MANAGER (roleCode: PROJECT_MANAGER, hierarchy: 2)
    ├── Permission Count: 29/156 (19% baseline + 10 critical via TenantSettings)
    ├── Scope: Assigned projects and teams management
   ├── Base Permissions:
   │   ├── project:create:own, project:list:own, project:read:own, project:update:own
   │   ├── project:assign:worker, project:assign:driver, project:assign:task, project:read:team, project:read:schedule
   │   ├── estimate:create, estimate:list:own, estimate:read:own, estimate:update:own
   │   ├── invoice:create, invoice:list:own, invoice:read:own, invoice:update:own
   │   ├── task:create:project, task:list:project, task:read:project, task:update:project, task:assign:worker, task:assign:driver
   │   ├── documents:list:project, documents:read:project, documents:upload:project, documents:comment:project
   │   └── expenses:list:project, expenses:read:project, time:create:own_entry, time:read:own, scheduling:read:own, payroll:read:own
    ├── Critical Permissions (TenantSettings-controlled):
    │   ├── estimate:approve, estimate:delete:own, estimate:read:profit
    │   ├── invoice:approve, invoice:delete:own, invoice:read:profit
    │   ├── changeorder:approve, changeorder:delete:own
    │   └── project:read:financial
    └── Scope: Own/assigned projects only (RLS enforced)

    WORKER (roleCode: WORKER, hierarchy: 8)
    ├── Permission Count: 12/156 (8%)
    ├── Scope: Task execution and own record management
    ├── Key Permissions:
   │   ├── task:read:assigned, task:update:own
    │   ├── time:create:own_entry, time:read:own
    │   ├── expenses:create:own, expenses:read:own
    │   ├── project:read:assigned (limited to assigned work)
   │   ├── documents:list:assigned, documents:read:assigned, documents:upload:assigned
    │   └── scheduling:read:own
    ├── Restrictions:
    │   ├── No estimate or invoice access
    │   ├── No CRM or inventory adjustments
    │   ├── No project creation or team assignments
    │   └── No approval permissions
    └── Scope: Own records + assigned tasks only (RLS enforced)

   DRIVER (roleCode: DRIVER, hierarchy: 9)
   ├── Permission Count: 13/156 (8%)
   ├── Scope: Delivery tasks and logistics operations
   ├── Key Permissions:
   │   ├── task:list:delivery, task:read:delivery, task:update:status:delivery
   │   ├── project:read:delivery_info, inventory:read:delivery_items
   │   ├── time:create:own_entry, time:read:own
   │   ├── expenses:create:delivery, expenses:list:own, expenses:read:own
   │   ├── documents:read:delivery, documents:upload:delivery
   │   └── scheduling:read:own
    ├── Restrictions:
    │   ├── No full project access beyond delivery info
    │   ├── No estimate, invoice, or financial access
    │   ├── No inventory adjustments or team management
    │   └── No approval permissions
    └── Scope: Delivery tasks + own records only (RLS enforced)

    VIEWER (roleCode: VIEWER, hierarchy: 10)
    ├── Permission Count: 16/156 (10%)
    ├── Scope: Read-only access for demos and training (sandbox-only)
   ├── Key Permissions:
   │   ├── project:list, project:read (demo projects)
   │   ├── estimate:list, estimate:read (sample estimates)
   │   ├── invoice:list, invoice:read (sample invoices)
   │   ├── documents:list, documents:read (public docs)
   │   ├── inventory:list, inventory:read (demo items)
   │   ├── expenses:list, expenses:read (summary)
   │   ├── time:read, scheduling:read, payroll:read (demo context)
   │   ├── crm:list, crm:read (sample customer data)
   │   └── ai:ask, ai:generate:demo_report (demo reports)
    ├── Enforcement:
    │   ├── Sandbox-only: RLS enforces Tenant.isSandbox = true
    │   ├── No production tenant access
    │   └── Demo data and training purposes only
    ├── Restrictions:
    │   ├── No write operations (create/update/delete blocked)
    │   ├── No approval or financial operations
    │   └── No real integrations or billing access
    └── Scope: Demo/training content only

PERMISSION DISTRIBUTION BY DOMAIN (18 Domains Total — Illustrative Examples):

   Domain: estimate (Examples)
   ├── ADMIN: create, list, read, update, delete, send, approve
   ├── PROJECT_MANAGER: base create/list/read/update (own) + approve via TenantSettings (if enabled)
   ├── WORKER: No estimate access
   ├── DRIVER: No estimate access
   └── VIEWER: estimate:list, estimate:read (demo data only)

   Domain: project (Examples)
   ├── ADMIN: Full project permissions including financial and assignments
   ├── PROJECT_MANAGER: project:create:own, project:update:own, project:assign:worker/driver/task, project:read:team/schedule
   ├── WORKER: project:read:assigned (limited to assigned work)
   ├── DRIVER: project:read:delivery_info
   └── VIEWER: project:list, project:read (demo projects only)

   Domain: invoice (Examples)
   ├── ADMIN: Full invoice permissions including writeoff
   ├── PROJECT_MANAGER: base create/list/read/update (own) + approve via TenantSettings (if enabled)
   ├── WORKER: No invoice access
   ├── DRIVER: No invoice access
   └── VIEWER: invoice:list, invoice:read (demo data only)

    18 Domains (authoritative list in rbac_schema_v9.0.yml): tenant, accesscontrol, identity, membership, estimate, invoice, project, task, expenses, inventory, scheduling, time, payroll, crm, documents, changeorder, ai, analytics

ROLE HIERARCHY ENFORCEMENT:
├── Higher roles (lower hierarchy numbers) inherit permissions
├── Role assignments checked against hierarchy
├── Cannot assign role higher than own role
├── Cannot escalate own privileges
└── Admin approval required for sensitive role changes
```

---

## 🔄 ACCESS CONTROL OPERATION FLOWS

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PERMISSION CHECK FLOW (v9.0)                        │
└─────────────────────────────────────────────────────────────────────────────┘

    User Action: Project Manager approves Estimate EST-2025-001

    1. ACTOR CONTEXT EXTRACTION
       ├── JWT Token → Extract actorId, tenantId, memberId
       ├── Actor: actor-123 (John Smith - USER type)
       ├── Member: member-456 (Construction Co tenant)
       └── SecurityContext created

    2. RBAC v9.0 PERMISSION CHECK
       ├── Get MemberRole: PROJECT_MANAGER (hierarchy: 2)
       ├── Base permission check: estimate:approve
       │   └── RolePermission lookup: ❌ NOT FOUND (not in base PM permissions)
       ├── Dynamic permission check: TenantSettings query
       │   ├── pmCanApproveEstimates = true ✓
       │   └── Dynamic permission: estimate:approve ✓ GRANTED
       └── Combined result: ✓ ALLOWED

    3. RLS v9.0 RESOURCE ACCESS
       ├── Query: SELECT * FROM estimates WHERE id = 'EST-2025-001'
       ├── RLS Policy Applied:
       │   ├── tenantId = 'construction-co' ✓
       │   ├── role_hierarchy <= 2 (PM can approve) ✓
       │   ├── is_project_manager(estimate.projectId, 'member-456') ✓
       │   └── Resource access: ✓ GRANTED
       └── Estimate data returned

    4. BUSINESS LOGIC EXECUTION
       ├── Update estimate.status = 'APPROVED'
       ├── Set estimate.approvedAt = NOW()
       ├── Set estimate.approvedByActorId = 'actor-123'
       ├── Auto-create Project (if autoCreateProjectOnApproval = true)
       └── Send approval notification

    5. AUDIT EVENT LOGGING
       ├── AccessAuditEvent created:
       │   ├── actorId: actor-123
       │   ├── eventType: ESTIMATE_APPROVE
       │   ├── resourceType: estimate
       │   ├── resourceId: EST-2025-001
       │   ├── accessDecision: ALLOWED
       │   ├── roleId: role-pm
       │   ├── permissionId: estimate:approve (dynamic)
       │   ├── contextData: {dynamicPermission: true, tenantSetting: 'pmCanApproveEstimates'}
       │   └── riskScore: 0.20 (low-medium risk)
       └── Event logged to audit trail

    Result: ✅ SUCCESS - Estimate approved with complete audit trail

┌─────────────────────────────────────────────────────────────────────────────┐
│                      SERVICE ACCOUNT API ACCESS FLOW                        │
└─────────────────────────────────────────────────────────────────────────────┘

    External System: QuickBooks Integration (API call)

    1. API AUTHENTICATION
       ├── Request Header: Authorization: Bearer sk_live_abc123...
       ├── Extract keyPrefix: sk_live_
       ├── ServiceAccountKey lookup by keyHash
       │   ├── Key found: key-789 (QuickBooks Integration)
       │   ├── Status: ACTIVE ✓
       │   ├── Not expired ✓
       │   └── IP whitelist check: 203.0.113.0/24 ✓
       └── Key validation: ✅ SUCCESS

    2. SERVICE ACTOR CONTEXT
      ├── ServiceAccount: sa-456 (QuickBooks Integration)
      ├── Actor: actor-789 (SERVICE_ACCOUNT type)
      ├── Tenant: construction-co
      ├── Assigned permissions: invoice:read, documents:read, inventory:list
       └── SecurityContext created

    3. API REQUEST PROCESSING
       ├── Request: GET /api/invoices?status=APPROVED
       ├── Permission check: invoice:read ✓ ALLOWED
       ├── RLS Policy Applied:
       │   ├── tenantId = 'construction-co' ✓
       │   ├── Service account scoped access ✓
       │   └── Returns only approved invoices for tenant
       └── Query executed with RLS filtering

    4. USAGE TRACKING
       ├── ServiceAccountKey.usageCount += 1
       ├── ServiceAccountKey.lastUsedAt = NOW()
       ├── ServiceAccountKey.lastUsedFrom = '203.0.113.15'
       └── ServiceAccount.lastRequestAt = NOW()

    5. AUDIT EVENT LOGGING
       ├── AccessAuditEvent created:
       │   ├── actorId: actor-789
       │   ├── serviceAccountId: sa-456
       │   ├── serviceAccountKeyId: key-789
       │   ├── eventType: API_USAGE
       │   ├── resourceType: invoice
       │   ├── actionType: read
       │   ├── accessDecision: ALLOWED
       │   ├── ipAddress: 203.0.113.15
       │   ├── requestPath: /api/invoices
       │   ├── requestMethod: GET
       │   └── contextData: {keyPrefix: 'sk_live_', rateLimitTier: 'STANDARD'}
       └── API usage logged

    Result: ✅ SUCCESS - API data returned with usage tracking

┌─────────────────────────────────────────────────────────────────────────────┐
│                        ROLE ASSIGNMENT VALIDATION FLOW                       │
└─────────────────────────────────────────────────────────────────────────────┘

    Admin Action: Assign WORKER role to new employee

    1. ASSIGNMENT REQUEST VALIDATION
       ├── Assigner: Admin (hierarchy: 0)
       ├── Assignee: Member 'jane-doe' (new employee)
       ├── Target Role: WORKER (hierarchy: 8)
       ├── Hierarchy Check: 0 < 8 ✓ (Admin can assign WORKER)
       └── Basic validation: ✅ PASSED

    2. MEMBER VALIDATION
       ├── Member exists: member-789 ✓
       ├── Member status: ACTIVE ✓
       ├── Existing role check: No active roles
       ├── Role conflict check: No conflicts
       └── Member validation: ✅ PASSED

    3. ROLE ASSIGNMENT CREATION
       ├── MemberRole record:
       │   ├── memberId: member-789
       │   ├── roleId: role-worker
       │   ├── assignedAt: NOW()
       │   ├── isActive: true
       │   ├── isPrimary: true (first role)
       │   ├── assignedByActorId: actor-admin
       │   └── assignReason: "New employee onboarding"
       └── Assignment saved: ✅ SUCCESS

    4. PERMISSION CACHE INVALIDATION
       ├── Redis key: permissions:construction-co:member-789
       ├── Cache invalidated ✓
       ├── Next permission check will recalculate
       └── Cache management: ✅ COMPLETE

    5. NOTIFICATION & AUDIT
       ├── Email notification to jane-doe@construction-co.com
       ├── Notification: "WORKER role assigned - access to task management"
       ├── AccessAuditEvent:
       │   ├── eventType: ROLE_ASSIGN
       │   ├── resourceType: member
       │   ├── resourceId: member-789
       │   ├── accessDecision: ALLOWED
       │   ├── contextData: {roleCode: 'WORKER', assignReason: 'New employee onboarding'}
       │   └── roleId: role-worker
       └── Assignment completed: ✅ SUCCESS

    Result: ✅ SUCCESS - WORKER role assigned with notifications and audit trail
```

---

**Document Version:** 9.0
**Document Status:** ✅ Production-Ready v9.0 Architecture
**Integration Status:** ✅ RBAC v9.0 + RLS v9.0 + Actor Pattern + TenantSettings
**Phase Status:** ✅ Phase 1 Complete - 5 Internal Roles
**Pattern Compliance:** ✅ Universal Actor Pattern + Multi-Tenant Security
**Total Security Models:** 26 (AccessControl: 12 + Identity: 8 + Membership: 6)
**Next Review:** Upon Phase 2 planning (External Users + Advanced Features)
