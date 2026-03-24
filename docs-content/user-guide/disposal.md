# Disposal

Manage end-of-life processes for hardware assets with method tracking and audit trail.

## Disposal workflow

1. Change the asset status to **Awaiting Disposal**.
2. Navigate to **Assets → Disposals** or click **Create Disposal** from the asset detail page.
3. Record:
    - **Method** — e-waste recycling, resale, donation, destruction.
    - **Date** of disposal.
    - **Certificate** — upload disposal certificate from the vendor if applicable.
    - **Proceeds** — any financial return from resale.
4. Complete the disposal — the asset status changes to **Disposed**.

## Audit trail

Disposed assets remain in the database with full history: procurement, assignments, maintenance, and disposal. This satisfies audit requirements for asset lifecycle documentation (ISO 27001 A.8).

The `DisposalHistory` model tracks status changes within the disposal workflow itself (from awaiting to completed).
