# Frameworks & Controls

OpsDeck's compliance engine is built around frameworks — structured collections of controls that define your regulatory or security requirements.

## Supported frameworks

OpsDeck ships with templates for:

- **ISO 27001:2022** — information security management controls.
- **SOC 2** — trust service criteria (security, availability, processing integrity, confidentiality, privacy).

You can also create **custom frameworks** for internal policies, industry regulations, or client-specific requirements.

## Importing a framework

1. Navigate to **Compliance → Frameworks**.
2. Click **Add Framework**.
3. Choose from a template or create a blank framework.
4. For templates, controls are pre-populated with standard numbering and descriptions.
5. Customize as needed — add, remove, or modify controls.

## Framework controls

Each control represents a single requirement:

- **Reference** — control number (e.g., A.8.1, CC6.1).
- **Title** — short description.
- **Description** — full requirement text.
- **Category/Section** — grouping within the framework.
- **Status** — compliance status (see [Compliance Dashboard](compliance.md)).

## Mapping controls to evidence

Controls are connected to evidence through **Compliance Links** — the polymorphic linking system that connects any entity to any control. See [Compliance Dashboard](compliance.md) for details on evidence linking workflows.

## Statement of Applicability (SoA)

For ISO 27001, the Statement of Applicability documents which controls are in scope and which are excluded with justification. OpsDeck supports this through:

- Marking controls as applicable or excluded.
- Adding justification notes for excluded controls.
- Generating an SoA report from the framework view.
