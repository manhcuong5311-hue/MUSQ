# 351-400 folder: leg curls (2026-10-01, revised after review the same day)

Six knee-flexion curls from the builder's 356-400 set: 369 Standing Leg Curl, 370 Kneeling Leg
Curl, 371 Cable Standing Leg Curl, 373 Swiss Ball Leg Curl, 374 Sliding Leg Curl and 375
Single-Leg Sliding Curl (models `Legs/<Name>.usdc`). `spec_400_legcurl.py` holds the copy and
setup steps (its header lists what each model shows and the full citations),
`Tools/fault-review/faults_400_legcurl.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_400_legcurl.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The motion briefs (`SCRATCH/briefs_legs/<Resource>.md` for knee, hip, ankle and trunk angles,
  `SCRATCH/briefs/<Resource>.md` for the arms), every 0.5 s; the trainer stills at 0/1/2/3/5 s
  (`SCRATCH/shots/view/<slug>_t*.png`); `tiers27.json`; `joints.json`.
- The rigs, equipment prims and skinned bodies straight from the USD with Blender's Python +
  pxr (`SCRATCH/legcurl/eq.py` for equipment bounds at 0 and 2 s, `skin.py` for the lowest
  skinned points of the seat and shorts).
- Label layout: `preview_400.py legcurl` plus the pills (~24 + 6.4 pt per character, 28 pt
  tall), leaders and dots drawn over the five stills with the app's edge clamp
  (`SCRATCH/legcurl/overlay.py`), with the eye button (top right, to 84 pt) and legend (bottom
  left, from 610 pt) boxed.
- Ghosts: a Python port of `FaultGhost.solve` (`SCRATCH/legcurl/ghost.py`: the same body
  axes, shift / turn / straighten / resolve, strengths and tips) run on the real joint
  transforms at the fault's moment and projected with each framing plus the fault's `view`
  (`faults.py` measures, `glines.py` + `gdraw.py` draw them over the stills).
- Revision after review (2026-10-01): `SCRATCH/legcurl_rev2/v.py` measures the changed ghosts
  (the cable trunk, the kneeling lean at 18°, the sliding hips' new strength, the free-leg
  kick), `g2.py` draws them over the stills (`ghosts_rev2.png`), and `overlay.py` redraws the
  changed labels; Gulgosteren 2025's Fig. 1B image and the Youdas 2015 values (Macadam and
  Feser 2019, Table 2) were read directly.

## Shared facts about the models

- One body (torso, neck to pelvis, 0.592 m). Every clip is 7.96 s with two identical reps:
  still to 0.38 s, the curl ~1.1-1.2 s (to ~1.55 s), the top held ~0.65 s (to 2.25 s), the
  return ~1.25 s (2.29-3.54 s), still at the start to 4.38 s, then again. The tempo cues
  (curl in about a second, a brief hold, at least as long on the way back) describe that.
- The three upright curls work the LEFT leg (the copy says so); both floor curls with two
  sliders or the ball use both legs; the Single-Leg Sliding Curl works the LEFT leg with the
  RIGHT held up.
- Highlight tiers (`tiers27.json`): bright (1.0, 0.06, 0.01) = BicepsFemoris,
  Semimembranosus, Semitendinosus on all six -> PRIMARY "Hamstrings". Dim (0.26, 0.02, 0.01)
  = GastrocnemiusLateral/Medial and Soleus on the Standing and Kneeling curls ->
  SECONDARY "Gastrocnemius"; the same plus GluteusMaximus/Medius/Minimus on the Swiss ball
  and both sliding curls -> SECONDARY "Gluteus Maximus" and "Gastrocnemius"; on the Cable
  Standing Leg Curl the calves and glutes are only faint (0.11, 0.01, 0.01) -> two LOW
  secondary rows, "Gastrocnemius" and "Gluteus Medius", and the gluteus maximus named among
  the stabilisers. All names pass `part_of()` (hamstrings, calves, glutes). The legend lines
  stay short: "GLUTEUS MAXIMUS · GASTROCNEMIUS" is 31 characters.
- Gastrocnemius values: no gastrocnemius EMG exists for any of these six exercises. The
  values follow the library (Lying Leg Curl 0.46, Seated Leg Curl 0.40) and the paint, and
  the split between them is a judgement call, not evidence: the two machines 0.40 MODERATE
  (the toes stay pointed at 114°, and Lisboa 2026 saw less gastrocnemius swelling with the
  toes pointed than with the ankle neutral, so no higher than the lying curl); the two
  sliding curls 0.36 LOW (the ankles flex to 79° at the top, and ExRx says dorsiflexion lets
  the gastrocnemius assist); the cable curl 0.34 LOW (ankle near neutral, 99°, but faint
  paint); the Swiss ball 0.30 LOW (the toes pointed hard, 154° -> 142°). Li 2002 (its
  knee-flexion moment greatest with the knee straight, little at 90° and 75°) says nothing
  about ranking one exercise against another and is no longer cited for these values.
- Framings (the model map): the upright curls side-on from the front-left at yaw -1.3 (about
  15° short of a true left side view, the front a little toward the camera), the floor curls
  at -1.35; zooms 0.901 / 0.815 / 0.921 / 0.603 / 0.507 / 0.511. At -1.3 the two machines'
  pivot disc, on the outside of the axle 0.4 m nearer the camera than the knee, shows ~36 pt
  behind the knee in the trainer view, so the Knee on the pivot dot sits just in front of the
  disc's rim although the knee is on the pivot's axis in 3D (a true side view, -1.57, would
  line them up; the model map is outside this family). The pivot fault ghosts turn -0.3 to
  that side view.

## Standing Leg Curl

Model facts: standing on the RIGHT foot on a foot platform (right knee 165°, the foot flat),
the chest on a chest pad (1.16-1.42 m up), forearms on two arm pads, hands on the handles
(elbows 86°), trunk 8° forward and still. The left thigh hangs straight down (hip 172°) and
never moves; the left knee goes 173° -> 73°, so at the top the lower leg points 17° above
level and the ankle is 12 cm above the knee. The left knee joint sits on the lever's pivot
(knee 0.511 m up at z 0.000; the hinge axle, outside the left leg, centred 0.51 m up at z 0.00).
The ankle roller rides behind the lower leg ~7 cm above and ~9 cm behind the ankle joint. No
thigh pad is modelled: ExRx's machine has an upper pad in front of the lower thigh, which
normally stops the knee drifting forward (the pivot cue's fault). The chest pad sits inside
the chest in the model (only a sliver shows); the copy's intent is unchanged.

| Claim | Source |
|---|---|
| Chest and forearms on the pads, upper body still, only the lower leg moves; no swinging | StrengthLog, Standing Leg Curl (grip the handles, keep the upper body still, avoid swinging); ExRx Lever Standing Leg Curl (bend over and grasp handles); the model (trunk still, chest on the pad) |
| Almost straight to past level; pause, lower until almost straight | StrengthLog (pause briefly at the top, slowly lower); ExRx (pull the lever up to the back of the thigh, return until the knee is straight); the model (173° -> 73°, so most of the knee's range, not all of it) |
| With the hip straight the hamstrings are short at the top, one reason the end can feel hardest | ExRx comment: a bent-over posture potentially further decreases the active insufficiency of the hamstrings at the completion of knee flexion (hedged; on a machine the cam profile also sets where it feels hardest, hence "one reason ... can") |
| Roller just above the heel, on the firm lower leg rather than the calf | StrengthLog (pad just above the heel of the working leg) is the placement source. With the knee on the pivot, the knee torque equals the lever's torque wherever the roller sits (force x distance is the same about the knee and the pivot), so placement changes where the roller presses and comfort, not the load; the copy says only that |
| Knee in line with the pivot; off it the roller slides along the leg | StrengthLog, Lying Leg Curl (knees in line with the machine's joint; the most important adjustment); the model (knee on the axle's axis); the same fact as the library's Lying/Seated/Single-Leg Curl knee cues |
| Right foot flat, knee soft, body weight on it; bobbing up off the right heel with each curl is the mistake | ExRx (stand with body weight shifted onto the resting leg's foot); StrengthLog (needs a bit more balance; controlled, no swinging); the model (right knee 165°, the foot flat all clip). No source names rising onto the standing toes, so the mistake is worded as bobbing off the resting foot, which the two sources rule out |
| Comparison (rocking back swings the heel with momentum) | StrengthLog (avoid swinging to maximise hamstring activation) |

Activation: Hamstrings PRIMARY 0.90 (ExRx target; the library's Lying and Single-Leg Curl use
0.90). Gastrocnemius SECONDARY 0.40 MODERATE: ExRx synergist; see "Gastrocnemius values"
above (no EMG; the library's seated value, the toes pointed at 114°). Stabilisers from ExRx:
gluteus medius, gluteus minimus; core.

## Kneeling Leg Curl

Model facts: the RIGHT knee and shin rest on a horizontal kneeling pad (right knee 90°, the
right foot off its back end); the trunk leans 50° forward (hips 130°) with the forearms on two
arm pads (elbows 89°) and the hands on the handles, no chest pad. The left thigh hangs
straight down beside the pad; knee 173° -> 73°. The left knee joint is on the pivot (knee
0.596 m, axle centre 0.595 m, both at z 0.00); the roller sits ~7 cm above and ~9 cm behind
the ankle joint.

| Claim | Source |
|---|---|
| Stay leaning forward over the arm pads; the hip stays bent, the two-joint hamstrings work longer than in a standing curl | ExRx Lever Standing Leg Curl comment (a bent-over posture potentially further decreases the active insufficiency of three of four hamstring heads); ExRx Lever Kneeling Leg Curl (forearm on the padded arm rest) |
| In a 12-week study, curls with the hips bent grew the hamstrings more than curls lying flat | Maeo 2021 (seated vs prone leg curl, one leg each: whole hamstrings +14% vs +9%, the gain in the biarticular muscles) |
| Pelvis level, right knee settled on the pad, only the left lower leg moves; hitching brings in the lower back | ExRx Lever Kneeling Leg Curl (supporting knee on the horizontal pad; stabilisers gluteus medius and maximus); the library's Single-Leg Curl hip cue |
| Range: from a nearly straight leg to the heel above the knee, most of the knee's range | ExRx (raise the ankle to the back of the thigh, lower until the knee is straight); the model (173° -> 73°) |
| Knee on the pivot: knee and lever turn together, so the roller moves with the heel | ExRx (knee against the vertical pad); StrengthLog Lying Leg Curl (machine joint in line with the knees); the model |
| Roller low on the leg, on the back of the lower leg below the bulk of the calf | ExRx (other leg under the roller pad); StrengthLog (pad just above the heel); the model. As the Standing Leg Curl, placement is about where the roller presses, not the load |

Activation: as the Standing Leg Curl (same lever, roller and ankle angle): Hamstrings 0.90,
Gastrocnemius 0.40. Stabilisers from ExRx: gluteus maximus, gluteus medius; core.

## Cable Standing Leg Curl

Model facts: facing a cable tower ~1 m ahead, the low pulley in line with the left leg; a cuff
round the LEFT ankle; standing on the RIGHT foot on the floor (knee 172°), hands on the
handles of a support frame in front (elbows 78°), trunk 8° forward. The left thigh hangs
straight down; knee 155° -> 73°, so every rep starts with the knee ~25° short of straight. The
cable runs from the cuff to the pulley: at the start it is level, ~65° to the shin and ~0.34 m
from the knee joint; at the top it passes ~5 cm from the knee (the `HG_AnkleCable` prim's
ends against the knee joint), so the cable bends the knee hardest early in the curl and very
little at the top. The stack rises 16 cm.

| Claim | Source |
|---|---|
| Each rep starts a little short of straight; the cable's pull is square-ish to the lower leg near the start and runs almost through the knee at the top, so the start is hardest | The model's geometry (above) |
| Lower until just short of straight with the cable still pulling | The model (155° at the start) and its cable line. ExRx, the main source, says the opposite: it returns to a straight knee ("Return by straightening knee to original position") and curls to full flexion; the copy's cue follows this model, and the mistake is the swing and the rest at straight, not reaching it |
| Stand tall and still, the hands only steadying; tipping forward mid-rep turns part of the lift into a hip swing | StrengthLog, Standing Leg Curl (maintain an upright posture; keep the upper body still); ExRx Cable Standing Leg Curl (grasp the support bar); the model (trunk 8° and still, hands on the frame). The fault is the trunk moving mid-rep, not a bent hip as such (the Kneeling Leg Curl sells a bent hip) |
| Cuff round the ankle, snug, the cable straight to the pulley; at the ankle it pulls on the longest lever | ExRx (foot harness on one ankle attached to the low pulley); the model (cuff above the heel, the pulley in line). Unlike the machines' roller, a cable's pull is fixed by the stack, so a cuff slid up the calf does shorten the knee's lever and lighten the curl; the lever claim holds here |
| Hips stay put, not pulled toward the stack; letting the cable drag them forward arches the lower back | ExRx comment: keep the hip from sagging or from being pulled forward; stabilisers include the quadratus lumborum and obliques; the ghost (the pelvis ahead of the spine) |
| Thigh hangs straight down, the knee pointing at the floor; drifting forward bends the hip | ExRx (pull the cable back by flexing the knee); the model (thigh vertical all clip) |
| Setup: face the stack, hands on the frame, the left foot hanging just behind the right | ExRx (grasp the support bar; attached foot slightly off the floor); the model: the left toes just touch the floor at the start of each rep (skinned shoe 2 mm up, the planted right 1 mm), so the step does not say off the floor |

ExRx says the elbows stay straight to support the body; the model's elbows are bent 78°, so
the copy only says to rest the hands on the handles with the arms relaxed.

Activation: Hamstrings 0.86 (ExRx target), a little under the machines because the cable's
pull on the knee fades toward the top in this model. Gastrocnemius 0.34 LOW (ExRx synergist;
no EMG; the paint is faint, 0.11). Gluteus Medius 0.20 LOW (ExRx stabiliser of the one-leg
stance; faint paint). Stabilisers: gluteus maximus (painted faint with the medius and
minimus; ExRx lists it for the kneeling machine, not this one), gluteus minimus, quadratus
lumborum, obliques (ExRx).

## Swiss Ball Leg Curl

Model facts: supine on a mat, arms out ~35-40° from the sides on the floor, palms down; both
heels on top of a ~68 cm ball, ankles 26 cm apart. The hips are held up the whole clip: at the
start the knees are 164° and the hips 162°, the pelvis joint 0.35 m up and the seat of the
shorts 0.19 m off the floor (~11 cm above the mat); the knees curl to 90° as the ball rolls
40 cm toward the hips, the hips rise to 0.62 m and straighten to 176°, a straight line from the
shoulders to the knees at the top.

| Claim | Source |
|---|---|
| Heels on top of the ball, hip-width apart | PureGym (heels and lower calves on the ball); Monajati 2017 (heels on the ball); ExRx BWBallLegCurl (lower legs on the ball); the model (heels on top, 26 cm apart) |
| From the top the heels press down and drag the ball in; set low on its side they slip as it rolls | PureGym (heels and lower calves on the ball) for the placement; the slipping is reasoning (a heel low on the side cannot press down on the ball). The earlier feet-pressed-together fault was dropped with its ghost: unsourced, and heels together is a harder variant, not a recognised error |
| Top = a straight line shoulders-knees; arching past it moves the work to the lower back | PureGym (a straight line from knees to shoulders); ExRx (keep hips and low back straight; hips straight throughout) |
| In this version the hips stay up for the whole set, the glutes helping a little | ExRx (raise back and hips; keep hips straight throughout the movement; gluteus maximus a stabiliser); PureGym (lift the hips into a glute bridge); the model (hips never down); Youdas 2015 (gluteus maximus 10.9% MVIC, hence a little). The held bridge is this version's choice, not a universal rule: Monajati 2017's protocol lowered the pelvis each rep, as the Sliding Leg Curl model does, so the copy says in this version |
| Roll the ball out slowly: the hamstrings work as they lengthen, and a slow roll-out keeps the ball from running away | PureGym (pause, slowly reverse); Monajati 2017 (slow return; biceps femoris activity measured in the lowering phase) |
| Curl in over about a second, hold, at least as long rolling out | The model's timing; Schoenfeld 2015 (0.5-8 s repetitions build similar muscle, so the tempo is for control, not a growth claim) |
| Arms on the floor, palms down, a wide base | ExRx (arms extended out to the sides); PureGym (arms out in line with the shoulders, palms pressed into the floor); Monajati 2017 (hands on the floor, palms down); the model |

Activation: Hamstrings 0.78 HIGH, under the machines: Monajati 2017 measured biceps femoris
50.3% MVIC in the ball curl's lowering at the closest knee angles (74.8% in the Nordic),
Youdas 2015 measured the hamstrings at 51.9-59.6% MVIC in double-leg hamstring curls, and
Guruhan 2021 found the ball curl below the Nordic. Gluteus Maximus 0.28 LOW, SECONDARY for the
dim paint: Youdas 2015 measured 10.9% MVIC for this exact move (a bridge with the feet on a
Swiss ball plus a hamstring curl, 26 adults), under the plain double-leg bridge's 16.4%
(values tabulated in Macadam and Feser 2019); ExRx lists it as a stabiliser. Gastrocnemius 0.30
LOW (ExRx synergist; no EMG; see above). Stabilisers: erector spinae (ExRx), core, obliques
(ExRx antagonist stabilisers rectus abdominis and obliques).

## Sliding Leg Curl

Model facts: supine on a mat, arms out to the sides (upper arms ~68° out) with the elbows bent
~75° and the palms down, the hands on the floor beside the hips; both heels on sliders on the
floor beyond the mat. At the start the knees are 164° and the seat rests on the mat (skinned
shorts 5 cm up, the mat top 7 cm); as the heels slide 60 cm in, the knees bend to 70° and the
hips lift into a bridge (pelvis 0.21 -> 0.47 m, the seat 0.31 m off the floor), then lower
back to the mat as the legs slide out. The hip bends as the pelvis lifts (176° -> 148° at the
top); the ankles go from 119° to 79°.

| Claim | Source |
|---|---|
| The hips lift as the heels slide in and lower as the legs go out; the hamstrings hold the hips up while they bend the knee | Gulgosteren 2025 Fig. 1B (hips low with the legs straight, bridged with the knees bent); Monajati 2017's ball-curl protocol (pelvis lifted as the knees bend, lowered as they straighten); the model (the hip bends 176° -> 148° as the pelvis lifts, so the copy says hold, not straighten). Muscle & Strength only for feeling it in the glutes and hamstrings: it bridges first and keeps the hips up while the legs go out and back, and its eccentric-only regression lowers the hips before pulling the heels in, the reverse of this model |
| Legs stop just short of straight, the knees soft, controlled and ready to pull back in | Muscle & Strength (refrain from locking out the knees at the bottom); the model (164°). M&S's reason, keeping tension, assumes the hips stay up; in this model the seat rests on the mat at the bottom, so the copy gives control and readiness instead |
| Ribs down; a pumped lower back is the sign of the back taking over | Muscle & Strength (a lower-back pump means a core/pelvis stability issue) |
| Slide out slowly, the heels pressing so the hamstrings brake the slide | Muscle & Strength (slowly extend the legs; eccentric-only valslide curls as a progression) |
| Arms out on the floor, palms down, a wide base | The model; ExRx and PureGym for the ball curl (arms out, palms down). Muscle & Strength sets the hands by the sides; the copy follows the model |

Activation: Hamstrings 0.84: Hegyi 2019 put the prone and slide leg curls, with the
straight-knee bridge and upright hip extension, at the highest hamstring activity of nine
exercises (12RM loads, 2 s phases; the group spanning 40-54% MVIC lowering, 69-85% lifting);
Gulgosteren 2025 measured the biceps femoris at 70.5 +- 10.3% MVIC in its supine sliding leg
curl (21 healthy players). That study's curl is most likely this two-leg one: the title,
introduction, methods, abbreviation list and figure captions say supine sliding leg curl, and
Fig. 1B shows both heels down (checked on the figure); only the abstract once expands SSLC as
Sliding Single-Leg Curl. Gluteus Maximus 0.52 MODERATE (Gulgosteren 2025: 55.1 +- 9.3% MVIC).
Gastrocnemius 0.36 LOW (no EMG; see above). Stabilisers: core, erector spinae, obliques.

## Single-Leg Sliding Curl

Model facts: as the Sliding Leg Curl with one slider under the LEFT heel; the RIGHT leg is held
up off the floor all clip, knee bent 81°, the thigh pointing up at 68° to the floor; the left
knee and hips move as in the Sliding Leg Curl, the seat back on the mat at the bottom (pelvis
0.21 m, left knee 164°).

| Claim | Source |
|---|---|
| Right leg up, knee bent, held still; kicking the knee up toward the chest to swing the hips up is the mistake | Muscle & Strength, Single Leg Valslide Leg Curl (pull one hip into flexion with the knee bent and hold it); Tsaklis 2015 (the other leg kept off the floor); the model. The mistake mirrors the library's Single-Leg Glute Bridge free-leg fault (kicking the free leg up to help the hips rise), so the two one-leg bridges agree |
| Pelvis level as the hips rise; one foot down lets the free side drop and the back twist | Muscle & Strength (a lower-back pump means a core/pelvis stability issue); the library's Single-Leg Glute Bridge hip cue |
| Lower slowly on the left leg; lowering-only work has built about as much muscle as lifting-only, so the one-leg lowering is worth doing before a one-leg curl back in; if that is too hard, lower on one leg and pull back with both | Muscle & Strength (focus on the eccentric: lower down with one leg, come back with both); Schoenfeld 2017 (eccentric-only vs concentric-only training, 10.0% vs 6.8%, not significant), used for the lowering being worth doing, not for a slow tempo |
| Slide the left leg out until almost straight; stopping halfway leaves the stretched part of every rep out | Muscle & Strength (legs out until almost parallel to the floor, no lockout) for the range; Tsaklis 2015 only for the leg straightening slowly, then curling back. The earlier claim that the bottom is where the slide works hardest was dropped: Tsaklis reports a phase, not a position, and in this model the seat rests on the mat at the bottom (pelvis 0.21 m, as the Sliding Leg Curl) |
| Arms spread on the floor, palms down, pressing lightly so the body does not tip toward the raised leg | The model (upper arms ~68° out); reasoning from the one-leg base (the hips cue) |

Activation: Hamstrings 0.88, a rank judgement (the hardest of the family's floor curls, one leg
doing the work of two), not a measured value for this model. Tsaklis 2015 rated its slide leg
the highest intensity of ten exercises (>= 80% MVIC) with no medial-lateral bias, but its
version started from bent knees with the pelvis held off the ground throughout, unloaded, and
normalised EMG to 80% of the MVIC value, which inflates the percentages; this model's seat
returns to the mat. Gluteus Maximus 0.58 MODERATE, above the two-leg Sliding Leg Curl's 0.52
since one leg carries the bridge (Youdas 2015: single-leg bridge 32.6% vs double-leg bridge
16.4% MVIC, tabulated in Macadam and Feser 2019). Gastrocnemius 0.36 LOW (as the Sliding Leg
Curl). Stabilisers: hip flexors (holding the right leg up), obliques, erector spinae.

## Distinct from the library

The Lying Leg Curl (prone, both legs), Seated Leg Curl (hips flexed ~90°) and Single-Leg Curl
(prone, left leg) are the other machine curls. Here the standing machine and the cable curl
are upright with the hip almost straight, the kneeling machine holds the hip bent ~50°, and
the three floor curls pair the knee bend with a bridge. The cue sets are their own: the chest
pad, range, roller, knee on the pivot and the standing foot (standing); the forward lean,
level hips, range, pivot and roller (kneeling); the soft start, the still trunk, the cuff, the
hips and the thigh (cable); the heels, ribs, the held bridge, tempo and arms (ball); the hip
drive, the soft bottom, ribs, tempo and arms (sliding); the held free leg, the level pelvis,
the one-leg lowering, the arms and the full slide (single-leg sliding).

Sibling copy was checked for repeats: no intro, why, mistake, correct, setup step or label is
shared word for word between the six (the Standing and Kneeling range, pivot and roller cues,
and the floor curls' arms, tempo, ribs and bottom-of-rep cues, are each worded for their own
exercise). The Schoenfeld 2017 sentence appears only in the Single-Leg Sliding Curl's tempo
why. The roller cues no longer claim a longer lever or a heavier load (see the Standing Leg
Curl table); the library's Lying Leg Curl and Single-Leg Curl pad cues (spec_legs2.py) still
carry that lever claim, which is outside this family.

## Labels

Rows after the squeeze (0.16-0.80), sides and what each pill sits over, checked on the five
stills:

- Standing: chest 0.16 right (above the stack's top bar, below the eye button), range 0.36
  right and pad (Roller at the heel, the same width as before) 0.48 right (over the static
  stack guides, above the lever's sweep, which tops out ~0.58), pivot 0.64 left and stance
  0.70 left (over the static frame posts, ending before the standing calf and shoe; at 0.72
  the stance fault view, which frames the body higher, put the ghost's raised heel line
  across the pill's right end).
- Kneeling: lean 0.16 right, hips (Hips level) 0.42 right (below the top bar, ~20 pt above the
  roller's highest point), pivot (Left knee on the pivot) 0.52, range (Heel above the knee)
  0.64 (in this order: the patella dot sits just up and left of the knee-joint dot, and the
  other order crossed the two leaders) and pad (Roller low on the leg, ending at x 0.41) 0.80
  left (over the static handle posts and base).
- Cable: range 0.16 right with a long leader to the knee, trunk 0.24 left (left of the neck
  and upper chest; at 0.16 the trunk fault's ghost head and neck, tipped forward, ran through
  the pill in its fault view), cuff 0.36 right, hips 0.48 and thigh 0.64 left (over the
  static frame posts, ending before the belly and knee).
- Swiss ball: hips 0.16 right, ribs 0.26 right, tempo 0.26 left (clear of the knee's highest
  point, ~0.35), heels 0.72 left (below the ball), arms 0.80 right.
- Sliding: hips 0.16 right, knees 0.26 left, ribs (No arch at the top) 0.32 right, tempo 0.64
  left and arms 0.64 right (below the body band, ~20 pt under the sliders).
- Single-leg sliding: free 0.16 right, hips 0.32 right, tempo (Heel out slowly, ending at
  x ~0.33, short so that the range label's leader, rising from the row below to the knee,
  passes right of it; the longer Left heel out slowly put that leader across its pill) 0.64
  left, arms (Arms wide, palms down) 0.64 right, range 0.72 left.

## Ghosts

Measured with the port at the fault's moment (top = knee most bent, bottom = straightest, as
`fault_times.py` reads the legcurl kind); torso lengths are 0.592 m.

- Standing: chest `legCurlRocked(15)` (trunk 8° forward -> 7° back, head ~18 cm back, elbows
  re-seated; top); range `curlShort("L", 45)` (73° -> 118°, the lower leg 28° below level;
  top); pivot `legCurlKneeForward(20).seen(-0.3)` (knee ~15 cm forward; top), turned to a true
  left side view: from the framing, 15° short of it, the pivot disc (0.4 m nearer the camera
  than the knee) shows ~36 pt behind the correct knee, so the real knee already looked off
  the pivot; side-on the disc covers the real knee (~5 pt off its centre) and the ghost's knee
  sits ~44 pt off it, past the rim (~29 pt; at 15° it only reached the rim); stance, bobbing
  up off the right heel: the heel up 20° about the toes, the hips 0.1 torso lengths up, the
  right knee re-seated (top). The pad cue has no ghost.
- Kneeling: lean `legCurlRocked(18)` (trunk 50° -> 32°, the elbows 89° -> ~157°, the head
  ~22 cm; at 20° the shoulder-to-hand span, 0.543 m, would pass the arm's 0.538 m and lock the
  elbows; top); hips: the left hip and leg 0.12 up, the pelvis 0.05, seen from behind-left
  (view -1.0; the hip line ~31 pt across, its left end ~18 pt up; top); range
  `curlShort("L", 45)` (top); pivot: the whole body 0.2 back (~12 cm; top), seen side-on
  (view -0.3): from the framing a knee moved back travelled toward the disc's image, ~36 pt
  behind the correct knee, and read as moving onto the pivot; side-on the correct knee is on
  the disc's centre and the ghost's knee ~31 pt behind it, at the back rim. The pad cue has
  no ghost.
- Cable: range, the lower leg turned 32° toward straight, fading with the bend (155° -> ~178°
  at the start; bottom); trunk, the spine only turned 20° forward about the pelvis (8° -> 28°,
  the head ~24 cm forward and down, ~67 pt; top); the arms are left out, since with the hands
  fixed 0.34 m from the shoulders re-seating the elbows would fold them to ~39° into a tangle
  of lines; hips, the pelvis and hanging leg 0.15 forward, the mid-spine 0.14 (the lower back
  arches), the right knee re-seated (~6.4 cm at the start; bottom); thigh
  `legCurlKneeForward(20)` (~15 cm; top). The cuff cue has no ghost.
- Swiss ball: heels has no ghost (the heels' place on the ball; it falls back to the red
  ring, as the roller and cuff cues); ribs `floorCurlArched(0.18, chest: 0.08)` (lumbar ~11 cm
  up; top); hips `floorCurlHipsDown(0.22, .whenStraight)` (pelvis ~11 cm down at the start,
  to the mat; bottom); arms `floorCurlArmsUp(.lateral, 30)` (hands ~24 cm up; top). Tempo has
  none.
- Sliding: hips `floorCurlHipsDown(0.44, .between(thigh_L, foot_L, from: 1.41, to: 0.82))`,
  growing with how far the heels have come in (the hip-to-ankle distance, 1.41 torso lengths
  at the start, 0.82 at the top): none at the start, where the seat already rests on the mat;
  at the top the pelvis ~26 cm down to 0.208 m, its resting height (0.206 m), the knees 70° ->
  ~45°; at 1.0 s it sits at 0.255 m, above the mat (top). The earlier `.withBend` strength put
  the ghost's seat 3-4 cm into the mat through the bottom and early rise. Knees straightened
  0.06 past the hip-heel line (164° -> ~175°, ~8 cm; bottom); ribs `floorCurlArched(0.2,
  chest: 0.09)` (~12 cm; top); arms `floorCurlArmsUp(.up, 40)` (elbows ~20 cm up; top). Tempo
  has none.
- Single-leg sliding: free, the right thigh turned 30° further up, as the library's
  Single-Leg Glute Bridge free-leg fault (68° -> ~98° above the floor, just past vertical; the
  knee ~23 cm, ~35 pt, toward the head, the foot ~23 cm higher, staying below the hips pill;
  top); hips, the right hip and leg 0.2 down and the pelvis 0.1, seen from the feet end on the
  left (view +0.7; the hip line ~23 pt across, its right end ~19 pt down; top); arms as the
  Sliding Leg Curl (top); range, the left heel 0.25 nearer the hips (164° -> 116° at the start,
  about halfway to the top's 70°; bottom). Tempo has none.

Feet-end moves were kept off the floor curls' side views: the framings put the toes ~16-21 pt
from the screen's left edge, so a ghost that slides the heels further out would leave the
screen.
