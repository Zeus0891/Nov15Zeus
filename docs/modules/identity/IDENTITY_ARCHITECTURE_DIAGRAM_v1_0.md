# 📊 Identity Module - Arquitectura Visual

**Version:** 1.0  
**Last Updated:** November 17, 2025  
**Module**: identity.prisma  
**Aligned with**: Estimate v8.0, Invoice v8.0, Project v2.0, Inventory v1.0, Expense v1.0  
**Total Models**: 8

---

## 🏗️ Diagrama de Estructura Completa

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Actor (Core Identity Entity)                        │
│                           Pattern: BH (Base Hybrid)                          │
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
        │ globalId ⭐   │     │ updatedAt     │   │              │
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
        ├─► 👤 ACTOR IDENTITY
        │   ├── actorType (USER|SERVICE_ACCOUNT|SYSTEM|GUEST)
        │   ├── displayName (REQUIRED)
        │   └── actorNumber (AUTO: ACT-2025-00001)
        │
        ├─► 🔗 POLYMORPHIC RELATION
        │   ├── User (1:1 if actorType = USER)
        │   ├── ServiceAccount (1:1 if actorType = SERVICE_ACCOUNT)
        │   └── Member (1:N across tenants)
        │
        ├─► 📊 STATUS
        │   ├── isActive
        │   ├── isVerified (email/phone verified)
        │   └── isSuspended (temporarily blocked)
        │
        ├─► 📅 ACTIVITY TRACKING
        │   ├── lastActivityAt
        │   ├── lastLoginAt
        │   └── loginCount
        │
        └─► 🌐 GLOBAL LINKAGE
            ├── globalId (for cross-tenant tracking)
            └── Used in ALL audit trails platform-wide

┌─────────────────────────────────────────────────────────────────────────────┐
│                  CRITICAL PLATFORM CONCEPT: Actor Pattern                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ "Actor" is the UNIVERSAL IDENTITY for the entire platform:                  │
│                                                                              │
│ ✅ Every action is attributed to an Actor                                   │
│ ✅ Users, Service Accounts, System processes → All are Actors               │
│ ✅ All audit trails reference actorId (createdByActorId, etc.)              │
│ ✅ Enables unified security, permissions, and compliance                    │
│                                                                              │
│ RELATIONSHIP HIERARCHY:                                                     │
│                                                                              │
│    Actor (Global Identity)                                                  │
│      ├─► User (Authentication Identity)                                     │
│      │     └─► Member[] (Tenant Memberships)                                │
│      │           └─► MemberRole[] → Role → Permission                       │
│      │                                                                       │
│      └─► ServiceAccount (API/Integration Identity)                          │
│            └─► ServiceAccountKey[] (API Keys)                               │
│                                                                              │
│ EXAMPLE FLOW:                                                               │
│   1. User signs up → Actor created (globalId assigned)                      │
│   2. User record created (links to Actor)                                   │
│   3. User joins Tenant A → Member created (links to Actor)                  │
│   4. User joins Tenant B → Another Member created (same Actor)              │
│   5. User creates Estimate → createdByActorId = Actor.id                    │
│                                                                              │
│ This enables: Cross-tenant analytics, unified audit, compliance tracking    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         CHILD RELATIONS (1 type)                             │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        └─► Member[] (tenant memberships - in membership.prisma)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         CROSS-MODULE REFERENCES                              │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► ALL audit trails (createdByActorId, updatedByActorId)
        ├─► AccessAuditEvent.actorId
        ├─► ApprovalRequest.submittedByActorId
        ├─► Session.actorId
        └─► SecurityEvent.actorId

┌─────────────────────────────────────────────────────────────────────────────┐
│                         INDEX STRATEGY (8 indexes)                           │
└─────────────────────────────────────────────────────────────────────────────┘

    🔑 PRIMARY CONSTRAINTS (2)
       ├── [id]
       └── [globalId]

    🔍 COMMON FILTERS (3)
       ├── [actorType]
       ├── [isActive]
       └── [tenantId] (nullable - for service accounts)

    ⏰ TEMPORAL (2 BRIN)
       ├── [createdAt]
       └── [lastActivityAt]

    📈 GOVERNANCE (1)
       └── [deletedAt]
