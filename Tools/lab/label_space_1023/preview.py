# Draws proposed new pills (and any moved old pills) onto the trainer shots at t=0 and at the bottom,
# so a layout can be judged before touching the app. System python (PIL).
# Usage: python3 preview.py <lab> <placements.json> <out.jpg>
#   placements.json: {"Back Squat": {"x":..,"y":..,"side":..,"joint":..,"label":..,
#                                    "move": {"<old label>": {"x":..,"y":..,"side":..}}}, ...}
import sys, os, json, re
from PIL import Image, ImageDraw, ImageFont

LAB, PL, OUT = sys.argv[1], json.load(open(sys.argv[2])), sys.argv[3]
VW, VH, S = 382, 655, 3
P = json.load(open(os.path.join(LAB, 'proj_at.json')))
ANNS = json.load(open(os.path.join(LAB, 'anns.json')))
Wd = json.load(open(os.path.join(LAB, 'widths.json')))
font = ImageFont.truetype('/System/Library/Fonts/SFNS.ttf', 12 * S)
B = json.load(open('/Users/sammanhcuong/Developer/GymWorkout/Tools/fault-review/bottoms.json'))


def slug(n):
    return re.sub('[^a-z0-9]+', '-', n.lower())


def width(label):
    if label in Wd['widths']:
        return Wd['widths'][label]
    return 24 + Wd['k'] * font.getlength(label) / S


def card(path):
    im = Image.open(path).convert('RGB')
    w, h = im.size
    top = next(y for y in range(200, h) if sum(im.getpixel((60, y))) < 3 * 170)
    return im.crop((30, top, 30 + S * VW, top + S * VH))


def pill(d, ax, ay, side, label, fill=(30, 30, 34), edge=(255, 210, 60)):
    w, h = width(label) * S, Wd['height'] * S
    x0 = ax * VW * S - w if side == 'leading' else ax * VW * S
    y0 = ay * VH * S - h / 2
    d.rounded_rectangle([x0, y0, x0 + w, y0 + h], radius=13 * S, fill=fill, outline=edge, width=4)
    d.text((x0 + 12 * S, y0 + 7 * S), label, font=font, fill=(235, 235, 235))


tiles = []
for name, p in PL.items():
    s = slug(name)
    b = round(B.get(name, 1.0), 2)
    times = [0.0, b] if b > 0 else [0.0, 1.5]
    for t in times:
        shot = os.path.join(LAB, 'shots_before', '%s_t%s.png' % (s, ('%g' % t) if t else '0'))
        if not os.path.exists(shot):
            shot = os.path.join(LAB, 'shots_before', '%s_t%s.png' % (s, t))
        if not os.path.exists(shot):
            continue
        im = card(shot)
        d = ImageDraw.Draw(im)
        e = P[name]
        k = min(range(len(e['times'])), key=lambda i: abs(e['times'][i] - t))
        # moved old pills: grey out the old spot, draw the new one in blue
        for lab, m in p.get('move', {}).items():
            old = next(a for a in ANNS[name]['anns'] if a['label'] == lab)
            w = width(lab) * S
            ox0 = old['x'] * VW * S - w if old['side'] == 'leading' else old['x'] * VW * S
            d.rectangle([ox0, old['y'] * VH * S - 14 * S, ox0 + w, old['y'] * VH * S + 14 * S], outline=(255, 60, 60), width=4)
            jx, jy = e['joints'].get(old['joint'], [[0.5, 0.5]] * len(e['times']))[k] if old['joint'] in e['joints'] else (None, None)
            if jx is not None:
                d.line([(m['x'] * VW * S, m['y'] * VH * S), (jx * VW * S, jy * VH * S)], fill=(120, 190, 255), width=4)
            pill(d, m['x'], m['y'], m['side'], lab, edge=(120, 190, 255))
        jx, jy = e['joints'][p['joint']][k]
        d.line([(p['x'] * VW * S, p['y'] * VH * S), (jx * VW * S, jy * VH * S)], fill=(255, 210, 60), width=5)
        d.ellipse([jx * VW * S - 12, jy * VH * S - 12, jx * VW * S + 12, jy * VH * S + 12], fill=(255, 210, 60))
        pill(d, p['x'], p['y'], p['side'], p['label'])
        im = im.resize((VW, VH))
        ImageDraw.Draw(im).text((6, VH - 14), '%s  t=%s  %s' % (name, t, p['joint']), fill=(255, 255, 255))
        tiles.append(im)
cols = 6
rows = (len(tiles) + cols - 1) // cols
sheet = Image.new('RGB', (VW * cols, VH * rows), (15, 15, 15))
for i, t in enumerate(tiles):
    sheet.paste(t, ((i % cols) * VW, (i // cols) * VH))
sheet.save(OUT, quality=82)
print(OUT, sheet.size)
