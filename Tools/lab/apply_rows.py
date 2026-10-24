# Writes a rows-follow-paint workflow's results into SampleData.swift
# (2026-10-22): replaces each content's `activation: [...]` (and `stabilisers`
# when given) and gives each listed stance its note and own list.
#   python3 apply_rows.py <SampleData.swift> <results.json>
# results.json: [{"exercise", "contentVar", "changed", "activationSwift"
# ("activation: [ ... ]"), "stabilisers" (list or null), "stances": [{"label",
# "note", "activationSwift" ("[ ... ]")}]}]
import sys, json, re

path, results = sys.argv[1], json.load(open(sys.argv[2]))
src = open(path).read()


def match_close(s, i):
    """Index of the bracket closing the one at s[i], skipping strings and // comments."""
    open_ch = s[i]
    close_ch = {'[': ']', '(': ')'}[open_ch]
    depth, j, n = 0, i, len(s)
    while j < n:
        c = s[j]
        if c == '"':
            j += 1
            while s[j] != '"':
                j += 2 if s[j] == '\\' else 1
        elif s.startswith('//', j):
            j = s.index('\n', j)
            continue
        elif c == open_ch:
            depth += 1
        elif c == close_ch:
            depth -= 1
            if depth == 0:
                return j
        j += 1
    raise ValueError('unbalanced')


def content_span(var):
    a = src.index('static let %s = ExerciseContent(' % var)
    return a, match_close(src, src.index('(', a))


log = []
for r in results:
    if not r.get('changed') and not r.get('stances'):
        continue
    if r.get('changed'):
        var = r['contentVar']
        a, b = content_span(var)
        block = src[a:b]
        k = block.index('activation: [')
        e = match_close(block, k + len('activation: '))
        new = r['activationSwift'].strip()
        assert new.startswith('activation: [') and new.endswith(']'), var
        # the file's content-level indent: rows and comments at 12, the bracket at 8
        lines = new.splitlines()
        new = '\n'.join(['activation: ['] + [' ' * 12 + l.strip() for l in lines[1:-1] if l.strip()] + [' ' * 8 + ']'])
        block = block[:k] + new + block[e + 1:]
        if r.get('stabilisers') is not None:
            m = re.search(r'stabilisers: \[[^\]]*\]', block)
            body = ', '.join('"%s"' % s for s in r['stabilisers'])
            if m:
                block = block[:m.start()] + 'stabilisers: [%s]' % body + block[m.end():]
            else:
                log.append('%s: no stabilisers line to replace' % var)
        src = src[:a] + block + src[b:]
        log.append('rows  %s' % r['exercise'])
    for st in r.get('stances') or []:
        name = r['exercise']
        s0 = src.index('"%s": [\n            ExerciseStance(' % name, src.index('stancesByExercise'))
        s1 = match_close(src, src.index('[', s0))
        sblock = src[s0:s1]
        m = re.search(r'ExerciseStance\(label: "%s", model: ' % re.escape(st['label']), sblock)
        i = m.start()
        mo = sblock.index('model: ', i) + len('model: ')
        me = match_close(sblock, sblock.index('(', mo))
        end = match_close(sblock, sblock.index('(', i))
        ind = ' ' * 27
        acts = st['activationSwift'].strip()
        assert acts.startswith('[') and acts.endswith(']'), (name, st['label'])
        rows = '\n'.join(' ' * 16 + line.strip() for line in acts[1:-1].splitlines() if line.strip())
        new_tail = ',\n%snote: "%s",\n%sactivation: [\n%s\n%s])' % (ind, st['note'].replace('"', '\\"'), ind, rows, ind)
        sblock = sblock[:me + 1] + new_tail + sblock[end + 1:]
        src = src[:s0] + sblock + src[s1:]
        log.append('stance %s / %s' % (name, st['label']))
open(path, 'w').write(src)
print('\n'.join(log))
print(len(log), 'edits')
