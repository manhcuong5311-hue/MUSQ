# Trainer content generator (2026-09-24)

Authored the Shoulder, Arm and remaining Leg `ExerciseContent` entries in
`GymWorkout/Models/SampleData.swift`.

- `spec.py` — all copy: cue annotations (cueID, label, tracked joint), technique
  cues, activation, stabilisers, comparison copy, glows, optional `overrides`
  (hand-set label rows). Sources are cited in the SampleData section comments.
- `probe.py` — projects rig joints through each exercise's framing at 8 points
  across the clip with the REAL viewport aspect. Since the setup drawer (2026-09-24) the
  trainer viewport is 382×655 (≈0.58); the labels here were laid out at
  382/705, before the drawer. The `model-pipeline` solver assumed 0.74. Run with Blender's Python from
  `Tools/model-pipeline` (it imports `framer`); writes `joints.json`.
- `setup.py` — setup steps for all 60 trainer exercises (the swipe-up drawer).
- `gen.py` — lays labels out (rows 0.14/0.32/0.50/0.68/0.86 by joint height,
  same side as the joint, flip if the pill would cover any tracked dot) and
  writes Swift into `generated.json` per group; paste/replace the block
  between `// MARK: - Shoulder content` and `// MARK: - Home`.
- `framer_rootfix.py` — framer copy that falls back to the default prim when a
  model has no `/root` (the legacy Lunge).

Paths inside the scripts point at a session scratchpad; adjust before reuse.
Always verify label placement with simulator screenshots afterwards.

Legs2 batch (2026-09-24): `spec_legs2.py` holds the 15 exercises added from
`SourceExports/Legs2` (curls, hinges, bridges, kickbacks, abduction, plus the
re-exported Step-Up, Push-Up, Plank). Generate with `spec` swapped for it, e.g.
`python3 -c 'import sys,spec_legs2; sys.modules["spec"]=spec_legs2; exec(open("gen.py").read())'`.
An entry may pass `slots=[...]` to override the label rows — lying/prone
bodies use `FLAT` (0.15–0.87, skipping 0.50) so labels sit above and below
the body. Top rows under ~0.12 collide with the eye button on the right, and
rows past ~0.88 with the muscle legend on the left.

Abs batch (2026-09-24): `spec_abs.py` holds the 11 core exercises from
`SourceExports/Abdoment` (088-099; 095 Plank keeps the existing Plank content).
Its header lists the sources (Escamilla 2006/2010, ACE/SDSU, Youdas 2008/2014,
McGill 1996/2010). "Hip Flexors" and "Quadratus Lumborum" are shown in the
legend but have no `MusclePart`, so recovery ignores them.

Gated batch (2026-09-24): `spec_gated.py` holds Biceps Curl, Squat and Lunge
(re-exported from `SourceExports/3 bai thieu`, which replaced a missing or
mismatched model) plus the new Lunge (Lean). Its header lists what each model
shows and the sources. `probe.py` now takes names after the output path and
merges into that file, e.g. `probe.py joints.json "Squat" "Lunge"`. The lunges
are seen nearly side-on (yaw -1.3); labels are pinned with `overrides`, and
some cues track the far-side joint (`hand_R`, `patella_R`) so leaders don't
cross the body. The generated Swift lives under
`// MARK: - Gated exercises and lean lunge` in SampleData.

Chest batch 101-131 (2026-09-25): `spec_chest3.py` holds the 28 exercises from
`SourceExports/Chest3` (floor, Smith, single-arm, alternating, neutral-grip and
squeeze presses, pullovers, plate-loaded and selectorised machines, cable
presses and flies, landmine press, incline push-up). Its header lists what each
model shows and the sources; glows are placed from the probed pec, delt and
triceps joints. `probe.py` now also projects the pec and lat anchors. Seated
machines and the head-on standing flies pin their labels with `overrides` and
point the shoulder/elbow cues at the far-side joints, which sit in the open
part of the frame. The generated Swift lives under
`// MARK: - Chest batch 101-131` at the end of SampleData.

