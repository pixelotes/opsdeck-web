# Data Import (CLI)

OpsDeck provides CLI commands for bulk CSV import, useful for initial system bootstrapping or migrating from legacy tools.

## General usage

All import commands use the Flask CLI. For Docker deployments:

```bash
# Copy CSV into the container
docker cp my_data.csv opsdeck_web_1:/app/

# Run the import
docker exec -it opsdeck_web_1 flask data-import [COMMAND] my_data.csv
```

For local installations, run directly:

```bash
flask data-import [COMMAND] my_data.csv
```

## Supported entities

### Users

```bash
flask data-import users users.csv
```

| Column | Required | Description |
|---|---|---|
| `name` | Yes | Full name |
| `email` | Yes | Email (must be unique) |

Imported users receive the `user` role by default. Random passwords are generated and displayed in console output.

### Assets

```bash
flask data-import assets assets.csv
```

| Column | Required | Description |
|---|---|---|
| `name` | Yes | Asset name |
| `model` | No | Model identifier |
| `serial_number` | No | Serial number |
| `asset_type` | No | Type (laptop, server, etc.) |
| `status` | No | Lifecycle status |

### Suppliers

```bash
flask data-import suppliers suppliers.csv
```

| Column | Required | Description |
|---|---|---|
| `name` | Yes | Company name |
| `website` | No | URL |
| `category` | No | Supplier category |

### Contacts

```bash
flask data-import contacts contacts.csv
```

| Column | Required | Description |
|---|---|---|
| `name` | Yes | Contact name |
| `email` | Yes | Email |
| `supplier` | Yes | Supplier name (must exist) |
| `role` | No | Role at the supplier |

## Validation and error handling

- Duplicate records (matched by email for users, name for suppliers) are skipped with a warning.
- Invalid rows are logged with the row number and error details.
- The import runs within a database transaction — if critical errors occur, the entire import can be rolled back.
- Console output shows a summary: imported, skipped, and failed counts.
