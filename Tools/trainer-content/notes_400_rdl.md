# 351-400 folder: Romanian deadlifts and the Dumbbell Deadlift (2026-10-01)

Eight exercises from the builder's 356-400 set (family "rdl"):
`spec_400_rdl.py` holds the copy and setup steps,
`Tools/fault-review/faults_400_rdl.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_400_rdl.json` their still moments. The spec
header lists what each model shows and the full citations; this file maps each
claim in the copy to them and records the model facts it relies on.

## Shared facts about the models

- Evidence: briefs `SCRATCH/s400/briefs/<Resource>.md` and
  `SCRATCH/s400/briefs_legs/<Resource>.md` (joint angles and positions every
  0.5 s), trainer stills `SCRATCH/s400/shots/view/<slug>_t{0,1,2,3,5}.png`,
  tiers `SCRATCH/s400/tiers27.json`, joints.json, the builder's
  DANH_SACH_356_400.md (356 bodyweight, 357 barbell, 358 two dumbbells, the
  single-leg lifts show one side).
- Rig frame: Y up, the lifter faces +z, their left is +x.
- Timing (all eight): two identical reps in 7.96 s. RDLs: ~0.6 s still at
  the top, ~1.0 s down, ~0.5 s held at the bottom (deepest 1.75 s), ~1.0 s
  up. Dumbbell Deadlift: bottom 1.2-2.7 s, deepest 2.54 s.
- Paint (all eight): biceps femoris, semitendinosus, semimembranosus and
  gluteus maximus, medius and minimus bright (PRIMARY); erector spinae dim
  (SECONDARY); nothing else. Activation rows follow it: hamstrings and glutes
  primary, erector spinae secondary, no other rows (the Dumbbell Deadlift's
  quadriceps are named in the copy but not painted, see its section).
- Which leg works: the three single-leg RDLs stand on the LEFT leg for both
  reps; the right leg is the free leg. The B-stance works the LEFT (front)
  leg; the right foot is the kickstand. The cue dots use `_L` for the working
  leg and `foot_R` for the free or kickstand foot. The copy says so in the
  knee / front cue and in step 1-2 of each setup, and each setup ends with
  switching legs.
- Framing (SampleData model map): single-leg RDLs yaw -1.3, zoom 0.599
  (side-on from the lifter's left, facing screen-left); B-stance -1.3, 0.897;
  Smith -1.0, 0.915; cable -1.0, 0.902; kettlebell -0.8, 0.904; Dumbbell
  Deadlift -0.8, 0.901.
- Library neighbours kept distinct: Romanian Deadlift (barbell, two legs;
  hamstrings 0.88, gluteus maximus 0.72, erector 0.42), Dumbbell Romanian
  Deadlift (0.84 / 0.70 / 0.52), Stiff-Leg Deadlift (0.88 / glutes secondary
  0.58 / 0.58), Deadlift (glutes 0.76, hamstrings 0.66, quadriceps 0.50,
  erector 0.85), Trap Bar Deadlift (0.80 / erector 0.75 / hamstrings 0.60 /
  quadriceps 0.78). The single-leg lifts add gluteus medius rows; the
  machine and cable RDLs sit a step under the free-weight RDL; the Dumbbell
  Deadlift ranks like a trap bar pull, glutes first. The library words stay:
  HAMSTRINGS for the RDLs, and every single-leg and B-stance entry lists the
  hamstrings first to match.

## Sources checked for this family

Each was opened and read for the numbers used (PMC full texts for Diamant,
Mo, Sørensen and Coratella; Europe PMC abstracts for Lee, Swinton, Dicus,
Zebis, Schwanbeck; JOSPT and search abstracts for DiStefano and Camara;
McAllister's full text; the web pages for ACE, PureGym, REP Fitness,
StrengthLog). Re-checked on 2026-10-01 against a sources review: ACE's
wording (one of the most common mistakes), Schwanbeck's abstract (n=6, free
squat higher), Coratella's full text (ascending phase only, bodybuilders),
Mo's full text (knee ~15°, the dumbbell results), Sørensen's methods,
Zebis's abstract, REP Fitness (stops at the bottom), PureGym B-stance and
StrengthLog.

- Diamant W, Geisler S, Havers T, Knicker A 2021, Int J Exerc Sci
  14(1):187-201, doi 10.70252/mvfy4610, PMC8136577. 15 trained men, barbell
  single-leg deadlift vs conventional deadlift at 8RM (62.7 vs 112.8 kg).
  Concentric: gluteus medius 77.6 vs 59.3 % (p 0.002), gluteus maximus 91.7
  vs 85.7 (n.s.), biceps femoris 82.1 vs 74.2 (p 0.041), erector spinae left
  67.4 vs 82.7 (p 0.004). Combined: GMED 68.1 vs 47.8, GMAX 73.4 vs 65.6, BF
  68.9 vs 60.2, ES left 58.7 vs 76.1. In the single-leg lift the erector
  (67.4 left, 66.2 right) was lower than in the deadlift but still about 0.8
  of the biceps femoris (82.1). GMAX against BF was not tested. Methods: the
  standing knee bent only as far as needed to keep the back straight (so it
  could bend during the rep; the copy cites Mo for a fixed knee); the
  straight free leg extended behind to counterbalance; the upper body about
  parallel to the ground; bar gripped at shoulder width.
- DiStefano LJ, Blackburn JT, Marshall SW, Padua DA 2009, J Orthop Sports
  Phys Ther 39(7):532-540, doi 10.2519/jospt.2009.2796. Bodyweight
  single-limb deadlift: gluteus medius 59 ± 25 %, gluteus maximus 59 ± 28 %
  MVIC. Only the abstract values are verified: the JOSPT full text could
  not be opened, so the exact single-limb deadlift technique (trunk angle,
  reach) is unverified, and the copy claims only that an unloaded
  single-leg deadlift worked the two glutes moderately.
