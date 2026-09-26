# Batch 191-240: shrugs and loaded carries (2026-09-26)

Content: `spec_191_240_shrugcarry.py`. Ghosts: `Tools/fault-review/faults_191_240_shrugcarry.swift.txt`
(typechecked with `swiftc -typecheck` against a scratch copy of `FaultPoses.swift` with the pieces and
table entries pasted in; nothing in the project was edited).

Checked with rig probes (pxr through Blender's Python), the briefs and the framing screenshots.

Revised on 2026-09-26 after two reviews (evidence, model/ghost), then checked again in a second pass. The
changes are listed under [Revision](#revision) and [Pass 2](#pass-2) at the end.

## Shared findings

### Shrugs (227-232)

All six shrugs share one body animation. Only the arms and the equipment differ.

- Stance: feet 0.32 m apart (hip-width), knees soft at 174-176°, trunk vertical, head still. The elbows stay
  straight at 175-178° through the whole clip.
- Motion: the shoulders rise 5.4 cm straight up. Shoulder-to-pelvis distance goes from 0.947 to 1.029 torso
  lengths, and forward travel is only 6 mm. Two reps in 8 s. Each rep is about 1.3 s up, a short hold at the top
  (frames ~41-49 and ~136-144), about 1.6 s down, and a pause at the bottom.
- Copy that follows from this:
  - "straight up, no rolling"
  - arms straight
  - a brief hold at the top
  - the head still

The shared cues are range (top of the shoulder), path (other shoulder), head (head) and arms (elbow). The fifth
cue is specific to each variation.

Claims and sources:

- **Upper trapezius as the primary muscle, high activation (0.88).** Ekstrom 2003 (JOSPT 33:247) measured 10
  exercises, and the shoulder shrug gave the highest upper-trapezius EMG. Castelein 2016 (Man Ther 21:250) found
  high UT activity in the weighted shrug with the arms at the sides.
- **Levator scapulae as a secondary (0.52, moderate).** Castelein 2016 used fine-wire EMG: the levator scapulae
  and rhomboid major are active in the standard shrug and less so in the shrug with the arms overhead. The
  number is an estimate because the paper's table values were not available. "Levator Scapulae" has no
  `MusclePart`, so recovery ignores it.
- **Middle trapezius (0.30, low).** Pizzari 2014 (Clin Biomech 29:201) measured the middle trapezius in the
  standard shrug, below the 30°-abduction shrug. The low rank reflects that it is not the target. The exact
  %MVIC was not seen.
- **Forearm flexors (0.45, moderate).** StrengthLog lists the forearm flexors as secondary for the barbell and
  dumbbell shrug when no straps are used.
- **Technique:**
  - ACE Shrug (barbell): overhand, shoulder-width grip, shoulders "directly upwards to the ears as high as
    possible", "DO NOT roll the shoulders".
  - ACE Standing Shrug (dumbbells): neutral grip at the thighs, no shoulder rotation or elbow flexion, erect
    torso, head and neck aligned.
  - StrengthLog Dumbbell Shrug: arms "straight and passive", shoulders straight up and down, a short pause at
    the top.
- **Variation evidence is thin.** No study compares the EMG of dumbbell, barbell, Smith, cable, trap-bar and
  behind-the-back shrugs. The activation is therefore identical across the six, and only the setup and fifth
  cue change.

Ghost strength: the new `shrugTop` is `.between("upper_arm_L", "pelvis", from: 0.96, to: 1.02)`. It is none at
the bottom (0.947) and full at the top (1.029).

- `range` uses `shouldersLowered(0.07)`: the shoulders, arms and grip held 0.07 torso lengths lower, with
  `shrugTop`, no turn. The ghost's shoulders stay about 1 cm above the bottom position while the lifter is at
  the top.
- `path` uses `shrugRolled(0.14)`, which moves the shoulders 0.14 torso lengths (about 8 cm) forward (or back,
  -0.14) at the top, the arms and grip carried with them, with `shrugTop`. The Smith shrug uses
  `shrugRolledOnTrack` instead: the shoulders come forward 0.14 while the hands stay on the rails, sinking
  0.025 torso lengths (about 1.5 cm) so the straight arms keep their length, the elbows re-seated (175° against
  the lifter's 178° at the top, about 170° while it fades).
- `arms` uses `shrugCurled` (the hands curl 40° about the elbows at the top, up and forward) where the load
  can swing forward: dumbbells, cable handles, the trap bar and the free bar in front. The Smith bar is on a
  track and the behind-the-back bar would be swung through the hips, so those two use the new `shrugRowed`
  (the elbows drive back and bend, the bar rides straight up). Rig check at the top of the rep, same
  fixed-axis turns as `FaultGhost`: a 40° curl on the behind-the-back model moved the grip 0.25 m forward, to
  7.6 cm in front of the pelvis joint; `shrugRowed(back: 30, bend: 50)` keeps it 0.17 m behind the pelvis
  (0.1 cm change) and lifts it 6.5 cm, the elbows 12.6 cm back. On the Smith model a curl moved the bar
  0.20 m off its track; `shrugRowed(back: 27, bend: 50)` keeps it within 0.4 cm fore-aft and lifts it 6.6 cm.
- `head` uses the existing `chinCraned` (neck 0.06 forward and 0.03 up, head 0.14 forward and 0.06 up), always.
- Every shrug still is at the top, 1.58 s.
- Label: the shared arms label is "Arms straight". The longer "Arms straight, no curl" pinned at row 0.42
  sat over the left fist and the top of the dumbbell (u 0.58-0.81, v 0.43-0.52 in the framing still); the
  short pill at row 0.32 (u 0.71-0.96) clears the arm's outer edge at about u 0.70.

Views, from a framing yaw of -0.5 (the barbell shrug is -0.8):

- The side-on faults (path, head, arms and the fifth cue) use `.seen(-0.8)`, for a total of -1.3. The barbell
  uses -0.6, for a total of -1.4. `range` is not turned.
- The Smith and cable shrugs use -0.6, for a total of -1.1. At -1.3 the Smith rail (x ≈ ±1, level with the
  bar) or the cable columns could sit between the camera and the lifter. Please check these in the stills. The
  cable shrug's stance is not turned.
- The behind-the-back shrug is framed at -2.4 and uses `.seen(0.9)`, for a total of -1.5, except `path`,
  `.seen(0.7)` for -1.7.

### Carries (233-235)

- Walked in place by `inplace.py`: the pelvis is held and the feet slide back as on a treadmill. Logged as timed
  sets.
- The farmer's carry walks slowly: one step every 2 s, a 4 s gait cycle. The suitcase and overhead carries share
  one walking clip at one step a second. The copy therefore says "short, controlled / steady steps", not "quick".
- `longStride(from:to:)` opens the stride at both ends: the leading foot 0.2 torso lengths further ahead, the
  trailing foot 0.14 further back, the hips 0.05 lower (the bob of a long stride, so the straight trailing leg
  still reaches), both knees re-seated.
  - It uses `foot_front`/`foot_back` and `shin_front`/`shin_back`, so it follows whichever foot leads.
  - It fades with the ankle gap so it never jumps when the feet pass and the leading side swaps.
  - Farmer's: gap 0.53-0.79 torso lengths, fade 0.60 → 0.76. Suitcase and overhead: gap 0.37-0.72, fade
    0.52 → 0.68.
  - The carry stills are at the widest stride: 2.0 s (farmer's), 3.0 s (suitcase and overhead).

## Per exercise

### Dumbbell Shrug (`dumbbellShrug`, yaw -0.5)

**Model:** a dumbbell at each side, handles running front to back, so the palms face the thighs. The hands are
0.59 m apart, and the arms hang in the plane of the body.

**Fifth cue:** grip, "Dumbbells at your sides", on `hand_R`. Source: ACE Standing Shrug (neutral grip alongside
the thighs).

**Comparison:** ROLLING THE SHOULDERS (ACE: do not roll; StrengthLog: straight up and down).

| Fault | Ghost | Best moment |
|---|---|---|
| range | shoulders still low (`shouldersLowered(0.07)`, `shrugTop`), no turn | top, 1.58 s |
| path | shoulders rolled 0.14 forward (`shrugRolled(0.14)`), `.seen(-0.8)` | top, 1.58 s |
| arms | hands curled 40° (`shrugCurled`), `.seen(-0.8)` | top, 1.58 s |
| head | chin poked forward (`chinCraned`), `.seen(-0.8)` | any; 1.58 s |
| grip | dumbbells swung 14° in front of the thighs (`armsSwungForward(14)`, always), `.seen(-0.8)` | any; 1.58 s |

### Barbell Shrug (`barbellShrug`, yaw -0.8)

**Model:** the bar hangs in front of the thighs, 0.12 m ahead of the shoulders. The hands are 0.50 m apart,
about shoulder-width.

**Fifth cue:** grip, "Bar against the thighs", on `hand_R`. Source: ACE (overhand, shoulder-width). The model's
bar hangs 0.12 m ahead of the shoulders, so a front bar always pulls them forward a little; the why says a bar
brushing the thighs pulls them forward less than one hanging away, not that it cannot pull them at all.

**Comparison:** SHORT, BOUNCING REPS (ACE: as high as possible; StrengthLog: pause at the top).

The plates cover rows 0.41-0.55 on both sides, so the labels use rows 0.14, 0.32 and 0.68.

| Fault | Ghost | Best moment |
|---|---|---|
| range | shoulders and bar still low (`shouldersLowered(0.07, withBar: true)`, `shrugTop`), no turn | top, 1.58 s |
| path | shoulders and bar rolled 0.14 forward (`shrugRolled(0.14, withBar: true)`), `.seen(-0.6)` | top, 1.58 s |
| arms | hands curled 40° (`shrugCurled(withBar: true)`); a free bar in front can swing forward; `.seen(-0.6)` | top, 1.58 s |
| head | chin poked forward (`chinCraned`), `.seen(-0.6)` | any; 1.58 s |
| grip | bar swung 14° away from the thighs (`armsSwungForward(14, withBar: true)`, always), `.seen(-0.6)` | any; 1.58 s |

### Smith Machine Shrug (`smithMachineShrug`, yaw -0.5)

**Model:** the barbell grip on a Smith bar, 0.14-0.15 m ahead of the shoulders, inside the rails.

**Fifth cue:** bar, "Stand close to the bar". The rails fix the bar's path; where the lifter stands only decides
where that path sits against the body, which is what the why now says. This is mechanical reasoning. Schick 2010
(JSCR 24:779, bench press) found less medial deltoid stabiliser activity on a Smith machine than with a free bar;
no study has tested the Smith shrug, so this is carried over by reasoning and is not used in the copy.

**Comparison:** LEANING INTO THE BAR.

**Uncertain:** there is no Smith shrug EMG study.

| Fault | Ghost | Best moment |
|---|---|---|
| range | shoulders and bar still low (`shouldersLowered(0.07, withBar: true)`, `shrugTop`), no turn | top, 1.58 s |
| path | shoulders forward 0.14, bar kept on its track and about 1.5 cm lower (`shrugRolledOnTrack`), `.seen(-0.6)` | top, 1.58 s |
| arms | elbows back 27° and bent 50°, bar straight up the track (`shrugRowed(back: 27, bend: 50)`), `.seen(-0.6)` | top, 1.58 s |
| head | chin poked forward (`chinCraned`), `.seen(-0.6)` | any; 1.58 s |
| bar | trunk and bar tipped 10° forward (`leanedForward(10, withBar: true)`, `.always`), `.seen(-0.6)` | any; 1.58 s |

The `path` ghost used to be `shrugRolled(0.08, withBar: true)`, which carried the bar 4.7 cm forward of the
rails at the top; `shrugRolledOnTrack` keeps it on them.

### Cable Shrug (`cableShrug`, yaw -0.5)

**Model:** a handle in each hand at the sides, the same arm pose as the dumbbell shrug. The cables run down and
out about 23° from vertical to a low pulley on each side, exiting at x ≈ ±0.7 m, 0.1 m behind the feet. Each
hand goes to its own side; the cables do not cross.

**Fifth cue:** stance, "Centred, knees soft", on `patella_R`.

**Comparison:** PULLING WITH THE ARMS (ACE: no elbow flexion; StrengthLog: arms passive).

**Uncertain:** the outward line of pull puts the arms in slight abduction. Pizzari 2014 found that a shrug at
30° abduction raises trapezius activity, but the model's arms are only about 12° out. I did not claim extra
activation.

| Fault | Ghost | Best moment |
|---|---|---|
| range | shoulders still low (`shouldersLowered(0.07)`, `shrugTop`), no turn | top, 1.58 s |
| path | shoulders rolled 0.14 forward (`shrugRolled(0.14)`), `.seen(-0.6)` | top, 1.58 s |
| arms | hands curled 40° (`shrugCurled`), `.seen(-0.6)` | top, 1.58 s |
| head | chin poked forward (`chinCraned`), `.seen(-0.6)` | any; 1.58 s |
| stance | feet together, 0.2 torso lengths in each (ankles about 8 cm apart), knees straightened, drawn with the hips so the straight legs converge (inline), no turn | any; 1.58 s |

### Trap Bar Shrug (`trapBarShrug`, yaw -0.5)

**Model:** standing in the frame with a neutral grip on the side handles. The hands are 0.56 m apart and in line
with the body.

**Fifth cue:** posture, "Stand tall, no lean back", on `spine`. Sources:

- ACE: erect torso, hips straight.
- Swinton 2011 (JSCR 25:2000): standing inside the hex bar lowers lumbar and hip moments and allows a heavier
  load. That study was on the deadlift; for the shrug the point is carried over by reasoning.

**Comparison:** LEANING BACK.

| Fault | Ghost | Best moment |
|---|---|---|
| range | shoulders still low (`shouldersLowered(0.07)`, `shrugTop`), no turn | top, 1.58 s |
| path | shoulders rolled 0.14 forward (`shrugRolled(0.14)`), `.seen(-0.8)` | top, 1.58 s |
| arms | hands curled 40° (`shrugCurled`), `.seen(-0.8)` | top, 1.58 s |
| head | chin poked forward (`chinCraned`), `.seen(-0.8)` | any; 1.58 s |
| posture | hips rocked 0.09 torso lengths forward, trunk and arms leaned back 12° about the pelvis, knees re-seated (inline, after `bodySwung`, `.always`), `.seen(-0.8)` | any; 1.58 s |

The posture mistake says the hips rock forward, which `leanedBack(10)` did not draw. `bodySwung` has the hip
drive, but its strength is `.withBend("forearm_L")`, which is zero with this model's straight elbows, so the
moves are written inline and shown throughout. The legs are drawn too, so the thighs slant up to the forward
hips: the banana shape.

### Behind-the-Back Barbell Shrug (`behindTheBackBarbellShrug`, yaw -2.4)

**Model:** the bar hangs behind the thighs, 0.14 m behind the shoulders. The hands are 0.50 m apart and
overhand. The shoulder blades retract no more than in the front shrugs.

**Framing:** seen from behind-left. The lifter's left side is on the left of the frame, and the labels mirror
the front shrugs.

**Path cue:** this exercise has its own cue, "rolling back", because rolling back is the tempting direction with
the bar behind.

**Fifth cue:** bar, "Bar against the legs", on `hand_R`.

**Comparison:** ROLLING THE SHOULDERS.

**Uncertain:** coaching sites often say the behind-the-back shrug "hits the middle traps" more, but I found no
EMG study. Its activation is kept the same as the front shrugs.

| Fault | Ghost | Best moment |
|---|---|---|
| range | shoulders and bar still low (`shouldersLowered(0.07, withBar: true)`, `shrugTop`), no turn | top, 1.58 s |
| path | shoulders and bar rolled back 0.14 (`shrugRolled(-0.14, withBar: true)`), `.seen(0.7)` | top, 1.58 s |
| arms | elbows driven back 30° and bent 50°, bar rising behind (`shrugRowed(back: 30, bend: 50)`), `.seen(0.9)` | top, 1.58 s |
| head | chin poked forward (`chinCraned`), `.seen(0.9)` | any; 1.58 s |
| bar | bar swung back off the legs, arms turned -14° (`armsSwungForward(-14, withBar: true)`, always), `.seen(0.9)` | any; 1.58 s |

Head, arms and bar use `.seen(0.9)` (total -1.5, a left-side view). Path uses `.seen(0.7)` (total -1.7), seen
from a touch behind the left side so the shoulders, rolled back toward the "Straight up, no rolling" pill, stay
clear of it. Range is not turned.

### Farmer's Carry (`farmersCarry`, yaw -0.6)

**Model:**

- A dumbbell in each hand, arms straight (171°) at the sides; the left palm faces in, but the export's right
  hand is turned palm-out (thumb pointing back). Probed from the thumb and finger joints: the right thumb points
  back and outward (lateral -0.52, forward -0.44), while every other neutral-grip model (Dumbbell, Cable and Trap
  Bar Shrug, the Suitcase free hand) has it forward and in. The copy keeps palms in, which is the correct
  technique. Flag for the lead: check a close still; if it shows, the right-hand grip needs a re-export, which
  the content cannot fix.
- Shoulders level, trunk upright with side bend within 1°.
- Feet about 0.30 m apart side to side, knees 123-166°.
- Slow, deliberate steps, one every 2 s.

**Cues:** head, shoulders, posture, grip, steps.

Claims and sources:

- **Forearm flexors (P, 0.80).** The load hangs from the hands for the whole set; StrengthLog lists the forearm
  flexors as primary. There is no forearm EMG study, so the rank is inferred.
- **Upper trapezius (S, 0.45).** StrengthLog lists the traps as primary, but I found no EMG, so the value is
  kept moderate.
- **Gluteus medius (S, 0.40).** Stastny 2015 (J Hum Kinet 45:157) measured 26-47 %MVIC in the farmer's walk
  (group means).
- **Obliques (S, 0.35, low).** Ellestad 2024 (Int J Exerc Sci 17:480) measured the external oblique at 11-14
  %MVIC in the farmer's carry (about 25 kg a hand). That is below the longissimus and multifidus (14-16 %MVIC)
  and below the gluteus medius range Stastny 2015 reported (26-47 %MVIC). The carry raised EO by only 5-7
  %MVIC over a static hold. McGill 2009 found higher internal oblique peaks (81-111 %MVIC) in 3 strongmen at 75 kg a hand,
  but EO peaks were 39-50 %MVIC, well below the gluteus medius (108) and lumbar erector (106-144) peaks. The
  obliques are kept as a secondary muscle, not a primary one; the core's job is also covered by the
  stabilisers (erector spinae, quadratus lumborum, rectus abdominis). StrengthLog's Farmers Walk lists the
  obliques (with the forearm flexors, glutes and trapezius) as primary, but that is not EMG evidence.
- **Glows:** both forearms (A) and, as the SOFT glow, the upper trapezius, the next muscle in the panel (it
  replaced a glow on the lower trunk when the obliques moved down).
- **Steps.**
  - Winwood 2014 (Int J Sports Sci Coach 9:1127): the farmer's walk has a shorter stride than unloaded walking.
    Its higher stride rate was not used, because the model walks slowly.
  - McGill 2009: "short, rapid steps".
  - Taylor & Reed 2020 (NSCA Coach 7(3)): upright torso, walk slow and controlled.

**Comparison:** SHOULDERS ROUNDED.

| Fault | Ghost | Best moment |
|---|---|---|
| head | looking down (inline): chest 0.06 back, neck and head 0.07 forward and 0.03 down, the head bowed 55° forward and down about the neck (its length kept), the head point about 0.2 forward and 0.1 lower | any; 2.0 s |
| shoulders | shoulders and arms 0.13 forward, 0.06 down and 0.03 in, chest 0.07 back, neck and head 0.09 forward and 0.03 down; the girdle drawn from the neck so the drop reads as a slump (inline, after `backRounded`) | any; 2.0 s |
| posture | trunk and arms forward 10° (`leanedForward(10, strength: .always)`) | any; 2.0 s |
| grip | arms swung forward 15° (`armsSwungForward(15)`, always) | any; 2.0 s |
| steps | `longStride(from: 0.6, to: 0.76)` | widest stride, 2.0 s |

All of these use `.seen(-0.8)` (total -1.4).

### Suitcase Carry (`suitcaseCarry`, yaw -0.3)

**Model:**

- One dumbbell, in the LEFT hand, palm in.
- The right arm swings freely, front to back.
- Trunk upright: 3° of forward lean, no side bend.
- Narrow tread with the feet about 0.22 m apart, knees 119-173°, one step a second.

**Cues:** level, twist, grip, free arm, steps.

Claims and sources:

- **Obliques (P, 0.60).**
  - McGill 2009: with the load in the left hand, the right external oblique was more active, and the reverse
    for the right hand. The obliques and quadratus lumborum buttress the hip in asymmetric carries (from the
    model, not EMG).
  - Bordelon 2021 (JSCR 35 S1:S114): in the suitcase position, the external oblique and gluteus medius
    opposite the load were significantly more active.
  - Ellestad 2024 (one 25 kg dumbbell): on the side away from the load the external oblique reached 33
    %MVIC, the highest of the carry's muscles.
  - The A glow sits on the lifter's right flank (the left of the frame), from the lower ribs to the hip, centred
    between `support_PectoralisMajor_Abdominal_R` and `thigh_R`; the old centre (spine and right hip) sat on
    the lower belly. The gluteus medius SOFT glow sits just below it on the right hip.
- **Twist cue.** McGill 2009 put the larger twist of the right-hand suitcase carry down to a waddling gait; the
  left-hand carry (the model's side) twisted less than the farmer's walk (5.8° against 8.2°, 3 strongmen), so
  the copy says a one-sided load can turn the trunk, not that it tends to.
- **Gluteus medius (S, 0.42).** Neumann & Cook 1985 (Phys Ther 65:305): a load carried on the opposite side
  gives the highest gluteus medius EMG of the stance hip. Bordelon 2021 agrees. It works hardest while the leg
  away from the load is in stance, so the steps cue says each time that leg takes the weight, not every step.
- **Erector spinae (S, 0.50).** Ellestad 2024, one 25 kg dumbbell: on the side away from the load, the
  longissimus reached 29 %MVIC and the multifidus 21 %MVIC, close to that side's external oblique (33 %MVIC).
  The suitcase carry raised both over the suitcase hold. McGill 2009's left-hand carry had a higher lumbar
  erector peak than external oblique on the side away from the load, but those peaks include lifting the
  weight off the floor, so the obliques stay first.
- **Forearm flexors (S, 0.55).** Inferred from the grip.
- **Quadratus lumborum** is listed only as a stabiliser, because no study measured its EMG.
- **Free-arm cue.** No study. ACE's Suitcase Carry does not address the free arm, and some guides allow it out
  for balance (Motra's Dumbbell Suitcase Carry: extend the free arm for balance if needed). The mechanical
  point (an abducted arm shifts a little mass to the free side and slightly eases the side-bend moment) is
  sound but small, so the copy frames it as a progression, not an error: it can help balance at first; once
  you can stay tall, let it hang or swing.
- NSCA Coach (Taylor & Reed 2020): avoid any lateral bending in unilateral carries.
- McGill 2013 (Ergonomics 56:293): one-hand loading raises the low-back load.
- **Labels:** the grip label is "Crush the handle" (was "Weight still at the side", whose leader crossed its
  own pill and the left thigh), and the twist label points at `chest` (0.49, 0.38), not `spine` (the belly).

**Comparison:** LEANING TOWARD THE WEIGHT.

| Fault | Ghost | Best moment |
|---|---|---|
| level | trunk, shoulders and arms bent 10° toward the left (loaded) side about the pelvis, new piece `leanedToLoad`, no turn | any; 3.0 s |
| twist | `twisted(-22)`: trunk, shoulders and arms turned 22° about the pelvis, the right shoulder swinging forward; `.seen(-1.0)` (total -1.3, near side-on, so the upper body opens toward the camera over the side-on hips) | any; 3.0 s |
| grip | left arm swung forward 15° (`armsTurned(.lateral, 15, side: "L")`), `.seen(-1.0)` | any; 3.0 s |
| free | right arm abducted 35° (`armsTurned(.forward, 35, side: "R")`), no turn | any; 3.0 s |
| steps | `longStride(from: 0.52, to: 0.68)`, `.seen(-1.0)` | widest stride, 3.0 s |

### Overhead Carry (`overheadCarry`, yaw -1.0)

**Model:**

- Two dumbbells locked overhead, with the handles running side to side, so the palms face forward.
- Elbows at 175°, upper arms at 175° of elevation beside the ears.
- Hands 0.46 m apart and 3-5 cm ahead of the shoulders.
- The shoulders sit 3 cm higher than at rest, from upward rotation.
- The same legs as the suitcase carry.

**Cues:** wrist, lockout, shoulders, ribs, steps.

Technique source: BarBend (Dewar, updated 22 Nov 2024):

- muscles worked, in this order: scapular stabilisers, shoulders, abdominals and obliques
- elbows fully extended, arm vertical
- wrists not buckled backwards
- reach up against the weight
- ribs not flared
- small steps

Activation (the weakest evidence in the family). No EMG study of the deltoids in an overhead carry exists. The
rows follow the upward-rotator evidence and BarBend's muscle list:

- **Upper trapezius (P, 0.60, moderate).** Ekstrom 2003: the upper trapezius and serratus anterior are the
  scapular upward rotators. Bordelon 2021 measured UT, LT, latissimus and serratus (no deltoids) in one-arm
  overhead carries; most muscles rose with load.
- **Serratus anterior (S, 0.55).** Ekstrom 2003: serratus activity peaks in exercises with arm elevation above
  120° (the model holds 175°). "Serratus Anterior" has no `MusclePart`, so recovery ignores it.
- **Lateral deltoid (S, 0.45).** The upper arms sit at 175° of elevation in an 80° plane, close to the frontal
  plane with the palms forward, so the row uses the lateral head; the anterior deltoid, rotator cuff and
  triceps are listed as stabilisers. The deltoid rank is below the upward rotators because nothing measured it.
- **Obliques (S, 0.36, low).** Bordelon 2021 measured the EO in the overhead position (the side away from the
  load more active in the one-arm carry).
- The numbers are relative ranks, not measured %MVIC.
- **Glows:** A on the upper trapezius (both attachments and supports); SOFT on the serratus, centred between
  `deltoid_arc_clavicle_2_L` and `support_LatissimusDorsi_L` with no nudge (a +0.04 nudge put it on the lats,
  since at yaw -1.0 the chest faces the left of the frame); SOFT on the trunk (`spine`).
- **Lockout copy:** the why no longer says the skeleton holds the weight (the scapula has no bony support
  beneath it; the trapezius and serratus hold it up and rotated). It now says straight, stacked arms keep each
  dumbbell almost over the shoulder joint, on a very short lever. The mistake text matches the ghost (the arms
  drifting forward); the ghost does not bend the elbows, and with the palms forward an elbow bend would sit in
  the frontal plane and barely show in the side view.

**Comparison:** RIBS FLARED, BACK ARCHED.

| Fault | Ghost | Best moment |
|---|---|---|
| wrist | hand tips turned 48° back (`wristBentBack`), `.seen(-0.4)` | any; 3.0 s |
| lockout | arms 18° forward of the head (`armsTurned(.lateral, -18)`, always), `.seen(-0.4)` | any; 3.0 s |
| shoulders | shoulders, arms and grip sinking 0.08 under the weights (`shouldersLowered(0.08)`, always), no turn | any; 3.0 s |
| ribs | trunk and arms 10° back, spine 0.08 and chest 0.036 forward (`leanedBack(10, arch: 0.08)`), `.seen(-0.4)` | any; 3.0 s |
| steps | `longStride(from: 0.52, to: 0.68)`, `.seen(-0.4)` | widest stride, 3.0 s |

The turned faults sit at a total of -1.4.

## New pieces

- `shrugTop` (strength)
- `shouldersLowered(_:withBar:strength:)`, shared by the shrug range fault and the overhead shoulders fault
- `shrugRolled(_:withBar:)`
- `shrugRolledOnTrack`, the Smith shrug's roll: shoulders 0.14 forward, the hands held on the rails and
  lowered 0.025 (about 1.5 cm), the elbows re-seated
- `shrugCurled(withBar:)`, for loads that can swing forward: the hands curled 40° about the elbows
- `shrugRowed(back:bend:)`, for the Smith bar and the bar behind the legs: the elbows drive back and bend, the
  bar rising straight up
- `longStride(from:to:)`: leading foot 0.2 ahead, trailing foot 0.14 back, hips 0.05 lower, knees re-seated
- `leanedToLoad`: the trunk bent 10° toward the loaded left side

Four entries are written inline rather than as pieces, as about 200 older table entries are: the Cable Shrug
`stance` (feet together, knees straight), the Trap Bar Shrug `posture` (hips forward and the trunk back, after
`bodySwung`, shown throughout), and the Farmer's Carry `head` (the head bowed about the neck) and `shoulders`
(forward and down, with the upper back rounding).

The block typechecks with `swiftc -typecheck` against a scratch copy of `FaultPoses.swift` with the pieces and
table entries pasted in (re-run after the revision).

## Checked but not cited in the header

- Schick EE, Coburn JW, Brown LE, Judelson DA, Khamoui AV, Tran TT, Uribe BP 2010, J Strength Cond Res
  24(3):779-784, doi:10.1519/JSC.0b013e3181cc2237. Smith machine vs free-weight bench press: less medial
  deltoid stabiliser activity on the Smith machine, no difference in the anterior deltoid or pectoralis major.
  It says nothing about shrugs, so it backs no copy (see the Smith Machine Shrug).

## Could not open

- ExRx, which blocked access.
- The JOSPT full text for Ekstrom's table values.
- The Bordelon 2021 full text (paywalled, still refused in pass 2); its claims rest on the abstract (Crossref,
  Semantic Scholar). PubMed lists the issue as 35(Suppl 1); the article's own citation line says 35(2S).

Claims attributed to these rely only on their abstracts.

## Revision

Two reviews (evidence and model/ghost). Checked against the Ellestad 2024 PMC full text and its %MVIC table,
the McGill 2009 PDF (Table 2, the figure 2 caption and the event summaries), the Stastny 2015 and Bordelon
2021 abstracts, BarBend's Overhead Carry page, Motra's Dumbbell Suitcase Carry guide, the rig (thumb and finger
joints, the arm turns at the top of the rep) and the framing stills with the label layout drawn over them.

Applied:

- Farmer's Carry: obliques from primary (0.45) to secondary, low (0.35); order forearms, upper trapezius,
  gluteus medius, obliques. The SOFT glow moved from the lower trunk to the upper trapezius.
- Suitcase Carry: erector spinae 0.35 (low) to 0.50 (moderate), ranked above the gluteus medius.
- Header: the Ellestad 2024 entry rewritten (loads, absolute values, which muscles rose on which side); the
  McGill 2009 entry now says the larger twist came mainly from the right-hand carry and gives the farmer's walk
  peaks; Bordelon 2021 lists the muscles it measured; BarBend's muscle order added; Schick 2010 dropped.
- Overhead Carry: upper trapezius primary (0.60), serratus anterior (0.55), lateral deltoid (0.45), obliques
  (0.36); anterior deltoid moved to the stabilisers; A glow on the upper trapezius; the serratus glow's +0.04
  nudge removed; lockout why and mistake rewritten.
- Suitcase Carry copy: twist why (can, not tends to), free-arm why and mistake hedged, steps why (the other
  leg's stance, not every step).
- Barbell Shrug grip why and Smith Machine Shrug bar why made accurate to the model and the rails.
- Ghosts: new `shrugRowed` for the Smith and behind-the-back arms; Farmer's shoulders ghost now drops and rounds;
  Trap Bar posture ghost now rocks the hips forward.
- Labels: "Arms straight" pinned at row 0.32 in the four front-on shrugs; Suitcase grip label "Crush the
  handle"; Suitcase twist label on `chest`.
- Farmer's Carry: the export's right hand turned palm-out, noted for the lead.

Also changed while checking (not in the reviews): the Suitcase Carry A glow moved from the lower belly to the
right flank, where the obliques opposite the load are.

## Pass 2

Every finding of the two reviews was checked again against the current files; all had been applied in the
revision. Re-verified here: the Ellestad 2024 %MVIC table (PMC full text; the right hand was loaded in the
suitcase conditions), McGill 2009 Table 2, the twist results (left-hand carry 5.8° against the farmer's walk
8.2°) and the stepping advice (local PDF text), the Stastny 2015 group means (PMC full text), the Ekstrom,
Pizzari, Castelein, Bordelon, McGill 2013, Neumann and Winwood abstracts or texts, Motra's free-arm line,
ACE's Suitcase Carry (nothing on the free arm) and BarBend's muscle order. The rig was re-simulated with
FaultGhost's fixed-axis turns: `shrugRowed(back: 30, bend: 50)` keeps the behind-the-back grip 0.1 cm off its
fore-aft place and 0.17 m behind the pelvis while it rises 6.5 cm; `shrugRowed(back: 27, bend: 50)` keeps the
Smith grip on its track (0.3 cm) while it rises 6.6 cm.

Changed in pass 2:

- The Smith shrug's `path` ghost now keeps the bar on the rails (`shrugRolledOnTrack`, above); this was the
  revision's one open ghost concern.
- Header citations completed (all authors and DOIs for Swinton, Stastny, McGill 2013, Neumann, Ellestad);
  the Ekstrom line says the shrug studied was unilateral; ACE's Suitcase Carry named.
- The unused Saeterbakken 2013 and Caravan 2018 entries were removed from these notes; Schick 2010 keeps a full
  citation because the Smith section explains why it is not used.
- The block typechecks with `xcrun swiftc -typecheck` against a scratch copy of the current `FaultPoses.swift`
  with the pieces and table pasted in; no table key or piece name clashes with the table or the other
  batch 191-240 blocks.

Pass 2, continued (second session):

- Every finding was checked again against the current files; nothing had regressed. The lead's integrated block
  in `GymWorkout/Models/FaultPoses.swift` is identical to `faults_191_240_shrugcarry.swift.txt`, and a scratch
  copy of that file passes `xcrun swiftc -typecheck` on its own.
- Re-read at source: the Ellestad 2024 %MVIC table (PMC11042841), McGill 2009 (3 strongmen; farmer's walk 75 kg
  a hand, suitcase carries about 37-42 kg in one hand; twist 5.8° left-hand carry against 8.2° farmer's walk,
  as average peaks), the Ekstrom, Pizzari, Castelein, Swinton, Stastny, Neumann, McGill 2013, Winwood and
  Bordelon abstracts, the NSCA Coach PDF (pages 50-54), BarBend, Motra, ACE Shrug and Suitcase Carry, and
  StrengthLog's Farmers Walk.
- The NSCA Coach entry now carries the article's full title, and the StrengthLog Farmers Walk entry lists its
  primary muscles as given (forearm flexors, obliques, glutes, trapezius).
