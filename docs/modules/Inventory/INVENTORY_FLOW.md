# 📦 Inventory Module Suite - Complete Flow Documentation

## 📋 Executive Summary

**Module Suite**: `inventoryCore.prisma`, `inventoryTransactions.prisma`, `inventoryControl.prisma`  
**Pattern**: Mixed (BH for transactions, Tenant for most, Pattern B for InventoryItem)  
**Purpose**: Complete inventory management with zero-loss prevention  
**Total Models**: 30 models (10 + 10 + 10)  
**Integration**: Estimate, Invoice, Project, CRM, Purchase Order  
**Version**: 1.0  
**Last Updated**: November 17, 2025

---

## 🎯 Strategic Purpose

The **INVENTORY module suite** is the **material management foundation** in the enterprise ERP for construction and field services. It enables complete control over materials, tools, and equipment from procurement through project delivery with industry-leading **zero-loss prevention**.

### Key Business Objectives

1. **Zero-Loss Prevention**: Track and prevent every dollar of inventory shrinkage
2. **Multi-Location Control**: Manage inventory across warehouses, jobsites, and vehicles
3. **Project Integration**: Seamlessly reserve and issue materials to active projects
4. **Cost Accuracy**: Maintain precise costing with FIFO/LIFO/Average methods
5. **Automated Reordering**: Never run out of critical materials
6. **Audit Compliance**: Enterprise-grade audit trails and formal audit support

---

## 🏗️ Module Architecture (30 Models)

### inventoryCore.prisma (10 models)

**Purpose**: Master data foundation for inventory management

| Model | Pattern | Purpose |
|-------|---------|---------|
| **InventoryItem** | Tenant + Pattern B | Item master (full actor tracking) |
| **InventoryCategory** | Tenant + Pattern A | Hierarchical categorization |
| **InventoryLocation** | Tenant + Pattern A | Warehouses, jobsites, vehicles |
| **InventoryBin** | Tenant + Pattern A | Specific storage locations |
| **InventoryUnitOfMeasure** | Tenant + Pattern A | UOM conversion matrix |
| **InventoryStock** | Tenant + Pattern A | Stock levels by location/bin |
| **InventorySupplier** | Tenant + Pattern A | Vendor master data |
| **InventoryItemVendor** | Tenant + Pattern A | Item-vendor pricing (M:N) |
| **InventoryAttachment** | Tenant + Pattern A | Item photos, specs, SDS |
| **InventoryHistoryEvent** | Tenant + Audit | Complete audit trail |

### inventoryTransactions.prisma (10 models)

**Purpose**: All inventory movement transactions

| Model | Pattern | Purpose |
|-------|---------|---------|
| **InventoryTransaction** | BH + Pattern A | Transaction header with globalId |
| **InventoryTransactionLine** | Tenant + Pattern A | Transaction line items |
| **InventoryAdjustment** | BH + Pattern A | Stock adjustments/corrections |
| **InventoryTransfer** | BH + Pattern A | Location-to-location transfers |
| **InventoryTransferLine** | Tenant + Pattern A | Transfer line items |
| **InventoryReturn** | BH + Pattern A | Returns from projects/suppliers |
| **InventoryReturnLine** | Tenant + Pattern A | Return line items |
| **InventoryCount** | BH + Pattern A | Physical count cycles |
| **InventoryCountLine** | Tenant + Pattern A | Count line items |
| **InventoryTransactionHistory** | Tenant + Audit | Transaction audit trail |

### inventoryControl.prisma (10 models)

**Purpose**: Loss prevention, reorder automation, audit compliance

| Model | Pattern | Purpose |
|-------|---------|---------|
| **InventoryLossEvent** | BH + Pattern A | Zero-loss prevention tracking |
| **InventoryLossCause** | Tenant + Pattern A | Loss categorization |
| **InventoryLossInvestigation** | Tenant + Pattern A | Investigation records |
| **InventoryAudit** | BH + Pattern A | Formal audit management |
| **InventoryAuditLine** | Tenant + Pattern A | Audit findings |
| **InventoryReservation** | Tenant + Pattern A | Project material reservations |
| **InventoryCommitment** | Tenant + Pattern A | Hard stock commitments |
| **InventoryReorderPoint** | Tenant + Pattern A | Automated reorder rules |
| **InventorySafetyStock** | Tenant + Pattern A | Safety stock levels |
| **InventoryControlHistory** | Tenant + Audit | Control audit trail |

---

## 🔄 Core Workflow 1: Inventory Item Lifecycle

### Overview
Complete lifecycle from item creation through active use to discontinuation.

---

### Stage 1: Item Creation & Setup

**Trigger**: Need to add new material, tool, or equipment to inventory

**Actions**:
1. Create **InventoryItem**:
   ```prisma
   InventoryItem {
     itemNumber: "ITEM-2025-00001" (auto-generated)
     itemName: "2x4x8 Lumber - SPF"
     itemType: MATERIAL
     categoryId: lumberCategory.id
     trackingMethod: LOT_BATCH
     baseUnitOfMeasureId: eachUOM.id
     costingMethod: FIFO
     status: PENDING
   }
   ```

2. Set physical attributes:
   ```prisma
   weight: 12.5
   weightUnit: "LB"
   dimensions: {length: 96, width: 3.5, height: 1.5}
   volume: 504 (cubic inches)
   ```