- Mo RCY, Ngai DCW, Ng CCM, Sin KHS, Luk JTC, Ho IMK 2023, Front Physiol
  14:1264604, doi 10.3389/fphys.2023.1264604, PMC10716453. Twelve young men
  with at least 2 years of resistance training, reps at maximal speed.
  Single-leg RDL with one dumbbell (20-32 kg per subject) in one hand or a
  flywheel, the load on the standing-leg side or the opposite side;
  subjects maintained the knee at ~15° of flexion throughout, trunk about
  parallel at the bottom. Very high superior gluteus maximus (105-169 %) and
  biceps femoris (70-122 %); dumbbell concentric BF 113.0-115.2 %, inferior
  GMAX 78-97 %, erector 75.1 (ipsilateral) to 93.8 % (contralateral),
  gluteus medius 62.9 to 79.8 %. With the dumbbell, the contralateral hold
  significantly raised superior gluteus maximus (concentric) and gluteus
  medius, dominant-side erector and superior gluteus maximus (eccentric);
  the flywheel showed the same pattern; flywheel and dumbbell did not
  differ. Neither model holds one dumbbell, so the side effect is used only
  to rule out a reason for a lower gluteus medius.
- Sørensen B, Aagaard P, Malchow-Møller L, Zebis MK, Bencke J 2021, Int J
  Sports Phys Ther 16(3):704-714, doi 10.26603/001c.24150, PMC8168984. 23
  female elite team handball players; explosive reps from below the knee
  with the knees near full extension; the single-leg load half the two-leg
  8RM. Hamstring activity (% of peak nEMG): two-leg RDL 68.0 ± 18.8,
  single-leg RDL 63.6 ± 16.7.
- Lee S, Schultz J, Timgren J, Staelgraeve K, Miller M, Liu Y 2018, J Exerc
  Sci Fit 16(3):87-93, doi 10.1016/j.jesf.2018.08.001. Conventional vs
  Romanian deadlift at 70% RDL 1RM: rectus femoris 58.6 vs 25.3 %peak and
  gluteus maximus 51.5 vs 46.9 %peak, both significantly higher in the
  conventional lift; greater knee and ankle joint torques in it.
- McAllister MJ et al. 2014, J Strength Cond Res 28(6):1573-1580, doi
  10.1519/JSC.0000000000000302. Single reps at 85% 1RM of leg curl, good
  morning, glute-ham raise and RDL: hamstring activity maximised in the RDL
  and glute-ham raise.
- Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2022, Int J Environ Res
  Public Health 19(3):1903, doi 10.3390/ijerph19031903, PMC8835508. Ten male
  competitive bodybuilders, barbell from the floor at 80% 1RM, the spine
  kept straight: RDL, RDL standing on a 15 cm step and stiff-leg deadlift.
  The step raised gluteus maximus, semitendinosus and longissimus
  excitation in the ascending phase only; the biceps femoris did not
  differ. It also found the RDL drew more semitendinosus than the stiff-leg
  deadlift and the stiff-leg more gluteus maximus; that part is not used
  in the copy (see Knee Angle below).
- Zebis MK et al. 2013, Br J Sports Med 47(18):1192-1198, doi
  10.1136/bjsports-2011-090281. 16 female elite handball and soccer players.
  Kettlebell swing and RDL: semitendinosus over biceps femoris at 73-115 %
  of MVC.
- Swinton PA, Stewart A, Agouris I, Keogh JW, Lloyd R 2011, J Strength Cond
  Res 25(7):2000-2009, doi 10.1519/JSC.0b013e3181e73f87. Hexagonal bar (load
  at the sides) vs straight bar: lower peak moments at the lumbar spine, hip
  and ankle, a higher one at the knee.
- Camara KD, Coburn JW, Dunnick DD, Brown LE, Galpin AJ, Costa PB 2016, J
  Strength Cond Res 30(5):1183-1188, doi 10.1519/JSC.0000000000001352. Hex bar:
  more vastus lateralis; straight bar: more biceps femoris (concentric) and
  erector spinae (eccentric).
- Schwanbeck S, Chilibeck PD, Binsted G 2009, J Strength Cond Res
  23(9):2588-2591, doi 10.1519/JSC.0b013e3181b1b181. Six participants,
  free-weight vs Smith squat at 8RM: biceps femoris 26 % higher in the free
  squat (so the Smith about a fifth lower), all muscles together 43 % higher
  free. Small and a squat, not a hinge: used only for the direction of the
  Smith RDL's ranks.
- Dicus JR et al. 2023, Int J Exerc Sci 16(4):12-22, doi 10.70252/zaoj6139,
  PMC10124728. RDL vs cable pull-through vs reverse hyperextension at 50%
  1RM: the redirected (pulley) pull-through drew less longissimus (-11.0 %),
  multifidus (-14.1), biceps femoris (-13.1) and semitendinosus (-6.8) than
  the RDL. A different cable hinge (facing away, cable between the legs):
  used only to set the Cable RDL's rows a step under the free-weight RDL's,
  never in the copy.
- Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
  10.2519/jospt.2010.3337 (review): the hip's control of the thigh and
  pelvis and knee valgus.
- McCall P 2025, ACE Certified, The ACE Do It Better Series: The Romanian
  Deadlift (acefitness.org): slight knee bend, hinge by pushing the tailbone
  back, chin tucked, eyes to the floor; lower until tension behind the
  thighs, about knee height or mid-shin; the spine bending and rounding is
  one of the most common mistakes; clients often bend the knees as if
  squatting; T. Gentilcore: the farther the bar hovers from the body, the
  greater the stress on the lower back.
- ACE Exercise Library, Single-Arm Single-Leg Romanian Deadlift: standing
  knee slightly bent, back straight, the free leg straightened behind, the
  weight lowered in front of the standing leg.
