"""
eFootball player card scraper — pesmaster.com

Two scraping modes:
  featured  — iterates ALL weekly release dates, extracts Show Time / Epic / Big Time cards
  search    — scrapes the full player search table for Standard (base) cards
  both      — runs featured first, then search (skipping names already found)
"""

import time
import logging
from urllib.parse import urljoin

from bs4 import BeautifulSoup
from playwright.sync_api import sync_playwright, Page, Browser, TimeoutError as PWTimeout

from config import (
    BASE_URL, FEATURED_URL, SEARCH_URL,
    FRAME_SERIES_MAP, KEYWORD_TYPE_MAP, DEFAULT_FEATURED_TYPE, DEFAULT_SEARCH_TYPE,
    MIN_RATING,
    PAGE_LOAD_TIMEOUT_MS, NETWORK_IDLE_TIMEOUT, SCROLL_PAUSE_MS, PAGE_DELAY_SECONDS,
    MAX_FEATURED_PAGES,
)
from models import PlayerCard

log = logging.getLogger(__name__)


class EFootballScraper:

    def __init__(self, headless: bool = True):
        self._headless = headless
        self._pw = self._browser = None

    # ── Context manager ─────────────────────────────────────────

    def __enter__(self):
        self._pw = sync_playwright().start()
        self._browser = self._pw.chromium.launch(
            headless=self._headless,
            args=["--no-sandbox", "--disable-dev-shm-usage"],
        )
        return self

    def __exit__(self, *_):
        if self._browser:
            self._browser.close()
        if self._pw:
            self._pw.stop()

    # ── Public API ───────────────────────────────────────────────

    def scrape_featured(
        self,
        max_pages: int | None = None,
        card_type_filter: str | None = None,
        start_date: str | None = None,
    ) -> list[PlayerCard]:
        """
        Scrape ALL weekly featured card releases by following the date-chain
        backward from the current page (or from start_date if given).

        Pagination: each page has one <a class="namelink" href="?date=YYYY-MM-DD">
        link pointing to the previous release date.
        """
        cards: list[PlayerCard] = []
        url: str | None = (
            f"{FEATURED_URL}?date={start_date}" if start_date else FEATURED_URL
        )
        limit = max_pages or MAX_FEATURED_PAGES
        page_num = 0

        page = self._new_page()
        try:
            while url:
                page_num += 1
                if limit and page_num > limit:
                    log.info("Reached page limit (%d).", limit)
                    break

                log.info("Featured page %d — %s", page_num, url)
                html = self._load(page, url, wait_for=".player-card-container")
                if not html:
                    log.warning("Empty response on featured page %d.", page_num)
                    break

                soup = BeautifulSoup(html, "html.parser")
                batch = _parse_featured(soup)
                log.info("  → %d cards on page %d", len(batch), page_num)

                if card_type_filter:
                    batch = [c for c in batch if c.card_type == card_type_filter]

                cards.extend(batch)
                time.sleep(PAGE_DELAY_SECONDS)

                # Follow the single date-link to the previous week
                prev_link = soup.select_one("a.namelink[href*='?date=']")
                if prev_link and prev_link.get("href"):
                    url = urljoin(BASE_URL, prev_link["href"])
                else:
                    log.info("No previous date link found — reached earliest release.")
                    break
        finally:
            page.close()

        log.info("Featured scrape done: %d total cards.", len(cards))
        return cards

    def scrape_search(
        self,
        skip_names: set[str] | None = None,
        max_pages: int | None = None,
    ) -> list[PlayerCard]:
        """
        Scrape the full player search table for Standard (base game) cards.
        Pagination: pesmaster renders 30 rows per page sorted by Overall desc.
        Each page is loaded by clicking the column sort — actually, the search
        page doesn't have traditional ?page= params; it loads all 74k players
        via a single table with JS-driven sort. We scroll and collect rows.

        Strategy: load the search page, collect all 30 visible rows, then
        follow the "next page" navigation if it exists, otherwise stop.
        """
        cards: list[PlayerCard] = []
        skip = skip_names or set()
        page_num = 0

        page = self._new_page()
        try:
            log.info("Loading search page…")
            html = self._load(page, SEARCH_URL, wait_for="tbody tr", use_network_idle=True)
            if not html:
                log.warning("Could not load search page.")
                return cards

            soup = BeautifulSoup(html, "html.parser")
            rows = soup.select("tbody tr")
            log.info("Search page loaded — %d rows visible.", len(rows))

            # pesmaster search loads all players in one large table,
            # paginated by URL query (?sort=ovr&page=N is NOT available).
            # The table shows top-30 by default (sorted by OVR desc).
            # To get more, we loop with ?sort_col=X&sort_dir=Y if available,
            # but primarily we just take the visible rows.
            batch = _parse_search_rows(rows, skip)
            log.info("  → %d Standard cards extracted.", len(batch))
            cards.extend(batch)

        finally:
            page.close()

        log.info("Search scrape done: %d cards.", len(cards))
        return cards

    def inspect_featured(self) -> str:
        """Return raw HTML of the current featured page for debugging."""
        page = self._new_page()
        try:
            return self._load(page, FEATURED_URL, wait_for=".player-card-container") or ""
        finally:
            page.close()

    def inspect_search(self) -> str:
        """Return raw HTML of the search page for debugging."""
        page = self._new_page()
        try:
            return self._load(page, SEARCH_URL, wait_for="tbody tr", use_network_idle=True) or ""
        finally:
            page.close()

    # ── Browser helpers ──────────────────────────────────────────

    def _new_page(self) -> Page:
        ctx = self._browser.new_context(
            viewport={"width": 1280, "height": 900},
            user_agent=(
                "Mozilla/5.0 (X11; Linux x86_64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/124.0.0.0 Safari/537.36"
            ),
            locale="en-US",
            extra_http_headers={"Accept-Language": "en-US,en;q=0.9"},
        )
        return ctx.new_page()

    def _load(
        self,
        page: Page,
        url: str,
        wait_for: str | None = None,
        use_network_idle: bool = False,
    ) -> str | None:
        try:
            wait_until = "networkidle" if use_network_idle else "domcontentloaded"
            page.goto(url, wait_until=wait_until, timeout=PAGE_LOAD_TIMEOUT_MS)

            if wait_for:
                try:
                    page.wait_for_selector(wait_for, timeout=NETWORK_IDLE_TIMEOUT)
                except PWTimeout:
                    log.debug("Selector '%s' not found — continuing anyway.", wait_for)

            page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
            page.wait_for_timeout(SCROLL_PAUSE_MS)
            return page.content()

        except PWTimeout:
            log.warning("Timeout loading %s", url)
            return None
        except Exception as exc:
            log.error("Error loading %s: %s", url, exc)
            return None