3. Upload documentation:
   ```prisma
   InventoryAttachment {
     itemId: item.id
     attachmentType: PHOTO
     fileName: "2x4-lumber.jpg"
     isPrimary: true
   }
   
   InventoryAttachment {
     itemId: item.id
     attachmentType: SPEC_SHEET
     fileName: "lumber-specs.pdf"
   }
   ```

**Status**: `InventoryItem.status = PENDING`

---

### Stage 2: Costing & Pricing Setup

**Trigger**: Item created, now set financial parameters

**Actions**:
1. Set costing:
   ```prisma
   InventoryItem {
     costingMethod: FIFO
     standardCost: 5.25 (target cost)
     averageCost: 0 (will calculate on first purchase)
     lastPurchaseCost: 0
     currencyCode: "USD"
   }
   ```

2. Set pricing with markup:
   ```prisma
   InventoryItem {
     sellingPrice: 8.50
     markupPercentage: 61.90% // (8.50 - 5.25) / 5.25
     listPrice: 9.00 (MSRP)
     priceUnit: "EA"
   }
   ```

3. Configure supplier:
   ```prisma
   // Preferred supplier
   InventoryItem {
     preferredSupplierId: acmeLumber.id
     leadTimeDays: 3
     minimumOrderQuantity: 50
   }
   
   // Add vendor pricing
   InventoryItemVendor {
     itemId: item.id
     supplierId: acmeLumber.id
     unitPrice: 5.00
     minimumOrderQuantity: 50
     priceBreaks: [
       {qty: 100, price: 4.85},
       {qty: 500, price: 4.70}
     ]
     isPreferredVendor: true
   }
   ```

---

### Stage 3: Stock Control Setup

**Trigger**: Configure reorder automation and safety stock

**Actions**:
1. Set reorder points (per location):
   ```prisma
   // Main warehouse
   InventoryReorderPoint {
     itemId: item.id
     locationId: mainWarehouse.id
     reorderPoint: 100 (trigger when ≤ 100)
     reorderQuantity: 500 (order 500 units)
     minimumQuantity: 50 (never go below)
     maximumQuantity: 1000 (max storage)
     leadTimeDays: 3
     averageDailyUsage: 25 (calculated)
     isActive: true
   }
   ```

2. Set safety stock:
   ```prisma
   InventorySafetyStock {
     itemId: item.id
     locationId: mainWarehouse.id
     safetyStockQuantity: 75
     calculationMethod: DAYS_SUPPLY
     daysOfSupply: 3 // 3 days buffer
     serviceLevel: 99% // 99% in-stock target
     reason: "High-demand item, prevent stockouts"
   }
   ```

---

### Stage 4: Item Activation

**Trigger**: Setup complete, ready for use

**Actions**:
1. Activate item:
   ```prisma
   InventoryItem.status = PENDING → ACTIVE
   InventoryItem.activeFromDate = today
   ```

2. Create history event:
   ```prisma
   InventoryHistoryEvent {
     entityType: ITEM
     entityId: item.id
     changeType: STATUS_CHANGE
     oldValue: "PENDING"
     newValue: "ACTIVE"
   }
   ```

3. Item now available for:
   - Purchase orders
   - Estimates
   - Project reservations
   - Transactions

**Status**: `InventoryItem.status = ACTIVE`

---

### Stage 5: Initial Stock (if applicable)

**Trigger**: Need to record opening balance

**Actions**:
1. Create opening balance adjustment:
   ```prisma
   InventoryAdjustment {
     adjustmentNumber: "ADJ-2025-00001"
     adjustmentType: OPENING_BALANCE
     adjustmentDate: today
     locationId: mainWarehouse.id
     status: APPROVED
   }
   ```

2. Add adjustment line:
   ```prisma
   // (This would be part of the transaction, details TBD based on schema)
   InventoryTransactionLine {
     itemId: item.id
     quantity: 250
     unitCost: 5.25
     totalCost: 1312.50
   }
   ```

3. Post adjustment → Creates **InventoryTransaction**:
   ```prisma
   InventoryTransaction {
     transactionType: ADJUSTMENT
     status: POSTED
     postedAt: now()
   }
   ```

4. Update **InventoryStock**:
   ```prisma
   InventoryStock {
     itemId: item.id
     locationId: mainWarehouse.id
     quantityOnHand: 250
     quantityAvailable: 250
     averageUnitCost: 5.25
     totalValue: 1312.50
   }
   ```

5. Update **InventoryItem** totals:
   ```prisma
   InventoryItem.totalQuantityOnHand = 250
   InventoryItem.lastStockCountDate = today
   ```

---

## 🔄 Core Workflow 2: Purchase & Receipt

### Overview
Complete purchase order receipt workflow with cost updates.

---

### Stage 1: Create Purchase Order (Future Module)

**Trigger**: Stock level hits reorder point

**Actions**:
1. System detects low stock:
   ```typescript
   if (inventoryStock.quantityOnHand <= reorderPoint.reorderPoint) {
     // Trigger reorder
     createPurchaseOrder({
       supplierId: item.preferredSupplierId,
       itemId: item.id,
       quantity: reorderPoint.reorderQuantity
     });
   }
   ```

