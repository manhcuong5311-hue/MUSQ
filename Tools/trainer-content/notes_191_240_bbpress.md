# Batch 191-240: barbell, Smith and landmine presses (2026-09-26)

Content in `spec_191_240_bbpress.py`, ghosts in
`Tools/fault-review/faults_191_240_bbpress.swift.txt`. Eight exercises: Seated
Barbell Overhead Press, Behind-the-Neck Press, Push Press, Z Press, Smith
Machine Shoulder Press, Landmine Shoulder Press, Half-Kneeling Landmine Press,
Viking Press.

Checks run: `python3 spec_191_240_bbpress.py` prints OK; the gen.py dry run
renders all eight; the fault fragment was spliced into a scratch copy of
`FaultPoses.swift` and compiled with `swiftc`, every cue id resolves, and the
app's own `FaultGhost.solve` was run on rig poses exported at the bottom, the
top and (push press) the bottom of the dip to confirm each ghost moves the way
its mistake says. All model facts below come from the rig (joint angles and
positions sampled across each clip) and the framing screenshots; after the
review (see Revision at the end) the bar and handle heights were also measured
against the skinned body (head, neck, trapezius, front deltoid and clavicular
pec meshes) and the equipment meshes.

## Sources

| Key | Reference | Used for |
| --- | --- | --- |
| Saeterbakken 2013 | Saeterbakken AH, Fimland MS. J Strength Cond Res 2013;27(7):1824-1831. doi:10.1519/JSC.0b013e318276b873 | Seated vs standing barbell press: medial deltoid ~7% lower seated (trend), posterior deltoid ~25% lower seated; barbell raises triceps activity vs dumbbells |
| Saeterbakken 2012 | Saeterbakken AH, Fimland MS. Eur J Appl Physiol 2012;112(5):1671-1678. doi:10.1007/s00421-011-2141-7 | External oblique activity ~68-81% lower in two-arm than one-arm presses; core activity higher standing than seated |
| Campos 2020 | Campos YAC et al. J Hum Kinet 2020;75:5-14. doi:10.2478/hukin-2020-0033 | Seated barbell shoulder press with the back on a 90° bench: anterior 33.3%, medial 27.9%, posterior 11.4% MVIC (so anterior > medial >> posterior) |
| Paoli 2010 | Paoli A, Marcolin G, Petrone N. J Strength Cond Res 2010;24(6):1578-1583. doi:10.1519/JSC.0b013e3181d756ea | Sitting military press: reps finished at full elbow extension (180°) drew more EMG than reps stopped at 90° or 135° in the deltoids, triceps and upper trapezius. Its partial reps were cut at the top, so it is cited only for pressing to straight arms |
| Coratella 2022 | Coratella G, Tornatore G, Longo S, Esposito F, Cè E. Front Physiol 2022;13:825880. doi:10.3389/fphys.2022.825880 | Seated front vs back barbell press and machine press: back press more medial and posterior deltoid, front press more pectoralis; barbell more deltoid than machine; back press bar lowered to below the external occipital protuberance; grip set for 90° elbow with the upper arm at 90° |
| Padovan 2026 | Padovan R et al. J Hum Kinet 2026;103:81-96. doi:10.5114/jhk/205466 | HD-EMG front vs back press: front more anterior deltoid and pectoralis in both phases; back more posterior deltoid, upper trapezius and triceps only while lowering; no lateral deltoid amplitude difference |
| Kebaetse 1999 | Kebaetse M, McClure P, Pratt NA. Arch Phys Med Rehabil 1999;80(8):945-950. doi:10.1016/S0003-9993(99)90088-6 | Slouched sitting: ~24° less active shoulder abduction, less scapular posterior tilt near full elevation, less abduction force (behind-the-neck head cue) |
| McKean 2015 | McKean MR, Burkett BJ. J Sport Health Sci 2015;4(3):250-257. doi:10.1016/j.jshs.2013.11.007 | Behind-the-head press starts with less thoracic extension (more kyphotic); male lifters exceeded passive external rotation; safe for lifters with normal trunk stability and full shoulder range |
| Kolber 2013 | Kolber MJ, Corrao M, Hanney WJ. J Strength Cond Res 2013;27(5):1333-1339. doi:10.1519/JSC.0b013e318269f776 | High-five position exercises (behind-the-neck pulldown and military press) associated with clinical signs of anterior shoulder instability |
| Gundersen 2026 | Gundersen AH, Krosshaug T, Mausehund L, van den Tillaar R, Larsen S. Sports Biomech 2026;25(6):841-854. doi:10.1080/14763141.2025.2590028 | Seated barbell press grip width: narrower grips lift more, with more shoulder and elbow range; wider grips reduce elbow moments, narrower ones shoulder moments |
| Soriano 2019 | Soriano MA, Suchomel TJ, Comfort P. Sports Med 2019;49(6):867-885. doi:10.1007/s40279-019-01096-8 | Push press = dip then drive by triple extension, forces passed through the trunk; a strictly vertical dip is described as a key difference in jerk performance |
| Lake 2014 | Lake JP, Mundy PD, Comfort P. J Strength Cond Res 2014;28(9):2552-2559. doi:10.1519/JSC.0000000000000438 | Push press power comparable with the jump squat (the legs do real work) |
| Catalyst | Everett G. Push Press. Catalyst Athletics exercise library, https://www.catalystathletics.com/exercise/87/Push-Press/ | Push press dip by bending the knees with the trunk vertical, about 10% of height, full foot on the floor; the arms press as the legs finish; the heels rise at least slightly with a full leg drive; starts from the jerk rack on the shoulders |
| NSCA Kinetic Select | NSCA Kinetic Select: Push Jerk. https://www.nsca.com/education/articles/kinetic-select/push-jerk/ (read through the search index; the page itself returns 403 to the fetcher) | The same dip as the push press: no deeper than a quarter squat, torso erect, bar straight down, the hips not moving back but staying under the shoulders (the dip cue). Its weight over the middle of the feet is stated for the catch, not the dip, so it is not cited for the heels cue |
| Botton 2013 | Botton CE, Wilhelm EN, Ughini CC, Pinto RS, Lima CS. Medicina Sportiva 2013;17(2):67-71. doi:10.5604/17342260.1055261 | Smith machine shoulder press at 10RM: anterior deltoid ~70% MVIC, more than the other lifts tested bar the bench press (~55%) and pec deck (~50%); medial deltoid highest in lateral raises (~55%), reverse pec deck and seated rows, not the Smith press |
| Schick 2010 | Schick EE et al. J Strength Cond Res 2010;24(3):779-784. doi:10.1519/JSC.0b013e3181cc2237 | Smith vs free-weight bench press: less medial deltoid on the Smith machine |
| Rodríguez-Ridao 2020 | Rodríguez-Ridao D et al. Int J Environ Res Public Health 2020;17(19):7339. doi:10.3390/ijerph17197339 | Anterior deltoid highest at 60° press angles and higher beyond 45°; upper pectoralis peaks at 30° |
| NSCA Basics | Sands WA, Wurth JJ, Hewit JK. NSCA Basics of Strength and Conditioning Manual. NSCA, 2012 | Behind-the-neck press: starts with the bar across the shoulders and is lowered back there; elbows under the hands, bar just behind the ears at lockout in line with shoulders, hips and heels, core engaged against arching. Push press: starts with the bar across the back of the shoulders (the front of the shoulders allowed) and the weight centred on the feet (the setup's mid-foot); no pause in the dip, core engaged (its dip lets the torso come forward with the weight on the heels, which the copy does not follow) |
| Wellman 2023 | Wellman A. Complete Conditioning for Football. Champaign, IL: Human Kinetics, 2023 (foreword by T. Allen; published excerpt: half-kneeling landmine one-arm press) | Knee down on the pressing side, braced neutral spine, press straight out and not across the body; the landmine press as a middle ground between horizontal and vertical pressing |
| Cressey | Cressey E. Strength Exercise of the Week: Half-Kneeling 1-arm Landmine Press. EricCressey.com | A slight stretch on the trailing leg's hip flexors with the glutes on that side switched on; brace against extension and rotation; press straight out, not across the body |
| StrengthLog | StrengthLog exercise guides: overhead press, push press, behind the neck press, Z press, landmine press | Muscles worked (primary front deltoid in all; secondary lists) and step lists. The behind the neck press is lowered to the base of the neck; the landmine press is done standing with the feet about shoulder-width or kneeling |

Not used although searched: no EMG or kinetics study was found for the Z
press, the landmine shoulder press, the half-kneeling landmine press or the
Viking press (Botton 2013 covers the Smith machine shoulder press). ExRx and the NSCA Exercise
Technique Manual (4th ed., 2022, which lists the seated barbell shoulder press,
push press and landmine shoulder press) could not be read, so nothing is
attributed to them. Durall et al. 2001 (Strength Cond J 23(5):10-18) is a
scanned PDF whose text could not be checked, so it is not cited.

## Seated Barbell Overhead Press

Model: seated upright near the front of a bench, trunk vertical and ~0.12 m
clear of the short back pad (the copy never tells the lifter to lean on a
pad), knees ~120°, feet flat ~0.42 m apart. Overhand grip ~0.76 m, hands about
a hand's width outside the shoulders. Bar lowered in front of the face to chin
height (elbows 55°, hands 5 cm above the shoulder joints), pressed to 162° over
the top of the head. Head still.

Claims:
- Anterior deltoid primary, lateral deltoid next: in Campos 2020, a seated
  barbell press with the back on the bench, medial deltoid reached ~0.84 of
  the anterior deltoid's %MVIC; the lateral row is kept a little under that
  (0.66, MODERATE) because MVIC ratios between muscles are imprecise and the
  medial deltoid's drop when seated is only a trend (Saeterbakken 2013,
  p = 0.062). (Pass 1 derived 0.66 by taking the seated drop off Campos's
  ratio, which counted sitting twice: Campos was already seated.) Lateral
  kept as a primary with a MODERATE fraction to match the library's ANT. +
  LAT. DELTOID.
