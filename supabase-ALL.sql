-- ============================================================
-- Portfolio Bahi-Khata — POORA DATABASE SETUP (ek hi file)
-- Supabase → SQL Editor → New query → poora paste → Run.
-- Ye idempotent hai: purane (already set) DB par bhi safe chalega.
-- Aapko sirf YE EK file chalani hai (baaki alag SQL files ki zaroorat nahi).
-- Ant me apna email daal kar khud ko SUPER ADMIN banana mat bhoolna.
-- ============================================================

-- ---------- PROFILES ----------
create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  email text,
  created_at timestamptz default now()
);
alter table public.profiles add column if not exists name  text;
alter table public.profiles add column if not exists phone text;
alter table public.profiles add column if not exists is_admin     boolean default false;
alter table public.profiles add column if not exists is_super     boolean default false;
alter table public.profiles add column if not exists can_support  boolean default false;
alter table public.profiles add column if not exists can_accounts boolean default false;
alter table public.profiles add column if not exists can_settings boolean default false;
alter table public.profiles add column if not exists is_premium   boolean default false;
alter table public.profiles add column if not exists premium_until timestamptz;
alter table public.profiles add column if not exists premium_reminder_at timestamptz;
alter table public.profiles add column if not exists referral_code text;
alter table public.profiles add column if not exists referred_by   text;
alter table public.profiles enable row level security;

-- ---------- PORTFOLIOS ----------
create table if not exists public.portfolios (
  user_id uuid primary key references auth.users on delete cascade,
  data jsonb default '{}'::jsonb,
  updated_at timestamptz default now()
);
alter table public.portfolios enable row level security;

-- ---------- APP SETTINGS ----------
create table if not exists public.app_settings ( id int primary key );
insert into public.app_settings (id) values (1) on conflict (id) do nothing;
alter table public.app_settings add column if not exists support_phone    text;
alter table public.app_settings add column if not exists support_whatsapp text;
alter table public.app_settings add column if not exists announcement     text;
alter table public.app_settings add column if not exists upi_id           text;
alter table public.app_settings add column if not exists premium_price    text;
alter table public.app_settings add column if not exists premium_benefits text;
alter table public.app_settings add column if not exists razorpay_on      boolean default false;
alter table public.app_settings add column if not exists upi_on           boolean default true;
alter table public.app_settings add column if not exists company_name     text;
alter table public.app_settings add column if not exists contact_email    text;
alter table public.app_settings add column if not exists contact_address  text;
alter table public.app_settings add column if not exists updated_at       timestamptz default now();
alter table public.app_settings enable row level security;

-- ---------- SUPPORT MESSAGES ----------
create table if not exists public.support_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  sender text,
  body text,
  created_at timestamptz default now()
);
alter table public.support_messages enable row level security;

-- ---------- NEWS ----------
create table if not exists public.news (
  id uuid primary key default gen_random_uuid(),
  title text, body text, created_at timestamptz default now()
);
alter table public.news enable row level security;

-- ---------- LEADERBOARD ----------
create table if not exists public.leaderboard (
  user_id uuid primary key references auth.users on delete cascade,
  name text, pct numeric, opted_in boolean default false, updated_at timestamptz default now()
);
alter table public.leaderboard enable row level security;

-- ---------- PAYMENT REQUESTS ----------
create table if not exists public.payment_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  amount text, utr text, plan text, status text default 'pending',
  created_at timestamptz default now()
);
alter table public.payment_requests enable row level security;

-- ---------- HELPER FUNCTIONS ----------
create or replace function public.is_super() returns boolean language sql security definer stable as $$
  select coalesce((select is_super from public.profiles where id=auth.uid()),false); $$;
create or replace function public.can_accounts() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_accounts) from public.profiles where id=auth.uid()),false); $$;
create or replace function public.can_support() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_support) from public.profiles where id=auth.uid()),false); $$;
create or replace function public.can_settings() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_settings) from public.profiles where id=auth.uid()),false); $$;
create or replace function public.is_admin() returns boolean language sql security definer stable as $$
  select coalesce((select (is_super or can_support or can_accounts or can_settings) from public.profiles where id=auth.uid()),false); $$;

