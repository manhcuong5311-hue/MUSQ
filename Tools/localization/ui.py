#!/usr/bin/env python3
"""UI strings: what the compiler extracted from the Swift code (Localizable
table), what still looks like unlocalized English, and the String Catalog.

  ui.py keys [--dd DERIVED] [--out FILE]   every extracted key with its locations
  ui.py audit [--dd DERIVED]               string literals in the app's Swift files
                                           that are not extracted and look shown
  ui.py catalog FILE.json [--dd DERIVED] [--lang vi]
                                           write GymWorkout/Localization/Localizable.xcstrings:
                                           every extracted key, FILE's translations
                                           (key -> text) and the ones already there

DERIVED is the DerivedData folder of a build of the app (the lab build's
`$LAB/dd` by default); keys come from its .stringsdata files, so build first.
"""
import argparse, glob, json, os, re, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
APP = os.path.join(ROOT, 'GymWorkout')
CATALOG = os.path.join(APP, 'Localization', 'Localizable.xcstrings')
DATA_FILES = {'Models/SampleData.swift', 'Models/FaultPoses.swift', 'Models/XRayDemos.swift'}
DEFAULT_DD = os.environ.get('LAB', '') and os.path.join(os.environ['LAB'], 'dd')


def stringsdata(dd):
    pat = os.path.join(dd, 'Build/Intermediates.noindex/GymWorkout.build/*/GymWorkout.build/Objects-normal/*/*.stringsdata')
    files = glob.glob(pat)
    if not files: sys.exit(f'no .stringsdata under {dd} — build the app first')
    return files


def keys(dd, table='Localizable'):
    """key -> {'value', 'comment', 'locations': [file:line]}"""
    out = {}
    for f in stringsdata(dd):
        d = json.load(open(f))
        src = os.path.basename(d.get('source', f))
        for e in d['tables'].get(table, []):
            k = out.setdefault(e['key'], {'value': e.get('value'), 'comment': e.get('comment', ''), 'locations': []})
            if e.get('comment') and not k['comment']: k['comment'] = e['comment']
            loc = f"{src}:{e['location']['startingLine']}"
            if loc not in k['locations']: k['locations'].append(loc)
    return out


SPEC = re.compile(r'%(\d+\$)?[-+ #0]*\d*(\.\d+)?(lld|llu|ld|lu|d|u|f|lf|@|s|e|g)')


def norm_key(k):
    return SPEC.sub('§', k.replace('%%', '%'))


def swift_literals(src):
    """(text with interpolations as §, line) for one-line string literals outside comments."""
    out, i, n, line = [], 0, len(src), 1
    while i < n:
        c = src[i]
        if c == '\n': line += 1; i += 1; continue
        if src.startswith('//', i):
            j = src.find('\n', i); i = n if j < 0 else j; continue
        if src.startswith('/*', i):
            j = src.find('*/', i + 2); j = n if j < 0 else j + 2
            line += src.count('\n', i, j); i = j; continue
        if src.startswith('"""', i):
            j = src.find('"""', i + 3); j = n if j < 0 else j + 3
            line += src.count('\n', i, j); i = j; continue
        if c == '"':
            j, buf = i + 1, []
            while j < n and src[j] != '"' and src[j] != '\n':
                if src[j] == '\\' and src[j + 1] == '(':
                    depth, j = 1, j + 2
                    while depth and j < n:
                        if src[j] == '(': depth += 1
                        elif src[j] == ')': depth -= 1
                        elif src[j] == '"':      # nested literal inside the interpolation
                            j += 1
                            while j < n and src[j] != '"': j += 2 if src[j] == '\\' else 1
                        j += 1
                    buf.append('§'); continue
                if src[j] == '\\':
                    buf.append(src[j + 1]); j += 2; continue
                buf.append(src[j]); j += 1
            out.append((''.join(buf), line, src[max(0, i - 120):i]))
            i = j + 1; continue
        i += 1
    return out


IGNORE_BEFORE = re.compile(
    r'(systemName|systemImage|named|forResource|withExtension|forKey|storageKey|key|id|identifier|'
    r'accessibilityIdentifier|rawValue|resource|joint|cueID|subsystem|category|fileName|ofType|'
    r'productID|ProductID|url|URL|string|format|dateFormat|locale|identifier|scheme|path|comment)\s*[:(]\s*$|'
    r'(print|debugPrint|fatalError|assert|assertionFailure|precondition|preconditionFailure|Logger\(\)?\.\w+|'
    r'os_log|NSLog|#Preview|Image|UIImage|Color|URL|AppStorage|SceneStorage|Notification\.Name|'
    r'UserDefaults\.\w+\.\w+|hasPrefix|hasSuffix|contains|replacingOccurrences|components|split|'
    r'firstIndex|range)\s*\(\s*$|case\s*$|==\s*$|!=\s*$|\[\s*$')


