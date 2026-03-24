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
