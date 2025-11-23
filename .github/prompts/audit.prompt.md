# MODULES_CLEAN_V10 – Fix List

## 1. System statistics header is out of sync

Your per-module `Tables (N)` totals currently sum to:

* GLOBAL modules (1–5): **5 modules / 24 tables** ✅
* HYBRID modules (6–22): **17 modules / 198 tables**
* TENANT modules (23–64): **42 modules / 412 tables**
* **TOTAL**: 64 modules / **634** tables

But the header still says `189` HYBRID tables, `415` TENANT tables, and `628` total.

### ✅ Action: Update the “System Statistics” block

Replace this block:

```md
### System Statistics

- **GLOBAL modules**: 5
- **HYBRID modules**: 17
- **TENANT modules (internal)**: 42
- **TOTAL**: 64 modules

- **GLOBAL tables**: 24
- **HYBRID tables**: 189
- **TENANT tables**: 415
- **TOTAL TABLES**: 628
```

With this corrected version:

```md
### System Statistics

- **GLOBAL modules**: 5
- **HYBRID modules**: 17
- **TENANT modules (internal)**: 42
- **TOTAL**: 64 modules

- **GLOBAL tables**: 24
- **HYBRID tables**: 198
- **TENANT tables**: 412
- **TOTAL TABLES**: 634
```

> Note: These counts assume “HYBRID modules” = modules **6–22** only. If you later decide to treat `CRMCOMMUNICATION` (26) as conceptually HYBRID, you’ll need to bump HYBRID modules to 18 and adjust table counts again (see next section).

---

## 2. Module 26 – CRMCOMMUNICATION classification (HYBRID vs TENANT)

**Location:** `## 26. MODULE CRMCOMMUNICATION`

Current state:

* `**Scope**: TENANT`
* Rationale section title: `### 🎯 CRITICAL RATIONALE (Why HYBRID)`
* Has a **HYBRID TABLES (2)** section with:

  * `CRMEmail` (with mandatory `globalId`)
  * `CRMEmailPublicLink` (token-based external access)
* Placed under the “🏢 TENANT MODULES” section (not under “HYBRID MODULES”).

So conceptually it behaves **exactly like the other HYBRID modules** (it exposes a public-link surface with `globalId`), but in your taxonomy and stats it’s grouped as TENANT-only.

You have two consistent options:

### Option A – Treat CRMCOMMUNICATION as conceptually HYBRID

If you want it aligned with the other public-link + globalId modules:

1. **Keep** `Scope: TENANT` (RLS is still tenant-based, which matches your pattern).
2. **Re-classify conceptually as HYBRID**:

   * Move module 26 under the **HYBRID MODULES** section in the document, or
   * Add a short note in the module saying it is part of the HYBRID family of modules.
3. **Update system statistics** if you include it in the HYBRID count:

   * HYBRID modules: **18**
   * HYBRID tables: **198 + 11 = 209**
   * TENANT modules: **41**
   * TENANT tables: **412 − 11 = 401**
   * TOTAL tables: **24 + 209 + 401 = 634**

   In that case, update the stats block instead to:

   ```md
   - **GLOBAL modules**: 5
   - **HYBRID modules**: 18
   - **TENANT modules (internal)**: 41
   - **TOTAL**: 64 modules

   - **GLOBAL tables**: 24
   - **HYBRID tables**: 209
   - **TENANT tables**: 401
   - **TOTAL TABLES**: 634
   ```

### Option B – Keep CRMCOMMUNICATION as pure TENANT

If you intentionally want **all CRM communications internal-only** and not a public-link surface:

* Remove or refactor:

  * The `HYBRID TABLES (2)` label.
  * `CRMEmailPublicLink` as a public access pattern (or at least remove the `globalId` / public-link semantics).
* Change the rationale heading to: `### 🎯 CRITICAL RATIONALE (Why TENANT)`
* Ensure the description explicitly states that any external email exposure is handled via `EMAILENGINE` and `SMSCALLS` HYBRID modules, and this module is only for **internal CRM context**.

Right now, the text says “Why HYBRID” and defines `CRMEmailPublicLink`, but the module is counted as TENANT in the stats. Pick either Option A or Option B and make the doc self-consistent.

---

## 3. Stale module-number references in mermaid diagrams

Several diagrams still reference **old module numbers** from previous versions. Here are the exact lines and the corrections.

### 3.1 INVENTORYCORE (Module 47) – Output references

**Location:** `## 47. MODULE INVENTORYCORE` → mermaid block “Proceso de Datos de Inventario (Core)”

Current lines:

```mermaid
        F --> G[InventoryTransactions (45)];
        F --> H[InventoryControl (46)];
```

**Fix:**

```mermaid
        F --> G[InventoryTransactions (48)];
        F --> H[InventoryControl (49)];
```

---

### 3.2 INVENTORYTRANSACTIONS (Module 48) – Input and GL links

