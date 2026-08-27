// Ek scheme ka aaj ka NAV — AMFI official file se.

let cache = { rows: null, ts: 0 };
const TTL = 6 * 60 * 60 * 1000;

async function getNavAll() {
  if (cache.rows && Date.now() - cache.ts < TTL) return cache.rows;
  const res = await fetch('https://www.amfiindia.com/spages/NAVAll.txt', {
    headers: { 'User-Agent': 'Mozilla/5.0' }
  });
  const text = await res.text();
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
  try {
    const code = (req.query.code || '').toString().trim();
    if (!code) return res.status(400).json({ error: 'code required' });
    const rows = await getNavAll();
    const row = rows.find(r => r.schemeCode === code);
    if (!row) return res.status(404).json({ error: 'not found' });
    res.status(200).json({ schemeCode: row.schemeCode, schemeName: row.schemeName, nav: row.nav, date: row.date });
  } catch (e) {
    res.status(500).json({ error: 'mf failed' });
  }
};
