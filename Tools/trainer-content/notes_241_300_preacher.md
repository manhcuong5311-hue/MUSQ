# Batch 241-300: preacher-style and machine curls (2026-09-27)

Content: `spec_241_300_preacher.py`. Ghosts: `Tools/fault-review/faults_241_300_preacher.swift.txt`.
Five exercises from SourceExports/241-300: 241 Single-Arm Machine Curl, 242 Cable Preacher
Curl, 250 Preacher Hammer Curl, 260 Reverse Preacher Curl, 263 Barbell Preacher Curl.

How the models were read: the briefs and the framing shots (start, peak), then the rig and the
equipment prims straight from the USD with Blender's Python + pxr: joint angles, the world
angles of the upper arm and forearm, the hand joint's frame (its +z is the palm, its +y runs
along the hand toward the fingers), the lever, pivot hubs and stack of the curl machine, and
the cable bar's swivel, the pulley wheel and the moving plates of the cable station. The
skeleton space of these stages is Y-up with the lifter facing +z (`arm_motion.py` reads it
that way). `wrist.py` labels the palm as if it were Z-up, so in every brief of the batch its
"backward" means up, "down" means backward, "forward" means down and "up" means forward (its
wrist-flex numbers are frame-free and correct). Read that way the grips are: machine, cable and
barbell underhand; hammer thumb-up; reverse overhand. The shots agree.

## Checks run

