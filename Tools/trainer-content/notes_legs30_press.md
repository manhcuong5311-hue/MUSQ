# 30-leg set: leg presses (2026-09-28)

Five exercises from the HIKSEMI drive's "300-350/27_9" folder:
`spec_legs30_press.py` holds the copy,
`Tools/fault-review/faults_legs30_press.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_legs30_press.json` when to still them. The
spec's header lists the full citations; this file maps each claim in the copy
to them and records what the models show.

## Shared facts about the models

- All five are machine presses and the **pelvis never moves** (hip joints at
  the same place, pelvis and lumbar bones at the same angle all clip). Reps
  are read from the knee angle (the briefs' phases).
- Timing, identical in all five: sled down over ~1.1 s (0.12-1.12 s), knee
  within ~2° of its deepest bend for ~0.9 s (1.17-2.04 s), press over ~1.8 s
  (2.08-3.83 s); second rep 4.12-7.83 s.
- Knee 160° at the top (never locked) -> 95° at the bottom in all five.
- Hands on the handles beside the hips all clip (elbows 108°).
- Rig: torso (neck to pelvis) 0.59 m, hip joints 0.18 m apart, shoulder
  joints 0.40 m apart. Sled travel 0.21 m.
- Feet flat: the foot bone points ~24° into the plate in all five (re-measured
  in review 1 from foot_L's bone axis against the plate's face with pxr; on
  the vertical press the bone is 36° above level, which is where an earlier
  "~36°" in the spec header came from), the angle of a flat foot (the toe tip
  within ~1 cm of the plate's face, the ankle ~8 cm off it).
  No model lifts a heel. At the bottom the knee joint ends ~4 cm short of the
  toe tips along the plate, the kneecap about over the toes.
- Footplates (from the USD mesh): 45-degree presses, 1.1 x 0.63 m, face 33°
  back from vertical; vertical press, face ~12° off level. On both the ankle
  sits level with the plate's centre line, the toes toward the top (or head)
  edge: "the middle of the platform".
- Framing: the four 45-degree presses at yaw -2.0 and the vertical press at
  -2.2, rear three-quarter views from the lifter's left (25° and 36° past a
  true side view), the feet at the top left of the screen and the head at the
  right.

## Vertical Leg Press

Model: lying flat on the back pad (trunk 90° back), hips on the seat pad, the
sled running straight up and down above them. Ankles 0.40 m apart
(shoulder width), 0.10 m toward the head from the hips (feet about over the
hips), toes out ~7°. Hip (trunk-thigh) 74° -> 42°, the deepest hip bend of
the family.

- Activation Quadriceps 0.86 / Gluteus Maximus 0.48: **no EMG study of the
  vertical leg press was found.** Lying flat closes the hip further
  (trunk-thigh 42° at the bottom against 56° on the 45-degree press; the hip
  range is about the same, 32° against 33°). That is closer to Marchetti
  2023's upright 90° seat-back condition (less vastus lateralis, more biceps
  femoris, gluteus maximus unchanged; the reclined 125° back gave the larger
  hip range) than to its reclined one. Since the gluteus maximus did not
  change with hip angle, the glute row stays at 0.48 and the quadriceps row
  sits a hair under the 45-degree press (0.86). Extrapolated, not measured.
  StrengthLog's leg press guide ("2. Vertical Leg Press") suggests the deeper
  hip flexion "can lead to more activation of the glutes and hamstrings",
  but that is coaching opinion with no EMG behind it, and Marchetti 2023's
  measured gluteus maximus did not change with hip angle, so the row stays
  at 0.48. Stabilisers hamstrings, adductors, calves: ExRx (synergist
  adductor magnus, soleus; dynamic stabilisers hamstrings, gastrocnemius).
