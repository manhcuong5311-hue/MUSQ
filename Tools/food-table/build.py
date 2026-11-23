#!/usr/bin/env python3
"""MUSQ food table: checks the group files in src/ and compiles the table the
meal scan (server) and the app read.

  python3 -I build.py check src/vn-1.json [more files]   checks files, prints every item
  python3 -I build.py compile                            checks all of src/*.json, writes the outputs

Every number comes from USDA FoodData Central rows (usda/usda_index.tsv, public
domain) or, rarely, an explicit per-100 g value with its source. See SPEC.md.
"""
import glob
import hashlib
import json
import os
import re
import sys
import unicodedata

HERE = os.path.dirname(os.path.abspath(__file__))
INDEX = os.path.join(HERE, "usda", "usda_index.tsv")
ROOT = os.path.normpath(os.path.join(HERE, "..", ".."))
OUTPUTS = [
    os.path.join(ROOT, "functions", "src", "data", "foodTable.json"),
    os.path.join(ROOT, "GymWorkout", "Resources", "FoodTable.json"),
]

ITEM_ID = re.compile(r"^([a-z]{2,4}\.)?[a-z0-9]+(_[a-z0-9]+)*$")
COMPONENT_ID = re.compile(r"^[a-z0-9-]+\.c\.[a-z0-9]+(_[a-z0-9]+)*$")
HIDDEN = ("oil", "sugar", "sauce")
MACROS = ("kcal", "p", "f", "c")

# Size words follow a count: the app writes "2 <word>s", "½ <word>" and
# "≈ ¾ <word>", and the server prints "1 <word> 125 g" in the prompt and cuts
# words at 20 characters. So a size word is one plain noun phrase.
SIZE_WORD_MAX = 20
QUANTITY_WORDS = {"a", "an", "about", "approx", "approximately", "around", "half", "quarter", "one", "two",
                  "some", "few", "several", "một", "hai", "nửa", "khoảng", "vài", "mấy"}
CONNECTORS = {"with", "without", "and", "or", "in", "on", "for", "per", "plus",
              "kèm", "với", "và", "hoặc", "có", "không", "cho", "trong", "trên"}
# The server cuts names at 80 characters.
NAME_MAX = 80


class Problems:
    def __init__(self):
        self.errors, self.warnings = [], []

    def error(self, where, text):
        self.errors.append(f"ERROR {where}: {text}")

    def warn(self, where, text):
        self.warnings.append(f"warn  {where}: {text}")


def load_usda():
    usda = {}
    with open(INDEX, encoding="utf-8") as fh:
        next(fh)
        for line in fh:
            fid, _ds, kcal, p, f, c, desc, _cat = line.rstrip("\n").split("\t")
            usda[fid] = {"kcal": float(kcal), "p": float(p), "f": float(f), "c": float(c), "desc": desc}
    return usda


def load_groups(paths, problems):
    nodes = {}  # id -> (node, file, "component" | "item")
    order = []
    for path in paths:
        name = os.path.basename(path)
        try:
            data = json.load(open(path, encoding="utf-8"))
        except Exception as exc:  # noqa: BLE001
            problems.error(name, f"not valid JSON: {exc}")
            continue
        if not isinstance(data, dict) or not isinstance(data.get("items"), list):
            problems.error(name, 'needs {"group": ..., "components": [...], "items": [...]}')
            continue
        for kind_key, kind in (("components", "component"), ("items", "item")):
            for node in data.get(kind_key) or []:
                nid = node.get("id") if isinstance(node, dict) else None
                if not isinstance(nid, str):
                    problems.error(name, f"{kind} without an id: {str(node)[:80]}")
                    continue
                if nid in nodes:
                    problems.error(nid, f"duplicate id (also in {nodes[nid][1]})")
                    continue
                nodes[nid] = (node, name, kind)
                order.append(nid)
    return nodes, order