- `python3 spec_241_300_preacher.py` prints OK.
- gen.py dry run (the command in the brief): every entry lays out 5 annotations, all pinned
  with `overrides`. The layouts, squeezed into 0.16-0.80 as `spec_241_300.py` does, were
  drawn over the start and peak shots with the app's pill size (12 pt semibold, 12/7 padding)
  and leader rule (label edge to joint): no leader crosses the head, no pill covers a tracked
  dot or a glow in either shot, and in the cable and hammer curls no pill covers the moving
  bar or dumbbell at the bottom (rows moved: cable grip 0.44 to 0.56 and range to 0.68 on the
  left, cable torso label shortened to "Chest on the pad" so the range leader clears it;
  hammer range 0.50 to 0.62). Revision: the machine and cable pad labels lost "flat" ("Arm on
  the pad", "Arms on the pad"), which moves the machine pill clear of the back of the head
  (left edge 0.697 against the head's ~0.68) and the cable pill's right edge to 0.318 (head
  from ~0.323). (Both were shortened again in revision 2, below.)
- Ghosts: the PIECES and TABLE sections were pasted into a scratch copy of
  FaultPoses.swift (pieces before `// MARK: Legs 300-350 pieces`, table before
  `// MARK: Legs 300-350 (2026-09-26)`); `xcrun swiftc -typecheck` passed, and a scratch
  build printed all 25 faults resolving from `FaultPoses.fault(exercise:cue:)` (the table
  literal builds, so no duplicate keys). No project build, no simulator.
- The three new pieces were run through a Python port of `FaultGhost.solve` on the real joint
  transforms (numbers below).
- Revision 2 (after the app screenshots; the Barbell Preacher Curl re-framed to yaw -0.8, zoom
  0.602, joints.json re-probed): every layout was drawn again over the start, peak and peak2
  shots with the app's pill size and leader rule, and every changed ghost was re-rendered with
  the Python port of `FaultGhost.solve`, mapped into the fault-mode view (the model scaled by
  0.935 and lifted 0.091 of the view, from `roomBelow: 0.26`) with its cue's pill drawn in. The
  pieces and table were pasted into a scratch copy of FaultPoses.swift: `swiftc -typecheck`
  passed and a scratch build resolved all 25 faults. Changes: the two-arm pad cue's title is
  "Arms on the Pad" (it read "Arm on the Pad" on the banner of three two-arm lifts); the pad
  labels of the machine, cable, hammer and reverse curls are shorter ("Arm on pad", "Arms on
  pad") so their pills end clear of the turned ghost's shoulder, which starts the lifted arm;
  the machine, hammer and reverse torso labels moved below the rocked-back ghost's pelvis; the
  torso ghosts use `preacherRockedBack`, which moves only the joints it draws (the shared
  `curlSeatedSwungBack` moved both arms and the hand tips too, leaving dashed guides from the
  resting arm and the bar to points with no line).
- Revision 3 (after the round-two app screenshots; the Reverse Preacher Curl re-framed to yaw
  -0.8, zoom 1.0, offset (-0.02, 0.123, 0.02), joints.json re-probed). The Reverse was laid out
  again: the new pills and leaders were drawn over the start and peak shots, and the bar and
  plates were projected over the whole clip (0-3.2 s) at the new framing, measuring their
  clearance to each pill. Its ghost views were re-set for -0.8, checked on offline renders
  (the Python port of `FaultGhost.solve`, the mistake-mode scale and lift, each cue's pill).
  The changed Barbell, Machine and Reverse ghosts were rendered the same way. The pieces and
  table were spliced into a scratch copy of FaultPoses.swift, which built with
  `swiftc -typecheck` and a scratch build that resolved all 25 faults. `python3
  spec_241_300_preacher.py` and `python3 spec_241_300.py` print OK, and the gen.py dry run
  lays out all five entries. Changes: Reverse pad row 0.34, range "Almost straight" on the far
  elbow, torso "No rocking back" on the left hip, pad ghost at the framing's own view; Machine
  torso label "Chest against the pad", pivot ghost legs drawn to the ankles; Barbell grip ghost
  without the bar line, torso ghost with only the far arm, seat ghost sunk 0.28
  (`preacherSatLower`). Not yet seen in the app: re-shoot the Reverse trainer shots and all
  five Reverse stills, the Machine trainer shots and pivot and torso stills, and the Barbell
  grip, torso and seat stills.
- Revision 4 (after the round-three app screenshots): the Reverse torso ghost draws only the
  far (right) arm, as the Barbell's: at -1.2 the two lifted upper arms fell on one line through
  the spine. Checked on an offline render (both arms, near arm only, far arm only). Not yet seen
  in the app: re-shoot reverse-preacher-curl--torso.

---

## Single-Arm Machine Curl (241, yaw -1.0)

**Model.** The plate-stack, preacher-style curl machine of the Machine Biceps Curl
(`Q191_CurlMachine`). Seated, knees ~111°, hips ~101°, feet flat ~0.38 m apart, trunk 12°
forward, chest to the pad. The upper arms sit 55° below horizontal (35° off vertical), resting
on a short arm pad (0.126 m along its slope, top ~39°) just above the elbows: the arm bone is
11.8 cm above the pad plane at the shoulder and 3.8 cm at the elbow, as on the Machine Biceps
Curl model (pad 36.8°, arm 54.9°). Only the LEFT arm works: underhand on the lever's straight
two-grip handle, the
hand straight in front of the left shoulder; elbow 162° to 62° (forearm 37° below horizontal
to 62° above), two reps. The left elbow sits level with the lever's side pivot (elbow 0.907 m
up, hub centre 0.905 m, within 0.5 cm fore-aft). The whole lever turns; the stack rises
~25 cm and hangs ~7 cm above the tower base at the bottom. The right upper arm rests on the
pad, elbow ~102°, the empty fist ~23° above horizontal, palm in, in the path of the lever's
right grip (`Q191_CurlMachine_Handle__1`, x -0.30 to -0.10), which passes through it at ~1.0 s
and ~2.7 s (the grip's axis comes within 0.5-1.4 cm of the right thumb and ring-finger joints;
model defect, see Library recommendations). Left wrist ~10° extended, fingers closed round the
handle. Left arm on the right of the frame.

**Claims and sources**
- Seat set so the elbow lines up with the pivot, back of the arm on the pad, armpit near its
  top, lower until the arm is (almost) extended: ExRx Lever Preacher Curl (plate loaded)
  (LVPreacherCurlH, the builder's reference, read on a Wayback snapshot: align the elbows near
  the lever's fulcrum; if no resistance is felt early in the rep, set the seat so the back of
  the arm lies flush on the pad); StrengthLog Machine Biceps Curl (elbows in line with the
  machine's joint, stop just before the weights hit the stack, which is what the model does).
- With the elbow on the lever's axis the handle travels the forearm's arc; seat too low puts
  the elbow under the pivot so handle and forearm travel different arcs and the handle drags
  along the hand: geometry of a lever turning about its hub (as for the Machine Biceps Curl).
- The pad fixes the upper arm so the shoulder cannot help: StrengthLog, The 13 Best Machine
  Exercises (the machine curl locks the upper arm in place and makes it almost impossible to
  use the shoulders or swing the back); ExRx (the back of the upper arm should remain on the
  pad); Coratella 2023 JFMK (flexing the arms forward raised anterior deltoid excitation).
  ACE/Young 2014 found less anterior deltoid than the barbell curl only for the incline curl,
  concentration curl and chin-up, not the preacher curl, so it is not cited for this.
- Bottom-range training on preacher-style curls built more strength and at least as much
  muscle: Pedrosa 2023, Sato 2021 (both dumbbell preacher curls; the machine puts the arm in
  the same position; neither used a machine).
- Palm up, the biceps does more of the lifting than with other grips: Coratella 2023 Sports
  (+12% vs neutral, +19% vs pronated, lifting phase, trained lifters). Bent wrists take
  needless load: StrengthLog. Curling the wrist moves the handle with the wrist: geometry.
- Rocking back lets the body start the lift: NSCA Basics manual (no momentum), StrengthLog
  (body still). StrengthLog's machine-curl line (almost impossible to swing the back) means
  rocking back is uncommon on this machine: the torso cue is valid but not an evidenced common
  mistake. The copy makes no claim about where the machine is hardest (its cam is not known).
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.66 MOD > Brachioradialis 0.38 LOW, as the
  Machine Biceps Curl. No EMG study of a selectorised one-arm curl machine was found; ranked
  like the preacher curl (ACE: the preacher and incline curls had less brachioradialis than
  the narrow EZ curl; Oliveira 2009). ExRx's Lever Preacher Curl lists the brachialis as target
  and the biceps and brachioradialis as synergists, with no data.
- Comparison: SEAT SET TOO LOW (the machine-specific set-up point, ExRx).

**Uncertain.** Activation shares (no direct study). Whether one-arm work changes activity
against the two-arm machine was not looked into; the copy makes no claim about it. The
direction of the seat fault (too low puts the elbow below the pivot) follows the Machine Biceps
Curl; no source states it (ExRx says only that a badly set seat leaves the arm off the pad and
the start of the rep unloaded). On this rig the ghost elbow ends ~5 cm inside the arm pad (the
real elbow joint sits 3.8 cm above its top).

**Labels and glows.** Right: pad (0.14, "Arm on pad") on the left shoulder, clear of the head
and, in the turned pad still, of the ghost's shoulder (pill from 0.756, the shoulder at ~0.70);
torso (0.49, "Chest against the pad") on the chest joint, which from this view lands where the
chest meets the arm pad, at the lever's post, seen from behind the pad (the chest, spine and
pelvis all project onto the machine's front post here; the visible chest is left of the working
arm, and a leader to it from the right would cross the working elbow, one from the top-left
would meet the grip leader at the hand). The label says "against", as the cue does, so the dot
on the pad reads as the contact; the pill (from 0.594, px 190-306) ends ~16 px right of the
range leader and ~9 px above the seat dot. The row sits ~22 pt below the rocked-back ghost's
pelvis in the torso still. Pivot (0.68,
"Seat set, elbow at pivot") on the right hip (thigh_R, just left of the post; the pelvis dot
sat on the post), naming what the seat lines up. Left: grip (0.14) on the working hand, range
(0.56) on the working elbow. Glows: the left biceps (A) and the left elbow (soft); the resting
right arm has none. (The app tints both arms' muscles, since the muscle tint has no side; an
app-level follow-up.)

**Ghosts and stills**
- pad: `curlArmsOffPad(25, side: "L")`, with the elbow bend; top.
- range: `elbowsFolded(.lateral, 30, side: "L", strength: .between("upper_arm_L", "hand_L",
  from: 0.8, to: 0.885))` (0.897 torso lengths at 162°); bottom. A 30° fold (ghost elbow
  ~132°, the forearm about level) instead of `curlBottomCut`'s 45°: from the side the 45° ghost
  forearm lay along the resting right forearm (raised ~23°) and read as the free arm
  highlighted; no view from -1.0 to -1.5 separates them, the 30° fold sits clearly below it.
  Near the elbow the ghost line still runs along the free forearm's lower edge for ~100
  display px. A turn of only -0.2 (total -1.2) was tried offline: the free elbow still projects
  next to the working elbow, and the lever tube then runs just under the ghost line, so the
  view stays -0.5.
- grip: `curlWristsCurled("L")`; top.
- torso: `preacherRockedBack(22, side: "L")` (new); top.
- pivot: `leftCurlMachineSatLow` (new): body and left shoulder 0.1 torso lengths lower, hand on
  the handle, left elbow and knees re-seated (the resting right shoulder is not drawn, so it no
  longer moves). On the rig the ghost elbow sits 8 cm below the hub and 4 cm behind it at the
  bottom (1.8 cm below, 4.6 cm in front at the top); any, read at the bottom. The legs are
  drawn to the ankles only, as `preacherSatLow`: the toes never move, and the near foot sits
  behind the machine's front base rail, where the ankle-to-toe line was drawn on the rail.
All `.seen(-0.5)` (total -1.5, true left side, where the pivot hub shows).

## Cable Preacher Curl (242, yaw +1.1)

**Model.** A preacher bench set square in front of a dual cable station. Its pad top slopes
only ~30° (the top rises 0.12 m from front to back edge, against 0.22 m on the Dumbbell
Preacher Curl's ~45° pad, which lies parallel to the arm), flatter than the upper arms, which
sit 44-46° below horizontal and touch it near the elbows (bone 12 cm above the pad plane at the
shoulder, 5 cm at the elbow). Seated, knees ~124°, hips ~110°, feet flat, trunk 12° forward,
chest to the pad, armpits at the top edge. A straight cable bar underhand, hands ~0.47 m apart
(about shoulder-width). The cable runs from a swivel under the middle of the bar down and
forward to the station's low pulley, ~0.9 m in front of the elbows at floor level, 56-64°
below horizontal. Both arms curl together, elbows 164° to 63° (forearms 28° below horizontal
to 73° above; the bar about chin height at the top), two reps; the selected plates rise
~0.5 m. Wrists 11-15° extended. Framed from the front-right: the right arm is the near one,
on the left of the screen; the cable station stands in front of the lifter, out of frame to
the right, and only its base and the cable (running off to the lower right) show.

The resistance profile was computed from the rig (the cable's direction from its own mesh,
`GYM_Cable_R_CableToHandle`, its line through `GYM2_CableStraightBar_CableMount`, turning effect
about the elbows): ~0.5 of peak at the bottom (elbows 164°), peak with the elbows at ~100-120°,
~0.73 of peak at the top (63°). A free weight hanging from the hands on the same bench would be
~0.9 at the bottom, peak with the forearms level, and ~0.3 at the top (~0.35 measured at the
palm). (The first pass took the cable from the right handle anchor to the wheel and got 0.69,
0.8, 0.93 and 0.4; the cable-mesh figures replace them. The copy's claim, heavy to the top
where a barbell goes light, holds either way.)

**Claims and sources**
- Set-up (preacher bench, backs of the arms on the pad, shoulder-width underhand grip on a
  cable bar, raise toward the shoulders, lower until the arms are extended, the plates in use
  should not touch the rest of the stack at the bottom): ExRx Cable Preacher Curl (the
  builder's reference, read on a Wayback snapshot). The set-up step puts the bench about a
  metre from the low pulley, as in the model (pulley ~0.9 m in front of the elbows), because
  the top-heavy profile depends on the pulley sitting low and well in front.
- The pull stays heavy to the top where a barbell on the same bench goes light: the rig
  computation above; Nunes 2020 describes the same contrast (cable preacher: more torque with
  the elbows flexed; barbell: more with them extended). The copy stops at mechanics: Nunes
  found similar growth either way (7% vs 8%) and more strength at 20° only for the barbell, so
  no claim that the cable builds more muscle.
- Full range builds more strength: Pinto 2012 (0-130° vs 50-100°, 1RM +25.7% vs +16.0%).
  The bottom-half training results (Pedrosa, Sato) are not used here, because the cable's
  bottom is its lightest part.
- Curling toward the shoulders: ExRx Cable Preacher Curl (raise the cable bar toward the
  shoulders; lower until the arms are fully extended; the plates should not touch down). No
  technique source lists stopping short at the top as a common error; the cue is chosen because
  the low cable keeps the top of the curl loaded (rig profile, Nunes 2020), and the copy claims
  only the mechanics.
- Grip, wrists, pad and torso: as the machine curl (Coratella 2023 Sports; StrengthLog;
  StrengthLog's machine-curl line and ExRx for the pad; Coratella 2023 JFMK). The torso cue
  says the elbow flexors skip part of the work, not the hardest part, since on this cable the
  bottom is not the hardest part.
- Range why: lowering until the arms are almost straight works the elbow flexors through
  nearly their whole range (the model stops at 164°, not fully straight).
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.66 MOD > Brachioradialis 0.38 LOW. No EMG
  study of the cable preacher curl was found; ranked like the preacher curls (ACE) with a
  supinated grip (Coratella 2023 Sports, whose curls were on a cable). ExRx lists the
  brachialis as target and the biceps and brachioradialis as synergists, with no data.
- Comparison: STOPPING SHORT AT THE TOP (what sets the cable version apart).

**Uncertain.** The loading profile depends on where the pulley sits relative to the bench; the
copy describes the model's set-up (low pulley in front). Activation shares have no direct
study.

**Labels and glows.** Left: pad (0.14, "Arms on pad", ending at 0.259, ~19 px clear of the back
of the head in the trainer and ~22 pt clear of the ghost's near shoulder in the pad still) on the
near (right) shoulder, torso (0.50) on the chest, range (0.68) on the near elbow, its leader
rising past the chest label.
Right: top (0.14) on
the far (left) hand, which leads the bar at the top; grip (0.56) on the near hand, below the
bar's lowest point. Glows: the near biceps (A), the near elbow (soft), the far biceps (soft);
each sits on the model's red biceps in the shots.

**Ghosts and stills**
- pad: `curlArmsOffPad(25)`; top.
- range: `curlBottomCut(from: 0.8, to: 0.885)` (0.899 torso lengths at 164°); bottom.
- top: `curlStoppedShortOfTop(from: 0.64, to: 0.5)` (new): the forearms unfold 40° about the
  elbows over the last part of the curl, drawn to the wrists (the hand tips reached up into
  the "Curl all the way up" pill). On the rig the ghost elbows sit at ~95° when the real ones
  reach 81° and at ~102° at the top (63°); nothing shows below 90°. Top.
- grip: `curlWristsCurled("R")`, the near hand only: from the true side the two arms line up,
  and with both hands and the bar the near hand's fold crossed the far forearm into a zig-zag;
  top.
- torso: `preacherRockedBack(22)` (new; the trunk sits 12° forward, as the piece assumes); top.
All `.seen(0.4)` (total +1.5, a true right side view).

## Preacher Hammer Curl (250, yaw -1.1)

**Model.** The body of the Dumbbell Preacher Curl on a preacher bench whose pad top slopes
~30° (the Dumbbell Preacher Curl's is ~45°): seated, knees ~124°, hips ~110°, feet flat, trunk
12° forward, chest to the pad, the LEFT upper arm 45° below horizontal over the pad, touching it
near the elbow (bone 11 cm above the pad plane at the shoulder, 4 cm at the elbow), armpit at
the top edge. One dumbbell in the left hand, thumb up and palm facing in
for the whole clip (palm normal along the lifter's right); elbow 162° to 62° (forearm 27°
below horizontal to 72° above), two reps. Wrist 4-8° extended. The right arm is empty: its
elbow sits just past the pad's right edge and the forearm passes through the pad's front
corner, the fist hanging below it (elbow ~104°, wrist bent ~45°; static all clip; model
defect, see Library recommendations). Left arm on the right of the frame.

**Claims and sources**
- Pad, seat, torso and range: as the Dumbbell Preacher Curl (ExRx Dumbbell and Barbell
  Preacher Curl: armpit near the top of the pad, back of the arm on it, lower until extended;
  StrengthLog: pad under the armpit, body still; Oliveira 2009: on the dumbbell preacher curl
  the biceps works hard only near extension because the load torque falls as the forearm
  rises; Pedrosa 2023, Sato 2021: bottom-range preacher training built more strength and at
  least as much muscle). Those training studies used palm-up preacher curls, so the copy says
  "on preacher curls".
- The brachialis bends the elbow the same way whatever the grip: Date 2021 (brachialis EMG
  patterns similar in supination, neutral and pronation) and anatomy (it inserts on the ulna,
  not the radius; Coratella 2023 Sports calls it the most powerful elbow flexor). The biceps
  works less with the palm in: Coratella 2023 Sports (-12% neutral vs supinated). "A larger
  share falls on the brachialis" is the inference from the two.
- Near the bottom the dumbbell sits out in front of the wrist and pulls the hand toward the
  little finger: mechanics (with the thumb up, the weight's lever about the wrist is largest
  with the forearm near level). ExRx lists the flexor and extensor carpi radialis, which hold
  the wrist against that pull, as stabilisers of the Lever Hammer Preacher Curl (a lever
  machine with thumb-up handles; the model uses a dumbbell on a preacher bench). Bent wrists
  take needless load: StrengthLog. Keep the grip neutral, without turning the palm: StrengthLog
  Hammer Curl (it is easy to start twisting the wrists without thinking about it), named in the
  correct text.
- Elbow off the pad lets the front of the shoulder help and tips the dumbbell back over the
  elbow: Coratella 2023 JFMK (flexing the arms forward raised anterior deltoid excitation),
  StrengthLog's machine-curl line and ExRx (back of the upper arm stays on the pad), lever
  mechanics. (ACE/Young 2014 is not cited: its preacher curl did not lower the anterior
  deltoid against the barbell curl.)
- Activation: Brachialis 0.76 HI (primary) > Biceps Brachii 0.72 HI (primary) >
  Brachioradialis 0.38 LOW. The brachialis leads because the library files the exercise under
  it and its role does not change with grip while the biceps' falls. The neutral grip is at
  least as strong as palm-up (Kohn 2018: 244 N vs 214 N isometric at 110°, not significantly
  different; both about twice pronated). The brachialis figure is a judgement: it is kept as
  the library's primary and matches the Alternating Hammer Curl (Brachialis P 0.76); its
  activity was not measured in any loaded curl. Biceps: 0.84 on the palm-up preacher less
  Coratella's 12%, rounded down to sit under the brachialis; ranked primary as in the
  Alternating Hammer Curl (StrengthLog Hammer Curl also lists the biceps as primary). Both rows
  map to the app's biceps group, so the group roles do not change. Brachioradialis: kept at the
  preacher level, because the loaded and
  unloaded EMG studies do not show a neutral grip raising it (Coratella 2023 Sports: 6% lower
  than supinated; Kleiber 2015: neutral same as supinated; Boland 2008: most active in elbow
  flexion whatever the forearm's position), although ExRx names it the target and StrengthLog
  says the grip puts it in a stronger position.
- Comparison: ARM LIFTING OFF THE PAD.

**Uncertain.** The order of the three elbow flexors is not measured for this exercise (the
brachialis needs fine-wire EMG). ExRx files its Lever Hammer Preacher Curl (a machine) under the
brachioradialis; the library's BRACHIALIS was kept (see recommendations). No source lists the
wrist tipping toward the little finger as a common hammer-curl error. It is inferred from the
load's pull on the wrist (thumb up, dumbbell in front of the wrist) and ExRx's radial wrist
stabilisers. The documented error, twisting the wrist (StrengthLog Hammer Curl), cannot be drawn
as a ghost (a turn about the forearm's axis leaves hand_L.tip in place), so it is named in the
correct text instead.

**Labels and glows.** As the Dumbbell Preacher Curl, with these changes: the range pill sits at
0.62, below the dumbbell's lowest point; the grip pill one notch higher (0.10, on screen 0.124,
as the seated wrist curls' GRIP_ABOVE_HEAD), clear of the far plate's top at each peak; the pad
pill reads "Arm on pad" (from 0.756, clear of the ghost's shoulder in the pad still); the torso
pill sits at 0.62 on the right, below the rocked-back ghost's pelvis (~0.40 in the torso
still), and the seat pill below it (0.74) points at the near foot, so no leader crosses the
torso pill (a seat leader up to the pelvis would). Glows: the left elbow (A: brachialis and
brachioradialis) and the left biceps (soft).

**Ghosts and stills**
- pad: `curlArmsOffPad(25, side: "L")`; top.
- range: `curlBottomCut("L", from: 0.8, to: 0.885)`; bottom.
- grip: `curlWristsGivingWay("L")` (new): the hand tipping 45° toward the little finger about
  the wrist; all of it from the bottom to ~125° of elbow angle, none by 90°. On the rig the
  hand points 72° below horizontal at the bottom instead of 27°. Bottom.
- torso: `preacherRockedBack(22, side: "L")` (new); top.
- seat: `preacherSatLow.seen(0.5)`; any, read at the bottom (dumbbell away from the head).
Pad, range, grip and torso `.seen(-0.4)` (total -1.5, true left side).

## Reverse Preacher Curl (260, yaw -0.8, zoom 1.0)

**Model.** Same body; the pad top slopes ~38°, the upper arms 45° below horizontal over it
(bone 9 cm above the pad plane at the shoulder, 5 cm at the elbow). An EZ bar with plates,
overhand on its angled grips, hands ~0.39 m apart: palms down at the bottom and facing forward
at the top, turned ~23° in from fully palm-down by the bar's angle (palm normal 0.39 toward the
midline). Both arms curl
together, elbows 162° to 62° (forearms 27° below horizontal to 72° above), two reps. Wrists
8-9° extended (knuckles in line). Re-framed at yaw -0.8, zoom 1.0, offset (-0.02, 0.123, 0.02)
(it was yaw -1.1, zoom 1.021, where the near plate covered the whole head at every peak). The
near plate now sweeps from px 157-213, y 267-357 (over the lower chest and left elbow) at the
bottom to px 193-253, y 139-227 (right of the face, overlapping the back of the head) at the
top; the far plate goes from px 15-78, y 280-357 to 47-110, y 172-247 (322x700 shots). The
left hand shows at the bottom; the left elbow sits behind the near plate there.

**Claims and sources**
- Set-up (overhand, shoulder-width, armpit near the top of the pad, back of the arm on it,
  raise until the forearms are vertical, lower until extended): ExRx Barbell Reverse Preacher
  Curl (the builder's reference); the model stops ~18° short of vertical.
- With the palms down the biceps works less: Coratella 2023 Sports (-19% vs supinated). The
  brachioradialis and brachialis take a larger share: Kleiber 2015 (brachioradialis
  significantly more active pronated than supinated or neutral, biceps unchanged, slow unloaded
  flexions); Coratella 2023 (loaded: brachioradialis only 5% below supinated while the biceps
  fell 19%); Date 2021 (brachialis unaffected by forearm position); StrengthLog, How to Train
  Your Forearm Extensors (reverse curls shift some of the work from the biceps onto the
  brachioradialis). The muscles on the back of the forearm hold the wrists straight: ExRx
  Barbell Reverse Curl (wrist extensors among the stabilisers); StrengthLog forearm-extensor
  guide (reverse curls recruit the extensor carpi radialis longus and brevis to stabilise);
  Coratella 2023 Sports suggests the pronated grip needs wrist stabilisation toward extension
  (their explanation, not measured). StrengthLog's Reverse Barbell Curl guide, cited for grip
  width, lists the biceps as primary.
- The angled grips can be easier on the wrists: StrengthLog EZ Curl says so of the underhand
  EZ curl ("can be kinder to the wrists and elbows"); applied to the overhand grip by the same
  logic, hence "can be".
- A palm-down grip is much weaker than palm-up: Kohn 2018 (isometric elbow-flexion force ~114
  N pronated vs ~214 N supinated and ~244 N neutral).
- Range (bottom half hardest, bottom-range training): as the barbell preacher; Oliveira 2009's
  load profile is grip-free mechanics; the training studies used palm-up curls.
- Wrists dropping into flexion near the bottom: mechanics (the bar hangs in front of the wrist,
  palm down, its pull largest with the hands near level); StrengthLog (bent wrists take needless
  load). The mistake text says near the bottom, where the ghost is read; at the top the palms
  face forward and dropping toward the floor no longer describes flexion.
- Activation: Brachioradialis 0.56 MOD (primary, as the library and ExRx), Brachialis 0.68 MOD
  (co-primary), Biceps Brachii 0.62 MOD. Brachialis: the barbell preacher's 0.68, since forearm
  rotation does not change its role (Date 2021, unloaded flexions in three forearm positions;
  it inserts on the ulna). Biceps: 0.84 less Coratella's 19%, rounded down. Brachioradialis:
  its share of the lift rises as the biceps drops (Kleiber 2015; StrengthLog forearm-extensor
  guide: reverse curls shift work from the biceps onto the brachioradialis), but loaded EMG
  does not show its activity rising (Coratella 2023: 5% lower pronated than supinated at each
  grip's 8RM; Boland 2008, fine-wire, 0-67 N: no difference between forearm positions in
  flexion), so it is raised from the palm-up preacher's 0.36 only to MOD. StrengthLog's Reverse
  Barbell Curl guide lists the biceps as primary. Judgement; no study of the reverse preacher
  curl itself. The first pass had the brachioradialis at 0.70 HI as the only primary, which
  would have filed the lift as primary forearms and only secondary biceps-group work.
- Comparison: ROCKING BACK (the weak grip invites an overloaded bar; Kohn 2018).

**Uncertain.** Which of the three flexors does most in a loaded reverse curl is not
established; the fractions are judgement. The EZ bar's effect on the wrists is StrengthLog's
statement about the underhand EZ curl.

**Labels and glows.** Laid out again for the new framing (from the re-probed joints.json).
Left: wrist (0.10, "Overhand, wrists straight") on the far (right) hand, which shows between
the plates at the bottom and beside the far plate at the top, one notch above the top row so it
clears the far plate's top at each peak; range (0.56, "Almost straight") on the far (right)
elbow, visible on the far forearm at the bottom and at the bottom of the far biceps at the top.
The left elbow sat behind the near plate at the bottom, its leader across the plate's face; the
label is short so its leader crosses the bar's middle ~5-10 px left of the near fist (with a
longer label it ran through the fist), and the far plate's bottom stays ~7 px above the pill.
Right: pad (0.34, "Arms on pad") on the left shoulder, its leader ~40 px straight up the outside
of the upper arm. At 0.14 the pill lay over the near plate at every peak (plate y 139-227); at
0.34 (px 231-306, y 261-283) the plate's lowest point at the peak is ~34 px above it, and mid-rep
the bar's sleeve end passes 1-3 px left of its left end without touching it (projected over the
clip). Torso (0.62, "No rocking back") on the left hip (thigh_L): the chest joint landed on the
near plate's rim at the bottom and on the pad's corner at the top, the other chest joints are
behind the plate at the bottom or under the near forearm at the top, and a leader to them from
the right crosses the working arm; the pelvis dot sits ~4 px below the plate's rim and the spine
dot on the plate. The hip stays clear of the plate (~20 px right of its rim at the bottom), it is
the hinge the rocked-back ghost turns about, and the label names the comparison's ROCKING BACK.
Seat (0.74) on the near foot, as the hammer curl. Glows: the left elbow (A: brachioradialis and
brachialis), the left biceps (soft) and the right elbow (soft).

**Ghosts and stills**
- pad: `curlArmsOffPad(25)`, the framing's own -0.8; top. Turned -0.4 (total -1.2, the old
  side view) the near plate covered the whole head again and the two lifted upper arms fell on
  one straight line; they separate from -0.9 and form two clear L shapes at -0.8, with the head
  left of the near plate, as the Barbell Preacher Curl's pad.
- range: `curlBottomCut(from: 0.8, to: 0.885).seen(-0.4)` (total -1.2); bottom. The two
  short forearms stay apart and rise clear above the plates.
- wrist: `curlWristsGivingWay(withBar: true)` (new): both hands tipping 45° down into flexion,
  the bar line between the hand tips; on the rig 72° below horizontal at the bottom instead of
  27°, gone by 90°. Bottom. Not turned: from the side both hands sat behind the near plate;
  from -0.8 both hands show between the plates and the two dropped hands separate.
- torso: `preacherRockedBack(22, side: "R").seen(-0.4)` (new; total -1.2); top. The far
  (right) arm only: with both arms the two lifted upper arms fell on one straight line through
  the spine (both shoulders and both elbows within ~3 px of it), read as one long bar with the
  forearms, spine and neck as four uprights; with the far arm only the spine is clear and one
  L-shaped arm sits left of it, nothing crossing. The lean is unchanged (the turn still pivots
  on the pelvis; the bend is read on the right elbow, which curls with the left). The leaning
  ghost's spine, neck and head sit right of the near plate, which covers the real head at the
  top. At
  -0.8 the lean looks smaller (head shift ~103 px against ~142 px) and the ghost's neck, head
  and near arm are drawn on the plate; -1.0 puts the ghost head on the plate's rim. No view
  clears both heads, and the ghost is the subject.
- seat: `preacherSatLow.seen(0.5)` (total -0.3); any, read at the bottom (bar away from the
  head). At -0.6 the near plate covers the ghost's spine and pelvis. In the still the unmoved
  left ankle, the pill's own dot, touches the pill's left end, because the pill keeps its
  trainer row while the view turns (app-level).

## Barbell Preacher Curl (263, yaw -0.8, zoom 0.602)

**Model.** Same body; the pad top slopes ~29°, the upper arms 45° below horizontal over it
(bone 13 cm above the pad plane at the shoulder, 5 cm at the elbow). An Olympic barbell with
plates, underhand, hands ~0.42 m apart (shoulder-width). Both arms curl together, elbows 162°
to 62°, forearms 27° below horizontal
to 71° above, two reps; wrists 9-12° extended. Re-framed for the 2.2 m bar at yaw -0.8, zoom
0.602 (offset [-0.003, 0.051, 0.003]; it was yaw -1.1, zoom 0.943, where the near plate hid the left hand
at the bottom and rose past the head at the top): the near plate now sweeps u 0.62-0.86, v
0.25-0.54, right of the chest at the bottom and right of the head at the top, and the far plate
u 0.08-0.37, v 0.33-0.53; the lifter is drawn smaller, like the Barbell Curl (zoom 0.615).

**Claims and sources**
- Set-up (shoulder-width underhand grip, armpit near the top of the pad, back of the upper arm
  on it, raise until the forearms are vertical, lower until extended; also called the Scott
  curl): ExRx Barbell Preacher Curl (the builder's reference); StrengthLog Barbell Preacher
  Curl (pad under the armpits, body still, feet flat, stop short of full extension if it is
  uncomfortable, wrists straight).
- Bottom half hardest, bottom-range training: Oliveira 2009; Pedrosa 2023; Sato 2021 (all
  dumbbell preacher curls; the bar's load profile on the same pad is the same mechanics).
- Palm-up grip, biceps does the most work: Coratella 2023 Sports. Curling the wrists in pulls
  the bar back toward the elbows: mechanics.
- Seat too low hunches the shoulders; rocking back skips the bottom: as the Dumbbell Preacher
  Curl (ExRx seat rule; NSCA, StrengthLog on momentum).
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.68 MOD > Brachioradialis 0.36 LOW, as the
  Dumbbell Preacher Curl: ACE had the preacher curl lowest in biceps activity of its eight
  curls and with less brachioradialis than the narrow EZ curl (the ACE text does not say which
  implement its preacher curl used); Oliveira 2009 shows the biceps working hard only near
  the bottom.
- Comparison: STOPPING SHORT AT THE BOTTOM.

**Uncertain.** Activation shares (no study of the barbell preacher curl itself).

**Labels and glows.** Laid out again for the new framing, keeping the pills above v 0.24 or
below v 0.55 where the plates sweep. Right: pad (0.14, "Arms on the pad") on the left shoulder,
its leader straight down; seat (0.74, "Seat set, feet flat") on the near foot (foot_L), a short
level leader (the pelvis dot sat on the near plate's lower face at the bottom). Left: torso
(0.14, "Chest on the pad") on the upper chest between the arms
(support_PectoralisMajor_Clavicular_R): the chest joint landed on the near plate's rim at the
bottom and on the pad's corner at the top, and from the right any leader to the visible chest
crosses the working left elbow or the head; this leader passes ~10-18 px left of the head, over
the right trapezius, and between the two hands at the peak (the dot sits ~3 px from the left
forearm's edge there). Grip (0.23, "Wrists straight") under it on the far hand, short so the
pill ends left of the torso leader, 16 px above the far plate's top at the peak (in the grip
still, where the model sits 0.09 higher, the pill lies over the far plate's upper-left rim).
Range (0.62, "Arms almost straight") on the far elbow, ending 17 px left of the right knee (the
longer label sat on it). Glows (from the re-probed joints, no nudges): the left biceps (A), left
elbow (soft), right biceps (soft), each on the model's red muscle in the shots.

**Ghosts and stills**
- pad: `curlArmsOffPad(35)`; top. 35° rather than 25°: at this zoom the 25° lift moved the
  elbows only ~23 pt; 35° moves them ~32 pt.
- range: `curlBottomCut(from: 0.8, to: 0.885).seen(-0.4)` (total -1.2); bottom. The two ghost
  forearms rise clear above the plates; from -0.8 to -0.9 the near upper arm crosses the far
  forearm. The label's far-elbow dot sits on the near plate's rim in this still.
- grip: `curlWristsCurled(degrees: 65)`; top. The deeper fold, as the Dumbbell Spider Curl,
  since the lifter is drawn small. No bar line: drawn from tip to tip it ran along the real bar
  ~15-20 px below it and across the neck, and with the two folded hands read as a lowered bar (a
  ∏ frame) rather than two bent wrists; without it the two hooks read at a glance.
- torso: `preacherRockedBack(22, side: "R")` (new); top. The far (right) arm only: from -0.8
  the near arm's forearm lay along the ghost's neck-to-head segment and its upper arm crossed
  the spine, so the spine could not be told apart. With the far arm only the spine is clear and
  one L-shaped arm sits on the screen's left, nothing crossing. The lean is unchanged (the turn
  still pivots on the pelvis; the bend is read on the right elbow, which curls with the left).
  The "Chest on the pad" leader passes near the far ghost wrist, because the pill keeps its
  trainer row (app-level).
- seat: `preacherSatLower(0.28).seen(0.5)` (new; total -0.3, both plates off the trunk; at -0.6
  the near plate reaches the left hip); any, read at the bottom. The shared 0.2 sink left the
  shoulders' V only ~9 pt deep at this zoom; 0.28 moves the trunk ~58 px instead of ~42 px (at
  764 wide) and about doubles the V, the hips still above the knees.
Pad, grip and torso keep the framing's own -0.8 (the old `.seen(-0.4)` now gave -1.2, where the
near plate hides the head and left shoulder at the top). From -0.9 on, the near plate already
reaches the left shoulder, where the lifted arms start, and the leaning ghost's head; at -0.8
both clear it and the sagittal faults are seen 46° off the front.

## Fault moments (for fault_times.py)

```json
{
  "Single-Arm Machine Curl": {"pad": "top", "range": "bottom", "grip": "top", "torso": "top", "pivot": "bottom"},
  "Cable Preacher Curl": {"pad": "top", "range": "bottom", "top": "top", "grip": "top", "torso": "top"},
  "Preacher Hammer Curl": {"pad": "top", "range": "bottom", "grip": "bottom", "torso": "top", "seat": "bottom"},
  "Reverse Preacher Curl": {"pad": "top", "range": "bottom", "wrist": "bottom", "torso": "top", "seat": "bottom"},
  "Barbell Preacher Curl": {"pad": "top", "range": "bottom", "grip": "top", "torso": "top", "seat": "bottom"}
}
```

The pivot and seat ghosts hold all through the rep (`.always`); they are read at the bottom,
where the load is away from the head. `fault_times.py` takes the elbow as the smaller of the
two, so on the two one-arm lifts (resting right elbow constant at 101.5° and 103.8°) the
"bottom" search ties wherever the left elbow is straighter than the resting right one and
returns 3.83 s (left elbow 162°, the bottom hold at the end of rep 1), which is a real bottom
(checked by running `times()` on both rigs); the "top" is the left elbow's most bent moment
(1.58 s).

## New pieces

`curlWristsGivingWay(side, withBar:, degrees:)` (a 45° drop, strength by shoulder-to-wrist
0.64-0.8), `curlStoppedShortOfTop(side, from:, to:)` (a 40° unfold, drawn to the wrists),
`preacherRockedBack(degrees, side:)` (the seated rock-back, moving only the spine and the drawn
arm), `leftCurlMachineSatLow` (0.1 sink, left arm and shoulder only, legs to the ankles),
`preacherSatLower(drop)` (`preacherSatLow` with its sink as a parameter, for the Barbell
Preacher Curl's small lifter; the shared 0.2 piece is unchanged), documented in the PIECES
section. Reused: `curlArmsOffPad`, `curlBottomCut`, `curlWristsCurled`, `preacherSatLow`,
`elbowsFolded`, `leftArm`, `torso`, `spine`, `elbow`. No fault here is tempo or force only, so
every cue has a ghost. The shared `curlSeatedSwungBack` (Dumbbell Preacher Curl, Machine Biceps
Curl, and a standing cable curl) still moves the whole `trunk` and so leaves orphan dashed
guides from undrawn joints; it lives outside this family's files.

## Library recommendations

- Preacher Hammer Curl: difficulty .intermediate -> .beginner, like the Dumbbell Preacher Curl
  (same bench set-up, one dumbbell, pad support) and the Alternating and Cable Hammer Curls; the
  neutral grip is at least as strong as palm-up (Kohn 2018). Primary muscle stays BRACHIALIS
  (ExRx files its lever-machine version under the brachioradialis, but the loaded EMG does not
  show the brachioradialis rising with a neutral grip, and the brachialis' role is
  grip-independent).
- Barbell Preacher Curl: re-framed at yaw -0.8, zoom 0.602 (done; labels and ghost views redone
  above).
- Reverse Preacher Curl: re-framed at yaw -0.8, zoom 1.0, offset (-0.02, 0.123, 0.02) (done;
  joints.json re-probed, labels and ghost views redone above: pad row 0.34, range on the far
  elbow, torso on the left hip, pad ghost at the framing's own view).
- Reverse Preacher Curl: BRACHIORADIALIS and EZ BAR match the model and ExRx; no change.
- Model fixes (for the model builder, not the library): Single-Arm Machine Curl, move the
  resting right hand out of the lever's arc (the right grip passes y 1.00-1.06 m, z
  0.25-0.30 m around 1.0 s and 2.7 s), e.g. lay the forearm on the pad top or draw the fist
  back toward the chest; Preacher Hammer Curl, re-pose the empty right arm so the elbow and
  forearm lie on the pad; Cable Preacher, Preacher Hammer, Reverse Preacher and Barbell Preacher
  Curl, re-tilt Q191_Preacher_Pad to the Dumbbell Preacher Curl's ~45° pad so the upper arms lie
  along it. Re-export and re-probe after each.

## Sources

- Oliveira LF, Matta TT, Alves DS, Garcia MAC, Vieira TMM. 2009. Effect of the shoulder
  position on the biceps brachii EMG in different dumbbell curls. J Sports Sci Med
  8(1):24-29. (Abstract read on Europe PMC, PMC3737788.)
- Pedrosa GF, Simões MG, Figueiredo MOC, Lacerda LT, Schoenfeld BJ, Lima FV, Chagas MH,
  Diniz RCR. 2023. Training in the initial range of motion promotes greater muscle adaptations
  than at final in the arm curl. Sports 11(2):39. doi:10.3390/sports11020039
- Sato S, Yoshida R, Kiyono R, Yahata K, Yasaka K, Nunes JP, Nosaka K, Nakamura M. 2021.
  Elbow joint angles in elbow flexor unilateral resistance exercise training determine its
  effects on muscle strength and thickness of trained and non-trained arms. Front Physiol
  12:734509. doi:10.3389/fphys.2021.734509
- Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M. 2012. Effect of range of
  motion on muscle strength and thickness. J Strength Cond Res 26(8):2140-2145.
  doi:10.1519/JSC.0b013e31823a3b15
- Nunes JP, Jacinto JL, Ribeiro AS, Mayhew JL, Nakamura M, Capel DMG, Santos LR, Santos L,
  Cyrino ES, Aguiar AF. 2020. Placing greater torque at shorter or longer muscle lengths?
  Effects of cable vs. barbell preacher curl training on muscular strength and hypertrophy in
  young adults. Int J Environ Res Public Health 17(16):5859. doi:10.3390/ijerph17165859
- Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F, Cè E. 2023. Biceps
  brachii and brachioradialis excitation in biceps curl exercise: different handgrips,
  different synergy. Sports 11(3):64. doi:10.3390/sports11030064 (full text read on PMC,
  PMC10054060: standing cable curls, bar for supinated and pronated, rope for neutral, each
  grip's own 8RM; nRMS to maximal isometric excitation; no absolute values reported.)
- Coratella G, Tornatore G, Longo S, Esposito F, Cè E. 2023. Bilateral biceps curl shows
  distinct biceps brachii and anterior deltoid excitation comparing straight vs. EZ barbell
  coupled with arms flexion/no-flexion. J Funct Morphol Kinesiol 8(1):13.
  doi:10.3390/jfmk8010013
- Kleiber T, Kunz L, Disselhorst-Klug C. 2015. Muscular coordination of biceps brachii and
  brachioradialis in elbow flexion with respect to hand position. Front Physiol 6:215.
  doi:10.3389/fphys.2015.00215
- Boland MR, Spigelman T, Uhl TL. 2008. The function of brachioradialis. J Hand Surg Am
  33(10):1853-1859. doi:10.1016/j.jhsa.2008.07.019 (abstract read on PubMed: fine-wire EMG,
  loads 0-67 N, no difference in activation during elbow flexion across the three forearm
  positions.)
- Date S, Kurumadani H, Nakashima Y, Ishii Y, Ueda A, Kurauchi K, Sunagawa T. 2021. Brachialis
  muscle activity can be measured with surface electromyography: a comparative study using
  surface and fine-wire electrodes. Front Physiol 12:809422. doi:10.3389/fphys.2021.809422
- Kohn S, Smart RR, Jakobi JM. 2018. Voluntary activation and twitch potentiation of the elbow
  flexors across supinated, neutral, and pronated forearm orientations. Physiol Rep 6:e13560.
  doi:10.14814/phy2.13560 (abstract and PMC5789656 read: 213.6, 243.6 and 113.6 N at 110°;
  supinated and neutral both above pronated and not different from each other.)
- Young S, Porcari JP, Camic C, Kovacs A, Foster C. 2014. ACE study reveals best biceps
  exercises. ACE ProSource, August 2014 (ACE-sponsored, not peer-reviewed; PDF text read: 16
  volunteers with lifting experience, 70% 1RM; the concentration curl highest in biceps
  activity; the incline
  and preacher curls less brachioradialis than the narrow EZ curl; the anterior deltoid lower
  than the barbell curl only for the incline curl, concentration curl and chin-up; the %MVC
  values are in a figure, read in the 191-240 batch as ~68% for the preacher curl).
- Sands WA, Wurth JJ, Hewit JK. 2012. NSCA's Basics of Strength and Conditioning Manual
  (EZ-bar curl coaching points: no momentum, controlled return).
- ExRx.net: Lever Preacher Curl (plate loaded) (LVPreacherCurlH), Cable Preacher Curl, Barbell
  Preacher Curl, Barbell Reverse Preacher Curl, Lever Hammer Preacher Curl (a lever machine),
  Dumbbell Hammer Curl, Barbell Reverse Curl. ExRx blocks direct fetches; instructions and
  muscle lists were read from the pages' search-index text (2026-09-27) and, in the revision,
  from Wayback snapshots of LVPreacherCurlH, CBPreacherCurl and LVHammerPreacherCurl.
- StrengthLog exercise guides (strengthlog.com, read 2026-09-27): Barbell Preacher Curl,
  Hammer Curl (lists the biceps as primary), Reverse Barbell Curl (lists the biceps as
  primary), EZ Curl, Machine Biceps Curl (upper arms on the pad, elbows in line with the
  machine's joint, stop just before the weights hit the stack).
- StrengthLog, The 13 Best Machine Exercises for Muscle and Strength
  (strengthlog.com/best-machine-exercises, read 2026-09-27): the machine curl locks the upper
  arm in place and makes it almost impossible to use the shoulders or swing the back.
- StrengthLog, How to Train Your Forearm Extensors (strengthlog.com/forearm-extensors-exercises-
  workout, read 2026-09-27): reverse curls shift some of the work from the biceps onto the
  brachioradialis and recruit the wrist extensors, especially the extensor carpi radialis
  longus and brevis, to stabilise.
