# 30-leg set: calf raises 083-087 (2026-09-28)

Five exercises from the drive's "Calf 83-" folder: `spec_legs30_calf.py` holds
the copy, `Tools/fault-review/faults_legs30_calf.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_legs30_calf.json` the moment each ghost is
stilled. The spec header lists the full citations and what each model shows;
this file maps each claim in the copy to them.

## Shared facts about the models

- Same clip timing in all five: two reps in 8 s; heels lowest at 0 s and
  4 s; ~0.9 s up (0.17-1.08 s), ~0.85 s held at the top (1.12-1.96 s), ~1.7 s
  down (2.0-3.71 s), ~0.4 s paused at the bottom (3.75-4.12 s). The tempo
  cue ("about a second up, hold, about two seconds down, pause a moment")
  describes exactly that.
- Ankle angle (shin to foot bone) reads ~98-99° with the foot flat on these
  rigs. Heels highest: 138-148°. The heel rise is ~11 cm in the standing
  models (pelvis 1.11 -> 1.22 m).
- Every model has the ball of the foot on the back edge of its block, step,
  footplate or sled plate with the heel off it (checked against the USD
  bounds: e.g. standing block top from z 0.20, the ball of the foot at
  z ~0.19; seated footplate from z 0.29, ball at ~0.28; sled plate lower
  edge at y 1.37, ball at ~1.33).
- Feet straight ahead (±2°), ankles 0.26-0.27 m apart (about hip width).
- No rig has toe joints; ghosts use `foot_*.tip` (0.38 torso lengths along
  the foot bone), as every other foot fault does.

## Model notes (where the models differ from textbook technique)

- **No stretch below the step.** ExRx (all five pages) says to lower the
  heels "until calves are stretched", and PureGym's leg press guide says to
  lower the heels below the plate. None of the models does: the standing,
  Smith and single-leg models bottom out at ankle 98-99° with the foot
  pitched exactly as when standing flat (heel level with the top of the
  block); the seated model at 103°; the leg press at 108°, about 9-10° short
  of flat. **The model's whole range therefore lies inside Kassiano 2023's
  final range (0 to +25° plantar flexion, 0° = foot at 90° to the tibia),
  the band that grew the gastrocnemius least;** the study's lower range,
  which grew it most, ran from 25° dorsiflexion up to 0°, entirely below a
  flat foot, and none of the models enters it. The copy is written to say
  this plainly: the *why* says the gains came from "training only the
  stretched range below a flat foot"; level is given as "the least to aim
  for" (never called a full rep: Kassiano's FULL ROM ran from 25°
  dorsiflexion to 25° plantar flexion, and level-to-top is its FINAL ROM,
  which grew least), and the copy says "the extra growth in that study came
  from the part below it", so the heels should sink below the step "if your
  ankles are comfortable". The *correct* text asks for level and then, if the
  ankles and Achilles tendons are comfortable, a sink below it into a
  stretch. That advice to go below level is what the study (and ExRx,
  PureGym) supports; the model does not show it. The intro says "at least to
  level" (standing, single-leg), "about level" (seated) and "close to flat"
  (leg press), which is what the model does. The ghost for the bottom cue
  shows the heels held about half-way up, which is clearly worse than the
  model's level heels.
- **Single-leg: dumbbell on the working side.** The model works the LEFT leg,
  holds the dumbbell in the LEFT hand and steadies itself with the RIGHT hand
  on a fixed grip. ExRx only says "Grasp dumbbell in one hand"; the setup
  step says "in the hand on the working side", which is what the model does.
- **Knees 170-172°, not fully straight.** ExRx says to keep the knees
  straight; the models hold a slight, fixed bend, and the copy says
  "straight but soft". On the leg press the 170° bend matches the PureGym
  and NASM guidance (slight bend, do not lock, do not let the knees bend
  excessively).
