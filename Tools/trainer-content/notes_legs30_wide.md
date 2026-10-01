# 30-leg set: wide stances (2026-09-28)

Five exercises from the HIKSEMI "300-350/27_9" folder: Lateral Lunge, Cossack
Squat, Dumbbell Sumo Squat, Barbell Sumo Squat and Kettlebell Goblet Squat.
`spec_legs30_wide.py` holds the copy (its header lists the full citations and
what each model shows), `Tools/fault-review/faults_legs30_wide.swift.txt` the
ghosts, `Tools/fault-review/fault_moments_legs30_wide.json` when to still them.
This file maps each claim in the copy to its source and records where the
models differ from textbook technique.

## Shared facts about the models

- Read from `briefs_legs30/<Slug>.md` (angles every 0.5 s), `joints.json` and
  the app stills. Rig: shoulder joints 0.39 m apart, torso 0.59 m, thigh
  0.44 m, shin 0.40 m. Every clip is two reps in 8 s.
- Lateral Lunge and Cossack Squat shift from side to side: rep 1 works the
  LEFT leg (the lifter's left is screen right at yaw -0.3), rep 2 the RIGHT.
  Their one-leg cues use `patella_bent`, `foot_bent`, `patella_straight`
  (probe.py's SIDE_SHIFT points; the app picks the more bent knee every
  frame, `BodyFrame.bentSide`). That rule misfires on the Lateral Lunge mid
  rep (see Model notes and Uncertain).
- The sumo squats and the goblet squat go down in ~0.9 s, pause ~0.75 s at
  the bottom, rise in ~0.9 s and stand ~1.25 s; bottoms at ~1.7-2.2 s and
  ~5.7-6.2 s.

## Lateral Lunge

Model: bodyweight, hands clasped at the chest; feet 0.32 m apart and pointing
straight ahead; rep 1 the left foot steps out 0.42 m (ankles 0.74 m apart) and
the hips go 0.54 m to that side, 0.29 m back and 0.33 m down. Bottom: stepping
knee 87°, hip 49°, thigh 17° above parallel, shin 19° forward, kneecap 13 cm
ahead of the ankle and straight over the foot side to side; the other leg
straight (171°), its foot flat; trunk 58° forward.

Claims and sources:
- Quadriceps primary (HI 0.76): ExRx Dumbbell Alternating Side Lunge and
  Barbell Side Lunge (target quadriceps). Riemann 2013 (young adults: the
  lateral lunge prompted greater ankle and knee extensor contributions, the
  forward lunge greater hip extensor demand) and Flanagan 2004 (older adults:
  lateral lunge targeted the plantar flexors, forward lunge the hip
  extensors; knee differences less consistent) put the lateral lunge on the
  knee and ankle more than the forward lunge.
- Gluteus maximus MOD 0.52: DiStefano 2009 lateral lunge 41 +/- 20% MVIC
  (bodyweight; value read from the table in Macadam 2015, the abstract
  reports only the lunges together), and this model's deep hinge (hip 49°,
  trunk 58°), with Farrokhi 2008 finding more gluteus maximus and biceps
  femoris EMG with the trunk forward in the lunge. Kept below the
  quadriceps because of Riemann 2013 / Flanagan 2004.
- Adductors MOD 0.42: Delmore 2014 ranked side lunges third of six hip
  adductor exercises for adductor longus activity (behind side-lying
  adduction and ball squeezes, ahead of Swiss-ball adduction, rotational
  squats and sumo squats); ExRx lists the adductor magnus of the lead leg and
  the adductors of the extended leg as synergists. Delmore's abstract gives
  no %MVIC, so the fraction is a rank, not a measured level. Delmore's
  ranking is descriptive: side lunges, standing Swiss-ball adduction,
  rotational squats and sumo squats did not differ significantly in peak
  adductor longus EMG (P > .08); only side-lying adduction (over all) and
  ball squeezes (over rotational squats, sumo squats and Swiss-ball
  adduction; average activation over side lunges, P = .001) stood out. So
  0.42 here vs 0.44 in the sumo squats is not a measured gap.
- Gluteus medius MOD 0.46 (was LOW 0.36): DiStefano 2009 measured it close
  to the gluteus maximus (39 +/- 19% vs 41 +/- 20% MVIC), and Bouillon 2012
  near equal too (13% vs 12%), so it sits just below the gluteus maximus row;
  the small gap is a judgement for the model's hip hinge (Farrokhi 2008 did
  not measure the gluteus medius). ExRx lists it as a stabiliser. Bouillon 2012 (via Macadam 2015) measured much lower gluteal
  values in a side-step lunge (12-13% MVIC, different normalisation), so the
  glute rows are kept modest.
