-- ============================================================
-- Portfolio Bahi-Khata — Company / Legal info
-- Supabase → SQL Editor → New query → paste → Run.
-- ============================================================

alter table public.app_settings add column if not exists company_name    text;
alter table public.app_settings add column if not exists contact_email   text;
alter table public.app_settings add column if not exists contact_address text;

-- Ho gaya. "Success" aana chahiye.
