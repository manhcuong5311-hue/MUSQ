# Trainer content for the model-only exercises of 2026-10-29, family "cond":
# the seven conditioning lifts that shipped with a 3D model and no
# ExerciseContent - Sled Push (Legs/SledPush), Sled Drag (Legs/SledDrag),
# Rowing Machine (Back/RowingMachine), Battle Rope Alternating Waves
# (Shoulder/BattleRopeAlternatingWaves), Battle Rope Slams
# (Shoulder/BattleRopeSlams), Medicine Ball Chest Pass
# (Chest/MedicineBallChestPass) and Medicine Ball Slam (Abs/MedicineBallSlam).
# They are the last seven of the round's thirty-six; the other twenty-nine
# shipped in the arms, glutes, legs, core, female, clean, snatch, jerk and jump
# families. Same format as spec.py on top of common_1_50.py; spec_1029.py
# imports this module and gen.py reads SPEC / SETUP. notes_1029_cond.md maps
# every claim in the copy to a source or to a model measurement.
#
# HOW THE MODELS WERE MEASURED. The round folder's meas.py opens each rig with
# pxr, reads every joint's world transform and every equipment mesh's points at
# every integer frame and projects both through that lift's own trainer framing
# (jobs.py, copied from the app's own modelByExercise); sil.py and headsil.py
# do the silhouettes, room.py, lead.py, chk.py and anchor.py the label
# geometry, and tiers_cond.json carries the paint. Nothing here was
# re-exported: convert_all.py was never imported by any script in this family,
# and no model-export script was run. Each lift also has an 800-1000 line
# measure_<Key>.md, a per-lift d_<Key>/ folder of re-derivation scripts, and
# the figures those scripts reproduce are marked RE-MEASURED where they are
# used.
# Frame: Y up, the lifter faces +z, their left is +x, metres. Knee (thigh-shin-
# foot), hip (chest-thigh-shin) and elbow (upper_arm-forearm-hand) are inner
# angles, 180 straight; trunk is the neck-over-pelvis line from vertical,
# POSITIVE FORWARD - so Sled Drag's -13.67 degrees is a backward lean and
# Battle Rope Slams' -4.92 at the top of the slam is behind vertical. The rig
# joint called forearm_* IS the elbow and hand_* is the wrist; there is no heel
# joint on this rig, so no contact test anywhere in this family can be a heel
# test. The ankle angle (shin-foot-toe) and upper-arm elevation from straight
# down are not in the published A block and are computed per side from the
# joint positions wherever a cue needs them.
#
# SIX TRAPS THIS FAMILY SETS. Every one of them cost this round time, and five
# of the six are shared by all seven entries.
# (1) THE RIGS ARE SKINNED. UsdGeom.Mesh.GetPointsAttr().Get(t) on a body mesh
#     returns the REST pose at EVERY time code, so projecting mesh points
#     directly gives a standing silhouette that never moves. Every silhouette
#     figure in this module comes from the pre-computed <Key>_SIL.npz (sil.py
#     evaluates UsdSkel linear-blend skinning at every frame over all the
#     skinned meshes and bins the result into 655 v rows, one per rendered
#     pixel row) and every face test from <Key>_HEAD.npz (headsil.py, the same
#     binning over just the vertices whose dominant UsdSkel influence is
#     root/pelvis/spine/chest/neck/head). A pill must clear the lifter at EVERY
#     pixel row inside its band, so the per-frame gap is the MINIMUM over rows
#     of max(u0 - umax, umin - u1), as chk.py and room.py do it; taking the
#     maximum over rows over-reads every slot.
# (2) THE LOAD GEOMETRY RUNS FAR OUTSIDE THE FRAME on six of the seven, and
#     every extent or distance quoted about a load is CLIPPED to the visible
#     frame (u 0..1, v 0..1) and SAYS it is clipped. Raw left-edge reach:
#     Battle Rope Alternating Waves u -6.7704, Battle Rope Slams -4.3960 (the
#     ropes run away from the camera along +z, which at yaw -1.3 maps to
#     -0.9636 in screen x), Medicine Ball Chest Pass -1.6831 (the wall slab;
#     the ball itself reaches -1.3558), Rowing Machine -0.4804 (the flywheel),
#     Sled Push -0.4105 and Sled Drag -0.3651. Medicine Ball Slam is the one
#     exception in the family: all 362 ball points are inside the frame on all
#     192 frames, so its raw and clipped extents are identical and it says so.
#     TWO CORRECTIONS TO THE ROUND BRIEF live in the per-lift comments and are
#     repeated here. The brief's Rowing Machine figure u 0.998 is the
#     apparatus's RIGHT-hand extreme and is INSIDE the frame by 0.6 px; that
#     lift's excursion is on the left, to -0.4804. And the brief's chest-pass
#     -1.683 is the WALL slab, not the ball.
#     room.py's own load columns, and chk.py's, are RAW: the load-distance
#     column can under-read against the clipped figure when invisible points
#     sit just off the left edge, and room.py's load-in-the-band line counts
#     off-frame rope at drawn rows 0.64 and 0.80 on the two rope lifts. The
#     frames-inside-the-pill count is unaffected either way, because a point
#     inside a pill is on screen by definition.
# (3) THE PAINT IS HEAVY. Re-read from tiers_cond.json: Sled Drag 31 names (4
#     bright, 27 dim), Battle Rope Slams 30 (10 bright, 20 dim), Rowing Machine
#     23 (16 bright, 7 dim), Medicine Ball Slam 23 (6 bright, 17 dim), Battle
#     Rope Alternating Waves 22 (3 bright, 19 dim), Sled Push 15 (10 bright, 5
#     dim), Medicine Ball Chest Pass 14 (7 bright, 7 dim). Nothing is faint
#     anywhere in the family and NOT ONE painted name on any of the seven
#     carries an _L/_R or (L)/(R) suffix, so every lift's paint is two-sided and
#     A against SOFT in a glow is THE PAINT TIER and nothing else - never depth,
#     never a side, never which face of a limb points at the camera. The cost is
#     the legend: it joins the primary names and then the secondary names with
#     " . ", uppercases both and gives each lineLimit(1), about 40 characters at
#     375 pt and 43 at 393 pt, so the long row tables truncate on device and no
#     entry can fix it from here (family-wide open point 2).
# (4) FRAME WINDOWS ARE INCLUSIVE AND SECONDS ARE AMBIGUOUS, so every seconds
#     figure in this module says whether it is a frame COUNT or a count of
#     frame INTERVALS. f29..f40 is TWELVE frames and 0.458 s of elapsed time
#     (11 intervals). ALL SEVEN CLIPS ARE 192 FRAMES AT 24 FPS with times[0] =
#     0.0 and times[191] = 7.958333, so the samples SPAN 191 intervals =
#     7.958333 s while the LOOP is 192 intervals = 8.000000 s; frequencies use
#     the loop and windows use the span. Frame f = round(t * 24), the 0-based
#     index into times; the files' own frames arrays are USD frames 1..192, so
#     USD frame = f + 1 and t0 = 1.0. Shares of a clip are frame counts.
# (5) THE PERIOD SWEEPS USE THE EUCLIDEAN PER-JOINT DISTANCE AND THE FREEZE
#     SWEEPS A 0.001 mm TOLERANCE. A sweep on a per-axis or squared residual
#     finds the wrong lag, and 1e-9 finds no frozen run on any of the seven.
#     Every sweep below is CIRCULAR (frame i against frame (i + k) mod 192,
#     maximum over all 26 probed joints and all 192 frames), because a linear
#     sweep splits a held pose across the loop seam and misses the period. Two
#     readings that are easy to get wrong and are spelled out in each entry:
#     the runner-up lag is often another MULTIPLE of the period, so a sorted
#     list has to be read with that in mind, and the HALF-period lag is not a
#     second period on any of these seven - on Battle Rope Slams it is in the
#     sweep's top band but not its maximum (1287.861131 mm against a maximum
#     1287.861196 at lag 11, with 16 lags larger, and 0.0003 at the period) and on
#     Medicine Ball Chest Pass it is 97.0% of the worst.
# (6) joints.json HOLDS EIGHT SAMPLES PER JOINT AND ON FOUR OF THE SEVEN THEY
#     ALIAS. glow() averages those eight, which are the eight whole-second
#     moments t 0..7. Against a period of 1.000 s (Battle Rope Slams), 2.000 s
#     (Battle Rope Alternating Waves, Medicine Ball Chest Pass, Medicine Ball
#     Slam) or 1.33333 s (the two sleds) they land on one pose or on a handful
#     of phases, not across the rep - on Battle Rope Slams all eight are within
#     seven-eighths of a frame of the top of the slam. So the glow centres in
#     those entries are STATIC placements at one instant and each entry says so;
#     the app itself tracks the live joint every frame
#     (Exercise3DView.dotPoint), so this is a default-placement question and not
#     a rendering one. The eight stills inherit the same aliasing: on Battle
#     Rope Slams stills/battle-rope-slams_t0..t7.png are eight copies of one
#     instant (t1..t7 pixel-for-pixel identical, t0 differing in 1,116 of
#     250,210 pixels), and the chest-pass stills show two poses and neither is
#     the throw.
#
# WHAT EACH CLIP HOLDS. The per-lift comments carry the full measure; these are
# the shapes, and all seven loop.
# - Sled Push (yaw -1.3, zoom 0.797, offset [-0.02, 0.081, 0.073]). SIX
#   bit-identical stride cycles of 32 frames = 1.33333 s (circular lag 32 at
#   0.0000074506 mm; the next nearest lag is 1 at 102.2704 mm and the
#   half-period lag 16 is 272.5126 mm, the third worst band in the clip), which
#   is twelve mirrored steps and 90 steps per minute. NOTHING IS FROZEN - 0 of
#   192 at 0.001 mm and still 0 at 1.0 mm - which is why this entry is allowed a
#   tempo cue where the jump family was not. 126 frames have the left toe down,
#   126 the right, 60 BOTH and 0 NEITHER, so there is no flight phase. The trunk
#   is frozen at 50.08 degrees forward (total range 0.0000296) and that one
#   angle is the exercise. Load: the sled is scenery, 516 of 1032 points on
#   screen, and the lifter never catches it - the closest toe stays 66.54 cm
#   behind the nearest sled point. Paint 15, the second lightest of the seven.
# - Sled Drag (yaw -1.3, zoom 0.68, offset [0.018, 0.046, -0.066]). SIX cycles
#   of 32 frames again (lag-32 residual 0.000017 mm against 36.765361 mm at the
#   nearest non-multiples) and A MARCH ON THE SPOT: the body walks backwards in
#   place and the sled never moves, nine of its thirteen meshes being bolted to
#   the world. Trunk frozen at -13.67014 degrees, which is BACKWARD on this
#   module's sign convention, range 0.0000065; the knee never passes 145.59193
#   degrees, still 34.41 short of straight. Load 13 meshes, 1608 points, 1074 of
#   them on screen on every frame (66.79%) and the other 534 off the left edge
#   on every frame. Paint 31 names on 62 meshes, the heaviest in the family, 4
#   bright and 27 dim.
# - Rowing Machine (yaw -1.35, zoom 0.694, offset [-0.006, 0.057, 0.028] - the
#   one lift in the family at a yaw other than -1.3 or -0.8). TWO strokes of 96
#   frames = 4.0000 s, 15 strokes a minute, lag 96 agreeing to 0.000584 mm
#   against 68.2681 at lag 95 or 97, with the whole residual in the arm chain.
#   DO NOT call lag 48 the runner-up: at 914.2032 mm it is a shallow local
#   minimum that 89 of the 191 lags beat. The clip NEVER freezes (0 intervals at
#   0.001, 0.01 and 0.1 mm; 6 of the 192 circular intervals and 5 of the 191
#   published ones at 1.0 mm), so no cue may describe a hold, though
#   single channels pin while the body translates - knee for 39 frames of every
#   96, handgap at 0.245723 m on every frame with 0.0000 m of range. Load 18
#   meshes and 1,490 points a frame, fourteen of them bolted down. Paint 23
#   names, 16 bright, on 46 of the rig's 125 skinned meshes.
# - Battle Rope Alternating Waves (yaw -1.3, zoom 0.934, the tightest framing in
#   the family, offset [0.017, 0.084, -0.062]). NOT ONE REP: four bit-identical
#   cycles of 48 frames = 2.000 s, and inside them each arm waves at exactly
#   2.5 Hz - one wave every 9.6 frames = 0.400 s, 150 waves per arm per minute -
#   with the left exactly half a wave behind the right, while the pelvis bobs at
#   exactly 5.0 Hz. The RANGE IS SMALL EVERYWHERE (knee 4.613 degrees, hip
#   2.253, trunk frozen at 23.4546), the feet travel 0.0253 mm in eight seconds
#   and the hands never move sideways, so nothing in this clip degrades and no
#   cue may be written as a fatigue demonstration. The elbow FLEXES as the hand
#   RISES, which is the opposite of what the cue would assume. Paint 22 names, 3
#   bright - the anterior deltoid and the two biceps heads - and 19 dim.
# - Battle Rope Slams (yaw -1.3, zoom 0.732, offset [0.017, -0.035, -0.063]).
#   EIGHT reps on a period of exactly 24 frames = 1.000 s, lag 24 and lag 48
#   both at 0.0003 mm against 253.4732 at phase 1. The clip starts and ends
#   mid-work: no set-up pose, no finish pose, no rest frame. Its one freeze is
#   f0 to f1 in every rep, 8 of the 191 intervals = 0.3333 s, 16 of 192 frames
#   as a count - AND THE ROPE KEEPS MOVING THROUGH IT, 34.150665 mm of centroid
#   step, so nothing in the clip is ever fully still. Hand height falls
#   1.252535 m, knee 59.1545 degrees, hip 51.1907 and trunk 42.2505 against an
#   elbow that moves 14.6279, which is the badge. Load 78 cylinders, 36 ever
#   visible, 36.9% of point-samples on screen; the rope is on the floor from
#   1.5905 m out to 6.02 m on every frame, 1.4559 m clear of the toes. Paint 30
#   names, 10 bright, 20 dim.
# - Medicine Ball Chest Pass (yaw -1.3, zoom 0.889, offset [0.027, 0.053,
#   -0.098]). FOUR reps of 48 frames = 2.000 s (lag 48, 96 and 144 at 0.000554
#   mm against 125.7792 at 47 or 49; f191 IS f0 to 0.000000 mm). The ball leaves
#   the hands, goes ENTIRELY OFF FRAME for 11 frames of every rep (f13..f23) and
#   comes back 9.45 cm HIGHER than it went out while keeping 73.06% of its
#   horizontal speed, which no wall does - so the copy must not promise the
#   reader a return, and setup step 5 says so instead of coaching around it. The
#   elbow maximum is 167.99985 degrees, a key set at 168 and not a solver clamp.
#   Paint 14 names, the lightest in the family, 7 bright and 7 dim, and this is
#   the one entry without the legend problem.
# - Medicine Ball Slam (yaw -0.8, zoom 0.694, offset [0.048, -0.061, -0.049] -
#   with Squat Jump and Jump Rope the only -0.8 framings in the round's last two
#   families). FOUR reps of 48 frames = 2.000 s (lag 48, 96 and 144 at 0.000247
#   mm; the half-period lag 24 is 1403.006 mm, so this is not a two-phase
#   alternation). Eight phases, of which the two holds are genuinely frozen at
#   0.001 mm: 28 of 192 FRAMES are inside a frozen pose (14.58%), which is 20
#   INTERVALS of the loop, 0.8333 s of 8.0000 s, or 19 intervals and 0.7917 s
#   scanned as a flat strip. Over half of every rep is the squat down to the ball
#   and the stand back up with it, which setup step 4 states. The ball loses 98.5
#   per cent of its energy on impact (rebound 3.41 cm, restitution 0.094) and
#   ITS LOAD NEVER LEAVES THE FRAME, alone in this family. Paint 23 names, 6
#   bright, 17 dim.
#
# HOW THE SEVEN READ AS ONE.
# CUE IDS are shared wherever the cue is the same thing: `torso` on four (Sled
# Push, Sled Drag, Battle Rope Alternating Waves, Medicine Ball Chest Pass),
# `drive` on four (Sled Push, Rowing Machine, Battle Rope Slams, Medicine Ball
# Chest Pass), `stance` on three (Sled Push, Battle Rope Alternating Waves,
# Medicine Ball Chest Pass), `steps` on the two sleds, `tempo` on Sled Push and
# Battle Rope Alternating Waves, `hands` on Battle Rope Alternating Waves and
# Medicine Ball Chest Pass. The rest are the lift's own: `path`, `arms`, `knee`
# (Sled Drag), the stroke's own four `setup` / `swing` / `finish` / `recovery`
# (Rowing Machine), `grip` (Battle Rope Alternating Waves), `top` / `body` /
# `elbow` / `bottom` (Battle Rope Slams), `catch` (Medicine Ball Chest Pass),
# `reach` / `hinge` / `depth` / `feet` (Medicine Ball Slam).
# LABEL STRINGS are shared only where the instruction is identical: `Arms long`
# (9) is Sled Drag's `arms` and Battle Rope Slams' `elbow`, both of them a
# straight arm holding a load that the legs and hips move. The two sleds
# deliberately do NOT share their torso label - Sled Push gets `Low lean, flat
# back` for a 50.08 degree forward lean and Sled Drag `Lean away from the sled`
# for -13.67 backwards - because the same word on two lifts leaning opposite
# ways would be worse than two words.
# BADGES. One is reused inside the family and the reuse is the point: LOSING THE
# LEAN carries both sleds, because the fault is the same one and both models
# hold their lean frozen so neither can demonstrate losing it. The other five
# are each the one fault that lift owns and that no cue above already carries -
# ARMS PULL EARLY (Rowing Machine), SHRUGGING UP (Battle Rope Alternating
# Waves), ARMS ONLY (Battle Rope Slams, the library's own word, two shipped uses
# and this is the third), ELBOWS FLARED (Medicine Ball Chest Pass, the
# library's commonest pressing badge at eight shipped blocks) and ROUNDED LOWER
# BACK (Medicine Ball Slam). THE RULE THEY ALL KEEP: no badge in this module is
# given for a fault the model performs on purpose, and on all seven the model
# demonstrates the CORRECT side of its own badge measurably, which is what each
# correctNote quotes.
# THE GLUTES ARE ONE ROW, on the owner's standing decision of 2026-10-30: the
# rig lights gluteus maximus, medius and minimus as ONE unsplit group, so every
# lift here that paints them gets a single Gluteus Maximus row, the copy says
# glutes, and NO string in any of the seven entries names the gluteus medius -
# not in a row, not in a stabiliser list. Six of the seven paint the glutes and
# carry that row; Medicine Ball Chest Pass does not paint them and names
# gluteus maximus among its stabilisers instead.
# NO library= KEY ON ANY OF THE SEVEN, and that is deliberate rather than an
# omission. validate_library()'s EQUIPMENT set is {BARBELL, DUMBBELL, EZ BAR,
# CABLE, MACHINE} and these lifts' shipped equipment words are SLED, ROWER,
# BATTLE ROPE and MEDICINE BALL, so any library= tuple would fail validation
# while changing nothing - every shipped row already names the muscle this
# paint makes primary. Widening EQUIPMENT is an owner decision (family-wide
# open point 4) and library_cond.md section 7 recommends changing no shipped row.
# FIVE OF THE SEVEN ARE TIMED, TWO ARE COUNTED. ExerciseCatalog.swift's
# timedExercises set holds Sled Push, Sled Drag, Rowing Machine, Battle Rope
# Alternating Waves and Battle Rope Slams, so measure(forExerciseNamed:) returns
# .time. TWO of the five end a setup step on the house phrase for the set time
# (Sled Push step 4, Sled Drag step 4); Battle Rope Alternating Waves step 5 and
# Battle Rope Slams step 4 say the same thing in their own words (for time rather
# than reps; timed rather than counted); and Rowing Machine says NOTHING about
# time anywhere on the ungated surface - review open point R2 below. Eleven of
# the nineteen shipped timed entries use the house phrase verbatim, so adopting
# it on all five would make the library 14 of 19; that is an owner call and is
# priced in R2. The two medicine ball lifts are rep-based and no step of theirs
# uses it. (Corrected 2026-10-31: the sentence previously claimed all five end on
# the house phrase, which only Sled Push and Sled Drag do.) Three of the five timed
# lifts also lose the weight column, because isBodyweight() matches BATTLE ROPE
# and ROWER; SLED is not in that list, so the two sled lifts are the family's
# only timed-and-loaded pair and no step of theirs prescribes reps.
# PART_OF() TRAPS, the same three on nearly every lift and each a hard
# validate() failure if ignored: part_of of RectusFemoris is None, so that row
# would be silently DROPPED and the rectus femoris rides unnamed inside the
# Quadriceps row; part_of of BicepsFemoris is biceps, the ARM, so a hamstring
# row must read Hamstrings; and part_of of Deltoid Anterior is sideDelts, the
# wrong head, so a row must read Anterior Deltoid / Lateral Deltoid / Posterior
# Deltoid. part_of of a single forearm muscle returns None as well, so all
# forearm work in this family rides inside one Forearms row (Sled Drag, Rowing
# Machine) or is named among the stabilisers (the rest).
# WHAT THE READER ACTUALLY SEES decided the copy on all seven.
# ExerciseDetailView.instructions() is the only ungated surface: it reads
# ExerciseCatalog.setupSteps and ExerciseCatalog.formCues, and formCues maps
# each cue to ($0.title, $0.correct) and throws intro, why and mistake away -
# with mistake sitting behind the trainer AND the paywall. So anything a lifter
# must know to do the lift safely is in a setup step or in a cue's `correct`
# string on every one of the seven, and each entry says which.
#
# THE BOUNDARY ON WHAT THE COPY MAY CLAIM, because it governs every fraction in
# this module. THERE IS NO %MVIC-NORMALISED EMG STUDY OF ANY OF THESE SEVEN
# LIFTS. There is no EMG study of a hand-pushed sled (what the sled literature
# measures is TOWING, and it measures load rather than posture), none of sled
# dragging at all, none of a rope slam, none of a battle-rope wave with a %MVIC
# normalisation, and none of a medicine ball chest pass or slam. So NOT ONE
# fraction in this module is ranked on measured activation of its own lift:
# every one follows the paint in tiers_cond.json, is carried from the nearest
# library entry, or is marked in its own comment as an estimate, and no cue
# claims a muscle works hardest in any phase of any of these seven. Three
# further limits are kept throughout: a between-condition percentage is never
# written as a %MVIC or as a fraction, nothing is claimed about fatigue on a
# clip that does not degrade, and where the only mechanistic evidence is an
# animal or in-vitro preparation (Callaghan and McGill 2001, porcine cervical
# units, in Medicine Ball Slam) it is named as what it is and carries no dose.
# Each entry lists its own sources and what each one may not be used for; the
# round's sources_cond.md and sources_safety.md hold the full records.
#
# THE LABEL GEOMETRY, and the one conversion that has already caused a mistake
# in this round. A spec writes RAW slots and spec_1029.py's row() DRAWS them
# squeezed: raw 0.14/0.32/0.50/0.68/0.86 become drawn 0.16/0.32/0.48/0.64/0.80.
# The overrides dict in every entry below is in RAW slots; room.py, lead.py and
# chk.py take DRAWN rows, and every px figure quoted in the per-lift LABEL
# GEOMETRY blocks is at the pill the app actually draws - half-height 0.025 in
# v, width (24 + 5.6 * len(label)) / 382, pinned EDGE 0.035 from the leading
# (left) or the trailing (right) frame edge, in a 382 x 655 frame. Battle Rope
# Alternating Waves is the one entry that uses a slot off that ladder: its
# `grip` pill sits at raw 0.23, drawn 0.24, between the first two rows, and that
# entry's open point 1 gives the measured cost of every alternative. Medicine
# Ball Slam is the one entry with all five pills on the same edge, all trailing
# and on the five default rows. Four entries double up a row with one pill on
# each edge, because the usable slots run out before the five cues do: Rowing
# Machine doubles BOTH drawn 0.16 and drawn 0.80 and leaves 0.48 and 0.64 empty
# (the arm-and-handle row and the rail row, where nothing fits at any length),
# Battle Rope Slams doubles 0.80 and leaves 0.16 empty, and Battle Rope
# Alternating Waves and Medicine Ball Chest Pass each double 0.16. The two
# sleds are the only lifts here with five distinct rows. A doubled row is house
# practice rather than a new shape - 134 of the 290 override blocks in the
# shipped specs already put two cues on one row with opposite sides - and each
# entry states the gap between the two pills in px.
#
# FAMILY-WIDE OPEN POINTS, recorded for the owner and NOT decided here. Each is
# stated with both options and their measured cost in the entry it bites
# hardest; the per-lift blocks hold eight to twelve more apiece.
#  1. WHETHER THE COPY MAY SAY THE SLED MOVES, AND THE MARCH ON THE SPOT. On
#     both sleds the lifter's feet cycle and the sled does not: nine of Sled
#     Drag's thirteen meshes are bolted to the world and Sled Push's nine sled
#     meshes travel 0.0000 mm, eqc and eqbox having a lag-32 residual of
#     exactly 0. Option A (taken on both): the
#     copy describes the real exercise, which moves, and no cue asks the reader
#     to copy the animation. Option B: the copy describes only what the clip
#     shows, which would make the two sled entries say nothing about going
#     anywhere. The same choice recurs on Battle Rope Alternating Waves, whose
#     rope has no anchor mesh while setup step 1 asks for an anchor.
#  2. THE LEGEND TRUNCATES ON BOTH LINES AND NO ENTRY CAN FIX IT. With 31, 30,
#     23, 23 and 22 painted names on five of the seven, the row tables run to
#     eight, ten, twelve and fifteen rows, and the legend shows about 40
#     characters of each line. Option A (taken): keep the rows the paint
#     justifies, so Muscles Worked is right and the legend is a truncated
#     preview of it. Option B: cut the tables to what the legend can show,
#     which would drop rows the render demonstrably lights. This is
#     rows_cond.md open point 3 and it spans the family.
#     THE PER-LINE COST, which this block did not carry until the second-review
#     pass. Exercise3DView.swift:512-524 joins the names with a MIDDLE DOT
#     (U+00B7) inside spaces, three characters wide, and both lines are
#     lineLimit(1) - about 40 characters at 375 pt and 43 at 393 pt:
#       lift                      PRI n/chars whole@40/43   SEC n/chars whole@40/43
#       Sled Push                  4 /  53      3 / 3        3 /  48      2 / 2
#       Sled Drag                  1 /  10      1 / 1       11 / 162      3 / 3
#       Rowing Machine             6 /  87      2 / 3        4 /  63      2 / 2
#       Battle Rope Alt. Waves     2 /  33      2 / 2        9 / 138      2 / 2
#       Battle Rope Slams          6 /  92      2 / 2        9 / 136      2 / 3
#       Medicine Ball Chest Pass   5 /  92      2 / 2        3 /  47      2 / 2
#       Medicine Ball Slam         3 /  48      2 / 2        9 / 135      2 / 3
#     TWELVE OF THE FOURTEEN LINES ARE CUT AT 40 AND THE SAME TWELVE AT 43: no
#     line in the family falls between 34 and 46 characters, so the 375 pt / 393
#     pt difference never saves a line here - it only buys one more whole name on
#     Rowing Machine PRIMARY, Battle Rope Slams SECONDARY and Medicine Ball Slam
#     SECONDARY. Only Sled Drag's one-name primary line (10) and Battle Rope
#     Alternating Waves' two-name primary line (33) survive whole, and Sled
#     Drag's 162-character secondary line is the longest legend line in the app
#     (review_cond_format.md finding 8 counts 252 of the library's 847 legend
#     lines over 40 characters, median 28, previous maximum 139). Row counts collapse into TARGET MUSCLES pills as
#     well: Sled Push 7 rows to 6 pills, Sled Drag 12 to 10, Rowing Machine 10 to
#     8, Battle Rope Alternating Waves 11 to 9, Battle Rope Slams 15 to 11,
#     Medicine Ball Chest Pass 8 to 5, Medicine Ball Slam 12 to 10.
#  3. NINE TO FIFTEEN ROWS ON LIFTS WHOSE PAINT THE READER CANNOT SEE. On every
#     lift of this family some painted muscle is invisible in the render -
#     vastus intermedius lies under rectus femoris on four of them, the glutes
#     are inside shorts on Sled Drag and Rowing Machine, and on Medicine Ball
#     Slam nine painted names are invisible and two rows get no glow at all. The
#     tiers can therefore only VETO a row, never confirm one, and each entry
#     says so where it matters.
#  4. THE EQUIPMENT WORDS. SLED, ROWER, BATTLE ROPE and MEDICINE BALL are all
#     outside common_1_50.EQUIPMENT, so validate_library() rejects them and no
#     entry passes a library= key. Option A (taken): pass nothing, since every
#     shipped row is already right. Option B: widen EQUIPMENT, which is an owner
#     decision about the shared module and touches more than this family.
#  5. THE TRAPEZIUS AND THE DELTOID SPLITS, which span five lifts between them.
#     tiers_cond.json names TrapeziusUpper, TrapeziusMiddle and TrapeziusLower
#     separately and part_of() files all three under upperBack, so every entry
#     here ships ONE unsplit Trapezius row; and a dim Lateral Deltoid at 0.40
#     reads MODERATE against bright rows elsewhere in the same table. Both are
#     rows_cond.md open points (1 and 5) and both are recorded rather than
#     decided.
#  6. THE EIGHT PROBED MOMENTS, AND WHETHER THE DEFAULT GLOW PLACEMENT SHOULD
#     BE RE-PROBED. On four of the seven they alias onto one pose or a few
#     (trap 6 above), so every glow centre in those entries is a static
#     placement. Option A (taken): place from the probe, say in the comment that
#     it is one instant, and let the app's live joint tracking do the rest.
#     Option B: re-probe at a phase mean, which changes joints.json and
#     therefore every family that reads it.
#
# ===================== SECOND-REVIEW PASS, 2026-10-31 =====================
# A coaching pass and a format pass were run over this module after it was
# drafted (rep/review_cond_coaching.md, rep/review_cond_format.md) and their
# findings are applied here. Nothing below changed a pill, a slot, a side, an
# activation row, a glow or a comparison tuple; the one annotation LABEL that
# changed - Feet inside shoulder width to Feet inside shoulder-width - is the
# same 26 characters, so every pill in the family draws at exactly the width it
# drew before, and chk.py was re-run to prove it (0 lifter overlaps and 0 leader
# frames on the head across all 35 pills, unchanged).
#
# WHAT WAS WRONG AND IS NOW FIXED, worst first:
#  a. SLED PUSH SAID THE ARMS ARE STRAIGHT in seven places while the elbow holds
#     69.6 to 79.7 deg of bend on all 192 frames. Three were ungated. See the
#     entry's open point 13 for the measurement and for the label, which is left
#     to the owner with its geometry priced.
#  b. MEDICINE BALL SLAM TOLD THE READER TO SQUAT BELOW PARALLEL. At the deepest
#     frame the HIP is 0.1120 m ABOVE the knee and it is above the knee on all
#     192 frames. The measure report's clauses were right and its conclusion
#     inverted them; the inversion had reached three comments, depth.why and
#     depth.correct, and all five are corrected.
#  c. ROWING MACHINE SETUP STEP 1 ASKED FOR HEELS DOWN - a rig limit stated as an
#     instruction, against this entry's own rationale, and wrong on an erg. See
#     the step rationale above SETUP for the measurement.
#  d. ROWING MACHINE'S DRIVE SEQUENCE was stricter in the copy than in the clip:
#     the trunk is flat through f7 and first opens at f8, where knee_L is
#     121.0472 of the 76.6989-to-175.9928 leg drive - 44.7 per cent of the way
#     through, not nearly straight. drive.correct and swing.correct now say the
#     first half and driving hard; swing.intro and the comparison correctNote
#     follow them.
#  e. BATTLE ROPE ALTERNATING WAVES PUT THE HANDS AT THE HIPS. The wrist is
#     29.51 to 40.11 cm in front of the shoulder joint and 20.43 to 39.13 cm
#     below it, with 48.7 to 66.5 deg of elbow bend - the arms are not hanging
#     and the hands are half a metre out in front. setup 3 and hands.correct are
#     rewritten, and hands.correct now names the elbow as well as the shoulder
#     (the linear split in hands.why is 11.9 cm of the 18.96 cm rise on the
#     shoulder and 8.2 cm on the elbow, so the shoulder still does more).
#  f. MEDICINE BALL CHEST PASS STEP 5 CONTRADICTED STEP 4 and disabled the catch
#     cue for any reader who took its dead-ball branch. Entry open point 11.
#  g. FOUR ABSOLUTES THAT CAME FROM A FROZEN RIG RATHER THAN FROM COACHING are
#     softened: Waves stance.correct (feet exactly where they are - foot_L
#     travels 0.0253 mm in eight seconds), Waves torso.correct (nothing above the
#     knee turns or rocks - trunk range 0.000018 deg), Chest Pass stance.correct
#     (nothing steps, shuffles or jumps - both toes frozen to seven decimals),
#     and Sled Drag knee.correct (drive each step with the thigh, which is not an
#     action a lifter can take; the thigh swings 12.1 deg and the quadriceps row
#     is the lift's only primary).
#  h. shoulder width WAS UNHYPHENATED in eight reader-facing strings against a
#     library that hyphenates overwhelmingly, and the family did not even hold
#     one spelling - only Battle Rope Slams step 2 had the hyphen. All now
#     hyphenated, in the step, the correct string, the one label and two gated
#     strings that describe the stance. The census over setup steps and correct
#     strings, 193 to 4 (210 to 4 with labels and titles counted), is
#     review_cond_format.md finding 1; counted here independently over the whole
#     of SampleData.swift it is 279 to 9, and the library hyphenates in this
#     exact grammatical position too - inside shoulder-width 4 against 1,
#     outside shoulder-width 10 against 0.
#  i. SLED PUSH CALLED THE SAME OBJECT A handle IN STEP 2 AND A post IN CUE 1,
#     a few lines apart on instructions(). Both now say handle, which is also the
#     library's habit: review_cond_format.md finding 2 counts handle 405, post 23
#     and upright 86 over setup steps, correct strings, labels and titles, and a
#     whole-file word count of SampleData.swift here gives handle 403 and post 26
#     - either way the ratio is about sixteen to one. The model's own two meshes
#     are Cylinder_096 and Cylinder_097, which measure_SledPush.md:254-255 calls
#     upright handle posts, so both words are true of the model and this was
#     purely a consistency choice. The pill label still says posts and is open
#     point 13.
#  j. THREE NON-FIRST CUES RESTATED A SETUP STEP HARDER THAN THE HOUSE ALLOWS.
#     Measured as the share of the correct string's 3-word shingles that appear
#     in some setup step, with the longest shared word run:
#       Chest Pass stance  50 pc / 13 words / 142 ch  ->   0 pc / 2 / 120
#       Waves grip         27 pc / 10 words / 168 ch  ->   0 pc / 2 / 104
#       Rowing setup       58 pc / 15 words / 251 ch  ->  30 pc / 9 / 180
#     Rowing's setup cue is a FIRST cue, where a high overlap is the house
#     pattern - review_cond_format.md finding 3 puts the shipped library's first
#     cues at a mean of 37 per cent and a p90 of 71, against 30 and 57 for cues
#     2 to 5, and records Step-Up Jump shipping twelve hours earlier at 76 per
#     cent with a 15-word run - and its 251-character string was the family's
#     longest, above the library's p99 of 184 for a correct string, so it is now
#     180 and inside p99. Across the family
#     cues 2-5 fall from a 41.9 to a 39.2 per cent content-word mean.
#     NOT TAKEN: Rowing recovery.correct at 75 per cent of content words. Its
#     3-word-shingle overlap is 9.4 per cent and its longest shared run is three
#     words - it names the same three joints in different words because that is
#     what the cue is for - so there is no restated clause to cut, and cutting
#     the joints would cut the cue.
#  k. THE TIMED-PHRASE SENTENCE IN THIS HEADER WAS WRONG for three of the five
#     timed lifts. Corrected above; the owner's choice about the phrase itself is
#     Rowing Machine's open point 9.
#  l. THREE DIFFERENT LIBRARY SETUP-STEP DISTRIBUTIONS were quoted in this module
#     (p90 96 / p99 140, p99 132, and p90 108 / p99 163). All now read median 61,
#     p90 96, p99 140, max 214 over the 1,720 shipped steps, which is what
#     reproduces. THE BRIEF'S p99 OF 132 DOES NOT REPRODUCE on any subset: the
#     all-466-block figure is 140 by linear interpolation and by nearest rank and
#     the pre-round figure is 117, while median 61 and max 214 reproduce exactly
#     and the 214 is this round's own. The per-entry digit lists were refreshed
#     for the six steps whose length changed.
#     THE WHOLE BAND, recorded once for all seven so the next family does not
#     rediscover it: these 32 steps run 104 to 130 with a median of 118, so
#     NOTHING breaks the round brief's 135 and cond is the tightest family of the
#     round (against this round's shipped 29 at a median of 101.5 and a max of
#     214, and jump's 18 at 130 and 198) - and yet the whole distribution,
#     minimum included, sits in the pre-round library's top decile (p90 93).
#     Option A (taken): leave them; the long step is how three lifts that lose the
#     weight column and five that are timed carry safety copy with nowhere else
#     to go. Option B: pull the 11 steps over 120 characters toward the library
#     p90; each of those carries two instructions joined by and, and splitting one
#     would need a sixth step, which validate() rejects - so the content would
#     have to be cut rather than moved.
#
# WHAT THE TWO REVIEWS RAISED AND THIS PASS DECLINED, with the reason:
#  m. BATTLE ROPE SLAMS' RELOAD WORDING - entry open point 13. The direction
#     reproduces, the reviewer's interval figures did not, and the conservative
#     wording is not wrong.
#  n. THE WAVES BADGE. The coaching review notes that SHRUGGING UP sits on the
#     rope lift that never elevates (0 of 192 frames with the hand above the
#     shoulder, a 34.705 deg ceiling on upper-arm elevation) while ARMS ONLY sits
#     on the one that does (96 of 192 frames, reaching 153.3511 deg), and that
#     the Waves correctNote spends four sentences explaining it. Moving a badge
#     changes a comparison tuple and the fault the entry is about, which is an
#     owner decision and not a review fix; it is left where it is, with all three
#     options and their costs in the coaching review's Part 4 open point 3.
#  o. ROWING MACHINE'S PACE - open point 9 there. Recorded with both options and
#     the 1 : 2.10 measurement, not decided.
#  p. THE SLED PUSH PILL LABEL - open point 13 there, now priced.
#  q. TRIMMING THE COMPARISON NOTES. cond's correctNote runs to a median of 423
#     and a maximum of 668 against a library median of 104 and maximum of 534
#     (review_cond_format.md finding 12), and its mistakeNote reaches 698. Nothing renders them: FormComparisonCopy's correctCue,
#     mistakeCue, correctNote and mistakeNote appear in exactly two files,
#     AnatomyModels.swift:154-161 (the struct) and SampleData.swift (the data),
#     and NO view reads them. So the length costs nothing on screen today and
#     these are the only notes in the library written against measured clips, for
#     the day a Form Comparison screen returns - the App Store IAP copy still
#     names it. Option A (taken): leave them. Option B: trim 14 strings toward
#     104 characters for a screen that does not exist.
#  r. TWO FINDINGS THAT ASKED FOR SOMETHING ALREADY RECORDED. Battle Rope Slams'
#     fifteen rows being a library first is in that entry's open point 3 (a
#     record by 3), and Medicine Ball Chest Pass's Serratus Anterior leading a
#     legend line that TARGET MUSCLES drops is in its open point 3 - which now
#     also states it the way the reader meets it. Neither needed a new point.
#  s. SLED DRAG'S cues DICT ORDER now matches its annotation order (path, torso,
#     arms, knee, steps), which common_1_50.py:11 states as the format and 428 of
#     the 452 comparable shipped blocks keep. validate() compares the two as sets
#     and gen.py:67 emits in annotation order, so nothing in the app changes;
#     this was the only entry in the round whose two orders differed. The 428 of
#     452 figure is review_cond_format.md finding 10, which also notes that all
#     24 blocks that differ are spec.py-era and that 14 further blocks build
#     their annotations through a helper and cannot be compared.
# ==========================================================================
#

from common_1_50 import *

NAMES = ["Sled Push", "Sled Drag", "Rowing Machine", "Battle Rope Alternating Waves",
         "Battle Rope Slams", "Medicine Ball Chest Pass", "Medicine Ball Slam"]

# ====================================================================== sled push

# ---------------------------------------------------------------- sled push
#
# Legs/SledPush.usdc, framing yaw -1.3 rad (-74.48 degrees), zoom 0.797, offset
# [-0.02, 0.081, 0.073], viewport 382 x 655 - the app's own three numbers, at
# SampleData.swift:3031-3032. SampleData.swift names Sled Push at exactly two
# lines: :350, the library row (primaryMuscle QUADS + GLUTES, equipment SLED,
# difficulty .beginner, category .legs), and :3031, the ExerciseModel. There is
# NO ExerciseContent, which is why this entry exists. No library= key: the row
# words QUADS + GLUTES and SLED are not in common_1_50's MUSCLES / EQUIPMENT
# sets, so a library= tuple would fail validate_library(), and the row stage
# recommends changing no shipped library row.
#
# THE APP COUNTS THIS LIFT IN SECONDS, NOT REPS. ExerciseCatalog.swift:137
# lists Sled Push in timedExercises (the set runs :130-138), so
# measure(forExerciseNamed:) at :100 returns .time; and SLED is NOT in
# isBodyweight()'s equipment list (:108-112), so the weight column stays live -
# seconds WITH a load, which only the two sled lifts are in this family. A
# setup step that said do 10 reps would contradict
# the app's own UI, and the house phrase for the surface is for the set time -
# 11 of the 19 shipped timed entries use the phrase in a setup step and 5 of
# them end a step with it (Farmer's Carry :26525, Overhead Carry, Calf Raise
# Hold, Farmer's Walk on Toes, Farmer Carry March).
#
# THE CLIP IS 192 FRAMES AT 24 FPS, times[0] = 0.0 and times[191] = 7.958333,
# so 7.958 s of frames and 8.000 s of cycle. Frame numbering is the round's:
# f = round(t * 24), the 0-based index into times; the file's own frames array
# is the USD frame and runs 1..192, so USD frame = f + 1 and t0 = 1.0. EVERY
# WINDOW BELOW IS WRITTEN f<a>..f<b> INCLUSIVE, so f1..f11 is ELEVEN FRAMES and
# the time from the first of them to the last is (11 - 1) / 24 = 0.4167 s;
# where a figure is a contact-to-contact duration it says so and is taken over
# the bracketing contact frames.
#
# SIX BIT-IDENTICAL STRIDE CYCLES, PERIOD EXACTLY 32 FRAMES (1.33333 s). A
# CIRCULAR lag sweep (frame i against frame (i + k) mod 192, max over all 26
# joints and all 192 frames) gives 0.0000074506 mm at lag 32 and at every
# multiple of it. Two numbers that have already been confused once this round:
# the NEXT NEAREST lag is 1, at 102.2704 mm - not the half-period - and the
# HALF-PERIOD lag 16 is 272.5126 mm, the third worst band in the clip (the
# worst is lag 6 and lag 26, 299.8762 mm). Cycle c against cycle 0, frame for
# frame, is 7.451e-06 mm on the Euclidean per-joint distance (5.299e-06 on the
# max-component metric) for every c in 1..5; the lag-32 residual over A, eqc
# and eqbox is exactly 0 and over UV 3.0e-09.
#
# THE LOOP SEAM IS INVISIBLE AND IS NOT A DEFECT. Wrapping f191 onto f0 the
# worst per-joint disagreement is 3.901984 mm (worst joint hand_R), mean
# 1.2583 mm - and that is the SMALLEST interframe step anywhere in the clip
# (median 38.9411 mm, mean 39.4283 mm, maximum 102.270420 mm at f16 -> f17).
# f31 -> f32 and f191 -> f0 are the same moment of the cycle (191 mod 32 = 31),
# which is why the two numbers are identical.
#
# NOTHING IN THIS CLIP IS FROZEN, which is why this entry is allowed a tempo
# cue where the jump family was not. Searching circularly for runs whose
# per-frame max joint step is under the round's 0.001 mm tolerance finds 0 of
# 192; so do 0.01 mm, 0.1 mm and 1.0 mm. In both conventions: 0 of 192 frames
# belong to a frozen pose (0.0%) and 0 of 192 frame intervals are frozen
# (0.000 s of 8.000 s). Box Jump, by contrast, held 41.7% of its frames still.
#
# THE TWO STEPS ARE MIRROR IMAGES AT HALF A CYCLE. max abs(knee_L(i) -
# knee_R(i+16)) is 0.0555 degrees against 51.6437 at lag 0; hip 0.1692 against
# 33.4789; elbow 1.2503 against 9.5947; and mirrored foot_L against foot_R
# 0.2772 mm, toe 0.4337 mm, patella 2.1126 mm, hand 2.7629 mm. f16 is the same
# pose as f0 to 0.000005 mm. So the clip is 12 identical steps of 16 frames,
# 12 steps / 8.000 s = 1.5 steps per second = 90 STEPS PER MINUTE, and one rep
# is whichever of six cycles or twelve steps you choose to call one - nothing
# in the clip marks a set start or a set end.
#
# THE PHASES. Two, and they alternate. Everything here is the LEFT step,
# f0..f16; the right step is the same thing at f + 16 with L and R swapped, and
# the whole lot repeats at f + 32, 64, 96, 128 and 160. Contact means the toe
# joint is within 3 mm of its own minimum height (toe_L.y min 0.015796, toe_R.y
# min 0.015390); there is NO heel joint on this rig, so a heel test is
# impossible.
#   1 LEFT SWING      f1..f11   11 frames inclusive, 0.4167 s first to last,
#                               0.5000 s contact to contact (f0 -> f12)
#   2 DOUBLE SUPPORT  f12..f16   5 frames inclusive, 0.1667 s
#   3 RIGHT SWING     f17..f27  11 frames inclusive, 0.4167 s, 0.5000 s
#                               contact to contact (f16 -> f28)
#   4 DOUBLE SUPPORT  f28..f32   5 frames (f32 = f0 of the next cycle)
# Frame budget over f0..f31, each frame counted once: f0 + 11 + 5 + 11 + 4 =
# 32. Checked twice: 1 + 11 = 12, 12 + 5 = 17, 17 + 11 = 28, 28 + 4 = 32.
# Over the whole clip 126 of 192 frames have the left toe down, 126 the right,
# 60 BOTH and 0 NEITHER - there is no flight phase anywhere.
#
# ANGLES AT THE BOUNDARIES, straight from A and identical to the values
# re-derived from J (0 degrees of difference on all four channels):
#   f0  knee_L 158.41  knee_R 158.46  hip_L 148.59  hip_R 148.60
#       elbow_L 109.36 elbow_R 108.13 ankle_L 102.64 trunk +50.08
#   f6  knee_L  96.31  hip_L 113.29   - the peak of the left swing
#   f12 knee_L 151.88  knee_R 151.93  - left toe back down
#   f22 knee_R  96.35  hip_R 113.39   - the peak of the right swing
# Whole-clip ranges: knee_L 96.307 (f6) to 158.406 (f0) = 62.099 degrees
# (checked: 158.406 - 96.307); knee_R 62.107; hip_L 113.294 to 148.592 =
# 35.298; hip_R 35.208; elbow_L 100.293 (f8) to 110.442 (f18) = 10.149;
# elbow_R 10.083; ankle_L (computed, shin-foot-toe) 95.30 to 102.64 = 7.34;
# anklegap 0.2882 m (f0, f15) to 0.3736 (f22) = 0.0854 m. TRUNK IS FROZEN:
# 50.079990 to 50.080019, a total of 0.0000296 degrees. shouldergap is frozen
# at 0.392155 m (range 2.0e-07 m) and handgap moves 0.002204 m.
#
# WHAT THE BODY DOES, IN METRES: the swinging toe lifts 9.65 cm (0.015796 to
# 0.112302, peak at f6), the ankle 12.93 cm (0.1200 to 0.2493) and the knee only
# 5.9 cm (patella_L 0.4423 to 0.5014); the knee travels 28.29 cm forward in z
# and the ankle 19.13 cm; the ankle's path over one step is 46.20 cm and its
# NET displacement 0.0000 cm. The whole midline - pelvis, spine, chest, neck,
# head - bobs 2.287 cm vertically, the same on all five. Stance anklegap at
# double support is 0.2882 m = 73.5% of the 0.3922 m shoulder span (narrower
# than the shoulders); handgap is 0.6279 m = 160.1% of it.
#
# THE LOAD: NINE STATIC MESHES, 1032 projected points per frame, every one an
# axis-aligned box or cylinder identical at all 192 frames.
#   Cylinder_096  right handle post   3.8 x 95.0 x 3.8 cm, x -0.2990..-0.2610
#   Cylinder_097  left handle post    3.8 x 95.0 x 3.8 cm, x +0.2610..+0.2990
#   Cylinder_098  centre weight pin   5.0 x 43.0 x 5.0 cm
#   Cylinder_099/100/101  three plates on the pin, 40.0 x 5.0 x 40.0 cm each
#   Cube_106/107  the two floor runners, 10.0 x 8.0 x 95.0 cm
#   Cube          base deck, 72.0 x 9.0 x 70.0 cm
# Whole sled 74.0 cm wide, 104.5 cm tall, 95.0 cm deep, three plates and no
# more. THE SLED NEVER MOVES: centroid travel 0.0000 mm on all nine meshes and
# a bbox range of exactly 0.0 mm on all six faces over all 192 frames, which is
# why eqc and eqbox have a lag-32 residual of exactly 0. Nothing in the copy
# may say it tips, accelerates or is driven - see open point 1.
#
# THE SLED ON SCREEN, RAW THEN CLIPPED. 516 of its 1032 projected points -
# exactly 50.0% - are OFF SCREEN, all of them off the LEFT edge (u < 0; none
# off the right, top or bottom). RAW u -0.4105..+0.2957, v +0.3611..+0.8134.
# CLIPPED TO THE VISIBLE FRAME (u, v in 0..1): u +0.0110..+0.2957 = 108.8 px of
# 382, v +0.3611..+0.7948 = px 237..521 of 655. EVERY SCREEN FIGURE ABOUT THE
# SLED IN THIS ENTRY IS THE CLIPPED ONE AND SAYS SO; the raw 0.7062 of frame
# width is a fiction: 58% of that span is off the left edge and only 40% of it
# carries points inside the frame. Per mesh: the right post
# (u +0.0623..+0.0893) and the left post (+0.1123..+0.1431) are the only two
# WHOLLY on screen; the plates show a third of themselves, each runner and the
# deck half, and the centre pin (raw -0.0859..-0.0516) IS NEVER VISIBLE AT ALL. A cue pointing at the plates has a quarter of them to point
# at and one pointing at the pin has nothing, which is why the stance cue names
# the posts.
#
# THE HANDS DO GRIP THE POSTS - do not report them as floating. The wrist
# joints sit a steady 8.75 cm (hand_L to Cylinder_097) and 9.03 cm (hand_R to
# Cylinder_096) from their post with 0.01 cm of variation over the whole clip,
# and no joint ever enters a sled mesh (forearm_L 31.34-32.43 cm, head
# 49.42-50.75 cm, pelvis 84.18 cm). But extending the elbow-to-wrist line past
# the wrist, which is where the hand mesh goes, reaches 0.10 cm (left) and
# 0.36 cm (right) from the post at 10 cm and is INSIDE the post at 12 cm - and
# a 6x crop of px 8..120 x 230..300 shows fingers wrapped round both posts. The
# hands take the posts FROM THE OUTSIDE: wrists at x +/-0.314 against post
# centres at x +/-0.280, so 3.4 cm outside, and handgap 0.628 m against a
# 0.560 m post spacing. The feet never approach the sled: the forward-most toe
# reaches z -0.3404 and the sled's rear-most point is z +0.3250, a gap of
# 66.54 cm (checked twice: 0.3250 - (-0.3404) = 0.6654 m) that never closes.
#
# WHAT THIS MODEL DOES THAT A LIFTER MUST NOT COPY, worst first:
# - IT IS A MARCH IN PLACE, NOT A SLED PUSH. pelvis x range 0.0000 mm, z range
#   0.0001 mm; spine, chest, neck and head 0.0000 / 0.0002 mm; each foot
#   returns to its starting point with a NET displacement of 0.0000 cm per
#   step; and the sled's nine meshes travel 0.0000 mm. No cue may be read off
#   this animation about covering ground, stride length or turning the hips.
#   Open point 1 is what the copy does about it.
# - THE TRUNK ANGLE IS FROZEN at 50.079990 to 50.080019 degrees for all 192
#   frames, and the lumbar, thoracic and neck chains with it (170.679 /
#   171.267 / 144.733, zero range on each). The model shows no hip extension,
#   no finish, no rise or fall of the chest - and it cannot show the body angle
#   being LOST either, which is this entry's badge. The 50.08 degrees is simply
#   the only pose the rig holds.
# - THE HEEL NEVER LANDS, on either foot, at any frame. With no heel joint the
#   test is foot pitch, ankle to toe: the planted left foot is at 46.29 degrees
#   below horizontal at every one of its 126 contact frames, to two decimals,
#   against 21.034 degrees for the same rig standing flat in Box Jump - 25.26
#   degrees more plantarflexion (checked: 46.2922 - 21.0340 = 25.2581). So a
#   cue saying heel down or drive through the whole foot is flatly contradicted
#   on screen, and one saying stay on the balls of your feet describes the only
#   thing the rig can do. Open point 7.
# - THE KNEE DRIVE IS MOSTLY A SHIN SWING and is overstated by about a factor
#   of two: the knee rises 5.9 cm while the ankle rises 12.93 cm and the toe
#   9.65 cm, and the knee travels 28.29 cm forward but NEVER comes above the
#   hip (patella_L.y peaks at 0.5014 against a pelvis at 0.8573..0.8802). No
#   cue below asks for a high knee.
# - THE HANDS SLIDE 4 cm UP AND DOWN THE HANDLES, OUT OF PHASE. The two
#   shoulders stay exactly level with each other at every frame (upper_arm_L
#   and _R both 1.2184 at f0 and f16, 1.1955 at f8 and f24) yet hand_L and
#   hand_R each move 40.00 mm in y and see-saw: hand_L - hand_R is -2.69 mm at
#   f0, +37.31 mm at f8 and -42.69 mm at f24. The posts are static, so the grip
#   is sliding about +/-2 cm once per step - 10.9 px for the left hand and
#   9.5 px for the right, at 2.71 px per cm. That is the rig absorbing the
#   body's 22.87 mm bob. NOTHING IN THE COPY DESCRIBES THE ARMS AS DOING
#   ANYTHING; see open point 8 for what it costs the stance anchor.
# - THERE IS NO FLIGHT AND THE CADENCE IS A WALK: both feet are never off the
#   floor (0 of 192 frames) and 90 steps per minute. A cue about sprinting or
#   an explosive first step has nothing on screen to attach to.
# - Two small ones, recorded so nobody re-finds them: the sled floats 5.0 mm
#   (runners at y +0.0050 against the lifter's floor plane at y = 0), which is
#   1.39 px; and hand_R is BEHIND the lifter's-left post in depth (rotated
#   depth -0.0943 against the post's +0.1733), so the near post is correctly
#   drawn across the right hand - but hand_R projects to u 0.1401, inside the
#   left post's screen column u 0.1123..0.1431, and anyone reading the UV alone
#   would call it a clash. It is why the stance pill anchors hand_L (u 0.206)
#   and not hand_R.
# - CHECKED AND CLEAN, so nobody checks again: no joint enters a sled mesh
#   (minimum 8.75 cm); the grip reaches the handle; the loop seam is the
#   smallest step in the clip; the two sides are symmetric to 0.0555 degrees at
#   half a cycle; the feet never leave the floor together.
#
# PAINT (tiers_cond.json, key Legs/SledPush): 15 painted meshes - 10 BRIGHT,
# 5 DIM, nothing faint. That is the SECOND LIGHTEST paint of the seven COND
# lifts (Medicine Ball Chest Pass 14, then this 15, Battle Rope Alternating
# Waves 22, Rowing Machine 23, Medicine Ball Slam 23, Battle Rope Slams 30,
# Sled Drag 31) and only just above the jump family's 10-14. NOTHING IS
# ONE-SIDED: no painted name carries an
# _L/_R or (L)/(R) suffix, so both sides light, which agrees with the 0.0555
# degree L/R symmetry above.
#   bright: VastusIntermedius, VastusLateralis, VastusMedialis, RectusFemoris
#           (-> quads); GluteusMaximus, GluteusMedius, GluteusMinimus
#           (-> glutes); GastrocnemiusLateral, GastrocnemiusMedial, Soleus
#           (-> calves)
#   dim:    Semimembranosus, Semitendinosus, BicepsFemoris (-> hamstrings);
#           DeltoidAnterior; RectusAbdominis
# THREE part_of() TRAPS, all verified by calling the real function out of
# common_1_50.py and all hard validate() failures if ignored:
# part_of(RectusFemoris) is None, so the row would be DROPPED and it rides
# inside the Quadriceps row unnamed; part_of(BicepsFemoris) is BICEPS - the arm
# - so the hamstring row must read Hamstrings (part_of(Biceps Femoris), with
# the space, is hamstrings); and part_of(DeltoidAnterior) is sideDelts - the
# WRONG HEAD - so the row must read Anterior Deltoid, which resolves to
# frontDelts.
#
# THE GLUTES. The rig lights gluteus maximus, medius and minimus as ONE unsplit
# group, so on the owner's standing decision this lift gets a single
# Gluteus Maximus row, the copy says glutes, and NOTHING NAMES THE GLUTEUS
# MEDIUS anywhere - not a row, not a stabiliser. Recorded because stepUpContent
# and walkingLungeContent both do name it and are otherwise the closest
# precedents in the library, and because 93 shipped blocks name it one way or
# the other; the precedent being followed here is the twelve-hour-old jump
# family (Box Jump :49920), not the older 89.
#
# IS THE PAINT VISIBLE? PARTLY, AND THE BRIGHTEST TIER IS NOT. Every still
# pixel inside the lifter's own silhouette span was classified:
#   quads     BRIGHT  YES, and they dominate - the front-thigh box (u
#             0.56..0.90, v 0.50..0.68) is 31.1% orange at t0 and 32.6% at t1,
#             and patella_L projects to px (268, 390), which reads RGB
#             (135, 35, 0)
#   calves    BRIGHT  yes but modestly - the lower-leg box is 11.7% orange at
#             t0, 10.2% at t1, 6.1% at t3; the rest is shoe and shadow
#   glutes    BRIGHT  NO - UNDER THE SHORTS. The hip box round the pelvis joint
#             (px (237, 287)) reads RGB (34, 38, 44), the dark blue-grey of the
#             shorts, and no orange appears between the waist and the hem in
#             ANY of the three distinct stills. This is the jump family's
#             hidden-glute trap again and worse: here the glutes are three of
#             the ten bright meshes. Open point 5.
#   hamstrings DIM    partly - the rear thigh is mostly in shadow at this yaw
#             and the thigh box is orange only on its front half
#   RectusAbdominis DIM  a thin sliver - the torso box is 1.3-1.4% orange, a
#             dark-red edge along the underside of the leaning torso
#   DeltoidAnterior DIM  a 60-PIXEL PATCH, the faintest thing in the frame:
#             u 0.288..0.359, v 0.302..0.328 at t0 (68 px at t3), a dull red
#             notch between the neck and the shoulder. The Anterior Deltoid
#             glow below is centred on exactly that patch. Open point 6.
#
# THE STILLS. Eight at 382 x 655, and only THREE DISTINCT PICTURES: t0 = t2 =
# t4 = t6 (mean absolute pixel difference 0.0000, 0 pixels differing), t1 = t5,
# t3 = t7; across groups 3.68 to 4.29 with 23,679 to 25,714 pixels differing.
# Their md5 sums all differ, but that is file metadata - the pixels are
# identical, so do not use the md5 to tell them apart. f = round(24 t) gives
# frames 0, 24, 48, 72, 96, 120, 144, 168, i.e. cycle phases 0, 24, 16, 8, 0,
# 24, 16, 8, and with f16 the same pose as f0 that predicts exactly the
# grouping above. t0/t2/t4/t6 are double support (both shoes down, knees at
# 158.4 / 158.5, both hands on the posts); t1/t5 are the peak of the right
# swing; t3/t7 the mirror. Eight stills land on only four of the 32 phases and
# two of those four are the same pose, so the stills cannot be used to read the
# motion - and the floor is a dark plane with no contact shadow, so they cannot
# be used to judge whether a foot is down either. Use the toe.y test.
#
# ROWS, RANKS AND FRACTIONS - SETTLED AT THE ROW STAGE (rows_cond.md 8.1) AND
# NOT RE-DERIVED HERE. Seven rows, four primary, ZERO ESTIMATES: every fraction
# is a same-name, same-rank carry from a named shipped row.
#   Quadriceps       P 0.84 HIGH      CARRY Squat Jump :50176 (also Squat
#                                     :12339, Lunge :12438), 7 blocks
#   Gastrocnemius    P 0.78 HIGH      CARRY Squat Jump :50177, Bodyweight
#                                     Standing Calf Raise :38732, 7 blocks
#   Soleus           P 0.60 MODERATE  CARRY Squat Jump :50178, Bodyweight
#                                     Standing Calf Raise :38733, 7 blocks
#   Gluteus Maximus  P 0.56 MODERATE  CARRY Squat Jump :50179, Squat :12340
#   Rectus Abdominis S 0.30 LOW       CARRY Farmer's Carry :26599, Suitcase
#                                     Carry :26703, Overhead Carry :26801
#   Anterior Deltoid S 0.30 LOW       CARRY Barbell Power Clean :48833, Hang
#                                     Clean :48926 - the clean family, where
#                                     the delt RECEIVES a load rather than
#                                     pressing it, which is what a hand on a
#                                     sled handle does
#   Hamstrings       S 0.25 LOW       CARRY Hack Squat (Stances) [Standard]
#                                     :3158, Squat Jump :50180
# The whole primary block comes from ONE shipped entry, Squat Jump :50176-80,
# the only block in the library with primary quads, a primary calf pair and
# primary glutes together - exactly the shape this paint asks for, and shipped
# twelve hours before this round. The calf pair keeps the library's
# knee-straight BODYWEIGHT gap of +0.18 (0.78 / 0.60, 7 blocks); the loaded gap
# is 0.86 / 0.66 and the sled is loaded, which is priced in open point 4
# because it would put GASTROCNEMIUS above QUADRICEPS in the legend on a lift
# whose library row says QUADS + GLUTES. Every level word came out of
# common_1_50.level() and not a keyboard: 0.84 and 0.78 are >= 0.70 so HIGH,
# 0.60 and 0.56 are in 0.40..0.69 so MODERATE, 0.30 and 0.25 are below so LOW.
# Seven rows is the 97.6th percentile of the library (median 3, p90 6, ceiling
# 12), so the table is large but inside range.
#
# STABILISERS. erector spinae (81 shipped uses), transverse abdominis (39),
# adductors (58), forearms (53) - four, which with 3 is the fat part of the
# distribution (mode 3 at 196 blocks, 4 at 104). None of the four is painted on
# this lift, which is the point: a stabiliser is by definition a muscle the rig
# does not light. transverse abdominis rather than core because Rectus
# Abdominis already has a row, which is the house habit (Bear Crawl :44948 does
# the same); the 39-use spelling, not the 2-use transversus. No gluteus medius.
#
# THE LEGEND TRUNCATES ON BOTH LINES, and the entry cannot fix it. The legend
# joins the names with a middle dot, uppercases them, and both lines are
# lineLimit(1) at about 40 characters on a 375 pt phone and 43 on a 393 pt one;
# the rank word sits in the same HStack, so the SECONDARY line is about 2
# characters tighter (38 / 41).
#   PRIMARY   QUADRICEPS . GASTROCNEMIUS . SOLEUS . GLUTEUS MAXIMUS   53 chars
#             -> 3 of 4 at both budgets; GLUTEUS MAXIMUS is chars 39-53 and is
#             cut, on a lift whose own library row says QUADS + GLUTES
#   SECONDARY RECTUS ABDOMINIS . ANTERIOR DELTOID . HAMSTRINGS         48 chars
#             -> 2 of 3; HAMSTRINGS is chars 39-48 and is cut, at 43, 41 and 40
# A cut name is lost on the 3D screen only: Sheets.swift:95 is a plain ForEach
# with no cap, so every row still draws its bar in Muscles Worked. Open points
# 4 and 6 price the two ways of shortening these lines.
#
# SOURCES BEHIND EVERY COACHING CLAIM IN THE COPY, and what each one may not
# support. The house rule for this round: no cue may claim a muscle level, a
# muscle ranking or an outcome unless a study measured it, and only
# %MVIC-normalised EMG supports a muscle-level claim.
# - THERE IS NO %MVIC STUDY OF A SLED PUSH, so NO ROW ABOVE IS CITED ANYWHERE
#   and no cue names a muscle level. Verified negatives, each a simple
#   single-phrase query: sled push AND EMG -> 0; sled push AND muscle
#   activation -> 1, which is the study below; sled AND MVIC -> 2, both
#   automotive whiplash papers; sled AND electromyograph* -> the same two.
# - Martinez-Serrano 2021 (Sensors 21(22):7482, PMID 34833557) is the ONLY sled
#   EMG study: n = 9 male amateur rugby union players, called a pilot by its
#   authors, three muscles (biceps femoris, vastus lateralis, gastrocnemius
#   medialis), sled push at 20 / 55 / 90% body mass ON AN INSTRUMENTED SKILLRUN
#   TREADMILL - the participants did not travel, which the paper itself flags.
#   Load raised VL (p <= 0.001) and GM (p <= 0.001) and did NOT change BF
#   (p = 0.278); peak power was highest at 55% BM. ITS STATED LIMITATION IS
#   THE NON-NORMALIZATION OF MUSCLE ACTIVATION VALUES, so it supports a
#   DIRECTION ONLY - heavier sled, more knee-extensor and calf demand, hamstring
#   demand not following - and no level, no ranking and no percentage. That is
#   the one sentence the drive cue's why takes from it.
# - THE LEAN IS MEASURED ONLY IN TOWING, and the copy says towing. Lockie 2003
#   (JSCR 17(4):760-7, PMID 14636109, n = 20 men, 12.6% and 32.2% BM): trunk
#   lean, hip flexion and ground contact time all increased and stride length
#   fell about 10% and about 24%. Cronin 2008 (Sports Biomech 7(2):160-72,
#   PMID 18610770, n = 20, 15% and 20% BM): sled towing increased trunk angle
#   12.5 to 71.5% while a weighted vest at the same relative load DECREASED it
#   1.7 to 13.0%, so the lean is the sled's doing and not the load's.
#   Osterwald 2021 (Sports 9(10):137, PMID 34678918, n = 33): hip, knee, ankle
#   and trunk angle all changed significantly with load (p < 0.05) and trunk
#   lean increased LINEARLY with it. ALL THREE ARE TOWING - a harness, facing
#   forward, free arms - and NONE PRESCRIBES AN ANGLE. The only statement that
#   PUSHING leans further than towing is NSCA Coach 9.3.2 secondary text whose
#   page returns HTTP 403 to a fetch, so it is second-hand and is NOT CITED
#   anywhere in this entry.
# - THE ~45 DEGREE LEAN IS FOLKLORE. No NASM-published sled guideline was
#   found, and the commercial sources that give a figure disagree with each
#   other on hand and arm position too. What coaching IS consistent about:
#   hold the body angle constant rather than letting the hips rise and the
#   chest drop, short quick steps, neutral spine. The copy therefore says a low
#   lean and never a number - and the model's own 50.08 degrees is close enough
#   to the circulating 45 that the picture does not fight the words.
# - THE STRIDE IS NOT A CHOICE. Coaching is split (one HYROX guide calls long
#   strides the fault, another calls overstriding the fault) and Lockie 2003
#   settles it awkwardly: the LOAD shortens the stride about 10% at 12.6% BM
#   and about 24% at 32.2%. So the steps cue says keep them short and quick and
#   badges no stride length.
# - LOAD PRESCRIPTION IS THE ONE EVIDENCE-BACKED THING IN THE SLED LITERATURE
#   AND THE SETUP STEPS STILL DO NOT QUOTE IT. Seitz 2017 (PMID 28185808,
#   n = 20 rugby league): a push at 75% BM made a 20 m sprint faster at 4 min
#   (-0.95%), 8 min (-1.80%) and 12 min (-1.54%), while 125% BM made it slower
#   at every time point (+1.36 to +2.59%). Martinez-Serrano 2021: peak power
#   highest at 55% BM. Cahill 2020 (PMID 31742795, n = 50, 8 weeks): 5-20 m
#   splits improved in all three resisted groups and NOT with unresisted
#   sprinting. Cahill 2021 (PMID 31972825, n = 90 high-school athletes): the
#   load-velocity relationship is highly linear in every individual (r > 0.96,
#   slope CV 3.1%) but the load needed for a given velocity decrement VARIES
#   GREATLY BETWEEN ATHLETES - which is itself the argument against printing a
#   percentage for a general audience. Open point 10.
# - THE ONLY SAFETY-RELEVANT EVIDENCE FOR A NON-ATHLETIC READER is Baumann 2024
#   (J Aging Phys Act 32:416-27, PMID 38340712): 36 apparently healthy older
#   adults randomised to a progressive sled push or walking completed the
#   protocol with NO ADVERSE EVENTS, one third of the sled group reporting
#   minimal body discomfort, and every physiological variable rose with
#   intensity against walking (p < .001). It is an EXPLORATORY FEASIBILITY
#   study on one specific machine (XPO Sled Trainer), establishes no training
#   effect, and is quoted in the stance why for exactly that much.
# - THERE IS NO INJURY LITERATURE ON A SLED PUSH AT ALL. The nearest dataset is
#   a HYROX cohort (Chittenden 2026, PMID 42780891, n = 89 over 12 weeks, mean
#   weekly response 62%) whose eight stations include a sled push: weekly
#   prevalence of any health problem 30% (95% CI 24-37), injury incidence 14.4
#   per 1000 h, overuse 73% of injuries, the KNEE the most frequently injured
#   region at 22% of episodes and shoulder problems near-absent. The authors
#   say it attributes nothing to any one station, so it licenses nothing here
#   and is not in any cue.
# - PACE HAS NO EVIDENCE AND NO PRECEDENT. The library has never badged pace,
#   rhythm, tempo, rushing, fatigue or breakdown in 466 blocks - nor the breath,
#   grip failure, head position, the environment or the direction of travel -
#   so the tempo cue is the copy's own voice, named as coaching. The cue ID
#   tempo itself is well precedented (53 shipped cues). The one measured pacing
#   datum in this family is on ropes, not sleds (Ratamess 2015b: a shorter rest
#   raised the metabolic cost of rope intervals, 52.8% against 40.5% of VO2max
#   in men), and it is deliberately NOT cited on a sled.
#
# OPEN POINTS THIS ENTRY HANDS THE OWNER - recorded, not decided. No cue above
# assumes an answer to any of them.
#  1. WHETHER THE COPY MAY SAY THE SLED MOVES. This is the single biggest
#     judgment call on the lift. The clip shows a static sled (0.0000 mm on all
#     nine meshes) and a lifter marching in place at 90 steps per minute with
#     0.0000 cm of net foot travel, and the app counts the set in seconds.
#     OPTION A: never claim travel. The model then never contradicts a word,
#     and the price is exact - the one sentence the safety stage says this lift
#     must carry, that the sled only moves while the whole body stays low
#     behind it and the push dies the moment you stand up, BECOMES UNWRITABLE,
#     and so do the clear lane in setup step 1 and the keep it moving clause in
#     the tempo cue. OPTION B, WHICH IS WHAT THIS ENTRY DOES: describe the real
#     exercise and accept that the animation beside the words shows neither the
#     travel nor the loss of the lean. The round's own cue rule points here -
#     a correct string must say the real mechanic and must neither ask for the
#     artefact nor coach around it - so no correct string mentions marching on
#     the spot and none says anything like unlike the model. Measured cost of
#     B: five clauses of the copy (lane, keep it moving, the sled stops, cover
#     the ground, push the floor back) have nothing in the clip corroborating
#     them, and a reader who watches the model for eight seconds sees a lifter
#     who never goes anywhere.
#  2. WHETHER DRAWN ROWS 0.16 AND 0.80 MAY BE USED AT ALL, and this entry uses
#     both. room.py prints no lift for them, which reads like unlimited room;
#     it means only that the band holds no silhouette row at all, on 192 of 192
#     frames. The real daylight at the worst frame is 1.83 px at drawn 0.16
#     (topmost occupied row index 123, upper edge v 0.187786, against the
#     band's v 0.185000: 0.002786 x 655 = 1.825 px) and 0.63 px at drawn 0.80
#     (lowest occupied row 506, lower edge v 0.774046, against v 0.775000:
#     0.000954 x 655 = 0.625 px). Per frame the top row wanders 123..129 and
#     the bottom 496..506, so the margins run 1.83-7.83 px and 0.63-10.63 px.
#     OPTION A (this entry): use them; any change to the pill half-height, to
#     the drawn rows or to the rig takes both slots away without warning.
#     OPTION B: stay off them - and then the five-row grid has only THREE
#     usable slots left (0.32 trailing 22 ch, 0.48 leading 24 ch, 0.64 leading
#     24 ch), so a five-pill layout needs the two thin 10-character slots as
#     well: 0.32 leading at 10 ch (+4.3 px of lifter daylight, sled 10.5 px
#     away, 0 frames inside, 25 of 26 leaders clear) and 0.48 trailing at 10 ch
#     (+4.6 px, sled 242.3 px, 25 of 26 clear). Measured cost of B: two of the
#     five labels fall to 10 characters and two pills sit on 4.3 and 4.6 px of
#     clearance instead of the 6.9 and 40.4 px this layout holds (0.32
#     trailing at its 22 characters and 0.48 leading at its 17).
#  3. THE ROW-0.64 PILL SITS ON THE SLED, ON ALL 192 FRAMES. At drawn 0.64 the
#     load is inside the pill at EVERY length from 8 to 28 characters, so
#     shortening the label buys nothing: the visible sled in that band is a
#     21-pixel strip hard against the left edge (CLIPPED u +0.0110..+0.0668 =
#     px 4.2..25.5; raw -0.2075..+0.0668) and a leading pill's left edge is
#     pinned at u 0.035 = px 13.4. Trailing 0.64 is dead on the lifter (-33.4
#     px on 192 frames at 10 characters). The round's hard pill test is about
#     the SKINNED LIFTER and the LEADERS, and this pill is clean on both
#     (+38.2 px, 0 overlap frames, leader to patella_L clear 0/192), so this is
#     a legibility cost and not a declared breach - what is covered is the
#     sled's base deck, never the lifter. OPTION A (this entry): accept it.
#     OPTION B: drop row 0.64 and take a 10-character slot per open point 2.
#     OPTION C: leave the five-row grid on this lift, as Box Jump's open point
#     6(c) contemplated - gen.py takes any y in overrides, layout() applies no
#     grid check, and validate() checks only the cue id and the side - which is
#     unnecessary here because the lifter is already clean on all five.
#  4. CALVES AGAINST GASTROCNEMIUS PLUS SOLEUS. The row stage settles two rows
#     and this entry carries them. Both names resolve to calves, so TARGET
#     MUSCLES is identical either way, and the difference is the legend:
#     QUADRICEPS . GASTROCNEMIUS . SOLEUS . GLUTEUS MAXIMUS is 53 characters
#     and shows 3 of 4 names, while a single Calves row would give
#     QUADRICEPS . GLUTEUS MAXIMUS . CALVES at 37 characters, which FITS BOTH
#     phone widths and shows all three - the only arrangement measured on this
#     lift that loses no primary name. Costs: it departs from the settled table
#     and from the Squat Jump carry, collapses two separately painted bright
#     groups into one row, and drops the library's knee-straight calf pair
#     convention (+0.18 across 7 blocks). The same line with GASTROCNEMIUS in
#     place of CALVES is 44 characters and is truncated on both widths, and
#     standingCalfRaiseContent's split-pair precedent pushes it past 50.
#  5. WHETHER THE GLUTE ROW SHOULD BE PRIMARY AT ALL, given the render never
#     shows it. The rig paints all three gluteals BRIGHT, so the standing
#     decision gives one Gluteus Maximus row - but the hip box is 0% paint and
#     29-42% shorts in every one of the three distinct stills. OPTION A (this
#     entry): keep it primary at 0.56 and let the legend claim GLUTEUS MAXIMUS
#     over a hip the reader cannot see lit - except that at 53 characters the
#     legend CUTS that very name, so the claim is invisible too. OPTION B:
#     demote it so the legend leads with the muscles that are actually orange
#     on screen. Measured: with the glute row in, the primary line is 53
#     characters and shows 3 of 4; without it, QUADRICEPS . GASTROCNEMIUS .
#     SOLEUS is 35 and shows all three.
#  6. WHETHER TO CARRY THE ANTERIOR DELTOID ROW. The paint says dim and the
#     render shows a 60-pixel patch, the faintest thing in the frame;
#     bearCrawlContent is the library's precedent for a front-delt row on a
#     non-shoulder lift. Measured cost of keeping it: the secondary line is 48
#     characters and shows 2 of 3, cutting HAMSTRINGS. Dropping either it or
#     Rectus Abdominis brings the line to 29 characters and shows all of it.
#  7. WHETHER TO MENTION THE FOOT AT ALL. The planted foot holds 46.29 degrees
#     of pitch at every one of its 126 contact frames, 25.26 degrees more than
#     a flat stance, so stay on the balls of your feet is true of the model and
#     true of the exercise but describes the only thing the rig can do rather
#     than a correctable fault - while heel down or drive through the whole
#     foot is flatly contradicted on screen. This entry puts push off the ball
#     of each foot in the steps correct string as a plain fact of the exercise
#     and badges nothing about it; HEELS LIFTING (3 uses) and HEELS DROPPING
#     (2) both exist in the library and both would be wrong here.
#  8. THE STANCE ANCHOR AND THE 4 cm HAND SLIDE. hand_L is the anchor here: its
#     uv path is 0.20, it is 34.9 px from the load, and its leader from drawn
#     0.32 trailing is clear on 0/192 frames. But its y moves 40.00 mm once per
#     step, which is 10.9 px on screen, so the leader endpoint will visibly
#     shuttle twice per step. OPTION A (this entry): hand_L, because the label
#     is about the grip and hand_R's u 0.1401 falls inside the left post's own
#     screen column 0.1123..0.1431, where a reader cannot tell hand from post.
#     OPTION B: hand_R, the calmest anchor on the load at 29.7 px and uv path
#     0.17. OPTION C: forearm_L or forearm_R - the elbow, uv path 0.14, the
#     calmest joints in the clip, 48.2 px from the load - and let the leader
#     point at the forearm rather than the hand.
#  9. THE BADGE WORD. This entry reuses LOSING THE LEAN, currently ONE use
#     (Leaning Lateral Raise :23946, mistakeCue Torso straightens up), which
#     makes it a two-use badge whose two uses mean the same thing: the lean
#     that defines the set-up is lost. Two equally defensible single-use
#     alternatives: TORSO STANDING UP (:5098, Barbell Bent-Over Row, Torso
#     rises, turns into a shrug) and STAYING UPRIGHT (:37436, Chest Dip, Trunk
#     stays upright). A fourth option is a new word; note that the library's
#     three sled/rope/ball badge words are all taken by something else
#     (SLED SINKING :33277 is a leg-press carriage), so a sled badge that meant
#     what it says would have to be new, and SLED SINKING must not be reused.
# 10. WHETHER A SETUP STEP MAY NAME A LOAD PERCENTAGE. The sled literature's
#     one robust prescription is 75% BM potentiates and 125% impairs (Seitz
#     2017) with peak power at 55% (Martinez-Serrano 2021), all from rugby and
#     track athletes - and Cahill 2021 showed across 90 athletes that the load
#     for a given velocity decrement varies widely between individuals. Step 1
#     therefore says a load you can keep moving at a steady walk, with the
#     percentages held in the stance why where they are gated. The owner may
#     prefer the number on the ungated surface.
# 11. THE SETUP STEPS ARE LONG. Four steps of 124, 127, 125 and 122 characters
#     against a library median of 61, a p90 of 96 and a p99 of 140 - all four
#     inside p99 and far inside the 214 record, but each carries two
#     instructions and the 3-to-5 rule means they cannot be split, so cutting
#     further drops content rather than repetition. Same choice the jump family
#     handed over twelve hours ago.
# 12. FIFTEEN OF THIS LIFT'S ANCHORS HAVE NEVER BEEN LEADER-CHECKED. joints.json
#     probes 41 anchors for Sled Push but the measurement file carries UV for
#     only the 26 that probe.py measures, so lead.py cannot test
#     attachment_TrapeziusUpper_L/R, deltoid_arc_clavicle_2_L/R,
#     deltoid_arc_scapula_2_L/R, support_LatissimusDorsi_L/R,
#     support_PectoralisMajor_Abdominal_L,
#     support_PectoralisMajor_Clavicular_L/R,
#     support_PectoralisMajor_Sternal_L/R or support_TrapeziusUpper_L/R. All
#     five anchors used below are among the 26 and are checked; a future edit
#     that reaches for one of the other 15 is unverified.
# 13. THE PILL LABEL STILL CALLS THE ARMS LONG, AND THEY ARE BENT 70 TO 80 DEG.
#     Corrected on the ungated surface 2026-10-31 - setup step 2, stance.correct
#     and drive.correct - and in the gated stance.intro, stance.mistake,
#     drive.intro and drive.mistake, every one of which called the arm straight
#     or badged a bent elbow as the fault. WHAT IS MEASURED: elbow_L runs
#     100.2931 to 110.4416 deg and elbow_R 99.1134 to 109.1961, an inner angle
#     where 180 is straight, so the elbow holds 69.6 to 79.7 deg of bend on every
#     one of the 192 frames. f0 was re-derived from J as the upper_arm_L -
#     forearm_L - hand_L angle at 109.3568, bit-equal to the published channel,
#     and the segment check agrees: a 0.2879 m upper arm plus a 0.2498 m forearm
#     is a 0.5377 m straight reach against a shoulder-to-wrist distance of 0.4135
#     to 0.4421 m, 76.9 to 82.2 per cent of straight. It is visible, not just
#     true: projected through this lift's own framing the elbow sits 21.40 to
#     23.05 px off the shoulder-to-wrist line on the near arm, about 6 per cent
#     of frame width. RIGID IS NOT STRAIGHT - the copy had turned a 10-degree
#     range into an angle of 180 - and the entry now says what drive.why already
#     measured, that the arm is a strut which must not collapse (elbow_L 10.149
#     deg, handgap 2.204 mm, shouldergap 2.0e-07 m). stance.correct deliberately
#     opens differently from setup step 2 (the handles where the sled puts them,
#     against at the width the sled sets): the first draft of this fix opened
#     both the same way and pushed this cue's longest shared word run with the
#     step list from 8 to 12, which a FIRST cue can carry but which was a
#     needless regression. It is back to 8 - into one low line from head to
#     heels, shared with step 3 and unchanged from the draft - with only six
#     words (walk your feet back behind you) now shared with step 2, and the
#     cue's 3-word-shingle overlap with the step list is 35.7 per cent against
#     the draft's 53.3. The two strings also drop
#     just outside shoulder width, which is wrong twice: handgap is 0.6279 m
#     against a 0.392155 m shoulder span, 160.4 per cent, so 11.8 cm outside each
#     shoulder - and on a real sled the width is not the lifter's to choose, the
#     posts being 0.560 m apart with the wrists 3.4 cm outside them.
#     THE LABEL IS LEFT TO THE OWNER, with the geometry priced so the choice is
#     free rather than risky. At drawn row 0.32 trailing, pointing at hand_L:
#       22 ch `Arms long on the posts` (as shipped) - lifter 6.9 px, load
#              167.9 px, leader CLEAR 0/192 frames
#       20 ch `Elbows set, chest off`               - lifter 18.1 px, load
#              179.1 px, leader CLEAR 0/192 frames
#       18 ch `Arms take the lean`                  - lifter 29.3 px, load
#              190.3 px, leader CLEAR 0/192 frames
#     (room.py "Sled Push" 18,20,22 and lead.py "Sled Push" hand_L 0.32 trailing
#     at each length.) Both candidates are SHORTER than the label shipped, so
#     both GAIN clearance - 11.2 px and 22.4 px - and none of the three puts a
#     leader on the drawn head. OPTION A (taken by default): keep the label; the
#     cost is that the one place left in the entry calling the arm long sits
#     beside an arm drawn with a 22 px bend. OPTION B: take one of the two
#     priced labels; the cost is nothing geometrical and one line here.
#     For contrast Sled Drag measures elbow_L frozen at 153.0631 deg, 97.3 per
#     cent of a straight reach and a 9.3 px offset, and its arms cue correctly
#     says the same soft bend. The two sled entries had their arm language the
#     wrong way round relative to their own clips.
ex(name="Sled Push", var="sledPush",
   # LABEL GEOMETRY. Five pills, five slots, measured at the pill the app
   # DRAWS - half-height 0.025 in v, width (24 + 5.6 * len(label)) / 382,
   # pinned EDGE 0.035 from the leading (left) or trailing (right) frame edge -
   # against the 655-row SKINNED silhouette (SledPush_SIL.npz, not mesh points:
   # the rig is skinned and GetPointsAttr().Get(t) returns the REST POSE at
   # every time code), against the sled's 1032 projected points, and with every
   # leader tested against the HEAD'S OWN silhouette (SledPush_HEAD.npz), not a
   # box round the head joint - the drawn crown sits 44.2 to 45.0 px above that
   # joint here, mean 44.6. All figures are over ALL 192 FRAMES. The rows named
   # below are the DRAWN rows; overrides carries the RAW 0.14-0.86 values, which
   # spec_1029.py renders at 0.16 / 0.32 / 0.48 / 0.64 / 0.80.
   #
   # THE FRAME. This is the opposite problem to Box Jump. The lifter never
   # moves: the whole midline has an x range of 0.0000 mm and a z range of
   # 0.0002 mm (the march in place above), so the silhouette sits at a CONSTANT
   # u in every band and a pill that clashes clashes for all 192 frames rather
   # than for a window. The lifter spans u 0.0457..0.9018 and occupies v rows
   # 0.1885..0.7733; the head's own silhouette is u 0.2330..0.3645, v
   # 0.1885..0.2802, and the head joint sits at u 0.3163 (it never moves in u)
   # and v 0.2569..0.2656. Per drawn row the lifter's u in the band is: 0.16
   # NONE on 192 of 192 frames, 0.32 u 0.2556..0.5616, 0.48 u 0.4528..0.7436,
   # 0.64 u 0.4764..0.8430, 0.80 NONE on 192 of 192 frames. Rows 0.16 and 0.80
   # are therefore free - by 1.83 px and 0.63 px of real daylight at the worst
   # frame, which is open point 2 and not a free lunch.
   #
   # ONE CONSEQUENCE OF THE 50-DEGREE LEAN THAT DECIDES THE WHOLE LAYOUT: the
   # head is the topmost thing in the frame, so ANY pill at drawn 0.32, 0.48,
   # 0.64 or 0.80 sits BELOW the head rows and its leaders cannot cross the face
   # at all - lead.py reports never spans the head rows for 25 of the 26 probed
   # joints from each of those four slots. Only drawn 0.16 is above the head,
   # and there the two sides are opposites: 0.16 TRAILING is clean for every
   # joint but head up to 26 characters (at 28 it puts hand_R on the face on
   # 108 of 192 frames), while 0.16 LEADING is unusable short and barely usable
   # long - at 10 characters 25 of 26 joints are ON THE FACE, at 16 eleven are
   # on it for all 192 frames, at 22 four are, and even at 28 hand_R is on it
   # for 18 of 192 frames in six runs of three. So the top pill is trailing.
   #
   # room.py "Sled Push" 10,11,12,13,17,19,22  (and 23,24,26,28 for the
   # ceilings), reading lifter clearance px / lifter-overlap frames / load
   # distance px / load-inside frames. THE FIVE SLOTS TAKEN, in cue order:
   #   stance `Arms long on the posts` 22 ch  DRAWN 0.32 TRAILING (raw 0.32)
   #     lifter +6.9 px / 0 FRAMES, load 167.9 px / 0 frames inside - the
   #     TIGHTEST pill in this layout, re-checked with chk.py against the
   #     assembled module. (A draft of this entry quoted +23.7 px and
   #     184.7 px, which are room.py's 19-CHARACTER column at the same slot;
   #     the label is 22 characters and each one costs 5.6 px, so the true
   #     figures are 16.8 px tighter on both counts.)
   #     lead.py "Sled Push" hand_L 0.32 trailing 22 -> anchor edge u 0.5797,
   #     hand_L CLEAR 0/192 (never spans the head rows); the full sweep at that
   #     slot is 25 of 26 CLEAR with only head ON THE FACE, and no pill anchors
   #     on the head. CEILING 23 ch (+1.3 px); 24 ch is -4.3 px on 132 frames.
   #     hand_L projects to a constant u 0.206, LEFT of the anchor edge, so the
   #     leader leaves the pill through its inner edge rather than crossing its
   #     own rectangle - the check lead.py does not make.
   #   torso  `Low lean, flat back`   19 ch  DRAWN 0.16 TRAILING (raw 0.14)
   #     lifter NO SILHOUETTE ROW IN THE BAND on 192 of 192 frames / 0 overlap
   #     frames, load 217.9 px / 0 inside. lead.py neck 0.16 trailing 19 ->
   #     anchor edge u 0.6236, neck CLEAR 0/192, closest 20.9 px at t 0.96 -
   #     the TIGHTEST clear leader in the whole layout, and it is the tightest
   #     because this is the one slot above the head. Full sweep 25 of 26 CLEAR
   #     (hand_R 24.7 px, hand_L 32.0, upper_arm_R 33.9, clavicle_R 37.9, the
   #     feet over 100 px). CEILING 26 ch on the leaders, 28 on the pill.
   #   drive  `Legs do the pushing`   19 ch  DRAWN 0.64 LEADING (raw 0.68)
   #     lifter +38.2 px / 0 FRAMES, and THE SLED IS INSIDE THE PILL ON ALL 192
   #     FRAMES at every length from 8 to 28 characters - open point 3. lead.py
   #     patella_L 0.64 leading 19 -> anchor edge u 0.3764, patella_L CLEAR
   #     0/192; full sweep 25 of 26. patella_L's per-frame u is 0.533..0.702,
   #     entirely RIGHT of the anchor edge, so the leader leaves the pill
   #     correctly. CEILING 24 ch for the lifter (+10.2 px); 26 ch is -1.0 px
   #     on 6 frames. Drawn 0.64 TRAILING is dead: -33.4 px on 192 frames at 10
   #     characters.
   #   steps  `Short steps`           11 ch  DRAWN 0.80 LEADING (raw 0.86)
   #     lifter NO SILHOUETTE ROW IN THE BAND on 192 of 192 / 0 overlap, load
   #     6.8 px / 0 FRAMES INSIDE. lead.py foot_L 0.80 leading 11 -> anchor edge
   #     u 0.2591, foot_L CLEAR 0/192; full sweep 25 of 26. ELEVEN CHARACTERS IS
   #     NEARLY THE WHOLE BUDGET: the visible sled in this band is a 7-pixel
   #     strip at px 105.7..113.0 (CLIPPED u +0.2768..+0.2957; raw
   #     -0.4105..+0.2957), the pill's right edge is at px 99.0 at 11
   #     characters, and the load falls to 1.2 px at 12 characters and is inside
   #     the pill on ALL 192 FRAMES from 13 characters up. foot_L's per-frame u
   #     is 0.730..0.845, right of the anchor edge. The alternative is drawn
   #     0.80 TRAILING, which holds 28 characters with the load 74.9 px away -
   #     but at row 0.80 every natural anchor (the feet and toes, u 0.632-0.845)
   #     lies RIGHT of a trailing pill's inner edge (u 0.4917 at 28 ch), so its
   #     leader would cross its own pill. That is why the bottom pill is leading
   #     and short.
   #   tempo  `Pace you can hold`     17 ch  DRAWN 0.48 LEADING (raw 0.50)
   #     lifter +40.4 px / 0 FRAMES, load a constant 42.6 px / 0 frames inside
   #     at every length. lead.py pelvis 0.48 leading 17 -> anchor edge u
   #     0.3470, pelvis CLEAR 0/192; full sweep 25 of 26. pelvis is the calmest
   #     anchor far from the sled - uv path 0.20, u frozen at 0.620, 189.6 px of
   #     load clearance - which is what a cue about holding one rate wants.
   #     CEILING 24 ch (+1.2 px); 26 ch is -10.0 px on 36 frames.
   # SO ALL FIVE PILLS ARE ZERO-OVERLAP AGAINST THE SKINNED LIFTER AND ALL FIVE
   # LEADERS ARE ZERO-FRAME CLEAR OF THE HEAD'S OWN SILHOUETTE. The round's hard
   # pill rule is met in full, which Box Jump's layout was not. The one thing
   # this layout does not buy is the sled: the drive pill covers the sled's
   # 21-px base strip on all 192 frames and no arrangement on the five-row grid
   # avoids that while keeping five pills (open point 3).
   # Reproduce any figure with, in the cond data folder,
   #   room.py "Sled Push" 10,11,12,13,17,19,22,23,24,26,28
   #   lead.py "Sled Push" hand_L 0.32 trailing 22      (and neck/0.16/19,
   #     patella_L/0.64/19, foot_L/0.80/11, pelvis/0.48/17; `-` for the joint
   #     sweeps all 26)
   #
   # LABEL STRINGS. All five are NEW, because the library has no sled entry of
   # any kind: SampleData.swift's only other Sled string is
   # hackSquatCalfRaiseContent's label Sled high, hold, which is the hack-squat
   # machine. `Short steps` (11) is deliberately not the library's `SHORT STEP`
   # badge (:26917 Forward Lunge), which names the OPPOSITE fault - a lunge step
   # that is too short - and is a badge, not a label. `Arms long on the posts`
   # (22) says what the measurement says and nothing more: the arms are a rigid
   # link (elbow_L 10.149 degrees of travel, handgap 2.204 mm, shouldergap
   # frozen) and the hands take the posts from outside (handgap 160.1% of the
   # shoulder span, wrists 3.4 cm outside the post centres).
   overrides={"stance": (0.32, "trailing"), "torso": (0.14, "trailing"),
              "drive": (0.68, "leading"), "steps": (0.86, "leading"),
              "tempo": (0.50, "leading")},
   annotations=[
       ("stance", "Arms long on the posts", "hand_L"),
       ("torso", "Low lean, flat back", "neck"),
       ("drive", "Legs do the pushing", "patella_L"),
       ("steps", "Short steps", "foot_L"),
       ("tempo", "Pace you can hold", "pelvis"),
   ],
   cues={
       "stance": ("Start Position",
                  "You stand well back from a loaded sled with a hand on each upright post, your elbows set hard and your whole body tipped into one low line.",
                  "The grip and the stance are both measured and both wider or narrower than a reader would guess. The hands are WIDE: handgap is 0.6279 m against a shouldergap frozen at 0.392155 m for all 192 frames, so 160.1% of the shoulder span, and they take the posts FROM THE OUTSIDE - the wrists sit at x plus and minus 0.314 against post centres at plus and minus 0.280, 3.4 cm outside, over a 0.560 m post spacing. The feet are NARROW: anklegap at double support is 0.2882 m, 73.5% of the same shoulder span. The grip is a real grip, which the wrist joint alone would deny: hand_L sits 8.75 cm from Cylinder_097 and hand_R 9.03 cm from Cylinder_096 and no joint ever enters a sled mesh, but extending the elbow-to-wrist line past the wrist - which is where the hand mesh goes - reaches 0.10 cm and 0.36 cm from the post at 10 cm and is inside the post at 12 cm, and a 6x crop of the still shows fingers wrapped round both posts. The lifter starts and stays two thirds of a metre behind the frame: the forward-most toe reaches z -0.3404 against the sled's rear-most point at z +0.3250, a gap of 66.54 cm that never closes. The sled itself is nine static meshes - two 95 cm handle posts, a centre pin, three 40 cm plates, two 95 cm runners and a 72 by 70 cm deck, 74.0 cm wide by 104.5 cm tall by 95.0 cm deep - whose bounding boxes are bit-identical on all 192 frames. On screen only the two handle posts are wholly visible (u 0.0623..0.0893 and 0.1123..0.1431); 50.0% of the sled's projected points fall off the LEFT edge of the frame, so CLIPPED TO THE VISIBLE FRAME it runs u 0.0110..0.2957 and v 0.3611..0.7948, the plates show about a third of themselves and the centre pin is never seen at all - which is why this cue names the posts and nothing else. On load: the literature gives a prescription and this cue does not pass it on as one. Seitz 2017 had 20 rugby league players push at 75% of body mass and sprint 20 m faster at 4, 8 and 12 minutes afterwards, while 125% made them slower at every time point; Martinez-Serrano 2021 found peak power highest at 55%; but Cahill 2021 measured 90 high-school athletes and found that although the load-velocity relationship is highly linear in each individual (r greater than 0.96), the load needed for a given velocity decrement varies greatly between people - so a percentage printed for a general audience would mislead more readers than it helped. The one piece of safety evidence for a non-athletic reader is Baumann 2024: 36 apparently healthy older adults randomised to a progressive sled push or walking completed the protocol with no adverse events, a third of the sled group reporting minimal discomfort. It is an exploratory feasibility study on one machine and establishes no training effect.",
                  "Standing in close to the sled with the elbows folding and the chest resting on the handles, or loading it so heavy that it will not move at all.",
                  "Take the handles where the sled puts them, walk your feet back behind you, and set your body into one low line from head to heels with your elbows braced."),
       "torso": ("Body Angle",
                 "Your body is one low straight line leaning into the sled, and it holds that angle from the first step to the last.",
                 "THE LEAN IS THE ONE THING IN THIS CLIP THAT NEVER CHANGES, and it is the exercise. trunk reads 50.079990 to 50.080019 degrees across all 192 frames - a total of 0.0000296 degrees - and the lumbar, thoracic and neck chains are frozen with it at 170.679, 171.267 and 144.733, zero range on each. The whole midline is a rigid bar that only bobs 22.87 mm up and down: pelvis, spine, chest, neck and head all have an x range of 0.0000 mm and a z range of 0.0001 to 0.0002 mm. So the model shows one angle and CANNOT show it being lost, which is also why this entry badges the fault without a glow that could demonstrate it. The one posture choice the model does make visible is the head: the chest-to-neck segment tilts 55.833 degrees toward the facing direction while the neck-to-head segment tilts only 20.566, so the head is held 35.267 degrees UP off the trunk line - the lifter is looking ahead under a 50 degree lean, not tucked, and that never changes either. What is measured about the lean is measured in TOWING, not pushing, and the copy says so. Lockie 2003 towed 20 men at 12.6% and 32.2% of body mass and found trunk lean, hip flexion and ground contact time all increased while stride length fell about 10% and about 24%. Cronin 2008 towed 20 athletes at 15% and 20% and found sled towing increased trunk angle by 12.5 to 71.5% while a weighted vest at the same relative load DECREASED it by 1.7 to 13.0% - so the lean is the sled pulling the body forward, not the weight pressing it down. Osterwald 2021 took 33 athletes through 40 m at four velocity decrements and found hip, knee, ankle and trunk angle all changed significantly (p less than 0.05) with trunk lean rising LINEARLY with load, and concluded that heavy loads prevented mechanics reflective of maximum-velocity sprinting. All three are a harness, facing forward, with free arms. None of them prescribes an angle, and the only claim that pushing leans further than towing is secondary text on a page that will not open, so it is not used. The commonly quoted 45 degrees is coaching folklore with no standards body behind it; what the coaching sources agree on is holding the angle constant rather than letting the hips rise and the chest drop, which is why this cue says a low lean and gives no number. The model's own 50.08 degrees is close enough to 45 that the picture does not fight the words.",
                 "Letting the hips rise and the chest come up as the set goes on, so the push turns into a stand-up and the sled stops.",
                 "Hold one low forward lean with a flat back and your hips in line with your shoulders for the whole set - if your hips rise and your chest comes up, the sled stops moving."),
       "drive": ("Leg Drive",
                 "The legs do all of it. Your arms only connect you to the sled; they never fold and they never press.",
                 "The ranges settle it. knee_L travels 62.099 degrees over the clip (96.307 at f6 to 158.406 at f0, checked: 158.406 - 96.307) and knee_R 62.107; hip_L travels 35.298 degrees (113.294 to 148.592) and hip_R 35.208. Against that elbow_L moves 10.149 degrees (100.293 at f8 to 110.442 at f18) and elbow_R 10.083, handgap changes 2.204 mm over 192 frames and shouldergap changes 2.0e-07 m - frozen. The knee moves six times what the elbow does, and the arms are a fixed link rather than a motor. The only upper-body motion worth naming is not an arm action at all: the two shoulders stay exactly level with each other at every frame, yet each wrist moves 40.00 mm in y and the two see-saw out of phase (hand_L minus hand_R is -2.69 mm at f0, +37.31 mm at f8 and -42.69 mm at f24), so the grip slides about 2 cm up and down the static posts once per step - 10.9 px and 9.5 px on screen at 2.71 px per cm. That is the rig absorbing the body's 22.87 mm bob, and nothing in this entry describes the arms as doing anything. The knee drive itself is smaller than it looks and no cue asks for a high knee: the knee rises only 5.9 cm while the ankle rises 12.93 cm and the toe 9.65 cm, it travels 28.29 cm FORWARD rather than up, and it never comes above the hip - patella_L peaks at 0.5014 m against a pelvis at 0.8573 to 0.8802 m. On muscle: there is no %MVIC study of a sled push anywhere, so this cue claims no level and no ranking. The only EMG study of the movement is Martinez-Serrano 2021 - nine male amateur rugby union players, called a pilot by its own authors, three muscles, pushing at 20, 55 and 90% of body mass on an instrumented treadmill where the participants did not travel. A heavier sled significantly raised vastus lateralis and gastrocnemius medialis activity (p at or below 0.001 each) while biceps femoris did not change (p = 0.278). Its stated limitation is the non-normalisation of its activation values, so it supports a DIRECTION - heavier sled, more knee-extensor and calf demand, hamstring demand not following - and nothing on the app's HIGH, MODERATE or LOW scale.",
                 "Letting the elbows fold and hauling with the arms until the chest sinks onto the handles and the legs stop driving.",
                 "Push the floor back with your legs, not with your arms - set your elbows at the start and never let them give, so your chest stays off the handles and the legs keep working."),
       "steps": ("Short Quick Steps",
                 "The steps are short and fast, off the ball of each foot, and one foot is always on the floor.",
                 "The cadence is measured and it is a walk, not a sprint: 12 steps over 8.000 s is 1.5 steps per second, 90 STEPS PER MINUTE. Each step is 16 frames, 0.6667 s between the two double-support poses; the swinging foot is off the floor for ELEVEN frames, f1..f11 inclusive, which is 0.4167 s from the first airborne frame to the last and 0.5000 s contact to contact (f0 to f12). BOTH FEET ARE NEVER OFF THE FLOOR - 0 of 192 frames - and 126 of 192 frames have the left toe down, 126 the right, 60 BOTH and 0 NEITHER, so there is no flight phase anywhere and nothing here is explosive. The foot is the other measured fact. There is no heel joint on this rig, so the test is foot pitch, ankle to toe: the planted left foot sits at 46.29 degrees below horizontal at every one of its 126 contact frames, to two decimals, against 21.034 degrees for the same rig standing flat in Box Jump - 25.26 degrees more plantarflexion (checked: 46.2922 - 21.0340 = 25.2581). The lifter is on the balls of both feet for the entire clip and the heel is never down, which is defensible for a real sled push and which means a cue saying heel down or drive through the whole foot would be flatly contradicted on screen. On stride length, coaching is split - one guide calls long strides the fault and another calls overstriding the fault - and the measurement settles it awkwardly: Lockie 2003 found the LOAD itself shortened the stride about 10% at 12.6% of body mass and about 24% at 32.2%, so a short step is what a loaded sled forces rather than something the lifter chooses. This cue therefore asks for quick steps and badges no stride length. For scale, the swinging leg covers 46.20 cm of ankle path per step and finishes with a net displacement of 0.0000 cm.",
                 "Reaching for long slow strides, so each step waits on the other leg and the sled loses speed between pushes.",
                 "Take short fast steps and push off the ball of each foot, keeping one foot on the floor the whole time rather than reaching for long strides."),
       "tempo": ("Setting the Pace",
                 "This one is timed, not counted. You pick a speed at the start and the job is to still be moving at that speed when the clock runs out.",
                 "The app measures this lift in SECONDS: ExerciseCatalog.swift:137 lists Sled Push in timedExercises, so measure(forExerciseNamed:) returns .time, and because SLED is not in isBodyweight()'s equipment list the weight column stays live - seconds with a load. Eleven of the nineteen shipped timed entries end a setup step with the phrase for the set time, and this entry follows them. The clip supports a tempo cue where the jump family's did not, and that is a measured difference rather than a preference: searching circularly for runs whose per-frame maximum joint step falls under 0.001 mm finds 0 of 192 frames and 0 of 192 frame intervals, and the same at 0.01, 0.1 and 1.0 mm - the smallest step anywhere is 3.901984 mm, at f31 to f32, which is also the loop seam, and the largest is 102.270420 mm at f16 to f17. Box Jump, by contrast, held 41.7% of its frames perfectly still. So this model moves continuously at one rate for the whole clip and a cue may speak about rate. What it cannot show is the fault: the clip is six bit-identical 32-frame cycles (a circular lag sweep agrees to 0.0000074506 mm at lag 32 and to no better than 102.2704 mm at lag 1, and each of cycles 1 to 5 matches cycle 0 frame for frame to 7.451e-06 mm Euclidean), and six identical cycles cannot fade, slow or break down. Pacing is therefore coaching and is named as such. It is also unprecedented on the badge surface: in 466 shipped blocks the library has never badged pace, rhythm, tempo, rushing, fatigue or breakdown, nor the breath, grip failure, head position or the environment - although the cue id tempo itself is well established, with 53 shipped uses. The only measured pacing datum anywhere in this family is on battle ropes rather than sleds - Ratamess 2015b found a shorter rest interval raised the metabolic cost of rope work, 52.8% against 40.5% of VO2max in men - and it is deliberately not carried onto a sled.",
                 "Sprinting the first few steps and then stalling with most of the clock left, or stopping the sled and restarting it over and over.",
                 "Start at a pace you can keep to the end of the set time rather than sprinting the first few steps, and keep the sled moving the whole way instead of stopping and restarting it."),
   },
   # Rows, ranks, fractions and stabilisers exactly as the row stage settled
   # them (rows_cond.md 8.1), re-read from tiers_cond.json: 10 bright, 5 dim,
   # nothing faint, nothing one-sided. Bright, so primary: the three vastus
   # heads as one Quadriceps row with the dropped RectusFemoris riding inside
   # it, the two gastrocnemius heads as one Gastrocnemius row, the Soleus on its
   # own, and all three glutes as ONE Gluteus Maximus row on the owner's
   # standing decision. Dim, so secondary: RectusAbdominis, DeltoidAnterior
   # written as Anterior Deltoid (or part_of files it under sideDelts), and the
   # two hamstring muscles as one Hamstrings row with BicepsFemoris inside it
   # (written with the space, or part_of files it under the arm). SEVEN CARRIES
   # AND NO ESTIMATES - the whole primary block comes from Squat Jump
   # :50176-:50180, shipped twelve hours before this round and the library's
   # only block pairing primary quads, a primary calf pair and primary glutes.
   # No library= override: the row stage recommends changing no shipped library
   # row, and QUADS + GLUTES / SLED are not in validate_library()'s word sets.
   # See the header for every line number and for the twelve open points.
   activation=[("Quadriceps", P, HI, 0.84), ("Gastrocnemius", P, HI, 0.78),
               ("Soleus", P, MOD, 0.60), ("Gluteus Maximus", P, MOD, 0.56),
               ("Rectus Abdominis", S, LOW, 0.30),
               ("Anterior Deltoid", S, LOW, 0.30),
               ("Hamstrings", S, LOW, 0.25)],
   stabilisers=["erector spinae", "transverse abdominis", "adductors",
                "forearms"],
   # The badge reuses LOSING THE LEAN, one shipped use (Leaning Lateral Raise
   # :23946, mistakeCue Torso straightens up), so both uses mean the same
   # thing: the lean that defines the set-up is lost. TORSO STANDING UP
   # (:5098) and STAYING UPRIGHT (:37436) are equally defensible single-use
   # alternatives - open point 9 - and SLED SINKING (:33277) must NOT be
   # reused, because it belongs to a leg-press carriage. The correct note is
   # the model's own frozen angle; the mistake note keeps the three towing
   # studies honest - all three towed rather than pushed, none prescribes an
   # angle, and there is no injury mechanism here at all, so nothing claims
   # that losing the lean hurts anyone. What it does is stop the sled. Field
   # lengths against the library: badge 15 characters (median 16, max 29),
   # correctCue 30 (median 26, max 42), mistakeCue 25 (median 27, max 43),
   # correctNote 336 (median 104, max 534) and mistakeNote 538 (median 111,
   # max 562) - the last two are long, and the mistake note was cut from 683
   # to stay inside the shipped maximum, which it now clears by 25 characters.
   comparison=("LOSING THE LEAN", "Body stays low behind the sled",
               "Hips rise, chest comes up",
               "In the model the lean is the one thing that never changes: trunk reads 50.079990 to 50.080019 degrees across all 192 frames, a total of 0.0000296 degrees, with the lumbar, thoracic and neck chains frozen alongside it. That one angle is the whole exercise, and the model cannot show it being lost because it only ever holds the one pose.",
               "Nobody has measured a sled pushed by the hands; what is measured is towing. Lockie 2003 towed 20 men at 12.6% and 32.2% of body mass and found trunk lean, hip flexion and contact time all rose with load while stride length fell about 10% and about 24%; Cronin 2008 found towing raised trunk angle 12.5 to 71.5% while a vest at the same load lowered it; Osterwald 2021 found lean rising linearly with load in 33 athletes. None prescribes an angle, none pushed anything, and there is no injury mechanism - standing up simply stops the sled."),
   # ONE PLAIN glow() CALL PER ROW OF PAINT, in row order, each written out in
   # full - no shared helper. Every joint named is one of the 26 with UV in
   # SledPush_A.json, and glow() averages joints.json's eight probed samples,
   # which are the eight whole-second moments t 0..7 - checked against the UV at
   # frames 0, 24, 48, 72, 96, 120, 144 and 168, which agree to 0.0005 on the
   # still joints and to within 0.011 in u on the two swinging ones, the probe
   # having sampled the fast part of the stride a shade off the frame. Those
   # eight moments land on only four of the 32 cycle phases (0, 24, 16, 8) and
   # two of the four are the same pose, so these are STATIC placements and not
   # phase means - which costs nothing here, because the midline does not move
   # and the paint is two-sided. The four BRIGHT rows get A and the three DIM rows
   # get SOFT: A against SOFT is THE PAINT TIER and nothing else, not depth and
   # not a side, because no painted name on this model carries an _L/_R suffix
   # and the two legs agree to 0.0555 degrees at half a cycle - so no glow
   # claims a near side, a far side or which face of a limb points at the
   # camera. The seven centres are all distinct: quads (0.622, 0.548),
   # gastrocnemius (0.635, 0.618), soleus (0.71, 0.667), glutes (0.62, 0.443),
   # rectus abdominis (0.564, 0.421), anterior deltoid (0.323, 0.315),
   # hamstrings (0.601, 0.493). Two notes. The ANTERIOR DELTOID centre is
   # placed on the measured paint: the only orange above the shorts is a
   # 60-pixel patch at u 0.288..0.359, v 0.302..0.328, whose centre is
   # (0.3235, 0.3150), and the dx and dy below put the ellipse there rather
   # than on the bare clavicle mean. The dx and dy on HAMSTRINGS exist only to
   # separate it from the glute ellipse - thigh_L plus thigh_R averages to
   # (0.6205, 0.4430) against the pelvis at (0.6200, 0.4430), the same
   # coincidence Box Jump hit - and the quad and hamstring ellipses still
   # overlap, which is honest: they are painted over the same stretch of thigh,
   # and at this yaw only its front half reads orange at all.
   glows=[glow("Sled Push", ["thigh_L", "patella_L", "thigh_R", "patella_R"],
               A, 0.55, rx=0.10, ry=0.075, dy=0.03),
          glow("Sled Push", ["shin_L", "shin_R"], A, 0.50, rx=0.085, ry=0.05,
               dy=0.02),
          glow("Sled Push", ["shin_L", "foot_L", "shin_R", "foot_R"], A, 0.45,
               rx=0.075, ry=0.045, dy=0.015),
          glow("Sled Push", ["pelvis"], A, 0.42, rx=0.095, ry=0.06),
          glow("Sled Push", ["chest", "pelvis"], SOFT, 0.30, rx=0.075,
               ry=0.05, dy=0.015),
          glow("Sled Push", ["clavicle_L", "clavicle_R"], SOFT, 0.28, rx=0.06,
               ry=0.04, dx=-0.025, dy=-0.015),
          glow("Sled Push", ["thigh_L", "thigh_R"], SOFT, 0.26, rx=0.09,
               ry=0.055, dx=-0.02, dy=0.05)])

# The setup steps and each cue's `correct` string are the ONLY coaching a
# reader sees outside the gated trainer: ExerciseDetailView.instructions()
# (Features/Train/ExerciseDetailView.swift:447) reads
# ExerciseCatalog.setupSteps at :448 and ExerciseCatalog.formCues at :449, and
# formCues maps each cue to ($0.title, $0.correct) and throws intro, why and
# mistake away - with `mistake` sitting behind the trainer AND the paywall. So
# the one thing this lift has to carry is on both surfaces: the lean is the
# exercise and the push dies the moment you stand up, in step 4 and again in
# the torso cue's `correct`. Four steps at 124, 127, 125 and 122 characters -
# inside the library's p99 of 140 and far inside its 214 record, but well over
# its median of 61 (open point 11). Step 1 says a load you can keep moving
# rather than a percentage of body mass, because Cahill 2021 measured that the
# load for a given velocity decrement varies widely between people; the Seitz
# 2017 and Martinez-Serrano 2021 percentages stay in the gated stance `why`
# (open point 10). Step 4 ends on the timed convention, for the set time, which
# eleven of the nineteen shipped timed entries use verbatim. Nothing in any
# step asks the reader to copy the animation's march in place, and nothing
# coaches around it (open point 1).
SETUP["Sled Push"] = [
    "Set the sled at one end of a clear lane and load it light enough that you can keep it moving at a steady walk the whole way.",
    "Take a handle in each hand at the width the sled sets, set your elbows so they cannot fold, and walk your feet back behind you.",
    "Drop your hips and chest into one low line from head to heels, brace your trunk, and look up the lane, not down at your feet.",
    "Keep that body angle and push with the legs in short quick steps for the set time - the push dies the moment you stand up.",
]
# ------------------------------------------------------------------- sled drag
#
# Sled Drag (Legs/SledDrag), resource SledDrag, yaw -1.3, zoom 0.68, offset
# [0.018, 0.046, -0.066], 192 frames at 24 fps, t 0.0000-7.9583, frame
# 382 x 655. The framing is the app's own: SampleData.swift:3033-3034 reads
# ExerciseModel(resource: SledDrag, framing: ModelFraming(yaw: -1.3,
# zoom: 0.68, offset: [0.018, 0.046, -0.066])) and SledDrag_A.json carries the
# identical triple. The library row is SampleData.swift:353-355 - Exercise(name:
# Sled Drag, category: .legs, primaryMuscle: QUADRICEPS, equipment: SLED,
# difficulty: .beginner) - and there is no sledDrag content in the file at all,
# which is why this entry exists. ExerciseCatalog.swift:137 puts Sled Drag in
# timedExercises, so the app logs it in SECONDS, and isBodyweight(_:) at :108
# does NOT match SLED, so the weight field stays live: it is one of the two
# timed-and-loaded lifts in the app. Nothing below is counted per rep or per
# side, and setup step 4 ends with the house phrase for the set time, which 11
# of the 19 shipped timed entries use (Farmer's Carry :26525, Overhead Carry,
# Farmer Carry March, Calf Raise Hold).
#
# FRAME CONVENTION, because this family has already lost time to it. A window
# written fN..fM is INCLUSIVE and holds M - N + 1 frames; the seconds figure
# attached to it is said to be a frame COUNT or a count of frame INTERVALS every
# time, never left to the reader. f12..f16 is FIVE frames (0.2083 s by count) or
# FOUR intervals (0.1667 s). The clip loops, so one full cycle of 32 frames is
# 32 intervals = 1.33333 s and the whole clip is 192 intervals = 8.0000 s, while
# the published time stamps span 191 intervals = 7.9583 s.
#
# LOAD EXTENTS ARE CLIPPED. The sled geometry runs off the LEFT edge of the
# frame: raw, the 308,736 projected point-samples span u -0.3651..0.5458 and
# v 0.4018..0.7915. EVERY distance and extent quoted below is CLIPPED to the
# visible frame (u 0..1, v 0..1), where the load spans u 0.0019..0.5458 and
# v 0.4018..0.7765 - 207.8 px of the 382 px width (54.4 per cent) and 245.5 px
# of the 655 px height (37.5 per cent), in the lower left. 1074 of the 1608
# projected points are inside the frame on EVERY frame (66.79 per cent,
# constant, because nine of the thirteen meshes never move); the other 534
# (33.21 per cent) are off the left edge, u < 0, on every frame. Nothing of the
# load ever leaves the top, the bottom or the right edge. room.py scores the
# load against the pill in screen space, so its load columns are already
# clipped in the only sense that matters.
#
# THE RIG IS SKINNED. UsdGeom.Mesh.GetPointsAttr().Get(t) returns the REST pose
# at every time code, so every silhouette figure below comes from
# SledDrag_SIL.npz (the evaluated UsdSkel skinning binned into 655 v rows, one
# per rendered pixel row) and every face test from SledDrag_HEAD.npz (the same
# for the vertices whose dominant influence is root/pelvis/spine/chest/neck/
# head). Re-read here: the lifter occupies rows r129..r497 and u 0.4363..0.8133;
# the head's own silhouette occupies rows r129..r178, u 0.6902..0.8044, 45-46
# rows per frame. In row-EDGE v that is 0.19695..0.76031 for the body and
# 0.19695..0.27328 for the head; measure_SledDrag.md quotes the same rows in the
# row-CENTRE convention, (r + 0.5) / 655, as 0.19771..0.75954 and
# 0.19771..0.27250. Both appear below and each is labelled.
#
# THE SHAPE: SIX IDENTICAL CYCLES, AND A MARCH ON THE SPOT.
# A CIRCULAR lag sweep over all 26 joints and all 192 frames gives a period of
# exactly 32 frames = 1.33333 s: the lag-32 residual is 0.000017 mm, which is
# float noise, against 36.765361 mm at the nearest non-multiples (lags 1, 31 and
# 33, and 63, 65, 95, 97, 127, 129, 159, 161, 191), a ratio of about 2.2
# million. 192 / 32 = 6.0000 cycles, two steps each, so 12 steps in 8.0000 s =
# 90 steps a minute, one step every 16 frame intervals (0.66667 s). The clip
# loops seamlessly: |J[0] - J[160]| is 0.000017 mm, and the 1.584843 mm between
# frame 0 and frame 191 is exactly one frame of motion at that point in the
# cycle, being the smallest per-frame step anywhere in the clip.
# THE HALF-PERIOD TRAP: lag 16 is 150.603664 mm, inside the sweep's top band
# (maximum 150.603775 at lag 13), not a second period. Per joint it splits the body in two - the 18
# upper-body joints repeat at lag 16 to 0.0005-0.0011 mm (the torso and arms
# really do repeat every single step, 0.6667 s) while foot_L and foot_R differ by
# 150.6037 and 150.5381 mm because they alternate. The body's period is 32.
# FROZEN RUNS: with the brief's 0.001 mm tolerance there are NONE - 0 frames and
# 0 intervals, 0.0000 s. The slowest interval in the clip moves 1.584843 mm
# (always shin_R, at intervals i15, i31, i47, i63, i79, i95, i111, i127, i143,
# i159, i175, i191), the mean is 20.1632 mm and the fastest 36.765361 mm. A 1e-9
# tolerance finds nothing and is not the test. The only thing ever exactly still
# is a planted foot: foot_L has 6 runs over 119 still intervals (4.9583 s) or 125
# frames in a plateau (5.2083 s), foot_R 7 runs over 119 intervals or 126 frames,
# and the typical left plateau is intervals i12..i31, FRAMES f12..f32, which is
# 21 frames (0.8750 s by count) or 20 intervals (0.8333 s).
#
# THE PHASES, one cycle, f0..f31, t 0.0000..1.2917; add 32k frames and 1.33333k s
# for cycle k = 0..5, and f32 is bit-identical to f0. Stance read from foot
# height (double-support frames in f0..f31 measured as exactly {0, 12, 13, 14,
# 15, 16, 28, 29, 30, 31}).
#   f0 alone          double stance, tall. Both knees at their most extended,
#                     145.59193 and 145.60768, pelvis at its highest 0.871296 m.
#                     The cycle's reference frame.
#   f1..f11           LEFT SWING. 11 frames (0.4583 s by frame count) or 10
#                     intervals (0.4167 s). Lift-off to touch-down, f0..f12
#                     inclusive, is 13 frames (0.5417 s) or 12 intervals
#                     (0.5000 s).
#   f12..f16          double stance, rising. 5 frames (0.2083 s) or 4 intervals
#                     (0.1667 s). BOTH knees extend together, 140.506 to 145.592
#                     and 140.519 to 145.608, and the pelvis rises 11.824 mm.
#   f17..f27          RIGHT SWING, the mirror. 11 frames / 10 intervals; f16..f28
#                     inclusive is 13 frames / 12 intervals, 0.5000 s.
#   f28..f32          double stance, rising; f32 is f0.
# Per cycle: 24 intervals of single support (1.0000 s, 75 per cent) and 8 of
# double support (0.3333 s, 25 per cent); 24 + 8 = 32, the period.
#
# RANGES over the whole clip, re-measured here from SledDrag_A.json:
#   knee_L     104.60730 .. 145.59193   range 40.98464 deg
#   knee_R     104.62132 .. 145.60768   range 40.98635 deg
#   trunk      -13.67014 .. -13.67014   range 0.0000065 deg  (negative = back)
#   elbow_L    153.06307 .. 153.06311   range 0.00004 deg
#   elbow_R    153.06288 .. 153.06292   range 0.00004 deg
#   handgap      0.504002 m             range 0.000000 m
#   shouldergap  0.392155 m             range 0.000000 m   (upper_arm_L to
#                upper_arm_R, NOT the scapulae, which give 0.284868)
#   anklegap     0.28000 .. 0.31921 m   range 0.03921 m
#   pelvis.y     0.847578 .. 0.871296 m range 0.023718 m
#   foot_L.y     0.068600 .. 0.191983 m range 0.123384 m
#   foot_L.z    -0.106348 .. -0.020001  range 0.086347 m
#   hip_L (A)                           range 2.93370 deg  -- DO NOT USE
#   thigh_L tilt from vertical  +14.799 .. +27.186   range 12.387 deg
#   thigh_R tilt from vertical  +14.674 .. +27.122   range 12.448 deg
# THE hip WARNING: A[hip_L] measures the angle at the hip between a ray to the
# CHEST and a ray to the knee, and the hip joint sits 91.4 mm off the sagittal
# plane (x +0.09143 against the chest at x 0), so that channel moves 2.93 deg
# while the thigh segment itself tilts 12.39. Anyone who reads hip range 2.9 deg
# off A and writes that the hip barely moves is wrong. The knee cue uses the
# thigh tilt and says so.
#
# THE FIVE THINGS THE CLIP DOES THAT NOTHING HERE MAY ASK A LIFTER TO COPY:
# (1) NOTHING TRAVELS, NOT THE LIFTER AND NOT THE SLED. This is the big one and
#     it goes to the heart of the exercise. 18 of the 26 probed joints have
#     world x and z frozen to 0.000358 mm or less over all 192 frames - chest,
#     both clavicles, both forearms, both hands, head, neck, pelvis, both
#     scapulae, spine, the pectoral support marker, BOTH HIP JOINTS and both
#     upper arms - and their only motion is a shared vertical bob between
#     23.7178 and 23.7187 mm. foot_L returns to z -0.020001 and y 0.068600 at
#     f12 and foot_R to z -0.020001 and y 0.068565 at f28; whenever both feet are
#     down they sit at the SAME z to 0.000000 m, so they are never staggered and
#     STRIDE LENGTH IS ZERO. The nine static sled meshes travel 0.000 mm at both
#     centroid and bbox corner. So the animation is a march on the spot in front
#     of a sled that never moves, and every setup step and every correct string
#     has to supply the travel itself. No cue points at a stride length, a foot
#     plant position or a sled position, because all three are constants.
# (2) THE ARMS ARE WELDED IN SPACE. handgap 0.504002 m and shouldergap 0.392155
#     with a range of 0.000000 each, both elbows 153.063 deg with a range of
#     0.00004 deg, hand_L world x and z fixed to 0.0003 mm, and on screen the
#     hands move 0.00 px sideways and about 5 px vertically over the whole 8 s.
#     There is no tug, no arm bend and no shoulder give anywhere, so the arms cue
#     is coaching and says so in its why. Note 153.063 deg is NOT straight - it
#     is roughly 27 deg of bend held unchanged - so no string says the arms are
#     straight; they hang 0.38461 m below the shoulder joint (constant to five
#     decimals) with the upper arm 38.9341 deg from straight down.
# (3) THE TRUNK NEVER CHANGES. -13.67014 deg on every one of the 192 frames,
#     range 0.0000065. The backward lean is real and worth naming, but there is
#     no bracing cycle, no sway and no rounding, so anything about not letting
#     the torso rock is the writer's coaching and not a measurement.
# (4) A DOUBLE-LEG BOUNCE NO GAIT HAS. In each double-stance window both knees
#     extend at once, knee_L by 5.086 and knee_R by 5.088 deg, while the pelvis
#     rises 11.824 mm over 4 intervals (0.1667 s). Real walking never extends
#     both knees in double support. No cue here reads as pushing the floor away
#     with both legs between steps.
# (5) THE SWING LEG FOLDS UNDER INSTEAD OF REACHING BACK. The thigh tilts from
#     +14.799 to +27.186 deg toward the way the lifter faces (+12.387) while the
#     ankle sweeps 86.35 mm BACKWARD and 123.38 mm UP and sets down on exactly
#     the same spot. For a backward drag you would normally reach the foot back
#     and plant it behind you; this clip flicks the heel back under a forward-
#     driving knee. So reach the trailing leg back stays out of everything that
#     claims to describe the screen.
# Two smaller ones. THE STRAPS STRETCH: end to end they measure 1.004162 m at f8
# and f24 and 1.021782 m at f0 and f16, a change of 17.620 mm or 1.75 per cent of
# their length EVERY STEP, which no loaded strap does - so strap tension is not
# modelled and there is no slack-to-taut moment to point a cue at. AND THERE IS
# NO HEEL: the 26 probed joints stop at foot_* (the ankle) and toe_*, so the jump
# family's heel-lands-after-the-toe test cannot be run at all. The ankle-to-toe
# segment is rigid (0.149098 m, range 0.0000 mm) and plantar-flexes FURTHER
# during swing, never dorsiflexing anywhere in the clip, and the lowest toe sits
# at y 0.015390 m, above the floor. Any heel or forefoot wording would be the
# writer's invention, so there is none.
#
# THE LOAD: 13 meshes, 1608 points a frame, and the whole sled is scenery.
# Cylinder_104 and Cylinder_102 are the two straps (59.8 x 767.3 x 674.7 mm);
# Cylinder_103 and Cylinder_105 the two handles; Cylinder_096 and Cylinder_097
# the 950 mm upright poles; Cylinder_098 the 430 mm plate post; Cylinder_099,
# _100 and _101 three 400 x 50 mm weight plates; Cube the 720 x 700 mm deck;
# Cube_106 and Cube_107 the two 950 mm skids. NINE OF THE THIRTEEN NEVER MOVE -
# centroid and bbox-corner travel both exactly 0.000 mm over all 192 frames. The
# two handles are parented rather than animated: 23.718 mm of y travel, the
# identical figure the frozen upper body bobs, each centroid staying 98.71 mm
# from its own hand joint to 0.01 mm on every frame. Only the two straps deform,
# sled end pinned (y 0.1632..0.1633, z 0.9477..0.9478, 0.1 mm of wobble) and hand
# end following the handle (y 0.9071..0.9306); the load's union bbox moves
# 2.692 mm in total, all of it ymax. The sled sits at z 0.825..1.775, in FRONT of
# the lifter, who stands at z about -0.17..+0.21. The straps never touch the
# lifter below the hands - nearest approach to a leg joint 317.4 mm (the thigh on
# its own side, at f0), 345 mm to the patella, 369 mm to the shin, which with a
# 59.8 mm mesh is about 290 mm of air. CLIPPED, the plate post (Cylinder_098) is
# never visible at all: 0 per cent of its u span is inside the frame.
#
# THE VIEW. The camera is PERSPECTIVE, not orthographic - a 3x4 projective fit
# reproduces every joint UV to 5.2e-15 in u and 4.8e-15 in v (0.000 px) while an
# affine fit leaves 8.8e-3 in v, 5.8 px, and puts the sled's bottom edge 23 px
# wrong. So there is no single mm-per-row figure: 4.7968 mm per row at the head
# joint, 4.7608 at the pelvis, 4.5547 at foot_L. The camera sits at world
# (5.159, 0.776, 1.723), 5.16 m out on the lifter's LEFT and 1.72 m forward,
# looking along (-0.948, +0.032, -0.317): 71.5 degrees round toward the lifter's
# left, a left profile rotated 18.5 degrees toward the front. So the lifter's
# LEFT reads at HIGH u (hand_L u 0.5872 against hand_R u 0.5079), their BACK at
# high u and their FRONT at low u, the sled is off to the lower LEFT, and v
# counts DOWN. No cue below names a near or a far side and none claims a muscle
# faces the camera; the paint is bilateral on all 31 names, so A against SOFT in
# the glows is the paint tier alone.
#
# THE PAINT, re-read from tiers_cond.json key Legs/SledDrag: 4 BRIGHT at level
# 1.0000, 27 DIM at 0.2556, 0 faint - 31 muscles and 62 meshes, since not one
# name carries the (L) or (R) suffix tiers.py writes for a one-sided mesh, so
# every one is lit on both sides. That is the second-heaviest paint in the family
# (31 against Battle Rope Slams' 30, Rowing Machine's 23 and Sled Push's 15).
# BRIGHT is the quadriceps and nothing else - RectusFemoris, VastusIntermedius,
# VastusLateralis, VastusMedialis - which matches the library row's
# primaryMuscle: QUADRICEPS exactly.
# DIM, grouped by the MusclePart each resolves to: hamstrings (BicepsFemoris,
# Semimembranosus, Semitendinosus); glutes (GluteusMaximus, GluteusMedius,
# GluteusMinimus); calves (GastrocnemiusLateral, GastrocnemiusMedial, Soleus);
# forearms, NINE of them (Brachioradialis, ExtensorCarpiRadialisBrevis,
# ExtensorCarpiRadialisLongus, ExtensorCarpiUlnaris, ExtensorDigitorum,
# FlexorCarpiRadialis, FlexorDigitorumProfundus, FlexorDigitorumSuperficialis,
# PalmarisLongus); upperBack (TrapeziusUpper, TrapeziusMiddle, TrapeziusLower,
# RhomboidMajor); delts (DeltoidAnterior, DeltoidLateral, DeltoidPosterior);
# biceps (BicepsBrachii_LongHead, BicepsBrachii_ShortHead).
# WHAT IS NOT PAINTED matters as much: no RectusAbdominis (Sled Push has it), no
# Sartorius (this rig's hip flexor), no ErectorSpinae, no lats and no adductors.
# So this lift has no core row to argue about and no Hip Flexors silent-drop
# problem, and core, erector spinae and adductors are free for the stabilisers.
# WHAT ACTUALLY REACHES THE RENDER, from the eight stills segmented against the
# floor (painted pixels as a share of figure pixels, by row band):
#   head / neck            r129-185   5.4 per cent   the trapezius strip
#   upper back and delts   r185-250  30.9 per cent   the clearest dim paint
#   torso and arms         r250-332  10.6 per cent   the forearm block
#   hips and upper thigh   r332-395  44.2 per cent   the quads, from the hem
#   thigh                  r395-445  28.2 per cent   the bright quad mass
#   knee / shin            r445-475   3.5 per cent   the calves, barely
#   foot                   r475-510   0.0 per cent   white sneakers, no paint
# THREE THINGS A DRAFTER HAS TO KNOW. The GLUTES are completely hidden by
# Anatomy_Shorts_Surface - the first painted pixel anywhere below the waist is at
# row 326 and there is not one inside the shorts' own area; ShortsGluteZone.swift
# (wired in at USDZViewport.swift:543) exists for exactly this and leaves no
# trace in these stills, and the control rules out a dim-level explanation
# because Sled Push, whose glutes are painted BRIGHT at 1.0000, has IDENTICAL
# fabric statistics (R-minus-B percentiles -13 / -10 / -3 on both lifts, and the
# buttock band reads -10.90 against -10.21 at the front of the shorts, a
# difference of 0.7 of 255). That is open point 1. VastusIntermedius is painted
# bright and can never be visible, lying under RectusFemoris by construction -
# legal to name, but a name for nothing on screen. And RhomboidMajor sits under
# TrapeziusMiddle, which from a left profile makes it the least visible dim thing
# after the glutes - naming the upper back is fine, pointing at the rhomboids is
# pointing at pixels that are not there.
# THE part_of() TRAPS ON THIS LIFT, checked name by name. Palmaris Longus
# returns None and its row would be SILENTLY DROPPED (none of brachioradialis /
# forearm / wrist / grip / finger / digitorum / pollicis / carpi occurs in it),
# and it is in HAND as well, so validate() flags it before the app does: ALL NINE
# forearm meshes ride inside one Forearms row, which is also what the README's
# one-group rule asks for and what 60 of the library's 75 secondary Forearms rows
# do at 0.30. Deltoid Anterior resolves to sideDelts but Anterior Deltoid to
# frontDelts, and Deltoid Posterior to sideDelts but Posterior Deltoid to
# rearDelts - tiers_cond.json has the words in the order part_of() mis-files, so
# the rows read Anterior Deltoid / Lateral Deltoid / Posterior Deltoid.
# THE OWNER'S STANDING DECISION ON THE GLUTES is applied: the rig lights maximus,
# medius and minimus as ONE unsplit group, so there is a single Gluteus Maximus
# row, the copy says glutes, and NO string in this entry names the gluteus medius
# anywhere - not in a row and not in the stabilisers, where it is otherwise the
# library's ninth-commonest value (46 blocks).
#
# SOURCES, and this is the thinnest-evidenced lift of the seven. THERE IS NO EMG
# STUDY OF SLED DRAGGING AT ALL, %MVIC or raw, so no string below claims a muscle
# level, a muscle ranking or an outcome for any muscle, and all twelve fractions
# are library carries or the one family estimate (see the activation comment).
# The measured literature used is:
#  - West, Cunningham, Finn, Scott, Crewther, Cook and Kilduff 2014, J Strength
#    Cond Res 28(1):265-272, PMID 23575361, ABSTRACT ONLY. 11 strength-trained
#    men, 5 sets of 2 x 20 m maximal BACKWARD drags at 75 per cent of body mass,
#    30 s between drags and 120 s between sets. Countermovement-jump peak power
#    fell from 4,445 +/- 705 W to 3,464 +/- 819 W immediately after (p = 0.001)
#    and was back at baseline by 3 h; blood lactate went 1.7 +/- 0.5 to
#    12.4 +/- 2.6 mmol/L and was still raised at 60 min (3.8 +/- 1.9, p = 0.004);
#    NO change in creatine kinase at any time point. It is a recovery time-course
#    study, so it belongs in a gated why and in a setup step about session order,
#    never in a safety claim, and it says nothing about which muscles work.
#  - Keogh et al. 2010, J Strength Cond Res 24:3088-97, PMID 19996774. 6
#    resistance-trained men with heavy-sled experience, 3 x 25 m at 171.2 kg: a
#    heavy sprint-style sled PULL shared much of acceleration-sprint kinematics
#    but had SMALLER step lengths and step rates, LONGER ground contacts and a
#    MORE HORIZONTAL TRUNK. It is forward, harnessed and n = 6, it measured no
#    muscle activity, and more horizontal is relative to sprinting rather than an
#    instruction. Used only to say that the literature names no angle.
#  - Lockie 2003 and Osterwald 2021 both find trunk lean RISES WITH LOAD on towed
#    sprints and neither prescribes a value; Seitz 2017 is the one
#    evidence-backed prescription anywhere in the sled literature and it is about
#    LOAD, not posture, and about the PUSH - 75 per cent of body mass potentiated
#    a later 20 m sprint while 125 per cent impaired it at every time point.
# COACHING, named as coaching: neutral spine, constant tension on the strap, do
# not stand up tall, drive through the legs. No NASM or other governing-body sled
# guideline could be found, the sources disagree about hand and arm position, and
# the familiar 45-degree lean figure is folklore - it is not quoted anywhere in
# this entry.
# DELIBERATELY NOT USED: McGill 2009 (PMID 19528856), the obvious-looking
# strongman trunk citation, which did NOT include a sled drag or a sled push -
# its events were the farmer's walk, super yoke, Atlas stone, suitcase carry, keg
# walk, tire flip and log lift, so citing it for a sled is a category error;
# Harris 2016, which cannot separate the drag from three other strongman events
# in the same session; and any muscle level, ranking or injury-prevention claim,
# because none exists for this movement.
#
# WHAT THE READER ACTUALLY SEES. ExerciseDetailView.instructions() is the only
# ungated surface and shows the SETUP steps and, for each cue, its TITLE and its
# correct string. intro, why, mistake, the pill labels, the comparison and the
# stabilisers are not on that screen, and mistake is behind the trainer AND the
# paywall. So the one thing this lift has to carry - that it is the BACKWARD
# drag, that you cannot see where you are going, and that the knees stay bent all
# the way - lives in setup steps 2 and 3 and in the correct strings of path,
# knee and steps, and nowhere else. The library has no badge for anything in the
# environment (297 distinct mistake badges over 466 blocks, not one about a
# floor, a wall or a lane), so there is no shipped wording to lean on.
#
# OPEN POINTS FOR THE OWNER, recorded and not decided:
#  1. DO THE GLUTES READ ON DEVICE? All three glute meshes are painted dim and
#     100 per cent covered by the shorts in all eight stills (first painted pixel
#     below the waist at row 326), and the Sled Push control shows it is not a
#     dim-level problem: bright glutes there give byte-for-byte the same fabric
#     statistics. ShortsGluteZone.swift has been wired into
#     USDZViewport.styleBody since 2026-10-28 to fix exactly this.
#     - Option A, taken here: trust ShortsGluteZone and keep the Gluteus Maximus
#       secondary row and its glow. Cost: if the tint really is absent, the sheet
#       names and the glow marks something the reader cannot see, on the one lift
#       where hip drive is half the point.
#     - Option B: treat them as invisible, drop the row to 11 and drop the glow.
#       Cost: a backward sled drag with no glute row is wrong on the muscle sheet
#       and contradicts the paint.
#     - Cheapest way to settle it: open Sled Push in the app and look at whether
#       the shorts go red. Thirty seconds on device, and it settles both lifts.
#  2. TWELVE ROWS AND A LEGEND THAT SHOWS THREE. rows_cond.md 8.2 settles the
#     table at 12 rows, 1 primary and 11 secondary, which ties the all-time
#     maximum. The primary legend line is QUADRICEPS, 10 characters, the only
#     line in the family with room to spare. The SECONDARY line is 162
#     characters, which would be the longest legend line in the app, beating
#     Dumbbell Clean and Press's 139, and shows 3 of its 11 names at both
#     budgets: TRAPEZIUS . LATERAL DELTOID . FOREARMS, 38 characters, fitting
#     exactly at the tighter secondary budget (PRIMARY and SECONDARY are separate
#     Text views in the same HStack, so the secondary line is about 2 characters
#     tighter than the primary one - 38 and 41 against 40 and 43). Nothing is
#     lost from TARGET MUSCLES: Sheets.swift:95 is an uncapped ForEach, so all 12
#     rows draw their bars. Keeping 12 is Option A; trimming the tail to the
#     three names the legend can show is Option B and costs eight painted groups
#     their row. Reordering buys nothing: the cut falls at name 3, before the
#     eight-way tie at 0.30 begins.
#  3. THE TRAPEZIUS SPLIT (rows_cond.md open point 1, which spans five lifts).
#     TrapeziusUpper, Middle and Lower are all lit and this entry gives them ONE
#     unsplit Trapezius row. Here that is the safe side of the fork: 54 of the
#     library's 56 unsplit Trapezius rows are SECONDARY, which is the rank this
#     lift needs, unlike the Rowing Machine, where the same choice would need a
#     primary Lower Trapezius row with zero precedent. All candidates part_of()
#     to upperBack, so TARGET MUSCLES is identical either way.
#  4. LATERAL DELTOID AT 0.40 READS MODERATE (rows_cond.md open point 5). All
#     three deltoid heads are painted dim, the anterior and posterior carry
#     cleanly at 0.30 (n = 6 and n = 16), but the library has NO secondary
#     Lateral Deltoid row below 0.40 - the whole set is 0.70, 0.66, 0.60, 0.54,
#     0.50, 0.45, 0.40 - so a dim strap-holding lateral delt lands above its own
#     two neighbours and second on the lift. Estimating it at 0.30 to match them
#     invents a new value for that muscle at that rank. Measured cost of the
#     switch: NONE in the legend, 3 of 11 names either way, with only the third
#     name changing from FOREARMS to LATERAL DELTOID.
#  5. THE Rhomboids 0.30 ESTIMATE is the one invented value on this lift and the
#     only estimate in its twelve rows (rows_cond.md 5 and open point 9).
#     Rhomboids has exactly one secondary row in the whole library and it is 0.72
#     (Rear Delt Row :25180), which level() makes HIGH and which would put a dim
#     postural mesh above everything here but the quads; the muscle's primary
#     floor is 0.45. 0.30 is the upperBack secondary floor (Trapezius S 0.30 at
#     Machine Pullover :22228, Landmine Shoulder Press :23322, Half-Kneeling
#     Landmine Press :23424). The alternative is to drop the row and let the
#     Trapezius row carry the upper back, which changes no legend and no TARGET
#     MUSCLES entry (both part_of() to upperBack) at the cost of one painted mesh
#     its row.
#  6. THE BADGE MAY COLLIDE WITH SLED PUSH. The lean fault has three single-use
#     badges available and all three fit both sleds: STAYING UPRIGHT (1, Chest
#     Dip :37434, mistakeCue Trunk stays upright), LOSING THE LEAN (1, Leaning
#     Lateral Raise :23944, Torso straightens up) and TORSO STANDING UP (1,
#     Barbell Bent-Over Row :5096, Torso rises, turns into a shrug).
#     sources_safety.md 3.2 fault 4 records that Sled Push has the same fault
#     with the sign reversed and the same three candidates. This entry takes
#     LOSING THE LEAN on the reasoning that STAYING UPRIGHT reads as the push's
#     (a forward lean that must not stand up), but the two entries are being
#     drafted in parallel and nobody has checked. If both took the same one the
#     result is a badge count of 2 where the library had 1 - legal, but not
#     deliberate.
#  7. ROW 0.16 TRAILING IS LEFT UNUSED. It is the sixth usable slot and the only
#     other one that takes a full 28 characters, but its SAFETY IS COUPLED TO
#     LABEL LENGTH, which no other slot on this lift is: at 13 characters the
#     anchor edge lands at u 0.7116, inside the torso, and 18 of the 26 probed
#     joints are ON THE FACE on all 192 frames (head -19.2 px, scapula_L -20.9,
#     upper_arm_L -20.5), while at 28 characters the anchor is pushed out to
#     u 0.4917 and all 25 non-head joints clear, worst upper_arm_L 5.8 px. A
#     longer label is SAFER there than a short one. This entry uses 0.16 leading
#     instead, which is clean at every length tested. If a future label on this
#     lift needs a sixth slot, 0.16 trailing has to be re-measured at that exact
#     length rather than assumed.
#  8. ROW 0.64 TRAILING CAPS THE KNEE LABEL AT 11 CHARACTERS. Knees bent is 10
#     and leaves 10.7 px of lifter clearance with 0 overlap frames; 11 characters
#     leaves 5.1 px; 12 characters is -0.5 px and on the lifter in 12 frames; and
#     Knees stay bent, 15, is -17.3 px and on the lifter in all 192. If the owner
#     wants a longer knee label the only other home is 0.48 leading, which then
#     needs Arms long moved down to 0.64 trailing at 9 characters (16.3 px) - and
#     that swap puts the knee pill on the hip row and the arm pill on the knee
#     row, which is why it was not taken.
#  9. HOW HONEST TO BE ABOUT THE MARCH ON THE SPOT (measure_SledDrag.md open
#     point 3). Setup steps 2 and 4 and the steps cue's correct string all supply
#     travel the model does not show, and no string describes the screen as
#     travelling. The alternative is a step that names the mismatch out loud,
#     which spends one of three to five public steps on an artefact. Not decided.
# 10. ONE QUADRICEPS ROW OR THE PAINTED HEADS (measure_SledDrag.md open point 4).
#     All four painted heads part_of() to quads, so this is purely legend length
#     and taste. QUADRICEPS is 10 characters and fits with room to spare; RECTUS
#     FEMORIS . VASTUS LATERALIS is 33 and also fits; adding VASTUS MEDIALIS
#     makes 51 and cuts mid-word. A four-head table would also name
#     VastusIntermedius, which lies under RectusFemoris and can never be seen.
#     rows_cond.md 8.2 settled the one-row form and this entry uses it.
# 11. A FIFTH SETUP STEP FOR THE ONE MEASURED FACT? West 2014 is the only study
#     of a backward drag and its finding is about the session, not the technique:
#     a hard drag costs about a fifth of your jump power for up to three hours,
#     with no creatine kinase rise. sources_safety.md 3.2 says it belongs in a
#     gated why OR in a setup step, and the jump family set a precedent for the
#     shape (Squat Jump step 3 ends jump early in the session while your legs are
#     fresh) - though the sign is reversed here, because a drag DEPLETES jump
#     power rather than needing it, so the drag goes LAST.
#     - Option A, taken: four steps, and the fact stays in path.why, gated.
#       Cost: the one citable measurement on the lift never reaches a free
#       reader.
#     - Option B: a fifth step, Save hard drags for the end of a session: one
#       costs about a fifth of your jump power for up to three hours (107
#       characters, inside the budget). Cost: 5 steps is 14 of 467 shipped
#       blocks, 3.0 per cent, against 4 in 295, so it leaves the house shape for
#       a programming note on a beginner-tier lift.
ex(name="Sled Drag", var="sledDrag",
   # LABEL GEOMETRY. Five pills, five slots, measured at the pill the app DRAWS
   # (half-height 0.025 in v, width (24 + 5.6 * len)/382, pinned EDGE 0.035 from
   # the leading or trailing frame edge) against the 655-row SKINNED silhouette
   # and the HEAD's own silhouette, over all 192 frames, with room.py and lead.py
   # from the round folder. Rows quoted here are the DRAWN rows; overrides below
   # carries the RAW 0.14 / 0.32 / 0.50 / 0.68 / 0.86 values that spec_1029.py's
   # row() squeezes to the drawn 0.16 / 0.32 / 0.48 / 0.64 / 0.80. Every load
   # figure is clipped to the visible frame, as the header says.
   #
   #   path    0.16 leading,  25 ch (Check the lane behind you) - the band holds
   #           NO silhouette at any length, so 0 of 192 overlap frames, and the
   #           pill bottom at v 0.185 clears the crown of the head by 7.825 px
   #           (row-edge v 0.19695) or 8.32 px (row-centre v 0.19771); load
   #           142.0 px and inside 0/192; leader to foot_R CLEAR 0/192 frames,
   #           closest 71.1 px at t = 0.92
   #   torso   0.32 leading,  23 ch (Lean away from the sled) - lifter 62.1 px,
   #           0 of 192 overlap frames; load 37.2 px, inside 0/192; leader to
   #           chest CLEAR 0/192 (it never spans the head's own v rows at all)
   #   arms    0.48 leading,   9 ch (Arms long) - lifter 85.4 px, 0/192; load
   #           27.4 px, inside 0/192; leader to hand_L CLEAR 0/192 (never spans
   #           the head rows)
   #   knee    0.64 trailing, 10 ch (Knees bent) - lifter 10.7 px, 0/192; load
   #           129.3 px, inside 0/192; leader to patella_L CLEAR 0/192 (never
   #           spans the head rows)
   #   steps   0.80 trailing, 19 ch (Short, steady steps) - the band holds no
   #           silhouette, 0/192 overlap frames, and the pill top at v 0.775
   #           clears the lowest lifter row by 9.625 px (row-edge v 0.76031) or
   #           10.13 px (row-centre v 0.75954); load 145.5 px, inside 0/192;
   #           leader to foot_L CLEAR 0/192 (never spans the head rows)
   #
   # SO THE LAYOUT IS CLEAN: zero lifter-overlap frames and zero load-inside
   # frames on all five pills, and every leader CLEAR on all 192 frames. There is
   # no breach to report on this lift.
   #
   # Why those five and not others, in numbers. SIX of the ten slots are usable
   # and FOUR are dead:
   #   0.64 leading   UNUSABLE at every length tested, 9 to 28 ch: the lifter is
   #                  clear (113.2 px at 9 ch) but the STRAP is inside the pill
   #                  on all 192 frames, load clearance 0.0 px. Row 0.64 is where
   #                  the straps' lower run crosses, clipped u 0.002..0.046.
   #   0.32 trailing  UNUSABLE from 9 ch: -16.4 px and on the lifter in all 192
   #                  frames. The binding edge is the lifter's back at u 0.5975.
   #   0.80 leading   9 ch ONLY, and then by 1.9 px of load; from 10 ch up the
   #                  skid is inside the pill on all 192 frames. The skid reaches
   #                  v 0.7915, inside the 0.80 band.
   #   0.48 trailing  9 ch ONLY, 3.2 px; 10 ch is -2.4 px on all 192 frames.
   # Ceilings on the six that work, each the last length with 0 overlap frames
   # and 0 load-inside frames: 0.16 leading 28 ch (the lifter is never in the
   # band and the load sits 142.0 px away at EVERY length, so the only ceiling is
   # the 28-character validate() limit); 0.16 trailing 28 ch on the pill but see
   # open point 7 on its leader; 0.32 leading 28 ch (34.1 px lifter, 37.2 px
   # load); 0.80 trailing 28 ch (95.1 px load, no lifter); 0.48 leading 24 ch
   # (1.4 px lifter and 6.9 px load, with 25 ch going to -4.2 px on the lifter in
   # 84 frames and 26 ch swallowing the handles on all 192); 0.64 trailing 11 ch
   # (5.1 px, with 12 ch at -0.5 px in 12 frames).
   # - NO TWO OF THE FIVE SHARE A DRAWN ROW, so the pill-versus-pill ceiling
   #   never binds. For the record it is 27 characters each: a leading pill ends
   #   at 0.035 + w and a trailing one starts at 1 - 0.035 - w, which leaves
   #   +4.9 px at 27 and 27 and -6.3 px at 28 and 28, a COLLISION that room.py
   #   cannot see because it scores each pill against the lifter and the load and
   #   never against the other pill. At the lengths used here, 25 and 19 on one
   #   row would still have been +55.3 px.
   # - THE ANCHOR CHOICE WAS UNUSUALLY FREE, and that is a measurement, not an
   #   assumption: a full lead.py sweep at each of the five slots reports EVERY
   #   probed joint CLEAR on all 192 frames except head itself, which is ON THE
   #   FACE 192/192 from all five (-16.2 to -17.7 px). The reason is structural -
   #   the head's own silhouette occupies rows r129..r178 and every drawn row
   #   except 0.16 lies BELOW it, so a leader from 0.32, 0.48, 0.64 or 0.80
   #   cannot enter the head's rows at all. Row 0.16 is the one row above them,
   #   so it is the only slot whose leaders cross the head band, and it still
   #   clears at 25 ch: foot_R 71.1 px, toe_R 76.3, toe_L 73.0, foot_L 67.7,
   #   hand_R 80.8, chest 47.6. So the anchors below were picked for meaning and
   #   for leader length, not for safety.
   # - path takes 0.16 leading rather than any shoulder-height slot because the
   #   three joints that TIGHTEN from row 0.16 are exactly the shoulder ones - at
   #   26 ch upper_arm_L is 7.4 px, neck 8.2 and scapula_L 12.3 - while every leg
   #   anchor is 63-76 px. It is anchored at foot_R, the far foot and the one at
   #   lower u, so the leader stays on the front side of the frame; foot_L was
   #   left to steps rather than shared.
   # - arms takes 0.48 leading at 9 characters rather than at that slot's 24
   #   character ceiling: at 24 ch the lifter clearance is 1.4 px and the load
   #   6.9, at 14 ch they are 57.4 and 27.4, and at 9 ch they are 85.4 and 27.4.
   #   The binding edges there are the lifter's left silhouette edge at u 0.4532
   #   and the HANDLES, which are the only load inside that band (clipped
   #   u 0.468..0.546, on screen all 192 frames). Row 0.48 is also the hand row:
   #   hand_L sits at v 0.429 against the band's v 0.455..0.505.
   # - knee takes 0.64 trailing because row 0.64 is the knee row - patella_L
   #   v 0.597..0.606 against the band's v 0.615..0.665 - and because the only
   #   load near it is 129.3 px away. Its 11-character ceiling is open point 8.
   # - steps takes 0.80 trailing anchored at foot_L because the library already
   #   wrote this exact pill: overheadCarryContent, SampleData.swift:26743, is
   #   CueAnnotation(cueID: steps, label: Short, steady steps, labelSide:
   #   .trailing, joint: foot_L) at labelPoint y 0.700. Same cue id, same string,
   #   same side, same joint, on the library's other timed walking hold.
   #
   # LABEL STRINGS, checked against SampleData.swift:
   #   Short, steady steps (19) - REUSE x1, overheadCarryContent :26743, cue id
   #     steps, joint foot_L, trailing. The only existing use, and it is the
   #     library's own timed walking lift.
   #   Arms long (9) - REUSE x10: :30383 and :30483 (cue id sides), :30678,
   #     :34986, :42256, :44178, :44276, :44376 (arms), :30989 (hold), :45557
   #     (extend). It is the library's standard label for an arm that holds
   #     rather than pulls, which is exactly this lift's arm, and at 9 characters
   #     it leaves the most room of any label here.
   #   Knees bent (10) - NEW, but it is the shortest member of a large shipped
   #     family: Knees straight x15, Knees soft x3, Knees bent, feet flat x2
   #     (21 ch). The 21-character version was dropped on geometry, not on sense:
   #     row 0.64 trailing caps at 11.
   #   Lean away from the sled (23) - NEW. The library has Leaning away as a
   #     mistake badge (4 uses) but no lean label of its own, and the sled has to
   #     be named because the direction of the lean is the whole lift.
   #   Check the lane behind you (25) - NEW, and necessarily so: the library has
   #     no label, no cue and no badge anywhere about the space the lifter moves
   #     into. 297 distinct mistake badges over 466 blocks and not one names a
   #     floor, a wall or a lane.
   overrides={"path": (0.14, "leading"), "torso": (0.32, "leading"),
              "arms": (0.50, "leading"), "knee": (0.68, "trailing"),
              "steps": (0.86, "trailing")},
   annotations=[
       ("path", "Check the lane behind you", "foot_R"),
       ("torso", "Lean away from the sled", "chest"),
       ("arms", "Arms long", "hand_L"),
       ("knee", "Knees bent", "patella_L"),
       ("steps", "Short, steady steps", "foot_L"),
   ],
   cues={
       "path": ("Walking Backwards",
                "You travel backwards, away from the sled, so you cannot see the ground you are about to cover.",
                "The direction IS the lift, and the clip states it in one channel that never moves: trunk sits at -13.67014 deg on all 192 frames, negative being backwards, with a range of 0.0000065 deg. At the reference frame f0 both feet are flat and level, the knees 34.408 deg short of straight, the thigh 14.799 deg forward of vertical and the shank 16.304 deg back - the knees-forward, hips-back, lean-away shape of a backward drag - and the hands hang 0.38461 m below the shoulder joint, constant to five decimals, with the upper arm 38.9341 deg from straight down. Nothing else in the frame carries the direction. The lifter does not travel: 18 of the 26 probed joints have world x and z frozen to 0.000358 mm or less, the head among them, so the model never turns to look behind it either, and the sled does not move. This is the only acute hazard in the family and the library has no badge for anything in the environment - 297 distinct mistake badges across 466 blocks and not one about a floor, a wall or a lane - so if a setup step and this string do not say it, no surface the reader can reach will. West 2014 measured the session rather than the technique: 11 strength-trained men, 5 sets of 2 x 20 m backward drags at 75 per cent of body mass, countermovement-jump peak power falling from 4,445 +/- 705 W to 3,464 +/- 819 W immediately after (p = 0.001) and back at baseline by 3 h, blood lactate 1.7 +/- 0.5 to 12.4 +/- 2.6 mmol/L and still raised at 60 min, and NO change in creatine kinase at any time point. That is the only thing measured about a backward drag anywhere, it is a programming fact rather than a technique one - a hard drag costs about a fifth of your jump power for up to three hours, with no marker of muscle damage - and it stays here, gated, rather than spending one of the four public setup steps. There is no EMG study of sled dragging at all and no governing-body standard for it, so nothing in this entry claims a muscle level or a trunk angle.",
                "Setting off backwards without looking at the lane first, or craning round so far that the lean collapses and the strap goes slack.",
                "Clear a straight lane behind you and look down it before the first step, then travel backwards along it and glance over your shoulder every few steps."),
       "torso": ("Lean Away",
                 "Your hips sit back and your whole trunk leans away from the sled, so the strap never goes slack.",
                 "trunk is -13.67014 deg on every one of the 192 frames, a range of 0.0000065 deg - the most constant channel in the clip. The lean is real and worth naming, but it never changes, so there is no bracing cycle, no sway and no rounding in the animation: anything about not letting the torso rock is coaching and not a measurement. The shape it holds alongside the lean: the knees run 34.408 to 75.393 deg of flexion, the pelvis rides 0.847578 to 0.871296 m, and the hands stay 0.38461 m below the shoulder joint. The measured literature prescribes no angle. Keogh 2010 - 6 resistance-trained men, 3 x 25 m at 171.2 kg - found a heavy sprint-style sled PULL had a more horizontal trunk than acceleration sprinting, with smaller step lengths, lower step rates and longer ground contacts; but that is a forward harnessed pull, it measured no muscle activity at all, and more horizontal is relative to sprinting rather than a target. Lockie 2003 and Osterwald 2021 both find trunk lean rises with load on towed sprints and neither names a value, and no NASM or other governing-body sled guideline could be found. The familiar 45-degree figure is folklore and is not used. What the coaching sources are consistent about is the FAULT, for the drag specifically: standing up too tall. McGill 2009, the obvious strongman trunk citation, did not include a sled drag or a sled push and is deliberately not cited.",
                 "Standing up taller as the set goes on, so the strap goes slack and the sled stalls between steps.",
                 "Sit your hips back and lean away from the sled, then hold that same angle from the first step to the last instead of letting your chest rise."),
       "arms": ("Arms Hang Long",
                "Your arms only hold the strap. The legs are what move the sled.",
                "The arms are welded in space for the whole clip, so this string is coaching and not a description of the screen: handgap is frozen at 0.504002 m and shouldergap at 0.392155, both with a range of 0.000000; both elbows sit at 153.063 deg with a range of 0.00004 deg; hand_L world x and z are fixed to within 0.0003 mm; and on screen the hands move 0.00 px sideways and about 5 px vertically over the whole 8 s. There is no tug, no arm bend and no shoulder give anywhere, so the model shows neither this fault nor its fix. Note what 153.063 deg is NOT: it is about 27 deg of bend held unchanged, not a straight arm, with the hands 0.38461 m below the shoulder joint and the upper arm 38.9341 deg from straight down - which is why this says soft bend and never says straight. The strap is modelled as geometry rather than as rope: end to end it measures 1.004162 m at f8 and f24 and 1.021782 m at f0 and f16, a change of 17.620 mm or 1.75 per cent of its length on EVERY step, which no loaded strap does, so there is no slack-to-taut moment in the clip to point at. It never touches the lifter below the hands either: the nearest it comes to a leg joint is 317.4 mm, to the patella 345 mm and to the shin 369 mm, which with a 59.8 mm mesh is about 290 mm of air. The paint supports the cue only weakly, in that all of it here is dim: nine forearm muscles, both biceps heads and all three deltoid heads at level 0.2556, the forearm block reading as 10.6 per cent of the figure pixels in rows 250-332. The library badge for the fault is PULLING WITH THE ARMS, 4 uses - Cable Wood Chop :12188, Cable Shrug :25950, Machine Crunch :42236, Landmine Rotation :44452.",
                "Bending the elbows to haul the sled along, so the arms and the grip give out long before the legs do.",
                "Let your arms hang from your shoulders with the same soft bend at the elbow all the way through, so your hands only hold on and your legs move the sled."),
       "knee": ("Knees Stay Bent",
                "Both knees stay bent for the whole drag. They never straighten out at the top of a step.",
                "knee_L runs 104.60730 to 145.59193 deg and knee_R 104.62132 to 145.60768, ranges of 40.98464 and 40.98635, and the two sides never differ by more than about 0.016 deg. So even at its tallest, frame f0 of every cycle, the knee is 34.408 deg short of straight, and at its deepest 75.393 - it never approaches a lockout anywhere in the clip. Read the THIGH rather than the published hip channel: A hip_L moves only 2.93370 deg, because the ray it measures runs to the chest while the hip joint sits 91.4 mm off the sagittal plane, whereas the thigh segment itself tilts 12.387 deg (14.799 to 27.186) toward the way the lifter faces. The quadriceps are the only BRIGHT paint on this lift - 4 of the 31 painted muscles at level 1.0000, the other 27 at 0.2556 - which matches the library row primaryMuscle QUADRICEPS, and they are the clearest paint in the render too, 44.2 per cent of the figure pixels in rows 332-395 and 28.2 per cent in rows 395-445. But there is NO EMG study of sled dragging, %MVIC or raw, so nothing here claims a level or a ranking for them. One thing the clip does that no lifter should read as an instruction: in each double-stance window both knees extend together, knee_L by 5.086 and knee_R by 5.088 deg over 4 frame intervals (0.1667 s), with the pelvis rising 11.824 mm. No real gait extends both knees in double support, so no string here asks for a two-legged push between steps.",
                "Letting the knees straighten between steps, so the hips ride up and the quads stop doing the work.",
                "Keep a bend in both knees from the first step to the last, and push each step away through the front of your thighs rather than straightening the leg to get there."),
       "steps": ("Short Steady Steps",
                 "Short, steady steps keep the sled moving. Long reaching steps let it stall.",
                 "THIS IS THE CUE THAT CARRIES WHAT THE MODEL CANNOT SHOW: the clip is a march on the spot in front of a sled that never moves. 18 of the 26 probed joints have world x and z frozen to 0.000358 mm or less over all 192 frames - chest, both clavicles, both forearms, both hands, head, neck, pelvis, both scapulae, spine, the pectoral marker, BOTH HIP JOINTS and both upper arms - and their only motion is a shared vertical bob between 23.7178 and 23.7187 mm. foot_L returns to z -0.020001 and y 0.068600 at f12 and foot_R to z -0.020001 and y 0.068565 at f28; whenever both feet are down they sit at the SAME z to 0.000000 m, so they are never staggered and stride length is zero. The nine static sled meshes travel 0.000 mm. What the clip does give is a cadence: a circular lag sweep finds a period of exactly 32 frames, 1.33333 s, with a residual of 0.000017 mm against 36.765361 mm at the nearest non-multiple, so 192 frames are 6.0000 cycles of two steps - 12 steps over 8.0000 s, 90 steps a minute, one step every 16 frame INTERVALS (0.66667 s). Each swing is 11 FRAMES, 0.4583 s by frame count, or 10 frame INTERVALS, 0.4167 s; lift-off to touch-down, f0 to f12 inclusive, is 13 frames (0.5417 s) or 12 intervals (0.5000 s). Per cycle that is 24 intervals of single support (1.0000 s, 75 per cent) and 8 of double support (0.3333 s, 25 per cent). That 90 a minute is this animation and not a prescription, which is why no public string quotes it. Two things the clip forbids: the thigh drives 12.387 deg forward while the ankle sweeps 86.35 mm BACKWARD and 123.38 mm UP and lands on the same spot, so the swing leg folds under rather than reaching back and no string says reach the trailing leg back; and a freeze sweep at 0.001 mm finds zero frozen frames and zero frozen intervals, the slowest interval in the clip moving 1.584843 mm, so there is no pause anywhere to hang a tempo on.",
                 "Reaching each foot far back, or stamping away on the spot without actually covering any ground.",
                 "Keep covering ground with short, steady steps and never let the sled come to a stop between them, so the strap stays tight the whole way."),
   },
   # ROWS, STABILISERS AND FRACTIONS EXACTLY AS THE ROW STAGE SETTLED THEM
   # (rows_cond.md 8.2 and 4.2, re-verified there by final.py against level(),
   # part_of(), fraction-descending order, the one-primary rule, the
   # double-quote and backslash ban, lower-case stabilisers and the
   # no-gluteus-medius rule: 0 failures). TWELVE ROWS, 1 PRIMARY and 11
   # SECONDARY, which TIES THE ALL-TIME MAXIMUM row count in the library - 1 of
   # 466 blocks reaches 12 and the distribution's median is 3 - and the SECONDARY
   # TAIL IS A NEW MAXIMUM ON ITS OWN: no shipped block has more than nine
   # secondary rows (Dumbbell Clean and Press :49427), so eleven is +2, and
   # nothing in the file pairs a tail that long with a single primary row. Eight
   # blocks in 466 have one row in total. The library has NO ANALOGUE for this
   # lift at all,
   # so nothing is carried wholesale; every row is carried muscle by muscle, and
   # the two nearest parents each cover only half of it (Leg Extension :7158
   # gives the one-row quad-primary shape, Farmer's Carry :26525 the
   # grip-and-trap-under-load shape of a timed walking hold).
   # BRIGHT paint, so primary: the four quadriceps meshes as ONE Quadriceps row
   # at 0.84 - the library's stepping-lift value, carried from Squat :12339,
   # Lunge :12438 and Barbell Lunge :27004 (n = 7), and the same figure Sled Push
   # takes, so the two sleds read as a pair. Leg Extension's 0.91 was not carried:
   # it is a seated isolation.
   # DIM paint, so secondary, every one of the seven lit MuscleParts getting a
   # row: Trapezius 0.44, the walking-loaded-hold value from Suitcase Carry
   # :26702 and Kettlebell Clean :49110 (n = 4; the alternatives were 0.42 from
   # the two static holds and 0.36, the library's commonest trapezius value);
   # Lateral Deltoid 0.40 from Plate Front Raise :24512 and Barbell Front Raise
   # :24609 (n = 5), forced up to MODERATE because the library has no secondary
   # Lateral Deltoid row below 0.40 - open point 4; Forearms 0.30, the library's
   # pinned value in 60 of its 75 secondary forearm rows, carrying ALL NINE lit
   # forearm meshes in one row; Biceps Brachii 0.30 from Barbell Upright Row
   # :25383 (n = 12); Anterior Deltoid 0.30 from Barbell Power Clean :48833
   # (n = 6); Posterior Deltoid 0.30 from Lat Pulldown :5683 and Deadlift :4979
   # (n = 16); Rhomboids 0.30, THE ONE ESTIMATE on this lift and open point 5;
   # Gluteus Maximus 0.30 from Back Extension :6404 and Glute-Ham Raise :35891;
   # Gastrocnemius 0.30 from Swiss Ball Leg Curl :36258 (n = 6); Soleus 0.30 from
   # Dumbbell Lying Leg Curl :48296, Box Jump :49984 and Step-Up Jump :50082 -
   # all three of the library's secondary soleus rows are 0.30, so the
   # knee-straight gastrocnemius-above-soleus gap of +0.18 to +0.20 does not
   # apply at this rank and the twelve-hour-old jump family already shipped the
   # tie; Hamstrings 0.25 from Hack Squat (Stances) :3158 (n = 13).
   # ELEVEN OF THE TWELVE ARE SAME-NAME, SAME-RANK, SAME-FRACTION CARRIES from a
   # named shipped row. The eight-way tie at 0.30 is ordered by nothing and that
   # costs nothing: the legend is cut at name 3, before the tie begins.
   # THE GLUTES ARE ONE ROW because the rig lights maximus, medius and minimus as
   # one unsplit group - the owner's standing decision - so the copy says glutes
   # and nothing anywhere in this entry names the gluteus medius.
   activation=[("Quadriceps", P, HI, 0.84),
               ("Trapezius", S, MOD, 0.44), ("Lateral Deltoid", S, MOD, 0.40),
               ("Forearms", S, LOW, 0.30), ("Biceps Brachii", S, LOW, 0.30),
               ("Anterior Deltoid", S, LOW, 0.30), ("Posterior Deltoid", S, LOW, 0.30),
               ("Rhomboids", S, LOW, 0.30), ("Gluteus Maximus", S, LOW, 0.30),
               ("Gastrocnemius", S, LOW, 0.30), ("Soleus", S, LOW, 0.30),
               ("Hamstrings", S, LOW, 0.25)],
   # Stabilisers are judgement, not paint - a stabiliser is by definition
   # unpainted, so tiers_cond.json can only VETO, never confirm. All three are
   # vetoed-clean here: the drag paints no RectusAbdominis, no ErectorSpinae and
   # no adductor, so core is legal on the drag where it is not on the push (which
   # paints RectusAbdominis and therefore uses transverse abdominis instead).
   # forearms is deliberately NOT listed: on this lift it has a row. Three is the
   # library's modal count (196 of 466 blocks) and core (246 uses), erector
   # spinae (81) and adductors (58) are all high-frequency values. No list names
   # the gluteus medius.
   stabilisers=["core", "erector spinae", "adductors"],
   # THE BADGE. LOSING THE LEAN is a single-use library badge (Leaning Lateral
   # Raise :23944, mistakeCue Torso straightens up) and this is the fault every
   # general sled source names for the drag. It is the right badge here for the
   # reason the jump family used: THE MODEL DEMONSTRATES THE CORRECT SIDE OF IT
   # EXACTLY, and holds it - trunk -13.67014 deg on all 192 frames with a range
   # of 0.0000065, and a knee that never passes 145.59193, i.e. 34.408 deg short
   # of straight. Not used: PULLING WITH THE ARMS (4 uses, :12188, :25950,
   # :42236, :44452), which is semantically right and which the arms cue's
   # mistake already states, but whose correct side the model also holds frozen,
   # so it would spend the one comparison slot restating cue 5; SLED SINKING (1,
   # Leg Press Calf Raise :33275), where the sled is a machine carriage and not a
   # sled, so reusing it would read oddly beside the shipped entry; and SHORT
   # STEP (1, Forward Lunge :26915), because stride length is a constant in this
   # clip and nothing may point at it. The collision risk with Sled Push is open
   # point 6. The mistakeNote claims no injury outcome and no activation, because
   # neither exists for this movement. Field lengths against the 466-block
   # census: correctCue 24 (median 26, p90 32, max 42), mistakeCue 27 (median 27,
   # p90 32, max 43), correctNote 300 (median 104, p90 142, max 534), mistakeNote
   # 506 (median 111, p90 149, max 562) - long, but inside the shipped ceiling. A
   # first draft of the mistakeNote ran to 637 characters, which would have been
   # a new maximum, and the Keogh sentence was cut from it because the torso cue
   # already carries that study in full.
   comparison=("LOSING THE LEAN", "Knees bent, leaning away",
               "Torso stands up, knees lock",
               "In the model the lean never moves: trunk sits at -13.67014 deg, negative being backwards, on every one of the 192 frames, a range of 0.0000065 deg - and the knee never passes 145.59193 deg, which is still 34.408 deg short of straight, so the shape the clip holds is exactly the one this cue asks for.",
               "Standing up tall is the fault every general sled source names for the drag, and it is coaching rather than a measured outcome: there is no EMG study of sled dragging at all, no governing-body guideline for it, and no trial has tested a posture cue on a sled. The only evidence-backed prescription anywhere in the sled literature is LOAD rather than posture, and it comes from the push: Seitz 2017 found 75 per cent of body mass potentiated a later sprint while 125 per cent impaired it at every time point."),
   # ONE GLOW PER PAINTED SCREEN REGION, not one per row. The jump family's rule
   # was one glow per row of paint, which worked at five rows; at TWELVE it would
   # put twelve ellipses on a 382 x 655 frame, several of them on the same
   # pixels, because seven of the eleven secondary rows are upper-body groups
   # that project into two bands. So the rule applied here is one glow per band
   # the still audit actually measures, and the two rows that share a band are
   # named: BICEPS BRACHII has no glow of its own because the biceps lies inside
   # the arm band the forearm glow already marks, and RHOMBOIDS has none because
   # RhomboidMajor sits under TrapeziusMiddle and from this left-profile camera
   # is the least visible dim mesh on the model after the glutes - the upper-back
   # glow covers the band it would mark. Six glows, which sits inside the
   # library's range (0 to 12 across 125 spec blocks, mode 2) and matches the
   # jump family's 4 to 6.
   # glow() averages joints.json's EIGHT probed samples, so every centre below is
   # a static placement and not a phase mean. BRIGHT paint takes A at 0.55, the
   # 27 dim meshes take SOFT at 0.28 - the paint tier alone, not a depth claim,
   # since all 31 names are bilateral. The centres, computed from joints.json and
   # checked against the still audit's row bands:
   #   quads        u 0.625 v 0.536  thigh and patella, both sides. Inside the
   #                measured quad band, rows 332-445 = v 0.507-0.679, the two
   #                heaviest-painted bands on the model (44.2 and 28.2 per cent).
   #   hamstrings   u 0.665 v 0.548  thigh both sides, dy +0.075. It lands 0.040
   #                HIGHER in u than the quad glow, which is the right side of
   #                the leg for a posterior group given the back reads at high u
   #                - but that is an accident of where the joint means fall, not
   #                a measurement of the paint, and it is SOFT and flatter for
   #                that reason. Front and back of one thigh project to nearly
   #                the same place, exactly as the jump family found.
   #   glutes       u 0.665 v 0.488  pelvis, dy +0.015. THIS MARKS THE HIP, NOT
   #                VISIBLE PAINT: the shorts cover the whole buttock and the
   #                first painted pixel below the waist is at row 326, v 0.498.
   #                It is here because the row is here, and open point 1 is the
   #                honest caveat on both.
   #   calves       u 0.633 v 0.677  shin and foot both sides, dy +0.015, which
   #                puts it at the top of the measured calf band, rows 445-475 =
   #                v 0.679-0.725. The shin JOINT alone sits at v 0.605, above
   #                the paint, so the foot joints are averaged in to drop it.
   #                That band is only 3.5 per cent painted - the calves barely
   #                register at dim - so the glow is the dimmest thing here by
   #                area as well as by tier.
   #   upper back   u 0.739 v 0.317  scapulae and upper arms, both sides. Inside
   #   and delts    rows 185-250 = v 0.282-0.382, which at 30.9 per cent is the
   #                clearest dim paint in the frame.
   #   forearms     u 0.598 v 0.406  forearms and hands, both sides. Inside rows
   #                250-332 = v 0.382-0.507, 10.6 per cent painted, the block
   #                that reaches down-left toward the handles.
   glows=[glow("Sled Drag", ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.55, rx=0.10, ry=0.085),
          glow("Sled Drag", ["scapula_L", "scapula_R", "upper_arm_L", "upper_arm_R"], SOFT, 0.28, rx=0.09, ry=0.055),
          glow("Sled Drag", ["forearm_L", "forearm_R", "hand_L", "hand_R"], SOFT, 0.28, rx=0.08, ry=0.06),
          glow("Sled Drag", ["thigh_L", "thigh_R"], SOFT, 0.28, rx=0.07, ry=0.06, dy=0.075),
          glow("Sled Drag", ["pelvis"], SOFT, 0.28, rx=0.07, ry=0.045, dy=0.015),
          glow("Sled Drag", ["shin_L", "shin_R", "foot_L", "foot_R"], SOFT, 0.28, rx=0.07, ry=0.045, dy=0.015)])

# SETUP. Four steps, all under the 135-character budget (library median 61,
# p99 132, longest ever shipped 214). These and the five correct strings are the
# ONLY surface an ungated reader gets, so between them they have to carry three
# things the model cannot show and the exercise name does not say: that the drag
# goes BACKWARD (step 2), that the lane behind you has to be looked at before you
# move (step 2, because the library has no badge for anything in the environment
# and mistake is behind the trainer AND the paywall), and that the lifter supplies
# the travel the clip does not (steps 2 and 4). Step 1 sets the equipment and the
# arms the Arms long pill names; step 3 sets the shape the clip holds frozen -
# hips back, a quarter squat of 34.408 deg of knee flexion at its shallowest,
# heels down, leaning away; step 4 ends with for the set time, the phrase 11 of
# the 19 shipped timed entries use, because ExerciseCatalog.swift:137 logs this
# lift in seconds, and nothing here is per rep or per side. No step names a
# stride length, a foot plant or a sled position, all three being constants in
# this animation. FOUR rather than five: a setup-step census of setup.py (467
# entries, 1,724 steps) gives 3 steps in 158 blocks (33.8 per cent), 4 in 295
# (63.2 per cent) and 5 in only 14 (3.0 per cent), with step length median 61,
# p99 140 and max 214 - so four is the house shape and the fifth step West 2014
# would have bought is open point 11 rather than a silent addition.
SETUP["Sled Drag"] = [
    "Load the sled, take a strap or handle in each hand, and face it with your arms long and the strap already tight.",
    "You walk the whole set backwards, so clear a straight lane behind you and check it is empty before you start.",
    "Bend your knees a little and lean away from the sled with your hips under you, heels down and weight through the whole foot.",
    "Walk backwards with short, steady steps and keep the strap tight so the sled never stops, for the set time.",
]
# ================================================================ rowing machine

# ------------------------------------------------------------- rowing machine
#
# Back/RowingMachine.usdc, framing yaw -1.35 rad (-77.35 degrees), zoom 0.694,
# offset [-0.006, 0.057, 0.028], viewport 382 x 655 - the app's own three
# numbers, byte-identical to SampleData.swift:3051-3052, so every figure below
# is measured on the model the app actually draws. THE CLIP IS 192 FRAMES at
# 24 fps = 7.9583 s of elapsed time over 191 intervals, and frame f = round(t
# * 24). World: Y up, the lifter faces +z, the lifter's left is +x, metres.
# Knee, hip and elbow are inner angles (180 straight) and trunk is the
# neck-over-pelvis line from vertical, positive forward; the rig joint called
# forearm_* IS the elbow and hand_* is the wrist. The ankle angle is not in
# the published A block - it is the inner angle shin-foot-toe, recomputed here
# per side from the joint positions.
#
# TWO IDENTICAL STROKES, PERIOD EXACTLY 96 FRAMES = 4.0000 s. A circular lag
# sweep over all 26 joints and all 192 frames, using the EUCLIDEAN per-joint
# distance, agrees to 0.000584 mm at lag 96 and to no better than 68.2681 mm
# at lag 95 or 97. Twenty-two of the 26 joints are bit-identical at lag 96;
# the whole residual is in the arm chain (hand_R 0.000584, hand_L 0.000499,
# forearm_R 0.000350, forearm_L 0.000274 mm). The clip loops cleanly: the
# wrap from f191 to f0 disagrees by 0.5765 mm, which is one frame of motion
# and the SLOWEST of all 191 intervals. Every figure below is stroke 1 and
# repeats at t + 4.0000 s. DO NOT call lag 48 the next nearest lag: at
# 914.2032 mm it is the second-shallowest local minimum of the curve but 62 of
# the 191 lags beat it, lag 5 among them at 285.3419 mm.
#
# THE CLIP NEVER FREEZES. Per-frame maximum joint step over the 191 intervals:
# min 0.576624, max 68.268042, mean 25.145542 mm. At the round's 0.001 mm
# tolerance, ZERO intervals belong to a frozen pose - and zero at 0.01 mm and
# at 0.1 mm as well; only at 1.0 mm do 5 intervals appear (f95-f96, f31-f32,
# f127-f128, f32-f33, f128-f129). So no cue may describe a hold. What IS
# pinned is individual channels while the whole body translates: knee_L/R for
# f16..f54 (39 frames, 1.5833 s), hip_L/R for f24..f42 (19 frames, 0.7500 s),
# trunk at +15.3313 for f58..f95 plus f0..f7 and at -20.1677 for f24..f42,
# pelvis z for f15..f58 (44 frames, 1.7917 s), and handgap at 0.245723 m on
# every single frame, range 0.0000 m.
#
# FOUR TRAPS THIS LIFT SETS, all of which cost measurement time:
# (1) THE RIG IS SKINNED. GetPointsAttr().Get(t) on a body mesh returns the
#     REST pose at every time code, so every silhouette figure below comes
#     from the pre-computed RowingMachine_SIL.npz (655 rows, one per rendered
#     pixel row) and RowingMachine_HEAD.npz, never from mesh points.
# (2) THE LOAD RUNS FAR OUTSIDE THE FRAME. Raw, the apparatus projects to
#     u -0.4804 to +0.9983, v 0.4506 to 0.7761. EVERY load figure in this
#     entry is CLIPPED to the visible frame (u 0..1, v 0..1) and said to be
#     clipped. Clipped, the apparatus covers u 0.0701..0.9983, v 0.4506..
#     0.7688, and 165,120 of the 286,080 projected load points - 57.72% - are
#     on screen, with 42.28% off the LEFT edge and 0.00% off the right, the
#     top or the bottom. CORRECTION TO THE ROUND BRIEF, which lists this
#     lift's off-frame reach as u 0.998: 0.9983 is the apparatus right-hand
#     extreme and it is INSIDE the frame by 0.6 px. The excursion is on the
#     LEFT, to u -0.4804, the flywheel, 183.5 px beyond the left edge.
# (3) eqpts ARE MESH VERTICES, NOT A FILLED SILHOUETTE. Every box part is a
#     56-point cube sampled only at its corners, so the 2.11 m monorail reads
#     as two clusters - one off-screen at u -0.183 and one at u 0.977-0.998 -
#     with nothing sampled in between, although the rail is DRAWN as a
#     continuous bar right across the frame. Any nearest-load-point figure,
#     room.py's load column included, can therefore call a pill or a leader
#     clear of the rail while it sits squarely on top of it. The leader test
#     in the LABEL GEOMETRY block below is run against the CONVEX HULL of
#     each mesh's projected vertices instead; all 18 parts are convex solids
#     (boxes, two cylinders, a sphere), so the hull IS the drawn silhouette.
# (4) FRAME WINDOWS ARE INCLUSIVE. f29..f40 is TWELVE frames and ELEVEN
#     intervals; the seconds figure differs by 1/24 depending on which you
#     mean. Every window below gives the frame COUNT and the interval count,
#     and says which produced the seconds.
#
# THE PHASES, inclusive windows. One stroke is f0..f95 - 96 frames, 95
# intervals, 3.9583 s - and 4.0000 s including the wrap to f96 = f0 of the
# next stroke. That is 15.000 strokes per minute, which is a demonstration
# tempo and NOTHING in the copy quotes or implies it.
#   A  catch, the slowest instant   f95..f96   2 frames   0.0417 s   0.5766 mm
#   B  leg drive by the knee        f0..f16   17 frames  16 int  0.6667 s
#   B' leg drive by the seat        f0..f15   16 frames  15 int  0.6250 s
#   C  body swing back              f7..f24   18 frames  17 int  0.7083 s
#   D  arm pull                     f18..f30  13 frames  12 int  0.5000 s
#   E  finish                       f30..f34   5 frames   4 int  0.1667 s
#   F  arms away                    f34..f45  12 frames  11 int  0.4583 s
#   G  body over                    f42..f58  17 frames  16 int  0.6667 s
#   H  recovery slide by the knee   f54..f95  42 frames  41 int  1.7083 s
#   H' recovery slide by the seat   f58..f95  38 frames  37 int  1.5417 s
# B/B' and C overlap at f8..f16, C and D at f18..f24, F and G at f42..f45, and
# G and H at f54..f58. THAT OVERLAP IS THE ROWING SEQUENCE - legs, then back,
# then arms on the drive; arms, then back, then legs on the recovery - and it
# is the one thing on this lift the copy can assert with the picture behind
# it. By the seat alone the stroke splits exactly: 15 intervals driving
# (0.6250 s) + 43 parked at the finish (1.7917 s) + 38 sliding forward
# (1.5833 s) = 96 intervals = 4.0000 s, and 0.6250 + 1.7917 + 1.5833 = 4.0000.
#
# WHOLE-CLIP RANGES: knee_L 76.6989..175.9932 (99.2943 deg), knee_R
# 76.7104..176.0943, hip_L 53.5990..122.5228 (68.9239), elbow_L
# 54.6294..175.0821 (120.4527), trunk -20.1677..+15.3313 (35.4990),
# ankle_L 107.1819..150.0683 (42.8864, derived), shouldergap 0.3773..0.4094
# (0.0321 m), handgap 0.2457..0.2457 (0.0000 m), anklegap range 0.0011 m,
# pelvis z 30.2194 cm of seat travel, hand-midpoint z 102.6285 cm of handle
# travel, pelvis y 8.8451 cm of rise.
# CATCH, f0 and f96: knee 76.699 (103.301 deg of bend), hip 53.599, elbow
# 175.082, trunk +15.3313 forward, ankle 107.182 dorsiflexed, seat at its
# forward end (pelvis z -0.060436), hands furthest out (mid z +0.646861),
# scapulae widest (shouldergap 0.409358), and the shoulders 19.10 cm in front
# of the hips (clavicle_L z 0.1306 against pelvis z -0.0604).
# FINISH, f30..f34: knee 175.993, hip 122.523, elbow 54.629 (its clip
# minimum, at f130 in stroke 2), trunk -20.1677 back, ankle 150.058, seat at
# its back stop, handle nearest (hand mid z -0.379424 at f31), scapulae most
# retracted (shouldergap 0.377253 at f28).
# Nothing in the body ever leaves the frame: the skinned silhouette occupies
# rows 198..451 of 655, v 0.3031..0.6893, u 0.0567..0.9085.
#
# THE LOAD. eq_names holds 18 meshes and 1,490 points per frame, and FOURTEEN
# OF THE EIGHTEEN ARE SCENERY - centroid travel 0.0000 m and maximum
# per-frame step 0.0000 mm over all 192 frames. Only four are driven:
# HG_Handle (Cylinder_096, 144 pts) by the hands, HG_Chain (Cylinder_097, 144)
# by the handle, and HG_SeatCushion plus HG_SeatCarriage (Cube_113, Cube_114,
# 56 each) by the hips. The moving-point indices confirm the slicing: of the
# 1,490 points, 398 move, in runs 168-311 (the handle), 1066-1101, 1103-1173
# and 1175-1321 (the chain tail, the carriage and the cushion).
#   HG_Handle   a 40.00 x 3.40 x 3.40 cm bar, constant size, RIGIDLY CARRIED
#               by the hands: centroid-to-hand-midpoint 0.108432..0.108442 m,
#               a spread of 0.010 mm over 192 frames. handgap is 0.245723 m at
#               EVERY frame on a 40 cm bar, so the hands never slide and there
#               is no grip change to coach. Its centroid y stays 0.8400..
#               0.8800 - within 4 cm of level across 102.63 cm of travel, so
#               this is a flat horizontal pull and not an arc. On screen its
#               mid-u runs 0.0897 to 0.6764, 224.10 px of the 382, inside a v
#               band of only 0.451..0.477. 100% of its points are on screen on
#               all 192 frames.
#   HG_Chain    one stretched cylinder, not links. Far end pinned (box z-max
#               1.2101 m, spread 0.000077 m), near end on the handle axis.
#               CLIPPED, the visible chain is a near-horizontal line at
#               v 0.4560..0.4723 - pixel rows 298.7 to 309.4, a band 10.7 rows
#               deep - running from the LEFT FRAME EDGE to the handle in all
#               192 frames, 34 px long at the catch and 258 px at the finish.
#               Its fixed end is 69.9 px beyond the left edge. 50% of its
#               points are on screen.
#   seat        cushion 38 x 9 x 30 cm plus carriage 12 x 5 x 22 cm, z
#               difference 0.00000000 m at every frame, so one rigid body.
#               Centroid z range 0.308420 m against the pelvis joint's
#               0.302194 m - a 6.23 mm slip, with nothing visible from it.
#               Cushion top a constant y 0.3400. Both parts 100% on screen,
#               cushion u 0.440..0.821, carriage u 0.476..0.776.
#   scenery     HG_Rail (the 2.11 m monorail, v 0.657..0.698, drawn right
#               across the frame - see trap 3), HG_RailFoot, HG_RailFoot_001,
#               HG_RailSupport, HG_RailSupport_001, HG_FootStretcher (the
#               footplate, u 0.100..0.290), HG_HeelCup and HG_HeelCup_001,
#               HG_FootStrap and HG_FootStrap_001, HG_FrontFoot, HG_FrontLeg,
#               HG_ChainHousing and HG_Flywheel (a 362-point sphere).
# THE WHOLE HEAD OF THE MACHINE IS OFF THE LEFT EDGE IN ALL 192 FRAMES -
# flywheel, chain housing, front foot and front leg are 0% on screen - and the
# flywheel NEVER TURNS, being a static sphere. So no cue may say the flywheel,
# the fan, the monitor or the damper: the reader cannot see any of them.
#
# WHAT THE ANIMATION DOES THAT A LIFTER MUST NOT COPY. Three real, and three
# that look like faults in the numbers and are not, recorded so nobody
# rediscovers them and puts them in the copy.
# (a) THE CATCH IS NOT A FULL-COMPRESSION CATCH, SO SHINS VERTICAL STAYS OUT.
#     The f0 knee of 76.699 looks deep, but the knee joint sits 0.1797 m
#     BEHIND the ankle in z (shin_L z 0.2749 against foot_L z 0.4546), so the
#     shin leans 27.1007 deg BACK from vertical in the sagittal plane
#     (27.1158 on the right). The seat travels only 30.22 cm. Hart 2006
#     teaches a vertical shin; every one of the 192 frames contradicts it.
#     NO CUE AND NO SETUP STEP IN THIS ENTRY MENTIONS THE SHIN AT ALL - the
#     catch is described by the knee bend, the straight arms and the shoulders
#     being in front of the hips, all three of which are measured and visible.
#     Open point 4.
# (b) THE KNEE NEVER STRAIGHTENS, 4 DEGREES SHORT, AND THAT READS CORRECTLY.
#     knee_L maxes at 175.9932 and knee_R at 176.0943, both held to within
#     0.0008 deg for the whole of f16..f54 - 39 frames of every 96. A soft
#     knee at the finish is what a coach wants, so this is a cue and not a rig
#     fault, but NOTHING says legs locked out or drive until the legs are
#     straight. The finish cue says keep a soft bend.
# (c) THE HEEL NEVER LEAVES THE PLATE AND THE FOOT BARELY TURNS, SO NO HEEL
#     CUE. Over the whole clip foot_L moves 16.13 mm in y, 2.16 mm in z and
#     0.54 mm in x, and toe_L moves 0.89 mm in y and 1.16 mm in z. The derived
#     ankle angle swings 42.8864 deg, so about 37 of those degrees are the
#     shin moving over a foot effectively nailed to the stretcher. That is
#     what a strapped footplate does, and it is defensible - but many rowers
#     lift the heel at the catch and this model shows none of it. This is the
#     direct analogue of the jump family's rope that never reaches the floor.
# (d) NOT A FAULT: THE PELVIS JOINT CLIMBS 8.85 cm OFF A FIXED SEAT AND
#     NOTHING SHOWS. pelvis y rises 0.395392 to 0.483843 while the cushion top
#     stays at a constant y 0.3400, so the hip joint goes from 5.54 cm above
#     the seat to 14.38 cm above it (0.143843 - 0.055392 = 0.088451). It does
#     not render: tested against the cushion's own projected top edge at every
#     sixth frame, the lowest lifter row inside the cushion's u span is 4.7 to
#     5.4 px BELOW that edge at every frame sampled. The bone origin moves
#     inside the flesh as the pelvis tilts; the skin stays on the seat.
#     Nothing to keep out of the copy, but also nothing to build a cue on.
# (e) NOT A FAULT: NOTHING PASSES THROUGH ANYTHING. The handle's closest
#     approach to patella_L is 0.4323 m (f43), 0.4141 m above and 0.0140 m in
#     front of the knee. Treated as the straight segment from its anchor to
#     the handle centroid, the chain's closest probed joint is chest at
#     0.2252 m (f32). The handle's screen rectangle lies between the lifter's
#     leftmost and rightmost silhouette pixels in its rows on 192 of 192
#     frames, but umin/umax is a per-row min/max and not a filled mask, so
#     that is a SPAN test and not an occlusion test; the stills show the bar
#     correctly in the hands and in front of the torso.
# (f) NOT A FAULT, BUT DECISIVE FOR THE COPY: THE CADENCE IS A DEMONSTRATION.
#     15.000 strokes per minute, drive 0.6250 s of seat motion against a
#     1.5833 s slide forward, 1 : 2.533, plus a 1.7917 s window in the middle
#     where the seat is parked and only the back and the arms work. Nothing in
#     this entry quotes or implies a stroke rate.
# Also measured for the drafter's protection: THE WRIST IS NEVER ABOVE THE
# SHOULDER - hand_L sits 2.52 to 19.17 cm below clavicle_L on all 192 frames,
# 0 of 192 above - so nothing says lift the handle; and handgap is constant to
# 0.000017 m, so nothing coaches a grip change.
#
# PAINT (tiers_cond.json, key Back/RowingMachine): 23 painted names, 16 BRIGHT
# and 7 DIM, nothing faint, and NOTHING ONE-SIDED - every name resolves to
# both an _L_Mesh and an _R_Mesh, so 23 names are 46 of the rig's 125 skinned
# meshes.
#   bright: DeltoidPosterior; GluteusMaximus, GluteusMedius, GluteusMinimus;
#           Infraspinatus, Subscapularis, Supraspinatus, TeresMinor;
#           RhomboidMajor; TrapeziusLower, TrapeziusMiddle, TrapeziusUpper;
#           RectusFemoris, VastusIntermedius, VastusLateralis, VastusMedialis
#   dim:    BicepsBrachii_LongHead, BicepsBrachii_ShortHead; BicepsFemoris,
#           Semimembranosus, Semitendinosus; ErectorSpinae; LatissimusDorsi
# THE VIEW, AND WHY IT MATTERS TO THE PAINT. The camera-depth axis in world is
# (0.97572, 0, 0.21901), i.e. 12.65 deg off the lifter's LEFT toward their
# front, and screen u runs along (0.21901, 0, -0.97572), so +z - the way the
# lifter faces - maps to LOW u: the lifter sits side-on facing SCREEN-LEFT,
# head swinging to screen-right as they lay back. A depth-buffer render of all
# 125 skinned meshes gives the left-side meshes 12,043-13,518 of the lifter's
# 21,000-22,500 pixels against 1,664-2,120 for the right, a 6-8 : 1 split. IT
# IS A LEFT-SIDE VIEW WITH A SLIVER OF THE FRONT, NOT A BACK VIEW, which
# matters on a lift whose paint is almost all back muscle. No cue below names a
# near or a far side and no cue claims a muscle faces the camera.
# FIVE OF THE SIXTEEN BRIGHT NAMES NEVER PUT A PIXEL ON SCREEN. Measured at
# the four distinct still frames, GluteusMedius, GluteusMinimus,
# RhomboidMajor, Subscapularis and Supraspinatus are at 0 px on both sides at
# all four. Visible pixel sums over f0/f24/f48/f72: VastusLateralis 6175,
# LatissimusDorsi 3868 (DIM), BicepsFemoris 3638 (DIM), DeltoidPosterior 2056,
# RectusFemoris 1727, VastusMedialis 1100, BicepsBrachii_LongHead 873 (DIM),
# TrapeziusUpper 702, VastusIntermedius 201, TrapeziusLower 159,
# Infraspinatus 143, TrapeziusMiddle 139, Semitendinosus 122,
# BicepsBrachii_ShortHead 107, TeresMinor 98, Semimembranosus 57,
# ErectorSpinae 46, GluteusMaximus 26, and zero for the five above. So the
# GLUTES, painted bright, show 26 px in 87,182 - 0.0298% - and the shorts over
# them measure R minus max(G, B) of +0.8 at f0 and +0.6 at f24, dead neutral
# grey against +74 to +97 for a bright muscle. Open point 1. THE OWNER'S
# STANDING GLUTE DECISION HOLDS AND IS REINFORCED: one unsplit Gluteus Maximus
# row, the copy says glutes, and NO entry names the gluteus medius anywhere,
# in a row or a stabiliser - here it is not merely a convention but a muscle
# the reader literally cannot see.
# part_of() TRAPS verified against common_1_50.py:43-64. A row must read
# Posterior Deltoid, because part_of of Deltoid Posterior gives sideDelts.
# Trapezius, Rhomboids, Mid-Back and Upper Back ALL collapse to upperBack, so
# two of them in one spec buy one row's worth of information - this entry
# spends two of them deliberately, on the row stage's settled table. Teres
# Minor, Infraspinatus, Supraspinatus, Subscapularis and Rotator Cuff all land
# on rearDelts alongside Posterior Deltoid. Erector Spinae beats the later
# back keyword and lands on lowerBack. Gluteus Maximus is the only glute name
# allowed. A single forearm muscle returns None and the row is DROPPED, so
# forearm work rides in the stabilisers - and on this lift the paint lights no
# forearm mesh at all, so a Forearms row is forbidden by the paint rule even
# though every member of the cable-row family carries one.
# THE LEGEND TRUNCATES, AND THIS LIFT IS THE FAMILY'S ONLY BUDGET-SENSITIVE
# ONE. Exercise3DView.swift:507-545 uppercases each rank's names and joins
# them with a space, a middle dot and a space, and both lines are lineLimit(1)
# - about 40 characters at 375 pt and 43 at 393 pt, with the SECONDARY line
# about 2 characters tighter because SECONDARY is the longer rank word, so 38
# and 41. The primary line is 87 characters: POSTERIOR DELTOID ends at 17,
# TRAPEZIUS at 29, RHOMBOIDS at 41, QUADRICEPS at 54, ROTATOR CUFF at 69 and
# GLUTEUS MAXIMUS at 87. So the reader sees 2 of 6 names at 40 and 3 of 6 at
# 43 - RHOMBOIDS ends at exactly 41, whole at 43 and cut at 40. The secondary
# line is 63: LATISSIMUS DORSI 16, ERECTOR SPINAE 33, BICEPS BRACHII 50,
# HAMSTRINGS 63, so 2 of 4 at every width. A truncated legend costs the reader
# the NAME on the 3D screen and not the data - Sheets.swift:95 is a plain
# ForEach with no cap, so all ten rows draw their bar in Muscles Worked - and
# every name here resolves through part_of(), so none is silently dropped the
# way Hip Flexors and Serratus Anterior are. Reordering within the two 0.63
# and the one 0.48 tie gains nothing: the cut falls at name 2 or 3, before any
# tie begins. Open point 6.
#
# SOURCES BEHIND EVERY COACHING CLAIM IN THIS ENTRY.
#  - THE DRIVE ORDER AND THE HANDLE-AND-SEAT RULE ARE COACHING, NAMED AS
#    COACHING. Hart A, Rowing Technique: Passing the Human Polygraph, CrossFit
#    Journal Issue 50, October 2006, retrieved as a primary PDF: the legs
#    initiate the power with the arms straight, then the torso, then the arms
#    finish; the handle and the seat must move together on the drive and a
#    handle that moves first is pulling with the back early; on the recovery
#    the handle leads, the arms extend first, then forward flexion at the hips,
#    before the knees begin to rise. NO STUDY TESTS THE DRIVE SEQUENCE against
#    injury or performance - Soper and Hume 2004 (PMID 15462614) concludes
#    that biomechanical predictors of 2000 m performance are indistinct and
#    that research on ideal technique is limited, and twenty-two years on
#    nothing overturns it. Concept2 and British Rowing teach the same order
#    (British Rowing adds no movement in the back or shoulders until the legs
#    are nearly straight), but Concept2's own tips page returns HTTP 403 to a
#    fetch so only Hart is quoted. THE TERM SHOOTING THE SLIDE IS DELIBERATELY
#    ABSENT: it is jargon, the ungated screen has no room to define it, and
#    labels are capped at 28 characters.
#    British Rowing's 60 / 30 / 10 legs-body-arms POWER SPLIT, the single most
#    quotable number in rowing coaching, IS NOT USED ANYWHERE: no study in the
#    searched literature measured it, and Duchene 2025 (PMID 38205960), the
#    nearest measured relative, reports stroke-rate effects on handle, leg,
#    trunk and arm power in 24 rowers and not a split.
#  - THE LOW BACK IS THE BEST-EVIDENCED THING ON THIS LIFT AND IT IS WHERE THE
#    SAFETY WEIGHT GOES. Trease 2020 (PMID 32586943, 153 Australian
#    international rowers, 48,611 athlete days, 270 injuries): the most
#    frequently injured area was the LUMBAR REGION, 84 cases, 1.7% of athlete
#    days. Wilson 2014 (PMID 25257230, narrative review): 12-month low back
#    pain incidence 31.8% to 51% of the cohort, and greater pelvic rotation at
#    either end of the stroke is ideal as opposed to lumbar flexion and
#    extension, which tends to be poorly demonstrated in NOVICE ROWERS ON
#    ERGOMETERS. Nugent 2021 (PMID 33397675, 22 studies, 429 participants):
#    rowers WITHOUT pain hold neutral or anterior pelvic rotation at the catch
#    and a flatter low back at the finish; rowers WITH pain show greater
#    POSTERIOR pelvic rotation at the catch; and in both groups fatigue
#    increases lumbar flexion at the catch, more on the erg than in a boat.
#    Ng 2015 (PMID 26252195, 10 adolescent male rowers with pain against 10
#    without, 15-minute erg trial): no difference in MEAN lumbar angle, but
#    the painful group had less excursion into extension over the drive,
#    greater variability, sat closer to END-RANGE FLEXION for a greater
#    proportion of the drive and showed increased time in sustained flexion
#    loading. Yamashita 2023 (PMID 37293422, 10 with pain against 12 without,
#    500 m maximal erg, EMG normalised to MVIC and binned per 10% of the
#    cycle): lumbar erector spinae HIGHER in the pain group at 0-10% of the
#    stroke, p < 0.001 - the catch - and thoracic erector spinae higher at
#    10-20% and 20-30%; the abstract reports significances and not the %MVIC
#    values, so none is quoted. Wilson 2013 (PMID 23898686, 19 elite men):
#    maximum lumbar flexion increased over a step test by 4.4 +/- 0.9 deg on
#    the ergometer against 1.3 +/- 1.1 in the boat, a 3.1 deg difference,
#    p = 0.035. Ze 2025 (PMID 40605029, 10 studies, N = 2,082, meta-analysis):
#    the ONLY significant risk factor was previous low back pain, OR 2.65
#    (1.86-3.78), and training volume at 1.26 (0.83-1.91) did NOT reach
#    significance - so this entry makes no claim about erg volume, which
#    weakens Wilson 2014's volume claim. Callaghan and McGill 2001 (PMID
#    11114441), the mechanism behind every repeated-rounding-under-load
#    sentence in the fitness world, is PORCINE CERVICAL spine in vitro at up
#    to 86,400 cycles, so it is not cited in any public string and is not
#    cited here as a dose.
#    WHAT THE MODEL DOES WITH ALL THAT: the rig HAS NO LUMBAR SPINE. The only
#    lumbar proxy, the pelvis-spine-chest joint-chain angle, takes 33 distinct
#    values over the clip - exactly as many as the trunk channel - and sits at
#    170.0789 deg on 92 of 192 frames and 173.6789 on 38, which are precisely
#    the frame counts of the trunk channel's two pinned windows. The chain is a
#    deterministic function of the trunk angle: THERE IS NO INDEPENDENT LUMBAR
#    ARTICULATION IN THIS RIG AT ALL, and its whole catch-to-finish excursion
#    is 3.6000 deg - smaller than the 4.4 deg of fatigue creep Wilson measured
#    ON TOP of whatever flexion was already there. The thoracic chain moves
#    8.4000 deg. The catch IS the model's most flexed instant, so the
#    DIRECTION is right and the magnitude is nowhere. Consequently the badge
#    is NOT ROUNDED LOWER BACK (7 shipped uses, and the literature's own
#    fault), because that would badge something the animation never shows;
#    the lumbar instruction lives in the swing cue's correct string and in a
#    setup step, where the reader can reach it. Open point 3.
#  - THE ONLY %MVIC STUDY OF ROWING-MACHINE ROWING CONTRADICTS THE PAINT IN
#    DIRECTION, AND NO ROW BELOW IS SET FROM IT. Sha and Chiu 2026 (Sensors
#    26(14):4546, PMID 42515428), n = 12 university students with at least a
#    year of erg experience, Apollo V WATER-resistance ergometer, four
#    resistance levels, stroke rate fixed at 40 per minute by metronome,
#    strokes 4-8 of 11 analysed, DRIVE PHASE ONLY, six muscles, normalised to
#    MVIC: biceps brachii 24.34-39.37%, latissimus dorsi 20.29-24.93%,
#    tibialis anterior 15.84-19.74%, rectus femoris 10.46-13.50%, deltoid
#    9.72-14.20%, triceps brachii 8.23-12.73%. Only the biceps changed with
#    resistance (F = 3.326, p = 0.020). ON THE APP'S OWN SCALE EVERY CELL IS
#    LOW: the single highest, biceps at MAX, is 0.3937, which is 0.0063 below
#    the MODERATE threshold - a row set that followed this study would have no
#    HIGH and no MODERATE row at all and would put biceps and lats at the top,
#    where this lift's paint puts them DIM. Against that: water erg not air,
#    fixed stroke rate with no power target (the authors concede the
#    upper-body dominance may be an artefact of it), drive phase only, five
#    strokes, n = 12, SEX NOT REPORTED, SDs up to a CV of 55% with rectus
#    femoris' SD larger than its mean, and it did not measure erector spinae,
#    hamstrings, calves, glutes, trapezius, rhomboids or any rotator-cuff
#    muscle - nine of the sixteen bright meshes. Vieira 2020 (PMID 32192073,
#    20 elite rowers) partly mediates: all eight sampled lower-limb muscles
#    were recruited, RECTUS FEMORIS ACTIVE THE LONGEST and biceps femoris the
#    briefest, and TIBIALIS ANTERIOR WAS THE ONLY MUSCLE RECRUITED IN THE
#    RECOVERY - which is the one stabiliser on this lift with a measurement
#    behind it. SO: a cue may teach legs-then-body-then-arms as the coaching
#    convention, and the drive cue's why says so in those words; NO cue claims
#    the legs are the highest-activation muscles, because the one study that
#    measured that found the opposite. Open point 2.
#  - CATCH AND FINISH ANGLES ARE NOT QUOTED AS STANDARDS. No authoritative set
#    of degrees emerged: the studies reporting them have 5-17 rowers and
#    disagree on which angles matter. Hart teaches roughly 30 deg of forward
#    body angle at the catch and a 30 deg layback; the model gives +15.3313
#    and -20.1677, which is 14.67 deg short at the catch and 9.83 deg short at
#    the finish, 35.499 deg of swing against a taught 60. NO CUE BELOW QUOTES
#    EITHER TAUGHT FIGURE, and none quotes the model's own either, because a
#    reader cannot measure their own trunk angle.
#  - THE OTHER FAULTS AND WHY THEY ARE NOT THE BADGE. EXCESSIVE BACK LEAN has
#    4 shipped uses, ALL FOUR seated cable rows (:5889, :20844, :20958,
#    :21190) - the erg's closest shipped relatives - but the model's layback is
#    20.1677 deg, 9.83 LESS than the taught 30, so the animation never shows
#    the fault. LEANING BACK has 16 uses and is the joint-commonest badge in
#    the library. SHRUGGING THE PULL (1 use, :6212 Chest-Supported Row
#    Machine) fits the finish, and the model shows the CORRECTION rather than
#    the fault: shouldergap goes 0.409358 at f94 to 0.377253 at f28, 3.21 cm
#    of scapular retraction. Knee flare at the catch is the one fault Hart
#    ties to injury in words, but anklegap's whole-clip range is 0.001084 m
#    and handgap's 0.000017 m - the stance never changes - so it is not
#    badged either. The fault the badge names is the one the model's own
#    sequence is about.
#
# OPEN POINTS THIS ENTRY HANDS THE OWNER - recorded, not decided, and no cue
# or row above assumes an answer to any of them.
#  1. THE SHORTS SHOW NO GLUTE TINT, ON A LIFT THAT PAINTS ALL THREE GLUTES
#     BRIGHT. ShortsGluteZone.swift (2026-10-28) says the shorts take the
#     glutes' own paint so a glute lift is not lost under the fabric; measured
#     over exactly the pixels the depth buffer assigns to
#     Anatomy_Shorts_Surface, the stills read R minus max(G, B) of +0.8 at f0
#     and +0.6 at f24 - neutral grey against +74 to +97 for a bright muscle
#     and +31 to +39 for a dim one. Either the stills (captured 2026-10-30)
#     come from a path that does not run ShortsGluteZone.texture, or the
#     feature is not firing for this model. COST OF LEAVING IT: a
#     bright-painted group shows 26 px in 87,182 and any glute cue points at
#     black cloth, which is why no cue here names the glutes and the Gluteus
#     Maximus row sits last of the six primaries at 0.48. COST OF CHASING IT:
#     a look at the capture path before this round's copy ships. Nothing was
#     touched to find out.
#  2. THE LATS AND THE BICEPS ARE DIM AND THE MEASURED EVIDENCE PUTS THEM
#     FIRST. The paint makes LatissimusDorsi and both BicepsBrachii heads
#     secondary and the traps / rhomboids / rear-delt group primary, which is
#     right for a horizontal pull with scapular retraction - but the only
#     %MVIC study of this exact machine ranks biceps first (24.34-39.37%) and
#     lats second (20.29-24.93%), and ON SCREEN the dim lat shows 1,277 px at
#     the catch against 1,228 px for all six visible bright back muscles put
#     together (49 + 63 + 112 + 147 + 216 + 641 = 1,228; 1,277 - 1,228 = 49).
#     OPTION A, taken here: leave the paint, write the copy around the
#     mid-back and the sequence, and let the reader's eye and the legend
#     disagree by one muscle. OPTION B: promote the lat to bright; the cost is
#     that the lift's story stops being rows with the back rather than the
#     arms, and the row table would have to be rebuilt. Measured costs above;
#     the choice is the owner's convention.
#  3. THE BADGE SPELLING IS ALREADY SPLIT IN THE LIBRARY AND THIS ENTRY PICKS
#     ONE. ARMS PULL EARLY has exactly 1 use (:45641 cleanAndPressContent, cue
#     Elbows bend before the hips open) and ARMS PULLING EARLY exactly 1
#     (:48845 barbellPowerCleanContent, cue Arms bend before the hips open).
#     This entry takes ARMS PULL EARLY, for a traceable reason and not a
#     coin-toss: two of its own fractions are carried from cleanAndPressContent
#     (Quadriceps 0.62 at :45624 and Erector Spinae 0.55 at :45629), so it
#     follows that block's spelling. If the owner would rather collapse the
#     pair, this is the third use and the moment to do it.
#  4. THE CATCH IS 27.1007 DEG SHORT OF A VERTICAL SHIN AND THE SEAT TRAVELS
#     ONLY 30.22 cm, so the model does not show a full-compression catch.
#     OPTION A, taken here: describe what the model does and keep the shin out
#     of the copy entirely - the setup cue and step 3 name the knee bend, the
#     straight arms and the shoulders in front of the hips instead. OPTION B:
#     write the standard shins-vertical cue anyway and accept that the picture
#     contradicts it in all 192 frames. The jump family's precedent (the rope
#     that never reaches the floor, the heel that lands 0.167 s late) points at
#     Option A, but the owner set that precedent, not this entry.
#  5. THE LIBRARY CARD ALREADY SAYS equipment ROWER (SampleData.swift:676) and
#     common_1_50.validate_library accepts only BARBELL, DUMBBELL, EZ BAR,
#     CABLE and MACHINE. THIS ENTRY CARRIES NO library TUPLE, which leaves
#     ROWER alone; adding one would force MACHINE and change the card the
#     reader sees. primaryMuscle MID-BACK is already in the allowed MUSCLES
#     set and difficulty .beginner is valid, so the card needs nothing else.
#  6. SIX PRIMARY ROWS MEAN THE READER SEES TWO OR THREE OF THEM. The primary
#     legend line is 87 characters against a 40-43 budget and RHOMBOIDS ends
#     at exactly 41 - whole at 393 pt, cut at 375. Three honest options:
#     leave it (the Muscles Worked sheet shows all ten rows, so what is lost
#     is the name on the 3D screen); fold Rhomboids into Trapezius, which
#     part_of files under the same upperBack part anyway, buying 12 characters
#     and bringing QUADRICEPS inside the budget at the cost of one visible
#     name; or reorder against the fraction convention. The row stage settled
#     the table and this entry does not change it.
#  7. THE CLEAN LEADER ANCHORS TEND TO POINT AT THE HIDDEN SIDE. Of the four
#     joints whose leader clears both the head and the machine from row 0.32
#     leading at 13 characters - the same four under the nearest-vertex test
#     and under the convex-hull test - three are on the right: scapula_R
#     (head 2.0 px, machine 18.40 px), upper_arm_R (9.9 / 22.17) and
#     clavicle_R (6.4 / 28.47). The right side of this body is where none of the
#     paint renders (1,664-2,120 px against 12,043-13,518). This entry takes
#     the fourth, clavicle_L (5.7 / 29.18), which is on the LIT near side; the
#     cost is that its head margin is 5.7 px rather than scapula_R's 2.0 px
#     measured the other way, and that the label there is capped at 13
#     characters (at 14 clavicle_L falls to 3.5 px and at 15 to 1.3 px, and at
#     16 it is ON the face). scapula_L, the anatomically ideal anchor for a
#     blades cue, is ON the face from row 0.32 leading on 44 of 192 frames and
#     from row 0.16 leading on 118, so it is not available at all.
#  8. TWO OF THE FIVE LEADERS CROSS THE DRAWN MONORAIL, AND IT IS FORCED
#     GEOMETRY RATHER THAN A CHOICE. See the LABEL GEOMETRY block: the rail is
#     drawn as a continuous bar at v 0.657..0.698 across the whole frame
#     width, row 0.80's band is v 0.775..0.825 below it, and every one of the
#     26 joints is above it - so tested against the convex hulls, ALL 26
#     joints cross the rail from both row-0.80 slots on all 192 frames. Since
#     rows 0.48 and 0.64 are unusable and rows 0.16 and 0.32 hold only three
#     pills between them, five annotations cannot avoid putting two pills
#     below the rail. The round's hard pill rule is about the LIFTER and the
#     HEAD and this layout is 0/192 on both for all five pills; the rail and
#     seat crossings are a declared cost, and the only way to remove them is
#     to ship fewer than five annotations, which validate() forbids.
#  9. NOTHING ON THE UNGATED SURFACE SAYS THIS LIFT IS TIMED, OR HOW TO PACE IT.
#     The app logs Rowing Machine in seconds (ExerciseCatalog.swift:137) and the
#     other four timed lifts of this family each give the reader a pacing rule -
#     Sled Push step 4 and its tempo cue, Sled Drag step 4, Battle Rope
#     Alternating Waves step 5 and its tempo cue, Battle Rope Slams step 4. This
#     entry says nothing about pace, time or fatigue in five setup steps or five
#     correct strings, and it is the ONE lift of the seven where technique loss
#     under fatigue is MEASURED rather than coached - Wilson 2013 has maximum
#     lumbar flexion rising 4.4 +/- 0.9 deg over an erg step test against
#     1.3 +/- 1.1 in a boat, p = 0.035, with Willwacher 2021 and Wilson 2014
#     alongside - all of it cited in swing.why, which is gated.
#     OPTION A (taken, and the drafter's stated position in recovery.why): stay
#     silent. No rate, no ratio and no cadence anywhere a reader can see.
#     OPTION B: put the drive-to-recovery SHAPE on the end of recovery.correct.
#     It is a proportion rather than a cadence and is the universally taught
#     shape of the stroke, independent of stroke rate. Measured by the seat: one
#     stroke is 96 frames, 4.0000 s, 15.000 strokes a minute; catch f0 to finish
#     f31 is 31 INTERVALS, 1.2917 s; finish back to the next catch is 65
#     INTERVALS, 2.7083 s; the ratio is 1 : 2.10. The clause costs 19 characters
#     on an already 187-character string - and take longer coming forward than
#     you took on the drive - for 206 in all. Cost: this would be the family's
#     first stroke proportion on the ungated surface.
#     OPTION C: the house phrase for the set time inside an existing step. No
#     room - the entry is already at the five-step maximum, four of the five run
#     116 to 130 characters, and validate() rejects a sixth.
ex(name="Rowing Machine", var="rowingMachine",
   # LABEL GEOMETRY. Five pills, five slots, and this lift has EXACTLY FIVE
   # usable slots of the ten, so there is no slack anywhere. Measured at the
   # pill the app DRAWS - half-height 0.025 in v, width (24 + 5.6 *
   # len(label)) / 382, pinned EDGE 0.035 from the leading (left) or trailing
   # (right) frame edge - against the 655-row SKINNED silhouette
   # (RowingMachine_SIL.npz, never mesh points: the rig is skinned and
   # GetPointsAttr().Get(t) returns the rest pose at every time code), and
   # with every leader tested twice: against the HEAD'S OWN silhouette
   # (RowingMachine_HEAD.npz, rows 198..265, v 0.3031..0.4053) and against the
   # CONVEX HULL of every equipment mesh's projected vertices, which is what
   # catches the drawn monorail that a nearest-vertex test misses. All figures
   # are over ALL 192 FRAMES. The rows named here are the DRAWN rows;
   # overrides below carries the RAW 0.14 / 0.32 / 0.50 / 0.68 / 0.86 values,
   # which spec_1029.py renders at 0.16 / 0.32 / 0.48 / 0.64 / 0.80.
   #
   # THE FRAME. The skinned lifter occupies rows 198..451 of 655, v 0.3031..
   # 0.6893, u 0.0567..0.9085, and never leaves the frame. That leaves exactly
   # two bands empty of the body: row 0.16 (v 0.135..0.185, rows 88.4..121.2),
   # which clears the lifter's topmost row by 76.8 px, and row 0.80
   # (v 0.775..0.825, rows 507.6..540.4), which clears the lowest by 56.6 px.
   # Inside row 0.32's band the lifter is present on 192 of 192 frames at
   # u 0.4135..0.8994 - that is the HEAD, and it is what caps the leading pill
   # there. Inside row 0.48's band the lifter spans u 0.0567..0.9085 (the
   # reaching arm) and inside row 0.64's u 0.1235..0.7879 (thigh and shin).
   # room.py "Rowing Machine" 13,15,18,19 (and 8,10,12,14,16,20,21,22 for the
   # ceilings), cells read lifter clearance px / overlapping frames / load
   # clearance px / frames the load is inside the pill:
   #   0.16 leading   CLEAN AT ANY LENGTH to the 28-character limit - the
   #                  lifter never enters the band and the nearest load point
   #                  is a constant 181.7 px away, 0 frames inside. The best
   #                  room on the lift.
   #   0.16 trailing  CLEAN AT ANY LENGTH, load 174.0 px, 0 frames inside.
   #   0.32 leading   clean to 21 characters: +47.8 px at 13, +36.6 at 15,
   #                  +19.8 at 18, +14.2 at 19, +3.0 at 21, and -2.6 px on 12
   #                  frames at 22. The cap is the head - at 21 characters the
   #                  pill's right edge is u 0.405681 and the head's left edge
   #                  in that band is u 0.4135, a gap of 2.99 px. Load a
   #                  constant 76.9 px, 0 frames inside.
   #   0.80 leading   clean of the LIFTER at any length (56.6 px below it),
   #                  but the nearest load point is only 4.1 px: HG_RailFoot
   #                  at u 0.088..0.217, v 0.713..0.769, whose top edge sits
   #                  3.9-4.1 px above the band. 0 frames inside the pill.
   #   0.80 trailing  clean of the LIFTER at any length, load 13.8 px, 0
   #                  frames inside.
   # and the other five are dead: 0.32 trailing is on the lifter from 8
   # characters (-43.7 px, 68 frames) and is -68.4 px on 82 frames by 13; 0.48
   # leading is -88.5 px on 106 frames at 13 with the handle or chain INSIDE
   # the pill on 106 frames; 0.48 trailing -75.2 px on 128; 0.64 leading
   # -63.0 px with ALL 192 frames overlapping and the machine inside the pill
   # on all 192 even at 8 characters; 0.64 trailing is nearly clean only at 8
   # characters (-1.2 px, 60 frames) and gone by 10 (-12.4 px, 126 frames).
   # Rows 0.48 and 0.64 are the arm-and-handle row and the rail row, and
   # nothing fits in either. FIVE SLOTS, FIVE ANNOTATIONS, NO SPARE.
   #
   # Pill by pill, in cue order. Columns: drawn row and side, label length,
   # lifter clearance and overlap frames, load clearance and frames inside,
   # the leader against the head's own silhouette, and the leader against the
   # convex hulls of the drawn machine.
   #   setup    `Chest forward`       13  row 0.32 leading
   #     lifter +47.8 px / 0 frames, load 76.9 px / 0 frames inside, leader to
   #     clavicle_L 0/192 ON THE FACE with a closest approach of 5.7 px at
   #     t = 0.00, leader 0/192 over any drawn machine part. THIRTEEN
   #     CHARACTERS IS THE BUDGET HERE and the cap is the leader, not the
   #     pill: the pill itself is clean to 21 characters, but clavicle_L's
   #     head margin falls 5.7 px at 13 characters to 3.5 at 14 and 1.3 at
   #     15, and goes negative at 16, where the leader is on the face on 12
   #     of 192 frames at -0.9 px, rising to 24 frames at 17 and 30 at 18.
   #     Open point 7.
   #   drive    `Arms straight`       13  row 0.16 leading
   #     lifter never enters the band / 0 frames, load 181.7 px / 0 frames
   #     inside, leader to forearm_L 0/192 on the face, closest 32.7 px at
   #     t = 7.46, leader 0/192 over the drawn machine with a closest approach
   #     of 11.16 px at f32. forearm_L is the ONLY one of the 26 joints clear
   #     of both the head and the machine from this slot - from the top-left
   #     gutter every torso and shoulder anchor is on the face (head 192/192,
   #     neck 120, scapula_L 118, upper_arm_L 120, scapula_R 102, chest 64)
   #     and every leg anchor crosses the rail - so this slot chose its own
   #     anchor, and the cue placed here is the one whose instruction IS the
   #     elbow.
   #   swing    `Swing from the hips` 19  row 0.80 trailing
   #     lifter never enters the band / 0 frames, load 13.8 px / 0 frames
   #     inside, leader to pelvis 0/192 on the face - it never spans the
   #     head's rows at all - and the leader crosses HG_Rail, HG_SeatCarriage
   #     and HG_SeatCushion on 192/192 frames. Length is FREE in this slot:
   #     nothing about the pill or the leader changes with it, because the
   #     rail crossing is forced for every joint at every length (open point
   #     8), so the label is as long as it needs to be to say the thing. The
   #     seat crossing is the one crossing in this layout that reads as
   #     intended rather than tolerated - the dot sits on the hip joint just
   #     above the cushion the hip is sitting on.
   #   finish   `Handle to the ribs`  18  row 0.16 trailing
   #     lifter never enters the band / 0 frames, load 174.0 px / 0 frames
   #     inside, leader to hand_L 0/192 on the face, closest 25.3 px at
   #     t = 0.00, leader 0/192 over the drawn machine, closest 6.53 px at
   #     f32. hand_L and hand_R are the ONLY joints whose leader clears the
   #     head from the top-right gutter (the pill pins at u 0.6383 and the
   #     head sits at u 0.4135..0.8994 in its own band, so everything else
   #     drops straight through it), and of the two only hand_L also clears
   #     the machine - hand_R crosses a drawn part on 28 of 192 frames and
   #     comes within 4 px of a machine vertex on 42.
   #     This slot also chose its own anchor, and it chose well: the hand
   #     arrives at u 0.741 at the finish, directly beneath the pill, and
   #     travels out to u 0.159 at the catch.
   #   recovery `Knees bend last`     15  row 0.80 leading
   #     lifter never enters the band / 0 frames, load 4.1 px / 0 frames
   #     inside, leader to patella_L 0/192 on the face - it never spans the
   #     head's rows - and the leader crosses HG_Rail on 192/192 frames and
   #     nothing else. At 15 characters the nearest VERTEX of the machine is
   #     11.52 px from this leader, against 5.33 px at 13 and a graze at 10,
   #     which is why the label is 15 and not the library's 10-character
   #     `Legs first` - but see open point 8: the vertex figure is cosmetic,
   #     because the drawn rail is crossed either way.
   # THE TWO FIGURES THAT DECIDE THE WHOLE LAYOUT: all five pills are 0/192
   # for lifter overlap and all five leaders are 0/192 on the head, so this
   # layout MEETS the round's hard pill rule with no breach and no exception
   # claimed. The declared cost is the two rail crossings in open point 8.
   # Reproduce any figure with, in the cond data folder,
   #   room.py "Rowing Machine" 13,15,18,19
   #   lead.py "Rowing Machine" clavicle_L 0.32 leading 13
   #   lead.py "Rowing Machine" forearm_L  0.16 leading 13
   #   lead.py "Rowing Machine" pelvis     0.80 trailing 19
   #   lead.py "Rowing Machine" hand_L     0.16 trailing 18
   #   lead.py "Rowing Machine" patella_L  0.80 leading 15
   # and the hull test with d_RowingMachine/v5.py, which takes the same five
   # pills as cue|row|side|len|joint arguments.
   #
   # LABEL STRINGS. Two are the library's own for the same cue. `Arms
   # straight` (13, x8) is the shrugs' label - six of the eight are shrugs,
   # where the point is that the arms stay straight while something else
   # works, which is exactly this lift's leg drive - and it is true here to
   # 0.34 of a degree (see the drive cue's why). `Legs first` (10, x4,
   # Dumbbell Thruster, Kettlebell Thruster, Split Jerk and Push Jerk, all on
   # cueID drive) WAS the natural label for the drive cue and is NOT used,
   # because the drive slot's forced anchor is the elbow and `Legs first`
   # pointing at an elbow would be a leader to the wrong thing; the drive
   # order it carries is in that cue's correct string and in setup step 4
   # instead. THREE ARE NEW, and each because the library has nothing for it:
   # `Chest forward` (13) - the library's 11 `Chest up` labels are all squats
   # and presses and would be FALSE here, the model's trunk being 15.3313 deg
   # FORWARD at the catch with the shoulders 19.10 cm in front of the hips;
   # `Swing from the hips` (19) - the library has no body-swing label at all
   # and its nearest string is the FAULT text on the four seated cable rows
   # (Leaning back to swing); `Handle to the ribs` (18) - the library's
   # `Elbows to the ribs` (18, x16) is the same length and equally legal, but
   # the anchor this slot forces is the WRIST, so the label names what the
   # wrist is holding. All five are inside the 28-character cap.
   overrides={"setup": (0.32, "leading"), "drive": (0.14, "leading"),
              "swing": (0.86, "trailing"), "finish": (0.14, "trailing"),
              "recovery": (0.86, "leading")},
   annotations=[
       ("setup", "Chest forward", "clavicle_L"),
       ("drive", "Arms straight", "forearm_L"),
       ("swing", "Swing from the hips", "pelvis"),
       ("finish", "Handle to the ribs", "hand_L"),
       ("recovery", "Knees bend last", "patella_L"),
   ],
   cues={
       "setup": ("Start Position",
                 "You sit strapped to the footplate at the front of the slide, knees bent, arms reaching straight out to the handle and your shoulders a little in front of your hips.",
                 "The catch is f0 and f96, and it is the quietest instant in the clip rather than a hold: the step from f95 to f96 is 0.5766 mm, the slowest of all 191 intervals, and no interval anywhere in the clip falls under 0.001 mm. Measured at f0 the knee is 76.699 degrees - 103.301 degrees of bend - the hip 53.599, the elbow 175.082, the trunk 15.3313 degrees forward, the derived ankle 107.182 and dorsiflexed, the seat at its forward end with pelvis z -0.060436, the hands at their furthest out with a midpoint z of +0.646861, and the scapulae at their widest with shouldergap 0.409358. The shoulders are 19.10 cm in front of the hips at that frame (clavicle_L z 0.1306 against pelvis z -0.0604), which is the part of the pose a reader can actually check on themselves. The grip is NARROWER than the shoulders and never changes: handgap is 0.245723 m on every one of the 192 frames, range 0.0000 m, on a 40.00 cm bar, which is 60.0 per cent of the shouldergap at the catch and 65.1 per cent at the finish. WHAT THIS POSE IS NOT is a full-compression catch, and that is why nothing in this entry mentions the shin: the knee joint sits 0.1797 m BEHIND the ankle in z (shin_L z 0.2749 against foot_L z 0.4546), so the shin leans 27.1007 degrees BACK from vertical in the sagittal plane and 27.1158 on the right, and the seat travels only 30.2194 cm in total. Hart 2006 teaches a vertical shin and roughly thirty degrees of forward body angle; the model gives 15.3313, which is 14.67 degrees short, so neither figure is quoted anywhere a reader can see. No catch angle is quoted as a standard at all: the studies that report them have five to seventeen rowers and disagree about which angles matter, and Soper and Hume 2004 concludes that research on ideal rowing technique is limited.",
                 "Sitting at the front of the slide with the lower back rounded under and the shoulders already behind the hips.",
                 "Strap both feet to the footplate and take the handle overhand with your hands a little inside the ends of the bar, then slide forward to the front of the slide with your back flat."),
       "drive": ("Leg Drive",
                 "The legs go first. You push the footplate away with the arms still straight, and the handle and the seat leave together.",
                 "This is the one claim on this lift that the picture supports frame by frame. Measured by the knee the drive is f0 to f16 - 17 frames, 16 intervals, 0.6667 s - over which knee_L goes 76.6989 to 175.9928 degrees, 99.29 degrees of extension. Measured by the seat it is f0 to f15, 16 frames and 15 intervals, 0.6250 s, the pelvis travelling z -0.060436 to -0.362613, which is 30.2194 cm. THE ELBOW DOES NOT MOVE WHILE THAT HAPPENS: elbow_L is 175.0821 at f0, 174.8320 at f16 and 174.7482 at f18, so it stays inside 0.34 of a degree of its catch value across the whole leg drive, and only then folds 120.1099 degrees to 54.6383 by f30. The first frame it has given up a full degree is f19 at 173.4161, and f20 is already 165.0822. AND THE HANDLE AND THE SEAT BOTH START ON THE VERY FIRST INTERVAL: from f0 to f1 the pelvis moves 3.848 mm and the hand midpoint 5.060 mm, which is the model's own version of Hart's rule that the handle and the seat must move together on the drive and that a handle moving first means pulling with the back early. The order itself is coaching and is named as coaching: Hart 2006 in CrossFit Journal 50 teaches legs, then torso, then arms, Concept2 and British Rowing teach the same, and NO study tests the drive sequence against injury or performance - Soper and Hume 2004 says the biomechanical predictors of rowing performance are indistinct in the literature. What may NOT be said is that the legs are the hardest-working muscles here: the only MVIC-normalised study of rowing-machine rowing, Sha and Chiu 2026 with twelve subjects on a water ergometer, puts rectus femoris fifth of six muscles at 10.46 to 13.50 per cent of MVIC and biceps brachii first at 24.34 to 39.37. Vieira 2020 is the honest form of the leg claim: in twenty elite rowers all eight sampled lower-limb muscles were recruited and rectus femoris was active the LONGEST of them, so the legs are working even where their amplitude is modest.",
                 "Bending the elbows or opening the back while the knees are still bent, so the handle moves before the seat does.",
                 "Push the footplate away with your legs while your arms stay straight and your body angle holds through the first half of the push, so the handle and the seat start moving together."),
       "swing": ("Body Swing",
                 "Once the legs are driving hard, your trunk swings open from the hips and carries the handle on.",
                 "The swing is f8 to f24 - 17 frames, 16 intervals, 0.6667 s - and the trunk goes 15.3313 degrees forward to 20.1677 degrees back, a range of 35.4990 degrees, while the hip opens 53.5990 to 122.5228, which is 68.9239 degrees. It overlaps the leg drive at f8 to f16 and the arm pull at f18 to f24, and that overlap IS the sequence. IT IS A HIP SWING AND NOT A BACK SWING, and the rig proves it the hard way: the only lumbar proxy in this skeleton, the pelvis-spine-chest joint-chain angle, takes 33 distinct values over the whole clip - exactly as many as the trunk channel - and sits at 170.0789 degrees on 92 of the 192 frames and 173.6789 on 38, which are precisely the frame counts of the trunk channel's own two pinned windows. The chain is a deterministic function of the trunk angle, so there is no independent lumbar articulation in this rig at all, and its entire catch-to-finish excursion is 3.6000 degrees. The thoracic chain moves 8.4000. This is also the best-evidenced safety point in the whole conditioning family. Trease 2020, following 153 Australian international rowers over 48,611 athlete days, found the lumbar region the most frequently injured area with 84 of 270 injuries. Nugent 2021, pooling 22 studies and 429 participants, found that rowers WITHOUT low back pain hold neutral or anterior pelvic rotation at the catch and a flatter low back at the finish, while rowers WITH pain show greater posterior pelvic rotation at the catch, and that in both groups fatigue increases lumbar flexion at the catch, more on the ergometer than in a boat. Ng 2015 found no difference in mean lumbar angle between ten adolescent rowers with pain and ten without, but the painful group sat closer to end-range flexion for a greater proportion of the drive, came out of flexion less over the drive and spent more time in sustained flexion loading - so the fault is time spent near the end of the range, not one rounded stroke. Yamashita 2023 localised it: lumbar erector spinae activity was higher in the painful group at 0 to 10 per cent of the stroke cycle, p below 0.001, which is the catch. Wilson 2013 measured the drift directly, maximum lumbar flexion rising 4.4 plus or minus 0.9 degrees over an ergometer step test against 1.3 plus or minus 1.1 in a boat, p equals 0.035 - more than this model's entire 3.6000 degrees of lumbar range. Hart teaches a thirty-degree layback; the model gives 20.1677, which is 9.83 short, so no figure is quoted.",
                 "Opening the back before the legs are down, or getting the lean by rounding and then arching the lower back instead of rotating at the hips.",
                 "Once the legs are driving hard, swing your trunk open from your hips until you are leaning back a little past upright, and keep your back flat the whole way rather than rounding it and then arching it."),
       "finish": ("The Finish",
                  "The handle comes in last, to the bottom of your ribs, with your elbows going past your body and your shoulder blades drawing together.",
                  "The arm pull is f18 to f30 - 13 frames, 12 intervals, 0.5000 s - the elbow folding 174.7482 to 54.6383 degrees, 120.1099 degrees, and the finish itself is f30 to f34, 5 frames and 4 intervals, 0.1667 s. WHERE THE HANDLE ARRIVES, measured along the trunk rather than off the floor, because the trunk is laid back 20 degrees at that point: at f31 the hand midpoint projects 0.3136 m along the 0.5940 m axis from the hip joint to the neck joint, which is 52.8 per cent of the way up the trunk, and sits 0.0973 m out from that axis. The chest joint projects at 45.5 per cent, so the hands arrive 4.34 cm above it along the trunk, and they are 19.25 cm BELOW the collarbone joint in height. That is the bottom of the ribcage - not the collarbone and not the waist. The pull is flat, not an arc: the handle centroid's height stays inside 0.8400 to 0.8800 m, within 4 cm of level, across all 102.6285 cm of handle travel. The blades do draw together, and this is the one place the model shows a correction rather than a fault: shouldergap goes 0.409358 at f94 to 0.377253 at f28, which is 3.21 cm of scapular retraction. TWO THINGS THE MODEL FORBIDS HERE. The knee never straightens - knee_L maxes at 175.9932 and knee_R at 176.0943, both held to within 0.0008 of a degree for the whole of f16 to f54, 39 frames of every 96 - so nothing says the legs lock out and the correct string asks for a soft bend instead. And the wrist is never above the shoulder: hand_L sits 2.52 to 19.17 cm below clavicle_L on all 192 frames, 0 of 192 above it, so nothing says lift the handle. On the muscles, the paint and the measurement disagree in direction and neither is asserted here: the paint makes the traps, rhomboids and rear-delt group primary and the lats and biceps secondary, while Sha and Chiu 2026 ranks biceps brachii first of six at 24.34 to 39.37 per cent of MVIC and latissimus dorsi second at 20.29 to 24.93, on a water ergometer at a fixed stroke rate with twelve subjects and nine of this lift's sixteen bright muscles never measured.",
                  "Hauling the handle up into the collarbone, shrugging the shoulders up instead of drawing the blades together, or heaving further back to get it there.",
                  "Finish by drawing the handle in to the bottom of your ribs, elbows travelling past your body and your shoulder blades squeezing together, and leave a soft bend in your knees rather than locking them out."),
       "recovery": ("The Recovery",
                    "Coming forward you reverse the order: hands away first, then the body tips forward, and only then do the knees bend and the seat slide you back.",
                    "The recovery is the drive run backwards, and the model does it in that order and in that time. The arms go away over f34 to f45 - 12 frames, 11 intervals, 0.4583 s - the elbow opening 54.6294 to 174.8232 degrees. The body comes over f42 to f58 - 17 frames, 16 intervals, 0.6667 s - the trunk going 20.1677 degrees back to 15.3313 forward. The slide is f54 to f95 by the knee, 42 frames and 41 intervals, 1.7083 s, knee 175.9932 to 76.7988, or f58 to f95 by the seat, 38 frames and 37 intervals, 1.5417 s. THE KNEE IS THE LAST OF THE THREE TO MOVE, and it is pinned while it waits: knee_L holds between 175.9928 and 175.9932 degrees, a spread of 0.0004, for the whole of f16 to f54. By the seat alone the stroke divides exactly - 15 intervals driving at 0.6250 s, 43 intervals parked at the finish at 1.7917 s, 38 intervals sliding forward at 1.5833 s, which is 96 intervals and 4.0000 s, and 0.6250 plus 1.7917 plus 1.5833 is 4.0000. Hart 2006 is the named coaching source and the wording is his: on the recovery the handle leads the body forward, the arms extend first and then forward flexion occurs at the hips, and you should feel your weight shift to the front of the seat before the knees begin to rise. ONE CAUTION THAT GOVERNS THIS WHOLE ENTRY: the clip runs at 15.000 strokes per minute with a drive-to-recovery ratio of 1 to 2.533 measured by seat motion, and that is a demonstration tempo. No stroke rate, no ratio and no cadence is quoted anywhere a reader can see, here or in any other cue.",
                    "Letting the knees come up before the hands and the body have gone forward, so the handle has to be lifted over them.",
                    "Come forward in the reverse order - straighten your arms first, then let your trunk tip forward from your hips, and only then let your knees bend and the seat slide you back to the front."),
   },
   # Rows, ranks, fractions and stabilisers exactly as the row stage settled
   # them (rows_cond.md 4.3 and 8.3), re-read from tiers_cond.json: 16 bright
   # and 7 dim, nothing faint, nothing one-sided. Bright, so primary:
   # DeltoidPosterior as Posterior Deltoid; the three trapezius bands as ONE
   # unsplit Trapezius row; RhomboidMajor as Rhomboids; RectusFemoris and the
   # three vastus heads as one Quadriceps row; Infraspinatus, Supraspinatus,
   # Subscapularis and TeresMinor as one Rotator Cuff row; and all three
   # painted glutes as ONE Gluteus Maximus row, on the owner's standing
   # decision, so the copy says glutes and nothing names the medius. Dim, so
   # secondary: LatissimusDorsi, ErectorSpinae, both BicepsBrachii heads as
   # one Biceps Brachii row, and BicepsFemoris plus Semimembranosus plus
   # Semitendinosus as one Hamstrings row.
   # Four decisions inside the table, all the row stage's and none this
   # entry's: Trapezius is ONE primary row rather than three, because three
   # would need a primary Lower Trapezius row for which the library has zero
   # precedent at any fraction and would show the reader FEWER names, not
   # more; the leg rows do not come from the leg-press family - Quadriceps
   # 0.62 and Gluteus Maximus 0.48 are the library's values for legs that
   # drive a lift named after something else, because carrying Clean and
   # Press's own Gluteus Maximus 0.70 would put GLUTEUS MAXIMUS at the head of
   # the legend on a MID-BACK lift; there is NO Forearms row, the one place
   # the cable-row family parent is not followed, because this lift's paint
   # lights no forearm mesh and the paint rule is absolute, so the grip goes
   # to the stabilisers where 53 shipped blocks put it; and Erector Spinae
   # gets a row at 0.55 although the cable-row family makes it a stabiliser,
   # because the paint lights it dim and it is the one row here carrying real
   # safety weight. Carries: Posterior Deltoid 0.67 and Trapezius 0.63 and
   # Rhomboids 0.63 and Rotator Cuff 0.60 and Latissimus Dorsi 0.62 and Biceps
   # Brachii 0.48 from Low Cable Row (:21166-21176), the beginner member of
   # the cable-row family and the only one carrying the complete shape;
   # Quadriceps 0.62 from Clean and Press (:45624) and Power Snatch (:49202);
   # Erector Spinae 0.55 from Clean and Press (:45629); Gluteus Maximus 0.48
   # from Leg Press (:7051); Hamstrings 0.25 from Hack Squat (:3158). Every
   # level word came from common_1_50.level() and not from a keyboard. No
   # library= override - open point 5.
   activation=[("Posterior Deltoid", P, MOD, 0.67), ("Trapezius", P, MOD, 0.63),
               ("Rhomboids", P, MOD, 0.63), ("Quadriceps", P, MOD, 0.62),
               ("Rotator Cuff", P, MOD, 0.60), ("Gluteus Maximus", P, MOD, 0.48),
               ("Latissimus Dorsi", S, MOD, 0.62), ("Erector Spinae", S, MOD, 0.55),
               ("Biceps Brachii", S, MOD, 0.48), ("Hamstrings", S, LOW, 0.25)],
   # core where 279 shipped blocks put it; forearms because the grip is real
   # and the paint denied it a row; tibialis anterior because it is the one
   # stabiliser in this family with a measurement behind it - Vieira 2020
   # found it the ONLY one of eight lower-limb muscles recruited in the
   # recovery phase - and because no calf mesh is painted on this lift. Six
   # shipped uses of tibialis anterior is thin but real. Nothing here is
   # painted on this lift, and nothing names the gluteus medius.
   stabilisers=["core", "forearms", "tibialis anterior"],
   # The badge is ARMS PULL EARLY, which has exactly one shipped use
   # (:45641 cleanAndPressContent, cue Elbows bend before the hips open)
   # against ARMS PULLING EARLY's one (:48845) - the library has already split
   # this spelling and open point 3 says why this entry takes the first. The
   # mistake cue follows that block's own wording with the noun swapped. It
   # deliberately is NOT ROUNDED LOWER BACK (7 uses) or EXCESSIVE BACK LEAN
   # (4 uses, all four seated cable rows), because the animation shows neither
   # fault: 3.6000 degrees of lumbar chain range and a 20.1677-degree layback
   # against a taught 30. The correct note is this model's measured elbow
   # hold; the mistake note keeps the coaching honest by naming Hart as
   # coaching and saying plainly that no study has tested the sequence.
   comparison=("ARMS PULL EARLY", "Legs finish before the elbows bend",
               "Elbows bend before the legs finish",
               "In the model elbow_L is 175.0821 degrees at the catch, 174.8320 at f16 where the knee has already reached 175.9928, and 174.7482 at f18 - inside 0.34 of a degree of straight across the whole leg drive - and it only then folds 120.1099 degrees to 54.6383 by f30. The handle and the seat also start together, moving 5.060 mm and 3.848 mm respectively on the first interval of the stroke. The legs-then-arms order is the part of this animation worth copying.",
               "Hart 2006 in CrossFit Journal 50 is the named source and it is coaching, not a finding: the handle and the seat must move together on the drive, and a handle that moves first is evidence of pulling with the back early. No study tests the drive sequence against injury or against performance - Soper and Hume 2004 concludes that the biomechanical predictors of rowing performance are indistinct in the literature and that research on ideal technique is limited. What is measured is adjacent: Wilson 2014 reports that greater pelvic rotation at either end of the stroke is ideal as opposed to lumbar flexion and extension, and that this tends to be poorly demonstrated in novice rowers on ergometers."),
   # ONE PLAIN glow() CALL PER ROW OF PAINT, in row order, each written out in
   # full - no shared helper. Every joint named is in joints.json's own probe
   # set for this lift. The six BRIGHT rows get A and the four DIM rows get
   # SOFT: here A against SOFT is the PAINT TIER and nothing else, not depth
   # and not a side, because every one of this lift's 23 painted names
   # resolves to both an _L_Mesh and an _R_Mesh. glow() averages joints.json's
   # eight probed samples, so these are STATIC placements and not phase means,
   # and on this clip those eight samples span a wide arc - scapula_L alone
   # runs u 0.505..0.850 across them - so each centre is the mean of a sweep
   # and not a pose. The ten centres, all distinct: posterior deltoid
   # (0.660, 0.430), trapezius (0.680, 0.402), rhomboids (0.680, 0.462),
   # quadriceps (0.557, 0.588), rotator cuff (0.713, 0.428), glutes
   # (0.693, 0.617), lats (0.699, 0.522), erector spinae (0.689, 0.562),
   # biceps (0.590, 0.448), hamstrings (0.644, 0.632); the closest pair is
   # the posterior deltoid and the trapezius at an L1 distance of 0.048. The
   # dx and dy nudges exist only to separate ellipses that would otherwise
   # coincide - the rotator cuff and the rhomboids share the same two scapula
   # joints and so the same raw centre (0.683, 0.443), and the glutes and the
   # hamstrings sit 0.001 apart in v on the pelvis and the thighs - and the
   # ellipses still overlap, which is honest: on this body the rotator cuff is
   # under the scapula the rhomboids attach to, and the three hamstring
   # muscles are painted over the same stretch of thigh as the glutes end on.
   # The lifter faces screen-LEFT, so the BACK is at HIGH u and every nudge
   # toward the back is a positive dx.
   glows=[glow("Rowing Machine", ["deltoid_arc_scapula_2_L", "deltoid_arc_scapula_2_R"],
               A, 0.55, rx=0.075, ry=0.05, dy=-0.005),
          glow("Rowing Machine", ["support_TrapeziusUpper_L", "support_TrapeziusUpper_R",
                                  "neck"], A, 0.55, rx=0.075, ry=0.045),
          glow("Rowing Machine", ["scapula_L", "scapula_R", "spine"], A, 0.52,
               rx=0.07, ry=0.055, dy=-0.02),
          glow("Rowing Machine", ["thigh_L", "patella_L", "thigh_R", "patella_R"],
               A, 0.52, rx=0.105, ry=0.065),
          glow("Rowing Machine", ["scapula_L", "scapula_R"], A, 0.50, rx=0.06,
               ry=0.045, dx=0.03, dy=-0.015),
          glow("Rowing Machine", ["pelvis"], A, 0.48, rx=0.075, ry=0.05,
               dx=0.03, dy=0.02),
          glow("Rowing Machine", ["support_LatissimusDorsi_L", "support_LatissimusDorsi_R"],
               SOFT, 0.34, rx=0.08, ry=0.06),
          glow("Rowing Machine", ["spine"], SOFT, 0.30, rx=0.055, ry=0.065,
               dx=0.015),
          glow("Rowing Machine", ["upper_arm_L", "forearm_L", "upper_arm_R",
                                  "forearm_R"], SOFT, 0.28, rx=0.085, ry=0.04),
          glow("Rowing Machine", ["thigh_L", "thigh_R"], SOFT, 0.26, rx=0.09,
               ry=0.05, dx=-0.02, dy=0.035)])

# The setup steps and each cue's `correct` string are the ONLY coaching a
# reader sees outside the gated trainer - ExerciseDetailView.instructions()
# shows the steps and, per cue, the title and `correct`, while intro, why,
# mistake, the pill labels, the comparison and the stabilisers are not on that
# screen and `mistake` is behind the trainer AND the paywall - so the ORDER,
# which is the one thing the name Rowing Machine does not give, is carried
# three times over: in the drive cue's correct, in the recovery cue's correct
# and in step 4 here. The lumbar instruction, which is the best-evidenced
# safety point in this family, is carried twice: in the swing cue's correct
# and in step 5. No step leans on a number the reader has not been given, no
# step mentions the shin (open point 4), the heel (the heel never leaves the
# plate), a stroke rate (the clip's 15.000 per minute is a demonstration) or
# the damper and the flywheel (both off the left edge in all 192 frames).
# CORRECTED 2026-10-31: step 1 used to end so your heels stay down, which broke
# that rule three ways - the rationale above says no step mentions the heel; the
# heel is pinned by the rig rather than by the lifter (foot_L.y moves 16.129 mm
# and toe_L.y 0.888 mm over the clip, with the left foot's pitch running 9.1839
# to 15.1786 deg, toe above ankle, a range of 5.9947 deg); and on an erg the heel
# lifting at the catch is normal, so obeying it would cut the compression at the
# one end of the stroke the lumbar literature in swing.why is about. The step now
# says so your feet cannot slide, which is what the straps are actually for.
# Step 2's inside-the-shoulders grip is measured: handgap 0.245723 m
# against a shouldergap of 0.409358 at the catch, which is 60.0 per cent - 8.2 cm
# inside each shoulder, which is why the step no longer says JUST narrower.
# Lengths are 118, 117, 118, 116 and 130 characters against the library's
# median of 61, p90 of 96, p99 of 140 and all-time longest of 214, so all five are inside
# p99 and none approaches the record.
SETUP["Rowing Machine"] = [
    "Sit down, put both feet on the footplate and do the straps up across the balls of your feet so your feet cannot slide.",
    "Take the handle overhand, hands a little inside the ends of the bar and about shoulder-width apart.",
    "Slide forward until your knees are bent, your arms are straight and your shoulders are a little in front of your hips.",
    "Drive in order - legs, then body, then arms - then come forward in reverse: arms, body, knees - and row on for the set time.",
    "Take the lean from your hips with a flat back rather than rounding the lower back, and let the handle and the seat start together.",
]
# ------------------------------------------- battle rope alternating waves
# Shoulder/BattleRopeAlternatingWaves, resource BattleRopeAlternatingWaves,
# yaw -1.3 rad (-74.48 deg), zoom 0.934, offset [0.017, 0.084, -0.062],
# viewport 382 x 655. The framing is the app's own: SampleData.swift:3035
# carries exactly these numbers and jobs.py copies them. SampleData.swift
# mentions this lift at only two lines - 765 (the Exercise row: ANTERIOR
# DELTOID / BATTLE ROPE / beginner) and 3035 (the ExerciseModel) - so there
# is no ExerciseContent today and the trainer gates it. spec_1029.py line 28
# lists it in the cond family.
#
# NO library= KEY HERE, and that is deliberate rather than an omission. The
# shipped row already says ANTERIOR DELTOID, which is what this paint makes
# primary, so there is nothing to change; and common_1_50.validate_library()
# would REJECT any attempt, because its EQUIPMENT set is
# {BARBELL, DUMBBELL, EZ BAR, CABLE, MACHINE} and this lift's equipment word
# is BATTLE ROPE. Widening that set is an owner decision, not this entry's -
# open point 8.
#
# Everything below is read from measure_BattleRopeAlternatingWaves.md (which
# reads BattleRopeAlternatingWaves_A.json / _SIL.npz / _HEAD.npz /
# tiers_cond.json / the eight stills), from rows_cond.md section 8.4, from
# sources_cond.md section 5, from sources_safety.md section 3.4 and part 6,
# and from library_cond.md. Twelve figures were RE-MEASURED for this entry
# alone, off the same A.json, by d_BattleRopeAlternatingWaves/arm.py,
# rope.py, g1.py, g2.py and slot.py; they are marked RE-MEASURED where they
# are used. Nothing was re-exported and convert_all.py was never imported.
#
# ====================== WHAT THE CLIP IS ======================
# 192 frames at 24 fps. times[0] = 0.0, times[191] = 7.958333.
# TWO TIME CONVENTIONS, AND THEY DIFFER: the 192 samples SPAN 191 intervals
# = 7.958333 s; as a LOOP they are 192 intervals = 8.000000 s. Every
# frequency below uses the loop; every window uses the span. A window
# f<a>..f<b> inclusive is b-a+1 FRAMES and (b-a)/24 SECONDS, and each figure
# below says which it is.
#
# NOT ONE REP: FOUR bit-identical cycles of 48 frames = 2.000 s. The
# circular lag sweep (max over all 26 joints and all 192 frames of the
# EUCLIDEAN |J[i] - J[(i+k) mod 192]|) comes in under 1 mm at exactly three
# lags - 48, 96 and 144, all at 0.0001 mm - and gcd(48, 96, 144) = 48. The
# next nearest lag is 19 (0.7917 s) at 16.0174 mm, tied with 29, 67, 77,
# 115, 125, 163 and 173; those are the lags two or three WAVE periods away
# (one wave is 9.6 frames, so 19.2 and 28.8), and the 16.0 mm is the
# residual of a 0.2-0.4 frame misalignment.
# DO NOT read lag 24 as the next nearest. 24 is the half-period lag and it
# is one of the WORST in the whole sweep, 215.0160 mm, because half a cycle
# later the two arms have swapped. The half-period lag is what the MIRROR
# test wants: swapping every _L joint with its _R partner and negating x,
# frame f+24 is the mirror image of frame f to 2.4759 mm over the 20 paired
# joints, and the entire residual is in the knee (patella_L 2.476, shin
# 2.165, toe 0.430, foot 0.034 mm). In angles the mirror is exact:
# max |elbow_L(f) - elbow_R(f+24)| = 0.000164 deg.
# The seam is a continuation, not a cut: |J[191] - J[0]| = 73.3728 mm, which
# is the 79.6th percentile of the 191 interior steps (min 13.5273, median
# 48.3101, max 78.1868 mm), while |J[144] - J[0]| = 0.0001 mm.
# NO FROZEN FRAMES AT ALL. Scanning every circular interval at a 0.001 mm
# tolerance: 0 of 192 intervals frozen, 0 under 1 mm, 0 under 0.1 mm, 0
# under 0.01 mm, and the smallest step in the clip is 13.5273 mm. In both
# conventions that is 0 frames, 0 frame intervals, 0.000 s held. The lifter
# is in continuous motion from the first frame to the last - the opposite of
# the jump family (Box Jump holds still for 41.7% of its clip) - which is
# why a cue here may legitimately talk about rhythm: there is no hold to
# contradict.
# THE MOTION IS TWO PURE SINUSOIDS. FFT over the 192-frame circular loop
# (1 cycle per loop = 0.125 Hz): hand_L.y and hand_R.y are dominated by
# 20 cyc/loop = 2.5000 Hz at amplitude 0.093775 m (2nd harmonic 40 cyc at
# 0.008263, 3rd 60 cyc at 0.000257); hand_*.z the same 2.5 Hz at 0.053080 m;
# elbow_L and elbow_R the same 2.5 Hz at 8.8832 deg. pelvis.y, knee_L and
# handgap are dominated by 40 cyc/loop = 5.0000 Hz (0.007979 m, 2.3061 deg,
# 0.026341 m). So each arm waves at exactly 2.5 Hz - one wave every
# 9.6 frames = 0.400 s - and the body bobs at exactly 5.0 Hz. Counting
# turning points agrees: hand_L.y has 20 maxima and 20 minima over the loop,
# pelvis.y has 40 maxima. 9.6 frames is not a whole number of frames, which
# is why the POSE period is 48 and not 10: five waves (5 x 9.6 = 48) are
# needed before the motion lands back on the frame grid, and there is no
# frame at which one wave begins.
#
# ====================== THE PHASES ======================
# There is no hold and no take-off, so the phases are the quarters of one
# 0.400 s wave of one arm. Exact turning points from the 2.5 Hz component:
# hand_L.y peaks at frame 2.4000 + 9.6k (t 0.1000 + 0.400k s) and troughs at
# 7.2000 + 9.6k; hand_R.y is the reverse; elbow_L peaks where hand_L.y
# troughs; pelvis.y peaks at frame 1.2000 + 4.8k. The left hand tops out
# 0.200 s before the right - exactly half a wave. elbow is in ANTIPHASE with
# hand height (r = -0.9947): the hand is HIGHEST when the elbow is MOST
# bent. Hand height and hand reach move together (r = +0.9871).
#
#   #  phase              window   frames / intervals / seconds   what moves
#   1  bottom of stroke   f7       1 frame  / 0 int / 0.0000 s    hand_L.y 0.8955, hand_L.z 0.4317,
#                                                                 elbow_L 131.22, elbow_R 113.57,
#                                                                 knee_L 125.085, hip_L 137.391,
#                                                                 pelvis.y 0.80454
#   2  drive up           f7..f12  6 frames / 5 int / 0.2083 s    hand_L.y 0.8955 -> 1.0798,
#                                                                 hand_L.z 0.4317 -> 0.5371,
#                                                                 elbow_L 131.22 -> 113.50 (SHORTENS),
#                                                                 elbow_R 113.57 -> 131.31
#      mid-rise           f10      1 frame                        hand_L.y 1.0107, elbow_L 119.54
#   3  top of stroke      f12      1 frame  / 0 int / 0.0000 s    hand_L.y 1.0798 (max),
#                                                                 elbow_L 113.50 (MINIMUM)
#   4  drive down         f12..f17 6 frames / 5 int / 0.2083 s    hand_L.y 1.0798 -> 0.8914,
#                                                                 elbow_L 113.50 -> 131.22
#      mid-fall           f15      1 frame                        hand_L.y 0.9521, elbow_L 125.25
#   5  bottom again       f17      1 frame                        hand_L.y 0.8914, elbow_L 131.22
#
# f7..f17 is 11 FRAMES, 10 INTERVALS, 0.4167 s - 0.0167 s longer than one
# wave, because a wave is 9.6 frames and this window is 10 intervals. The
# exact cycle runs from frame 7.2 to frame 16.8. The right arm does the same
# thing 0.200 s later. A left-plus-right alternation is one wave apart,
# 9.6 intervals = 0.400 s, and the clip holds 20 of them; 24 intervals =
# 1.000 s is 2.5 waves and is not a unit of this clip. Over the 8.000 s loop: 20 waves per arm, 40 in all,
# 4 pose cycles, 40 body bobs.
#
# RANGES OVER THE WHOLE CLIP (A block, and RE-MEASURED by arm.py):
#   elbow_L   113.4982 (t 0.500, f12) .. 131.3138 (t 1.500, f36)   17.8156 deg
#   elbow_R   113.4981 (t 1.500)      .. 131.3137 (t 0.500)        17.8156 deg
#   knee_L    122.2226 (t 0.750)      .. 126.8357 (t 0.250)         4.6131 deg
#   knee_R    122.2321                .. 126.8459                   4.6138 deg
#   hip_L     135.9929                .. 138.2458                   2.2529 deg
#   hip_R     136.1404                .. 138.4015                   2.2611 deg
#   trunk     23.454590               .. 23.454607                  0.000018 deg
#   handgap   0.41216 m (t 1.000)     .. 0.46487 m (t 1.500)        0.052715 m
#   anklegap  0.39999964 m            .. 0.39999973 m               0.00000009 m
#   shouldergap 0.39215492 m          .. 0.39215505 m               0.00000014 m
#   anklegap / shouldergap = 102.0004% (RE-MEASURED); handgap is 105.1-118.5%
#   of shouldergap (RE-MEASURED), so the hands are a little wider than the
#   shoulders and never cross.
# Derived: wrist vertical swing 0.89140..1.08100 m = 18.96 cm; fore-aft
# 0.4310..0.5371 = 10.61 cm; LATERAL 0.3 um (hand_L) and 0.4 um (hand_R) -
# none. 42.9 cm of 3-D wrist path per wave, of which 37.9 cm is the vertical
# up-and-down. The wrist is below the shoulder joint in
# 192 of 192 frames, by 20.43..39.13 cm, ahead of it by 29.49..40.10 cm
# (both RE-MEASURED), and 9.03..27.73 cm above the pelvis joint. The upper
# arm never passes 34.705 deg from straight down (17.340..34.705, range
# 17.365 deg, the 3D angle from vertical, RE-MEASURED; the sagittal-plane
# projection of the same thing reads 15.459..33.458, range 17.999, and the
# 3D figure is the one quoted). Wrist speed 0.1248..1.8765 m/s, mean 1.0771,
# fastest t 0.417 and slowest t 1.708; each wrist covers 8.5723 m (left) and
# 8.5873 m (right) in 8 seconds. Pelvis bob 0.79449..0.81045 m = 15.958 mm,
# forty times, at 5.00 Hz.
# THE STANCE, TRUNK AND SPINE NEVER CHANGE. pelvis->spine 0.1142 m at
# 11.7790 deg forward (range 0.000015); spine->chest 0.1567 m at 20.8001
# (0.000022); chest->neck 0.3240 m at 28.8328 (0.000021); neck->head
# 0.1007 m at 15.2660 (0.000008); pelvis->neck 0.5909 m at 23.4546
# (0.000018). Feet pinned all 192 frames: foot_L (+0.2000, 0.0686, 0.0000),
# foot_R (-0.2000, 0.0686, 0.0000), toe_L (+0.2361, 0.0158, +0.1347), toe_R
# (-0.2361, 0.0154, +0.1345); TOTAL path over 8 s foot_L 0.0253 mm, foot_R
# 0.0273, toe_L 0.0285, toe_R 0.0304 - numerical noise. The toe is 13.5 cm
# ahead of the ankle. Everything above the knee holds its pelvis-relative
# offset to better than 0.0004 mm in all three axes; the only articulation
# anywhere is the two arms plus the 15.96 mm knee bob. Upper arm 0.2879 m
# and forearm 0.2498 m, both constant (RE-MEASURED).
#
# ====================== THE LOAD ======================
# eq_names is 78 entries, every one Cyl: 78 cylinder segments, 1560
# projected points per frame = exactly 20 per segment. eqc is (192, 78, 3)
# and eqbox (192, 78, 6) - one row per SEGMENT per frame, not one per frame
# (RE-MEASURED by rope.py). Segments 0-38 are the RIGHT rope, 39-77 the
# LEFT; segment 0 is the end at the fist and 38 the free far end, and z
# increases monotonically along both chains in every frame.
# THE ROPE IS DRIVEN BY THE LIFTER, not scenery. Segment 0 is rigidly
# parented to its wrist bone: |offset from the wrist joint| is
# 0.117468..0.117469 m on the right and 0.114122..0.114123 m on the left, a
# range of 0.61 um over all 192 frames (RE-MEASURED). The rope surface sits
# 6.03..7.69 cm from the right wrist joint and 5.70..7.41 cm from the left,
# crossing the fist at about 48 deg to the forearm - a hammer grip, not a
# floating rope. Chain length centroid-to-centroid 5.6411..5.8772 m (R) and
# 5.6424..5.8792 m (L) over the clip, 11.5075 m for the two together
# (RE-MEASURED; the measure report's frame-0 figures, 5.7994 and 5.6755 m,
# sit inside those ranges). Segment thickness 0.0361 m.
# NO ANCHOR MESH EXISTS, BUT THE GEOMETRY IS A LOOP. The two far ends sit at
# x -0.05281..-0.05210 and +0.05200..+0.05271, y 0.0190..0.0427,
# z 5.9059..5.9079 - 10.48..10.75 cm apart, at the same z to 2.005 mm,
# symmetric about x = 0, and 5.7712 m ahead of toe_L (all RE-MEASURED). That
# is exactly what one ~11.5 m rope looped round a post at 5.906 m would look
# like with the post left unmodelled. It is also entirely OFF SCREEN
# (segments 11-38 are never visible), so no reader can check it. Open
# point 2.
# THE TRAVELLING WAVE. Vertical swing grows from 23.00 cm at segment 0
# (z 0.553) to a peak of 40.81 cm at segment 8 (z 0.947) and then decays -
# 18.58 cm at segment 12, 8.11 at 18, 5.80 at 24, 3.56 at 32, 2.37 at 38 -
# and NEVER reaches zero: all 39 segments move. Wave speed 10.62 m/s over
# segments 0-12 (dz +0.8053 m, lag +0.0758 s), 4.25 over 12-24, 4.96 over
# 24-38; a straight fit over 0-12 gives -85.31 deg/m, wavelength 4.220 m,
# 10.55 m/s. The free end lags the fist by 1.0526 s = 2.63 wave periods, so
# the rope carries two and a half waves along its length at any moment. Rope
# L is in exact antiphase with rope R: at lag 24 frames the correlation is
# +1.0000 for every segment and the residual is 0.090..2.449 mm.
# WHAT YOU ACTUALLY SEE - AND THESE FIGURES ARE CLIPPED TO THE VISIBLE FRAME
# u 0..1, v 0..1, WHICH THE RAW ONES ARE NOT. Raw extent u -6.7704..0.3928,
# v 0.2864..1.0584 - 7.163 frame widths wide, with 80.2% of all load points
# off the LEFT edge (u < 0) and 5.4% below the bottom (v > 1); only 19.8%
# are visible. CLIPPED, the load occupies u 0.0000..0.3928 (0.0..150.1 px of
# 382) and v 0.2864..0.5291 (187.6..346.6 px of 655), 302..318 visible
# points per frame of 1560, mean 309.4. Only segments 0-8 of 39 on the right
# and 0-9 on the left ever appear: the viewer sees the first metre of a
# 5.8 m rope, and it is the lively metre - segments 0-8 carry the swings
# from 23.00 cm up to the 40.81 cm peak, while the stretch lying still on
# the floor is entirely off screen.
# WHERE THE ROPE IS IN EACH DRAWN LABEL BAND, CLIPPED:
#   drawn 0.16   never, 0 frames                       (room.py: 0.00 s, agrees)
#   drawn 0.32   148 of 192 frames, clipped u 0.0000..0.2302
#   drawn 0.48   180 of 192 frames, clipped u 0.0001..0.3928
#   drawn 0.64   NEVER - room.py says 8.00 s at u -0.535..-0.214, all off the left edge
#   drawn 0.80   NEVER - room.py says 8.00 s at u -1.653..-0.658, all off the left edge
# So room.py's own "load in the band" line is UNCLIPPED and misleading at
# rows 0.64 and 0.80, and its load-distance column is unclipped too: exactly
# two cells change when it is recomputed on visible points only - row 0.64
# leading 48.7 -> 57.2 px and row 0.80 leading 139.1 -> 161.6 px - and no
# /in count ever changes. Both corrected figures are used in the table
# below, and both are confirmed by slot.py's clipped column.
#
# ====================== THE PAINT ======================
# tiers_cond.json, key Shoulder/BattleRopeAlternatingWaves: 22 painted
# meshes, 3 BRIGHT, 19 DIM, 0 FAINT. NO mesh carries a _L or _R suffix, so
# every painted muscle lights on BOTH sides and every glow below spans both.
# For scale this is heavy but not the family's worst: Sled Drag 31, Battle
# Rope Slams 30, Rowing Machine 23, the jumps 10-14.
#   BRIGHT (3 meshes -> 2 rows)
#     BicepsBrachii_LongHead, BicepsBrachii_ShortHead -> Biceps Brachii (biceps)
#     DeltoidAnterior                                 -> Anterior Deltoid (frontDelts)
#   DIM (19 meshes -> 9 rows)
#     DeltoidLateral                                  -> Lateral Deltoid (sideDelts)
#     DeltoidPosterior                                -> Posterior Deltoid (rearDelts)
#     TricepsBrachii_Lateral/Long/MedialHead          -> Triceps Brachii (triceps)
#     TrapeziusLower/Middle/Upper                     -> Trapezius (upperBack)
#     RhomboidMajor                                   -> Rhomboids (upperBack)
#     ExternalOblique + InternalOblique               -> Obliques (abs)
#     RectusAbdominis                                 -> Rectus Abdominis (abs)
#     GluteusMaximus + Medius + Minimus               -> Gluteus Maximus (glutes)
#     RectusFemoris + VastusIntermedius/Lateralis/Medialis -> Quadriceps (quads)
# THE GLUTE RULE HOLDS. The rig lights maximus, medius and minimus as one
# unsplit group, so they collapse to a single Gluteus Maximus row, the copy
# says glutes, and no string in this entry names the gluteus medius - not in
# a row and not in the stabilisers.
# part_of() TRAPS CHECKED: part_of(Deltoid Anterior) and
# part_of(Deltoid Posterior) both return sideDelts, which is wrong, so the
# rows must read Anterior Deltoid, Lateral Deltoid, Posterior Deltoid - and
# they do. Nothing in this paint is a forearm mesh, so there is no honest
# Forearms row to write and grip work rides in the stabilisers instead
# (open point 5). Two legal part_of collisions: Obliques and Rectus
# Abdominis both file under abs, Rhomboids and Trapezius both under
# upperBack - validate() permits it, but TARGET MUSCLES will show one chip
# where the legend shows two names.
# IS THE PAINT VISIBLE? 9,728 painted px of 66,617 figure px; BRIGHT is
# 751 px = 1.13% of the figure, all of it on the NEAR (right) arm in a patch
# about 64 px wide and 74 px tall at u 0.421-0.589, v 0.226-0.339 - roughly
# 90 px of anterior deltoid cap (v 0.20-0.26, 11.9% of the bright pixels)
# and roughly 660 px of biceps belly (v 0.26-0.34, 87.9%). The FAR arm's
# bright paint is completely hidden behind the torso: 0 bright pixels at
# u >= 0.60. By screen box: near delt cap 382 bright + 660 dim of 2193
# figure px; near upper arm 544 + 231 of 2892; far delt and upper trap
# 0 + 1143 of 2117 (54.0%); upper back 0 + 3037 of 6722 (45.2%); front of
# the trunk 13 + 1359 of 2800 (48.5%); waist 0 + 1824 of 5101 (35.8%);
# glutes 0 + 228 of 2054 (11.1%); quads 0 + 3134 of 5495 (57.0%); lower
# thigh and knee 18 of 5259; shin, ankle and shoe 0 of 10465; the two
# forearms and fists 36 + 20 of 2215. The whole glute box is 21.6% painted
# against the quad box's 50.8%: the black shorts cover the top of the seat
# down to v 0.50 and below v 0.58 the visible surface is hamstring, which
# this lift does not paint. Nothing below v 0.68 is painted at all.
# LEGEND TRUNCATION. The legend joins the primary names with " . ",
# uppercases, and both lines are lineLimit(1) - about 40 characters at
# 375 pt and 43 at 393 pt. The primary line is comfortable:
# ANTERIOR DELTOID . BICEPS BRACHII is 33 characters and both names fit.
# The secondary line is not: all nine is 143 characters, 103 over, and at
# most THREE short names survive. Open point 4.
#
# ====================== LABEL GEOMETRY ======================
# Rows: a spec writes RAW slots and spec_1029.py row() draws them squeezed,
# drawn = round(0.16 + (raw - 0.14) * 0.64 / 0.72, 3), i.e. the defaults
# 0.14/0.32/0.50/0.68/0.86 draw at 0.16/0.32/0.48/0.64/0.80 and the inverse
# is raw = 0.14 + (drawn - 0.16) * 1.125. The overrides dict below is in RAW
# slots; every number in this block is at the DRAWN row, which is what
# room.py and lead.py take. The pill: half-height 0.025 in v, width
# (24 + 5.6 * len(label)) / 382, pinned 0.035 from the leading (left) or
# trailing (right) frame edge, frame 382 x 655. On a leading pill the left
# edge is fixed at u 0.035 and each extra character pushes the right edge
# 5.6 px further toward the lifter, so clearance falls 5.6 px per character.
# Measured with
#   python3.13 -I room.py "Battle Rope Alternating Waves" 10,11,12,14
#   python3.13 -I lead.py "Battle Rope Alternating Waves" <joint> <drawn row> <side> <len>
# and, for the one row room.py cannot reach, with slot.py (below).
#
# ON SCREEN THE LIFTER FACES LEFT, seen from the right-rear quarter: pelvis
# at u 0.718, head at u 0.529, hand_R at u 0.240-0.317, and both ropes run
# forward and leave through the LEFT edge. The joints occupy u 0.2398-0.7419
# and v 0.1818-0.8395. The floor is a flat RGBA (16, 17, 18) block whose
# horizon is at v 0.5069 (332 px, 218 px above the toe), so the lower 49% of
# the frame is near-black - which matters for the two pills below v 0.5.
# Per drawn row, from the SKINNED 655-row silhouette:
#   drawn  SIL rows  lifter u extent              left gutter    right gutter
#   0.16   88-121    0.4381..0.5888 (167-225 px)  167.3 px (f0)  157.1 px (f16)
#   0.32   193-225   0.1461..0.7390 ( 56-282 px)   55.8 px (f7)   99.7 px (f15)
#   0.48   298-330   0.1938..0.8444 ( 74-323 px)   74.0 px (f33)  59.4 px (f6)
#   0.64   402-435   0.4927..0.7541 (188-288 px)  188.2 px (f18)  93.9 px (f6)
#   0.80   507-540   0.4506..0.7751 (172-296 px)  172.1 px (f14)  85.9 px (f18)
# Rows 0.32 and 0.48 are where the ARMS are - the fists reach out to u 0.1461
# at 0.32 and the hip reaches back to u 0.8444 at 0.48 - so the lifter spans
# most of the frame width there. Rows 0.16 (head), 0.64 (knee) and 0.80
# (shin) leave a wide left gutter.
#
# THE CHARACTER CEILING PER DEFAULT SLOT, with the longest label whose pill
# never touches the skinned silhouette in any frame, and the same with the
# VISIBLE rope also kept out:
#   drawn  side      lifter ceiling   with rope   clearance at the ceiling
#   0.16   leading   23               23          1.2 px
#   0.16   trailing  21               21          2.1 px
#   0.32   leading    3               NONE        1.6 px (the rope is in the pill at every length)
#   0.32   trailing  11               11          0.7 px
#   0.48   leading    6               NONE        3.1 px (same)
#   0.48   trailing   3                3          5.3 px
#   0.64   leading   26               26          5.3 px
#   0.64   trailing  10               10          0.6 px
#   0.80   leading   24               24          0.4 px
#   0.80   trailing   8                8          3.7 px
# TWO OF THE FIVE DEFAULT ROWS CANNOT CARRY A LABEL. Row 0.48 has no usable
# slot on either side: leading is eaten by the rope (inside the pill in
# 124-176 of 192 frames at every length) and trailing tops out at THREE
# characters, which is not a label. Row 0.32 is nearly as bad: leading
# unusable, trailing 11 characters at 0.7 px. So this entry does NOT use
# raw 0.50 or raw 0.32. What it does instead is in open point 1.
#
# THE SLOT ACTUALLY CHOSEN FOR EACH PILL. Four of the five sit on default
# raw slots (0.14 twice, one pill in each gutter, plus 0.68 and 0.86); the
# fifth takes raw 0.23 -> drawn 0.24. NEITHER of those two things is new,
# and both counts were re-derived here rather than taken on trust, by
# brace-matching every overrides dict in the repo's spec*.py:
#   871 override entries across the 178 dicts that write raw slots literally
#   (290 overrides dicts in all, 1,431 entries, the other 112 going through
#   ov()); 134 of those 178 dicts repeat a raw slot. 48 DISTINCT NON-DEFAULT RAW VALUES
#   are already shipped, three-decimal ones among them (0.095, 0.225, 0.231,
#   0.466, 0.483, 0.591, 0.612, 0.635, 0.686, 0.759), and RAW 0.23 IS ONE OF
#   THEM, used 4 times - spec_1_50_compound.py, spec_1_50_curls.py and
#   spec_241_300_preacher.py. So the one moved row is not even a new value.
#   134 OF THE 290 DICTS REPEAT A RAW SLOT with one pill on each side, and
#   raw 0.14 leading plus 0.14 trailing is the commonest such pair of all -
#   spec_1029_arms.py Lying Cable Curl, spec_1029_clean.py Barbell Power
#   Clean and Hang Clean, spec_1012_kb.py Sumo Kettlebell Deadlift and
#   Kettlebell Deadlift, and the three spec_0927_shoulders.py entries all do
#   exactly what this entry does at drawn 0.16.
# In the shipped Swift the same thing shows up as 197 of the 466 content
# blocks having two annotations on one labelPoint.y, several with one in each
# gutter (chestPressMachine y 0.30 at x 0.22 and x 0.97; declineCrunch y 0.63
# at x 0.523 and x 0.726).
# gen.py places every overridden cue directly and only consults the default
# slot list for cues WITHOUT an override, so with all five overridden there is
# no interaction with raw 0.32 or 0.50 at all: a dry run of row() and
# layout() over this entry reports no un-overridden cue and leaves drawn 0.32
# and 0.48 free, and emits labelPoint x/y of (0.303, 0.16) hands,
# (0.741, 0.16) torso trailing, (0.244, 0.24) grip, (0.259, 0.64) tempo and
# (0.274, 0.80) stance - the same anchor edges the table above was measured
# at, each y landing on a clean two decimals as gen.py's y:.2f needs.
#
#   cue     label           len  raw    drawn side      lifter px / overlap   load px (clipped) / inside   leader
#   hands   Hands stay low  14   0.14   0.16  leading     51.57 /   0/192      66.39 /  0/192   hand_R     CLEAR 0/192, closest 51.7 px at t 1.33
#   torso   Torso still     11   0.14   0.16  trailing    58.12 /   0/192     220.85 /  0/192   spine      CLEAR 0/192, closest 57.4 px at t 0.54
#   grip    Light grip      10   0.23   0.24  leading     85.47 /   0/192      13.99 /  0/192   hand_L     CLEAR 0/192, never spans the head rows
#   tempo   Steady pace     11   0.68   0.64  leading     89.25 /   0/192      57.24 /  0/192   forearm_R  CLEAR 0/192, never spans the head rows
#   stance  Feet planted    12   0.86   0.80  leading     67.56 /   0/192     161.60 /  0/192   foot_R     CLEAR 0/192, never spans the head rows
#
# ALL FIVE PILLS: 0 of 192 overlap frames with the skinned lifter. ALL FIVE
# LEADERS: 0 of 192 frames inside the head's own silhouette. ALL FIVE PILLS
# also keep the visible rope out: 0 of 192 inside-frames, at clipped
# clearances of 13.99 to 220.85 px. THE RULE IS MET WITH NO BREACH, so there
# is no cheapest-breach figure to record.
# The four rows room.py itself covers (0.16, 0.32, 0.64, 0.80) are quoted
# straight from
#   python3.13 -I room.py "Battle Rope Alternating Waves" 10,11,12,14
# whose rows read, at the four lengths this entry uses:
#   0.16 leading   74.0/0/66.4/0    68.4/0/66.4/0    62.8/0/66.4/0    51.6/0/66.4/0
#   0.16 trailing  63.7/0/226.0/0   58.1/0/220.8/0   52.5/0/215.7/0   41.3/0/205.6/0
#   0.64 leading   94.9/0/48.7/0    89.3/0/48.7/0    83.7/0/48.7/0    72.5/0/48.7/0
#   0.80 leading   78.8/0/139.1/0   73.2/0/139.1/0   67.6/0/139.1/0   56.4/0/139.1/0
# room.py's ROWS tuple is hard-coded to the five default drawn rows, so it
# cannot test drawn 0.24. That one row was measured with
# d_BattleRopeAlternatingWaves/slot.py, which is room.py's own arithmetic -
# same _SIL.npz, same pill geometry, same formulas - generalised to an
# arbitrary row and given a load column clipped to u 0..1, v 0..1. It was
# validated by reproducing room.py's whole published ten-row table at
# lengths 9, 13, 17, 21, 25 and 28 CELL FOR CELL (slot.py check), and its
# clipped column independently reproduces the two corrections above
# (0.64 leading 48.68 -> 57.24 px, 0.80 leading 139.09 -> 161.60 px).
# Where drawn 0.24 came from, and why not 0.26 or 0.22: the rope sits just
# under the top-left gutter, so the load clearance there is VERTICAL and does
# not change with label length. At 10 characters, leading:
#   drawn 0.20  lifter 74.54 px / 0 overlap   rope 40.19 px / 0 inside
#   drawn 0.22  lifter 79.50 px / 0 overlap   rope 27.09 px / 0 inside
#   drawn 0.24  lifter 85.47 px / 0 overlap   rope 13.99 px / 0 inside   <- chosen
#   drawn 0.25  lifter 78.02 px / 0 overlap   rope  7.44 px / 0 inside
#   drawn 0.26  lifter 75.89 px / 0 overlap   rope  0.89 px / 0 inside
#   drawn 0.27  lifter 70.68 px / 0 overlap   rope  0.00 px / 28 inside  <- first breach
# 0.24 is the best lifter clearance of the six and the last row with
# double-digit rope clearance; 0.26 is clean but by 0.89 px, and 0.27 is the
# first row where the rope enters the pill. 0.24 also sits 0.08 below the two
# pills at 0.16, and pills are 0.05 tall in v, so the gap between their edges
# is 0.03 in v = 19.65 px; at drawn 0.22 that gap would be 6.55 px and at
# 0.26 it would be 32.75 px but with the 0.89 px rope margin. Its ceiling is
# 25 characters at 1.5 px, so the 10-character label leaves 85.5 px.
# WHY THESE ROWS AND NOT THE MEASURE REPORT'S OTHER OPTIONS: the leading
# gutter is roomy (>= 20 characters, lifter and rope both clear) at drawn
# 0.05-0.26 and 0.56-0.95 and DEAD at 0.27-0.55, where the visible rope is
# inside the pill at every length; the trailing gutter is roomy at 0.05-0.24
# and 0.88-0.95 and dead at 0.25-0.87, where the body is. Drawn 0.88 and
# above would need raw 0.95, outside the family's own stated 0.14-0.86 raw
# span, so this entry stays inside it. That leaves the top block (both
# gutters) and the bottom block (leading only), which is what the layout
# above uses. Open point 1 records the alternatives with their costs.
# LEADER MARGINS, full sweep of all 26 probed joints (lead_sweeps.txt). At
# drawn 0.24, 0.64 and 0.80 the pill is below the head's own rows, so every
# one of the 25 non-head joints never spans them at all and is CLEAR 0/192
# by construction; head itself is ON THE FACE 192/192 by construction and is
# not used by any pill. At drawn 0.16 every leader must cross those rows and
# all 25 are still CLEAR 0/192, but the margins differ, and at the lengths
# this entry uses they are:
#   0.16 leading, 14 characters (anchor edge u 0.3031): upper_arm_L 3.1 px,
#     scapula_L 3.6, neck 5.8, scapula_R 20.8, clavicle_L 25.5,
#     clavicle_R 26.7, upper_arm_R 27.0, chest 30.8, spine 35.3,
#     thigh_L 37.0, pelvis 38.2, forearm_L 39.8, forearm_R 47.2,
#     patella_L 47.1, foot_L 47.6, hand_L 50.3, HAND_R 51.7, toe_L 49.0
#   0.16 trailing, 11 characters (anchor edge u 0.7409): neck 31.0 px,
#     hand_R 32.8, hand_L 34.3, clavicle_R 39.7, clavicle_L 40.0,
#     upper_arm_R 40.2, forearm_R 44.7, scapula_R 45.5, upper_arm_L 46.0,
#     forearm_L 49.0, scapula_L 50.7, chest 55.8, patella_R 55.1,
#     SPINE 57.4, pelvis 57.8, thigh_L 58.1, foot_L 58.0
# The two tight anchors on 0.16 leading, upper_arm_L at 3.1 px and scapula_L
# at 3.6 px, are not used by any pill. The chosen anchors are the roomiest
# sensible ones on their slots: hand_R 51.7 px (3rd of the 25 at that slot)
# and spine 57.4 px (2nd of the 25 at that slot).
# WHY EACH ANCHOR IS THE JOINT ITS LABEL IS ABOUT, and where it sits on
# screen (joints.json means): hand_R (0.272, 0.396) is the NEAR fist, the
# one the viewer can actually see, so the hand-height pill points at it and
# the pill at drawn 0.16 sits at head height with the leader spanning
# exactly the shoulder-to-fist drop the cue is about; hand_L (0.335, 0.382)
# is the far fist, so the two hand pills take one fist each instead of
# crowding one; spine (0.702, 0.423) is at HIGH u, i.e. on the trailing side
# where its pill is, with a near-vertical 11 px leader; forearm_R
# (0.440, 0.380) is the near ELBOW (the rig calls the elbow forearm_* and
# the wrist hand_*), which is the joint whose rise and fall a reader watches
# for rhythm; foot_R (0.622, 0.780) is 0.02 in v from its own pill at drawn
# 0.80, so the stance label is drawn at foot height. Anchors are limited to
# the 26 joints in A.json: joints.json probes 41 for this lift and
# validate() accepts all 41, but room.py and lead.py can only test the 26,
# so no pill here uses one of the 15 untestable ones
# (attachment_TrapeziusUpper_L/R, deltoid_arc_clavicle_2_L/R,
# deltoid_arc_scapula_2_L/R, support_LatissimusDorsi_L/R,
# support_PectoralisMajor_Abdominal_L, _Clavicular_L/R, _Sternal_L/R,
# support_TrapeziusUpper_L/R).
#
# ====================== THE STILLS ======================
# Eight PNGs, 382 x 655 RGBA on a transparent background, and only TWO
# distinct images: t1 = t3 = t5 = t7 exactly (0 differing pixels) and
# t2 = t4 = t6 exactly, with t0 differing from t2 in 5 pixels at
# u 0.524-0.644, v 0.687-0.838 with a max channel delta of 5 - anti-aliasing
# on two identical poses. THE TWO IMAGES DIFFER ONLY IN THE ROPE: t0 vs t1
# differ in 6,860 pixels, 3,620 of them in the rope gutter left of u 0.24,
# and the lifter is in exactly the same pose (hand_L.y 0.981981 at f0 and
# 0.981981 at f24; elbow_L 121.7808 and 121.7807; max joint disagreement
# between frames 0 and 24 is 0.000186 mm). Frame 24 is the mirror of frame 0
# and at frame 0 the two arms happen to be level, so the mirror is the same
# picture. Matching the rope silhouette to eqpts identifies them uniquely:
# t0 is frame 0, 48, 96 or 144 and t1 is frame 24, 72, 120 or 168.
# TWO TRAPS IN THE STILLS, both relevant to this entry:
#  (a) The renders are NOT at probe.py's eight times and joints.json is.
#      probe.py samples at frame indices 0, 23.875, 47.750, 71.625, 95.500,
#      119.375, 143.250, 167.125 - eight different phases of the 48-frame
#      period - while the renders are consistent with the LOOP 8-split
#      (0, 24, 48, 72, 96, 120, 144, 168), which mod 48 is 0, 24, 0, 24, 0,
#      24, 0, 24: exactly the two poses rendered. So joints.json's anchors
#      drift across the eight samples while the pictures do not, worst case
#      8.3 px in u and 15.2 px in v on hand_L. That matters for the GLOWS,
#      which glow() centres on the mean of those eight samples: every centre
#      below is an eight-sample mean over two body poses that differ only in
#      the arms, so the trunk and leg centres are effectively static and
#      only the two arm centres carry any phase averaging at all.
#  (b) The eight stills never show the stroke's extremes. hand_L covers only
#      u 0.316-0.358, v 0.360-0.405 across them against a true clip range of
#      u 0.302-0.388, v 0.334-0.426 - 46% of the u travel and 53% of the v
#      travel. Anyone judging the swing from the stills underestimates it by
#      about half: the real wrist swing is 18.96 cm and the stills show
#      about 10 cm of it. No copy below is written from the stills.
#
# ====================== WHAT NOT TO COPY ======================
# Nine findings; the first four must stay out of the public copy and none of
# the five correct strings asks for any of them.
#  1. THE FEET NEVER MOVE. Total path over 8 s: foot_L 0.0253 mm, toe_L
#     0.0285 mm; anklegap constant to 0.00000009 m. No weight shift, no
#     step, no pivot, no heel lift. No cue says the lifter shifts, rocks,
#     steps or drives through one foot.
#  2. THE TRUNK NEVER MOVES. trunk constant at 23.4546 deg (range
#     0.000018), every spine segment to 0.00002 deg, shouldergap to
#     0.00000014 m, the head's x and z to 0.0 and 0.2 micrometres - it never
#     turns, nods or looks anywhere. So anything the copy says about the
#     torso is about HOLDING a position, not producing one, and the torso
#     cue is written that way.
#  3. THE BODY BOBS 40 TIMES IN 8 SECONDS - 15.958 mm at 5.00 Hz, 300 a
#     minute - while the knee opens and closes 4.613 deg, both knees in
#     phase to 0.0103 deg, pelvis-knee correlation +1.0000. A 1.6 cm bounce
#     five times a second is not something a human produces. NO CUE ASKS FOR
#     A RHYTHMIC DIP OR A LEG DRIVE, and the knee material in the stance cue
#     is about holding the shallow bend.
#  4. THE HANDS NEVER MOVE SIDEWAYS. hand_L.x and hand_R.x constant to 0.3
#     and 0.4 micrometres, pelvis.x to 0.0 um and pelvis.z to 0.1 um: the
#     whole lift happens in two parallel sagittal planes 0.4122 m apart.
#     Nothing crosses, circles or goes out to the side, so no copy borrows
#     language from in-and-out or circle waves.
#  5. The rope dips below the floor, by up to 2.816 mm, in all 192 frames,
#     on segments 16-38 (1164 of 14976 segment-frames, 72 of them deeper
#     than 2 mm); the resting underside is only +0.114..+0.930 mm above
#     y = 0, so its float and its sink are the same order. Invisible at this
#     zoom and off screen anyway, so it gets no copy.
#  6. The rope has no anchor mesh - see the load section and open point 2.
#  7. THE ELBOW FLEXES AS THE HAND RISES: minimum 113.498 deg at the TOP of
#     the stroke, maximum 131.314 at the bottom, r = -0.9947, over a range
#     of 17.816 deg. The copy therefore cannot say the arms hold a fixed
#     angle and cannot say they straighten on the way up. The hands cue says
#     what actually happens and nothing more - open point 3.
#  8. THE RANGE IS SMALL EVERYWHERE: knee 4.613 deg, hip 2.253, elbow
#     17.816, trunk 0.000018. Only the wrist moves a real distance, 18.96 cm
#     up and down. No cue promises a big or powerful movement.
#  9. THE ELBOW NEVER PASSES THE SHOULDER: forearm_L.z stays 7.6..15.6 cm in
#     front of upper_arm_L.z, the wrist is 20.43..39.13 cm below the
#     shoulder in 192 of 192 frames and 29.49..40.10 cm in front of it, and
#     9.03..27.73 cm above the pelvis. The arms never go behind the body.
# Neither of the jump family's two traps applies: the rope DOES reach the
# floor (it rests 0.114-0.930 mm above it and dips 2.8 mm into it), and
# there is no landing, so there is no heel-after-toe problem.
#
# ====================== THE SOURCES, CLAIM BY CLAIM ======================
# ONE EMG STUDY EXISTS WITH A %MVIC NORMALISATION AND IT FITS THIS CLIP.
# Calatayud, Martin, Colado, Benitez, Jakobsen & Andersen, Muscle Activity
# During Unilateral vs. Bilateral Battle Rope Exercises, J Strength Cond Res
# 2015;29(10):2854-2859, PMID 25853917, doi 10.1519/JSC.0000000000000963;
# full text read. n = 21 trained young MEN (age 23 +- 2.15 y, 177.63 +-
# 7.17 cm, 79.12 +- 9.1 kg, 11.82 +- 2.29% fat, at least a year of training
# twice a week). Rope 15 m long, 4 cm diameter, 14 kg. Stance: feet
# shoulder-width, trunk flexed forward approximately 30-45 degrees, half
# squat, NEUTRAL GRIP, arms straight and relaxed at the sides. Participants
# were asked to use MINIMAL LOWER BODY AND TRUNK MOVEMENT and to generate
# the waves primarily through shoulder flexion and extension. 3 consecutive
# repetitions per condition, 2 min rest, METRONOME AT 70 bpm. EMG at 1 kHz,
# high-pass 10 Hz, moving RMS 500 ms, peak RMS of the 3 reps averaged,
# normalised to the maximal RMS of two 5 s MVICs per muscle. Table 1,
# least-square means (SEM), the UNILATERAL ALTERNATING column being the one
# that applies to this lift:
#   anterior deltoid        63 (4.9) alternating vs 58 (6.9) bilateral, p 0.227
#   external oblique        73 (7.7)              vs 54 (6.3),          p 0.02
#   lumbar erector spinae   51 (2.7)              vs 67 (3.9),          p 0.001
#   gluteus medius          14 (2.3)              vs 18 (2.6),          p 0.054
# The protocol is this clip: minimal trunk and lower-body movement, waves
# from the shoulders, at a trunk flexion of 30-45 deg against the clip's
# 23.4546 - slightly more upright than the studied range, everything else
# agreeing. WHAT IT DOES NOT SHOW: four muscles only, so nothing on the
# biceps brachii that this paint makes BRIGHT, and nothing on the triceps,
# the other two deltoid heads, the trapezius, the rhomboids, the
# quadriceps, the rectus abdominis or the internal oblique; male only,
# n = 21, all trained, and the authors themselves ask for caution in
# generalising; one rope only, and they note that ropes of differing weight,
# length and diameter could give different results; peak RMS over three
# reps, so nothing about a sustained 30-second bout. The gluteus medius
# figure is recorded here and NOT used anywhere, per the owner's standing
# decision.
# The second EMG record, Eginyan, Williams, Joseph & Lam 2024 (J Spinal Cord
# Med 47:135-142, PMID 34874241), is 4 males with motor-complete spinal cord
# injury and 4 able-bodied controls, seated, relative rather than %MVIC EMG.
# It supports nothing about a standing able-bodied lifter and is cited for
# nothing. Marin, Garcia-Gutierrez, Da Silva-Grigoletto & Hazell 2015
# (J Musculoskelet Neuronal Interact 15(3):240-248, PMID 26350942, ABSTRACT
# ONLY, 28 recreationally active students, 20 s of undulation) states no
# normalisation, so no percentage may be written from it; its one usable
# statement is a DIRECTION - the gastrocnemius was more active during the
# alternating arm motion while the quadriceps, rectus abdominis and
# multifidus were more active double-arm - and it is the only measured thing
# that separates the app's two rope lifts. It is not quoted as a number.
# METABOLIC, for the pacing cue only. Ratamess 2015b (PMID 26049794, JSCR
# 29:2375-2387), 12 men and 10 women aged 20.8 +- 1.3, eight 30 s bouts of
# 15 s single-arm plus 15 s double-arm waves metronome-standardised at
# 15 waves per arm: 52.8 +- 5.5% VO2max in men and 50.0 +- 11.2% in women on
# 1-minute rests, 40.5 +- 4.5% and 37.7 +- 11.0% on 2-minute rests, with
# lactate, ventilation and heart rate all higher on the short rest.
# Fountaine & Schmidt 2015 (PMID 23897017, JSCR 29:889-893), 11 physically
# active, a 15.2 m rope ANCHORED AT A POST with 7.6 m per hand, ten 15 s
# bouts of double-arm waves with 45 s rest: mean HR 163 +- 11 bpm, peak VO2
# 35.4 +- 5.4 mL/kg/min, 10.1 +- 1.6 METs. Ratamess 2015a (PMID 24942174)
# found mean VO2 significantly greatest in its battle-rope protocol
# (24.6 +- 2.6 mL/kg/min) among thirteen single-exercise protocols. All are
# whole-protocol averages including rest, so none gives the cost of a single
# wave and none measured any muscle; NO STUDY MEASURES WHERE A ROPE WAVE
# FAILS OR PRESCRIBES A PACE.
# OUTCOMES, for the grip claim only. Cao 2026 (PMID 42768377, BMC Sports Sci
# Med Rehabil), PRISMA 2020 systematic review and meta-analysis of 21
# studies and 590 participants aged 11-25: upper-limb explosive power
# Hedges g = 1.59 (95% CI 0.77-2.42, p 0.001), GRIP STRENGTH g = 0.99
# (0.30-1.67, p 0.011), upper-limb muscular endurance g = 1.17 (0.04-2.30,
# p 0.044), core endurance g = 1.67 (0.30-3.03, p 0.016), and LOWER-LIMB
# explosive power NOT significant (g = 1.17, -0.21-2.55, p 0.088). The
# authors stress substantial between-study heterogeneity and call the
# subgroup analyses exploratory; every interval is wide. The lower-limb null
# is the specific reason no cue here claims a battle rope trains the legs,
# and the Quadriceps row stays at the bottom of the secondary list.
# WHAT HAS NO EVIDENCE AT ALL. There is NO study of battle rope shoulder
# position, scapular kinematics, impingement, or anything that changes with
# fatigue - not one - and the library has never badged pace, rhythm, tempo
# or going out too hard in 466 blocks. The shoulder material in the
# comparison below and the pacing material in the tempo cue are therefore
# coaching convention, and both say so where they are used. The measurement
# also says the usual impingement framing does not fit this lift: the
# painful-arc literature is about 60-120 deg of elevation and the upper arm
# here never passes 34.705 deg. Fatigue is NOT IN THE MODEL in any form -
# four identical cycles, a trunk that moves 0.000018 deg, a head that moves
# 0.2 micrometres, nothing that degrades - so any fatigue claim is the
# drafter's own voice and is confined to the gated fields.
# THE ONE THING THE NAME DOES NOT GIVE (sources_safety.md part 6, item 4):
# the waves come from short fast arm work below the shoulder while
# everything else holds still, so pick a pace you can hold for the whole
# interval. The name says the arms alternate. It does not say that the half
# squat and the forward lean are a HOLD, that the hands never come above the
# shoulder (0 of 192 frames, always 20.43-39.13 cm below it), or that at the
# model's own rate a beginner who goes all out is finished in fifteen
# seconds. That sentence is split across the stance, hands and tempo cues'
# CORRECT strings and setup steps 2, 3 and 5, which are the only places a
# free reader will see it: ExerciseDetailView.instructions() shows the setup
# steps and each cue's title and correct string, and nothing else.
#
# ====================== THE FIVE CUES ======================
# Ids: stance (45 shipped uses), hands (20), torso (106), grip (144), tempo
# (53) - all five are in the library's own vocabulary, all lower case and
# purely alphabetic as all 169 shipped ids are. Titles: Stance (23 shipped
# uses with this id), Hand Position (15), Torso Control (12), Grip (81),
# Tempo (38) - all five are reused house titles with the matching id.
# Labels, counted with len() the way validate() counts them, against the
# 1,294 distinct label strings in SampleData.swift:
#   Feet planted   (12) REUSE x21 - the library's most-used label, and one
#                  of those 21 is already on a `stance` id. It is also the
#                  most literally true label available: total foot path over
#                  eight seconds is 0.0253 mm.
#   Hands stay low (14) INVENTED. The library has no rope or conditioning
#                  entry with content, and nothing among its labels says a
#                  hand stays below the shoulder on a standing lift. Rejected
#                  with reasons: Hands under shoulders (21, x4) and Hands
#                  under the shoulders (25, x4) mean vertically aligned in a
#                  push-up, a different instruction and a confusing near-twin;
#                  Hands below shoulders (21, invented) would fit the slot at
#                  12.4 px but reads as that same twin; Handles at shoulder
#                  height (26, x3) is false here, the wrist being 20.43-39.13
#                  cm below the shoulder joint in every frame. Built on the
#                  library's own pattern - Elbows stay low (15), Legs quiet
#                  (10), Low back stays down (19).
#   Torso still    (11) REUSE x2, and both uses are on a `torso` id. The
#                  exact shipped pairing, and 0.000018 deg of trunk range is
#                  what it describes. Torso square (12, x2) was the
#                  alternative and is on a `core` id; it names only the twist,
#                  where this cue holds against the twist AND the rock.
#   Light grip     (10) REUSE x5, one of them on a `grip` id. Palms facing
#                  in (15, x6, four of them on `grip`) was the alternative
#                  and describes the measured neutral grip exactly, but the
#                  hand orientation is already carried by setup step 3 and
#                  the correct string, while grip TENSION is the half that
#                  decides the set.
#   Steady pace    (11) REUSE x2, and both uses are on a `tempo` id. Steady
#                  rhythm (13, x3) was the alternative and went to Jump Rope
#                  twelve hours ago; pace is the right word here because the
#                  fault is going out too hard, not losing the beat.
# Only TITLE and CORRECT are public. So each correct string is the whole
# instruction a lifter follows, each why carries the measurement, and each
# mistake is the fault stated as the thing being done wrong. No correct
# string asks for anything in the nine do-not-copy findings, and none coaches
# around an artefact: where the model and the lift diverge (the elbow, the
# bob, the missing anchor) the copy states the real mechanic and the
# divergence is recorded as an open point rather than written into the cue.
#
# ====================== OPEN POINTS FOR THE OWNER ======================
#  1. WHICH FIVE ROWS. The default raw slots leave two of the five
#     unwritable: drawn 0.48 caps at 6 characters leading with the rope
#     inside the pill in 124-176 of 192 frames, or 3 characters trailing;
#     drawn 0.32 caps at 3 characters leading with the rope inside in 144 of
#     192, or 11 trailing at 0.7 px. Four layouts, all measured:
#       (a) KEEP THE DEFAULTS, cues 2 and 3 trailing. Cost: 11 characters and
#           3 characters. A 3-character label is not a label, so cue 3 is
#           effectively unwritable.
#       (b) KEEP THE DEFAULTS, cues 2 and 3 leading anyway. Cost: the pill
#           covers the visible rope in 144 of 192 frames at drawn 0.32 and
#           176 of 192 at drawn 0.48, and cuts into the lifter in 88-160
#           frames. This breaks the zero-overlap rule outright.
#       (c) WHAT THIS ENTRY DOES: 0.16 leading / 0.16 trailing / 0.24
#           leading / 0.64 leading / 0.80 leading, i.e. raw 0.14, 0.14, 0.23,
#           0.68, 0.86. Cost: one new raw slot, two pills sharing drawn 0.16
#           (one per gutter), and three of the five in the left gutter with
#           two of those below the v 0.5069 floor horizon over near-black
#           floor. Benefit: ceilings 23, 21, 25, 26 and 24 against labels of
#           14, 11, 10, 11 and 12, so clearances of 51.6 to 89.3 px, zero
#           lifter overlap and zero rope-inside frames everywhere.
#       (d) RE-SLOT ALL FIVE to drawn 0.16 / 0.22 / 0.60 / 0.72 / 0.84, all
#           leading (raw 0.14 / 0.2075 / 0.635 / 0.77 / 0.905). Cost: all
#           five in one gutter, three of them crowded into the bottom third
#           over the floor, the top two 0.06 apart (6.55 px between pill
#           edges), and raw 0.905 is OUTSIDE the family's stated 0.14-0.86
#           raw span. Benefit: ceilings 23, 24, 26, 28, 28 - the most
#           headroom of any layout.
#     (c) is shipped because it is the only one of the four that meets the
#     rule with margin everywhere while staying inside the raw span. If the
#     owner would rather not double up on drawn 0.16, (d) is the fallback and
#     the labels need no change.
#  2. THE ROPE HAS NO ANCHOR MESH, and setup step 1 asks for one anyway. The
#     far end simply stops on the floor 5.7712 m ahead of the toe and
#     ripples 2.37 cm. The geometry is nevertheless a loop - the two far ends
#     are 10.48-10.75 cm apart, at the same z to 2.005 mm, symmetric about
#     x = 0 - so an unmodelled post at 5.906 m is the natural reading, and
#     Fountaine & Schmidt 2015 anchored its 15.2 m rope at a post with 7.6 m
#     per hand. All of it is off screen (segments 11-38 are never visible),
#     so no reader can be misled by the picture. The alternative is to drop
#     the anchor and phrase the setup purely around the lifter, which is what
#     measure_BattleRopeAlternatingWaves.md suggests; it touches TWO steps,
#     not one, because step 2 also says to stand facing the anchor, and the
#     cost is that a reader holding a loose rope is never told what to do
#     with the middle of it. Also note the modelled rope is SHORT: 11.5075 m
#     for the two chains together against the 15 m of Calatayud and the
#     15.2 m of Fountaine, so step 1 says a long rope and quotes no length.
#  3. THE ELBOW BEHAVIOUR. The model flexes the elbow AS the hand rises -
#     minimum 113.498 deg at the top, maximum 131.314 at the bottom,
#     r = -0.9947 - over a range of 17.816 deg, while the upper arm swings
#     17.365 deg. A planar reconstruction of the wrist (max error 7.3075 mm,
#     RE-MEASURED) splits the 18.96 cm of wrist rise into about 11.88 cm from
#     the shoulder swing alone and about 8.21 cm from the elbow flexion
#     alone, so roughly 60/40 and NEITHER joint is passive. Calatayud's
#     protocol asked for straight, relaxed arms and waves from the shoulders.
#     The hands cue says the shoulder does the driving and never says the
#     elbow holds a fixed angle or straightens on the way up; if the owner's
#     convention is that the copy describes the MODEL rather than the lift,
#     the elbow shortening could be named outright in the correct string
#     instead, at the cost of asking a reader to watch a 17.8 deg change.
#  4. HOW MANY SECONDARY NAMES TO PRINT. Nine secondary rows are justified by
#     the paint and section 8.4 settles all nine, but at most THREE short
#     ones survive lineLimit(1): all nine is 143 characters against a budget
#     of about 40 at 375 pt and 43 at 393 pt. Shortest-first,
#     OBLIQUES . TRAPEZIUS . QUADRICEPS is 33 characters and 3 of 9 survive;
#     longest-first, POSTERIOR DELTOID . RECTUS ABDOMINIS is 36 and only 2
#     survive. Keeping all nine means the reader sees three names and a
#     clipped word; cutting to three means TARGET MUSCLES loses six chips the
#     rig actually lights. This entry keeps all nine, following 8.4.
#  5. WHETHER TO CLAIM GRIP OR FOREARM WORK AT ALL. No forearm mesh is
#     painted, so there is no honest activation row for it and forearms ride
#     in the stabilisers, where they are not on the ungated screen. But the
#     grip CUE is one of the five and its title and correct string ARE
#     ungated, and Cao 2026 measures grip strength as one of the four
#     outcomes that improved (g = 0.99). If the owner would rather the five
#     cues all map onto painted tissue, the replacement is a `shoulder` cue
#     (shoulders down and back, anchored to scapula_R at (0.575, 0.270),
#     which is at the exact height of the drawn 0.24 pill) - but that has no
#     measurement behind it at all, the model holds the shoulders still so it
#     can neither perform nor refute the fault, and the comparison badge
#     below already carries the shrug. Dropping grip would also leave the
#     one thing that actually ends a beginner's set unmentioned anywhere a
#     free reader can reach.
#  6. WHETHER THE GLUTE ROW EARNS ITS PLACE. The rig lights all three glutes,
#     but only 21.6% of the glute box is visible paint against 50.8% for the
#     quads, the shorts cover the top of the seat down to v 0.50, and below
#     v 0.58 the visible surface is unpainted hamstring. Keeping the row is
#     faithful to the rig (and 8.4 keeps it); dropping it matches what a
#     reader sees. The glow for it is the dimmest of the eight at 0.24 for
#     the same reason.
#  7. THE 5 Hz BODY BOB. Forty bounces of 15.958 mm in eight seconds is a rig
#     artefact and reads as a shimmer rather than a movement. No cue asks for
#     it. The open question is the opposite one: whether the copy should
#     instead say the stance stays STILL, which is what the feet and trunk
#     actually do, and the stance cue does say that - so if the owner reads
#     the bob as intended leg drive, that cue is the one to change.
#  8. THE EQUIPMENT WORD. validate_library() accepts only BARBELL, DUMBBELL,
#     EZ BAR, CABLE and MACHINE, and this lift's shipped equipment is BATTLE
#     ROPE. No library= key is written here, so nothing fails; but the whole
#     cond family has this problem (sled, rope, rower, medicine ball), and
#     whether EQUIPMENT should grow is an owner decision for the family
#     rather than for this entry.
#  9. QUOTING THE MODEL'S RATE. The clip waves at 2.5000 Hz per arm - 150
#     strikes a minute per arm, 300 in all - which is more than twice
#     Calatayud's 70 bpm metronome and about two and a half times the 60 per
#     arm per minute of Ratamess 2015b. The tempo cue's why states the
#     figure and labels it the model's tempo rather than a target, and the
#     correct string quotes no rate at all (the library has never printed a
#     per-minute or bpm figure in a correct string, in 2,352 of them). If the
#     owner wants a rate in the public copy, the studied numbers are the ones
#     to print, not the clip's.
# 10. RAW 0.23 IS A ROUND FIRST, NOW COUNTED. The grip pill's raw 0.23 - which
#     spec_1029.row() draws at exactly 0.24 - is the only off-ladder label row in
#     the whole 36-exercise round: spec_1029_arms / clean / core / female /
#     glutes / jerk / jump / legs / snatch use ONLY 0.14 / 0.32 / 0.50 / 0.68 /
#     0.86 between them. None of the 1029 families uses the drawn-to-raw ov()
#     converter that spec_1010_female.py:139 defines, so bare raw numbers are the
#     round's own convention and only the VALUE is new here. Option A (taken) and
#     the measured cost of every alternative are in open point 1 above; this adds
#     only that the owner is being asked to bless a new slot value, not a new
#     notation.
ex(name="Battle Rope Alternating Waves", var="battleRopeAlternatingWaves",
   overrides={"hands": (0.14, "leading"), "torso": (0.14, "trailing"),
              "grip": (0.23, "leading"), "tempo": (0.68, "leading"),
              "stance": (0.86, "leading")},
   annotations=[
       ("stance", "Feet planted", "foot_R"),
       ("hands", "Hands stay low", "hand_R"),
       ("torso", "Torso still", "spine"),
       ("grip", "Light grip", "hand_L"),
       ("tempo", "Steady pace", "forearm_R"),
   ],
   cues={
       "stance": ("Stance",
                  "Everything from the hips down holds one shape for the whole interval - the waves come out of your arms.",
                  "This stance is a hold, and the model proves it. trunk is 23.454590 to 23.454607 degrees forward over all 192 frames, a range of 0.000018 degrees, and every spine segment keeps its angle to 0.00002 degrees: pelvis to spine 11.7790, spine to chest 20.8001, chest to neck 28.8328, neck to head 15.2660. The knee works over 4.6131 degrees (122.2226 to 126.8357) and the hip over 2.2529 (135.9929 to 138.2458). The feet are pinned: foot_L travels 0.0253 mm and toe_L 0.0285 mm in eight seconds, which is numerical noise, and the ankle joints hold 0.4000 m apart to 0.00000009 m - 102.0% of the 0.39215 m between the shoulder joints - with the toe 13.5 cm ahead of the ankle. Calatayud and colleagues (2015) set exactly this base for the one battle-rope study with a percentage-of-maximum normalisation: 21 trained men, feet shoulder-width, half squat, trunk flexed forward about 30 to 45 degrees, asked for minimal lower-body and trunk movement with the waves driven by the shoulders. This clip is a little more upright than their range at 23.45 degrees and matches it in every other respect. One thing in the model is not worth copying: the pelvis rises and falls 15.958 mm forty times in eight seconds, 5.00 Hz, with the knee opening and closing 4.613 degrees in step (correlation +1.0000). That is the rig answering the strike rate, not a leg drive, and the instruction is to hold the bend rather than pump it.",
                  "Standing up out of the half squat as the set goes on, or shuffling the feet to find a new base once it gets hard.",
                  "Set your feet about shoulder-width with your knees bent a little and your chest tipped forward over them, then leave your feet planted and hold that shape until the interval ends."),
       "hands": ("Hand Position",
                 "Each hand drives down and up over a short range and never comes up past your shoulder.",
                 "The wrist swings 18.96 cm vertically (0.89140 to 1.08100 m), 10.61 cm fore and aft, and 0.0003 mm sideways - so 42.9 cm of 3-D path per wave, 37.9 cm of it vertical, in a single vertical plane. It is below the shoulder joint in 192 of 192 frames, by 20.43 to 39.13 cm, ahead of it by 29.49 to 40.10 cm, and 9.03 to 27.73 cm above the pelvis joint, and the upper arm never passes 34.705 degrees from straight down (17.340 to 34.705, a span of 17.365). That matters for what this lift is not: the painful-arc and subacromial literature is about 60 to 120 degrees of elevation, and this stroke never gets near it, so the shoulder worry here is not an overhead one. The hands sit 0.41216 to 0.46487 m apart, 105 to 118% of the 0.39215 m shoulder span, and never cross. Calatayud and colleagues (2015) asked their 21 trained men for waves generated primarily through shoulder flexion and extension with the arms straight and relaxed, and measured 63% of maximum (SEM 4.9) in the anterior deltoid during the alternating wave against 58 (6.9) with both arms together. The model flexes the elbow as the hand rises rather than holding it - most bent at the top, 113.498 degrees, straightest at the bottom, 131.314, correlation with hand height -0.9947 over a range of 17.816 - and a planar reconstruction of the wrist (worst error 7.3 mm) puts about 11.9 cm of the 18.96 cm rise on the shoulder swing and about 8.2 cm on that elbow bend. Both joints work; the shoulder does more. The paint agrees about where the effort is: of 22 painted meshes the 3 bright ones are the anterior deltoid and the two biceps heads, and all 751 bright pixels sit on the near arm between v 0.226 and v 0.339.",
                 "Swinging the hands up toward the shoulders or overhead, which turns a short fast stroke into a slow heavy one and empties the interval.",
                 "Drive each hand down and straight back up over about twenty centimetres, keeping both fists below your shoulders and out in front of your hips, and drive from the shoulder and elbow rather than flicking the wrist."),
       "torso": ("Torso Control",
                 "One arm going up while the other goes down tries to turn you, and your trunk is what refuses.",
                 "This is the one number in the study that is bigger for the alternating wave than for anything else. Calatayud and colleagues (2015), 21 trained men, 15 m rope of 4 cm and 14 kg, peak RMS over three repetitions at a 70 bpm metronome normalised to two five-second maximal contractions: the external oblique reached 73% of maximum (SEM 7.7) in the unilateral alternating wave against 54 (6.3) with both arms together, p = 0.02 - while the lumbar erector spinae went the other way, 51 (2.7) against 67 (3.9), p = 0.001. So alternating puts the work into the side wall of the trunk, and the reason is that the two arms are out of phase: the left hand tops out 0.200 s before the right, exactly half of the 0.400 s wave. In the clip the trunk simply does not move - 23.454590 to 23.454607 degrees over 192 frames, every spine segment steady to 0.00002 degrees, the gap between the shoulder joints constant to 0.00000014 m, and the head fixed in x and z to 0.0 and 0.2 micrometres, so it never turns, nods or looks away. The paint lights the external oblique, the internal oblique and the rectus abdominis dim, and 35.8% of the waist box on screen is painted. Nothing in this clip fatigues, either: four identical 48-frame cycles, so the model can show the hold but not the moment it fails.",
                 "Letting the shoulders turn with each stroke so the trunk twists, or rocking the chest up and down to help the arms along.",
                 "Brace your middle, hold your shoulders down away from your ears and keep them square to the rope, so each arm works on its own without the trunk twisting."),
       "grip": ("Grip",
                "You hold the rope like a hammer, and how hard you squeeze decides how long the set lasts.",
                "The rope end is in the fist, not floating: the first segment of each rope is rigidly parented to its wrist bone, and its offset from the wrist joint varies by 0.61 micrometres over all 192 frames (0.117468 to 0.117469 m on the right, 0.114122 to 0.114123 on the left). The rope surface sits 6.03 to 7.69 cm from the right wrist joint and 5.70 to 7.41 cm from the left and crosses the fist at about 48 degrees to the forearm, which is a hammer grip with the palms facing each other - the neutral grip Calatayud and colleagues (2015) specify. Each side here is a chain of 39 cylinders 3.61 cm thick, 5.64 to 5.88 m long, 11.51 m for the two together; their rope was 15 m, 4 cm and 14 kg. Nothing in the clip shows grip force, and no study measures it in a rope wave. What is measured is the outcome: Cao and colleagues (2026), a review of 21 studies and 590 participants aged 11 to 25, found grip strength improved with battle-rope training, Hedges g = 0.99 with a confidence interval of 0.30 to 1.67, p = 0.011 - the authors stress substantial variation between studies and call their subgroup work exploratory, and the interval is wide. The forearm is also the one working tissue this rig does not paint at all: 22 meshes are lit and not one of them is a forearm, so the forearms are named among the stabilisers instead of getting a row.",
                "Squeezing the handle as hard as you can from the first stroke, so the forearms burn out well before the clock does.",
                "Grip firmly enough not to lose the rope and no harder than that - your forearms are what give out first."),
       "tempo": ("Tempo",
                 "Battle ropes are an interval rather than a set of reps, and the pace you choose is the whole exercise.",
                 "The model gives a tempo, and it is a display speed rather than a target. A Fourier transform over the 192-frame loop makes hand height a near-pure sinusoid at 2.5000 Hz (20 cycles per 8.000 s loop, amplitude 0.093775 m, second harmonic only 0.008263), so one wave of one arm is 9.6 frames = 0.400 s - 150 strikes a minute per arm, 300 in all - and a left-plus-right pair is 24 frames = 1.000 s, of which the clip holds eight. The pose repeats every 48 frames = 2.000 s to 0.0001 mm, four identical cycles, and there is no held frame anywhere: 0 of 192 intervals move less than 0.001 mm and the smallest step in the clip is 13.5273 mm. Each wrist covers 8.5723 m in eight seconds at 0.1248 to 1.8765 m/s, mean 1.0771. Now the comparison: Calatayud and colleagues (2015) used a 70 bpm metronome and Ratamess and colleagues (2015) standardised 15 waves per arm in 15 seconds, which is 60 a minute per arm - so the clip is running at more than twice the only rates anyone has studied. Ratamess measured what the interval costs: 12 men and 10 women through eight 30-second bouts reached 52.8 plus or minus 5.5% of maximal oxygen uptake in men and 50.0 plus or minus 11.2% in women on one-minute rests, falling to 40.5 plus or minus 4.5% and 37.7 plus or minus 11.0% on two-minute rests. No study measures where a rope wave fails and none prescribes a pace, and in 466 shipped blocks this library has never once badged pace, rhythm or going out too hard. The rule in the correct string is coaching convention, not a measurement.",
                 "Going flat out for the first ten seconds, so the waves shrink to nothing long before the interval is over.",
                 "Pick one speed you could hold for the whole interval and keep it from the first stroke to the last, and when the rope stops travelling end the set there rather than grinding on slower."),
   },
   # Rows exactly as rows_cond.md section 8.4 settles them, pasted unchanged:
   # 11 rows, 2 primary, 10 of the 11 carries from named shipped rows and 1
   # the family's Rhomboids S 0.30 estimate. They follow the paint recounted
   # above - 3 bright meshes giving the two primaries (Anterior Deltoid from
   # DeltoidAnterior, Biceps Brachii from the two biceps heads) and 19 dim
   # meshes giving the nine secondaries - and the single Gluteus Maximus row
   # is the owner's unsplit-glute rule, with no gluteus medius named
   # anywhere. Obliques leads the secondaries at 0.68 because it is the one
   # row with a measurement behind it, Calatayud's 73% of maximum for the
   # external oblique in this exact alternating wave; Quadriceps is last at
   # 0.25 because Cao 2026's lower-limb result is the one outcome that did
   # not reach significance. Order is primaries first then secondaries, each
   # fraction-descending, as 461 of 466 shipped blocks are. Every level word
   # came from common_1_50.level() and every name resolves through
   # part_of(): frontDelts, biceps, abs, triceps, sideDelts, upperBack,
   # rearDelts, abs, glutes, upperBack, quads. See open point 4 on the
   # legend, which shows at most three of the nine secondary names.
   activation=[("Anterior Deltoid", P, HI, 0.84), ("Biceps Brachii", P, MOD, 0.46),
               ("Obliques", S, MOD, 0.68), ("Triceps Brachii", S, MOD, 0.50),
               ("Lateral Deltoid", S, MOD, 0.40), ("Trapezius", S, LOW, 0.36),
               ("Posterior Deltoid", S, LOW, 0.30), ("Rectus Abdominis", S, LOW, 0.30),
               ("Gluteus Maximus", S, LOW, 0.30), ("Rhomboids", S, LOW, 0.30),
               ("Quadriceps", S, LOW, 0.25)],
   # The three stabilisers section 8.4 settles, pasted unchanged, no
   # deviation. erector spinae is the one Calatayud measured and the one the
   # alternating wave DEMOTES - 51% of maximum against 67 with both arms
   # together - so it belongs here rather than in a row; forearms is the lit
   # tissue this rig does not paint, so it has no honest row (open point 5);
   # calves carry a stance whose feet never leave the floor. No gluteus
   # medius, which is the library's fourth most common stabiliser and is
   # excluded by the owner's standing decision, and Calatayud's own 14% for
   # it is the lowest number in their table anyway.
   stabilisers=["erector spinae", "forearms", "calves"],
   # The badge names the one fault no cue mistake above already carries -
   # the five are standing up out of the half squat, swinging the hands high,
   # twisting or rocking, clenching the grip and going out too hard - and one
   # fault this model refutes exactly rather than
   # performs, which is the rule Step-Up Jump had to be fixed for last
   # round. SHRUGGING UP is a REUSE: 3 shipped uses, all raises, and the
   # count and the owners were RE-DERIVED here rather than copied, because
   # three line-number conventions are in play this round (sources_safety.md
   # 2.1). Quoting the line that HOLDS mistakeBadge:, they are
   # SampleData.swift:8021 dumbbellLateralRaiseContent, :8207
   # machineLateralRaiseContent and :24237 yRaiseContent; library_cond.md
   # indexes the same three at :8019, :8205 and :24235, which is the
   # comparison: line, always exactly 2 lower. A fourth use on a rope reads
   # naturally and no new badge is minted. The three shipped pairs are
   # Shoulders down, arms to 90 / Traps shrug the weight up; the same correct
   # cue with Traps shrug the pads up; and Shoulders down, arms in a Y /
   # Shoulders shrug to the ears - so the pair written below duplicates none
   # of them. Three alternatives were dropped with reasons. TORSO
   # TWISTING (12 uses) is the torso cue's own mistake, and all twelve uses
   # are single-arm lifts, which this is not. ARMS ONLY (2 uses) is wrong for
   # this lift: the alternating wave IS arm and shoulder work with the trunk
   # and legs holding, which is exactly what Calatayud instructed and what
   # the 4.6 degrees of knee and 0.000018 degrees of trunk show, so calling
   # arm work a fault here would be false. A knee-bounce badge is forbidden
   # by the no-badge-for-what-the-model-does rule: the pelvis bobs 15.958 mm
   # forty times in this clip, so the model performs it.
   comparison=("SHRUGGING UP", "Shoulders stay down and set", "Shoulders ride up to the ears",
               "The model never shrugs. The gap between the shoulder joints holds 0.39215492 to 0.39215505 m across all 192 frames, a range of 0.00000014 m, and the clavicles, scapulae and upper arms each keep their offset from the pelvis to better than 0.0004 mm in every axis, while the head is fixed in x and z to 0.0 and 0.2 micrometres. There is also no top of the wave for the traps to grab: the wrist is below the shoulder joint in 192 of 192 frames, by 20.43 to 39.13 cm, and the upper arm never passes 34.705 degrees from straight down. The paint says the same - all three trapezius bands are dim, and the only bright meshes are the anterior deltoid and the two biceps heads.",
               "This one is coaching convention and not a measurement, and it is worth saying plainly: there is no study of battle rope shoulder position, scapular motion, impingement or what fatigue does to any of them. Rope sources agree on keeping the shoulders packed down and away from the ears and on cutting the interval short once rope speed drops, and this library already badges the same fault on three raises. The clip cannot settle it either way, because nothing in it degrades: four identical 48-frame cycles, a trunk that moves 0.000018 degrees and a head that moves 0.2 micrometres."),
   # Eight glows for the eight paint boxes counted off the stills, not one
   # per activation row: no mesh in this paint carries a side suffix, so
   # every row lights on both sides, and what a reader can actually see is
   # eight patches rather than eleven muscles. A is the bright tier and SOFT
   # the dim one, straight off tiers_cond.json. rx and ry are set from each
   # measured box's half-width and half-height, and every centre was checked
   # to land inside its own box (d_BattleRopeAlternatingWaves/g2.py). glow()
   # averages joints.json's eight samples, and on this clip those eight land
   # on only two body poses that differ solely in the arms (see the stills
   # section), so the six trunk and leg centres are effectively a static
   # placement and only the two arm centres average any phase at all.
   # Opacity follows the measured painted fraction of each box: the two
   # bright arm patches at 0.55 and 0.50, quads 57.0% and obliques 35.8%
   # mid-range, and the glutes lowest at 0.24 because only 21.6% of that box
   # is painted and the shorts cover the top of the seat (open point 6). The
   # triceps gets no glow of its own: its 231 dim pixels sit inside the near
   # upper-arm box the biceps glow already covers, and the decode cannot
   # separate them.
   glows=[glow("Battle Rope Alternating Waves", ["upper_arm_R", "clavicle_R"], A, 0.55,
               rx=0.070, ry=0.038, dx=0.015, dy=-0.005),
          glow("Battle Rope Alternating Waves", ["upper_arm_R", "forearm_R"], A, 0.50,
               rx=0.062, ry=0.040, dx=0.030, dy=0.005),
          glow("Battle Rope Alternating Waves", ["upper_arm_L", "scapula_L"], SOFT, 0.32,
               rx=0.058, ry=0.045, dx=0.030, dy=0.020),
          glow("Battle Rope Alternating Waves", ["chest", "spine", "scapula_L"], SOFT, 0.30,
               rx=0.100, ry=0.068, dy=0.030),
          glow("Battle Rope Alternating Waves", ["support_PectoralisMajor_Abdominal_L",
                                                 "support_PectoralisMajor_Abdominal_R"], SOFT, 0.26,
               rx=0.072, ry=0.052, dy=0.025),
          glow("Battle Rope Alternating Waves", ["spine", "pelvis"], SOFT, 0.34,
               rx=0.092, ry=0.050, dy=0.055),
          glow("Battle Rope Alternating Waves", ["pelvis", "thigh_L"], SOFT, 0.24,
               rx=0.072, ry=0.045, dx=0.080, dy=0.065),
          glow("Battle Rope Alternating Waves", ["thigh_L", "thigh_R", "patella_L", "patella_R"], SOFT, 0.28,
               rx=0.075, ry=0.070, dy=0.015)])

# Five steps, 111 to 129 characters (129, 126, 114, 111, 120 in the order
# below), against a library median of 61, a p99 of 140 and a longest-ever of
# 214 over the 1,720 shipped steps; the brief's ceiling is about 135 and the
# longest here is 129. These and the five correct strings are the only text a
# free reader sees, so between them they have to carry the whole lift.
# Step 1 sets the rope up - see open point 2, since the model shows no
# anchor mesh, although the two far ends are 10.48-10.75 cm apart at the same
# distance, which is a loop round a post that was not modelled, and all of it
# is off screen. Step 2 is the half squat at the measured 23.45 degrees and
# the 0.4000 m stance, i.e. 102.0% of the shoulder span. Step 3 is the
# neutral grip and the hands low in front of the hips, which is the one thing
# the exercise name does not give. Step 4 clears the floor, which no library
# badge and no study covers and which nothing else in the app will tell
# anyone. Step 5 makes it a timed interval and gives the practical stopping
# rule in place of a rate: the model's 150 strikes a minute per arm is more
# than twice anything studied, and in 2,352 correct strings and 1,720 setup
# steps this library has never printed a per-minute or bpm figure. Step 5 and
# the tempo cue agree rather than compete - the clock sets the interval, and
# the rope going quiet ends it early.
SETUP["Battle Rope Alternating Waves"] = [
    "Loop the middle of a long rope round a post or rack upright, take an end in each hand and walk back until a little slack is left.",
    "Stand facing the rope, feet about shoulder-width, knees bent a little and chest tipped forward over them.",
    "Hold an end in each fist with your palms facing each other, elbows bent, and your hands out in front of your hips.",
    "Clear about three body lengths of floor in front of you and keep anything you could trip on out of the rope path.",
    "Work this for time rather than reps: set a clock before you start, and treat the rope going quiet as the end of the set.",
]
# ============================================================ battle rope slams

# ------------------------------------------------------- battle rope slams
#
# Shoulder/BattleRopeSlams.usdc, framing yaw -1.3 rad (-74.48 degrees), zoom
# 0.732, offset [0.017, -0.035, -0.063], viewport 382 x 655 - the app's own
# three numbers, at SampleData.swift:3037-3038, which jobs.py copies. The
# library row is at SampleData.swift:768 (category .shoulders, primaryMuscle
# ANT. + LAT. DELTOID, equipment BATTLE ROPE, difficulty .beginner) and there
# is no ExerciseContent, so this is a model-only lift. No library= override:
# library_cond.md section 7 recommends changing no shipped library row, and
# validate_library() would reject BATTLE ROPE anyway, since EQUIPMENT holds
# only BARBELL / DUMBBELL / EZ BAR / CABLE / MACHINE.
#
# THE APP LOGS THIS LIFT IN SECONDS, NOT REPS. The timedExercises set is
# declared at ExerciseCatalog.swift:130 and holds Battle Rope Slams at
# line 138, and line 101 is where unit() reads it (.time, not .reps). So
# nothing below counts reps as the unit of work and the pace step is written
# for an interval.
#
# CONVENTIONS. Y up, metres; the lifter faces +z, their left is +x. Knee is
# thigh-shin-foot, hip is chest-thigh-shin, elbow is upper_arm-forearm-hand,
# all inner angles (180 straight); trunk is the neck-over-pelvis line from
# vertical, POSITIVE FORWARD. The rig joint forearm_* IS the elbow and hand_*
# is the wrist. Ankle (shin-foot-toe) and upper-arm elevation from straight
# down are not in the published A block and are computed from the joint
# positions. WINDOWS ARE INCLUSIVE: f1..f13 holds THIRTEEN frames and spans
# TWELVE intervals = 0.5000 s. Every seconds figure below says whether it is a
# frame COUNT or a count of frame INTERVALS.
#
# EVERYTHING HERE WAS RE-MEASURED rather than copied. measure_BattleRopeSlams
# .md was read in full and then checked: d_BattleRopeSlams/v1.py re-derives
# the clip shape, every channel extreme, the speeds, the symmetry and the
# silhouette, d_BattleRopeSlams/v2.py re-derives the load - its world extent,
# the grip, the floor contact and what reaches the screen - and
# d_BattleRopeSlams/v3.py the remaining assertions: the rope's diameter, its
# motion during the lifter's freeze, the drawn crown, the floor horizon and
# the rope-to-limb distances. d_BattleRopeSlams/check.py then re-runs
# validate() over this fragment and re-checks every label against its slot
# ceiling. All four run with
# /Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13 -I
# and read only BattleRopeSlams_A.json, BattleRopeSlams_SIL.npz,
# BattleRopeSlams_HEAD.npz, joints.json, common_1_50.py and the two Swift
# files cited above. Nothing was re-exported, convert_all.py was never
# imported and nothing in GymWorkout was written. The paint is read from
# tiers_cond.json through rows_cond.md, and the only figures NOT re-derived
# here are the ones that need the PNG stills, which are quoted from
# measure_BattleRopeSlams.md section 7 and marked where they appear
# (Blender's python has no PIL). Three figures of the measure report did not
# reproduce and are corrected in open points 9 and 10.
#
# THREE TRAPS THIS MODEL SETS:
# (1) THE RIG IS SKINNED. GetPointsAttr().Get(t) returns the REST pose at
#     every time code, so every silhouette figure below comes from the
#     pre-computed _SIL.npz (the lifter, 655 rows) and _HEAD.npz (the head's
#     own rows), never from mesh points.
# (2) THE LOAD RUNS FAR OUTSIDE THE FRAME. The raw projection reaches
#     u -4.396 because the ropes run away from the camera along +z, which at
#     yaw -1.3 maps to -0.9636 in screen x. EVERY load extent quoted below is
#     CLIPPED to the visible frame (u 0..1, v 0..1) and says so; room.py's own
#     load columns are RAW, and where that changes a number it is stated.
# (3) ALL EIGHT OF joints.json's PROBED MOMENTS ARE THE SAME POSE. The probe
#     samples eighths of the clip and the period is exactly 24 frames, so all
#     eight land within seven-eighths of a frame of the top of a slam: head,
#     pelvis, toe_R, upper_arm_R and patella_R are identical to three decimal
#     places across all eight samples, and hand_L creeps only 0.008 in u
#     (3.1 px). stills/battle-rope-slams_t0..t7.png are eight copies of that
#     one instant (measure report section 7: t1..t7 are pixel-for-pixel
#     identical and t0 differs in 1,116 of 250,210 pixels, largest channel
#     difference 71/255, which is render noise).
#     So every glow() centre below is the TOP-OF-SLAM pose, not a phase mean,
#     and no still shows the descent, the bottom or the ascent.
#
# CLIP SHAPE. 192 frames at 24 fps, times[0] = 0.0, times[191] = 7.958333,
# USD time codes 1..192 (t0 = 1.0); frame f = round(t * 24). EIGHT
# BIT-IDENTICAL REPS ON A PERIOD OF EXACTLY 24 FRAMES = 1.000 s. A circular
# lag sweep (frame i against frame (i+k) mod 192, EUCLIDEAN per-joint
# distance, maximum over the 26 joints and all 192 frames) gives 0.0003 mm at
# lag 24 and the same 0.0003 mm at lag 48 - the runner-up is another multiple
# of the period, so a sorted list has to be read with that in mind. The
# nearest lag that is NOT a multiple of 24 is phase 1 at 253.4732 mm, about
# 845,000 times the loop error. THE HALF-PERIOD IS NOT THE RUNNER-UP BUT THE
# WORST: lag 12 reads 1287.8611 mm and the sweep's true maximum is phase 11
# or 13 at 1287.8612 mm. The clip loops: wrapping f191 onto f0 disagrees by
# 17.517 mm at worst (hand_L), mean 2.010 mm, which is not a seam defect but
# the ordinary f23 to f24 step of the cycle - 11.1% of the median per-frame
# maximum joint step of 157.8277 mm.
#
# THE ONE FREEZE, AND THE ROPE KEEPS MOVING. With a 0.001 mm tolerance (1e-9
# finds nothing) exactly 8 of the 191 intervals are frozen, and they are
# intervals 0, 24, 48, 72, 96, 120, 144 and 168 - f0 to f1 in every rep, the
# top of the slam. As a frame COUNT that is 16 of 192 frames = 8.33%; as a
# count of INTERVALS it is 8 intervals = 0.3333 s, 4.17% of the 8.000 s loop.
# On those same eight intervals the rope's largest centroid step is still
# 34.150665 mm, so nothing in the clip is ever fully still. There is no
# set-up pose, no finish pose and no rest frame: the clip starts and ends
# mid-work.
#
# THE PHASES, one period f0..f23 with f24 the next rep's f0 (v1.py):
#   1 TOP HOLD        f0..f1    2 frames, 1 interval = 0.0417 s. Frozen to
#     under a micron. knee_L 173.2675 (this rig's near-straight), hip_L
#     169.2028, trunk -4.9191 (BEHIND vertical), elbow_L 141.8910 (the most
#     bent it gets), ankle_L 128.8949, wrist 1.9454 m, pelvis 0.9408, head
#     1.6325, heel up at foot_L.y 0.1087, handgap 0.5553.
#   2 SLAM, descent   f1..f13   13 frames, 12 intervals = 0.5000 s. Wrist
#     1.945448 to 0.692912, a drop of 1.252535 m. knee_L 173.2675 to
#     114.1130 (59.1545 degrees), hip_L 169.2028 to 118.0121 (51.1907 over
#     the descent; 51.9597 clip-wide, because hip_L peaks at 169.9718 on the
#     way up at f22), trunk -4.9191 to +37.3313 (a 42.2505 degree swing),
#     ankle_L 128.8949 to 87.2944, pelvis down 18.103 cm, head down
#     31.266 cm. Sub-windows: f1..f4 the break (trunk crosses vertical
#     between f3 at -0.53 and f4 at +4.21); f4..f9 the drive (every interval
#     above 4.08 m/s of wrist speed, fastest f6 to f7 at 5.509 m/s);
#     f11..f13 the lower body stops - knee, hip, trunk, ankle, pelvis and
#     head are identical to within 1e-4 at f11, f12 and f13 while the wrist
#     still falls 5.33 mm then 1.88 mm. THE POSE BOTTOMS AT f11 AND THE
#     HANDS AT f13: 3 frames, 2 intervals = 0.0833 s.
#   3 RELOAD, ascent  f13..f24  12 frames, 11 intervals = 0.4583 s. The same
#     1.252535 m back up. The clip's fastest interval is f20 to f21 at
#     6.083 m/s, and elbow_L reaches its clip minimum 141.8884 at f23.
#     f23 IS NOT THE TOP - the wrist is still 5.4 mm low and 1.7 cm forward;
#     the top is f24, the next rep's f0.
#   whole period f0..f24: 25 frames, 24 intervals = 1.0000 s, and
#   1 + 12 + 11 = 24. THE DESCENT IS ONE INTERVAL LONGER THAN THE ASCENT.
#
# SPEED (v1.py). Peak 3-D wrist speed 5.509 m/s on the way down (interval
# f6 to f7) against 6.083 m/s on the way up (f20 to f21); means 3.094 down,
# 3.348 up. ONLY THE VERTICAL COMPONENT IS FASTER COMING DOWN: 5.462 against
# 5.008 m/s. The clip's single largest per-frame joint step, 253.4732 mm, is
# the wrist going UP, and it occurs eight times - once per rep.
#
# THE LOAD: TWO MIRRORED ROPES, 78 CYLINDERS (v2.py). eq_names is 78 entries
# and every one is Cyl - 1560 projected points per frame, 20 per cylinder.
# Meshes 0..38 are the lifter's right rope (mean x < 0) and 39..77 the left;
# the mirror error between them is 0.0002 mm over all frames and segments.
# Index 0 / 39 is the hand end and 38 / 77 the far end. Whole-load world
# bounding box over the clip: x -0.2669..+0.2669, y -0.0010..+2.2839,
# z -0.0182..+6.0206; the cylinder cross-section in x is 0.0384..0.0493 m, so
# a 4-5 cm rope. Each half runs 5.539..7.265 m as a polyline through its 39
# centroids, which means the model's geometry is consistent with ONE rope
# about 12 m long doubled round an anchor - the same order as the 12.8 m,
# 4.1 kg training rope in Faigenbaum 2018. That is a consistency check, not a
# prescription, and no string below names a rope length.
#   IT IS DRIVEN, NOT SCENERY: centroid path length over the clip is 28.52 m
#   at the hand segment, 32.82 m at the crest above the hand, 12.00 m at
#   segment 22 and 1.14 m at the far end. It is periodic on the same 24
#   frames as the lifter (eqc and eqbox agree to 0.0000 mm at lag 24, and the
#   projected eqpts to du = 0, dv = 0 exactly).
#   THE HANDS NEVER LET GO: the nearest rope centroid to hand_R is segment 1
#   at a constant 0.1136 m on all 192 frames and to hand_L segment 40 at
#   0.1111 m on all 192 - the handle is rigidly parented 11 cm beyond the
#   wrist joint, in the fist.
#   IT NEVER PASSES THROUGH THE LIFTER: outside the two grip bones the
#   nearest approach is 0.3124 m (thigh_L to patella_L, f13), and the loop
#   that curls above the head at the top stays 0.5005 m from the neck-to-head
#   segment.
#   THE FLOOR. Some part of the rope is down (segment bounding-box ymin
#   at or below 0.002 m) on every one of the 192 frames, 12 to 38 segments of
#   the 78 at any moment, mean 23.8 - that is 6 to 19 per rope, mean 11.9.
#   What changes is where it lifts off: out to z 4.382 m as the hands rise
#   (f23) and back to 1.591 m as they fall (f10). THE NEAREST THE ROPE EVER
#   TOUCHES DOWN IS z 1.5905 m at f10, against a toe_L frozen at z 0.134682,
#   so 1.4559 m clear of the toes, and it is on the floor from there out to
#   6.02 m on every frame.
#   ON SCREEN, CLIPPED TO u 0..1 AND v 0..1: 110,488 of 299,520 point-samples
#   are inside the frame = 36.9%, 481 to 699 per frame, mean 575.5. Clipped
#   u 0.0002..0.7118 = 271.8 px of 382; clipped v 0.0246..0.7261 = 459.5 px
#   of 655. Only 36 of the 78 cylinders are ever visible (right 0..17, left
#   39..56), 26 are visible on every frame (right 0..12, left 39..51) and 42
#   never appear at any frame. The visible portion runs from the hands up
#   into a tight loop above and behind them - its top is v 0.0246, 16.1 px
#   below the frame's top edge - then down and left, leaving the frame at
#   u = 0 at a v that sweeps with the slam (0.446-0.450 at f0, 0.320-0.338 at
#   f6, 0.699-0.706 at f12, 0.289-0.314 at f21).
#
# WHAT THIS MODEL DOES THAT A LIFTER MUST NOT COPY - all re-measured, and all
# of it kept out of the public strings:
#  - THE HANDS NEVER GET NEAR THE FLOOR. The lowest wrist in the clip is
#    0.692912 m, which is 6.69 cm BELOW the pelvis joint at that instant
#    (0.7598) and 23.34 cm ABOVE the kneecap (patella_L 0.4595). The slam
#    finishes at hip height. No string says drive it into the ground or
#    finish past the knees.
#  - NOTHING VISIBLY STRIKES THE GROUND. The nearest floor contact is
#    1.4559 m clear of the toes and the rope is already lying on the floor
#    from there out to 6.02 m on every frame of the clip, so the strike the
#    lift is named for is not an event the animation shows. See open point 5.
#  - THE ARMS ARE A STRAIGHT-ARM PENDULUM AND THEY STRAIGHTEN THE WRONG WAY.
#    elbow_L runs 141.8884..156.5163 - a 14.6279 degree range - elbow_R
#    141.2888..156.8816 (15.5928), and the wrist sits 0.5083..0.5265 m from
#    the shoulder against a fully extended 0.2879 + 0.2498 = 0.5377 m, a
#    spread of 18.1 mm. The elbow is STRAIGHTEST AT THE BOTTOM (156.5163 at
#    f10) and most bent at the top (141.8884 at f23). No string asks for a
#    bend at the bottom or for the elbows to drive the rope.
#  - THE FASTEST MOMENT IS THE LIFT, NOT THE SLAM (speeds above), and the
#    descent takes one interval longer. The drive cue says so rather than
#    calling the down phase the explosive one.
#  - THE FOREFOOT IS NAILED DOWN. toe_L moves 0.0277 mm in total over 192
#    frames and toe_R 0.0234 mm, per-frame maximum 0.0003 mm for both; the
#    heel rises 4.0150 cm at the top of each rep (foot_L.y 0.068599 to
#    0.108750) and is flat from f6 through f19. No string asks for a weight
#    shift, a step, a hop or a change in foot pressure, because there is none
#    to feel. The toes-planted clause in setup step 3 is the one thing the
#    foot does do.
#  - THE STANCE NEVER CHANGES. shouldergap is a constant 0.392155 m (range
#    0.000000); anklegap 0.400000..0.414267 = 102.0% to 105.6% of it, and all
#    1.4 cm of that is the heel lift, not a widening; handgap
#    0.514571..0.555250 = 131.2% to 141.6%, so the hands are always outside
#    the shoulders.
#  - NO LEAD SIDE. elbow_L minus elbow_R reaches 4.7841 degrees at f8 and
#    mirror(hand_L) minus hand_R 18.4811 mm, also at f8; the legs are tighter
#    (knee within 0.2667 degrees). This is a DOUBLE-ARM slam, nothing
#    alternates, and no string names a near or far side. TORSO TWISTING (12
#    shipped uses, all twelve single-arm lifts) must never be used here.
#  - NO HOLD AT THE BOTTOM A READER COULD TIME: the lower body stops for 3
#    frames, 2 intervals = 0.0833 s, and the only true freeze is one interval
#    per rep at the top.
#  - TWO RIG ARTEFACTS THAT DO NOT SHOW AT TRAINER ZOOM: the rope's lowest
#    point is -0.00102 m, 1.0 mm through the floor plane, on some frames, and
#    the far ends drift 5.99 cm over the clip, so nothing anchors them. 42 of
#    the 78 cylinders never reach the screen at all.
#
# PAINT (tiers_cond.json, key Shoulder/BattleRopeSlams): 30 painted meshes,
# 10 BRIGHT and 20 DIM, nothing faint - the second heaviest in the family
# behind Sled Drag's 31. NO PAINTED NAME CARRIES A SIDE SUFFIX, so both sides
# light and A against SOFT below is the paint tier alone, never depth and
# never a side.
#   bright: DeltoidAnterior (-> frontDelts); DeltoidLateral (-> sideDelts);
#           DeltoidPosterior (-> rearDelts); GastrocnemiusLateral,
#           GastrocnemiusMedial, Soleus (-> calves); RectusFemoris,
#           VastusIntermedius, VastusLateralis, VastusMedialis (-> quads)
#   dim:    BicepsBrachii_LongHead, BicepsBrachii_ShortHead (-> biceps);
#           TricepsBrachii_LateralHead, _LongHead, _MedialHead (-> triceps);
#           ExternalOblique, InternalOblique, RectusAbdominis (-> abs);
#           GluteusMaximus, GluteusMedius, GluteusMinimus (-> glutes);
#           ErectorSpinae (-> lowerBack); RhomboidMajor, TrapeziusLower,
#           TrapeziusMiddle, TrapeziusUpper (-> upperBack); Infraspinatus,
#           Subscapularis, Supraspinatus, TeresMinor (-> rearDelts)
# FIVE part_of() TRAPS, verified against common_1_50.py: part_of of
# Deltoid Anterior is sideDelts and of Deltoid Posterior is sideDelts too, so
# the rows must read Anterior Deltoid and Posterior Deltoid, with the
# adjective first; part_of of RectusFemoris is None, so it rides inside the
# Quadriceps row and is never named; part_of of TeresMinor is lats, while
# Teres Minor with the space is rearDelts, and the four cuff meshes ride
# inside one Rotator Cuff row rather than being named; part_of of Shoulders
# is None and it is not in LEGEND_ONLY, so that word can never be a row.
# THE REAR-DELT COLLISION is expected, not a defect: DeltoidPosterior is
# bright and the four cuff meshes are dim, and all five file under rearDelts,
# so ExerciseCatalog.partContributions keeps the stronger role and the detail
# screen shows ONE Rear delts chip marked primary. Both rows still appear in
# the trainer legend and validate() does not object.
# THE OWNER STANDING DECISION ON THE GLUTES IS APPLIED: the three gluteal
# meshes get a single Gluteus Maximus row, the copy says glutes, and no
# string anywhere in this entry names the gluteus medius.
#
# WHAT THE READER ACTUALLY SEES. ExerciseDetailView.instructions() is the
# only ungated surface: the SETUP steps and, per cue, the TITLE and the
# correct string. intro, why, mistake, the pill labels, the comparison and
# the stabilisers are not on that screen, and mistake is behind the trainer
# AND the paywall. So the four things a lifter has to know to do this lift at
# all are in setup steps or correct strings: that it is BOTH HANDS TOGETHER
# and whole-body rather than an arm action - sources_safety PART 6 item 5,
# the one thing the name does not give, and the words both hands together are
# in the slam cue's correct string precisely because the sibling entry is
# Battle Rope Alternating Waves and a reader could otherwise assume this one
# alternates too - that it finishes at hip height, that the rope lands out in
# front and needs that floor, and that the lift is timed so the rate has to
# be chosen.
# TARGET MUSCLES comes from the rows through MusclePart(muscleName:) and
# drops any name that resolves to nil - none of the fifteen rows below does.
# With all ten brights primary and all twenty dims secondary the screen shows
# 5 primary chips (Front delts, Side delts, Rear delts, Quads, Calves) and 6
# secondary (Biceps, Triceps, Abs, Glutes, Lower back, Upper back) in a
# FlowRow that wraps, so nothing truncates there. The trainer legend joins
# the row NAMES with a dot separator, uppercased, and both lines are
# lineLimit(1) - about 40 characters at 375 pt and 43 at 393 pt - so the
# primary line ANTERIOR DELTOID . GASTROCNEMIUS . QUADRICEPS . SOLEUS .
# LATERAL DELTOID . POSTERIOR DELTOID (92 characters) shows its first two
# names and the secondary line (136) shows two or three. That truncation is
# rows_cond.md section 7's measurement, not a new finding, and it is why the
# lift's library word ANTERIOR DELTOID is first.
#
# ======================================================= LABEL GEOMETRY
# Rows below are the DRAWN rows, which is what room.py and lead.py take;
# overrides= carries the RAW values, which spec_1029.py renders at
# 0.16 / 0.32 / 0.48 / 0.64 / 0.80 (raw 0.14 / 0.32 / 0.50 / 0.68 / 0.86).
# The pill the app draws: half-height 0.025 in v, width
# (24 + 5.6 * len(label)) / 382, pinned EDGE 0.035 from the leading (left) or
# trailing (right) frame edge, in a 382 x 655 frame. Clearances are against
# the SKINNED silhouette (BattleRopeSlams_SIL.npz, 655 rows) and the leaders
# against the HEAD'S OWN silhouette (BattleRopeSlams_HEAD.npz), because the
# drawn crown sits about 41 px above the head JOINT on this clip (v3.py:
# 40.4 to 41.7 px, mean 40.9; see open point 10) - a box round the joint
# would under-read every leader. All figures are over ALL 192 FRAMES.
#
# THE FRAME. The lifter never leaves it: silhouette u 0.1685..0.8047, rows
# 62..564 = v 0.0947..0.8626. Per drawn band, the lifter's u and the left
# edge of the band that a leading pill has to clear:
#   0.16  silhouette rows  88..121  u 0.3521..0.7265  left edge 0.3521..0.5184
#         (band EMPTY of the lifter on 128 of 192 frames)
#   0.32  rows 193..225  u 0.1903..0.7708  left edge 0.1903..0.5612
#   0.48  rows 298..330  u 0.1819..0.7624  left edge 0.1819..0.5660
#   0.64  rows 402..435  u 0.2815..0.7905  left edge 0.2815..0.5453
#   0.80  rows 507..540  u 0.4816..0.7323  LEFT EDGE 0.4816 ON EVERY FRAME
# The 0.1819 and 0.1903 left edges at rows 0.48 and 0.32 are the hands
# sweeping through at the bottom of the slam, which is what kills the leading
# gutter there; row 0.80 is the ankles and shoes and its left edge never
# moves, which is why a 26-character pill fits there and nowhere else.
#
# WHICH JOINTS SIT INSIDE EACH BAND (frames of 192): 0.16 hand_L 48, hand_R
# 24. 0.32 neck 88, clavicle_L 64, clavicle_R 64, upper_arm_L 64, head 56,
# scapula_L 48, upper_arm_R 48, forearm_R 16, forearm_L 8, hand_L 8, hand_R
# 8. 0.48 chest 104, spine 88, support_PectoralisMajor_Abdominal_R 56,
# forearm_R 32, forearm_L 24, hand_L 16, hand_R 16. 0.64 patella_R 72,
# shin_R 40. 0.80 foot_R 192/192, toe_R 192/192, foot_L 64.
#
# room.py "Battle Rope Slams" 7,8,9,11,24  (and 7,8,9,11,12,17,26 for the
# ceilings), reading lifter clearance px / lifter-overlap frames / load
# distance px / frames with the load inside the pill, out of 192:
#   0.32 trailing   8ch  +5.4 /  0 / 122.8 / 0      <- TAKEN
#   0.48 trailing   9ch  +3.0 /  0 / 149.1 / 0      <- TAKEN
#   0.64 trailing   7ch  +3.5 /  0 / 127.8 / 0      <- TAKEN
#   0.80 leading   24ch +12.2 /  0 /  29.5 / 0      <- TAKEN
#   0.80 trailing  11ch  +3.3 /  0 / 132.7 / 0      <- TAKEN
#   0.16 leading   17ch  +1.9 /  0 /   0.0 / 80     rope inside the pill
#   0.16 trailing  11ch  +5.5 /  0 /  26.6 / 0      every leader on the face
#   0.64 leading   12ch  +3.0 /  0 /   0.0 / 56     rope inside the pill
#   0.32 leading    7ch  -3.9 / 16 /   0.0 / 64     never clean
#   0.48 leading    7ch  -7.1 / 16 /   0.0 / 24     never clean
# EXACT CHARACTER CEILINGS (each extra character costs 5.6 px): 0.80 leading
# 26 (+1.0 px; 27 gives -4.6 px on all 192 frames), 0.16 leading 17 (+1.9),
# 0.64 leading 12 (+3.0), 0.16 trailing 11 (+5.5), 0.80 trailing 11 (+3.3;
# 12 gives -2.3 px on all 192), 0.48 trailing 9 (+3.0; 10 gives -2.6 px on 48
# frames), 0.32 trailing 8 (+5.4; 9 gives -0.2 px on 16 frames), 0.64
# trailing 7 (+3.5; 8 gives -2.1 px on 40 frames), 0.32 leading 6 (+1.7),
# 0.48 leading never.
#
# THE ONE PLACE CLIPPING CHANGES A ROOM.PY NUMBER. At 0.80 leading the
# nearest load sample over all rope points is 29.5 px, but the nearest
# ON-SCREEN sample is 32.3 px, at u 0.0236, v 0.7261, frame 10 - and it sits
# above the band, not beside it. Everywhere else the nearest point is already
# on screen, and every inside-the-pill count is honest either way, because a
# point inside a pill is necessarily inside the frame. room.py also prints
# load in the band 8.00 s for row 0.80 from geometry whose clipped u is
# -1.383..-0.092, i.e. entirely off the left edge: ROW 0.80 CARRIES NO
# VISIBLE ROPE ON ANY FRAME (v2.py: 0 of 192 frames with an on-screen rope
# sample in that band, against 80 at row 0.16, 88 at 0.32, 24 at 0.48 and 56
# at 0.64).
#
# THE LAYOUT, AND WHY IT IS THE ONE THAT PASSES. The round's hard test is
# that a pill has ZERO lifter-overlap frames and its leader ZERO frames on
# the head. measure_BattleRopeSlams.md open point 1 framed this lift as a
# choice between a pill sitting on the rope (0.64 or 0.16 leading) and a
# leader crossing the face (the trailing rows), because its option table does
# not contain 0.64 TRAILING at 7 characters. It should: at 7 characters that
# slot is +3.5 px clear of the lifter on every frame, 127.8 px from the
# nearest rope point with the rope inside the pill on 0 frames, and its
# leaders are clear for 23 of the 26 probed joints. With it the layout below
# is clean on BOTH hard tests AND on the load, which no other arrangement on
# this lift manages. The price is paid in characters and in spread: one label
# is capped at 7, four of the five pills sit on the trailing edge, two share
# row 0.80, and the frame's top sixth carries no pill at all. Open points 1
# and 2 give the alternatives with their measured costs.
#
# PILL BY PILL, in cue order (slot, label and its length, lifter clearance
# and overlap frames, load distance and frames inside, leader against the
# head's own silhouette):
#   top     `Reach up`  (8)  row 0.32 trailing. Lifter +5.4 px / 0 frames,
#     load 122.8 px / 0 frames inside. lead.py "Battle Rope Slams"
#     upper_arm_R 0.32 trailing 8 -> anchor edge u 0.7849, CLEAR 0/192,
#     closest 43.8 px at t = 0.46. This is the roomiest leader in the layout
#     and it is the right anchor for an overhead cue: the upper arm is what
#     reaches 153.3511 degrees from straight down. The slot is the stingiest
#     on leaders of the five taken - at 8 characters forearm_L is on the face
#     72/192, hand_L 80, hand_R 64, forearm_R 48 and head 184 - so no pill
#     here may anchor on a hand or an elbow; everything from the neck down is
#     clear by 32.2 to 66.4 px.
#   body    `Whole body, not the arms` (24)  row 0.80 leading. Lifter
#     +12.2 px / 0 frames, load 29.5 px / 0 frames inside (32.3 px to the
#     nearest ON-SCREEN sample, above the band). lead.py ... pelvis 0.80
#     leading 24 -> anchor edge u 0.4497, CLEAR 0/192, and the leader never
#     spans the head's rows at all. THE LABEL IS 24 AND NOT 26 ON PURPOSE:
#     the ceiling is 26 at +1.0 px, and 24 buys 11.2 px of margin on the one
#     pill whose band the lifter's feet never leave. The anchor is the pelvis
#     because the hips are what the cue is about - they drop 18.103 cm - and
#     because from this slot only head and forearm_L are on the face.
#   elbow   `Arms long` (9)  row 0.48 trailing. Lifter +3.0 px / 0 frames,
#     load 149.1 px / 0 frames inside. lead.py ... forearm_R 0.48 trailing 9
#     -> anchor edge u 0.7702, CLEAR 0/192, closest 7.4 px at t = 0.00.
#     forearm_* IS the elbow joint, so the pill points at the thing it names,
#     and the pill sits in the band the elbow occupies (forearm_R is inside
#     it on 32 of 192 frames). NINE CHARACTERS IS THE ONLY LENGTH THAT IS
#     CLEAN ON BOTH TESTS: the leader margin IMPROVES with length (6.7 px at
#     7, 7.4 at 9, 7.8 at 10) while the lifter clearance fails at 10
#     (-2.6 px on 48 frames). hand_R from this slot is clear by only 4.3 px
#     and hand_L is on the face 48/192, so the elbow is also the only arm
#     anchor this slot can take.
#   bottom  `Stop at hip` (11)  row 0.80 trailing. Lifter +3.3 px / 0 frames,
#     load 132.7 px / 0 frames inside. lead.py ... hand_R 0.80 trailing 11
#     -> anchor edge u 0.7409, CLEAR 0/192, closest 19.6 px at t = 0.00.
#     Eleven characters is the ceiling (12 puts the pill on the lifter on all
#     192 frames). The anchor is the hand because the cue is about where the
#     hands stop; hand_L is on the face 32/192 from here and forearm_L 64, so
#     hand_R is the one arm anchor available. The two row-0.80 pills do not
#     touch: at 24 characters the leading one spans u 0.0350..0.4497 and at
#     11 the trailing one spans u 0.7409..0.9650, 111.3 px apart. 134 of the
#     290 override blocks in the shipped specs already put two cues on one
#     row with opposite sides, spec_1029_jump.py among them, so this is house
#     practice and not a new shape.
#   drive   `Rise up` (7)  row 0.64 trailing. Lifter +3.5 px / 0 frames, load
#     127.8 px / 0 frames inside. lead.py ... patella_R 0.64 trailing 7 ->
#     anchor edge u 0.7996, CLEAR 0/192, and the leader never spans the
#     head's rows at all. The anchor is the kneecap because the reload is a
#     leg action - the knee opens 114.1130 to 173.2675 over 11 intervals -
#     and patella_R is the joint that actually lives in this band (72 of 192
#     frames, u 0.560..0.593). SEVEN CHARACTERS IS THE CEILING: at 8 the
#     lifter is inside the pill on 40 frames. This is the slot the measure
#     report's option table missed, and it is what makes the layout clean.
#
# LABEL STRINGS. `Arms long` has 10 shipped uses, so the elbow cue carries
# the library's own word for its own cue. The other four are new and each was
# checked against what the library already owns. The two obvious candidates
# both fail: `Stand tall` (13 shipped uses) is 10 characters and fits neither
# the reload's 7-character slot nor the overhead cue's 8, and `Hips back` (12
# uses) is 9 and would fit the elbow's slot but says nothing about an elbow -
# and on the slam cue, which has 24 characters to spend, it would badge the
# hinge half of a model that squats as much as it hinges (knee 59.1545
# against hip 51.1907 over the descent, within 8 degrees of each other).
# `Reach up`, `Stop at hip`, `Rise up` and `Whole body, not the arms` have no
# shipped use. Seven-character labels are rare but real - the library ships
# Legs up (x4), Eyes up, Chin up, Toes up, No dip and Lean in - and the
# longest label here, 24 characters, is well inside validate()'s 28.
#
# ======================================================= SOURCES
# NO %MVIC-NORMALISED EMG STUDY OF A ROPE SLAM EXISTS (sources_cond.md
# section 6, with its verified negative searches). Calatayud 2015 cannot be
# borrowed for two independent reasons: it measured bilateral and alternating
# WAVES, not slams, and its protocol instructed minimal lower body and trunk
# movement, which is the opposite of this clip's 42.2505 degree trunk swing
# and 59.1545 degree knee range. So NO string in this entry claims a muscle
# level, a muscle ranking or a muscle percentage, and every mechanical claim
# is either a measurement of this model or named coaching.
# What can be cited, and is, in the body cue's why only:
#  - FAIGENBAUM 2018, PMID 29683913, JSCR 32(5):1197-1206. 15 boys, 10.6 plus
#    or minus 1.4 y, a 12.8 m / 4.1 kg training rope, metronome-standardised,
#    a progressive 10-minute protocol of five exercises by two sets of 30 s
#    with 30 s rest, of which EX5 was double-arm slams. Treadmill peaks were
#    VO2 47.4 plus or minus 8.8 mL/kg/min and HR 195.1 plus or minus 6.6 bpm;
#    values rose from EX1 set 1 (10.3 mL/kg/min, 103.2 bpm) to EX5 set 2
#    (30.0 plus or minus 3.9 mL/kg/min, 168.6 plus or minus 11.8 bpm),
#    spanning 21.5 to 64.8% of peak VO2 and 52.9 to 86.4% of peak HR.
#  - RATAMESS 2015a found a battle-rope protocol the most metabolically
#    demanding of thirteen, and Faigenbaum 2018 attributes that to the
#    double-arm slam specifically, explaining it by a substantial lower body
#    contribution.
#  THE CAVEATS TRAVEL WITH THEM, in the same why: the sample is 15 boys of
#  about ten; the exercise order was fixed and progressive, so the slam sat
#  last and carries the cumulative fatigue of the four before it; and NEITHER
#  STUDY MEASURED A MUSCLE - the lower body contribution is the authors'
#  explanation of a metabolic result and is the only published support of any
#  kind for the quadriceps, gastrocnemius and soleus this lift paints bright.
# Everything else is the model: sources_safety.md 3.5 Fault 1 (the arms
# barely bend - the model settles it), Fault 3 (driving the rope into the
# floor or finishing past the knees - contradicted twice over), Fault 4
# (calling the down phase the explosive one - measurably backwards), Fault 5
# (the overhead lean-back, with the correction in open point 9) and Fault 6
# (the shoulder framing fits THIS rope entry and not the waves: hands above
# the shoulder on 96 of 192 frames here against 0 of 192 there).
#
# ======================================================= ROWS
# Rows, ranks, fractions and stabilisers are rows_cond.md section 8.5
# verbatim - 15 rows, 6 primary, which is three more rows than the previous
# all-time maximum and a count only two of 466 shipped blocks reach at
# primary. Four of the fifteen are Push Press's entire table (:22545-22548),
# whose library primaryMuscle string is character-for-character this lift's
# ANT. + LAT. DELTOID. The one value that is not a carry is Rhomboids S 0.30,
# the upperBack secondary floor, which rows_cond.md section 5 argues as the
# family's single estimate. Nothing was re-derived here; rows_cond.md
# section 8's own final.py re-reads that block and re-checks every row
# against level(), part_of(), fraction-descending order, the one-primary
# rule, the quote and backslash ban, lower-case stabilisers and the
# no-gluteus-medius rule, with 0 failures.
#
# ======================================================= OPEN POINTS
# Recorded for the owner, not decided. No string above assumes an answer.
#  1. FIVE CHARACTERS AGAINST A ROPE THROUGH A PILL. The layout above is
#     clean on every test, and the price is the 7-character cap on `Rise up`.
#     The alternative is 0.64 LEADING at 12 characters: +3.0 px clear of the
#     lifter on every frame and the best leaders in the set (only head and
#     forearm_L on the face; hand_L 22.0 px, hand_R 45.5, forearm_R 11.4),
#     but THE ROPE IS INSIDE THAT PILL ON 56 OF 192 FRAMES - 29.2% - and
#     visibly so: v2.py puts on-screen rope in that band on exactly 56
#     frames, clipped u 0.0014..0.4651, against a pill spanning u
#     0.0350..0.2737. A third option, 0.16 leading at 17 characters, buys the
#     empty top band and 17 characters but puts the rope inside the pill on
#     80 of 192 frames and leaves only two usable anchors in all 26 joints
#     (hand_L clear by 3.0 px, hand_R by 15.8). The shipped precedent accepts
#     a load crossing - Box Jump has its box inside a pill on all 384 frames
#     - so this is a taste call about whether a readable label is worth a
#     rope drawn through a callout.
#  2. THE TOP SIXTH OF THE FRAME HAS NO PILL. Rows used are 0.32, 0.48, 0.64
#     and 0.80 twice; nothing sits at 0.16. Row 0.16 has exactly two slots
#     and both fail a hard test: leading puts the rope inside the pill (24 to
#     80 frames, every length) and trailing puts ALL 26 PROBED JOINTS on the
#     face, from foot_L at 32/192 to head at 192/192, because the pill pins
#     at u 0.7409 while the head sits below and left of it for part of every
#     rep. Box Jump rejected its own 0.16 trailing for the same reason. If
#     the owner wants a pill up there it costs one of the two breaches in
#     open point 1.
#  3. FIFTEEN ROWS AND SIX PRIMARIES. rows_cond.md open point 3 carries this
#     in full: following the paint gives 15 rows (a record by 3), and the
#     library's only two three-deltoid blocks (:49427, :49530) demote the
#     lateral and posterior heads to secondary - which SAVES NO ROWS at all,
#     improves the primary legend line to 54 characters and 2 of 4 names, and
#     worsens the secondary line to 174, which would be the longest legend
#     line in the app by 35 characters. There is no paint-honest 12-row
#     version of this lift.
#  4. THE GLUTE ROW CANNOT BE SEEN. At the only pose the stills show there is
#     a 57-row band, y 309..365 = v 0.4718..0.5573, with ZERO painted pixels
#     - the black shorts - and both gluteal joints project inside it (pelvis
#     v 0.5145, thigh_L v 0.5150). The row follows the tier file, which is
#     the rule, and USDZViewport.swift:543 has mixed glute paint into the
#     shorts fabric since 2026-10-28, so this may be a shader question;
#     rows_cond.md open point 13 carries it for five lifts. It is unverified
#     at the bottom of the slam, where the hips fold 42 degrees and the
#     shorts move with them, and nothing in this round may render that pose.
#  5. WHETHER THE COPY SAYS WHERE THE ROPE LANDS. This entry says it - a
#     stride in front of you, in the bottom cue's correct string and in setup
#     step 3 - on the model's own nearest floor contact, z 1.5905 m against a
#     toe frozen at 0.134682, so 1.4559 m clear of the toes. THE COST: it is
#     not visible in the trainer. Row 0.80 carries no on-screen rope on any
#     frame, 100% of the visible rope lies below the render's black floor
#     horizon (v 0.5084) on frames f9 through f16 - 8 frames of every 24 -
#     and the rope's luminance there is 56.6 against the floor's 15.3, so it
#     is a dark shape on a black floor. The alternative is silence, which
#     leaves the word slam unexplained on a lift where the reader needs to
#     know a stride of floor has to be clear.
#  6. WHETHER THE COPY NAMES A TEMPO. The clip is a fixed one slam per
#     1.000 s - 60 a minute - and the app logs the lift in seconds, so that
#     is the rate a reader who matched the model would copy. Setup step 4
#     tells the reader to choose a rate they can hold and does NOT name the
#     figure: that is sources_safety.md open point 7 Option A, and it matches
#     the jump family, which named no tempo on any of its four entries.
#     Naming 60 a minute would match the model exactly and would be the first
#     tempo figure in the family; the library has never badged pace in 466
#     blocks, so a badge is not available either way.
#  7. THE FIFTH CUE IS `drive` AND NOT `stance`. This entry has no
#     start-position cue. Precedent: two of the four jump entries shipped
#     twelve hours ago (Squat Jump, Jump Rope) have none either, and the
#     stance facts are all in the setup steps, which the reader sees on the
#     same ungated screen. If the owner wants one, the only slot it could
#     take is the 7-character one, where the best honest label is Stance (6)
#     or Feet set (8, one over the ceiling) - and it would displace the
#     reload, which is the phase holding the clip's fastest motion.
#  8. THE BADGE IS A REUSE, NOT A NEW WORD. ARMS ONLY has 2 shipped uses
#     (:12094 russianTwist, :41785 toeTouchCrunch) and fits exactly; this
#     entry makes it the third. PULLING WITH THE ARMS (4 uses: :12190,
#     :25952, :42238, :44454) was rejected because this is a push-down, not a
#     pull. library_cond.md 2.3 and sources_safety.md open point 8 require a
#     NEW badge for anything equipment-specific in this family, because
#     SQUATTING THE ROPE (:46981) is a cable pull-through, SLED SINKING
#     (:33277) a leg-press carriage and BALL KEPT HIGH (:44644) a Russian
#     twist - but this lift's fault is not equipment-specific, so it needs no
#     new word. LEANING BACK was also considered and rejected: it is already
#     the joint most-used badge at 16, and the lean-back here is only 4.9191
#     degrees with the lumbar chain moving 3.000 degrees across the whole
#     clip, so it would badge something barely visible.
#  9. A CORRECTION TO measure_BattleRopeSlams.md, re-verified here.
#     Section 4.5 of that report says the overhead lean-back happens 240
#     times in the clip's eight reps. IT DOES NOT REPRODUCE and is wrong by a
#     factor of 30 (sources_safety.md PART 4 item 1 found this first; v1.py
#     confirms it independently). trunk is below vertical on 48 of 192
#     frames in 9 runs - f0-f3, f22-f27, f46-f51, f70-f75, f94-f99,
#     f118-f123, f142-f147, f166-f171, f190-f191, the ninth being the clip
#     wrapping into the first - so EIGHT lean-backs, one per rep, 6 frames
#     each; and trunk is at the full -4.919118 degrees on 24 of 192 frames,
#     3 per rep (f0, f1, f23 and their repeats). The report's own frame table
#     is right; only its summary sentence is wrong. The top cue's why quotes
#     the corrected figures.
# 10. TWO SMALL FIGURES THAT DID NOT REPRODUCE EXACTLY, neither of which
#     changes anything here. measure_BattleRopeSlams.md section 6 gives the
#     lifter's on-screen width as 111.4 px at f0 and 234.8 px at f18, where
#     v1.py reads the same silhouette as 108.0 px minimum and 236.1 px
#     maximum; and it gives the drawn crown as 40.9 to 42.2 px above the head
#     joint, mean 41.4, where v3.py reads 40.4 to 41.7, mean 40.9. Both are
#     differences in which rows are counted and where a row's centre is
#     taken. This entry quotes neither width, and no leader figure depends on
#     the crown offset, because every leader was tested against the head's
#     own silhouette row by row rather than against any offset box.
#     Recorded so a future reviewer does not think they were missed.
# 11. TEN GLOWS WOULD BE THE MOST IN ANY ENTRY. Counted over all 380 ex()
#     blocks in the spec files, the current maximum is 8, on Barbell Clean
#     and Jerk's 9 rows. Thirty painted meshes fall into eleven MusclePart
#     groups here, and the shipped habit splits: the jump family that shipped
#     twelve hours ago is strictly one glow per row (6/6, 6/6, 5/5, 4/4),
#     while the big jerk tables collapse to one per painted REGION - Dumbbell
#     Clean and Press has 12 rows and 6 glows, Kettlebell Clean and Press 10
#     and 5. The ten below are the region rule plus two collapses the geometry
#     forced, both recorded in the glow comment: the Rotator Cuff row rides
#     inside the two shoulder-cap glows (it files under rearDelts with
#     Posterior Deltoid, so it adds no chip to TARGET MUSCLES either), and the
#     dim arm paint gets ONE ellipse rather than one per arm because at the
#     probed pose the left arm projects behind the drawn head. Collapsing
#     further, to the jerk family's five or six, would leave painted regions
#     unmarked; one glow per row would be fifteen.
# 12. FOURTEEN OF THE FIFTEEN ROWS REST ON PAINT PLUS A LIBRARY CARRY WITH NO
#     MEASUREMENT BEHIND THEM, and the fifteenth is an estimate. This lift
#     carries ten bright meshes on zero muscle measurements
#     (sources_cond.md 8.3). The copy reflects that: no cue claims a level, a
#     ranking or a percentage for any muscle, and the only citations in the
#     entry are metabolic.
# 13. THE RELOAD IS MEASURABLY FASTER THAN THE SLAM AND drive.correct SAYS AS
#     QUICK AS. Re-measured on hand_R over the first rep: the descent is f0..f13,
#     13 INTERVALS, with a peak 3-D wrist speed of 5.523 m/s; the ascent is
#     f13..f24, 11 INTERVALS, peak 6.069 m/s. The rise is the faster half on both
#     measures. OPTION A (taken): leave this half is as quick as the slam itself,
#     not a recovery. It is conservative rather than wrong, it carries the whole
#     point of the cue - the reload is not a rest - and it does not invite a
#     beginner to race a rope that is largely riding its own momentum back up.
#     OPTION B: quicker than the slam itself, which is true and one character
#     shorter. Recorded because the coaching review offered B as an optional
#     sharpening; its figures (6.083 up against 5.509 down, 11 intervals against
#     12) did not reproduce exactly here, while the DIRECTION reproduces on both
#     measures.
ex(name="Battle Rope Slams", var="battleRopeSlams",
   overrides={"top": (0.32, "trailing"), "body": (0.86, "leading"),
              "elbow": (0.50, "trailing"), "bottom": (0.86, "trailing"),
              "drive": (0.68, "trailing")},
   annotations=[
       ("top", "Reach up", "upper_arm_R"),
       ("body", "Whole body, not the arms", "pelvis"),
       ("elbow", "Arms long", "forearm_R"),
       ("bottom", "Stop at hip", "hand_R"),
       ("drive", "Rise up", "patella_R"),
   ],
   cues={
       "top": ("Overhead Start",
               "Every rep starts at the top, with both hands above your shoulders, the arms long and a little wider than your shoulders.",
               "This is the half of the lift that separates the two rope entries, and it is measured. The hands are above the shoulder joint on 96 of 192 frames - exactly 50.0%, 12 frames in every rep - against 0 of 192 frames on Battle Rope Alternating Waves, where they never come above the shoulder at all. The upper arm sweeps 18.9017 to 153.3511 degrees from straight down, a range of 134.4494 degrees. The hands stay outside the shoulders the whole time: handgap runs 0.514571 to 0.555250 m against a shouldergap frozen at 0.392155 m for all 192 frames, so 131.2% to 141.6% of the shoulder span, and the gap is widest at the top. Underneath them the knee is at 173.2675 degrees, which is this rig's near-straight, so every flexion figure in this entry is measured from 173.27 and not from 180. The top is the only genuinely still moment in the clip: one interval per rep is frozen to better than 0.001 mm, which is 0.0417 s of interval time, and the rope is still moving through it - its largest centroid step on those eight intervals is 34.150665 mm. The model also leans back a little at the top, and this entry does not ask you to. Re-measured, because the measure report overstates it thirtyfold: trunk is behind vertical on 48 of 192 frames - eight lean-backs, one per rep, six frames each, which a run scan prints as nine runs only because the first one is split across the loop seam - and it reaches its full -4.919118 degrees on 24 of 192 frames, 3 per rep. Four point nine degrees is not an arch, and the whole lumbar chain moves 3.000 degrees across the clip, so there is nothing here to copy and nothing worth badging. No study has measured a rope slam, so nothing in this cue is a claim about muscles.",
               "Pushing the hips forward and arching the back to get the hands higher, or letting them stop at chest height so the rope never has anywhere to fall from.",
               "Take both hands up above your shoulders, elbows long and hands a little wider than your shoulders, with your ribs down so the reach comes from your shoulders, not from arching your back."),
       "body": ("The Slam",
                "The rope goes down because your whole body goes down - you sit and fold as the hands come through.",
                "Over the descent, f1 to f13, which is 13 frames and 12 intervals = 0.5000 s, the knee goes 173.2675 to 114.1130 (59.1545 degrees), the hip 169.2028 to 118.0121 (51.1907 degrees over the descent; 51.9597 clip-wide, because the hip actually peaks at 169.9718 on the way UP at f22, two frames short of the top), and the trunk swings from 4.9191 degrees behind vertical to 37.3313 degrees forward - a 42.2505 degree swing. The pelvis drops 18.103 cm, the head 31.266 cm and the wrist 1.252535 m. THE KNEE AND THE HIP MOVE WITHIN 8 DEGREES OF EACH OTHER, so this model is neither a hinge nor a squat but both at once, which is why no cue here tells you to sit or to hinge instead of the other. Against all of that the elbow moves 14.6279 degrees in the entire clip. The fastest single interval of the descent is f6 to f7 at 5.509 m/s at the wrist. There is no EMG study of a rope slam anywhere, so nothing in this entry says which muscle does the work; what is published is metabolic. Faigenbaum 2018 (PMID 29683913, JSCR 32(5):1197-1206) put 15 boys, 10.6 plus or minus 1.4 years old, through a 10-minute progressive protocol of five rope exercises using a 12.8 m, 4.1 kg rope, 2 sets of 30 s each with 30 s rest, and double-arm slams were the fifth: values rose from 10.3 mL/kg/min and 103.2 bpm on the first set of the first exercise to 30.0 plus or minus 3.9 mL/kg/min and 168.6 plus or minus 11.8 bpm on the second set of the slams, which is 64.8% of treadmill peak VO2 and 86.4% of peak heart rate. Ratamess 2015a found a battle-rope protocol the most metabolically demanding of thirteen, and Faigenbaum attributes that to the slam in particular, explaining it by a substantial lower body contribution. Read both carefully: the sample is fifteen ten-year-old boys, the exercise order was fixed and progressive so the slam sat last and carries the fatigue of the four before it, and neither study measured a single muscle - the lower body contribution is the authors' explanation of a metabolic result, not a measurement of anything.",
                "Standing upright and swinging only the arms, so the rope is thrown rather than driven and the legs never load.",
                "Slam with both hands together, bending your knees and folding at your hips by about the same amount as the hands come down, and let the rope follow your body rather than trying to throw it with your arms."),
       "elbow": ("Arms Stay Long",
                 "Your arms only hold the rope - they do not bend to drive it down.",
                 "The model settles this one. The left elbow runs 141.8884 to 156.5163 degrees, a range of 14.6279, and the right 141.2888 to 156.8816, a range of 15.5928; the wrist sits 0.5083 to 0.5265 m from the shoulder against a fully extended 0.2879 + 0.2498 = 0.5377 m, so the whole reach varies by 18.1 mm over the clip. That is a straight-arm pendulum from the shoulder, and it straightens the way a reader would not guess: THE ELBOW IS STRAIGHTEST AT THE BOTTOM, 156.5163 degrees at f10, AND MOST BENT AT THE TOP, 141.8884 at f23. So a cue asking for a bend at the bottom, or for the elbows to chop the rope down, would contradict the animation as well as the mechanics. The grip never changes either: the nearest rope segment to the right wrist is a constant 0.1136 m away on all 192 frames and to the left wrist 0.1111 m, both to four decimal places, because the handles are parented 11 cm beyond the wrist joint. And both arms do the same thing - the two elbows differ by at most 4.7841 degrees, at f8, and mirroring the left hand onto the right leaves 18.4811 mm, also at f8 - so this is a double-arm slam with no lead side and nothing alternating. No study has measured any of this.",
                 "Bending the elbows to chop the rope down, which turns a whole-body slam into a small triceps push.",
                 "Keep your elbows long the whole way and let your arms hang heavy from your shoulders - if anything they straighten as the rope goes down, and they should never pull it."),
       "bottom": ("Where It Finishes",
                  "The hands stop around hip height with your knees and hips still bent, and the rope goes down out in front of you.",
                  "The lowest the wrist gets is 0.692912 m, which is 6.69 cm BELOW the pelvis joint at that instant (0.7598) and 23.34 cm ABOVE the kneecap (patella_L 0.4595). THE SLAM FINISHES AT HIP HEIGHT - not at the shins and not at the floor - so nothing in this entry says drive it into the ground or finish past your knees. At that moment the knee is at 114.1130 degrees, the hip at 118.0121 and the trunk 37.3313 degrees forward, all three at their clip extremes. The bottom is also not a hold a reader could time: the lower body is identical to within 1e-4 at f11, f12 and f13 - 3 frames, 2 intervals, 0.0833 s - while the wrist keeps sinking 5.33 mm and then 1.88 mm, so the pose bottoms at f11 and the hands at f13. Where the rope goes is measured too, and it is further out than most readers expect. Some part of the rope is on the floor on every one of the 192 frames, 6 to 19 segments per rope at any moment, and the nearest it ever touches down is z 1.5905 m at f10 against a toe frozen at z 0.134682 - 1.4559 m clear of the toes, about a stride - from where it lies on the floor out to 6.02 m. One honest warning about the picture: nothing visibly strikes the ground in this clip, row 0.80 of the frame carries no on-screen rope at all, and on frames f9 through f16, 8 frames of every 24, the whole visible rope is below the render's black floor horizon at v 0.5084. The strike the lift is named for is real, but you will not see it here.",
                  "Driving the hands down past the knees toward the floor, so the hips keep folding after the rope has already gone.",
                  "Finish with your hands about hip height and your knees and hips still bent, driving the rope down and away from you rather than straight down at your own feet."),
       "drive": ("The Reload",
                 "Standing back up is half the work: the rope only gets overhead again because your legs push the floor away.",
                 "This is the half readers treat as a rest, and in this clip it is the faster one. The ascent, f13 to f24, is 12 frames and 11 intervals = 0.4583 s, against the descent's 13 frames and 12 intervals = 0.5000 s, so THE WAY UP IS ONE INTERVAL SHORTER. Peak 3-D wrist speed is 6.083 m/s going up, at f20 to f21, against 5.509 m/s coming down; the means are 3.348 against 3.094 m/s. The clip's single largest per-frame joint step, 253.4732 mm, is the wrist on the way UP, and it happens eight times, once per rep. Only the VERTICAL component is faster coming down, 5.462 against 5.008 m/s, which is the whole of the usual claim that a slam is explosive downwards. Underneath it the knee opens 114.1130 to 173.2675 degrees and the hip 118.0121 to 169.9718, peaking at f22, two frames before the top, while the forefoot never moves at all - toe_L travels 0.0277 mm in total over 192 frames, toe_R 0.0234 mm, and the heel lifts 4.0150 cm at the top of each rep. So the push comes out of a planted foot. The pace this adds up to is one slam per 1.000 s, eight identical reps in 7.958 s, and the app logs this lift in seconds rather than reps - which is a property of the clip and not a recommendation, and is why the rate is left to you in the setup steps.",
                 "Treating the way up as a rest, so the rope goes slack and the next slam starts from nothing.",
                 "Push the floor away and stand back up tall, letting the rope ride back up overhead - this half is as quick as the slam itself, not a recovery."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.80), ("Gastrocnemius", P, HI, 0.78),
               ("Quadriceps", P, MOD, 0.62), ("Soleus", P, MOD, 0.60),
               ("Lateral Deltoid", P, MOD, 0.56), ("Posterior Deltoid", P, LOW, 0.30),
               ("Triceps Brachii", S, MOD, 0.58), ("Erector Spinae", S, MOD, 0.55),
               ("Obliques", S, MOD, 0.52), ("Rotator Cuff", S, MOD, 0.50),
               ("Rectus Abdominis", S, MOD, 0.40), ("Trapezius", S, LOW, 0.36),
               ("Biceps Brachii", S, LOW, 0.30), ("Gluteus Maximus", S, LOW, 0.30),
               ("Rhomboids", S, LOW, 0.30)],
   stabilisers=["forearms", "latissimus dorsi", "hamstrings"],
   comparison=("ARMS ONLY", "Hips and knees drive the rope down",
               "Arms swing, legs and trunk still",
               "In the model the knee moves 59.1545 degrees, the hip 51.1907 and the trunk 42.2505 while the elbow moves 14.6279, and the elbow is straightest at the bottom of the slam rather than bent - so the rope is driven by the body and only held by the arms.",
               "ARMS ONLY has two shipped uses and this is the third; it is not an equipment word, so unlike this family's sled and ball faults it needed no new badge. Nobody has measured a rope slam, so this names a mechanical fault the model settles and makes no claim about which muscle works or about any injury rate."),
   # ONE glow() PER PAINTED REGION, in activation-row order as far as a
   # region set allows, each written out in full with no shared helper. Every
   # joint named is one of the 41 probed for this lift in joints.json. The
   # five BRIGHT regions get A and the five DIM ones SOFT: here A against
   # SOFT is the PAINT TIER and nothing else - not depth, not a side - because
   # no painted name on this model carries an _L/_R or (L)/(R) suffix and the
   # joints are symmetrical to 0.2667 degrees at the knee and 4.7841 at the
   # elbow. The two shoulder-cap glows carry rows 1, 5 and 6 (the three
   # bright deltoid heads) AND the dim Rotator Cuff row, which has no region
   # of its own: its four meshes sit under the same cap, it files under
   # rearDelts with Posterior Deltoid, and it adds no chip to TARGET MUSCLES.
   # THE GEOMETRY IS ALL AT THE TOP-OF-SLAM POSE, because all eight of
   # joints.json's probed moments are that pose (trap 3 in the header), so
   # these are static placements and not phase means - and at that pose the
   # arms are overhead, beside the head, which constrains four of the ten.
   # The head's OWN silhouette at f0 spans v 0.2145..0.2878 and u
   # 0.6225..0.7458 (u 0.6472..0.7284 at v 0.278), so:
   #  - the dim arm paint gets ONE ellipse, on the right arm. The left arm's
   #    probed mean is (0.711, 0.278), which is INSIDE the head's own u range
   #    at that row, so a second ellipse there would be drawn over the face.
   #    That is a projection fact at one pose, not a claim that one arm works
   #    harder; the paint is two-sided and open point 11 records the cost.
   #  - the right-arm ellipse is nudged dx -0.035 to (0.580, 0.300), spanning
   #    u 0.530..0.630 against the arm's own 0.592..0.637, which still leaves
   #    a 2.9 px sliver (u 0.6225..0.630) inside the head's lowest rows. That
   #    is the smallest breach available without sliding the ellipse off the
   #    limb it marks.
   #  - both shoulder caps and the upper-back glow are nudged DOWN (dy +0.012,
   #    +0.010, +0.030) so their top edges clear v 0.2878, the head's lowest
   #    drawn row, instead of grazing the jaw.
   # The ten centres are all distinct: delt cap L (0.712, 0.339), delt cap R
   # (0.637, 0.350), gastrocnemius (0.631, 0.686), quads (0.634, 0.587),
   # soleus (0.635, 0.750), upper arm (0.580, 0.300), erector spinae
   # (0.662, 0.456), abs (0.583, 0.396), trapezius and rhomboids
   # (0.683, 0.352), glutes (0.648, 0.515). The trunk ellipses do overlap one
   # another, which is honest: the obliques, the rectus abdominis and the
   # erectors are painted around the same stretch of trunk, and the glute
   # paint sits in the band the stills show as empty (open point 4).
   glows=[glow("Battle Rope Slams", ["deltoid_arc_clavicle_2_L", "deltoid_arc_scapula_2_L"],
               A, 0.55, rx=0.075, ry=0.05, dy=0.012),
          glow("Battle Rope Slams", ["deltoid_arc_clavicle_2_R", "deltoid_arc_scapula_2_R"],
               A, 0.55, rx=0.075, ry=0.05, dy=0.01),
          glow("Battle Rope Slams", ["shin_L", "shin_R"], A, 0.50, rx=0.085, ry=0.05,
               dy=0.02),
          glow("Battle Rope Slams", ["thigh_L", "patella_L", "thigh_R", "patella_R"],
               A, 0.48, rx=0.10, ry=0.07),
          glow("Battle Rope Slams", ["shin_L", "foot_L", "shin_R", "foot_R"], A, 0.45,
               rx=0.08, ry=0.05, dy=0.015),
          glow("Battle Rope Slams", ["upper_arm_R", "forearm_R"], SOFT, 0.30, rx=0.05,
               ry=0.065, dx=-0.035),
          glow("Battle Rope Slams", ["spine"], SOFT, 0.28, rx=0.065, ry=0.055, dy=-0.02),
          glow("Battle Rope Slams", ["support_PectoralisMajor_Abdominal_L",
                                     "support_PectoralisMajor_Abdominal_R"],
               SOFT, 0.28, rx=0.07, ry=0.06),
          glow("Battle Rope Slams", ["attachment_TrapeziusUpper_L",
                                     "attachment_TrapeziusUpper_R"],
               SOFT, 0.26, rx=0.085, ry=0.045, dy=0.03),
          glow("Battle Rope Slams", ["pelvis"], SOFT, 0.24, rx=0.08, ry=0.05)])

# The setup steps and each cue's `correct` string are the only coaching this
# lift shows outside the gated trainer, so the four things the name does not
# give are all here or in a correct string: that the rope is doubled round an
# anchor with an end in each hand (step 1), the stance and grip that the
# model holds unchanged for all 192 frames (step 2), that the rope lands a
# stride out and that the forefoot stays down (step 3, and open point 5), and
# that the lift is TIMED rather than counted so the rate is the reader's
# choice (step 4, and open point 6). No step leans on a figure the reader has
# not been given, and no step names the model's own 60 slams a minute.
# Lengths are 119, 123, 123 and 127 characters against a shipped median of 61
# and a p90 of 96 and p99 of 140 - all four are inside p99, which the jump family that
# shipped twelve hours ago could not say of 9 of its 18 steps.
# The five correct strings run 142, 168, 183, 189 and 204 characters. Over
# 1,513 shipped correct strings the median is 104 and p90 is 140, so these
# are long by the whole library - but the jump family's twenty run 120 to 280
# with a median of 187, so they are ordinary by the freshest precedent. They
# are the only place a reader meets the four facts above, which is why the
# fresh convention was followed rather than the old median.
SETUP["Battle Rope Slams"] = [
    "Loop a battle rope around a post and walk back with an end in each hand until only a little slack is left on the floor.",
    "Stand with your feet about shoulder-width apart and your knees soft, holding an end in each hand with your palms facing in.",
    "Leave two clear strides of floor in front of you for the rope to run out, and keep your toes planted for the whole set.",
    "This lift is timed rather than counted, so pick a rate you can hold to the end of the interval instead of going flat out early.",
]
# ------------------------------------------------------- medicine ball chest pass
# Chest/MedicineBallChestPass, resource MedicineBallChestPass, yaw -1.3 rad
# (-74.48 degrees), zoom 0.889, offset [0.027, 0.053, -0.098], viewport
# 382 x 655. The framing is the app's own: SampleData.swift:3041 carries exactly
# those three numbers and jobs.py copies them. SampleData.swift names the lift at
# only two lines - 1283 (the Exercise row: PECTORALIS MAJOR / MEDICINE BALL /
# beginner, under the comment that the Desktop 401-500 folder shipped 494 as
# models only, no trainer content yet) and 3041 (the ExerciseModel) - so there is
# no ExerciseContent today and the trainer gates the lift. A third mention sits
# outside SampleData: ChestPaint.swift:97 already marks all three pec regions
# primary on the 2D chest map, which is why the rows below split the chest three
# ways.
# NO library= tuple is passed. The shipped row is already PECTORALIS MAJOR /
# MEDICINE BALL / beginner, and MEDICINE BALL is not in common_1_50.EQUIPMENT
# {BARBELL, DUMBBELL, EZ BAR, CABLE, MACHINE}, so passing it would fail
# validate_library() while changing nothing.
# This lift is REP-BASED, not timed. ExerciseCatalog.swift:140-147 does not list
# it in timedExercises and isBodyweight() tests MEDICINE BALL against a list it
# is not in, so the set logs as reps with a live weight field. No setup step
# below ends in the timed family's for the set time phrase.
#
# Everything is read from measure_MedicineBallChestPass.md (which reads
# MedicineBallChestPass_A.json / _SIL.npz / _HEAD.npz / tiers_cond.json and the
# eight stills), from rows_cond.md section 8.6 for the table, and from
# sources_cond.md section 7 / sources_safety.md section 3.6 for the claims. The
# label geometry was RE-MEASURED for this entry by room.py, lead.py and
# d_MedicineBallChestPass/ck.py and every figure in the LABEL GEOMETRY block is
# from those three runs, not copied.
#
# WHAT THE MODEL IS. 192 frames at 24 fps; times[0] = 0.0, times[191] = 7.958333,
# so the SPAN is 7.958 s (191 intervals) and the LOOP PERIOD is 8.000 s (192
# intervals). Frame f = round(t * 24). A window written f<a>..f<b> is INCLUSIVE
# and its frame count is b - a + 1; where a figure below is a count of frame
# INTERVALS it says so.
# FOUR BIT-IDENTICAL REPS of 48 frames = 2.000 s. A CIRCULAR lag sweep (frame i
# against frame (i + k) mod 192, Euclidean per-joint distance, max over all 26
# probed joints and all 192 frames) gives 0.000554 mm at lag 48, 96 and 144
# against 125.7792 mm at lag 47 and 49. Frame 191 IS frame 0, to 0.000000 mm.
# THE HALF-PERIOD LAG IS NOT A SECOND PERIOD: lag 24 is 410.4228 mm, which is
# 97.0% of the worst lag in the entire sweep (423.2890 mm), so nothing here may
# be described as a half-cycle or an alternating pattern.
# A FROZEN HOLD, both ways of counting, found with a 0.001 mm tolerance (1e-9
# finds nothing): consecutive frames agree to better than 0.001 mm over the steps
# f40 -> f48, and J[0] = J[40] = J[48] to 0.000000 mm, so the hold wraps the rep
# boundary. By FRAMES, 36 of 192 (18.75%) belong to a frozen pose. By INTERVALS,
# 32 of 192 circular intervals = 1.3333 s are held still, 16.67% of the 8.000 s
# period. Per rep the hold is 9 frames (f40..f48) and 8 intervals (0.3333 s).
# PERFECTLY SYMMETRIC. elbow_L - elbow_R never exceeds 0.000230 degrees,
# knee_L - knee_R stays inside 0.021, hip_L - hip_R inside 0.204; hand_*,
# forearm_*, upper_arm_* and clavicle_* mirror to 1e-6 m on every axis; pelvis,
# spine, chest, neck and head sit at x = 0.00000000 at every frame. There is no
# lead side and no rotation, so NO CUE NAMES A SIDE.
#
# THE PHASES, scanned frame by frame rather than read off a trace. Reps 2-4
# repeat all of it at +2.000 / +4.000 / +6.000 s.
#   1 Dip            f0..f5    6 frames  0.2500 s  knee 139.90 -> 129.38,
#                                                  hip 162.09 -> 155.52,
#                                                  trunk +7.58 -> +9.58
#   2 Drive          f6..f11   6 frames  0.2500 s  elbow 59.87 -> 160.00, i.e.
#                                                  100.13 degrees in 5 INTERVALS
#                                                  (0.2083 s); hand_L.z 0.2840 ->
#                                                  0.6691 (+38.5 cm); handgap
#                                                  0.2326 -> 0.1356 m at f10;
#                                                  heels leave at f9
#   3 Release        f11 -> f12   1 interval  0.4583 -> 0.5000 s
#   4 Ball out       f12..f17  6 frames  0.2500 s  exact ballistics (below)
#   5 Turnaround     f17 -> f18   1 interval  ball z peaks at 2.4000 and reverses
#   6 Ball back      f18..f25  8 frames  0.3333 s  handgap 0.3178 m at f18, the
#                                                  clip maximum, then closes
#   7 Catch          f25 -> f26   1 interval  1.0417 -> 1.0833 s
#   8 Absorb         f26..f32  7 frames  0.2917 s  elbow 142.00 -> 61.64, i.e.
#                                                  80.36 degrees in 6 INTERVALS
#                                                  (0.2500 s)
#   9 Settle         f33..f39  7 frames  0.2917 s
#  10 Hold           f40..f48  9 FRAMES, 8 INTERVALS = 0.3333 s, bit-frozen
# Arithmetic check on the two windows that are easy to get wrong: f12..f25 is 14
# FRAMES (25 - 12 + 1) = 0.5833 s, while the SPAN t 0.5000 to t 1.0417 is 13
# intervals = 0.5417 s; f40..f48 is 9 FRAMES = 0.3750 s, while the held interval
# count is 8 = 0.3333 s.
#
# ANGLE RANGES over the whole clip. elbow_L 59.8680 (t 0.250) to 167.9999
# (t 0.750), range 108.1319. knee_L 129.3762 (1.333) to 144.4630 (0.750), range
# 15.0868. hip_L 155.5226 (0.208) to 162.9079 (0.833), range 7.3854. trunk
# 6.5793 (1.333) to 13.5793 (0.500), range 7.0000037 over only 40 DISTINCT VALUES
# with a flat plateau at 9.5793 across f5..f8 - a hand-keyed channel. handgap
# 0.1356 m (0.417) to 0.3178 m (0.750). anklegap 0.3200 to 0.3238 m, range
# 0.0038. shouldergap 0.3922 m with a range of 0.0000004 m. The elbow maximum is
# 167.99985, a key set at 168 degrees and not a solver clamp, so NOTHING BELOW
# SAYS THE ARM STRAIGHTENS.
#
# THE LOAD. eq_names is ["Sphere", "Cube"], 418 projected points per frame;
# indices 0..361 are the Sphere (362 points) and 362..417 the Cube (56 points),
# split by which projected points have zero variance across frames.
#  - The SPHERE is the medicine ball: 0.300 m on every axis at every frame, a
#    sphere of radius 0.150 m, 30 cm across. Centroid x is 0.000000 at every
#    frame; y 1.2303 (f5) to 1.4492 (f21); z 0.4122 (f32) to 2.4000 (f17). Travel
#    per axis x 0.000000, y 0.218876, z 1.987815 m. Centroid path length
#    16.437447 m over the clip, 4.109362 m per rep.
#  - The CUBE is a wall slab and IT IS NEVER ON SCREEN. bbox every frame x
#    -0.500..+0.500, y -0.000..+1.900, z 2.600..2.700, i.e. 1.000 x 1.900 x
#    0.100 m standing on the floor 2.4647 m in front of the toe. Zero travel on
#    every axis. On screen it draws at u -1.6831..-1.2701, v -0.1519..0.9643, and
#    0 OF 10 752 POINT-FRAMES (56 points x 192 frames) ARE INSIDE THE VISIBLE
#    FRAME. The round brief's chest-pass figure u -1.683 is this slab's left edge;
#    the ball's own raw minimum is u -1.3558.
#  - HELD, NOT SCENERY. On every contact frame each wrist is exactly 0.1881 m
#    from the ball centre, i.e. 0.0381 m (3.81 cm) outside its surface, to better
#    than 0.2 mm, and neither hand is ever inside the ball. Held f0..f11 and
#    f26..f47 = 34 frames per rep (1.4167 s, 70.8% of the rep); free flight
#    f12..f25 = 14 frames (0.5833 s), the gap between the last and the first held
#    frame being 15 intervals = 0.6250 s.
#  - RELEASE between f11 and f12 at (0.000, 1.102, 6.230) m/s, speed 6.326 m/s,
#    10.0 degrees above horizontal. The OUTBOUND leg f12..f17 is exact
#    ballistics: dz is +0.25957 m on every one of the five steps and the second
#    difference of y is -0.01703 m per frame squared on every step
#    = -9.810 m/s squared. The RETURN leg f18..f26 IS NOT free flight - its
#    horizontal speed GROWS from 0.17986 to 0.18963 m per frame (+5.4%) and its
#    vertical acceleration drifts from -9.497 to -10.184 m/s squared. CATCH
#    between f25 and f26 at (0.000, -1.697, -4.551) m/s, speed 4.857 m/s, i.e.
#    73.06% of the outgoing horizontal speed.
#  - THE BALL ON SCREEN, CLIPPED TO THE VISIBLE FRAME (0 <= u <= 1, 0 <= v <= 1)
#    and said to be clipped: raw u -1.3558..0.5424 becomes CLIPPED
#    u 0.0003..0.5424, and raw v 0.1185..0.3751 becomes CLIPPED v 0.1869..0.3751.
#    Of the Sphere's 69 504 point-frames, 50 616 (72.8%) are inside the visible
#    frame; counted over BOTH meshes the same 50 616 is 63.1% of 80 256, because
#    the Cube contributes 0 - the two shares are the same numerator over different
#    denominators and neither is wrong (ck.py prints 63.1%, the measure report
#    72.8%). THE BALL IS ENTIRELY OFF FRAME FOR 11 FRAMES OF EVERY REP, f13..f23
#    (t 0.5417-0.9583 in rep 1), 11 frames = 0.4583 s, so 44 of 192 frames, 22.9%
#    of the clip. Held, it sits at u 0.3156..0.5371, v 0.2238..0.3537 - a disc of
#    radius 42.6 px centred at (162.9, 189.3) px, in front of the chest and below
#    the chin.
#
# WHAT THE ANIMATION DOES THAT A LIFTER MUST NOT COPY, and which therefore
# constrains every public string below:
#  1 THE BALL NEVER TOUCHES THE WALL AND THE WALL IS NEVER ON SCREEN. The ball's
#    leading face reaches z 2.5500 at f17; the slab's front face is at z 2.6000;
#    the per-frame minimum gap is 0.050000 m, checked twice, so the ball turns
#    round 5.00 CM SHORT of the slab, and only 4 frames of the clip (f17, f65,
#    f113, f161) put it within 10 cm. So no public string describes a wall, a
#    rebounder, a partner, a bounce or a target AS SOMETHING THE PICTURE SHOWS -
#    and yet the lifter cannot do the exercise without one, which is why the
#    target lives in setup step 1 and the honest caveat in setup step 5.
#  2 THE RETURN IS NOT A BOUNCE. It arrives at the turn falling at 0.943 m/s and
#    leaves it RISING at 1.559 m/s, and its apex coming back is 1.4492 m at
#    z 1.6763 against 1.3547 m at z 1.6213 going out - 9.45 cm HIGHER, checked
#    both ways - while carrying only 73.06% of its outgoing horizontal speed. No
#    wall does that.
#  3 THE ELBOW NEVER STRAIGHTENS AND IT FINISHES OPENING LONG AFTER THE BALL HAS
#    GONE. Maximum 167.99985 at f18; at release (f11) it is 160.00 and it then
#    FLEXES to 158.47 at f13 before re-extending. f18 is 6 frames (0.2500 s)
#    after the first free-flight frame f12 and 7 frames (0.2917 s) after the last
#    held frame f11 - it coincides with the ball's turnaround, not the throw. What
#    opens at f18 is the hands going APART (handgap 0.3178 m, the clip maximum)
#    while hand_L.z has moved BACKWARDS from 0.6766 at f12 to 0.6523, a change of
#    -0.0243 m. So finish long, fingers chasing the ball is contradicted, and the
#    torso cue says the real mechanic instead of coaching around the artefact.
#  4 THERE IS ALMOST NO LEG OR TRUNK IN IT. knee 15.0868 degrees, hip 7.3854,
#    trunk 7.0000037, anklegap 3.8 mm, shouldergap 0.4 micrometres. No triple
#    extension, no hip drive, no weight shift. Nothing below says drive through
#    the floor or finish with the hips.
#  5 THE FEET NEVER MOVE AT ALL. toe_L and toe_R are frozen on all three axes for
#    all 192 frames, ranges of 0.000000 m to seven decimals. The heels rise
#    1.43 cm at most, on f9..f17 = 9 frames = 0.3750 s per rep, peaking at f12.
#  6 THE STANCE IS NARROWER THAN THE SHOULDERS AND NEVER CHANGES. anklegap
#    0.3200 m against shouldergap 0.3922 m = 81.6% of shoulder width. A setup step
#    saying feet shoulder-width would be 8 cm wider than the model, so step 3 says
#    a little inside shoulder width.
#  7 THE HANDS SQUEEZE IN, NOT OUT. handgap falls to 0.1356 m at f10, so at
#    maximum drive the two wrists are 13.6 cm apart behind a 30 cm ball, with the
#    ball centre 17.5 cm in front of and 1.7 cm above the hand midpoint. The ball
#    is pushed from behind and never gripped on its sides. This is what makes
#    ELBOWS FLARED the honest badge (see the comparison block).
#  8 THE DEEPEST ELBOW OF THE REP IS THE WIND-UP, NOT THE CATCH: 59.87 at f6
#    against 61.64 at f32. The knee is flat either way - 129.376188 at f32 against
#    129.376190 at f5, two millionths of a degree, which is nothing. Sink into
#    the catch is therefore NOT asked for anywhere below and is not dressed up as
#    a number.
#  9 18.75% of the frames are a frozen pose and all four reps are bit-identical,
#    so NO CUE DESCRIBES A TEMPO, A COUNT OR A DIFFERENCE BETWEEN REPS.
# 10 THE TRAINER'S OWN EIGHT STILLS COLLAPSE TO TWO POSES. t1 = t3 = t5 = t7 are
#    bit-identical (0 of 250 210 pixels differ); t2 = t4 = t6 are bit-identical
#    and t0 differs from them in 30 of 250 210 pixels with a maximum channel delta
#    of 2, i.e. render noise. The even stills are f0 (the hold) and the odd ones
#    f24 (the ball coming back). NEITHER SHOWS THE RELEASE, THE FLIGHT, THE
#    TURNAROUND OR THE CATCH, so no cue leans on a position the reader can check
#    in the strip. The same collapse hits joints.json: its eight probes take at
#    most five distinct values per joint, four of them clustered on the f23/f24
#    pose, which is why the glows below avoid hand_* and forearm_* (screen paths
#    2.3-2.6 of frame width) and sit on joints whose own travel is 0.4-0.8.
#
# THE PAINT (tiers_cond.json, key Chest/MedicineBallChestPass). 14 painted
# meshes: 7 BRIGHT, 7 DIM, 0 FAINT - the lightest paint of the seven COND lifts
# (Sled Drag 31, Battle Rope Slams 30, Medicine Ball Slam 23, Rowing Machine 23,
# Battle Rope Alternating Waves 22, Sled Push 15), so this entry does not have
# the legend problem the family has elsewhere. NO painted name carries a side
# suffix, which agrees with the perfect mirror symmetry above, so every glow is
# placed on both sides or on the side the render actually draws, and never as a
# depth claim.
#   BRIGHT  PectoralisMajor_Clavicular, PectoralisMajor_Sternal,
#           PectoralisMajor_Abdominal, TricepsBrachii_LongHead,
#           TricepsBrachii_LateralHead, TricepsBrachii_MedialHead,
#           DeltoidAnterior
#   DIM     BicepsBrachii_LongHead, BicepsBrachii_ShortHead, VastusIntermedius,
#           VastusLateralis, VastusMedialis, RectusFemoris, SerratusAnterior
# No glute mesh is painted on this lift at all, so the owner's standing glute
# decision does not bite here and no string below names a glute except the
# gluteus maximus stabiliser (which the row parent, Plyometric Push-Up, also
# names). The gluteus medius is named nowhere, as the standing decision requires.
# part_of() traps that bite on this lift, run for real: part_of(DeltoidAnterior)
# is sideDelts and part_of(Deltoid Anterior) is also sideDelts, so the row must
# read ANTERIOR DELTOID, which resolves to frontDelts. part_of(RectusFemoris) is
# None and would be DROPPED, so the painted rectus femoris rides inside the
# Quadriceps row. part_of(SerratusAnterior) is None AND not in LEGEND_ONLY, so
# only the spaced spelling Serratus Anterior is legal.
# DOES THE PAINT SHOW? Measured on the stills, which are 382 x 655, exactly the
# trainer frame. Paint covers 7 517 of 27 384 rendered lifter pixels (27.5%) in
# t0 and 7 556 of 29 348 (25.7%) in t1. Blobs in t0, largest first: the NEAR
# (left) THIGH 3 509 px (46.7%) at u 0.636..0.793, v 0.513..0.682; the PECTORAL
# FAN 2 354 px (31.3%) at u 0.545..0.709, v 0.220..0.328; the NEAR UPPER ARM
# 1 176 px (15.6%) at u 0.707..0.791, v 0.278..0.376; slivers of the FAR THIGH
# 345 px (4.7%) at u 0.547..0.592, v 0.531..0.663; a patch of the FAR ARM past
# the ball 121 px (1.6%) at u 0.531..0.607, v 0.313..0.342. Two consequences the
# glow block uses: the DIM QUADS OUT-DRAW EVERY BRIGHT MUSCLE (the two thigh
# blobs are 50.1% of all painted pixels in t0 and 50.3% in t1 against 31.3% for
# the bright pecs), and THE BRIGHT DeltoidAnterior IS NEARLY INVISIBLE (inside a
# 22 px disc on upper_arm_L, 191 of 1 077 body pixels are painted in t0, 17.7%,
# and 69 of 768 in t1, 9.0%, because at this yaw the shoulder is seen almost in
# profile and the cap the reader sees is the unpainted lateral and posterior
# deltoid). The bright/dim split cannot be read back from pixel colour - the
# saturation (R-G)/R of the painted pixels is one lighting-dominated spread
# (0.263..0.830, median 0.623 in t0) with no second mode - so tiers_cond.json is
# the only source of truth for tiers and the far-arm patch above cannot be
# attributed to the biceps from the pixels alone (see glow 6).
#
# WHERE THE CAMERA IS, because two glows depend on it. The ball's projected minor
# axis grows monotonically with its world z (84.6 px at z 0.4196, 86.9 px at
# z 0.7346, 89.3 px at z 1.1022), so +z is TOWARD the camera: the camera is in
# front of the lifter and about 74 degrees round to the lifter's LEFT, nearly a
# left-side profile with a little front. The lifter's LEFT reads at HIGH u
# (upper_arm_L u 0.698-0.720 against upper_arm_R u 0.608-0.629) and toe_L draws
# lower on screen than toe_R (v 0.8429 against 0.8134), so the near side is the
# left. That is why the near arm shows its lateral surface - the 1 176 px bright
# triceps blob - and the far arm shows its anterior surface, the 121 px patch.
#
# THE SOURCES BEHIND EACH COACHING CLAIM. There is NO EMG study of the chest
# pass: ABSTRACT:"chest pass" AND ABSTRACT:"electromyograph*" returns 0, as does
# the MVIC form, and ABSTRACT:"medicine ball" AND ABSTRACT:"MVIC" returns two
# nutrition studies that merely used a throw as an outcome test. So NO cue below
# claims a muscle level or a ranking from evidence; the table follows the paint,
# exactly as the jump family did when no study existed.
#  - THE THROW IS A VALIDATED TEST OF UPPER-BODY POWER. Test-retest 0.996 for the
#    backward overhead throw and r = 0.906 with the jump power index in 20
#    competitive sand volleyball players (Stockbrugger and Haennel 2001, JSCR
#    15:431-8, PMID 11726253); ICC 0.94 (95% CI 0.88-0.97) for a supine throw
#    with a 4 kg accelerometer ball in 30 physically active adults and r = 0.92
#    with the seated throw, sensitive to induced upper-body fatigue where grip
#    strength was not (Tremblay 2026, JSCR 40:e346-51, PMID 41460695); peak force
#    and RFD reliable at ICC >= 0.82 and CV <= 14.0% in 20 young women (Johnson
#    2024, PMID 38825994). Used in the drive cue's why.
#  - SPEED OF INTENT IS THE TRAINED QUALITY. A maximum-speed unloaded warm-up
#    raised chest-pass distance by 0.50 m (6.0%) in 93% of 45 young female
#    basketball players (p < 0.01) while a slow-speed warm-up did not (p = 0.11)
#    and a seated control did not (p = 0.36) - Iwata 2026, Int J Exerc Sci
#    19:6002, PMID 42004778. Used in the drive cue's why.
#  - MEDICINE-BALL TRAINING RAISES THROWING VELOCITY AND NOT PRECISION. +14%
#    velocity (d = 3.0) against +3.7% in controls over 6 weeks in 28 competitive
#    female handball players, with throwing PRECISION unchanged (Raeder 2015,
#    JSCR 29:1904-14, PMID 26102258). Used in the drive cue's why.
#  - THE ONE STUDY WITH PER-EXERCISE NUMBERS FOR THE CHEST PASS, with its
#    authors' own caveat. 14 children, mean age 10.1 +/- 1.3 y, 2.3 kg ball, each
#    exercise twice for 30 s: chest pass 15.0 +/- 1.9 then 15.8 +/- 1.9 reps in
#    30 s, about one rep every 1.9-2.0 s, at 53.7% then 63.4% of VO2peak and
#    79.7% then 85.8% of HRpeak (Faigenbaum 2018, Int J Exerc Sci 11:886-899,
#    PMID 29997735). The authors state the aim was NOT to disentangle the acute
#    effects of each exercise, that the sequence was non-randomized, and that
#    each exercise was likely influenced by fatigue from the previous one, so
#    these are ORDERED, CONFOUNDED OBSERVATIONS AND NOT EXERCISE EFFECTS. Quoted
#    that way in the stance cue's why and nowhere else.
#  - THE CATCH HAS NO LITERATURE AND NO BADGE. Nothing in the sources and nothing
#    in the library's 466 comparison blocks addresses receiving a thrown
#    medicine ball; the nearest badge the library owns is BOUNCING OFF THE FLOOR
#    (1 use, barbellFloorPressContent :12661, mistakeCue Elbows slam the floor)
#    and it is about a barbell. The catch cue's why says so in those words.
#  - THE ONLY FORTHCOMING SOURCE. Tsartsapakis 2025 (PMID 40700315, Methods and
#    Protocols 8(4):77) is a PROTOCOL paper with no data whose expected outcomes
#    include overhead medicine ball slam trials. It is cited NOWHERE below and is
#    recorded here only so the next round re-checks it.
#
# THE ONE THING THE EXERCISE NAME DOES NOT GIVE, which has to live on the only
# ungated surface. ExerciseDetailView.instructions() shows the SETUP steps and,
# for each cue, its TITLE and its CORRECT string; intro, why, mistake, the pill
# labels, the comparison and the stabilisers are not on that screen, and mistake
# is behind the trainer AND the paywall. For this lift the missing thing is: YOU
# NEED A SOLID WALL OR A PARTNER AT A DISTANCE YOU CHOOSE, AND THE REP IS NOT
# FINISHED UNTIL YOU HAVE ABSORBED THE BALL COMING BACK. The name implies a
# target without saying you must set one up, and the catch is the only loading
# event in the lift - the elbow re-closes 80.36 degrees in 6 intervals (0.2500 s)
# at a trunk that moves 7.0000 degrees all clip, with the ball arriving at
# 4.857 m/s. The model shows no wall at all, so this cannot be left to the
# picture. It is carried TWICE on the ungated surface: setup steps 1 and 5 for the
# target, and setup step 4 plus the catch cue's title and correct string for the
# absorb. Setup steps are 3-5 and the library median is 61 characters, p99 140,
# longest ever 214; the five below are 113, 109, 107, 120 and 128 characters, all
# under about 135.
#
ex(name="Medicine Ball Chest Pass", var="medicineBallChestPass",
   # LABEL GEOMETRY. Rows: raw 0.14/0.32/0.50/0.68/0.86 draw at
   # 0.16/0.32/0.48/0.64/0.80 (spec_1029.py:41 maps
   # row(y) = round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)).
   # overrides below is in RAW slots; every number in this block is at the DRAWN
   # row, which is what room.py and lead.py take. To go back:
   # raw = 0.14 + (drawn - 0.16) * 1.125. Measured with
   #   python3.13 -I room.py "Medicine Ball Chest Pass" 8,9,10,20,21,23,26
   #   python3.13 -I lead.py "Medicine Ball Chest Pass" <joint> <drawn> <side> <len>
   # and re-derived independently by d_MedicineBallChestPass/ck.py, which rebuilds
   # the pill box, the 655-row skinned clearance and the load distance from
   # MedicineBallChestPass_A.json and _SIL.npz. room.py and ck.py agree to 0.1 px
   # on all five slots.
   # THE PILL THE APP DRAWS: half-height 0.025 in v, width
   # (24 + 5.6 * len(label)) / 382, pinned EDGE 0.035 from the leading (left) or
   # trailing (right) frame edge, on a 382 x 655 frame. Each extra character costs
   # exactly 5.6 / 382 of frame width = 5.6 px of clearance.
   #
   # WHERE THINGS ARE. The lifter's skinned silhouette spans u 0.0919..0.8436 and
   # v 0.1015..0.8542; its leftmost point is the fingertips at f13 (row 186,
   # v 0.2847), 51.5 px left of the hand_R wrist joint. THIS IS NOT A TRANSLATION
   # LIFT - the body stays put and only the arms sweep, so the left edge swings
   # 113.9 px over the clip and the right edge only 13.2 px, which is why four of
   # the five LEADING slots are clean and every TRAILING slot but the shortest is
   # dead. Per drawn band the lifter's u span is: 0.16 -> 0.4972..0.7355;
   # 0.32 -> 0.0980..0.7930 (the extended arms, at f13); 0.48 -> 0.5570..0.8436;
   # 0.64 -> 0.5363..0.7684; 0.80 -> 0.5162..0.8116. No band is ever empty.
   # The head's OWN silhouette occupies rows 66..136 of 655, i.e. v 0.1015..0.2084,
   # and every probed joint except head itself has v >= 0.2222 (neck, the
   # highest). THEREFORE NO LEADER FROM A PILL AT DRAWN ROW 0.32, 0.48, 0.64 OR
   # 0.80 TO ANY JOINT BUT head CAN ENTER THE HEAD ROWS AT ALL, which lead.py
   # reports as never spans the head rows. Drawn row 0.16 is the one exception,
   # because its band (v 0.135..0.185) lies inside the head band. The drawn crown
   # of the head sits 50.0-51.3 px above the head joint (mean 50.7), so a leader
   # aimed near head height must be checked against the head silhouette and not
   # against the head joint - which is what lead.py does.
   #
   # THE LOAD IS CLIPPED. room.py's own band summary says the load is in the 0.16
   # band for 2.00 s at u -1.264..-0.012 - EVERY ONE of those 4 520 point-samples
   # is LEFT OF u = 0 and invisible, and the Cube contributes 0 in-band points at
   # every row and is off screen on every frame regardless. The only row a reader
   # ever sees the ball cross is 0.32, which is dead on both sides anyway. So the
   # load distances quoted per slot below were recomputed TWICE by ck.py, once
   # over all 418 points (RAW) and once over only the points inside the visible
   # frame 0 <= u <= 1, 0 <= v <= 1 (CLIPPED), with the owning mesh named each
   # time: FOR ALL FIVE SLOTS THE NEAREST LOAD POINT IS A SPHERE POINT THAT IS ON
   # SCREEN AND THE RAW AND CLIPPED FIGURES ARE IDENTICAL. Every px figure in the
   # table below is therefore a real screen distance and is CLIPPED.
   #
   # Pill by pill, in cue order. Cells are: slot, label and its len(), the pill's
   # minimum clearance from the SKINNED lifter and its overlap frames, the
   # CLIPPED load distance and the frames the load is inside the pill, and the
   # leader against the HEAD'S OWN silhouette.
   #   hands  `Hands behind the ball`      21  row 0.16 LEADING
   #     lifter +35.0 px / 0 of 192 frames; load 1.2 px CLIPPED (nearest point
   #     Sphere index 95 at f25, u 0.049298 v 0.186879, on screen) / 0 frames
   #     inside; leader to hand_R CLEAR 0/192, closest 35.9 px at t 0.50.
   #     The full 26-joint sweep at this slot and this length puts 25 of 26 joints
   #     CLEAR (only head itself, 192/192, which is what anchoring to the head
   #     would mean and is not a defect of the slot); the tightest are
   #     upper_arm_L 8.1 px, neck 9.5 px and scapula_L 9.7 px, and hand_R and
   #     hand_L are the ROOMIEST in the whole layout at 35.9 px each. So hand_R is
   #     both the joint the label is about and the best-cleared anchor available
   #     from this slot.
   #     TWENTY-THREE CHARACTERS IS THE CEILING HERE and the LEADERS bind before
   #     the pill does: the pill itself is clean to 27 characters (+1.4 px; 28
   #     gives -4.2 px on 20 frames), but at 24 characters neck (4/192),
   #     scapula_L (16/192) and upper_arm_L (20/192) go ON THE FACE in the runs
   #     t 0.46-0.62 of each rep, at 26 scapula_R joins and upper_arm_L is
   #     44/192, and at 27 ten joints are on the face. At 23 upper_arm_L is down
   #     to 0.7 px, so 21 characters is deliberately two under the ceiling.
   #   drive  `Push the ball away fast`    23  row 0.48 LEADING
   #     lifter +46.6 px / 0 of 192; load 52.4 px CLIPPED (Sphere index 4 at f5,
   #     u 0.421339 v 0.375070, on screen) / 0 inside; leader to
   #     support_PectoralisMajor_Abdominal_R CLEAR 0/192, never spans the head
   #     rows. 25 of 26 joints CLEAR at this slot and length.
   #     THIS IS THE BEST SLOT ON THE LIFT: 0 lifter-overlap frames at every
   #     length tested from 8 to 28 characters, +18.6 px even at the validate()
   #     cap of 28, and the nearest load point a steady 52.4-65.3 px away with 0
   #     frames inside. It gets the longest label.
   #   catch  `Catch on soft elbows`       20  row 0.64 LEADING
   #     lifter +55.5 px / 0 of 192; load 157.6 px CLIPPED (same Sphere point) /
   #     0 inside; leader to forearm_R CLEAR 0/192, never spans the head rows.
   #     25 of 26 joints CLEAR. Clean to 28 characters (+10.7 px). forearm_R IS
   #     THE ELBOW JOINT in this rig (hand_* is the wrist), which is exactly what
   #     the label names, and drawn row 0.64 is knee height while the elbow sits
   #     at v 0.311-0.379, so the leader runs up the frame and crosses nothing.
   #   stance `Feet inside shoulder-width` 26  row 0.80 LEADING
   #     lifter +14.2 px / 0 of 192; load 262.0 px CLIPPED (same Sphere point) /
   #     0 inside; leader to toe_L CLEAR 0/192, never spans the head rows. 25 of
   #     26 joints CLEAR. The slot is clean to 28 characters but only just
   #     (+3.0 px at 28, +8.6 at 27, +14.2 at 26, +25.4 at 24), so 26 was chosen
   #     to keep 14 px rather than 3. toe_L and toe_R are PERFECTLY STATIC ON
   #     SCREEN (path 0.000 in uv, u 0.6716 and 0.5850 fixed, v 0.8429 and 0.8134
   #     fixed) and 319.3 and 292.9 px from the nearest visible load point - the
   #     calmest anchors in the whole COND family, and the right ones for a cue
   #     whose whole content is that the feet do not move.
   #   torso  `Stay tall`                   9  row 0.16 TRAILING
   #     lifter +13.3 px / 0 of 192; load 105.9 px CLIPPED (Sphere index 10 at f0,
   #     u 0.528692 v 0.264472, on screen) / 0 inside; leader to spine CLEAR
   #     0/192, closest 13.4 px at t 1.33.
   #     NINE CHARACTERS IS THE CEILING HERE: the pill is +13.3 px at 9 and
   #     +7.7 px at 10, then -3.5 px on 84 frames at 12. The LEADERS also bind:
   #     from this slot hand_L (36/192, runs t 0.96-1.29 of each rep) and hand_R
   #     (48/192, runs t 0.96-1.42) go ON THE FACE, and neck is clear by only
   #     1.9 px, clavicle_R by 2.0, clavicle_L by 2.5 and upper_arm_R by 3.1 - so
   #     this slot may NOT take a hand, a neck or a clavicle anchor. spine is
   #     clear by 13.4 px, the joint-wise maximum from this slot along with
   #     foot_L 13.6 and foot_R 13.5, and it is the joint a trunk cue is about.
   #
   # ALL FIVE PILLS: 0 lifter-overlap frames out of 192 and 0 frames with any load
   # point inside. ALL FIVE LEADERS: 0 of 192 frames on the head's own
   # silhouette. THE RULE IS MET IN FULL, with one near-miss recorded as open
   # point 1 below (the ball passes 1.2 px under the hands pill at f25 of each
   # rep, i.e. f25/f73/f121/f169, without ever entering it).
   # The two pills that share drawn row 0.16 do not touch: the leading pill ends
   # at u 0.4057 and the trailing pill starts at u 0.7702, a gap of 139.3 px, with
   # the head drawn between them (head joint u 0.579-0.668).
   #
   # SLOTS REJECTED, WITH THEIR NUMBERS, so the layout is not mistaken for the
   # only one available. 0.32 LEADING is dead: 68 lifter-overlap frames at 8
   # characters (f10..f26 of each rep, when the arms reach u 0.0980) rising to
   # 192 by 20, AND THE BALL IS INSIDE THE PILL ON 32-140 FRAMES - the only slot
   # on the lift the load ever enters. 0.32, 0.48 and 0.80 TRAILING are dead at
   # every length (92-192 overlap frames; 0.48 trailing is already -22.4 px on
   # 192 frames at 8 characters). 0.16 TRAILING is capped at 9 characters, as
   # above. 0.64 TRAILING is clean but capped at 9 characters too and much
   # tighter: +6.3 px at 8, +0.7 px at 9, -4.9 px on 80 frames at 10 - its
   # leaders are better (every joint but head never spans the head rows, so it
   # would take any anchor) but 0.7 px of pill clearance at 9 characters is
   # inside the width of the silhouette binning, so 0.16 trailing's +13.3 px was
   # preferred for the same label. The fifth pill therefore had a real choice and
   # the cheaper one on pill clearance was taken; see open point 2.
   overrides={"hands": (0.14, "leading"), "drive": (0.50, "leading"),
              "catch": (0.68, "leading"), "stance": (0.86, "leading"),
              "torso": (0.14, "trailing")},
   # LABELS, counted with len() the way validate() counts them (cap 28), against
   # the 1 308 distinct label strings in SampleData.swift:
   #   Hands behind the ball      (21) INVENTED. The library's two nearest strings
   #                 both belong to medicineBallPushUpContent, where the ball is
   #                 ON THE FLOOR and the hands are on top of it: Both hands on
   #                 the ball (22, :16064) and Chest to the ball (17, :16057).
   #                 Neither says where the hands sit
   #                 relative to the ball, which is the whole measured point here:
   #                 handgap 0.1356 m at f10 behind a 0.300 m ball, each wrist
   #                 3.81 cm outside its surface. Built on the library's own
   #                 pattern of naming a hand position (Hands land in place 19,
   #                 Hands shoulder-width 20, Hands by the hips 17).
   #   Push the ball away fast    (23) INVENTED. The library has no throwing lift
   #                 with content at all, so there is no release label to reuse.
   #                 Hands leave the floor (21, :37226 plyometricPushUp, the row
   #                 parent) is the nearest in family and names the hands rather
   #                 than the load. Explosive is avoided in the label because the
   #                 title carries the idea and fast is what the measurement says
   #                 (100.13 degrees of elbow in 0.2083 s).
   #   Catch on soft elbows       (20) INVENTED, and deliberately one word off a
   #                 library string: Land on soft elbows (19, :37232
   #                 plyometricPushUp) is the row parent's own landing label and
   #                 this lift catches rather than lands. Catch it high (13,
   #                 :49638 barbellCleanAndJerk) and Catch, chest up (15, :45560
   #                 cleanAndPress) are the only two catch labels in the file and
   #                 both are about racking a BARBELL on the shoulders, where the
   #                 elbows drive UP and under rather than folding. soft elbows is
   #                 carried verbatim from the parent because
   #                 the parent's badge is STIFF-ARM LANDING and the mechanic is
   #                 the same one.
   #   Feet inside shoulder-width (26) INVENTED. Feet close (10, x2 - :32724
   #                 cyclistSquat and :50212 jumpRope, the twelve-hour-old entry)
   #                 is the library's own narrow-stance string and
   #                 would also fit the slot, but it under-states a stance that is
   #                 81.6% of shoulder width - closer to shoulder width than to
   #                 together - and the measured risk is a reader setting up 8 cm
   #                 WIDER than the model, which only the explicit comparison
   #                 rules out. Feet shoulder-width, centred (28, x2) is the
   #                 string that would be wrong here. Built on Feet hip-width
   #                 apart (20, x3) and Feet about hip-width (20).
   #   Stay tall                   (9) REUSE x7, the library's own string. It is
   #                 nine characters, which is exactly this slot's ceiling, and it
   #                 answers the LEANING BACK fault (16 library uses as a badge)
   #                 that measurement 3 above shows the model does not commit.
   #                 Chest up (8, x11) would buy 5.6 px more clearance and was
   #                 rejected only on meaning: the trunk's whole range is
   #                 7.0000037 degrees, so the instruction is that the trunk does
   #                 not move, not that the chest lifts. See open point 2.
   annotations=[
       ("hands", "Hands behind the ball", "hand_R"),
       ("drive", "Push the ball away fast", "support_PectoralisMajor_Abdominal_R"),
       ("catch", "Catch on soft elbows", "forearm_R"),
       ("stance", "Feet inside shoulder-width", "toe_L"),
       ("torso", "Stay tall", "spine"),
   ],
   # CUE IDS. All five are established library ids, lower case and purely
   # alphabetic as all 169 distinct ids in the file are: stance (45 uses),
   # hands (20), drive (25), catch (7), torso (106).
   # Only TITLE and CORRECT reach the free reader. Every `correct` below asks for
   # something the model actually does, and where the animation does something a
   # lifter must not copy (measurements 1, 2, 3 and 4 above) the `correct` string
   # states the real mechanic instead of either asking for the artefact or
   # coaching around it.
   cues={
       "hands": ("Behind the Ball",
                 "The ball is pushed from behind with the hands close together, not gripped on its sides.",
                 "The hands own this ball and nothing else comes near it. On every contact frame each wrist is exactly 0.1881 m from the ball centre, which is 0.0381 m - 3.81 cm - outside its 0.150 m surface, to better than 0.2 mm, and neither hand is ever inside the ball; the next nearest joint is the right pectoral support at 0.1069 m and then the clavicles at 0.1474 m. At maximum drive the hands squeeze IN rather than out: handgap falls from 0.2326 m at the hold to 0.1356 m at f10, so the two wrists are 13.6 cm apart behind a ball 30 cm across, with the ball centre 17.5 cm in front of and 1.7 cm above the hand midpoint. On screen the nearest joint to a visible ball point is hand_R at 1.3 px and hand_L at 6.6 px, then the pectoral support at 23.4 px. Held, the ball draws at u 0.3156..0.5371, v 0.2238..0.3537 - a disc of radius 42.6 px in front of the chest and below the chin. So the ball is driven by the hands for 34 of the 48 frames of each rep, 70.8% of it, and it is pushed from behind and never gripped at the sides.",
                 "Holding the ball out away from the chest with the arms already half extended, so there is no push left to make.",
                 "Hold the ball at chest height with both hands behind it and your thumbs close together, so the pass pushes the ball from behind rather than squeezing it from the sides."),
       "drive": ("The Pass",
                 "This is a throw. Push the ball away as fast as you can and let it go.",
                 "The pass is 5 frame intervals long. The elbow opens from 59.87 degrees at f6 to 160.00 at f11 - 100.13 degrees in 5 INTERVALS, 0.2083 s - while hand_L.z travels from 0.2840 to 0.6691 m, 38.5 cm, and the heels leave the floor at f9. Release falls between f11 and f12 at (0.000, 1.102, 6.230) m/s, a speed of 6.326 m/s at 10.0 degrees above horizontal, and the outbound flight f12..f17 is exact ballistics: dz is +0.25957 m on every one of the five steps and the second difference of y is -0.01703 m per frame squared on every step, which is -9.810 m/s squared. What this trains is speed, and that is the one thing the literature is clear about. There is no EMG study of the chest pass at all, but the throw is a reliable and valid test of upper-body power - test-retest 0.996 and r = 0.906 with a jump power index in 20 sand volleyball players (Stockbrugger and Haennel 2001), ICC 0.94 with a 4 kg instrumented ball in 30 active adults, sensitive to upper-body fatigue where grip strength was not (Tremblay 2026), peak force and rate of force development reliable at ICC 0.82 or better in 20 young women (Johnson 2024). Intent is trainable: a maximum-speed warm-up raised chest-pass distance 0.50 m, 6.0%, in 93% of 45 young female basketball players, where a slow-speed warm-up did not (Iwata 2026). And six weeks of medicine-ball training raised throwing velocity 14% in 28 handball players while leaving precision unchanged (Raeder 2015) - so push for speed, not for accuracy.",
                 "Pressing the ball out at ordinary bench-press speed, so the rep trains nothing a press does not.",
                 "From your chest, push the ball away as hard and as fast as you can and let it leave your hands - this is a throw, not a press."),
       "catch": ("The Catch",
                 "Half the rep is receiving the ball, and it is the only part that loads you quickly.",
                 "The catch is one frame interval and the absorb that follows is six. Between f25 and f26 each wrist goes from 0.2233 m outside the ball to exactly its held 0.0381 m, and the ball arrives at (0.000, -1.697, -4.551) m/s, a speed of 4.857 m/s. The elbow then closes 80.36 degrees in 6 INTERVALS - 0.2500 s, 142.00 at f26 to 61.64 at f32 - at a trunk whose entire range over the clip is 7.0000037 degrees, and the hips and knees barely help: hip 7.3854 degrees of range, knee 15.0868, anklegap 3.8 mm. A ball 30 cm across arriving in a quarter of a second at a near-static trunk is the only fast loading event in this lift, and nothing in the literature or in the library addresses it: the nearest thing the app owns is BOUNCING OFF THE FLOOR on the Barbell Floor Press, whose mistake cue is Elbows slam the floor, and that is about a barbell. Two things the clip does NOT give you. The deepest elbow of the rep is the wind-up and not the catch - 59.87 degrees at f6 against 61.64 at f32 - and the knee goes the other way by four thousandths of a degree, 129.3762 at f32 against 129.3871 at f5, which is nothing, so there is no measured sink into the catch to copy. And the return is not a bounce off anything: the ball leaves its turnaround RISING at 1.559 m/s having arrived falling at 0.943 m/s, comes back 9.45 cm higher than it went out, and keeps only 73.06% of its outgoing horizontal speed. Set the distance yourself and judge the catch yourself.",
                 "Catching the ball on straight arms, so the elbows and shoulders stop it instead of the muscles.",
                 "Meet the ball with your arms already reaching and let your elbows fold it in to your chest - and if a pass comes back off line, step aside and let it go rather than reaching for it."),
       "stance": ("Your Base",
                  "The feet are a little inside shoulder-width and they never move.",
                  "The stance is narrower than the shoulders and it is frozen. anklegap is 0.3200 m against a shouldergap of 0.3922 m, which is 81.6% of shoulder width, and over 192 frames anklegap changes by 3.8 mm while shouldergap changes by 0.0000004 m. The feet themselves do not move at all: toe_L and toe_R are frozen on all three axes for all 192 frames, with ranges of 0.000000 m to seven decimals, and the heels rise 1.43 cm at most, on f9..f17 - 9 frames, 0.3750 s - peaking at f12. Nothing steps, shuffles or resets between reps, and the four reps are bit-identical to 0.000554 mm. There is also no leg drive to find here: knee range 15.0868 degrees over the whole clip, hip 7.3854, trunk 7.0000037, with no triple extension and no weight shift, so a wide base buys nothing and a step would only cost accuracy. On how many reps to do, the only study with per-exercise numbers for this movement had 14 children, mean age 10.1 years, with a 2.3 kg ball reach 15.0 and then 15.8 repetitions in 30 s - about one every 1.9-2.0 s - at 53.7% and then 63.4% of VO2peak; but its authors state the aim was not to disentangle the individual exercises, the exercise order was not randomised, and each exercise was likely influenced by fatigue from the one before, so those are ordered, confounded observations and not an effect of the chest pass (Faigenbaum 2018).",
                  "Stepping into the throw or letting the feet drift wider, so the pass turns into a push press from the legs.",
                  "Leave your feet where you set them - they do not step or shuffle into the throw, so every rep starts from the same base."),
       "torso": ("Quiet Trunk",
                 "The trunk hardly moves. The pass comes from the arms and chest, not from leaning back.",
                 "The trunk is the quietest channel in the clip. Its whole range is 7.0000037 degrees, from 6.5793 at f32 to 13.5793 at f12, over only 40 distinct values with a flat plateau at 9.5793 across f5..f8 - a hand-keyed channel - and the lumbar and thoracic chains are frozen at 171.879 and 174.067 with zero range. The hands are never above the shoulder on any of the 192 frames, staying 9.29 to 17.02 cm below it, and the upper arm peaks at 73.7965 degrees from straight down. The reaching finish a thrower expects is not there either, and this is the one place the animation would mislead a reader who copied it. The elbow's maximum is 167.99985 degrees - a key set at 168, so the arm never straightens - and it arrives at f18, which is 6 frames (0.2500 s) after the first free-flight frame f12 and 7 frames (0.2917 s) after the last held frame f11, so it coincides with the ball's turnaround and not with the throw. At release the elbow is 160.00 and it then FLEXES to 158.47 at f13 before re-extending. What actually opens at f18 is the hands going apart - handgap 0.3178 m, the clip maximum - while hand_L.z moves BACKWARDS from 0.6766 m at f12 to 0.6523, a change of -0.0243 m. So the arms spread and drift back after the ball has gone, and finish long with the fingers chasing the ball is contradicted by the model. Keep the trunk still and let the ball go.",
                 "Rocking the trunk back and throwing the shoulders after the ball to add a little distance.",
                 "Keep your chest up and your trunk almost still through the rep - the pass comes from your arms and chest, not from leaning back or swinging after the ball."),
   },
   # ROWS EXACTLY AS rows_cond.md SECTION 8.6 SETTLES THEM, pasted unchanged.
   # 8 rows, 5 primary, and they follow the paint re-counted above: the three
   # BRIGHT pectoral heads and the BRIGHT triceps and anterior deltoid are the
   # five primaries; the DIM serratus, quadriceps and biceps are the three
   # secondaries. The seven dim meshes collapse to three rows because the three
   # vasti plus RectusFemoris are one Quadriceps row (part_of(RectusFemoris) is
   # None, so the mesh name cannot be a row name) and the two biceps heads are one
   # Biceps Brachii row.
   # THE WHOLE PRIMARY BLOCK IS A CARRY FROM PLYOMETRIC PUSH-UP (:37309-37313),
   # the library's only plyometric chest entry and the only place it describes an
   # explosive chest action. Middle Pectoralis 0.88 and Triceps Brachii 0.70 and
   # Anterior Deltoid 0.60 are same-rank carries; Upper Pectoralis 0.64 and Lower
   # Pectoralis 0.56 move SECONDARY -> PRIMARY AND KEEP THEIR FRACTIONS, which is
   # the library's own stated rule (the Leg Press comment at
   # SampleData.swift:7037-7049: Gluteus Maximus moves up from secondary to
   # primary, its 0.48 kept). Serratus Anterior 0.30 is Chest-Supported Row
   # Machine :6202; Quadriceps 0.25 is Farmer's Walk on Toes :40368 and Jump Rope
   # :50271; Biceps Brachii 0.24 is the fly family's value, 12 shipped uses. NO
   # ESTIMATE IN THIS TABLE - all eight fractions are carries from named shipped
   # rows, and the lift is one of only two in the family with no estimate.
   # Every level word was produced by common_1_50.level() and not typed
   # (>= 0.70 HIGH, 0.40-0.69 MODERATE, else LOW), and every name was resolved
   # through the imported part_of(): Middle / Upper / Lower Pectoralis -> chest,
   # Triceps Brachii -> triceps, Anterior Deltoid -> frontDelts (NOT sideDelts,
   # which is what Deltoid Anterior would give), Quadriceps -> quads, Biceps
   # Brachii -> biceps, Serratus Anterior -> None but in LEGEND_ONLY so legal.
   # WHY THE FRACTIONS MATTER HERE AND NOT JUST THE NAMES. library_cond.md
   # objected that this lift would lose the word it is about - a legend led by the
   # anterior deltoid reads ANTERIOR DELTOID . LOWER PECTORALIS and never names
   # the chest. Under the Plyometric Push-Up carry the fractions put MIDDLE
   # PECTORALIS first, so the legend reads MIDDLE PECTORALIS . TRICEPS BRACHII and
   # the reader does see the chest named at every budget.
   # WHAT THE LEGEND ACTUALLY SHOWS. Exercise3DView.swift:513 and :524 uppercase
   # the names and join them with a middle dot, and BOTH lines are lineLimit(1) at
   # about 40 characters on a 375 pt phone and 43 on a 393 pt one - and because
   # PRIMARY and SECONDARY are separate Text views in the same HStack, the
   # secondary line is about 2 characters tighter. This lift's primary line is
   # MIDDLE PECTORALIS . TRICEPS BRACHII . UPPER PECTORALIS . ANTERIOR DELTOID .
   # LOWER PECTORALIS = 92 characters, so 2 of 5 names show at both budgets; the
   # secondary line is SERRATUS ANTERIOR . QUADRICEPS . BICEPS BRACHII = 47
   # characters, 2 of 3. Truncation costs the reader the NAME on the 3D screen and
   # not the data: Sheets.swift:95 is a plain ForEach with no cap, so every row
   # still draws its bar in the Muscles Worked sheet. The one exception is
   # Serratus Anterior, which part_of() sends to None, so it renders in the legend
   # and is silently dropped from TARGET MUSCLES whether or not the line
   # truncates - see open point 3.
   activation=[("Middle Pectoralis", P, HI, 0.88), ("Triceps Brachii", P, HI, 0.70),
               ("Upper Pectoralis", P, MOD, 0.64), ("Anterior Deltoid", P, MOD, 0.60),
               ("Lower Pectoralis", P, MOD, 0.56),
               ("Serratus Anterior", S, LOW, 0.30), ("Quadriceps", S, LOW, 0.25),
               ("Biceps Brachii", S, LOW, 0.24)],
   # Stabilisers exactly as rows_cond.md section 6 settles them, all lower case as
   # all 466 shipped lists are, and four is the second most common count (104
   # blocks against the mode of 3 at 196). Each is unpainted on this lift, which
   # is what makes it legal as a stabiliser rather than a row: no glute, no
   # rotator cuff, no abdominal and no forearm mesh appears in this lift's tier
   # list. gluteus maximus is named because the row parent, Plyometric Push-Up,
   # names it too and because nothing in this paint contradicts it; THE GLUTEUS
   # MEDIUS IS NAMED NOWHERE IN THIS ENTRY, as the owner's standing decision
   # requires, although it is the library's fourth most common stabiliser at 46
   # blocks. rotator cuff for a throw, following medicineBallPushUp and
   # closeGripBenchPress. core rather than transverse abdominis because no
   # Rectus Abdominis row exists here to disambiguate from.
   stabilisers=["core", "gluteus maximus", "rotator cuff", "forearms"],
   # THE BADGE. ELBOWS FLARED is the library's own, 8 uses (mistakeBadge at
   # :9136, :13403, :15784, :16149, :16481, :34324, :37657, :45535), and one of
   # those - :16149
   # medicineBallPushUp, mistakeCue Elbows flared for balance - is ALREADY A
   # MEDICINE BALL LIFT, so this is a ninth use and a second on this equipment,
   # not a new badge word. Three reasons it is the right one here.
   # First, the model refutes the fault exactly and measurably: handgap falls from
   # 0.2326 m at the hold to 0.1356 m at f10, so the hands come IN as the ball
   # goes out, and the ball centre sits 17.5 cm in front of and 1.7 cm above the
   # hand midpoint - the ball is pushed from behind, never gripped on its sides.
   # Second, this module may not badge a fault the model performs on purpose (the
   # rule the jump family set on Jump Rope's HEELS DROPPING), and the model does
   # not flare at any frame.
   # Third, it is not any of the five cue mistakes above, which are: holding the
   # ball away from the chest, pressing instead of throwing, catching on straight
   # arms, stepping or drifting the feet, and rocking the trunk back. The flare is
   # adjacent to the hands cue's CORRECT string, which is the instruction, and
   # that is the overlap the house convention allows.
   # Rejected, with reasons. STIFF-ARM LANDING (1, :37324 plyometricPushUp) names
   # the catch mechanic exactly and is the row parent's own badge, but the catch
   # cue's mistake is already catching the ball on straight arms, so badging it
   # would duplicate a cue. BALL KEPT HIGH (1, :44644 medicineBallRussianTwist) is
   # the only ball badge the library owns and it means ball held up by the ribs on
   # a twist, a different instruction. HANDLE DRIFTING AWAY (1, :31831
   # landmineSquat) is about a handle, not a ball. A badge for having no target -
   # the lift's real gap - would be the library's FIRST badge for anything in the
   # reader's environment in 466 blocks, so it is left as open point 4 rather than
   # invented here. correctCue is 32 characters and mistakeCue 27, against library
   # medians of 26 and 27 and p90s of 32 each.
   comparison=("ELBOWS FLARED", "Hands behind the ball, elbows in", "Elbows flare, hands go wide",
               "With the hands behind the ball and the elbows tracking in by the ribs, the push runs straight through the ball and the chest and triceps do it. The model holds that line and tightens it: handgap falls from 0.2326 m at the hold to 0.1356 m at the moment of maximum drive, so the two wrists finish 13.6 cm apart behind a ball 30 cm across, and each wrist stays exactly 3.81 cm outside the ball surface on every contact frame.",
               "Hands spread on to the sides of the ball push the elbows out level with the shoulders, so the force runs around the ball rather than through it and the front of the shoulder takes what the chest should. It is the commonest pressing fault the library badges - eight shipped blocks carry it, one of them another medicine ball lift - and this animation does the opposite at every frame, which is why it is worth naming."),
   # GLOWS. One plain glow() per PAINT GROUP, six calls for the eight rows, and
   # THIS IS A DECLARED DEVIATION from the jump family's one-glow-per-row habit
   # (Jump Rope 4 rows / 4 glows, Box Jump 6 / 6). The reason is measured: the
   # three bright pectoral heads' own support joints sit 0.026 in u and 0.025 to
   # 0.092 in v apart - clavicular (0.613, 0.252), sternal (0.587, 0.286),
   # abdominal (0.588, 0.344) - i.e. 10 px and 16 to 60 px apart on a frame where
   # the whole measured pectoral blob is 63 px wide and 71 px tall, so three
   # separate glows there would read as one smear with three centres. The shipped
   # library is firmly on the side of fewer glows than rows - 1 glow in 10 blocks,
   # 2 in 241, 3 in 196, 4 in 12, 5 in 3, 6 in 3, 8 in 1, against row counts that
   # run to 12 - and chestSupportedRowMachineContent carries 9 rows with 4 glows.
   # Six glows for eight rows sits inside both precedents. It needs the row
   # stage's agreement or the three pec glows come back; see open point 5.
   # Opacities descend with the fractions they stand for, bright rows on A and dim
   # rows on SOFT, which is the paint tier alone and never a depth claim. glow()
   # averages joints.json's eight probed moments, and on this clip those eight
   # collapse to TWO poses (f0 and f24, four samples each), so every centre below
   # is the midpoint of two extremes. That is safe for the torso and thigh joints,
   # whose own screen paths are 0.409 to 0.681 of frame width, and it is why NO
   # glow is anchored on hand_* or forearm_*, whose paths are 2.303 to 2.622. Each
   # centre was then checked against the measured paint blob it stands for.
   glows=[glow("Medicine Ball Chest Pass",
               ["support_PectoralisMajor_Clavicular_L", "support_PectoralisMajor_Clavicular_R",
                "support_PectoralisMajor_Sternal_L", "support_PectoralisMajor_Sternal_R",
                "support_PectoralisMajor_Abdominal_L", "support_PectoralisMajor_Abdominal_R"],
               A, 0.58, rx=0.088, ry=0.062, dx=0.025, dy=-0.015),
          # -> (0.621, 0.279), box u 0.533..0.709 v 0.217..0.341, against the
          # measured pectoral blob u 0.545..0.709 v 0.220..0.328 (2 354 px, the
          # clearest thing in the frame). All six supports are averaged so the one
          # glow stands for all three bright heads and both sides.
          glow("Medicine Ball Chest Pass", ["upper_arm_L", "scapula_L"],
               A, 0.55, rx=0.050, ry=0.052, dx=0.030, dy=0.072),
          # -> (0.750, 0.320), box u 0.700..0.800 v 0.268..0.372, against the
          # measured near-upper-arm blob u 0.707..0.791 v 0.278..0.376 (1 176 px).
          # The triceps paint carries no side suffix, but at this yaw only the
          # near arm's lateral surface is drawn - 1 176 px against the far arm's
          # 121 px - so the glow sits where the paint renders. That is the view,
          # not a depth claim.
          glow("Medicine Ball Chest Pass", ["upper_arm_L", "upper_arm_R"],
               A, 0.50, rx=0.072, ry=0.034, dy=-0.010),
          # -> (0.665, 0.243), box u 0.593..0.737 v 0.209..0.277, spanning BOTH
          # shoulder joints (upper_arm_R u 0.608-0.629, upper_arm_L u 0.698-0.720)
          # because the paint is two-sided. ry is deliberately small so the top
          # edge sits at v 0.209, just clear of the head's own silhouette, which
          # ends at v 0.2084. THIS IS THE GLOW THE RENDER DOES NOT BACK UP: only
          # 17.7% of the near shoulder cap is painted in t0 and 9.0% in t1, the
          # visible cap being the unpainted lateral and posterior deltoid. It
          # follows the BRIGHT tier and the primary row; see open point 6.
          glow("Medicine Ball Chest Pass",
               ["support_LatissimusDorsi_L", "support_LatissimusDorsi_R"],
               SOFT, 0.30, rx=0.040, ry=0.040, dx=-0.016),
          # -> (0.720, 0.371), box u 0.680..0.760 v 0.331..0.411, the near lateral
          # ribcage between the chest joint (v 0.359) and the spine joint
          # (v 0.424-0.437), which is where the serrated fan reads - most clearly
          # in t1. The two lat supports project to the same u,v at every sample,
          # so the average is that one point; dx moves it forward off the lat.
          glow("Medicine Ball Chest Pass",
               ["thigh_L", "thigh_R", "patella_L", "patella_R"],
               SOFT, 0.28, rx=0.100, ry=0.072, dy=0.040),
          # -> (0.673, 0.595), box u 0.573..0.773 v 0.523..0.667, against the two
          # thigh blobs together, u 0.547..0.793 v 0.513..0.682 (3 509 px near
          # plus 345 px far). This is the LARGEST painted area on the lift - the
          # dim quads are 50.1% of all painted pixels in t0 and 50.3% in t1,
          # out-drawing every bright muscle - and it is still SOFT at 0.28,
          # because the tier is dim and the knee moves 15.0868 degrees in the
          # whole clip. The picture and the table disagree here on purpose; see
          # open point 7.
          glow("Medicine Ball Chest Pass", ["upper_arm_R"],
               SOFT, 0.26, rx=0.042, ry=0.024, dx=-0.040, dy=0.062),
          # -> (0.580, 0.326), box u 0.538..0.622 v 0.302..0.350, against the
          # 121 px far-arm patch u 0.531..0.607 v 0.313..0.342 - the only painted
          # pixels on the far arm, and the far arm is the one showing its anterior
          # surface at this yaw, which is where the biceps is. The patch cannot be
          # attributed to the biceps from pixel colour (the bright and dim
          # saturations are one spread with no second mode), so this placement is
          # an inference from the camera position and anatomy and is named as one.
          # upper_arm_R was used rather than forearm_R because the elbow joint's
          # screen path is 2.303 of frame width and its eight-sample average is
          # meaningless; upper_arm_R's path is 0.681.
          ])
# THE SETUP STEPS AND EACH CUE'S CORRECT STRING ARE THE ONLY COACHING A FREE
# READER SEES. ExerciseDetailView.instructions() (ExerciseDetailView.swift:447,
# with ExerciseCatalog.swift:115-122 exposing setup and the cues' titles plus
# correct) throws intro, why and mistake away, and mistake is behind the trainer
# AND the paywall. So everything safety-bearing on this lift is in a step or a
# correct string, and the step list carries the two things the model cannot show.
# Step 1 is the target the lift needs and the picture never shows - the slab in
# the clip is off screen on all 192 frames and the ball turns round 5.00 cm short
# of it - stated as something the reader sets up, not as something to look for in
# the model, and it names the hazard (the line of the throw) because the library
# has no badge for anything in the environment. Step 2 gives the ball and the
# hand position behind it, which measurement 7 makes the defining detail. Step 3
# gives the stance at a little inside shoulder width rather than at shoulder
# width, which would be 8 cm wider than the model's 0.3200 m against a 0.3922 m
# shoulder span. Step 4 makes the catch half the rep on the ungated surface, as
# well as in the catch cue, because the absorb is the lift's only fast loading
# event and nothing in the literature or the library warns about it. Step 5
# PRESCRIBES the equipment instead of warning about it (changed 2026-10-31,
# open point 11): the model's ball still comes back 9.45 cm HIGHER than it went
# out while keeping 73.06% of its horizontal speed, which no wall does, so the
# copy still never describes the model's return - it tells the reader to pick a
# ball that gives one. The old wording offered a dead-ball branch (throw to a
# partner or pick it up and reset each rep), and a reader on that branch has no
# catch at all, which contradicts step 4 and leaves one of the five cues with
# nothing to apply to. Step 1 already prescribes a wall or a partner, so the
# cost of prescribing equipment on a surface where the model shows no target was
# already paid. No step ends in
# the timed family's for the set time phrase, because this lift is rep-based.
# Lengths: 113, 109, 107, 120, 128 characters - library median 61, p90 96, p99
# 140, longest ever shipped 214 (n = 1,720 shipped steps; re-measured in the
# second-review pass, where the brief's p99 of 132 did not reproduce on any
# subset - the all-466 figure is 140 and the pre-round figure 117).
SETUP["Medicine Ball Chest Pass"] = [
    "Face a solid wall about two to three metres away, or a partner at that distance, with nothing breakable in the throwing line.",
    "Use a medicine ball you can hold in both hands at chest height, hands behind it and elbows down by your ribs.",
    "Stand with your feet a little inside shoulder-width, flat and still, and stand tall with your trunk braced.",
    "Treat the catch as half the rep: take the ball on bending elbows and bring it back to your chest before you throw again.",
    "Use a ball that bounces back off a wall - a dead slam ball will not return and leaves you nothing to catch.",
]
# OPEN POINTS, RECORDED FOR THE OWNER AND NOT DECIDED.
#  1. THE BALL PASSES 1.2 PX UNDER THE HANDS PILL AND NEVER ENTERS IT. At drawn
#     row 0.16 leading the nearest visible load point is 1.2 px from the pill at
#     every label length from 8 to 28 characters, with 0 frames inside - it is
#     Sphere point 95 at f25, u 0.049298 v 0.186879, and it recurs at f73, f121
#     and f169, one brush per rep. The rule in the brief is met (zero overlap
#     frames, zero frames inside), but 1.2 px is one pixel of a 382 px frame and
#     the object brushing past is the ball, which is what the reader is watching.
#     Option A (taken): keep the hands pill at 0.16 leading and accept a 1.2 px
#     brush on 4 of 192 frames. Option B: vacate 0.16 leading entirely, which
#     needs BOTH short trailing slots - 0.16 trailing at 9 characters (+13.3 px,
#     load 105.9 px) and 0.64 trailing at 9 characters (+0.7 px, load 197.4 px) -
#     so two of the five labels would be nine characters or fewer, and the layout
#     would hang on a 0.7 px pill clearance that is inside the width of the
#     silhouette binning. Measured cost of B: it trades a 1.2 px load brush for a
#     0.7 px lifter clearance and loses 14 and 11 characters of label on two
#     cues. I took A; the owner may not.
#  2. WHICH SHORT SLOT AND WHICH SHORT LABEL THE TRUNK CUE GETS. Four legal
#     combinations, all with zero overlap frames and zero head frames:
#     0.16 trailing with Stay tall (9) gives +13.3 px of pill clearance (taken);
#     0.16 trailing with Chest up (8, x11 in the library against Stay tall's x7)
#     gives +18.9 px; 0.64 trailing with Stay tall gives +0.7 px; 0.64 trailing
#     with Chest up gives +6.3 px. 0.64 trailing has the better LEADERS - from
#     there no joint but head ever spans the head rows, so it would take any
#     anchor - while 0.16 trailing forbids hand_L (36/192 on the face), hand_R
#     (48/192), and comes within 1.9 px of the face on neck and 2.0 on
#     clavicle_R. I chose the pill clearance over the leader freedom and the
#     meaning over the extra 5.6 px, because the measurement is that the trunk's
#     whole range is 7.0000037 degrees - it does not move, rather than lifting.
#     If the owner's convention prefers the higher-use library string, Chest up at
#     0.16 trailing is a one-line change that costs nothing and buys 5.6 px.
#  3. SERRATUS ANTERIOR IS A ROW THE MUSCLES WORKED SHEET SILENTLY DROPS.
#     rows_cond.md 8.6 gives it a secondary row at 0.30 because the mesh is
#     painted dim and rule 1 says rows follow the paint. It is in
#     common_1_50.LEGEND_ONLY so validate() passes, but part_of() returns None,
#     so MusclePart(muscleName:) drops it and it is absent from TARGET MUSCLES
#     whether or not the legend truncates - the only one of this family's 75 rows
#     for which the sheet does not catch what the legend shows. The library's own
#     habit is the opposite: 2 blocks name it as a row, 96 as a stabiliser.
#     Measured cost of the row (taken, as section 8.6 settles it): it occupies 17
#     of the secondary line's 47 characters and pushes BICEPS BRACHII out of a
#     line that shows 2 of 3 names anyway. Stated the other way round, because
#     that is how a reader meets it: the secondary line reads SERRATUS ANTERIOR,
#     QUADRICEPS, BICEPS BRACHII, so THE MOST PROMINENT SECONDARY NAME IN THE
#     TRAINER LEGEND IS THE ONE THE DETAIL SCREEN'S PILLS DO NOT SHOW. That is
#     the Hip Flexors trap landing somewhere new; it is legal, intended by
#     LEGEND_ONLY, and is not a bug. Measured cost of moving it to the
#     stabilisers: a painted mesh gets no row, which breaks rule 1, the secondary
#     line falls to 27 characters with both names whole, and the stabiliser list
#     would go to five. Its two shipped row values are 0.30 (:6202) and 0.66
#     (:44924).
#  4. NOTHING IN THE LIBRARY CAN BADGE THE LIFT'S REAL GAP. The chest pass needs
#     a target and the model has none: the slab is off screen on all 192 frames
#     and the ball stops 5.00 cm short of it. The three ball and handle badges the
#     library owns all mean something else (BALL KEPT HIGH a Russian twist,
#     HANDLE DRIFTING AWAY a landmine squat, BOUNCING OFF THE FLOOR a barbell
#     floor press), and in 466 blocks the library has NEVER badged anything in the
#     reader's environment. Option A (taken): carry the target in setup steps 1
#     and 5 with no badge behind it, and badge ELBOWS FLARED, which the model
#     refutes frame by frame. Option B: invent the library's first environment
#     badge, on a lift whose own clip cannot show the fault, which would set a
#     precedent for the whole family - the Sled Drag has the same problem and a
#     genuine acute hazard behind it. Measured cost of A: the one thing a lifter
#     must set up before the first rep has no glow and no comparison view.
#  5. SIX GLOWS FOR EIGHT ROWS. Declared above and repeated here because it is a
#     deviation from the jump family's one-per-row habit, not a slip. The three
#     bright pectoral heads share one glow because their support joints are 10 px
#     and 16 to 60 px apart inside a blob 63 px wide and 71 px tall. Option A
#     (taken): six glows, one per paint group, which is where the shipped library
#     sits (2 glows in 241 blocks, 3 in 196, and 9 rows with 4 glows on
#     chestSupportedRowMachine). Option B: eight glows, one per row, matching the
#     twelve-hour-old jump modules; the three pec centres would be (0.613, 0.252),
#     (0.587, 0.286) and (0.588, 0.344), and the biceps and triceps would both
#     need their own arm placements, which is five glows inside 0.13 x 0.12 of the
#     frame. The row stage has to agree the grouping or the extra two come back.
#  6. THE ANTERIOR DELTOID IS A BRIGHT PRIMARY ROW THE RENDER BARELY SHOWS.
#     Inside a 22 px disc on upper_arm_L, 191 of 1 077 body pixels are painted in
#     t0 (17.7%) and 69 of 768 in t1 (9.0%), because at yaw -1.3 the shoulder is
#     seen almost in profile and the cap the reader sees is the unpainted lateral
#     and posterior deltoid. This is the chest pass's version of the jump
#     family's glutes-under-the-shorts problem. Option A (taken, and what section
#     8.6 settles): keep Anterior Deltoid as a primary row at 0.60 and give it a
#     glow, honouring the BRIGHT tier and the Plyometric Push-Up carry, and point
#     the reader at a part of the picture that is mostly unpainted. Option B:
#     demote it to a lower-case anterior deltoid stabiliser, which matches what
#     the render shows and under-states a bright mesh, drops the primary line from
#     92 to 74 characters (still 2 of 4 names), and would make the stabiliser
#     list five long. It is also the row with no evidence either way, there being
#     no EMG study of this movement.
#  7. THE DIM QUADS OUT-DRAW EVERY BRIGHT MUSCLE AND THE LEGS BARELY MOVE. The
#     two thigh blobs are 50.1% of all painted pixels in t0 and 50.3% in t1,
#     against 31.3% for the bright pectoral fan, so the reader's eye goes to the
#     legs - while the knee's whole range over 192 frames is 15.0868 degrees, the
#     hip's 7.3854, and there is no triple extension at all. A Quadriceps
#     secondary row at 0.25 (taken, as section 8.6 settles) is honest about the
#     picture and generous about the movement; a quadriceps stabiliser would be
#     the reverse. Both validate. Recorded because the glow at 0.28 opacity is
#     the largest coloured area on the screen and a reader may reasonably read it
#     as the lift's main worker.
#  8. THE PEC HEADS ARE A NEW RANK PATTERN. Section 8.6 gives three PRIMARY
#     pectoral rows, following the paint and the README's chest-head rule and
#     ChestPaint.swift:97, which already marks all three regions primary on the 2D
#     map. No shipped block has three primary pectoral rows: across the 52 blocks
#     that name all three heads the patterns are S,P,S (29), P,S,S (9), S,S,P (6),
#     S,P,P (5) and P,P,S (3). The alternative, one Pectoralis Major row, shortens
#     the primary line to 53 characters and 2 of 3 names, but Pectoralis Major has
#     NO primary row anywhere in the library - all 6 uses are secondary, the
#     highest being Push-Up S 0.84 - so a bright single-group chest would be the
#     first primary Pectoralis Major row ever shipped. Settled by the rows stage,
#     recorded here so it is not mistaken for a drafting choice.
#  9. THE EIGHT TRAINER STILLS SHOW ONLY TWO POSES AND NEITHER IS THE THROW.
#     t1 = t3 = t5 = t7 bit-identical, t2 = t4 = t6 bit-identical, t0 differing
#     from those three in 30 of 250 210 pixels at a maximum channel delta of 2.
#     The eight samples land on f0 (the frozen hold) and f24 (the ball coming
#     back), because eight samples over 7.958 s is every 1.000 s against a
#     2.000 s period. The release, the flight, the turnaround and the catch are in
#     none of them, and joints.json has the same problem - at most five distinct
#     values per joint across its eight probes, four clustered on f23/f24. Nothing
#     in the copy above leans on a position the reader can check in the strip, but
#     anyone judging this entry from the stills will think the model is standing
#     still holding a ball. A re-probe at the release and the catch would be worth
#     doing before any future cue depends on a mid-throw position.
# 10. WHETHER A CHEST PASS MAY CLAIM THE CHEST AT ALL. There is no EMG study of
#     this movement - the searches are recorded above and all return zero - and
#     the one study with per-exercise numbers is 14 ten-year-olds with a 2.3 kg
#     ball in a non-randomised order its own authors say confounds the per-exercise
#     values. What is established is narrower and different: the throw is a
#     reliable, valid TEST of upper-body power that correlates with the vertical
#     jump, and medicine-ball training raises throwing velocity without raising
#     precision. The table above follows the paint and cites the literature for
#     nothing, which is what the jump family did when no study existed, and the
#     drive cue's why says plainly that what is measured is the test and not the
#     muscle. Recorded so the next round does not read the eight rows as evidence.
# 11. THE BALL TYPE IN STEP 5 IS NOW PRESCRIBED, AND IT IS THE ONE OPEN POINT
#     THIS REVIEW PASS DECIDED. Step 5 used to read: A ball that does not bounce
#     will not come back off a wall, so throw to a partner or pick it up and
#     reset each rep. A reader who took the second branch had NO CATCH - so step
#     4 (treat the catch as half the rep) and catch.correct (the rep is not
#     finished until you have absorbed it) both promised something that branch
#     removes, and one of this entry's five cues stopped applying to them. It now
#     reads: Use a ball that comes back off a wall, or throw to a partner - a dead
#     slam ball will not return and leaves you nothing to catch (128 ch).
#     OPTION A (taken): prescribe the ball. Cost - the entry prescribes equipment
#     on a surface where the model shows no target at all; the wall slab draws at
#     u -1.683 to -1.27 and is NEVER on screen, so CLIPPED TO THE VISIBLE FRAME
#     (u 0..1, v 0..1) it contributes nothing. Step 1 already prescribes a wall or
#     a partner and step 2 the ball, so that cost was paid before this change.
#     OPTION B: keep the caveat. Cost - the contradiction above, on the one screen
#     that is never gated, plus a cue with nothing to apply to.
#     This decides NOTHING about Medicine Ball Slam, where the bouncing-versus-
#     dead question is genuinely contested (sources_safety.md Part 5 open point
#     4). That lift's step 2 matches its own model, which loses 98.5 per cent of
#     its horizontal speed in the bounce, and is untouched.
# ------------------------------------------------------------ medicine ball slam
#
# Abs/MedicineBallSlam, yaw -0.8, zoom 0.694, offset [0.048, -0.061, -0.049],
# 192 frames at 24 fps (clip t 0.000-7.958 s), frame 382 x 655 - the framing the
# app itself uses (SampleData.swift:3039-3040, jobs.py). Library row today:
# Exercise(name: Medicine Ball Slam, category: .core, primaryMuscle:
# RECTUS ABDOMINIS, equipment: MEDICINE BALL, difficulty: .beginner) at
# SampleData.swift:1492-1494, with no ExerciseContent - one of the 36 model-only
# lifts, and the comment two rows above it already says so. ExerciseCatalog
# gives it .reps and NOT isBodyweight (MEDICINE BALL is in neither
# timedExercises nor the bodyweight equipment list), so unlike the five timed
# lifts of this family no setup step below ends in for the set time.
# Every figure here is read from measure_MedicineBallSlam.md, rows_cond.md 4.7
# and 8.7, sources_cond.md 7 and 9.4, sources_safety.md 3.7 and Part 6, and
# library_cond.md; the headline numbers were re-measured independently for this
# entry in d_MedicineBallSlam/verify.py off MedicineBallSlam_A.json and all of
# them reproduce (see VERIFICATION below).
#
# WINDOW ARITHMETIC. Every window is written fA..fB INCLUSIVE, which is
# (B-A+1) FRAMES and (B-A)/24 SECONDS of elapsed time. f29..f40 is twelve
# frames and 0.458 s. Where a figure says seconds it is the INTERVAL
# convention, (B-A)/24, and where it is a frame count it says so.
#
# CLIP SHAPE - FOUR IDENTICAL REPS OF EXACTLY 48 FRAMES, 2.0000 s each. The
# circular lag sweep, taken as the EUCLIDEAN per-joint distance (max over all
# 26 measured joints and all 192 frames of |J[i] - J[i+k mod 192]|): lag 48,
# 96 and 144 all agree to 0.000247 mm; the next nearest lag is 245.777 mm at
# lag 1 (and at 47, 49, 95, 97, 143, 145 and 191, which are the same comparison
# at +-1 mod 48), which is 995 000 times the period error; the HALF-period lag
# 24 is 1403.006 mm, so this is not a two-phase alternation. Rep 1 is f0..f47,
# and every figure below repeats at t + 2.000, + 4.000 and + 6.000 s. f191
# against f0 is 0.000000 mm, but that is free rather than engineered - both
# frames sit inside the same held pose. Frozen runs, swept at a 0.001 mm
# tolerance (1e-9 finds nothing): f46..f49, f28..f30 and their three repeats -
# 28 of the 192 FRAMES are inside a frozen pose (14.58 per cent), which is 20
# of the 192 frame INTERVALS of the loop, 0.8333 s of 8.0000 s, 10.42 per cent
# of elapsed time; scanned as a flat strip rather than a loop it is 19
# intervals, 0.7917 s. Largest single-frame step 245.777 mm (f17->f18 and its
# three repeats), median non-frozen step 74.544 mm. Left and right mirror
# throughout - knee_L against knee_R never differs by more than 0.112 deg,
# elbow_L against elbow_R by more than 0.0005 deg - so every single-side figure
# below is the LEFT side.
#
# THE PHASES OF REP 1, with their windows (measure_MedicineBallSlam.md 2):
#   1. chest hold          f46..f49   4 frames  0.1250 s  frozen; straddles the
#                                               rep boundary (rep phases 46,
#                                               47, 0, 1)
#   2. counter-dip         f1..f4     4 frames  0.1250 s  knee 167.04 -> 151.26
#   3. overhead reach      f4..f12    9 frames  0.3333 s  shoulder 44.9 -> 165.9
#   4. the slam, attached  f12..f19   8 frames  0.2917 s  trunk -3.82 -> 38.34
#   5. release and flight  f19..f21   3 frames  0.0833 s  impact at f21, t 0.875
#   6. follow-down         f19..f28  10 frames  0.3750 s  knee -> 61.9026
#   7. bottom hold         f28..f30   3 frames  0.0833 s  frozen
#   8. stand up with it    f31..f46  16 frames  0.6250 s  trunk 55.20 -> 1.58
# Clip-wide channel ranges: knee 61.9026-167.0409 (105.1383 deg), hip
# 74.8139-170.9145 (96.1006), elbow 75.1952-167.6511 (92.4559), trunk -5.5434
# to 56.5450 (62.0884), ankle 64.1445-124.0064 (59.8618), shoulder flexion
# 14.3119-166.1791 (151.8672), handgap 0.1839-0.3536 m, anklegap
# 0.3800-0.3933 m, shouldergap a dead constant 0.392155 m (range 3.11e-07 m).
# PHASES 6 TO 8 ARE 28 OF THE 48 FRAMES, 27 INTERVALS = 1.1250 s OF THE
# 2.0000 s REP, 58 PER CENT - more of the rep than the slam. That is the fact that decides this
# entry's public copy (Part 6 of sources_safety.md).
#
# THE LOAD - one driven sphere, and the only load in this family that never
# leaves the frame. eq_names is [Sphere]: one mesh, 362 points per frame, at
# /root/HG_MedicineBall/Sphere; the only other non-rig mesh on the stage is
# DARK_Floor, which meas.py excludes by name, and GYM_Barbell_ROOT holds zero
# meshes. Bounding box 0.300000 m on a side on every frame (range 1.34e-07 m),
# so a 0.300 m ball of radius 0.150 m, with the centroid and the box centre
# agreeing to 2.4e-08 m. It is welded to the hands for f0..f19 and f28..f47 -
# |hand_L - centre| is exactly 0.188053 m, 0.038053 m outside the surface, on
# every one of those frames and on no other - and ballistic only over f20..f27
# (re-measured: the frames off that radius are exactly 20..27 and their three
# repeats). x is 0.0000 on every frame (|x| <= 6.5e-09 m), dead on the midline
# between feet that sit at x +-0.19. Centre y 1.2200 at the chest hold, 2.1211
# at f12 (top surface 2.2711), 1.1612 at f18 where z reaches its forward-most
# 0.8843, then 0.1500 at f21; box bottom reaches exactly 0.000000 at f21 and
# over f25..f30 and is never negative on any of the 192 frames. Release, with
# each dy computed both ways and asserted equal: f19->f20 vy -8.3100 m/s,
# f20->f21 vy -8.7188, horizontal a constant -3.9830 across both free
# intervals, resultant at impact 9.5853 m/s; implied vertical acceleration
# -25.475, +0.796, -25.688 and -9.810 m/s2 across those four intervals, so only
# f20->f21 is at g (g to 0.04 per cent). The bounce is a clean parabola fitted
# over f21..f25 at g = 9.8100, v0 = +0.8175 m/s, max residual 2.6e-09 m, apex
# 3.41 cm, restitution 0.094 - and the ball loses 98.5 per cent of its
# horizontal speed in it (3.9830 m/s in, 0.0600 m/s out) and then stops dead,
# which is scripted, not simulated. It settles 0.1847 m in front of the toe
# joints, and measured in 3-D against the shoe mesh its surface never comes
# closer to a shoe than +0.1004 m. ON SCREEN, AND THIS NEEDS NO CLIPPING: all
# 69 504 point-samples (362 points x 192 frames) are inside 0 <= u <= 1 and
# 0 <= v <= 1 - zero samples outside - so raw and clipped are identical, and
# for the record the CLIPPED extents are u 0.1646-0.7133, v 0.0988-0.8667. The
# disc is 64.1 to 72.1 px across on the 382 x 655 frame and peaks at 84.7 px
# per frame of screen speed at f20. Unlike Battle Rope Alternating Waves
# (u -6.770), Battle Rope Slams (-4.396) and Medicine Ball Chest Pass (-1.683),
# nothing about this load had to be clipped to be quotable.
#
# WHAT THE ANIMATION DOES THAT A LIFTER MUST NOT COPY, and what that forbids:
#  (a) THERE IS NO CATCH AND NOTHING TO CATCH. The ball hits the floor at f21
#      with the wrists still 0.4882 m above its centre, and they do not touch
#      it again until f28, 0.2917 s later (f21..f28 is 8 frames, 7 intervals).
#      So no string may say ride the ball down or stay with it to the floor.
#      drive.correct says let it go and let it land, which is what the model
#      does and is also the safe version (sources_safety.md 3.7 fault 3).
#  (b) DO NOT BUILD ANYTHING ON THE RELEASE INSTANT. At f20 the wrists are
#      already 0.2843 m from the centre, 0.1343 m clear of the surface, yet the
#      f19->f20 interval is -25.688 m/s2, about 2.6 g. One frame of 48, almost
#      certainly invisible at 24 fps, but it makes once you let go it
#      free-falls one frame wrong. No cue here is built on it; drive.why states
#      it instead.
#  (c) THE BALL IS DEAD. 98.5 per cent of its horizontal speed goes in the
#      bounce and then it stops with no deceleration ramp. Nothing here
#      describes what the ball does after it lands beyond that it stays where
#      it lands - which for a dead slam ball is true anyway.
#  (d) THE HEEL COMES UP IN THE REACH AND NEVER IN THE SQUAT. foot_L rests at
#      0.068600 m, peaks +4.015 cm at f11 (foot_R +4.008 cm) and is back at its
#      rest height to within 0.00025 mm for every frame of f20..f31. So stay
#      flat-footed is true of the slam and the squat and FALSE of the reach,
#      and feet.correct says both halves rather than claiming either alone.
#  (e) THE GRIP NEVER CHANGES. The wrists hold a fixed 0.188053 m radius on
#      every attached frame, so the animation can teach nothing about hand
#      position, and the apparent regrip over f20..f28 is the hands travelling
#      to meet a fixed point. No cue below is about the hands on the ball.
#  (f) NOTHING PASSES THROUGH ANYTHING. Minimum ball-surface-to-joint clearance
#      is +0.0381 m (the wrists, by construction), then
#      support_PectoralisMajor_Abdominal_R +0.0801 m at f45, shins +0.1832 and
#      knees +0.1915 at f34, head +0.2880 and neck +0.2914. The ball never
#      comes near the face overhead.
#  (g) THINGS THAT LOOK LIKE ARTEFACTS AND ARE NOT. The resting knee (167.04)
#      and hip (169.23) are bent because that is this rig's neutral, the same
#      as the jump family; the -5.54 deg trunk at f11 is a normal overhead
#      lean-back; and THE BACK DOES NOT ROUND - see the comparison comment.
#
# THE PAINT, from tiers_cond.json key Abs/MedicineBallSlam: 23 names, 6 BRIGHT,
# 17 DIM, 0 faint, and NO painted name carries a side suffix - each resolves to
# exactly two rig meshes, <Name>_L_Mesh and <Name>_R_Mesh, so 46 of the 125
# skinned meshes in Anatomy_MasterRig are lit and nothing is one-sided.
# Mid-weight for this family (Sled Drag 31, Battle Rope Slams 30, Rowing
# Machine 23) and more than double the jump family.
#   BRIGHT (6): DeltoidAnterior; RectusAbdominis; RectusFemoris,
#     VastusIntermedius, VastusLateralis, VastusMedialis (all four quadriceps
#     heads).
#   DIM (17): BicepsBrachii_LongHead, BicepsBrachii_ShortHead; BicepsFemoris,
#     Semimembranosus, Semitendinosus; DeltoidLateral, DeltoidPosterior;
#     ErectorSpinae; ExternalOblique, InternalOblique; GluteusMaximus,
#     GluteusMedius, GluteusMinimus; RhomboidMajor; TrapeziusLower,
#     TrapeziusMiddle, TrapeziusUpper.
# part_of() traps re-checked on this list: part_of(Deltoid Anterior) returns
# sideDelts and part_of(Deltoid Posterior) returns sideDelts too, so all three
# deltoid rows below are written adjective-first - Anterior Deltoid gives
# frontDelts, Lateral Deltoid sideDelts, Posterior Deltoid rearDelts. No
# forearm muscle is painted on this lift, so the one-forearm-row rule does not
# bite here. THE OWNER STANDING DECISION ON THE GLUTES is applied: the rig
# lights maximus, medius and minimus as one unsplit group, so there is a single
# Gluteus Maximus row, the copy says nothing about a specific glute, and NO
# string in this entry names the gluteus medius - not in a row, not in the
# stabilisers.
# IS ANY OF IT VISIBLE? The camera is a 45.8 deg three-quarter FRONT view from
# the lifter's left (the lifter's LEFT reads at HIGH u: foot_L u 0.712-0.719
# against foot_R 0.552-0.565). 9 OF THE 23 PAINTED NAMES CONTRIBUTE NOTHING A
# VIEWER CAN SEE: the three glutes (100 per cent of their height falls inside
# the shorts band y 0.7022-1.0832, and the t0 shorts box holds 52 lit pixels of
# 4 922, 1.1 per cent), ErectorSpinae, RhomboidMajor, the three Trapezius heads
# and DeltoidPosterior (all posterior, on the far side on every frame); the
# hamstrings show only a sliver. What does read: the four quadriceps strongly
# (thigh boxes 52.6 and 21.4 per cent lit at t0), RectusAbdominis at t0 only
# and half-blocked by the ball disc, DeltoidAnterior at t0 (27.6 and 38.1 per
# cent of the two delt boxes), and the biceps and lateral deltoid as muted dark
# red on the upper arm. The obliques read on the upper flank only - the lower
# 42-48 per cent of their height is inside the shorts band. The BRIGHT and DIM
# tiers could NOT be separated by pixel colour: the render's shading range
# swamps the tier difference, so the tiers above are tiers_cond.json's, not a
# threshold.
#
# THE STILLS - eight files, TWO pictures. stills/medicine-ball-slam_t0..t7.png
# are 382 x 655 with alpha; t1 = t3 = t5 = t7 and t2 = t4 = t6 are
# byte-identical and t0 differs from t2/t4/t6 in 313 pixels of 250 210 (max
# channel difference 35, all inside u 0.526-0.699 / v 0.369-0.441) which is
# render noise, the poses agreeing to 0.000247 mm. The cause is the same
# aliasing as the glow trap: still tK is frame 24K and the rep is 48 frames, so
# t0 = f0 (the chest hold) and t1 = f24 (mid-descent, 4 frames above the
# bottom), confirmed two independent ways. NO STILL IN THE SET SHOWS THE
# BOTTOM, THE OVERHEAD POSITION OR THE SLAM - a cue written off the stills
# would describe a third of the lift, which is why every cue below is written
# off the frame data.
#
# SOURCES, and what each one may carry.
#  - THERE IS NO EMG STUDY OF A MEDICINE BALL SLAM. sources_cond.md 7.1
#    records the verified negatives: ball slam or overhead slam AND
#    electromyograph* -> 0; TITLE medicine ball AND TITLE slam -> 0; medicine
#    ball AND MVIC -> 2, both nutrition trials. So NO cue, note or row below
#    claims a muscle level, a muscle ranking or an activation outcome.
#    Tsartsapakis 2025 (PMID 40700315, Methods and Protocols 8(4):77) plans
#    exactly this measurement and is written in the future tense with no data;
#    it is named once, as a forthcoming source, and carries nothing.
#  - Faigenbaum 2018 (PMID 29997735, PMC6033503, Int J Exerc Sci
#    11(4):886-899): 14 children of mean age 10.1 +/- 1.3 y, 2.3 kg ball,
#    double-arm slam twice for 30 s - 15.1 +/- 2.5 then 16.1 +/- 2.5
#    repetitions, about one every 1.9-2.0 s, at 62.8 and 63.6 per cent of
#    VO2peak, 175.1 and 178.3 bpm (88.8 and 89.6 per cent of HRpeak), RPE 6.1
#    and 6.7. Used in depth.why for the RATE and the COST only, with the
#    authors' own caveats stated: the protocol was not designed to disentangle
#    the exercises, the sequence was not randomised, and each row is confounded
#    by fatigue from the one before. No muscle was measured.
#  - Hill 2024 (PMID 38900175, JSCR 38:1295-9): 24 adolescent swimmers, 3 x 5
#    medicine-ball slams as a PAPE stimulus, 50 m freestyle 1.6 per cent
#    (0.47 s) faster after 4 min (95 per cent CI 0.17-0.77, p < 0.001), 2 per
#    cent in women, and nothing at 1 or 8 min. The only randomised study of the
#    slam as such, and it measured a swim time, so it supports the slam being a
#    potent stimulus and nothing about which muscles perform it. Not used in
#    any public string.
#  - Callaghan and McGill 2001: porcine cervical functional spinal units,
#    IN VITRO, up to 86 400 bending cycles at 1 Hz, repeated flexion and
#    extension initiating posterior annular herniation at modest compression.
#    The only mechanistic evidence behind the badge, and it lives in
#    mistakeNote with the species and the segment named. It supports no dose
#    and it is not a human lumbar spine.
#  - COACHING, named as coaching and never as a finding: Bodybuilding.com's
#    slam guide (the spine is at risk of rounding; recommends a BOUNCING ball
#    for beginners), Sportskeeda (press the hips back, bend the knees), a Motra
#    entry (rounding the back during the slam as a common error) and Fitwill
#    (do not chase a rebounding ball by rounding the low back). None is a
#    standards body and none cites a measurement. sources_cond.md 9.4 is blunt
#    about the wider convention: the common claim that a slam trains the abs
#    has no EMG support whatsoever, and Stockbrugger 2003 - the nearest
#    validated ground, the throw as a reliable test of upper-body power -
#    explicitly declines to name a muscle.
#  - Deliberately NOT used: Ikeda 2009 (PMID 19826303), which is a SIDE throw
#    in n = 10 normalised to trunk-rotation torque rather than per-muscle MVIC,
#    with its signal in the external oblique; any claim that a slam is a core
#    exercise; any optimal ball weight, rep count or slam height, because none
#    is measured.
#
# LABEL GEOMETRY. Five pills, five slots, measured at the pill the app DRAWS
# (half-height 0.025 in v, width (24 + 5.6 * len)/382, pinned EDGE = 0.035 from
# the leading or trailing frame edge) against the 655-row SKINNED silhouette
# and the HEAD's own silhouette over all 192 frames, plus the 362-point load
# per frame. Rows quoted in the table below are the DRAWN rows that room.py and
# lead.py take; `overrides` carries the RAW 0.14 / 0.32 / 0.50 / 0.68 / 0.86
# values that spec_1029.py's row() squeezes to the drawn 0.16 / 0.32 / 0.48 /
# 0.64 / 0.80. Cells are room.py's own output, read off
# d_MedicineBallSlam/room_final.txt:
#
#     room.py "Medicine Ball Slam" 4,5,6 / 7,8,9,10
#     lead.py "Medicine Ball Slam" <joint> <drawn row> trailing <len>
#
#   reach  0.16 trailing, 10 ch (Reach tall) - lifter 10.2 px, 0 of 192 overlap
#          frames; load 16.2 px, inside 0/192; leader to upper_arm_L CLEAR
#          0/192, closest 6.6 px at t = 0.46; leader off the BALL all 192,
#          closest 15.5 px
#   hinge  0.32 trailing,  5 ch (Hinge) - lifter 15.6 px, 0/192; load 86.3 px,
#          inside 0/192; leader to pelvis CLEAR 0/192, closest 45.2 px at
#          t = 0.46; off the BALL all 192, closest 26.7 px
#   drive  0.48 trailing,  7 ch (Slam it) - lifter 11.4 px, 0/192; load
#          83.2 px, inside 0/192; leader to chest CLEAR 0/192, closest 78.2 px
#          at t = 1.17; off the BALL all 192, closest 24.9 px
#   depth  0.64 trailing,  8 ch (Sit deep) - lifter 1.6 px, 0/192; load
#          78.7 px, inside 0/192; leader to patella_L CLEAR 0/192 (it never
#          spans the head's own v rows at all); off the BALL all 192, closest
#          41.9 px
#   feet   0.80 trailing,  8 ch (Feet set) - lifter 8.6 px, 0/192; load
#          90.4 px, inside 0/192; leader to foot_L CLEAR 0/192 (never spans the
#          head rows); off the BALL all 192, closest 69.1 px
#
# So all five pills are clean on all four tests: zero overlap frames with the
# skinned lifter, zero frames with the load inside the pill, zero frames with
# the leader on the head, and zero frames with the leader crossing the ball
# disc. Nothing below is a breach and there is no cheapest-breach to report.
#
# WHY THOSE FIVE SLOTS AND THOSE LENGTHS, in numbers.
#  - THE BUDGET IS THE TIGHTEST IN THIS FAMILY. validate() allows a
#    28-character label; swept L = 4..28, no slot on this lift takes more than
#    16 and six of the ten take 9 or fewer. Per-slot ceilings, as max L with
#    zero lifter overlap / max L that ALSO never has the load inside the pill:
#    0.16 leading 22 / 16, 0.16 trailing 11 / 11, 0.32 leading 7 / 6, 0.32
#    trailing 7 / 7, 0.48 leading 6 / 4, 0.48 trailing 9 / 9, 0.64 leading
#    11 / 9, 0.64 trailing 8 / 8, 0.80 leading 15 / 15, 0.80 trailing 9 / 9.
#  - EVERY LEADING SLOT FAILS THE BALL TEST FOR EVERY JOINT. Run at each
#    leading slot's ceiling, the number of the 26 measured joints whose leader
#    never crosses the ball disc is 0 OF 26 at 0.16, 0.32, 0.48, 0.64 and 0.80
#    leading alike, because the pill sits at low u while the ball sweeps
#    u 0.1646-0.7133 across every row; the crossing runs between 12 and 144 of
#    192 frames depending on the joint. From the TRAILING edge 20 of the 26 are
#    clear, and the six that are not are the same six everywhere - hand_R,
#    forearm_R, patella_R, shin_R, toe_R and
#    support_PectoralisMajor_Abdominal_R, the far side, which reads at low u.
#    That is why all five pills here are trailing. The measured cost is in open
#    point 1.
#  - NO ARM-DISTAL ANCHOR IS AVAILABLE AT ALL. From every trailing slot the
#    leader to hand_L, hand_R and forearm_L is ON THE FACE for part of the clip
#    (0.16 trailing at 10 ch: hand_L 52/192, hand_R 72/192, forearm_L 32/192),
#    and forearm_R, which IS head-clear from the three lower rows, is one of
#    the six joints whose leader crosses the ball from every trailing slot. The
#    head joint is on the face 192/192 by construction, so it is never an
#    anchor. So no cue here can be anchored at the hands or the elbow,
#    and the reach is anchored at upper_arm_L - the shoulder, which is also
#    where the reach physically happens (shoulder flexion 44.9 -> 166.18 deg
#    while the elbow only opens 75.37 -> 149.29).
#  - THE LADDER IS ORDERED BY LEADER LENGTH. The clean anchors' own v ranges
#    are upper_arm_L 0.365-0.598 (mean 0.442), chest 0.452-0.630 (0.510),
#    pelvis 0.539-0.684 (0.588), patella_L 0.680-0.741 (0.705) and foot_L
#    0.817-0.829 (0.827), so pairing them with drawn rows 0.16, 0.48, 0.32,
#    0.64 and 0.80 keeps every leader short. The two swaps that were tested and
#    rejected: hinge at 0.48 with the library's own Hips back (9 ch) is clean
#    but leaves only 0.2 px of lifter clearance, and depth at 0.32 would give
#    patella_L a 252 px leader against 42 px from 0.64.
#  - THE ONE THIN MARGIN IS depth. Sit deep at 8 ch leaves 1.6 px; the same
#    slot at 7 ch leaves 7.2 px. It is still zero overlap frames, so it passes,
#    but it is the slot to re-measure first if the animation or the framing
#    changes. Open point 3 carries the alternative.
#  - Row 0.16 is nearly empty sky: the skinned lifter is inside that band in
#    only 24 of 192 frames (the hands and the ball at the overhead reach, which
#    reach v 0.137), which is why the trailing side there takes 11 characters
#    against 7 at rows 0.32. Whole-figure silhouette u 0.1858-0.7880,
#    v 0.1374-0.8626; head-only silhouette u 0.3686-0.7264, v 0.2595-0.5847.
#  - 15 of the 41 anchors in joints.json for this lift are NOT in
#    MedicineBallSlam_A.json and therefore cannot be tested by either tool
#    (attachment_TrapeziusUpper_L/R, deltoid_arc_clavicle_2_L/R,
#    deltoid_arc_scapula_2_L/R, support_LatissimusDorsi_L/R,
#    support_PectoralisMajor_Abdominal_L, support_PectoralisMajor_Clavicular_L/R,
#    support_PectoralisMajor_Sternal_L/R, support_TrapeziusUpper_L/R). None is
#    used as an annotation anchor below; two pairs are used as glow centres,
#    where no leader is drawn and the test does not apply.
#
# LABEL STRINGS. One reuse and four new, which is what a 44-character all-
# trailing budget allows. Counts below are LABEL uses in the shipped library,
# counted as the label: field in SampleData.swift and not as occurrences of the
# string anywhere: 2 323 labels, 1 308 distinct, median 18 characters, min 3,
# max 36. This lift's five slots average 8.8 characters, less than half the
# house median, which is the real size of open point 1.
#   Sit deep (8) - REUSE, and the library's single use of it is the same cue
#     with the same id: cossackSquatContent carries the annotation
#     (depth, Sit deep, pelvis) at SampleData.swift:30886. It is the right
#     string here for a measured reason, and the reason is the KNEE and not
#     parallel: knee_L reaches 61.9026 deg, which is 118 deg of flexion, and the
#     pelvis drops 45.58 cm from its own clip maximum - deep by any reading. It
#     is NOT below parallel: at the deepest frame the HIP joint is 0.1120 m ABOVE
#     the knee joint and the thigh slopes 15.09 deg down from hip to knee, and
#     the hip is above the knee on all 192 frames (corrected 2026-10-31; the
#     measure report's measured clauses are right and its conclusion inverted
#     them, and the inversion had reached three comments, depth.why and the
#     depth cue's `correct`). Full depth (10) and About parallel (14) are both
#     out anyway, and geometrically rather than editorially: at drawn row 0.64
#     trailing the lifter leaves room for 8 characters at 1.6 px, while 10
#     characters overlap the silhouette on 120 of 192 frames and 14 on all 192
#     (room.py "Medicine Ball Slam" 8,10,14).
#   Reach tall (10) - NEW. The library has no overhead-reach label at all: the
#     nearest strings are Stand tall (10, 13 uses) and Walk tall (9, 1), both
#     postural and neither about taking a load overhead.
#   Hinge (5) - NEW, and forced by the 7-character ceiling at row 0.32. The
#     library's own hip-fold label is Hips back (9, 14 uses, e.g.
#     dumbbellRomanianDeadliftContent/hips) and it does not fit this row; it
#     would also overclaim here, because the pelvis travels only 0.11 m in z
#     across the whole clip while dropping 45.58 cm in y. A 5-character label
#     is rare but not new: 18 of the 2 323 shipped labels are 5 characters or
#     fewer - five at 3, twelve at 4 and one at 5 (Pivot).
#   Slam it (7) - NEW. Nothing in the library describes a throw; its only
#     medicine-ball label group belongs to the Russian twist.
#   Feet set (8) - NEW, and chosen over the library's Heel down (9, 8 uses),
#     which fits this slot at 3.0 px but is a single-leg string and would claim
#     the heels stay down - false of the reach, where both rise about 4 cm.
#     Feet flat was rejected for the same reason. Feet set is the measured
#     claim: toe_L and toe_R travel 0.00033 mm and 0.00049 mm over all 192
#     frames.
#
# VERIFICATION. d_MedicineBallSlam/verify.py re-measured, independently of the
# measure report and off MedicineBallSlam_A.json: the lag sweep (48/96/144 at
# 0.000247 mm, lag 1 at 245.777, lag 24 at 1403.006), the loop error (0.000000
# mm), the frozen-interval count (19 in a strip, 0.7917 s), the largest step
# (245.777 mm at f17->f18), the median non-frozen step (74.544 mm), all seven
# published channel ranges, the pelvis y and z trajectories, the ball centre at
# f0/f11/f12/f18/f19/f21 and |x| <= 6.5e-09, the four release intervals and
# their four accelerations, the 0.188053 m wrist radius and the exact frames it
# leaves (f20..f27), the 0.4882 m hands-above-ball at impact, the heel peak
# (+4.015 cm at f11, +4.008 right) and its return to rest over f20..f31 (to
# 0.00025 mm, which is the report's +0.00000 cm at its own precision), the toe
# travel, the knee 0.1120 m below the hip and the 15.09 deg thigh at f28, the
# three spine chains (lumbar 171.879 rest / 166.479 at f22 / 173.379 at f11;
# thoracic 174.067 / 161.467; neck 175.433 / 157.783 at f28), the grip angle
# (99.75 deg at f0, 58.59 at f11), the ankle (105.41 rest, 64.14 at f28, 124.01
# at f11), shoulder flexion (14.31 to 166.18 at f11) and the elbow through the
# throw. EVERY ONE REPRODUCES. Two notes for the record: the lag and step
# figures only reproduce with the EUCLIDEAN per-joint distance - taking the
# largest single coordinate difference instead gives 241.866 mm at lag 1 and a
# largest step of 241.866 mm at f18->f19, both wrong - and the frozen sweep
# needs the 0.001 mm tolerance, since 1e-9 finds nothing.
#
# OPEN POINTS, RECORDED FOR THE OWNER AND NOT DECIDED.
#  1. ALL FIVE PILLS ON THE TRAILING EDGE, OR MORE ROOM FOR THE LABELS.
#     Measured both ways. Trailing-only, which is what ships below: the five
#     slots take 11 / 7 / 9 / 8 / 9 characters, 44 in total, the anchor must be
#     one of the 20 ball-clear joints, and every leader stays off the ball on
#     all 192 frames. Using the leading edge: 0.16 leading opens to 16
#     characters and 0.80 leading to 15 - 31 across those two slots against 20
#     for the same two trailing - but EVERY joint's leader from EVERY leading
#     slot crosses the ball disc, 0 of 26 clear, for between 12 and 144 of 192
#     frames. There is no middle option. TWO PRECEDENT COSTS come with the
#     choice made here and both are worth the owner's eye. First, of the 283
#     five-slot override blocks in the spec modules, ZERO are all-trailing,
#     though two are all-leading and one of those is Box Jump, shipped twelve
#     hours ago. Second, the five labels average 8.8 characters against a
#     shipped label median of 18 over 2 323 labels - this is the terse end of
#     the house voice, and it is the ball that put it there, not the lifter.
#  2. THE BADGE IS THE ONE FAULT THE MODEL GETS RIGHT. Coaching is unanimous
#     that the commonest slam fault is lumbar flexion on the way down; this
#     model flexes the lumbar chain 5.400 deg from rest and folds 96.1006 deg
#     at the hip, i.e. it demonstrates the CORRECT side exactly. Option A, used
#     below: badge ROUNDED LOWER BACK, which has 7 shipped uses (:4988 Deadlift,
#     :6091 T-Bar Row, :9712 Bulgarian Split Squat (Lean), :17200 Deficit
#     Deadlift, :18102 Landmine Row, :21957 Reverse-Grip T-Bar Row, :23223
#     Z Press) and is the most-precedented of four near-duplicate spellings
#     (BACK ROUNDING 4, ROUNDED BACK 3, UPPER BACK ROUNDING 2 - 16 occurrences
#     in all, and NOT ONE of them on a ballistic lift, so this would be the
#     first). Option B: badge the pick-up instead - 54 per cent of every rep, a
#     squat at 56.33 deg of trunk lean, stopping just above parallel with the
#     hip 0.1120 m above the knee, that no study, no badge
#     and no coaching source has ever addressed - which means inventing a badge
#     word on the one lift of the seven where the animation would actually
#     support the glow. The jump family's own precedent is for Option A: Squat
#     Jump took KNEES CAVING IN precisely because the model shows the correct
#     side of it. Also available and not used: PULLING WITH THE ARMS (4 uses),
#     which names the fault drive.mistake states.
#  3. ONE PILL MARGIN COULD BE WIDER AT THE COST OF ITS STRING. As shipped, the
#     five lifter clearances are 10.2 / 15.6 / 11.4 / 1.6 / 8.6 px, every one of
#     them at zero overlap frames. The 1.6 px is depth, and it is the only one
#     under 8 px. Option A, shipped: keep Sit deep (8 ch), the library's own
#     string for this exact cue id, at 1.6 px. Option B: invent a 7-character
#     depth label, which takes 0.64 trailing to 7.2 px - the library has no
#     7-character depth label to borrow, so this costs the one reuse in the
#     five. Either way the slot passes; it is the one to re-measure first if
#     the animation or the framing changes.
#  4. HOW MANY QUADRICEPS ROWS. The paint lights all four heads BRIGHT and all
#     four resolve to quads. One Quadriceps row ships below. Four rows would be
#     literally faithful to the rig and would push the primary legend line from
#     48 characters to 110 against a 40-43 character budget; one row leaves the
#     line at 48 and TARGET MUSCLES still lists quads either way. Both pass
#     validate().
#  5. NINE PAINTED NAMES ARE INVISIBLE, AND TWO ROWS GET NO GLOW. The three
#     glutes, ErectorSpinae, RhomboidMajor, the three Trapezius heads and
#     DeltoidPosterior contribute no pixel a viewer can see in this camera.
#     They keep their rows below, so the activation list matches the rig rather
#     than the render; dropping them would do the reverse, and previous rounds
#     have gone both ways. The owner's standing decision settles only the
#     NAMING of the glutes, not whether a row survives when the shorts hide it.
#     Separately, Obliques (S 0.52, the second-highest secondary) and Gluteus
#     Maximus (S 0.30) get no glow of their own: the rig paints the obliques on
#     the same screen region as the rectus abdominis with 42-48 per cent of
#     their height inside the shorts band, and 100 per cent of the glutes'
#     height is inside it. The jump family made the opposite call and gave its
#     glutes a flagged glow.
#  6. ONE UNSPLIT Trapezius ROW, which is library_cond.md open point 1 and
#     affects five lifts in this family. The rig paints TrapeziusUpper, Middle
#     and Lower; one row ships. Splitting costs +2 rows here (14 in all) and
#     puts all three names past the legend cut, which falls at name 2 or 3.
#  7. THE BALL TYPE IN SETUP STEP 2 TAKES A SIDE ON AN UNMEASURED QUESTION.
#     The step says a ball that does not bounce back, which is what the model
#     is - 98.5 per cent of its horizontal speed goes in the bounce, apex
#     3.41 cm, restitution 0.094 - and what most coaching says. But
#     Bodybuilding.com argues the opposite FOR BEGINNERS, that a dead ball
#     forces the lifter all the way to the floor and into spinal flexion to
#     retrieve it, and recommends a bouncing one. Both arguments are coherent
#     coaching and neither is measured.
#  8. THE SLAM DISTANCE IN SETUP STEP 2. The step gives the model's own
#     number, about 10 cm in front of the shoes - measured in 3-D against the
#     shoe mesh, the ball surface's minimum clearance is +0.1004 m, with its
#     near surface 0.1847 m in front of the toe joints, dead on the midline.
#     That is tighter than most coaching teaches, and the question is
#     safety-shaped rather than cosmetic: the copy directs a beginner to slam a
#     30 cm ball a hand's width from their own shoes. What makes it safe in the
#     clip is that the model's ball is dead - it loses 98.5 per cent of its
#     horizontal speed in the bounce - and step 2 can ask for a non-bouncing ball
#     but cannot enforce one. OPTION A (taken): keep the model's own 10 cm.
#     OPTION B: a rounder, further figure such as a foot or 30 cm; the cost is
#     disagreeing with the animation by a visible amount, 0.10 m of world being
#     about 25 px on this 382 px frame.
#  9. THE SECONDARY LEGEND LINE IS 135 CHARACTERS, four short of the library's
#     all-time maximum (139, Dumbbell Clean and Press). Nine names, of which
#     the reader sees two at 40 characters and three at 43: LATERAL DELTOID
#     ends at exactly 43, so it is whole on a 393 pt phone and cut on a 375 pt
#     one - and cut at the real secondary budget of 41, since PRIMARY and
#     SECONDARY are separate Text views in the same HStack and the longer rank
#     word steals about 2 characters from the name line. Reordering inside the
#     four-way 0.30 tie gains zero names, because the cut falls before the tie
#     begins. The primary line is 48 characters and loses ANTERIOR DELTOID
#     (positions 33-48) on every viewport. Nothing is lost from TARGET MUSCLES
#     by truncation - Sheets.swift:95 is an uncapped ForEach - and all twelve
#     names resolve through part_of(), so none is silently dropped.
# 10. THE GLOW PROBE ALIASES PERFECTLY AND MISSES THE WHOLE LIFT. glow()
#     averages joints.json's EIGHT probed moments; on this lift moments 0, 2, 4
#     and 6 are identical to 3 dp and match clip f0 (the chest hold) and
#     moments 1, 3, 5 and 7 match f24, f24, f23 and f23 (mid-descent), because
#     the probe samples one second apart and the rep is exactly 2.000 s. So
#     every centre is a 50/50 blend of standing and mid-descent, with NO probe
#     moment anywhere near the overhead reach (phase 11) or the slam (phase
#     18), and two of the five glows below needed an explicit dy to land on
#     paint the render actually shows. A glow on the overhead position is not
#     obtainable from glow() at all; it would need an explicit (cx, cy).
# 11. FOR THE RECORD, AND UNIQUE IN THIS FAMILY: this lift's load never leaves
#     the visible frame, so every distance quoted about the ball is both raw
#     and clipped and a reader sees exactly what the numbers say. The ropes,
#     the sleds and the chest pass all needed clipping.
ex(name="Medicine Ball Slam", var="medicineBallSlam",
   overrides={"reach": (0.14, "trailing"), "hinge": (0.32, "trailing"),
              "drive": (0.50, "trailing"), "depth": (0.68, "trailing"),
              "feet": (0.86, "trailing")},
   annotations=[
       ("reach", "Reach tall", "upper_arm_L"),
       ("hinge", "Hinge", "pelvis"),
       ("drive", "Slam it", "chest"),
       ("depth", "Sit deep", "patella_L"),
       ("feet", "Feet set", "foot_L"),
   ],
   cues={
       "reach": ("Reach Overhead",
                 "You take the ball from your chest and reach it straight overhead with your arms long.",
                 "The reach is f4..f12 of a 48-frame rep - 9 frames, 0.3333 s of elapsed time - and it is almost all shoulder. Shoulder flexion, measured as the upper-arm-to-wrist vector against straight down, goes 44.9 deg to 166.18 at f11, while the elbow only opens 75.37 to 149.29 and the knee comes back no further than 163.73. The ball rises from y 1.1789 m to 2.1211 at f12, its top surface at 2.2711, and the wrists peak at y 1.9593, which is 0.3674 m above the standing head height of 1.5919. It travels backwards as it rises - ball z 0.3738 to 0.0280 at f11, essentially straight above the pelvis, whose own z range is -0.1000 to 0.0100 - and it never comes near the face: the smallest clearance from the ball surface to the head joint anywhere in the clip is 0.2880 m, and to the neck 0.2914 m. The trunk goes 5.5434 deg PAST vertical into a backward lean at f11, and both heels leave the floor, foot_L 4.015 cm and foot_R 4.008 cm, above 1 cm over f7..f14. The library badges LEANING BACK on 16 blocks and ARCHING THE LOWER BACK on 2, and 5.54 deg is not enough to badge. No EMG study of a medicine ball slam exists, so nothing here names a muscle: Tsartsapakis 2025 plans exactly that measurement and is written in the future tense with no data.",
                 "Pressing the ball up with bent elbows, or arching the lower back to get it overhead instead of reaching through the shoulders.",
                 "Take the ball from your chest straight up over your head in one move, arms long, until it is stacked right above your hips, and let your heels come up as you reach."),
       "hinge": ("Fold At The Hips",
                 "On the way down you fold forward at the hips while your back stays long.",
                 "The fold is at the hip and almost nowhere else. hip_L runs 170.9145 deg to 74.8139, a 96.1006 deg range clip-wide and 94.42 deg within a rep, while the lumbar chain from pelvis to spine to chest flexes only from 171.879 deg at rest to 166.479 at f22 - 5.400 deg against rest, and 6.900 deg clip-wide, because that same chain EXTENDS to 173.379 in the overhead reach - and the thoracic chain from spine to chest to neck goes 174.067 to 161.467, 12.600 deg against rest and 16.100 clip-wide. Segment lengths are rigid to 3e-07 m, so none of that is rig stretch. The head tucks 17.650 deg, the chest-neck-head angle going 175.433 to 157.783 at f28: the model is looking at the ball at the bottom, not up. And the hips drop far more than they travel back - pelvis y 0.9357 m to 0.4799, a 45.58 cm fall, against a z range of 0.11 m in total, 0.0000 at f0, 0.0067 at f12, -0.0600 at f19 and -0.1000 at f28 - which is why the pill says Hinge rather than the library's Hips back, a string whose own lifts send the hips much further behind them. Coaching is unanimous that the commonest slam fault is spinal flexion on the way down and that the fix is a hinge, but no source found is a standards body and none cites a measurement.",
                 "Rounding the lower back to drive the ball down, or bending at the waist with the hips left under you.",
                 "Send the ball down by folding forward at your hips, and keep your back long from your hips to your head the whole way - the bend belongs at the hip, not in your spine."),
       "drive": ("The Slam",
                 "You throw the ball down in front of you with your whole body, not with your arms.",
                 "The slam is f12..f19, 8 frames and 0.2917 s, and the arms do not pull. The elbow is 149.29 deg at f12, 157.49 at f18 and 156.64 at f19, then 165.46 at f20 and its clip maximum 167.6511 at f21 - after the ball has already hit the floor - so it OPENS about 18 deg across the throw. What moves is the trunk: -3.82 deg to 38.34, which is 42.16 deg across 7 intervals at a mean 145 deg/s, with hip 170.58 to 133.53, knee 163.73 to 135.63 and the wrists falling from y 1.9593 to 0.9591. The ball goes down and FORWARD first, z 0.0714 to 0.8843 at f18, then back to 0.8119 at f19, and lands at f21, t 0.875, at 8.7188 m/s vertically and 3.9830 m/s horizontally, 9.5853 m/s resultant. It is welded to the hands over f0..f19 and f28..f47, the wrists holding a fixed 0.188053 m radius, and free only over f20..f27. There is no catch: at the instant of impact the wrists are 0.4882 m ABOVE the ball centre and they do not touch it again for 0.2917 s. One frame of the release is scripted rather than ballistic - the f19-to-f20 interval shows -25.688 m/s2, about 2.6 g, and only f20-to-f21 is at g, -9.810, which is g to 0.04 per cent - so nothing here is built on the release instant.",
                 "Pulling the ball down with the arms while the trunk stays upright, or chasing it to the floor instead of letting it go.",
                 "Throw the ball down hard in front of you with your hips and trunk, keeping your arms long rather than pulling with them, then let it go and let it land."),
       "depth": ("Squat To The Ball",
                 "After the ball lands you squat all the way down to it, pick it up and stand back up.",
                 "The pick-up is the biggest part of the rep and nobody has written about it: 28 of the 48 frames of a rep - 27 intervals, 1.1250 s of the 2.0000 s rep, 58 per cent - is the descent, the bottom hold and the stand. The descent is f19..f28, 10 frames and 0.3750 s: knee 135.63 deg to 61.9026 at a mean 196.6 deg/s, hip 133.53 to 74.81, trunk to its clip maximum 56.5450 at f26 and 56.33 at f28, the ankle 95.05 to 64.14 against 105.41 standing, the pelvis 0.8396 m to 0.4799 - 35.97 cm below where the slam left it and 41.92 cm below standing - and the head 1.3763 to 0.8831. At the bottom the HIP joint is 0.1120 m ABOVE the knee joint and the thigh slopes 15.09 deg down from hip to knee, so the squat stops just ABOVE parallel on the usual hip-crease-to-knee reading even though the knee itself is deeply flexed at 61.9026 deg - the hip is above the knee on all 192 frames, so no string here asks for depth below parallel, and the depth a lifter actually needs is whatever gets two hands under the ball with a long back. The bottom is frozen over f28..f30, 3 frames and 2 intervals, 0.0833 s, every joint identical to 0.001 mm, with the hands back on the ball at the same 0.188053 m radius. The stand is f31..f46, 16 frames and 0.6250 s, and the elbow re-folds 148.66 deg to 75.20 over the last six of them, re-racking the ball at the chest. No study, no library badge and no coaching source addresses this pick-up. The nearest measured figure is a RATE: Faigenbaum 2018, 14 children of mean age 10.1 years with a 2.3 kg ball, managed 15.1 then 16.1 double-arm slams in 30 s, about one every 1.9 to 2.0 s, which is this clip's own 2.000 s rep, at 62.8 and 63.6 per cent of VO2peak and 88.8 and 89.6 per cent of peak heart rate. Its authors say the protocol was not built to separate the exercises and that each row is confounded by fatigue from the one before, so it is a rate and a cost and not a muscle claim.",
                 "Snatching the ball up off the floor with straight legs and a rounded back instead of squatting down to it.",
                 "Keep going down after the slam: squat right down to the ball with your hips back and your back long, pick it up in both hands and stand all the way up with it at your chest."),
       "feet": ("Feet Stay Set",
                "Your feet stay where you set them, and your heels only leave the floor as you reach overhead.",
                "The feet never move and the heels move once. anklegap runs 0.3800 to 0.3933 m, and that 1.33 cm is the ankle joints rotating rather than a step, against a shouldergap that is a dead constant 0.392155 m with a range of 3.11e-07 m - so the stance is shoulder-width. toe_L and toe_R travel 0.00033 mm and 0.00049 mm over all 192 frames: there is no step, no stance reset and no stance change anywhere in the clip. The heel is the one thing that leaves the floor, and it does it in the reach rather than in the squat. foot_L rests at 0.068600 m, is above 1 mm from f5, above 1 cm over f7..f14, peaks 4.015 cm up at f11 with foot_R at 4.008, and is back at its rest height to within 0.00025 mm for every frame of f20..f31 - the whole slam, the descent, the squat and the stand. So flat-footed is true of the half of the rep that loads the knee and false of the reach, and no string here may claim either half on its own. What the bottom asks of the ankle is real: 64.14 deg at f28 against 105.41 standing, which is 41.27 deg of dorsiflexion, achievable but not universal. The library badges HEELS LIFTING on 3 blocks, all of them squats, and that badge is wrong for this lift: here the heels lift on purpose.",
                "Stepping or shuffling the feet between reps, or letting the heels peel off the floor at the bottom of the squat.",
                "Set your feet about shoulder-width and leave them there - your heels come up as you reach overhead, then stay down through the slam and the whole squat."),
   },
   # Rows, fractions and stabilisers exactly as the row stage settled them
   # (rows_cond.md 4.7 and 8.7): TWELVE rows, three primary, fraction
   # descending inside each rank, which ties the all-time maximum row count.
   # Standing Cable Crunch :41975 is the exact movement parent - a standing
   # overhead-to-hip trunk flexion against resistance - and both of its rows
   # come across intact: Rectus Abdominis P 0.86 (:42045, also Cable Crunch
   # :11514) and Obliques S 0.52 (:42046). Rectus Abdominis at the head of the
   # list is also this entry's own library row word, RECTUS ABDOMINIS, which is
   # where it belongs on a .core entry. Quadriceps P 0.62 carries from Clean and
   # Press :45624; Anterior Deltoid P 0.40 is the overhead-THROW family's value
   # (Power Snatch :49206, Barbell Clean and Jerk :49700, Split Jerk :49798) and
   # not a pressing value, because the arms reach overhead and then drive down
   # rather than press up. Secondaries: Erector Spinae 0.55 (Clean and Press
   # :45629), Lateral Deltoid 0.40 (Barbell Front Raise :24609), Trapezius 0.36
   # (Push Press :22548), Biceps Brachii 0.30 (Barbell Upright Row :25383),
   # Posterior Deltoid 0.30 (Lat Pulldown :5683), Gluteus Maximus 0.30 (Back
   # Extension :6404), Hamstrings 0.25 (Hack Squat (Stances) [Standard] :3158).
   # ELEVEN OF THE TWELVE ARE SAME-NAME, SAME-RANK, SAME-FRACTION CARRIES. The
   # twelfth, Rhomboids S 0.30, is this family's ONE ESTIMATE (rows_cond.md 5):
   # there is nothing to carry, since Rhomboids has exactly one secondary row in
   # the whole library, and the same estimate is used on Sled Drag and both
   # battle ropes. NOT ONE FRACTION HERE IS A MEASUREMENT OF A SLAM, because
   # none exists - see the sources comment. The trapezius ships as one unsplit
   # row although the rig paints three bands (open point 6), the four bright
   # quadriceps heads as one row (open point 4), and the three glutes as the
   # single Gluteus Maximus row the owner's standing decision requires.
   activation=[("Rectus Abdominis", P, HI, 0.86), ("Quadriceps", P, MOD, 0.62),
               ("Anterior Deltoid", P, MOD, 0.40),
               ("Erector Spinae", S, MOD, 0.55), ("Obliques", S, MOD, 0.52),
               ("Lateral Deltoid", S, MOD, 0.40), ("Trapezius", S, LOW, 0.36),
               ("Biceps Brachii", S, LOW, 0.30), ("Posterior Deltoid", S, LOW, 0.30),
               ("Gluteus Maximus", S, LOW, 0.30), ("Rhomboids", S, LOW, 0.30),
               ("Hamstrings", S, LOW, 0.25)],
   # Judgement, not paint: a stabiliser is by definition a muscle the rig does
   # not light, so tiers_cond.json can only VETO one, and none of these three is
   # painted on this lift. latissimus dorsi (32 shipped uses) goes first because
   # Standing Cable Crunch :41975, the movement parent, lists it first and it
   # drives the overhead-to-floor pull; forearms (53) is where a two-hand hold
   # on a 0.300 m ball goes, and no forearm mesh is painted here so it could not
   # take a row; transverse abdominis (39) rather than core (279) because
   # Rectus Abdominis already leads the table, which is the house habit (Bear
   # Crawl :44948 does the same). Three is the shipped mode, 196 blocks of 466.
   # No list in this entry names the gluteus medius, per the owner's standing
   # decision - it is otherwise the library's fourth most common stabiliser.
   stabilisers=["latissimus dorsi", "forearms", "transverse abdominis"],
   # ROUNDED LOWER BACK is the library's own badge, 7 uses and the most
   # precedented of four near-duplicate spellings, and this is the first time it
   # sits on a ballistic lift. It is the right badge for the jump family's
   # reason: it is the fault every coaching source names for this exercise, AND
   # THE MODEL DEMONSTRATES THE CORRECT SIDE OF IT EXACTLY, which is the best
   # thing a comparison can have. correctNote is therefore a measurement, not an
   # argument. mistakeNote names the only mechanistic evidence there is, with
   # its species and its segment, and claims no dose, no activation and no
   # injury outcome - no study has tested a rounded back on a slam, and none
   # shows that any cue here changes an injury rate. The alternative badge,
   # which would have been new, is in open point 2.
   comparison=("ROUNDED LOWER BACK", "Back long, fold at the hips",
               "Lower back rounds to reach the ball",
               "The model does the correct version, measurably. The lumbar chain from pelvis to spine to chest flexes only 5.400 deg from its resting 171.879, to 166.479 at f22, and 6.900 deg across the whole clip, while hip_L folds 96.1006 deg from 170.9145 to 74.8139. The thoracic chain gives up 12.600 deg from rest. Segment lengths are rigid to 3e-07 m, so none of that is rig stretch, and the head tucks 17.650 deg at the bottom because the model is looking at the ball.",
               "Coaching is unanimous that the commonest fault in a slam is spinal flexion on the way down and that the fix is a hip hinge, but none of the sources found is a standards body and none cites a measurement. The only mechanistic evidence is Callaghan and McGill 2001, which took porcine cervical spinal units through up to 86 400 bending cycles at 1 Hz in vitro and saw repeated flexion initiate posterior annular herniation at modest compression - neither a human nor a lumbar spine, and no dose. No study has tested a rounded back on this lift."),
   # FIVE glows for twelve rows, which is normal for a long table (Dumbbell
   # Clean and Press carries 12 rows and 6 glows, Kettlebell Windmill 10 and 3).
   # One glow per painted REGION that the render actually shows, plus one
   # honestly-flagged glow for the posterior group. Every centre is glow()'s own
   # eight-moment mean, which on this lift is a 50/50 blend of the chest hold
   # and mid-descent (open point 10), and the two dy values are the only
   # adjustments:
   #   quads      mean (0.623, 0.644), no nudge. It lands inside the measured
   #              paint: at still t0 the bright pixels run 1 857 at v 0.60-0.65
   #              and 1 305 at v 0.65-0.70, and the two thigh boxes are 52.6 and
   #              21.4 per cent lit. This is the clearest paint on the model.
   #   abs        mean (0.569, 0.524) lands in the SHORTS band, where t0 holds
   #              only 327 lit pixels at v 0.50-0.55; the standing-pose value is
   #              v 0.446 and the abdomen band v 0.45-0.50 holds 2 006. dy=-0.05
   #              puts the centre at v 0.474, between the two.
   #   frontdelt  mean (0.574, 0.455); the standing-pose value is v 0.380 and
   #              the shoulder band v 0.35-0.40 holds 1 154 lit pixels at t0.
   #              dy=-0.06 puts it at v 0.395. NOTE: in joints.json
   #              deltoid_arc_clavicle_2_L/R and upper_arm_L/R carry IDENTICAL
   #              probed values on this lift, so without this nudge the delt and
   #              upper-arm glows would sit exactly on top of each other.
   #   upper arm  the dim biceps and lateral deltoid, SOFT. Taking the mean of
   #              the shoulder and the elbow gives (0.567, 0.501), which is
   #              where the muted dark red reads in both stills.
   #   posterior  the dim erector spinae, rhomboid and three trapezius bands,
   #              mean (0.610, 0.488), SOFT and flattest. IT MARKS THE REGION
   #              AND NOT VISIBLE
   #              PAINT, and the evidence is the camera: all six names sit on
   #              the far side of the body from this 45.8 deg three-quarter
   #              front view on every one of the 192 frames, and no lit pixel
   #              appears for any of them in either distinct still. It is kept,
   #              flagged, for the same reason the jump family kept its glute
   #              glow; the glutes and the obliques here got neither a glow nor
   #              a flag, which is open point 5.
   glows=[glow("Medicine Ball Slam", ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.55, rx=0.11, ry=0.075),
          glow("Medicine Ball Slam", ["support_PectoralisMajor_Abdominal_L", "support_PectoralisMajor_Abdominal_R"], A, 0.55, rx=0.085, ry=0.06, dy=-0.05),
          glow("Medicine Ball Slam", ["deltoid_arc_clavicle_2_L", "deltoid_arc_clavicle_2_R"], A, 0.50, rx=0.09, ry=0.045, dy=-0.06),
          glow("Medicine Ball Slam", ["upper_arm_L", "upper_arm_R", "forearm_L", "forearm_R"], SOFT, 0.30, rx=0.10, ry=0.06),
          glow("Medicine Ball Slam", ["spine", "scapula_L", "scapula_R"], SOFT, 0.28, rx=0.10, ry=0.07)])

# instructions() is the ONLY ungated surface: it shows these steps and, for each
# cue, its title and its correct string. Nothing else in the entry reaches a
# free reader - not the intro, not the why, not the pill label, not the
# comparison, and mistake sits behind the trainer AND the paywall. So the three
# things this lift needs that its name does not give are all here or in a
# correct string: the ball does not come back, the pick-up is more than half of
# every rep and that squat is where the back works (Part 6 of
# sources_safety.md), and the space overhead and in front has to be clear.
# Step 2 carries the model's own aiming distance and takes a side on the ball
# type - open points 7 and 8. Step 4 is the sentence Part 6 asks for, and it
# also stops the reader treating the slam as the whole rep. Library budget:
# median 61 characters, p90 96, p99 140, longest ever 214; these five are 110,
# 104, 108, 128 and 118, all inside the 135 the round brief sets.
SETUP["Medicine Ball Slam"] = [
    "Stand with your feet about shoulder-width, a medicine ball in both hands at your chest, and your trunk braced.",
    "Use a slam ball that does not bounce back, and aim at a spot about 20 cm in front of your toes.",
    "Clear the floor in front of you and the space overhead, and keep your eyes on the ball as you go down to it.",
    "Expect over half of every rep to be the squat down to the ball and the stand back up - that squat is where your back is working.",
    "Stand all the way up with the ball at your chest before you start the next rep, and keep your feet where you set them.",
]