- Triceps moderate (0.52): barbell raises triceps vs dumbbells, seated ~20%
  lower than standing (trend) (Saeterbakken 2013); the standing Barbell
  Overhead Press entry has 0.58.
- Upper trapezius low (0.34): measured and active in the sitting military
  press, rising with range (Paoli 2010), no difference front vs back
  (Coratella 2022). No percentage source; the value is a conservative rank
  below the triceps.
- Pressing to straight arms draws more activity than stopping short (Paoli
  2010: reps finished at 180° drew more deltoid and triceps EMG than reps
  stopped at 90° or 135°). Paoli cut its partial reps at the top, so it is
  cited only for pressing to straight arms; the lowering depth (at least
  chin height) follows the model and makes no EMG claim. StrengthLog's Z
  press and NSCA Basics lower further, to the shoulders, so the copy says
  at least chin height rather than calling the chin the whole range.
- The depth mistake says nose height: `barHeldHigh` lifts the bar ~9 cm,
  from the chin (+0.14 m over the shoulder joints) to about the nose
  (+0.23 m); the forehead (~+0.30 m) would need a bigger lift.
- Grip width trade-off (Gundersen 2026, a seated barbell press study).
- Leaning back turns the press into a steep incline press: geometry (the bar
  still goes straight up, so a trunk tipped back ~12° presses as if from a
  ~78° incline bench); Rodríguez-Ridao 2020 shows the press angle shifts work between the
  anterior deltoid and upper pectoralis, but only up to 60°. Same claim as
  the existing Barbell Overhead Press copy.
