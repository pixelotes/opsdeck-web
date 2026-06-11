# Event Rules

<!-- TODO: screenshot of the Event Rules list with the create/edit modal open -->

Event rules turn everyday data changes into notifications. Whenever a record is
created, updated, or deleted, a matching rule fires a message through your chosen
delivery channels — without writing any code.

- **Menu path**: **Settings → Event Rules**
- **URL**: `/settings/event-rules`
- **Permission**: requires the `settings` module (write access to create, edit, toggle, or delete rules).

## How it works

OpsDeck already records every create, update, and delete in the [Audit Log](audit-log.md).
The event engine reuses that trail as its source of truth:

1. A background job reads recently changed records from the audit log every couple of minutes.
2. For each change it checks your enabled rules. A rule matches when the **entity** and the **action** line up.
3. Each matching rule queues a notification, which the [communications queue](../architecture/scheduler.md) then delivers on its next run.
4. Each audit entry is marked as processed, so you are never notified twice for the same change.

!!! note "Delivery is near-real-time, not instant"
    Because the engine polls the audit log and then hands off to the communications
    queue, expect a delay of a few minutes between the change and the notification.
    Existing history is **not** replayed: only changes made after a rule is created
    will trigger it.

## Creating a rule

Click **New Rule** and fill in:

| Field | What it does |
|---|---|
| **Name** / **Description** | Labels for the rule (shown in the list). |
| **Entity** | The kind of record to watch — Asset, Subscription, Risk, Incident, Credential, Certificate, Supplier, Contract, Change, Request, Candidate, Policy, Compliance Rule, License, Peripheral. |
| **Action** | `create`, `update`, `delete`, or `any` (matches all three). |
| **Email Template** | The message to send. Templates are managed under **Communications**. |
| **Send to** | Who receives it (see below). |
| **Delivery Channels** | One or more of Email, Slack, Webhook, Discord (see [Configuration → Notifications](configuration.md#notification-settings)). |

### Recipients

In this version recipients are **static**:

- **All admins** — every user with the admin role.
- **A role** — all users with the chosen role.
- **Specific email addresses** — a comma-separated list you type in.

### Channels and destinations

Channel selection mirrors the system notifications screen. Each rule carries its
own destination settings, so different rules can post to different places:

- **Slack** — optional fixed channel ID, or a DM to the recipient (requires `SLACK_BOT_TOKEN`).
- **Webhook** — an HTTP endpoint that receives a JSON payload.
- **Discord** — a Discord incoming-webhook URL (`https://discord.com/api/webhooks/...`).

### Template variables

Event-rule templates receive a generic context describing the change:

| Variable | Example | Meaning |
|---|---|---|
| `entity` | `Laptop-014` | Human-readable name of the record |
| `entity_type` | `Asset` | The kind of record |
| `entity_id` | `42` | Database ID |
| `action` | `update` | What happened |
| `actor` | `alice@acme.com` | Who made the change (or *system*) |
| `changes` | `{"status": {"old": "active", "new": "retired"}}` | Field-by-field diff (updates only) |
| `timestamp` | `2026-06-11 09:14` | When the change happened |

Example subject and body:

```
Subject:  {{ entity_type }} {{ entity }} was {{ action }}d
Body:     {{ actor }} {{ action }}d {{ entity }}.
```

### Ready-made templates

OpsDeck ships three generic, ready-to-use templates you can attach to a rule
straight away — **Event: Record Created**, **Event: Record Updated**, and
**Event: Record Deleted**. The "Updated" one renders the field-by-field diff
automatically. Use them as-is or copy one as the starting point for your own.

!!! note "Best practice: guard your variables with `{% if %}`"
    Templates can be reused across different events, but not every variable exists
    in every context — for example `changes` is only present on updates, and the
    onboarding-style `{{ user.name }}` is not part of the event context at all.
    Always wrap optional variables in a conditional so the message stays clean:

    ```jinja
    {% if changes %}
      Fields changed:
      {% for field, vals in changes.items() %}
        - {{ field }}: {{ vals.old }} → {{ vals.new }}
      {% endfor %}
    {% else %}
      (no field details)
    {% endif %}
    ```

    Guard at the variable itself (`{% if user %}{{ user.name }}{% endif %}`), not
    inside it (`{% if user.name %}` would still fail when `user` is absent). As a
    safety net, a missing variable now renders as **empty** rather than leaking the
    raw `{{ ... }}` into the notification — but an explicit `{% if %}` keeps the
    wording right.

## Managing rules

From the list you can **enable/disable** a rule (the toggle), **edit** it, or
**delete** it. Disabled rules are skipped by the engine but kept for later.

## Event rules vs. system notifications

These two screens are complementary:

- **[Settings → Notifications](configuration.md#notification-settings)** handles built-in *time-based* alerts — "renews in 7 days", "certificate expiring". These need date math, not a single record change.
- **Settings → Event Rules** handles *change-based* alerts — "an asset was created", "a risk was deleted".

Both deliver through the same channels and the same queue.
