# 401-500 folder, round 3: RKC, weighted, side hip-lift and Copenhagen planks (2026-10-05)

Four plank variations from the builder's 445-474 exports: 454 RKC Plank, 455 Weighted Plank,
456 Side Plank Hip Lift and 457 Copenhagen Plank (models `Abs/<Resource>.usdc`).
`spec_500_plankhold.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_plankhold.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_plankhold.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.
SCRATCH below is `$LAB/r3/plankhold/` (the session scratchpad).

## How the models were read

- The rigs straight from the USD with Blender's Python + pxr: `SCRATCH/rig2.py` (every joint's
  full world transform every frame, `<Resource>_xf.npz`), `skin.py` (the skinned meshes at chosen
  frames via `UsdSkel` skinning, blend shapes ignored), then `prone.py` (plank heights, elbow and
  knee angles, elbows against shoulders, elbow-to-ankle distance), `tilt.py` and `rest.py` (pelvis,
  spine and thigh bones in the pelvis's frame, posed against the bind pose), `profile.py` (the
  midline back and belly surface along the body), `side.py`, `side2.py`, `legs.py` (side planks in
  the lifter's own axes: hip line, shoulder line, side bend, hip abduction and flexion per leg),
  `arm.py` (support elbow against shoulder in the room), `low.py` and `feet.py` (lowest mesh points
  per part, shoes split by the nearer ankle), `misc.py` (widths, the plate), `gate.py` (the
  distance the hip lift's ghosts fade on), `head.py` (head against trunk, posed and bind).
- The motion briefs (`$LAB/r3/briefs*/`), `tiers.txt`, `joints.json` and the trainer stills at
  0/1/2/3/5 s (`$LAB/r3/stills`). The briefs' trunk lean and rep phases were written for upright
  lifts (the static planks show "rep phases" that are only a sub-centimetre sway), so every angle
  and height here was measured from the rig.
- Ghosts: `SCRATCH/ghost.py`, a new Python port of `FaultGhost.solve` (shift, turn, straighten,
  resolve, the strengths, `BodyFrame`, tips) with the trainer projection of `probe.py` and the
  mistake view's turn, 0.935 scale and lift (`USDZViewport`, `roomBelow` 0.26). Its projection
  reproduces `joints.json` to 0.0006. `pieces.py` holds the pieces in Python, `size.py` reports
  joint moves (cm and on-screen pt in the mistake view), bone lengths, knee and elbow angles and
  the lowest ghost point; `gdump.py` + `gdraw.py` draw ghost and real skeletons over the stills.
- Labels: `preview_500.py plankhold` plus `SCRATCH/overlay.py` (pills drawn from their label
  points at ~24 + 6.4 pt per character, the eye button and legend boxed, leaders to the joints
  projected at 0, 1 and 3 s), then the lab shots.
- Sources: Europe PMC REST records (abstracts) for every study; full text of Schoenfeld 2014 (the
  author's copy on bretcontreras.com, text pulled from the PDF's streams), Schaber 2021 and
  Polglass 2019 (Europe PMC full-text XML); ExRx through the Wayback Machine (`SCRATCH/src/exrx_*`:
  Front Plank 2026-01-27, Side Bridge 2021-04-20, Side Plank 2022-02-26, Gluteus Medius 2026-06-24);
  StrengthLog, Bret Contreras and Coach pages fetched directly (`SCRATCH/src/`).

## Shared facts about the models

- One body (neck to pelvis 0.59 m), clips of 7.96 s at 24 fps, a 1.6 x 2.4 m mat (`HG_Mat`, top at
  y 0). The RKC and weighted planks lie face down, head toward +z, framed side-on (yaw -1.35, head
  on the screen's left). The two side planks lie on the RIGHT forearm, head toward +z, the chest
  facing +x, framed from behind (yaw 1.5, head on the right, feet on the left).
- Paint (`tiers.txt`): RKC rectus abdominis bright; anterior deltoid, both obliques, gluteus
  maximus, medius, minimus dim. Weighted: rectus abdominis bright; anterior deltoid, both obliques
  dim. Side hip lift: lateral deltoid, both obliques, gluteus maximus, medius, minimus bright;
  rectus abdominis dim. Copenhagen: adductor longus, adductor magnus, gracilis, lateral deltoid,
  rhomboid major, trapezius upper, middle, lower bright; both obliques and rectus abdominis dim.
- No EMG of the RKC plank as such, of a plate-loaded plank or of a static Copenhagen hold was found
  (Europe PMC searches: RKC / hardstyle plank; plank or prone bridge with load, weight or plate;
  Copenhagen plank, side-lying adduction plank; dynamic side bridge). Schoenfeld 2014's long-lever
  posterior-tilt plank is the RKC plank's mechanics; Serner 2014 and Collings 2026 measured the
  partner-held Copenhagen adduction. They report %MVC or modelled forces, which the app's
  fractions are not, so every fraction is a judgement call anchored on the library's Plank (rectus
  0.78, obliques 0.56, gluteus maximus 0.36), Side Plank (obliques 0.78, gluteus medius 0.46) and
  Cable Hip Adduction (adductor longus 0.85), as each code comment says.
- Three of the four are timed (`ExerciseCatalog.timedExercises` already lists RKC, Weighted and
  Copenhagen Plank); the hip lift is counted in reps.

## RKC Plank

Model facts: still (pelvis height 23.5-24.0 cm all clip). Forearm plank: elbows 113°, the elbow
joints 10.0 cm ahead of the shoulder joints (upper arms 20-21° forward of vertical), 35 cm apart
against shoulders 39 cm; forearms angled 20° in, the fists (on their sides, palms in) almost meeting
in front (fleshed-hand meshes 1.5 cm apart at the midline, under and in front of the face, not
clasped); shoes touching at the midline (ankle joints 10 cm apart), toes tucked; knees 174°;
neck-hip-knee 177°; the trunk line rising 9° toward the head; shoulder joints 32.6 cm, pelvis
23.7 cm, the lowest abdominal point 12.6 cm above the mat. Head tipped 13° back from the trunk
line (bind pose 0.6°), the line of sight landing about at the hands. Elbows to ankles 1.46 m; the Weighted Plank (same rig, elbows under the shoulders) 1.36 m;
the library Plank (older rig) 1.37 m with the elbows under the shoulders, forearms parallel and
ankles 18 cm apart. Pelvic tilt: against the thighs the pelvis sits 1.4° further back than in the
bind pose and 2.5° further back than the Weighted Plank's (thigh in the pelvis frame -167.3°,
-169.8°, bind -168.7°), and the dip of the lower back below a line from the buttocks to the upper
back is 4.6 cm against the Weighted Plank's 4.9 cm. So the model shows no visible posterior tilt;
what sets it apart from the library Plank is the forward, slightly narrower elbows with the hands
together, the feet together and the lower body line (shoulders 3 cm lower than the Weighted Plank).

| Claim | Source |
|---|---|
| Elbows about 10 cm ahead of the shoulders, forearms angled in so the fists almost meet | The model (10.0 cm; forearms 20° in; fists 1.5 cm apart); Schoenfeld 2014 Table I (long lever: elbows 6 in apart at nose level), Contreras 2011 (arms further out, elbows closer). The model's elbows are less far forward than Schoenfeld's and 35 cm apart, much wider than his 6 in (15 cm) and about the Weighted Plank's 34 cm (the library Plank's are 39 cm), so the copy does not claim narrower elbows; it gives the model's set-up |
| Moving the elbows forward lengthens the lever between elbows and toes | Schoenfeld 2014 introduction (elbows further toward the head and closer together increase lever arm length and reduce the base of support) and discussion (increasing the distance between the elbows and toes) |
| EMG: elbows forward and close together raised upper rectus abdominis activity to more than three times a regular plank's | Schoenfeld 2014 Table II: long-lever plank upper rectus 90.47% vs traditional 27.26% MVC (3.3x) |
| The longer lever tended to do more than the pelvic tilt | Schoenfeld 2014 abstract (the long-lever component tends to contribute more than the posterior-tilt component); for the upper rectus itself the long-lever and posterior-tilt planks (90 vs 55% MVC) did not differ significantly, hence tended |
| Mistake: elbows under the shoulders turn it back into a regular plank | Schoenfeld 2014 Table I (the traditional plank: elbows directly below the glenohumeral joint) |
| Squeeze the glutes as hard as you can; tailbone toward the feet, a backward pelvic tilt the abs help hold | Schoenfeld 2014 Table I (gluteals contracted as strongly as possible, pubic bone toward the belly button, tailbone toward the feet) and introduction (the tilt is a force couple of the hip extensors and the rectus abdominis and external oblique); Contreras 2011 (glutes as hard as possible to posteriorly tilt the pelvis) |
| Hips in line with shoulders and heels | The model (neck-hip-knee 177°); the tilt itself is not visible in the model (see above), so the copy asks for it as the squeeze's aim |
| Adding the squeeze to a regular plank more than doubled external oblique activity; with the long lever the hardest plank tested | Schoenfeld 2014 Table II (posterior tilt 110.79 vs 50.21% external oblique, 2.2x) and discussion (the long-lever posterior-tilt plank had the highest means for all muscles, the most difficult variation) |
| Knees locked, thighs tight; legs as one rigid beam | Contreras 2011 (contract the quads to lock out the knees); Coach, Harris-Fry (tense your quads to force your knees up); the beam is mechanics; the model's knees 174° |
| Coaching: tense the quads to lock the knees, clench the glutes as hard as possible | Contreras 2011; Coach, Harris-Fry (clench your glutes as hard as possible) |
| Fists almost meet in front, feet touch; make fists and bring them together | The model (fists on their sides 1.5 cm apart, shoes touching); Coach, Harris-Fry (clench your hands together in front of you); Schoenfeld 2014 Table I (fists on the floor) |
| Hands and feet together shrink the base; the authors of an EMG study of the long-lever plank suggest a smaller base, with the elbows closer, adds to what the longer lever does | Schoenfeld 2014 introduction (elbows closer together reduce the base of support; with the longer lever these factors "conceivably enhance recruitment"); the hands and feet are mechanics (Schoenfeld's subjects kept the feet shoulder-width apart) |
| Pull intro: brace everything hard for a short hold while nothing moves | The model (still); Coach, Harris-Fry (the focus is on whole-body tension) |
| Pull (why and correct): shoulders toward toes and toes toward the head as if to pike, making the glutes work harder to keep the body straight | Coach, Harris-Fry ("squeeze your shoulders towards your toes and toes towards your head as if you're trying to raise your midriff into the pike position", which "increases the stabilizing force required from your glutes") |
| Clench the glutes as soon as you are up | Coach, Harris-Fry (starting from the standard plank position, then clench the glutes); a draft said before you lift, which no source gives |
| Three to five holds of about 10 s, tension before duration | Coach, Harris-Fry (start with three to five planks of around 10 seconds; keeping the tension high is more important than lasting longer) |
| Setup | The model (elbows a hand's width ahead, forearms in, fists together, feet together); Coach's order for the squeeze (up into the plank, then quads and glutes squeezed; Coach also clenches the hands once up, where the setup places the fists before the lift, a set-up choice, not a sourced claim); Contreras 2011 for the quads and glutes |

Activation: Rectus Abdominis 0.92 PRIMARY (bright), Obliques 0.68 and Gluteus Maximus 0.48
SECONDARY (dim). Judgement calls: the rectus well over the library Plank's 0.78 because the
long-lever posterior-tilt plank tripled or quadrupled upper rectus activity against the regular
plank in Schoenfeld 2014 (110 vs 27% MVC); the external oblique reached 149% there, second only to
the lower abdominal site (154%), but it is dim, so a high secondary over the Plank's 0.56; the gluteus maximus is squeezed
as hard as possible but was not measured in what was read, a little over the Plank's 0.36.
Stabilisers: transverse abdominis (Schoenfeld's lower abdominal stabiliser site blends the lower
rectus, transverse abdominis and internal oblique), quadriceps (the locked knees), and the dim
anterior deltoid and gluteus medius (a third secondary row would truncate the legend; the round-2
rule). The minimus, painted with them, is not named.

## Weighted Plank

Model facts: still (pelvis 27.1-27.4 cm). Forearm plank: elbows 93-94°, straight under the
shoulders (0.0 cm ahead, upper arms 5° from vertical, elbows 34 cm apart), forearms parallel
pointing ahead, hands 24 cm apart at their inner edges with the palms facing in; ankles 22 cm apart
(hips 18 cm), toes tucked, knees 174°, neck-hip-knee 179°; shoulders 35.2 cm, pelvis 27.4 cm,
abdomen 16.2 cm off the mat. Head 14° back from the trunk line. The plate (`HG_BackPlate`, disc
32 cm across) lies on the upper back: its centre 14 cm toward the hips from the shoulder-blade
joints and 8 cm toward the head from the chest joint, over the midline, tilted ~21° from level
(about 10° steeper than the back under it); it touches the back around its middle (its lower rim
dips ~3 cm into the mid-back mesh, its upper rim stands ~3 cm clear near the shoulders, a mesh
clip). It does not move.

| Claim | Source |
|---|---|
| One straight line head to heels under the plate; the core has to work harder under the load | StrengthLog Weighted Plank (form and hold a straight line from your head to feet; the core needs to work harder to maintain stability and proper alignment under the greater load); the model (179°) |
| If the hips sag, the lower back bends under the weight | Mechanics, as the library Plank's mistake note |
| Elbows straight under the shoulders, forearms parallel, palms in; ExRx's front plank also sets the elbows under the shoulders | The model; ExRx Front Plank (forearms on mat, elbows under shoulders; it says nothing of the forearms' angle or the palms) |
| Stacked, the upper arms carry the weight straight down | Mechanics |
| Mistake ghost: elbows far in front, the shoulders dropping | The library Plank's elbow cue; the ghost (see Ghosts) |
| Plate flat on the upper back, centred over the spine | The model |
| Centred it presses straight down; off to one side it tips, slides and twists you | Mechanics |
| StrengthLog suggests a partner to set it; ExRx adds weight on the hips or lower back | StrengthLog Weighted Plank (have a training partner to help you position the plate; lie down, place the plate, then push up); ExRx Front Plank (harder with added weight on hips or low back, rarely performed that way) |
| Partner sets the plate before you push up; you lower to the mat before it comes off | StrengthLog's order (lie down, plate on, then push up); taking it off is the same order reversed (a draft had it lifted off before you lower, which is not the reverse) |
| Head the top end of the straight line; close to the trunk's line, tipped up just enough to look at the hands | StrengthLog's straight line from head to feet; the model (head 14° back from the trunk against the bind pose, the line of sight about at the hands; a draft said nearly in line) |
| Straight legs a rigid beam; ExRx lists the quadriceps among the plank's stabilisers | ExRx Front Plank (stabilisers include the quadriceps); mechanics |
| Feet about hip-width, on the toes | The model (ankles 22 cm, hips 18 cm); ExRx puts the legs together, StrengthLog gives no width |

Activation: Rectus Abdominis 0.82 PRIMARY (bright), Obliques 0.60 and Anterior Deltoid 0.36
SECONDARY (dim). Judgement calls: StrengthLog says the core works harder under the plate and ExRx
that added weight makes the plank more challenging, but no EMG was found; the plate here rests close to the elbows (its centre 17 cm from the
elbow line on a ~1.4 m span, so by statics most of its weight goes down the arms, mechanics), so
the rectus is only a little over the library Plank's 0.78 and the obliques a little over its 0.56.
The anterior deltoid holds the upper arm under the extra load (dim; LOW). StrengthLog lists abs
primary and obliques secondary, the same order. Stabilisers: serratus anterior and quadriceps (ExRx
front plank stabilisers, and the library Plank's), transverse abdominis (the library Plank's; ExRx
does not list it), gluteus maximus (a library Plank row, not painted here).

## Side Plank Hip Lift

Model facts: on the RIGHT forearm: elbow 93°, the elbow under the shoulder (0.1° off vertical at the
top, 8° at the bottom), the forearm pointing forward across the body's line, the hand flat on the
mat. The left arm straight (180°) and vertical, the hand ~1.2 m up. Feet staggered, both shoes on
the mat: the top (left) ankle ~30 cm ahead of the bottom one (in the body's axes the left foot
18-32 cm forward of the pelvis, the right -10 to +5 cm). Bottom knee 170° throughout; top knee
146° at the bottom, 167° at the top; top hip flexed ~28°. The pelvis is rolled ~33° toward the
floor (hip line 57° from level) and the shoulder line ~30° less (63° at the bottom, 78° at the top).
The hips lower and lift 11.2 cm (pelvis joint 31.1 -> 42.3 cm). At the bottom the leg line meets
the trunk at ~10° bent toward the floor (the bottom hip adducted 15°; the hip joints' midpoint 4.3 cm
below a line from the shoulder joints' midpoint to the ankles'), the lowest point of the bottom thigh
5.8 cm above the mat (rectus femoris, mid-thigh; the vastus lateralis 7.5 cm) and of the shorts 9.0
cm; at the top ~6° the other way (the bottom hip abducted 1.5°; the hips 6.7 cm above that line): the
hips a little above a straight line. Timing: low 0-0.42 s, up 0.42-1.08 s,
held 1.08-2.38 s, down 2.38-3.17 s, low 3.17-4.42 s, the second rep the same from 4.42 s. Head in
line with the trunk (3°).

| Claim | Source |
|---|---|
| Right forearm on the mat, elbow under the shoulder; forearm pointing forward | The model |
| Stacked, the upper arm carries the body straight down so the trunk does the lifting | Mechanics |
| ExRx sets the forearm under the shoulder, across the line of the body | ExRx Side Bridge and Side Plank (forearm on mat under shoulder perpendicular to body) |
| Hips rise a little above a straight line | The model (+6° at the top; 6.7 cm above the shoulder-to-ankle line) |
| ExRx: hips raised by bending the spine sideways, obliques the target, the bottom hip abducts | ExRx Side Bridge (raise hips upward by lateral flexion of spine; in addition the lower hip abducts and the upper hip adducts; target obliques) |
| Abduction is the gluteus medius's movement | ExRx Gluteus Medius (movement: hip abduction) |
| EMG, nine exercises: the side bridge could be used to strengthen the gluteus medius and external oblique | Ekstrom 2007 abstract |
| Hips lower about 11 cm and stop just above the mat; the bottom thigh about 6 cm off it | The model (11.2 cm; 5.8 cm, the rectus femoris at mid-thigh; a draft said 8 cm from the vastus lateralis alone) |
| Correct: lower until the bottom thigh is a few centimetres above the mat, pause there, then lift again | The model (5.8 cm; the 1.25 s pause at the bottom); a draft said lift straight away, which clashed with the model and the tempo cue |
| Stopping short keeps the obliques working; resting hands the weight to the mat, so the side of the trunk rests too (comparison) | Mechanics; a draft's comparison said each lift starts from a dead stop, which read against the model's own pause at the bottom |
| Hips in line, not pushed back (front to back: the pelvis joint stays over the shoulder joints' line all clip); ExRx describes the lift as a sideways bend of the spine; folding pushes the buttocks back into a forward bend | ExRx Side Bridge (raise hips upward by lateral flexion of spine); the fold is mechanics. A draft added that ExRx keeps the knees and hips straight: it does (set-up), but the model's top knee bends to 146° and its top hip flexes ~28° with the feet staggered, so the copy no longer says so |
| Top foot in front of the bottom one | StrengthLog Side Plank (place the foot of the top leg in front of the other foot); the model |
| Tempo: lift under a second, hold about a second, lower under a second, a pause of about a second near the mat, ~4 s a rep | The model (0.67 s, 1.3 s, 0.8 s, 1.25 s; a 4 s cycle) |
| Setup | The model (right side, forearm forward, top foot in front, left arm up); ExRx and StrengthLog set-ups |

Activation: Obliques 0.82, Gluteus Medius 0.62, Gluteus Maximus 0.42, Lateral Deltoid 0.40 PRIMARY
(bright), Rectus Abdominis 0.30 SECONDARY (dim). Judgement calls: ExRx's target and Ekstrom 2007's
side-bridge finding put the obliques first, a touch over the library Side Plank's 0.78 since the lift
adds side-bending to the hold; the gluteus medius is bright here (a 0.46 secondary in the library's
static side plank) and the bottom hip abducts through the lift (ExRx), 0.62; the gluteus maximus
(ExRx: lower fibres a synergist) and lateral deltoid (ExRx synergist; the support shoulder) have no
values in what was read, low moderate. Gluteus minimus (bright, painted with the medius, unmeasured)
is named with the stabilisers (the bird dog's rule); quadratus lumborum, serratus anterior and the
adductors are ExRx side bridge synergists. The primary legend line has four names and truncates
(the round-1 open point; the rows follow the paint).

## Copenhagen Plank

Model facts: still (no joint moves more than a few millimetres). On the RIGHT forearm: elbow 92°,
the elbow exactly under the shoulder, the forearm pointing forward; the left arm straight and
vertical, the hand ~1.3 m up. Trunk level (0°), hips and shoulders stacked (both lines vertical),
head in line (3°). The bench (`HG_Bench`, top 45 cm, 30 cm deep, 1.1 m long, across the end of the
mat) carries the top (left) leg by the foot and ankle: the left shoe's lowest point on the bench top
(45.1 cm), the ankle joint 50 cm up, the calf clear of the bench edge; top knee 171°, the leg
sloping 9° down from the hip (64 cm) to the bench. The bottom (right) leg hangs straight (knee 180°)
21° off the body's line toward the floor, under the bench, its shoe 3.5 cm above the mat; it touches
neither floor nor bench. Pelvis joint 54.6 cm up.

| Claim | Source |
|---|---|
| Top leg on the bench at the ankle, knee straight, holds you up; a long lever | The model; Polglass 2019 (long lever: the foot the contact point; short lever: the knee) |
| Its adductors hold the pelvis up by pressing that leg down into the bench | Schaber 2021 (the CAE's raise is pelvic-on-femoral concentric adduction of the supported leg); ExRx Side Bridge (upper hip adducts) |
| Modelling study driven by EMG: long-lever Copenhagen in the top tier for every adductor modelled (longus, magnus, gracilis among them) of eight exercises | Collings 2026 abstract (EMG-assisted neuromusculoskeletal model; eight exercises; Copenhagen long lever tier 1 for all adductor muscles: brevis, longus, magnus, gracilis) |
| Mistake: the knee on the bench is the easier short-lever hold; use it if this is too hard | Polglass 2019 (levels 1-2 short lever, knee on the box; levels 3-4 long lever, foot on it) |
| Hips up, level with the shoulders, body straight to the bench | The model (trunk level, hips 64/46 cm stacked) |
| The top leg's adductors and the side of the trunk carry the body | StrengthLog Copenhagen Plank (adductors primary; abs, obliques secondary); mechanics |
| EMG: the Copenhagen adduction drove adductor longus as high as any of eight adduction exercises | Serner 2014 abstract (eight exercises, adductor longus 14-108% nEMG; the Copenhagen adduction a high-intensity exercise); Schaber 2021 full text (the CAE and the ball squeeze between the knees produced 108%) |
| Programmes built on it raised adductor strength and cut groin problems in football players | Ishøi 2016 (eccentric hip adduction strength +35.7% in U-19 players); Harøy 2019 (41% lower risk of groin problems in male football players) |
| Body in a straight line, the bottom leg hanging under the bench | StrengthLog Copenhagen Plank (body forms a straight line; bottom leg off the ground, hanging under the bench or lightly touching it); the model |
| Pushing the hips back bends the body at the waist | Mechanics |
| Elbow under the shoulder | StrengthLog (forearm on the floor directly below your shoulder); the model |
| The support shoulder carries the upper body; pushing the floor away keeps the shoulder blade set | Mechanics |
| ExRx lists the lateral deltoid and middle and lower trapezius among the side bridge's synergists | ExRx Side Bridge (synergists: deltoid lateral, supraspinatus, trapezius middle and lower, serratus anterior) |
| Setup: bench at the end of the mat, right side, foot and ankle on the bench, hips up, bottom leg hanging, top arm up | The model; StrengthLog's steps |

Activation: Adductors 0.90, Lateral Deltoid 0.46, Trapezius 0.42 PRIMARY (bright), Obliques 0.52 and
Rectus Abdominis 0.30 SECONDARY (dim). "Adductors" is one row for the three painted adductor meshes
(adductor longus, adductor magnus, gracilis; ExRx lists the gracilis among the hip adductors) and is
the library row's muscle; Serner 2014 and Collings 2026 put the Copenhagen at the top for them, so
over the library Cable Hip Adduction's 0.85. The lateral deltoid and trapezius (ExRx side bridge
synergists, the support shoulder) have no value in what was read: low moderate. The bright rhomboid
is named with the stabilisers (ExRx's side bridge lists the trapezius, not the rhomboids, and a
fourth primary would truncate the legend further). Obliques dim: a side plank's target, but the
adductors hold the hips here; rectus abdominis LOW (Serner: abdominals 5-48% nEMG across the
adduction exercises). Stabilisers: rhomboids, gluteus medius, quadratus lumborum, serratus anterior.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`); label points
are the pills' inner edges. Checked with `SCRATCH/overlay.py` on the stills at 0, 1 and 3 s and the
lab shots.

