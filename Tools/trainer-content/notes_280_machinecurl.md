# Redone 190-280: Machine Preacher Curl (2026-09-30)

The one new exercise of the drive's redone "190-280 🟢" folder: 264 Machine Preacher Curl
(model `Biceps/MachinePreacherCurl`). `spec_280_machinecurl.py` holds the copy and setup steps
(its header lists what the model shows and the full citations),
`Tools/fault-review/faults_280_machinecurl.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_280_machinecurl.json` the moment each ghost is stilled. This
file maps the copy's claims to their sources and records the model facts the copy relies on.

## How the model was read

- The brief (`SCRATCH/briefs22/new/MachinePreacherCurl.md`, every 0.5 s), the trainer stills at
  0/1/2/3/5 s (`SCRATCH/shots/view/machine-preacher-curl_t*.png`), `highlight_tiers22.json` and
  `joints.json`.
- The rig and machine straight from the USD with Blender's Python + pxr (scripts in
  `SCRATCH/mpc/`): elbow angle, shoulder-to-wrist distance and the stack's height every 1/8 s;
  the equipment prims' bounds; the arm pad's top edge from its mesh (back-top and front-top
  vertices); the pivot hub centres; the upper arm's and forearm's world angles; the wrist to
  handle distance. The same was read from `Biceps/MachineBicepsCurl` (and a brief made for it
  with `briefs_1_50/brief_arms.py`) to see how the two differ.
- Label layout: `preview_280.py machinecurl`, then the pills (12 pt semibold, ~24 + 6.4 pt per
  character, 28 pt tall), leaders and dots drawn over the five stills with the squeezed rows and
  the app's 8 pt edge clamp (`TrackedCallout.anchor`), the dots at `joints.json`'s moment for
  each still (`SCRATCH/mpc/overlay.py`, output in `SCRATCH/mpc/overlay/`).

## Model facts the copy relies on

- Machine: `Q191_CurlMachine`, the Machine Biceps Curl's and Single-Arm Machine Curl's plate
  stack curl machine. Here the pivot hubs sit at x ±0.38 (outside the arms, at the ends of the
  pad), centred 0.939 m up and 0.008 m fore-aft (Machine Biceps Curl: 0.907 m, -0.031 m); the
  arm pad (0.66 m wide) has its top edge at 0.982 m (back, z -0.150) and 0.904 m (front,
  z 0.002), a 27.0° slope (Machine Biceps Curl 0.942 / 0.850 m, 30.6°). One lever prim (two side
  arms, a straight handle with a grip either side of centre) turns about the hubs; the stack
  rises from 0.139 m to 0.389 m (25 cm) at ~2.5 mm per degree of lever turn (0.021 m over the
  first 8°, 0.128 m over the next 52°, 0.100 m over the last 40°). No cable or cam is modelled,
  so nothing in the copy says where the machine is heaviest.
- Body: knees 111°, hips 101°, feet flat, ankles 0.38 m apart, trunk 12° forward and still. Same
  body as the other curls (torso, neck to pelvis, 0.592 m). The chest meets the back of the pad,
  but not cleanly: skinned with UsdSkel at 0 and 2 s, the rectus abdominis, internal and
  external obliques and lower pectoralis (abdominal and sternal) fill the pad slab's full ~4 cm
  thickness between z -0.165 and -0.08 at y 0.91-0.98, so the pad's back ~8 cm sits inside the
  lower chest and upper abs (the torso's front surface there is at z ~-0.08). A model issue,
  flagged below; "chest to the pad" still holds.
- Upper arms: 45° below horizontal (shoulder joint 1.143 m, z -0.196; elbow 0.940 m,
  z 0.008), 57° of shoulder flexion from the trunk (the Machine Biceps Curl 55° below
  horizontal, 47° from the trunk); they never move. Skinned (UsdSkel, 0 and 2 s), the triceps'
  long and lateral heads lie within 1.5 cm of the pad's top plane from z -0.164 to 0.003, the
  whole pad, and sit 2.5-2.7 cm inside it over z -0.157 to -0.044: the backs of the upper arms
  lie along the whole pad, pressed into its back half by the armpits. The humerus slopes 45°,
  steeper than the 27° pad, because the arm thins toward the elbow. The armpits sit over the top
  edge (shoulder joints 16 cm above it) and the elbows at the front edge (elbow z 0.008, pad
  front z 0.013).
- Elbows on the pivot axis: elbow 0.940-0.941 m up, hub centre 0.939 m; fore-aft 0.000 all clip.
  The wrist joint stays 0.081 m from the handle's grip centre all clip (the handle does not move
  in the hand).