- Lockout wording: the model's elbows stop at ~162° (hands 0.50 m over the
  shoulders), so the correct text says press back up to arms' length over
  the head rather than insisting on straight arms; the why keeps Paoli
  2010's full elbow extension as the reason to finish the rep. The same
  wording is used for the Z press (same arm motion) and the push press
  lockout.

Faults (framed at yaw -0.8; moment for the stills):
- torso (`leanedBack(12, arch: 0.08)` with the bar: the trunk, arms and bar
  tipped back 12° about the pelvis, the spine 0.08 torso lengths and the
  chest 0.036 forward; any; `.seen(-0.6)`, total -1.4): lockout, 1.33 s.
- barpath (`armsTurned(.lateral, -18)` with the bar: the arms swung 18°
  forward about the shoulders, locked out in front of the head;
  `.whenStraight`; `.seen(-0.6)`): lockout, 1.33 s.
- grip (`wristBentBack` with the bar: the hand tips turned 48° back about the
  side-to-side axis; any; no turn): bottom, 0.08 s.
- depth (`barHeldHigh` with the bar: hands and bar 0.16 torso lengths up,
  elbows re-seated; with the elbow bend; no turn): bottom, 0.08 s.
- feet (`feetTucked`: the feet 0.16 torso lengths back toward the seat and
  rocked 25° onto the toes, knees re-seated; any; `.seen(-0.6)`): 0.08 s.

## Behind-the-Neck Press

Model: standing, feet ~0.30 m apart, knees straight. Grip ~0.72 m. Bar lowered
behind the head to just below the base of the skull: the bar centre sits ~9 cm
above the shoulder joints (hands ~3 cm), level with the chin, against the back
of the upper traps and neck, 2-3 cm below where the skull starts and ~10 cm
below ear level. Elbows 37° and ~22 cm below the shoulder joints (upper arms
~41° from hanging), forearms vertical from the side, upper arms just behind
the frontal plane; the head is held ~5 cm forward of the neck all clip; full
lockout (180°) with the bar just behind the head.

Claims:
- Anterior 0.80, lateral 0.76 (both HIGH), posterior 0.38: the back press
  raises medial and posterior deltoid over the front press (Coratella 2022,
  large effects) and lowers anterior deltoid (Padovan 2026); standing adds
  posterior deltoid over seated (Saeterbakken 2013). Compared with the
  existing standing Barbell Overhead Press (0.86 / 0.74): anterior a little
  lower, lateral a little higher. The lateral evidence is mixed: Coratella
  2022 found much higher medial deltoid in the back press (8 bodybuilders,
  seated with lumbar support), Padovan 2026 no amplitude difference (its
  back-press increases in posterior deltoid, upper trapezius and triceps
  were in the lowering phase only), so the lateral row is only a small bump
  over the front press. Triceps 0.54: the two studies disagree on front vs
  back, so it stays moderate.
