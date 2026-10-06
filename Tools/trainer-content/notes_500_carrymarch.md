# 401-500 folder, round 3: loaded marches (2026-10-05)

Two exercises from the builder's 445-474 exports: 469 Farmer Carry March and 470 Suitcase Carry
March (models `Abs/FarmerCarryMarch.usdc`, `Abs/SuitcaseCarryMarch.usdc`). `spec_500_carrymarch.py`
holds the copy and setup steps (its header lists what each model shows and the full citations),
`Tools/fault-review/faults_500_carrymarch.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_carrymarch.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on. SCRATCH
is the session scratchpad (`/private/tmp/claude-501/.../scratchpad`); the lab is `SCRATCH/lab`.

## How the models were read

- The round's arm and leg briefs (`SCRATCH/lab/r3/briefs/<Resource>.md`, `briefs_legs/`),
  `SCRATCH/lab/r3/tiers.txt`, `joints.json` and the trainer stills at 0/1/2/3/5 s
  (`SCRATCH/lab/r3/stills/`).
- The rigs straight from the USD with Blender's Python + pxr (`SCRATCH/lab/r3/carrymarch/`):
  `series.py` samples every frame (192 frames, 24 fps): both knees, hips (neck-hip-knee) and
  elbows, the thigh's angle below level, ankle and toe heights, pelvis position, the hip line's
  and shoulder line's tilt and turn, trunk lean forward and sideways (neck over pelvis), hands,
  the arm's angle from straight down, and the world bounds of `HG_WeightL/R`
  (`series_<Resource>.json`). `probe0.py` lists the prims and joints.
- Ghosts: `gh.py`, a Python port of `FaultGhost.solve` (body frame, shift / turn / straighten /
  resolve, strengths, tips, the `_bent` / `_straight` roles) plus the trainer projection
  (probe.py's camera with the framing, the fault's `view` and the mistake view's `roomBelow`
  0.26 shrink and lift). `check_proj.py` shows it reproduces `joints.json` to the third decimal at
  view 0. `report()` prints every moved joint in cm and pt, every drawn segment whose length
  changes by more than 3 mm, and knee and elbow angles with the side each knee bends to.
  `pieces.py` mirrors the Swift pieces; `size1.py`, `size2.py` sized them.
- Labels: `preview_500.py carrymarch`, then `ov.py` (pills drawn ~24 + 6.4 pt per character, 28 pt
  tall, leaders to the probed joint at each still, the eye button and legend boxed) over the five
  stills, then the lab shots.
- Sources: Europe PMC REST records (abstracts; `lit/e_<PMID>.json`), the full texts of Ellestad
  2024 (`lit/ellestad.xml`) and Stastny 2015 (`lit/stastny.xml`) from Europe PMC, PubMed for the
  McGill and Andersson abstracts (`lit/pubmed_abs.txt`), Crossref for the Bordelon abstract (PubMed
  and Europe PMC carry none), ExRx through the Internet Archive (`lit/x_iliopsoas.html`,
  `lit/x_gmed.html`), The Prehab Guys and Motra pages fetched raw (`lit/pg_*.html`,
  `lit/motra_*.html`, text pulled with `lit/txt.py`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.592 m). Both clips 7.96 s, looping. The two clips have the
  same legs and trunk frame for frame (every leg, pelvis and trunk number below is identical in
  the two series); they differ only in the arms and dumbbells.
- Stance: hip joints 18.3 cm apart, ankle joints 22 cm apart (feet about hip-width), toes forward,
  standing knee 173-174 degrees, trunk 0.4 degrees back and at most 0.1 degrees to the side,
  shoulder line level (tilt under 0.001 degrees), hip line level (pelvis tilt 0.0 all clip), the
  pelvis 0.909 m up every frame, sliding 1.6 cm toward the standing leg on each lift and turning
  2 degrees at most. No travel: the standing ankle stays at z 0.06 m.
- The march, left knee first: the left heel leaves the floor at ~0.1 s (the ankle joint 1 cm up at
  0.125 s); the knee rises to 78 degrees by ~0.6 s; holds 0.62-1.15 s (knee 78.4, hip 98.4 between trunk and thigh, the thigh
  7.3 degrees below level, the knee joint 5.6 cm below and 44 cm in front of the hip joint, the
  shin tipped 19 degrees back from vertical so the foot sits a little behind the knee, the ankle
  joint 47.6 cm and the toe joint 38.6 cm off the floor against 6.9 and 1.6 standing); lowers
  1.2-1.71 s; the foot is down at 1.71 s. Both feet down 1.71-2.13 s. The right knee the same
  2.13-3.71 s, both down to 4.13 s, then again: four lifts in the clip, one every 2 s, each foot
  off the floor ~1.6 s from heel off to heel down (0.08-1.75 s) but wholly clear of it, the ball
  of the foot included (toe joint up), only ~1.3 s (0.25-1.58 s); each phase (rise, hold, lower)
  about half a second.
- Paint (`tiers.txt`): see each exercise. "Hip Flexors" is the library's legend-only name for
  the rig's Sartorius mesh (README, round 2); it counts for no muscle group.
- Legend: one line per rank (`lineLimit(1)`), 354 pt wide, the names in 9.5 pt mono with 0.07 em
  tracking before the dot and the `SECONDARY` word; the estimate was ~43 characters of names,
  the lab says fewer (below). Farmer secondary: GLUTEUS MEDIUS · TRAPEZIUS · OBLIQUES (37); suitcase:
  FOREARMS · ERECTOR SPINAE · GLUTES (34). Lab round 1 showed the draft's FOREARMS · ERECTOR
  SPINAE · GLUTEUS MEDIUS (42) truncated ("GLUTEUS MEDI..."), so the real limit is nearer 39-40.
- Library rows (checked against the models, no change needed): Farmer Carry March GRIP + CORE /
  DUMBBELL / beginner (two dumbbells; grip leads the counted muscles, see below), Suitcase Carry
  March OBLIQUES / DUMBBELL / beginner (one dumbbell; obliques bright). Both are already logged
  in seconds (`ExerciseCatalog.timedExercises`) and filed as carries by
  `ExerciseRotation` (the name contains "carry"); `fault_times.py` classes them as `carry`
  ("march"), but every moment is given in seconds here.

## Sibling and library check

- Library Farmer's Carry, Suitcase Carry, Overhead Carry (`spec_191_240_shrugcarry.py` and its
  notes; the content in SampleData): walked on the spot with short low steps, one step every 2 s
  (farmer) or 1 s; forearm flexors primary (0.80) on the farmer, obliques primary (0.60) on the
  suitcase, the suitcase's rows forearm flexors 0.55, erector spinae 0.50, trapezius 0.44,
  gluteus medius 0.42. Their sources (Ellestad 2024, Stastny 2015, Bordelon 2021, McGill 2009,
  Neumann and Cook 1985) are the ones re-read here. The marches differ by the high, held knee
  and no travel. The library suitcase carry holds the dumbbell in the LEFT hand; this march in
  the RIGHT.
- Round 2's Farmer's Walk on Toes (`spec_500_calfmore.py`): steps on the spot on the balls of the
  feet, soles ~3 cm up, 1.5 steps a second; its hip cue and ghost idea (the lifted side's hip
  sagging, seen from the front) is reused with a new piece that keeps the lifted leg hanging
  straight (below). Its pieces sit inside the 401-500 block, which `--only` integration replaces,
  so this family defines its own (`carryMarch500*`).
- `dupes.py` (`SCRATCH/lab/r3/carrymarch/`): no sentence of 26 characters or more in this
  family's cues, setup, comparison or labels appears in SampleData.swift, setup.py or any other
  spec file. The draft repeated two (the library suitcase carry's "Trunk bends to the dumbbell"
  and "Leaning toward the dumbbell, the loaded shoulder dropping"); both reworded.

## Farmer Carry March

Model facts: a dumbbell in each hand (`HG_WeightL/R`, 0.34 m long, handles front to back, centres
0.82 m up beside the thighs, lowest point 0.73 m), palms facing in (the brief's palm vectors point
at the midline), arms long (elbows 171) and ~15 degrees out from the sides (hands 33 cm from the
midline); the dumbbells move about 6 mm at most all clip (centres within 6.3 mm). Framed three-quarter from the front left
(yaw -1.0). Paint: ONLY Sartorius bright; dim: Brachioradialis, the extensor and flexor carpi and
digitorum muscles, PalmarisLongus, ExternalOblique, InternalOblique, GluteusMaximus, Medius,
Minimus, RectusAbdominis, RhomboidMajor, TrapeziusLower, Middle, Upper.

| Claim | Source |
|---|---|
| Knee: drive each knee up until the thigh is about level with the hip, and hold it a moment | Motra, Dumbbell Farmer's March ("Lift one knee slowly until the thigh is parallel to the floor"; "Pause briefly at the top to establish balance"); the model (thigh 7 degrees short of level, held ~0.55 s) |
| The hip flexors lift the leg and hold it | Andersson 1995 (psoas and iliacus "coactivated ... particularly when hip flexor torque was required"); ExRx Iliopsoas (hip flexion) |
| For those moments you balance yourself and both dumbbells on one foot | The model (the whole foot clear of the floor ~1.3 s per lift, the heel up ~1.6 s) |
| One guide lifts the knee until the thigh is parallel, pauses briefly at the top, lowers under control, and lists rushing the tempo as a common mistake | Motra, Dumbbell Farmer's March ("Lower the foot back to the ground under control"; common mistakes: "Rushing the tempo") |
| Here the thigh stops just short of level, holds about half a second and comes down in about half a second | The model (rise 0.125-0.6 s, hold 0.62-1.15 s, lower 1.2-1.71 s) |
| Correct: the foot just behind the knee; one knee about every two seconds | The model (shin 19 degrees back; a foot leaves the floor at 0.13, 2.13, 4.13 and 6.13 s) |
| Posture: the knee rises because the hip bends; leaning the shoulders back raises the thigh further off the floor without the hip bending any more, so part of the knee's height comes from the lean instead of the hip (comparison: the lean tips the trunk instead of bending the hip further) | Mechanical reasoning (the thigh's angle to the floor is the hip angle plus the trunk's lean). The draft said the hip flexors then do less of the lifting; the torque that holds the thigh up depends on the thigh's angle to the floor, not on the lean, so that was cut (review) |
| One guide lists leaning backward among its common mistakes; another says keep the back straight up and do not bend over | Motra, Dumbbell Farmer's March (common mistakes: "Leaning backward"); The Prehab Guys, Carry - Suitcase, Bilateral, In Place ("Keep your back straight up, don't bend over") |
| Hips: each lift leaves you on one leg for well over a second with both dumbbells | The model (the left foot wholly clear of the floor 0.25-1.58 s, the heel up 0.08-1.75 s; was about a second and a half until verification) |
| The standing leg's hip muscles, the gluteus medius among them, keep the other side of the pelvis from sagging | ExRx Gluteus Medius ("Steadies pelvis so it does not sag when opposite side is not supported with leg"); Graber 2021's abstract (pelvic drop is caused by decreased hip abductor activity) |
| In one farmer's walk study, group averages for the gluteus medius ran from about 26 to 47 percent of its maximum | Stastny 2015 (the means of its strength-ratio subgroups, 26 +- 10 to 47 +- 19 %MVIC; 16 trained men, 75% of 6RM) |
| Grip: the dumbbells hang from your hands for the whole set | The model; the set is timed |
| One guide says to grip hard, another to keep the dumbbells at your sides, not moving forward or backward | Motra (form cue "Grip hard"); The Prehab Guys, bilateral in place ("Keep the dumbbells at your side, don't move them forward or backward") |
| A dumbbell that swings forward takes its weight out from under the shoulder, so the shoulder and trunk hold it out in front | Mechanical reasoning (a moment arm about the shoulder) |
| Shoulders: two dumbbells pull down on the shoulders for the whole set | Mechanical; the model |
| One guide lists the shoulders rounding forward among its common mistakes; another says not to shrug either shoulder, traps relaxed | Motra, Dumbbell Farmer's March (common mistakes: "Shoulders rounding forward"); The Prehab Guys, bilateral in place ("Don't shrug your shoulders on either side, keep your traps relaxed") |
| Setup: grip each handle in the middle, palms facing in; march on the spot, one knee about every two seconds | The model; the library Farmer's Carry set-up (reworded) |

Activation, and the deliberate exception. The paint lights only the hip flexors, a legend-only
name, and `validate()` now needs a primary row the app counts, or the exercise would belong to no
muscle group. So Hip Flexors stays a PRIMARY row (bright, 0.60, below) and one dim muscle is
promoted to PRIMARY: the forearms. Why the grip and not the core (the library row reads GRIP +
CORE): the dumbbells hang from the hands for the whole timed set, the library's Farmer's Carry
ranks the forearm flexors first at 0.80 for the same job, and The Prehab Guys' in-place version
says you feel the forearms first in its list ("You should feel the muscles in your forearms,
shoulders, and hips working"); the trunk muscles measured low in a farmer's carry (Ellestad 2024,
Table 2: external oblique 11.1-14.2, rectus abdominis 8.4-10.7, longissimus 13.7-16.4, multifidus
14.9-16.3 %MVIC, against a plank's 34.5-36.1 external oblique and 48.8-54.1 rectus abdominis).
Motra rates the abs and obliques first for its farmer's march, but that is a guide's rating, not
a measurement. Forearms 0.80 HIGH: the Farmer's Carry value, a judgement (no forearm EMG of any
carry was found), named "Forearms" because the paint lights the flexors, extensors and
brachioradialis alike. This is the one break of bright = primary in the family, said in the code
comment.
- Hip Flexors 0.60 MODERATE (shared with the suitcase march): one leg at a time, driven to just
  short of level and held ~0.55 s against only the leg's own weight; under the library's Hanging
  Knee Raise (0.76), where both legs hang from the hips. A judgement; Andersson 1995 supports
  the role, not a level.
- Gluteus Medius 0.45 MODERATE (dim glutes): Stastny 2015's 26-47 %MVIC in a farmer's walk; the
  library carry's 0.40 nudged for the ~1.3 s on one leg per lift. A judgement.
- Trapezius 0.40 MODERATE (all three parts dim; named whole): a little under the Farmer's Carry's
  upper trapezius 0.45 because the row names the whole muscle. A judgement (no trapezius EMG of a
  farmer's carry was read; The Prehab Guys' ask for relaxed traps is a form cue, not a level).
- Obliques 0.35 LOW (dim): the Farmer's Carry's value; Ellestad 2024's 11-14 %MVIC.
- Stabilisers: rectus abdominis and rhomboids (painted dim; legend width), erector spinae
  (Ellestad 2024's longissimus and multifidus, 14-16 %MVIC; not painted), quadratus lumborum
  (not painted; the library carries list it; McGill 2009's abstract gives the quadratus lumborum
  supporting the torso and pelvis in the frontal plane as its yoke-walk example, with the farmer's
  walk and suitcase carry among the events studied).

## Suitcase Carry March

Model facts: one dumbbell, in the RIGHT hand (`HG_WeightR`, the same size and place as the farmer's
right), palm in, arm long (171) and still. The free left arm hangs relaxed, elbow 163-168, the
hand 24-27 cm from the midline (the loaded hand 33 cm), swinging from 2 degrees behind to 18
degrees in front of straight down (rest 6), forward while the right knee is up (2.6-3.1 s). No
lean toward the dumbbell: shoulders level and trunk upright every frame (as the shared facts).
Framed nearly face-on (yaw -0.3). Paint: ExternalOblique, InternalOblique and Sartorius bright;
dim: the forearm muscles, ErectorSpinae, the three glutei, RectusAbdominis, RhomboidMajor, the
three trapezius parts.

| Claim | Source |
|---|---|
| Level: a dumbbell in one hand pulls the trunk down toward it, so the muscles on the other side hold you upright | Mechanical; Bordelon 2021 (suitcase position: the gluteus medius and external oblique away from the load significantly more active); Ellestad 2024 |
| In one EMG study of a suitcase carry with the weight in the right hand, the left external oblique worked at about a third of its maximum, about as hard as in a plank, more than three times the right side's level | Ellestad 2024, full text: "For the SC and SH, participants used their right arm to hold the weight"; Table 2 suitcase carry EO left 33.0 +- 4.2, right 9.6 +- 1.7 (3.4x); plank EO left 34.5 +- 4.8, right 36.1 +- 4.0; the SC left value is marked different from the farmer's carry and hold only, not from the plank |
| Leaning toward the weight lets it bend you sideways instead | Mechanical reasoning |
| Shoulder: one guide for this exercise says not to shrug but keep the trap relaxed while holding the dumbbell; a guide to a one-dumbbell march lists shrugging the shoulder among its common mistakes | The Prehab Guys, Carry - Suitcase, Unilateral, In Place ("Don't shrug your shoulder, keep your trap relaxed while holding the dumbbell"); Motra, Dumbbell Single-Arm March (common mistakes: "Shrugging shoulder"; it marches forward, so not "another" guide for this exercise) |
| A shoulder hitched up also tips the shoulder line out of level | Geometry |
| Knee: each high knee leaves you on one foot with the load off to one side, so the trunk and standing hip hold you up on their own | The model; mechanical |
| One guide to a one-dumbbell march takes the knees to hip height; here the thigh stops a few degrees short of level and pauses | Motra, Dumbbell Single-Arm March ("Lift knees to hip height with full steps forward"; it marches forward, so the copy says "a one-dumbbell march", not "this march"); the model (7 degrees short, held ~0.55 s). The Prehab Guys says to bring the knee to the chest; the copy follows the model |
| Hips: with the dumbbell in the right hand, the left hip works hardest standing on the left foot as the right knee comes up | Neumann and Cook 1985 (24 adults; a load carried contralateral to the stance hip gave its gluteus medius the highest EMG); the model (right knee up 2.13-3.71 s) |
| In walking studies a load in the hand opposite the standing leg drew the most from that hip's gluteus medius, and a weight in one hand raised hip abductor activity on the side away from it | Neumann and Cook 1985; Graber 2021 (26 adults, 15-20% body weight in one hand: hip abductor activity higher contralateral to the weight, no change ipsilateral) |
| Tempo: one guide to a one-dumbbell march asks for a controlled march and lists rushing the steps among its common mistakes | Motra, Dumbbell Single-Arm March (form cue "March controlled"; common mistakes: "Rushing steps"; tempo 2-0-2) |
| Here a knee comes up every two seconds and pauses about half a second at the top | The model |
| A controlled pace gives you time to shift onto the standing foot as each knee comes up | Coaching wording built on The Prehab Guys' "Shift your weight to one side as you bring the other knee to your chest" |
| Switch the dumbbell to the other hand when the set time is up (cue and setup) | Motra, Dumbbell Single-Arm March ("Switch the dumbbell to the other hand and repeat") |
| Hips correct: hold the pelvis level as you shift onto the standing foot; take extra care as the knee on the dumbbell side rises | Neumann and Cook 1985 (above); worded by side, not as the right knee, because the copy switches the dumbbell to the other hand each set |
| Comparison: staying upright makes the free side's obliques, and the hip you stand on, hold the load | Ellestad 2024 (the free side's external oblique 33 %MVIC); the hip you stand on, mechanical (with the free-side knee up you stand on the loaded side) |
| Setup: pick it up in your right hand, palm facing in | The model |

Activation (paint: obliques and hip flexors bright -> both PRIMARY):
- Obliques 0.62 MODERATE: the library Suitcase Carry's 0.60, nudged for the time on one leg; the
  side away from the load at 33 %MVIC in Ellestad 2024, about a plank's level; Bordelon 2021 on
  the side. A judgement.
- Hip Flexors 0.60 MODERATE (shared). Andersson 1995 also found the psoas "selectively involved
  ... in contralateral loading situations requiring stabilization of the spine in the frontal
  plane"; the abstract does not say how the load was held, so the copy does not use it.
- Forearms 0.55 (dim): the Suitcase Carry's forearm flexors; the load hangs from one hand.
- Erector Spinae 0.50 (dim): the Suitcase Carry's value; Ellestad 2024 left longissimus 29.1 and
  multifidus 21.0 %MVIC with the weight in the right hand.
- Glutes 0.42 (dim: gluteus maximus, medius, minimus): the Suitcase Carry's gluteus medius value;
  Neumann and Cook 1985, Graber 2021, Bordelon 2021 (the gluteus medius away from the load). Named
  "Glutes" (files under glutes like the library's "Gluteus Medius") because the full name
  truncated the legend on lab round 1's shot; the paint lights all three glutei.
- Stabilisers: quadratus lumborum (the library Suitcase Carry's; McGill 2009 as above), trapezius,
  rectus abdominis and rhomboids (the last three painted dim; a fourth secondary name would
  truncate the legend). The library Suitcase Carry lists the trapezius as a secondary row at 0.44,
  just above its gluteus medius 0.42 (its comment quotes Bordelon 2021's Table 2: the loaded side's
  upper trapezius 21-28 %MVIC, the far gluteus medius 10-13; the full text was not re-read here).
  Keeping the glutes and moving the trapezius to the stabilisers is a judgement for the march's
  added time on one leg (the hips cue), not an EMG ranking.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`).

