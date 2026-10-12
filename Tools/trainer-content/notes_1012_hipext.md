# Notes: family hipext (Desktop "300-400" folder, 2026-10-12)

Five exercises: Cable Pull-Through (383), Standing Cable Hip Extension (387),
Reverse Hyperextension (388), Single-Leg Back Extension (389), 45-Degree Hip
Extension (390). Spec: `spec_1012_hipext.py`; ghosts:
`Tools/fault-review/faults_1012_hipext.swift.txt` (new pieces prefixed
`r1012hipext`); moments, all in seconds:
`Tools/fault-review/fault_moments_1012_hipext.json` (`fault_times.py` files
none of the five names under a kind of its own, so every moment is given).

## How the models were read

- `$LAB/r1012/hipext/dump.py` (Blender's Python + pxr) wrote every joint's
  world position and the Y/Z axes of a few bones every frame (192 frames) for
  the five rigs; `an.py` and `m1.py`-`m10.py` measured angles, `phases.py`
  the still and moving stretches from a per-frame angle, `eq.py`, `near.py`,
  `stack.py` and `eqproj.py` the equipment (bounds at given times, what lies
  near a joint, the weight stack's plates, screen boxes through the framing),
  `skin.py` skinned body meshes for contacts (pad, shoes, hands), `be_pad.py`
  the bench pad against the hips, `lever.py` the cable's moment arm, and
  `ghost.py` / `gdefs.py` / `grun.py` port `FaultGhost.solve` to size the
  ghosts (bone lengths, knee bend, screen offsets through the framing).
- Angle conventions: knee = thigh-shin inner angle (180 straight); hip = the
  thigh against the pelvis-neck line in the body's own side view (0 in line,
  + flexed, - extended); trunk = pelvis-neck line from vertical; thigh =
  hip-knee line from straight down. One body: neck to pelvis 0.592 m, hip
  joints 0.18 m apart, shoulder joints 0.39 m apart, thigh 0.444 m, shin
  0.398 m.
- The briefs (`briefs_1012/`), `tiers.txt`, `joints.json` and the trainer
  stills (`$LAB/r1012/stills/`) were read first; the numbers below are my own
  re-measurements and agree with the briefs. The Standing Cable Hip
  Extension's brief was written at yaw -1.35; the app (and joints.json) use
  -1.8.

## Model facts used in the copy

Cable Pull-Through
- Back to a cable column; the low pulley's axle 0.20 m up, 0.96 m behind
  the ankle joints, on the midline (`GYM_M29_PulleyAxle_L`, z -0.958);
  a rope (`GYM2_CableRope_*`) whose cable runs forward between the legs.
  "about a metre in front of the pulley", "facing away from a low pulley".
- Rope ends held with the palms facing each other (hand +z axes point at
  the midline, -x for the left hand, +x for the right): "palms facing each
  other". Hands 4 cm above hip-joint height and 18 cm in front of the hips
  standing; between the thighs ~17 cm above the knees at the bottom.
- Ankles 0.40 m apart, shoulder joints 0.39 m: "about shoulder-width"; feet
  turned out ~12 deg (brief): "toes turned out a little".
- Standing: trunk 0-3 deg, knees 164 deg (16 bent), shins 5 deg forward.
  Bottom: trunk 75 deg forward (15 above level), hip flexed 100 deg, knees
  155 deg (25 bent), shins vertical (-0.3 deg). "tips about 75 degrees
  forward", "knees go only from about 16 to 25 degrees of bend", "shins stay
  upright". The pelvis travels 14 cm back and 3 cm down.
- Spine segment angles constant (171/174/176 deg): the back keeps its shape.
- Elbows 156 deg standing, 142 at the bottom: "about 156 degrees standing
  and 142 at the bottom".
- Timing (trunk angle): standing to 0.17 s, down 0.17-1.58 s, held
  1.58-2.04 s, up 2.04-3.17 s, standing 3.17-4.17 s: "pause briefly" (the
  bottom hold), "the stand between reps lasts about a second".
- Stack (`stack.py`): pinned at plate 08; its bottom face 0.564 m standing,
  0.372 m at the bottom, plate 07's top 0.339 m: the plates rise 19 cm and
  stay 3.3 cm off the rest of the stack at the bottom: "the lifted plates
  stay about 3 cm above the rest of the stack".
- Cable leverage (mechanics, worked from the hand, hip and pulley-axle
  positions): the line of the cable from the hands to the pulley passes ~7 cm
  from the hip joints standing (below them) and ~28 cm at the bottom, so the hips still carry a flexion moment at the top, larger
  at the bottom. Supports StrengthLog's "no rest at the top" line.

Standing Cable Hip Extension
- Ankle cuff (rig meshes `GYM2_CableAnkleCuff_*`) just above the LEFT ankle
  (band 0.13-0.26 m up, ankle joint 0.10), the swivel eye at its front; the
  cable to the column's low pulley (axle 0.20 m up, x -0.045, z 0.37: ~0.35 m
  in front of the hips). "ankle cuff just above your left ankle", "low
  pulley".
- Both hands round the column's upright (`GYM_M29_Rail_L`, 7 cm from the
  left wrist; the skinned hands reach either side of it), palms facing each
  other, wrist joints at y 1.09 m, elbows 117 deg: "hold its upright with
  both hands at about waist height", "elbows bent". (Review: the draft said
  chest height; the hand meshes span 1.04-1.14 m, the middle of the rectus
  abdominis (0.88-1.29 m), 6-17 cm under the pectorals' lowest point
  (1.20 m).)
- Right leg: knee 175 deg, thigh 2 deg forward, all clip: "stand tall on the
  right leg", "almost straight". Trunk 8.6 deg forward, pelvis fixed: "about
  9 degrees", "stays still".
- Left thigh 18 deg in front of vertical (knee 160) at rest -> 28 deg behind
  (knee 174) at the back, the knee 149 deg mid-swing (0.88-0.96 s and
  2.96-3.04 s): "from about 18 degrees in front of vertical to about 28
  behind it", "160 ... 149 ... about 174". Hip 27 deg flexed -> 19 deg
  extended against the trunk line.
- At rest the left toe joint is 3 cm and the ankle 2 cm higher than the
  right's (on the floor): "the left foot just off the floor in front of you"
  (ExRx: "foot is slightly off floor").
- Timing (thigh angle): rest to 0.33 s, back 0.33-1.67 s, held 1.67-2.17 s
  (0.5 s: "about half a second"), forward 2.17-3.67 s, rest 3.67-4.33 s.
- Cable leverage (`lever.py`): the cable's moment arm about the left hip at
  the back of the kick is 0.68 m with the model's straight knee and 0.55 m
  with the ghost's knee bent to ~119 deg (the cuff ~25 cm higher): "lifts the
  cuff and shortens the cable's leverage on the hip". Mechanical reasoning
  on the model, no source.

