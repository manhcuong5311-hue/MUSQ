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

Exercises 101-200 and a stricter check (2026-10-23/24). The same pass for
the 101-200 swap put 36 pills of 18 lifts off faces and fists
(`moves_101_200.json`, then `moves_101_200_r2.json` for five more pills once
a real-app review found leaders running through another pill's dot). That
review and its verifiers found the checker's blind spots, now fixed:
- The face was a 24 pt circle round the head joint, which sits at the base
  of the skull 20-40 pt behind the face. It is now the head: a disc 0.75 of
  the neck-to-head bone past the joint, radius 1.05 of that bone on screen
  (fitted on the Snatch-Grip Deadlift's silhouettes), and a pill is on it
  when it covers a tenth of it.
- New problem kinds: a leader through another pill's dot (within 6 pt; it
  then reads as pointing there) and a leader across the face.
- Lifts with a stance picker have a 382 x 581 card (picker and note above
  it), the scene scaled 0.887 and inset 22.6 pt; the checker reads
  `stancesByExercise` and uses that geometry. Pills are clamped into the 8 pt
  margins as `TrackedCallout` does.
- `proj_at.py` reads every framing preset (`.bench`, `.cableStation`, ...),
  `parse_anns.py` and `apply_moves.py` read the bench presses' `218.0 /
  382.0` points (`apply_moves.py` used to skip them silently; it now asserts),
  `widths.py` takes `K=1.15` to skip calibration on lifts with no shots.
Rescanned with it, all 183 lifts of exercises 1-200 (offline: `anns`,
`proj_at` and fixed widths are enough) showed 21 more with a pill on the
head or a fist that the reviews had not named, 17 of them in 1-100 (the leg
presses' hip pills on the hand at the side handle, Pec Deck Fly's squeeze
pill on the chin, the Grip & lats pill on the Stiff-Leg Deadlift's head, the
squats' trap pills on the face, ...). Laid out and checked one agent each,
then shot in the app at five moments of the rep and re-reviewed
(`moves_faces_hands_1024.json`, 55 pills on 22 lifts with Decline Cable
Press below; Cable Wood Chop's chin touch at the bottom of the chop needed
a second pass judged on real shots every 0.25 s).
- `dots_check.py` on a 0 s shot of all 183 lifts found seven whose real
  leader dots disagree with `proj_at`: Assisted Dip (~58 pt left), the
  Decline Cable Fly, Decline Cable Press, Decline Crunch and Smith Machine
  Decline Press (~26-45 pt high), Weighted Chest Dip (~12 pt) and Standing
  Dumbbell Press (~6 pt). The cause is not found. Checked on joints fitted
  to the shots (scale and offset), only Decline Cable Press had a pill on
  the head; it was moved.
- The real pills are 3-6 pt wider than `widths.py`'s fit (the measured
  factor is ~1.20, not 1.13-1.15). With `K=1.20`, nine more lifts flag, and
  on the real shots each is a pill end 0-3 pt from the edge of a head or a
  hand, not over it: Belt Squat, Curtsy Lunge, Zercher Squat, Rack Pull,
  Incline Dumbbell Press, Low-to-High Cable Fly, Single-Leg Calf Raise,
  Wide-Grip Barbell Row, Landmine Shoulder Press. These were left as they
  are.
- Snatch-Grip Deadlift: at lockout the Grip & lats dot sits ~4 pt from
  the end of "Upper back tight, flat". No position-only fix exists. Renaming
  the label to "Upper back tight" (the Safety Bar Squat's wording) at x
  0.660 would clear it; that waits for the owner.