- Farmer (yaw -1.0, the lifter facing screen-left; the near arm and dumbbell u ~0.60-0.84, the far
  arm and dumbbell u ~0.35-0.51; the lifted knees out to u ~0.27-0.45 at v ~0.45-0.72): posture
  (Tall, no leaning back, to the head) 0.16 left; shoulders (Shoulders back, to the near shoulder)
  0.16 right, below the eye button; grip (Weights hang still, to the far hand) 0.28 left (0.34 until review, see Review), above
  the far dumbbell; hips (Hips level, to the far hip) 0.60 left, between the lifted thigh and the
  lifted right shoe; knee (Knee up to hip height, to the far knee) 0.78 left, under the lifted
  shoe. The hips leader passes over the lifted near thigh while the left knee is up and the knee
  leader runs beside the lifted right shin while that knee is up: every path to the hips from the
  open side crosses an arm or a dumbbell otherwise. The draft's tempo pill (bottom right, to the
  near foot) sat on the near calf and its leader crossed the far leg when the foot lifted; the
  tempo cue was folded into the knee cue and replaced by the shoulders cue.
- Suitcase (yaw -0.3, face-on; the loaded arm and dumbbell u ~0.22-0.42, the free hand u ~0.70):
  shoulder (Shoulder down, to the right shoulder) 0.16 left, above it (at 0.30 the pill sat
  on the loaded arm); level (No side lean, to the head) 0.16 right. Both top pills were cut short
  after lab round 1 (Loaded shoulder down, Level, no side lean): in the mistake view the lifted,
  shrunk model brings the shoulders up to their row and the longer pills touched the shoulders and
  the shrug ghost; hips (Hips stay level,
  to the left hip) 0.56 right, under the free hand; knee (Knee hip-high, to the left knee; Knee to hip height until review, see Review)
  0.72 right, its leader beside the lifted shin; tempo (Slow, steady march, to the right foot)
  0.80 left.