- PureGym exercise pages (puregym.com): Single-Leg Deadlifts (soft knee, hips
  back, the free leg straight out behind, not to the side; lower to between
  just below the knee and mid-shin; start light or unloaded); B-Stance
  Deadlifts (a small step back so the back toes are in line with or just
  behind the working heel, only the ball of the back foot down, most of the
  weight on the working leg, the other leg just for balance; the weights as
  close to the working leg as possible, which the model does not show, so
  the copy leaves it out); Dumbbell Deadlift
  (neutral grip, dumbbells by the sides, lower toward the floor only as far
  as the spine stays neutral, no need to touch it).
- REP Fitness (Borchert), The Smith Machine Deadlift Guide: Smith RDL bar set
  just below hip height, safety stops all the way at the bottom of the
  machine, feet hip-width, toes forward, bar close to the legs, lower to
  about mid-shin; J. Flicker: the fixed path makes it easier to focus on
  posterior-chain work with less demand on balance or coordination. REP Fitness, Kettlebell Deadlift guide: the
  kettlebell RDL starts standing, the bell never set down between reps, a
  slight knee bend, the bell close, to about mid-shin.
- StrengthLog, Smith Machine Romanian Deadlift: primary hamstrings, glutes
  and lower back (secondary adductors, traps, forearm flexors). The model
  paints the lower back dim, so it is a secondary row here.

No EMG study was found for the B-stance, Smith, cable or kettlebell RDL by
name, or for a dumbbell deadlift with the dumbbells at the sides. Their rows
are ranked from the closest studied lifts, as each section says, and marked
as estimates in the spec comments.

## Shared cues (single-leg)

- Hinge and Reach (SL_HINGE, barbell and dumbbell): hips back stretches the
  standing hamstrings and glute (ACE RDL: push the tailbone back; PureGym
  single-leg: hips back); the free leg reaches back as a counterweight
  (Diamant 2021 methods, ACE single-leg page, PureGym); in the loaded lifts
  studied with the trunk near level the standing glutes and hamstrings
  worked hard (Diamant 2021 GMAX 91.7 / BF 82.1 % concentric; Mo 2023 very
  high SGM and BF; both near-parallel trunks). Correct: stop when trunk and
  free leg are close to level, as the model (trunk 72°, free leg 18° below
  level) and the studies. The bodyweight entry has its own why (below).
- Level Hips (SL_SQUARE): standing on one leg the gluteus medius holds the
  pelvis level (Powers 2010 on the hip's pelvic control); "a barbell
  single-leg deadlift drew clearly more gluteus medius than a two-leg
  deadlift" = Diamant 2021 (77.6 vs 59.3 % concentric, 68.1 vs 47.8 %
  combined). Free leg straight behind, not to the side: PureGym. The model:
  no pelvic tilt at any point, the free foot straight behind its hip, toes
  down (foot pitch 72° at the bottom). The barbell and dumbbell versions add
  one sentence each (the bar tips; the free-side dumbbell rides higher):
  mechanics of a pelvis and trunk turning open, drawn by the ghost.
- Standing Knee (SL_KNEE): "the left, standing knee ... the right leg is the
  free leg" is the model (left knee 160° all clip). Bending it more turns the
  hinge toward a squat and gives work to the thigh front: Lee 2018 (bent-knee
  conventional deadlift, rectus femoris 58.6 vs 25.3 %peak). "In a
  single-leg RDL study the standing knee was held at about 15 degrees of
  bend throughout" = Mo 2023 methods (subjects maintained ~15°); the model
  holds 20°. (Diamant's method let the knee bend as needed, so it is not
  cited for a fixed knee.)
- Spine Position (BACK, six entries): neutral spine keeps the bend at the
  hips; rounding is one of the most common RDL errors (ACE RDL, verbatim
  sense); chin tucked, eyes to the floor (ACE). "Often once the hips have
  run out of hinge and the hands keep reaching": mechanics, the same idea as
  ACE's stop point (lower until tension behind the thighs) and the library
  RDL's spine and range cues; not a measured frequency. The loaded entries'
  mistake says to get the weight lower; the bodyweight entry's says to
  reach lower.

## Single-Leg Romanian Deadlift (356)

Model: bodyweight. Left leg stands (knee 160° all clip, foot flat); right
free leg rests ~27 cm behind at the top, toes lightly down, then rises in line
with the trunk (right hip 176-180°, knee 175°) to 18° below level, ankle
0.63 m up, ~1.1 m behind the standing ankle. Standing hip 171° to 79°, trunk
0° to 72°, pelvis 28 cm back, no sideways tilt. Arms hang straight (elbows
175°), palms in, hands ~0.49 m up at the bottom (about knee height), ~25 cm
ahead of the standing ankle.

- Hinge and Reach (own why): the shared mechanics, then "even with no
  weight in the hands, a single-leg deadlift worked the standing hip's
  gluteus maximus and medius moderately in one study" = DiStefano 2009
  (bodyweight single-limb deadlift, both 59 % MVIC, MODERATE on the app's
  scale). The loaded studies are not cited here.
- Spine Position: the shared cue with its own mistake (dropping the head to
  reach lower; there is no weight).
- Balance (own cue): one foot as the base, hips back matched by chest and
  free leg (mechanics of the counterweight, Diamant methods). Correct: grip
  the floor, move slowly, master this unloaded version before holding
  weights (PureGym: start light or unloaded). The model's standing foot
  stays flat and still all clip.