2. Create **PurchaseOrder**:
   ```prisma
   PurchaseOrder {
     poNumber: "PO-2025-00456"
     supplierId: acmeLumber.id
     orderDate: today
     expectedDeliveryDate: today + 3 days
     status: APPROVED
   }
   
   PurchaseOrderLine {
     itemId: item.id
     quantity: 500
     unitPrice: 4.85 (from price break)
     totalPrice: 2425.00
   }
   ```

3. Update **InventoryStock**:
   ```prisma
   InventoryStock.quantityOnOrder += 500
   ```

4. Update **InventoryItem**:
   ```prisma
   InventoryItem.totalQuantityOnOrder += 500
   ```

---

### Stage 2: Receive Goods

**Trigger**: Supplier delivers goods to warehouse

**Actions**:
1. Receiving clerk creates receipt:
   ```prisma
   InventoryTransaction {
     transactionNumber: "TXN-2025-01234"
     transactionType: RECEIPT
     transactionDate: today
     referenceNumber: "PO-2025-00456"
     sourceType: PURCHASE_ORDER
     sourceId: po.id
     supplierId: acmeLumber.id
     toLocationId: mainWarehouse.id
     status: DRAFT
   }
   ```

2. Add received items:
   ```prisma
   InventoryTransactionLine {
     transactionId: txn.id
     itemId: item.id
     quantity: 500 (full order received)
     unitCost: 4.85
     totalCost: 2425.00
     locationId: mainWarehouse.id
     binId: lumberRack05.id
     lotNumber: "LOT-2025-Q4-ABC" (from supplier)
   }
   ```

3. Post transaction:
   ```prisma
   InventoryTransaction.status = DRAFT → POSTED
   InventoryTransaction.postedAt = now()
   ```

4. Update **InventoryStock**:
   ```typescript
   // FIFO costing
   inventoryStock.quantityOnHand += 500
   inventoryStock.quantityOnOrder -= 500
   inventoryStock.quantityAvailable += 500
   
   // Update average cost
   const oldTotalValue = inventoryStock.quantityOnHand × inventoryStock.averageUnitCost
   const newPurchaseValue = 500 × 4.85
   inventoryStock.averageUnitCost = (oldTotalValue + newPurchaseValue) / (inventoryStock.quantityOnHand + 500)
   inventoryStock.totalValue = inventoryStock.quantityOnHand × inventoryStock.averageUnitCost
   inventoryStock.lastReceivedDate = today
   ```

5. Update **InventoryItem**:
   ```prisma
   InventoryItem.totalQuantityOnHand += 500
   InventoryItem.totalQuantityOnOrder -= 500
   InventoryItem.lastPurchaseCost = 4.85
   InventoryItem.averageCost = recalculate across all locations
   ```

**Result**: Stock received, costs updated, available for projects

---

## 🔄 Core Workflow 3: Project Material Management

### Overview
Complete flow from estimate to project reservation to material issue.

---

### Stage 1: Material in Estimate

**Trigger**: Sales team creates estimate with materials

**Actions**:
1. Add material line to estimate:
   ```prisma
   EstimateLineItem {
     estimateId: estimate.id
     lineType: MATERIAL
     inventoryItemId: item.id // Link to inventory
     description: "2x4x8 Lumber - SPF"
     quantity: 200
     unitOfMeasureId: eachUOM.id
     unitCost: 5.25 (from InventoryItem.standardCost)
     unitPrice: 8.50 (from InventoryItem.sellingPrice)
     totalCost: 1050.00
     totalPrice: 1700.00
   }
   ```

2. Check availability:
   ```typescript
   const available = inventoryItem.totalQuantityAvailable
   if (available < estimateLineItem.quantity) {
     // Warn: "Only 180 units available, 200 requested"
   }
   ```

**Status**: Estimate in progress

---

### Stage 2: Estimate Approved → Reserve Materials

**Trigger**: Customer approves estimate, project auto-created

**Actions**:
1. **Estimate** approved:
   ```prisma
   Estimate.status = APPROVED
   Estimate.approvalStatus = APPROVED
   ```

2. **Project** auto-created (1:1:1 linkage):
   ```prisma
   Project {
     sourceEstimateId: estimate.id
     globalId: estimate.globalId // SAME globalId
     projectNumber: estimate.estimateNumber // SAME number
     crmAccountId: estimate.crmAccountId
     status: PLANNING
   }
   ```

3. Create **InventoryReservation** for each material:
   ```prisma
   InventoryReservation {
     itemId: estimateLineItem.inventoryItemId
     locationId: mainWarehouse.id
     projectId: project.id
     estimateId: estimate.id
     quantityReserved: 200
     requiredByDate: project.plannedStartDate
     reservationDate: today
     status: ACTIVE
   }
   ```

4. Update **InventoryStock**:
   ```prisma
   InventoryStock.quantityReserved += 200
   InventoryStock.quantityAvailable -= 200 // (onHand - reserved)
   ```

5. Update **InventoryItem**:
   ```prisma
   InventoryItem.totalQuantityReserved += 200
   InventoryItem.totalQuantityAvailable -= 200
   ```

**Result**: Materials reserved, not available for other projects

---

### Stage 3: Issue Materials to Project

**Trigger**: Project starts, materials needed at jobsite