- RKC Plank: glutes (pelvis) 0.20 left and legs (near knee) 0.20 right; pull (chest) 0.30 left, its
  pill ending at x 0.42, left of the glutes leader (x 0.45 at that row); lever (near elbow) 0.72
  left and base (near ankle) 0.72 right, rising from below the mat. A first layout with the pull
  pill at 0.80 below crossed the lever leader.
- Weighted Plank: head (head) 0.22 left and plate (chest, under the plate) 0.22 right, both leaders
  running down-left; elbows (near elbow) 0.72 left, legs (near knee) 0.72 right with a shorter
  label (Knees straight, on toes), and body (pelvis) 0.80 right, its leader rising left of the legs
  pill (x 0.53 at that row against the pill's 0.565). A first layout with the head pill at 0.80
  crossed the elbows pill; in lab round 1 the body pill sat at 0.80 left and its leader grazed the
  end of the elbows pill.
- Side Plank Hip Lift: the raised left hand reaches v ~0.32 (fingertips) in the trainer view and
  ~0.23 in the lifted mistake view, so the only right-hand pill above is at 0.16: line (spine),
  its leader running down-left of the arm. Lift (pelvis) 0.22 left. Below the mat (the mat's front
  edge at ~0.72): dip (bottom hip) 0.74 left, elbow (support elbow) 0.74 right, tempo (chest) 0.80
  left, its leader rising between the dip leader and the elbow pill (x 0.48 at 0.74). In lab
  round 1 the tempo pill sat at 0.80 right and its leader grazed the end of the elbow pill.
- Copenhagen Plank: top (the foot on the bench) 0.22 left, its leader running down-left to the
  bench; hips (pelvis) 0.16 right, left of the raised arm; line (bottom hip) 0.74 left, its leader
  passing under the hanging leg; elbow 0.74 right; shoulder (support shoulder) 0.80 left, its long
  leader rising right of the line leader and left of the elbow pill and support forearm. A first
  layout with the top and hips pills both top left crossed their leaders, and with the shoulder
  pill top right crossed the hips leader near the raised arm.

## Ghosts

Measured with the port at the fault's still; distances are joint moves, pt are on-screen moves in
the mistake view. Face down the lifter's forward is the floor and `ahead` is toward the head; on the
right forearm the lifter's left is the ceiling, so moves toward the floor use `rise`.

- RKC Plank (still 2.0 s): lever `plankHold500ElbowsSlid(-0.17, rise: 0.03)` (forearms and hands
  10 cm toward the feet along the floor, 16 pt; the shoulders 1.8 cm higher so the upper arm keeps
  its 28.7 cm; elbows 113° -> 93°, the Weighted Plank's set-up); glutes `plankHold500HipsSag(0.22)`
  (hips 13.0 cm toward the floor, 20 pt, mid-spine 6.5, knees 5.8 cm; lab round 1's 0.18, 10.6 cm,
  read as a slight bend); legs `plankHold500KneesSoft(0.12)` (knees
  7.1 cm toward the floor, 174° -> 159°, hips 2.8 cm; shins +1.7 cm, as the library Plank's feet
  ghost stretches); base `plankHold500FeetApart(12, view: -1.5)` (each leg 12° out, the ankles
  17.5 cm out each, ~29 pt, seen from behind the feet). Pull has no ghost.
- Weighted Plank (2.0 s): body `plankHold500HipsSag(0.2)` (hips 11.8 cm, 18 pt); elbows
  `plankHold500ElbowsSlid(0.2, rise: -0.04)` (forearms and hands 11.8 cm toward the head, 19 pt,
  shoulders 2.4 cm lower; elbows 93° -> 118°); head `plankHold500HeadDropped(50)` (the head 8.5 cm,
  the crown point 18.5 cm toward the floor, 29 pt); legs `plankHold500KneesSoft(0.12)`
  (as the RKC). Plate has no ghost.
- Side Plank Hip Lift: lift `plankHold500HipsLowered(0.17, strength: plankHold500Top)` (still 1.6 s;
  the hips 10.1 cm lower, back to the bottom of the dip, 16 pt; top knee 167° -> 140°, bottom
  170° -> 150°, re-seated over the planted feet); dip `plankHold500HipsLowered(0.18, strength:
  plankHold500Bottom)` (still 3.7 s; the hips 10.7 cm lower, 17 pt, the side of the bottom hip, the
  shorts 9 cm up, to about the mat; bottom knee 170° -> 158°, top 146° -> 132°; the draft's 0.13,
  7.7 cm and 12 pt, assumed the vastus lateralis's 7.5 cm went to the mat, but the re-seated bottom
  knee rises ~1.5 cm, which left the hip ~3 cm up in the review's estimate); the strengths read the pelvis-to-right-hand distance (1.07 torso lengths
  with the hips down, 1.20 at the top; `Top` full from 1.18, none below 1.12; `Bottom` full at 1.09,
  none above 1.12), so neither ghost shows at the other end (checked: 0 at 0.1 s and 1.6 s
  respectively); elbow `armsTurned(.forward, 25, side: "R")` (the elbow 10.9 cm toward the head,
  17 pt, ~2 cm off the mat; a negative turn would move it toward the feet; lab round 1's 20° barely
  parted from the real arm); line `plankHold500Piked(back: 0.28, down: 0.16, view: -0.6)` (the
  pelvis 19.1 cm, 30 pt: ~16.5 cm behind the line and ~9.5 cm toward the feet; top knee 167° ->
  165°, bottom 170° -> 133°; seen three-quarter from the head side). The pike was first a pure
  backward shift: the top foot is planted 30 cm forward, so the top leg ran out of reach (knee
  forced to 180°, thigh +1.4 cm); moving the hips toward the feet as well keeps both legs' lengths.
  Views from -1.4 to +1.4 were compared; lab round 1 used (0.2, 0.1, -1.0), where the turned body
  foreshortened until the pike did not read. The lower trunk's two segments stretch (pelvis to
  chest 27 -> 39 cm), as the library Side Plank's shifted pike does on a smaller scale; sliding the
  chest and head toward the feet too cut that to 30 cm in the review's port but pulled the ghost neck
  off the shoulders, so it was left. Tempo has none.
- Copenhagen Plank (2.0 s): hips `plankHold500BenchSag(0.15, adduct: 5)` (pelvis, hips and hanging
  leg 8.9 cm lower, 14 pt; top knee 171° -> 160° over the foot on the bench; the bottom leg turned
  5° up so its ankle stays at 13 cm and its shoe ~1.5 cm off the mat; 0 degrees put it through the
  mat); line `plankHold500BenchPiked(back: 0.28, down: 0.06, view: -0.6)` (pelvis and hanging leg
  17.0 cm, 21 pt: ~16.6 cm behind the line, ~3.7 cm toward the bench; top knee 171° -> 154°; the
  lower trunk 27 -> 34 cm; round 1: 0.2 at -1.0); elbow `armsTurned(.forward, 25, side: "R")` (the elbow 12.5 cm toward the head,
  19 pt, ~3 cm off the mat; round 1: 20°); shoulder `plankHold500ShoulderSunk(0.15)` (chest, neck
  and head 8.9 cm lower, 14 pt, the support shoulder left over the elbow so the neck closes on it,
  20.7 -> 12.7 cm; drawn as the spine and the support side's neck-shoulder-elbow line). Rounds 1
  and 2 also lowered the top shoulder and raised arm (0.14, then 0.18); the arm slid down along
  itself and hid the change. Top has no ghost.
- Bone lengths: the turns and re-seated knees keep them; the face-down sag and soft-knee pieces
  shift joints as the library's `hipsSagging` and Plank feet ghost do (shins +1-2 cm; the sags also
  stretch the lower trunk, pelvis to chest 27 -> 32 cm at 0.22); the elbow
  slides keep the upper arm within 0.2 cm by moving the shoulders. No knee or elbow bends backward:
  every knee change is a re-seat (`resolve`) or a shift toward the side it flexes (checked in the
  port).

## Uncertain

- No EMG of the RKC plank as such, of a plate-loaded plank or of a static Copenhagen hold; the
  fractions are judgement calls (above).
- The RKC model shows no visible posterior pelvic tilt (1.4° against the bind pose, 2.5° against
  the Weighted Plank); the copy asks for the squeeze and tilt as coaching does, and describes the
  visible result as a straight body with no sag. Its elbows are 10 cm forward and 35 cm apart,
  less far and wider than Schoenfeld's long lever (nose level, 6 in apart).
- The weighted plank's plate sits on the upper back, where ExRx loads the hips or lower back; the
  copy follows the model and names ExRx's alternative. The plate's lower rim clips ~3 cm into the
  back mesh.
- The side hip lift's pelvis is rolled ~33° toward the floor and the feet are staggered; ExRx's side
  bridge stacks the legs (StrengthLog staggers them). The copy follows the model and makes no
  stacked-hips claim.
- Serner 2014, Collings 2026, Ishøi 2016 and Harøy 2019 measured the dynamic, partner-held
  Copenhagen adduction, not a static bench hold; the copy says "the Copenhagen adduction" or "the
  long-lever Copenhagen exercise" for their findings. Serner's 108% is read from Schaber 2021's full
  text (the abstract gives the 14-108% range only).
- The four-name primary legend of the side hip lift truncates after GLUTEUS MAXIMU (the round-1
  open point); the Copenhagen plank's three names fit (lab shots).

## Change log

- 2026-10-05, draft: models measured, sources read, copy, setup, ghosts and moments for all four;
  `spec_500.py plankhold` OK; `family.sh check plankhold` BUILD SUCCEEDED on the first build.
- Lab round 1 (`family.sh shoot plankhold "0,1.5,3.7"`, kept in `SCRATCH/round1/`): BUILD SUCCEEDED,
  the app ran; every trainer still had its pills off the lifter and moving parts. Fixed: the
  weighted plank's body leader and the hip lift's tempo leader grazed the ends of the pills beside
  them (both pills moved, see Labels); the RKC glutes ghost read as a slight bend (0.18 -> 0.22);
  both side-plank elbow ghosts barely parted from the real arm (20° -> 25°); the Copenhagen shoulder
  ghost was too small (0.14 -> 0.18); both pike ghosts at a turn of -1.0 foreshortened the body
  until the pike did not read (now -0.6 with a larger pike). The RKC lever, legs and base, the
  weighted plank's body, elbows, head and legs, the hip lift's lift and dip and the Copenhagen hips
  ghosts read as named and were kept. The hip lift's primary legend truncates after GLUTEUS MAXIMU
  (four bright muscles), as expected.
- Lab round 2 (kept in `SCRATCH/round2/`): the two moved leaders are clear of the pills beside them
  (zoomed); the RKC glutes sag reads; both elbow ghosts now slant the upper arm toward the head; both
  pikes read as the hips displaced behind the line in the three-quarter view. Left: the Copenhagen
  shoulder ghost, whose lowered raised arm overlaid the real one; rewritten without the arm (above).
- Lab round 3 (`family.sh shoot plankhold "0,1.5,3.7" "Copenhagen Plank"`, kept in
  `SCRATCH/round3/`): BUILD SUCCEEDED; the new shoulder ghost reads as the upper trunk sagging onto
  the support arm, the neck closing on the support shoulder; the other Copenhagen screens as in
  round 2. Final state: every trainer still has its pills off the lifter and the moving limbs with
  clear leaders, and every ghost is attached, above the mat and shows its named mistake. Open: the
  hip lift's truncated primary legend.

## Review (2026-10-05)

An independent sources and model review of the four files, round 3 of the 401-500 batch. Working
files are in `SCRATCH/review/` (the four files as they stood before the review in
`SCRATCH/review/before/`, the lab output in `SCRATCH/review/lab1/`).

- Sources reopened, not from the author's copies: the eight Europe PMC records (Schoenfeld 2014,
  Ekstrom 2007, Serner 2014, Schaber 2021, Collings 2026, Ishøi 2016, Harøy 2019, Polglass 2019;
  authors, year, journal, volume, issue, pages, DOI and PMID all match the header) and the PubMed
  abstracts of Serner, Ishøi, Polglass and Schoenfeld; full text of Schoenfeld 2014 (the PDF on
  bretcontreras.com: Table I set-ups, Table II means, the introduction's lever and base, the
  discussion's ranking), Schaber 2021 and Polglass 2019 (Europe PMC XML: the 108% for the CAE and
  the ball squeeze between the knees, the CAE defined as partner-held; levels 1-5, the 30 cm box, the
  knee then the foot as the contact point, the box at hip height); Contreras 2011, Coach,
  StrengthLog Weighted Plank, Side Plank and Copenhagen Plank fetched fresh; ExRx Front Plank, Side
  Bridge, Side Plank and Gluteus Medius at the cited Wayback snapshots. Every other quote and number
  in the copy is on the page it is attributed to.
