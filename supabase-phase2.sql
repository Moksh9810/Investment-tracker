-- ============================================================
-- Portfolio Bahi-Khata — Phase 2 (Support) setup
-- Supabase → SQL Editor → New query → ye poora paste karke Run.
-- (Phase 1 wala SQL pehle chal chuka hona chahiye — is_admin() usi se aata hai.)
-- ============================================================

-- 1) Support chat messages ---------------------------------------
create table if not exists public.support_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  sender text check (sender in ('user','admin')),
  body text,
  created_at timestamptz default now()
);
alter table public.support_messages enable row level security;

drop policy if exists "sm read"   on public.support_messages;
drop policy if exists "sm insert" on public.support_messages;
-- user apni baat dekhe/bheje; admin sabki
create policy "sm read"   on public.support_messages for select using (user_id = auth.uid() or public.is_admin());
create policy "sm insert" on public.support_messages for insert with check (user_id = auth.uid() or public.is_admin());

-- 2) App settings (support number etc.) --------------------------
create table if not exists public.app_settings (
  id int primary key default 1,
  support_phone text,
  support_whatsapp text,
  announcement text,
  updated_at timestamptz default now()
);
insert into public.app_settings (id) values (1) on conflict (id) do nothing;
alter table public.app_settings enable row level security;

drop policy if exists "settings read"  on public.app_settings;
drop policy if exists "settings write" on public.app_settings;
-- number sabko dikhe (read), badle sirf admin
create policy "settings read"  on public.app_settings for select using (true);
create policy "settings write" on public.app_settings for all
  using (public.is_admin()) with check (public.is_admin());

-- 3) Live chat ke liye realtime ON -------------------------------
do $$
begin
  alter publication supabase_realtime add table public.support_messages;
exception when others then null;
end $$;

-- Ho gaya. "Success" aana chahiye.
