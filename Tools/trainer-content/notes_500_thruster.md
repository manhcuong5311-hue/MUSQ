# 401-500 folder, round 3: thrusters and the clean and press (2026-10-05)

Four lifts from the builder's 445-474 exports: 471 Barbell Thruster (`Legs/BarbellThruster`),
472 Dumbbell Thruster (`Legs/DumbbellThruster`), 473 Kettlebell Thruster (`Legs/KettlebellThruster`)
and 474 Clean and Press (`Shoulder/CleanAndPress`). `spec_500_thruster.py` holds the copy and setup
steps (its header lists what each model shows and the full citations),
`Tools/fault-review/faults_500_thruster.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_thruster.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The rigs straight from the USD with Blender's Python + pxr (`SCRATCH/thruster/` in the session
  scratchpad, `SCRATCH` = `$LAB/r3`): `dump.py` writes every joint, the equipment's world boxes
  (each plate, dumbbell head, kettlebell bell) and the skinned shoes, hands, glutes and thigh muscles
  every frame; `an.py` prints a timeline (pelvis height, knee and hip angles, trunk lean, ankle angle,
  heel and toe height from the skinned shoe, elbow angles, shoulder flexion, upper-arm angle to level,
  hand and elbow heights, equipment centres); short snippets measured widths, the spine's two bends,
  knee tracking against the feet, the thigh angle at the bottom and the bar's distance to the shins
  and thighs; `contact.py` measures the closest distance between the equipment meshes and the skinned
  muscle, hand and head-neck meshes (the bar shaft as a rod).
- The motion briefs (`SCRATCH/briefs/<Resource>.md`, `briefs_legs/`), `tiers.json`, `joints.json`
  and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`). The briefs' wrist reading for the barbell
  rack (+79°, "flexion") contradicts the palms-up hand on a vertical forearm; it was not used.
- Labels: `preview_500.py thruster`, `SCRATCH/thruster/overlay.py` (pills at ~24 + 6.5 pt per
  character and 29 pt tall, the app's 8 pt edge clamp, leaders to the probed joint, scored against
  the stills' silhouettes) and `rows.py` (how long each plate covers a label row over the whole
  clip, plates as projected discs), then the lab shots.
