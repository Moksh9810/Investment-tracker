// Ek scheme ka aaj ka NAV — AMFI (do source), phir mfapi.in fallback.
let cache = { rows: null, ts: 0 };
const TTL = 6 * 60 * 60 * 1000;
const AMFI_URLS = [
  'https://www.amfiindia.com/spages/NAVAll.txt',
  'https://portal.amfiindia.com/spages/NAVAll.txt'
];

async function getNavAll() {
  if (cache.rows && Date.now() - cache.ts < TTL) return cache.rows;
  let text = null, lastErr = 'unknown';
  for (const url of AMFI_URLS) {
    try {
      const res = await fetch(url, { headers: { 'User-Agent': 'Mozilla/5.0', 'Accept': 'text/plain,*/*' } });
      if (res.ok) { text = await res.text(); break; }
      lastErr = 'HTTP ' + res.status + ' @ ' + url;
    } catch (e) { lastErr = (e && e.message) + ' @ ' + url; }
  }
  if (!text) throw new Error('AMFI fetch failed: ' + lastErr);
  const rows = [];
  for (const line of text.split('\n')) {
    const p = line.split(';');
    if (p.length >= 6 && /^\d+$/.test(p[0].trim())) {
      rows.push({ schemeCode: p[0].trim(), schemeName: p[3].trim(), nav: parseFloat(p[4]), date: p[5].trim() });
    }
  }
  cache = { rows, ts: Date.now() };
  return rows;
}

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  const code = (req.query.code || '').toString().trim();
  if (!code) return res.status(400).json({ error: 'code required' });
  // 1) AMFI
  try {
    const rows = await getNavAll();
    const row = rows.find(r => r.schemeCode === code);
    if (row && isFinite(row.nav)) {
      return res.status(200).json({ schemeCode: row.schemeCode, schemeName: row.schemeName, nav: row.nav, date: row.date, src: 'amfi' });
    }
  } catch (e) { /* niche fallback */ }
  // 2) mfapi.in fallback
  try {
    const r = await fetch(`https://api.mfapi.in/mf/${code}/latest`);
    const j = await r.json();
    if (j && j.data && j.data[0]) {
      return res.status(200).json({ schemeCode: code, schemeName: j.meta && j.meta.scheme_name, nav: parseFloat(j.data[0].nav), date: j.data[0].date, src: 'mfapi' });
    }
  } catch (e) {}
  return res.status(502).json({ error: 'NAV nahi mila (AMFI/mfapi dono se)' });
};
