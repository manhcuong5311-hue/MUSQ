# 401-500 folder: curls (2026-10-04)

Five biceps curls from the builder's 255-267 set: 255 Strict Curl, 256 21s Curl, 257 EZ-Bar 21s,
258 Waiter Curl and 267 Seated Dumbbell Curl (models `Biceps/<Resource>.usdc`: StrictCurl,
Curl21s, EZBar21s, WaiterCurl, SeatedDumbbellCurl). `spec_500_curls.py` holds the copy and setup
steps (its header lists what each model shows and the full citations),
`Tools/fault-review/faults_500_curls.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_curls.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The arm briefs (`SCRATCH/briefs/<Resource>.md`: elbow, shoulder, wrist and palm every 0.5 s,
  the moving equipment), the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`), `tiers30.json`,
  `joints.json`.
- The rigs straight from the USD with Blender's Python + pxr (`SCRATCH/curls/rig.py`, a reader:
  joint world transforms, equipment bounds, skinned mesh points via UsdSkel skinning):
  `reps.py` (every frame's elbow angles, both arms, and the rep extrema), `detail21.py` (21s
  angles at each transition: forearm elevation, upper-arm angle, hand and elbow positions),
  `ezbar.py` (EZ bar segments and grip sockets), `strict.py` (wall board and pad bounds, the
  back-most skinned points of the shoes, shorts, glutes, upper back, head and triceps against the
  pad's face), `waiter.py` (dumbbell, plates and handle bounds against the hands and fingers),
  `seated.py` (bench pad planes, skinned body against the back pad, seat), `palm.py` (palm turn
  from the hand joint's +Z, the palm normal), `lever.py` (the load's lever arm about the elbow:
  horizontal distance from the elbow joint to the bar's or dumbbell's centre), `dist.py`
  (shoulder-to-wrist distances per elbow angle, for the ghosts' `between` strengths).
- Labels: `preview_500.py curls`, then `overlay.py` drew gen.py's pills (24 + 5.6 pt per
  character, 28 pt tall), leaders, the tracked joints and the projected skeleton and moving
  equipment (`jstill.py`, `eqproj.py`) over the stills and at the 21s' later moments, with the eye
  button (top right, to 84 pt) and the legend (bottom left, from 610 pt) boxed. Then the lab's
  trainer screenshots (see Labels).
- Ghosts: `ghost.py`, a Python port of `FaultGhost.solve` (same body axes, shift / turn /
  straighten / resolve, strengths, hand and foot tips), run on the real joint transforms at the
  fault's moment and projected with the framing plus the fault's view (`faults.py`). Then the
  lab's fault stills.

## Shared facts about the models

- One body; torso (neck to pelvis) 0.592 m. Both arms move together and identically in all five
  (left and right elbow angles equal to 0.1° on every frame): no alternating arm anywhere.
- Strict, Waiter and Seated clips are 7.96 s, two identical 4 s reps: still ~0.2-0.3 s, the curl
  ~1.0-1.1 s, the top held ~0.4-0.5 s, the lowering ~1.5 s, still at the bottom ~0.5 s. The
  tempo lines (curl in about a second, lower in about one and a half) describe that.
- The 21s clips are 43.96 s (1056 frames at 24 fps), one set of 21 reps, 2 s each, with no rest.
- Highlight tiers, identical for the five: bright BicepsBrachii_LongHead, BicepsBrachii_ShortHead,
  Brachialis -> PRIMARY "Biceps Brachii" and "Brachialis"; dim Brachioradialis and the wrist and
  finger flexors and extensors (ExtensorCarpiRadialisBrevis/Longus, ExtensorCarpiUlnaris,
  ExtensorDigitorum, FlexorCarpiRadialis, FlexorDigitorumProfundus/Superficialis, PalmarisLongus)
  -> SECONDARY "Brachioradialis" and one "Forearms" row, as the 1-50 curls and the Machine
  Preacher Curl group them. All four names pass `part_of()` (biceps, biceps, forearms, forearms).
  Legend lines: "BICEPS BRACHII · BRACHIALIS", "BRACHIORADIALIS · FOREARMS".
- Framings (model map, not changed): Strict -1.0 / 0.735, 21s -0.9 / 0.698, EZ -0.4 / 0.878,
  Waiter -0.5 / 0.875, Seated -0.6 / 0.783. All negative: the lifter's left (near) arm is on the
  right of the screen.

## Activation (all five)

No EMG study of a wall (strict) curl, 21s, a waiter curl or a back-supported seated dumbbell curl
was found (Europe PMC searches 2026-10-04: "21s", "21's", "waiter curl", "wall curl", "strict
curl", seated vs standing curls; the only "21s" hit is unrelated). Every value is a judgement call
from the library's nearest lift and the paint:

| Row | Strict | 21s | EZ 21s | Waiter | Seated | Basis |
|---|---|---|---|---|---|---|
| Biceps Brachii P | 0.90 | 0.90 | 0.88 | 0.86 | 0.84 | Barbell Curl 0.90 (same straight bar, grip and elbow path; the wall or the 21s scheme change the swing and range, not the bar); EZ 0.02 under the straight bar (Coratella 2023 JFMK: +1.8% biceps with the straight bar, arms still, lifting phase); Waiter as the 1-50 Dumbbell Curl 0.86 (palms up all rep); Seated as the Alternating Dumbbell Curl 0.84 (palms in, turned up as the weight rises) |
| Brachialis P | 0.72 | 0.72 | 0.72 | 0.72 | 0.72 | bright; the house value for a bright brachialis (Machine Preacher Curl 0.72); Kawakami 1994 (MRI estimate: 47% of maximal elbow-flexor torque, biceps 34%; a capacity estimate, not activation); Coratella 2023 Sports ("Brachialis is the most powerful flexor of the forearm", not measured there); kept under the biceps as the library does |
| Brachioradialis S | 0.52 | 0.52 | 0.52 | 0.44 | 0.44 | dim; Barbell Curl 0.52 for the bars (Marcolin 2018: the bars drew more brachioradialis than dumbbell curls; straight vs EZ "a matter of subjective comfort"); the 1-50 Dumbbell Curl's 0.44 for the dumbbells; Boland 2008 (active in elbow flexion whatever the forearm position) |
| Forearms S | 0.30 | 0.30 | 0.30 | 0.30 | 0.30 | dim; the 1-50 curls' house value; Mogk and Keir 2003 (gripping works the forearm flexors and extensors). On the waiter curl the fingers do not grip, but the wrists hold the hands level against the load all rep (flexed 42° at the bottom, extended 42° at the top), so the same LOW value |

Stabilisers: ExRx's Barbell and Dumbbell Curl lists (anterior deltoid, upper and middle trapezius,
levator scapulae, wrist flexors; the wrist flexors are already the Forearms row): "anterior
deltoid", "upper trapezius" and "middle trapezius" on the Strict and Seated curls (trunk pinned by
the wall or pad), "core" instead of the middle trapezius on the free-standing 21s and Waiter Curl
(the house choice for standing curls).