- Ghosts: `SCRATCH/thruster/ghost.py`, a Python port of `FaultGhost.solve` (BodyFrame, shift, turn,
  straighten, resolve, strength) with `proj.py` (probe.py's projection with each framing) and
  `pieces.py` (the shared Swift pieces in Python): moved distances, on-screen size, knee and elbow
  angles before and after, segment lengths, lowest ghost point.
- Sources: Europe PMC REST records (abstracts) for every study, the PMC full text of Geisler 2023
  (read, not cited: its EMG exceeded the MVICs, so it does not rank muscles); ExRx through the
  Wayback Machine (`SCRATCH/thruster/src/exrx/*.html`, text with `txt.py`); CrossFit's pages fetched
  directly (`SCRATCH/thruster/src/web/`).

## Shared facts about the models

- One body: shoulder joints 39.2 cm apart, hip joints 18.3 cm, neck to pelvis ~0.59 m standing. Clips
  of 7.96 s at 24 fps. The spine's two bends (pelvis-spine-chest and spine-chest-neck) read 8° and
  5-6° in every frame of all four clips, so the back never rounds or arches; the trunk only tips.
- The three thrusters share one leg motion and timing, two identical 4 s reps: racked and standing
  0-0.33 s; squatting 0.33-1.50 s; a short stop at the bottom (pelvis 0.475 m, 1.50-1.67 s); standing
  up 1.67-2.17 s (knees 62° -> 175° in 0.5 s); the weight leaves the shoulders at ~2.0 s with the
  knees at 129° and the arms finish the press at 2.50 s (barbell) or 2.58 s (dumbbells,
  kettlebells); locked out to ~3.33 s; back to the shoulders by 3.83 s with a small knee bend (145°
  barbell, 148° dumbbell and kettlebell) as it lands; standing again at 4.0 s.
- Thruster feet: ankle joints 39.0 cm apart (the shoulder joints' width), the feet turned 20° out,
  the skinned heels 0.2 cm off the floor the whole clip.
- Thruster bottom: knees 62°, hips 87° (dumbbell, kettlebell) to 89° (barbell), trunk 24° forward,
  shins 40° (barbell) to 49° forward, the knees 25 cm (barbell) to 30 cm ahead of the ankles. The hip
  joint stays above the knee joint: the thigh line slopes 15.2° (barbell) or 20.1° (dumbbell,
  kettlebell) above level, short of parallel.
- Knee tracking at the bottom: the barbell model's knees are 62.6 cm apart over ankles 39.0 cm apart,
  each knee 25-26° out from straight ahead with the feet at 20° (over the toes). The dumbbell and
  kettlebell models' knees are 22.8 cm apart, each pointing 15° inward while the feet point 20° out:
  the knees cave in. So those two have no knee cue (an open point below).
- Thruster lockout: elbows 174-175°, the hands 1-3 cm behind the ankle joints in the horizontal
  plane (over the ankles), 1-3 cm in front of the shoulder joints, the trunk 2° back, the head joint
  under the hands (the bar 2.4 cm in front of it).
- Clean and Press: one rep, below.
- Framings: the barbell thruster and the clean and press front three-quarter from the lifter's left
  (yaw -0.8), the dumbbell and kettlebell thrusters a little more face-on (-0.6).

## Activation

Paint (`tiers.json`): the three thrusters light DeltoidAnterior, GluteusMaximus, GluteusMedius,
GluteusMinimus, RectusFemoris and the three vasti bright; AdductorLongus, AdductorMagnus, Gracilis,
DeltoidLateral, RhomboidMajor, TrapeziusUpper/Middle/Lower and the three triceps heads dim. The Clean
and Press lights DeltoidAnterior, the three glutes, the quadriceps, RhomboidMajor and the three
trapezius parts bright; the biceps heads, BicepsFemoris, Semimembranosus, Semitendinosus,
Brachioradialis, the forearm flexors and extensors, DeltoidLateral, ErectorSpinae, the gastrocnemius
heads, Soleus and the triceps heads dim. Rows follow the paint (bright = PRIMARY, dim = SECONDARY).

No EMG study of a thruster or a clean and press was found (Europe PMC: thruster with EMG, kinetics,
kinematics, squat and press, CrossFit; "clean and press"; "power clean" with electromyography). The
thruster studies found are about loads and conditioning (Oliver-López 2025 predicts thruster 1RM from
the clean and jerk; others time workouts such as Fran), not muscle activity. So every fraction is a
judgement call anchored on the library's nearest lifts and the order the studies give:

| Row | Value | Anchor |
|---|---|---|
| Thrusters: Quadriceps P | 0.86 | Library Goblet Squat 0.85, Kettlebell Goblet Squat 0.86, under Front Squat 0.94 (its copy asks for the hip crease below the knee; these models stop 15-20° above level). Gullett 2009: the front squat matched the back squat's overall muscle recruitment |
| Thrusters: Anterior Deltoid P | 0.80 | Library Push Press and Dumbbell Push Press 0.80 (legs launch the load, arms finish). ExRx Military Press: target anterior deltoid |
| Thrusters: Gluteus Maximus P | 0.62 (moderate) | Library Back Squat 0.62; Contreras 2016: no significant difference in gluteus maximus EMG between front, full and parallel squats. Bright, so primary |
| Barbell: Triceps Brachii, Lateral Deltoid S | 0.58, 0.56 | Library Push Press |
| Dumbbell, kettlebell: Lateral Deltoid, Triceps Brachii S | 0.60, 0.55 | Library Dumbbell Push Press; Saeterbakken 2013 (standing: dumbbells drew more anterior and medial deltoid and less triceps activity than the barbell), the direction those values lean; Blazkiewicz 2022 (kettlebell and dumbbell presses not significantly different) for the kettlebell |
| Thrusters: Adductors S | 0.38 (low) | ExRx Barbell Front Squat lists the adductor magnus as a synergist; library Squat's Adductor Magnus 0.40 |
| Thrusters: Trapezius S | 0.36 (low) | Library Standing Dumbbell Press 0.36; ExRx Military Press lists the middle and lower trapezius as synergists; CrossFit's thruster page names the traps among the muscles that drive the bar overhead |
| Clean and Press: Anterior Deltoid P | 0.84 | The strict press; library Barbell Overhead Press 0.86 |
| Clean and Press: Trapezius P | 0.70 | Nagao 2021 (the upper trapezius appeared to hold the shoulder blades in the first pull and transition, contracted hard to lift them in the second pull); library Barbell Shrug 0.88 is an isolation lift; ExRx Power Clean's scapular elevation and upward rotation |
| Clean and Press: Gluteus Maximus P, Quadriceps P | 0.70, 0.62 | CrossFit Power Clean: hips, quads, glutes and hamstrings are the prime movers; library Deadlift 0.76 / 0.50, the quadriceps raised for the catch and the stand from a partial squat |
| Clean and Press: Erector Spinae, Triceps Brachii, Hamstrings, Lateral Deltoid, Forearms S | 0.55, 0.55, 0.50, 0.50, 0.35 | ExRx Power Clean: static spinal extension; library Deadlift (erector 0.85, hamstrings 0.66) for heavier loads; library Barbell Overhead Press triceps 0.58; ExRx Military Press synergist lateral deltoid; the grip held through the clean |

Moved to the stabilisers with the reason in the code: the rhomboids (bright on the clean and press,
dim on the thrusters; the Trapezius row files the same muscle group, the upper back, and another
name would run the one-line legend further past its width), the bright gluteus medius and minimus
(covered by the Gluteus Maximus row's group), and on the clean and press the dim biceps (they bend
the elbows only in the pull under, ExRx's elbow flexion) and calves (only as the heels rise at the
top of the pull). The serratus anterior (ExRx Military Press synergist; ExRx's thruster articulation
lists scapular upward rotation) and the core (CrossFit: the trunk contracts isometrically) are named
too. The three-name primary legends (four on the clean and press) truncate, the open point the
round-1 README names.

## Barbell Thruster

Model facts: overhand grip, wrist joints 58.4 cm apart (9.6 cm outside each shoulder joint). The bar
is held in the palms at the front of the shoulders just above the collarbones: its centre 1 cm below
and 8 cm in front of the neck joint; its surface 2.6-2.8 cm in front of the front deltoid and 3.2 cm
from the clavicular pectoralis, 5 cm from the neck, so it hovers just off the shoulders rather than
resting on them (the muscle meshes are the body's surface; there is no skin layer). Forearms vertical
(the elbow joint directly under the wrist joint, z 0.19), the elbows 8 cm in front of the bar's
centre, the upper arms 53° below level standing and 67° at the bottom, elbows 42-44°. Reps and
bottom as above; the bar leaves the shoulders at ~2.0 s, the elbows open 44° -> 58° -> 72° (2.0,
2.08, 2.17 s, knees 129°, 158°, 175°) and lock at 2.5 s.

| Claim | Source |
|---|---|
| The bar sits at the front of the shoulders, just above the collarbones; elbows down and a little in front of it | The model (above). ExRx Barbell Thruster: "Position bar on front of shoulders with elbows pointing slightly forward and torso tight" |
| CrossFit's thruster guide keeps the bar against the body until the legs lift it off the shoulders | CrossFit The Thruster ("The bar must stay connected to the body until the legs elevate it off the shoulders") |
| CrossFit's front squat guide: a bar held up in the hands, off the body, lets the arms soak up the leg drive like shock absorbers and loads the shoulders, elbows and wrists | CrossFit The Front Squat ("the arms act like shock absorbers and dampen the forces driven into the bar from the leg drive, but it is also stressful on the shoulders, elbows, and wrists"); CrossFit The Thruster says the front squat's faults also show in the thruster |
| Grip just outside the shoulders | The model (9.6 cm outside each shoulder joint); CrossFit The Thruster ("hands just outside the shoulders"); ExRx ("slightly wider than shoulder width") |
| ExRx: thighs just past level; CrossFit: hip crease below the top of the knees; the lifter stops about 15 degrees above level | ExRx ("Descend until knees and hips are fully bent or until thighs are just past parallel to floor"); CrossFit The Thruster ("a front squat where the crease of the hips descends below the top of the knees"); the model (thigh line 15° above level, hip joint 12 cm above the knee joint). The copy says close to level, deeper if the heels stay down and the back flat, so it never teaches stopping short |
| A much shallower squat turns into a short dip and the legs drive through less of their range | Mechanics; the push press's short dip (ExRx Push Press) as the comparison |
| ExRx moves the knees slightly outward toward the toes | ExRx ("Knees travel slightly outward in direction of toes"); the model (knees 26° out over feet at 20°) |
| CrossFit counts knees caving in among front squat faults that show in the thruster; its front squat guide: the force no longer goes efficiently into the floor and back up into the bar; may lead to knee pain over time | CrossFit The Thruster ("knees collapsing inward"); CrossFit The Front Squat ("forces are not being efficiently directed into the ground or back up the chain into the bar"; "an orthopedically compromised position that may lead to knee pain over time") |
| The legs lift the bar off the shoulders first, the arms finish; pressing before the hips and knees straighten is a common fault: less weight, wasted effort, more fatigue | CrossFit The Thruster ("focus on using the legs to elevate the load prior to pressing the bar off the shoulders"; "It is common for athletes to engage their arms early ... less weight being lifted, inefficient movement, and increased fatigue") |
| Here the bar leaves the shoulders as the knees straighten and the arms finish once the legs are straight | The model (2.0-2.5 s above) |
| Stand up fast | The model (0.5 s from the bottom to straight legs); CrossFit The Thruster: Potent Tool ("explosive drive out of the bottom of the squat") |
| Finish with the bar overhead roughly over the ankles; a bar forward of the ankles lacks the support of the body under it | CrossFit The Thruster ("bar is overhead and roughly in line with the ankles"); CrossFit The Shoulder Press ("does not have musculoskeletal support to support the load" forward of the ankles), paraphrased; the model (hands over the ankles) |
| ExRx pulls the head forward under the bar at lockout | ExRx ("Pull head forward at lockout overhead"); the model (head joint under the hands) |
| The weight tends to finish out in front | CrossFit Potent Tool ("fighting the tendency of the weight to finish out in front") |
| Setup | ExRx (rack or clean, grip slightly wider than the shoulders, bar on the front of the shoulders, elbows slightly forward, torso tight, feet turned out); CrossFit (roughly shoulder-width stance, toes out slightly); the model (feet 39 cm, toes 20° out) |
| Comparison: pressing early | CrossFit The Thruster, as above |

## Dumbbell Thruster

Model facts: a dumbbell in each hand at the shoulders, palms facing in (the left palm faces the
midline), the handles running front to back (each dumbbell 34 cm long along the lifter's forward
axis), the back head of each 0.9-1.1 cm from the lateral and front deltoid: resting on top of the
shoulder; the front head 5.7 cm from the hand, out in front. Elbows 31-35°, pointing down and
forward (upper arms 48° below level standing, 68° at the bottom). The dumbbells leave the shoulders
at ~2.0 s; elbows 59-60° at 2.17 s (knees 175°), 157° at 2.5 s, locked (174°) by 2.58 s, palms still
facing in.

| Claim | Source |
|---|---|
| Dumbbells on the front of the shoulders, palms in, elbows down and forward | The model; ExRx Dumbbell Thruster ("Position dumbbell in front of shoulders with elbows pointing slightly forward and torso tight") |
| Resting on the shoulders they travel with the body; held out in front the arms carry them and they pull the chest forward | Mechanics |
| CrossFit notes the weight tries to pull you forward at the bottom | CrossFit Potent Tool ("At the bottom of the front squat, the athlete fights the weight from pulling them forward") |
| Rest the back end of each dumbbell on the shoulder | The model (back head ~1 cm from the deltoid) |
| ExRx: thighs just past level; CrossFit standard: hip crease below the top of the knees; the lifter stops about 20° above level | ExRx Dumbbell Thruster (same wording as the barbell's); CrossFit The Thruster; the model (thigh line 20.1° above level) |
| A much shallower squat leaves only a short dip to drive from | Mechanics |
| Heels down until the hips and knees have fully straightened; heels lifting early is a thruster fault | CrossFit The Thruster ("The heels remain down until the hips and knees fully extend"; "heels lifting from the floor prematurely") |
| Weight toward the balls of the feet takes work from the glutes and hamstrings | CrossFit The Front Squat ("they decrease the contribution of the powerful muscles of the posterior chain (glutes and hamstrings)") |
| Legs move the load off the shoulders, arms only once the hips and knees are straight; engaging the arms earlier is common, costs load and adds fatigue | CrossFit The Thruster, as for the barbell |
| Lockout overhead roughly over the ankles, the line the body supports | CrossFit The Thruster; The Shoulder Press; the model (hands 3 cm behind the ankle joints) |
| With two dumbbells each arm finds that line on its own | CrossFit The Thruster (dumbbell and kettlebell versions "require the athlete to stabilize each side independently of the other") |
| In a shoulder-press study the standing dumbbell press, the version with the most to steady, drew the most deltoid activity | Saeterbakken 2013 ("the exercise with the greatest stability requirement (standing and dumbbells) demonstrated the highest neuromuscular activity of the deltoid muscles") |
| Setup | ExRx; CrossFit (stance); the model |

## Kettlebell Thruster

Model facts: the hands together in front of the chin (wrist joints 19.2 cm apart), palms facing in,
wrists straight (the brief's 0°), the elbows tucked inside the shoulder line (elbow joints 16 cm out
from the midline against shoulder joints at 19.6 cm), the upper arms against the ribs (their muscle
surface 0.1-0.5 cm from the chest and obliques, `bodycontact.py`), the upper arms 66°
below level standing and 82° at the bottom, elbows 43°. Each bell rests on the outside of the
forearm (0.5 cm from the brachioradialis, 2.4 cm from the upper chest). The press turns the palms
forward: locked out (elbows 174° by 2.58 s), each bell hangs behind the wrist, its centre ~11 cm
behind the hand joint, the hands over the shoulders and 3 cm behind the ankle joints.

| Claim | Source |
|---|---|
| Elbows tucked against the ribs, hands in front of the chin, bells on the outsides of the forearms | The model; ExRx Kettlebell Front Squat ("Hold two kettlebells in front of shoulders, one with each arm positioned close to body"); ExRx Kettlebell Press ("kettlebell against outside of arm"; "Keep arm close to body in bottom position") |
| Tucked in, the arms rest on the trunk and the bells ride the leg drive; flared out, the arms hold the bells away from the body | Mechanics |
| ExRx keeps the supporting wrist straight in both | ExRx Kettlebell Front Squat ("Wrist supporting kettlebell should be held straight"); ExRx Kettlebell Press ("Wrist supporting kettlebell should be kept straight") |
| A straight wrist lets the bell sit on the forearm; bent back, the bell's weight hangs on the bent wrist instead | Mechanics (the bell rests on the forearm in the model) |
| ExRx kettlebell front squat: thighs just past level; CrossFit thruster standard: hip crease below the knees; the lifter stops about 20° short | ExRx Kettlebell Front Squat ("Descend until thighs are just past parallel to floor"); CrossFit The Thruster; the model |
| Legs lift the load off the shoulders before the arms direct it overhead; using the arms first is the timing fault, less weight and more fatigue | CrossFit The Thruster ("the legs elevate the bar off the shoulders on the ascent before relying on the arms to direct the bar into the overhead position"; the early-arms fault, as above) |
| Arms locked overhead, roughly over the ankles where the body is under it | CrossFit The Thruster; The Shoulder Press; the model |
| Palms turn from facing in to facing forward; bells hang behind the wrists | The model |
| Kettlebells and dumbbells as thruster tools | CrossFit The Thruster ("a pair of dumbbells, a pair of kettlebells"; they "may allow for a better rack position") |
| Setup | ExRx Kettlebell Front Squat (feet shoulder width or slightly wider), Kettlebell Press (take the bell from a rack or clean it); the model |

## Clean and Press

Model facts (one rep):
- Start 0-0.42 s: barbell on the floor (plates 45 cm, the bar's centre 22.5 cm up), ankle joints
  22 cm apart (hip-width; the hip joints are 18 cm), toes 15° out, wrist joints 61.4 cm apart (11 cm
  outside each shoulder joint). The bar 1.8 cm ahead of the shoe's midpoint (over the middle of the
  foot), the shoulder joints straight over it (1 cm behind), hips 48°, knees 98°, pelvis 58.5 cm up
  against knee joints at 46 cm (hips above the knees), the trunk 62° from vertical, elbows 156°.
- First pull 0.42-1.08 s: the bar rises past the knees (y 0.49 m at 1.0 s), ~1 cm from the
  tibialis anterior to 0.75 s and 1.6 cm from the quadriceps at the knees (`contact.py`, bar as a
  rod); the knees open to 119°; the back angle steepens from 62° to 36° (the shoulders rise ~26 cm,
  the hips ~11 cm).
- Transition 1.08-1.25 s: the knees re-bend to 109° as the bar passes them (the double knee bend).
- Second pull 1.25-1.67 s: hips 111° -> 167°, knees 109° -> 150-154° (never straight), the heels up
  8.4 cm (onto the toes), the trunk 3° back, the bar to the hips, ~1 cm from the vastus medialis
  at 1.25 s and the rectus femoris at 1.5 s. The elbows stay 156-162° to 1.6 s.
- Pull under and catch 1.67-2.25 s: the elbows bend high and out (upper arms near level at 1.92 s,
  abducted ~58° at 2.0 s), the feet land 8 cm wider (ankle joints 30 cm apart) by 2.0-2.17 s, the
  bar on the front of the shoulders (0.6 cm from the clavicular pectoralis), lowest at 2.25 s: pelvis
  70.2 cm (21 cm below standing), knees 99°, hips 127°, trunk 12° forward. A power clean (thighs
  above parallel; knees short of 90°).
- Stand 2.25-2.67 s; the left foot steps back in 2.9-3.1 s, the right 3.3-3.5 s (ankles 22 cm again).
- Rack 3.5-3.67 s: the bar on the upper chest (0.3 cm from the clavicular pectoralis), the elbows
  down (upper arms 69° below level) and 5 cm in front of the shoulder joints.
- Press 3.67-4.75 s, knees 175° throughout: a strict press. The head joint moves ~2 cm back as the
  bar passes (4.0-4.4 s). Lockout 4.75-5.0 s: elbows 173°, the bar 1.5 cm in front of the ankle
  joints, 2.6 cm in front of the head joint.
- Lowered to the shoulders by 5.6 s (knees soften to 161°), to the thighs with the elbows high and
  out 6.0-7.1 s, hinged to the floor by 7.8 s.

| Claim | Source |
|---|---|
| Bar over the middle of the feet, shoulders over the bar, back flat, hips above the knees | The model; ExRx Power Clean ("Position shoulders over bar with back arched tightly. Arms are straight with elbows pointed along bar"); CrossFit The Power Clean ("keeping the hips higher than the knees and the shoulders higher than the hips. The low back is flat"). CrossFit puts the shoulders slightly in front of the bar; ExRx and the model over it |
| A flat back holds the trunk rigid so the legs' push reaches the bar; CrossFit has the back and trunk brace to pass the force from the floor into the bar | Mechanics; CrossFit The Power Clean ("These muscles contract isometrically to allow for the efficient transfer of forces from the ground into the bar") |
| Grip a little wider than the shoulders; feet hip-width | ExRx ("slightly wider than shoulder width"; "hip width's apart or slightly wider"); CrossFit ("under the hips or slightly wider than hip-width"); the model |
| A bar drifting from the body in the first pull is a common fault: it can pull you forward and blunt the hips in the next pull | CrossFit The Power Clean ("let the bar drift away from the body ... may result in the athlete being pulled forward and may result in an ineffective use of the hips on the second pull") |
| ExRx keeps the bar close to the thighs and lifts it steadily rather than jerking it off the floor | ExRx ("keeping barbell close to thighs"; "Do not jerk weight from floor; arise steadily then accelerate") |
| Here the bar stays within about two centimetres of the shins and thighs | The model (1-1.6 cm from the shin and thigh muscle surfaces at 0.2-1.5 s) |
| Keep the bar close to the shins as it rises and to the thighs once it passes the knees | ExRx ("keeping barbell close to thighs"); CrossFit The Power Clean ("ensure that the bar stays tight to the body"); the model (the bar ~1 cm from the tibialis anterior from the floor, ~1 cm from the quadriceps past the knees) |
| Arms straight through the first and second pulls, pulling only after the hips and knees extend; bending early cuts power, lets the bar drift or the hips stop short | CrossFit The Power Clean ("The arms should remain straight on the first and second pulls ... should only start to pull on the bar after full hip and knee extension"; "power output is reduced, and other faults may occur, like the bar drifting away from the body or lack of hip extension") |
| Here the elbows stay long until the hips open and the heels rise, then bend high and out | The model (elbows 156-162° to 1.6 s; hips 164-167°, heels 8 cm; then elbows high and out). The model's knees reach only ~150°; the copy says the hips and knees drive, not that the knees straighten |
| Elbows high and out to pull under; rise onto the toes | CrossFit ("the athlete's arms bending — elbows high and outside"); ExRx ("Jump upward, extending body"; "allowing elbows to flex out to sides"); the model |
| A power clean is caught in a partial squat, hip crease above the knees; ExRx catches it before the knees pass 90° | CrossFit The Power Clean ("the crease of the hips must stay above the top of the knees"); ExRx ("Catch bar on shoulders before knees bend lower than 90°"); the model (knees 99°) |
| A weak receiving position (chest and shoulders rolling forward, back rounding) is a common fault that makes the bar hard to stand up with | CrossFit The Power Clean ("let the shoulders and chest roll forward, and the back round, making it very difficult to stand up with the load"). CrossFit's list also has low elbows; the model's elbows are low in the rack, so the copy leaves elbows out |
| The feet land a little wider, then step back in before the press | The model; CrossFit ("the feet slide quickly from hip width to shoulder width"; the model lands 8 cm wider, not shoulder-width); ExRx ("The lift is complete when feet are in line and bar is under control") |
| The shoulder press is done without the legs, pressed in a straight line close to the face, finished over the ankles with the arms locked | CrossFit The Shoulder Press ("performed from a standing position, without assistance from the legs"; "pull the chin back ... keep the bar close to their face"; "the arms are locked and the bar is over the ankles") |
| The push press adds a dip and a leg drive | ExRx Push Press ("Dip body by bending knees, hips and ankles slightly. Explosively drive upward with legs") |
| The knees stay straight from the rack to lockout | The model (175° 3.5-5.0 s) |
| Squeeze glutes and thighs | CrossFit The Shoulder Press ("tighten the abdominals, glutes, and quads") |
| Comparison: arms pulling early | CrossFit The Power Clean, as above |
| Setup | ExRx; CrossFit; the model |

## Distinct from the library

The library's Front Squat, Goblet Squat and Kettlebell Goblet Squat stand up and stop; the Push
Press, Dumbbell Push Press and Barbell Overhead Press start standing. A thruster runs the front squat
straight into the press with the legs launching the load (CrossFit), and the clean and press lifts
the bar from the floor first. No sentence of the four entries' copy or setup is shared with another
entry, another spec file or SampleData.swift (`SCRATCH/thruster/dupes.py`).

## Library rows

As given: the thrusters QUADS + SHOULDERS (BARBELL / DUMBBELL / KETTLEBELL), intermediate, legs; the
Clean and Press ANTERIOR DELTOID, BARBELL, advanced, shoulders. They match the primary rows (the
thrusters' quadriceps and anterior deltoid; the clean and press's anterior deltoid listed first). The
library's vocabulary has no full-body word; POSTERIOR CHAIN would undersell the press, so no change.

## Labels

Rows are the final on-screen ones (`ov()` maps them back through spec_500's squeeze). Pill widths and
silhouettes were checked with `overlay.py` on the five reference stills, plate coverage per row over
the whole clip with `rows.py`, then on the lab shots.

- Barbell Thruster: the plates sweep both sides from v ~0.09 (locked out) to ~0.63 (bottom), so
  four labels sit below them (left 0.64 Elbows in front -> right elbow, left 0.80 Legs, then arms ->
  right ankle, right 0.66 Thighs to level -> left hip, right 0.73 Knees over toes -> left knee) and
  Lock out overhead at the top left (0.09) -> right hand; the left-hand plate never rises past v
  ~0.17 in the trainer view. At 0.12 the first lab shot showed the lockout ghost's view (the model
  shrunk and lifted) put the plate under the pill, and at 0.07 the second showed the pill over the
  COMMON MISTAKE chip (which spans v ~0.03-0.06), so the label sits at 0.09 and the lockout ghost is
  turned 0.6 toward the lifter's left, which moves the far plate in from the corner. The leg-drive
  label points at the right ankle,
  the floor end of the drive, so its leader stays off the right calf (to the knee it ran up the
  calf at the bottom).
- Dumbbell Thruster: larger and more face-on; the dumbbells sweep u ~0.26-0.79. Short labels: two
  at the top left (0.12 Arms locked out -> right elbow, 0.19 On shoulders -> right hand, clear of
  the right dumbbell overhead at u >= 0.38), right 0.58 Thighs level -> left hip and 0.80 Heels down
  -> left ankle, left 0.64 Legs first -> right knee.
- Kettlebell Thruster: as the dumbbell's; the bells sweep u ~0.22-0.69 and, locked out, up to 0.93 on
  the right at the top. Top left 0.12 Arms locked -> right elbow and 0.19 Wrists straight -> right hand,
  right 0.52 Elbows tucked -> left elbow and 0.64 Thighs level -> left hip, left 0.64 Legs first ->
  right knee.
- Clean and Press: the plates rise from the floor to overhead and back down both sides, so every row
  but the top left is crossed by a plate for part of the rep (`rows.py`: 0.4-1.9 s of 7.96 s per
  row). Top left 0.09 Strict press -> right elbow and 0.14 Catch, chest up -> right collarbone (no
  plate reaches either; 0.07 covered the mistake chip on the second lab round); right 0.16 Arms long -> left elbow (the right-hand plate passes over it for
  ~1 s at lockout, when the cue is not in play); right 0.58 Flat back -> pelvis and left 0.58 Bar
  close -> right hand (a plate passes over each as the bar rises past in the pull, ~0.4 s, and as it
  is lowered). The first lab shots had the catch label at 0.19 under the left-hand plate at lockout
  and the start label at 0.50 under the right-hand plate through the catch.
- Legends: the three-name primary lines truncate (QUADRICEPS · ANTERIOR DELTOID · GLUTEUS MA..., and
  ANTERIOR DELTOID · TRAPEZIUS · GLUTEUS MAX... on the clean and press), and the fourth secondary
  name (Trapezius on the thrusters, Lateral Deltoid and Forearms on the clean and press) is cut; the
  muscle panel lists every row.

## Ghosts and when to still them

Every cue has a ghost. Moments in `fault_moments_500_thruster.json`; `fault_times.py` reads the
thrusters and the clean and press as `legs` (bottom = pelvis lowest), but the top / lockout by pelvis
height is ambiguous (the pelvis is as high racked at 0 s as locked out), so lockouts and every clean
and press moment are given in seconds.

- Barbell: rack 1.54 s (bottom), `thruster500RackSlipped(lean: 8, forward: 0.12, down: 0.06,
  elbowsBack: 0.15, withBar: true)`: trunk 8° further forward, hands and bar ~11 cm forward and ~12 cm
  lower, elbows 44° -> ~60°. Depth (bottom) `shallow(0.45, withBar: true)`: hips ~27 cm higher (the
  pelvis ~16 cm below standing), knees 62° -> ~110° (review; was 0.3, ~18 cm, knees ~92°). Knees (bottom) `thruster500KneesIn(0.25).seen(0.5)`: knees ~14 cm in, re-seated so the
  thigh and shin keep their lengths and the knee its 62° (the shared `kneesIn` shortened the thigh
  44 -> 40 cm on this rig). Drive 1.88 s (stilled at 1.90 s, rising, knees ~100°) `thruster500PressedEarly(0.3, withBar:
  true)`: hands and bar ~16 cm up, elbows 43° -> ~62°. Lockout 2.9 s `armsTurned(.lateral, -18,
  withBar: true, strength: .whenStraight("forearm_L")).seen(-0.6)` (the Push Press's lockout piece):
  the hands ~16 cm and the bar ~19 cm forward, seen nearly in profile (a total of -1.4), which also moves the far plate
  in from the top-left label.
- Dumbbell: hold 1.54 s `thruster500RackSlipped(lean: 6, forward: 0.18, down: 0.08, withBar:
  false).seen(-0.4)`: hands ~12 cm forward and ~13 cm lower, elbows 31-35° -> ~56-60°. Depth `shallow
  (0.45)`. Heels (bottom) `heelsUp().seen(-0.6)`: heels ~7 cm up, knees forward (62° -> ~54°). Drive
  1.88 s `thruster500PressedEarly(0.35, withBar: false)`: hands ~18 cm up, elbows -> ~60°. Lockout
  2.9 s `armsTurned(.lateral, -18, ...).seen(-0.4)`.
- Kettlebell: rack 1.54 s `thruster500ElbowsFlared(0.3)`: elbows ~15 cm out, hands ~6 cm forward and
  out. Wrists 0.2 s `thruster500WristsBentBack(60)` (palms in, so the hands tip outward; tips ~12 cm;
  the shared `palmsInWristsBentBack`, 40° and ~8 cm, read faintly on the first lab shot). Depth
  `shallow(0.45)`. Drive and lockout as the dumbbell's.
- Clean and Press: start 0.2 s `rdl4BackRounded(.always).seen(-0.5)` (the 351-400 RDLs' piece):
  the lumbar and mid back ~6 cm up off the line of the back, the head ~9 cm lower (pelvis-spine
  11.4 -> 13.9 cm, spine-chest 15.7 -> 14.5 cm). A turns-only family piece (lumbar turned back about
  the pelvis, chest down about the lumbar joint) moved the spine mostly along the line of the tipped
  back and read as no rounding at 40/50/20 and 55/65/25 on two lab rounds. Pull 1.0 s `armsSwungForward(20, withBar: true).seen(-0.4)`: hands
  ~18 cm and bar ~22 cm forward, seen nearer profile (review; was unturned). Extend 1.25 s `thruster500CleanArmsBent(up: 0.3)`: the hands and bar ~18 cm
  higher up the body, the elbows re-seated back and out (161° -> ~99°), an upright-row pull (the
  draft folded the forearms forward about the elbows, a curl that swung the bar ~30 cm out). Catch
  2.25 s `chestDropped(14, withBar: true, strength: .always)`: head ~23 cm and bar ~13 cm forward.
  Press 3.95 s `thruster500PressDipped(0.1)`: hips, trunk and bar ~6 cm lower, knees 175° -> ~136°.
- Checked in the port: no knee or elbow bends backward (the re-seated knees stay forward of the
  hip-ankle line: knees-in, shallow, press dip); bone lengths kept except in the shared shift-based
  `chestDropped` (chest-neck 32.4 -> 33.9 cm, neck-head 10.1 -> 11.3 cm) and `rdl4BackRounded`
  (above).
- The mistake view lifts and shrinks the model, so the overhead load (the barbell's right-hand plate,
  the dumbbells, the bells) sits behind the right end of the COMMON MISTAKE chip in the three
  thruster lockout faults: the open point the round-1 README names for heads.

## Uncertain

- The dumbbell and kettlebell thruster models' knees cave in at the bottom (knee joints 23 cm apart
  over ankles 39 cm apart; each knee 15° inward of straight ahead while the feet point 20° out), a
  fault CrossFit lists. Their copy has no knee cue and does not describe the knees; a builder fix
  (the barbell model's knee track) would let them carry one.
- All three thruster models stop with the thighs 15-20° above level, short of ExRx's thighs just
  past parallel and CrossFit's hip crease below the knee; the copy says close to level, deeper if
  the heels stay down.
- The barbell model holds the bar ~3 cm in front of the front deltoids rather than resting on them;
  the copy says the bar sits at the front of the shoulders by the collarbones.
- The clean and press model catches with the elbows low (CrossFit's receiving position has them
  high) and its knees reach only ~150° in the second pull; the copy leaves both out.
- Every activation fraction is a judgement call; no EMG of these lifts exists.
- ExRx was read through Internet Archive copies.

## Change log

- 2026-10-05, draft: models measured, sources read, copy, setup, ghosts and moments for all four;
  `spec_500.py thruster` OK; `family.sh check thruster` BUILD SUCCEEDED on the first build.
- Before the first shoot: the measured knee track showed the dumbbell and kettlebell knees caving
  in, so the kettlebell knee cue became a depth cue and the dumbbell's trunk cue (whose leader to the
  chest crossed an arm and a dumbbell) a depth cue; the barbell rack copy was changed from "rests on
  the shoulders against the throat" after `contact.py` measured the ~3 cm gap, and the clean's pull
  copy from "a few centimetres" to "within about two centimetres" of the legs.
- Lab round 1 (`family.sh shoot thruster "0.2,1.0,1.54,2.25,2.9,4.9"`, kept in
  `SCRATCH/thruster/round1/`): BUILD SUCCEEDED; trainer labels off the lifters and plates on the
  thrusters. Fixed: the barbell lockout pill sat on the lifted plate in its mistake view (0.12 ->
  0.07); the clean and press catch pill under the left-hand plate at lockout and the start pill under
  the right-hand plate through the catch (catch 0.19 -> 0.12, press 0.12 -> 0.07, start 0.50 ->
  0.58); the clean's back-rounding ghost too faint (40/50/20 -> 55/65/25) and its early-arm ghost
  drawn as a forward curl (now the hands up the body, elbows back and out); the kettlebell wrist
  ghost too faint (40° -> 60°, a family piece). Every other ghost read as its mistake.
- Lab round 2 (`"0.2,1.0,1.54,2.25,4.9"`, kept in `SCRATCH/thruster/round2/`): the new catch and
  start rows clear of the plates at the catch and at lockout; the early-arm ghost now an upright-row
  pull, the wrist ghost readable. Fixed: the 0.07 pills (barbell lockout, clean and press press)
  covered the COMMON MISTAKE chip in their mistake views (now 0.09, the clean's catch 0.14, and the
  barbell lockout ghost turned -0.6); the clean's back-rounding ghost still read as a flat line (now
  `rdl4BackRounded`). Left: at ~1.4-1.7 s, as the bar passes the hips, both clean-and-press 0.58
  pills sit over a plate at once (~0.3 s).
- Lab round 3 (`"0.2,1.54,2.9,4.9"`, kept in `SCRATCH/thruster/round3/`): BUILD SUCCEEDED. The 0.09
  and 0.14 pills clear the mistake chip and, at lockout in the trainer, the left-hand plate; the
  barbell lockout ghost reads in profile with its pill clear of the plates; `rdl4BackRounded` shows
  the clean's start as an arch over the back. Left: in the three thruster lockout faults the raised
  load (a plate, the dumbbells, the bells) sits over part of the COMMON MISTAKE chip, as the
  lifted head does in earlier families' mistake views.

## Review (2026-10-05)

An independent sources and model review of the four files, round 3 of the 401-500 batch. Working
files are in `SCRATCH/thruster/review/`: `m/joints.py` (a fresh dump of every joint and the
equipment boxes from the USD), `m/an.py` (timeline), `m/headbox.py` and `m/bardist.py` (skinned
head-neck extents; bar shaft to shin and thigh muscle distances), `m/rport.py` (the reviewer's own
port of `FaultGhost.solve`) with the family's and the shared pieces in `m/runall.py` and a
bend-direction check in `m/flips.py`; sources in `src/`. The pre-review lab output is kept in
`review/lab_before/`, the review's shots in `review/lab_review1/`.

- Sources reopened: the five Europe PMC records (Gullett 2009, Contreras 2016, Saeterbakken 2013,
  Blazkiewicz 2022, Nagao 2021); authors, year, journal, volume, issue, pages, DOI and PMID all match
  the header, and the populations and findings are as stated (15 healthy trained individuals; 13
  resistance-trained women at their 10RM; 15 men at 80% 1RM, standing barbell vs dumbbell anterior
  deltoid ~15% and medial deltoid ~7% lower, triceps ~39% higher; 20 subjects, seated, 6 kg and 70%
  1RM, no significant differences; 20 trained men at 50/70/90% 1RM). The nine ExRx pages were re-read
  at the cited Wayback snapshots (timestamps match) and CrossFit's Thruster, Potent Tool (Rochet,
  2024), Front Squat, Shoulder Press and Power Clean pages fetched again; every quote in the notes is
  on the page it is attributed to.
- Changed, sources: Gullett 2009's abstract says the front squat was as effective as the back squat
  in overall muscle recruitment, not that it recruited the leg muscles as well (spec comment, header
  and the activation table). The barbell rack's why replaced an unsourced line (kept close, the bar
  rides the drive straight up) with CrossFit's thruster rule that the bar stays connected to the
  body until the legs lift it off the shoulders. A bar forward of the ankles now lacks the support
  of the body under it (the shoulder press guide: no musculoskeletal support), not nothing under it.
  CrossFit's first-pull drift may pull the athlete forward and may make poor use of the hips, so the
  copy says it can pull you forward and blunt the hips; the early arm bend can let the bar drift or
  the hips stop short (cue and comparison), as its page says other faults may occur. The shoulder
  press guide's rack (elbows down and out, slightly in front of the bar) is added to the header: it
  supports the barbell model's elbows-down rack better than the front squat's high elbows.
- Changed, model fidelity:
  - Over the back of your head (barbell lockout and the strict press): at lockout the skinned
    head-neck mesh spans z -11.4 to +9.6 cm (thruster 2.9 s; -11.7 to +9.5 cm clean and press 4.9 s),
    its middle at ~-1 cm, and the bar's centre is at +0.9 cm and +1.5 cm: over the middle of the head,
    which both now say. The head does move ~2.5 cm back as the bar passes and forward under it at
    lockout (thruster 2.08-2.42 s, clean and press 3.75-4.67 s), so ExRx's head-through stays.
  - The clean's catch (knees 99°, hips 127°, pelvis 21 cm below standing) is a partial squat, the
    word CrossFit uses, not a quarter squat (intro and comments).
  - Thruster leg drive: the bar centre is 5 cm above the shoulder joints at 1.92 s (knees 104°) and
    13 cm at 2.0 s (knees 129°), before the knees straighten (175° at 2.17 s), so "keep the bar on
    your shoulders until your hips and knees snap straight" became "until the snap of your hips and
    knees pops it off / lifts them off" (CrossFit: connected to the body until the legs elevate it),
    in all three.
  - The thrusters stop at the bottom for ~0.17 s (pelvis 0.475 m 1.50-1.67 s): "drive up without
    pausing" and "drive up at once" became "drive straight back up".
  - Barbell depth why: "a little above level" became "about 15 degrees above level" (measured 15.2°),
    as the dumbbell and kettlebell entries give their 20.
- Changed, ghosts: the three depth ghosts `shallow(0.3)` -> `shallow(0.45)`. At 0.3 the ghost's
  pelvis sat 25 cm below standing with the knees at 92°, a half squat, against mistakes that say a
  few inches down, a quarter squat and bobbing a few inches; at 0.45 it sits ~16 cm below standing
  with the knees at ~110°. The clean's pull ghost is turned 0.4 toward the lifter's left (a total of
  -1.2): at -0.8 the Bar close pill sat over the left-hand plate in its own mistake view; the drift
  also reads better nearer profile. Its mistake now says the bar drifts out in front of the shins and
  knees on its way up (it is stilled at the knees, 1.0 s, not as the bar leaves the floor).
- Changed, labels: Kettlebell Thruster Wrists flat -> Wrists straight (the cue's own word and the
  library's usual label; an earlier reviewer noted flat can read as palms down). Its right edge,
  u 0.318, stays clear of the right bell at lockout (u >= 0.41) on the lab shot.
- Model re-measured from the rigs, all as the copy and notes state: the thrusters' knees 62°, thighs
  15.2° (barbell) and 20° above level, trunk 24°; heels down all clip (ankle joint 6.9 cm, toe joint
  1.6 cm, constant); the barbell's knees 62.6 cm apart and 25° out over feet at 20°, the dumbbell and
  kettlebell's 22.8 cm apart and 15° in (the open point stands); lockout elbows 174-175°, hands over
  the ankles; barbell rack elbows 8 cm ahead of the bar, upper arms 53° and 67° below level; the
  kettlebell wrists 9° from straight, elbows inside the shoulders, palms turning from in to forward
  2.17-2.5 s as the bells pass the face, each bell ~12 cm behind the hand at lockout; the dumbbell
  palms still facing in at lockout (hand axes). Clean and press: start knees 98°, hips 48°, trunk
  62°, elbows 156°; the double knee bend (119° -> 109°); hips 167°, knees 150-154°, ankle joints
  6 cm up; elbows 156-162° to 1.58 s; the catch 8 cm wider; the left foot steps in 2.9-3.1 s, the
  right 3.33-3.5 s; knees 175° through the press; the bar shaft ~1.0 cm from the tibialis anterior
  and the quadriceps from 0.2 to 1.5 s.
- Ghosts re-solved in the reviewer's port at the lab's still times: every size in the table matches
  (within 1-4 cm; the lockout comments now give the hands ~16 cm and the bar ~19 cm forward, the
  pull's bar ~22 cm); bone lengths kept except the shared `rdl4BackRounded` and `chestDropped`
  (as noted); no knee bend direction flips (knee normals within 23°, the caved knees being the move
  itself); the clean's early-arm ghost turns the nearly straight elbow's bend plane (161° -> 101°,
  the elbows back and out), which a free shoulder allows.
- Activation: anchors re-checked in SampleData.swift (Push Press 0.80/0.58/0.56, Dumbbell Push Press
  0.80/0.60/0.55, Goblet 0.85, Kettlebell Goblet 0.86, Front Squat 0.94, Back Squat glutes 0.62,
  Squat adductor magnus 0.40, Standing Dumbbell Press trapezius 0.36, Barbell Overhead Press
  0.86/0.58, Deadlift 0.76/0.66/0.50/0.85, Barbell Shrug 0.88); every row follows the paint, its level
  matches its fraction, and every fraction is labelled a judgement call. No change.
- Lab (`family.sh shoot thruster "0.2,1.0,1.54,2.9,4.9"`): BUILD SUCCEEDED. The three depth ghosts
  now stand clearly higher than the lifter, the pull ghost's pill is clear of the plates, Wrists
  straight is clear of the bells; the other 16 ghosts and the trainer stills as before. Left as the
  author reported: both clean and press 0.58 pills over a plate at 1.54 s (the bar passing the hips,
  ~0.3 s; the plates sweep both sides from the floor to overhead, so no row below the top left
  stays clear all rep, as the author's `rows.py` found) and Arms long under the
  right-hand plate at lockout; the thruster lockout loads over the COMMON MISTAKE chip.

## Verification (2026-10-05)

A final claim-by-claim check of the four files after the review. Working files are in
`SCRATCH/thruster/skeptic/`: `src/` (the five Europe PMC records, the nine ExRx pages at the cited
Wayback snapshots and the CrossFit Thruster, Potent Tool, Front Squat, Shoulder Press, Power Clean,
Dumbbell and Kettlebell Thruster pages, all fetched again), `m/dump.py` (a fresh dump of every joint
with its world rotation and every equipment part's box, all four rigs, every frame), `m/skin.py`
(the skinned muscle, shoe and head-neck meshes through UsdSkel), `m/tl.py` and `m/tlcp.py`
(timelines), `m/palm.py` (palm normals from the finger joints) and `m/port.py` + `m/pieces.py` + `m/runall.py`
(a separate Python port of `FaultGhost.solve` and the pieces, run at the lab's still times).

Confirmed as written: every citation (authors, year, journal, volume, issue, pages, DOI, PMID) and
the populations; every ExRx and CrossFit quote in the tables, on the page credited; the paint in
`tiers.txt` and each activation anchor in SampleData.swift (Push Press 0.80/0.58/0.56, Dumbbell
Push Press 0.80/0.60/0.55, Goblet 0.85, Kettlebell Goblet 0.86, Front Squat 0.94 with its Hip
crease below the knee label, Back Squat glutes 0.62, Squat adductor magnus 0.40, Standing Dumbbell
Press trapezius 0.36, Barbell Overhead Press 0.86/0.58, Deadlift 0.76/0.66/0.50/0.85, Barbell Shrug
0.88); a fresh Europe PMC search (thruster or clean and press with EMG) still finds no EMG study of
these lifts. Model: the thrusters' timing, bottom (knees 62°, hips 87-89°, trunk 24°, thighs 15.2°
and 20.1° above level, knees 25 and 30 cm ahead of the ankles), heels 0.2 cm off the floor all
clip, feet 39 cm and 20° out; the barbell knees 25-28° out over the 20° feet from 0.75 s to 2.0 s,
the dumbbell and kettlebell knees 13-22° in; the load leaving the shoulders at 1.92-2.0 s (knees
104-129°); lockout hands over the ankles and shoulders, the bar 1.8 cm in front of the middle of the
skinned head (z -11.4 to +9.6 cm); the barbell bar 2.6-2.8 cm off the front deltoids, 3.2 cm off the
clavicular pectorals; the dumbbells' back heads on top of the front of the shoulders; the
kettlebell wrists 9° from straight, upper arms 0.2 cm from the trunk, elbows inside the shoulders,
palms in at the rack and turning forward 2.17-2.5 s, each bell 11-12 cm behind the hand locked out;
the dumbbell palms still in at lockout. Clean and press: start (knees 98°, hips 48°, trunk 62°,
elbows 156°, shoulders 0.6 cm behind the bar, the bar 1.6 cm ahead of the shoe's midpoint on the
foot axis, pelvis 58.5 cm over knee joints at 46 cm), the bar ~1.0-1.2 cm from the tibialis
anterior and the quadriceps from 0 to 1.5 s, the double knee bend, heels 8.8 cm up, elbows long to
1.58 s, the catch (feet 30 cm apart, knees 99°, 21 cm below standing, knees 26° out over feet at
20°), knees 175° through the press, the head ~2 cm back as the bar passes and forward under it at
lockout. Ghosts: all 20 re-solved in the separate port; sizes as the table comments say (rack
hands 11 cm forward and 12 cm lower in world axes, depth pelvis 16 cm below standing with knees
~110°, knees-in 14.7 cm, lockout hands 15.6 cm and bar 19 cm, pull bar 22 cm, extend elbows 161° ->
99°, catch head 23 cm, press dip 5.9 cm and knees 136°); no knee re-seats behind the hip-ankle line.

Changed (text and comments only; no label, cue id, tracked joint or ghost):
- Barbell rack intro: the bar sits at -> is held at the front of the shoulders. The model holds it
  in the palms 2.6-2.8 cm off the front deltoid mesh, not resting on it.
- Depth mistakes: a few inches down / a quarter squat (barbell), a few inches down (dumbbell) and
  bobbing a few inches (kettlebell) -> stopping well short of level / a shallow squat, standing up
  from well above level, bobbing only part of the way down. The ghosts' pelvis sits ~16 cm (6 in)
  below standing with the knees ~110°, more than a few inches; the table comments say the same.
- Barbell knee correct: most of all as you start to stand (no source) -> all the way down and back
  up (CrossFit: keep pushing out on the knees throughout the entire rep; the model's knees track out
  from 0.75 s to 2.0 s).
- Barbell lockout why: ExRx pulls the head forward under the bar -> forward (its words: Pull head
  forward at lockout overhead).
- Barbell comparison mistake note: leaves the work to the shoulders (unsourced) -> starts the arms
  before the legs have finished (CrossFit's definition of the fault).
- Barbell setup: from a rack at about shoulder height -> from a rack (no source gives the height).
- Kettlebell wrist why: the wrist at the end of its range (unsourced) -> the bell's weight hangs on
  the bent wrist instead (mechanics).
- Clean and Press pull correct: sweep it back toward your shins -> keep it close to your shins as it
  rises and to your thighs once it passes your knees. The model's bar is ~1 cm from the shins from
  the floor up; it is never swept back to them.
- Comments: the clean and press lockout over the middle (not the back) of the head, missed in the
  review; the dumbbell and kettlebell elbows lock at 2.58 s, not 2.67 s; the right foot steps in
  3.3-3.5 s; Nagao 2021's upper trapezius appeared to hold the shoulder blades (the abstract's
  hedge); Contreras 2016 found no significant difference, not the same EMG; Saeterbakken 2013's
  dumbbell advantage is in anterior and medial deltoid. Ghost table: the drive ghosts are stilled at
  1.90 s with the knees ~100°, hands ~16 cm (barbell) and ~18 cm (dumbbells, bells) up, elbows to
  ~57-62° (were ~93°, ~17 and ~20 cm, measured at 1.875 s).
- `spec_500.py thruster` OK; `family.sh check thruster` BUILD SUCCEEDED (text and comments only, so no
  new shots; the review's shots are kept in `review/lab_review1/`).

Left open (as the review): the bar ~3 cm off the shoulders in the barbell rack, the caved knees in
the dumbbell and kettlebell models, the thighs 15-20° above level, the clean's low elbows and
~150° knees in the second pull, the clean and press 0.58 pills crossed by a plate for ~0.3 s, and
the thruster lockout loads over the COMMON MISTAKE chip.
