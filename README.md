# Portfolio Bahi-Khata — Live version (deploy guide)

Ye app aapke stocks, mutual funds aur loan/byaaj ka hisaab rakhta hai, aur
live NAV/price khud le aata hai. Ye "hosted" version banane ke liye niche
diye 5 kadam follow karein (~15 minute, sab free).

## Kya-kya file hai
- `index.html` — poora app (frontend)
- `api/mf-search.js` — fund search (AMFI official data)
- `api/mf.js` — ek fund ka aaj ka NAV
- `api/stock.js` — stock ka live price (Yahoo Finance)

## Deploy kaise karein (Vercel — free, coding nahi)

### Kadam 1: GitHub account
1. https://github.com par jaakar free account banayein.
2. Login ke baad upar-right "+" → **New repository**.
3. Naam dein (jaise `portfolio-bahikhata`), **Public** rehne dein, **Create repository**.

### Kadam 2: File upload
1. Naye repo me link "**uploading an existing file**" par click karein.
2. Is folder ki saari files drag-and-drop karein — **`api` folder samet**
   (taaki `api/mf.js` waala structure bana rahe).
3. Niche **Commit changes** dabayein.

### Kadam 3: Vercel se jodein
1. https://vercel.com par jaayein → **Continue with GitHub** (free).
2. **Add New… → Project** → apna `portfolio-bahikhata` repo **Import** karein.
3. Kuch settings badalne ki zaroorat nahi — seedhe **Deploy** dabayein.

### Kadam 4: Live URL
- 1 minute me Vercel ek link dega, jaise
  `https://portfolio-bahikhata.vercel.app`
- Ye link phone/computer kisi bhi browser me kholein — app live chalega,
  MF search aur "Live Rates Update" dono kaam karenge.

### Kadam 5: Roz ka istemaal
- Link ko phone me bookmark/home-screen par laga lein.
- Data aapke apne browser me save hota hai (localStorage).

## Note
- MF NAV AMFI se roz shaam ko update hota hai — din me ek baar
  "Live Rates Update" kaafi hai.
- Stock price market hours me live rehta hai.
- Data sirf usi browser me dikhega jisme entry ki. Backup chahiye to
  bataiye — main export/import (file me save) ka feature jod dunga.
