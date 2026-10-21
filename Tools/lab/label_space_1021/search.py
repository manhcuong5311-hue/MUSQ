# Where a new cue pill can go on each deadlift-set-up lift without sitting on the lifter, the bar,
# the rack, another pill, a dot, the buttons or the legend, with a leader that crosses no
# other leader or pill. Blender's python (numpy). Usage: python3.13 search.py <lab> "<label>" [joints]
import sys, os, json, math, re
import numpy as np

LAB = sys.argv[1]
LABEL = sys.argv[2]
JOINTS = sys.argv[3].split(',') if len(sys.argv) > 3 else ['hand_L', 'hand_R']
VW, VH = 382, 655
anns = json.load(open(os.path.join(LAB, 'anns.json')))
J = json.load(open(os.path.join(LAB, 'joints11.json')))
Wd = json.load(open(os.path.join(LAB, 'widths.json')))
PH = Wd['height']
PW = Wd['widths'][LABEL]
M = 8.0                       # TrackedCallout.edgeMargin


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
    def orient(p, q, r):
        return (q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0])
    o1, o2, o3, o4 = orient(a, b, c), orient(a, b, d), orient(c, d, a), orient(c, d, b)
    return (o1 * o2 < 0) and (o3 * o4 < 0)


res = {}
for name, e in anns.items():
    if os.environ.get('ONLY') and name not in os.environ['ONLY'].split('|'):
        continue
    s = slug(name)
    occ = raw(os.path.join(LAB, 'occ', s + '.occ.raw'))
    ui = raw(os.path.join(LAB, 'occ', s + '.ui.raw'))
    Socc = integral(occ)
    forb = np.zeros((VH, VW), bool)
    ex = []                                   # existing pills: rect + leader samples
    for a in e['anns']:
        w = Wd['widths'][a['label']]
        r = pill_rect(a['x'] * VW, a['y'] * VH, a['side'], w)
        x0, y0, x1, y1 = [int(round(v)) for v in (r[0] - 6, r[1] - 6, r[2] + 6, r[3] + 6)]
        forb[max(y0, 0):min(y1, VH), max(x0, 0):min(x1, VW)] = True
        js = J[name].get(a['joint'], [])
        dots = [(u * VW, v * VH) for u, v in js]
        for (dx, dy) in dots:                 # keep the new pill off every existing dot
            forb[max(int(dy) - 8, 0):min(int(dy) + 8, VH), max(int(dx) - 8, 0):min(int(dx) + 8, VW)] = True
        ex.append(dict(rect=r, anchor=(a['x'] * VW, a['y'] * VH), dots=dots, label=a['label']))
    # buttons (top right) and legend (bottom left), measured from the overlay
    forb[0:118, 322:VW] = True
    ys, xs = np.nonzero(ui[560:, :])
    if len(ys):
        lx1 = xs.max(); ly0 = 560 + ys.min()
        leg = ui[560:, :]
        # the legend is the wide block hugging the left edge: rows where the left 20 pt are lit
        rows = np.nonzero(leg[:, 8:24].any(1))[0]
        if len(rows):
            ly0 = 560 + rows.min() - 6
            cols = np.nonzero(leg[rows.min():rows.max() + 1, :].any(0))[0]
            forb[ly0:VH, 0:min(VW, cols.max() + 8)] = True
    Sforb = integral(forb)
    best = []
    for side in ('leading', 'trailing'):
        ax = np.arange(M + (PW if side == 'leading' else 0), VW - M - (0 if side == 'leading' else PW) + 0.1, 3.0)
        ay = np.arange(M + PH / 2, VH - M - PH / 2 + 0.1, 3.0)
        AX, AY = np.meshgrid(ax, ay)
        X0 = AX - PW if side == 'leading' else AX
        X1 = AX if side == 'leading' else AX + PW
        Y0, Y1 = AY - PH / 2, AY + PH / 2
        fb = rect_sum(Sforb, X0, Y0, X1, Y1)
        oc = rect_sum(Socc, X0, Y0, X1, Y1) / (PW * PH)
        ok = (fb == 0) & (oc <= float(os.environ.get('OCC_MAX', '0.06'))) & (AY >= float(os.environ.get('YMIN', '0')) * VH)
        for i, j in zip(*np.nonzero(ok)):
            anchor = (AX[i, j], AY[i, j])
            rect = (X0[i, j], Y0[i, j], X1[i, j], Y1[i, j])
            # no old leader may run under the new pill
            if any(seg_hits_rect(o['anchor'], d, rect, 3) for o in ex for d in o['dots']):
                continue
            for jn in JOINTS:
                samples = [(u * VW, v * VH) for u, v in J[name][jn]]
                bad = 0
                for k, d in enumerate(samples):
                    # the new dot must not hide under an old pill, nor its leader cross old pills or leaders
                    for o in ex:
                        r = o['rect']
                        if r[0] - 2 <= d[0] <= r[2] + 2 and r[1] - 2 <= d[1] <= r[3] + 2:
                            bad += 1
                        if seg_hits_rect(anchor, d, r, 2):
                            bad += 1
                        od = o['dots'][k] if k < len(o['dots']) else None
                        if od and seg_cross(anchor, d, o['anchor'], od):
                            bad += 1
                    if rect[0] - 2 <= d[0] <= rect[2] + 2 and rect[1] - 2 <= d[1] <= rect[3] + 2:
                        bad += 1                  # the pill would sit on its own dot
                if bad > int(os.environ.get('BAD_MAX', '0')):
                    continue
                L = np.mean([math.hypot(d[0] - anchor[0], d[1] - anchor[1]) for d in samples])
                # leaders should leave the pill on the side facing the dot
                mx = np.mean([d[0] for d in samples])
                wrong_side = (side == 'leading' and mx < anchor[0] - 4) or (side == 'trailing' and mx > anchor[0] + 4)
                cost = float(os.environ.get('WL', '1')) * L + float(os.environ.get('WO', '400')) * oc[i, j] + (80 if wrong_side else 0) + 60 * bad + (0 if anchor[1] <= float(os.environ.get('TOPY', '9999')) else float(os.environ.get('TOPPEN', '0')))
                best.append((cost, round(anchor[0] / VW, 3), round(anchor[1] / VH, 3), side, jn, round(L), round(float(oc[i, j]), 3), bad))
    best.sort()
    # keep distinct spots
    pick = []
    for b in best:
        if all(abs(b[1] - p[1]) > 0.06 or abs(b[2] - p[2]) > 0.05 or b[3] != p[3] or b[4] != p[4] for p in pick):
            pick.append(b)
        if len(pick) == 6:
            break
    res[name] = pick
    print(name)
    for p in pick:
        print('   cost %5.1f  point (%.3f, %.3f) %-8s %-12s leader %3d pt  occ %.3f  bad %d' % p)
json.dump(res, open(os.path.join(LAB, 'search_' + re.sub('[^a-z]+', '_', LABEL.lower()) + '.json'), 'w'), indent=1)
