#!/usr/bin/env python3
"""UI strings: what the compiler extracted from the Swift code (Localizable
table), what still looks like unlocalized English, and the String Catalog.

  ui.py keys [--dd DERIVED] [--out FILE]   every extracted key with its locations
  ui.py audit [--dd DERIVED]               string literals in the app's Swift files
                                           that are not extracted and look shown
  ui.py catalog FILE.json [--dd DERIVED] [--lang vi] [--keep-stale]
                                           write GymWorkout/Localization/Localizable.xcstrings
                                           the way Xcode does (its key order and JSON
                                           layout): every extracted key, FILE's
                                           translations (key -> text) and the ones
                                           already there

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
    """key -> {'value', 'comment', 'locations': [file:line]}. A key used in
    several places carries every distinct comment, sorted and joined with a
    newline, the way Xcode merges them into the catalog."""
    out, comments = {}, {}
    for f in stringsdata(dd):
        d = json.load(open(f))
        src = os.path.basename(d.get('source', f))
        for e in d['tables'].get(table, []):
            k = out.setdefault(e['key'], {'value': e.get('value'), 'comment': '', 'locations': []})
            if e.get('value') is not None and k['value'] is None: k['value'] = e['value']
            if e.get('comment'): comments.setdefault(e['key'], set()).add(e['comment'])
            loc = f"{src}:{e['location']['startingLine']}"
            if loc not in k['locations']: k['locations'].append(loc)
    for key, cs in comments.items():
        out[key]['comment'] = '\n'.join(sorted(cs))
    for k in out.values():
        k['locations'].sort()
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
                if src[j] == '\\' and src[j + 1] == 'u' and src[j + 2:j + 3] == '{':
                    end = src.find('}', j)
                    buf.append(chr(int(src[j + 3:end], 16))); j = end + 1; continue
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
    r'productID|ProductID|url|URL|string|format|dateFormat|locale|identifier|scheme|path|comment|defaultValue)\s*[:(]\s*$|'
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


SORTER = r'''
import Foundation
let url = URL(fileURLWithPath: CommandLine.arguments[1])
let keys = try! JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [String]
let sorted = keys.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
FileHandle.standardOutput.write(try! JSONSerialization.data(withJSONObject: sorted))
'''


def xcode_sorted(keys):
    """Xcode's key order in a String Catalog: Foundation's
    localizedStandardCompare (checked on the file Xcode wrote: 0 pairs out of
    order), run through `xcrun swift`."""
    import subprocess, tempfile
    with tempfile.TemporaryDirectory() as d:
        kp, sp = os.path.join(d, 'k.json'), os.path.join(d, 's.swift')
        json.dump(keys, open(kp, 'w', encoding='utf-8'), ensure_ascii=False)
        open(sp, 'w').write(SORTER)
        return json.loads(subprocess.run(['xcrun', 'swift', sp, kp], capture_output=True, check=True).stdout)


def xcode_json(obj):
    """JSON the way Xcode writes a catalog: `"key" : value`, two-space indent,
    an empty object as `{` blank line `}`."""
    text = json.dumps(obj, indent=2, ensure_ascii=False, separators=(',', ' : '))
    return re.sub(r'^( *)(.*?)\{\}(,?)$', lambda m: f'{m.group(1)}{m.group(2)}{{\n\n{m.group(1)}}}{m.group(3)}',
                  text, flags=re.M)


def catalog(dd, new_file, lang, keep_stale=False):
    """Rewrite the catalog as Xcode would after a build, plus FILE's
    translations: entries already there keep their fields, explicit keys
    (`String(localized: "a.b", defaultValue: "X")`) carry
    `extracted_with_value` and their English, keys no longer in the code are
    dropped (or kept as stale)."""
    from collections import OrderedDict as OD
    ks = keys(dd)
    raw = open(CATALOG, encoding='utf-8').read() if os.path.exists(CATALOG) else ''
    old = json.loads(raw, object_pairs_hook=OD) if raw else {'sourceLanguage': 'en', 'strings': {}, 'version': '1.0'}
    new = json.load(open(new_file, encoding='utf-8')) if new_file else {}
    strings, missing = {}, []
    for k, info in ks.items():
        entry = OD(old['strings'].get(k, {}))
        if info['comment']: entry['comment'] = info['comment']
        locs = OD(entry.get('localizations', {}))
        if info['value'] is not None and info['value'] != k:
            entry['extractionState'] = 'extracted_with_value'
            en = locs.get('en', {}).get('stringUnit', {})
            locs['en'] = {'stringUnit': OD([('state', en.get('state', 'new')), ('value', info['value'])])}
        elif entry.get('extractionState') in ('stale', 'extracted_with_value'):
            entry.pop('extractionState')
        t = new.get(k)
        if isinstance(t, str) and t.strip():
            locs[lang] = {'stringUnit': OD([('state', 'translated'), ('value', t)])}
        if k.strip() and lang not in locs: missing.append(k)
        if locs: entry['localizations'] = OD(sorted(locs.items()))
        else: entry.pop('localizations', None)
        strings[k] = OD(sorted(entry.items()))
    stale = [k for k in old['strings'] if k not in ks]
    if keep_stale:
        for k in stale:
            e = OD(old['strings'][k]); e['extractionState'] = 'stale'
            strings[k] = OD(sorted(e.items()))
    data = OD([('sourceLanguage', 'en'), ('strings', OD((k, strings[k]) for k in xcode_sorted(list(strings)))),
               ('version', old.get('version', '1.0'))])
    open(CATALOG, 'w', encoding='utf-8').write(xcode_json(data) + ('\n' if raw.endswith('\n') else ''))
    print(f'{len(strings)} keys, {len(strings) - len(missing)} with {lang}, {len(missing)} missing; '
          f'{len(stale)} keys no longer in the code {"kept as stale" if keep_stale else "dropped"}')
    return missing


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    k = sub.add_parser('keys'); k.add_argument('--dd', default=DEFAULT_DD); k.add_argument('--out')
    a = sub.add_parser('audit'); a.add_argument('--dd', default=DEFAULT_DD)
    c = sub.add_parser('catalog'); c.add_argument('file', nargs='?'); c.add_argument('--dd', default=DEFAULT_DD)
    c.add_argument('--lang', default='vi'); c.add_argument('--keep-stale', action='store_true')
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
        catalog(args.dd, args.file, args.lang, args.keep_stale)


if __name__ == '__main__':
    main()