- **Seated pad and knees.** The thigh pads sit on the lower thighs just above
  the knees (pad underside y 0.76 m over z -0.02..0.21, the knee joint at
  y 0.67, z 0.14), knees 91-96°, shins vertical (knee within 5 cm of over the
  ankle). The copy's "about a right angle, shins upright, pad just above the
  knees" matches. Hip angle opens and closes (97° -> 84°) only because the
  thighs tip up with the pad.
- **Hands.** Standing machine: handles on the carriage in front of the
  shoulders. Seated: handles on the pad. Leg press: handles beside the seat.
  Smith: bar gripped ~12 cm outside the shoulder joints, bar ~7 cm behind the
  neck joint (upper traps). None of the models pulls with the arms.

## Standing Calf Raise

Model: standing calf machine, pads on the shoulders, knees 172°, trunk 0°,
ankle 99° -> 139°.

- Activation Gastrocnemius P HI 0.86, Soleus S MOD 0.66 (ACT_STRAIGHT):
  - Knee straight favours the gastrocnemius: Signorile 2002 (medial
    gastrocnemius > soleus at 180°; soleus lower at 180° than at 90/135°;
    "MG with the leg fully extended"); Price 2003 (knee straight, 25% 1RM:
    gastrocnemius heads active on MRI, no soleus change); Hébert-Losier 2012
    (0° vs 45° knee flexion: gastrocnemius 5% higher, soleus 4% lower
    straight — a small shift). ExRx: target gastrocnemius, synergist soleus.
  - The soleus still works substantially: Gentil 2020 (standing machine calf
    raise, knees fully extended: soleus ~51% of its own peak, like both
    gastrocnemius heads; normalised per muscle, so not a ranking) and
    Kinoshita 2023 (the soleus grew as much after standing as after seated
    training). Hence MOD 0.66, near the top of the band, not LOW. The exact
    fractions are a judgement; the studies give the order, not the numbers.
