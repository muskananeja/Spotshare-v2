#!/usr/bin/env node
// Cleans the raw survey export into the { id, lat, lon, name, status, price,
// hours, pay, type, conf } shape used by curbside-mvp's Supabase `spots`
// table (see FALLBACK_SPOTS in index.html).
//
// Usage: node scripts/clean-parking-lots.js [input.csv] [output.json]

const fs = require('fs');
const path = require('path');

const inputPath = process.argv[2] ||
  '/Users/muskananeja/Downloads/Spotshare final data - _Export.csv';
const outputPath = process.argv[3] ||
  path.join(__dirname, '..', 'data', 'mumbai-parking-lots.json');

// ─── Minimal CSV parser (handles quoted fields with embedded commas) ──────
function parseCSV(text) {
  const rows = [];
  let row = [], field = '', inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i], next = text[i + 1];
    if (inQuotes) {
      if (c === '"' && next === '"') { field += '"'; i++; }
      else if (c === '"') inQuotes = false;
      else field += c;
    } else if (c === '"') inQuotes = true;
    else if (c === ',') { row.push(field); field = ''; }
    else if (c === '\r') { /* skip */ }
    else if (c === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
    else field += c;
  }
  if (field.length || row.length) { row.push(field); rows.push(row); }
  const header = rows.shift().map(h => h.trim());
  return rows.filter(r => r.length > 1).map(r =>
    Object.fromEntries(header.map((h, i) => [h, (r[i] || '').trim()]))
  );
}

// ─── Exclusion rules: private / restricted / not-currently-public lots ───
const EXCLUDE_PATTERNS = [
  /restrict/i, /residents?-?\s*only/i, /not open to (general )?public/i,
  /not applicable.*(barc|port|colony|residential|diplomatic|corporate|golf)/i,
  /authorized personnel/i, /staff[- ]only/i, /members? only/i,
  /faculty[- ]only/i, /not (a )?public parking/i, /not for public/i,
  /not a parking lot/i, /diplomatic (mission|premises)/i,
  /under redevelopment/i, /may be inaccessible/i,
];

const EXCLUDED_CATEGORIES = new Set(['Private parking', 'Residential parking']);

function isExcluded(row) {
  if (EXCLUDED_CATEGORIES.has(row.type)) return true;
  const blob = `${row.hours} ${row.capacity} ${row.price}`;
  return EXCLUDE_PATTERNS.some(re => re.test(blob));
}

// ─── Field shortening helpers ─────────────────────────────────────────────
function firstClause(text, maxLen = 60) {
  if (!text) return 'Unknown';
  // Split on ';', '|', or an em-dash (—) source attribution — but keep
  // en-dash (–) time ranges like "1–3hr" and parenthetical detail intact.
  const cut = text.split(/[;|]|\s—\s/)[0].trim();
  const out = cut || text.trim();
  return out.length > maxLen ? out.slice(0, maxLen - 1).trim() + '…' : out;
}

function shortenHours(text) {
  if (!text) return 'Unknown';
  if (/24 hours/i.test(text)) return 'Open 24h';
  return firstClause(text);
}

function shortenPrice(text) {
  if (!text) return 'Not published';
  if (/^(not published|unknown|not available|not applicable)/i.test(text.trim())) {
    return 'Not published';
  }
  return firstClause(text, 70);
}

function extractPay(text) {
  const found = new Set();
  if (/upi/i.test(text)) found.add('UPI');
  if (/cash/i.test(text)) found.add('Cash');
  if (/\bcard\b/i.test(text)) found.add('Card');
  if (found.size === 0) return 'Not specified';
  return [...found].join(' & ');
}

function confidenceTag(sourceConfidence) {
  const c = (sourceConfidence || '').toLowerCase();
  if (c === 'verified') return 'Verified · seed data';
  if (c === 'corroborated') return 'Corroborated · seed data';
  return 'Unverified · seed data';
}

// ─── Dedup: collapse rows within ~80m of each other, keep first (lowest lot_num) ───
function haversine(a, b, c, d) {
  const R = 6371000, dL = (c - a) * Math.PI / 180, dN = (d - b) * Math.PI / 180;
  const x = Math.sin(dL / 2) ** 2 + Math.cos(a * Math.PI / 180) * Math.cos(c * Math.PI / 180) * Math.sin(dN / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(x), Math.sqrt(1 - x));
}

function dedup(rows) {
  const kept = [];
  for (const row of rows) {
    const dup = kept.find(k => haversine(k.lat, k.lon, row.lat, row.lon) < 80);
    if (!dup) kept.push(row);
  }
  return kept;
}

// ─── Main ──────────────────────────────────────────────────────────────────
const raw = parseCSV(fs.readFileSync(inputPath, 'utf8'));

const stats = { total: raw.length, excludedPrivate: 0, excludedBadCoords: 0, duplicates: 0 };

let cleaned = raw
  .map(row => ({
    ...row,
    lat: parseFloat(row.lat),
    lon: parseFloat(row.lng),
  }))
  .filter(row => {
    if (!Number.isFinite(row.lat) || !Number.isFinite(row.lon)) {
      stats.excludedBadCoords++;
      return false;
    }
    if (isExcluded(row)) {
      stats.excludedPrivate++;
      return false;
    }
    return true;
  });

const beforeDedup = cleaned.length;
cleaned = dedup(cleaned);
stats.duplicates = beforeDedup - cleaned.length;

const spots = cleaned.map((row, i) => ({
  id: i + 1,
  lat: row.lat,
  lon: row.lon,
  name: row.name.replace(/\s+/g, ' ').trim(),
  status: /limited/i.test(row.capacity) ? 'limited' : 'open',
  price: shortenPrice(row.price),
  hours: shortenHours(row.hours),
  pay: extractPay(row.price),
  type: row.type || 'Surface lot',
  conf: confidenceTag(row.price_source_confidence),
}));

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, JSON.stringify(spots, null, 2));

console.log(`Input rows:        ${stats.total}`);
console.log(`Bad/missing coords: -${stats.excludedBadCoords}`);
console.log(`Private/restricted: -${stats.excludedPrivate}`);
console.log(`Duplicates (<80m):  -${stats.duplicates}`);
console.log(`Output spots:       ${spots.length}`);
console.log(`Written to:         ${outputPath}`);
