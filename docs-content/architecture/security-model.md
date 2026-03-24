# Security Model

This document describes OpsDeck's security architecture, covering authentication, authorization, data protection, and security headers.

## Authentication flow

OpsDeck supports two authentication methods: local credentials and Google OAuth via Flask-Dance.

### Local authentication

1. User submits email and password.
2. Password is verified against the stored hash (Werkzeug PBKDF2).
3. If MFA is enabled (`MFA_ENABLED=True`) and the login comes from an unknown IP address, a one-time password (OTP) is sent via email. Known IPs are tracked per user via the `UserKnownIP` model and bypass the MFA step.
4. Flask-Login creates a server-side session with secure cookie flags.
5. The user's IP is recorded as a known IP for future logins.

### OAuth (Google SSO)

1. User clicks "Sign in with Google."
2. Flask-Dance redirects to Google's OAuth consent screen.
3. On callback, the email is matched to an existing user record.
4. If the user exists, a session is created. If not, access is denied (no self-registration).

!!! warning
    `OAUTHLIB_INSECURE_TRANSPORT=1` must only be set in development. It disables the HTTPS requirement for OAuth callbacks.

## Session management

| Setting | Default | Production |
|---|---|---|
| `SESSION_COOKIE_SECURE` | `False` | `True` |
| `SESSION_COOKIE_HTTPONLY` | `True` | `True` |
| `SESSION_COOKIE_SAMESITE` | `Lax` | `Lax` or `Strict` |

Sessions are stored server-side. The cookie contains only the session identifier, signed with `SECRET_KEY`.

## Authorization (RBAC)

### Role hierarchy

| Role | Access |
|---|---|
| **Admin** | Full system access, user management, configuration. Bypasses all permission checks. |
| **Editor** | Read/write access to operational data based on module permissions |
| **User** | Read access to assigned data, limited write access based on module permissions |
| **API** | Programmatic access via bearer token (inherits user's permissions) |

### Permission resolution

Permissions are defined at the module level. Each module (assets, compliance, risk, etc.) has two access levels: `READ_ONLY` and `WRITE` (which implies read).

Permission checks follow this chain:

1. Route decorator `@permission_required(module, level)` intercepts the request.
2. `permissions_service.py` resolves the user's effective permissions by combining their direct role with group-inherited permissions.
3. Resolved permissions are cached in-memory (`permissions_cache.py`) to avoid repeated DB queries.
4. Cache is invalidated when group membership or role assignment changes.

### API authentication

API endpoints accept a bearer token in the `Authorization` header. Tokens are generated per-user, hashed with SHA-256 before storage, and carry the same permissions as the owning user. Tokens can be revoked from the user profile.

## Data protection

### Credential encryption

The credentials vault (`models/credentials.py`) uses Fernet symmetric encryption (from the `cryptography` library) to encrypt secret values at rest. The encryption key is derived from `SECRET_KEY`. Each `CredentialSecret` record stores a Fernet token that can only be decrypted with the application's key.

### Password hashing

User passwords are hashed using Werkzeug's `generate_password_hash` (PBKDF2 with SHA-256, 600,000 iterations by default). Plaintext passwords are never stored or logged.

### API token hashing

API tokens are displayed once at creation time. The stored value is a SHA-256 hash — the original token cannot be recovered from the database.

## Security headers (flask-talisman)

flask-talisman enforces:

- `Strict-Transport-Security` (HSTS)
- `Content-Security-Policy` (CSP)
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `Referrer-Policy: strict-origin-when-cross-origin`

CSP is configured to allow the specific CDN sources used by the frontend libraries (Bootstrap, Chart.js, etc.) while blocking inline scripts where possible.

## Rate limiting

Flask-Limiter protects against brute-force and abuse:

- Login endpoint: rate-limited to prevent credential stuffing.
- API endpoints: per-token rate limits.
- Configurable via environment variables.

## Audit logging

Every data mutation is captured by the SQLAlchemy event listener in `utils/audit_listener.py`:

- **Who**: User ID from the Flask-Login session.
- **What**: Table name, record ID, operation type (INSERT/UPDATE/DELETE).
- **When**: UTC timestamp.
- **Details**: JSON diff of changed fields (via DeepDiff).

Audit log records are append-only — there is no UI or API to delete them. They serve as the immutable audit trail required by ISO 27001 and SOC 2.
