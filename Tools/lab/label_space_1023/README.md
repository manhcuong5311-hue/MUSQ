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

Exercises 201-280 (2026-10-24): the same pass for the Desktop "From 191"
swap (fdb0a36, exports 201-280). Two checker fixes came first:
- The card's height. A subtitle that wraps to a second line (e.g.
  "SHOULDERS · DUMBBELL · INTERMEDIATE") pushes the card's top down ~11 pt
  while its bottom stays put, so the card is 643.7 pt tall; a stance picker
  without notes (Cable Front Raise) leaves 616.7 pt, one with notes 581.
  Pills sit at fractions of the card and the camera keeps its vertical field
  of view, so the scene keeps its vertical fractions and narrows about the
  card's centre by the same ratio (the 581 pt stance card's 0.887 scale and
  22.6 pt inset are that rule). `cards.py <lab> <shots>` measures each
  lift's card on its t=0 trainer shot into `cards.json`; `check_layout.py`
  and `dots_check.py` use it when present. That explains the ~6-7 pt "off"
  lifts `dots_check.py` reported: its top was fixed at a one-line subtitle's.
  With it all 78 lifts of this batch agree within 3 pt.
- The buttons. "Under the buttons" was any pill reaching x > 322 with its
  top above y 118, which flagged pills well clear below them; it now uses
  the two buttons' frames (x 338-370, y 12-84 pt) with 4 pt to spare.
Widths were set with `K=1.20` (the real pills' factor found for 101-200;
`widths.py` alone fits 1.12). Shots for this pass came from a second
iPhone 17 Pro simulator made for it ("Claude Harness 17 Pro B"), so the
ghost shoot on the harness simulator could run at the same time.
With those, 45 of the 78 lifts checked clean and 33 had a pill on the head
or a fist, a leader across the face or through another dot, or a dot under
a pill. Laid out one agent per lift with these tools and checked by a
second (who changed 10 of the 33), then shot in the rebuilt app at six
moments of the rep and checked again on the shots, one checker per lift:
62 pills moved on 32 lifts (`moves_201_300.json`), and two dots track
another joint (`joints_201_300.json`): Chest-Supported Lateral Raise's
"Shoulders down, no shrug" the right trap's attachment (the left support
point sat ~8 pt from the head's centre, so any leader to it crossed the
face) and Machine Rear Delt Row's "Chest on the pad" the chest (the spine
joint sat on the lower back since the new machine seats the lifter 17 cm
higher). On the real shots Cable Rear Delt Row's shrug pill still lay on
the crown of the head: seen from behind, the head rises above the disc the
checker draws ahead of the head joint. It moved to the top row and passed a
second shot check. 75 lifts now check clean. Left as they are: three
leaders that must cross the face because the elbow or hand they track
passes in front of the head (Viking Press "Elbows tucked" and "Palms in,
wrists neutral", Powell Raise "Arm long, elbow soft", Rear Delt Row
"Elbows out wide"; the pills themselves stay off it), and dots that slip
behind a plate for a moment (Viking Press's right hand, the 21s Curl's and
Barbell Preacher Curl's far arm, Dumbbell Reverse Curl's shoulder at the
top).

Exercises 300-400 (2026-10-25): the same pass for the Desktop "From 316"
swap (e79db48), 49 lifts with content, now under the 2026-10-25 "Charcoal"
model look (a dark grey lifter on a lighter grey studio). Two more checker
fixes:
- `cards.py` looked for the card's top in one pixel column, and the Smith
  rack's white upright runs up that column under the new look (Smith
  Machine Split Squat read 539.7 pt); it now takes the earliest dark row of
  six columns. Every card of this batch is 655 pt.
- Cable Hip Adduction and Cable Standing Leg Curl project 22 pt right of
  their real dots, the cause not found (like 1-100's Assisted Dip).
  `dots_check.py` now writes each lift's median shift past 3 pt to
  `dot_offsets.json`, and `check_layout.py` adds it; Cable Standing Leg
  Curl's "leader under a pill" was that shift.
With them, 31 lifts checked clean and 18 had a pill on a fist, a leader
across the face or through another dot, or crossing leaders; the ghost
review added Smith Machine Hip Thrust, whose dots sat on the Smith upright,
the bar pad, the hand and a white shoe. One agent laid out each lift and
another verified it (three corrected): 46 pills moved on 19 lifts
(`moves_300_400.json`) and six dots track another joint
(`joints_300_400.json`): Good Morning's "Bar on the traps" the right trap
(it tracked the left hand, which passes over the face at the bottom),
Machine Hip Thrust's "Roller on hip crease" the right hand at the roller's
end (the left passed in front of the face), and on Smith Machine Hip Thrust
"Ribs down, spine neutral" the spine, "Back pivots on the bench" the chest
(the back never shows from this camera), "Pad on the hip crease" the lower
pec's support point (it lands on the bar pad) and "Shins vertical at the
top" the knee. All 49 lifts now check clean; shot in the rebuilt app at six
moments, the 19 relaid lifts each passed a checker on the real shots.
Left: white dots on white shoes (Assisted Nordic Curl's ankles, Banded Hip
Abduction's and Machine Hip Thrust's feet) and dots that slip behind an
arm for a moment (B-Stance Romanian Deadlift's hip and back at the top).
