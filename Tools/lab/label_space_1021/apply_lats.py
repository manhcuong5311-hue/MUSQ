# Adds (or re-places) the deadlift set-up's grip-and-lats cue `lats` on the 11 deadlift-set-up lifts in
# SampleData.swift: one callout right after the spine callout, one TechniqueCue right after the spine cue
# (`spine`, or `back` on the Romanian deadlifts). Re-runnable: an existing `lats` callout gets the new
# point/side/joint, the cue text is rewritten.
# Usage: python3 apply_lats.py <SampleData.swift> <placements.json>
#   placements.json: {"Deadlift": {"x": 0.45, "y": 0.07, "side": "trailing", "joint": "CTRL_finger_middle_01_L"}, ...}
import sys, re, json

path, table = sys.argv[1], json.load(open(sys.argv[2]))
src = open(path).read()

LABEL = "Grip & lats tight"
CUE = dict(
    title="Grip & Lats",
    intro="Your grip and your lats tie the bar to your body before it moves.",
    why=("Pulling the shoulders down towards the hips tightens the lats, which hold the bar against the legs "
         "so it travels straight. A bar that drifts forward pulls the hips up and rounds the back."),
    mistake=("Grabbing the bar with loose hands and relaxed shoulders, so the bar swings away from the legs "
             "and the upper back rounds as the weight comes up."),
    correct=("Close all five fingers round the bar, pull the shoulders down to tighten the lats, brace until "
             "the back is flat, and keep the bar against your legs the whole rep."),
)


def call_end(s, i):
    """Index just past the ')' closing the call whose '(' is at s[i]."""
    d = 0
    for j in range(i, len(s)):
        if s[j] == '(':
            d += 1
        elif s[j] == ')':
            d -= 1
            if d == 0:
                return j + 1
    raise ValueError('unbalanced')


def find_call(block, head, key):
    """Start/end of the first `head(` call in block whose text contains key."""
    i = 0
    while True:
        i = block.find(head + '(', i)
        if i < 0:
            return None
        e = call_end(block, i + len(head))
        if key in block[i:e]:
            return i, e
        i = e


def annotation(indent, p):
    cont = indent + ' ' * len('CueAnnotation(')
    side = '' if p['side'] == 'leading' else 'labelSide: .trailing, '
    return (f'CueAnnotation(cueID: "lats", label: "{p.get("label", LABEL)}",\n'
            f'{cont}labelPoint: CGPoint(x: {p["x"]:.3f}, y: {p["y"]:.3f}),\n'
            f'{cont}{side}leaderLength: 40, joint: "{p["joint"]}")')


def technique(indent):
    i2 = indent + '    '
    lines = [f'TechniqueCue(', f'{i2}id: "lats",']
    for k in ('title', 'intro', 'why', 'mistake'):
        lines.append(f'{i2}{k}: "{CUE[k]}",')
    lines.append(f'{i2}correct: "{CUE["correct"]}"')
    lines.append(f'{indent})')
    return '\n'.join(lines)


def insert_after(block, start, end, text, indent):
    """Insert `text` as the next element after the call block[start:end] in its array literal."""
    rest = block[end:]
    m = re.match(r'\s*,', rest)
    if m:
        k = end + m.end()
        return block[:k] + '\n' + indent + text + ',' + block[k:]
    return block[:end] + ',\n' + indent + text + block[end:]


for name, p in table.items():
    var = re.search(r'^\s+"%s":\s+(\w+Content),' % re.escape(name), src, re.M).group(1)
    a = src.index('static let %s = ExerciseContent(' % var)
    b = call_end(src, src.index('(', a))
    block = src[a:b]
    # callout
    old = find_call(block, 'CueAnnotation', 'cueID: "lats"')
    if old:
        s0, e0 = old
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = block[:s0] + annotation(indent, p) + block[e0:]
    else:
        s0, e0 = (find_call(block, 'CueAnnotation', 'cueID: "spine"') or find_call(block, 'CueAnnotation', 'cueID: "back"')
                  or find_call(block, 'backAnnotation', '"spine"'))
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = insert_after(block, s0, e0, annotation(indent, p), indent)
    # technique cue
    old = find_call(block, 'TechniqueCue', 'id: "lats"')
    if old:
        s0, e0 = old
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = block[:s0] + technique(indent) + block[e0:]
    else:
        s0, e0 = find_call(block, 'TechniqueCue', 'id: "spine"') or find_call(block, 'TechniqueCue', 'id: "back"')
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = insert_after(block, s0, e0, technique(indent), indent)
    # an existing pill moved to make room (labelPoint and side only)
    for lab, m in p.get('move', {}).items():
        s0, e0 = find_call(block, 'CueAnnotation', 'label: "%s"' % lab)
        call = block[s0:e0]
        new = re.sub(r'labelPoint: CGPoint\(x: [\d.]+, y: [\d.]+\)', 'labelPoint: CGPoint(x: %.3f, y: %.3f)' % (m['x'], m['y']), call)
        new = re.sub(r'labelSide: \.(leading|trailing),\s*', '', new)
        if m['side'] == 'trailing':
            new = new.replace('leaderLength:', 'labelSide: .trailing, leaderLength:', 1)
        block = block[:s0] + new + block[e0:]
    src = src[:a] + block + src[b:]
    print('%-36s %s (%.3f, %.2f) %s %s' % (name, var, p['x'], p['y'], p['side'], p['joint']))
open(path, 'w').write(src)
