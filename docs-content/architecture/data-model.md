# Data Model

OpsDeck uses SQLAlchemy as its ORM with PostgreSQL as the sole supported database. The data model is organized into domain-specific model files with shared patterns for cross-cutting concerns.

## Overview

The full schema has 80+ tables across 27 model files. Rather than one monolithic diagram, the relationships are documented below by domain.

---

## Assets & hardware

Tracks hardware lifecycle from procurement to disposal, with assignment history, maintenance, and peripherals.

```mermaid
erDiagram
    Asset ||--o{ AssetAssignment : "assigned via"
    Asset ||--o{ AssetHistory : "tracks changes"
    Asset ||--o{ MaintenanceLog : "maintained"
    Asset ||--o| DisposalRecord : "disposed"
    Asset ||--o{ Peripheral : "has peripherals"
    Asset }o--o| Location : "located at"
    Asset }o--o| User : "assigned to"
    Asset }o--o| Supplier : "purchased from"
    Asset }o--o| Purchase : "bought via"

    Peripheral ||--o{ PeripheralAssignment : "assigned via"
    Peripheral }o--o| User : "assigned to"
    Peripheral }o--o| Supplier : "purchased from"
    Peripheral }o--o| Asset : "attached to"

    AssetAssignment }o--|| User : "checked out to"

    DisposalRecord ||--o{ DisposalHistory : "status changes"

    Asset {
        int id PK
        string name
        string model
        string serial_number
        string status
        string internal_id
        date purchase_date
        float cost
        int warranty_length
        boolean is_critical
        boolean is_virtual
        int user_id FK
        int location_id FK
        int supplier_id FK
        int purchase_id FK
    }

    Location {
        int id PK
        string name
        string address
        string city
        string country
        string timezone
    }

    AssetAssignment {
        int id PK
        int asset_id FK
        int user_id FK
        datetime checked_out_date
        datetime checked_in_date
    }

    MaintenanceLog {
        int id PK
        int asset_id FK
        text issue
        text resolution
        float cost
    }

    DisposalRecord {
        int id PK
        int asset_id FK
        string method
        date disposal_date
    }
```

---

## Compliance & frameworks

The core governance engine: frameworks define requirements, controls define individual rules, and compliance links connect evidence from any entity to any control.

```mermaid
erDiagram
    Framework ||--o{ FrameworkControl : "defines"
    FrameworkControl ||--o{ ComplianceLink : "evidenced by"
    FrameworkControl ||--o{ ComplianceRule : "has rules"
    FrameworkControl }o--o{ FrameworkControl : "mapped targets"

    ComplianceLink {
        int id PK
        int framework_control_id FK
        int linkable_id
        string linkable_type
        text description
    }

    Framework {
        int id PK
        string name
        text description
        boolean is_custom
        boolean is_active
    }

    FrameworkControl {
        int id PK
        int framework_id FK
        string control_id
        string name
        text description
        boolean is_applicable
        text soa_justification
    }

    ComplianceRule {
        int id PK
        int framework_control_id FK
        string rule_type
        text condition
    }
```

!!! note "Polymorphic linking"
    `ComplianceLink.linkable_type` stores the entity class name (Asset, Policy, Supplier, etc.) and `linkable_id` stores its primary key. This avoids a separate junction table per entity type.

---

## Audits

Point-in-time compliance snapshots with immutable evidence for auditors.

```mermaid
erDiagram
    ComplianceAudit ||--o{ AuditControlItem : "contains"
    ComplianceAudit }o--o| Framework : "for framework"
    ComplianceAudit }o--o| Contact : "external auditor"
    ComplianceAudit }o--o| User : "internal lead"
    ComplianceAudit }o--o{ User : "participants"

    AuditControlItem ||--o{ AuditControlLink : "evidence"
    AuditControlItem }o--o| FrameworkControl : "snapshot of"

    ComplianceAudit {
        int id PK
        string name
        string status
        boolean is_locked
        datetime locked_at
        int framework_id FK
        int auditor_id FK
        int internal_lead_id FK
    }

    AuditControlItem {
        int id PK
        int audit_id FK
        int original_control_id FK
        string control_ref
        string status
        text notes
    }

    AuditControlLink {
        int id PK
        int audit_item_id FK
        int linkable_id
        string linkable_type
        text description
    }
```

---

## User access reviews (UAR)

Automated comparison engine for detecting access discrepancies between systems.

