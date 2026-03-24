# Business Continuity & Disaster Recovery

Document BCDR plans and track test execution to demonstrate resilience readiness.

## BCDR plans

1. Navigate to **Security → BCDR**.
2. Click **Add Plan**.
3. Document:
    - **Plan scope** — which services and systems are covered.
    - **Recovery objectives** — RTO (Recovery Time Objective) and RPO (Recovery Point Objective).
    - **Procedures** — step-by-step recovery instructions.
    - **Responsible parties** — who executes the plan.
4. Link to the business services covered by the plan.

## Test log tracking

Regular BCDR testing is required by most compliance frameworks:

1. From the plan detail page, click **Log Test**.
2. Record: test date, test type (tabletop, simulation, full failover), and results.
3. Document lessons learned and any plan updates needed.
4. `BCDRTestLog` records provide evidence for compliance controls.

## Linking to compliance

BCDR plans and test logs are commonly linked to:

- ISO 27001 A.17 — Information security aspects of business continuity management.
- SOC 2 A1 — Additional criteria for availability.