**Actions**:
1. Warehouse worker creates material issue:
   ```prisma
   InventoryTransaction {
     transactionNumber: "TXN-2025-02345"
     transactionType: ISSUE
     transactionDate: today
     sourceType: PROJECT
     sourceId: project.id
     projectId: project.id
     fromLocationId: mainWarehouse.id
     toLocationId: jobsite123.id
     status: DRAFT
   }
   ```

2. Add issue lines:
   ```prisma
   InventoryTransactionLine {
     transactionId: txn.id
     itemId: item.id
     quantity: 200
     unitCost: 5.25 (from current stock - FIFO)
     totalCost: 1050.00
     locationId: mainWarehouse.id
     lotNumber: "LOT-2025-Q4-ABC" (from specific lot)
   }
   ```

3. Post transaction:
   ```prisma
   InventoryTransaction.status = DRAFT → POSTED
   InventoryTransaction.postedAt = now()
   ```

4. Update **InventoryStock** (FROM location):
   ```prisma
   // Main warehouse
   InventoryStock {
     locationId: mainWarehouse.id
     quantityOnHand -= 200
     quantityReserved -= 200
     lastIssuedDate = today
   }
   ```

5. Create/Update **InventoryStock** (TO location - jobsite):
   ```prisma
   // Jobsite 123
   InventoryStock {
     itemId: item.id
     locationId: jobsite123.id
     quantityOnHand += 200
     quantityAvailable += 200
   }
   ```

6. Update **InventoryReservation**:
   ```prisma
   InventoryReservation {
     quantityFulfilled += 200
     quantityRemaining = 0
     status: ACTIVE → FULFILLED
     fulfilledAt = today
   }
   ```

7. Link to **ProjectTask** (material usage):
   ```prisma
   ProjectTask {
     taskName: "Frame walls"
     materialInventoryItemId: item.id
     materialQuantityPlanned: 200
     materialQuantityUsed: 200
     materialCost: 1050.00
   }
   ```

8. Update **InventoryItem** totals:
   ```prisma
   InventoryItem.totalQuantityOnHand = unchanged (moved, not consumed)
   InventoryItem.totalQuantityReserved -= 200
   InventoryItem.totalQuantityAvailable = unchanged
   ```

**Result**: Materials at jobsite, tracked to project task, cost captured

---

### Stage 4: Bill Materials on Invoice

**Trigger**: Invoice created for project

**Actions**:
1. Create **Invoice** (linked to Project):
   ```prisma
   Invoice {
     relatedProjectId: project.id
     globalId: project.globalId // SAME globalId (1:1:1)
     invoiceNumber: project.projectNumber // SAME number
     crmAccountId: project.crmAccountId
   }
   ```

2. Add **InvoiceLineItem** for materials:
   ```prisma
   InvoiceLineItem {
     invoiceId: invoice.id
     lineType: MATERIAL
     inventoryItemId: item.id
     description: "2x4x8 Lumber - SPF"
     quantity: 200
     unitPrice: 8.50 (from InventoryItem.sellingPrice)
     totalPrice: 1700.00
     relatedProjectTaskId: projectTask.id
     relatedInventoryTransactionId: issueTxn.id
   }
   ```

3. Revenue recognition:
   ```
   Cost: $1050.00 (from InventoryTransaction)
   Revenue: $1700.00 (from Invoice)
   Gross Profit: $650.00 (38.2% margin)
   ```

---

## 🔄 Core Workflow 4: Physical Count Cycles

### Overview
Maintain inventory accuracy through regular physical counts.

---

### Scenario 1: Full Physical Count (Annual)

**Trigger**: End of year, full warehouse count required

**Actions**:
1. Schedule **InventoryCount**:
   ```prisma
   InventoryCount {
     countNumber: "CNT-2025-00001"
     countType: FULL
     countDate: 2025-12-31
     scheduledDate: 2025-12-30
     locationId: mainWarehouse.id
     categoryId: null // All categories
     status: SCHEDULED
     assignedToMemberId: warehouseManager.id
   }
   ```

2. System generates **InventoryCountLine** for all items at location:
   ```typescript
   // Get all items in stock at this location
   const stockRecords = await prisma.inventoryStock.findMany({
     where: {
       tenantId,
       locationId: mainWarehouse.id,
       quantityOnHand: { gt: 0 }
     }
   });
   
   // Create count line for each
   for (const stock of stockRecords) {
     await prisma.inventoryCountLine.create({
       data: {
         countId: count.id,
         itemId: stock.itemId,
         locationId: stock.locationId,
         binId: stock.binId,
         systemQuantity: stock.quantityOnHand,
         countedQuantity: null, // To be filled by counter
         unitCost: stock.averageUnitCost
       }
     });
   }
   ```

3. Count day:
   ```prisma
   InventoryCount.status = SCHEDULED → IN_PROGRESS
   InventoryCount.startedAt = now()
   ```

4. Counters scan/count items:
   ```prisma
   // For each item counted
   InventoryCountLine {
     countedQuantity: 245 (actual count)
     varianceQuantity: 245 - 250 = -5 (shortage)
     variancePercentage: -2%
     varianceValue: -5 × 5.25 = -26.25
     varianceReason: "Unknown shrinkage"
     countedByMemberId: counter1.id
     countedAt: now()
   }
   ```

