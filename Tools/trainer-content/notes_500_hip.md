# 401-500 folder: dumbbell hip thrust (2026-10-04)

One exercise from the builder's 401-500 set: 376 Dumbbell Hip Thrust (`Legs/DumbbellHipThrust`).
`spec_500_hip.py` holds the copy and setup steps (its header lists what the model shows and the
full citations), `Tools/fault-review/faults_500_hip.swift.txt` the ghosts (all reused from the
Barbell hip thrust pieces) and `Tools/fault-review/fault_moments_500_hip.json` the moment each ghost
is stilled. This file maps the copy's claims to their sources and records the model facts.

## How the model was read

- The leg brief (`SCRATCH/briefs_legs/DumbbellHipThrust.md`), the trainer stills, `tiers30.json`,
  `joints.json`.
- The rig and equipment from the USD with Blender's Python + pxr: `SCRATCH/calfseat/rig.py` (all
  joints every frame, equipment bounds), `SCRATCH/hip/hang.py` (knee, hip, elbow angles, pelvis
  height, the knee-hip-shoulder line), `SCRATCH/calfseat/shoes.py` on the skinned glutes, back,
  abdomen and hands (how high the seat stays at the bottom, where the back meets the pad).
  The Barbell Hip Thrust rig was read the same way for comparison.
- Labels with `SCRATCH/calfseat/pills.py`; ghosts with the Python port of `FaultGhost.solve`
  (`SCRATCH/calfseat/ghost.py`).

## Model facts

- Upper back across the long side of a low flat bench (pad top 0.36 m, front edge z -0.37, the
  shoulder joints right over it at the bottom: near the top of the shoulder blades). Lower trapezius
  mesh 0.356 m up over the pad: the back stays on it. The shoulder joints move ~6 cm toward the head
  (z -0.368 -> -0.425) as the trunk turns 30 degrees over the edge: a pivot, not a slide.
- Dumbbell (HG_LapDumbbell): shaft 34 cm across the body, heads 16 cm in diameter at x +-0.08-0.15,
  centred over the hip joints (z 0.09 at the bottom, 0.12 at the top; pelvis joint z 0.09-0.10):
  the hip crease. Both hands hold it by the heads (hand joints x +-0.15-0.17, ~0.30 m apart),
  elbows 85 -> 132 degrees. It rises with the hips (centre 0.45 -> 0.67 m).
- Feet flat all clip (shoe soles at 1 mm), ankles 0.40 m apart (shoulder joints 0.39), toes turned
  out 8 degrees each. Knees 69 -> 90 degrees, shins vertical at the top (knee over the ankle within
  4 mm in z); the knees sit ~3 cm inside the ankles each side at the top (0.34 vs 0.40 m apart), as
  the barbell model (no knee cue, as there).
- Hips 115 -> 169 degrees (trunk-thigh; the spine joint sits just above the hips, so a straight hip
  reads short of 180 on this measure), pelvis 0.205 -> 0.462 m; at the top the knees, hip joints and
  shoulders are in line (179 degrees, the hips 0.5 cm under the line), the trunk level.
