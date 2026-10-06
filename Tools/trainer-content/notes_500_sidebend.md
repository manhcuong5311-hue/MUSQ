# 401-500 folder, round 3: side bends, reverse wood chop and cable rotation (2026-10-05)

Four standing oblique lifts from the builder's 458-461 exports: 458 Cable Side Bend, 459 Dumbbell
Side Bend, 460 Reverse Cable Wood Chop and 461 Cable Rotation (models `Abs/<Resource>.usdc`).
`spec_500_sidebend.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_sidebend.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_sidebend.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.
`SCRATCH` below is the session's lab folder (`$LAB/r3`).

## How the models were read

- The arm and leg briefs (`SCRATCH/briefs/<Resource>.md`, `SCRATCH/briefs_legs/<Resource>.md`),
  `tiers.txt`, `joints.json` and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`). The briefs
  give the neck-over-pelvis line, which mixes a pelvic tilt with a spinal bend and does not split a
  side bend from a twist, so the rigs were read directly with Blender's Python + pxr (scripts in
  `SCRATCH/sidebend/`):
  - `dump.py`: every joint's world matrix and every `GYM_*` / `HG_*` mesh's world bounds, every
    frame (192 frames, 24 fps), into `<Resource>.json`.
  - `bones.py`: each trunk bone's turn from the start of the clip as a rotation vector in the
    lifter's start frame, split into flexion (about the left axis), side bend (about the forward
    axis) and twist (about the up axis); the lumbar part is the spine bone against the pelvis, the
    thoracic part the chest bone against the spine bone, and the head against the chest.
  - `lines.py`: the yaw of the shoulder, hip and ankle lines (how far each faces left or right of
    the feet), each foot's direction, knee and elbow angles, the neck-over-pelvis lean, heel heights.
  - `eq.py`: the equipment bounds at chosen frames and which pieces move (pulley carriages, the
    handle, rope and dumbbell, the weight stacks).
  - `orange.py`: centre and spread of the bright (orange) and dim (red) painted pixels in the five
    stills, where the glows sit; `occ.py`: which screen bands the lifter and equipment cover, for
    the labels; `overlay.py`: the pills (~24 + 6.4 pt per character, 28 pt tall, clamped 8 pt inside
    the viewport as `TrackedCallout` does) and leaders drawn over the five stills.
- Ghosts: `SCRATCH/sidebend/ghost.py`, a Python port of `FaultGhost.solve` (shift, turn, straighten,
  resolve, the four strengths, the `_R` mirroring of non-lateral turns) with a camera fitted to
  `joints.json` by direct linear transform (mean error 0.4-1.1 pt over every probed joint at the 8
  probe times), and a `view` turn about the vertical through the pelvis for the mistake views;
  `final.py` solves every ghost as written in Swift at its moment and checks every drawn segment's
  length at 0.5, 1, 2 and 3 s and the side each knee and elbow bends to.
- Sources: Europe PMC REST records (`SCRATCH/sidebend/src/epmc_*.json`); ExRx through the Wayback
  Machine (`src/exrx/*.html|txt`); StrengthLog live (`src/web/sl_*.txt`, read 2026-10-05) and
  Bodybuilding.com through the Wayback Machine (`src/web/bb_cablelift.txt`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.59 m). Every clip is 7.96 s with two identical 4 s reps.
- Facing: the lifter faces +z, their left +x. The trainer framings are yaw 0.4 (cable side bend),
  -0.3 (dumbbell side bend), 0.5 (chop and rotation); the fitted cameras sit 23 deg toward the
  lifter's right, 18 deg toward their left, and 28 and 27 deg toward their right, so a positive
  framing yaw turns the right side toward the camera and a negative view turns the left side
  toward it.
- Every cable lift uses the right-hand carriage of the dual-pulley station `GYM_M29`, so the cable
  comes from the lifter's right and every rep is worked against a pull from the right.
- Moments (fault_times `hold`, given in seconds): the side bends' deepest lean toward the weight at
  1.25-1.5 s (stilled 1.4 s), their far lean at ~3 s; the chop's bottom at 0-0.08 s and 3.5-4 s
  (stilled 3.75 s), its top 1.5-2 s (1.6 s), the hands passing the chest at ~0.75 s; the rotation's
  end of turn 1.5-2 s (1.6 s).
- Highlight tiers (`tiers.txt`): both side bends light ExternalOblique and InternalOblique bright;
  Brachioradialis, the forearm flexors and extensors (ExtensorCarpiRadialisBrevis / Longus,
  ExtensorCarpiUlnaris, ExtensorDigitorum, FlexorCarpiRadialis, FlexorDigitorumProfundus /
  Superficialis, PalmarisLongus), ErectorSpinae, RectusAbdominis, RhomboidMajor and the three
  Trapezius parts dim. The chop: obliques bright; DeltoidAnterior, GluteusMaximus / Medius /
  Minimus and RectusAbdominis dim. The rotation: DeltoidAnterior, DeltoidLateral and both obliques
  bright, nothing dim. Bright rows are PRIMARY, dim rows SECONDARY (house rule); all names pass
  `part_of()`.
- Legend width (one line per rank, ~43 characters of names, `notes_500_calfstand.md`): the side
  bends' dim set would read ERECTOR SPINAE · RECTUS ABDOMINIS · TRAPEZIUS · FOREARMS · RHOMBOIDS,
  so three are rows (ERECTOR SPINAE · TRAPEZIUS · FOREARMS, 37 characters: the iliocostalis and
  trapezius ExRx names, and the grip on the weight) and the rectus abdominis and rhomboids are
  named with the stabilisers. The
  chop's GLUTEUS MAXIMUS · ANTERIOR DELTOID · RECTUS ABDOMINIS would be 53, so the rectus abdominis
  (Andersson 2002: little activated in trunk rotations) goes with the stabilisers. The rotation's
  primary line OBLIQUES · ANTERIOR DELTOID · LATERAL DELTOID is 45 characters; see Lab rounds.
- No EMG study giving activation levels for any of the four was found (Europe PMC searches for side
  bend, lateral flexion with dumbbells, wood chop / woodchop, chop and lift, cable trunk rotation,
  the Pallof press; web searches). The one EMG study of a cable wood chop found in verification,
  Vasudevan et al. 2016 (J Sports Med, PMID 27403454, PMC4925984), recorded only the order in which
  muscles switched on, not how strongly. The closest measurements found are fine-wire studies of trunk
  rotation (Andersson 2002), maximal twisting efforts (McGill 1991) and side-lying trunk lifts
  (Andersson 1996), none of a loaded standing lift. The Oliva-Lozano and Muyor 2020 systematic
  review of core exercises (PMC7345922, full text searched) has no side bend, chop or cable
  rotation data. Every fraction is therefore a judgement call anchored on the library's nearest
  lifts: Side Plank (obliques 0.78), Suitcase Carry (obliques 0.60, forearm flexors 0.55, erector
  spinae 0.50, trapezius 0.44, the trapezius from Bordelon et al. 2021 per its code comment),
  Cable Wood Chop (obliques 0.78, rectus abdominis 0.44) and Russian Twist (obliques 0.76). Each is
  said so in the spec's code comments.

## Sources

