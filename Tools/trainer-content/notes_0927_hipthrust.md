# Barbell hip thrust: notes (batch 2026-09-27)

Family file: `spec_0927_hipthrust.py` (var `barbellHipThrust`), ghosts in
`Tools/fault-review/faults_0927_hipthrust.swift.txt`. `python3
spec_0927_hipthrust.py` and `python3 spec_0927.py` both print OK; the ghost
pieces and table entry typecheck (`swiftc -typecheck`) when pasted into a
scratch copy of `FaultPoses.swift`.

## What the model shows (BarbellHipThrust, export 077)

Measured from the rig (joints every 0.25 s over the first rep; torso, neck to
pelvis, 0.59 m), the brief and the framing shots (yaw -0.7, three-quarter
from the feet on the lifter's left).

- Upper back on the long side of a low bench, top ~0.36 m. The bench edge
  sits under the top of the shoulder blades, about level with the shoulder
  joints; the neck and head lie over the bench.
- Barbell with a thick foam pad (0.44 m long) across the hip crease: ~2.5 cm
  toward the knees from the hip joints at lockout, ~10 cm at the bottom.
- Both hands on the bar just outside the pad (hands 0.60 m apart), elbows
  128-144 degrees; they steady the bar and do not push.
- Feet flat for the whole clip, ankles 0.40 m apart (shoulder joints 0.39 m
  apart, so about shoulder-width), toes turned out a little (~6 degrees on
  the foot bone; the brief says 10).
- The hips drive up from a trunk-thigh angle of 116 to 176 degrees, pelvis
  0.20 -> 0.48 m. At lockout knees, hips and shoulders are level (0.47-0.48 m,
  knee-hip-shoulder 179-180 degrees), the trunk is level with the floor, the
  shins vertical, knees 90 degrees (69 at the bottom; knee range 22 degrees).
- The spine keeps one gentle shape throughout (pelvis-spine-chest 172,
  spine-chest-neck 174 degrees at every sample): no added arch at the top.
- The head stays in line with the trunk (chest-neck-head 176 degrees), so at
  lockout it faces the ceiling; there is no chin tuck.
- The trunk turns 30 degrees over the bench edge; the shoulder joints shift
  3-6 cm toward the head as it turns, which is the pivot, not a slide.
- One rep every 4 s, top plateau 1.24-1.99 s (peak 1.75 s), bottom at 0 / 4 s.

Not written to (for the lead):

- **Knees inside the feet.** At lockout the knee joints are 0.26 m apart and
  the ankles 0.40 m (0.19 m apart at the bottom), so each knee sits ~7 cm
  inside its ankle and the shins angle out ~10 degrees seen from the feet.
  Contreras 2011 asks for the knees to track over the toes and not cave in.
  There is therefore no knee cue and no "knees over the toes" line anywhere
  in the copy. A re-export with the thighs abducted until the knees sit over
  the feet (knees ~0.40-0.44 m apart) would allow a knee cue with a
  `kneesIn` ghost, as on the Glute Bridge.
- Bench height 0.36 m, a little below ExRx's 40-46 cm. The copy says "low
  bench, secured so it cannot slide" and gives no number.

## Claims and sources

Hips (`pelvis`, "Hips up to a level torso")
- Hips rise until the torso is level with the floor; hold a one-count;
  lower under control: Contreras, Cronin, Schoenfeld 2011 (Strength Cond J
  33(5):58-61, doi:10.1519/SSC.0b013e31822fa09d). ExRx: extend the hips until
  straight.
- Gluteus maximus is the main hip extensor in this lift (the copy does not
  claim its share of the hip extension moment, which EMG cannot split
  between muscles): Contreras 2011 (primary hip extensor), Contreras 2015 (J Appl Biomech 31(6):452-458,
  doi:10.1123/jab.2014-0301), Andersen 2018 (J Strength Cond Res
  32(3):587-593, doi:10.1519/JSC.0000000000001826), Neto 2019 and 2020 (J
  Sports Sci Med 18(2):198-206 and 19(1):195-203), Brazil 2021 (PLoS One
  16(3):e0249307; extensor demand far greater at the hip than the knee or
  pelvis-trunk).
- "The end of the range, where the glutes are at their shortest" is
  anatomy (full hip extension). Deliberately not claimed: that tension or
  the hip moment is highest at lockout. Brazil 2021 found the hip extensor
  moment peaks early (~14% of the lift) and falls toward lockout, against
  the common belief.

Ribs / spine (`support_PectoralisMajor_Abdominal_R`, "Ribs down, spine neutral")
- Extension from the hips, not the lumbopelvic region; brace first; a slight
  arch is fine, excessive lumbar hyperextension may load the posterior
  spine; head and neck in line with the spine: Contreras 2011. The spine
  claim is expert guidance and cites spine-loading work, not injury data;
  the copy says only that a big arch under load "can add stress to the
  lower back". That the arch adds height through the spine instead of the
  hips is geometry, not a measurement.
- The mistake line describes what the ghost shows: the lower back bowing up
  above the line of the hips and shoulders at the top (the ghost does not
  move the bar).
- The head line follows Contreras 2011 and matches the model. Some coaches
  cue a chin tuck with the eyes forward at lockout; the model does not show
  it, so the copy does not ask for it.

Feet (`foot_L`, "Shins vertical at the top")
- Feet about shoulder-width, at a distance that gives a 90-degree knee and a
  vertical shin at the top: Contreras 2011; knees ~90 degrees at the top and
  shoulder-width feet: StrengthLog; shoulder-width: ExRx.
- Bent knees shorten the hamstrings so they help less (active
  insufficiency): Contreras 2011 (reasoning, not measured there).
- Feet further out: Collazo Garcia 2020 (J Strength Cond Res
  34(9):2449-2455, doi:10.1519/JSC.0000000000002859), 7 personal trainers at
  40% 1RM; EMG differed in every muscle except the gluteus medius. The full
  text is paywalled; the values come from Neto 2019, Table 2, whose row for
  this study has one value too few for its columns. Read as gluteus
  maximus, gluteus medius, semitendinosus, biceps femoris, rectus femoris,
  vastus lateralis, vastus medialis (the only order that matches the
  review's own summary: feet away raises BF and ST, lowers RF, VL and VM;
  the rotation variation raises GMax): biceps femoris ~41 -> 72 %MVIC,
  semitendinosus ~32 -> 70, vastus lateralis ~27 -> 11, vastus medialis
  ~35 -> 11, gluteus maximus ~55 -> 51. Neto 2019's text:
  feet forward raises hamstring demand "without changing gluteus maximus
  excitation". The copy calls it "one small study" and gives only the
  direction (hamstrings up, quadriceps down, no gain in glute activity),
  which Neto 2019's Table 1 and text state outright; the sizes depend on
  the inferred column order, so the copy does not say "far more". That
  bent knees leave more of the hip extension to the glutes is Contreras
  2011's active-insufficiency reasoning, not a measurement.
- Toes turned out a little: shown by the model; no claim is made that it
  changes muscle activity (Collazo Garcia's rotation variation, which raised
  gluteus maximus activity, combined its foot set-up with an intentional
  push into hip external rotation, so it is not the same thing).

Bench (`scapula_L`, "Back pivots on the bench")
- Upper back across the bench; the back hinges across it and sliding up
  and down is kept to a minimum: Contreras 2011 (placement slightly lower
  than a low-bar squat position). ExRx: upper back on the bench.
- "Sliding moves the hips away from the feet and changes the knee angle
  mid-rep" is geometry: with the feet planted, the body moving along the
  bench changes the hip-to-foot distance.
- The mistake line follows the ghost: the body slides toward the head, so
  the bench edge ends up lower on the back, near the bottom of the shoulder
  blades (in the ghost the edge sits ~14 cm hip-side of scapula_L at
  lockout, against ~2 cm in the model). The correct line and setup step 4
  put the edge near the top of the shoulder blades, where the model has it
  (about 11-12 cm down the spine from the neck joint; Contreras 2011:
  slightly lower than a low-bar squat position).

Bar (`hand_L`, "Padded bar in hip crease")
- Bar at the crease of the hips; pad it because the lift presses hard on the
  lower abdomen and pubic region, the thicker the better: Contreras 2011.
  Bar rolled back and centred over the hips, across the upper hip flexors
  and lower abdomen; thick padding if the pelvis and hip flexors do not pad
  it enough; hands on the bar keep it from rolling back near the top: ExRx
  (checked through search-result text in three separate searches; exrx.net
  blocks direct fetches). Pad between bar and pelvis: StrengthLog.
- The mistake (the bar rolling up onto the stomach) is placed near the top,
  as ExRx places it; at the bottom the trunk slopes up toward the head and
  the crease is a valley.

Activation (fractions are the app's relative bars, not %MVIC)
- Gluteus Maximus P 0.90: the target in every source; Contreras 2015 mean
  69.5 (upper) and 86.8 (lower) %MVIC at 10RM, above the back squat;
  Williams 2021 (J Strength Cond Res 35(1):16-24,
  doi:10.1519/JSC.0000000000002651) peak higher than back and split squat;
  Andersen 2018 above the hex bar deadlift (16% over the whole lift, 26% in
  the upper part) and not different from the barbell deadlift; Neto 2020
  "very high" (>60% MVIC). Contreras 2016 (J Appl Biomech 32(3):254-260,
  doi:10.1123/jab.2015-0091) found the barbell version above the band and
  American hip thrusts only for the upper gluteus maximus (69.5 vs 49.2 and
  57.4 %MVIC); lower gluteus maximus was similar (86.7, 79.2, 89.9).
- Hamstrings S 0.45: Contreras 2015 biceps femoris 40.8 %MVIC (about half
  the glute signal, above the squat); Andersen 2018 the barbell deadlift
  20% higher; ExRx dynamic stabilisers.
- Erector Spinae S 0.45, level with the hamstrings: second in Neto 2019's
  excitation order ("gluteus maximus, erector spinae, hamstrings, and
  quadriceps femoris"); the second-largest extensor moment (pelvis-trunk)
  in Brazil 2021, which sees it mainly resisting trunk flexion; no
  difference from the two deadlifts at 1RM in Andersen 2018; a stabiliser
  in ExRx. Not ranked above the hamstrings, which Contreras 2015 and
  Andersen 2018 measured directly.
- Quadriceps S 0.40: Contreras 2015 vastus lateralis 99.5 %MVIC, not
  different from the squat at 10RM; Brazil 2021 a real knee extensor
  moment; ExRx synergist, StrengthLog secondary; but Delgado 2019 (J
  Strength Cond Res 33(10):2595-2601, doi:10.1519/JSC.0000000000003290;
  8 trained men) squat far higher at 1RM, and Collazo Garcia 2020 low vasti
  values at 40%. Contreras 2015's 99.5 %MVIC is deliberately discounted
  against those two, so the bottom of the moderate band.
- Stabilisers adductors, gluteus medius, core: Contreras 2011 (adductors
  and posterior gluteus medius as secondary hip extensors), StrengthLog
  (adductors), ExRx (abdominals and obliques as antagonist stabilisers).
- No hypertrophy claim anywhere: higher EMG did not mean more glute growth
  in a training study (Plotkin 2023, Front Physiol 14:1279170,
  doi:10.3389/fphys.2023.1279170, similar to the squat). Barbalho 2020 (Int
  J Sports Med 41(5):306-310) is not cited: its data were flagged as
  improbable and a retraction was called for (Stronger by Science 2020),
  though it has not been retracted.

Comparison (ARCHING THE LOWER BACK) restates the ribs cue (Contreras 2011).
Setup follows the model and Contreras 2011 / ExRx / StrengthLog: floor, back
to the long side of a secured bench (Contreras 2011 asks for it secured),
bar rolled over the thighs into the crease, feet shoulder-width and close
enough for vertical shins at the top (Contreras 2011; the model's lockout
depends on it), toes out a little, bench edge across the shoulder blades,
hands either side of the pad.

## Labels

All five pills are pinned with `overrides` (rows on the 0.14-0.86 scale,
squeezed into 0.16-0.80 by `spec_0927.py`): ribs and bar on 0.14, hips on
0.26 (squeezes to 0.27, written as y 0.27), feet and bench on 0.86.

- Ribs tracks `support_PectoralisMajor_Abdominal_R`, on the top of the
  lower ribcage under the right end of the pad (at the bottom of the rep it
  sits at the pad's lower corner; check it there in the simulator). The
  `chest` joint lies inside the trunk behind the near hip, so from yaw -0.7
  its dot lands on the red hip muscles at lockout, on the flank at the
  bottom. `spine` and the lat anchors land in the same place; the _L and
  sternal pec anchors come within 10-21 pt of `hand_L`.
- Hips moved from 0.32 to 0.26: at 0.32 the pill's lower half covered the
  left end of the pad (the bar cue's object) on the top plateau and the top
  of the left plate. At 0.27 it clears the pad top (v ~0.32) by ~20 pt and
  overlaps the plate's top edge by a few points at most.
- Checked on all eight probed positions (29 pt pills): no crossings, no
  leader through a pill, the closest leader passes ~14 pt from the hips
  pill's corner (the ribs leader, at the bottom of the rep), the ribs and
  bar dots stay 35-40 pt apart, every dot is at least ~90 pt from every
  pill.

## Ghosts

All five cues have a ghost. The new strength `thrustLockout`
(`.between("pelvis", "foot_L", from: 0.9, to: 1.04)`) reads the lockout from
hip height: the pelvis-to-left-ankle distance runs 0.86 torso lengths at the
bottom to 1.06 at lockout, so faults of the top show fully on the plateau
(1.24-1.99 s), a third at 0.75 s, and not at all in the lower half.
`.whenStraight("thigh_L")` would not work here: it reads the hip angle from
the spine joint, which sits ~11 cm up the trunk while the hip joints sit
~9 cm to either side, so a straight hip measures ~145 degrees and the
strength runs only 0.30 (bottom) to 0.61 (lockout). No move uses `ahead`:
with the trunk tilted up toward the head at the bottom and level at the top,
`BodyFrame.ahead` points at the feet until ~0.6 s and at the head after.

Simulated with a Python port of `FaultGhost.solve` on the rig:

| cue | piece | at lockout | best still |
|---|---|---|---|
| hips | `hipsShortOfLockout(0.25, strength: thrustLockout)` | pelvis and bar 15 cm low (0.48 -> 0.33 m), hips 179 -> 148 degrees, knees and elbows re-seated | top |
| ribs | `thrustArched` (new; `bridgeArched`, larger) | spine joint 7 cm, chest 3 cm above the line | top |
| feet | `thrustFeetFar(0.22)` | ankles 13 cm further out, knees 91 -> 113 degrees, shins 19 degrees off vertical | top |
| bench | `slidUpBench(0.2)` | hips, trunk, arms and bar 12 cm toward the head, knees 91 -> 111 degrees | top |
| bar | `barRolledUp(0.28, strength: thrustLockout)` | hands and bar 17 cm toward the head, onto the stomach; elbows 144 -> 85 degrees; the bar line stays ~20 cm above the trunk joints, clear of the stomach | top |

No fault turns the model (`view` 0): the hip and spine faults move up and
down the screen, and the moves along the trunk's line show at about
two-thirds of their length from yaw -0.7 (a 13 cm move is ~23 pt). A turn
toward side-on would bring the near plate over the hips and hands.

Fault moments for `fault_times.py`:
`{"Barbell Hip Thrust": {"hips": "top", "ribs": "top", "feet": "top", "bench": "top", "bar": "top"}}`.
`fault_times.py` has no bridge class, so it reads this lift as a press (top =
elbows straightest). That lands right here, because the elbows open from 128
degrees at the bottom to 144 on the top plateau, but a bridge class keyed on
pelvis height (like `legs`) would be sturdier, and `bottoms.py`'s
`HIPS_HIGH` set could take "Barbell Hip Thrust" for the default still.

The bar ghost was first always on and read at the bottom. It now uses
`thrustLockout` like the others: the bar can only roll toward the stomach
once the trunk is near level (ExRx: near the top), and at the bottom the
old ghost showed a bar resting uphill on the belly. Simulated: 0 up to
0.5 s, a third at 0.75 s, 0.88 at 1.0 s, full on the plateau.

## Uncertainties

- The foot-distance numbers come from one study of seven people at 40% 1RM,
  read from a review's table (the paper is paywalled).
- Quadriceps and erector spinae ranks are genuinely mixed across studies
  (load, normalisation and electrode sites differ); the quadriceps sit at
  the bottom of the moderate band and the erector spinae level with the
  hamstrings (0.45), not above them.
- The spine-safety point is expert guidance, not injury data.
- The model's knees sit inside the feet (above); the copy avoids the topic
  and nothing describes the model's knees as correct. Both reviewers flagged
  it as a model issue: the main view, the CORRECT FORM comparison and every
  ghost show this knee position as the reference. A re-export of 077 with
  the thighs abducted (Blender source
  /Volumes/HIKSEMI/BLENDER/03_Dui_sau_Mong/077_barbell_hip_thrust.blend)
  would fix it and allow a knee cue.
- The ribs dot sits at the pad's lower corner at the bottom of the rep;
  confirm it reads as the ribcage in the simulator.
- Existing content, outside this family: the Glute Bridge and Single-Leg
  Glute Bridge ghosts that use `.whenStraight("thigh_L")` (`bridgeArched`
  and the inline hips faults) read 0.44 at the bottom and 0.56 at the top on
  the GluteBridge rig, so they barely fade out at the bottom, for the same
  reason as above. Other `.whenStraight("thigh_L")` faults (for example
  `leanedBackAtLockout`) likely cap near 0.6 too.
