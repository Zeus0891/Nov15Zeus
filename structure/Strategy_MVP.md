# 🚀 MVP Implementation Strategy - BeeSmart ERP

## Executive Overview

**IMPORTANT**: ALL 64 modules in the complete architecture WILL be implemented. This document outlines the **prioritized implementation order** for the MVP (beta free signup) phase.

## 🎯 Phase 1 Priority Modules (First 8 Modules)

The following modules will be completed FIRST to establish the foundational platform:

### Global/Platform Foundation (5 modules)

1. **`identityCore.prisma`** - Core user identity system
2. **`identityAuthN.prisma`** - Authentication engine
3. **`identityAuthZ.prisma`** - Authorization and permissions
4. **`platformRegistry.prisma`** - Tenant registry
5. **`publicLinkEngine.prisma`** - Public link infrastructure

### Tenant Foundation (3 modules)

6. **`tenantConfig.prisma`** - Tenant configuration and settings
7. **`membership.prisma`** - Member management within tenants
8. **`accessControlTenant.prisma`** - RBAC/ABAC implementation

---

## 📋 Table Exclusions for Phase 1

Within the 8 priority modules above, the following tables can be implemented in later phases while maintaining core functionality:

---

## 1) PLATFORM_IDENTITY (`identityCore.prisma`) - Priority Module #1

✅ **Will be implemented in Phase 1**

For basic signup/login functionality, the following tables can be deferred to later phases:

**Postergar (NO MVP):**

- `Actor`

  - Solo lo necesitas cuando tengas un motor de auditoría cross-módulo “serio” y service accounts actuando como actores.

- `UserDevice`

  - Device fingerprinting y gestión avanzada de sesiones por dispositivo es nice-to-have.

- `UserDeviceHistoryEvent`

  - Historial detallado de confianza/cambios de dispositivos, útil para security forensics, no para un MVP.

- `UserHistoryEvent`

  - Auditoría fina de cambios de cuenta; puedes empezar con logs de aplicación o una tabla genérica más adelante.

- `UserSetting`

  - Preferencias globales (tema, idioma global) se pueden hardcodear o guardar luego.

- `UserApiKey`

  - No hay API pública en el MVP → sin necesidad de API keys personales.

- `UserInvitation`

  - En MVP puedes usar solo “self-signup” y dejar invitaciones globales para una fase posterior.

**Seguramente SÍ en MVP:**

- `User`, `Session`, `RecoveryCode` (si vas a soportar MFA pronto), `UserProfile` (aunque sea mínimo).

---

## 2) PLATFORM_AUTHENTICATION (`identityAuthN.prisma`) - Priority Module #2

✅ **Will be implemented in Phase 1**

For basic email + password + reset functionality, the following can be deferred:

**Postergar (NO MVP):**

- `IdentityProvider`

  - SSO (Google, Okta, etc.) es claramente fase 2.

- `AuthFactor`

  - Si no vas a lanzar con MFA desde el día 1, difiérelo.

- `AuthFactorChallenge`

  - Igual: depende de tener MFA.

- `AccountLockout`

  - Puedes empezar con una política simple en código (rate limiting a nivel de API/gateway) y luego formalizar tabla.

- `SSOSession`

  - Sin SSO, no se usa.

- `SecurityEvent`

  - Puedes dejar la auditoría de seguridad avanzada para después; al inicio bastan logs de aplicación.

**Probable SÍ en MVP:**

- `PasswordResetToken`

  - Necesario para reset de contraseña “olvidé mi password”.

---

## 3) PLATFORM_GOVERNANCE (`platformRegistry.prisma`) - Priority Module #3

✅ **Will be implemented in Phase 1**

Contains only:

- `Tenant`

**This MUST be included in Phase 1.**
No tables to defer - complete implementation required.

---

## 4) PUBLICLINKENGINE (`publicLinkEngine.prisma`) - Priority Module #4

✅ **Will be implemented in Phase 1**

The `...PublicLink` pattern in HYBRID modules depends on this engine. Start simple but implement foundation:

**Postergar (NO MVP):**

