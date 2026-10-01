# Batch 241-300: standing cable curls (2026-09-27)

Content: `spec_241_300_cable.py`. Ghosts: `Tools/fault-review/faults_241_300_cable.swift.txt`.
Four exercises from SourceExports/241-300: 243 Single-Arm Cable Curl, 244 High Cable Curl,
245 Overhead Cable Curl, 247 Cable Hammer Curl.

How the models were read: the briefs and the framing shots, then the rig and the equipment
prims straight from the USD (Blender's Python + pxr): joint angles over the clip, pulley,
handle, bar and stack transforms, and the palm direction from the finger joints (the curled
fingertip points to the palm). The brief's palm words come from a script that assumes Z-up;
these files are Y-up, so its "up" means forward and its "backward" means up (for example the
single-arm curl's "palm up" at the start is palm forward with the arm hanging). Every ghost
was solved with a Python port of `FaultGhost.solve` on the real joint transforms, projected
with the app's framing (plus its `view`) and drawn over the framing shots or a side/face-on
stick figure to check its direction and size.

Where each curl is hardest was read off the rig: the share of the cable's pull that turns the
elbow (sine of the angle between forearm and cable, grip to pulley), against a weight held in
the same pose (numbers in the spec header). Low pulley ahead (single-arm, hammer): the cable
runs mostly down and partly forward (single-arm ~56° below horizontal at the start, 76-78°
from mid-rep to the top; hammer ~44° at the start, also outward, 65-69° later), ~25-40° off
the hanging forearm's line, so its pull tips the hand forward and does not resist the start
(share -0.39 single-arm, -0.45 hammer, free weight 0.17); ~0.9-1.0 from 100° to 70°; 0.88
at the top where a free weight is 0.71. High cable: 0.47 at the start, 0.92 mid-rep, 0.66 at
the top. Overhead: 0.18 at the start, 1.00 mid-rep, 0.85 at the top. The copy says only that
the cable "barely resists" or "pulls almost along the arms" at the start, so the first part
is light and easy to cut short.

The cable's moment about the shoulder (per unit tension at the hands; re-read in the revision
from the pulley and handle prims): single-arm and hammer extension at the top (~0.19), so an
elbow swinging forward works against it (front deltoid); high cable adduction all rep
(0.18-0.37), overhead ~0 at the start and extension from ~150° to the top (0.16-0.29), so in
those two sinking or dropping elbows give way to the cable and the handles drift toward the
pulleys. The copy never says the lats or shoulders help lift the weight.

The copy does not say cables keep constant tension (StrengthLog's cable pages do) or build
more muscle: Nunes 2020 (cable vs barbell preacher, torque peaking at
opposite ends: similar growth), Attarieh 2025 and Larsen 2026 (shoulder angle changed with
profiles matched: similar growth) and Parpa 2025 (dumbbell curl more biceps EMG than a
Bayesian cable curl) all argue against those claims.

## Checks run

- `python3 spec_241_300_cable.py` prints OK.
- gen.py dry run (the command in the task) lays out 5 annotations per entry; all rows are
  pinned with `overrides`. Pills and leaders were drawn over the framing shots at 0.2 s and
  1.58 s with the rows squeezed as `spec_241_300.py` does (0.14 -> 0.16, 0.50 -> 0.48, 0.68 ->
  0.64, 0.86 -> 0.80): no leader crosses the head or another pill, no pill covers a moving
  hand, handle or bar, and the glows sit on the working or near arm.
- Swift: the pieces and table were pasted into a scratch copy of FaultPoses.swift (pieces
  above `// MARK: Back pieces`, table after the Barbell Hip Thrust entry) and
  `xcrun swiftc -typecheck` passed. No project build, no simulator.
- No clash with the table: none of the four names is in FaultPoses.swift yet; the two new
  piece names are not used by the other 241-300 families.

## Revision after review (2026-09-27)

Both reviews (evidence; model, labels and ghosts) were checked against the rig (cable
direction, elbow and shoulder moments and stack heights re-read from the USD), the shots, an
equipment depth raster at the ghost views and the sources (StrengthLog pages re-fetched; ExRx
and Muscle & Strength read from web.archive.org captures; the NSCA manual from its PDF).
Applied: the overhead upper-arm why and comparison (no lats claim; the cable pulls the raised
arms down), the overhead pad why and mistake, the overhead range why and mistake, the
single-arm and hammer range whys (the cable runs mostly down and barely resists the start),
the high upper-arm why and comparison note (sinking elbows give way to the cables), the
single-arm shoulder and stance whys (no "drags the shoulder forward"), the torso whys (no
strain claim), "joins in" for the front deltoid, "without swinging the elbow forward",
FULL_RANGE narrowed to mid-range partials, the high stance why, brachioradialis 0.42 MOD for
the high and overhead curls, the hammer activation order (brachialis first), the single-arm
torso dot on the pelvis, the hammer grip dot on the near hand, the high range label "Almost
straight", the overhead setup "lat bar", the single-arm stance ghost turned to total +0.5 and
the hammer grip ghost to face-on, plus the source and citation notes. Left for the lead: the
single-arm framing (idle side toward the camera), the overhead stack resting for half the
rep, and the high cable curl's shoulder-height pulleys against its name. `python3
spec_241_300_cable.py` prints OK and the gen.py dry run lays out all four; labels were
redrawn over the 0.2 s and 1.58 s shots.

## Revision after the in-app visual review (2026-09-27)

The Single-Arm Cable Curl was re-framed after the content was written: yaw +1.1 zoom 0.874
-> yaw -1.5 zoom 0.875 offset (-0.002, 0.037, 0.026), seen from the working left side
(joints.json re-probed). Both visual reviews (labels; ghosts) were checked against the app
screenshots at 0.2 s and the two peaks, all 20 fault stills, the re-probed joints and a
re-projection of the ghosts with the mistake view's staging (scale 1 - 0.25 x 0.26, lift
0.35 x 0.26 of the view height, as USDZViewport does; it lands on the yellow ghost of the
elbow and wrist stills). Proposed pills were drawn over the trainer shots and the fault
stills with the app's pill widths (about 18 + 6.4 pt per character).

Applied:
- Single-Arm, re-laid for the left-side view: "Upper arm still" (top right, near shoulder;
  the old 22-character label covered the back of the head), "Shoulders down" on
  `scapula_L` at the right-hand row 0.32 (the old dot `upper_arm_R` is now the far shoulder,
  and the top-left pill sat on the face and, in the mistake view, under the raised ghost
  hand), "Stand tall" on `support_LatissimusDorsi_L` at the right-hand row 0.48 (the pelvis
  dot sat on the hanging hand at the start, beside the range dot), "Lower all the way" on
  the left at row 0.48 (a level leader at the bottom, near-vertical beside the cable at the
  top, instead of one across the whole trunk), and the stance dot on the near ankle
  (`foot_L`). The top-left row stays empty. Biceps glow without the old +0.04 nudge (the
  working arm is now nearest the camera).
- Single-Arm ghosts re-set for yaw -1.5: torso without `.seen(0.45)` (total -1.05 put the
  column and stack in front of the lifter; side-on the lean lies in the picture plane);
  shoulder `hunched("L")` (side-on, the free arm's ghost crossed the trunk); stance
  `.seen(-1.1)`, total -2.6 back-left (at -2.1 the width change was foreshortened to about
  half; +0.5 front-right reads as well but needs a 115° swing through the column's view).
- High Cable Curl wrist label "Wrists flat": in the mistake view the raised left hand and
  the wrist ghost reached the old 25-character pill (the ghost drawn over "Palms"), and
  "Wrists straight" would start ~3 pt from the ghost wrist; the palm directions stay in the
  cue text (palms up at the start, toward the head at the top, as wrist.py reads them).
- Overhead Cable Curl: "Arms almost straight" (the model opens to 164°, and the cue says
  almost straight), "Underhand, flat wrists" (the old pill end touched the bar's angled left
  grip at the start), "Pads on thighs" (the roller sits on the lower thighs, as the cue and
  set-up say; the shorter pill also ends clear of the far shin); pad ghost `shallow(0.18,
  withArms: false)`: the 0.1 rise (~15 pt) all but lay on the body, and at the bottom the
  arm and bar lines reached into the mistake bar.

Not changed:
- High Cable shoulder still (the shrugged ghost's right hand touches the end of "Shoulders
  down"; the text reads; "No shrugging" would send the trainer leader across the right
  handle), the Cable Hammer grip still (turned face-on, the dot is on the screen left and
  the top-right pill's leader crosses the chest; hand_L is hidden in the trainer view), the
  overhead range and pad stills' arms reaching the mistake bar in the correct-form model,
  and the hammer torso dot on the forearm at the bottom (no clear trunk joint is probed
  there). All come from the mistake view keeping each pill at its trainer row and side while
  the model is scaled, lifted and turned; that is app-level (Exercise3DView.callouts()),
  outside this family's files.
- The Cable Hammer stance label ("Knees soft"; the face-on ghost shows the feet coming
  together): a longer "Feet hip-width apart" pill would cover the calves or heels in the
  side-on trainer view, and the cue text names both.

Checks: `python3 spec_241_300_cable.py` and `python3 spec_241_300.py` print OK; the gen.py dry
run lays out all four; the integrated FaultPoses.swift with this family's table entries
replaced by the file's passes `xcrun swiftc -typecheck` (pieces unchanged). Fault moments are
unchanged (single-arm shoulder and stance still at 1.58 s, the top).

## Revision after the second in-app review (2026-09-27)

Checked against the round-two app shots (start, peak, peak2 for all four; peak and peak2 are
identical) and all 20 fault stills. None of the four was re-framed after round one (the
Cable Hammer trainer shot is pixel-identical to round one's; the other three differ only in
their pills), so no ghost `.seen()` changed. Proposed pills were drawn over the trainer
shots; the ghost changes were re-projected with the review's port of `FaultGhost.solve` and
the mistake view's staging (each current pose lands on the app's yellow ghost).

Applied:
- Single-Arm: "Shoulders down" row 0.32 -> 0.30 (squeezed 0.302). At 0.32 its left cap touched
  the tip of the free (akimbo) elbow, ~1 pt; at 0.30 it clears it by ~7 pt, still on the
  background right of the back, and its leader to `scapula_L` stays clear of the "Upper arm
  still" leader.
- Single-Arm torso ghost: new piece `bodySwungOneArm("L")`, `bodySwung(withBar: false)`'s
  moves with the spine, the working arm and the hip line drawn, and only those points moved.
  Side-on, the free arm's hand-on-hip triangle crossed the leaned spine, the working arm and
  the "Stand tall" leader, and left dashed guides around the hip.
- Cable Hammer torso ghost: `bodySwungOneArm("R")`, the near arm only (the far arm's V crossed
  the spine and the near arm).
- Cable Hammer grip label "Wrists straight" -> "Firm wrists". Turned face-on for the grip
  fault, the lone pill keeps its top-right row and the ghost's left-hand tip sat on the longer
  pill's left cap; the shorter pill starts ~25 pt further right. Not "Wrists flat": on a
  thumbs-up grip "flat" can read as palms down, which the cue says not to do. The cue text
  keeps "wrists straight".
- Cable Hammer stance label "Knees soft" (`patella_R`, row 0.64) -> "Feet hip-width"
  (`foot_R`, left, row 0.80): the face-on stance ghost shows the feet drawn together, and
  locked knees do not show face-on; the other two standing cable curls label the same fault
  by the feet. Short, so in the side-on trainer it ends ~20 pt left of the near heel and
  above the base, with a short leader to the near ankle (round one ruled out only the
  20-character "Feet hip-width apart", which would reach the heel). The cue text keeps
  "knees soft".
- High Cable shoulder ghost: the shrug (0.12 up, as `shrugged`) drawn as the girdle and upper
  arms only, and the undrawn hands not moved. With the forearms, the raised right hand sat on
  the top-left pill's cap in the mistake view.
- Overhead range ghost: `curlBottomCut`'s fold and strength drawn and moved to the wrists
  only; the bar ends sat under the mistake bar in the mistake view, and their guides ran
  across it.
- Overhead torso ghost: the 15° rock back drawn as the spine and the near (left) arm to the
  wrist, and only those points turned; side-on the far forearm crossed the near upper arm,
  and the hand tips' guides ran off the right edge.
- Overhead pad ghost: `shallow(0.18)`'s rise, knee re-seat and strength, drawn as the spine,
  hip line and legs to the ankles, and only the pelvis, hips and trunk move: `shallow` still
  moved every arm and bar point, whose guides ran up into the mistake bar, and the near foot
  line grazed the "Pads on thighs" pill.

Not changed:
- The Single-Arm "Stand tall" dot (`support_LatissimusDorsi_L`) sits on the back edge of the
  hanging forearm at the bottom, and the Cable Hammer "Torso still" dot (`spine`) inside the
  hanging near forearm; both are clear at the top, where their faults are shown. Every probed
  trunk joint lies on or beside the near arm at the bottom from these sides; a clear dot needs
  a lower-back (lumbar or erector) joint in the rig and in probe.py JOINTS.
- The Overhead grip leader runs through the near elbow at the peak (the far hand is behind
  the head). The alternatives tried (the near hand with a top-right pill; grip and range
  rows swapped) touch the cable, cover the bar in the grip still or cross the range leader.
- App-level (not content): the lone mistake pill keeping its trainer row and side, the banner
  on the standing heads and the overhead bar, dashed guides for undrawn points.

Checks: `python3 spec_241_300_cable.py` and `python3 spec_241_300.py` print OK; the gen.py dry
run lays out all four; the integrated FaultPoses.swift with this family's pieces and table
replaced by the file's passes `xcrun swiftc -typecheck`. Fault moments are unchanged.
Re-shoot: the Single-Arm torso, High Cable shoulder, Overhead range, torso and pad, Cable
Hammer grip, torso and stance stills, and the Single-Arm and Cable Hammer trainer shots.

## Sources used across the family

- Coratella et al. 2023, Sports 11(3):64 (grips): supinated > neutral biceps (+12%) and
  brachioradialis (+6%) when lifting; anterior deltoid higher with neutral and pronated.
- Coratella et al. 2023, J Funct Morphol Kinesiol 8(1):13: flexing the arms forward raised
  anterior deltoid excitation (checked in the PMC full text) and, in the lifting phase, biceps
  excitation too, so the copy says the front deltoid joins in, not that the biceps rests.
- Kleiber et al. 2015, Front Physiol 6:215; Boland et al. 2008, J Hand Surg Am 33(10):1853-9;
  Basmajian and Latif 1957, JBJS 39A(5):1106-18 (through secondary summaries).
- Signorile et al. 2017, JSCR 31(2):313-22: cable biceps curl drew more pectoralis major and
  anterior deltoid than a selectorised machine curl, biceps no different (basis for the
  anterior deltoid stabiliser; a machine, not a free-weight, comparison).
- Pinto et al. 2012, JSCR 26(8):2140-5: preacher curls in untrained men, full range (0-130°)
  against mid-range partials (50-100°): 1RM +25.7% vs +16.0%; thickness similar (the copy
  says only "more strength than mid-range partial reps").
- Nunes et al. 2020, IJERPH 17(16):5859; Attarieh et al. 2025, Eur J Sport Sci
  25(4):e12279; Larsen et al. 2026, Front Physiol 17:1750722; Parpa et al. 2025, Muscles
  4(4):45 (balance for the cable claims, above; the Bayesian curl also differs in shoulder
  position, so Parpa is balance only).
- Young, Porcari et al. 2014, ACE ProSource (not peer-reviewed): the standing cable curl was
  one of eight curls; only the concentration curl was significantly higher for the biceps. The
  %MVC figure could not be read from the PDF, so no number is used.
- NSCA Basics of Strength and Conditioning Manual (Sands, Wurth, Hewit 2012), EZ-bar curl:
  stand erect with the feet hip-width apart; elbows at the sides, no rolling the shoulders
  forward, no momentum, controlled return (read from the PDF).
- ExRx on web.archive.org captures: Cable One Arm Curl 2023-11-22 (elbow to the side; at full
  flexion the elbow can travel forward slightly; stabilisers include the anterior deltoid and
  upper trapezius), Cable Hammer Curl 2023-01-13 (a rope on one low pulley; target
  brachioradialis, synergists brachialis and biceps), Cable Curl 2024-01-05 (stand close to
  the pulley), Cable Underhand Pulldown 2020-08-04 (sit with the thighs under the supports;
  used for the pad set-up only).
- Muscle & Strength: Standing High Pulley Cable Curl (web.archive.org capture 2023-09-30:
  two high pulleys, underhand, stand in the centre, arms outstretched, upper arms and body
  fixed, do not move the elbows; target biceps, intermediate).
- StrengthLog: Overhead Cable Curl (keep the upper arms stable, bring the handle toward the
  back of the head), Hammer Curl (feet about hip-width in a stable position, brace the core to
  avoid swinging; elbows at the sides or slightly forward, forward movement loads the front
  delts; keep the grip neutral), Cable Curl (take a step back; upper arm still or slightly
  forward), all re-fetched in the revision; Dumbbell Curl (wrists straight; used by the
  191-240 curls).

---

## Single-Arm Cable Curl (yaw -1.5; re-framed from +1.1)

**Model.** Standing tall, feet ~0.3 m apart and square, knees ~174°, trunk still. The LEFT
arm works; the right hand rests on the right hip. D-handle on the bottom pulley of the column
straight ahead of the working hand, exit ~0.55 m in front of it and ~8 cm off the floor, cable
~56° below horizontal at the start and 76-78° from mid-rep to the top. Underhand: palm forward with the arm hanging, up toward the shoulder at the top; wrist
~10° back. Elbow 172° -> 56°, upper arm 2-10° off the trunk, forearm ~45° short of vertical at
the top. Stack 2-5 cm off its rest at the bottom. Seen from the working left side: the lifter
faces screen-left toward the column at the left edge, the working arm nearest the camera, the
free elbow sticking out behind the back on the right.

**Claims and sources**
- Upper arm by the side, only the forearm moves; forward drift brings the front deltoid in:
  ExRx Cable One Arm Curl (elbow to the side), NSCA, StrengthLog Hammer Curl (forward movement
  loads the front delts), Coratella 2023 JFMK; the rig agrees (the cable's shoulder moment at
  the top is extension, so bringing the elbow forward is front-deltoid work). The copy says the
  front deltoid "joins in", not that it finishes the rep. The model keeps the elbow at the side
  and stops short of vertical, so the copy says curl until the handle is in front of the
  shoulder (as the 191-240 curls). "Without swinging the elbow forward", not "without the
  elbow moving": ExRx allows slight forward travel at full flexion and StrengthLog Cable Curl
  says still or slightly forward; the model drifts 2-10°.
- Range: facing a low pulley from a step away the cable runs down and a little forward from
  the hanging hand and does not resist the start (rig numbers above), so the copy says it
  "barely resists" the first part; lower until the arm is straight (ExRx: until the arm is
  fully extended), which takes the elbow through its whole range (no "whole length" claim:
  the flexors carry no cable load there); full range builds more strength than mid-range
  partials (Pinto 2012). "The stack still just off its rest" matches the model (2-5 cm up).
  ExRx Cable Curl says stand close to the pulley, which would load the bottom; the model
  stands a step back, as StrengthLog Cable Curl allows, so the copy describes the light start.
- Shoulders down and back: NSCA (no rolling the shoulders forward); ExRx lists the anterior
  deltoid and upper trapezius as stabilisers. No mechanism is claimed. The pill says
  "Shoulders down" (short enough to clear the free elbow); the dot is on the back of the near
  shoulder (`scapula_L`) and the ghost hunches the near shoulder, the one in view.
- No leaning or hip swing, lower over 2-3 s: NSCA (no momentum), StrengthLog Hammer Curl
  (brace the core to avoid swinging), the batch's curl wording ("borrows momentum from the
  hips and lower back"); no injury claim.
- Stance: NSCA (stand erect, feet hip-width apart), StrengthLog Hammer Curl (feet about
  hip-width in a stable position); "the cable pulls down and a little forward on one side
  only, so the body does not rock toward the stack" is mechanics.
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.64 MOD > Brachioradialis 0.44 MOD,
  the same order and nearly the same values as the Alternating Dumbbell Curl; a supinated cable
  curl works the biceps about as a barbell curl does (ACE 2014, Young, Porcari et al., 70%
  1RM: only the concentration curl differed significantly). Signorile 2017 compared cable with
  selectorised machine curls: more pectoralis major and anterior deltoid on the cable, biceps
  not different (basis for the anterior deltoid stabiliser). Brachialis from anatomy (surface
  EMG cannot isolate it). Stabilisers: anterior deltoid (Signorile 2017), forearm flexors,
  obliques (one-sided pull).

**Uncertain.** No wrist cue (five cues, the arm already carries two). Labels for the left-side
view: "Upper arm still" top right on the near shoulder joint, "Shoulders down" (row 0.30,
right, ~7 pt above the free elbow's tip) on the back of the near shoulder, "Stand tall"
(row 0.48, right) on the near lat, "Lower all the way" (row 0.48, left) on the hand, "Feet
hip-width apart" (row 0.80, left) on the near ankle. The pelvis and spine joints sit on the
hanging hand and forearm at the bottom, so the torso dot is on the lat; at the bottom even
the lat dot touches the back edge of the hanging forearm (no lower-back joint is probed), and
it is clear at the top, where the torso fault is shown. The top-left row stays empty: the face is there
and the working hand rises toward it (in the mistake view, which lifts the model, up to the
top row). The foot width cannot show side-on in the trainer; the stance ghost turns to show
it. Fractions below the biceps are judgement.

**Ghosts and stills** (top = left elbow most bent, ~1.6 s; bottom = arm straightest, 0.2 s)
- elbow: `elbowsForward(35, side: "L")`, the left arm swung 35° forward with the elbow bend;
  reads as framed. **top**
- range: `curlBottomCut("L", from: 0.8, to: 0.89)`, the left forearm folded 45° where the arm
  should be straight (shoulder-to-wrist 0.906 torso lengths at 172°). **bottom**
- shoulder: `hunched("L")`, the near shoulder 0.07 forward and 0.1 up (~20 pt toward the
  pulley and up), the working arm carried; the free arm is not drawn (side-on its ghost
  crossed the trunk). **any**
- torso: `bodySwungOneArm("L")` (new): `bodySwung(withBar: false)`'s moves, hips 0.06 ahead,
  trunk and working arm 15° back, drawn as the spine, the working arm and the hip line, and
  only those points move; side-on as framed, so the lean lies in the picture plane (the head
  ~49 pt back). The free arm is not drawn or moved: side-on its hand-on-hip triangle crossed
  the spine, the working arm and the "Stand tall" leader. The old `.seen(0.45)` gave total
  -1.05 at the new yaw, where the column and stack hide the lifter. **top**
- stance: `cableFeetTogetherLocked.seen(-1.1)`, ankles ~6 cm apart against the model's 30,
  knees locked, turned to the back-left (total -2.6): the real ankles ~70 pt apart, the
  ghost's ~15; the near (left) ankle, which carries the dot, is on the pill's side. The turn
  swings away from the column (the equipment raster shows no joint covered at -2.6); total
  +0.5 reads as well but needs a 115° swing through the column's view. **any**

## High Cable Curl (yaw -0.3)

**Model.** Standing tall between the columns of a cable crossover, feet ~0.3 m apart. Pulleys
at ~1.38 m, just below shoulder height (1.43 m) and ~5 cm behind the shoulders: the cables run
out and a little down. D-handles, underhand (palms up with the arms out, toward the head at
the top). Upper arms held level (~91° elevation, 7-18° forward of straight out) and still;
elbows 168° -> 68° together, the hands coming in beside the head. No shrug, no lean. Both
stacks ~5 cm off their rests with the arms out.

**Claims and sources**
- Upper arms level and still, only the forearms move; curl the handles in toward the head;
  stand centred; keep the body fixed; lower slowly: Muscle & Strength. "The cables tip the
  upper arms down; if the elbows sink the handles drift back toward the pulleys and each curl
  gets shorter" is read off the rig: the cables' shoulder moment is adduction all rep
  (0.18-0.37 per unit tension), and with the upper arm 20° below level at the top each hand
  ends ~10 cm closer to its pulley. The earlier "the shoulders help move the handles" was
  dropped: at shoulder-height pulleys sinking elbows give way to the cables.
- Shoulders down: NSCA-style shoulder cue; with the arms held at shoulder height hiking the
  shoulders is easy (mechanics, no study).
- Palms up is the biceps' strongest position (Coratella 2023 Sports); curling the wrists in
  puts needless load on them (StrengthLog Dumbbell Curl). The palms face up with the arms out
  and turn toward the head at the top (wrist.py), so the cue text says both and the label
  says only "Wrists flat" (short, so the pill clears the raised hand and the wrist ghost in
  the mistake view).
- Range: the start is lighter than the middle with the pulleys at shoulder height (rig
  numbers); straightening the arms takes the elbows through their whole range; full range
  builds more strength than mid-range partials (Pinto 2012). The label says "Almost
  straight" (the model opens to 168°, and the cue says almost straight).
- Stance: M&S (stand in the centre, keep the body fixed), NSCA and StrengthLog Hammer Curl
  (feet hip-width); "neither arm is drawn further out than the other" is mechanics. The
  mistake's "body swaying" is mechanics too: the two cables pull out to opposite sides almost
  symmetrically, so the net sideways pull is small.
- Activation: Biceps Brachii 0.82 HI, Brachialis 0.62 MOD, Brachioradialis 0.42 MOD —
  the whole row extrapolated from the standing single-arm cable curl (same palms-up grip) and
  lowered slightly because no study of this exercise was found. Holding the shoulder at 90°
  of abduction has no known effect on the brachioradialis, so it stays MODERATE (the
  preacher family's 0.38 rests on ACE 2014 for preacher curls and does not carry over).
  Stabilisers: deltoids (hold the arms at shoulder height against gravity and the cables'
  downward pull), rotator cuff, forearm flexors, core.

**Uncertain.** Evidence is thin: no study of this curl. No torso cue: the arms fill the
frame at rows 0.24-0.33, and a leader from the lower rows to the trunk would cross a thigh,
so the stance cue at the foot carries "keep the body still". Library name: the pulleys in the
model sit at 1.37-1.45 m, about level with the 1.43 m shoulders, not above the head as M&S
describes ("two high pulley cable attachments"); the setup says "about shoulder height". For
the lead: keep the name with this setup, or re-export 244 with the pulleys at about head
height (~1.8 m) and then re-check the upper-arm and range whys, which rest on shoulder-height
pulleys.

**Ghosts and stills** (the whole family's faults move in the plane the camera sees here)
- upperarm: `armsTurned(.forward, -20, strength: .withBend("forearm_L"))`, the upper arms
  sinking 20° below level as the hands come in, giving way to the cables. **top**
- shoulder: the shoulders and upper arms 0.12 up (as `shrugged`), drawn as the girdle and
  upper arms only and the hands not moved: with the forearms, the raised right hand sat on the
  top-left "Shoulders down" pill in the mistake view. **any**
- wrist: new `armsOutWristsCurled`, each hand folded 50° toward the palm about the chest's
  axis, with the elbow bend. **top**
- range: `elbowsFolded(.forward, 45, strength: .between("upper_arm_L", "hand_L", from: 0.8,
  to: 0.885))`, the forearms folded toward the head where the arms should be almost straight
  (0.903 torso lengths at 168°). **bottom**
- stance: `cableFeetTogetherLocked`, ankles ~6 cm apart, knees locked. **any**

## Overhead Cable Curl (yaw -1.3)

**Model.** Seated at a lat-pulldown station, thighs under the rollers (knees ~92°), feet flat,
trunk upright. Lat bar (ends angled down) on the high pulley, underhand on its straight
middle, hands ~0.48 m apart; palms face
back toward the head with the arms up, down at the top. Upper arms held at ~160° (~20° in
front of vertical) and still; elbows 164° -> 73°. The bar starts ~0.5 m above the shoulders,
just in front of the head, and finishes just behind the head, ~27 cm above and ~16 cm behind
the shoulders. Pulley ~1.07 m above and ~0.24 m in front of the shoulders. Seen from the left,
facing left; the far (right) arm is the one toward the open left of the frame, so the arm
cues point at it.

**Model issue.** The stack sits on its rest from the start until the bar is ~0.7 m from the
pulley (elbows ~105-110°; plate 14 still at 0.84 m at 1.0 s, rising from 1.1 s) and sets down
again at the same point on the way back (by ~2.6-3.0 s), so the cable is slack for the first
half of each curl in the model. The copy therefore does not ask the lifter to keep the
weights off the rest; a re-export with the cable shortened by ~0.25 m (stack just off its
rest with the arms straight) would let the range cue say so, as the other three do.

**Claims and sources**
- Upper arms raised and still, bend only at the elbows, bring the bar toward the back of the
  head: StrengthLog Overhead Cable Curl (keep your upper arms stable). "The cable pulls the
  raised arms down in front, so the front of the shoulders holds them up; if the elbows drop
  forward the bar moves toward the pulley and each curl gets shorter" is read off the rig:
  the cable's shoulder moment is ~0 at the start and extension from ~150° of elbow bend to
  the top (0.16-0.29 m per unit tension at the hands), and with the arms swung 30° forward at
  the top the hands end ~10 cm closer to the pulley. The first draft called this fault a
  pulldown with the lats pulling the bar down (citing ExRx Cable Underhand Pulldown); that was
  backwards for this geometry, since the lats extend the shoulder, the same way the cable
  already pulls, and the ExRx page describes a different set-up. The badge is now ELBOWS
  DROPPING.
- Range: the start is light because the cable runs almost along the straight arms (rig
  numbers; in the model it is not loaded at all there, see above); straightening the arms
  keeps the full range at the elbow (no "whole length" claim: with the shoulder flexed ~160°
  the biceps is shortened across the shoulder); full range builds more strength than
  mid-range partials (Pinto). The mistake no longer says "the bar never rising above the
  head": in the model the bar stays 0.27-0.52 m above the shoulders, above the head all rep.
- Grip: underhand, shoulder-width (StrengthLog: underhand grip); wrists straight (StrengthLog
  Dumbbell Curl). Label "Underhand, flat wrists", short enough to end clear of the bar's
  angled left grip at the start. The range label is "Arms almost straight" (the model opens
  to 164°, and the cue says almost straight).
- Torso: rocking back to drag the bar down, as a swung pulldown; mechanics, no study. Here the
  body does lift the stack: rocking the trunk back 15° moves the hands ~0.15-0.2 m away from the
  pulley.
- Pads: sit with the thighs under the supports (ExRx Cable Underhand Pulldown, 2020 capture)
  and stability; no study. The why says only that snug pads fix the hips so the body cannot
  rise to follow the bar or rock back to help it down. The first draft's "the cable pulls the
  body up" was dropped: curl loads are a fraction of body weight, and in the model the cable
  is slack at the bottom, where the pad ghost is shown. Rising off the seat is a movement the
  lifter makes. The label is "Pads on thighs": the roller sits on the lower thighs, just above
  the knees, as the cue and set-up say (the dot is on the knee, the probed point nearest it).
- Activation: Biceps Brachii 0.80 HI, Brachialis 0.62 MOD, Brachioradialis 0.42 MOD —
  extrapolated from the standing cable curl (same palms-up grip) and lowered slightly; no EMG
  study found. Stabilisers: anterior deltoid (holds the raised arms against the cable's
  extension moment, above), rotator cuff, forearm flexors, core.

**Uncertain.** Evidence is thin. The shoulder is flexed ~160°, which shortens the biceps'
long head at the shoulder; the copy makes no length or growth claim (Attarieh 2025 and
Larsen 2026 found shoulder angle alone made no clear difference to growth, at smaller angles).

**Ghosts and stills**
- upperarm: `armsTurned(.lateral, -30, withBar: true, strength: .withBend("forearm_L"))`,
  the arms swinging 30° down and forward as the elbows bend, giving way to the cable; the bar
  ends over the head instead of behind it. **top**
- range: `curlBottomCut(from: 0.8, to: 0.885)`'s fold and strength, the forearms folded 45°
  back where the arms should be almost straight overhead (0.899 torso lengths at 164°), drawn
  and moved to the wrists only: in the mistake view the bar ends sit under the mistake bar,
  and their guides ran across it. **bottom**
- grip: `curlWristsCurled(withBar: true)`: the palms face back with the arms up and down at
  the top, so the fold about `.lateral` curls toward the palm. **top**
- torso: `curlSeatedSwungBack(15)`'s turn and strength, trunk and arms rocked 15° back from
  the hips with the elbow bend (the model sits upright, so the ghost ends 15° behind
  vertical), drawn as the spine and the near (left) arm to the wrist, and only those points
  turn: side-on the far forearm crossed the near upper arm, and the hand tips' guides ran off
  the right edge. **top**
- pad: `shallow(0.18)`'s rise, knee re-seat and strength, the hips and trunk ~10 cm (~25 pt)
  up off the seat, the knees opening from 92° to ~110° over the planted feet; the knee-bend
  strength is full at 92°. Drawn as the spine, the hip line and the legs to the ankles (as
  `preacherSatLow`; the feet stay planted), and only the pelvis, hips and trunk move: with
  `shallow` every arm and bar point moved, and their guides ran up into the mistake bar, and
  the near foot line grazed the "Pads on thighs" pill. At 0.1 (~15 pt) the ghost all but lay
  on the body. **bottom** (arms straight, when the body rises to follow the bar)

## Cable Hammer Curl (yaw +1.4)

**Model.** Standing tall, feet ~0.3 m apart, centred between two low pulleys ~0.7 m either
side of the midline and ~0.6 m ahead, so each cable runs forward, down and out. D-handles,
neutral grip (palms facing, thumbs up) for the whole rep; wrists 4-9° back. Both arms curl
together, the same path as the single-arm model (elbows 172° -> 56°, upper arms 2-10° off the
trunk). Both stacks 2-5 cm off their rests at the bottom. Seen from the right side: the right
arm nearest; the left hand is hidden behind the right at the bottom.

**Claims and sources**
- Upper arms by the sides, forward drift brings the front deltoids in ("join in", not
  "finish the rep"): ExRx Cable Hammer Curl (elbows to the sides; slight forward travel at
  full flexion is allowed, hence "without swinging the elbows forward"), StrengthLog Hammer
  Curl (forward movement loads the front delts), Coratella 2023 JFMK. ExRx's page uses a rope
  on one low pulley; the model's two wide low pulleys with a D-handle each are a common
  variant, not the ExRx set-up.
- Range: as the single-arm curl (rig numbers, Pinto 2012; ExRx: lower to full extension). The
  cables run down, forward and out from the hanging hands (~44° below horizontal at the
  start) and do not resist the start (share -0.45) down to ~150°, so the copy says they
  "barely resist" the first part and makes no "whole length" claim.
- Grip: the neutral grip defines the hammer curl; the brachialis (Basmajian and Latif 1957)
  and brachioradialis (Boland 2008) flex the elbow in any grip; the biceps works a little less
  than palms up (Coratella 2023 Sports, -12%; Kleiber 2015 found no significant change in slow
  unloaded flexions, hence "a little"). Keep the grip neutral, do not twist the palms up
  (StrengthLog). "The wide pulleys pull the hands down and outward" is read off the rig
  (each pulley ~0.44 m outside and ~0.56 m ahead of its hand at the start; the cable is
  69% down, 58% forward and 43% out at the start, ~90% down and ~30% out at the top).
- Torso and stance: as the single-arm curl (NSCA, StrengthLog Hammer Curl; the rocking toward
  the stacks is mechanics). No injury claim in the torso why ("borrows momentum from the hips
  and lower back").
- Activation: Brachialis 0.76 HI (primary; works in every grip, Basmajian and Latif 1957;
  cannot be measured with surface EMG), Biceps Brachii 0.74 HI (primary; the supinated 0.84
  less ~12%, Coratella 2023 Sports), Brachioradialis 0.42 MOD (the palms-up 0.44 less ~6%,
  Coratella 2023 Sports; Boland and Kleiber found no difference). The brachialis-over-biceps
  order is inference: it matches the library primary (BRACHIALIS), StrengthLog Hammer Curl
  (hammer curls emphasise the brachialis and brachioradialis more than regular curls) and the
  other two hammer curls in the batch (Alternating Hammer Curl 0.76 / 0.74, Preacher Hammer
  Curl 0.76 / 0.72); no EMG can rank it against the biceps. The copy does not repeat the
  common claim that hammer curls single out the brachioradialis. Stabilisers: anterior
  deltoid (Coratella 2023 Sports, higher with a neutral grip; Signorile 2017; ExRx), forearm
  flexors, core.

**Uncertain.** No EMG can rank the brachialis against the biceps; the order follows the batch
convention (above). ExRx makes the brachioradialis the target; StrengthLog names the biceps
and brachialis as primary. The torso dot (spine) lies behind the hanging right forearm at the
bottom and is in view at the top; the spine, chest and pelvis are all behind the near arm or
hand at the bottom from this side (a lower-back joint would be needed for a clear dot there).
The grip dot is on the near (right) hand, in view all clip
(the left hand is hidden behind the near hip at the bottom); the label is "Firm wrists",
short so that, turned face-on for its fault, the pill's left cap clears the ghost's left-hand
tip ("flat" could read as palms down on a thumbs-up grip). The stance label is "Feet
hip-width" on the near ankle (bottom row, left), what the face-on stance ghost shows; the cue
text keeps "knees soft", which does not show face-on. No shoulder cue: its joint would
sit on top of the upper-arm dot. Face-on (the grip and stance ghosts) a low part of the base
in front of the lifter covers the feet below the ankles; the shins, knees and hands show.

**Ghosts and stills**
- elbow: `elbowsForward(35)`, both arms swung 35° forward with the elbow bend. **top**
- range: `curlBottomCut(from: 0.8, to: 0.89)`, both forearms folded 45° at the bottom.
  **bottom**
- grip: new `hammerWristsBentBack.seen(-1.4)`, each hand turned 45° outward about the body's
  up axis (wrist extension for a thumbs-up grip) with the elbow bend, turned face-on (total 0;
  at +0.4 the right stack column hides the right arm) so the sideways bend shows; face-on the
  forearms point at the camera and both tips move ~17 pt outward, beside the handles. The turn about `.up` never bends the wrist the wrong
  way: a hanging hand is left alone, and the forward-pointing part of the hand always swings
  outward (a turn about `.forward` would flip direction once the forearm passes level).
  **top**
- torso: `bodySwungOneArm("R")` (new, shared with the single-arm curl), hips 0.06 ahead, trunk
  and near arm 15° back; side-on as framed. Drawn with the near (right) arm only, and only the
  drawn points move: the far arm's ghost made a second V across the spine and the near arm.
  **top**
- stance: `cableFeetTogetherLocked.seen(-1.4)`, ankles ~6 cm apart, knees locked, turned
  face-on (total 0); the "Feet hip-width" dot is on the real right ankle, and the pill's
  leader passes a few points left of that foot's toe guide. **any**

Note for integration: the drag/spider family's `hammerWristBent` (Alternating Hammer Curl) is
a one-sided fold toward the palm (+55° about `.up`, left arm only). `hammerWristsBentBack` is
the opposite bend on both arms, chosen because the model's wide pulleys pull the hands
outward; the two can stay separate.

## Fault moments (for fault_times.py)

```json
{
 "Single-Arm Cable Curl": {"elbow": "top", "range": "bottom", "shoulder": "any", "torso": "top", "stance": "any"},
 "High Cable Curl": {"upperarm": "top", "shoulder": "any", "wrist": "top", "range": "bottom", "stance": "any"},
 "Overhead Cable Curl": {"upperarm": "top", "range": "bottom", "grip": "top", "torso": "top", "pad": "bottom"},
 "Cable Hammer Curl": {"elbow": "top", "range": "bottom", "grip": "top", "torso": "top", "stance": "any"}
}
```