- Changed, sources: the Coach page was first published 2017-02-17 and updated 2023-05-17 (the header
  said 2023 only), and it has the shoulders, not the elbows, squeezed toward the toes; the header
  and the pull cue's correct line now say so (the line had read pull your elbows and toes toward
  each other). The RKC activation comment and notes called the external oblique (149%) the most
  active muscle of the long-lever posterior-tilt plank; Schoenfeld's lower abdominal site was higher
  (154%), so it is now second only to that site. The weighted plank's stabiliser note credited the
  transverse abdominis to ExRx, which does not list it; it is the library Plank's. ExRx's side bridge
  synergist list in the header is completed (it lists the quadratus lumborum the hip lift names in
  its stabilisers, and tensor fasciae latae, psoas and iliocostalis).
- Changed, copy: RKC glutes intro, hips level with the shoulders and heels -> in line with them (the
  shoulder joints sit 9 cm above the pelvis's); glutes and base why no longer lean on the same EMG
  study or the study's authors, which a card read on its own cannot resolve; glutes correct and the
  fourth setup step put the squeeze once you are up, Coach's order (they said before you lift,
  which no source gives); the pull intro no longer repeats its correct line. Weighted plank: the
  plate correct had a partner lift it off before you lower, which is not the reverse of StrengthLog's
  order; now you lower to the mat before it comes off; the head why said the head stays nearly in
  line with the trunk while the model has it ~14° back, now close to the trunk's line, tipped up just
  enough to look at the hands. Side plank hip lift: the dip why said the bottom thigh stays about
  8 cm off the mat (the vastus lateralis alone); the thigh's lowest point is the rectus femoris at
  mid-thigh, 5.8 cm, so about 6 cm; the dip correct said lift straight away, against the model's
  1.25 s pause at the bottom and the tempo cue, and now says pause there, then lift again; the line
  why said ExRx keeps the knees and hips straight, true of ExRx's stacked set-up but not of this
  model (top knee 146-167°, top hip flexed ~28°), so it now names only ExRx's sideways bend of the
  spine; the comparison's mistake note no longer says each lift starts from a dead stop, which read
  against the model's own pause.
