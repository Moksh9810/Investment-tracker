#!/bin/bash

# ============================================
# Bahi-Khata Quick Setup Script
# Run: bash QUICK_SETUP.sh
# ============================================

echo "🚀 Bahi-Khata Setup Starting..."

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: index.html not found. Run this script from the bahi-khata folder."
    exit 1
fi

echo "✅ Files found"

# Initialize Git
echo "📦 Initializing Git..."
git init
git add .
git commit -m "Initial commit: Bahi-Khata v1.0.0 - Production ready"

echo ""
echo "✅ Git initialized!"
echo ""
echo "📋 NEXT STEPS:"
echo ""
echo "1️⃣  Go to https://supabase.com and create account"
echo ""
echo "2️⃣  Create new project, then copy:"
echo "   - Project URL (https://xxxxx.supabase.co)"
echo "   - Anon Key (eyJ...)"
echo ""
echo "3️⃣  Edit these files and paste your credentials:"
echo "   - js/config.js (lines 9-10)"
echo "   - .env file (lines 7-8)"
echo ""
echo "4️⃣  Go to Supabase SQL Editor and run the SQL from SETUP_GUIDE.md"
echo ""
echo "5️⃣  Test locally:"
echo "   python3 -m http.server 8000"
echo "   Then open: http://localhost:8000"
echo ""
echo "6️⃣  Push to GitHub:"
echo "   git remote add origin https://github.com/Moksh9810/Investment-tracker.git"
echo "   git push -u origin main"
echo ""
echo "7️⃣  Deploy to Vercel:"
echo "   npm i -g vercel"
echo "   vercel --prod"
echo ""
echo "8️⃣  Add environment variables in Vercel dashboard:"
echo "   - VITE_SUPABASE_URL"
echo "   - VITE_SUPABASE_ANON_KEY"
echo ""
echo "🎉 Done! Visit your Vercel URL"
