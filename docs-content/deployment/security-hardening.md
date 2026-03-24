# Security Hardening

Production security checklist and configuration guidance.

## Pre-deployment checklist

- [ ] `SECRET_KEY` is a unique, random string (at least 64 characters).
- [ ] `FLASK_DEBUG=0` is set.
- [ ] `SESSION_COOKIE_SECURE=True` (requires HTTPS).
- [ ] `SESSION_COOKIE_HTTPONLY=True` (default).
- [ ] `SESSION_COOKIE_SAMESITE=Lax` or `Strict`.
- [ ] Default admin password has been changed.
- [ ] Database password is strong and unique.
- [ ] TLS is configured on the reverse proxy.
- [ ] `OAUTHLIB_INSECURE_TRANSPORT` is **not** set.

## Content Security Policy

flask-talisman enforces a CSP that restricts script and style sources. The default policy allows:

- Scripts and styles from `'self'` and the specific CDN sources used by vendor libraries.
- Inline styles for Bootstrap components (via nonce or `'unsafe-inline'` where unavoidable).
- No inline scripts.

Review and tighten the CSP for your environment. Test with browser developer tools to catch blocked resources.

## Rate limiting

Flask-Limiter protects against:

- **Login brute-force** — limited attempts per IP per time window.
- **API abuse** — per-token rate limits on API endpoints.
- **Form spam** — general rate limits on POST endpoints.

Configure limits via environment variables or in the application configuration. Defaults are conservative — adjust based on expected legitimate traffic.

## OAuth / SSO setup

For Google OAuth:

1. Create OAuth credentials in Google Cloud Console.
2. Set authorized redirect URI to `https://your-domain/login/google/authorized`.
3. Configure `GOOGLE_OAUTH_CLIENT_ID` and `GOOGLE_OAUTH_CLIENT_SECRET`.
4. Ensure `OAUTHLIB_INSECURE_TRANSPORT` is **not** set in production.

Users must already exist in OpsDeck — OAuth authenticates but does not auto-create accounts.

## Secret rotation

| Secret | Rotation impact | Procedure |
|---|---|---|
| `SECRET_KEY` | Invalidates all sessions and encrypted credentials | Update key, restart app, re-encrypt credentials |
| Database password | Requires config update | Update in PostgreSQL and `.env`, restart app |
| API tokens | Per-user, no global impact | Revoke from user profile, generate new token |
| OAuth secrets | Breaks SSO until updated | Update in Google Console and `.env` |

!!! danger
    Changing `SECRET_KEY` renders all Fernet-encrypted credentials unreadable. Export credential vault contents **before** rotating the key.

## Network security

- Place the application behind a reverse proxy (Nginx, Traefik) — never expose Gunicorn directly.
- Isolate PostgreSQL from public network access.
- Use firewall rules to restrict access to necessary ports only.
- For Kubernetes, use NetworkPolicies to limit pod-to-pod communication.

## Known IP tracking

OpsDeck records the IP addresses used by each user (`UserKnownIP`). This enables:

- Detection of logins from new/unusual locations.
- Audit trail of access origins.
- Future: alerting on logins from unknown IPs.