- Model checked with my own scripts straight from the USD (`SCRATCH/review/dump.py` joints every
  frame, `skin.py` skinned meshes, `m1.py`, `m2.py`): RKC elbows 112.7°, 10.0 cm ahead of the
  shoulders, 35.0 cm apart (shoulders 39.2), wrists 17.9 cm apart with the hand meshes 1.5 cm apart,
  ankles 10 cm apart with the shoes touching, knees 174°, neck-hip-knee 177°, shoulders 32.6 and
  pelvis 23.7 cm, rectus abdominis 12.6 cm off the mat, elbows to ankles 1.454 m, no joint moving
  more than 5.5 mm; weighted elbows 93.5° straight under the shoulders, 34 cm apart, hands 24 cm,
  ankles 22 cm, knees 174°, 179°, abdomen 16.2 cm, elbows to ankles 1.354 m, the plate disc 32 cm
  across, its centre 14 cm toward the hips from the shoulder-blade joints and 8 cm toward the head
  from the chest joint, tilted 21.0°; hip lift on the right forearm (elbow 93°), left arm up (hand
  1.24-1.27 m), the left ankle 30 cm in front, bottom knee 170°, top knee 146-167°, pelvis
  31.1-42.3 cm, up 0.42-1.08 s, held to 2.38 s, down by 3.17 s, the second rep from 4.42 s, the hip
  joints 4.3 cm below the shoulder-to-ankle line at the bottom and 6.7 cm above it at the top;
  Copenhagen on the right forearm (elbow 92°), the left shoe on the bench at 45.1 cm, top knee 171°,
  the bottom knee 180° and its shoe 3.5 cm off the mat under the bench, hips stacked (64 over 46 cm),
  trunk level. Every other model number in the copy and notes matches; only the bottom thigh height
  was wrong (above).
