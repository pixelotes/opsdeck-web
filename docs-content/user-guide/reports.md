# Reports & Search

<!-- TODO: screenshot of a generated report (e.g., compliance summary or asset inventory) -->

OpsDeck includes built-in reports and a universal search engine for cross-entity discovery.

## Built-in reports

Available from **Reports** in the sidebar:

| Report | Content |
|---|---|
| Asset inventory | Complete asset list with status, location, assignment, and warranty |
| Asset reports | Distribution charts including an **Assets by Brand** breakdown |
| Assets dashboard | Fleet analytics with **fleet distribution by brand** and a **breakdown rate by brand** chart (repair rate per manufacturer over 12 months) |
| Compliance summary | Per-framework control status and evidence coverage |
| Spend analysis | Actual (past) spend across assets, peripherals, standalone licenses and subscriptions, normalised to EUR — see below |
| Subscription forecast | 12-month renewal projection with cost breakdown (this is the **future** view; spend analysis is the **past** view) |
| UAR findings | Open findings across all comparisons |
| Risk register | All risks with scoring, treatment, and status |
| Certificate status | Certificates by expiry date |
| Training compliance | Course completion rates per user and group |

Reports can be exported as CSV or PDF (via WeasyPrint).

## Spend analysis

The spend analysis report (**Reports → Spend Analysis**, permission `finance`) shows **actual past spend**, not a forecast. It combines:

- **One-off purchases** — assets, peripherals, and standalone (perpetual) licenses, counted once at their purchase date.
- **Subscriptions** — recurring spend reconstructed from billing history. Every billing occurrence in the selected window is enumerated over the renewal schedule and valued at the cost that was **effective on that charge date**, taken from the subscription's cost history.

All amounts are normalised to **EUR** using the configured exchange rates, and a **Spend by Month (EUR)** summary breaks the total down per calendar month.

### How subscription spend is reconstructed

Subscription prices and seat counts change over time. OpsDeck keeps a cost history for each subscription (recorded on creation, on cost edits, and when per-user seats change — including from the subscription's own user management). For each billing date, the report uses the **most recent cost-history entry on or before that date**; when several changes happen on the same day, the last one recorded that day wins (it is the state that stood at billing time).

!!! note "Reconstruction, not invoices"
    This is a faithful reconstruction from the recorded cost history and renewal schedule — not imported invoices. It does not model proration, taxes, discounts, or one-off credits. Periods before a subscription's first recorded cost fall back to its current cost.

### Filters and window

The report filters by date range, item type (all / assets / peripherals / licenses / subscriptions), supplier, brand, user, group, and location. Brand and location apply only to hardware, so selecting either excludes subscriptions. When no date range is given, subscription spend defaults to the **trailing 12 months**.

## Universal search

Access via the search icon in the top navigation bar:

1. Enter a query — searches across names, descriptions, serial numbers, notes, and custom field values.
2. Results are grouped by entity type (assets, users, incidents, suppliers, etc.) with result counts.
3. Apply **faceted filters**: entity type, status, date range, severity.
4. Click any result to navigate to its detail page.

The search service (`search_service.py`) queries all configured entity types in parallel and merges results.

## Export options

Most list views and reports support:

- **CSV export** — all columns, respecting current filters.
- **PDF export** — formatted report using WeasyPrint with headers, pagination, and summary statistics.
