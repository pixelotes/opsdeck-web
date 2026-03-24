# Risk Assessment

Risk assessments provide a structured workflow for evaluating threats across a defined scope, producing documented findings with evidence.

## Assessment workflow

1. Navigate to **Security → Risk Assessments**.
2. Click **Create Assessment**.
3. Define the scope: which assets, services, or business areas are being assessed.
4. For each identified risk, create a `RiskAssessmentItem`:
    - Describe the threat.
    - Score impact and likelihood.
    - Document existing controls.
    - Attach evidence (screenshots, reports, configurations).
5. Set a **validity period** — the date range during which this assessment is considered current.
6. Complete the assessment to finalize findings.

## Evidence attachment

Each assessment item supports evidence attachments:

- Upload files (PDFs, screenshots, configuration exports).
- Link to existing OpsDeck entities (assets, policies, compliance controls).
- Evidence is stored as `RiskAssessmentEvidence` records.

## Assessment reports

Generate a summary report from the assessment detail page, including:

- Scope and methodology.
- Findings with scoring and evidence references.
- Recommended treatment plans.
- Risk heat map (impact vs. likelihood matrix).

## Relationship to risk register

Findings from a risk assessment can be promoted to the risk register:

- Click **Add to Risk Register** on any assessment item.
- A `Risk` record is created with the scoring and context from the assessment.
- The assessment item links back to the risk for traceability.
