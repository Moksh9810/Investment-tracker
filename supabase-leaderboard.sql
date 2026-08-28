-- ============================================================
-- Portfolio Bahi-Khata — Leaderboard (opt-in, sirf % return)
-- Supabase → SQL Editor → New query → paste → Run.
-- ============================================================

create table if not exists public.leaderboard (
  user_id uuid primary key references auth.users on delete cascade,
  name text,
  pct numeric,
  opted_in boolean default false,
  updated_at timestamptz default now()
);
alter table public.leaderboard enable row level security;

drop policy if exists "lb read"  on public.leaderboard;
drop policy if exists "lb write" on public.leaderboard;
-- sirf opt-in wale sabko dikhein; apna hamesha; admin sab
create policy "lb read"  on public.leaderboard for select
  using (opted_in = true or user_id = auth.uid() or public.is_admin());
-- har user sirf apni row likhe
create policy "lb write" on public.leaderboard for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Ho gaya. "Success" aana chahiye.
