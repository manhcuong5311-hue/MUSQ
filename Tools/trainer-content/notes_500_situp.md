# 401-500 folder, round 2: sit-ups and V-ups (2026-10-04)

Six lying core lifts from the builder's 415-444 exports: 426 Sit-Up (`Abs/SitUp`), 427 Weighted
Sit-Up (`Abs/WeightedSitUp`), 428 Decline Sit-Up (`Abs/DeclineSitUp`), 429 Weighted Decline Sit-Up
(`Abs/WeightedDeclineSitUp`), 443 V-Up (`Abs/VUp`) and 444 Alternating V-Up (`Abs/AlternatingVUp`).
`spec_500_situp.py` holds the copy and setup steps (its header lists what each model shows and the
full citations), `Tools/fault-review/faults_500_situp.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_situp.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The arm and leg briefs (`SCRATCH/briefs2/<Resource>.md`, `SCRATCH/briefs2_legs/<Resource>.md`),
  `tiers2.txt`, `joints.json` and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`). The briefs'
  trunk lean and rep phases were written for upright lifts, so everything below was measured again.
- The rigs from the USD with Blender's Python + pxr (`SCRATCH/situp/`): `rig.py` (joint world
  transforms per frame, mesh points of the `HG_*` equipment), `measure.py` (trunk angle above the
  floor, hip, knee and elbow angles, leg angles, pelvis, neck and shoulder-blade heights every
  1/24 s, into `m_<Resource>.json`), `detail.py` (spine bends at the spine, chest and neck joints;
  the hands, fingertips and elbows in the head's own axes), `plate.py` (the plate's centre, size and
  facing against the chest and hands), `bench.py` (the decline pad's top surface, fitted from its
  vertices; the roller; heights above the pad), `vup.py` (fingertips against the shins, ankles and
  balls of the feet; which hand reaches which foot; the shoulder line's turn). The rep phases come
  from the trunk angle (within 1° of its lowest = flat, of its highest = top).
- Sources: Europe PMC REST records (abstracts; Kim 2016 full text) via `SCRATCH/situp/epmc.py`
  (`abs1.txt`-`abs3.txt`, `kim2016.xml`); ExRx through the Wayback Machine (`SCRATCH/situp/exrx/`,
  text pulled with `txt.py` / `t2.py`); Rogue's and StrengthLog's pages through the Wayback Machine
  (`SCRATCH/situp/web/`); Catalyst Athletics live (WebFetch, 2026-10-04).
- Labels: `preview_500.py situp`, then `SCRATCH/situp/score.py` (pills against the dark body and
  the teal mat or pad in the five stills, and against the body lifted as the mistake view lifts it;
  leaders over the body; leaders through other pills; leaders crossing each other further than
  22 pt from their joints), `search.py` (a local search over rows, sides and alternative joints)
  and `evalay.py` (draws a layout over the stills), then the lab shots.
- Ghosts: `SCRATCH/situp/ghostport.py` (the round-1 Python port of `FaultGhost.solve`),
  `pieces.py` / `final.py` (this family's faults with their strengths), `gh.py` (sizes in cm and in
  mistake-view points, knee angles and bend side, drawn to `draw.json` and `render.py`) and
  `sweep.py` (every fault over the whole clip: strength range and the lowest ghost joint against
  the floor), then the lab shots.

## Shared facts about the models

- One body. Torso (neck to pelvis joint) 0.579 m lying flat, 0.55-0.56 m while curled.
- Every clip is 7.96 s with two identical 4 s reps (the alternating version's second rep uses the
  other leg): flat to ~0.3 s, rising 0.29-1.17 s (~0.9 s), held at the top 1.21-2.12 s (~0.9 s),
  lowering 2.17-3.25 s (~1.1 s), flat again 3.29-4.25 s (~1 s). The copy's timings ("hold for about
  a second", "take about a second to lower", "lower at about the speed you rose", "pause") describe
  that. The V-ups hold 1.17-2.17 s and rest 3.25-4.29 s.
- Paint (`tiers2.json`), all six: RectusAbdominis and Sartorius bright, ExternalOblique and
  InternalOblique dim. The rig paints the hip flexors on the Sartorius mesh, so that row is "Hip
  Flexors", a legend-only name (shown, not counted for recovery), as the library's Abs content does.
  Bright = PRIMARY: "Rectus Abdominis" and "Hip Flexors"; dim = SECONDARY: "Obliques". All names pass
  `validate()` (abs, legend-only, abs). The primary legend line is RECTUS ABDOMINIS · HIP FLEXORS
  (33 characters), within the ~43 the one-line legend shows.
- Framings: the four sit-ups and the V-Up at yaw -1.35 (side-on from the front-left, the feet to
  the left of the screen, the head to the right lying), the Alternating V-Up at -0.8 (three-quarter).

## Activation

No EMG study measured any of these six exactly as the models do them. Every fraction is a
judgement call anchored on the library's lifts (Crunch: rectus abdominis 0.80, obliques 0.45;
Decline Crunch: rectus abdominis 0.84; Reverse Crunch: hip flexors 0.42; Hanging Leg Raise: rectus
abdominis 0.84, hip flexors 0.86), ordered by the studies below; each is also explained in a code
comment.

- Sit-Up: Rectus Abdominis 0.76, Hip Flexors 0.72 (both PRIMARY), Obliques 0.50 (SECONDARY).
  Escamilla 2006 (JOSPT, abstract): upper and lower rectus abdominis activity was greatest for the
  Ab Slide, Torso Track, crunch and Ab Roller (the bent-knee sit-up not among them); external and
  internal oblique activity greatest for the Ab Slide, Torso Track, crunch and bent-knee sit-up;
  rectus femoris greatest for the bent-knee sit-up and four machines (SAM, Ab Twister, Ab Rocker, Ab
  Doer). So the rectus abdominis sits a little under the Crunch's 0.80; the obliques a little over its
  0.45 is a judgement (the study puts the crunch and the bent-knee sit-up in the same top group). Juker 1998 (abstract): all
  forms of sit-ups activated psoas at 15-35% MVC, the curl-up under 10%; Escamilla 2006 (Phys Ther,
  abstract): rectus femoris activity among the highest in the bent-knee sit-up. The hip flexors stay
  under the Hanging Leg Raise's 0.86 because the feet are free: fixing them raised rectus femoris
  activity (Parfrey 2008; Burden 2013).