Batch 133-160 (2026-09-25): `spec_131_160.py` holds the 27 exercises from
`SourceExports/131-160` (push-up and bench variants, pulls from pins, blocks
and the floor, barbell, landmine, one-arm, kettlebell and inverted rows). Its
header lists what each model shows and the sources; glows are placed on the
pecs, lats or hips by the kind of lift. The generated Swift lives under
`// MARK: - Batch 133-160` at the end of SampleData. Dumbbell Bent-Over Row
is a separate model from the older Dumbbell Row (wider hands, straighter
knees, deeper hinge) and is listed as its own exercise.

Batch 161-190 (2026-09-25): `spec_161_190.py` holds the 30 back exercises from
`SourceExports/160-190` (pull-up and chin-up variants, pulldowns, cable and
machine rows, a reverse-grip T-bar row and two pullovers), with the same cue
sets as the Pull-Up, Lat Pulldown and Seated Cable Row. Some sit close to
older entries with different models: Wide-Grip Pull-Up (Pull-Up), Wide-Grip
Lat Pulldown (Lat Pulldown), Close-Grip Seated Cable Row (Seated Cable Row),
Machine Seated Row (Chest-Supported Row Machine). The Dumbbell Pullover Row
model keeps the arms nearly straight, so it is written as a lat pullover.

Batch 191-240 (2026-09-26): 46 exercises from `SourceExports/190-240` —
shoulder presses and raises, rotator-cuff work, rear-delt and upright rows,
shrugs, loaded carries and biceps curls. Written by family on top of
`common_191_240.py` (helpers, `validate()`), one module per family
(`spec_191_240_{bbpress,dbpress,lateral,frontrear,shrugcarry,curls}.py`),
each with a header listing what its models show and the sources, and
`notes_191_240_*.md` mapping the copy's claims to them. `spec_191_240.py`
collects them in library order; `python3 spec_191_240.py` validates all 46.
Each family was drafted by one agent, checked by two independent reviewers
(sources and claims; model fidelity, labels and ghosts) and revised twice.
`gen.py` now writes `MuscleActivation(name:rank:fraction:)`: the HIGH /
MODERATE / LOW word is read off the fraction in the app (>= 0.70 high,
0.40-0.69 moderate). The setup steps were appended to `setup.py`, the Swift
lives under `// MARK: - Batch 191-240 (2026-09-26)` at the end of SampleData,
and `probe.py` gained deltoid, upper-trap and collarbone anchors. The three
carries are logged in seconds (`ExerciseCatalog.timedExercises`).

Legs 300-350 (2026-09-26): 11 exercises from `SourceExports/300-350` — flat,
front-foot-elevated and rear-foot-elevated split squats (barbell, dumbbell,
Smith) and the forward, barbell, Smith reverse and curtsy lunges. Written by
family on top of `common_300_350.py` (`spec_300_350_{splitsquat,lunge}.py`,
headers listing what each model shows and the sources, `notes_300_350_*.md`
mapping claims to sources); `spec_300_350.py` collects them and squeezes the
label rows into 0.16-0.80 like the 191-240 batch. Each family was drafted,
checked by two independent reviewers and revised twice. The split squats keep
the left leg in front; the four lunges switch legs between reps, so their
one-leg cues name `<stem>_front` / `<stem>_back`, which the app resolves every
frame (`Exercise3DView.trackedPoint`) and `probe.py` now writes for the lifts
in its `ALTERNATING` set. `probe.py` also probes `toe_L/R` (skipped on rigs
without them). The model briefs came from a leg-motion summary (knee and hip
angles per leg, foot positions and heights, trunk lean, pelvis height every
0.5 s). The Swift lives under `// MARK: - Legs 300-350 (2026-09-26)` at the
end of SampleData; the setup steps were appended to `setup.py`.

Late additions (2026-09-27): Seated Dumbbell Lateral Raise, Cable Rear Delt
Row, Dumbbell Upright Row and Barbell Hip Thrust, written the same way
(`common_0927.py`, `spec_0927_{shoulders,hipthrust}.py`, `notes_0927_*.md`;
`python3 spec_0927.py` validates the four). The Swift lives under
`// MARK: - Late additions (2026-09-27)`; the integration script cuts after the
Legs 300-350 block, so the late block is always pasted after it.

