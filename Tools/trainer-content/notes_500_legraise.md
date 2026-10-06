# 401-500 folder, round 3: leg raises and kicks (2026-10-05)

Five exercises from the builder's 445-474 exports: 445 Toe-to-Bar (`Abs/ToeToBar`), 446 Hanging
Oblique Knee Raise (`Abs/HangingObliqueKneeRaise`), 447 Lying Leg Raise (`Abs/LyingLegRaise`), 448
Flutter Kick (`Abs/FlutterKick`) and 449 Scissor Kick (`Abs/ScissorKick`).
`spec_500_legraise.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_legraise.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_legraise.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The rigs straight from the USD with Blender's Python + pxr, scripts in
  `SCRATCH/lab/r3/legraise/` (SCRATCH = the session scratchpad): `rig.py` (every joint's world
  position and matrix every frame, and the `HG_*` equipment bounds), `m2.py` (hanging: trunk
  lean, hip, knee, elbow and shoulder angles, toes and ankles, the pelvis's and shoulder line's
  turn), `hok.py` (the oblique raise: pelvis tilt, thigh angle above level, which way the knees
  point, side bend), `m3.py` / `m4.py` (lying: trunk angle, each leg's angle above the floor and
  out to the side, ankle positions), `skin.py` (linear-blend skinning of the shoe, hand and muscle
  meshes at chosen times), `low.py` / `feet.py` (lowest points above the mat, each shoe's extent),
  and the shoes' gap to the bar. The frame: Y up, the lifter facing +z, their left +x; the mat's
  top at y 0; the pull-up bar's axis at y 2.40 m, z 0, 3.5 cm thick.
- The motion briefs (`LAB/r3/briefs/`, `briefs_legs/`), `tiers.txt` and the trainer stills at
  0/1/2/3/5 s. The briefs' rep phases and trunk lean were written for upright lifts; the hanging
  phases match the rig, the lying angles were measured again.
- Sources: Europe PMC REST records (`src/epmc.py`, `src/abs.py`; Mandroukas 2022 full text from
  PMC), ExRx through the Wayback Machine (`src/wbdirect.py`, `src/exrx/`), the other web pages
  fetched directly (`src/`).
- Labels: `preview_500.py legraise`, then `lay.py` (pills against a capsule silhouette of the
  lifter built from the rig every 2nd frame and against the bar and uprights; leader length
  inside the body; leaders crossing), `search.py` (a brute-force search over rows, sides and
  joints) and the lab shots.
- Ghosts: `ghost.py`, a Python port of `FaultGhost.solve` (its projection reproduces
  `joints.json`), `pieces.py` / `final.py` (this family's pieces and faults), `sizes.py` (sizes in
  cm and trainer-view points, knee angles) and `sweep.py` (every fault over the whole clip: lowest
  ghost point, bone lengths, knee bend direction), then the lab shots.

## Shared facts about the models

- One body (neck-to-pelvis 0.59 m hanging straight, 0.57-0.58 m at the hanging tops, 0.57 m lying),
  every clip 7.96 s at 24 fps.
- Hanging pair: `HG_PullupBar` 2.4 m up between two uprights; an overhand grip, wrist joints 53 cm
  apart against shoulder joints 39 cm apart (a little wider than the shoulders), the hands wrapped
  on the bar (the skinned hands reach its top).
- Floor three: on `HG_Mat` (1.6 x 2.4 m, top at y 0), face up, head toward -z; the arms by the
  sides (hands at the hips, palms down), the head, shoulder blades, buttocks and hands on the mat
  (lowest points 0.4-2.2 cm), the lumbar muscle surface 3.3 cm above the mat; the trunk, pelvis,
  arms and head identical in every frame. Legs straight (180), toes pointed (ankle ~140), ankle
  joints 27 cm apart against hip joints 18 cm (about hip-width) when not crossing.
- Paint (`tiers.txt`): Toe-to-Bar, RectusAbdominis and Sartorius bright, and dim the forearm
  flexors and extensors and brachioradialis, LatissimusDorsi, DeltoidPosterior, Infraspinatus,
  Supraspinatus, Subscapularis, TeresMinor, TrapeziusUpper/Middle/Lower, RhomboidMajor,
  External and InternalOblique; Hanging Oblique Knee Raise, External and InternalOblique,
  RectusAbdominis and Sartorius bright, the arm and back set (plus the biceps) only faint; Lying
  Leg Raise and Flutter Kick, RectusAbdominis and Sartorius bright, the obliques dim; Scissor Kick
  the same plus AdductorLongus, AdductorMagnus and Gracilis dim. The rig paints the hip flexors on
  the Sartorius mesh, so that row is "Hip Flexors", a legend-only name, as in the library's Abs
  content. Bright = PRIMARY, dim = SECONDARY; faint follows the calfstand family's rule (LOW
  "Forearms" and "Latissimus Dorsi" rows, the rest with the stabilisers). All names pass
  `validate()`.
- Framings: Toe-to-Bar side-on from the front-left (yaw -1.3), the oblique raise three-quarter
  (-0.5), the Lying Leg Raise side-on (-1.35), the kicks three-quarter (-0.8).

## Activation

No EMG study measured any of these five as the models do them; every fraction is a judgement call
anchored on the library (Hanging Leg Raise: hip flexors 0.86, rectus abdominis 0.84, obliques 0.62,
forearms 0.40, latissimus dorsi 0.25; Hanging Knee Raise: rectus abdominis 0.80, hip flexors 0.76,
obliques 0.64; Reverse Crunch: rectus abdominis 0.82, obliques 0.58, hip flexors 0.42; Crunch 0.80)
and ordered by the studies below. Each is also explained in a code comment.

- Toe-to-Bar: Rectus Abdominis 0.88 and Hip Flexors 0.86 PRIMARY; Obliques 0.62, Forearms 0.42
  SECONDARY (MODERATE), Latissimus Dorsi 0.35 SECONDARY (LOW). The rectus above the library's
  straight-leg raise because the feet go on to the bar with the waist flexing (ExRx Hanging
  Straight Leg-Hip Raise: the abs only contract dynamically if the waist flexes; McGill 2015: the
  hanging straight leg raise drew over 130% MVC from the rectus abdominis, the highest of the
  exercises tested). The obliques stay a dim secondary row at the library's value although McGill
  measured 88% MVC in the external oblique (the paint rule). The lats above the library's 0.25
  because the arms press the bar down here (the upper arm closes on the trunk by 39 degrees; ExRx:
  decrease shoulder flexion; Invictus: lats engaged pressing down; Escamilla 2006 Phys Ther: lat
  EMG among the highest in the hanging knee-up with straps). Stabilisers: posterior deltoid,
  rotator cuff, trapezius, rhomboids (dim, as the library's hanging raises name them for legend
  width) and quadriceps (ExRx's synergist list; the knees held nearly straight).
- Hanging Oblique Knee Raise: Obliques 0.76, Rectus Abdominis 0.74, Hip Flexors 0.72 PRIMARY;
  Forearms 0.30 and Latissimus Dorsi 0.18 SECONDARY (LOW, faint). Obliques primary because they
  are bright and ExRx's target for the twisting knee raise (Escamilla 2006 Phys Ther: both obliques
  among the highest in the hanging knee-up); the rectus and hip flexors a little under the library
  knee raise's because the knees rise only ~18 degrees above level, to one side (ExRx lists the
  rectus abdominis as a stabiliser of the twisting knee raise). Stabilisers: posterior deltoid,
  rotator cuff, trapezius, rhomboids, biceps (faint).
- Lying Leg Raise: Hip Flexors 0.84 and Rectus Abdominis 0.72 PRIMARY, Obliques 0.45 SECONDARY.
  The hip flexors move the legs (ExRx Lying Straight Leg Raise: target iliopsoas; Andersson 1997:
  bilateral leg lifts drew more iliacus and sartorius activity than hip-flexion sit-ups; Juan 2024:
  iliopsoas over 60% MVIC in leg lifts); the rectus holds the pelvis (ExRx: a stabiliser without
  waist flexion; Andersson 1997: bilateral leg lifts need the abdominals; Mandroukas 2022: more
  rectus than external oblique in leg movements from long lying), so under the curling Crunch
  (0.80) and Reverse Crunch (0.82); the obliques under the Reverse Crunch's 0.58. Stabilisers:
  transverse abdominis (the library's abs convention), quadriceps (ExRx).
- Flutter Kick: Hip Flexors 0.78, Rectus Abdominis 0.74 PRIMARY, Obliques 0.45 SECONDARY. The hip
  flexors under the leg raise's because the kicks are short (Catalyst: a low-intensity hip flexor
  exercise); the rectus a little over it (Mandroukas 2022: strong lower rectus activity in
  alternate up-and-down leg movements, more than the upper rectus and external oblique; both legs
  are off the floor all set, Andersson 1997). Stabilisers as the leg raise.
- Scissor Kick: Hip Flexors 0.78, Rectus Abdominis 0.72 PRIMARY; Obliques 0.45, Adductors 0.45
  SECONDARY (MODERATE). The adductors are dim and draw the legs across (ExRx Adductors: hip
  adduction; ExRx's scissor kick lists adductor longus and brevis as synergists). Stabilisers:
  transverse abdominis, gluteus medius (opens the legs: hip abduction, mechanics), quadriceps.
- Legends: the oblique raise's primary line OBLIQUES · RECTUS ABDOMINIS · HIP FLEXORS (41
  characters) shows in full with its rank word on the lab shots. The Toe-to-Bar's secondary line
  OBLIQUES · FOREARMS · LATISSIMUS DORSI (38, the library Hanging Leg Raise's) is drawn under the
  near upright's foot at this framing, which hides its last letters and the rank word (see
  Uncertain).

## Toe-to-Bar

Model facts: strict, no kip. Still hang to ~0.1 s and ~3.5-4.1 s (elbows 177, legs hanging, hips
172); the legs rise ~0.1-1.5 s, are held ~1.5-2.0 s and lowered ~2.0-3.5 s; two identical reps.
At the top the shoes' toes are level with the bar (their highest point 2.402 m, the bar's axis
2.40) and 2.3 cm in front of its surface (4 cm from its axis), x -0.10 m between the hands at
+-0.27: they reach the bar without quite touching it. Knees 176 hanging, 173 at the top, 158.5 at
the least (~0.75 and ~2.75 s). Hips 172 -> 44 (trunk to thigh); the trunk tips back 37 degrees
(neck behind the pelvis), the pelvis rises 17 cm and moves 10 cm forward; the pelvis bone turns
36 degrees against the chest (14 hanging), the spine rounding ~22 degrees more; the upper arm
closes on the trunk from 171 to 132 degrees, the elbows to 159-160, the shoulder joints rise ~5 cm.

| Claim | Source |
|---|---|
| Still hang on straight arms; press the bar down toward your hips as the legs rise | The model (elbows 177 hanging; the arms close 39 degrees on the trunk); ExRx Hanging Straight Leg-Hip Raise ("Attempt to decrease shoulder flexion during movement"); Invictus ("Keeping the lats engaged while pressing down on the bar") |
| ExRx also calls this lift the strict toes-to-bar | ExRx ("Also known as 'Toes-to-Bar' or 'Strict Toes-to-Bar'") |
| Arms close on the trunk by about 40 degrees, the body tips back under the bar | The model (171 -> 132; 37 degrees) |
| Shoulders down away from the ears (correct) | Invictus Tip 1 ("creating space between your ears and shoulders") |
| Mistake: hanging loose, shoulders by the ears | Coaching (Invictus's active hang); the library Hanging Knee Raise's grip cue |
| CrossFit's standard: both feet on the bar at the same time, inside the hands, from a full hang | CrossFit Games 15.1 standards |
| Catalyst lifts straight legs until the toes reach the bar | Catalyst Hanging Leg Raise |
| Toes level with the bar, about 2 cm in front, pause ~0.5 s | The model (2.3 cm, 1.5-2.0 s) |
| Mistake: feet around head height | The ghost (the legs 35 degrees lower; the feet ~45-57 cm out in front of the bar and ~20 cm lower, the ankles at ~2.0 m and the toes at ~2.2 m against the head joint at ~1.95 m) |
| Long legs the harder version; ExRx and Catalyst make it easier by bending the knees; Catalyst calls knees to elbows the more accessible variation | ExRx ("Movement can be made easier by Bending knees"); Catalyst Hanging Leg Raise ("To scale the motion, bend the knees"), Knees to Elbows ("a more accessible variation of the hanging leg raise") |
| Knees within about 20 degrees of straight | The model (least 158.5) |
| ExRx: hip raise finishing with the waist flexing to bring the feet to the bar; the abs only shorten if the waist actually flexes | ExRx ("Raise legs by flexing hips until fully flexed. Continue to raise feet toward bar by flexing waist."; "Rectus Abdominis and Obliques only dynamically contract if actual waist flexion occurs") |
| Catalyst curls the pelvis up as in a crunch so it is not just hip flexion | Catalyst Hanging Leg Raise ("tightening the abs to curl the pelvis up as you would in a crunch so the motion is not simply hip flexion") |
| In an EMG study of 14 men the hanging straight-leg raise was the hardest of the three exercises for the abdominal wall | McGill 2015 abstract (14 males; body saw, hanging leg raise, walkout; "the hanging straight leg raise created the highest challenge to the abdominal wall (>130% MVC in rectus abdominis, 88% MVC in external oblique)") |
| Curl the pelvis up as the legs rise; the lower back rounds steadily | The model (the lumbar segment's angle to the upper trunk grows from 14 to 36 degrees in step with the legs, about half of it before the thighs pass level) |
| Catalyst returns the legs under control and controls the speed on a pull-up bar to keep swinging to a minimum | Catalyst Hanging Leg Raise ("Return the legs to the hanging position under control"; "If performing from pull-up bars, control the speed to minimize swinging") |
| Dropping the legs sends them swinging back, which can throw the next rep up | Mechanical reasoning (a pendulum); no source |
| The kipping version uses that swing on purpose; this strict version starts every rep from a still hang | Invictus ("Kipping toes-to-bar is the same concept of the strict but you are adding in a kipping motion to help give yourself momentum to get your feet to the bar"); the model (still 3.5-4.1 s) |
| Mistake (legs): bending the knees and tucking them toward the chest, the feet well short of the bar | The ghost (knees 173 -> 103 at the top, the ankles moving ~46 cm, ~34 cm of it down, to ~1.9 m against the bar's 2.40) |
| Lift both feet at once; legs nearly straight and side by side (correct) | CrossFit 15.1 (both feet on the bar at the same time); the model (the legs parallel, ankle joints 27 cm apart hanging and 23 cm at the top, the shoes 12-17 cm apart; not together, so the copy no longer says the feet or legs are together) |
| About a second and a half down; still about half a second between reps; lower at about the speed you lifted | The model (2.0-3.5 s down, 1.4 s up; still 3.5-4.1 s) |
| Setup: overhand, a little wider than the shoulders; straight arms, legs straight below you; shoulders down, hang still | The model (the thumbs on the inside of the hands, palms forward: overhand; elbows 177, knees 176, hips 174 hanging); ExRx Hanging Straight Leg Raise ("slightly wider than shoulder width overhand grip"); Invictus |

Not used: CrossFit's 15.1 standard also requires the arms and hips extended at the bottom and the feet
brought back behind the bar and behind the body on every rep (its own words; it does not say kipping,
but that is the kipped competition version). The model is the strict version (Catalyst, ExRx), so the
copy treats the swing back as the mistake, as Catalyst does, and says the kipping version swings on
purpose.

Comparison (FEET SHORT OF THE BAR): ExRx ("Continue to raise feet toward bar by flexing waist";
the abs only dynamically contract if actual waist flexion occurs) and the model (the curl grows as the
legs rise). The correct note says the curl carries the legs up to the bar as they rise (not at the
top), and the mistake note that stopping at head height cuts the rep off before the waist has
finished flexing; the earlier claim that the hip flexors then do most of the lift had no source and
was removed.

## Hanging Oblique Knee Raise

Model facts: rep 1 (0-4 s) to the lifter's LEFT, rep 2 (4-8 s) to the RIGHT. Still hang to ~0.1 s
and ~3.5-4.1 s; up ~0.1-1.5 s; held ~1.5-2.0 s; down ~2.0-3.5 s. Elbows 177 all clip; the shoulder
line never turns. At the top: knees 80, hips 84, thighs 18 degrees above level, the knees pointing
20 degrees off to the side (both knees left of the midline: x 0.28 and 0.10 m against the pelvis's
0.05), the pelvis turned 20 degrees toward that side, its hip on that side 7 degrees higher, the
pelvis 5 cm toward that side, the lower spine leaning 18 degrees the other way from the pelvis (the
trunk side-bent over the hiked hip), the spine rounded ~13 degrees more than hanging.

| Claim | Source |
|---|---|
| Elbows ~177 every rep, shoulders square | The model |
| Invictus asks for an active hang from the moment you take the bar, space between ears and shoulders, giving tension and control over the swing | Invictus Tip 1 ("you should be in an active position, creating space between your ears and shoulders. This allows you to gain a lot of tension through your body on the rig and puts you in full control over your swing"), in its toes-to-bar guide |
| Grip a little wider than the shoulders | ExRx Hanging Twisting Leg Raise ("shoulder width or slightly wider overhand grip"); the model |
| Knees to one side, left first then right | The model; ExRx Hanging Twisting Leg Raise ("Raise legs to one side ... Raise legs to opposite side in same manner ... alternating between sides") |
| ExRx files the hanging twisting knee raise under the obliques, the muscles that turn and side-bend the waist | ExRx Hanging Twisting Leg Raise (Obliques directory, target Obliques, "Also known as Hanging Twisting Knee Raise"); ExRx Obliques (lumbar rotation and lateral flexion) |
| Lifting the knees to one side turns and tilts the pelvis under the ribs; ~20 degrees, ~20 degrees, ~7 degrees, shoulders square | The model |
| Mistake: straight up the middle is a plain hanging knee raise | The library's Hanging Knee Raise; the ghost |
| ExRx raises the knees until the hips are fully flexed or the knees well above the hips; CrossFit's hanging knee raise ends when the knees pass hip height | ExRx Hanging Twisting Leg Raise; CrossFit Games 15.1 ("ends when the athlete has raised their knees above the height of their hip") |
| Thighs ~18 degrees above level, knees bent a little past a right angle | The model (knees 80) |
| Catalyst raises the knees without swinging, controls the speed on a pull-up bar to keep swinging to a minimum | Catalyst Knees to Elbows ("Without swinging, lift the knees"; "control the speed to minimize swinging") |
| Kicking the legs back builds a swing that throws the next rep up | Mechanical reasoning |
| ~1.5 s down, ~0.5 s pause | The model |
| ExRx alternates sides rep by rep | ExRx Hanging Twisting Leg Raise |
| Setup: overhand, a little wider than shoulder-width; straight arms, legs straight below you | ExRx Hanging Twisting Leg Raise; the model (thumbs inside, palms forward; knees 176 hanging, the ankle joints 21 cm apart, so not together) |
| Equal reps each way give both sides of the waist the same work | Reasoning (the obliques' sides act on their own side's turn and bend, ExRx Obliques); not ExRx's words |

Comparison (KNEES UP THE MIDDLE): ExRx (the obliques are the target; ExRx adds that they work largely
isometrically, with relatively little movement, so the copy no longer calls the turn the movement ExRx
gives them); the model's pelvis turn and tilt under square shoulders.

## Lying Leg Raise

Model facts: legs from -1.5 degrees (the hip-to-ankle line just under the hip; shoes 4.6 cm off the
mat, calves 2.6 cm) to 86.4 degrees (hip 97) ~0.1-1.45 s, held ~1.45-1.95 s, lowered ~2.0-3.6 s,
hovering ~3.6-4.1 s; two identical reps. The heels never touch. Pelvis, spine, head, arms still.

| Claim | Source |
|---|---|
| Lifting the legs is hip flexion; without waist flexion the rectus and external oblique only hold the pelvis and waist | ExRx Lying Straight Leg Raise ("With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion"); ExRx Iliopsoas (hip flexion) |
| The authors of an EMG study describe the hip flexors' pull tending to arch the lower back while the abs hold the pelvis | Mandroukas 2022 discussion ("The contractions of these muscles increases lordosis in the lumbar spine, while the abdominal muscles have static action, stabilising the pelvis") |
| Pelvis and lower back do not move | The model (lumbar surface 3.3 cm all clip) |
| Straight legs a long lever (reasoning); ExRx's easier version bends the knees | ExRx Lying Straight Leg Raise ("To decrease intensity, flex knees along with hips") |
| Legs hip-width, toes pointed | The model |
| ExRx raises the legs until the hips are fully flexed; lying down, legs taken past vertical stop loading the waist and hip flexors | ExRx Lying Straight Leg Raise ("raise legs by flexing hips until hips are completely flexed"; "would not load waist and hip flexors after they travel beyond vertical", said of a lying leg-hip raise) |
| ~4 degrees short of vertical, ~0.5 s pause | The model (86.4, 1.45-1.95 s) |
| Head and shoulders down; lifting the head does not help the legs, it bends the neck and upper back | The model; mechanical reasoning |
| ExRx makes its lying leg raises easier letting the heels touch each rep, harder not letting them | ExRx Lying Straight Leg Raise ("Alternatively, perform exercise on floor and allow heels to make contact with floor each repetition", under Easier); ExRx Lying Leg Raise on floor, a bent-knee raise ("To decrease intensity, allow heels to make contact with floor each repetition"; "Perform on bench or do not let heels to make contact with floor", under Harder). The harder half is only on the bent-knee page, so the copy says its lying leg raises, not this raise |
| Heels ~5 cm off the mat between reps; ~1.6 s down against ~1.4 up | The model |

Comparison (BACK ARCHING): ExRx and Mandroukas as above.

## Flutter Kick

Model facts: each leg 5 -> 27 degrees above the floor (shoes 14.4 -> 46.9 cm), the legs opposite,
level at 16 degrees; left highest at 0.33, 1.67, 3.0, 4.33, 5.67, 7.0 s, right at 1.0, 2.33 ...
(1.33 s per cycle, a swap every ~0.67 s); no sideways motion; knees 180 all clip.

| Claim | Source |
|---|---|
| Catalyst: a hip flexor exercise training the abs to hold the pelvis and back still, lower back pressed into the floor | Catalyst Flutter Kick ("a low-intensity hip flexor exercise and a pelvis and back stability exercise—training the ability of the abs to stabilize the pelvis and back against unwanted movement"; "keep the lower back pressed into the floor") |
| EMG: 35 male students moving straight legs alternately up and down lying flat, the lower rectus showed more activity than the upper rectus and external oblique | Mandroukas 2022 results (35 male students; "During the alternate up and down leg movement (scissors) ... a strong activation of the RAL ... higher activity compared with the RAU ... and the EO (p < 0.001)") |
| Kick a little higher if the back lifts | Coaching: legs higher shorten their lever (reasoning; the round-2 Hollow Body Hold gives the same advice). Healthline's scissor kick page says the opposite for its easier version (keep the legs lower to the mat, start with the feet hovering if the back arches); that is not followed, since lower legs need more hip-flexor torque. ExRx Lying Simultaneous Alternating Straight Leg Raise lists raising the legs only a short height under Harder ("Raising legs up only short height challenges greater isometric-like endurance"), which agrees that low legs are the harder end; it says nothing about the back |
| Catalyst lifts straight legs; ExRx's easier version of its alternating straight-leg raises bends the knees | Catalyst Flutter Kick; ExRx Lying Simultaneous Alternating Straight Leg Raise ("To decrease intensity, flex knees along with hips") |
| Short range (Catalyst); ExRx: the scissor kick's very short range calls for more isometric-like endurance | Catalyst ("in a short range of motion"); ExRx Lying Scissor Kick ("Movement involves very short range of motion so greater isometric-like endurance is required") |
| 5-27 degrees, heels ~14-47 cm, ~30 cm of travel | The model |
| Catalyst keeps both heels off the floor; ExRx makes its scissor kick slightly easier letting alternate heels touch | Catalyst ("both heels are off the floor"); ExRx Lying Scissor Kick ("To make movement slightly easier, perform exercise on floor and allow alternating heels to make contact with floor each repetition") |
| The lower heel never closer than ~14 cm | The model |
| Catalyst programs 20-100 reps or 20-60 s | Catalyst Flutter Kick (Programming) |
| Legs swap every ~0.7 s, each leg up once every 1.3 s | The model |

Comparison (BACK ARCHING): Catalyst; Mandroukas's hip flexor pull on the lumbar curve.

## Scissor Kick

Model facts: the over-under scissor. Open at 0, 1.33, 2.67 ... s (ankles 0.67 m apart, each leg
17.6 degrees out, 15 up); crossed at 0.67 s left over right (ankles 6.5 cm apart sideways, the top
17 cm higher: 21 and 9 degrees up; the shoes overlap 4.2 cm sideways), at 2.0 s right over left,
and so on. At the cross each leg points 4 degrees past straight ahead and the ankle joints sit 3.3 cm
either side of the midline: the feet meet there and overlap, but the legs never pass the midline.
Shoes 20-38 cm off the mat (lowest point). Knees 180.

| Claim | Source |
|---|---|
| The over-under version ExRx points to from its own scissor kick | ExRx Lying Scissor Kick ("Also see over/under variation", a video link) |
| Drawing the legs in toward the midline is hip adduction, which ExRx gives as the movement of the adductors, the inner-thigh muscles | ExRx Adductors (other name: Inner Thigh; movement: Hip Adduction). The sentence that ExRx lists adductor longus and brevis among the scissor kick's helpers was removed: ExRx's scissor kick is the up-and-down kind and it lists the same two as synergists of all its lying hip flexor raises (the straight leg raise, the alternating raise), where its Adductors page gives them initial hip flexion, so the list does not support the sideways sweep |
| Feet meet at the middle and overlap a few centimetres; left on top, then right; one cross every 1.3 s | The model |
| Mistake: turning back with the feet still apart | The ghost (both legs 15 degrees out at the cross, the ankles ~49 cm apart instead of overlapping; round 2's side by side did not match a ghost with the feet half a metre apart) |
| ExRx: without waist flexion the abs only hold the pelvis and waist; its own scissor kick's very short range calls for isometric-like endurance | ExRx Lying Scissor Kick (Comments: "Movement involves very short range of motion so greater isometric-like endurance is required"; said of ExRx's up-and-down scissor kick, so the copy says its own) |
| ExRx's easier lying leg raises bend the knees | ExRx Lying Straight Leg Raise, Lying Simultaneous Alternating Straight Leg Raise |
| ExRx makes its own up-and-down scissor kick slightly easier letting alternate heels touch | ExRx Lying Scissor Kick ("To make movement slightly easier ... allow alternating heels to make contact with floor each repetition"; its execution lowers the vertical leg while the lower one rises) |
| Legs 9-21 degrees, the lower heel at least ~20 cm | The model |
| Healthline: a rhythmic, controlled motion rather than a fast one, in a guide written for the up-and-down kind | Lindberg S (medically reviewed by Bubnis D), How to do scissor kicks, Healthline, 2019-05-01 ("Keep the motion rhythmic and controlled, not fast and furious"; its kick lowers one leg as the other lifts, and it notes the move is sometimes called flutter kicks) |
| Setup: wider than the shoulders | The model (ankles 67 cm against shoulder joints 39 cm) |

Comparison (FEET NOT CROSSING): the model; ExRx's over/under variation. The correct note says the
legs come in to the midline, not across it (see the model facts).

## Distinct from the library

The Hanging Leg Raise lifts straight legs to about level, the Hanging Knee Raise bent knees
straight up, the Captain's Chair is supported on the forearms against a pad, the Reverse Crunch
curls the hips off the floor with bent knees, the Hollow Body Hold holds the legs still. No cue
sentence repeats one of the library's or another round's word for word (checked by script, see the
change log).

## Library rows

The rows went in with the models: RECTUS ABDOMINIS on all but the oblique raise (OBLIQUES), all
BODYWEIGHT; Toe-to-Bar advanced, the oblique raise intermediate, the floor three beginner. They fit
the models and sources (ExRx's target for the Toe-to-Bar is the rectus abdominis, for the twisting
knee raise the obliques; for the three floor lifts ExRx's target is the iliopsoas, which the library
has no row for). No change proposed.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`). The eye
button (top right, above ~0.13) and the legend (from ~0.92) are clear.

