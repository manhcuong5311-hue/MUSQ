# 30-leg set: machine squats (2026-09-28)

Three exercises from the HIKSEMI "300-350/27_9" folder: Belt Squat, Pendulum
Squat and V-Squat. `spec_legs30_machine.py` holds the copy (its header lists
what each model shows and the full source citations),
`Tools/fault-review/faults_legs30_machine.swift.txt` the ghosts and
`fault_moments_legs30_machine.json` when each is stilled. This file maps each
claim in the copy to its source and records where the models differ from
textbook technique.

## Shared facts about the models

- Both legs work together; nothing alternates, so faults use `*` and read the
  bend from `shin_L`.
- Tempo (pelvis height, briefs_legs30): top 0-0.12 s, down ~1.0 s, a hold of
  0.75 s (belt, V) or 0.8 s (pendulum) at the bottom, up ~1.75 s; second rep
  4.0-7.9 s. Deepest points 1.33 s (belt, pendulum) and 1.38 s (V).
- Rig: torso (neck to pelvis) 0.59 m, shoulder joints 0.39 m apart, no toe
  joints. The foot bones never change angle in any clip: the feet stay flat.
- Framing (probe.py JOBS): belt -0.8 (three-quarter from the front-left),
  pendulum and V -1.3 (side-on from the left, the lifter facing screen-left,
  the machine behind on the right).