def looks_shown(text):
    t = text.replace('§', '').strip()
    if len(t) < 2 or not re.search(r'[A-Za-z]{2}', t): return False
    if re.fullmatch(r'[a-z][A-Za-z0-9]*(\.[A-Za-z0-9_]+)+', t): return False      # sf.symbol / dotted.id
    if re.fullmatch(r'[a-z]+[A-Z_][A-Za-z0-9_]*', t): return False                # camelCase / snake ids
    if re.fullmatch(r'[A-Za-z0-9_]+_[A-Za-z0-9_]*', t): return False              # BONE_names
    if re.search(r'https?://|\.(usdz|usdc|png|jpg|json|hdr|swift)\b', t): return False
    return True


def audit(dd):
    extracted = {norm_key(k) for k in keys(dd)}
    rows = []
    for path in sorted(glob.glob(os.path.join(APP, '**', '*.swift'), recursive=True)):
        rel = os.path.relpath(path, APP)
        if rel in DATA_FILES or rel.startswith('Localization/'): continue
        src = open(path, encoding='utf-8').read()
        for text, line, before in swift_literals(src):
            if not looks_shown(text): continue
            if norm_key(text) in extracted: continue
            if IGNORE_BEFORE.search(before): continue
            if re.search(r'(L10n\.content|localizedContent)\s*\(?\s*$', before): continue
            rows.append(f'{rel}:{line}: "{text}"')
    return rows


def catalog(dd, new_file, lang):
    ks = keys(dd)
    old = json.load(open(CATALOG, encoding='utf-8')) if os.path.exists(CATALOG) else {'sourceLanguage': 'en', 'strings': {}, 'version': '1.0'}
    new = json.load(open(new_file, encoding='utf-8')) if new_file else {}
    strings = {}
    missing = []
    for k in sorted(ks, key=str.lower):
        if not k.strip(): continue          # TextField("", …) and empty hints
        info = ks[k]
        entry = {}
        if info['comment']: entry['comment'] = info['comment']
        locs = dict(old['strings'].get(k, {}).get('localizations', {}))
        if info['value'] is not None:
            locs['en'] = {'stringUnit': {'state': 'translated', 'value': info['value']}}
        t = new.get(k)
        if isinstance(t, str) and t.strip():
            locs[lang] = {'stringUnit': {'state': 'translated', 'value': t}}
        if lang not in locs: missing.append(k)
        if locs: entry['localizations'] = dict(sorted(locs.items()))
        strings[k] = entry
    stale = [k for k in old['strings'] if k not in ks]
    data = {'sourceLanguage': 'en', 'strings': strings, 'version': '1.0'}
    open(CATALOG, 'w', encoding='utf-8').write(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=False) + '\n')
    print(f'{len(strings)} keys, {len(strings) - len(missing)} with {lang}, {len(missing)} missing; '
          f'dropped {len(stale)} keys no longer in the code')
    return missing


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    k = sub.add_parser('keys'); k.add_argument('--dd', default=DEFAULT_DD); k.add_argument('--out')
    a = sub.add_parser('audit'); a.add_argument('--dd', default=DEFAULT_DD)
    c = sub.add_parser('catalog'); c.add_argument('file', nargs='?'); c.add_argument('--dd', default=DEFAULT_DD)
    c.add_argument('--lang', default='vi')
    args = ap.parse_args()
    if not args.dd: sys.exit('pass --dd or set LAB')
    if args.cmd == 'keys':
        data = json.dumps(keys(args.dd), ensure_ascii=False, indent=1)
        if args.out: open(args.out, 'w', encoding='utf-8').write(data + '\n')
        else: print(data)
    elif args.cmd == 'audit':
        rows = audit(args.dd)
        print('\n'.join(rows)); print(f'{len(rows)} literals look shown but are not localizable', file=sys.stderr)
    elif args.cmd == 'catalog':
        catalog(args.dd, args.file, args.lang)


if __name__ == '__main__':
    main()
