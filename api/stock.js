// Stock ka live price — Yahoo Finance se, server ki taraf se (CORS ka jhanjhat nahi).

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  try {
    const symbol = (req.query.symbol || '').toString().trim().toUpperCase();
    const exch = (req.query.exch || 'NSE').toString().toUpperCase();
    if (!symbol) return res.status(400).json({ error: 'symbol required' });
    const suffix = exch === 'BSE' ? '.BO' : '.NS';
    const url = `https://query1.finance.yahoo.com/v8/finance/chart/${symbol}${suffix}?interval=1d&range=1d`;
    const r = await fetch(url, { headers: { 'User-Agent': 'Mozilla/5.0' } });
    const j = await r.json();
    const price = j && j.chart && j.chart.result && j.chart.result[0] && j.chart.result[0].meta
      ? j.chart.result[0].meta.regularMarketPrice : null;
    if (!isFinite(price)) return res.status(404).json({ error: 'no price' });
    res.status(200).json({ symbol, price });
  } catch (e) {
    res.status(500).json({ error: 'stock failed' });
  }
};