## Ghosts

Sized with `gh.py` at each fault's moment (the mistake view's turn and shrink included). Every knee
keeps bending forward, every elbow keeps its angle, and no drawn segment changes length by more
than 3 mm except the farmer's shoulders, which use the library Farmer's Carry slump moves as they
are (the girdle line ~0.8 cm shorter, spine-to-chest ~0.6 cm longer), and the suitcase shrug,
whose neck-to-shoulder line shortens ~1.0 cm as the shoulder rises (as the library `shrugged`).

| Exercise | Cue | Ghost | Moment |
|---|---|---|---|
| Farmer | knee | `carryMarch500KneeLow(32)`: the lifted thigh 32 degrees lower (~39 below level), the knee ~22 cm lower and ~10 cm back, opening 78 -> ~110, the shin keeping its slant, the toes still ~12 cm up; seen -0.5 (total -1.5). Lab round 1's 40 degrees put the toes at the floor. Stilled at 3.0 s (review; 1.0 s before), the right knee up, the knee the label tracks | 3.0 s |
| Farmer | posture | `carryMarch500LeanedBack(15)`: the trunk 15 degrees back about the pelvis, the head ~18 cm and shoulders ~14 cm back; seen -0.5 | 1.0 s |
| Farmer | hips | `carryMarch500HipDropped(26)`: the pelvis and lifted leg tilted 26 degrees about the standing hip, then the leg turned back about its own hip, so the lifted hip and leg drop ~8 cm (and ~2 cm in) without swinging in under the body, the pelvis ~4 cm, every length kept; `faceOn` (total 0.1). A first version that only tilted (as round 2's) swung the lifted foot ~12 cm in under the body at 15 degrees | 1.0 s |
| Farmer | grip | `armsSwungForward(18)`: both arms 18 degrees forward, the hands ~16 cm ahead; seen -0.5 | 1.0 s |
| Farmer | shoulders | `carryMarch500ShouldersRounded` (the library Farmer's Carry slump): shoulders and arms ~9 cm forward and down, chest ~4 cm back, neck and head ~6 cm forward; seen -0.5 | 2.0 s |
| Suitcase | level | `carryMarch500LeanedToWeight(12)`: the trunk 12 degrees over to the right (loaded) side about the pelvis, the head ~14 cm, the loaded shoulder ~5 cm lower; as framed | 3.0 s |
| Suitcase | shoulder | `carryMarch500ShruggedRight(0.14)`: the right shoulder, arm and dumbbell ~8 cm up; as framed | 2.0 s |
| Suitcase | knee | `carryMarch500KneeLow(32)`, as the farmer; `sideOn` (total -1.4), the lifted left leg on the near side | 1.0 s |
| Suitcase | hips | `carryMarch500HipDropped(26)` with the right (dumbbell-side) knee up, the right hip and leg ~8 cm lower; as framed | 3.0 s |

No ghost: the suitcase tempo (the pace of the march). The knee and hip ghosts read the `_bent`
leg and fade with `.withBend("shin_bent")`, so in the live mistake view they follow whichever
knee is up and vanish with both feet down; the lean-back ghost fades the same way (it is the
compensation for a rising knee).

## Uncertain

- No EMG study of either march (or of any march with dumbbells) was found; every fraction is a
  judgement anchored on the library's carry rows and moved for the hip flexor lift and the time on
  one leg. The forearm values rest on no forearm EMG of any carry.
- The Farmer Carry March's PRIMARY forearms break bright = primary on purpose (the counted
  muscle that leads; see the activation section). If the rig is ever re-painted, lighting the
  forearms bright would remove the exception.
- The coaching guides (The Prehab Guys, Motra) are practice sources, not studies; the copy calls
  each "one guide". Motra's march pages give a slower tempo (2-1-2, 2-0-2) than the model's
  ~0.5 s phases; the copy gives the model's timing and asks only for a pause and a controlled
  lowering.
- The Prehab Guys says to bring the knee to the chest; Motra to hip height or the thigh
  parallel. The models stop 7 degrees short of level; the copy says "about level" (farmer) and
  "nearly level" (suitcase).
- Ellestad 2024 measured walking carries, not marches; Stastny 2015, Neumann and Cook 1985 and
  Graber 2021 measured walking. The copy says "carry", "farmer's walk" or "walking studies".
- Bordelon 2021 was read as the abstract (Crossref); McGill 2009 and Andersson 1995 as abstracts.
- The hip-drop ghosts tilt the pelvis 26 degrees, far more than a real hip drop, so that it reads
  at the trainer's size (round 2's farmer's walk found ~6 cm of drop faint).

## Change log

- 2026-10-05, draft: copy, setup, ghosts and moments for both; `spec_500.py carrymarch` OK; the
  overlay moved the farmer's tempo label off the near calf by replacing the tempo cue with a
  shoulders cue (tempo folded into the knee cue) and moved the suitcase shoulder pill above the
  loaded arm. Source pass: "chief among them" (gluteus medius) cut to "among them"; the posture
  why rewritten as geometry (the draft's "tips your weight behind the standing foot" had no
  source); "pull the shoulders down and forward" cut to "pull down on the shoulders"; plural
  "guides" made "one guide ... another" wherever each point is one page's; "a common way to hold
  a heavy dumbbell" (no source) replaced by the guides' own wording; the suitcase tempo why's
  "keeps the load from rocking you" (no source) replaced.
- `family.sh check carrymarch`: BUILD SUCCEEDED on the first build.
- Lab round 1 (`SCRATCH/lab/r3/carrymarch/round1/`, stills 0 / 1 / 3 s: both feet down, the left
  knee held up, the right knee held up): BUILD SUCCEEDED; every trainer still with its pills off the
  lifter and the dumbbells; all nine ghosts attached and readable. Fixed: the suitcase secondary
  legend truncated ("GLUTEUS MEDI..."), so that row is "Glutes"; in the suitcase mistake views the
  lifted model's shoulders reached the two top pills (Loaded shoulder down touched the shrug
  ghost), so they became Shoulder down and No side lean; the knee ghost's 40 degrees put the
  lifted toes at the floor, so both knee ghosts drop the thigh 32 degrees (toes ~12 cm up).