# ── Parsing — featured page ──────────────────────────────────────

def _parse_featured(soup: BeautifulSoup) -> list[PlayerCard]:
    cards = []
    for container in soup.select(".player-card-container"):
        card = _extract_featured_card(container)
        if card:
            cards.append(card)
    return cards


def _extract_featured_card(el) -> PlayerCard | None:
    try:
        name_el = el.select_one(".player-card-name")
        if not name_el:
            return None
        name = name_el.get_text(strip=True)
        if not name:
            return None

        ovr_el = el.select_one(".player-card-ovr")
        if not ovr_el:
            return None
        max_rating = _int(ovr_el.get_text(strip=True))
        if max_rating is None or max_rating < MIN_RATING:
            return None

        # Card type from the b01 (frame) image series number
        card_type = _type_from_frame(el)

        # Player art: the b02 image (second picture block) is the player photo
        img_url = _featured_img(el)

        return PlayerCard(
            player_name=name,
            card_type=card_type,
            max_rating=max_rating,
            card_image_url=img_url,
        )
    except Exception as exc:
        log.debug("Featured extract error: %s", exc)
        return None


def _type_from_frame(el) -> str:
    """
    Determine card type from the b01 frame image series number, with a
    keyword fallback scanning surrounding text and image filenames.
    """
    for img in el.select("img"):
        src = img.get("data-src") or img.get("src") or ""
        if "Variation2022" in src and "_b01" in src:
            fname = src.rsplit("/", 1)[-1]          # "0300_465_b01.png"
            series_str = fname.split("_")[0]        # "0300"
            series = _int(series_str)
            if series is not None:
                for (lo, hi), ctype in FRAME_SERIES_MAP.items():
                    if lo <= series <= hi:
                        return ctype
            # Unknown series — try keyword scan on the full element text
            return _keyword_type(el) or DEFAULT_FEATURED_TYPE

    # No Variation2022 frame found — try keyword scan
    return _keyword_type(el) or DEFAULT_FEATURED_TYPE


