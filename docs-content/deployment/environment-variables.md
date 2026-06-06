# Environment Variables

OpsDeck is configured entirely via environment variables. Set them in your OS, in a `.env` file in the project root (auto-loaded via python-dotenv), or in your container orchestrator.

## General

| Variable | Description | Default | Required |
|---|---|---|---|
| `SECRET_KEY` | Cryptographic signing key for sessions, CSRF, and credential encryption. Must be long and random. | `your-secret-key-change-this` | **Yes** |
| `FLASK_APP` | Flask application entry point. | `run:app` | Yes |
| `FLASK_DEBUG` | Enable debug mode. `1` for development, `0` for production. | `0` | No |

## Database

| Variable | Description | Default | Required |
|---|---|---|---|
| `DATABASE_URL` | PostgreSQL connection URI. Format: `postgresql://user:pass@host:port/dbname` | — | **Yes** |

## Admin initialization

These are used only on the first run to create the initial admin user.

| Variable | Description | Default |
|---|---|---|
| `DEFAULT_ADMIN_EMAIL` | Admin user email. | `admin@example.com` |
| `DEFAULT_ADMIN_INITIAL_PASSWORD` | Admin user initial password. Changed on first login. | `admin123` |

## Email / SMTP

| Variable | Description | Default |
|---|---|---|
| `SMTP_SERVER` | SMTP server hostname. | `smtp.gmail.com` |
| `SMTP_PORT` | SMTP server port. | `587` |
| `EMAIL_USERNAME` | SMTP authentication username (usually an email). | `''` |
| `EMAIL_PASSWORD` | SMTP authentication password or app password. | `''` |
| `EMAIL_SENDER_NAME` | Display name for the email `From` header. When set, outgoing mail shows as `Name <EMAIL_USERNAME>`; when empty, just the address. | `''` |

## Authentication

| Variable | Description | Default |
|---|---|---|
| `GOOGLE_OAUTH_CLIENT_ID` | Google OAuth client ID for SSO. | `''` |
| `GOOGLE_OAUTH_CLIENT_SECRET` | Google OAuth client secret. | `''` |
| `OAUTHLIB_INSECURE_TRANSPORT` | Allow OAuth over HTTP. **Development only.** | — |
| `MFA_ENABLED` | Enable IP-based MFA. When a login comes from an unknown IP, an OTP is sent via email. Known IPs (tracked per user) bypass the check. | `False` |

## Session and cookies

| Variable | Default | Production recommendation |
|---|---|---|
| `SESSION_COOKIE_SECURE` | `False` | `True` |
| `SESSION_COOKIE_HTTPONLY` | `True` | `True` |
| `SESSION_COOKIE_SAMESITE` | `Lax` | `Lax` or `Strict` |

## Notifications

| Variable | Description | Default |
|---|---|---|
| `WEBHOOK_URL` | External webhook URL for notifications (Slack, Discord). | `''` |
| `SLACK_BOT_TOKEN` | Slack bot token for direct messaging and channel notifications. | `''` |

## Performance tuning

| Variable | Description | Default |
|---|---|---|
| `GUNICORN_WORKERS` | Number of Gunicorn worker processes. | `2` |
| `GUNICORN_THREADS` | Threads per Gunicorn worker. | `4` |
| `TIMEZONE` | Application timezone for scheduled jobs and display. | `Europe/Madrid` |

## Enterprise features

| Variable | Description | Default |
|---|---|---|
| `ENTERPRISE_ENABLED` | Enable enterprise-tier features. | `False` |
| `SEED_DEMO_DATA` | Seed demo data on first run. Development only. | `False` |

!!! tip "Minimal production `.env`"
    ```bash
    SECRET_KEY=<64-char random string>
    DATABASE_URL=postgresql://opsdeck:password@db:5432/opsdeck
    FLASK_DEBUG=0
    SESSION_COOKIE_SECURE=True
    DEFAULT_ADMIN_EMAIL=admin@yourcompany.com
    DEFAULT_ADMIN_INITIAL_PASSWORD=<strong password>
    ```