- Lab round 2 (`SCRATCH/lab/r3/carrymarch/round2/`, stills 0.4 / 1 / 3 s, the 0.4 s still with the
  left knee rising): both legends on one line; the top pills clear in every mistake view (the
  level ghost's free shoulder ~20 pt from its pill); the 32 degree knee ghosts read as a low lift
  with the foot off the floor; the other ghosts unchanged and readable. Left as it is: the farmer's
  Hips level leader crosses the root of the lifted thigh while either knee is up (see Labels).
- After round 2 (copy only, nothing a still shows): Motra's single-arm march walks forward, so
  the suitcase knee and tempo whys now say "one guide to a one-dumbbell march"; the legend-width
  comments corrected to the lab's ~40 characters.

## Review (independent, 2026-10-05)

Two passes, sources then fidelity to the models; scripts and evidence in
`SCRATCH/lab/r3/carrymarch/review/`.

Sources. Every study re-fetched by the reviewer: the Europe PMC REST records of all seven
(`e_<PMID>.json`), the full text of Ellestad 2024 (`ellestad.xml`), PubMed and Crossref for
Bordelon 2021's abstract (`crossref_bordelon.json`; PubMed and Europe PMC carry none). All seven
exist with the authors, journals, volumes, pages, DOIs and PMIDs cited. Ellestad's Table 2 and
methods confirm every number used: 18 college-aged adults (12 women, 6 men), the weight in the
right hand for the suitcase carry, farmer's carry external oblique 11.1 / 14.2 and rectus abdominis
8.4 / 10.7 %MVIC, suitcase carry left external oblique 33.0 (different from the farmer's carry and
hold only, not from the plank's 34.5 / 36.1) against the right's 9.6 (3.4 times), left longissimus
29.1, multifidus 21.0. Stastny, Neumann and Cook, Graber and Andersson say what the copy and notes
use. ExRx re-read from the Internet Archive (Iliopsoas 2024-01-05: hip flexion, related muscles
include sartorius and rectus femoris; Gluteus Medius 2025-11-07: steadies the pelvis so it does not
sag when the opposite side is not supported). The Prehab Guys' two in-place pages and Motra's
Dumbbell Farmer's March and Dumbbell Single-Arm March re-fetched raw (`pg_*.txt`, `motra_*.txt`);
every quoted line is on the page. Fixed:
- Farmer posture why and comparison: leaning back raises the thigh without more hip bend (true,
  geometry), but "so the hip flexors do less of the lifting / of the lift" did not follow: the
  torque that holds the thigh up depends on the thigh's angle to the floor, not on the lean. Now
  part of the knee's height comes from the lean instead of the hip, and the comparison's mistake
  note says the lean tips the trunk instead of bending the hip further.
- Farmer hips why: Motra's "Shifting hips sideways" is a sideways slide, not the hip drop the cue
  and ghost show, and the correct cue (as The Prehab Guys and the model) asks you to shift onto
  the standing foot; the sentence was cut. ExRx's gluteus medius line and Stastny's numbers carry
  the why.
- Suitcase shoulder why: Motra's single-arm march walks forward, so "another" guide for this
  exercise became a guide to a one-dumbbell march, as the knee and tempo whys already said.
- Suitcase hips correct: "as the right knee rises" became "as the knee on the dumbbell side
  rises", since the copy switches the dumbbell to the other hand each set (the why keeps the
  right-hand example, said as such).
- Suitcase comparison: "the obliques and hip on the free side" hold the load was only half true
  for the hip (with the free-side knee up you stand on the loaded side); now the free side's
  obliques and the hip you stand on.
- McGill 2009 (header, notes): the abstract gives the quadratus lumborum's frontal-plane support
  of the torso and pelvis as its yoke-walk example, not as a finding for carries in general; both
  places now say so. The suitcase notes called the trapezius "the least measured of the four dim
  candidates", which the library's own comment contradicts (Bordelon's loaded-side upper
  trapezius 21-28 %MVIC against the far gluteus medius 10-13); now an honest judgement for the
  march's time on one leg. The farmer trapezius rationale (a relaxed-traps form cue taken as a
  lower level) replaced by naming the whole muscle; Stastny's 26-47 are subgroup means, said so.
