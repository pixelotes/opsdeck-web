# REST API

OpsDeck provides a REST API for programmatic access to all major entities, built with flask-smorest and documented via OpenAPI/Swagger.

## Authentication

All API requests require a bearer token in the `Authorization` header:

```
Authorization: Bearer <your-api-token>
```

### Generating a token

1. Navigate to your **User Profile**.
2. Scroll to **Developer Settings (API)**.
3. Click **Generate New Token**.
4. Copy the token immediately — it's displayed only once.

The token inherits the permissions of the owning user. Tokens are hashed (SHA-256) before storage and can be revoked from the user profile.

## Swagger UI

Interactive API documentation is available at:

```
https://your-opsdeck-instance/swagger-ui
```

The Swagger UI lets you browse endpoints, see request/response schemas, and test API calls directly from the browser (with a valid token).

## Supported endpoints

The API covers the following entities under `/api/v1/`:

| Endpoint | Methods | Entity |
|---|---|---|
| `/api/v1/users` | GET, POST | Users (POST upserts by email) |
| `/api/v1/assets` | GET | Hardware assets |
| `/api/v1/peripherals` | GET | Peripherals |
| `/api/v1/licenses` | GET | Software licenses |
| `/api/v1/subscriptions` | GET | SaaS subscriptions |
| `/api/v1/services` | GET | Business services |
| `/api/v1/suppliers` | GET | Suppliers |
| `/api/v1/contacts` | GET | Supplier contacts |
| `/api/v1/changes` | GET, POST | Change records |
| `/api/v1/requests` | GET, POST | Service requests |
| `/api/v1/incidents` | POST | Security incidents |
| `/api/v1/onboardings` | POST | Onboarding processes |

GET endpoints list records (`GET /…`) and fetch a single record by id (`GET /…/{id}`); `incidents` and `onboardings` are write-only (POST upsert) and have no GET. Each list endpoint accepts `limit` and `offset` query parameters.

## Upsert with `external_ref`

The writable endpoints (`changes`, `requests`, `incidents`, `onboardings`) are designed for integration with external systems and behave as **idempotent upserts**. Include an `external_ref` — your own stable identifier, such as a ticket key — in the POST body:

- If no record with that `external_ref` exists, a new one is created and the response is **`201 Created`**.
- If one already exists, it is updated in place and the response is **`200 OK`**.

This lets an external system (a ticketing tool, a SIEM, a script) push the same record repeatedly without creating duplicates. `external_ref` is unique per entity. Omitting it always creates a new record.

```bash
# First call creates the change (201); a later call with the same
# external_ref updates it in place (200).
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
        "title": "Deploy v2.0",
        "change_type": "Normal",
        "status": "In Progress",
        "external_ref": "JIRA-1234"
      }' \
  https://opsdeck.example.com/api/v1/changes
```

Users are also upsertable, keyed by **email** rather than `external_ref` (this is how the [Google Users import](data-import.md#google-workspace-import) avoids duplicates).

## Pagination

List endpoints return a plain JSON array and accept `limit` and `offset` query parameters (defaults: `limit=100`, `offset=0`):

```
GET /api/v1/assets?limit=25&offset=50
```

## Example: list all assets

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://opsdeck.example.com/api/v1/assets
```

## Example: create a service request

```bash
# Upsert by external_ref; resolves requester/assignee by email or name.
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
        "title": "Laptop for new hire",
        "request_type": "Hardware",
        "priority": "High",
        "assignee": "it-support@example.com",
        "external_ref": "SD-5678"
      }' \
  https://opsdeck.example.com/api/v1/requests
```

## Example: create an incident

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title": "Unauthorized access attempt", "severity": "SEV-1", "description": "..."}' \
  https://opsdeck.example.com/api/v1/incidents
```