- Weighted Sit-Up: 0.82 / 0.76 / 0.54 - each row a little higher for the plate (Monfort-Panego 2009,
  review abstract: added loads or inclined planes increase contraction intensity significantly).
- Decline Sit-Up: 0.82 / 0.84 / 0.52. The ankles are hooked: Andersson 1997 (abstract) found flexed,
  supported legs raised hip flexor activation in hip-flexion sit-ups without generally changing the
  abdominals'; Parfrey 2008 and Burden 2013 the same for the rectus femoris with fixed feet. The
  slope adds intensity (Monfort-Panego 2009; ExRx: the board version is harder than the flat one).
  The library's Decline Crunch has rectus abdominis 0.84.
- Weighted Decline Sit-Up: 0.86 / 0.86 / 0.56, the Decline Sit-Up's plus the plate.
- V-Up: Rectus Abdominis 0.84, Hip Flexors 0.88, Obliques 0.55. Straight legs lifted from the hip as
  in the Hanging Leg Raise (0.84 / 0.86), plus the trunk; Andersson 1997: bilateral leg lifts
  required the abdominals and they worked in both trunk- and hip-flexion sit-ups.
- Alternating V-Up: 0.78 / 0.76 / 0.50. Andersson 1997: unilateral leg lifts did not require the
  abdominals; Rogue lists the single-leg V-up as the easier version. The obliques stay at the
  Sit-Up's 0.50 although the shoulders turn ~10° toward the lifted leg (a judgement).
