# Database Management

OpsDeck uses Flask-Migrate (Alembic) for database schema versioning with a sequential numbering convention.

## Migration conventions

Migrations are stored in `migrations/versions/` with sequential numbering:

```
migrations/versions/
├── 001_initial.py
├── 002_add_notes_field.py
├── 003_add_risk_categories.py
└── ...
```

This provides human-readable ordering and enforces a linear migration history. No branching migrations.

## Running migrations

```bash
# Apply all pending migrations
flask db upgrade

# Check current migration version
flask db current

# View migration history
flask db history
```

For Docker deployments, migrations run automatically on container startup via `entrypoint.sh`. For manual or Kubernetes deployments, run migrations explicitly before starting the application.

## Creating new migrations

After modifying SQLAlchemy models:

```bash
# Auto-generate a migration
flask db migrate -m "description of changes"

# Rename the generated file to follow sequential numbering
# e.g., rename random hex to 015_add_certificate_tracking.py

# Review the generated migration
# Verify upgrade() and downgrade() functions

# Apply
flask db upgrade
```

!!! warning
    Always review auto-generated migrations. Alembic may miss some changes (table renames, data migrations) or generate incorrect operations.

## Rollback

```bash
# Roll back one migration
flask db downgrade -1

# Roll back to a specific revision
flask db downgrade 010
```

## Database initialization

On a fresh database:

```bash
flask db upgrade     # Apply all migrations
flask init-db        # Create base tables and configuration
flask seed-db-prod   # Create admin user and seed reference data
```

## Diagnostics & repair

After a rough deployment the Alembic version tracking can drift from the actual
schema (e.g. `alembic_version` missing, stale, or behind). `flask db-doctor`
diagnoses this and repairs the safe cases:

```bash
# Diagnose only (read-only). Exits non-zero if problems are found.
flask db-doctor

# Diagnose and repair where safe
flask db-doctor --fix
```

It checks two things:

- **Alembic tracking** — reports `OK`, `MISSING` (no `alembic_version` table),
  `EMPTY`, `STALE` (current revision not in the migration scripts), or `BEHIND`
  (pending migrations).
- **Schema vs models** — uses Alembic autogenerate to compare the live schema
  against the SQLAlchemy models and lists any drift. Extra tables not present in
  the models (e.g. optional plugins) are reported separately, not as errors.

With `--fix` it only applies safe repairs:

| Situation | Action |
| --- | --- |
| Empty database | `upgrade` (build the schema from migrations) |
| Tables present, tracking missing/stale, schema already matches | `stamp head` |
| Pending migrations | `upgrade` |
| Real schema drift (models ≠ migrations) | Reported only — run `flask db migrate` |

!!! note
    `db-doctor` never generates `ALTER` statements on its own. When it detects
    genuine drift between the models and the schema it tells you to create a
    migration rather than guessing.
