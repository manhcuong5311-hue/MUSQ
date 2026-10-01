# 351-400 folder, family "hinge": good mornings, Nordics, glute-ham raise (2026-09-30)

Six exercises from the builder's 363-368: Good Morning, Seated Good Morning,
Smith Machine Good Morning, Nordic Hamstring Curl, Assisted Nordic Curl and
Glute-Ham Raise. `spec_400_hinge.py` holds the copy (its header lists the full
citations), `Tools/fault-review/faults_400_hinge.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_400_hinge.json` their still moments. This
file maps each claim in the copy to its source and records what the models
show.

## How the models were read

- Briefs: `SCRATCH/briefs_legs/<Resource>.md` (knee, hip, thigh, shin, trunk,
  equipment every 0.5 s) and `SCRATCH/briefs/<Resource>.md` (arms).
- A finer pass over the USDs with Blender's Python (every 0.125 s): trunk tip,
  knee angle, the app's hip angle (spine-hip-knee, as `FaultPose.neighbours`
  reads it), the neck's distance to the knee in torso lengths, and every cue
  joint projected through the app's camera and each model's framing (the
  `probe.py` projection).
- Stills of the trainer viewport at 0, 1, 2, 3 and 5 s (`SCRATCH/shots/view`),
  with the laid-out pills and leaders drawn over them for every still.
- Tiers: `SCRATCH/tiers27.json`. Builder's notes: DANH_SACH_356_400.md,
  REFERENCES.md, FIX_365_368_20260928.md, SOURCES_365_368_20260928.md and the
  367 `band_diagnostics.json` (band length and strain per frame).

## Model facts the copy relies on

Shared: rig torso (neck to pelvis) 0.59 m; two identical reps in 7.96 s; both
legs work together, symmetric within 1°. The app's hip angle reads ~146°
standing upright and ~122° seated upright in these rigs (the spine joint sits
behind the hip), which is why the good-morning ghosts grow with the neck's
distance to the knee instead of `.withBend("thigh_L")`.

