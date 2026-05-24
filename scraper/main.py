#!/usr/bin/env python3
"""
eFootball Player Card Scraper — pesmaster.com

Modes:
  python main.py                        # scrape featured + search, upload all
  python main.py --mode featured        # premium cards only (Show Time/Epic/Big Time)
  python main.py --mode search          # Standard base cards only
  python main.py --dry-run              # scrape, print, no DB write
  python main.py --limit 5             # stop after 5 featured pages (~35 cards)
  python main.py --card-type "Epic"    # filter by card type
  python main.py --inspect featured    # print raw HTML of featured page 1
  python main.py --inspect search      # print raw HTML of search page
  python main.py --no-headless         # show browser window (debug)
  python main.py --clean               # remove stale cards after upload
"""

import argparse
import logging
import sys
from collections import Counter

from tqdm import tqdm

from scraper import EFootballScraper
from scraper_api import scrape_efworld
from uploader import make_client, upsert_cards, delete_stale_cards
from models import PlayerCard

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s — %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
log = logging.getLogger("main")


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Scrape eFootball player cards from pesmaster.com and sync to Supabase."
    )
    p.add_argument("--mode", choices=["featured", "search", "both", "efworld", "all"],
                   default="efworld",
                   help="Scrape source: efworld=efootball-world.com API (default), "
                        "featured=pesmaster weekly, search=pesmaster base, "
                        "both=pesmaster featured+search, all=every source.")
    p.add_argument("--dry-run", action="store_true",
                   help="Scrape but do NOT write to Supabase.")
    p.add_argument("--limit", type=int, default=None, metavar="N",
                   help="Stop featured scrape after N pages (≈7 cards/page).")
    p.add_argument("--start-date", type=str, default=None, metavar="YYYY-MM-DD",
                   help="Start featured scrape from this release date instead of today.")
    p.add_argument("--card-type", type=str, default=None, metavar="TYPE",
                   choices=["Show Time", "Epic", "Big Time", "Standard"],
                   help="Only keep this card type.")
    p.add_argument("--clean", action="store_true",
                   help="Delete stale DB cards after upload.")
    p.add_argument("--inspect", choices=["featured", "search"],
                   help="Print raw HTML of the chosen page and exit.")
    p.add_argument("--no-headless", action="store_true",
                   help="Show browser window while scraping.")
    p.add_argument("--verbose", action="store_true",
                   help="Debug-level logging.")
    return p.parse_args()


def deduplicate(cards: list[PlayerCard]) -> list[PlayerCard]:
    """
    Deduplicate by source_id when available (keeps every distinct card version,
    so Mbappé POTW and Mbappé Show Time are separate rows).
    Only falls back to (player_name, card_type) for cards with no source_id.
    """
    seen_source: dict[str, PlayerCard] = {}
    seen_fallback: dict[tuple[str, str], PlayerCard] = {}

    for card in cards:
        if card.source_id:
            seen_source[card.source_id] = card
        else:
            key = (card.player_name, card.card_type)
            if key not in seen_fallback or card.max_rating > seen_fallback[key].max_rating:
                seen_fallback[key] = card

    return list(seen_source.values()) + list(seen_fallback.values())


def main() -> None:
    args = parse_args()
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    headless = not args.no_headless

    # ── Inspect mode ─────────────────────────────────────────────
    if args.inspect:
        log.info("Inspect mode — fetching %s page HTML…", args.inspect)
        with EFootballScraper(headless=headless) as spider:
            html = (spider.inspect_featured() if args.inspect == "featured"
                    else spider.inspect_search())
        if html:
            print("\n── RAW HTML (first 6000 chars) ─────────────────────\n")
            print(html[:6000])
            print(f"\n── Total length: {len(html):,} chars ────────────────")
        else:
            print("Failed to load page.")
        return

    # ── Scrape ───────────────────────────────────────────────────
    log.info("Mode=%s  limit=%s  card_type=%s  headless=%s",
             args.mode, args.limit, args.card_type, headless)

    all_cards: list[PlayerCard] = []

    # ── efworld API (fast, no browser) ─────────────────────────
    if args.mode in ("efworld", "all"):
        type_filter = [args.card_type] if args.card_type else None
        efworld_cards = scrape_efworld(
            card_types=type_filter,
            max_pages=args.limit,
        )
        all_cards.extend(efworld_cards)
        log.info("efworld cards collected: %d", len(efworld_cards))

    # ── pesmaster browser scraper ───────────────────────────────
    if args.mode in ("featured", "both", "search", "all"):
        with EFootballScraper(headless=headless) as spider:

            if args.mode in ("featured", "both", "all"):
                featured = spider.scrape_featured(
                    max_pages=args.limit,
                    card_type_filter=args.card_type,
                    start_date=args.start_date,
                )
                all_cards.extend(featured)
                log.info("pesmaster featured cards: %d", len(featured))

            if args.mode in ("search", "both", "all"):
                skip = {c.player_name for c in all_cards}
                standard = spider.scrape_search(skip_names=skip)
                if args.card_type:
                    standard = [c for c in standard if c.card_type == args.card_type]
                all_cards.extend(standard)
                log.info("pesmaster search (Standard) cards: %d", len(standard))

    cards = deduplicate(all_cards)
    log.info("After deduplication: %d unique cards (from %d raw).",
             len(cards), len(all_cards))

    if not cards:
        log.warning("No cards scraped. Run --inspect featured or --inspect search to debug.")
        sys.exit(0)

    # ── Preview ──────────────────────────────────────────────────
    print("\n── Sample cards ────────────────────────────────────")
    for card in cards[:10]:
        print(f"  {card}")
    if len(cards) > 10:
        print(f"  … and {len(cards) - 10} more")

    breakdown = Counter(c.card_type for c in cards)
    print("\n── Card type breakdown ─────────────────────────────")
    for ctype, count in breakdown.most_common():
        print(f"  {ctype:<14} {count:>6}")
    print(f"  {'TOTAL':<14} {len(cards):>6}\n")

    if args.dry_run:
        log.info("Dry-run — skipping Supabase upload.")
        return

    # ── Upload ───────────────────────────────────────────────────
    log.info("Connecting to Supabase…")
    try:
        client = make_client()
    except Exception as exc:
        log.error("Supabase connection failed: %s", exc)
        sys.exit(1)

    log.info("Upserting %d cards…", len(cards))
    with tqdm(total=len(cards), unit="cards", desc="Uploading") as bar:
        for i in range(0, len(cards), 100):
            batch = cards[i : i + 100]
            upsert_cards(client, batch)
            bar.update(len(batch))

    log.info("Upload complete.")

    if args.clean:
        log.info("Removing stale cards…")
        names = {c.player_name for c in cards}
        deleted = delete_stale_cards(client, names, card_type=args.card_type)
        log.info("Deleted %d stale cards.", deleted)

    log.info("Done.")


if __name__ == "__main__":
    main()
