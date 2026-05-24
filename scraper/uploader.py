"""
Uploads scraped PlayerCard data to Supabase using upsert.

Upsert key: (player_name, card_type) — lets the scraper run weekly
and update ratings/images without creating duplicate rows.
"""

import logging
import time

from supabase import create_client, Client

from config import SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, TABLE_NAME, UPSERT_BATCH_SIZE
from models import PlayerCard

log = logging.getLogger(__name__)

MAX_RETRIES   = 5
RETRY_BACKOFF = 2   # seconds — doubles on each retry


def make_client() -> Client:
    return create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)


def upsert_cards(client: Client, cards: list[PlayerCard]) -> tuple[int, int]:
    if not cards:
        return 0, 0

    total = 0
    rows = [c.to_row() for c in cards]

    for i in range(0, len(rows), UPSERT_BATCH_SIZE):
        batch = rows[i : i + UPSERT_BATCH_SIZE]
        total += _upsert_batch_with_retry(client, batch, i + 1)

    return total, 0


def _upsert_batch_with_retry(client: Client, batch: list[dict], batch_num: int) -> int:
    # Split into rows with source_id (upsert on source_id) and rows without (upsert on name+type)
    with_id    = [r for r in batch if r.get("source_id")]
    without_id = [r for r in batch if not r.get("source_id")]

    total = 0
    if with_id:
        total += _upsert_rows(client, with_id, "source_id", batch_num)
    if without_id:
        total += _upsert_rows(client, without_id, "player_name,card_type", batch_num)
    return total


_missing_index_warned = False   # warn once per run


def _upsert_rows(client: Client, rows: list[dict], conflict_key: str, batch_num: int) -> int:
    global _missing_index_warned
    delay = RETRY_BACKOFF
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            result = (
                client.table(TABLE_NAME)
                .upsert(rows, on_conflict=conflict_key)
                .execute()
            )
            count = len(result.data) if result.data else len(rows)
            log.info("Batch %d upserted %d rows (key: %s).", batch_num, count, conflict_key)
            return count
        except Exception as exc:
            msg = str(exc)

            # 42P10 = no unique constraint — constraint not created yet.
            # Fall back to upsert with ignore_duplicates=True (ON CONFLICT DO NOTHING).
            if "42P10" in msg or "no unique or exclusion constraint" in msg:
                if not _missing_index_warned:
                    log.warning(
                        "\n"
                        "  ┌──────────────────────────────────────────────────────────────┐\n"
                        "  │  Unique constraint for 'source_id' not found in Supabase.   │\n"
                        "  │  Run this once in the SQL editor:                            │\n"
                        "  │                                                              │\n"
                        "  │  alter table player_cards                                    │\n"
                        "  │    add constraint player_cards_source_id_key                 │\n"
                        "  │    unique (source_id);                                       │\n"
                        "  │                                                              │\n"
                        "  │  Falling back to INSERT (ignore duplicates) for this run.   │\n"
                        "  └──────────────────────────────────────────────────────────────┘",
                    )
                    _missing_index_warned = True
                return _insert_ignore(client, rows, batch_num)

            if attempt == MAX_RETRIES:
                log.error("Batch %d failed after %d attempts: %s", batch_num, MAX_RETRIES, exc)
                raise
            log.warning(
                "Batch %d attempt %d/%d failed (%s) — retrying in %ds…",
                batch_num, attempt, MAX_RETRIES, type(exc).__name__, delay,
            )
            client = make_client()
            time.sleep(delay)
            delay = min(delay * 2, 30)
    return 0


def _insert_ignore(client: Client, rows: list[dict], batch_num: int) -> int:
    """INSERT with ON CONFLICT DO NOTHING — skips existing rows silently."""
    delay = RETRY_BACKOFF
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            result = (
                client.table(TABLE_NAME)
                .upsert(rows, ignore_duplicates=True)
                .execute()
            )
            count = len(result.data) if result.data else len(rows)
            log.info("Batch %d inserted/skipped %d rows.", batch_num, count)
            return count
        except Exception as exc:
            if attempt == MAX_RETRIES:
                log.error("Batch %d insert failed after %d attempts: %s", batch_num, MAX_RETRIES, exc)
                raise
            client = make_client()
            time.sleep(delay)
            delay = min(delay * 2, 30)
    return 0


def delete_stale_cards(
    client: Client,
    current_names: set[str],
    card_type: str | None = None,
) -> int:
    if not current_names:
        return 0

    existing = client.table(TABLE_NAME).select("master_card_id,player_name,card_type").execute()
    stale_ids = [
        row["master_card_id"]
        for row in (existing.data or [])
        if row["player_name"] not in current_names
        and (card_type is None or row["card_type"] == card_type)
    ]

    if not stale_ids:
        return 0

    for i in range(0, len(stale_ids), UPSERT_BATCH_SIZE):
        batch = stale_ids[i : i + UPSERT_BATCH_SIZE]
        client.table(TABLE_NAME).delete().in_("master_card_id", batch).execute()

    log.info("Deleted %d stale cards.", len(stale_ids))
    return len(stale_ids)