- `PublicLinkAnalytics`

  - Métricas finas de uso de links (por hora, tasas de fallo, etc.). Puedes loguear a un sistema de logs genérico al inicio.

- `PublicLinkSecurityEvent`

  - Detección avanzada de intrusiones / abuso. De nuevo, se puede hacer luego con observability más madura.

**Opcional (decisión tuya):**

- `PublicLinkTemplate`

  - Si en MVP puedes vivir con expiraciones y políticas “hardcodeadas” en código, también podría postergarse.
  - Si quieres que los productos (Estimate, Invoice, etc.) lean defaults configurables, entonces sí implementas esta desde el inicio.

---

## 5) PLATFORM_AUTHORIZATION (`identityAuthZ.prisma`) - Priority Module #5

✅ **Will be implemented in Phase 1**

Solo contiene:

- `Permission`
- `AccessResource`

La idea es que este módulo es el catálogo global que tu RBAC tenant-level consume.

**Recomendación:**

- **NO postergaría ninguna**: son tablas pequeñas, fáciles de poblar y fundamentales para no hardcodear permisos en todo el código.

---

## 6) TENANT_ACCESSCONTROL (`accessControlTenant.prisma`) - Priority Module #6

✅ **Will be implemented in Phase 1**

For simple tenant-level RBAC (roles + members), these tables can be deferred:

**Postergar (NO MVP):**

- `AccessPolicy`
- `AccessPolicyCondition`

  - Motor ABAC/ReBAC completo (condiciones, atributos, reglas complejas). Overkill para el MVP.

- `AccessScope`
- `AccessScopeAssignment`

  - Scopes avanzados ("own", "team", "department") pueden ser simples strings en roles al inicio.

- `AccessAuditEvent`

  - Auditoría fina de autorización puede ir a logs de aplicación por ahora.

**Essential for Phase 1:**

- `Role`, `RolePermission`, `MemberRole`
- `ServiceAccount`, `ServiceAccountKey` (for API integrations)

---

## 7) TENANT_CONFIG (`tenantConfig.prisma`) - Priority Module #7

✅ **Will be implemented in Phase 1**

Core tenant configuration required for multi-tenant operations. Some tables can be simplified:

**Defer to later phases:**

- `TenantUsageRecord` - Usage tracking for billing
- `TenantDomain` - Custom domain management
- `TenantBranding` - White-label customization
- `TenantFeatureFlag` - Advanced feature toggling
- `TenantComplianceSetting` - Compliance configurations
- `TenantIdentityProvider` - SSO provider mapping

**Essential for Phase 1:**

- `TenantSettings` - Core settings (timezone, locale, currency)
- `TenantSubscription` - Basic subscription status
- `TenantModule` - Module enablement
- `TenantHistoryEvent` - Configuration audit trail

---

## 8) MEMBERSHIP (`membership.prisma`) - Priority Module #8

✅ **Will be implemented in Phase 1**

Bridges global User identity to tenant-specific Member context. Some features can be deferred:

**Defer to later phases:**

- `MemberExternalLink` - External profile linking
- `MemberDocument` - HR document management

**Essential for Phase 1:**

- `Member` - Core user-tenant bridge
- `MemberSettings` - Basic member preferences
- `MemberInvitation` - Team invitation system
- `MemberHistoryEvent` - Member lifecycle tracking

---

## 📅 Implementation Timeline

### Phase 1 (Weeks 1-4): Foundation

- Complete the 8 priority modules listed above
- Essential tables only, defer advanced features
- Basic CRUD operations and authentication
- Multi-tenant isolation (RLS)

### Phase 2 (Weeks 5-8): Core Business

- Implement core HYBRID modules (estimate, invoice, project)
- Add essential TENANT modules (CRM, time tracking)
- Expand deferred tables from Phase 1

### Phase 3 (Weeks 9-16): Full Platform

- Complete all 64 modules
- Advanced features and integrations
- Full enterprise functionality

---

## 📊 Statistics Summary

- **Total Architecture**: 64 modules, 634 tables
- **Phase 1 Priority**: 8 modules (~50-60 core tables)
- **Deferred Tables**: ~30-40 advanced features
- **Full Implementation**: All modules will be completed