def resolve(nid, nodes, usda, problems, cache, stack=()):
    """Per-100 g macros and hidden grams per 100 g of a node or an fdc reference."""
    if nid in cache:
        return cache[nid]
    if nid.startswith("fdc:"):
        row = usda.get(nid[4:])
        if row is None:
            problems.error(stack[-1] if stack else nid, f"unknown USDA row {nid}")
            return None
        result = ({k: row[k] for k in MACROS}, {})
        cache[nid] = result
        return result
    if nid not in nodes:
        problems.error(stack[-1] if stack else nid, f"unknown reference {nid}")
        return None
    if nid in stack:
        problems.error(nid, f"reference loop: {' -> '.join(stack + (nid,))}")
        return None
    node = nodes[nid][0]
    sources = [k for k in ("per100", "src", "parts") if k in node]
    if len(sources) != 1:
        problems.error(nid, 'give exactly one of "per100", "src" (one USDA row) or "parts"')
        return None
    result = None
    if "per100" in node:
        per = node["per100"]
        if not isinstance(per, dict) or any(not isinstance(per.get(k), (int, float)) for k in MACROS):
            problems.error(nid, "per100 needs numbers kcal, p, f, c")
            return None
        if not node.get("source"):
            problems.error(nid, 'explicit per100 needs "source" (name and URL)')
        result = ({k: float(per[k]) for k in MACROS}, {})
    elif "src" in node:
        src = node["src"]
        if not isinstance(src, str) or not src.startswith("fdc:"):
            problems.error(nid, 'src must be "fdc:<id>"')
            return None
        inner = resolve(src, nodes, usda, problems, cache, stack + (nid,))
        if inner is None:
            return None
        result = (dict(inner[0]), dict(inner[1]))
    else:
        parts = node["parts"]
        if not isinstance(parts, list) or not parts:
            problems.error(nid, "parts must be a non-empty list")
            return None
        total = {k: 0.0 for k in MACROS}
        hidden = {}
        grams = 0.0
        for part in parts:
            if not (isinstance(part, list) and 2 <= len(part) <= 3 and isinstance(part[0], str)
                    and isinstance(part[1], (int, float)) and part[1] > 0):
                problems.error(nid, f'bad part {part}: use ["fdc:<id>" or an id, grams] or [..., grams, "oil"|"sugar"|"sauce"]')
                continue
            ref, g = part[0], float(part[1])
            if len(part) == 3 and part[2] not in HIDDEN:
                problems.error(nid, f'part {part}: third value must be one of {", ".join(HIDDEN)}')
                continue
            inner = resolve(ref, nodes, usda, problems, cache, stack + (nid,))
            if inner is None:
                continue
            for k in MACROS:
                total[k] += inner[0][k] * g / 100
            if len(part) == 3:
                hidden[part[2]] = hidden.get(part[2], 0.0) + g
            else:
                for k, v in inner[1].items():
                    hidden[k] = hidden.get(k, 0.0) + v * g / 100
            grams += g
        if grams <= 0:
            return None
        per100 = {k: total[k] * 100 / grams for k in MACROS}
        refs = {part[0] for part in parts if isinstance(part, list) and part and isinstance(part[0], str)}
        if len(refs) == 1:
            # One row in parts (a split component, or an item built from one):
            # its kcal and macros are that row's exactly, with no rounding noise.
            inner = cache.get(next(iter(refs)))
            if inner is not None:
                per100 = dict(inner[0])
        result = (per100, {k: v * 100 / grams for k, v in hidden.items()})
        node["_grams"] = grams
    cache[nid] = result
    return result


def size_word_problem(word):
    """Why a piece or serving word can't follow a count, or None when it's a plain noun phrase."""
    word = unicodedata.normalize("NFC", word)
    if word != " ".join(word.split()):
        return "remove the extra spaces"
    if len(word) > SIZE_WORD_MAX:
        return f"{len(word)} characters, at most {SIZE_WORD_MAX}"
    bad = sorted({ch for ch in word if not (ch.isalpha() or ch in " -")})
    if bad:
        return f"letters, spaces and hyphens only: no digits, parentheses, commas, plus signs or slashes ({''.join(bad)})"
    words = word.casefold().split()
    if words[0] in QUANTITY_WORDS:
        return f'starts with the quantity word "{words[0]}"'
    joins = [w for w in words if w in CONNECTORS]
    if joins:
        return f'"{joins[0]}" adds a second thing'
    return None