- Toe-to-Bar: the swinging legs sweep the whole left half between ~0.30 and ~0.80, and the
  lifter, the near upright and the bar fill the right, so the pills sit above the swing on the
  left (hang, Press the bar down, 0.12, to the far hand on the bar; lower, Lower slowly, 0.18, to
  the far ankle), below it (toes, Toes to bar, 0.80, to the far toes) and right of the hanging body
  over the near upright (pelvis, Curl hips up, 0.62, to the lumbar joint; legs, Legs long, 0.78, to
  the far knee). Chosen by `search.py` (pills on the lifter, leader length inside the body, leaders
  crossing, leaders through another pill): none on the lifter in any frame, no leaders crossing or
  passing through a pill. Round 1 had Toes to the bar at the top left, where the toes ghost's feet
  touched it in the mistake view, Lower slowly at 0.86, under the mistake sheet, and the knee
  leader passing through the hips pill at the top.
- Hanging Oblique Knee Raise: the knees swing to screen left on the right-side rep, so most pills
  sit right of the body over the right upright: hang (Shoulders down) 0.22 to the near shoulder,
  side (Knees to one side) 0.44 to the near knee, swing (No swinging) 0.66 to the near ankle; left:
  height (Knees up high) 0.30 to the far knee, short enough to clear the far arm (Knees above hips
  sat on it), switch (Left, then right) 0.84 to the far ankle. The side leader crosses the lower
  trunk while the knees are on the right side (rep 2).
