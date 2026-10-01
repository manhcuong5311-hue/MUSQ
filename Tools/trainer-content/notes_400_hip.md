# 351-400 folder: frog pumps, cable adduction and the hip abductions (2026-09-30)

Seven exercises of the 351-400 folder (family "hip"): `spec_400_hip.py`
holds the copy, `Tools/fault-review/faults_400_hip.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_400_hip.json` their still moments. The spec
header lists the full citations; this file records what the models show and
maps each claim in the copy to its source.

## Shared facts about the models

- Evidence: briefs `briefs/<Resource>.md` and `briefs_legs/<Resource>.md`;
  stills `shots/view/<slug>_t{0.0,1.0,2.0,3.0,5.0}.png`; highlight tiers
  `tiers27.json`; joint projections `joints.json`. Joint positions were also
  read straight from the converted USD every 0.25-0.5 s (Blender's Python,
  `UsdSkel`, the stage kept alive while querying) for the angles, spreads
  and fault geometry quoted here and in the spec header.
- Rig: torso (neck to pelvis) 0.592 m, hip joints 0.18 m apart, thigh
  0.44 m, shin 0.40 m.
- Every clip: two 4 s reps in 8 s, the top at 2.0 s and 6.0 s.
- Framings (model map in SampleData.swift, which is the truth): frog pumps
  yaw -1.57 (side-on from the lifter's left; the briefs still quote the
  first-pass -1.0), cable adduction, standing abduction and banded abduction
  -0.3, side-lying abduction and clamshell 3.14 (from behind).
- Single-leg models: the LEFT leg works in the cable adduction (right leg
  standing), the standing abduction (right leg standing), the side-lying
  abduction and the clamshell (lying on the right side, the left leg on
  top). The setup steps say which leg works in the demo.
- These rigs probe no toe joints (`toe_L/R` empty), so no cue or glow uses
  them.
- Paint (tiers27.json): frog pumps gluteus maximus/medius/minimus bright,
  biceps femoris, semitendinosus, semimembranosus and erector spinae dim;
  cable adduction adductor longus, adductor magnus and gracilis bright;
  standing, side-lying and banded abduction and the clamshell gluteus
  maximus/medius/minimus bright. Activation rows follow it: bright = P, dim
  = S. Rows are only written where a source measured the muscle in that or
  a close exercise (see each section); a painted muscle with no usable data
  gets no row rather than an invented fraction (the gluteus minimus of the
  frog pumps, standing and banded abduction and the clamshell, the
  gracilis of the cable adduction).

## Frog Pump

Model: supine on a mat, soles pressed together (ankle joints 0.16 m apart,
each foot turned in 24 deg so the soles meet, the feet on their outer
edges), ankle joints ~0.38 m from the hip joints along the body. Knees 55
deg at the bottom, 73 deg at the top (inner angle), 0.87 m apart at the
bottom and 0.78 m at the top (the thighs ~50 deg out from the midline, close
to flat). The hips lift from 0.18 to 0.36 m (pelvis joint); at the top the
trunk slopes ~20 deg down to the shoulders and the pelvis sits ~10 cm above
the shoulder-to-knee line, i.e. the hips are as high as they go. ~1.2 s up,
~0.7 s hold (1.58-2.25 s), ~1.3 s down, ~0.8 s at the bottom. Spine shape
unchanged all clip (pelvis-spine-chest 172 deg, spine-chest-neck 174 deg).
Head on the mat in line with the trunk (not visibly tucked; the copy asks
for a slight tuck because the source does, and the ghost only shows the
head lifting). Arms flat on the floor out to the sides, palms down, elbows
~97-101 deg, hands beside the waist ~35 cm out.

Claims and sources:
- "Soles together, heels in", knees wide, lower back flattened, chin tucked,
  weighted with a dumbbell in the lap: Contreras 2016 (his frog pump
  guide). He says no EMG data exist for frog pumps, so every activation
  claim is borrowed from bridge studies and worded that way.
- "The gluteus maximus is the biggest muscle lifting the hips in a bridge,
  and it also turns the thighs out, the position the frog stance holds":
  anatomy (largest hip extensor, an external rotator). The study claim
  sits in the knees cue only (below), so the two cues do not repeat it.
- "At the top the hips are fully extended and the glutes at their
  shortest": anatomy; the model's top is its highest hip position. Not
  claimed: that tension peaks there.