| Source | What it is | Used for |
|---|---|---|
| ExRx Cable Side Bend (`WeightExercises/Obliques/CBSideBend`, Wayback 2019-07-20) | "With side to low pulley, grasp stirrup attachment with near arm. Stand with arm straight." Execution: pull the stirrup by bending sideways through the waist so the torso moves away from the pulley; lower it by leaning toward the pulley; continue with the opposite side. Target obliques; synergists quadratus lumborum, psoas major, iliocostalis lumborum and thoracis; stabilisers upper and middle trapezius, levator scapulae, gluteus medius and minimus | Cable side bend set-up, range, arm straight, muscles, stabilisers, the other side |
| ExRx Dumbbell Side Bend (`DBSideBend`, Wayback 2018-08-10) | "Grasp dumbbell with arm straight to side." "Bend waist to opposite side of dumbbell until slight stretch is felt. Lower to opposite side, same distance and repeat." Same muscles as the cable version | One dumbbell; muscles. Its stretch is felt bending AWAY from the dumbbell, and it goes the same distance both ways; the copy does not use either (see the dumbbell section) |
| ExRx Cable Twist (`CBTwist`, Wayback 2019-08-21) | A shoulder-height pulley, both hands, feet wide, the near heel raised, knees slightly bent; rotate the torso to the opposite side with the arms horizontal and straight. Comment: arguably more hip internal rotation and transverse adduction than spinal rotation; remarkably little rotation through the spine. Target obliques; synergists include TFL, gluteus medius and minimus, hip adductors, psoas, quadratus lumborum, iliocostalis; stabilisers include rectus abdominis, erector spinae, pectoralis major and minor, middle and lower trapezius, rhomboids, the lateral and posterior deltoid, triceps | Rotation muscles and stabilisers (lateral and posterior deltoid). Its feet and its hips-first comment differ from the model; see the rotation section |
| ExRx Cable Down-Up Twist (`CBDownUpTwist`, Wayback 2019-09-15) | A low pulley, arms straight, the stirrup pulled diagonally up around the shoulders by rotating the torso and raising the arms; feet wide, near heel raised; bends the knees slightly more near the top. Stabilisers include the anterior, lateral and posterior deltoid, quadriceps and gluteus maximus | Chop muscles and stabilisers (anterior deltoid, gluteus maximus, quadriceps). Its knees bend near the top, the model's straighten; the copy follows the model and Bodybuilding.com |
| ExRx Obliques muscle page (Wayback 2026-02-02) | Lumbar flexion (both sides); rotation right = left external with right internal, rotation left = right external with left internal; lateral flexion = both obliques of the same side; origin ribs 5-12, thoracolumbar fascia, iliac crest, inguinal ligament; insertion rectus sheath, iliac crest, inguinal ligament, pubic crest, ribs 8-12, linea alba | Which obliques turn which way; that a side bend is the obliques' movement; the ribs-to-pelvis attachments |
| ExRx Quadratus Lumborum muscle page (Wayback 2025-06-07) | Lateral flexion to its own side; from the iliac crest to the 12th rib and the upper four lumbar transverse processes | The quadratus lumborum's attachments in the hips cues |
| StrengthLog, Dumbbell Side Bend (read 2026-10-05) | Feet shoulder-width, a dumbbell in one hand, the other hand on the hip or by the side of the head; bend toward the dumbbell side, lowering it along the leg; keep the upper body in the same plane, no leaning forward or backward; pause at a comfortable depth, return with the obliques; controlled, no momentum | Same plane, along the leg, comfortable depth and pause, no momentum, one dumbbell |
| StrengthLog, Cable Machine Wood Chop (Low to High) | The handle as low as possible, sideways to the anchor, almost straight arms, a sweeping chop diagonally upward, a controlled return; obliques primary, abs secondary | Chop arms, return |
| StrengthLog, Horizontal Wood Chop with Cable | About shoulder height, almost straight arms, a sweeping horizontal movement, a controlled return; trains the rotating function of the obliques | Rotation arms, return |
| Bodybuilding.com, Standing cable low-to-high twist (Wayback 2023-01-06) | The lowest pulley, side to the cable, feet shoulder-width, squat down and take the handle in both hands, arms fully extended; pull it up and across until the arms are fully extended above the head, keeping the back straight, pivoting the back foot and straightening the legs; return slowly and under control | Chop squat start, leg drive, back-foot pivot, finish above the head |
| Andersson EA, Grundstrom H, Thorstensson A 2002, Spine 27(6):E152-E160, doi:10.1097/00007632-200203150-00014, PMID 11884920 (abstract) | Ten subjects, fine-wire EMG of eight trunk muscles in sitting and standing trunk rotations: the highest involvement on the side turned toward in resisted maximal twists, except the external oblique (opposite side dominant); rectus abdominis little activated in all rotations | External oblique works on the side opposite the turn (chop); rectus abdominis to the stabilisers (chop) |
| Andersson EA, Oddsson LI, Grundstrom H, Nilsson J, Thorstensson A 1996, Clin Biomech 11(7):392-400, doi:10.1016/0268-0033(96)00033-2, PMID 11415651 (abstract) | Seven subjects, fine-wire EMG: quadratus lumborum and the deep lateral erector spinae most active in ipsilateral trunk flexion lying on the side | Background for the quadratus lumborum in the stabilisers; not quoted in the copy |
| McGill SM 1991, J Orthop Res 9(1):91-103, doi:10.1002/jor.1100090112, PMID 1824571 (abstract) | 25 subjects; maximal isometric twisting: rectus abdominis 22%, external oblique 52%, internal oblique 55%, latissimus dorsi 74% of maximum; the latissimus and external oblique strongly involved through dynamic twists | The closest twisting EMG found; not used for any fraction and not quoted in the copy |

Rejected: Bordelon et al. 2021 (J Strength Cond Res 35(Suppl 1):S114-S119, PMID 33298714) is cited by
the library's Suitcase Carry for its trapezius value; its Europe PMC record has no abstract and the
full text was not reached, so none of its numbers are used here, only the library value it backs.

## Sibling and library check

- Library: Cable Wood Chop (high to low, cues arms / rotate / hips / pivot / brace, badge PULLING
  WITH THE ARMS), Russian Twist (badge ARMS ONLY), Side Plank, Suitcase Carry. The reverse chop's
  pivot cue covers the same idea as the library chop's ("Pivoting on the back foot lets the hips
  rotate without twisting the knee") in different words; its badge is LIFTING WITHOUT TURNING.
- No sentence of cue, setup or comparison copy repeats word for word within the family, with any
  string in SampleData.swift or with the other 401-500 families on disk (checked by script).
- Round-3 siblings, read 2026-10-05 as drafts while they were being written: the twist family's
  landmine rotations put the obliques at 0.78 and its Russian twists at 0.80 (this family 0.76-0.78);
  the carrymarch family's Suitcase Carry March has obliques 0.62, forearms 0.55 and erector spinae
  0.50 for a heavier one-sided load carried throughout, against this family's side bends at
  0.78 / 0.38 / 0.45, which bend the trunk against the load rather than hold it straight. Their
  final values may differ.

## Cable Side Bend

Model facts: right side to `GYM_M29`; the right carriage (`GYM_M29_Carriage_R`) at the bottom of its
track, pulley `CarriagePulley_R` 0.15-0.25 m up at x -0.56, z 0.02-0.05 (44 cm outside the right
ankle at x -0.12, level with it front to back); a stirrup handle (`GYM_M29_Handle_R`) in the right
hand; the cable (`HandleCable_R`) runs from the pulley to the hand. The right arm hangs straight
(elbow 172 deg), the wrist 0.91 m up at the start, beside the thigh (x -0.33, ~24 cm outside the
hip joint), palm facing in. The left hand rests behind the head: wrist ~10 cm behind, ~14 cm left
of and ~10 cm above the head joint, elbow 64 deg, the elbow out to the side above shoulder height.
Ankles 24 cm apart, toes out 8 deg each, knees 171-173 deg. Each rep: 0-1.25 s the chest bone
side-bends 24 deg to the right (lumbar 12, thoracic 12; flexion and twist components under 0.1
deg; the head moves with the chest), the neck-over-pelvis line 16 deg, the wrist down to 0.80 m
(11 cm, about the upper thigh); held to ~1.6 s; up through upright at ~2.35 s and on to 12 deg the
other way (line 8 deg) at 2.75-3.25 s; upright at 4 s. The pelvis does not tilt or turn and moves
~2 cm away from the lean. The stack is lifted ~10 cm at the start, ~4 cm at the bottom of the
lean, ~12 cm at the far lean (8 cm of travel).

