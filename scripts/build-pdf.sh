#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WEB_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$WEB_DIR/docs-content"
BACKUP_DIR=$(mktemp -d)

# Auto-detect Chrome/Chromium binary and generate mkdocs-pdf.yml override
for bin in chromium-browser chromium google-chrome google-chrome-stable; do
  if command -v "$bin" &>/dev/null; then
    CHROME_BIN="$bin"
    break
  fi
done

if [ -z "$CHROME_BIN" ]; then
  echo "==> ERROR: No Chrome/Chromium binary found"
  exit 1
fi

echo "==> Using headless browser: $CHROME_BIN"
sed -i "s|headless_chrome_path:.*|headless_chrome_path: $CHROME_BIN|" "$WEB_DIR/mkdocs-pdf.yml"

echo "==> Backing up docs-content..."
cp -a "$DOCS_DIR/." "$BACKUP_DIR/"

restore() {
  echo "==> Restoring original docs-content..."
  rm -rf "$DOCS_DIR"
  mkdir -p "$DOCS_DIR"
  cp -a "$BACKUP_DIR/." "$DOCS_DIR/"
  rm -rf "$BACKUP_DIR"
}
trap restore EXIT

echo "==> Rendering mermaid diagrams to PNG..."
python "$SCRIPT_DIR/render-mermaid.py" "$DOCS_DIR"

echo "==> Building PDF with MkDocs..."
cd "$WEB_DIR"
mkdocs build -f mkdocs-pdf.yml

PDF_PATH="$WEB_DIR/dist/docs/export/opsdeck-docs.pdf"
if [ -f "$PDF_PATH" ]; then
  echo "==> PDF generated: $PDF_PATH ($(du -h "$PDF_PATH" | cut -f1))"
else
  echo "==> ERROR: PDF was not generated"
  exit 1
fi
