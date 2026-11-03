#!/usr/bin/env python3
"""Data strings (coaching copy, muscle/equipment names, stances, x-ray demos)
and their translations in GymWorkout/Localization/<lang>.lproj/Content.strings.

The app looks these up by the English string itself (L10n.content), so this
tool finds every such string in the Swift data files, says which ones have
no translation yet, and writes translations into the table.

  content.py extract [--out FILE]      every English data string with context (JSON)
  content.py check [--lang vi] [--list] what is missing / stale in the table
  content.py merge FILE.json [--lang vi] [--drop-stale]
                                       FILE maps English -> translation (or id ->
                                       translation with ids from `extract`);
                                       rewrites the table in source order

Exercise names are never extracted: they stay English in every language.
"""
import argparse, hashlib, json, os, re, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
APP = os.path.join(ROOT, 'GymWorkout')
SOURCES = ['Models/SampleData.swift', 'Models/XRayDemos.swift']

# Labelled arguments whose string is shown on screen.
TEXT_LABELS = {
    'label', 'title', 'intro', 'why', 'mistake', 'correct', 'note',
    'correctBadge', 'mistakeBadge', 'correctCue', 'mistakeCue', 'correctNote', 'mistakeNote',
    'chip', 'caption', 'summary', 'boneLabel', 'muscleLabel',
    'primaryMuscle', 'equipment',
}
# Arrays whose every string is shown on screen.
ARRAY_LABELS = {'setup', 'stabilisers'}
# Positional helpers: callee -> index of the shown argument.
POSITIONAL = {'backAnnotation': 1}
# Fields that are names rather than prose (translated from the glossary).
NAME_FIELDS = {'primaryMuscle', 'equipment', 'stabilisers', 'muscle'}


def unescape(body):
    """A Swift string literal's body -> the runtime string."""
    out, i = [], 0
    while i < len(body):
        c = body[i]
        if c != '\\':
            out.append(c); i += 1; continue
        n = body[i + 1]
        if n == 'u' and body[i + 2] == '{':
            j = body.index('}', i)
            out.append(chr(int(body[i + 3:j], 16))); i = j + 1; continue
        out.append({'n': '\n', 't': '\t', 'r': '\r', '0': '\0', '"': '"', "'": "'", '\\': '\\'}[n])
        i += 2
    return ''.join(out)


def literals(src):
    """Yield (body, start, end, line) for every one-line string literal, and the
    code with comments and string bodies blanked (same offsets)."""
    code = list(src)
    found = []
    i, n, line = 0, len(src), 1
    while i < n:
        c = src[i]
        if c == '\n':
            line += 1; i += 1; continue
        if src.startswith('//', i):
            j = src.find('\n', i); j = n if j < 0 else j
            for k in range(i, j): code[k] = ' '
            i = j; continue
        if src.startswith('/*', i):
            depth, j = 1, i + 2
            while depth and j < n:
                if src.startswith('/*', j): depth += 1; j += 2
                elif src.startswith('*/', j): depth -= 1; j += 2
                else: j += 1
            for k in range(i, j):
                if src[k] != '\n': code[k] = ' '
            line += src.count('\n', i, j); i = j; continue
        if src.startswith('"""', i):
            raise SystemExit(f'multi-line string at line {line}: not handled')
        if c == '"':
            j = i + 1
            while src[j] != '"':
                if src[j] == '\\':
                    if src[j + 1] == '(':
                        raise SystemExit(f'interpolated string at line {line}: not handled')
                    j += 2
                else:
                    j += 1
            found.append((src[i + 1:j], i, j + 1, line))
            for k in range(i + 1, j): code[k] = '_'
            i = j + 1; continue
        i += 1
    return found, ''.join(code)


def extract():
    """Every shown data string, in source order, with where it was seen."""
    rows = []
    for rel in SOURCES:
        src = open(os.path.join(APP, rel), encoding='utf-8').read()
        found, code = literals(src)
        # Content variable -> exercise names, from the content dictionary.
        names_by_var = {}
        for m in re.finditer(r'"((?:[^"\\]|\\.)*)"\s*:\s*(\w+Content)\b', src):
            names_by_var.setdefault(m.group(2), []).append(unescape(m.group(1)))
        stack = []          # (opener, callee-or-label, positional index so far)
        lit_at = {s: (b, e, ln) for b, s, e, ln in found}
        block, block_names = None, []
        i, n = 0, len(code)
        while i < n:
            c = code[i]
            if c == 's' and code.startswith('static ', i):
                m = re.match(r'static\s+(?:let|var|func)\s+(\w+)', code[i:])
                if m and not stack:
                    block = m.group(1); block_names = names_by_var.get(block, [])
            if c in '([':
                head = code[max(0, i - 80):i]
                callee = re.search(r'(\w+)\s*$', head)
                label = re.search(r'(\w+)\s*:\s*$', head)
                stack.append([c, (label.group(1) if c == '[' and label else
                                  callee.group(1) if callee else ''), 0])
            elif c in ')]':
                if stack: stack.pop()
            elif c == ',' and stack:
                stack[-1][2] += 1
            elif c == '"' and i in lit_at:
                body, end, ln = lit_at[i]
                head = code[max(0, i - 80):i]
                label = re.search(r'(\w+)\s*:\s*$', head)
                field = None
                top = stack[-1] if stack else None
                if label and label.group(1) in TEXT_LABELS:
                    field = label.group(1)
                elif label and label.group(1) == 'name' and top and top[1] == 'MuscleActivation':
                    field = 'muscle'
                elif not label and top and top[0] == '[' and top[1] in ARRAY_LABELS:
                    field = top[1]
                elif not label and top and top[0] == '(' and POSITIONAL.get(top[1]) == top[2]:
                    field = 'label'
                if field:
                    text = unescape(body)
                    ex = block_names
                    if field in ('primaryMuscle', 'equipment') and top and top[1] == 'Exercise':
                        m = re.search(r'name:\s*"((?:[^"\\]|\\.)*)"', src[src.rfind('Exercise(', 0, i):i])
                        ex = [unescape(m.group(1))] if m else []
                    rows.append({'en': text, 'field': field, 'block': block or '',
                                 'exercises': ex, 'file': rel, 'line': ln})
                i = end; continue
            i += 1
    return rows


