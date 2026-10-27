import re, json, sys
src = open(sys.argv[1]).read()
names = [l.strip() for l in open(__import__("os").environ.get("LIFTS") or __import__("os").path.join(__import__("os").path.dirname(__import__("os").path.abspath(__file__)), "lifts.txt")) if l.strip()]
def calls(blk, head):
    i = 0
    while True:
        i = blk.find(head + '(', i)
        if i < 0: return
        j = i + len(head) + 1; d = 1
        while d:
            d += {'(': 1, ')': -1}.get(blk[j], 0); j += 1
        yield blk[i + len(head) + 1: j - 1]; i = j
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


out = {}
for n in names:
    var = re.search(r'^\s+"%s":\s+(\w+Content),' % re.escape(n), src, re.M).group(1)
    a = src.index("static let %s = ExerciseContent(" % var); b = close_paren(src, src.index("(", a))
    rows = []
    for s in calls(src[a:b], 'backAnnotation'):
        q = re.findall(r'"([^"]*)"', s)
        if len(q) < 3: continue          # the helper's own definition, not a call
        cue, label, joint = q[:3]
        # the older back lifts write their slots over 655, not 567 (2026-10-27)
        sl = re.search(r'slot: (?:(\w+)|\(x: ([\d.]+) / ([\d.]+), y: ([\d.]+) / ([\d.]+)\))', s)
        if sl[1]:
            m = re.search(r'static let %s = \(x: ([\d.]+) / 382\.0, y: ([\d.]+) / 567\.0\)' % sl[1], src)
            x, y = float(m[1]) / 382, float(m[2]) / 567
        else:
            x, y = float(sl[2]) / float(sl[3]), float(sl[4]) / float(sl[5])
        side = (re.search(r'side: \.(\w+)', s) or [None, 'leading'])[1]
        rows.append(dict(cue=cue, label=label, x=x, y=y, side=side, joint=joint))
    for s in calls(src[a:b], 'CueAnnotation'):
        g = lambda pat: (re.search(pat, s) or [None, None])[1]
        # plain fractions, or the bench presses' "218.0 / 382.0" points
        pt = re.search(r'labelPoint: CGPoint\(x: ([\d.]+)(?: / ([\d.]+))?, y: ([\d.]+)(?: / ([\d.]+))?\)', s)
        x, y = float(pt[1]) / float(pt[2] or 1), float(pt[3]) / float(pt[4] or 1)
        rows.append(dict(cue=g(r'cueID: "(\w+)"'), label=g(r'label: "([^"]*)"'), x=x, y=y, side=g(r'labelSide: \.(\w+)') or 'leading', joint=g(r'joint: "(\w+)"')))
    out[n] = dict(var=var, anns=rows)
json.dump(out, open(sys.argv[2], 'w'), indent=1)
print(len(out), 'lifts;', sum(len(e['anns']) for e in out.values()), 'callouts')