```mermaid
erDiagram
    UARComparison ||--o{ UARExecution : "executed as"
    UARExecution ||--o{ UARFinding : "produces"

    UARComparison {
        int id PK
        string name
        string source_a_type
        json source_a_config
        string source_b_type
        json source_b_config
        string key_field_a
        string key_field_b
        json field_mappings
        string schedule_type
        json schedule_config
        boolean auto_create_incidents
    }

    UARExecution {
        int id PK
        int comparison_id FK
        string status
        datetime started_at
        datetime completed_at
        json source_a_snapshot
        json source_b_snapshot
        int findings_count
        int left_only_count
    }

    UARFinding {
        int id PK
        int execution_id FK
        string finding_type
        string severity
        string status
        string key_value
        json dataset_a_record
        json dataset_b_record
        json field_diffs
    }
```

---

## Risk & security

Risk register, security incidents with timeline tracking, and post-incident reviews.

```mermaid
erDiagram
    Risk ||--o{ RiskHistory : "tracked over"
    Risk ||--o{ RiskAffectedItem : "affects"
    Risk ||--o{ RiskReference : "references"
    Risk }o--o| User : "owned by"
    Risk }o--o| ThreatType : "categorized as"
    Risk }o--o{ RiskCategory : "in categories"
    Risk }o--o{ SecurityActivity : "mitigated by"

    SecurityIncident ||--o| PostIncidentReview : "reviewed in"
    SecurityIncident }o--o{ Asset : "affects assets"
    SecurityIncident }o--o{ User : "affects users"
    SecurityIncident }o--o{ Subscription : "affects subscriptions"
    SecurityIncident }o--o{ Supplier : "affects suppliers"

    PostIncidentReview ||--o{ IncidentTimelineEvent : "timeline"

    Risk {
        int id PK
        text risk_description
        string status
        string treatment_strategy
        int inherent_impact
        int inherent_likelihood
        int residual_impact
        int residual_likelihood
        text mitigation_plan
        int owner_id FK
    }

    SecurityIncident {
        int id PK
        string title
        text description
        string status
        string severity
        string impact
        boolean data_breach
        int reported_by_id FK
        int owner_id FK
        int assignee_id FK
    }

    PostIncidentReview {
        int id PK
        int incident_id FK
        text summary
        text root_cause
        text lessons_learned
        boolean is_locked
    }

    IncidentTimelineEvent {
        int id PK
        int review_id FK
        datetime event_time
        text description
        int order
    }
```

---

## Procurement & vendors

Supplier management, contracts, subscriptions, purchases, and budgets.

```mermaid
erDiagram
    Supplier ||--o{ Contact : "has contacts"
    Supplier ||--o{ Subscription : "provides"
    Supplier ||--o{ Purchase : "sold"
    Supplier ||--o{ Asset : "supplied"
    Supplier ||--o{ SecurityAssessment : "assessed via"

    Contract ||--o{ ContractItem : "line items"
    Contract }o--o| Supplier : "with supplier"

    Subscription }o--o{ User : "used by"
    Subscription }o--o{ PaymentMethod : "paid via"
    Subscription }o--o{ Contact : "managed by"

    Purchase }o--o| Supplier : "from"
    Purchase }o--o| Budget : "charged to"
    Purchase }o--o| PaymentMethod : "paid via"
    Purchase ||--o{ PurchaseCostHistory : "cost changes"

    Budget {
        int id PK
        string name
        float amount
        date start_date
        date end_date
    }

    Supplier {
        int id PK
        string name
        string compliance_status
        boolean is_critical
        date gdpr_dpa_signed
        string data_storage_region
    }

    Subscription {
        int id PK
        string name
        float cost
        string billing_cycle
        date renewal_date
        int supplier_id FK
    }

    Purchase {
        int id PK
        string description
        string invoice_number
        date purchase_date
        float validated_cost
        int supplier_id FK
        int budget_id FK
    }

    Contract {
        int id PK
        string name
        date start_date
        date end_date
        float value
        int supplier_id FK
    }
```

---

## Service catalog

Business services mapped to technical components with typed dependency tracking.

