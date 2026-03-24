# Monitoring & Logging

OpsDeck uses ECS-format structured logging and provides a health check endpoint for monitoring integration.

## Structured logging

All application logs are emitted in ECS (Elastic Common Schema) format using the `ecs-logging` library. This makes them directly ingestible by Elasticsearch, Logstash, and Kibana.

Log entries include:

- **Timestamp** — ISO 8601 UTC.
- **Log level** — DEBUG, INFO, WARNING, ERROR.
- **Event metadata** — `event.action`, `event.category`, `event.outcome`.
- **User context** — `user.id`, `user.email` (when available).
- **Request context** — `source.ip`, `http.request.method`, `url.path`.

### Log configuration

Log level is controlled via the `LOG_LEVEL` environment variable (default: `INFO`). Set to `DEBUG` for troubleshooting.

Logs are written to stdout by default (suitable for Docker/Kubernetes log collection). For file output, configure in the application or redirect via your process manager.

## Health check endpoint

```
GET /health
```

Returns HTTP 200 with a JSON body if the application is healthy:

```json
{
  "status": "healthy",
  "database": "connected",
  "scheduler": "running"
}
```

Checks performed:

- Database connectivity (simple query).
- APScheduler status (running vs. stopped).

Use this endpoint for:

- Docker health checks (`HEALTHCHECK` in Dockerfile or `docker-compose.yml`).
- Kubernetes liveness and readiness probes.
- External monitoring (Uptime Robot, Pingdom, etc.).

## Integration with ELK

Since logs are already in ECS format, integration with Elasticsearch is straightforward:

1. Configure your log driver to ship logs to Logstash or Filebeat.
2. Logs parse natively without custom grok patterns.
3. Use Kibana to create dashboards for: API access patterns, authentication failures, error rates, and audit events.

## APScheduler monitoring

Scheduled job execution is logged with:

- Job start and completion timestamps.
- Duration and outcome (success/failure).
- Error details with stack traces on failure.

Monitor for:

- Jobs that stop executing (scheduler died).
- Jobs with increasing duration (performance degradation).
- Repeated failures on the same job.
