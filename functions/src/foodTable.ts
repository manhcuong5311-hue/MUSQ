/**
 * The food table the meal scan grounds its numbers in: Vietnamese,
 * international and generic foods with kcal and macros per 100 g, compiled
 * by Tools/food-table/build.py (see SPEC.md there) into
 * src/data/foodTable.json. tsc copies that file to lib/data/ (tsconfig
 * "include"), so it deploys with the code; the app ships the same file.
 * Read once per instance, on the first scan. When it can't be read or holds
 * no usable entry, scans run as they did before it: the model's own
 * estimates.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { logger } from "firebase-functions/v2";

/** Grams of added fat ("oil"), added sugar and sauces or dips, which a
 *  photo can't show; already counted in the kcal and macros. */
export interface Hidden { oil?: number; sugar?: number; sauce?: number }
export const HIDDEN_KEYS = ["oil", "sugar", "sauce"] as const;

export interface FoodEntry {
  id: string;
  kind: "dish" | "food";
  /** Lowercase ISO 3166 alpha-2 code, or "intl"; none for generic foods. */
  cuisine?: string;
  en: string;
  vi: string;
  /** "piece": a counted food, size.g is one piece. "g": a food by amount,
   *  size.g is a typical serving. */
  unit: "piece" | "g";
  size: { g: number; en: string; vi: string };
  /** kcal and grams of protein, fat and carbs per 100 g as eaten. */
  per100: { kcal: number; p: number; f: number; c: number };
  /** Hidden grams per 100 g. */
  hidden100?: Hidden;
}

export interface FoodTable {
  /** build.py's integer from the table's content, so it changes with every
   *  revision; 0 when the file has none. It names the prompt cache, and
   *  each scan sends it to the app (Meal.tableVersion; null for 0), which
   *  takes numbers from its own copy of an entry only when its table has
   *  the same version. */
  version: number;
  entries: ReadonlyMap<string, FoodEntry>;
  /** Every entry as one prompt line, grouped by cuisine and kind. */
  lines: string;
}

const ID = /^[a-z0-9][a-z0-9._-]{0,79}$/;

const num = (value: unknown) => (typeof value === "number" && Number.isFinite(value) ? value : NaN);

/** One line of text with no "|" (the prompt's column separator). */
const clean = (value: unknown, max: number) =>
  typeof value === "string" ? value.replace(/[|\s]+/g, " ").trim().slice(0, max) : "";

/** The longest size word the prompt takes; build.py holds the compiled
 *  words to the same limit, so this only guards against a stray one. */
const SIZE_WORD_MAX = 20;

/** A size word on one line, at most SIZE_WORD_MAX characters. A longer one
 *  first loses its qualifier ("drumstick (edible part)" → "drumstick"),
 *  then whole words from the end: it's never cut inside a word. "" when
 *  not even its first word fits. */
