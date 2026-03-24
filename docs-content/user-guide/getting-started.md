# Getting Started

This guide walks you through your first steps after deploying OpsDeck — from logging in to understanding the core navigation and setting up your organization.

## First login

After deployment, open your OpsDeck instance and log in with the admin credentials configured during installation:

- **Default email:** `admin@example.com`
- **Default password:** `admin123`

You'll be prompted to change the default password immediately. If Google OAuth is configured, you can also use "Sign in with Google."

## Navigation overview

OpsDeck's interface is organized around a left sidebar with these main sections:

| Section | What you'll find |
|---|---|
| **Dashboard** | Compliance summary, upcoming renewals, recent activity |
| **Assets** | Hardware, peripherals, software, locations, maintenance |
| **Compliance** | Frameworks, controls, audits, compliance drift, UAR |
| **Security** | Risk register, incidents, security activities, credentials |
| **Vendors** | Suppliers, contracts, subscriptions, purchases, budgets |
| **People** | Users, groups, onboarding/offboarding, hiring, training |
| **Services** | Service catalog, dependency mapping |
| **Reports** | Built-in reports, universal search |
| **Administration** | Configuration, policies, locations, cost centers |

The top bar provides universal search (magnifying glass icon) and quick access to notifications and your user profile.

## Core concepts

Before diving in, understand these concepts that appear throughout OpsDeck:

**Compliance links.** Any entity (asset, policy, service, supplier) can be linked to a framework control as evidence. This is the backbone of compliance management — link evidence continuously, not just during audits.

**Tags.** Flexible labels that can be attached to most entities for custom categorization and filtering.

**Custom properties.** Assets, users, and peripherals support custom fields defined at the organization level (Administration → Configuration).

**Audit trail.** Every creation, update, and deletion is logged with the user, timestamp, and changed fields. This trail is immutable and cannot be deleted from the UI.

## Initial configuration checklist

Complete these steps to set up your organization:

### 1. Organization settings

Navigate to **Administration → Configuration** and set:

- Organization name and logo.
- Default timezone and date format.
- Notification preferences (email, Slack webhook).

### 2. Locations

Navigate to **Administration → Locations** and create your physical and logical locations:

- Office sites (HQ, branches, data centers).
- Remote locations if tracking remote worker assets.
- Locations support hierarchy (building → floor → room).

### 3. Cost centers

Navigate to **Administration → Cost Centers** and create departments or budget centers:

- Used for asset assignment, budget allocation, and reporting.
- Map to your organization's financial structure.

### 4. Users and groups

Navigate to **People → Users** and create your team:

1. Click "Add User" — provide name, email, and role (Admin/Manager/User).
2. Create **Groups** for department-based permission assignment.
3. If using Google OAuth, users can log in immediately with their Google email.

### 5. Compliance frameworks

Navigate to **Compliance → Frameworks** to set up your compliance requirements:

1. Create or import a framework (ISO 27001, SOC 2, or custom).
2. Review the controls — each one represents a requirement you need evidence for.
3. Start linking existing assets, policies, and services to controls.

### 6. Suppliers

Navigate to **Vendors → Suppliers** and register your key vendors:

1. Add supplier details, compliance status, and contacts.
2. Link contracts and subscriptions.
3. Set up renewal tracking.

## What's next

With the basics configured, explore these workflows:

- **[Hardware Assets](assets.md)** — start tracking your asset inventory.
- **[Compliance Dashboard](compliance.md)** — understand your compliance posture.
- **[User Access Reviews](uar.md)** — automate access governance.
- **[Data Import (CLI)](data-import.md)** — bulk import existing data from CSV.
