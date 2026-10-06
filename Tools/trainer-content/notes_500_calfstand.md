# 401-500 folder: standing, hinged and sled calf raises (2026-10-04)

Seven straight-knee calf raises from the builder's 401-414 exports: 414 Bodyweight Standing Calf
Raise, 401 Dumbbell Standing Calf Raise, 403 Single-Leg Dumbbell Calf Raise, 411 Single-Leg
Machine Calf Raise (the builder's "standing single-leg machine calf raise"), 404 Donkey Calf Raise,
405 Machine Donkey Calf Raise and 406 Hack Squat Calf Raise (models `Legs/<Resource>.usdc`).
`spec_500_calfstand.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_calfstand.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_calfstand.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The leg briefs (`SCRATCH/briefs_legs/<Resource>.md`: knee, hip, ankle, foot pitch, trunk lean,
  equipment every 0.5 s, rep phases), `tiers30.json`, `joints.json` and the trainer stills at
  0/1/2/3/5 s (`SCRATCH/stills`).
- The rigs, equipment and skinned shoes straight from the USD with Blender's Python + pxr:
  `SCRATCH/calfstand/measure.py` (joint positions and angles, the world bounds of every `HG_*` and
  `GYM_*` prim, and the skinned shoe points split by the nearer foot, for the heel's height against
  the step), `meshpts.py` (the hack squat footplate's vertices, for its slope and edge),
  `heel.py` (the knee-to-toe-tip distance `calfHeelHeight` reads), `track.py` (pelvis and ankle
  displacement against the ankle angle, for sizing the heel ghosts).
- Ghosts: `SCRATCH/calfstand/ghost.py`, a Python port of `FaultGhost.solve` (the same body axes,
  shift / turn / straighten / resolve, strengths, tips), run on the real joint transforms at the
  fault's moment (`pieces.py` holds the pieces, `try3.py`, `tune*.py` measure them).
- Labels: `preview_500.py calfstand` plus `SCRATCH/calfstand/overlay.py` (the pills, ~24 + 6.4 pt
  per character and 28 pt tall, with the app's 8 pt edge clamp, and leaders drawn over the five
  stills, the eye button and legend line boxed), then the lab shots (`lab500.sh shoot`).
- Sources: Europe PMC REST records (abstracts) for every study; ExRx through the Wayback Machine
  (`SCRATCH/calfstand/exrx/*.html`, text pulled with `txt.py`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.592 m; foot bone from the ankle joint to the ball of the foot
  ~15 cm). Every clip is 7.96 s with two identical reps: heels lowest to 0.08 s, rising 0.12-0.88 s
  (~0.8 s), held at the top 0.92-2.12 s (~1.2 s), lowered 2.17-3.33 s (~1.2 s), resting at the
  bottom 3.38-4.08 s (~0.7 s). The copy's timings ("rise in under a second" / "about a second",
  "hold for about a second", "take longer to lower", "pause / rest for a moment") describe that.
- Knees 173-176° in all seven, so the copy says straight but soft / not locked. ExRx allows a
  slight knee bend during the stretch; every knee fault here is the deeper dip used to bounce or
  drive the load up (the ghosts take the knee to ~138-144°), a coaching convention, as in the
  library's calf raises.
- Ankle angle = shin to foot bone on the rig. With the sole flat on the floor and the shin ~6°
  forward (the bodyweight and dumbbell models at rest, heel skin 1 mm off the floor) it reads 106°,
  the foot bone pitched 21° down. Neutral (Kassiano 2023's 0°, the foot at 90° to the tibia) is
  taken as ~109°, the reading the calfseat family measured for a flat foot under a vertical shin
  (the Single-Leg Seated Calf Raise's resting right foot), so the two families read angles the same
  way. Bottoms: 106° on the two floor raises (flat on the floor, ~3° dorsiflexed by the shin's
  lean), 88° (single-leg dumbbell, ~21° dorsiflexed), 85° (single-leg machine, ~24°), 96° (both
  donkeys, ~13°), 77° (hack squat, ~32°). Tops: 142° / 143° / 141° / 145° / 155° / 138°, ~29-46°
  plantar flexed. So, unlike the library's five calf models (none goes below a flat foot), five of
  these seven reach into the lower range that grew the gastrocnemius most in Kassiano 2023 (25°
  dorsiflexed to neutral), and the copy says so; the two floor raises cannot, and their copy says
  that too.
- Heels against their support (skinned shoe, lowest point of the heel half): single-leg dumbbell
  10.2 cm vs the step's top 15 cm (~5 cm below); single-leg machine 12.2 vs 17 cm (~5 cm below);
  donkey 7.6 vs 12 cm, machine donkey 12.6 vs 17 cm (~4.4 cm below); hack squat 13.9 cm vs the
  platform's edge 23 cm (~9 cm below). The balls of the feet sit on the back edge of each support:
  the toe joint at z 0.195-0.199 m against edges at z 0.188 (step, blocks) and 0.227 (hack
  platform rubber).
- Highlight tiers (`tiers30.json`): GastrocnemiusLateral, GastrocnemiusMedial and Soleus bright on
  all seven -> both "Gastrocnemius" and "Soleus" PRIMARY (the house rule: bright = PRIMARY). Dim:
  BicepsFemoris, Semimembranosus, Semitendinosus on both donkeys -> SECONDARY "Hamstrings"; on the
  hack squat raise those plus RectusFemoris and the three vasti -> "Quadriceps" and "Hamstrings";
  on the dumbbell standing raise the forearm flexors and extensors, brachioradialis, the three
  trapezius parts, rhomboid major and the hamstrings -> "Forearms", "Trapezius", "Hamstrings"
  (rhomboids in the stabilisers, see below); on the single-leg dumbbell raise the same set only
  faint -> "Forearms" and "Trapezius" as LOW rows, the rhomboids and hamstrings among the
  stabilisers (the legcurl family's rule for faint paint). All names pass `part_of()`.
- Legend width: the legend is one line per rank (`Exercise3DView.legend`, mono 9.5 pt with 0.07 em
  tracking, ~6.4 pt a character, 14 pt padding), so a name line fits ~43 characters on the 382 pt
  viewport. "FOREARMS · TRAPEZIUS · HAMSTRINGS" is 33; adding "RHOMBOIDS" would make 45 and
  truncate, which is why the dumbbell raise names the rhomboids in its stabilisers.
- Calf fractions: no EMG exists for any of these seven exact lifts. LOADED = Gastrocnemius 0.86,
  Soleus 0.66 (the library's Standing Calf Raise values) for the dumbbell, single-leg, machine and
  hack raises. The order (gastrocnemius ahead with the knee straight) rests on Signorile 2002
  (medial gastrocnemius above the soleus at 180°, the soleus lower at 180° than at 90/135°),
  Price 2003 (knee straight, 25% 1RM: only the gastrocnemius heads lit on MRI), Cresswell 1995
  (gastrocnemius EMG falls as the knee bends, soleus holds; the gastrocnemius at least 40% of the
  torque straight) and Hebert-Losier 2012 (soleus 4% higher, gastrocnemius 5% lower at 45° than at
  0°). The soleus stays a strong primary, not a minor one: Gentil 2020 (standing machine calf
  raise, knees straight: mean EMG 50.7% / 52.2% / 51.3% of each muscle's own peak in the tests for
  the lateral and medial gastrocnemius and soleus; the full text normalises each muscle to its own
  maximum, so this shows the soleus working substantially, not a ranking between the muscles) and
  Kinoshita 2023 (the soleus grew about as much after standing as after seated training, 2.1% vs
  2.9%); ExRx's analyses page says knee-straight raises "activate both the Gastrocnemius and
  Soleus". UNLOADED = 0.78 / 0.60 for the bodyweight standing and donkey
  raises: two legs share the body weight (and the donkey rests part of the upper body on the
  forearms), so each calf lifts less than in the loaded raises; Hebert-Losier 2012 measured only
  23% MVIC for one-leg bodyweight raises. Both splits are judgement calls; the studies give the
  order, not the numbers.
- Secondary rows (all LOW, all paint-led judgements with no EMG for these lifts): each stands for a
  minor role, not for lifting the load. Forearms 0.30 / 0.24 grip the dumbbells; Trapezius
  0.28 / 0.20 hold the shoulders up under them (ExRx lists the upper and middle trapezius as the
  dumbbell raises' stabilisers); Hamstrings 0.20 on the donkey pair are stretched by the hinge
  (ExRx), held long rather than lifting; Hamstrings 0.15 on the dumbbell and hack raises and
  Quadriceps 0.25 on the hack raise (steadying the straight knees; ExRx counts the quadriceps as
  synergists only once the knees bend) are the lowest rows, there because the paint lights them.
- Framings: six at yaw -1.3 (side-on from the front-left, facing screen-left), the hack squat raise
  at -0.6 (three-quarter from the front-left, the lifter facing the camera turned to screen-left).

## Sibling and library check

- Library: Standing Calf Raise (machine, heels stop level with the block, 99°), Single-Leg Calf
  Raise (22 cm step, heel stops level, a balance handle; dumbbell in the left hand), Smith Machine
  Calf Raise, Leg Press Calf Raise, Seated Calf Raise. Of the new seven, the single-leg dumbbell
  raise is closest to the library's Single-Leg Calf Raise; it differs in its step (15 cm), its
  post, and above all its heel, which sinks ~5 cm below the step. Its cues replace the library's
  tempo cue with level hips and turn the bottom cue into a stretch cue.
- Sibling family calfseat (`spec_500_calfseat.py`, read 2026-10-04): its two knee-straight
  machines (calf press, horizontal leg press, knees 168°) use the same Gastrocnemius 0.86 / Soleus
  0.66, both PRIMARY, and its four seated raises Soleus 0.86 with Gastrocnemius 0.40, both PRIMARY
  for the paint; it cites the same studies for the knee-angle claims (Signorile 2002, Cresswell
  1995, Price 2003, Kinoshita 2023, Gentil 2020) and the range claims (Kassiano 2023, Kawakami
  2002), and reads ankle neutral at ~109°, as here. The claims agree: with the knee straight the
  gastrocnemius leads and the soleus still works hard; with it bent the soleus does most of it;
  standing training grew the gastrocnemius far more than seated, the soleus about the same. Its
  hamstring rows (dim on its machines) are 0.20 LOW, as the donkey pair's here.
- No sentence of cue, setup or comparison copy repeats word for word between the seven, or with
  the library's five calf contents (checked by script; the one hit, a hack squat setup step equal
  to the library's leg press step, was reworded).

## Bodyweight Standing Calf Raise

Model facts: flat floor, no equipment, feet hip-width (ankles 0.20 m apart, toes ~6° out), arms
hanging at the sides (elbows 170°), trunk upright. Ankle 106° -> 142°; the heels rise ~12 cm (heel
skin 1.4 -> 13.3 cm up) and come back onto the floor every rep; the body rises ~7 cm and drifts
~10 cm forward over the balls of the feet.

| Claim | Source |
|---|---|
| Rise straight over the big and second toes; rolling onto the little-toe side tips the ankles outward; in a small heel-raise study raises rolled that way drew less peroneus longus work than raises with the weight toward the big toe; the peroneus longus runs down the outside of the leg and steadies the ankle | Kim 2022 full text (five healthy men, one- and two-leg raises with the ankle everted or inverted: PL EMG higher with eversion, in the rise; its introduction: the PL supports the lateral ankle ligaments, and the soleus and gastrocnemius work well either way). Review fix: the draft said rolled-out raises drew "little" PL work and straight raises more; the study compared eversion with inversion, so the copy now says "less" and "toward the big toe" |
| Knees straight; the gastrocnemius starts above the knee, so it pulls hardest straight; in studies that bent the knee its activity fell while the soleus kept working; a dip lets the thighs spring you up | ExRx Gastrocnemius (origin: medial and lateral femoral condyles); Cresswell 1995; Signorile 2002; ExRx exercise pages (quadriceps synergists once the knees bend) |
| The ankle cannot lock out, so the calves still hold you at the top; ExRx notes the top stays hard; hold about a second | ExRx Calf Exercise Analyses ("the upper portion of the calf exercises is relatively more difficult ... the ankle cannot extend straight like other joints"); the model (~1.2 s hold) |
| Heels touch the floor every rep, the whole range of the floor version; a step lets them sink below level; training that stretched range grew the gastrocnemius more than the range above it in an eight-week study | The model (no step; heels back on the floor); Kassiano 2023 (initial range -25° to 0° vs final 0° to +25°: medial 15.2% vs 3.4%, lateral 14.9% vs 6.2%); ExRx Standing Calf Raise (toes on a calf block, heels off) |
| Lower slower than you rise; in an eight-week bodyweight study the leg that also lowered alone over 3 s gained strength and thickness, the raise-only leg did not; the way down is part of the work | Nakamura 2025 (CON-ECC leg: MVIC +32.9%, thickness +9.1%, ROM +30.4%; CON leg no change); the model (~0.8 s up, ~1.2 s down). The study compared lowering with not lowering, not two lowering speeds, so the copy no longer says the slow way down is what made the difference |
| Setup: rest a hand on a wall if you wobble | ExRx Standing Calf Raise (hand on support for balance); the model uses none, so the copy offers it |

Activation: UNLOADED (Gastrocnemius 0.78, Soleus 0.60), both PRIMARY. Stabilisers: tibialis
posterior, peroneals, toe flexors (Akuzawa 2017: tibialis posterior, peroneus longus and flexor
digitorum longus work in heel raises), core (convention).

## Dumbbell Standing Calf Raise

Model facts: as the bodyweight model (same stance, floor and motion, ankle 106° -> 143°) with a
dumbbell in each hand at the sides, arms straight (176°), the handles running front to back
(palms facing the thighs). ExRx's Dumbbell Standing Calf Raise uses one dumbbell, a calf block and
a hand on a support; the copy follows the model and names the block as ExRx's set-up in the
bottom cue.

| Claim | Source |
|---|---|
| Dumbbells hang beside the hips; load carried slightly forward of the feet makes the top a little easier (ExRx), so swinging them forward takes work off where the rep is hardest and pulls you off balance | ExRx Calf Exercise Analyses ("placing the load slightly forward relative the feet allow for something closer to a lockout ... a subtle decrease of muscle tension nearer the top"); the balance clause is mechanics. (The draft's "over the toes" went further than ExRx's "slightly forward") |
| Knees straight; the gastrocnemius crosses the knee; bending shortens it; quadriceps join once the knees bend | ExRx Gastrocnemius; ExRx Dumbbell Standing Calf Raise comments; Cresswell 1995 / Signorile 2002 as above |
| Top: short range, the calves shortest at the top, the ankle never locks out; pause with the dumbbells at your sides | ExRx Calf Exercise Analyses; the model's hold |
| Heels back to the floor every rep; ExRx sets the lift on a calf block; the stretched range below flat grew the gastrocnemius more than above it | ExRx Dumbbell Standing Calf Raise ("Position toes and balls of feet on calf block with arches and heels extending off"); Kassiano 2023 |
| No bouncing: the tendon stretches and recoils; in a dip-and-push ankle movement the fibres stayed nearly the same length while the tendon stored and returned the energy | Kawakami 2002 |

Activation: LOADED, both PRIMARY. Forearms 0.30 LOW (gripping the dumbbells; the library's
dumbbell lunges, Walking and Reverse Lunge, use 0.30; no EMG), Trapezius 0.28 LOW (holding the
shoulders up under the dumbbells; ExRx stabilisers: upper and middle trapezius, levator scapulae;
no EMG), Hamstrings 0.15 LOW (painted dim; no source measures them in a calf raise; a paint-led
judgement, the lowest row). None of the three moves the load. Stabilisers: rhomboids (painted dim with
the trapezius; legend width, see above), levator scapulae and gluteus medius (ExRx), tibialis
posterior, peroneals (Akuzawa 2017).

## Single-Leg Dumbbell Calf Raise

Model facts: the LEFT leg works for both reps. The ball of the left foot on the back edge of a
15 cm step (`HG_ForefootStep`, 0.8 x 0.19 m), heel off it: ~5 cm below the step's top at the
bottom (ankle 88°), ~13 cm above it at the top (141°). A dumbbell in the LEFT hand, arm straight
(176°) at the side. The RIGHT hand on a 1.43 m post (`HG_SupportPost`, ~0.34 m to the right and
~0.2 m ahead) at 1.30 m, below the shoulder (1.49 -> 1.60 m): elbow 73° at the bottom, 97° at the
top, as the body rises away from the fixed hand. Right knee bent 129°, the foot ~30 cm behind the
left heel and ~36 cm off the floor (never near the step). Pelvis 8 cm left of centre, over the
left foot; trunk upright.

| Claim | Source |
|---|---|
| Right hand on the post only for balance; ExRx: a hand on a support for balance, a lighter load if the hands must help; the post sits below the shoulder, so help comes from leaning and pushing down | ExRx Dumbbell Single Leg Calf Raise ("Place hand on support for balance", "Use lighter load if you need to assist with hands used for support"); the model (hand 19-30 cm below the shoulder joint) |
| Hips level; the standing-side gluteus medius holds the pelvis so it does not sag on the unsupported side; level hips keep the weight over the left foot | ExRx Gluteus Medius ("Steadies pelvis so it does not sag when opposite side is not supported with leg"); ExRx's one-leg stabilisers (gluteus medius and minimus, quadratus lumborum, obliques) |
| Left knee straight; the gastrocnemius runs from above the knee to the heel; a bend in the stretch shortens it and lets the thigh spring you up | ExRx Gastrocnemius; ExRx (knees straight, or a slight bend only in the stretch) |
| Top: one calf holds the whole body and the dumbbell; the ankle never locks out; hold a second | ExRx Calf Exercise Analyses; the model |
| Heel sinks below the step (a few centimetres here); training below a flat foot grew the gastrocnemius more than above it; stopping level leaves that part out | The model (~5 cm below, ankle 88°); Kassiano 2023; ExRx ("Lower heel by bending ankle until calf is stretched") |
| Comparison: below the step grew the gastrocnemius more than above level; stopping at level keeps reps in the range that grew it least | Kassiano 2023 (final range 0 to +25°: medial +3.4%, lateral +6.2%, the least of the three groups) |

Activation: LOADED, both PRIMARY. The dumbbell set is faint: Forearms 0.24 and Trapezius 0.20
(LOW, below the two-dumbbell raise's 0.30 / 0.28 since one hand holds one dumbbell; no EMG).
Stabilisers: gluteus medius, quadratus lumborum, obliques (ExRx), rhomboids and hamstrings (faint
paint), tibialis posterior, peroneals.

## Single-Leg Machine Calf Raise

Model facts: the LEFT leg works on a standing calf machine (`GYM_M24`): the shoulders under two
pads on a lever pivoted behind (hub ~0.6 m back), the hands on handles in front of the shoulders
(elbows 43°). The ball of the left foot on the back edge of the toe block (10 cm on a 6 cm
platform, top 17 cm up); the heel ~5 cm below the block's top at the bottom (ankle 85°), the top
145°. The body rises ~12 cm straight up (pelvis 1.03 -> 1.15 m, no fore-aft travel) with the pads;
the stack rises ~7 cm. The right knee bent 129°, the foot hanging ~28 cm behind the left heel,
clear of the block. Trunk 2° forward.

| Claim | Source |
|---|---|
| Stand tall with the hips under the pads; the pads load the shoulders, so the push runs down a tall body; hips back fold the body, a hip snap can start the lever | ExRx Lever Standing Calf Raise ("Stand erect by extending hips and knees"); mechanics and coaching convention, as the library's Standing Calf Raise body cue (no study) |
| The right foot stays off the block; ExRx lists assisting with the other leg as an easier version; touching down turns the bottom into a two-leg raise | ExRx Single Leg Calf Raise ("Resistance can be reduced by assisting raise with other leg"); the model (foot never touches) |
| Left knee straight; in studies that bent the knee gastrocnemius activity fell while the soleus kept working; a dip lets the thigh drive the pads | Cresswell 1995; Signorile 2002; ExRx (quadriceps synergists once the knee bends) |
| Labels Stand tall (the body cue) and Knee straight | Shortened in review: the draft's Hips under the pads and Left knee straight sat on the chest and touched the thigh (see Labels) |
| Top: the calf still holds the load at the top, where ExRx notes calf raises stay hardest | ExRx Calf Exercise Analyses |
| Heel below the block a few centimetres; below flat grew the gastrocnemius more than above it; ExRx sets the lever just below the lowest point | The model; Kassiano 2023; ExRx Lever Standing Calf Raise ("If possible, position lever just below lowest range of motion"); "so the pads stay on your shoulders through the whole stretch" is the plain consequence of that setting |
| Setup: lever just below the lowest point | ExRx Lever Standing Calf Raise |

Activation: LOADED, both PRIMARY; no dim paint. Stabilisers: gluteus medius, quadratus lumborum,
obliques (ExRx one-leg raises), upper trapezius (ExRx Lever Standing Calf Raise: trapezius,
levator scapulae under the pads), tibialis posterior, peroneals.

## Donkey Calf Raise

Model facts: hinged at the hips with the forearms flat on a padded column (`HG_ForearmPad`, top
0.87 m, on `HG_PadColumn`), elbows 95°, hands palm down; the balls of both feet on the back edge of
a 12 cm block (`HG_ToeBlock`), heels off; no partner and no added load. Knees 173-174°. The
shoulders stay put on the pad while the hips rise ~9 cm, so the hips close 109° -> 91° and the
trunk tips from ~24° to ~14° above level as the heels rise. Ankle 96° (heels ~4.4 cm below the
block's top) -> 155°. Hips about over the ankles (pelvis ~3.5 cm behind them).

| Claim | Source |
|---|---|
| Stay folded forward, forearms resting; ExRx: trunk about parallel to the floor; ExRx's explanation that bent hips with straight knees stretch the hamstrings, which pull against the gastrocnemius behind the knee and may help it keep tension near the top; pushing up turns it into a standing raise | ExRx Weighted Donkey Calf Raise ("Torso should be approximately parallel to floor"; forearms on a thigh-high surface); ExRx Calf Exercise Analyses (hip flexion with the knee straight stretches the hamstrings; "Hamstrings pull against Gastrocnemius"; "permits greater tension potential of the gastrocnemius muscles near the top"). ExRx's reasoning, not a measured result, so the copy says "its explanation" and "may" |
| Long back; tight hamstrings pull on the pelvis; ExRx notes it shows as lumbar rounding or a knee bend at the bottom of a hip-bent calf exercise; a higher support bends the hips less | ExRx Calf Exercise Analyses ("For those with less hamstring flexibility ... a subtle flexion through the lumbar spine or a slight knee bend ... particularly during dorsal flexion"), said of hip-flexed calf exercises (its example is a seat set too upright); the higher-support advice follows from it |
| Knees straight; the gastrocnemius needs a straight knee to work at length; bending eases tight hamstrings; ExRx flags that bend | ExRx Gastrocnemius / Hamstrings (origin ischial tuberosity, insertion tibia); ExRx Calf Exercise Analyses |
| Top: rising fully and holding takes each rep to the end of the range; the hips rise with the heels while the chest stays down | The model |
| Heels below the block; the stretched range grew the gastrocnemius more | The model (~4.4 cm below, ankle 96°); Kassiano 2023 |
| Setup: forearms on a pad at about hip height, step back onto the block, hips above the ankles, trunk close to level | The model (pad top 0.87 m, hip joints 0.99 m); ExRx (thigh-high surface). Review: the draft stood on the block first and then walked the feet back, which would step off the block, so the forearms go on the pad first |
| Hinge mistake: pushing up on the arms | The ghost straightens the elbows (95° -> ~159°) with the hands on the pad, so the forearms leave it; the draft said through the forearms |

Activation: UNLOADED (0.78 / 0.60), both PRIMARY: body weight only, part of the upper body resting
on the forearms. Hamstrings 0.20 LOW (dim; ExRx: stretched by the bent hips and straight knees; no
EMG, a judgement). Stabilisers: serratus anterior, pectoralis major (ExRx donkey pages: the trunk
held on the support), erector spinae (holding the hinge; convention), tibialis posterior,
peroneals.

## Machine Donkey Calf Raise

Model facts: the donkey's body and motion 5 cm higher on the `GYM_M24` frame. The lever's two pads
rest across the lower back and hips (1.19-1.28 m up, over z -0.02 to 0.24 m: above the pelvis
joint at 1.04 m and the lumbar spine), riding up with them; the forearms on a separate pad (top
0.92 m); the balls of the feet on the machine's toe block (top 17 cm), heels ~4.4 cm below it at
the bottom. The stack rises ~8 cm.

| Claim | Source |
|---|---|
| Pad across the lower back and hips; lever just below the lowest point; over the hips the load presses down through the legs, higher on the back it presses the trunk down | ExRx Lever Donkey Calf Raise ("Position lower back and hips under padded lever"; "Position lever just below lowest range of motion"); ExRx Sled Donkey Calf Raise (same); the last clause is mechanics (the trunk is held only at the forearms) |
| Flat back under the loaded pad; tight hamstrings show as lumbar rounding at the bottom, here under load | ExRx Calf Exercise Analyses, as the donkey's back cue |
| Knees straight; with the pad on the hips a knee bend lets the thighs drive it; quadriceps join once the knees bend | ExRx Lever Donkey Calf Raise comments |
| Top: the ankle never locks out; ExRx notes the top stays hardest | ExRx Calf Exercise Analyses |
| Heels below the block; below flat grew the gastrocnemius more | The model; Kassiano 2023 |

Activation: LOADED, both PRIMARY. Hamstrings 0.20 LOW (as the donkey). Stabilisers: serratus
anterior, pectoralis major (ExRx Lever Donkey Calf Raise), erector spinae, tibialis posterior,
peroneals.

## Hack Squat Calf Raise

Model facts: on a hack squat machine (`GYM_M15`), BACK on the back pad and facing out (the lifter
faces +z; the back pad spans z -0.43 to -0.01 m behind; the front view in the stills shows the
chest and quadriceps), reclined 35° from vertical, the shoulders under the shoulder pads, the
hands on the handles beside the head (elbows 27-37°). The footplate slopes up 15° toward the front
(rubber top from 23 cm up at its back edge, z 0.227, to 35 cm at the front); the balls of the feet
(toe joints at z 0.230) sit on its lower edge with the heels and arches hanging off. Feet
hip-width (ankles 0.21 m apart). Knees 175°, hips 144° -> 152°. Ankle 77° (heels ~9 cm below the
edge) -> 138°; the body and sled ride ~14 cm up the rails, along the trunk's own line.

| Claim | Source |
|---|---|
| Only the balls of the feet on the platform's lower edge, heels and arches off; heels can drop below it and rise above it; not every platform is open at its lower end, some take a calf block | ExRx Sled Hack Calf Press ("Place toes and balls of feet on lower portion of platform with heels and arches extending off"; "Not all Hack Squat machines have platform with opened lower end ... some platforms may accommodate calf block") |
| Back and hips on the pad; the shoulder pads carry the load down the line of the sled; hips sliding forward bend the knees and let the thighs help | ExRx ("Lie supine on sled with shoulders against pad"); mechanics (the model's body moves along the trunk's line) |
| Knees straight; the gastrocnemius crosses the back of the knee, so a straight knee keeps it long; in a 12-week study calf raises with the knee straight grew it far more than with it bent to 90°; a bend turns part of the rep into a squat | ExRx Gastrocnemius (biarticulate, femoral condyles to the calcaneus); Kinoshita 2023 (lateral 12.4% vs 1.7%, medial 9.2% vs 0.6%; the authors credit training at long muscle lengths); ExRx (quadriceps synergists once the knees bend). Review: the draft gave crossing the knee as the study's finding (since ...); it is now stated as anatomy before the result |
| Top: hold the sled at the top for a moment | The model; the calves work by pointing the ankles (anatomy) |
| Heels drop furthest here, deep below a flat foot; that range grew the gastrocnemius more | The model (77°, ~9 cm below the edge, against 85-96° on the other four that go below level); Kassiano 2023 |
| Setup: stand the sled up with straight knees; release the safety catch if it has one | ExRx ("straighten knees"; "Disengage docking lever if it impedes movements"), worded for machines with or without one |

Activation: LOADED, both PRIMARY. Quadriceps 0.25 LOW (dim; a minor role steadying the straight
knees under the sled; ExRx counts them as synergists only once the knees bend, which this model
does not do, so the row is low; no EMG), Hamstrings 0.15 LOW (dim; no source). ExRx lists no
significant stabilisers, so only tibialis posterior, peroneals and core are named.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`); pills
~24 + 6.4 pt per character. The probed joints (`joints.json`) sit a few points off the bodies in
some stills (the single-leg models' framing), so placement was settled on the lab shots, not the
overlay alone. Right-hand pills are kept short where the body or calves reach u ~0.65.

- Bodyweight: tempo (Lower slowly) 0.24 right, beside the head, leader to the chest; knees 0.56
  left; toes (Over the big toes, to the far ball of the foot `toe_R`) 0.72 left and top (Rise
  high, hold, to the near ball `toe_L`) 0.80 left, in that order so the two leaders, both ending at
  the toes, do not cross; floor (Heels touch down) 0.80 right, a short leader to the near heel. The
  first draft's longer labels (Weight over the big toes, Lower slower than you rise, Heels to the
  floor) ran their pills onto the calves and torso.
- Dumbbell: tempo (No bouncing) 0.24 right; arms (Hang still) 0.44 left, its leader over the
  dumbbells' front plates to the wrist; knees 0.60 left; top 0.80 left (to `toe_L`); floor (Heels
  back down) 0.80 right. The secondary legend line, FOREARMS · TRAPEZIUS · HAMSTRINGS, fits.
  Review: the draft's 18-character Dumbbells at sides covered the top of the far dumbbell's front
  plate at the top of the rep (the plate's left edge comes out to u ~0.30 there); the review's
  first replacement, Hang at sides, cleared it by only ~3 pt, so the label is Hang still (10
  characters, ~20 pt clear), which also matches the comparison's Dumbbells still at your sides; at
  0.44 it stays ~13 pt below the swung ghost hands (u 0.27, v 0.39) in the arms fault.
- Single-leg dumbbell: everything but the bottom label on the left, in front of the lifter, so no
  leader crosses the dumbbell arm or the hanging leg: post (Light grip) 0.24 left (the first draft's
  Light hand on the post ran onto the chest and over the ghost arm). At the top of the rep the body
  drifts ~10 cm forward and hides the right hand and the post behind the chest (`hand_R` stays at u
  0.36, v 0.39, a little inside the belly's front edge even at the bottom), so any leader to the
  hand crosses the front of the chest for ~1.2 s of each rep (no probed joint lies on the visible
  hand or the post). From the author's 0.16 it ran down the whole chest; the review moved the pill
  to 0.24, which shortens that run, clears the head and chest by ~15 pt and, in the lean fault's
  front view, sits beside the post's top, clear of the ghost's arm and hand (u 0.26, v 0.30). Left
  open: the leader still ends inside the torso at the top of the rep; hips 0.40 left (to the pelvis
  across the belly, not across the arm as from the right; at 0.46 the pill touched the dumbbell's
  front plate at the top of the rep, so the leader now passes over the plate instead); knee (Knee
  straight) 0.60 left, to the front of the knee; top 0.72 left (to `toe_L`, beside the post); bottom
  (Heel below the step) 0.80 right.
- Single-leg machine: pads (Stand tall) 0.36, knee (Knee straight) 0.58 and top (Pads up high,
  hold) 0.70 on the left, over the open floor in front; free (Right foot stays off) 0.58 and bottom
  0.80 on the right, below the lever arm and clear of the hanging foot. Review: the body's front
  reaches u ~0.30-0.37 down the left side, and the draft's Hips under the pads (0.36) sat on the
  chest and belly in all three stills and Left knee straight touched the thigh, so both are short.
- Donkey: the mistake view lifts and shrinks the model (`roomBelow`), by ~0.1 of the viewport
  here, which puts the hips where any top-right pill sits (round 3: Back long at 0.23 right sat on
  the lifted hips in its fault view, Chest down at 0.17 right on their top edge). So every label but
  the bottom one is on the left: back (Back long) 0.13 above the head, its leader along the top of
  the back to the lower back, the back fault turned 0.5 so the lifted head clears the pill; hinge
  (Forearms rest, to the near hand `hand_L`) 0.36, between the hanging head and the hands on the
  pad, over the pad's front face in the fault view; knees 0.52 left, its leader running under the
  forearm pad to the far knee (`patella_R`, the leftmost knee, so the leader does not cross the
  near leg; the right-hand draft pill sat on the hamstrings); top 0.80 left (to `toe_R` on the
  block); bottom 0.84 right, below the heels. (Round 1's 25-character Chest down, forearms rest on
  the left touched the head at the top of the rep and sat on the hinge ghost's head and neck.)
- Machine donkey: the lever arm, which moves, takes the right-hand rows from ~0.17 down to the hips.
  Pad (Pad on the hips, no ghost, so trainer view only) 0.15 right, between the eye button and the
  lever's bracket: on the review's shot at 1.5 s (the top hold, where the bracket is highest) the
  pill clears the eye button by ~3 pt and the bracket by ~6 pt, so it no longer touches; a higher
  row would hit the eye button and no other spot on that side is free. Its leader runs over the
  lever's pad to the pelvis, which is what it points at; back (Back flat) 0.13 left above the head,
  its leader along the top of the back to the lower back. In round 2 the back pill sat at 0.15
  right, where the mistake view (which lifts the model) put it on the lever's bracket; on the left,
  the lifted head would reach it, so the back fault turns the lifter 0.5 toward the front, which
  moves the head right while the vertical hump still reads. Knees, top and bottom as the donkey.
- Hack squat: back 0.24 left (to the spine), knees 0.50 left (to the right knee, on the left of
  the screen), feet (Balls of feet on edge) 0.70 left (to `toe_R`), top (Sled high, hold) 0.70 and
  bottom (Heels below the plate) 0.80 right, all over the static frame and platform.

## Ghosts

Measured with the port at the fault's moment (top = heels highest, bottom = heels lowest, as
`fault_times.py` reads the `calf` kind off the left ankle; all seven work the left leg or both, so
no seconds are needed), then checked on the lab stills. The heel faults turn the foot about the
ball of the foot (`toe_*`, which these rigs have) rather than the virtual toe tip the library's
calf pieces pivot on (0.38 torso lengths, ~22 cm, further than the ball's ~15 cm), and move the
body with the ankle; the sizes were tuned so the ghost's knee stays near straight (171-176°;
smaller body moves left the hip-ankle span longer than the leg, which the solver draws as a
locked, stretched leg).

- Bodyweight: toes `calfStand500RolledOut()` (ankles ~6 cm and knees ~3.5 cm out from the midline,
  seen from the front, `faceOn`; at 4.7 cm in round 1 it read only faintly); knees
  `calfKneesDipped(body: carried)` (knees 175° -> ~143°, the body ~4 cm down; bottom); top
  `calfStand500Heels("*", turn: 20, ...)` (ankle 138° -> ~117°, the body ~3 cm down and ~4 cm back;
  top); floor `calfStand500Heels("*", turn: -22, ...)` (ankle 104° -> ~126°, the heels ~5 cm off the
  floor; bottom). Tempo has none.
- Dumbbell: arms `armsSwungForward(20, strength: calfHeelHeight(from: 0.9, to: 0.97))` (the hands
  ~18 cm forward at the top); knees, top and floor as the bodyweight raise. Tempo has none.
- Single-leg dumbbell: post `pulledOnSupport(strength: .always).seen(faceOn)` (shared piece: the
  trunk 12° toward the post, the head ~14 cm, the right elbow 97° -> ~71°; top); hips
  `calfStand500HipDropped(0.1)` (the right hip and hanging leg ~6 cm lower, the pelvis ~3 cm, seen
  from the front; top); knee `calfKneesDipped("L", body: calfOneLegBody, reseat: ["forearm_R"])`
  (176° -> ~144°; bottom); top (left heel 20° lower, 138° -> ~116°; top); bottom (the heel 25° up
  from its stretch, 88° -> ~109°, level with the step's top; bottom).
- Single-leg machine: pads `calfStand500OneLegHipsBack` (hips ~12 cm back, the hanging leg with
  them, the left knee 176° -> ~151°; top); free `calfStand500FreeFootDown(45)` (the right knee
  129° -> ~174°, the foot ~18 cm lower and ~25 cm forward, beside the working foot; bottom); knee
  `calfKneesDipped("L", body: calfStand500MachineOneLegBody)` (bottom); top (142° -> ~121°, knee
  ~173°); bottom (84° -> ~110°, knee ~172°).
- Knee direction (review): the port's angles were unsigned, so the review re-ran every ghost with
  the knee's side of the hip-ankle line (`SCRATCH/calfstand/review/check.py`). Three re-seats bent
  a near-straight knee backward, past straight, because the hips move ahead of the old knee line
  and `.resolve` keeps the knee on the side it already sits: the hack squat back and knees ghosts
  (~20° and ~42° backward, plain on the lab shots) and, slightly, the donkeys' left knee at the
  bottom (~9°) and the hack squat bottom (~4°). Each now nudges the knees forward in the room
  before the re-seat (`.shift(["shin_*"], ahead: 0.1)` in the two sled pieces, `kneeAhead` 0.05 /
  0.1 in `calfStand500Heels`), which only picks the side: the angles are unchanged and every knee
  bends forward at every moment of the rep.
- Donkey (the back fault seen 0.5 further toward the front, see Labels): hinge
  `calfStand500TrunkRaised(15)` (trunk 15° up about the hips, the head ~18 cm, the
  elbows 95° -> ~159° with the hands on the pad; top); back `calfStand500BackRounded(0.14)` (the
  lumbar spine ~8 cm toward the ceiling; bottom; 0.1 read too faintly in round 1); knees
  `calfStand500HingeKneesBent(0.08)` (hips ~5 cm lower, knees 174° -> ~141°; bottom); top (151° ->
  ~128°, the hips ~3 cm lower, the shoulders staying on the pad; top); bottom (95° -> ~127°, the
  hips ~6 cm higher, knees ~171°, `kneeAhead: 0.05`; bottom).
- Machine donkey: back, knees, top and bottom as the donkey; the back fault is seen from 0.5
  further toward the front (a total of -0.8, see Labels). The pad cue has no ghost.
- Hack squat (all seen side-on to the sled, `sledSide`, a total of -1.57): back
  `calfStand500SledHipsOff(forward: 0.12, down: 0.1)` (the pelvis ~9 cm off the pad and down the
  sled, the knees bending forward 175° -> ~160°; top); knees `calfStand500SledSinks(0.12)` (the body
  ~7 cm down the sled, knees bending forward 175° -> ~138°; bottom); top (134° -> ~113°, the body
  ~5 cm down the sled, knees ~171°); bottom (75° -> ~109°, the body ~8 cm up the sled, knees ~176°,
  `kneeAhead: 0.1`). The feet cue has no ghost.
  Side-on, the near plates hide much of the body, but the ghost is drawn over them.

## Uncertain

- No EMG study of any of these seven exact lifts; every fraction is ranked from the knee-angle
  studies and the paint, and the secondary rows are judgements.
- Kassiano 2023 trained young women on a horizontal leg press for 8 weeks; the copy names it as one
  study.
- Kim 2022 studied five healthy men with a smart insole and EMG; it compared raises with the ankle
  everted and inverted, so the copy says only that raises rolled onto the outside edge drew less
  peroneus longus work than raises with the weight toward the big toe, and calls it a small study.
- ExRx's hamstring-gastrocnemius explanation for hip-bent calf raises is ExRx's reasoning, not a
  measurement; the copy attributes it and hedges.
- ExRx was read through Internet Archive copies (the live site blocks automated fetches).
- Shared, outside this family's files: in the hack squat framing the legend's two lines sit over
  the machine's dark base, and the secondary line (QUADRICEPS · HAMSTRINGS) is dark grey on dark
  grey, hard to read; in the mistake views (`roomBelow` lift) the head of a standing lifter
  reaches behind the COMMON MISTAKE chip in several front and side views (bodyweight toes and
  top, single-leg hips, post and pads). Reported to the lead.

## Change log

- 2026-10-04, draft: copy, setup, ghosts and moments for all seven; `spec_500.py calfstand` OK;
  lab check BUILD SUCCEEDED on the first build.
- Lab round 1: every shot showed the simulator's home screen. The app crashed on launch
  (`EnvironmentValues` assertion): `Exercise3DView` now reads `Ads`, `Purchases` and `Paywall` from
  the environment (edited 2026-10-04 14:21), and the shared harness
  (`SCRATCH/ContentView.harness.swift`) did not inject them. The harness's two `Exercise3DView`
  branches now add `.environment(Purchases())`, `.environment(Ads(purchases: Purchases()))` and
  `.environment(Paywall())` (the backup is `SCRATCH/calfstand/ContentView.harness.before.swift`);
  reported to the lead, since every family's lab run uses it.
- Lab round 1 (rerun): labels shortened and moved (bodyweight, dumbbell, hack squat), seen on the
  real screens; single-leg dumbbell, donkey and machine donkey labels relaid (see Labels). Ghosts:
  roll-out raised to 6 cm, the donkey back hump to 0.14 torso lengths.
- Lab round 2: the single-leg hips pill off the dumbbell, the donkey hinge pill off the eye button,
  the machine donkey back label to the left with its fault turned 0.5.
- Lab round 3: the donkey's top-right pills sat on the hips in the (lifted) mistake views, so its
  back label went top left with its fault turned 0.5, as the machine donkey's, and the hinge label
  became Forearms rest, to the near hand, on the left. The machine donkey's pad pill touches the
  lever's bracket for a moment at the top of the rep (kept: the only free spot on that side; the
  review's shot measured ~6 pt clear, see Labels).
- Copy review: no sentence repeats within the family or with the library's five calf contents; the
  hack squat bottom why no longer compares with "these calf raises" (the reader sees one).

- Lab round 4 (donkey only) confirmed the left-hand donkey layout; a final full shoot of all seven
  (`SCRATCH/lab/calfstand/`, trainer at 0 / 1.5 / 3 s and all 31 ghosts) shows every label off the
  lifter and moving equipment, apart from the machine donkey pad pill's brief touch on the
  lever's bracket at the top of the rep, and every ghost attached and readable. Earlier rounds
  are kept in `SCRATCH/calfstand/round1-4/`.
- Independent review (2026-10-04): every cited study re-read on Europe PMC (abstracts; full texts
  of Gentil 2020, Kim 2022 and Kinoshita 2023) and every ExRx page re-fetched from the Wayback
  Machine; all exist with the details cited. Fixed: Kim 2022 overstated (little vs less; it
  compared eversion with inversion), Gentil 2020's normalisation described, Signorile's subjects
  (experienced subjects, not lifters), the Nakamura inference (the way down is part of the work,
  not that slowness was tested), ExRx's load slightly forward (not over the toes), the hack knee
  sentence (anatomy, then the study), the donkey setup order and hinge mistake (arms, not
  forearms), the ankle wording (rolling out tips the ankles outward), and the secondary rows'
  roles stated as minor. Ghosts: the hack squat back and knees ghosts bent the knees backward
  (and the donkey and hack bottoms slightly), fixed with a forward knee nudge before the re-seat.
  Labels: the single-leg machine's Hips under the pads sat on the chest (now Stand tall) and Left
  knee straight touched the thigh (now Knee straight); the dumbbell's Dumbbells at sides covered
  the far plate at the top (now Hang still, after Hang at sides cleared it by only ~3 pt in review
  round 1); the single-leg dumbbell post pill moved to 0.24 so its leader crosses less of the chest
  that hides the hand at the top. Glows: the one-leg raises
  no longer glow the hanging right calf. Two review lab rounds; final output in
  `SCRATCH/lab/calfstand/` (pre-review shots in `SCRATCH/calfstand/review/before_review/`, review
  round 1 in `SCRATCH/calfstand/review/review_round1/`).