def sid(text):
    return 's' + hashlib.sha1(text.encode('utf-8')).hexdigest()[:10]


def distinct(rows):
    """One entry per English string, first sighting first."""
    seen, out = {}, []
    for r in rows:
        e = seen.get(r['en'])
        if e is None:
            e = {'id': sid(r['en']), 'en': r['en'], 'field': r['field'], 'block': r['block'],
                 'exercises': list(r['exercises']), 'file': r['file'], 'line': r['line'], 'uses': 0}
            seen[r['en']] = e; out.append(e)
        e['uses'] += 1
        for x in r['exercises']:
            if x not in e['exercises'] and len(e['exercises']) < 6: e['exercises'].append(x)
    return out


def table_path(lang):
    return os.path.join(APP, 'Localization', f'{lang}.lproj', 'Content.strings')


STR = re.compile(r'"((?:[^"\\]|\\.)*)"\s*=\s*"((?:[^"\\]|\\.)*)"\s*;')


def read_table(lang):
    p = table_path(lang)
    if not os.path.exists(p): return {}
    t = open(p, encoding='utf-8').read()
    t = re.sub(r'/\*.*?\*/', '', t, flags=re.S)
    return {strings_unescape(k): strings_unescape(v) for k, v in STR.findall(t)}


def strings_unescape(s):
    return re.sub(r'\\(u[0-9a-fA-F]{4}|.)', lambda m: (chr(int(m.group(1)[1:], 16)) if m.group(1)[0] == 'u' and len(m.group(1)) == 5
                                                     else {'n': '\n', 't': '\t', '"': '"', '\\': '\\'}.get(m.group(1), m.group(1))), s)


def strings_escape(s):
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n').replace('\t', '\\t')


def write_table(lang, entries, table):
    """entries: distinct rows in source order; table: en -> translation."""
    p = table_path(lang)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    lines = ['/* Data strings for L10n.content, keyed by the English text.',
             '   Generated by Tools/localization/content.py merge; edit translations',
             '   here or in a merge file, never the keys. */', '']
    written = set()
    for e in entries:
        v = table.get(e['en'])
        if v is None or e['en'] in written: continue
        where = (e['exercises'][0] if e['exercises'] else e['block']) or e['file']
        lines.append(f'/* {where} · {e["field"]} */')
        lines.append(f'"{strings_escape(e["en"])}" = "{strings_escape(v)}";')
        written.add(e['en'])
    stale = [k for k in table if k not in written]
    if stale:
        lines += ['', '/* No longer in the app (kept for reuse; content.py merge --drop-stale removes them). */']
        for k in sorted(stale):
            lines.append(f'"{strings_escape(k)}" = "{strings_escape(table[k])}";')
    open(p, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
    return len(written), len(stale)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    a = sub.add_parser('extract'); a.add_argument('--out')
    c = sub.add_parser('check'); c.add_argument('--lang', default='vi'); c.add_argument('--list', action='store_true')
    m = sub.add_parser('merge'); m.add_argument('file'); m.add_argument('--lang', default='vi')
    m.add_argument('--drop-stale', action='store_true')
    args = ap.parse_args()

    entries = distinct(extract())
    if args.cmd == 'extract':
        data = json.dumps(entries, ensure_ascii=False, indent=1)
        if args.out: open(args.out, 'w', encoding='utf-8').write(data + '\n')
        else: print(data)
        words = sum(len(e['en'].split()) for e in entries)
        print(f'{len(entries)} distinct strings, {words} words', file=sys.stderr)
    elif args.cmd == 'check':
        table = read_table(args.lang)
        missing = [e for e in entries if e['en'] not in table]
        current = {e['en'] for e in entries}
        stale = [k for k in table if k not in current]
        print(f'{len(entries)} strings, {len(entries) - len(missing)} translated, '
              f'{len(missing)} missing, {len(stale)} stale')
        if args.list:
            for e in missing:
                print(f'MISSING {e["file"]}:{e["line"]} [{e["field"]}] {e["en"]}')
            for k in stale:
                print(f'STALE {k}')
        sys.exit(1 if missing else 0)
    elif args.cmd == 'merge':
        new = json.load(open(args.file, encoding='utf-8'))
        by_id = {e['id']: e['en'] for e in entries}
        table = read_table(args.lang)
        added = 0
        for k, v in new.items():
            en = by_id.get(k, k)
            if not isinstance(v, str) or not v.strip(): continue
            if table.get(en) != v: added += 1
            table[en] = v
        if args.drop_stale:
            current = {e['en'] for e in entries}
            table = {k: v for k, v in table.items() if k in current}
        n, stale = write_table(args.lang, entries, table)
        print(f'{added} added or changed; table has {n} current + {stale} stale')


if __name__ == '__main__':
    main()
