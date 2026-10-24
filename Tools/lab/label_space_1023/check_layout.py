# Checks a whole callout layout of one lift over the dense samples (every
# 0.25 s): any pill on the face or a fist, pills overlapping, a dot under a
# pill, a leader running under a pill or crossing another leader, and how much
# of each pill sits on the lifter or the equipment (2026-10-23). Since
# 2026-10-24 also a leader running through another pill's dot (it then reads
# as pointing there) or across the face (unless its own dot is on the head
# or neck). The face is now the whole head (a disc ahead of the head joint),
# and a pill counts as on it when it covers a tenth of that disc. Lifts with a
# stance picker have a shorter card (382 x 581: the picker and its note sit
# above it), the scene scaled to it; pills are clamped into the 8 pt margins
# as the app's TrackedCallout does.
# Blender's python (numpy).
#   python3.13 check_layout.py <lab> "<Lift>" [moves.json]
# moves.json: {"Lift": {"<label>": {"x":..,"y":..,"side":..}}} applied over
# anns.json before checking. Prints one line per problem and a summary;
# exit status 0 when clean.
import sys, os, json, re
import numpy as np

LAB, NAME = sys.argv[1], sys.argv[2]
MOVES = json.load(open(sys.argv[3])).get(NAME, {}) if len(sys.argv) > 3 else {}
VW, VH = 382, 655
anns = json.load(open(os.path.join(LAB, 'anns.json')))
J = json.load(open(os.path.join(LAB, 'joints.json')))
P = json.load(open(os.path.join(LAB, 'proj_at.json')))[NAME]
Wd = json.load(open(os.path.join(LAB, 'widths.json')))
PH = Wd['height']
FACE_R, HAND_R = 24.0, 15.0
_sd = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..', 'GymWorkout', 'Models', 'SampleData.swift')).read()
_st = _sd[_sd.index('stancesByExercise'):]
STANCE = NAME in set(re.findall(r'^        "([^"]+)": \[\n            ExerciseStance\(', _st, re.M))
CH = 581.0 if STANCE else float(VH)
KS = CH / VH                   # the scene's scale in the card
CX = 22.6 if STANCE else 0.0   # and its left inset (fitted on the Incline Cable Press shots)
# A two-line subtitle shortens the card (LAB/cards.json from cards.py): the
# pills sit at fractions of the shorter card and the scene keeps its vertical
# fractions, narrowing about the centre by the same ratio.
_cards = os.path.join(LAB, 'cards.json')
CARD = json.load(open(_cards)).get(NAME) if os.path.exists(_cards) else None
if CARD:
    CH = CARD['h']


def scene(u, v):
    if CARD:
        return ((0.5 + (u - 0.5) * CH / VH) * VW, v * CH)
    return (KS * u * VW + CX, KS * v * VH)


def clamp(ax, ay, side, w):
    m = 8
    lo = m + w if side == 'leading' else m
    hi = VW - m if side == 'leading' else VW - m - w
    return (min(max(ax, lo), hi), min(max(ay, m + PH / 2), CH - m - PH / 2))


def raw(p):
    return np.frombuffer(open(p, 'rb').read(), dtype=np.uint8).reshape(VH, VW) > 0


def pill_rect(ax, ay, side, w):
    return (ax - w, ay - PH / 2, ax, ay + PH / 2) if side == 'leading' else (ax, ay - PH / 2, ax + w, ay + PH / 2)


def seg_hits_rect(p, q, r, pad=0.0):
    x0, y0, x1, y1 = r[0] - pad, r[1] - pad, r[2] + pad, r[3] + pad
    dx, dy = q[0] - p[0], q[1] - p[1]
    t0, t1 = 0.0, 1.0
    for pk, qk in ((-dx, p[0] - x0), (dx, x1 - p[0]), (-dy, p[1] - y0), (dy, y1 - p[1])):
        if pk == 0:
            if qk < 0:
                return False
        else:
            t = qk / pk
            if pk < 0:
                t0 = max(t0, t)
            else:
                t1 = min(t1, t)
            if t0 > t1:
                return False
    return True


def seg_dist(p, q, c):
    """Distance from point c to the segment p-q."""
    dx, dy = q[0] - p[0], q[1] - p[1]
    L = dx * dx + dy * dy
    t = 0.0 if L == 0 else max(0.0, min(1.0, ((c[0] - p[0]) * dx + (c[1] - p[1]) * dy) / L))
    return ((p[0] + t * dx - c[0]) ** 2 + (p[1] + t * dy - c[1]) ** 2) ** 0.5


def seg_cross(a, b, c, d):
    def o(p, q, r):
        return (q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0])
    return o(a, b, c) * o(a, b, d) < 0 and o(c, d, a) * o(c, d, b) < 0


slug = re.sub('[^a-z0-9]+', '-', NAME.lower())
# masks are optional: without them the face/fist, overlap and leader checks still run
op = os.path.join(LAB, 'occ', slug + '.occ.raw')
occ = raw(op) if os.path.exists(op) else np.zeros((VH, VW), bool)
times = P['times']
pills = []
for a in anns[NAME]['anns']:
    m = MOVES.get(a['label'])
    x, y, side = (m['x'], m['y'], m['side']) if m else (a['x'], a['y'], a['side'])
    w = Wd['widths'][a['label']]
    ax, ay = clamp(x * VW, y * CH, side, w)
    pills.append(dict(label=a['label'], joint=a['joint'], rect=pill_rect(ax, ay, side, w), anchor=(ax, ay),
                      dots=[scene(u, v) for u, v in J[NAME].get(a['joint'], [])]))