- Good Morning: straight bar high on the upper traps (centre level with the
  neck joint, ~6 cm behind it); hands 0.78 m apart (~20 cm outside each
  shoulder), elbows ~45°, pointing down; ankles 0.28 m apart, toes out ~7°;
  knees 162° all clip (an ~18° bend); trunk 0° to 64° (26° above level);
  hips ~24 cm back; ~1 s down, held 1.67-2.21 s, ~1.1 s up. Framed yaw -2.3
  (from behind the lifter's left).
- Seated Good Morning: straddles the front end of a flat bench (pad 0.40 m
  wide, top 0.54 m, running front to back); ankles 0.60 m apart, ~3 cm in
  front of the knees; knees ~118° (bent ~62°); same bar and grip; pelvis
  fixed; trunk 0° to 55°, the trunk-thigh angle 110° to 57° (~123° of hip
  flexion at the bottom, against ~89° in the standing Good Morning); ~1.3 s
  down, ~0.4 s at the bottom, ~1.5 s up. Framed yaw -2.3.
- Smith Machine Good Morning: Smith bar on the upper traps, hands 0.74 m
  apart (~20 cm outside each shoulder, like the Good Morning's 0.78 m); the
  bar moves only vertically (z 0.01-0.04, drops ~19 cm); ankles 0.28 m
  apart, toes forward, ~18 cm behind the bar's line. The skinned shoes run
  from z -0.23 to 0.08 (middle -0.07; the sole's contact patch averages
  -0.05), so the bar runs over the front of the feet near the balls, ~10 cm
  ahead of mid-foot. The builder's note (middle of the sole ~25 mm behind
  the bar plane) does not match the exported model; the copy follows the
  model. Knees 164° to 150° (16° to 30° bent); trunk 8° to 52°, hip 98° at
  the bottom (GM 91°); hips ~42 cm back; held 1.67-2.17 s. Framed yaw -1.0.
- Nordic Hamstring Curl: kneels on a cushion, ankles under a padded roller
  on posts; hips straight all clip; knees 89° to 164° (body ~15° above the
  floor at the bottom); ~0.9 s down, held 1.62-2.21 s, ~1.1 s back up with no
  hand push; hands loose in front of the lower chest; at the bottom the
  wrists ~18 cm and the palms ~9 cm above the mat (5 cm thick, top at y
  0.05). Framed yaw -1.4.
- Assisted Nordic Curl: the same, plus a closed elastic loop from an anchor
  bar 1.26 m up on a tower ~0.7 m behind the knees, around the front of the
  chest; the contact slides ~8 cm up the chest; strain 0.14 at the top, 1.06
  at the bottom (geometric, not a calibrated force).
- Glute-Ham Raise: GHD, lower thighs over the round pad with the knees just
  behind it, shins on a flat plate, feet against the upright footplate
  (the real toe tip touches it at z -0.49), ankles between two rollers; hips
  straight all clip; knees 89° to 172° (~7° above level); timing as the
  Nordic. This is the knee-only glute-ham raise (hips held straight), the
  version McAllister 2014, Ebben 2009 ("Russian curl" on a glute-ham machine)
  and the ACE study describe, not the one that also hinges at the hips.

## Claims and sources

### Good Morning
- Bar high on the traps, shoulder blades squeezed, the lab studies' spot:
  Vigotsky 2015 (upper trapezius, slightly above the acromion), McAllister
  2014 (superior aspect of the trapezius), Ebben 2009 (base of the neck,
  scapulae retracted). "Shelf of muscle", "pull the bar into the back":
  coaching mechanics, not a cited result.
- Lower-back muscles ~70% of their own maximum at heavy loads: Vigotsky
  2015, 90% 1RM: lumbar 70.9, thoracic 66.6 %MVIC (73.1 lumbar at 80%). The
  copy does not compare this with the hamstrings (39.9 medial, 30.4
  lateral): the MVIC tests differed by muscle (prone knee flexion at 45°; a
  prone superman the authors say may not be a true MVIC position for
  everyone), noted in the header and the activation comment.
- Hamstrings stretch further than in a sprint: Vigotsky 2015 ("the stretch in
  the GM is greater than the maximum stretch observed during a sprint";
  modelled lengths).
- A slight, fixed bend keeps the knees from locking back; good mornings with
  the knees almost straight pushed the knees toward straightening:
  Schellenberg 2013 (maximal knee flexion 5.3°, an external extension moment
  at the knee during GMs). Knee bend 17° to 25° from half to 90% of max,
  shorter hamstrings: Vigotsky 2015 (17.1° at 50%, 24.8° at 90%; estimated
  hamstring length decreased with load); the copy no longer says the lift
  turns toward a squat (the mistake text describes that fault, not a
  finding). The model's fixed 18° sits at the light end; Ebben 2009 kept
  ~15°.
- Hips over the heels, chest out over the toes, less hamstring stretch:
  mechanics (the hip stays more open when the hips do not travel back).
- Studied good mornings went to about level: McAllister 2014 (torso parallel,
  ~90° hip flexion), Ebben 2009 (torso parallel), Vigotsky 2015 (approximately
  parallel). "Load on the hips greatest at the bottom": mechanics (the bar's
  horizontal distance from the hips grows with the lean).
- Activation (erectors 0.80, hamstrings 0.76, gluteus maximus 0.48): the
  erectors first is a house choice (both primaries are painted bright;
  Vigotsky's percentages cannot rank the two, see above); McAllister 2014
  (hamstring activity highest in the RDL and glute-ham raise; the good
  morning's concentric erector activity equal to the RDL's, 216.6 vs 217.0
  µV) and Ebben 2009 (GM 43 vs SLDL 49 %MVIC, not different) keep the
  hamstrings below the app's RDL and stiff-leg 0.88. Jaeggi 2024 (modelled
  gluteal forces highest in the good morning and the split squat's front
  leg; 8 women, 25% BW) and Schellenberg 2013 (a larger hip moment than a
  deadlift at the same bar load) support a real glute share; McAllister 2014
  (gluteus medius lowest in the good morning of four lifts: concentric 43.1
  µV vs 194.1 prone leg curl and 220.7 glute-ham raise, both significantly
  higher; the RDL also higher) keeps it a MODERATE secondary, not higher. No
  gluteus maximus EMG of the good morning was found.

### Seated Good Morning
- Straddling the bench, feet flat in front of the knees, back set in extension
  and braced, bend as far as possible without losing the extension; mainly
  for the back's isometric arch, secondarily glutes and hamstrings: Catalyst
  Athletics (Greg Everett), paraphrased; the copy says weightlifting coaches
  use it this way rather than stating the purpose as fact.
- With the knees bent, the hamstrings help less with straightening the hip
  and the glutes' share grows: Liu 2022 (maximal isometric hip extension,
  hip at 0° or 45°: the hamstrings' torque share highest with the knee
  straight, the gluteus maximus/hamstring ratio highest at hip 0°, knee 90°)
  and Kwon & Lee 2013 (prone, hip at 0°: BF/ST activity fell past ~60° of
  knee flexion, the gluteus maximus then above both); stated as isometric
  hip-extension tests. The copy no longer says the hamstrings are slack or
  that hip-extension torque falls: the model folds the hip to ~123° of
  flexion at the bottom (vs ~89° standing), which lengthens the hamstrings
  at the hip by roughly what the bent knee takes up, and Németh 1983 found
  knee angle did not change isometric hip-extensor strength at 0-90° of hip
  flexion. No test used ~120° of hip flexion.