- At the bottom the trunk slopes up 30 degrees to the bench and the seat hovers ~5-8 cm off the
  floor (the gluteus maximus mesh's lowest point 7.7 cm): the hips never rest.
- The spine keeps one shape (spine-chest-neck 174 degrees throughout); the chin tucks ~18 degrees
  at the top (chest-neck-head 178 -> 160), eyes along the body. The barbell copy's "head in line with
  the spine" is therefore left out here; there is no head cue.
- Timing (pelvis): bottom 0-0.29 s, up 0.33-1.33 s, top 1.38-2.17 s (~0.8 s hold), down
  2.21-3.54 s (~1.3 s), ~0.7 s at the bottom; two reps in 7.96 s. "Hold for about a second" is the
  0.8 s hold.
- Paint: GluteusMaximus, GluteusMedius, GluteusMinimus, RectusFemoris and the three vasti bright;
  BicepsFemoris, Semimembranosus, Semitendinosus and ErectorSpinae dim. (The Barbell Hip Thrust's
  model paints the three glutes bright and the hamstrings dim, the quadriceps unlit; the Glute
  Bridge's the glutes and quadriceps bright.)

## Claims and sources

| Claim | Source |
|---|---|
| Hips rise until the torso is level; the gluteus maximus is the main hip extensor; the rep ends with the hips straight, where the glutes are shortest | ExRx Barbell Hip Thrust ("Raise bar upward by extending hips until straight"; target gluteus maximus); Brazil 2021 (extensor demand far greater at the hip than at the knee or pelvis-trunk); the glutes shortest at full hip extension is anatomy; the library's barbell copy |
| Knees, hips and shoulders line up at the top; hold about a second | Fitness Volt ("Your body, from the knees to the head, should be in a straight line at the top"); the model (179 degrees, 0.8 s hold) |
| Ribs down, trunk braced and rigid; arching the lower back or tipping the pelvis forward adds height through the spine | ExRx ("Movement should occur through hip with torso rigid. Avoid chest arching upward and anterior pelvic tilt, both producing spinal hyperextension") |
| Feet so the shins are vertical at the top; knees near 90 degrees shorten the hamstrings at the knee so they help less; in one small study feet further out raised hamstring and lowered quadriceps activity with no gain in glute activity | StrengthLog (knees ~90 degrees at the top); the model (vertical shins); Collazo Garcia 2020 via Neto 2019's text (feet away: biceps femoris and semitendinosus up, quadriceps down, gluteus maximus unchanged; 7 trainers at 40% 1RM, hence "one small study"); Neto 2019's text for the shortened hamstrings ("knee flexion (about 90° angle) during the hip-raising phase induces a hamstrings insufficiency (lower force production), requiring a greater effort of the gluteus maximus", citing Kwon and Lee 2013) |
| Feet flat about shoulder-width, toes turned out a little | ExRx and StrengthLog (about shoulder width); Fitness Volt ("Plant your feet shoulder-width apart on the floor and turn your toes outward slightly"); the model (0.40 m, 8 degrees) |
| The upper back pivots on the bench edge; sliding moves the hips away from the feet and changes the knee angle | ExRx ("Find comfortable contact hinge position on bench and avoid sliding"); the model (a ~6 cm pivot of the shoulder joints, the back staying on the pad); the knee-angle consequence is geometry (the feet stay planted) |
| Bench edge near the top of the shoulder blades | The model (shoulder joints over the edge); Fitness Volt (shoulder blades against the bench edge); the library barbell copy |
| A low bench, secured so it cannot slide | ExRx ("Bench may need to be secured so it does not slide on floor"; it suggests 40-46 cm, the model's is 36 cm, so the copy says only "low") |
| The dumbbell across the hip crease, held at both ends so it stays put; across the crease it loads hip extension directly; it can roll toward the stomach as the hips rise | Fitness Volt ("Place the dumbbell horizontally in your hip crease and hold onto each end to ensure it stays in place"); ExRx (the bar across the upper hip flexors and lower abdomen; "Keep bar from rolling back near top of movement with hands on bar"); the model (dumbbell over the hip joints, hands on the heads) |
| Comparison HIPS STOPPING SHORT: finishing with the torso level takes the hips to straight, where the glutes are shortest; stopping low cuts off the top of the range | ExRx (extend the hips until straight); the range description, no growth claim (Plotkin 2023: more gluteal EMG in the hip thrust did not predict more growth, so the copy makes none) |

## Activation

- Gluteus Maximus PRIMARY 0.90: the target in every source (ExRx, StrengthLog); Contreras 2015
  (69.5 / 86.8 %MVIC upper / lower, well above the back squat); the library barbell value.
- Quadriceps PRIMARY 0.55 (painted bright): a judgement call. Contreras 2015 measured the vastus
  lateralis near the back squat at 10RM (99.5 vs 110 %MVIC, not different); Delgado 2019 found it
  lower than the squat at 1RM; Neto 2019 (PMID 31191088) summarises 35-100% MVIC across the hip thrust studies;
  Plotkin 2023 saw more quadriceps growth after squats than after hip thrusts; ExRx lists the
  quadriceps as a synergist, StrengthLog as secondary. Above the library barbell lift's 0.40 (its
  model leaves them unlit) and below the Glute Bridge's paint-led 0.66.
- The three glutes are bright; they are grouped as the library's Glute Bridge groups the same
  bright set (glutes and quadriceps): the gluteus maximus row stands for them and the gluteus
  medius and minimus are named with the stabilisers. A first draft had Gluteus Medius as a third
  PRIMARY row at 0.45 (Neto 2019: ~45% MVIC in the hip thrust, Collazo Garcia's four variations at
  40% 1RM); on the simulator the one-line legend truncated it ("GLUTEUS MED..."), so the library's
  grouping was used instead.
- Hamstrings SECONDARY 0.45 and Erector Spinae SECONDARY 0.45 (painted dim): the library barbell
  values for the same motion (Contreras 2015 biceps femoris 40.8 %MVIC; ExRx: hamstrings dynamic
  stabilisers, erector spinae stabiliser). Caveat found in review: the only erector spinae EMG in
  Neto 2019's table (Andersen 2018, barbell hip thrust: upper 93%, lower 83% mean MVIC; Neto's
  summary "approximately 85% MVIC") is far above 0.45. The row stays at the barbell lift's value
  (same motion, dim paint, so secondary) as a judgement call, and no copy claims anything about
  the lower back's share.
- Stabilisers: gluteus medius and gluteus minimus (painted bright, see above; Neto 2019: gluteus
  medius ~45% MVIC in the hip thrust), adductors (StrengthLog secondary), core.

## Labels

As the Barbell Hip Thrust (same framing and body): ribs and dumbbell on the top row (left and
right), hips below them on the left at 0.27, feet and bench on the bottom row. The ribs cue tracks
`support_PectoralisMajor_Abdominal_R` (on the lower ribcage; the `chest` joint's dot lands on the
glutes from this view), the dumbbell cue the left hand; their leaders drop side by side to the
middle of the body without crossing (at the hips pill's row the ribs leader passes ~6 pt right of
that pill's end, as on the barbell layout). Checked with `pills.py` on all five stills.

## Ghosts

All five reused from the Barbell hip thrust pieces (FaultPoses.swift), shown at the top (moments
"top"; `thrustLockout` reads the left pelvis-to-ankle distance, 0.86 at the bottom and 1.04 at the
top on this rig, so they are full at lockout). Sizes from `ghost.py` at 1.75 s: hips ~15 cm
(~28 pt) below the line, knees 90 -> ~74; lumbar spine ~7 cm (~13 pt) up; feet ~13 cm (~19 pt)
further out, knees ~111; the back ~12 cm (~15 pt) up the bench, knees ~109; the dumbbell (the hand
tips' line) ~17 cm (~20 pt) toward the stomach, elbows 132 -> ~85. No turn: as on the barbell lift,
a turn toward side-on would not show these better (they move up and down the screen or along the
trunk's line).

## Uncertain

- The quadriceps and gluteus medius fractions are judgements from barbell-hip-thrust EMG; no study
  measured a dumbbell hip thrust. The erector spinae 0.45 is the library's, below the ~85% MVIC
  Neto 2019 summarises (see Activation).
- Fitness Volt is a coaching site; the dumbbell placement it describes matches the model.
