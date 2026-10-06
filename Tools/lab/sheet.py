# Contact sheet: sheet.py out.png cols [--size WxH] label=image ...
# (or plain image paths, labelled by file name).
import sys, os
from PIL import Image, ImageDraw

args = sys.argv[1:]
out, cols = args[0], int(args[1]); args = args[2:]
W, H = 230, 394
if args and args[0] == "--size":
    W, H = map(int, args[1].split("x")); args = args[2:]
items = [a.split("=", 1) if "=" in a else (os.path.basename(a)[:-4], a) for a in args]
tiles = []
for label, p in items:
    try:
        im = Image.open(p).convert("RGB").resize((W, H))
    except Exception:
        im = Image.new("RGB", (W, H), (60, 0, 0))
    d = ImageDraw.Draw(im)
    d.rectangle((0, 0, W, 14), fill=(0, 0, 0)); d.text((2, 1), label[:44], fill=(255, 255, 0))
    tiles.append(im)
rows = (len(tiles) + cols - 1) // cols
sheet = Image.new("RGB", (cols * W, max(rows, 1) * H), (40, 40, 40))
for i, t in enumerate(tiles):
    sheet.paste(t, ((i % cols) * W, (i // cols) * H))
sheet.save(out)
print(out, len(tiles))