def check_item(nid, node, per100, problems):
    for lang in ("en", "vi"):
        if not isinstance(node.get(lang), str) or not node[lang].strip():
            problems.error(nid, f'needs a "{lang}" name')
        elif len(node[lang].strip()) > NAME_MAX:
            problems.error(nid, f'the "{lang}" name has {len(node[lang].strip())} characters; the server cuts names at {NAME_MAX}')
    if not ITEM_ID.match(nid):
        problems.error(nid, "item ids are lowercase ascii: a slug, or <cuisine>.<slug>")
    kind = node.get("kind")
    if kind not in ("food", "dish"):
        problems.error(nid, 'kind must be "food" or "dish"')
    if kind == "dish" and not node.get("cuisine"):
        problems.error(nid, 'a dish needs "cuisine" (ISO 3166 alpha-2 country code in lowercase, or "intl")')
    if kind == "dish" and ("." not in nid or nid.split(".")[0] != node.get("cuisine")):
        problems.error(nid, "a dish id is <cuisine>.<slug>")
    unit = node.get("unit")
    if unit not in ("piece", "g"):
        problems.error(nid, 'unit must be "piece" (counted) or "g" (by amount)')
        return None
    size_key = "piece" if unit == "piece" else "serving"
    size = node.get(size_key)
    if not isinstance(size, dict):
        problems.error(nid, f'unit "{unit}" needs "{size_key}": {{"en": ..., "vi": ...}}')
        return None
    for lang in ("en", "vi"):
        if not isinstance(size.get(lang), str) or not size[lang].strip():
            problems.error(nid, f'{size_key} needs an "{lang}" word (e.g. "bowl"/"tô", "egg"/"quả")')
            continue
        why = size_word_problem(size[lang])
        if why:
            problems.error(nid, f'{size_key} word "{size[lang]}": {why}. The app writes "2 <word>s" and '
                                f'"≈ ¾ <word>": use a plain noun ("can", "slice", "bowl", "lon", "lát", "tô") '
                                f'and move the detail into the name or "note"')
    grams = node.get("_grams")
    if grams is not None:
        if "g" in size and abs(size["g"] - grams) > max(1.0, 0.02 * grams):
            problems.error(nid, f"{size_key}.g is {size['g']} but the parts add up to {grams:g} g: parts describe exactly one {size_key}; leave g out")
        g = grams
    else:
        g = size.get("g")
        if not isinstance(g, (int, float)) or g <= 0:
            problems.error(nid, f"{size_key} needs g (edible grams per {size_key})")
            return None
    if per100 is not None:
        if per100["kcal"] > 900 or per100["kcal"] < 0:
            problems.error(nid, f"{per100['kcal']:.0f} kcal per 100 g is impossible")
        atwater = 4 * per100["p"] + 4 * per100["c"] + 9 * per100["f"]
        if per100["kcal"] > 40 and abs(atwater - per100["kcal"]) > 0.3 * per100["kcal"] and node.get("cat") not in ("alcohol", "drink"):
            problems.warn(nid, f"kcal {per100['kcal']:.0f}/100 g vs 4P+4C+9F {atwater:.0f}: check the rows")
        serving_kcal = per100["kcal"] * g / 100
        if serving_kcal > 2500:
            problems.warn(nid, f"{serving_kcal:.0f} kcal per {size_key}: too big?")
    return g


