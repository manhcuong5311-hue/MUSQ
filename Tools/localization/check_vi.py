#!/usr/bin/env python3
"""Mechanical checks on {key: vietnamese} against the English.

  check_vi.py TRANSLATIONS.json BATCH.json [BATCH.json ...]   -> issues as JSON lines

Checks: format specifiers (same set; positional %1$@ allowed), exercise
names and protected words kept, UPPER CASE kept, length of short labels,
decimal points, spelling per the glossary, leftover English, end
punctuation, quotes, ellipsis.
"""
import json, re, sys, os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
NAMES = [n.strip() for n in open(os.path.join(ROOT, 'Tools/localization/exercise_names.txt'), encoding='utf-8') if n.strip()]
NAMES.sort(key=len, reverse=True)
PROTECTED = ['MUSQ', 'Premium', 'Apple Health', 'kcal', 'BMI', 'BMR', 'TDEE', '1RM', 'RIR', 'RPE', 'AI']
SPEC = re.compile(r'%(?:(\d+)\$)?([-+#0]*\d*(?:\.\d+)?)(lld|llu|ld|lu|d|u|f|lf|@|s|e|g)')  # no space flag: "10% under" is text
SPELL = {'xóa': 'xoá', 'Xóa': 'Xoá', 'hủy': 'huỷ', 'Hủy': 'Huỷ', 'hòa': 'hoà', 'minh họa': 'minh hoạ', 'khoẻ': 'khỏe', 'tuỳ': 'tùy'}
ENGLISH_LEFT = re.compile(r"\b(the|and|your|you|with|this|that|today|week|goal|meal|steps|sleep|water|weight|workout|log|plan|daily|calories|protein|carbs)\b", re.I)


def specs(s):
    s = s.replace('%%', '')
    out = []
    for i, m in enumerate(SPEC.finditer(s)):
        out.append((m.group(1), m.group(2), m.group(3)))
    return out


def spec_ok(en, vi):
    e, v = specs(en), specs(vi)
    if len(e) != len(v):
        return f'{len(e)} specifiers in English, {len(v)} in Vietnamese'
    if all(x[0] is None for x in v):
        if [x[1:] for x in e] != [x[1:] for x in v]:
            return f'specifier types/order differ: {e} vs {v}'
        return None
    # positional: every English argument used once with the same type
    etypes = {i + 1: x[2] for i, x in enumerate(e)} if all(x[0] is None for x in e) else {int(x[0]): x[2] for x in e}
    vused = {}
    for i, x in enumerate(v):
        pos = int(x[0]) if x[0] else i + 1
        vused[pos] = x[2]
    if vused != etypes:
        return f'positional specifiers do not match: en {etypes} vi {vused}'
    return None


def letters(s): return re.sub(r'[^A-Za-zÀ-ỹ]', '', s)


def check(key, en, vi, comment=''):
    issues = []
    if not isinstance(vi, str) or not vi.strip():
        return ['empty translation']
    r = spec_ok(en, vi)
    if r: issues.append(r)
    for n in NAMES:
        if n in en and n not in vi:
            issues.append(f'exercise name "{n}" not kept verbatim')
    for p in PROTECTED:
        if re.search(r'\b' + re.escape(p) + r'\b', en) and p not in vi:
            issues.append(f'"{p}" not kept')
    le = letters(en)
    if len(le) >= 3 and le.isupper() and letters(vi) != letters(vi).upper():
        issues.append('English is UPPER CASE, Vietnamese is not')
    words_en = len(en.split())
    if words_en <= 3 and len(en) >= 3:
        ratio = len(vi) / max(1, len(en))
        if len(vi) > len(en) * 1.6 + 4:
            issues.append(f'short label {ratio:.1f}x longer ({len(en)} -> {len(vi)} chars)')
    if re.search(r'\d\.\d', vi) and not re.search(r'\d\.\d', en):
        issues.append('decimal point added')
    if re.search(r'\d\.\d', en) and re.search(r'\d\.\d', vi) and not re.search(r'v\d|iOS|\d\.\d\.\d', en):
        issues.append('decimal point kept: Vietnamese uses a comma (0,5)')
    for bad, good in SPELL.items():
        if bad in vi: issues.append(f'spelling: "{bad}" -> "{good}"')
    if vi.strip() == en.strip() and len(le) >= 4 and not any(p in en for p in PROTECTED) and not any(n == en.strip() for n in NAMES):
        issues.append('same as English')
    stripped = vi
    for n in NAMES: stripped = stripped.replace(n, '')
    for p in PROTECTED: stripped = stripped.replace(p, '')
    m = ENGLISH_LEFT.findall(stripped)
    if m and vi.strip() != en.strip():
        issues.append('English words left: ' + ', '.join(sorted(set(x.lower() for x in m))))
    # A key with arguments writes a literal percent as %%; one without, as %.
    if en.count('%%') != vi.count('%%'):
        issues.append(f'literal percent: "%%" ×{en.count("%%")} in English, ×{vi.count("%%")} in Vietnamese')
    if specs(en) and re.search(r'(?<!%)%(?![%@\d.+#-]|lld|llu|ld|lu|d|u|f|lf|s|e|g)', vi.replace('%%', '')):
        issues.append('a lone "%" in a string with arguments: write "%%"')
    if en.count(' ') != vi.count(' '):
        issues.append(f'no-break spaces: {en.count(chr(0xa0))} in English, {vi.count(chr(0xa0))} in Vietnamese')
    for ch in ['…', '“', '”', '·', '→', '✓']:
        if en.count(ch) != vi.count(ch):
            issues.append(f'"{ch}" count differs')
    if en.rstrip().endswith(('.', '?', '!', ':')) and not vi.rstrip().endswith(('.', '?', '!', ':', '…')):
        issues.append('end punctuation dropped')
    if en != en.strip() and (en[:1].isspace() != vi[:1].isspace() or en[-1:].isspace() != vi[-1:].isspace()):
        issues.append('leading/trailing space differs')
    return issues


def main():
    tr = json.load(open(sys.argv[1], encoding='utf-8'))
    entries = {}
    for b in sys.argv[2:]:
        for e in json.load(open(b, encoding='utf-8')):
            entries[e['key']] = e
    n = 0
    for k, vi in tr.items():
        e = entries.get(k)
        if not e:
            print(json.dumps({'key': k, 'issues': ['not in the batches']}, ensure_ascii=False)); n += 1; continue
        iss = check(k, e['en'], vi, e.get('comment', ''))
        if iss:
            print(json.dumps({'key': k, 'en': e['en'], 'vi': vi, 'issues': iss}, ensure_ascii=False)); n += 1
    missing = [k for k in entries if k not in tr]
    for k in missing:
        print(json.dumps({'key': k, 'issues': ['no translation']}, ensure_ascii=False))
    print(f'{n} with issues, {len(missing)} without translation, {len(tr)} translated', file=sys.stderr)


if __name__ == '__main__':
    main()
