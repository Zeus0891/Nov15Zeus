## 7. MODULE PROJECTTASKSCHEDULING

### Tables (10)

**Module**: `projectTaskScheduling.prisma`
**Scope**: TENANT
**Description**: Internal project task and schedule management. Manages el WBS, las dependencias y la ruta crítica para la ejecución.

### 🎯 CRITICAL RATIONALE (Why TENANT)

- **Plan Operacional Confidencial:** El cronograma detallado (`ProjectSchedule`), las dependencias (`ProjectTaskDependency`) y la **ruta crítica** (`ProjectCriticalPath`) son planes operativos estratégicos.
- **Base para el Control:** El _baseline_ (`ProjectBaseline`) es esencial para medir la desviación del proyecto y es un dato de control interno sensible.
- **Vínculo Transaccional:** Cada asignación (`ProjectTaskAssignment`) debe estar ligada a un `Member` (23) y a un proyecto (50), manteniendo el aislamiento.

### TENANT TABLES (10): ALL TENANT-SCOPED

- **ProjectTask** 🏆: Project tasks and activities (WBS).
- **ProjectTaskAssignment**: Task assignments to team members.
- **ProjectTaskDependency**: Task dependencies (predecessors, successors).
- **ProjectSchedule**: Project schedules.
- **ProjectScheduleItem**: Schedule items and milestones.
- **ProjectCriticalPath**: Critical path analysis.
- **ProjectBaseline**: Schedule baselines for variance analysis.
- **ProjectChecklistItem**: Task checklists.
- **ProjectTaskComment**: Comments on tasks.
- **ProjectTaskAttachment**: Task-level attachments.

### Process Flow: PROJECTTASKSCHEDULING (Planificación Operativa)

```mermaid
graph TD
    subgraph Planning[Estructura y Tareas (TENANT)]
        A[Project (50)] --> B[ProjectSchedule];
        B --> C[ProjectTask & ChecklistItem];
    end

    subgraph Logic[Asignación y Ruta Crítica (TENANT)]
        C --> D[ProjectTaskDependency];
        C --> E[ProjectTaskAssignment];
        D --> F[ProjectCriticalPath];
    end

    subgraph Control[Control]
        F --> G[ProjectBaseline];
        C --> H[TimeAttendance (41)];
    end

    A & B & C & D & E & F & G & H -- tenantId (RLS) --> I[Aislamiento Completo];

    style Planning fill:#dff,stroke:#333;
    style Logic fill:#ccf,stroke:#333;
    style Control fill:#f9f,stroke:#333;
```

---

## 8. MODULE PROJECTRISK

### Tables (10)

**Module**: `projectRisk.prisma`
**Scope**: TENANT
**Description**: Internal project risk and issue management. Also manages the critical field data capture through Daily Logs (field reports).

### 🎯 CRITICAL RATIONALE (Why TENANT)

- **Riesgo y Responsabilidad:** Los registros de riesgos (`ProjectRisk`) y las decisiones de mitigación son información interna que afecta la responsabilidad y la estrategia del proyecto.
- **Registro de Campo como Fuente de Verdad:** El **`ProjectDailyLog`** es una tabla de datos de origen crítica. Contiene los detalles exactos de mano de obra, equipo y materiales utilizados, lo cual es la base para el costeo y los registros de tiempo.
- **Integración Financiera:** Los datos de labor y materiales de los _Daily Logs_ alimentan directamente los módulos **`TIMEATTENDANCE` (41)** y **`JOBCOSTING` (47)**, confirmando la necesidad de aislamiento RLS.

### TENANT TABLES (10): ALL TENANT-SCOPED

- **ProjectRisk** 🏆: Project risks and mitigation.
- **ProjectIssue**: Project issues and problems.
- **ProjectDecision**: Project decisions and rationale.
- **ProjectDailyLog**: Daily log entries (field reports).
- **ProjectDailyLogLabor**: Labor tracking in daily logs.
- **ProjectDailyLogEquipment**: Equipment usage in daily logs.
- **ProjectDailyLogMaterial**: Material usage in daily logs.
- **ProjectDailyLogPhoto**: Photos in daily logs.
- **ProjectProgress**: Progress tracking and reporting.
- **ProjectNote**: General project notes.

### Process Flow: PROJECTRISK (Riesgos y Reporte Diario)

```mermaid
graph TD
    subgraph Management[Riesgos y Decisiones (TENANT)]
        A[Project (50)] --> B[ProjectRisk & Issue];
        B --> C[ProjectDecision];
    end

    subgraph FieldData[Reporte Diario (TENANT)]
        A --> D[ProjectDailyLog];
        D --> E[DailyLogLabor / Equipment / Material / Photo];
    end

    subgraph Output[Flujo de Datos]
        E --> F[TimeAttendance (41)];
        E --> G[JobCosting (47)];
    end

    A & B & C & D & E & F & G -- tenantId (RLS) --> H[Datos de Riesgo y Campo Segregados];

    style Management fill:#dff,stroke:#333;
    style FieldData fill:#ccf,stroke:#333;
    style Output fill:#f9f,stroke:#333;
```