| Claim | Source |
|---|---|
| The trunk bends straight to the side, toward the pulley and back, without tipping forward or turning | The model (above); StrengthLog Dumbbell Side Bend (same plane, no leaning forward or backward) |
| A sideways bend is the obliques' movement on one side; ExRx lists them as this lift's target and the quadratus lumborum among the helpers; tipping forward turns part of the rep into a forward bend | ExRx Obliques (lateral flexion, same side); ExRx Cable Side Bend (target obliques, synergists QL ...); the last clause is mechanics |
| Slide the right shoulder straight down toward the pulley, as if your back were against a wall | Coaching image for the frontal plane (StrengthLog's same plane); the model's chest turns 0 deg |
| The arm holding the handle hangs straight down from the shoulder; ExRx sets the lift up with the arm straight, so the handle rises only as far as the waist lifts it; bending the elbow or shrugging raises it with the arm instead | ExRx Cable Side Bend ("Stand with arm straight"); the model (elbow 172 deg all clip); the rest is mechanics. ExRx's stabilisers (upper and middle trapezius, levator scapulae) hold the shoulder girdle, which is why the trapezius is a row |
| Lean toward the pulley, then rise a little past upright; ExRx lifts the handle by bending away from the pulley and lowers it by leaning toward it; going past upright carries the far side of the waist through the end of its bend against the cable | ExRx Cable Side Bend (execution); the model (24 deg toward, 12 deg away; the stack stays lifted all clip, so the far side works against the cable all the way up); the last clause is mechanics |
| Lean until the handle is about halfway down your thigh | The model (the stirrup grip 0.82 m upright, beside the upper thigh, 0.70 m at the bottom of the lean; hip joint 0.91 m, knee 0.47 m, so mid-thigh 0.69 m) |
| The obliques run from the lower ribs to the top of the pelvis, the quadratus lumborum from the pelvis to the lowest rib and the lumbar spine; pushing the hips out lets the legs take part of the movement and the waist bends less | ExRx Obliques and Quadratus Lumborum attachments (the obliques' other attachments, linea alba and pubis, are left out as not relevant to a side bend); the consequence is mechanics; the model's pelvis moves ~2 cm |
| Weight even, knees soft, hips level; only the ribcage tilts | The model (knees 171-173 deg, pelvis level) |
| The cable pulls you toward the machine the whole time, so the way down is resisted too; StrengthLog's dumbbell side bend guide asks for control without momentum | Mechanics (the stack stays lifted all clip); StrengthLog Dumbbell Side Bend |
| A little over a second to lean toward the pulley, pause, rise smoothly past upright | The model (1.25 s, held ~0.35 s, back to upright in ~0.75 s, on to the far lean by 2.75 s) |
| Comparison: straight sideways keeps the work on the side of the waist, where the obliques and quadratus lumborum pull; tipping forward turns part of each rep into a forward bend | ExRx Obliques / QL (lateral flexion); mechanics |
| Setup: stirrup at the bottom of the track, right side to the machine a short step away; handle in the right hand (nearest the pulley), arm straight, cable taut; left hand behind the head, elbow out; feet about hip-width, knees soft; all reps, then the other side | The model (pulley 44 cm outside the ankle; stack lifted at the start; ankles 24 cm); ExRx ("near arm", "Continue with opposite side") |

## Dumbbell Side Bend

Model facts: the same body, stance (ankles 24 cm, toes out 8 deg, knees 172-175 deg), left hand
behind the head and timing as the cable side bend. A dumbbell (`HG_WeightR`, three cylinders: two
heads and the handle running front to back) in the right hand, arm straight (171 deg), palm facing
the thigh; its centre at 0.82 m beside the right thigh (x -0.31). The lean toward it reaches 26 deg
at the chest bone (lumbar 13, thoracic 13; line 18 deg) at 1.25 s, the dumbbell's centre down to
0.70 m (12 cm, x -0.42); held to ~1.6 s; up through upright at ~2.4 s and on to only 9 deg the
other way (line 6 deg) at 2.75-3.25 s. No forward lean or twist; the pelvis still (2 cm shift).

| Claim | Source |
|---|---|
| The chest keeps facing forward; StrengthLog asks you to keep the upper body in the same plane as you bend; turning toward the weight takes it out of that plane and mixes in a twist | StrengthLog Dumbbell Side Bend ("Keep your upper body in the same plane", which it explains as no leaning forward or backward; a twist is read as leaving the plane too, my reading); the model (twist under 0.1 deg) |
| One hand holds the dumbbell, the other rests behind the head | The model; StrengthLog (the other hand on the hip or by the side of the head) |
| A weight in one hand pulls you sideways, so the other side has something to lift against; with a dumbbell in each hand the two pull against each other and largely cancel out, so the bend has much less to work against; ExRx and StrengthLog both use one dumbbell | Mechanics; ExRx Dumbbell Side Bend ("Grasp dumbbell"); StrengthLog ("holding a dumbbell in one hand") |
| Lower the dumbbell down the outside of the leg as far as you comfortably can, pause, then rise a little past upright; StrengthLog lowers it along the leg to a comfortable depth and pauses before rising | StrengthLog Dumbbell Side Bend; the model (26 deg toward, 9 deg away, held ~0.35 s). ExRx bends AWAY from the dumbbell until a stretch is felt and then goes the same distance toward it; the model goes three times further toward the dumbbell than away, so the copy follows the model and StrengthLog and does not use ExRx's stretch (fixed in self-review: the draft credited ExRx with a stretch on the lowering) |
| A short dip leaves most of the bend undone, and with it most of the distance the other side of the waist lifts the weight | Mechanics |
| The obliques and quadratus lumborum run between the lower ribs and the top of the pelvis, so the bend has to happen above the hips; sliding the hips lets the dumbbell sink without the waist bending as far | ExRx Obliques / QL attachments; mechanics; the model |
| StrengthLog warns against using momentum to lift the dumbbell; bouncing out of the bottom throws the weight up | StrengthLog ("avoid using momentum to lift the dumbbell"); mechanics |
| Lower over a little more than a second, pause, lift back up smoothly | The model (1.25 s, ~0.35 s) |
| Comparison: one dumbbell pulls you sideways and the other side bends you back up against its pull; two dumbbells largely cancel (the mistake cue), each other's pull, leaving much less to lift against | Mechanics (at upright the two hands' pulls cancel; bent over, only the part from the shift of both hands to one side remains, so largely, not wholly) |
| Setup: one dumbbell in the right hand, arm straight, palm facing the thigh; left hand behind the head; feet about hip-width, knees slightly bent; the set on this side, then the left hand | The model; StrengthLog's feet are shoulder-width, the model's 24 cm, so the copy follows the model |

## Reverse Cable Wood Chop

Model facts: right side to `GYM_M29`; the right carriage at the bottom of its track (pulley
0.15-0.25 m up, x -1.0, z 0.16-0.19), ~1 m to the right of the lifter's midline and ~0.77 m from the
right ankle; a rope (`HG_RopeStrand*`, knobs, grips, clip) in both hands, the hands ~14-16 cm apart.
The arms stay straight (elbows 171 deg) all clip. Start (0 s, and 3.5-4 s): knees 125 deg (a shallow
squat: thighs ~29-32 deg off vertical, the pelvis 10 cm below standing; the inner hip angles 143 / 123 deg), pelvis 0.81 m, ankles 51 cm apart; the trunk leans 13
deg forward and 25 deg toward the pulley (the neck-over-pelvis line); the shoulder line faces 58 deg
and the hip line 30 deg right of the feet; the hands at 0.85 m, ~45 cm right of the midline, beside
the right hip; the left heel ~3 cm up (that foot turned 8 deg toward the right). The chop, 0-1.5 s:
the knees straighten to 171 deg (left) and 149 deg (right), the pelvis rises to 0.90 m, the
shoulders turn to 50 deg left (108 deg in all) and the hips to 28 deg left (58 deg in all, the
shoulders ~50 deg past the hips), the trunk comes upright (line 0 deg forward, 5 deg left); the
hands stay within ~13 deg of straight in front of the chest and rise from 42 cm below to 35 cm
above the shoulders (1.77 m, ~31 cm left of them, above the head joint at 1.59 m); over ~0.63-0.85 s
the right heel lifts ~6 cm, and over ~0.75-1.25 s the right foot turns 32 deg on its ball (-12 ->
+20 deg), the left heel (~3 cm up at the start, that foot turned 8 deg toward the pulley) having come
down over 0.5-0.65 s while the left foot turned to +12 deg. Held 1.5-2.0 s, lowered by 3.5 s, rest at the bottom to 4 s; both
reps low right to high left. The stack rises ~40 cm.

| Claim | Source |
|---|---|
| The arms stay long from the low start to the high finish; StrengthLog's low-to-high chop keeps the arms almost straight; long arms keep the rope at arm's length, so the legs and the turn of the trunk drive it; bent elbows turn the top of the chop into an arm pull | The model (171 deg); StrengthLog Cable Machine Wood Chop (Low to High); mechanics. (Self-review: the draft said the rope moves only as far as the legs and trunk carry it, but the model's shoulders also raise the arms ~80 deg against the chest; removed) |
| Hands in front of the chest, from the right hip to above the left shoulder | The model (within 13 deg of straight ahead of the chest; hip height to 35 cm above the shoulders) |
| The chest turns with the rope, from angled toward the pulley to angled away from it; turning left uses the right external with the left internal oblique; in a study of maximal resisted trunk twists the external oblique was most active on the side opposite the turn; raising the rope without turning leaves the lift to the shoulders | The model (shoulders 58 deg right -> 50 deg left; the pulley is ~82 deg right of the start's pelvis, so angled toward it rather than facing it); ExRx Obliques; Andersson 2002 (abstract: highest activity on the ipsilateral side in maximal twists with shoulder resistance, except the external oblique, contralateral-dominant; the review narrowed the copy from trunk rotations in general to resisted twists, since the abstract says the patterns changed with the task, and the verification to maximal resisted twists, the only condition the abstract reports it for); the last clause is mechanics |
| Until the chest faces well to the left of the feet at the top | The model (shoulder line 50 deg left; the feet's ankle line -6 deg, toes +12 / +20 deg) |
| Start in a shallow squat and stand up as you chop; a guide to the standing low-to-high cable twist squats down to take the handle with straight arms and straightens the legs as it comes up and across; reaching down with straight legs bends the back over and leaves the legs out (mistake: straight legs, the back bent over, as the ghost draws it) | The model (knees 125 -> 171 / 149 deg, pelvis +9 cm); Bodybuilding.com ("squat down", "arms should still be fully extended", "straighten your legs"); the last clause is mechanics |
| Sit into a shallow squat with the chest up, the rope beside the right hip | The model (knees 125 deg, thighs ~30 deg off vertical, pelvis 0.81 m against 0.91 m standing, trunk 13 deg forward, hands at hip height out to the right of the right hip) |
| The right heel lifts as the rope rises past the chest and the foot turns on its ball as you finish the chop; the same guide pivots the back foot for the full range; turning on the ball lets the hips follow the chest, with the foot fixed the knee takes the twist (mistake: the right foot left pointing where it started, the knee caving in) | The model (right heel ~6 cm over ~0.63-0.85 s while the hands pass the chest; the foot's 32 deg turn over ~0.75-1.25 s, the chop ending at 1.5 s); Bodybuilding.com ("pivot your back foot ... to get a full range of motion"); the last clause is mechanics |
| As the hands pass the chest, let the right heel come up | The model (the right heel rises over ~0.63-0.85 s, while the hands rise past the chest, ~1.15-1.45 m) |
| StrengthLog asks for a controlled return; the stack pulls the rope back toward the low pulley, so letting it go drops you into the squat twisting fast | StrengthLog (Low to High: "Return to the starting position in a controlled manner"); Bodybuilding.com (slow and controlled); mechanics |
| About a second and a half up, hold the top a moment, about as long down | The model (1.5 s, 0.5 s, 1.5 s) |
| Comparison: turning the ribcage as the rope rises makes the trunk carry the load; raising it in front without turning hands the lift to the shoulders and arms | Mechanics; ExRx Obliques (rotation) |
| Setup: rope at the bottom of the track, right side to the machine a long step away; feet wider than the shoulders; shallow squat, turned toward the pulley, rope ends beside the right hip, arms straight; every rep up to above the left shoulder, then the other side | The model (ankles 51 cm; ~0.77 m from the pulley); Bodybuilding.com's feet are shoulder-width, the model's wider, so the copy follows the model |

Activation: Obliques 0.78 PRIMARY (bright; the library's Cable Wood Chop; StrengthLog primary),
Gluteus Maximus 0.45 MODERATE SECONDARY (dim; the hips extend out of the shallow squat and turn; ExRx
stabiliser of the down-up twist), Anterior Deltoid 0.40 MODERATE SECONDARY (dim; the straight arms
are raised ~80 deg at the shoulders against the cable; ExRx stabiliser of the down-up twist); all
judgement calls. Stabilisers: rectus abdominis (dim; Andersson 2002 found it little activated in
rotations; legend width), gluteus medius (dim; ExRx synergist), quadriceps and erector spinae (ExRx
stabilisers). The gluteus minimus is painted dim but named nowhere (see Verification). The library row's OBLIQUES / CABLE / intermediate fits.

## Cable Rotation

Model facts: right side to `GYM_M29`; the right carriage set mid-track (carriage block 1.07-1.25 m,
pulley ~1.16 m up, x -1.0, z 0.16-0.19), ~1 m to the right; the lower pectoral attachment
(`support_PectoralisMajor_Abdominal_*`) sits at 1.20 m and the shoulder joints at 1.42 m, so the
pulley is about the bottom of the chest. A rope in both hands, the hands ~17 cm apart at 1.30 m
(12 cm below the shoulder joints) and ~51 cm from the shoulders' midpoint, elbows 152 deg; the hands
stay exactly in front of the chest all clip (their direction from the shoulders matches the chest's
facing to 0.0 deg), so only the trunk moves them. Ankles 32 cm apart (the hip joints 18 cm), toes
out 8 deg, knees 163-166 deg, both heels down all clip. Start: the shoulder line faces 36 deg and the
hip line 12 deg toward the pulley; 0-1.5 s the shoulders turn to 44 deg left (80 deg in all) and the
hips to 14 deg left (26 deg in all; per bone: pelvis 26, lumbar 27, thoracic 27 deg); held to
2.0 s; back by 3.5-3.75 s; both reps to the left. Trunk lean 5-7 deg forward, side tilt within 5 deg,
the shoulders level (both 1.42 m). The stack rises ~39 cm.

| Claim | Source |
|---|---|
| Arms long, elbows softly bent, hands in front of the breastbone | The model (152 deg; hands fixed in front of the chest) |
| Held at arm's length the rope pulls across the body far from the spine, so turning against it takes more from the trunk; StrengthLog's horizontal chop keeps the arms almost straight; pulling the rope in shortens that lever | Mechanics (moment arm of the cable about the spine's long axis); StrengthLog Horizontal Wood Chop with Cable |
| Let the trunk carry the hands round | The model (the arms never move against the chest) |
| The hands travel level at chest height; with the pulley near chest height the rope pulls across the body rather than up or down it; holding the arms up in front against that pull is work for the shoulders; ExRx lists the deltoids among the stabilisers of its standing cable twists | The model (hands at 1.30 m all clip; pulley 1.16 m, ~1 m away); mechanics; ExRx Cable Twist (lateral and posterior deltoid) and Down-Up Twist (anterior, lateral, posterior) |
| Turn from angled toward the pulley to well past the middle; turning left uses the right external with the left internal oblique; the ribcage turns much further than the hips, the twist of the waist the obliques make; stopping as the hands reach the middle leaves out the end | The model (shoulders 36 deg toward the pulley -> 44 deg away, 80 deg in all; hips 26 deg); ExRx Obliques (rotation); mechanics. ExRx's cable twist comment says its version turns mostly at the hips with little spinal rotation and raises the near heel; the model keeps both heels down and turns the shoulders three times as far as the hips, so the copy follows the model |
| Turn until the hands are out beyond the left hip, hold a moment | The model (hands at x 0.34-0.46, the left hip at 0.09; held 1.5-2.0 s) |
| Stand tall without leaning away; the obliques turn the ribcage around the spine; leaning sideways lets body weight drag the rope and swaps part of the turn for a side bend | The model (side tilt within 5 deg, shoulders level); ExRx Obliques; mechanics |
| StrengthLog asks for a controlled return on the horizontal chop; the cable pulls you back, so a slow return keeps the trunk working on the way back | StrengthLog; mechanics |
| About a second and a half away, pause, about as long back | The model (1.5 s, 0.5 s, 1.5 s) |
| Comparison: arm's length keeps the rope far from the spine, a longer lever; pulling it in shortens the lever | Mechanics |
| Setup: pulley about the bottom of the chest, rope, right side to the machine a long step away; feet a little wider than hip-width, toes out a little, knees soft; rope ends in front of the chest, arms long, the cable turning the shoulders toward the pulley; every rep to the left, then the other side | The model; StrengthLog sets the pulley at about shoulder height, the model's sits ~26 cm lower, so the copy follows the model |

Activation: Obliques 0.76 PRIMARY (bright; the library's Russian Twist; StrengthLog trains the
obliques' rotating function), Anterior Deltoid 0.45 and Lateral Deltoid 0.40 PRIMARY (both bright,
so primary by the house rule, but they only hold the arms up in front against the cable, so they
sit at the bottom of the moderate band; ExRx lists the lateral and posterior deltoid among the
cable twist's stabilisers and the anterior among the down-up twist's); judgement calls. Stabilisers:
rectus abdominis, erector spinae, gluteus medius, posterior deltoid (ExRx, unpainted). The library
row's OBLIQUES / CABLE / beginner fits.

## Side bend activation

Obliques 0.78 PRIMARY (bright; ExRx target; the library's Side Plank, which holds the trunk up against a
sideways bend), Erector Spinae 0.45 MODERATE SECONDARY (dim; ExRx's iliocostalis lumborum and thoracis
synergists are the erector spinae's lateral column; a little under the Suitcase Carry's 0.50),
Trapezius 0.40 MODERATE SECONDARY (dim; ExRx's upper and middle trapezius stabilisers hold the
shoulder girdle against the weight; a little under the Suitcase Carry's 0.44), Forearms 0.38 LOW
SECONDARY (dim; the grip on the handle or dumbbell; well under the Suitcase Carry's forearm flexors
0.55, which hold a heavier dumbbell for a whole walk). All judgement calls. Stabilisers: quadratus
lumborum (ExRx synergist, no mesh on the rig), rectus abdominis and rhomboids (dim; legend width; not
listed by ExRx), gluteus medius (ExRx stabiliser). The library rows OBLIQUES / CABLE and DUMBBELL /
beginner fit.

## Labels

All rows are on-screen rows (the spec writes them with `ov()`). Pills were drawn over the five
stills with `overlay.py`.
- Cable side bend (yaw 0.4): the cable tower stands at the left edge (u < 0.08) and the cable runs
  from the right hand (u ~0.25, v ~0.5) to the pulley at the bottom left; the left elbow reaches
  u ~0.77 at v ~0.2; the right of the screen is free below v ~0.3. Bend sideways only 0.12 left
  (over the head) to the head; Arm hangs long 0.20 left to the right shoulder; Lower slowly 0.84
  left (over the tower's base, under the cable, left of the right shin) up to the handle hand;
  Past upright 0.36 right to the left shoulder; Hips still 0.52 right to the left hip.
- Dumbbell side bend (yaw -0.3): the dumbbell hangs at u ~0.12-0.33, v ~0.48-0.62; the left elbow
  reaches u ~0.79 at v ~0.2. Free hand behind head 0.12 left, down to the hand behind the head;
  Full bend 0.76 left (under the dumbbell, left of the right shin), its leader up through the
  dumbbell to the hand; Chest square 0.36, No swinging 0.44 and Hips level 0.52 right, to the
  chest, the lower back and the left hip.
- Reverse chop (yaw 0.5): the cable sweeps from the bottom left to the hands, beside the right hip
  at the start and at the top right at the top. Slow on the way down 0.14 left to the head (above
  the head at every still); Arms long 0.40, Chest turns 0.50 and Legs drive up 0.64 right, to the
  left shoulder, the chest and the left knee (below the hands at the top); Pivot 0.80 left, five
  characters so it clears the right shoe (u >= 0.23 there), to the right ankle.
- Cable rotation (yaw 0.5): the cable enters at the left edge (v ~0.28-0.36) and the arms sweep out
  to u ~0.85 at v ~0.24-0.36. Stand tall 0.14 and Hands chest high 0.21 right, above the arms, to
  the head and the left hand; Arms long 0.42 right, below the arms, to the left elbow; Turn fully
  0.14 left, beside the head, to the right shoulder, which swings round from the pulley side; Slow
  return 0.74 left to the right knee. Every hand-tracked leader is long at one end of the turn;
  tracking the left elbow and left hand from the right keeps them short at the end of the turn,
  where the reps hold.

## Ghosts

Sizes and checks are in the table comments of the faults file (from `final.py`). Every drawn segment
keeps its length within 5 mm at the fault's moment and at 0.5, 1, 2 and 3 s, and no knee or elbow
changes the side it bends to. Strengths:
- Side bends: the neck-to-right-hip distance (1.01 upright, 0.97 / 0.96 at the bottom, 1.03 at the
  cable's far lean), so the lean faults show only toward the weight and the cable's range fault
  only on the far lean.
- Chop: the left hand's distance from the right hip (0.78 low, 1.33 with the hands at the chest,
  1.65 at the top). Rotation: the left hand's distance from the left hip (1.20 -> 1.09).
- Cable side bend: plane (library `leanedForward` 20 deg, seen from the lifter's left, a total yaw
  of -1.1: face-on it read 26 pt at the head, from the side ~53 pt; the station's frame stands
  behind the lifter in that view); arm (the right shoulder shrugged ~7 cm toward the ear, the arm
  carried, and the elbow bent 60 deg, 172 -> ~119 deg; the neck-to-shoulder line shortens 2 cm,
  which is the shrug); range (the 12 deg far lean
  taken out, 6 deg at each spinal joint); hips (everything from the hips up ~8.5 cm left and ~1 cm
  down: the 3.5 cm drop, less the rise of the leaning body's left axis; both knees re-seated:
  without the drop the near-straight legs could not reach the feet and stretched ~1.5 cm). Tempo has no ghost.
- Dumbbell side bend: twist (30 deg about the trunk's length toward the dumbbell, seen 0.3 further
  from the left, a total of -0.6, where the shoulder line shortens most, ~87 -> ~60 pt, and the
  dumbbell hand's ~24 cm reads ~45 pt; nearly side-on, a total of -1.3, the shoulder line hardly
  changed); free
  (the left arm brought down from behind the head to hang like the right one by six turns, sized
  upright: a shift-built version stretched the arm 3-4 cm once the trunk bent, because the chest
  turns 26 deg while the body frame tilts 18 deg; stilled at 0.1 s); depth (half the 26 deg lean
  taken out); hips (as the cable's). Tempo has no ghost.
- Reverse chop: arms (the hands ~15 cm back toward the chest at 0.75 s, the elbows re-seated
  171 -> ~95 deg); turn (45 deg back toward the pulley at the top, the chest about square; seen 0.3 round toward
  the left since the review, a total of 0.2); legs (at
  the bottom the hips ~9 cm higher, the knees 125 -> ~161-164 deg, the trunk 25 deg further over);
  pivot (the right ankle turned about the ball of the foot 32 deg back toward where it pointed at
  the start and 8 deg down, the heel ~2 cm lower, and the right knee pushed ~13 cm toward the
  midline and re-seated, 149 -> ~151 deg: the knee caving in over a foot that has not turned; seen
  0.6 round toward the left, a total of -0.1, where the knee's move reads ~26 pt; the heel stays
  ~4 cm up, since a heel put fully down leaves the leg short of the floor with the hips this high,
  locking the knee and stretching both bones ~1 cm). Return has no ghost.
- Cable rotation: arms (the hands ~15 cm in, elbows 152 -> ~91-104 deg); height (library
  `armsTurned(.lateral, -25)`, the hands ~17-22 cm lower); turn (40 deg back toward the pulley at
  the end of the turn, the shoulders ending about square, the hands in front of the chest; seen 0.3
  round toward the left since the review, a total of 0.2); tall (15 deg sideways away from the
  pulley, the head ~18 cm). Return has no ghost.

## Lab rounds

- Compile check (`family.sh check sidebend`): built on the first run.
- Round 1 (`family.sh shoot sidebend "0,1.5,3"`, kept in `SCRATCH/sidebend/round1/`): every trainer
  still had its five pills clear of the lifter and of moving equipment (the cable side bend's tempo
  pill over the tower's static base, the dumbbell's Full bend leader through the dumbbell to the
  hand, as planned); the secondary legend fits on one line for all four; the cable rotation's
  primary line truncates to OBLIQUES · ANTERIOR DELTOID · LATERAL DELT..., like the library's other
  three-primary rows. Ghosts: thirteen of sixteen read as their mistakes. Three did not: the cable
  side bend's arm (the elbow bent alone, 70 deg, folded the forearm toward the camera and read as a
  short forearm), the chop's pivot (seen from the lifter's right side, the cable tower stood
  between the camera and the lifter; the leg straightened rather than showing the knee) and the
  dumbbell twist (25 deg seen from -0.9 read faintly). The cable side bend's plane ghost, seen from
  the lifter's left, has the station's frame behind the lifter; it reads (the yellow trunk tipped
  ~52 pt forward) and was kept.
- Round 2 (`shoot sidebend "0,1.5,3"`, `round2/`): the arm ghost now shrugs the shoulder ~7 cm and
  bends the elbow 60 deg, and reads as the arm pulling up; the pivot ghost keeps the foot pointing
  where it started with the knee caving ~13 cm toward the midline, seen nearly face-on, and reads;
  the twist seen from -1.3 still read weakly (the shoulder line hardly changes nearly side-on).
- Round 3 (`shoot sidebend "0,1.5,3" "Dumbbell Side Bend"`, `round3/`): the twist at 30 deg, seen
  from -0.6 in total: the ghost's shoulder line shortens and the dumbbell arm swings back in toward
  the body, which reads as the chest turning toward the weight. The dumbbell's other ghosts and its
  trainer stills unchanged. BUILD SUCCEEDED on every run; the final shots for the other three are
  round 2's.

## Self-review (author, 2026-10-05)

- Sources: every cited page was saved and re-read against the copy. Fixed while drafting: the
  dumbbell range cue credited ExRx with a stretch on the way down (ExRx's stretch is on the bend
  away from the dumbbell; now StrengthLog's comfortable depth only); the cable tempo cue said
  "StrengthLog's side bend guide" (it is the dumbbell side bend's); the dumbbell twist cue said
  StrengthLog asks for the trunk to stay in one plane "through the side bend" in a way that read as
  a quote about twisting (StrengthLog's plane line is about leaning forward or back; the twist is
  my reading, and the copy now says the twist takes the trunk out of that plane); the deltoid
  stabilisers are now credited to the two ExRx cable twists they come from.
- Model fidelity: the chop's arms cue said the rope moves only as far as the legs and trunk carry
  it, but the model's arms also rise ~80 deg at the shoulders; reworded. The chop's turn mistake
  said the chest keeps facing the pulley, while its ghost leaves the chest facing about forward;
  now "stays facing forward". The cable plane mistake said tipping forward or turning, but the
  ghost only tips; now tipping only. The pivot intro said the heel lifts as you finish the chop; it
  lifts mid-chop (0.65-0.85 s), now "as the rope rises past your chest". Setup feet widths follow
  the measured ankles (24, 51 and 32 cm against hip joints 18 and shoulder joints 39 cm apart).
- `python3 spec_500.py sidebend` prints OK (4 exercises); no sentence of the copy repeats one in
  SampleData.swift, in the other 401-500 families or within this family.

## Open points and shared requests

- The cable rotation's primary legend line (three bright muscles, 45 characters) truncates to
  OBLIQUES · ANTERIOR DELTOID · LATERAL DELT... on the simulator, the README's known open point for
  three-primary rows; the library's muscle names were kept rather than shortened.
- The chop's pivot label is "Pivot": the corner left of the right foot fits five characters.
- The chop's and the rotation's arm ghosts (the hands pulled ~15 cm in, the elbows bending) read
  moderately: the arms point partly toward the camera at those moments. The cable side bend's plane
  ghost is seen against the station's frame.

- `common_1_50.part_of()` files "Quadratus Lumborum" under quads ("quad" matches first), while the
  app (`MusclePart.init(muscleName:)`) files it under the lower back; not used as a row here (it is
  in the stabilisers), but a family that rows it would pass validation with the wrong group.
- The models give no reason to change the library rows (OBLIQUES; CABLE, DUMBBELL, CABLE, CABLE;
  beginner, beginner, intermediate, beginner) or the movement patterns (`ExerciseRotation` already
  files side bends, wood chops and cable rotations as trunk rotation); no timed or bodyweight flag.

## Review (independent, 2026-10-05)

Two passes after the author finished, sources and claims, then fidelity to the models. Working files
are in `SCRATCH/sidebend/review/` (the four files and the author's last lab output as they stood
before the review in `review/before/`).

Sources, re-fetched independently rather than from the author's copies (`review/src/`):
- Europe PMC REST records of Andersson 2002 (PMID 11884920), Andersson 1996 (PMID 11415651) and
  McGill 1991 (PMID 1824571): authors, years, journals, volumes, issues, pages and DOIs as cited;
  ten, seven and 25 subjects; McGill's 22 / 52 / 55 / 74% for the rectus abdominis, external and
  internal oblique and latissimus dorsi in maximal isometric twisting efforts; Andersson 2002's
  ipsilateral dominance in maximal twists with shoulder resistance except the external oblique
  (contralateral) and the little-activated rectus abdominis; Andersson 1996's quadratus lumborum
  and deep lateral erector spinae peaking in side-lying ipsilateral trunk flexion. The
  Oliva-Lozano and Muyor 2020 review (PMC7345922) exists and its full text has no side bend, chop,
  Pallof or cable-rotation data. Further Europe PMC searches (chop / wood chop, side bend, lateral
  flexion exercises, cable rotation, Pallof press, each with EMG) found no EMG of these four lifts
  either, so the fractions stay judgement calls.
- ExRx through the Wayback Machine at the cited snapshots (20190720012153, 20180810111420,
  20190821232435, 20190915124100, 20260202082020, 20250607120559): every quote and paraphrase in the
  notes and header is on its page (set-ups, execution, the cable twists' hips-first comment and
  raised near heel, the down-up twist's knees bending more near the top, target, synergists and
  stabilisers; the Obliques page's rotation pairs, 1 = external, 2 = internal; the attachments).
  StrengthLog's three pages re-fetched live (wording as cited: same plane, along the leg, pause at
  a comfortable depth, no momentum; the chops' almost straight arms and controlled return; the
  horizontal chop's shoulder-height pulley); Bodybuilding.com's standing cable low-to-high twist at
  the 20230106042925 snapshot (shoulder-width feet, squat down with the arms fully extended, pivot
  the back foot and straighten the legs, finish above the head, slow return).
- Library anchors re-read in SampleData.swift: Side Plank obliques 0.78; Suitcase Carry obliques
  0.60, forearm flexors 0.55, erector spinae 0.50, trapezius 0.44; Cable Wood Chop obliques 0.78,
  rectus abdominis 0.44; Russian Twist obliques 0.76. Paint re-read in `tiers.txt`: the activation
  rows follow it (bright primary, dim secondary or, for legend width, stabilisers as in the
  cablecrunch and calfstand families); every level matches its fraction; every fraction is marked a
  judgement call.
- The shared request checked: `MusclePart.init(muscleName:)` tests "quadratus lumborum" before
  "quad" (lower back) and `part_of()` does not (quads), and the library's own Side Plank has a
  Quadratus Lumborum row, so the mismatch is real.

Models re-measured from the USD files with my own scripts (`review/rig/dump.py`: joints every frame
and equipment bounds with Blender's Python + pxr; `a1.py`-`a4.py`), not the author's dumps.
Confirmed: torso 0.59 m; the side bends' pure lateral bends (chest bone 24 / 26 deg toward the
weight at 1.25-1.6 s, lumbar half of it, 12 / 9 deg the other way at 2.75-3.25 s, flexion and twist
0.0, pelvis still, the neck-to-shoulder distance constant, so no shrug), the left hand 14 cm left,
10 cm behind and 10 cm above the head joint, ankles 24 cm, the cable pulley 44 cm outside the right
ankle, the stack lifted all clip; the chop's half squat (knees 125 deg, pelvis 0.81 -> 0.90 m),
shoulders 58 deg right -> 50 deg left and hips 30 -> 28, arms 171 deg, hands from hip height ~46 cm
right of the midline to 1.77 m, 31 cm left of and 35 cm above the shoulders, stack +40 cm; the
rotation's pure turn about the vertical (pelvis 26, lumbar 53, chest 80 deg at 1.4-2.0 s), hands
fixed at 1.30 m, elbows 152 deg, pulley 1.11-1.21 m, shoulders level at 1.42 m.

Changed, copy (model fidelity):
- Cable side bend range, correct line: "Lean until the handle is beside your upper thigh" cued the
  bottom by where the handle already is upright (the stirrup grip is at 0.82 m standing, beside the
  upper thigh); at the bottom of the lean it is at 0.70 m, about mid-thigh (hip joint 0.91, knee
  0.47 m). Now "about halfway down your thigh".
- Cable side bend arm intro: "hangs straight from a relaxed shoulder" sat oddly with the trapezius
  row (ExRx's upper and middle trapezius stabilisers); the model's shoulder neither shrugs nor
  drops, so the line now says the arm hangs straight down from your shoulder.
- Reverse chop legs: the mistake said straight legs and a rounded back, but the ghost tips a
  straight trunk 25 deg further over; the mistake and the why now say the back is bent over.
- Reverse chop pivot: the mistake said the right foot stays flat and planted, but the ghost (rightly:
  with the hips this high a heel put fully down leaves the leg short of the floor, so the knee locks
  and both bones stretch ~1 cm, checked in the port) leaves the heel ~4 cm up and turns the foot back
  to where it pointed; the mistake is now the foot left pointing where it started, and the why says
  with the foot fixed. The intro now splits the timing as the model has it: the heel lifts as the
  rope passes the chest (0.63-0.85 s) and the foot turns on its ball as the chop finishes
  (0.75-1.25 s).
- Reverse chop and cable rotation turn intros: "from facing the pulley" overstated the start (the
  shoulders face 58 and 36 deg toward a pulley ~82-84 deg to the right); now "angled toward".

Changed, copy (sources and mechanics):
- Reverse chop turn why: "in a study of trunk rotations the external oblique worked hardest on the
  side opposite the turn" generalised Andersson 2002, whose abstract gives that pattern for maximal
  twists with shoulder resistance and says the patterns changed with the task; now "in a study of
  resisted trunk twists ... was most active".
- Cable side bend range why: going past upright "makes the far side of your waist bend the trunk
  against the cable" implied the far side only works past upright; the stack stays lifted all clip,
  so it works all the way up. Now going past upright carries it through the end of its bend.
- Cable side bend hips why: "tips your whole body" (the ghost moves the hips sideways, it does not
  tip anything) is now "lets your legs take part of the movement".
- Dumbbell one-dumbbell why and comparison: two dumbbells "balance each other" and leave "little to
  lift against" overstated the mechanics (their pulls cancel upright; bent over, the shift of both
  hands to one side still loads the bend). Now they largely cancel out and leave much less.
- Spec header and notes model facts: the handle's height through the cable lean, the chop's heel
  and foot timing (and the left heel's start ~3 cm up, foot turned 8 deg toward the pulley).

Changed, ghosts (sizes re-solved in my own port of `FaultGhost.solve`, `review/rig/gport.py` with
`table.py`, a DLT camera fitted to `joints.json` at 0.4-1.1 pt mean error; it agrees with the
author's sizes to the millimetre and the point):
- Both turn ghosts (`turn` of the chop and of the cable rotation) are now seen 0.3 round toward the
  lifter's left (a total of 0.2). In the framing the rotation's squared-up arms pointed almost at the
  camera, so the ghost hands sat only ~40-70 pt from the model's and the lab shot read weakly; from
  0.2 they land in front of the chest, ~68-92 pt away, with the shoulder line still ~62 -> ~102 pt.
  The chop's hands move ~50-54 pt instead of ~31-42 pt (shoulder line ~48 -> ~92 pt).
- Comments only: the side bends' hips ghosts move the hips ~1 cm down, not 3.5 cm (the body's left
  axis tilts up while the trunk leans, taking up most of the drop); the pivot ghost's partly raised
  heel is explained.
- Left as they were, checked in the port: every other size in the ghost comments; every drawn
  segment keeps its length within 5 mm at the fault's moment and at 0.5, 1, 1.4, 2, 3 and 3.75 s
  except the arm ghost's deliberate 2 cm neck-to-shoulder shrug; no knee or elbow flips the side it
  bends to; the strengths show the lean faults only toward the weight and the range fault only on
  the far lean; the moments (1.4 s deepest lean, 3.0 s far lean, 0.1 s upright, 0.75 / 1.6 / 3.75 s
  on the chop, 1.6 s on the rotation's hold).

Left as they were, checked: the labels (every pill clear of the lifter and of moving equipment at
0 / 1.5 / 3 s; the cable side bend's Arm hangs long pill ends ~2 pt from the head at the deepest
lean; the rotation's hand leaders cross the left shoulder at the start, where the hands are in front
of the chest); the setup steps; the stabilisers; the library rows; the open points the author
listed (the rotation's three-primary legend truncates; the chop's and rotation's arm ghosts read
moderately; the cable side bend's arm ghost folds the forearm partly toward the camera and reads as
the arm drawn up, moderately).

Review lab round (`family.sh shoot sidebend "0,1.5,3"`, log `review/shoot_review1.log`, output copied
to `review/review_round1/`): BUILD SUCCEEDED; all 12 trainer stills and 16 ghosts shot. The trainer
stills match round 2's (no label, row or tracked joint changed). The rotation's turn ghost now ends
with the squared-up arms in front of the chest, ~80 pt short of the model's hands, the dashed guides
running out to them, which reads as stopping at the middle; the chop's turn ghost shows the broad,
square shoulder line with the arms raised straight up in front of the face (its hands still reach
the COMMON MISTAKE chip, the README's open point). The chop's legs and pivot mistake views carry the
new mistake lines, which now match their ghosts. The other twelve ghosts are unchanged. No further
round was needed.

## Verification (final skeptic, 2026-10-05)

A claim-by-claim pass over the copy (cue intros, whys, mistakes, corrects, comparisons, setup
steps), the spec's activation comments and header, and the sources table. Working files are in
`SCRATCH/sidebend/skeptic/` (the four files as they stood before this pass in `skeptic/before/`).

Sources, fetched again myself (`skeptic/src/`), not from the author's or the reviewer's copies:
- Europe PMC REST records of Andersson 2002, Andersson 1996, McGill 1991 and Bordelon 2021: authors,
  journals, volumes, pages, DOIs and subject counts (10, 7, 25) as cited; McGill's 22 / 52 / 55 / 74%;
  Andersson 2002's pattern holds only "in maximal trunk twists with shoulder resistance"; Andersson
  1996's quadratus lumborum peak in side-lying ipsilateral trunk flexion; Bordelon has no abstract.
  The Oliva-Lozano and Muyor 2020 full text (PMC7345922) has no side bend, chop or cable rotation.
- ExRx at the six cited Wayback snapshots: every quote, set-up, execution step, comment, target,
  synergist and stabiliser named in the copy, the header and the table is on its page (the obliques'
  rotation pairs, lateral flexion by both obliques of one side, their attachments; the quadratus
  lumborum's iliac crest to 12th rib and upper four lumbar transverse processes).
- StrengthLog's three pages live (same plane, along the leg, pause at a comfortable depth, no
  momentum, the other hand on the hip or by the head; the chops' almost straight arms, controlled
  return, the low-to-high's obliques primary / abs secondary, the horizontal one's shoulder height
  and rotating function) and Bodybuilding.com's low-to-high twist at 20230106042925 (squat down, arms
  fully extended, up and across to above the head, pivot the back foot and straighten the legs,
  slow and controlled return).
- Library anchors in SampleData.swift (Side Plank 0.78; Suitcase Carry 0.60 / 0.55 / 0.50 / 0.44;
  Cable Wood Chop 0.78 / 0.44; Russian Twist 0.76), the library chop's pivot line and badges, the
  round-3 siblings' values (twist 0.78 / 0.80; carry march 0.62 / 0.55 / 0.50) and `tiers.txt`.
- Own Europe PMC searches (wood chop, side bend with dumbbell or cable, cable rotation, chop and
  lift, each with EMG) found one EMG study of a cable wood chop, Vasudevan et al. 2016, which
  recorded only the order of muscle onsets; no study gives activation levels for these lifts.

Models, re-measured from the USD files with my own pxr scripts (`skeptic/rig/dump.py`, `L.py`):
every model number the copy relies on matched (lean 24 / 26 deg toward the weight at 1.25-1.6 s,
lumbar and thoracic halves, 12 / 9 deg the other way at 2.75-3.25 s, flexion and twist 0.0, pelvis
still and ~2 cm off centre; the stirrup grip 0.82 -> 0.71 m against hip 0.91 and knee 0.47 m; the
stack lifted 4-12 cm all clip; the dumbbell lengthwise, 0.82 -> 0.70 m; the chop's knees 125 ->
171 / 149 deg, pelvis 0.81 -> 0.90 m, shoulders 58 deg right -> 50 deg left, hips 30 -> 28, elbows
171 deg, the right heel up over 0.63-0.85 s and the foot turned -12 -> +20 deg on a fixed toe joint
over 0.75-1.25 s, the knee then pointing 14 deg against the foot's 20; the rotation's shoulders 36
deg right -> 44 deg left, hips 26 deg in all, hands at 1.30 m exactly in front of the chest, no
side lean in the shoulders' own frame, pulley 1.11-1.21 m against the lower pectoral attachment at
1.20 m). The ghosts were not re-solved here (the reviewer's independent port agrees with the
author's).

Changed (text only; no label, cue id, tracked joint, ghost or moment changed, so no shoot):
- Reverse chop: half squat -> shallow squat in the legs intro, the legs correct line and the setup.
  The model's start bends the knees only to 125 deg (55 deg of flexion), with the thighs 29-32 deg
  off vertical (a third of the way to parallel, not half) and the pelvis 10 cm below standing, so
  half squat overstated the depth (my reading of the term; no source defines it for this lift).
  Header, activation comment and notes rows follow.
- Reverse chop turn why: a study of resisted trunk twists -> maximal resisted trunk twists; the
  abstract reports the contralateral external oblique only for maximal twists with shoulder
  resistance. The header's Andersson 2002 summary now carries the same condition.
- Dumbbell comparison mistake cue: Two dumbbells balance out -> Two dumbbells largely cancel, to
  match the reviewer's softened note (the pulls cancel upright, not wholly once bent over).
- Activation comments: the side bends' comment said Erector Spinae, Trapezius and Forearms sit each
  a little under the Suitcase Carry, but Forearms 0.38 is well under its 0.55 (now just under; the
  Suitcase Carry's dumbbell is the heavier one on the models, 23.6 cm plates three a side against
  16 cm heads); the Side Plank is a hold against a sideways bend, not a side-bending lift (spec and
  notes). The chop's comment said the gluteus medius and minimus are named in the stabilisers; only
  the medius is. The comment now says so; the dim gluteus minimus is left unnamed (an open point,
  not added, since this pass adds no claims).
- Spec header: the rotation's hands are ~17 cm apart, not together. Sources table: McGill 1991 is
  not background for any fraction (none is taken from it). The no-EMG statement (spec and notes) is
  narrowed to activation levels and names Vasudevan 2016.

Checked and left: every other cue, why, mistake, correct, comparison and setup line; the
mechanical clauses (marked as mechanics in the tables) read as reasoning, not as findings.
`python3 spec_500.py sidebend` prints OK (4 exercises); no new sentence repeats one in SampleData.swift
or the other families.
