# 401-500 folder: chest (2026-10-04)

Five pressing lifts from the builder's 127-136 set: 132 Decline Push-Up, 136 Plyometric Push-Up,
129 Chest Dip, 130 Weighted Chest Dip and 127 Landmine Chest Press (models `Chest/<Name>.usdc`).
`spec_500_chest.py` holds the copy and setup steps (its header lists what each model shows and the
full citations), `Tools/fault-review/faults_500_chest.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_chest.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The motion briefs (`SCRATCH/briefs/<Resource>.md` for the arms, `SCRATCH/briefs_legs/<Resource>.md`
  for the legs and trunk, every 0.5 s), the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`),
  `tiers30.json`, `joints.json`.
- The rigs, equipment prims and skinned meshes straight from the USD with Blender's Python + pxr
  (`SCRATCH/chest/rig.py` helpers; `measure.py`, `pushup.py`, `plyo.py`, `dip.py`, `wdip.py`,
  `land.py`, `land2.py`, `misc.py`): joint angles every 1/12 s, the elbows' spread from the trunk
  (the upper arm projected on the body's up/left plane, measured from the line toward the feet),
  the skinned hands, shoes, pecs, head and shorts against the floor and the bench, equipment bounds.
- Labels: `preview_500.py chest` plus `SCRATCH/chest/overlay.py`, which draws gen.py's pills (~24 +
  6.4 pt per character, 28 pt tall) and leaders over the five stills with the eye button and legend
  boxed; `dots.py` and the grid images (`grid_dip.png`, `grid_land.png`) for the free space.
- Ghosts: a Python port of `FaultGhost.solve` (`SCRATCH/chest/ghost.py`: the body axes, shift /
  turn / straighten / resolve, strengths, tips) run on the real joint transforms at the fault's
  moment and projected with each framing plus the fault's `view` (`faults.py`, `t1.py`-`t5.py` for
  the variants tried). Then the lab (`lab500.sh shoot chest`), whose stills are in
  `SCRATCH/lab/chest/`.

## Shared facts about the models

- One body (torso, neck to pelvis, 0.592 m; the shoulder joints 0.39 m apart, the outer delts
  0.57 m). Every clip is 7.96 s with two identical reps.
- Highlight tiers (`tiers30.json`): bright = DeltoidAnterior, PectoralisMajor_Clavicular /
  _Sternal / _Abdominal and TricepsBrachii_Lateral / _Long / _MedialHead on all five, so
  "Pectoralis Major", "Anterior Deltoid" and "Triceps Brachii" are PRIMARY rows everywhere; the
  Plyometric Push-Up also has RectusAbdominis, ExternalOblique and InternalOblique dim, so
  "Rectus Abdominis" and "Obliques" are SECONDARY rows there. The pec row is named "Pectoralis
  Major" on all five because the paint lights all three parts, although the library rows read
  UPPER / LOWER PECTORALIS (see "Library rows" below). All names pass `part_of()` (chest,
  frontDelts, triceps, abs).
- No study reports %MVIC for any of these five lifts as the models do them, so every fraction is a
  judgement call anchored on the library's push-up and dip values; each is explained below and in
  a code comment.

## Decline Push-Up