- Depth is individual. The model stops at about the base of the skull,
  which is Coratella 2022's start (the bar below the external occipital
  protuberance), a lower bound rather than a stop; NSCA Basics lowers the
  bar across the shoulders and StrengthLog to the base of the neck. So the
  copy does not call the standard range a fault: the mistake is forcing the
  bar lower than your own shoulders allow. McKean 2015 found
  behind-the-head pressing safe for lifters with normal trunk stability and
  full shoulder range; male lifters exceeded their passive external
  rotation, and the authors advise building passive range first (the why
  sentence). Kolber 2013 found an association between doing high-five
  exercises (behind-the-neck pulldown and press) and clinical signs of
  anterior instability; it did not study depth and cannot show cause (the
  comparison's mistake note says associated). Lowering further drops the
  elbows (less abduction) and takes the bar back, so the shoulders turn
  further out; the pass-1 comparison's full abduction was wrong and is gone. The
  setup takes the bar from the rack on the upper traps, as NSCA Basics does.
- Upright upper back for the head cue: Kebaetse 1999 measured ~24° less
  active shoulder abduction and less scapular posterior tilt near full
  elevation when slouched (seated, unloaded); McKean 2015 found the
  behind-the-head technique starts with less thoracic extension. That
  slouching makes getting the bar behind the head harder on the shoulder is
  an inference from these, not a measured press result.
- Forearms vertical, grip wide enough: Coratella 2022's grip rule and NSCA
  Basics (elbows under the hands). That a narrow grip adds rotation is
  geometric reasoning; Gundersen 2026 only shows narrower grips increase
  shoulder range in the front press.
- Lockout just behind the ears over shoulders, hips and heels; no arching:
  NSCA Basics.

Faults (framed at yaw -0.8):
- grip (inline narrow grip: hands and bar 0.2 torso lengths (~12 cm) further
  in each side, elbows 0.04, so the forearms slant in; any; view 0.5, total
  -0.3): bottom, 3.83 s.
- depth (bar forced further down the back of the neck: hands and bar 0.14
  torso lengths (~8 cm) lower and 0.06 (~3.5 cm) further back, elbows
  re-seated; with the elbow bend; view -1.5, total -2.3, from behind-left):
  bottom, 3.83 s. With bone lengths kept, the elbows also come slightly
  forward and in.
- head (`headDropped`: chest 0.06 torso lengths back, neck 0.06 and head 0.18
  forward; with the elbow bend; `.seen(-0.6)`, total -1.4): bottom, 3.83 s.
- brace (`leanedBack(10, arch: 0.08)` with the bar; any; `.seen(-0.6)`):
  top, 2.0 s.
- lockout (`armsTurned(.lateral, -25)` with the bar: 25° forward, the bar
  ~19 cm ahead of the shoulders, in front of the face; `.whenStraight`;
  `.seen(-0.6)`): lockout, 2.0 s.

## Push Press

Model: standing, feet ~0.34 m apart, knees soft (~157°) when upright. Same arm
motion and grip as the seated press: the bar is held in front of the chin, at
chin height and ~17 cm in front of the shoulder joints (~12 cm in front of the
front deltoids), with the elbows ~8 cm behind it. It is never racked on the
shoulders, and the arms stay still through the dip. Each rep dips ~8 cm (knees
to ~125°, trunk vertical), drives, and the arms press while the legs finish
(elbows 104° as the knees reach 149°); the bar is lowered with the legs still.
No re-dip, so it is a push press, not a jerk.

Claims:
- Activation: no EMG study of the push press was found. Ranked from
  StrengthLog's list (front deltoid primary; triceps, lateral deltoid, quads,
  glutes, traps secondary) with the legs' real share shown by Lake 2014 (power
  comparable with the jump squat). Anterior 0.80, triceps 0.58, lateral 0.56,
  quadriceps 0.44 are ranks, not measurements.
- Dip straight down, trunk vertical, hips under the shoulders: Catalyst
  (bend at the knees with the trunk vertical, to about 10% of height) and
  NSCA Kinetic Select's push jerk dip (torso erect, bar straight down, the
  hips not moving back but staying under the shoulders, no deeper than a
  quarter squat), with Soriano 2019 as jerk-literature support (a strictly
  vertical dip separates master from novice jerkers). NSCA Basics' push
  press dip lets the torso come forward with the hips back and the weight on
  the heels; the model and the copy keep the trunk vertical, so NSCA Basics
  is cited only for no pause in the dip.
- Whole foot down, heels down in the dip: Catalyst (full foot in contact
  with the floor, the weight a little toward the heels, balance kept through
  the dip). The setup's weight over mid-foot is NSCA Basics' start position
  (weight centred on the feet); NSCA Kinetic Select's middle of the feet is
  stated for the catch, so it is not cited here, and pass 2 took mid-foot
  out of the dip and heels cues. The model's heels never leave the floor,
  even in the drive; Catalyst says a full drive lifts them at least
  slightly, so the correct text allows it only as the legs finish (if they
  rise at all) and claims nothing the model contradicts.
- Legs first, then the arms (the Start Position cue, label Arms still in the
  dip): StrengthLog and Catalyst (the arms press once the legs have
  extended). StrengthLog and Catalyst start the push press from a rack on
  the front of the shoulders, NSCA Basics from across the back of the
  shoulders (the front allowed), and Soriano 2019 lists it from the chest
  and from behind the neck; none holds the bar off the shoulders. This model
  starts with the bar in front of the chin, so the copy and setup describe
  the model's start, and the why sentence adds that most lifters start from
  the shoulders and the same rule applies. It does not present the
  chin-height hold as the usual start.
- Trunk passes the leg drive into the bar: Soriano 2019.

Faults (framed at yaw -0.8; the dip faults read the pelvis-to-left-ankle
distance, `pushPressDip`: none at 1.40 torso lengths, all of it at 1.30, so
they show only in the dip):
- rack (arms pressing early, the bar rising before the legs drive,
  `barHeldHigh` with the bar: hands and bar 0.16 torso lengths up, elbows
  re-seated; `pushPressDip`; no turn): bottom of the dip, 0.50 s. Not the
  elbow-most-bent moment: the exercise's default still is 3.33 s, where the
  lifter stands tall and these faults are zero, so rack, dip and heels are
  shot at 0.50 s.
- dip (`leanedForward(16)` with the bar: trunk, arms and bar tipped 16°
  forward about the pelvis; `pushPressDip`; `.seen(-0.6)`, total -1.4):
  0.50 s.
- heels (heels up in the dip, `heelsUp`'s moves: each foot turned 24° up
  about the toes, knees re-seated; `pushPressDip` rather than `.withBend`,
  because the knees stay soft at ~157° standing; view -0.6): 0.50 s.
- lockout (`armsTurned(.lateral, -18)` with the bar, locked out in front of
  the face; `.whenStraight`; `.seen(-0.6)`): lockout, 1.42 s.
- brace (`leanedBack(12, arch: 0.08)` with the bar; any; `.seen(-0.6)`):
  lockout, 1.42 s.

## Z Press

