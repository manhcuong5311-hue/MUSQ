# 30-leg set: barbell squat variations (2026-09-28)

Six exercises from the HIKSEMI drive's `300-350/27_9` folder:
`spec_legs30_barbell.py` holds the copy, `Tools/fault-review/faults_legs30_barbell.swift.txt`
the ghosts and `fault_moments_legs30_barbell.json` their still moments. The
spec header lists the full citations; this file maps each claim in the copy
to them and records what the models show. Studies are named by first author
and year.

## Shared facts about the models

- All six squat on both legs at once, symmetrically (left and right joint
  angles within 1°), two reps per clip. Framing yaw -1.0 (box, pause, safety
  bar, Zercher), -0.8 (overhead), -0.9 (landmine): three-quarter from the
  lifter's front-left, the lifter facing screen-left-front, their left hand
  on the right of the screen. With the negative yaw the lifter's left side
  is turned toward the camera, so `patella_L` is the near knee. The
  left-hand knee labels point at the knee on the screen-left side
  (`patella_R`, the lifter's far knee, visible clear of the near leg).
- Rig torso (neck to pelvis) 0.59 m, shoulder joints ~0.38-0.40 m apart. No
  toe joints on these rigs (`toe_L/R` probed empty), so foot cues use
  `foot_L`.
- Thigh angle is measured below horizontal toward the knee: +5-6° (box,
  pause, safety bar, Zercher) puts the hip joint ~4 cm above the knee joint,
  i.e. about parallel; +12° (overhead, landmine) is just above parallel,
  the hip joint ~9 cm above the knee joint. The copy says "about parallel"
  for all six (see Model notes for the last two).
- Clip lengths: box, safety bar and Zercher 10 s; pause 12 s; overhead and
  landmine 8 s.

## Box Squat

Model: straight bar high on the upper traps (6 cm behind the neck joint,
level with it), grip 0.78 m. Box 0.43 m high behind the lifter, front edge
~18 cm behind the ankles. Ankles 0.50 m apart (~1.3 x shoulder-joint width),
toes out 20°. Down ~1.1 s, SITS on the box ~1.2 s (pelvis joint 8 cm above
the box top, 33 cm behind the ankles), up ~1.0 s. On the box: knees 84°,
hips 56°, thighs about parallel, shins 9° (15-19° while moving), trunk 44°.

Claims and sources:
- Library QUADS + GLUTES, activation Quadriceps HI 0.80 > Gluteus Maximus
  MOD 0.62 > Erector Spinae MOD 0.42; adductors, hamstrings, calves and core
  as stabilisers. McBride 2010, the one EMG study of this lift: muscle
  activity (vastus lateralis and medialis, biceps femoris, longissimus)
  generally higher in the squat than the box squat, so the quadriceps sit
  below the app's Back Squat (0.90). Gluteus maximus level with the back
  squat's 0.62, not above it (review 2): McBride found activity generally
  lower in the box squat (the glutes were not measured), and no EMG study
  supports raising it. Context only, not a reason for the rank: Fry 2003
  (blocking the knees with a barrier, body-weight load) raised hip torque,
  and Swinton 2012 found the largest hip moments in the powerlifting squat,
  not the box squat; neither matches this model's 15-19° shins.
  Stance width is not used as a reason either: this model's ankles are 0.50 m
  apart (~1.3 x shoulder-joint width), while Paoli 2009 found a glute
  difference only at its widest stance, McCaw 1999's wide stance was 140%
  of shoulder width and Swinton 2012's box squatters stood 92 cm wide.
  Adductors stay a stabiliser, as in the other five squats and the app's
  Back Squat (StrengthLog lists them, but no box squat study measured
  them). Erector spinae just under the back squat's 0.45: McBride 2010
  found longissimus activity generally higher in the free squat. It is not
  lowered further because this model leans 44°.
- Bar cue (shared BAR): high bar keeps the torso more upright and the
  quadriceps working; a low bar brings more lean in back squats — Glassbrook
  2017.
- Back cue: the lean comes with sitting back (Swinton 2012: more vertical
  shin, centre of mass back; Fry 2003: holding the knees back brought more
  trunk lean). "The more you lean, the more the brace has to hold" is
  mechanics (a longer lever from the bar to the lower back), not measured.
  "Brace, back flat" is coaching convention. Review 2 removed the Swinton
  2012 spine claim from this cue: Swinton's box squat (92 cm stance,
  vertical shins, 30-70% 1RM lifted as fast as possible) had the smallest
  peak spine moment of three styles, but this model's high-bar box squat
  (0.50 m stance, shins 15-19° while moving, 44° lean) is not that squat,
  and "peak loading on the spine" reads to a lay user as compression when
  Swinton measured a joint moment.
