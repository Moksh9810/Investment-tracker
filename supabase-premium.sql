-- ============================================================
-- Portfolio Bahi-Khata — Premium (manual UPI) setup
-- Supabase → SQL Editor → New query → paste → Run.
-- ============================================================

-- 1) Premium columns ---------------------------------------------
alter table public.profiles add column if not exists is_premium    boolean default false;
alter table public.profiles add column if not exists premium_until  timestamptz;
alter table public.profiles add column if not exists referral_code  text;
alter table public.profiles add column if not exists referred_by    text;

alter table public.app_settings add column if not exists upi_id           text;
alter table public.app_settings add column if not exists premium_price    text;
alter table public.app_settings add column if not exists premium_benefits text;

-- 2) Signup trigger: trial + pehle-100-free + referral -----------
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
declare cnt int; refc text;
begin
  select count(*) into cnt from public.profiles;
  refc := lower(substr(md5(new.id::text),1,6));

  insert into public.profiles (id, email, name, phone, referral_code, referred_by, is_premium, premium_until)
  values (new.id, new.email,
          new.raw_user_meta_data->>'name',
          new.raw_user_meta_data->>'phone',
          refc,
          new.raw_user_meta_data->>'ref',
          (cnt < 100),                    -- pehle 100 users ko lifetime premium
          now() + interval '7 days')      -- sabko 7-din free trial
  on conflict (id) do update set
    name  = coalesce(excluded.name,  profiles.name),
    phone = coalesce(excluded.phone, profiles.phone);

  insert into public.portfolios (user_id, data)
  values (new.id, '{}'::jsonb) on conflict (user_id) do nothing;

  -- referral: naye user ne kisi ka code daala to DONO ko +30 din
  if new.raw_user_meta_data->>'ref' is not null then
    update public.profiles
      set premium_until = greatest(coalesce(premium_until, now()), now()) + interval '30 days'
      where referral_code = new.raw_user_meta_data->>'ref';
    update public.profiles
      set premium_until = greatest(coalesce(premium_until, now()), now()) + interval '30 days'
      where id = new.id;
  end if;

  return new;
end;$$;

-- 3) Payment requests (manual UPI) -------------------------------
create table if not exists public.payment_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  amount text, utr text, plan text,
  status text default 'pending',
  created_at timestamptz default now()
);
alter table public.payment_requests enable row level security;
drop policy if exists "pr read"   on public.payment_requests;
drop policy if exists "pr insert" on public.payment_requests;
drop policy if exists "pr update" on public.payment_requests;
create policy "pr read"   on public.payment_requests for select using (user_id = auth.uid() or public.can_accounts());
create policy "pr insert" on public.payment_requests for insert with check (user_id = auth.uid());
create policy "pr update" on public.payment_requests for update using (public.can_accounts()) with check (public.can_accounts());

-- Ho gaya. "Success" aana chahiye.
-- (Purane users ko chahein to premium do:
--  update public.profiles set is_premium=true where email='...';)