---

---

## 📋 Legacy Content (Previous Detailed Analysis)

The following sections contain the original detailed analysis of table exclusions for reference:

- `Role`, `RolePermission`, `MemberRole`

  - Lo mínimo para tener RBAC interno por tenant.

---

### 7. TENANT_CONFIG (`tenantConfig.prisma`)

Aquí es donde más pega la decisión de “sin billing/subscription en MVP”.

**Postergar (NO MVP):**

- `TenantSubscription`

  - No hay planes, límites comerciales ni estados de cobro en beta free.

- `TenantUsageRecord`

  - Metering para billing; no lo necesitas todavía.

- `TenantComplianceSetting`

  - Configuración avanzada de cumplimiento (GDPR residency granular, retención, etc.) se puede posponer.

- `TenantIdentityProvider`

  - Depende de SSO (que ya pospusimos).

- `TenantHistoryEvent`

  - Auditoría fina de cambios de configuración del tenant; nice-to-have, pero no bloqueante para beta.

**Seguramente SÍ en MVP:**

- `TenantSettings` (timezone, locale básicos)
- `TenantDomain` (si quieres subdominios por tenant)
- `TenantBranding` (si quieres mínimo branding)
- `TenantModule` (aunque sea estático, para saber qué módulos están “activos”)
- `TenantFeatureFlag` (útil incluso para ir activando features por tenant, pero podrías reemplazarlo por feature flags en código si quieres simplificar aún más).

---

### 8. MEMBERSHIP (`membership.prisma`)

Aquí quieres lo mínimo para que un User global exista como Member interno en un tenant.

**Postergar (NO MVP):**

- `MemberExternalLink`

  - Links a LinkedIn, HRIS, etc.; puro “nice to have”.

- `MemberDocument`

  - Docs HR (contratos, certificaciones, NDAs). No son necesarios para que la app funcione en beta.

- `MemberHistoryEvent`

  - Auditoría fina del lifecycle de Member. Puedes comenzar con logs simples y agregar esto cuando la estructura esté estable.

**Probable SÍ en MVP:**

- `Member` (clave)
- `MemberSettings` (aunque sea mínima)
- `MemberInvitation` (si quieres invitar usuarios al tenant; si no, podrías crearlos de forma directa y postergar esta también).

---

## 3) Resumen rápido para que lo tengas claro

En esta fase MVP (beta, signup gratis, sin billing/subscription, sin SSO, sin integraciones complejas), **NO implementaría**:

- En **GLOBAL**:

  - `Actor`, `UserDevice`, `UserDeviceHistory`, `UserHistoryEvent`, `UserSetting`, `UserApiKey`, `UserInvitation`
  - `IdentityProvider`, `AuthFactor`, `AuthFactorChallenge`, `AccountLockout`, `SSOSession`, `SecurityEvent`
  - `PublicLinkAnalytics`, `PublicLinkSecurityEvent` (y opcionalmente `PublicLinkTemplate` si prefieres hardcodear)

- En **TENANT SECURITY / CONFIG / MEMBERSHIP**:

  - `AccessPolicy`, `AccessPolicyCondition`, `AccessScope`, `AccessScopeAssignment`, `AccessAuditEvent`, `ServiceAccount`, `ServiceAccountKey`
  - `TenantSubscription`, `TenantUsageRecord`, `TenantComplianceSetting`, `TenantIdentityProvider`, `TenantHistoryEvent`
  - `MemberExternalLink`, `MemberDocument`, `MemberHistoryEvent` (y quizás `MemberInvitation` si ni siquiera vas a tener invitaciones internas en la primera iteración)

Con esto te quedas con:

- Auth simple (User + Session + PasswordResetToken),
- Un catálogo básico de permisos,
- Tenants funcionando sin planes de pago,
- RBAC minimalista (Role / RolePermission / MemberRole),
- Membresía simple por tenant,

y dejas todo lo “enterprise / billing / SSO / ABAC avanzado / auditoría fina” para una **Fase 2+** cuando tengas usuarios reales usando el sistema.
