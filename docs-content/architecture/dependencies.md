# Dependencies

Complete list of Python and JavaScript dependencies used by OpsDeck, with version, purpose, and justification.

## Python dependencies

### Production (`requirements.txt`)

| Package | Version | Purpose |
|---|---|---|
| **Flask** | 3.1.3 | Web framework — lightweight, blueprint-based, extension-friendly |
| **Flask-SQLAlchemy** | 3.1.1 | SQLAlchemy integration for Flask — session management, model base class |
| **Flask-Migrate** | 4.1.0 | Database migrations via Alembic — schema versioning and upgrades |
| **Flask-Login** | 0.6.3 | Session-based user authentication — login/logout, remember-me, session protection |
| **Flask-Dance** | 7.1.0 | OAuth provider integration — Google SSO support |
| **Flask-WTF** | 1.2.2 | Form handling with CSRF protection — validation, rendering, file uploads |
| **flask-talisman** | 1.1.0 | Security headers — CSP, HSTS, X-Frame-Options, referrer policy |
| **flask-smorest** | 0.46.2 | REST API framework — OpenAPI spec generation, request/response validation |
| **Flask-Limiter** | 4.1.1 | Rate limiting — brute-force protection, API throttling |
| **marshmallow-sqlalchemy** | 1.4.2 | Auto-schema generation from SQLAlchemy models for API serialization |
| **SQLAlchemy** | *(transitive)* | ORM — model definition, querying, relationship management |
| **Alembic** | *(transitive)* | Migration engine — auto-detect model changes, generate migration scripts |
| **psycopg2-binary** | 2.9.11 | PostgreSQL driver — binary distribution, no compilation needed |
| **APScheduler** | 3.11.2 | Background job scheduler — cron-style jobs, in-process execution |
| **gunicorn** | 25.1.0 | Production WSGI server — multi-worker, pre-fork model |
| **requests** | 2.32.5 | HTTP client — webhook delivery, external API calls |
| **python-dateutil** | 2.9.0 | Date parsing and manipulation — relative deltas, recurring dates |
| **python-dotenv** | 1.2.2 | Environment variable loading from `.env` files |
| **pytz** | 2026.1 | Timezone definitions — IANA timezone database |
| **MarkupSafe** | 3.0.3 | HTML escaping — Jinja2 dependency, XSS prevention |
| **Markdown** | 3.10.2 | Markdown rendering — documentation pages, rich text descriptions |
| **WeasyPrint** | 68.1 | HTML-to-PDF rendering — report generation using existing templates |
| **ecs-logging** | 2.3.0 | ECS-format structured logging — Elasticsearch-compatible log format |
| **deepdiff** | 8.6.1 | Structured object comparison — UAR engine, audit change detection |
| **slack_sdk** | 3.41.0 | Slack API client — notification delivery to Slack channels |
| **PyJWT** | 2.12.0 | JWT token handling — OAuth flow, token validation |
| **cryptography** | 46.0.5 | Cryptographic operations — Fernet encryption for credential vault |
| **boto3** | 1.42.67 | AWS SDK — S3 storage for attachments in cloud deployments |

### Development (`requirements-dev.txt`)

| Package | Version | Purpose |
|---|---|---|
| **pytest** | 9.0.2 | Test framework — 377 tests across all modules |
| **Faker** | 40.8.0 | Fake data generation — test fixtures, demo data seeding |

## JavaScript dependencies

### Production (`package.json`)

| Package | Version | Purpose |
|---|---|---|
| **bootstrap** | 5.3.x | CSS framework — responsive grid, components, utilities |
| **@popperjs/core** | 2.11.x | Tooltip/popover positioning — Bootstrap dependency |
| **@fortawesome/fontawesome-free** | 7.2.x | Icon library — UI icons throughout the application |
| **chart.js** | 4.5.x | Chart library — dashboard visualizations, compliance trends |
| **simple-datatables** | 10.2.x | Table enhancement — sort, search, paginate HTML tables |
| **tom-select** | 2.5.x | Enhanced select inputs — search, tagging, remote data |
| **fullcalendar** | 6.1.x | Calendar component — scheduling views, date-based navigation |
| **mermaid** | 11.13.x | Diagram renderer — service topology, flowcharts from text |
| **suneditor** | 2.47.x | WYSIWYG editor — rich text editing for descriptions and notes |
| **easymde** | 2.20.x | Markdown editor — documentation editing with preview |
| **sortablejs** | 1.15.x | Drag-and-drop — reorderable lists (onboarding items, priorities) |
| **swagger-ui-dist** | 5.32.x | API documentation UI — interactive endpoint testing |
| **html2canvas** | 1.4.x | DOM-to-canvas screenshot — client-side report captures |
| **orgchart.js** | 0.0.4 | Organization chart — hierarchical user visualization |

## Dependency management

Python dependencies are pinned to exact versions (`==`) in `requirements.txt` for reproducible builds. The `update-deps.sh` script automates the update workflow:

1. Creates a fresh virtual environment.
2. Installs packages with latest compatible versions.
3. Freezes to `requirements.txt`.
4. Runs the test suite to verify compatibility.

JavaScript dependencies are managed via npm. `copy-assets.js` copies distribution files from `node_modules` to `src/static/vendor/` — no bundler involved.
