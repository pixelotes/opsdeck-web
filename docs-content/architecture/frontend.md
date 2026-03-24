# Frontend Stack

OpsDeck uses server-rendered Jinja2 templates with Bootstrap 5, enhanced by purpose-specific JavaScript libraries. There is no SPA framework, no build step, and no JS bundler.

## Template architecture

Templates follow Jinja2's layout inheritance pattern:

```
templates/
├── layout.html              # Base layout: navbar, sidebar, footer, JS/CSS includes
├── components/              # Reusable includes: modals, forms, tables, pagination
│   ├── confirm_modal.html
│   ├── pagination.html
│   ├── compliance_links.html
│   └── ...
└── [module]/                # One directory per functional module
    ├── list.html            # Table listing with filters
    ├── detail.html          # Entity detail view
    ├── form.html            # Create/edit form
    └── ...
```

All module templates extend `layout.html` and use `{% block content %}` for page-specific content. Reusable components are included via `{% include 'components/...' %}`.

## Bootstrap 5

Bootstrap 5 (loaded from `static/vendor/`) provides:

- Responsive grid system for layout.
- Form styling and validation states.
- Card components for detail views.
- Table styling (enhanced by Simple DataTables).
- Modal dialogs for confirmations and quick actions.
- Toast notifications for feedback messages.

No custom Bootstrap build — the full distribution is used via `copy-assets.js`.

## JavaScript libraries

Each interactive need is solved by a purpose-specific library:

| Library | Version | Purpose | Where used |
|---|---|---|---|
| **Simple DataTables** | 10.2.x | Sortable, searchable, paginated tables | All list views |
| **Tom Select** | 2.5.x | Enhanced select inputs with search and tagging | Entity selection dropdowns |
| **Chart.js** | 4.5.x | Dashboard charts and visualizations | Dashboard, reports, compliance drift |
| **FullCalendar** | 6.1.x | Calendar views for scheduling | Maintenance, renewals, training |
| **Mermaid** | 11.13.x | Diagram rendering from Markdown-like syntax | Service topology, documentation |
| **SunEditor** | 2.47.x | Rich text editor (WYSIWYG) | Description fields, notes |
| **EasyMDE** | 2.20.x | Markdown editor | Documentation pages |
| **SortableJS** | 1.15.x | Drag-and-drop reordering | Onboarding pack items, priority lists |
| **Swagger UI** | 5.32.x | Interactive API documentation | `/swagger-ui` endpoint |
| **html2canvas** | 1.4.x | Client-side screenshots | Report generation |
| **OrgChart.js** | 0.0.4 | Organization chart rendering | People → Organization |
| **Font Awesome** | 7.2.x | Icons throughout the UI | Global |

## Asset pipeline

There is no Webpack, Vite, or other bundler. The asset pipeline is a simple Node.js script:

```bash
npm install        # Install packages to node_modules/
npm run build-assets  # Copies vendor files to src/static/vendor/
```

`copy-assets.js` reads `package.json` dependencies and copies the required distribution files (minified JS and CSS) to `src/static/vendor/`. Templates load these files with standard `<script>` and `<link>` tags.

## JavaScript patterns

Client-side JavaScript follows these conventions:

- **No module bundling.** Scripts are loaded globally via `<script src="...">` tags.
- **Progressive enhancement.** Core functionality works without JavaScript. JS adds interactivity (search, sort, AJAX updates) on top.
- **AJAX for partial updates.** Some actions (status toggles, inline edits, bulk operations) use `fetch()` to call route endpoints and update the DOM without full page reloads.
- **Event delegation.** Table-level event handlers manage clicks on dynamically rendered rows.