export function sizeWord(value: unknown): string {
  const word = clean(value, 200);
  if (word.length <= SIZE_WORD_MAX) return word;
  const head = word.split(/\s*[(,]/)[0].trim();
  if (head && head.length <= SIZE_WORD_MAX) return head;
  const text = head || word;
  // The last space at or before the limit ends the last whole word.
  const end = text.slice(0, SIZE_WORD_MAX + 1).lastIndexOf(" ");
  return end > 0 ? text.slice(0, end).replace(/[\s(,+\/-]+$/, "") : "";
}

/** One compiled entry, or undefined when it isn't usable. */
function readEntry(value: unknown): FoodEntry | undefined {
  if (!value || typeof value !== "object") return undefined;
  const e = value as Record<string, unknown>;
  const id = typeof e.id === "string" ? e.id.trim() : "";
  const unit = e.unit === "piece" || e.unit === "g" ? e.unit : undefined;
  const size = (e.size && typeof e.size === "object" ? e.size : {}) as Record<string, unknown>;
  const per = (e.per100 && typeof e.per100 === "object" ? e.per100 : {}) as Record<string, unknown>;
  const g = num(size.g);
  const [kcal, p, f, c] = [num(per.kcal), num(per.p), num(per.f), num(per.c)];
  const en = clean(e.en, 80) || clean(e.vi, 80);
  const vi = clean(e.vi, 80) || en;
  if (!ID.test(id) || !unit || !en || !(g > 0 && g <= 5000)) return undefined;
  if (!(kcal >= 0 && kcal <= 900) || ![p, f, c].every((x) => x >= 0 && x <= 100)) return undefined;
  const raw = (e.hidden100 && typeof e.hidden100 === "object" ? e.hidden100 : {}) as Record<string, unknown>;
  const hidden: Hidden = {};
  for (const key of HIDDEN_KEYS) {
    const grams = num(raw[key]);
    if (grams > 0 && grams <= 100) hidden[key] = grams;
  }
  const word = unit === "piece" ? "piece" : "serving";
  const cuisine = typeof e.cuisine === "string" && /^[a-z]{2,4}$/.test(e.cuisine) ? e.cuisine : undefined;
  return {
    id,
    kind: e.kind === "dish" ? "dish" : "food",
    ...(cuisine ? { cuisine } : {}),
    en,
    vi,
    unit,
    size: { g, en: sizeWord(size.en) || word, vi: sizeWord(size.vi) || sizeWord(size.en) || word },
    per100: { kcal, p, f, c },
    ...(Object.keys(hidden).length > 0 ? { hidden100: hidden } : {}),
  };
}

/** The cuisines' names for the prompt's group headers, fixed here rather
 *  than read from the runtime's ICU data (Intl.DisplayNames), whose names
 *  can change with a Node update and would change the cached prefix. A
 *  test checks that every cuisine in the bundled table has one. */
export const CUISINES: ReadonlyMap<string, string> = new Map(Object.entries({
  intl: "International",
  ar: "Argentina", at: "Austria", au: "Australia", bd: "Bangladesh", be: "Belgium", br: "Brazil",
  ca: "Canada", ch: "Switzerland", cn: "China", co: "Colombia", cu: "Cuba", de: "Germany",
  dk: "Denmark", eg: "Egypt", es: "Spain", et: "Ethiopia", fr: "France", gb: "United Kingdom",
  gh: "Ghana", gr: "Greece", hk: "Hong Kong", hu: "Hungary", id: "Indonesia", ie: "Ireland",
  il: "Israel", in: "India", ir: "Iran", it: "Italy", jm: "Jamaica", jo: "Jordan", jp: "Japan",
  ke: "Kenya", kh: "Cambodia", kr: "South Korea", la: "Laos", lb: "Lebanon", lk: "Sri Lanka",
  ma: "Morocco", mm: "Myanmar", mx: "Mexico", my: "Malaysia", ng: "Nigeria", nl: "Netherlands",
  no: "Norway", np: "Nepal", nz: "New Zealand", pe: "Peru", ph: "Philippines", pk: "Pakistan",
  pl: "Poland", pr: "Puerto Rico", pt: "Portugal", ru: "Russia", sa: "Saudi Arabia", se: "Sweden",
  sg: "Singapore", sn: "Senegal", sy: "Syria", th: "Thailand", tn: "Tunisia", tr: "Türkiye",
  tw: "Taiwan", ua: "Ukraine", us: "United States", ve: "Venezuela", vn: "Vietnam", za: "South Africa",
}));

/** "Vietnam", "Japan", "International", or "Generic" for no cuisine; a
 *  code with no name here stands for itself. */
export function place(cuisine: string | undefined): string {
  if (!cuisine) return "Generic";
  return CUISINES.get(cuisine) ?? cuisine;
}

/** "vn.pho_bo_tai | Phở bò tái | bowl 620 g", or "egg_boiled | Hard-boiled
 *  egg | 1 egg 50 g" for a counted food (the weight of one piece). One name a
 *  line keeps the cached prefix small (about 1,000 lines): the Vietnamese
 *  name for Vietnamese dishes, English for the rest; the model knows the
 *  dishes under either. */
export function promptLine(entry: FoodEntry): string {
  const names = entry.cuisine === "vn" ? entry.vi : entry.en;
  const grams = Math.round(entry.size.g);
  const size = entry.unit === "piece" ? `1 ${entry.size.en} ${grams} g` : `${entry.size.en} ${grams} g`;
  return `${entry.id} | ${names} | ${size}`;
}

/** The entries under short headers: Vietnamese first, then the other
 *  cuisines by name, international, generic last; dishes before foods.
 *  Deterministic (the names are fixed in CUISINES), so the same table file
 *  always gives the same cacheable prefix. */
function promptLines(entries: Iterable<FoodEntry>): string {
  const rank = (cuisine: string | undefined) => (cuisine === "vn" ? 0 : cuisine === "intl" ? 2 : cuisine ? 1 : 3);
  const groups = new Map<string, { cuisine?: string; kind: FoodEntry["kind"]; lines: string[] }>();
  for (const entry of entries) {
    const key = `${entry.cuisine ?? ""}|${entry.kind}`;
    let group = groups.get(key);
    if (!group) groups.set(key, (group = { cuisine: entry.cuisine, kind: entry.kind, lines: [] }));
    group.lines.push(promptLine(entry));
  }
  const order = (a: string, b: string) => (a < b ? -1 : a > b ? 1 : 0);
  return [...groups.values()]
    .sort((a, b) =>
      rank(a.cuisine) - rank(b.cuisine) ||
      order(place(a.cuisine), place(b.cuisine)) ||
      (a.kind === "dish" ? 0 : 1) - (b.kind === "dish" ? 0 : 1))
    .map((group) => [`## ${place(group.cuisine)} ${group.kind === "dish" ? "dishes" : "foods"}`, ...group.lines].join("\n"))
    .join("\n");
}

/** A compiled table checked entry by entry: unusable entries and repeated
 *  ids are skipped (and counted); null when no entry is left. */
export function parseFoodTable(data: unknown): { table: FoodTable | null; skipped: number } {
  const d = (data && typeof data === "object" ? data : {}) as Record<string, unknown>;
  const entries = new Map<string, FoodEntry>();
  let skipped = 0;
  for (const item of Array.isArray(d.items) ? d.items : []) {
    const entry = readEntry(item);
    if (!entry || entries.has(entry.id)) skipped++;
    else entries.set(entry.id, entry);
  }
  if (entries.size === 0) return { table: null, skipped };
  // Any positive integer: build.py derives it from a hash of the content.
  const version = typeof d.version === "number" && Number.isInteger(d.version) && d.version > 0 ? d.version : 0;
  return { table: { version, entries, lines: promptLines(entries.values()) }, skipped };
}

/** Reads a compiled table file: null (logged) when it can't be read or
 *  has no usable entry. */
export function loadFoodTable(path: string): FoodTable | null {
  try {
    const { table, skipped } = parseFoodTable(JSON.parse(readFileSync(path, "utf8")));
    if (!table) {
      logger.warn("food table empty: meal scans run without it", { skipped });
      return null;
    }
    logger.info("food table loaded", { version: table.version, entries: table.entries.size, skipped });
    return table;
  } catch (error) {
    logger.warn("food table unreadable: meal scans run without it", { error: String(error) });
    return null;
  }
}

/** Where the build puts the table: lib/data/foodTable.json. */
export const FOOD_TABLE_PATH = join(__dirname, "data", "foodTable.json");

let cached: FoodTable | null | undefined;

/** The deployed table, read once per instance (a failure too: it's
 *  logged once and not retried). */
export function foodTable(): FoodTable | null {
  if (cached === undefined) cached = loadFoodTable(FOOD_TABLE_PATH);
  return cached;
}
