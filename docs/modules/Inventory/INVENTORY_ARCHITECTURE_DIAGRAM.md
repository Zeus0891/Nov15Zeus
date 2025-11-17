# 📊 Inventory Module Suite - Architecture Visual Diagram

**Version:** 1.0  
**Last Updated:** November 17, 2025  
**Modules**: inventoryCore.prisma, inventoryTransactions.prisma, inventoryControl.prisma  
**Aligned with**: Estimate v8.0, Invoice v8.0, Project v2.0, CRM v1.0  
**Total Models**: 30 (10 + 10 + 10)

---

## 🏗️ Complete Structure Diagram - MODULE 1: INVENTORY CORE

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       InventoryItem (Critical Entity)                        │
│                          Pattern: Tenant + Pattern B                         │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                │                     │                     │
                ▼                     ▼                     ▼
        ┌───────────────┐     ┌───────────────┐   ┌──────────────┐
        │   IDENTITY    │     │   LIFECYCLE   │   │ GOVERNANCE   │
        ├───────────────┤     ├───────────────┤   ├──────────────┤
        │ id (UUID v7)  │     │ status        │   │ auditCorr... │
        │ tenantId      │     │ createdAt     │   │ dataClass... │
        │               │     │ updatedAt     │   │ retention... │
        │               │     │ deletedAt     │   │ recordSrc    │
        │               │     │               │   │ metadata     │
        │               │     │               │   │ timezone     │
        └───────────────┘     └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    ACTOR ATTRIBUTION (Pattern B - ENABLED)                   │
├─────────────────────────────────────────────────────────────────────────────┤
│ createdByActorId → Actor  |  updatedByActorId → Actor  |  deletedByActorId  │
│                      FULL ACTOR CROSS-RELATIONS                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUSINESS DIMENSIONS                                │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► 📄 ITEM IDENTITY
        │   ├── itemNumber (AUTO: ITEM-2025-00001)
        │   ├── itemName (REQUIRED)
        │   ├── itemDescription
        │   ├── sku (Stock Keeping Unit)
        │   ├── barcode, qrCode
        │   └── manufacturerPartNumber
        │
        ├─► 📊 ITEM CLASSIFICATION
        │   ├── itemType (MATERIAL|TOOL|EQUIPMENT|CONSUMABLE|SERVICE)
        │   ├── categoryId → InventoryCategory
        │   ├── subcategory
        │   └── tags (array)
        │
        ├─► 📦 INVENTORY ATTRIBUTES
        │   ├── trackingMethod (STANDARD|SERIALIZED|LOT_BATCH)
        │   ├── baseUnitOfMeasureId → InventoryUnitOfMeasure
        │   ├── weight, weightUnit
        │   ├── dimensions (length, width, height)
        │   └── volume, volumeUnit
        │
        ├─► 💰 COSTING
        │   ├── costingMethod (FIFO|LIFO|AVERAGE|STANDARD)
        │   ├── standardCost
        │   ├── averageCost (calculated)
        │   ├── lastPurchaseCost
        │   └── currencyCode
        │
        ├─► 💵 PRICING
        │   ├── sellingPrice
        │   ├── markupPercentage
        │   ├── listPrice
        │   └── priceUnit (per EA, per FT, per LB, etc.)
        │
        ├─► 📊 STATUS & FLAGS
        │   ├── status (ACTIVE|INACTIVE|DISCONTINUED|PENDING)
        │   ├── isStocked (maintain inventory)
        │   ├── isPurchasable
        │   ├── isSellable
        │   ├── isSerializedTracking
        │   ├── isLotTracking
        │   └── isPerishable
        │
        ├─► 📅 LIFECYCLE DATES
        │   ├── activeFromDate
        │   ├── discontinuedDate
        │   └── expirationWarningDays (for perishables)
        │
        ├─► 🏭 SUPPLIER INFO
        │   ├── preferredSupplierId → InventorySupplier
        │   ├── leadTimeDays
        │   └── minimumOrderQuantity
        │
        ├─► 📊 STOCK METRICS (Denormalized)
        │   ├── totalQuantityOnHand (sum across all locations)
        │   ├── totalQuantityReserved
        │   ├── totalQuantityAvailable
        │   ├── totalQuantityOnOrder
        │   ├── reorderPoint
        │   ├── safetyStockLevel
        │   └── lastStockCountDate
        │
        └─► 🔗 CROSS-MODULE LINKAGE
            ├── estimateLineItems[] → EstimateLineItem
            ├── projectTasks[] → ProjectTask (material usage)
            ├── invoiceLineItems[] → InvoiceLineItem (billing)
            └── purchaseOrderLines[] → PurchaseOrderLine (future)

┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHILD RELATIONS (15+ types)                               │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► InventoryStock[] (stock by location)
        ├─► InventoryItemVendor[] (vendor pricing)
        ├─► InventoryAttachment[] (images, specs)
        ├─► InventoryReservation[] (reserved for projects)
        ├─► InventoryCommitment[] (committed stock)
        ├─► InventoryReorderPoint[] (location-specific reorder)
        ├─► InventorySafetyStock[] (location-specific safety)
        ├─► InventoryTransactionLine[] (transaction history)
        ├─► InventoryAdjustment[] (adjustments)
        ├─► InventoryTransferLine[] (transfers)
        ├─► InventoryReturnLine[] (returns)
        ├─► InventoryCountLine[] (physical counts)
        ├─► InventoryLossEvent[] (shrinkage)
        └─► InventoryHistoryEvent[] (audit trail)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATUS FLOW DIAGRAM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    PENDING (setup/approval)
      │
      ▼
    ACTIVE (in use)
      │
      ├──► INACTIVE (temporarily disabled)
      │      │
      │      └──► ACTIVE (reactivated)
      │
      └──► DISCONTINUED (obsolete)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         INDEX STRATEGY (18 indexes)                          │