Batch 241-300 (2026-09-27): 15 curls and 11 wrist, finger and grip exercises
from `SourceExports/241-300`, in five families
(`spec_241_300_{preacher,cable,dragspider,wrist,grip}.py` on top of
`common_241_300.py`; `notes_241_300_*.md`; `python3 spec_241_300.py`
validates all 26). `validate()` also runs `part_of()`, a copy of
`MusclePart.init(muscleName:)`, and rejects activation names the app would
drop or file under the wrong group (Adductor Pollicis reads as the leg
adductors, Pronator Teres as the lats); the Swift mapping now also files
finger, digitorum, pollicis and carpi names under the forearms. The four holds
are timed (`ExerciseCatalog.timedExercises`) and the towel hang counts as
bodyweight. The briefs came from the arm summary plus a wrist summary (wrist
bend toward the palm or the back of the hand, palm direction, finger bend);
the skeleton's joint space is the app's Y-up frame with the lifter facing +z.
Each family was drafted, checked by two reviewers (sources, model), revised,
then reviewed again on the app's own screenshots and ghost stills and fixed.
The integration script cuts only inside the content map: the library above it
carries markers with the same prefix. Run it after the legs and late ones.

Exercises 1-150 redone (2026-09-29/30): the user re-did models 1-150 and
mostly re-painted which muscles are lit, so content was realigned with each
model's highlight tiers (bright = PRIMARY, dim = SECONDARY in the legend).
- Nine new exercises from the 1-50 set (Pendlay Row, Dumbbell, Incline
  Dumbbell, Preacher, Cable, Bayesian Cable and Reverse Curls, Wrist Curl,
  Close-Grip Bench Press) were written by family in
  `spec_1_50_{curls,forearm,compound}.py` on `common_1_50.py`
  (`notes_1_50_*.md` map claims to sources; `python3 preview_1_50.py
  <family>` validates and prints the label layout; `briefs_1_50/` holds the
  arm/upper-body motion briefs from `briefs_1_50/brief_arms.py`). Each family
  was drafted, checked by a sources reviewer and a model reviewer, revised,
  re-checked, then fixed again from the app's own screenshots and ghost
  stills. `integrate_1_50.py <scratch>` adds their setup steps, content map
  entries and Swift (`// MARK: - Exercises 1-50 redone (2026-09-29)`) and the
  fault ghosts (`// MARK: Exercises 1-50 redo`); the library rows and model
  map went in with the models.
- The 75 replaced exercises were edited in place in SampleData.swift (and
  setup.py where generated): activation ranks, stabilisers and glows moved to
  the new tiers, setup/cue copy fixed where the new model does something
  else, and labels relaid where a reframe or the new motion put pills on the
  lifter. House decisions: rows list Middle Trapezius, Posterior Deltoid and
  Rhomboids as primary with the rotator cuff in the stabilisers (the legend is
  one line), a dim-lit muscle that was only a stabiliser becomes a sourced
  LOW/MODERATE secondary row. The generated families these came from
  (spec.py, spec_legs2.py, spec_chest3.py, spec_131_160.py, spec_abs.py,
  spec_legs30_press.py …) were NOT updated, so regenerating them would undo
  those edits — edit SampleData.swift directly for these exercises, or bring
  the spec files up to date first.