**Location:** `## 48. MODULE INVENTORYTRANSACTIONS` → mermaid block “Flujo de Transacciones de Inventario”

Current lines:

```mermaid
        A[InventoryItem (44)] --> B[InventoryTransaction (48)];
...
        F --> G[GLJournal (35)];
```

**Fix:**

```mermaid
        A[InventoryItem (47)] --> B[InventoryTransaction (48)];
...
        F --> G[GLJournal (38)];
```

* `InventoryItem` lives in `INVENTORYCORE` (Module 47).
* `GLJournal` lives in `GENERALLEDGER` (Module 38).

---

### 3.3 INVENTORYCONTROL (Module 49) – Project reference

**Location:** `## 49. MODULE INVENTORYCONTROL` → mermaid block “Flujo de Control y Auditoría de Inventario”

Current line:

```mermaid
        D --> E[Proyectos (Módulo 3)];
```

`PROJECTSCORE` is module **8**, not 3.

**Fix:**

```mermaid
        D --> E[Proyectos (Módulo 8)];
```

---

### 3.4 ROOMMODEL (Module 56) – Links to Estimate and JobCosting

**Location:** `## 56. MODULE ROOMMODEL` → mermaid block “Pipeline RoomModel → Costeo”

Current lines:

```mermaid
        G --> H[EstimateLineItem (1)];
        G --> I[JobCostBudget (47)];
...
        I[JobCostBudget (47)] --> J[JobCosting Module];
```

Correct modules:

* `ESTIMATE` is module **6**.
* `JOBCOSTING` is module **50**.

**Fix:**

```mermaid
        G --> H[EstimateLineItem (6)];
        G --> I[JobCostBudget (50)];
...
        I[JobCostBudget (50)] --> J[JobCosting Module];
```

---

### 3.5 ROOMSCANNER (Module 57) – Link back to RoomModel

**Location:** `## 57. MODULE ROOMSCANNER` → mermaid block “Pipeline de Escaneo a Modelo”

Current line:

```mermaid
        I[RoomModel (53)] --> J[RoomModelHistoryEvent];
```

`ROOMMODEL` is module **56**, not 53.

**Fix:**

```mermaid
        I[RoomModel (56)] --> J[RoomModelHistoryEvent];
```

---

### 3.6 SCHEDULINGENGINE (Module 60) – Reference to SchedulingCore

**Location:** `## 60. MODULE SCHEDULINGENGINE` → mermaid block “Optimización de Programación”

Current line:

```mermaid
        B[ScheduleCore (56)] --> C[ScheduleOptimizationRun];
```

`SCHEDULINGCORE` is module **59**.

**Fix:**

```mermaid
        B[ScheduleCore (59)] --> C[ScheduleOptimizationRun];
```

---

### 3.7 WEATHERIMPACTALERTS (Module 63) – Reference to WeatherIntelligenceCore

**Location:** `## 63. MODULE WEATHERIMPACTALERTS` → mermaid block “Motor de Impacto Climático”

Current line:

```mermaid
        A[WeatherIntelligenceCore (59)] --> B{WeatherImpactRule};
```

`WEATHERINTELLIGENCECORE` is module **62**.

**Fix:**

```mermaid
        A[WeatherIntelligenceCore (62)] --> B{WeatherImpactRule};
```

---

### 3.8 TASKS (Module 61) – Reference to NOTIFICATIONS

**Location:** `## 61. MODULE TASKS` → mermaid block “Flujo de Tareas Generales”

Current line:

```mermaid
        F[Notifications Module (46)] --> G[Internal Channels];
```

`NOTIFICATIONS` is module **52**.

**Fix:**

```mermaid
        F[Notifications Module (52)] --> G[Internal Channels];
```

---

### 3.9 WEATHERIMPACTALERTS (Module 63) – ProjectLocation reference

**Location:** `## 63. MODULE WEATHERIMPACTALERTS` → mermaid block “Motor de Impacto Climático”

Current line:

```mermaid
        C[ProjectLocation (50)] --> D[WeatherProjectForecast];
```

`ProjectLocation` lives in `PROJECTSCORE` (Module **8**), not module 50.

**Fix:**

```mermaid
        C[ProjectLocation (8)] --> D[WeatherProjectForecast];
```

---

## 4. Everything else

* All modules from **1 to 64** exist and are uniquely numbered.
* File names and module names are consistent (`Module: x.prisma` matches headings).
* Every HYBRID-style module (6–22) correctly follows the pattern:

  * Core entity with mandatory `globalId`.
  * `<Entity>PublicLink` mirroring `globalId` and describing external token access.
* Tenant-only modules consistently use `tenantId`-scoped, RLS-safe data and do not expose public-link tables, except for `CRMCOMMUNICATION` (handled in section 2).

Once you:

1. Fix the statistics block,
2. Decide and fix the classification of `CRMCOMMUNICATION` (Option A or B),
3. Update the stale module numbers in the diagrams,
