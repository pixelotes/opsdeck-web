# Scheduler & Jobs

OpsDeck uses APScheduler (Advanced Python Scheduler) for background job execution within the Flask application process. No external queue or worker infrastructure is required.

## Configuration

APScheduler runs in-process with the Flask application. It initializes during app startup and shares the application context, database session, and configuration.

Jobs are defined programmatically in the application factory (`src/__init__.py`) and service modules. The scheduler uses a thread pool executor with a single job store (in-memory by default).

!!! note
    Because the scheduler runs in-process, jobs execute serially within the thread pool. A long-running job will not block the web server (Gunicorn spawns separate workers), but it will delay other scheduled jobs.

## Registered jobs

| Job | Schedule | Service | Description |
|---|---|---|---|
| Compliance drift snapshot | Weekly (Mondays at 9:00 AM) | `compliance_drift_service` | Captures current compliance status for all frameworks and compares with the previous snapshot to detect regressions |
| UAR scheduled execution | Configurable per comparison | `uar_service` | Loads datasets, runs the comparison engine, and generates findings |
| Subscription renewal alerts | Daily | `notifications` | Checks for subscriptions approaching renewal and sends notifications |
| Credential expiry alerts | Daily | `notifications` | Checks for credentials approaching expiry date |
| Certificate expiry alerts | Daily | `notifications` | Checks for certificates approaching expiry date |
| Communications queue | Every 5 minutes | `notifications` | Processes scheduled emails, Slack messages, and webhooks |
| Exchange rate sync | Daily at 3:00 AM | `finance_service` | Syncs currency exchange rates for multi-currency support |
| Data retention | Weekly | — | Archives old records per configured retention policies |

## Compliance drift detection

The drift detection job is the most complex scheduled task:

1. **Snapshot capture.** Queries all `FrameworkControl` records and their current compliance status (derived from linked evidence). Stores the snapshot as a JSON record with timestamp.
2. **Drift analysis.** Compares the new snapshot with the most recent previous snapshot. For each control, detects status changes.
3. **Classification.** Changes are classified as:
    - **Regression** — status worsened (e.g., Compliant → Warning). Assigned severity: critical for Non-compliant, high for Warning, medium for other regressions.
    - **Improvement** — status improved (e.g., Non-compliant → Compliant).
4. **Alerting.** Critical regressions are logged and (when configured) trigger notifications via email or Slack webhook.

The drift timeline is visualized on the Compliance Drift dashboard, showing changes over configurable periods (7, 30, 90 days).

## UAR scheduled execution

UAR comparisons can be scheduled at the comparison level:

1. The scheduler checks for comparisons due for execution based on their configured frequency (daily, weekly, monthly).
2. For each due comparison, it triggers `uar_service.execute_comparison()`.
3. The engine loads both datasets, performs the DeepDiff comparison, and generates `UARFinding` records.
4. Progress is logged for long-running comparisons.
5. On completion, the execution record is updated with finding counts and status.

## Error handling

- Each job wraps its execution in a try/except block.
- Errors are logged with full stack traces using the ECS-format structured logger.
- Failed jobs do not crash the scheduler — the next scheduled run proceeds normally.
- There is no automatic retry mechanism — failed runs must be investigated from the logs or re-triggered manually.

## Manual execution

All scheduled jobs can be triggered manually:

- **Compliance drift snapshot:** click "Capture Snapshot" on the Compliance Drift page.
- **UAR execution:** click "Run Now" on the comparison detail page.
- **Via CLI:** `flask run-job <job_name>` (if configured).