- Stabilisers erector spinae, hamstrings, calves, core: ExRx Dumbbell
  Alternating Side Lunge (Internet Archive copy: dynamic stabilisers
  hamstrings and gastrocnemius; stabilisers erector spinae listed first,
  then trapezius, levator scapulae, tibialis anterior, gluteus medius and
  minimus, quadratus lumborum, obliques); the model hinges 58°, so the
  lower back holds the trunk.
- Hips cue: "pushing the hips back brings the hip extensors in" — ACE Side
  Lunge (push the hips backward while shifting the weight) and Farrokhi 2008;
  "studies comparing lunges found the lateral lunge leans more on the ankle
  of the stepping leg than a forward lunge does" — Riemann 2013 and
  Flanagan 2004 (plantar flexors); "and one found more on the knee as well"
  — Riemann 2013 only (Flanagan 2004: knee differences less consistent).
  The mistake (the hips kept forward and the chest upright, the knee
  driving forward over the toes) is coaching convention; the ghost draws
  that (hips
  ~9 cm forward, trunk 58° -> 33°, kneecap 21 cm ahead of the ankle instead
  of 13 cm). With its foot fixed, the straight leg in that ghost also folds
  from 171° to ~149°; it is kept in the ghost so the hips stay joined to
  it. The mistake no longer says "the hips over the middle of the stance":
  the model itself passes through a centred half squat at 1.0 s (Model
  notes), and the ghost moves the hips forward, not to the midline.
- Torso cue: the lean is allowed while the back is flat (ACE: brace, bend at
  the hips, push the hips back; Myer 2014: excessive trunk flexion or
  rounding is a deficit); "in forward lunges a forward lean added glute and
  hamstring work": Farrokhi 2008 (forward lunge only, worded so). See the model notes on how far this model leans.
- Knee cue: ACE (knee aligned over the second toe to avoid inward collapse),
  ExRx (the lead knee points the same way as the foot); "often shows the hip
  losing control": Powers 2010 (a review; hip, pelvis and trunk control can
  affect the knee, not the only cause).
- Heel cue: ACE (weight over the heels, both heels flat), ExRx (land on the
  heel, then the forefoot), Myer 2014 (heels lifting reduce the base of
  support and bring compensations).
- Straight-leg cue: ACE (the non-working leg near or at full extension);
  ExRx (adductors of the extended leg as synergists, "flexible hip adductors
  allow a fuller range"). "Bending both knees turns the rep into a lopsided
  squat" is a description of the movement, not a study claim. The intro
  says the leg "ends long" and the correct cue straightens it "as your hips
  move over the bent leg; at the bottom it is straight", because the model
  keeps that knee bent (135°) through the centred half squat and straightens
  it (171°) only at the bottom, 1.75-2.38 s.
- Comparison HIPS NOT SITTING BACK: as the hips cue.
- Setup: feet about hip-width (model 0.32 m ankle to ankle, slightly wider),
  hands clasped, weight in the heels (ACE); the last step says both feet
  point ahead and that each rep steps one foot out and back (model: 0°
  toe-out, the step out 0.46-1.71 s and 2.42-3.62 s), so the setup does not
  put the lifter in the wide stance before the first rep.
- Knee comfort: Escamilla 2008 and 2022 found patellofemoral force and
  stress higher in the side lunge than the forward lunge (80-90° knee angles
  with load; 40-100° bodyweight). Escamilla reports knee flexion (0° =
  straight); the model's 87° inner angle is ~93° of flexion, just past the
  80-90° band. The 2008 authors advise 0-50° over 60-90° to limit
  patellofemoral stress (their interpretation; the abstract's findings
  sentence is worded the other way round). Not in the copy; it is why the
  copy asks for the hips back rather than more knee bend, and why no depth
  target beyond the model's is set.

## Cossack Squat

Model: bodyweight, hands clasped at the chest; ankles 1.0 m apart, toes out
20°. Bottom: bent knee 46°, hip 71°, thigh 5° past parallel, shin 36° forward,
the kneecap 21 cm ahead of and 16 cm outside the ankle, heel down; the other
leg straight (171°) with its foot turned up on the heel, toes up; trunk 16°.
Hips drop 0.47 m. Holds the bottom ~0.9 s.

- **No EMG study of the Cossack squat was found** (EuropePMC and PubMed
  searches for "Cossack squat" returned no biomechanics papers). Rows are
  ranked from the closest lifts: ExRx Barbell Side Split Squat (a side-to-side
  squat with the other leg only slightly bent: target quadriceps; synergists
  gluteus maximus, adductor magnus of the lead leg, adductors of the
  extended leg; a wider stance emphasises the gluteus maximus) and the
  lateral lunge rows above. Quadriceps 0.78 HI, gluteus maximus 0.56 and
  adductors 0.48 MOD, a little above the lateral lunge for the depth
  (thigh past parallel: Kubo 2019, full squats grew the glutes and
  adductors more; the adductor magnus as a hip extensor deep in hip
  flexion: Neumann 2010, Benn 2018). The EMG evidence on glute work and
  depth conflicts: Caterisano 2002 (n = 10; gluteus maximus share of four
  muscles' summed EMG rose with depth) against Contreras 2016 (no
  difference in upper or lower gluteus maximus EMG between parallel, full
  and front squats), so the step above the lateral lunge is kept small.
  Gluteus medius MOD 0.46, as the lateral lunge (no depth data for it).
- Depth cue: "the working knee bends further than in most squats": the
  model's bent knee reaches 46°. The hip is not claimed: it reaches only
  71° inner (~109° of flexion), about the sumo squats' 78-81°. "Training
  through a full squat built more glute and adductor muscle than half
  squats": Kubo 2019 (bilateral squats). No EMG depth claim (Caterisano 2002
  vs Contreras 2016). "Build the depth up over weeks; it takes flexible inner
  thighs": ExRx ("flexible hip adductors will allow fuller range of
  motion"); the time frame is coaching convention. The mistake says
  "stopping short of parallel, the hips staying above the bent knee", which
  is what the ghost draws: about three quarters of the way down, the thigh
  about 10 degrees above parallel (hip joint ~7-8 cm above the knee instead
  of 4 cm below it). It said "halfway down ... well above" until review 2.