5. Count completed:
   ```prisma
   InventoryCount.status = IN_PROGRESS → COMPLETED
   InventoryCount.completedAt = now()
   InventoryCount.itemsCountedTotal = 1250
   InventoryCount.itemsWithVariance = 87
   InventoryCount.totalVarianceValue = -1245.50
   InventoryCount.accuracyPercentage = 93.0%
   ```

6. Manager reviews and approves:
   ```prisma
   InventoryCount.status = COMPLETED → APPROVED
   InventoryCount.approvedAt = now()
   InventoryCount.approvedByMemberId = warehouseManager.id
   ```

7. System auto-creates **InventoryAdjustment**:
   ```prisma
   InventoryAdjustment {
     adjustmentNumber: "ADJ-2025-00567"
     adjustmentType: PHYSICAL_COUNT
     adjustmentDate: today
     locationId: mainWarehouse.id
     relatedCountId: count.id
     status: APPROVED
     totalAdjustmentValue: -1245.50
     reason: "Physical count variance"
   }
   ```

8. Post adjustment → Updates **InventoryStock**:
   ```typescript
   for (const line of countLines with variance) {
     const stock = await prisma.inventoryStock.findUnique({
       where: { itemId_locationId: { itemId: line.itemId, locationId: line.locationId } }
     });
     
     stock.quantityOnHand = line.countedQuantity
     stock.quantityAvailable = stock.quantityOnHand - stock.quantityReserved
     stock.lastCountedDate = today
   }
   ```

**Result**: Inventory adjusted to match physical count, variances documented

---

### Scenario 2: Cycle Count (Ongoing)

**Trigger**: Weekly cycle count of high-value items (ABC analysis)

**Actions**:
1. System identifies items for cycle count:
   ```typescript
   // A-items: High value, count weekly
   // B-items: Medium value, count monthly
   // C-items: Low value, count quarterly
   
   const aItems = await prisma.inventoryItem.findMany({
     where: {
       tenantId,
       totalValue: { gte: 10000 }, // High value
       lastStockCountDate: { lt: sevenDaysAgo }
     },
     take: 50 // Count 50 A-items this week
   });
   ```

2. Create **InventoryCount**:
   ```prisma
   InventoryCount {
     countNumber: "CNT-2025-00078"
     countType: CYCLE
     countDate: today
     locationId: mainWarehouse.id
     status: IN_PROGRESS
     description: "Weekly A-item cycle count"
   }
   ```

3. Generate count lines only for selected items

4. Count, review, approve, adjust (same as full count)

**Benefit**: Continuous accuracy monitoring without full shutdown

---

## 🔄 Core Workflow 5: Zero-Loss Prevention

### Overview
Critical innovation - track and prevent every dollar of inventory loss.

---

### Stage 1: Loss Discovered

**Trigger**: Loss discovered during count, inspection, or routine operations

**Actions**:
1. Report **InventoryLossEvent**:
   ```prisma
   InventoryLossEvent {
     lossNumber: "LOSS-2025-00012"
     lossType: THEFT
     lossDate: yesterday
     discoveredDate: today
     locationId: jobsite456.id
     binId: null
     status: REPORTED
     severity: HIGH
     reportedByMemberId: siteSuper.id
     description: "5 cordless drills missing from jobsite tool storage"
   }
   ```

2. Add loss items (would be separate lines model if designed):
   ```
   Item: Cordless Drill Model XYZ
   Quantity Lost: 5
   Unit Cost: $150.00
   Total Loss Value: $750.00
   Serial Numbers: [SN001, SN002, SN003, SN004, SN005]
   ```

3. Calculate financial impact:
   ```prisma
   InventoryLossEvent.totalLossValue = 750.00
   InventoryLossEvent.recoveryAmount = 0
   InventoryLossEvent.netLoss = 750.00
   ```

4. Link to **InventoryLossCause**:
   ```prisma
   InventoryLossEvent.causedById = theftExternal.id
   
   InventoryLossCause {
     causeName: "Theft - External"
     causeCategory: EXTERNAL
     totalIncidents++
     totalLossValue += 750.00
   }
   ```

**Status**: `InventoryLossEvent.status = REPORTED`

---

### Stage 2: Investigation

**Trigger**: Loss event requires investigation

**Actions**:
1. Assign investigator:
   ```prisma
   InventoryLossEvent.status = REPORTED → INVESTIGATING
   InventoryLossEvent.investigatedByMemberId = securityManager.id
   ```

2. Create **InventoryLossInvestigation**:
   ```prisma
   InventoryLossInvestigation {
     lossEventId: loss.id
     investigationDate: today
     investigatorMemberId: securityManager.id
     status: IN_PROGRESS
   }
   ```

3. Gather evidence:
   ```prisma
   InventoryLossInvestigation {
     findings: `
       - Security camera footage reviewed
       - No forced entry detected
       - Last seen on 2025-11-15 at 16:30
       - Storage container left unlocked overnight
       - 3 crew members had access
     `
     rootCause: "Inadequate security procedures"
     recommendations: `
       - Install additional locks
       - Implement sign-out sheet for tools
       - Add motion-sensing lights
       - Daily tool inventory count
     `
     witnessStatements: "[Statements attached]"
     securityFootage: "cameras_2025-11-15_evening.mp4"
   }
   ```

