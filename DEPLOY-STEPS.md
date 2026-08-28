# Final deploy — sirf ek baar (v21)

## 1) Database (ek hi SQL, ek baar)
Supabase → SQL Editor → New query → **`supabase-ALL.sql`** poora paste → **Run**.
(Ye sab kuch set kar deta hai; purane DB par bhi safe hai.)
Phir apna email daal kar khud ko super admin banayein:
```
update public.profiles set is_super = true where email = 'aapka-email@example.com';
```

## 2) Email verification ON (production ke liye)
Supabase → Authentication → Sign In / Providers → Email → **"Confirm email" ON**.

## 3) Files upload (ek baar)
GitHub repo → Add file → Upload files → ye sab drag karein:
- `index.html`
- `manifest.json`, `sw.js`, `icon-192.png`, `icon-512.png`
- `vercel.json`
- poora `api` folder (isme naye: send-email.js, cron-reminders.js, delete-account.js, rzp-order.js, rzp-verify.js)
- **`config.js` MAT daalein** (wo pehle se laga hai)
→ Commit changes. Vercel apne-aap deploy karega. App me **Ctrl+Shift+R** → v21.

## 4) App ke andar (Settings tab)
- Company/Legal info (naam, email, address) bharein
- UPI ID + Premium price + benefits bharein
- Manual UPI ON rakhein

---

## Baad me (jab keys/account ho — sab OFF-ready, kuch nahi tootega):
Vercel → Project → Settings → Environment Variables me daalein, phir Redeploy:

**Emails (welcome/receipt/reminder) ke liye:**
- `RESEND_API_KEY`  → resend.com (free) se
- `EMAIL_FROM`      → jaise: `Portfolio <no-reply@aapkadomain.com>` (ya test ke liye `onboarding@resend.dev`)
- `SUPABASE_URL`    → aapka supabase url
- `SUPABASE_SERVICE_ROLE` → Supabase → Settings → API Keys → service_role
- `SUPABASE_ANON_KEY` → publishable/anon key
(Reminder email roz apne-aap chalega — vercel.json me cron laga hai.)

**Razorpay auto-payment ke liye:** RAZORPAY-SETUP.md dekhein.

**Account delete** ke liye bhi SUPABASE_URL + SUPABASE_SERVICE_ROLE (+ANON) zaroori hain (upar wale hi).

**Error monitoring (optional):** config.js me `window.SENTRY_DSN="..."` add kar dein (sentry.io free).

**Custom domain:** Vercel → Project → Settings → Domains → `portfolio.energiaa.in` add karke DNS me CNAME lagayein.
