# 401-500 folder, round 2: tibialis raises and dorsiflexion (2026-10-04)

Five lifts for the muscles at the front of the shin from the builder's 417-425 exports: 417 Tibialis
Raise, 420 Single-Leg Tibialis Raise, 419 Wall Tibialis Raise, 418 Machine Tibialis Raise and 425
Banded Dorsiflexion (models `Legs/<Resource>.usdc`). `spec_500_tibialis.py` holds the copy and setup
steps (its header lists what each model shows and the full citations),
`Tools/fault-review/faults_500_tibialis.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_tibialis.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on. The library had no
tibialis or dorsiflexion content before these five, so they set the house style for it.

## How the models were read

- The leg briefs (`SCRATCH/briefs2_legs/<Resource>.md`), `tiers2.txt`, `joints.json` and the trainer
  stills at 0/1/2/3/5 s (`SCRATCH/stills`).
- The rigs, equipment and skinned shoes straight from the USD with Blender's Python + pxr:
  `SCRATCH/tibialis/measure.py` (joint positions; knee, hip, ankle and elbow angles; foot pitch; shin
  and trunk lean; the skinned shoe split by the nearer foot, for the toe-tip and heel heights; the
  world bounds of every `HG_*` prim and whether it moves), `timeline.py` (the left ankle every frame,
  for the rep phases), `tipdist.py` (the knee-to-toe-tip distance the ghosts' strength reads).
- Ghosts: `SCRATCH/tibialis/ghost.py` (the round-1 Python port of `FaultGhost.solve`), `pieces.py`
  (this family's pieces in Python), `try.py`, `try2.py`, `try3.py` (angles, bone lengths, which side of
  the hip-ankle line each re-seated knee lands on, on-screen displacement in points).
- Labels: `preview_500.py tibialis` and `SCRATCH/tibialis/overlay.py` (pills at ~24 + 6.4 pt per
  character with the app's 8 pt edge clamp, leaders to the probed joints over the five stills), then
  the lab shots (`lab500.sh shoot tibialis`).
- Sources: Europe PMC REST records (abstracts; the full texts of Semple 2009 and of Baldim 2024's
  preprint), ExRx through the Wayback Machine (`SCRATCH/tibialis/exrx/*.html`), StrengthLog and Hinge
  Health live (`SCRATCH/tibialis/web/`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.592 m). Every clip is 7.96 s with two identical reps, read off
  the left ankle frame by frame (phases at 5-95% of its range; the ankle is still only ~1.0-2.0 s and
  ~3.5-4.0 s, the rest being slow ease in and out): toes down to 0.12 s, lifting 0.17-0.83 s (~0.7 s), held up
  0.88-2.17 s (~1.3 s), lowering 2.21-3.25 s (~1.1 s), resting down 3.29-4.12 s (~0.8 s); the machine
  and band clips run ~0.02-0.04 s earlier. The copy's timings ("lift in under a second", "hold for about a
  second", "a little longer to lower", "rest for a moment") describe that.
- Ankle angle = shin to foot bone (ankle joint to the ball of the foot, `toe_*`). Flat on the floor
  under a near-vertical shin it reads ~107° (the bone points ~22° down); the foot at 90° to the tibia
  is ~112° (90° plus that 22°; the calf families quote ~109-111°). Ranges: Tibialis Raise 107° -> 87°, Single-Leg 105° ->
  84°, Wall 128.5° -> 100°, Machine 126.5° -> 92°, Band 122.7° -> 87.8°. So the two free-standing
  raises start about neutral (~5° bent up) and lift ~20°; the wall raise starts ~17° pointed (the shins
  lean back 16°) and moves 28°; the machine and band start ~11-15° pointed and move 35°.
- The heels stay on the floor in the three standing raises (the shoe's heel 0.1-0.4 cm off it all
  rep); the shoe tips rise from 2.4 cm to 15.5 cm (Tibialis Raise, Single-Leg) and 16.2 cm (Wall).
- Highlight tiers (`tiers2.txt`): TibialisAnterior, TibialisPosterior, FibularisLongus and
  ExtensorDigitorumLongus bright on all five; RectusFemoris and the three vasti dim on the Single-Leg
  and Wall raises; nothing else.

## Activation decisions

- **Tibialis Anterior** is the only PRIMARY row on all five (the lead's brief: "Tibialis Anterior is
  the primary row"). `part_of()` now files it under the calves (the lower leg). ExRx's muscle page
  gives its actions as dorsal flexion and inversion, from the lateral tibia to the medial cuneiform
  and first metatarsal; ExRx's Calf Exercise Analyses names it with the extensor digitorum longus,
  extensor hallucis longus and peroneus tertius as the dorsal flexors.
- **Tibialis Posterior** and **Fibularis Longus** are painted bright but are listed as LOW SECONDARY
  rows, a deliberate exception to "bright = primary": neither lifts the toes. Semple 2009 (full text)
  describes the tibialis posterior as an inverter and plantar flexor (its tendon's course), the
  hindfoot's most powerful supinator. Hagen 2016 (abstract; intramuscular EMG of the tibialis
  posterior and peroneus longus in contractions toward plantar flexion, dorsiflexion, pronation and
  supination) treats the two as the ankle's supinator and pronator and says the pronators and
  supinators play a key role in the side-to-side stability of the ankle, which is the role the rows
  stand for; Kim 2022 (read by the calfstand family) adds that the peroneus longus supports the
  lateral ankle ligaments. The copy never says they lift the foot; the Single-Leg raise's hips cue says
  only that "the muscles either side of the ankle stop the foot rolling in or out". Baldim 2024's
  discussion adds that the peroneals control the ankle's inverting moment (the
  tibialis anterior inverts as it lifts). No study measured either in these lifts; the fractions are
  judgement calls sized by how much side-to-side balance each version asks: one heel 0.30, two heels
  0.20 (free-standing and wall), feet held in a lever or sitting with the feet unloaded 0.15. Making
  them primary would also run the one-line legend ("TIBIALIS ANTERIOR · TIBIALIS POSTERIOR ·
  FIBULARIS LONGUS", 57 characters) far past its ~43; as secondaries the line "TIBIALIS POSTERIOR ·
  FIBULARIS LONGUS" is 37 and fits.
- **Extensor digitorum longus**: `validate()` rejects the name (it would be filed under the forearms),
  so the toe extensors are named in the stabilisers ("toe extensors") on all five. They are in fact
  dorsal flexors (ExRx), and Marsh 1981 estimated that the tibialis anterior gives less than half the
  maximum voluntary dorsiflexion torque at mid-position, "the remainder presumably being provided by
  the long extensors of the toes"; the stabiliser list is the only place the app can name them.
- **Quadriceps** (dim on the Single-Leg and Wall raises: holding the standing knee straight, holding
  the knees straight while leaning on the wall) are named in the stabilisers rather than as a third
  secondary row: "TIBIALIS POSTERIOR · FIBULARIS LONGUS · QUADRICEPS" is 50 characters and would
  truncate (the calfstand family named its dim rhomboids in the stabilisers for the same reason).
- **Tibialis Anterior fractions.** Only the band has EMG for the same movement: Baldim 2024 measured
  49.84 ± 13.49% MVIC for dorsiflexion against an elastic band (supine, knee straight, band across the
  front of the forefoot, 3 s up and 3 s down; 30 young women; surface EMG; Table 1 of the preprint), so
  the Banded Dorsiflexion row is 0.50 MODERATE. The rest are judgement calls on the calf families'
  scale: 0.78 for the two-foot body-weight raises (free-standing and wall; the calfstand family's
  unloaded two-leg calf value) and 0.86 where one shin carries the body (Single-Leg) or a machine lever
  (Machine; ExRx calls the tibia raise's torque relatively high throughout; the model shows no plates,
  so the value assumes the machine is used loaded). The wall raise's longer
  range is not taken as a heavier load. These rank the lifts; no study gives the numbers.

## Sibling and library check

- Library: no tibialis or dorsiflexion exercise; the nearest are the calf raises, which move the ankle
  the other way. ExRx files these lifts as the Reverse Calf Raise (standing), Single Leg Reverse Calf
  Raise and Lever Seated Tibia Raise; the copy uses the app's names.
- Round-2 sibling calfmore (`spec_500_calfmore.py`): its Banded Plantar Flexion sits upright (trunk
  4° back, hips 90°) holding the band's ends in the hands; this family's Banded Dorsiflexion reclines
  34° on straight arms with the band anchored ahead of the feet, so the two share no set-up copy.
- Round-1 calfstand: this family reuses its scale for the main row (0.78 / 0.86) and its rule for dim
  paint that would overflow the legend. Its "hips" text for the one-leg dumbbell raise was not
  reused; the Single-Leg raise's level-hips correction is reworded.
- No sentence of cue, setup or comparison copy repeats word for word within the five or with the
  library's calf contents (checked by script, see the change log).

## Tibialis Raise

Model facts: flat floor, no equipment and no support; feet hip-width (ankles 0.25 m apart), arms
hanging (elbows 170°), knees 173-174° throughout. Ankle 107° -> 87°: the forefoot turns up ~24°
about the planted heels (foot bone 22° below level -> 2° above), the shoe tips 2 -> 15.5 cm. As the
toes rise the pelvis travels ~8 cm back and 1.5 cm up and the trunk tips 1° -> 5° forward (hips
172° -> 167°), all of it returning as the soles come down.

| Claim | Source |
|---|---|
| Stay tall; the hips ease back only a little (the correction: let them drift back a little); with the toes up you stand on your heels, so your weight moves back over them | The model (pelvis ~8 cm back, hips 172° -> 167°); balance over the base of support (mechanics). The draft's correction said a few centimetres, which understated the model's 8 cm |
| ExRx keeps the hips straight in this lift; lifting the feet with the hips bent far and the knees straight pulls the hamstrings and calves tight, which can make the top harder or cut it short | ExRx Reverse Calf Raise ("Keep knees and hips straight throughout exercise"); ExRx Calf Exercise Analyses, Hip Position Analysis ("Dorsal Flexion exercises performed with a significantly flexed hip ... can either decrease the upper range of motion or at least make the topmost portion more difficult", the hamstrings pulling on the gastrocnemius) |
| Knees straight; ExRx keeps them straight; bending them tips the shins forward over flat feet, bending the ankles before the toes move and leaving less room for the lift | ExRx (as above); the rest is geometry: a forward shin over a flat foot already dorsiflexes the ankle. The ghost shows it: the toes end lower |
| Top: as high as they go, hold about a second; the dorsiflexors made the most force with the foot pointed slightly down and lost force quickly once the ankle bent up past a few degrees, so the top is where they are weakest | Marsh 1981 (maximum voluntary dorsiflexion torque at 10° of plantar flexion, "decreased sharply as the ankle was dorsiflex[ed] beyond 5 degrees"); the model (~1.3 s hold); StrengthLog (toes as high as possible) |
| Bottom: soles flat on the floor every rep, the front of the shin longest there; ExRx sets the lift on the edge of a block so the toes drop below level and start longer still | The model (soles flat, ~0.8 s rest); ExRx Reverse Calf Raise ("Position heels on forward edge of calf block"; "Return ... until toes are pointed downward") |
| Lower under control; the same muscle lowers the foot as it lengthens; lift in under a second, take a little longer down | Anatomy (the dorsiflexors control the lowering); StrengthLog ("Lower your toes back down in a controlled manner"); the model (~0.7 s up, ~1.1 s down) |
| Comparison: folding far forward at the hips with straight knees pulls the hamstrings and calves tight, which ExRx notes can make the top harder or cut it short | ExRx Hip Position Analysis, as above (ExRx's case is a "significantly flexed hip", hence far forward) |
| Setup: near a wall or rail you can touch if you tip back | ExRx (a hand on a support for balance); the model uses none, so the copy offers it |
| Setup: start with both soles resting flat on the floor | The model (heels 0.1-0.4 cm, forefoot 0.6 cm off the floor at the bottom). The draft said the weight is spread evenly between heels and forefeet, which no source or measurement supports (the pelvis stands only ~2 cm ahead of the ankles) |

Activation: Tibialis Anterior 0.78 P; Tibialis Posterior, Fibularis Longus 0.20 S. Stabilisers: toe
extensors (see above), core (convention; ExRx lists none for this lift).

## Single-Leg Tibialis Raise

Model facts: the LEFT leg works (left knee 174°, ankle 105° -> 84°, the same forefoot lift, hip
shift and trunk tip as the Tibialis Raise), the pelvis 11 cm left of centre over the left foot. The
right knee is bent 129°, the right ankle 0.27-0.39 m behind the left heel, its shoe ~5.5 cm off the
floor at the bottom and ~9 cm at the top; it never touches down. The right hand holds a post
(`HG_SupportPost`, 1.23 m tall, 0.38 m right of the midline, level with the hips) at 1.10 m, elbow
103-107°; the left arm hangs at the side.

| Claim | Source |
|---|---|
| The right hand only keeps you steady; ExRx sets the lift up with a hand on a support for balance and points to an easier version if the hand starts to help | ExRx Single Leg Reverse Calf Raise ("Grasp support with other hand for balance"; "Use lighter load or position heels more on platform if you need to assist with hands used for support. Resistance can be reduced ... or using both legs") |
| Pulling on the post leans you toward it and takes weight off the left heel, so the shin has less to lift | Mechanics (the post carries part of the body weight) |
| The right foot stays up, knee bent behind; ExRx lifts the other leg to the rear by bending the knee and lists both legs as the easier version; here the foot hangs only a few centimetres above the floor at the bottom | ExRx ("Lift other leg to rear by bending knee"; "using both legs"); the model (shoe ~5.5 cm up at the bottom) |
| Level hips: the standing side's hip muscles hold the pelvis up; ExRx names the gluteus medius and maximus, quadratus lumborum and obliques as the stabilisers | ExRx Single Leg Reverse Calf Raise (stabilizers); ExRx Gluteus Medius ("Steadies pelvis so it does not sag when opposite side is not supported with leg", snapshot 2024-01-05, read in round 1) |
| The muscles either side of the ankle stop the foot rolling in or out | Hagen 2016 (the pronators and supinators: side-to-side stability of the ankle); Semple 2009 (tibialis posterior a supinator) |
| Top: the shin muscles are weakest with the foot pulled up; on one leg no second foot shares the load; hold a second | Marsh 1981; the model |
| Bottom: the sole back on the floor uses the whole range of this flat-floor version; ExRx sets the one-leg raise up with the heel on the edge of a platform, so the toes can drop below it | The model; ExRx Single Leg Reverse Calf Raise ("Position one heel on forward edge of platform"; "Return by extending foot until toes are pointed downward"). The draft said ExRx makes it harder by setting the heel nearer the edge so the toes can drop; ExRx gives the harder version (heels closer to the edge) without that reason, and its Calf Exercise Analyses ties the heel position to torque, not range |
| Comparison: touching the right foot down turns part of each rep into a two-foot raise, the easier version ExRx lists | ExRx, as above |

Activation: Tibialis Anterior 0.86 P (one shin lifts against the whole body); Tibialis Posterior,
Fibularis Longus 0.30 S (balancing on one heel). Stabilisers: toe extensors, quadriceps (dim paint,
legend width), gluteus medius, gluteus maximus, quadratus lumborum, obliques (ExRx).

## Wall Tibialis Raise

Model facts: leaning back on a wall (`HG_Wall`, face at z -0.02 m): heels ~40 cm out from it (the
shoe's back edge at z 0.38 m; the ankle joints ~47 cm), feet hip-width, knees 168°, hips 156° ->
159°, the trunk 6° and the shins 16° back from vertical, arms hanging at the sides. Ankle 128.5° ->
100° (28°): the forefoot turns up ~26° (shoe tips 2 -> 16 cm), the heels down; the body slides ~3 cm
up the wall as the toes rise (pelvis 0.84 -> 0.87 m) and back down. The skinned shorts, the lower
trapezius and the back of the head stay within 0.4 cm of the wall's face all rep
(`SCRATCH/tibialis/wallgap.py`), so the hips, upper back and head rest on it.

| Claim | Source |
|---|---|
| Upper back and hips on the wall all set; StrengthLog leans back on a wall with the trunk lightly braced; the wall holds your balance so the toes can come all the way up without tipping, as you might free-standing | StrengthLog Tibialis Raise ("Lean against the wall. Make sure that you have a slight tension in your core."); the free-standing model's balance shift (mechanics) |
| Heels well out, here about 40 cm; the further out, the more the shins lean back and the more pointed the ankles at the start; a physical therapy guide makes it harder by moving the feet further out for that bigger range; close shortens every rep | The model (heels ~40 cm out, shins 16° back, start ~18° pointed, 28° range against the free-standing 20°); Hinge Health ("Start with your feet further away from the wall so your feet move through a bigger range of motion") |
| StrengthLog starts 20 to 30 cm out; move further as it gets easier | StrengthLog ("Stand about 20–30 cm / 8–12 inches away from a wall"); the model stands further out, so the copy gives both |
| Legs straight; StrengthLog keeps them straight; bending the knees lets you slide down and brings the shins upright, losing the lean that gives the longer range | StrengthLog ("Keep your legs straight"); geometry, as the foot-distance claim |
| Top: as high as possible without the heels leaving the floor; weakest with the foot pulled up; the back may slide a little up the wall | StrengthLog; Marsh 1981; the model (pelvis ~3 cm up as the toes rise) |
| Lower slowly; StrengthLog lowers in a controlled way; the shin muscles let the foot down as well | StrengthLog; anatomy |
| Comparison: feet well out = ankles more pointed at the start and a longer toe path; close = shins upright, shorter path | The model; Hinge Health |

Activation: Tibialis Anterior 0.78 P; Tibialis Posterior, Fibularis Longus 0.20 S. Stabilisers: toe
extensors, quadriceps (dim, legend width), core (StrengthLog's core tension).

## Machine Tibialis Raise

Model facts: seated on a flat bench (`HG_Seat`, top 42 cm), knees 84°, hips 81°, shins vertical,
trunk 4° forward, hands resting on the thighs (elbows 96°). The feet in a rocker lever
(`HG_TibLever`): the heels in a cradle (`HG_HeelCradle`) behind the pivot, a roller pad
(`HG_FootRoller`, 4 cm radius) across the tops of the feet over the instep (it touches the shoe 5-12 cm
ahead of the ankle joint, behind the ball of the foot at 15 cm; `skeptic/contact.py`), the axle (`HG_TibAxle`, on posts `HG_TibPost`)
level with and in line with the ankle joints (both at y 0.17 m, z 0.44 m). Ankle 126.5° -> 92° (35°):
the toes from ~15° below level (foot bone 37° down) to ~20° above; the roller rises ~6 cm and the heel
cradle swings down; the heels stay 9-11 cm off the floor in the cradle.

| Claim | Source |
|---|---|
| ExRx warns against using other muscles to push the heel pedal down as the lever rises; here the lever turns about the same line as the ankles, so pushing down through the legs cannot lift the pad, only the shin muscles turning the feet up can | ExRx Lever Seated Tibia Raise ("Avoid using other muscles to push pedal down with heels as lever is lifted"); the model (the axle `HG_TibAxle` centred at y 0.171, z 0.438, the left ankle joint at y 0.171, z 0.438 all rep, re-measured in review; a force through the pivot has no lever arm). The draft said pressing the heels levers the pad up, which this geometry does not allow |
| Shins upright; the shin angle sets the start; too far forward bends the feet up in the lever so the toes cannot point as far down; ExRx has you slide back until you feel the toes fully pointed at the bottom; the correction says the toes can point down past level (the model's ~15°, not fully pointed) | The model (shins vertical); geometry; ExRx ("In starting lower position, scoot back on bench just slightly until full planter flexion is felt") |
| Top: the load stays fairly high through the whole lift; weakest with the foot pulled up; set a clear top position | ExRx Calf Exercise Analyses, Tibia Raise ("torque is relatively high throughout movement"); Marsh 1981; ExRx ("Establish range of motion criteria for highest position") |
| Bottom: the pad takes the toes down past level (the draft's intro said until they point at the floor, more than the model's ~15° below level); lower until the toes point downward; strongest pointed about 10 degrees down, so starting there uses their best length | ExRx ("Return by extending feet until toes are pointed downward"); Marsh 1981 (optimum length and maximum voluntary torque near 10° of plantar flexion); the model (~15° below level) |
| Tempo: largely continuous tension, with a chance to relax at the bottom (the draft's fairly steady tension, the only chance to relax read more into ExRx than it says); the muscles let the pad back as they lengthen | ExRx Calf Exercise Analyses ("a largely continuous tension curve with an opportunity to relax or decrease activation at the lower starting position"); anatomy |
| Comparison: past level starts each lift with the shin muscles long, close to where they are strongest; stopping level cuts off the stretched start ExRx has you reach | Marsh 1981; ExRx |
| Setup: ankles in line with the lever's pivot, shins upright; the roller across the tops of the feet, ahead of the ankles | The model (the draft said near the toes; the roller sits over the instep, 5-12 cm ahead of the ankle joints) |

Activation: Tibialis Anterior 0.86 P (a loaded lever); Tibialis Posterior, Fibularis Longus 0.15 S
(the feet held in the lever). Stabilisers: toe extensors, core (ExRx: no significant stabilizers).

## Banded Dorsiflexion

Model facts: long-sitting on a mat (`HG_Mat`), legs straight (knees 170°), feet hip-width (ankles
0.18 m apart), a 4 cm towel roll (`HG_TowelRoll`) under the lower calves ~15 cm above the ankles so
the heels hang clear of the mat (the shoe's lowest point, the back of the heel, 1.3 cm up with the
toes pointed and 4.7 cm with them pulled back; the draft's 4.6-9.7 cm came from a heel window that
does not fit the upturned foot); the trunk reclined 34° behind vertical (hips 122°) on
straight arms (elbows 171°), the hands on the mat ~30 cm behind the hips. The band (`HG_BandL/R`, two
strands a side) runs from a low anchor (`HG_BandAnchor`, `HG_AnchorPost`, 15-17 cm up, ~55 cm beyond
the ankles) over the tops of the feet across the forefoot (it touches the shoe 9-12 cm ahead of the ankle joints,
3-6 cm behind the balls of the feet, 12-15 cm behind the shoe tips; `skeptic/contact.py`); it is taut
all rep, its strands lengthen ~7 cm and its lever arm about the ankle grows ~10.6 -> 12.6 cm as the feet
come back. Ankle 122.7° -> 87.8° (35°), ~11° pointed to ~24° past neutral.

| Claim | Source |
|---|---|
| Lean back on straight arms, hands on the mat behind the hips (the draft's a little behind understated the model's ~30 cm); with the legs straight, folding forward at the hips pulls the hamstrings and calves tight, which ExRx notes can shorten or harden the top of a foot lift; for a seated machine version it recommends a more reclined seat for a fuller range | ExRx Calf Exercise Analyses (Hip Position Analysis, as above; Reverse Calf Press: "Positioning the seat in a more reclined or supine position is recommended, permitting a fuller range of motion"; "Those with poor hamstring flexibility may have a slightly arched (flexed) spine when the hips are flexed sharply, particularly during ankle dorsiflexion"); the model (34° recline) |
| The band wraps over the tops of both feet across the forefoot (intro and correction); in a lab study of band exercises for the ankle it sat across the front of the forefoot; well ahead of the ankle it has good leverage; slipped back it has little | Baldim 2024 preprint, methods ("elastic band in the anterior region of the forefoot"); leverage (mechanics); the model (9-12 cm ahead of the ankle joints, 3-6 cm behind the balls of the feet, so a little further back than the study's). The draft said near the toes / just behind the toes and that it pulls as far from the ankle as it can, which the model's position does not bear out |
| A band pulls harder the further it stretches, heaviest at the top where the shin muscles are weakest; tested lying on the back, band dorsiflexion worked the tibialis anterior at about half the activity of a maximal contraction | Elastic behaviour (the model's strands lengthen ~7 cm as the feet come back, and the band's lever arm about the ankle also grows, ~10.6 -> 12.6 cm, so its turning effect is largest at the top); Marsh 1981; Baldim 2024 (49.84 ± 13.49% MVIC, supine with the knee straight; the copy says lying on the back because the model long-sits) |
| Bottom: between pulls the band tips the feet forward past upright (toes pointing away in the correction and label, a direction: the model is ~11° pointed); returning past upright starts each pull with the front of the shin long; the muscles are strongest pointed slightly down; a short return starts every rep where they have less to give | Marsh 1981; ExRx (returning until the toes point down, on its lifts); the model (~11° pointed) |
| Return speed: the band pulls hardest near the top and stays taut through the return, so a controlled return keeps the muscles working as they lengthen; snapping forward skips that half; pull in about a second, return over a slightly longer count | Elastic behaviour and the model (strands taut all rep; ~0.7 s back, ~1.1 s forward). The draft also quoted Baldim's 3 s up / 3 s down metronome, a pace the copy then told the user not to follow; it was removed in review |
| Comparison: reclined, the hips stay more open, as ExRx recommends for a fuller range with straight knees; sitting up can cut the top short | ExRx, as above; the model's hips are 122°, so more open rather than open (the draft) |
| Setup: legs straight, a rolled towel under the lower calves; a band from a low anchor in front of the feet over the tops of both feet; slide back until it is taut with the toes pointing away; lean back on straight arms | The model |

Activation: Tibialis Anterior 0.50 P (Baldim 2024); Tibialis Posterior, Fibularis Longus 0.15 S.
Stabilisers: toe extensors, triceps (the straight arms propping the reclined trunk; convention),
core.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`; the bottom row
can go to 0.86, above the legend at ~0.92); pills ~24 + 6.4 pt per character. Two things set the
layout beyond the trainer stills: (1) while a mistake shows, the model is lifted ~0.12 of the viewport
(`roomBelow`), so a low label beside the feet in the trainer view can land on the lifted feet in that
cue's own mistake view (round 1: the Wall's Toes high, hold at 0.72, the Single-Leg's at 0.70 and the
Band's Toes back at 0.42 all sat on the lifted toes); (2) where a leader enters the trunk it should not
cross the arm or head (round 1: the Band's tempo leader ran through the head, the Wall's and Machine's
crossed the shoulder), so the tempo labels point at the head, which they reach without crossing
anything.

- Tibialis Raise: tempo (Lower slowly) 0.18 right, level with the head; hips (Hips stay tall) 0.44
  right to the pelvis, which sits behind the hanging hand, so the leader ends on the hand (left: no
  other joint stands for the hips); knees 0.58 left to the near kneecap; top (Toes high, hold) 0.74
  left to the ball of the near foot (in its mistake view the lifted toes clear the pill by ~10 pt);
  floor (Soles back down) 0.80 right, a short leader to the near ankle.
- Single-Leg: post (Light grip) 0.22 left to the right hand, which sits behind the trunk in this
  framing, so the leader crosses the chest (as in calfstand's one-leg dumbbell raise; no probed joint
  lies on the fingers that show at the post). At round 1's 0.28 the pill touched the chest and, in the
  post fault's front view, covered the forearm reaching to the post. Hips 0.44 right; free (Right foot
  stays up) 0.58 right, above the hanging shoe (0.60 until review: in its own mistake view, with the
  model lifted, the pill sat on the hanging shoe's heel); top (Toes high, hold) 0.62 left, its leader running
  down beside the post to the ball of the left foot; floor (Sole flat, shortened from Sole back down so
  the top leader passes right of it) 0.80 left to the same point.
- Wall: tempo 0.24 right to the head and wall (Back on the wall) 0.44 right to the near shoulder blade,
  both over the static wall panel (round 1's leader to the pelvis crossed the hanging hand); knees (Legs
  straight) 0.56, feet (Heels well out) 0.64 and top (Toes up) 0.80 on the left over the open
  floor, the feet leader running in front of the shins to the near ankle. Round 2: at the top of the rep
  the lifted toes reached the right end of a 0.80 Toes high, hold pill, so the label lost its last
  word; on round 3's shot Toes high still touched the lifted toe tip at the top hold, so it is now
  Toes up, ~20 pt clear (the cue keeps the hold).
- Machine: the shins, lever and roller fill the lower left, so the left labels sit high with short
  text: seat (Shins upright) 0.20 left, straight down to the far knee; top (Lift, hold) 0.40 left, its
  leader running down left of the shins to the far toes (it passes over the roller near its end);
  bottom (Toes down) 0.86 left, below the lever, over the static base plate; tempo 0.20 right to the
  head; heels (Heels light) 0.80 right over the bench legs, to the near ankle.
- Band: band (Band on forefoot) 0.20 left to the near toes and top (Toes back) 0.32 left to the far
  toes, the upper leader passing right of the lower pill, both clear of the toes lifted in the mistake
  views; recline (Lean back on hands) 0.72 right, up to the near hand on the mat; tempo (Slow return)
  0.76 and bottom (Let toes point away) 0.84 left, below the mat, up to the far and near ankles
  without crossing.

## Ghosts

Measured with the port at the fault's moment (top = toes highest, bottom = toes lowest, as
`fault_times.py` reads the `tibialis` kind off the left ankle; all five work the left leg or both, so
no seconds are needed). Strengths read the knee-to-toe-tip distance (`tibialis500Lift`), which
shrinks as the toes come up: 0.86 -> 0.75 torso lengths (Tibialis Raise), 0.85 -> 0.73 (Single-Leg),
0.95 -> 0.82 (Wall), 0.94 -> 0.78 (Machine), 0.93 -> 0.75 (Band). The toe faults turn the toe tip
about the ankle (`foot_*`), the line the ghost draws; every re-seated knee was checked to bend forward.

- Tibialis Raise: hips `tibialis500HipsFolded(25, back: 0.06, drop: 0.02)` (trunk 5° -> 30°, hips
  167° -> ~136°, the head ~27 cm forward and down, knees ~161°; top); knees
  `tibialis500KneesSunk(drop: 0.08, back: 0.05, toes: 16)` (knees 173° -> ~141°, the body ~5 cm down,
  the toe tips ~6 cm lower with the shins, the ankle angle kept at ~88°; top. A first version that
  bent the knees with the toes left up needed ~38° of dorsiflexion, so the toes now drop with the
  shins); top `tibialis500Forefoot("*", -16)` (86° -> ~102°, toe tips ~6 cm lower); floor
  `tibialis500Forefoot("*", 16)` (106° -> ~90°, toe tips ~6 cm up; bottom). Round 1 used 14°, which
  read only faintly on the lab stills. Tempo has none.
- Single-Leg: post `pulledOnSupport(strength: .always).seen(faceOn)` (shared piece: trunk 12° toward
  the post, the head ~14 cm, the right elbow 107° -> ~76°; top); free
  `tibialis500FreeFootDown(40)` (right knee 129° -> ~169°, the toe tips onto the floor ~13 cm behind the
  left foot; bottom); hips `tibialis500HipDropped(0.09)` (the right hip and leg ~5 cm lower, seen from
  the front; top); top / floor as the Tibialis Raise on the left foot.
- Wall: wall `tibialis500HipsOffWall(0.15)` (hips ~9 cm off the wall, knees 168° -> ~147°; without
  the forward knee nudge the re-seat swung the knees ~9 cm inward); feet `tibialis500FeetIn(back:
  0.3, up: 0.08)` (heels ~18 cm nearer the wall, the body ~5 cm higher, knees ~164°, shins nearly
  upright); knees `tibialis500SlidDown(0.1)` (~6 cm down the wall, knees ~137°); top as above, 16°
  (99° -> ~115°). The three set-up faults are stilled at the bottom and drawn the same all rep.
- Machine: seat `tibialis500SeatForward(0.15)` (~9 cm forward, knees 84° -> ~72°, shins tipped
  forward over the held feet; bottom; drawn as the legs from the pelvis, since round 1's moved spine
  line lay over the real torso and cluttered the view); top / bottom `tibialis500Forefoot("*", ∓18)` (90° -> ~108°,
  125° -> ~107°, toe tips ~7 cm). Heels and tempo have none.
- Band: recline `tibialis500SatUp(28, round: 0.06)` (trunk 34° behind upright -> ~6°, back rounded;
  drawn as spine and shoulders); top / bottom `tibialis500Forefoot("*", ∓20)` (86° -> ~106°, 121° ->
  ~101°). Band and tempo have none.

## Uncertain

- No EMG study of any of these five as the models do them; only the band's main row has a measured
  value for the same movement (Baldim 2024, supine rather than long-sitting, women, an unreported band
  tension). Every other fraction is a ranked judgement.
- Tibialis posterior and fibularis longus are painted bright, which the copy and rows do not follow
  (see Activation decisions); flagged to the lead, together with the paint itself, which may not
  match the anatomy of a dorsiflexion lift. The review kept the rows (see Review); if the lead holds
  to bright = primary, the round-1 precedent is a primary row at 0.40, which no source supports here.
- Baldim 2024's 49.84 ± 13.49% comes from the Research Square preprint's Table 1; the published
  version (J Bodyw Mov Ther, abstract only on Europe PMC) was not seen in full, so its table may differ.
- Marsh 1981 measured isometric torque across ankle angles (stimulated and voluntary); the copy uses
  it only for where the dorsiflexors are strong and weak, not for how hard any of these lifts is.
- Hinge Health and StrengthLog are coaching sources (Hinge's page clinically reviewed); the wall
  raise's set-up claims rest on them and on the model, not on a study.
- ExRx was read through Internet Archive copies (the live site blocks automated fetches).

## Change log

- 2026-10-04, draft: copy, setup, ghosts and moments for all five; `spec_500.py tibialis` OK; lab
  check BUILD SUCCEEDED on the first build. Copy check by script: no cue, setup or comparison sentence
  repeats within the five, with the library's contents or with the round-1 and sibling calf families
  (the draft's Tibialis Raise setup repeated three of calfstand's bodyweight steps word for word; they
  were reworded).
- Lab round 1 (`SCRATCH/tibialis/round1/`): every screen rendered (no crash). Labels: the Band's tempo
  leader ran through the head; the Wall's and Single-Leg's top pills and the Band's Toes back pill
  sat on the toes lifted in their mistake views; the Wall's and Machine's tempo leaders crossed the shoulder,
  the Wall's wall leader the hanging hand, and the Single-Leg's post pill touched the chest and, in its
  front view, covered the forearm on the post; all relaid (see Labels). Ghosts: every one attached and
  readable; the toe faults raised from 14° to 16°; the machine's seat ghost lost its spine line.
- Lab round 2 (`SCRATCH/tibialis/round2/`): all mistake views clear; one trainer collision left (the
  Wall's top pill and the lifted toes at the top of the rep), shortened to Toes high.
- Lab round 3: Toes high still touched the lifted toe tip at the top hold; now Toes up.
- Lab round 4 (`SCRATCH/lab/tibialis/`, also copied to `SCRATCH/tibialis/round4/`): final shots of the
  trainer at 0 / 1.5 / 3 s and all 19 ghosts.

## Review (2026-10-05)

An independent sources and model review of the four files (scripts and fetched pages in
`SCRATCH/tibialis/review/`; the pre-review files and lab shots in `review/before/` and
`review/before_lab/`).

- **Sources.** All five studies re-opened on Europe PMC: Marsh 1981 (PMID 7263411), Baldim 2024
  (39593687), Semple 2009 (19691828, PMC2739849), Hagen 2016 (27721087) and Kim 2022 (35750787,
  PMC9232603); authors, year, journal, volume, pages, DOI and PMID are right in every citation. The
  claims were checked against the abstracts (Marsh: optimum length and maximum voluntary torque near
  10° of plantar flexion, a sharp fall past 5° of dorsiflexion, under half the midposition torque from
  the tibialis anterior; Hagen: the pronators and supinators in side-to-side stability), the full
  texts of Semple 2009 (inversion and plantar flexion; the most powerful hindfoot supinator) and Kim
  2022 (the peroneus longus supporting the lateral collateral ligaments) fetched again, and Baldim's
  preprint (30 women aged 18-35; supine, knee extended, band on the front of the forefoot; 3 s up and
  3 s down; tibialis anterior 49.84 ± 13.49% MVIC; the peroneals controlling the inverting moment).
  ExRx's Reverse Calf Raise, Single Leg Reverse Calf Raise, Lever Seated Tibia Raise, Calf Exercise
  Analyses and Tibialis Anterior pages were fetched again from the Wayback Machine at the cited
  snapshots, StrengthLog's Tibialis Raise and Kettlebell Tibialis Raise and Hinge Health's guide live;
  each says what the notes quote. Hinge Health's citation now gives the page's title, date
  (2024-07-26) and clinical reviewer (Maureen Lu, PT, DPT).
- **Model re-measured** (`review/spot.py`, `chk_*.py`): the machine's axle centre and the left ankle
  joint coincide (y 0.171, z 0.438) all rep; the wall's face at z -0.02 with the ankles 47 cm out, knees
  167.5°, shins 16.4° and trunk 6.1° back, the pelvis 3 cm up the wall at the top; the band's wraps at
  z 0.49-0.54 between the ankle (0.458) and the ball of the foot (0.554), its strands 7 cm longer at the
  top, the trunk 34.4° back, the hands 30 cm behind the hips; the one-leg pelvis level (hip joints at
  the same height all rep), the right knee 128.6°, the right hand 4-6 cm from the post's centre at
  1.10 m. The header and notes' model facts hold.
- **Copy changed.** Machine heels why: the draft said pressing the heels into the cradle levers the
  pad up, but in this model the lever turns about the ankles, so a push through the legs has no lever
  arm; it now gives ExRx's warning and says only the shin muscles can turn the lever here. Machine
  seat, bottom: the toes cannot point fully down / until they point at the floor overstated the
  model's ~15° below level; now as far down, past level. Band bottom: the intro and why now say past
  upright (the model is ~12° pointed); the label and correction keep toes pointing away as a
  direction. Band top: the study is described on its own (tested lying on the back) instead of
  through that band study, which assumed the reader had opened the band cue. Band tempo: the why no
  longer quotes Baldim's 3 s up and 3 s down, a pace the correction then told the user not to follow.
  Tibialis Raise comparison: folding far forward at the hips (ExRx's case is a significantly flexed
  hip). Machine tempo intro reworded (its words ended a correction in calfstand's Machine Donkey Calf Raise).
  No sentence repeats within the family, with the library or with the other 401-500 families
  (checked by script).
- **Activation kept.** Tibialis Anterior stays the only primary row; Tibialis Posterior and Fibularis
  Longus stay LOW secondary rows although painted bright. The reviewer agrees with the author: the
  lead's brief names Tibialis Anterior as the primary row and warns that the other two are plantar
  flexors and evertors; no study measures them in a dorsiflexion lift, so a primary row (at the
  round-1 floor of 0.40) would be an unsourced claim, and the three-name primary legend truncates. It
  is still a departure from the batch's bright = primary rule, left for the lead (see Uncertain). The
  fractions and levels match; every value but the band's is marked a judgement in the code and here.
  The machine's 0.86 now says the model shows no plates (a machine is used loaded).
- **Labels.** Single-Leg free (Right foot stays up) 0.60 -> 0.58: in its own mistake view the lifted
  hanging shoe touched the pill's corner. Checked and kept: the Tibialis Raise hips leader ends on the
  hanging hand (every hip joint sits behind it in this framing); the Single-Leg post leader crosses the
  chest (the hand on the post is hidden behind the trunk); the Machine Lift, hold leader passes over
  the roller's end at the bottom of the rep; the machine's tempo pill clears the head by ~10 pt.
- **Ghosts.** All 19 re-run on the port (`review/ghostchk.py`, reusing `tibialis/ghost.py`) at the
  lab's moments: bone lengths kept, every re-seated knee bends forward, the post elbow 107° -> 76°;
  the sizes in the table comments match. Every lab still was inspected: each ghost shows its named
  mistake, stays attached and is possible. Kept: the Wall's wall and knees ghosts look alike (both bend
  the knees), but each matches its own text (hips ~9 cm off the wall vs ~6 cm down the wall). The toe
  ghosts (16-20°) are small on screen but read against the hollow markers of the real toe tips.
- **Lab.** One review round (`lab500.sh shoot tibialis "0,1.5,3"`, BUILD SUCCEEDED; final shots in
  `SCRATCH/lab/tibialis/`, also copied to `SCRATCH/tibialis/review/review_round1/`): the trainer at
  0 / 1.5 / 3 s and all 19 ghosts render (no crash); the moved Right foot stays up pill clears the
  hanging shoe by ~10 pt in its mistake view and nothing else moved. The band tempo why's last wording
  (stays taut through the return) and two code comments were edited after that build; `lab500.sh
  check tibialis` on the final files: BUILD SUCCEEDED (the shots were restored to `SCRATCH/lab/tibialis/`).

## Verification (2026-10-05, final skeptic)

An adversarial pass over every claim and number in the copy, the activation comments and the source
tables (scripts in `SCRATCH/tibialis/skeptic/`; the files as they stood before it in
`skeptic/before/`).

- **Sources re-opened.** Europe PMC records for all five studies (authors, year, journal, volume,
  pages, DOI, PMID match); Marsh 1981's abstract (maximum voluntary torque at 10° of plantar flexion,
  "decreased sharply as the ankle was dorsiflex[ed] beyond 5 degrees"; under half the midposition
  torque from the tibialis anterior); Hagen 2016's abstract; the full texts of Semple 2009 and Kim
  2022 fetched again; Baldim's preprint on Research Square (supine, knee extended, band on the
  anterior forefoot, 3 s / 3 s metronome, tibialis anterior 49.84 ± 13.49% MVIC). ExRx's Reverse Calf
  Raise (snapshot 2026-05-20), Single Leg Reverse Calf Raise (2025-08-16), Lever Seated Tibia Raise
  (2023-06-01), Calf Exercise Analyses (2026-06-25), Tibialis Anterior and Gluteus Medius (2024-01-05)
  fetched from the Wayback Machine myself; StrengthLog's Tibialis Raise and Hinge Health's guide
  re-read live. Every quote in the tables matches.
- **Model re-measured with my own pxr scripts** (`sk.py`, `sk1.py`, `sk2.py`, `tl2.py`, `mach.py`,
  `band.py`, `contact.py`, `heel.py`, `wallgap.py`): all ankle, knee, hip, trunk and shin angles in
  the header hold; the 5-95% rep phases (0.7 / 1.3 / 1.1 / 0.8 s) hold; the machine's axle centre
  and both ankle joints coincide (y 0.171, z 0.438) all rep and the model has no plates; the wall's
  face at z -0.02 with the heels 40 cm and the ankles 47 cm out, the lower trapezius and shorts at
  the wall's face; the one-leg pelvis level, the right shoe 5.5 / 9.1 cm off the floor, the right
  fingers on the post at 1.10 m.
- **Refuted and fixed in the copy.** (1) Banded Dorsiflexion band cue: near the toes, just behind
  the toes and it pulls as far from the ankle as it can were not what the model shows (the band
  touches the shoe 9-12 cm ahead of the ankle joints, 3-6 cm behind the balls of the feet); now
  across the forefoot, well ahead of the ankle with good leverage. (2) Machine setup: the roller sits
  over the instep (5-12 cm ahead of the ankle joints), not near the toes; now across the tops of
  your feet, ahead of the ankles. (3) Single-Leg bottom why: ExRx makes the raise harder with the heel
  nearer the edge but does not give the toes dropping as the reason (its analyses tie the heel
  position to torque); now ExRx sets the raise up with the heel on the edge of a platform, so the
  toes can drop below it, which its preparation and execution say. (4) Machine tempo why: fairly
  steady tension, the only chance to relax overstated ExRx's largely continuous tension curve with an
  opportunity to relax at the lower position; now largely continuous tension, with a chance to relax
  at the bottom. (5) Tibialis Raise hips correction: a few centimetres understated the model's 8 cm;
  now a little. (6) Tibialis Raise setup: weight spread evenly between heels and forefeet had no
  source or measurement; now both soles resting flat on the floor. (7) Banded Dorsiflexion recline
  correction: a little behind your hips understated the model's 30 cm; now behind your hips. (8)
  Banded Dorsiflexion comparison: the hips stay open at the model's 122°; now more open, as ExRx
  recommends; the recline why now says a seated machine version and a more reclined seat, as ExRx
  words it.
- **Refuted and fixed in the header and notes only.** The band model's heels hang 1.3-4.7 cm clear
  of the mat, not 4.6-9.7 cm (the draft's heel window did not fit the upturned foot); the machine's
  heels 9-11 cm off the floor, not 9-10; the foot at 90° to the tibia reads ~112° on this rig, so
  the wall raise starts ~17° pointed (not ~18°) and the band ~11° pointed to ~24° past neutral (not
  ~12° / ~23°); the one-leg right ankle is 0.27-0.39 m behind the left heel (the draft did not say
  behind what); Kim 2022's peroneus longus claim is in its abstract as well as its introduction; the
  legend width is ~43 characters (one line said ~44).
- **Checked and kept.** Marsh's angles in the top and bottom whys; the band's pull heaviest at the
  top (its stretch and its lever arm both grow toward the top); every ExRx, StrengthLog and Hinge
  Health paraphrase; the machine heels why (a push through the legs passes through the ankle, which
  is the lever's axis); the activation fractions and their judgement labels.
- **Not re-shot.** Only copy text changed (no label, cue id, tracked joint, ghost or moment), so the
  lab shots from the review round stand; `python3 spec_500.py tibialis` prints OK.