- Difficulty intermediate: StrengthLog ("Since the angles are steeper in the
  vertical leg press, it demands more technique and control from the
  lifter").
- Whole foot / heels down, push through heel and forefoot: ExRx
  (SLSingleLegVerticalLegPress: "Do not allow heel to raise off of platform,
  pushing with both heel and forefoot"). "The knees come down close to the
  chest" describes the model (hip 42°).
- Depth, about 90° at the knee or sooner if the hips start to lift: ExRx
  single-leg vertical press ("just before hips raise up from pad"; it also
  notes "Flexible hip flexion is required for fuller range of motion", kept
  here only, not in the copy); the existing Leg Press entry (roughly 90° or
  the hips start to lift, whichever comes first). Quadriceps work hardest
  around a right angle at the knee: Martín-Fuentes 2020 review (quadriceps
  activity greater with more knee flexion, peak at approximately 90°). That
  peak is the deepest angle those studies measured: the presses it covers
  started at "approximately 90° knee flexion", so nothing shows more
  quadriceps work beyond 90°, while Escamilla 2001 found all knee forces
  rising with flexion; hence the copy does not ask for more than about 90°.
  "The hips bend further than in a 45-degree press" is what the two models
  show (42° vs 56°), follows from lying flat, and agrees with StrengthLog
  (the vertical press "allows for a deeper hip flexion at the bottom of the
  movement").
- Hands on the handles, steadying the upper body: ExRx ("grasp handles to
  sides") and StrengthLog ("You can grasp the handles on either side of the
  seat ... to stabilize your upper body"); "helps keep the hips down on the
  pad at the bottom" is coaching reasoning. Pushing on the knees takes load
  off the legs: coaching convention, no study; worded mildly.
- Setup: safety stops just below the lowest point is standard machine
  practice (ExRx: "Re-engage support lever ... before dismounting"; the
  stops themselves are convention). Step 4 says "release the sled's catch"
  (the lock that holds the sled at the top), not "the stops", so it does not
  read as taking off the range stops set in step 2.
- Comparison HIPS CURLING UP: ExRx, StrengthLog (as deep as possible without
  rounding the back, glutes on the seat).

## 45-Degree Leg Press

Model: back pad 60° back from vertical, sled on 45° rails, feet
shoulder-width in the middle of the platform, toes out ~7°, hip 89° -> 56°.
The same exercise as the existing **Leg Press** (model LegPress, framed at
-0.6): the cues keep that entry's five (foot placement, knee tracking, range
/ depth, top lockout, back position), its labels where they fit
(Feet shoulder-width, centred; Knees track over toes) and its ranks
(quadriceps 0.87, gluteus maximus 0.48, stabilisers hamstrings, adductors,
calves).

- Quadriceps first, glutes second: Martín-Fuentes 2020 review (vasti most
  active, then rectus femoris), 2020 and 2022 inclined leg press studies;
  ExRx (target quadriceps, synergist gluteus maximus). The glute row is not a
  measured ratio; it keeps the old entry's value.
- Foot placement: mid-platform shares the work; higher shifts a little toward
  the glutes, lower toward the quadriceps: ExRx ("Placing feet slightly high
  on platform emphasizes Gluteus Maximus. Placing feet slightly lower ...
  Quadriceps"); Da Silva 2008 (at 80% 1RM, rectus femoris and vastus
  lateralis more active with the low placement, gluteus maximus with the
  high). The abstract reports the rectus femoris and gastrocnemius more
  active with the low placement than the high at both 40% and 80% 1RM, and
  the vastus lateralis (low) and gluteus maximus (high) differences only at
  80%; the Martín-Fuentes 2020 review summarises it more loosely (no
  high/low difference except the gluteus maximus at 80%). Escamilla 2001
  found no muscle or knee force difference between high and low placements,
  so the copy says "a little" and does not call a low placement harmful to
  the knee. "Too low, the knees travel far past the toes and the heels start to
  lift": mechanics (the lower the foot, the more the ankle must bend at a
  given knee angle) plus ExRx's "Do not allow heels to raise"; the ghost
  shows exactly that.
- Knee tracking: ExRx ("Keep knees pointed same directions as feet"),
  StrengthLog (knees not falling in). Toe angle made no difference: Escamilla
  2001 (feet straight vs 30° out: no difference in muscle activity or knee
  forces), Martín-Fuentes 2022 (0° vs 45°: no EMG difference; preferred
  stance advised). "At the bottom or on the way up" rather than one phase, as
  no source times it; the ghost is stilled at the bottom.
- Depth (DEPTH): quadriceps activity peaks around 90° of knee bend and falls
  as the knee straightens (Martín-Fuentes 2020 review); hips set the limit
  (ExRx: back support adjusted "without forcing hips to bend at waist";
  StrengthLog: "as deep as possible without rounding your back and while
  keeping your glutes on the seat"; excessive depth puts pressure on the
  lower back). Knee forces rise with depth: Escamilla 2001 (all knee forces
  increased with knee flexion; 0-50° suggested for minimising them), so "a
  shorter range is reasonable for sensitive knees".
- Lockout (LOCKOUT): quadriceps activity falls toward full extension
  (Martín-Fuentes 2020 review: vasti and rectus femoris decrease, biceps
  femoris and gastrocnemius increase near extension); not snapping the knees
  straight: StrengthLog ("stop the movement before overextending the knees";
  locking out adds pressure to the joints) and the old entry. The model stops
  at 160°, matching the cue. The risk wording is kept mild (no study
  quantifies injury risk from locking out on a leg press). ExRx's Q&A
  "Locking Out Knees on Leg Press" (2019-11-14 archive copy) argues that a
  controlled lockout is not inherently dangerous and that the widely shared
  hyperextension injury had other causes (a far too heavy load); the cue is
  therefore kept to not *snapping* the knees straight under a heavy sled,
  and the main reason given is the loss of quadriceps tension near
  extension (Martín-Fuentes 2020 review).
- Back position (BACK): StrengthLog ("have your lower back and butt still
  during the entire set"), ExRx ("back on padded support"), the old entry.
  Coaching convention; no EMG or load study.
- Setup: back pad set for ~90° without the hips lifting: ExRx (adjust the
  back support for near full range without the hips bending at the waist).
- Comparison FEET TOO LOW: ExRx (heels), mechanics above.

## Single-Leg Press

Model: the 45-degree press with the LEFT leg only; the left foot where it is
in the two-leg press (ankle 11 cm outside the hip); the right foot on a low
side foot rest (6-10 cm off the floor, right of the seat), right knee 82°,
hip 144°, still all clip.

- Activation as the 45-degree press: **no study compares the single-leg and
  two-leg 45-degree press**, and the review calls the unilateral leg press
  "hardly investigated". Stien 2021 (unilateral 6RM leg press): high vastus
  lateralis, gluteus maximus no different from a kickback. Gluteus medius as
  a stabiliser: coaching reasoning (one-sided load on the pelvis); the seat
  and handles hold the pelvis, and no leg press study ranks it high
  (Martín-Fuentes 2020, 2022: gluteus medius the lowest of the four muscles
  measured, two-leg press).
- Foot placement, "just outside the hip", "where it sits in your two-leg
  stance": the model. ExRx single-leg 45: one foot on the platform, the other
  foot on the floor; heel down, push with heel and forefoot; knee pointed the
  same way as the foot.
- Hip position: ExRx ("without forcing pelvis to bend at waist"; grasp the
  handles). "The lower back makes up the difference": reasoning from the
  one-sided load, not a measured finding.
- Knee tracking (KNEE_ONE): "the whole load goes through one knee, set off to
  one side of the sled" describes the model (the working ankle 0.20 m left of
  the midline); "a knee that follows the toes keeps that load lined up" is
  coaching reasoning with no study, as in the two-leg cue (ExRx: knee
  pointed the same way as the foot). The first draft's claim that the knee
  "tends to drift in as the rep gets hard" had no source and was removed.
- Setup "Set a load you can control on one leg" (step 1, before getting in):
  convention. The bilateral deficit (Hay 2006: two legs together produce
  less than the sum of each alone; Pisz, Blazek & Stastny 2026, 31 trained
  men: bilateral deficit ratio 5.16% bilateral and 14.29% split-load in 1RM
  leg press) means one leg can often handle more than half the two-leg load;
  the copy does not give a number.
- Comparison HIP LIFTING OFF THE SEAT: ExRx.

## Narrow-Stance Leg Press

Model: ankles 0.20 m apart (about hip width; hip joints 0.18 m apart), toes
~3° out, knees over the ankles (0.22 m apart at the bottom).

- Activation Quadriceps 0.87 / Gluteus Maximus 0.48: the quadriceps row is
  the 45-degree press's, unchanged, because stance width did not change
  quadriceps EMG in the leg press (Martín-Fuentes 2022: 100% vs 150% hip
  width; Escamilla 2001 found only a hamstring difference, wide > narrow with
  the feet high) or in the squat (Paoli 2009: only the gluteus maximus
  changed; McCaw & Melrose 1999: the quadriceps did not change with stance).
  Only Sinclair 2022, a musculoskeletal model of squats, gives the narrow
  stance more quadriceps force, and it is not used against the measured
  EMG. No leg press study measured the gluteus maximus by stance, and no
  squat study shows it lower at a hip-width stance than at shoulder width:
  Paoli 2009 reports the gluteus maximus higher only at the widest of its
  three stances (no lower value at the narrow one), and McCaw & Melrose 1999
  (narrow stance 75% of shoulder width) report a load-by-stance interaction
  for the gluteus maximus without its direction in the abstract. So the
  glute row stays at the 45-degree press's 0.48.
- "A narrow stance keeps each knee travelling in a straight line over its
  foot": coaching reasoning (knee over foot, as ExRx's knees the same way as
  the feet). "Stance width changed quadriceps activity little": Martín-Fuentes
  2022, Escamilla 2001 (only the hamstrings differed).
- "The knee forces shifted rather than fell: in one study the narrow stance
  put more compressive force on the knee, the wide stance more tension on
  ... the PCL": Escamilla 2001 (in the leg press, narrow stance greater
  tibiofemoral and patellofemoral compressive forces than wide; wide stance
  greater PCL tension). Given both ways so neither stance reads as the one
  that is easier on the knee.