```mermaid
erDiagram
    BusinessService ||--o{ ServiceComponent : "composed of"
    BusinessService ||--o{ ServiceDependency : "parent of"
    BusinessService ||--o{ ServiceDependency : "child of"
    BusinessService }o--o| User : "owned by"
    BusinessService }o--o| CostCenter : "funded by"
    BusinessService }o--o{ User : "used by"
    BusinessService }o--o{ Documentation : "documented in"
    BusinessService }o--o{ Policy : "governed by"
    BusinessService }o--o{ SecurityActivity : "protected by"

    BusinessService {
        int id PK
        string name
        string category
        string criticality
        string status
        int sla_response_hours
        int sla_resolution_hours
        int owner_id FK
        int cost_center_id FK
    }

    ServiceDependency {
        int parent_id PK_FK
        int child_id PK_FK
        enum label "nullable"
    }

    ServiceComponent {
        int id PK
        int service_id FK
        string component_type
        int component_id
        string role
    }
```

The `ServiceDependency` association model connects services with an optional typed label from a controlled vocabulary: `hosts`, `authenticates`, `provides_access`, `stores_data`, `processes_data`, `monitors`, `backs_up`, `routes_traffic`, `calls_api`, `sends_data`. Existing dependencies without a label continue to work normally.

---

## People & authentication

Users, groups, RBAC permissions, org chart, and known IP tracking.

```mermaid
erDiagram
    User }o--o{ Group : "member of"
    User }o--o| User : "reports to (manager)"
    User ||--o{ Permission : "has direct"
    User ||--o{ UserKnownIP : "logged from"
    User ||--o{ PolicyAcknowledgement : "acknowledges"
    User ||--o{ CourseAssignment : "assigned training"
    User ||--o{ AssetAssignment : "uses assets"

    Group ||--o{ Permission : "grants"

    Permission }o--|| Module : "on module"

    User {
        int id PK
        string name
        string email
        string role
        int manager_id FK
        int buddy_id FK
    }

    Group {
        int id PK
        string name
    }

    Permission {
        int id PK
        int user_id FK
        int group_id FK
        int module_id FK
        enum access_level
    }

    Module {
        int id PK
        string name
        string slug
    }
```

---

## Policies, training & onboarding

Governance workflows: policy acknowledgment, training tracking, and employee lifecycle.

```mermaid
erDiagram
    Policy ||--o{ PolicyVersion : "versioned"
    Policy ||--o{ PolicyAcknowledgement : "acknowledged via"

    Course ||--o{ CourseAssignment : "assigned as"
    CourseAssignment ||--o| CourseCompletion : "completed"

    OnboardingPack ||--o{ PackItem : "contains"
    ProcessTemplate ||--o{ ProcessItem : "defines steps"
    OnboardingProcess ||--o{ ProcessItem : "checklist"

    Policy {
        int id PK
        string title
        date effective_date
        date review_date
    }

    PolicyVersion {
        int id PK
        int policy_id FK
        int version_number
        text content
    }

    PolicyAcknowledgement {
        int id PK
        int policy_id FK
        int user_id FK
        datetime acknowledged_at
    }

    Course {
        int id PK
        string title
        string content_type
        int duration_hours
    }

    CourseAssignment {
        int id PK
        int course_id FK
        int user_id FK
        date due_date
    }
```

---

## Cross-cutting patterns

### Polymorphic linking

Both `ComplianceLink` and `Link` use a `linkable_type` + `linkable_id` pattern to connect any entity to compliance controls or to other entities without per-type junction tables. `RiskAffectedItem` and `RiskReference` follow the same pattern.

### CustomPropertiesMixin

Models that include this mixin (`Asset`, `User`, `Peripheral`) support arbitrary custom fields:

```mermaid
erDiagram
    CustomFieldDefinition ||--o{ CustomFieldValue : "instantiated as"
    CustomFieldValue }o--|| Asset : "on entity"

    CustomFieldDefinition {
        int id PK
        string name
        string field_type
        string applies_to
    }

    CustomFieldValue {
        int id PK
        int field_definition_id FK
        int entity_id
        string entity_type
        text value
    }
```

### Audit logging

Every mutation generates an `AuditLog` record via the SQLAlchemy event listener:

| Column | Content |
|---|---|
| `user_id` | Who made the change |
| `action` | INSERT / UPDATE / DELETE |
| `table_name` | Affected table |
| `record_id` | Affected record |
| `timestamp` | UTC timestamp |
| `changes` | JSON diff (DeepDiff output) |

### Soft deletes and history

Most entities use `is_archived` flags rather than physical deletion. History tables (`AssetHistory`, `RiskHistory`, `CostHistory`, `DisposalHistory`) capture point-in-time snapshots for trending and timeline visualization.