```

---

## 👤 User (Authentication Entity)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          User (Authentication Identity)                      │
│                            Pattern: A (Lightweight)                          │
└─────────────────────────────────────────────────────────────────────────────┘

    IDENTITY
    ├── id (UUID v7)
    └── actorId → Actor (1:1 REQUIRED)

    USER CREDENTIALS
    ├── email (UNIQUE, REQUIRED)
    ├── emailVerified (boolean)
    ├── emailVerifiedAt
    ├── phoneNumber (optional)
    ├── phoneVerified
    └── phoneVerifiedAt

    PASSWORD (Encrypted)
    ├── passwordHash (bcrypt)
    ├── passwordSalt
    ├── passwordLastChangedAt
    └── requirePasswordChange (force reset on next login)

    USER PROFILE
    ├── firstName
    ├── lastName
    ├── displayName (computed: firstName + lastName)
    ├── avatarUrl
    └── timezone

    PREFERENCES
    ├── locale (en-US, es-MX, etc.)
    ├── language
    └── dateFormat

    STATUS
    ├── status (ACTIVE|PENDING_VERIFICATION|SUSPENDED|LOCKED|DELETED)
    ├── isActive
    ├── isEmailVerified
    ├── isPhoneVerified
    └── isSuspended

    SECURITY
    ├── mfaEnabled (multi-factor authentication)
    ├── mfaMethod (TOTP|SMS|EMAIL)
    ├── lastPasswordChangeAt
    ├── failedLoginAttempts
    └── lockedUntil (account lockout)

    ACTIVITY
    ├── lastLoginAt
    ├── lastLoginIp
    ├── loginCount
    └── lastActivityAt

    METADATA
    └── metadata (JSON - extensible user data)

    PURPOSE:
    User is the authentication identity. One user can be a member of
    multiple tenants. User → Actor → Member[] → Tenant[]

    INDEXES (12)
    ├── [id]
    ├── [actorId] (unique)
    ├── [email] (unique, case-insensitive)
    ├── [phoneNumber]
    ├── [status]
    ├── [isActive]
    ├── [emailVerified]
    ├── [mfaEnabled]
    ├── [lastLoginAt] BRIN
    ├── [createdAt] BRIN
    ├── [lockedUntil]
    └── [deletedAt]
```

---

## 🔐 Session (Active Login Session)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Session (Pattern A - Stateful)                       │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATIONS
    ├── userId → User
    └── actorId → Actor

    SESSION IDENTITY
    ├── sessionId (UUID v7, public identifier)
    ├── sessionToken (encrypted, used in cookies/headers)
    └── refreshToken (for token refresh)

    SESSION METADATA
    ├── deviceName (e.g., "Chrome on MacOS")
    ├── deviceType (DESKTOP|MOBILE|TABLET|API)
    ├── userAgent
    ├── ipAddress
    ├── geolocation (country, city, lat/lon)
    └── isTrustedDevice

    LIFECYCLE
    ├── createdAt (session start)
    ├── expiresAt (session expiration)
    ├── lastActivityAt (for idle timeout)
    ├── refreshedAt (last token refresh)
    └── terminatedAt (manual logout or forced termination)

    STATUS
    ├── status (ACTIVE|EXPIRED|TERMINATED|REVOKED)
    ├── isActive
    └── terminatedReason (LOGOUT|TIMEOUT|ADMIN_REVOKED|SECURITY_POLICY)

    TENANT CONTEXT (Optional)
    ├── currentTenantId → Tenant (selected tenant for session)
    └── memberId → Member (active membership)

    SECURITY
    ├── mfaVerifiedAt (when MFA was last verified)
    ├── requiresMfaReverification (step-up auth)
    └── securityEventId → SecurityEvent (if flagged)

    SESSION LIMITS
    ├── maxIdleMinutes (default: 30)
    └── maxSessionHours (default: 24)

    PURPOSE:
    Tracks active login sessions. Users can have multiple concurrent
    sessions (web, mobile, desktop app). Sessions can be revoked
    individually or all at once.

    AUTO-CLEANUP:
    Cron job deletes expired sessions older than 30 days.

    INDEXES (10)
    ├── [sessionId] (unique)
    ├── [sessionToken] (unique, for lookups)
    ├── [refreshToken] (unique)
    ├── [userId]
    ├── [actorId]
    ├── [status]
    ├── [isActive]
    ├── [expiresAt]
    ├── [currentTenantId]
    └── [createdAt] BRIN