└─────────────────────────────────────────────────────────────────────────────┘

    🔑 PRIMARY CONSTRAINTS (2)
       ├── [tenantId, id]
       └── [tenantId, itemNumber]

    📊 UNIQUE CONSTRAINTS (3)
       ├── [tenantId, sku] (if provided)
       ├── [tenantId, barcode] (if provided)
       └── [tenantId, qrCode] (if provided)

    📊 STATUS FILTERS (2)
       ├── [tenantId, status]
       └── [tenantId, itemType]

    🔍 COMMON FILTERS (4)
       ├── [tenantId, categoryId]
       ├── [tenantId, isStocked]
       ├── [tenantId, trackingMethod]
       └── [tenantId, deletedAt]

    ⏰ TEMPORAL (1 BRIN)
       └── [createdAt]

    📈 ANALYTICS & GOVERNANCE (3)
       ├── [tenantId, auditCorrelationId]
       ├── [tenantId, dataClassification]
       └── [tenantId, preferredSupplierId]

    💰 COSTING & STOCK (3)
       ├── [tenantId, totalQuantityOnHand]
       ├── [tenantId, reorderPoint]
       └── [tenantId, isPerishable]

┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA FLOW DIAGRAM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    1. CREATE INVENTORY ITEM
       ├── Generate itemNumber (via NumberSequence)
       ├── Set categoryId (organize by material type)
       ├── Set baseUnitOfMeasureId (EA, FT, LB, etc.)
       ├── Set costingMethod (FIFO, AVERAGE, etc.)
       ├── Set status = PENDING
       └── Upload photos → InventoryAttachment

    2. SET COSTING & PRICING
       ├── standardCost (target cost)
       ├── sellingPrice (with markup)
       ├── markupPercentage = (sellingPrice - cost) / cost
       └── Update averageCost (as purchases occur)

    3. CONFIGURE SUPPLIERS
       ├── Add InventoryItemVendor records
       ├── Set preferredSupplierId
       ├── leadTimeDays, minimumOrderQuantity
       └── Vendor pricing tiers

    4. SET STOCK RULES
       ├── InventoryReorderPoint (per location)
       ├── InventorySafetyStock (per location)
       ├── reorderQuantity
       └── Enable auto-reorder flag

    5. ACTIVATE ITEM
       ├── status = PENDING → ACTIVE
       └── Item available for use

    6. INITIAL STOCK (if applicable)
       ├── Create InventoryAdjustment (type: OPENING_BALANCE)
       ├── Set quantity per location
       ├── Create InventoryStock records
       └── Update totalQuantityOnHand

    7. USAGE IN ESTIMATE
       ├── EstimateLineItem.inventoryItemId = item.id
       ├── Estimate uses standardCost for costing
       └── Estimate uses sellingPrice for client pricing

    8. PROJECT RESERVATION
       ├── Project approved → Reserve materials
       ├── Create InventoryReservation
       ├── totalQuantityReserved++
       └── totalQuantityAvailable = onHand - reserved

    9. MATERIAL ISSUE TO PROJECT
       ├── Create InventoryTransaction (type: ISSUE_TO_PROJECT)
       ├── totalQuantityOnHand--
       ├── totalQuantityReserved--
       └── Link to ProjectTask (material usage tracking)

    10. INVOICE BILLING
        ├── Invoice includes materials used
        ├── InvoiceLineItem.inventoryItemId = item.id
        └── Revenue recognition