def report_line(nid, node, per100, hidden100, g, problems):
    if per100 is None or g is None:
        return f"{nid}: (not computed)"
    unit = node["unit"]
    size = node["piece"] if unit == "piece" else node["serving"]
    k = per100["kcal"] * g / 100
    line = (f"{nid} | {node.get('vi', '')} | {unit} {g:g} g ({size.get('en', '')}) | {k:.0f} kcal"
            f" P{per100['p'] * g / 100:.1f} F{per100['f'] * g / 100:.1f} C{per100['c'] * g / 100:.1f}"
            f" | {per100['kcal']:.0f}/100g")
    if hidden100:
        line += " | hidden " + ", ".join(f"{c} {v * g / 100:.0f} g" for c, v in sorted(hidden100.items()))
    for ref in node.get("check") or []:
        try:
            per = ref.get("per", "serving")
            base = k if per in ("serving", "piece") else per100["kcal"]
            dev = (base - float(ref["kcal"])) / float(ref["kcal"]) * 100
            line += f" | check {ref['kcal']}/{per} ({ref.get('src', '?')}) {dev:+.0f}%"
            if abs(dev) > 25 and not node.get("note"):
                problems.warn(nid, f"{dev:+.0f}% from {ref.get('src', '?')} ({ref['kcal']} kcal/{per}): fix, or explain in \"note\"")
        except (KeyError, TypeError, ValueError, ZeroDivisionError):
            problems.error(nid, 'check entries are {"kcal": n, "per": "serving"|"piece"|"100g", "src": "...", "url": "..."}')
    return line


def warn_repeated_names(nodes, order, problems):
    """Two items with the same English or Vietnamese name look the same in search."""
    for lang in ("en", "vi"):
        seen = {}
        for nid in order:
            node, _name, kind = nodes[nid]
            if kind != "item" or not isinstance(node.get(lang), str):
                continue
            key = " ".join(unicodedata.normalize("NFC", node[lang]).split()).casefold()
            if key in seen:
                problems.warn(nid, f'same {lang} name as {seen[key]} ("{node[lang].strip()}"): make one more specific')
            else:
                seen[key] = nid


def is_split(node):
    """One USDA row in parts with its fat or sugar share tagged: a split component."""
    parts = node.get("parts")
    if not isinstance(parts, list) or not parts or not all(isinstance(p, list) and len(p) >= 2 for p in parts):
        return False
    refs = {p[0] for p in parts}
    first = parts[0][0]
    return (len(refs) == 1 and isinstance(first, str) and first.startswith("fdc:")
            and any(len(p) == 3 and p[2] in ("oil", "sugar") for p in parts))


def warn_hidden_rows(nodes, order, usda, problems):
    """A USDA row that a split component splits, or one with the same per-100 g
    values, hides its added fat or sugar wherever it's used untagged (a recipe
    part, or a single-row item's src) and counts its whole weight when it's
    tagged "oil" or "sugar"."""
    same = {}
    for fid, row in usda.items():
        same.setdefault(tuple(row[k] for k in MACROS), []).append(fid)
    covered = {}  # "fdc:<id>" -> (the split row, a split component, what it tags)
    for nid in order:
        node, _name, kind = nodes[nid]
        if kind != "component" or not is_split(node):
            continue
        ref = node["parts"][0][0]
        tags = {p[2] for p in node["parts"] if len(p) == 3}
        what = " and ".join(w for t, w in (("oil", "added fat"), ("sugar", "added sugar")) if t in tags)
        row = usda.get(ref[4:])
        if row is not None:
            for fid in same[tuple(row[k] for k in MACROS)]:
                covered.setdefault("fdc:" + fid, (ref, nid, what))
    for nid in order:
        node, _name, _kind = nodes[nid]
        if is_split(node):
            continue
        natural = node.get("natural", [])
        if not (isinstance(natural, list) and all(isinstance(r, str) and r.startswith("fdc:") for r in natural)):
            problems.error(nid, '"natural" lists the rows ("fdc:<id>") a recipe uses untagged on purpose')
            natural = []
        uses = []
        if isinstance(node.get("src"), str):
            uses.append((node["src"], None, True))
        for part in node.get("parts") or []:
            if isinstance(part, list) and len(part) in (2, 3) and isinstance(part[0], str):
                uses.append((part[0], part[2] if len(part) == 3 else None, False))
        for ref in natural:
            if not any(r == ref and tag is None and not src for r, tag, src in uses):
                problems.warn(nid, f'"natural" lists {ref}, but no untagged part uses it')
        for ref, tag, src in uses:
            if ref not in covered or tag == "sauce" or (tag is None and not src and ref in natural):
                continue
            row, comp, what = covered[ref]
            alias = "" if ref == row else f" (the same values as {row})"
            if src:
                problems.warn(nid, f"is {ref}{alias} alone, so it shows none of the {what} that {comp} tags: "
                                   f"build it from a split component of your group")
            elif tag is None:
                problems.warn(nid, f"uses {ref}{alias} untagged, which hides the {what} that {comp} tags: use a "
                                   f'split component of your group, or list the row in "natural" and say why in "note"')
            else:
                problems.warn(nid, f'tags {ref}{alias} "{tag}" by its whole weight, but only its share is '
                                   f"{tag}: use a split component of your group (as {comp}), untagged")


