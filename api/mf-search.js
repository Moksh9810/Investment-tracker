// MF search — AMFI official NAV file se (do source + saaf error).
let cache = { rows: null, ts: 0 };
const TTL = 6 * 60 * 60 * 1000; // 6 ghante
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
  if (!rows.length) throw new Error('AMFI parse failed (0 rows)');
  cache = { rows, ts: Date.now() };
  return rows;
}

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  try {
    const q = (req.query.q || '').toString().toLowerCase().trim();
    if (q.length < 3) return res.status(200).json([]);
    const tokens = q.split(/\s+/).filter(Boolean);
    const rows = await getNavAll();
    const out = rows
      .filter(r => { const name = r.schemeName.toLowerCase(); return tokens.every(t => name.includes(t)); })
      .slice(0, 40)
      .map(r => ({ schemeCode: r.schemeCode, schemeName: r.schemeName }));
    res.status(200).json(out);
  } catch (e) {
    res.status(500).json({ error: String((e && e.message) || e) });
  }
};

module.exports.getNavAll = getNavAll;
