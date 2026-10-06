# 401-500 folder, round 3: moving planks (2026-10-05)

Four planks that move, from the builder's 445-474 exports: 450 Mountain Climber, 451 Plank Shoulder
Tap, 452 Plank Hip Dip and 453 Plank Knee to Elbow (models `Abs/<Resource>.usdc`).
`spec_500_plankdyn.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_plankdyn.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_plankdyn.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The rigs straight from the USD with Blender's Python + pxr (`SCRATCH/plankdyn/`, SCRATCH = the
  lab's `r3` folder): `rig.py` dumps every joint (position and bone axis) every frame; `an.py`,
  `mc.py`, `twist.py`, `bend.py` and `k2e.py` give the timelines (pelvis and hip heights, the hip
  line's tilt, knee, hip and elbow angles, the hips' height against the shoulder-to-ankle line, the
  twist and side bend of the hips against the shoulders, hand and knee positions); `skin.py` skins
  the muscle, hand and shoe meshes with UsdSkel and `mesh1.py` measures skin gaps and heights above
  the mat (the mat, `Cube`, has its top at y 0).
- The motion briefs (`SCRATCH/briefs/<Resource>.md`, `briefs_legs/`), `tiers.txt`, `joints.json`
  and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`). The briefs were written for upright
  lifts; for these planks the hip height against the body line, the hip roll and twist, which limb
  moves when, and the skin gaps were measured from the rig.
- Ghosts: `ghost.py`, a Python port of `FaultGhost.solve` (BodyFrame, shifts, turns with the
  `_R` mirroring, `resolve`, the `_bent` / `_straight` sides and the strength gates) with these
  framings; its projection reproduces `joints.json` to 0.0005 (0.005 on the mountain climber's
  fast feet). `pieces.py` mirrors the Swift pieces; `sweep.py` solves every ghost at its still and
  over the whole clip (lowest moved joint, every drawn bone's length, bend direction of every moved
  knee and elbow).
- Labels: `preview_500.py plankdyn` plus `overlay.py` (pills and leaders drawn over the reference
  stills with each tracked joint projected at that moment), then the lab shots
  (`family.sh shoot plankdyn`).
- Sources: Europe PMC REST records for every study, the PMC full texts of Cugliari 2017 and
  Heredia 2024 (`SCRATCH/plankdyn/src/`); the ACE, NASM, StrengthLog and Motra pages fetched
  directly; ExRx through the Wayback Machine.

## Shared facts about the models

- One body (torso, neck to pelvis, 0.59 m), clips of 7.96 s at 24 fps, a 1.6 x 2.4 m mat, no
  other equipment. All four are framed three-quarter from the front-left (yaw -0.8, the hip dip
  -0.6), the head on the screen's left, the lifter's left side nearer the camera.
- Paint (`tiers.json`): Mountain Climber RectusAbdominis, Sartorius bright; DeltoidAnterior,
  ExternalOblique, InternalOblique, TricepsBrachii (three heads) dim. Shoulder Tap
  RectusAbdominis bright; DeltoidAnterior, the obliques, the triceps dim. Hip Dip ExternalOblique,
  InternalOblique, RectusAbdominis bright; nothing dim. Knee to Elbow the obliques and
  RectusAbdominis bright; DeltoidAnterior, Sartorius, the triceps dim. Rows follow the paint
  (bright = PRIMARY, dim = SECONDARY); "Hip Flexors" for the sartorius (legend-only, as the
  library's Abs content and the brief say). The hip dip has no secondary row because nothing is
  painted dim.
- Legend width: the secondary line truncates past ~38 characters (round 2: OBLIQUES · HIP FLEXORS
  · POSTERIOR DELTOID, 42, was cut). Three dim muscles would read OBLIQUES · TRICEPS BRACHII ·
  ANTERIOR DELTOID (45), so on each lift one of the two arm muscles is named with the stabilisers
  instead (see each exercise).
- No EMG study of any of the four as the models do them was found (Europe PMC searches for
  mountain climber, shoulder tap(s), hip dip, rainbow, rotating or rotary planks, spiderman and
  knee-to-elbow planks, knee tuck / knee-up with EMG terms; the one 2022 study a web search offered,
  Mandroukas et al. in J Funct Morphol Kinesiol, carries an expression of concern and covers none of
  them). The closest measured drills are the suspended knee-tuck (Cugliari 2017) and the Power Wheel
  and Swiss-ball knee-ups (Escamilla 2006 and 2010, as Cugliari quotes them). Every fraction is a
  judgement call anchored on the library's nearest lifts (Plank 0.78 / 0.56, Hanging Knee Raise 0.80
  / 0.76, Side Plank 0.78, Russian Twist 0.76, Bicycle Crunch 0.84, Dead Bug 0.68 / 0.40), said in
  the spec's code comments.
- The shoulder tap's and hip dip's sides are read through the knees (the app's `bentSide`): in the
  tap the supporting side's knee bends ~2° more than the tapping side's while a hand is up (171.7 vs
  174.1°), and in the hip dip the lowered hip's knee bends more (163.8 vs 166.7° at the right dip;
  0.8° at the left). Checked every frame (`ghost.py`): in the tap the supporting side is always
  `_bent` while a hand is up; in the hip dip the lowered hip is `_bent` everywhere except 2.08-2.33
  and 3.67-3.92 s (the start and end of the left dip, under 6 cm of hip difference), where the gate
  reads the wrong pair and hides the ghost.

## Mountain Climber