- Changed, ghost: the hip lift's dip ghost (`plankHold500HipsLowered`, 0.13 -> 0.18). The draft sized
  it so the vastus lateralis's 7.5 cm went to the mat, but the re-seated bottom knee rises ~1.5 cm as
  the hips drop, and the review's estimate (the thigh mesh carried with the hip and knee,
  `SCRATCH/review/diplow.py`) left the side of the hip ~3 cm up; 0.18 (10.7 cm, 17 pt, bottom knee
  170° -> 158°) brings it to about the mat. Its gating was re-checked (full at 0.1 and 3.7 s, none at
  1.6 s; the lift ghost the reverse).
- Ghosts re-solved with the author's port of `FaultGhost.solve` (`ghost.py`, checked line by line
  against FaultGhost.swift) and my own copies of the 12 pieces as written in the Swift
  (`SCRATCH/review/gcheck.py`): every size in the comments matches within a centimetre except three
  comment fixes: the RKC lever ghost closes the elbows from 113° to 93° (said open), the weighted
  head ghost's crown point goes 18.5 cm down, not down and back, and the hip lift's elbow ghost lifts
  the elbow ~2 cm, not ~3. No knee or elbow bends backward. The shifted pikes stretch the lower
  trunk (27 -> 39 cm on the hip lift, 27 -> 34 cm on the Copenhagen plank), as the library Side
  Plank's pike does on a smaller scale; a variant sliding the chest and head toward the feet cut the
  hip lift's to 30 cm but pulled the ghost neck off the shoulders in a projected sketch
  (`pikealt.py`), so the comments now record the stretch and the ghost stays.
