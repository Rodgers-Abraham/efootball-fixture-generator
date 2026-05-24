#!/usr/bin/env bash
# Weekly eFootball card scraper — run by cron every Thursday at 16:00 EAT
# Scrapes only the latest release batch (--limit 1) and upserts to Supabase.

set -euo pipefail

SCRAPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRAPER_DIR/scraper.log"
PYTHON="$(which python3)"

echo "=== $(date '+%Y-%m-%d %H:%M:%S %Z') — weekly scrape starting ===" >> "$LOG_FILE"

cd "$SCRAPER_DIR"

"$PYTHON" main.py \
  --mode efworld \
  --limit 1 \
  >> "$LOG_FILE" 2>&1

echo "=== $(date '+%Y-%m-%d %H:%M:%S %Z') — done ===" >> "$LOG_FILE"
