# Vendor Compliance

<!-- TODO: screenshot of the Vendor Compliance overview with the assessments history -->

Vendor Compliance gives a single view of how your suppliers stack up against your security and regulatory requirements, and keeps a history of every security assessment performed.

- **Menu path**: **Compliance → Vendor Compliance**
- **URL**: `/compliance/vendor-compliance`

## Vendor compliance overview

The overview lists every supplier with its compliance posture:

| Column | Description |
|---|---|
| **Supplier** | The vendor |
| **Compliance status** | Approved, Pending Review, Rejected, or Not Assessed |
| **Critical** | Whether the supplier is flagged as [critical](suppliers.md#critical-suppliers) |
| **Last assessment** | Date of the most recent security assessment |

This replaces the older per-supplier GDPR/assessment date columns with a posture-focused view.

## Assessments history

From the overview, the **Assessments History** button opens the full log of security assessments across all suppliers, ordered most-recent first. Each entry records the supplier, the assessment date, and its outcome (Approved / Rejected / Pending).

Keeping assessments as a dated history — rather than a single "last assessed" field — provides the audit evidence reviewers expect for supplier-management controls (for example ISO 27001 A.15).

See [Suppliers](suppliers.md) for managing the vendors themselves.