- Lying Leg Raise: top (Legs to vertical) 0.18 left to the near toes; lower (Lower slowly) 0.30 and
  legs (Knees straight) 0.40 right to the near ankle and knee; back (Low back stays down) 0.72 left
  to the lumbar joint and head (Head stays down) 0.72 right to the head, both from below the mat.
  Round 1 had Lower slowly at 0.80 left, where its leader ran through the back pill.
- Flutter Kick: range (Small kicks) 0.26 left to the far toes; knees (Knees straight) 0.26 right
  to the near knee; tempo (Steady rhythm) 0.36 right to the near hip; heels (Heels never touch)
  0.70 left to the near ankle and back (Low back stays down) 0.70 right to the lumbar joint, from
  below.
- Scissor Kick: cross (Cross, swap the top leg) 0.26 left to the near toes; knees 0.26 and tempo
  0.36 right; heels (Heels off the mat) 0.70 left to the far ankle; back 0.70 right.
- The probed joints have fixed sides, and the oblique raise and the kicks switch sides, so every
  label is worded to hold for either side.

## Ghosts and when to still them

Measured with the port at each fault's still (`final.py`, `sweep.py`); the sweep runs every fault
over the whole clip: no ghost joint goes under the mat or the floor, no knee bends against its real
bend, and bone lengths are kept except where the shoulders' line is meant to change (the hang's
neck sinking between the shoulders, ~2 cm).

