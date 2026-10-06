# 401-500 folder, round 2: hollow body, dead bug and bird dog (2026-10-05)

Four floor core exercises from the builder's 415-444 exports: 441 Hollow Body Hold, 442 Hollow
Body Rock, 439 Dead Bug and 440 Bird Dog (models `Abs/<Resource>.usdc`).
`spec_500_stability.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_stability.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_stability.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The rigs straight from the USD with Blender's Python + pxr: `SCRATCH/stability/rig.py` (every
  joint every frame, the format of the earlier families' `rig.py`), `measure.py` (joint positions
  and angles every 0.125 s, and the lowest point above the mat of the skinned muscle meshes, grouped
  as shoulder-blade muscles (trapezius middle and lower, infraspinatus, rhomboid major, teres major
  and minor), erector spinae (split along the trunk into lumbar and thoracic parts), gluteus
  maximus, head, fleshed hands, shoes (split by the nearer ankle), calves and hamstrings),
  `show.py` (timelines). The mat (`HG_Mat`) has its top at y 0, so the heights are above the mat.
- The motion briefs (`SCRATCH/briefs2/<Resource>.md`, `briefs2_legs/`), `tiers2.txt`,
  `joints.json` and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`). The briefs' trunk lean
  and rep phases were written for upright lifts; for these floor lifts the trunk angle, the hip,
  knee, shoulder and elbow angles, which limb moves and when, and the heights above the mat were
  measured from the rig.
- Ghosts: `SCRATCH/stability/ghost.py`, a copy of the calfseat family's Python port of
  `FaultGhost.solve` with this family's framings and rigs (its projection reproduces `joints.json`
  to the third decimal), `pieces.py` (the pieces in Python), `draw.py` + `render.py` (ghost and
  real skeleton over the stills), and a sweep of the rock's ghosts over its whole clip for the
  lowest ghost joint.
- Labels: `preview_500.py stability` plus `SCRATCH/stability/overlay.py` (the calfstand family's
  overlay: pills ~24 + 6.4 pt per character, the eye button and legend line boxed, leaders to the
  probed joint in each still), then the lab shots (`lab500.sh shoot`).
- Sources: Europe PMC REST records (abstracts) for every study, the PMC full text of Stevens 2007;
  ExRx through the Wayback Machine (`SCRATCH/stability/exrx/*.html`, text with `txt.py`); NASM,
  StrengthLog and CrossFit pages fetched directly (`SCRATCH/stability/src/`).

## Shared facts about the models

- One body (torso, neck to pelvis in a straight line, 0.59 m with the spine straight on all fours,
  0.53 m in the hollow and 0.57 m lying flat in the dead bug), clips of 7.96 s at 24 fps, a 1.6 x
  2.4 m mat, no other equipment.
