# Razorpay auto-payment — kaise ON karein (KYC ke baad)

Aapko coding nahi karni. Bas do jagah copy-paste:

## A) Vercel me 4 keys daalein (ek baar)
1. https://vercel.com → apna project **Investment-tracker** → **Settings** → **Environment Variables**.
2. Ek-ek karke ye 4 "Add" karein (Name = jaisa likha, Value = aapki):
   - `RAZORPAY_KEY_ID`        → Razorpay Dashboard → Settings → API Keys → Key Id
   - `RAZORPAY_KEY_SECRET`    → wahi jagah → Key Secret (sirf ek baar dikhta hai — sambhaal lein)
   - `SUPABASE_URL`           → aapka https://xxxx.supabase.co (config.js me bhi hai)
   - `SUPABASE_SERVICE_ROLE`  → Supabase → Settings → API Keys → Legacy tab → **service_role** (secret) key
3. Save karke, Vercel → **Deployments** → sabse upar wale ke "..." menu → **Redeploy** (taaki keys lag jaayein).

> RAZORPAY_KEY_SECRET aur SUPABASE_SERVICE_ROLE **secret** hain — inhe kabhi kisi ko na dein, aur app/config.js me na daalein. Ye sirf Vercel env me rehni chahiye.

## B) Razorpay dashboard me webhook (optional, extra safety)
Abhi zaroori nahi — verify app me ho jata hai. (Chaahein to baad me jod sakte hain.)

## C) App me toggle ON karein
1. App → **⚙️ Settings** → "Payment methods ON/OFF".
2. **Razorpay auto-payment ON** toggle chaalu karein.
3. Bas — ab user Premium tab me "Online pay karo" dabayega, pay karte hi premium apne-aap.

## Manual UPI
Alag toggle hai — jab chaahein ON/OFF. Dono saath bhi chal sakte hain.
