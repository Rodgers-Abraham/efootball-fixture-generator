"""
API-based scrapers — no Playwright needed.

efootball-world.com  →  POST /api/proxy/v1/api/players/search
  Returns paginated JSON with name, type, overallRating, imageUrl.
  Supports type filters: SHOWTIME | EPIC | BIGTIME | HIGHLIGHT | TRENDING
  8,003 cards total (161 pages @ 50 per page).

efhub.com  →  GET /api/public/players (page 1 only, returns ~25 cards, rest is 403)
  Used only as a source of the efimg.com card image CDN pattern:
    https://efimg.com/efootballhub22/images/player_cards/{player_id}_l.png
  The player IDs are identical to efworld IDs, so we can construct
  efhub images for any efworld card.
"""

import time
import logging
from typing import Iterator

import requests
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

from models import PlayerCard

log = logging.getLogger(__name__)

# ── efootball-world.com ──────────────────────────────────────────

EFWORLD_SEARCH_URL = "https://efootball-world.com/api/proxy/v1/api/players/search"

EFWORLD_TYPE_MAP = {
    "SHOWTIME":  "Show Time",
    "EPIC":      "Epic",
    "BIGTIME":   "Big Time",
    "HIGHLIGHT": "Highlight",
    "TRENDING":  "POTW",
}

EFWORLD_HEADERS = {
    "User-Agent":   "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124.0",
    "Accept":       "application/json",
    "Content-Type": "application/json",
    "Referer":      "https://efootball-world.com/player",
    "Origin":       "https://efootball-world.com",
}

PAGE_SIZE   = 50
PAGE_DELAY  = 0.8   # polite delay between pages (seconds)
MIN_RATING  = 60


def scrape_efworld(
    card_types: list[str] | None = None,
    max_pages: int | None = None,
) -> list[PlayerCard]:
    """
    Scrape all cards from efootball-world.com via its REST API.

    Args:
        card_types: subset of ["Show Time","Epic","Big Time","Highlight","POTW"]
                    — if None, all types are fetched.
        max_pages:  stop after this many pages per type batch (None = all).
    """
    # Map our DB names back to efworld API names
    reverse_map = {v: k for k, v in EFWORLD_TYPE_MAP.items()}
    if card_types:
        api_types = [reverse_map[t] for t in card_types if t in reverse_map]
    else:
        api_types = list(EFWORLD_TYPE_MAP.keys())

    all_cards: list[PlayerCard] = []
    session = requests.Session()
    session.headers.update(EFWORLD_HEADERS)

    for api_type in api_types:
        db_type = EFWORLD_TYPE_MAP[api_type]
        log.info("efworld — fetching %s (%s)…", api_type, db_type)
        cards = list(_efworld_pages(session, api_type, max_pages))
        log.info("  → %d %s cards", len(cards), db_type)
        all_cards.extend(cards)
        time.sleep(PAGE_DELAY)

    return all_cards


def _efworld_pages(
    session: requests.Session,
    api_type: str,
    max_pages: int | None,
) -> Iterator[PlayerCard]:
    db_type = EFWORLD_TYPE_MAP[api_type]
    page = 1

    while True:
        if max_pages and page > max_pages:
            break

        data = _efworld_fetch(session, api_type, page)
        if not data:
            break

        players = data.get("players", [])
        if not players:
            break

        for p in players:
            card = _efworld_card(p, db_type)
            if card:
                yield card

        if not data.get("hasNext", False):
            break

        page += 1
        time.sleep(PAGE_DELAY)


@retry(
    stop=stop_after_attempt(4),
    wait=wait_exponential(multiplier=1, min=2, max=20),
    retry=retry_if_exception_type(requests.RequestException),
    reraise=True,
)
def _efworld_fetch(session: requests.Session, api_type: str, page: int) -> dict | None:
    try:
        resp = session.post(
            EFWORLD_SEARCH_URL,
            json={
                "sortBy":    "CREATED_AT",
                "sortOrder": "DESC",
                "page":      page,
                "size":      PAGE_SIZE,
                "types":     [api_type],
            },
            timeout=15,
        )
        resp.raise_for_status()
        return resp.json()
    except requests.HTTPError as e:
        log.warning("efworld HTTP %s on page %d type %s", e.response.status_code, page, api_type)
        return None


def _efworld_card(p: dict, db_type: str) -> PlayerCard | None:
    try:
        name = (p.get("name") or "").strip()
        if not name:
            return None
        ovr = p.get("overallRating")
        if not isinstance(ovr, int) or ovr < MIN_RATING:
            return None

        # Prefer efworld's CloudFront image; also build efhub CDN fallback
        img = p.get("imageUrl") or _efhub_img_url(p.get("id"))

        return PlayerCard(
            player_name=name,
            card_type=db_type,
            max_rating=ovr,
            card_image_url=img or None,
            source_id=str(p["id"]) if p.get("id") else None,
        )
    except Exception as exc:
        log.debug("efworld card error: %s", exc)
        return None


# ── efhub image CDN helper ───────────────────────────────────────

def _efhub_img_url(player_id: str | None) -> str | None:
    """
    efhub hosts full card art at:
      https://efimg.com/efootballhub22/images/player_cards/{id}_l.png
    Player IDs are identical to efworld IDs.
    """
    if not player_id:
        return None
    return f"https://efimg.com/efootballhub22/images/player_cards/{player_id}_l.png"