- Ankles ~60 cm apart, a little in front of the knees; ~55° lean: model.
- Activation (erectors 0.80 HIGH, hamstrings 0.62 MODERATE, glute 0.50
  secondary): Catalyst (back first) and the house order of the standing lift;
  Liu 2022 and Kwon & Lee 2013 (the hamstrings' share lower with the knee
  bent), with Németh 1983 and the hip angle above, so 0.62 is an estimate;
  the library row's POSTERIOR CHAIN (part_of: lower back) agrees with the
  erectors leading. No study of this lift was found.
- Comparison (leaning from the upper back vs folding at the hips): the same
  fault as the hinge cue and its ghost, so it no longer repeats the Good
  Morning's back-rounding card.

### Smith Machine Good Morning
- The rails fix the bar's path; the feet set the lift; hips must travel back
  behind a bar that cannot move forward: mechanics of the fixed track. The
  hips ~40 cm back vs the bar ~20 cm down, knees 16° to 30°: model.
- Feet set back under the bar, the bar over the balls of the feet, the
  ankles well behind it; hands well outside the shoulders: model (see the
  model facts; the grip matches the Good Morning's).
- Erectors ~70% in free-bar good mornings; more knee bend, shorter hamstrings:
  Vigotsky 2015.
- Activation (erectors 0.76, hamstrings 0.72, glute 0.48): as the free-bar
  lift, both primaries a step lower from the model (trunk 52° vs 64° and hip
  98° vs 91° at the bottom: a shorter lever about the hips and back, less
  hamstring stretch). Schwanbeck 2009 (squats, n = 6 at 8RM: biceps femoris
  about a fifth lower with the Smith bar, 26% higher with the free bar;
  lumbar erectors not different) is context, not the basis of the step. No
  Smith good-morning study was found. The builder's reference is a video
  demonstration only.
- Mistakes (simulator QA 2026-10-01): the bar-low mistake says the hands hold
  the bar and the chest tips further forward, as its ghost draws (the hips
  go only ~2 cm back so the bar stays on its line; the old text also said
  the hips went further back). The feet mistake is cut to three lines so the
  sheet no longer hides the Feet under bar pill in its own fault view.

### Nordic Hamstring Curl
- Straight line knees-hips-shoulders: E3 Rehab; the lab versions held the
  hips straight: Ebben 2009 (hips extended, maintained throughout), McAllister
  2014 (hip 0° in the glute-ham raise), Šarabon 2019 (standard NHE, 0° hip
  flexion). Lifters told to bend further at the hips also tipped the pelvis
  and rounded the lower back: Šarabon 2019 (told to hold 50° or 75°, they
  performed a combination of hip flexion, pelvic rotation and spine
  flexion; the limitations add that they often flexed the lumbar spine
  instead of the hip). Šarabon also found the hip-flexed instructions gave
  higher peak knee and hip torque, so the copy does not claim that bending
  at the hips unloads the knees; the comparison says only that it is no
  longer the version tested and trained in the studies. A slight hip bend
  as a way to start, working toward the straight line: E3 Rehab (letting
  the hips bend is perfectly acceptable as a regression).
- Faster falls, lower hamstring activity; a sharp speed-up: Ditroilo 2013 (r =
  -0.62 between peak knee angular velocity and peak EMG; sharp velocity
  increase at 47.9-80.5°). Hamstring activation stays >70% between 60° and
  40° of knee flexion and drops to 27% at the end: Monajati 2017 (not quoted
  in the copy; supports "the drop").
- Programmes that include the Nordic about halved hamstring injuries: van
  Dyk 2019 (programmes including the NHE, several multi-part; risk ratio
  0.49; 0.52 in the RCTs); Petersen 2011 (3.8 vs 13.1 per 100 player
  seasons) and van der Horst 2015 (0.25 vs 0.8 per 1000 h) are the largest
  trials.
- Six weeks of Nordics: longer control of the fall and more eccentric
  strength: Delahunt 2016 (control 68.1° vs 73.7°, strength 202.4 vs 177.4
  N·m). Mjølsnes 2004 (+11% eccentric torque in 10 weeks), Bourne 2017 BJSM
  51:469 (longer BFlh fascicles) and Cuthbert 2020 (low volumes work as well)
  back the programme framing; not quoted.
- Shorten the range with a stack in front; catch with the hands and push back
  up if you cannot curl up: E3 Rehab.
- Fixing the heels alone made no difference against a partner; a set-up that
  also fixed the kneeling height and knee position gave a straighter
  controlled knee and more EMG: Bergmann 2026 (break-point angle 56.0° with
  the device vs 74.8° partner and 74.3° rigid heel fixation alone; the
  authors recommend consistent set-up conditions, hence set up the same way
  each time).
- Activation (hamstrings 0.95, gastrocnemius 0.40 MODERATE, gluteus maximus
  0.34 LOW): Šarabon 2019 (standard NHE peak ST 106.7, BF 99.7 %MVC; gluteus
  maximus relatively low in every variation; erector spinae ~65%) and
  Ditroilo 2013 (BF 134% of a maximal eccentric contraction) for 0.95.
  Ebben 2009's 98 %MVIC Russian curl was done on a glute-ham machine (the
  knee-only glute-ham raise, a plate at the chest), so it backs the
  Glute-Ham Raise row, not this one; the floor Nordic sits above the
  glute-ham raise on the ACE study (floor version ST above the prone leg
  curl, machine version not). Murakami 2023 (eccentric phase BF 52.8, ST
  49.2, medial gastrocnemius 28.7 ± 9.0, lateral 22.8, gluteus maximus 30.8
  ± 41.6 %MVIC) has the calf and glute level, so the gap between the two
  secondaries is small (0.40 vs 0.34) and the order rests on Šarabon's low
  glute and the gastrocnemius crossing the knee. Narouei 2018 (ST and BF
  most active; back extensors and internal oblique above other trunk and
  hip muscles: the stabilisers). Bourne 2017 BJSM 51:1021: the Nordic
  preferentially recruits the semitendinosus (the Hamstrings row covers all
  three).

