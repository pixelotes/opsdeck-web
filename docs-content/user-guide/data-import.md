# Data Import

OpsDeck supports bulk CSV import from two places: the **admin UI** (recommended) and the **Flask CLI**.

## From the admin UI (recommended)

**Administration → Import Data** (requires *Administration* write access) imports records from a CSV with a safe, guided workflow:

1. **Pick the entity type** and **download its CSV template** — the template's header row is exactly the columns that type accepts.
2. Fill in the CSV and **upload it**.
3. **Review the preview**: every row is classified as **create**, **skipped** (e.g. a duplicate that already exists) or **error** (e.g. a missing required value). Nothing is written to the database yet.
4. **Confirm** to create the records. For user imports the generated passwords are shown once, on the results page — copy them then.

Each type's card lists its **required** and **optional** columns. Where a referenced object is given by name (an asset's brand/model/location, a contact's supplier, a subscription's budget…) it is matched by name and, for some types, created automatically if missing.

### Supported types

Users, Suppliers, Contacts, Assets, Peripherals, Software, Subscriptions, Risks, Locations, Tags, Brands, Asset Models, Cost Centers, Budgets and Payment Methods.

!!! tip
    Import reference data first (Locations, Brands, Budgets, Suppliers…) so that later imports (Assets, Subscriptions…) link to existing records instead of auto-creating partial ones.

!!! note
    Assets and Peripherals require a `serial_number`; Subscriptions require both `supplier_name` (which must already exist) and `name`.

## CLI usage

The Flask CLI runs the **same import engine as the admin UI** — identical types, columns, rules and duplicate handling. It's handy for bootstrapping or scripting. The command name is the type key; list them all with `flask data-import --help`, and see a type's columns with e.g. `flask data-import assets --help`.

For Docker deployments:

```bash
docker cp my_data.csv opsdeck-web-1:/app/
docker exec -it opsdeck-web-1 flask data-import users my_data.csv
```

For local installations:

```bash
flask data-import users my_data.csv
```

### Available commands

`users`, `suppliers`, `contacts`, `assets`, `peripherals`, `software`, `subscriptions`, `risks`, `locations`, `tags`, `brands`, `asset_models`, `cost_centers`, `budgets`, `payment_methods`.

Columns and required fields are exactly those documented for the UI above (e.g. `assets`/`peripherals` require `serial_number`; `subscriptions` requires `supplier_name` and `name`). Each run reports `created / skipped / errors` with a per-row reason for anything not created; `users` prints the generated passwords once.

## Google Workspace import

In addition to CSV imports, OpsDeck ships a helper script that syncs users straight from **Google Workspace** via the Admin Directory API. It is found at `scripts/google-import.py` (with `scripts/google-import.md` for full details).

Unlike the CSV importer, this script talks to OpsDeck over the [REST API](api.md) and upserts users **by email**, so it is safe to run repeatedly — existing users are skipped, only missing ones are created.

### Prerequisites

A Google Cloud **service account** with domain-wide delegation, authorized for the `admin.directory.user.readonly` scope in the Google Admin console.

Configure the script via environment variables:

| Variable | Required | Description |
|---|---|---|
| `GOOGLE_SERVICE_ACCOUNT_JSON` | Yes | Path to the service account JSON key |
| `GOOGLE_DELEGATED_USER` | Yes | Admin email for domain-wide delegation |
| `OPSDECK_URL` | Yes | OpsDeck base URL |
| `OPSDECK_API_TOKEN` | Yes | API token from an admin user |
| `GOOGLE_DOMAIN` | No | Restrict the import to one domain |
| `OPSDECK_DEFAULT_ROLE` | No | Role for imported users (default `user`) |

### Running it

```bash
# Preview what would be imported
python scripts/google-import.py --dry-run

# Create the missing users
python scripts/google-import.py --execute

# Limit to a Google org unit
python scripts/google-import.py --org-unit /Employees --execute
```

One of `--dry-run` or `--execute` is required. Use `--include-suspended` to also import suspended Google accounts (skipped by default).

## Validation and error handling

- Duplicate records (matched by email for users, name for suppliers) are skipped with a warning.
- Invalid rows are logged with the row number and error details.
- The import runs within a database transaction — if critical errors occur, the entire import can be rolled back.
- Console output shows a summary: imported, skipped, and failed counts.
