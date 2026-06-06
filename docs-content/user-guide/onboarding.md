# Onboarding & Offboarding

<!-- TODO: screenshot of an onboarding checklist in progress -->

Manage employee onboarding and offboarding with templated checklists, pack communications, and progress tracking.

## Onboarding packs

An onboarding pack defines the standard set of items needed for a new hire:

1. Navigate to **People → Onboarding**.
2. Click **Create Pack**.
3. Add **pack items** — tasks to complete (provision laptop, create accounts, assign training, etc.).
4. Each item can be assigned to a responsible person.

## Process templates

Templates allow reuse across multiple onboarding processes:

1. Create a `ProcessTemplate` with standard items.
2. When onboarding a new hire, instantiate the template to create a `ProcessItem` checklist.
3. Items are checked off as they're completed, with timestamp and responsible user recorded.

## Process notes

Both onboarding and offboarding processes have a free-text **notes** field for context that doesn't fit a checklist item — special instructions, exceptions, or handover details. Edit it from the **Details** card on the process page; line breaks are preserved, and the notes appear on the process detail view.

## Offboarding

The offboarding workflow mirrors onboarding in reverse:

1. Create an `OffboardingProcess` for the departing user.
2. Checklist items include: revoke access, collect hardware, update asset assignments, remove from groups.
3. Track completion to ensure nothing is missed.

### Closing an offboarding

You can close an offboarding with **Complete Process** even when items remain unchecked — useful when some steps don't apply or are handled outside OpsDeck. If items are still pending, a confirmation dialog reports how many before you proceed. Closing the process archives the user and sets their departure date to today.

## Pack communications

Onboarding packs can trigger communications:

- Welcome emails with account details.
- Scheduled reminders for incomplete items.
- Manager notifications when the process is complete.