- KNEES cue: "crosses the knee ... works hardest with the knee straight;
  bending the knee shortens it and its activity falls". The drop in
  gastrocnemius EMG: Cresswell 1995 (gastrocnemius EMG fell with knee
  flexion at the same effort, soleus unchanged; the authors put it down to
  fibres leaving the recording volume and/or impaired neuromuscular
  transmission), Arampatzis 2006 (GM EMG fell at pronounced knee flexion
  "despite of no differences in GM fascicle length"; the authors credit the
  force-length potential of the whole triceps surae, so the drop is not
  explained by fascicle slack alone), Signorile 2002. The shortened-muscle
  explanation is the coaching one: ExRx ("Gastrocnemius are in active
  insufficiency since knees are significantly bent", seated page) and
  StrengthLog (gastrocnemius in a shortened position when the knee is bent).
  The copy therefore says "shortens", which is anatomically true, and not
  "slackens". "Dipping at the knees ... brings the thighs into the lift":
  ExRx ("Quadriceps serve as synergist muscle if knees are bent slightly
  during stretch"). ExRx allows a slight knee bend during the stretch
  ("Keep knees straight throughout exercise or bend knees slightly only
  during stretch"); the fault here is a deeper dip used to bounce the load
  up (the ghost goes from 172° to about 141°), a coaching convention, not an
  ExRx rule. Comparison KNEES DIPPING: same sources.
- TOP cue: "a calf raise has a short range to begin with": the models' ankle
  moves ~40°; Kinoshita 2023 trained 50° (20° dorsiflexion to 30° plantar
  flexion), Kassiano 2023 50°. "Rising as high as you can": ExRx ("as high as
  possible"). Holding at the top: the model holds ~0.85 s. No study isolates
  the top hold; it is described as making each rep reach the top, not as a
  growth claim.
- BOTTOM cue: Kassiano 2023 (8 weeks, young women, horizontal leg press
  calf raise; lower range -25° to 0°, i.e. dorsiflexed up to a flat foot,
  grew the medial gastrocnemius 15.2% vs 6.7% full and 3.4% final range 0°
  to +25°; lateral 14.9% vs 6.2% final, vs 7.3% full not significant) —
  hence "training only the stretched range below a flat foot grew the
  gastrocnemius more than training only the range above it, and at least as
  much as the full range". The study was on a leg press machine, which the
  copy says. "Level with the step is the least to aim for" (the model's
  bottom; not called full, since level-to-top is the study's FINAL ROM, the
  band that grew least); "the extra growth in that study came from the part
  below it, so let the heels sink below the step if your ankles are
  comfortable" is the part the study supports: ExRx (lower until stretched), PureGym (lower
  the heels below the plate). The "if comfortable" hedge is coaching
  caution, not a study finding (see Model notes).
- BODY cue: "Stand erect": ExRx preparation. That pushing the hips back and
  driving them forward can heave the weight up is mechanics and coaching
  convention; no study measured it.
- TEMPO cue (leg press: "press ... let the sled back", same timing): Kawakami 2002 (counter-movement plantar flexion: gastrocnemius
  fascicles nearly isometric while the tendon stored and released elastic
  energy, raising the work). The copy says the fibres "stayed nearly the
  same length while the tendon stored and returned energy", which is the
  finding; "keep the lift on the calf muscles" is the coaching inference.
  Timing is the model's.
- Stabilisers tibialis posterior, peroneals, toe flexors: Akuzawa 2017
  (fine-wire EMG of tibialis posterior, peroneus longus and flexor digitorum
  longus in heel raises); listed, not ranked. Upper back: ExRx stabilisers
  (trapezius, levator scapulae) under the shoulder pads. Core: convention.
- Foot angle is not a cue: Riemann 2011 and Nunes 2020 show toes out and in
  shift work between the gastrocnemius heads, so it is a choice, not a
  fault; setup says toes forward, as the model stands.

## Seated Calf Raise

Model: knees 91-96°, pad on the lower thighs, trunk 0°, ankle 103° -> 148°.

- Activation Soleus P HI 0.86, Gastrocnemius S LOW 0.30 (ACT_SEATED):
  Cresswell 1995 (gastrocnemius EMG down with knee flexion, soleus
  unchanged), Arampatzis 2006 (the same EMG drop; not explained by GM
  fascicle length alone), Price 2003 (knee 90°: only the soleus showed
  on MRI), Signorile 2002 (soleus best targeted at 90°), ExRx (target soleus;
  "Gastrocnemius are in active insufficiency since knees are significantly
  bent"), StrengthLog (mostly the soleus). Kinoshita 2023: seated training
  grew the gastrocnemius only 0.6-1.7%, consistent with LOW.
- **Honesty about the soleus:** Kinoshita 2023 found the soleus grew no more
  after 12 weeks of seated than of standing training (2.9% vs 2.1%, not
  different). The copy therefore says the seated raise leaves "the soleus
  doing most of the work" (activation, well supported) and never claims it
  builds the soleus better than standing raises. Hébert-Losier 2012 also
  found only a 4-5% shift at 45° knee flexion; the seated model's 90° is
  where Price and Signorile found the clear separation.
- KNEES cue: the mistake (feet far out, knees opening) is a set-up error that
  moves the knee toward the angles where the gastrocnemius works more
  (Cresswell 1995, Signorile 2002: soleus lower, medial gastrocnemius higher
  as the knee straightens). Correct text (pad just above the knees, balls of
  the feet under the knees): the model; ExRx ("Position lower thighs under
  lever pads").
- TRUNK cue: coaching convention and mechanics (the pad rests on the lower
  thighs, so leaning back and pulling on the handles can lift it). No study found.
  The model sits still with the hands on the pad handles.
- KNEES cue "it is shortened and adds little": the EMG drop from Cresswell
  1995 and Arampatzis 2006, the shortened-muscle explanation from ExRx
  ("active insufficiency") and StrengthLog, as in the standing KNEES note.
- BOTTOM cue: Kassiano 2023 was straight-knee (horizontal leg press) and
  measured only the medial and lateral gastrocnemius by ultrasound (PubMed
  abstract). No seated or soleus range-of-motion training study was found.
  The copy says so ("In a study of straight-knee calf raises ... That study
  measured only the gastrocnemius, so it does not show the same for the
  soleus") and gives "about level with the platform" as the least to aim
  for (the model bottoms at 103°, a few degrees above flat), with the sink
  below the platform "if comfortable" as the option.
- Stabilisers: foot muscles only (Akuzawa 2017); ExRx lists no significant
  stabilisers.

## Leg Press Calf Raise

Model: 45° sled, trunk reclined 45°, knees 170°, ankle 108° -> 148°, the sled
~11 cm up the rails.

- **No study compared the leg press calf raise with the standing one by
  EMG.** It is a knee-straight calf raise, so it takes ACT_STRAIGHT. Kassiano
  2023 and Nunes 2020 both trained calf raises on a leg press (horizontal,
  pin-loaded) and measured gastrocnemius growth, which supports the
  gastrocnemius row; ExRx Sled 45° Calf Press: target gastrocnemius,
  synergist soleus.
- KNEES cue (sled sinking): NASM ("avoid allowing knees to bend
  excessively"); ExRx (quadriceps join in when the knees bend; ExRx allows
  a slight bend during the stretch, so the fault is the deeper sink used to
  push the sled back with the thighs, a coaching convention); the
  gastrocnemius part as in the standing KNEES cue. Comparison SLED SINKING.
- LOCK cue: PureGym ("Keep a slight bend in your knees throughout the
  movement (don't lock your knees out)"). The copy calls this guide advice
  ("Leg press calf raise guides advise"), with no injury claim; the correct
  text says to keep the bend and not let the knees snap straight. PureGym's
  advice to "adjust the seat so your knees are slightly bent when the plate
  is at rest" is for the seated (horizontal) leg press only; the model is a
  45° sled that rests on its stops with the knees well bent, so that advice
  is not used. The model holds 170°.
- TOP cue has its own why ("Pointing the ankles as far as they go and
  holding briefly"): on the leg press nothing rises, the lifter pushes the
  sled.
- BOTTOM cue: Kassiano 2023 (the study used this kind of machine): "Coming
  back to about a flat foot is the least to aim for; the extra growth in
  that study came from going past flat, so go a little past it if
  comfortable." The intro ("close to flat") and the correct text ("until
  the ankles are at or close to flat, and a little past flat if
  comfortable") match the model, which stops ~9° short of a flat foot; going
  past flat is the advice the study and PureGym support, which the model
  does not show.
- Setup order follows PureGym's 45° instructions: balls of the feet on the
  lower edge of the plate first, then "press the plate off the safety bars
  and extend your legs out, keeping a slight bend in your knees". The feet
  are never moved while the loaded sled is off its stops; if they slip, the
  last step says to re-engage the stops before resetting them (ExRx:
  "Reposition stance if feet slip", which does not mention the stops; the
  stops part is safety convention). NASM: forefeet on the platform, hip
  width. "Release the safety stops": the model's machine has safety stops
  and a release lever; wording is general because machines differ.
- TOP label "Push through the forefeet" (review 2; the earlier "Press
  through the balls" read as an unintended double meaning): the cue pushes
  through the balls of the feet, as the model does (PureGym's own text says
  "toes").

## Single-Leg Calf Raise

Model: left leg works, ball of the foot on the back edge of a 22 cm step,
dumbbell in the left hand, right hand on a fixed balance grip, right knee
bent 136° with the foot behind; ankle 99° -> 139°.

- **No EMG study of the loaded single-leg calf raise against the two-leg
  one was found.** It keeps ACT_STRAIGHT (knee straight). Hébert-Losier 2012
  used single-leg heel raises (bodyweight) for its 0° vs 45° comparison.
- SUPPORT cue: ExRx ("Place hand on support for balance", "Use lighter load
  if you need to assist with hands used for support"). In the model the grip
  sits 25-35 cm below the shoulder (hand_R minus shoulder y -0.25 m at the
  bottom, -0.35 m at the top; the elbow opens 73° -> 99° as the body rises
  away from it), so the arm can only help by pushing down on the handle or
  leaning weight onto it; pulling on a grip below the shoulder draws the
  body down. The copy says "Pushing down on the handle takes part of your
  body weight on the arm" (mechanics), mistake "Leaning on the handle and
  pushing down on it", comparison LEANING ON THE HANDLE / "Arm pushes down
  on the handle".
- Stabilisers gluteus medius, obliques: ExRx (gluteus medius and minimus,
  quadratus lumborum, obliques). Forearms: holding the dumbbell.
- Library difficulty intermediate: one leg carries the body and the
  dumbbell and has to balance; a judgement.

## Smith Machine Calf Raise

Model: Smith bar on the upper traps over the ankles, balls of the feet on a
20-22 cm deck, knees 172°, trunk 0°, ankle 98° -> 138°.

- **No Smith calf raise EMG study found.** ACT_STRAIGHT, as the standing
  machine (ExRx Smith Standing Calf Raise: target gastrocnemius, synergist
  soleus).
- BODY cue (bar's fixed path): mechanics of a vertical track; ExRx ("Stand
  erect").
- Setup: ExRx (bar at upper-chest height, calf block under the bar, back of
  the shoulders under the bar, "Disengage bar by rotating bar back").
- Comparison HEELS STAY HIGH: correct note "uses the whole range above the
  step; sinking a little below it, if comfortable, adds the stretch";
  mistake note "cuts every rep short near the top and never lets the calves
  lengthen". Both are descriptions of range, not growth claims: the earlier
  least-growth claim was dropped because in Kassiano 2023 the flat-to-top
  range the model shows is itself the one that grew least. The value of the
  stretch below the step is carried by the BOTTOM cue (Kassiano 2023).

## Ghosts and when to still them

Checked with a Python port of `FaultGhost.solve` run on the five rigs
(Blender's Python with pxr; scratchpad `legs/calfghost.py`). The strength
for most faults is `calfHeelHeight`, the knee-to-toe-tip distance, which
depends only on the ankle angle: 0.82-0.87 torso lengths at the bottom
(ankle 98-108°), 0.98-1.02 at the top (138-148°).

| Exercise | Cue | Ghost | Moment |
|---|---|---|---|
| Standing | body | hips ~12 cm back, ~3 cm down, trunk ~10° forward, knees ~152° | any |
| Standing | knees | body ~4 cm lower over planted feet, knees 172° -> ~141° | bottom |
| Standing | top | heels 20° lower about the toes (ankle 139° -> ~117°), body ~6 cm down | top |
| Standing | bottom | heels held 22° up (99° -> ~120°), body ~8 cm up | bottom |
| Seated | knees | feet ~12 cm further out, knees 96° -> ~116° | bottom |
| Seated | trunk | `seatedRocked(12)`: trunk 12° back, head ~14 cm back, elbows re-seated | top |
| Seated | top / bottom | heels 20° lower / 22° higher, the knees and pad ~6 cm lower / ~8 cm higher | top / bottom |
| Leg press | knees | feet ~5 cm back along the legs, knees 170° -> ~140° | bottom |
| Leg press | lock | `kneesSnapped` (knee ~6 cm onto and past the line) | top |
| Leg press | top / bottom | toes turned 20° back / 22° forward about the ankle (~8 cm at the toes) | top / bottom |
| Single-leg | support | `pulledOnSupport` (shared piece; the name is FaultPoses.swift's): trunk 12° toward the handle, leaning weight onto it, right elbow re-seated 99° -> 73° | top |
| Single-leg | knee / top / bottom | as standing, left leg only; the right hand stays on the grip, its elbow re-seated | bottom / top / bottom |
| Smith | body / knees / top / bottom | as standing; top and bottom with no fore-aft body shift, so the bar stays on its track | any / bottom / top / bottom |

No "tempo" cue has a ghost (speed, not position), so every exercise has four
ghosts.

Views: standing, seated and single-leg are framed at -1.3 (near side-on from
the front left), so sagittal faults need no turn; the single-leg lean toward
the handle is side to side and turns `faceOn` (total -0.2). Smith is framed at
-0.8: sagittal faults turn -0.5 (total -1.3). The leg press is framed at -2.4,
~47° past a side view from behind: its faults turn 0.4 to -2.0, the view the
leg press family reads its sagittal faults from (at -2.4 a fore-aft move shows
at 68% on screen, at -2.0 at 91%). Screen shots of the ghosts in the app are
still to be taken.

## Labels

Rows on the 0.14-0.86 scale, squeezed to 0.16-0.80 by `spec_legs30.py`
(the first draft's check drew rows unsqueezed; review 1 re-checked them on
the squeezed rows, pill width (24 + 5.6 x chars) / 382). Standing, Seated
and Smith: foot labels share the lowest row, one each side, each leader to
the foot on its own side of the screen so the leaders do not cross
(standing: foot_R u 0.46-0.50 left, foot_L 0.51-0.54 right; seated: foot_R
0.26-0.30, foot_L 0.30-0.35; Smith: foot_R 0.21-0.24, foot_L 0.30-0.33).
Seated: the foot labels left row 0.68, which covered the glowing calves (u
0.25-0.42, v 0.53-0.70); "Knees at 90°" is 12 characters so it ends before
the far knee (u 0.31). The Smith lifter stands on the left of the screen, so
four labels sit on the right over the frame. Leg press: nothing on the left
at 0.33 on screen, which would cover the near calf; "Knees stay put" ends
before the near hand (u 0.34); "Push through the forefeet" (25 characters)
on the top row spans u 0.035-0.465, above the feet (v 0.28-0.30) and clear
of "Heels back down" (from u 0.682). Single-leg:
"Balance only" ends before the balance upright (u ~0.26); the top label sits
at row 0.68 (v 0.64) over the upright, because on the lowest row it covered
the working toes (u 0.27-0.32, v 0.78-0.80).

Cue order: `gen.py` emits cues in annotation order and the 3D view opens on
the first, so "tempo" (no ghost) is listed last in all five.

## Uncertain

- Activation fractions are ranked from the knee-angle studies; no study gives
  gastrocnemius-to-soleus ratios for these exact machines.
- The leg press, Smith and single-leg rows are extrapolated from the standing
  (knee-straight) evidence.
- The trunk (seated), body (standing, Smith) and support (single-leg) cues
  rest on coaching convention and mechanics, not on studies of those faults.
- Kassiano 2023 studied young women on a horizontal leg press for 8 weeks;
  the copy names it as one study.
- ExRx was read through Internet Archive copies (the live site blocks
  automated fetches).

## Change log

- 2026-09-28: first draft of all five (copy, ghosts, moments, notes);
  `spec_legs30.py calf` OK; `check_faults_legs30.py` BUILD SUCCEEDED.

## Change log (review 1)

- BOTTOM cues (standing, single-leg, Smith, seated, leg press): the *why*
  now says the Kassiano 2023 gains came from the stretched range below a
  flat foot, gives level as the minimum and sinking below the step (if
  comfortable) as what adds the stretch; the *correct* text asks for level,
  then a sink below it into a stretch if comfortable; the mistake says reps
  stay "near the top" instead of "in the upper half". Model notes now state
  that every model's range lies inside Kassiano's final (0 to +25°) band.
- Smith comparison notes rewritten as range descriptions; the least-growth
  claim is dropped (the model's correct rep is itself that range).
- TOP why: "The calves lift you" -> "The calves work by pointing the
  ankles", which reads right for the seated pad and the leg press sled.
- Seated trunk why: the pad rests on the lower thighs, not the knees.
- Leg press: setup reordered (feet on the lower edge first, then press the
  sled off the stops; re-engage the stops before resetting slipping feet),
  per PureGym's 45° instructions; lock correct text no longer uses PureGym's
  seated-machine seat advice; top label "Press through the balls"; own tempo
  tuple ("Press ... let the sled back"). Header and notes updated.
- Labels: standing foot joints swapped so the leaders do not cross; seated
  foot labels moved to the lowest row, one each side (top -> foot_R
  leading, bottom -> foot_L trailing), off the calves; single-leg top label
  moved to row 0.68, off the working toes.
- "tempo" moved to the end of the annotations for standing, single-leg and
  Smith, so each exercise opens on a cue with a ghost.
- Ghost and moment files unchanged (cue IDs unchanged). `spec_legs30.py
  calf` OK; `check_faults_legs30.py` BUILD SUCCEEDED.

## Change log (review 2)

All eleven findings checked against the sources (Kassiano 2023 and
Arampatzis 2006 abstracts re-read through PubMed E-utilities; the
single-leg brief for the grip height) and applied:

- BOTTOM why (standing, Smith, single-leg, seated, leg press): the clause
  "keeps the rep full" is gone. In Kassiano 2023 the FULL ROM ran from -25°
  to +25° and level-to-top is the FINAL ROM, which grew least, so calling a
  level-bottom rep "full" misread the study. Level is now "the least to aim
  for", and the copy says the extra growth came from the part below it.
  Findings 1 and 7 cover the same sentence; finding 1's wording was used.
- Seated BOTTOM why: "No such study exists for the seated raise" became
  "That study measured only the gastrocnemius, so it does not show the same
  for the soleus". The notes now say no seated or soleus range-of-motion
  training study was found. Findings 2 and 11 are the same point, handled
  once. The seated minimum is "about level", since the model bottoms at 103°.
- KNEES why and the standing comparison: "slackens" became "shortens", and
  the seated "slack" became "shortened". The notes now cite Cresswell 1995
  and Arampatzis 2006 only for the EMG drop. They add Arampatzis's finding
  of no fascicle-length difference, and credit the shortened-muscle
  explanation to ExRx and StrengthLog. The Arampatzis line in the spec
  header was extended to match.
- The notes now say ExRx allows a slight knee bend during the stretch, and
  that the dip-and-bounce fault is coaching convention (standing KNEES and
  leg press KNEES). No copy change.
- Leg press BOTTOM why: "Coming back to about a flat foot is the least to
  aim for; ... go a little past it if comfortable." Correct: "until the
  ankles are at or close to flat, and a little past flat if comfortable".
  The correct-mode model (108°) no longer contradicts the text (findings 5
  and 10).
- Leg press TOP: the why is now the leg press's own ("Pointing the ankles as
  far as they go ..."), because nothing rises on the sled. The label is now
  "Push through the forefeet" (25 characters, top row u 0.035-0.465).
- Single-leg SUPPORT: the grip sits 25-35 cm below the shoulder, so the
  fault is leaning on and pushing down on the handle, not pulling. The why,
  mistake, correct and comparison (LEANING ON THE HANDLE / "Arm pushes down
  on the handle") are rewritten. The spec header now says the body rises
  away from the grip. The ghost comment in the faults file and the ghost
  table are updated. The ghost itself is unchanged: `pulledOnSupport` is a
  shared FaultPoses piece and already shows the lean.
- Ghost and moment files: only the one comment changed (cue IDs unchanged).