- Labels and glows: unchanged; every trainer still (0, 1.5, 3.7 s) and mistake view re-checked on
  the lab shots: pills off the lifter and the bench, leaders clear of the other pills.
- Lab (`family.sh shoot plankhold "0,1.5,3.7"`, copy in `SCRATCH/review/lab1/`): BUILD SUCCEEDED,
  the app ran; all 12 trainer stills and 16 ghosts as in the author's rounds 2-3 except the dip
  ghost, whose hip now sits on the lower edge of the body, ~5 pt lower than before. Every ghost is
  attached, above the mat and shows its named mistake; the dip and the two pikes remain the least
  striking.
- Left open, as the author reported: the hip lift's truncated primary legend (removing the lateral
  deltoid would still not fit GLUTEUS MAXIMUS: 43 characters against the 41 that show), the RKC
  model's invisible pelvic tilt and wide elbows, the weighted plate on the upper back and its ~3 cm
  mesh clip, the rolled pelvis of the hip lift, every activation fraction a judgement call with no
  EMG for these exact holds, and Ekstrom 2007, Collings 2026, Ishøi 2016 and Harøy 2019 read as
  abstracts only.

## Verification (2026-10-05)

A claim-by-claim skeptic pass over the copy, setup steps, activation comments and these tables, after
the review. Working files in `SCRATCH/skeptic/` (the four files as they stood before it, fresh
source copies in `SCRATCH/skeptic/src/`, my own rig scripts `dump.py`, `skin.py`, `meas.py`,
`plot.py`).