- Heel cue: the ankle demand is the model's (shin 36° forward at knee 46°);
  "limiting ankle bend made the knees drift inward and the quadriceps work
  less": Macrum 2012 (double-leg squat with a 12° forefoot wedge). StrengthLog
  (keep the bent leg's foot flat, push through the heel).
- Knee cue: ExRx (lead knee the same way as the foot), Powers 2010. The model's
  knee sits a little outside the toe line (a 37° line against the 20°
  toe-out), never inside it.
- Torso cue: ExRx (keep the torso upright), Myer 2014 (trunk as upright as
  possible). The "hands clasped" detail is the model's.
- Straight-leg cue: StrengthLog ("point the toes of the extended leg
  upward"), ExRx (extended-leg adductors). "The usual way to give the leg
  room to turn as you sink" is coaching convention, worded as such; no
  study compared a flat and a toes-up straight foot. The mistake now reads
  "the weight settling between the feet" (was "so the hips stay between the
  feet"): the ghost moves only the straight foot and knee, the hips stay
  over the bent leg.
- Comparison HEEL LIFTING: Macrum 2012, Myer 2014.
- Library: bodyweight, intermediate (the depth and adductor flexibility).

## Dumbbell Sumo Squat

Model: ankles 0.78 m apart, toes out 35°; one dumbbell held upright by both
hands at arm's length between the legs. Bottom: knees 72°, hips 81°, thighs
parallel, shins 17° forward, kneecaps 11 cm ahead of and 8 cm outside the
ankles (a 36° line, the toes' 35°), heels down; trunk 4° -> 18°.

- **No EMG study of a dumbbell (or barbell) "sumo squat" as such was found.**
  Ranked from wide-stance back squat studies:
  - Quadriceps primary HI 0.85 (was 0.80): ExRx Smith Wide Squat (target
    quadriceps); McCaw 1999 (stance width did not change the quadriceps,
    only the load did); Lee 2026 (wide stance raised vastus medialis
    activity, pointing the quadriceps up, not down); Escamilla 2001 (knee
    extensor moments 447-756 N.m in the medium and wide stances against
    359-573 N.m narrow; "knee and hip moments were greater" wide; abstract
    checked on Europe PMC). Sinclair 2022's modelled forces (narrow stance
    more quadriceps force) are the one source pointing lower and are
    outweighed. The row is level with the library's dumbbell-loaded Goblet
    Squat (0.85) and below the Back Squat (0.90) for the lighter load held
    in the hands (McCaw 1999: quadriceps EMG changed with load), not for the
    stance.
  - Gluteus maximus MOD 0.58 (was 0.62): hip extensor moments rise with width
    (Escamilla 2001, Lahti 2019, Hopkins 2024; Sinclair 2022 more
    posterior-chain force wide). EMG is mixed: Paoli 2009 higher only at the
    widest stance, McCaw 1999 a load x stance interaction only, and Lee 2026
    measured the gluteus maximus and found no stance effect.
  - Adductors MOD 0.44, deliberately not high: Pereira 2010 (hips turned out
    30-50° raised hip adductor activity at 60-90° knee flexion, from a low
    level) and McCaw 1999 (adductor longus stance x phase interaction) point
    up; Paoli 2009 (adductor magnus unchanged by width), Hopkins 2024 (hip
    adductor moment unchanged by width) and Delmore 2014 (sumo squats last of
    six adductor exercises) point the other way.
  - Hamstrings as a stabiliser (ExRx dynamic stabiliser), forearms for the
    grip.
- Hold cue: mechanics (the load under the shoulders rides with the hips; a
  drifting load pulls the chest forward). The ghost swings the arms 25°
  forward, the dumbbell in front of the knees, as the mistake says; the
  mistake no longer says the chest follows, since the ghost does not move
  the chest.
- Stance cue (STANCE, shared with the barbell version): ExRx Smith Wide Squat
  (feet wide, pointing out 30-45°, knees the same way as the feet); "wide
  stances asked more of the hip extensors than narrow ones": Escamilla 2001
  (3-D: greater knee and hip moments wide), Lahti 2019, Hopkins 2024; "and
  drew more glute activity in some of them": Paoli 2009 (widest stance
  only), McCaw 1999 (load x stance interaction); Lee 2026 found no gluteus
  maximus change, hence "some"; "squatting wide with the toes pointing
  straight ahead produced some of the largest knee and hip moments
  measured in one study": Lorenzetti 2018 (special care in the wide / 0°
  and narrow / 42° positions). Escamilla 2001 (knee biomechanics) found no
  difference in muscle activity or knee forces between 0° and 30° toe-out,
  so the copy does not claim the toe angle targets muscles; it is about
  letting the knees follow the feet.
- Knee cue (KNEE_WIDE): Myer 2014 (knee valgus linked to hip abductor and
  external rotator weakness, adductor overactivity and restricted
  dorsiflexion), Macrum 2012, ExRx.
- Depth cue (DEPTH_WIDE): Pereira 2010 (adductors most active at 60-90°
  knee flexion, "past 60 degrees ... in one squat study" in the copy), Kubo
  2019 (full squat training grew the gluteus maximus and adductors more
  than half squats). The EMG claim that the glutes do a larger share the
  deeper you go was dropped: only Caterisano 2002 (n = 10, share of four
  muscles' summed EMG, parallel vs others p = 0.056) supports it, and
  Contreras 2016 found no gluteus maximus difference between parallel,
  full and front squats.
  The model pauses ~0.75 s at the bottom, hence "pause".
- Torso cue: "keeping the trunk fairly upright, leaning only about as far
  as the shins, keeps the weight over the middle of the feet": Myer 2014
  (trunk parallel to the tibia as a guideline); the model's trunk (18°)
  matches its shins (17°). Escamilla 2001 found no trunk difference between
  stances, so the copy makes no link between the wide stance and an
  upright trunk (the first draft's "so the trunk can stay fairly upright"
  did; removed in review 1).
- Comparison STOPPING SHORT: Kubo 2019 (the correct note now names the
  training result, not EMG), Pereira 2010.

## Barbell Sumo Squat

Model: the dumbbell version's legs exactly; a high bar ~6 cm behind the neck
joint, hands 0.78 m apart, elbows ~45° and pointing down; trunk 4° -> 22°,
the bar 6 cm forward at the bottom.

- Rows as the dumbbell version, higher for the load (0.90 / 0.64 / 0.44;
  were 0.82 / 0.64 / 0.44): the wide-stance studies loaded a bar at 60-75%
  (McCaw 1999) and 70% 1RM (Paoli 2009), heavier than a dumbbell held in
  the hands. Quadriceps as the library's Back Squat (0.90): same bar, same
  load class, no EMG drop with stance, and greater knee extensor moments
  wide (Escamilla 2001). Gluteus maximus a little above the Back Squat's
  0.62 for the wide stance's greater hip extensor moments (Escamilla 2001,
  Lahti 2019, Hopkins 2024), and above the dumbbell version's 0.58 for the
  load.
- Erector Spinae S MOD 0.45 (an activation row, not a stabiliser):
  consistent with the library's Back Squat (0.45; Front Squat 0.50). A free
  high bar on the back with the trunk leaning 22° at the bottom, and
  Escamilla 2001 found no trunk difference with stance width, so the back
  demand is taken as the back squat's. (The first draft listed it only as a
  stabiliser from ExRx's Smith Wide Squat, a guided-bar machine.)
- Bar cue: Glassbrook 2017 (high bar more upright than low bar in back
  squats), worded "in back squats". The first draft's "which suits the
  wide stance" had no source (wide-stance powerlifters often squat
  low-bar) and was removed. The bar dot is on `upper_arm_L`, where the bar
  crosses the near shoulder at yaw -0.8; the library Back Squat's
  `support_TrapeziusUpper_L` projects onto the side of the head here. The mistake ghost reuses `barSlidLow`
  from the split squats (10° more lean, hands 6 cm lower on the back).