Model facts: the toes rest on top of a bench (top 43 cm above the floor, 0.45 m in model space
over a floor at 0.015; 40 cm deep), the shoe soles 12-14 cm in from its near edge, legs straight
(knees 178°). Hands on the floor just outside the shoulders (the hands' inner edges 0.56 m apart,
the outer delts 0.57 m; wrist joints 0.64 m apart), fingers forward, the wrists 4 cm toward the
feet from the shoulder joints when the arms are straight. The body stays straight (178° at the
hips, neck-pelvis-ankle); its shoulder-ankle line slopes 5° head-down at the top and 14° at the
bottom (trunk 94° -> 103° from vertical). Elbows 172° -> 78°; at the bottom the upper arms are
49° out from the trunk (measured on the body's up/left plane), the elbows pointing back toward the
feet; the chest (skinned pecs) stops 18 cm and the face 19 cm above the floor; the shoulder joints
stay 12 cm above the elbows. Timing: still to 0.67 s, down 0.7-2.0 s, a 0.5 s pause at the bottom
(2.0-2.5 s), up 2.5-3.5 s, the top held to 4.7 s, then again.

| Claim | Source |
|---|---|
| Heels, hips and head in one straight line; hips sag as the arms tire is the mistake | ExRx Decline Push-up (both upper and lower body kept straight throughout); the model (178°) |
| With the feet up, the hands carry more of your weight: at its peak ~70% of body mass on a 30 cm box, 74% on a 61 cm box, 64% on the floor | Wurm et al. 2010 ISBS (Table 1, peak force as a share of body mass: 0.70, 0.74, 0.64; read in full), the conference report of Ebben et al. 2011 (whose abstract gives no percentages). Peak values, so the copy says at its peak. The model's bench, 43 cm, sits between the two boxes, so the copy gives both values and no figure for this bench. The straight body passing the load to the chest and arms is reasoning |
| Hands just outside the shoulders, under them; arms close to vertical when straight | ExRx (hands on the floor slightly wider than shoulder width); the model (inner edges level with the outer delts; at the top the wrists 12 cm outside and 4 cm behind the shoulder joints, so the arms are near vertical) |
| In an EMG study of five push-up hand placements, setting the hands forward (or back) drew the most abdominal and back-muscle activity; the authors advise care with those variants with low back pain | Marcolin et al. 2015, abstract (standard, wide, narrow, forward and backward variants; highest abdomen and back activity in the forward and backward ones; implement them carefully with low back pain). The PMC full text is not open, so the copy says only what the abstract says (the review removed an earlier reading that more of each rep went into holding the trunk, and lower-back for back). The fault drawn is the forward placement |
| Elbows ~45° from the body, pointing toward the feet; the chest, front delts and triceps press together | The model (49° at the bottom). The 45° figure is house coaching (the library's Push-Up and Incline Push-Up); no study ties a push-up elbow angle to an outcome, so the copy claims none |
| ExRx files this push-up under the upper chest; in one EMG study push-ups sloping 15° head-down worked the front delts and triceps harder than ones sloping 15° head-up, with mid-chest activity about the same | ExRx Decline Push-up (directory Upper Chest; target Pectoralis Major, Clavicular). Lin et al. 2026, full text, Table 1 and post hoc tests, stable surface: front delt 55.5 vs 44.3 and triceps 37.8 vs 32.0% MVIC at -15° vs +15°, both significant; the pec (sternocostal fibres, 35.8 vs 39.2) not significantly different between those two angles (its post hoc tests are on the angle main effect, both surfaces pooled, as no interaction was found). The model slopes 5-14° head-down. This replaced a sentence on Noteboom et al. 2024 (grip width and shoulder loads in the bench press), which was about grip width, not the elbow angle the cue and ghost show; Noteboom found the abduction angle mattered less than grip width |
| The hands carry more of the body's weight in the bottom position than in the top one, so short reps skip the most heavily loaded part | Suprak et al. 2011 (28 trained men in static positions on a force plate: the hands supported less body mass up than down) |
| Lower until the elbows pass a right angle, chest about a hand's length from the floor | The model (78°, chest 18 cm up). ExRx lowers the upper body to the floor; the copy follows the model and gives its depth |
| A poked-forward neck cuts the range short; reaching with the head fakes depth | ExRx Decline Push-up comment (range compromised if the neck is protracted; pull the head back slightly for a full descent). The faked depth is reasoning |
| Setup: kneel with the bench behind, hands on the floor, toes on the bench | ExRx (kneel with the bench behind, hands slightly wider than shoulder width, feet on the bench, raise the body with arms straight) |

Activation: no study measured the clavicular pec in a decline push-up. Lin et al. 2026 measured
stable-surface push-ups at body angles of +30 to -30° (shoulder-ankle line against the ground;
minus = shoulders below the ankles; the pec electrode on the sternocostal fibres):
the sternocostal pec 39.2 / 40.8 / 35.8% MVIC at +15 / 0 / -15°, the front delt 44.3 / 49.1 /
55.5, the triceps 32.0 / 34.5 / 37.8. A floor push-up is about +15° (the plyometric model:
+4 to +13°); this model is -5 to -14°, taken as -10°. Interpolating gives ratios to +15° of 0.96
(pec), 1.20 (front delt), 1.15 (triceps); applied to the library Push-Up (pec 0.84, triceps 0.60,
front delt 0.52): pec 0.80, triceps 0.69, front delt 0.62. All PRIMARY for the paint. A judgement
call anchored on the library's push-up values. ExRx names the clavicular pec the target with the
sternal pec, front delt and triceps as synergists; its comments add that lower elevations target
the sternal head with the clavicular head as a synergist and very high ones may not involve the
sternal head (an earlier draft misread this as lower elevations still working the sternal head). Stabilisers from ExRx: serratus anterior,
rectus abdominis, obliques, quadriceps.

## Plyometric Push-Up

Model facts: a floor push-up with the same hands as the decline (0.64 m wrists, fingers forward);
the body 15° above level at the top (trunk 75° from vertical), 5° at the bottom. Still to 0.25 s;
a controlled descent to elbows 78° at 1.08 s (0.83 s), the chest (skinned pecs) 12 cm off the
floor; ~0.1 s at the bottom; an explosive push to straight arms (173°) by 1.46 s; the hands
leave the floor from ~1.46 to ~1.83 s, the palms' lowest point at most 5.2 cm up (1.67 s), the
shoulders 7 cm and the pelvis 4 cm higher than at the top, the elbows bending to ~158° in the air;
the toes stay on the floor and the body stays straight (178°). No clap: the hands come straight
back down. Landing at ~1.83 s with the elbows ~158°, it sinks to 102° at 2.33 s (chest 21 cm off
the floor), then presses back up slowly to straight arms by 3.33 s and waits to 4.25 s; the
second rep repeats it (bottom 5.08 s, flight ~5.46-5.83 s, sink 6.33 s). The elbows are ~37° out
from the trunk at the bottom.

| Claim | Source |
|---|---|
| Push hard enough for the hands to leave the floor; this model's hands lift about 5 cm | ExRx Clap Push-up (lower and immediately push up as fast as possible; the hands leave the ground); the model (5.2 cm) |
| In a review of 30 studies, upper-body plyometric training improved medicine-ball throws and strength over controls; the certainty of that evidence was low or very low | Garcia-Carrillo et al. 2023 (35 studies reviewed, 30 meta-analysed, healthy youth and young adults; maximal strength ES 0.39, medicine-ball throw 0.64; GRADE low or very low) |
| Catch on bent elbows and sink; clap push-up lifters met the floor with the elbows bent ~30° and bent ~20° more; this model ~160° -> ~100° | Moore et al. 2012 (full text, Table 1: elbow flexion at contact -29.91 +- 9.40°, displacement -20.79 +- 7.77°); ExRx (catch the body); the model |
| Landing on locked arms is the mistake | Moore et al. 2012 (elbow flexion at contact and displacement as the landing's absorption) and ExRx (catch the body). The jolt to the joints (comparison) is reasoning |
| The abs and obliques hold the trunk straight; ballistic push-ups needed more muscle activity and loaded the spine more | Freeman et al. 2006 (abdominal wall and back muscles recorded; more dynamic, ballistic push-ups required more activation and higher spine load); ExRx (keep hips and waist straight) |
| Hands land back where they took off, just outside and under the shoulders, as ExRx's clap push-up has you do | ExRx Clap Push-up (place the hands back in the original position, catching the body; hands shoulder width or slightly wider); the model (the hands land on the same spots, 0.64 m). Less of the arm under the load with the hands forward is reasoning |
| A quick drop and an immediate push produced more peak force and a faster rise in force than a push from a still bottom | Dhahbi et al. 2017 (countermovement vs squat plyometric push-ups: peak GRF and RFD at take-off higher with the countermovement) |
| Lower under control until the elbows pass a right angle, then push at once | The model (0.83 s down to 78°, ~0.1 s at the bottom); ExRx (lower and immediately push) |
| Setup: start from the knees if you cannot yet push off the toes; brace before each rep | ExRx (pivot off the knees if too difficult; a solid strength base first) |

Activation: no %MVIC values were found for this push-up. Freeman et al. 2006 found ballistic
push-ups needed more muscle activation than ordinary ones, and Garcia-Masso et al. 2011 measured
pec, triceps, front delt and external oblique activity in three plyometric push-ups (values not in
the abstract; the full text is paywalled). Values a little above the library Push-Up: pec 0.88
(0.84), triceps 0.70 (0.60), front delt 0.60 (0.52); the abs LOW secondaries, rectus abdominis
0.32 and obliques 0.28 (the library Push-Up and ExRx list them as stabilisers; dim paint). A
judgement call. Stabilisers: serratus anterior (ExRx push-up), gluteus maximus (library Push-Up),
quadriceps (ExRx decline push-up's straight-leg stabiliser, as here).

## Chest Dip

Model facts: parallel bars 0.60 m apart (centres; 6 cm thick, top 1.23 m), running front to
back; a neutral grip, the palms facing in. Top: elbows 175°, trunk 12° forward. It lowers for
~1.5 s (0.4-1.9 s) to elbows 76° with the trunk 33° forward; at the bottom the shoulder joints sit
0.8 cm below the elbows (the upper arms 2° past level) and the upper arms ~59° behind the trunk;
it holds ~0.5 s, presses in ~0.9 s, holds the top ~1 s. The elbows stay over the hands (x 0.30 vs
0.30) so, from the front, the forearms stay upright; from the side the elbows go back. Knees bent
110°, the feet behind and side by side (not crossed), the thighs about vertical (hips 163-166°).
The pelvis drops 21 cm, the shoulders 28 cm.

| Claim | Source |
|---|---|
| The chest tips forward as you lower; leaning lets you sink deep with less shoulder extension | McKenzie et al. 2022a (full text: in the bar dip the thorax can lean forward, which aids depth while reducing the share of depth from shoulder extension); the model (12° -> 33°) |
| ExRx's chest dip bends at the hips and knees and targets the chest; its triceps dip keeps the hips straight | ExRx Chest Dip (bend knees and hips; target pectoralis major, sternal) and Triceps Dip (keep hips straight) |
| Lean grows to ~30° at the bottom | The model (33°); McKenzie et al. 2022b (non-fatigued bar dips: lean 18.5° at the start, peak 37.3 +- 9.8°), a similar pattern chosen freely |
| In competition a dip usually counts once the shoulders pass below the elbows; the model goes just past elbow height, elbows ~75° | StrengthLog Bar Dip (in a competitive event a rep often counts once the shoulder passes below the elbow; in your own training go as deep as you comfortably can); the model (0.8 cm below, 76°). An earlier draft called it the usual standard for a full dip, which says more than StrengthLog does |
| Lifters used most, not all, of their shoulders' backward range at the bottom | McKenzie et al. 2022a (88% of the maximal range test) and 2022b (76%) |
| Elbows over the bars, travelling backward, not out; elbows flaring out to the sides is a common mistake | StrengthLog Bar Dip (your elbows should go backward, not out; common mistakes include flaring the elbows out to the sides); the model (elbows over the hands). ExRx's chest dip lets the elbows flare to the sides on a wide bar; on these bars, about shoulder width, the model keeps them over the hands, and the copy follows the model and StrengthLog. The ExRx dip-bar-width tip (hands no wider than the elbows at a right angle) was dropped from the copy: it limits grip width and does not ask for the elbows over the hands |
| Shoulders down; shrugging makes the dip less efficient and stresses the shoulder | StrengthLog (shoulders down and back, not shrugged toward the ears) |
| Knees bent, feet behind, legs quiet; kicking out of the bottom is the mistake; StrengthLog lists swinging the body for momentum among common dip mistakes | ExRx (bend knees and hips slightly); StrengthLog Bar Dip (using momentum, swinging the body to complete the movement); the model (110°, still) |
| Comparison: bolt upright, more of the depth has to come from the shoulders bending back | McKenzie et al. 2022a (the bench dip, with the least lean, used the most shoulder extension). An earlier draft said all of the depth, which overstates it |
| Setup: bars about shoulder width or a little wider, palms in, press up, knees bent, slight lean | The model (bars 0.60 m vs outer shoulders 0.57 m); ExRx (arms straight with shoulders above hands, knees and hips bent) |

Activation: no %MVIC exists for the bar dip. McKenzie et al. 2022a reported peak EMG in mV: the
bar dip raised the pec, front delt, triceps and other muscles over the bench dip (triceps 1.04 vs
0.83 mV). Values from the library's dips moved up for an unassisted, leaning dip: pec 0.84
(Assisted Dip 0.56; ExRx names the sternal pec the target), triceps 0.82 (Assisted Dip 0.84, Bench
Dip 0.86), front delt 0.66 (Assisted 0.48). A judgement call. Stabilisers from ExRx's synergist
and stabiliser lists: pectoralis minor, latissimus dorsi, rhomboids, lower trapezius.

## Weighted Chest Dip

Model facts: the arms and trunk move exactly as the Chest Dip (the same joint angles to the frame);
the hips a little straighter (170-176°) with the feet higher behind. A dip belt with two 36 cm
chains (S50_DipBeltChain, _R) and a 34 cm plate (BeltPlate) hanging 4-9 cm in front of the
thighs, its top 21 cm below the belt; the plate moves with the hips (5-6 cm back at the bottom, as
the pelvis), with no swing of its own.

| Claim | Source |
|---|---|
| The belt sits low on the hips, the plate hanging in front; a dip belt carries the load with the hands free | ExRx Weighted Chest Dip (weight on a dip belt around the waist); StrengthLog (add weight with a weight belt); the model |
| Hung close in front of the thighs, the plate stays clear of the bars and legs; a long chain lets it swing | The model (4-9 cm in front of the thighs). The swing is reasoning |
| The lean grows from ~12° to ~33° as in the bodyweight dip | The model |
| The bottom, where the shoulders are bent furthest back, is the dip's most vulnerable position; a pectoralis major tear during weighted dips has been reported; dip researchers caution that added load or fatigue may raise the risk of pec injury | McKenzie et al. 2022a (peak shoulder extension, 88% of the maximal range in the bar dip, previously identified as the dip's most vulnerable position; added load, fatigue or a wide grip may markedly raise the risk of pec injury); Carek and Hawkins 1998 (one pectoralis major rupture during weighted parallel bar dips; case report). An earlier draft said the bottom is most demanding on the chest and that tears (plural) have been reported; both said more than the sources |
| Stop with the shoulders at elbow height; add weight only while that depth stays smooth | StrengthLog (depth as far as comfortable); the model. The progression rule is reasoning from the sources above |
| Finish every rep on straight arms | ExRx (push the body up until the arms are straight); the model (175°, held ~1 s). The reset is reasoning |
| Quiet legs keep the plate still; a kick sets it swinging | Reasoning; the model (legs still, plate moving only with the hips) |

Activation: no EMG exists for the weighted dip; the added load raises each value over the
bodyweight Chest Dip (pec 0.84 -> 0.90, triceps 0.82 -> 0.88, front delt 0.66 -> 0.72). A
judgement call. Stabilisers as the Chest Dip with core for the hanging load.

## Landmine Chest Press

Model facts: standing, the left foot a step ahead (ankles 43 cm apart front to back, 36 cm side
to side; the right toes ~15 cm behind the left heel), knees soft (~160°; the front knee bends to
151° as the arms press), trunk 15° forward, 18° at the top. Both hands on a crossbar handle (20 cm,
S50_LandmineHandle with two grips) at the bar's free end, the hands 16 cm apart, palms forward and
slightly in; the plate on the bar just beyond the handle, the bar's other end in a base on the
floor 2.0-2.4 m ahead (off screen). Start: the handle at upper-chest height (the hands level with
the upper pecs, 3-14 cm in front of them), elbows 60°, pointing down by the sides. Press 0.3-1.25 s
up and forward along the arc (the handle rises 36 cm and moves 31 cm forward, ~49° above level),
the elbows opening to 162° (not locked) and drawing in toward the midline (upper arms ~14° inward
at the top); the hands finish about face height; held to ~1.6 s; lowered over ~1.8 s; resting at
the chest to 4.3 s. At lockout the arms sit ~131° from the trunk's down line, about where a 40°
incline bench press finishes (90° + the incline).

| Claim | Source |
|---|---|
| Both hands on the crossbar handle, wrists straight; the close two-hand grip keeps the triceps busy: in a bench-press EMG study, narrower grips raised triceps activity | Lehman 2005 (12 men, isometric flat bench holds: moving from wide to narrower grips increased triceps activity); the model (hands 16 cm apart); StrengthLog Landmine Press (one or both hands) |
| The handle starts at the upper chest, elbows low by the sides | StrengthLog (the bar resting on the chest at the start); the model (60°, elbows below the shoulders). The forearms-behind-the-handle line is reasoning |
| Press up and forward along the bar's arc; the handle climbs ~50°, the arms finish about where they would at the top of a 40° incline press; in bench-press EMG studies inclines of about 30-45° drew more upper-chest and front-delt activity than a flat bench | The model (49°, 131°); Trebs et al. 2010 (clavicular pec higher at 44° and 56° than flat; front delt higher at 28, 44 and 56°); Rodriguez-Ridao et al. 2020 (upper pec greatest at 30°); Lauver et al. 2016 (upper pec higher at 30° and 45° in part of the concentric phase). Activity, not work: the studies measured EMG |
| Nearly straight arms at the top | The model (162°). StrengthLog presses to lockout; the copy follows the model |
| A small forward lean, ~15° here, puts body weight behind the press; leaning back arches the lower back | The model; the library's landmine presses (core cue). Reasoning |
| Left foot a step ahead, knees soft, weight through both feet | The model; the library's landmine presses (stance cue). StrengthLog sets the feet about shoulder-width apart; the copy follows the model |

Activation: no EMG exists for the two-hand landmine press. Values from the library's Single-Arm
Landmine Press (upper pec 0.78, front delt 0.76, triceps 0.50), the triceps raised to 0.62 for the
close two-hand handle (Lehman 2005). The pec row is "Pectoralis Major" for the paint (all three
parts bright). StrengthLog lists the front delt first for its landmine press; the pec just above
the front delt follows the library's Single-Arm Landmine Press, and the order of the two is a
judgement call like the values themselves. Stabilisers: serratus anterior,
core, glutes, rotator cuff (the library's landmine presses).

## Distinct from the library

The Push-Up, Incline, Wide-Grip, Diamond, Archer and Medicine Ball Push-Ups keep the feet on the
floor and never leave it; the decline raises the feet on a bench (more load on the hands, a
head-down slope) and the plyometric push-up throws the hands off the floor and catches. The Bench
Dip (hands on a bench, feet on the floor) and the Assisted Dip (kneeling on a counterweighted pad,
trunk upright) are triceps-led dips; the two chest dips hang free on parallel bars and lean
forward, one with a belt and plate. The Single-Arm, Half-Kneeling and standing Landmine (shoulder)
Presses press one arm from the shoulder and fight rotation; the Landmine Chest Press drives a
two-hand handle from the chest. Cue sets: body line, hands, elbows, depth, head (decline); drive,
landing, body, hands, countermovement (plyometric); lean, depth, elbows, shoulders, legs (dip);
belt, lean, depth, lockout, legs (weighted dip); grip, start, path, trunk, stance (landmine).
Sibling copy was checked for repeats: the two dips share cue ideas (lean, depth, legs) but no
sentence; the two push-ups share the hipsSagging ghost and the body-line idea, worded apart.

## Labels

Rows after the squeeze (0.16-0.80; overrides via `ov()`), checked on the five stills with
`overlay.py` and then on the lab's trainer shots:

- Decline Push-Up (the body in a band v 0.40-0.62, head left, bench right): depth 0.16 right,
  head (Head in line, short so it ends left of the other leaders) 0.24 left and body 0.24 right
  on the same row; elbow 0.64 right and hands 0.72 left below the body (the other order put the
  hands leader across the elbow pill). The body label sat at 0.32 until the second lab round: in
  its mistake view the model is lifted (roomBelow) and the body at the top of the rep reached
  ~0.31-0.48, so the pill lay over the legs and feet.
- Plyometric Push-Up (band v 0.42-0.60): depth 0.24 left, body 0.32 right; hands (Hands land in
  place, ending at x ~0.41) 0.64 left, land 0.64 right (~10 pt under the shoes), drive 0.72 right,
  its leader passing between the two 0.64 pills.
- Chest Dip (three-quarter front-left, the lifter's front to the left; above the bars only the
  right column is free at the bottom of the rep, the head and chest filling the left): lean 0.16,
  shoulders 0.24, depth (To elbow height, pointing at the near elbow, the height the shoulders
  should reach) 0.32 and elbow (Forearms upright, pointing at the near wrist on the bar) 0.40, all
  right and at most 16-18 characters so they start right of the near elbow (x ~0.60 at the
  bottom); legs 0.72 left, below the bars, pointing at the far knee (`patella_R`) since the review:
  the near knee's leader crossed the near post for ~20-27 px, the far knee's for ~5-15. The lean
  label points at the neck, which carries the trunk's lean and keeps the leader above the near
  shoulder; a leader to the chest joint would cross the near arm. Review (2026-10-04): the right
  column sits 36-56 px from the back and near arm (closest, depth at the bottom). No cleaner
  layout was found: above the bars the head and chest fill the left down to x ~0.16; below the
  bars on the left a pill clears the lifter in the side-on mistake views but hits the near post in
  the head-on ones (elbow and shoulders, view +1.0), so the elbow and shoulders pills must stay
  right, and the depth and lean leaders from the lower left would cross the near bar and the pec;
  the eye button keeps the column from starting above 0.16 and the bar's end (v ~0.43) from going
  past 0.40.
- Weighted Chest Dip: lean 0.16, depth (Shoulders to elbows, pointing at the near shoulder) 0.24,
  lockout (Finish straight) 0.32 right; belt (Belt low) 0.52 left, short so it clears the plate,
  its leader to the pelvis at the belt; legs (Legs quiet, pointing at the feet) 0.40 right, just
  above the post's cap: at 0.72 left the plate (v 0.58-0.72 at the bottom) ran through the pill,
  and at 0.48 right the lifted model's feet ran into it in the legs mistake view.
- Landmine Chest Press (the bar and plate sweep the upper left, the lifter in the middle, only a
  narrow strip free at the right). Relaid in the review: the first layout had four pills at
  0.62-0.80 left whose leaders ran ~300 pt up to the hands and elbows, across the bar at the bottom
  of the rep (the bar runs from the hands down-left) and, for the near-wrist one, over the trunk.
  Now: grip (Wrists straight, `hand_R`) 0.12 left, above the bar and plate at every moment (at
  lockout the fists top out at v ~0.15 and the plate at ~0.23; the eye button is on the right);
  core (Lean in, `neck`) 0.24 right, short so it starts at x 0.80, clear of the leaned-back ghost
  in its own mistake view (the ghost's shoulders reach x ~0.70; Lean in, brace at 0.70 touched
  it); path (Up the arc, `hand_R`) 0.66 left, short so its leader comes up between the plate and
  the near forearm instead of along the forearm; elbow (Elbows low by the ribs, `forearm_R`) 0.74
  left, long so its leader passes right of the path pill (the hand target sits up-left of the
  elbow target, so the path pill must be the upper one or the leaders cross); stance (Left foot a
  step ahead) 0.80 left. Each lower-left pill was checked in its own lifted mistake view: path at
  0.66 ends ~50 pt left of the toes at lockout (at 0.70 it reached them), elbow at 0.74 ~25 pt.
  `SCRATCH/chest/review/evalay.py` measures pill and leader overlap on the stills.

## Ghosts

Measured with the port at the fault's moment (press kind: bottom = elbow most bent in the first
4 s, lockout = straightest; seconds where that picks the wrong rep moment); torso 0.592 m.

- Decline: body `chest500HipsSag(0.26)` at the top (pelvis ~15 cm, ~25 pt; the shared
  `hipsSagging`, ~9.5 cm at the bottom, read as a slight bend in the first lab still); hands
  `chest500HandsForward(0.26)` (the level slide, ~15 cm, ~24 pt, the elbows re-seated, 78° -> ~82°;
  bottom), level since the body's up axis tips toward the floor; elbow `chest500ElbowsFlared(41)`
  (bottom; the upper arms from 49° to ~88° out from the trunk, a T, the elbows re-seated so the
  elbow keeps 78° and both bones their length, each elbow ~18 cm toward the head and out, the
  shoulder line drawn with the arms; from the framing ~20 and ~26 pt with the two arms apart);
  depth `chest500PushUpHigh(0.28)` (shoulders ~17 cm higher, elbows 78° -> ~135°; bottom); head `chest500HeadDropped(40)` (the crown, `head.tip`, ~15 cm lower, ~25 pt;
  bottom).
- Plyometric: drive none (speed); land `chest500PushUpHigh(0.24)` at 2.33 s, the sink after the
  catch (strength 0.86, shoulders ~12 cm higher, elbows 102° -> ~162°); body `hipsSagging` at
  2.33 s, as `chest500HipsSag(0.26)` (~26 pt); hands `chest500HandsForward(0.26)` at 2.33 s (~15 cm,
  ~25 pt, the elbows re-seated); depth `chest500PushUpHigh(0.28)`
  at the bottom (1.08 s; elbows 78° -> ~129°, ~30 pt). The landing and stopped-high ghosts share a
  piece: both draw arms that stay straighter than the model's; withBend makes the landing ghost
  show through the slow descent too, read as arms that will not bend.
- Chest Dip: lean `chest500DipUpright(20)` (33° -> ~13° at the bottom, head ~24 cm, ~52 pt);
  depth `chest500DipHeldHigh(0.32)` (~19 cm higher, elbows 76° -> ~130°); elbow
  `chest500DipElbowsOut(0.2).seen(1.0)` (~9 cm out; head-on both elbows ~20 pt; from the framing
  the near one moved ~2 pt along the line of sight); shoulders `chest500DipShrugged(0.18).seen(1.0)`
  (both shoulder joints ~11 cm up the trunk toward the ears, the hands on the bars, the elbows
  re-seated, 76° -> ~107°, the trunk and head where the model has them; head-on the shoulders rise
  ~24 pt past the base of the neck into a V; withBend, so nothing at the top where straight arms
  leave no room). Until the review this piece sank the trunk and head ~11 cm between fixed
  shoulders: that flattened the shoulder line into a T across the chest (the neck joint starts
  ~10 cm above the shoulder joints) and did not read as a shrug in the lab still; legs
  `chest500KneesKicked(15)`
  (knees ~12 cm, feet ~18 cm forward; 25° moved the feet ~30 cm and 35° ~41 cm, too far). All at
  the bottom.
- Weighted Chest Dip: belt none (where the plate hangs); lean as the Chest Dip; depth
  `dipSunk(-0.14, legsRide: true, ...)` (the Assisted Dip's piece: ~8 cm deeper, shoulders ~10 cm
  below the elbows, elbows 76° -> ~65°; bottom); lockout `dipSunk(-0.12, ... .whenStraight)`
  (elbows 175° -> ~123° at the top, strength 0.94); legs as the Chest Dip.
- Landmine Chest Press: grip `chest500WristsBack(65).seen(-0.6)` (the hand tips ~12 cm toward the
  face, ~31 pt near side-on; bottom; the shared `wristBentBack`, 48°, barely showed in the first lab
  still); elbow `chest500LandmineElbowsOut(65)` (bottom; the elbows re-seated after the turn, so
  they swing ~21 cm out and up, ~13 cm out to the sides and from 0° to ~45° out from the trunk,
  ~32 and ~49 pt; the first version, 40° without re-seating, stretched the forearm from 25 to 33 cm);
  path `chest500LandmineShort.seen(-0.3)` (hands ~7 cm down the arc, elbows 162° -> ~117°, ~20-25
  pt; lockout); core `chest500LandmineLeanBack(25, arch: 0.05).seen(-0.7)` (the trunk tipped back
  about the pelvis, 15° forward -> ~10° back, the hands on the handle, the elbows 71° -> ~160°, the
  head ~30 cm back, ~77 pt side-on; at 0.6 s while pressing; at -0.4 the arms crossed the shoulder
  line); stance
  `chest500FeetLevel(0.36).seen(-0.4)` (each ankle ~21 cm to level with the hips, ~50 pt; the legs
  drawn straight between hip and ankle come out ~5 cm (~11%) short; re-seating the knees instead
  keeps the bones but crossed the two knees into an X, so the straight legs stay). The library's
  `leanedBack` was not used: it carries the hands with the trunk, ~34 cm off the handle.
- Bone lengths were checked for every ghost at its moment (`SCRATCH/chest/review/bones.py`): all
  arm and leg bones kept except the stance's straightened legs above; the hips-sag pieces bend
  the spine chain (pelvis-spine 11 -> 15 cm), which reads as the sag.

## Library rows

- Decline Push-Up UPPER PECTORALIS stays: ExRx files the decline push-up under the upper chest
  with the clavicular pec as target. Nobody has measured the clavicular head in a decline push-up
  (Lin et al. 2026 recorded the sternocostal fibres: not significantly different between 15°
  head-down and 15° head-up, lower than level, lowest at 30° head-down), and ExRx itself notes
  that lower elevations target the sternal head. The copy therefore says only that ExRx files the
  push-up under the upper chest and what Lin measured; it never claims the decline works the
  upper chest harder, and the activation row is Pectoralis Major for the paint.
- Chest Dip / Weighted Chest Dip LOWER PECTORALIS: no EMG separates the pec heads in a dip; ExRx
  names the sternal pec the target. Leave as is.
- Landmine Chest Press UPPER PECTORALIS: consistent with the incline-like finish (Trebs 2010,
  Rodriguez-Ridao 2020); StrengthLog lists the front delt first. Leave as is.
- Plyometric Push-Up PECTORALIS MAJOR / advanced, the rest of the equipment and difficulty words:
  no change.

## Lab rounds

- Round 1 (`SCRATCH/chest/round1/`): every label clear in the trainer shots; ghosts weak or
  unclear for the decline hips (`hipsSagging`), the dip shrug (framing), the landmine wrists
  (48°) and the landmine lean-back (arms across the shoulder line at -0.4).
- Round 2 (`SCRATCH/chest/round2/`): those four fixed; the decline elbow turned to a true side
  view. In the mistake views (model lifted) the decline body pill lay over the legs and the
  weighted dip's legs pill over the feet; both moved; the dip shrug deepened.
- Round 3 (Decline Push-Up, Chest Dip, Weighted Chest Dip only).
- Review (2026-10-04, a second agent, sources and model): every cited record opened (Europe PMC /
  PubMed, the PMC full texts of Lin, McKenzie a and b, Moore and Noteboom, the ISBS paper, the
  saved Wayback ExRx pages and the StrengthLog pages); copy and notes softened where they said more
  than the source (Marcolin, Suprak, Carek, the dip standard, all of the depth, the landmine
  inclines), the Noteboom and dip-bar-width sentences dropped, the ExRx decline elevation comment
  read correctly; the decline elbow, dip shrug, both hands-forward and the landmine elbow ghosts
  rebuilt (above); the landmine labels relaid and the dip's legs leader moved to the far knee.
  Round 4 lab stills in `SCRATCH/lab/chest/`.
- Left as is: at the top of the weighted dip (the lockout fault) and of the landmine press (the
  path fault) the lifted model's head and hands reach the COMMON MISTAKE banner in the mistake
  view; the ghosts read, the overlap is the mistake view's framing of the top position.
- The legend's primary line (three primaries) is cut after ~40 characters (PECTORALIS MAJOR ·
  TRICEPS BRACHII · ANTER...), as on the library's rows with three primaries.
