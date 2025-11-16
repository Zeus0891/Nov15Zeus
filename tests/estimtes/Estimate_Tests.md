## En un ERP arquitecturado como el tuyo, con 600+ tablas y un módulo crítico como “Estimating”, los tests son un componente obligatorio para garantizar:

1. **Integridad referencial** bajo multi-tenant (composite FK).
2. **Correcto comportamiento de onDelete** (Cascade / Restrict / SetNull).
3. **Consistencia del flujo de negocio** (Estimate → Revisions → Sections → LineItems → Taxes/Discounts/Fees → Conversion a Project).
4. **Governance** (auditCorrelationId, createdByActorId, etc.).
5. **Constraints e índices** válidos (`@@unique`, `@@index`).
6. **Enum transitions** permitidas (workflow).
7. **Flujo end-to-end** desde creación de Estimate hasta conversión.

A continuación te doy:

# 1. El set de tests que DEBE existir

# 2. Cómo implementarlos

# 3. Qué espera cada test

# 4. Un generador automatizado para que tu repo siempre valide el módulo

---

# ✅ 1. Tipos de tests necesarios para este módulo

## A. **Schema Integrity Tests** (Prisma-Level)

Verifican:

* Todas las tablas existen
* Los campos están correctos (tipos, nullability)
* Los enums existen y están vinculados
* Los constraints (`@@unique`) están activos
* Los índices existen
* Los foreign keys corresponden al modelo esperado

Esto se hace con:

* `prisma validate`
* introspección del schema vs DB de test
* scripts automatizados en Jest o Vitest

## B. **Migration Tests**

Simulan que el módulo puede:

* migrar en una base vacía
* migrar desde un snapshot previo
* revertir correctamente

Pruebas necesarias:

1. `migration up` en blanco
2. `migration down`
3. `migration up` desde versión previa

## C. **Business Flow Tests** (más importantes)

Simulan el uso real del módulo:

### 1. **Create Estimate**

Debe:

* crear Estimate
* generar globalId
* asignar estimateNumber
* inicializar totales en 0
* respetar default states `status = DRAFT`

### 2. **Add Sections**

* crea secciones
* puedes crear nested sections
* `displayOrder` mantiene el orden
* agregar secciones no rompe `lineItemCount`

### 3. **Add Line Items**

* crea items correctamente
* sección opcional
* precios calculan totales
* `lineTotal = quantity * unitPrice` si no hay override

### 4. **Add Taxes / Discounts / Fees**

* deben amarrarse al estimate
* recalcular snapshot totals en Estimate
* verificar onDelete restricciones:

| Modelo      | onDelete Est. | Comportamiento |
| ----------- | ------------- | -------------- |
| Sections    | Cascade       | Se borran      |
| Line Items  | Cascade       | Se borran      |
| Assumptions | Cascade       | Se borran      |
| Exclusions  | Cascade       | Se borran      |
| Alternates  | Cascade       | Se borran      |
| Taxes       | Cascade       | Se borran      |
| Discounts   | Cascade       | Se borran      |
| Fees        | Cascade       | Se borran      |

### 5. **Publish Revision**

Cuando generas un EstimateRevision:

* revisionNumber autoincrementa
* snapshot fields se rellenan
* `isPublished = true` funciona si eliges una sola publicada

### 6. **Client View Simulation**

* set `sentToClientAt`
* simulate `clientViewedAt`
* simulate `clientApprovedAt`
* verify transitions:

```
PENDING → VIEWED → APPROVED
```

### 7. **Convert to Project**

* se debe crear un Project con el mismo globalId
* sections → phases
* line items → tasks

### 8. **Cascade Delete**

Cuando borras Estimate:

* TODO se elimina automáticamente **excepto**:

  * Tenant (Restrict)
  * CRMAccount (Restrict)
  * Member (SetNull)
  * ApprovalRequest (SetNull)
  * eSignatureEnvelope (SetNull)

---

# ✅ 2. Cómo implementar los tests (stack recomendado)

## Opción A — **Jest + Prisma + Testcontainers (recomendado)**

### 1. Instala dependencias:

```bash
npm install --save-dev jest ts-jest @types/jest testcontainers
```

### 2. Crea un Postgres aislado por test:

```ts
import { PostgreSqlContainer } from "testcontainers";

let container;
let prisma;

beforeAll(async () => {
  container = await new PostgreSqlContainer().start();
  process.env.DATABASE_URL = container.getConnectionString();

  await exec("npx prisma migrate deploy");
  prisma = new PrismaClient();
});

afterAll(async () => {
  await prisma.$disconnect();
  await container.stop();
});
```

---

# 🚀 3. Tests listos para copiar y usar

## Test 1 — Create Estimate

```ts
test("Should create an estimate with correct defaults", async () => {
  const est = await prisma.estimate.create({
    data: {
      id: uuid(),
      tenantId,
      globalId: uuid(),
      estimateNumber: "EST-2025-00001",
      title: "Test Estimate",
      crmAccountId,
      currencyCode: "USD"
    }
  });

  expect(est.status).toBe("DRAFT");
  expect(est.totalAmount.toNumber()).toBe(0);
  expect(est.lineItemCount).toBe(0);
});
```

---

## Test 2 — Add section

```ts
test("Should create a section under estimate", async () => {
  const sec = await prisma.estimateSection.create({
    data: {
      id: uuid(),
      tenantId,
      estimateId,
      sectionNumber: "1.0",
      title: "Foundation",
    }
  });

  expect(sec.displayOrder).toBe(0);
});
```

---

## Test 3 — Add line item

```ts
test("Should create line item and calculate totals", async () => {
  const item = await prisma.estimateLineItem.create({
    data: {
      id: uuid(),
      tenantId,
      estimateId,
      itemName: "Concrete",
      quantity: 10,
      unitPrice: 100
    }
  });

  expect(item.lineTotal.toNumber()).toBe(0); // default until calculation engine
});
```

---

## Test 4 — Cascade delete

```ts
test("Deleting estimate cascades children", async () => {
  await prisma.estimate.delete({
    where: { tenantId_id: { tenantId, id: estimateId } },
  });

  const items = await prisma.estimateLineItem.findMany({ where: { estimateId }});
  const secs = await prisma.estimateSection.findMany({ where: { estimateId }});

  expect(items.length).toBe(0);
  expect(secs.length).toBe(0);
});
```

---

# 🧠 4. End-to-End Test: Full Estimate Flow

Este valida TODO el módulo:

```ts
test("Full estimate flow works", async () => {
  const est = await createEstimate();
  await addSections(est);
  await addLineItems(est);
  await addDiscounts(est);
  await publishRevision(est);
  await simulateClientApproval(est);
  const project = await convertToProject(est);

  expect(project.globalId).toBe(est.globalId);
  expect(project.phases.length).toBeGreaterThan(0);
});
```

---
