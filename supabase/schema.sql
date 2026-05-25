-- Users table
create table users (
  id uuid primary key default gen_random_uuid(),
  username text unique not null,
  team_tag char(3) unique not null,
  email text unique,
  avatar_url text,
  created_at timestamptz default now()
);

-- Player cards database (populated by Python scraper)
create table player_cards (
  master_card_id uuid primary key default gen_random_uuid(),
  player_name text not null,
  card_type text not null check (card_type in ('Show Time', 'POTW', 'Big Time', 'Highlight', 'Epic', 'Standard')),
  max_rating int not null,
  card_image_url text,
  source_id text,              -- efworld/efhub unique card ID (one per card version)
  updated_at timestamptz default now()
);

-- source_id uniquely identifies each card version (Mbappé POTW ≠ Mbappé Show Time ≠ Mbappé Epic)
create unique index player_cards_source_id_idx on player_cards (source_id) where source_id is not null;

-- Fallback for pesmaster cards that have no source_id
create unique index player_cards_name_type_idx on player_cards (player_name, card_type) where source_id is null;

-- Tournaments
create table tournaments (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  format text not null check (format in ('single_elimination', 'double_elimination', 'round_robin')),
  status text not null default 'pending' check (status in ('pending', 'active', 'completed')),
  invite_code char(6) unique,
  created_by uuid references users(id),
  created_at timestamptz default now()
);

-- Tournament participants
create table tournament_participants (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid references tournaments(id) on delete cascade,
  user_id uuid references users(id),
  seed int,
  unique(tournament_id, user_id)
);

-- User squads (each squad item = one card slot tied to a user)
create table squad_items (
  squad_item_id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  master_card_id uuid references player_cards(master_card_id),
  position text not null check (position in ('starter', 'substitute')),
  slot_index int not null,
  unique(user_id, slot_index)
);

-- Matches (generated fixtures)
create table matches (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid references tournaments(id) on delete cascade,
  round int not null,
  match_number int not null,
  home_user_id uuid references users(id),
  away_user_id uuid references users(id),
  home_score int,
  away_score int,
  home_possession int,
  away_possession int,
  home_shots int,
  away_shots int,
  home_shots_on_target int,
  away_shots_on_target int,
  home_fouls int,
  away_fouls int,
  status text not null default 'scheduled' check (status in ('scheduled', 'in_progress', 'completed')),
  played_at timestamptz,
  created_at timestamptz default now()
);

-- Match events (goals, MOTM)
create table match_events (
  id uuid primary key default gen_random_uuid(),
  match_id uuid references matches(id) on delete cascade,
  squad_item_id uuid references squad_items(squad_item_id),
  event_type text not null check (event_type in ('goal', 'motm')),
  created_at timestamptz default now()
);

-- Friendships table
create table friendships (
  id uuid primary key default gen_random_uuid(),
  user_id_1 uuid references users(id) on delete cascade,
  user_id_2 uuid references users(id) on delete cascade,
  status text not null check (status in ('pending', 'accepted')),
  created_at timestamptz default now(),
  unique(user_id_1, user_id_2)
);

-- ─────────────────────────────────────────────────────────────
-- Row Level Security
-- ─────────────────────────────────────────────────────────────

alter table users               enable row level security;
alter table player_cards        enable row level security;
alter table tournaments         enable row level security;
alter table tournament_participants enable row level security;
alter table squad_items         enable row level security;
alter table matches             enable row level security;
alter table match_events        enable row level security;
alter table friendships         enable row level security;

-- friendships: users can read their own friendships; anyone can read their own pending/accepted status
create policy "friendships: read own"
  on friendships for select using (auth.uid() = user_id_1 or auth.uid() = user_id_2);
create policy "friendships: insert"
  on friendships for insert with check (auth.uid() = user_id_1);
create policy "friendships: update"
  on friendships for update using (auth.uid() = user_id_1 or auth.uid() = user_id_2);
create policy "friendships: delete"
  on friendships for delete using (auth.uid() = user_id_1 or auth.uid() = user_id_2);

