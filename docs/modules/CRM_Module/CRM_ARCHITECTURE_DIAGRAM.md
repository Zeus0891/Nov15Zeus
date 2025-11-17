# 📊 CRM Module Suite - Architecture Visual Diagram

**Version:** 1.0  
**Last Updated:** November 17, 2025  
**Modules**: crmcore.prisma, crmcommunication.prisma, crmrelationships.prisma  
**Aligned with**: Estimate v8.0, Invoice v8.0, Project v2.0  
**Total Models**: 30 (10 + 10 + 10)

---

## 🏗️ Complete Structure Diagram - MODULE 1: CRM CORE

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          CRMAccount (Critical Entity)                        │
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
        ├─► 📄 BUSINESS IDENTITY
        │   ├── accountName (REQUIRED)
        │   ├── accountNumber (AUTO: ACC-2025-00001)
        │   └── accountCode (optional user code)
        │
        ├─► 🏢 ACCOUNT CLASSIFICATION
        │   ├── accountType (COMPANY|INDIVIDUAL|GOVERNMENT|NON_PROFIT)
        │   ├── industry
        │   └── website
        │
        ├─► 📊 STATUS & RATING
        │   ├── status (ACTIVE|INACTIVE|LEAD|PROSPECT|CUSTOMER|FORMER)
        │   ├── rating (HOT|WARM|COLD)
        │   └── leadSource
        │
        ├─► 💰 FINANCIAL METRICS
        │   ├── lifetimeValue
        │   ├── totalRevenue
        │   ├── totalProjects
        │   └── totalInvoices
        │
        ├─► 👤 OWNERSHIP & TERRITORY
        │   ├── ownerMemberId → Member
        │   ├── territoryId
        │   └── assignedTeamId
        │
        └─► 🔗 CROSS-MODULE LINKAGE
            ├── estimates[] → Estimate (crmAccountId REQUIRED)
            ├── invoices[] → Invoice (crmAccountId REQUIRED)
            └── projects[] → Project (crmAccountId REQUIRED)

┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHILD RELATIONS (20+ types total)                         │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► CRMContact[] (people at this account)
        ├─► CRMAddress[] (locations)
        ├─► CRMInteraction[] (touchpoints)
        ├─► CRMNote[] (notes)
        ├─► CRMAccountTag[] (M:N tags)
        ├─► CRMActivity[] (tasks/events)
        ├─► CRMEmail[] (from Communication module)
        ├─► CRMSMS[] (from Communication module)
        ├─► CRMPhoneCall[] (from Communication module)
        ├─► CRMMessageThread[] (from Communication module)
        ├─► CRMAccountRelationship[] (account-to-account)
        ├─► CRMContactRole[] (contact roles in account)
        ├─► CRMAccountHierarchy (org structure)
        └─► CRMPartner (partner management)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATUS FLOW DIAGRAM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    LEAD
      │
      ├──► Qualified ──► PROSPECT
      │                      │
      └──► Disqualified ──► INACTIVE
                             │
    PROSPECT                 │
      │                      │
      ├──► Deal Won ──► CUSTOMER ──► ACTIVE
      │                      │
      └──► Deal Lost ──► INACTIVE ─┘
    
    ACTIVE ──► Churn ──► FORMER
      │
      └──► Win Back ──► ACTIVE

┌─────────────────────────────────────────────────────────────────────────────┐
│                         INDEX STRATEGY (15 indexes)                          │
└─────────────────────────────────────────────────────────────────────────────┘

    🔑 PRIMARY CONSTRAINTS (2)
       ├── [tenantId, id]
       └── [tenantId, accountNumber]

    📊 STATUS FILTERS (3)
       ├── [tenantId, status]
       ├── [tenantId, accountType]
       └── [tenantId, rating]

    🔍 COMMON FILTERS (2)
       ├── [tenantId, ownerMemberId]
       └── [tenantId, deletedAt]

    ⏰ TEMPORAL (1 BRIN)
       └── [createdAt]

    📈 ANALYTICS & GOVERNANCE (2)
       ├── [tenantId, auditCorrelationId]
       └── [tenantId, dataClassification]

┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA FLOW DIAGRAM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    1. CREATE ACCOUNT
       ├── Generate accountNumber (via NumberSequence)
       ├── Set status = LEAD
       ├── Assign ownerMemberId (routing rules)
       └── Create initial CRMActivity (follow-up task)

    2. ADD CONTACTS & ADDRESSES
       ├── CRMContact (people at account)
       ├── CRMAddress (locations)
       └── CRMContactRole (define roles)

    3. TRACK INTERACTIONS
       ├── CRMInteraction (calls, meetings, visits)
       ├── CRMEmail (email correspondence)
       ├── CRMSMS (text messages)
       └── CRMPhoneCall (phone calls)

    4. QUALIFY LEAD
       ├── Update status: LEAD → PROSPECT
       ├── Update rating (HOT|WARM|COLD)
       └── Create CRMActivity for next steps

    5. CREATE ESTIMATE
       ├── Link Estimate.crmAccountId
       ├── Link Estimate.crmContactId
       └── Create CRMInteraction (type: EMAIL, "Estimate Sent")

    6. WIN DEAL
       ├── Update status: PROSPECT → CUSTOMER
       ├── totalProjects++
       ├── lifetimeValue += estimateAmount
       └── Auto-create Project (if configured)

    7. ONGOING BUSINESS
       ├── Update status: CUSTOMER → ACTIVE
       ├── Track all Projects, Invoices
       ├── Update totalRevenue (on payment)
       └── Schedule regular check-in activities
```

---

## 🏗️ Complete Structure Diagram - CRMContact

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          CRMContact (Critical Entity)                        │
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
        ├─► 📄 PERSONAL INFORMATION
        │   ├── firstName, lastName, fullName
        │   ├── middleName, suffix
        │   └── (Auto-compute: fullName = firstName + lastName)
        │
        ├─► 📧 CONTACT INFORMATION
        │   ├── email (unique per tenant)
        │   ├── emailSecondary
        │   ├── phone, phoneSecondary
        │   ├── mobile
        │   └── fax
        │
        ├─► 🏢 PROFESSIONAL INFORMATION
        │   ├── title (job title)
        │   ├── department
        │   └── primaryAccountId → CRMAccount
        │
        ├─► 📊 STATUS & PREFERENCES
        │   ├── status (ACTIVE|INACTIVE|DECEASED)
        │   ├── preferredContactMethod (EMAIL|PHONE|SMS)
        │   └── preferredLanguage
        │
        ├─► 🔒 PRIVACY & CONSENT (GDPR)
        │   ├── doNotCall, doNotEmail, doNotText
        │   ├── gdprConsent
        │   ├── marketingConsent
        │   └── dataPrivacyStatus
        │
        ├─► 📅 IMPORTANT DATES
        │   ├── birthdate
        │   └── anniversaryDate
        │
        └─► 🔗 CROSS-MODULE LINKAGE
            ├── estimates[] → Estimate (crmContactId optional)
            ├── invoices[] → Invoice (crmContactId optional)
            └── projects[] → Project (crmContactId optional)

┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHILD RELATIONS (9 types)                                 │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► CRMAddress[] (addresses for this contact)
        ├─► CRMInteraction[] (touchpoints)
        ├─► CRMNote[] (notes)
        ├─► CRMActivity[] (tasks/events)
        ├─► CRMEmail[] (emails)
        ├─► CRMSMS[] (text messages)
        ├─► CRMPhoneCall[] (calls)
        ├─► CRMContactRole[] (roles in accounts)
        └─► CRMHouseholdMember[] (household membership)

┌─────────────────────────────────────────────────────────────────────────────┐
│                         INDEX STRATEGY (10 indexes)                          │
└─────────────────────────────────────────────────────────────────────────────┘

    🔑 PRIMARY CONSTRAINTS (2)
       ├── [tenantId, id]
       └── [tenantId, email] (email unique per tenant)

    📊 STATUS FILTERS (1)
       └── [tenantId, status]

    🔍 COMMON FILTERS (2)
       ├── [tenantId, primaryAccountId]
       └── [tenantId, lastName]

    ⏰ TEMPORAL (1 BRIN)
       └── [createdAt]

    📈 ANALYTICS & GOVERNANCE (2)
       ├── [tenantId, deletedAt]
       └── [tenantId, auditCorrelationId]
```

