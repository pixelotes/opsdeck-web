# Audit Log

<!-- TODO: screenshot of the audit log table with the change-detail modal open -->

The audit log records a comprehensive, tamper-evident trail of changes to data in OpsDeck. It answers *who changed what, when, and from where* across every module.

- **Menu path**: **Administration → Audit Log**
- **URL**: `/audit-log`
- **Permission**: requires read access to the `administration` module. The log is view-only — no one can edit or delete entries from the UI.

## What is captured

Changes are captured automatically at the database layer, so every create, update, and delete is recorded without each module having to opt in. Each entry stores:

| Field | Description |
|---|---|
| **Timestamp** | When the change happened (timezone-aware) |
| **Action** | Create, Update, or Delete |
| **User** | The signed-in user who made the change (or *System* for automated jobs) |
| **Entity type** | The kind of record affected (User, Asset, Subscription, …) |
| **Entity** | A human-readable name plus the record ID |
| **IP address** | The source IP of the request |
| **Details** | For updates, a field-by-field diff of old vs. new values |

In addition to data changes, security-relevant events — logins (including OAuth), MFA challenges, impersonation, token generation, password changes, and user role changes — are recorded in the structured application logs.

!!! warning "Sensitive values are never stored"
    Password hashes, secrets, tokens, API keys, and encrypted values are excluded from the change diff. Bookkeeping fields like `created_at`/`updated_at` are also omitted to keep the diff readable.

!!! tip "The audit log also powers Event Rules"
    The same change trail is the source for the event engine. Configure
    [Event Rules](event-rules.md) to send a notification whenever a chosen kind of
    record is created, updated, or deleted.

## Reviewing the log

The log is a paginated table ordered newest-first. Click the **details** (eye) icon on any update to open a modal showing the exact fields that changed and their before/after values.

Filter the view by:

- **Entity type** — narrow to one kind of record.
- **Action** — create, update, or delete.
- **User** — everything done by a specific person.
- **Date range** — from/to dates (inclusive).
- **Search** — free-text match against the entity name.

You can also adjust the page size. The current view can be exported to **CSV** for offline analysis or evidence collection.

!!! note "Retention"
    OpsDeck does not purge audit records automatically — they accumulate indefinitely. If you need a retention policy, archive or prune the `audit_log` table at the database level.