- Activation: DiStefano 2009 GMAX 59 %, GMED 59 % MVIC, so both MODERATE
  and level (0.60 / 0.60). The hamstrings, not measured there, 0.62, just
  above as the hinge's other prime mover and the library word (loaded:
  Diamant BF a little under GMAX, not tested; Mo BF well above the inferior
  GMAX). Erector spinae holds only the trunk's weight: LOW 0.34, under the
  loaded single-leg lifts' 0.50 (estimate). Stabilisers: adductors,
  obliques, calves, core (balance on one foot).
- Setup: left foot, knee slightly bent, right toes behind, arms hanging palms
  in, brace, all reps, switch: the model's start position; switching legs is
  standard single-leg practice (PureGym).

Layout (side-on, the head's arc u 0.2-0.4 v 0.25-0.47, the hands in front of
the standing leg down to v 0.66, the free leg sweeping right of centre v
0.5-0.72): back top left, hinge second row right, knee short on the left at
0.72 (ends u 0.230, clear of the hands and left of the standing foot),
balance bottom left, square bottom right. Checked on all five stills.

## Barbell Single-Leg Romanian Deadlift (357)

Model: legs, trunk and timing as 356. Barbell overhand, hands 0.57 m apart
(just outside the thighs, about shoulder width as in Diamant), elbows 162°;
bar from 0.84 m (upper thighs) ~16 cm ahead of the standing ankle to 0.43 m,
just below the knee, ~6 cm ahead of it; level all clip.

- Bar Path: bar over the one foot; farther from the body = more lower-back
  stress (Gentilcore in ACE RDL). "Guides put the bottom between just below
  the knee and mid-shin, wherever the hips stop travelling back" = PureGym
  single-leg (just below the knee to mid-shin) and ACE (until tension behind
  the thighs, knee height or mid-shin); the model stops just below the
  knee. Shoulder-width overhand: Diamant 2021 methods.
- Level Hips (barbell version): SL_SQUARE's why plus "a barbell shows it at
  once: when the free hip opens, the bar tips" (mechanics: the shoulders turn
  with an opening pelvis; the ghost raises the whole right arm).
- Activation: Diamant 2021 is this lift. GMAX a little above BF (91.7 vs
  82.1 concentric, 73.4 vs 68.9 combined, not tested against each other)
  while Mo's dumbbell version has BF well above the inferior GMAX, so the two
  are level-pegged with the hamstrings first as the library word:
  hamstrings 0.86, GMAX 0.84. GMED close behind (77.6 / 68.1) = 0.74. The
  erector was lower than a conventional deadlift (67.4 vs 82.7) but about
  0.8 of the biceps femoris (Diamant; Mo 75-94 % with one dumbbell), so it
  stays secondary as painted but MODERATE 0.50, above the library RDL's
  0.42. Sørensen 2021: at half the two-leg load hamstring activity stayed
  about as high (63.6 vs 68.0), so the hamstrings sit just under the library
  RDL's 0.88.
- Setup: take the bar from a rack at hip height (standard barbell practice);
  left foot, as the model; switch legs.

Layout: bar label top left (ends u 0.391; the bar sweeps u 0.15-0.56 from v
0.45), back top right, hinge second row right, knee 0.72 left, square bottom
right. Checked on all stills.

## Dumbbell Single-Leg Romanian Deadlift (358)

Model: legs and trunk as 356; a dumbbell in each hand, palms in, the arms
~16° out from the sides so the dumbbells hang ~15 cm outside each shoulder,
0.75 m apart: the left one ~29 cm outside the standing ankle, the right one
on the free leg's side. Front to back they stay over the standing foot,
6-10 cm ahead of its ankle, and travel straight down from 0.84 m to 0.44 m
(just below the knee).

- Dumbbell Path: "one each side just outside the shoulders ... travel
  straight down" is the model. Travelling straight down keeps the load over
  the standing foot front to back and the lever short (Gentilcore in ACE
  RDL; ACE single-leg page: weight lowered in front of the standing leg);
  one in each hand is balanced side to side (mechanics). The copy no longer
  says the dumbbells hang beside the standing leg: in the model they hang
  well outside it.
- Level Hips (dumbbell version): SL_SQUARE's why plus "as the free hip
  opens, that side's dumbbell rides higher" (mechanics of the trunk
  following the pelvis; the ghost raises the whole right arm ~6 cm).
  Comparison: ONE SIDE RIDES UP, its own, so it no longer repeats the
  bodyweight lift's.
- Activation: Mo 2023 (dumbbell SL RDL) BF 113-115 % over the inferior GMAX
  78-97 %, GMED 63-80 % concentric, erector 75-94 %; ranked with the barbell
  version (Diamant 2021): hamstrings 0.86, GMAX 0.84, erector MODERATE 0.50.
  GMED 0.74 as the barbell: two dumbbells are a symmetric load like the bar;
  Mo's one-hand ipsilateral 62.9 and contralateral 79.8 % bracket Diamant's
  barbell 77.6 %.
- Setup: dumbbells at the sides palms in, left foot, right toes behind,
  switch: the model.

Layout: as the barbell version; the long dumbbell label (ends u 0.435)
points at the right hand (the far dumbbell, u 0.31): to the left hand its
leader ran through the chest dot at 1 s and 3 s (within 0.004) and read as
a second leader to Flat back (QA of the simulator stills, 2026-10-01).

## B-Stance Romanian Deadlift (359)

Model: left (front) foot flat, knee 162° all clip; right foot the kickstand,
fixed: ankle 20 cm behind and 29 cm to the side of the front ankle, heel up
on the ball (foot pitch 56°), its toes about level with the front heel; back
knee 130° to 113°. Trunk 0° to 62°, front hip 172° to 93°, pelvis 24 cm back.
Two dumbbells, palms in, ~15 cm outside the shoulders (0.71-0.73 m apart;
the left one ~26 cm outside the front ankle), from 0.84 m to 0.54 m (knee
height), straight down.

