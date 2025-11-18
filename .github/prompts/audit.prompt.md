---
agent: agent
---
# RBAC + RLS Architecture Audit & ERP-Aligned Blueprint
You are acting as a **Senior Enterprise Architect**.
Your task is to audit and analyze several RBAC + RLS reference files that are stored inside:

```
/RBAC&RLSDocumentation/
```

These include (but are not limited to):

* `RBAC.schema.v7.yml`
* `rbac-generator-v7.ts`
* `rbac.ts`
* `permissions.ts`
* `roles.ts`
* `withRLS.ts`
* `withRLS-examples.md`
* `summary.md`
* `cleanup-rbac-data.ts`
* `seed-rbac-v7.ts`

**IMPORTANT:**
These files **belong to a completely different project**.
They MUST be used **strictly as architectural REFERENCE ONLY.**
Do NOT reuse their implementation.
Do NOT assume they belong to the BeeSmart Pro ERP.
Use them only for inspiration and patterns.

---

## ✔ Your real job:

Generate a brand new **Enterprise-level RBAC + RLS Architecture Documentation (.md file)** fully aligned with the **BeeSmart Pro ERP** platform, using **only** the documentation that exists inside our ERP under:

```
/docs/modules/AccessControl/
/docs/modules/CRM_Module/
/docs/modules/estimate/
/docs/modules/expenses/
/docs/modules/Inventory/
/docs/modules/invoice/
/docs/modules/projects/
```

This includes:

### **AccessControl**

```
docs/modules/AccessControl/ACCESS_CONTROL_ARCHITECTURE_DIAGRAM.md
docs/modules/AccessControl/ACCESS_CONTROL_FLOW_v1_0.md
```

### **CRM Module**

```
docs/modules/CRM_Module/CRM_ARCHITECTURE_DIAGRAM.md
docs/modules/CRM_Module/CRM_FLOW.md
```

### **Estimate Module**

```
docs/modules/estimate/ESTIMATE_ARCHITECTURE_DIAGRAM_v8.md
docs/modules/estimate/Estimate_Flow.v8.md
docs/modules/estimate/Estimate_Module_Documentation.md
```

### **Expenses Module**

```
docs/modules/expenses/EXPENSE_ARCHITECTURE_DIAGRAM.md
docs/modules/expenses/EXPENSE_FLOW.md
docs/modules/expenses/EXPENSE_MODULE_SUMMARY.md
```

### **Inventory Module**

```
docs/modules/Inventory/INVENTORY_ARCHITECTURE_DIAGRAM.md
docs/modules/Inventory/INVENTORY_FLOW.md
```

### **Invoice Module**

```
docs/modules/invoice/Invoice_Architecture_Diagram_v8.0.md
docs/modules/invoice/Invoice_Flow.v8.0.md
docs/modules/invoice/Invoice_Module_Updates.md
```

### **Projects Module**

```
docs/modules/projects/PROJECT_ARCHITECTURE_DIAGRAM.md
docs/modules/projects/PROJECT_FLOW.md
docs/modules/projects/Documentation_Progress/*
```

These files form the **true source of business, architectural, and security requirements** for the BeeSmart Pro ERP.

---

## ✔ What you must deliver:

Produce a single markdown document:

### **RBAC_RLS_ENTERPRISE_BLUEPRINT_v1.0.md**

The document must be **Senior Enterprise Architect level**, and must include:

### 1. **Audit Summary**

Audit the reference RBAC/RLS files under `/RBAC&RLSDocumentation/`
Explain which patterns are valuable
Explain which patterns should NOT be reused
Explain the architectural lessons extracted

### 2. **ERP-Aligned RBAC Blueprint**

Define a clean, modern RBAC schema aligned to the BeeSmart Pro ERP modules.
Include:

* Role model (Internal, External, Hybrid)
* Role hierarchy
* AccessScope model
* Permission domains reflecting ERP modules
* Standardized permission taxonomy (create, read, update, delete, approve, reject, convert, send, pay, adjust, etc.)
* Examples of permission usage across modules

### 3. **ERP-Aligned RLS Strategy**

Design a new RLS model aligned with:

* Tenant
* Identity
* Actor
* Membership
* AccessControl
* 1:1:1 Traceability flows (Estimate → Project → Invoice)

RLS must match your ERP’s real multi-tenant database model.

### 4. **Critical Module Examples**

Explain how the RBAC+RLS framework applies to:

* Estimate
* Invoice
* Projects
* Inventory
* Expenses
* CRM
* AccessControl
* Identity & Membership

Each module should include **usage patterns**, e.g.:

* estimate:approve
* estimate:convert-to-project
* invoice:send-client
* invoice:apply-payment
* project:update-status
* inventory:investigate-loss
* expense:approve
* crm:read-contact

### 5. **Best Practices + Enterprise Patterns**

Explain best practices for:

* Permission enforcement
* Multi-tenant data isolation
* Cross-resource access policies
* Role assignment workflows (internal/external)
* Integration with the ERP AccessControl module
* Audit logging strategy
* Governance & compliance

### 6. **Future-facing RBAC Generator Plan**

Outline a conceptual design for:

* `rbac-generator-v1.0.ts`

This should describe:

* How new permissions would be generated from a schema
* How roles, permissions, and mappings would be produced
* How seeds would be created
* How middleware would be derived
* How documentation would be auto-synced

Do NOT generate actual code.
Provide a **clear enterprise blueprint**.

---

## ✔ Critical rules

* Only use `/RBAC&RLSDocumentation/` as **reference**, not as implementation.
* Build the new blueprint based **strictly** on the ERP documentation inside `docs/modules/…`.
* The output must be enterprise-level, clean, modern, and aligned to the BeeSmart Pro architecture.
* Focus on correctness, modularity, maintainability, and multi-tenant security.
* Produce a **single .md file**, not multiple outputs.

---

# End of Prompt
