# Desktop "300-400" folder: kettlebell swing and deadlifts (2026-10-12)

Three of the folder's twelve new exercises, family "kb": 391 Kettlebell Swing
(`Legs/KettlebellSwing`), 392 Sumo Kettlebell Deadlift (`Legs/SumoKettlebellDeadlift`) and 394
Kettlebell Deadlift (`Legs/KettlebellDeadlift`), already converted, in the library rows and model
map with their framings (yaw -1.3 / -0.5 / -0.8) and probed into `joints.json`.
`spec_1012_kb.py` holds the copy and setup steps (its header lists what the models show and the
full citations), `Tools/fault-review/faults_1012_kb.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_1012_kb.json` their moments. This file maps the copy's claims to
their sources or to a model measurement.

## How the models were read

- Motion briefs `briefs_1012/<Resource>.md` (knee, hip, trunk lean, pelvis, hands and the bell
  every 0.5 s), the paint (`$LAB/r1012/tiers.txt`), the trainer stills
  (`$LAB/r1012/stills/<slug>_t{0,1,2,3,5}.png`) and `joints.json`.
- The rigs straight from the USD with Blender's Python + pxr, scripts in `$LAB/r1012/kb/`:
  `measure.py` (per frame: pelvis, the bell's world bounds, hands, both knees, the hip and knee
  angles in 3-D and in the side view, trunk lean, stance widths, toe-out from the foot bone, the
  thigh's direction over the floor, palm direction, arm angle, head against the trunk),
  `swingfine.py` (the swing every frame through the hip snap and the drop, wrist and forearm
  distance to the thigh), `sweep.py` / `projstills.py` (joints and the bell's box projected
  through each trainer framing with probe.py's camera), `draw_labels.py` (gen.py's pills and
  leaders drawn on the stills and on in-between poses), `ghost.py` + `try_ghosts.py` +
  `draw_ghosts.py` (a Python port of `FaultGhost.solve` and the candidate ghosts drawn).
- Hip angles in these notes are trunk-to-thigh in the side view (180 = straight). The briefs'
  "hip" is the 3-D angle, which reads 162-170° standing in these wide stances because the thighs
  splay out (the side view gives 177-179°).

## Model facts

One body in all three: neck to pelvis 0.592 m, thigh 0.444 m, shoulder joints 0.39 m apart, hip
joints 0.18 m. 7.96 s at 24 fps each.

### Kettlebell Swing

- Equipment: one kettlebell, 24 x 27 x 25 cm, in both hands on the handle, overhand: the palm
  (the hand's +z) faces back and a little up at the bottom and straight down at the top; wrists
  17 cm apart; elbows 171° at every frame.
- Stance: feet flat and still all clip, ankle joints 54 cm apart (shoulder joints 39 cm), toes
  15° out.
- Timing: four identical swings, one every 2.0 s; the clip starts at the bottom and loops there
  (bottom 0, 2, 4, 6, 7.96 s; top 1, 3, 5, 7 s).
- Bottom (the backswing): hips 90° (the trunk-thigh angle in the side view), knees 153° (a 27°
  bend), shins 3-4° back of vertical, trunk 60° forward (neck over pelvis), pelvis 0.84 m (6 cm
  below standing) and 25 cm further back. Hands 0.63 m up, 16 cm above the knee joints (0.47 m),
  between the thighs (the wrist 13 cm from the thigh's axis, its forearm in front of the inner
  thigh). The bell's
  centre 0.44 m up and 9 cm behind the knee joints (13 cm in front of the hip joints, below
  them), its top 0.58 m, its bottom 0.31 m: it never comes near the floor.
- Spine: at the bottom the three back segments (pelvis-spine, spine-chest, chest-neck) lean 50°,
  58° and 64°, standing -10°, -2° and +4°: the same 14° spread, so the back keeps its standing
  shape and only tips at the hips. Head within 12° of the trunk line at the bottom, 1° at the top.
- Drive: hips 117° at 0.25 s, 162° at 0.46 s, >= 175° from 0.58 s; knees 176° by 0.58 s; trunk
  under 2° from 0.62 s and vertical by 0.75 s. When the hips reach straight the bell's centre is
  at 0.81 m and rising; it passes hip height (0.90 m) at ~0.65 s.
- Top: the bell's centre peaks at 1.29 m at 1.0 s (top 1.41 m), 13 cm below the shoulder joints
  (1.43 m) and 12 cm above the chest joint (1.17 m): about chest height. The arms are 81° from
  hanging, 9° below level, the hands 8 cm below shoulder height, the bell 71 cm in front of the
  shoulders. It stays within 7 cm of its peak from 0.9 to 1.1 s. Hips 179°, knees 177°, trunk
  0° (the most it ever leans back is 0.5°).
- Drop: the body stays straight (hips >= 175°) until ~1.42 s, when the hands are back down to
  ~0.99 m, just above the hip joints; the hips then fold to 90° by 2.0 s while the bell swings
  back between the legs.
- Paint: biceps femoris, semitendinosus, semimembranosus and the three glutes bright; erector
  spinae, rectus femoris, vastus intermedius, lateralis and medialis, brachioradialis and the
  wrist and finger flexors and extensors (ECRB, ECRL, ECU, ED, FCR, FDP, FDS, PL) dim.

### Sumo Kettlebell Deadlift

- Equipment and grip: one kettlebell, 28 x 29 x 24 cm, both hands overhand on the handle (palms
  facing back at the bottom), wrists 18 cm apart, elbows 171-172°.
- Stance: ankle joints 66 cm apart (1.7 times the shoulder joints), toes 35° out, feet flat and
  still.
- Timing: standing 0-0.58 s; down to 1.71 s; the bell on the floor (its lowest point within
  0.5 cm of it) 1.71-2.12 s, the pelvis within 5 mm of its lowest 1.71-2.17 s; up until ~3.4 s;
  standing 3.38-4.58 s; the second rep the same (floor 5.71-6.12 s).
- Bottom: knees 89° (thighs 7° below level), hips 50°, trunk 49° forward, shins 9° forward,
  pelvis 0.53 m (36 cm lower) and 30 cm back. Each thigh points 35.4° out over the floor and its
  foot 35.0°: the knees track over the toes; knees 69 cm apart, just outside the ankles. The arms
  hang straight down (4° from vertical) between the knees (hands 9 cm either side of the midline,
  knees 35 cm), shoulders 3 cm ahead of the hands. The bell between the feet, its centre 4 cm
  ahead of the ankle joints, level with the middle of the feet (ankle-to-toe midpoint 6 cm ahead
  of the ankles).
- The way up: the trunk rights itself steadily as the pelvis rises (48° at 2.17 s, 42° at 2.5,
  30° at 2.83, 15° at 3.17, 4° at 3.5 s); the hips never rise ahead of the chest.
- Top: knees 176°, hips 177°, trunk 1°. The arms angle ~27° forward (hands 24 cm ahead of the
  shoulders), so the bell hangs about a hand's width in front of the hips. Below the knees the
  bell rises and lowers straight up and down (its centre 4 cm ahead of the ankles from 1.5 to
  2.5 s); above them it swings forward to 28 cm ahead of the ankles at the top.
- Spine at the bottom: segments 39°, 47°, 53° (standing -9°, -1°, +5°): the standing shape.
- Paint: hamstrings, glutes and the four quadriceps heads bright; erector spinae and the forearm
  muscles dim.

### Kettlebell Deadlift

- The same bell and grip (wrists 18 cm apart, palms back, elbows 171-172°).
- Stance: ankle joints 44 cm apart (about shoulder-width: the shoulder joints are 39 cm apart),
  toes 18° out, feet flat and still.
- Timing as the sumo: standing 0-0.58 s, the bell on the floor 1.71-2.12 s and 5.71-6.12 s,
  standing 3.38-4.58 s.
- Bottom: knees 104° (shins 11° forward, knees 7 cm ahead of the ankles), hips 49°, trunk 66°
  forward, pelvis 0.65 m (26 cm lower) and 32 cm back. Thighs 19° out over feet 18° out: knees
  over the toes, 45 cm apart. The bell's centre 6 cm ahead of the ankle joints, exactly level with
  the middle of the feet (ankle-to-toe midpoint 0.144 m, bell 0.14 m), the 28 cm bell between
  the feet. Arms 9° from vertical, shoulders 8 cm ahead of the
  hands, the arms inside the knees.
- Top as the sumo (knees 176°, hips 177°, trunk 1°, arms ~29° forward, the bell 29 cm ahead of
  the ankles); straight up and down below the knees, forward above them.
- Spine at the bottom: segments 56°, 64°, 70° (standing -9°, -1°, +5°): the standing shape.
- Paint: hamstrings and glutes bright; erector spinae, quadriceps and forearm muscles dim.

## Sources

Opened this session (2026-10-12); PubMed/Europe PMC records checked for each PMID and DOI.

- McGill SM, Marshall LW 2012, J Strength Cond Res 26(1):16-27, doi 10.1519/JSC.0b013e31823a4063,
  PMID 21997449. Abstract: 7 men plus a case study of a kettlebell master, 16 kg bell; "kettlebell
  swings create a hip-hinge squat pattern characterized by rapid muscle activation-relaxation
  cycles of substantial magnitudes (~50% of a maximal voluntary contraction [MVC] for the low back
  extensors and 80% MVC for the gluteal muscles with a 16-kg kettlebell) resulting in about
  3,200 N of low back compression". Van Gelder 2015 (below) reports this study's gluteus maximus as
  76.1 +- 36.6% and biceps femoris 32.6 +- 24.1% MVC, and says it emphasised a squat-based swing to
  chest height.
- Van Gelder LH, Hoogenboom BJ, Alonzo B, Briggs D, Hatzel B 2015, Int J Sports Phys Ther
  10(6):811-826, PMC4637916 (full text, PMC site). 19 analysed (23 recruited) novices, 8-16 kg,
  swings paced at 45 beats/min to a board 2-3 inches above eye level: two-handed swing gluteus
  maximus 69.4% and gluteus medius 53.0% of MVIC (Table 1); biceps femoris 78.95 +- 53.29% across
  all swings; the biceps femoris peaked first; terminal hip flexion 85.4° and extension -9.7° in
  the two-handed swing. Its phase table: the bell's momentum halted between and behind the legs at
  terminal hip flexion, the highest gluteal and hamstring activity as it is accelerated forward.
- Zebis MK, Skotte J, Andersen CH, Mortensen P, Petersen HH, Viskaer TC, Jensen TL, Bencke J,
  Andersen LL 2013, Br J Sports Med 47(18):1192-1198, doi 10.1136/bjsports-2011-090281, PMID
  22736206 (PubMed abstract): 16 female elite handball and soccer players; "Kettlebell swing and
  Romanian deadlift targeted specifically ST over BF (Δ17-22%, p<0.05) at very high levels of
  normalised EMG (73-115% of MVC)".
- Del Monte MJ, Opar DA, Timmins RG, Ross JA, Keogh JWL, Lorenzen C 2020, J Strength Cond Res
  34(7):1953-1958, doi 10.1519/JSC.0000000000002254, PMID 28930870 (abstract): 14 participants,
  hip hinge, squat and double knee extension swings; "the hip hinge swing elicited a greater
  overall MH and BF sEMG in comparison with the squat swing" and the double knee extension swing;
  medial hamstrings above biceps femoris across all.
- Lyons BC, Mayo JJ, Tucker WS, Wax B, Hendrix RC 2017, J Strength Cond Res 31(9):2363-2370, doi
  10.1519/JSC.0000000000001771, PMID 28394829 (abstract): one-arm swing, snatch and clean, 8-10RM:
  erector spinae Swing > Snatch, vastus lateralis Swing > Clean; no values in the abstract (the
  full text was not available).
- Bullock GS, Schmitt AC, Shutt JM, Cook G, Butler RJ 2017, Int J Sports Phys Ther 12(3):324-332,
  PMID 28593086, PMC5455182 (full text): 15 subjects, full effort, shoulder-height swing cycle time 1.45 +- 0.16 s,
  peak knee flexion 60.8°, peak hip flexion 69.8°. Used only to note that the model's 2.0 s swing
  is slower than these; the copy prescribes no pace.
- Murphy KM, Riemann BL 2025, Int J Sports Phys Ther 20(1):30-39, doi 10.26603/001c.127464, PMID
  39758692, PMC11698002 (full text): shoulder-height
  swings ended close to neutral hip extension (-1.8° and 0.2°). Background only.
- Brumitt J, En Gilpin H, Brunette M, Meira EP 2010, N Am J Sports Phys Ther 5(4):257-265, PMID
  21655384, PMC3096147 (full text): clinical
  commentary; overhand grip, the bell just behind the legs at the start, swung to about shoulder
  height, a neutral spine and braced trunk. Background only (it starts the swing from a squat
  position, which the model does not).
- Escamilla RF, Francisco AC, Fleisig GS, Barrentine SW, Welch CM, Kayes AV, Speer KP, Andrews JR
  2000, Med Sci Sports Exerc 32(7):1265-1275, doi 10.1097/00005768-200007000-00013, PMID 10912892
  (abstract): national powerlifting championship; "The sumo group had 5-10 degrees greater
  vertical trunk and thigh positions, employed a wider stance (70 +/- 11 cm vs 32 +/- 8 cm),
  turned their feet out more (42 +/- 8 vs 14 +/- 6 degrees)".
- Escamilla RF, Francisco AC, Kayes AV, Speer KP, Moorman CT 2002, Med Sci Sports Exerc
  34(4):682-688, doi 10.1097/00005768-200204000-00019, PMID 11932579 (abstract): 13 collegiate
  football players, 12RM: vastus medialis, vastus lateralis and tibialis anterior higher in the
  sumo, medial gastrocnemius in the conventional deadlift (the library Sumo Deadlift's comment
  quotes %MVIC values from the full text, which was not available to this family and is not used).
- Hanen NC, Ben Mansour K, Ertel GN, Duchene Y, Gauchard GC 2025, Front Bioeng Biotechnol
  13:1597209, doi 10.3389/fbioe.2025.1597209, PMC12148905 (full text, Table 3): 30 experienced men
  at 85% 1RM; biceps femoris higher in the conventional lift in both phases (78.0 vs 71.3 and 77.6
  vs 69.9, p 0.009 / 0.003), vastus lateralis higher in the sumo in phase 1 (63.3 vs 55.5, p
  0.014), gluteus maximus not different, thoracic erector higher in the conventional lift's second
  phase; each muscle normalised to its own peak in the task, so the values rank styles, not
  muscles.
- Lee S, Schultz J, Timgren J, Staelgraeve K, Miller M, Liu Y 2018, J Exerc Sci Fit 16(3):87-93,
  doi 10.1016/j.jesf.2018.08.001, PMID 30662500, PMC6323186 (abstract): conventional vs Romanian deadlift at 70%
  of the RDL 1RM: rectus femoris 58.57 vs 25.26 %peak and gluteus maximus 51.52 vs 46.88 %peak.
- Swinton PA, Stewart A, Agouris I, Keogh JW, Lloyd R 2011, J Strength Cond Res 25(7):2000-2009,
  doi 10.1519/JSC.0b013e3181e73f87, PMID 21659894 (abstract): the hexagonal bar "resulting in lower
  peak moments at the lumbar spine, hip, and ankle ... and an increased peak moment at the knee".
- Camara KD, Coburn JW, Dunnick DD, Brown LE, Galpin AJ, Costa PB 2016, J Strength Cond Res
  30(5):1183-1188, doi 10.1519/JSC.0000000000001352, PMID 26840440 (abstract): hexagonal bar more
  vastus lateralis; straight bar more biceps femoris (concentric) and erector spinae (eccentric).
- Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi 10.2519/jospt.2010.3337, PMID
  20118526 (abstract): "impaired muscular control of the hip, pelvis, and trunk can affect
  tibiofemoral and patellofemoral joint kinematics and kinetics in multiple planes".
- McCall P, ACE ProSource, October 2015: "Do it Better: ACE's Technique Series Continues With the
  Two-handed Kettlebell Swing" (acefitness.org/continuing-education/prosource/october-2015/5635/...;
  trainers quoted: A. Scantalides, StrongFirst/RKC Level II, and J. Sinkler). Read twice, the
  second time for exact sentences: "In the hip hinge, the knees remain in a slightly flexed position
  with the shins relatively vertical to the floor"; "Keep the spine long and hinge forward at the
  hips to lean down and grip the kettlebell with both hands in a palms-down grip"; "Keep the shins
  vertical to the floor and the spine straight as you pull the kettlebell back between the legs";
  "A common mistake often made by people learning the swing is to do a squat instead of a hip
  hinge"; "the swing is executed from the hips with minimal movement from the knees"; "Quickly
  push the hips forward and pull the knees back"; the down phase cued as hiking a football; "The
  explosive extension of the hips should propel the kettlebell up to chest or shoulder height";
  "The strength to move the weight should come from the legs and hips, NOT the shoulders";
  "Another common mistake is to think about lifting the kettlebell with the arms and shoulders"
  (like a front raise); "As the kettlebell reaches the top of the move, brace the abdominal
  muscles and contract the arm and shoulder muscles" for a brief pause. (So the copy does not tell
  the arms to stay loose at the top; it says they only guide the bell.)
