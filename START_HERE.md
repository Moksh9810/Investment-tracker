# ⚡ START HERE - 5 MINUTES SETUP

**Sirf 5 steps. Bas ye karo aur done!**

---

## Step 1: Supabase Setup (2 min)
```
1. https://supabase.com → Sign Up
2. Create Project (name: bahi-khata)
3. Wait for project to initialize
4. Go to Settings → API
5. Copy-paste 2 things:
   - Project URL
   - Anon Key
6. Save in notepad
```

---

## Step 2: Add Credentials to Code (1 min)

**Open `js/config.js`**

Find:
```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key-here';
```

Replace with YOUR values from Step 1

Save!

---

## Step 3: Create Database (1 min)

**Supabase Dashboard:**
1. SQL Editor → New Query
2. Copy-paste SQL from `SETUP_GUIDE.md` (look for "CREATE TABLE")
3. Click Run
4. Repeat for second SQL query (RLS security)

Done!

---

## Step 4: Push to GitHub (1 min)

**Terminal (in bahi-khata folder):**
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/Moksh9810/Investment-tracker.git
git push -u origin main
```

Login when asked.

---

## Step 5: Deploy to Vercel (2 min)

**Terminal:**
```bash
npm i -g vercel
vercel login
vercel --prod
```

**Then in Vercel Dashboard:**
1. Go to Settings → Environment Variables
2. Add 2 variables:
   - `VITE_SUPABASE_URL` = your URL
   - `VITE_SUPABASE_ANON_KEY` = your key
3. Click "Redeploy"

---

## ✅ DONE!

Visit: `https://bahi-khata-xxxxx.vercel.app`

App is LIVE! 🚀

---

## 🐛 Problem?

**Page not loading?**
- Check Vercel environment variables are added

**Styles broken?**
- Hard refresh: Ctrl+Shift+R

**Console errors?**
- F12 → Console tab
- Check if credentials added correctly

---

**Full guide:** `SETUP_GUIDE.md`  
**Details:** `README.md`

That's it! You're done! 🎉