- Stabilisers: transverse abdominis on all six (the library's core lifts list it); neck flexors where
  the head is held off the mat by the curl (the library's Crunch); rectus femoris (ExRx lists it as a
  sit-up synergist; it is part of the quadriceps and is the hip flexor the EMG studies measured, so it
  is named separately from the Sartorius-painted "Hip Flexors" row); tibialis anterior on the decline
  pair (ExRx's stabiliser with the feet hooked); forearm flexors where the hands grip the plate;
  quadriceps (straight knees) and anterior deltoid (the reach) on the V-ups.

## Sit-Up

Model facts: knees 84-85° all rep, feet flat ~0.30 m apart and never moving, nothing over them (the
only equipment is `HG_Mat`). The hands rest beside the head (wrist joints ~14 cm out from the head
joint, level with it), the middle fingertips ~15 cm up the back of the head and 3-6 cm behind it,
the elbows (39-41°) pointing forward and out (~20 cm forward of the head, ~32 cm out); the hands do
not move against the head all rep. Lying, the trunk is 5° below level, hips 150°; at the top 81°
above the floor (9° short of upright), hips 62°, trunk-to-thigh 59°.
The rise starts as a curl: at 0.5 s the shoulder-blade joints are 12.6 cm higher than lying
(0.063 -> 0.189 m) while the trunk line is only 11° up; the bend at the chest joint grows from 5° to
19-21° during the rise (15° at the top) and at the neck from 3° to 8-11°. The pelvis joint drops
3.6 cm at the top as the pelvis rolls back.

| Claim | Source |
|---|---|
| Hands beside the ears, fingertips behind the head, elbows out; they stay there | The model |
| Pulling bends the neck rather than the trunk; ExRx warns throwing the body up with the hands behind the head can jerk the head forward harder than the neck is used to | ExRx Arm Position During Waist Exercises: "the chance of neck injury may be increased when the exerciser places the hands higher behind the head and attempts to throw the body upward, jerking the head forward with greater force than to which the neck is accustomed"; "Don't confuse neck movement for movement through the waist" |
| A review of abdominal exercise studies lists not pulling with the hands behind the head among its safety rules | Monfort-Panego 2009 abstract: safety criteria "(b) do not pull with the hands behind the head" |
| Gap between chin and chest | ExRx Sit-up comment (space between chin and sternum); the library's Crunch |
| A sit-up begins as a trunk curl (neck and upper back, then the lower back), then the hips | Cordo 2003 abstract (trunk curling: neck and upper trunk flexion, then lumbar trunk lifting; then footward pelvic rotation); the model (the shoulder blades up 12.6 cm with the trunk 11° up) |
| A sit-up done as a trunk curl drew more rectus abdominis and external oblique activity on average, and less rectus femoris, than the Army's hip-led sit-up, which may arch the lower back | Sullivan 2015 abstract (18 trained men; mean EMG and iEMG of RA and EO greater in the modified, trunk-flexion sit-up; mean and maximum RF greater, and maximum EO greater, in the traditional U.S. Army sit-up; "may result in lumbar hyperextension"). "On average" because the maximum EO went the other way |
| Hooking the feet gives the hip flexors something to pull against; in one study fixing the feet lowered abdominal activity and raised rectus femoris activity, in another restrained feet also raised rectus femoris activity | Andersson 1997 (supported legs raised hip flexor activation); Parfrey 2008 (foot fixation: lower activation at all abdominal sites, higher RF); Burden 2013 (feet-restrained sit-ups and curl-ups: higher RF than unrestrained curl-ups). Only Parfrey supports the abdominal half: Burden's curl-ups with the feet restrained drew the highest abdominal iEMG, so the copy names one study for it (review) |
| Feet flat and free, hip-width, knees about 90° | The model (84-85°, 0.30 m); StrengthLog (knees about 90°; StrengthLog anchors the feet, the model does not, and the copy follows the model) |
| Every form of sit-up worked the psoas at 15-35% of maximum, the curl-up under 10% | Juker 1998 abstract |
| Sit up until nearly upright; hold about a second | The model (81°, 0.9 s); StrengthLog ("Bend as far forward as possible") |
| If the upper back never comes all the way down, the abs may only hold a position | ExRx Sit-up comment ("If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise") |
| Pause on the mat between reps | The model (~1 s flat) |

Comparison (HEAVING FROM THE HIPS): Sullivan 2015 as above.

## Weighted Sit-Up

Model facts: as the Sit-Up (same mat, legs, timing), holding a 30 cm plate (4.8 cm thick) flat on
the upper chest, its centre ~25 cm out from the chest joint and ~15-17 cm toward the head from it
(the upper chest), its face along the chest (normal 0.98-1.0 along the body's forward axis); the left
hand over its top edge, the right hand under its bottom edge (each ~14 cm from the centre), elbows
77° / 83°; the plate is fixed in the chest joint's frame all rep. The trunk rises to 76° (14° short of
upright), hips 68°.

| Claim | Source |
|---|---|
| A load higher up the body is harder; a plate held high behind the head is harder than the same plate on the lower chest | ExRx Arm Position During Waist Exercises ("More challenging positions can be achieved by placing the arms higher on the body"; the shift moves the centre of gravity further from the fulcrum, or articulating joint; "placing the added weight higher behind the head (where far less weight would be required) would be more challenging than placing the weight on the lower chest") |
| Holding a weight against the chest adds load to a sit-up | StrengthLog Sit-Up ("You can increase the load by holding a weight against your chest") |
| Pushing the plate toward the knees shortens its leverage on the hips and swings it up | Reasoning from ExRx's lever explanation and momentum; no study. The model (verification): the ghost's push (hands 17 cm out of the chest, 6 cm toward the hips) puts the plate ~5 cm further from the hip joints in a straight line, but moves it 4 cm (lying) to 16-18 cm (from mid-rise on) further toward the feet horizontally, which shortens the lever its weight resists the rise with; so the copy says leverage, not closer to the hips |
| A neutral neck with space between chin and breastbone, the plate on the upper chest just below the neck | ExRx Arm Position ("keep their neck in a neutral position so the added weight can be placed on the upper chest, just below the neck"); ExRx Sit-up (space between chin and sternum) |
| Do not mistake moving the neck for moving the waist | ExRx Arm Position ("Don't confuse neck movement for movement through the waist") |
| The lumbar lift is the moment of peak muscle activity and least stability | Cordo 2003 abstract (phase II, lumbar trunk lifting: "the point of peak muscle contraction and maximum postural instability") |
| The abs only shorten if the waist actually bends | ExRx Weighted Decline Sit-up / Roman Chair Sit-up ("Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs") |
| In one EMG study fixed feet lowered the abdominals' activity and raised the rectus femoris'; free feet leave more of the lift to the abs | Parfrey 2008 only (Burden 2013 found the opposite for the abdominals, see the Sit-Up) |
| Return until the upper back rests on the mat; ExRx's weighted sit-up carries the same note as its plain one | ExRx Sit-up and Weighted Sit-up ("Return until back of shoulders contact with floor or mat"; both pages carry the isometric comment, "If upper back does not come completely down ...") |
| Setup: a light plate, one hand over its top edge and one under its bottom edge | The model; "light" is a judgement (the 30 cm plate is a small one; no weight is stated) |

ExRx's Weighted Sit-up holds the plate behind the neck with the feet hooked; the model holds it on
the upper chest with the feet free, and the copy follows the model (ExRx's own tip names the upper
chest as the neck-friendly place).

## Decline Sit-Up

Model facts: the bench pad (`HG_DeclinePad`) is ~1.6 m long (1.56 m from end to end on the floor plan) and 42 cm wide, its top 0.31 m up at the
head end and 0.78 m at the high end, a 17.1° slope (a straight-line fit through the highest pad
vertex in 12 slices along its length: y = 0.307 z + 0.557). The ankle roller (`HG_AnkleRoller`,
10 cm across, 52 cm wide) sits at the high end 0.81-0.91 m up; the ankle joints are just under it
(0.77 m) with the toes beyond it, so the roller lies over the fronts of the ankles. Knees 73-74°, the
seat on the pad (the pelvis joint 16 cm above the pad's plane lying, 9 cm at the top as the pelvis
rolls). Lying along the pad the trunk is 22° below level (5° off the pad's line), the head below the
hips; at the top 85.6° above the floor (103° from the bench), hips 35°, trunk-to-thigh 30°: 108° of
trunk travel against 86° on the floor. Hands and arms as the Sit-Up (elbows 39-41°).

| Claim | Source |
|---|---|
| A shallow decline, about 15 to 20 degrees, head end low | The model (17°); "shallow" against ExRx's "higher incline" option |
| The roller stops you sliding down; with the legs supported, hip-led sit-ups raised hip flexor activity while the abdominals' stayed about the same, and fixing the feet raised rectus femoris activity in other studies | Andersson 1997 abstract ("flexed and supported legs increased hip flexor activation, whereas such modifications did not generally alter the activation level of the abdominals"); Parfrey 2008; Burden 2013 |
| Hook the fronts of the ankles under the roller, knees bent | The model; ExRx Incline Sit-up ("Hook feet under support ... with hips bent") |
| Pulling bends the neck, not the trunk; the review's safety rule | ExRx Arm Position; Monfort-Panego 2009 |
| ExRx files its decline sit-up under the hip flexors; unless the waist bends, the abs only hold the pelvis and waist still | ExRx Weighted Decline Sit-up (HipFlexors/WtDeclineSitup: target Iliopsoas; "With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion") |
| On ExRx's head-down board you return until the backs of the shoulders touch it; if the upper back stops short the abs may only hold a position | ExRx Incline Sit-up ("Return until back of shoulders contact incline board"; the isometric comment, which says may). The copy names the head-down board, not ExRx's decline sit-up, whose return is to hips almost extended |
| The return takes the trunk below level | The model (22° below) |
| In a small EMG study of slow sit-ups the lower rectus abdominis worked harder lowering than raising | Kim 2016 full text, Table 1 (20 students; 3 s up, 3 s down, ankles held, arms crossed: lower rectus abdominis 34.1 vs 27.9% MVIC, significant; upper 31.6 vs 28.5, not significant), so the copy names only the lower part |
| Lower in about a second, at about the speed you rose | The model (~1.1 s down, ~0.9 s up) |
| Gravity pulls the trunk down the slope | Mechanics |

Comparison (PULLING ON THE ROLLER): the mistake note says only that dragging on the roller makes the
lift a hip flexor pull. The draft added that the abs do less of the lift; the closest evidence is
mixed (Andersson 1997: supported legs did not generally alter the abdominals; Parfrey 2008: fixed
feet lowered them; Burden 2013: restrained curl-ups drew the most), so that half was cut
(verification).

ExRx calls this head-down board an "incline board" (Incline Sit-up, RectusAbdominis/BWInclineSitUp)
and its easier option is "lowering incline, performing movement on horizontal surface", i.e. the
slope makes it harder.

## Weighted Decline Sit-Up

Model facts: the same bench, roller, legs and timing; a 25 cm plate (4.8 cm thick) held flat on the
upper chest as the Weighted Sit-Up (left hand on the top edge, right on the bottom; elbows 76° / 80°;
the plate centre ~25-28 cm out from the chest joint and 17-21 cm toward the head). The trunk rises
to 65° above the floor (82° from the bench), hips 57°: well short of upright, unlike the unweighted
decline.

| Claim | Source |
|---|---|
| ExRx shows the weight held in front of the chest for this lift | ExRx Weighted Decline Sit-up ("Hold weight in front of chest (as shown) or behind neck or use no weight") |
| The higher up the body a load sits, the harder | ExRx Arm Position ("placing the arms higher on the body") |
| The plate drifting toward the knees shortens its leverage on the hips as you rise and turns the start into a swing | Reasoning, as the Weighted Sit-Up. The model: the same push moves the plate 4-18 cm further toward the feet horizontally from ~0.5 s on, but not at the very bottom (trunk 22° below level, where it moves ~1 cm the other way), hence as you rise |
| Chin space, the plate below the neck; tucking bends the neck, not the waist | ExRx Arm Position; ExRx Sit-up |
| Supported or fixed feet raised hip flexor activity, and in one study lowered abdominal activity | Andersson 1997; Parfrey 2008 |
| Strong abs and flexible hip flexors matter before decline sit-ups | ExRx Dangerous Exercise essay ("Flexible hip flexors and strong abdominal muscles are particularly important before performing the Decline Situp") |
| The abs only shorten if the waist bends | ExRx Weighted Decline Sit-up |
| ExRx's sit-up on a head-down board returns until the backs of the shoulders touch the board; the abs may only hold a position if the upper back stops short | ExRx Incline Sit-up ("Return until back of shoulders contact incline board"; the isometric comment). ExRx's own Weighted Decline Sit-up lowers "until hips are almost extended", so the copy names the head-down board (verification; the draft said ExRx returns each rep there) |

The model stops ~25° short of upright (ExRx: "Raise body by flexing hips until torso is upright");
the copy never asks for upright here and describes the curl, the plate and the return instead.

## V-Up

Model facts: flat on the mat, legs straight (180°) with the ankles 0.27 m apart, arms straight
(174°) overhead on the mat, the hands ~0.61 m apart (the shoulder joints 0.39 m). From ~0.3 s the
trunk and legs rise together (both 20° at 0.67 s, 40° at 0.83 s, 55° at 1.0 s) to 62° each above the
floor (hips 57°) by 1.17 s; the arms swing forward from overhead (shoulder 177° -> 89°) and each
hand's middle fingertip ends ~4 cm from its own ankle (left to left, right to right), ~14 cm short of
the ball of the foot. Balanced on the seat (the pelvis joint 3 cm lower). Held to 2.17 s, lowered
together to 3.25 s, then the arms and legs rest on the mat to ~4.3 s.

| Claim | Source |
|---|---|
| The V-up: a sit-up and a straight-leg raise done together, hands to the feet, balanced on the seat with a pause | Catalyst Athletics V-Up ("Simultaneously perform a sit-up and lift your straight legs, reaching the hands up to touch the toes"; "pause when the hands and feet meet and hold this position"); Rogue V-Ups ("combination of a hollow body position + sit-up + leg raise"; "Simultaneously lift legs and torso"; "Try and be balanced on the glutes") |
| Bent knees: Catalyst's jack knife (knees and elbows meeting) and Rogue's easier tuck-up | Catalyst ("can be performed by bending the knees and with the hands on the head, bringing the knees and elbows together, making the exercise a jack knife"); Rogue regressions ("Tuck-Up, instead of straight legs, bend knees to chest") |
| Straight legs make the long lever | Mechanics, as the library's Hanging Leg Raise |
| Reach to the ankles, each hand to its own ankle | The model (Catalyst and Rogue reach for the toes; the model stops ~14 cm short, at the ankles, and the copy follows the model) |
| Avoid arching the lower back or slamming down | Rogue ("Avoid arching your lower back or slamming down") |
| Press the lower back gently into the mat (setup) | Rogue ("Press lower back into the floor and contract your abdominals, creating a hollow shape") |
| Arms and legs touch down between reps | The model (~1 s flat). Catalyst keeps the heels off the floor between reps; the copy follows the model and does not claim either way is better |

## Alternating V-Up

Model facts: the V-Up's start, trunk path (62°) and timing, one leg at a time: rep 1 (0-4 s) the LEFT
leg rises to 62° while the right stays straight on the mat (its hip angle only follows the trunk,
121° at the top); both hands reach the left ankle (fingertips ~6 cm from it) and the shoulder line
turns ~10° toward it (the right shoulder comes forward). Rep 2 (4-8 s) mirrors it with the right leg
and both hands to the right ankle. Knees 180° throughout.

| Claim | Source |
|---|---|
| The single-leg V-up, the other leg kept on the ground, is an easier step toward the full V-up | Rogue V-Ups regressions ("Single-Leg V-Up, alternate one leg at a time while keeping the other on the ground") |
| In an EMG study of leg lifts, lifting both legs needed the abdominals and lifting one did not (the abstract does not say the lifts were done lying, so the copy no longer says lying) | Andersson 1997 abstract ("Bilateral, but not unilateral, leg lifts required activation of abdominal muscles") |
| Left first, then right; switch every rep; both hands to the lifted ankle; the trunk turns slightly toward it | The model |
| Bent-knee tuck-up as the easier version | Rogue |
| Arching / slamming down | Rogue |
| Comparison: keeping the resting leg down makes each rep a single-leg V-up, one leg lifted at a time | Rogue; the model. The draft said one leg's hip flexors work at a time, but the resting hip flexes too as the trunk rises (169° -> 121°), so the copy now says one leg lifted (verification) |
| The hands reach that ankle, as in the full V-up, which Rogue and Catalyst finish with the hands at the feet | The model (fingertips ~6 cm from the lifted ankle); Rogue ("Reach arms up and forward toward toes"), Catalyst ("reaching the hands up to touch the toes"). The draft said the hands meet the foot |

## Distinct from the library

The library's Crunch stops when the shoulder blades clear the floor and keeps the hip flexors out
of it ("Sitting all the way up ... turns the second half into a hip-flexor exercise"); the Sit-Up
here is that full sit-up, which is why the hip flexors are painted bright and its copy says what
coming all the way up adds (Juker 1998) rather than calling it a mistake. The Decline Crunch curls
only the upper back on its bench; the decline pair sit all the way up (86° unweighted, 65° with the
plate). The Reverse Crunch and Hanging Leg Raise move the legs with the trunk still; the V-ups raise
both. No cue sentence repeats word for word between the six or with the library's Crunch, Decline
Crunch, Reverse Crunch or Hanging Leg Raise (checked by script).

## Library rows

The rows went in with the models (RECTUS ABDOMINIS on all six; BODYWEIGHT for the Sit-Up and both
V-ups, PLATE for the weighted pair, BENCH for the Decline Sit-Up; difficulty beginner / intermediate /
intermediate / advanced / advanced / intermediate). They fit the models and sources: Rogue calls the
single-leg V-up the easier version (intermediate under the V-Up's advanced) and the V-up "a step up
from the sit-up". The Weighted Decline Sit-Up uses both a plate and a bench; PLATE is kept.

## Labels

Rows below are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`). Lying,
the head, hands and shoulder blades are all on the right of the screen; at the top they are in the
middle and the hands and head sit up-left of the shoulder blades, so any two leaders from the same
side to the head region cross in one of the two positions. Each layout therefore keeps one label
per side pointing at the head region and sends the others to joints that keep their left-right order
in both positions.

- Sit-Up: top (Sit up tall, pause) 0.20 left to the head; neck (Hands at the ears) 0.28 right to
  `hand_L` (at 0.36 in round 1 the rising head touched it at 0.8 s, a moment the reference stills
  did not cover); bottom (Shoulders down) 0.70 right to `scapula_L` (a short leader up from below the
  mat lying; at the top it runs up the back); feet 0.72 left to `foot_L`; curl (Curl up first) 0.80
  right to the lumbar `spine`, the joint its ghost moves. "Shoulders to the mat" was cut to
  "Shoulders down" so the curl leader clears its pill.
- Weighted Sit-Up: chin 0.24 right to the head; plate 0.28 left to `hand_L` (from the right its
  leader ran through the head at the top; at 0.36 the pushed-out ghost hands sat on its pill in the
  plate fault); bottom 0.70 and curl 0.80 right; feet 0.72 left.
- Decline Sit-Up: the bench fills the lower left and the lower right, so all five sit above the body.
  Right: curl (Curl up first) 0.20 and tempo (Lower slowly) 0.27 to `neck`, neck (No pulling) 0.34 to
  `hand_L` (at 0.44 in round 1 the head touched its pill at 0.8 s); left: bottom (Shoulders down)
  0.28 to `scapula_R`, roller (Ankles hooked) 0.36 to `toe_L`. At the top the three right-hand
  leaders meet at the head; the two from the right to `neck` and `hand_L` cross within ~20 pt of it.
- Weighted Decline Sit-Up: right: curl 0.24 to `neck`, chin (Chin up) 0.34 to the head; left: bottom
  0.20 to `scapula_R`, plate (Plate close) 0.30 to the `chest` (the hands sit up-left of the shoulder
  blades at the top and their leaders crossed every alternative; the longer Plate on the chest sat on
  the pushed-out ghost hands in round 1), roller 0.40 to `toe_L`.
- V-Up: together (Lift legs and trunk) 0.28 left to `toe_L`; reach 0.32 right to `hand_L`; back
  (No arch coming down) 0.68 right to `spine`; legs (Knees straight) 0.72 left to `shin_L`; balance
  (Balance on the seat) 0.80 left to the pelvis.
- Alternating V-Up: reach (Hands to that ankle) 0.16 right to `hand_L`; down (One leg at a time)
  0.30 left to `foot_R` (`foot_L` in the draft: on the right-leg rep its leader crossed the lifted right
  leg; the right foot is on the mat in rep 1 and up in rep 2, a short leader both times); knees 0.72 left to `patella_L`; trunk (Chest comes up too) 0.72 right to
  the chest; back 0.80 left to `spine`. The working leg alternates, and the alternating rig is not in
  probe.py's `ALTERNATING` set (and `_front`/`_back` would not pick the lifted leg of a lying lifter
  anyway), so every label is worded to hold for both legs: Knees straight (both stay straight), One
  leg at a time (the right foot is down in rep 1 and up in rep 2).

## Ghosts and when to still them

Measured with the port at each fault's moment (the `curlup` kind: top = trunk and thighs closest,
bottom = furthest, in the first 4 s; seconds where those are the wrong moment). `sweep.py` runs every
fault over the whole clip; with the strengths below no ghost joint goes below the mat on the floor
lifts or into the bench on the decline pair, and no knee bends backward.

- Strengths: the sit-up ghosts that only make sense up (or down) are gated by the neck-to-left-knee
  distance in torso lengths (`situp500Top` / `situp500Low`): ~1.7 lying on all four; 0.95 (Sit-Up),
  1.02 (Weighted), 0.58 (Decline), 0.88 (Weighted Decline) at the top. The V-ups' by the left hand's
  distance from the pelvis (`situp500Risen`, 1.87 lying, 1.1-1.3 from the start of the rise, the same
  on both alternating reps); the alternating version's leg ghosts by the neck-to-left-ankle distance
  (`situp500LeftLegUp`, 1.26 at the left-leg top, 2.2-2.5 lying and all through the right-leg rep), so
  they show on the first rep only. Without these, the stopped-short, rolled-back, arms-up and
  knees-bent ghosts would put limbs through the mat lying down.
- Sit-Up: neck `situp500HeadYanked(45)` (the library's `headYanked` at 45° instead of 35°: at 35° the
  head moved ~9 pt; top); curl `situp500BackArched` at 0.3 s, as the rise starts (the lumbar joint
  ~11 cm, 20 pt, and the chest ~6 cm up with the pelvis and shoulders down, a hump; built from three
  turns so every segment keeps its length. The draft used the library's `lowerBackArched(0.22)`,
  which shifts the joints: ~13 cm at the still, but it shrank the lumbar segment 11.4 -> 8.3 cm
  whenever the trunk was partly curled during playback; see Review). Rounds 1-2 drew a stiff whole trunk lifted
  ~9-12 cm at 0.5 / 0.42 s, which stayed inside the body's outline and read poorly; feet
  `situp500FeetUp("*", 20)` at 0.8 s with `situp500Top(1.4)` (the ankles ~20 cm, 36 pt, the toes
  ~27 cm, 50 pt, off the mat; the draft's `situp500Top(1.1)` gave only half of that at 0.8 s); top
  `situp500StoppedShort(35)` (81° -> 46°); bottom `situp500Hovering(25)` (the head ~42 pt up).
- Weighted Sit-Up: plate `situp500PlatePushed(forward: 0.3, down: 0.1)` (hands ~18 cm, ~31 pt toward
  the knees, elbows opening to 129-147°; top); chin `situp500ChinDown(40)` with the crown
  (`head.tip`) in the chain, since the head joint alone moved ~9 pt (the crown ~25 pt); curl, feet,
  bottom as the Sit-Up.
- Decline Sit-Up: neck, curl, bottom as the Sit-Up. Weighted Decline: plate, chin, curl, bottom as the
  Weighted Sit-Up. The roller and tempo cues have no ghost.
- V-Up: legs `situp500KneesBent("*", 60)` (the feet ~50 pt toward the seat; the shank turns toward the
  back of the thigh, checked on the port's drawing); reach `situp500ArmsUp(55)` (the hands ~65 pt);
  together `situp500LegsDown(38)` at 0.85 s (the legs 40° -> 2° while the trunk is ~45° up); balance
  `situp500RolledBack(25)` (trunk 62° -> 37°, legs 62° -> 87°; drawn as the trunk and legs since round
  2, the turned arms crowded it); back `situp500BackArched` at 2.95 s as the legs come down (the
  lumbar joint ~11 cm off the mat; the library's `lowerBackArched` at 0.14 at 2.8 s barely showed
  in round 1), gated by `situp500Lowered` so it
  does not read as a sway back at the top.
- Alternating V-Up (all at the left-leg top, 1.58 s, except back at 2.95 s): knees
  `situp500KneesBent("L", 60)`; down `situp500FeetUp("R", 25)` (the resting right foot ~36 cm up);
  reach as the V-Up; trunk `situp500StoppedShort(35, withArms: false)` (the trunk and shoulder line:
  with the arms it crowded the lifted leg in round 1), seen side-on (`.seen(-0.55)`, the V-Up's
  -1.35) since review; back as the V-Up.

## Uncertain

- No EMG study of these six exact lifts; every fraction is a judgement call.
- Juker 1998 had 8 subjects and intramuscular electrodes; Kim 2016 used surface electrodes on 20
  students (the copy names it a small study and quotes only the significant lower-rectus result);
  Andersson 1997 had 6 subjects (the copy says "an EMG study"); Sullivan 2015's modified sit-up is
  described only as focusing on trunk flexion in the abstract.
- Catalyst Athletics and Rogue are coaching sources, not studies; the copy attributes them.
- ExRx was read through Internet Archive copies (the live site blocks automated fetches).

## Change log

- 2026-10-04, draft: copy, setup, labels (scored and searched over the stills), ghosts (port, sweep)
  and moments for all six; `spec_500.py situp` OK.
- Lab round 1 (`lab500.sh shoot situp "0,0.8,1.6,5.6"`; stills at rest, mid-rise, the top and the
  alternating version's right-leg top): BUILD SUCCEEDED on the first build. Labels clear in all but
  two places, both at the 0.8 s mid-rise: the Sit-Up's Hands at the ears and the Decline Sit-Up's No
  pulling touched the rising head (moved up). Fault views: the Weighted Decline's plate pill sat on
  the pushed-out ghost hands (shorter label), the Weighted Sit-Up's plate pill nearly did (moved up);
  the curl ghosts and the V-ups' back ghosts were too faint, the V-Up balance and alternating trunk
  ghosts crowded (arms dropped from their lines). Shots in `SCRATCH/situp/round1/`.
- Lab round 2: the labels fixed; the curl ghost (a stiff trunk lifted ~12 cm at 0.42 s) still read
  as a line inside the body, so all four sit-ups now draw the library's lumbar arch at 0.3 s and the
  V-ups' back ghost moved to 2.95 s. Copy: the four curl mistakes lead with the arch the ghost shows;
  the Sit-Up's top no longer says the chest is over the thighs (at 81° it is over the hips); the
  decline curl's ExRx line no longer says ExRx's sit-up is done with a straight waist; the V-Up's
  "Lock the legs out softly" became "Keep the knees straight". Shots in `SCRATCH/situp/round2/`.
- Lab round 3 (final): BUILD SUCCEEDED; all 24 trainer stills (0, 0.8, 1.6 and 5.6 s for each
  exercise) show every pill off the lifter and the bench, and all 27 ghosts render attached, each
  showing its mistake: the lumbar-arch hump now reads on the four sit-ups and both V-ups, the plate
  pills clear the pushed-out ghost hands. Left as they are: at the top of the Decline Sit-Up the two
  right-hand leaders to the neck and hands cross within ~20 pt of the head; the bottom (Shoulders
  down / Back to the mat) leaders of the floor sit-ups run up the back at the top of the rep, since
  the shoulder blade is behind the trunk there. Final shots in `SCRATCH/lab/situp/` (copied to
  `SCRATCH/situp/round3/`).
- Independent review (2026-10-05): see Review below. Lab `lab500.sh shoot situp "0,0.8,1.6,5.6"`:
  BUILD SUCCEEDED, 24 trainer stills and 27 ghosts; shots in `SCRATCH/lab/situp/` (copied to
  `SCRATCH/situp/review/after/`; the author's round-3 shots in `review/before/`).
- Final verification (2026-10-05): text and comment fixes only, see Verification below;
  `spec_500.py situp` OK. No label, cue id, tracked joint, ghost or moment changed, so the review's
  lab output stands.

## Review (independent, 2026-10-05)

Two passes, sources then fidelity to the models; scripts and evidence in `SCRATCH/situp/review/`.

Sources. All twelve studies re-read on Europe PMC (`review/epmc_all.txt`; Kim 2016's full text
re-fetched: 20 students, knees 100°, arms crossed, ankles held, 3 s up / 3 s down; lower rectus
27.9 vs 34.1% MVIC, significant, upper 28.5 vs 31.6, not). Authors, journals, volumes, pages, DOIs and
PMIDs all correct. ExRx re-fetched from the Wayback Machine (BWSitUp and BWInclineSitUp 2026-02-12,
WtSitUp 2026-02-06, HipFlexors/WtDeclineSitup 2023-12-13, BWRomanChairSitup 2025-06-16, Tips
2025-10-29, DangerousExercises 2025-06-07; `review/src/`), StrengthLog's Sit-Up (2026-02-21), Rogue's
V-Ups (2025-10-18) and Catalyst's V-Up (live); each says what the tables above quote. Fixed:
- Free feet (Sit-Up, Weighted Sit-Up): "In EMG studies, fixing the feet lowered abdominal activity"
  rested on Parfrey 2008 alone; Burden 2013's curl-ups with the feet restrained drew the highest
  abdominal EMG. The copy now gives one study for the abdominal drop and the other only for the
  rectus femoris rise; the Weighted Sit-Up says the rectus femoris rather than the hip flexors.
- Decline bottom: "ExRx sets the decline sit-up to return until the backs of the shoulders touch
  the board" quoted ExRx's Incline Sit-up (its head-down board); ExRx's decline sit-up lowers until
  the hips are almost extended. Now names the head-down board. Both decline bottom cues now keep
  ExRx's may (the abs may only hold a position), as the floor ones did.
- Weighted Sit-Up plate: ExRx compares the plate high behind the head with the lower chest; one on
  the chest became the same plate on the lower chest.
- Decline roller: without raising the abdominals' became while the abdominals' stayed about the same
  (Andersson: did not generally alter). Alternating V-Up: lying leg lifts became leg lifts (the
  abstract does not say how the lifts were done), and the trunk cue no longer repeats the down cue.
- Sit-Up comparison: heaving from the hips arches the lower back became can arch (Sullivan: may
  result in lumbar hyperextension).
- The Decline Sit-Up's tempo mistake repeated the library Decline Crunch's word for word; reworded
  (a script finds no sentence shared with any spec, spec_500 family or SampleData).
- Header: the Roman Chair Sit-up and Tips snapshot dates were wrong (2026-07-17 and 2026-02-12 are
  the hip flexor list and the Sit-up page); corrected, the missing dates added, and the study lines
  give subjects and Andersson's did not generally.
Activation checked against the paint (RectusAbdominis and Sartorius bright, the obliques dim, on all
six) and the levels; every list is a labelled judgement call. Unchanged.

Model fidelity. The rigs re-measured (`review/check.py`, `bench2.py`): trunk -5 -> 81° (Sit-Up), 76°
(Weighted), -22 -> 85.6° (Decline), 64.6° (Weighted Decline), 62° (both V-ups); knees 84-85° / 73-74°
/ 180°; feet never move on the floor sit-ups; elbows 39-41° (hands by the head) or 76-83° (plate);
the pad 17.0°, its top 0.31 -> 0.78 m (~1.6 m long, not 1.53: corrected), the roller 0.81-0.91 m
over the ankles; Alternating: left leg 0-4 s with both hands to the left ankle, right leg 4-8 s, the
resting leg -3° on the mat. Fixed:
- V-Up reach mistake said the shoulders stay low; the ghost only turns the arms up. Now: stopping
  with the arms pointing at the ceiling, short of the ankles. Alternating trunk mistake said the
  chest stays near the mat; the ghost's trunk is at 27°. Now: the chest lags well behind the leg.
- Ghosts, checked over the whole clip with the round-1 port (`review/rv_ghosts.py`: every drawn
  segment's length, the knee and elbow bend planes in `elbows.py`, joints and tips against the mat
  and the pad in `tips.py`). The curl and V-up back ghosts (the library's `lowerBackArched` at 0.22)
  stretched the spine segments 0.7-1.3 cm at the still and shrank the lumbar segment by up to 3.1 cm
  (11.4 -> 8.3) whenever the trunk was partly curled during playback; narrower gates still left
  2.4-2.9 cm. They now use `situp500BackArched`, three turns (the lumbar segment -60° about the
  pelvis, the upper back +80° about the lumbar joint, the neck and head -10° about the chest): the
  same hump (lumbar joint ~11 cm, 20 pt; chest ~6 cm) with every length kept.
- The Sit-Up and Weighted Sit-Up feet ghosts were at half strength at their 0.8 s still
  (`situp500Top(1.1)` gave 0.51), the feet ~10 cm (19 pt) up, not the ~20 cm the comment said; now
  `situp500Top(1.4)`, full from 0.8 s (ankles ~20 cm, 36 pt), none lying.
- The Alternating V-Up trunk ghost sat inside the body's outline at the three-quarter framing; now
  `.seen(-0.55)`, side-on like the V-Up. 35° kept: 40° put the chest ~2 cm below its lying height as
  the trunk comes down on the right-leg rep.
- Label: Alternating One leg at a time now tracks `foot_R`; to `foot_L` its leader crossed the lifted
  right leg on the right-leg rep (scored with the author's `score.py`; 116 -> 106).
- Comments: the Sit-Up neck and top ghost sizes corrected (hands ~15 pt, elbows ~26 pt; the head
  ~39 cm back, not lower).
Checked and kept: no knee or elbow bends against its real bend anywhere in any clip; no ghost joint
or tip goes under the mat or into the pad; left/right, alternation and moments match the clip.
Left as they are (no better layout found by the scorer): the Weighted Decline's Plate close leader
passes behind the thighs while lying (the chest joint sits behind them; to the hands it crossed the
other leaders); the Decline Sit-Up's three right-hand leaders meet at the head at the top. The new
shots show the arch hump, the full feet lift and the side-on trunk ghost reading as intended.

## Verification (final skeptic, 2026-10-05)

Every claim and number in the copy, setup steps, activation comments and the source tables above was
checked again against sources fetched afresh (`SCRATCH/situp/skeptic/`: the twelve Europe PMC
records with authors, journal, volume, pages, DOI and PMID, Kim 2016's full text and Table 1; ExRx
BWSitUp, BWInclineSitUp, WtSitUp, HipFlexors/WtDeclineSitup, BWRomanChairSitup, Tips, the Dangerous
Exercise essay and the hip flexor list from the Wayback Machine; Rogue, StrengthLog and Catalyst)
and against the rigs (`skeptic/v1.py`: trunk, hip, knee and elbow angles, foot motion, hand and
ankle spacing, top and flat spans; the plate against the chest joint and the hip joints; the pad
slope and roller; the alternating version's legs, hands and shoulder turn; ghost sizes with the
round-1 port in `skeptic/gsz.py`). Refuted or overstated, and fixed:
- Plate toward the knees "brings it closer to the hips" (Weighted Sit-Up plate cue and comparison,
  Weighted Decline plate cue and comparison): measured, the ghost's push puts the plate ~5 cm
  further from the hip joints in a straight line; what it shortens is the horizontal lever its weight
  resists the rise with (by 4-18 cm; on the decline not at the very bottom). The copy now says it
  shortens the plate's leverage on the hips (as you rise, on the decline), and ExRx's rule is given
  as ExRx states it: a load higher up the body is harder.
- Weighted Decline bottom: "ExRx returns each rep until the backs of the shoulders touch the board"
  read as ExRx's instruction for this lift; ExRx's Weighted Decline Sit-up lowers until the hips are
  almost extended. Now names ExRx's sit-up on a head-down board, as the Decline Sit-Up does.
- Weighted Sit-Up bottom: "what ExRx notes for every sit-up" became ExRx's weighted sit-up carries
  the same note as its plain one (the note is on the Sit-up, Weighted Sit-up and Incline Sit-up pages).
- Weighted Decline plate: "ExRx holds the weight in front of the chest" became shows (ExRx offers in
  front of the chest, behind the neck or no weight).
- Decline Sit-Up comparison: "and the abs do less of the lift" cut (the evidence is mixed, above).
- Alternating V-Up comparison: "one leg's hip flexors working at a time" became one leg lifted at a
  time (the resting hip flexes 169° -> 121° as the trunk rises). Reach: "The hands meet the foot"
  became the hands reach that ankle (fingertips ~6 cm from it). Knees: Rogue's tuck-up is "an"
  easier version (Rogue lists three regressions), not "the".
- V-Up balance mistake: "the legs tipping over toward the head" became tipping back (the ghost's legs
  reach 87°, not past vertical).
- Comments: Escamilla 2006 JOSPT's groups are "among the highest", not "highest" (header and Sit-Up
  activation); the Sit-Up obliques at 0.50 over the Crunch's 0.45 are marked a judgement (the study
  puts both in one group); the notes said rectus femoris was greatest for the sit-up and three
  machines (four: SAM, Ab Twister, Ab Rocker, Ab Doer); Monfort-Panego's rule is avoid active hip
  flexion and fixed feet, not hip flexion with fixed feet; Catalyst's jack knife is bent knees with
  the hands on the head; the plate is fixed in the chest joint's frame (not "moves under 4 cm"); the
  Sit-Up fingertips are 3-6 cm behind the head joint; the Alternating V-Up trunk ghost moves the
  head ~40 cm (39.6 by the port), not ~50.
Confirmed as written: the study numbers and populations (Juker 8 subjects, psoas 15-35% vs under
10%; Andersson 6 men, 38 exercises; Sullivan 18 trained men, mean RA and EO higher in the
trunk-flexion sit-up, RF higher in the Army sit-up, may result in lumbar hyperextension; Parfrey 14,
foot fixation lowered all abdominal sites and raised RF; Burden 23, restrained feet raised RF; Cordo
phases and the critical point; Kim 20 students, 3 s / 3 s, lower RA 34.1 vs 27.9% MVIC, upper not
significant); every ExRx, Rogue, Catalyst and StrengthLog quote; the library anchors (Crunch 0.80 /
0.45, Decline Crunch 0.84, Reverse Crunch hip flexors 0.42, Hanging Leg Raise 0.84 / 0.86 with
straight legs); the model facts (trunk -5 -> 81°, 76°, -22 -> 85.6°, 64.6°, 62°; knees 84-85°,
73-74°, 180°; elbows 39-41°, 76-83°, 174°; feet still on the floor and decline lifts; ankles 0.30 /
0.26 / 0.27 m apart against hip joints 0.18 m; the pad 17.1°, 0.31 -> 0.78 m, ~1.6 m; the ankle
joints under the roller; the plates 30 and 25 cm, left hand on the top edge, right on the bottom;
V-Up hands 0.61 m apart, fingertips ~4 cm from their own ankles; Alternating left leg 0-4 s, right
4-8 s, the resting leg on the mat, both hands to the lifted ankle, the shoulders turned ~10° toward
it) and the other ghost sizes in the table comments.
Still judgement calls: every activation fraction (no EMG study of these six lifts); the swing in the
plate cues (momentum reasoning); a light plate in the setup.
