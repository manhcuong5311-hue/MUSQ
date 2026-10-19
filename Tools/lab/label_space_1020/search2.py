# Re-place ONE existing pill of a lift, with every other pill (old ones plus the planned new one) fixed.
# Blender's python. Usage: python3.13 search2.py <lab> <placements.json> "<lift>" "<label to move>"
import sys, os, json, math, re
import numpy as np

LAB, PLF, NAME, MOVE = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
src = open(os.path.join(LAB, 'search.py')).read()
pre = src.split('res = {}')[0]
sys.argv = [sys.argv[0], LAB, 'Grip tight, elbows down']
exec(pre)
PL = json.load(open(PLF))[NAME]
P = json.load(open(os.path.join(LAB, 'proj_at.json')))[NAME]


def dots_of(joint):
    # the 8 probe samples plus the dense 0.25 s samples
    a = [(u * VW, v * VH) for u, v in J[NAME].get(joint, [])]
    b = [(u * VW, v * VH) for u, v in P['joints'].get(joint, [])]
    return a, b


s = slug(NAME)
occ = raw(os.path.join(LAB, 'occ', s + '.occ.raw'))
ui = raw(os.path.join(LAB, 'occ', s + '.ui.raw'))
Socc = integral(occ)
fixed = []
target = None
for a in anns[NAME]['anns']:
    m = PL.get('move', {}).get(a['label'])
    x, y, side = (m['x'], m['y'], m['side']) if m else (a['x'], a['y'], a['side'])
    w = Wd['widths'][a['label']]
    d8, dd = dots_of(a['joint'])
    item = dict(rect=pill_rect(x * VW, y * VH, side, w), anchor=(x * VW, y * VH), dots=d8, dense=dd, label=a['label'], joint=a['joint'], w=w)
    if a['label'] == MOVE:
        target = item
    else:
        fixed.append(item)
w = Wd['widths'][PL['label']]
d8, dd = dots_of(PL['joint'])
fixed.append(dict(rect=pill_rect(PL['x'] * VW, PL['y'] * VH, PL['side'], w), anchor=(PL['x'] * VW, PL['y'] * VH), dots=d8, dense=dd, label=PL['label'], joint=PL['joint'], w=w))

forb = np.zeros((VH, VW), bool)
for o in fixed:
    r = o['rect']
    x0, y0, x1, y1 = [int(round(v)) for v in (r[0] - 6, r[1] - 6, r[2] + 6, r[3] + 6)]
    forb[max(y0, 0):min(y1, VH), max(x0, 0):min(x1, VW)] = True
    for (dx, dy) in (o['dots'] if os.environ.get('SPARSE') else o['dense']):
        forb[max(int(dy) - 8, 0):min(int(dy) + 8, VH), max(int(dx) - 8, 0):min(int(dx) + 8, VW)] = True
forb[0:118, 322:VW] = True
leg = ui[560:, :]
rows = np.nonzero(leg[:, 8:24].any(1))[0]
if len(rows):
    cols = np.nonzero(leg[rows.min():rows.max() + 1, :].any(0))[0]
    forb[560 + rows.min() - 6:VH, 0:min(VW, cols.max() + 8)] = True
Sforb = integral(forb)
PWm = target['w']
old = target['anchor']
d8, dd = target['dots'], target['dense']
out = []
for side in ('leading', 'trailing'):
    ax = np.arange(M + (PWm if side == 'leading' else 0), VW - M - (0 if side == 'leading' else PWm) + 0.1, 3.0)
    ay = np.arange(M + PH / 2, VH - M - PH / 2 + 0.1, 3.0)
    AX, AY = np.meshgrid(ax, ay)
    X0 = AX - PWm if side == 'leading' else AX
    X1 = AX if side == 'leading' else AX + PWm
    Y0, Y1 = AY - PH / 2, AY + PH / 2
    ok = (rect_sum(Sforb, X0, Y0, X1, Y1) == 0) & (rect_sum(Socc, X0, Y0, X1, Y1) / (PWm * PH) <= 0.06)
    for i, j in zip(*np.nonzero(ok)):
        anchor = (AX[i, j], AY[i, j]); rect = (X0[i, j], Y0[i, j], X1[i, j], Y1[i, j])
        if any(seg_hits_rect(o['anchor'], d, rect, 3) for o in fixed for d in (o['dots'] if os.environ.get('SPARSE') else o['dense'])):
            continue
        bad = 0
        DD = d8 if os.environ.get('SPARSE') else dd
        for k, d in enumerate(DD):
            for o in fixed:
                r = o['rect']
                if r[0] - 2 <= d[0] <= r[2] + 2 and r[1] - 2 <= d[1] <= r[3] + 2: bad += 1
                if seg_hits_rect(anchor, d, r, 2): bad += 1
                OD = o['dots'] if os.environ.get('SPARSE') else o['dense']
                od = OD[k] if k < len(OD) else None
                if od and seg_cross(anchor, d, o['anchor'], od): bad += 1
            if rect[0] - 2 <= d[0] <= rect[2] + 2 and rect[1] - 2 <= d[1] <= rect[3] + 2: bad += 1
        if bad > int(os.environ.get('BAD_MAX', '0')):
            continue
        L = np.mean([math.hypot(d[0] - anchor[0], d[1] - anchor[1]) for d in dd])
        mx = np.mean([d[0] for d in dd])
        wrong = (side == 'leading' and mx < anchor[0] - 4) or (side == 'trailing' and mx > anchor[0] + 4)
        move = math.hypot(anchor[0] - old[0], anchor[1] - old[1])
        cost = 0.5 * L + 0.5 * move + (60 if wrong else 0) + (40 if side != ('leading' if old[0] < VW / 2 and False else side) else 0)
        out.append((round(cost + 40 * bad, 1), round(anchor[0] / VW, 3), round(anchor[1] / VH, 3), side, round(L), round(move), bad))
out.sort()
pick = []
for b in out:
    if all(abs(b[1] - p[1]) > 0.05 or abs(b[2] - p[2]) > 0.04 or b[3] != p[3] for p in pick):
        pick.append(b)
    if len(pick) == 6:
        break
print(NAME, '| move', MOVE, '| joint', target['joint'], '| was', round(old[0] / VW, 3), round(old[1] / VH, 3))
for p in pick:
    print('   cost %5.1f  point (%.3f, %.3f) %-8s leader %3d pt  moved %3d pt  bad %d' % p)