Model: sitting on a floor mat, legs straight (~171°) and ~0.40 m apart, trunk
vertical (hip ~97°), no back support. Arm motion identical to the seated
press. Framed side-on (yaw -1.3), facing screen left.

Claims:
- No EMG study found. Deltoid and triceps rows copied from the seated barbell
  press (same arm motion; StrengthLog lists front delt primary, lateral delt,
  triceps, chest and traps secondary). Erector spinae low (0.32) is an
  inference: with no back support the trunk extensors hold the torso upright
  over the hips; no measurement supports a number, so it is kept low.
- Sitting tall, no lean back, bar stacked over the hips: mechanics of an
  unsupported seated trunk; not a studied claim.

Faults (framed side-on at yaw -1.3):
- torso (inline slump, a deeper `backRounded`: spine 0.10 torso lengths back,
  chest 0.05 back and 0.05 down, neck 0.06 forward and 0.07 down, head 0.15
  forward and 0.09 down; any; no turn): 1.33 s.
- brace (`leanedBack(12, arch: 0.06)` with the bar; any; no turn): top,
  1.33 s.
- barpath (`armsTurned(.lateral, -18)` with the bar, locked out in front;
  `.whenStraight`; no turn): lockout, 1.33 s.
- grip (`wristBentBack` with the bar, 48°; any; no turn): bottom, 0.08 s.
- depth (`barHeldHigh` with the bar, 0.16 torso lengths up; with the elbow
  bend; `.seen(0.5)`, total -0.8, toward front three-quarter, since side-on
  the near plate hides the face and the real bar): bottom, 0.08 s.
Only depth turns: the framing is already side-on.

## Smith Machine Shoulder Press

Model: adjustable bench with the back pad ~10° off vertical, back on the pad,
knees ~112°, feet flat ~0.38 m apart. Grip ~0.58 m (just outside the
shoulders). The bar runs straight up and down ~0.15 m in front of the shoulder
joints (~7 cm in front of the nose), from the collarbones (bar centre ~5 cm
above the shoulder joints and ~10 cm below the chin, just above the top of the
clavicular pec; elbows 36°, ~5 cm behind the bar) to 178°.

Claims:
- Anterior deltoid primary (0.82) and lateral deltoid lower (0.60): Botton
  2013 measured ~70% MVIC anterior deltoid in the Smith machine shoulder
  press at 10RM, more than the other lifts tested bar the bench press and
  pec deck, with medial deltoid highest in lateral raises, reverse pec deck
  and seated rows rather than the Smith press. Guided presses also cut
  medial deltoid in the bench press (Schick 2010), and machine presses drew
  less medial and posterior deltoid than the barbell (Coratella 2022).
  Upper pectoralis low (0.28): front presses bring the pectoralis in more
  than back presses (Coratella 2022, Padovan 2026). Rows unchanged in pass 2.
- Bench position decides where the bar meets the body: follows from the fixed
  vertical path; not a studied claim. Label Bench under bar (15 characters,
  pill to x 0.318) so it clears the right forearm at mid-rep (u 0.34,
  v 0.35), which the pass-1 label Bar clears the face covered.
- Pressing to straight arms (Paoli 2010, full elbow extension; see the
  seated press) from the collarbones, which is where this model stops (its
  own depth tuple, `DEPTH_SMITH`; the free-bar seated and Z presses stop at
  the chin). Back on the pad (same logic as the existing Machine Shoulder
  Press). The pad is ~10° off vertical, so the bench cue and setup say just
  short of upright.
- Elbow why: elbows flared out and back behind the bar push it at an angle
  and turn the shoulders further out at the bottom (mechanics of the
  position shown; pass 1 said twist, which is not a defined movement). NSCA
  Basics' matching cue is elbows directly under the hands.

Faults (framed at yaw -0.6):
- bench (body set back from the fixed bar: pelvis, hips, trunk and shoulders
  0.22 torso lengths (~13 cm) back, level with the floor, the hands left on
  the bar and the elbows re-seated, so the upper arms angle forward to it;
  legs not drawn; with the elbow bend; view -0.8, total -1.4): 1.0 s.
- back (`lowerBackArched(0.12)`: spine 0.12 torso lengths and chest 0.054
  forward; any; `.seen(-0.8)`): 3.67 s.
- elbow (flared out and back: elbows 0.25 torso lengths out and 0.1 back,
  re-seated; with the elbow bend; view 0.4, total -0.2, near face-on):
  bottom, 3.67 s.
- depth (`barHeldHigh` with the bar: 0.16 torso lengths, ~9 cm, puts the bar
  at chin height, the short rep the copy describes; with the elbow bend; no
  turn): bottom, 3.67 s.
- feet (`feetTucked`; any; `.seen(-0.8)`): 3.67 s.

## Landmine Shoulder Press

Model: LEFT hand on the bar end; split stance with the RIGHT foot forward
(opposite the pressing arm; ankles ~0.29 m ahead of and ~0.31 m behind the
hips), front knee straight (~175°), back knee ~150°, back heel slightly up,
trunk ~4° forward; right hand on the right hip. The bar end starts at the
front of the shoulder (hand 6 cm below the shoulder joint, elbow 20°); the
elbow points down close to the side, 0.26 m below, 0.12 m out from and level
front to back with the shoulder joint (~25° out, no forward raise), so the
copy says close to the ribs, not in front of them. It finishes up and forward
(hand 0.32 m above and 0.43 m ahead of the shoulder, elbow ~166°).