---

## 🏗️ MODULE 2: CRM COMMUNICATION (crmcommunication.prisma)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     CRMEmail (BH Pattern + Pattern A)                        │
│                     Multi-Channel Communication Hub                          │
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
        │               │     │ deletedAt     │   │              │
        └───────────────┘     └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           EMAIL DIMENSIONS                                   │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        ├─► 📧 EMAIL DETAILS
        │   ├── subject
        │   ├── bodyHtml (HTML version)
        │   └── bodyText (plain text version)
        │
        ├─► 📬 ADDRESSING
        │   ├── fromAddress
        │   ├── toAddresses[] (array)
        │   ├── ccAddresses[]
        │   └── bccAddresses[]
        │
        ├─► 📊 STATUS & TRACKING
        │   ├── status (DRAFT|SCHEDULED|SENT|DELIVERED|OPENED|CLICKED|BOUNCED)
        │   ├── sentAt, deliveredAt
        │   ├── openedAt, openCount
        │   └── clickedAt, clickCount
        │
        ├─► 🔗 PARENT LINKAGE
        │   ├── accountId → CRMAccount
        │   ├── contactId → CRMContact
        │   └── relatedToType/relatedToId (Estimate|Invoice|Project)
        │
        ├─► 💬 THREADING
        │   ├── threadId → CRMMessageThread
        │   └── inReplyToEmailId (for threading)
        │
        └─► 📎 ATTACHMENTS
            └── CRMEmailAttachment[]

┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATUS FLOW DIAGRAM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    DRAFT
      │
      ▼
    SCHEDULED (optional)
      │
      ▼
    SENT ──► sentAt
      │
      ▼
    DELIVERED ──► deliveredAt (webhook from provider)
      │
      ├──► OPENED ──► openedAt (tracking pixel)
      │      │
      │      └──► CLICKED ──► clickedAt (link tracking)
      │
      └──► BOUNCED ──► bouncedAt
            │
            └──► FAILED

┌─────────────────────────────────────────────────────────────────────────────┐
│                   COMMUNICATION MODELS OVERVIEW                              │
└─────────────────────────────────────────────────────────────────────────────┘

    📧 CRMEmail (BH Pattern)
       └── Email tracking with open/click rates

    📱 CRMSMS (BH Pattern)
       └── SMS message tracking with delivery status

    📞 CRMPhoneCall (BH Pattern)
       ├── Call logging with duration
       └── CRMPhoneCallRecording (Pattern A)
           ├── Recording storage
           ├── Transcription support
           └── Compliance tracking

    💬 CRMMessageThread (BH Pattern)
       ├── Conversation threading
       └── CRMMessageParticipant (Pattern A)
           └── Thread membership tracking

    📡 CRMChannel (Pattern A)
       └── Communication provider configuration

    🔔 CRMNotificationSetting (Pattern A)
       └── Member notification preferences

    📬 CRMNotificationEvent (Pattern A)
       └── Notification delivery tracking
