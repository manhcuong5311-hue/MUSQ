# 401-500 folder, round 3: stability ball rollout, body saw and bear crawl (2026-10-05)

Three anti-extension core exercises from the builder's 445-474 exports: 466 Stability Ball
Rollout, 467 Body Saw and 468 Bear Crawl (models `Abs/<Resource>.usdc`). `spec_500_antiext.py`
holds the copy and setup steps (its header lists what each model shows and the full citations),
`Tools/fault-review/faults_500_antiext.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_antiext.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.
`SCRATCH` below is `$LAB/r3` of this session.

## How the models were read

- The rigs straight from the USD with Blender's Python + pxr: `SCRATCH/antiext/rig.py` (every
  joint every frame, with the joints' rotations and the equipment prims' world bounds),
  `measure.py` (angles, positions and heights every 0.25 s), `lumb.py` (the spine's and head's
  offsets in the body's own axes, the BodyFrame the app uses), `skin.py` (lowest points above the
  mat of skinned mesh groups: shoes, fleshed hands, knee region, forearms, elbows, shins, abs,
  pecs, head, glutes, thighs, and for the rollout the gap between each group and the ball's
  surface). The mat (`HG_Mat`) has its top at y 0, so heights are above the mat. Step and limb
  timing for the bear crawl from per-limb windows (a hand or ankle more than 3 mm above its rest
  height or moving along z).
- The motion briefs (`SCRATCH/briefs/<Resource>.md`, `briefs_legs/`), `tiers.txt`,
  `joints.json` and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`). The briefs' trunk lean
  and rep phases were written for upright lifts; for these floor lifts the trunk angle, the hip,
  knee, shoulder and elbow angles, the slide and step distances and the heights were measured
  from the rig.
- Ghosts: `SCRATCH/antiext/ghost.py`, a Python port of `FaultGhost.solve` and `BodyFrame` (with
  the `_bent`/`_straight` roles and the `.up` mirroring), whose projection reproduces
  `joints.json` to the third decimal; `pieces.py` (the pieces in Python), `final.py` (sizes,
  bone lengths, joint angles, lowest point), `gdump.py` + `drawg.py` (ghost over the stills).
- Labels: `preview_500.py antiext` plus `SCRATCH/antiext/overlay.py` (pills at ~24 + 6.4 pt
  per character, wider than gen.py's estimate, the eye button and legend boxed, leaders to the
  probed joint in each still), then the lab shots (`family.sh shoot antiext`).
- Sources: Europe PMC REST records (abstracts) for every study; the full text of McGill 2015
  (the author's copy on backfitpro.com) and Pyka 2017 (open access), read as text with PDFKit;
  NASM, Prehab Guys, ACE, the University of Calgary and OpenStax pages fetched directly
  (`SCRATCH/antiext/src/`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.59 m), clips of 7.96 s at 24 fps, a 1.6 x 2.4 m mat.
- The head is held a little up from the rig's standing neutral in all three: the neck-to-head
  line sits 20-26° toward the back of the chest-to-neck line (the bind pose: ~4°), the same in
  every frame of each clip (rollout 26°, body saw 20°, bear crawl 22°; review's `hd.py`; the draft
  said 15-21° against 1°). So the copy says the head stays about
  in line with the back and does not ask for a tucked chin (NASM's plank cue), which the model
  does not show. The head joint's forward (z) axis points ~36° below level at the rollout's full
  reach, into the ball, and ~24° below level at the start, where it passes just above the top of
  the ball (final check, `skeptic/head.py`; the draft said ~40°). The copy's eyes down toward the
  ball is a rough reading from the joint axes, true of the full reach where the head ghost is
  stilled; the rig has no eye direction.
- Paint (`tiers.json`): rollout, RectusAbdominis and Sartorius bright, DeltoidPosterior and the
  two obliques dim; body saw, RectusAbdominis bright, DeltoidPosterior, the obliques and
  SerratusAnterior dim; bear crawl, DeltoidAnterior and RectusAbdominis bright, the obliques,
  RectusFemoris, the three vasti, Sartorius and the three triceps heads dim. Rows follow the paint
  (bright = PRIMARY, dim = SECONDARY): "Hip Flexors" for the sartorius and "Serratus Anterior"
  (both legend-only, as in the library), "Quadriceps" for the rectus femoris and vasti.
- Legend width: a line holds about 38 characters before it truncates (the stability family's
  shot), so each secondary line here stays at or under 35: rollout OBLIQUES · POSTERIOR DELTOID
  (28), body saw SERRATUS ANTERIOR · OBLIQUES (28), bear crawl OBLIQUES · QUADRICEPS · HIP
  FLEXORS (35). The body saw's dim posterior deltoid and the bear crawl's dim triceps are named
  with the stabilisers instead (see each exercise).
- The studies report %MVIC (or %MVC), which the app's fractions are not, and none studied these
  three exactly as the models do them; every fraction is a judgement call anchored on the
  library's nearest lifts (Ab Wheel Rollout 0.88/0.68/0.48, Plank 0.78/0.56, Push-Up anterior
  deltoid 0.52, Reverse Crunch hip flexors 0.42, Dead Bug rectus 0.68) and the order the studies
  give, as each code comment says.
- Framings: all three three-quarter from the front-left (yaw -0.8), head on the screen's left.

## Stability Ball Rollout

Model facts: kneeling, knees 24 cm apart (hip joints 18 cm) and planted, the knee skin on the mat
at every sampled moment (0.1-0.7 cm at 0, 0.5, 1, 1.75, 2.75, 3 and 5 s); the shoes' toes on the mat, the shins angled ~20° up from the knees. A
66 cm stability ball (`HG_StabilityBall`) under the forearms: the forearm skin within 0.5 cm of
the ball's surface at the same moments, the hands 4-6 cm above it, the wrists 22 cm apart (shoulder joints
39 cm), palms facing in, the elbows inside the shoulders. Start (0-0.42 s): the trunk (pelvis to
neck) 43° above level, hips ~151° (neck-hip-knee), upper arms ~96° from the trunk, elbows ~114°.
Rolls out 0.46-1.21 s (~0.75 s), the ball travelling 53 cm (centre z 0.635 -> 1.165); holds at
full reach 1.25-2.33 s (~1.1 s): hips ~175° (neck-hip-knee; knees, hips and shoulders in one
line), the trunk 28° above level, upper arms ~153° from the trunk, elbows ~147°, the pelvis 25 cm
up (glute skin 18 cm), the knees still down; rolls back 2.38-3.12 s (~0.75 s); rests at the
start 3.17-4.42 s (~1.25 s); rep 2 the same, 4.46-7.12 s. The back keeps a slight constant
rounding (the chest 2.4-4.1 cm toward the back of the pelvis-neck line, the lumbar joint
0.9-1.6 cm), never an arch.