### Assisted Nordic Curl
- Band around the chest anchored above and behind: E3 Rehab; model (anchor
  1.26 m up, ~0.7 m behind the knees). The band pulls the chest up and back,
  taking part of the load off the hamstrings: mechanics (it lowers the
  moment the hamstrings resist about the knee; the knees still carry the
  body).
- The band stretches far more at the bottom: builder's band_diagnostics (strain
  0.14 at the top, 1.06 at the bottom); that tension grows with stretch is
  the ordinary behaviour of an elastic band, not a measured force.
- Heavy-to-light bands built as much Nordic strength (~20% in 8 weeks) with
  less soreness and effort: Ishøi 2025 (under-14/15 elite youth players).
- Faster falls, lower hamstring activity: Ditroilo 2013 (as the Nordic).
  Demeusoy 2026 (one all-out repetition: assisted versions reached more
  torque and higher EMG integrals for BF, ST and both gastrocnemius heads,
  put down to greater muscle length at the end and longer time under
  tension) is no longer in the copy: next to a Hamstrings row under the
  Nordic's it read as a contradiction, and integrals grow with duration.
- Activation (hamstrings 0.85, gastrocnemius 0.32 LOW, gluteus maximus 0.22
  LOW): a house estimate below the unassisted 0.95 for the band's share of
  the load in the submaximal assisted rep the model shows; Demeusoy's
  all-out data are noted in the spec comment. The calves and glutes are
  painted only faintly (0.11).

