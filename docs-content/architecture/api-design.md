# API Design

The REST API is built with flask-smorest, which provides OpenAPI (Swagger) spec generation, request validation, and response serialization.

## Architecture

```
src/api.py          # Blueprint registration, token auth hook
src/schemas.py      # Marshmallow schemas (auto-generated from SQLAlchemy models)
```

The API blueprint is registered at `/api/v1/` with a `before_request` hook that validates bearer tokens on every request.

## REST conventions

| Verb | Usage |
|---|---|
| `GET /api/v1/{resource}` | List entities (paginated) |
| `GET /api/v1/{resource}/{id}` | Get single entity |
| `POST /api/v1/{resource}` | Create entity (writable resources only) |

Currently, most resources are read-only (GET). Writable endpoints exist for changes, incidents, and onboarding processes.

## Authentication

Bearer token in the `Authorization` header. The `check_token()` hook:

1. Extracts the token from `Authorization: Bearer <token>`.
2. Looks up the user by token value.
3. Sets `g.api_user` for the request context.
4. Returns 401 if the token is missing or invalid.
5. Logs all access attempts (success and failure) in ECS format.

## Marshmallow schemas

Schemas are auto-generated from SQLAlchemy models using `marshmallow-sqlalchemy`:

```python
class AssetSchema(BaseSchema):
    custom_properties = fields.Dict(dump_only=True)
    class Meta(BaseSchema.Meta):
        model = Asset
```

This provides:

- Automatic field mapping from model columns.
- Exclusion of sensitive fields (e.g., `password_hash`, `api_token` on UserSchema).
- JSON serialization of complex types (dates, enums, relationships).
- Custom properties exposed as a flat dict.

## OpenAPI spec

flask-smorest auto-generates an OpenAPI 3.0 spec from the registered blueprints and schemas. Available at:

- `/openapi.json` — raw spec.
- `/swagger-ui` — interactive documentation UI (Swagger UI).

## Pagination

List endpoints accept `page` and `page_size` query parameters. Responses include pagination metadata:

```json
{
  "items": [...],
  "total": 142,
  "page": 1,
  "page_size": 25,
  "pages": 6
}
```

Default page size is 25. Maximum page size is 100.
