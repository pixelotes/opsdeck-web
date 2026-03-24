# Architecture Decision Records

This page documents the key architectural decisions made during OpsDeck's development, the context behind them, and the trade-offs accepted.

## ADR-001: Flask as web framework

**Context.** OpsDeck needed a Python web framework that supports rapid feature development, has a mature ecosystem, and doesn't impose unnecessary structure.

**Decision.** Flask was chosen over Django, FastAPI, and other alternatives.

**Rationale.**

- Flask's blueprint system maps cleanly to OpsDeck's modular structure (one blueprint per functional area).
- No ORM opinions — SQLAlchemy was chosen independently for its flexibility.
- Lightweight core with extensions for exactly what's needed (Flask-Login, Flask-WTF, flask-talisman, Flask-Limiter).
- Django's batteries-included approach would have imposed an admin interface, user model, and migration system that conflict with OpsDeck's custom requirements.
- FastAPI was considered but the project predates its maturity and OpsDeck's server-rendered templates don't benefit from async.

**Trade-offs.** More manual wiring than Django. No built-in admin panel. Extension quality varies.

---

## ADR-002: Monolithic architecture

**Context.** The application covers IT ops, compliance, procurement, CRM, and more — domains that could theoretically be separate services.

**Decision.** Ship as a single deployable monolith.

**Rationale.**

- Single operator (or very small team) — operational overhead of microservices is unjustifiable.
- Cross-domain queries (e.g., "show me all assets linked to this compliance control that belong to this vendor") are trivial with a shared database and impossible with service boundaries.
- Deployment is `docker-compose up` or a single Helm release. No service mesh, no API gateway, no distributed tracing required.
- The internal module structure (models/routes/services) provides logical separation without physical separation.

**Trade-offs.** All modules scale together. A bug in one area can affect others. The codebase must stay well-organized as it grows.

---

## ADR-003: Server-rendered templates over SPA

**Context.** Modern web apps often use React/Vue/Angular with a separate API backend.

**Decision.** Use Jinja2 server-side rendering with progressive enhancement via vanilla JavaScript.

**Rationale.**

- Eliminates an entire build toolchain (Webpack/Vite, Node.js CI, API versioning).
- Forms, tables, and CRUD operations — OpsDeck's primary UI patterns — are faster to build with server rendering.
- No API contract negotiation between frontend and backend teams (there is no frontend team).
- Bootstrap 5 provides responsive layout, DataTables handles sortable tables, Tom Select handles enhanced selects, Chart.js handles dashboards.
- The REST API exists for programmatic access and integrations, not for powering the UI.

**Trade-offs.** Less interactive than a SPA. Page transitions require full reloads (mitigated by fast server responses). Complex client-side interactions (e.g., drag-and-drop UAR configuration) require vanilla JS that could be cleaner in React.

---

## ADR-004: Elastic License

**Context.** OpsDeck needs to be open-source enough for transparency, self-hosting, and community contributions, but protected against cloud providers offering it as a managed service.

**Decision.** Elastic License 2.0.

**Rationale.**

- Allows free use, modification, and self-hosted deployment.
- Prevents third parties from offering OpsDeck as a managed SaaS without contributing back.
- Well-precedented — used by Elasticsearch, Kibana, and other infrastructure software.
- Simpler than AGPL for end users who just want to self-host.

**Trade-offs.** Not OSI-approved "open source." Some organizations' legal teams may require review. Cannot be included in Linux distributions that require OSI licenses.

---

## ADR-005: APScheduler over Celery

**Context.** OpsDeck needs background job scheduling for UAR execution, compliance drift snapshots, renewal notifications, and data retention.

**Decision.** APScheduler (in-process) instead of Celery with Redis/RabbitMQ.

**Rationale.**

- Zero additional infrastructure — no Redis, no RabbitMQ, no separate worker process.
- Jobs run within the Flask application context with full access to the database and configuration.
- Scheduled jobs (cron-style) are the primary use case, not high-throughput task queues.
- Job definitions live in Python code alongside the services they invoke, not in a separate configuration.

**Trade-offs.** Jobs run in the application process — a long-running job blocks that worker. No horizontal scaling of job execution. No built-in retry/dead-letter queue (manual error handling in each job).

---

## ADR-006: PostgreSQL as sole database

**Context.** The application needs a relational database. Multiple databases were considered.

**Decision.** PostgreSQL only. MySQL is not officially supported.

**Rationale.**

- Robust JSON support for storing custom properties and audit diffs.
- Advanced indexing (GIN, GiST) for full-text search without an external search engine.
- Mature ecosystem with excellent tooling (pg_dump, pg_restore, pgAdmin).
- Well-supported by all deployment targets (Docker, Kubernetes, RDS, Aurora).