- Brace cue: Myer 2014 (trunk upright, rigid; excessive flexion or rounding a
  deficit); "leaning only about as far as the shins keeps the bar over the
  middle of the feet" is Myer's guideline plus mechanics, with no stance
  link (Escamilla 2001); the lower-back lever is mechanics. The model's trunk (22°) is a
  little more than its shins (16°); "about as far as the shins" is Myer's
  guideline, which the model roughly meets.
- Setup: bar racked at upper-chest height (as ExRx Smith Wide Squat and the
  split squats), safety bars just below the bottom position (practice, as
  in the 300-350 batch's barbell Bulgarian split squat).
- Comparison KNEES CAVING IN: Myer 2014, Lorenzetti 2018.
- Library: barbell, intermediate.

## Kettlebell Goblet Squat

Model: ankles 0.42 m apart, toes out 12°; kettlebell by the sides of the
handle, bell down, against the chest; elbows ~50°, pointing down. Bottom:
knees 56°, hips 91°, thighs 13° above parallel, shins 47° forward with the
kneecaps 29 cm ahead of the ankles, heels down; trunk 4° -> 14°.

- **No kettlebell goblet squat EMG study was found.** The closest is Collins
  2021 (a goblet squat at 30% body mass, the load held at the chest: more
  vastus medialis and lateralis activity and vertical force than the
  landmine squat; the abstract does not name the implement). Gullett 2009:
  front vs back squat bar position did not change muscle activity (so a
  front load is not assumed to change the ranking). Quadriceps 0.86 HI,
  gluteus maximus 0.50 MOD (about parallel). Adductors are a stabiliser
  (with upper back and forearms), as in the library's Goblet, Back and
  Front Squats: this model's stance (about shoulder width, toes out 12°) is
  the Goblet Squat's and no goblet study measured the adductors, so no
  adductor bar the dumbbell Goblet Squat lacks. Close to the library's
  Goblet Squat (0.85 / 0.52). Rectus Abdominis S LOW 0.32 added in review
  2, as the library's Goblet Squat (0.32), in place of a core stabiliser, so
  the two goblet squats show the same trunk rows; no goblet study measured
  the abdominals, so the value is the library's, not a measurement.
- Hold cue: ACE Goblet Squat (weight in front of the chest, elbows close to
  the ribs); "the further it drifts, the more it pulls the chest forward" is
  mechanics. Ghost `wideBellSagging` is the library Goblet Squat's hold
  fault.
- Heel cue: "the knees travel well forward, past the toes ... fine while the
  heels stay down": the model (kneecaps 29 cm ahead of the ankles, heels
  flat) and Fry 2003 (some forward knee travel is appropriate; restricting it
  moves load to the hips and trunk). Macrum 2012 for the heel and ankle
  claim; "if the heels still lift, stand a little wider": Demers 2018
  (narrower stances need more dorsiflexion; limited dorsiflexion may
  benefit from a wider stance).
