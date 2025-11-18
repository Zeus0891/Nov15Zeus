# 📊 RBAC Schema Validation Report v8.2

**Generated**: 2025-11-18T17:34:57.145Z
**Schema Version**: 8.2
**Validation Status**: ✅ PASSED

## 📈 Statistics

| Metric | Count |
|--------|-------|
| Total Domains | 12 |
| Total Roles | 17 |
| Total Permissions | 91 |
| Internal Roles | 12 |
| External Roles | 5 |
| Hierarchy Range | 0-10 |

## 🏗️ Domain Breakdown

| Domain | Permissions |
|--------|-------------|
| estimate | 11 |
| project | 11 |
| invoice | 10 |
| expenses | 9 |
| inventory | 8 |
| documents | 7 |
| payroll | 7 |
| scheduling | 7 |
| accesscontrol | 6 |
| crm | 6 |
| identity | 6 |
| ai | 3 |

## 👥 Role Hierarchy

| Role | Hierarchy | Type | Description |
|------|-----------|------|-------------|
| ADMIN | 0 | INTERNAL | System administrator with full platform access |
| EXECUTIVE | 1 | INTERNAL | C-level executive with strategic oversight |
| PROJECT_MANAGER | 2 | INTERNAL | Project oversight and team management |
| FINANCE_CONTROLLER | 2 | INTERNAL | Financial oversight and approval authority |
| HR_MANAGER | 3 | INTERNAL | Human resources and employee management |
| ESTIMATOR | 4 | INTERNAL | Estimate creation and cost analysis |
| ACCOUNTING | 5 | INTERNAL | Accounting operations and transaction processing |
| SCHEDULER | 5 | INTERNAL | Resource and time scheduling management |
| INVENTORY_MANAGER | 5 | INTERNAL | Materials and inventory management |
| PAYROLL_MANAGER | 6 | INTERNAL | Payroll processing and management |
| CLIENT_OWNER | 6 | EXTERNAL | Client company owner with project oversight |
| CLIENT_MANAGER | 7 | EXTERNAL | Client project management and coordination |
| VENDOR | 7 | EXTERNAL | External vendor or supplier access |
| WORKER | 8 | INTERNAL | Field operations and task execution |
| CLIENT_VIEWER | 8 | EXTERNAL | Client stakeholder with limited access |
| VIEWER | 9 | INTERNAL | Read-only access for internal stakeholders |
| GUEST | 10 | EXTERNAL | Temporary or demo access |