- Reference heights lying flat (the Dead Bug's trunk, which never moves): the shoulder-blade
  muscles 0.1 cm above the mat, the buttocks 0.3 cm, the head resting on it, the lumbar part of the
  erector spinae 3.0 cm above it (the natural hollow under the lower back), the scapula joints
  6.8 cm up.
- Paint (`tiers2.json`): hollow hold and rock, RectusAbdominis bright, ExternalOblique,
  InternalOblique, Sartorius dim; dead bug, RectusAbdominis bright, DeltoidPosterior, the two
  obliques, Sartorius dim; bird dog, ErectorSpinae, GluteusMaximus, GluteusMedius, GluteusMinimus
  bright, DeltoidAnterior, DeltoidLateral, the two obliques, RectusAbdominis dim. Rows follow the
  paint (bright = PRIMARY, dim = SECONDARY): "Hip Flexors" for the sartorius (legend-only, as the
  library's Abs content and the brief say). Named with the stabilisers instead of a row: the dead
  bug's dim posterior deltoid (legend width) and, on the bird dog, the bright gluteus minimus (no
  value measured) and the dim rectus abdominis and lateral deltoid (see each exercise).
- Legend width (one line per rank): the lab shot showed the dead bug's secondary line OBLIQUES ·
  HIP FLEXORS · POSTERIOR DELTOID (42 characters) cut after ~38 with the rank word, so the
  calfstand family's ~43 is generous; the posterior deltoid went to the stabilisers. The bird dog's
  primary line ERECTOR SPINAE · GLUTEUS MAXIMUS · GLUTEUS MEDIUS is 49 and truncates to GLUTEUS...
  (the open point the round-1 README names for three-primary rows; all three are painted bright,
  so the house rule keeps them).
- No EMG study of the hollow hold or rock was found (Europe PMC searches for hollow body, hollow
  hold, hollow rock and hollow position with EMG, gymnastics or abdominal terms; the web results
  that quote percentages for the hollow hold are fitness blogs with no study behind them and were
  not used). The dead bug and bird dog studies report %MVIC, which the app's fractions are not, so
  every fraction is a judgement call anchored on the library's nearest lifts and the order the
  studies give (each is said in the spec's code comments).
- Framings: hollow hold and rock side-on (yaw -1.35, head on the screen's right); dead bug and bird
  dog three-quarter from the front-left (-0.8; the dead bug's head on the right, the bird dog's on
  the left).

## Hollow Body Hold

Model facts: face up, head toward -z. Arms straight overhead (shoulders flexed ~166°, elbows 180°),
hands ~50 cm apart (shoulder joints 39 cm apart), the hands 36-39 cm off the mat. Legs straight
(knees 180°), ankles 24 cm apart, toes pointed (ankle ~145°), the hip-to-ankle line ~13° above
the floor, heels 26 cm off the mat, hip angle (neck-hip-knee) ~157°. The head is off the mat (its
lowest point 22 cm up, the head joint 30 cm vs 11 cm lying flat), the shoulder blades too (scapula
joints 16.7 vs 6.8 cm lying flat; the back's muscle surface lifts away from the lower thoracic
region up, 4.2 cm at the thoracic erector spinae, 5.3 cm at the lowest shoulder-blade muscle); the
buttocks touch the mat (0.1 cm) and the lumbar erector spinae sits 2.5 cm above it, no higher than
lying flat (3.0 cm). Static: a slow sway on a 4 s cycle (the neck 24.0-25.2 cm up, the hands
40.1-42.8 cm); the legs never move. Logged in seconds (`ExerciseCatalog.timedExercises`).

| Claim | Source |
|---|---|
| Lower back pressed into the mat the whole hold | StrengthLog Hollow Hold ("Press your lower back into the ground", "keep your lower back pressed firmly into the floor"); the model (lumbar 2.5 cm, no higher than lying flat; the buttocks down) |
| The hip flexors hold the legs up; the psoas is attached to the lower spine | ExRx Lying Straight Leg Raise (target iliopsoas); ExRx Iliopsoas (origin: vertebral column, T12, L1-5 and discs) |
| With the trunk held still, the abs hold the pelvis and lower back in place against that pull | ExRx Lying Straight Leg Raise and Lying Leg Raise comments ("With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion"); ExRx Rectus Abdominis ("controls the tilt of the pelvis and curvature of the lower spine") |
| An EMG study that kept the pelvis tucked while both straight legs were lowered: abdominals worked harder than in a bent-knee curl | Shields and Heiss 1997 (15 men; posterior pelvic tilt held by electrogoniometer feedback; double straight-leg lowering significantly greater abdominal activation than the isometric bent-knee curl) |
| Correct: raise the legs a little if the back lifts | StrengthLog's range (15-30°, higher is the easier end) and its easier version; coaching |
| Shoulder blades up: a small curl of the upper trunk, the rectus abdominis's own movement, held still | ExRx Rectus Abdominis (movement: spinal flexion); the library Crunch's wording (the rectus flexes the trunk) |
| StrengthLog sets the shoulder blades just above the ground, only the lower back and buttocks touching | StrengthLog ("ensuring your shoulder blades are just above the ground"; "only your lower back and glutes in contact with the floor") |
| Heels about 25 cm off the mat here | The model (26 cm) |
| Lower, straighter legs lever harder on the trunk; raising them makes it easier | Mechanics (the legs' weight sits further from the hip axis as they lower); StrengthLog's range |
| StrengthLog 15 to 30° off the ground; ExRx eases a straight-leg raise by bending the knees | StrengthLog ("Lift your legs between 15 and 30 degrees off the ground, keeping them straight"); ExRx Lying Straight Leg Raise (Easier: "flex knees along with hips"). The model's legs sit ~13° above the floor, just under StrengthLog's range; the copy gives the model's heel height rather than an angle |
| Toes pointed | The model (ankle ~145°, plantar flexed) |
| Arms overhead in line with the body; hands a little wider than the shoulders | StrengthLog ("Your arms should remain extended overhead in line with your body"); the model (hands 50 cm apart, shoulder joints 39 cm). The model's legs are hip-width (ankles 24 cm apart) where StrengthLog keeps them close together; the copy says hip-width in the setup |
| Overhead arms lengthen the top end of the shape | Mechanics, as the leg lever |
| Logged in seconds, not reps; StrengthLog asks you to breathe steadily while you hold the position | The app (`timedExercises`); StrengthLog ("Breathe steadily and hold this position for the desired amount of time") |
| If you can only hold it on a held breath, use the easier version, knees bent and drawn in | StrengthLog ("To make the exercise easier, you can bend your knees slightly and keep them closer to your chest") |
| Setup | StrengthLog's steps (lower back pressed down, legs and head and shoulders lifted; StrengthLog lifts the legs first and the head and shoulders with them, the setup lists the upper body first) with the model's sizes (hip-width legs, heels ~25 cm) |

Activation: Rectus Abdominis 0.82 PRIMARY (bright), Obliques 0.52 and Hip Flexors 0.48 SECONDARY
(dim). Judgement calls: no EMG of the hollow; the rectus at the library Reverse Crunch's 0.82
(Shields 1997: straight-leg lowering with the pelvis tucked beat a curl, so not below the Crunch's
0.80); the obliques between the Crunch's 0.45 and the Reverse Crunch's 0.58; the hip flexors hold
both straight legs off the floor the whole time (ExRx: the iliopsoas is a straight-leg raise's
target), a touch over the Reverse Crunch's 0.42. StrengthLog lists the same three: abs primary,
obliques and hip flexors secondary. Stabilisers: transverse abdominis (convention, as the library's
abs content), quadriceps (ExRx straight-leg raise stabilisers; the knees are held straight), neck
flexors (the head held up, as the library Crunch).

## Hollow Body Rock

Model facts: the hold's shape, rigid (hip ~157°, knees 180°, shoulders ~166°, the spine's curve
fixed), rocking end to end, a rock every 1.33 s (six in the clip). The trunk line (pelvis to neck)
tips from 24° above level (head end up at 0.33, 1.67, 3.0, 4.33, 5.67, 7.0 s: heels 3.5-3.9 cm
off the mat, the lowest shoulder-blade muscle 11.5 cm up, the head's lowest point 35 cm, the
buttocks 0.5 cm) to 6° below level (legs end up at 1.0, 2.33, 3.67, 5.0, 6.33, 7.67 s: the
shoulder-blade muscles touch the mat, the head's lowest point 10 cm up, heels 51 cm, buttocks
2.8 cm), a 30° rock rolling on the curved back from the buttocks to the shoulder blades. It starts
at the mid pose, the hold's pose. Logged in reps.

| Claim | Source |
|---|---|
| The back stays curved, lower back down, so the body rolls like a rocker | CrossFit The Hollow Rock ("rock like a rocking chair"); the model (rolls on the curved back) |
| CrossFit: a flat spot where the body lands with a clunk instead of rolling, which it puts down to weak contraction of the lower abs; take the clunk out | CrossFit ("a flat spot that creates a visible clunk caused by weak contraction of the lower abs. Take the clunk out"), paraphrased |
| Rolls from the buttocks to the shoulder blades here | The model (buttocks down at the head-up end, the shoulder-blade muscles down at the legs-up end) |
| CrossFit likens the rock to a rocking chair, which tips without changing shape; here the hips keep the same angle through every rock | CrossFit ("rock like a rocking chair"; that a rocking chair keeps its shape is the image, not CrossFit's words); the model (hip 156.6° every frame). "Swinging the legs up at the hips throws the body over with momentum" is the plain consequence of a hip swing, said as the mistake the ghost draws |
| Arms overhead beside the head; swinging them forward throws the body toward the feet | CrossFit ("with your arms extended overhead"); mechanics; the model (shoulders ~166° all clip) |
| Knees straight; bent knees shorten the lever; ExRx eases a straight-leg raise by bending the knees | CrossFit ("legs out straight"); ExRx Lying Straight Leg Raise (Easier); the model (knees 180°) |
| Heels just off the mat at the low end | The model (3.5-3.9 cm) |
| About one rock every 1.3 s, six every eight seconds | The model (1.33 s per rock, six head-up peaks in 7.96 s) |
| CrossFit reads the smoothness of the rock as a measure of lower-ab strength | CrossFit ("The smoothness of your rocking speaks to your lower ab strength") |
| Setup: the hollow first, then tip toward the feet to start | StrengthLog's hollow; the model (from the mid pose the head end rises first, 0 -> 0.33 s) |

Activation: as the hold (same paint, same shape; the rock is the hold in motion). No study
separates them, so the same judgement-call fractions; the library row already rates it advanced
over the hold's intermediate. Stabilisers as the hold.

## Dead Bug

Model facts: face up, head toward -z. The trunk never moves: the head and shoulder-blade muscles
rest on the mat, the lumbar erector spinae 3.0 cm above it all clip. Start: arms straight up over
the shoulders (shoulders flexed ~86°, the upper arms 84° above level), hips ~95° and knees 90°
(thighs vertical, shins level, knees over the hips, heels 52 cm up). Rep 1: the RIGHT arm goes back
overhead (to ~170°, the upper arm 4° above level, the hand ~10 cm off the mat) while the LEFT leg
straightens out (hip 174°, knee 174°, the thigh 4° above level, the heel ~9 cm off the mat),
together, 0.12-1.25 s (~1.1 s); held 1.25-1.95 s (~0.7 s); back 2.0-3.2 s (~1.2 s); rest
3.2-4.1 s. Rep 2: the LEFT arm and RIGHT leg the same way, 4.1-7.2 s, rest to the end. Elbows
180° all clip.

| Claim | Source |
|---|---|
| Lower back stays on the mat while an arm and a leg reach away | NASM Dead Bug ("press your lower back into the floor throughout the movement"); StrengthLog Dead Bugs ("Keep the lower back in contact with the floor the entire time"); the model (trunk still, lumbar unchanged) |
| The reaching leg levers on the pelvis and tries to tip it into an arch; holding it still is the abs' job | Mechanics; ExRx Rectus Abdominis (controls the pelvis's tilt) |
| In an EMG study the dead bug worked mostly the abdominal muscles | Souza 2001 ("the Dying Bug exercise predominantly recruited the abdominal musculature") |
| NASM lists the lower back arching away from the floor first among its common mistakes; comparison: NASM reads it as the core letting go | NASM (first item: "Allowing the lower back to arch away from the floor, indicating core disengagement") |
| Right arm with the left leg, then left arm with right leg | The model (rep 1 right arm + left leg, rep 2 left + right); NASM ("Extend your right arm overhead while simultaneously extending your left leg", then alternate); StrengthLog (opposite arm and leg) |
| Opposite limbs at the same moment make the trunk hold still against both | Plain description of the lift (both limbs move together in the model) |
| Heel and hand stop about a hand's width above the floor | The model (heel 8.6 cm, hand 9.7 cm) |
| NASM stops them just short of touching the floor | NASM ("Stop just short of touching your arm and leg to the floor") |
| Both arms straight; NASM and StrengthLog start with both arms straight up toward the ceiling | NASM ("arms extended toward the ceiling perpendicular to your torso"); StrengthLog ("arms straight up towards the ceiling"); the model (elbows 180° all clip) |
| A straight arm keeps the hand far from the shoulder, a long lever overhead like the leg | Mechanics |
| Each reach about a second, a short hold at full stretch | The model (~1.1 s out, ~0.7 s held, ~1.2 s back, ~0.9 s pause) |
| NASM asks for slow, deliberate reps and lists moving too fast or jerkily among the mistakes | NASM FAQ ("Perform dead bug movements slowly and deliberately"); mistakes ("Jerky or uncontrolled limb movements", "Moving too quickly without maintaining spinal control"). An EMG study of dead-bug speeds (Korean, 2017) was found by search but could not be opened, so nothing is claimed about speed and muscle activity |
| Setup: head and shoulders down, arms up over the shoulders, knees over the hips at 90°, shins level, lower back pressed down | NASM and StrengthLog set-ups; the model |

Activation: Rectus Abdominis 0.68 PRIMARY (bright); Obliques 0.55 and Hip Flexors 0.40 SECONDARY
(dim). Judgement calls: Souza 2001 found the rectus and obliques about equally active and nothing
above 41% MVIC, so the rectus sits moderate, under the library Plank's 0.78, and the obliques below
it (dim, so secondary); the hip flexors lower and return the reaching leg (a little under
the Reverse Crunch's 0.42). The posterior deltoid is painted dim; a shoulder extensor (ExRx), it
brings the arm back up from overhead, a minor role. It was a LOW 0.20 row until the round 1 shot
showed the secondary legend truncated (OBLIQUES · HIP FLEXORS · POSTERIOR DELTO...), so it is named
with the stabilisers, as the calfstand family did with the rhomboids. NASM lists the rectus and
transverse abdominis as primary, the obliques secondary; StrengthLog abs primary, obliques
secondary. Stabilisers: transverse abdominis (NASM), posterior deltoid (above), quadriceps
(straightening the reaching knee; ExRx's leg-raise stabilisers).

## Bird Dog

Model facts: on hands and knees, head toward +z. Hands ~7 cm behind the shoulders (about under
them), elbows ~165°, forearms near vertical; knees under the hips, ~20 cm apart; the toes resting
on the mat. The trunk ~9° above level (shoulders a little higher than the hips) and still all
clip (the spine's bend constant). Rep 1: the RIGHT arm forward and the LEFT leg back together,
0.2-1.25 s (~1 s); held 1.25-2.1 s (~0.9 s); back 2.2-3.35 s (~1.1 s); rest to 4.1 s. Rep 2: the
LEFT arm and RIGHT leg, 4.1-7.35 s. Extended leg: hip 172°, knee 169°, the thigh 6° below level,
the ankle at hip height (46 vs 48 cm). Extended arm: the upper arm 16° above level, but the elbow
bends to ~116° with the elbow out to the side (12 cm), so the hand ends ~46 cm in front of the
shoulder at shoulder height (wrist 57 cm up, shoulder 56 cm), in front of the head. Both hip
joints stay at the same height; the pelvis slides ~2 cm toward the supporting knee.

| Claim | Source |
|---|---|
| Hips level and square while one leg is up; NASM lists the spine rotating or the hips shifting first among its common mistakes | NASM Bird Dog (first common mistake: "Allowing the spine to rotate or the hips to shift"); the model (hip joints level all clip) |
| With a leg up the pelvis rests on one knee and the trunk muscles stop it turning; in EMG studies the obliques and back muscles on opposite sides of the trunk worked together to hold it still | Stevens 2007 abstract and full text (exercise 2: the other side's internal oblique and the leg side's external oblique >20% MVIC, the leg side's lumbar iliocostalis and the other side's thoracic iliocostalis high; the abstract: hip and trunk muscles "function together in order to stabilize the spine"; its discussion reports Callaghan 1998's suggestion that the other side's internal oblique was activated "to maintain a neutral pelvis and spine posture" and finds it goes with the leg side's external oblique); Garcia-Vaquero 2012 (highest: the internal oblique on the raised arm's side and the erector spinae on the other side) |
| The leg straight back to about hip height, knee nearly straight | The model (thigh 6° below level, knee 169°) |
| One EMG study raised the leg to the horizontal; the gluteus maximus of that leg among the most active muscles | Stevens 2007 (the leg "out to the horizontal"; the leg side's gluteus maximus and multifidus >20% MVIC, the highest group); also Souza 2001 (erector spinae and gluteus maximus most active when the leg on their side was raised) |
| NASM extends the arm and leg into one straight line while the spine stays neutral | NASM ("creating a straight line through your arm and leg"; "Maintain a neutral spine and stable torso") |
| The hand reaches forward to about shoulder height, in front of the head; the elbow allowed to bend as here | The model. ExRx ("Raise arm out straight beside head") and NASM reach with a straight arm; the model's elbow bends to ~116° with the hand still at shoulder height, so the copy follows the model and does not say straight |
| One EMG study raised the arm to the horizontal; in a spine-loading study adding the opposite arm to a leg lift made it harder | Stevens 2007 (the arm "to the horizontal"); Callaghan 1998 ("When combined with contralateral arm extensions, the challenge and demand of the exercise were increased"; the abstract does not say the single-leg extension was on hands and knees, Stevens 2007's introduction cites it for "the single leg extension task in four-point kneeling") |
| Hands under the shoulders, knees under the hips | NASM ("hands positioned directly under your shoulders and your knees under your hips"); ExRx ("Kneel on mat on all fours"); the model |
| Stacked, the arms and thighs carry the weight straight down | Mechanics |
| ExRx: lift deliberately with no jerking; one EMG study 2 s up, 5 s held, 2 s down; here about a second each way with a short hold | ExRx Bird Dog comments ("Lift leg and arm deliberately with no jerking"); Stevens 2007 methods (dynamic phases 2 s, static phase 5 s, metronome); the model |
| Setup | NASM and ExRx set-ups; the model (elbows ~165°, the trunk about level, the head in line) |

Activation: Erector Spinae 0.64, Gluteus Maximus 0.64, Gluteus Medius 0.42 PRIMARY (bright);
Obliques 0.48, Anterior Deltoid 0.28 SECONDARY (dim). The back extensors and gluteus maximus of the
raised leg's side are the most active muscles in the studies (Stevens: lumbar multifidus and
gluteus maximus >20% MVIC, not significantly different from each other; Souza: erectors and
gluteus maximus most active on the raised leg's side, all below 41%; Ekstrom 2007's abstract: this
lift may help strengthen the gluteus maximus), so both sit level and moderate, well
under the library Glute Bridge's 0.82 and Back Extension's 0.85 (low loads). ExRx lists the
erector spinae as the target (the library row's muscle, so it is listed first) and the gluteus
maximus as a synergist. The gluteus medius is painted
bright but is an ExRx stabiliser here and no value was read for it (Ekstrom's per-muscle values are
in the paywalled full text), so it is the lowest moderate; ExRx's Gluteus Medius page gives it the job the support knee needs
(it "steadies pelvis so it does not sag when opposite side is not supported with leg"). The gluteus minimus, painted bright
with it, is named with the stabilisers (ExRx stabiliser; no value; the 351-400 hip family's rule
for an unmeasured painted minimus). Obliques: Stevens >20% MVIC (both obliques in the pattern
above, the same class as the multifidus and gluteus maximus), Garcia-Vaquero's most active
muscle with the other side's erector spinae, Souza above the rectus abdominis; a moderate 0.48 as a dim secondary, under the two bright
extensors and above the unmeasured gluteus medius (review: raised from a LOW 0.38, which read as a
minor role against all three studies). Anterior deltoid: holds
the reaching arm forward (ExRx synergist, shoulder flexion). Named with the stabilisers instead of
rows: the rectus abdominis (dim, but among the lowest muscles measured, Stevens <10% MVIC, and an ExRx
antagonist stabiliser), the lateral deltoid (dim; an ExRx synergist with a minor role), so the
secondary legend line stays one line; and the hamstrings (ExRx dynamic stabiliser, unpainted).
NASM lists the rectus abdominis as a primary muscle; the EMG and the paint do not, so the copy
follows them.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`). Every
leader meets its joint from the open side, above the body or up through the mat below it; the eye
button (top right, above ~0.12) and the legend (below ~0.88) are clear. In a mistake view only that
cue's pill shows, over a model lifted and shrunk (`roomBelow`), so each pill was also checked
against its own ghost there.

- Hollow hold: legs (Legs long and low, to the near knee) 0.20 left; arms (Arms long overhead, to
  the near elbow) 0.20 right; back (Low back on the mat, to the lumbar spine) 0.70 left; breath
  (Breathe, keep the shape, to the chest) 0.80 left, its leader staying right of the back leader;
  shoulders (Shoulder blades up, to the near shoulder blade) 0.70 right. Round 1 had the legs and
  arms pills at 0.30, where the raised legs and arms ghosts reach (v ~0.29 in the lifted mistake
  view) and sat on the pills; the breath pill was top right then.
- Hollow rock: knees (Knees straight) 0.20 left and arms (Arms stay overhead) 0.20 right, for the
  same reason (round 1's arms pill at 0.30 sat on the thrown-forward arms ghost); hips (Rock as one
  piece, to the far hip, left of the lumbar spine on screen) 0.70 left and back (Back stays curved,
  to the lumbar spine) 0.80 left, stacked so their leaders do not cross; tempo (Smooth, even rock,
  to the chest) 0.70 right. The rocking feet rise to v ~0.43 and the hands to ~0.45 in the trainer
  view, far below the top pills.
- Dead bug: the probed joints are fixed sides, and the reaching limbs switch sides halfway, so each
  cue points at a joint whose leader stays clear in both halves (lab stills at 0, 1, 1.6 and
  5.5 s): reach (Reach low, no touch, to the left foot) 0.30 left; pair (Opposite arm and leg, to
  the right hand) 0.16 right; arms (Arms straight, to the left hand) 0.27 right, short so the pair
  leader passes left of it; back (Low back stays down) 0.72 left; tempo (Slow and steady, to the
  head) 0.72 right. While the right arm is overhead (1-2 s) the pair leader ends at the right hand
  beside the left shoulder, running down just left of the upright left arm. A first layout with a
  resting-knee cue (Knees over hips, to `patella_R`) crossed the reach leader in the second half,
  when the right leg reaches, so that cue became the arms cue. Round 1 had the arms pill at 0.32
  (the raised left hand came within ~2 pt of it in the lifted mistake view) and the pair pill at
  0.20. Probing `_bent` / `_straight` points for the dead bug and bird dog (probe.py's SIDE_SHIFT,
  which the app already resolves for labels) would let the reach cue follow the reaching foot;
  requested in the report.
- Bird dog: base (Hands under shoulders, to the near shoulder, which stays put while either arm
  moves) 0.24 left, passing right of the head; tempo (Slow, hold the top, to the chest) 0.18 right;
  hips (Hips level, to the pelvis) 0.30 right; arm (Hand at shoulder height, to the right hand)
  0.80 left, from below: on the mat its leader rises across the mat to the hand, reaching (first
  half) it passes left of the body and below the head to the hand out in front; leg (Heel back,
  hip height, to the left ankle) 0.72 right, rising across the mat. A first layout with the arm
  pill top left crossed the head whenever the right hand was on the mat.
- Legends: the dead bug's secondary line read OBLIQUES · HIP FLEXORS · POSTERIOR DELTO... on the
  round 1 shot, so the posterior deltoid moved to the stabilisers (the calfstand family's rule for
  the legend); the bird dog's primary line reads ERECTOR SPINAE · GLUTEUS MAXIMUS · GLUTEUS...
  (left as it is, see Uncertain).

## Ghosts

Measured with the port at the fault's still and checked on the lab stills; distances are joint
moves at full strength. Lying face up the lifter's forward is the ceiling (`BodyFrame`: left +x,
up toward the head), on all fours the floor. Turns about `.lateral`: positive carries the front
toward the head, so a positive turn lifts face-up legs and lowers face-up arms overhead.

- Hollow hold (still 2.0 s; static): back `stability500BackArched(0.32, legs: 10)` (lumbar ~17 cm
  toward the ceiling, a peak above the hip and the chest; chest ~8 cm; legs 10° lower, heels
  ~15 cm; round 1's 0.22 with 8° read only as a straighter trunk line and lower legs);
  shoulders `stability500ShouldersDown(22)` (neck, head and arms turned 22° back about the chest:
  the chest-to-neck line 28° -> 6°, as lying flat; head ~15 cm, shoulders ~9 cm lower); legs
  `stability500LegsRaised(20)` (heels ~27 cm higher); arms `armsTurned(.lateral, -45)` (hands
  ~29 cm higher). Breath has none.
- Hollow rock: back `stability500BackArched(0.32)` (no leg drop: at the low end the heels are
  3.5 cm off the mat, so dropping the legs would put them through it; still 2.0 s, the mid pose);
  hips `stability500LegsRaised(20)` (still 1.0 s, the legs-up end); arms `armsTurned(.lateral,
  -55)` (still 1.67 s, the head-up end, hands pointing at the ceiling); knees
  `stability500Tucked(thighs: 35, knees: 60)` (knees ~120°; still 1.67 s). Every rock ghost was
  swept over the whole clip: the lowest ghost joint stays 11 cm or more above the mat (a plain knee
  bend of 50-60° put the toes 7 cm into the mat at the low end, hence the tuck). Rhythm has none.
- Dead bug (still 1.6 s, the first hold; the `_straight` / `_bent` pieces follow either side and
  fade in with the reaching knee, `.whenStraight("shin_straight")`, 0.93 at the hold, 0 at the
  start where both knees are bent): back `stability500BackArched(0.32, strength:
  .between("foot_L", "foot_R", from: 0.6, to: 1.0))` seen side-on (`.seen(-0.55)`, to the
  hollow's -1.35): lumbar ~18 cm, chest ~8 cm, faded in as the ankles part (0.42 torso lengths at
  the start, ~1.1 with a leg out), so it shows in both halves; pair `stability500SameSide(84)`
  (the reaching arm back up, the other arm overhead beside the reaching leg, hands ~67 cm); reach
  `stability500StopsShort(hip: 35, knee: 50, arm: 45)` (leg 35° higher with the knee ~127°, the
  knee ~23 cm and the foot ~14 cm higher; hand ~35 cm higher; round 1's 45° put the ghost's toes
  against the reach pill); arms `stability500ElbowsBent(resting: 60, reaching: 70)` (elbows ~124°
  and ~115°; the opposite signs were tried first and put the reaching hand 9 cm into the mat).
  Tempo has none.
- Bird dog (still 1.6 s, the first hold): hips `stability500HipRolled(25, out: 20)` (review: the
  pelvis and reaching leg turned 25° about the trunk's long axis through the supporting hip, the
  reaching hip ~7 cm higher and the hip line tilted ~22° at the hold, and the leg swung 20° out
  about its hip, the foot ~20 cm out; the author's `stability500HipOpened(rise: 0.15, out: 0.08)`
  shifted the whole leg ~9 cm up and ~5 cm out with the pelvis ~4 cm, which stretched the
  pelvis-to-reaching-hip line from 9.1 to ~14 cm and read on the lab shot as the leg a little
  higher); leg
  `stability500LegKicked(25, sag: 0.1)` (foot ~31 cm higher, the lower back ~5 cm toward the
  floor); arm `armsTurned(.lateral, 30, side: "bent", strength: stability500Reaching)` (hand ~20 cm
  higher, above the head); base `armsTurned(.lateral, 20, side: "straight")` (the support hand
  ~18 cm forward, still on the mat, +1 cm). Tempo has none. A head ghost (looking up) was tried and
  dropped: the neck-to-head line is ~10 cm, and even 50° moved it only ~12 pt.
- Bone lengths: turns keep them; the arch pieces shift the lumbar joint, which stretches the
  pelvis-spine-chest line a little (hollow: pelvis to lumbar 11.4 -> 12.1 cm, lumbar to chest
  15.6 -> 17.6 cm; dead bug: 11.3 -> 14.4 and 15.6 -> 18.9 cm), as the library's
  `lowerBackArched` does; the bird dog's leg kick sags the lumbar ~5 cm (pelvis to lumbar
  +11%). The bird dog hip roll is two turns, so the hip width (18.3 cm) and leg bones are kept
  (the review's port: `SCRATCH/stability/review/run5.py`). No knee or elbow bends backward: the
  knee and elbow ghosts are turns about the joint in the direction it flexes (checked on the port
  and the stills).

## Uncertain

- No EMG of the hollow hold or rock; their fractions rest on the library's crunches and
  Shields 1997's straight-leg lowering, and are judgement calls.
- Ekstrom 2007 was read as an abstract only (the full text is paywalled); only its conclusion
  about the gluteus maximus is used.
- The Korean dead-bug speed study (found by search) could not be opened; nothing from it is used.
- The bird dog's reaching arm is bent ~116° in the model, where ExRx and NASM reach with a straight
  arm; the copy describes the hand's position and allows the bend.
- The hollow hold's legs sit ~13° above the floor, just under StrengthLog's 15-30°; the copy gives
  the model's heel height (about 25 cm).
- The bird dog's primary legend line truncates to GLUTEUS... (three bright muscles, 49 characters;
  the README's open point on three-primary legends). The rows follow the paint; a shorter name
  ("Glutes" for all three) would fit but departs from the library's names.
- ExRx was read through Internet Archive copies.

## Change log

- 2026-10-05, draft: models measured, sources read, copy, setup, ghosts and moments for all four;
  `spec_500.py stability` OK; `lab500.sh check stability` BUILD SUCCEEDED on the first build.
- Lab round 1 (`lab500.sh shoot stability "0,1,1.6,5.5"`, kept in `SCRATCH/stability/round1/`):
  the app ran (no home-screen shots). Fixed: the hollow hold's legs and arms pills and the rock's
  arms pill sat on their raised ghosts (moved to 0.20, the breath and rhythm pills below the mat);
  the arch ghosts read only as a straighter trunk (0.22-0.25 -> 0.32); the dead bug's reach ghost
  toes touched its pill (45° -> 35°) and its arms pill sat ~2 pt above the raised hand (0.32 ->
  0.27, the pair pill 0.20 -> 0.16); the dead bug's secondary legend truncated (posterior deltoid
  to the stabilisers). Copy self-review before the round: no claim beyond its source (the hip
  extension clause in the bird dog leg cue and a breath-holding clause replaced by sourced ones),
  the bird dog's erector spinae and gluteus maximus levelled (Stevens 2007: not significantly
  different), one setup sentence shared by the hold and rock reworded.
- Lab round 2 (kept in `SCRATCH/stability/round2/`): every trainer still has its labels off the
  lifter and the moving limbs, leaders sensible in both halves of the dead bug and bird dog; every
  ghost attached, readable and above the mat. Left: the dead bug's pair leader runs down just left
  of the upright left arm while the right arm is overhead (1-2 s), and the bird dog's primary
  legend truncates.
- Self-review (sources and model) after round 2: the bird dog hips cue now says NASM lists the
  rotating spine or shifting hips first among its common mistakes (it had said "the mistake").
  Final lab run (`SCRATCH/lab/stability/`, trainer at 0 / 1 / 1.6 / 5.5 s and all 16 ghosts):
  BUILD SUCCEEDED, screens identical to round 2.

## Review (2026-10-05)

An independent sources and model review of the four files, round 2 of the 401-500 batch. Working
files are in `SCRATCH/stability/review/`; the pre-review lab output is kept in
`SCRATCH/stability/review_before/`.

- Sources reopened: the six Europe PMC records (Souza 2001, Stevens 2007, Garcia-Vaquero 2012,
  Callaghan 1998, Ekstrom 2007, Shields and Heiss 1997); authors, year, journal, volume, pages,
  DOI and PMID all match the header. The PMC full text of Stevens 2007 (30 volunteers, the leg and
  the opposite arm to the horizontal, 2 s up, 5 s held, 2 s down at a metronome, neutral spine,
  ipsilateral meaning the extended leg's side, multifidus and gluteus maximus not significantly
  different, the obliques' role in holding the pelvis and spine). NASM Dead Bug and Bird Dog,
  StrengthLog Hollow Hold and Dead Bugs, and CrossFit The Hollow Rock were fetched fresh; ExRx's
  Bird Dog, Alternating Bird Dog, Lying Straight Leg Raise, Lying Leg Raise (floor), Iliopsoas,
  Rectus Abdominis, Gluteus Medius, Anterior and Posterior Deltoid pages were re-read at the cited
  Wayback snapshots. Every quote and number in the notes is on the page it is attributed to.
- Changed, sources: Ekstrom 2007 no longer reads as naming the gluteus maximus the one muscle the
  quadruped lift may strengthen (the abstract says only that it may help strengthen it); the
  Callaghan abstract does not say the single-leg extension was on hands and knees, so the header
  and the claim table now take that from Stevens 2007's account of it; ExRx's Gluteus Medius page
  (it steadies the pelvis when the other side has no leg under it) is added as the reason the
  bright gluteus medius works while one knee carries the hips.
- Changed, activation: the bird dog's obliques from LOW 0.38 to MODERATE 0.48. All three studies put
  them among the most active muscles of the exercise (Stevens in the same >20% class as the
  multifidus and gluteus maximus, Garcia-Vaquero's highest, Souza above the rectus abdominis); as a
  dim muscle they stay secondary and under the two bright extensors. Every other row was checked
  against the paint (bright = primary), its level and the library anchors cited (Crunch 0.80,
  Reverse Crunch 0.82/0.58/0.42, Plank 0.78, Glute Bridge 0.82); all are labelled judgement calls.
- Changed, copy: the hollow hold's back cue said the abs work "with the trunk not curling" while the
  upper trunk is curled in the hold; it now says with the trunk held still. The rock's back mistake
  read "flattening and arching", which clashed with a flat lower back being the goal; it now says
  the lower back arches up off the mat, leaving a flat spot the rock lands on (comparison: Lower
  back arches, rock clunks). The rock's one-piece cue no longer puts tips as one piece in
  CrossFit's mouth: CrossFit likens the rock to a rocking chair, and the model's fixed hip angle is
  stated as the model's.
- Model checked from the rigs (`SCRATCH/stability/review/db.py`, `bd.py`, `hr.py` over the
  author's joint dumps, and the author's mesh heights): the dead bug's right arm with the left
  leg (0.1-1.25 s out, held to ~2 s, back by 3.2 s), then the left arm with the right leg
  (4.1-7.2 s), elbows 180° all clip, ankle joints 17.5 cm and wrists 15 cm up at the hold; the
  bird dog's right arm with the left leg first, the leg's ankle at hip height (46 vs 48 cm), knee
  169°, the reaching elbow 116° with the hand 46 cm in front of the shoulder at its height, the
  pelvis sliding 2.2 cm, hips level; the hold's legs 13° up, ankles 24 cm and hands 50 cm apart,
  the sway 8.5-9.9° on a 4 s cycle; the rock's trunk +24° to -6° every 1.33 s, six head-up peaks,
  the hip 156.6° every frame, the lumbar 2.2-4.3 cm above the mat through the rock (so lower back
  down holds). Copy, setup steps, left/right and timing claims all match.
- Changed, ghost: the bird dog's hips ghost (`stability500HipOpened`, a shift of the whole leg up
  and out with the pelvis half as high) stretched the pelvis-to-reaching-hip line from 9.1 to
  ~14 cm and read on the lab shot as the leg a little higher. It is now
  `stability500HipRolled(25, out: 20)`: the pelvis and reaching leg turned about the trunk's long
  axis through the supporting hip and the leg swung out about its hip, both turns, so the hip
  width and the leg's bones are kept; the hip line tilts ~22° and the foot swings ~20 cm out at
  the hold, the same on either side (checked at 1.6 and 5.6 s in the review's port, `run5.py`).
  The other 15 ghosts were re-solved in the port (bone lengths, bend direction, lowest point) and
  checked on the lab shots; each shows its named mistake, attached and possible.
- Labels: unchanged; every trainer still and mistake view re-checked. Left as the author reported:
  the dead bug's pair leader runs just left of the upright left arm to the right hand, hidden
  behind the head while it is overhead (1-2 s), and the bird dog's primary legend truncates.
- Lab (`lab500.sh shoot stability "0,1,1.6,5.5"`, output in `SCRATCH/lab/stability/`, copy in
  `SCRATCH/stability/review/lab_review1/`): BUILD SUCCEEDED, the app ran, trainer screens as
  before, the new hips ghost reads as the hip lifted and the leg swung out.

## Verification (final skeptic, 2026-10-05)

A last adversarial pass over every claim and number in the copy, setup steps, activation comments,
the spec header, this file's claim tables and the ghost comments. Working files are in
`SCRATCH/stability/final/`; the four files as they stood before this pass are kept there too.

- Sources re-fetched independently, not from the earlier copies: the six Europe PMC records
  (authors, journal, year, volume, pages, DOI, PMID and abstract wording all match the header);
  Stevens 2007 full text from PMC (30 volunteers, 15 men and 15 women; leg and opposite arm to the
  horizontal; 2 s up, 5 s held, 2 s down at a metronome; neutral spine; ipsilateral = the extended
  leg's side; multifidus and gluteus maximus not significantly different, P <= 0.44; the
  introduction cites Callaghan [8] for the single-leg extension in four-point kneeling); NASM Dead
  Bug and Bird Dog, StrengthLog Hollow Hold and Dead Bugs, CrossFit The Hollow Rock; ExRx Bird
  Dog, Alternating Bird Dog, Lying Straight Leg Raise, Lying Leg Raise (floor), Iliopsoas (snapshot
  2024-01-05), Rectus Abdominis, Gluteus Medius, Anterior and Posterior Deltoid through the Wayback
  Machine. Library anchors re-read in SampleData.swift (Crunch 0.80/0.45, Reverse Crunch
  0.82/0.58/0.42, Plank 0.78, Glute Bridge 0.82, Back Extension 0.85; Crunch stabilisers include
  the neck flexors; Hollow Body Hold in `timedExercises`; the four library rows), and the paint in
  `tiers2.json`.
- Models re-measured with my own scripts straight from the USD (`final/dump.py` joints every frame,
  `final/skin.py` skinned-mesh lowest points, `final/an.py`), not the author's or reviewer's dumps.
  Confirmed: the hold's hip 156-157°, knees and elbows 180°, shoulders 166°, legs 13° up, ankles
  24.2 cm and hands 49.9 cm apart (shoulder joints 39.2 cm), ankle 145°, heels 26.3 cm, hands
  36.0-38.6 cm, head 21.7-22.8 cm, buttocks 0.1 cm, lumbar 2.5 cm, a 4 s sway; the rock's hip 156.6°
  and spine curve identical every frame, head-up peaks at 0.33, 1.67, 3.0, 4.33, 5.67, 7.0 s (heels
  3.5 cm, shoulder-blade muscles 11.5 cm), legs-up peaks at 1.0, 2.33 ... 7.67 s (shoulder-blade
  muscles 0.1 cm, head 10.1 cm, heels 51.1 cm), lumbar 2.2-4.3 cm; the dead bug's trunk identical
  every frame, right arm with left leg 0.12-1.25 s, held to 1.95 s, back by 3.2 s, left arm with
  right leg 4.1-7.2 s, elbows 180° all clip, the reaching heel 8.6 cm and hand 9.7 cm off the mat,
  head 0.3 cm; the bird dog's right arm with left leg first (0.2-1.25 s, held to 2.1 s), hand
  6.5 cm behind the shoulder, elbows 165°, knees 19.7 cm apart under the hips, trunk 8.6° and still,
  leg hip 172°, knee 169°, ankle 46.1 vs hip 47.8 cm, upper arm 16° up, elbow 116° and 12 cm out,
  wrist 57.2 vs shoulder 55.6 cm, hand 45.6 cm ahead of the shoulder (the head joint 15.6 cm),
  hip joints level all clip, pelvis sliding 2.2 cm toward the supporting knee. The mat is 1.6 x
  2.4 m with its top at y 0; `GYM_Barbell_ROOT` holds only two empty sockets, so no equipment.
- Ghost sizes re-solved with the review's port (`final/gcheck.py`); every size in the ghost
  comments matches within a centimetre except the one fixed below.

Changed in this pass (no label, cue id, tracked joint, ghost or moment changed, so no lab shoot
was needed; `spec_500.py stability` prints OK and `preview_500.py` gives the same layout):

- Dead bug Range why: dropped "In an EMG study the dead bug's abdominal activity rose as its levels
  got harder". Souza 2001's abstract supports the sentence on its own, but it does not say what the
  levels were, and in a cue about how far to reach it read as if reaching lower was the harder
  level, which nothing I read supports.
- Hollow hold Breathing why: "so it has to last through many breaths, and StrengthLog's guide asks
  for steady breathing all the way through" claimed a hold length no source gives; it now says the
  hold is logged in seconds, not reps, and StrengthLog asks you to breathe steadily while you hold
  the position (its wording).
- Hollow rock Curved Back why: "the sign that the lower abs are not holding the curve" went past
  CrossFit's wording; it now says CrossFit puts the clunk down to weak contraction of the lower abs
  and asks you to take the clunk out.
- Torso length: the header, the shared facts and the ghost table said the torso (neck to pelvis)
  is 0.59 m; that is the straight-spine bird dog. The straight-line distance is 0.53 m in the hollow
  and 0.57 m lying flat in the dead bug, which is the length the ghosts' shifts scale with (0.32 x
  0.53 m = the 17 cm hollow arch). All three now say so.
- Bird dog activation comment and notes: "Garcia-Vaquero's highest muscle" for the obliques now
  names the other side's erector spinae as joint highest (the abstract names both); "the rectus
  abdominis was the lowest muscle measured" is now "among the lowest" (Stevens lists the rectus
  abdominis, the leg side's internal oblique and, in exercises 1 and 2, the other side's gluteus
  maximus under 10%). The header's Stevens entry says the same.
- Bird dog hips claim table: the "maintain a neutral pelvis and spine posture" quote is Stevens
  reporting Callaghan 1998's suggestion, not Stevens's own finding; the row now says so and adds the
  abstract's "function together in order to stabilize the spine", which is what the copy relies on.
- Dead bug activation comment and notes: the obliques at 0.55 against the rectus at 0.68 are
  "below" it, not "just under" it.
- Hollow hold setup row: StrengthLog lifts the legs first with the head and shoulders at the same
  time; the setup lists the upper body first, so the row no longer says "in the model's order".
- Rock hips ghost comment: "the feet ~28 cm higher" matched neither number in the port; the feet
  move ~29 cm, ~23 cm of it upward, at the legs-up end.

Checked and left as they are: every other cue, setup step, comparison note, label and activation
row. Still open, as the review left them: the dead bug pair leader beside the upright arm at 1-2 s,
the bird dog's truncated primary legend, judgement-call fractions with no EMG for the hollow,
Ekstrom 2007 and Callaghan 1998 read as abstracts only, the model's bent bird-dog reaching arm and
13° hollow legs (the copy follows the model).