**Trade-offs.** Limits deployment options for organizations that standardize on MySQL/MariaDB. The psycopg2-binary dependency requires PostgreSQL client libraries.

!!! note "Historical note: SQLite support (removed in v0.6)"
    OpsDeck supported SQLite as an alternative database through version 0.5. It was dropped in v0.6 because the workarounds required to accommodate SQLite's limitations (no native JSON operators, no concurrent writes, limited ALTER TABLE support, missing window functions) were adding complexity and slowing down development. Features like audit logging with JSON diffs, compliance drift snapshots, and full-text search all relied on PostgreSQL capabilities that had no clean SQLite equivalent.

---

## ADR-007: Sequential migration numbering

**Context.** Alembic (via Flask-Migrate) generates random hex revision IDs by default.

**Decision.** Use sequential numbering (`001_initial.py`, `002_add_notes_field.py`, etc.).

**Rationale.**

- Human-readable ordering — you can see at a glance which migration came first.
- Easier to discuss in code reviews ("migration 015" vs "migration a3f7b2c1").
- Linear history enforced — no branching migrations that could conflict.

**Trade-offs.** Requires manual coordination if multiple developers create migrations simultaneously. Merge conflicts on migration numbers must be resolved manually.

---

## ADR-008: Bootstrap 5 + vanilla JS over React/Vue

**Context.** The frontend needs interactive components (sortable tables, enhanced selects, charts, calendar views, org charts).

**Decision.** Bootstrap 5 as the CSS framework, with purpose-specific JS libraries instead of a framework.

**Rationale.**

- Bootstrap 5 dropped jQuery dependency — clean, modern CSS with responsive grid.
- Each interactive need is solved by the best-in-class library for that specific problem: Simple DataTables for tables, Tom Select for selects, Chart.js for charts, FullCalendar for calendar views, Mermaid for diagrams, SortableJS for drag-and-drop, OrgChart.js for org charts.
- No build step required — `copy-assets.js` copies vendor files from `node_modules` to `static/vendor/`.
- Total JS bundle is smaller than any SPA framework's baseline.

**Trade-offs.** No component model — UI reuse is via Jinja2 includes and macros, which are less composable than React components. State management across related UI elements requires manual DOM manipulation.

---

## ADR-009: WeasyPrint for PDF generation

**Context.** OpsDeck needs to generate PDF reports (audit exports, compliance reports, asset inventories).

**Decision.** WeasyPrint — HTML/CSS to PDF rendering in Python.

**Rationale.**

- Uses the same Jinja2 templates and CSS already written for the web UI — no separate template language.
- Pure Python (with system library dependencies for Pango/Cairo) — no headless browser required.
- Produces high-quality PDFs with proper typography, tables, and page breaks.

**Trade-offs.** Requires system packages (`libpango`, `libcairo`) which complicate the Docker image. Rendering complex layouts can be slow for large reports. CSS support is not 100% — some flexbox/grid features are unavailable.

---

## ADR-010: DeepDiff for UAR and audit change detection

**Context.** The UAR engine and audit logging need to compare complex objects and produce human-readable diffs.

**Decision.** DeepDiff library for structured comparison.

**Rationale.**

- Handles nested dict/list comparison out of the box.
- Produces structured output (added, removed, changed) that can be stored as JSON in the database.
- Used both in the UAR engine (comparing user records between systems) and in the audit listener (detecting which fields changed on a model update).
- Mature library with good edge-case handling (type changes, list reordering, etc.).

**Trade-offs.** Can be slow on very large objects. Output format requires post-processing for human display. Library size is non-trivial for what is conceptually a simple operation.

---

## ADR-011: ECS-format structured logging

**Context.** OpsDeck targets regulated environments where centralized log management is expected. Logs need to be machine-parseable for aggregation in ELK, Datadog, Splunk, or similar stacks.

**Decision.** Use the `ecs-logging` library to emit logs in Elastic Common Schema (ECS) format.

**Rationale.**

- ECS is a well-defined, vendor-neutral JSON schema for log events — fields like `@timestamp`, `log.level`, `message`, `error.stack_trace` are standardized.
- Elasticsearch/Kibana ingest ECS logs natively with zero custom parsers or grok patterns. This is a significant operational win for teams already running ELK.
- Other log aggregators (Datadog, Splunk, Grafana Loki) can consume JSON logs with minimal configuration since the field names are predictable.
- The Helm chart includes an optional Filebeat sidecar that ships ECS logs directly to Elasticsearch.
- Structured JSON is also easier to filter programmatically than plain-text logs (e.g., `jq '.log.level == "ERROR"'`).

**Trade-offs.** JSON logs are harder to read in a terminal during local development compared to plain-text. The `ecs-logging` library adds a dependency. Teams not using ELK get less immediate value from the specific field naming, though the structured JSON format is still beneficial.