- `probe.py` now carries the chest/back/leg exercises whose content predates
  it, with their current framings (Step-Up's stale entry fixed).

Exercises 151-190 and gated redone (2026-09-30): the last 37 re-exports of
the `1-100 🟢` folder. Biceps Curl came back identical; the other 36 were
realigned in SampleData.swift (and setup.py) the same way as 1-150, from the
new highlight tiers:
- Rows (Meadows, Landmine, Dumbbell Bent-Over, Renegade, Kettlebell, Gorilla,
  Reverse-Grip T-Bar, the seven cable rows and three machine rows): Middle
  Trapezius, Posterior Deltoid and Rhomboids primary, lats and biceps
  secondary, rotator cuff with the stabilisers (neutral-grip fractions from
  Vasconcelos et al. 2023). The High Cable Row keeps the lats primary too (they
  stay bright), and its face-pull copy was rewritten: the model rows neutral
  handles from high pulleys down to the lower chest.
- Pull-ups and pulldowns (lats alone bright, trapezius dim): the lats stay the
  only primary; the dim trapezius leaves the stabilisers as a "Trapezius"
  secondary row, or is already named by an existing Middle Trapezius row. The
  Wide-Grip Lat Pulldown's copy no longer asks for straight arms at the top
  (the model stops at 149°).
- Pullovers: the bright rear delts stay a LOW secondary on the EMG, as on the
  Dumbbell and Barbell Pullover.
- Lunge / Lunge (Lean): nothing to change beyond what was flagged.
spec_131_160.py, spec_161_190.py and spec_gated.py were NOT updated.

Redone 190-280 folder (2026-09-30): 21 replaced models were realigned in
SampleData.swift / setup.py the same way (activation from the new tiers,
presses relaid for their new arm paths and framings, the rear-delt rows'
now-bright cuff kept in the stabilisers). The new Machine Preacher Curl was
written as family `machinecurl` on `common_1_50.py`: `spec_280.py`,
`spec_280_machinecurl.py`, `notes_280_machinecurl.md`, `preview_280.py
machinecurl`; `integrate_280.py <scratch>` writes its setup steps, content
map entry, Swift block and fault ghosts between its own BEGIN/END markers,
so it can be re-run after any family edit. The spec_191_240_* and
spec_241_300_* families were not updated.

Back Extension rewritten (2026-10-01): the model is the lower-back variant
(pelvis resting on the pad at the hip bones, the spine curling down over the
pad edge and uncurling to a straight line; erector spinae the only bright
muscle), but the copy taught the flat-back hip hinge for the glutes and
hamstrings. SampleData.swift (`backExtensionContent`) and setup.py were
rewritten for the spinal curl (sources in the code comment: da Silva et al.
2009, Schoenfeld et al. 2017, Mayer et al. 1999/2002, Andersen et al. 2021),
labels relaid for its new behind-left framing (-1.9), and the "hips" ghost
now draws the flat-back hinge as the mistake. The spec file it was
generated from was not updated.

351-400 folder (2026-10-01): 27 new hamstring, glute and hip exercises, in
four families (`spec_400_{rdl,hinge,legcurl,hip}.py` on `common_1_50.py`;
`notes_400_*.md`; `python3 spec_400.py` validates all 27, `preview_400.py
<family>` prints the label layout). Each family was drafted, checked by a
sources reviewer and a model reviewer, revised and re-checked, then fixed
again from the app's own screenshots. `integrate_400.py <scratch>` writes the
setup steps, content map entries, Swift (`// MARK: - 351-400 (2026-09-30)`)
and fault ghosts between its own BEGIN/END markers and can be re-run. The
library rows and model map went in with the models; `ExerciseRotation`'s
movement patterns now file the Nordic/sliding curls and the glute-ham raise
as leg curls, frog pumps as bridges and the clamshell with the glute
isolation lifts, and `ExerciseCatalog.isBodyweight` counts the SWISS BALL,
SLIDERS and BAND lifts as bodyweight.

401-500 folder (2026-10-04): 30 new exercises (the folder's exports from 106 on
that were not in the app), in six families on `common_1_50.py`:
`spec_500_{chest,hammer,curls,calfstand,calfseat,hip}.py`, `notes_500_*.md`;
`python3 spec_500.py [family]` validates, `preview_500.py <family>` prints the
label layout. Each family was drafted by one agent, then checked by an
independent reviewer (every source re-opened; copy, labels and ghosts against
the model and the app's own screenshots) who fixed what they found.
`integrate_500.py <scratch> [--only/--skip <family>]` writes the setup steps,
content-map entries, Swift (`// MARK: - 401-500 (2026-10-04)`) and fault
ghosts between its own BEGIN/END markers; it edits the copy of the project it
sits in, so a mirror's copy integrates into the mirror (that is how families
were built and shot one at a time). The library rows and model map went in
with the models. House decisions:
- Activation follows the paint (bright = primary). Where the paint and the
  literature disagree it is said in the code and notes: the four seated calf
  raises light the gastrocnemius bright, so it is a primary row at 0.40 (the
  lowest moderate value) under the soleus's 0.86, and the copy never says the
  gastrocnemius works hard with the knee bent. No EMG exists for any of the 30
  as the models do them; every fraction is a judgement call anchored on the
  library's nearest lift.
- Copy follows the model where coaching differs: the rope hammer curl starts
  each rep 28° short of straight, the cross-body hammer curl alternates (left
  arm 0-4 s) and finishes on the midline, the decline push-up stops 18 cm off
  the floor, five of the standing and all six seated calf raises sink the heels
  below their support.
- The 21s run 44 s (7 bottom-half reps, 7 top-half, 7 full); their fault
  stills are given in seconds. The Wrist Roller winds with palms-down wrist
  flexion (ExRx's Cable Roller Wrist Flexion), so its library row is FOREARM
  FLEXORS.
- Cues with no ghost (tempo, the Zottman and wrist-roller forearm turns, where
  a plate hangs or the palms sit) fall back to the red ring.
`ExerciseRotation`'s movement patterns gained `calfRaise` (matched before
squats and presses, so the leg-press, hack-squat and Smith calf raises and the
calf press stay calf work; the library's Leg Press Calf Raise had been filed as
a squat) and file the 21s and the wrist roller as curls.
Open points the reviewers left: the library's Single-Leg, Leg Press and Smith
Machine Calf Raises paint the soleus bright but list it as secondary; the
one-line legend truncates three- and four-primary rows; in mistake views the
lifted model's head can sit behind the "COMMON MISTAKE" chip.

Second round, 415-444 (2026-10-04/05): 30 more exercises in six families on
the same files (`spec_500_{calfmore,tibialis,situp,crunch,cablecrunch,
stability}.py`, `notes_500_*.md`; `spec_500.py` now lists 12 families and
validates all 60). Each family went through a Workflow pipeline: an author
(measure the model, read sources, draft, two or more lab rounds), an
independent reviewer (every source re-opened, model fidelity, every lab
image) and a skeptic that tried to refute every factual claim and number
against its source and the rig and softened or cut what failed (96-190
claims checked per family; each notes file has Review and Verification
sections). Shared changes for this round:
- `part_of()` (and `MusclePart.init(muscleName:)` in the app) file tibialis,
  fibularis and peroneus under the calves, the lower leg; `BodyMap` lights
  tibialis posterior and the fibularis on the calves and tibialis anterior on
  the shin. `validate()` accepts the library's legend-only names ("Hip
  Flexors", painted on the rig's Sartorius mesh, and "Serratus Anterior") and
  rejects shin toe-extensor names the app would file under the forearms.
- Movement patterns gained `tibialisRaise` and `coreStability` (dead bug, bird
  dog, hollow body rock); sit-ups and V-ups count as crunches, plantar flexion
  as a calf raise, the walk on toes as a carry, the hollow body hold as a hold.
  Calf Raise Hold, Farmer's Walk on Toes and Hollow Body Hold are timed.
House decisions and open points:
- The tibialis models paint tibialis posterior and fibularis longus bright
  next to tibialis anterior. Both are plantar flexors and do not lift the
  toes, so they stay LOW secondary rows (the one break of bright = primary,
  explained in the code and notes); the paint could be revisited in Blender.
- The Toe Touch Crunch's thighs sit about 10° past vertical, which ACE warns
  against; the copy says "about straight up". A builder fix would match it.
- These rigs read a flat foot under a vertical shin as an ankle angle of
  about 112°, not the ~109° round 1 used; only round 1's notes quote angles
  from it, no copy does.
- Optional follow-ups the families named: probe `_bent/_straight` points for
  the bicycle and cross-body crunches, dead bug and bird dog (their labels
  track fixed left-side joints and are worded to fit); a legend backing where
  it sits over grey equipment (Elevated Calf Raise step).

Third round, 445-474 (2026-10-05): 30 more in eight families
(`spec_500_{legraise,plankdyn,plankhold,sidebend,twist,antiext,carrymarch,
thruster}.py`; `spec_500.py` validates all 90), through the same
author / reviewer / skeptic Workflow (84-212 claims checked per family). The
lab scripts and agent brief now live in `Tools/lab/` (the scratchpad copies
were lost between rounds). Shared changes:
- `validate()` requires at least one primary row the app counts, so no
  exercise is left in no muscle group; `part_of()` files Quadratus Lumborum
  under the lower back, as the app does.
- Movement patterns: leg and knee raises, toe-to-bar and the kicks are leg
  raises; side bends, cable and landmine rotations file with the twists and
  chops; the body saw with the rollouts; the bear crawl and carry marches
  with the carries; thrusters and the clean and press are a new
  `olympicLift`; mountain climbers, shoulder taps, knee-to-elbows and the
  side plank hip lift are `coreStability` (moving drills, not holds), the
  plank hip dip a trunk rotation. The RKC, weighted and Copenhagen planks,
  both carry marches and the bear crawl are timed.
House decisions and open points:
- Farmer Carry March: the model paints only the hip flexors bright (a
  legend-only name), so Forearms leads as a deliberate, documented exception
  to bright = primary.
- Model details the copy follows and the builder may want to fix: the
  Toe-to-Bar stops 2.3 cm short of the bar; the Scissor Kick's legs stack
  rather than cross; the landmine rotations pivot the same-side heel; the
  dumbbell and kettlebell thrusters' knees cave 13-22° at the bottom and all
  three thrusters stop 15-20° above parallel; the shoulder tap's balance
  sits outside its support base; the RKC plank shows no visible pelvic tilt;
  the mountain climber's front foot never lands.
- Optional: probe `_bent/_straight` (or `_front/_back`) points for the kicks,
  climbers, marches and twists so their labels follow the working side.

Desktop "1-100" folder (2026-10-10): 34 replaced models (see the
model-pipeline README). Their content was edited in place in SampleData.swift
(setup.py and the spec files for the two setup changes), following the paint
where it changed (owner's call, 2026-10-01: the list follows the model): the
rear delts as a low secondary on the Skull Crusher and Dumbbell Overhead
Triceps Extension; the soleus primary on the Standing Calf Raise and the
gastrocnemius primary on the Seated Calf Raise (the new rig lights the calves
as one group; the seated raise keeps the gastrocnemius' 0.30 fraction); all
three glutes primary on the Hip Abduction Machine (Lean), which took the
folder's 081 export (Gluteus Minimus added; the upright machine kept its
model and content);
Trapezius and Forearms secondary on the Step-Up (it carries dumbbells),
Abdominals secondary on the Barbell Hip Thrust, the front delts, biceps and
triceps on the Landmine Squat, and the front and rear delts, triceps and
biceps on the Cable Wood Chop (low; "shoulders" left the stabilisers). The
Heel-Elevated Squat's setup now leads with the slant board the model stands
on, and the Curtsy Lunge's no longer says elbows out. Labels were relaid
where the new motion put pills on the lifter: the Cable Wood Chop's hips and
brace pills moved left and its pivot dot to the left foot (the one that
turns), and the Heel-Elevated Squat's bar pill moved left of the head. Left
as they were: the
erectors newly lit on the Back, Pause, Safety Bar and Heel-Elevated Squats
(already secondary rows) and the hamstrings on the Single-Leg Glute Bridge.
The Barbell Sumo Squat's erectors came back bright, while the Back, Pause,
Safety Bar and Heel-Elevated Squats light them dim and the other squats not
at all; the owner re-exported it with them dim (2026-10-10), which its
Erector Spinae secondary row already matches. The spec files these exercises were generated
from (spec.py, spec_legs2.py, spec_abs.py, spec_legs30_calf.py,
spec_legs30_barbell.py) were NOT updated for the activation changes, so
regenerating them would undo these edits.

The five formerly red-named replacements (Assisted Dip, Bulgarian Split
Squat, Smith Machine Squat, Romanian and Dumbbell Romanian Deadlift) were
revised through a Workflow: one reviser per exercise proposed exact edits
from the old/new stills, trainer shots and ghosts, and two checkers verified
each set (one per lens: true to the model; house rules and syntax). Applied:
the Assisted Dip's chest and front delts primary (now painted bright), its
elbow copy and label for elbows kept over the hands (~10 cm outside the
shoulders, no longer tucked), its torso pill moved off the hips; the
Bulgarian Split Squat's Forearms row dropped (no longer painted), torso copy
for its 10-20° lean, depth pill moved off the back knee; the Smith Machine
Squat's labels relaid off the new bar and copy for the new rack's fixed bar
path; both RDLs rewritten for knees that bend from 20° to 42° as the hips go
back and hold there (the owner's fix), so the knee cue teaches that bend and
the mistake is now locked knees, the barbell RDL's bar copy no longer claims
contact with the legs, and the dumbbell RDL's hips pill moved off the arm.
Not changed, for the owner: bright glutes listed as secondary on the
Bulgarian Split Squat and Smith Machine Squat (the paint did not change, as
on the other squats); the dumbbell RDL's path label (31 characters) still
sits on the forearm, as before the re-export.

The folder's five new exercises (Single-Leg Extension, Smith Machine Front
Squat, Dumbbell Lateral Step-Up, Barbell Step-Up, Hip Adduction Machine) are
one family, `spec_1010_legs.py` on `common_1_50.py`, listed by
`spec_1010.py` (`python3 spec_1010.py legs` validates, `preview_1010.py legs`
prints the layout), with `notes_1010_legs.md` (claims to sources, and the
reviewer's claim-by-claim `## Review`). It was drafted by one agent from
`briefs_1010/` (written by `briefs_legs30/brief.py`) and the lab
(`Tools/lab/family_1010.sh`), then an independent reviewer re-opened all 55
claims and re-measured the models, softened what the sources do not say and
fixed copy, four labels (on three exercises) and two ghosts. `integrate_1010.py <scratch>`
writes the setup steps, content-map entries, Swift (`// MARK: - Desktop
1-100 (2026-10-10)`) and fault ghosts between its own BEGIN/END markers.
House decisions: the other three quad lifts list the quadriceps and the
glutes primary, as painted (the medius and minimus covered by the Gluteus
Maximus row or named among the stabilisers); the Single-Leg Extension's
first export painted the glutes bright, kept as a LOW secondary (0.10) until
the owner re-exported it with them unlit the same evening, so it now lists
the quadriceps alone; `part_of()` drops "Gracilis", so the
adduction machine lists Adductors primary with the gracilis among the
stabilisers. The copy follows the models where they differ from coaching:
no model locks the knees out at the top (168° on the extension, 137-150° on
the step-ups, 163° on the squat), and on both step-ups the trailing foot
hovers ~2.6 cm over the box at the top.

The female model's lifts (2026-10-10): Hack Squat (Stances), Pendulum Squat
(Stances) and Cable Step-Down are family `female` in `spec_1010.py`
(`spec_1010_female.py`, `notes_1010_female.md`), written by one agent and
reviewed by another in a Workflow, integrated with `integrate_1010.py`. A
stance set is one exercise: its labels, cues, ghosts and the activation
recovery counts are written for the standard stance and checked against all
five; the trainer's stance picker (`SampleData.stancesByExercise`, shown by
`Exercise3DView`) swaps the model and shows each stance's own note and
muscle list, which follow that stance's paint. A third agent measured the
ten stance models for those: the high placements light the glutes and the
low ones the quads (supported: ExRx; Da Silva 2008 on the leg press); the
owner's "wide = inner quads, narrow = outer quads" is not (McCaw 1999, Paoli
2009), so those notes only say what the model lights. The Ab Wheel Rollout's
content was revised for its female model (rounded back, hips above the
knee-to-shoulder line, 93 cm roll-out; obliques, lats, triceps and rear
delts as secondary rows) through a reviser and two checkers. Open: the Cable
Step-Down's model is a standing cable kickback from a knee drive (nothing
steps down), so its name may want changing; its library row now says
GLUTEUS MAXIMUS, as painted. The stance sets' legends sit over the dark
machine base.

Renamed the same evening (owner's call): Cable Step-Down is now Cable
Knee-Drive Kickback, since its model drives the knee up and kicks the leg
back and nothing steps down (the export was named Cable_Step_Downs). The
resource stays `CableStepDown`; the library row, content, ghosts, still
times, thumbnail (`lib-cable-knee-drive-kickback`) and tool files use the
new name, and the movement pattern files it with the glute kickbacks.