- Toe-to-Bar (bottom = 0.0 s, top = 1.58 s by `fault_times.py`'s curlup kind; the shots still them
  0.02 s later): hang
  `legRaise500HangingLoose(0.18)` (the body ~11 cm, ~22 pt lower); toes
  `legRaise500LegsShort(35)` (the legs point almost straight up at the top, so the feet swing ~45-57 cm,
  ~100 pt, out in front of the bar and only ~20 cm down, to about head height); legs
  `legRaise500KneesBent("*", 70)` (knees 173 -> 103, feet ~46 cm); pelvis `legRaise500NoCurl(20)`
  (the lumbar joint ~11 cm toward the belly, legs 20 degrees lower, feet ~29 cm); lower
  `legRaise500SwungBack(40)` (~0.6 of it at the hang, feet ~35 cm back).
- Hanging Oblique Knee Raise: hang as the Toe-to-Bar (bottom); side `legRaise500KneesMiddle(20)` at
  1.75 s, gated to the left-side rep (`legRaise500LeftRep`: none at the right-side top), the knees
  back square, ~16 cm (~31 pt), seen from the front (`.seen(0.5)`, added in review: at the framing
  the left-side knees point almost at the camera, so the squared ghost read as the knees going to
  the other side); height `legRaise500LegsShort(30).seen(-0.8)` at 1.75 s (0.86 of it at the still:
  the thighs 18 above -> ~8 below level); swing `legRaise500SwungBack(40).seen(-0.8)` at the bottom (feet ~34
  cm back; ~61 pt seen side-on against ~34 at the framing). Switch has none.
