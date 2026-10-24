# Writes move_off.py's moves.json into SampleData.swift: each moved pill gets
# its new labelPoint and side; nothing else changes. Re-runnable.
# Usage: python3 apply_moves.py <SampleData.swift> <moves.json>
import sys, re, json

path, table = sys.argv[1], json.load(open(sys.argv[2]))
src = open(path).read()


def close_paren(s, i):
    """Index of the ')' closing the '(' at s[i], skipping strings and // comments."""
    d, j = 0, i
    while True:
        c = s[j]
        if c == '"':
            j += 1
            while s[j] != '"':
                j += 2 if s[j] == '\\' else 1
        elif s.startswith('//', j):
            j = s.index('\n', j)
            continue
        elif c == '(':
            d += 1
        elif c == ')':
            d -= 1
            if d == 0:
                return j
        j += 1


for name, moves in table.items():
    var = re.search(r'^\s+"%s":\s+(\w+Content),' % re.escape(name), src, re.M).group(1)
    a = src.index('static let %s = ExerciseContent(' % var)
    b = close_paren(src, src.index('(', a))
    block = src[a:b]
    for label, m in moves.items():
        s0 = block.rfind('CueAnnotation(', 0, block.index('label: "%s"' % label))
        e0 = close_paren(block, block.index('(', s0)) + 1
        call = block[s0:e0]
        assert 'label: "%s"' % label in call, (name, label)
        # plain fractions, or the bench presses' "218.0 / 382.0" points
        new, n = re.subn(r'labelPoint: CGPoint\(x: [\d.]+(?: / [\d.]+)?, y: [\d.]+(?: / [\d.]+)?\)',
                         'labelPoint: CGPoint(x: %.3f, y: %.3f)' % (m['x'], m['y']), call)
        assert n == 1, (name, label, 'labelPoint')
        new = re.sub(r'labelSide: \.(leading|trailing),\s*', '', new)
        if m['side'] == 'trailing':
            new = new.replace('leaderLength:', 'labelSide: .trailing, leaderLength:', 1)
            assert 'labelSide: .trailing' in new, (name, label, 'side')
        block = block[:s0] + new + block[e0:]
        print('%-34s %-34s (%.3f, %.3f) %s' % (name, label, m['x'], m['y'], m['side']))
    src = src[:a] + block + src[b:]
open(path, 'w').write(src)