- "Angling each thigh about 30 degrees out from the midline also lowered
  erector spinae activity and anterior pelvic tilt a little compared with
  keeping the thighs parallel": Kang 2016 (the angle is per thigh, patella
  to ASIS, so the thighs were ~60 deg apart; erector spinae 50.7 -> 46.8%
  MVIC, hence "a little").
- Heels in / knees well bent: "in single-leg bridges, bending the knee
  further cut biceps femoris (hamstring) activity by about two thirds while
  glute activity stayed about the same": Lehecka 2017 (135 vs 90 deg knee
  flexion: biceps femoris 23% vs 75% MVIC, the only hamstring measured;
  gluteus maximus 47% vs 51%, medius 57% vs 58%). "Can cramp": Lehecka
  2017 and Boren 2011 both report hamstring cramping in bridges.
- Knees wide: "the upper part of the gluteus maximus is favoured in
  exercises that add hip abduction or outward rotation": Selkowitz 2016
  (superior > inferior portion in those exercises). "Bridging with the
  thighs apart or pushed out against a band raised gluteus maximus
  activity": Kang 2016 (0/15/30 deg abduction of each thigh from the
  midline, highest at 30: 16.6 -> 20.3% MVIC); Kim 2018 (hips turned out 25
  deg); Choi 2015 (Thera-Band isometric abduction; note hamstrings and
  erectors were unchanged there, so no hamstring claim is made for the
  knees cue). The frog stance is far wider than any of them, so the copy
  does not claim a size.
- Head: coaching only (Contreras 2016: tuck the chin); no study. "Lifting
  it to watch curls the neck up and down on every rep": mechanics. The label
  reads "Head down on the mat", what the model shows; the slight tuck is
  asked for in the correct line and setup step 4 only.
- Comparison: "with the thighs parallel the lower back tends to work a
  little harder": Kang 2016 (erector spinae 50.7% at 0 deg vs 46.8% at 30).
- Activation: gluteus maximus 0.85 (library Glute Bridge 0.82, a touch
  higher for the abduction/rotation findings above); gluteus medius 0.40
  (bright in the paint but low in two-leg bridges: Moore 2020 pooled 18.8%
  MVIC; a band around the knees lowered it in Kennedy 2023's glute
  bridge); erector spinae 0.32, a touch under the Glute Bridge's 0.36
  (with the thighs angled out it was only slightly lower than in a plain
  bridge, Kang 2016: -8%, still above the gluteus maximus; Contreras
  credits the flattened lumbar spine for keeping the erectors out, which
  is coaching, not measured); hamstrings 0.30 (Lehecka's knee-bend effect;
  the frog knee is bent past 100 deg of flexion). The gluteus minimus is
  painted but has no bridge data for two legs; no row.

## Weighted Frog Pump

Model: the Frog Pump's legs, trunk and timing to the frame, plus a
dumbbell 0.34 m long (handle side to side) across the hips, centred over
the hip joints (0.36 m high at the bottom, 0.54 m at the top); both hands
hold it ~0.22 m apart near its ends, elbows 134 deg.

