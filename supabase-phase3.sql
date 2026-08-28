-- ============================================================
-- Portfolio Bahi-Khata — Phase 3 (Admin roles/permissions)
-- Supabase → SQL Editor → New query → poora paste → Run.
-- (Phase 1 & 2 pehle chal chuke hone chahiye.)
-- ============================================================

-- 1) Permission columns ------------------------------------------
alter table public.profiles add column if not exists is_super     boolean default false;
alter table public.profiles add column if not exists can_support  boolean default false;
alter table public.profiles add column if not exists can_accounts boolean default false;
alter table public.profiles add column if not exists can_settings boolean default false;

-- 2) Helper functions (RLS ke liye) ------------------------------
create or replace function public.is_super() returns boolean language sql security definer stable as $$
  select coalesce((select is_super from public.profiles where id = auth.uid()), false); $$;

create or replace function public.can_accounts() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_accounts) from public.profiles where id = auth.uid()), false); $$;

create or replace function public.can_support() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_support) from public.profiles where id = auth.uid()), false); $$;

create or replace function public.can_settings() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_settings) from public.profiles where id = auth.uid()), false); $$;

-- is_admin() ab "koi bhi admin access" matlab rakhta hai
create or replace function public.is_admin() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_support or can_accounts or can_settings)
                   from public.profiles where id = auth.uid()), false); $$;

-- 3) Policies update ---------------------------------------------
-- Portfolios: apna, ya jise accounts-access ho
drop policy if exists "portfolios all" on public.portfolios;
create policy "portfolios all" on public.portfolios for all
  using (user_id = auth.uid() or public.can_accounts())
  with check (user_id = auth.uid() or public.can_accounts());

-- Support: apna, ya jise support-access ho
drop policy if exists "sm read"   on public.support_messages;
drop policy if exists "sm insert" on public.support_messages;
create policy "sm read"   on public.support_messages for select using (user_id = auth.uid() or public.can_support());
create policy "sm insert" on public.support_messages for insert with check (user_id = auth.uid() or public.can_support());

-- Settings: badle sirf jise settings-access ho
drop policy if exists "settings write" on public.app_settings;
create policy "settings write" on public.app_settings for all
  using (public.can_settings()) with check (public.can_settings());

-- Profiles: permissions sirf SUPER admin badal sake (koi khud ko upar na kar sake)
drop policy if exists "profiles update" on public.profiles;
create policy "profiles update" on public.profiles for update
  using (public.is_super()) with check (public.is_super());

-- ============================================================
-- 4) KHUD KO SUPER ADMIN BANAYEIN (apna email daalein):
--
--    update public.profiles set is_super = true
--    where email = 'aapka-email@example.com';
-- ============================================================