- Kickstand Foot: a small step back, toes level with or just behind the
  front heel, heel up, back foot for balance: PureGym B-stance. "It steadies
  you side to side while the front leg does the work" = PureGym (the other
  leg just for balance). "Stepped far back, it turns the lift into a
  split-stance RDL": naming, not a load-share claim (the old line that both
  legs then share the load was unsourced and is gone).
- Front Leg Works: most of the weight on the working leg, the other for
  balance (PureGym); "spares you most of the balancing of a true single-leg
  RDL": mechanics of the second contact.
- Hip Hinge: as the RDL; sinking straight down bends both knees into a split
  squat (mechanics; ACE: knees bending as if squatting; Lee 2018 for
  bent-knee work).
- Dumbbell Path: "one on each side ... straight down to about the knees" is
  the model (the intro said past the knees, which the model does not reach:
  its dumbbells stop at 0.54 m, about knee height; fixed in QA); straight down keeps the load over the front foot and the lever
  short (Gentilcore in ACE RDL); the model stops about knee height, where
  the front hip is at 93°. PureGym's keep them close to the working leg is
  not claimed: the model's dumbbells hang ~26 cm outside it. Label: Hang
  straight (was Weights close).
- Activation (no study): between the two-leg dumbbell RDL (library 0.84 /
  0.70 / erector 0.52) and the dumbbell SL RDL (0.86 / 0.84 / 0.74 / 0.50).
  Hamstrings first (0.84) as both; GMAX 0.76, above the two-leg RDL's for the
  front leg's larger share (Diamant 2021 on one leg). GMED 0.60, an estimate
  between a two-leg lift (Diamant's conventional deadlift drew 59.3 against
  the single-leg 77.6 %, about 0.57 on this scale) and the single-leg 0.74,
  nearer the two-leg end since the kickstand takes the side-to-side balance
  (raised from 0.48, which sat under the dim erector). Erector 0.50 as the
  single-leg lifts, secondary as painted.
- Setup: the model's stance, then switch feet.

Layout (closer framing; the head reaches v 0.13 at the top, the dumbbells
sweep u 0.33-0.76 v 0.44-0.67, glutes to u 0.86 at the bottom, the back heel
u 0.72-0.75 v 0.76-0.80): back top left, hinge second row right, the short
dumbbell label left at 0.48 (ends u 0.288, clear of the dumbbells at 0.33),
front-foot label bottom left, Kickstand bottom right. Checked on all stills.
The dumbbell label points at the right hand (u 0.46): at the top the left
hand hangs on the hip dot and its leader crossed Hips back's (QA).

## Smith Machine Romanian Deadlift (360)

Model: vertical Smith (the builder's model after the Hammer Strength HSSMV),
carriage on two upright rails, hooks, orange safety stops low on the machine
(collars and cushions 0.20-0.28 m). Feet flat, ankles 0.28 m apart, toes
forward; knees 162° top, 150° bottom; trunk 0° to 70°, hips 165° to 79°,
pelvis 15 cm back. The bar stays 10 cm ahead of the ankles (over mid-foot,
the toe tips ~20 cm ahead) and runs straight down from 0.86 m to 0.46 m
(knee height); overhand, hands 0.56 m apart.

- Foot Position: bar just below hip height, feet hip-width, toes forward,
  bar close (REP Fitness); the fixed track means stance sets the load's place
  (mechanics); the model's bar over mid-foot.
- Hip Hinge: RDL among the highest hamstring activity (McAllister 2014);
  "the track does the balancing": REP Fitness (Flicker, less demand on
  balance or coordination); the mistake of bending the knees as in a squat:
  ACE. Correct: its own line (the bar slides down its track), not the
  library's closing-a-door image.
- Range of Motion: stop when the hips stop travelling back (ACE: until
  tension behind the thighs, about knee height or mid-shin). "Standing on a
  step for extra range raised glute and inner-hamstring activity in
  bodybuilders who kept the spine straight" = Coratella 2022 (step-RDL:
  gluteus maximus and semitendinosus, ascending phase; biceps femoris no
  different; 10 competitive bodybuilders, 80% 1RM, spine straight); "so
  extra range helps as a longer hinge, not as rounding" is the inference
  (no rounded condition was tested). "Set the safety stops just below that
  point" and setup step 1 (below the lowest point of your rep): our own
  advice so a missed rep lands on the stops; REP Fitness sets them all the
  way at the bottom, which is also below the rep, and the model's stops sit
  low, well under the bar's lowest point.
- Knee Angle: the hamstrings cross the knee (anatomy), so locked knees put
  them on stretch sooner and the hips run out of hinge earlier; a soft bend
  lets the hips travel further back (ACE slight bend; mechanics). The old
  claim that a soft bend loads the hamstrings through a longer range is
  gone: it lengthens the hip's travel, not necessarily the stretch.
- Comparison: STANDING TOO FAR BACK, the Smith's own fault (the library
  Romanian Deadlift already has TURNS INTO A SQUAT). Bar far from the body =
  longer lever on the lower back: Gentilcore in ACE RDL.
- Activation (no study): the free-weight RDL's ranks (library 0.88 / 0.72 /
  0.42) a step lower, 0.84 / 0.68 / 0.38: the free-weight squat drew 26 %
  more biceps femoris than the Smith squat (Schwanbeck 2009, n=6, a squat,
  used only for direction) and the track takes the balance (REP Fitness).
  StrengthLog lists hamstrings, glutes and lower back as primary; the model
  paints the erector dim, so it is secondary here.
- Setup: REP Fitness (bar just below hip height, feet hip-width, bar over the
  feet, overhand just outside the thighs); twisting the bar off the hooks is
  how a Smith unlocks.

