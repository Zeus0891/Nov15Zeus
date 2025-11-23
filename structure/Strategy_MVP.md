Te respondo directo, módulo por módulo, solo con lo que **NO** implementaría en el MVP (beta free signup). Todo lo demás se asume que sí va en esta fase.

---

## 1) GLOBAL MODULES – Tablas que podemos postergar

### 1. PLATFORM_IDENTITY (`identityCore.prisma`)

Para un MVP con signup/login básico puedes reducir bastante:

**Postergar (NO MVP):**

* `Actor`

  * Solo lo necesitas cuando tengas un motor de auditoría cross-módulo “serio” y service accounts actuando como actores.
* `UserDevice`

  * Device fingerprinting y gestión avanzada de sesiones por dispositivo es nice-to-have.
* `UserDeviceHistory`

  * Historial detallado de confianza/cambios de dispositivos, útil para security forensics, no para un MVP.
* `UserHistoryEvent`

  * Auditoría fina de cambios de cuenta; puedes empezar con logs de aplicación o una tabla genérica más adelante.
* `UserSetting`

  * Preferencias globales (tema, idioma global) se pueden hardcodear o guardar luego.
* `UserApiKey`

  * No hay API pública en el MVP → sin necesidad de API keys personales.
* `UserInvitation`

  * En MVP puedes usar solo “self-signup” y dejar invitaciones globales para una fase posterior.

**Seguramente SÍ en MVP:**

* `User`, `Session`, `RecoveryCode` (si vas a soportar MFA pronto), `UserProfile` (aunque sea mínimo).

---

### 2. PLATFORM_AUTHENTICATION (AuthN) (`identityAuthN.prisma`)

Para arrancar con email + password + password reset:

**Postergar (NO MVP):**

* `IdentityProvider`

  * SSO (Google, Okta, etc.) es claramente fase 2.
* `AuthFactor`

  * Si no vas a lanzar con MFA desde el día 1, difiérelo.
* `AuthFactorChallenge`

  * Igual: depende de tener MFA.
* `AccountLockout`

  * Puedes empezar con una política simple en código (rate limiting a nivel de API/gateway) y luego formalizar tabla.
* `SSOSession`

  * Sin SSO, no se usa.
* `SecurityEvent`

  * Puedes dejar la auditoría de seguridad avanzada para después; al inicio bastan logs de aplicación.

**Probable SÍ en MVP:**

* `PasswordResetToken`

  * Necesario para reset de contraseña “olvidé mi password”.

---

### 3. PLATFORM_GOVERNANCE (`platformRegistry.prisma`)

Solo tiene:

* `Tenant`

**Este SÍ lo necesitas en MVP.**
No hay nada que postergar aquí.

---

### 4. PUBLICLINKENGINE (`publicLinkEngine.prisma`)

El patrón de `...PublicLink` de tus módulos HYBRID depende de este motor, pero puedes empezar ultra-simple.

**Postergar (NO MVP):**

* `PublicLinkAnalytics`

  * Métricas finas de uso de links (por hora, tasas de fallo, etc.). Puedes loguear a un sistema de logs genérico al inicio.
* `PublicLinkSecurityEvent`

  * Detección avanzada de intrusiones / abuso. De nuevo, se puede hacer luego con observability más madura.

**Opcional (decisión tuya):**

* `PublicLinkTemplate`

  * Si en MVP puedes vivir con expiraciones y políticas “hardcodeadas” en código, también podría postergarse.
  * Si quieres que los productos (Estimate, Invoice, etc.) lean defaults configurables, entonces sí implementas esta desde el inicio.

---

### 5. PLATFORM_AUTHORIZATION (AuthZ) (`identityAuthZ.prisma`)

Solo contiene:

* `Permission`
* `AccessResource`

La idea es que este módulo es el catálogo global que tu RBAC tenant-level consume.

**Recomendación:**

* **NO postergaría ninguna**: son tablas pequeñas, fáciles de poblar y fundamentales para no hardcodear permisos en todo el código.

---

## 2) TENANT GOVERNANCE / SECURITY – Tablas a NO implementar en MVP

### 6. TENANT_ACCESSCONTROL (`accessControlTenant.prisma`)

Para un RBAC simple por tenant (roles + members) en MVP necesitas muy poco.

**Postergar (NO MVP):**

* `AccessPolicy`
* `AccessPolicyCondition`

  * Motor ABAC/ReBAC completo (condiciones, atributos, reglas complejas). Overkill para el MVP.
