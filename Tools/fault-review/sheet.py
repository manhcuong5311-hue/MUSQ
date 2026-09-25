import sys, glob, os, collections
from PIL import Image, ImageDraw
D = sys.argv[1]; out = sys.argv[2]; only = sys.argv[3:] or None
rows = collections.OrderedDict()
for f in sorted(glob.glob(D + "/*.png")):
    ex, cue = os.path.basename(f)[:-4].split("--")
    if only and ex not in only: continue
    rows.setdefault(ex, []).append((cue, f))
W = 300
tiles = []
for ex, items in rows.items():
    row = []
    for cue, f in items:
        im = Image.open(f).convert("RGB")
        w, h = im.size
        im = im.crop((0, int(h * 0.13), w, int(h * 0.80)))   # the viewport, above the mistake bar
        im = im.resize((W, int(im.size[1] * W / w)))
        d = ImageDraw.Draw(im); d.rectangle((0, 0, W, 16), fill="white"); d.text((4, 2), f"{ex} · {cue}", fill="black")
        row.append(im)
    tiles.append(row)
cols = max(len(r) for r in tiles); th = tiles[0][0].size[1]
S = Image.new("RGB", (cols * W, len(tiles) * th), "#888")
for r, row in enumerate(tiles):
    for c, im in enumerate(row): S.paste(im, (c * W, r * th))
S.save(out); print(out, S.size)
