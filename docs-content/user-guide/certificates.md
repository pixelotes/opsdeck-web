# Certificates

Track TLS/SSL certificates and other digital certificates with expiry alerting and version history.

## Certificate tracking

1. Navigate to **Security → Certificates**.
2. Click **Add Certificate**.
3. Provide: name, domain/subject, issuer, and expiry date.
4. Link to the services or assets that use this certificate.

## Expiry alerts

- The scheduler checks daily for certificates approaching expiry.
- Notifications are sent based on configured lead times (e.g., 30, 14, 7 days before expiry).
- Expired certificates are flagged on the dashboard.

## Certificate versions

When renewing a certificate:

1. Create a new `CertificateVersion` on the existing certificate record.
2. Update the expiry date and any changed details (issuer, key type).
3. Previous versions are preserved in the history.

## Linking to infrastructure

Link certificates to:

- **Business services** that use them (customer portal, API gateway).
- **Assets** that host them (load balancers, web servers).
- **Compliance controls** related to encryption requirements.
