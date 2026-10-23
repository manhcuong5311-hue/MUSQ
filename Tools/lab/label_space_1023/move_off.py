# Finds the pills that cover the lifter's face or hands at any moment of the
# rep, and re-places each one, every other pill fixed, at the nearest spot that
# keeps off the face, the hands, the lifter and the equipment, the other pills,
# their leaders and dots, the buttons and the legend (2026-10-23).
# Blender's python (numpy). Usage: python3.13 move_off.py <lab> [lift ...]
# Reads anns.json, joints.json (dense, every 0.25 s), widths.json and the
# occ/<slug>.occ.raw / .ui.raw masks; writes moves.json
#   {"Lift": {"Old label": {"x":.., "y":.., "side":..}}} plus a report.
import sys, os, json, math, re
import numpy as np

LAB = sys.argv[1]
ONLY = set(sys.argv[2:])
VW, VH = 382, 655
M = 8.0                                   # TrackedCallout.edgeMargin
anns = json.load(open(os.path.join(LAB, 'anns.json')))
J = json.load(open(os.path.join(LAB, 'joints.json')))
Wd = json.load(open(os.path.join(LAB, 'widths.json')))
PH = Wd['height']
FACE_R, HAND_R = 24.0, 15.0               # pt around the head joint / the fist
OCC_MAX = float(os.environ.get('OCC_MAX', '0.3'))    # share of the pill allowed over the lifter elsewhere
COVER_MIN = int(os.environ.get('COVER_MIN', '30'))   # pt² of face/fist under a pill that counts as covering


def slug(n):
    return re.sub('[^a-z0-9]+', '-', n.lower())


def raw(p):
    return np.frombuffer(open(p, 'rb').read(), dtype=np.uint8).reshape(VH, VW) > 0


def integral(m):
    s = np.zeros((VH + 1, VW + 1), dtype=np.int32)
    s[1:, 1:] = m.astype(np.int32).cumsum(0).cumsum(1)
    return s


def rect_sum(S, x0, y0, x1, y1):
    x0 = np.clip(np.floor(x0).astype(int), 0, VW); x1 = np.clip(np.ceil(x1).astype(int), 0, VW)
    y0 = np.clip(np.floor(y0).astype(int), 0, VH); y1 = np.clip(np.ceil(y1).astype(int), 0, VH)
    return S[y1, x1] - S[y0, x1] - S[y1, x0] + S[y0, x0]


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


def protected(name):
    """Disks around the head and the fists at every sample of the rep."""
    m = np.zeros((VH, VW), bool)
    yy, xx = np.mgrid[0:VH, 0:VW]
    js = J[name]
    spots = [(j, FACE_R) for j in ('head',)] + [(j, HAND_R) for j in ('hand_L', 'hand_R', 'CTRL_finger_middle_01_L', 'CTRL_finger_middle_01_R')]
    for j, r in spots:
        for u, v in js.get(j, []):
            cx, cy = u * VW, v * VH
            x0, x1 = int(max(cx - r, 0)), int(min(cx + r + 1, VW))
            y0, y1 = int(max(cy - r, 0)), int(min(cy + r + 1, VH))
            if x0 >= x1 or y0 >= y1:
                continue
            sub = (xx[y0:y1, x0:x1] - cx) ** 2 + (yy[y0:y1, x0:x1] - cy) ** 2 <= r * r
            m[y0:y1, x0:x1] |= sub
    return m


def chrome(ui):
    """The buttons (top right) and the legend (bottom left)."""
    f = np.zeros((VH, VW), bool)
    f[0:118, 322:VW] = True
    leg = ui[560:, :]
    rows = np.nonzero(leg[:, 8:24].any(1))[0]
    if len(rows):
        cols = np.nonzero(leg[rows.min():rows.max() + 1, :].any(0))[0]
        f[560 + rows.min() - 6:VH, 0:min(VW, cols.max() + 8)] = True
    return f


def items(name, place):
    out = []
    for a in anns[name]['anns']:
        x, y, side = place.get(a['label'], (a['x'], a['y'], a['side']))
        w = Wd['widths'][a['label']]
        out.append(dict(label=a['label'], joint=a['joint'], w=w, side=side, anchor=(x * VW, y * VH),
                        rect=pill_rect(x * VW, y * VH, side, w),
                        dots=[(u * VW, v * VH) for u, v in J[name].get(a['joint'], [])]))
    return out


def covers(rect, prot):
    x0, y0, x1, y1 = [int(round(v)) for v in rect]
    return prot[max(y0, 0):max(min(y1, VH), 0), max(x0, 0):max(min(x1, VW), 0)].sum()