Claims and sources: as the Frog Pump for the feet, knees and back cues
(the same FROG_FEET / FROG_KNEES text). The dumbbell placement is
Contreras 2016 ("a dumbbell in the lap"). "The hands only keep it from
rolling" describes the model (elbows fixed at 134 deg all clip).
"Arching finishes the rep with the lower back instead of the hips" is
mechanics (the ghost bows the lumbar spine up; the dumbbell does not move).
Activation, estimated (no study loads a frog pump): every Frog Pump row a
little higher for the load, gluteus maximus 0.87 (between the Frog Pump's
0.85 and the library Barbell Hip Thrust's 0.90, beside the Single-Leg Glute
Bridge's 0.86), gluteus medius 0.42, erector spinae 0.34 and hamstrings
0.32 (both still under the Glute Bridge's 0.36).

## Cable Hip Adduction

Model: stands on the right leg (knee 174 deg), side-on to a cable stack
~1.1 m to the lifter's left, low pulley at ankle height, cuff on the left
ankle. Left hand on an upright post between lifter and stack, at waist
height (hand 0.20 m above the hip joints, elbow 103 deg); right arm hangs.
The left leg stays straight and ~11 deg forward; from ~28 deg out (the foot
~11 cm off the floor; the ankle joint 0.19 m up against the standing
ankle's 0.08) it sweeps to ~16 deg past the midline at 2.0 s, the foot ~14
cm past the body's midline and ~17 cm in front of the standing foot, and
back by 4.0 s. Trunk upright and pelvis level all clip. Knees 0.40 m
apart out, 0.09 m crossed (0.67 / 0.16 torso lengths).

Claims and sources:
- Setup, "upper body still", slight bend in the standing leg, return with
  control: StrengthLog (cable machine hip adduction); the cuff on the ankle
  nearest the stack and the leg crossing in front: the builder's reference
  (Muscle & Strength, blocked to automated fetches; the StrengthLog page
  says the same about the near leg and the low pulley).
- "The adductors pull the leg in toward and across the midline": anatomy.
- Twisting/leaning helps swing the foot without more hip work, hip drop
  tilting the leg across, a bent knee shortening the cable's lever, the
  cable drawing the leg out wide stretching the adductors: geometry and
  mechanics, not measured.
- Setup names the working leg: the left, nearest the stack, standing on
  the right.
- Comparison: gracilis, adductor longus and magnus together: anatomy;
  Lovell 2012 found all three most active with the hips at 0-45 deg in
  squeeze tests.
- Activation: adductor longus 0.85 first (Serner 2014: standing adduction
  against an elastic band was one of the two dynamic high-intensity
  adductor longus exercises; exact values in the paywalled full text were
  not read, so none are quoted); adductor magnus 0.62, moderate but still
  P for the paint (Collings 2026: the open-chain lying leg lift loaded the
  longus and brevis more, tier 2, than the magnus and gracilis, tier 3,
  the lowest; Hides 2016: the magnus was recruited more than the longus in
  a weight-bearing task, i.e. closed-chain work is what favours it). The gracilis is painted bright but "Gracilis" has no MusclePart
  keyword (validate() rejects it), so it is named in the comparison copy
  instead of a row.
- Jensen 2014 (elastic-band adduction training raised eccentric adduction
  strength 30%) is background only; the copy does not cite it.

## Standing Hip Abduction

Model: faces two upright rails with handles at lower-chest height, a hand
on each (elbows ~100 deg). Stands on the right leg (knee 174 deg). The left
leg, straight, lifts straight out to the side (no flexion, no turn of the
foot) to 30 deg at 2.0 s (foot ~11 cm off the floor, 0.42 m out) and lowers
by 4.0 s. Trunk upright, pelvis level all clip. Feet 0.31 torso lengths
apart together, 1.04 at the top.

Claims and sources:
- Setup and cues: NHS OPAL standing hip abduction (hold a support, hip,
  knee and foot forward, body straight, whole leg straight out to the side,
  hold 2 s, lower slowly).
- "The gluteus medius above all lifts the leg": Moore 2020 (main abductor
  in the reviewed exercises); anatomy.
- "The standing leg's gluteus medius holds the pelvis level, and in one EMG
  study it worked harder than the lifting leg's": Bolgla 2005 (42% vs 33%
  MVIC). Sinsurin 2015 (n=9) did not compare the legs in a matched
  direction: its moving-leg peak (64.7% MVIC) came with the leg moved 30
  deg off the side-on line, the standing leg's in pure side abduction.
- Hip hiking handing the lift to the waist muscles: mechanics here; the
  side-lying evidence (Cynn 2006) is cited only in the side-lying copy.
- "The thigh abducts only about 45 degrees before the pelvis starts to
  tip": ACE side-lying abduction guidance (the thigh abducts to about 45
  deg; beyond that the whole hip moves). "A lift of around 30 degrees, as
  here": the model's 30 deg; Boren 2011's side-lying version also lifts to
  ~30 deg.
- Toes forward: "turning the foot out rotates the hip outward, and in
  side-lying tests that raised tensor fasciae latae activity": Lee 2013
  (lateral rotation: more TFL), McBeth 2012 (abduction with external
  rotation: TFL 71% vs medius 53%). "A hip flexor that also lifts the leg
  sideways": anatomy.
- Setup: two rails with handles, one hand on each, as the model (no chair
  alternative, which has no two handholds at chest height).
- Activation: gluteus medius 0.78 (Bolgla 2005 33% moving / 42% standing;
  Sinsurin 2015's 64.7% was a diagonal lift, not this one; relative within
  the exercise it is the main mover; library Cable Hip Abduction 0.80);
  gluteus maximus 0.42 (upper fibres join abduction: Selkowitz 2016; about
  half the medius in side-lying: DiStefano 2009; library Cable Hip
  Abduction 0.42). The gluteus minimus is painted but no study measured it
  in a standing leg lift: Ganderton 2017's standing data (55% / 49%) are an
  isometric outward push on both feet, feet flat, in 10 postmenopausal
  women, so no row.
- Layout: the rails' uprights run down the screen at u 0.18-0.22 and
  0.54-0.58; every pill stays off them (two short labels top-left above the
  handles, three on the right beside the hip, where the lifted thigh stays
  left of u 0.70 at those heights).

## Side-Lying Hip Abduction

Model: on the right side, both legs straight and stacked in line with the
body, hips and shoulders stacked (the hip line stays vertical all clip).
The top (left) leg lifts in the frontal plane only to 32 deg at 2.0 s (ankle
0.34 -> 0.78 m high) and lowers by 4.0 s; no forward drift, no turn of the
foot, no pelvic tilt. Head in line with the spine, held ~10 cm off the mat
with nothing under it (hence "the head stays in line", not "rests"); lower
arm bent on the floor, its hand in front of the face; top hand on the floor
in front of the chest.
Feet 0.31 torso lengths apart stacked, 1.08 at the top.

Claims and sources:
- Setup, stacked hips and shoulders, head in line, knee straight, foot
  neutral, lift until the hips begin to tilt, "raising the leg too high is
  a frequent error" and "past the hip's own range the pelvis tilts":
  ACE side-lying hip abduction. Boren 2011's version:
  leg to ~30 deg, neutral or slight hip extension, toes forward.
- Leg path: "with the hip turned out, the tensor fasciae latae was more
  active than the gluteus medius": McBeth 2012 (71% vs 53%); Lee 2013
  (lateral rotation raises TFL). Letting the leg drift forward: Boren 2011
  (substitution by the TFL through hip flexion, their discussion).
- Rolling the hip back turning the lift into a forward swing: geometry,
  with the TFL/hip-flexor point above.
- Waist: "holding the lower back still halved quadratus lumborum activity,
  nearly doubled gluteus medius activity and cut the pelvic tilt by more
  than half": Cynn 2006 (QL 60 -> 28% MVIC, gluteus medius 25 -> 46%,
  lateral pelvic tilt 13.9 -> 5.6 deg, with a pressure biofeedback unit).
