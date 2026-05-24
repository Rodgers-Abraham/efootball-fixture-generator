from dataclasses import dataclass


@dataclass
class PlayerCard:
    player_name: str
    card_type: str          # Show Time | POTW | Big Time | Highlight | Epic | Standard
    max_rating: int
    card_image_url: str | None = None
    source_id: str | None = None   # efworld/efhub unique card ID — each version of a player is distinct

    def to_row(self) -> dict:
        row = {
            "player_name":    self.player_name,
            "card_type":      self.card_type,
            "max_rating":     self.max_rating,
        }
        if self.card_image_url:
            row["card_image_url"] = self.card_image_url
        if self.source_id:
            row["source_id"] = self.source_id
        return row

    def __str__(self) -> str:
        return f"{self.player_name} [{self.card_type}] OVR {self.max_rating}"