Reverse Hyperextension
- Plate-loaded pendulum (`HG_RH_Pendulum`, plates on horns at x +/-0.47-0.5
  m), its pivot near the hips' axis (arm top at y ~1.15-1.30, z ~0); the
  strap (`HG_RH_AnkleStrap`) round both lower legs 6-11 cm above the ankle
  joints: "strap ... just above the ankles".
- Lying face down; torso pad 0.94 m up, z 0.18-0.68; the pecs on it (0.937),
  the rectus abdominis 3 cm above it, the pad's end (z 0.18) about the upper
  belly, the hip joints (z 0) 18 cm past it: "chest on the pad", "hips off its
  end", "well past its end so the legs hang free".
- Hands on the front grips (`HG_RH_GrabGrip`, y 0.68-0.71, z 0.95-0.99),
  elbows 167 deg: "hold the grips ... arms long", "nearly straight".
- Trunk level and still (89.6 deg from vertical all clip), spine joints
  still: "the trunk stays still on the pad".
- Both legs together, knees 176 deg all clip: "about 176 degrees".
- Thighs 4 deg toward the head of straight down hanging (hip 94 deg) -> 3
  deg above level (hip -3 deg) at the top: "travel about 97 degrees, from
  hanging straight down to about 3 degrees above level" (review: the draft
  said "from just under the pad", but the hanging feet are 3 cm toward the
  head of the hips, which sit 18 cm past the pad's end).
- Timing: hanging to 0.29 s, up 0.29-1.71 s (1.4 s), held 1.71-2.12 s
  ("just under half a second"), down 2.12-3.71 s (1.6 s), hanging 3.71-4.29
  s ("about half a second").

45-Degree Hip Extension and Single-Leg Back Extension (the same bench)
- `GYM2_BE_Root_001`: two hip cushions on a 45-degree frame; their top edge
  9 cm below the hip joints along the body's long axis, carrying the thighs
  from 9 to 39 cm below them (`be_pad.py`; the skinned thigh front within
  ~1.5 cm of the pad face): "its top edge sits about 9 cm below the hip
  joints", "just below your hip crease".
- Foot plate at 45 deg; the ankle roller's axis 6 cm up the shin from the
  ankle joint and 10.6 cm off the shin line (radius ~6.8 cm), on the back of
  the lower leg (review: the soleus mesh touches the roller, the shoe soles
  within 0.3 cm of the plate): "the roller behind your lower calves", "both
  feet flat on the plate". Feet 18 cm apart (hip joints 18 cm). (The draft
  quoted "about 6 cm above the ankles" and "about hip-width apart" here;
  neither is in the copy.)
- Arms crossed on the chest: each hand's fingers point across the body (the
  left hand at x -0.03, the right at x +0.03), elbows 79-90 deg: "arms
  crossed on the chest".
- 45-degree: knees 178 deg; trunk 44.6 deg from vertical (in line with the
  legs, hip -0.4 deg) -> 109.6 deg (19.6 below level), hip 64.6 deg: "to
  about 20 degrees below level", "about 65 degrees". Every spine segment and
  the pelvis bone turn the same 65 deg: a flat-back hinge.
- Single-leg: the left foot on the plate under the roller (knee 178); the
  right thigh on the pad, knee 115 deg, the right ankle at y 0.83 m, ~22 cm
  above the roller's top (0.605), all clip: "the right leg stays off the
  plate, knee bent and foot lifted behind". Trunk to 116.6 deg (26.6 below
  level), hip 71.6 deg: "about 27 degrees below level", "about 72 degrees".
- Timing (both): top to 0.29 s, down 0.29-1.71 s, held 1.71-2.12 s, up
  2.12-3.71 s, top 3.71-4.29 s ("hold for a moment" at the top).
- The trunk passes level at ~45 deg of hip flexion (t ~1.2 s), about
  two-thirds of the way down: "comes in the lower part of the rep".

## Sources and what each supports