Model facts: high plank, hands flat under the shoulders (wrist joints 36.8 cm apart, shoulder
joints 39.2 cm, the hands 0-1.4 cm ahead of the shoulders), elbows 174-177° all clip, ankles 22 cm
apart (hip joints 18 cm). The hips sit 3.6-8.9 cm above the straight line from the shoulders to the
back ankle (hip angle on the back leg 158-167°), the trunk 6-12° above level. One swap every 2 s:
the legs swap together in ~0.6 s (0.12-0.75 s; both shoes 4.5 cm off the mat at 0.5 s), then the
front knee is drawn a little further in (knee 66 -> 54°, hip 82 -> 58°) while the pelvis sinks
5 cm (0.505 -> 0.451 m at 1.4 s) and rises again by 2.0 s. The right knee is in at 0 s, the left
0.75-2.0 s, the right 2.75-4.0 s, and so on. The driving knee ends under the chest (0.9-1.9 s:
knee joint 23-31 cm ahead of the hip joints, level with the chest joint within 6 cm, 20-30 cm behind
the hands, 12-13.5 cm up; its lowest skin 5.4 cm above the mat), the thigh touching the belly; its shoe hovers 2.5 cm
off the mat (it never lands). The back leg goes straight (knee 171°), toes on the mat.

| Claim | Source |
|---|---|
| Each knee drives in under the chest in turn, the foot just off the mat | The model (knee level with the chest joint; shoe 2.5 cm up). ACE puts the front foot on the floor, heel slightly lifted; the copy follows the model |
| Drawing the knee in is hip flexion, the hip flexors' job | ExRx Iliopsoas (hip flexion); ExRx Suspended Mountain Climber (target iliopsoas) |
| ExRx's version names the iliopsoas as the target; as long as the waist does not bend, the abs only steady the pelvis and waist while the hip flexes | ExRx Suspended Mountain Climber (target Iliopsoas; "With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion"); the copy says it is ExRx's suspended version of the drill and keeps ExRx's condition (verification: it had dropped it) |
| StrengthLog pulls the knee into the chest as far as you can | StrengthLog Mountain Climbers ("Pull your right knee into the chest as far as you can") |
| Hips low, just above a straight line from shoulders to heels | The model (3.6-8.9 cm above the line) |
| Lifting the hips makes the drill easier; NASM: clients may raise them to reduce the challenge | NASM plank coaching, Piked Hips ("Clients may elevate their hips to reduce the challenge"); the copy says no more than that (review: it read takes load off the abs; verification: may restored) |
| StrengthLog asks you to keep your hips down | StrengthLog ("Keep your hips down") |
| Here the hips sink a little each time the knee comes in, then rise back | The model (pelvis 5 cm lower at 1.4 s) |
| Hands flat under the shoulders, about shoulder-width, arms straight | The model; StrengthLog ("hands about shoulder-width apart") |
| ACE places the hands slightly in front of the shoulders | ACE Mountain Climbers ("slightly in front of your shoulders"); the correct line allows under or just in front |
| Straight arms stacked under the shoulders hold the upper body still | Mechanics (the library Plank's elbow cue says the same of the forearm plank) |
| The back leg straightens fully, toes on the mat | The model (knee 171°, shoe on the mat); ACE ("fully extending your right leg behind you") |
| ExRx asks you to straighten the hip on every stroke, so each leg makes a full stroke | ExRx Suspended Mountain Climber ("Attempt to straighten hip each stroke"). The model's back knee straightens (171°) but its hip stays 13-22° short of straight (hip angle 158-167°, the hips above the line), so the copy no longer says each leg works through its whole range (verification) |
| ACE switches the legs at the same moment, both feet leaving the floor | ACE ("simultaneously switch leg positions. Both feet leave the ground") |
| StrengthLog runs the knees in and out as far and as fast as you can | StrengthLog ("run the knees in and out as far and as fast as you can") |
| Each swap takes just over half a second and comes every two seconds, a controlled pace rather than a sprint | The model (0.12-0.75 s; swaps at 0, 2, 4, 6 s), slower than StrengthLog's as fast as you can (review: it read slow enough to keep the hips and shoulders steady, but the hips sink 5 cm each stroke) |
| Go faster only while your hips keep about the same height | Coaching, following ExRx's "maintaining approximate height of hips from floor throughout movement"; the model's pelvis stays within 5 cm (45-50.5 cm) (verification: it read stay steady, which the 5 cm sink each stroke contradicts) |
| Setup | ACE and StrengthLog set-ups with the model's sizes (hands under the shoulders, feet about hip-width, hips just above the line) |
| Comparison: the abs keep the trunk braced while each knee drives in | ACE ("Stiffen your abdominal muscles (brace) to stabilize your spine"); verification: it read hold the trunk still, but the pelvis sinks 5 cm and the trunk tilts 6 -> 12° each stroke |

Activation: Rectus Abdominis 0.76 and Hip Flexors 0.66 PRIMARY (bright); Obliques 0.48 and Triceps
Brachii 0.30 SECONDARY (dim). Judgement calls: in the suspended knee-tuck the rectus abdominis
(lower 54%, upper 44% MVC) worked more than the external (42%) and internal (18%) oblique (Cugliari
2017), and the Power Wheel knee-up was among the most demanding drills for the abdominals in
Escamilla 2006; the floor version moves one leg at a time with the feet on the mat, so the rectus
sits just under the library Plank's 0.78. The hip flexors (ExRx's target) move one leg at a time,
mostly forward rather than up against gravity: 0.66, under the Hanging Knee Raise's 0.76. Obliques
below the rectus as in the knee-tuck and under the Plank's 0.56. Triceps: they hold the elbows
straight, and the high planks in Can 2024 drew more triceps activity than the forearm planks
(abstract). StrengthLog lists abs primary and obliques secondary. The anterior deltoid (dim) is
named with the stabilisers for legend width; the other stabilisers are ExRx's (serratus anterior,
quadriceps) and the library Plank's transverse abdominis.

## Plank Shoulder Tap

Model facts: high plank, hands directly under the shoulders (36.8 vs 39.2 cm), elbows ~175° when
down, the body straight (the hips on the shoulder-to-ankle line, hip ~172°), trunk 16° above level,
ankles 22 cm apart. The right hand leaves the mat at 0.08 s, its fingers touch the outside of the
left shoulder 0.6-1.1 s (skin gap 4 mm, elbow ~98°, peak bend 60° on the way up and down) and it is
back down by 1.75 s; the left hand taps the right shoulder 2.08-3.75 s; again from 4 s (a tap every
2 s, ~1.7 s each). As a hand lifts, the whole body (hips and shoulders together) shifts ~2.5 cm
toward the supporting hand; the hip and shoulder lines keep 0° of roll and twist.