- Lying Leg Raise: back `legRaise500BackArched` at 3.2 s, gated to the low part of the rep
  (ankle-to-neck 2.2 -> 2.42 torso lengths; lumbar joint ~11 cm, ~19 pt); legs
  `legRaise500KneesBent("*", 60)` (feet ~40 cm, ~65 pt) and top `legRaise500LegsShort(40)` (86 ->
  46 degrees, feet ~58 cm, ~95 pt) at the top, gated by ankle-to-neck 2.3 -> 2.0 (`withBend("thigh_L")`
  only reached 0.66 lying, the hip angle reads off the lumbar joint); head
  `legRaise500HeadUp(25)` at the top (head ~25 cm up; drawn without the arms, whose hands went into
  the mat). Lower has none.
- Flutter Kick (all at 0.33 s, the left leg up): back `legRaise500BackArched(.always)`; knees,
  range and heels name the legs by role (`_front` = the higher leg lying face up) and fade out as
  the legs pass (`legRaise500KickApart`, ankles 0.52 -> 0.68 torso lengths apart): knees bent 45
  on the higher leg (foot ~30 cm down), the higher leg 35 degrees higher (the ankle ~51 cm along its arc, ~36 cm of it up), the lower
  leg 9 degrees down onto the mat (foot ~13 cm). Tempo has none.
