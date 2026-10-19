# Pill widths in pt: SF text width (PIL) for every label, calibrated against the real pills
# measured in the trainer overlay masks. System python (PIL). Usage: python3 widths.py <lab> <new label>...
import sys, os, json
from PIL import Image, ImageFont

LAB = sys.argv[1]
NEW = sys.argv[2:]
VW, VH = 382, 655
anns = json.load(open(os.path.join(LAB, '..', 'anns.json'))) if os.path.exists(os.path.join(LAB, '..', 'anns.json')) else json.load(open(os.path.join(LAB, 'anns.json')))
f = ImageFont.truetype('/System/Library/Fonts/SFNS.ttf', 120)
tw = lambda s: f.getlength(s) / 10.0          # 12 pt text


def slug(n):
    import re
    return re.sub('[^a-z0-9]+', '-', n.lower())


ratios = []
meas = {}
for name, e in anns.items():
    p = os.path.join(LAB, 'occ', slug(name) + '.ui.png')
    if not os.path.exists(p):
        continue
    ui = Image.open(p).convert('L')
    for a in e['anns']:
        ax, ay = a['x'] * VW, a['y'] * VH
        step = -1 if a['side'] == 'leading' else 1
        # the pill's own row: the overlay is solid across the pill's middle third
        best = 0
        for dy in (-3, 0, 3):
            y = int(round(ay + dy))
            if not 0 <= y < VH:
                continue
            x = int(round(ax)) + 2 * step
            run = 0
            gap = 0
            while 0 <= x < VW:
                if ui.getpixel((x, y)) > 0:
                    run = abs(x - ax)
                    gap = 0
                else:
                    gap += 1
                    if gap > 4:
                        break
                x += step
            best = max(best, run)
        meas[name + '|' + a['label']] = best
        t = tw(a['label'])
        if best > 40:
            ratios.append((best - 24) / t)
ratios.sort()
k = ratios[len(ratios) // 2] if ratios else 1.08
print('pill width = 24 + %.3f * text (median of %d pills; range %.3f-%.3f)' % (k, len(ratios), ratios[0], ratios[-1]))
out = dict(k=k, height=28.5, widths={})
for name, e in anns.items():
    for a in e['anns']:
        out['widths'][a['label']] = 24 + k * tw(a['label'])
for s in NEW:
    out['widths'][s] = 24 + k * tw(s)
    print('%-28s %.1f pt (%.3f of the width)' % (s, out['widths'][s], out['widths'][s] / VW))
json.dump(out, open(os.path.join(LAB, 'widths.json'), 'w'), indent=1)