| Claim | Source |
|---|---|
| Hips level and facing the mat while a hand is up | The model (0° roll and twist) |
| With one hand up the body rests on three points and tends to roll toward the free side | Mechanics: the body's centre (on the midline) lies outside the line from the supporting hand to the opposite foot (~7.5 cm to the side at the hips' level, ~9.5 cm at the waist, before the model's 2.5 cm shift), which is why the model shifts toward the supporting hand |
| NASM uses shoulder taps as an anti-rotation drill, cue keep the hips quiet | NASM plank coaching ("Add shoulder taps as an anti-rotation challenge. The primary coaching cue: 'Keep the hips quiet.'") |
| In a published shoulder-tap screen, the top score needs the hips not to rotate | Heredia 2024, Table 2 (score 3: "Hips did not rotate"; scores 2 and 1: hips rotated), after Balfany et al. 2019 |
| Here the body shifts about 2.5 cm over the supporting hand | The model |
| The right hand taps the left shoulder, then the left the right, back to the floor between | The model; Heredia 2024 ("tap the left shoulder with the right hand and return to the plank position, and the right shoulder with the left hand") |
| Removing a point of contact increases the stabilising demand | NASM ("Removing a point of contact increases stabilization demands") |
| Fingers touch the outside of the opposite shoulder | The model (4 mm skin gap at the left deltoid's outer side) |
| NASM ends the set once the hips sag, pike or rotate, and reads sagging hips as the front of the core letting go | NASM ("Once posture begins to break down—whether the hips sag, pike, or rotation occurs—the set is complete"; Sagging Hips: "a loss of anterior core engagement") |
| Squeeze your glutes and pull your ribs down | NASM's cues for sagging hips |
| Feet about hip-width, toes on the mat | The model (ankle joints 22 cm, hip joints 18 cm) |
| The feet are two of the three points of support; further apart, a wider base | Mechanics |
| The screen starts with the feet shoulder-width apart and lets you spread them to one and a half shoulder-widths if the taps cannot be done from that first position | Heredia 2024 ("feet shoulder-width apart"; "If the recruit was unable to perform these movements in the initial plank position, they were instructed to spread their feet to a shoulder-width and a half stance"); the wider stance scores 2 at best (Table 2) |
| Mistake: feet together, so the hips rock with every tap | Mechanics (a narrower base); the screen widens the feet when the taps cannot be done |
| NASM measures success by stability rather than quick reps; the screen's taps are controlled | NASM ("Success is measured by maintaining stability rather than completing repetitions quickly"); Heredia 2024 ("performed in a controlled manner") |
| Each tap under two seconds, the hand up about a second and a half, half a second on the shoulder | The model (1.67 s, 0.6-1.1 s) |
| Setup: hands directly under the shoulders, arms straight; feet hip-width, wider is easier | Heredia 2024 ("hands directly beneath their shoulders"; the wider stance is the fallback when the taps cannot be done) and the model; ACE, Kovar 2014, for a plank on gliders ("Keep the feet wide to create a wide base of support that makes it easier to maintain a neutral and stable pelvis") |

Activation: Rectus Abdominis 0.78 PRIMARY (bright); Obliques 0.60 and Anterior Deltoid 0.36
SECONDARY (dim). Judgement calls: no trunk EMG of shoulder taps exists that I found (Can 2024
measured only shoulder and scapular muscles); the body holds the Plank's line, so the rectus is the
Plank's 0.78. A hand off the floor adds a turning load (NASM: anti-rotation), and rotating the
lumbar spine is the obliques' movement (ExRx), so they sit over the Plank's 0.56, still secondary
as painted dim. The anterior deltoid lifts the tapping arm (ExRx: shoulder flexion; the shoulder
flexes from ~73° to ~110°, ~120° in the side view) and steadies the supporting shoulder. The triceps (dim) hold the supporting elbow
straight and are named with the stabilisers for legend width.

## Plank Hip Dip

Model facts: forearm plank, elbows directly under the shoulders (elbow and shoulder joints at the
same z), forearms parallel (34 cm apart), hands in fists, palms in, elbows ~93°; the body straight
(hips within 1.3 cm of the shoulder-to-ankle line), trunk 8° above level, ankles 18 cm apart on the
toes. The hips turn about the body's long axis while the shoulder line stays level: the right hip
down at 1.0 s (hip line tilted 37.5°; that side's lowest skin ~8 cm above the mat within 5 cm of the
hip joint and ~4 cm at mid-thigh, against ~13 and ~10 cm level; the twist between hips and shoulders 38°), level at 2.0 s, the left hip down at
3.0 s, level at 4.0 s, and again. Smooth, ~1 s each way, no pause; the pelvis's centre stays at
0.274-0.279 m. The knees soften a little (171 -> 164°) and the feet pivot on the toes.

| Claim | Source |
|---|---|
| The hips turn so one hip lowers toward the mat, then the other, stopping just above it | The model (nothing touches; the lowered side's thigh ~4 cm up); Motra Plank Twist ("Lower hip toward the ground without touching") |
| Turning the hips while the rib cage stays put twists the trunk; rotating and side-bending the lower spine is the obliques' job | The model (38° twist, shoulders level); ExRx Obliques (lumbar rotation and lateral flexion) |
| ACE's rainbow plank turns the hips to one side aiming to touch the floor; here the lower hip and thigh stop a few centimetres above the mat | ACE, Vargo 2017 ("rotate the hips to one side, aiming to touch the floor"); the model (the lowered side's skin ~8 cm up by the hip joint, ~4 cm at mid-thigh). Verification: it read the hip stops about 6 cm above the mat, from a 5.7 cm point on the outer thigh 29 cm below the hip joint |
| Only the hips turn; the shoulders stay level over the elbows | The model (shoulder line 0°) |
| If the shoulders roll along, the body turns in one piece and the twist is lost | Mechanics |
| One coaching guide keeps the shoulders stable and lets only the hips rotate | Motra Plank Twist ("Twist hips to one side while keeping shoulders stable"; "Hips rotate only") |
| Between turns the body is straight, hips in line with the shoulders | The model (hips within 1.3 cm of the line at 0, 2, 4 s; the trunk 8° above level, so the hips sit lower than the shoulders, on the line rather than level with them) |
| One coaching guide lists sagging hips and an arched lower back among its common mistakes; NASM reads sagging hips as the front of the core letting go | Motra (Common Mistakes: "Sagging hips", "Arched lower back"); NASM (above) |
| Elbows under the shoulders, forearms parallel, fists on the mat | The model; NASM ("Elbows directly under the shoulders"; "Forearms are parallel") |
| Stacked, the upper arms hold the body up while the hips turn | Mechanics |
| One coaching guide lists jerky rotations as a mistake and gives a tempo of two seconds each way | Motra ("Jerky rotations"; Tempo "2-0-2") |
| About a second each way, no pause | The model (fastest through the middle, slowing into each side; verification: at an even pace dropped) |
| Setup | NASM's forearm plank set-up with the model's sizes; the turn |

Activation: Obliques 0.80 and Rectus Abdominis 0.70 PRIMARY (bright); no secondary row (nothing is
painted dim). Judgement calls: turning the hips against still shoulders is a lumbar twist, the
obliques' movement (ExRx), so they lead, beside the library's Side Plank (0.78) and Russian Twist
(0.76), under the Bicycle Crunch (0.84); the library row's muscle is OBLIQUES. The rectus holds the
forearm plank's line (the Plank's 0.78), a little lower here since the hips turn through it rather
than hold still. Motra rates the obliques over the abs for this exercise, but its scores are
unsourced and were not used for numbers. Stabilisers: transverse abdominis (as the library Plank),
anterior deltoid and serratus anterior (holding the forearm plank's shoulders), gluteus maximus
(NASM's squeeze the glutes).

## Plank Knee to Elbow

Model facts: the shoulder tap's high plank and body line (hands under the shoulders, hips on the
line, ankles 22 cm apart). The left knee comes out to the side and forward 0.08-0.75 s, is held to
~1.1 s and goes back by 1.85 s; a short rest; the right knee 2.08-3.88 s; again from 4 s. At the
hold the knee is bent 79° and the hip 62°; the knee joint sits outside the left arm, 12 cm out from
the elbow, 14 cm behind it and 8 cm lower (knee joint to elbow joint 20 cm), the thigh's skin 9.4 cm
from the arm's just above the elbow (it never touches); the foot is off the mat (ankle 22 cm up),
out to the side. The same side, not across. The trunk side-bends ~6° toward the knee and the pelvis
shifts 3 cm toward it; the hip line tilts at most ~3° (the working hip ~1 cm higher), the shoulders
stay square.

| Claim | Source |
|---|---|
| The knee comes out to the side and forward toward the same elbow, its foot off the mat | The model (the knee joint moves 6 cm lower as it comes forward and out, so not up; verification) |
| The hip flexes and opens to bring the knee out and forward, and the trunk bends a little toward it, a side bend the obliques make | The model (hip 62°, knee out; 6° side bend); ExRx Obliques (lateral flexion) |
| ACE's glider plank with knee to elbow draws the right knee toward the right elbow, then the left toward the left | ACE, Kovar 2014 (on gliders: "Draw the right knee toward the right elbow. Return to center and draw the left knee toward the left elbow"). ACE's Vargo 2017 brings the knee across to the opposite elbow; the model goes to the same side, so the copy follows Kovar |
| Here the knee stops about 10 cm short of the arm | The model at the 1.0 s hold: the thigh's skin 9.4 cm from the arm's, the knee's (within 8 cm of the joint) 11.1 cm; the knee joint 11.5 cm out from the elbow joint, 14 cm behind and 7.5 cm lower. The correct line no longer says just behind the elbow (verification) |
| With a foot up the pelvis rests on one leg and the trunk has to stop it rolling open | Mechanics |
| ACE's (BOSU) spiderman plank keeps the hips low and facing the floor | ACE, Rohmann 2014 ("keep the hips low and facing the floor") |
| Here the hips stay within a few degrees of level | The model (≤3.2°) |
| Lifting the hips makes room for the knee but makes the plank easier; NASM: clients may raise them to reduce the challenge; ACE's BOSU spiderman plank keeps them low | Mechanics; NASM Piked Hips. ACE's bilateral spiderman plank on gliders (Kovar 2014) lets the hips lift as both knees come in; the single-leg versions (Rohmann 2014) keep them low, as the model does |
| A published high-plank screen starts with the hands directly beneath the shoulders | Heredia 2024 |
| ACE's spiderman plank lifts the leg slowly with minimal movement, holds a moment and returns before the other side | ACE, Rohmann 2014 ("With minimal movement, lift your left leg slowly"; "Hold for a moment, return to plank and repeat on the right side") |
| Out in under a second, a brief pause, back as smoothly; about two seconds there and back | The model (0.67 s out, ~0.4 s held, 0.73 s back) |
| Setup | The model; ACE Kovar (high plank, alternating legs) |

Activation: Rectus Abdominis 0.74 and Obliques 0.72 PRIMARY (bright); Hip Flexors 0.50 and Triceps
Brachii 0.30 SECONDARY (dim). Judgement calls: no EMG of this drill was found. The rectus (the
library row's muscle, listed first) and the obliques (the side bend toward the knee) are both a
touch under the Plank's 0.78 since one leg moves through the hold; the hip flexors drive one knee
out and forward (dim, so secondary; less than the mountain climber's 0.66 since the thigh swings
out to the side); triceps as the mountain climber's (Can 2024's abstract). The anterior deltoid
(dim) is named with the stabilisers for legend width.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`). The body
is a band across v ~0.38-0.60 in all four, so pills sit above the back and below the mat; the eye
button (top right, above ~0.12) and the legend (below ~0.88) stay clear. The probed joints are
fixed sides while the legs and hands alternate, so each cue points at a joint that is right in at
least the phase its ghost is stilled in and whose leader stays off the body in both phases; the
labels are worded to fit either phase. Probing `_bent` / `_straight` points (probe.py's
SIDE_SHIFT) for the mountain climber and knee to elbow would let the knee cues follow the working
knee; requested in the report.

- Mountain Climber: knee (Knee drives toward the chest, to the chest) 0.20 left; pace (Swap, then
  pull in, to the head) 0.30 left, its leader staying left of the knee leader; hips (Hips stay low,
  to the pelvis) 0.24 right; hands (Hands under shoulders, to the left hand) 0.72 left; leg (Push
  each leg straight back, to the right foot) 0.74 right. The right foot is the back foot while the
  left knee is in (the ghosts' still) and under the body in the other phase. Round 1 had the knee
  pill bottom left to the left knee (Knees drive in, in turn): whenever the right knee was in (0 and
  3 s) the left knee was back and the right foot forward, and the two leaders from below crossed;
  with the targets swapping sides every two seconds no pair of rows below the mat kept them apart,
  so the knee cue now points at where the knee is driving.
- Plank Shoulder Tap: tap (Hand to opposite shoulder, to the left shoulder, which the right hand
  taps) 0.18 left; tempo (Slow, controlled taps, to the head) 0.28 left, under it; hips (Hips stay
  square, to the pelvis) 0.24 right; line (Straight line, head to heels, to the near knee) 0.70
  left; feet (Feet about hip-width, to the right foot) 0.76 right. A hands cue was tried first: a
  leader to the left hand crossed the body while it tapped the far shoulder (2-4 s), one to the
  right hand ran up the near arm while it tapped (0-2 s), so it became the feet cue. Round 1 had the
  line pill top right to the mid-back, beside the tap pill, the two leaders running down side by
  side to the shoulders and back.
- Plank Hip Dip: tempo (Slow, even turns, to the head) 0.24 left; shoulders (Shoulders stay square,
  to the near shoulder) 0.18 right and line (Hips up, body long, to the mid-back) 0.28 right,
  stacked so the leaders do not cross; hips (Hip turns down, no touch, to the near hip) 0.70 right,
  rising from below; elbows (Elbows under shoulders, to the near elbow) 0.76 left.
- Plank Knee to Elbow: tempo (Slow, pause at the elbow, to the head) 0.24 left; line (Hips down,
  body straight, to the mid-back) 0.20 right and hips (Hips facing the mat, to the pelvis) 0.30
  right; knee (Knee out to the same elbow, to the left knee) 0.72 right, reaching the knee from
  below whether it is out by the elbow or back; hands (Hands under shoulders, to the left hand) 0.76
  left.

## Ghosts

Measured with the port at the fault's still and swept over each clip; distances are joint moves at
full strength. Face down, the lifter's forward is the floor and up is toward the head; a positive
turn about `.lateral` carries the front (floor) toward the head, so it flexes a hip or lowers the
hips about the chest, and a negative one lifts them. Every piece is built from turns (plus a
`resolve` re-seating a knee over a planted foot), except the review's two slides (hands or
forearms slid along the mat with the shoulders lowered to keep the arms' length, the high-plank
elbows re-seated with `resolve`), so the drawn bones keep their lengths (the swept maximum change
is 0.4 cm, the tap's hip roll re-seating a near-straight knee; 0.3 cm on the slides); no moved knee or
elbow bends against its real bend in any frame; no moved joint goes more than ~1 cm below where the
real one sits (the toe tips' bone ends sit 3 cm under the mat's surface in the rig itself).

- Mountain Climber (still 1.4 s: the left knee in, its deepest, except the knee at 1.0 s; the side
  ghosts follow `_bent`, the knee drawn in, every frame): knee `plankDyn500KneeShort(16)` (the
  drawn-in thigh 16° back about the hip, the knee ~11 cm further back and ~6 cm lower, its joint
  ~8 cm above the mat at 1.0 s and ~6 cm at the 1.4 s low point; full while that knee's angle is 90°
  or less); hips `plankDyn500HipsPiked(12, legs: 21).seen(-0.6)` (pelvis 45
  -> 57 cm, level with the shoulders, hip angle 170 -> 152°; the back foot set back down ~4 cm
  ahead; side-on, since from the framing the ghost's back and legs crossed in round 1); hands
  `plankDyn500HandsSlid(0.38, drop: 0.085)` (the hands slid ~22 cm ahead on the mat, the shoulders
  ~5 cm lower, the elbows still 171-180°); leg `plankDyn500BackLegBent(hip:
  30, knee: 55)` (the back knee folded to ~116° and 18 cm lower, the foot 14 cm forward on the mat).
  Pace has none.
- Plank Shoulder Tap (still 1.0 s, the right hand at the left shoulder): hips
  `plankDyn500HipsRolled(35).seen(-2.3)` (the pelvis rolled about the supporting hip, the tapping
  side's hip ~9 cm lower; seen from the feet, as the screen judges it: from the framing the 18 cm
  hip line was ~30 pt long and lay along the legs in round 1; gated by the tapping elbow,
  `plankDyn500Tapping`: (180 - elbow angle) / 90, so 0.9 or more from 0.25 to 1.5 s, 0.91 at the 1.0 s still with the elbow at 98°, 0.03 with both hands down); tap
  `plankDyn500TapShort(40)` (the tapping arm 40° back down about its shoulder, the hand ~22 cm
  lower, by the chest, 28 cm from the shoulder instead of 12; gated the same); line
  `plankDyn500HipsSagged(25, legs: 32).seen(-0.6)` (pelvis ~10 cm lower, the feet put back;
  side-on); feet `plankDyn500FeetTogether(6)` (both legs 6° in, ankles ~4.5 cm apart instead of 22).
  Tempo has none.
- Plank Hip Dip (hips and shoulders stilled at 3.0 s, the near hip down; line and elbows at 2.0 s,
  level): hips `plankDyn500DipShort(28).seen(-2.5)` (the hips turned back 28° about the raised hip,
  ~10° of turn left instead of 37.5°, the lowered hip ~8 cm higher; seen from the feet, where the
  real hip line's 37.5° and the ghost's ~10° are both in view: from the framing the lowered hip
  moved ~20 pt); shoulders `plankDyn500ShouldersRolled(20).seen(0.6)` (the shoulder line turned 20°
  about the raised side's shoulder, the lowered side's shoulder ~13 cm lower; seen head-on, across
  the shoulders); both gated by `plankDyn500Dipping` (0 level, 0.41 at 14° of turn, 0.85 at 27°,
  full from ~30°); line `plankDyn500HipsSagged(25, legs: 32).seen(-0.6)` (pelvis ~10 cm lower,
  side-on); elbows `plankDyn500ElbowsSlid(0.22, level: 0.031, drop: 0.05)` (the forearms and fists
  slid ~13 cm toward the head on the mat along the trunk's axis, the shoulders ~3 cm lower, the
  elbows opening from 93° to ~120°, the same in every frame; the room's `ahead` is not used because
  the body frame's left and forward turn with the hips, up to 37.5°, and `ahead` then swings
  sideways). Tempo has none.
- Plank Knee to Elbow (still 1.0 s, the left knee out at the elbow; gated by `plankDyn500KneeOut`,
  the ankles' spread: 0 with both feet down, 0.86 at 0.5 s, full 0.75-1.25 s): knee
  `plankDyn500KneeOutShort(30)` (the working leg swung 30° back about the hip, the knee 13 cm
  further back and 10 cm further out, 36 cm from the elbow instead of 20); hips
  `plankDyn500HipRolledOpen(22)` (pelvis and working leg rolled about the supporting hip, the
  working hip ~6.5 cm higher, the foot ~26 cm higher); line `plankDyn500HipsPiked(12, legs: 21)`
  gated the same, side-on (pelvis ~12 cm higher); hands `plankDyn500HandsSlid(0.38, drop: 0.08)`
  (the hands slid ~22 cm ahead on the mat, the shoulders ~5 cm lower, the elbows 167-180°). Tempo
  has none.

## Uncertain

- No EMG of any of the four; fractions rest on the library's planks and crunches and on the closest
  measured drills (the suspended knee-tuck, the Power Wheel and Swiss-ball knee-ups), all judgement
  calls.
- Can 2024 (triceps higher in high planks) and Escamilla 2006 were read as abstracts only.
- Balfany et al. 2019, the shoulder-tap screen's origin, was not read; its protocol is taken from
  Heredia 2024's description.
- The shoulder tap's and hip dip's ghosts rely on small knee asymmetries in the rigs to tell the
  sides apart (a re-export could change them; a wrong read hides the ghost rather than drawing the
  wrong side).
- The mountain climber's front foot never lands where ACE's does, and its tempo is slower than
  StrengthLog's as fast as you can; the copy follows the model.
- ACE rates the Mountain Climber advanced; the library row says beginner (not changed).
- ExRx was read through Internet Archive copies; its mountain climber page is the suspended version
  (2021 snapshot).

## Change log

- 2026-10-05, draft: models measured, sources read, copy, setup, ghosts and moments for all four;
  `spec_500.py plankdyn` OK; `family.sh check plankdyn` BUILD SUCCEEDED on the first build. The
  shoulder tap's first draft had a hands cue (Hands under shoulders, a support hand set forward as
  the ghost); its leader crossed the body in one phase or the other (overlay of the reference
  stills), so it became the feet cue before the first shoot.
- Lab round 1 (`family.sh shoot plankdyn "0,1,1.4,3"`, kept in `SCRATCH/plankdyn/round1/`):
  BUILD SUCCEEDED, the app ran, all 16 trainer stills and 16 ghosts shot. Fixed: the mountain
  climber's knee and back-leg leaders crossed below the mat whenever the right knee was in (knee
  cue moved to the chest, top left; pace to the head); the shoulder tap's line pill sat beside the
  tap pill top right with the two leaders side by side (moved below the mat to the near knee); the
  piked and sagging ghosts read poorly from the framing (the ghost's back and legs crossed), so they
  are seen side-on (`.seen(-0.6)`); the tap's hip roll and the dip's short turn moved only ~20 pt
  along the legs, so they are seen from the feet (`.seen(-2.3)`, `.seen(-2.5)`; stick previews of
  the views from the port, `draw.py`, before the shoot); the dip's shoulder roll is seen head-on
  (`.seen(0.6)`). Legends: no truncation (the longest secondary line, HIP FLEXORS · TRICEPS BRACHII, fits).
- Lab round 2 (kept in `SCRATCH/plankdyn/round2/`): every trainer still has its pills off the
  lifter and leaders that do not cross in either phase (0, 1, 1.4, 3 s); every ghost attached and
  readable: the pikes and sags side-on, the tap's hip roll from the feet (hip line tilted ~35°
  against the square body), the dip's short turn from the feet (ghost hips nearly level against
  the real 37.5° turn), the dip's shoulder roll head-on.
- Self-review after round 2 (sources and model): ghost comments re-measured with the port and
  corrected (the climber's knee ~14 cm back and ~9 cm lower, not 17 cm "halfway to the hips"; the
  pike's back foot lands ~4 cm ahead rather than in place; the tap's ankles 4.5 cm apart; the
  dip's shoulder ~13 cm lower; the knee to elbow's hip and foot 6.5 and 26 cm); the climber's
  comparison note no longer reads NASM as saying why clients pike beyond its own words; ExRx's
  mountain climber is named as its suspended version; the knee to elbow's hip and tempo cues name
  ACE's BOSU spiderman plank (ACE's glider spiderman plank, both knees together, lets the hips
  lift).
- Final `family.sh check plankdyn` after the self-review (only ghost comments and these notes
  changed since round 2): BUILD SUCCEEDED; `spec_500.py plankdyn` OK.

## Review (2026-10-05)

An independent sources and model review of the four files, round 3 of the 401-500 batch. Working
files are in `SCRATCH/plankdyn/review/` (the four files as the author left them in `before/`; the
review's lab shots in `lab_review1/`).

- Sources reopened: the four Europe PMC records (Cugliari 2017, Escamilla 2006, Can 2024, Heredia
  2024); authors, year, journal, volume, issue, pages, DOI and PMID all match the header. Cugliari's
  PMC full text: 17 active men, the knee-tuck from a push-up position with each foot in a strap,
  hips and knees to ~90°, Table 1 medians LRA 54, URA 44, EO 42, IO 18, LES 8, UES 6% MVC, and the
  discussion's Swiss-ball (32/35%) and Power Wheel (41/45%) knee-up figures. Escamilla's abstract
  (21 men and women; the Power Wheel pike, knee-up and roll-out highest for the rectus, internal
  oblique and latissimus, the pike and knee-up high for rectus femoris) and Can's (21 men, ten low
  and high planks including shoulder taps, higher triceps and lower trapezius in the high planks,
  no trunk muscles) say what the header says. Heredia's full text: 202 recruit datasets, the
  shoulder-taps protocol after Balfany (hands directly beneath the shoulders, feet shoulder-width,
  a dowel along the back, right hand to left shoulder and back then left to right, controlled; the
  wider stance only if the taps cannot be done from the first position) and Table 2 (score 3 needs
  the hips not to rotate). The saved NASM, ACE (library no. 258; Kovar 2014, Rohmann 2014, Vargo
  2017), StrengthLog, Motra and ExRx Wayback pages were re-read and the live NASM, StrengthLog,
  Motra and ExRx Wayback URLs answer; every quote in the claim tables is on the page it is
  attributed to. Re-running Europe PMC searches for mountain climber, shoulder tap(s), rotating,
  rainbow and hip-dip planks and knee-to-elbow or spiderman planks with EMG terms found no study
  with activation levels for any of the four (only a 2026 Data in Brief EMG and IMU dataset with no
  %MVC), so every fraction stays a labelled judgement call. Library anchors re-checked in
  SampleData (Plank 0.78 / 0.56, Hanging Knee Raise 0.80 / 0.76, Side Plank 0.78, Russian Twist
  0.76, Bicycle Crunch 0.84, Dead Bug 0.68); rows follow the paint, levels match the fractions.
- Changed, copy: the climber's hips cue and comparison and the knee to elbow's line cue said
  lifting the hips takes load off the abs or the trunk, more than NASM's to reduce the challenge;
  they now say it makes the drill (plank) easier. The climber's rhythm cue said the model's pace is
  slow enough to keep the hips and shoulders steady, but the hips sink 5 cm each stroke; it now says
  a controlled pace rather than a sprint. The knee to elbow names ACE's glider plank with knee to
  elbow (Kovar's feet slide on gliders) and calls the one-leg version ACE's BOSU spiderman plank,
  as the hips cue does. The shoulder tap's feet cue now gives Heredia's condition for the wider
  stance (the taps cannot be done from the first position) instead of without losing the position.
  Three line cues said the hips level with the shoulders, but the trunk rises 8-16° to the head, so
  the hips sit below the shoulders on the line; they now say in line with.
- Model checked from the rigs (`review/check1.py`, `check2.py`, `try13.py` on the author's joint
  dumps): the climber's swaps (right knee in at 0 s, left 0.75-2 s, the pelvis 50.5 -> 45.3 cm at
  1.5 s, the hips 3.3-8.7 cm above the shoulder-to-ankle line), the tap's sides and timing (right
  hand up 0.08-1.75 s, elbow 98° at the shoulder, the body 2.5 cm toward the supporting hand, no
  roll), the dip's sides (right hip down at 1 s, left at 3 s, 37.5°, shoulders level) and the knee
  to elbow's same-side knee (left first, outside, behind and below the left elbow, 20 cm joint to
  joint; the pelvis 3 cm toward it). Copy, setup steps, labels, left/right and timing all match.
- Changed, ghosts. The hip dip's elbows ghost (`armsTurned(.lateral, 25)`) lifted the fists ~13 cm
  off the mat; worse, the body frame's left and forward turn with the hips (up to 37.5°), so the
  room's `ahead` and the lateral axis swing sideways during each dip. It is now
  `plankDyn500ElbowsSlid(0.22, level: 0.031, drop: 0.05)`: the forearms and fists slid ~13 cm toward
  the head on the mat along the trunk's own axis (pelvis to neck, which the hip turn leaves alone),
  the shoulders ~3 cm lower so the upper arms keep their length (swept: within 0.2 cm, elbows 93 ->
  ~120° in every frame). The climber's and knee to elbow's hands ghosts (`armsTurned`, hands ~5 cm
  and fingers ~10 cm off the mat) are now `plankDyn500HandsSlid` (hands ~22 cm ahead on the mat,
  shoulders ~5 cm lower, elbows re-seated with `resolve`, 167-180°, bones within 0.3 cm). The
  climber's short-stroke ghost turned the thigh 22°, putting the knee joint ~4 cm above the mat
  (the knee's skin under it); it is now 16° (knee ~11 cm back and ~6 cm lower, joint ~8 cm up at
  its still, now 1.0 s, ~6 cm at the 1.4 s low point). The other 12 ghosts were re-solved in the
  port (`review/sweep.py`; the author's port extended with the `ahead` / `rise` shifts) and checked
  on the lab shots: each shows its named mistake, attached and possible; no knee or elbow bends the
  wrong way in any frame.
- Labels: unchanged; every trainer still (0, 1, 1.4, 3 s) re-checked. Left as the author reported:
  the climber's back-leg pill points at the right foot, under the body in every other phase, and
  the tap's pill at the left shoulder, the supporting one while the left hand taps (probing `_bent`
  / `_straight` points would fix both; requested).
- Lab (`family.sh shoot plankdyn "0,1,1.4,3"`, copy in `review/lab_review1/`): BUILD SUCCEEDED, the
  app ran, trainer screens as before; the new hands and elbows ghosts read as the hands (forearms)
  set out in front with the arms slanting forward, on the mat; the short-stroke knee sits lower and
  further back, clear of the mat.

## Verification (2026-10-05)

A final claim-by-claim check of the four files after the review, round 3 of the 401-500 batch.
Working files in `SCRATCH/plankdyn/skeptic/` (the spec and notes as the review left them:
`spec_before.py`, `notes_before.md`).

- Sources reopened: the four Europe PMC records (authors, year, journal, volume, issue, pages, DOI,
  PMID match the header); Cugliari's PMC full text (17 active men; the knee-tuck from a push-up
  position, feet in the straps, hips and knees to ~90°; Table 1 medians 54 / 44 / 42 / 18 / 8 / 6%
  MVC; the discussion's ranking roll-out, body saw, pike, knee-tuck and its Swiss-ball 32 / 35% and
  Power Wheel 41 / 45% knee-up figures); Escamilla's and Can's abstracts; Heredia's full text (202
  recruit datasets; hands directly beneath the shoulders, feet shoulder-width, right hand to the
  left shoulder and back then left to right, controlled; the shoulder-width-and-a-half stance only
  if the taps cannot be done; Table 2, score 3: hips did not rotate). The saved NASM, ACE (no. 258,
  Kovar 2014, Rohmann 2014, Vargo 2017), StrengthLog, Motra and ExRx Wayback pages (snapshot dates
  as in the header) carry every quote in the claim tables; the live NASM page was fetched again
  and matches. Europe PMC searches re-run for the four drills with EMG terms: no study with
  activation levels for any of them (the one mountain climber EMG hit, a 2020 Pilates Wunda Chair
  study of co-contraction, is a different exercise). Library anchors re-read in SampleData (Plank
  0.78 / 0.56, Hanging Knee Raise 0.80 / 0.76, Side Plank 0.78, Russian Twist 0.76, Bicycle Crunch
  0.84, Dead Bug 0.68 / 0.40) and the four library rows' muscles (RECTUS ABDOMINIS; OBLIQUES for
  the hip dip); paint re-read in `tiers.txt`; every row follows it and every level its fraction.
- Model re-measured from the USD files directly (`skeptic/j.py` dumps the joints with pxr, `m.py`
  the timelines, `sk.py` skins the meshes; `s1.py`-`s9.py` the checks), not from the earlier dumps:
  clip 7.96 s at 24 fps; mat 1.6 x 2.4 m, top at y 0. Mountain climber: swaps 0.12-0.75 s, the left
  knee in 0.75-2.0 s, knee 66 -> 54°, hip 82 -> 58°, pelvis 50.5 -> 45.1 cm at 1.4 s, trunk 6-12°,
  hips 3.3-9.5 cm above the shoulder-to-back-ankle line, back knee 171°, elbows 173.5-177.3°,
  wrists 36.9 / shoulders 39.2 cm apart, hands 0-1.4 cm ahead; the front shoe 2.5 cm off the mat,
  both 4.5 cm at 0.4-0.5 s, the thigh against the belly. Shoulder tap: right hand off the mat
  0.12-1.67 s, its skin 4 mm from the left deltoid's outer side 0.75-1.0 s (elbow 98°, peak bend
  62°), the left hand 2.08-3.75 s, the pelvis 2.5 cm toward the supporting hand, 0° roll and twist,
  the supporting knee 171.7° against 174.1°. Hip dip: right hip down at 1.0 s (37.5°), left at
  3.0 s, shoulders 0°, elbows 93.5° under the shoulders, fists on the mat, the turn fastest through
  the middle and slowing into each side. Knee to elbow: the left knee out 0.08-0.75 s, held to
  ~1.1 s, back by 1.83 s; knee 79°, hip 62°; the pelvis 3 cm toward it, hip roll 3.2°, the hip line
  8.4° off the shoulder line (the side bend); hips on the line (-0.6 cm). Ghosts: the review's port
  re-run (`review/sweep.py`); sizes as the table says, no bone change over 0.4 cm, no reversed bend.
- Changed, copy (text only; no label, cue id, tracked joint or ghost changed, so no shoot):
  - Mountain climber knee why: ExRx's abs-only-steady statement now keeps its condition (as long as
    the waist does not bend).
  - NASM's piked hips (climber hips why and comparison, knee to elbow line why): clients may raise
    the hips, as NASM words it, not do.
  - Climber back leg why: so each leg makes a full stroke, not works through its whole range (the
    model's back hip stays 13-22° short of straight).
  - Climber rhythm correct: go faster only while your hips keep about the same height (ExRx's
    wording), not stay steady (the hips sink 5 cm each stroke, as the review found for the why).
  - Climber comparison: the abs keep the trunk braced (ACE's brace), not hold the trunk still.
  - Hip dip hip why: the lower hip and thigh stop a few centimetres above the mat. The 6 cm came
    from the author's 5.7 cm, which is the outer thigh 29 cm below the hip joint; by the hip joint
    the skin is ~8 cm up, the thigh's lowest ~4 cm.
  - Hip dip tempo why: at an even pace dropped (the turn slows into each side).
  - Knee to elbow knee intro: forward toward the elbow, not up (the knee joint drops 6 cm as it
    comes out); correct: just behind the elbow dropped (the knee is 14 cm behind it).
- Changed, header and notes facts: the climber's back hip 158-167° (was 160-166°) and the driving
  knee 23-31 cm ahead of the hip joints, 20-30 cm behind the hands, 12-13.5 cm up (was 14-21,
  20-27, 10-13); the hip dip's skin heights (above); the tap's shoulder flexion ~110° (was ~125°);
  the support-triangle offset ~7.5 cm at the hips (was ~9); the tap gate's strength (0.91 at its
  still, not full). Kovar's wide-feet line added as a source for wider is easier.
- `python3 spec_500.py plankdyn`: OK.
