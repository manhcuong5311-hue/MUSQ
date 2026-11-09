# Fault ghosts, family "female" (2026-11-09)

Vertical Hack Squat, Standing Hinge Kickback, Incline Bench Cable Kickback:
the female model's lifts of the Desktop "Women exsercise" folder, coached on
2026-10-29..31 with no ghosts. Ghosts in `faults_1109_female.swift.txt`
(pieces prefixed `female1109`), stills in `fault_moments_1109_female.json`
(seconds). `check_faults_1109.py --only female`: BUILD SUCCEEDED.

## Method

- Joints read with Blender's Python (pxr) from the app models, frame =
  1 + 24 * seconds. One female rig: torso (neck to pelvis) 0.507 m, so 0.1
  torso lengths = 5.1 cm.
- Every ghost solved with a Python port of `FaultGhost.solve` (shift, turn
  with the `_R` mirror, straighten, resolve, the `.tip` and `.heel` points,
  the strength gates) at its still, and re-solved at every frame of the
  8 s clip (two reps) on every model it is shown on (the hack squat's five
  stance models): limb bone lengths ghost vs model, and each knee's and
  elbow's bend direction against the model's at that frame. Result: no
  knee or elbow bent backward at any frame; bones kept to 0.0% except the
  hinge kickback's locked standing knee (+0.9% at most, the straightened
  leg spanning a hair more than its bones).
- Each view checked on Blender Workbench renders of the model at the
  fault's total yaw with the ghost drawn over it (session scratchpad,
  not kept).
- On-screen sizes below are estimates in points of the 382x655 trainer
  viewport in the mistake view: the app scales the model to `zoom` over the
  body's longest extent (hack squat 1.87 m, hinge kickback 1.51 m, incline
  kickback 2.00 m), the camera sees 1.176 units of height (32° at 2.05),
  and the mistake view shrinks the model to 0.935 (`roomBelow` 0.26): about
  284, 192 and 135 pt per metre.

## Vertical Hack Squat

Model `FemaleVerticalHackSquatStandard` (stances High, Low, Wide, Narrow
share the cues and ghosts), framing yaw -1.0. The rig faces +x, so -1.0 is
a front three-quarter from the lifter's right, 33° off face-on. Rep 4 s:
top at 0 and 4 s (knees 167°), bottom hold 2.0-2.25 s (knees 88°; High 78°,
Low 99°, Wide 82.5°, Narrow 93.5°); the trunk stays vertical (0.5°); feet
flat on the plate at ±13.1 cm (Wide ±19.8, Narrow ±7.6), toes ~7° out. The
machine: the carriage's shoulder pads and loading plates sit at shoulder
height either side, a front column stands ~75 cm ahead of the toes on the
midline.

| cue | ghost | still |
| --- | --- | --- |
| pad | `female1109TrunkFolded(25).seen(0.6)` | 2.0 |
| grip | ring-only | - |
| depth | ring-only | - |
| knees | `thruster500KneesIn(0.2)` | 2.0 |
| feet | `female1109ToesOut(40).seen(-0.3)` | 2.0 |