- Left as they were: every activation value (judgement calls, labelled so; levels match the
  fractions; the suitcase rows follow the paint; the farmer's Forearms PRIMARY is the documented
  exception, the library Farmer's Carry ranking the forearm flexors first and Ellestad's trunk
  values low), the stabilisers, the setup steps.

Model fidelity. Both rigs re-sampled every frame by a new script (`rv_series.py`, `rv_an.py`) and
every ghost re-sized with the reviewer's own port of `FaultGhost.solve` (`rv_ghost.py`,
`rv_pieces.py`; body frame, `_bent` / `_straight` roles, strengths, mirrored turns, tips). The
model facts hold: left foot up 0.125-1.67 s, right 2.125-3.67 s, again from 4.125 s; knee 78.4,
thigh 7.3 below level, knee joint 5.6 cm below and 43.9 cm ahead of the hip, shin 19 back, held
0.62-1.17 s; standing knee 173; pelvis 0.909 m, level, sliding 1.6 cm toward the standing leg;
trunk 0.4 back; dumbbells within 6 mm; the suitcase free arm 1.6 behind to 18.2 in front, elbow
163-168. Every ghost's size matches the notes (knee ghosts 22 cm lower, 10 cm back, 78 -> 110,
toes 12 cm up, the knee still bending forward; lean back head 18 cm, shoulders 14 cm; hip drops
8 cm, 1.8 cm in, every length kept; arms 18 degrees, hands 16 cm; slump girdle 20.7 -> 19.9 cm;
lean to the weight head 14.5 cm, loaded shoulder 5.2 cm lower; shrug 8.3 cm, neck-to-shoulder
20.7 -> 19.7 cm); every elbow keeps its angle. Fixed:
- Farmer knee ghost: stilled at 1.0 s it lowered the LEFT knee while its label's leader (Knee up to
  hip height, tracking `patella_R`) pointed at the standing right knee. Now stilled at 3.0 s, the
  right knee up: the leader meets the knee the ghost lowers (it runs past the lifted shoe, as in
  the trainer at 3 s).
