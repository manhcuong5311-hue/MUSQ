# Notes: family female (Desktop "1-100" folder, 2026-10-10)

Three exercises on the female model: Hack Squat (Stances), Pendulum Squat
(Stances), Cable Knee-Drive Kickback. Spec: `spec_1010_female.py`; ghosts:
`Tools/fault-review/faults_1010_female.swift.txt`; moments:
`fault_moments_1010_female.json` (all given in seconds).

The two stance sets are one exercise each (the owner: "đó là 1 bài nhưng có
những stance"): the trainer opens on the Standard model and the picker swaps
in High, Low, Wide or Narrow. Labels, ghosts and the exercise-level
activation are authored once, on the Standard model; the activation uses the
Standard paint (what recovery counts); per-stance muscle lists and picker
notes are handled separately and are not in this family. Every line of copy
was checked against the numbers of all five stances below, and stance
differences are only named where they were measured.

## How the models were read

- `$LAB/femwork/dump.py` (session scratchpad; Blender's Python + pxr) wrote
  every joint's world position and Y axis every frame, plus the equipment's
  bounding boxes, for all eleven rigs (five hack stances, five pendulum
  stances, the step-down). `an.py` / `cmp.py`: knee = thigh-shin inner
  angle, hip = neck-hip-knee, trunk lean = neck over pelvis from vertical,
  positions in the lifter's level axes. `ghost.py` is the legs family's
  Python port of `FaultGhost.solve` (one bug fixed: a `*` turn pivoting on a
  `.tip` read the wrong side letter) used to size every ghost.
- The hack and pendulum rigs face -x (their left is +z), so the briefs'
  "sideways +17°" is the trunk leaning 17° back on the pad; the step-down rig
  faces +z like the male rigs. Framings: hack 0.6 is a front-left
  three-quarter (0 would be side-on from the left), pendulum 0 is side-on
  from the left, step-down -1.0 a front-left three-quarter.
- One body: neck to pelvis 0.50 m, hip joints 18 cm apart, shoulder joints
  39 cm apart.
- The motion briefs (`briefs_1010/`), tiers.txt, joints.json and the trainer
  stills were read first; the numbers below are my re-measurements.

## Model facts used in the copy

Hack Squat (Stances) — 5.96 s, one rep, the owner's cycle (lift slightly,
unlock, squat, lock, lower slightly):
- 0-0.5 s knees 140° -> 150° (the sled lifts off its stops); the safety
  handle (LS_CTRL_RestLock) swings from level to hanging between 0.5 and
  1.0 s and back by ~5.5-6 s. Top held to ~1.7 s; down 1.7-3.0 s (~1.3 s);
  pelvis within 5 mm of the bottom 3.08-3.58 s ("about half a second"); up
  3.6-5.0 s (~1.4 s). Hands on the handle frame by the shoulders all clip.
- Trunk 17° back from vertical on the back pad every frame; the hips travel
  44 cm down and 5 cm back in all five stances ("the sled's path and timing
  stay the same", "about 44 cm down", "about 17 degrees back").
- Plate treads rise ~20° toward the toes; ankle and toe heights constant all
  clip in every stance (heels flat).

| stance | ankles apart | toe-out | top knee | bottom knee / hip | hips vs knees at bottom | knee outside ankle | knee vs toe joint |
|---|---|---|---|---|---|---|---|
| Standard | 27 cm | 9° | 150° | 73° / 103° | 4.7 cm below | 5.0 cm | 6 cm behind |
| High (feet 9 cm up the plate) | 27 | 9° | 154° | 80° / 98° | 8.8 below | 5.1 | 16 behind |
| Low (8 cm down) | 28 | 7° | 152° | 70° / 108° | level | 3.2 | 1.7 past |
| Wide | 48 | 16° | 156° | 76° / 103° | 5.5 below | 1.8 | 8 behind |
| Narrow | 18 | 4° | 150° | 73° / 102° | 4.5 below | 4.4 | 6 behind |

-> "knees bend to between about 70 and 80 degrees", "level with the knees or
up to about 9 cm below them", "each knee about 2 to 5 cm outside its ankle",
"150 to 155 degrees at the top, 25 to 30 degrees short of straight" (156° on
Wide rounds into it), "toes turned out a little". No copy says the knees stay
behind the toes (Low passes them by 1.7 cm).

Pendulum Squat (Stances) — 7.96 s, two 4 s reps:
- Top 0-0.4 s (knees 155° in every stance), down to 1.75 s (~1.35 s, "about
  1.4 seconds"), pelvis within 5 mm of the bottom 1.62-2.21 s (knee 67° held
  1.75-2.08 s; "about half a second"), up to 3.75 s (~1.6 s).
- Shoulders under the pads, back on the pad, hands on handles 24 cm in front
  of and 14 cm below the shoulders. The fixed footplate rises ~35° toward the
  toes (its ribs climb from y 0.29 to 0.63 m over 0.49 m toward the toes);
  ankle and toe heights constant all clip.
- The pad tips the trunk from 19-21° back at the top to 30-38° at the bottom
  in the five stances; the hips travel down and toward the plate (Standard 29
  cm down, 28 cm forward; Low 21 cm down).
- Bottom: Standard knee 67°, hip 112°, hips 12.7 cm below the knees, knees
  5.4 cm outside the ankles; High 65°, 21.6 cm below, 5.5 cm; Low 87°, hips
  3.6 cm ABOVE the knees (thighs about level), 3.2 cm; Wide (47 cm, toes out
  18°) 67°, 14.8 below, 4.8; Narrow (18 cm, 4°) 71°, 11.2 below, 4.3. Knees
  9-17 cm behind the toe joints at the bottom in every stance. -> "about 65
  degrees with the feet high to about 87 with them low", "3 to 6 cm outside
  its ankle", "about 67 degrees ... about 13 cm below the knees; with the
  feet low the thighs only reach about level".
- Unlike the library's Pendulum Squat (hips down and back, heel-high plate,
  hips to 66°), here the hips move toward the plate and only close to ~112°
  (102-126° across stances) while the knees bend ~90°.

Cable Knee-Drive Kickback — 7.96 s, two 4 s reps. Despite its name the model is a
standing cable kickback from a knee drive:
- Right foot flat on a round plate 6.5 cm high (CSD_RightFoot_Plate, 45 cm
  across), right knee 160° every frame; trunk 32° forward every frame; pelvis
  fixed, level (hip joints at the same height) and square (hip line yaw 0°);
  hands on the tower upright at ~1.31 m (chest height), elbows 121-131°.
- Ankle cuff on the LEFT ankle; the cable runs to the low pulley ~0.6 m up
  (about knee height; the standing knee joint is at 0.62 m), ~0.6 m in front
  of the hips.
- Left leg: 0-0.38 s knee up in front (hip 81°, knee 90°, thigh 68° forward
  of vertical); pushed back 0.42-1.79 s (1.37 s); held 1.83-2.17 s (hip
  170°, knee 170°, thigh 36° behind vertical); returned 2.21-3.58 s (1.37 s);
  held in front 3.62-4.38 s. The left toe never comes lower than 18 cm off
  the floor. -> "about 80", "about 170", "about 36 degrees behind
  vertical", "about a third of a second", "about 1.4 seconds, as long as the
  push back took", "through about 90 degrees at the hip".

## Sources and what each supports

All opened in this pass (ExRx via Wayback `id_` snapshots, Europe PMC REST
abstracts, PMC full text for Stien, StrengthLog live).
- ExRx Sled Hack Squat (snapshot 2026-07-17): lie on the back pad, shoulders
  under the shoulder pad, feet slightly higher than the base of the sled,
  extend hips and knees, release the dock levers; re-engage the support
  lever in the extended position before dismounting; "If insufficient hip
  flexibility forces pelvis to pull away from back pad ... only lower sled
  just short of spinal articulation"; knees the same way as the feet; heels
  down, push with heel and forefoot; feet slightly high emphasise the
  gluteus maximus, slightly low the quadriceps; target quadriceps,
  synergists gluteus maximus, adductor magnus, soleus, dynamic stabilisers
  hamstrings, gastrocnemius. -> hack feet, pad, knees, top (safety lever),
  setup; pendulum feet and knees ("on the hack squat"); activation.
- ExRx Cable Standing Hip Extension (snapshot 2025-04-20): ankle cuff on a
  low pulley, grasp a bar with both hands, pull the cable back by extending
  the hip; target gluteus maximus, synergist hamstrings, stabilisers erector
  spinae, obliques, quadratus lumborum, gluteus medius, minimus. (Its
  version keeps the leg straight with the foot just off the floor; the model
  starts from a knee drive, so the copy follows the model.) -> step-down
  torso, kick, hips, grip; activation and stabilisers.
- StrengthLog Hack Squat: feet about shoulder width, extend the legs and
  disengage the locks, squat as deep as you can with good form; feet high ->
  more glute, low -> more quad and calf activity; little difference with
  width or toe angle; less core activity than free squats (cites Escamilla
  2001, Da Silva 2008, Clark 2019, Erdag & Yavuz 2020). -> hack depth, setup.
  StrengthLog Pendulum Squat: feet slightly about hip-width, back pressed
  against the backrest throughout, release the safety latch, lower yourself
  slowly until the thighs are parallel or slightly lower, push through the
  heels; primary quads, glutes, adductors. -> pendulum feet, pad, depth,
  tempo (lower slowly; added in review), setup, stabilisers.
- Da Silva et al. 2008 (Abs): 14 women, leg press high vs low feet: low feet
  more rectus femoris and vastus lateralis at high effort, high feet more
  gluteus maximus. -> hack feet ("as a leg press study in women found").
- Escamilla et al. 2001 (Abs): 10 men, high/low foot leg press, wide/narrow,
  feet straight or out 30°: no difference between foot angles; no knee-force
  difference high vs low; wide high-foot press more hamstrings. -> notes only
  (supports "toes turned out a little" being a comfort choice).
- McCaw & Melrose 1999 (Abs): stance width "does not cause isolation within
  the quadriceps but does influence muscle activity on the medial thigh and
  buttocks". Paoli et al. 2009 (Abs): only the gluteus maximus changed with
  width (higher at the widest). -> hack feet ("a wider stance changed
  inner-thigh and glute activity but did not single out any part of the
  quadriceps").
- Clark et al. 2019 (Abs): 10 men, trunk muscle activation higher in the back
  squat than the hack squat for all muscles and phases but one. -> hack and
  pendulum pad.
- Bryanton et al. 2012 (Abs): 10 strength-trained women, knee extensor
  relative muscular effort rose with depth (joint moments, not EMG). -> both
  depth cues, pendulum comparison ("work closest to their maximum").
- Caterisano et al. 2002 (Abs): gluteus maximus share of EMG rose with
  depth. -> activation notes only.
- Schoenfeld & Grgic 2020 (Abs): full ROM favours lower-body hypertrophy. ->
  hack depth.
- Stien et al. 2021 (PMC7919354, methods read): standing kickback machine
  from hip 90° to 180°: gluteus maximus EMG not different from the leg
  press, biceps femoris higher. -> step-down hamstrings row (notes only).
- Kubo et al. 2019 (Abs) was re-read but is not cited in the copy.

## The owner's stance notes vs the sources (for the per-stance lists)

The Blender notes give: Standard = overall legs; High = more glutes; Low =
more quads; Wide = inner quads; Narrow = outer quads. High/Low agree with
ExRx, StrengthLog and Da Silva 2008 (leg press). Wide/Narrow as "inner /
outer quads" are not supported: McCaw & Melrose 1999 and Paoli 2009 found no
shift between the quadriceps' heads with stance width (wider raised the
gluteus maximus and, in McCaw, the adductor longus). The exercise-level copy
therefore says only that width changes inner-thigh and glute activity; whoever
writes the per-stance notes should not claim "inner quads" / "outer quads".
The Wide models paint the sartorius bright (hack: with the vastus medialis;
pendulum: with the adductors and gracilis), the Narrow models the vastus
lateralis alone.

## Mechanical reasoning (no source; marked as such)

- Hack/pendulum: the sled or carriage guides the trunk, not the knees; a
  knee stopped short of lockout keeps the thighs holding the sled; the
  swinging carriage builds momentum on the way down (as the library's
  pendulum copy).
- Step-down: arching the lower back adds range from the spine, not the hip
  (as the library's kickback); a rolled-open hip turns the kick into
  something other than straight hip extension; holding the tower takes
  balance out of the way; the standing leg only steadies you.
- Tempo, pauses and "stop before the pelvis tucks" are coaching convention
  shown by the model; the timings are the model's.

## Activation decisions

Bright = primary, dim = secondary, no exception.
- Hack (Standard paint: quads + all three glutes bright, hamstrings dim):
  Quadriceps P 0.88 (library Hack 0.89, Pendulum 0.88; ExRx target);
  Gluteus Maximus P 0.50 (bright; ExRx synergist; above the library Hack's
  0.44 secondary for thighs below level, Caterisano 2002; the medius and
  minimus covered by this row and named in the stabilisers, the legs
  family's house decision); Hamstrings S 0.25 (dim; ExRx dynamic
  stabilisers). Judgement calls.
- Pendulum (quads bright; glutes and hamstrings dim): Quadriceps P 0.88
  (library); Gluteus Maximus S 0.40 (dim; below the library's 0.48 because
  the hips close only to ~112°); Hamstrings S 0.20 (dim). No pendulum EMG
  exists. Judgement calls.
- Step-down (glutes bright, hamstrings dim): Gluteus Maximus P 0.84 (library
  Cable Glute Kickback; ExRx target; medius/minimus covered, in the
  stabilisers with ExRx's erector spinae, obliques, quadratus lumborum);
  Hamstrings S 0.50 (library kickback; ExRx synergist; Stien 2021).
- Levels: 0.88 HIGH, 0.84 HIGH, 0.50 MODERATE, 0.40 MODERATE, 0.25 / 0.20
  LOW; validate() passes.

## Labels

Pills hug the screen edges; rows were planned on a grid over the stills and
checked with an overlay of gen.layout drawn on the stills, then in three lab rounds.
- Hack (yaw 0.6): the carriage, loaded plate and two yellow safety handles
  move through the right half from v 0.27 to 0.85, so the right side is used
  only at 0.86 (static base): "Knees track out" (to the left knee, the leader
  arriving from below right). Left side: "Back on the pad" 0.16 (leader over
  the right arm to the chest; any leader to the back pad crosses the trunk
  from this view), "Soft knees at the top" 0.40 and "Thighs to level" 0.50
  (short, left of the right thigh, which reaches u 0.36), "Feet flat on the
  plate" 0.86 over the static plate below the shoes. First lab round: both
  bottom pills at 0.88 sat ~10 pt above the legend, which takes two rows on
  the stance sets (the picker also shortens the viewport), so both moved up
  to 0.86, still clear of the shoes (their soles end at ~0.83).
- Pendulum (yaw 0): the beam and pad sweep the top half, so "Lower slowly,
  pause" sits at 0.20 right (above the beam and the head), "Knees track out"
  0.44 left (was "Knees over the toes"; renamed in review) (under the beam, above the knees), "Back on the pad" 0.75
  and "Thighs level or lower" 0.81 right over the static posts and base
  (second lab round: at 0.70 the pill's left end touched the swinging pad's
  lowest corner near the bottom of the rep, so both moved down), "Whole foot on the plate" 0.86 left on
  the static plate (0.88 in the first round, too close to the two-row
  legend). The pad and depth leaders reach the spine and pelvis from below,
  past the glutes: from this side-on view any leader to the back pad crosses
  the hips or the trunk.
- Step-down (yaw -1.0): "Hold the tower" 0.16 left over the static tower,
  "Lean forward, back still" 0.20 and "Hips square" 0.32 right in open
  space, "Push the foot back" 0.84 right below the foot's backmost point,
  "Right foot on the plate" 0.88 left below the plate. The kick leader
  crosses the standing shin while the working foot is in front of it (about
  a third of the clip); a leader to the moving foot from either side crosses
  the standing leg in one half of the swing.

## Ghosts

One per position cue. No ghost (red ring): pendulum "tempo" (speed),
step-down "grip" (force). Sizes on the Standard rigs, ghost.py:
- Hack, all side-on (view -0.6, total 0) but the knees (0.9, total 1.5):
  feet = heelsUp (heels ~8 cm up, knee 73° -> 68°); pad =
  machineHipsOffPad (hips ~6 cm off the pad); knees =
  thruster500KneesIn(0.2) (~10 cm each, bones kept); depth = shallow(0.3,
  ahead 0.04) (hips ~15 cm up the sled's path, knee 73° -> ~91°: "only to
  about a right angle"); top = kneesSnapped at 1.0 s (strength 0.67, 150°
  -> ~174°, bones ~3% short as the shared piece draws them).
- Pendulum (side-on as framed; knees turned 1.2): heelsUp (~8 cm, 67° ->
  61°), machineHipsOffPad (~6 cm), thruster500KneesIn(0.2) (~10 cm),
  shallow(0.27, ahead -0.3) (hips ~14 cm up and ~15 cm back along the arc,
  knee 67° -> ~100°).
- Step-down (whenStraight on the left hip, read from the mid-spine joint:
  0.55 at the back of the kick, 0 with the knee up): torso =
  fem1010KickArched (mid-spine ~4.4 cm toward the belly, thigh 56° behind
  vertical instead of 36°), kick = fem1010KickShort (thigh about vertical,
  knee ~129°), hips = fem1010HipOpened seen from behind (view -2.1, total
  -3.1; foot ~16 cm out, hip line turned ~12°), stance = rearLegPushing("R")
  (standing knee 160° -> 180°, ~8 cm back). Angles were doubled from the
  first draft because the mid-spine reading caps the strength at 0.55.
- Moments in seconds: hack bottom 3.3 s, top 1.0 s; pendulum bottom 1.9 s;
  step-down back of the kick 2.0 s ("Cable Knee-Drive Kickback" has no fault_times
  rule and would fall to `press`).

## For the builder / shared files (not changed here)

- The library row for "Cable Knee-Drive Kickback" says primaryMuscle QUADRICEPS, but
  the model is a glute-painted standing kickback (the standing knee never
  moves; only the cuffed leg extends the hip). The Cable Glute Kickback row
  uses GLUTEUS MAXIMUS; that word fits here too. The name could also be
  revisited ("step-down" usually means lowering the body off a step on one
  leg, which the model does not do).
- The step-down's grip: ExRx keeps the elbows straight; the model's are bent
  ~125°. The copy says "elbows bent", matching the model.
- App layout (shared code, seen in the lab): on the two stance sets the
  fault view's COMMON MISTAKE chip is drawn over the stance picker (both sit
  at the top of the trainer), so the picker's High / Low / Wide labels are
  hidden while a ghost shows. The chip should sit below the picker, inside
  the viewport, as on the other trainers.
- The pendulum legend's first row (QUADRICEPS PRIMARY) is drawn over the
  machine's dark base at this framing and is hard to read; a slightly higher
  offset or a scrim behind the legend would fix it.


## Review (independent reviewer, 2026-10-10)

Sources re-opened in this pass: ExRx Sled Hack Squat and Cable Standing Hip
Extension (Wayback `id_` snapshots), StrengthLog Hack Squat and Pendulum
Squat (live), and the Europe PMC abstracts of Da Silva 2008, McCaw &
Melrose 1999, Paoli 2009, Clark 2019, Bryanton 2012, Caterisano 2002,
Schoenfeld & Grgic 2020, Stien 2021 and Escamilla 2001. Every claim the copy
hangs on them is in the text (ExRx: dock/support levers, pelvis pulling
off the pad, knees with the feet, heels down with heel and forefoot, high
feet glutes / low feet quads, a ballet bar held with both hands, the
stabiliser lists; StrengthLog: as deep as you can, parallel or slightly
lower, backrest throughout, heels, safety latch, lower slowly). Model numbers
spot-checked from the author's dumps (hack Standard/Wide knees 150/156° at
the top and 73/76° at the bottom, trunk 17° all clip, hips 5 cm below the
knees; pendulum Standard 67°, hips 13 cm below the knees, trunk 20° -> 36°,
Low 87° with the hips 4 cm above the knees; step-down hip 81° -> 170°, knee
90° -> 170°, standing knee 160°, trunk 32°): all match the copy. Activation
matches the Standard paint in tiers.txt for all three (hack: quads and
glutes bright, hamstrings dim; pendulum: quads bright, glutes and hamstrings
dim; step-down: glutes bright, hamstrings dim).

Changed (spec only; ghosts, moments and layout rows unchanged):
- Hack feet: "in squat studies a wider stance changed inner-thigh and glute
  activity" -> "in free-squat studies stance width changed glute and
  inner-thigh activity". Paoli 2009 found only the gluteus maximus changed
  (adductor magnus did not); McCaw 1999 says width influences the medial
  thigh and buttocks without giving a direction for the adductor, so the
  copy no longer pins the inner-thigh change on the wider stance.
- Hack top: "stay bent between reps" -> "through the top hold" (the model is
  one rep); "ExRx re-engages the safety lever with the legs extended like
  this" -> "the support lever with the legs extended" (ExRx's extended
  position is not the model's 150° soft knee; ExRx's word is lever).
