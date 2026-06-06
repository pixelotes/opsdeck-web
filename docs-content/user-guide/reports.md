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
| Subscription forecast | 12-month renewal projection with cost breakdown |
| UAR findings | Open findings across all comparisons |
| Risk register | All risks with scoring, treatment, and status |
| Certificate status | Certificates by expiry date |
| Training compliance | Course completion rates per user and group |

Reports can be exported as CSV or PDF (via WeasyPrint).

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