- Farmer grip pill: in the grip mistake view (1.0 s, the near knee up) the pill's lower right
  corner sat on the lifted near thigh. Row 0.34 -> 0.28; clear in the trainer stills and the
  mistake view, the leader still running down the far side of the trunk to the far hand.
- Suitcase knee pill: Knee to hip height reached over the standing left calf while the right knee
  was up (the 3 s still). Now Knee hip-high (13 characters), ~15 pt clear of the calf; the leader
  unchanged.
- Left as they were: the other ghosts and moments, the farmer's Hips level leader over the root
  of the lifted thigh (no better path, as the author found), the suitcase Hips stay level pill
  ~3 pt from the standing thigh at 3 s (not touching), the suitcase knee mistake view's leader
  crossing the far standing shin.

Review lab round (`SCRATCH/lab/r3/carrymarch/review/lab_rv1/`, stills 0.4 / 1 / 3 s): BUILD
SUCCEEDED; the three label changes and the knee moment show as intended; legends on one line; all
nine ghosts attached and readable, none changed in shape. `spec_500.py carrymarch` OK; `dupes.py`
finds no sentence of 26 characters or more repeated with the library or the other families.

## Verification (final skeptic, 2026-10-05)

A last adversarial pass over every claim and number in the copy (intros, whys, mistakes, corrects,
comparison notes, setup steps), the labels, the spec header and activation comments, this file's
claim tables and the ghost comments. Working files and the four files as they stood before this
pass are in `SCRATCH/lab/r3/carrymarch/sk/`.