- Knee cue: Myer 2014, Macrum 2012, ExRx Kettlebell Front Squat (knees the
  same way as the feet).
- Depth cue: see the model notes (the model stops a little above parallel;
  the label reads "About parallel"). "Training through a full squat built
  more glute muscle than half squats": Kubo 2019. "The load in front helps you sit down between the heels
  with the chest up" is the usual coaching reason for the goblet hold, not
  a measured result.
- Torso cue: mechanics (a front load moves ahead of the feet as the chest
  tips). No "in line with the shins" here: the model's trunk (14°) is far
  more upright than its shins (47°).
- Comparison HEELS LIFTING: Myer 2014, Macrum 2012.
- Library: kettlebell, beginner (ACE rates the dumbbell goblet squat
  intermediate; the library's Goblet Squat is beginner, kept for
  consistency).

## Model notes

Where the models differ from textbook technique:

- **Lateral Lunge trunk lean.** The model hinges to 58° at the bottom, the
  head coming down to about hip height of a standing lifter. ExRx says keep
  the torso upright; ACE's side lunge pushes the hips back with a braced
  trunk. The copy accepts a forward lean from the hips and makes the back
  flat the cue, and the torso ghost rounds the back rather than adding more
  lean. It does not tell the user to lean 58°.
- **Lateral Lunge shin.** ACE takes the stepping shin to vertical; the model's
  shin is 19° forward with the kneecap 13 cm ahead of the ankle (still behind
  the toe tip). The copy does not ask for a vertical shin.
- **Lateral Lunge step.** The stepping foot lifts only ~3 cm and lands flat;
  ExRx lands heel then forefoot. The copy says land the foot flat.
