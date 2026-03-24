# Users & Groups

Manage user accounts, group memberships, role assignments, and the organization chart.

## User management

### Creating users

1. Navigate to **People → Users**.
2. Click **Add User**.
3. Provide: name, email, department, location, and role.
4. The user receives a temporary password (or uses Google OAuth if configured).
5. First login requires a password change.

### Roles

| Role | Description |
|---|---|
| **Admin** | Full system access including user management and configuration. Bypasses all permission checks. |
| **Editor** | Read/write access to operational data based on module permissions |
| **User** | Read access to assigned data with limited write permissions based on module permissions |

### Custom properties

Users support custom fields (via `CustomPropertiesMixin`). Define custom fields in **Administration → Configuration → Custom Fields** and they appear on all user forms.

## Groups

Groups provide permission inheritance — all members of a group receive the group's permissions:

1. Navigate to **People → Groups**.
2. Click **Add Group**.
3. Name the group and assign module permissions.
4. Add users as members.

When a user belongs to multiple groups, permissions are merged — the highest access level wins (WRITE > READ_ONLY).

## Organization chart

OpsDeck includes an interactive org chart:

- Navigate to **People → Organization** to view the hierarchy.
- The chart is rendered using OrgChart.js.
- `OrgChartSnapshot` records capture point-in-time snapshots of the organizational structure.

## Permission assignment

<!-- TODO: screenshot of the module permission assignment panel for a user or group -->

See [Permissions & RBAC](../architecture/permissions.md) for the technical details of how permissions are resolved and cached.
