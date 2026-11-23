#!/usr/bin/env python3
"""Missing-Vietnamese UI keys -> translation batches with code context.

  make_batches.py KEYS.json OUTDIR [--max-words 2300] [--max-keys 300]

KEYS.json is `ui.py keys` output from a fresh lab build. A key is missing
when Localizable.xcstrings has no `vi` for it. Each batch holds whole files'
keys where it can (one file's keys stay together unless the file alone is
bigger than a batch), so a translator sees a screen's strings side by side.
"""
import json, os, re, sys, glob, argparse, collections

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
APP = os.path.join(ROOT, 'GymWorkout')
CATALOG = os.path.join(APP, 'Localization', 'Localizable.xcstrings')

ap = argparse.ArgumentParser()
ap.add_argument('keys'); ap.add_argument('outdir')
ap.add_argument('--max-words', type=int, default=2300)
ap.add_argument('--max-keys', type=int, default=300)
ap.add_argument('--order', help='comma list of basenames giving the file order')
a = ap.parse_args()

keys = json.load(open(a.keys, encoding='utf-8'))
cat = json.load(open(CATALOG, encoding='utf-8'))['strings']
paths = {}
for p in glob.glob(os.path.join(APP, '**', '*.swift'), recursive=True):
    paths.setdefault(os.path.basename(p), p)
src_cache = {}

def lines_of(base):
    if base not in src_cache:
        p = paths.get(base)
        src_cache[base] = open(p, encoding='utf-8').read().split('\n') if p else []
    return src_cache[base]

def context(loc, before=5, after=2):
    base, line = loc.rsplit(':', 1); line = int(line)
    L = lines_of(base)
    lo, hi = max(0, line - 1 - before), min(len(L), line + after)
    out = []
    for i in range(lo, hi):
        mark = '>>' if i == line - 1 else '  '
        out.append(f'{mark}{i + 1:5d} {L[i].rstrip()[:180]}')
    return f'{os.path.relpath(paths.get(base, base), ROOT)}:{line}\n' + '\n'.join(out)

missing = []
for k, info in keys.items():
    if not k.strip():
        continue
    if 'vi' in cat.get(k, {}).get('localizations', {}):
        continue
    en = info['value'] if info.get('value') is not None else k
    locs = info['locations']
    missing.append({
        'key': k,
        'en': en,
        'comment': info.get('comment', ''),
        'locations': locs,
        'context': context(locs[0]),
    })

def words(e): return len(re.findall(r"[A-Za-z']+", e['en'])) + 1

byfile = collections.OrderedDict()
order = a.order.split(',') if a.order else []
missing.sort(key=lambda e: (order.index(e['locations'][0].split(':')[0]) if e['locations'][0].split(':')[0] in order else 999,
                            e['locations'][0].split(':')[0], int(e['locations'][0].split(':')[1])))
for e in missing:
    byfile.setdefault(e['locations'][0].split(':')[0], []).append(e)

batches, cur, cw = [], [], 0
for f, es in byfile.items():
    fw = sum(words(e) for e in es)
    if cur and (cw + fw > a.max_words or len(cur) + len(es) > a.max_keys):
        batches.append(cur); cur, cw = [], 0
    for e in es:
        if cur and (cw + words(e) > a.max_words * 1.15 or len(cur) >= a.max_keys):
            batches.append(cur); cur, cw = [], 0
        cur.append(e); cw += words(e)
if cur: batches.append(cur)

os.makedirs(a.outdir, exist_ok=True)
for i, b in enumerate(batches, 1):
    json.dump(b, open(os.path.join(a.outdir, f'batch_{i:02d}.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    files = collections.Counter(e['locations'][0].split(':')[0] for e in b)
    print(f'batch_{i:02d}: {len(b):4d} keys, {sum(words(e) for e in b):5d} words, files: ' + ', '.join(f'{k}({v})' for k, v in files.items()))
print(f'{len(missing)} missing keys in {len(batches)} batches')
