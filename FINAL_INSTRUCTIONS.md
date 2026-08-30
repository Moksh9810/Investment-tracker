# 🎯 FINAL INSTRUCTIONS - LITERALLY 2 STEPS

Supabase already setup hai aur site live hai? Perfect! Sirf ye do:

---

## Step 1️⃣ : Download + Extract

Sab files download karo aur folder mein extract karo:

```
bahi-khata/
├── index.html
├── css/design-system.css
├── js/app.js, config.js, utils/...
├── .env.example
├── .gitignore
├── package.json
└── README.md, START_HERE.md, etc.
```

---

## Step 2️⃣ : GitHub Push

Terminal kholo aur ye run karo:

```bash
cd path/to/bahi-khata

git init
git add .
git commit -m "Bahi-Khata v1.0.0"
git remote add origin https://github.com/Moksh9810/Investment-tracker.git
git push -u origin main
```

---

## ✅ DONE!

Vercel automatically redeploy hoga!

Site live rehega:
```
https://investment-tracker-git-main-moksh17.vercel.app/
```

---

## ⚙️ One More Thing

**Agar Supabase credentials nahi hain to:**

1. `js/config.js` mein (lines 9-10) paste karo:
```javascript
const SUPABASE_URL = 'https://your-url.supabase.co';
const SUPABASE_ANON_KEY = 'your-key';
```

2. `.env` file bana aur paste karo:
```
VITE_SUPABASE_URL=https://your-url.supabase.co
VITE_SUPABASE_ANON_KEY=your-key
```

3. Push karo GitHub par

---

## 🎉 Bas itna hi!

Files ready hain. Sirf upload karo GitHub par. Vercel khud redeploy karega!

**Questions?** `START_HERE.md` dekho.

---

**Created:** 2026-08-30
**Status:** ✅ 100% Ready to Deploy