Compared with the chest Single-Arm Landmine Press model (same rig, checked
with motion.py): that one starts at chest height (hand 0.18 m below the
shoulder, elbow ~40°), finishes a little lower and further forward (upper arm
~119° vs ~130° here), stands with the pressing-side foot forward and hangs the
free arm straight. The paths are otherwise close (both ~45-50° above
horizontal). That is why this entry ranks the front deltoid first and the
upper chest second, while the chest entry does the reverse: the difference is
real but small, and the copy says the arc sits between a bench press and an
overhead press for both.

Claims:
- Anterior deltoid primary (0.80), upper pectoralis and triceps moderate
  (0.50): StrengthLog lists front deltoid primary with triceps and chest
  secondary; at steep (≥45°) press angles the anterior deltoid is highest
  while the upper pectoralis falls from its 30° peak (Rodríguez-Ridao 2020).
  No landmine EMG exists that we found.
- Obliques low (0.32) and the anti-rotation cue: one-arm presses raise
  external oblique activity several-fold over two-arm presses (Saeterbakken
  2012, dumbbell presses).
- Middle ground between horizontal and vertical pressing; press straight out,
  not across the body: Wellman 2023, Cressey.
- Leaning back tips the press toward a flatter, chest-led push (core cue and
  comparison): the arc already rises ~45-50°, like a steep incline press, so
  leaning the trunk back makes the press flatter relative to the body, and
  flatter angles favour the upper pectoralis over the anterior deltoid
  (Rodríguez-Ridao 2020: anterior deltoid highest at 45-60°, upper
  pectoralis at 30°). Pass 1 said it turns into an incline press, which
  contradicted LM_PATH's own description of the arc. The same wording is
  used for the half-kneeling and Viking presses.
- Stance: StrengthLog's landmine press stands with the feet about
  shoulder-width (or kneels), so a parallel stance is a valid setup, not a
  fault. The copy speaks only to this split-stance version: the mistake is
  letting the feet drift together out of the split (the ghost), not
  standing parallel as such.
- Setup: the lifter holds the loaded end and faces the anchor (the
  landmine base is ~1.8 m in front of the lifter in both landmine models),
  so the setup says stand (or kneel) at the loaded end facing the landmine.

Faults (framed at yaw -1.0):
- elbow (`leftElbowFlared(40)`: the left elbow swung 40° out and up about the
  shoulder, around the chest's axis; with the elbow bend; `.seen(0.5)`,
  total -0.5, toward face-on): bottom, 3.83 s. From the model's ~25° this
  flares the elbow to ~65°, high out to the side, which is the mistake the
  copy names.
- path (`leftPressedAcross`: the left hand 0.16 torso lengths and the elbow
  0.06 toward the midline; `.whenStraight`; view 0.6, total -0.4): top,
  1.75 s.
- core (`leanedBack(14, arch: 0.05)`, no bar; any; `.seen(-0.4)`, total
  -1.4): top, 1.75 s.
- twist (`leftShoulderTwistedForward`: the trunk, both shoulders and the left
  arm turned 30° about the pelvis around the vertical, the left shoulder
  forward; the free right arm is not drawn; any; view -0.5, total -1.5,
  side-on): 1.75 s.
- stance (feet brought level, side by side: the front (right) ankle moved
  back and the back (left) one forward 0.5 torso lengths each, level with the
  floor, which puts both under the hips, the knees straightened onto the
  hip-ankle line; any; view -0.4, total -1.4, side-on): 3.83 s.
  `squareLockedStance` was dropped here: it only draws the feet 6 cm in,
  which never squares a 0.60 m stagger, and the front knee is already
  straight. Re-seating the knees instead of straightening
  them would bend them to ~140°, which reads as a squat.

## Half-Kneeling Landmine Press

Model: LEFT knee down under the hip (hip ~170°, back toes tucked), RIGHT foot
flat ahead (knee ~92°, shin vertical), LEFT arm presses, right hand on the
right hip. Same arm path as the standing landmine press.

Claims: as the standing landmine press (same activation rows; no study shows
kneeling changes them, so they are not changed). Knee down on the pressing
side (the bar in the hand on the same side as the down knee) and a braced
neutral spine: Wellman 2023, which also asks for a slight hip-flexor
stretch. The Wellman excerpt says to contract the glute of the leg that is
up; the copy follows Cressey instead (a subtle stretch on the trailing
leg's hip flexors with the glutes on that side switched on, i.e. the glute
of the down leg), which matches the model's extended back hip (~170°). No
copy change was needed for this in pass 2; only the citation changed.

Faults (framed at yaw -1.0):
- elbow, path, core, twist: as the standing press (elbow 3.83 s; path, core
  and twist 1.75 s). The elbow starts in the same place (0.26 m below,
  0.12 m out, level front to back with the shoulder).
- stance (hips sat back toward the heel, the Kneeling Lat Pulldown's feet
  fault made larger: pelvis and hips 0.22 torso lengths (~13 cm) back and
  0.12 (~7 cm) down, the spine 0.1 back, so the trunk bends forward at the
  hip; any; view -0.4, total -1.4): 3.83 s.

## Viking Press

