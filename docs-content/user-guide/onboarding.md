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

## Offboarding

The offboarding workflow mirrors onboarding in reverse:

1. Create an `OffboardingProcess` for the departing user.
2. Checklist items include: revoke access, collect hardware, update asset assignments, remove from groups.
3. Track completion to ensure nothing is missed.

## Pack communications

Onboarding packs can trigger communications:

- Welcome emails with account details.
- Scheduled reminders for incomplete items.
- Manager notifications when the process is complete.
