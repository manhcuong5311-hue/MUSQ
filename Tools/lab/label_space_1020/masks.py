# Masks for the label search, at 1 px = 1 pt of the 382x655 trainer viewport.
#  occ/<slug>.occ.raw  : anything the model or its equipment covers at any of the 7 label-free stills
#  occ/<slug>.ui.raw   : the trainer's own overlay at t=0 (pills, leaders, dots, buttons, legend)
# Run with the system python (PIL). Usage: python3 masks.py <lab>
import sys, os, json, glob
from PIL import Image, ImageChops, ImageFilter

LAB = sys.argv[1]
OCC = os.path.join(LAB, 'occ')
VW, VH = 382, 655
SLUGS = ["back-squat", "box-squat", "pause-squat", "barbell-sumo-squat", "heel-elevated-squat",
         "barbell-split-squat", "smith-machine-split-squat", "barbell-bulgarian-split-squat",
         "smith-machine-bulgarian-split-squat", "good-morning", "seated-good-morning",
         "smith-machine-good-morning", "barbell-step-up"]


def card_view(path):
    """The label-free viewport (HARNESS_VIEW): the only non-black block below the status bar."""
    im = Image.open(path).convert('RGB')
    w, h = im.size
    top = next(y for y in range(200, h) if sum(im.getpixel((w // 2, y))) > 40)
    return im.crop((30, top, 30 + 3 * VW, top + 3 * VH))


def card_trainer(path):
    """The trainer viewport: the dark card under the light header."""
    im = Image.open(path).convert('RGB')
    w, h = im.size
    top = next(y for y in range(200, h) if sum(im.getpixel((60, y))) < 3 * 170)
    return im.crop((30, top, 30 + 3 * VW, top + 3 * VH))


def maxdiff(a, b):
    d = ImageChops.difference(a, b)
    r, g, bl = d.split()
    return ImageChops.lighter(ImageChops.lighter(r, g), bl)


def to_pt(mask_l, thr):
    """Binary at full res, then any-pixel pooling down to 1 px per pt."""
    m = mask_l.point(lambda v: 255 if v > thr else 0)
    return m.filter(ImageFilter.MaxFilter(3)).resize((VW, VH), Image.BOX).point(lambda v: 255 if v > 0 else 0)


# Background: the empty viewport, with the 'model failed to load' text blended out row-wise.
bg = card_view(os.path.join(OCC, 'empty.png'))
W3, H3 = bg.size
y0, y1 = int(0.38 * H3), int(0.60 * H3)
px = bg.load()
for x in range(W3):
    a, b = px[x, y0], px[x, y1]
    for y in range(y0 + 1, y1):
        t = (y - y0) / (y1 - y0)
        px[x, y] = tuple(int(a[k] + (b[k] - a[k]) * t) for k in range(3))
bg.save(os.path.join(OCC, 'bg.png'))

meta = {}
for s in SLUGS:
    views = sorted(glob.glob(os.path.join(OCC, s + '_v*.png')))
    if not views:
        print('no views', s)
        continue
    occ = None
    for v in views:
        m = to_pt(maxdiff(card_view(v), bg), 26)
        occ = m if occ is None else ImageChops.lighter(occ, m)
    occ.save(os.path.join(OCC, s + '.occ.png'))
    open(os.path.join(OCC, s + '.occ.raw'), 'wb').write(occ.tobytes())
    tr = os.path.join(LAB, 'shots_before', s + '_t0.png')
    v0 = os.path.join(OCC, s + '_v0.png')
    if os.path.exists(tr) and os.path.exists(v0):
        ui = to_pt(maxdiff(card_trainer(tr), card_view(v0)), 30)
        ui.save(os.path.join(OCC, s + '.ui.png'))
        open(os.path.join(OCC, s + '.ui.raw'), 'wb').write(ui.tobytes())
    meta[s] = dict(views=len(views))
    print(s, len(views), 'views')
json.dump(meta, open(os.path.join(OCC, 'masks.json'), 'w'))
