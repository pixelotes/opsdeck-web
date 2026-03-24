# Credentials Vault

Store and manage sensitive credentials (API keys, service account passwords, shared secrets) with encryption at rest and access control.

## Storing credentials

1. Navigate to **Security → Credentials**.
2. Click **Add Credential**.
3. Provide: name, description, category, and the secret value.
4. The secret is encrypted using Fernet symmetric encryption (from the `cryptography` library) before storage.
5. Optionally set a **rotation date** to track when the credential should be changed.

## Access control

- Viewing decrypted secrets requires explicit permission (`can_read` on the credentials module).
- The credential list shows metadata (name, category, rotation date) without revealing secrets.
- Clicking **Reveal** decrypts and displays the secret temporarily.
- All reveal actions are logged in the audit trail.

## Credential rotation tracking

- Set a rotation date when creating or updating a credential.
- The dashboard and reports show credentials approaching or past their rotation date.
- After rotating a credential in the external system, update the stored value and reset the rotation date.

!!! warning
    The encryption key is derived from your `SECRET_KEY`. If you change `SECRET_KEY`, all stored credentials become unreadable. Always back up your `SECRET_KEY` securely.