Model: standing, feet ~0.30 m apart, knees straight, both hands on a landmine
Viking handle with neutral grips (palms facing in: the hand's palm axis points
toward the midline, turned ~90° from the barbell models; hands 0.50-0.63 m
apart). The handles start at the front of the shoulders, at collarbone height
(grips from 6 cm below to 8 cm above the shoulder joints; the chin is 14 cm
above them), elbows folded (~21°) and hanging almost straight down, tucked at
the sides (upper arms ~5° from hanging, elbows 2 cm in front of and 2 cm
inside the shoulder joints). Mid-press the elbows open out to the sides
(~0.23 m out from the shoulders, wider than the hands), and the handles finish
up and forward (elbows ~160°, hands ~0.41 m ahead of the shoulders, about
level with the top of the head).

Claims:
- No Viking press study found. Activation ranked from the landmine press
  (StrengthLog) and steep press angles (Rodríguez-Ridao 2020): anterior deltoid
  0.82, triceps 0.56, upper pectoralis 0.44, lateral deltoid low (0.36)
  because the handles finish up and forward, well short of overhead (upper
  arm ~126°), nearer an incline press than an overhead press. The elbows do
  open out mid-press, so the lateral deltoid is listed, but kept low. All four
  are ranks.
- Neutral handles let the elbows start tucked in under them: what the model
  does; no claim that a neutral grip is safer is made, as none was found in
  the literature. The elbow cue asks for a tucked start and a drive up and
  forward, not for the elbows to stay under the handles all the way, since the
  model's own elbows open out mid-press. Its why says flared elbows push the
  handles sideways, off the arc (the position's mechanics; pass 1 said
  twist, which no source defines).
- Finish, not lockout: the model's elbows stop at ~160° (hands 0.41 m ahead
  of and 0.33 m above the shoulders), so the path cue asks for full reach up
  and forward (label Press to full reach, title Finish) and its mistake is
  the elbows still well bent, short of the top; the pass-1 copy said the
  arms finish straight, which the model never shows.
- Leaning back: as the landmine press (tips it toward a flatter, chest-led
  push).

Faults (framed at yaw -1.0):
- grip (wrists bent back: with the palms facing in, the backs of the hands
  tip out, the hand tips turned 40° outward about the chest's axis: the
  dumbbell family's `palmsInWristsBentBack`, in FaultPoses.swift; any;
  `.seen(0.6)` toward face-on, total -0.4): bottom, 3.83 s. `wristBentBack`
  turns about the side-to-side axis, which for these hands only tilts them
  within the palm.
- elbow (elbows flared: both elbows swung 38° out about the shoulders,
  around the chest's axis; with the elbow bend; view 0.6, total -0.4):
  bottom, 3.83 s.
- path (arms bent at the top: the handles 0.14 torso lengths back and 0.12
  down (~9 cm short), the elbows 0.14 down, then re-seated, so the bend
  (~112° from the model's ~161°) opens downward; `.whenStraight`; view -0.4,
  total -1.4, side-on): top, 1.58 s. The model's own lockout is ~160°, so
  the fault shows at ~80%.
- core (`leanedBack(14, arch: 0.06)`, no bar; any; `.seen(-0.4)`): top,
  1.58 s.
- feet (dipping the knees, the Barbell Overhead Press's feet moves without
  the bar: the hips and all they carry 0.12 torso lengths lower, knees
  re-seated; any; view -0.4): 3.83 s.

## For the fault-review stills

Each fault's still is in `bottoms.json` as "Exercise|cue" (the times in the
Faults lists above). Away from the exercise's default still: Seated torso
and barpath 1.33 s; Behind-the-Neck brace and lockout 2.0 s; Push Press
rack, dip and heels 0.50 s (bottom of the dip) and lockout and brace
1.42 s; Z Press torso, brace and barpath 1.33 s; Smith bench 1.0 s; both
landmines' path, core and twist 1.75 s; Viking path and core 1.58 s.

New pieces: `barHeldHigh(withBar:strength:)` (hands and bar 0.16 torso
lengths up, elbows re-seated, with the elbow bend by default; seated, Z and
Smith depth, push press rack), `pushPressDip` (a `FaultStrength.between` on
pelvis to left ankle, 1.40 to 1.30 torso lengths), `leftPressedAcross` and
`leftShoulderTwistedForward` (both landmines). Inline one-offs:
behind-the-neck grip and depth, push press heels, Z press torso, Smith bench
and elbow, landmine stance, half-kneeling stance, Viking elbow, path and
feet. The Viking grip reuses the dumbbell family's `palmsInWristsBentBack`.
`squareLockedStance`, `gripTooNarrow` and `twisted` are not used by this
family.

## Revision (2026-09-26, after the model/ghost review)

Each finding was checked against the rig and the skinned meshes (bar, grip
and body surfaces at the bottom and top of the rep) before it was applied.

- Push Press: the model never racks the bar. The rack cue is now Start
  Position (label Arms still in the dip), the setup holds the bar in front
  of the chin with the seated press's grip (a hand's width outside the
  shoulders), the elbows-in-front step is gone, and the comparison notes no
  longer say the bar leaves the shoulders. Ghost unchanged.
- Behind-the-Neck Press: depth is to just below the base of the skull (label
  Bar to base of skull), not ear level; the mistake is the bar dropped down
  the back of the neck toward the upper back; setup takes the bar on the
  upper traps; the head cue no longer says the head moves during the rep.
  Ghost unchanged (it already drops the bar ~8 cm).
- Smith Machine Shoulder Press: depth is to the collarbones (label Lower to
  collarbones, new `DEPTH_SMITH`); the bench cue says just short of upright;
  the elbow cue no longer says the elbows sit in front of the bar (they sit
  ~5 cm behind it). Ghost unchanged.
