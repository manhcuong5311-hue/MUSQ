# Compares the white leader dots in real trainer shots with the lab's
# projected joints (2026-10-24): a lift whose projection is off (Assisted Dip,
# ~58 pt) shows a median offset past 6 pt. Shots are <shots dir>/<slug>_t<T>.png
# at 3x, from shoot_trainer.sh. System python (PIL).
#   python3 dots_check.py <lab> <shots dir>
import sys, os, re, json, glob, statistics
from PIL import Image
LAB, SH = sys.argv[1], sys.argv[2]
VW, VH = 382, 655
anns = json.load(open(LAB + '/anns.json')); P = json.load(open(LAB + '/proj_at.json'))
src = open('/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Models/SampleData.swift').read()
i = src.index('stancesByExercise'); stance = set(re.findall(r'^        "([^"]+)": \[\n            ExerciseStance\(', src[i:], re.M))
def slug(n): return re.sub('[^a-z0-9]+', '-', n.lower())
def dots(f, top):
    im = Image.open(f).convert('RGB'); W, H = im.size; px = im.load()
    def isw(c): return c[0] >= 243 and c[1] >= 243 and c[2] >= 243 and max(c) - min(c) < 6
    seen = set(); out = []
    for y in range(top, min(H, top + 3 * VH), 2):
        for x in range(31, 1175, 2):
            if (x, y) in seen or not isw(px[x, y]): continue
            st = [(x, y)]; seen.add((x, y)); pts = []
            while st:
                cx, cy = st.pop(); pts.append((cx, cy))
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if (nx, ny) in seen or not (0 <= nx < W and top <= ny < H): continue
                    if isw(px[nx, ny]): seen.add((nx, ny)); st.append((nx, ny))
            xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
            h = max(ys) - min(ys) + 1; w = max(xs) - min(xs) + 1
            if 100 < len(pts) < 1500 and abs(h - w) <= 4 and 10 < h < 40 and len(pts) > 0.6 * h * w:
                out.append(((sum(xs) / len(xs) - 31.5) / 3, (sum(ys) / len(ys) - top) / 3))
    return out
by = {}
for f in sorted(glob.glob(SH + '/*_t*.png')):
    s, t = os.path.basename(f)[:-4].rsplit('_t', 1)
    n = next((n for n in anns if slug(n) == s), None)
    if not n or n not in P: continue
    st = n in stance; K = (581 / VH) if st else 1.0; CX = 22.6 if st else 0
    top = 573 if st else 351
    e = P[n]; k = min(range(len(e['times'])), key=lambda j: abs(e['times'][j] - float(t)))
    D = dots(f, top)
    for a in anns[n]['anns']:
        j = e['joints'].get(a['joint'])
        if not j or not D: continue
        u, v = j[k]; x, y = K * u * VW + CX, K * v * VH
        d = min(D, key=lambda q: (q[0] - x) ** 2 + (q[1] - y) ** 2)
        by.setdefault(n, []).append((d[0] - x, d[1] - y))
for n, o in sorted(by.items()):
    mx = statistics.median(a for a, b in o); my = statistics.median(b for a, b in o)
    flag = '  <-- OFF' if (mx * mx + my * my) ** 0.5 > 6 else ''
    print('%-36s n=%2d median offset (%6.1f, %6.1f) pt%s' % (n, len(o), mx, my, flag))
