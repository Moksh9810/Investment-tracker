// MF search — AMFI ki official NAV file se (mfapi.in ke bharose nahi).
// Server ki taraf se fetch hota hai, isliye browser me CORS/SSL dikkat nahi aati.

let cache = { rows: null, ts: 0 };
const TTL = 6 * 60 * 60 * 1000; // 6 ghante

async function getNavAll() {
  if (cache.rows && Date.now() - cache.ts < TTL) return cache.rows;
  const res = await fetch('https://www.amfiindia.com/spages/NAVAll.txt', {
    headers: { 'User-Agent': 'Mozilla/5.0' }
  });
  const text = await res.text();
  const rows = [];
  for (const line of text.split('\n')) {
    const p = line.split(';');
    // Format: SchemeCode;ISIN1;ISIN2;SchemeName;NAV;Date
    if (p.length >= 6 && /^\d+$/.test(p[0].trim())) {
      const nav = parseFloat(p[4]);
      rows.push({ schemeCode: p[0].trim(), schemeName: p[3].trim(), nav, date: p[5].trim() });
    }
  }
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
      .filter(r => {
        const name = r.schemeName.toLowerCase();
        return tokens.every(t => name.includes(t)); // har shabd naam me ho (kram koi bhi)
      })
      .slice(0, 40)
      .map(r => ({ schemeCode: r.schemeCode, schemeName: r.schemeName }));
    res.status(200).json(out);
  } catch (e) {
    res.status(500).json({ error: 'mf-search failed' });
  }
};

module.exports.getNavAll = getNavAll;
