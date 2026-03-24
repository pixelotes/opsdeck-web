# Upgrading

Procedure for upgrading OpsDeck to a new version.

## Version compatibility

OpsDeck follows semantic versioning. Database migrations handle schema changes between versions. Always read the [Changelog](../changelog.md) before upgrading to understand breaking changes.

## Upgrade procedure

### 1. Backup

Always back up before upgrading:

```bash
# Database
docker-compose exec -T db pg_dump -U opsdeck opsdeck | gzip > backup_pre_upgrade.sql.gz

# Attachments
tar -czf attachments_pre_upgrade.tar.gz ./data/attachments
```

### 2. Pull new version

=== "Docker"

    ```bash
    docker-compose pull
    # or rebuild if using local Dockerfile:
    docker-compose build --no-cache
    ```

=== "Manual"

    ```bash
    cd /opt/opsdeck
    git fetch origin
    git checkout v0.x.y  # Target version tag
    source venv/bin/activate
    pip install -r requirements.txt
    ```

### 3. Run migrations

=== "Docker"

    Migrations run automatically on container startup via `entrypoint.sh`.

=== "Manual"

    ```bash
    flask db upgrade
    ```

### 4. Restart

=== "Docker"

    ```bash
    docker-compose up -d
    ```

=== "Manual"

    ```bash
    sudo systemctl restart opsdeck
    ```

### 5. Verify

- Check application logs for migration errors.
- Verify the dashboard loads correctly.
- Confirm the version number in the UI footer.

## Dependency updates

Python and JavaScript dependencies are updated periodically:

```bash
# Python — use the provided script
bash update-deps.sh

# JavaScript
bash update-node-deps.sh
```

Both scripts update dependencies and run tests to verify compatibility.

## Rollback plan

If the upgrade fails:

1. Stop the application.
2. Restore the database from backup.
3. Restore attachments from backup.
4. Roll back to the previous version (Docker image tag or git checkout).
5. Restart.