- Scissor Kick (all at 0.67 s, the first cross): back as the Flutter Kick; cross
  `legRaise500LegsApart(15).seen(0.5)` (both legs 15 degrees out, the feet ~21 cm each way apart),
  knees on the top leg (45), heels the under leg 13 degrees down (9 -> -4, the heel on the mat as
  on the Flutter Kick; 11 in round 2 left it ~4 cm up); the three gated to the cross
  (`legRaise500Crossed`). Tempo has none.

## Uncertain

- No EMG of these five lifts; every fraction is a judgement call.
- McGill 2015's hanging straight leg raise is not described in the abstract beyond its name; it is
  the closest measured lift to the strict toes-to-bar.
- Mandroukas 2022 reports integrated EMG in mV (not normalised); only the order between muscles is
  used, and the copy says the lower rectus showed more activity, not that it worked harder. Its "scissors" is the up-and-down alternating leg movement (the flutter kick), not the
  model's over-under scissor.
- ExRx's over/under scissor kick is only a video link on its scissor kick page; the copy says no
  more than that ExRx points to it.
- Healthline is a consumer health site; it is used for one tempo sentence only, and its scissor kick
  is the up-and-down kind (the copy says so). Its easier version keeps the legs lower when the back
  arches, the opposite of the copy's kick a little higher (coaching, kept: see the Flutter Kick table).
- On the Toe-to-Bar's framing the near upright's foot covers the end of the secondary legend line
  (LATISSIMUS DORS... and SECONDARY); a legend backing over equipment (the README's open point from
  round 2) would fix it, or a framing change.
- Leaders to moving legs cross the body at some point of a swing whatever row they start from: the
  Toe-to-Bar's Legs long leader passes over the hanging legs to the far knee at the bottom, its Curl
  hips up leader over the near hip; the oblique raise's Knees to one side leader crosses the lower
  trunk on the right-side rep. The layout search kept the pills off the lifter in every frame and
  no two leaders crossing.
- The kicks' and the leg raise's lower-back ghost is the situp family's arch (lumbar joint ~11 cm,
  ~19-22 pt): it reads as a small hump at the lower back, as it does there.
- ExRx was read through Internet Archive copies (the live site blocks automated fetches).

## Change log

- 2026-10-05, draft: models measured, sources read, copy, setup, labels (searched), ghosts (port,
  sweep) and moments for all five; `spec_500.py legraise` OK; `family.sh check legraise` BUILD
  SUCCEEDED on the first build.
