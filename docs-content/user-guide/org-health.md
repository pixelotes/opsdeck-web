# Organizational Health

<!-- TODO: screenshot of the Org Health dashboard showing the six bento cards -->

The Organizational Health dashboard is an executive, at-a-glance view of the organization's risk, compliance, and operational posture. It is designed for management reporting rather than day-to-day operations.

- **Menu path**: **Dashboards → Org Health**
- **URL**: `/org-health`
- **Permission**: requires read access to the `health_dashboard` module.

At the top, a **global status badge** summarizes overall posture:

| Status | When |
|---|---|
| **Critical** | One or more critical risks, or an active security incident |
| **Degraded** | More than two high-severity risks |
| **Operational** | Otherwise |

## The six cards

The dashboard is laid out as six bento cards. Each card surfaces real items and links straight through to the detailed module, so the figures stay consistent with the underlying dashboards.

### Organizational Risks

A health-score gauge (0–100) with a global risk badge (Acceptable / Elevated / Critical). The score starts at 100 and is reduced by open risks — most heavily by critical residual risks, then by high residual risks. Closed and accepted risks are excluded. A **View Risk Register** link opens the full register.

### Compliance Tasks

A prioritized, scrollable list of compliance obligations (expiring certificates, due security activities, upcoming audits, and similar), each tagged with a category badge and the days remaining. Summary counters show how many are critical, due within 30 days, and upcoming within 90 days. Items already due are flagged **Now**. Each row links to the relevant item.

### Upcoming Security Activities

Security activities due within the next 30 days, including overdue ones. Each shows its frequency (Annual / Quarterly / Monthly / Weekly / Daily), the last execution date (or *Never performed*), and the days remaining or overdue. Rows link to the activity detail.

### The Horizon (30-60-90)

A tabbed forward view of everything expiring or renewing within 90 days:

- **Fins** — payment methods expiring soon.
- **Creds** — credentials approaching expiry.
- **Certs** — certificate versions nearing expiry.
- **Renews** — subscriptions and licenses up for renewal, with cost.

Each item shows the days remaining with an urgency-colored progress bar.

### Operations Pulse

Four operational stats: renewals this month (projected spend), asset health percentage, assets under warranty, and active subscription count. A **View Full Ops Dashboard** link opens the operations & finance dashboard.

### Compliance Radar

Four compliance stats: overall compliance percentage, pending audits, controls at risk (warning + non-compliant), and uncovered controls. An expandable **Coverage by framework** section breaks the percentage down per framework. Figures come from the real-time compliance evaluator, so they match the [Compliance Dashboard](compliance.md). Controls marked *not applicable* (see [Frameworks & Controls](frameworks.md)) are excluded from the totals.

!!! note "Where the numbers come from"
    The cards reuse the same services as the detailed dashboards (risk register, finance, and the compliance evaluator). They do not recompute spend or compliance independently, so the headline figures always reconcile with the module-level views.