- Tight cue: the box takes away the bounce so the legs start from a
  standstill — McBride 2010 ("a box squat removes the stretch-shortening
  cycle"); StrengthLog (sit on the box for a few moments; trains force
  generation from the bottom). "Relaxing lets the back round" is coaching
  convention, not measured. StrengthLog also describes a touch-only box
  squat; the model sits, so the copy describes sitting.
- Sit cue: shins closer to vertical, weight further back — Swinton 2012;
  holding the knees back shifts work from the knees to the hips and brings
  more forward lean — Fry 2003 (restricting forward knee travel cut knee
  torque, raised hip torque and increased trunk lean; Fry concluded the
  knees moving slightly past the toes may be appropriate). So the correct
  text asks for shins "fairly upright", not vertical, matching the intro
  and the model (15-19° while moving, 9° on the box); the lean trade-off
  is what the model's 44° shows.
  The copy makes no stance-width claim (the model's stance is only a little
  wider than the shoulders). The copy does not claim more hamstring work (McBride 2010 found biceps femoris
  activity generally higher in the free squat).
- Knee cue: knees over turned-out toes, feet a little wider than the
  shoulders (the model's); caving often shows the hips losing control —
  Powers 2010 (a commentary: hip, pelvis and trunk control can
  affect knee mechanics; it does not say valgus is always a hip problem, so
  the copy says "often").
- Comparison RELAXING ON THE BOX: consistent with the tight cue.
- Setup: box a short step behind where the lifter stands after walking the
  bar out (the model's box front edge is ~18 cm behind the ankles), height
  to put the thighs about parallel (the model's), stance a
  little wider than the shoulders with the toes out (the model's 0.50 m and
  20°; Swinton's box squatters stood much wider, see Model notes).

## Pause Squat

Model: the box squat's bar and grip; ankles 0.42 m apart, toes out 12°; down
~1.1 s, a still hold of ~2.5 s at the bottom (1.75-4.21 s, nothing moves
more than 1 cm or 1°), up ~1.0 s. Bottom: knees 63°, hips 68°, thighs about
parallel, shins 31°, kneecaps ~21 cm ahead of the ankles, trunk 29°.

- Activation = the app's Back Squat (Quadriceps 0.90, Gluteus Maximus 0.62,
  Erector Spinae 0.45). **No study comparing muscle activity with and
  without a pause was found.** The pause changes timing and load
  (StrengthLog: about 90% of the regular squat), not which muscles work, so
  the ranks are the back squat's.
- Pause cue: "A pause takes the bounce out of the bottom." The bounce fades with a half-life under a second — Wilson 1991,
  measured in the **bench press** (the copy says so); two seconds leaves
  ~20% of it (0.5^(2/0.85)), hence "removes most of it". "Squats with a
  pause of about two seconds built strength at least as well as bounced
  squats" — Martínez-Cava 2021 (10 weeks; both groups improved; the pause
  group's effect sizes were larger, 0.76-1.12 vs 0.45-0.92; the abstract
  does not report a significant group difference, so the copy says "at least
  as well", not "better"). Pallarés 2014 used the same 2-s pause for more
  repeatable testing. "Two to three seconds": the model holds ~2.5 s;
  StrengthLog says at least a second, count to three.
- Pause mistake (cutting it short, bouncing) is timing, so it has no ghost
  (see the swift comment).
- Brace cue: coaching convention (no study of trunk position during a
  pause). The comparison's "hips shoot up first" matches StrengthLog's use
  of pause squats against hips rising faster than the bar.
- Depth cue (shared depth()): "the glutes' share of the muscle activity
  rose with depth" — Caterisano 2002 (back squats: gluteus maximus share of
  the summed integrated EMG of four muscles 16.9 / 28.0 / 35.4% partial /
  parallel / full; vasti and biceps femoris shares unchanged). It is an EMG
  proportion, not a share of the mechanical work, so the copy says "muscle
  activity".
- Setup: safety bars just below the pause depth — safe-rack practice (not
  from a cited study; the paused lifter spends longest in the hole).

## Safety Bar Squat

Model: a safety squat bar drawn with a padded yoke over the upper back and
shoulders, two handles forward over the shoulders held in front (hands
~19 cm ahead of and ~9 cm below the shoulder joints, 0.34 m apart), and
cambered ends dropping the sleeves (their centre ~14 cm below, ~13 cm in
front of the neck joint). Checked on the stills: yoke pads, forward handles
and cambered sleeves are all drawn; it is not a straight bar. Ankles 0.42 m,
toes out 12°. Bottom: knees 62°, hips 75°, thighs about parallel, shins 34°,
trunk 23° (6° less than the straight-bar pause squat model — matching the
direction of Hecker 2019's 7.3°).

- Activation Quadriceps HI 0.86, Gluteus Maximus MOD 0.62, Erector Spinae
  MOD 0.40, Lower Trapezius LOW 0.36. Vantrease 2021: similar muscle
  activation at the same relative loads (7 muscles). Hecker 2019: at 75% of
  each bar's 3RM, vastus lateralis -9.3%, hamstrings -15-17%, gastrocnemius
  and rectus abdominis lower (put down to the lighter load), lower
  trapezius +50.3%, trunk and hip flexion 7.3° and 5.7° less. Kristiansen
  2021: more gluteus maximus than a high-bar squat. Johansson 2024: less hip
  flexion and hip extensor torque, similar knee kinetics. So the quadriceps
  a step under the back squat, the glutes level with it, the erector spinae
  lower for the upright trunk, and a low trapezius row ("Lower Trapezius",
  filed under upper back by part_of).
- Handles cue: handles instead of a straight bar ease the shoulders —
  StrengthLog ("the requirement for mobility in the shoulders is also
  reduced"). "Held in close with the elbows down, the handles keep the yoke
  seated" — coaching convention.
- Upper back cue: the load sits slightly further forward — StrengthLog; lower
  trapezius about half again as active and a more upright trunk — Hecker
  2019. The mistake (upper back rounding, chest dropping) is coaching
  convention.
- Knee, depth and feet cues: shared KNEES (Powers 2010), depth()
  (Caterisano 2002) and FEET (Fry 2003 for forward knee travel being
  normal).
- Comparison UPPER BACK ROUNDING: consistent with the torso cue.

## Zercher Squat

Model: straight bar in the crooks of the elbows (elbows ~46°), hands clasped
in front of the chest (0.18 m apart), bar at lower-chest height ~23 cm below
and ~12 cm in front of the neck joint (25 / 7 cm at the bottom). Ankles
0.46 m, toes out 15°. Bottom: knees 61°, hips 80°, thighs about parallel,
shins 33°, trunk 17°.

- **No EMG study of the Zercher squat was read.** Erdag & Yavuz 2020
  (conference chapter comparing front, back, hack, sumo and Zercher squats at
  60% 1RM) exists, but its abstract and text were not accessible, so nothing
  is taken from it. Rows ranked from the app's Front Squat (Quadriceps 0.94,
  Erector Spinae 0.50, Gluteus Maximus 0.40) because both hold the load in
  front with an upright trunk (Gullett 2009: front squat as effective in
  overall recruitment; Yavuz 2015: more vastus medialis and less trunk lean
  in the front squat): Quadriceps 0.88 (a step lower, as the arms usually
  limit the load — StrengthLog), Erector Spinae 0.48, Gluteus Maximus 0.40
  (the front squat's; no source moves it either way). Caterisano 2002 is
  not a reason to raise it: the glute share rose with depth, and the app's
  Front Squat asks for hip crease below the knee, deeper than this model's
  parallel; the stance (0.46 m, toes out 15°) is not wide enough for Paoli
  2009's glute change. Biceps and upper back are stabilisers (they hold the
  bar; no EMG).
- Crook cue: load in front like a front or goblet squat, upright torso; the
  arms want to drop, pull the bar in; elbows close — StrengthLog. The
  mistake ("the arms sagging away from the body and the hands dropping, the
  bar rolling toward the forearms") is coaching convention and matches the
  ghost (elbows ~10 cm ahead, hands ~8 cm lower, elbows opening 46° -> 72°).
  Label: the near elbow (`forearm_L`) projects onto the chest joint in this
  framing, so the label points at the far elbow (`forearm_R`), which is on
  screen with the bar through it. Setup:
  rack just under elbow height, towel for comfort — StrengthLog.
- Back cue: front-loaded squats done with less trunk lean — Yavuz 2015
  (back squat showed greater trunk lean than the front squat). The rounding
  mistake is coaching convention (StrengthLog: keep the back straight).
- Comparison ARMS SAGGING: consistent with the crook cue.

## Overhead Squat

Model: straight bar overhead on straight arms (elbows ~170°), grip 0.92 m,
bar ~49 cm above and 4-5 cm behind the neck joint, directly over the ankles
all clip (within 1 cm fore-aft). Ankles 0.42 m, toes out 12°. Knees 161° at
the top. Down ~1.0 s, ~0.75 s at the bottom, up ~1.75 s. Bottom: knees 57°,
hips 85°, thighs just above parallel (+12°), shins 47°, kneecaps ~29 cm ahead
of the ankles, trunk 18°.

- Activation Quadriceps HI 0.80, Gluteus Maximus MOD 0.50, Erector Spinae
  MOD 0.40, Trapezius LOW 0.34. Aspe & Swinton 2014: at 60-90% of each
  lift's 3RM the back squat drew more activity in the erector spinae and all
  lower-body muscles on the way up, and more peak force; the overhead squat
  only slightly more rectus abdominis and external oblique on the way down
  (2-7%). So all rows sit below the back squat, and the abdominals stay with
  the stabilisers. The trapezius row is from StrengthLog (trapezius
  secondary) and mechanics (holding the bar overhead), not EMG — kept LOW.
- Bar cue: bar slightly behind the head, in line with the heels —
  StrengthLog; the model has it over the ankles, 4-5 cm behind the neck
  joint, so the copy says "over the ankles, slightly behind the head". The
  "shoulders and back have to fight" line is mechanics (a longer lever).
- Elbows cue: grip wider than the shoulders, arms locked, push up into the
  bar — StrengthLog. "Straight, locked arms hold the bar at a steady height"
  is geometry (a locked elbow fixes the arm length). "Gives the bar a stable
  base" restates StrengthLog's locked arms and shoulders pushing up into the
  bar; it is coaching convention, not measured. Review 2 removed the
  unsourced claim that a wider grip makes the bar easier to hold steady.
- Torso cue: needs good shoulder, hip and ankle mobility — StrengthLog.
- Knee cue: label "Knees over the feet", intro "The knees travel well
  forward over the feet and never cave inward" (the model's knees go
  straight ahead, see Model notes); the correct text keeps "push the knees
  out over the middle toes" as the instruction. Knees well past the toes is
  normal while the heels stay down —
  Fry 2003 (knees moving slightly past the toes may be appropriate; the
  model's ~29 cm ahead of the ankle is further than "slightly", see Model
  notes); caving — Powers 2010.
- Depth: "about parallel, or lower if the bar stays over the ankles" — the
  model stops just above parallel (+12°), so the intro says "about
  parallel" (StrengthLog asks for at least parallel; the correct text keeps
  deeper as the aim when mobility allows). Caterisano 2002 for the glute
  line in depth().
- Setup: learn with an empty bar or dowel — coaching convention
  (StrengthLog: requires very good mobility). Library ADVANCED.

## Landmine Squat

Model: a barbell pivoting in a floor landmine ~2 m ahead of the lifter, one
plate on the sleeve and a 0.33 m crosswise handle at the end, both hands on
it at chest height: ~38 cm ahead of the shoulder joints at the top (elbows
97°), ~20 cm at the bottom (elbows 46°) as the arc brings it in. Legs and
timing as the overhead squat; trunk 5° -> 15°.

- Activation Quadriceps HI 0.78, Gluteus Maximus MOD 0.52, Erector Spinae
  LOW 0.30. Collins 2021: at 30% of body mass the landmine squat drew less
  vastus medialis and lateralis activity and less vertical force than the
  goblet squat, more backward horizontal force; hamstring changes differed
  by sex, so no hamstring row. Quadriceps set below the app's Goblet Squat
  (0.85); gluteus maximus as the goblet squat (not measured); erector
  spinae low — StrengthLog (lower back only secondary; "doesn't ... tax
  your lower back very much").
- Handle cue: label "Handle at chest height"; intro "Both hands hold the
  handle at chest height in front of the body; it rides in toward the chest
  as you sink"; correct "Hold the handle at chest height with the elbows
  down, let it ride in toward you as you sink, and do not let it drift
  further out" — the model (38 cm ahead of the shoulder joints at the top,
  ~20 cm at the bottom). The arc toward the chest is geometry of the pivot;
  "held close, the load stays near the body and the trunk can stay
  upright" (the why) is the general principle and coaching convention.
  StrengthLog says hands rest against the top of the chest; the model holds
  the handle about a forearm's length in front at the top, so no string in
  the copy (label, intro, correct, setup step 2, comparison) says the handle
  is held close to or at the chest for the start position: they say "at
  chest height". Setup introduces the handle ("the loaded end, or a handle
  attachment on it").
- Torso cue: "the bar leans on you from its pivot in front, pushing back as
  well as down into your hands" — statics: a bar pivoting on the floor and
  held still at chest height needs the smallest hand force at right angles
  to the bar (forward and up), so it pushes on the lifter mostly down and
  partly back (with the pivot ~2 m away at chest height, roughly 0.84 down,
  0.54 back), not along its length. "Compared with a goblet squat, the
  landmine squat produced more backward and less vertical force" — Collins
  2021 (ground-reaction forces: posterior horizontal force up, vertical
  force down; it did not measure the force along the bar); "asks little of
  the lower back" — StrengthLog.
- Knee cue as the overhead squat's (label "Knees over the feet"; Fry 2003,
  Powers 2010).
- Comparison HANDLE DRIFTING AWAY: consistent with the handle cue.
- Library LANDMINE, beginner (StrengthLog: a stable squat that does not
  need much mobility).

## Model notes (where the model differs from textbook technique)

- Box squat: the textbook powerlifting box squat (Swinton 2012) uses a very
  wide stance (~92 cm) and near-vertical shins with a low bar. This model
  stands only a little wider than the shoulders (ankles 0.50 m), carries a
  high bar, and its shins tip 9° on the box and 15-19° on the way down and
  up. The copy describes a high-bar box squat with a moderately wide stance
  and says "shins fairly upright / closer to vertical", not vertical. The
  44° lean on the box is more than the other models' 17-29°, as expected
  when sitting back to a box.
- Box squat: StrengthLog allows either touching the box or sitting on it;
  the model sits for ~1.2 s, so the copy teaches sitting and staying tight.
- Pause squat: the pause is ~2.5 s and fully still; the copy asks for two to
  three seconds.
- Safety bar: the model's safety bar is a real cambered bar with yoke pads
  and forward handles; nothing to correct.
- Zercher: the hands are clasped high, in front of the chest, rather than
  low in front of the belly; the copy says "clasp the hands" without a
  height.
- Overhead squat: the knees never fully lock at the top (161°); the copy
  does not mention the top lockout. The grip (0.92 m, ~2.4 x shoulder-joint
  width) is wide but narrower than a typical snatch grip; the copy says
  "wide", not "snatch". The thighs stop just above parallel (+12°, the hip
  joint ~9 cm above the knee joint); the copy asks for "about parallel, or
  lower if the bar stays over the ankles" (StrengthLog: at least parallel);
  the ghost for depth draws a clearly higher stop (13 cm), so the model
  still reads as the correct side. The knees travel ~29 cm ahead of the ankles, well past the toes: the
  copy says this is normal while the heels stay down (Fry 2003 supports
  forward knee travel but studied a parallel back squat with a body-weight
  load).
- Landmine: same leg motion as the overhead squat: the thighs stop just
  above parallel (+12°, the hip joint ~9 cm above the knee joint), knees
  well forward. The copy asks for "about parallel", which the model only
  just reaches. The handle is held ~38 cm in front of and ~10 cm below the
  shoulder joints at the top (elbows 97°, forearms about level, roughly a
  forearm's length off the chest), and comes in to ~20 cm only at the
  bottom; so the label, intro, correct text, setup and comparison say "at
  chest height", not "close to the chest".
- Overhead and landmine squats: the knees travel straight ahead rather than
  out over the turned-out toes. At the bottom the kneecap is 29 cm ahead of
  the ankle and ~1 cm inside it, while the feet point 12° out, so the toe
  line would put it ~6 cm further out (0.29 x tan 12°): the knees sit ~6-7
  cm inside the toe line, ~14° off the foot direction. The other four
  models do track the toes (knee over ankle outward 2-6 cm). So on these two
  the label reads "Knees over the feet" and the intro "travel well forward
  over the feet and never cave inward"; the correct text keeps the
  instruction to push the knees out over the middle toes. The `kneesIn`
  ghost (~10 cm further in) still reads as the fault.

## Ghosts and when to still them

Framing -1.0: sagittal faults `.seen(-0.4)` (total -1.4, near side-on), the
knee fault `.seen(0.8)` (total -0.2, near face-on). Overhead -0.8: `-0.6` /
`0.6`. Landmine -0.9: `-0.5` / `0.7`.

Reused pieces: `barSlidLow` (split squat pieces: the bar slid low, 10° more
lean), `chestDropped`, `kneesIn`, `shallow`, `heelsUp`, `leanedForward`,
`armsTurned(.lateral, -14, withBar: true)` for the overhead bar drifting
forward (negative swings overhead arms forward).

New pieces, checked with a Python port of `FaultGhost.solve` on each rig at
the bottom (Blender's bundled Python for `pxr`):
- `barbellBoxRockedBack`: trunk rocks back 18° and the lower back rounds; on
  the box the neck goes ~15 cm back and ~10 cm up, the trunk from 44° to
  ~26°; knees unchanged (84°).
- `barbellBoxKneesForward`: hips 12 cm forward (pelvis 3.7 cm behind the
  box's front edge instead of 15 cm), trunk 44° -> 32°, the knees ~8 cm
  further forward and bent to 74°.
- `barbellHandlesPushedAway` (safety bar): hands 12 cm ahead and 5 cm up,
  elbows ~14 cm forward (the upper arms lift forward; the elbows rise only
  ~1 cm, so the mistake text no longer says "elbows up").
- `barbellZercherArmsSagging` (review 1): trunk 8° forward, upper arms 15°
  forward about the shoulders, forearms opened 30° about the elbows; at the
  bottom the elbows (and bar) ~10 cm ahead and ~2 cm lower (~7 cm further
  from the chest), hands ~8 cm lower and ~17 cm ahead, elbow 46° -> ~72°,
  neck ~8 cm forward. Rigid turns only (no re-seat), so the arm lengths
  hold. No bar line (the hands are clasped). The first version shifted the
  hands 13 cm down and re-seated the elbows, which moved them only ~3-4 cm
  and read as the hands dropping rather than the arms sagging away.
- `barbellOverheadElbowsBent`: hands 10 cm lower, elbows ~11 cm forward.
  `armsTurned(.lateral, -14)`: the bar (hand tips) ~14 cm ahead of the
  ankles, same height.
- `barbellLandmineHandleAway`: hands ~24 cm ahead and 5 cm lower. No bar
  line (one short handle).
- Pause and other depth ghosts `shallow(0.22)`: hips 13 cm higher, knees
  63° -> 83° on the pause squat.

Still moments (fault_moments_legs30_barbell.json):

| Exercise | Cue | Moment |
|---|---|---|
| Box Squat | bar, back, tight, sit, knee | bottom |
| Pause Squat | bar, brace, depth, knee | bottom |
| Pause Squat | pause | no ghost (timing) |
| Safety Bar Squat | handles | any |
| Safety Bar Squat | torso, knee, depth, feet | bottom |
| Zercher Squat | crook, back, knee, depth, feet | bottom |
| Overhead Squat | bar, torso, knee, depth | bottom |
| Overhead Squat | elbows | any |
| Landmine Squat | handle, torso, depth, knee, feet | bottom |

The bottom faults scale with the knee's bend (`withBend("shin_L")`), full at
the bottom; the handles and elbows ghosts are constant.

## Labels

Rows are written on the 0.14-0.86 scale and squeezed to 0.16-0.80 by
`spec_legs30.py`. Checked by drawing the laid-out pills and leaders over the
start and bottom stills (scratchpad `bb/overlay.py`), and (review 1) by
testing every pill against all 8 probed joint moments and every pair of
leaders for crossings (scratchpad `rev1bb/pills.py`): on the box and pause
squats the bar label sits top left above the left plate, the torso label
below it, short enough to end before the head at the bottom. The knee
labels on the box, pause, safety bar and Zercher squats read "Knees out"
(the longer "Knees out over toes" pill covered `patella_R`); the pause
squat's sits on the middle row, where the pill clears the knee at all 8
moments. Box squat: "Stay tight on the box" at row 0.32 right (only brushes
`hand_L` on the way up), "Sit back to the box" at 0.86 right over the box
face. Pause squat: the pause label at 0.32 right (at 0.50 it covered
`hand_L` at the bottom). Zercher: the elbow label top left to `forearm_R`,
the back label top right to the chest, so the leaders no longer cross. The
overhead squat's bar and elbow labels sit top right by the near hand and
elbow. Review 2: the pause squat's brace label is "Chest up" (the longer
"Chest up, braced" sent its leader through the trap dot during the hold);
the safety bar and Zercher depth labels read "Thighs parallel" (the longer
pill started on the near hip at the bottom); the overhead and landmine knee
labels read "Knees over the feet". Landmine: the depth label moved to 0.68 left (on the right at 0.68
it covered the pelvis at the bottom; at 0.50 right its leader crossed the
torso label's). Verify in the simulator.

## Uncertain

- No EMG data for the Zercher squat or for paused vs unpaused squats; their
  rows are extrapolated as described.
- The box squat's glute rank (0.62, level with the back squat's) has no
  EMG of the glutes in a box squat behind it; McBride 2010's generally lower
  activity in the box squat keeps it from going higher.
- Erdag & Yavuz 2020 (Zercher squat EMG) exists but was not read.
- The overhead squat's and safety bar squat's trapezius rows are low-
  confidence (mechanics / one study of the lower trapezius).
- Wilson 1991's decay was measured in the bench press.
- ExRx could not be read (live site blocks automated fetches; the Internet
  Archive was offline on 2026-09-28). Lincoln 2022 (SCJ, safety squat bar
  technique) and Ronai & Scibek 2024 (ACSM HFJ, landmine squat) are closed
  access and were not used.

## Change log

- 2026-09-28: first draft of all six (copy, ghosts, moments, notes).
- 2026-09-28: after checking the ghosts on the rigs: the safety bar handles
  mistake no longer says "elbows up" (the elbows move forward, ~1 cm up);
  piece comments carry the measured moves. Copy corrections before the
  first check: the box squat's spine claim reworded to Swinton's "loaded the
  spine least of three styles"; the sit cue no longer claims more hamstring
  work; the landmine handle is "close in front of the chest" (the model
  does not hold it against the chest); the landmine torso cue cites Collins
  2021's force direction instead of a back squat comparison; a Zercher
  "lift the elbows" instruction with no source was removed. Landmine depth
  label moved to row 0.68.

## Change log (review 1)

- Zercher Squat: Gluteus Maximus 0.46 -> 0.40 (the front squat's); the
  Caterisano 2002 reason is dropped (it runs the other way: the app's Front
  Squat is deeper than this model's parallel). Spec comment and notes
  rewritten.
- Box Squat: the sit cue no longer says a wide stance drew more glute
  activity; the glute rank (0.66) now rests on Fry 2003 and Swinton 2012;
  adductors moved from an MOD activation row to the stabilisers, as in the
  other five squats and the Back Squat. Knee cue says "feet a little wider
  than the shoulders" instead of "a wider stance".
- Box Squat: the back cue's Swinton 2012 claim is qualified ("using a
  wide-stance box squat with near-vertical shins, peak loading on the spine
  was lowest of three squat styles").
- Box Squat: setup step 1 puts the box a short step behind where you stand
  after walking the bar out (not behind the rack).
- Shared depth(): "the glutes' share of the muscle activity rose with
  depth" (was "of the work"; Caterisano measured EMG shares).
- Pause Squat: "A pause takes the bounce out of the bottom."
- Safety Bar Squat: header now says Vantrease 2021's 1RM was 11.6% higher
  with the straight bar (144.7 vs 128.8 kg); ghost table comment no longer
  says "elbows up".
- Overhead Squat: elbows why reworded ("lowers the bar over the head, which
  makes it easier to hold steady over the feet"); depth intro "about
  parallel", correct text "about parallel, or lower if the bar stays over
  the ankles" to match the model's just-above-parallel stop.
- Landmine Squat: torso why reworded (the bar pushes back as well as down,
  not along its length; Collins 2021 described as backward vs vertical
  force); label "Handle at chest height" and intro "at chest height in
  front of the body; it rides in toward the chest as you sink"; setup step
  2 mentions a handle attachment; Model notes give the 38 cm / 20 cm handle
  distances and the just-above-parallel depth.
- Zercher Squat: the arms-sagging ghost rebuilt with rigid turns (upper arms
  15° forward, forearms opened 30°), so the elbows and bar move ~10 cm away
  from the body instead of ~4 cm; the mistake text now reads "the arms
  sagging away from the body and the hands dropping, the bar rolling toward
  the forearms and pulling the chest forward".
- Labels: "Knees out" on the box, pause, safety bar and Zercher squats (the
  longer pill hid `patella_R`); pause squat knee label to row 0.50 left and
  pause label to 0.32 right (it covered `hand_L`); box squat tight label to
  0.32 right and sit label to 0.86 right; Zercher elbow label to `forearm_R`
  top left and back label top right (the leaders crossed on one point);
  landmine depth label to 0.68 left (it covered the pelvis at the bottom).
  All checked against the 8 probed moments with `rev1bb/pills.py`.

## Change log (review 2)

- Box Squat, back cue: the Swinton 2012 spine clause is dropped. Its box
  squat (92 cm stance, vertical shins, 30-70% 1RM lifted fast) is not the
  squat on screen (high bar, 0.50 m stance, shins 15-19° while moving, 44°
  lean), and "peak loading on the spine" paraphrased a joint moment. The
  why now ends "and the more you lean, the more the brace has to hold"
  (mechanics). Swinton 2012 stays for the sit cue's shins and centre of
  mass.
- Box Squat, sit cue: why adds "and brings more forward lean" (Fry 2003
  measured both); correct text "keep the shins fairly upright" (was "close
  to vertical"), matching the intro, the model and Fry's conclusion.
- Box Squat: Gluteus Maximus 0.66 -> 0.62 (level with the Back Squat); the
  reason is McBride 2010 (activity generally lower in the box squat, glutes
  not measured); Fry 2003 and Swinton 2012 hip torque kept as context only.
  The erector row (0.42) now cites McBride's longissimus result.
- Overhead Squat, elbows why: "A grip wider than the shoulders, with the
  elbows locked and the arms pushing up into the bar, gives the bar a
  stable base" (StrengthLog) replaces the unsourced "lowers the bar ...
  easier to hold steady".
- Landmine Squat: correct text, setup step 2 and the comparison
  (correctCue "Handle at chest height", correctNote "Held at chest height")
  no longer say the handle is held close to or at the chest; the Handle cue
  and Model notes entries now describe every string.
- Overhead and Landmine Squats: knee label "Knees over the feet" (was
  "Knees out over toes", same length, same layout); intro "The knees travel
  well forward over the feet and never cave inward." Model note added: the
  knees go straight ahead, ~6-7 cm inside the toe line at the bottom.
- Pause Squat: brace label "Chest up" (was "Chest up, braced"); its leader
  now passes the bar label's trap dot ~0.06 lower during the hold (v 0.49
  vs 0.43 at u 0.41), so the two leaders no longer meet on one dot.
- Safety Bar and Zercher Squats: depth label "Thighs parallel" (was "Thighs
  to parallel"); the pill now starts at u 0.68, clear of the near hip at
  the bottom (thigh_L u 0.63-0.64).
- Documentation: `patella_R` is described as the knee on the screen-left
  side (the lifter's far knee), not the near knee, in Shared facts and the
  box and pause squat spec comments.
- Checked with `rev1bb/pills.py` (no pill covers a probed joint at any of
  the 8 moments; no leaders cross), `python3 spec_legs30.py barbell` and
  `check_faults_legs30.py` (ghost files unchanged this round).