4. Complete investigation:
   ```prisma
   InventoryLossInvestigation.status = IN_PROGRESS → COMPLETED
   InventoryLossInvestigation.completedAt = today
   ```

5. Attempt recovery:
   ```prisma
   InventoryLossInvestigation {
     recoveryAttempted: true
     recoveryAmount: 0
     insuranceClaim: true
   }
   ```

6. Update loss event:
   ```prisma
   InventoryLossEvent.status = INVESTIGATING → RESOLVED
   InventoryLossEvent.preventiveMeasures = investigation.recommendations
   ```

**Result**: Loss investigated, prevention measures documented, insurance claim filed

---

### Stage 3: Implement Prevention

**Actions**:
1. Update location procedures:
   ```prisma
   InventoryLocation {
     locationId: jobsite456.id
     securityProcedures: `
       - All tools must be signed out/in
       - Daily count required
       - Storage locked at all times
       - Motion lights active
     `
     isRestrictedAccess: true
   }
   ```

2. Create **CRMActivity** for prevention implementation:
   ```prisma
   CRMActivity {
     activityType: TASK
     subject: "Install jobsite security upgrades"
     priority: HIGH
     dueDate: next_week
     assignedToMemberId: opsManager.id
   }
   ```

3. Track loss trends:
   ```typescript
   // Monthly loss analysis
   const lossStats = await prisma.inventoryLossEvent.groupBy({
     by: ['lossType', 'locationId'],
     where: { lossDate: { gte: last_month } },
     _sum: { totalLossValue: true },
     _count: true
   });
   
   // Identify problem areas
   if (lossStats.jobsite456.totalLoss > threshold) {
     // Flag for management review
     createAlert("High loss at Jobsite 456");
   }
   ```

**Result**: Loss prevented through documented procedures, ongoing monitoring

---

### Stage 4: Adjust Inventory

**Actions**:
1. Create **InventoryAdjustment** for loss:
   ```prisma
   InventoryAdjustment {
     adjustmentNumber: "ADJ-2025-00789"
     adjustmentType: DAMAGE // or OBSOLETE, based on loss type
     adjustmentDate: today
     locationId: jobsite456.id
     reason: "Loss due to theft - LOSS-2025-00012"
     totalAdjustmentValue: -750.00
     status: APPROVED
   }
   ```

2. Post adjustment:
   ```prisma
   InventoryTransaction {
     transactionType: ADJUSTMENT
     sourceType: LOSS_EVENT
     sourceId: loss.id
     status: POSTED
   }
   ```

3. Update **InventoryStock**:
   ```prisma
   InventoryStock {
     locationId: jobsite456.id
     itemId: cordlessDrill.id
     quantityOnHand -= 5
     quantityAvailable -= 5
   }
   ```

4. Update **InventoryItem**:
   ```prisma
   InventoryItem.totalQuantityOnHand -= 5
   ```

**Result**: Inventory adjusted to reflect loss, financial impact recorded

---

## 🔄 Core Workflow 6: Transfer Between Locations

### Overview
Move inventory from one location to another (warehouse to jobsite, truck to jobsite, etc.)

---

### Workflow: Warehouse to Jobsite Transfer

**Trigger**: Project manager needs materials at jobsite

**Actions**:
1. Create **InventoryTransfer**:
   ```prisma
   InventoryTransfer {
     transferNumber: "TRF-2025-00123"
     transferDate: today
     requestedDeliveryDate: tomorrow
     fromLocationId: mainWarehouse.id
     toLocationId: jobsite789.id
     status: DRAFT
     requestedByMemberId: projectManager.id
   }
   ```

2. Add **InventoryTransferLine**:
   ```prisma
   InventoryTransferLine {
     transferId: transfer.id
     itemId: concreteMix80lb.id
     quantityRequested: 100
     quantityShipped: 0
     quantityReceived: 0
     unitOfMeasureId: bagUOM.id
   }
   ```

3. Warehouse prepares shipment:
   ```prisma
   InventoryTransfer.status = DRAFT → IN_TRANSIT
   InventoryTransfer.shippedAt = now()
   InventoryTransfer.shippedByMemberId: warehouseClerk.id
   InventoryTransfer.carrierName = "Company Truck #3"
   InventoryTransfer.trackingNumber = "TRUCK3-2025-1117"
   
   InventoryTransferLine.quantityShipped = 100
   ```

4. Jobsite receives shipment:
   ```prisma
   InventoryTransfer.status = IN_TRANSIT → RECEIVED
   InventoryTransfer.receivedAt = now()
   InventoryTransfer.receivedByMemberId = siteSuper.id
   
   InventoryTransferLine.quantityReceived = 100
   ```

5. System creates 2 **InventoryTransaction** records:
   ```prisma
   // Transaction 1: Issue from warehouse
   InventoryTransaction {
     transactionType: ISSUE
     sourceType: TRANSFER
     sourceId: transfer.id
     fromLocationId: mainWarehouse.id
     status: POSTED
   }
   
   // Transaction 2: Receipt at jobsite
   InventoryTransaction {
     transactionType: RECEIPT
     sourceType: TRANSFER
     sourceId: transfer.id
     toLocationId: jobsite789.id
     status: POSTED
   }
   ```