- Activation, on one scale with the Clamshell (both ranked on the %MVIC
  the same studies measured in the two lifts): gluteus medius 0.86
  (DiStefano 2009 81% MVIC, best of 12; Boren 2011 63%; McBeth 2012 70% in
  its abstract, 79% in its results text); gluteus minimus 0.58 (Moore 2019
  fine wire 43% posterior, 38% anterior per Moore 2020); gluteus maximus
  0.50 (DiStefano 39%, Boren 51%, McBeth 25%: about what it is in the
  clam).

## Banded Hip Abduction

Model: seated upright on a flat bench (top 0.52 m), hips ~72 deg flexed,
knees 108 deg, feet flat 0.38 m apart (about shoulder width) and fixed. A
mini band around the lower thighs just above the knees. Both knees open
together from 0.36 to 0.68 m apart (0.60 -> 1.15 torso lengths; top
1.5-2.5 s) and close by 4.0 s. Arms straight down, hands resting on the
bench beside the hips. Trunk still.

Claims and sources:
- Band just above the knees, sit upright, push out, no upper-body or back
  motion: The Prehab Guys (seated hip abduction with band); the builder's
  other reference, the King's College Hospital NHS guide, was not opened.
- "Pushing the knees apart works the side glutes": de Almeida Paz 2022
  (seated machine; it recorded only the gluteus medius and TFL). "The
  upper fibres of the gluteus maximus pull the same way": anatomy; no study
  measured the gluteus maximus in seated abduction (Selkowitz 2016 found
  the superior portion favoured in exercises with abduction, none of them
  seated). "Rocking adds momentum, so the hips do less of the opening":
  mechanics.