- ACE Exercise Library, Swing (acefitness.org/acefit/exercise-library-details/0/391/): feet
  shoulder-width, knees slightly bent, both hands, palms facing down; back straight, sink back into
  the hips to pull the bell back between the legs, under the hips; lift the chest, push the hips
  forward and pull the knees back; the bell rises to chest height; the strength comes from the legs
  and hips, not the shoulders.
- StrengthLog, Kettlebell Swing (strengthlog.com/kettlebell-swing): primary glutes and lower back;
  secondary hamstrings, adductors, trapezius, forearm flexors; the bell one or two feet in front to
  start; a wide stance; knees bent only slightly; swing to about chest height; the hips (and back),
  not the arms, lift the bell; put it back on the ground after the set; goblet or front squats
  are better for the quadriceps.
- REP Fitness Editorial Team, reviewed by Rosie Borchert, NASM-CPT, "How to Deadlift with a
  Kettlebell: Master Form, Variations, and Benefits" (repfitness.com/blogs/training/kettlebell-
  deadlift; published 2026-06-01, updated 2026-08-07). Kettlebell deadlift: feet hip-width, toes
  slightly out; the bell between the feet, the handle "directly over the midpoint of your feet";
  shoulders back, chest proud; grip with both hands, "palms facing you"; push the hips back;
  "Flatten your back by pulling your chest up and engaging your lats"; brace; drive through the
  heels, extend the hips; "Stand tall at the top, squeezing your glutes without hyperextending your
  lower back"; lower by pushing the hips back first; let the bell touch the floor briefly. Common
  mistakes: rounding the lower back during the descent, squatting instead of hinging, letting the
  knees cave inward, jerking the weight off the floor, hyperextending at the top, holding the
  breath. Sumo: feet wider than shoulder-width, toes out about 45°, the bell centred between the
  feet, shins vertical at the grip; a more upright torso; emphasis on the inner thighs and glutes;
  less lower-back stress; drive the knees out; the bell in a straight vertical line. Muscles: glutes,
  hamstrings, erector spinae, lats, traps, core stabilisers, grip.

