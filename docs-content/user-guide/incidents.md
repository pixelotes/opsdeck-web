# Security Incidents

<!-- TODO: screenshot of an incident detail page with timeline events -->

The incident management module tracks security events from initial report through investigation, resolution, and post-incident review.

## Reporting an incident

1. Navigate to **Security → Incidents**.
2. Click **Report Incident**.
3. Provide:
    - **Title** and **description** — what happened.
    - **Severity** — Critical, High, Medium, Low.
    - **Affected systems** — link assets, services, or users impacted.
    - **Assignee** — the person responsible for investigation.

## Incident statuses

Incidents progress through **Investigating → Contained → Resolved → Closed**. The incident list has a **status** dropdown to filter to a single status; the active filter is reflected in the URL and the dropdown label, so it can be bookmarked or shared.

## Incident timeline

Every incident has a timeline (`IncidentTimelineEvent`) that tracks the investigation:

- Add timeline entries as the investigation progresses.
- Each entry records the action taken, who took it, and when.
- The timeline provides a chronological audit trail of the response.

## Post-incident review

After resolution:

1. Click **Create Post-Incident Review** on the incident detail page.
2. Document root cause, contributing factors, and lessons learned.
3. Link follow-up actions: new risks, policy updates, configuration changes.
4. The `PostIncidentReview` record is permanently linked to the incident.

## Linking incidents

Incidents can be linked to:

- **Risks** — an incident may validate a previously identified risk or create a new one.
- **Compliance controls** — incident response demonstrates control effectiveness.
- **Assets and services** — affected infrastructure.
- **UAR findings** — an access-related incident may originate from a UAR finding.