- Pendulum feet: "the machine's arc changes with them" -> "how deep the knees
  bend changes with them" (the arc is fixed by the machine; the stances
  change where along it the bottom falls, 65-87° at the knee).
- Pendulum label "Knees over the toes" -> "Knees track out" (as on the hack):
  from this side-on view the knees sit 9-17 cm behind the toes at the
  bottom in every stance, so "over the toes" read as a forward-knee cue the
  model contradicts. Both knee intros now say "in line with the toes".
- Pendulum tempo: now cites StrengthLog's "lower yourself slowly" (the cue
  had no source); "each rep starts from a standstill" -> "each drive up".

Checked and left: hack and pendulum ghosts show their mistake (heels up,
hips off the pad, knees in, stopping high, snapped knees at the top hold);
the step-down's standing-knee ghost is small (160° -> 180°) but visible as a
straight yellow leg; the hips ghost reads from behind. No pill sits on the
lifter or moving equipment in the trainer stills. The hack knees leader and
the step-down kick leader cross a shin for part of the clip (accepted, as
the author noted). The step-down "Hips square" pill touches the right glute
only in the from-behind fault view.

Open (for the builder, shared code):
- The hack legend (QUADRICEPS · GLUTEUS MAXIMUS PRIMARY, HAMSTRINGS
  SECONDARY) is also drawn over the machine's dark base and is hard to read;
  same fix as the pendulum legend (scrim or offset).
- Review shoot (0, 1.5, 3 s, after the edits): the renamed pendulum pill
  sits clear of the lifter; nothing else moved.
- Ab Wheel Rollout (male model replaced by a female one) is not in this
  family's FAMILIES list and was not reviewed here; its library copy was
  written for the old model and needs its own check.