- Feet touching, knees crowding: the ghost (ankles 4.4 cm either side of the
  midline, knees 5.6 cm) and coaching reasoning; the old Leg Press entry's
  "too narrow" foot mistake.
- Comparison FEET TOO CLOSE.

## Wide-Stance Leg Press

Model: ankles 0.68 m apart (1.7 times the shoulder joints; "about one and a
half shoulder-widths" in the copy), toes out ~17°, knees 0.47-0.51 m apart,
following the turned-out feet.

- Activation Quadriceps 0.87 (unchanged from the 45-degree press), Gluteus
  Maximus 0.54, Adductors LOW 0.34. Leg press EMG: stance width did not
  change the quadriceps (Martín-Fuentes 2022; Escamilla 2001), with more
  hamstring activity for the wide stance with a high placement (Escamilla
  2001); the squat studies agree for the quadriceps (Paoli 2009; McCaw &
  Melrose 1999), so the quadriceps row does not move. The glute and adductor rows come from
  squat studies: Paoli 2009 (only the gluteus maximus rose, at the widest
  stance; the adductor magnus did not change), McCaw & Melrose 1999 (stance
  width changed adductor longus and gluteus maximus activity, not the
  quadriceps), Sinclair 2022 (wide stance more posterior-chain force). **No
  leg press study measured the adductors by stance width**, so their row is
  LOW; ExRx lists the adductor magnus as a synergist and StrengthLog lists
  the adductors among the leg press's main muscles.
- "Can make room for a deeper rep": ExRx alternating 45 press
  (SLAlternating45LegPress, 2019-08-24 archive copy: "Wide stance may allow
  for deeper range of motion"); StrengthLog ("For some people, it might be
  hard to go deep enough with their feet shoulder-width apart, and therefore
  more suitable to widen the stance a bit").
- Knee tracking (KNEE_WIDE): Escamilla 2001 and Martín-Fuentes 2022 (toe
  angle no effect), ExRx (knees the same way as the feet). The mistake is
  "caving in toward each other, inside the line of the toes", not "inside the
  feet": in the correct model the knees already sit inside the ankles
  (0.47-0.51 m against 0.68 m), on the hip-to-ankle line.
- Stance mistake "wide but low, heels peel up": ExRx (heels), same mechanics
  as the 45-degree press.
- Comparison KNEES CAVING IN ("Knees cave in toward each other"): ExRx,
  StrengthLog.

## Model notes

- **Fixed pelvis.** Real lifters' pelvises tilt as the hips close; the rig's
  does not move at all, so the models never show the hips curling up. The
  copy teaches stopping before that point, and the depth ghosts draw what it
  looks like.
- **Vertical press depth.** The model reaches a hip (trunk-thigh) angle of
  42° with the pelvis flat on the pad. Many lifters' hips will lift before
  that; the copy says to stop before they do rather than to match the
  model's depth.
- **Knees at the bottom.** Every model stops at 95° at the knee with the
  knees about over the toes, roughly the "about 90°" of the copy and the old
  entry.
- **Soft top.** Every model stops at 160° at the knee, 20° short of straight,
  a little more bend than "almost straight"; the copy's "slight bend" covers
  it.
- **Short sled travel.** 0.21 m in every model, with the ~1.1 s lowering,
  ~0.9 s at the bottom and ~1.8 s press. The pause at the bottom is not a
  coached pause; the copy does not mention tempo.
- **Single-leg foot rest.** The model's idle foot rests on a low side rest;
  many machines have none, and ExRx puts that foot on the floor, so the setup
  says "the side foot rest or the floor".
- **Toe angles.** Read from the foot bones: ~7° out (shoulder-width and
  single-leg), ~3° (narrow), ~17° (wide). No sources require a particular
  angle; the copy says "slightly" / "a little".

## Ghosts and when to still them

Framings -2.0 (45-degree presses) and -2.2 (vertical): sagittal faults need
no turn (25° and 36° off side-on). Knees caving in turn toward a view from
behind the head. Vertical press: a total of -3.14, `.seen(-0.94)` (the knees
at v 0.47, well above the head at v 0.605). The four 45-degree presses
(knee faults and the Narrow "stance" fault): a total of -2.7, `.seen(-0.7)`.
Projected at the bottom (1.42 s) with probe.py's camera: at -3.14 the head
(0.42, 0.40) sat between the real knees (u 0.351 and 0.506, v 0.38) and under
the caved ghost knees; at -2.7 the head moves to u 0.58, right of the knees
(0.363 and 0.506), and the Narrow press's feet (u 0.285 and 0.385) clear it.

New pieces (documented in the swift text; prefixed with the family key
`press`): `pressFeetLow(_:by:heelUp:)`
(feet 0.2 torso lengths down the platform, then 10° up about the toes,
held all rep),
`pressHipsCurled` (hips 0.1 torso lengths off the seat and 0.03 toward the
head, lower back rounding), `pressHipLifted` (single leg: the working hip
0.14 off the seat, the pelvis 0.07), `pressHandsOnKnees` (vertical: hands
onto the thighs above the knees), `pressFeetTogether` (narrow: feet and
knees 0.1 in toward the midline), `pressLeftKneeSnapped` (single leg: only
the working knee straightens; `kneesSnapped` would also straighten the
resting leg). Reused: `kneesIn`, `heelsUp`, `kneesSnapped`,
`lowerBackArched(0.14)` (the old Leg Press's back ghost).

Checked with a Python port of `FaultGhost.solve` on the rig at the bottom
(1.5 s): `pressFeetLow()` moves the toes 12 cm down the plate (still on
it), lifts the ankle ~3.4 cm off the plate and moves the knee ~2.5 cm, now
~6 cm past the toe tips instead of ~4 cm short; the knee closes 95° -> 84°.
It is a setup fault (feet placed low), so since review 2 it holds all rep
(strength `.always`, like `pressFeetTogether`) instead of growing with the
knee's bend, which had the ghost feet sliding ~8.5 cm up and down the plate
each rep while the real feet stayed put. One FaultPose has one strength, so
the heel lift now shows at the top too; it was cut from 15° to 10° to keep
that small. At the top (0 s) the hip-to-ankle span shortens from 0.83 to
0.77 m and the knee re-seats at 133° instead of 160°, which is how bent the
knee would be with the feet that low at the same sled position. `pressHipsCurled` lifts the pelvis 5.8 cm off the
45-degree pad (5.6 cm straight up on the vertical press, 1.7 cm toward the
head), the knees closing to 84-85°. `pressHandsOnKnees` puts the near hand
at (0.14, 0.66, -0.43), on the thigh just above the knee at (0.14, 0.72,
-0.48), the elbow re-seated at 78°; at the top (strength 0.22) the hands have
barely left the handles. `heelsUp()` on the vertical plate moves the ankle
6 cm down (off the plate, which is above) and 6.5 cm toward the head.
`kneesIn()` on the Narrow press uses a smaller amount, 0.09 instead of the
default 0.17: its knees start only 0.11 m from the midline, and the default
(~9.5 cm each at the bottom) left them 1.6 cm from it, fused or passing
through each other and caving further than the feet-touching fault; with
0.09 they end 6.1 cm from the midline, just touching. The 45-degree, Wide
and Single-Leg presses keep the default (their knees start 0.14-0.25 m out).
`pressFeetTogether` leaves the ankles 4.4 cm and the knees 5.6 cm from the
midline at the bottom; it is a setup fault, so it holds all rep (strength
`.always`, as the older Leg Press's "feet" fault). `pressHipLifted` lifts the working hip 7.8 cm. `kneesSnapped` at
the top (strength 0.78) moves the knee 8 cm to 178°.

Every cue has a ghost. Still moments (fault_moments_legs30_press.json):
bottom for feet, knee, depth, hip, grip and the Wide press's stance;
lockout (the top, knees straightest) for lockout; any for back and the
Narrow press's stance (both ghosts are constant).

## Labels

Rows are written on the 0.14-0.86 scale and squeezed to 0.16-0.80 by
`spec_legs30.py`. 45-degree presses: the foot label top left above the
platform (the 28-character "Feet shoulder-width, centred" ends at u 0.51, over
the platform's top edge); the two knee labels on the right above the head
(0.16 and 0.32 on screen); the hip label at 0.48 on the left, ending at u 0.41
just short of the near thigh and hand; the back label at 0.64 on the right,
below the shoulders, a nearly vertical leader to the chest. Vertical press:
the foot label above the plate, the two knee labels top right, the hip label
bottom right (0.80, a leader across the seat to the pelvis; at 0.64 on
either side it covered the near arm or the head) and the hand label bottom
left, a short leader up to the near hand. Checked by drawing the laid-out
pills and leaders over the start and bottom stills; verify in the simulator.

## Uncertain

- No EMG data for the vertical press, the single-leg 45-degree press against
  the two-leg press, or leg press adductor activity by stance width; those
  rows are extrapolated as above.
- The glute row (0.48) is the old entry's value, not a measured ratio.
- ExRx was read through Internet Archive copies (2018-2019 snapshots); the
  live site blocks automated fetches.
- The "hands on the knees", "feet touching" and single-leg "lower back makes
  up the difference" points are coaching reasoning, not measured findings.
- `fault_times.py` reads a leg press's bottom and top from the smaller of the
  two knee angles; on the Single-Leg Press the resting right knee (82°, still)
  is always smaller than the working left (95-160°), so bottom, lockout and
  any all get the same arbitrary frame, and the foot, knee and hip ghosts
  (which grow with the left knee's bend) may be stilled with that knee near
  160°, hardly visible. It needs the knee that moves most over the first rep
  (or shin_L for this exercise), then the Single-Leg Press rows of
  bottoms.json regenerated (reported as a shared change; only the review
  stills are affected, not the app).

## Change log

- 2026-09-28: first draft of all five entries, their ghosts and moments;
  spec_legs30.py press OK; check_faults_legs30.py BUILD SUCCEEDED.
- 2026-09-28: corrected the header after measuring the footplate from the USD
  mesh (face 33° back from vertical, not perpendicular to the rails; the knee
  ends ~4 cm short of the toe tips, not past them), the thigh angle sign on
  the narrow press, and narrowed the wide-stance hamstring claim to Escamilla
  2001's wide-and-high condition.

## Change log (review 1)

- Vertical press activation: rewrote the Marchetti 2023 reasoning (the
  lying press has a more closed hip, like the upright 90° condition, not a
  larger hip range; gluteus maximus unchanged in either, so the rows stay).
- Single-Leg Press KNEE_ONE why: dropped the unsupported "nothing but the
  hip" and "tends to drift in"; now states the one-knee, off-centre load and
  marks the rest as coaching reasoning.
- Narrow and Wide presses: quadriceps back to 0.87 (leg press and squat EMG
  found no stance effect on it); only the glute row moves (0.45 / 0.54).
- Narrow stance why: Escamilla 2001's knee forces given both ways
  (compression narrow, PCL tension wide).
- Wide press: KNEE_WIDE mistake and why, and the comparison mistakeCue
  ("Knees cave in toward each other"), now describe caving toward each
  other, since the correct knees already sit inside the feet.
- Da Silva 2008 described from its abstract (rectus femoris and
  gastrocnemius differ at both loads; vastus lateralis and gluteus maximus
  at 80%) instead of "no overall difference". The reviewer's suggested
  wording ("only at 80%, not at 40%") was not used: the abstract reports
  rectus femoris and gastrocnemius differences at 40% too.
- Added Pisz, Blazek & Stastny 2026 and the ExRx lockout Q&A to the spec's
  sources; added the ExRx counterpoint to the Lockout bullet.
- Foot bone angle: re-measured with pxr, ~24° in both files (the 36° was
  the vertical press's bone angle above level).
- Setup: vertical step 4 says "release the sled's catch"; single-leg load
  choice moved to step 1.
- Ghosts: 45-degree presses' knee faults and the Narrow stance fault at
  `.seen(-0.7)` (total -2.7) so the head no longer sits between the knees
  (re-projected with probe.py's camera); `pressFeetTogether` is `.always`
  and stilled at "any"; helpers renamed with the `press` prefix. Not
  edited: fault_times.py (shared file; the Single-Leg Press knee choice is
  reported as a shared change).
- spec_legs30.py press OK; check_faults_legs30.py BUILD SUCCEEDED.

## Change log (review 2)

- Vertical press depth: the why now says the quadriceps work hardest around
  a right angle at the knee, "so lower to about there, or less if the hips
  start to lift first"; the correct cue says to lower to about 90° or stop
  sooner if the hips lift (the "more flexible hips allow a deeper rep" line
  moved to these notes only). The comparison's correct note follows. Notes:
  the review's 90° peak is the deepest angle its studies measured.
- Vertical press hands: the why now says the handles steady the upper body
  and help keep the hips down (StrengthLog), not that they anchor the lifter
  as the sled comes down. StrengthLog cited next to ExRx.
- Vertical press notes: StrengthLog cited for the deeper hip flexion and for
  "more technique and control" (the intermediate rating); its suggestion of
  more glute and hamstring work noted as unmeasured, the glute row kept at
  0.48 on Marchetti 2023.
- Narrow press glute row back to 0.48 (the reviewer's second option): Paoli
  2009 only shows a higher value at the widest stance, and McCaw & Melrose
  1999's abstract gives a load-by-stance interaction without its direction,
  so no study supports a lower value for a hip-width stance.
- Narrow stance why: "in a straight line over its foot" (not "up and
  down"), and "stance width changed quadriceps activity little" (Escamilla
  2001 found a hamstring difference).
- Wide press: SLAlternating45LegPress added to the spec's ExRx pages;
  StrengthLog's wider-stance quote added to the deeper-rep bullet.
- Spec header: Marchetti 2023 and Sinclair 2022 authors in full; Sinclair's
  widths as multiples of greater trochanter width; StrengthLog entry lists
  the points now cited.
- Ghosts: Narrow `kneesIn("*", 0.09)`; `pressFeetLow` made `.always` with
  `heelUp` 10 (option a; checked with the Python port of the solver at the
  top and bottom on the 45-degree, Wide and Single-Leg rigs).
- spec_legs30.py press OK; check_faults_legs30.py BUILD SUCCEEDED.
