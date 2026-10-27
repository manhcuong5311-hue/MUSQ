# The trainer card's real height per lift (2026-10-24). A subtitle that
# wraps to a second line (e.g. "SHOULDERS · DUMBBELL · INTERMEDIATE")
# pushes the card's top down ~11 pt while its bottom stays put, so the card
# is ~644 pt tall instead of 655; a stance picker without notes (Cable Front
# Raise) leaves ~617 pt where one with notes leaves 581. Pills sit at
# fractions of the card and the camera keeps its vertical field of view, so
# the scene keeps its vertical fractions and narrows about the card's centre
# by the same ratio (the 581 pt stance card's 0.887 scale and 22.6 pt inset
# are that rule). Offline checks that assume 655 put the short cards'
# joints up to ~3 pt off sideways, and dots_check.py's fixed top read them
# ~7 pt low (Cable Front Raise ~21 pt).
# dots_check.py also writes <lab>/dot_offsets.json, the median shift of a
# lift's real dots from these projections where it passes 3 pt (an unknown
# misprojection, e.g. the cable stations' 22 pt); check_layout.py adds it.
# Reads <shots dir>/<slug>_t0.png (3x, from shoot_trainer.sh); writes
# <lab>/cards.json {"Lift": {"top": <card top in px>, "h": <height in pt>}}.
# System python (PIL).
#   python3 cards.py <lab> <shots dir>
import sys, os, re, json
from PIL import Image

LAB, SH = sys.argv[1], sys.argv[2]
VH = 655
TOP = 351                 # the card's top in px under a one-line subtitle
BOTTOM = TOP + 3 * VH     # where every card ends (the sheet's top)
anns = json.load(open(LAB + '/anns.json'))
out = {}
for n in anns:
    p = os.path.join(SH, re.sub('[^a-z0-9]+', '-', n.lower()) + '_t0.png')
    if not os.path.exists(p):
        continue
    im = Image.open(p).convert('RGB')
    # Columns right of the picker's dark segment and the subtitle, left of
    # the buttons, clear of the rounded corner. Light equipment can run up
    # one column past the card's top (the Smith rack's white upright under
    # the 2026-10-25 Charcoal look), so the earliest dark row of several
    # wins.
    top = min(next((y for y in range(330, 1200) if sum(im.getpixel((x, y))) < 3 * 170), 9999)
              for x in (760, 820, 880, 940, 1000, 1060))
    out[n] = dict(top=top, h=round((BOTTOM - top) / 3, 1))
json.dump(out, open(LAB + '/cards.json', 'w'), indent=1)
short = {n: c['h'] for n, c in out.items() if abs(c['h'] - VH) > 2}
print('%d lifts, %d with a shorter card: %s' % (len(out), len(short), ', '.join('%s %.1f' % kv for kv in sorted(short.items()))))