def content_version(compiled):
    """The table's version: a number from a hash of the compiled items, so it
    changes exactly when what the server and the app read changes. 31 bits,
    so it fits a signed 32-bit integer anywhere it is stored."""
    text = json.dumps(compiled, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    return (int(hashlib.sha256(text.encode("utf-8")).hexdigest()[:8], 16) & 0x7FFFFFFF) or 1


def run(paths, compile_outputs):
    problems = Problems()
    usda = load_usda()
    nodes, order = load_groups(paths, problems)
    cache = {}
    lines, compiled = [], []
    for nid in order:
        node, name, kind = nodes[nid]
        got = resolve(nid, nodes, usda, problems, cache)
        if kind == "component":
            if not COMPONENT_ID.match(nid):
                problems.error(nid, "component ids look like <group>.c.<slug>")
            for lang in ("en", "vi"):
                if not node.get(lang):
                    problems.error(nid, f'component needs an "{lang}" name')
            continue
        per100, hidden100 = got if got else (None, {})
        g = check_item(nid, node, per100, problems)
        lines.append(report_line(nid, node, per100, hidden100, g, problems))
        if per100 is not None and g is not None:
            unit = node["unit"]
            size = dict(node["piece"] if unit == "piece" else node["serving"])
            size["g"] = round(g, 1)
            entry = {
                "id": nid, "kind": node["kind"], "en": node["en"].strip(), "vi": node["vi"].strip(),
                "unit": unit, "size": {"g": size["g"], "en": size["en"], "vi": size["vi"]},
                "per100": {k: round(per100[k], 1) for k in MACROS},
            }
            if node.get("cuisine"):
                entry["cuisine"] = node["cuisine"]
            if node.get("cat"):
                entry["cat"] = node["cat"]
            if node.get("aka"):
                entry["aka"] = [a for a in node["aka"] if isinstance(a, str)][:6]
            hidden = {c: round(v, 1) for c, v in hidden100.items() if v >= 0.05}
            if hidden:
                entry["hidden100"] = hidden
            compiled.append(entry)
    warn_repeated_names(nodes, order, problems)
    warn_hidden_rows(nodes, order, usda, problems)
    print("\n".join(lines))
    print()
    for text in problems.warnings + problems.errors:
        print(text)
    print(f"\n{len(lines)} items, {len(problems.errors)} errors, {len(problems.warnings)} warnings")
    if compile_outputs:
        if problems.errors:
            print("not written: fix the errors first")
            return 1
        table = {"version": content_version(compiled),
                 "source": "USDA FoodData Central (public domain) and MUSQ recipes", "items": compiled}
        text = json.dumps(table, ensure_ascii=False, separators=(",", ":"))
        for out in OUTPUTS:
            os.makedirs(os.path.dirname(out), exist_ok=True)
            with open(out, "w", encoding="utf-8") as fh:
                fh.write(text)
            print("wrote", os.path.relpath(out, ROOT), f"{len(text) / 1024:.0f} KB")
        print(f"{len(compiled)} items, version {table['version']}")
    return 1 if problems.errors else 0


if __name__ == "__main__":
    if len(sys.argv) >= 3 and sys.argv[1] == "check":
        sys.exit(run(sys.argv[2:], False))
    if len(sys.argv) == 2 and sys.argv[1] == "compile":
        sys.exit(run(sorted(glob.glob(os.path.join(HERE, "src", "*.json"))), True))
    print(__doc__)
    sys.exit(2)
