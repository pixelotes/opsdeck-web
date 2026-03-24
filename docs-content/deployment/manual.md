# Manual Deployment

Deploy OpsDeck on a standard Linux server without containers, using Gunicorn behind Nginx.

## System requirements

- Python 3.11+
- PostgreSQL 15+ (16 recommended)
- Nginx (for reverse proxy and TLS termination)
- System packages for WeasyPrint: `libpango-1.0-0`, `libpangocairo-1.0-0`, `libgdk-pixbuf2.0-0`, `libffi-dev`, `libcairo2`

## Installation

### 1. System packages

```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git nginx \
  libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev libcairo2 \
  postgresql postgresql-contrib
```

### 2. PostgreSQL setup

```bash
sudo -u postgres psql -c "CREATE USER opsdeck WITH PASSWORD 'your-db-password';"
sudo -u postgres psql -c "CREATE DATABASE opsdeck OWNER opsdeck;"
```

### 3. Application setup

```bash
cd /opt
sudo git clone https://github.com/pixelotes/opsdeck.git
cd opsdeck

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 4. Configuration

```bash
cp .env.example .env
```

Edit `.env`:

```bash
SECRET_KEY=<64-char random string>
DATABASE_URL=postgresql://opsdeck:your-db-password@localhost:5432/opsdeck
FLASK_DEBUG=0
SESSION_COOKIE_SECURE=True
DEFAULT_ADMIN_EMAIL=admin@yourcompany.com
DEFAULT_ADMIN_INITIAL_PASSWORD=<strong password>
```

### 5. Database initialization

```bash
flask db upgrade
flask init-db
flask seed-db-prod
```

### 6. Gunicorn

Test that the application starts:

```bash
gunicorn --bind 127.0.0.1:5000 --workers 4 --timeout 120 run:app
```

## Systemd service

Create `/etc/systemd/system/opsdeck.service`:

```ini
[Unit]
Description=OpsDeck Application
After=network.target postgresql.service

[Service]
User=www-data
Group=www-data
WorkingDirectory=/opt/opsdeck
Environment="PATH=/opt/opsdeck/venv/bin"
EnvironmentFile=/opt/opsdeck/.env
ExecStart=/opt/opsdeck/venv/bin/gunicorn --bind 127.0.0.1:5000 --workers 4 --timeout 120 run:app
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable opsdeck
sudo systemctl start opsdeck
```

## Nginx reverse proxy

Create `/etc/nginx/sites-available/opsdeck`:

```nginx
server {
    listen 443 ssl;
    server_name opsdeck.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/opsdeck.yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/opsdeck.yourcompany.com/privkey.pem;

    client_max_body_size 50M;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /opt/opsdeck/src/static/;
        expires 30d;
    }
}

server {
    listen 80;
    server_name opsdeck.yourcompany.com;
    return 301 https://$host$request_uri;
}
```

```bash
sudo ln -s /etc/nginx/sites-available/opsdeck /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## File permissions

```bash
sudo chown -R www-data:www-data /opt/opsdeck/data
sudo chmod 750 /opt/opsdeck/data/attachments
```