- **Cossack straight foot** turns up onto its heel (StrengthLog's cue), read
  from the still; the brief gives only the foot's yaw (constant 20°) and the
  ankle moving 7 cm back.
- **Cossack knee** travels slightly outside the toe line (37° vs the 20°
  toe-out). The copy says the knee follows the toes and the fault is caving
  inward, which is not what the model does.
- **Goblet depth.** The model stops with the thighs 13° above parallel (hip
  joint ~10 cm above the knee joint) even though the knees bend to 56°,
  because the shins tip 47° forward. ACE's goblet squat goes to the hips
  below knee level. The copy says "about parallel, deeper if the heels stay
  down and the back stays flat", and the label reads About parallel.
- **Sumo squats** reach exactly parallel (0°) with the trunk about in line
  with the shins, and pause ~0.75 s at the bottom; no difference from
  textbook technique. The dumbbell's lower end stays ~0.24 m off the floor,
  so no step is needed for this depth.
- **Lateral Lunge centred half squat.** The step does not go straight into
  a hinge over one leg: at 1.0 s (and again at 3.0 s on the way back) the
  pelvis sits midway between the ankles, both knees ~135° and the trunk 5°
  forward (the b_mid still); only then do the hips shift and hinge over the
  stepping leg. The other knee is still 135° at 1.5 s and 148° at 2.5 s and
  is straight (171°) only at the bottom, 1.75-2.38 s. The copy therefore
  asks for the other knee to be straight at the bottom, not throughout, and
  the hips mistake no longer describes this centred position.
- **Lateral Lunge `_bent` / `_straight` jump.** Because of that centred
  half squat the knees nearly tie (1.0 s L 136° / R 134°; 3.0 s L 135° /
  R 133°), and the more-bent-knee rule gives the `_bent` role to the trail
  leg there: in rep 1 it goes R (top) -> L (0.5 s) -> R (~1.0 s) -> L
  (1.5 s) -> R (~3.0 s), mirrored in rep 2. joints.json shows it
  (patella_bent on the trail knee at moments 1, 3, 5, 7). The Knee over
  toes, Heel down and Other leg straight dots jump across the screen
  several times a rep, and the knee, heel and trail ghosts land on the
  wrong leg mid-rep (at about half strength, both knees ~135°). The
  Cossack only ties at the top (L 170° / R 169°), so its start frame points
  at the right knee although rep 1 goes left. Not fixable in the family
  files; reported as a shared change (decide the working side by which
  foot the pelvis is shifted toward, e.g. the sign of dot(pelvis - (foot_L
  + foot_R)/2, frame.left), or switch only when one knee is >~10° more bent,
  in both `BodyFrame.bentSide` and probe.py's SIDE_SHIFT points, then
  re-probe joints.json).
- **Barbell Sumo bar drift.** The bar comes 6 cm forward at the bottom as the
  trunk tips to 22°; within the normal range for a high-bar squat.

## Ghosts and when to still them

Framing yaws: Lateral Lunge and Cossack -0.3, Dumbbell Sumo and Goblet -0.5,
Barbell Sumo -0.8. Sagittal faults turn to a total of -1.2 (-0.9, -0.7, -0.4),
the left side (the working leg in rep 1) toward the camera; knees caving in
turn to face-on (0.3, 0.5, 0.8); the toes-forward stance fault turns to -0.2
(0.3, 0.6), where the toes swing across the screen; the straight leg bending
turns to a total of -0.9 (-0.6), where both the foot sliding in and the knee
folding show.

New pieces (in the swift text, prefixed `wide`): `wideStraightLegBent(_:)`
(the straight foot slides in, the knee re-seats and folds; strength from
the bent knee), `wideHipsForward` (lateral lunge: hips 0.15 torso lengths
forward, trunk 25° more upright, both knees re-seated; the straight leg,
foot fixed, folds 171° -> ~149° as a side effect and is kept so the hips
stay joined), `wideSideShallow(_:)`
(`shallow` for the side-to-side lifts, strength read from `shin_bent`, since
`shallow` reads `shin_L`, which is straight in rep 2), `wideToesForward`
(both feet's toes swung 35° to point ahead), `wideBellSagging` (the library
Goblet Squat's hold fault). Reused: `backRounded`, `chestDropped`,
`kneesIn("bent")` (lateral lunge, default 0.17), `kneesIn("bent", 0.3)`
(Cossack: the bent knee already sits ~16 cm outside the ankle and ~8 cm
outside the toe line, 21 cm x tan 20°, so the default ~10 cm would leave
the ghost knee over the second toe, the correct position; 0.3, ~18 cm,
puts it ~2 cm inside the ankle, over the arch), `heelsUp("bent")` (their
strength follows the named knee, so they switch legs with the reps), `shallow`, `armsSwungForward`,
`barSlidLow`, `kneesIn()`, `heelsUp()`.

Checked with a Python port of `FaultGhost.solve` on the rigs (Blender's
bundled pxr): at 2.0 s the lateral lunge's `wideHipsForward` moves the
pelvis 8.9 cm forward, takes the trunk from 58° to 33° and the kneecap from
13 to 21 cm ahead of the ankle (knee 87° -> 80°); `wideStraightLegBent(0.12)`
moves the straight foot 7.1 cm in and folds that knee 171° -> 139°; on the
Cossack `wideStraightLegBent(0.2)` moves the foot 11.8 cm and folds the knee
171° -> 120°, the knee rising ~17 cm; `wideSideShallow(0.3)` lifted the
pelvis 17.8 cm (hip joint from 3.6 cm below to 12.8 cm above the bent
knee), but the straight leg, already at 171° with its foot fixed, cannot
reach: the hip-ankle span grows from ~0.84 to ~0.90 m and the ghost draws
that leg ~7% too long. Review 1 cut it to `wideSideShallow(0.2)`: ~12 cm,
span ~0.875 m (~4% stretch), the hip joint ~7-8 cm above the bent knee
(estimated by scaling the 0.3 result), about three quarters of the way
down, the thigh about 10 degrees above parallel (the mistake copy says
"stopping short of parallel" to match); on the dumbbell sumo `wideToesForward` turns the toes
from 35° out to within 3° of straight ahead.

Still moments (fault_moments_legs30_wide.json): every fault at the bottom
except the sumo squats' stance fault (constant, "any"). All five are
`fault_times.py`'s "legs" kind (`kind()` matches "lunge" and "squat"):
bottom = pelvis lowest in the first 4 s, i.e. rep 1, the rep with the left
leg working, which the -0.9 / -0.7 / -0.4 turns assume.

## Labels

Rows are written on the 0.14-0.86 scale and squeezed to 0.16-0.80 by
`spec_legs30.py`. Checked by drawing the pills and leaders over the start,
mid-descent (b_mid, 1.0 s) and both bottom stills (scratchpad
`legs/wide/layout_*.png`, redrawn in review 1 with the b_mid still).

- Lateral Lunge and Cossack: the body swings from one side of the screen to
  the other, so the labels use only the two top rows and the bottom row
  under the feet; the leaders to the bent knee and foot cross the frame in
  one of the two reps whichever side they sit on. The long "Other leg
  straight" pill takes the top right (the heads never rise above v 0.28);
  the short Hips back / Sit deep pills sit below it at the second row,
  starting at u ~0.77 / ~0.83. At row 0.32 the first draft's long pill
  (u 0.64-0.97) covered the Cossack's face at 3.0 s (head at 0.63, 0.33)
  and sat on the lateral lunge's near deltoid at 1.0 / 3.0 s (0.68, 0.36);
  the check had used only the start and the bottoms.
- Dumbbell Sumo: the knees and shoes fill both edges at the fourth and fifth
  rows, so all five labels sit in the top three rows; the right-hand labels
  below the top row are short (Arms long, Toes out) to start past the near
  upper arm.
- Barbell Sumo: the plates sweep both edges between v 0.26 and 0.52, so the
  bar and chest labels sit above them on the top row (the bar dot on the
  near shoulder, `upper_arm_L`), the depth label on the
  right at the fourth row, the knee and stance labels on the bottom row.
- Kettlebell Goblet: the near arm and hip fill the right edge, so only the
  kettlebell label is on the right; the other four stack down the left, the
  heel label short enough to end before the right knee at the bottom.

## Uncertain

- The Cossack squat, the sumo squats and the kettlebell goblet squat have no
  direct EMG data; their rows are extrapolated as described.
- The adductor rows rest on mixed evidence: adductor longus rankings
  (Delmore 2014), surface EMG with the hips turned out (Pereira 2010), and
  training growth (Kubo 2019); Paoli 2009 and Hopkins 2024 found no change in
  adductor magnus activity or adductor moment with stance width.
- DiStefano 2009's lateral lunge values come from Macadam 2015's table; the
  original article was not reachable (403).
- ExRx was read through Internet Archive copies (the live site blocks
  automated fetches).
- Delmore 2014's abstract gives the ranking, not %MVIC values, and most of
  its pairwise differences were not significant.
- Lateral Lunge dots and one-leg ghosts jump between legs mid-rep (the
  `bentSide` rule; Model notes). Awaiting the shared fix in FaultGhost.swift
  and probe.py.
- The `wideSideShallow(0.2)` hip-over-knee height (~7-8 cm) is scaled from
  the 0.3 run, not re-solved.

## Change log

- 2026-09-28: first draft of the five entries, the ghosts and the still
  moments; label layout checked on the stills; new ghost pieces checked with
  a Python port of the solver; `spec_legs30.py wide` OK and
  `check_faults_legs30.py` BUILD SUCCEEDED.

## Change log (review 1)

- STANCE, Dumbbell and Barbell torso whys: removed the causal link between
  the wide stance and an upright trunk (Escamilla 2001 found none).
- DEPTH_WIDE, Cossack and Goblet depth whys, Dumbbell Sumo comparison
  correct note: dropped the "glute share rises with depth" EMG claim; kept
  Pereira 2010 (hedged to "one squat study") and Kubo 2019's training
  result. Added Contreras 2016 (J Appl Biomech 32(1):16-22, doi
  10.1123/jab.2015-0113, checked on Europe PMC) as conflicting evidence.
- Cossack depth why: only the knee is claimed to bend further than in most
  squats (hip 71° inner, ~109° flexion).
- STANCE: "asked more of the hip extensors ... and drew more glute activity
  in some of them"; notes record Lee 2026's null gluteus maximus result
  (checked in the PLOS ONE article) and that the lower quadriceps row rests
  on Sinclair 2022 only.
- Barbell Sumo: Erector Spinae S MOD 0.45 added as an activation row (Back
  Squat 0.45), removed from stabilisers; bar why no longer says a high bar
  "suits the wide stance"; bar dot moved to `upper_arm_L`.
- Kettlebell Goblet: adductors moved to stabilisers (library Goblet Squat
  consistency), two activation rows; depth label "About parallel".
- Lateral Lunge: erector spinae added to stabilisers (ExRx, checked through
  the Internet Archive); "in forward lunges" for Farrokhi 2008; hips mistake
  now "Keeping the hips forward over the stepping foot with the chest
  upright, so the stepping knee drives forward over the toes" (what the
  ghost draws; the model itself passes through a centred half squat);
  comparison mistake cue/note matched; trail intro "ends long" and correct
  cue straightens the knee as the hips move over; notes say the straight
  leg folds to ~149° in `wideHipsForward`.
- Cossack trail mistake: "the weight settling between the feet".
- Dumbbell Sumo hold mistake: dropped "the chest following it" (the ghost
  moves only the arms).
- Ghosts: Cossack `kneesIn("bent", 0.3)` (the default drew the correct knee
  position); Cossack `wideSideShallow(0.2)` (0.3 stretched the straight leg
  ~7%).
- Labels: Lateral Lunge and Cossack swap the two trailing top rows (long
  "Other leg straight" on the top row); overlays redrawn with the b_mid
  still.
- Header and notes: Delmore 2014's ranking marked descriptive (P > .08 for
  the other peak comparisons, checked on Europe PMC); Demers 2018 doi
  10.70252/BWZE8275 (PMC6033510); Lorenzetti 2018 erratum (BMC Sports Sci
  Med Rehabil 12:7, 2020, doi 10.1186/s13102-020-0160-6); Escamilla knee
  angles stated as flexion and the 2008 point attributed to the authors'
  interpretation.
