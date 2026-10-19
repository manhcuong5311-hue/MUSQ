# Adds (or re-places) the back-bar grip and shoulder-blade cue `shelf` on the 13 back-bar lifts in
# SampleData.swift: one callout right after the bar callout, one TechniqueCue right after the bar cue.
# Re-runnable: an existing `shelf` callout gets the new point/side/joint, the cue text is rewritten.
# Usage: python3 apply_shelf.py <SampleData.swift> <placements.json>
#   placements.json: {"Back Squat": {"x": 0.45, "y": 0.07, "side": "trailing", "joint": "hand_L"}, ...}
import sys, re, json

path, table = sys.argv[1], json.load(open(sys.argv[2]))
src = open(path).read()

LABEL = "Grip tight, elbows down"
CUE = dict(
    title="Grip & Shoulder Blades",
    intro="Your hands, elbows and shoulder blades build the shelf the bar sits on.",
    why=("Squeezing the shoulder blades together bunches the upper traps into a firm, muscular shelf for "
         "the bar, and elbows held down and slightly back keep the upper back tight. Elbows that rise let "
         "it round and tip the trunk forward."),
    mistake=("Holding the bar loosely with the wrists bent back and the elbows drifting up or forward, so the "
             "shoulder blades relax and the bar rests on a soft upper back."),
    correct=("Wrap your thumbs around the bar, keep the wrists in line with the forearms, squeeze the shoulder "
             "blades together and pull the elbows down and back before the first rep."),
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
    return (f'CueAnnotation(cueID: "shelf", label: "{p.get("label", LABEL)}",\n'
            f'{cont}labelPoint: CGPoint(x: {p["x"]:.3f}, y: {p["y"]:.2f}),\n'
            f'{cont}{side}leaderLength: 40, joint: "{p["joint"]}")')


def technique(indent):
    i2 = indent + '    '
    lines = [f'TechniqueCue(', f'{i2}id: "shelf",']
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
    old = find_call(block, 'CueAnnotation', 'cueID: "shelf"')
    if old:
        s0, e0 = old
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = block[:s0] + annotation(indent, p) + block[e0:]
    else:
        s0, e0 = find_call(block, 'CueAnnotation', 'cueID: "bar"')
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = insert_after(block, s0, e0, annotation(indent, p), indent)
    # technique cue
    old = find_call(block, 'TechniqueCue', 'id: "shelf"')
    if old:
        s0, e0 = old
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = block[:s0] + technique(indent) + block[e0:]
    else:
        s0, e0 = find_call(block, 'TechniqueCue', 'id: "bar"')
        line0 = block.rfind('\n', 0, s0) + 1
        indent = block[line0:s0]
        block = insert_after(block, s0, e0, technique(indent), indent)
    # an existing pill moved to make room (labelPoint and side only)
    for lab, m in p.get('move', {}).items():
        s0, e0 = find_call(block, 'CueAnnotation', 'label: "%s"' % lab)
        call = block[s0:e0]
        new = re.sub(r'labelPoint: CGPoint\(x: [\d.]+, y: [\d.]+\)', 'labelPoint: CGPoint(x: %.3f, y: %.2f)' % (m['x'], m['y']), call)
        new = re.sub(r'labelSide: \.(leading|trailing),\s*', '', new)
        if m['side'] == 'trailing':
            new = new.replace('leaderLength:', 'labelSide: .trailing, leaderLength:', 1)
        block = block[:s0] + new + block[e0:]
    src = src[:a] + block + src[b:]
    print('%-36s %s (%.3f, %.2f) %s %s' % (name, var, p['x'], p['y'], p['side'], p['joint']))
open(path, 'w').write(src)
