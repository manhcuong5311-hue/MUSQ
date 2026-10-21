# Checks the lats pill of each deadlift-set-up lift against the layout now in SampleData.swift, over the
# dense 0.25 s joint samples: overlaps, leaders crossing pills or leaders, dots under pills, and how
# much of the pill sits on the lifter or the equipment. Blender's python.
# Usage: python3.13 checkall.py <lab> <anns_now.json>
import sys, os, json, math, re
import numpy as np

LAB, ANF = sys.argv[1], sys.argv[2]
src = open(os.path.join(LAB, 'search.py')).read()
sys.argv = [sys.argv[0], LAB, 'Grip & lats tight']
exec(src.split('res = {}')[0])
ANN = json.load(open(ANF))
P = json.load(open(os.path.join(LAB, 'proj_at.json')))
font_w = Wd['widths']


def width(label):
    return font_w[label]


for name, e in ANN.items():
    s = slug(name)
    occ = raw(os.path.join(LAB, 'occ', s + '.occ.raw'))
    J2 = P[name]['joints']
    pills = []
    for a in e['anns']:
        if a['joint'] not in J2:
            print('   (no dense samples for %s on %s)' % (a['joint'], name))
            continue
        w = width(a['label'])
        pills.append(dict(label=a['label'], cue=a['cue'], rect=pill_rect(a['x'] * VW, a['y'] * VH, a['side'], w),
                          anchor=(a['x'] * VW, a['y'] * VH), dots=[(u * VW, v * VH) for u, v in J2[a['joint']]], side=a['side']))
    new = next(p for p in pills if p['cue'] == 'lats')
    others = [p for p in pills if p is not new]
    issues = []
    r = new['rect']
    for o in others:
        q = o['rect']
        if not (q[2] + 4 < r[0] or r[2] < q[0] - 4 or q[3] + 4 < r[1] or r[3] < q[1] - 4):
            issues.append('overlaps pill ' + o['label'])
        if any(seg_hits_rect(o['anchor'], d, r, 2) for d in o['dots']):
            issues.append('leader of %s runs under the new pill' % o['label'])
    for k, d in enumerate(new['dots']):
        for o in others:
            q = o['rect']
            if q[0] <= d[0] <= q[2] and q[1] <= d[1] <= q[3]:
                issues.append('t=%.2f dot under %s' % (P[name]['times'][k], o['label']))
            if seg_hits_rect(new['anchor'], d, q, 1):
                issues.append('t=%.2f leader through %s' % (P[name]['times'][k], o['label']))
            if seg_cross(new['anchor'], d, o['anchor'], o['dots'][k]):
                issues.append('t=%.2f crosses leader of %s' % (P[name]['times'][k], o['label']))
    # the moved bar pills too: their leaders against everything else
    x0, y0, x1, y1 = [int(round(v)) for v in r]
    oc = occ[max(y0, 0):y1, max(x0, 0):x1].mean()
    uniq = sorted(set(re.sub(r't=[\d.]+ ', '', i) for i in issues))
    n = len(issues)
    print('%-36s %-24s occ %.3f  %s' % (name, new['label'], oc, 'clean' if not n else '%d hits: %s' % (n, '; '.join(uniq))))
