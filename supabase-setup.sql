-- ============================================================
-- Portfolio Bahi-Khata — Supabase setup
-- Supabase dashboard → SQL Editor me ye poora paste karke "Run" dabayein.
-- ============================================================

-- 1) Tables ------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  email text,
  is_admin boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.portfolios (
  user_id uuid primary key references auth.users on delete cascade,
  data jsonb default '{}'::jsonb,
  updated_at timestamptz default now()
);

alter table public.profiles  enable row level security;
alter table public.portfolios enable row level security;

-- 2) Admin check (RLS recursion se bachne ke liye) ---------------
create or replace function public.is_admin()
returns boolean language sql security definer stable as $$
  select coalesce((select is_admin from public.profiles where id = auth.uid()), false);
$$;

-- 3) Row Level Security policies ---------------------------------
drop policy if exists "profiles read"   on public.profiles;
drop policy if exists "profiles insert" on public.profiles;
drop policy if exists "profiles update" on public.profiles;
create policy "profiles read"   on public.profiles for select using (id = auth.uid() or public.is_admin());
create policy "profiles insert" on public.profiles for insert with check (id = auth.uid());
create policy "profiles update" on public.profiles for update using (id = auth.uid() or public.is_admin());

drop policy if exists "portfolios all" on public.portfolios;
create policy "portfolios all" on public.portfolios
  for all using (user_id = auth.uid() or public.is_admin())
  with check (user_id = auth.uid() or public.is_admin());

-- 4) Naya user bante hi profile + khaali portfolio auto-ban jaye --
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, email) values (new.id, new.email)
    on conflict (id) do nothing;
  insert into public.portfolios (user_id, data) values (new.id, '{}'::jsonb)
    on conflict (user_id) do nothing;
  return new;
end;$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
-- 5) KHUD KO ADMIN BANAYEIN
--    Pehle app par apne email se SIGN UP karein, PHIR niche
--    apna email daal kar ye line alag se Run karein:
--
--    update public.profiles set is_admin = true
--    where email = 'aapka-email@example.com';
-- ============================================================
