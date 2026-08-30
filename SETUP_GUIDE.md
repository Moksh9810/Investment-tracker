# 🚀 Bahi-Khata Setup Guide

Complete step-by-step guide to get your investment tracker running in 10 minutes.

---

## Step 1: Get Supabase Credentials (2 minutes)

### 1.1 Create Supabase Account
1. Go to [supabase.com](https://supabase.com)
2. Click "Sign Up"
3. Complete the registration (email or GitHub)

### 1.2 Create a New Project
1. Click "New Project"
2. Choose a project name (e.g., "bahi-khata")
3. Set a secure password
4. Select a region closest to you
5. Wait for project to initialize (takes ~1 minute)

### 1.3 Get Your Credentials
1. Project initialized? Click on it to open
2. In the left sidebar, click "Settings"
3. Click "API"
4. Copy the following:
   - **Project URL** (starts with https://xxx.supabase.co)
   - **Anon Key** (your public key)
5. Save these somewhere safe

---

## Step 2: Setup Local Files (3 minutes)

### 2.1 Create Configuration File
1. Open `js/config.js`
2. Find these lines:
   ```javascript
   const SUPABASE_URL = 'https://your-project.supabase.co';
   const SUPABASE_ANON_KEY = 'your-anon-key-here';
   ```
3. Replace with YOUR actual values from Step 1.3
4. Save the file

### 2.2 Create Environment File
1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Open `.env`
3. Update these lines:
   ```
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key-here
   ```
4. Save the file

---

## Step 3: Setup Supabase Database (3 minutes)

### 3.1 Access Supabase Console
1. Go to your Supabase project dashboard
2. Click "SQL Editor" in the left sidebar
3. Click "New Query"

### 3.2 Create Tables
Copy and paste this SQL, then click "Run":

```sql
-- Create Holdings table
CREATE TABLE IF NOT EXISTS holdings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  symbol VARCHAR(10) NOT NULL,
  quantity DECIMAL NOT NULL,
  avg_price DECIMAL NOT NULL,
  current_price DECIMAL,
  type VARCHAR(20), -- 'stock', 'mutual_fund', 'bond', 'loan'
  date DATE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create Transactions table
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  holding_id UUID REFERENCES holdings(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type VARCHAR(20), -- 'buy', 'sell', 'dividend', etc
  quantity DECIMAL,
  price DECIMAL,
  date DATE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create User Preferences table
CREATE TABLE IF NOT EXISTS user_preferences (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  theme VARCHAR(20) DEFAULT 'dark',
  currency VARCHAR(3) DEFAULT 'INR',
  notifications_enabled BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 3.3 Enable Row Level Security
Create a new query and paste this:

```sql
-- Enable RLS
ALTER TABLE holdings ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

-- Holdings policies
CREATE POLICY "Users can view own holdings" ON holdings
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create holdings" ON holdings
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own holdings" ON holdings
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own holdings" ON holdings
FOR DELETE USING (auth.uid() = user_id);

-- Transactions policies
CREATE POLICY "Users can view own transactions" ON transactions
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create transactions" ON transactions
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Preferences policies
CREATE POLICY "Users can view own preferences" ON user_preferences
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own preferences" ON user_preferences
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can create preferences" ON user_preferences
FOR INSERT WITH CHECK (auth.uid() = user_id);
```

Click "Run"

---

## Step 4: Run Locally (2 minutes)

### Option A: Simple HTTP Server (Recommended)
```bash
# Using Python (built-in on Mac/Linux)
python3 -m http.server 8000

# Then open browser to:
# http://localhost:8000
```

### Option B: Node.js HTTP Server
```bash
# Install if not already
npm install -g http-server

# Run
http-server -p 8000

# Then open browser to:
# http://localhost:8000
```

### Option C: Direct Browser (No Server)
1. Simply double-click `index.html` to open in browser
2. Note: Some features may not work without a server

---

## Step 5: Test It! (Let's Go!)

### 5.1 Open in Browser
Open your browser to `http://localhost:8000`

You should see:
- ✅ Bahi-Khata logo in header
- ✅ Navigation menu
- ✅ Marketing/landing page
- ✅ Theme toggle button (sun/moon icon)

### 5.2 Test Theme Toggle
1. Click the theme toggle button (sun/moon icon in header)
2. See the page switch between dark and light themes

### 5.3 Test Navigation
1. Click "Dashboard" in the sidebar
2. Click "Stocks" 
3. Click "Mutual Funds"
4. Click back to landing page

### 5.4 Test Modal
1. Go to Stocks page
2. Click "Add Stock" button
3. Fill in the form
4. Click "Save" or "Cancel"

### 5.5 Check Console Logs
1. Open browser DevTools (F12 or Cmd+Option+I)
2. Go to "Console" tab
3. You should see:
   ```
   ✅ Bahi-Khata initializing...
   ✅ Supabase initialized successfully
   ✅ App initialized
   ```

---

## 🎉 You're Ready!

Everything is working! Now you can:

### Next Steps:
1. **Create User Account** - Add authentication signup/login
2. **Load Real Data** - Connect your Supabase database
3. **Add More Features** - Customize as needed
4. **Deploy** - Push to GitHub and deploy to Vercel/Netlify

### Deploy to Production

#### Using Vercel (Easiest):
```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel --prod

# Add environment variables in Vercel dashboard:
# - VITE_SUPABASE_URL
# - VITE_SUPABASE_ANON_KEY
```

#### Using Netlify:
1. Push code to GitHub
2. Connect repository to Netlify
3. Deploy (Netlify auto-detects it's static)

#### Using GitHub Pages:
1. Enable Pages in GitHub settings
2. Set branch to `main`
3. Wait for deploy

---

## 🐛 Troubleshooting

### "Supabase not initialized" Error
**Problem:** Console shows "Supabase not initialized"

**Solution:**
1. Check `js/config.js` has correct credentials
2. Verify Supabase library loaded (should see in console)
3. Hard refresh: Ctrl+Shift+R (or Cmd+Shift+R on Mac)

### Page Not Loading
**Problem:** Blank white page or no content

**Solution:**
1. Open DevTools (F12)
2. Check Console tab for errors
3. Check Network tab to see if files loaded
4. Try hard refresh: Ctrl+Shift+R

### CSS Not Loading
**Problem:** Page loads but looks broken/unstyled

**Solution:**
1. Check `design-system.css` is in `css/` folder
2. Check `<link>` tag in `index.html` is correct:
   ```html
   <link rel="stylesheet" href="css/design-system.css">
   ```
3. Hard refresh: Ctrl+Shift+R

### Modal Not Working
**Problem:** Add Stock button does nothing

**Solution:**
1. Check DevTools Console for JavaScript errors
2. Verify modal HTML exists in `index.html`
3. Check `js/app.js` has event listeners setup

### Database Connection Failed
**Problem:** Can't save data to Supabase

**Solution:**
1. Verify credentials in `js/config.js`
2. Check Supabase project is active
3. Verify Row Level Security (RLS) is setup correctly
4. Check "SQL Editor" in Supabase - tables exist?

---

## 📞 Need Help?

### Check These First:
1. **README.md** - General information
2. **DESIGN.md** - Design system details
3. **Browser Console (F12)** - Error messages
4. **Supabase Docs** - https://supabase.com/docs

### Still Stuck?
1. Check GitHub Issues
2. Open new GitHub Issue with error details
3. Include browser console errors
4. Include Supabase project region

---

## ✅ Checklist

Before deploying to production, verify:

- [ ] Supabase credentials added to `js/config.js`
- [ ] `.env` file created with credentials
- [ ] Database tables created in Supabase
- [ ] Row Level Security (RLS) enabled
- [ ] Local test successful (page loads, theme toggle works)
- [ ] Console shows "✅ App initialized"
- [ ] Modal opens and closes correctly
- [ ] Can add/view/update holdings (after backend integration)

---

## 🚀 Deployment Checklist

Before going to production:

- [ ] Test on mobile, tablet, desktop
- [ ] Test all pages and features
- [ ] Check all buttons work
- [ ] Verify Supabase credentials are correct
- [ ] Set environment variables in hosting platform
- [ ] Test authentication flow
- [ ] Performance test (open DevTools → Lighthouse)
- [ ] Security check (use Supabase security guide)

---

## 📚 Additional Resources

### Official Docs:
- [Supabase Getting Started](https://supabase.com/docs/getting-started/quickstarts/nextjs)
- [Vercel Deployment](https://vercel.com/docs)
- [Netlify Deployment](https://docs.netlify.com/)

### Our Docs:
- **README.md** - Project overview
- **DESIGN.md** - Design system
- **IMPLEMENTATION_GUIDE.md** - Code examples

### JavaScript Tutorials:
- [JavaScript.info](https://javascript.info)
- [MDN Web Docs](https://developer.mozilla.org/)

---

**You did it! 🎉 Your investment tracker is ready to go!**

Happy investing! 📈

---

**Created:** 2026-08-30  
**Version:** 1.0.0  
**Status:** Ready to Deploy ✅