```

---

## 🏗️ Supporting Models - Inventory Core

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   InventoryCategory (Pattern A - Hierarchy)                  │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📁 Category Details
       ├── categoryName (REQUIRED)
       ├── categoryCode
       ├── description
       └── parentCategoryId → InventoryCategory (nested)

    🎨 Display
       ├── iconName
       └── colorCode

    👤 Actor Attribution: Pattern A

    Examples:
       └── Building Materials
           ├── Lumber
           ├── Concrete & Masonry
           ├── Electrical
           └── Plumbing

┌─────────────────────────────────────────────────────────────────────────────┐
│                InventoryLocation (Pattern A - Warehouses/Sites)              │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📍 Location Details
       ├── locationCode (UNIQUE: WH-001, SITE-123)
       ├── locationName (REQUIRED)
       ├── locationType (WAREHOUSE|JOBSITE|TRUCK|OFFICE|VENDOR)
       └── description

    🏢 Physical Details
       ├── addressId → CRMAddress
       ├── gpsLatitude, gpsLongitude
       ├── capacity (total storage capacity)
       └── currentUtilization

    👤 Management
       ├── managerId → Member (location manager)
       └── isDefault (default location)

    📊 Status
       ├── status (ACTIVE|INACTIVE|CLOSED)
       └── isRestrictedAccess

    🔗 Children
       ├── InventoryBin[] (bins within location)
       └── InventoryStock[] (stock at location)

    👤 Actor Attribution: Pattern A

    Examples:
       ├── Main Warehouse (WH-001)
       ├── Jobsite #123 (SITE-123)
       ├── Truck #5 (TRUCK-005)
       └── Vendor Consignment (VENDOR-ABC)

┌─────────────────────────────────────────────────────────────────────────────┐
│                  InventoryBin (Pattern A - Specific Locations)               │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📦 Bin Details
       ├── locationId → InventoryLocation (REQUIRED)
       ├── binCode (UNIQUE per location: A-01-05)
       ├── binName
       └── binType (SHELF|RACK|FLOOR|PALLET|CAGE)

    📐 Physical Attributes
       ├── aisle, zone, section
       ├── capacity
       └── currentUtilization

    📊 Status
       └── status (ACTIVE|INACTIVE|FULL|QUARANTINE)

    👤 Actor Attribution: Pattern A

    Example: Warehouse Zone A, Aisle 1, Shelf 5 = "A-01-05"

┌─────────────────────────────────────────────────────────────────────────────┐
│            InventoryUnitOfMeasure (Pattern A - UOM Conversions)              │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📏 UOM Details
       ├── uomCode (EA, FT, LB, GAL, BOX, etc.)
       ├── uomName (Each, Foot, Pound, Gallon)
       ├── uomType (COUNT|LENGTH|WEIGHT|VOLUME)
       └── description

    🔄 Conversion
       ├── baseUomId → InventoryUnitOfMeasure (if conversion needed)
       ├── conversionFactor (e.g., 1 BOX = 12 EA)
       └── conversionFormula (for complex conversions)

    📊 Display
       ├── abbreviation (ea, ft, lb)
       └── decimalPlaces (0 for count, 2 for weight)

    Examples:
       ├── EA (Each) - Base unit
       ├── FT (Foot) - Base unit
       ├── BOX (Box) - 12 EA (conversion)
       └── PALLET (Pallet) - 48 BOX = 576 EA

┌─────────────────────────────────────────────────────────────────────────────┐
│           InventoryStock (Pattern A - Stock Levels by Location)              │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🆔 Linkage
       ├── itemId → InventoryItem (REQUIRED)
       ├── locationId → InventoryLocation (REQUIRED)
       └── binId → InventoryBin (optional)

    📊 Stock Quantities
       ├── quantityOnHand (current physical stock)
       ├── quantityReserved (reserved for projects/orders)
       ├── quantityAvailable (onHand - reserved)
       ├── quantityOnOrder (expected from POs)
       └── quantityAllocated (allocated but not issued)

    💰 Costing
       ├── averageUnitCost (weighted average)
       ├── totalValue (quantity × cost)
       └── lastCostUpdateDate

    📅 Dates
       ├── lastReceivedDate
       ├── lastIssuedDate
       └── lastCountedDate

    🔢 Serial/Lot Tracking
       ├── serialNumber (if serialized)
       ├── lotNumber (if lot tracked)
       ├── expirationDate (if perishable)
       └── manufacturedDate

    👤 Actor Attribution: Pattern A

    @@unique: [tenantId, itemId, locationId, binId, serialNumber, lotNumber]

┌─────────────────────────────────────────────────────────────────────────────┐
│                 InventorySupplier (Pattern A - Vendor Master)                │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🏢 Supplier Details
       ├── supplierNumber (AUTO: SUP-2025-00001)
       ├── supplierName (REQUIRED)
       ├── contactName, contactEmail, contactPhone
       └── accountId → CRMAccount (link to CRM if also client)

    📍 Address
       └── addressId → CRMAddress

    💰 Terms
       ├── paymentTerms (NET30, NET60, COD)
       ├── discountTerms (2/10 NET30)
       ├── currencyCode
       └── taxId

    📊 Performance
       ├── rating (1-5 stars)
       ├── onTimeDeliveryRate
       ├── qualityRating
       └── totalPurchaseAmount

    📊 Status
       └── status (ACTIVE|INACTIVE|SUSPENDED|PENDING)

    👤 Actor Attribution: Pattern A

┌─────────────────────────────────────────────────────────────────────────────┐
│         InventoryItemVendor (Pattern A - Item-Supplier Pricing M:N)         │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── itemId → InventoryItem
       └── supplierId → InventorySupplier

    💰 Pricing
       ├── unitPrice
       ├── minimumOrderQuantity
       ├── priceBreaks (JSON: [{qty: 100, price: 9.50}])
       └── currencyCode

    📦 Supply Details
       ├── supplierPartNumber
       ├── leadTimeDays
       ├── isPreferredVendor
       └── lastPurchaseDate

    📅 Contract
       ├── contractStartDate
       ├── contractEndDate
       └── contractNumber

    👤 Actor Attribution: Pattern A

┌─────────────────────────────────────────────────────────────────────────────┐
│              InventoryAttachment (Pattern A - Item Documentation)            │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📎 Attachment Details
       ├── itemId → InventoryItem
       ├── fileName, fileUrl, fileSize
       ├── mimeType
       └── attachmentType (PHOTO|SPEC_SHEET|MANUAL|SDS|DRAWING)

    📊 Display
       ├── isPrimary (primary photo)
       └── sortOrder

    👤 Actor Attribution: Pattern A

┌─────────────────────────────────────────────────────────────────────────────┐
│              InventoryHistoryEvent (Pattern A - Core Audit Trail)            │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📊 Event Tracking
       ├── entityType (ITEM|CATEGORY|LOCATION|SUPPLIER|STOCK)
       ├── entityId
       ├── changeType (CREATED|UPDATED|STATUS_CHANGE|PRICE_CHANGE)
       ├── fieldName, oldValue, newValue
       ├── timestamp
       └── actorId

    Use: Complete audit trail for inventory master data
```

---

## 🏗️ MODULE 2: INVENTORY TRANSACTIONS (inventoryTransactions.prisma)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                 InventoryTransaction (BH Pattern - Header)                   │
│                        Critical Transaction Record                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                │                     │                     │
                ▼                     ▼                     ▼
        ┌───────────────┐     ┌───────────────┐   ┌──────────────┐
        │   IDENTITY    │     │   LIFECYCLE   │   │ GOVERNANCE   │
        ├───────────────┤     ├───────────────┤   ├──────────────┤
        │ id (UUID v7)  │     │ status        │   │ auditCorr... │
        │ tenantId      │     │ createdAt     │   │ dataClass... │
        │ globalId ⭐   │     │ updatedAt     │   │ metadata     │
        │               │     │ postedAt      │   │              │
        └───────────────┘     └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    ACTOR ATTRIBUTION (Pattern A - IDs Only)                  │