-- users: anyone logged in can read all profiles (needed for participant search)
-- only the owner can insert/update their own row
create policy "users: read all"      on users for select using (true);
create policy "users: insert own"    on users for insert with check (auth.uid() = id);
create policy "users: update own"    on users for update using (auth.uid() = id);

-- player_cards: public read-only (populated by scraper via service role)
create policy "cards: read all"      on player_cards for select using (true);

-- tournaments: authenticated read; creator can insert/update/delete
create policy "tournaments: read all"
  on tournaments for select using (auth.role() = 'authenticated');
create policy "tournaments: insert"
  on tournaments for insert with check (auth.uid() = created_by);
create policy "tournaments: update"
  on tournaments for update using (auth.uid() = created_by);
create policy "tournaments: delete"
  on tournaments for delete using (auth.uid() = created_by);

-- tournament_participants: any authenticated user can read; creator of the tournament manages entries
create policy "participants: read all"
  on tournament_participants for select using (auth.role() = 'authenticated');
create policy "participants: insert"
  on tournament_participants for insert
  with check (
    auth.uid() = (select created_by from tournaments where id = tournament_id)
  );
create policy "participants: delete"
  on tournament_participants for delete
  using (
    auth.uid() = (select created_by from tournaments where id = tournament_id)
  );

-- squad_items: owner can manage; anyone authenticated can read (needed for Quick-Tap player chips)
create policy "squad: read all"
  on squad_items for select using (auth.role() = 'authenticated');
create policy "squad: insert own"
  on squad_items for insert with check (auth.uid() = user_id);
create policy "squad: update own"
  on squad_items for update using (auth.uid() = user_id);
create policy "squad: delete own"
  on squad_items for delete using (auth.uid() = user_id);

-- matches: authenticated read; tournament creator manages
create policy "matches: read all"
  on matches for select using (auth.role() = 'authenticated');
create policy "matches: insert"
  on matches for insert
  with check (
    auth.uid() = (select created_by from tournaments where id = tournament_id)
  );
create policy "matches: update"
  on matches for update
  using (
    auth.uid() = (select created_by from tournaments where id = tournament_id)
  );

-- match_events: authenticated read; tournament creator logs goals/MOTM
create policy "events: read all"
  on match_events for select using (auth.role() = 'authenticated');
create policy "events: insert"
  on match_events for insert
  with check (
    auth.uid() = (
      select t.created_by from matches m
      join tournaments t on t.id = m.tournament_id
      where m.id = match_id
    )
  );

-- ─────────────────────────────────────────────────────────────
-- Storage setup for Avatars
-- ─────────────────────────────────────────────────────────────
-- 🔥 MASTER FIX FOR AVATAR UPLOADS (Run this in Supabase SQL Editor) 🔥
-- insert into storage.buckets (id, name, public) values ('avatars', 'avatars', true);

-- create policy "avatar_upload" on storage.objects for insert with check (
--   bucket_id = 'avatars' AND (auth.uid())::text = (storage.foldername(name))[1]
-- );

-- create policy "avatar_update" on storage.objects for update using (
--   bucket_id = 'avatars' AND (auth.uid())::text = (storage.foldername(name))[1]
-- );

-- create policy "avatar_delete" on storage.objects for delete using (
--   bucket_id = 'avatars' AND (auth.uid())::text = (storage.foldername(name))[1]
-- );

-- create policy "avatar_public_view" on storage.objects for select using (
--   bucket_id = 'avatars'
-- );

-- ─────────────────────────────────────────────────────────────
-- Account Management
-- ─────────────────────────────────────────────────────────────

-- Function to handle user deletion from auth.users (trigger)
create or replace function public.handle_user_delete()
returns trigger as $$
begin
  delete from public.users where id = old.id;
  return old;
end;
$$ language plpgsql security definer;

-- Trigger to delete public user data when auth user is deleted
-- create trigger on_auth_user_delete
--   after delete on auth.users
--   for each row execute procedure public.handle_user_delete();
