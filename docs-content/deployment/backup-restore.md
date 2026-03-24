# Backup & Restore

OpsDeck stores data in two places: PostgreSQL (all application data) and the filesystem (attachments and uploaded files). Both must be backed up together to ensure a consistent restore.

## What to back up

| Component | Location | Method |
|---|---|---|
| Database | PostgreSQL | `pg_dump` |
| Attachments | `/app/data/attachments` (container) or `./data/attachments` (host) | File copy / tar |
| Configuration | `.env` file | File copy |

## Automated backup script

```bash
#!/bin/bash
# backup-opsdeck.sh
set -euo pipefail

BACKUP_DIR="/backups/opsdeck"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

mkdir -p "$BACKUP_DIR"

# Database backup
echo "Backing up database..."
docker-compose exec -T db pg_dump -U opsdeck opsdeck \
  | gzip > "$BACKUP_DIR/db_${TIMESTAMP}.sql.gz"

# Attachments backup
echo "Backing up attachments..."
tar -czf "$BACKUP_DIR/attachments_${TIMESTAMP}.tar.gz" ./data/attachments

# Cleanup old backups
find "$BACKUP_DIR" -name "*.gz" -mtime +${RETENTION_DAYS} -delete

echo "Backup complete: $BACKUP_DIR/*_${TIMESTAMP}.*"
```

Schedule via cron:

```cron
0 2 * * * /opt/scripts/backup-opsdeck.sh >> /var/log/opsdeck-backup.log 2>&1
```

## Restore procedure

### 1. Stop the application

```bash
docker-compose stop web
```

### 2. Restore the database

```bash
# Drop and recreate the database
docker-compose exec db psql -U opsdeck -c "DROP DATABASE opsdeck;"
docker-compose exec db psql -U opsdeck -c "CREATE DATABASE opsdeck;"

# Restore from backup
gunzip -c /backups/opsdeck/db_20260324_020000.sql.gz \
  | docker-compose exec -T db psql -U opsdeck opsdeck
```

### 3. Restore attachments

```bash
rm -rf ./data/attachments
tar -xzf /backups/opsdeck/attachments_20260324_020000.tar.gz
```

### 4. Restart

```bash
docker-compose start web
```

## Kubernetes backup

For Helm deployments, adapt the strategy:

- Use `kubectl exec` instead of `docker-compose exec` to run `pg_dump`.
- For external PostgreSQL (RDS/Aurora), use the provider's native backup (automated snapshots, point-in-time recovery).
- For attachment PVCs, use your storage provider's snapshot mechanism or Velero for volume-level backups.

## Verification

After any restore, verify:

1. Application starts without migration errors.
2. Dashboard loads with correct data.
3. Attachments are accessible (open any asset or policy with uploaded files).
4. Audit log contains expected history.
