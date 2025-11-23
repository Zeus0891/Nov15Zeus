# 📋 Tablas Excluidas del MVP

Lista completa de tablas que **NO** deben implementarse en la fase MVP (beta free signup) según `Strategy_MVP.md`.

---

## 🌐 GLOBAL MODULES

### 1. PLATFORM_IDENTITY (`identityCore.prisma`)

**Tablas a postergar:**
- `Actor`
- `UserDevice`
- `UserDeviceHistoryEvent` (nota: en modules_v11.md aparece como `UserDeviceHistoryEvent`)
- `UserHistoryEvent`
- `UserSetting`
- `UserApiKey`
- `UserInvitation`

**Total: 7 tablas**

---

### 2. PLATFORM_AUTHENTICATION (`identityAuthN.prisma`)

**Tablas a postergar:**
- `IdentityProvider`
- `AuthFactor`
- `AuthFactorChallenge`
- `AccountLockout`
- `SSOSession`
- `SecurityEvent`

**Total: 6 tablas**

---

### 3. PUBLICLINKENGINE (`publicLinkEngine.prisma`)

**Tablas a postergar:**
- `PublicLinkAnalytics`
- `PublicLinkSecurityEvent`

**Opcional (decisión del equipo):**
- `PublicLinkTemplate` (puede postergarse si se hardcodean las políticas)

**Total: 2-3 tablas**

---

## 🏢 TENANT MODULES

### 4. TENANT_ACCESSCONTROL (`accessControlTenant.prisma`)

**Tablas a postergar:**
- `AccessPolicy`
- `AccessPolicyCondition`
- `AccessScope`
- `AccessScopeAssignment`
- `AccessAuditEvent`
- `ServiceAccount`
- `ServiceAccountKey`

**Total: 7 tablas**

---

### 5. TENANT_CONFIG (`tenantConfig.prisma`)

**Tablas a postergar:**
- `TenantSubscription`
- `TenantUsageRecord`
- `TenantComplianceSetting`
- `TenantIdentityProvider`
- `TenantHistoryEvent`

**Total: 5 tablas**

---

### 6. MEMBERSHIP (`membership.prisma`)

**Tablas a postergar:**
- `MemberExternalLink`
- `MemberDocument`
- `MemberHistoryEvent`

**Opcional (decisión del equipo):**
- `MemberInvitation` (si no se implementan invitaciones internas en la primera iteración)

**Total: 3-4 tablas**

---

## 📊 RESUMEN TOTAL

### Por categoría:

| Categoría | Cantidad de Tablas |
|-----------|-------------------|
| **GLOBAL** | 15-16 tablas |
| **TENANT** | 15-16 tablas |
| **TOTAL** | **30-32 tablas** |

### Lista completa (sin duplicados):

**GLOBAL (15-16 tablas):**
1. Actor
2. UserDevice
3. UserDeviceHistoryEvent
4. UserHistoryEvent
5. UserSetting
6. UserApiKey
7. UserInvitation
8. IdentityProvider
9. AuthFactor
10. AuthFactorChallenge
11. AccountLockout
12. SSOSession
13. SecurityEvent
14. PublicLinkAnalytics
15. PublicLinkSecurityEvent
16. PublicLinkTemplate (opcional)

**TENANT (15-16 tablas):**
1. AccessPolicy
2. AccessPolicyCondition
3. AccessScope
4. AccessScopeAssignment
5. AccessAuditEvent
6. ServiceAccount
7. ServiceAccountKey
8. TenantSubscription
9. TenantUsageRecord
10. TenantComplianceSetting
11. TenantIdentityProvider
12. TenantHistoryEvent
13. MemberExternalLink
14. MemberDocument
15. MemberHistoryEvent
16. MemberInvitation (opcional)

---

## ✅ Tablas que SÍ van en MVP

### GLOBAL:
- `User`
- `Session`
- `RecoveryCode` (si se soporta MFA)
- `UserProfile`
- `PasswordResetToken`
- `Tenant`
- `Permission`
- `AccessResource`
- `PublicLinkTemplate` (si se quiere configuración dinámica)

### TENANT:
- `Role`
- `RolePermission`
- `MemberRole`
- `TenantSettings`
- `TenantDomain` (opcional)
- `TenantBranding` (opcional)
- `TenantModule`
- `TenantFeatureFlag` (opcional)
- `Member`
- `MemberSettings`
- `MemberInvitation` (si se implementan invitaciones)

---

## 📝 Notas

- Las tablas marcadas como "opcionales" dependen de decisiones específicas del equipo sobre funcionalidades del MVP.
- Esta lista se basa en la estrategia de MVP que prioriza funcionalidad básica sin features enterprise avanzadas.
- Todas las demás tablas de los módulos de negocio (Estimate, Invoice, Project, etc.) **SÍ** deben implementarse en el MVP.