Layout: the plates sweep both frame edges v 0.40-0.75 and the head's arc runs
from (0.65, 0.18) to (0.33, 0.39); at the 2 s still the top of the head
reaches v 0.326 at u 0.27 and spans u 0.236-0.316 by v 0.334. So Flat back
top left, Hips back top right (over the static right rail), the range label
alone on the second row left, shortened to To knees (ends u 0.215; Bar to
knees there ended at 0.274 and clipped the head at the bottom), feet bottom
left, knees bottom right beside the static orange low stop. QA of the
simulator stills (2026-10-01): with Bar to knees top left and Flat back
below it, the back leader to the chest crossed the range leader to the
right hand at every moment, so the two swapped rows again and the range
label was shortened to fit under the head. In the range fault's turned
view (total -1.2) the head's chin just meets the pill's rounded top-right
corner (u 0.20-0.215, v 0.30-0.315).

## Cable Romanian Deadlift (361)

Model: facing a low-pulley stack; the lower pulley 0.18 m up, ~0.92 m ahead
of the ankles; straight bar on a swivel, overhand, hands 0.54 m apart,
elbows 158°. The cable draws the arms forward at the top (hands 25 cm ahead
of the shoulders, ~28° from vertical, the bar ~18 cm clear of the thighs);
at the bottom they hang about vertical. The hands from 0.97 m, 24 cm ahead
of the ankles, to 0.54 m (just above the knees), 30 cm ahead; cable ~41°
from vertical at the top, ~60° at the bottom; the stack drops 28 cm (centre
0.98 to 0.70 m) and never rests. Feet 0.28 m apart, knees 162° to 154°,
trunk 0° to 68°, hips 171° to 84°, pelvis 23 cm back.

- Distance: the model's geometry (the bar nears the pulley as you hinge, the
  stack sinks toward its rest at the bottom; the model stands ~0.9 m away).
  Not a cited source; the spec header says so. Mistake: standing too close
  to the pulley (the ghost stands ~0.56 m away, not over it).
- Hip Hinge (shared) plus "the cable pulls toward the machine as well as
  down": the model's cable angle. Correct: its own line (sit back against
  the cable's pull).
- Arms: the cable's forward pull grows as you hinge (the model's cable angle
  from 41° to 60°); lats holding the bar in (ACE: pull the bar into the body,
  Gentilcore); rounded shoulders load the upper back (mechanics). The copy
  no longer says the arms hang from the shoulders or that the bar is held
  just in front of the thighs: the model's arms are drawn ~28° forward at
  the top and the bar is ~18 cm clear of the thighs there.
- Knee Angle: as the Smith's, in other words; the mistake is the cable's own
  (knees locked at the bottom, where the model's cable is most nearly level,
  ~60° from vertical, and pulls hardest toward the machine).
- Lockout: leaning back past upright bends the lower back instead of
  finishing the hip (library Deadlift / Trap Bar lockout cues; mechanics).
- Activation (no study): a step under the free-weight RDL, 0.80 / 0.66 /
  0.36: stack loads are lighter and the pull is redirected; the one cable
  hinge studied (Dicus 2023, pull-through) drew less hamstring and erector
  activity than the RDL. Not cited in the copy.
- Setup: lowest pulley, straight bar, walk back ~1 m until the stack lifts
  (the model), stand tall, knees soft.

Layout: the machine base and low pulley fill the bottom-left corner and the
cable runs from the bar down to it, so nothing low on the left: lockout
(to the spine) top right and hinge (to the pelvis) second row right, that
way round since the spine dot sits above and left of the pelvis (the other
way round the two leaders crossed at every moment, found in QA), arms short on the left at 0.48 (ends u 0.230,
left of the bar), knee and distance on the right at 0.64 and 0.80.

## Kettlebell Romanian Deadlift (362)

Model: one kettlebell, both hands overhand on the handle (0.2 m apart),
elbows 156-159°, the bell centred between the legs in front: centre from
0.78 m (in front of the thighs) to 0.35 m (between mid-shin and knee),
23-27 cm ahead of the ankles all clip, over the toe tips; at the bottom the
shins are vertical and the bell's back face ~11 cm in front of them. The
arms angle ~30° forward at the top (hands 26 cm ahead of the shoulders) and
hang vertical at the bottom. Legs and trunk as the cable RDL. Slow, even,
no swing.

- Hip Hinge: "with one bell hanging in front of the legs, the hips travel
  back to counterbalance it" (mechanics). The old line, that the hips keep
  the bell over the middle of the feet, is gone: the model's bell hangs over
  the toes. Mistake: sinking the hips toward the bell with the chest rising
  (the ghost, hingeSquatted, turns the arms with the trunk, so the bell
  comes forward and up; the old words said it drops straight down).
- Tempo: an RDL starts standing, the bell never set down between reps (REP
  Fitness kettlebell guide); snapping the hips so the bell floats is a
  kettlebell swing, a ballistic lift (the swing is a different exercise;
  Zebis 2013 studied it separately).
- Bell Path: the closer the bell to the legs, the shorter the lever on the
  lower back (Gentilcore in ACE RDL); to about mid-shin (REP Fitness, ACE).
  Mistake: the bell swinging out away from the shins (the model's bell
  already hangs over the toes, so drifting toward the toes is not the
  fault).
- Knee Angle: as the Smith's, in other words; correct adds that a soft,
  fixed bend keeps the knees out of the bell's path.
- Activation (no study): the RDL's ranks a step lower for the lighter load
  one bell allows, 0.82 / 0.66; the RDL and the kettlebell swing both drew
  very high hamstring activity (Zebis 2013); the erector kept at the RDL's
  0.42 because the bell hangs 23-27 cm ahead of the ankles, further forward
  than the library RDL's bar over mid-foot, a longer lever for its weight
  (estimate).
- Setup: bell between the feet, squat down to pick it up, stand, arms long,
  knees soft (REP Fitness: start standing); at the top the bell hangs in
  front of the thighs, as the model.

