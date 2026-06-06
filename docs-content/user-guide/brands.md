# Hardware Brands

<!-- TODO: screenshot of the brand list and the brand breakdown chart -->

Brands are first-class entities in OpsDeck. Managing manufacturers as their own records (rather than as free-text on each asset) keeps naming consistent and unlocks brand-level reporting across the fleet.

- **Menu path**: **Core Inventory → Brands**
- **URL**: `/brands/`

## Managing brands

1. Navigate to **Core Inventory → Brands**.
2. Click **Add Brand**.
3. Provide a **name** (required, unique), and optionally a **website** and **notes**.

A brand can be referenced by:

- **Asset models** — a model belongs to a brand.
- **Assets** — hardware assets carry a brand.
- **Peripherals** — peripherals carry a brand.

Deleting a brand is blocked while records still reference it.

## Brand reporting

Because brands are structured data, they feed two reporting views:

- **Asset reports** (**Reports → Asset Reports**) include an *Assets by Brand* breakdown; assets without a brand are grouped under *N/A*.
- The **assets dashboard** (**Reports → Assets Dashboard**) adds two brand charts:
    - **Fleet distribution by brand** — how the fleet splits across manufacturers.
    - **Breakdown rate by brand** — repair/incident rate per brand over the last 12 months, useful for spotting unreliable hardware.

See [Reports & Search](reports.md) for the full reporting catalog.