All opened 2026-10-12; full texts were read where marked.
- Dicus et al. 2023, Int J Exerc Sci (full text, PMC10124728) -> pull-through
  back cue ("worked the lower-back muscles less than a Romanian deadlift",
  "half of each lift's estimated maximum"); reverse hyper lowering cue ("both
  stayed active on the way down": eccentric GM 36, BF 56 %MVIC at a 2-0-2
  tempo, "worked at two seconds up and two seconds down" (the draft's "a
  slow, even tempo"), "a pendulum reverse hyper like this one": a
  plate-loaded pendulum machine, as the model's);
  activation rows of both.
- Andersen et al. 2021, J Sports Sci Med (full text, PMC8057707; re-read in
  review on jssm.org) -> 45-degree hinge cue ("heavy 45-degree extensions
  done with a straight back drew more activity from the biceps femoris, one
  of the hamstrings, than Romanian deadlifts did, and more glute activity in
  the top half of the rep": 6RM loads, BF +71% whole movement, GM +74% upper
  part, the Technogym 45-degree Roman chair, "back had to be straight with a
  natural sway"; only the biceps femoris was measured, so the draft's
  "more hamstring activity" now names it); 45 and single-leg activation
  rows. Its "started in an upright position" is not explicit about the top,
  so the top cue now cites one lab study (Schellenberg) instead of "the lab
  studies".
- Schellenberg et al. 2017, BMC Sports Sci Med Rehabil (full text,
  PMC5404334) -> bench hinge cue ("a lab study on a 45-degree bench, the
  hip-led version loaded the hips and lower back more than curling down
  through the spine": larger Mb,max and Mh,max for BEh); "set the bottom of
  each rep just before the spine started to bend" (instruction 5a); top
  ("as soon as your upper body is in line with your legs", instruction 6);
  free-leg cue ("raised the peak load on the working hip by more than a
  third": Mh,max 1.1 vs 0.8 Nm/kg; "its glute activity with it": GlutMax 22.7
  vs 16.5 %MVC concentric, p .001); depth cue ("the hips work hardest around
  where the trunk passes level": Mh,max at the reversal point, whose RoMh of
  ~30-36 deg on that 45-degree bench puts the trunk near level; the
  background's "highest loading conditions (i.e., when the upper body is
  horizontal)"); single-leg activation rows.
- Stevens et al. 2022, Int J Exerc Sci (full text, PMC9362892) -> 45 and
  standing-hip-extension activation notes only (mean BFmed and BFdist above
  the RDL for the 45-degree hip extension and the cable kickback; mean GMax
  above the Nordic and leg curl).
- Oh et al. 2007, JOSPT (abstract) -> standing hip extension torso cue and
  reverse hyper back cue ("In a study of face-down leg lifts, drawing the
  belly in cut the pelvis's forward tip from about 10 degrees to 3 and more
  than doubled the glute's activity, while the lower-back muscles worked far
  less": APT 10 -> 3 deg, GM 24 -> 52 %MVIC, ES 49 -> 17).
- Liu et al. 2022, Physiother Theory Pract (abstract) -> reverse hyper knees
  cue ("in maximal hip-extension tests, the hamstrings' share was highest
  with the knee fully straight").
- ExRx (Wayback snapshots listed in the spec) -> Cable Standing Hip
  Extension: cuff, low pulley, hands on a bar, leg straight with the foot
  slightly off the floor, extend the hip; target GM, synergist hamstrings,
  stabilisers ES, obliques, QL, gluteus medius/minimus ("the gluteus maximus
  as the target muscle and the hamstrings helping", the stabilisers).
  Lever Reverse Hyper-extension: strap above the ankles, torso on the bench,
  handles, legs hanging straight, hips extended as high as possible with
  nearly straight legs, "some individuals ... through the lower back, in
  which case, Erector Spinae also becomes synergist" ("Some lifters also bend
  through the lower back, which hands part of the lift to the back muscles");
  target GM, synergist hamstrings, ES stabiliser, rectus abdominis and
  obliques antagonist stabilisers (stabilisers row). 45 deg Hyperextension:
  pad high enough to spread the weight on the thigh, not so high it limits
  the range, abdomen not pressing on the pad when lowered (pad cue); lower
  to a mild stretch or the torso about perpendicular to the legs (depth
  cue's "another guide"); arm position sets difficulty (arms cue). Single
  Leg 45 deg Hyperextension: one heel under the brace, the other leg just
  above; "Easier: ... performing exercise with both legs" ("with both legs
  the same lift is easier"); arms higher harder. Targets/synergists for the
  bench activation notes.
- StrengthLog -> Cable Pull-Through: rope on a low pulley, back to it, cable
  between the thighs, a few steps forward, hinge at the hips letting the
  rope go back between the thighs, extend the hips to stand; "you won't get
  the same rest in the top position that you often get with free weights"
  (top cue); primary glutes, secondary lower back, hamstrings, adductors
  (stabilisers: adductors). Reverse Hyperextension: hips at the edge of the
  pad, handles, brace, neutral back, legs up to the line of the body or
  slightly above, squeeze and hold a moment, lower slowly (range, lowering,
  grip cues). Back Extension: top pad against the top of the thighs so it
  does not hinder leaning forward ("that will decrease the movement in your
  hip"), arms crossed, up to a straight line, hold a second, no momentum
  (pad, top, arms cues). Cable Glute Kickback: brace, keep the body still,
  push the leg "as far up as you can without rotating in the hips" (torso
  and hips cues: "One guide's cue for cable kickbacks is to push the leg
  only as far as it goes without the hips rotating"; the draft's "the usual
  cue" rested on this one page).
- BarBend (Dewar, updated 27 Nov 2024) -> pull-through: no slack; arms
  straight so the cable does not cause friction in the groin, "don't pull
  through your arms — let your glutes and hamstrings do the work" (arms cue);
  knees slightly unlocked, back flat, shoulders back and down (hinge, back);
  pause briefly at the furthest point (hinge: "pause briefly"); squeeze as you
  rise, end in the identical position (top); widen the stance (stance).
- Garage Gym Reviews (McLean, updated 20 Sep 2023) -> pull-through: lowest
  pulley, walk forward until the stack separates; A. Bacon: "The biggest
  mistake most people make is not stepping forward adequately enough",
  "you lose tension as your hips travel back" (stance cue: "one coach calls
  not stepping far enough forward the biggest set-up mistake"); feet wide
  enough to pull the rope through; "flex from the hips, not the knees", "If
  you initiate the pull-through with the knees ... a squat and not a hinge"
  (hinge cue); neutral spine (back); squeeze at lockout (top).
- Catalyst Athletics, Reverse Hyper (Everett) -> "keeping the abs and glutes
  tight to prevent excessive lumbar hyperextension" (back cue, with
  StrengthLog's brace and glute squeeze: "guides ask for a braced belly and
  tight glutes so the lower back does not overarch"; the draft's "keeping
  the abs and glutes tight stops the lower back from overarching" stated the
  coach's aim as a result); the swinging version ("Some coaches let the legs
  swing under the bench and use the rebound").

## Claims by cue (beyond the model facts above)

Cable Pull-Through
- hinge: "a hip hinge: the bend comes at the hips" (StrengthLog, GGR);
  "stretches the glutes and hamstrings against the cable" (mechanical: both
  lengthen as the hip flexes; StrengthLog/BarBend name them); "Leading with
  the knees ... a squat" (GGR); correct: "pause briefly" (BarBend, model).
- back: "keeps the bending at the hips" (mechanical: the model's spine is
  rigid), Dicus (LT, MF). Correct "shoulders pulled back and down" (BarBend).
- top: "the end of the hip's range, where the glutes are at their shortest"
  (anatomy: the gluteus maximus shortens as the hip extends; same wording as
  the library's Dumbbell Hip Thrust); "the hips are still loaded at the top"
  (StrengthLog; the model's 7 cm moment arm); "where a free weight would
  hang straight under the shoulders" (mechanical).
- arms: BarBend; the elbow numbers.
- stance: GGR (Bacon), BarBend ("no slack", "widen your stance"); the stack
  and pulley numbers.
- Comparison: hinge vs squat (GGR).

Standing Cable Hip Extension
- kick: ExRx (target, synergist); "holds the glute at its shortest"
  (anatomy); the model's arc and hold.
- torso: StrengthLog kickback (body still); Oh 2007; "the extra range comes
  from the spine" (mechanical).
- hips: StrengthLog kickback.
- knee: the model's knee angles; the leverage is the model's geometry
  (above). ExRx describes the attached leg as straight; the model bends it
  ~30 deg as the foot passes under the body and nearly straightens it at the
  back, and the copy follows the model.
- grip: ExRx (both hands on a bar); "takes balance out of the lift" and
  "pulling ... twists the body into the kick" are the library kickback's
  reasoning, mechanical. ExRx has the elbows straight; the model bends them
  117 deg and the copy says "elbows bent".
- Comparison: arching vs a still back (Oh 2007, StrengthLog).

Reverse Hyperextension
- lift: ExRx (hip extension, GM target), StrengthLog (line of the body or
  slightly above; squeeze and hold), model.
- back: ExRx (articulating through the lower back), Catalyst (abs and glutes
  tight against lumbar hyperextension), Oh 2007, StrengthLog (brace, neutral
  back).
- knees: ExRx (legs nearly straight), Liu 2022, model.
- lower: Dicus (eccentric activity at a 2-0-2 tempo), StrengthLog (lower
  slowly), Catalyst (the swinging version), model timing.
- grip: StrengthLog ("Hold on to the handles or sides for stability"), ExRx
  ("grasp handles"); "a fixed base" is mechanical. StrengthLog puts the hips
  at the pad's edge and ExRx the torso and waist on the bench; this model's
  pad ends at the upper belly with the hips ~18 cm past it, and the copy
  says only "hips off its end".
- Comparison: arching (as the back cue).

45-Degree Hip Extension / Single-Leg Back Extension
- hinge: Schellenberg (hip-led vs spine-led moments; bottom just before the
  spine bends), Andersen (45 only), model.
- top: Schellenberg, Andersen, StrengthLog (straight line, hold); "mostly
  arches the lower back" is mechanical (the thighs are fixed on the pad).
- pad: ExRx, StrengthLog, the model's 9 cm; "the back curls over it
  instead" follows the library's Back Extension (the pad at the hip bones
  makes the spine curl over its edge) and Schellenberg's spine-led version.
- arms: ExRx (arm position sets difficulty; hands at or beyond the head
  harder on the single-leg page), StrengthLog (no momentum).
- free (single-leg): Schellenberg, ExRx, model. ExRx holds the free leg
  "just above" the brace; the model bends the right knee to 115 deg with the
  foot up behind, and the copy follows the model.
- depth (45): Schellenberg, ExRx, mechanics (the hip moment arm of the upper
  body is longest with the trunk level), model.

## Activation

Paint (tiers.txt), the glute-group convention (bright glutes = a Gluteus
Maximus row; the medius and minimus covered by it or named among the
stabilisers), and the faint rule (LOW rows or stabilisers):
- Cable Pull-Through: GM P 0.70 HIGH; Hamstrings S 0.60 MOD; Erector Spinae
  S 0.34 LOW. Dicus 2023 ranks the pull-through against the barbell RDL
  (library 0.72 / 0.88 / 0.42): GM no different (28.6 vs 29.6), BF -38%, ST
  -22%, LT -19%, MF -23%. The fractions scale the library's RDL values: a
  judgement call. Stabilisers: adductors (StrengthLog), gluteus medius,
  core, forearms (the rope grip, GGR).
- Standing Cable Hip Extension: GM P 0.84 HIGH (the library's Cable Glute
  Kickback and Cable Knee-Drive Kickback; no EMG of the standing version);
  Hamstrings S 0.36 LOW (faint paint). Stevens 2022's cable kickback drew
  more mean BF than the RDL at two sites, so 0.36 likely understates them:
  flagged. Erector spinae (faint, ExRx stabiliser) and ExRx's obliques,
  quadratus lumborum and gluteus medius are stabilisers.
- Reverse Hyperextension: GM P 0.86 HIGH; Hamstrings S 0.90 HIGH; Erector
  Spinae S 0.50 MOD. Dicus 2023: GM, BF and ST all above the RDL's, LT and MF
  not different. The hamstrings stay SECONDARY as painted with a fraction
  above the primary's: the library's Deadlift (erector spinae secondary 0.85
  over primaries 0.76/0.66/0.50) is the precedent, and the README's
  2026-10-11 note accepts a secondary at 0.85-0.88. Stabilisers: rectus
  abdominis, obliques (ExRx antagonist stabilisers).
- 45-Degree Hip Extension: GM P 0.76 HIGH; Hamstrings S 0.90 HIGH; Erector
  Spinae S 0.42 MOD (Andersen 2021, Stevens 2022 against the library's RDL;
  ExRx makes the hamstrings the target, the paint secondary). Stabilisers:
  adductor magnus (ExRx synergist), gluteus medius.
- Single-Leg Back Extension: Hamstrings P 0.92 HIGH; GM P 0.84 HIGH; Erector
  Spinae S 0.46 MOD: a step over the two-leg version's rows (Schellenberg
  2017, unloaded: Mh,max, GlutMax, GlutMed and ErecLum higher on one leg;
  HamMed only eccentrically, HamLat not). Judgement calls. Stabilisers:
  gluteus medius (higher on one leg in that study), adductor magnus.
- Library rows (SampleData `300-400`): Cable Pull-Through, Standing Cable Hip
  Extension, Reverse Hyperextension and 45-Degree Hip Extension GLUTEUS
  MAXIMUS (glutes the only bright group: matches); Single-Leg Back Extension
  POSTERIOR CHAIN (hamstrings and glutes bright: matches). No change needed.
- Legend lines: "HAMSTRINGS · ERECTOR SPINAE" (27 characters), "HAMSTRINGS ·
  GLUTEUS MAXIMUS" (28): within the ~43 that fit.

## Labels

Laid out from joints.json and the stills with a coordinate grid
(`$LAB/r1012/hipext/view/*_grid.png`) and the equipment's screen boxes
(`eqproj.py`); every row is an override (`ov()`).
- Cable Pull-Through: the column fills u > 0.86 (static) and the moving
  cable runs from the hands (u 0.39-0.66, v 0.43-0.63) to the pulley at the
  lower right. Short labels on the right of the top two rows ("Hips back",
  "Back flat"), over the column; "Stand tall at the top" top left, ending
  at u 0.41, left of the head at the top (0.61), its leader to the head (to
  the chest, lab round 1's leader cut across the chin while standing; the
  draft's "Stand tall, squeeze glutes" ended at 0.48, where the lockout
  ghost's neck met the pill's end in its own mistake view, so the review
  shortened it); "Arms
  stay long" left on the third row, ending at u 0.30 before the hands;
  "Cable tight" bottom right, starting at u 0.74, past the near heel and
  under the cable.
- Standing Cable Hip Extension: the column on the left (u < 0.25) with the
  moving cable at its foot; the grip label top left over the column; trunk,
  hips (0.30), kick (0.40) and knee (0.49) stacked on the right, each
  starting past the back and the glutes. The kick and knee leaders are clean
  at the back of the kick (their ghosts' moment) and cross the standing leg
  with the foot forward. In the mistake view (1.9 s) the shrunk, lifted
  model's back foot fills the right at v 0.65-0.73 and the knee ghost's
  curled foot v 0.53-0.62, so the knee label sits above both: lab round 2's
  knee label at 0.64 met the ghost's toes and round 3's at 0.67 sat on the
  model's shoe.
- Reverse Hyperextension: the machine and lifter fill v 0.33-0.70; labels
  above (back top left, knees top right) and below (grip bottom left; lift
  and lower bottom right at 0.72, under the base rails' 0.68, and 0.80). In
  the mistake view the shrunk, lifted model puts the plates and the lifted
  feet at v 0.24-0.34 on the right, so no label sits there: lab round 1's
  knee label on the second row met its ghost's raised toes, round 2's range
  label there sat on the plates.
- Bench lifts: the figure and bench fill v 0.27-0.73; top (left, ends
  0.435, at v 0.12 since the review: at 0.16 the arched-top ghost's head
  touched the pill's lower edge in its own mistake view; the left side has
  no button) and hinge (right, starts 0.506, v 0.16) at the top, pad right on the second row
  (clear of the lifted right shoe, top v 0.43), arms bottom left, free leg /
  depth bottom right with leaders across the static bench.

## Ghosts

Sized with the port at each moment (moments in the JSON); one ghost per
position cue; the bench pad cue has none (where a pad sits is a setting).
- Cable Pull-Through: hinge `hingeSquatted(withBar: false)` (hips ~12 cm
  lower, knees 155 -> ~111); back `r1012hipextBackRounded(.withBend)` (mid-back
  ~10 cm up, head ~15 cm down; enlarged after lab round 1, where the bench
  lifts' version read only as a low arc); top `leanedForward(32, .whenStraight)` (~21 deg
  at the top, the hip ~0.67 straight there); arms `r1012hipextArmsRowed`
  (elbows 156 -> ~102, hands ~15 cm up; the draft's ~114 / ~16 were stale);
  stance `r1012hipextCloserToPulley`
  (~24 cm nearer the column).
- Standing Cable Hip Extension: all fade with the left foot's distance from
  the right (`r1012hipextLegBack`, 0.45-0.8 torso lengths), so they show at
  the back of the kick only: kick short (thigh about vertical), torso arched
  (~7 cm, leg ~14 deg higher), hips opened (foot ~17 cm out; turned -1.34 to
  a back view, since the drift runs along the framing's line of sight), knee
  curled (~119 deg), grip twisted (30 deg, shoulders ~10 cm, the elbows
  re-seated with the hands on the upright: left 117 -> ~159, right -> ~92;
  lab round 1's 25-deg twist of the trunk and shoulders alone barely read
  from behind-left).
- Reverse Hyperextension: strengths from the neck's distance to the left
  ankle (1.72 torso lengths hanging, 2.42 up): legs short (~42 deg below
  level), legs flung (~25 deg above, mid-spine ~6 cm sag), knees curled
  (~126 deg; 60 deg of curl in lab round 1 lifted the toes into the label),
  legs swung under (32 deg, at the hang, 4.0 s), chest off the pad (head ~20
  cm up, elbows re-seated straight; the arm bones draw ~11 cm long, since
  the near-straight arms cannot reach the grips from the raised shoulders).
- Bench lifts: back rounded at the bottom (from the neck-ankle distance,
  2.40 -> 2.08; mid-back ~11 cm up, head ~16 cm down after lab round 1's
  ~9.5 / ~13 cm read only as a low arc), arched top (2.38 -> 2.425, within ~0.2 s of the top; head
  ~26 cm up and back), arms flung (the library Back Extension's grip ghost,
  the elbows re-seated in review so the arm bones keep their lengths; the
  shifts alone drew the right upper arm ~10 cm short and its forearm ~8 cm
  long), the single-leg's right foot set down (knee
  115 -> ~177), the 45's short dip (trunk 35 deg back up toward the line at
  the bottom).

## Lab rounds

Each round: `family_1012.sh shoot hipext "0,1.5,3"` (trainer at 0, 1.5 and 3
s, every ghost at its moment), every image inspected at full size
(`$LAB/r1012/hipext/view/` keeps the contact sheets made from them).

Round 1 (16:05)
- Cable Pull-Through: no pill on the lifter, the rope or the moving cable;
  the lockout leader to the chest cut across the chin while standing (now to
  the head). Ghosts: squat, top lean, rowing arms and closer stance read
  clearly; the rounded back read only as a low arc (enlarged).
- Standing Cable Hip Extension: pills clear of the body and cable; the kick
  and knee leaders cross the standing leg with the foot forward (accepted,
  see Labels). Ghosts: short kick, arch, opened hip (back view) and curled
  knee read; the 25-degree twist of trunk and shoulders barely read from
  behind-left (now 30 degrees with the arms re-seated on the upright).
- Reverse Hyperextension: pills above and below the machine. All five ghosts
  read; the knee ghost's raised toes ran into its own label on the second
  row (rows swapped, curl 60 -> 50 degrees).
- Bench lifts: pills clear; leaders cross only the static bench. The arched
  top, flung arms, free foot down and short dip read; the rounded back read
  only as a low arc (enlarged).

Round 2 (16:11)
- The head leader, the larger rounded back (now a hump over the back with
  the head tucked under, on the pull-through and both bench lifts) and the
  twist with re-seated arms all read; the reverse hyper's knee label now
  clears its ghost.
- New problems: the reverse hyper's range label, moved to the second row on
  the right, sat on the pendulum's plates in its own mistake view (the
  shrunk, lifted model raises the plates to v ~0.24-0.33): moved to the
  bottom right (0.72). On the standing cable hip extension the knee ghost's
  toes touched "Leg long" at 0.64: moved to 0.67.

Round 3 (16:27, the two exercises with label moves)
- Reverse Hyperextension: the range label at the bottom right (0.72) is
  clear in the trainer and in its mistake view; the knee label on the top
  row clears its ghost. Done.
- Standing Cable Hip Extension: "Leg long" at 0.67 cleared the ghost's toes
  but sat on the shrunk, lifted model's back shoe in the mistake view; the
  kick and knee labels moved up to 0.40 and 0.49 (hips to 0.30).

Round 4 (16:32, the standing cable hip extension): every pill clear of the
lifter and the cable in the trainer at 0, 1.5 and 3 s; in the mistake views
the knee label sits ~10 pt above the curled ghost foot and clear of the back
shoe, the kick label clear of the glutes; all five ghosts read. Done.

Left as they are (accepted, not fixed): the kick and knee leaders cross the
standing leg while the foot is forward; leaders cross the static bench and
reverse-hyper frame; the pull-through's top-right pills sit over the static
column; the rounded-back ghost reads as a hump with the head tucked under
rather than a smooth curve (five spine points).

## Open points for the owner

- Reverse Hyperextension: the torso pad ends at the upper belly, 18 cm before
  the hip joints; only the chest rests on it and the belly hovers ~3 cm above
  its end. Coaching (StrengthLog, ExRx) puts the hips at the pad's edge with
  the waist supported; moving the body ~10-15 cm toward the feet, or a longer
  pad, would match it. The copy says only "hips off its end".
- Standing Cable Hip Extension: the hamstrings are painted only faint; a
  cable kickback study (Stevens 2022) found biceps femoris activity above the
  RDL's, and with the knee nearly straight at the back the hamstrings help
  extend the hip (Liu 2022). A dim paint would let them be a normal
  secondary row.

## Self-check (author, 2026-10-12)

Every source above was re-opened for the numbers it supports: Dicus,
Andersen, Stevens and Schellenberg in full text (PMC pages / Europe PMC XML),
Oh and Liu as abstracts (Europe PMC), ExRx through Wayback snapshots, and
StrengthLog, BarBend, Garage Gym Reviews and Catalyst Athletics as fetched
pages; the quoted wording in this file was checked against those texts.
Changes this pass made to the draft:
- Pull-through lockout intro: "the hips straight under the shoulders" ->
  "the trunk upright": the model stands with the trunk at 0-3 degrees but
  the thighs 11 degrees forward on soft knees, so the hips stop ~11 degrees
  short of the trunk line.
- Reverse hyper lowering: "a study of this machine" -> "a pendulum reverse
  hyper like this one" (Dicus used a plate-loaded pendulum; it is not the
  model's machine).
- 45-degree depth: "the load on the hips peaks near the bottom" -> "around
  where the trunk passes level ... in the lower part of the rep": Andersen
  reports (from Contreras) the 45-degree chair's peak torque mid-motion, and
  Schellenberg's peak at its (shallower) bottom; on this model the trunk
  passes level about two-thirds of the way down.
- Bench top: "Lifting further only arches the lower back" -> "mostly":
  the hips can extend a little past the line too.
- Standing cable hip extension knee: the reason for a long leg at the back
  is the cable's leverage on the model (0.68 -> 0.55 m with the knee bent),
  not a hamstring claim: bending the knee shifts hip-extension work toward
  the glutes in isometric tests (Kwon YJ, Lee HO 2013, J Phys Ther Sci
  25(10):1295-1297, PMID 24259779, abstract: past ~60 degrees of knee flexion
  the gluteus maximus out-worked the biceps femoris and semitendinosus in
  maximal prone hip extension, while the hip's peak torque fell; Liu 2022),
  so the copy does not say a bent knee costs the glutes anything.
Mechanical reasoning, stated as such above: the cable's moment arms (both
cable lifts), "the bend comes at the hips" from the rigid spine, the
glutes' shortest length at hip extension, the extra height from the spine
when the back arches, where the 45-degree bench loads the hips most.
Judgement calls: every activation fraction (anchored on the library's RDL
values through the cited comparisons, or on the library's kickbacks), and
the hamstrings' SECONDARY rank where EMG would rank them higher (reverse
hyper, 45-degree), which follows the paint.

## Review (independent reviewer, 2026-10-12)

An independent pass over the four files: sources first, then the models,
activation, labels and ghosts. Working files are in the session
scratchpad's `lab/r1012/hipext_review/` (`src/` the pages fetched for this
review, `m/` my own reader of the USD joints (`rd.py`), skinning helper
(`sk.py`), equipment bounds (`eqb.py`, `eqlist.py`) and measuring scripts,
`g/` my own port of `FaultGhost.solve` (`fg.py`, `pieces.py`), `before/`
the four files as the author left them, and composites of the lab shots).
Nothing was taken from the author's dumps or ports except as a cross-check.

### Sources, claim by claim

- Dicus 2023: Europe PMC record (authors, journal 16(4):12-22, DOI
  10.70252/zaoj6139, PMID 37113509, PMC10124728) and the PMC full text.
  Twelve college-aged men who had taken an upper-level course in safe
  resistance-training technique (the header called them trained; it now
  says what the paper says), 3-5RM -> predicted 1RM -> 50%, 2-0-2 at a 60
  bpm metronome (the reverse hyper starting with the lift), RDL on a
  plate-loaded barbell, RH on a plate-loaded pendulum machine, CP on a
  selectorised cable; MVICs from break tests per muscle. Table 2 totals,
  concentric and eccentric values and the p values are as the header gives
  them. Pull-through back cue: supported. Reverse hyper lowering cue:
  supported, but "a slow, even tempo" was the draft's gloss; it now gives
  the paper's pace ("two seconds up and two seconds down"). Fractions: the
  ratios used (BF 0.62, ST 0.78, LT 0.81, MF 0.77 of the RDL's; RH GM, BF,
  ST 1.66, 1.81, 1.58 times) are the table's.
- Andersen 2021: Europe PMC record (20(2):181-187, PMID 33948095) and the
  full text on jssm.org (PMC answered with a CAPTCHA, which was not worked
  around). 15 resistance-trained women, three reps at 6RM, Technogym
  45-degree Roman chair with a vest and plates at the chest, the back
  straight with a natural sway, ~90 degrees of hip range; BF +71% over the
  RDL (whole), +124% (upper part); GM not different (whole, p .151, ES
  0.62), +74% (upper part); ES no differences; the introduction gives
  Contreras's mid-motion torque peak for the 45-degree chair. Changed: the
  45-degree hinge cue said "more hamstring activity", but only the biceps
  femoris was measured, so it now names it ("drew more activity from the
  biceps femoris, one of the hamstrings"), and "heavy" says the lab version
  was loaded (6RM), unlike the model. The draft's top cue said the straight
  line is "the top used in the lab studies"; Andersen only says the women
  "started in an upright position", so the cue now cites one study
  (Schellenberg's instruction 6).
- Schellenberg 2017: the PMC XML from Europe PMC. 16 adults (8 men, 8
  women) with strength-training experience (the header said trained
  adults), unloaded, a 45-degree bench whose front part put the hip joint
  centre just above its edge; Table 1 instructions 3, 5a and 6; Table 2
  Mh,max 1.1 vs 0.8 Nm/kg (BEh, p .000); Table 4 GlutMax 22.7 vs 16.5
  (concentric, p .001) and 17.4 vs 12.7 (eccentric), GlutMed 13.5 vs 9.3,
  ErecLum 22.8 vs 18.9 (p .002), HamMed 12.8 vs 9.6 eccentric (p .045),
  HamLat no difference; larger Mb,max and Mh,max for BEh than BEs. Every
  copy claim drawn from it holds ("more than a third" = +37%). Worth
  knowing, now in the open points: the lab's hip-led reps covered only
  30-36 degrees of hip range and still showed some lumbar flexion, while
  the model folds 65-72 degrees with a rigid spine; the copy takes only the
  study's stopping rule and follows the model for the depth.
- Stevens 2022: Europe PMC record (15(1):1179-1189, PMID 35989703) and the
  PMC full text (read through the fetch tool, and its wording checked
  against the author's saved PMC copy): a 45-degree hip extension and a
  cable kickback, no set-up details; mean GMax hip extension and kickback
  > Nordic and leg curl; mean BFmed and BFdist hip extension, kickback,
  Nordic and leg curl > step-up and RDL; mean BFprox kickback > step-up
  only, so "two of three sites" holds. The abstract's BFdist sentence is
  the peak result, which does not put the hip extension above the RDL; the
  activation notes use the mean results, as they say. Used in activation
  comments only.
- Oh 2007 (abstract): 20 adults; ES 49 -> 17, GM 24 -> 52, medial
  hamstrings 47 -> 58 %MVIC, anterior pelvic tilt 10 -> 3 degrees with the
  drawing-in manoeuvre. Both cues that use it: supported ("more than
  doubled": 2.2 times).
- Liu 2022 (abstract): the hamstrings' torque contribution highest with the
  knee fully extended. Supported. Kwon and Lee 2013 (abstract, notes only):
  as the self-check says.
- ExRx, Wayback id_ snapshots at the cited times: Cable Standing Hip
  Extension (2025-04-20), Lever Reverse Hyper-extension (2025-10-25), 45
  degree Hyperextension, hands behind hips (2026-06-24), Single Leg 45
  degree Hyperextension (2026-01-08). Wording, targets, synergists and
  stabilisers as the header gives them. The 45-degree page lists "No
  significant stabilizers"; the stabiliser rows there are its synergist the
  adductor magnus and the glute-group convention's gluteus medius, as on the
  library's Back Extension.
- StrengthLog (live): Cable Pull-Through, Reverse Hyperextension, Back
  Extension (its FAQ has the pad sentence the notes quote) and Cable Glute
  Kickback, as cited. StrengthLog files the reverse hyper's glutes,
  hamstrings and lower back all as primary; the rows follow the paint
  instead (the README's rule). Changed: the hips cue's "The usual cue for
  this kind of kick" rested on this one page ("as far up as you can without
  rotating in the hips"); it now says "One guide's cue for cable
  kickbacks".
- BarBend (Mike Dewar, last updated 27 Nov 2024), Garage Gym Reviews (Shane
  McLean, updated 20 Sep 2023, with Dr Allan Bacon's quotes) and Catalyst
  Athletics (Wayback 2025-12-07): as quoted. Changed: the reverse hyper back
  cue said "keeping the abs and glutes tight stops the lower back from
  overarching", stating Catalyst's aim ("to prevent excessive lumbar
  hyperextension") as a result; it now says guides ask for a braced belly
  and tight glutes so the lower back does not overarch (Catalyst, with
  StrengthLog's brace and glute squeeze).
- Mechanical reasoning not yet marked above, now marked: "With one leg
  anchored, that hip lifts the whole upper body" (the free leg's thigh lies
  on the pad with nothing for its foot to push against, so the anchored
  hip makes the extension moment); "Square hips keep the leg moving
  straight back"; "Kept still, they leave the lifting to the hips"; "the
  hips are still loaded at the top" (re-measured: the hands-to-pulley line
  passes 6.6 cm below the hip axis standing and 28.3 cm at the bottom; the
  modelled rope dips from the hands to its clip at knee height behind the
  legs (as a rope passing under the crotch would) before the cable runs
  back to the pulley, so the line of pull bends there, but either way it
  passes below and in front of the hips: a flexion moment at the top).

### Model, re-measured

My own reader of the joint world transforms (`m/rd.py`; the skeleton
prim's Z-up to Y-up transform is already in them), skinned meshes and
equipment bounds. Confirmed, within rounding: every number in the header
and the Model facts above (pull-through trunk 0 -> 75 degrees, hips 11 ->
100, knees 164 -> 155, shins 4.7 -> -0.4, pelvis 13.6 cm back and 3.2 cm
down, spine angles 171.1/174.1/176.3 every frame, elbows 155.7 -> 141.9,
ankles 0.400 m apart, toes out 12.0 degrees, pulley axle (0, 0.20, -0.958),
the pinned plates 19.2 cm up and 3.3 cm off the stack at the bottom;
standing hip extension trunk 8.6 degrees, pelvis, trunk, arms and right leg
still to 0.04 degrees, right knee 175, left thigh +18 -> -28 degrees in the
sagittal plane only, knee 160 -> 148.4-149 -> 174, hip +26.6 -> -19.4,
cuff band 0.13-0.26 m up, pulley 0.37 m in front, the moment arm 0.68 ->
0.55 m with the knee ghost; reverse hyper trunk 89.58 degrees and every
joint above the hips still, knees 176.0, thighs +4 -> -93 degrees, the
pivot coaxial with the hips, strap 6-11 cm above the ankles, the sternal
pectorals 0.4 cm into the pad, the belly 2.8 cm above it, hip joints 18.4
cm past its end; bench lifts trunk +45.4 -> -19.6 / -26.6 degrees, hips 0
-> 64.6 / 71.6, every spine segment turning together (the single-leg's head
4 degrees less), knees 178, right knee 115 all clip, the pad from 8.6 cm
below the hip joints along the leg, its face 13.3 cm in front of the
hip-ankle line against the rectus femoris at 13.6, the roller (radius 6.1-
6.8 cm) on the soleus, the shoe soles within 0.3 cm of the plate, arms
crossed with each hand past the midline; timing as the header gives it
with a 0.5-1 degree threshold). Two copy claims did not match:
- Standing Cable Hip Extension: the hands are not at chest height. The
  hand meshes span 1.04-1.14 m, the middle of the rectus abdominis
  (0.88-1.29 m) and 6-17 cm below the pectorals' lowest point (1.20 m).
  The grip intro, setup step 2, the header and the Model facts now say
  about waist height.
- Reverse Hyperextension: "from just under the pad" was wrong; the legs
  hang straight down from hips 18 cm past the pad's end (the feet 3 cm
  toward the head of them). Now "from hanging straight down".
The notes' bench facts also quoted two phrases that are not in the copy
("about 6 cm above the ankles", "about hip-width apart"); corrected.

### Activation

Every row follows the paint (bright primary, dim secondary, faint as a LOW
row or a stabiliser) and the glute-group convention, every level matches
its fraction, and the library rows (GLUTEUS MAXIMUS x4, POSTERIOR CHAIN for
the single-leg back extension) match the bright groups. The single-leg back
extension's bright hamstrings are primary (0.92); the dim hamstrings of the
reverse hyper and the 45-degree hip extension are secondary at 0.90, above
their gluteus maximus primaries (0.86, 0.76). That is the README's
2026-10-11 rule (ranks follow the paint, fractions follow the EMG) and the
EMG backs it (Dicus: RH BF 62.4 and ST 49.4 vs the RDL's 34.5 and 31.2;
Andersen: BF +71% over the RDL; Stevens: BFmed and BFdist above the RDL),
so it is kept; 0.90 is the library's highest secondary (the precedent
stops at 0.88), flagged below. The fractions themselves remain judgement
calls scaled from the library's RDL (0.88 / 0.72 / 0.42) and kickbacks
(0.84), as the activation comments say. Consistency: the Back Extension is
the spine-curl version (ES primary 0.85, GM and hamstrings 0.30) and its own
comparison calls the flat-back hinge the glute and hamstring version, which
is what these two bench lifts are; the Cable Knee-Drive Kickback's
stabilisers are the standing hip extension's, and both library kickbacks
give the gluteus maximus 0.84; the Glute-Ham Raise is a knee-led lift
(hamstrings 0.93 primary) with nothing to reconcile.

### Copy, house style

No double quotes or backslashes in the copy, every label 28 characters or
fewer, five annotations and five cues per exercise, badges in capitals,
stabilisers lower case. A sentence-by-sentence comparison with
SampleData.swift, every other spec file and setup.py found one near copy:
the bench arms why opened with the library Back Extension's arms intro with
one word changed ("Where the arms sit sets how heavy the upper body is to
lift"); it now reads "The higher the arms sit on the body, the harder each
rep". Shared short phrases (comparison cues, set-up steps such as Cross
your arms over your chest) were left.

### Ghosts

Every ghost re-solved with my own port at its still (bone lengths, knee and
elbow angles, displacements in the body's and the room's axes); every
size in the comments matches within a centimetre or two except:
- Pull-through arms (`r1012hipextArmsRowed`): the elbows go 156 -> ~102,
  not ~114, and the hands rise ~15 cm (the author's own port gives the same
  102; the comment was stale). Comments corrected.
- Bench arms (`r1012hipextArmsFlung`): the library Back Extension's two
  shifts, applied to these rigs' unevenly crossed arms, drew the right
  upper arm 0.288 -> 0.19 m and its forearm 0.25 -> 0.33 m (the comment
  said the bones stretch ~2 cm, true only of the left arm). Added
  `.resolve(["forearm_*"])` after the shifts: both bones keep their
  lengths, the hands still land ~50 cm out, the elbows end ~141-145 (left)
  and ~115 degrees (right). Lab: reads as before, two flung arms.
- Reverse hyper grip (`r1012hipextChestOffPad`): the arms are already near
  straight (167 degrees), so lifting the shoulders 14 cm leaves the grips
  out of reach and `.resolve` draws the arm bones ~11 cm long in all. Any
  lift that reads does this (14 degrees still stretches them 7.5 cm), and
  on the lab shot the yellow arms read as pushing on the grips without
  looking broken; kept, the stretch now stated in the comments.
The other ghosts hold their comments: squat (hips 12 cm down, knees 155 ->
111), rounded back (mid-back ~10-11 cm, head ~15-16 cm; the pelvis-spine
segment draws ~5 cm long, as noted), lockout lean (21 degrees, head 25 cm),
closer stance (24 cm), short kick (thigh 2 degrees behind vertical, foot 36
cm forward), arched kick (spine 7 cm, foot 13 cm up), opened hip (foot 17
cm out, back view), curled knee (174 -> 119, ankle 32 cm up), twist
(elbows 117 -> 159 / 92), legs short (42 degrees below level, feet 61 cm
down), legs flung (25 degrees above, feet 31 cm up), knees curled (176 ->
126, ankles 28 cm up), swung under (feet 44 cm toward the head), arched
top (head 26 cm), short dip (trunk 15 degrees above level, head 42 cm up),
free foot down (115 -> 177, foot 40 cm down). No knee or elbow bends
backward. Moments: every one is in seconds and lands in the right hold
(pull-through bottom 1.58-2.04 s and standing 3.12-4.17 s; standing hip
extension's back hold 1.67-2.17 s; reverse hyper top 1.71-2.12 s and hang
3.71-4.29 s; bench bottom 1.67-2.17 s and top 3.67-4.33 s; the free-leg and
flung-arm ghosts are always on, shown mid-rep at 1.0 and 2.6 s).

### Labels

Checked on every trainer still (0, 1.5, 3 s) and every mistake view of
review round 1. Two pills met their own ghost in the mistake view, which
the author's rounds had not caught:
- Pull-through lockout: the leaning ghost's neck sat on the right end of
  "Stand tall, squeeze glutes" (ending at u 0.48). Now "Stand tall at the
  top" (ends at 0.41): ~27 pt clear of the ghost, and the leader to the
  head is unchanged in the trainer.
- Bench lifts, top position: the arched ghost's head touched the lower
  edge of "Stop in a straight line" at v 0.16. The pill moved up to 0.12 on
  the left, where there is no button (the library has many left-side
  labels at 0.12); ~30 pt clear in the mistake view, ~26 pt under the
  mistake banner, and the leader still passes right of the head at the top.
Accepted, as the author left them: the reverse hyper's knee leader runs
over the near pendulum plate when the legs are up (the plates sit beside
the knees all rep, so any leader to the knee does); leaders across the
static bench, frame and column; the standing hip extension's kick and knee
leaders across the standing leg while the foot is forward; its knee pill
~13 pt above the curled ghost's shin; the grip pill ~7 pt from the twisted
ghost's arm.

### Lab

Review round 1 (17:05, all five exercises, `family_1012.sh shoot hipext
"0,1.5,3"`): BUILD SUCCEEDED; every trainer still and ghost inspected
enlarged; the two label problems above found; the re-seated flung arms and
the stretched reverse-hyper arms checked. Review round 2 (17:12, the
pull-through and the two bench lifts, after the two label moves): BUILD
SUCCEEDED; "Stand tall at the top" clears the lockout ghost (~27 pt) and
its leader still meets the head at 0, 1.5 and 3 s; "Stop in a straight
line" at 0.12 clears the arched ghost's head on both bench lifts (~30 pt)
and sits clear of the head, the buttons and the mistake banner; every
other still and ghost as in round 1. Composites of both rounds are in the
review folder.

### Changed in this review (summary)

- spec: Dicus and Schellenberg participant descriptions; standing hip
  extension hands at about waist height (header, grip intro, setup step 2);
  "One guide's cue for cable kickbacks"; reverse hyper "from hanging
  straight down", "guides ask for a braced belly and tight glutes", "two
  seconds up and two seconds down"; bench top "where a lab study of this
  lift set the top"; bench arms why reworded; 45-degree hinge names the
  biceps femoris and the heavy load; StrengthLog kickback wording in the
  header; pull-through lockout label "Stand tall at the top"; bench top
  label row 0.12.
- faults: `r1012hipextArmsFlung` re-seats the elbows; comment fixes for
  the rowed arms (102 degrees, 15 cm), the flung arms and the reverse
  hyper's arm stretch.
- notes: the corrections above in Model facts, Sources, Labels and Ghosts,
  and this section. The moments file needed no change.

### Open points for the owner (added to the author's)

- Hamstrings SECONDARY 0.90 on the reverse hyper and 45-degree hip
  extension: the library's highest secondary (precedent 0.85-0.88). EMG
  supports it; 0.88 would sit inside the precedent if preferred.
- Standing cable hip extension hamstrings LOW 0.36 (faint paint) against
  0.50 on the library's two cable kickbacks, the same muscle job; the
  author's note on re-painting them dim stands.
- The bench models fold 65-72 degrees at the hips with a perfectly rigid
  spine, about twice the hip range the lab's hip-led reps reached before
  the spine bent (Schellenberg: 30-36 degrees); the copy follows the model.
- Shared file, not edited: the library Back Extension's grip ghost
  (FaultPoses.swift, the same two shifts) also changes its arm bones on
  its own rig (forearm 0.25 -> 0.21-0.23 m, upper arm 0.24-0.30 m over the
  rep in my port); adding `.resolve(["forearm_*"])` there would keep them.
- Reverse Hyperextension: the knee label's leader runs over the near
  pendulum plate while the legs are up (the plates ride beside the knees,
  so any leader to the knee does); accepted.
