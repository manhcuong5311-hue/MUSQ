# Batch 191-240: dumbbell and cable presses (2026-09-26)

Seven exercises from `SourceExports/190-240` (exports 194-198, 202, 203). Copy is in
`spec_191_240_dbpress.py`, ghosts in `../fault-review/faults_191_240_dbpress.swift.txt`.
`python3 spec_191_240_dbpress.py` prints OK. The generator dry-run renders all seven. The
fault fragment type-checks with `swiftc -typecheck` against a scratch copy of
`FaultPoses.swift`, alone and together with all six families' fragments (bbpress, curls,
dbpress, frontrear, lateral, shrugcarry). None of the piece names or exercise keys collide.

How the models were read: `briefs/*.md`, the framing screenshots, dense joint timelines in
the lifter's own axes (49 samples), and Blender workbench renders from the side and front at
the bottom, the dip and lockout. A Python port of `FaultGhost.solve` was run on the rig at
key frames to check that each ghost moves the way its mistake says (results below).

Revised after two reviews (2026-09-26): the cable rows no longer lower the lateral deltoid,
the seated and neutral-grip copy now matches where the model actually sits and holds its
elbows, the push press dip uses mid-foot like the barbell Push Press, the one-arm lean is
framed as a big lean (ExRx allows a lean for balance), and the elbow ghost now puts the elbows
behind the shoulders. The fragment was re-type-checked alone and with every other family's
fragment.

Second pass (2026-09-26): every reviewer finding was re-checked against the current files and
the sources (abstracts through Europe PMC, Luczak and Coratella full text, the Durall full
text, CrossFit and StrengthLog fetched, NSCA and ExRx through search snippets). One line of
copy changed: the seated comparison's mistake note said nothing stops the lean, but the pad
would at about 20°, so it now says only the braced trunk keeps the lifter upright. The
header and notes were tightened: NSCA does say the hips stay under the shoulders in the dip,
ExRx allows a lean for balance without calling it slight and puts the cable pulleys low to
medium, ACE's seated press keeps the back on a back rest, the Saeterbakken 2012 erector
figure is bilateral-versus-unilateral, Paoli's no-load exceptions are named, and the
neutral-grip lateral deltoid row now has its reasoning written down. The spliced fragment
still type-checks against the current `FaultPoses.swift`.

Second pass, completion check (2026-09-26): Coratella's full-text results were re-read. The
neutral-grip front machine press did give less medial and posterior deltoid than the back
machine press (and less anterior deltoid while lowering); earlier passes had said it showed
no deltoid difference. The header and notes are corrected, and the neutral-grip elbow cue's
why now says pressing in front of the head works the side deltoid less as well as the upper
chest more. Also tightened: the ExRx cable page is now titled Cable Isolateral Standing
Shoulder Press, and the Kohler triceps result is given exactly (barbell on a bench highest,
dumbbells on a Swiss ball lowest). The fault fragment is unchanged; `FaultPoses.swift`
already carries it word for word and type-checks on its own.

## Shared model facts

The six pronated presses use the same arm animation: Standing, Seated, Push Press,
Single-Arm DB and both cable presses. The elbow timeline is identical in all of them.

- **Bottom:** palms forward. The wrist is about 5 cm above the shoulder joint and 17 cm in
  front of it; the handle is about 13 cm above the shoulder joint, about chin height. The
  elbow is about 19 cm below the shoulder, 20 cm out and 9 cm forward, so the forearms are
  near vertical (18° off). Elbow angle is 50°.
- **Plane:** the upper arm sits 49-66° from straight ahead. That is 24-41° in front of the
  frontal plane, which is the scapular plane.
- **Lockout:** a soft lockout. Elbow 162°, upper arm 167° from hanging, hands 0.47 m apart
  over the shoulders. The hands start 0.71 m apart.
