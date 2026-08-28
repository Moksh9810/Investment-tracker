-- ============================================================
-- Portfolio Bahi-Khata — Growth batch (News/Tips)
-- Supabase → SQL Editor → New query → paste → Run.
-- (Phase 1-3 pehle chal chuke hone chahiye — can_settings() usi se aata hai.)
-- ============================================================

create table if not exists public.news (
  id uuid primary key default gen_random_uuid(),
  title text,
  body text,
  created_at timestamptz default now()
);
alter table public.news enable row level security;

drop policy if exists "news read"  on public.news;
drop policy if exists "news write" on public.news;
-- sabko dikhe; daalna/hataana sirf settings-access waale admin
create policy "news read"  on public.news for select using (true);
create policy "news write" on public.news for all
  using (public.can_settings()) with check (public.can_settings());

-- Ho gaya. "Success" aana chahiye.