Layout: back and hinge on the right (top rows), tempo and bell short on the
left at 0.48 and 0.72 (end u 0.303 and 0.244, left of the arms and bell;
the right forearm starts at u ~0.33 at 1 s), knee bottom right. The bell
label sat at 0.64 until QA: at the bottom both hands are at v 0.64 on the
handle, so its level leader ran through the tempo (right-hand) dot.

## Dumbbell Deadlift (393)

Model: a dumbbell in each hand at the sides, palms in, 0.68 m apart (outside
the feet), handles pointing forward. Stands tall at the top (knees 170°,
hips 174°), then hips and knees bend together: knees to 59-67° (59° at the
deepest, 2.5 s), hips to 40-48°, thighs about parallel, pelvis 0.91 to
0.44 m and 24 cm back, trunk 56° at most, knees over the feet (toes out
~7°). The dumbbells go straight down beside the feet to ~8 cm off the floor
(16 cm heads, centre 0.16 m), never touching it, then back up. This knee
bend and floor-to-hip range is what separates it from the library's
dumbbell RDL.

- Dumbbell Path: load at the sides, in line with hips and knees as in a trap
  bar; trap-bar studies found lower lumbar and hip moments, a higher knee
  moment (Swinton 2011) and more vastus lateralis (Camara 2016) than a
  straight bar. Lower until just above the floor: the model; PureGym (no need
  to touch the floor).
