# Frequently Asked Questions

## General

**What is OpsDeck?**

OpsDeck is an integrated IT operations and governance platform that consolidates asset management, compliance, vendor management, risk management, and service catalog into a single self-hosted application. It's designed for IT teams in regulated environments who need operational rigor without enterprise complexity.

**Who is OpsDeck for?**

Mid-market IT teams (50–500 employees) in finance, healthcare, SaaS, and other regulated industries. It's particularly well-suited for organizations where a single person or small team manages IT operations, security, and compliance simultaneously.

**What compliance frameworks does OpsDeck support?**

OpsDeck ships with support for ISO 27001 and SOC 2, and supports custom frameworks. You can define any framework with any number of controls. The compliance linking system is framework-agnostic — any entity can be linked to any control as evidence.

## Licensing

**What license does OpsDeck use?**

Elastic License 2.0. You can use, modify, and self-host OpsDeck freely. The restriction is on offering it as a managed service (SaaS) to third parties.

**Can I use OpsDeck internally at my company?**

Yes, without restriction. The Elastic License only restricts offering OpsDeck as a managed service to others.

**Is OpsDeck open source?**

The source code is publicly available and modifiable, but the Elastic License is not OSI-approved. If your organization requires OSI-approved licenses, check with your legal team.

## Deployment

**What are the minimum requirements?**

Python 3.11+, PostgreSQL 15+, and approximately 1 GB of RAM for the application. For Docker deployments, Docker Engine 24+ and Docker Compose v2.

**Does OpsDeck support MySQL?**

PostgreSQL is the only officially supported database. The codebase uses PostgreSQL-specific features (JSON fields, advanced indexing). MySQL may work for basic functionality but is not tested.

**Can I run multiple instances for high availability?**

Yes, with external PostgreSQL and shared storage for attachments. Multiple application replicas can run behind a load balancer. Ensure `SECRET_KEY` is identical across all instances.

**Does OpsDeck need internet access?**

No. OpsDeck is fully self-contained and can run in air-gapped environments. The only external connections are optional: SMTP for email, Slack webhook for notifications, and Google OAuth for SSO.

## Features

**Can I import existing data?**

Yes. OpsDeck includes a CLI for bulk CSV import of users, assets, suppliers, and contacts. See the [Data Import](user-guide/data-import.md) guide.

**Does OpsDeck have an API?**

Yes. A REST API with bearer token authentication covers all major entities. Interactive documentation is available at `/swagger-ui` on your deployment. See [API Usage](user-guide/api.md).

**Can I customize the fields on assets and users?**

Yes. Custom properties (key-value custom fields) can be defined at the organization level and applied to assets, users, and peripherals. See [Configuration](user-guide/configuration.md).

**How does the credential vault work?**

Credentials are stored encrypted at rest using Fernet symmetric encryption (from the `cryptography` library). The encryption key is derived from your `SECRET_KEY`. Access to view secrets is controlled by RBAC permissions.

## Troubleshooting

**The application won't start — database connection error.**

Verify your `DATABASE_URL` environment variable. Ensure PostgreSQL is running and accessible. For Docker deployments, check that the `db` service is healthy before the `web` service starts (`depends_on` with `condition: service_healthy`).

**Migrations fail after upgrading.**

Run `flask db upgrade` manually to see detailed error output. If a migration fails midway, you may need to resolve the database state manually. Check the [Database Management](deployment/database.md) guide.

**I forgot the admin password.**

Use the CLI: `flask reset-password admin@example.com`. This resets the password and prompts for a new one on next login.

**Search returns no results.**

Universal search indexes entity names, descriptions, serial numbers, and notes. Ensure the entities you're looking for have searchable content in those fields. Custom field values are also indexed.
