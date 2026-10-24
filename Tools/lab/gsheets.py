# One contact sheet per exercise from a shoot_ex.sh run (2026-10-22): the
# trainer at 0 / 1.5 / 3 s, then every cue's mistake view (ghost or ring),
# for reviewing ghosts. python3 gsheets.py <shoot_ex out dir> <sheets dir>
import sys, os, glob
from PIL import Image, ImageDraw, ImageFont

G, OUT = sys.argv[1], sys.argv[2]
os.makedirs(OUT, exist_ok=True)
font = ImageFont.truetype('/System/Library/Fonts/SFNS.ttf', 15)
W, H = 240, 522
for cues in sorted(glob.glob(os.path.join(G, 'cues_*.txt'))):
    slug = os.path.basename(cues)[5:-4]
    tiles = []
    for t in ('0', '1.5', '3'):
        p = os.path.join(G, 'trainer', f'{slug}_t{t}.png')
        if os.path.exists(p):
            tiles.append((f'trainer t={t}s', p))
    for line in open(cues):
        cue, st = line.split()
        tiles.append((f'mistake: {cue} @ {st}s', os.path.join(G, 'faults', f'{slug}--{cue}.png')))
    cols = 4
    rows = (len(tiles) + cols - 1) // cols
    sheet = Image.new('RGB', (cols * W, rows * (H + 22)), (30, 30, 30))
    d = ImageDraw.Draw(sheet)
    for i, (label, p) in enumerate(tiles):
        x, y = (i % cols) * W, (i // cols) * (H + 22)
        try:
            im = Image.open(p).convert('RGB').resize((W, H))
        except Exception:
            im = Image.new('RGB', (W, H), (90, 0, 0))
        sheet.paste(im, (x, y + 22))
        d.text((x + 4, y + 3), label, fill=(255, 220, 60), font=font)
    sheet.save(os.path.join(OUT, slug + '.jpg'), quality=82)
print(len(glob.glob(os.path.join(OUT, '*.jpg'))), 'sheets')