issues = []
# The head joint sits at the base of the skull, 20-40 pt behind the face:
# the head is a disc carried 0.75 of the neck-to-head bone past the joint,
# its radius 1.05 of that bone on screen (fitted on the Snatch-Grip
# Deadlift's silhouettes, 2026-10-24). FACE_R stays the floor.
face = []
for k, ((u, v), (nu, nv)) in enumerate(zip(J[NAME].get('head', []), J[NAME].get('neck', []))):
    (hx, hy), (nx, ny) = scene(u, v), scene(nu, nv)
    L = ((hx - nx) ** 2 + (hy - ny) ** 2) ** 0.5
    face.append((times[k], (hx + 0.75 * (hx - nx), hy + 0.75 * (hy - ny)), max(1.05 * L, FACE_R * 0.75)))
fists = [(times[k], scene(u, v)) for j in ('hand_L', 'hand_R', 'CTRL_finger_middle_01_L', 'CTRL_finger_middle_01_R')
         for k, (u, v) in enumerate(J[NAME].get(j, []))]


_gx, _gy = np.meshgrid(np.linspace(-1, 1, 21), np.linspace(-1, 1, 21))
_disc = _gx ** 2 + _gy ** 2 <= 1


def covers(r, c, rad):
    """Share of the disc (centre c, radius rad) under the rect."""
    xs, ys = c[0] + _gx * rad, c[1] + _gy * rad
    inside = (xs >= r[0]) & (xs <= r[2]) & (ys >= r[1]) & (ys <= r[3]) & _disc
    return inside.sum() / _disc.sum()


def near_rect(pt, r, rad):
    cx = min(max(pt[0], r[0]), r[2]); cy = min(max(pt[1], r[1]), r[3])
    return (cx - pt[0]) ** 2 + (cy - pt[1]) ** 2 < rad * rad


for p in pills:
    r = p['rect']
    x0, y0, x1, y1 = [int(round(v)) for v in r]
    # The muscles and key-tips buttons: two 32 pt squares 8 pt apart, 12 pt in
    # from the top right (x 338-370, y 12-84), with 4 pt to spare (2026-10-24;
    # the old box, x > 322 and y < 118, flagged pills clear below them).
    if r[2] > 334 and r[1] < 88:
        issues.append('%s: under the buttons' % p['label'])
    nf = [t for t, pt, rad in face if covers(r, pt, rad) >= 0.1]
    nh = [t for t, pt in fists if near_rect(pt, r, HAND_R * 0.6)]
    if nf:
        issues.append('%s: on the face at %s s' % (p['label'], sorted(set(nf))[:6]))
    if nh:
        issues.append('%s: on a fist at %s s' % (p['label'], sorted(set(nh))[:6]))
    oc = occ[max(y0, 0):y1, max(x0, 0):x1].mean() if x1 > x0 and y1 > y0 else 0
    p['occ'] = round(float(oc), 2)
for i, p in enumerate(pills):
    for q in pills[i + 1:]:
        a, b = p['rect'], q['rect']
        if not (a[2] + 4 < b[0] or b[2] + 4 < a[0] or a[3] + 4 < b[1] or b[3] + 4 < a[1]):
            issues.append('%s overlaps %s' % (p['label'], q['label']))
for p in pills:
    for q in pills:
        if p is q:
            continue
        for k, d in enumerate(p['dots']):
            r = q['rect']
            if r[0] <= d[0] <= r[2] and r[1] <= d[1] <= r[3]:
                issues.append('%s: dot under %s at %.2f s' % (p['label'], q['label'], times[k]))
            if seg_hits_rect(p['anchor'], d, r, 1):
                issues.append('%s: leader under %s at %.2f s' % (p['label'], q['label'], times[k]))
            if k < len(q['dots']) and seg_cross(p['anchor'], d, q['anchor'], q['dots'][k]):
                issues.append('%s: leader crosses %s at %.2f s' % (p['label'], q['label'], times[k]))
            if k < len(q['dots']) and seg_dist(p['anchor'], d, q['dots'][k]) < 6 and \
                    ((d[0] - q['dots'][k][0]) ** 2 + (d[1] - q['dots'][k][1]) ** 2) ** 0.5 > 6:
                issues.append('%s: leader through the %s dot at %.2f s' % (p['label'], q['label'], times[k]))
        r = p['rect']
        for k, d in enumerate(p['dots']):
            if r[0] + 2 <= d[0] <= r[2] - 2 and r[1] + 2 <= d[1] <= r[3] - 2:
                issues.append('%s: its own dot under it at %.2f s' % (p['label'], times[k]))
                break
    if p['joint'] not in ('head', 'neck'):
        for k, d in enumerate(p['dots']):
            if k < len(face) and seg_dist(p['anchor'], d, face[k][1]) < face[k][2] * 0.7:
                issues.append('%s: leader across the face at %.2f s' % (p['label'], times[k]))
uniq = sorted(set(re.sub(r' at [\d.]+ s$', '', i) for i in issues))
for i in uniq:
    n = sum(1 for j in issues if j.startswith(i))
    print('  ' + i + ('  (x%d)' % n if n > 1 else ''))
print('%s: %s; pills on the lifter: %s' % (NAME, 'clean' if not uniq else '%d problems' % len(uniq),
                                         ', '.join('%s %.2f' % (p['label'], p['occ']) for p in pills)))
sys.exit(0 if not uniq else 1)