* `AccessScope`
* `AccessScopeAssignment`

  * Scopes tipo “own/team/department/region”; puedes empezar con permisos “full tenant / read-only” y ya.
* `AccessAuditEvent`

  * Auditoría detallada de cada decisión de autorización; útil en enterprise, no crítica en beta.
* `ServiceAccount`
* `ServiceAccountKey`

  * Cuentas técnicas y sus claves para integraciones/automatizaciones. En MVP puedes correr workers internos sin modelarlos como ServiceAccount en DB.

**Probable SÍ en MVP:**

* `Role`, `RolePermission`, `MemberRole`

  * Lo mínimo para tener RBAC interno por tenant.

---

### 7. TENANT_CONFIG (`tenantConfig.prisma`)

Aquí es donde más pega la decisión de “sin billing/subscription en MVP”.

**Postergar (NO MVP):**

* `TenantSubscription`

  * No hay planes, límites comerciales ni estados de cobro en beta free.
* `TenantUsageRecord`

  * Metering para billing; no lo necesitas todavía.
* `TenantComplianceSetting`

  * Configuración avanzada de cumplimiento (GDPR residency granular, retención, etc.) se puede posponer.
* `TenantIdentityProvider`

  * Depende de SSO (que ya pospusimos).
* `TenantHistoryEvent`

  * Auditoría fina de cambios de configuración del tenant; nice-to-have, pero no bloqueante para beta.

**Seguramente SÍ en MVP:**

* `TenantSettings` (timezone, locale básicos)
* `TenantDomain` (si quieres subdominios por tenant)
* `TenantBranding` (si quieres mínimo branding)
* `TenantModule` (aunque sea estático, para saber qué módulos están “activos”)
* `TenantFeatureFlag` (útil incluso para ir activando features por tenant, pero podrías reemplazarlo por feature flags en código si quieres simplificar aún más).

---

### 8. MEMBERSHIP (`membership.prisma`)

Aquí quieres lo mínimo para que un User global exista como Member interno en un tenant.

**Postergar (NO MVP):**

* `MemberExternalLink`

  * Links a LinkedIn, HRIS, etc.; puro “nice to have”.
* `MemberDocument`

  * Docs HR (contratos, certificaciones, NDAs). No son necesarios para que la app funcione en beta.
* `MemberHistoryEvent`

  * Auditoría fina del lifecycle de Member. Puedes comenzar con logs simples y agregar esto cuando la estructura esté estable.

**Probable SÍ en MVP:**

* `Member` (clave)
* `MemberSettings` (aunque sea mínima)
* `MemberInvitation` (si quieres invitar usuarios al tenant; si no, podrías crearlos de forma directa y postergar esta también).

---

## 3) Resumen rápido para que lo tengas claro

En esta fase MVP (beta, signup gratis, sin billing/subscription, sin SSO, sin integraciones complejas), **NO implementaría**:

* En **GLOBAL**:

  * `Actor`, `UserDevice`, `UserDeviceHistory`, `UserHistoryEvent`, `UserSetting`, `UserApiKey`, `UserInvitation`
  * `IdentityProvider`, `AuthFactor`, `AuthFactorChallenge`, `AccountLockout`, `SSOSession`, `SecurityEvent`
  * `PublicLinkAnalytics`, `PublicLinkSecurityEvent` (y opcionalmente `PublicLinkTemplate` si prefieres hardcodear)

* En **TENANT SECURITY / CONFIG / MEMBERSHIP**:

  * `AccessPolicy`, `AccessPolicyCondition`, `AccessScope`, `AccessScopeAssignment`, `AccessAuditEvent`, `ServiceAccount`, `ServiceAccountKey`
  * `TenantSubscription`, `TenantUsageRecord`, `TenantComplianceSetting`, `TenantIdentityProvider`, `TenantHistoryEvent`
  * `MemberExternalLink`, `MemberDocument`, `MemberHistoryEvent` (y quizás `MemberInvitation` si ni siquiera vas a tener invitaciones internas en la primera iteración)

Con esto te quedas con:

* Auth simple (User + Session + PasswordResetToken),
* Un catálogo básico de permisos,
* Tenants funcionando sin planes de pago,
* RBAC minimalista (Role / RolePermission / MemberRole),
* Membresía simple por tenant,

y dejas todo lo “enterprise / billing / SSO / ABAC avanzado / auditoría fina” para una **Fase 2+** cuando tengas usuarios reales usando el sistema.