| Claim | Source |
|---|---|
| At full reach knees, hips and shoulders make one straight line | The model (hips ~175°; seen from the side the shoulder joints sit within 1 cm of the knee-hip line); ACE Kneeling ABC's keeps "a straight line from head to knees" on the ball (a related ball exercise) |
| Rolling the ball away lengthens the lever the trunk holds; gravity pulls the hips toward the mat and the lower back toward an arch; the abdominals hold it straight | Mechanics (the trunk spans the knees and the ball, so its weight bends it toward the floor); NASM plank blog (the body saw and walkout "increase the lever length and substantially raise anti-extension demands") |
| In an EMG study of a Swiss ball roll-out the rectus abdominis and obliques worked harder than in most of the ten exercises compared, while the lower-back muscles stayed low | Escamilla 2010 abstract (roll-out upper/lower rectus 63/53%, external and internal oblique 46/46% MVIC, "significantly greater compared to most other exercises"; eight Swiss ball and two floor exercises; "Lumbar paraspinal EMG signal was relative low (less than 10% MVIC) for all exercises") |
| Correct: brace, pull the ribs down, stop before the hips drop | NASM plank blog ("Pull the ribs down"; set ends "Once posture begins to break down—whether the hips sag"); Prehab Guys (bring it back "when you can't go out any further", back flat) |
| Roll out until the hips are straight, about half a metre here | The model (ball 53 cm, hips 151° -> 175°) |
| The further the ball rolls, the longer the lever; opening the hips is what turns the lean into a rollout | Mechanics; the model (the hips open as the ball rolls) |
| Prehab Guys rolls the ball out slowly with a flat back and brings it back when you cannot go further | Prehab Guys Ab Roll Out - Swissball (theprehabguys.com/vimeo-video/ab-roll-out-2/; the draft named it Swiss Ball Core Roll Out, a different page whose notes do not say this) ("slowly roll the ball out while keeping your back flat. Push into the ball and bring it back in when you can't go out any further") |
| Head about in line with the back, eyes down toward the ball | The model (the head ~22° up from the rig's neutral, its forward line toward the ball at full reach; see Shared facts) |
| NASM counts both craning the neck back and dropping the head as alignment errors | NASM plank blog ("Both excessive neck extension and dropping the head can disrupt alignment"). NASM's "Tuck the chin slightly" and "Hold an apple under your chin" are not used: the model's head is a little up, not tucked |
| Mistake: craning the head up to look far ahead; correct: eyes toward the ball, not up at the wall | NASM (excessive neck extension); the ghost tips the neck and head well past the model's ~20° |
| Forearms rest on top of the ball and stay there | The model (forearm skin within 0.5 cm of the ball at every sampled moment) |
| The ball rolls under the forearms, so they carry the upper body as the arms reach overhead | The model (the forearms on the ball all clip, the upper arms ~96° -> ~153° from the trunk); mechanics |
| Prehab Guys puts the forearms and hands on top of the ball, pushes into it to bring it back, keeps the elbows in line with the shoulders | Prehab Guys Ab Roll Out - Swissball ("Place your forearms and hands on top of the ball"; "Push into the ball and bring it back"; "Keep your back flat and your elbows in line with your shoulders at all times") |
| Correct: elbows no wider than your shoulders | The model (elbows 22 cm apart, shoulders 39 cm); Prehab Guys' "in line with your shoulders" read as not wider |
| Tempo: out in about three quarters of a second, hold about a second, back | The model (0.75 s, 1.1 s, 0.75 s, rest 1.25 s; 0.83, 1.2, 0.83 and 1.1 s between 2% and 98% of the ball's travel, final check) |
| A pace you could stop at lets you halt where the back is still flat | Reasoning on Prehab Guys' "slowly" and its stop point. The model's ~0.75 s roll-out is quicker than "slowly" suggests, so the copy gives the model's timing and asks for control, not a slow count (label Control the roll) |
| Setup | Prehab Guys (kneel, forearms on top of the ball); ACE Kneeling ABC's ("lean the body forward at a 45 degree angle and rest the elbows on the top of the ball"; the model's start 43°); NASM (ribs down); the model's knee width |
| Comparison: with the ribs down and the hips in line the abs hold the trunk straight; once the hips sag the long lever bends the body at the hips and lower back; shorten the roll | Mechanics; NASM ("Pull the ribs down"; sagging hips "a loss of anterior core engagement"); Prehab Guys (bring it back when you cannot go further) |

Activation: Rectus Abdominis 0.82 and Hip Flexors 0.40 PRIMARY (bright); Obliques 0.62 and
Posterior Deltoid 0.30 SECONDARY (dim). Judgement calls: the rectus HIGH, under the library Ab
Wheel Rollout's 0.88 (the wheel's longer lever; the library rates the wheel advanced and this
row intermediate), over the Plank's 0.78 (Escamilla 2010: the roll-out among the most active of
ten exercises); the obliques moderate under it in about the EMG's ratio (46 vs 53-63%). The hip
flexors are painted bright, but the one hip flexor measured in the roll-out, the rectus femoris,
was among the lowest (6-10% MVIC, Escamilla 2010); mechanically the hip flexors resist the hips
sagging into extension at full reach (the iliopsoas was not measured), so they stay a primary row
at the lowest moderate value, 0.40, as the calfseat family kept the bright gastrocnemius at 0.40,
and the copy never says they work hard. The posterior deltoid, a shoulder extensor (OpenStax: the
deltoid also extends the arm), holds the arms from being drawn further overhead and helps pull
the ball back (mechanics, not measured): LOW 0.30. Stabilisers: transverse abdominis
(convention, as the library's abs content), latissimus dorsi (not painted, so a stabiliser rather than a row;
Escamilla 2006 found the Power Wheel roll-out among the exercises most active for it, and
Escamilla 2010's conclusion names it for the roll-out and pike, though its results list the
latissimus as greatest in the pike, knee-up, skier, hip extensions and decline push-up, not the
roll-out), gluteus maximus (NASM's plank setup squeezes the glutes; the library Ab Wheel lists it).

## Body Saw

Model facts: forearm plank, forearms parallel and fixed (elbow joints at z 0.40, wrists at 0.65,
34 cm apart, the shoulder joints 39 cm), fists on the mat, forearm and hand skin on the mat
(0.2 cm); the shoes' toes on two sliders (`HG_SliderL/R`, the shoe skin 1.3 cm up, the sliders'
top 1.2 cm), ankles 22 cm apart; knees 171-175°, hips ~173° (neck-hip-knee), the body a straight
line 8° above level (pelvis 25-27 cm up, the glute skin 23 cm), its shape unchanged all clip. The
body slides: at the start (0 s) the shoulders are ~11 cm in front of the elbows (upper arm ~59°
from the trunk, elbows ~71°); it slides back 0.04-1.5 s (~1.45 s) until they are ~11 cm behind
(upper arm ~104°, elbows ~116°), the sliders travelling 22 cm; pause to 2.0 s; forward 2.0-3.5 s
(~1.5 s); pause to 4.1 s; rep 2 the same, 4.1-7.5 s. The pelvis rises ~2 cm mid-slide as the upper
arms pass upright.