```

---

## 👤 UserProfile (Extended Profile Data)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      UserProfile (Pattern A - Optional)                      │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── userId → User (1:1)

    PERSONAL INFO
    ├── middleName
    ├── preferredName
    ├── title (Mr., Mrs., Dr., etc.)
    ├── suffix (Jr., Sr., III, etc.)
    └── pronouns (he/him, she/her, they/them)

    CONTACT INFO
    ├── personalEmail (separate from login email)
    ├── personalPhone
    ├── workPhone
    ├── emergencyContactName
    └── emergencyContactPhone

    LOCATION
    ├── addressLine1
    ├── addressLine2
    ├── city
    ├── stateProvince
    ├── postalCode
    ├── country
    └── timezone

    EMPLOYMENT (if applicable)
    ├── jobTitle
    ├── department
    ├── managerId → Member (reporting manager)
    ├── hireDate
    └── employeeNumber

    SOCIAL
    ├── linkedInUrl
    ├── twitterHandle
    └── githubUsername

    BIO
    ├── bio (short biography)
    └── skills[] (array of skill tags)

    PROFILE STATUS
    ├── profileCompleteness (0-100%)
    └── lastUpdatedAt

    PURPOSE:
    Optional extended profile information. Not required for login,
    but useful for internal directories, org charts, etc.

    INDEXES (5)
    ├── [userId] (unique)
    ├── [employeeNumber]
    ├── [managerId]
    ├── [department]
    └── [lastUpdatedAt]
```

---

## ⚙️ UserSetting (Preferences)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      UserSetting (Pattern A - Key-Value)                     │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── userId → User

    SETTING IDENTITY
    ├── settingKey (e.g., "theme", "notifications.email")
    ├── settingCategory (UI|NOTIFICATIONS|PRIVACY|INTEGRATIONS)
    └── settingType (STRING|NUMBER|BOOLEAN|JSON|ARRAY)

    SETTING VALUE
    ├── settingValue (JSON - stores any type)
    └── defaultValue (fallback if not set)

    SCOPE
    ├── scope (GLOBAL|TENANT|PROJECT)
    └── scopeResourceId (if tenant or project specific)

    METADATA
    ├── isEditable (can user change this?)
    ├── isVisible (show in settings UI?)
    └── description

    STATUS
    └── isActive

    EXAMPLES:
    ├── theme: "dark"
    ├── notifications.email: true
    ├── notifications.slack: false
    ├── defaultTenantId: "tenant-123"
    ├── estimateTemplate: "template-xyz"
    └── dashboardLayout: { widgets: [...] }

    PURPOSE:
    Flexible key-value store for user preferences. Can be global
    or scoped to specific tenants/projects.

    INDEXES (6)
    ├── [userId, settingKey] (unique)
    ├── [userId, settingCategory]
    ├── [settingKey]
    ├── [scope]
    ├── [scopeResourceId]
    └── [isActive]
```

---

## 🔑 UserApiKey (Personal API Keys)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     UserApiKey (Pattern A - API Access)                      │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATIONS
    ├── userId → User
    └── actorId → Actor

    KEY IDENTITY
    ├── keyId (public identifier)
    ├── keyName (e.g., "My Desktop App")
    └── description

    KEY MATERIAL (Encrypted)
    ├── keyHash (bcrypt of actual key)
    ├── keyPrefix (e.g., "pk_live_" - visible to user)
    └── keyLastFourDigits (for identification)

    SCOPE
    ├── scopeType (FULL_ACCESS|READ_ONLY|SPECIFIC_PERMISSIONS)
    ├── allowedPermissions[] (subset of user's permissions)
    └── allowedTenants[] (limit to specific tenants)

    LIFECYCLE
    ├── createdAt
    ├── expiresAt
    ├── lastRotatedAt
    └── rotationPolicy (NEVER|30_DAYS|90_DAYS|180_DAYS|365_DAYS)

    STATUS
    ├── status (ACTIVE|EXPIRED|REVOKED|COMPROMISED)
    └── isActive

    USAGE TRACKING
    ├── lastUsedAt
    ├── usageCount
    ├── lastAccessIp
    └── lastAccessLocation

    SECURITY
    ├── allowedIpAddresses[] (whitelist)
    ├── requiresMTLS (mutual TLS required)
    └── isCompromised (marked if leaked)

    PURPOSE:
    Personal API keys for user-level API access (not service accounts).
    Similar to GitHub Personal Access Tokens.

    DIFFERENCE vs ServiceAccountKey:
    - UserApiKey: Personal, tied to a user's permissions
    - ServiceAccountKey: Shared, tied to service account permissions

    INDEXES (8)
    ├── [id]
    ├── [keyId] (unique)
    ├── [userId]
    ├── [actorId]
    ├── [keyHash]
    ├── [status]
    ├── [expiresAt]
    └── [lastUsedAt]
```