- Grip: underhand, palms up (facing the shoulders at the top), wrists 0° all clip, hands at
  x ±0.20 (0.40 m apart) straight in front of the shoulder joints (x ±0.196).
- Elbow range and timing: 162.0° to 62.1° (forearms 27° below horizontal to 72° above);
  shoulder-to-wrist 0.531 m at the bottom (0.897 torso lengths), 0.458-0.480 m at 117-126°
  (0.77-0.81), 0.279 m at the top (0.471). Two identical reps in 7.96 s: still to 0.30 s; up
  0.30-1.58 s (~1.3 s); the top held 1.58-2.00 s; down 2.00-3.75 s (~1.75 s); still 3.75-4.30 s;
  again. Top (elbows most bent) 1.58 s, bottom 3.83 s, as `bottoms.json` has for the Machine
  Biceps Curl, which runs the identical timing.
- Framing (yaw -1.0, zoom 1.032, offset (-0.024, 0.142, 0.037)): from the front-left; head
  (0.62, 0.19), near shoulder (0.74, 0.26), near elbow (0.59, 0.35), far elbow (0.42, 0.37),
  wrists (0.43, 0.41) / (0.26, 0.42) at the bottom and (0.54, 0.23) / (0.37, 0.25) at the top;
  in the stills the fists' tops reach v ~0.17 at the top of the rep and their bottoms v ~0.45 at
  the bottom; the stack shows as a sliver at the left edge, rising through v 0.43-0.78.
- Highlight tiers (`highlight_tiers22.json`, "Biceps/MachinePreacherCurl", new model only):
  bright (1.0, 0.06, 0.01) = BicepsBrachii_LongHead, BicepsBrachii_ShortHead, Brachialis; dim
  (0.26, 0.02, 0.01) = Brachioradialis, ExtensorCarpiRadialisBrevis/Longus, ExtensorCarpiUlnaris,
  ExtensorDigitorum, FlexorCarpiRadialis, FlexorDigitorumProfundus/Superficialis, PalmarisLongus.

## Cue titles

Pivot Alignment, Upper Arm Position, Grip and Wrists, Bottom of the Rep, Lowering Speed: neutral
topic names, as across the app (Range of Motion, Grip, Arm Position ...). The trainer's mistake
banner reads "COMMON MISTAKE · <TITLE>", and on the app's fault screenshots (2026-09-30) the first
titles, which stated the correct form ("Elbows on the Pivots", "Upper Arms Down", "Palms Up"),
read as if that were the mistake over ghosts showing the opposite; "ELBOWS ON THE PIVOTS" also ran
the banner to within ~2 pt of the muscles button.

## Claims and sources

- pivot. "Each elbow lines up with the lever's pivot on that side"; seat set until "both elbows
  sit level with the round pivots at the sides of the pad" — the model (elbows on the axis, the
  hubs at the pad's ends); ExRx Lever Preacher Curl (Wayback 2023-12-04: "Align elbows at same
  pivot point as fulcrum of lever"); StrengthLog Machine Biceps Curl ("Your upper arms should
  rest on the padding, and your elbows should be in line with the machine's joint"). "With the
  elbows on the same axis, the handle travels the same arc as the hands, so it stays put in the
  palms from bottom to top; with the elbows off the axis, the handle slides along the hands" —
  geometry of a lever turning about its hubs, and the model (wrist to grip 0.081 m all clip).
  The mistake's direction (seat too low, elbows below the pivots) follows the Machine Biceps and
  Single-Arm Machine Curls; no source states which way it usually goes, and in this model the
  elbows already sit at the pad's front edge, so a lower elbow would be inside the pad.