- Viking Press: handles start at the front of the shoulders with the elbows
  tucked at the sides (label Elbows tucked, shortened from the suggested
  Elbows tucked in so the right-hand pill clears the hips on row 0.50); the
  path cue lowers to the front of the shoulders and finishes with the handles
  up in front of the head; setup says front of the shoulders and facing the
  landmine. The grip ghost now bends the wrists back for a palms-in grip, and
  the grip mistake text says so.
- Landmine Shoulder Press and Half-Kneeling Landmine Press: `LM_ELBOW` says the
  elbow starts low and close to the side (not in front of the ribs).
- Landmine Shoulder Press: stance label Staggered stance on row 0.68 (the old
  row 0.86 pill sat over the front shoe), no knees-soft claim (the front knee
  is straight), mistake is the feet side by side, with the new ghost.

The Viking ghost finding reached this revision cut off after its first
sentence (the hand's palm axis); the fix applied is the one that sentence
points to, checked on the rig: the palm axis points toward the midline, so the
old side-to-side turn tilted the hand within the palm.

Checks re-run: `python3 spec_191_240_bbpress.py` and `python3 spec_191_240.py`
print OK; the gen.py layout and emit ran for all eight; the revised fragment
was spliced into a scratch copy of `FaultPoses.swift` and compiled with
`swiftc`, and `FaultGhost.solve` on the exported rig poses changes only the
landmine stance (feet ±0.50 torso lengths along the facing, knees on the
hip-ankle line) and the Viking grip (hand tips ~0.08-0.09 torso lengths
outward on each side). No source was added or removed: the new depth copy
follows Coratella 2022's protocol (bar below the external occipital
protuberance, re-checked on the article).

## Revision 2 (2026-09-26, pass 2: full evidence and model findings)

Pass 1 saw only part of the reviews. Every finding was re-checked against the
current files, the briefs, the framing shots and the sources themselves
(Europe PMC abstracts, the NSCA Basics PDF text, the McKean author PDF, the
Coratella full text, the Wellman excerpt and the Cressey, Catalyst and
StrengthLog pages). The full decision log is in the session scratchpad
(findings/pass2-bbpress.md).

- Behind-the-Neck Press: depth is now treated as individual. The cited
  manuals lower the bar further than the model (NSCA Basics across the
  shoulders, StrengthLog the base of the neck), so the fault is forcing the
  bar lower than your own shoulders allow (badge FORCED DEPTH), backed by
  McKean 2015 (males exceeded passive external rotation) and Kolber 2013
  (association only). The head why now cites Kebaetse 1999.
- Seated, Z and Smith depth: the why cites Paoli 2010 only for pressing to
  full elbow extension; the free-bar mistake says nose height, where the
  ghost puts the bar; the correct text says at least chin height.
- Smith: Botton 2013 added (a Smith machine shoulder press EMG study);
  bench label Bench under bar clears the right forearm; the elbow why no
  longer says twist.
- Push Press: dip and foot cues cite Catalyst and NSCA Kinetic Select; NSCA
  Basics is kept only for no pause in the dip; the start cue says most
  lifters start from the shoulders; the heels text no longer tells the
  lifter to let the heels rise (the model's never do), only allows it as
  the legs finish.
- Landmine and half-kneeling: leaning back tips the press toward a flatter,
  chest-led push (not into an incline press); the stance fault is the feet
  drifting together out of the split, since a parallel stance is a valid
  setup; the setups stand or kneel at the loaded end facing the landmine;
  Wellman is the sole author (foreword by T. Allen) and Cressey is cited for
  the down-leg glute.
- Viking: the path cue is a full-reach finish (the model stops at ~160°);
  flatter-push wording for leaning back; the elbow why no longer says
  twist.
- Activation rows, glows and ghosts are unchanged. The Swift fragment
  changed only in comments (behind-the-neck depth, seated depth).

Checks re-run: `python3 spec_191_240_bbpress.py` and `python3 spec_191_240.py`
print OK; the gen.py dry run emits all eight. `FaultPoses.swift` already holds
the pass-1 fragment verbatim, so the revised fragment was swapped in for it in
a scratch copy and `swiftc -typecheck` reports no errors.

Completion of pass 2 (the same day, after re-checking every finding again;
decision log in findings/pass2-bbpress.md):

- Push Press: NSCA Kinetic Select states the weight over the middle of the
  feet for the catch, not the dip, so it is no longer cited for the heels
  cue; the dip and heels correct texts now say hips under the shoulders
  (NSCA Kinetic Select) and whole foot on the floor (Catalyst). The notes
  no longer say NSCA Basics and Soriano 2019 start from the front of the
  shoulders: NSCA Basics starts across the back of the shoulders (front
  allowed) and Soriano lists both.
- Seated, Z and push press lockouts: correct texts say arms' length over the
  head (the models stop at ~162°), as the model review suggested.
- Viking Press: grip correct text drops knuckles up (a barbell cue); the grip
  ghost now uses `palmsInWristsBentBack.seen(0.6)` from FaultPoses.swift,
  the same moves as the inlined pose it replaces.

Checks: `python3 spec_191_240_bbpress.py` prints OK; the gen.py dry run emits
all eight; the fragment spliced into a scratch copy of `FaultPoses.swift`
passes `swiftc -typecheck` with no errors.