- Measured in the USD with a scratch script (pxr, Blender's Python): foot
  bone pitch (belt 24° below level, pendulum 34°, V 16°), the footplates'
  top surface heights at each end, the belt and handle meshes.

## Belt Squat

Model: raised deck (0.30 m), padded hip belt from hip-joint height to ~20 cm
above, the cable clipped to the front of the belt and running down between
the feet through a slot in the deck to a weight trolley on the front upright
(it rises and falls with the hips). At the top the cable slants ~12° forward
from the slot (z 0.10) to the clip (z 0.25 at 0.98 m up), so the clip sits
~15-17 cm ahead of the ankles (z 0.08); at the bottom it hangs nearly
straight (clip z 0.11). Ankles 0.42 m apart (about the
0.39 m shoulder-joint width: "shoulder-width"), toes out 12°, ankles in line
front to back with the cable slot. Hands on two fixed handles 1.44 m up:
~28 cm below the shoulders at the top (elbows 80°), reached up to at the
bottom. Hips sink 46 cm, only 5 cm back; knees 161° -> 54°, hips 163° -> 87°,
trunk 5° -> 25°; shins 59° forward, the knee ~34 cm ahead of the ankle; the
thighs stop ~20° above parallel (hip joint ~15 cm above the knee joint).

Claims and sources:
- Activation Quadriceps HI 0.88, Gluteus Maximus MOD 0.46, no erector row:
  the library's Back Squat is quadriceps 0.90, gluteus maximus 0.62, erector
  spinae 0.45. Quadriceps did not differ between belt and back squats in
  Evans 2019 (vastus medialis, lateralis, rectus femoris), Joseph 2020 and
  Gulick 2015. Gluteus maximus was lower in the belt squat in Evans 2019
  (0.69 vs 0.84 and 0.71 vs 0.86, about 18%) and Joseph 2020 (32-35%), not
  different in Gulick 2015 (a SquatMax-MD machine whose load slides along a
  fixed rod; Joseph 2020 contrasts this with the pivoting load in its own
  study and in Evans 2019, both of which found less gluteus maximus, and
  notes that fixed-track resistance lowers activation). 0.62 cut by
  about a quarter -> 0.46. Lumbar erector activity about half the back
  squat's (Joseph 2020: impulse -45.4%, peak -52.0%), so no erector row.
- Stabilisers adductors, hamstrings, calves: Joseph 2020 found adductors,
  integrated biceps femoris (peak 12.2% lower) and medial gastrocnemius not
  different from the back squat, whose
  library entry lists them as stabilisers; ExRx Cable Belt Squat and Weighted
  Belt Squat (synergists adductor magnus, soleus; dynamic stabilisers
  hamstrings, gastrocnemius). StrengthLog lists the adductors among the
  primary muscles; they stay a stabiliser here for consistency with the Back
  Squat, since the one study that measured them found no difference. "core"
  is left out: Joseph 2020 found rectus abdominis and external oblique
  activity lower than in the back squat.
- Cable cue (feet either side of the cable, ankles in line with where it
  runs down between the feet, shoulder-width, toes out a little): ExRx Cable
  Belt Squat ("Stand with feet shoulder width or wider to each side of
  cable"); the model (ankles in line with the deck slot). Joseph 2020's
  method ("the ankles were aligned with the belt attachment point", the
  manufacturer's instruction) refers to its pivoting-lever machine, not a
  cable machine like the model's, where the clip on the front of the belt
  sits ~15 cm ahead of the ankles at the top; so the copy lines the ankles
  up with the cable's run between the feet, not with the clip. "Runs down
  from the front of the belt" replaces "runs straight down" (the cable
  slants at the top). The consequence of standing off
  the line (the cable pulls the hips back behind the heels) is mechanics, not
  a measured result.
- Hands cue: the balance role ("only there to steady you") comes from ExRx
  Cable Belt Squat alone ("holding onto pole for balance", or arms held
  forward). Joseph 2020 was stricter: participants "were not allowed to
  utilize the handle to steady themselves or assist them during belt
  squats. Rather participants were asked to hold their hands hovering above
  the bar or to lightly rest them on the top of the bar", and it notes that
  grasping the handle could let the arms assist. So the copy's study
  sentence says only what the lifters did ("hovering over the handle or
  resting lightly on it, without pulling") and does not credit the study
  with the steadying role. "Takes some of the work off the legs" is
  reasoning from Joseph's note, worded softly. The model holds the handles;
  nothing shows it pulling. The handles are fixed, so the correct line says
  the arms "simply reach up to stay on the handles" as you sink (they do not
  move, so the hands cannot follow them; see Model notes).
- Knee cue: knees in line with the toes (ExRx: "Knees should point same
  direction as feet"). Fry 2003 (7 men, parallel barbell squats) supports
  knees moving slightly past the toes (restricting them cut knee torque and
  raised hip torque and trunk lean; appropriate loading "may require the
  knees to move slightly past the toes"); "well forward" describes the model
  (knee ~34 cm ahead of the ankle, ~19 cm past the ball of the foot, far
  beyond what Fry studied) and fits Layer 2018's larger knee moments. Larger knee and ankle moments and smaller low-back moments:
  Layer 2018 (maximal isometric belt vs back squats at 4 depths, values
  interpolated to a 45° thigh angle; higher peak force, knee and ankle
  moments, lower low-back moments; hip moments not different). Because the
  efforts were maximal and the belt squat produced more total force, the
  larger moments partly reflect that force, not only where the load sits;
  the copy says "in maximal held squats at the same thigh angle" and names
  no size. Caving knees taking the load at an angle: Powers 2010 (hip control
  and knee mechanics), as in the split squat notes.
- Depth cue: "The belt keeps the load off the spine": Gulick 2015 (unloads
  the shoulders and spine), Layer 2018 (lower low-back moments). "So the back
  is less often what stops you going deeper" is **reasoning / coaching
  convention**, no study: Layer 2018 measured lower low-back moments at a
  fixed thigh angle, not how deep lifters could go. "In one squat analysis,
  the knee extensors had to work closer to their maximum the deeper the
  squat": Bryanton 2012 (10 strength-trained women; relative muscular
  effort = net joint moment over the maximum torque at that joint angle,
  computed from joint moments, not EMG; it rose with depth, not load). It is
  the only study behind the claim, hence "one squat analysis" and "knee
  extensors" rather than "quadriceps". Caterisano 2002 found the vasti's
  share of EMG unchanged with depth (only the gluteus maximus share rose),
  so the copy claims nothing about quadriceps EMG and depth; this matches the
  barbell family's depth copy. Full-depth training built more glute and
  adductor muscle than half squats: Kubo 2019 (knee extensors grew similarly;
  the copy does not claim more quadriceps growth). "As deep as you can keep
  the heels down and the back flat": StrengthLog ("as deep as possible with
  good technique"); ExRx says thighs just past parallel, which this model
  does not reach (see Model notes), so the copy names no thigh angle.
- Heel cue: ExRx ("feet flat on surface; equal distribution of weight
  through forefoot and heel").
- Comparison STOPPING SHORT: correctNote "takes the knee extensors through
  the range where they work closest to their maximum": Bryanton 2012 (as the
  depth cue). The mistakeNote now says only that stopping at a right angle
  "leaves the deepest part of the range untrained" (the earlier "the part of
  the squat the belt makes easier to reach" had no source). Consistent with
  the depth cue and its ghost (knees opened to ~88°).
- Setup: belt on, cable to the front of the belt, feet either side of the
  cable, hands on the handles (ExRx Cable Belt Squat; the model). Library
  BELT / beginner: the common list offers BELT; beginner matches the library's
  Smith Machine Squat for a guided, back-unloaded squat.

## Pendulum Squat

Model: shoulders under the pads of a carriage swinging about an axle ~1.9 m
up and ~1.2 m behind the heels, back on its pad, hands on handles fixed to
it (elbows 73°). Footplate sloping ~10° down toward the toes (0.33 m at the
heel end, 0.19 m at the toe end; the foot bone pitched ~10° more toe-down
than on the belt squat's flat deck). Ankles 0.46 m apart, toes out 13°. Hips
travel 45 cm down and 40 cm back; knees first forward (shins 33° at 0.5 s),
then back (14° at the bottom); bottom knees 78°, hips 66°, thighs parallel,
trunk 24°. Knees 167° at the top.

- **No EMG or biomechanics study of the pendulum squat was found** (PubMed /
  Europe PMC, "pendulum squat", 2026-09-28; only product and coaching pages).
  Ranked from the library's Hack Squat (quadriceps 0.89, gluteus maximus
  0.44), the closest supported machine squat: Quadriceps 0.88, Gluteus
  Maximus 0.48, raised a little for the model's deep hip bend (hips 66°;
  Caterisano 2002: the gluteus maximus share rose with depth; Kubo 2019).
  Stabilisers adductors, hamstrings, calves as the Hack Squat; StrengthLog's
  pendulum guide lists quads, glutes and adductors.
- Pad cue: the pad carries the trunk; less trunk muscle activity than a back
  squat: Clark 2019 (hack squat, same relative loads), Erdag & Yavuz 2020
  (hack squat erector spinae lower; conference paper), so the copy says
  "hack squats ... have drawn less trunk muscle activity". Stop before the
  pelvis tucks off the pad: ExRx Lever V-Squat, Sled and Lever Hack Squat
  ("If insufficient hip flexibility forces pelvis to pull away from back pad
  ... only lower sled just short of spinal articulation"); StrengthLog
  pendulum guide ("keep your back pressed against the backrest").
- Feet cue: the plate higher at the heels lets the knees travel forward
  (model). "In two-leg squats on decline boards, even a 10° slope raised the
  load on the knee extensors and lowered it at the ankle": Richards 2016
  (18 adults, bodyweight double-limb squats on 0-25° declines; peak knee
  moment 1.65 at 0° to 2.23 at 10°, p<0.001; the ankle moment fell as the
  decline steepened; patellar tendon load was also estimated). The model's
  plate is ~10°, the angle that study already found effective. Supporting
  single-leg evidence on steeper boards: Kongsgaard 2006 (25° decline: more
  knee extensor EMG and patellar tendon strain) and Zwerver 2007 (knee moment
  ~40% higher at 15° and steeper). Push through the whole foot, heels down:
  ExRx ("Do not allow heels to raise off of platform, pushing with both heel
  and forefoot"). About shoulder-width, toes out a little: the model (0.46 m,
  13°); StrengthLog says about hip-width ("slightly about hip-width apart");
  the model's 0.46 m (13° toe-out) is closer to shoulder-width.
- Knee cue: ExRx (knees the same way as the feet); the forward-then-back
  knee path is the model's; Powers 2010 for the caving knee. The label stays
  "Knees over toes" (the intro reads it as "the knees follow the line of the
  toes"); the depth mistake no longer says "knees pushed forward over the
  toes", so the label and the mistake no longer clash. "Knees track toes"
  was tried at the same row: its pill (one character longer) covers ~0.03 of
  the width of the front of the shin at mid-descent, twice the graze of the
  current label, and lower rows cover the toes.
- Depth cue: thighs about parallel or a little lower: StrengthLog pendulum
  guide ("until your thighs are parallel to the floor or slightly lower");
  the model (thighs at -1°). "In one squat analysis, the knee extensors had
  to work closer to their maximum the deeper the squat": Bryanton 2012 (free
  squats; relative effort from joint moments, not EMG; see the belt squat
  depth bullet for Caterisano's unchanged vasti share). Mistake line:
  "the hips still high and the knees pushed far forward", as the ghost shows
  (knee ~21 cm ahead of the ankle instead of ~9 cm). Full range builds more lower-body muscle: Schoenfeld & Grgic 2020
  (systematic review). "As far as the back stays on the pad": ExRx.
- Tempo cue (controlled descent, short pause, no bounce): **coaching
  convention**, no study. It describes what the model does (about 1 s down,
  0.8 s hold). The copy only says the pause makes the legs start from a
  standstill instead of rebounding; it makes no muscle or injury claim.
- Comparison HIPS OFF THE PAD: ExRx (as the pad cue). Library intermediate,
  as the Hack Squat.

## V-Squat

Model: shoulders under the pads, back on the pad, hands on handles on the
carriage (elbows 73°); the carriage pivots about a low axle (0.3 m up, ~2 m
behind the heels). Footplate sloping ~8° up toward the toes. At the top the
feet sit ~42 cm ahead of the hips, the knees 14 cm behind the ankles, the
trunk vertical, knees 161°. Hips drop 34 cm and come 12 cm forward; bottom
knees 71°, hips 78°, thighs parallel, shins 20° forward, trunk 12°. Ankles
0.46 m apart, toes out 11°.

- **No EMG study of the V-squat was found** (searches for "V-squat" and
  "V squat machine", 2026-09-28). Ranked from the library's Hack Squat:
  Quadriceps 0.88, Gluteus Maximus 0.45 (a step below the pendulum, whose
  hips bend further, 66° vs 78°). ExRx Lever V-Squat: target quadriceps;
  synergists gluteus maximus, adductor magnus, soleus; dynamic stabilisers
  hamstrings, gastrocnemius -> stabilisers adductors, hamstrings, calves.
- Pad cue: ExRx Lever V-Squat (shoulders under the pads, back against the
  back pad; the pelvis pulling away from the pad when hip flexibility runs
  out; only lower just short of that). "Technique guides advise".
- Feet cue: ExRx Lever V-Squat ("Placing feet slightly forward on platform
  emphasizes Gluteus Maximus. Placing feet slightly back on platform
  emphasizes Quadriceps."; heels down, push with heel and forefoot; feet
  shoulder or hip width). The foot-position effect is **ExRx coaching
  guidance**, worded "tends to"; mechanically, feet further forward lengthen
  the hip's moment arm and shorten the knee's; no V-squat or hack squat EMG
  study of foot position was checked. Feet ahead of the hips: the model
  (~42 cm at the top, ~30 cm at the bottom), so the setup says "well ahead
  of your hips".
- Knee cue: ExRx ("Squat down with knees pointed same direction as feet");
  knees past the ankles at the bottom: the model (14 cm).
- Depth cue: thighs about parallel: the model. "With the trunk supported,
  the back is less often what stops you going deeper" is **reasoning /
  coaching convention** (the pad carries the trunk; Clark 2019 found less
  trunk muscle activity in the hack squat), not a measured result: no study
  measured reachable depth. Knee extensors working closer to their maximum
  deeper: Bryanton 2012 (relative effort from joint moments, not EMG);
  full-depth training and glute and adductor growth: Kubo
  2019. ExRx says to descend until the knees or hips are near complete
  flexion; the copy allows deeper "while the back stays on the pad".
- Tempo cue: coaching convention, as the pendulum; "stopping just short of
  locking the knees" describes the model's top (161°), not a sourced rule.
- Comparison HEELS LIFTING: ExRx (heels down, heel and forefoot).

## Model notes (where the models differ from textbook technique)

- **Belt Squat knees and depth.** The shins reach 59° from vertical with the
  heels flat, the knee ~34 cm ahead of the ankle, about 19 cm past the ball
  of the foot, while the thighs stop ~20° above parallel. That is more ankle
  bend than most lifters have, and shallower thighs than ExRx's "just past
  parallel". The copy therefore says "as deep as you can keep the heels down
  and the back flat", names no thigh angle, and the depth intro describes
  what the model shows (knees deeply bent, the thighs still somewhat above
  parallel: ~20°, the hip joint ~15 cm above the knee joint, so not "a
  little"); the mistake line is anchored on the knees ("bent to about a right
  angle, the thighs well above parallel"). The heel
  cue and its ghost cover the heels lifting.
- **Belt Squat trunk.** 25° forward at the bottom, more than "upright";
  the knee cue says "fairly upright".
- **Belt Squat hands.** The model grips the handles throughout. The handles
  are fixed at 1.44 m, so as the hips sink the arms end up raised with the
  elbows sharply bent (38-46°) and the hands ~11 cm above the shoulders,
  which looks like hanging on the handles. The copy asks for a light grip
  and says the arms simply reach up to stay on the handles as you sink (no
  "elbows relaxed", which the model does not show).
- **Belt Squat cable.** The cable slants ~12° forward at the top (clip
  ~15-17 cm ahead of the ankles) and hangs nearly straight at the bottom;
  the ankles line up with the deck slot. The copy says the cable "runs down"
  and lines the ankles up with where it runs down between the feet.
- **Belt Squat occlusion.** At the framing yaw (-0.8) the lifter's left foot
  stands behind the front-right upright for the whole rep, and the trolley's
  near plate and sleeve cover the right knee and both feet from mid-descent
  through the bottom hold. The annotation dots therefore use joints that stay
  in view (left knee, right ankle, pelvis, right hip joint); the right ankle
  dot still sits on the plate sleeve during the hold. A more side-on framing
  (yaw about -1.1 to -1.3, as the sagittal ghosts use) would clear the legs;
  that needs probe.py, joints.json and the framing re-run, reported to the
  orchestrator rather than changed here.
- **Belt Squat machine type.** The model is a cable and weight-stack belt
  squat; the studies used pivoting-lever (Evans 2019, Joseph 2020) or
  fixed-rod (Gulick 2015) machines.
- **Pendulum footplate** slopes down toward the toes (heels ~10° higher).
  Pendulum machines differ; the copy explains this plate rather than claiming
  all pendulum plates are angled this way.
- **V-Squat footplate** slopes up toward the toes (~8°), and the lifter
  starts with the feet well ahead of the hips and the knees behind the
  ankles. Not mentioned in the copy beyond "feet ahead of the hips".
- **V-Squat range.** ExRx describes lowering to near-complete knee or hip
  flexion and standing until the legs are straight; the model stops at
  parallel and at 161° at the top. The copy follows the model (parallel,
  deeper if the back stays on the pad; stop just short of locking the knees).
- **Pendulum and V-Squat top**: knees 167° and 161°, never locked.
- **Pendulum and V-Squat knee width.** At the bottom the knees sit inside the
  ankles: pendulum 0.34 m apart vs ankles 0.46 m (each knee ~6 cm medial,
  ~8 cm inside the toe line), V-Squat 0.39 m vs 0.46 m (~4 cm each). The
  thighs still point roughly along the feet (pendulum thigh 10° out vs foot
  13°; V 13° vs 11°), so the knee cue's "pointing out over the middle toes"
  describes the thigh direction more than the knee's position. In the
  face-on knee-fault view the correct lifter's shins already slope inward;
  the knee ghost reads as a further ~10 cm cave from there. The Belt Squat
  is fine (knees 0.44 m apart, ankles 0.42 m).
- No model shows a safety stop being released; the setup step "Release the
  safety stop" is generic to these machines.

## Ghosts and when to still them

Views: belt (-0.8) sagittal faults `.seen(-0.7)` (total -1.5, side-on from
the left), knees caving `.seen(-2.3)` (total -3.1, from behind); pendulum and
V (-1.3) sagittal faults no turn, knees caving `faceOn` (total -0.2).

Occlusion (review 2), ray-tested with probe.py's camera against the
machine's triangles (depth interpolated across each triangle) at 0.5, 1.0,
1.5 and 2.0 s: from the belt squat's near face-on view (total -0.2, the
earlier `.seen(0.6)`) the trolley's plates hide the left knee and the plates
and sleeve both ankles, and turns of 0.3 and 0.9 are blocked too; from
behind (total -3.1) both knees and both ankles are clear at every time,
the lifter at u 0.27-0.55. The belt squat's knee fault is the only entry in
the table turned to a rear view; other entries' rear views come from their
own framing, not from a fault turn. At the side-on total of -1.3 (the
earlier `.seen(-0.5)`) the front upright hid the left knee at the bottom
and the right knee at mid-descent; at -1.5 both knees, both ankles, the hip
and the pelvis are clear at 0.5-2.0 s (only the lifter's own belt covers
the hip joints). Pendulum and V faceOn views: both knees and ankles clear
(the machine is behind the lifter).

New pieces: `machineFeetAheadOfCable` (both feet 0.2 torso lengths ahead,
knees re-seated), `machineHipsOffPad` (pelvis and hips 0.12 torso lengths
forward along the lifter's own forward axis, the chest 0.02, the mid-spine
0.03, less than the ~0.075 a straight chest-pelvis line would give, so the
lower back bows ~2.7 cm back toward the pad: rounded; knees re-seated). The rest reuse `kneesIn`, `heelsUp` and `shallow`.
No ghost for the belt squat's hands cue (pulling on the handles is force,
not position) or the two tempo cues (speed).

Checked with a Python port of `FaultGhost.solve` on the rigs at 1.5 s (the
bottom, strength 1): feet ahead of the cable moves the feet 11.8 cm and the
knee from 34 to 25 cm ahead of the ankle; belt `shallow(0.35, withArms:
false)` lifts the hips 20.7 cm and opens the knees 54° -> 88°; belt heels up
lifts the ankle 9 cm; pendulum hips off the pad moves the pelvis 7.1 cm
(knee 78° -> 67°; measured with the spine at 0.06, before review 1); pendulum `shallow(0.3, ahead: 0.3)` lifts the hips 17.8 cm
and moves them 17.8 cm forward, the knee 78° -> 90° and 21 cm ahead of the
ankle (9 cm in the model); V hips off the pad moves the pelvis 7.1 cm; V
`shallow(0.26, ahead: -0.09)` lifts the hips 15.4 cm, 5.3 cm back, knee
71° -> 99°; heels up lifts the ankles ~8 cm on both.

| Exercise | Cue | Moment |
|---|---|---|
| Belt Squat | cable, knee, depth, heel | bottom |
| Pendulum Squat | pad, feet, knee, depth | bottom |
| V-Squat | pad, feet, knee, depth | bottom |

Every ghost scales with the knee bend (`withBend("shin_L")`), full at the
bottom; the tops are 161-167°, so ~15-20% still shows there.

## Labels

Rows are written on the 0.14-0.86 scale and squeezed to 0.16-0.80 by
`spec_legs30.py`. Checked by drawing the pills (gen.py widths) and leaders
over the start and bottom stills:
- Belt: hands (leading 0.32) to the lifter's right hand; cable ("Over the
  cable", leading 0.50) to the right hip joint on the belt line (u 0.60-0.62,
  nearest the front of the belt where the cable clips, which projects at
  u 0.57-0.59), kept to 14 characters so it ends at u 0.303, clear of the right elbow at
  the bottom (a 20-character label reached u 0.39 and covered it); knee
  ("Knees track toes", leading 0.62) to the left knee, the leader crossing
  the right thigh; foot ("Whole foot flat", leading 0.86) to the right
  ankle over the deck; depth ("Sink deep", trailing 0.50) to the pelvis,
  right of the upright. The cable and depth pills share the squeezed row
  0.48; with the cable dot left of the depth dot the two leaders diverge
  (before review 2 they ran to the pelvis and the right hip the other way
  round and crossed over the belly). All pills stay on machinery (upright, plates,
  deck) at the start, mid-descent and bottom.
- Pendulum: tempo top right (the head is top left); pad (trailing 0.44,
  "Back on the pad") clear of the back at the bottom; knee "Knees over toes"
  at leading 0.74 (squeezed 0.693), at shin height: at 0.68 the pill
  covered the front of the knee at mid-descent (knee at u 0.20-0.32); at
  0.74 it is clear at the start and bottom and only grazes the front of the
  shin at mid-descent; depth trailing 0.68; feet leading 0.86 over the
  plate.
- V: the lifter starts on the right and ends on the left, so tempo is top
  left (above the hands); pad trailing 0.56 (squeezed 0.533), below the
  glutes at the start and right of them at the bottom; depth trailing 0.68;
  knee leading 0.50 (squeezed 0.48), above the knees (at 0.62 it covered
  them during the bottom hold), only touching the ends of the handles at
  the bottom; feet leading 0.86.
Glows are centred on the bottom samples only (`low_glow`, joints.json
samples at 1, 2, 5 and 6 s), since the hips travel 34-46 cm and the all-clip
mean floated off the thigh at both ends.

## Uncertain

- The pendulum and V-squat rows have no direct EMG data; they copy the
  library's Hack Squat with small, stated adjustments.
- The belt squat's gluteus maximus drop is uncertain in size (0-35% across
  three studies); 0.46 sits between them.
- The decline-board evidence behind the pendulum plate claim now includes
  a two-leg study that covers the plate's ~10° (Richards 2016); the
  remaining gaps are that it used bodyweight squats and a board rather than
  a loaded machine.
- ExRx pages were read through Internet Archive snapshots (dates in the spec
  header); StrengthLog guides carry no author or date.

## Change log

- 2026-09-28: first draft of the three entries, faults and moments; labels
  checked over the stills (belt depth label shortened, pendulum knee label
  moved below the knee and shortened, V tempo label moved to the top left and
  the pad label to hip height); glows centred on the bottom samples; depth
  ghosts tuned on the Python port (belt 0.3 -> 0.35, V 0.3 -> 0.26); copy
  tightened to the sources (Layer 2018 named as held squats at matched thigh
  angles; "one belt squat study" for the hands; hack squat named for the
  trunk-activity claim; decline studies named as single-leg; Kubo 2019 as
  glute and adductor growth only).

## Change log (review 1)

- Gulick 2015 described correctly: a SquatMax-MD hip belt squat machine
  with the load sliding on a fixed rod (not a free-weight belt); Joseph
  2020's contrast with pivoting-load machines and its note on fixed-track
  resistance added; Model notes say none of the studies used a cable and
  weight-stack belt squat like the model.
- Pendulum feet cue: Richards 2016 (two-leg decline squats, knee moment up
  and ankle moment down already at 10°) added and now carries the claim;
  why reworded to "in two-leg squats on decline boards, even a 10° slope
  raised the load on the knee extensors and lowered it at the ankle";
  Kongsgaard and Zwerver kept as single-leg support; Uncertain bullet
  updated.
- Joseph 2020 results corrected: integrated biceps femoris not different,
  peak 12.2% lower; medial gastrocnemius and tibialis anterior named instead
  of "calves".
- StrengthLog pendulum foot width quoted correctly (about hip-width).
- Layer 2018 named as maximal held squats at a 45° thigh angle; knee why now
  says "in maximal held squats at the same thigh angle ... larger knee and
  ankle moments and smaller low-back moments"; notes record hip moments not
  different and that the larger moments partly reflect the larger force.
- V-squat feet why softened to "tends to bring in"; notes label it ExRx
  coaching guidance with the moment-arm reasoning.
- Fry 2003 mapped to the belt squat knee cue (knees travelling well
  forward).
- Belt Squat annotations moved off occluded joints: heel to foot_R, cable to
  the pelvis ("Over the cable", leading 0.50), depth to thigh_R, knee to
  patella_L; pills redrawn over the start, mid and bottom stills. Occlusion
  and the suggested more side-on framing recorded in Model notes and
  reported as a shared change.
- V-Squat setup step 2: "well ahead of your hips". Labels: knee to leading
  0.50, pad to trailing 0.56, both redrawn clear of the body.
- Pendulum knee label "Knees over toes"; moved from 0.68 to 0.74 after
  drawing it over the mid-descent still (it covered the knee at 0.68).
- Belt Squat depth intro: "the thighs a little above parallel" (the model's
  thighs stop ~20° above parallel); mistake line now "the thighs well above
  parallel".
- `machineHipsOffPad`: the mid-spine moves 0.03 instead of 0.06, so the
  ghost shows the lower back rounding back toward the pad as the comment,
  the pad cue and the comparison describe; doc comment rewritten.
- Belt Squat hands: Model notes record the raised, sharply bent arms and
  the occluded legs; the correct line drops "elbows relaxed" for "at the
  bottom the hands just follow the handles".

## Change log (review 2)

- Depth why (all three): "In squat studies the quadriceps worked relatively
  harder the deeper the squat" -> "In one squat analysis, the knee extensors
  had to work closer to their maximum the deeper the squat"; belt comparison
  correctNote now says the knee extensors work "closest to their maximum".
  Notes: Bryanton 2012 measured relative effort from joint moments (10
  women), not EMG; Caterisano 2002 found the vasti's EMG share unchanged
  with depth. Consistent with the barbell family.
- Fry 2003: header and notes now say it supports knees moving slightly past
  the toes; "well forward" is the model's (and fits Layer 2018), not Fry's.
- Belt hands: notes quote Joseph 2020 in full (not allowed to steady or
  assist); the balance role credited to ExRx only; copy's study sentence
  now "hovering over the handle or resting lightly on it, without pulling".
  Correct line: "as you sink, the arms simply reach up to stay on the
  handles" (the handles are fixed).
- Unsourced depth reasoning softened and labelled: belt depth why "the back
  is less often what stops you going deeper"; V-Squat "With the trunk
  supported, the back is less often what stops you going deeper"; belt
  comparison mistakeNote "leaves the deepest part of the range untrained".
  Notes label the first two as reasoning / coaching convention.
- Caterisano 2002 and Fry 2003: full author lists and DOIs added to the
  header (checked in Europe PMC).
- Belt knee ghost: `.seen(0.6)` -> `.seen(-2.3)` (from behind); the frontal
  views put the trolley's plates and sleeve in front of the left knee and
  both ankles (re-checked with a ray test that interpolates depth across
  each triangle). Table comment and Views line rewritten.
- Belt cable, depth and heel ghosts: `.seen(-0.5)` -> `.seen(-0.7)` (total
  -1.5), clear of the front upright that hid one knee at -1.3.
- Belt annotations: cable -> thigh_R, depth -> pelvis, same rows, so the two
  leaders on row 0.48 diverge instead of crossing; redrawn over the stills.
- Pendulum depth mistake: "the knees pushed far forward" (no longer "over
  the toes", which clashed with the "Knees over toes" label). The label
  itself is kept: "Knees track toes" was drawn at row 0.74 and grazed the
  shin twice as much at mid-descent.
- Belt depth intro: "the thighs still somewhat above parallel" (~20° above).
- Belt cable: correct line and setup step 3 line the ankles up with where
  the cable runs down between the feet (not with the clip, ~15 cm ahead at
  the top); why says "runs down" not "runs straight down"; header and model
  paragraph record the ~12° slant; Joseph 2020's attachment-point
  instruction noted as its pivoting-lever machine's.
- Model notes: pendulum and V-Squat knees sit ~6 cm / ~4 cm inside the
  ankles at the bottom; the knee ghost reads as a further cave from there.

## Change log (reframe to -1.5)

- Belt Squat re-framed from yaw -0.8 to -1.5 (zoom 0.767, offset (0.004,
  -0.034, -0.061)): side-on from the lifter's left, facing screen-left, the
  upright, handles and plates ahead on the left. At -0.8 the trolley's
  plates and sleeve and the front-right upright hid the knees and feet.
  probe.py, joints.json, the brief and the stills were re-run upstream. This
  supersedes the belt framing in "Shared facts", the "Belt Squat occlusion"
  model note, the belt "Views" line and the belt bullet under "Labels".
- Annotations: hands hand_R -> hand_L and heel foot_R -> foot_L (the near
  side, in view all rep); cable thigh_R -> foot_R (side-on the right ankle
  sits behind the left one where the cable drops through the deck, so the
  dot lands on the cable just above the deck; the hip joints and pelvis now
  project to one point, so the old anchor would have shared the depth dot);
  knee (patella_L) and depth (pelvis) kept. Rows: hands leading 0.26
  (squeezed 0.267; at 0.32 the pill covered the top of the head in the
  bottom hold), knee leading 0.68 (0.64, level with the knee at the
  bottom), depth trailing 0.50 (0.48), cable trailing 0.72 (0.676; at 0.68
  it came within a few pixels of the glutes at the bottom), foot trailing
  0.86 (0.80, on the deck's front face below the shoes). Drawn with gen.py
  widths at the exactly projected joints over the start, mid-descent,
  bottom and second-rep stills: every pill on machinery, background or deck,
  none over the body or face, leaders 0.07-0.26 of the screen width, none
  crossing.
- Glows: the activation glow now covers the near thigh only (thigh_L and
  patella_L over the bottom samples, rx 0.13, ry 0.05, centre (0.524,
  0.603)), the soft glute glow pelvis and thigh_L (rx 0.06, ry 0.05, nudged
  0.03 back, centre (0.668, 0.571), opacity 0.26 kept); both sit on the
  model's quadriceps and glutes in the bottom still.
- Ghosts: cable, depth and heel drop `.seen(-0.7)` (the framing is now the
  side-on view they turned to); knee `.seen(-2.3)` -> `.seen(-1.6)`, still a
  total of -3.1, from behind. Ray test (the review-2 script with the new
  framing) at 0.5-2.5 s: at -1.5 both knees, both ankles and the pelvis are
  clear (only the belt covers the right hip joint); at -3.1 both knees and
  both ankles are clear; at -2.8 and -3.4 the belt's webbing covers one knee
  in the bottom hold; face-on (+1.3, +1.6) the plates cover one or both
  knees and ankles. Python port of `FaultGhost.solve` at the new views, in
  the bottom hold: feet ahead of the cable moves the feet ~0.08 of the
  screen width toward the upright (the toes stay on the deck); `shallow`
  lifts the hips ~0.13; heels up drives the knee ~0.07 forward and up; the
  knees cave ~0.06 each across the screen from behind. Moments unchanged
  (bottom).
- Copy (cues, setup, activation, comparison) unchanged; none of it depends
  on the view.
