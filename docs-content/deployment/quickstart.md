# Quick Start

Get a local development instance running in under 5 minutes.

## Prerequisites

- Python 3.11+
- PostgreSQL 15+ running locally (or use the Docker Compose method below)
- Git

## Option A: Local Python

```bash
# Clone
git clone https://github.com/pixelotes/opsdeck.git
cd opsdeck

# Virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Environment
cp .env.example .env
# Edit .env and set DATABASE_URL to your local PostgreSQL

# Database
flask db upgrade
flask init-db
flask seed-db-prod    # Creates admin user and base data

# Run
flask run --debug
```

## Option B: Docker Compose

```bash
git clone https://github.com/pixelotes/opsdeck.git
cd opsdeck
docker-compose up -d --build
```

This starts both the application and a PostgreSQL 16 container. The database is initialized automatically via `entrypoint.sh`.

## First login

Open `http://127.0.0.1:5000` and log in with:

| Field | Value |
|---|---|
| Email | `admin@example.com` |
| Password | `admin123` |

You'll be prompted to change the password immediately.

!!! tip
    Customize the initial admin credentials by setting `DEFAULT_ADMIN_EMAIL` and `DEFAULT_ADMIN_INITIAL_PASSWORD` in `.env` before the first run.

## What's next

- [Environment Variables](environment-variables.md) — full configuration reference.
- [Docker Compose](docker.md) — production-grade Docker deployment.
- [Kubernetes](kubernetes.md) — Helm chart deployment.
- [Getting Started (User Guide)](../user-guide/getting-started.md) — learn the application.
