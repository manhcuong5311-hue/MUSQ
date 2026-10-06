# 401-500 folder, round 3: landmine rotations and Russian twists (2026-10-05)

Four rotation exercises from the builder's 462-465 exports: 462 Landmine Rotation, 463 Landmine 180,
464 Medicine Ball Russian Twist and 465 Weighted Russian Twist (models `Abs/<Resource>.usdc`).
`spec_500_twist.py` holds the copy and setup steps (its header lists what each model shows and the
full citations), `Tools/fault-review/faults_500_twist.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_twist.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The arm and leg briefs (`SCRATCH/lab/r3/briefs/<Resource>.md`, `briefs_legs/<Resource>.md`),
  `tiers.txt`, `joints.json` and the trainer stills at 0/1/2/3/5 s (`SCRATCH/lab/r3/stills`). The
  briefs give hands, elbows, knees and the neck-over-pelvis lean, not how far the chest and hips
  turn, so the rigs were read directly with Blender's Python + pxr (scripts in
  `SCRATCH/lab/r3/twist/`):
  - `dump.py`: every joint's world matrix for all 192 frames, plus the world bounds of every
    `HG_*` prim, into `<Resource>.json` (also the library's older `RussianTwist` for comparison).
  - `meas.py`: per 0.25 s, the heading of the shoulder line (`upper_arm_L` - `upper_arm_R`) and the
    hip line (`thigh_L` - `thigh_R`) from above, each bone's orientation change from frame 0,
    knee and hip angles, foot height, heading and pitch, the hands' midpoint; `feet.py`: knee,
    ankle and toe joints and the pelvis; `meshpts.py`: the ball's and plate's real mesh extents
    (their bounding boxes are loose).
  - `orange.py`: centroid and spread of the painted pixels in the five stills (the glows); the
    medicine ball is excluded by colour (paint R > 180, G < 135, B < 100).
- Ghosts: `ghost.py` (a Python port of `FaultGhost.solve` and `BodyFrame`, with the four framings;
  its projection matches `joints.json` to the third decimal), `proto.py` / `final.py` (the pieces
  as Python, sized on the rigs at each fault's moment; `final.py` also sweeps the whole clip every
  1/12 s for segment lengths and for any knee or elbow bending the other way), `drawg.py` for
  quick drawings over the stills.
- Labels: `preview_500.py twist` plus `overlay.py` (pills ~24 + 6.4 pt per character, 28 pt tall,
  leaders drawn over the five stills), then the lab shots.
- Sources: Europe PMC REST records (abstracts; `SCRATCH/lab/r3/twist/src/epmc_*.json`) and the
  Vinstrup 2015 full text (PMC XML); ExRx through the Wayback Machine (`src/exrx_*.html`);
  StrengthLog pages and the Fitness Volt article fetched live (`src/*.html`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.59 m standing, 0.57 m reclined). Every clip is 7.96 s
  (192 frames at 24 fps).
- Turn sign: the hip-line heading is positive when the left hip comes forward, i.e. when the
  lifter turns to their right (checked against the hands, which go to -x, the lifter's right).
- Highlight tiers (`tiers.txt`): both landmines light ExternalOblique, InternalOblique and
  RectusAbdominis bright and DeltoidAnterior, DeltoidLateral, GluteusMaximus, GluteusMedius and
  GluteusMinimus dim; both Russian twists light ExternalOblique, InternalOblique,
  RectusAbdominis and Sartorius (the rig's hip flexor paint, written "Hip Flexors", legend-only)
  bright and DeltoidLateral dim. Bright rows are PRIMARY and dim rows SECONDARY (house rule).
- Legend width: one line per rank, ~43 characters of names. Five dim muscles on the landmines
  would overflow, so two are rows (GLUTEUS MEDIUS . ANTERIOR DELTOID, 33 characters) and
  gluteus maximus, gluteus minimus and lateral deltoid are named with the stabilisers, as the
  cablecrunch family did with the ab coaster's posterior deltoid. The twists' primaries read
  OBLIQUES . RECTUS ABDOMINIS . HIP FLEXORS (41), which fits (lab shots).
- No EMG study of a landmine rotation, landmine 180 or loaded Russian twist was found: Europe PMC
  abstract searches for "russian twist" (0 hits) and landmine with rotation, oblique or EMG
  (presses, squats, punch throws only); web searches. Every fraction is a judgement call, said so
  in the spec's code comments; nEMG values from related studies are not the app's fraction.
- Rejected or unused: Hiremath et al. 2025 (JPES 25(1):175-185; sit-ups, back extensions, planks;
  no twist); Mandroukas et al. 2022 (JFMK 7(3):67; a supine curl-up with rotation, not a seated
  twist); Kawama et al. 2022 (JSSM 21(4):493-503; a sit-up twist, rectus abdominis only); Allen
  et al. 2024 (Strength Cond J 47(1):109-113, "Exercise technique: the landmine rotation"; only
  the abstract was reachable, so nothing from it is used); Bodybuilding.com's Landmine 180's
  page (now 404; the Wayback Machine was rate-limiting, so it was not read and is not cited).

## Sibling and library check

- Library Russian Twist (`russianTwistContent`, its own older model, measured from
  `Abs/RussianTwist.usdc`): trunk ~27 deg behind upright, shoulder line ~22 deg each way, the
  ball kept at chest height (hands 0.48-0.60 m) with the elbows fixed at 65 deg, one side every
  2 s; cues rotate / ball / lean / hips / feet, comparison ARMS ONLY, Obliques 0.76 primary,
  Rectus Abdominis 0.52 and Hip Flexors 0.38 secondary, no sources. The two new twists lean back
  39 deg, turn 47.5 deg, take the load from the chest down beside each hip ~5 cm off the floor
  with the arms lengthening, one side every 1.33 s. The copy is written fresh for that: its cues
  are the shoulder turn, the load down beside the hip (the library's model keeps it at the chest),
  holding the lean (the library's mistake is a rounded back; here it is sitting up), knees still,
  and rhythm / plate grip; comparisons BALL KEPT HIGH and KNEES SWAYING.
- Library Cable Wood Chop (diagonal chop from a high pulley, obliques 0.78 primary): the landmine
  obliques row is anchored on it.
- No sentence of cue, setup or comparison copy repeats word for word between the four, with any
  string in SampleData.swift or with the other `spec_500_*` families (checked by script; the review
  found one clause shared by the two twists' knees why and reworded the plate one).

## Landmine Rotation

Model facts: a landmine base (`HG_LandmineBase`, pivot `HG_Pivot`) on the floor at z ~2.0 m, ~1.95 m
in front of the heels; the shaft (`HG_LandmineShaft`) rises to a sleeve (`HG_LandmineSleeve`) with
one plate and collar (`HG_Plates`) near its end. Both hands wrapped around the sleeve end, palms
facing each other (brief), at 1.46 m: 5 cm above the shoulder joints (1.42 m) and 49 cm in front of
them, elbows 144 deg. Ankles 42 cm apart (shoulder joints 39 cm), toes out ~10 deg, knees 168 deg,
trunk 8 deg forward. The bar end sweeps to the right at 1.0 s, through the top at 2.0 s, to the
left at 3.0 s, back at 4.0 s, and again (two sweeps a side; ~1 s down, ~1 s up; within ~1 deg of
the end of the turn from 0.75 to 1.25 s). At each side: shoulder line 47 deg, hip line 26 deg, head
with the chest (47 deg); hands 1.03-1.11 m (lumbar joint 1.01 m, hip joints 0.88 m), in the hips'
frame ~47 cm in front of that side's hip and ~8 cm outside it; elbows 153-159 deg; trunk lean 13 deg
forward and 6 deg toward the bar; both knees 150 deg; the pelvis ~2 cm lower and ~7 cm toward the
other leg. Feet: the balls of both feet never move (toe joints fixed to the millimetre); on the
side the bar comes down to, the heel lifts ~5 cm and swings ~5 cm outward, the toes turning ~28 deg
inward, and that knee drifts ~5 cm toward the midline.

| Claim | Source |
|---|---|
| Chest and head turn with the bar end, the hips about half as far; about 45 degrees | The model (shoulder line 47 deg, hip line 26 deg, head 47 deg) |
| Turning right uses the left external and right internal oblique; they run from the lower ribs to the pelvis, so the ribcage turning over the hips is their work | ExRx Obliques (Wayback 20260202082020: rotation right [left 1 = external, right 2 = internal]; origins ribs 5-12 and fascia, insertions iliac crest, inguinal ligament, pubic crest, rectus sheath / linea alba); the last clause is the attachments' mechanics |
| In a study of standing twists held at set angles, the obliques were clearly more active than standing square only once the turn passed about 30 degrees | Swie & Sakamoto 2004 abstract (ten men, graded isometric standing twists, contralateral EO and ipsilateral IO; "a significant increase against the initial posture ... when the twisting angle was more than 30 degrees"). Verification: the abstract does not say whether the angle was the chest's turn over the feet or over the pelvis; on this model the shoulder line turns 47 deg over the floor but only ~21 deg over the hip line, so the copy states the finding and never says this lift passes 30 deg (on the twists the pelvis is still, so their 47.5 deg is all trunk) |
| Arms long, elbows softly bent; StrengthLog keeps the arms straight; ExRx's standing cable twist keeps both arms straight; held on long arms the bar end stays in front of the chest, so the trunk has to turn to carry it across; bent elbows let the arms drag it | The model (elbows 138-162 deg; the hands' heading from the shoulders stays within 6 deg of the chest's facing all clip, review measurement); StrengthLog Landmine Rotation ("arms straight in front of you", "keep your arms straight"); ExRx Cable Twist (Wayback 20250803155043: "Both arms should be horizontal and straight"); mechanics. The model's arms are softly bent, so the copy says long and softly bent, not straight |
| Each sweep brings the bar end to about waist height, out in front of the hip and a little outside it; StrengthLog lowers it toward the outside of the hip | The model (hands 1.03-1.11 m; 47 cm in front, 8 cm outside in the hips' frame); StrengthLog ("lowering the bar toward the outside of your hip") |
| Turning back with the bar end at chest height keeps the arc and the turn short | Mechanics (the bar end only gets lower by turning further; the ghost turns back 19 deg) |
| About a second down and a second up, easing into the end of the turn; StrengthLog alternates in a controlled motion; a fast bar end carries on past the controlled turn | The model; StrengthLog ("Continue alternating from side to side in a controlled motion"); the momentum clause is mechanics |
| Feet about shoulder-width, toes out a little, knees soft and bending more as you turn; StrengthLog sets the feet slightly wider than shoulder-width; ExRx bends both knees slightly and notes that much of its turning comes from the hips rather than the spine; soft knees let the hips turn and sink, locked knees make them harder to turn | The model (ankles 42 cm vs shoulder joints 39 cm, toes out 10 deg, knees 168 -> 150 deg, pelvis -2 cm); StrengthLog ("feet slightly wider than shoulder-width apart"); ExRx Cable Twist ("Bend knees of both legs slightly"; "This movement arguably involves more hip internal rotation and transverse adduction than spinal rotation"; "remarkably little rotation actually occurs through spine"; "A large part of rotational force actually occurs through rotation/transverse adduction of forward hip"; verification: the copy said the turning force comes from the hips, but ExRx puts the force in the forward hip of its staggered stance, so the copy now says the turning, which ExRx puts in the hips rather than the spine); the last clause is mechanics |
| Setup: barbell in a landmine base, plate on the free end, face the anchor; sleeve end in both hands, palms facing, about shoulder height, arms long; feet about shoulder-width; sweeps alternate | The model |

Not cued: the heel. ExRx's cable twist raises the heel of the foot on the side the turn comes from
("Raise heel of nearest foot off floor", the foot nearest the pulley) and Fitness Volt keeps both
feet planted; the model lifts the heel on the side the bar comes down to, the mirror image of
ExRx's, so a heel cue in either direction would contradict either the model or the sources read.
(Verification: an earlier wording also said the web landmine guides pivot the back foot; no source
read here says so, so it was dropped.) The copy
only says the feet stay about shoulder-width with the knees soft. See Open points.

Activation: Obliques 0.78 PRIMARY (the library's Cable Wood Chop; Vinstrup 2015: external obliques
47-54% of MVC EMG in standing elastic torso twists and 41-77% seated in a machine, not the app's
fraction), Rectus Abdominis 0.40 MODERATE PRIMARY (painted bright, but Andersson 2002 found it
"little activated in all rotations" and Vinstrup 2015 measured 10-16%; the lowest moderate value,
as the seated calf raises' gastrocnemius, and the copy never says it turns the trunk), Gluteus
Medius 0.30 LOW SECONDARY (painted dim; ExRx Cable Twist synergist, turning over the hips),
Anterior Deltoid 0.30 LOW SECONDARY (painted dim; StrengthLog's secondary muscle, holding the
arms out in front). Stabilisers: erector spinae (Vinstrup 2015: 24 / 50% in the standing twist;
ExRx Cable Twist stabiliser), gluteus maximus and gluteus minimus (painted dim; ExRx lists the
minimus's anterior fibres as a synergist), lateral deltoid (painted dim; ExRx stabiliser). All
judgement calls. The library row OBLIQUES / LANDMINE / intermediate fits.

## Landmine 180

Model facts: the same landmine, plate and grip. Ankles 46 cm apart (wider than the rotation's 42),
toes out 10 deg, knees 168 deg. Start: hands at 1.64 m, 23 cm above the shoulder joints and 6 cm
above the head joint (about eye level), arms raised ~120 deg (brief: shoulder flexion 119 deg),
elbows 144 deg. One side per 4 s: down to the right over ~2 s (deepest at 2.0 s, within ~1 deg from
1.75 to 2.25 s), back up over ~2 s, then the left (4-8 s). At the bottom: shoulder line 77 deg, hip
line 42 deg (55% of it), head 77 deg; hands 1.03-1.09 m (hip joints 0.86 m), 35 cm to the side of
the start line in the room, ~41 cm in front of that hip and ~10 cm outside it in the hips' frame;
the arm reaching across bends to 117 deg, the other stays at 145; trunk lean 10 deg forward and
10 deg toward the bar; knees 143-150 deg; pelvis ~3 cm lower. Same same-side heel lift (~6 cm,
toes turning ~34 deg in). Differences from the rotation: a wider stance, a start ~18 cm higher,
a turn ~30 deg bigger at the chest and ~16 deg bigger at the hips, one slow side at a time
(2 s down, 2 s up) instead of a brisk alternating sweep (1 s each way), the crossing arm bending
at the bottom.

| Claim | Source |
|---|---|
| Each rep starts with the bar end at about eye level, arms raised long in front; raise it there before each turn | The model (hands 1.64 m, arms ~120 deg); Fitness Volt (Magnante, ACE-certified, updated 2024-08-11: "Explode the weight up overhead to the starting position"). Its step 3 starts with the arms extended forward; the model is higher than that, between the two |
| Starting high gives the bar end its longest arc; starting at chest height trims the top off every rep | Mechanics |
| Turn until you nearly face the side: chest most of a quarter turn, hips a little over half as far | The model (77 deg; 42 deg) |
| Turning left uses the right external and left internal oblique (ExRx); ExRx puts much of the standing cable twist's turning in the hips rather than the spine; StrengthLog's landmine rotation turns the hips and torso together | ExRx Obliques; ExRx Cable Twist comment ("arguably involves more hip internal rotation and transverse adduction than spinal rotation"; the turning force in the forward hip, so the copy says turning, not force); StrengthLog Landmine Rotation ("Rotate your hips and torso to one side"). Fitness Volt says the lower body should not turn at all; the model turns the hips 42 deg, so the copy follows the model, StrengthLog and ExRx |
| Trunk stays tall, leaning only slightly forward | The model (lean 8 -> 10 deg) |
| In a study of torso twists against an elastic band done standing, one side of the lower back worked about as hard as the obliques and harder than in a seated twist machine, which the authors linked mostly to standing | Vinstrup 2015 full text (Table 2, elastic: right erector spinae 50%, external obliques 54 / 47%; machine: right erector spinae 32%, P = 0.03; Discussion: the difference "would most likely be a result of the two different body positions (seated versus standing) ... the standing position would engage the postural muscles to a larger degree", adding the elastic exercise's longer lever arm as a second reason) |
| The bar end comes down as the trunk turns and the arms lower, not by the trunk bending | The model (the upper arms 119 deg from the trunk's down line at the top, 46-65 deg at the bottom; the trunk lean 8 -> 10 deg forward). Verification: the copy said the bar end drops by turning the trunk; a turn about the vertical does not lower the hands, the arms lowering does, so it now names both |
| Folding over the bar lowers it with a bend instead; turning around a tall spine | Mechanics |
| The bar end comes down to about hip height, in front of the hip, the arm that reaches across bending more at the elbow; pause, then back over the top | The model (hands 1.03-1.09 m, the lumbar joint ~1.0 m: the top of the pelvis rather than the hip joints at 0.86 m; crossing elbow 144 -> 117 deg while the other stays at 145; ~0.5 s near-still at the bottom). Fitness Volt bends the bottom arm and keeps the top arm extended; the model bends the arm that crosses over the top, so the copy follows the model and cites Fitness Volt for neither arm |
| Fitness Volt lowers the bar to the side with the torso rotating; StrengthLog takes it toward the outside of the hip; turning back early leaves out the lower arc and much of the turn | Fitness Volt ("lower the bar down to either side ... Slightly rotate your torso in the direction of the bar"); StrengthLog; mechanics (the ghost turns back 29 deg of 77) |
| About two seconds down and two up, a brief pause; Fitness Volt names swinging the bar with little control as a common mistake and does each rep slowly | The model; Fitness Volt ("swinging the bar back and forth with very little control"; "Perform each rep at a slow pace") |
| Setup: plate on the free end, face the anchor; feet a little wider than shoulder-width; palms facing; hands about level with the eyes; one hip then the other | The model |

Activation: as the Landmine Rotation (same paint, same sources, no EMG for either).

## Medicine Ball Russian Twist

Model facts: seated on a mat (`HG_Mat`, top at y 0), knees 63 deg, feet flat (ankle joints 7 cm up,
toes on the floor, as standing), ankles 30 cm apart, knees 37 cm; trunk 39 deg behind upright
(neck over pelvis), the pelvis rolled back (pelvis-to-lumbar segment 72 deg behind upright,
lumbar-to-thoracic 38, thoracic-to-neck 28: a rounded back), trunk-to-thigh ~86 deg; the lean never
changes (38.6-39.4 deg). A medicine ball (`HG_MedicineBall`, 24 cm across) held between the palms in
front of the chest (centre 0.59 m up), elbows 64 deg. Shoulder line turns 47.5 deg right at 0.67 s,
back at 1.33 s, 47.5 deg left at 2.0 s, back at 2.67 s, and so on (three twists each way in the
clip; ~0.33 s near-still at each side); head with the chest (44 deg about the vertical, ~52 deg
about the reclined trunk's own line). At each side: the ball's centre 37 cm out from the midline
and ~6 cm behind the hip joints, its lowest point ~5 cm above the mat; elbows 121 deg (near arm)
and 142 deg (far arm). The pelvis, legs and feet do not move at all (hip line heading 0.0 deg all
clip).

| Claim | Source |
|---|---|
| Shoulders turn about 45 degrees each way, the head following the ball | The model (47.5 deg, head with the chest) |
| Turning left uses the right external and left internal oblique (ExRx) | ExRx Obliques |
| In a study of standing twists held at set angles, the obliques were clearly more active than with no twist only past about 30 degrees, so a twist made mostly with the arms leaves the trunk short of it | Swie & Sakamoto 2004 abstract (standing, not seated; the copy says standing); the last clause is the copy's reading |
| Each twist takes the ball from in front of the chest down beside the hip, just off the floor; arms lengthen; almost touching the mat | The model (ball centre 0.59 -> 0.17 m, lowest point ~5 cm up, elbows 64 -> 121-142 deg) |
| ExRx's medicine ball Russian twist turns the torso and reaches the arms to the same side until the ball reaches the floor; StrengthLog's brings the weight toward the hip | ExRx Medicine Ball Russian Twist (Wayback 20250827094522: "Touch ball on floor to one side by turning torso and reaching arms to same side"); StrengthLog Core Twist (strengthlog.com/russian-twist/: "Twist your torso to one side and bring the weight toward your hip"). The model stops ~5 cm short of the floor, so the copy says just off the floor |
| In this version the ball goes down nearly to the floor on each side (verification: was "to the floor"; the model stops ~5 cm short); holding it up by the ribs cuts that reach short, so less of its weight ends up out at the side, where the trunk has to stop it and turn it back; close beside the hip | ExRx Medicine Ball Russian Twist (touches the ball to the floor); mechanics (on the model the ball beside the hip sits ~0.23 m to the side of the reclined trunk's long axis, so its weight twists the trunk toward that side; at the middle it sits in the midline plane and does not). The library's Russian Twist teaches the ball held at chest height and calls reaching it far away to tap the floor a mistake; its model keeps the ball at the chest. This model lowers the ball close beside the hip (centre 37 cm from the midline), so the copy frames the low position as what this version does and says close beside the hip |
| Lean back about 40 degrees and keep it | The model (39 deg, constant) |
| ExRx lists flexion of the spine and hips as held still while the spine rotates; leaned back behind the hips, the abdominals and hip flexors hold the trunk while the obliques turn it; sitting up lets its weight settle over the hips | ExRx Medicine Ball Russian Twist (Force (Articulation): Dynamic spine rotation; Static spine flexion, hip flexion); the holding and settling clauses are mechanics (a trunk behind the hips has to be held against falling back) |
| Hips, knees and feet stay put; the obliques turn the ribcage against the pelvis, so with the pelvis still, the whole turn happens in the trunk (verification: was "the pelvis has to stay still for the turn to happen in the trunk", an absolute; a pelvis that turns still leaves some twist above it); ExRx notes twists with the hips held still allow more turning through the spine; knees swaying turn the hips | The model (pelvis and legs static); ExRx Obliques attachments; ExRx Cable Twist ("Seated oblique exercises or those exercises where hips are stabilized allow for greater range of movement through spine"); the swaying clause is mechanics |
| Feet flat, knees pointing up, about hip-width apart | The model (ankles 30 cm, knees 37 cm apart; StrengthLog allows feet on the ground or slightly lifted) |
| An even rhythm, a little over a second side to side, about two thirds of a second to each side; a ball that swings freely carries you past the controlled turn | The model (1.33 s side to side); mechanics. ExRx's version (a plyometric) moves the ball rapidly from side to side; the copy does not call speed a mistake, only letting the ball's swing bounce you back |
| Setup: knees bent, feet flat about hip-width; ball between the palms in front of the chest, elbows bent; lean back about 40 degrees, balance on the hips; alternate | The model; ExRx ("Recline back slightly balancing on hips with bent legs positioned as counterbalance", which reads as the feet off the floor; the model keeps them down, as StrengthLog allows: "feet either on the ground or slightly lifted"); StrengthLog |

Activation: Obliques 0.80 PRIMARY (a little above the library's Russian Twist, 0.76: these models
turn ~47.5 deg against its ~22, past Swie & Sakamoto's ~30 deg), Rectus Abdominis 0.60 MODERATE
PRIMARY and Hip Flexors 0.55 MODERATE PRIMARY (both painted bright; above the library's 0.52 /
0.38 secondary because the trunk is held 39 deg back against ~27 there, ExRx's static spinal and
hip flexion; below the situp family's sit-ups, 0.72-0.88, where the trunk is lifted; Andersson 1997:
the hip flexors are highly active only where the hips flex, which here they hold), Lateral Deltoid
0.20 LOW SECONDARY (painted dim; holds the arm on the ball's side out from the body as the ball goes
down to the side; the brief has both arms at 34 deg of abduction at the middle and the arm on the
twist's side at 41-55 deg on the way down and back, 41 at the end of each twist, while the other arm
crosses the body at -37 to -38). All judgement calls. Stabilisers: transverse abdominis (ExRx Obliques comment: the obliques and transversus raise intra-abdominal
pressure), erector spinae (Andersson 2002: the back muscles take part in trunk rotations), anterior
deltoid (holds the ball out in front; ExRx's static shoulder flexion). The library row OBLIQUES /
MEDICINE BALL / beginner fits.

## Weighted Russian Twist

Model facts: the same seat, lean (39 deg), twist (47.5 deg, the same timing) and static legs as the
medicine-ball twist (trunk, head and legs identical, the hands within ~3 cm and the elbows ~4 cm,
the plate being wider than the ball); a weight plate (`HG_WeightPlate`, 28 cm
across) held by its rim, one hand on each side (wrists at x +-0.16 m, the plate's rim at +-0.14,
level with its centre), in front of the chest at the middle (elbows 63 deg) and down beside the hip
at each side, its lowest edge ~5 cm above the mat (elbows 118 deg near, 130 deg far).

| Claim | Source |
|---|---|
| The ribcage turns about 45 degrees each way over hips that stay square; obliques from the lower ribs to the pelvis; right turn: left external + right internal, left the reverse; past ~30 degrees in a standing twist study, a turn the arms alone do not make | The model; ExRx Obliques; Swie & Sakamoto 2004 (the last clause is the copy's reading) |
| The plate travels from the chest down beside the hip, its edge just clear of the mat; StrengthLog brings the weight toward the hip, ExRx's medicine ball version touches the floor; keeping the plate by the ribs cuts that reach short, so less of its weight is out at the side | The model (lowest edge ~5 cm up); StrengthLog Core Twist (a plate is one of its loads); ExRx Medicine Ball Russian Twist; mechanics |
| Hold the trunk about 40 degrees back for the whole set; abdominals and hip flexors hold it; ExRx's medicine ball version lists spine and hip flexion as held (verification: was "ExRx lists", read as a page for this exercise); rising toward upright lets the load settle onto the hips | The model; ExRx (static spine and hip flexion); mechanics |
| Knees point up, feet flat; ExRx: twists with the hips held still allow more turning through the spine; knees tipping turn the hips | The model; ExRx Cable Twist comment; mechanics |
| Hold the plate by its rim, one hand each side (about three and nine o'clock), close in front of the chest at the middle; StrengthLog holds the weight with both hands in front of the chest; a rim grip keeps the plate steady, a plate pinched by its top edge can tip and swing | The model (wrists at the rim's sides, level with its centre, elbows 63 deg at the middle); StrengthLog ("Hold a weight plate, medicine ball, or kettlebell with both hands in front of your chest"); the steadiness clause is mechanics |
| Setup: as the medicine-ball twist, the plate by its rim | The model |

Activation: as the medicine-ball twist (same paint, same reasoning; a plate gives no reason to
change the values). The library row OBLIQUES / PLATE / intermediate fits.

## Labels

All rows below are on-screen rows (the spec writes them with `ov()`). Pills were drawn over the five
stills with `overlay.py`, then checked on the lab shots.
- Landmine Rotation (yaw -0.3): the lifter stands right of centre; the bar runs from the hands to
  its base at the bottom left; at 1 s the plate swings out to u ~0.33-0.43, v ~0.37-0.45. The
  right edge beside the lifter is too narrow for a pill. Left: turn 0.13 (Chest turns with the
  bar, to the chest; 0.16 in the draft, moved up in review, see Review), arms 0.27 (Arms long, to the right elbow), range 0.48 (Waist height, 12
  characters so it ends at u 0.27, clear of the bar at u >= 0.38 in that band; to the lumbar
  joint, which sits at waist height), tempo 0.60 (Steady pace, to the pelvis); right, below the
  feet: knees 0.80 (Knees soft, to the left knee). The leaders to the chest, lumbar joint and pelvis
  cross the thin bar; the arms leader crosses the chest on the left sweep, when the right elbow
  swings across (a fixed joint can't follow the alternating arms).
- Landmine 180 (yaw -0.3): the hands start at the top (v ~0.16) and come out to u ~0.37-0.48,
  v ~0.29-0.50 at 1-2 s. Left: turn 0.12 (Turn chest and hips, to the chest; ends at u 0.38, above
  the sleeve's path), top 0.17 (Start up high, to the right elbow; the two swapped in review, see
  Review), back 0.40 (Stay tall, to the
  neck, 9 characters, ending at u 0.24, left of the plate), hip 0.52 (To your hip, to the right hip
  joint, the side the first rep goes to), tempo 0.64 (Slow arc, to the pelvis).
- Russian twists (yaw -0.5): seated, feet to the left, knees up at v ~0.43, head at v ~0.33-0.40;
  the load swings out to the right (u ~0.7-0.92, v ~0.45-0.62) on the left twists and behind the
  body on the right ones. Left: knees 0.18 (to the near, left knee), tempo / grip 0.30 (to the
  right hand; the two swapped in review, see Review); right, below the eye button: lean 0.19 (to the head), turn 0.28 (to the near, left
  shoulder); bottom right, below the mat: low 0.80 (to the left hand, which is out at the right on
  the left twists; on the right twists its leader crosses the shins).

## Ghosts

Sizes, moves and checks are in the table comments of the faults file (from `final.py`). Every
ghost is built from turns or from joints re-seated with `resolve`: no drawn segment changes length
by more than 0.2 cm at any moment of the clip (the locked knees, at the edges of the sweep), and no
knee or elbow bends the other way (checked every 1/12 s by the side of the shoulder-wrist or
hip-ankle line each joint sits on).
- Moments: the landmines are drawn on the sweep to the lifter's right (rotation 1.0 s, 180 2.0 s),
  where the bar end swings out into the open left of the screen; the 180's start fault at 0.0 s;
  the twists on the twist to the lifter's left (2.0 s), where the load comes round to the near
  side. Strengths tie each fault to its side: the right hand's distance to the right hip for the
  landmines (none at 1.05 / 1.0 torso lengths, all at 0.85 / 0.75), the right hand's distance to
  the left hip for the twists (none at 0.80, all at 0.40); the 180's start fault by the right hand's
  distance to the pelvis (all at 1.5, none at 1.3). Lean (twists) shows at all times.
- Landmine Rotation: turn (the shoulder line 47 -> 13 deg, the chest nearly facing the anchor, both
  arms swung 25 deg back toward the bar end), arms (the hands ~22 cm back toward the chest, the
  elbows 153-159 -> 83-95 deg), range (the shoulder line 47 -> 28 deg, the hands ~15 cm higher),
  knees (the hips ~3 cm up and the knees re-seated, 150 -> 169-173 deg; seen 1.3 further round,
  where the knees bend across the screen). "tempo" has no ghost.
- Landmine 180: top (both arms 44 deg down, the hands 1.64 -> ~1.28 m; seen from the lifter's
  right, 1.0 round, so the arms swing across the screen instead of toward the camera and the bar
  runs off to the right, away from the top-left pill), turn (the shoulder line 77 -> 33
  deg, the arms swung 30 deg back), back (everything above the lumbar joint 25 deg forward, the
  trunk line 10 -> 26 deg), hip (the shoulder line 77 -> 48 deg, the hands ~17 cm higher). "tempo"
  has no ghost.
- Russian twists: turn (the shoulder line 48 -> 17 deg, the arms swung 25 deg back toward the
  load), low (the hands ~18 cm up the trunk, the elbows bending to ~79-97 deg), lean (the trunk
  turned 25 deg forward about the hips, 39 -> ~14 deg behind upright), knees (both knees ~10-13 cm
  toward the lifter's left, feet planted, knee angle 63 deg kept). "tempo" (medicine ball) and
  "grip" (plate) have no ghost.

## Lab rounds

- Compile check (`family.sh check twist`): built on the first run.
- Round 1 (`shoot twist "0,1,2,3,5"`, kept in `SCRATCH/lab/r3/twist/round1/`): every trainer still
  had its five pills clear of the lifter and of the moving bar, plate and ball; the legends on one
  line (landmines GLUTEUS MEDIUS . ANTERIOR DELTOID; twists OBLIQUES . RECTUS ABDOMINIS . HIP
  FLEXORS). Fourteen of the sixteen ghosts read as their mistakes. Two were weak: the 180's start
  ghost, seen from the front, drew the lowered arms pointing at the camera inside the chest; the
  rotation's arm pull was small (~29 pt at the hands). Fixed: the start ghost seen from the side
  (0.9 toward the lifter's left), the arm pull from 0.30 to 0.38 torso lengths (~36 pt).
- Round 2 (`shoot twist "0,1,2,3,6"`, kept in `round2/`; the copy edits made since round 1 do not
  change any label): all twenty trainer stills again clear (6 s adds the 180's left-hand bottom:
  the pills stay left of the hands' path; the Stay tall and Start up high leaders cross the arms
  there). The 180's start ghost, seen from the lifter's left, now read clearly (the arms forward at
  chest height under the model's raised arms), but in that view the bar runs off to the upper
  left under the Start up high pill; the arm pull read better at ~36 pt. Fixed: the start ghost
  seen from the lifter's right instead (1.0 the other way), where the bar runs off to the right.
- Round 3 (`shoot twist "0,2" "Landmine 180"`, kept in `round3/`): BUILD SUCCEEDED; the start ghost
  seen from the lifter's right reads clearly (the arms level at chest height under the model's
  raised arms, ~81 pt at the hands), its pill clear of the bar; the plate at the top of the rep sits
  just under the eye button in that view (equipment, not a label). The other three 180 ghosts and
  both trainer stills are unchanged. The final set in `SCRATCH/lab/twist/` is round 2's shots with
  the 180's start ghost and its 0 / 2 s stills from round 3 (`trainer.png`, `faults.png`).

## Open points

- The two landmine models lift the heel on the side the bar comes down to and turn that foot's
  toes inward (rotation ~5 cm and ~28 deg, 180 ~6 cm and ~34 deg), the mirror image of ExRx's
  cable twist, which raises the heel of the foot on the side the turn comes from.
  The copy cues neither heel; a builder fix (pivot the other foot) would let a pivot cue be added.
- No EMG for any of the four; the landmine rows rest on the library's Cable Wood Chop and the
  twists' on the library's Russian Twist, which themselves cite nothing.
- The arms label (rotation) and the low label (twists) track one fixed side's joint, so on the
  other side's sweep or twist their leaders cross the body.
- Mistake views: in the rotation's locked-knees view (1.3 round toward the lifter's left, where the
  knee bend shows best) the lifter's head sits behind the COMMON MISTAKE chip, and in the 180's
  start view (1.0 round toward the right) the plate sits just under the eye button; the ghosts and
  their pills are clear in both.

## Review (2026-10-05)

An independent sources and model review of the four files, round 3 of the 401-500 batch. Working
files are in `SCRATCH/lab/r3/twist/review/`; the four files as the author left them are kept in
`review/before/`, the first review lab output in `review/lab_review1/`.

- Sources reopened, fresh copies rather than the author's: the four Europe PMC records (Swie &
  Sakamoto 2004, Electromyogr Clin Neurophysiol 44(2):111-126; Andersson 2002, Spine 27(6):E152-60,
  doi:10.1097/00007632-200203150-00014; Vinstrup 2015, Scientifica 2015:403068,
  doi:10.1155/2015/403068, PMC4628648; Andersson 1997, Eur J Appl Physiol 75(2):115-123,
  doi:10.1007/s004210050135): authors, journals, years, pages, DOIs and PMIDs match the header, and
  every abstract claim is there (ten men, standing unresisted twists held at graded angles, a
  significant rise over the untwisted posture only past 30 deg; rectus abdominis little activated
  in all rotations, the external oblique contralateral-dominant; hip flexors highly active only with
  hip flexion). Vinstrup's full text (PMC XML): 17 untrained men, 10RM, standing with feet
  shoulder-width, arms horizontal and extended, feet, legs and hips stationary; Table 2 elastic /
  machine rectus abdominis 10 / 16, external obliques left 54 / 77 and right 47 / 41, erector
  spinae left 24 / 18 and right 50 / 32 (P = 0.03) % MVC; the Discussion puts the difference
  most likely down to sitting versus standing and adds the elastic set-up's longer lever arm. ExRx
  through the Wayback Machine at the cited snapshots (Obliques 20260202082020, Rectus Abdominis
  20260528230856, Cable Twist 20250803155043, Medicine Ball Russian Twist 20250827094522),
  StrengthLog Landmine Rotation (dateModified 2025-09-17) and Core Twist (2026-06-12) and Fitness
  Volt's Landmine 180 (Matthew Magnante, ACE; published 2022-05-25, modified 2024-08-11) fetched
  live: every quote in the claim tables is on its page.
- Changed, sources: the 180's back cue said the lower back worked about as hard as the obliques,
  "which the authors put down to the standing position"; the authors explained why the elastic
  standing twist had more erector spinae activity than the seated machine (mostly standing, plus
  the lever arm), not why it matched the obliques. It now says the lower back worked about as hard
  as the obliques and harder than in a seated twist machine, which the authors linked mostly to
  standing. Added to the notes: Fitness Volt bends the bottom arm and keeps the top one extended,
  while the model bends the arm that crosses over; the copy follows the model and cites neither.
- Changed, copy: the rotation's arms cue said the bar end can only travel as far as the trunk
  turns it, an absolute the shoulders could break; on the model the hands stay within 6 deg of the
  chest's facing all clip (review measurement), so it now says the bar end stays in front of the
  chest and the trunk has to turn to carry it across. The 180's bottom cue said the arm reaching
  across bends a little; it goes from 144 to 117 deg, so it now bends more at the elbow. The twists'
  low cues called the ball or plate held by the ribs a mistake with the reason that it stays close
  to the trunk, which reads against the library's Russian Twist (ball at chest height, reaching far
  out to tap the floor its mistake): the medicine-ball why now opens with what this version does
  (the ball down to the floor each side, ExRx), the correct cue says close beside the hip (the
  ball's centre is 37 cm from the midline), and both whys and the comparison note give the reason
  as less of the load out at the side, where the trunk has to stop it and turn it back (mechanics:
  beside the hip the ball sits ~0.23 m to the side of the reclined trunk's axis). The plate twist's
  knees why repeated a clause of the medicine-ball one word for word; reworded.
- Changed, labels. A clearance script over every 1/12 s of each clip, using the sleeve's, plate's
  and ball's real mesh points and the bone lines (`review/rpills.py`, `rdense.py`, `rlead.py`),
  found three clashes between the author's whole-second stills: (1) Landmine 180: on the way down
  and back up (~0.2-0.6 s, ~3.4-3.8 s) the plate and the arms passed under the right end of the
  Turn chest and hips pill (0.21), up to ~9 pt deep, and through the whole right-hand rep the Start
  up high leader (0.13, to the right elbow) ran across that pill's right end (two leaders seemed to
  leave it in the 1 and 2 s shots). Now Turn chest and hips is on top at 0.12 and Start up high
  under it at 0.17: ≥7.6 pt and ≥14.9 pt from the moving equipment, no leader over a pill (rows of
  0.12 on the left are used by nine earlier pills). (2) Landmine Rotation: the sleeve end grazed the
  bottom of Chest turns with the bar (0.16) at ~0.25 s; it is at 0.13 now, ≥8.5 pt clear. (3) Both
  twists: on every right twist the rhythm / grip leader to the right hand ran down along the right
  end of the knees pill (visible in the 1 and 3 s shots); the two rows are swapped (knees 0.18,
  rhythm / grip 0.30), so no leader passes over a pill; the two leaders now meet near the near knee
  on the left twists. Every other label was checked the same way and is unchanged.
- Model checked independently (`review/rdump.py` reads the USD with pxr: joints every frame and
  the HG_ meshes' points; `rmeas.py`, `rextra.py`): every number in the header and the model-fact
  paragraphs holds (rotation 47 / 26 deg, hands 1.46 m and 1.03-1.11 m, knees 168 -> 150, the same-
  side heel 5 cm up with the toes turning ~28 deg in, anchor 1.95 m; 180 hands 1.64 m with the head
  joint at 1.58 m, 77 / 42 deg, crossing elbow 117 deg, ankles 46 cm; twists 39 deg lean, 47.5 deg
  turns at 0.67 / 2.0 s, pelvis and legs still, ball 24 cm and plate 28 cm with their lowest points
  5.0 and 5.2 cm off the mat, the two twists' trunks identical and hands within 3 cm). Corrected in
  the spec, notes and faults comments: the two twists match within ~3-4 cm at the hands and elbows
  (not ~1 cm); the rotation's elbows 138-162 deg (not 144-162), the library Russian Twist's hands
  0.48-0.60 m (not 0.54-0.57), the twists' arm abduction ~34-55 deg (not 43-48); the spec comment's
  sit-up range 0.72-0.88 to match the situp family.
- Ghosts: the author's `ghost.py` was read line for line against `FaultGhost.solve` / `BodyFrame`
  (turn mirroring for `_R` pivots off the lateral axis, `resolve`, `between`, tips along the bone's
  +Y) and its projection against `joints.json` (exact to the third decimal); all 16 faults were then
  rewritten from the Swift table and solved every 1/12 s (`review/rcheck.py`, `rsize.py`): no drawn
  segment changes length by more than 0.18 cm (the locked knees), no elbow or knee bends the other
  way, every size in the table comments matches within ~1 cm / 2 pt, and each fault shows only on
  its side (rotation 0.6-1.4 and 4.6-5.4 s, 180 1.4-2.6 s and its start fault at the tops, twists
  around 2.0, 4.67 and 7.33 s). Every ghost on the lab sheet reads as its named mistake, attached
  and possible; none changed.
- Activation re-checked against `tiers.txt` (bright = primary, dim = secondary, the three
  landmine dim muscles named with the stabilisers for legend width as the cablecrunch and sidebend
  families did), the levels against the fractions and the library anchors (Cable Wood Chop
  obliques 0.78, rectus abdominis 0.44, shoulders among its stabilisers; Russian Twist 0.76 / 0.52 /
  0.38); all are labelled judgement calls; unchanged. The anterior deltoid's 0.30 is at the low end
  for the 180, which raises the loaded sleeve to eye level every rep, but no EMG argues a number.
- Lab: `family.sh shoot twist "0,0.4,1,2,3"` (BUILD SUCCEEDED; trainer stills at the transits and
  all 16 ghosts; kept in `review/lab_review1/`), then `shoot twist "0,0.35,0.4,2,6" "Landmine 180"`
  for the 180's final rows (BUILD SUCCEEDED; kept in `review/lab_review2/`; a last
  `family.sh check twist` after comment-only edits also built; the final set, review 1's shots with
  the 180's from review 2, is copied back into `SCRATCH/lab/twist/trainer` and `faults`). On both: the rotation's top pill clear of the sleeve at 0.4 s; the 180's
  two top pills clear of the hands, sleeve and plate at 0.35 and 0.4 s (the hands ~25 pt from Start
  up high), each leader leaving its own pill at 0, 2 and 6 s; the twists' rhythm / grip leader
  straight down to the right hand at 0.4 and 1 s, clear of the knees pill, and meeting the knees
  leader near the near knee at 2 s; all 16 ghosts and their mistake views as before (the 180's turn
  pill at 0.12 sits under the COMMON MISTAKE chip with room to spare). The legends are unchanged.

## Verification (2026-10-05)

A final claim-by-claim check after the review, trying to refute every factual claim and number in the
copy, the spec's header and activation comments, the faults comments and the claim tables above.
Working files are in `SCRATCH/lab/r3/twist/verify/`.

- Sources fetched fresh, not the author's or the reviewer's copies: the four Europe PMC records
  (`epmc_*.json`) and Vinstrup's full text (`vinstrup.xml`, PMC4628648); ExRx Obliques, Rectus
  Abdominis, Cable Twist and Medicine Ball Russian Twist at the cited Wayback snapshots; StrengthLog
  Landmine Rotation (dateModified 2025-09-17) and Core Twist (2026-06-12) and Fitness Volt's
  Landmine 180 (Matthew Magnante, ACE; 2022-05-25, updated 2024-08-11, the swinging mistake under
  its Common Mistakes To Avoid heading) fetched live. Every quote in the claim tables is on its
  page; the citations' authors, years, volumes, pages, DOIs and PMIDs match; Vinstrup's Table 2
  (rectus abdominis 10 / 16, external obliques 54 / 77 and 47 / 41, erector spinae 24 / 18 and
  50 / 32, P = 0.03) and Discussion (standing "most likely", plus the lever arm) match the copy and
  comments. The rejected papers exist as listed (Mandroukas 2022 JFMK 7(3):67; Kawama 2022 JSSM
  21(4):493-503, a sit-up twist with rectus abdominis only; Hiremath 2025 JPES 25(1):175-185). The
  library anchors hold (Cable Wood Chop obliques 0.78, rectus abdominis 0.44; Russian Twist 0.76 /
  0.52 / 0.38), as do the calfseat gastrocnemius 0.40 and the situp family's 0.72-0.88.
- Model, read again from the USD with my own pxr dump (`vdump.py`, joints and joint rotations every
  frame, the HG_ meshes every other frame; `vmeas.py`, `vextra.py`, `vface.py`, `veq.py`): every
  model number in the copy, header and notes holds. Rotation: hands 1.46 m at the top (shoulder
  joints 1.42, 49 cm in front), 1.03 / 1.11 m at 1.0 and 3.0 s, 47 cm in front of and 8 cm outside
  that hip; shoulder line 47.0 deg, hip line 25.8, head 46.9; elbows 138-162 (144 at the top,
  153 / 159 at the sides); knees 168 -> 150; lean 7.6 -> 13.1 deg forward and 6.4 to the side;
  pelvis 1.8 cm down, 7 cm across; ankles 42 cm, shoulder joints 39, toes out 10 deg; the right heel
  5.1 cm up and 5.5 cm out with the foot turning 28 deg in on the right sweep, toe joints still to
  0.5 mm; the hands within 6.1 deg of the chest's facing all clip; pivot at z 1.95-2.05 m. 180:
  hands 1.64 m (23 cm above the shoulder joints, the head joint 1.58 m, the skull top ~1.76 m, so
  about eye level), arms 119 deg from the trunk; 77.2 / 42.4 deg at 2.0 s, within 1 deg from 1.75 to
  2.25 s; hands 1.03 / 1.09 m, 41 cm in front of and 10 cm outside the right hip; crossing elbow 117,
  the other 145; knees 143-150; lean 9.5 forward, 10.2 sideways; pelvis 3.2 cm down; ankles 46 cm;
  heel 6.1 cm, foot 34 deg in. Twists: lean 38.6-39.4 deg; knees 63; feet flat; ankles 30 cm, knees
  37; shoulder line 47.5 deg at 0.67 / 2.0 s, back at 1.33 / 2.67; the head's rotation equal to the
  chest's (52 deg about the reclined trunk); pelvis and legs still; elbows 64 / 63 at the middle,
  121-142 (ball) and 118-130 (plate) at the sides, the hands nearly still for ~0.33 s there; ball
  24 cm, centre 37 cm out and 6 cm behind the hip joints, lowest point 5.0 cm; plate 28 cm, held
  tilted ~30 deg back with the wrists at its sides level with its centre, lowest edge 5.2 cm; the two
  twists' trunks and legs identical, hands within 3.1 cm, elbows 4.1 cm. Library Russian Twist: lean
  26.6-28.2, shoulder line 22.2, elbows 65, hands 0.48-0.60 m, one side every 2 s.
- Ghosts: the reviewer's `rcheck.py` / `rsize.py` (Swift table rewritten in Python) rerun on the
  author's port: every size in the table comments matches, worst segment change 0.18 cm, no joint
  bending the other way, each fault on its own side. No ghost, label, row, cue id or tracked joint
  was changed, so no new shots were taken.

Changed (text only):
- Rotation knees why and 180 turn why: ExRx's cable twist was cited for "much of the turning force"
  coming from the hips; ExRx puts the force in the forward hip of its staggered stance and says the
  movement arguably involves more hip rotation than spinal rotation. Both now say much of the turning
  comes from the hips rather than the spine.
- 180 back why: "the bar end drops by turning your trunk" was wrong mechanics: a turn about the
  vertical does not lower the hands; on the model the upper arms come down from 119 deg to 46-65 deg
  from the trunk. It now says the bar end comes down as the trunk turns and the arms lower, not by the
  trunk bending.
- Medicine-ball low why: "the ball goes down to the floor" became "nearly to the floor" (the model
  stops ~5 cm short, as its intro says).
- Medicine-ball knees why: "the pelvis has to stay still for the turn to happen in your trunk" (an
  absolute) became "with the pelvis still, the whole turn happens in your trunk".
- Plate twist lean why: "ExRx lists" became "ExRx's medicine ball version lists" (ExRx's static
  flexion is on that page, not a page for this exercise).
- Spec header and notes: the heel's "usual back-foot pivot" and "the web landmine guides pivot the
  back foot" had no source read here; they now name only ExRx's cable twist (the heel nearest the
  pulley raised) and Fitness Volt (feet planted). The library's Cable Wood Chop also lifts the back
  heel, so the model's same-side heel stays uncued. Andersson 1997's journal is Eur J Appl Physiol
  Occup Physiol; the Vinstrup line now says "most likely" and names the lever arm; the cable twist
  line adds the raised heel and the hip-over-spine comment; the twists' lateral deltoid comment
  names the arm on the load's side (41-55 deg of abduction; the other arm crosses the body).
- Faults comments: the rotation's and 180's turn ghosts named the left hand and left elbow "far";
  in the yaw -0.3 framing they are the near ones (both nearer the camera than the right), so they
  read "near (left)" now. No code changed.
- Validation: `python3 spec_500.py twist` prints OK; `family.sh check twist` after all the edits:
  BUILD SUCCEEDED (log in `verify/check.log`).

Doubts left: Swie and Sakamoto's abstract does not say how the twisting angle was measured; the
rotation's chest turns 47 deg over the floor but only ~21 deg over its hips, so the copy states the
finding without saying this lift passes 30 deg. The "locked knees make the hips harder to turn",
"less of its weight out at your side" and "a rim grip keeps the plate steady" clauses are
mechanics, not sourced.