- Lab round 1 (`family.sh shoot legraise "0,1,1.6,5.6"`, kept in `SCRATCH/lab/r3/legraise/round1/`):
  BUILD SUCCEEDED; all 20 trainer stills and 21 ghosts rendered, every ghost attached and showing
  its mistake. Fixed: the Toe-to-Bar's Toes to the bar pill (top left) touched the toes ghost's feet
  in the mistake view and its Lower slowly pill at 0.86 sat under the mistake sheet (the sheet
  starts at ~0.85 of the viewport), and the knee leader passed through the hips pill at the top: the
  toes pill moved to 0.80 bottom left (Toes to bar), lower to 0.18 top left, the knee and hips
  pills to 0.78 and 0.62 right, re-searched with a leader-through-pill check; the Lying Leg Raise's
  Lower slowly leader ran through the back pill (moved to 0.30 right). Copy tightened against the
  sources (ExRx's shoulder-flexion note quoted as written, the hardest of the hanging raises ->
  the harder version, Invictus's active hang named as its toes-to-bar guide's, ExRx's endurance
  wording, the scissor cross's adductor sentence from ExRx's Adductors page, a setup sentence
  that repeated another lift's).
- Lab round 2 (`"0,0.67,1.6,5.6"`, kept in `SCRATCH/lab/r3/legraise/round2/`):
  BUILD SUCCEEDED; every pill off the lifter in all 20 stills, no leader through a pill, all 21 ghosts
  attached and readable, no pill on its ghost in the mistake views. Text-only edits after it (the
  lying leg raise's correct line, an activation comment, the header's sources).

## Self-review (author, 2026-10-05)

- Sources: every study re-read on Europe PMC with its authors, journal, volume, pages, DOI and PMID
  as in the header; Mandroukas 2022's full text for the exercise list and the scissors result;
  ExRx's eight exercise pages and three muscle pages at the snapshots named; CrossFit 15.1,
  Catalyst's four pages, Invictus and Healthline as fetched. Every copy sentence with a source is
  in the tables above; reasoning is marked as such (the swing, the long lever, head lifting, the
  sides getting the same work). Shields and Heiss 1997, read first, was dropped (nothing in the
  copy rests on it).
- Model fidelity: the copy's sides, timings, angles and heights are the rig's (the tables'
  model facts); the oblique raise is worded for both sides; the kicks' labels name no side; the
  Toe-to-Bar says the toes reach the bar, the model stopping 2.3 cm short of contact (said here).
- Activation: every row follows the paint (bright primary, dim secondary, faint LOW or
  stabilisers) and each fraction's level matches it; all are labelled judgement calls.
- Final `family.sh check legraise` after the comment fixes: BUILD SUCCEEDED.

## Review (independent, 2026-10-05)

Two passes, sources and then fidelity to the models; working files in `SCRATCH/lab/r3/legraise/rev/`
(`src/` the sources as re-fetched, `dump.py` / `meas.py` / `hok.py` / `lie.py` / `shoe.py` the rigs
re-measured from the USD, `lab_review1/` the review's lab shots).

Sources. The five Europe PMC records re-read (`rev/src/epmc_*.json`): McGill, Andersen, Cannon 2015
(14 males; body saw, hanging leg raise, walkout; the hanging straight leg raise >130% MVC rectus
abdominis, 88% external oblique, ~3000 N), Escamilla et al. 2006 (21 men and women; the hanging
knee-up with straps among the highest for the rectus abdominis, internal oblique and latissimus
dorsi, and with the Power Wheel the highest for the external oblique), Andersson et al. 1997 (6 men),
Mandroukas et al. 2022 (PMC full text: 35 male students; Figure 3A straight legs moved alternately up
and down, RAL 445.8 against RAU 285.7 and EO 231.2 mV; the discussion's hip flexor pull increasing
the lordosis while the abdominals stabilise the pelvis) and Juan et al. 2024 (9 studies, 109
adults). Authors, journals, volumes, pages, DOIs and PMIDs all match the header. ExRx's eight
exercise and three muscle pages re-fetched at the cited Wayback snapshots, Catalyst's four pages,
CrossFit's 15.1 standards, Invictus (Weiss, Vieux, Ewart, 6 Feb 2023) and Healthline (Lindberg,
reviewed by Bubnis, 1 May 2019) fetched fresh. Every quote in the tables is on its page. Fixed:
- Flutter Kick back: the lower rectus worked harder than the upper rectus and the external oblique
  rested on raw, unnormalised iEMG compared across muscles; it now says showed more activity, and
  names the 35 male students.
- Oblique raise: Catalyst controls the speed to minimise swinging, not so the body does not swing
  (both the swing cue and the Toe-to-Bar's lowering cue now say to keep swinging to a minimum). The
  comparison called the turn the movement ExRx gives the obliques, while ExRx says they work largely
  isometrically with little movement; it now says only that ExRx makes them the target. The switch
  cue's reason for alternating (equal work each side) no longer reads as ExRx's.
- Lying Leg Raise top: ExRx's past-vertical note is about a lying leg-hip raise and says waist and
  hip flexors; the copy now keeps both and says lying down.
- Toe-to-Bar lowering: CrossFit's 15.1 standard, cited for the toes, asks for the feet behind the
  bar on every rep; the copy now says the kipping version uses the swing on purpose (Invictus) and
  this strict one starts each rep from a still hang. The notes no longer say CrossFit's rule is for
  kipping reps only.
- Scissor tempo: Healthline's guide is for the up-and-down scissor kick (it says the move is also
  called flutter kicks); the copy now says so. Its advice to keep the legs lower when the back arches
  contradicts the kicks' kick a little higher; recorded, the coaching kept (mechanics, and the
  round-2 Hollow Body Hold's advice).
Activation re-checked against `tiers.txt` (all five) and the library anchors in SampleData.swift
(Hanging Leg Raise 0.86 / 0.84 / 0.62 / 0.40 / 0.25, Hanging Knee Raise 0.80 / 0.76 / 0.64 / 0.40 /
0.25, Reverse Crunch 0.82 / 0.58 / 0.42): bright rows primary, dim secondary, faint LOW or
stabilisers, every level matching its fraction, every list labelled a judgement call. Unchanged.

Model fidelity. Re-measured from the USD (not the author's dumps): Toe-to-Bar knees 176 -> 173, least
158.5 at ~0.8 and 2.75 s; hip 174 -> 43; lean 37.4 back; pelvis +17.4 cm; upper arm to trunk 171 -> 132;
elbows 177 -> 159.5; shoulders +4.9 cm; wrists 53.5 cm, shoulders 39.2 cm; the skinned shoes 2.402 m
high and 2.3 cm from the bar's surface at x -0.10 (the hands at +-0.27). Oblique raise: left rep 1,
right rep 2, knees 80, thighs 18 above level and 20 to the side, pelvis turn 20 and hike 7 toward the
knees, shoulders square, elbows 177. Lying Leg Raise: -1.5 -> 88 degrees in the sagittal plane (86.4
in space, the legs 3 degrees out), held 1.5-1.9 s, still trunk. Flutter Kick: 5-27 degrees, left peak
0.33 s, right 1.0 s, 1.33 s cycle. Scissor Kick: ankles 67 cm open, 9 / 21 degrees at the cross.
Fixed:
- Scissor cross: the copy said the legs cross over the midline; at the cross each leg is only 4
  degrees past straight ahead and the ankle joints stay 3.3 cm either side of the midline (the shoes
  overlap ~4 cm, the top one 17 cm higher). The cue now has the legs drawn in toward the midline until
  one foot passes just over the other; its mistake said the feet stop side by side while the ghost
  holds them ~49 cm apart, so it now says they turn back still apart (comparison: Feet turn back
  apart). The setup step matches.
- Toe-to-Bar pelvis: the cue had the pelvis curl start as the legs pass level; the model's lumbar
  curl grows steadily from the hang (14 -> 36 degrees, about half before the thighs pass level), so
  the intro and correct lines now curl as the legs rise. Legs mistake: tucking and flicking the feet
  up at the end; the ghost is the tuck at the top, so it now reads tucking with the feet well short
  of the bar.
- Ghosts, checked with the author's port (re-read against FaultGhost.swift: frame, role sides,
  mirrored turns, tips, strengths) and the lab shots:
  - Oblique raise side: at the framing the left-rep knees point almost at the camera and look
    centred, so the squared ghost knees showed off to screen left, which reads as the knees going
    to the other side. Now `.seen(0.5)`, from the front: the real knees ~28 pt to the lifter's
    left of the pelvis, the ghost's under it (~31 pt move, as before). Lab shot confirms.
  - Scissor heels: 11 degrees left the under heel ~4 cm off the mat; 13 (9 -> -4 degrees) puts the
    ankle joint at 10 cm, the heel on the mat as on the Flutter Kick (~40 pt). Lowest point over
    the clip 0.10 m.
  - Comments corrected: the Toe-to-Bar toes ghost moves the feet ~45-57 cm out in front of the bar
    and only ~20 cm down (not ~50 cm down); the oblique raise's height ghost shows 0.86 of its 30
    degrees at the still, the thighs ~8 degrees below level (not 12).
  The other 18 ghosts checked on the shots: attached, the named mistake, knees bending the right
  way, nothing under the mat; unchanged.
- Labels: all 20 trainer stills re-inspected (identical to round 2); no pill on the lifter. Left as
  the author reported: leaders to the swinging legs crossing the body at some point of the swing,
  the Toe-to-Bar's secondary legend under the upright's foot.
- Lab (`family.sh shoot legraise "0,0.67,1.6,5.6"`, copy in `rev/lab_review1/`): BUILD SUCCEEDED,
  20 trainer stills and 21 ghosts; the changed ghosts read as intended.
- A last text edit (the Toe-to-Bar lowering cue's final sentence) after the shoot; `spec_500.py
  legraise` OK and `family.sh check legraise` BUILD SUCCEEDED.

## Verification (final skeptic, 2026-10-05)

Every claim and number in the copy, the setup steps, the activation comments and the source table
was checked against a fresh copy of its source or against the rig. Working files in
`SCRATCH/lab/r3/legraise/skep/` (`src/` the sources as re-fetched, `dump.py` / `lib.py` / `t2b.py` /
`hok.py` / `lie.py` the joints read straight from the USD, `skin.py` the skinned shoes, hands, head,
glutes and back).

Sources re-opened: the five Europe PMC records (McGill 2015: 14 males, three exercises, >130% MVC
rectus abdominis, 88% external oblique, ~3000 N; Escamilla 2006: 21 men and women, the hanging
knee-up with straps; Andersson 1997: 6 men; Mandroukas 2022 full text: 35 male students, Figure 3A
straight legs moved up and down alternately, RAL 445.83 against RAU 285.70 and EO 231.17 mV, the
discussion's lordosis sentence; Juan 2024: 9 studies, >60% MVIC); the 11 ExRx pages at the cited
Wayback snapshots; Catalyst 45, 490, 567, 563; CrossFit 15.1; Invictus (Weiss, Vieux, Ewart, Feb 6
2023); Healthline (Lindberg, reviewed by Bubnis, 2019-05-01). All citations match.

Model facts re-measured (all confirmed): Toe-to-Bar knees 176 / 173 / least 158.5, hips 174 -> 43,
lean 37.4 back, pelvis +17.4 cm, arm-to-trunk 171 -> 132, elbows 177 -> 159.5, shoulders +4.9 cm,
wrists 53.5 / shoulders 39.2 cm, overhand (thumbs inside), up 0.04-1.5 s, held 1.5-2.0, down
2.0-3.6, still 3.6-4.04; the lumbar curl 14 -> 36 (25 when the thighs pass level at ~0.76 s); the
skinned shoes 2.402 m high, 2.3 cm from the bar's surface at x -0.10, the hands' inner edges at
+-0.22. Oblique raise: left 0-4 s, right 4-8 s, knees 80, thighs 18 above level, knees 20 to the
side, pelvis turned 20 and hiked 7, shifted 5 cm, shoulders square, elbows 177.3, arm-to-trunk
172 -> 162. Lying Leg Raise: knees 180, ankle 140 (toes pointed), -1.5 -> 86.4 in space, up ~1.4 s,
held ~0.5 s, down ~1.6 s, shoes 4.6 cm off the mat at the bottom; trunk, arms and head still, palms
down (thumbs inside, toward the mat); head, hands and glutes 0.4 cm off the mat. Flutter Kick: 5-27,
left peaks 0.33, 1.67 ... s, right 1.0, 2.33 ..., level crossings every ~0.67 s, no pause (ankle
speed never under 0.07 m/s), shoes 14.4-46.9 cm, the lowest heel point moving 33 cm. Scissor Kick:
open 0.67 m at 0, 1.33 ... s (17.6 out, 15 up), crosses at 0.67 (left on top), 2.0 (right) ... six,
21 / 9 degrees, ankle joints +-3.3 cm, the shoes overlapping 4.2 cm sideways, the lower shoe at least
20.4 cm up, no pause. Paint (`tiers.txt`) and the library anchors in SampleData.swift match the
activation rows and comments.

Refuted and fixed (text only; no label, cue id, tracked joint or ghost changed):
- Feet and legs together (Toe-to-Bar toes intro, legs correct and setup; oblique raise setup): the
  hanging models keep the legs parallel and apart (ankle joints 27 cm hanging and 23 cm at the top
  on the Toe-to-Bar, 21 cm on the oblique raise; the shoes 8-17 cm apart). Now both feet at once,
  legs side by side, legs straight below you.
- Toe-to-Bar comparison: the correct note curled the pelvis at the top, against the model (the curl
  grows from the hang, half of it before the thighs pass level) and the pelvis cue fixed in review;
  the mistake note's the hip flexors do most of the lift had no source. Now the curl carries the legs
  up to the bar as they rise, ExRx's abs-shorten-only-with-waist-flexion, and stopping short cuts the
  rep off before the waist has finished flexing.
- Scissor cross why: ExRx lists adductor longus and brevis as synergists of its up-and-down scissor
  kick and of all its lying hip flexor raises (initial hip flexion on its Adductors page), so citing
  that list for the sideways sweep was misleading. The clause is gone; the copy keeps hip adduction
  as ExRx's movement for the adductors. The activation comment says the same.
- Heels touching: ExRx makes its (up-and-down) scissor kick slightly easier letting alternate heels
  touch; the Flutter and Scissor heels cues now say slightly easier and alternate heels, and the
  Scissor cues say its own scissor kick (heels, and the back cue's very short range).
- Lying Leg Raise lowering: ExRx's harder-without-heel-contact is on its bent-knee floor raise, the
  easier half on the straight-leg page; the copy now says its lying leg raises, not this raise.
- Ghost comments (sizes only): Toe-to-Bar legs, the ankles ~46 cm, ~34 cm of it down (the notes said
  ~46 cm lower); Lying Leg Raise legs, ~40 cm away from the head, ~21 cm down (not toward the mat);
  top, ~58 cm along the arc, ~22 cm down (not ~58 cm down); Flutter range, ~51 cm along the arc,
  ~36 cm up (not ~51 cm up). Header source notes say which ExRx pages are the bent-knee and
  up-and-down kinds, and that the past-vertical note is said of a lying leg-hip raise.
- Kept, with the conflict recorded: kick a little higher if the back lifts (mechanics; ExRx's
  alternating raise lists low legs as the harder end; Healthline says the opposite).

Checks: `spec_500.py legraise` OK, `preview_500.py legraise` unchanged layout, `family.sh check
legraise` BUILD SUCCEEDED after the edits. No shoot was needed (text and comments only); the
review's lab shots (`rev/lab_review1/`) were re-inspected: all 21 ghosts attached and reading as their
mistake (the Lying Leg Raise legs ghost folds the shins away from the head, as the corrected comment
now says).
