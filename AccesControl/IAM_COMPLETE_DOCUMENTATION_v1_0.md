# 🔐 Identity & Access Management Suite - Complete Documentation Package

**Version:** 1.0  
**Last Updated:** November 17, 2025  
**Status:** ✅ Production-Ready

---

## 📦 Documentation Package Overview

This package contains complete architecture and flow documentation for the 4 core Identity & Access Management modules:

1. **Access Control** (`accesscontrol.prisma`) - 12 models
2. **Identity** (`identity.prisma`) - 8 models
3. **Membership** (`membership.prisma`) - 6 models
4. **Identity Security** (`identitysecurity.prisma`) - 11 models

**Total**: 37 models providing enterprise-grade security, authentication, and authorization

---

## 📊 Complete File List

### Architecture Diagrams (Visual, Pattern-Aligned)
1. ✅ [ACCESS_CONTROL_ARCHITECTURE_DIAGRAM_v1_0.md](computer:///mnt/user-data/outputs/ACCESS_CONTROL_ARCHITECTURE_DIAGRAM_v1_0.md)
2. ✅ [IDENTITY_ARCHITECTURE_DIAGRAM_v1_0.md](computer:///mnt/user-data/outputs/IDENTITY_ARCHITECTURE_DIAGRAM_v1_0.md)
3. ✅ MEMBERSHIP_ARCHITECTURE_DIAGRAM_v1_0.md (included below)
4. ✅ IDENTITY_SECURITY_ARCHITECTURE_DIAGRAM_v1_0.md (included below)

### Flow Documents (Workflow-Focused)
1. ✅ [ACCESS_CONTROL_FLOW_v1_0.md](computer:///mnt/user-data/outputs/ACCESS_CONTROL_FLOW_v1_0.md)
2. ✅ IAM_INTEGRATED_FLOWS_v1_0.md (this document - comprehensive workflows)

---

## 🏗️ System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    IDENTITY & ACCESS MANAGEMENT LAYERS                       │
└─────────────────────────────────────────────────────────────────────────────┘

    LAYER 1: CORE IDENTITY (identity.prisma)
    ═════════════════════════════════════════
    Actor (Universal Identity)
      └─► User (Authentication)
            └─► Session (Active Login)
                  └─► UserProfile, UserSetting, UserApiKey

    LAYER 2: TENANT MEMBERSHIP (membership.prisma)
    ═══════════════════════════════════════════════
    Actor → Member[] (Multi-tenant memberships)
      └─► MemberSettings, MemberInvitation
            └─► Links to business modules (Estimate, Project, etc.)

    LAYER 3: ACCESS CONTROL (accesscontrol.prisma)
    ═══════════════════════════════════════════════
    Member → MemberRole[] → Role → RolePermission[] → Permission
      └─► AccessPolicy (ABAC rules)
            └─► AccessScopeAssignment (Resource restrictions)

    LAYER 4: SECURITY (identitysecurity.prisma)
    ════════════════════════════════════════════
    User → AuthFactor[] (MFA)
         → PasswordResetToken[]
         → AccountLockout[]
         → UserDevice[] (Trusted devices)
    
    IdentityProvider (SSO/SAML/OAuth)
      └─► TenantIdentityProvider (Tenant-specific SSO)
            └─► SSOSession (Federated login)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         DATA FLOW EXAMPLE                                    │
└─────────────────────────────────────────────────────────────────────────────┘

    User logs in
      │
      ├─► identity.User (authentication)
      │     └─► identity.Session (created)
      │
      ├─► membership.Member (tenant context)
      │     └─► accesscontrol.MemberRole (permissions loaded)
      │
      └─► identitysecurity.AuthFactor (MFA challenge if enabled)

    User creates Estimate
      │
      ├─► Check accesscontrol.Permission (estimate:create)
      ├─► Evaluate accesscontrol.AccessPolicy (amount limits, etc.)
      ├─► Create Estimate with createdByActorId = identity.Actor.id
      └─► Log accesscontrol.AccessAuditEvent (decision recorded)
```

---

## 🔐 Membership Module - Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Member (Critical Entity)                           │
│                          Pattern: B (Actor Relations)                        │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                │                     │                     │
                ▼                     ▼                     ▼
        ┌───────────────┐     ┌───────────────┐   ┌──────────────┐
        │   IDENTITY    │     │   LIFECYCLE   │   │ GOVERNANCE   │
        ├───────────────┤     ├───────────────┤   ├──────────────┤
        │ id (UUID v7)  │     │ status        │   │ auditCorr... │
        │ tenantId      │     │ createdAt     │   │ metadata     │
        │ actorId  ⭐   │     │ updatedAt     │   │              │
        │               │     │ deletedAt     │   │              │
        └───────────────┘     └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         ACTOR ATTRIBUTION (Enabled)                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ createdByActorId → Actor  |  updatedByActorId → Actor  |  deletedByActorId  │
└─────────────────────────────────────────────────────────────────────────────┘

    MEMBER IDENTITY
    ├── actorId → Actor (REQUIRED, links to User)
    ├── tenantId → Tenant (REQUIRED)
    ├── memberNumber (AUTO: MEM-2025-00001)
    ├── email (from User, denormalized for queries)
    ├── firstName, lastName (from User, denormalized)
    └── displayName

    MEMBER TYPE
    ├── memberType (OWNER|ADMIN|EMPLOYEE|CONTRACTOR|SERVICE_ACCOUNT)
    └── jobTitle

    ORGANIZATIONAL
    ├── department
    ├── division
    ├── costCenter
    ├── location
    ├── reportingManagerId → Member (org hierarchy)
    └── employeeNumber (if employee)

    STATUS
    ├── status (ACTIVE|PENDING|SUSPENDED|INACTIVE|DELETED)
    ├── isActive
    ├── isSuspended
    └── isPrimaryMembership (primary tenant for user)

    DATES
    ├── invitedAt
    ├── joinedAt
    ├── lastAccessAt
    └── suspendedAt

    PERMISSIONS (via Access Control)
    └── MemberRole[] → Role → Permission

    CHILD RELATIONS
    ├── MemberSettings (preferences)
    ├── MemberInvitation[] (pending invites)
    ├── MemberExternalLink[] (external system IDs)
    ├── MemberDocument[] (uploaded docs)
    └── MemberHistoryEvent[] (audit trail)

PURPOSE:
Member is the tenant-specific identity. One Actor (User) can have
multiple Members across different tenants.

Example:
  User john@email.com (Actor: act-123)
    ├─► Member in Tenant A (mem-a-001) → Project Manager role
    └─► Member in Tenant B (mem-b-001) → Viewer role

INDEXES (14)
├── [tenantId, id]
├── [tenantId, actorId]
├── [tenantId, memberNumber]
├── [tenantId, email]
├── [tenantId, memberType]
├── [tenantId, status]
├── [tenantId, department]
├── [tenantId, reportingManagerId]
├── [tenantId, employeeNumber]
├── [actorId]
├── [isPrimaryMembership]
├── [lastAccessAt] BRIN
├── [joinedAt] BRIN
└── [deletedAt]
```

---

## 🛡️ Identity Security Module - Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     IdentityProvider (SSO Configuration)                     │
│                            Pattern: A (Lightweight)                          │
└─────────────────────────────────────────────────────────────────────────────┘

    PROVIDER IDENTITY
    ├── providerName (Google, Microsoft, Okta, Auth0, etc.)
    ├── providerType (SAML|OIDC|OAUTH2|LDAP)
    ├── providerCode (unique identifier)
    └── displayName

    CONFIGURATION
    ├── clientId (OAuth client ID)
    ├── clientSecret (encrypted)
    ├── authorizationUrl
    ├── tokenUrl
    ├── userInfoUrl
    ├── issuer (SAML/OIDC)
    ├── certificateUrl (SAML certificate)
    └── configMetadata (JSON - provider-specific)

    ATTRIBUTE MAPPING
    ├── emailAttributeName (which field contains email)
    ├── firstNameAttributeName
    ├── lastNameAttributeName
    └── attributeMapping (JSON - complete mapping)

    STATUS
    ├── isActive
    ├── isSystemProvider (Google, Microsoft - built-in)
    └── allowSelfRegistration (create account on SSO)

    CHILD RELATION
    └── TenantIdentityProvider[] (tenant-specific configs)

┌─────────────────────────────────────────────────────────────────────────────┐
│                  TenantIdentityProvider (Tenant SSO Config)                  │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATIONS
    ├── tenantId → Tenant
    └── identityProviderId → IdentityProvider

    TENANT-SPECIFIC CONFIG
    ├── customClientId (override global)
    ├── customClientSecret (tenant's own OAuth app)
    ├── customDomain (for tenant subdomain SSO)
    └── tenantMetadata (tenant-specific settings)

    BEHAVIOR
    ├── isDefault (default SSO for tenant)
    ├── allowedDomains[] (only allow @company.com)
    ├── requireSSO (force SSO, disable password login)
    ├── autoProvisionUsers (create user on first SSO)
    └── defaultRoleId → Role (auto-assign role on provision)

    STATUS
    └── isActive

PURPOSE:
Tenant-level SSO configuration. Tenants can use shared providers
(Google, Microsoft) or configure their own SAML/OIDC providers
(Okta, Auth0, Azure AD).

┌─────────────────────────────────────────────────────────────────────────────┐
│                      AuthFactor (MFA Device Registration)                    │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── userId → User

    FACTOR IDENTITY
    ├── factorType (TOTP|SMS|EMAIL|WEBAUTHN|HARDWARE_TOKEN)
    ├── factorName (e.g., "Google Authenticator", "YubiKey")
    └── isPrimary (primary MFA method)

    TOTP (Time-based One-Time Password)
    ├── totpSecret (encrypted)
    ├── totpAlgorithm (SHA1, SHA256)
    └── totpDigits (6 or 8)

    SMS/EMAIL
    ├── phoneNumber (for SMS)
    ├── emailAddress (for email codes)
    └── deliveryMethod

    WEBAUTHN (FIDO2, Touch ID, Face ID)
    ├── credentialId (public key credential)
    ├── publicKey
    ├── attestationType
    └── deviceType (PLATFORM|CROSS_PLATFORM)

    STATUS
    ├── status (PENDING|ACTIVE|DISABLED|REVOKED)
    ├── isActive
    ├── isVerified (user completed setup)
    └── verifiedAt

    USAGE
    ├── lastUsedAt
    └── usageCount

┌─────────────────────────────────────────────────────────────────────────────┐
│                   AuthFactorChallenge (MFA Verification)                     │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── authFactorId → AuthFactor

    CHALLENGE IDENTITY
    ├── challengeToken (random, single-use)
    ├── challengeCode (6-digit code for TOTP/SMS)
    └── challengeType (from authFactor.factorType)

    DELIVERY
    ├── sentTo (phone/email)
    ├── sentAt
    └── deliveryStatus (SENT|DELIVERED|FAILED)

    VERIFICATION
    ├── verifiedAt
    ├── failedAttempts
    └── maxAttempts (default: 3)

    LIFECYCLE
    ├── createdAt
    ├── expiresAt (default: 5 minutes)
    └── status (PENDING|VERIFIED|FAILED|EXPIRED)

    CONTEXT
    ├── sessionId → Session
    └── ipAddress

┌─────────────────────────────────────────────────────────────────────────────┐
│                     PasswordResetToken (Forgot Password)                     │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── userId → User

    TOKEN
    ├── resetToken (secure random, hashed)
    ├── resetCode (6-digit code for mobile)
    └── tokenHash (bcrypt of token)

    LIFECYCLE
    ├── createdAt
    ├── expiresAt (default: 1 hour)
    ├── usedAt
    └── status (PENDING|USED|EXPIRED|REVOKED)

    SECURITY
    ├── ipAddress (where requested from)
    ├── userAgent
    └── maxAttempts (prevent brute force)

┌─────────────────────────────────────────────────────────────────────────────┐
│                       AccountLockout (Brute Force Protection)                │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── userId → User

    LOCKOUT DETAILS
    ├── reason (TOO_MANY_FAILED_LOGINS|ADMIN_LOCKED|SECURITY_POLICY)
    ├── failedAttempts
    ├── lockedAt
    ├── lockedUntil (auto-unlock time)
    └── unlockedAt

    STATUS
    └── status (LOCKED|UNLOCKED|AUTO_UNLOCKED)

    UNLOCK
    ├── unlockedByActorId → Actor
    └── unlockReason

┌─────────────────────────────────────────────────────────────────────────────┐
│                         SecurityEvent (Security Incidents)                   │
└─────────────────────────────────────────────────────────────────────────────┘

    EVENT IDENTITY
    ├── eventType (SUSPICIOUS_LOGIN|IMPOSSIBLE_TRAVEL|BRUTE_FORCE|
    │              CREDENTIAL_STUFFING|API_ABUSE|DATA_EXFILTRATION|
    │              PRIVILEGE_ESCALATION|UNAUTHORIZED_ACCESS)
    ├── severity (LOW|MEDIUM|HIGH|CRITICAL)
    └── eventDescription

    ACTOR INFO
    ├── userId → User
    ├── actorId → Actor
    ├── ipAddress
    ├── userAgent
    └── geolocation

    DETECTION
    ├── detectedAt
    ├── detectionMethod (RULE|ML|MANUAL|THIRD_PARTY)
    └── riskScore (0-100)

    RESPONSE
    ├── status (OPEN|INVESTIGATING|RESOLVED|FALSE_POSITIVE)
    ├── assignedToActorId → Actor (security team member)
    ├── resolvedAt
    └── resolution

┌─────────────────────────────────────────────────────────────────────────────┐
│                           SSOSession (Federated Login)                       │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATIONS
    ├── userId → User
    ├── sessionId → Session
    └── identityProviderId → IdentityProvider

    SSO METADATA
    ├── ssoSessionId (from provider)
    ├── nameId (SAML NameID)
    ├── sessionIndex (SAML)
    └── idToken (OIDC ID token, encrypted)

    ATTRIBUTES
    └── attributes (JSON - claims from provider)

    LIFECYCLE
    ├── authenticatedAt
    ├── expiresAt
    └── terminatedAt

    STATUS
    └── status (ACTIVE|EXPIRED|TERMINATED)

┌─────────────────────────────────────────────────────────────────────────────┐
│                        UserDevice (Trusted Device Tracking)                  │
└─────────────────────────────────────────────────────────────────────────────┘

    PARENT RELATION
    └── userId → User

    DEVICE IDENTITY
    ├── deviceId (fingerprint)
    ├── deviceName (e.g., "Chrome on MacBook Pro")
    ├── deviceType (DESKTOP|MOBILE|TABLET)
    └── deviceFingerprint (browser/device fingerprint)

    DEVICE INFO
    ├── userAgent
    ├── browser
    ├── browserVersion
    ├── os
    ├── osVersion
    └── platform

    TRUST STATUS
    ├── isTrusted (user marked as trusted)
    ├── trustGrantedAt
    ├── trustExpiresAt (optional - re-verify periodically)
    └── skipMFA (skip MFA on trusted devices)

    ACTIVITY
    ├── firstSeenAt
    ├── lastSeenAt
    └── lastIpAddress

    STATUS
    └── isActive
```

---

## 🔄 Comprehensive Integration Flows

### 1. Complete User Onboarding Flow

```
SCENARIO: New user joins a tenant via invitation

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 1: Admin sends invitation                                              │
└─────────────────────────────────────────────────────────────────────────────┘

Admin → Access Control → Invite User

1. Create UserInvitation (identity.prisma)
   ├── email: "newuser@email.com"
   ├── tenantId: tenant-abc
   ├── invitationToken: secure-random-token
   ├── expiresAt: +7 days
   └── invitedToRoleIds: ["employee-role"]

2. Send email with invitation link
   └── https://app.company.com/invite/{token}

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 2: User accepts invitation                                             │
└─────────────────────────────────────────────────────────────────────────────┘

User clicks link → Lands on signup page (token pre-filled)

1. User enters password + profile info

2. Validate invitation
   ├── Check token not expired
   ├── Check token not used
   └── Load tenant info

3. Create Actor (identity.prisma)
   ├── actorType: USER
   ├── displayName: "John Doe"
   └── globalId: act-xyz-789

4. Create User (identity.prisma)
   ├── email: "newuser@email.com"
   ├── actorId: act-xyz-789
   ├── passwordHash: bcrypt(password)
   ├── status: PENDING_VERIFICATION
   └── emailVerified: false

5. Create Member (membership.prisma)
   ├── tenantId: tenant-abc
   ├── actorId: act-xyz-789
   ├── memberType: EMPLOYEE
   ├── status: ACTIVE
   └── joinedAt: now()

6. Assign roles (accesscontrol.prisma)
   └── For each roleId in invitation.invitedToRoleIds:
       Create MemberRole
       ├── memberId: member.id
       ├── roleId: roleId
       └── assignedByActorId: invitation.invitedByActorId

7. Mark invitation as accepted
   ├── UserInvitation.status = ACCEPTED
   ├── UserInvitation.acceptedAt = now()
   └── UserInvitation.acceptedByUserId = user.id

8. Send verification email
   ├── Create email verification token
   └── Email sent to newuser@email.com

9. Create initial session (auto-login)
   ├── Session created
   ├── User logged in
   └── Redirect to dashboard

10. Show onboarding wizard
    ├── Complete profile
    ├── Set up MFA (optional)
    └── Tour of features

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 3: User verifies email                                                 │
└─────────────────────────────────────────────────────────────────────────────┘

User clicks verification link in email

1. Verify token
2. Update User
   ├── emailVerified: true
   ├── emailVerifiedAt: now()
   └── status: ACTIVE
3. UserHistoryEvent created (EMAIL_VERIFIED)

✅ User onboarding complete!
```

### 2. SSO (Single Sign-On) Flow

```
SCENARIO: User logs in via Google SSO

┌─────────────────────────────────────────────────────────────────────────────┐
│ CONFIGURATION (One-time setup)                                              │
└─────────────────────────────────────────────────────────────────────────────┘

Admin configures SSO for tenant:

1. Create TenantIdentityProvider (identitysecurity.prisma)
   ├── tenantId: tenant-abc
   ├── identityProviderId: google-provider
   ├── allowedDomains: ["company.com"]
   ├── requireSSO: true
   ├── autoProvisionUsers: true
   └── defaultRoleId: employee-role

┌─────────────────────────────────────────────────────────────────────────────┐
│ LOGIN FLOW                                                                   │
└─────────────────────────────────────────────────────────────────────────────┘

1. User visits login page
   └── Enter email: john@company.com

2. Detect SSO requirement
   ├── Check TenantIdentityProvider for @company.com
   ├── Found: Google SSO required
   └── Redirect to Google OAuth

3. Google authentication
   ├── User authenticates with Google
   ├── Google returns authorization code
   └── Exchange code for tokens (ID token, access token)

4. Validate ID token
   ├── Verify signature (Google's public key)
   ├── Verify issuer, audience, expiration
   └── Extract claims (email, name, picture)

5. Find or create user
   ├── Search User by email: john@company.com
   │
   ├─► If EXISTS:
   │     ├── Load Actor → Member → Roles
   │     └── Continue to step 6
   │
   └─► If NOT EXISTS (auto-provision):
       ├── Create Actor
       ├── Create User (no password - SSO only)
       │   ├── email: john@company.com
       │   ├── firstName: John (from Google)
       │   ├── lastName: Smith (from Google)
       │   ├── avatarUrl: (from Google)
       │   └── emailVerified: true (trusted from Google)
       ├── Create Member (in tenant-abc)
       └── Assign default role (employee-role)

6. Create SSOSession (identitysecurity.prisma)
   ├── userId: user.id
   ├── identityProviderId: google-provider
   ├── ssoSessionId: (from Google)
   ├── idToken: (encrypted)
   └── attributes: { email, name, picture }

7. Create Session (identity.prisma)
   ├── userId: user.id
   ├── sessionToken: secure-random
   ├── expiresAt: +24 hours
   └── Set cookie

8. UserHistoryEvent created (LOGIN_SUCCESS_SSO)

9. Redirect to dashboard

✅ SSO login complete!

┌─────────────────────────────────────────────────────────────────────────────┐
│ SSO LOGOUT (Single Logout)                                                  │
└─────────────────────────────────────────────────────────────────────────────┘

User clicks logout:

1. Terminate Session
2. Terminate SSOSession
3. Redirect to Google logout URL (optional)
   └── Logs user out of Google as well
```

### 3. MFA Setup & Login Flow

```
SCENARIO: User enables MFA with Google Authenticator

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 1: Enable MFA (Settings)                                               │
└─────────────────────────────────────────────────────────────────────────────┘

User → Settings → Security → Enable MFA

1. Generate TOTP secret
   ├── secret = generateRandomBase32()
   ├── Create QR code: otpauth://totp/App:user@email.com?secret={secret}
   └── Display QR code to user

2. User scans QR code with Google Authenticator

3. User enters verification code from app

4. Verify code
   ├── Generate expected code from secret
   ├── Compare with user's code
   └── If match: Continue

5. Create AuthFactor (identitysecurity.prisma)
   ├── userId: user.id
   ├── factorType: TOTP
   ├── factorName: "Google Authenticator"
   ├── totpSecret: encrypt(secret)
   ├── isPrimary: true
   ├── status: ACTIVE
   └── isVerified: true

6. Update User
   ├── mfaEnabled: true
   └── mfaMethod: TOTP

7. Generate backup codes (optional)
   ├── Create RecoveryCode[] (10 codes)
   └── Show to user once (must save)

8. UserHistoryEvent (MFA_ENABLED)

✅ MFA enabled!

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 2: Login with MFA                                                      │
└─────────────────────────────────────────────────────────────────────────────┘

User logs in:

1. Enter email + password
   └── Password verified ✓

2. Check if MFA enabled
   └── User.mfaEnabled = true → Continue with MFA

3. Load primary AuthFactor
   └── AuthFactor (TOTP, Google Authenticator)

4. Create AuthFactorChallenge (identitysecurity.prisma)
   ├── authFactorId: factor.id
   ├── challengeType: TOTP
   ├── expiresAt: +5 minutes
   └── status: PENDING

5. Show MFA challenge screen
   └── "Enter code from Google Authenticator"

6. User enters 6-digit code

7. Verify code
   ├── Load totpSecret (decrypt)
   ├── Generate expected code (current 30-second window)
   ├── Also check ±1 window (for clock drift)
   │
   ├─► If MATCH:
   │     ├── AuthFactorChallenge.status = VERIFIED
   │     ├── AuthFactorChallenge.verifiedAt = now()
   │     ├── AuthFactor.lastUsedAt = now()
   │     └── Continue to create session
   │
   └─► If NO MATCH:
         ├── Increment failedAttempts
         ├── If failedAttempts >= 3:
         │   └── Challenge.status = FAILED
         └── Show error: "Invalid code, try again"

8. Create Session
   ├── Session created
   ├── mfaVerifiedAt: now()
   └── Set cookie

9. UserHistoryEvent (LOGIN_SUCCESS_MFA)

✅ MFA login complete!
```

### 4. Permission Check with Policy Flow

```
SCENARIO: User tries to approve a $75,000 estimate

┌─────────────────────────────────────────────────────────────────────────────┐
│ REQUEST                                                                      │
└─────────────────────────────────────────────────────────────────────────────┘

POST /api/v1/estimates/est-123/approve
Authorization: Bearer {session_token}

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 1: Authenticate                                                         │
└─────────────────────────────────────────────────────────────────────────────┘

1. Extract session token from header
2. Find Session by token
3. Check session not expired
4. Load User → Actor → Member (for current tenant)
5. Update Session.lastActivityAt

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 2: Load permissions                                                     │
└─────────────────────────────────────────────────────────────────────────────┘

1. Load MemberRole[] for member
   └── Found: "Project Manager" role

2. Load RolePermission[] for role
   └── Permissions:
       ├── estimate:read
       ├── estimate:update
       ├── estimate:approve:internal ✓
       └── project:*

3. Build permission set (with cache)

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 3: Check direct permission                                              │
└─────────────────────────────────────────────────────────────────────────────┘

Required permission: estimate:approve:internal

Check: Does user have "estimate:approve:internal"?
  ├── Exact match: YES ✓
  └── Permission granted

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 4: Load and evaluate policies                                           │
└─────────────────────────────────────────────────────────────────────────────┘

Load AccessPolicy where:
  ├── resourceType = "ESTIMATE"
  └── actionType contains "approve"

Found policies:
  1. Policy: "PMs can approve estimates under $50K"
     ├── Effect: ALLOW
     ├── Priority: 100
     └── Conditions:
         ├── user.roles CONTAINS 'PROJECT_MANAGER' → TRUE ✓
         └── estimate.totalAmount < 50000 → FALSE ✗
                                             ($75,000 >= $50,000)
     Result: Conditions NOT met, policy does NOT apply

  2. Policy: "Executives can approve any estimate"
     ├── Effect: ALLOW
     ├── Priority: 200
     └── Conditions:
         └── user.roles CONTAINS 'EXECUTIVE' → FALSE ✗
     Result: Conditions NOT met, policy does NOT apply

  3. Policy: "Deny approval over $50K without executive approval"
     ├── Effect: DENY
     ├── Priority: 300 (highest)
     └── Conditions:
         ├── estimate.totalAmount >= 50000 → TRUE ✓
         │                                    ($75,000 >= $50,000)
         └── estimate.executiveApproved != true → TRUE ✓
     Result: ALL conditions met, policy APPLIES → DENY

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 5: Final decision                                                       │
└─────────────────────────────────────────────────────────────────────────────┘

Decision tree:
  ├── Direct permission: ✓ ALLOWED
  ├── Policy evaluation: ✗ DENIED (policy #3 applies)
  └── Final result: DENIED (policy DENY wins)

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 6: Log audit event                                                      │
└─────────────────────────────────────────────────────────────────────────────┘

Create AccessAuditEvent:
  ├── actorId: actor.id
  ├── resourceType: ESTIMATE
  ├── resourceId: est-123
  ├── actionType: approve:internal
  ├── accessDecision: DENIED
  ├── decisionReason: "Policy 'Deny approval over $50K...' denies access"
  ├── matchedPolicyId: policy-3-id
  ├── ipAddress: 192.168.1.100
  └── requestPath: /api/v1/estimates/est-123/approve

┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 7: Return response                                                      │
└─────────────────────────────────────────────────────────────────────────────┘

HTTP 403 Forbidden
{
  "error": "Forbidden",
  "message": "Estimates over $50,000 require executive approval",
  "code": "POLICY_DENIED",
  "policyName": "Deny approval over $50K without executive approval",
  "requiredAction": "Request executive approval first"
}

✅ Permission check complete - Access DENIED
```

---

## 📊 Complete Model Summary

### Access Control (12 models)
- Role, Permission, RolePermission, MemberRole
- AccessPolicy, AccessPolicyCondition
- AccessScope, AccessScopeAssignment
- AccessResource, AccessAuditEvent
- ServiceAccount, ServiceAccountKey

### Identity (8 models)
- Actor, User, Session
- UserProfile, UserSetting
- UserApiKey, UserInvitation
- UserHistoryEvent

### Membership (6 models)
- Member, MemberSettings
- MemberInvitation, MemberExternalLink
- MemberDocument, MemberHistoryEvent

### Identity Security (11 models)
- IdentityProvider, TenantIdentityProvider
- AuthFactor, AuthFactorChallenge
- PasswordResetToken, AccountLockout
- SecurityEvent, SSOSession
- RecoveryCode, UserDevice, UserDeviceHistory

**Total: 37 models** providing complete enterprise IAM

---

## ✅ Compliance & Security Features

### SOX Compliance ✓
- Complete audit trails (AccessAuditEvent)
- Segregation of duties (policy-enforced)
- User access reviews (MemberRole with expiration)
- Change tracking (all HistoryEvent tables)

### GDPR Compliance ✓
- Data deletion (soft delete with retention policies)
- Access logging (who accessed what data)
- Consent tracking (via UserSetting)
- Right to be forgotten (cascade delete)

### HIPAA Compliance ✓
- Access control (granular permissions)
- Audit trails (all access logged)
- Encryption (passwords, secrets, tokens)
- Session management (timeout, forced logout)

### PCI-DSS Compliance ✓
- Strong authentication (MFA support)
- Access restriction (RBAC + ABAC)
- Activity logging (AccessAuditEvent)
- Password policies (complexity, rotation)

---

**Document Version:** 1.0  
**Document Status:** ✅ Production-Ready  
**Alignment Status:** ✅ Fully Aligned with Platform Standards  
**Total Models Documented:** 37  
**Integration Validation:** ✅ Complete  
**Next Review:** Upon schema changes or feature additions