- Sources re-fetched independently: the seven Europe PMC REST records (authors, journal, year,
  volume, issue, pages, DOI, PMID and abstract wording match the header), Crossref for Bordelon
  2021's abstract (18 resistance-trained adults, 12 m carries with the dumbbell on the dominant
  side; in the suitcase position the nondominant gluteus medius and external oblique significantly
  more active; activation rising with load across most muscles), the Europe PMC full texts of
  Ellestad 2024 (right arm for the suitcase carry and hold; 18 of 26 recruited gave usable data,
  12 women and 6 men; every Table 2 value used, the suitcase carry's left external oblique 33.0
  marked different from the farmer's carry and hold only) and Stastny 2015 (Table 2: gluteus
  medius group means 26-47 %MVIC, n = 32 legs of 16 men; the overall H/Q groups 36 and 39). The
  Prehab Guys' two in-place pages and Motra's Dumbbell Farmer's March and Dumbbell Single-Arm March
  fetched live; every quoted or paraphrased line is on the page (Motra's farmer's march: thigh
  parallel, pause briefly to establish balance, lower under control, grip hard, tempo 2-1-2, the
  four common mistakes; the single-arm march: knees to hip height with full steps forward, march
  controlled, tempo 2-0-2, leaning toward the weight, shrugging, rushing steps, switch hands).
  ExRx through the Wayback Machine at the cited snapshots (Iliopsoas 2024-01-05: hip flexion,
  sartorius among the related muscles; Gluteus Medius 2025-04-18: steadies the pelvis so it does
  not sag when the opposite side is not supported with a leg). Library anchors re-read in
  SampleData.swift (Farmer's Carry forearm flexors 0.80, upper trapezius 0.45, gluteus medius
  0.40, obliques 0.35; Suitcase Carry obliques 0.60, forearm flexors 0.55, erector spinae 0.50,
  trapezius 0.44, gluteus medius 0.42; Hanging Knee Raise hip flexors 0.76; the library rows GRIP +
  CORE and OBLIQUES, DUMBBELL, beginner; both marches in `timedExercises`; ExerciseRotation and
  fault_times.py class them as carries), and the paint in `tiers.txt`.
