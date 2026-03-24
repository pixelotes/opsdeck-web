# Configuration

Manage organization-wide settings, custom fields, notification preferences, and taxonomy.

## Organization settings

Navigate to **Administration → Configuration**:

- Organization name and logo.
- Default timezone and date format.
- Currency settings for financial modules.
- Notification preferences (global email and webhook settings).

Settings are stored in the `OrganizationSettings` model and cached for performance.

## Custom fields

Define additional fields for assets, users, and peripherals:

1. Navigate to **Administration → Configuration → Custom Fields**.
2. Click **Add Custom Field**.
3. Provide: field name, data type (text, number, date, select), and target entity types.
4. The field appears on all forms and detail pages for the selected entity types.
5. Custom field values are searchable via universal search.

## Tags

Tags provide flexible, cross-entity categorization:

- Create tags in **Administration → Tags**.
- Apply tags to any entity that supports them.
- Filter lists and reports by tag.

## Notification settings

Configure per-event notification preferences:

- Which events trigger notifications (asset assignment, incident creation, renewal approaching).
- Notification channels: email (via SMTP) and/or webhook (Slack, Discord).
- Per-user notification preferences can override global settings.

## Configuration versioning

The `ConfigurationVersion` model tracks changes to system configuration over time, providing an audit trail of who changed what settings and when.