├─────────────────────────────────────────────────────────────────────────────┤
│          createdByActorId | updatedByActorId | postedByActorId              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                      TRANSACTION DIMENSIONS                                  │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► 📄 TRANSACTION IDENTITY
        │   ├── transactionNumber (AUTO: TXN-2025-00001)
        │   ├── transactionType (RECEIPT|ISSUE|ADJUSTMENT|TRANSFER|RETURN)
        │   ├── transactionDate
        │   └── referenceNumber (PO#, Project#, etc.)
        │
        ├─► 📊 STATUS
        │   └── status (DRAFT|POSTED|CANCELLED|REVERSED)
        │
        ├─► 🔗 LINKAGE (Polymorphic)
        │   ├── sourceType (PURCHASE_ORDER|PROJECT|ESTIMATE|INVOICE|MANUAL)
        │   ├── sourceId (document id)
        │   ├── projectId → Project (if project-related)
        │   └── supplierId → InventorySupplier (if vendor transaction)
        │
        ├─► 📍 LOCATIONS
        │   ├── fromLocationId → InventoryLocation
        │   └── toLocationId → InventoryLocation
        │
        ├─► 📝 DETAILS
        │   ├── description, notes
        │   ├── totalValue (sum of line values)
        │   └── lineCount
        │
        └─► 🔗 CHILDREN
            └── InventoryTransactionLine[]

┌─────────────────────────────────────────────────────────────────────────────┐
│                         TRANSACTION TYPE FLOW                                │
└─────────────────────────────────────────────────────────────────────────────┘

    RECEIPT (Increase Stock)
       ├── From: Supplier
       ├── To: Warehouse
       └── Source: Purchase Order

    ISSUE (Decrease Stock)
       ├── From: Warehouse
       ├── To: Project/Customer
       └── Source: Project, Invoice

    ADJUSTMENT (Correct Stock)
       ├── Location: Warehouse
       └── Source: Physical Count, Correction

    TRANSFER (Move Stock)
       ├── From: Warehouse A
       ├── To: Warehouse B
       └── Source: Transfer Order

    RETURN (Return Stock)
       ├── From: Project/Customer
       ├── To: Warehouse
       └── Source: Project, Invoice

┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATUS FLOW DIAGRAM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    DRAFT (preparing transaction)
      │
      ▼
    POSTED (stock updated) ──► postedAt set
      │                         Stock quantities updated
      │                         Cannot edit
      │
      ├──► REVERSED (undo transaction)
      │      └── Creates offsetting transaction
      │
      └──► CANCELLED (before posting)

┌─────────────────────────────────────────────────────────────────────────────┐
│           InventoryTransactionLine (Pattern A - Line Items)                  │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── transactionId → InventoryTransaction (REQUIRED)
       ├── itemId → InventoryItem (REQUIRED)
       ├── locationId → InventoryLocation
       └── binId → InventoryBin (optional)

    📊 Quantities
       ├── quantity (transaction quantity)
       ├── unitOfMeasureId → InventoryUnitOfMeasure
       ├── serialNumber (if serialized)
       ├── lotNumber (if lot tracked)
       └── expirationDate (if perishable)

    💰 Costing
       ├── unitCost
       ├── totalCost (quantity × unitCost)
       └── costingMethod (FIFO|LIFO|AVERAGE)

    📝 Details
       ├── lineNumber (sort order)
       ├── description
       └── notes

    👤 Actor Attribution: Pattern A

┌─────────────────────────────────────────────────────────────────────────────┐
│              InventoryAdjustment (BH Pattern - Stock Corrections)            │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🆔 Identity (BH Pattern)
       ├── id, tenantId
       └── globalId ⭐

    📄 Adjustment Details
       ├── adjustmentNumber (AUTO: ADJ-2025-00001)
       ├── adjustmentType (PHYSICAL_COUNT|CORRECTION|DAMAGE|OBSOLETE|OPENING_BALANCE)
       ├── adjustmentDate
       └── reason

    📍 Location
       └── locationId → InventoryLocation

    📊 Status
       └── status (DRAFT|APPROVED|POSTED)

    🔗 Linkage
       ├── approvalRequestId → ApprovalRequest (if approval required)
       └── relatedCountId → InventoryCount (if from physical count)

    💰 Financial Impact
       └── totalAdjustmentValue (sum of line adjustments)

    📝 Details
       ├── description, notes
       └── attachments (photos of damage, etc.)

    👤 Actor Attribution: Pattern A

    Creates InventoryTransaction (type: ADJUSTMENT) when posted

┌─────────────────────────────────────────────────────────────────────────────┐
│              InventoryTransfer (BH Pattern - Location Transfers)             │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🆔 Identity (BH Pattern)
       ├── id, tenantId
       └── globalId ⭐

    📄 Transfer Details
       ├── transferNumber (AUTO: TRF-2025-00001)
       ├── transferDate
       └── requestedDeliveryDate

    📍 Locations
       ├── fromLocationId → InventoryLocation (REQUIRED)
       └── toLocationId → InventoryLocation (REQUIRED)

    📊 Status
       ├── status (DRAFT|IN_TRANSIT|RECEIVED|CANCELLED)
       ├── shippedAt
       └── receivedAt

    👥 Parties
       ├── requestedByMemberId → Member
       ├── shippedByMemberId → Member
       └── receivedByMemberId → Member

    🚚 Shipping
       ├── carrierName
       ├── trackingNumber
       └── shippingMethod

    📝 Details
       ├── description, notes
       └── InventoryTransferLine[]

    👤 Actor Attribution: Pattern A

    Creates 2 InventoryTransactions when received:
       1. ISSUE from source location
       2. RECEIPT at destination location

┌─────────────────────────────────────────────────────────────────────────────┐
│            InventoryTransferLine (Pattern A - Transfer Line Items)           │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── transferId → InventoryTransfer
       └── itemId → InventoryItem

    📊 Quantities
       ├── quantityRequested
       ├── quantityShipped
       ├── quantityReceived
       └── unitOfMeasureId

    🔢 Tracking
       ├── serialNumber (if serialized)
       └── lotNumber (if lot tracked)

    📝 Details
       └── notes

┌─────────────────────────────────────────────────────────────────────────────┐
│               InventoryReturn (BH Pattern - Material Returns)                │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🆔 Identity (BH Pattern)
       ├── id, tenantId
       └── globalId ⭐

    📄 Return Details
       ├── returnNumber (AUTO: RET-2025-00001)
       ├── returnType (FROM_PROJECT|FROM_SUPPLIER|FROM_CLIENT)
       ├── returnDate
       └── returnReason (EXCESS|DEFECTIVE|WRONG_ITEM|OTHER)

    📍 Location
       └── toLocationId → InventoryLocation (where returned)

    🔗 Linkage
       ├── projectId → Project (if from project)
       ├── supplierId → InventorySupplier (if to supplier)
       └── sourceTransactionId (original issue transaction)

    📊 Status
       ├── status (DRAFT|APPROVED|RECEIVED|RESTOCKED)
       └── receivedAt

    💰 Financial
       ├── totalReturnValue
       └── creditAmount (if returning to supplier)

    📝 Details
       ├── description, notes
       └── InventoryReturnLine[]

    👤 Actor Attribution: Pattern A

┌─────────────────────────────────────────────────────────────────────────────┐
│             InventoryReturnLine (Pattern A - Return Line Items)              │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── returnId → InventoryReturn
       └── itemId → InventoryItem

    📊 Quantities
       ├── quantityReturned
       ├── quantityAccepted (may be less than returned)
       ├── quantityRejected
       └── unitOfMeasureId

    💰 Costing
       ├── unitCost
       └── totalValue

    📝 Condition
       ├── condition (GOOD|DAMAGED|DEFECTIVE)
       ├── disposition (RESTOCK|SCRAP|REPAIR|RETURN_TO_VENDOR)
       └── notes

┌─────────────────────────────────────────────────────────────────────────────┐
│              InventoryCount (BH Pattern - Physical Count Cycles)             │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🆔 Identity (BH Pattern)
       ├── id, tenantId
       └── globalId ⭐

    📄 Count Details
       ├── countNumber (AUTO: CNT-2025-00001)
       ├── countType (FULL|CYCLE|SPOT|ABC)
       ├── countDate
       └── scheduledDate

    📍 Scope
       ├── locationId → InventoryLocation (REQUIRED)
       ├── categoryId → InventoryCategory (if filtering)
       └── zoneId (if partial count)

    📊 Status
       ├── status (SCHEDULED|IN_PROGRESS|COMPLETED|APPROVED|CANCELLED)
       ├── startedAt
       ├── completedAt
       └── approvedAt

    👥 Team
       ├── assignedToMemberId → Member
       └── approvedByMemberId → Member

    📊 Results
       ├── itemsCountedTotal
       ├── itemsWithVariance
       ├── totalVarianceValue
       └── accuracyPercentage

    📝 Details
       ├── description, notes
       └── InventoryCountLine[]

    👤 Actor Attribution: Pattern A

    When approved, creates InventoryAdjustment for variances

┌─────────────────────────────────────────────────────────────────────────────┐
│            InventoryCountLine (Pattern A - Count Line Items)                 │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── countId → InventoryCount
       ├── itemId → InventoryItem
       ├── locationId → InventoryLocation
       └── binId → InventoryBin (optional)

    📊 Quantities
       ├── systemQuantity (from InventoryStock)
       ├── countedQuantity (actual count)
       ├── varianceQuantity (counted - system)
       └── variancePercentage

    💰 Financial Impact
       ├── unitCost
       ├── varianceValue (variance × cost)
       └── varianceReason

    🔢 Tracking
       ├── serialNumber (if serialized)
       └── lotNumber (if lot tracked)

    📝 Details
       ├── countedByMemberId → Member
       ├── countedAt
       └── notes

┌─────────────────────────────────────────────────────────────────────────────┐
│          InventoryTransactionHistory (Pattern A - Transaction Audit)         │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📊 Event Tracking
       ├── entityType (TRANSACTION|ADJUSTMENT|TRANSFER|RETURN|COUNT)
       ├── entityId
       ├── changeType (CREATED|POSTED|CANCELLED|REVERSED)
       ├── fieldName, oldValue, newValue
       ├── timestamp
       └── actorId

    Use: Complete audit trail for all transactions
```

---

## 🏗️ MODULE 3: INVENTORY CONTROL (inventoryControl.prisma)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│          InventoryLossEvent (BH Pattern - Zero-Loss Prevention)              │
│                          CRITICAL INNOVATION                                 │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🆔 Identity (BH Pattern)
       ├── id, tenantId
       └── globalId ⭐

    📄 Loss Details
       ├── lossNumber (AUTO: LOSS-2025-00001)
       ├── lossDate
       ├── discoveredDate
       └── lossType (THEFT|DAMAGE|SHRINKAGE|OBSOLETE|WEATHER|UNKNOWN)

    📍 Location
       ├── locationId → InventoryLocation
       └── binId → InventoryBin (if known)

    💰 Financial Impact
       ├── totalLossValue
       ├── recoveryAmount (insurance, etc.)
       └── netLoss

    📊 Status
       ├── status (REPORTED|INVESTIGATING|RESOLVED|CLOSED)
       └── severity (LOW|MEDIUM|HIGH|CRITICAL)

    👥 Parties
       ├── reportedByMemberId → Member
       ├── investigatedByMemberId → Member
       └── approvedByMemberId → Member

    🔗 Linkage
       ├── causedById → InventoryLossCause
       ├── projectId → Project (if project-related)
       └── investigations → InventoryLossInvestigation[]

    📝 Details
       ├── description
       ├── circumstancesDescription
       ├── preventiveMeasures
       └── attachments (photos, police reports)

    👤 Actor Attribution: Pattern A

    ⭐ KEY INNOVATION: Zero-loss prevention tracking

┌─────────────────────────────────────────────────────────────────────────────┐
│             InventoryLossCause (Pattern A - Loss Categorization)             │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📊 Cause Details
       ├── causeName (REQUIRED)
       ├── causeCode
       ├── causeCategory (INTERNAL|EXTERNAL|NATURAL|UNKNOWN)
       └── description

    📈 Metrics
       ├── totalIncidents
       ├── totalLossValue
       └── averageLossValue

    🎯 Prevention
       └── preventionGuidelines (text)

    Examples:
       ├── Theft - Employee
       ├── Theft - External
       ├── Damage - Transport
       ├── Damage - Handling
       ├── Weather - Rain
       ├── Obsolescence
       └── Unknown

┌─────────────────────────────────────────────────────────────────────────────┐
│        InventoryLossInvestigation (Pattern A - Investigation Records)        │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       └── lossEventId → InventoryLossEvent

    📝 Investigation Details
       ├── investigationDate
       ├── investigatorMemberId → Member
       ├── findings (text)
       ├── rootCause
       └── recommendations

    📎 Evidence
       ├── witnessStatements
       ├── securityFootage
       └── attachments

    📊 Status
       ├── status (IN_PROGRESS|COMPLETED|CLOSED)
       └── completedAt

    💰 Recovery
       ├── recoveryAttempted
       ├── recoveryAmount
       └── insuranceClaim

┌─────────────────────────────────────────────────────────────────────────────┐
│               InventoryAudit (BH Pattern - Formal Audits)                    │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🆔 Identity (BH Pattern)
       ├── id, tenantId
       └── globalId ⭐

    📄 Audit Details
       ├── auditNumber (AUTO: AUD-2025-00001)
       ├── auditType (INTERNAL|EXTERNAL|REGULATORY|INSURANCE)
       ├── auditScope (FULL|PARTIAL|LOCATION|CATEGORY)
       ├── startDate, endDate
       └── purpose

    📍 Scope
       ├── locationIds (array of locations)
       └── categoryIds (array of categories)

    👥 Team
       ├── auditorMemberId → Member (lead auditor)
       ├── externalAuditorName (if external)
       └── externalAuditorFirm

    📊 Status
       ├── status (SCHEDULED|IN_PROGRESS|COMPLETED|REPORT_ISSUED)
       └── reportIssuedAt

    📊 Results
       ├── itemsAudited
       ├── findingsCount
       ├── criticalFindingsCount
       └── overallScore (1-100)

    📝 Details
       ├── summary
       ├── recommendations
       ├── findings → InventoryAuditLine[]
       └── attachments (audit report PDF)

    👤 Actor Attribution: Pattern A

┌─────────────────────────────────────────────────────────────────────────────┐
│              InventoryAuditLine (Pattern A - Audit Findings)                 │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── auditId → InventoryAudit
       └── itemId → InventoryItem (if item-specific)

    📊 Finding Details
       ├── findingType (VARIANCE|PROCESS|CONTROL|COMPLIANCE|OTHER)
       ├── severity (LOW|MEDIUM|HIGH|CRITICAL)
       ├── finding (description)
       ├── recommendation
       └── correctiveAction

    📍 Location
       └── locationId → InventoryLocation (if location-specific)

    📊 Status
       ├── status (OPEN|IN_PROGRESS|RESOLVED|CLOSED)
       ├── targetResolutionDate
       └── actualResolutionDate

    👥 Assignment
       └── assignedToMemberId → Member

┌─────────────────────────────────────────────────────────────────────────────┐
│          InventoryReservation (Pattern A - Project/Order Reservations)       │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── itemId → InventoryItem (REQUIRED)
       ├── locationId → InventoryLocation
       ├── projectId → Project (if project)
       ├── estimateId → Estimate (if estimate)
       └── orderId → SalesOrder (if order - future)

    📊 Quantities
       ├── quantityReserved
       ├── quantityFulfilled (issued)
       ├── quantityRemaining (reserved - fulfilled)
       └── unitOfMeasureId

    📅 Dates
       ├── reservationDate
       ├── requiredByDate
       ├── expirationDate (auto-release if not used)
       └── fulfilledAt

    📊 Status
       └── status (ACTIVE|PARTIALLY_FULFILLED|FULFILLED|RELEASED|EXPIRED)

    📝 Details
       ├── reservedForDescription
       └── notes

    👤 Actor Attribution: Pattern A

    Effect: InventoryStock.quantityReserved++

┌─────────────────────────────────────────────────────────────────────────────┐
│            InventoryCommitment (Pattern A - Hard Commitments)                │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── itemId → InventoryItem (REQUIRED)
       ├── locationId → InventoryLocation
       ├── projectId → Project
       └── estimateId → Estimate

    📊 Quantities
       ├── quantityCommitted
       ├── quantityIssued
       ├── quantityRemaining
       └── unitOfMeasureId

    📅 Dates
       ├── commitmentDate
       ├── requiredByDate
       └── expirationDate

    📊 Status
       └── status (COMMITTED|PARTIALLY_ISSUED|FULFILLED|CANCELLED)

    💰 Costing
       ├── unitCost (locked at commitment)
       └── totalCommittedValue

    📝 Details
       └── notes

    👤 Actor Attribution: Pattern A

    Difference from Reservation: Commitment is harder (cannot be released)

┌─────────────────────────────────────────────────────────────────────────────┐
│         InventoryReorderPoint (Pattern A - Location Reorder Rules)           │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── itemId → InventoryItem (REQUIRED)
       └── locationId → InventoryLocation (REQUIRED)

    📊 Reorder Settings
       ├── reorderPoint (trigger level)
       ├── reorderQuantity (how much to order)
       ├── minimumQuantity (never go below)
       └── maximumQuantity (never exceed)

    📅 Lead Time
       ├── leadTimeDays
       └── reviewPeriodDays (how often to check)

    📊 Demand Forecast
       ├── averageDailyUsage (calculated)
       ├── seasonalFactor (1.0 = normal)
       └── trendFactor

    📊 Status
       ├── isActive
       └── lastTriggeredDate

    👤 Actor Attribution: Pattern A

    @@unique: [tenantId, itemId, locationId]

┌─────────────────────────────────────────────────────────────────────────────┐
│          InventorySafetyStock (Pattern A - Location Safety Levels)           │
└─────────────────────────────────────────────────────────────────────────────┘
    
    🔗 Linkage
       ├── itemId → InventoryItem (REQUIRED)
       └── locationId → InventoryLocation (REQUIRED)

    📊 Safety Stock Settings
       ├── safetyStockQuantity (buffer stock)
       ├── calculationMethod (MANUAL|DAYS_SUPPLY|STATISTICAL)
       ├── daysOfSupply (if using days method)
       └── serviceLevel (99%, 95%, etc.)

    📊 Variability Factors
       ├── demandVariability
       ├── leadTimeVariability
       └── confidenceLevel

    📝 Details
       ├── reason (WHY safety stock needed)
       └── notes

    👤 Actor Attribution: Pattern A

    @@unique: [tenantId, itemId, locationId]

┌─────────────────────────────────────────────────────────────────────────────┐
│          InventoryControlHistory (Pattern A - Control Audit Trail)           │
└─────────────────────────────────────────────────────────────────────────────┘
    
    📊 Event Tracking
       ├── entityType (LOSS|AUDIT|RESERVATION|REORDER|SAFETY_STOCK)
       ├── entityId
       ├── changeType (CREATED|UPDATED|RESOLVED|CLOSED)
       ├── fieldName, oldValue, newValue
       ├── timestamp
       └── actorId

    Use: Complete audit trail for inventory control activities
```

---

## 🔄 CROSS-MODULE INTEGRATION

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    INVENTORY → ESTIMATE INTEGRATION                          │
└─────────────────────────────────────────────────────────────────────────────┘

    EstimateLineItem
         │
         └───► inventoryItemId → InventoryItem
               ├── Pull standardCost for costing
               ├── Pull sellingPrice for client pricing
               ├── Pull leadTimeDays for scheduling
               └── Check totalQuantityAvailable

    Material Costing:
       EstimateLineItem.quantity × InventoryItem.standardCost = Material Cost
       EstimateLineItem.price = InventoryItem.sellingPrice × markupPercentage

┌─────────────────────────────────────────────────────────────────────────────┐
│                    INVENTORY → PROJECT INTEGRATION                           │
└─────────────────────────────────────────────────────────────────────────────┘

    Project Approved
         │
         ├───► Create InventoryReservation
         │        ├── projectId = project.id
         │        ├── itemId = estimateLineItem.inventoryItemId
         │        ├── quantityReserved = estimateLineItem.quantity
         │        └── requiredByDate = project.plannedStartDate
         │
         └───► Update InventoryStock
                    └── quantityReserved++

    Material Issue to Project:
         │
         ├───► Create InventoryTransaction (type: ISSUE_TO_PROJECT)
         │        ├── projectId = project.id
         │        ├── fromLocationId = warehouse.id
         │        └── transactionDate = now
         │
         ├───► Create InventoryTransactionLine
         │        ├── itemId = inventoryItem.id
         │        ├── quantity = issued
         │        └── unitCost = current cost
         │
         ├───► Update InventoryStock
         │        ├── quantityOnHand--
         │        └── quantityReserved--
         │
         └───► Link to ProjectTask
                    └── Track material usage per task

┌─────────────────────────────────────────────────────────────────────────────┐
│                    INVENTORY → INVOICE INTEGRATION                           │
└─────────────────────────────────────────────────────────────────────────────┘

    InvoiceLineItem
         │
         └───► inventoryItemId → InventoryItem
               ├── Bill materials used on project
               ├── Pull sellingPrice
               └── Link to InventoryTransaction (material issue)

    Billing Flow:
       1. Materials issued to project → InventoryTransaction
       2. Invoice created → InvoiceLineItem references InventoryItem
       3. InvoiceLineItem.quantity = materials used
       4. InvoiceLineItem.unitPrice = InventoryItem.sellingPrice
       5. Revenue recognition

┌─────────────────────────────────────────────────────────────────────────────┐
│                INVENTORY → PURCHASE ORDER INTEGRATION (Future)               │
└─────────────────────────────────────────────────────────────────────────────┘

    Create Purchase Order
         │
         ├───► PurchaseOrderLine
         │        ├── inventoryItemId → InventoryItem
         │        ├── quantity = order quantity
         │        └── unitPrice = vendor price
         │
         └───► Update InventoryStock
                    └── quantityOnOrder++

    Receive Purchase Order:
         │
         ├───► Create InventoryTransaction (type: RECEIPT)
         │        ├── supplierId = po.supplierId
         │        ├── sourceType = "PURCHASE_ORDER"
         │        └── sourceId = po.id
         │
         ├───► Create InventoryTransactionLine
         │        ├── quantity = received
         │        └── unitCost = po line unit price
         │
         ├───► Update InventoryStock
         │        ├── quantityOnHand++
         │        ├── quantityOnOrder--
         │        └── averageUnitCost = recalculate (FIFO/LIFO/AVG)
         │
         └───► Update InventoryItem
                    ├── lastPurchaseCost = po line unit price
                    └── averageCost = recalculate

┌─────────────────────────────────────────────────────────────────────────────┐
│                    INVENTORY → CRM INTEGRATION                               │
└─────────────────────────────────────────────────────────────────────────────┘

    InventorySupplier
         │
         └───► accountId → CRMAccount (if supplier is also a customer)

    Benefits:
       ├── Single contact management
       ├── Unified communication history
       └── 360° vendor relationship view
```

---

## 📊 PATTERN SUMMARY

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PATTERN DISTRIBUTION                                 │
└─────────────────────────────────────────────────────────────────────────────┘

    🔴 PATTERN B (Full Actor Relations) - CRITICAL ENTITIES (1)
       └── InventoryItem

    🟡 BH PATTERN (Base Hybrid - globalId enabled) (7)
       ├── InventoryTransaction
       ├── InventoryAdjustment
       ├── InventoryTransfer
       ├── InventoryReturn
       ├── InventoryCount
       ├── InventoryLossEvent
       └── InventoryAudit

    🟢 PATTERN A (Lightweight - IDs Only) (22)
       ├── InventoryCategory
       ├── InventoryLocation
       ├── InventoryBin
       ├── InventoryUnitOfMeasure
       ├── InventoryStock
       ├── InventorySupplier
       ├── InventoryItemVendor
       ├── InventoryAttachment
       ├── InventoryHistoryEvent
       ├── InventoryTransactionLine
       ├── InventoryTransferLine
       ├── InventoryReturnLine
       ├── InventoryCountLine
       ├── InventoryTransactionHistory
       ├── InventoryLossCause
       ├── InventoryLossInvestigation
       ├── InventoryAuditLine
       ├── InventoryReservation
       ├── InventoryCommitment
       ├── InventoryReorderPoint
       ├── InventorySafetyStock
       └── InventoryControlHistory
```

---

## 🎯 KEY INNOVATIONS

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      INVENTORY KEY INNOVATIONS                               │
└─────────────────────────────────────────────────────────────────────────────┘

    ⭐ ZERO-LOSS PREVENTION (InventoryLossEvent)
       └── Unique to construction/field services
           ├── Track every loss incident
           ├── Categorize loss causes
           ├── Formal investigations
           ├── Prevention measures
           ├── Financial impact tracking
           └── Insurance claim support

    ⭐ MULTI-LOCATION / MULTI-BIN TRACKING
       └── Critical for distributed operations
           ├── InventoryLocation (warehouses, jobsites, trucks)
           ├── InventoryBin (specific storage locations)
           ├── InventoryStock (per location/bin)
           └── GPS tracking for mobile inventory

    ⭐ PROJECT-INTEGRATED RESERVATIONS
       └── Seamless project material planning
           ├── Reserve materials when project approved
           ├── Prevent over-commitment
           ├── Auto-allocate to projects
           └── Track material usage per task

    ⭐ SERIAL/LOT/BATCH TRACKING
       └── Full traceability
           ├── Serial numbers for tools/equipment
           ├── Lot numbers for materials (concrete batch, lumber lot)
           ├── Expiration tracking for perishables
           └── Warranty tracking

    ⭐ ADVANCED COSTING METHODS
       └── Flexible costing for accuracy
           ├── FIFO (First In, First Out)
           ├── LIFO (Last In, First Out)
           ├── Weighted Average
           ├── Standard Cost
           └── Real-time cost updates

    ⭐ AUTOMATED REORDERING
       └── Never run out of critical materials
           ├── InventoryReorderPoint (per location)
           ├── InventorySafetyStock (buffer levels)
           ├── Demand forecasting
           ├── Seasonal adjustments
           └── Auto-generate POs (future)

    ⭐ PHYSICAL COUNT CYCLES
       └── Maintain inventory accuracy
           ├── Full counts (annual)
           ├── Cycle counts (ongoing)
           ├── ABC analysis (priority-based)
           ├── Variance tracking
           └── Auto-adjustment posting

    ⭐ AUDIT COMPLIANCE
       └── Enterprise audit readiness
           ├── Formal audit module
           ├── External auditor support
           ├── Findings tracking
           ├── Corrective actions
           └── Report generation
```

---

## 🎯 Conclusión Visual

Este diagrama muestra la **arquitectura completa** de los 3 módulos INVENTORY:

1. ✅ **30 models total** (10 + 10 + 10) organizados en 3 módulos
2. ✅ **Pattern B** para InventoryItem (CRITICAL - full actor)
3. ✅ **BH Pattern** para transacciones (globalId for traceability)
4. ✅ **Pattern A** para todos los modelos de soporte (lightweight)
5. ✅ **Multi-location tracking** (warehouses + jobsites + trucks)
6. ✅ **Zero-loss prevention** (unique innovation)
7. ✅ **Serial/Lot/Batch** tracking
8. ✅ **FIFO/LIFO/Average** costing
9. ✅ **Project integration** (reservations + usage tracking)
10. ✅ **Automated reordering** (safety stock + reorder points)
11. ✅ **Physical count cycles** (full + cycle + ABC)
12. ✅ **Audit compliance** (formal audits + findings)

**PRODUCTION-READY** para implementación inmediata.

---

**Preparado por**: Claude (Anthropic)  
**Fecha**: 2025-11-17  
**Versión**: 1.0
