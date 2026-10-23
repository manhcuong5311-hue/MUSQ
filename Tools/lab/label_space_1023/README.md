# Pills off the face and hands (2026-10-23)

After the 2026-10-17 re-tune of exercises 1-100, the ghost review
(`Tools/fault-review/README.md`) found callout pills sitting on the lifter's
face or fists on 14 lifts (`lifts.txt`). The owner asked to move them. The
tools are the `../label_space_1020` set (whose README has the method), driven
by `lifts.txt` instead of hard-coded lists, plus:

- `check_layout.py <lab> "<Lift>" [moves.json]`: every problem of one
  lift's whole layout over the dense samples (every 0.25 s): a pill on the
  face (24 pt round the head joint) or a fist (15 pt round the hand and
  middle knuckle), pills overlapping, a dot or leader under a pill, crossing
  leaders, the buttons; and how much of each pill sits on the lifter.
- `preview_moves.py <lab> "<Lift>" <moves.json> <out.jpg>`: the layout drawn
  on the label-free stills at 0-3 s, moved pills outlined.
- `move_off.py`: a greedy one-pill re-placer; on crowded lifts it gets stuck
  or sends leaders across the frame, so it served only as a hint.
- `apply_moves.py SampleData.swift moves.json`: writes new points and sides.

Each lift was laid out by one agent with those tools and checked by a
second; `moves_v1.json` is what went in (41 pills on 14 lifts). Every lift
now checks clean: no pill on the face or a fist at any moment, no overlap,
no crossing, no dot under a pill. Pills still sit over the bar, a machine
or the legs where the frame has no other room (Leg Extension, Hip Abduction
Machine (Lean), Low-to-High Cable Fly).

Pitfalls: the harness simulator had been left in Dark appearance, which
breaks `masks.py`'s card crop (it looks for the dark card under a light
header) and the pill-width calibration; shoot the trainer stills in Light
(`xcrun simctl ui <sim> appearance light`) and set it back afterwards. The
`proj_at.py` here reads each lift's framing from SampleData (including the
`.standing` preset) and projects every joint the lifts' callouts track.
