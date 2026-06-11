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

Configure per-event notifications in **Settings → Notifications**. Each system
event (license expiring, subscription renewal, certificate expiring, compliance
breach, …) maps to an email template and a set of delivery channels. Queued
messages are delivered by the background dispatcher (every 5 minutes), with
exponential-backoff retries on failure.

For every event you can enable or disable it, pick the template, set the
days-before-event offset, and select one or more delivery channels:

| Channel | Destination | Notes |
|---------|-------------|-------|
| **Email** | Recipient address (via SMTP) | Default channel. Requires SMTP configured. |
| **Slack** | DM to the user (resolved by email) or a fixed channel ID | Requires `SLACK_BOT_TOKEN`. Set a channel ID (e.g. `C12345`) for broadcasts, or leave empty to DM the recipient. |
| **Webhook** | Generic HTTP endpoint | POST with a structured JSON payload (event code, timestamp, target, recipient). |
| **Discord** | Discord incoming webhook | POST `{"content": "..."}`; subject in bold, body as plain text (capped at Discord's 2000-character limit). |

### Discord

To deliver an event to Discord:

1. In Discord, open **Server Settings → Integrations → Webhooks → New Webhook**, choose the target channel, and **Copy Webhook URL** (`https://discord.com/api/webhooks/...`).
2. In OpsDeck, open **Settings → Notifications**, edit the event, tick the **Discord** channel, and paste the URL into **Discord Webhook URL**.
3. Save. The next time the event fires, the message is posted to that Discord channel.

Per-user notification preferences can override global settings.

These are the built-in, time-based events. To send notifications when a record is
created, updated, or deleted, use [Event Rules](event-rules.md) instead — they
share the same channels and delivery queue.

## Configuration versioning

The `ConfigurationVersion` model tracks changes to system configuration over time, providing an audit trail of who changed what settings and when.