---

## 📧 UserInvitation (Invite Pending Users)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    UserInvitation (Pattern A - Onboarding)                   │
└─────────────────────────────────────────────────────────────────────────────┘

    INVITATION IDENTITY
    ├── invitationToken (secure random token)
    └── invitationCode (short code for mobile/SMS)

    INVITEE INFO
    ├── email (who is being invited)
    ├── firstName (optional pre-fill)
    └── lastName (optional pre-fill)

    INVITATION CONTEXT
    ├── invitationType (NEW_USER|EXISTING_USER_NEW_TENANT)
    ├── tenantId → Tenant (which tenant they're joining)
    ├── invitedToMembership (auto-create Member on accept)
    └── invitedToRoleIds[] (auto-assign roles)

    INVITER INFO
    ├── invitedByUserId → User
    ├── invitedByActorId → Actor
    └── invitationMessage (custom welcome message)

    LIFECYCLE
    ├── invitedAt
    ├── expiresAt (default: 7 days)
    ├── acceptedAt
    ├── declinedAt
    └── revokedAt

    STATUS
    ├── status (PENDING|ACCEPTED|DECLINED|EXPIRED|REVOKED)
    └── isActive

    ACCEPTANCE
    ├── acceptedByUserId → User (if they accepted)
    ├── acceptanceIpAddress
    └── acceptanceUserAgent

    REMINDERS
    ├── remindersSent (count)
    └── lastReminderSentAt

    PURPOSE:
    Invite new users to the platform or existing users to new tenants.
    Secure token-based flow with expiration.

    FLOW:
    1. Admin sends invitation (creates UserInvitation)
    2. Email sent with invitation link (token in URL)
    3. User clicks link → Lands on signup/accept page
    4. User accepts → Creates User + Member (if new user)
    5. User redirects to tenant dashboard

    INDEXES (8)
    ├── [id]
    ├── [invitationToken] (unique)
    ├── [invitationCode]
    ├── [email]
    ├── [tenantId]
    ├── [status]
    ├── [expiresAt]
    └── [createdAt]
```

---

## 📋 UserHistoryEvent (Audit Trail)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                 UserHistoryEvent (Pattern A - Audit Trail)                   │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── userId → User

    EVENT IDENTITY
    ├── eventId (UUID v7)
    └── eventTimestamp

    EVENT TYPE
    └── eventType (USER_CREATED|USER_UPDATED|EMAIL_VERIFIED|
                   PASSWORD_CHANGED|MFA_ENABLED|MFA_DISABLED|
                   LOGIN_SUCCESS|LOGIN_FAILED|LOGOUT|
                   ACCOUNT_LOCKED|ACCOUNT_UNLOCKED|
                   PROFILE_UPDATED|SETTINGS_CHANGED|
                   INVITATION_SENT|INVITATION_ACCEPTED)

    EVENT DETAILS
    ├── eventDescription
    ├── eventData (JSON - full context)
    └── eventActorId → Actor (who triggered event)

    CONTEXT
    ├── ipAddress
    ├── userAgent
    ├── geolocation
    └── sessionId → Session

    CHANGES (if update event)
    ├── changedFields[] (list of fields changed)
    ├── oldValues (JSON - before state)
    └── newValues (JSON - after state)

    PURPOSE:
    Complete audit trail of user account changes. Required for
    compliance and security investigations.

    RETENTION:
    Keep indefinitely for critical events (password changes, MFA),
    7 years for compliance events.

    INDEXES (6)
    ├── [userId, eventTimestamp]
    ├── [eventType]
    ├── [eventActorId]
    ├── [sessionId]
    ├── [eventTimestamp] BRIN
    └── [createdAt]
```

---

## 🔄 IDENTITY FLOW DIAGRAMS

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         USER REGISTRATION FLOW                               │
└─────────────────────────────────────────────────────────────────────────────┘

    User visits signup page
              │
              ▼
    ┌─────────────────────────┐
    │ Enter email + password  │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Validate inputs         │  ← Email unique, strong password
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Create Actor            │  ← Universal identity
    │ (globalId assigned)     │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Create User             │  ← Links to Actor
    │ (hash password)         │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Send verification email │  ← Token in link
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ User status: PENDING    │
    └──────────┬──────────────┘
               │
    User clicks email verification link
               │
               ▼
    ┌─────────────────────────┐
    │ Verify token            │
    │ Mark email verified     │
    │ User status: ACTIVE     │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Create Session          │  ← Auto-login
    └──────────┬──────────────┘
               │
               ▼
    Redirect to dashboard / onboarding

┌─────────────────────────────────────────────────────────────────────────────┐
│                         USER LOGIN FLOW (MFA)                                │
└─────────────────────────────────────────────────────────────────────────────┘

    User enters email + password
              │
              ▼
    ┌─────────────────────────┐
    │ Find User by email      │
    └──────────┬──────────────┘
               │
               ├──► Not found ──► Login failed
               │
               ▼
    ┌─────────────────────────┐
    │ Check account status    │
    └──────────┬──────────────┘
               │
               ├──► Locked ──► Show "account locked" message
               ├──► Suspended ──► Show "account suspended"
               │
               ▼
    ┌─────────────────────────┐
    │ Verify password         │  ← bcrypt.compare()
    └──────────┬──────────────┘
               │
               ├──► Wrong ──► Increment failedLoginAttempts
               │              Lock if >= 5 attempts
               │
               ▼
    ┌─────────────────────────┐
    │ Password correct ✓      │
    │ Reset failedAttempts    │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ MFA enabled?            │
    └──────────┬──────────────┘
               │
               ├──► NO ──► Create Session ──► Login success
               │
               ▼
    ┌─────────────────────────┐
    │ Send MFA challenge      │  ← TOTP / SMS / Email
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ User enters MFA code    │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Verify MFA code         │
    └──────────┬──────────────┘
               │
               ├──► Invalid ──► Allow 3 attempts, then fail
               │
               ▼
    ┌─────────────────────────┐
    │ MFA verified ✓          │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ Create Session          │
    │ Update lastLoginAt      │
    │ Increment loginCount    │
    └──────────┬──────────────┘
               │
               ▼
    ┌─────────────────────────┐
    │ UserHistoryEvent        │  ← Log LOGIN_SUCCESS
    └──────────┬──────────────┘
               │
               ▼
    Redirect to dashboard
```

---

## 🔗 CROSS-MODULE INTEGRATIONS

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         INTEGRATION ARCHITECTURE                             │
└─────────────────────────────────────────────────────────────────────────────┘

    IDENTITY → MEMBERSHIP
    ══════════════════════
    Actor → Member[] (1:N - user can join multiple tenants)
    User.actorId → Actor.id (1:1)
    
    IDENTITY → ACCESS CONTROL
    ═════════════════════════
    Actor used in ALL audit trails (createdByActorId, etc.)
    Session.actorId → used for permission checks
    
    IDENTITY → SECURITY
    ═══════════════════
    User → Session[] (active logins)
    User → AuthFactor[] (MFA devices)
    User → PasswordResetToken[]
    User → AccountLockout[]
    
    IDENTITY → APPROVALS
    ════════════════════
    Actor → ApprovalRequest (submitter, approver attribution)
    
    IDENTITY → ALL BUSINESS MODULES
    ═══════════════════════════════
    Actor is the universal "who did this" for:
    - Estimate.createdByActorId
    - Project.createdByActorId
    - Invoice.createdByActorId
    - Expense.createdByActorId
    - Every model with audit attribution
```

---

**Document Version:** 1.0  
**Document Status:** ✅ Production-Ready  
**Alignment Status:** ✅ Fully Aligned with Platform Standards  
**Pattern Compliance:** ✅ BH (Actor), Pattern A (all others)  
**Integration Validation:** ✅ All cross-module references validated  
**Next Review:** Upon schema changes or feature additions