- "A seated abductor machine drew as much gluteus medius activity as
  side-lying abduction and the clam, with less tensor fasciae latae than
  side-lying abduction": de Almeida Paz 2022. The band version was not
  studied; the machine is the closest measured position.
- Band placement: "just above the knees the band sits where the thighs
  spread furthest": geometry (the knee end of the thigh travels furthest).
  "In band walks, moving it down to the ankles and feet raised gluteal
  activity": Cambridge 2012 (the gluteus medius rose at each step down, the
  gluteus maximus only with the band at the feet). "Seated with the feet
  planted a band at the ankles would barely stretch, so progress with a
  heavier band instead": the model's fixed feet; advice, not measured.
- Feet planted: model fact plus coaching; no study.
- Comparison: "rocking back throws the knees apart with momentum, so the
  glutes do less of the work against the band": mechanics (the knees still
  part only by the hips abducting; momentum helps).
- Activation: gluteus medius 0.78 (de Almeida Paz 2022; the library Hip
  Abduction Machine 0.82); gluteus maximus 0.54, beside the library
  machine's 0.52, ranked from anatomy since no seated abduction measured
  it. The gluteus minimus is painted but no seated
  abduction measured it; no row.
- Ghosts: the band cue has none (the band is not a tracked joint); it falls
  back to the red ring.

## Clamshell

Model: on the right side, hips ~51 deg flexed, knees ~80 deg (inner angle),
feet stacked together in line with the hips. The top (left) knee opens from
0.16 to 0.36 m above the bottom one at 2.0 s while the ankles stay
together; the pelvis and trunk never roll. Lower hand folded under the head
(the forearm under the front of the head, the hand ~4 cm from its centre
line), top hand on the floor in front of the chest. Knees 0.27 torso
lengths apart closed, 0.61 open.

Claims and sources:
- Setup: Boren 2011 (hips ~45 deg, knees bent, feet together); Cambridge
  University Hospitals NHS (neutral spine, deep abdominals engaged, knees
  open with the ankles together, the pelvis must not roll back, the glass of
  water image).
- "The gluteus maximus, the back of the gluteus medius and the deep hip
  rotators beneath them": Ganderton 2017 (fine wire: posterior medius
  moderate, anterior and middle low) and Moore 2020's discussion (the
  posterior segment has an external rotation moment arm); the deep
  rotators by anatomy (the clam is a resisted outward turn of the hip, so
  they are movers here, not stabilisers). "About equally active in the clam": DiStefano 2009 (medius
  40% / 38%, maximus 34% / 39%), Boren 2011 (47% / 53%), McBeth 2012 (33% /
  34%). "In most studies more active than the tensor fasciae latae":
  Selkowitz 2013 (fine wire, gluteal-to-TFL index 115, the highest of 11),
  Sidorkewicz 2014 (medius dominant, ratio far greater than side-lying),
  Willcox 2013 (TFL low); McBeth 2012 found the TFL about equal to the
  medius and the anterior hip flexors higher, hence "most".
- Hip angle: "the hip angle makes a small difference: gluteus medius
  activity was highest with the hips bent to about 60 degrees and lowest
  with them straight": Willcox 2013 abstract (medius greatest at 60 deg).
  The values (pelvis neutral ~22.5% at 60 deg, ~21% at 30, ~17% at 0) are
  read from Moore 2020's data table, not Willcox's paywalled full text;
  Moore calls the hip-angle effect minimal, hence "small". The intro,
  correct line and setup say 45 to 60 deg: Boren 2011 used ~45, Willcox's
  best was 60, and the model sits at ~51.
- Pelvis: "with the pelvis rolled back, gluteus maximus and medius activity
  both dropped": Willcox 2013 abstract; the 35 deg recline (used for the
  rolled-back ghost) is from Moore 2020's data table.
- Heels: "keeping the feet together makes the knee opening a turn of the
  hip outward; letting the top foot rise with the knee lifts the whole leg
  instead": mechanics, matching the ghost (the foot ~9 cm up, the knee
  still open). No number is quoted: Boren 2011's clam progression 2 (knees
  kept together while the top foot lifts, a pure inward turn) drew gluteus
  medius 62% and maximus 12% against 47% / 53% in progression 1, and
  progression 3 medius 68%, so it does not show the foot lift is worse for
  the glutes, and it is not the model's fault.