- **pad** ("shoulders lift off the pads so the trunk folds forward out of
  the carriage"): the trunk and shoulders tip 25° forward about the pelvis,
  drawn as spine plus the shoulder line, without the arms (the hands hold
  handles beside the head; `leanedForward`'s swung arms crossed the trunk
  in a zigzag on the render). Gate `.withBend("shin_L")`: 1.0 at the bottom
  (0.9 on Low, 0.96 on Narrow), 0.14 at the top. At 2.0 s the shoulders
  ~19 cm forward and ~4 cm down, the head ~26 cm forward (~50-69 pt). View
  +0.6 (total -0.4, 23° off side-on from the lifter's right): from the
  framing the fold ran 57% along the line of sight. The near side's loading
  plate covers the model's shoulders from there; the yellow trunk reads over
  it.
- **grip** ("hauling on the handles"): ring-only, a matter of force; the
  hands stay on the handles either way (as the Belt Squat's "hands" and
  the Cable Knee-Drive Kickback's "grip").
- **depth** ("dropping fast into the bottom and bouncing"): ring-only, a
  matter of speed (as the Pendulum Squat's and V-Squat's "tempo").
- **knees**: the shared thruster piece the female Hack Squat uses: each knee
  0.2 torso lengths (~10 cm) toward the midline, re-seated so the thigh,
  shin and knee angle are kept (87.7° stays 87.7°). Gate `.withBend("shin_L")`.
  As framed: the knees' side-to-side line is 33° off the screen's, ~21-27 pt
  each; on Narrow the ghost knees end ~3 cm apart, not crossing.
- **feet** ("turning the toes out to feel the inner thigh"): both toe tips
  swing 40° out about the ankles (`.up` axis, negative = out on both
  sides), the heels in place; a setup fault, `.always`. Each tip ~13 cm
  (~11.5 out, ~6 back). View -0.3 (total -1.3, 15° off face-on): from the
  framing the right foot turned toward the camera; face-on the front column
  stands between the feet. ~27-37 pt per tip. (The shoes sit low behind the
  plate's lip and the storage horns from this level camera; the yellow feet
  carry the read.)

## Standing Hinge Kickback

Model `StandingHingeKickback`, framing yaw -1.0. The rig faces +z; -1.0 is
a front-left three-quarter, 33° off side-on, the working (left) leg toward
the camera. The trunk is held 67.5° forward of vertical (22.5° above level)
all clip, both hands on the cable column's upright (elbows 138° left, 151°
right); the right leg stands on a plate, knee 160°. Rep 4 s: the left leg
hangs at 0 s (knee 154°), top at 2.0 s (knee 170°, thigh 8° below level,
the ankle 1.04 m up), held ~1.75-2.25 s.

Gates (`.between` on the ankles' spread, 0.36 torso lengths hanging, 2.61
at the top): `female1109HingeKickTop` 1.9 -> 2.5 (none until ~1.25 s, 0.66
at 1.5 s, 1.0 for 1.75-2.25 s); `female1109HingeKicking` 0.6 -> 2.5 (none
to ~0.5 s, 0.45 at 1.0 s, 1.0 from 1.75 s). The hip's own bend
(`.whenStraight("thigh_L")`, as the Cable Knee-Drive Kickback uses) reads
only 0.17-0.57 on this rig and peaks mid-kick, since the trunk is tipped.

| cue | ghost | still |
| --- | --- | --- |
| kick | `female1109HingeKickArched.seen(-0.57)` | 2.0 |
| knee | `female1109HingeHeelCurled.seen(-0.57)` | 2.0 |
| hips | `female1109HingeHipOpened.seen(-2.14)` | 2.0 |
| torso | `female1109HingeTrunkDropped.seen(-0.57)` | 2.0 |
| stance | `female1109HingeUpOnToe.seen(-0.57)` | 2.0 |

- **kick** ("swinging the leg as high as it will go and letting the lower
  back arch"): the mid-spine sags 0.16 (~8 cm) toward the floor and the
  chest 0.07, the left leg swings 25° further up about the hip: the thigh
  ~17° above level, the ankle ~41 cm higher (~80-90 pt; the spine ~16 pt).
  KickTop gate. View -0.57 (total -1.57, side-on from the left).
- **knee** ("locking the knee out at the top, or bending it so the heel
  comes toward you instead of the leg going back"): drawn as the second
  half: the thigh 25° down about the hip and the foot 80° up about the knee,
  the knee 170° -> 90°, the thigh 33° below level, the ankle ~29 cm nearer
  the hips and ~20 cm higher (~68-80 pt). The lockout half has no room: the
  model holds the knee at 170° at the top, so locking it moves the knee
  ~4 cm (a triangle of 0.47 and 0.49 m bones), on the model's own leg.
  KickTop gate; side-on.
- **hips** ("the working hip rolling up and open at the top"): the hips and
  left leg turn 22° about the trunk's long axis (the left hip ~3 cm up
  toward the ceiling), then the leg 22° out about the hip: the ankle ~22 cm
  out to the left (~42-61 pt). KickTop gate. View -2.14 (total -3.14, from
  behind): from the side the drift runs along the line of sight; rear
  three-quarters (-2.5, -2.8) laid the ghost leg on the model's.
- **torso** ("starting upright and folding further forward as the set goes
  on, so the trunk swings with each rep"): the trunk, shoulders and elbows
  turn 20° down about the pelvis, then the elbows re-seat so the hands stay
  on the upright: the back about level (2.5° above, from 22.5°), the head
  ~20 cm lower (~40 pt), elbows 138°/151° -> 119°/129°, bones kept. Turning
  the elbows with the trunk before re-seating matters: re-seated from where
  they were, the right elbow flipped backward from ~1.5 s (found by the
  whole-clip check). Kicking gate, so the ghost trunk dips and rises with
  every kick (the swing). The upright direction has no room: with the
  hands on the upright the arms run out of reach within ~8°. Side-on.
- **stance** ("rising onto the standing toe, or letting that knee lock"):
  both at once: the right foot turns 30° heel-up about the ball (`toe_R`),
  the hip rises 0.16 (~8 cm), and the knee re-seats straight on the
  hip-to-ankle line (160° -> 180°, never past it at any frame; bones up to
  +0.9%). The foot is drawn ankle - heel (`foot_R.heel`) - ball, so the
  lifted heel shows (~9 cm). At 2.0 s the knee ~9 cm back and up; ~15-18 pt
  each, the smallest ghost of the family (22° and 6.6 cm, tried first, read
  small at this framing's 0.556 zoom). KickTop gate; side-on (the left leg
  is up behind at the top, so the standing leg is clear).

## Incline Bench Cable Kickback

Model `InclineBenchCableKickback`, framing yaw -1.3. The rig faces -z;
-1.3 is side-on from the lifter's right (the working leg toward the
camera), ~15° behind. Chest-down on a pad 44.5° from vertical; the resting
left leg lies along the pad, knee 117°, foot off the end; arms on the
machine (right elbow 166°, left 76°). Rep 4 s: the right knee folded under
at 0-0.25 s (80°), top 1.75-2.1 s (knee 172°, the thigh 26° below level).

Gate `female1109InclineKickTop`: `.between("foot_R", "foot_L", 0.9 -> 0.55)`,
the right foot coming back up beside the resting left one (1.90 torso
lengths at the bottom, 0.49 at the top): none until ~1.15 s, 0.27 at 1.25 s,
1.0 from 1.5 to 2.4 s, none again from 2.75 s.

| cue | ghost | still |
| --- | --- | --- |
| cuff | ring-only | - |
| finish | `female1109InclineLegFlung` | 2.0 |
| hips | `female1109InclineHipRolled.seen(1.3)` | 2.0 |
| trunk | `female1109InclineChestUp` | 2.0 |
| support | `female1109InclineRestingLegPushed.seen(2.87)` | 2.0 |

- **cuff** ("strapping the cuff over the shin, or loose"): ring-only, where
  the cuff sits is the attachment's setting, not a body position.
- **finish** ("snapping the leg out and letting the pelvis roll over to get
  it higher"): the right leg 36° further up about the hip, the thigh ~10°
  above level instead of 26° below (the copy's correct finish is the thigh
  about level with the hips, so the ghost has to clear level), the ankle
  ~59 cm higher (~80-86 pt); the pelvis rolling over drawn as a lower-back
  arch, the mid-spine 0.12 (~6 cm, ~8 pt) and the chest 0.05 toward the
  pad. The ghost foot stays below head height, inside the frame. As framed.
- **hips** ("the working hip rolling up and over"): the hips and right leg
  turn 22° about the trunk's long axis (positive here: the pivot is the
  pelvis, so the right hip comes up off the pad, ~3.5 cm), then the leg 22°
  out about the hip (mirrored for `_R`): the ankle ~19 cm out to the right
  (~25-39 pt). View +1.3 (total 0, from behind): from the side the drift
  runs at the camera. The cable column stands behind the lifter there; the
  yellow reads on it. (Total -0.3 laid the ghost leg nearer the model's.)
- **trunk** ("pushing the chest up off the pad"): the chest, head and
  shoulders turn 24° up about the mid-spine: the head ~21 cm, the shoulders
  ~14 cm up (~18-27 pt). Spine and shoulder line only: the right arm is
  near straight on the machine, so re-seating it under lifted shoulders
  would draw its bones long. As framed.
- **support** ("the resting leg drifting or pushing, so the hips shift a
  little on every rep"): the hips and the whole left leg slide 0.07 (~3.5
  cm) up the pad, then the left foot turns 30° down about the knee (117° ->
  147°): the ankle ~23 cm lower (~31-44 pt), bones kept. View +2.87 (total
  1.57, side-on from the left): from the framing the resting leg is the far
  one and lies behind the working leg at the top.

## Not solved / open

- Hinge kickback "knee": only the heel-curl half of the mistake is drawn
  (see above).
- Hinge kickback "torso": only "folding further forward" is drawn, not
  "starting upright" (no room with the hands on the upright).
- Not shot on the simulator (this round's rule); the views were judged on
  Blender renders, where the app's perspective camera and lighting differ.
