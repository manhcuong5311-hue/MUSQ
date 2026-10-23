# Draws a lift's callout layout (anns.json with moves.json applied) on its
# label-free stills at 0, 1, 2 and 3 s: pills, leaders and dots where the
# tracked joints are at that moment, moved pills outlined in yellow.
# System python (PIL). Usage: python3 preview_moves.py <lab> "<Lift>" <moves.json|-> <out.jpg>
import sys, os, json, re
from PIL import Image, ImageDraw, ImageFont

LAB, NAME, MV, OUT = sys.argv[1:5]
moves = json.load(open(MV)).get(NAME, {}) if MV != '-' else {}
VW, VH, S = 382, 655, 2
anns = json.load(open(os.path.join(LAB, 'anns.json')))[NAME]['anns']
P = json.load(open(os.path.join(LAB, 'proj_at.json')))[NAME]
Wd = json.load(open(os.path.join(LAB, 'widths.json')))
font = ImageFont.truetype('/System/Library/Fonts/SFNS.ttf', 12 * S)
slug = re.sub('[^a-z0-9]+', '-', NAME.lower())
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'masks.py')).read()
exec(src.split('# Background:')[0].replace('LAB = sys.argv[1]', 'LAB = %r' % LAB))   # card_view()

tiles = []
for t in ('0', '1.0', '2.0', '3.0'):
    p = os.path.join(LAB, 'occ', '%s_v%s.png' % (slug, t))
    if not os.path.exists(p):
        continue
    im = card_view(p).resize((VW * S, VH * S)).convert('RGB')
    d = ImageDraw.Draw(im)
    k = min(range(len(P['times'])), key=lambda i: abs(P['times'][i] - float(t)))
    for a in anns:
        m = moves.get(a['label'])
        x, y, side = (m['x'], m['y'], m['side']) if m else (a['x'], a['y'], a['side'])
        w, h = Wd['widths'][a['label']], Wd['height']
        ax, ay = x * VW, y * VH
        x0 = ax - w if side == 'leading' else ax
        u, v = P['joints'][a['joint']][k]
        d.line([(ax * S, ay * S), (u * VW * S, v * VH * S)], fill=(235, 235, 235), width=2)
        d.ellipse([(u * VW - 3) * S, (v * VH - 3) * S, (u * VW + 3) * S, (v * VH + 3) * S], fill=(255, 255, 255))
        d.rounded_rectangle([x0 * S, (ay - h / 2) * S, (x0 + w) * S, (ay + h / 2) * S], radius=13 * S,
                            fill=(30, 30, 34), outline=(255, 210, 60) if m else (90, 90, 96), width=4 if m else 2)
        d.text(((x0 + 12) * S, (ay - h / 2 + 7) * S), a['label'], font=font, fill=(235, 235, 235))
    d.text((8, 8), '%s  t=%ss' % (NAME, t), font=font, fill=(255, 220, 60))
    tiles.append(im.resize((VW, VH)))
sheet = Image.new('RGB', (VW * len(tiles), VH), (30, 30, 30))
for i, im in enumerate(tiles):
    sheet.paste(im, (i * VW, 0))
sheet.save(OUT, quality=85)
print(OUT)