- **Timing:** two reps in 8 s at 24 fps.
- **Trunk:** lean and side bend are 0° throughout.
- **Label layout:** every label row is pinned with `overrides`. Joints on the right of the
  frame (the lifter's left arm) get trailing labels, joints on the left get leading ones, and
  midline joints go to whichever side is free. That keeps the leaders short, with no crossing
  over the body.
  - One compromise remains: in Standing Dumbbell Press the top-right pill ("Press to straight
    arms") sits just above `hand_L` at lockout (hand v 0.17). The older Dumbbell Shoulder
    Press has the same compromise.
  - The single-arm lockout labels go top-left instead, because their hand rises to v 0.15.

## Dumbbell Push Press

**Model.** Standing, with the feet 0.34 m apart and the knees soft (157°).

- **Dip:** each rep dips about 8 cm. The pelvis drops from 0.90 to 0.82 m, the knees bend to
  about 122°, and the trunk stays vertical with the heels down. The dumbbells wait at the
  shoulders throughout (frames 1-17 and 97-112).
- **Drive and press:** the knees straighten as the arms press (frames 17-33). The arm press
  starts while the knees are still at about 135°, so the model blends drive and press. For
  that reason no "legs first, then arms" timing cue was written.
- **Lowering:** the dumbbells are lowered with the knees straight.

**Claims and sources.**

- The dip is no deeper than a quarter squat (or about 10% of body height), with the torso
  erect, the hips staying directly under the shoulders rather than moving back, and the
  weight balanced over the middle of the feet. Source: NSCA Kinetic Select, *Push Jerk* (the
  same dip as the push press). The page returns 403 to direct fetches, so its wording was
  checked through search-result snippets.
- The trunk stays vertical in the dip, the heels stay down until the legs and hips have
  extended, then the lifter presses to directly overhead. Source: CrossFit Essentials, *The
  Push Press*.
- **Foot pressure:** the copy and setup say "weight over mid-foot, heels down". CrossFit also
  says the weight shifts toward the heels, but NSCA says the middle of the feet, and the
  barbell Push Press in this batch (`spec_191_240_bbpress.py`) says mid-foot, so the app
  teaches one foot pressure for the same dip. "Hips under the shoulders" in the dip cue is
  NSCA's (see above).
- "The legs drive the push press much as they drive a jump." Source: Lake, Mundy & Comfort
  2014, JSCR 28(9):2552-2559. Push press peak and mean power and impulse were comparable with
  the jump squat.
- "A deep dip slows the turnaround and lets the trunk fold" is a technique convention: coaches
  teach a short dip. No study measured dip depth, so it is kept as reasoning.
- **Activation:** Anterior Deltoid P 0.80, Lateral Deltoid S 0.60, Triceps S 0.55,
  Quadriceps S 0.45.
  - The ranks follow StrengthLog *Push Press*: front delt primary; quads, glutes, adductors,
    lower back, trapezius, triceps and lateral delt secondary.
  - No EMG study of the dumbbell push press was found, and none of the barbell push press
    against a strict press. The fractions are deliberately modest and illustrative.
- The quads glow is the third glow.

**Uncertain.** The quadriceps share, and the lateral deltoid's rank relative to the triceps.
Both come from the strict-press literature.

**Ghost stills.**

Framed at yaw -0.5. The dip faults use `dumbbellPushPressDip` (none at 1.40 torso lengths
pelvis to left ankle, all of it at 1.30).

| Cue | Ghost | Still |
|---|---|---|
| `dip` | `leanedForward(14)`: trunk and arms tipped 14° forward about the pelvis; dip strength; `.seen(-0.8)`, total -1.3 | 0.5 s (bottom of the dip) |
| `depth` | Inline: the hips and all they carry 0.2 lower, knees re-seated; dip strength; view -0.6, total -1.1 | 0.5 s |
| `heels` | Inline, `heelsUp`'s moves: each foot turned 24° up about the toes, knees re-seated; dip strength; view -0.8, total -1.3 | 0.5 s |
| `elbow` | `pressElbowsDraggedBack("*")` (see New fault pieces); with the elbow bend; view -1.0, total -1.5 | 3.17 s (end of the lowering) |
| `lockout` | `armsTurned(.lateral, -18)`: arms swung 18° forward, finished in front of the face; `.whenStraight`; `.seen(-0.8)`, total -1.3 | 1.42 s (lockout) |

The dip stills sit at the dip bottom rather than at the elbow rule's pick: the rule is
ambiguous here, since the elbow is just as bent (50°) at the end of the lowering (3.17 s,
the exercise's default still), when these ghosts are off because the dip strength is 0
standing.

Ghost checks on the rig, in torso lengths (about 0.59 m on this rig):

- `dip` moves the head 0.28 forward at the dip bottom, and 0 when standing or at lockout.
  The ghost tips only the trunk (`leanedForward`), so the mistake text says "the chest
  tipping forward as the knees bend" and no longer mentions the hips sitting back.
- `depth` moves the pelvis 0.2 down (about 12 cm below the real dip), the knees closing from
  about 122° to about 94°.
- `heels` lifts the ankle 0.12 and brings the knee forward.
- `lockout` moves the hands 0.22 forward.

## Standing Dumbbell Press

**Model.** The same stance as the push press, with the knees at 157° for the whole clip.
This is a strict press, with the pronated arm path described above.

**Claims and sources.**

- **Elbows about 30° forward (scapular plane):** Durall, Manske & Davies 2001, Strength Cond
  J 23(5):10-18. This is a clinical commentary, not an experimental study. It names
  abduction plus external rotation plus horizontal abduction as the at-risk position for the
  front of the shoulder capsule, above all in lifters with anterior laxity or instability.
  The 30°-forward, scapular-plane advice is given for presses usually done behind the neck,
  and it says shoulder presses are best done with the hands and elbows in front of the
  shoulder, with a bar, dumbbells or a machine. The copy uses it only for that general
  advice. Also ExRx *Dumbbell Shoulder Press* (elbows below the wrists).
- **Elbow mistake:** "pulled back behind the shoulders" (not "behind the body"), which is
  what the ghost draws: the elbow ends about 3 cm behind the shoulder joint.
- **Lockout mistake:** "elbows still clearly bent, the dumbbells a few inches short of the
  top". The ghost drops the hands about 9 cm and bends the elbows out to about 108°; it does not
  bring the dumbbells down to head height, so the old "level with the top of the head" was
  dropped.
- **Press to straight arms works the deltoids, triceps and upper traps harder:** Paoli,
  Marcolin & Petrone 2010, JSCR 24(6):1578-1583. The widest range, to full elbow extension,
  raised EMG in every muscle measured. The exceptions were the middle trapezius, teres minor
  and posterior deltoid with no load.
- **Standing makes the abs work far harder than sitting:** Saeterbakken & Fimland 2012, Eur J
  Appl Physiol 112(5):1671-1678. Rectus abdominis was about 81% lower seated than standing in
  the bilateral dumbbell press.
- **Braced trunk, no lumbar arch; neutral wrists:** ACE *Seated Overhead Press*.
- **Activation:** AD P 0.88, LD P 0.76, Triceps S 0.52, Rectus Abdominis S 0.30.
  - Saeterbakken & Fimland 2013 (JSCR 27(7):1824-1831): standing dumbbells gave the highest
    deltoid EMG of the four seated/standing, barbell/dumbbell presses.
  - LD relative to AD follows Campos et al. 2020 (J Hum Kinet 75:5-14): seated barbell press,
    AD 33.3% and medial 27.9% MVIC, a ratio of about 0.84.
  - StrengthLog and ExRx list the lateral deltoid as secondary. It is marked primary here, as
    in the older Dumbbell Shoulder Press, because Campos 2020 measured the medial deltoid at
    about 84% of the anterior deltoid in the shoulder press, and Saeterbakken 2013 found
    standing dumbbells gave slightly more medial deltoid than the standing barbell (about 7%,
    p = 0.05) and the highest deltoid activity of the four presses.
  - Triceps is moderate: in Saeterbakken 2013 the standing barbell gave about 39% more
    triceps than standing dumbbells, and in Kohler 2010 the barbell on a bench gave the most
    triceps activity and dumbbells on a Swiss ball the least.

**Ghost stills.**

Framed at yaw -0.5.

| Cue | Ghost | Still |
|---|---|---|
| `elbow` | `pressElbowsDraggedBack("*")`; with the elbow bend; view -1.0, total -1.5 | 3.58 s (bottom) |
| `lockout` | `pressLockoutBent("*")`: elbows 0.12 out, hands 0.2 lower, elbows re-seated; `.whenStraight`; no turn | 1.33 s (lockout) |
| `brace` | `leanedBack(12, arch: 0.08)`: trunk and arms 12° back about the pelvis, spine 0.08 and chest 0.036 forward; any; `.seen(-0.8)`, total -1.3 | 1.33 s |
| `wrist` | `wristBentBack` (no bar): hand tips 48° back about the side-to-side axis; any; `.seen(-0.8)` | 3.58 s (bottom) |
| `stance` | `pressKneesDipped`: the hips and all they carry 0.1 lower, knees re-seated; with the elbow bend; view -0.6, total -1.1 | 3.58 s (bottom) |

## Seated Dumbbell Press

**Model.** A flat seat 0.55 m high with a short upright back pad. The pad's top is at
1.10 m, 5.5 cm below the shoulder joints (1.155 m), so it reaches the upper shoulder blades.

- The lifter sits upright in the middle of the seat, well clear of the pad. The hip joints
  are about 27 cm in front of the pad's face (the seat runs 46 cm front to back, and the hips
  are about 15 cm from its front edge). The side render shows about 13 cm between the
  buttocks and the pad and about 15 cm between the upper back and the pad. Touching the pad
  would take about 20° of lean.
- Feet are flat and wide (0.42 m), the knees at about 121°, the feet a little ahead of the
  knees. The arm path is the pronated one described above.
- This differs from the older Dumbbell Shoulder Press, which leans on a tall upright pad. The
  copy therefore says "sit tall in the middle of the seat", not "back against the pad" or
  "hips back", and the torso mistake is "leaning back toward the pad" (the ghost leans 12° in
  free space), not "over the top of the pad".
- At the bottom the dumbbell handles are about 13 cm above the shoulder joints and 4 cm below
  the head joint: about chin height, with the plates' lower edges at the tops of the
  shoulders. The depth cue says "just above the shoulders, about chin height".

**Claims and sources.**

- **Seated vs standing dumbbells:** Saeterbakken & Fimland 2013. Seated dumbbells gave about
  15% less medial deltoid than standing (p = 0.008), about 8% less anterior (a trend,
  p = 0.07), and about 24% less posterior. 1-RM was about 10% higher seated.
- **Activation:** AD P 0.84, LD P 0.66 (moderate), Triceps S 0.50, Upper Trapezius S 0.36.
  - Upper trapezius: Luczak, Bosak & Riemann 2013 (J Sports Med 2013:612650). The 85°
    dumbbell shoulder press gave more upper trapezius and anterior deltoid than incline and
    flat presses. Paoli 2010 also measured the upper trapezius in the seated press.
- **"Leaning back tilts it toward an incline press":** Luczak 2013 (85° vs 45° benches).
  Pectoralis activity rises and the press changes as the trunk reclines.
- **Depth:** lower to just above the shoulders. Sources: ACE (start at shoulder level) and
  ExRx (lower to the sides of the shoulders).
- **Back support:** ACE's *Seated Overhead Press* sits with the back against a back rest and
  keeps contact with the bench. This model sits clear of its short pad, so the copy teaches
  what it shows (sit tall, trunk upright over the hips) and does not tell the lifter to keep
  off the pad; the fault is only leaning back with the lower back arched, which ACE also
  rules out ("no arching in your low back").
- The path and elbow cues are shared with Standing; see there.

**Ghost stills.**

Framed at yaw -0.5.

| Cue | Ghost | Still |
|---|---|---|
| `elbow` | `pressElbowsDraggedBack("*")`; with the elbow bend; view -1.0, total -1.5 | 3.58 s (bottom) |
| `path` | Inline wide drift: hands 0.28 out and 0.05 down, elbows re-seated (hands ~74 cm apart against the real 47, arms ~19° out, elbows ~167°); `.whenStraight`; no turn | 1.33 s (lockout) |
| `depth` | Inline short rep: hands 0.16 up, elbows re-seated, so the dumbbells turn round at forehead height; with the elbow bend; no turn | 3.58 s (bottom) |
| `torso` | `leanedBack(12, arch: 0.08)`; any; `.seen(-1.0)`, total -1.5 | 1.33 s |
| `feet` | `pressFeetTucked`: feet 0.3 back and rocked 25° onto the toes, knees re-seated; any; `.seen(-1.0)` | 3.58 s |

## Neutral-Grip Dumbbell Shoulder Press

**Model.** An adjustable bench one notch off upright, with the trunk reclined about 9°. The
back is on the pad, the feet flat about 0.38 m apart, the knees at about 112°.

- **Grip:** palms face each other; the dumbbells run front to back.
- **Bottom:** the dumbbells are at the front of the shoulders, the elbow bent to about 19°.
  The upper arm is about 16° from hanging, with the elbows low beside the ribs: in trunk
  axes the elbow is about 6 cm in front of the shoulder joint, 28 cm below it and 5 cm out
  (25 cm to the side of the chest joint), so it sits beside the rib cage, a little forward,
  not in front of it. The copy says "low by the sides, a little forward". (The brief's
  upper-arm plane of -168..173 is an artefact of the un-rotated skeleton frame and is not
  quoted.)
- **Press:** the elbows travel forward and up: about 24 cm in front of the shoulder and 13 cm
  out at frame 17.
- **Lockout:** about 168-173°, with the hands 0.31 m apart. Each dumbbell's plates are 0.21 m
  across, so the dumbbells finish close together, the plates about 10 cm apart.

**Claims and sources.**

- **Elbows in front of the shoulder keep it out of the at-risk position:** Durall et al. 2001
  (a clinical commentary; see Standing). It says to press with the hands and elbows in front
  of the shoulder and to avoid abduction with external rotation and horizontal abduction.
  The copy claims no more than that; it does not say the neutral grip is easier on the
  shoulders in general, and popular sites that say so are not cited.
- **Pressing in front of the head works the upper chest more:** there is no EMG study of
  neutral against pronated grips in a free-weight shoulder press. The closest evidence is
  Coratella et al. 2022 (Front Physiol 13:825880, EMG as % MVIC):
  - With the barbell, the front press gave more clavicular pectoralis and triceps, and the
    back press more medial and posterior deltoid. The anterior deltoid was not higher in the
    front press; the back press excited it more while lowering.
  - The front machine press used a neutral grip, the closest match to this model. Against
    the back machine press it gave far more clavicular pectoralis (effect size 20.5
    lifting, 7.0 lowering) and less medial deltoid (ES 1.8 lifting, 5.2 lowering) and
    posterior deltoid in both phases, and less anterior deltoid while lowering (ES 2.9).
    The authors put the lower medial deltoid down to the arm rising by combined abduction
    and flexion in front of the head. (Earlier passes said the machine pair showed no
    deltoid difference; the full-text results say otherwise, so that was corrected.)
  - The earlier line that the neutral grip "puts the front deltoid in charge" was removed:
    nothing measured supports it.
- **Luczak, Bosak & Riemann 2013** (J Sports Med 2013:612650; women, 4.5 kg dumbbells, EMG
  normalised to the flat press, Table 3): the sternal pectoralis was low in the 85° shoulder
  press (40% against 127% for the flat press, about a third, concentric), but the clavicular
  head still reached about 70% of the flat-press level (91% against 131%). The upper chest is
  a real secondary mover.
- **Activation:** AD P 0.86, Triceps S 0.54, LD S 0.42, Upper Pectoralis S 0.40 (moderate;
  raised from 0.30 on the Luczak and Coratella points above). The ranks are by analogy with
  the front press and kept conservative.
  - The lateral deltoid sits below the pronated presses (0.66-0.76) because here the elbows
    travel forward, so the arm rises more by flexion than by scapular-plane abduction, and
    the medial deltoid is mainly an abductor. Coratella's front presses, both the barbell
    and the neutral-grip machine, gave less medial deltoid than the matching back presses,
    so the direction is measured. Those comparisons are against pressing behind the head,
    not against a pronated press in front, so the size of the cut is inference. It stays
    moderate and secondary, as StrengthLog and ExRx list it.
  - The elbow cue's why says pressing in front of the head works the upper chest more and
    the side deltoid less than pressing behind it, which both of Coratella's front-back
    pairs show.
- **Wrist:** the new piece `palmsInWristsBentBack` tips the hands outward. With the palms in,
  the back of each hand faces out. The piece turns about the chest's axis, not the axis
  `wristBentBack` turns about.

**Ghost stills.**

Framed at yaw -0.6.

| Cue | Ghost | Still |
|---|---|---|
| `grip` | `palmsInWristsBentBack`: hand tips 40° outward about the chest's axis; any; no turn | 3.83 s (bottom) |
| `elbow` | Inline: elbows swung 40° out about the shoulders (chest's axis), re-seated, palms still in; with the elbow bend; no turn | 3.83 s (bottom) |
| `lockout` | `armsTurned(.lateral, -20)`: arms 20° forward, stopped with the dumbbells in front of the face; `.whenStraight`; `.seen(-0.8)`, total -1.4 | 1.58 s (lockout) |
| `back` | `lowerBackArched(0.12)`: spine 0.12 and chest 0.054 forward; any; `.seen(-0.9)`, total -1.5 | 3.83 s |
| `feet` | `pressFeetTucked`; any; `.seen(-0.9)` | 3.83 s |

## Single-Arm Dumbbell Shoulder Press

**Model.** The standing press with only the LEFT arm pressing, on the same path. The right
arm hangs straight by the side (elbow 171°). There is no side bend.

**Claims and sources.**

- **One-arm pressing makes the obliques work much harder:** Saeterbakken & Fimland 2012.
  External oblique was about 68% lower bilateral than unilateral when standing; erector spinae
  was about 18% lower bilateral when standing. StrengthLog *Dumbbell Shoulder Press* also
  notes that single-arm and standing raise core demand.
- **The lean:** ExRx *Dumbbell One Arm Shoulder Press* says the torso can lean away for
  balance or stay upright; it does not limit the lean to a slight one (checked through
  search snippets; ExRx blocks direct fetches). The
  model presses upright, which is the version that makes the obliques hold the trunk
  (Saeterbakken & Fimland 2012), so only a large lean that does the lifting is treated as the
  fault: the mistake is "leaning well away from the working arm so the trunk, not the
  shoulder, lifts the weight". No peer-reviewed study measured the lean. The comparison says
  a big lean lets the obliques stop holding the trunk still; the old claim that "the side of
  the trunk takes the strain" had no source and was removed. The ghost leans 12° (the head
  moves about 14 cm), which reads as a big lean.
- **Activation:** AD P 0.88, LD P 0.76, Triceps S 0.52, Obliques S 0.42.
  - The deltoid values mirror the standing press exactly. No unilateral-versus-bilateral
    deltoid EMG was found, so they are neither raised nor lowered.
  - The obliques are moderate, from Saeterbakken 2012.

**Ghost stills.**

Framed at yaw -0.5.

| Cue | Ghost | Still |
|---|---|---|
| `core` | `pressLeanedAway`: trunk, arms and grip turned 12° about the pelvis (chest's axis), to the lifter's right; any; no turn | 3.58 s |
| `elbow` | `pressElbowsDraggedBack("L")`, left arm only; with the left elbow bend; view -1.0, total -1.5 | 3.58 s (bottom) |
| `lockout` | `pressLockoutBent("L")`: left elbow 0.12 out, left hand 0.2 lower, re-seated; `.whenStraight`; no turn | 1.33 s (lockout) |
| `brace` | `leanedBack(12, arch: 0.08)`; any; `.seen(-0.8)`, total -1.3 | 1.33 s |
| `stance` | `pressKneesDipped`; with the elbow bend; view -0.6, total -1.1 | 3.58 s (bottom) |

## Cable Shoulder Press

**Model.** Standing centred between two towers. The pulleys are at floor level, about 0.45 m
behind the lifter and 0.66 m out to each side, so the cables run down and back from the
handles. The feet are 0.34 m apart, the knees soft. Palms face forward on the handles, and
the arm path is the pronated one described above.

**Claims and sources.**

- **Setup, standing between two pulleys:** ExRx *Cable Isolateral Standing Shoulder Press*
  (formerly *Cable Standing Shoulder Press*;
  exrx.net/WeightExercises/DeltoidAnterior/CBStandingShoulderPress) says to stand between
  two low to medium height pulleys, the stirrups at the sides of the shoulders. It also says
  the pulleys should be much closer together than a standard crossover; the model's towers
  are 1.32 m apart, so the copy says nothing about pulley spacing and only asks for the
  pulleys at the bottom, as the model shows. The page's text was checked through search
  snippets, because ExRx blocks direct fetches.
- **The cables pull the handles back as well as down, and the trunk into a lean:** mechanics
  of the model's line of pull. The handles are at x ±0.36 and the pulleys at x ±0.66, 0.45 m
  behind and 0.12 m up, so each cable pulls down, back and out. It is not measured, and no
  cable shoulder press EMG study was found.
- **Lockout:** near lockout the hand is about 0.53 m above the shoulder, so the backward pull
  draws the straight arms behind the head; the muscles that resist it are the shoulder
  extensors (latissimus, teres major, long head of the triceps), not the deltoids. The copy
  therefore says only that holding the handles over the shoulders keeps the arms in line with
  the trunk instead of the shoulders and lower back arching back to follow the cables. The
  earlier "keeps the load on the deltoids" was removed.
- **Activation:** AD P 0.88, LD P 0.76, Triceps S 0.50, Rectus Abdominis S 0.30.
  - No cable shoulder press EMG study was found, so the deltoid rows mirror the standing
    dumbbell press (Saeterbakken & Fimland 2013; core from 2012).
  - The low, wide pulleys add a pull toward the side, which the side deltoid (and
    supraspinatus) resists, and near lockout a pull behind the head, which the shoulder
    extensors resist. At the bottom the backward pull slightly reduces the flexion moment
    (about -0.12 per unit force against -0.17 for a dumbbell). Neither argues for less
    side-deltoid work than with dumbbells, so the earlier cut to LD 0.66 (reasoned from a
    backwards reading of the line of pull) was undone. These values are inference.

**Uncertain.** All cable-specific activation. Flagged as inference.

**Ghost stills.**

Framed at yaw -0.5.

| Cue | Ghost | Still |
|---|---|---|
| `elbow` | `pressElbowsDraggedBack("*")`; with the elbow bend; view -1.0, total -1.5 | 3.58 s (bottom) |
| `lockout` | `armsTurned(.lateral, 14)`: arms swung 14° back, behind the head; `.whenStraight`; `.seen(-0.8)`, total -1.3 | 1.33 s (lockout) |
| `brace` | `leanedBack(12, arch: 0.08)`; any; `.seen(-0.8)` | 1.33 s |
| `stance` | `cableFeetTogetherLocked`: feet 0.2 in each, knees straightened; any; no turn | 3.58 s |
| `wrist` | `wristBentBack` (no bar), 48°; any; `.seen(-0.8)` | 3.58 s (bottom) |

## Single-Arm Cable Shoulder Press

**Model.** One tower on the lifter's left. The LEFT arm presses; the right hangs by the side.
The cable runs down, back and out to the left from the handle.

**Claims and sources.**

- **Obliques:** Saeterbakken 2012 (unilateral dumbbell press) and Santana, Vera-Garcia &
  McGill 2007 (JSCR 21(4):1271-1277, doi:10.1519/R-20476.1). Santana studied a standing
  one-arm cable chest press, a horizontal push at chest height, not an overhead press:
  whole-body stability limited the load (26 kg against 74 kg for the bench press), and the
  internal oblique and latissimus dorsi on the side opposite the pressing arm were as active
  as the anterior deltoid and pectoralis major. The trunk muscles as a whole did not match
  the shoulder's. It is the closest evidence rather than a direct match.
- **The lean:** the same framing as the single-arm dumbbell press (a big lean that lifts is
  the fault). Here the pulley pulls the trunk toward the working side, so the lean-away
  direction is inferred, not measured.
- **Lockout:** the same reasoning as the two-arm cable press.
- **Activation:** AD P 0.88, LD P 0.76, Triceps S 0.50, Obliques S 0.42. The deltoid rows
  mirror the single-arm dumbbell press, which mirrors the standing press; the reasoning
  matches the two-arm cable press.

**Ghost stills.**

Framed at yaw -0.5.

| Cue | Ghost | Still |
|---|---|---|
| `core` | `pressLeanedAway`; any; no turn | 3.58 s |
| `elbow` | `pressElbowsDraggedBack("L")`; with the left elbow bend; view -1.0, total -1.5 | 3.58 s (bottom) |
| `lockout` | `armsTurned(.lateral, 14, side: "L")`: the left arm swung 14° back, behind the head; `.whenStraight`; `.seen(-0.8)`, total -1.3 | 1.33 s (lockout) |
| `brace` | `leanedBack(12, arch: 0.08)`; any; `.seen(-0.8)` | 1.33 s |
| `stance` | `cableFeetTogetherLocked`; any; no turn | 3.58 s |

## New fault pieces

- **`dumbbellPushPressDip`:** `FaultStrength.between("pelvis", "foot_L", from: 1.40, to: 1.30)`.
  The pelvis-to-left-ankle distance is 1.417 torso lengths standing and 1.285-1.306 at the dip
  bottom. The numbers are identical to the barbell family's `pushPressDip`, so the lead can
  keep one.
- **`pressElbowsDraggedBack(_ side:)`:** the elbow shifted 0.25 back and 0.06 out and the
  hand 0.12 back, then the elbow re-seated, shown with the elbow bent, turned `-1.0`. The
  first version copied the older Dumbbell Shoulder Press's inline fault (0.12 back, 0.05
  out), but the re-seat pulled most of that back: the ghost elbow stayed about 5 cm in front
  of the shoulder joint, 4 cm from the real one. The larger shift puts it about 3 cm behind
  the shoulder joint at the bottom (a 12 cm change), the dumbbell about 7 cm back, and the
  forearm 32° off vertical against the real 18°. The older inline ghost has the same
  weakness; it was not touched here.
- **`pressLockoutBent(_ side:)`:** the elbow nudged 0.12 out to the side and the hand 0.2
  lower, then the elbow re-seated, so the bend opens in the frontal plane, across the
  screen; shown near lockout (`.whenStraight`), no turn. On the rig the elbow ends about
  12 cm out at about 108°, the hand about 9 cm lower.
- **`pressFeetTucked`:** seated presses: the feet 0.3 back under the seat (level with the
  floor) and rocked 25° up onto the toes, the knees re-seated. Further than the shared
  `feetTucked` (0.16): on the rig the toes go about 18 cm back and the ankles end behind the
  knees.
- **`cableFeetTogetherLocked`:** cable presses: the feet 0.2 in each side and the knees
  straightened, the ankles about touching (about 10 cm apart against the real 34). The
  shared `squareLockedStance` only brings them to about hip width.
- **`pressLeanedAway`:** the trunk, arms and grip turned 12° about the pelvis around the
  chest's axis, which tilts it to the lifter's right, away from the working left arm; any,
  no turn.
- **`pressKneesDipped`:** the hips and all they carry sink 0.10 and the knees are re-seated,
  shown while the arms are bent, turned `-0.6`.
- **`palmsInWristsBentBack`:** the hand tips turned 40° outward about the chest's axis;
  described in the neutral-grip section.

**Views.** All framings are yaw -0.5 (neutral grip -0.6), facing the lifter.

| Fault kind | View | Total yaw |
|---|---|---|
| Sagittal: leaning back or forward, arms forward or back, heels, wrist bent back | `.seen(-0.8)` | ~-1.3 (neutral lockout -1.4) |
| Elbows dragged back (`pressElbowsDraggedBack`) | view -1.0 | -1.5 |
| Knee dips (push press depth, `pressKneesDipped`) | view -0.6 | -1.1 |
| Seated or bench faults (torso, back, feet) | `.seen(-0.9)` to `.seen(-1.0)` | -1.5 |
| Frontal-plane or vertical: lean away, flare, wide path, soft lockout (`pressLockoutBent`), seated depth, wrist on the neutral grip, cable stance | none | -0.5 (-0.6) |

**Solver check.** Directions checked with the Python port (in torso lengths, lifter's axes):

- `pressElbowsDraggedBack`: the elbow goes about 0.20 back (behind the shoulder joint) and
  0.07 out, the hand 0.12 back.
- `pressLockoutBent`: per the piece's own rig check, the hand goes about 9 cm down and the
  elbow ends about 12 cm out at about 108°.
- `pressLeanedAway`: the head goes 0.24 to the right.
- `pressKneesDipped`: the pelvis goes 0.10 down.
- `wristBentBack`: the tip goes 0.15 back.
- `palmsInWristsBentBack`: the tip goes 0.13 out.
- Neutral elbow flare: the elbow goes 0.29 out.
- Cable lockout: the hands go 0.17 back.
- Push press lockout: the hands go 0.22 forward.

No cue was left without a ghost. Every mistake is a position.

## For the lead: `bottoms.py`

Every ghost with `.whenStraight(...)` strength is empty at the bottom, where the default
elbow rule shoots the still. The stills are now in `bottoms.json` as "Exercise|cue" (the
times in the tables above): the lockouts and the seated `path` at the straightest elbow
(Dumbbell Push Press 1.42 s; Standing, Seated, Single-Arm Dumbbell and both cable presses
1.33 s; Neutral-Grip 1.58 s), with `brace` (and the seated `torso`) at the same moment.

The push press's `dip`, `depth` and `heels` stills are at the dip bottom (0.5 s): the
elbow rule cannot tell the dip from the end of the lowering.
`pressLeanedAway` (`core`) shows at any moment and is shot at the bottom (3.58 s).
