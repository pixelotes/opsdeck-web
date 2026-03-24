# Policy Management

Manage organizational policies with version control and acknowledgment tracking.

## Creating policies

1. Navigate to **Compliance → Policies**.
2. Click **Add Policy**.
3. Provide: title, description, and effective date.
4. Upload the policy document (PDF).
5. Set a **review schedule** (e.g., annual review).
6. Assign to users or groups for acknowledgment.

## Policy versions

Policies support versioning:

- When updating a policy, create a new `PolicyVersion` rather than overwriting.
- Previous versions are preserved for audit trail.
- Users who acknowledged a previous version may need to re-acknowledge the new version.

## Acknowledgment workflows

1. Assign users or groups to a policy.
2. Users see pending acknowledgments on their dashboard.
3. The user opens the policy, reads it, and clicks **Acknowledge**.
4. A `PolicyAcknowledgement` record is created with user ID and timestamp.
5. The tracking report shows acknowledgment rates per policy.

!!! tip
    Link policies to compliance controls to demonstrate that governance requirements are met and that staff have been informed.

## Compliance integration

Policies are one of the most common evidence types linked to compliance controls. Examples:

- Information Security Policy → ISO 27001 A.5.1
- Acceptable Use Policy → SOC 2 CC1.1
- Data Classification Policy → ISO 27001 A.8.2