6. Update **InventoryStock**:
   ```typescript
   // Decrease warehouse stock
   InventoryStock {
     itemId: concreteMix80lb.id
     locationId: mainWarehouse.id
     quantityOnHand -= 100
     quantityAvailable -= 100
   }
   
   // Increase jobsite stock
   InventoryStock {
     itemId: concreteMix80lb.id
     locationId: jobsite789.id
     quantityOnHand += 100
     quantityAvailable += 100
   }
   ```

7. Update **InventoryItem** totals:
   ```prisma
   // Total onHand unchanged (just moved)
   InventoryItem.totalQuantityOnHand = unchanged
   ```

**Result**: Materials transferred, inventory updated at both locations

---

## 🔄 Core Workflow 7: Return from Project

### Overview
Return unused or damaged materials from project to warehouse

---

### Scenario: Return Excess Materials

**Trigger**: Project completed, excess materials to return

**Actions**:
1. Project manager initiates return:
   ```prisma
   InventoryReturn {
     returnNumber: "RET-2025-00045"
     returnType: FROM_PROJECT
     returnReason: EXCESS
     returnDate: today
     projectId: project.id
     toLocationId: mainWarehouse.id
     status: DRAFT
   }
   ```

2. Add **InventoryReturnLine**:
   ```prisma
   InventoryReturnLine {
     returnId: return.id
     itemId: plywood4x8.id
     quantityReturned: 15
     quantityAccepted: 0 // To be inspected
     quantityRejected: 0
     unitCost: 45.00
     condition: GOOD
     disposition: RESTOCK
   }
   ```

3. Warehouse receives and inspects:
   ```prisma
   InventoryReturn.status = DRAFT → RECEIVED
   InventoryReturn.receivedAt = now()
   
   InventoryReturnLine {
     quantityAccepted: 14 (one sheet damaged)
     quantityRejected: 1
     condition: GOOD (for 14 sheets)
     disposition: RESTOCK
     notes: "1 sheet water damaged, disposed"
   }
   ```

4. Restock accepted items:
   ```prisma
   InventoryReturn.status = RECEIVED → RESTOCKED
   ```

5. Create **InventoryTransaction**:
   ```prisma
   InventoryTransaction {
     transactionType: RETURN
     sourceType: PROJECT
     sourceId: project.id
     toLocationId: mainWarehouse.id
     status: POSTED
   }
   ```

6. Update **InventoryStock**:
   ```typescript
   // Decrease jobsite stock
   InventoryStock {
     locationId: jobsite789.id
     itemId: plywood4x8.id
     quantityOnHand -= 15
   }
   
   // Increase warehouse stock (only accepted qty)
   InventoryStock {
     locationId: mainWarehouse.id
     itemId: plywood4x8.id
     quantityOnHand += 14
   }
   ```

7. Create **InventoryLossEvent** for damaged item:
   ```prisma
   InventoryLossEvent {
     lossType: DAMAGE
     lossDate: today
     locationId: jobsite789.id
     totalLossValue: 45.00
     severity: LOW
     description: "1 plywood sheet water damaged"
   }
   ```

**Result**: Usable materials returned to stock, damaged items written off

---

## 🔄 Core Workflow 8: Automated Reordering

### Overview
System monitors stock levels and triggers reorder when below reorder point.

---

### Workflow: Auto-Reorder Triggered

**Trigger**: Stock drops below reorder point

**Actions**:
1. System monitors stock levels (daily job):
   ```typescript
   // Check all active reorder points
   const lowStockItems = await prisma.inventoryStock.findMany({
     where: {
       tenantId,
       quantityAvailable: { lte: reorderPoint }
     },
     include: {
       item: true,
       location: true,
       reorderPoint: true
     }
   });
   
   for (const stock of lowStockItems) {
     if (stock.reorderPoint.isActive) {
       triggerReorder(stock);
     }
   }
   ```

2. Create reorder alert:
   ```prisma
   CRMNotificationEvent {
     eventType: "INVENTORY_REORDER_TRIGGERED"
     recipientMemberId: purchasingAgent.id
     relatedEntityType: "INVENTORY_ITEM"
     relatedEntityId: item.id
     notificationContent: `
       Reorder triggered for: ${item.itemName}
       Location: ${location.locationName}
       Current Stock: ${stock.quantityAvailable}
       Reorder Point: ${reorderPoint.reorderPoint}
       Suggested Order Quantity: ${reorderPoint.reorderQuantity}
     `
     status: PENDING
   }
   ```

3. Auto-create draft **PurchaseOrder** (if configured):
   ```prisma
   PurchaseOrder {
     poNumber: "PO-2025-AUTO-00123"
     supplierId: item.preferredSupplierId
     orderDate: today
     status: DRAFT // Requires approval
     isAutoGenerated: true
   }
   
   PurchaseOrderLine {
     itemId: item.id
     quantity: reorderPoint.reorderQuantity
     unitPrice: itemVendor.unitPrice
     requestedDeliveryDate: today + item.leadTimeDays
   }
   ```

4. Update reorder point:
   ```prisma
   InventoryReorderPoint.lastTriggeredDate = today
   ```

**Result**: Reorder triggered, PO created, buyer notified

---

## 📊 Key Metrics & Reports

### Inventory Valuation Report