```

---

## 🏗️ MODULE 3: CRM RELATIONSHIPS (crmrelationships.prisma)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      RELATIONSHIP MODELS OVERVIEW                            │
└─────────────────────────────────────────────────────────────────────────────┘

    🔗 CRMAccountRelationship (Pattern A)
       ├── fromAccountId → CRMAccount
       ├── toAccountId → CRMAccount
       ├── relationshipType (PARENT|SUBSIDIARY|PARTNER|COMPETITOR|VENDOR)
       └── strength (WEAK|MODERATE|STRONG)

    👔 CRMContactRole (Pattern A)
       ├── contactId → CRMContact
       ├── accountId → CRMAccount
       ├── roleType (PRIMARY|BILLING|TECHNICAL|DECISION_MAKER)
       └── isPrimary

    🏢 CRMAccountHierarchy (Pattern A)
       ├── accountId → CRMAccount (child)
       ├── parentAccountId → CRMAccount (parent)
       ├── hierarchyLevel (1, 2, 3...)
       ├── hierarchyPath (nested sets)
       └── Rollup Metrics
           ├── rollupRevenue
           ├── rollupEmployeeCount
           └── rollupProjectCount

    🏠 CRMHousehold (Pattern A)
       ├── householdName
       ├── householdType (FAMILY|ROOMMATES|BUSINESS_PARTNERS)
       └── CRMHouseholdMember[]
           ├── contactId → CRMContact
           └── role (HEAD|SPOUSE|DEPENDENT)

    👨‍💼 CRMDecisionMaker (Pattern A)
       ├── contactId → CRMContact
       ├── accountId → CRMAccount
       ├── decisionAuthority (FULL|LIMITED|ADVISORY)
       ├── decisionScope (BUDGET|TECHNICAL|LEGAL)
       └── budgetAuthority ($ amount)

    📊 CRMInfluencer (Pattern A)
       ├── contactId → CRMContact
       ├── influencerType (INTERNAL|EXTERNAL|CONSULTANT)
       ├── influenceScore (1-10)
       └── networkSize

    🤝 CRMPartner (Pattern A)
       ├── accountId → CRMAccount
       ├── partnerType (REFERRAL|RESELLER|INTEGRATOR)
       ├── partnerTier (GOLD|SILVER|BRONZE)
       ├── commissionRate
       └── Performance Metrics
           ├── totalReferrals
           ├── totalRevenue
           └── lastDealDate

    📎 CRMRelationshipAttachment (Pattern A)
       └── Files for relationships (contracts, agreements)

    📜 CRMRelationshipHistoryEvent (Pattern A)
       └── Audit trail for relationships
```

---

## 🔄 CROSS-MODULE INTEGRATION

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CRM → REVENUE DOCUMENTS LINKAGE                           │
└─────────────────────────────────────────────────────────────────────────────┘

    CRMAccount (Parent - REQUIRED)
         │
         ├───► Estimate.crmAccountId (REQUIRED)
         │        │
         │        └───► Estimate.crmContactId (optional)
         │             Estimate.billToAddressId → CRMAddress
         │             Estimate.jobsiteAddressId → CRMAddress
         │
         ├───► Project.crmAccountId (inherited from Estimate)
         │        │
         │        └───► Project.crmContactId (inherited)
         │             Project.jobsiteAddressId → CRMAddress
         │
         └───► Invoice.crmAccountId (inherited from Estimate/Project)
                  │
                  └───► Invoice.crmContactId (inherited)
                        Invoice.billToAddressId → CRMAddress

┌─────────────────────────────────────────────────────────────────────────────┐
│                    COMMUNICATION → REVENUE DOCUMENTS                         │
└─────────────────────────────────────────────────────────────────────────────┘

    CRMEmail/CRMSMS/CRMPhoneCall
         │
         └───► relatedToType (ESTIMATE|INVOICE|PROJECT)
               relatedToId (document id)

    Example: "Estimate Sent" email
       CRMEmail {
         accountId: estimate.crmAccountId
         contactId: estimate.crmContactId
         relatedToType: "ESTIMATE"
         relatedToId: estimate.id
         subject: "Estimate: EST-2025-00123"
       }

┌─────────────────────────────────────────────────────────────────────────────┐
│                    INTERACTION → REVENUE DOCUMENTS                           │
└─────────────────────────────────────────────────────────────────────────────┘

    CRMInteraction
         │
         └───► relatedToType (ESTIMATE|INVOICE|PROJECT)
               relatedToId (document id)

    Example: "Deal Won" interaction
       CRMInteraction {
         interactionType: NOTE
         subject: "Deal Won! 🎉"
         accountId: estimate.crmAccountId
         relatedToType: "ESTIMATE"
         relatedToId: estimate.id
         sentiment: POSITIVE
       }
