# 401-500 folder: seated and reclined calf raises (2026-10-04)

Six exercises from the builder's 401-500 set: 412 Calf Press Machine, 413 Horizontal Leg Press
Calf Raise, 408 Barbell Seated Calf Raise, 409 Dumbbell Seated Calf Raise, 410 Single-Leg Seated
Calf Raise and 407 Smith Machine Seated Calf Raise (models `Legs/<Resource>.usdc`).
`spec_500_calfseat.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_calfseat.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_calfseat.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The leg briefs (`SCRATCH/briefs_legs/<Resource>.md`), the trainer stills
  (`SCRATCH/stills/<slug>_t{0,1,2,3,5}.png`), `tiers30.json` and `joints.json`.
- The rigs straight from the USD with Blender's Python + pxr (`SCRATCH/calfseat/`): `rig.py`
  dumps every joint every frame (position and bone axis) and every equipment mesh's bounds at
  0, 1.2, 2.6 and 3.6 s; `eqmove.py` lists what moves; `ang.py` prints knee, hip and ankle angles
  (ankle = shin to foot bone; also shin to the toe joint); `eqpts.py` and `shoes.py` give world
  points of the footplates and of the skinned shoes and thighs, to measure where the heels sit
  against the block or plate and where the load rests on the thighs.
- `tiers.py` was also run on the library's Seated Calf Raise, Leg Press Calf Raise and Standing
  Calf Raise models (`SCRATCH/calfseat/tiers_lib.json`) to see what their content was matched to:
  Seated soleus bright and gastrocnemius faint; Leg Press all three bright; Standing the
  gastrocnemius bright and the soleus faint.
- Labels: `preview_500.py calfseat`, then `SCRATCH/calfseat/pills.py` draws gen.py's layout (pills
  at (24 + 5.6 x chars) / 382 wide and 28 pt tall, leaders to the probed joint at each sample,
  the glows at 0.7 of their radius, the eye button and legend boxes) over the five stills.
- Ghosts: `SCRATCH/calfseat/ghost.py` is a Python port of `FaultGhost.solve` (body frame,
  shift / turn / straighten / resolve, strengths, tips) plus the trainer projection (probe.py's
  `proj`, the fault's `view`, and the `roomBelow` 0.26 shrink and lift while a mistake shows); it
  reproduces `joints.json` exactly at view 0, room 0. It measured every ghost's moves in cm and pt.

## Shared facts about the models

- One body (torso 0.592 m, shin 0.40 m, thigh 0.44 m). These rigs have toe joints (`toe_L/R` at
  the ball of the foot, 0.149 m from the ankle along the foot bone).
- Neutral ankle on this rig: the Single-Leg Seated model's right foot is flat on the floor with
  the shin within 1.3 degrees of vertical and reads 109 degrees (shin to foot bone; 110.5 to the
  toe joint). Kassiano 2023 defines 0 as the foot at 90 degrees to the tibia, so ~109 is taken as
  0 here; dorsiflexion and plantar flexion below are read from it (approximate, +-2 degrees).
- Timing, the same in all six (ankle angle): bottom 0-0.08 s, up 0.12-0.88 s (~0.8 s), held at
  the top 0.92-2.12 s (~1.2 s), down 2.17-3.29/3.33 s (~1.2 s), held at the bottom to 4.08 s
  (~0.7 s), then the second rep. The tempo cues ("in under a second, hold the top for about a
  second, a little longer letting it back, pause briefly in the stretch") describe that. The
  library's calf raises lower over ~1.7 s; these models lower only ~1.5x as long as they rise, so
  the copy says "a little longer", not "about two seconds".
- **All six sink the heels below the block or plate at the bottom.** Measured on the skinned
  shoes: on the two machines the shoe touches the plate's face just above its lower edge and the
  heel hangs ~4.4 cm past the face (about 12 degrees below the plate's line); on the seated four
  the front of the shoe rests on the 10 cm block's back edge (sole 10.3 cm up) and the heel drops
  to 5.6 cm, ~4.5 cm below the block top (about 13 degrees). So, unlike the library's five calf
  raises (which stop level or short of flat; notes_legs30_calf.md), the bottom cues here ask for
  the stretch and the model shows it.
- Paint (`tiers30.json`): GastrocnemiusLateral, GastrocnemiusMedial and Soleus bright on all six;
  BicepsFemoris, Semimembranosus and Semitendinosus dim on the Calf Press Machine and the
  Horizontal Leg Press Calf Raise; nothing else lit. All row names pass `part_of()` (calves,
  hamstrings).

## Activation: the paint against the knee-angle evidence

- House rule (README, "Exercises 1-150 redone"): bright = PRIMARY, dim = SECONDARY.
- Machines (knees 168 degrees, nearly straight): Gastrocnemius PRIMARY 0.86, Soleus PRIMARY 0.66,
  the library's knee-straight values (Standing and Leg Press Calf Raise use 0.86 / 0.66; the Leg
  Press Calf Raise lists the soleus as secondary although its model paints it bright, which the
  house rule would now make primary). Evidence for the order: Signorile 2002 (medial gastrocnemius
  above the soleus at 180 degrees; the lateral head no different from the soleus), Price 2003 (knee straight: gastrocnemius active on MRI, no
  soleus change at 25% 1RM), Cresswell 1995 (the gastrocnemius gives at least 40% of the torque
  with the leg straight); ExRx Sled 45 Calf Press, Lever 45 Calf Press and Sled Seated Calf Press:
  target gastrocnemius, synergist soleus. The soleus still works substantially with the knee
  straight (Gentil 2020: ~51% of its own peak in a 10RM standing calf raise, like both
  gastrocnemius heads), hence high in the moderate band. The exact fractions are judgements.
- Hamstrings SECONDARY 0.20 LOW on the two machines: painted dim. No study measured the
  hamstrings in a calf press or leg press calf raise, and none of the sources lists them (ExRx: no
  significant stabilisers). They cross the back of the knee with the gastrocnemius and sit long in
  these seats (hips 89-116 degrees, knees 168). A judgement call from the paint; the copy makes
  no claim about them.
- Seated four (knees 85-93 degrees): Soleus PRIMARY 0.86 (the library's Seated Calf Raise value)
  and Gastrocnemius PRIMARY 0.40. The gastrocnemius is painted bright, so it is primary under the
  house rule, but every source says the bent knee shifts the work to the soleus: Signorile 2002
  (the soleus best targeted at 90 degrees), Price 2003 (knee at 90: only the soleus showed on MRI
  at 25% 1RM), Cresswell 1995 (gastrocnemius EMG fell with knee flexion at the same effort while
  the soleus held), Arampatzis 2006 (medial gastrocnemius EMG fell at pronounced knee flexion
  despite no change in its fascicle length), Kinoshita 2023 (12 weeks seated: gastrocnemius
  volume +0.6-1.7% vs +9.2-12.4% standing; soleus similar), ExRx (Smith, safety bar and lever
  seated: predominantly soleus, "Gastrocnemius are in active insufficiency since knees are
  significantly bent"), StrengthLog (mostly the soleus, the gastrocnemius shortened). The library
  Seated Calf Raise (gastrocnemius painted faint) puts it at 0.30 SECONDARY. Here it is 0.40, the
  lowest moderate value: the floor the library uses for a muscle painted bright that the EMG ranks
  low (the 351-400 Frog Pump's gluteus medius, 0.40 PRIMARY against Moore 2020's pooled 18.8%
  MVIC; checked in notes_400_hip.md and SampleData). The evidence alone would put it near 0.30;
  0.40 honours the paint without ranking it near the soleus.
- **Said plainly: the PRIMARY rank of the seated gastrocnemius is the paint's, not the
  evidence's.** No source read says it works hard with the knee at ~90 degrees. The nearest thing
  to support for any real share is Signorile 2002 (the lateral head no different from the soleus
  at any of 90, 135 and 180 degrees); against it, Price 2003 (no significant gastrocnemius change
  on MRI at 90 degrees, 25% 1RM) and Kinoshita 2023 (no significant gastrocnemius growth after 12
  weeks seated, p = 0.147-0.508). In the app the row reads MODERATE (0.40), under the soleus's
  HIGH (0.86). The copy never ranks the two together: the knee cue says the gastrocnemius is
  shortened and "does less" and that the soleus does most of the work, and the barbell and
  Smith comparisons say the same (not "adds little", the library seated copy's words, which would sit oddly beside a
  primary row). Nothing in the cue, setup or comparison copy says the gastrocnemius works hard
  with the knee bent.
- Stabilisers: tibialis posterior, peroneals, toe flexors (Akuzawa 2017: tibialis posterior,
  peroneus longus and flexor digitorum longus active in heel raises), as the library's calf
  raises; "forearms" added on the two dumbbell raises (gripping the dumbbells).

## Calf Press Machine

Model: GYM_M14, a plate-loaded 45 degree calf press sled: back pad (y 0.39-0.99 m), seat pan, a
footplate with a rubber face on a carriage running up two 45 degree rails (rails y 0.71-1.64 m),
two plates on horns each side of the carriage. What moves: the whole sled (footplate, rubber,
horns, plates, struts) 7.5 cm up and 7.5 cm forward (10.6 cm along the rails); the seat and pad
are still. Trunk 51 degrees back from vertical on the pad; hips 94 -> 89 degrees (the legs pivot
~5 degrees at the hip as the plate goes out); knees 168 degrees throughout; hands on handles beside
the seat (x +-0.22-0.38, elbows 118). Balls of the feet on the plate's lower edge (shoe contact
just above the edge), ankles 0.18 m apart (the hip joints are 0.18 m apart), feet straight. Ankle
85 -> 141 degrees (~24 dorsiflexed to ~32 plantar flexed); heels ~4.4 cm past the plate face at
the bottom, ~12 cm off it at the top. No safety stops or release lever are modelled.

| Claim | Source |
|---|---|
| Top: push through the balls of the feet until the ankles are fully pointed, hold about a second | ExRx Sled / Lever 45 Calf Press ("Push sled by extending ankles as far as possible"); PureGym ("Pause at the top"); the model holds the top ~1.2 s |
| "The calves move the plate by pointing the ankles"; holding takes each rep to the end of that range | Anatomy (plantar flexion); the hold is described as reaching the top, not as a growth claim (as the library) |
| Bottom: let the heels sink below the plate, calves stretched, pause | ExRx ("Return by bending ankles until calves are stretched"); PureGym ("Lower your heels below the plate to gently stretch your calves"); the model (heels 4.4 cm past the face, ~0.7 s at the bottom) |
| An eight-week study on a horizontal leg press: training only the range below a flat foot grew the gastrocnemius more than only the range above, at least as much as the full range | Kassiano 2023 (initial ROM -25 to 0 degrees: medial +15.2% vs full +6.7% vs final +3.4%; lateral +14.9% vs final +6.2%, vs full +7.3% not significant, hence "at least as much"); the model's bottom (~24 degrees dorsiflexed) reaches the study's lower range |
| Knees: hold one slight bend; with the knees nearly straight the gastrocnemius stays long and shares the work with the soleus; bending lets the plate sink and the thighs push it back, part of the rep becomes a leg press | ExRx ("Keep knees straight throughout exercise or bend knees slightly only during stretch. Quadriceps serve as synergist muscle if knees are bent slightly during stretch"); Signorile 2002, Price 2003 (knee straight); the leg press part is mechanics, as in the library's Leg Press Calf Raise |
| Lock: "The usual guidance for this lift is a slight bend rather than locked knees"; holding it keeps the knees from snapping straight, or past straight | PureGym ("Keep a slight bend in your knees throughout the movement (don't lock your knees out)"); StrengthLog, Calf Raise in Leg Press, read 2026-10-04 ("Extend your legs without over-extending your knees"), for the past-straight half; the model holds 168 degrees. ExRx says knees straight; the copy and the model say just short of straight, as the library. (A NASM page the first draft leaned on, via a search snippet, no longer says this and is not used.) |
| Arms relaxed on the handles | PureGym ("Keep your arms relaxed"); the model's hands rest on the handles, elbows still |
| Tempo: dropping fast and bouncing lets the Achilles tendon stretch and spring back; fibres nearly the same length while the tendon stored and returned energy | Kawakami 2002 (counter-movement plantar flexion: gastrocnemius fascicles almost isometric, the tendon storing and releasing energy); "keep the work on the calf muscles" is the coaching inference, as the library |
| Comparison: the stretched range grew the gastrocnemius more than the upper range in a leg press calf study | Kassiano 2023 (initial vs final range, both heads) |
| Setup: back flat on the pad, hands on the handles, balls of the feet on the lower edge, hip-width, heels off; press out until the knees are nearly straight; release the catches if the machine has them | ExRx (sit with the back on the pad, grasp handles to the sides, toes and balls of the feet on the lower portion of the platform, heels and arches off); PureGym (45 degree machines: press the plate off the safety bars, keep a slight bend); the model (no catches modelled, hence "if the machine has them") |

How it differs from the library Leg Press Calf Raise (45 degree sled too): that model is a full leg
press, knees 170, ankle 108 -> 148 on the old rig, the heels ~9 degrees short of flat; this is a
compact calf sled, knees 168, and the heels go well below the plate.

## Horizontal Leg Press Calf Raise

Model: GYM_M16, a selectorised seated leg press: seat pan (y 0.35-0.38), back pad (to y 1.2 m),
head pad, a vertical footplate (face z 0.63) on a carriage on two level rails (y 0.28-0.32),
cabled to a weight stack on the lifter's right (x -0.9). What moves: the carriage, plate and rubber
10.2 cm along the rails (away from the lifter), the stack's top plates 10.7 cm up, the cable. Trunk
31 degrees back on the pad; hips 116 -> 111; legs about level (thighs 5-10 degrees above
horizontal); knees 168 throughout; hands on handles beside the seat (elbows 113). Balls of the feet
on the plate's lower edge (plate bottom y 0.71, shoe contact y 0.70-0.76), heels below it, ankles
0.18 m apart. Ankle 88 -> 144 (~21 dorsiflexed to ~35 plantar flexed); heels ~4.4 cm past the face
at the bottom, ~10.5 cm off it at the top.

| Claim | Source |
|---|---|
| Top, bottom, lock, tempo | As the Calf Press Machine; ExRx Sled Seated Calf Press (the same instructions on a seated leg press); PureGym (both machine types) |
| Bottom: "an eight-week study of calf raises on this kind of machine, a horizontal leg press" | Kassiano 2023 (pin-loaded horizontal leg press) |
| Seat: set so the knees are just short of straight; too close leaves the knees bent, shortening the gastrocnemius and letting the thighs push; too far back and the stack can touch down before the heels reach the stretch | ExRx Sled Seated Calf Press ("Place seat away from platform"; "Position seat back yet not so far that weight bottoms out during stretch"; quadriceps synergist if the knees bend); PureGym (seated machines: "adjust the seat so your knees are slightly bent when the plate is at rest"); Signorile 2002, Cresswell 1995 (the gastrocnemius shortened and less active with the knee bent) |
| Comparison SEAT TOO CLOSE | The same sources |
| Setup | PureGym (back against the support, balls of the feet on the bottom edge, seat so the knees are slightly bent with the plate at rest, arms relaxed); the model |

## The seated four (shared)

Model facts (identical leg motion in the Barbell, Dumbbell and Smith models; the single-leg model's
left leg differs only by a few degrees): flat bench (pad top 0.42 m), a 10 cm toe block (z
0.57-0.79) under the balls of the feet, heels off; trunk upright (4 degrees forward); knees 85-89
degrees, shins vertical (knee within 1-8 cm of over the ankle), thighs level at the bottom (hip and
knee joints both 0.53 m up); the knees rise ~9.5 cm as the heels go up (hip 87 -> 72 degrees);
ankles 0.21 m apart, feet straight; ankle 94 -> 157 (~15 dorsiflexed to ~48 plantar flexed).
Odd but harmless: the pelvis sinks 1.3 cm at the top in the two-leg models.

| Claim | Source |
|---|---|
| Knees at about a right angle, shins upright; the gastrocnemius shortened and doing less, its activity falling while the soleus holds, so the soleus does most of the work; feet far out open the knees and hand more of it back to the gastrocnemius | Cresswell 1995, Arampatzis 2006 (EMG), Price 2003 (MRI), Signorile 2002 (the soleus best at 90, the medial gastrocnemius at 180); ExRx and StrengthLog for "shortened" (active insufficiency); "hands more back" follows from the same studies (gastrocnemius activity higher as the knee straightens) |
| Balls of the feet on the block directly under the knees, thighs about level | The model; ExRx Smith Seated Calf Raise ("adjust height of bench or calf block so thigh is close to horizontal"); Fitbod (knees at roughly 90 degrees) |
| Top: rise as high as the ankles allow, hold about a second | ExRx seated pages ("Raise heels by extending ankles as high as possible"); Fitbod (hold at the top); the model (~1.2 s) |
| Bottom: the heels sink below the top of the block; "a study of straight-knee calf raises" found the range below flat grew the gastrocnemius more than the range above; it measured only the gastrocnemius, so it does not show the same for the soleus; sinking below the block adds the stretched part of the range | Kassiano 2023 (horizontal leg press, knee straight, gastrocnemius ultrasound only); ExRx ("Lower heels by bending ankles until calves are stretched"); Fitbod ("allow your heels to drop below the plate"); the model (heels ~4.5 cm below the block top). No seated or soleus range-of-motion study was found, as the library notes |
| Tempo | Kawakami 2002, as above; the model's timing |
| Comparisons | ROCKING THE TRUNK and the barbell trunk cue: mechanics (the load rests on the thighs, so leaning back while gripping it lifts it with the trunk and arms), as the library's Seated Calf Raise (coaching convention, no study); HEELS STAYING HIGH and STOPPING SHORT: range descriptions, no growth claim; FEET TOO FAR OUT: the knee-angle studies above |

### Barbell Seated Calf Raise

The barbell's 42 cm pad (HG_LapCushion) rests on the lower thighs ~8 cm behind the knee joints
(pad underside 0.636 m, thigh top 0.641 m); hands 0.60 m apart just outside the pad, elbows
108 -> 91; two plates each side; the bar rises 5.7 cm. No ExRx page covers a free barbell seated
calf raise; the Safety Bar Seated Calf Raise (lower thighs under the bar, the soleus comment) and
the Smith page (bar pad round the middle) are the nearest. Setup: the model; "rest a padded
barbell across your lower thighs, just above the knees" (ExRx: lower thighs under the bar).
Library row SOLEUS / BARBELL / intermediate fits (the bar has to be set on the thighs).

### Dumbbell Seated Calf Raise

A dumbbell stood on end on each lower thigh ~6 cm behind the knee joint (the lower end resting on
the thigh: shaft bottom 0.638 m, thigh top 0.641 m; 0.695 vs 0.694-0.704 m at the top), the hands
round the handles between the heads, elbows 88 -> 78; the dumbbells rise 5.7 cm.

| Claim | Source |
|---|---|
| The dumbbells stand on the lower thighs just above the knees; the hands only steady them | Fitbod, Seated Dumbbell Calf Raise ("Position the dumbbells near the end of your thighs, but not on your knees"); the model |
| "Load the calves through the shins"; lifting them with the arms takes that weight off the calves | Mechanics (the thigh rests on the shin at the knee; whatever the arms hold up the calves do not lift); a coaching convention, the free-weight counterpart of the library's "hauling on the handles" |

### Single-Leg Seated Calf Raise

The LEFT leg works both reps; the toe block (x 0.02-0.32) is under the left foot only; the right
foot rests flat on the floor beside it (right knee 101 degrees, still); the dumbbell (left) stands
on the left lower thigh, the left hand round it (elbow 90 -> 82); the right hand rests on the right
thigh (elbow 111, still). Left knee 92-93, ankle 94 -> 156; the pelvis sits 3 cm higher than in the
two-leg models. Fitbod's Seated Dumbbell One-Leg Calf Raise: one foot on the plate with the heel
off, "Position the dumbbell near the end of your leg, but not on your knee", the heel dropping
below the plate. The "switch legs after the set" step is convention (the model shows the left only).
`fault_times.py`'s calf kind reads the left ankle, which is the working one, so no seconds are
needed in the moments file.

### Smith Machine Seated Calf Raise

The Smith bar (GYM_M30) with a 42 cm pad round its middle rests on the lower thighs as the
barbell; hands 0.60 m apart outside the pad (elbows 108 -> 93); the bar rises 5.7 cm on the guide
rods; safety stops at 0.29-0.35 m, well below the bar. Setup from ExRx Smith Seated Calf Raise:
bar "slightly higher than lower leg height" (here "just above knee height"), "Wrap bar pad around
center of bar", calf block under the bar, bench near it, sit facing the bar with the toes on the
block, "extend ankles to raise knees so lower thighs are under padded bar", "Disengage bar by
rotating bar back", safety stops can support the bar at its lowest. The knee cue's correct text
(bench and block set so the thighs are about level) is ExRx's comment. The arms cue ("hands"):
"runs on its guides" is the model (the bar rides the guide rods); "whatever the arms pull up, the
calves do not have to lift" is mechanics and coaching convention, the Smith counterpart of the
library Seated Calf Raise's handle cue; "sit tall" in its correct text stands in for the barbell's
trunk cue.

## Labels

Rows are final (on-screen) rows; `ov()` converts them to the pre-squeeze rows spec_500.py expects.
Checked with `pills.py` on all five stills of each: no pill on the lifter or on moving equipment
(sleds, plates, carriages, bars, dumbbells), no leaders crossing each other, top rows clear of the
eye button (bottom 0.128), bottom rows clear of the legend (0.88).

- Calf Press: everything sits in the open band above the reclined body; the two foot labels top
  left (0.16) and top right (0.24) with leaders down-left to the feet (the right one always below
  the left one); the knee labels on the right at 0.32 (far knee) and 0.40 (near knee), above the
  head (head top ~0.44), the higher one's leader always above the other's; tempo bottom right over
  the static base frame. The 0.32 row's earlier left-side position covered the moving weight plate.
  Review (2026-10-04): all three right-hand leaders cross the sled from above, but none crosses the
  lifter except where it meets its knee or foot. Since gen.py pins pills to the screen edges, there
  is no cleaner arrangement: from below, a foot leader would cross the calves and a knee leader the
  underside of the knee; two foot labels on one side put one leader through the other's pill (both
  orders checked); the knee labels cannot come lower on the right (the head). The one change: the
  top cue now tracks the far toes (`toe_R`) and the heel cue the near ankle (`foot_L`); with the near
  toes and the far ankle the heel leader ran through the toe dot at the bottom of each rep, now it
  passes ~12 pt below it.
- Horizontal: top left over the stack column (static), leader down to the toes; lock (far knee)
  and seat (near knee) top right at 0.24 and 0.32, above the head pad; the heel label bottom left
  over the static rails, below the moving carriage; tempo bottom right.
- Barbell: the trunk label short ("Sit tall, still", 15 characters) so its pill ends right of the
  head and its leader drops to the left shoulder; tempo top left above the left plate, to the right
  hand on the bar (the bar carries the load up and down); "Knees at 90°" short, left of the far
  shin below the plate, to the far knee, at 0.62 (review: at 0.60 the knee ghost's far toe tip,
  ~15 cm further out and drawn at ~0.58 in the fault view, touched the pill's top edge; 0.62 keeps
  ~12 pt from it and ~14 pt above the near shoe in the trainer view); the foot labels share the
  bottom row, one each side, each leader to the foot on its own side.
- Dumbbell: the dumbbell label top left, its leader down to the near hand, left of the face; "Knees
  at 90°" left of the shins at 0.56 to the far knee; tempo over the bench legs to the hips; the foot
  labels at 0.83 below the shoes (the near foot from the right, the far foot from the left).
- Single-Leg: as the dumbbell; the knee label at 0.48, short ("Knee at 90°"), ending left of the
  dumbbell's lower head; tempo at 0.66 over the bench pad; the heel label at 0.76 right, its leader
  under the calf to the left ankle; the top label at 0.83 left over the block to the left toes.
- Smith (zoomed in, yaw -0.4, little free space): tempo top left, its leader down to the far
  shoulder, left of the head; the hands label short ("Light grip", 10 characters; a 12-character one touched the near hip on the
  simulator) right of the near hip below the bar, its leader straight up across the bar to the left hand; the knee cue labelled "Feet under knees" (16 characters, so it clears the near calf) over the static
  bench legs to the near ankle (a knee anchor would need a leader across the near thigh); the heel
  label bottom left to the far ankle, the top label bottom right to the near toes, both at 0.83.
  At 0.83 the left pill's top edge just touches the far shoe's sole in the trainer view; the review
  tried 0.85, but in the fault view the mistake sheet then hides the lower half of the pill (the
  sheet starts ~4 pt under a 0.83 pill), and no other row or side helps (any pill on the left
  spans the far toes, and a heel pill on the right would need its leader across the near foot), so
  0.83 stays.

Glows: the calves between knee and ankle, nudged toward the back of the shin (from the stills),
the near calf full, the far one soft; the single-leg raise only the working left calf; on the two
machines a faint (0.18) glow under the near thigh for the dim hamstrings.

## Ghosts and when to still them

Sizes from `ghost.py` (the strength reads `calfHeelHeight`, left knee to the left foot's tip: 0.80
at the bottom and 1.03 at the top seated, 0.745 / 0.763 and 0.996 / 1.004 on the calf press /
horizontal press).

| Exercise | Cue | Ghost | Moment |
|---|---|---|---|
| Calf Press | top | toes 28 degrees back toward the shins (ankle 141 -> ~113, about halfway up the 85-141 range), ~10.9 cm, ~23 pt (review: 22 degrees, ~18 pt, read as barely different on the simulator) | top |
| Calf Press | bottom | toes 30 degrees further out (85 -> ~115), ~11.6 cm, ~25 pt | bottom |
| Calf Press | knees | feet ~5 cm back down the legs' line, knees 168 -> ~140 | bottom |
| Calf Press | lock | `calfSeat500KneesLocked(0.08)`: the knee onto the hip-ankle line and past it, ~10 degrees past straight, ~8 cm (~17 pt); the library's `kneesSnapped` (0.05) only moved it ~6 cm and read as no change on the stills | top |
| Horizontal | top / bottom / lock | as the calf press (top 28 degrees, ankle 144 -> ~116, ~21 pt; bottom ~22 pt) | top / bottom / top |
| Horizontal | seat | feet ~7 cm nearer the hips, knees 168 -> ~131, knee ~13 cm up (~25 pt) | top |
| Barbell | trunk | `seatedRocked(15)`: trunk 15 degrees back, head ~18 cm (~26 pt), elbows re-seated (91 -> ~124); the library Seated Calf Raise uses 12, but at this three-quarter framing 12 (head ~20 pt) read as a slight sideways tilt, so the review raised it | top |
| Smith | hands | `calfSeat500ArmsLift(withBar: true)`: hands and bar ~7 cm (~25 pt) up, elbows 93 -> ~80 | top |
| Seated four | knees | feet ~12 cm further out, knees ~89 -> ~108 (dumbbell, single-leg: ~34 pt); barbell 0.25, ~15 cm, knees ~114 (~24 pt); Smith 0.2 seen from -0.3 (yaw -0.7), ~29-32 pt (review: at the framing's -0.4 the 0.25 move read as the feet sliding down the screen; -0.3 keeps the uprights either side of the lifter, unlike the -0.5 tried before) | bottom |
| Seated four | top | heels 20 degrees lower about the toes (157 -> ~128), knees ~4.7 cm lower | top |
| Seated four | bottom | heels 28 degrees up about the toes (94 -> ~128), heels and knees ~10 cm up | bottom |
| Dumbbell, Single-Leg | hands / hand | hands ~7 cm higher along the trunk, elbows re-seated (~21 pt) | top |

The single-leg ghosts move the left leg or arm only. Simulator round 1 (2026-10-04): the Smith
feet fault turned -0.5 put the near upright and a plate over the legs, so it kept the framing and
moved further (the review then found a -0.3 turn clear of the uprights and clearer, see the table); a trunk rock read poorly on the near face-on Smith framing, so the Smith's
arm cue became the arm pull (`hands`); the two lock ghosts were too small with `kneesSnapped`. The leg press "bottom" ghost turns the toes
forward about a fixed ankle, so its toes reach past the plate's current position: the plate would
in fact stay further out; checked on the simulator stills. No "tempo" ghost (speed).

## Uncertain

- The activation fractions are judgements ranked from the knee-angle studies; no study gives
  gastrocnemius-to-soleus ratios for these exact lifts, and none measured the hamstrings in a calf
  press. The seated gastrocnemius 0.40 is set by the paint, not the evidence (which says ~0.30).
- Kassiano 2023 studied young women on a horizontal leg press; the copy names it as one study and,
  on the seated raises, says it measured only the gastrocnemius.
- The trunk and hands cues rest on mechanics and coaching convention, not on studies of those
  faults.
- ExRx was read through Internet Archive snapshots; no ExRx page covers a dumbbell or free-barbell
  seated calf raise (Fitbod is the dumbbell source).
