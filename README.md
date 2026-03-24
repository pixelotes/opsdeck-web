# OpsDeck Web

Marketing website, API documentation, and user guides for [OpsDeck](https://github.com/pixelotes/opsdeck) — an open-source IT Operations & Governance platform for mid-market teams in regulated industries.

## What's in this repo

- **Landing page** — Product overview, feature tour, pricing, and OSS vs Enterprise comparison.
- **API reference** — Interactive Swagger UI page that loads the OpsDeck OpenAPI spec.
- **Documentation** — User guides, deployment instructions, architecture docs, FAQ, and changelog (built with MkDocs).
- **PDF export** — Scripts to generate offline PDF versions of the documentation.

## Tech stack

- [Astro](https://astro.build/) + TypeScript (static site)
- [TailwindCSS](https://tailwindcss.com/) (styling)
- [MkDocs Material](https://squidfunnel.github.io/mkdocs-material/) (documentation)
- [Puppeteer](https://pptr.dev/) (PDF generation)

## Getting started

```bash
# Install dependencies
npm install

# For PDF generation (optional)
pip install -r requirements-docs.txt
```

### Development

```bash
# Website dev server
npm run dev

# Documentation dev server
npm run dev:docs
```

### Build

```bash
# Build everything (website + docs)
npm run build

# Build only the website
npm run build:site

# Build only the docs
npm run build:docs

# Generate PDF docs
npm run build:pdf
```

### Preview

```bash
npm run preview
```

## Project structure

```
src/
  components/   # Astro UI components (Hero, Features, Pricing, etc.)
  layouts/      # Base HTML layout
  pages/        # index and api-reference pages
docs-content/   # MkDocs markdown source
  user-guide/   # Module usage guides
  deployment/   # Installation & deployment
  architecture/ # System design & technical docs
scripts/        # Build automation (PDF export, Mermaid rendering)
```

## License

[Elastic License 2.0](LICENSE)
