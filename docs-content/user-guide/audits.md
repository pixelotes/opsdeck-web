# Audit Snapshots

Audit snapshots capture the compliance state at a specific point in time, creating an immutable record for auditors. This is OpsDeck's "defense room" — the interface you present during an external audit.

## Audit creation strategies

OpsDeck supports two approaches when creating an audit:

| Strategy | When to use |
|---|---|
| **Fresh start** | First-time audit, new framework, or a complete reassessment |
| **Renewal** | Subsequent audits that build on a previous audit's scope and evidence |

Renewal mode clones the previous audit's control items and evidence links, giving you a head start rather than rebuilding from scratch.

## Creating an audit

1. Navigate to **Compliance → Audits**.
2. Click **Create Audit**.
3. Choose the target framework.
4. Select **Fresh Start** or **Renewal** (and pick the source audit if renewing).
5. The system creates `AuditControlItem` records — frozen copies of each framework control with their current compliance status and linked evidence.

## Working with the audit

Once created, the audit provides:

- **Control list** — all controls in scope, grouped by framework section, with status badges.
- **Evidence links** — each control shows its linked evidence items (assets, policies, services, etc.) as they were at snapshot time.
- **Gap analysis** — controls without evidence are highlighted. Use this to identify gaps before the auditor reviews.
- **Notes** — add auditor notes, remediation plans, or context to any control item.

## Linking additional evidence

While the audit is unlocked, you can:

1. Navigate to a control item within the audit.
2. Click **Link Evidence**.
3. Search for and select additional entities to link.
4. Each new link is recorded as an `AuditControlLink` within the audit scope.

## Locking the audit

When the audit is complete:

1. Click **Lock Audit**.
2. This sets the audit to an immutable state — no further changes can be made.
3. The locked audit serves as a point-in-time record for auditors and regulators.

!!! warning
    Locking is irreversible. Ensure all evidence is linked and all gaps are documented before locking.

## Exporting for auditors

The audit export service generates a comprehensive evidence package:

- PDF report with all controls, their status, and linked evidence.
- Attachments referenced by evidence links.
- Summary statistics (compliant, non-compliant, gap counts).

Navigate to the audit detail page and click **Export** to generate the package.

## Audit cloning

For recurring audits (e.g., annual ISO 27001 surveillance), cloning saves significant effort:

1. Create a new audit with **Renewal** strategy.
2. Select the previous audit as the source.
3. All control items and evidence links are copied to the new audit.
4. Review the cloned data — update statuses, add new evidence, remove obsolete links.
5. Lock when ready.