### Glute-Ham Raise
- Knees just behind the pad, feet on the footplate, ankles between the
  rollers, upright to parallel: ACE (Schmitt, Porcari et al. 2018,
  ACE-sponsored, not peer-reviewed); one study put the knees 4 cm behind the
  pad's apex, lowered until nearly parallel, hips extended: Ebben 2009 (the
  4 cm is Ebben's alone, so the copy says one study).
- Gastrocnemius almost twice as active on the way up as in a lying leg curl,
  in a loaded glute-ham raise: McAllister 2014 (concentric medial
  gastrocnemius 260.7 vs 139.7 µV, prone leg curl; the glute-ham raise done
  with a plate held at the xiphoid at 85% of a ~88 kg 1RM, so the copy says
  a loaded version). Crosses the knee and helps bend it: anatomy.
- More hamstring activity on the way up than a lying leg curl, more erector
  activity than the good morning or RDL, in one study of a loaded version:
  McAllister 2014 (concentric BF 387.7 vs 254.1, ST/SM 1197.2 vs 890.0 µV;
  erectors 432.0 vs 216.6 and 217.0). The ACE study found the machine
  version's BF below the prone leg curl, so the copy keeps the claim to that
  one study.
- Hardest near level; a controlled lowering: mechanics; Ditroilo 2013 for
  "faster falls, lower hamstring activity" (a Nordic study, so the copy says
  "in Nordic-style lowering").
