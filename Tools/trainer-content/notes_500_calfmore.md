# 401-500 folder, round 2: more calf work (2026-10-04/05)

Six calf exercises from the builder's 415-444 exports: 415 Elevated Calf Raise, 416 Bent-Knee Calf
Raise, 422 Calf Raise Hold, 423 Calf Raise Pulse, 421 Farmer's Walk on Toes and 424 Banded Plantar
Flexion (models `Legs/<Resource>.usdc`). `spec_500_calfmore.py` holds the copy and setup steps (its
header lists what each model shows and the full citations), `Tools/fault-review/faults_500_calfmore.swift.txt`
the ghosts and `Tools/fault-review/fault_moments_500_calfmore.json` the moment each ghost is stilled.
This file maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The leg and arm briefs (`SCRATCH/briefs2_legs/<Resource>.md`, `SCRATCH/briefs2/<Resource>.md`),
  `SCRATCH/tiers2.txt`, `joints.json` and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`).
- The rigs straight from the USD with Blender's Python + pxr (`SCRATCH/calfmore/`): `measure.py`
  (the calfstand family's: joints, knee/hip/ankle/elbow angles, skinned shoe points per foot, the
  world bounds of every `HG_*` prim) and `series.py` (every frame or every second frame: both
  knees and ankles, ankle-joint height, the backmost shoe point's height for each foot, the
  lowest shoe point, pelvis, trunk lean, elbows and hands; `series_<Resource>.json`). The ankle is
  the shin-to-foot-bone angle (shin, ankle joint, `toe_*`).
- Ghosts: `SCRATCH/calfmore/gh.py`, a Python port of `FaultGhost.solve` (body frame, shift / turn /
  straighten / resolve, the strengths, tips, `_bent` roles) plus the trainer projection (the
  framing from the briefs, the fault's `view`, the `roomBelow` 0.26 shrink and lift); it
  reproduces `joints.json` exactly at view 0, room 0. It prints every moved joint in cm and pt,
  the knee, elbow and ankle angles before and after, a bone-length check and whether each knee
  still bends to the same side of its hip-ankle line. `pieces.py` mirrors the Swift pieces;
  `t1.py`-`t7.py` sized them.
- Labels: `preview_500.py calfmore`, then `SCRATCH/calfmore/ov.py` (the calfstand overlay: pills
  ~24 + 6.4 pt per character, 28 pt tall, with the 8 pt edge clamp; leaders to the probed joint
  at each still; the eye button and legend line boxed) over the five stills, then the lab shots.
- Sources: Europe PMC REST records (abstracts) for every study, full texts of Uchida 2016
  (PMC4868225) and, through round 1, Kim 2022; ExRx through the Internet Archive copies the
  calfstand family saved (`SCRATCH/calfstand/exrx/*.html`, re-read here with its `txt.py`); web
  guides read with WebFetch on 2026-10-05; the NASA KSC page with curl
  (`SCRATCH/calfmore/lit/nasa_ankle.html`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.592 m), toe joints at the ball of the foot (`toe_L/R`,
  ~15 cm from the ankle joint). Every clip is 7.96 s and loops.
- Ankle readings: ~106 degrees with the sole flat on the floor and the shin ~6 degrees forward
  (the hold and pulse models at rest, heels 1.4 cm up at the backmost shoe point, the sole within
  0.5 cm of the floor along its length). Neutral (Kassiano 2023's 0, the foot at 90 degrees to the
  tibia) therefore reads ~112 on these rigs: 105.7 + the 6.3 degree shin lean on the hold at rest,
  97.1 + the 15.5 degree lean on the bent-knee raise. (The draft and review used round 1's ~109;
  verification re-measured it, and the dorsiflexed / plantar flexed degrees below are read from
  112.) The banded model starts at 109.6, within ~2 degrees of neutral, with the soles ~3 degrees
  off vertical: the toes point up.
- Knee-angle logic, as round 1: knee straight -> the gastrocnemius leads with the soleus still a
  strong primary (calfstand UNLOADED 0.78 / 0.60 for body weight on two legs, LOADED 0.86 / 0.66
  with added load); knee at ~90 -> the soleus leads (calfseat 0.86 soleus). The bent-knee raise
  (knees 146, 34 degrees of flexion) sits between and is ranked from the studies that tested a
  45 degree bend (below).
- Paint (`tiers2.txt`): GastrocnemiusLateral, GastrocnemiusMedial and Soleus bright on all six ->
  "Gastrocnemius" and "Soleus" PRIMARY everywhere. Dim: BicepsFemoris, Semimembranosus,
  Semitendinosus on the elevated raise -> "Hamstrings"; those plus RectusFemoris and the three
  vasti on the bent-knee raise, hold and pulse -> "Quadriceps", "Hamstrings"; on the farmer's
  walk the forearm flexors and extensors, brachioradialis, palmaris longus, the three trapezius
  parts, rhomboid major, the hamstrings and the quadriceps; nothing dim on the banded flexion.
  All row names pass `part_of()`.
- Legend width: one line per rank, ~43 characters. The farmer's walk's secondary line is
  FOREARMS · TRAPEZIUS · QUADRICEPS (33); a fourth name would run past it, so the rhomboids and
  hamstrings are named in its stabilisers, as the calfstand dumbbell raise did with the rhomboids.
- No EMG study of any of the six exact exercises was found; every fraction is a judgement call
  (see each exercise). Secondary rows are paint-led LOW rows for minor roles, except the farmer's
  walk's forearms (0.40, see there).
- Library rows (checked against the models, no change needed): Elevated, Hold, Pulse
  GASTROCNEMIUS / BODYWEIGHT / beginner (knees straight); Bent-Knee SOLEUS / BODYWEIGHT /
  beginner (the soleus is ranked first here, see below; the shift is modest, so the row names the
  muscle the bend favours, not one that does all the work); Farmer's Walk on Toes GASTROCNEMIUS /
  DUMBBELL / intermediate; Banded Plantar Flexion GASTROCNEMIUS / BAND / beginner (knees 170).

## Sibling and library check

- Round 1 (`spec_500_calfstand.py`, `spec_500_calfseat.py`, read 2026-10-04): the same ankle measure
  (round 1 read neutral as ~109; these rigs give ~112, see above), same sources where they overlap (Kassiano 2023, Signorile 2002, Cresswell 1995,
  Price 2003, Kinoshita 2023, Kawakami 2002, Nakamura 2025, Kim 2022, Akuzawa 2017, ExRx Calf
  Exercise Analyses and muscle pages), same UNLOADED / LOADED values and the same paint-led LOW
  rows (hamstrings 0.15). The claims agree: the stretched range below a flat foot grew the
  gastrocnemius most in Kassiano 2023 (the elevated raise reaches it, the floor raises cannot,
  the pulses and the hold sit at the other end); with the knee bent the soleus takes a larger
  share; bouncing hands work to the tendon.
- The Elevated Calf Raise is the calfstand Single-Leg Dumbbell Calf Raise's step and stretch on
  two legs with no dumbbell and no post (same `HG_ForefootStep`, same ~5 cm below / ~13 cm above
  the step). The hold and pulse are the calfstand Bodyweight Standing Calf Raise's stance on the
  floor, held or pulsed at the top instead of repeated. The farmer's walk differs from the
  library Farmer's Carry (forearms primary, a slow walk) by the heels never touching down and
  stepping on the spot.
- No cue, setup or comparison sentence repeats word for word within the family, with the library
  or with round 1 (checked by script after the first draft, which repeated six setup steps and
  two cue sentences; all reworded).

## Elevated Calf Raise

Model facts: both feet on a 15 cm step (`HG_ForefootStep`, x -0.4..0.4, z 0.123..0.313), the
front ~17 cm of each shoe on it, the toe joints at z 0.195 (~7 cm in from the back edge), heels
and arches off; no load, no support, arms hanging (elbows 170), knees 175-176, trunk upright.
Ankle 89 -> 142 (~23 degrees dorsiflexed to ~30 plantar flexed). The heels: lowest shoe point
10.2 cm (4.8 cm below the step's top), backmost point 10.9 -> 28.2 cm (~17 cm of travel). Up
0.08-1.0 s, held at the top 1.0-2.08 s, down 2.08-3.42 s, resting in the stretch 3.42-4.08 s, then
again.

| Claim | Source |
|---|---|
| Only the front of each foot on the step, heels off the back; ExRx sets it up on a calf block with the arches and heels off and says any step that will not tip can be the block | ExRx Standing Calf Raise (bodyweight): "Position toes and balls of feet on calf block with arches and heels extending off"; "Exercise step that will not overturn can be used as calf block"; the model |
| The heels go about 5 cm below the step, into the range below a flat foot; training only that lower range grew the gastrocnemius more than only the range above it (eight weeks) | The model (4.1-4.8 cm); Kassiano 2023 (initial -25 to 0: medial +15.2% vs final +3.4%, lateral +14.9% vs +6.2%) |
| From the stretch below the step to full height the heels travel about 17 cm; ExRx notes the top stays hard because the ankle cannot straighten out the way other joints do | The model (10.9 -> 28.2 cm); ExRx Calf Exercise Analyses ("the upper portion of the calf exercises is relatively more difficult ... in most people, the ankle cannot extend straight like other joints"). Verification: the draft's "like a knee or elbow" and "the whole range the step allows" went beyond the source and the model; reworded |
| The gastrocnemius starts on the thigh bone above the knee, so it lifts best with the knee straight or nearly straight (review: was "needs", softened to agree with the bent-knee copy); ExRx keeps the knees straight or bent slightly only in the stretch and counts the quadriceps as helpers once they bend, so a deeper dip brings the thighs into the rise | ExRx Gastrocnemius (origin: femoral condyles); ExRx Calf Exercise Analyses ("it must be at least partially stretched across a straight or nearly straight knee"); ExRx Standing Calf Raise comments ("Keep knees straight throughout exercise or bend knees slightly only during stretch. Quadriceps serve as synergist muscle if knees are bent slightly during stretch"). Verification: "lets the thighs drive the rise" overstated a synergist role; now "brings the thighs into the rise" |
| No bounce: in an all-out dip-and-push the gastrocnemius fibres stayed nearly the same length while the tendon stretched, stored the energy and gave it back; a brief settle leaves less of that spring, so more of the lift comes from the calves | Kawakami 2002 (six men, maximal effort, with versus without the counter-movement: more Achilles force, power and work with it; medial gastrocnemius fascicles "almost isometrically" while the muscle-tendon unit lengthened); the last clause is the inference from that comparison, as calfseat's (review: was "takes that spring out", softened). Verification: "quick" became "all-out" (the abstract says maximal effort, not how fast) and "calf muscle fibres" became "gastrocnemius fibres" (only the medial gastrocnemius was imaged) |
| Tempo: rise in under a second, lower a little longer | The model (~0.9 s up, ~1.3 s down) |
| Setup: a sturdy step near a wall or rail for balance | ExRx (step that will not overturn; "Place hand on support for balance"); the model uses no support, so the copy only offers it |

Activation: UNLOADED (Gastrocnemius 0.78, Soleus 0.60), both PRIMARY; Hamstrings 0.15 LOW (dim, no
source measures them in a calf raise; as calfstand). Stabilisers: tibialis posterior, peroneals,
toe flexors (Akuzawa 2017), core.

## Bent-Knee Calf Raise

Model facts: flat floor, no equipment, feet hip-width (ankles 0.21 m apart, toes ~10 degrees
out), knees held at 146 (34 short of straight) all clip, hips 147, trunk 14-16 degrees forward,
arms hanging. Ankle 97 -> 133: at the bottom the heels are on the floor and the ankle is ~15
degrees dorsiflexed, the shins' 15.5 degree forward lean with the sole flat; at the top ~21
plantar flexed. The
heels rise 1.4 -> 13.2 cm (~12 cm). Timing as the elevated raise.

| Claim | Source |
|---|---|
| Bend the knees partway (about a third of the way to a right angle) and keep exactly that bend | The model (146 throughout, a 34 degree bend); Physitrack Soleus Raises ("Keeping your knee slightly bent, rise up onto your toes") and Calf raises on step with knees bent ("Ensure your knees remain slightly bent throughout"). The guides say slightly bent; the copy follows the model's clearer bend (review: the draft's a little / small bend undersold 34 degrees) |
| The gastrocnemius crosses the back of the knee, so a bent knee slackens it and moves part of the work onto the soleus, which starts below the knee; ExRx notes the soleus becomes more active as the knee bends | ExRx Gastrocnemius (biarticulate; "active insufficiency through the completion of ankle plantar flexion when the knees are more flexed (soleus becomes more active)"); ExRx Soleus (origin: upper posterior tibia and fibula) |
| In a heel-raise study the shift at a 45 degree bend was small, so both muscles keep working | Hebert-Losier 2012a (soleus activity 4% greater, both gastrocnemius heads 5% lower at 45 than at 0; "might not be enough to significantly influence ... muscle-specific benefits"); Price 2003 (at 45: soleus and lateral gastrocnemius active on MRI); the model's bend (34) is smaller still |
| Straightening on the way up undoes it and lets the thighs push you up | Mechanics (extending the knees raises the hips); ExRx (quadriceps synergists when the knees bend) |
| Push through the big and second toes; where the weight sits changes which muscles help; raises tipped onto the little-toe side drew less from the peroneus longus than raises pressing toward the big toe (small study, insoles) | Kim 2022 full text (five healthy men, smart insoles plus EMG; double- and single-leg raises with the ankle everted or inverted; inverted heel raises "do not well recruit the PL"; the proper, everted raises drew more, "especially during the concentric rise phase"). It had no neutral-foot condition, so review replaced the draft's "as well as raises done straight" with the big-toe comparison, as round 1's review did. The draft's "bent knees make it easy to drift outward" had no source and was cut |
| Heels still rise about 12 cm; a short pause at the top, which ExRx notes stays hard | The model; ExRx Calf Exercise Analyses |
| The floor is the bottom; with the shins leaning forward the ankles are already past a right angle there | The model (ankle 97, ~15 degrees dorsiflexed: the sole flat, the shins 15.5 degrees forward). Verification: "a little past" undersold 15 degrees; "a little" cut |
| Lower more slowly than you rise; a leg that also lowered the heel on its own over 3 s gained strength and thickness, the raise-only leg neither | Nakamura 2025 (15 sedentary men, 8 weeks; MVIC torque +32.9%, muscle thickness +9.1% in the lowering leg, no increase in the raise-only leg); the model (~0.9 s up, ~1.3 s down). Verification: "lowered the heels" became "the heel" (one leg lowered) |
| Setup: lean the trunk slightly forward to stay balanced; a wall within reach | The model (trunk 14-16 forward, hips 147); ExRx (a hand on a support for balance) |

Activation: Soleus 0.70 HIGH and Gastrocnemius 0.62 MODERATE, both PRIMARY (both painted bright).
The soleus is ranked first for the bend: Price 2003 (at 45 degrees the soleus and the lateral head
showed on MRI, not the medial head), Hebert-Losier 2012a (+4% / -5% at 45), Signorile 2002 (the
soleus higher at the bent angles than at 180, the medial head lower), Cresswell 1995
(gastrocnemius EMG falls with knee flexion, soleus holds), ExRx (the soleus more active as the knee
bends; the primary plantar flexor in the seated, 90 degree raise, not at any bend). The shift is
modest at 34 degrees, so the gastrocnemius stays a strong primary: the values sit about two-fifths
of the way (34 of 90 degrees is 0.38; the soleus moved 0.10 of 0.26, the gastrocnemius 0.16 of
0.38) from the knee-straight UNLOADED 0.78 / 0.60 toward the seated 0.40 / 0.86, the soleus
first only narrowly; a judgement call (review: the draft's 0.72 / 0.58 moved further than the small
45 degree shift the copy cites). Hebert-Losier 2012b (fatigue
did not differ with knee angle) is why the copy does not promise the bend isolates the soleus.
Quadriceps 0.30 LOW (holding the 34 degree bend under body weight; no EMG, a judgement);
Hamstrings 0.15 LOW (paint-led).

## Calf Raise Hold

Model facts: flat floor, knees 175-176, arms hanging. Up 0.21-0.92 s (~0.7 s), held at the top
0.92-7.17 s (~6.25 s; ankle 144.5, ~32 plantar flexed; backmost heel point 13.8 cm, ~12.4 cm above
rest), down 7.17-7.83 s (~0.7 s), resting ~0.4 s across the loop. The body rises ~7 cm and drifts
~10 cm forward over the balls of the feet. Logged in seconds already (catalog).

| Claim | Source |
|---|---|
| Rise as high as you can and keep the heels there; ExRx notes the top stays hard because the ankle cannot straighten out to rest on | ExRx Calf Exercise Analyses ("in most people, the ankle cannot extend straight like other joints. ... This 'incomplete lockout'"); the model (no sag across the 6 s). Verification: "never" became "cannot", closer to ExRx's "in most people ... cannot" |
| As the calves tire the heels can creep down to an easier height | Plain consequence; the ghost shows it. (Not a measured claim; the draft's "tend to" was softened) |
| The hold works the calves at their shortest; in a review of isometric training, holds at longer muscle lengths built more muscle than holds at shorter ones, so use it alongside full-range raises | Oranchuk 2019 ("Isometric training at longer muscle lengths ... produced greater muscular hypertrophy when compared to equal volumes of shorter muscle length training") |
| A guide lists rising onto the outer edges as a common mistake; the peroneus longus worked harder during the rise with the weight toward the big toe than with the ankle rolled out | Caliverse Calf Raise Hold (FAQ, common mistakes: "bending the knee, using momentum, rising onto outer foot edges, holding your breath, and lowering too quickly"); Kim 2022 (everted vs inverted, see the bent-knee raise). Verification: Kim showed the PL difference in the rise phase, and a hold has no rise after the first, so the copy now says "during the rise" |
| Knees straight and still; the gastrocnemius holds the heels up best with the knee straight or nearly so; soft knees bring the thighs in | ExRx Calf Exercise Analyses ("at least partially stretched across a straight or nearly straight knee"); Caliverse ("bending the knee" among the mistakes; "Ensure that the knee is kept stationary at all times"); mechanics. Review softened "only with the knee straight": the bent-knee copy (Hebert-Losier 2012a) says both muscles keep working at 45 degrees |
| To balance on the balls of the feet your weight has to stay over them; a guide has you stay upright without leaning forward; folding at the hips moves the trunk's weight ahead | Caliverse, step 4 ("maintain upright posture without leaning forward"); mechanics. Verification: the draft and review said the guide lists leaning forward among its common mistakes; its mistakes list (bending the knee, using momentum, outer foot edges, holding the breath, lowering too quickly) does not include it, so the copy now cites the instruction |
| A guide has you breathe steadily at the top and lists holding the breath among the common mistakes; the model rises in under a second, holds about six, lowers in under a second | Caliverse ("Hold the top position for the required time while breathing steadily"; common mistakes: "holding your breath"); the model. Review cut the draft's unsourced "breathing evenly lets you hold the top for the whole set time" |

Activation: UNLOADED, both PRIMARY; Quadriceps 0.20 and Hamstrings 0.15 LOW (dim; holding the
straight knees steady; paint-led judgements, no EMG). Stabilisers: tibialis posterior, peroneals,
toe flexors, core.

## Calf Raise Pulse

Model facts: flat floor, knees 175-176, arms hanging. Up 0.21-0.75 s (~0.55 s) to ankle 140, then
ten pulses: dips to ankle ~131 at 1.0, 1.67, 2.33 ... 7.0 s and back to ~142 at 1.33, 2.0 ...
7.33 s, one every 0.67 s (about three every two seconds); the backmost heel point moves between
10.2 and 13.3 cm (~3 cm) and never comes below ~10 cm until the set ends; down 7.33-7.92 s
(~0.6 s), ~0.3 s at rest across the loop. The pulses run at ~19-30 degrees plantar flexed, the
upper part of Kassiano 2023's final range (0 to +25) and a little beyond it.

| Claim | Source |
|---|---|
| Rise all the way first; every pulse comes back to full height; a pulse guide has you rise as high as you can first | Lyfta Bodyweight Standing Pulse Calf Raise ("raising your heels as high as you can off the ground while keeping your knees straight"; "lower your heels back down just slightly, not all the way"; "immediately raise your heels back up again"); the model (every top back at ~142; the first rise reaches ~140) |
| The top of the range, where the ankle cannot straighten out and ExRx notes a calf raise stays hard | ExRx Calf Exercise Analyses (verification: "never" became "cannot", as the hold) |
| The heels move about 3 cm and never touch down; ExRx: the calves hold tension the whole time unless the heel rests on the floor | The model; ExRx Calf Exercise Analyses ("Unless the heel rests momentarily on the floor or exercise apparatus, the plantar flexors ... must maintain tension") |
| Trade-off: training only the upper part grew the gastrocnemius less than training the stretched part below a flat foot; pair pulses with full-range raises | Kassiano 2023 (final range +3.4% / +6.2% vs initial +15.2% / +14.9%) |
| Knee bob: the gastrocnemius works best with the knee straight or nearly straight | ExRx Calf Exercise Analyses; Lyfta ("keeping your knees straight"); softened in review as the hold |
| The peroneus longus did less when the ankle rolled out than when the weight stayed toward the big toe | Kim 2022 (everted vs inverted) |
| About three pulses every two seconds; a pulse guide warns against rushing; a fast bounce lets the tendon help spring the heels back, since in an all-out dip-and-push the tendon, not the gastrocnemius fibres, stored the energy and handed it back | The model; Lyfta ("Avoid rushing through the movements"); Kawakami 2002 (the fascicles first lengthened a little, then stayed nearly constant while the muscle-tendon unit lengthened; the authors conclude the fibres worked almost isometrically, "leaving the task of storing and releasing elastic energy ... to the tendon"). Review replaced the draft's "while the tendon did the work". Verification: "took up the stretch" still overstated it (the fascicles did lengthen early in the dip), so the copy now says only what the authors concluded (stored and handed back the energy); "spring the heels back" became "help spring"; "quick" became "all-out" |
| Lower to the floor under control after the last pulse | Lyfta ("After completing your set, slowly lower your heels back down to the ground, ensuring to maintain control"); the model (~0.6 s) |

Activation and stabilisers as the hold.

## Farmer's Walk on Toes

Model facts: a dumbbell in each hand (`HG_DumbbellL/R`, 0.34 m long, handles front to back, palms
in, arms straight at 176 and ~13 degrees out from the sides, centres ~0.9 m up). The heels stay up
the whole clip: the standing heels' backmost point ~11.5 cm up, standing ankles 130-137 (~18-25
plantar flexed), the lowest heel reading of either foot in the clip 11.5 cm. It steps IN PLACE:
the left foot lifts 0.0-0.5 s (knee to 132, the sole ~3 cm off the floor at 0.25 s), both feet
down 0.5-0.67 s, the right foot 0.67-1.17 s, and so on: 12 steps in the clip, one every 0.67 s.
The ankles stay at the same z all clip (no travel); the pelvis shifts ~2.6 cm toward the standing
leg each step and stays at the same height. Standing knees 168-175, trunk 1 degree forward.
Logged in seconds already (catalog).

| Claim | Source |
|---|---|
| Stay on the balls of the feet; the heels never touch the floor | The Prehab Guys, Farmer Carry - Dumbbell, On Toes ("Your heels should never contact the floor"); the model |
| The calves hold your body and both dumbbells the whole time, on one foot each time the other lifts | The model (single support each step) |
| One guide warns against letting the heel drop as a foot takes the weight | The Prehab Guys, Toe Walking ("The goal is to stay up as tall as you can and not let your heel drop when you put weight on it"; compensation: "Do not let your heels drop!"). Verification: the draft's "Guides ... warn" rested on this one page for the as-a-foot-takes-the-weight point (the farmer carry page says only that the heels should never contact the floor), so the copy now says one guide |
| Stand tall; leaning tips the weight ahead of the feet; guides say to stand tall, chest up | The Prehab Guys ("Stand up tall", "Don't sag your shoulders forward as you walk, stay upright"); Fitbod Dumbbell Toe Walks ("Maintain good posture by keeping your shoulder back, chest up"); mechanics. Verification: "guides ... say to stay upright" was The Prehab Guys' wording only; now each guide's own words |
| Shoulder blades slightly back; guides cue the shoulders back and one says you will feel the shoulder blades working with the calves; sagging rounds the upper back | The Prehab Guys ("Keep your shoulder blades pulled slightly back"; "You will feel the shoulder blades and calves working with this exercise"); Fitbod ("keeping your shoulder back, chest up"); the library Farmer's Carry shoulder cue. Review: the feel claim is the Prehab Guys' alone, so the copy says one guide |
| Every step leaves you on one foot; the standing gluteus medius holds the pelvis level; ExRx: it keeps the pelvis from sagging on the unsupported side; in one farmer's walk study it worked at about a quarter to half of its maximum | ExRx Gluteus Medius ("Steadies pelvis so it does not sag when opposite side is not supported with leg"); Stastny 2015 (26-47% MVIC, group means, 16 trained men at 75% of 6RM); the model. Verification: the closing "A dropping hip tips your weight and the dumbbells toward the lifted side" had no source and was cut |
| Short, quiet steps on the spot, about three every two seconds, each foot lifting a few centimetres; one guide calls for controlled, quiet steps, one at a time; you can walk forward the same way | The model (1.5 steps a second, sole ~3 cm up, no travel); The Prehab Guys ("Take slow, controlled, and quiet steps one at a time"; it walks forward). The copy drops "slow": the model steps at 1.5 a second |
| Setup: grip the dumbbells in the middle, palms in; rise onto the balls of the feet, then march | The model; the library Farmer's Carry set-up |

Activation: LOADED (Gastrocnemius 0.86, Soleus 0.66), both PRIMARY: body weight and two dumbbells,
on one foot between steps. Forearms 0.40 MODERATE (holding the dumbbells for a whole timed set:
between the calfstand dumbbell raise's 0.30 and the library Farmer's Carry's 0.80, where grip is
the target; no EMG, a judgement), Trapezius 0.30 LOW (holding the shoulders under the dumbbells;
the calfstand dumbbell raise's 0.28; Fitbod lists forearms and trapezius as secondary), Quadriceps
0.25 LOW (steadying the standing knee; the Prehab Guys' Toe Walking: "you may also feel you
quadricep thigh muscles working as well", sic; a judgement). Stabilisers: gluteus medius (Stastny 2015), rhomboids and
hamstrings (painted dim; legend width), core, tibialis posterior, peroneals.

## Banded Plantar Flexion

Model facts: long-sitting on a mat (`HG_Mat`), trunk upright (4 degrees back), hips 90, knees 170,
feet hip-width (ankles 0.18 m apart). A rolled towel (`HG_TowelRoll`, 4.3 cm high, z 0.29-0.33)
lies under the lower calves ~15 cm above the ankle joints (z 0.46), so the heels hang clear of the
mat (the lowest point of each shoe 3.1 cm above the mat at the start, 1.3 cm at full point). Two bands (`HG_BandL/R`),
one looped round the ball of each foot (the loop segments sit on the toe joint all clip), the
ends held in each hand ~19 cm ahead of and ~23 cm above the hip joints (the wrists ~34 cm above
the mat; the draft's "~23 cm above the mat" was the height above the hip joints), elbows bent 87
at the sides and still all clip; the bands stretch as the feet point (hand to ball of the foot
73.5 -> 81.8 cm). Ankle 109.6 (within ~2 degrees of neutral, the toes pointing up) -> 149.6 (40
degrees on, ~38 plantar flexed) over ~1 s, held 1.0-2.08 s, back over ~1.3 s (to 3.42 s), resting
3.42-4.08 s; two reps.

| Claim | Source |
|---|---|
| Push the balls of the feet into the bands until the toes point as far as they go, and pause | UMass Memorial Health / WebMD Ignite, Plantar Flexion (Strength) ("Push on the elastic band with the ball of your foot, pointing your toes ... Hold"); the model (~1.1 s hold) |
| An elastic band pulls harder the further it is stretched; the end of the push is where it resists most; stopping short leaves out the part where the band pulls hardest | Uchida 2016 full text ("tension force increases as the extent of elongation increases regardless of the color"; "the more the band is stretched, the greater the resistance"); the model (hand to ball of the foot longest at full point, 81.8 cm). Verification: "where the band works the calves hardest" (and the comparison's "the point they should work hardest") claimed more than the band data show; both now say where the band pulls hardest |
| The ankles point about 40 degrees from where they start | The model (109.6 -> 149.6) |
| Physiotherapy guides point slowly and return slowly to the start, under control | NASA KSC RehabWorks, Basic Ankle Protocol ("Slowly point toes against the resistance and then slowly return to the start position"); Physitrack ("control the movement as you return to the start position"; "Slowly let your foot back up") |
| The model comes back to a right angle at the ankle each rep, the toes pointing straight up | The model (109.6, within ~2 degrees of neutral on this rig; the sole ~3 degrees off vertical, the shin ~5 degrees off horizontal) |
| Legs straight, kneecaps up | Physitrack ("Keeping your leg still and your knee facing up to the ceiling"; "keep your knee straight") |
| With the knee straight the gastrocnemius stays long enough to help the soleus; ExRx notes that bending the knee makes the soleus more active; bending lets the feet slide toward you and slackens the bands | ExRx Gastrocnemius ("through the completion of ankle plantar flexion when the knees are more flexed (soleus becomes more active)"); mechanics. Verification: "takes over more" overstated "becomes more active" |
| A band only resists as far as it is stretched; the pull rose steadily with how far they were pulled out; one guide has you draw the band toward you as you push | Uchida 2016 (linear fits, r^2 > 0.95); UMass Memorial ("Pull the elastic band toward you as you do this") |
| Sitting with straight legs stretches the hamstrings; ExRx notes that in calf exercises with the hips bent and the knees straight, tight hamstrings can show as a subtly rounded lower back or a slight knee bend (review: was "tend to show as a rounding lower back", which dropped ExRx's knee-bend half and overstated it) | ExRx Calf Exercise Analyses ("Significant flexion of the hip with knee straight stretch the biarticulate hamstrings"; "less hamstring flexibility ... a subtle flexion through the lumbar spine or a slight knee bend") |
| Setup: a rolled towel under the lower calves so the heels are just off the mat; a band round the ball of each foot | NASA KSC ("Place a roll or rolled up towel under the calf to place the ankle up off the floor ... Place the theraband around the ball of the foot"); the model |

Activation: Gastrocnemius 0.60 and Soleus 0.48, both MODERATE PRIMARY (painted bright, nothing
dim). Knees 170, so the gastrocnemius leads as on the calfseat family's 168 degree machines, but
against an elastic band, far lighter than body weight (Uchida 2016's measured tension for the
heaviest Thera-Band, gold, was 8.93 kgf at 250% elongation), so both sit below the UNLOADED values; no
EMG for banded plantar flexion was found; a judgement call. Stabilisers: tibialis posterior,
peroneals, toe flexors (plantar flexor synergists, Akuzawa 2017), forearms (holding the bands).

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`).

- Elevated, bent-knee, hold, pulse (yaw -1.3, the body a narrow column at u ~0.40-0.65): short
  pills only. One cue right of the head at 0.26 (tempo / body, its leader to the chest or neck);
  knees 0.56 left; the far-toe cue (feet / toes, to `toe_R`) 0.70 left above the near-toe cue
  (top, to `toe_L`) 0.78 left so the two leaders ending at the balls of the feet do not cross;
  the heel cue 0.80 right, short (Sink below step, Heels down, Heels stay high, Small pulses),
  because the hanging heel and calf reach u ~0.62 there; the hold's breath cue 0.44 right. Draft
  labels that were too long (No bounce at the bottom over the back of the head; Heels below the
  step, Heels high all hold, Small pulses, heels up and Heels to the floor over the heels) were
  shortened from the overlay.
- Farmer's walk (yaw -1.0, the near dumbbell on the right, the far one on the left): everything
  that points at the body on the left, where only the far arm and dumbbell are: posture (Walk tall,
  to the head) 0.16, shoulders (to the far shoulder) 0.27, hips (to the far hip `thigh_R`, under the
  far dumbbell) 0.62, steps (to the far foot) 0.80; heels (Heels stay up, to the near ankle) 0.80
  right. A right-hand hip or posture leader would cross the near dumbbell or arm.
- Banded (yaw -0.8, the lifter low right, the legs along the mat to the feet on the left): hands
  (to the far fist `hand_R`, visible left of the torso) 0.30 left and top (to the far toes) 0.40
  left, both in the open space above the legs (top was at 0.44 until lab round 3, where the
  lifted, shrunk model of its fault's mistake view brought the ghost toes against the pill's lower
  edge); back (Sit tall, to the head) 0.17 right (at 0.20 the lifted head in the back fault's
  mistake view came within ~3 pt of the pill); return (to the far heel) 0.80 left and knees (to
  the near knee) 0.80 right, below the mat edge with their leaders over the static mat.

## Ghosts

Measured with `gh.py` at each fault's moment, then checked on the lab stills. Every knee in every
ghost bends to the side it bends in the model ("side OK") and every elbow keeps its side. The
review re-ran all 24 with a check of every drawn segment, not only the legs
(`SCRATCH/calfmore/review/check.py`): after the review's two reshaped pieces (hips, back) no
segment changes length by more than 0.5 cm except the farmer's shoulders, the library Farmer's
Carry's own moves (the girdle line ~0.8 cm shorter, spine-to-chest ~0.7 cm longer, kept as the
library has them); the roll-out's shin-to-foot changes ~0.3 cm, as round 1's piece. (The draft's
claim that no bone changed length had only checked the legs: its hip drop stretched each half of
the pelvis ~0.8 cm and its slump the lumbar segment ~3.8 cm.)

| Exercise | Cue | Ghost | Moment |
|---|---|---|---|
| Elevated | bottom | heels 22 degrees up about the balls of the feet (89 -> ~110, level with the step), body ~6 cm up, knees ~175 | bottom |
| Elevated | top | heels 20 degrees lower (142 -> ~121), body ~5 cm down and ~4 cm back, knees ~172 | top |
| Elevated | knees | `calfKneesDipped(body: carried)`: body ~4 cm down, knees 176 -> ~144 | bottom |
| Bent-knee | knees | hips ~3 cm up and ~2 cm back, knees 146 -> ~169 | top |
| Bent-knee | toes | `calfMore500RolledOut`: ankles ~6 cm, knees ~3.5 cm out, seen from the front | top |
| Bent-knee | top | heels 18 degrees lower (133 -> ~115), knees still ~145 | top |
| Bent-knee | floor | heels 22 degrees up off the floor (97 -> ~119), knees still 146 | bottom |
| Hold | height | heels 20 degrees lower (145 -> ~122), knees ~170 | 4.0 s |
| Hold | toes | roll-out, front view | 3.0 s |
| Hold | knees | body ~3 cm down, knees 175 -> ~149 | 4.0 s |
| Hold | body | `leanedForward(15)`: head ~18 cm ahead | 5.0 s |
| Pulse | top | at a peak, heels 16 degrees lower (142 -> ~124) | 2.0 s |
| Pulse | range | at a dip, heels 24 degrees lower (131 -> ~106, flat), knees ~167 | 3.0 s |
| Pulse | knees | body ~4 cm down, knees 175 -> ~144 | 2.67 s |
| Pulse | toes | roll-out, front view | 2.0 s |
| Farmer's | heels | both feet down: heels 28 degrees lower (134 -> ~109, flat), body and dumbbells ~7 cm down, knees ~175; seen -0.5 | 0.58 s |
| Farmer's | posture | `leanedForward(12)`, head ~15 cm ahead; seen -0.5 | 2.5 s |
| Farmer's | shoulders | the library carry's slump: arms ~9 cm forward and down, head ~6 cm; seen -0.5 | 2.5 s |
| Farmer's | hips | `calfMore500HipDropped(24)`: the pelvis tilted 24 degrees about the standing (`_straight`) hip, so the lifted (`_bent`) side's hip ~7.5 cm and the pelvis ~4 cm lower with the pelvis width kept, the lifted foot kept in the air (knee 132 -> ~112); front view. Lab round 1's ~6 cm read faintly; review replaced the drawn-down hip (each half of the pelvis +0.8 cm) with the tilt, as `hipCableHipDropped` | 0.25 s (left foot up) |
| Banded | top | feet 20 degrees back toward the shins (150 -> ~130), toes ~8 cm | 1.5 s |
| Banded | return | feet left 22 degrees pointed (110 -> ~132) | 3.75 s |
| Banded | knees | feet ~5 cm toward the hips, knees 170 -> ~140, ~11 cm up | 1.5 s |
| Banded | hands | hands ~15 cm forward, elbows 87 -> ~125 | 1.5 s |
| Banded | back | `calfMore500Slumped`: a C-curve built from the four spine segments turned in the side plane at their own lengths (lumbar 25 degrees back, lower thoracic 5 back, upper thoracic 15 and neck 45 forward): the lumbar spine ~5 cm back and ~2 cm down, the chest ~6 cm back, the neck ~4 cm and the head ~7 cm lower and ~9 cm forward; seen -0.5. Round 2's version read as a straight lean; round 3's C (review) stretched the lumbar segment 11.4 -> 15.2 cm and shrank the next 15.7 -> 11.7 cm | 3.0 s |

No ghost: elevated feet (where the feet sit on the step) and tempo; bent-knee tempo; hold breath;
pulse rhythm; farmer's steps (size and pace of the steps). The hip ghost uses the `_bent` role, so
in the live mistake view it follows whichever foot is up.

## Uncertain

- No EMG study of any of these six exact exercises; every fraction is a judgement anchored on
  round 1's values and moved by knee angle and load.
- The coaching guides (The Prehab Guys, Fitbod, Lyfta, Caliverse, Physitrack, UMass Memorial /
  WebMD, NASA KSC) are practice sources, not studies; the copy attributes them to guides.
- Kim 2022 had five subjects; the copy calls it a small study. It compared everted with inverted
  raises (no neutral foot), so the copy compares rolling out with pressing toward the big toe.
- Caliverse's Calf Raise Hold is a one-leg hold; the model holds on two feet. Its mistakes list
  (bending the knee, using momentum, outer foot edges, holding the breath, lowering too quickly)
  and its upright, no-lean instruction apply to either, and the copy calls it one guide. Lyfta is
  likewise the one pulse guide read, and The Prehab Guys the one source for quiet steps, for
  feeling the shoulder blades and for not letting the heel drop as a foot takes the weight.
- Kim 2022 showed the peroneus longus difference in the rise phase; the hold copy says so. Its
  EMG figure shows five subjects without a statistical test of the EMG difference.
- Kawakami 2002 was read as the abstract only (the PMC copy is a scanned PDF the fetch could not
  reach), so the copy says "all-out" (the abstract's maximal effort), not how fast the dip was.
- The farmer's hip ghost tilts the pelvis 24 degrees, far more than a real hip drop, so that it
  reads at the front view's size (about 6 cm of drop read faintly in lab round 1).
- Hebert-Losier 2012a tested 45 degrees of knee flexion; the model bends 34, so the copy says the
  shift is small rather than giving a number for this bend.
- Oranchuk 2019 is a review across muscles, not of the calves; the copy says so implicitly ("a
  review of isometric training") and uses it only to suggest pairing the hold with full-range
  raises.
- ExRx was read through Internet Archive copies (the live site blocks automated fetches).
- Shared, outside this family's files: in the Elevated Calf Raise framing the legend's first line
  ends over the grey step (PRIMARY is grey on grey, hard to read); in every mistake view the lifted
  model's head sits behind the COMMON MISTAKE chip (the round-1 open point). Reported to the lead.

## Change log

- 2026-10-05, draft: copy, setup, ghosts and moments for all six; `spec_500.py calfmore` OK;
  overlay-led label fixes (five draft labels shortened, the farmer's walk and banded layouts
  moved, see Labels).
- Lab round 1 (`SCRATCH/calfmore/round1/`, stills 0 / 1.5 / 3 s): BUILD SUCCEEDED on the first
  build; every trainer still with labels off the lifter and the moving dumbbells and bands; all 24
  ghosts attached and readable. The farmer's hip drop (0.1, ~6 cm) read faintly: raised to 0.13.
  Copy check by script: six setup steps and two cue sentences repeated round 1 or the library
  word for word; reworded.
- Self-review (sources, then model fidelity): cut or softened the claims no source carries
  ("bent knees make it easy to drift outward", "tend to creep down", "hands the hold to the
  thighs", "many fast pulses tend to drift"); ExRx's top-of-the-raise point said as "stays hard",
  not "hardest" (ExRx compares it with other exercises' tops); ExRx's soleus note said as "more
  active as the knee bends" (its seated-raise sentence is about 90 degrees); Stastny 2015 called
  one study; the farmer's single support "each time the other lifts", not "between steps"; the
  banded grip corrected (each hand holds both ends of the band on its side).
- Lab round 2 (`SCRATCH/calfmore/round2/`, stills 0.3 / 1.2 / 4.5 s: a foot lifted, mid-pulse,
  mid-hold): labels clear at those moments too; the larger hip drop reads. The banded back ghost
  read as a straight forward lean and its lifted head came within ~3 pt of the Sit tall pill:
  the slump reshaped into a C and the pill moved to 0.17.
- Lab round 3 (`SCRATCH/calfmore/round3/`, stills 0 / 1.5 / 3 s): the C-shaped slump reads and
  clears the Sit tall pill by ~20 pt; in the banded top fault's mistake view the ghost toes touched
  the lower edge of the Point the toes fully pill, so that pill moved from 0.44 to 0.40.
- Lab round 4 (stills 0 / 1.5 / 3 s, all 18 trainer stills and 24 ghosts): nothing else changed
  between rounds 3 and 4. Its shots are kept in `SCRATCH/calfmore/review/before_review/`; the review
  shoot below replaced `SCRATCH/lab/calfmore/`.

## Review (independent, 2026-10-05)

Two passes, sources then fidelity to the models; scripts and evidence in `SCRATCH/calfmore/review/`.

Sources. Every study re-read on Europe PMC (records and abstracts saved as `epmc_<PMID>.json`;
Nakamura 2025's results from PubMed, whose Europe PMC abstract is cut off; full texts of Kim 2022
and Uchida 2016). All fourteen exist with the authors, journals, volumes, pages, DOIs and PMIDs
cited (Signorile 2002's DOI added). ExRx re-read from the Internet Archive copies (Standing Calf
Raise 2025-07-02; Calf Exercise Analyses, Gastrocnemius, Soleus, Gluteus Medius 2024-01-05). Web
guides re-fetched: The Prehab Guys (Farmer Carry - Dumbbell, On Toes; Toe Walking), Fitbod
(Dumbbell Toe Walks: secondary forearms and trapezius), Lyfta (pulse), Caliverse (hold), Physitrack
(Soleus Raises; Resisted ankle plantar flexion in long sitting; Ankle plantar flexion against
resistance band), UMass Memorial (Plantar Flexion (Strength)), and the saved NASA KSC page. Fixed:
- Kim 2022 compared everted with inverted raises; the copy's "as well as raises done straight"
  (bent-knee, hold, pulse) described a neutral condition it never tested. Now: rolled out versus
  weight toward the big toe, as round 1's review settled.
- Pulse rhythm: "while the tendon did the work" overstated Kawakami 2002; now the tendon took up
  the stretch and handed back the energy. The shared tempo why: "takes that spring out" became
  "leaves less of that spring".
- Knee anatomy: "only with the knee straight" (hold, pulse) and "needs a straight knee"
  (elevated) contradicted the bent-knee copy's own evidence that both muscles keep working at a
  45 degree bend; now "best with the knee straight or nearly so".
- Banded back: ExRx says tight hamstrings can show as subtle lumbar flexion or a slight knee bend
  (on calf machines with the hips bent); "tend to show as a rounding lower back" became "can show
  as a subtly rounded lower back or a slight knee bend".
- Hold breath: the unsourced "breathing evenly lets you hold the top for the whole set time" cut;
  the guide's own instruction and mistake kept.
- Guide plurals: where only one guide was read the copy now says one guide (Caliverse for the hold,
  Lyfta for the pulse, The Prehab Guys for quiet steps and for feeling the shoulder blades).
- Bent-knee activation: 0.72 / 0.58 moved further toward the soleus than the small 45 degree shift
  the copy cites; now 0.70 / 0.62 (about a third of the way from knee-straight to seated values),
  the soleus still first, matching the SOLEUS library row. Levels unchanged (HIGH / MODERATE).

Model fidelity (rigs re-sampled with the author's `rigio`/`gh` ports; `review/series.py`,
`review/check.py`): the briefs' facts hold (bent-knee knees 146 all clip, trunk 14-16 forward; the
farmer steps in place, left foot first, the lifted sole ~3 cm up, pelvis ~2.6 cm toward the
standing leg, no travel; banded elbows 87, hands ~19 cm ahead of the hips). Fixed:
- Bent-knee copy said a little / small bend for a 34 degree bend; now partway, about a third of
  the way to a right angle (intro, correct, setup).
- Ghosts: the draft checked bone lengths on the legs only. Checking every drawn segment found the
  banded slump stretching the lumbar segment 11.4 -> 15.2 cm and shrinking the next 15.7 -> 11.7 cm,
  and the farmer's hip drop stretching each half of the pelvis ~0.8 cm. The slump was rebuilt from
  segment rotations that keep every length (same C, the lumbar bulge ~5 cm instead of ~8); the hip
  drop is now a 24 degree tilt about the standing hip (`hipCableHipDropped`'s idiom), the same
  ~7.5 cm drop with the pelvis width kept, and still mirrors to whichever foot is up. The farmer's
  shoulder slump keeps the library carry's moves (~0.8 cm on the girdle line), noted.
- Copy: two sentences near-copied round 1 (the bent-knee correct foot sentence and floor mistake);
  reworded. A script finds no sentence repeated with round 1, the other 401-500 families or the
  library.

- Review lab round (`SCRATCH/lab/calfmore/`, stills 0 / 1.5 / 3 s; log
  `SCRATCH/calfmore/review/lab_review1.log`): BUILD SUCCEEDED, all 18 trainer stills and 24 ghosts
  shot, no crash. Labels unchanged and clear as before. The rebuilt slump reads as a smoother C
  (lumbar back, upper back and head forward) and still clears the Sit tall pill; the tilted hip
  drop looks as before (`SCRATCH/calfmore/review/before_after_changed.png`). No further round
  was needed.
- Left as they were: the activation values other than the bent-knee raise (judgement calls,
  labelled so, levels matching fractions, primaries matching the paint), the labels and moments,
  the other 22 ghosts (every knee and elbow on its own side, lengths kept), the library rows.

## Verification (final skeptic, 2026-10-05)

An adversarial pass over every factual claim and number in the copy, the activation comments and
the source table. Evidence in `SCRATCH/calfmore/verify/`: all fourteen abstracts re-fetched from the
Europe PMC REST API (`e_<PMID>.json`), full texts of Kim 2022, Uchida 2016 and Stastny 2015 from
Europe PMC (`kim.xml`, `uchida.xml`, `stastny.xml`); ExRx re-fetched from the Internet Archive
myself (Standing Calf Raise 2025-07-02, Calf Exercise Analyses 2026-06-25, Gastrocnemius
2026-08-08, Soleus 2025-11-07, Gluteus Medius 2026-06-24; `x_<n>.txt`); Caliverse and The Prehab
Guys pages fetched raw (`cali.html`, `pg_*.html`); Fitbod, Lyfta, Physitrack and UMass Memorial
re-read on the web; the NASA KSC page from the saved copy. All six rigs re-sampled every frame
with Blender's Python + pxr by a new script (`ser.py`, `an.py`, `sole.py`: joints, knee, hip, ankle
and elbow angles, skinned shoe points, equipment bounds, the hand to ball-of-foot distance).

Confirmed (no change): every citation (authors, journal, volume, pages, DOI, PMID) and every study
number the copy or comments use (Kassiano 15.2 / 6.7 / 3.4 and 14.9 / 6.2%; Hebert-Losier 23 / 21%,
+4 / -5%, 45 and 48 raises; Price, Signorile, Cresswell, Kinoshita, Oranchuk, Nakamura 32.9 / 9.1 /
30.4%, Stastny 26-47% MVIC, Kim five healthy men, Uchida r^2 > 0.95); ExRx's step, knee, quadriceps,
tension, top-of-range, seated-soleus, hamstring and gluteus medius wording; the guide quotes listed
in the tables except those fixed below. Model facts the copy uses all hold: elevated heels 4.8 cm
below the step, 10.9 -> 28.2 cm (17.3 cm), up 0.92 s, top 1.04 s, down 1.38 s, a 0.6 s settle;
bent-knee knees 145.8-146.0 every frame, trunk 13.6-15.6 forward, heels 1.4 -> 13.2 cm; hold up
0.7 s, held 6.2 s, down 0.7 s, knees 174.7 throughout; pulses 10.2 -> 13.3 cm, ten dips one every
0.67 s, never down until 7.33 s; farmer 12 steps, left first, sole 3.0 cm up, pelvis 2.6 cm toward
the standing leg, ankles fixed at z 11.45 cm, standing heels never below 11.5 cm, arms 175.9;
banded knees 170, hips 90, elbows 87 still, 109.6 -> 149.6, hold 1.0-2.04 s, the band stretching
73.5 -> 81.8 cm; feet hip-width on all six (ankles 17.4-21.3 cm apart, hip joints 18.3). Paint and
library rows as stated. The reviewer's all-segment ghost check re-run: the two rebuilt pieces keep
every length; no ghost, label, cue id or tracked joint changed in this pass, so no lab round.

Refuted or overstated, fixed (copy):
- Hold body: Caliverse does not list leaning forward among its common mistakes (its list: bending
  the knee, using momentum, outer foot edges, holding the breath, lowering too quickly); it says
  to keep an upright posture without leaning forward. The copy now cites that instruction; the
  header, the table row and Uncertain were corrected too.
- Kawakami 2002 (elevated tempo why, pulse rhythm why): "quick" is not in the source (maximal
  effort is), and only the medial gastrocnemius was imaged; now "all-out" and "gastrocnemius
  fibres". The pulse's "the tendon, not the calf fibres, took up the stretch" still overstated it
  (the fascicles lengthened early in the dip): now the tendon "stored the energy and handed it
  back", the authors' conclusion, and the tendon "helps" spring the heels back.
- Hold toes: Kim 2022 showed the peroneus longus difference in the rise phase; the copy says
  "during the rise".
- Farmer heels: "Guides ... warn" rested on one page (Toe Walking) for the heel dropping as a foot
  takes the weight; now "One guide". Farmer hips: "A dropping hip tips your weight and the
  dumbbells toward the lifted side" had no source; cut.
- Elevated top: "like a knee or elbow" is not ExRx's (it says "like other joints", "in most
  people"); now "the way other joints do". "The whole range the step allows" was not measurable;
  now "from the stretch below the step to full height".
- Elevated knees: ExRx calls the quadriceps synergists in a slight stretch bend; "lets the thighs
  drive the rise" became "brings the thighs into the rise".
- Hold height and pulse top: "the ankle never straightens out" became "cannot straighten out"
  (ExRx: in most people it cannot).
- Bent-knee floor: the ankle at the bottom is ~15 degrees dorsiflexed (sole flat, shins 15.5
  forward), not "a little" past a right angle; "a little" cut. Bent-knee tempo: Nakamura's one
  leg lowered "the heel", not "the heels".
- Farmer posture: "guides for this walk say to stay upright" was one guide's wording; now "stand
  tall, chest up" (The Prehab Guys, Fitbod).
- Banded top and comparison: Uchida supports where the band pulls hardest, not where it "works
  the calves hardest"; both reworded. Banded knees: ExRx says the soleus "becomes more active",
  not that it "takes over more"; reworded.

Refuted, fixed (comments and notes):
- Neutral ankle: on these rigs a flat sole under a vertical shin reads ~112, not ~109 (105.7 at
  rest + the 6.3 degree shin lean on the hold; 97.1 + 15.5 on the bent-knee raise; the sole within
  0.5 cm of the floor along its length). Every derived degree in the header and model facts moved
  by ~3: elevated ~23 dorsiflexed -> ~30 plantar flexed, bent-knee ~15 -> ~21, hold ~32, pulses
  ~19-30, farmer ~18-25, banded start within ~2 degrees of neutral and top ~38 (40 degrees on).
  No copy sentence used these absolute degrees; the copy's 40 degrees is relative and holds.
- Banded hands: ~23 cm above the hip joints, not above the mat (the wrists are ~34 cm up).
- Bent-knee activation comment: ExRx calls the soleus the primary plantar flexor in the seated
  (90 degree) raise, not "once the knee bends"; and 0.70 / 0.62 sit about two-fifths of the way
  (0.10 of 0.26, 0.16 of 0.38) from the straight-knee to the seated values, not a third. Values
  unchanged.
- Banded activation: "usually far lighter than body weight" now carries its source (Uchida 2016
  measured the heaviest, gold, band at 8.93 kgf at 250% elongation).
- Hebert-Losier 2012a's 4% / 5% are given as the abstract gives them (not "of MVIC"); Lyfta,
  Caliverse and Prehab Guys quotes made verbatim; the banded shoe clearance re-measured (3.1 cm at
  the start, not 5.3).

Checked: `python3 spec_500.py calfmore` OK; `review/dupes.py` finds no whole sentence repeated
with round 1, the other 401-500 families or the library.