- Sources reopened fresh, not from the author's or reviewer's copies: the eight Europe PMC records
  (citations, populations and abstract numbers all match: Schoenfeld 19 trained men; Ekstrom 30
  adults, nine exercises; Serner 40 elite players, 14-108%, gluteals and abdominals 5-48%; Collings
  15 participants, long lever tier 1 for all adductors; Ishøi +35.7%; Harøy 41%); Schoenfeld 2014
  full text (the PDF on bretcontreras.com: Table I set-ups, Table II means, the introduction's lever,
  base and "conceivably enhance", the discussion's ranking and the lever's "tended to" effect);
  Schaber 2021 and Polglass 2019 full text (Europe PMC XML: the 108% for the CAE with the ball
  squeeze between the knees, the partner-held CAE; levels 1-5 isometric, 20 s, knee then foot on a
  30 cm box, the box at hip height); Coach (published 2017-02-17, updated 2023-05-17), Contreras
  2011, StrengthLog Weighted Plank, Side Plank, Copenhagen Plank and Plank fetched again; ExRx Front
  Plank, Side Bridge, Side Plank and Gluteus Medius at the cited Wayback snapshots.
- Rig re-measured with my own scripts from the USD (joints every frame, skinned meshes): RKC elbows
  112.7°, 10.0 cm ahead, 35.0 cm apart, wrists 17.9 cm, ankles 10.0 cm, shoes touching, knees 174°,
  177°, pelvis 23.7 cm, rectus abdominis 12.6 cm, no joint moving more than 5.4 mm; weighted elbows
  93.5° under the shoulders, 34 cm, ankles 22 cm, 179°, the plate 32 cm across, centred on the
  midline, 14 cm hipward of the shoulder-blade joints, 8 cm headward of the chest joint, tilted 21°;
  hip lift on the right forearm (92.5°, hand 25 cm forward of the elbow), left arm 180°, the left
  ankle 30 cm in front, bottom knee 170°, top knee 146-167°, pelvis 31.1-42.3 cm, up 0.42-1.08 s,
  top to ~2.35 s, down to 3.17 s, bottom to 4.42 s, the bottom thigh's lowest point 5.8 cm (rectus
  femoris), the hips ~4 cm below and ~8 cm above the shoulder-to-ankle line in height; Copenhagen
  on the right forearm (92°), trunk level, top knee 171°, bottom knee 180° and 21° off the line, the
  left shoe on the bench top (45.1 cm) with the ankle joint over the bench and the calf 2.4 cm clear
  of it, the bottom shoe 3.5 cm off the mat under the bench. The ghost sizes in the TABLE comments
  reproduce with the review's port (dip at 0.18).