- Models re-measured with my own sampler straight from the USD (`sk/dump.py`, `sk/an.py`,
  `sk/an2.py`; joints every frame through UsdSkel, equipment world bounds). Confirmed: torso
  0.592 m; hip joints 18.3 cm and ankles 22 cm apart; left knee first, a lift every 2 s (left
  0.1-1.75 s and 4.1-5.75 s, right 2.1-3.75 s and 6.1-7.75 s); knee 78.4 at the top, held within
  0.5 degrees 0.62-1.17 s, rise and lower ~0.5 s each; hip 98.4, thigh 7.3 below level, knee joint
  5.6 cm below and 43.9 cm ahead of the hip, shin 19.0 back, ankle 47.6 and toe joint 38.6 cm up;
  the foot set back down where it started (ankle x 0.110, z 0.060 before and after); standing knee
  173-174; pelvis 0.909 m, tilt 0.0, sliding 1.6 cm toward the standing leg (peaking at the top),
  turning 2 degrees; trunk 0.42 back, 0.08 to the side; shoulders level; elbows 170.6; arms 13-16
  degrees out; hands 32-33 cm from the midline at the dumbbells' middle; dumbbells 0.34 m along z,
  centres 0.82 m up, lowest 0.73 m; the suitcase has only `HG_WeightR`; its free left arm 163-168
  at the elbow, the hand 24-27 cm out, from 1.6 behind to 18.2 in front of straight down (rest
  6.2), forward at 2.75-3.0 s with the right knee up. Ghost sizes checked by hand geometry on these
  joints (not a third port): the knee ghost's thigh 32 degrees down moves the knee 22.4 cm down and
  9.6 cm back, the foot tip (0.38 torso lengths along the foot) ending ~12 cm up; the hip drop's
  26 degrees about the standing hip drops the other hip 8.0 cm and the pelvis 4.0 cm, 1.8 cm in;
  the lean back 15 degrees moves the head ~18 cm; the arms' 18 degrees moves the hands ~16.5 cm;
  the shrug's 0.14 torso lengths is 8.3 cm; the lean to the weight 12 degrees moves the head ~14.5
  cm and drops the loaded shoulder ~5 cm; the slump shifts are ~8.5, ~4 and ~5.6 cm. All match.

Changed in this pass (copy text only; no label, cue id, tracked joint, ghost or moment changed, so
no lab shoot was needed; `spec_500.py carrymarch` prints OK, `preview_500.py` gives the same
layout, `dupes.py` finds no repeated sentence):

- Farmer hips why: "on one leg for about a second and a half" overstated the single support. The
  heel is up ~1.6 s (0.08-1.75 s) but the whole foot, the ball included, is off the floor only
  ~1.3 s (0.25-1.58 s; earlier passes timed the ankle joint 1 cm up, 0.125-1.67 s). Now "for well
  over a second". The spec header ("each foot off the floor ~1.6 s", "every lift is ~1.6 s on one
  leg", "the left foot leaves the floor at 0.13 s"), both activation comments and this file's
  shared facts, claim table and farmer activation list now give ~1.3 s on one leg and the heel
  timing separately.
- Farmer hips why: "the gluteus medius worked at roughly 26 to 47 percent of its maximum" read as
  the muscle's range; Stastny's 26-47 are the means of subgroups split by strength ratios. Now
  "group averages for the gluteus medius ran from about 26 to 47 percent of its maximum"; the
  farmer activation comment says group means too.
- Suitcase level why: "some three times the right side's level" is now "more than three times"
  (33.0 / 9.6 = 3.4).
- Suitcase hips correct ("Before each lift, shift onto the standing foot") and tempo why ("shift
  onto the standing foot and settle before each knee comes up"): neither the model nor the source
  shifts first. The model's pelvis slides toward the standing leg while the knee rises (starting a
  frame or two before the heel leaves the floor, peaking at the top), and The Prehab Guys says to shift your
  weight as you bring the other knee up. Both now say the shift happens as the knee comes up.
- Farmer comparison correct note: "Staying stacked over the standing foot" did not match the
  model, whose trunk stays over the midline (the pelvis moves 1.6 cm of the standing ankle's 11).
  Now "Staying tall, ribs stacked over the hips", as the posture cue.
- Spec header, McGill 2009: "it gives no carry-by-carry result" was not quite right (the abstract
  does report the yoke carry's spine load); now "no result for the farmer's walk or suitcase
  carry". Dumbbell drift: the centres move up to 6.3 mm, so "within 6 mm" / "less than 6 mm"
  became "within 7 mm" / "about 6 mm at most".

Checked and left as they are: every other cue, setup step, comparison note, label and activation
row (levels match the fractions; the rows follow the paint, with the farmer's PRIMARY forearms the
documented exception). The suitcase hips mistake's "worst as the dumbbell-side knee comes up" is
mechanical reasoning (the load then hangs on the unsupported side) consistent with Neumann and
Cook 1985. The labels Knee up to hip height and Knee hip-high are approximations (the knee joint
stops 5.6 cm below the hip joint; Motra's single-arm march says hip height); the cues say about
or nearly level. The Slow, steady march label is relative to walking (a knee every 2 s); Motra's
2-0-2 and 2-1-2 tempos are slower than the model's ~0.5 s phases, which the copy gives as they are.
Still open, as the review left them: the farmer's hips and knee leaders over the lifted thigh and
shin, the suitcase knee mistake view's leader across the far shin, judgement-call fractions with
no EMG of either march, Bordelon 2021, McGill 2009 and Andersson 1995 read as abstracts only (the
library's Bordelon trapezius and gluteus medius numbers not re-read in the full text).