- Model notes: the Lateral Lunge's centred half squat at 1.0 / 3.0 s and
  the `_bent` / `_straight` role jumping mid-rep (shared fix reported).
- Ghost-moments paragraph: all five are the "legs" kind; the stale shared
  request removed.
- `spec_legs30.py wide` OK; `check_faults_legs30.py` BUILD SUCCEEDED.

## Change log (review 2)

- Dumbbell Sumo Squat: Quadriceps 0.80 -> 0.85 (level with the library's
  Goblet Squat; the gap to the Back Squat is the lighter load, McCaw 1999),
  Gluteus Maximus 0.62 -> 0.58 (a step below the barbell version for the
  load). Barbell Sumo Squat: Quadriceps 0.82 -> 0.90 (as the Back Squat).
  Notes add Escamilla 2001's greater knee extensor moments in the wide
  stance (447-756 vs 359-573 N.m, re-checked on Europe PMC) and say
  Sinclair 2022 is outweighed.
- Lateral Lunge: Gluteus Medius LOW 0.36 -> MOD 0.46, reordered before the
  adductors (DiStefano 2009 39% vs gluteus maximus 41%). Cossack Squat's
  row, ranked from the lateral lunge, follows: LOW 0.34 -> MOD 0.46.
- Lateral Lunge hips why: the ankle claim for both studies, the knee claim
  for one (Riemann 2013; Flanagan 2004 found knee differences less
  consistent). Hips mistake: "over the stepping foot" dropped (the ghost's
  hips stay ~20 cm behind the ankle).
- Lateral Lunge setup step 4: now a pre-rep instruction ("Keep both feet
  pointing ahead; each rep steps one foot wide to the side and back.").
- Kettlebell Goblet Squat: Rectus Abdominis S LOW 0.32 added and core
  dropped from the stabilisers, matching the library's Goblet Squat.
- Cossack depth mistake: "Stopping short of parallel, the hips staying
  above the bent knee." (was "halfway down ... well above"); notes' depth
  bullet and Ghosts paragraph describe the ghost as about three quarters
  down, thigh about 10 degrees above parallel. `wideSideShallow(0.2)` kept.
- No ghost or still-moment changes.
