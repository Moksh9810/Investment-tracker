# Portfolio Bahi-Khata (v9) — Multi-user + Admin

Stocks, Mutual Funds, Bonds, Loans/Interest — sab ek jagah.
Ab har koi apni ID banata hai, sirf apna portfolio dekhता hai,
aur admin ko sabke accounts dikhte hain (dekh + badal sakta hai).

## Hisse
- index.html            → app (frontend)
- api/                  → live price/NAV laane ke server-hisse (Vercel)
- supabase-setup.sql    → database + login setup (ek baar chalana hai)

## SETUP — 3 hisse (~20-30 min, sab free)

### A) Supabase (login + cloud database)
1. https://supabase.com → free account → **New project** banayein
   (project name kuch bhi; database password note kar lein).
2. Left menu → **SQL Editor** → **New query** → is folder ki
   `supabase-setup.sql` ka poora text paste karein → **Run**.
3. Left menu → **Project Settings → API**. Yahan 2 cheez milengi:
   - **Project URL**   (jaise https://abcd1234.supabase.co)
   - **anon public key** (lamba text)
4. `index.html` kholein, sabse upar `<script>` me ye 2 line badlein:
       const SUPABASE_URL='https://abcd1234.supabase.co';
       const SUPABASE_ANON_KEY='yahan-anon-public-key';
   (apni asli values daalein).
5. (Aasaan login ke liye) Supabase → **Authentication → Providers/Settings**
   me "Confirm email" band kar dein — to sign-up ke turant baad login ho jayega.
   (Chahein to on rakhein; tab user ko email verify karna padega.)

### B) Vercel (app host karna) — pehle jaisa
1. Badli hui files GitHub repo par upload karein
   (Add file → Upload files → saari files `api` folder samet → Commit).
2. Vercel apne-aap deploy kar dega. App ka pakka link kholein.

### C) Khud ko admin banayein
1. App par apne email se **Sign up** karein, phir **Login**.
2. Supabase → SQL Editor me ye chalayein (apna email daal kar):
       update public.profiles set is_admin = true
       where email = 'aapka-email@example.com';
3. App refresh karein — ab upar "ADMIN" aur ek "👥 Accounts" tab dikhega.

## Istemaal
- Har naya user: app par Sign up → Login → apna portfolio.
- Data cloud me safe — kisi bhi device se login karke wahi data.
- Admin: "👥 Accounts" tab me sabki list + net worth. Kisi ko
  "Open" karke uska portfolio dekh/badal sakte hain; "← mera account"
  se wapas.

## Note
- anon key public hoti hai — ye theek hai, kyunki database ki suraksha
  Row Level Security (SQL me set ki gayi) sambhalti hai: koi apna hi
  data dekh/badal sakta hai, admin sabka.
- Live price/NAV wale server-hisse (api/) pehle jaise kaam karte hain.