| Claim | Source |
|---|---|
| Body straight head to heels while it slides | The model (hips ~173°, the line unchanged); NASM ("coach a straight line from head to heels") |
| Correct: hips in line between the shoulders and heels (label: Hips in line, no sag) | The model (the body one line 8° above level, so the hip joints sit ~8 cm below the shoulder joints: 25-27 vs 33-35 cm). The draft said hips level with the shoulders, which the model does not show |
| Sliding back takes the elbows further in front, lengthening the lever | Mechanics; the model (the shoulders end ~11 cm behind the elbows) |
| NASM names the body saw a harder anti-extension progression for that reason, and reads sagging hips as the front of the core letting go | NASM plank blog ("Body Saw and Walkout Variations: These exercises increase the lever length and substantially raise anti-extension demands, making them appropriate for more advanced clients"; "Sagging Hips: This often indicates a loss of anterior core engagement") |
| Correct: squeeze the glutes, pull the ribs down | NASM ("Squeeze the glutes", "Pull the ribs down"; "Try ... 'Squeeze your glutes.' 'Pull your ribs down.'") |
| Shoulders travel from in front of the elbows to behind them, about 20 cm | The model (22 cm) |
| The further behind, the longer the lever the abs hold | Mechanics |
| An EMG study of a body saw done with the feet in suspension straps, starting from bent knees and sawing back as far as possible: rectus abdominis about 103% of an isometric maximum, serratus anterior almost 140% | McGill 2015 full text (methods: "with the feet suspended in the labile suspension straps, knees bent and the forearms on the ground ... participants were asked to straighten their legs and 'saw' back and forth as far as possible over 2 s", then back "to the original knees-bent position"; so unlike the model it starts with the knees bent; results: "103% for the body saw" in the rectus abdominis, normalised to an isometric MVC, "it is common to measure levels much higher than 100% during dynamic contractions"; "almost 140% MVC activation of the serratus anterior") |
| Correct: move from the shoulders, not the feet | Prehab Guys Plank Body Saw ("push your body back and forth using your shoulder muscles exclusively"; "Don't move your body just by moving your feet!") |
| Forearms planted and parallel, elbows about shoulder-width | The model (34 vs 39 cm); NASM setup ("Forearms are parallel"). NASM's and Prehab Guys' "elbows directly under the shoulders" is the static plank's and the saw's start; the model's shoulders travel from ~11 cm in front of the elbows to ~11 cm behind and are over them only mid-slide, so the cue, its correction and the setup no longer ask for the elbows under the shoulders (review) |
| The forearms are the fixed point the body saws over | The model (elbows fixed all clip) |
| Prehab Guys keeps the elbows from drifting too far in or out | Prehab Guys ("Keep your elbows in line with your hips and feet, don't bring them too far out or in") |
| Knees straight, toes on the sliders | The model (knees 171-175°, toes on the sliders) |
| Straight legs keep the lever long from shoulders to toes | Mechanics |
| Prehab Guys keeps the knees straight and the back flat as the shoulders move the body; NASM engages the quadriceps | Prehab Guys ("keeping your back flat and knees straight, push your body back and forth"); NASM ("Engage the quadriceps") |
| Each slide about a second and a half, a short pause at each end | The model (~1.45-1.5 s, pauses ~0.5-0.6 s) |
| A slow saw keeps the abs holding the line as the lever changes, rather than momentum carrying you through it | Reasoning (mechanics), not a finding of the study: McGill's 2 s / 1 s / 2 s metronome is its protocol, not a test of speed |
| In the EMG study the body saw was timed to a metronome: two seconds out, one second held, two seconds back | McGill 2015 ("as far as possible over 2 s (i.e., 2 beats of the metronome). Once at full extension, the position was held for 1 beat before the participant 'sawed' back ... over 2 beats") |
| Stop the set when the hips start to sag | NASM ("Once posture begins to break down—whether the hips sag, pike, or rotation occurs—the set is complete") |
| Setup | NASM forearm plank setup (forearms parallel, feet hip-width); the model (sliders under the toes, ankles 22 cm apart, elbows 34 cm apart, the shoulders ~11 cm ahead of the elbows at the start) |
| Comparison: glutes tight and ribs down, the abs hold the body straight while the shoulders saw it over the elbows; when the hips sag the longer lever wins and the lower back arches, NASM reads it as the front of the core letting go, so shorten the slide | NASM ("Squeeze your glutes." "Pull your ribs down."; sagging hips "a loss of anterior core engagement"); mechanics (shortening the slide shortens the lever, the copy's own advice) |

Activation: Rectus Abdominis 0.85 PRIMARY (bright); Serratus Anterior 0.66 and Obliques 0.58
SECONDARY (dim). Judgement calls: McGill 2015's (suspension-strap) body saw had the rectus
abdominis at 103% MVC at the peak, so HIGH, between the library Plank's 0.78 and Ab Wheel's 0.88
(the library row rates it advanced); its serratus anterior was the most active muscle measured
(almost 140% MVC) but is painted dim, so it stays secondary, moderate and under the rectus; the
external oblique worked more than the internal in every task (the table's 57 vs 24%), a touch
over the Plank's 0.56. The posterior deltoid is painted dim: a shoulder extensor (OpenStax), it
pulls the body forward over the elbows from the back of the slide (mechanics, not measured); as a
third secondary row the legend would read SERRATUS ANTERIOR · OBLIQUES · POSTERIOR DELTOID (48
characters) and truncate, so it is named with the stabilisers, as the stability family did with
the dead bug's. Stabilisers: posterior deltoid, transverse abdominis (convention), quadriceps and
gluteus maximus (NASM's plank setup engages both).

Note on McGill's Table I: the PDF's rotated column headers come out of order in the text; the
rectus abdominis (103.14) and serratus anterior (138.84) columns are fixed by the text, and the
external and internal oblique (56.98, 24.10) by the text's "external oblique muscles were
activated more than the internal oblique muscles in every task" and their position next to the
rectus; the other columns are not used.

## Bear Crawl

Model facts: on hands and the balls of the feet, knees hovering (the knee skin 3.7-4.0 cm above
the mat with both feet down, ~5-7 cm while stepping), knee joints ~6 cm in front of the hip
joints, hips ~86°, knees ~68°; the back flat and level (the trunk 2-3° above level, shoulder
joints 55 cm and hip joints 52 cm up; the lumbar joint 0.7 cm and the chest 1.7 cm off the
pelvis-neck line); hands 38 cm apart under the shoulders (wrists ~5 cm behind the shoulder line at
rest), the supporting elbows 150-165°, the stepping elbow bending to ~114°. Steps: the RIGHT hand
and LEFT foot forward together 0.29-1.71 s (~14 cm, the hand and ankle lifted ~7 cm), the LEFT
hand and RIGHT foot 2.29-3.71 s, then the same two steps backward, 4.29-5.71 (right hand, left
foot) and 6.29-7.71 s (left hand, right foot), all four down ~0.6 s between steps; the pelvis
travels 14 cm forward (0 -> 4 s) and back (4 -> 8 s). The hips stay level all clip (hip joints at
the same height every frame, no roll), the body turns about the vertical by up to 2.5° and shifts
~1 cm sideways toward the planted hand. The stepping leg's hip flexes from ~86° to ~76°. Logged in
seconds (`ExerciseCatalog.timedExercises` already lists it).

| Claim | Source |
|---|---|
| Knees hover a few centimetres off the mat, under the hips; about 4 cm here | The model (knee skin 3.7-4.0 cm; knees ~6 cm ahead of the hips); Pyka 2017 (knees "directly under the navel", raised "slightly off the ground"); Prehab Guys ("knees about a half inch off the ground") |
| With the knees off the floor the thighs and abs hold the body up instead of the knees resting on it | Mechanics (the knees no longer carry weight); Pyka 2017's rectus femoris (52% in the crawl) |
| In an EMG study of the bear crawl the knees were raised only slightly; raising the hips into the air or dropping the knees counted as lost form | Pyka 2017 methods ("raise their knees slightly off the ground such that a neutral spine is maintained"; "Examples of incorrect form included not maintaining a neutral spine, raising hips into the air, dropping knees to the ground, or bending the elbows") |
| Back flat and level, hips and shoulders at the same height | The model (the trunk 2-3° above level: shoulder joints 55 cm, hip joints 52-53 cm, so about the same height); ACE Bear Crawl ("keeping the back straight and the hips and shoulders at the same height"; ACE starts its crawl from a push-up position with the knees bent, a higher crawl than the model's, so only this line and the alternating limbs are used from it) |
| Calgary lists a sagging lower back and a rounded upper back among the faults | University of Calgary SHRED, Multidirectional bear crawl ("Avoid ... Rounded upper-back ... Sagging lower-back") |
| Prehab Guys: a cup of water on the lower back | Prehab Guys Bear Crawls Forward and Backward ("Pretend you have a cup of water balancing on your low back. Don't let it spill!") |
| Correct: head about in line with the back | Calgary ("Neutral head/neck position throughout the exercise"); the model (the head ~18° up from the rig's neutral, 22° against ~4°, so "about") |
| Hips square while a foot is up | The model (no roll); Calgary ("Hips dipping side-to-side", "Hips square towards floor") |
| Each step leaves one hand and the opposite foot holding you | The model (diagonal pairs step) |
| The trunk muscles stop the hips rolling toward the lifted side | Mechanics |
| In an EMG study of the bear crawl the external oblique was the most active of the four muscles measured | Pyka 2017 Table 2 (crawl: external oblique 140%, rectus femoris 52%, rectus abdominis 24%, erector spinae 12%; each muscle normalised to the largest of its maximal efforts, for the abdominals a resisted sit-up and a twist; the external oblique is the highest of the four in all three versions, 95-171%) |
| Right hand and left foot together, then left hand and right foot | The model (rep order measured); Pyka 2017 (right hand and left foot, then left hand and right foot) |
| Stepping opposite limbs leaves the other diagonal pair holding you; ACE, Calgary and Prehab Guys crawl this way | ACE ("Move the left hand and the right leg forward to start crawling. Alternate the arm and leg movements"); Calgary ("Move opposing arm & leg together in forward and backward directions"); Prehab Guys ("moving on hand and the opposite leg at the same time"); the diagonal support is the model's |
| Crawl back the same way | The model (two steps forward, two back); Prehab Guys ("After a few steps forward, then push backwards"); Calgary (forward and backward) |
| Hands land about under the shoulders, arms nearly straight; each step about 14 cm | The model (wrists ~5 cm behind the shoulder line at rest; while crawling from ~3 cm in front to ~12 cm behind: the right hand lands ~2 cm in front of its shoulder stepping forward and ~12 cm behind stepping back, the left ~5 cm behind both ways; supporting elbows 150-165°, steps 14 cm). The draft said the hands land under the shoulders; about added in the final check |
| Stacked under the shoulders, the arms take the weight straight down | Mechanics |
| The EMG study set the wrists under the shoulders, set each stepping hand half a hand's length from the other, and counted bent elbows as lost form | Pyka 2017 ("wrists placed directly under the shoulders, elbows straight"; "place them back down on the ground half a hands length from the stationary hand"; incorrect form "bending the elbows"). The model's supporting elbows are not fully straight (150-165°), so the copy says nearly straight |
| Correct: push the floor away | NASM plank blog ("Shrugged Shoulders ... Cue: 'Push the floor away.'"), a plank cue applied to the hands' support |
| Correct: take short, slow steps | The model (14 cm steps, each ~1.4 s); Prehab Guys ("Slowly crawl forward"); Pyka 2017 (half a hand's length) |
| Setup | Pyka 2017 (wrists under the shoulders, knees under the navel, raised slightly off the ground); Calgary (knees not too far back from the hips); the model (hands under the shoulders, knees ~6 cm ahead of the hips, toes tucked, two short steps forward, then two back) |
| Comparison: knees just off the mat and the back flat, the shoulders, abs and thighs hold the body still while opposite limbs step; pushing the hips up shortens the lever and takes work off the abs; the EMG study counted hips raised into the air as lost form | Mechanics; NASM on the plank's piked hips ("Clients may elevate their hips to reduce the challenge"), a plank source applied to the crawl; Pyka 2017 ("raising hips into the air" among incorrect form) |

Activation: Anterior Deltoid 0.58 and Rectus Abdominis 0.58 PRIMARY (bright); Obliques 0.54,
Quadriceps 0.50 and Hip Flexors 0.40 SECONDARY (dim). Judgement calls. Pyka 2017's crawl:
rectus femoris 52%, rectus abdominis 24%, external oblique 140% (each muscle to its own largest maximal effort), erector
spinae 12% MVC; no deltoid or triceps was measured. The anterior deltoid holds each arm forward
under its shoulder with the body's weight on it and swings the stepping hand forward (shoulder
flexion; OpenStax: the deltoid flexes the arm), so moderate, a little over the library Push-Up's
secondary 0.52; the rectus abdominis level with it, moderate, under the Plank's 0.78 and the Dead
Bug's 0.68, as Pyka's crawl had the rectus abdominis at only 24%, under the rectus femoris and external oblique (the draft gave the bear crawl's beginner row as the reason, but the Plank and Dead Bug are beginner rows too). The obliques were the most active muscle
in the EMG but are painted dim, so secondary, just under the two bright rows (the stability
family's rule for the bird dog's obliques); the quadriceps hold the bent knees off the floor
(Pyka's rectus femoris 52%; the knee extensors resist the knees sinking, mechanics); the hip
flexors swing each foot forward (the stepping hip flexes ~86° -> ~76°; the rectus femoris is one),
the lowest moderate value. The triceps, painted dim, keep the supporting elbows nearly straight;
a fourth secondary row would read OBLIQUES · QUADRICEPS · HIP FLEXORS · TRICEPS BRACHII (53
characters) and truncate, so they are named with the stabilisers. Stabilisers: triceps, serratus
anterior (Prehab Guys tags its bear crawl with it; legend-only in any case), transverse
abdominis (convention). A single-subject case study (Sánchez Egea 2021, a UMH bachelor's thesis,
bear walk vs bird dog) was read but is not used: one participant.

## Labels

Rows are on-screen rows after spec_500's squeeze (0.16-0.80; overrides through `ov()`). The
overlay used ~6.4 pt per character for the pills (the stability family's measure), wider than
gen.py's 5.6, to check that no leader crosses a pill. Every leader meets its joint from the open
side; the eye button (top right, above ~0.12) and the legend (below ~0.88) are clear.

- Rollout: the ball fills the left of the frame from v ~0.48 to ~0.69 (partly off the left edge
  at full reach), so no pill sits beside it. arms (Forearms on top of ball, to the near hand) 0.22
  left, its leader passing left of the head at the start; head (Head in line) 0.18 right and hips
  (Hips in line, no sag, to the pelvis) 0.34 right, the head pill above so its leader passes left
  of the hips pill's inner end; tempo (Control the roll, to the chest; Slow out, slow back until the review) 0.80 left, below the
  mat, its leader rising through the open space between the ball and the knees; reach (Roll till
  hips straighten, to the near hip) 0.72 right. The tempo label was shortened from "Slow out,
  pause, slow back" so its pill ends left of the reach pill's inner end and its leader clears
  that pill (~16 px). A first layout with two pills on each side at 0.31 overlapped in the middle
  and crossed leaders.
- Body saw: range (Shoulders past the elbows, to the near shoulder) 0.20 left, tempo (Slow, even
  saw, to the head) 0.30 left, the short tempo pill under the long range pill so the range leader
  passes right of it; hips (Hips in line, no sag, to the pelvis; Hips level, no sag until the review) 0.30 right; elbows (Forearms
  planted, parallel, to the near elbow) 0.70 left and knees (Knees straight, to the near knee)
  0.70 right, below the mat. A first layout with tempo above range sent the tempo leader through
  the range pill.
- Bear crawl: back (Back flat and level, to the lumbar spine) 0.24 left; hips (Hips square, no
  rocking, to the near hip) 0.26 right, ending ~0.09 to the right of the back leader's end; pair
  (Opposite hand, foot, to the right hand, which steps first) 0.69 left and hands (Hands under
  shoulders, to the near, left hand) 0.78 left, below the body, the short pair pill above so the
  hands leader rises past its end (~0.05 clear); knees (Knees hover, low, to the near knee) 0.74
  right. The hips cue first pointed at the pelvis, which put its leader's end next to the back
  leader's. Round 1 had the hands pill top left at 0.31 with its leader to the near shoulder: in
  the lifted, shrunk mistake view the shoulder sat right at the pill's end, so it moved below
  the body and points at the hand; the pair label was shortened from "Opposite hand and foot" so
  its pill ends left of the hands leader.

## Ghosts

Measured with the port at the fault's still; distances are joint moves at full strength. On the
ball, in the plank and on all fours the lifter's forward (out of the chest) is toward the floor.
Turns about `.lateral`: positive carries the front toward the head, so for a lifter face down a
positive turn of something lying toward the head lifts it toward the ceiling.

- Rollout (stills 1.75 s, the hold; the hip-sag and stop-short ghosts fade in with the reach,
  `antiExt500Rolled` = hand-to-knee distance 2.15 -> 2.4 torso lengths, ~2.0 at the start, ~2.5 at
  full reach): hips `antiExt500KneelingSag(0.24)` (pelvis ~14 cm toward the floor, to ~13 cm
  above the mat, hips ~148°, lumbar ~7 cm; the knees and chest stay, so the pelvis-to-chest line
  stretches 27 -> ~32 cm, as the library's sag pieces do); reach `antiExt500StopsShort(knees: 18,
  hips: 18, arms: 20)` (all turns: the body 18° up about the knees, the trunk 18° back down about
  the pelvis, the arms 20° toward the trunk; hips ~162°, the pelvis and shoulders ~14 cm up and
  back, the hands ~8 cm nearer and lower; bone lengths kept; seen nearer side-on, `.seen(-0.6)`
  to yaw -1.4, where the bent hips read against the straight line: round 1 in the trainer's
  three-quarter view read only as the body shifted up); head `antiExt500HeadUp(neck: 20,
  head: 50)` (head ~21 cm, neck ~11 cm); arms `antiExt500ElbowsWide(0.25, hands: 0.08)` (elbows
  ~15 cm out, ~6 cm outside the shoulders, hands ~5 cm; the forearm 25 -> 27 cm). Tempo has none.
- Body saw (stills 1.75 s, the back of the slide): hips `antiExt500PlankSag(0.25)` (a copy of
  the chest family's `chest500HipsSag`, which is not in the build when a family is integrated
  alone: pelvis ~15 cm toward the floor, to ~11 cm above the mat, hips ~155°, lumbar
  ~7 cm, knees ~7 cm, feet left on the sliders); range `antiExt500SawShort(ahead: 0.19, rise:
  0.04)` (the body ~11 cm forward, the hips and upper body ~2 cm up, so the shoulders sit over the
  elbows, elbows ~93° instead of ~116°; faded in with the slide, `antiExt500Sawed` = shoulder to
  wrist 0.55 -> 0.75 torso lengths, ~0.53 at the front, ~0.77 at the back; the upper arm keeps its
  length within 1 cm); elbows `antiExt500ElbowsWide(0.2, hands: 0).seen(0.8)` (elbows ~12 cm out,
  the fists where they are; forearm 25 -> 28 cm; seen face on from the review on); knees `antiExt500KneesDropped(0.2)` (knees ~12 cm toward
  the mat, to ~7 cm, bent to ~141°; shin 40 -> 43 cm). Tempo has none.
- Bear crawl: knees (still 2.0 s, all four down) `antiExt500HipsPiked(0.25)` (pelvis ~15 cm
  higher, lumbar ~7 cm, the knees re-seated over the feet ~15 cm higher, hips ~85° -> ~70°);
  back (2.0 s) `lowerBackArched(0.18).seen(-0.6)` (the library piece: lumbar ~11 cm toward the
  floor, chest ~5 cm, the pelvis-to-lumbar line 11 -> ~15 cm; seen nearer side-on, yaw -1.4,
  where the back is a long line: round 1's 0.16 in the three-quarter view barely showed); hips (1.0 s, mid first step) `antiExt500HipsRocked(-25, lift: 0.064)` from the review (the
  hip line rolled 25°, the stepping hip ~4 cm lower and the supporting hip ~4 cm higher, the
  stepping knee re-seated ~4 cm lower, its joint ~5 cm above the mat; the draft's
  `antiExt500HipDipped(-25)` turned it about the supporting hip and put the stepping knee joint
  0.8 cm above the mat, the knee through it; the `_bent` role
  follows the stepping leg for most of each step: L 0.25-2.75 s, R 3.0-4.0 and 5.25-7.75 s, so in
  the first part of the second and the last part of the third step it dips the planted side);
  pair (1.5 s) `antiExt500SameSide(up: 0.15, ahead: 0.15)` (the left hand ~9 cm up and ~9 cm
  forward with the left foot, the elbow re-seated to ~105° and ~6 cm out, the left leg drawn
  alongside; fades in as the left hand-to-foot distance shrinks from ~1.39 to ~1.20 torso
  lengths, so it shows from the first forward step to the second, full from ~1.4 to ~2.7 s, and
  is gone on the way back); hands (2.0 s) `armsTurned(.lateral, 25)` (each hand ~23 cm further forward: the left ~12 cm and the right ~24 cm in front of its shoulder, the right ~6 cm off the mat).
- No ghost goes below the mat; turns keep bone lengths (the stop-short, head, hips-rocked and hands
  ghosts), the shifts stretch some bones a little as noted. No knee or elbow bends backward: the
  resolves re-seat on the side they already bend to (the pair ghost's elbow bends to ~105° the
  way the real stepping elbow bends, ~114°).

## Change log

- 2026-10-05, draft: models measured (rig.py, measure.py, lumb.py, skin.py), sources read,
  copy, setup, ghosts and moments for all three; `spec_500.py antiext` OK. The first
  `family.sh check` failed: the body saw's sag reused the chest family's `chest500HipsSag`,
  which sits in that family's block and is left out when a family is integrated alone, so the
  family now has its own copy (`antiExt500PlankSag`); the second check built.
- Lab round 1 (`family.sh shoot antiext "0,1,1.75,3"`, kept in `SCRATCH/antiext/round1/`): the
  app ran; every trainer still had its pills off the lifter and the ball and the legends on one
  line. Fixed: the bear crawl's hands pill (top left, to the near shoulder) sat on the shoulder in
  the lifted mistake view, so it moved below the body to the near hand, with the pair pill above
  it shortened; the rollout's stop-short ghost read only as the body shifted up and the bear
  crawl's sagging back barely showed in the three-quarter view, so both are seen nearer side-on
  (`.seen(-0.6)`), the sag raised from 0.16 to 0.18.
- Lab round 2 (kept in `SCRATCH/antiext/round2/`): the bear crawl's labels clean at 0, 1, 1.75
  and 3 s (leaders apart, the hands leader clear of the pair pill); the stop-short ghost now shows
  the hips bent against the straight line and the sagging back a clear dip; the other ghosts as in
  round 1.
- Self-review after round 2 (sources and model): the head is not the rig's neutral as the draft
  said but held 15-21° up from it, so the rollout's head cue now says about in line, eyes down
  toward the ball, and drops NASM's tucked-chin cue, and the bear crawl's back cue says about in
  line; Escamilla 2010's results do not put the roll-out among the top latissimus exercises
  (only its conclusion names the latissimus for the roll-out and pike), so the latissimus
  stabiliser note now says so; the bear crawl hands cue quotes Pyka's "half a hands length from
  the stationary hand" as set down half a hand's length from the other hand.

## Review (2026-10-05)

An independent sources and model review of the four files, round 3 of the 401-500 batch. Working
files are in `SCRATCH/antiext/review/` (the four files as they stood before it are kept there);
the lab output after it is in `SCRATCH/antiext/review/lab1/`.

- Sources reopened, fresh: the three Europe PMC records (Escamilla 2010, Escamilla 2006, McGill
  2015: authors, journal, volume, pages, DOI and PMID match the header); McGill 2015's full text
  (methods, Table I, Table II); Pyka 2017's full text and its journal page (citation metadata and
  DOI match); NASM's plank blog, the three Prehab Guys pages, ACE's Kneeling ABC's and Bear Crawl,
  Calgary's Multidirectional bear crawl and OpenStax 11.5, fetched again. Every quote in the claim
  tables is on the page it is attributed to, with the exceptions fixed below.
- Changed, sources: the Prehab Guys rollout quotes (forearms and hands on top of the ball, roll out
  slowly with a flat back, push into the ball and bring it back, elbows in line with the
  shoulders) are from Ab Roll Out - Swissball (`ab-roll-out-2`), not Swiss Ball Core Roll Out,
  whose notes say none of it; the header and tables now name that page and the real URLs
  (theprehabguys.com/vimeo-video/..., not library.theprehabguys.com). McGill's body saw started
  with the knees bent and straightened the legs as the body sawed back; the header, the claim table
  and the Range cue now say so (the cue: a strap body saw starting from bent knees, the rectus
  abdominis about 103% of an isometric maximum, in place of worked above its isometric maximum).
  Pyka normalised each muscle to the largest of its maximal efforts (a resisted sit-up and a twist
  for the abdominals), not the external oblique to a twist; the draft's reason for values over
  100% (so above 100%) was dropped. The bear crawl's rectus abdominis comment gave the beginner row
  as the reason it sits under the Plank and Dead Bug, which are beginner rows too; the reason is
  now Pyka's low 24%.
- Model re-measured with my own dumps straight from the USD (`dump.py`, `dumpR.py`, `m_roll.py`,
  `m_saw.py`, `m_bear.py`, `hd.py`) and the author's `skin.py` (read, then rerun): every angle,
  distance and timing in the copy and the header checks out (rollout 43° -> 28°, hips 151° ->
  175°, ball 53 cm, 0.46-1.21 / 1.25-2.33 / 2.38-3.12 s; body saw shoulders +11 -> -11 cm over the
  elbows, sliders 22 cm, 0.04-1.5 / 2.0-3.5 s; bear crawl right hand and left foot first, steps
  14 cm lifted 7 cm, two forward and two back, hips level every frame, knee skin 4.0 cm at rest).
  Two corrections: the head line is 20-26° (not 15-21°) off the chest-to-neck line against ~4°
  (not 1°) in the bind pose, constant in every clip; fixed in the header and shared facts (the copy
  says about in line either way).
- Changed, copy (model fidelity): the body saw's hips cue said keep your hips level with your
  shoulders, but the model's body is a line 8° above level with the hip joints ~8 cm below the
  shoulders; the label is now Hips in line, no sag and the correction says in line between your
  shoulders and heels. The body saw's elbows correction, why and setup asked for the elbows under
  the shoulders, which the model passes through only mid-slide (the shoulders start ~11 cm ahead
  and end ~11 cm behind); they now ask for parallel forearms about shoulder-width apart, and the
  setup's last step braces with the shoulders a little ahead of the elbows. The rollout's tempo
  label Slow out, slow back did not fit a model that rolls out in ~0.75 s; it is now Control the
  roll (the cue already gives the model's timing). The rollout's reach mistake said the ball barely
  moves while its ghost stops ~8 cm short with the hips bent; it now reads Stopping the roll short,
  with the hips still bent. The bear crawl comparison's lets the back rest the work is now takes
  work off the abs.
- Ghosts re-solved in my own port of `FaultGhost.solve` and `BodyFrame` (`port.py`, `pcs.py`,
  `check.py`; bone lengths, knee and elbow angles and bend direction, lowest joint), at each
  fault's still. Every size in the ghost comments matches within a centimetre; no knee or elbow
  bends backward; the stretches are as noted. Changed: the bear crawl hips ghost turned the pelvis
  about the supporting hip and put the stepping knee joint 0.8 cm above the mat, so the knee
  (its skin ~3 cm under the joint) went through it and the lab shot read as the knee dropping. It
  is now `antiExt500HipsRocked(-25, lift: 0.064)`: the same 25° roll centred near the pelvis, the
  stepping hip ~4 cm down and the supporting hip ~4 cm up, both knees re-seated, the stepping knee
  joint ~5 cm above the mat; checked at 0.75, 1, 1.25, 3, 5 and 7 s (it follows the more bent
  knee, as before). The body saw elbows ghost is now seen face on (`.seen(0.8)`, yaw 0): in the
  three-quarter framing the 12 cm splay ran along the forearms and read only as the arms shifting.
  The hands ghost comment now gives where each hand ends (12 and 24 cm in front of its shoulder at
  2.0 s), not ~23 cm for both.
- Labels and lab: `spec_500.py antiext` and `preview_500.py antiext` OK; `family.sh shoot antiext
  "0,1,1.75,3"`: BUILD SUCCEEDED, the trainer stills as before with the two new labels clear of
  the lifter and the ball, the face-on elbows ghost an open A from shoulders to splayed elbows to
  the fists, the hips ghost a tilted hip line with the stepping knee above the mat; the other
  eleven ghosts unchanged and as described.
- Left as the author reported: the sag ghosts stretch the pelvis-to-chest line (17-28%) as the
  library's sag pieces do; the rollout elbows ghost stays in the three-quarter view (face on, the
  ball would hide the arms); the pair ghost at 1.5 s shows the right hand still ~4 cm up as it
  lands.

## Uncertain

- No EMG of a kneeling forearm roll-out on a ball whose set-up I could read (Escamilla 2010's
  methods are paywalled), of a slider body saw (McGill's hung the feet in straps), or of the
  deltoids in a bear crawl; every fraction is a judgement call.
- The rollout's bright hip flexors sit at 0.40 primary on mechanics while the one hip flexor
  measured (rectus femoris) was among the lowest in the roll-out.
- The body saw's serratus anterior was the most active muscle in McGill's study but is painted
  dim, so it is a secondary row under the rectus.
- The bear crawl's supporting elbows are 150-165° in the model where Pyka set them straight; the
  copy says nearly straight.
- The hips-rocked ghost follows the more bent knee, which is not the stepping leg at the start of the
  second step and the end of the third.

## Verification (final skeptic, 2026-10-05)

A last adversarial pass over every claim and number in the copy, setup steps, comparison notes,
activation comments, the spec header and this file's claim tables. Working files are in
`SCRATCH/antiext/skeptic/` (the four files as they stood before this pass in `skeptic/before/`).

- Sources re-fetched independently, not from the earlier copies: the three Europe PMC records
  (Escamilla 2010, Escamilla 2006, McGill 2015: authors, journal, volume, issue, pages, DOI, year
  and abstract wording match the header); McGill 2015 and Pyka 2017 full text extracted again with
  PDFKit (methods, Table I and II; methods, normalisation, Table 2, incorrect form); NASM's plank
  blog (H. Cherry, 2021, updated 2026-07-25), the three Prehab Guys pages (Ab Roll Out -
  Swissball, Plank Body Saw, Bear Crawls Forward and Backward), ACE Kneeling ABC's and Bear Crawl,
  Calgary SHRED Multidirectional bear crawl and OpenStax 11.5 fetched live. Every quote in the
  claim tables is on its page. McGill's Table I columns re-derived from the text: rectus abdominis
  is the column holding 130.88 / 110.40 / 103.14 (the text's >130%, 110% and 103%), pectoralis
  major the 109.36 beside it (the text's ~110%), serratus anterior the last (138.84), so the
  external and internal oblique are the two after the rectus (56.98, 24.10), external above
  internal in every row as the text says. Library anchors re-read in SampleData.swift (Ab Wheel
  Rollout 0.88/0.68/0.48 and stabilisers, Plank 0.78/0.56, Push-Up anterior deltoid 0.52, Reverse
  Crunch hip flexors 0.42, Dead Bug 0.68 with the posterior deltoid a stabiliser) and the catalog
  ratings (Ab Wheel and Body Saw advanced, Stability Ball Rollout intermediate, Plank, Dead Bug
  and Bear Crawl beginner; Bear Crawl in `timedExercises`); paint re-read in `tiers.txt`.
- Models re-measured with my own scripts straight from the USD (`skeptic/sdump.py`, `roll*.py`,
  `saw*.py`, `bear*.py`, `head.py`, `bind.py`, `sk.py` for skinned points near the knees and the
  forearms' gap to the ball). Confirmed: rollout trunk 43.4° -> 28.4°, hips 151° -> 175°, upper
  arms 96° -> 153°, elbows 114° -> 147°, ball 66 cm travelling 53.0 cm, out ~0.4-1.2 s, held to
  ~2.4 s, back by ~3.25 s, rep 2 four seconds later, knees 24.0 cm and wrists and elbows 21.8 cm
  apart (shoulder joints 39.2 cm), knee skin 0.4-0.5 cm off the mat, forearms 0.3-0.8 cm off the
  ball; body saw forearms parallel, elbows 34.0 cm apart, ankles 22.0 cm, shoulders +11.0 ->
  -11.0 cm over the elbows, sliders 22.0 cm, back 0.12-1.38 s and forward 2.04-3.46 s (2-98%),
  knees 171-175°, neck-hip-knee 173°, pelvis 25.2-27.4 cm, the hip joints ~8 cm under the
  shoulder joints; bear crawl right hand with left foot 0.29-1.71 s, then left hand with right
  foot, the same two backward, steps 14 cm lifted 7 cm, pelvis 14 cm forward and back, hip joints
  level every frame, yaw +-2.5°, sideways +-1.2 cm, trunk 2.3-3.4°, hands 38.1 cm apart, knee
  skin 4.0 cm at rest (3.8 on the planted side, 5-6 on the stepping side), supporting elbows
  150-165°, stepping hip 86° -> 76°. Head: 25.7° (rollout), 19.7° (body saw), 21.7° (bear crawl)
  off the chest-to-neck line against 3.7° in the bind pose. Mat 1.6 x 2.4 m, every clip 192 frames
  at 24 fps.
- Ghosts re-solved with the review's port at each still (`skeptic/gc.py`, the hips ghost with
  `HipsRocked(-25, lift: 0.064)`): every size in the ghost comments matches within a centimetre.
  The lab shots of the review (`review/lab1/`) checked again: every ghost and trainer still as
  described.

Changed in this pass (text only: no label, cue id, tracked joint, ghost or moment changed, so no
lab shoot; `spec_500.py antiext` prints OK and `preview_500.py` gives the same layout as the last
shoot):

- Bear crawl activation comment: it still said the external oblique's 140% was normalised to a
  twist, which the review had fixed only in the header; Pyka normalised each muscle to the largest
  of its maximal efforts (for the abdominals a braced flexion and a right twist). Now says so.
- Rollout Head Position why: NASM says both errors can disrupt alignment, not that they break
  it; the why now says can disrupt.
- Bear crawl Hand Position intro: the hands land about under the shoulders, not under them. The
  right hand lands ~2 cm in front of its shoulder stepping forward but ~12 cm behind it stepping
  back, and the planted left hand sits ~11 cm behind its shoulder mid-crawl; the header and the
  claim table now give that range.
- Header: Escamilla 2010's two other exercises are the crunch and bent-knee sit-up (traditional
  in the abstract, not floor exercises); the head line's gaze a little ahead of straight down did
  not fit the rollout, whose head axis is 24-36° below level, so it now says down and ahead.
- Notes: the rollout head axis ~36° below level at full reach and ~24° at the start (the draft
  ~40°), with what eyes toward the ball rests on; the bear crawl head ~18° (not ~19°) up from the
  rig's neutral; the four-row legend would be 53 characters, not 52; claim rows added for lines
  the tables had missed (the rollout arms why's first sentence, the body saw tempo why's
  reasoning sentence, the bear crawl's short, slow steps and the three comparison notes); the
  rollout tempo row now says the model's ~0.75 s roll-out is quicker than Prehab Guys' slowly, so
  the copy gives the model's timing and asks for control.

Left as they are, with the doubts on record: the body saw's knees are 171-175°, which the copy
calls straight (NASM's and Prehab Guys' word); the rollout's eyes down toward the ball holds at
full reach, while at the start the head's axis passes just above the ball; every fraction is a
judgement call, as the activation comments say.
