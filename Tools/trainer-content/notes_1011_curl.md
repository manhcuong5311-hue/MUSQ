# Desktop "100-200" folder: concentration curl (2026-10-11)

The folder's one new exercise: 237 Concentration Curl (model `Biceps/ConcentrationCurl.usdc`,
already converted, in the library rows and the model map with its framing, yaw -1.2, zoom 1.03,
and probed into `joints.json` by the coordinator). `spec_1011_curl.py` holds the copy and setup
steps (its header lists what the model shows and the full citations),
`Tools/fault-review/faults_1011_curl.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_1011_curl.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on.

## How the model was read

- The arm brief (`$LAB/r1011/briefs/ConcentrationCurl.md`), the paint (`tiers31_new.json`,
  Biceps/ConcentrationCurl), `joints.json`, and the reference stills in `var/conc_t*` (a
  provisional framing, used only for a first look).
- The rig straight from the USD with Blender's Python + pxr, scripts in `$LAB/r1011/curl/`:
  `rig.py` (a reader: joint world transforms, equipment bounds, UsdSkel-skinned mesh points),
  `reps.py` (both elbow angles every frame), `geo.py` (shoulder, elbow and wrist positions, upper
  arm and forearm angles, trunk lean, the stillness of everything but the left forearm),
  `contact.py` and `c2.py` (minimum distances between skinned meshes: triceps against the thigh
  muscles, the right hand against the knee, shoes against the floor, glutes and hamstrings
  against the seat, the dumbbell against the lower leg and the head), `palm.py` (palm normal
  against the elbow's flexion side, wrist bend, the dumbbell handle's axis), `lever.py` (the
  load's lever arm about the elbow: horizontal distance from the elbow joint to the handle's
  centre, every frame of the first curl), `top.py` (where the dumbbell ends at the top against
  the chin, the front deltoid and the shoulder joint).
- Labels: `preview_1011.py curl`, then `proj.py` + `overlay.py` (the skinned body, bright
  muscles, dumbbell and bench projected through the trainer framing with probe.py's camera, the
  eye button and legend boxed, gen.py's pills and leaders drawn), then the lab's trainer
  screenshots (see Labels).
- Ghosts: `ghost.py`, a Python port of `FaultGhost.solve` (body frame from the pelvis, neck and
  hips; shift / turn; withBend / between strengths; hand tips), run on the real joints at the
  fault's moment and projected through the framing. Then the lab's fault stills.

## Model facts

- One body: neck to pelvis 0.584 m, upper arm 0.288 m, forearm 0.250 m, shoulder joints 0.39 m
  apart. 7.96 s at 24 fps, two identical 4 s reps.
- Only the LEFT arm curls. Elbow 140°, leaving it at ~0.3 s; within 1° of 48° from ~1.29 s to
  ~2.08 s (within 0.3° from 1.33 to 2.04 s); back within 1° of 140° by ~3.58 s; still to ~4.3 s:
  up ~1.0 s, held ~0.7-0.8 s, down ~1.5 s (re-measured in the review; the draft's 1.1 / 0.6 /
  1.6-1.7 s used looser end points). The arm never straightens: the bottom is 40° short of
  straight.
- Bench: an adjustable bench set flat (both pads level, top 0.468 m up, 36 cm wide), its length
  running side to side under the lifter, who sits across it at the junction of the seat and back
  pads; the hip joints are 11 cm above the pad.
- Legs: ankle joints 0.66 m apart (shoe inner edges 0.54 m), the shoes 0.40-0.69 m in front of
  the hip joints, toes turned ~24° out (ankle-to-toe joints); heels (0.3 cm) and toes (0.6 cm) on the floor; knees 121°, hips
  54°. Still all clip.
- Trunk: 63° forward of vertical (neck over pelvis), still to the millimetre all clip. The upper
  back is rounded over the lower (pelvis-to-spine segment 40° from vertical, spine-to-chest and
  chest-to-neck 68°), so the copy says "lean forward over your thighs", not "back flat". The head
  is in line with the upper trunk (neck-to-head 25° above level, the upper trunk 22°).
- Working arm: the upper arm hangs 16° from vertical, the elbow 8 cm behind and 2 cm inside the
  shoulder joint; the shoulder and elbow joints move less than 0.5 mm all clip. The skinned
  triceps (long, lateral and medial heads) rests on the vastus medialis and sartorius at
  0.2-0.8 cm, just above the knee: the elbow joint is 8.5 cm above and 8.6 cm inside the knee
  joint. At the bottom the brachioradialis also brushes the thigh near the knee (0.1 cm).
- Grip: the handle runs side to side (90° to the forearm), held in its middle. The palm normal
  stays within 10° of the elbow's flexion side (palm fully up) at every sample, the wrist bend is
  0° (0.0-0.1°): no turn and no wrist movement. At the bottom the palm faces forward and up.
- Bottom: the forearm 65° below level, down and forward; the dumbbell hangs between the feet,
  1.2 cm inside the left lower leg at calf height (the dumbbell 17-30 cm off the floor).
- Top: the forearm 26° above level; the dumbbell's nearest point 8 cm from the head mesh, its top
  3.5 cm below the chin (the head mesh's lowest point ahead of the neck), the dumbbell's centre
  22 cm in front of and 13 cm below the shoulder joint, 12 cm from the front deltoid; the hand
  15 cm from the head.
- Free arm: the right hand cupped over the right knee (the skinned hand at 0.1-0.3 cm from the
  vastus lateralis and medialis, rectus femoris, sartorius and both gastrocnemius heads round the
  knee), the right elbow 69°, pointing out to the side (abducted ~58°). Still all clip.
- Load (lever arm about the elbow as a share of its peak): 0.42 at the bottom (140°), 0.75 at
  116°, 0.90 at 100°, peak 1.00 as the forearm passes level (elbow 72-77°), 0.95 at 56°, 0.90 at
  the top (48°), where the ~0.7-0.8 s hold is.
- Paint (tiers31_new.json): bright BicepsBrachii_LongHead, BicepsBrachii_ShortHead,
  Brachialis; dim Brachioradialis, ExtensorCarpiRadialisBrevis, ExtensorCarpiRadialisLongus,
  ExtensorCarpiUlnaris, ExtensorDigitorum, FlexorCarpiRadialis, FlexorDigitorumProfundus,
  FlexorDigitorumSuperficialis, PalmarisLongus; nothing faint.
- Framing (model map, not changed): yaw -1.2, zoom 1.03, offset (0.031, 0.278, -0.081): the
  lifter's left side faces the camera from the front-left, the head at the left of the frame, the
  bench running off to the right.

Where the model differs from coaching, the copy follows the model: ExRx and BarBend lower until
the arm is fully extended, the model stops at 140°. BarBend holds the free hand out to
counterbalance or grips the right knee or the bench; the model grips the knee, one of its
options.

## Sources

| Source | Used for |
|---|---|
| Young S, Porcari JP, Camic C, Kovacs A, Foster C. ACE study reveals best biceps exercises. ACE ProSource, August 2014. ACE-sponsored, not peer reviewed. PDF (acefitness.org/certifiednews/images/article/pdfs/ACE BicepsStudy.pdf, redirected to contentcdn.eacefitness.com) read in full; Figure 1 read off the rendered chart | 16 volunteers (8 men, 8 women, 18-24, "some form of weightlifting experience"), 70% of 1RM, EMG of biceps, anterior deltoid and brachioradialis, normalised to an isometric one-arm cable curl. Figure 1 (biceps, %MVC, read off the bars): concentration curl ~97, cable curl ~81, chin-up ~80, barbell curl ~77, EZ curl wide ~75, narrow ~72, incline ~71, preacher ~69, every other bar marked significantly different from the concentration curl. Text: "the concentration curl came out on top, eliciting significantly higher muscle activation of the biceps than any other exercise tested"; "for the AD, the incline curl, concentration curl and the chin-up had significantly less muscle activation than the barbell curl"; "This may be because during a concentration curl, the humerus is pressed against the leg and does not allow the upper arm to sway, which isolates the biceps." Porcari: other exercises call in the anterior deltoid, "it's almost natural to just swing your whole arm or shoulder forward". The article's photo shows a standing variant braced on a bench; the text does not say how the curl was done |
| ExRx.net, Dumbbell Concentration Curl (exrx.net/WeightExercises/Brachialis/DBConcentrationCurl, Wayback snapshot 2022-10-05; the live site returns 403) | Preparation: "Sit on bench. Grasp dumbbell between feet. Place back of upper arm to inner thigh. Lean into leg to raise elbow slightly." Execution: "Raise dumbbell to front of shoulder. Lower dumbbell until arm is fully extended. Repeat. Continue with opposite arm." Muscles: target Brachialis; synergists Biceps Brachii, Brachioradialis; stabilizers upper and middle trapezius, levator scapulae, obliques, erector spinae, wrist flexors. Its comment on the long head working more than the short head is not used |
| Polish A. Concentration Curl. BarBend, last updated 2024-11-27 (barbend.com/concentration-curl) | Sit on the edge of a bench with the knees far apart; brace the triceps against the left inner thigh; "Try to avoid wedging your elbow into your knee"; get the upper arm as perpendicular to the ground as possible and keep it stable; free hand held out to counterbalance, or "grip your right knee or the weight bench on your right side"; "Hold a strong contraction for a beat at the top"; lower with slow control to full extension (the model stops short); Curling Too Much: stop the curl once the triceps starts losing touch with the leg or the upper arm stops being perpendicular, rather than muscling the dumbbell up to the shoulder (the model's upper arm stays still to the top); Too Much Weight: needing to wedge the elbow, or a dumbbell that comes crashing down, means it is too heavy; FAQ: move up in weight only without unnecessary momentum. It also hinges with the spine neutral (the model's upper back rounds; the copy says nothing about the back's shape) |
| StrengthLog, Concentration Curl (strengthlog.com/concentration-curl, no date or author shown) | "Sit on a bench with a dumbbell in hand. Lean your elbow onto the inside of your leg."; lift by flexing the elbow, lower back; primary biceps, secondary forearm flexors |
| Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F, Cè E 2023. Biceps brachii and brachioradialis excitation in biceps curl exercise: different handgrips, different synergy. Sports 11(3):64. doi:10.3390/sports11030064, PMID 36976950 (abstract re-read on Europe PMC; full text read for the 500 curls) | Ten competitive bodybuilders, bilateral curls: biceps excitation greater supinated than pronated (+19%) and neutral (+12%) in the lifting phase; "biceps brachii is a supinator" (full text) |
| Schoenfeld BJ, Ogborn DI, Vigotsky AD, Franchi MV, Krieger JW 2017. Hypertrophic effects of concentric vs. eccentric muscle actions. J Strength Cond Res 31(9):2599-2608. doi:10.1519/JSC.0000000000001983, PMID 28486337 (abstract) | 15 studies: eccentric training gave a larger effect size, not significant (p = 0.076); mean growth 10.0% eccentric vs 6.8% concentric. Hence as much, or slightly more |
| Schoenfeld BJ, Ogborn DI, Krieger JW 2015. Effect of repetition duration during resistance training on muscle hypertrophy. Sports Med 45(4):577-585. doi:10.1007/s40279-015-0304-0, PMID 25601394 (abstract) | Eight studies, all training to muscle failure (an inclusion criterion): "hypertrophic outcomes are similar when training with repetition durations ranging from 0.5 to 8 s" |
| StrengthLog, Dumbbell Curl (strengthlog.com/dumbbell-curl, added in the review) | "Keep your wrists straight during the movement. If they're bent, it can put an unnecessary load on them" (the wrist cue's last clause) |
| Mogk JPM, Keir PJ 2003. The effects of posture on forearm muscle loading during gripping. Ergonomics 46(9):956-975. doi:10.1080/0014013031000107595, PMID 12775491 (abstract) | Gripping loads the forearm flexors and extensors; "A flexed wrist reduced maximum grip force by 40-50%" (activation row and the wrist cue's grip context only) |
| Kawakami Y, Nakazawa K, Fujimoto T, Nozaki D, Miyashita M, Fukunaga T 1994. Specific tension of elbow flexor and extensor muscles based on magnetic resonance imaging. Eur J Appl Physiol 68(2):139-147. doi:10.1007/BF00244027, PMID 8194543 (abstract) | MRI estimate: brachialis 47%, biceps 34%, brachioradialis 19% of elbow-flexor torque (a capacity estimate; activation rows only, no copy) |
| Boland MR, Spigelman T, Uhl TL 2008. The function of brachioradialis. J Hand Surg Am 33(10):1853-1859. doi:10.1016/j.jhsa.2008.07.019, PMID 19084189 (abstract) | Brachioradialis activity greatest in elbow flexion whatever the forearm position (activation row only) |

Searched and not used: Europe PMC "concentration curl" (29 hits; nine also match EMG or
electromyography, and only two of those measured muscle activity in the exercise. The rest:
three wearable-fatigue papers by Elshafei et al. that use the exercise as a test movement, and
four reviews or activity-recognition papers. The two: Krings et al.
2021, J Strength Cond Res 35(Suppl 1):S152-S157, PMID 30694963, fat grips cut 1RM but left the
concentration curl's EMG unchanged; Sevilmiş et al. 2024, Percept Mot Skills 131(5):1834-1860,
PMID 39214526, perceived vs measured activation, no per-exercise values in the abstract). Oliveira
et al. 2009 (J Sports Sci Med 8(1):24-29, PMID 24150552) compares standing, incline and preacher
dumbbell curls, not the concentration curl. So the ACE study is the only measurement of this
exercise's activation found, and it is not peer reviewed; the copy names it only as "one study".

## Activation

| Row | Value | Basis |
|---|---|---|
| Biceps Brachii P | 0.92 HIGH | bright. ACE 2014: the concentration curl drew significantly more biceps activity than all seven other exercises, including the barbell curl (~97% vs ~77% of an isometric cable-curl MVC). The library's highest biceps value is the Barbell Curl's 0.90 (Strict Curl and 21s the same), so 0.92 puts this lift a step above it. A judgement call on one non-peer-reviewed study; 0.90 would also be defensible (open point) |
| Brachialis P | 0.72 HIGH | bright. The house value for a bright brachialis (Machine Preacher Curl, the five 500 curls). ExRx lists the brachialis as this exercise's target (no EMG); Kawakami 1994 (capacity 47% vs biceps 34%). Kept under the biceps as the library does, since ACE measured the biceps highest here and no one measured the brachialis |
| Brachioradialis S | 0.44 MODERATE | dim. As the 1-50 Dumbbell Curl (a palm-up dumbbell curl); ExRx lists it as a synergist; Boland 2008 (active in elbow flexion in any forearm position). ACE measured it but reports no comparison involving the concentration curl. Judgement call |
| Forearms S | 0.30 LOW | dim (the wrist and finger flexors and extensors). The library curls' house value; the hand grips the dumbbell (Mogk and Keir 2003); ExRx lists the wrist flexors as stabilisers; StrengthLog the forearm flexors as secondary |

Legend lines: "BICEPS BRACHII · BRACHIALIS" (primary), "BRACHIORADIALIS · FOREARMS" (secondary),
as the 500 curls; checked on the lab shots. All four names pass `part_of()` (biceps, biceps,
forearms, forearms).

Stabilisers: "erector spinae", "obliques", "upper trapezius", "middle trapezius", from ExRx's list
(the wrist flexors are the Forearms row; levator scapulae left out to keep the list to four). The
erector spinae and obliques fit the model's 63° forward lean, which the trunk holds still.

## Claims

### Arm on the thigh (elbow, label "Upper arm on inner thigh" on upper_arm_L)

| Claim | Source |
|---|---|
| The back of the upper arm rests on the inner thigh, just above the knee, and stays there | ExRx ("Place back of upper arm to inner thigh"); StrengthLog; BarBend; the model (triceps on the vastus medialis and sartorius at 0.2-0.8 cm, the elbow joint 8.5 cm above and 8.6 cm inside the knee joint, still within 0.5 mm). "Just above the knee" also keeps it off the kneecap, which BarBend warns against |
| Pressed against the leg the upper arm cannot sway, so bending the elbow is the only motion | ACE ("the humerus is pressed against the leg and does not allow the upper arm to sway"); the model (only the left forearm moves) |
| In one study of eight biceps exercises this curl drew the most biceps activity, with less front-shoulder activity than the barbell curl; the researchers suggested the pinned upper arm was the reason | ACE 2014 (see Sources; "may be because"). "One study", because it is a single, sponsored, non-peer-reviewed study; "eight biceps exercises" because the chin-up is one of them |
| Mistake: the elbow lifting off the thigh and swinging forward as the dumbbell rises, so the shoulder helps lift it | ACE (Porcari: in other exercises the arm or shoulder swings forward and the anterior deltoid is called in); BarBend (keep the upper arm stable) |
| Let it hang almost straight down and move only the forearm | BarBend (upper arm as close to perpendicular to the ground as possible); the model (16° from vertical) |

Comparison (ELBOW OFF THE THIGH): the same sources. "The elbow flexors do the lifting" rather
than "the biceps alone": ExRx's target is the brachialis. Its correct note was reworded in the
review (the thigh holds the upper arm in place), since it repeated the cue's why nearly word for
word.

### Trunk position (torso, "Chest stays forward" on spine)

| Claim | Source |
|---|---|
| The chest stays leaning well forward over the thighs; only the forearm moves | The model (trunk 63° forward, still to the millimetre) |
| Sitting up or rocking back swings the dumbbell up with the trunk and pulls the arm off the thigh, so the trunk does part of the work through the middle of the curl, where the dumbbell pulls hardest | Mechanical reasoning on the model: the arm rides on the trunk, so tipping the trunk back swings the forearm toward level without the elbow bending, and the lever peaks as the forearm passes level (72-77°). No source measures a rocking concentration curl. The draft said the biceps skips the middle of the curl; softened in the review |
| Needing to rock is a sign the weight is too heavy | BarBend (move up in weight only without unnecessary momentum; needing to wedge the elbow or a crashing lowering means too heavy) |
| Lean forward over your thighs, brace your free hand on your right knee | The model (lean; right hand cupped over the right knee); BarBend (hold the free hand out, or "grip your right knee or the weight bench on your right side"). The draft said BarBend holds the free arm out instead; it gives the knee as an option |

### Top of the curl (top, "Pause at the top" on forearm_L)

| Claim | Source |
|---|---|
| Curl until the dumbbell is just under the chin, then hold it for a moment | The model (the dumbbell's top 3.5 cm below the chin, its nearest point 8 cm from the head; held ~0.7-0.8 s, 1.29-2.08 s); BarBend ("Hold a strong contraction for a beat at the top") |
| With the upper arm hanging down, the dumbbell pulls hardest as the forearm passes level and still at about nine-tenths of that at the top | The model's lever (peak at 72-77°, 0.90 at 48°) |
| So the last part is still hard work; stopping at level leaves it out | Reasoning from the lever. No claim about muscle length or growth is made: the range-of-motion studies cited by the library's curls trained preacher curls, whose load curve differs |
| Curl toward the front of the shoulder until the dumbbell is just under the chin, the upper arm still on the thigh, pause for a beat | ExRx ("Raise dumbbell to front of shoulder"); BarBend (hold for a beat; stop the curl once the triceps starts losing touch with the leg rather than muscling the dumbbell up to the shoulder); the model (the dumbbell's centre 22 cm in front of the shoulder joint, under the chin; the upper arm still to the top; ~0.7-0.8 s hold). The draft said about half a second, short of the model's hold, and did not mention BarBend's Curling Too Much advice; the clause about the upper arm reconciles the two |
| Mistake: turning each rep round with the forearm at or just below level, well short of the top | The ghost: the forearm ~14° below level (elbow ~88°). The draft said about level |

### Lowering (lower, "Lower slowly" on forearm_L; no ghost)

| Claim | Source |
|---|---|
| Lower more slowly than you lifted | The model (up ~1.0 s, down ~1.5 s); BarBend (lower with slow control) |
| In a review of training studies, lowering-only work built as much muscle as lifting-only work, or slightly more | Schoenfeld 2017 (15 studies; larger effect size for eccentric, p = 0.076; 10.0% vs 6.8%). The draft's sentence was the 500 curls' (Seated Dumbbell Curl) word for word; the library's Machine Preacher Curl words it about as much, or a little more |
| With sets taken to failure, rep durations from half a second to eight seconds built similar muscle, so lower under control | Schoenfeld 2015 (all eight studies trained to failure; the draft left that out and repeated the library's sentence) |
| Mistake: the dumbbell dropping so the arm snaps straight | BarBend (a dumbbell that comes crashing down is too heavy) |
| Up in about a second, down in about one and a half, stopping with the elbow still bent and the dumbbell just inside the left lower leg | The model (timing; bottom 140°; the dumbbell 1.2 cm inside the left lower leg). ExRx and BarBend lower to full extension; the copy follows the model and gives no reason for stopping short, as no source here gives one for this curl |

### Grip and wrist (wrist, "Wrist straight" on hand_L)

| Claim | Source |
|---|---|
| The forearm stays turned palm-up from bottom to top, the wrist straight | The model (palm within 10° of fully up against the forearm, wrist 0° at every sample). Forearm palm-up rather than the draft's palm turned up, which read against setup step 2 (palm facing forward at the bottom), as the library's Dumbbell Curl words it |
| The biceps both bends the elbow and turns the palm up; in competitive bodybuilders it has worked harder in palm-up curls than in palm-in or palm-down ones | Coratella 2023 Sports (ten competitive bodybuilders, lifting phase: +12% vs neutral, +19% vs pronated); the biceps' supination is anatomy |
| Letting the wrist curl in draws the dumbbell back toward the elbow, so the top of the rep gets easier, and a bent wrist can take an unnecessary load | Lever geometry (at the top the forearm points 26° above level, so folding the hand toward the palm moves the dumbbell back over the elbow); StrengthLog Dumbbell Curl (bent wrists, "an unnecessary load"). The draft's sentence was the library Dumbbell Preacher Curl's word for word |
| Hold the handle firmly in the middle, knuckles in line with the forearm | The model (gripped mid-handle); the library curls' house cue |

### Setup

| Step | Source |
|---|---|
| Sit on a flat bench, feet flat and wider than your shoulders | The model (flat bench; ankles 0.66 m apart against shoulder joints 0.39 m; heels and toes down); ExRx (sit on bench); BarBend (knees wide) |
| Pick up a dumbbell in your left hand, palm facing forward | The model (left hand; palm forward and up at the bottom); ExRx (grasp the dumbbell between the feet) |
| Lean forward and rest the back of your upper arm on your inner thigh, just above the knee | ExRx; the model |
| Brace your right hand on your right knee, the dumbbell hanging just inside your left lower leg | The model |
| Do every rep with the left arm, then switch sides | ExRx ("Continue with opposite arm"); the model shows the left arm |

## Distinct from the library

The Dumbbell Preacher Curl and Single-Arm Machine Curl rest one arm on a sloped pad in front of an
upright trunk (the library's preacher copy: the load is heaviest in the bottom half); the Spider Curl hangs both arms from
a chest pad; the Alternating Dumbbell Curl stands, palms turning up from facing in. Here the lifter
sits leaning 63° forward, one upper arm hanging almost straight down against the inner thigh, palm
up all rep, from a bent elbow (140°) to the dumbbell under the chin, and the load is heaviest from
the forearm passing level to the top. Cues: arm on the thigh, trunk, top and pause, lowering,
wrist.

## Library row

Concentration Curl, ARMS, BICEPS BRACHII / DUMBBELL / beginner (added with the model). It matches
the paint (the biceps the first bright muscle) and the activation (biceps first); no change
requested, although ExRx files the exercise under the brachialis.

## Labels

Final rows (after the squeeze; `ov()` sets them), sides and what each pill sits over, from the
overlay and the lab's trainer shots at 0, 0.75, 1.5 and 3 s. The dumbbell sweeps the left of the
frame from between the shins (bottom, ~0.55-0.63) through the left of the knees (0.75 s) to under
the chin (top, ~0.31-0.40), and the head sits at the upper left, so the left side only has room
above the head and below the feet. The record and eye buttons take the top right; the mistake
banner runs across the top middle (~0.03-0.065), so nothing sits above 0.12.

- Upper arm on inner thigh: 0.12 left, above the head, -> the near shoulder (upper_arm_L), the
  leader dropping over the upper trapezius, as the Dumbbell Preacher Curl's "Arm on the pad".
- Chest stays forward: 0.19 right, below the eye button and above the back, -> the spine joint
  in the middle of the back.
- Pause at the top: 0.53 right and Lower slowly: 0.63 right, over the static bench, -> the near
  elbow (forearm_L), the leaders crossing the near knee, as the Waiter Curl's two elbow pills.
- Wrist straight: 0.78 left, below the dumbbell's lowest point and the far foot, -> the near
  wrist (hand_L). Round 1 used "Palm up, wrist straight" (23 characters), whose leader started at
  x 0.435 and ran up along the far shin to the hand at the top; the shorter label starts it at
  x 0.30, left of the far shin, so it crosses only the far ankle. A leader from below has to pass
  the feet: the hand is between the shins at the bottom.

## Ghosts

Measured with the port at 1.6 s, the middle of the top hold (sizes in points of the 382x655
viewport at the framing; the mistake view shrinks the model further). No fault turns: at yaw -1.2
moves in the lifter's front-back plane show at ~93% of their length.

- elbow `curlArmsOffPad(30, side: "L")`: the upper arm swung 30° forward about the shoulder (16°
  behind vertical to 14° in front), the elbow ~15 cm (~48 pt) forward off the thigh, the hand
  ~11 cm; drawn to the wrist. Round 1 used 25° (~40 pt), which read but was the faintest ghost
  of the four.
- torso `preacherRockedBack(18, side: "L")`: the trunk tipped back 18° about the hips (63° to
  45°), the head ~21 cm (~68 pt), the left arm carried with it (its elbow ~12 cm up off the
  thigh). The piece moves only what it draws (spine and the working arm), so the right hand stays
  on the knee with no dashed guide.
- top `curlStoppedShortOfTop("L", from: 0.6, to: 0.42)`: the forearm unfolded 40° (48° to ~88°,
  the forearm ~14° below level), the hand ~17 cm (~60 pt) lower; zero above elbow ~81°, so it
  shows only over the top of the curl.
- wrist `curlWristsCurled("L", degrees: 60)`: the hand tip folded 60° toward the palm, ~12 cm
  (~39 pt) toward the chin. Round 1's 50° read as a slight kink in the shrunken mistake view.
- lower: tempo, no ghost (red ring).

All four reuse existing pieces, so the PIECES section is empty. Moments (fault_moments_1011_curl.json):
1.6 s for all four (fault_times.py would pick 1.5 for "top"; given in seconds so a re-run cannot
drift to the edge of the hold).

## Lab rounds

- Round 1 (`family_1011.sh shoot curl "0,0.75,1.5,3"`, 16:43): builds; the trainer stills show
  every pill clear of the dumbbell at all four moments and clear of the buttons; the four ghosts
  read. Changed after it: the wrist label shortened (its leader ran along the far shin), the
  elbow ghost 25° -> 30°, the wrist ghost 50° -> 60°.
- Round 2 (`family_1011.sh shoot curl "0,0.75,1.5,3"`, 16:47): builds. The Wrist straight
  leader now runs up left of the far shin to the hand at the top and crosses only the far
  ankle at the bottom; the other pills unchanged and clear of the dumbbell, the buttons and the
  legend at all four stills. The elbow ghost shows the upper arm angled forward with the elbow
  ~45 pt off its place on the thigh; the wrist ghost tips the fingers up toward the chin; the
  trunk and top ghosts as round 1. In the mistake views the model shrinks and rises, so the
  active cue's pill can overlap the head top (elbow) or the back (torso), as on other lifts.
  Output: `$LAB/r1011/curl/round1`, `round2`.
- After round 2 only copy changed (the trunk cue's correct line says "lean forward over your
  thighs", since the model's back is rounded, not hinged flat); `family_1011.sh check curl`
  compiled it (see Self-review).

## Self-review (2026-10-11)

- Sources: every web source re-opened this session (the ACE PDF, text and Figure 1; ExRx's
  2022-10-05 snapshot; BarBend; StrengthLog) and every PMID/DOI checked against its Europe PMC
  record (Coratella 2023, Schoenfeld 2017 and 2015, Mogk and Keir 2003, Kawakami 1994, Boland
  2008). The ACE values are read off a bar chart (about +-1 point) and are used only in the code
  and notes; the copy says "one study", "the most biceps activity" and "less front-shoulder
  activity than the barbell curl", which the ACE text states. Nothing in the copy relies on the
  long-head comment (ExRx) or on any claim about muscle growth from this curl.
- Model fidelity: left arm only, two identical reps, elbow 140° -> 48°, the top held ~0.6 s,
  lowering slower than lifting, the trunk still at 63°, the upper arm on the inner thigh just
  above the knee, the free hand on the right knee, the palm up and the wrist straight all rep,
  the dumbbell under the chin at the top and inside the left lower leg at the bottom: each is in
  the copy or setup as measured. The copy never says to straighten the arm or to hold the free
  arm out (coaching the model does not follow), and never says "back flat" (the model's upper
  back is rounded).
- Labels: five pills, none on the lifter's body in the trainer view or on the moving dumbbell at
  0, 0.75, 1.5 or 3 s; leaders cross the upper trapezius (upper arm), the back (trunk), the near
  knee (both elbow pills) and the far ankle (wrist), the least the frame allows.
- Ghosts: four, each the named mistake, attached at the shoulder, hips, elbow or wrist, bone
  lengths kept; the tempo cue falls back to the red ring.


## Review (independent, 2026-10-11)

An independent review of the four files, sources first, then the model, labels and ghosts.
Scripts, fetched pages and the pre-review files are in the session scratchpad's `rev1011/`
(`src/`, `m2.py`, `dups.py`, `before/`).

- **Sources.** All eight Europe PMC records re-opened through the REST API (Coratella 2023,
  Schoenfeld 2017 and 2015, Mogk and Keir 2003, Kawakami 1994, Boland 2008, and the two
  searched-and-not-used papers Krings 2021 and Sevilmiş 2024, plus Oliveira 2009). Authors, year,
  journal, volume, issue, pages, DOI and PMID are right in every citation, and each abstract says
  what the notes use it for. The Europe PMC search was re-run: 29 hits for "concentration curl",
  9 of them also matching EMG or electromyography (the draft said five; only Krings and Sevilmiş
  measured activity in the exercise, as the draft said). The ACE PDF was fetched again
  (contentcdn.eacefitness.com; the acefitness.org link now returns 403 without a browser user
  agent) and read in full: authors, 16 subjects (8 men, 8 women, 18-24, some weightlifting
  experience), 70% of 1RM, the isometric one-arm cable-curl MVC, Figure 1's bars (~97, 81, 80,
  77, 75, 72, 71, 69; every other bar starred against the concentration curl), the anterior
  deltoid result (incline, concentration and chin-up below the barbell curl) and the humerus
  pressed against the leg explanation all as quoted. The photo is a standing, bench-braced
  variant, as the notes say. ExRx's Dumbbell Concentration Curl was fetched from the Wayback
  Machine at the cited snapshot (20221005113622): preparation, execution, the long-head comment
  and the muscle lists all as quoted. StrengthLog's Concentration Curl was fetched live: as
  quoted. BarBend was fetched live (Alex Polish, last updated 2024-11-27). Two things in the
  draft were wrong or missing:
  - BarBend does not only hold the free arm out. It says to hold the empty hand out to
    counterbalance, or to "grip your right knee or the weight bench on your right side". The
    model's hand on the knee is one of BarBend's options. Corrected in the header, Model facts,
    the BarBend source row and the trunk table.
  - BarBend's Curling Too Much section (stop the curl once the triceps starts losing touch with
    the leg or the upper arm stops being perpendicular, rather than muscling the dumbbell up to
    the shoulder) was not mentioned, although the top cue calls stopping at level a mistake. The
    model's upper arm stays still all the way to the top, so the two do not conflict. The top
    cue's correct line now says to curl until the dumbbell is just under the chin with the upper
    arm still on the thigh, and the notes cite the section.
  Also tightened in the BarBend row: "Hold a strong contraction for a beat at the top", the
  crashing-lowering and unnecessary-momentum lines (the too-heavy claims), the neutral-spine
  hinge (the copy says nothing about the back's shape). The torso table no longer cites the 21s'
  DiGiovanni, which this family did not read.
- **Copy changed.**
  - Repeats: a script (`rev1011/dups.py`) compared every sentence of the copy with SampleData.swift,
    every `spec*.py` and setup.py. Three sentences were word for word the library's. Two were
    the Seated Dumbbell Curl's tempo lines (500 curls). The third was the Dumbbell Preacher
    Curl's wrist line. All three are reworded, and the script now finds no shared sentence. Two
    nine-word house phrases (the Coratella clause and the Seated Dumbbell Curl's tempo intro)
    were reworded too. The comparison's correct note, which repeated the elbow cue's why nearly
    word for word, now says the thigh holds the upper arm in place.
  - Lowering why: Schoenfeld 2017's effect size favoured eccentric work (10.0% vs 6.8%, p =
    0.076), so the copy now says lowering-only work built as much muscle as lifting-only work,
    or slightly more, as the library's Machine Preacher Curl does. Schoenfeld 2015 only included
    sets taken to muscle failure, so the 0.5-8 s line now says so; the draft left that out.
  - Wrist why: the bent-wrist load is now cited to StrengthLog's Dumbbell Curl (keep the wrists
    straight; bent, "it can put an unnecessary load on them"), fetched in the review and added to
    the sources. The draft cited the library's wording instead of a source. The copy keeps
    StrengthLog's can. The intro now says the forearm stays turned palm-up. The draft said the
    palm stays turned up from bottom to top, which read against setup step 2 (palm facing
    forward at the bottom, as the model shows); the library's Dumbbell Curl words it this way.
  - Torso why: the biceps skips the middle of the curl is softened to the trunk does part of the
    work through the middle of the curl, where the dumbbell pulls hardest (mechanical reasoning,
    unmeasured).
  - Top: the pause is now for a beat (BarBend's phrase). The draft said about half a second, but
    the model holds 0.7-0.8 s. The mistake now says at or just below level to match its ghost
    (forearm ~14° below level, elbow ~88°); the draft said about level.
- **Model re-measured** (`rev1011/m2.py` on the rig with Blender's Python, reusing only the
  author's joint reader; `top.py` and `palm.py` re-run):
  - Elbow 48.0-140.0°, two identical reps (5.5 s 48°, 7.0 s 109°, as rep 1).
  - Timing: leaves 140° at ~0.3 s, within 1° of 48° from 1.29 to 2.08 s, back to 140° by
    ~3.58 s. So up ~1.0 s, hold ~0.8 s, down ~1.5 s. The draft gave ~1.1 / ~0.6 / 1.6-1.7 s,
    from looser end points. The header and Model facts are corrected. The copy's "about a second"
    and "about one and a half" fit.
  - Body: upper arm 16.4° from vertical, the elbow 7.8 cm behind and 2.2 cm inside the
    shoulder; trunk 62.9° (neck to pelvis 0.584 m); the elbow joint 8.5 cm above and 8.6 cm
    inside the left knee joint; shoulders 0.392 m and ankles 0.660 m apart; knees 121°; right
    elbow 68.7°, right hand joint 11 cm from the right knee joint; every joint but the left
    forearm and hand still (≤0.4 mm).
  - Lever, as a share of its peak: 0.42 at 140°, 0.75 at 116°, 0.90 at 100°, ~1.0 at 67-83°,
    0.95 at 56°, 0.90 at 48°, as the notes say.
  - Palm within 10° of fully up and the wrist 0.0-0.1° at every sample.
  - At the top the dumbbell's nearest point is 8.2 cm from the head mesh, its top 3.5 cm below
    the chin's lowest point. The draft's inner plate 8 cm below the chin is corrected, and just
    under your chin holds.
- **Activation kept.** It matches the paint: biceps and brachialis bright (primary), the
  brachioradialis and the wrist and finger muscles dim (secondary). Levels match the fractions.
  Biceps 0.92 is the only curl above the library's 0.90 (Barbell, Strict and 21s; the other
  dumbbell curls are 0.84-0.88). It rests on ACE alone, a non-peer-reviewed study whose
  concentration curl was ~20 points above the barbell curl, so a step above is a fair judgement;
  left as the author's open point. Brachialis 0.72 and Forearms 0.30 are the house values;
  Brachioradialis 0.44 is the Dumbbell and Waiter Curls' value.
- **Labels kept.** Pills and leaders were checked on the round-2 shots (enlarged) and on the
  review's own shots below. No pill touches the lifter, the dumbbell, the buttons or the legend
  at 0, 0.75, 1.5 or 3 s.
  - Pause at the top clears the near calf by ~5 pt at the bottom of the rep and sits on the
    static bench pad.
  - Both elbow leaders cross the near knee.
  - The wrist leader crosses the far foot and runs along the outer edge of the far shin when the
    hand is up. A pill on the left between the head and the dumbbell's path would put its leader
    across the face and forearm, so the bottom-left row stays.
  - The upper-arm pill's leader runs to the shoulder over the trapezius (Dumbbell Preacher Curl
    precedent); a leader to the elbow would cross the shoulder and biceps.
- **Ghosts kept.** All four were re-run on the author's port (`ghost.py`, checked against
  FaultGhost.swift: `.lateral` is -left, and withBend and between strengths are as in the Swift)
  at 1.6, 1.0 and 2.6 s. Bone lengths are kept (0.288 / 0.250 m), no elbow bends backwards, and
  the sizes match the table comments:
  - elbow 14.9 cm (48 pt);
  - torso: head 21.4 cm (68 pt), trunk 45°, elbow 12.0 cm;
  - top: hand 17.1 cm (60 pt), elbow 88°;
  - wrist: tip 11.7 cm (39 pt), fold 60°.
  Each lab still shows its named mistake and stays attached. The top ghost's table comment now
  says at or just below level, like the copy.
- **Lab.** Review round 1 (`family_1011.sh shoot curl "0,0.75,1.5,3"`, 17:02) built; the trainer
  stills and the four fault stills were unchanged in layout, and the top mistake's new text fits
  its sheet in two lines. Review round 2 (17:04, after the last edits, the ghost comment
  included) built; all eight stills inspected enlarged: the same layout, every pill clear, each
  ghost its named mistake. Output: `$LAB/curl/` (round 1 kept in the scratchpad's
  `rev1011/lab_round1/`).
- **Shared items checked.** ExerciseRotation files "Concentration Curl" as `.armCurl` (no
  earlier rule matches "concentration": no row, press, raise or squat), so no movement-pattern
  change is needed. fault_times.py in the mirror gives top 1.50, and the moments file pins all
  four cues at 1.6 s (stilled at 1.62).