```typescript
// Total inventory value
const inventoryValue = await prisma.inventoryStock.aggregate({
  _sum: { totalValue: true },
  where: {
    tenantId,
    quantityOnHand: { gt: 0 }
  }
});

// By location
const byLocation = await prisma.inventoryStock.groupBy({
  by: ['locationId'],
  _sum: { totalValue: true },
  where: { tenantId }
});

// By category
const byCategory = await prisma.inventoryItem.groupBy({
  by: ['categoryId'],
  _sum: { totalQuantityOnHand: true, totalValue: true },
  where: { tenantId, status: 'ACTIVE' }
});
```

---

### Stock Movement Report

```typescript
// Transactions by type (last 30 days)
const movements = await prisma.inventoryTransaction.groupBy({
  by: ['transactionType'],
  _count: true,
  _sum: { totalValue: true },
  where: {
    tenantId,
    transactionDate: { gte: thirtyDaysAgo }
  }
});

// Output:
// RECEIPT: 45 transactions, $125,450
// ISSUE: 187 transactions, $98,230
// ADJUSTMENT: 12 transactions, -$1,245
// TRANSFER: 34 transactions, $0 (net zero)
```

---

### Loss Prevention Dashboard

```typescript
// Total losses by cause
const lossesByCause = await prisma.inventoryLossEvent.groupBy({
  by: ['lossType'],
  _count: true,
  _sum: { netLoss: true },
  where: {
    tenantId,
    lossDate: { gte: yearToDate }
  }
});

// Loss rate
const totalValue = inventoryValue._sum.totalValue
const totalLoss = lossesByCause._sum.netLoss
const lossRate = (totalLoss / totalValue) * 100

// Industry benchmark: <2% loss rate
// Goal: <1% loss rate
```

---

### Reorder Status Report

```typescript
// Items below reorder point
const needsReorder = await prisma.inventoryStock.count({
  where: {
    tenantId,
    quantityAvailable: { lte: reorderPoint }
  }
});

// Items below safety stock
const belowSafety = await prisma.inventoryStock.count({
  where: {
    tenantId,
    quantityOnHand: { lte: safetyStockQuantity }
  }
});

// On-order status
const onOrder = await prisma.inventoryItem.aggregate({
  _sum: { totalQuantityOnOrder: true },
  where: { tenantId }
});
```

---

## 🎯 Best Practices

### 1. Inventory Accuracy

**Do**:
- Conduct cycle counts regularly (ABC analysis)
- Full physical count annually
- Investigate ALL variances >5%
- Update counts immediately after posting

**Don't**:
- Skip counts because "too busy"
- Ignore small variances (they add up)
- Post adjustments without investigation

---

### 2. Loss Prevention

**Do**:
- Document EVERY loss event (no matter how small)
- Investigate high-value losses thoroughly
- Implement prevention measures immediately
- Track loss trends by location and category
- Set loss rate KPIs (<1% target)

**Don't**:
- Write off losses as "cost of doing business"
- Skip investigation for small losses
- Ignore patterns in loss data

---

### 3. Costing Accuracy

**Do**:
- Choose appropriate costing method (FIFO for construction)
- Update costs when receiving inventory
- Review average costs monthly
- Reconcile to accounting system

**Don't**:
- Use outdated standard costs
- Mix costing methods within same item
- Ignore cost variances

---

### 4. Reorder Automation

**Do**:
- Set realistic reorder points (based on lead time + usage)
- Maintain safety stock levels
- Review reorder parameters quarterly
- Adjust for seasonality

**Don't**:
- Set and forget reorder points
- Ignore lead time changes
- Over-stock slow-moving items

---

## 📊 Summary

**Inventory Module Suite** provides:
1. **Complete Item Master**: Items, categories, UOMs, suppliers
2. **Multi-Location Tracking**: Warehouses, jobsites, trucks, bins
3. **Transaction Management**: Receipts, issues, transfers, returns, adjustments
4. **Physical Counts**: Full, cycle, ABC, spot counts
5. **Zero-Loss Prevention**: Loss tracking, investigation, prevention ⭐
6. **Automated Reordering**: Reorder points, safety stock, demand forecasting
7. **Project Integration**: Reservations, material issues, cost tracking
8. **Audit Compliance**: Formal audits, findings, corrective actions
9. **Advanced Costing**: FIFO, LIFO, Average, Standard
10. **Serial/Lot Tracking**: Complete traceability

**Total Models**: 30 (inventoryCore: 10, inventoryTransactions: 10, inventoryControl: 10)

**Pattern Summary**:
- **Pattern B** (Full Actor): InventoryItem (critical entity)
- **BH Pattern** (globalId): InventoryTransaction, InventoryAdjustment, InventoryTransfer, InventoryReturn, InventoryCount, InventoryLossEvent, InventoryAudit
- **Pattern A** (IDs Only): All other supporting entities (22 models)

**Ready for Implementation**: ✅

---

**Next Steps**:
1. Review INVENTORY_ARCHITECTURE_DIAGRAM.md for complete model definitions
2. Generate Prisma migrations
3. Build tRPC API layers
4. Create UI components for inventory dashboard
5. Implement loss prevention workflows
6. Configure automated reordering
7. Set up cycle count schedules
8. Train warehouse staff on procedures

---

**Version**: 1.0  
**Last Updated**: November 17, 2025  
**Status**: ✅ COMPLETE & READY FOR IMPLEMENTATION