## Strict Curl

Model facts: a straight barbell, underhand, the wrist joints 0.44 m apart (the shoulder joints
0.39 m), palms fully up, wrists straight. Back to a wall board (Q191_StrictWall: 1.1 m wide, 2 m
tall, its face at z -0.162) carrying a 46 cm wide pad from 0.67 to 1.57 m up, its face at
z -0.135. Measured on the skinned body: the seat of the shorts 0.9 cm and the glutes 0.2 cm into
the pad (touching), the upper back (trapezius/rhomboid region, 1.40 m up) 0.2 cm into it, the back
of the head (1.68 m up, above the pad's top) level with the pad's face and 3 cm in front of the
board; the heels 14.5 cm in front of the pad's face, 17 cm from the board at floor level; the
triceps 3-5 cm off the pad (the arms are not pressed to the wall). Trunk 5° back and still; knees
174-176°; ankles 0.30 m apart. Elbows 175° -> 50° (top at 1.25 s, held to ~1.6 s, lowered by
~3.4 s): the upper arms 13° in front of the trunk at the bottom, 6° mid-curl, 16° at the top; the
elbows move within 5 cm. At the top the forearms point ~60° above level and the bar sits in front
of the upper chest, the hands 5 cm below shoulder height. Load 0.40 of peak at the bottom, peak at
~110°, 0.49 at the top. At the bottom the bar hangs ~6 cm in front of the thighs.

| Claim | Source |
|---|---|
| Glutes and upper back on the wall from the first rep to the last; contests judge exactly that | MCCS Strict Curl Competition rules ("Make sure that your glutes and upper back are pressed against the wall. They must remain against the wall throughout the entire strict curl lift."); Dale (FitnessVolt) (upper back and butt in contact on the way up and down); the model (both on the pad all clip) |
| Pinned there, the hips cannot drive forward and the trunk cannot rock, so the elbow flexors lift the bar | Williams (Men's Health) (the wall prevents the swing; move only at the elbows); the comparison note says the same |
| Upper back: shoulder blades pressed into the pad, chest up; rolling the shoulders forward lets the trunk finish the lift | Williams (squeeze the shoulder blades, drive the shoulders into the wall); MCCS (upper back on the wall throughout). The why is reasoning from the rule, not a measured effect |
| Bring the bar to your upper chest | The model (top: forearms ~60° above level, bar in front of the upper chest). Dale says to the chin; the copy follows the model |
| Elbows close to the sides; swinging them forward brings the front deltoids in | ExRx Barbell Curl (elbows to the side); Coratella 2023 JFMK full text ("the anterior deltoid was markedly more excited when flexing vs. not flexing the arms"; the biceps was also more excited in the lifting phase, so the copy makes no claim that the biceps work less). The contest rules allow the upper arms to move ("You can move your upper arms as much as you like"); the model keeps them within 6-16° of the trunk, and the copy follows the model |
| Knees soft but still, feet planted; a dip and drive through the legs gets the bar moving before the arms | Dale (feet must remain stationary); DiGiovanni (Set For Set) (leg drive is a sign the weight is too heavy, for curls in general); the model (knees 174-176° all clip). The mechanism is described, not measured |
| Each rep from straight arms; the bottom is the lightest part; in new lifters full-range curl training built more strength than mid-range partial reps | The model's load (0.40 of peak at the bottom); Pinto 2012 (no resistance-training experience, preacher curl, 0-130° vs a mid-range 50-100°: 1RM +25.7% vs +16.0%, thickness similar). The copy says mid-range, as the library's Dumbbell Curl does: Pinto's partials were mid-range, and the range studies below found lower-range partials as good or better |
| Setup: heels about 15 cm out; glutes and upper back on the pad, head upright; hands just wider than the shoulders; bar hanging in front of the thighs, knees almost straight | The model (14.5 cm from the pad's face, 17 cm from the board; head level with the pad's face; wrists 0.44 m apart vs shoulders 0.39 m). MCCS and Dale allow up to 12 inches (30 cm); the 15 cm is the model's, inside that limit |

Williams (Men's Health) also presses the backs of the arms to the wall; this model keeps the
triceps 3-5 cm off the pad, so the copy does not ask for it. No grip/wrist cue: the bar is held as
the Barbell Curl's (setup step), and the five cues cover the strict curl's own cheats (hips,
upper back, elbows, legs) plus the range.

Comparison (HIPS OFF THE WALL): the hips cue's sources.

## 21s Curl

Model facts (per-frame elbow angles, `reps.py` / `detail21.py`): a straight barbell, the Strict
Curl's grip (wrist joints 0.44 m apart, palms fully up), standing tall (trunk 0°, knees 174-176°,
ankles 0.30 m apart). Which half first: the bottom half.

| Block | Time | Range (elbow) | Each rep |
|---|---|---|---|
| Reps 1-7, bottom half | 0-14 s | 176° (straight) -> 90.2° (forearms 8° above level) -> 176° | 0.75 s up, 0.13 s pause, 1.0 s down, 0.12 s at straight; tops at 0.75-0.88, 2.75-2.88 ... 12.75-12.88 s |
| Transition | 14-15 s | 176° -> 90° | one curl up to level |
| Reps 8-14, top half | 15-29 s | 90.2° -> 52.3° (forearms 53° above level) -> 90.2° | ~0.7 s up, 0.17 s pause, ~0.95 s down, 0.17 s at level; tops at 15.71-15.88, 17.71-17.88 ... 27.71-27.88 s; the bar never goes below level |
| Transition | 29-30 s | 90° -> 176° | lowered to straight arms |
| Reps 15-21, full | 30-44 s | 176° -> 52.3° -> 176° | 0.83 s up, 0.13 s pause, 0.92 s down, 0.12 s at straight; tops at 30.83-30.96 ... 42.83-42.96 s |

The upper arms stay 5-15° in front of the trunk (the elbows within 5 cm). Load: 0.31 of peak with
straight arms, peak at ~95-100° (just before level), 0.99 at 90°, 0.60 at the top: the
bottom-half reps run from the lightest point to the heaviest, the top-half reps from the heaviest
to 0.60.

| Claim | Source |
|---|---|
| The scheme: 7 bottom-half reps from straight arms to about 90°, 7 top-half reps from 90° to the top, 7 full reps, no rest between | DiGiovanni (Set For Set) ("7 partial reps from the bottom up to about 90 degrees of elbow bend", "7 partial reps from 90 degrees up to the top contraction", "7 full reps", no rest); Nobbe (Garage Gym Reviews) (bottom half stopping at a 90° elbow first, then top half, then complete reps); the model (the same order and angles, one continuous set) |
| Bottom half: lightest with the arms straight, heaviest as the forearms reach level | The model's load (0.31 of peak at straight, peak at ~95-100°) |
| In new lifters on preacher curls, training the lower part of the range has built more strength than training the upper part, and at least as much muscle | Sato 2021 (non-resistance-trained adults, one-arm dumbbell preacher curls at 45° shoulder flexion over 0-50° vs 80-130° of flexion: strength rose only after the extended range; thickness +8.9% vs +3.4%); Pedrosa 2023 (untrained women, preacher curl 0-68° vs 68-135°: larger 1RM gain and more distal growth with the initial range, mid and summed growth similar, hence "at least as much"). In flexion terms the model's bottom half is 4-90°, its top half 90-128°, close to these ranges. All four range studies here (Pinto, Sato, Pedrosa, Havers) used preacher curls, where the load is heaviest near straight arms; on a standing curl the bottom is the lightest part, so the copy names preacher curls. In trained lifters Havers 2025 found initial-range partials about as good as full range; Schoenfeld and Grgic 2020 call the upper-limb evidence limited and conflicting, so the copy says "in new lifters" and claims no advantage for 21s themselves (no study of 21s exists) |
| Top half: starting from level, where the bar pulls hardest, keeps the elbow flexors loaded with no rest at the bottom | The model (load 0.99 of peak at level, the bar never below level in reps 8-14) |
| In preacher-curl studies of new lifters, upper-range reps on their own built less than the lower range | Sato 2021 (no significant strength gain, smaller thickness gain after the flexed range); Pedrosa 2023 (smaller 1RM gain after the final range) |
| Full reps: the whole range; in new lifters full-range curl training built more strength than mid-range partial reps | Pinto 2012 (50-100° partials; not the 21s' halves, so the copy names mid-range partials) |
| Elbows at the sides; swinging them forward brings the front deltoids in | DiGiovanni ("elbows tucked near your sides", "elbows stay pinned"); Coratella 2023 JFMK (see Strict Curl); the model |
| A lighter bar than a normal set; leaning back or driving with the hips means it is too heavy | DiGiovanni ("Most lifters need to go lighter than their normal 8-12 rep curl weight"; "if you are leaning back and using leg drive, the weight is too heavy"); Nobbe (start with light weights) |
| Setup: hands just wider than the shoulders, feet hip-width, arms straight | The model (wrists 0.44 m vs shoulders 0.39 m; ankles 0.30 m apart); ExRx Barbell Curl (shoulder-width underhand grip) |

Comparison (LEANING BACK): DiGiovanni (leaning back = too heavy).

## EZ-Bar 21s

Model facts: the same scheme and timing as the 21s Curl to the frame (bottom-half tops 90.1°,
top-half tops 52.2°, straight 173.6°; block boundaries at 14, 15, 29 and 30 s). The bar
(Q191_EZBar) has two bends each side: the straight middle (|x| < 0.05 m), an inner bend
(0.04-0.16 m) and an outer bend (0.15-0.30 m). The hands hold the outer bend (Grip_L/R sockets at
x +-0.195 m), the wrist joints 0.39 m apart, the shoulders' width; the palm normal points ~23°
in from fully up (palm vector [-0.39, 0.91, -0.13] at 92°), the grip segments angling ~21° in
plan. Upper arms 9-17° in front of the trunk. Load 0.30 of peak straight, peak at ~95°, 0.62 at
the top.

| Claim | Source |
|---|---|
| Outer angled grips, hands about shoulder-width, palms turned slightly in; the bends hold the forearms about 20° short of fully palms-up | The model (above) |
| The EZ and straight bars differ little: slightly more biceps with the straight bar in one study, a matter of comfort in another | Coratella 2023 JFMK (+1.8% biceps, straight vs EZ, arms still, lifting phase; ES 0.74); Marcolin 2018 ("The small difference between BC and EZ variants ... makes the choice between these two exercises a matter of subjective comfort") |
| Wrists curling in as the bar nears the top is the grip mistake; knuckles in line with the forearms | Mogk and Keir 2003 (a flexed wrist cut grip force 40-50%); the 1-50 curls' house cue. The copy only names the position. It said as the bar passes level until review; the ghost is read at a top-half rep's top (17.8 s), as the library's curl wrist faults are, so the copy now says near the top |
| Bottom half at long lengths, lightest to heaviest; new-lifter evidence | As the 21s Curl (Sato 2021, Pedrosa 2023; the model's load) |
| Top half: from level up, no rest at the bottom; on their own built less strength in new lifters | As the 21s Curl |
| Last seven full reps; full range built more strength than mid-range partial reps | Pinto 2012 (as the 21s Curl) |
| Elbows at the sides; forward elbows let the front deltoids take over the top | Coratella 2023 JFMK (anterior deltoid "markedly more excited when flexing vs. not flexing the arms", measured with both bars); DiGiovanni |
| Setup: lighter than for 8-12 curls; outer bends underhand, about shoulder-width | DiGiovanni; the model |

Comparison (ELBOWS DRIFTING FORWARD): the elbows cue's sources. The two 21s were checked for
repeats: no label, intro, why, mistake or correct sentence is shared word for word (the shared
facts are reworded), and their comparisons differ (leaning back vs elbows).

## Waiter Curl

Model facts: one dumbbell (0.45 m tall, plates 0.20 m across) stood on end; both palms flat under
its top plate (the plate's underside at the wrist joints' height, 0.96-0.99 m at the bottom), one
hand each side of the handle, the fingers pointing in and forward under the plate (fingertips
2.5 cm from the handle), not wrapped round it; the wrist joints 0.27 m apart. The dumbbell stays
vertical all rep: the hands' pitch is constant (-6.6°), the wrists bent 42° toward the palm at
the bottom and 42° back at the top to keep the plate level. Elbows 150° -> 66° (still to 0.17 s,
top by 1.25 s, held to ~1.75 s, lowered by 3.38 s): the arms never straighten (forearms 50° below
level at the bottom, 39° above at the top). The dumbbell rises 35 cm, from in front of the hips
(its top plate ~1.0 m up, its lower end 0.65 m) to chest height (hands 1.32 m, shoulders 1.43 m).
Upper arms 9-17° forward, elbows within 4 cm; trunk upright and still; knees 174-176°. The
dumbbell's centre sits ~6 cm ahead of the wrists, so the load stays high: 0.67 of peak at the
bottom, peak at ~105°, 0.81 at the top.

| Claim | Source |
|---|---|
| Both palms sit flat under the top plate, one each side of the handle; fingers flat, nothing gripped; wrapping the fingers round the handle is the mistake | Saini (FitnessVolt) ("Place your hands flat under the top plate with one hand on each side of the dumbbell's handle in a supinated position", "Do not wrap your fingers around the dumbbell", hold it like a waiter holds a tray); the model |
| The dumbbell stays on end, the top plate level all the way; the wrists bend back as the forearms rise and forward as they lower | Saini ("Ensure that the top of the dumbbell faces straight up throughout the motion. Do not let the top of the dumbbell be at an angle."); the model (the wrist angles above). "Open palms only hold a dumbbell that stays level on them" is reasoning |
| Wrists curling in near the top tips the dumbbell back toward the face | The model's geometry: with the wrists in line with the forearms at the top (39° above level) the plate would tilt ~40° toward the lifter |
| Elbows by the ribs; swinging them forward lets the front deltoids raise it | Saini ("keeping your elbows pinned to your sides"); Coratella 2023 JFMK |
| The arms never straighten; with the dumbbell out in front of the hands its pull on the elbows stays at two-thirds of its peak or more; hanging the arms straight eases that tension off | The model (150° at the bottom; load 0.67-1.0 of peak over the range); Saini ("Extending your arms at the bottom will ease tension off your brachii") |
| Stop each lowering with the dumbbell in front of the hips, curl to chest height | The model; Saini (curl until it is at chest height) |
| Curl in about a second, pause, lower in about one and a half | The model's timing |
| Setup: stand the dumbbell on end on a bench, slide both palms under its top plate, feet hip-width | Saini (place the dumbbell vertically on an elevated surface such as a bench); the model (ankles 0.30 m apart) |

Saini's claim that the waiter curl targets the long head is uncited and not used. Comparison
(DUMBBELL TIPPING): the upright cue's sources.

## Seated Dumbbell Curl

Model facts: seated on an adjustable bench (GYM_Bench_ROOT), the seat top 0.47 m up, the back pad
set nearly upright (its face 11° from vertical, 0.33 m wide, 0.45-1.28 m up). The trunk leans 17°
back; the upper back and the seat of the shorts touch the pad (0-0.3 cm), the head is above the
pad's top. Feet flat ~0.47 m in front of the hips, knees 120°, hips 129°. A dumbbell in each hand;
both arms curl together (identical angles every frame). The palms face in with the arms hanging
(the hands beside the seat, outside the pad, x +-0.33 m), turn up through the middle of the curl
(about 0.75-1.12 s, elbow ~120° -> ~70°), finish turned up toward the shoulders (~17° short of
fully up) and turn back in on the way down (2.25-2.75 s). Elbows 170° -> 54° (top 1.38-1.88 s,
lowered by ~3.5 s). The upper arms hang 7° in front of vertical, i.e. 10° behind the line of the
leaning trunk; 13° out at the bottom, 10° forward and 7° out at the top; elbows within 3 cm. Load
0.29 of peak at the bottom, peak at ~100°, 0.70 at the top.

| Claim | Source |
|---|---|
| Sit back against the near-upright pad; with the seat and pad holding the trunk there is nothing to swing with as long as you stay on them; rocking off the pad and back is the mistake | The model (back and seat on the pad all clip). The mechanism is reasoning: no source here measures a back-supported curl, so the copy claims no effect beyond removing the swing |
| Palms in at the bottom, turned up as the dumbbells rise, back in on the way down | ExRx Dumbbell Curl ("Position two dumbbells to sides, palms facing in", "raise ... and rotate forearm until forearm is vertical and palm faces shoulder"; it may be done simultaneously); the model (palm turn timing above) |
| The biceps both bends the elbow and turns the palm up | Coratella 2023 Sports full text ("biceps brachii is a supinator"; "flexes the elbow and supinate or stabilizes the forearm towards the supination") |
| In trained lifters palm-up curls have worked the biceps harder than palm-in or palm-down curls | Coratella 2023 Sports (ten competitive bodybuilders, 8RM: supinated +12% vs neutral, +19% vs pronated, lifting phase) |
| Wrists curling in instead of the palms turning up | The 1-50 curls' and Alternating Dumbbell Curl's wrist cue; a position, no effect claimed |
| The upper arms hang straight down beside the pad; forward elbows bring the front deltoids in | ExRx (elbows to sides); Coratella 2023 JFMK; the model (elbows outside the pad, x +-0.26 m vs the pad's +-0.165 m) |
| Arms almost straight at the bottom; the bottom is the lightest part; full-range training built more strength than mid-range partial reps in new lifters | The model (170°; load 0.29 of peak); Pinto 2012 |
| Curl in about a second, lower in about one and a half; lowering-only work has built about as much muscle as lifting-only work; 0.5-8 s reps built similar muscle | The model's timing; Schoenfeld 2017 (10.0% vs 6.8%, not significant); Schoenfeld 2015 |
| Setup: back almost upright, hips at the back of the seat, upper back on the pad, feet flat in front, palms facing in, curl both together | The model |

The ExRx Dumbbell Seated Curl page is behind ExRx's paywall in every Wayback snapshot tried
(2019-2023) and was not read. Comparison (ROCKING OFF THE PAD): the back cue.

## Distinct from the library

The Barbell Curl, Biceps Curl, Dumbbell Curl and Alternating Dumbbell Curl are free-standing,
full-range curls; the Incline Dumbbell Curl leans 25° back on a 65° pad with the arms 25° behind
the trunk; the Preacher, Spider and Drag curls fix or move the upper arms. Here: the Strict Curl
is the Barbell Curl against a wall that pins the glutes and upper back (cues: hips, upper back,
elbows, legs, range); the two 21s split one 44 s set into bottom-half, top-half and full reps
(cues: the three blocks, elbows, and the body or the EZ grip); the Waiter Curl holds one dumbbell
upright on open palms and never straightens the arms (palms, dumbbell angle, elbows, range, body);
the Seated Dumbbell Curl sits back on a near-upright pad, both arms together, palms turning up
from facing in (back, palm turn, elbows, range, lowering speed), with its arms only 10° behind
the trunk where the Incline Dumbbell Curl's are 25°.

## Library rows

Strict Curl BICEPS BRACHII / BARBELL / intermediate; 21s Curl BICEPS BRACHII / BARBELL /
intermediate; EZ-Bar 21s BICEPS BRACHII / EZ BAR / intermediate; Waiter Curl BICEPS BRACHII /
DUMBBELL / beginner; Seated Dumbbell Curl BICEPS BRACHII / DUMBBELL / beginner. All match the
models and the paint (biceps the first bright muscle); no change requested.

## Labels

Rows after the squeeze (final screen rows; `ov()` sets them), sides and what each pill sits over,
checked on the overlays and the lab's trainer screenshots. The moving equipment sets the free
space: on the three barbell lifts the plates sweep both sides between ~0.15 and ~0.58 (Strict and
21s: the near plate x 0.52-0.88, the far plate x 0.03-0.38; EZ: x 0.67-0.82 and 0.09-0.29), so
the pills sit above them (left, 0.10-0.17) or below them (0.62-0.75); on the left the top rows are
free (no button there), on the right the record and eye buttons take the top. While a mistake
shows, its banner covers ~0.03-0.065 at the top middle, so no pill sits above 0.10 (EZ's top-half
pill moved from 0.07 to 0.10 after round 1, where it ran under the banner).

- Strict Curl: Upper back on the wall 0.12 left -> far shoulder (upper_arm_R; the leader drops
  left of the head), Elbows by your sides 0.17 left -> far elbow (above the far plate's highest
  point, 0.23), Lower to straight arms 0.66 left -> far hand (below the far plate, left of the far
  leg), Glutes on the wall 0.66 right and Knees still, no dip 0.75 right over the static wall board
  -> near hip joint (thigh_L) and near kneecap. The hips leader first tracked the pelvis and ran
  diagonally across the front of the near thigh; the near hip (0.60, 0.47) sits at the back of the
  body on this view, so the leader now runs almost straight up the back of the near thigh, where
  the glutes meet the pad (review, 2026-10-04).
- 21s Curl: Elbows at your sides 0.12 left -> far elbow, 8-14: top half 0.17 left -> far hand
  (from above), 1-7: bottom half 0.66 left -> far hand (from below), 15-21: full reps 0.63 right
  -> near elbow (the leader runs up just outside the near hip), No leaning back 0.72 right -> near
  hip joint. The two far-hand leaders come from above and below and never cross; the elbows leader
  runs right of the top-half pill.
- EZ-Bar 21s (nearly front-on): 8-14: upper half 0.10 left -> far hand, 1-7: lower half 0.62
  left -> far hand, 15-21: all the way 0.71 left -> far elbow, Outer bends grip 0.63 right -> near
  hand, Elbows stay put 0.72 right -> near elbow. Front-on, the hands hang in front of the thighs,
  so the bottom leaders run up along the thighs' outer edges; the pills stay clear of the legs
  (left ends <= 0.36, right starts >= 0.67).
- Waiter Curl: Keep it upright 0.24 left -> far hand (from above), Flat open palms 0.64 left ->
  far hand (from below; the leader crosses the dumbbell, which is equipment), Stand still 0.16
  right -> head (passing above the near shoulder), Elbows at sides 0.40 right and Arms stay bent
  0.56 right -> near elbow. Left pills are kept to <= 15 characters so they end left of the
  dumbbell (x >= 0.33).
- Seated Dumbbell Curl: Back on the pad 0.12 left -> far shoulder, Lower slowly 0.195 left -> far
  elbow, Palms turn up 0.26 left -> far hand (above the far dumbbell's highest point, ~0.33; 0.27
  left the pill ~3 pt above the plate at the top, so it went up a step in review; the
  order keeps the two lower leaders from crossing), Elbows down 0.30 right (right of the back pad,
  above the near dumbbell's highest point, 0.33) -> near elbow, Arms almost straight 0.69 right
  (over the static bench strut, below the near dumbbell's lowest point, 0.65) -> near hand.

## Ghosts

Measured with the port at the fault's moment (pull: top = elbows most bent, bottom = straightest,
from the first 4 s; the 21s' later blocks given in seconds). Torso 0.592 m. Sizes in points are
in the 382x655 viewport at the fault's view.

- Strict Curl (framing -1.0; only hips turns): hips `curls500HipsOffWall(0.18).seen(-0.45)` (the
  pelvis ~11 cm forward off the pad, ~24 pt, the trunk 5° -> 15° behind vertical, the knees locking;
  top). Turned to a near side view (-1.45) after round 1, where from the framing the shift read only
  as a slightly different stance; a full side view would put the near plate face-on over the upper
  body, which is why the other Strict faults keep the framing. shoulders
  `curls500UpperBackOffWall(15)` (the upper trunk folded 15° about the mid-spine, the head ~15 cm
  and shoulders ~11 cm forward, the bar ~8 cm with them; top); elbows `elbowsForward(35, withBar:
  true)` (~17 cm, ~38 pt; top); knees `curls500KneeDip(0.07)` (hips ~4 cm down the wall, knees 174°
  -> ~144°, ~10 cm forward; bottom); range `curlBottomCut(from: 0.8, to: 0.89)` (175° -> ~130°;
  bottom).
- 21s Curl (framing -0.9, no turn: at a side view the plates face the camera): bottom
  `curlBottomCut` (176° -> ~131° at the bottom; none in the top half, where the arms never pass
  ~122°); top `elbowsFolded(.lateral, -40, .withBend)` at 16.9 s (90° -> 130°, the hands ~17 cm,
  ~39 pt lower; it fades toward straight, 127° -> ~151° at 0.4 s, and never passes straight, but
  while the clip plays it also shows in the other blocks at full strength once the elbows pass 90°:
  the bottom-half reps topping out at ~130° and the full reps stopping near level. No
  FaultStrength peaks at level alone, and a turn kept strong at straight arms would push the
  forearms past straight, so this is left as it is); full `curlStoppedShortOfTop(from: 0.6, to:
  0.45)` at 30.9 s (52° -> 92°, ~36 pt; zero until the elbows pass ~80°, so never in the bottom
  half; in the top-half reps it shows them stopping near level too); elbows
  `elbowsForward(35, withBar: true)` at 17.8 s (a top-half top); torso `bodySwung(withBar: true)` at
  40.9 s (a late full rep's top: hips 0.06 forward, trunk 0° -> 19° back, head ~31 pt).
- EZ-Bar 21s (framing -0.4, every fault turned -0.5 to the 21s Curl's -0.9): grip
  `curlWristsCurled(withBar: true)` at 17.8 s (hand tips ~10 cm, ~22 pt); bottom, top, full as the
  21s Curl (top: ~50 pt); elbows `elbowsForward(35, withBar: true)` at 40.9 s. Round 1 used -0.9
  (total -1.3, the Dumbbell Curl's turn): there the plates face the camera and cover the arms.
- Waiter Curl (framing -0.5, turned -0.8 to -1.3): upright `curlWristsCurled(degrees: 50)` (the
  hand tips ~8 cm, ~23 pt up toward the face; top); elbows `elbowsForward(30)` (~15 cm; top); range
  `elbowsFolded(.lateral, -55, .whenStraight)` (at 150°, strength 0.67: the hands swing ~37° down
  and back, ~15 cm toward the thighs; the forearms angle in to the plate, so the elbow angle only
  opens to ~155° but side-on the forearms line up with the upper arms; bottom); torso
  `bodySwung(withBar: false)` (top). The palms cue has no ghost (the hands' place on the plate;
  the rig draws no fingers): it falls back to the red ring.
- Seated Dumbbell Curl (framing -0.6, turned -0.7 to -1.3): back `curls500SeatedOffPad(25)` (the
  trunk ~22° forward at the bottom, from 17° back to ~5° forward, head ~27 cm, ~61 pt; bottom);
  palms `curlWristsCurled()` (top); elbows `elbowsForward(30)` (top); range `curlBottomCut(from:
  0.8, to: 0.89)` (170° -> ~127°; bottom). Lower (speed) has no ghost.

The new pieces (`curls500HipsOffWall`, `curls500UpperBackOffWall`, `curls500KneeDip`,
`curls500SeatedOffPad`) move only drawn points, so no dashed guide is left without a limb; the
knee dip leaves the arms out for that reason. The faults file typechecks (`xcrun swiftc
-typecheck` on a copy of FaultPoses.swift with the pieces and table pasted) and builds in the lab.

## Lab rounds

- Round 1 (`lab500.sh shoot curls "0,1.4,3"`, 21:00): builds; trainer labels clear of the plates,
  dumbbells and buttons at all stills. Fixed after it: the EZ-Bar 21s faults were turned to -1.3
  (the Dumbbell Curl's view), where the plates face the camera and cover the arms -> -0.9; the EZ
  top-half pill at 0.07 ran under the mistake banner -> 0.10; the Strict hips ghost read only as a
  slightly different stance from the framing -> turned to -1.45.
- Round 2 (`lab500.sh shoot curls "0,1.4,16.9,30.9"`, 21:24): builds; the 21s trainer stills at
  16.9 s (top-half level pause) and 30.9 s (full-rep top) keep every pill clear of the near plate
  at its highest; the EZ faults at -0.9 show the bent, sunk, short and forward arms clear of the
  plates; the Strict hips ghost shows the pelvis ~24 pt off the edge-on wall. (The 8 s clips were
  also shot at 16.9 / 30.9 s, which only repeats their loop.) Output: `SCRATCH/lab/curls/`.

- Round 3 (review, `lab500.sh shoot curls "0,1.4,16.9,30.9"`, 22:02): builds; after the review
  fixes below. The Strict hips leader runs up the back of the near thigh to the near hip; the
  Seated palms pill clears the far dumbbell by ~9 pt at the top; ghosts unchanged. Output:
  `SCRATCH/lab/curls/`.

## Review (2026-10-04)

An independent sources and model review of the four files.

- Sources: every PMID, DOI, author list, journal and year checked against its Europe PMC record
  (all 13 correct); the claims checked against the abstracts and the full texts of Pinto 2012,
  Sato 2021, the two Coratella 2023 papers and Marcolin 2018 (the bars, not only the EZ bar, beat
  dumbbell curls for brachioradialis in the lifting phase). The web sources were re-read: MCCS
  rules, Dale (FitnessVolt), Williams (Men's Health via AOL), DiGiovanni (Set For Set), Nobbe
  (Garage Gym Reviews), Saini (FitnessVolt) and ExRx's Barbell and Dumbbell Curl on the Wayback
  Machine; each says what the notes quote.
- Changed: the full-range line now says mid-range partial reps (Pinto's partials were 50-100°,
  and the library's Dumbbell Curl words it that way), and the 21s' and EZ-Bar 21s' full-rep lines
  no longer say partial reps alone, which read as a claim against the 21s' own halves; the 21s'
  and EZ's lower-half lines say the lower part of the range rather than this lower range (Sato
  and Pedrosa trained 0-50° and 0-68°, not the 21s' 4-90°); the Strict hips line says the elbow
  flexors have to lift the bar (not on their own: the shoulders still steady it); the EZ grip
  mistake says near the top, matching its ghost (17.8 s) and the library's wrist faults; the
  Waiter palms sit flat under the plate (cup contradicted Saini's flat hands) and its arms stay
  bent at the bottom rather than slightly bent (150°, the forearms 50° below level); the Strict
  triceps sit 3-5 cm off the pad (2.6 cm at mid-curl, re-measured with strict.py).
- Labels: Strict hips -> near hip (thigh_L) instead of the pelvis; Seated palms 0.27 -> 0.26.
  Checked and kept: the EZ-Bar 21s' lower leaders run up the outer edges of the thighs at the
  -0.4 framing, as the library's front-on Dumbbell Curl's do; the plates sweep both sides from
  ~0.15 to ~0.58, so no row reaches the arms from the side, and shorter labels would move the
  leaders by under 0.02. The 21s' No leaning back leader to the near hip and the Waiter's Keep it
  upright leader along the far arm at the bottom follow the same house pattern.
- Ghosts: all 23 stills checked; each shows its named mistake, attached and possible. The 21s'
  (and EZ's) top-half ghost also shows in the other blocks while the clip plays (see Ghosts);
  left as it is, documented in the table comment. The 21s' torso ghost is cluttered by the arms
  and bar at -0.9 but is the Barbell Curl's own view (-0.4 framing, -0.5 turn).