moves, report = {}, {}
for name in anns:
    if ONLY and name not in ONLY:
        continue
    s = slug(name)
    occ = raw(os.path.join(LAB, 'occ', s + '.occ.raw'))
    ui = raw(os.path.join(LAB, 'occ', s + '.ui.raw'))
    prot = protected(name)
    Socc, Sprot = integral(occ), integral(prot)
    place = {}
    flagged = [it for it in items(name, place) if covers(it['rect'], prot) > COVER_MIN]
    report[name] = {'covering': [it['label'] for it in flagged], 'moved': {}, 'stuck': []}
    for target in flagged:
        others = [it for it in items(name, place) if it['label'] != target['label']]
        forb = chrome(ui).copy()
        for o in others:
            r = o['rect']
            x0, y0, x1, y1 = [int(round(v)) for v in (r[0] - 6, r[1] - 6, r[2] + 6, r[3] + 6)]
            forb[max(y0, 0):min(y1, VH), max(x0, 0):min(x1, VW)] = True
            for dx, dy in o['dots']:
                forb[max(int(dy) - 8, 0):min(int(dy) + 8, VH), max(int(dx) - 8, 0):min(int(dx) + 8, VW)] = True
        Sforb = integral(forb)
        w, old = target['w'], target['anchor']
        best = None
        for side in ('leading', 'trailing'):
            ax = np.arange(M + (w if side == 'leading' else 0), VW - M - (0 if side == 'leading' else w) + 0.1, 3.0)
            ay = np.arange(M + PH / 2, VH - M - PH / 2 + 0.1, 3.0)
            AX, AY = np.meshgrid(ax, ay)
            X0 = AX - w if side == 'leading' else AX
            X1 = AX if side == 'leading' else AX + w
            Y0, Y1 = AY - PH / 2, AY + PH / 2
            ok = (rect_sum(Sforb, X0, Y0, X1, Y1) == 0) & (rect_sum(Sprot, X0, Y0, X1, Y1) == 0) \
                & (rect_sum(Socc, X0, Y0, X1, Y1) / (w * PH) <= OCC_MAX)
            for i, j in zip(*np.nonzero(ok)):
                anchor = (AX[i, j], AY[i, j]); rect = (X0[i, j], Y0[i, j], X1[i, j], Y1[i, j])
                if any(seg_hits_rect(o['anchor'], d, rect, 3) for o in others for d in o['dots']):
                    continue
                bad = 0
                for k, d in enumerate(target['dots']):
                    if rect[0] - 2 <= d[0] <= rect[2] + 2 and rect[1] - 2 <= d[1] <= rect[3] + 2:
                        bad += 1
                    for o in others:
                        r = o['rect']
                        if r[0] - 2 <= d[0] <= r[2] + 2 and r[1] - 2 <= d[1] <= r[3] + 2:
                            bad += 1
                        if seg_hits_rect(anchor, d, r, 2):
                            bad += 1
                        od = o['dots'][k] if k < len(o['dots']) else None
                        if od and seg_cross(anchor, d, o['anchor'], od):
                            bad += 1
                    if bad:
                        break
                if bad:
                    continue
                L = np.mean([math.hypot(d[0] - anchor[0], d[1] - anchor[1]) for d in target['dots']])
                mx = np.mean([d[0] for d in target['dots']])
                wrong = (side == 'leading' and mx < anchor[0] - 4) or (side == 'trailing' and mx > anchor[0] + 4)
                move = math.hypot(anchor[0] - old[0], anchor[1] - old[1])
                oc = rect_sum(Socc, X0[i, j], Y0[i, j], X1[i, j], Y1[i, j]) / (w * PH)
                cost = 0.6 * L + 0.4 * move + 300 * oc + (80 if wrong else 0) + (25 if side != target['side'] else 0) \
                    + (2 * (L - 160) if L > 160 else 0)
                if best is None or cost < best[0]:
                    best = (cost, anchor, side, round(L), round(move), round(float(oc), 2))
        if best:
            _, (x, y), side, L, mv, oc = best
            place[target['label']] = (round(x / VW, 3), round(y / VH, 3), side)
            moves.setdefault(name, {})[target['label']] = dict(x=round(x / VW, 3), y=round(y / VH, 3), side=side)
            report[name]['moved'][target['label']] = 'to (%.3f, %.3f) %s, leader %d pt, moved %d pt, on lifter %.2f' % (x / VW, y / VH, side, L, mv, oc)
        else:
            report[name]['stuck'].append(target['label'])
json.dump(moves, open(os.path.join(LAB, 'moves.json'), 'w'), indent=1)
for n, r in report.items():
    print(n)
    for k, v in r['moved'].items():
        print('   moved  %-34s %s' % (k, v))
    for k in r['stuck']:
        print('   STUCK  %s' % k)
    if not r['covering']:
        print('   (nothing covers the face or hands)')