- Activation, on one scale with the Side-Lying Hip Abduction: gluteus
  medius 0.62 and gluteus maximus 0.58, both moderate (still P for the
  paint) and about equal (DiStefano 40/34% and 38/39%, Boren 47/53%,
  McBeth 33/34%; Moore 2020: low to moderate). The medius sits well under
  side-lying's 0.86 (81/63/70% there), the maximus about side-lying's 0.50
  (39/51/25% there), a touch above for McBeth. The gluteus minimus is
  painted but barely works in the clam on fine wire (Moore 2019 3% / 8%;
  Ganderton 2017 7% / 20%; Moore 2020: "may not have great utility"); no
  row. Stabilisers: obliques, quadratus lumborum, core (the deep rotators
  move the hip here).

## Ghosts (faults_400_hip.swift.txt)

Checked on the rig with a Python copy of `FaultGhost.solve` (body axes,
shift/turn/resolve, strengths) before writing; the moves below are the
checked sizes. All pieces are prefixed `hip`.
- Frog pumps: top read from pelvis-to-left-ankle 0.74 -> 0.84 torso lengths
  (0.67 bottom, 0.86 top) because the spine-hip-knee angle stays 128-132
  deg with the thighs splayed. Short: hips ~12 cm low. Arched: lumbar
  ~7 cm up (pelvis, hands and dumbbell unmoved, so the mistake lines say
  arching, not the dumbbell rising). Feet far: ~13 cm along the floor
  (`ahead` points to the head for a face-up lifter), seen at +0.7 since
  side-on the slid toes ran off the viewport's left edge. Knees in: ~16 cm up
  and ~21 cm in at the top, with the top strength (none at the bottom),
  seen at +0.9. Head up: ~10 cm. Weighted: `hipsShortOfLockout(0.2)` (the
  hands and dumbbell sink with the hips) and `barRolledUp(0.25)` with the
  top strength (hands ~15 cm toward the head, 5 cm down onto the stomach at
  the top; none at the bottom).
- Cable adduction: "in" strength knees 0.45 -> 0.22 torso lengths. Twist
  25 deg (shoulders ~8.5 cm), view +1.3 (front-right: the chest turns
  toward the camera and the ghost's shoulders open wider than the
  lifter's; at -0.6 they turned into the line of sight and the ghost
  collapsed to a sliver with the post-side elbow folded across the waist). Haul 10 deg toward the post (head
  ~12 cm). Hip drop: the pelvis and left leg tilt 12 deg about the right
  hip (left hip ~4 cm down, the foot ~16 cm further across on screen, the
  toes ~7 cm above the floor). Knee bent 45 deg (ankle ~29 cm back), the
  toes turned back up 30 deg at the ankle so they stay at floor height
  instead of ~3 cm under it, view -0.6 (at -0.9 the post and the stack's
  rods stood in front of the lifter). Short: 10 deg back out, the foot
  stops on the body's midline (~14 cm short).
- Standing abduction: "out" strength feet 0.45 -> 0.95. `leanedAway(12)`,
  `seatedRocked(-15).seen(-0.9)` for leaning onto the rails (head ~18 cm
  forward, hands fixed), hike ~5 cm, swung 12 deg higher to 42 deg (foot
  ~10 cm up; at 20 deg the ghost's foot ran off the viewport's right edge
  in the lifted mistake view), toes turned out 45 deg.