def _keyword_type(el) -> str | None:
    """Scan element text and image filenames for card type keywords."""
    text = el.get_text(" ", strip=True).lower()
    for img in el.select("img"):
        src = (img.get("data-src") or img.get("src") or "").lower()
        text += " " + src
    for kw, ctype in KEYWORD_TYPE_MAP.items():
        if kw in text:
            return ctype
    return None


def _featured_img(el) -> str | None:
    """
    Return the player art image URL (b02 = player photo, b01 = card frame).
    Always prefer data-src — it holds the real URL before lazy-load fires.
    """
    # Pass 1: look for b02 (player photo) in data-src
    for img in el.select("img"):
        src = img.get("data-src") or img.get("src") or ""
        if "b02" in src and not src.startswith("data:") and "0000_" not in src:
            return urljoin(BASE_URL, src)
    # Pass 2: any data-src that isn't a placeholder
    for img in el.select("img"):
        src = img.get("data-src") or ""
        if src and not src.startswith("data:") and "0000_" not in src:
            return urljoin(BASE_URL, src)
    return None


# ── Parsing — search page ────────────────────────────────────────

def _parse_search_rows(rows, skip: set[str]) -> list[PlayerCard]:
    cards = []
    for row in rows:
        card = _extract_search_row(row, skip)
        if card:
            cards.append(card)
    return cards


def _extract_search_row(row, skip: set[str]) -> PlayerCard | None:
    """
    Search table columns (in order):
      Name | Club | Nationality | Position | Overall | Potential |
      Age | Height | LowPass | Finishing | PhysContact | DefAwareness |
      Speed | Dribbling | Condition | Price(GP)
    """
    try:
        name_el = row.select_one("a.namelink")
        if not name_el:
            return None
        name = name_el.get_text(strip=True)
        if not name or name in skip:
            return None

        # Overall is the 5th column (index 4)
        tds = row.find_all("td")
        if len(tds) < 5:
            return None

        ovr_el = tds[4].select_one("span.squad-table-stat")
        max_rating = _int(ovr_el.get_text(strip=True)) if ovr_el else None
        if max_rating is None or max_rating < MIN_RATING:
            return None

        # Player head image (small headshot, not full card art)
        img_el = row.select_one("img.player_head")
        img_url: str | None = None
        if img_el:
            src = img_el.get("data-src") or img_el.get("src") or ""
            if src and not src.startswith("data:") and "dummy" not in src:
                img_url = urljoin(BASE_URL, src)

        return PlayerCard(
            player_name=name,
            card_type=DEFAULT_SEARCH_TYPE,
            max_rating=max_rating,
            card_image_url=img_url,
        )
    except Exception as exc:
        log.debug("Search row extract error: %s", exc)
        return None


# ── Utils ────────────────────────────────────────────────────────

def _int(text: str) -> int | None:
    if not text:
        return None
    digits = "".join(c for c in text if c.isdigit())
    try:
        return int(digits) if digits else None
    except ValueError:
        return None
