# 401-500 folder, round 2: floor and ball crunches (2026-10-05)

Five crunches from the builder's 415-444 exports: 430 Bicycle Crunch, 431 Oblique Crunch, 437 Toe
Touch Crunch, 438 Cross-Body Crunch and 436 Stability Ball Crunch (models `Abs/<Resource>.usdc`).
`spec_500_crunch.py` holds the copy and setup steps (its header lists what each model shows and the
full citations), `Tools/fault-review/faults_500_crunch.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_crunch.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The rigs straight from the USD with Blender's Python + pxr (`SCRATCH/crunch/rig.py`,
  `measure.py`): every 0.25 s the neck-to-pelvis line's angle above the floor ("trunk"), the angle
  of each spine segment (pelvis-spine, spine-chest, chest-neck, neck-head), hip, knee and elbow
  angles, the turn of the shoulder line against the hip line about the trunk axis, the side bend,
  elbow-to-kneecap distances both ways, shoulder-blade (scapula joint) heights and the knee, ankle,
  toe, elbow, hand and fingertip positions. The briefs' trunk lean and rep phases were written for
  upright lifts, so the briefs were used only for the arm and leg angles.
- `extra.py`: the bicycle's free-leg angle and shoe height, the toe touch's fingertip-to-shoe gap
  (skinned hand and shoe meshes); `ball.py` and `ballcontact.py`: the ball's size and place and
  which skinned back meshes lie within 2 cm of its surface.
- Ghosts: `SCRATCH/crunch/cg.py`, the round-1 Python port of `FaultGhost.solve`
  (`calfstand/ghost.py`) plus the `_bent` / `_straight` role names (`BodyFrame.bentSide`: the knee
  bent further), screen sizes through the framing's projection (checked against `joints.json` to
  the third decimal), bone lengths and knee/elbow angles; `pieces.py` mirrors the Swift pieces,
  `gdraw.py` + `paint.py` draw them over the trainer stills.
- Labels: `preview_500.py crunch`, then `SCRATCH/crunch/overlay.py` (round 1's: pills ~24 + 6.4 pt
  per character, leaders to the probed joint over the stills at 0/1/2/3/5 s, the eye button and the
  legend line boxed), then the lab shots.
- Sources: Europe PMC REST records (abstracts; `SCRATCH/crunch/abstracts1.txt`), the full text of
  Oliva-Lozano & Muyor 2020 (only to find Crommert 2021), ExRx and ACE pages through the Wayback
  Machine (`SCRATCH/crunch/exrx/`, `SCRATCH/crunch/ace/`), the StrengthLog, Coach and FitnessVolt
  pages read live on 2026-10-05.

## Shared facts about the models

- One body: neck to pelvis 0.59 m lying flat, 0.52 m curled up (the chord shortens as the spine
  curls), 0.56-0.59 m on the ball. Every clip is 7.96 s at 24 fps.
- Hands behind the head (elbows ~40 degrees, pointing out) on all but the toe touch, whose arms
  reach up straight (elbows 166 degrees).
- In every floor crunch the pelvis and the lumbar segment (pelvis-to-spine joint) never move, so
  the lower back stays on the mat; the copy says so in each lower-back cue.
- The bicycle and cross-body crunches reach the same top pose: trunk ~22 degrees up, the shoulder
  line turned ~42 degrees against the hips, the crossing elbow joint 9 cm from the kneecap (with the
  flesh of both, a touch or near touch), hip 42 and knee 71 degrees on the raised leg.
- Paint (`tiers2.txt`): Bicycle and Cross-Body: ExternalOblique, InternalOblique, RectusAbdominis
  bright, Sartorius dim. Oblique: obliques bright, RectusAbdominis dim. Toe Touch: RectusAbdominis
  and Sartorius bright, obliques dim. Stability Ball: RectusAbdominis bright; obliques,
  RectusFemoris and the three vasti dim. Activation follows it (bright = PRIMARY, dim = SECONDARY):
  the obliques as one "Obliques" row, Sartorius as the legend-only "Hip Flexors" (the library's Abs
  convention), the four quadriceps meshes as "Quadriceps". All names pass `part_of()`.
- Fractions: no EMG of these five lifts as the models do them. Anchors: the library's Crunch (rectus
  abdominis 0.80, obliques 0.45), Russian Twist (obliques 0.76, rectus abdominis 0.52, hip flexors
  0.38), Reverse Crunch (hip flexors 0.42), Side Plank / Wood Chop (obliques 0.78). Moved by the ACE
  study's rankings (below): every lift here that it ranked sits above the traditional crunch (11th of
  13 for both muscles), so its primary rows sit a little above the Crunch's values, except the toe
  touch, whose reaching arms pull the other way (see its section). Each value is a judgement call,
  marked so in the spec's code comments.

## Sources and what each supports

- ACE press release, 14 May 2001 (Wayback 20210101101606), and ACE's "New Study Puts the Crunch on
  Ineffective Ab Exercises" by Mark Anders (results page, Wayback 20040714002104; "How to do the Top
  Ab Exercises Correctly", Wayback 20060823064320): Peter Francis, Ph.D., and Jennifer Davis, M.A.,
  SDSU Biomechanics Lab, 30 healthy adults aged 20-45, 13 exercises, EMG of the rectus abdominis and
  obliques. Rectus abdominis: bicycle maneuver 1st, crunch on exercise ball 3rd, vertical leg crunch
  4th, traditional crunch 11th. Obliques: bicycle 2nd, vertical leg crunch 5th, ball crunch 6th,
  traditional crunch 11th. The ball crunch drew significantly less rectus femoris activity (the
  pages do not say against which exercises). The vertical leg crunch: legs straight up, crossed at
  the ankles with a slight bend in the knee, hands behind the head, chin off the chest. The bicycle:
  lower back pressed to the ground, hands beside the head, elbow to the opposite knee. The
  traditional crunch: a fist's distance between chin and chest. Not peer reviewed; used for
  rankings and descriptions only.
- ACE Exercise Library: Supine Bicycle Crunches, Vertical Toe Touches, Crunch, Stability Ball Sit-ups
  / Crunches (snapshots in the spec header; quotes below).
- ExRx: Crunch, Twisting Crunch, Ball Crunch (snapshots in the spec header). ExRx's Twisting
  Crunch is done with the lower legs resting on a bench; its line that leg elevation keeps the
  pelvis tilted back applies to supported legs, so it is no longer cited for the bicycle's
  unsupported legs (review).
- StrengthLog: Bicycle Crunch, Oblique Crunch. Coach (Hutchings): Crossover Crunch. FitnessVolt
  (Magnante): Cross-Body Crunch.
- Crommert et al. 2021 (JSCR, PMID 29319600): twisting curl-ups, right-side fine-wire EMG; the
  internal oblique (and transversus) higher twisting right, the external oblique higher twisting left,
  the rectus abdominis unchanged by direction, "in keeping with the fiber orientation". The copy's
  wording: the external oblique worked harder when the trunk turned away from its side, the internal
  oblique when it turned toward it (what was measured on the right side). The abstract also says
  that changing the arm position to raise the load raised the EMG of all the abdominal muscles.
- Oliva-Lozano & Muyor 2020 (Int J Environ Res Public Health 17(12):4306, PMID 32560185,
  PMC7345922 full text), a systematic review whose table gives Crommert's static values (% MVIC,
  rectus abdominis / internal / external oblique): straight arms in front 60.8 / 43.5 / 31.4, arms
  crossed on the chest 67.6 / 47.1 / 40.2, hands behind the neck 81.0 / 61.7 / 58.8, twisting
  52.2 / 57.3 / 48.9. Used only for the toe touch's and the oblique crunch's fractions (review).
- Sternlicht et al. 2007 (JSCR, PMID 17530978): ball under the lower lumbar back vs under the
  inferior angles of the scapulae; low beat the floor crunch, high fell below it; moving the ball
  down about doubled the activity (upper and lower rectus abdominis, external oblique).
- Vera-Garcia, Grenier, McGill 2000 (Phys Ther, PMID 10842409): curl-up on a stable surface rectus
  abdominis 21% and external oblique 5% MVC; with the upper torso on a ball 35% and 10%.
- Monfort-Panego et al. 2009 (JMPT, PMID 19362234): safety points, including "do not pull with the
  hands behind the head" and "avoid active hip flexion and fixed feet".
- Juker et al. 1998 (MSSE, PMID 9502361): all sit-ups psoas 15-35% MVC, the curl-up under 10%.
- Andersson et al. 1997 (Eur J Appl Physiol, PMID 9118976): hip flexors (iliacus, rectus femoris,
  sartorius) highly active only when hip flexion lifts the upper body or the legs; used for the hip
  flexor fractions, not in the copy.
- Looked at and not used: Willett 2001 (the trunk curl with a twist drew similar upper rectus
  activity to the plain curl but the most external oblique activity came from the v-sit and reverse
  curl, so it does not support a twisting-crunch claim), Escamilla 2006, Clark 2003, Andersson 1998,
  Workman 2008, Parfrey 2008, Dolenec 2022 (a different ball exercise), Mandroukas 2022.

## Bicycle Crunch

Model facts: shoulders off the mat the whole clip (trunk ~22 degrees, upper back ~45); legs off the
floor; the right leg pushes out (knee 170, hip-to-ankle line ~30 degrees above the mat, the shoe's
lowest point 49 cm up) while the left knee draws in (hip 42, knee 71) and the right elbow reaches the
left knee (0.33-1.0 s), then the other way (1.67-2.33 s), six touches in 7.96 s, ~1.33 s per side,
each held ~0.6 s; between touches (0, 1.33, 2.67 s and so on) both knees pass 120 degrees with no
turn. Lower back and pelvis still.

| Claim | Source |
|---|---|
| Turn the rib cage until the elbow meets the opposite knee | ACE Supine Bicycle Crunches (trunk curls and rotates, elbow touches or nearly touches the opposite knee); ACE how-to (left elbow to right knee, then right to left); the model (9 cm joint to joint) |
| The obliques turn the trunk; in a study of twisting curl-ups the external oblique worked harder turning away from its side, the internal toward it | Crommert 2021 |
| In an ACE-sponsored study of 13 ab exercises the bicycle ranked first for the rectus abdominis and second for the obliques | ACE press release 2001 |
| Lead with the shoulder; right elbow to left knee, then the other way | StrengthLog ("extend your right leg while rotating your torso to bring your right elbow toward your left knee"); the model's order |
| One knee draws in while the other leg pushes out long, both feet off the floor; legs in and out along a straight line as the trunk curls and turns | ACE Supine Bicycle Crunches; the model |
| StrengthLog lists the abs and the hip flexors as its secondary muscles | StrengthLog Bicycle Crunch (Secondary muscles worked: Abs, Hip Flexor) |
| Push the free leg out until the knee is nearly straight, the foot well clear of the mat | The model (170 degrees, shoe 49 cm up); ACE (leg kept elevated) |
| Keep the low back pressed into the floor as the trunk curls and turns; the rotation from the trunk, not the hips; monitor the lower back carefully | ACE Supine Bicycle Crunches ("During the upward and downward movement of your trunk, it is important to keep your low back pressed into the floor / mat", "The rotation should come from your trunk and not your hips", "monitor changes in your low back carefully") |
| If the back starts to lift, slow down | ACE ("control movement speed and monitor changes in your low back carefully"). The second half of the old line (push the free leg out higher) had no source and was removed in verification. |
| Not pulling with the hands behind the head is a safety point; keep the head in line with the upper back | Monfort-Panego 2009; ACE ("Do not pull forward on your head ... maintaining alignment of your head with your thoracic (upper) spine") |
| A gap between chin and chest | ExRx (space between chin and sternum) |
| Slow and controlled, a brief hold each side; ACE ties the controlled speed to getting the most from the exercise and lowering the risk of injury | ACE ("slow, controlled manner", "Hold this up-position briefly for 1-2 seconds", "To maximize the benefits of this exercise and reduce the potential for injury, it is important to control movement speed"); the model holds ~0.6 s, so the copy says "a moment", and "a little over a second for each side" is the model's ~1.33 s. The old second sentence (rushing lets the legs and elbows swing through) had no source and was replaced in verification |

Difference from ACE: ACE starts each side from the floor with the thighs vertical and returns to
the start; the model keeps the shoulders up and the legs moving all set (as StrengthLog's version),
and the setup says so ("keep them up for the whole set").

Activation: Obliques 0.84 and Rectus Abdominis 0.82 (PRIMARY), Hip Flexors 0.40 (SECONDARY).
Stabilisers: transverse abdominis (Crommert measured it working in twisting curl-ups), neck flexors
(the head held up all set, as the library's Crunch), quadriceps (holding the free knee straight).

## Oblique Crunch

Model facts (the user asked which side and how): the crossover crunch. The left ankle rests across
the right thigh 17 cm short of the kneecap (figure 4), the left knee open to the left (67 degrees),
the right foot flat (knee 85). The trunk curls (-5 -> 19 degrees) and turns 31 degrees to the left
with ~1 degree of side bend, so it is a twist, not a side bend, and the knees do not drop to one side
(the legs never move). The right shoulder and elbow come up and across to the midline and stop with
the elbow 54 cm from the left knee. Both reps the same side. Up 0.5-1.0 s, held 1.0-2.4 s, down by
~3.3 s, flat to ~4.3 s.

| Claim | Source |
|---|---|
| Lead with the right shoulder toward the crossed left knee; the upper body lifts diagonally, the shoulder and elbow of one side toward the opposite knee; turn as far as you can | StrengthLog Oblique Crunch ("lift your upper body diagonally, so that the elbow and shoulder on one side of your body move towards the knee on your other side"; "Bend as far as possible"); the model |
| The elbow heads for the knee without needing to reach it | The model (stops 54 cm short); Coach's wording is "so your elbow moves to meet your knee", not a touch |
| Twisting curl-up EMG (external away, internal toward) | Crommert 2021 |
| The shoulders lift with the abs and the torso twists so the elbow moves to meet the knee | Coach, Crossover Crunch ("Contract your abs to lift your shoulders off the mat, without pulling on your neck. Twist your torso so your elbow moves to meet your knee."). Coach lists these as two steps, so the copy no longer credits Coach with doing them together (verification) |
| Here the lift and the turn happen together, and the right shoulder blade stays up through the turn; curl up as you turn | The model (0.5-1.0 s: trunk -0.3 -> 18.6 degrees while the turn goes 7 -> 31; the right scapula joint 6 -> 30 cm, held 1.0-2.5 s) |
| Tailbone and lower back on the mat at all times; the focus is the rib cage drawn toward the pelvis | ACE Crunch (two separate lines; the old so linking them was dropped in verification) |
| Lift without pulling on the neck; some people need to keep space between chin and breastbone, particularly with the hands behind the head | Coach; ExRx Twisting Crunch ("Certain individuals may need to keep their neck in neutral position with space between their chin and sternum, particularly with their hands are behind their heads") |
| Reverse slowly; lower slowly to keep tension on the core | Coach ("Reverse the move slowly back to the start"); FitnessVolt Cross-Body Crunch ("slowly return yourself to the starting position during the negatives to keep the tension on the core"). The old last sentence (holding the turn keeps the obliques working) had no source and was removed in verification |
| Timings (about half a second up, a second or so held, about a second down) | The model (0.5 s, 1.4 s, ~0.8 s) |
| Do all reps on one side, then switch legs | Plain practice for a one-side exercise; the model shows the left ankle crossed only |
| Setup: left ankle across the right thigh just above the knee, left knee open | The model; Coach ("Rest one foot on the opposite knee") |

Activation: Obliques 0.78 (PRIMARY), Rectus Abdominis 0.52 (SECONDARY), judgement calls; the
rectus abdominis row matches Crommert's static twisting curl-up (52% MVIC, against 81% for the
straight curl-up with the hands behind the neck, per Oliva-Lozano 2020's table). Stabilisers:
transverse abdominis, neck flexors.

## Toe Touch Crunch

Model facts: legs about straight up over the hips all clip (hip 86, knees 172, ankles 99 cm up; the
thighs lean ~10 degrees past vertical toward the head and the hip-to-ankle line ~6, the ankles ~9 cm
on the head side of the hips), arms straight reaching up; the trunk curls from flat to ~35 degrees (upper back ~64), the scapula joints
from 6 to 33 cm off the mat, the lumbar segment and pelvis still; the fingertips come up between the
feet to ~4 cm from the shoes. Up 0.25-1.0 s, held 1.0-2.4 s, down by 3.25 s, flat to 4.25 s.

| Claim | Source |
|---|---|
| Curl until the shoulder blades lift completely off the floor | ACE Vertical Toe Touches ("Continue curling upward until your scapulae (shoulder blades) lift completely off the floor") |
| Reaching with the arms alone moves the hands, not the trunk | Plain mechanics; the ghost shows it |
| With the legs held straight up and the hands behind the head, a similar crunch ranked 4th of 13 for the rectus abdominis, the traditional crunch 11th | ACE press release (vertical leg crunch 4th) and ACE how-to (vertical leg crunch: legs straight up, crossed at the ankles, hands behind the head); the hands are now named, since this model reaches with the arms (review) |
| Fingertips a few centimetres from the shoes, between the feet | The model (3.7 cm, hands at x +-4 cm, feet at +-13 cm) |
| Thighs vertical; past vertical toward you shifts weight from the seat into the lower back | ACE ("DO NOT move your thighs beyond this point as it shifts your body weight from your butt into your low back") |
| Knees extended as the legs rise before the first rep, the thighs kept vertical throughout; toes pointing up; knees long but not locked; bent knees drop the feet away from the hands | ACE ("extending your knees until your thighs are aligned vertically ... allowing your toes to point away from your body", "keep your thighs aligned vertically"); ACE how-to (vertical leg crunch: "crossed at the ankles with a slight bend in the knee", for not locked); the model (172 degrees, the legs still) and the knees ghost (172 -> 127, the feet ~30 cm away). Verification removed "so the legs are a fixed target for the hands" and "the legs start moving with each rep", which no source says. Round 1 said ACE straightens the knees and holds them; ACE says extends, and its how-to keeps a slight bend (review) |
| Head in line with the upper back, not flexed too far forward; craning the chin moves the head, not the trunk | ACE ("Maintain your head position aligned with your thoracic (upper) spine and avoid flexing your head too far forward"); the second half is plain mechanics (was adds reach through the neck, not the abs) |
| ACE holds the top position, controls the speed and rolls the trunk up and down | ACE ("hold this up-position briefly for 5 - 10 seconds", "control your movement speed ... roll your trunk upwards and downwards"); ACE's hold is 5-10 s, the model's ~1.4 s, so the correct line says "a second or so". Verification dropped briefly (it read as if ACE's hold matched the model's) and rather than throwing it, and removed the unsourced line about swinging the arms (no number added) |

Difference from ACE: ACE slides the hands up the thighs with the arms low; the model reaches with
straight arms toward the feet (the usual toe-touch crunch). ACE starts each rep with the knees bent and
feet on the floor; the model holds the legs up all set.

Activation: Rectus Abdominis 0.80 and Hip Flexors 0.42 (PRIMARY), Obliques 0.38 (SECONDARY), all
judgement calls. Round 1 had 0.84 / 0.42 / 0.48, which put the dim obliques above the bright hip
flexors and leaned on the ACE ranking of a hands-behind-the-head version; the arms reaching
forward are the lightest arm position in Crommert 2021 (rectus abdominis 61 against 81% MVIC,
external oblique 31 against 59, per Oliva-Lozano 2020's table), so the rectus abdominis now sits
at the Crunch's 0.80 and the obliques under the Crunch's 0.45 and under the hip flexors (review).
Stabilisers: transverse abdominis, quadriceps (the straight knees), neck flexors.

## Cross-Body Crunch

Model facts: knees bent 85, feet flat ~30 cm apart; each rep from flat, one knee draws in (hip 150
-> 42) as the trunk curls and turns ~42 degrees; the opposite elbow meets it (9 cm) over the upper
abdomen; the other foot stays down; held 1.0-2.4 s; back to flat by ~3.3 s; rep 2 the other side
(4-8 s).

| Claim | Source |
|---|---|
| The elbow and opposite knee meet over the middle | FitnessVolt ("bring your left elbow and right knee together directly above your belly button"); the model (the knee over the upper abdomen) |
| The obliques help curl the trunk and also turn it; twisting curl-up EMG | ExRx Crunch (obliques a synergist of the crunch); Crommert 2021 |
| Elbow touches or nearly touches; alternate sides each rep | FitnessVolt ("Return to the starting position and repeat with the right elbow and left knee"); the model |
| Knee and elbow together at the same time | FitnessVolt ("Bring the elbow and knee together at the same time to maximize the muscle contraction"); the second sentence describes the picture |
| Tailbone and lower back on the mat; rib cage toward the pelvis; only one knee rises, the other foot stays planted | ACE Crunch (its feet stay down too, but here one foot leaves the mat, so the feet are no longer cited); the model (the other ankle 7 cm up all rep). The old second sentence (a planted foot keeps the curl and turn in the trunk) had no source and was replaced in verification |
| Never pull on the head; not pulling with the hands behind the head among the safety points | FitnessVolt ("Never pull on your head while performing any variation of a crunch"); Monfort-Panego 2009 |
| Fingertips behind the ears, elbows out | FitnessVolt ("place your fingers behind your ears so that your elbows are pointing laterally") |
| A fist's width between chin and chest | ACE how-to, traditional crunch ("Keep a fists distance between your chin and chest"); the library's Crunch wording; ExRx (space between chin and sternum) |
| Moderate tempo and a slow return keep tension on the core | FitnessVolt |
| Hold a second or so, lower over about a second, rest down | The model (1.4 s, ~0.8 s, ~0.9 s flat) |

Activation: Obliques 0.80 and Rectus Abdominis 0.78 (PRIMARY), Hip Flexors 0.38 (SECONDARY).
Stabilisers: transverse abdominis, neck flexors.

## Stability Ball Crunch

Model facts: a 65 cm ball (centre 32.5 cm up, 44 cm behind the hip joints). At the bottom the back
lies along it from the buttocks to the lower trapezius (lower shoulder blades), the head and shoulders
off it; the hip joints 55 cm up, ~10 cm below the ball's top and in front of it (about 2 o'clock; the
lumbar joint ~1:45, the mid-back joint ~1 o'clock); feet flat, ankles 34 cm apart; knees 96-99;
thighs about level (the knee 6 cm below the hip). The upper back curls (trunk 26 -> 51 degrees above
level, chest-to-neck 22 -> 64) while the lower back and buttocks stay on the ball; the hips sink
~2 cm. The back does not extend over the ball at the bottom (ExRx's version extends it gently; the
copy does not ask for that). Up 0.25-1.0 s, held 1.0-2.5 s, down by 3.25 s.

| Claim | Source |
|---|---|
| Ball under the lower back roughly doubled rectus abdominis and external oblique activity compared with under the shoulder blades, and beat a floor crunch | Sternlicht 2007 |
| ACE sets the mid back on top of the ball with the hips lower on its front | ACE Stability Ball Crunch ("Your mid-back should be positioned on the top of the ball (at 12 o'clock) and your hips should be positioned at 2 o'clock") |
| Head and shoulders free of the ball | ExRx Ball Crunch ("lie back on ball with shoulders and head hanging off"); the model |
| Bottom of the chest toward the top of the pelvis until the upper back leaves the ball; tailbone and lower back stay on it | ACE Stability Ball Crunch |
| Sitting up brings the hip flexors in: every sit-up drew more psoas activity than the curl-up | Juker 1998 (15-35% vs under 10% MVC) |
| Widen the feet for balance; closer together as balance improves, to make it harder (verification dropped only) | ACE Stability Ball Crunch ("widen your base of support by moving your feet apart. As your improve your balance skills, increase the balance challenge ... by moving your feet together"); ACE how-to ("For better balance, spread your feet wider apart. To challenge the obliques, make the exercise less stable by moving your feet closer together") |
| Curl-ups with the upper torso on a ball raised rectus abdominis activity from 21% to 35% of maximum | Vera-Garcia 2000 (the abstract's condition, now named in the copy) |
| Knees about 90, feet hip-width | ACE (90-degree knees, hip-width); the model (96-99, 34 cm) |
| Low-back discomfort if the hips are not bent; a lower hip position on the ball or a smaller ball | ExRx Ball Crunch ("Some individuals may experience low back discomfort if hips are not bent so they must use smaller ball size or lower their hip position on ball") |
| Head in line with a slight chin tuck; no pulling with the hands | ACE Stability Ball Crunch; Monfort-Panego 2009 |

Activation: Rectus Abdominis 0.84 (PRIMARY), Obliques 0.50 and Quadriceps 0.25 (SECONDARY).
Stabilisers: transverse abdominis, neck flexors.

## Labels

All five sit in a middle band, so the labels go above and below it (overrides in the spec; rows
here are on-screen rows). Leaders that end on the head or shoulders cross an arm at some point of
the clip on the floor crunches (the hands are behind the head); no pill sits on the lifter.

- Bicycle (yaw -0.8): legs top left 0.24 to the near (left) foot, which keeps the leader clear of the
  far leg both when the left leg is out and when it is in (the far foot would make the leader cross
  the near shoe); tempo top right 0.16 to the left knee and neck top right 0.27 to the head with a
  short label (Hands never pull), so its inner end sits at 0.668, right of the tempo leader. The
  left knee swings between u 0.44 and 0.61, and when it is drawn in the tempo leader runs straight
  down at ~0.60; with round 1's Hands cradle the head (inner end 0.594) it ran onto that pill's
  anchor at 5.5 s (review). Lower back bottom left 0.76 to the pelvis, rotation
  bottom right 0.76 to the chest, both over the mat. The labels on the legs and the turn are
  side-neutral (Push one leg out long, Shoulder to the knee) because the joints they track are fixed
  while the working side alternates; see the shared request for `_bent` label points.
- Oblique (yaw -0.8): twist top right 0.16 to the right shoulder, neck top right 0.24 with a short
  label (Hands don't pull) so the twist leader passes left of its pill; tempo top left 0.24 to the
  crossed (left) knee; lower back bottom left 0.76, shoulder blade bottom right 0.72 to the right
  scapula.
- Toe touch (yaw -2.3): the legs fill the left and the trunk the bottom right, so the pills sit at the
  top (feet over the hips top left 0.20 to the near foot; legs long top right 0.16 to the far toes),
  right of the body (reach 0.30 to the right hand, Reach by curling up since verification; the head pill at 0.42 is short, Head in line, so it
  stays right of the raised right hand at rest) and bottom right on the mat (tempo 0.80 to the chest).
  The knees cue tracks the far toes because no pill fits beside the knees (the legs fill u 0.17-0.46).
- Cross-body (yaw -0.8): knee top left 0.24 to the near (left) knee; twist top right 0.16 to the
  chest; neck top right 0.24 with a short label (Don't pull the head) so the twist leader passes left
  of it; lower back bottom left 0.76; tempo bottom right 0.76 to the chest. Round 1 tracked the twist
  to the right shoulder and labelled the knee Knee rises to meet it; in rep 2 (4-8 s) the right knee
  and left elbow work, so the leader pointed at the planted left knee and the non-crossing shoulder.
  The knee label now reads Knees take turns rising and the twist tracks the chest (midline).
- Ball (yaw -1.35): ribs top left 0.16 to the chest; ball top left 0.24 (short label, Ball under low
  back) to the lumbar joint, its leader staying left of the ribs leader; hips left 0.32 to the
  pelvis; feet bottom left 0.80 to the near ankle; neck top right 0.20. Round 1 had the hips pill at
  0.42: clear of the thighs in the trainer view, but in the mistake view (the model shrunk and
  lifted) it sat on them.

## Ghosts

Pieces are prefixed `crunch500`. Role names: the bicycle and cross-body crunches alternate, so the
raised knee is `_bent` (bent further, `BodyFrame.bentSide`) and the crossing elbow sits on the
`_straight` side; the oblique crunch keeps the left knee bent all clip, so the same pieces read the
left knee and right elbow.

| Exercise | Cue | Ghost, measured on the rig | Moment |
|---|---|---|---|
| Bicycle | twist | `crunch500Unturned(-40)`, seen from the feet (`crunch500FromFeet`, view 0.8): chest, head and arms turned 40 degrees back toward the ceiling (shoulder line 42 -> 2 degrees against the hips), the crossing elbow swung ~22 cm back across the midline, 9 -> ~21 cm from the kneecap (round 1 said 16; re-measured in review), shoulders level (each ~13 cm); shown only near a touch (elbow-knee under 0.75 torso lengths); ~43 pt | 0.67 |
| Bicycle | legs | `crunch500FreeLegBent(-60)`: the straighter knee 170 -> ~117 with the leg out (foot ~36 cm lower), ~100-109 as the legs cross | 0.67 |
| Bicycle | low | `lowerBackArched(0.18)`, seen from the side (`crunch500Side`, view -0.55, yaw ~-1.35; review): lumbar joint ~9 cm, chest ~4 cm toward the ceiling, ~18 pt | 0.67 |
| Bicycle | neck | `headYanked` (library) | 0.67 |
| Oblique | twist | `crunch500Unturned(-28)`, seen from the feet, strength by right elbow to left knee 1.6 -> 1.1 torso lengths: 31 -> ~1 degree, right shoulder ~9 cm lower, ~34 pt | 1.5 |
| Oblique | lift | `crunch500Uncurled(12)`, same strength: trunk 12 degrees back toward the mat (18.6 -> ~6.6, about half the curl), head ~13 cm and shoulders ~9-11 cm lower, the right elbow still ~52 cm up (verification re-measured) | 1.5 |
| Oblique | low, neck | `lowerBackArched(0.18)` seen from the side, `headYanked` | 1.5 |
| Toe touch | reach | `crunch500Uncurled(18)`, strength hand-to-ankle 0.7 -> 0.4: trunk and arms 18 degrees back, hands ~24 cm short, ~56 pt, from the framing (side-on, round 2, the hands rose under the label's pill); the other three toe touch ghosts are seen side-on (`crunch500ToeSide`, view 0.95) | 1.5 |
| Toe touch | legs | `crunch500LegsTipped(20)`: feet ~29 cm toward the head | 1.5 |
| Toe touch | knees | `crunch500KneesBent(-45)`: 172 -> ~127, feet ~30 cm away from the head | 1.5 |
| Toe touch | neck | `crunch500HeadCraned(-40)`, drawn to `head.tip` (0.2 torso lengths up the head bone, ~9 cm, toward the crown): crown ~13 cm | 1.5 |
| Cross-body | twist | as the bicycle, seen from the feet, ~45 pt | 1.5 |
| Cross-body | knee | `crunch500KneeLeftLow(-45)`: raised thigh back toward the feet (hip 42 -> ~87), knee ~34 cm further from the chest | 1.5 |
| Cross-body | low, neck | `lowerBackArched(0.18)` seen from the side, `headYanked` | 1.5 |
| Ball | curl | `crunch500SatUp(22)`, strength hand-to-knee 1.86 -> 1.76 torso lengths (~1.92 at rest, ~1.77 at the top, so strength ~0.9 there): lower back ~4 cm off the ball, head ~23 cm (verification re-measured; was 5 and 28) | 1.5 |
| Ball | feet | `crunch500FeetTogether()`, seen `faceOn`: ankles 34 -> ~11 cm apart, knees ~9 cm in each, bones re-seated | 1.5 |
| Ball | hips | `crunch500HipsBridged(0.2)`: hips ~11 cm up, knees 96 -> ~115 | 1.5 |
| Ball | neck | `headYanked` | 1.5 |

The two-half-turn trick: a turn about one hip joint mirrors with the side (a right-side pivot
mirrors `.up` turns), so turning half about the straight-leg hip and half the other way about the
bent-leg hip turns the whole way in the direction that undoes the model's turn on either side, about
an axis ~2 cm from the middle of the hips (checked on both sides of the bicycle and cross-body
rigs). No cue about tempo or where the ball sits has a ghost.

Views (lab round 1): the turn ghosts were first shot from the framing (yaw -0.8), plus test cues
from behind the head (view -1.5) and from the feet (view 0.8). From the framing and from behind the
head the ghost's shoulder line and crossing arm lay over the real arms behind the head and read as a
tangle; from the feet the squared shoulder line runs straight across a body that is visibly turned,
so all three turn ghosts use view 0.8. The toe touch's ghosts were shot from the behind-the-head
framing and a side-view test of the legs ghost (view 0.95); side-on the legs' tip and the knee bend
run across the screen, so the legs, knees and neck ghosts use it (round 2). The reach ghost was tried
side-on too, but there the hands rose under the reach label's pill, so it stays on the framing, where
its lowered arms read beside the real ones (round 1's shot).

## Library rows

The rows (OBLIQUES for the bicycle, oblique and cross-body crunches; RECTUS ABDOMINIS for the toe
touch and ball crunches; BODYWEIGHT except SWISS BALL; all beginner) agree with the paint and the
sources (StrengthLog: primary obliques for the bicycle and oblique crunches). ACE's exercise library
lists its Supine Bicycle Crunches and Vertical Toe Touches as intermediate; the rows are left as they
are (a judgement for the library's owner, reported).

## Uncertain

- The ACE study is a press release and magazine article, not a peer-reviewed paper; its rankings
  are used only to place the fractions and in two "why" lines, worded as an ACE-sponsored study.
- Crommert 2021 recorded only the right side; the copy states what was measured there.
- Every fraction is a judgement call (see Shared facts).
- The turn ghosts turn the upper body about the neck-to-pelvis chord. The curled upper back lies
  off that chord, so the ghost's chest joint also shifts ~8 cm sideways (5 cm on the oblique
  crunch). Seen from the feet it is a slight bend in the ghost's spine; left as it is (found in
  review).
- The toe touch model's thighs lean ~10 degrees past vertical toward the head (the hip-to-ankle line
  ~6, the ankles ~9 cm on the head side of the hips; found in verification). ACE warns against
  moving the thighs beyond vertical. The copy now says the legs point about straight up and keeps
  ACE's warning; the legs ghost tips them a further 20 degrees. A builder fix (thighs at vertical)
  would make the model match ACE exactly.

## Lab rounds

- Round 1 (`lab500.sh shoot crunch "0,1.5,2,5.5"`, lock 00:36, BUILD SUCCEEDED first time; saved in
  `SCRATCH/crunch/round1/`): every label off the lifter in the trainer stills. Ghosts: the leg, knee,
  lower-back, neck, ball and toe-touch leg/knee ghosts read; the three turn ghosts, shot from the
  framing plus test cues from behind the head (`twistB`, view -1.5) and from the feet (`twistC`, view
  0.8), read only from the feet; the toe touch's ghosts lay over its legs and arms from behind the
  head (a side-view test, `legsB`, read better); the ball crunch's hips pill (0.42) sat on the thighs
  in the mistake view, where the model is shrunk and lifted; the cross-body's knee and twist leaders
  pointed at the near knee and right shoulder, which do nothing in rep 2. Test cues removed.
- Round 2 (`"0,1.5,5.5"`, lock 00:53; `SCRATCH/crunch/round2/`): turn ghosts from the feet, toe touch
  ghosts side-on, ball hips pill at 0.32, cross-body labels side-neutral. All read, except that
  side-on the toe touch's reach ghost and real hands rose under the reach pill; that ghost went back
  to the framing.
- Round 3 (final, `"0,1.5,5.5"`, lock 01:18, BUILD SUCCEEDED; `SCRATCH/lab/crunch/`, copied to
  `SCRATCH/crunch/round3/`): all 15 trainer stills and all 20 ghosts checked. Every pill sits off the
  lifter and the moving legs in the trainer view and in each mistake view; each ghost shows its
  mistake, attached to the lifter, with no limb through the mat or ball and no joint bent backward.
  Weakest reads, left as they are: the lower-back arches (~17 pt) and the toe touch's head nod
  (~36 pt) are small, and the turn ghosts need the squared shoulder line to be read against a body
  partly behind the legs.
- Round 4 (review, `"0,1.5,5.5"`, lock 01:52, BUILD SUCCEEDED; `SCRATCH/lab/crunch/`, copied to
  `SCRATCH/crunch/round4_review/`): the bicycle's Hands never pull pill sits clear of the tempo
  leader at all three stills. The three floor crunches' lower-back ghosts, now side-on, show the
  spine along the back with the lumbar joint lifted over its dashed guide from the mat. The oblique
  crunch's new low and neck mistake texts show under their ghosts. All 15 trainer stills and 20
  ghosts were checked again, with no crash.
- Round 5 (verification, `"0,1.5,5.5"`, lock 02:15, BUILD SUCCEEDED; `SCRATCH/lab/crunch/`, copied to
  `SCRATCH/crunch/round5_skeptic/`): the toe touch's reach pill, now Reach by curling up (19
  characters, as before), sits where Curl up, then reach sat, its leader to the right hand; all 15
  trainer stills keep every pill off the lifter. All 20 ghosts were checked again with the new
  mistake texts under them, with no crash.

## Self-review (sources, then model)

- Sources: every record re-opened (the Europe PMC abstracts in `SCRATCH/crunch/abstracts1.txt`; ACE,
  ExRx pages saved under `SCRATCH/crunch/ace/` and `exrx/`; StrengthLog, Coach and FitnessVolt read
  live). Softened in review: the oblique crunch's comparison no longer says a straight lift leaves the
  obliques doing little (Crommert's straight curl-ups drew 59-62% MVC from the obliques, per Oliva-Lozano
  2020's table); the cross-body's rotation line says the obliques help curl and also turn the trunk
  (ExRx lists them as the crunch's synergist) instead of that turning is what brings them in; the ball
  crunch's sitting-up lines say it brings the hip flexors in (Juker measured psoas, not a hand-off);
  the toe touch's head cue no longer asks the eyes to watch the feet, which would push the head
  forward against ACE's cue. The ACE study is named as ACE-sponsored and used only for rankings.
- Model: copy, setup and labels checked against the measurements above: which elbow goes to which
  knee and when, the bicycle's shoulders staying up, the cross-body's planted foot and its rest on the
  mat, the oblique crunch's crossed left ankle and one-sided turn that stops short of the knee, the toe
  touch's still legs and its fingertips' gap to the shoes, the ball under the lower and middle back with
  the head and shoulders free and the hips below the ball's top; the timings in the tempo cues are the
  clips'. No sentence of cue, setup or comparison copy repeats within the family or with the library
  (checked by script; one shared setup step was reworded).

## Review (2026-10-05)

An independent review of the four files, sources first and then the models.

- Sources: all six journal records re-opened on Europe PMC (Crommert 2021, Sternlicht 2007,
  Vera-Garcia 2000, Monfort-Panego 2009, Juker 1998, Andersson 1997). Authors, journal, year,
  volume, pages, DOI and PMID are all correct, and each abstract says what the copy claims. The
  web sources were re-fetched: the ACE press release (Wayback 20210101101606: 30 adults aged
  20-45, the rankings as quoted), the ACE results and how-to pages (2004 and 2006 snapshots), the
  four ACE Exercise Library pages and the three ExRx pages (their cited Wayback snapshots),
  StrengthLog's bicycle and oblique crunch pages, Coach's crossover crunch (Hutchings, updated
  4 July 2022) and FitnessVolt's cross-body crunch (Magnante, published 23 Nov 2020, updated
  11 Aug 2024). Each says what the notes quote.
- Changed (sources): the bicycle's lower-back line no longer cites ExRx's leg-elevation comment,
  which is about lower legs resting on a bench, not legs held up. It now cites ACE's own lines
  (low back pressed down through the curl and turn, rotation from the trunk, watch the low back),
  and the push the leg higher advice is marked in the notes as coaching, not a sourced claim. The
  toe touch's ACE ranking now says the hands were behind the head in that study, since this model
  reaches with the arms. The toe touch's knee line says ACE extends the knees as the legs rise and
  keeps the thighs vertical; round 1 said ACE straightens and holds them, and ACE's how-to keeps a
  slight bend.
- Changed (activation): the toe touch went from Rectus Abdominis 0.84, Hip Flexors 0.42, Obliques
  0.48 to 0.80 / 0.42 / 0.38 LOW. Round 1 put the dim obliques above the bright hip flexors, and it
  leaned on ACE's ranking of a hands-behind-the-head version. Crommert's arm positions (the table
  in Oliva-Lozano 2020, added to the sources) show straight arms in front drawing much less
  abdominal EMG than hands behind the neck. The oblique crunch's rectus abdominis 0.52 now also
  cites Crommert's static twisting curl-up (52% MVIC). Every other row was checked against the
  paint (`tiers2.txt`: bright = PRIMARY, dim = SECONDARY) and the HIGH / MODERATE / LOW bands.
- Changed (model fidelity): the oblique crunch's curl-height cue said curl first, then turn. The
  model curls and turns together (0.5-1.0 s: trunk -0.3 -> 18.6 degrees while the turn goes 7 ->
  31), so the cue now says lift as you turn. Two oblique mistake texts now match their ghosts:
  low was Arching the lower back or rolling the hips over, while the ghost only arches, and neck
  was Pulling the head across with the right hand, while the ghost (`headYanked`) pulls it forward.
  The bicycle and cross-body turn comments said the ghost elbow ends ~16 cm from the knee;
  re-measured, it ends ~21 cm away (it swings ~22 cm back across the midline).
- Re-measured and confirmed with the rigs (the author's `measure.py` tables, spot-checked, and
  `rv/check.py` and `rv/tw.py` in `SCRATCH/crunch/`):
  - the bicycle's order: right elbow to left knee first, six touches, the shoulders up all clip;
  - the cross-body's timing: up 0.5-1.0 s, holds to 2.5 s, flat 3.25-4.25 s, rep 2 mirrored, the
    other foot planted (ankle 7 cm up);
  - the oblique crunch's crossed left ankle, its 31-degree turn to the left with ~1 degree of side
    bend, and its right elbow stopping over the midline 54 cm from the knee, both reps;
  - the toe touch's still legs (knees 172) and its 1.0-2.5 s hold;
  - the ball at 2 o'clock under the hips (centre 32.5 cm up, 44 cm behind them), the lumbar
    segment still on it and the hips sinking 2 cm.
  Every ghost was solved every 1/6 s across its clip: no bone changes length, no knee or elbow
  bend reverses (checked even where only a neighbour moves), no joint goes more than 1 cm below
  the mat and no ghost joint enters the ball.
- Labels: the bicycle's head pill is now Hands never pull. With Hands cradle the head (inner end
  0.594), the tempo leader to the left knee ran straight down onto that pill's anchor whenever the
  knee was drawn in (5.5 s). Checked and kept:
  - the cross-body's knee leader points at the planted left knee in rep 2 (needs the `_bent` probe
    point, shared request);
  - the toe touch's head leader crosses the raised right arm while the lifter lies flat (0-0.25 and
    3.25-4.25 s), as other leaders to the head cross an arm on the floor crunches.
- Ghosts: the three floor crunches' lower-back arches are now seen from the side
  (`crunch500Side`, view -0.55). From the framing the spine was foreshortened to ~35 pt and the
  ~18 pt lift read as a kink; side-on the spine runs ~50 pt along the back (round 4). Kept, with
  the author's reasons: the turn ghosts from the feet, the toe touch's reach ghost on the framing
  and its other three side-on, and the small toe touch head nod. The turn ghosts' sideways chest
  shift is noted under Uncertain.

## Verification (2026-10-05)

A final adversarial pass over every claim and number in the copy, the activation comments and the
source list. Every source was re-opened independently (scripts and saved pages in
`SCRATCH/crunch/sk/`): the seven Europe PMC records (Crommert 2021, Sternlicht 2007, Vera-Garcia
2000, Monfort-Panego 2009, Juker 1998, Andersson 1997, Oliva-Lozano 2020 plus its full-text table of
Crommert's values, column order RA / IO / EO / TA confirmed from its text), the ACE press release,
results page and how-to page, the four ACE library pages and three ExRx pages at their cited
Wayback snapshots, StrengthLog's two pages, Coach (Hutchings, last updated 4 July 2022) and
FitnessVolt (Magnante, 23 Nov 2020 / 11 Aug 2024) live. Library anchors (Crunch, Reverse and
Decline Crunch, Russian Twist, Side Plank, Cable Wood Chop) and the paint were re-read. The rigs
were re-measured with Blender's Python (`sk/m1.py` to `m7.py`) and the ghosts re-solved with the
round-1 port (`sk/g1.py` to `g7.py`).

Changed (sources):
- Monfort-Panego 2009's safety point is avoid active hip flexion and fixed feet, not with fixed feet
  (spec header and notes).
- ACE's results page does not say against which exercises the ball crunch drew less rectus femoris
  activity; the ball activation comment no longer says than in the other exercises.
- Oblique curl-height why: Coach lists lift, then twist as two steps, so it is no longer credited
  with a curl and a turn together; the copy now says Coach lifts and twists, and that here (the
  model) the two happen together with the right shoulder blade up through the turn.
- Oblique lower-back why: ACE's two lines are no longer joined by a so; oblique neck why: ExRx says
  certain individuals may need space between chin and sternum, so the copy says some people need it
  rather than that ExRx suggests it.
- Cross-body lower-back why cited ACE's crunch keeping the feet on the mat, while this lift raises a
  knee; it now cites only the tailbone and lower back, and the unsourced line that a planted foot
  keeps the work in the trunk is replaced by the model fact (one knee rises, the other foot stays
  planted).
- Ball feet why: ACE does not say only; moving the feet together is to make it harder. Vera-Garcia's
  21% -> 35% is now named as curl-ups with the upper torso on a ball, the abstract's condition (the
  full text was not reachable; the abstract does not give the ball's exact place). Ball hips why:
  ExRx's fix is a lower hip position or a smaller ball.
- Bicycle legs why: StrengthLog lists the abs and the hip flexors as secondary muscles (was as
  working with the abs). Bicycle lower-back why: ACE says monitor the low back carefully, not
  throughout.
- Removed as unsourced: push the free leg out higher (bicycle lower-back correct; ACE supports only
  slowing down), rushing lets the legs and elbows swing through (bicycle tempo; replaced by ACE's own
  reason, getting the most from the exercise and lowering the risk of injury), holding the turn keeps
  the obliques working (oblique tempo), the legs as a fixed target and the legs moving with each rep
  (toe touch knees; now bent knees drop the feet away from the hands, which the knees ghost shows),
  swinging the arms turns the reach into momentum and rather than throwing it (toe touch tempo), and
  adds reach through the neck, not the abs (toe touch head; now moves the head, not the trunk). The
  toe touch tempo why no longer says ACE holds the top briefly, which read as if ACE's 5-10 s hold
  matched the model's ~1.4 s; no new number was added.

Changed (model fidelity):
- Toe touch reach label Curl up, then reach -> Reach by curling up: the arms stay at ~166 degrees and
  ~71-83 degrees above the floor while the trunk curls; there is no reach after the curl (lab round 5).
- Mistake texts matched to their ghosts, re-solved: bicycle twist (the ghost barely turns, ~2
  degrees, elbow ~20 cm from the knee: was Turning only partway ... well short); bicycle neck
  (headYanked pulls the head forward, not toward the knee); oblique lift (the ghost is the trunk at
  ~6.6 degrees instead of 18.6, about half the curl, the shoulders ~9-11 cm lower and the right elbow
  still ~52 cm up: was shoulders barely off the mat and the elbow near the floor); toe touch reach
  (ghost shoulder blades ~20 cm up against 6 lying and 33 at the top: was stay near the mat);
  cross-body knee (the ghost lowers only the knee, ~42 cm from the elbow, the elbow does not move:
  was reaching the elbow all the way down to it); ball feet (the ball's rolling is not shown or
  sourced: now a narrow base on the ball).
- Toe touch legs: the model's thighs lean ~10 degrees past vertical toward the head (hip-to-ankle
  ~6, ankles 9 cm on the head side of the hips), so the intro and setup say about straight up; see
  Uncertain.
- Bicycle timing: a side every ~1.33 s (7.96 s / 6), not ~1.25 s, and the level middle comes between
  every pair of touches (0, 1.33, 2.67 s ...), not only at 0 and 4.0 s (spec header and notes).
- Ghost comments re-measured: oblique lift (head ~13 cm, shoulders ~9-11 cm, was 11-13); ball sit-up
  (lower back ~4 cm and head ~23 cm at strength ~0.92, the hand-to-knee distance being ~1.77 torso
  lengths at the top and ~1.92 at rest, was 5 cm, 28 cm, 1.73 and 1.88).

Confirmed with the rigs: the bicycle's touches (right elbow to left knee 0.33-1.0 s, then
alternating, six in all, elbow joint to kneecap 9-10 cm, shoulders up all clip with both scapula
joints 19-33 cm against 6 lying flat, free knee 170, lowest shoe point 48.8 cm, thighs 75 degrees at
the level middle, fingertips behind the head); the oblique crunch's crossed left ankle (83% of the
way down the right thigh, 7.8 cm short of the knee joint along it, so just above the knee), its
31-degree turn with ~1 degree of side bend, curl and turn together 0.5-1.0 s, hold 1.0-2.4 s, down by
3.25 s, the right elbow over the midline 54 cm from the left knee; the toe touch's knees 172, arms
166, fingertips 3.7 cm from the shoes between the feet, hold 1.0-2.4 s; the cross-body's feet 30 cm
apart, knee and curl rising together, the knee over the upper abdomen between the lumbar and chest
joints, the other ankle 7 cm up all rep, rep 2 mirrored; the ball (65 cm, centre 32.5 cm up and 44 cm
behind the hips; hip joints 55 cm up, 10 cm below its top; ankles 34 cm apart; knees 96-99; hips
sinking 2 cm). Every activation row matches the paint and its band; the library anchors are as
quoted.