-- ---------- SIGNUP TRIGGER (naam/phone + trial + pehle-100-free + referral) ----------
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
declare cnt int; refc text;
begin
  select count(*) into cnt from public.profiles;
  refc := lower(substr(md5(new.id::text),1,6));
  insert into public.profiles (id, email, name, phone, referral_code, referred_by, is_premium, premium_until)
  values (new.id, new.email,
          new.raw_user_meta_data->>'name', new.raw_user_meta_data->>'phone',
          refc, new.raw_user_meta_data->>'ref',
          (cnt < 100), now() + interval '7 days')
  on conflict (id) do update set
    name = coalesce(excluded.name, profiles.name),
    phone= coalesce(excluded.phone, profiles.phone);
  insert into public.portfolios (user_id, data) values (new.id, '{}'::jsonb)
  on conflict (user_id) do nothing;
  if new.raw_user_meta_data->>'ref' is not null then
    update public.profiles set premium_until = greatest(coalesce(premium_until,now()),now()) + interval '30 days'
      where referral_code = new.raw_user_meta_data->>'ref';
    update public.profiles set premium_until = greatest(coalesce(premium_until,now()),now()) + interval '30 days'
      where id = new.id;
  end if;
  return new;
end;$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------- POLICIES ----------
-- profiles: apna+admin read; update sirf super
drop policy if exists "profiles read"   on public.profiles;
drop policy if exists "profiles insert" on public.profiles;
drop policy if exists "profiles update" on public.profiles;
create policy "profiles read"   on public.profiles for select using (id=auth.uid() or public.is_admin());
create policy "profiles insert" on public.profiles for insert with check (id=auth.uid());
create policy "profiles update" on public.profiles for update using (public.is_super()) with check (public.is_super());

-- portfolios: apna, ya accounts-access
drop policy if exists "portfolios all" on public.portfolios;
create policy "portfolios all" on public.portfolios for all
  using (user_id=auth.uid() or public.can_accounts())
  with check (user_id=auth.uid() or public.can_accounts());

-- app_settings: sabko read; write can_settings
drop policy if exists "settings read"  on public.app_settings;
drop policy if exists "settings write" on public.app_settings;
create policy "settings read"  on public.app_settings for select using (true);
create policy "settings write" on public.app_settings for all using (public.can_settings()) with check (public.can_settings());

-- support: apna ya support-access
drop policy if exists "sm read"   on public.support_messages;
drop policy if exists "sm insert" on public.support_messages;
create policy "sm read"   on public.support_messages for select using (user_id=auth.uid() or public.can_support());
create policy "sm insert" on public.support_messages for insert with check (user_id=auth.uid() or public.can_support());

-- news: sabko read; write can_settings
drop policy if exists "news read"  on public.news;
drop policy if exists "news write" on public.news;
create policy "news read"  on public.news for select using (true);
create policy "news write" on public.news for all using (public.can_settings()) with check (public.can_settings());

-- leaderboard: opt-in public read; apni row write
drop policy if exists "lb read"  on public.leaderboard;
drop policy if exists "lb write" on public.leaderboard;
create policy "lb read"  on public.leaderboard for select using (opted_in=true or user_id=auth.uid() or public.is_admin());
create policy "lb write" on public.leaderboard for all using (user_id=auth.uid()) with check (user_id=auth.uid());

-- payment_requests: apna ya accounts; update accounts
drop policy if exists "pr read"   on public.payment_requests;
drop policy if exists "pr insert" on public.payment_requests;
drop policy if exists "pr update" on public.payment_requests;
create policy "pr read"   on public.payment_requests for select using (user_id=auth.uid() or public.can_accounts());
create policy "pr insert" on public.payment_requests for insert with check (user_id=auth.uid());
create policy "pr update" on public.payment_requests for update using (public.can_accounts()) with check (public.can_accounts());

-- ---------- REALTIME (support live chat) ----------
do $$ begin
  alter publication supabase_realtime add table public.support_messages;
exception when others then null; end $$;

-- ============================================================
-- AKHRI KADAM — khud ko SUPER ADMIN banayein (apna email daalein):
--   update public.profiles set is_super = true where email = 'aapka-email@example.com';
-- ============================================================