- Refuted and fixed, model: the RKC copy said the hands clasp (setup step 2, the base correct and
  why) and meet (the lever and base intros). The model's hands are two fists on their sides, palms
  in, 1.5 cm apart, not clasped; Coach says clench your hands together and Schoenfeld's planks are
  on fists. Now the fists almost meet, and the correct line and setup say make fists and bring them
  together. Header and notes updated.
- Refuted and fixed, sources: the RKC lever why said the longer lever did more than the tilt;
  Schoenfeld's abstract says it tends to, and for the upper rectus itself the long-lever and
  posterior-tilt planks did not differ significantly, so now tended to (and in the header). The
  weighted elbows why said ExRx sets up the front plank the same way as the model (elbows under the
  shoulders, forearms parallel, palms in); ExRx gives only the elbows under the shoulders, so it now
  says that. The weighted activation comment and notes said StrengthLog and ExRx say the added weight
  makes the abs (core) work harder; ExRx says only that it makes the plank more challenging, so each
  is now quoted for what it says. The hip lift activation comment said Ekstrom found the side bridge
  enough to strengthen the external oblique and gluteus medius; the abstract says it could be used
  for strengthening them, now its wording.
- Softened, copy: the RKC comparison's mistake note said the hold turns into a slack regular plank
  (with the elbows still forward it is not the regular plank), now the hold goes slack. The hip lift
  line why said the work of the exercise is the sideways bend of the spine; ExRx also has the bottom
  hip abducting, so it now says ExRx describes the lift as a sideways bend of the spine. The hip lift
  line intro said the hips stay in line with the shoulders and feet as they rise and fall, which
  reads against the model's hips 4 cm below and 7-8 cm above that line; it now says not pushed back
  (front to back the pelvis stays on the shoulders' line all clip). The Copenhagen top why said the
  adductors lift the pelvis, of a still hold; now hold the pelvis up by pressing that leg down into the
  bench. The notes' setup row said the RKC setup follows Coach's order; it does for the squeeze only
  (Coach clenches the hands once up, the setup sets the fists first).
- Checked and kept: every other number and attribution in the copy, comments and these tables
  (Schoenfeld 3.3x upper rectus, 2.2x external oblique with the tilt, the hardest plank; Coach's
  shoulders toward the toes, the glutes' stabilising force, three to five holds of about 10 s,
  tension over duration; Contreras's quads and glutes; StrengthLog's straight line, partner and
  order, top foot in front, forearm below the shoulder, bottom leg under the bench; ExRx's front plank
  stabilisers, added weight on the hips or low back, side bridge set-up, lateral flexion, lower hip
  abducting, target and synergists, gluteus medius abduction; Serner, Collings, Ishøi, Harøy,
  Polglass and Schaber as cited; the hip lift tempo and the 11 cm, about 6 cm, about 10 cm and
  hand's width figures).
- Labels, cue ids, tracked joints, glows and ghosts unchanged; text-only edits, so no lab run.
  `python3 spec_500.py plankhold` prints OK (4 exercises).
- Still open: as the review lists (truncated hip lift legend, no EMG for these exact holds, the RKC
  model's invisible tilt and wide elbows, the plate on the upper back, the rolled hip-lift pelvis).
  The face-down soft-knee ghosts put the foot tip 2-7 mm under the mat top in the port (shin
  stretched ~1.5 cm, as the library Plank's feet ghost); not changed.