- Side-lying: "up" strength feet 0.45 -> 1.0. Swung 18 deg higher; leg
  forward 25 deg with the toes turned up (view 1.1, from the feet end);
  rolled back 35 deg (Willcox's recline), hips and shoulders, view 1.1;
  hitched: the pelvis and top leg tilt 12 deg about the bottom hip (a
  lateral pelvic tilt, Cynn 2006's 13.9 deg unstabilised), the top hip ~4
  cm toward the head and the leg ~12 deg higher (a plain 8 cm slide toward
  the head read only as a small shift along the body); head lifted ~9 cm.
- Banded: "apart" strength knees 0.75 -> 1.08. `seatedRocked(12)` and
  `heelsUp()` at view -1.1; knees ~7 cm short each; hips up: the pelvis and
  trunk rise ~6 cm while the shoulders, arms and hands stay put (the arms
  are nearly straight, so lifting the shoulders too would stretch them
  ~10%), the knees re-seat ~3 cm, seen face-on so the rise runs up the
  screen between the arms. The band cue has no ghost.
- Clamshell: "open" strength knees 0.40 -> 0.58. Short: the knee ~3 cm
  open instead of ~19; foot lifted ~9 cm; `hipRolledBack` (shared with the
  side-lying), hips straightened 30 deg; the forward-and-back ones at view
  1.1. The arched-back (brace) cue has no ghost and falls back to the red
  ring: lying on the side the arch bends the spine in a level plane, which
  a camera turned about the vertical sees edge-on from every side (the
  `lowerBackArched(0.1)` ghost drew a flat row of dots). The hip-angle
  ghost has the same limit (the hip bends in the level plane): it reads
  only as the legs drawn back in line with the body.
- Stills (fault_moments_400_hip.json): the top of each rep, except the
  clamshell's hip-angle fault at the bottom (no brace entry: no ghost).
- Visual QA (2026-10-01, simulator stills + an offline copy of the solver
  with the viewport's projection, the mistake view's 0.935 scale and lift
  and each fault's turn, matching the stills' ghosts to the pixel): the
  changes above, and the label moves below.

## Layout

Checked against the stills with every pill and leader drawn over t=0 and
t=2 (`preview_400.py hip` for rows and sides). Rows after the 0.16-0.80
squeeze. No pill covers the moving leg, the trunk or the equipment:
- Frog pumps: labels above (0.16-0.25) and below (0.68-0.73) the flat body
  band (0.39-0.58); the Weighted Frog Pump's dumbbell label on the top row
  right, the dumbbell topping out at 0.39. The knee label moved from 0.30
  to 0.24: in the knees-together mistake view (turned 0.9) the ghost's
  near knee rose onto its text; the hip label moved up to 0.16 to keep a
  gap.
- Real pill widths run ~5-15% over `width()` (~6.2 pt a character), and a
  leading pill wider than its label point allows is pushed right
  (`TrackedCallout.anchor`), so "Sweep across" really ended at u 0.297,
  not 0.274; the clearances below use measured widths.
- Cable adduction: trunk and post labels top-right (0.16, 0.26); the trunk
  label moved there because the twist ghost, seen from the front-right,
  swings the right shoulder into the top-left row. "Hips level" left at
  0.56, ending ~3 pt short of the standing thigh at every moment; the thigh's
  edge runs straight down there, so a higher row gains nothing and 0.54
  would meet the hand. The range label is now "Full sweep" at 0.65 left:
  at 0.73 "Sweep across" covered the front of the working shoe in its own
  mistake view (the lifted model's foot crosses at 0.69-0.76), and at
  0.80 it met the cuff at the top of the rep; 0.65 clears the standing
  knee by ~0.07. "Leg straight" moved right at 0.65 (over the post, ~6 pt
  clear of the working knee when it is out wide), since left under the
  range label its leader would cross the range label's.
- Standing abduction: see its section.
- Side-lying: range label top-left, leg-path (0.16) and waist (0.30)
  labels top-right, pelvis and head labels below (0.69). Before, the range
  label's leader ran under the leg-path label (0.30 left), the leg-path
  ghost's ankle landed on that label's text in its turned view, and the
  pelvis (top-right) and waist (bottom-left) leaders swapped sides across
  their two neighbouring dots; now the pelvis leader comes from the left
  and the waist leader from the right. The lifted foot tops out at 0.39.
- Clamshell: hip-angle (0.16) above the knee label (0.28) on the left, so
  the hip-angle leader passes ~0.03 right of the knee label instead of the
  knee leader running under the hip-angle label; the knee label stays
  above the lifted model's open knee (0.33) in its mistake view. The top
  hip sits straight above the pelvis, so the pelvis label went below the
  mat (0.80, under the heel label at 0.69) and its leader comes up from
  below instead of grazing the top-hip dot from above.
- Banded: top-left and top-right beside the head, two short labels left of
  the right arm (ending by u 0.245), the foot label at 0.80 left of the
  right ankle. Its bottom-right corner meets the end of the bench's base
  plate. No row fits cleanly: from 0.74 to 0.79 the pill meets the right
  shin once the knees open, at 0.80 only the plate's end, and a shorter
  word saves no width ("Feet down" is as long).