- pad. "With the backs of the upper arms resting on the pad, sloping down at about 45°" — the
  model: the upper arms (humerus) 45.0° below horizontal, the backs of the arms along the whole
  pad (whose top slopes 27°), the shoulders fixed; the 45° is the arms', not the pad's. "the
  elbows are the only joints that move" — the model (shoulders fixed);
  StrengthLog, The Best Machine Exercises ("It locks your upper arm in place and makes it almost
  impossible to use your shoulders or swing your back to get the weight up"). "Lifting the
  elbows ... brings the front of the shoulders into the lift" — Coratella 2023 JFMK, full text
  PMC9944112: "The anterior deltoid was more excited when flexing vs. not flexing the arms"
  (standing barbell curls, ten bodybuilders; used only for the direction). The same study found
  the biceps more excited in the lifting phase with the arms flexed (+17.7% straight bar, +20.3%
  EZ bar; abstract: "in ST flex vs. ST no-flex (+17.7%, ES: 3.93) and in EZ flex vs. EZ no-flex
  (+20.3%, ES: 5.87)"), so the copy claims only that the shoulders join in, never that the
  biceps works less. "takes the elbows off
  the pivots" — geometry. "The backs of the upper arms stay on the pad, the armpits over its top
  edge" — ExRx ("Seat should be adjusted to allow armpit to rest near top of pad. Back of upper
  arm should remain on pad throughout movement"); the model (armpits over the edge, the backs of
  the arms along the whole pad). "take some weight off the stack" is advice, not a claim.
- grip. "In trained lifters, curls with the palms turned up have worked the biceps harder on the
  way up than palm-in or palm-down curls" — Coratella 2023 Sports (ten competitive bodybuilders,
  standing bilateral cable curls, a bar palms up or down and a rope for neutral, 6-rep sets at
  the 8RM load; "During the ascending phase, (i) biceps brachii excitation was greater with the
  supinated compared to the pronated [+19(7)%, ES: 2.60] and neutral handgrip [+12(9)%...]"; full
  text: "During the descending phase, no significant differences emerged in nRMS between the
  three handgrips", hence "on the way up"). "a bent wrist grips far
  more weakly" — Mogk & Keir 2003 ("A flexed wrist reduced maximum grip force by 40-50%").
  "Curling the wrists in moves the handle with the wrists instead of the elbows" — mechanics.
  The mistake ("At the top, the wrists bending in so the handle tips back toward the face") is a
  description of the ghost (`curlWristsCurled`, the hand tips folding toward the face at the
  top), worded apart from the Machine Biceps Curl's.
  "hands straight in front of the shoulders", "wrists straight" — the model; StrengthLog Machine
  Biceps Curl ("Grab the handles with an underhand grip around shoulder width apart").
- range. "In new lifters on preacher curls, training that lower part has built more strength,
  and at least as much muscle, as training only the upper part" — Pedrosa 2023 (19 untrained
  young women, seated dumbbell preacher curl, one arm 0-68°, the other 68-135°: "greater 1RM
  increase", "greater CSA increase ... at 70% of biceps length", "similar increases ... for CSA
  at 50% ... and for CSAsummed") and Sato 2021 ("Thirty-two non-resistance trained young
  adults"; methods, PMC8489980: "positioned on a preacher curl bench in a seated position, with
  45° shoulder flexion and forearm supination", a dumbbell; 0-50° raised torque and thickness
  more than 80-130°, 8.9% vs 3.4%). "and full-range reps more strength than partial ones" —
  Pinto 2012 (full text: "Forty young men with no resistance training experience participated in
  this study"; "The elbow flexion training was performed in a bilateral mode preacher curl
  exercise", the 1RM tested "with the radioulnar joint supinated using a curling bar"; 0-130° vs
  50-100°, 10 weeks: 1RM +25.7% vs +16.0%, "FULL 1RM strength was significantly greater";
  thickness rose in both, 9.65% vs 7.83%, so no muscle claim for full range). All three trained
  people new to lifting, as "In new lifters" says. None of the three used a machine; the copy
  says "on preacher curls".
  "stopping just before the plates touch down" — StrengthLog Machine Biceps Curl ("stop just
  before the weights hit the stacks"). "almost straight" — the model (162°); ExRx says "until
  arms are fully extended", the copy follows the model and the other preacher entries. "the
  forearms slope down past level" — the model (forearms 27° below horizontal at the bottom).
  The mistake ("Turning each rep back up while the forearms are still angled up") describes the
  range ghost (the elbow held at ~117°, the forearm ~18° above horizontal); the mistake and
  correct lines are worded apart from the Machine Biceps Curl's.
- lower. "about two seconds" and "Curl up in about a second, hold the top for a moment" — the
  model (~1.3 s up, 0.4 s hold, ~1.75 s down). "in training studies, lowering-only work has
  built about as much muscle as lifting-only work, or a little more" — Schoenfeld 2017 JSCR
  (15 studies: "eccentric muscle actions resulted in a greater effect size ... but results did
  not reach statistical significance", "10.0% vs. 6.8%"; "both have shown to be effective").
  "In sets taken to failure, reps lasting from half a second to about eight seconds have built
  similar muscle, so the aim is control, not a slow count" — Schoenfeld 2015 Sports Med
  ("hypertrophic outcomes are similar when training with repetition durations ranging from 0.5 to
  8 s"; duration is the whole rep, "the sum total of the concentric, eccentric, and isometric
  components"; inclusion criterion (5): "carried out training to muscle failure"). "Make sure to
  do the entire movement at a controlled speed" — StrengthLog Machine
  Biceps Curl. "without letting the plates touch down" — StrengthLog Machine Biceps Curl
  ("stop just before the weights hit the stacks"), as in the range cue; the model's stack hangs
  7 cm above the tower base at the bottom (the whole stack lifts, no pin modelled, so the line
  no longer says "off the stack"). The mistake (the stack dropping, the arms snapping straight)
  is a description, no injury claim; the comparison's mistake note ends at "the elbows
  snapping straight", matching its cue.
- comparison (LETTING THE STACK DROP): the lower cue's sources. "Lowering under control, about
  two seconds here" — the control is what the sources support (Schoenfeld 2015: 0.5-8 s reps
  build similar muscle; StrengthLog: "a controlled speed"); the two seconds is this model's
  tempo (~1.75 s down), not a requirement. "builds muscle about as well as the lift" —
  Schoenfeld 2017 (see above; conclusion: "The findings indicate the importance of including
  eccentric and concentric actions in a hypertrophy-oriented RT program").
- Activation.
  - Biceps Brachii PRIMARY 0.84 HIGH: bright; the app's value for the machine and preacher curls
    (no EMG study of a two-arm preacher curl machine was found). StrengthLog lists the biceps
    as the machine curl's primary muscle.
  - Brachialis PRIMARY 0.72 HIGH: bright. ExRx names the brachialis the target of the lever
    preacher curl (biceps and brachioradialis synergists); Kawakami 1994 (MRI, four men)
    estimated its share of maximal elbow-flexor torque at 47% against the biceps' 34% and the
    brachioradialis' 19% (from PCSA and MRI moment arms: a capacity estimate, not activation);
    Coratella 2023 Sports calls it "the most powerful flexor of the forearm" (not measured
    there). Date 2021 (six men, unloaded elbow flexion, surface vs fine-wire EMG): "The BR has
    different EMG pattern from the BBLH and the BBSH", so the brachialis is active in elbow
    flexion on its own pattern; it shows the muscle works, not how hard. StrengthLog lists only
    the biceps (primary) and forearm flexors (secondary) and does not name the brachialis. Kept
    below the biceps as a house choice, matching the other machine and preacher curls (biceps
    0.84). No source compares the two on this lift; Coratella 2023 Sports did not record the
    brachialis ("only detectable through wire electrodes") and shows only that the biceps is
    more excited palms up than with other grips. The siblings rank it SECONDARY at 0.66-0.68
    (see "Uncertain / not yet seen"); the 0.72 is a house value on those grounds, not a measurement.
  - Brachioradialis SECONDARY 0.38 LOW: dim; the app's preacher/machine value; Boland 2008
    (fine-wire EMG: "The greatest EMG activity recorded from the brachioradialis occurs during
    elbow flexion tasks regardless of forearm position"); ExRx lists it as a synergist.
  - Forearms SECONDARY 0.30 LOW: dim (the wrist and finger flexors and extensors, one row as in
    the 1-50 curls, so the legend's secondary line reads "BRACHIORADIALIS · FOREARMS"); the
    1-50 curls' house value; ExRx lists the wrist flexors as stabilisers; StrengthLog lists
    the forearm flexors as the machine curl's secondary muscles.
  - Stabilisers "anterior deltoid" (Coratella 2023 Sports: the handgrips "require different
    anterior deltoid interventions for stabilizing the humeral head"; standing cable curls with
    the arms free; on this machine the pad carries the arms, so this stays a house stabiliser),
    "rotator cuff" and "core" (house, as the other machine curls).
- Setup steps: seat to the pivots (ExRx, StrengthLog, the model); chest to the pad, armpits over
  its top edge (the model; ExRx); backs of the upper arms on the pad's slope (the model; ExRx);
  the straight handle underhand, hands in front of the shoulders (the model; StrengthLog); start
  almost straight (the model, 162°).

## Labels and glows

Rows after the squeeze (`spec_280.row`): grip 0.124 left, pad 0.16 right, pivot 0.533 right,
range 0.533 left, lower 0.64 left. Pill spans below are after the app's 8 pt edge clamp
(`TrackedCallout.anchor`), at ~24 + 6.4 pt per character and 28 pt tall.

- grip "Wrists straight" (left, top) → `hand_L`. The pill spans u 0.021-0.335, v 0.103-0.145.
  Default view: the fists' tops reach ~0.17 at the top of the rep, so it clears them by ~15 pt;
  no button sits at the top left. Grip-mistake view (turned -0.5, scaled 0.935 and lifted
  0.35 × 0.26 of the view height, only this label shown; projected with the app camera at the
  top, 1.58 s): both fists and the handle sit at u 0.42-0.49, v 0.085-0.18 and the ghost's
  curled tips at ~(0.53, 0.11) and (0.50, 0.15), all ~33 pt or more right of the pill's end.
  The earlier "Palms up, wrists straight" (25 characters) reached u 0.503 there and covered the
  fists, so the label was cut to the part the ghost shows. Its leader clears the far fist at
  the top (it passes at v ~0.14-0.16, the fist's top ~0.18) and crosses the far arm at the
  bottom.
- pad "Arms on pad" (right, top) → `upper_arm_L`. Short, so the pill starts at u 0.732, right
  of the head (ends ~0.68), as the Single-Arm Machine Curl's "Arm on pad"; the leader drops
  straight to the near shoulder. The dot sits on the shoulder joint (16 cm above the pad); no
  mid-upper-arm joint is probed.
- pivot "Elbows on the pivots" (right, on the range row, below the hips) → `forearm_L`, the
  near elbow, on the axis; the pill (u 0.581-0.979, v 0.512-0.554) covers the near thigh and the
  seat's front, nothing that moves; its leader runs straight up over the abdomen to the dot. It
  was at hip height (row 0.471) before; in the pivot-mistake view (side-on, lifted) the
  seat-too-low ghost's lowered hips (v ~0.447) and thighs (running to the knees at ~(0.45,
  0.49), v ~0.48 at the pill's left end) would have been drawn across that pill; at 0.533 they
  stay ~22 pt above it, and the ghost's shins (u ~0.44-0.46) pass left of it.
- range "Arms almost straight" (left) → `hand_R`, and lower "Lower over two seconds" (left, one
  row lower) → `forearm_R`, the far elbow, which never moves (with no ghost, its red ring marks
  the joint that snaps straight). Both pills sit below the fists' lowest point (~0.45) over the
  far leg and the machine's left post; the range pill ends at u 0.419 and the lowering pill at
  0.452, so the lowering leader rises past the range pill's end ~0.02 clear (drawn on all five
  stills; the two leaders never cross). The stack's visible sliver at the left edge passes
  under both pills as it rises.
- Leaders that cross the body, kept as on the Machine Biceps Curl (same joints, similar
  layout; no row on the left reaches the far elbow without passing the near fist, and moving
  "lower" to `hand_R` would cross the range pill): the lowering leader passes over the far
  thigh and across the near wrist and fist at the bottom of every rep; the grip leader crosses
  the far arm at the bottom; the pivot leader rises over the abdomen. No pill covers the moving
  forearms or handle in the default view.
- Checked with `SCRATCH/mpc/overlay.py` (a copy with the new layout drew the five stills) and,
  for the grip and pivot mistakes, with the app camera's projection of the rig in the turned,
  lifted view; then on app screenshots (2026-09-30: the trainer at 1 and 3 s and the four
  ghosts at their moments): every pill clear of the moving arms, handle and fists, none under the
  buttons or off-screen; in the pad-mistake side view the near shoulder (the pad label's joint,
  under the ghost's shoulder dot) sits ~9 pt left of the "Arms on pad" pill, so its leader has no
  length there, which still reads.
- Glows: both biceps at full strength (the arms work together; centres (0.663, 0.306) and
  (0.488, 0.323)), and softer, the near elbow (0.589, 0.354) for the brachialis and
  brachioradialis.

## Ghosts

All use the Machine Biceps Curl's view (-0.5 from the framing's -1.0 is a true left side view,
where the elbows line up with the pivots); three reuse its pieces, the pivot ghost has its own:

- pivot `curlMachineSatLowToAnkles.seen(-0.5)` (new, in `faults_280_machinecurl.swift.txt`),
  read at the bottom: the Machine Biceps Curl's `curlMachineSatLow` (the body and upper arms 0.1
  torso lengths lower, the hands on the handle, the elbows re-seated) with the legs drawn to the
  ankles, as the Single-Arm Machine Curl's `leftCurlMachineSatLow`. In the side view the near
  base rail (x 0.32-0.40, y 0-0.07, nearer the camera than the near foot) hides the near foot,
  and `curlMachineSatLow`'s toe line (foot to `foot_*.tip`) was drawn over the rail. Worked by
  hand on the rig: the ghost elbow ends ~8 cm below and ~2.5-3 cm behind the hub at the bottom,
  ~1 cm under the pad's front underside, so the ghost upper arms pass through the pad (which the
  ghost ignores, as on the Single-Arm Machine Curl); ~1 cm below and ~4 cm in front of the hub
  at the top. The elbow-vs-hub read works: real elbow (0.534, 0.268), ghost elbow (~0.55,
  ~0.30) in the mistake view, clear of the pill.
- pad `curlArmsOffPad(25).seen(-0.5)`, top: the upper arms rise from 45° to 20° below
  horizontal.
- grip `curlWristsCurled().seen(-0.5)`, top.
- range `curlBottomCut(from: 0.8, to: 0.885).seen(-0.5)`, bottom: shoulder-to-wrist is 0.897
  torso lengths at the model's bottom (162°) and ~0.8 at ~122°, as on the Machine Biceps Curl.
- lower: tempo, no ghost (the red ring on the far elbow).

## Uncertain / not yet seen

- Activation shares are house values: no EMG study of a two-arm preacher curl machine was
  found, and the biceps-over-brachialis order is a house choice matching the other machine and
  preacher curls; no source settles the order (ExRx names the brachialis the target).
- None of the range-of-motion studies used a machine; the machine's own resistance curve is not
  modelled.
- Siblings (flag): the Machine Biceps Curl and the Single-Arm Machine Curl paint the brachialis
  the same bright red (`highlight_tiers22.json`, `SCRATCH/mpc/tiers_mbc.json`) but still rank it
  SECONDARY 0.66 in SampleData.swift, so their legends disagree with this entry's PRIMARY 0.72;
  not changed here (this family owns only its own files).
- Near-duplicate (flag): this model is the Machine Biceps Curl's machine, body, framing (yaw,
  zoom, offset within 0.001), timing and 162-62° elbow range, with the pad and pivots set higher
  (elbows 3.3 cm higher and 3.8 cm further forward, pad 27° vs 31°, upper arms 45° vs 55° below
  horizontal). The copy is worded apart from that entry's, but in the app the two read as the
  same exercise: the library thumbnails are nearly indistinguishable, both rows are ARMS ·
  MACHINE · BEGINNER with the biceps as primary muscle, and the Machine Biceps Curl's model is
  already a preacher-pad machine curl. For the user to decide (a distinct model, or one entry).
- Pivot ghost (flag): its upper arms pass through the pad, a known limitation shared with the
  Single-Arm Machine Curl. No source gives the mistake's direction (elbows below the pivots when
  the seat is too low), and in this model the elbows already sit at the pad's front edge, so the
  lower elbows can only be shown inside the pad.
- Model issue (flag): the arm pad's back ~8 cm sits inside the lifter's lower chest and upper
  abs (see Body above); it may show in the -0.5 side views, where the pad's near end overlaps
  the chest.
- The ghosts compile (`check_faults_280.py`) and were checked on app screenshots (2026-09-30):
  each draws its mistake visibly and the right way (pivot: the elbows under the hubs, the body
  lower; pad: the upper arms at ~20° below horizontal, the wrists in front of the face; grip: the
  hands folded ~50° toward the face; range: the forearms ~18° above horizontal at the bottom).
  The pad's back inside the chest does not show in the side views (the arms cover it).