- Activation (hamstrings 0.93, gastrocnemius 0.50 MODERATE, gluteus maximus
  0.30 LOW): McAllister 2014 (above the prone leg curl, loaded) and Ebben
  2009 (the Russian curl on a glute-ham machine, 98 %MVIC, significantly
  above the seated leg curl's 81) put it above the app's Seated Leg Curl
  (0.92); the ACE study, the only direct floor-vs-machine comparison (floor
  version ST above the prone leg curl, machine version not; BF lower in
  both), puts it a step under the floor Nordic's 0.95. McAllister measured
  only the gluteus medius here (concentric 220.7 µV, level with the prone
  leg curl's 194.1); no gluteus maximus EMG of this lift was found (the
  glutes hold the hips straight, as in the Nordic).

## Labels

Rows are the spec_400 squeeze (input 0.14-0.86 to 0.16-0.80); every pill was
drawn over the five stills of each model (pill 29 pt tall, width by
`gen.width`), and the leaders were checked every 0.125 s against each other and
against an approximate skull circle (19 pt round the head joint pushed 0.9 of
the neck-to-head step further). Results:

- Good Morning: bar (0.16 L, to the near hand, whose leader passes left of the
  head all rep, ~9 px clear at the bottom), back (0.16 R, short so the leader
  passes right of the head), depth (0.64 L, ends 0.36, left of the calf, to the
  chest), knee and hips on 0.80 under the feet. No pill over the lifter or the
  plates (plates sweep v 0.22-0.46 at both edges; rows 0.32 and 0.48 unused).
- Seated Good Morning: range (0.16 L, to the head: the only joint a top-left
  leader reaches without crossing the head), bar (0.16 R, to the far hand,
  right of the head), back (0.56 L, ends 0.30, left of the left knee), feet and
  hinge on 0.80 (the hinge leader runs up through the bench).
- Smith Machine Good Morning: every top-left leader would cross the head, the
  plates block both upper corners and the frame's uprights cover both edges,
  so the labels are short and low: back 0.465 L (ends 0.23; the body's edge at
  0.29; above the rack's orange pin at v 0.49), hips 0.64 L, knee 0.80 L (ends
  0.32, left of the near shoe), bar 0.64 R (starts 0.79, the far leg's back at
  0.73, leader up to the far hand on the bar), feet 0.80 R (starts 0.70, the
  near shoe ends at 0.66). Pills overlap only the static uprights.
- Nordic / Assisted Nordic: the head sweeps from top centre to lower left, and
  every trunk joint sits below-right of it early in the descent, so only the
  head is reachable from the top left; anchor 0.16 R (13 characters, its leader
  passing right of the head; on the Assisted it clears the tower's top bar by
  ~0.01); hands 0.64 L (ends 0.26, clear of the head at the bottom, which ends
  at v 0.60); the bottom row below the base carries the hips, knee (Nordic) and
  chest (Assisted, the band label). The band crosses the anchor leader, no
  pill.
- Glute-Ham Raise: range 0.16 L to the head, lower 0.16 R (short, its leader
  right of the head to the chest), feet 0.32 R (starts 0.67, the upright
  body's back at 0.63), line 0.64 L (ends 0.39, left of the pad's base plate
  and stand), pad 0.80 R below the base rails.

## Ghosts

Checked offline with a Python copy of `FaultGhost.solve` (body frame, shifts,
turns, straighten and resolve as in the app) every 0.25 s through the first
rep (0.125 s for the Nordic heads), drawn as stick figures with each fault's
view and over the stills for the side-on models (`SCRATCH/rv2/final.py`,
`final_<slug>.png`). Revised 2026-10-01 after the ghost review:

- Good mornings: the lean strengths (`hingeGMLean` etc.) read 0 at the top,
  ~0.26 at 1 s and 1 at the bottom. Bar low (hands ~7.3 cm down the back,
  ~12 px side-on; drawn as the arms and bar only since the simulator QA,
  as the unmoved spine drawn over the back buried the shift),
  rounding (~7 cm), knees bending (~5 cm lower, knees ~40°) read side-on.
  Hips over the heels: the pelvis, thighs and trunk ~24 cm forward and ~4 cm
  up, so the pelvis ends over the ankles (z 0.077 vs 0.080), the torso keeps
  its length and tip and folds out over the toes, the knees stay 162-165°
  and the hip ~26° more open (the first version moved only the pelvis and
  thighs: the torso shrank 17%, the hips stayed 12 cm behind the ankles and
  the knees bent to 146°, like the knee ghost). Stopping short: 48° standing
  (the trunk ~15-19° from mid-descent on) and 40° seated (~8-15°), a nod as
  the mistakes say, never past upright (was 30° / 25°: 34° / 30° left).
  Seated feet (~18 cm in each) read from behind (-0.5); the legs stretch up
  to ~4%.
- Seated hinge: its own piece (`hingeSeatedUpperBackCurl`), the trunk 15°
  back toward upright about the pelvis while the chest caves and the neck and
  head curl forward: at the bottom the lower trunk sits 30° instead of 45°
  forward and the chest ~8 cm higher, the head near the real one (was
  `headDropped`, which kept the full hip fold and matched the back ghost
  within 1°). The back ghost (`backRounded`) drops the whole trunk instead.
- Smith (side-on at -0.4): bar low on the track now takes the hips back 0.03
  torso lengths instead of 0.13, which keeps the bar within ~1.3 cm of its
  fixed line through the rep (it ended 6 cm behind it), ~10 cm lower on the
  rails. Squatting: trunk 15° up, hips 0.25 down and 0.22 forward: the bar
  stays within ~1 cm of its line and slides ~6 cm lower, the knees ~99°, the
  hips ~15 cm lower (the first version took the bar 15 cm off the rails).
  Feet 0.35 forward (ankles ~2 cm in front of the bar's line, toes ~26 cm),
  read at the top: from mid-descent the planted ankles are out of reach and
  the legs lock and stretch (~6% at the bottom). Back: `headDropped` (upper
  back, chest caving, head dropping, as the mistake says) instead of
  `backRounded`. Knees locked: straightened.
- Nordics and the glute-ham raise: `whenStraight("shin_L")`, 0 at the top,
  0.40 at 1 s, 0.82 (Nordic) / 0.91 (GHR) at the bottom. Hips bent: the
  thighs, hips and trunk turn 20° back toward upright about the knees, then
  the trunk folds 45° about the hips: at the Nordic's bottom the knees ~147°
  instead of 164°, the hips ~12 cm higher and ~5 cm back, the chest at the
  real height, the head ~13 cm lower (y 0.40); GHR knees ~153° instead of
  172° (the first version only folded the trunk down about a fixed pelvis:
  no backside pushing back, the head 19-27 cm lower, reading as a drop).
  Arms left out (carried, the hands reached 2 cm off the floor). Dropped
  (~10° lower, the head joint still 33 cm up), heels up (ankles +14 cm),
  propped hands (the palms onto the mat top, y 0.05; the real palms ~9 cm
  above it). Stopped short: Nordic 50° (the body ~34° forward at the bottom
  instead of 75°), GHR 45° (~42° instead of 83°, halfway), the Assisted
  band 60° (~26°, hanging in the band near upright); none passes upright at
  any sample. GHR knees on the pad (~9 cm forward down to the ankles; the toe
  tips are left out so they do not hang off the real footplate) and loose
  feet (the toe tip ~10 cm off the plate, toward the shin) at the top.
- No ghost: the GHR's "lower" (speed).
- Moments: all at the bottom except the GHR pad and feet and the Smith feet
  (top).

## Uncertain / to check on the simulator

- The Good Morning's bar leader passes ~9 px left of the head at the bottom;
  the Assisted Nordic's anchor pill clears the tower's top bar by ~0.01.
- The Smith labels are terse ("High bar", "Flat back") to fit the frame; the
  cue titles and sheets carry the detail.
- The Smith feet: the builder's note says mid-sole ~25 mm behind the bar
  plane, but the exported model's shoes put the bar over the front of the
  feet (~10 cm ahead of mid-foot); the copy follows the model.
- The Smith feet ghost stretches the legs from mid-descent (read at the top).
- Simulator QA (2026-10-01): in the Smith feet fault view (the top of the
  rep, the model lifted clear of the sheet) the near plate's top touches the
  viewport's top edge and the COMMON MISTAKE chip sits over the plate and the
  top of the head; turning the view does not move them (framing, not the
  ghost). In the trainer view the near plate runs off the right edge under
  the muscle and eye buttons at every moment (framing in the model map).
- The Nordics' heels-up ghost lifts the ankles through the fixed roller: the
  model's anchor cannot move, so a loose anchor can only be drawn that way.
- No EMG study was found for the seated or Smith good morning, a submaximal
  band-assisted Nordic or the gluteus maximus in the good morning or the
  glute-ham raise; those rows are estimates from the closest studied lifts.
- ExRx and StrengthLog were not used.