- Hips and Knees: a deadlift, not an RDL (the model's 59-67° knees); the
  dumbbells reach down near the floor (the model stops ~8 cm above it);
  bent-knee deadlifts drew more rectus femoris and gluteus maximus than the
  RDL (Lee 2018). Hips shooting up while the chest stays low leaves the back
  to finish (library Deadlift's hips-up fault; mechanics); the knees
  straighten early (the ghost opens them from ~65° to ~114°, not locked).
- Spine Position: flat back; no need to touch the floor if the spine would
  round (PureGym).
- Knee Tracking: knees over the toes (label Over toes, was Knees out, which
  the cue does not say; Knees over toes clipped the shoulder at the top); caving often shows the hips losing control
  of the thighs (Powers 2010, "often").
- Lockout: squeeze the glutes at lockout (PureGym); leaning back past upright
  only bends the lower back (library Deadlift lockout cue; mechanics). The
  unsourced clause that it does not work the hips harder is gone.
- Activation: as painted (hamstrings and glutes bright, erector dim), so the
  erector sits under both primaries. The library Deadlift (0.76 / 0.66 /
  erector 0.85) moved for the load at the sides, as with a hex bar: less
  biceps femoris and erector than a straight bar (Camara 2016), lower lumbar
  and hip moments (Swinton 2011), and dumbbells lighter than a barbell. GMAX
  0.74, hamstrings 0.56, erector 0.54 (was 0.60, above the hamstrings as in
  the library Deadlift and Trap Bar; both hex-bar studies and the paint
  point lower). No dumbbell-deadlift EMG was found: estimates. The
  quadriceps work hard at 59-67° knees but are not painted, so no row; the
  copy names the thighs' share.
- Setup: dumbbells beside the feet, hips back and knees bent to grip them
  palms in, chest up, stand up with them (PureGym).

Layout (the dumbbells sweep the middle of the frame v 0.46-0.90, the head
from (0.56, 0.18) to (0.37, 0.51)): back top left; the knee label short on
the left at 0.48 (ends u 0.230, left of the right arm and dumbbell at every
moment); Rise together (pelvis) top right and Stand tall (hip, thigh_L)
under it at 0.267, its pill starting 0.013 right of the left elbow at the
top (at 0.32 it touched it); At sides bottom right beside the near
dumbbell's lowest point (the pill starts u 0.785, the dumbbell ends ~0.74).
Rebuilt in QA (2026-10-01): with Rise together second row left and Over
toes second row right, the knee leader crossed Stand tall's and Rise
together's and the back leader crossed Rise together's through the whole
squat (1-3 s), where the chest, pelvis and hip dots line up on a diagonal
from the top left and the left knee swings to u 0.49.

## Fault ghosts (faults_400_rdl.swift.txt)

Every cue has a ghost; `rdl4` pieces are new, the rest shared. Views: the
single-leg lifts and the B-stance are side-on already (-1.3); the free hip
opening turns -1.3 (total -2.6, from behind on the left): the leg swings
across the line of sight, and at the old -0.8 its sideways swing and its
change in depth cancelled (the free foot moved 23 pt on screen, 25 pt
unturned, ~44 pt at -1.3). Smith and cable turn -0.2, kettlebell and
Dumbbell Deadlift -0.4 (total -1.2, as the library Dumbbell RDL); the
Dumbbell Deadlift's knees caving turns 0.6 (total -0.2, near face-on); the
B-stance's loaded kickstand turns -0.5 (total -1.8, see below).

Checked offline on 2026-10-01 with a Python copy of FaultGhost.solve on the
USD joints (SCRATCH/s400/rdl_review: ghost.py, mynew.py, my_all.png): every
ghost over the first rep, bone lengths and floor. No limb bone changes
length by more than ~1 cm except where a shared piece straightens a knee
(`rdl4KneesLocked` puts the knee on the hip-ankle line, so at the Smith's
150° knees each leg bone reads ~1.5 cm short) and the shared back rounding,
which moves the spine joint by design; no hand or foot dips through the
floor.

- Back (all seven lifts with a back cue, `rdl4BackRounded`): the Pendlay
  Row's deeper rounding (lower and middle back 0.10 torso lengths toward the
  ceiling, chest drawn 0.02 toward the hips, neck and head dropping toward
  the floor), replacing the shared `backRounded` after QA of the simulator
  stills (2026-10-01): its ~3-4 cm hump lay along the model's back as a flat
  line with only the head dropping, as the Pendlay row found. The Dumbbell
  Deadlift's sheet names the lower back, which this hump includes. Replayed
  offline (SCRATCH/s400/rdl_review ghost.py): the new ghost arches visibly
  over the real back at the bottom of each lift; it moves the spine joints
  by design, like the piece it replaces.
- Single-leg hinge (`rdl4ReachedDown`): the Stiff-Leg Deadlift's toe-touch
  (hips 7 cm forward over the foot, waist folding, head dropping) plus the
  free leg swinging 35° down about its hip (to ~53° below level; 45° put the
  toes ~7 cm through the floor).
- Single-leg knee (`rdl4StandingKneeSinks`): the body, load and free leg sink
  ~7 cm, the standing knee re-seated (160° to ~125°); the free foot carried,
  not re-seated.
- Single-leg square (`rdl4HipOpened`): pelvis and free leg turn 25° about the
  standing hip around the trunk axis (free hip ~7 cm toward the ceiling), the
  free leg 20° out to the side (foot ~25 cm out, toes turned out). With a
  load in each hand (`withArm`, barbell and dumbbell versions) the whole
  right arm, shoulder to palm, rises ~6 cm, so that side's dumbbell rides
  higher or the bar tips; moving the shoulder too keeps the upper arm its
  length (moving only the forearm and hand shrank it 29 to 24 cm). The
  trunk is not turned: rotating it swung the hanging arms sideways (the
  Pendlay row's lesson).
- Single-leg balance (`rdl4StandingHeelUp`): left heel up 22° about the toes,
  knee re-seated, arms drifting 12° forward.
- B-stance front (`rdl4KickstandLoaded`): kickstand heel down 30° (pitch 56°
  to 26°, the ankle ~9 cm lower), hips 3.5 cm back and 2.4 cm down, knees
  re-seated: the back knee opens (113° to ~131°) and the front knee stays
  soft (162° to ~154°). Moved back only, the front knee snapped straight
  (180°) and read as the locked-knee fault. Stance (`rdl4KickstandFarBack`):
  back foot 20 cm further back. The loaded-kickstand ghost turns -0.5
  (total -1.8, ~13° behind side-on) since QA: at the trainer's -1.3, ~16° in
  front of side-on, the kickstand's 29 cm to the side cancels most of its
  20 cm back on screen (~11 cm apart), and on the simulator still the
  ghost's back leg lay over the front one, the heel drop hard to read; from
  just behind they sit ~26 cm apart (offline replay). The far-back stance
  ghost already reads at -1.3 and is not turned.
- Smith hinge: `hingeKneesBending(withBar: true)`: hips sink ~7 cm, knees
  150° to ~122°, the bar straight down its track. The shared
  `hingeSquatted` swung the arms with the rising trunk and put the bar ~20
  cm off the rails.
- Smith range (`rdl4ChasedFloor`): the Romanian Deadlift's range fault.
- Smith stance (`rdl4StoodBackFromBar`): the body, feet and shoulders ~9 cm
  further back, the hands on the bar and the elbows re-seated (as the Smith
  Machine Upright Row's stance fault), growing with the hip bend so the
  arms never over-reach at the top; at the bottom the bar sits over the
  ghost's toe tips. `barDrifting` moved the bar 8 cm off the rails.
- Two-leg knees (`rdl4KneesLocked`): straightened, faded by the hip's bend.
- Cable arms (`rdl4ArmsDragged`): shoulders 5 cm out of the chest and the
  arms 28° further forward (~31° from vertical at the bottom, past the ~28°
  the cable draws the model's arms to at the top), the bar ~30 cm nearer
  the machine. Cable stance (`rdl4CloserToPulley`): the whole lifter drawn
  0.6 torso lengths (~34 cm) nearer the machine.
- Kettlebell hinge: the shared `hingeSquatted`; the arms turn with the
  rising trunk, so the bell comes ~17 cm forward and ~7 cm up, as the
  reworded mistake allows.
- Kettlebell tempo: `armsSwungForward(60)` at the top, strength when the
  hips are straight; the hip reads only ~0.62 straight at this model's top,
  so ~37° shows: the hands rise ~25 cm, the bell out to about waist height.
- Dumbbell Deadlift hips (`rdl4HipsShotUp`): the pelvis, hips and lower
  trunk turn 25° up about the neck (hips ~24 cm up and ~10 cm back, trunk
  56° to ~81°, knees re-seated 65° to ~114°), the head and hands still. The
  shared `hipsShotUp` straightened the knees onto the hip-ankle line under
  a pelvis raised only 8 cm, shrinking both leg bones by ~40%.
- Moments: bottom for every fault of the hinge, and now for the Smith
  stance (it grows with the hip bend); lockout for the cable and Dumbbell
  Deadlift lockout; top for the kettlebell tempo; any (the bottom) for the
  B-stance stance fault, which holds all rep.
- `check_faults_400.py`: BUILD SUCCEEDED with all four families pasted
  (2026-10-01, after this revision). The ghosts have not been shot on the
  simulator; the offline replay above stands in for that.
- QA of the simulator stills (2026-10-01): every ghost shows its mistake in
  the right direction; the back ghosts were deepened and the loaded
  kickstand turned (above). Not fixable here: at the top (Cable and
  Dumbbell Deadlift lockout, Kettlebell tempo) the fault view lifts the
  standing model so its head sits under the COMMON MISTAKE banner (the
  fault view's framing, not a ghost or moment choice: the lockout and swing
  faults belong to the top). After integrate_400.py pasted the families
  into FaultPoses.swift, `check_faults_400.py` as it stands pastes them a
  second time and fails on redeclarations; with the integrated 351-400
  block stripped first (a scratch copy of the script) the four families
  built (BUILD SUCCEEDED, 2026-10-01, after the QA fixes).