Searched and not found: any EMG study of a kettlebell deadlift (either stance) by name; the NSCA's
Kinetic Select kettlebell pages (403 from the lab's network). No claim rests on them.

## Activation

The rows follow the paint (bright = primary, dim = secondary). The rig lights the three glutes as
one group, so each bright glute group is one Gluteus Maximus row; the medius is named among the
swing's stabilisers (53% MVIC in the two-handed swing, Van Gelder 2015, a stabilising role in a
symmetric lift) and covered by the glute row on the deadlifts. Unpainted helpers go in the
stabilisers.

- Kettlebell Swing: Gluteus Maximus P 0.80 (McGill & Marshall ~80% MVC gluteal; Van Gelder 69.4%
  two-handed); Hamstrings P 0.76 (Zebis: very high, 73-115% MVC, semitendinosus-biased; Van Gelder
  BF ~79%; Del Monte: the hinge style the most; McGill's BF lower, so under the glutes, the order
  StrengthLog gives); Erector Spinae S 0.50 (McGill ~50% MVC; StrengthLog lists the lower back as
  primary, the paint has it dim); Forearms S 0.35 (estimate: two hands share one bell, a little
  under the library's Romanian and stiff-leg deadlifts' 0.36 and under its barbell and dumbbell
  deadlifts' 0.45; StrengthLog and ACE ProSource name the forearm flexors for the grip; the
  library Kettlebell Thruster, first cited here, has no forearm row); Quadriceps S 0.30
  (estimate: the knees only straighten 153° -> 177°; ACE ProSource lists the quadriceps among the
  synergists; Lyons 2017 found
  vastus lateralis activity without values; StrengthLog: squats suit the quads better).
  Stabilisers: gluteus medius (Van Gelder), adductors and trapezius (StrengthLog's secondaries),
  core (McGill's abdominal pulses).
- Sumo Kettlebell Deadlift: Gluteus Maximus P 0.76, Quadriceps P 0.74, Hamstrings P 0.56 (MOD),
  Erector Spinae S 0.50, Forearms S 0.35. No kettlebell EMG: anchored on the library Sumo Deadlift
  (gluteus maximus 0.84, hamstrings 0.66, quadriceps 0.72) a step lower for one bell's load; the
  quadriceps kept high (more vasti in the sumo: Escamilla 2002, Hanen 2025 early in the lift; this
  model's knees reach 89°); the hamstrings under the conventional kettlebell deadlift's (less biceps
  femoris in the sumo, Hanen 2025; no difference, Escamilla 2002); the erector under the
  conventional one's (trunk 49° vs 66°; Hanen's thoracic erector lower in the sumo's second phase;
  REP: less lower-back stress). Judgement calls throughout. Stabilisers: adductors (unpainted;
  REP: the sumo emphasises the inner thighs), lats and trapezius (REP), core. Three primary rows;
  on the lab shots the legend's primary line still fits on one line.
- Kettlebell Deadlift: Gluteus Maximus P 0.74 (as the library Dumbbell Deadlift, another bent-knee
  pull with the load in line with the body; Lee 2018), Hamstrings P 0.66 (the library Deadlift's;
  between the Dumbbell Deadlift's 0.56 at 58-65° knees and the Kettlebell RDL's 0.82 at 139°; more
  biceps femoris in conventional than sumo, Hanen 2025), Erector Spinae S 0.54 (as the Dumbbell
  Deadlift, under the hamstrings as painted), Quadriceps S 0.40 (the lowest moderate: a bent-knee
  deadlift works the rectus femoris far more than an RDL, Lee 2018, but less than the sumo,
  Escamilla 2002), Forearms S 0.35 (estimate). Judgement calls. Stabilisers: adductors, lats,
  trapezius, core (REP lists the lats, traps and core).

## Claims

### Kettlebell Swing

- Hip Hinge ("Hips back" on the pelvis). Intro: hips back, chest forward, knees a little, shins
  upright (model: hips 90°, knees 153°, shins 3-4° back of vertical, trunk 60°; ACE ProSource:
  shins relatively vertical, minimal knee movement). Why: a hip hinge, not a squat (ACE ProSource);
  the glutes and hamstrings stretch as the hips fold, then snap them straight (mechanics: hip
  flexion lengthens the hip extensors; ACE: explosive hip extension); a hinge-style swing drew more
  hamstring activity than a squat-style swing (Del Monte 2020); hips to ~90°, knees ~27° (model).
  Mistake: squatting the bell down (ACE's first common error). Correct: hips straight back, shins
  close to vertical, knees soft (ACE; model).
- Backswing ("Hike above the knees" on the left hand). Intro (reworded in review): between the
  legs at knee height (model: the bell 0.31-0.58 m up around the 0.47 m knee joints, centred 9 cm
  behind them), the hands above the knees (16 cm above the knee joints), the forearms close to the
  inner thighs (skinned meshes: the forearm flexors 2.6-3.5 cm and the hand 1.9 cm from the inner
  thigh muscles at the bottom). Why: the hips stop the bell and throw it forward (Van Gelder's
  phases: momentum halted between and behind the legs, then accelerated forward); a load further
  from the hips has a longer lever on the lower back (mechanics; Brumitt 2010: the bell's centre of
  mass makes a long lever arm), and a low bell drags the chest down (mechanics). Mistake: the
  hands sinking to the knees and the bell swinging low, the chest diving (the ghost: trunk 16°
  further down, head 20 cm, the grip to knee height). Correct: hike it back between the thighs
  (ACE ProSource's "hike"), hands above the knees, forearms close to the inner thighs (model).
- Flat Back ("Flat back" on the chest). Intro: the back keeps its standing shape (model: segment
  spread 14° standing and at the bottom), the neck in line (model: head within 12°). Why: swings
  with a 16 kg bell put ~3,200 N of compression on the lower back with the back muscles at ~half
  their maximum (McGill & Marshall 2012, "~50% MVC", "about 3,200 N"); "loads the spine quickly"
  is their "rapid activation-relaxation cycles"; a long, braced spine leaves the bending to the
  hips (ACE ProSource: spine long and straight; Brumitt: neutral spine, bracing). Correct: brace,
  spine long, fold at the hips (ACE).
- Hip Drive ("Arms guide" on the near shoulder). Intro: the hips snap straight, the bell
  floats to about chest height on straight arms (model: hips >= 175° by 0.58 s, the bell's centre
  peaks at 1.29 m, between the chest joint 1.17 m and the shoulder joints 1.43 m, elbows 171°; ACE
  Exercise Library and StrengthLog: chest height; ACE ProSource: chest or shoulder height). Why:
  the hips, not the shoulders, throw the bell (ACE ProSource: strength from the legs and hips, not
  the shoulders; explosive hip extension propels it; StrengthLog: not the arms); in the model the
  hips are straight when the bell passes hip height (~0.65 s) and it rises another third of a
  second (peak 1.0 s); lifting it with the arms turns the top into a front raise (ACE ProSource's
  second common error). Correct: hips forward hard, elbows straight, the arms only guiding the bell
  (ACE; StrengthLog).
- Stand Tall ("Stand tall" on the head). Intro: hips and knees straight, one line, no lean back
  (model: hips 179°, knees 177°, trunk 0°, never past -0.4°). Why: straightening the hips finishes
  the swing (ACE ProSource: explosive hip extension propels the bell), the braced trunk stays
  still (ACE ProSource: brace the abdominal muscles as the bell reaches the top); leaning back
  bends the lower back instead of the hips (mechanics; no source on the swing says it, REP lists
  hyperextending at the top among the kettlebell deadlift's mistakes). Correct: knees
  and hips straight (ACE: pull the knees back), shoulders over hips, then let the bell drop (model:
  the body stays straight until the hands are back at hip height, ~1.42 s).
- Comparison: squatting the swing; a squat-style swing drew less hamstring activity than a hinge
  (Del Monte 2020).
- Setup: feet a little wider than the shoulders, toes slightly out (model: ankles 54 cm, shoulder
  joints 39 cm, toes 15°; ACE says shoulder-width, the copy follows the model); the bell about a
  foot in front (StrengthLog: one or two feet); hinge and grip with both hands, palms down (ACE);
  brace and hike it back like a football snap (ACE ProSource); at the end guide it to the floor in
  front (StrengthLog: put it back on the ground). The model shows only the swings; it starts and
  loops at the bottom.
- Not claimed: a pace (the model swings every 2.0 s; Bullock's full-effort swings took 1.45 s),
  breathing (ACE ProSource and StrengthLog give opposite patterns), "float" timing beyond the
  model's own.

### Sumo Kettlebell Deadlift

- Stance ("Toes out" on the right foot). Intro: feet well wider than the shoulders, toes about 35°
  out, the bell between them (model). Why: wide feet with the toes out give the knees room to open
  over the feet, the hips sink between the heels, the bell passes between the legs (mechanics;
  REP: the sumo's wider stance and toes out); competition sumo pullers stood about twice as wide
  (70 vs 32 cm) and turned the feet out ~42° (Escamilla 2000). Mistake: wide with the toes forward
  (the library's sumo-squat stance fault). Correct (reworded in review): feet just outside the
  shoulders (skinned meshes: the shoes' inner edges 26.4 cm from the midline, the deltoids' outer
  edges 26.2 cm; the ankle joints 66 cm apart against 52 cm across the deltoids, so the draft's
  "about one and a half times shoulder-width" held only at mid-foot), toes 30-45° (REP ~45°,
  Escamilla 42 +- 8°, the library 30-45°; the model 35°), the bell centred and level with the
  middle of the feet (REP; model).
- Knee Tracking ("Knees out" on the left knee). Intro: knees out over the toes (model: thighs 35.4°
  out, feet 35.0°). Why: in a wide stance the knees travel out as well as forward to stay over the
  feet (mechanics); caving knees a common kettlebell deadlift mistake (REP); weak hip control
  linked to the knee drifting inward (Powers 2010, "can affect"). Correct: arms inside the knees
  (model).
- Chest Up ("Chest up, back flat" on the chest). Intro: the trunk only about halfway forward at the
  bottom (model 49°). Why: the wide stance lets the trunk stay upright (REP: a more upright torso;
  Escamilla 2000: sumo trunks 5-10° more vertical); 49° in the model; a flat, braced back passes
  the drive to the bell (mechanics). Correct: chest up, lats engaged (REP's standard cue).
- Hips and Chest ("Rise together" on the left hip; titled "Hips and Chest Together" before the
  review, whose mistake banner ran under the record button). Intro (reworded in review to describe
  the model, not cue it): hips and chest rise at the same rate, the trunk righting itself steadily
  (model: trunk 48° at 2.17 s, 42° at 2.5, 30° at 2.83, 15° at 3.17, 4° at 3.5 s as the pelvis
  rises). Correct: drive through the whole foot, knees out (REP: drive through the heels and push
  the floor away; drive the knees out). Why and mistake: mechanics (as the library Sumo Deadlift
  and Dumbbell Deadlift).
- Lockout ("Stand tall" on the head). Stand tall, glutes squeezed (REP); leaning back past upright
  only bends the lower back (REP lists hyperextending at the top as a mistake; mechanics); lower
  the bell the way it came up (REP: reverse the movement, hips back first).
- Comparison: knees caving in (REP; mechanics as the library Sumo Deadlift).
- Setup: model stance; the bell centred between the feet, level with their middle (REP); sink the
  hips, knees out, both hands palms facing you (REP); chest up, back flat, arms inside the knees,
  brace (REP; model).
- Not claimed: that the bell travels straight up and down (REP's sumo cue): the model's bell does
  below the knees but swings ~24 cm forward above them, its arms angled ~27° at the top.

### Kettlebell Deadlift

- Hip Hinge ("Hips back" on the pelvis). Intro: hips back first, knees only as far as needed to
  reach the handle with a flat back (REP: push the hips back; lower hips back first). Why: loads the
  glutes and hamstrings, the main movers (the paint; REP lists them first); hips ~50°, knees ~104°,
  shins close to upright (model: 49°, 104°, 11°); sinking straight down makes it a squat (REP's
  "squatting instead of hinging").
- Bell Position ("Bell mid-foot" on the right foot). Intro: at the bottom of each rep the bell
  touches down between the feet, the handle over the middle of the feet (model: each rep starts
  and ends standing and sets the bell down for ~0.4 s, 1.71-2.12 s; centre 0.14 m, mid-foot
  0.144 m; REP: the handle over the midpoint of the feet, let the bell touch the floor briefly). Why: the load in line with the body, as with a trap
  bar, where the lumbar and hip moments were lower than with a straight bar (Swinton 2011; the
  analogy is reasoning: the bell sits between the feet as the hex bar's handles sit beside them); a
  bell out in front lengthens the lever on the lower back (mechanics). Correct: handle over
  mid-foot, lats tight (REP), the bell close to the shins as it leaves and returns to the floor
  (REP: keep the kettlebell close to your body; the model's bell rises straight up past the shins,
  its centre 6-11 cm ahead of the ankle joints while below the knees; reworded in review from "close to
  your legs as it rises and lowers", since above the knees the bell swings out to hang a hand's
  width in front of the thighs).
- Flat Back ("Chest up, back flat" on the chest): flat back, spine holds its shape (model);
  rounding the lower back on the descent a common mistake (REP); brace, chest up, shoulders back,
  only as low as a flat back allows (REP).
- Knee Tracking ("Knees over toes" on the left knee): model (thighs 19°, feet 18°); caving a common
  mistake (REP); hip control (Powers 2010).
- Lockout ("Stand tall" on the left hip): stand tall, glutes squeezed, no hyperextension (REP).
- Comparison: squatting, not hinging (REP's mistake; mechanics).
- Setup: feet about shoulder-width, toes slightly out (model: 44 cm, 18°; REP says hip-width, the
  copy follows the model, whose wider stance leaves room for the 28 cm bell between the feet);
  the bell between the feet, handle over mid-foot; hips back, knees bent, both hands palms facing
  you; shoulders back, chest up, brace, stand (REP).

## Distinct from the library

- Kettlebell Romanian Deadlift (its 2026-10-12 model): knees 161° standing to 139° at the bottom,
  the bell never set down, slow lowering to mid-shin. The kettlebell deadlift bends the knees to
  104° and touches the bell to the floor each
  rep; the cues are the deadlift's (hinge with a knee bend, bell over mid-foot, lockout) rather
  than the RDL's (soft fixed knees, tempo, bell close).
- Dumbbell Deadlift (its 2026-10-12 model): two dumbbells at the sides, knees to 58-65°; here one
  bell between the feet.
- Sumo Deadlift (barbell): the same stance logic; here one bell between the feet, the arms
  hanging between the knees.
- The swing is the family's (and the library's) only ballistic hip hinge.

## Library rows

- Kettlebell Swing: LEGS, POSTERIOR CHAIN / KETTLEBELL / intermediate. Matches the paint
  (hamstrings and glutes bright). No change.
- Sumo Kettlebell Deadlift: LEGS, GLUTES + QUADS / KETTLEBELL / beginner. The paint lights the
  hamstrings bright too (a third primary row); GLUTES + QUADS still names what sets it apart from
  the conventional pull. No change requested.
- Kettlebell Deadlift: LEGS, POSTERIOR CHAIN / KETTLEBELL / beginner. Matches the paint. No change.

## Labels

(Rows after the squeeze.)

- Swing (the bell sweeps from between the legs to the left edge at v 0.23-0.34 through the middle
  left; the head from (0.35, 0.33) to (0.58, 0.18); the hips back to u 0.84): "Stand tall" 0.12
  left (ends u 0.24) -> the head; "Arms guide" 0.16 right (starts u 0.76) -> the near shoulder;
  "Flat back" 0.30 right -> the chest; "Hips back" 0.64 right, behind the thighs -> the pelvis;
  "Hike above the knees" 0.64 left, under the bell's arc and left of the far knee -> the near hand.
  Two constraints set it. At the bottom the head is left of the back, so the head's label has to
  be on the left and the back's on the right, or the two leaders cross (they did in a top-row
  layout with "Flat back" top left and "Stand tall" top right, checked with draw_labels.py). And
  the mistake view shrinks and lifts the model, so the bell at the top of its arc rises to
  v ~0.16-0.25 there: in round 2 the stand-tall pill at 0.16 left sat on the bell in its own
  mistake view, hence 0.12 (the mistake banner is above 0.065 and only across the middle; the
  buttons are on the right). Round 1 had "Hips drive, arms guide" top left on the far hand (the
  raised-arms ghost ran through it); round 2's "Arms just guide" started at u 0.68 and touched the
  lifted shoulder in its mistake view, so it was shortened to "Arms guide"; round 3's "Flat back"
  at 0.32 touched the top of the glutes in its own (lifted) mistake view, so 0.30.
- Sumo (the body fills u 0.17-0.81 at the bottom, the feet both bottom corners): "Stand tall"
  0.16 left -> the head; "Chest up, back flat" 0.16 right (starts u 0.62, right of the head) -> the
  chest; "Rise together" 0.32 right -> the near hip; "Knees out" 0.48 right, above the near thigh
  -> the near knee; "Toes out" 0.64 left, left of the far knee -> the far foot. Round 1 had the
  chest label top left and stand tall top right: at the bottom the two leaders crossed over the
  head.
- Kettlebell Deadlift (relaid in review, as this family's sumo and the library Kettlebell RDL at
  the same yaw): "Stand tall" 0.16 left -> the head; "Chest up, back flat" 0.16 right (from u
  0.624, right of the head) -> the chest; "Hips back" 0.267 right -> the pelvis; "Bell mid-foot"
  0.72 left -> the far foot (to the hands, its leader crossed the hanging bell at the top and the
  far shin at the bottom); "Knees over toes" 0.80 right, right of the near foot -> the near knee.
  The draft copied the Dumbbell Deadlift's layout ("Chest up, back flat" 0.16 left, "Hips back"
  0.16 right, "Stand tall" 0.267 right on the near hip): through the middle of each descent and
  ascent (0.8-1.1 s and 2.8-3.1 s on the author's per-frame sweep) the back leader ran across the
  face and, on the review's 1.0 s shot, the pill's end met the top of the head; the author's
  stills (0, 0.6, 1.5, 2, 3 s) fell either side of it.

## Ghosts

Sized with the port at each fault's still (points of the 382x655 viewport, turned views
included); bone lengths kept, no knee bent backward.

- Swing (side-on, no turns): hinge `hingeSquatted(withBar: true)` (0.82 of the move at the
  bottom: knees 153° -> ~114°, hips ~11 cm lower and ~5 cm forward, trunk ~18° more upright, 60° ->
  42°); hike `leanedForward(20, withBar: true, strength: .withBend("thigh_L"))` (trunk, arms and
  bell ~16° further down, the head ~20 cm, ~52 pt, the hands ~6 cm lower and the grip to knee
  height); back `rdl4BackRounded(.withBend("thigh_L"))` (head ~7 cm, ~19 pt); drive
  `r1012kbFrontRaise(22)` (new: the arms ~13° above level at the top instead of ~9° below, the
  hands ~20 cm higher, 1.34 -> ~1.55 m, between the neck and head joints, ~55 pt; zero in the lower
  half of the arc, by the hand-to-pelvis distance; the mistake view lifts the model, and 50°
  (round 1) ran past the head into the mistake banner, 32° (round 2) still reached its edge); top
  `r1012kbLeanedBack(20)` (new: ~14° past upright at the top, the head ~17 cm, ~42 pt).
- Sumo: stance `wideToesForward.seen(0.3)` at 0.3 s, standing (toe tips ~12 cm, ~30 pt; at the
  bottom the body's up axis tips 49° and the toes dipped ~4 cm into the floor; turned toward
  face-on as the library Dumbbell Sumo Squat's); knees `thruster500KneesIn(0.2).seen(0.3)`
  (each knee ~11 cm in, re-seated); torso `chestDropped(15, withBar: true).seen(-0.8)` (trunk 49° ->
  64°, rounded, head ~24 cm); hips `rdl4HipsShotUp.seen(-0.8)` (hips ~26 cm up and back, knees 89°
  -> ~160°); lockout `r1012kbLeanedBack(20).seen(-0.8)` (~15°, head ~18 cm).
- Kettlebell Deadlift: hinge `hingeSquatted(withBar: true).seen(-0.4)` (knees 104° -> ~77°, hands
  ~19 cm forward); bell `armsSwungForward(22, withBar: true, strength: .withBend("shin_L")).seen(-0.4)`
  (hands ~17 cm forward); back `rdl4BackRounded(.withBend("shin_L")).seen(-0.4)`; knees
  `thruster500KneesIn(0.2).seen(0.6)` (each ~10 cm); lockout `r1012kbLeanedBack(20).seen(-0.4)` (~13°).
- Moments (`fault_moments_1012_kb.json`): the swing in seconds (fault_times.py files it as a press:
  bottom 2.0 s for hinge, hike and back, top 3.0 s for drive and top); the deadlifts' bottom (the
  trunk tipped furthest, 1.75 / 1.92 s) and lockout (0.0 s), the sumo stance at 0.3 s.

## Lab rounds

- Check (`family_1012.sh check kb`, 15:43): integrates and builds (BUILD SUCCEEDED).
- Round 1 (`family_1012.sh shoot kb "0,0.6,1.5,2,3"`, 15:45; `$LAB/r1012/kb/round1`): builds;
  every pill clear of the lifter, the bell, the buttons and the legend at all five stills of all
  three lifts; all fifteen ghosts show their mistake in the right direction. Fixed after it: the
  swing's front-raise ghost (50°) ran past the head into the mistake banner and through the
  top-left drive pill, so 32° and the arms label moved top right onto the near shoulder ("Arms
  just guide"), stand tall top left; the sumo's two top leaders crossed over the head at the
  bottom, so its chest and stand-tall labels swapped sides; the sumo's toes ghost turned 0.3
  toward face-on.
- Round 2 (same stills, 15:52; `$LAB/r1012/kb/round2`): builds; the sumo's leaders no longer cross
  and its toes ghost reads (the feet turned to point ahead under knees that stay out). Still wrong
  in the swing's mistake views: the 32° front raise reached the edge of the mistake banner, the
  "Arms just guide" pill touched the lifted shoulder, and the top-left "Stand tall" pill sat on the
  bell at the top of the arc. Fixed: front raise 22°, "Arms guide", stand tall at 0.12 left (see
  Labels). The cues were also put in teaching order (the trainer opens on the first): swing hinge,
  hike, back, drive, top; sumo stance, knees, torso, hips, lockout; kettlebell deadlift hinge,
  bell, back, knees, lockout. The swing's drive mistake line now says "up toward head height".
- Round 3 (same stills, 15:59; `$LAB/r1012/kb/round3`): builds. The swing's mistake views are
  clean: the 22° front raise stays below and left of the banner, "Arms guide" clear of the
  shoulder, the "Stand tall" pill above the bell (~14 px) in the stand-tall view; the trainer
  stills at 0, 0.6, 1.5, 2 and 3 s show no pill on the lifter or the bell and no crossing
  leaders. One touch left: in the flat-back mistake view the "Flat back" pill (0.32 right) met
  the top of the glutes, so it moved to 0.30. The kettlebell bell-position intro was also
  corrected after this round: the model starts and ends each rep standing and only touches the
  bell down at the bottom, so the copy no longer says each rep starts on the floor. (The lab's
  `integrate_1012.py --only kb` also pasted another session's `faults_1012_revA.swift.txt`, whose
  name is not a family in `spec_1012.FAMILIES` and so is never skipped; it built cleanly with
  ours.)
- Round 4 (`family_1012.sh shoot kb "0,3" "Kettlebell Swing"`, 16:04; `$LAB/r1012/kb/round4`):
  builds; the swing's trainer stills and all five of its mistake views clean, the "Flat back" pill
  now clear of the glutes in its mistake view. The deadlifts' shots from round 3 stand (nothing
  of theirs changed after it but the bell-position intro).

## Self-review (2026-10-12)

- Sources: each PMID/DOI checked on PubMed or Europe PMC; abstracts read for McGill 2012, Zebis
  2013, Del Monte 2020, Lyons 2017, Escamilla 2000 and 2002, Lee 2018, Swinton 2011, Camara 2016
  and Powers 2010, full texts for Van Gelder 2015, Bullock 2017, Murphy 2025, Brumitt 2010 and
  Hanen 2025 (Table 3); the ACE Exercise Library page, the ACE ProSource article (re-read for its
  exact sentences), StrengthLog and REP Fitness opened this session. Softened or cut while
  checking: the knee cues say weak hip control "has been linked" to knees drifting in (Powers is
  a review), not "is one known cause"; "one of the most common" became "a common" (REP lists
  mistakes, not their frequency); the drive cue no longer tells the arms to stay loose (ACE has
  the arms and shoulders contract at the top) but to only guide the bell; nothing says ACE asks
  to "stand upright" (its text says to brace the abdominals at the top); the copy never says a
  deadlift bell travels straight up and down (REP's sumo cue) because these models' bells swing
  forward above the knees; the kettlebell deadlift no longer says each rep starts on the floor.
- Numbers in the copy and where they come from: swing hips ~90° and knees ~27° at the bottom,
  the bell rising another ~1/3 s after it passes hip height (model: ~0.65 s to the 1.0 s peak); ~3,200 N and back muscles at about
  half their maximum with a 16 kg bell (McGill & Marshall 2012); sumo stance about twice as wide
  and feet turned out ~42° in competition (Escamilla 2000); the sumo trunk ~49° at the bottom,
  toes ~35°, feet ~1.5 shoulder-widths (model); 30-45° toe-out (REP ~45°, Escamilla 42 +- 8°,
  the library 30-45°); kettlebell deadlift hips ~50° and knees ~104° (model). Every activation
  fraction is an EMG value (swing gluteus maximus and erector, McGill) or a judgement call
  anchored on a library lift, said so in the spec comments.
- Model fidelity: two hands, overhand, straight arms on all three; the swing's four 2-second
  swings from a loop at the bottom, a hinge with a small knee bend, a high backswing, the bell to
  about chest height, no lean back, the late hinge on the way down; the deadlifts' stances (66 vs
  44 cm, 35° vs 18°), depths, trunk angles, knees over toes, the bell touching down ~0.4 s at
  mid-foot. The copy follows the model where coaching differs: the swing's feet a little wider
  than ACE's shoulder-width, the kettlebell deadlift's about shoulder-width rather than REP's
  hip-width; the deadlift knees bend well past REP's "slight knee bend" (104° and 89°), so the
  cues teach a hinge with the knees bending as needed.
- Labels: five per lift; in the final shots no pill sits on the lifter, the bell, the buttons or
  the legend at 0, 0.6, 1.5, 2 or 3 s, and no two leaders cross; leaders cross the body only on
  the way to their joint (the sumo chest leader past the head's edge at the bottom, the swing's
  flat-back and arms leaders over the upper back at the bottom).
- Ghosts: fifteen, one per cue, every one a position fault shown in its own direction at its
  moment, bone lengths kept (the knee ghosts re-seat the knee), none through the floor beyond
  the 1 cm the real toe tips sit at. Two new pieces (`r1012kbFrontRaise`, `r1012kbLeanedBack`).
- Not done: no independent reviewer or skeptic pass this round (the coordinator may run one);
  the NSCA's kettlebell pages could not be opened.

## For the owner

- Both deadlift models hold the arms ~27-29° forward at lockout (hands 24-25 cm ahead of the
  shoulders), so the bell hangs a hand's width in front of the hips instead of from vertical arms,
  as on the library Kettlebell RDL. The copy does not mention it; a builder fix would let the arms
  hang.
- The swing loops from the bottom with no start from or return to the floor; the setup steps
  describe both.
- `fault_times.py` files "Kettlebell Swing" as a press (no rule matches "swing"); all its moments
  are given in seconds. An optional rule (swing -> hinge: bottom = trunk most tipped, top = least)
  would make "bottom"/"top" work.

## Review (independent reviewer, 2026-10-12)

Every cited source re-opened fresh and every model number re-measured with the reviewer's own
scripts, in `$LAB/r1012/kb_review/` (session scratchpad): `src/` holds the sources as fetched
(Europe PMC REST records for the 13 PMIDs, the PMC full texts of Van Gelder 2015, Bullock 2017,
Brumitt 2010 from the PMC site and of Hanen 2025 and Murphy 2025 from Europe PMC, the ACE Exercise
Library page, now served at acefitness.org/resources/everyone/exercise-library/391/swing/, the ACE
ProSource article, StrengthLog and REP Fitness live); `m/` the scripts: `dump.py` (every frame:
world joints, hand and foot rotations, the bell and handle boxes, straight from the USD),
`an.py`, `swing*.py`, `dl*.py` (angles in 3-D and in the side view, timing, the bell's path),
`contact.py` (the bell's lowest mesh point against the skinned shoe soles), `skin.py` (skinned
forearm, thigh, deltoid and shoe meshes through UsdSkel), `lib.py` (the library's re-modelled
Kettlebell RDL and Dumbbell Deadlift), `port.py` + `runall.py` (a separate Python port of
`FaultGhost.solve` and the eleven pieces in the table, run at the lab's still times).

### Sources: claim -> verdict -> action

- McGill & Marshall 2012 (abstract): 7 men plus a kettlebell master, 16 kg, ~50% MVC low back
  extensors, 80% MVC gluteal, about 3,200 N of low back compression, rapid activation-relaxation
  cycles -> supported (Flat Back why; gluteus maximus 0.80, erector 0.50). "Loads the spine
  quickly" paraphrases the rapid cycles -> kept.
- Van Gelder 2015 (PMC full text): 23 recruited, 19 analysed, none formally trained with a
  kettlebell; 8, 12 or 16 kg; 45 beats a minute to a board 2-3 in above eye level; two-handed
  gluteus maximus 69.4% and medius 53.04% MVIC; biceps femoris 78.95% across all swings and first
  to peak; terminal hip flexion 85.4°, extension -9.7°; the phase table; McGill's gluteus maximus
  76.1 and biceps femoris 32.6% and squat-based swing to chest height -> all as the notes say.
- Zebis 2013, Del Monte 2020, Lyons 2017, Escamilla 2002, Lee 2018, Swinton 2011, Camara 2016,
  Powers 2010 (abstracts): populations, findings and the quotes as stated -> supported. Del Monte
  carries the hinge why and the comparison note; Powers only "has been linked" (its "can affect").
- Bullock 2017 (Table 2): shoulder-height swing cycle 1.45 +- 0.16 s, knee 60.8°, hip 69.8° ->
  supported (not in the copy). Murphy 2025 (Table 2): shoulder-height swings end at -1.79° and
  0.23° -> supported (background). Brumitt 2010: as stated, and its line that the bell's centre of
  mass makes a long lever arm now backs the backswing why (notes).
- Escamilla 2000 (abstract): 70 vs 32 cm (2.2 times: about twice as wide), feet 42 vs 14°, trunk
  and thighs 5-10° more vertical, at a national championship -> stance why and chest-up why
  supported.
- Hanen 2025 (Table 3): biceps femoris 78.0 vs 71.3 and 77.6 vs 69.9 (p 0.009, 0.003), vastus
  lateralis 55.5 vs 63.3 in phase 1 (p 0.014), thoracic erector 74.8 vs 67.1 in phase 2 (p 0.022),
  gluteus maximus not different, each muscle normalised to its peak in the task -> exact.
- ACE ProSource (P. McCall, October 2015): every quoted sentence found verbatim. Two more lines
  now in the notes: hip flexion "lengthens the muscles responsible for creating hip extension"
  (the hinge why's stretch) and the quadriceps listed as synergists, the forearm flexors for the
  grip. ACE Exercise Library, StrengthLog, REP Fitness (published 2026-06-01, updated 2026-08-07,
  reviewed by R. Borchert): as stated. REP's "palms facing you" and "push the floor away" are in
  its conventional section; its sumo section names no grip (the sumo's grip follows the model).
- Not a source problem but a wrong anchor: the swing's forearm row (0.35) cited "the Kettlebell
  Thruster's grip row"; the library Kettlebell Thruster has no forearm row (the only 0.35 is the
  barbell Clean and Press). Re-anchored in the spec and the notes as an estimate: a little under
  the library's Romanian and stiff-leg deadlifts (0.36) and under its barbell and dumbbell
  deadlifts (0.45), two hands sharing one bell; StrengthLog and ACE name the forearm flexors.

### Model fidelity (re-measured)

Reproduced within rounding: the swing's 2.0 s period from a loop at the bottom; bottom hips 89.8°,
knees 153.0°, shins 3.6° back, trunk 59.6°, pelvis 6 cm lower and 25 cm back; hands 0.627 m, 16 cm
above the 0.470 m knee joints; the bell's box 0.305-0.578 m (its centre 0.415 m for the bell body,
0.44 m with the handle), 9 cm behind the knee joints, 13 cm ahead of the hip joints; back segments
14° apart standing and at the bottom; head 12° off the trunk line; hips >= 175° from 0.583 to
1.417 s, knees >= 176° from 0.583 s, the bell's centre passing hip height (0.90 m) at 0.660 s and
peaking 1.293 m at 1.0 s (shoulder joints 1.425, chest joint 1.169 m), arms 9° below level,
elbows 170.6° all clip, wrists 17 cm apart, palms back at the bottom and down at the top; hands
0.99 m when the hips start to fold; feet still, ankle joints 54 cm apart, toes 15° out. Sumo:
ankle joints 66 cm, toes 35°, standing to 0.583 s and again from 3.417 s, the bell within 0.5 cm
of its lowest 1.708-2.125 s; bottom knees 88.7°, hips 50.0°, trunk 48.6°, shins 8.5°, pelvis 36 cm
lower and 30 cm back, thighs 35.4° out over feet 35.0°, knees 69 cm apart, arms 3.6° from
vertical, shoulders 3 cm ahead of the hands, the bell's centre 4 cm ahead of the ankles (mid-foot
5.5 cm); top arms 26.7° forward. Kettlebell deadlift: ankle joints 44 cm, toes 18°; bottom knees
103.6°, hips 49.5°, trunk 65.6°, shins 10.6° (knees 7 cm ahead of the ankles), pelvis 26 cm lower
and 32 cm back, thighs 19.2° over feet 18°, the bell's centre at z 0.140 m with the ankle joints
at 0.080 and the ankle-to-toe midpoint at 0.144 m, arms 8.7°, shoulders 8 cm ahead; top arms 28°.
New measurements: the bell's lowest mesh point at the bottom is 0.001 m, the skinned shoe soles
0.0012 m (both 1.3 cm above the floor mesh), so the bell does touch down at sole level; the
forearm flexors pass 2.6-3.5 cm and the hand 1.9 cm from the inner-thigh muscles at the swing's
bottom; the deltoids are 52 cm across (not ~45 cm), the sumo's shoes start at the deltoids' outer
edge (26.4 vs 26.2 cm from the midline) and the kettlebell deadlift's heels sit 5 cm inside it.
The library's re-modelled Kettlebell RDL keeps its knees at 139-161° (the draft said 154-162°,
the old model) and the Dumbbell Deadlift sinks to 58-65° (as the draft's 59-67°).

### Activation, paint and library

Every row follows `tiers.txt` (swing and kettlebell deadlift: hamstrings and the three glutes
bright, the erector, quadriceps and forearms dim; sumo: the quadriceps bright as well); levels
match fractions; the glute group is one Gluteus Maximus row, the medius among the swing's
stabilisers and covered on the deadlifts. Against the library: the erector rows (0.50-0.54) sit in
its secondary erector range (0.36-0.58; Dumbbell Deadlift 0.54, Dumbbell RDL 0.52), the kettlebell
deadlift's hamstrings equal the Deadlift's 0.66 and the sumo's the Dumbbell Deadlift's 0.56, the
sumo's bright quadriceps (0.74) sit with the Dumbbell Deadlift (0.70 P), Sumo Deadlift (0.72) and
Trap Bar (0.78), the grip rows (0.35) just under the RDLs' 0.36. No fraction changed; only the two
anchors corrected (the forearm row above; the Kettlebell RDL's knee at 139°).

### Changed

On screen (spec):
- Swing Backswing intro: "high between the thighs, under the hips, the hands passing above the
  knees" -> "between the legs at knee height, the hands staying above the knees and the forearms
  close to the inner thighs". The bell spans 0.31-0.58 m around the 0.47 m knee joints, centred
  9 cm behind them and 13 cm ahead of the hip joints; only the hands and the handle are between
  the thighs. Correct: "Hike the bell back high between the thighs, ..." -> "between your thighs
  with the hands above your knees and the forearms close to your inner thighs, ..." (the label is
  "Hike above the knees").
- Swing Backswing mistake: "the bell swing low past the knees" -> "the hands sink to the knees and
  the bell swing low, the chest diving toward the floor after it". The ghost (trunk 16° further
  down at 0.82 strength) drops the hands only ~6 cm, to 10 cm above the knee joints, the grip to
  knee height; it shows the chest diving, not the bell passing the knees.
- Swing and kettlebell deadlift hinge mistakes: "the knees bend deep" -> "bend further", "the
  chest stays upright" -> "stays more upright": the ghosts take the knees 153° -> 114° and 104° ->
  77° and the trunk 60° -> 42° and 66° -> 44°, still well forward.
- Kettlebell deadlift bell correct: "keep the bell close to your legs as it rises and lowers" ->
  "close to your shins as it leaves and returns to the floor": above the knees the model's bell
  swings ~23 cm forward to hang a hand's width in front of the thighs (arms 28° forward at the
  top), which the copy should not deny on screen.
- Sumo stance correct: "about one and a half times shoulder-width" -> "just outside your
  shoulders" (1.26 times the deltoid width at the ankle joints, 1.4 at mid-foot).
- Sumo hips: title "Hips and Chest Together" -> "Hips and Chest" (the round-3 shot shows the
  mistake banner, COMMON MISTAKE · HIPS AND CHEST TOGETHER, running under the record button; the
  banner has no width limit); intro "Push the floor apart with the feet so ..." (a cue, and not
  REP's words) -> "The hips and chest rise at the same rate, the trunk righting itself steadily
  from the bottom" (the model).
- Kettlebell deadlift labels relaid (see Labels): "Stand tall" moved to the top left on the head,
  "Chest up, back flat" to the top right, "Hips back" to v 0.267 right. On the review's 1.0 s shot
  the draft's top-left back pill met the top of the head and its leader crossed the face, which
  the author's per-frame sweep confirms for 0.8-1.1 s and 2.8-3.1 s; with the new layout no
  leader comes within 0.087 (unit) of the head joint and no two leaders cross in any frame.

Comments and notes: the forearm anchor; the Kettlebell RDL's knees (139-161°) and the Dumbbell
Deadlift's (58-65°) in the spec and the notes; the swing's peak window (0.9-1.1 s) and lean
(-0.5°); the fault table's swing hinge comment (it gave the full move, 22° and 13 cm, beside the
knee angle at 0.82 strength, and "forward and up" for a grip that moves forward and 2 cm down),
its hike comment ("the hands below the knees": they stay 10 cm above the knee joints) and the sumo
torso comment (the neck-over-pelvis line reaches ~66°, not 64°); the claims for the changed copy.

### Ghosts and moments

All fifteen re-solved in the reviewer's port at the lab's stills (2.02 / 3.02 s swing, 0.32 /
1.77 / 0.02 s sumo, 1.94 / 0.02 s kettlebell deadlift): strengths 0.82 (swing bottom, hip bend),
1.0 (front raise, hand to pelvis 1.15 torso lengths at the top), 0.70 / 0.75 / 0.67 (lean-back
at the three tops), 0.85-1.0 (deadlift bottoms); sizes as the table says (front raise hands 1.34
-> 1.54 m, arms 12.7° above level; lean-backs turning the trunk 14.0°, 15.1° and 13.3° to 14°,
14° and 12° past upright, heads 17, 18, 16 cm; sumo toes 12.5 cm, knees 11 cm, chest 24 cm, hips
25.6 cm up and back with the knees 89° -> 161°; deadlift hinge 22° and 13 cm with knees 104° ->
77°, bell hands 17 cm, knees 10 cm);
every ghost bone the length of the real one; no knee re-seated backward. The moments are right:
the swing's bottom frames are 0, 2, 4, 6 s and its peaks 1, 3, 5, 7 s; the deadlifts' 1.75 and
1.92 s fall inside the bell-on-the-floor window and 0.0 s is standing. The new pieces read the
rig as their doc comments say (`.between("hand_L", "pelvis", 0.8, 1.1)` is 0 at 0.5 s, the hand
0.48 torso lengths from the pelvis, and 1 at the top, 1.15; `.whenStraight("thigh_L")` gives
0.67-0.75 standing).

### Labels, ghosts and moments on the shots

Round 3 and 4 shots inspected one by one, then two review shoots through WITHLOCK (BUILD
SUCCEEDED both times): `family_1012.sh shoot kb "0,1,2,3"` (16:33; sheets kept in
`$LAB/r1012/kb_review/shots1/`) and, after the relayout, `shoot kb "0,0.6,1,1.5,2,3" "Kettlebell
Deadlift"` (16:40; `shots2/`). The 1.0 s still was new to this family: it caught the kettlebell
deadlift's back pill against the head (fixed above, clean at all six stills after). Also checked
every second frame against the author's projection sweeps (`kb/*_sweep.json`, identical to
`joints.json` at the probed samples): with the final layout no pill comes within 0.06 of a head
joint and no leader within 0.04 in any frame of the three lifts; the only leader-over-bell flags
are the swing's hips leader grazing the bell's projected box at the bottom (the bell is hidden
behind the near thigh there) and the bell label's leader ending at the far foot beside the bell
(its job). Pills stay off the lifter, the bell, the buttons and the legend; no two leaders cross.
The sumo's mistake banner now ends ~20 px short of the record button. Each ghost shows its
mistake at its still (as sized above), and the swing's new backswing mistake line matches its
ghost (hands at the knees, chest diving).

### Open points for the owner

- `MistakeBanner` (Components.swift) has no width limit: a cue title past ~20 characters runs
  under the record button (seen here with Hips and Chest Together, now shortened). The library's
  Bench Angle and Bar Path (24 characters) may do the same; a shared cap or truncation would
  settle it.
- At the tops of the lifts the mistake view's lifted model puts the head over the banner's text
  (swing drive and top, sumo stance and lockout, kettlebell deadlift lockout), as noted on the
  thrusters; a framing matter outside this family.
- The swing's backswing ghost is modest (trunk 16° further down, the grip to knee height). With
  `leanedForward` the grip cannot go lower at any angle (at 30-50° it stays at 0.46-0.47 m while
  the head drops 28-47 cm: the hands circle the pelvis); a ghost with the bell well below the
  knees would need a new piece that also swings the arms down from the shoulders. The mistake
  line now describes the ghost as it is.
- As the author: the deadlift models hold the arms 27-28° forward at lockout (now also why the
  kettlebell deadlift's bell cue limits "close" to the shins); the swing has no start from or
  return to the floor; `fault_times.py` has no swing rule (all swing moments are in seconds).
- No shared file was edited; the library rows stand (Sumo Kettlebell Deadlift GLUTES + QUADS
  matches its two highest rows, the hamstrings a lower third).
