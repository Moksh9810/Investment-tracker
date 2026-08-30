# 🔐 Credentials Setup - ONE PLACE ONLY!

**Sirf ek jagah credentials add karo. Bas!**

---

## ✅ How It Works

```
.env file mein add karo
    ↓
config.js automatically load karega
    ↓
app.js use karega
    ↓
Sab kaam hoga! ✅
```

---

## 🎯 5 SECONDS SETUP

### Step 1: .env file kholo

**Folder mein:** `.env` file hai

Open karo notepad se

### Step 2: Credentials add karo

Find karo ye 2 lines:

```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

Replace with YOUR values:

```
VITE_SUPABASE_URL=https://abcdefgh.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
```

### Step 3: Save karo

Ctrl+S

### Done! ✅

---

## 🔒 Security

**Important:**
- `.env` file **NEVER** commit hoga (it's in .gitignore)
- Sirf locally rehega apke computer mein
- GitHub par nahi jayega
- Safe rahega! ✅

---

## 📝 Credentials Kahan Se Milenge?

1. Go to: https://app.supabase.com
2. Apna project click karo
3. Left sidebar: "Settings"
4. Click: "API"
5. Copy karo:
   - **Project URL** → VITE_SUPABASE_URL
   - **Anon Key** → VITE_SUPABASE_ANON_KEY

---

## ✨ Ye Lo!

```
.env file → Sirf 1 jagah
config.js → Automatically load
app.js → Automatically use

Zyada confusion nahi! 🎊
```

---

## ✅ Verify

After adding credentials:

1. Open `index.html` in browser
2. Open DevTools (F12)
3. Console mein dekho:
   ```
   ✅ Supabase initialized successfully
   ```

Agar ye message dikhe to **sab sahi hai!** 🎉

---

## 🆘 Problem?

**"Supabase credentials not configured" error?**

- Check `.env` file updated correctly
- Credentials paste kiye?
- Hard refresh: Ctrl+Shift+R

---

**That's it! Ek file, ek jagah, sirf once!** 🚀
