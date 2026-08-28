-- ============================================================
-- Portfolio Bahi-Khata — Razorpay/UPI toggles
-- Supabase → SQL Editor → New query → paste → Run.
-- (Razorpay ki SECRET keys yahan NAHI — wo Vercel env me jaati hain, README dekhein.)
-- ============================================================

alter table public.app_settings add column if not exists razorpay_on boolean default false;
alter table public.app_settings add column if not exists upi_on      boolean default true;

-- Ho gaya. "Success" aana chahiye.