```

---

## 📊 PATTERN SUMMARY

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PATTERN DISTRIBUTION                                 │
└─────────────────────────────────────────────────────────────────────────────┘

    🔴 PATTERN B (Full Actor Relations) - CRITICAL ENTITIES (2)
       ├── CRMAccount
       └── CRMContact

    🟡 BH PATTERN (Base Hybrid - globalId enabled) (5)
       ├── CRMInteraction
       ├── CRMEmail
       ├── CRMSMS
       ├── CRMPhoneCall
       └── CRMMessageThread

    🟢 PATTERN A (Lightweight - IDs Only) (23)
       ├── CRMAddress
       ├── CRMInteractionAttachment
       ├── CRMNote
       ├── CRMTag
       ├── CRMAccountTag
       ├── CRMActivity
       ├── CRMHistoryEvent
       ├── CRMEmailAttachment
       ├── CRMPhoneCallRecording
       ├── CRMMessageParticipant
       ├── CRMChannel
       ├── CRMNotificationSetting
       ├── CRMNotificationEvent
       ├── CRMAccountRelationship
       ├── CRMContactRole
       ├── CRMAccountHierarchy
       ├── CRMHousehold
       ├── CRMHouseholdMember
       ├── CRMDecisionMaker
       ├── CRMInfluencer
       ├── CRMPartner
       ├── CRMRelationshipAttachment
       └── CRMRelationshipHistoryEvent
```

---

## 🎯 KEY INNOVATIONS

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         CRM KEY INNOVATIONS                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    ⭐ 360° CUSTOMER VIEW
       └── Complete history of all interactions
           ├── Emails with open/click tracking
           ├── SMS messages
           ├── Phone calls with recordings
           ├── Meetings and site visits
           └── All linked to revenue documents

    ⭐ MULTI-CHANNEL UNIFIED INBOX
       └── All communications in one place
           ├── CRMMessageThread groups related messages
           ├── EMAIL, SMS, PHONE, CHAT all tracked
           ├── CRMMessageParticipant tracks who's involved
           └── Real-time notifications

    ⭐ RELATIONSHIP INTELLIGENCE
       └── Map complex org structures
           ├── CRMAccountHierarchy (parent-subsidiary)
           ├── CRMDecisionMaker (who signs contracts)
           ├── CRMInfluencer (who influences decisions)
           ├── CRMContactRole (roles within accounts)
           └── CRMPartner (partner management)

    ⭐ GDPR COMPLIANCE BUILT-IN
       └── Privacy & consent tracking
           ├── CRMContact.gdprConsent
           ├── CRMContact.marketingConsent
           ├── doNotCall, doNotEmail, doNotText flags
           └── Right to be forgotten (soft delete + anonymize)

    ⭐ LEAD-TO-CASH LIFECYCLE
       └── Complete journey tracking
           ├── LEAD → PROSPECT → CUSTOMER → ACTIVE → FORMER
           ├── All interactions logged
           ├── Revenue metrics tracked
           └── Churn prevention with at-risk flagging

    ⭐ EMAIL ENGAGEMENT TRACKING
       └── Deep insights into client engagement
           ├── Open tracking (tracking pixel)
           ├── Click tracking (link analytics)
           ├── Bounce detection
           └── Multi-send campaigns
```

---

## 🎯 Conclusión Visual

Este diagrama muestra la **arquitectura completa** de los 3 módulos CRM:

1. ✅ **30 models total** (10 + 10 + 10) organizados en 3 módulos
2. ✅ **Pattern B** para CRMAccount y CRMContact (CRITICAL - full actor)
3. ✅ **BH Pattern** para communications (globalId for traceability)
4. ✅ **Pattern A** para todos los modelos de soporte (lightweight)
5. ✅ **Multi-channel** communication (Email, SMS, Phone, Chat)
6. ✅ **Relationship intelligence** (Decision makers, influencers, hierarchies)
7. ✅ **GDPR compliant** con consent tracking
8. ✅ **360° view** con complete interaction history
9. ✅ **Cross-module integration** con Estimate, Invoice, Project
10. ✅ **Lead-to-cash** lifecycle management

**PRODUCTION-READY** para implementación inmediata.

---

**Preparado por**: Claude (Anthropic)  
**Fecha**: 2025-11-17  
**Versión**: 1.0
