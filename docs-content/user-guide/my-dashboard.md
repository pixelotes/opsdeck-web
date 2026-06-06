# My Dashboard

<!-- TODO: screenshot of the personal dashboard with the task timeline and resource tabs -->

My Dashboard is the personal, per-user landing view. Where the [main dashboard](dashboard.md) and [Org Health](org-health.md) summarize the whole organization, My Dashboard shows only what is assigned to or pending for the logged-in user.

- **Access**: user dropdown menu (top-right) → **My Dashboard**
- **URL**: `/my-dashboard`
- **Permission**: any logged-in user — no module permission required.

## Quick actions

A row of shortcut cards for the most common personal actions: report a security incident, request a change, jump to your pending tasks, and open your training courses (with a badge when courses are pending).

## Your stats

Four cards summarize your footprint:

- **Assigned equipment** — hardware assets plus peripherals assigned to you.
- **Courses** — completed vs. assigned, with a progress bar.
- **Active licenses** — software licenses assigned to you, with a warning when any expire soon.
- **Risks under your responsibility** — risks you own, highlighted when any are open.

## Pending tasks

A prioritized timeline of everything that needs your attention, sorted by urgency and deadline. Each task carries an urgency badge (Urgent / Soon / Pending) and a due indicator (*Due today*, *Due in X days*, *Overdue by X days*). Tasks include:

- **Policy acknowledgements** awaiting your sign-off.
- **Training courses** overdue or due within 30 days.
- **Credentials** assigned to you that expire within 30 days.

Each task links to the action needed. When nothing is pending, the timeline shows an "all done" empty state.

## My resources

A tabbed view of everything currently associated with you:

| Tab | Contents |
|---|---|
| **Equipment** | Assigned assets and peripherals, with warranty status |
| **Licenses** | Software licenses, with expiration status |
| **Services** | Business services you are linked to |
| **Subscriptions** | Subscriptions you are linked to, with renewal dates |
| **Risks** | Risks you own, with score, status, and treatment strategy |

!!! tip "Action-required alerts"
    The same pending items feed the notification bell in the navigation bar, so personal tasks surface even when you are working in another module.
