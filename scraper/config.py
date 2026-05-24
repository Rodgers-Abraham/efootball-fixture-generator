"""
Scraper configuration — pesmaster.com/efootball-2022
"""

import os
from dotenv import load_dotenv

load_dotenv()

# ── Supabase ────────────────────────────────────────────────────
SUPABASE_URL: str = os.environ["SUPABASE_URL"]
SUPABASE_SERVICE_ROLE_KEY: str = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
TABLE_NAME = "player_cards"

# ── Target ──────────────────────────────────────────────────────
BASE_URL = "https://www.pesmaster.com"
FEATURED_URL = f"{BASE_URL}/efootball-2022/player/featured/"
SEARCH_URL   = f"{BASE_URL}/efootball-2022/search/"

# ── Card type inference from frame image series prefix ──────────
#
# pesmaster encodes card type in the Variation2022 frame image filename:
#   /efootball-2022/graphics/players/Variation2022/{SERIES}_{variant}_b01.png
#
# SERIES ranges (confirmed from live data across multiple release dates):
#
#   300–399  →  Show Time   (gold frame, OVR 90+, top weekly specials)
#   400–499  →  Show Time   (alternate Show Time variants)
#   500–599  →  Highlight   (legends & event specials, OVR 85–90)
#   600–699  →  Epic        (standard premium featured, OVR 75–85)
#   700–799  →  Big Time    (max-level boosted cards, OVR 95–105+)
#   800–899  →  POTW        (Player of the Week awards)
#   900–999  →  POTW        (alternate POTW variants)
#
# Note: POTW (800–999) is estimated — extend if a new series appears.
# Run --inspect featured on a known POTW release date to verify.
FRAME_SERIES_MAP: dict[tuple[int, int], str] = {
    (300, 499): "Show Time",
    (500, 599): "Highlight",
    (600, 699): "Epic",
    (700, 799): "Big Time",
    (800, 999): "POTW",
}

# Keyword fallback: if frame series is unknown, match these substrings
# in the card image filename or surrounding HTML text.
KEYWORD_TYPE_MAP: dict[str, str] = {
    "potw":      "POTW",
    "player of": "POTW",
    "highlight": "Highlight",
    "show time": "Show Time",
    "showtime":  "Show Time",
    "big time":  "Big Time",
    "bigtime":   "Big Time",
    "epic":      "Epic",
}

DEFAULT_FEATURED_TYPE = "Epic"    # fallback for any unrecognised featured series
DEFAULT_SEARCH_TYPE   = "Standard"

# Skip cards with OVR below this
MIN_RATING = 60

# ── Browser ─────────────────────────────────────────────────────
PAGE_LOAD_TIMEOUT_MS  = 30_000
NETWORK_IDLE_TIMEOUT  = 15_000
SCROLL_PAUSE_MS       = 1_500
PAGE_DELAY_SECONDS    = 1.2
MAX_FEATURED_PAGES    = None   # None = all history; set an int to limit

# ── Upload ──────────────────────────────────────────────────────
UPSERT_BATCH_SIZE = 100
