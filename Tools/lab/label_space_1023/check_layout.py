# Checks a whole callout layout of one lift over the dense samples (every
# 0.25 s): any pill on the face or a fist, pills overlapping, a dot under a
# pill, a leader running under a pill or crossing another leader, and how much
# of each pill sits on the lifter or the equipment (2026-10-23).
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


def seg_cross(a, b, c, d):
    def o(p, q, r):
        return (q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0])
    return o(a, b, c) * o(a, b, d) < 0 and o(c, d, a) * o(c, d, b) < 0


slug = re.sub('[^a-z0-9]+', '-', NAME.lower())
occ = raw(os.path.join(LAB, 'occ', slug + '.occ.raw'))
ui = raw(os.path.join(LAB, 'occ', slug + '.ui.raw'))
times = P['times']
pills = []
for a in anns[NAME]['anns']:
    m = MOVES.get(a['label'])
    x, y, side = (m['x'], m['y'], m['side']) if m else (a['x'], a['y'], a['side'])
    w = Wd['widths'][a['label']]
    pills.append(dict(label=a['label'], rect=pill_rect(x * VW, y * VH, side, w), anchor=(x * VW, y * VH),
                      dots=[(u * VW, v * VH) for u, v in J[NAME].get(a['joint'], [])]))
issues = []
face = [(times[k], (u * VW, v * VH)) for k, (u, v) in enumerate(J[NAME].get('head', []))]
fists = [(times[k], (u * VW, v * VH)) for j in ('hand_L', 'hand_R', 'CTRL_finger_middle_01_L', 'CTRL_finger_middle_01_R')
         for k, (u, v) in enumerate(J[NAME].get(j, []))]


def near_rect(pt, r, rad):
    cx = min(max(pt[0], r[0]), r[2]); cy = min(max(pt[1], r[1]), r[3])
    return (cx - pt[0]) ** 2 + (cy - pt[1]) ** 2 < rad * rad


for p in pills:
    r = p['rect']
    x0, y0, x1, y1 = [int(round(v)) for v in r]
    if r[2] > 322 and r[1] < 118:
        issues.append('%s: under the buttons' % p['label'])
    nf = [t for t, pt in face if near_rect(pt, r, FACE_R * 0.75)]
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
        r = p['rect']
        for k, d in enumerate(p['dots']):
            if r[0] + 2 <= d[0] <= r[2] - 2 and r[1] + 2 <= d[1] <= r[3] - 2:
                issues.append('%s: its own dot under it at %.2f s' % (p['label'], times[k]))
                break
uniq = sorted(set(re.sub(r' at [\d.]+ s$', '', i) for i in issues))
for i in uniq:
    n = sum(1 for j in issues if j.startswith(i))
    print('  ' + i + ('  (x%d)' % n if n > 1 else ''))
print('%s: %s; pills on the lifter: %s' % (NAME, 'clean' if not uniq else '%d problems' % len(uniq),
                                         ', '.join('%s %.2f' % (p['label'], p['occ']) for p in pills)))
sys.exit(0 if not uniq else 1)
