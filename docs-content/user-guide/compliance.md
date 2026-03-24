# Compliance Dashboard

The compliance dashboard provides a real-time view of your organization's compliance posture across all configured frameworks, with control-level status tracking and evidence coverage metrics.

## Compliance score

The dashboard displays an overall compliance score per framework, calculated as the percentage of controls that have at least one evidence link (compliance link) attached. Controls are categorized by status:

| Status | Meaning |
|---|---|
| **Compliant** | Control has sufficient evidence linked and is marked as satisfied |
| **Manual** | Control requires manual verification — evidence exists but needs review |
| **Warning** | Control has partial evidence or evidence is outdated |
| **Non-compliant** | Control has no evidence or has been explicitly marked as non-compliant |
| **Uncovered** | Control has not been addressed yet — no links, no status |

## Control status breakdown

Each framework page shows all controls grouped by category or section, with:

- Status badge per control.
- Count of linked evidence items.
- Last review date.
- Assigned owner (if set).

Click any control to see its detail page with the full list of compliance links — the assets, policies, services, suppliers, and activities linked as evidence.

## Evidence linking

Evidence is linked to controls via the **Compliance Link** mechanism, which is available from two directions:

**From the control.** On the control detail page, click "Link Evidence" and search for the entity to link.

**From any entity.** On any asset, policy, service, or supplier detail page, scroll to "Compliance Links" and select the control to link to. Add context notes explaining how this entity satisfies the requirement.

!!! tip
    Link evidence continuously as part of daily operations, not just during audit preparation. This builds a living evidence repository that makes audit snapshots comprehensive from day one.

## Filtering by framework

If multiple frameworks are configured (e.g., ISO 27001 and SOC 2), the dashboard supports:

- Switching between frameworks via tabs.
- Cross-framework view showing controls that map to multiple standards.
- Filtering by status, category, or assigned owner.

## Relationship to other modules

The compliance dashboard aggregates data from across OpsDeck:

- **Audit snapshots** — frozen compliance state at a point in time. See [Audit Snapshots](audits.md).
- **Compliance drift** — automatic detection of status regressions. See [Compliance Drift](compliance-drift.md).
- **UAR findings** — unresolved access findings can impact compliance status. See [User Access Reviews](uar.md).
- **Risk register** — risks can be linked to controls they threaten. See [Risk Register](risk.md).
