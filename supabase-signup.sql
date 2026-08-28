-- ============================================================
-- Portfolio Bahi-Khata — Signup details (name + phone)
-- Supabase → SQL Editor → New query → paste → Run.
-- ============================================================

alter table public.profiles add column if not exists name  text;
alter table public.profiles add column if not exists phone text;

-- Naya user bante hi naam/phone (signup se) profile me aa jaye
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, email, name, phone)
  values (new.id, new.email,
          new.raw_user_meta_data->>'name',
          new.raw_user_meta_data->>'phone')
  on conflict (id) do update set
    name  = coalesce(excluded.name,  profiles.name),
    phone = coalesce(excluded.phone, profiles.phone);

  insert into public.portfolios (user_id, data)
  values (new.id, '{}'::jsonb)
  on conflict (user_id) do nothing;

  return new;
end;$$;

-- Ho gaya. "Success" aana chahiye.
