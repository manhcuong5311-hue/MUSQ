# Trainer content for the model-only exercises of 2026-10-29, family "jump":
# the four lifts that leave the floor on the lifter's own legs and shipped with
# a model but no coaching - Box Jump (Legs/BoxJump), Step-Up Jump
# (Legs/StepUpJump), Squat Jump (Legs/SquatJump) and Jump Rope (Legs/JumpRope).
# Same format as spec.py on top of common_1_50.py; spec_1029.py imports this
# module and gen.py reads SPEC / SETUP. notes_1029_jump.md maps every claim in
# the copy to the sources below or to a model measurement.
#
# HOW THE MODELS WERE MEASURED. The round folder's meas.py opens each rig with
# pxr, reads every joint's world transform and every equipment mesh's points at
# every integer frame and projects both through that lift's own trainer framing
# (jobs.py, copied from the app's modelByExercise); room.py, lead.py, chk.py
# and anchor.py do the label geometry; tiers_jump.json carries the paint.
# Frame: Y up, the lifter faces +z, their left is +x, metres. Knee, hip and
# elbow are inner angles (180 straight) and trunk is the neck-over-pelvis line
# from vertical, positive forward; the rig joint called forearm_* IS the elbow
# and hand_* is the wrist. The ankle angle is not in the published A block: it
# is the inner angle shin-foot-toe, computed per side from the joint positions,
# and both sides are quoted where a cue needs the pair.
#
# THREE TRAPS THIS FAMILY SETS, all of which cost this round time:
# (1) BOX JUMP AND STEP-UP JUMP RUN 384 FRAMES, 15.958 s at 24 fps, twice every
#     other clip in the round. Squat Jump and Jump Rope run 192. Nothing in
#     either of the first two entries is counted per 192 frames, and every
#     per-frame figure in them is out of 384.
# (2) SQUAT JUMP CARRIES NOTHING. eq_names is empty and eqc, eqbox and eqpts
#     are empty lists on all 192 frames, so room.py prints load distance
#     1000000000.0 px and 0 inside-frames at all ten of its slots and no label
#     on that lift can cross a load. Any code that reads eqpts for this family
#     has to guard for it.
# (3) THE RIGS ARE SKINNED. UsdGeom.Mesh.GetPointsAttr().Get(t) on a body mesh
#     returns the REST pose at every time code, so projecting mesh points
#     directly gives a standing silhouette that never moves - useless on clips
#     where the lifter crosses 243 px of frame. Every geometry figure below
#     comes from the pre-computed _A.json / _SIL.npz / _HEAD.npz instead.
#
# THE LIFTER'S SILHOUETTE comes from sil.py, which evaluates UsdSkel
# linear-blend skinning at every frame over all the skinned meshes and bins the
# result into 655 v rows, one per rendered pixel row. joints.json is not a
# substitute: it holds only eight samples per joint, and gen.py uses them to
# choose a default row while the app tracks the live joint every frame
# (Exercise3DView.dotPoint). On Jump Rope those eight samples are worse than
# sparse - the clip's pose repeats every 12 frames and the probe samples every
# 24, so all eight land on the same phase and the model looks motionless in
# them and in stills/jump-rope_t0..t7.png, which are eight copies of one
# instant. A pill must clear the lifter at EVERY pixel row inside its band, so
# the per-frame gap is the MINIMUM over rows of max(u0 - umax, umin - u1), as
# chk.py and room.py do it; taking the maximum over rows over-reads every slot.
#
# THE HEAD'S SILHOUETTE comes from headsil.py, which keeps only the skinned
# vertices whose dominant UsdSkel influence is root/pelvis/spine/chest/neck/
# head and bins those per row the same way. Both easy versions are wrong in
# opposite directions, as the jerk round found and this family confirms: a box
# round the head JOINT is far too small, because that joint sits at the base of
# the skull and the crown of the drawn head is 36.8-39.3 px above it on Box
# Jump and 36.9-38.5 px on Squat Jump; and the whole body at head height is far
# too big, the head being 0-38.8 px wide in its own rows on Squat Jump where
# the full silhouette there reaches 165.8 px. A leader is on the FACE only if
# it falls inside the head's own min/max u at some row the head occupies, which
# is what lead.py and chk.py test at every frame.
#
# THE VIEW. Box Jump and Step-Up Jump share yaw -1.3 rad and Squat Jump and
# Jump Rope yaw -0.8. At -1.3 the camera depth is 0.9636*x + 0.2675*z, which is
# very nearly a pure profile from the lifter's LEFT - on Step-Up Jump scapula_L
# sits 274.5 mm nearer the camera than scapula_R while the chest is only 5.8 mm
# nearer than the spine. At -0.8 it is the three-quarter view the jerk family
# records, and whether that is a front or a rear three-quarter is the same open
# question there and nothing below depends on it. What is not in doubt is the
# side, which is what the labels needed: the lifter's LEFT reads at HIGH u, at
# the frame's trailing (right) edge, on all four clips. No cue below names a
# near or a far side and no cue claims a muscle faces the camera. On three of
# the four lifts every glow is placed on both sides, and A against SOFT is the
# paint tier alone; the exception is Step-Up Jump, whose paint is itself
# one-sided (13 of its 14 meshes carry an explicit (L)), so five of its six
# glows sit on the left leg only and the sixth spans both thighs because the
# sartorius is its one two-sided mesh. That is the paint, not a depth claim.
#
# WHAT EACH CLIP HOLDS. The per-lift comments carry the full measure; these are
# the shapes.
# - Box Jump (yaw -1.3, zoom 0.664, offset [0.054, -0.045, -0.194]). 384
#   frames, TWO identical reps on a period of exactly 8.000 s found by a
#   CIRCULAR lag sweep (0.000679 mm at lag 192 against 222.2499 mm at 191 or
#   193; a linear sweep finds nothing, because the standing hold is split
#   across the loop seam). One jump UP and no jump down: the only flight in 384
#   frames is 11 frames, 0.458 s, and the way down is a 2.125 s two-step climb
#   led by the right foot in both reps. 160 of the 384 frames, 41.7%, belong to
#   a frozen pose, which is 156 frame intervals - 6.500 s of the 15.958 held
#   still. Frame COUNTS are used for shares of the clip and frame INTERVALS for
#   durations in seconds, in this entry and the next.
#   Equipment is scenery - one mesh, Cube, 0.840 x 0.380 x 0.640 m, bbox
#   bit-identical on all 384 frames and 0.000000 of screen travel. Paint: 14
#   meshes, 7 bright, 7 dim, nothing faint, nothing one-sided.
# - Step-Up Jump (yaw -1.3, zoom 0.743, offset [0.062, -0.065, -0.225]). 384
#   frames, two byte-identical 192-frame reps (the halves agree to 0.0009 mm);
#   3.708 s of every 8.000 s cycle is a dead freeze in the set-up pose. NOBODY
#   STEPS UP: the left foot is over the box footprint in 384 of 384 frames, the
#   right foot starts and ends at the identical point on the floor, and the
#   lifter is never on the box with both feet, so this is a one-leg vertical
#   jump taken FROM a box and the left leg leads in both reps. Same Cube, same
#   zero travel. Paint: 14 meshes, 8 bright, 6 dim, and 13 of the 14 carry an
#   explicit (L) - the one one-sided model in the family.
# - Squat Jump (yaw -0.8, zoom 0.67, offset [0.02, -0.077, -0.021]). 192
#   frames, THREE identical reps of 64 frames = 2.6667 s (lag 64 agrees to
#   0.000524 mm, next nearest lag 276.5 mm), 1.458 s of it a frozen stand. NO
#   EQUIPMENT at all. The lift's own defining measurement: the ankle is the one
#   joint that goes PAST its standing angle. The hip and knee do extend fully -
#   knee 84.10 at the bottom of the dip to 167.01 at take-off, 82.9 degrees,
#   hip 93.40 to 166.87, 73.5 - but they stop at the pose the rig stands in,
#   which is also the clip's global maximum (knee 167.01 / 167.28, hip 166.91 /
#   166.92, within 0.27 degrees of take-off). So 167 IS this rig's straight,
#   and what nothing here may say is that the model goes past its standing
#   angle at the hip or knee, or that the knee reaches 180 degrees. The ankle
#   runs 104.99 to 146.58, 41.6 degrees past standing. Paint: 13 meshes, 10
#   bright, 3 dim, nothing one-sided.
# - Jump Rope (yaw -0.8, zoom 0.575, offset [0.049, -0.04, -0.05]). 192 frames
#   and SIXTEEN identical bounces: every probed joint satisfies
#   |J[f] - J[f+12]| = 0.000 mm over all 180 valid pairs, so the clip is 16
#   cycles of 0.50000 s, 120 bounces a minute, with no set-up and no finish
#   frame. The upper body is a pure vertical elevator - trunk frozen at 2.5793
#   degrees with 0.00000 range, and pelvis, spine, chest, neck, head, both
#   clavicles, both scapulae and both upper arms each 0.000 mm of x and z range
#   - and the rope is animated past hands that never move, so no cue is written
#   as a wrist-circle demonstration. Paint: 10 meshes, 3 bright (both
#   gastrocnemius heads and the soleus) and 7 dim, nothing one-sided.
#
# HOW THE FOUR READ AS ONE. Where the cue is the same across lifts the label
# string is the same, and it is the library's own string wherever the library
# has one: `Heels lift` (10, the Dumbbell Clean and Press's own label written
# in this round, deliberately inverting the library's `Heels down`) on all
# three lifts whose heel measurably peels off a planted forefoot - Box Jump's
# leg drive, Squat Jump's drive and Jump Rope's ankle drive - each on its own
# foot_L or foot_R anchor; and `Soft knees` (10, x3 in the library on the
# Romanian deadlifts) on both two-foot landings, Box Jump and Squat Jump. The
# one deliberate difference is Step-Up Jump's `Soft knee` (9, x3 in the library
# on the three Single-Leg Romanian Deadlifts, the library's own one-legged
# lifts), singular because that lift measurably lands on ONE leg: the lead foot
# is back on the box at 2.167 s and the other foot does not reach the floor
# until 4.500 s. What the three landing pills do NOT share is the knee they
# point at - patella_R on Box Jump against patella_L on the other two - and
# that is a MARGIN preference, not a forced measurement: lead.py reports BOTH
# patellae clear 0/384 and 0/192 frames of the head's own silhouette from all
# three landing slots. On Box Jump the two differ enough to decide it
# (patella_R 13.4 px against patella_L 7.5 px from 0.16 leading, and that slot
# puts 16 of the 26 joints on the face, so the margin is worth having); on
# Step-Up Jump's 0.80 leading and Squat Jump's 0.80 leading the slot sits below
# the head's own rows entirely, so no leader from it can reach the head and the
# choice is free. The cue ID is `land` on all four, the library's own id for it
# (plyometricPushUpContent/land). The badges do NOT follow one rule, and the
# reason is per-lift: Box Jump and Step-Up Jump share STIFF-LEG LANDING,
# modelled on the library's one landing badge (Plyometric Push-Up's STIFF-ARM
# LANDING), because the fault is the same one; Squat Jump carries the library's
# own KNEES CAVING IN (squatContent at SampleData.swift:12347 and three more),
# because the knees on a repeated two-foot landing are the fault that lift
# genuinely owns and its model demonstrates the CORRECT side of it; and Jump
# Rope keeps DRIFTING OFF THE SPOT, because nothing it lands from is high
# enough for a landing badge (the toe rises 5.2 cm and the knee's whole range
# is 16 degrees).
# Where the labels differ because the LIFT differs they say so. The dip is
# `Dip and swing` on Box Jump, whose one cue covers the countermovement and the
# arm swing together; `Hips back` on Squat Jump, which spends a second cue on
# the arms and whose hips measurably travel 15.00 cm rearwards; and `Slight
# lean` on Step-Up Jump, whose pelvis drops only 0.015 m while the trunk
# pitches to 27.5 degrees, so it leans rather than sits back. None of the three
# reuses the library's `Dip straight down` (17, x5 on the Push Press, Dumbbell
# Push Press, Barbell Clean and Jerk, Split Jerk and Push Jerk), because those
# five hold the trunk inside a degree of vertical where these take it to 33.45,
# 41.08 and 27.46 degrees forward. `Chest up` (8, x10, and ALL TEN are squats -
# squatContent, Cossack, Dumbbell Sumo, Barbell Sumo, Kettlebell Goblet, Pause,
# Overhead, Landmine, Heel-Elevated and Smith Machine Front) is Box Jump's
# SET-UP label, where the trunk is 1.58 degrees forward, and is explicitly
# refused as Squat Jump's DIP label, where it would contradict 41.08 degrees -
# the same string, two phases, and both entries say which.
# ONE CONVENTION IS SHARED BY ALL THREE LANDING CUES and it is not measured on
# any of these four lifts: the knees track out over the toes. It is carried
# because the library already badges it SIX times (KNEES CAVING IN at
# SampleData.swift:6534, 12347, 16842, 31165, 32592 and 47476, one of them
# squatContent, this family's own row parent; five of the six pair it with the
# mistakeCue `Knees collapse inward` and :32592, wideStanceLegPressContent,
# with `Knees cave in toward each other`), because a repeated landing from
# flight is
# where it matters, and because on Squat Jump the model demonstrates the
# correct side of it exactly - knee to knee 0.3022 m standing to 0.5062 m at
# the bottom of the dip over ankles frozen 0.3000 m apart. Jump Rope is the one
# lift of the four that does not carry it, because it has no landing to
# mistrack: the toe rises 5.209 cm and the knee's whole range is 15.93 degrees.
# The ROWS read as one through the paint and not through the copy: the dim calf
# of Box Jump and Step-Up Jump ships two LOW 0.30 rows while the bright calf of
# Squat Jump and Jump Rope ships Gastrocnemius 0.78 and Soleus 0.60, and the
# four entries hand the owner the same open point about it - the calf TIER runs
# opposite to the measured ankle travel, Box Jump moving the ankle 63.86
# degrees and Step-Up Jump about 75 over the drive (80.49 over the whole clip)
# on dim paint while Jump Rope moves it 25.92 on bright paint. Those ankle
# figures were RE-MEASURED for this module off the _A.json joint positions
# (inner angle shin-foot-toe, left leg): Box Jump 78.72 at t 2.333 to 142.58 at
# t 1.667 and Jump Rope 103.571 to 129.494. rows.md open point 1 quotes 62.3
# and 26.2 for the same two spans; those two figures are stale, and the module
# does not disagree with that open point about anything else.
#
# THE BOUNDARY ON WHAT THE COPY MAY CLAIM, first, because it governs every
# fraction below. THERE IS NO %MVIC-NORMALISED EMG STUDY OF ANY OF THESE FOUR
# LIFTS. There is no peer-reviewed EMG study of the box jump as its own
# exercise, none of a step-up jump at any height, none of a bodyweight squat
# jump, and none of rope skipping with a %MVIC normalisation; nothing in this
# literature measures sartorius, gluteus minimus or vastus intermedius at all,
# and two of those three are too deep for surface EMG. So NOT ONE fraction in
# this module is ranked on measured activation of its lift: every one is
# carried from the nearest library entry or marked in its own comment as an
# estimate, every rank follows the paint in tiers_jump.json, and no cue claims
# a muscle works hardest in any phase of any of these four lifts. Two further
# limits are kept throughout: a between-condition percentage is never written
# as a %MVIC or as a fraction, and any %MVIC above 100 in a jumping task is
# treated as a normalisation artefact (Phillips 2025, below) and never carried.
#
# Sources (what each is used for is in notes_1029_jump.md). Every record was
# read on 2026-10-30.
# - Janikov MT, Padecky J, Doguet V, Tufano JJ 2023, Countermovement, hurdle,
#   and box jumps: data-driven exercise selection, J Funct Morphol Kinesiol
#   8(2):61, doi 10.3390/jfmk8020061, PMID 37218857: 20 recreationally trained
#   men, 25.2 +/- 3.5 y; force platforms plus a linear position transducer,
#   three reps each of a maximal countermovement jump, a 50 cm hurdle jump and a
#   jump onto a 50 cm box. NO EMG. The box jump reduced peak IMPACT force by
#   about 51% against the other two, with no difference in peak velocity, peak
#   vertical force, peak resultant force or total impulsion time - propulsion
#   indistinguishable, impact roughly halved, in the same 20 men. The only study
#   measured on a box jump. Cited in Box Jump's landing cue.
# - Dos Santos ML, Shields J, Berton R, Dinyer-McNeely T, Trevino M, Anderson O,
#   Dawes JJ 2024, Does box height matter?, Int J Exerc Sci 17(1):720-729, doi
#   10.70252/mtls9089, PMID 38863787: 14 recreationally active men (20.8 +/-
#   4.1 y) and 17 women (20.8 +/- 2.1 y), college students; box jumps at 0, 20,
#   40, 60 and 80% of each subject's own maximal box jump height for peak force,
#   RFD, peak power, jump height and time to take-off. No EMG. Peak force was
#   higher at 80% than at 0% in the WOMEN only (p = 0.001), with no significant
#   difference on any other variable in the men or at any height below 80% in
#   the women. Cited in Box Jump's set-up cue, as the reason no box height is
#   prescribed anywhere in this module.
# - Glassbrook DJ, Dorman CA, Doyle TLA, Wade JA, Fuller JT 2024, A kinetic
#   analysis of four high velocity, horizontally focused step-up variations for
#   acceleration training, Eur J Sport Sci 24(8):1086-1094, doi
#   10.1002/ejsc.12150, PMID 38886980 (read in full): 10 professional male rugby
#   league players, in-season, 24.9 +/- 2.7 y and 108.2 +/- 8.8 kg, a 600 Hz
#   force plate under a 41.5 cm box; peak vertical force, total impulse and
#   maximal rate of force development from first foot contact. NO EMG. The
#   step-up jump produced 63.5 +/- 7.2 N/kg of peak force against 23.3, 27.8 and
#   28.7 N/kg for three loaded step-up variations and about 2006 N/s/kg of RFD
#   against about 755 for a barbell one-box step-up with a catch (SMD 3.9-5.5,
#   p < 0.001). The only measurement published under this lift's name; it names
#   no muscle, and its 41.5 cm box is a protocol and not a recommendation.
#   Cited in Step-Up Jump's drive cue.
# - Bobbert MF, Gerritsen KG, Litjens MC, Van Soest AJ 1996, Why is
#   countermovement jump height greater than squat jump height?, Med Sci Sports
#   Exerc 28(11):1402-1412, PMID 8933491: six male volleyball players;
#   kinematics, kinetics and EMG of six lower-extremity muscles - WHICH six is
#   not stated in the abstract and could not be verified, so nothing here says
#   this study measured any particular muscle. From the same start position the
#   countermovement jump was on average 3.4 cm higher, the difference coming
#   from greater joint moments at the start of push-off, with a Hill-type model
#   ruling out stored elastic energy. Cited in Squat Jump's dip cue for the
#   dip-and-drive-together reading only.
# - Chiu LZ, Bryanton MA, Moolyk AN 2014, Proximal-to-distal sequencing in
#   vertical jumping with and without arm swing, J Strength Cond Res
#   28(5):1195-1202, PMID 24476777: 16 women volleyball players; force plates
#   plus six-camera motion capture, no EMG. A longer relative delay between
#   pelvis and knee extension went with higher jumps both with an arm swing
#   (r = 0.82, p < 0.001) and without (r = 0.58, p = 0.02), and the arm swing
#   raised hip extensor and ankle plantar flexor net joint moments, thigh and
#   leg angular accelerations and jump height (p <= 0.05). Cited in Squat Jump's
#   arm-swing and drive cues; it records no muscle activity, so neither cue says
#   which muscle the swing recruits.
# - Myers CA, Torry MR, Peterson DS, Shelburne KB, Giphart JE, Krong JP, Woo SL,
#   Steadman JR 2011, Measurements of tibiofemoral kinematics during soft and
#   stiff drop landings using biplane fluoroscopy, Am J Sports Med
#   39(8):1714-1722, PMID 21602566: 16 healthy adults, 6 male and 10 female,
#   landing from 40 cm, instructed to land softly or stiffly. Peak vertical
#   ground reaction force 1.63 +/- 0.73 against 2.60 +/- 1.32 body weights
#   (P < .001) and knee flexion from contact to peak flexion 55.4 +/- 8.8
#   against 36.8 +/- 11.1 degrees (P < .01), while anterior tibial translation,
#   rotation and varus/valgus were all similar between the styles. It measured
#   no box and no injury outcome. Cited in the landing copy of Box Jump,
#   Step-Up Jump and Squat Jump, with the same two numbers in each.
# - Guy-Cherry D, Alanazi A, Miller L, Staloch D, Ortiz-Rodriguez A 2018,
#   Landing styles influences reactive strength index without increasing risk
#   for injury, Sports Med Int Open 2(2):E35-E40, PMID 30539115: 30
#   participants, 26.5 +/- 5.1 y, sex split not stated; five trials each of
#   three randomised 40 cm drop-jump landing styles - soft at about 60 degrees
#   of knee flexion, stiff with the knees as straight as possible, and
#   self-selected - with EMG of gluteus maximus, quadriceps, hamstrings,
#   tibialis anterior and gastrocnemius. Ground reaction force 1.34 soft, 1.50
#   self-selected and 1.81 stiff body weights (p < 0.001); reactive strength
#   index 0.64 soft BELOW 0.93 stiff and 0.96 self-selected (p < 0.001); and NO
#   difference in the EMG of any of the five muscles in any comparison
#   (p > 0.66). This is the source that stops the landing copy over-claiming: a
#   landing cue is about force and joint angle, not about which muscle works,
#   and the stiff landing scored HIGHER for reactive strength. Cited alongside
#   Myers in all three landing comparisons.
# - Milner CE, Fairbrother JT, Srivatsan A, Zhang S 2012, Simple verbal
#   instruction improves knee biomechanics during landing in female athletes,
#   The Knee 19(4):399-403, PMID 21676618: adult female recreational athletes,
#   counterbalanced crossover, landing from a countermovement jump. The
#   instruction to land softly reduced peak vertical ground reaction force and
#   increased peak knee flexion against control. The abstract gives no n and no
#   numeric values, so the sample size COULD NOT BE VERIFIED and no number from
#   it is quoted; it is recorded as the evidence that the cue itself changes the
#   force, and nothing more.
# - Niu W, Feng T, Jiang C, Zhang M 2014, Peak vertical ground reaction force
#   during two-leg landing: a systematic review and mathematical modeling,
#   BioMed Res Int 2014:126860, PMID 25243113: pooled data from 26 articles;
#   peak vertical ground reaction force rises as the SQUARE ROOT of drop height.
#   Cited once, in Box Jump's step-down cue, for how drop landings scale.
# - Gunay A, Kahraman MY, Asci A 2026, The effect of box height on joint
#   stiffness performance in drop jumping, BMC Sports Sci Med Rehabil
#   18(1):162, PMID 41736156: 32 athletes, 16 male and 16 female, 21.6 +/-
#   2.6 y, two drop jumps from 26, 35 and 42 cm on each limb. Peak knee moments
#   rose with height, highest at 42 cm (p < 0.05). Cited once, in Box Jump's
#   step-down cue, beside Niu.
# - Lin Y, Lu Z, Cen X, Thirupathi A, Sun D, Gu Y 2022, The influence of
#   different rope jumping methods on adolescents lower limb biomechanics during
#   the ground-contact phase, Children (Basel) 9(5):721, PMID 35626898: 16 male
#   adolescents; kinematics, kinetics and surface EMG during a bounced jump
#   (both feet together, which is this model) and an alternating jump. The
#   bounce had a significantly smaller vertical ground reaction force over
#   11-82% of ground contact (p < 0.001) with a smaller peak force and loading
#   rate and more hip and knee flexion. Its EMG is STANDARDISED RMS AMPLITUDE
#   and not a percentage of a maximum contraction, so it ranks muscles and
#   yields no fraction; its one finding this family cannot act on is that the
#   tibialis anterior was significantly higher in the bounce, which the Jump
#   Rope paint does not light, and that entry's open point 5 says so. Cited in
#   Jump Rope's `base` cue (The Bottom). Jump Rope has no `stance` cue - that
#   id belongs to Step-Up Jump's first cue.
# - Kaewjaratwilai T, Makaje N, Chottidao M 2025, Are there sex differences in
#   lower-limb biomechanics and muscle activation during rope jumping in Muay
#   Thai athletes?, Sports (Basel) 13(11):410, PMID 41295793: 10 female and 10
#   male Muay Thai athletes, about 23 y, skipping at 2.2 Hz with ground reaction
#   force at 1000 Hz and EMG at 3000 Hz. Contact time 0.280 +/- 0.03 s in the
#   women and 0.275 +/- 0.05 s in the men and flight time 0.205 +/- 0.03 and
#   0.245 +/- 0.05 s, none of the sex differences significant. Its peak forces
#   are in kN with no body masses published, so NO body-weight multiple can be
#   derived from it and none is written; its EMG is reported as co-activation
#   ratios. Cited in Jump Rope's landing cue for the contact and flight times
#   only.
# - Town GP, Sol N, Sinning WE 1980, The effect of rope skipping rate on energy
#   expenditure of males and females, Med Sci Sports Exerc 12(4):295-298,
#   PMID 7421480: 19 males and 11 females, five minutes of skipping at each of
#   125, 135 and 145 skips a minute with expired air routed through a hollow
#   rope handle. Skipping RATE changed nothing - no difference in oxygen uptake,
#   heart rate, ventilation or energy cost, average 11.7 to 12.5 METs. Cited in
#   Jump Rope's landing cue, as the reason no cue asks for a faster rate.
# - Phillips DA, Paletta S, Perlet M 2025, Voluntary contractions underestimate
#   peak muscle activity in drop jumps, International Biomechanics 12(1):1-6,
#   PMID 40491094: 16 participants, 10 male and 6 female; maximal voluntary
#   isometric contractions of nine lower-extremity muscles against the maximum
#   activation in ten drop-jump trials. The MVIC underestimated maximum
#   activation by 71-140%, and in 60% of drop-jump research using an MVIC in
#   2018-2023 activation above 100% MVIC occurred. Not cited in any cue; it is
#   the reason this module treats any %MVIC above 100 in a jumping or stepping
#   task as a normalisation artefact, which is what disqualifies the step-up
#   review's figures below.
# - The coaching sources, all technique teaching with nothing measured behind
#   them, and labelled as coaching wherever the copy leans on them: NASM
#   exercise library Box Jumps (step down carefully rather than jumping down,
#   which it lists among its errors; 12 to 18 inches for beginners for landing
#   control); Catalyst Athletics Box Jump and Back Squat Jump (set the box low
#   so the jump itself is maximal; change direction immediately in the bottom);
#   Greg Everett, Don't Jump with Your Arms, Catalyst Athletics 2018 (removing
#   the swing is how you make sure the legs and hips do the work); ACE exercise
#   library #230 Single-Leg Push-Off and #28 Step-Up (one foot on the box,
#   hinged forward from the hips, drive the boxed foot into the box, swing both
#   arms up, land softly and quietly on the mid-foot, do not lock the knee, same
#   reps each leg); the NSCA squat jump / static vertical jump TEST protocol via
#   the Human Kinetics excerpt (lower to roughly 110 degrees of knee, hold
#   2-3 s, hands on the hips throughout, countermovement removed) - which
#   disagrees with Catalyst Athletics about whether a squat jump pauses, a
#   disagreement this module records rather than resolves; and Lee B, Jump Rope
#   Basics Part 1: Preparation, CrossFit Journal issue 62, October 2007 (arms
#   close to the sides, elbows pointing down at about 45 degrees, two-inch
#   wrist circles, jump only high enough to clear the rope - a height he gives
#   three different ways in the one article, which is why no single figure is
#   quoted as a standard).
# - DELIBERATELY NOT USED, and each for a stated reason: Ebben WP, Simenz C,
#   Jensen RL 2008 (J Strength Cond Res 22(3):861-868, PMID 18438229) - 23
#   athletes, integrated EMG of three muscle GROUPS across ten plyometric
#   drills, with the box jump and a squat jump at about 30% of 1RM squat among
#   them; its normalisation is not stated in the abstract, the full text was not
#   retrieved, its squat jump is loaded where the app's is not, and no
#   per-exercise value or ranking from it is carried. Heick JD, Talkington M,
#   Jain T 2020 (Int J Sports Phys Ther 15(6):1019-1028, PMID 33344018) - 18
#   healthy recreational athletes, the only %MVIC glute numbers during any jump,
#   but none of its four tasks is one of these four lifts and its own authors
#   attribute the 103% MVIC for gluteus medius to the normalisation. Neto WK et
#   al. 2020 (J Sports Sci Med 19(1):195-203, PMID 32132843) - a review of
#   sixteen articles putting the step-up at the top of the measured glute
#   exercises at a mean 125.09% MVIC, range 104.19-169.22%, where every step-up
#   value traces to one primary study of fifteen women at a 6RM load; the
#   numbers are above 100% and cannot be written as a fraction or an activation
#   level in any form. The secondhand 5-15% countermovement-over-squat-jump
#   figure, the clinic figure that stepping down cuts landing force by about
#   60%, and the 2024 Adult Compendium MET codes for rope skipping, none of
#   which has a retrievable primary measurement behind it as used.
# - NOT MEASURED ANYWHERE FOUND, and so stated as convention in the copy:
#   stepping down from a box against jumping down (nobody has compared them), an
#   optimal dip depth or jump height for any of these four lifts, a box or step
#   height, the knees tracking out over the toes on a landing, and any claim
#   that a landing cue changes an injury rate. The rule on HEIGHT is that no
#   height may be presented as a FINDING, not that none may be named: both box
#   lifts name a starting height in their setup steps - Box Jump NASM's 12 to 18
#   inches for beginners, Step-Up Jump a little below knee height - and both
#   entries label it as coaching where it is explained, beside Dos Santos 2024
#   and the note that no study compares heights. The two were inconsistent in
#   the draft, which named one and refused the other.
# - The library's own entries, read in SampleData.swift on 2026-10-30 for the
#   fractions that are carried rather than estimated: squatContent (Quadriceps
#   0.84, Gluteus Maximus 0.56), the bodyweight two-legged squat and the row
#   parent of Box Jump and Squat Jump; stepUpContent (Quadriceps 0.82, Gluteus
#   Maximus 0.64) for Step-Up Jump; bodyweightStandingCalfRaiseContent
#   (Gastrocnemius 0.78, Soleus 0.60), the BODYWEIGHT tier of the calf raises,
#   for the two lifts whose calves are painted bright; farmersWalkOnToesContent
#   (Quadriceps 0.25, Hamstrings 0.20) for Jump Rope, the only library entry
#   carrying exactly those four muscles in exactly those two ranks;
#   dumbbellLyingLegCurlContent (Soleus 0.30), the library's only secondary
#   Soleus row; powerSnatchContent, dumbbellSnatchContent and
#   dumbbellCleanAndPressContent (Gastrocnemius 0.30), the floor of every
#   secondary gastrocnemius row; and dumbbellLateralStepUpContent (Hip Flexors
#   0.24), itself disclosed as an estimate. The round's rows.md section 7
#   recommends changing no shipped library row, so no entry below carries a
#   `library=` override.
# - NOT a carry, listed apart because the draft filed it on the wrong side of
#   the line: Hamstrings 0.25 is an ESTIMATE on three of these four lifts
#   (rows.md 8.1, 8.2 and 8.3 all call it one). Its justification is only that
#   four shipped blocks use that value for a secondary hamstring row in the
#   squat-and-press family - legPressContent, verticalLegPressContent,
#   wideStanceLegPressContent and hackSquatStancesContent - which is three of
#   the library's SIX leg presses plus one hack squat, not four leg presses:
#   singleLegPressContent, narrowStanceLegPressContent and legPress45Content
#   carry no Hamstrings 0.25 row, and hackSquatStancesContent is not a leg
#   press. The value is
#   bracketed by eight secondary Hamstrings rows at 0.20 and three at 0.30.
# - The owner's decision of 2026-10-30 that the GLUTES ARE ONE GROUP: the rig
#   lights gluteus maximus, medius and minimus together, so every lift that
#   paints them gets a single Gluteus Maximus row, the copy says glutes, and no
#   entry names the medius anywhere, in a row or in the stabilisers. That is
#   load-bearing on Step-Up Jump, whose parent stepUpContent carries a Gluteus
#   Medius primary row at 0.44 which is therefore dropped - open point 7.4 of
#   the round's rows.md, recorded in that entry and not decided here.

from common_1_50 import *

NAMES = ["Box Jump", "Step-Up Jump", "Squat Jump", "Jump Rope"]

# ====================================================================== box jump

# ---------------------------------------------------------------- box jump
#
# Legs/BoxJump.usdc, framing yaw -1.3 rad (-74.48 degrees), zoom 0.664, offset
# [0.054, -0.045, -0.194], viewport 382 x 655 - the app's own three numbers, at
# SampleData.swift:3039. THE CLIP IS 384 FRAMES at 24 fps = 15.958 s, twice
# every other clip in this round, so nothing here may be computed per 192
# frames. TWO identical reps on a period of exactly 8.000 s: a circular lag
# sweep (frame i against frame (i+k) mod 384) agrees to 0.000679 mm at lag 192
# and to no better than 222.2499 mm at lag 191 or 193, and the clip loops - the
# wrap from frame 383 to frame 0 disagrees by 0.000327 mm at worst. Every
# figure below is rep 1 and repeats at t + 8.000 s. A LINEAR lag sweep finds
# nothing, because the long standing hold is split across the loop seam; that
# is the first trap on this model.
#
# 160 of the 384 frames (41.7%) belong to a frozen pose and 6.500 s of the
# 15.958 s (40.7%) is held still, in a 2.500 s standing hold (frames 148-208,
# plus its seam-split twin at frames 340-16) and a 0.750 s hold on the box
# (frames 74-92 and 266-284), so no cue asks the reader to watch a tempo.
# Each rep moves for 5.500 s, t 0.667 to 6.167.
#
# ONE PIECE OF EQUIPMENT, and it is scenery: eq_names is exactly [Cube], a
# plain block 0.840 m wide by 0.380 m tall by 0.640 m deep whose bounding box
# is bit-identical on all 384 frames (x -0.4200 to +0.4200, y -0.0120 to
# +0.3680, z 0.4636 to 1.1036), whose centroid is (0.0000, 0.1780, 0.7836) with
# a path length of 0.000000 m, and whose screen u and v ranges are both
# 0.000000. Nothing in the copy may describe it travelling, tipping or being
# pushed. Its base sits 1.2 cm INTO the floor, so its top face is y 0.3680
# while the lifter's standing plane on it is y 0.3800 - the rig floats 1.20 cm
# above the drawn surface, which is harmless at trainer zoom but means any
# height read off eqbox ymax is 1.2 cm low. The box is centred on the midline
# and its front face is 38.4 cm in front of the ankle joint and 24.6 cm in
# front of the toe at the set-up.
#
# WHAT A WRITER WOULD GET WRONG, all measured:
# - THERE IS NO JUMP DOWN. The only flight in 384 frames is the jump up: 11
#   frames, t 1.708-2.125, 0.458 s airborne and 0.500 s between the last and
#   the first toe contact. The way down is a two-step climb-down, right foot
#   then left, t 3.875-6.000 - 2.125 s, 38.6% of the 5.500 s of motion.
# - THE DEEPEST KNEE IS NOT IN THE JUMP. The countermovement reaches 105.1
#   degrees (t 1.500) and the landing 100.5 (t 2.250), about 62 and 66 degrees
#   of flexion from the 167.0 the rig stands at; the clip's real extremes are
#   both in the step-down - the left support knee 66.5 degrees at t 4.833 and
#   the left swing knee 45.08 at t 5.500.
# - THE DRAWN LANDING IS FOREFOOT-FIRST. toe_L reaches its settled 0.3958 at
#   frame 52 with foot_L still 5.0 cm above where it will sit (0.4988 against
#   the 0.4486 it settles to); the heel does not arrive until frame 56,
#   0.167 s later, the ankle angle closing 105.0 to 78.7 degrees over those
#   five frames. That is the rig's own timing and NOT a cue. On an 8.7 cm drop
#   onto a box there is nothing to roll through, and a lifter told to land on
#   the balls of the feet lands further forward on the surface - which is the
#   fault this module names 300 lines later, in Step-Up Jump's stance mistake
#   (the heel hanging over the edge). The landing cue coaches a whole-foot
#   landing, which is also what NASM's box-jump page, this entry's own named
#   source, teaches; the measurement stays in the `why`, where it belongs.
# - THE EXTENSION FINISHES IN THE AIR. The last frame with a toe down is
#   t 1.667; the knee's maximum for the jump, 174.36 degrees, is at t 1.750,
#   two frames later.
# - THE ARMS NEVER BEND AND ARE PERFECTLY MIRRORED. elbow_L minus elbow_R is
#   within 0.000142 degrees on every one of the 384 frames and elbow_L moves
#   only 159.10-171.75 (12.65 degrees) over the whole clip, while the wrist
#   travels from z -0.1060 m (t 1.083, behind the hips) to +1.3153 (t 2.208)
#   and from y 0.6884 (t 1.333) to 2.1646 (t 1.917). A straight-arm swing from
#   the shoulder, never a pull. handgap never drops below 0.6118 m against the
#   frozen 0.3922 m shouldergap - 1.56 to 1.85 times shoulder width - so the
#   arms are never beside the body.
# - IT IS GENUINELY TWO-FOOTED ON THE WAY UP and handed on the way down. Over
#   the jump (frames 16-56) knee_L minus knee_R stays inside -0.566 to +0.196
#   degrees, foot_L.y minus foot_R.y inside 0.63 mm and foot_L.z minus foot_R.z
#   inside 0.18 mm, and both toes leave and land on the same frames; but the
#   RIGHT foot leads down in both reps and does not alternate. The feet never
#   slide either: the ankle's front-to-back position is identical to
#   0.0000007 m over the 19 frames of the hold and the dip.
# - THE LIFTER CROSSES THE WHOLE FRAME. The silhouette's left edge swings 243
#   px (umin 0.6516 standing to 0.0160 at t 2.208) and its width RUNS 88 px
#   (f141, t 5.875) to 231 px (f54, t 2.250) - it is 96 px at the standing
#   freeze and 226 px at t 2.167 - which is what makes eight of the ten label
#   slots impossible.
#
# PAINT (tiers_jump.json, key Legs/BoxJump): 14 painted meshes, 7 BRIGHT and
# 7 DIM, nothing faint, and NOTHING ONE-SIDED - no painted name carries an
# _L/_R or (L)/(R) suffix, so both sides light, which agrees with the joint
# symmetry above and separates this model from its sibling Step-Up Jump, whose
# 13 one-sided (L) meshes make it the asymmetric one of the pair.
#   bright: GluteusMaximus, GluteusMedius, GluteusMinimus (-> glutes);
#           VastusIntermedius, VastusLateralis, VastusMedialis (-> quads);
#           RectusFemoris
#   dim:    Semimembranosus, Semitendinosus (-> hamstrings); BicepsFemoris;
#           GastrocnemiusLateral, GastrocnemiusMedial, Soleus (-> calves);
#           Sartorius
# THREE part_of() TRAPS, all verified against common_1_50.py on 2026-10-30 and
# all hard validate() failures if ignored: part_of(RectusFemoris) is None, so
# it rides inside the Quadriceps row and is never named; part_of(BicepsFemoris)
# is BICEPS - the arm - so the row must read Hamstrings (part_of(Biceps
# Femoris), with the space, is hamstrings, the exact analogue of the Anterior
# Deltoid trap); and part_of(Sartorius) is None and Sartorius is not in
# LEGEND_ONLY, so the only legal way to acknowledge the dim sartorius paint is
# the legend-only Hip Flexors row, for which the precedent is
# dumbbellLateralStepUpContent.
#
# FRACTIONS - FIVE CARRIES AND ONE ESTIMATE, and not one of the six is sourced
# to a measurement of a box jump, because none exists. There is no %MVIC or
# %MVC-normalised EMG study of a box jump, a step-up jump, a squat jump or
# skipping anywhere in SampleData.swift's citations; the only jump-adjacent
# sourced claims in the whole library sit on plyometricPushUpContent and are
# about push-ups. The library has no plyometric lower-body entry at all - the
# only *Content name containing jump or plyo is plyometricPushUpContent (the
# two cableWoodChop names carry hop, not jump or plyo) - so the row parent is
# squatContent, the bodyweight two-legged squat.
#   Quadriceps      P 0.84 CARRY squatContent (SampleData.swift:12280)
#   Gluteus Maximus P 0.56 CARRY squatContent - all three painted glutes in
#                          ONE row, on the owner's decision of 2026-10-30 that
#                          the paint is not split, so the copy says glutes and
#                          nothing names the medius, in a row or a stabiliser
#   Gastrocnemius   S 0.30 CARRY powerSnatchContent / dumbbellSnatchContent /
#                          dumbbellCleanAndPressContent, the floor of every
#                          secondary gastrocnemius row in the library
#   Soleus          S 0.30 CARRY dumbbellLyingLegCurlContent (:48226), the
#                          library's only secondary Soleus row
#   Hamstrings      S 0.25 ESTIMATE - both parents keep hamstrings as a
#                          stabiliser, so there is no fraction to carry;
#                          brackets 0.20 and 0.30, and 0.25 is the
#                          squat-and-press family's own value (legPressContent,
#                          verticalLegPressContent, wideStanceLegPressContent,
#                          hackSquatStancesContent)
#   Hip Flexors     S 0.24 CARRY dumbbellLateralStepUpContent (:45835) - a
#                          carry in number and an estimate in kind, because
#                          that parent disclosed it as an estimate itself
# Rows and ranks follow the paint, fraction-descending, stabilisers lower case.
# tibialis anterior is in the stabilisers because the landing is
# forefoot-first; anterior deltoid is kept from squatContent because the arm
# swing is measured and large (the wrist apex is 11.4 cm above the head joint).
#
# OPEN POINTS THIS ENTRY HANDS THE OWNER - recorded, not decided, and no cue
# above assumes an answer to any of them:
#  1. THE CALF TIER RUNS OPPOSITE TO MEASURED ANKLE TRAVEL. This model moves
#     the ankle through 63.86 degrees (78.72 at t 2.333 to 142.58 at t 1.667)
#     and is painted DIM, so it ships two LOW 0.30 calf rows; Jump Rope moves
#     it 25.92 degrees and is painted BRIGHT at HIGH 0.78. Either the paint
#     means what the clip is FOR rather than what each joint does, or this
#     model is under-painted at the ankle (rows.md open point 1).
#  2. THE DIM SOLEUS: ROW OR STABILISER, for the whole round. This entry gives
#     it a row, on README 716 and dumbbellLyingLegCurlContent; three lifts
#     shipped in this same round (Power Snatch, Dumbbell Snatch, Dumbbell Clean
#     and Press) do the opposite and put soleus in the stabilisers
#     (rows.md open point 2).
#  3. TWO CALF ROWS AT THE IDENTICAL 0.30, a consequence of 2. Legal, but it
#     breaks the house gastrocnemius-above-soleus gap that every other calf
#     pair in the library keeps (rows.md open point 3).
#  4. Hamstrings 0.25 is an estimate on three of this family's four lifts
#     (rows.md open point 6), and Hip Flexors 0.24 is the LOWEST Hip Flexors
#     fraction in the library with nothing bracketing it from below
#     (rows.md open point 8).
#  5. THE STEP-DOWN HAS NO TIER OF ITS OWN. Frames 93-144 are 2.125 s of slow
#     one-leg-at-a-time lowering holding the clip's two deepest knees (66.5 and
#     45.08 degrees), and the paint gives it no separate tier, so Quadriceps
#     0.84 covers the jump and the climb-down together. Nothing in the
#     activation table supports calling the step-down the harder half, and no
#     cue below does (rows.md open point 15).
#  6. THIS LIFT DOES NOT MEET THE ROUND'S PILL RULE, and that is a decision
#     the owner has to take before the module ships. The round brief states as
#     a HARD test that a pill must clear the SKINNED lifter at every frame -
#     lifter-overlap frames must be 0 - and it grants an exception only for a
#     LOAD crossing. Three of this lift's five pills are crossed by the
#     lifter's own reaching arms: `Heels lift` 6 frames, `Soft knees` 10 and
#     `Step down` 14, so 30 of the 1,920 pill-frames, 1.56%, all inside one
#     0.63 s window of each rep. Step-Up Jump, Squat Jump and Jump Rope are
#     0/0/0/0/0 on the same test. THREE OPTIONS, all measured, none chosen
#     here:
#       (a) SHIP AS WRITTEN. 30 crossed pill-frames, five labels that say
#           something, the crossings named frame by frame below. This is what
#           the file currently holds, and it is a declared breach of the rule,
#           not a compliant layout.
#       (b) STAY ON THE FIVE-ROW GRID AND CUT THE LABELS. A zero-overlap
#           layout exists there and it was measured rather than assumed: of
#           the ten slots, exactly five are ever clean of both the lifter and
#           the box, and their character ceilings are 0.64 leading 17, 0.16
#           trailing 12, 0.80 leading 8, 0.32 trailing 3 and 0.80 trailing 1.
#           But 0.16 trailing gives a clear LEADER only at THREE characters,
#           and then to exactly two anchors, both by under 2 px (foot_L
#           1.8 px, scapula_L 1.7 px); at 6, 9 and 12 characters every one of
#           the 26 joints is on the face. So the grid's compliant layout is
#           labels of 17, 8, 3, 3 and 1 characters, on 3.9 px and 4.6 px of
#           clearance in two of the five slots. One label of one character is
#           not coaching, which is why this entry does not take it.
#       (c) LEAVE THE FIVE-ROW GRID ON THIS LIFT ONLY. This is new measurement
#           and it is the option that makes a compliant layout readable.
#           gen.py takes any y in `overrides` (layout() applies no grid check,
#           and `slots` only places cues that have no override, of which this
#           entry has none), and common_1_50.validate() checks only the cue id
#           and the side - so a drawn row off the five is mechanically legal
#           today. Scanning every drawn row 0.08 to 0.92 on both sides at 8
#           characters, the LEADING gutter is clean of the lifter and never has
#           the box inside the pill from drawn v 0.54 all the way to 0.92:
#           +46.2 px at 0.54-0.58, +54.6 at 0.64, +69.3 at 0.73, +150.1 at
#           0.76, +205.1 at 0.86. At 10 characters the clean leading band is
#           v 0.54-0.67 (35.0-43.4 px, box 3.5-88.6 px away) plus v 0.73-0.78
#           (58.1-146.2 px, box 1.2-19.0 px away, 0 frames inside). With the
#           pill's 0.05 of height that fits five pills at 8 characters each -
#           for example drawn 0.54, 0.60, 0.66, 0.73 and 0.80 - all on the
#           leading side, all zero-overlap. The costs are real and are why this
#           is the owner's call and not the entry's: every label capped near 8
#           characters, all five pills stacked in the lower-left instead of
#           spread over the frame, and Box Jump becoming the only entry in 462
#           whose labels do not sit on gen.py's SLOTS grid. At 10 characters
#           the clean leading bands are v 0.54-0.67, v 0.73-0.78 and
#           v 0.85-0.92. THE TRAILING SIDE DOES HELP, which the draft had
#           wrong. Its LOW band is clean of lifter and box at 8 characters from
#           drawn v 0.07 to 0.23 (+105.3 px down to +2.4 px, failing at 0.24
#           with -14.9 px on 140 frames) but its leaders are the same
#           all-on-the-face problem as 0.16 trailing. Its HIGH band, drawn
#           v 0.87-0.92, is new: the lifter never enters that band at all, the
#           box stays 39.4-47.4 px away, and from a trailing pill at drawn
#           v 0.90 at 8 characters 26 of the 27 probed joints are CLEAR 0/384 -
#           only head is on the face, and no pill anchors on the head. So a
#           fifth pill can sit in the LOWER-RIGHT rather than stacking all five
#           in the lower-left, which is the readable version of this option.
#  7. THE LEGEND LINE IS THE LONGEST OF THE FOUR AND IT TRUNCATES. By rows.md
#     section 6's formula the primary line is 28 characters (QUADRICEPS .
#     GLUTEUS MAXIMUS) and the secondary line is 49 - GASTROCNEMIUS . SOLEUS .
#     HAMSTRINGS . HIP FLEXORS - against a 40-44 character budget, so HIP
#     FLEXORS, at positions 39-49, is cut mid-word on every viewport. It is the
#     legend-only row, so what is lost is the only acknowledgement of the dim
#     sartorius paint anywhere the reader can see. Step-Up Jump records its 42
#     and Squat Jump its 53; this is Box Jump's, and the draft did not record
#     it.
#  8. THE MEASURE FILE'S 57.1 DEGREES OF PLANTARFLEXION does not match its own
#     endpoints: 142.58 minus 82.83 is 59.75. This entry quotes the two
#     endpoint angles and never the difference. Re-measured here, the left
#     ankle's whole-clip span is 78.72 (t 2.333) to 142.58 (t 1.667), a range
#     of 63.86 degrees.
#  9. HIP FLEXORS IS INVISIBLE TO THE READER ON BOTH SURFACES, and it is the
#     only thing that separates this lift's muscle profile from Step-Up Jump's.
#     part_of() returns None for it, so LEGEND_ONLY lets it pass validate();
#     MusclePart(muscleName:) returns nil too, so ExerciseCatalog drops it
#     before TARGET MUSCLES is built, and the legend cuts it at every phone
#     width (open point 7). Box Jump and Step-Up Jump therefore show the reader
#     identical TARGET MUSCLES: PRIMARY Glutes / Quads, SECONDARY Hamstrings /
#     Calves. Three honest options: leave it and accept it is legend-only on an
#     iPad-width pane; put Hip Flexors first in each list so the truncation
#     falls on a name the reader can also read in TARGET MUSCLES, at the cost
#     of the fraction-descending convention; or drop the row here (secondary,
#     0.24, an estimate) and keep it only on Step-Up Jump, where the sartorius
#     is bright. Renaming to Quads / Glutes is not available - the library uses
#     Quadriceps 115 times and Gluteus Maximus 154.
# 10. THE SETUP STEPS ARE STILL LONG. Across the 1,702 setup steps in
#     SampleData.swift the median is 61 characters, p99 is 132 and the longest
#     ever shipped is 214. This round cut the clauses that the cue strings on
#     the same screen already carry, which takes the family from 19 steps with
#     11 over p99 (longest 242, which would have been the longest ever shipped)
#     to 18 steps with 9 over, longest 198 - still inside the shipped record of
#     214. The nine left are Box Jump 198, 140 and 165, Step-Up Jump 133, 139
#     and 136, and Jump Rope 150, 152 and 149 - single steps carrying two
#     instructions each, and the 3-5 step rule means they cannot be split, so
#     cutting further would drop content rather than repetition. The owner gets
#     that choice.
# 11. THE DOWN CUE AND STEP 5 OVERLAP. Both tell the reader to step off one
#     foot at a time rather than jumping down; the cue adds standing all the
#     way up on the box first, and the step now adds the bail. Measured as the
#     share of a cue's four-word phrases that appear in a setup step, this is
#     the only second cue in this family or either shipped precedent that
#     restates a step (a high FIRST cue is the house pattern). Shipped as is
#     because both surfaces matter on the lift where a miss meets a hard edge.
ex(name="Box Jump", var="boxJump",
   # LABEL GEOMETRY. Five pills, five slots, measured at the pill the app
   # DRAWS - half-height 0.025 in v, width (24 + 5.6 * len(label)) / 382,
   # pinned EDGE 0.035 from the leading (left) or trailing (right) edge -
   # against the 655-row SKINNED silhouette (BoxJump_SIL.npz, not mesh points:
   # the rig is skinned and GetPointsAttr().Get(t) returns the rest pose at
   # every time code), against the box's 56 projected points, and with every
   # leader tested against the HEAD'S OWN silhouette (BoxJump_HEAD.npz), not a
   # box round the head joint - the drawn crown sits 36.8 to 39.3 px above that
   # joint on this clip. All figures are over ALL 384 FRAMES. Rows below are
   # the DRAWN rows; overrides carries the RAW 0.14-0.86 values, which
   # spec_1029.py renders at 0.16 / 0.32 / 0.48 / 0.64 / 0.80.
   #
   # THE FRAME. This is the tightest layout of the four jumps and the reason
   # the round exists. The lifter translates 52 cm forward onto the box - the
   # ankle's own travel from take-off; from the standing pose it is 58 cm and
   # the pelvis 55 cm - which
   # at yaw -1.3 is 243 px to the LEFT, so the leading gutter is swept by the
   # body at the apex and the landing; and at least one foot is on the floor on
   # 234 of the 384 frames, with the silhouette's left edge above u 0.5 on 194
   # of them, which kills the trailing edge outright.
   # room.py "Box Jump" at 1,2,3,4,5,6,7,8,9,10,12,13,16,17,18 characters:
   # at four characters or more, exactly THREE of the ten slots have zero
   # lifter-overlap frames -
   #   0.64 leading   clean to 17 characters (+9.8 px at 16, +4.2 at 17,
   #                  -1.4 px on 4 frames at 18), box a constant 23.1 px away
   #                  and inside on 0 frames at every length
   #   0.80 leading   clean of the LIFTER at every length tested (+197.6 px at
   #                  1 character down to +46.4 at 28), but it is the box slot:
   #                  the box is 1.9 px away at 8 characters and INSIDE THE
   #                  PILL ON ALL 384 FRAMES from 9 characters up
   #   0.16 trailing  clean to 12 characters (+1.3 px) - and UNUSABLE, because
   #                  lead.py from it puts ALL 26 joints on the face, between
   #                  64 frames (toe_R) and 384 (head): the pill pins at
   #                  u 0.7263 and the head sits at u 0.739-0.849 while
   #                  standing, so every leader drops straight through it
   # and the other seven are dead: 0.32 trailing is clean only to THREE
   # characters (+3.9 px) and is on the lifter in 126 frames at four; 0.80
   # trailing is clean only at ONE character (+4.6 px) and 172 frames at two;
   # 0.64 trailing 32 frames at one character and 170 by three; 0.48 trailing
   # 144 frames at one character; 0.16 leading, 0.32 leading and 0.48 leading
   # never reach zero at any length, because the silhouette reaches u 0.094,
   # 0.016 and 0.087 in those bands and the pill's own left edge is pinned at
   # u 0.035 with a 24 px minimum width.
   # So TWO pills can be clean and the other three cannot, and since the app
   # draws all five callouts at once (Exercise3DView.swift:443 filters only
   # while a mistake is shown) the five slots must be distinct. The three
   # cheapest remaining slots were taken and the longest labels put where the
   # room is.
   #
   # Pill by pill, in cue order (slot, label length, lifter clearance and
   # overlap frames, load distance and frames inside, leader against the face):
   #   setup `Chest up`      8  row 0.80 leading  lifter +158.4 px / 0 frames,
   #     box 1.9 px / 0 frames inside, leader to spine 0/384 on the face (it
   #     never spans the head's own rows at any frame). EIGHT CHARACTERS IS THE
   #     WHOLE BUDGET HERE: at nine the box is inside the pill on all 384
   #     frames, so the library's eight-character `Chest up` is exactly what
   #     this slot can hold, and it is the only label in the entry short enough
   #     to go here. The band is also empty of the lifter on 134 of 384 frames.
   #   dip   `Dip and swing` 13 row 0.64 leading  lifter +26.6 px / 0 frames,
   #     box 23.1 px / 0 frames inside, leader to hand_R 0/384 on the face,
   #     closest 70.3 px at t 1.67. This is the only slot clean of BOTH the
   #     lifter and the box at a long label with no box ceiling - 0.80 leading
   #     is clean of the lifter at every length but swallows the box from nine
   #     characters, and 0.16 trailing is clean of both to 12 and fails on its
   #     leaders - and it takes up to 17 characters, so it gets the longest
   #     label; at 13 it is not length-bound. The roomiest leader in the layout
   #     is the drive's foot_L at 97.2 px, and the setup and down leaders never
   #     enter the head's rows at all.
   #   drive `Heels lift`   10 row 0.32 leading  lifter -87.2 px on 6 FRAMES
   #     (t 2.167-2.250 and t 10.167-10.250), box 232.7 px / 0 frames inside,
   #     leader to foot_L 0/384 on the face, closest 97.2 px at t 1.25. Six
   #     frames is the FEWEST overlap of any slot that is not already clean,
   #     and it is flat at six for every length from 5 to 10 characters, so a
   #     ten-character label costs nothing extra here.
   #   land  `Soft knees`   10 row 0.16 leading  lifter -57.5 px on 10 FRAMES
   #     (t 1.958-2.125 and t 9.958-10.125), box 337.5 px / 0 frames inside,
   #     leader to patella_R 0/384 on the face, closest 13.4 px at t 2.42.
   #     This slot has the stingiest leaders of the three compromise slots -
   #     16 of the 26 probed joints are ON the face from it, for 2 to 384
   #     frames each: head 384, upper_arm_L 106, scapula_L 104, neck 98,
   #     scapula_R 44, chest 34, spine 22, clavicle_L 18, clavicle_R 18,
   #     forearm_L 18, pelvis 18, thigh_L 18, upper_arm_R 18, thigh_R 16,
   #     hand_L 14 and support_PectoralisMajor_Abdominal_R 2. Only ten are
   #     clear: foot_L 4.3 px, foot_R 7.6, forearm_R 0.9, hand_R 4.9,
   #     patella_L 7.5, patella_R 13.4, shin_L 8.0, shin_R 13.5, toe_L 10.9
   #     and toe_R 14.4 - so the cue placed here is the one whose own anchor is
   #     the roomiest of those ten that belongs to it, patella_R. patella_L is
   #     equally clear (0/384) and was passed over on the 13.4-against-7.5 px
   #     margin alone; see the family header, which the draft had claiming a
   #     forced measurement here.
   #   down  `Step down`     9 row 0.48 leading  lifter -54.7 px on 14 FRAMES
   #     (t 2.333-2.583 and t 10.333-10.583), box 127.9 px / 0 frames inside,
   #     leader to foot_R 0/384 on the face (never spans the head's rows at
   #     all). Every joint except head is clear from this slot, which is why
   #     the most expensive pill is the one with the safest leader.
   #
   # WHAT THE THREE CROSSINGS ACTUALLY ARE, frame by frame (bjwho.py in
   # w_bjdraft, which lists the joints projecting inside each pill rectangle):
   # all three are the lifter's own ARMS reaching forward over the box, and no
   # torso, leg or head enters any of the three pills on any frame. Row 0.16
   # is crossed at the flight apex, t 1.958-2.125, with hand_L inside the pill
   # on the deepest frame (t 2.083, -57.5 px, a 57.5 px strip). Row 0.32 is
   # crossed at the landing, t 2.167-2.250, with both hands inside at t 2.208
   # (-87.2 px, an 80.0 px strip). Row 0.48 is crossed during the stand-up,
   # t 2.333-2.583, with hand_R inside at t 2.458 and t 2.500 and the strip
   # tapering to 7.8 px by t 2.583. Thirty crossed frames of 1,920 pill-frames
   # is 1.56% of the clip, all of it inside one 0.63 s window of each rep, and
   # it is nearly unbuyable ON THIS ROW SET: at FOUR characters those three
   # slots cost 6, 4 and 8 frames and at FIVE they cost 6, 6 and 10, so the
   # floor is 18 frames at four characters and 22 at five, and those labels
   # would be meaningless. (Admitting 0.16 trailing as a slot - clean of lifter
   # and box to 12 characters, rejected on its leaders alone - the cheapest
   # five slots at four characters are 0, 0, 0, 4 and 6 = 10 frames.) Below four characters two further slots
   # open and a zero-overlap layout becomes geometrically possible at 17, 8, 3,
   # 3 and 1 characters; off the five-row grid a zero-overlap layout exists at
   # eight characters everywhere. Open point 6 above carries both measurements
   # and hands the choice to the owner, and says plainly that as written this
   # lift breaches the round's hard pill rule. The
   # alternative arrangements, measured: giving row 0.64 to a ten-character
   # label and pushing the thirteen-character one to row 0.32 costs 8 frames
   # there instead of 6 and leaves the roomy seventeen-character slot holding a
   # ten-character label (32 frames in total against 30); and putting the
   # nine-character label at row 0.16 with a ten-character one at row 0.48
   # costs 10 + 16 against the 10 + 14 written here.
   # Reproduce any figure with, in the jump data folder,
   #   room.py "Box Jump" 1,2,3,4,5,6,7,8,9,10,12,13,16,17,18
   #   lead.py "Box Jump" - 0.80 leading 8      (and 0.64/13, 0.32/10,
   #                                             0.16/10, 0.48/9)
   #
   # LABEL STRINGS. Three are the library's own for the same cue, with their
   # counts: `Chest up` (8, x10, and all ten of them squats, Squat/torso among
   # them, and squatContent is this entry's row parent, which is why it is the
   # set-up label as well as the shortest usable string in the library);
   # `Heels lift` (10, x1, Dumbbell Clean and Press/extend, written in this
   # same round, and true here - the ankle joint rises 6.85 cm over a planted
   # toe); `Soft knees` (10, x3, the Smith Machine / Cable / Kettlebell
   # Romanian Deadlift knee cue). TWO ARE NEW. `Dip and swing` (13) is new
   # because the library's countermovement label, `Dip straight down` (17,
   # x5 on the Push Press, Dumbbell Push Press, Barbell Clean and Jerk, Split
   # Jerk and Push Jerk), would be FALSE here: those five hold the trunk inside
   # a degree of vertical, where this model takes it to 33.45 degrees forward,
   # and none of them swings the arms. `Step down` (9) is new because the
   # library has no descent label for any box lift at all - `Whole foot on the
   # box` (21, Barbell Step-Up, Dumbbell Lateral Step-Up) and `Stay tight on
   # the box` (21, Box Squat) are both about getting ON one.
   overrides={"setup": (0.86, "leading"), "dip": (0.68, "leading"),
              "drive": (0.32, "leading"), "land": (0.14, "leading"),
              "down": (0.50, "leading")},
   annotations=[
       ("setup", "Chest up", "spine"),
       ("dip", "Dip and swing", "hand_R"),
       ("drive", "Heels lift", "foot_L"),
       ("land", "Soft knees", "patella_R"),
       ("down", "Step down", "foot_R"),
   ],
   cues={
       "setup": ("Start Position",
                 "You stand a short step back from a box that never moves, tall and still, with your arms loose and ready to swing.",
                 "In the model this is a held pose and not a wind-up: 61 frames are identical to better than a micron and the stand lasts 2.500 s in every rep. The knees are at 167.02 and 167.06 degrees, the hips 166.12, the trunk 1.58 degrees forward and the pelvis 0.9029 m - and note that the rig stands with about 13 degrees of soft knee, so every flexion figure in this entry is measured from 167.0 and not from straight. The stance is NARROWER than the shoulders: 0.3000 m between the ankles against a shouldergap frozen at 0.3922 m for all 384 frames, which is 76.5%, with each foot 0.1500 m off the midline. The box is a plain block 0.840 m wide, 0.380 m tall and 0.640 m deep that never moves at all - its bounding box and its centroid are bit-identical on every frame and its screen position has a range of 0.000000 - and its front face is 38.4 cm in front of the ankle joint and 24.6 cm in front of the toe. The hands are already wide and stay wide: the gap between them never drops below 0.6118 m, 1.56 to 1.85 times the shoulder span, and at this freeze the wrist is 0.3059 m off the midline against the collarbone at 0.0128 m. Nothing in the literature sets a box height. Dos Santos 2024 had 14 recreationally active men and 17 women jump onto boxes at five heights, from zero to 80% of each person's own maximum, and measured peak force, rate of force development, peak power, jump height and time to take-off: peak force was higher at 80% than at zero in the WOMEN only, with no significant difference on any other variable in the men or at any height below 80% in the women. So this model shows one box and not a prescription: the mesh is 38.0 cm tall, and because its base sits 1.2 cm into the floor the drawn top face is at 36.8 cm while the plane the lifter stands on is at 38.0 cm, so a reader measuring the box on screen gets 36.8 cm. The three coaching sources that do give a rule disagree with each other - Catalyst Athletics and Everett set the box deliberately low so the jump itself is maximal, NASM suggests 12 to 18 inches for beginners for landing control, and both reason from what you are training rather than from what you can clear. The setup step names NASM's beginner range as a starting point, as coaching and not as a finding, because the alternative the draft had - pick a box you can land on with your knees bending - asks a beginner to know how a box jump lands before they have done one.",
                 "Standing so close that you have to pike your hips to get your feet over the edge, or picking the tallest box you can reach.",
                 "Stand about a foot's length back from the box with your feet a little inside shoulder-width and your weight over the whole foot, chest up and both arms hanging loose, and choose a box you can land on with your knees bending rather than the tallest one you can clear."),
       "dip": ("Countermovement",
               "You drop quickly into a short dip and swing both arms back behind your hips.",
               "The dip runs from t 0.667, the last frozen frame, to t 1.250. Over it the knees go from 167.02 to 107.32 degrees, the hips from 166.12 to 116.31, the trunk from 1.58 to 33.45 degrees forward - its maximum anywhere in the clip - and the pelvis drops 16.3 cm to 0.7398 m, which is the lowest it reaches in 384 frames. The arms go with it: the wrist travels from z +0.1274 m to -0.1060 m at t 1.083, 23.3 cm back and behind the hips, with the elbow moving at most 12.65 degrees over the entire clip (159.10 to 171.75) and the two elbows agreeing to 0.000142 degrees on every frame, so this is a straight-arm swing from the shoulder and never a pull. The knee is not finished at t 1.250 either: it opens 3.8 degrees at t 1.333 and then re-flexes to 105.14 at t 1.500, which is its deepest point before the feet leave. That is about 62 degrees of bend from the standing 167.0 - between a quarter and a half squat - and only 0.167 s separates it from the last frame a toe is on the floor. This is not the knee-only dip of a jerk or a push press, where the trunk stays inside a degree of vertical; here it comes forward 32 degrees.",
               "Sinking slowly into a deep squat, or stopping at the bottom before you jump.",
               "Bend your knees and hips quickly into a short dip, about a quarter to a half squat, letting your chest come forward and both arms swing back past your hips, and go straight back up out of the bottom without pausing there."),
       "drive": ("Leg Drive",
                 "Everything opens at once, your heels roll up over your toes, and you throw both arms up.",
                 "The heel lift is the measurement that defines this phase. Over t 1.458 to 1.667, 0.208 s, the ankle joint rises from 0.87 cm to 6.85 cm above its own resting height while the toe stays on the floor at 0.0141 to 0.0158 m, its resting value: the ankle angle opens from 82.8 to 142.6 degrees with the toe still planted. Underneath it the knee goes 106.9 to 166.9 degrees, the hip 128.0 to 163.1, and the trunk comes back up from 20.9 to 8.3 degrees forward. The feet do not slide while any of that happens - the ankle's front-to-back position is identical to 0.0000007 m across the 19 frames of the hold and the dip. The last frame with a toe down is t 1.667, and the knee's maximum for the jump, 174.36 degrees, is at t 1.750, two frames LATER: the extension finishes in the air, not on the floor. The arms finish with it - the wrist runs from 0.6884 m at t 1.333 to 2.1646 m at t 1.917, which is 11.4 cm above the head joint on that frame. Catalyst Athletics teaches exactly this swing, back then aggressively up, and Everett argues the opposite case for weightlifters, that removing the swing is how you make sure the legs and hips are doing the work. Both are coaching; the measured part is that the arms carry no load and the elbow never bends.",
                 "Pulling your feet up to reach the box instead of driving the floor away, and letting the arms stop at your hips.",
                 "Drive the floor away through the whole foot until your hips, knees and ankles are all open and your heels have rolled up over your toes, and swing both arms up past your head as it happens."),
       "land": ("Landing",
                "Both feet arrive on the box together and your hips and knees keep bending to soak up the landing.",
                "The flight is 11 frames, 0.458 s, with 0.500 s between the last and the first toe contact. The ankle reaches 0.6680 m at t 2.000 - 59.9 cm above the floor and 21.9 cm above the plane it is about to land on - and the toe crosses the box's front face (z 0.4636) 11.1 cm above the drawn top face - 11.5 cm by f45, the first frame already past it - so the box is cleared with room rather than scraped, and the pelvis PEAKS only 8.7 cm above the height it will stand at: by the last airborne frame, f51, it is already 5.1 cm BELOW that, and the whole fall from apex to settled is 27.7 cm. It is genuinely a two-foot landing: over the jump the knees stay within 0.57 degrees of each other and the ankles within 0.63 mm of height and 0.18 mm front to back, and both toes reach the box on the same frame. THE DRAWN LANDING IS NOT FLAT, which is a fact about the animation and not an instruction. The toe reaches its settled height at t 2.167 while the ankle is still 5.0 cm above where it will sit, and the heel does not arrive until t 2.333, 0.167 s later, with the ankle angle closing from 105.0 to 78.7 degrees over those five frames. The knee flexes from the standing 167.02 to 107.68 at the first frame of contact and 100.53 at t 2.250 - about 66 degrees of travel - and the ankles stay 0.3000 m apart through all of it, so the feet never widen to receive it. That heel timing is the rig's own and not a cue: a heel arriving 0.167 s late on a jump whose apex is 8.7 cm above the box is what a soft landing looks like in an animation, and it is still a whole-foot landing that the box has to be low enough and big enough to take. The lifter lands centred, not on the lip: the ankle settles 19.6 cm behind the front face and 44.4 cm in front of the back one, 51.7 cm forward of where it took off, after overshooting 3.8 cm and being pulled back. Landing on the box rather than the floor is where this lift is cheap, and that is a force result and not an activation one: Janikov 2023 put 20 recreationally trained men on force platforms for maximal countermovement jumps, 50 cm hurdle jumps and 50 cm box jumps and measured about 51% less peak impact force in the box jump, with no difference in peak velocity, peak vertical force, peak resultant force or total impulsion time. That study recorded no muscle activity at all.",
                "Landing with the knees straight, or landing on the balls of your feet near the front edge with the heels hanging off.",
                "Land on both feet at once, well back from the front edge of the box, toes down first and the heels following so the whole foot is down, keep your knees pointing out over your toes rather than letting them fall in, and keep bending your hips and knees until the landing goes quiet."),
       "down": ("The Step Down",
                "There is no jump down in this lift: you stand all the way up on the box and then step off one foot at a time.",
                "After the landing the lifter stands up on the box over t 2.333 to 3.000, the pelvis rising 19.0 cm from 1.0922 to 1.2823 m while the trunk comes back from its peak 31.45 degrees at t 2.417 to 1.58, and then holds still for 0.750 s, 19 identical frames. The way down is a climb and not a jump. The right toe leaves the box at t 4.042 and reaches the floor at t 4.833, then the left leaves at t 5.125 and lands at t 6.000, so the descent runs t 3.875 to 6.000 - 2.125 s, 38.6% of the 5.500 s this rep spends moving - and the only flight anywhere in the 384 frames is the jump up. The RIGHT foot leads down in both reps and does not alternate. The clip's two deepest knees are both here and not in the jump: the left support knee bends to 66.5 degrees at t 4.833 while the right foot reaches for the floor, and the left swing knee to 45.08 at t 5.500, against the jump's own deepest 100.53, and the ankles come 0.7555 m apart at t 4.875 with one foot on each level. NASM's box-jump page is the named source for stepping down - it says to step down carefully and not to jump down, and lists jumping down among its errors - and that is coaching: nobody has compared stepping down with jumping down in a study, and the figure that circulates for how much force stepping down saves has no study behind it, so it is not quoted here in any form. What is measured is only how drop landings scale. Niu 2014 pooled 26 studies and found peak vertical ground reaction force rising as the square root of the drop height, and Gunay 2026 had 32 athletes drop-jump from 26, 35 and 42 cm and found peak knee moments rising with height, highest at 42 cm.",
                "Jumping or dropping back off the box, or rebounding straight into the next rep.",
                "Stand all the way up on the box, then step down one foot at a time and reset both feet on the floor before the next jump - do not jump or drop off the box."),
   },
   # Rows, ranks, fractions and stabilisers exactly as the row stage settled
   # them (rows.md 8.1), re-read from tiers_jump.json: 7 bright and 7 dim,
   # nothing faint, nothing one-sided. Bright, so primary: the three vastus
   # heads as one Quadriceps row with the dropped RectusFemoris riding inside
   # it, and the three glutes as ONE Gluteus Maximus row. Dim, so secondary:
   # the two gastrocnemius heads, the soleus, and the two hamstring muscles as
   # one Hamstrings row with BicepsFemoris inside it (written with the space,
   # or part_of files it under the arm), plus the legend-only Hip Flexors row
   # that is the only legal way to name the dim sartorius. Five carries, one
   # estimate, no library= override - rows.md section 7 recommends changing no
   # shipped library row. See the header for where every fraction comes from
   # and for the eight open points, of which number 6 - the three pills the
   # lifter's arms cross - is a declared breach of the round's hard pill rule
   # and needs the owner's decision before this entry ships.
   activation=[("Quadriceps", P, HI, 0.84), ("Gluteus Maximus", P, MOD, 0.56),
               ("Gastrocnemius", S, LOW, 0.30), ("Soleus", S, LOW, 0.30),
               ("Hamstrings", S, LOW, 0.25), ("Hip Flexors", S, LOW, 0.24)],
   stabilisers=["core", "erector spinae", "tibialis anterior",
                "anterior deltoid"],
   # The badge is modelled on STIFF-ARM LANDING (Plyometric Push-Up), the
   # library's only landing badge and its only plyometric entry, with one noun
   # swapped; it names a fault NASM's own box-jump page lists. It deliberately
   # does not reuse BACK FOOT PUSHING or PUSHING OFF THE FLOOR, which the two
   # step-ups use for a fault the jumping variants commit on purpose. The
   # correct note is this model's measured landing; the mistake note keeps the
   # force studies honest - both measured a 40 cm drop landing and not a box,
   # neither tested an intervention, and Guy-Cherry 2018 found NO difference
   # in the EMG of any of five muscles across the three landing styles, so
   # nothing here claims a landing cue changes which muscle works or changes
   # an injury rate.
   comparison=("STIFF-LEG LANDING", "Knees bend as you land",
               "Knees stay straight on the box",
               "In the model the knee is 167.02 degrees standing, 107.68 on the first frame the toe is on the box and 100.53 at t 2.250, so the landing is taken over about 66 degrees of knee travel - which is the part of this animation worth copying. The heel following the toe by 0.167 s is not: on a jump whose apex is only 8.7 cm above the box the instruction is a whole foot down, and the ankle closing 105.0 to 78.7 degrees over those five frames is how the rig draws a soft landing, not how to aim one.",
               "NASM lists landing with straight knees among its box-jump errors, and the force cost is measured, though never on a box: Myers 2011 had 16 healthy adults land from 40 cm and recorded peak vertical force of 1.63 against 2.60 body weights, with 55.4 against 36.8 degrees of knee travel, when they were told to land softly rather than stiffly, and Guy-Cherry 2018 measured 1.34 against 1.81 body weights across soft and stiff landings in 30 participants from the same height. Neither study used a box, and no study shows that any landing cue changes an injury rate."),
   # ONE PLAIN glow() CALL PER ROW OF PAINT, in row order, each written out in
   # full - no shared helper. Every joint named is one of the 26 in
   # BoxJump_A.json. The two BRIGHT rows get A and the four DIM rows get SOFT:
   # here A against SOFT is the PAINT TIER and nothing else, not depth and not
   # a side, because this model's paint is two-sided on every mesh (no _L/_R
   # suffix anywhere) and the joints are symmetrical to 0.57 degrees at the
   # knee through the jump - so no glow claims a near side, a far side or which
   # face of a limb points at the camera. glow() averages joints.json's eight
   # probed samples, which on this clip span the stand, the dip, the flight and
   # the box hold, so these are static placements and not phase means. The six
   # centres, which are all distinct: quads (0.652, 0.563), glutes
   # (0.687, 0.471), gastrocnemius (0.622, 0.621), soleus (0.643, 0.687),
   # hamstrings (0.687, 0.521), hip flexors (0.665, 0.486). The dy nudges exist
   # only to separate ellipses that would otherwise coincide - thigh_L plus
   # thigh_R happens to average to exactly the pelvis centre on this clip - and
   # the ellipses do overlap, which is honest: BicepsFemoris, Semimembranosus
   # and Semitendinosus are painted over the same stretch of thigh.
   glows=[glow("Box Jump", ["thigh_L", "patella_L", "thigh_R", "patella_R"],
               A, 0.55, rx=0.10, ry=0.075, dy=0.03),
          glow("Box Jump", ["pelvis"], A, 0.50, rx=0.095, ry=0.06),
          glow("Box Jump", ["shin_L", "shin_R"], SOFT, 0.30, rx=0.085,
               ry=0.05, dy=0.02),
          glow("Box Jump", ["shin_L", "foot_L", "shin_R", "foot_R"], SOFT,
               0.28, rx=0.075, ry=0.045, dy=0.025),
          glow("Box Jump", ["thigh_L", "thigh_R"], SOFT, 0.26, rx=0.09,
               ry=0.055, dy=0.05),
          glow("Box Jump", ["pelvis", "thigh_L"], SOFT, 0.24, rx=0.07,
               ry=0.05, dx=-0.03, dy=0.015)])

# The setup steps and each cue's `correct` string are the ONLY coaching a
# reader sees outside the gated trainer (ExerciseCatalog.swift:115-122 exposes
# `setup` and the cues' titles plus `correct` and throws intro, why and mistake
# away; `mistake` is behind the trainer AND the paywall), so the step-down
# convention is carried here as well as in the down cue's `correct`, and no
# step leans on a number the reader has not been given. Step 1 names NASM's
# 12-to-18-inch beginner range as a STARTING point and not as a finding; the
# gated set-up `why` carries Dos Santos 2024, the fact that no study compares
# box heights, and the three coaching sources that disagree about how to pick
# one. Step 1 also says the surface has to take both whole feet, which nothing
# in the draft said, and it no longer uses the words land flat - that clause
# meant the box in the draft and the foot in the landing cue, which a reader
# had no way to tell apart.
SETUP["Box Jump"] = [
    "Pick a box with room for both whole feet on top and low enough that you can land on it with your knees bending - around 12 to 18 inches if it is new to you - and check that it will not slide or tip.",
    "Stand facing it, about a foot's length back from its near face.",
    "Clear the floor between you and the box, give yourself room to step down beside it, and jump early in the session while your legs are fresh.",
    "Brace your trunk and let your arms hang loose and a little wide, ready to swing back.",
    "Between reps step off the box one foot at a time rather than jumping down, and if a jump comes up short let your feet miss the box rather than reaching for the edge.",
]
# ==================================================================== step-up jump

# --------------------------------------------------------------- step-up jump
#
# Step-Up Jump (Legs/StepUpJump), yaw -1.3, zoom 0.743, offset
# (0.062, -0.065, -0.225), 382 x 655. 384 FRAMES AT 24 FPS = 15.958 s - twice
# the length of every other clip in this round except Box Jump, so nothing
# here is counted per 192 frames. TWO byte-identical reps of 192 frames =
# 8.000 s each (the halves agree to 0.0009 mm on all 26 joints at every
# frame; frame 0 and frame 383 agree to 0.00 mm, so the last frame is a
# duplicate of the first). Every time below is rep 1; add 8.000 s for rep 2.
# Only 4.292 s of each 8.000 s cycle moves (0.542-4.792 s); the other 3.708 s,
# 46% of the clip, is a dead freeze in the set-up pose, with no joint moving
# more than 1 mm.
#
# At yaw -1.3 the camera depth is 0.9636*x + 0.2675*z, so this is very nearly a
# pure LEFT-SIDE PROFILE (scapula_L sits 274.5 mm nearer than scapula_R, chest
# only 5.8 mm nearer than spine). Two consequences every pill below depends on:
# the lifter's LEFT reads at HIGH u, i.e. on the frame's TRAILING side
# (scapula_L u 0.718 against scapula_R 0.661), and the lifter FACES the
# frame's LEADING edge (chest u 0.699 < spine u 0.711). The box is bottom-left,
# the floor foot bottom-right.
#
# Equipment is one mesh, Cube: the plyo box, 0.840 m wide x 0.380 m tall x
# 0.640 m deep, top face at y 0.368, and it NEVER MOVES - centroid travel
# 0.000000 m and no bbox corner varying by more than 0.000000 m over all 384
# frames. It projects to u 0.179-0.697, v 0.728-0.935 and enters only drawn
# row 0.80, for all 16.00 s, at u 0.274-0.281.
#
# WHAT THE NAME GETS WRONG, and the reason three of the five cues are worded
# the way they are: NOBODY STEPS UP. The left foot starts on the box and is
# over its footprint in 384 of 384 frames (x range 11 mm, z range 66 mm); the
# right foot starts flat on the floor and ends at the identical point, 0.0 mm
# in x and 0.0 mm in z; the lifter is never standing on the box with both feet
# at any frame. This is a single-leg vertical jump performed FROM a box by the
# lead leg, set-up pose and finish pose identical, and the left leg leads in
# both reps and never alternates. So no string here says step up onto the box,
# bring the trail foot up, or alternate legs.
#
# This is also the one ONE-SIDED paint in the family: 13 of the 14 painted
# meshes carry an explicit (L) and the paint agrees with the motion that the
# left leg is the working leg (Legs/BoxJump 0 sided meshes, Legs/SquatJump 0,
# Legs/JumpRope 0, Legs/StepUpJump 13).
#
# Sources, kept apart from the measurements. THERE IS NO EMG STUDY OF A
# STEP-UP JUMP, so no cue here claims a muscle level, a muscle ranking or an
# outcome for this lift. The one measurement published under this name is
# Glassbrook, Dorman, Doyle, Wade & Fuller 2024, Eur J Sport Sci 24(8):
# 1086-1094 - ten professional male rugby league players, in-season, 24.9 +/-
# 2.7 y and 108.2 +/- 8.8 kg, body mass only, a 600 Hz force plate under a
# 41.5 cm box; it measured peak vertical force, total impulse and maximal rate
# of force development and NO EMG, and found the jump at 63.5 +/- 7.2 N/kg of
# peak force against 23.3, 27.8 and 28.7 N/kg for three loaded step-up
# variations, with about 2006 N/s/kg of RFD against about 755 for a barbell
# one-box step-up with a catch (SMD 3.9-5.5, p < 0.001). The landing figures
# come from Myers et al. 2011, Am J Sports Med 39(8):1714-1722 (16 healthy
# adults, 6 male and 10 female, dropping from 40 cm: peak vertical ground
# reaction force 1.63 +/- 0.73 body weights landing soft against 2.60 +/- 1.32
# landing stiff, P < .001) and Guy-Cherry et al. 2018, Sports Med Int Open
# 2(2):E35-E40 (30 participants, the same 40 cm: 1.34 soft, 1.50
# self-selected, 1.81 stiff body weights, p < 0.001; and NO difference in EMG
# of gluteus maximus, quadriceps, hamstrings, tibialis anterior or
# gastrocnemius across the three styles, p > 0.66). The coaching is ACE
# exercise library #230 Single-Leg Push-Off (one foot on the box, hinged
# forward from the hips, drive the boxed foot into the box, swing both arms up
# and in front, land softly and quietly on the mid-foot, do not lock the knee,
# same reps each leg) and #28 Step-Up, both read 2026-10-30, both labelled as
# coaching wherever they are used.
# Deliberately NOT used: any %MVIC or activation fraction for this lift (none
# exists); Neto et al. 2020's 125% and 169% MVIC step-up figures in any
# fractional form; a box height presented as a finding (nothing compares
# heights, and Glassbrook's 41.5 cm is one protocol - the setup step's
# a-little-below-knee-height is coaching and says so); ACE #28's knee-over-the-
# second-toe rule as a NUMBER, i.e. nothing here names a toe the knee should
# track over; any claim that a landing cue prevents an injury or changes which
# muscle works.
# TWO CONVENTIONS ARE USED, both labelled here and neither measured on this
# lift. The landing cue says the catching knee points out over the toes: a
# safety convention, carried because the library badges it six times
# (KNEES CAVING IN) and because a one-leg catch from flight is where it bites,
# not because anything in this clip measures it. And the flight cue asks for
# the back leg to stay quiet and underneath rather than be kicked up: the draft
# refused any trailing-leg claim and then made one anyway, reading the rig's
# passive swing leg as an instruction (at the apex, f46, patella_R is 0.1903 m
# BELOW the pelvis and hip_R is 121.05 degrees). A dangling trail leg is not
# what you want on a one-foot catch onto a box - it is the leg nearest the edge
# - so the cue takes the middle position, which does not depend on the rig
# either way, and the rig measurement stays in the `why`.
#
# THE PAINT AND THE ROWS. tiers_jump.json key Legs/StepUpJump: 14 meshes,
# 8 BRIGHT, 6 DIM, 0 FAINT. Bright: the three glutes (GluteusMaximus,
# GluteusMedius, GluteusMinimus, all L), the three vasti (Intermedius,
# Lateralis, Medialis, all L), RectusFemoris (L) and Sartorius (BOTH sides).
# Dim: GastrocnemiusLateral (L), GastrocnemiusMedial (L), Soleus (L),
# Semimembranosus (L), Semitendinosus (L) and BicepsFemoris (L). Written with
# spaces so part_of() resolves them, that is quads 4 bright, glutes 3 bright,
# hamstrings 3 dim and calves 3 dim, plus the sartorius, which resolves to
# nothing and rides in the legend-only Hip Flexors row.
# The six rows below are rows.md 8.2 unchanged. CARRIES: Quadriceps 0.82 and
# Gluteus Maximus 0.64 from stepUpContent (SampleData.swift:10882), the
# nearest library entry, with all three painted glutes in the one Gluteus
# Maximus row; Gastrocnemius 0.30 from the three explosive lifts of this round
# (powerSnatchContent, dumbbellSnatchContent, dumbbellCleanAndPressContent),
# the floor of every secondary gastrocnemius row; Soleus 0.30 from
# dumbbellLyingLegCurlContent (SampleData.swift:48226), the library's only
# secondary Soleus row. ESTIMATES, and marked as such: Hip Flexors 0.40, which
# the PAINT and not the literature makes primary - it is the lowest HIP FLEXORS
# primary in the library, used 11 times at exactly that value for exactly this
# reason, and no Hip Flexors row of either rank sits between 0.24 and 0.36. It
# is NOT the lowest bright-row value in the library, as the draft and rows.md
# 8.2 both say: 26 primary rows sit below 0.40 (14 at 0.30, five at 0.34, one
# at 0.35, three at 0.36 and three at 0.38), and three secondary Hip Flexors
# rows sit strictly between 0.24 and 0.40 at 0.36 and 0.38. Neither correction
# moves the estimate, which stands at 0.40; both narrow what is claimed for it.
# And Hamstrings 0.25, where both
# parents keep the hamstrings as a stabiliser so there is no fraction to
# carry, brackets 0.20 and 0.30, with 0.25 the value four shipped blocks of the
# squat-and-press family use for a secondary hamstring row (legPressContent,
# verticalLegPressContent, wideStanceLegPressContent, hackSquatStancesContent -
# three of the library's six leg presses plus one hack squat, which is not a
# leg press). Not one of the six is sourced to a measurement of this lift.
# OPEN POINTS this entry hands the owner, all of them rows.md 7 and none of
# them decided here:
#   7.1 The calf tier runs opposite to the measured ankle travel. This lift
#       moves the lead ankle about 75 degrees over the drive (77.7 to 153.1,
#       peaking at 156.6 two frames later in the air) and 80.49 degrees over
#       the whole clip (76.12 to 156.61), and is painted DIM, so the table says
#       LOW; Jump Rope moves it 25.92 degrees and is painted bright, so the
#       table says HIGH. rows.md open point 1's figures for the same spans are
#       stale; see the family header.
#   7.2 + 7.3 The dim soleus as a row at all, and the resulting two calf rows
#       tied at 0.30, which breaks the house gastrocnemius-above-soleus gap
#       every other calf pair keeps. Three lifts shipped in this same round do
#       the opposite and put soleus in the stabilisers.
#   7.4 Gluteus Medius is dropped against the parent: stepUpContent carries
#       Gluteus Medius .primary 0.44 and nothing replaces it, so the family's
#       one one-legged lift names no frontal-plane muscle at all.
#   7.7 + 7.9 Hip Flexors 0.40 is an estimate, and the sartorius it stands for
#       is the ONE two-sided mesh on the family's one one-sided model - so the
#       work it names belongs to the swing (right) leg while every other row
#       is left-only, and the row cannot say which side it means.
#   7.6 Hamstrings 0.25 is an estimate.
#   Legend (rows.md 8.5): the primary line is 42 characters against a 40-44
#       character budget, so Hip Flexors is the row at risk of being cut, and
#       it is the row the app drops from TARGET MUSCLES as well (Box Jump open
#       point 9).
#   THE DEFINING INSTRUCTION WAS PAYWALLED. That the back foot does nothing
#       lived only in drive.mistake, which sits behind the trainer AND
#       paywall.show(.mistake), while step 2 told the reader to leave that foot
#       flat on the floor and nothing told them it comes off. A reader who
#       springs off both legs has done the parent exercise's own badged fault,
#       BACK FOOT PUSHING. drive.correct now says the back foot goes light and
#       that the jump is straight up, and the cue title reads Drive Up Off the
#       Box, so the ungated reader gets the mechanic. The gated mistake is
#       unchanged.
# One measurement correction this entry hands back to measure_Step-UpJump.md
# section 7: that report's ceiling table lists 0.48 trailing as having no
# clean length (it swept down to 9 characters only) and calls 0.16 trailing
# unusable for leaders at any length. Re-measured below at shorter lengths and
# per joint, 0.48 trailing is clean of the lifter at 7 characters (+3.1 px,
# 0 frames) and 6 (+8.7 px), and foot_R gives a clear leader from 0.16
# trailing at every length up to 15 characters. Both findings are load-bearing
# here: they are what makes five clean slots exist on this lift.
ex(name="Step-Up Jump", var="stepUpJump",
   # LABEL GEOMETRY. Five pills, five slots, every number measured at the pill
   # the app DRAWS (half-height 0.025 in v, width (24 + 5.6*len)/382, pinned
   # EDGE 0.035 from the leading or trailing frame edge) against the 655-row
   # SKINNED silhouette, the box's whole projected point cloud and the HEAD's
   # own silhouette, over ALL 384 FRAMES - room.py and lead.py in the round
   # folder. RAW slot -> DRAWN row: 0.14 -> 0.16, 0.32 -> 0.32, 0.50 -> 0.48,
   # 0.68 -> 0.64, 0.86 -> 0.80. The overrides below are RAW; every figure in
   # this block is the DRAWN row.
   #
   #   stance  0.64 leading, 15 ch - lifter 11.6 px, 0 overlap frames; box
   #           46.5 px away, inside 0 of 384 frames; leader to toe_L on the
   #           face 0/384 (it never spans the head rows at all)
   #   dip     0.32 trailing, 11 ch - lifter 14.3 px, 0 overlap frames; box
   #           263.0 px away, inside 0/384; leader to spine on the face 0/384,
   #           closest 17.1 px at t=5.21. lead.py and chk.py agree on that
   #           figure to the decimal, and both report 0 frames. (The draft
   #           quoted 9.9 px here and explained it by saying the two tools
   #           measure different heads - chk.py the DRAWN head, lead.py the
   #           head's own silhouette. Both halves of that are wrong: 9.9 px is
   #           reproducible from neither tool, and chk.py's head_sil() loads
   #           the same <Name>_HEAD.npz that lead.py does, so they test the
   #           identical silhouette - only chk.py's docstring still describes
   #           a drawn-head box. The margin is 17.1 px, i.e. better than the
   #           draft claimed, so the anchor choice stands.)
   #   drive   0.48 trailing, 7 ch - lifter 3.1 px, 0 overlap frames; box
   #           177.1 px away, inside 0/384; leader to foot_L on the face
   #           0/384 (never spans the head rows)
   #   flight  0.16 trailing, 13 ch - lifter 19.9 px, 0 overlap frames; box
   #           362.2 px away, inside 0/384; leader to foot_R on the face
   #           0/384, closest 11.3 px at t=4.58
   #   land    0.80 leading, 9 ch - lifter 178.7 px, 0 overlap frames; box
   #           16.8 px away, inside 0/384; leader to patella_L on the face
   #           0/384 (never spans the head rows)
   #
   # So: 5 of 5 pills clear the skinned lifter at every one of the 384 frames,
   # 5 of 5 leaders are clear of the head at every frame, and NO PILL EVER
   # CROSSES THE BOX - there is no load crossing to declare on this lift.
   # Every one of those fifteen figures was re-measured by chk.py off this
   # entry itself, which uses the stricter DRAWN head rather than the head's
   # own silhouette, and it agrees on all of them.
   #
   # Why these five, with the numbers for what was rejected:
   # - ONLY FOUR of the ten slots clear the lifter at a normal label length,
   #   and the fifth exists only because the length was pushed down. At 9
   #   characters the six rejected slots are 0.16 leading -57.1 px / 10
   #   frames, 0.32 leading -70.4 / 10, 0.48 leading -42.1 / 14, 0.64 trailing
   #   -34.3 / 216, 0.80 trailing -45.9 / 258, and 0.48 trailing -8.1 / 14.
   #   Shortening does not rescue the five leading-side and bottom-trailing
   #   ones: at 3 characters 0.16 leading is still -23.5 px / 4 frames, 0.32
   #   leading -36.8 / 6, 0.48 leading -8.5 / 4, 0.64 trailing -0.7 / 2 and
   #   0.80 trailing -12.3 / 232. The top three leading rows are broken by the
   #   ARM SWING, and deeply - row 0.16 leading goes from +111 px at 1.500 s
   #   to -14 px at 1.583 s and -57 px at 2.083 s - and the two bottom
   #   trailing rows are broken by the standing lifter himself, for 216 and
   #   258 frames, the whole 3.708 s freeze included. 0.48 trailing is the one
   #   that recovers: -8.1 px at 9 characters but +3.1 px and 0 frames at 7,
   #   +8.7 at 6, +14.3 at 5. That is why the drive label is the 7-character
   #   one and why it is the only slot in this frame with a single-digit
   #   margin; the alternative was a fifth pill on a row that sits on the
   #   lifter for 216 frames or more.
   # - Pill ceilings (last length with 0 overlap frames), from the fine sweep:
   #   0.64 leading 17 ch (+0.4 px; 16 ch +6.0, 15 ch +11.6), 0.16 trailing
   #   16 ch (+3.1; 13 ch +19.9), 0.32 trailing 13 ch (+3.1; 11 ch +14.3),
   #   0.48 trailing 7 ch (+3.1), and 0.80 leading with no lifter limit at all
   #   (+94.7 px at 24 ch) but a BOX limit: 11 ch leaves 5.6 px, 12 ch 0.0 px
   #   with still 0 frames inside, and 13 ch and up put the box inside the
   #   pill on all 384 frames. Each label sits at least two characters inside
   #   its ceiling except the drive, which sits ON it.
   # - Anchors. Rows 0.48, 0.64 and 0.80 are safe by construction: the head's
   #   own silhouette spans v 0.003-0.356, so a leader from a pill at v 0.48
   #   or below to a joint at or below that pill cannot enter a row the head
   #   occupies, and lead.py reports all 25 non-head joints CLEAR 0/384 from
   #   each of those three slots at the lengths used. The only joints that even
   #   reach head height from them are the arms, and their margins are NOT the
   #   same across the three slots, as the draft had it: from the two LEADING
   #   slots (0.64 at 15 ch and 0.80 at 9 ch) forearm_L is 7.6 px, hand_L
   #   42.6 and 45.4 and hand_R 72.7 and 74.2, but from 0.48 TRAILING at 7 ch
   #   the same three are 2.1 px, 2.4 px and 49.7 px - an order of magnitude
   #   tighter at the near arm. Still clear on every frame, and the drive slot
   #   anchors at foot_L anyway, but 2.1 px is the figure to re-check if this
   #   clip or its framing ever changes, not 7.6.
   #   Row 0.32 trailing is clear for 23 joints and NOT for the near arm -
   #   at the 11 characters used, hand_L is on the face 8/384 frames (closest
   #   -10.2 px at 1.667 s) and forearm_L 2/384 (-1.6 px) - which is why the
   #   dip takes spine (+17.1 px) rather than an arm. No length rescues the
   #   arm: 8 frames at 10 ch (-12.4 px), 8 at 11, 4 at 13 ch (-5.8 px), and
   #   13 ch is the slot's own ceiling, so lengthening the label walks the
   #   anchor edge left and halves the failure without ever clearing it. (The
   #   draft reported 4 frames and -5.8 px for 11 ch, which are the 13 ch
   #   figures, and -0.3 px for forearm_L, and then contradicted itself by
   #   giving 8 frames for the same slot and length in the next clause.)
   # - Row 0.16 trailing is the hard one and foot_R is the only robust anchor
   #   in it. The pill anchor edge sits at u 0.6676-0.7409, just outside the
   #   head's own u range of 0.361-0.704, so a leader dropping to anything at
   #   mid-u crosses the skull: at 16 characters ALL 25 joints are on the face
   #   for 196-266 frames each. Per length, the clear count is 0 at 16 ch, 1
   #   at 15 (foot_R, 2.3 px), 4 at 14 (foot_R 6.8), 9 at 13 (foot_R 11.3,
   #   toe_R 5.7, thigh_R 0.5), 11 at 12 and 11, 12 at 10 and 12 at 9 (the
   #   draft's table said 11 at 12-10; re-measured, 10 ch gives 12 - chest,
   #   foot_L, foot_R, patella_R, pelvis, scapula_L, shin_R, spine, thigh_L,
   #   thigh_R, toe_R and upper_arm_L). foot_R at 13
   #   characters was taken because it is the widest margin available anywhere
   #   in that row (11.3 px, against toe_R 5.7, thigh_L 5.1, scapula_L 4.3,
   #   pelvis and spine 2.8) AND because the swing foot is what this cue is
   #   about. patella_L, the knee a flight cue might otherwise want, is NOT
   #   clear from this row at any length - it sits at u 0.498, inside the
   #   head's u span.
   # - The box forced only one choice: the landing label went to 0.80 leading
   #   at 9 characters, which leaves 16.8 px to the box, rather than the 11 or
   #   12 characters the slot would also take at 5.6 and 0.0 px.
   #
   # Label strings. Two are the library's own, reused because the cue is the
   # same: Legs up (7 characters, 3 entries - Dumbbell Snatch/pull, Dumbbell
   # Clean and Press/pull, Kettlebell Clean and Press/drive, all of them the
   # leg-drive cue of an explosive lift) and Soft knee (9 characters, 3
   # entries - the knee cue of the three Single-Leg Romanian Deadlifts, which
   # are the library's own one-legged lifts). Three are new, and each only
   # because nothing in the library that says the right thing fits the room
   # measured above:
   #   Flat on the box (15) - the library's own string for this is Whole foot
   #     on the box (21, Barbell Step-Up/foot and Dumbbell Lateral Step-Up/
   #     foot), and 21 characters do not fit any of the five slots: the widest
   #     ceiling in this frame is 17. Shortened to its one idea.
   #   Slight lean (11) - the parent's own torso string is Chest up, slight
   #     lean (21, Step-Up/torso), again over every ceiling; this is its
   #     second clause, kept because the first one would be wrong here (the
   #     trunk pitches to 27.5 degrees, so the chest does not stay up).
   #     Torso upright (13) and Dip straight down (17), the two library
   #     strings that would fit, both contradict the measurement.
   #   Both feet off (13) - the library has no flight label at all in 462
   #     blocks; its only plyometric labels are Plyometric Push-Up's Land on
   #     soft elbows (19) and Hands land in place (19), both over the 13-
   #     character ceiling of this slot and both about the hands.
   # Deliberately not reused: Drive through the top foot (26, Step-Up/drive),
   # the parent's own drive label, because that cue's named fault is pushing
   # off the floor with the back foot, which turns it into a jump - which is
   # this lift. Its wording, its mistakeCue and its badge are all left alone.
   overrides={"stance": (0.68, "leading"), "dip": (0.32, "trailing"),
              "drive": (0.50, "trailing"), "flight": (0.14, "trailing"),
              "land": (0.86, "leading")},
   annotations=[
       ("stance", "Flat on the box", "toe_L"),
       ("dip", "Slight lean", "spine"),
       ("drive", "Legs up", "foot_L"),
       ("flight", "Both feet off", "foot_R"),
       ("land", "Soft knee", "patella_L"),
   ],
   cues={
       "stance": ("On the Box",
                  "You begin with your whole working foot already up on the box and the other foot flat on the floor behind you.",
                  "The clip opens and closes in the same pose, held still for 3.708 s of every 8.000 s cycle. The lead knee is already at 73.3 degrees and the lead hip at 94.8, the trunk is 9.6 degrees forward of vertical and the arms hang with the elbows at 171.7. The whole lead foot is on the box, the ankle 0.081 m and the toe 0.028 m above its top face, and it stays over the box footprint in 384 of 384 frames - 11 mm of side-to-side travel and 66 mm of fore-and-aft travel in the entire clip. The feet are 0.300 m apart sideways and 0.560 m apart front to back, and the floor foot ends the rep at the point it started, to 0.0 mm in both directions. The box is 0.840 m wide, 0.380 m tall and 0.640 m deep, which is 85% of this lifter's knee height, and it does not move by one micrometre at any frame. So this is a jump taken FROM a box by one leg, not a climb onto it: the lifter is never standing on the box with both feet, and the left leg leads in both reps. Box height is a choice, not a finding - no study compares step heights, and the 41.5 cm box in the one published measurement of this lift is that protocol's box, not a recommendation.",
                  "Setting only the ball of the foot or the toes on the box, with the heel hanging over the edge.",
                  "Put the whole of one foot flat on the box with the heel on the surface, leave the other foot flat on the floor behind you, and keep that same foot on the box for every rep of the set."),
       "dip": ("Lean and Load",
               "You lean out over the box foot and let that knee and ankle fold a little, then jump straight out of it.",
               "The dip is small and it is not a squat. Over 0.542 to 0.833 s the lead knee closes from 72.9 to 65.3 degrees and the lead ankle from 88.8 to 79.2, but the pelvis drops only 0.015 m, from 0.856 m to 0.841 m. What actually travels is the trunk: it pitches from 10.0 to 27.5 degrees by 1.167 s, by which point the knee is already opening again. The lead knee passes 0.050 m in front of its own toe at the bottom and peaks 0.069 m past it, from 0.012 m behind at rest. The arms contribute nothing to this: the near hand moves at most 0.191 m from its resting place over the first 28 frames and its swing does not begin until 1.208 s. Reading those angles together, the load goes on by leaning the body over a foot that is already high rather than by sinking - that reading is mechanics, the angles are measured. ACE's own power version of this lift starts hinged forward from the hips, which is the same shape and is coaching, not measurement; ACE's upright-torso rule belongs to the strength step-up and carrying it here would be an inference.",
               "Sitting the hips back into a squat, or dropping straight down with the chest kept upright.",
               "Let your chest travel forward over the box foot until your weight is on it, sink a couple of inches at that knee and ankle with your arms hanging, and jump straight out of the bottom."),
       "drive": ("Drive Up Off the Box",
                 "One leg does all of it: the box leg straightens hard and throws you up off the box.",
                 "The floor foot leaves at the very start of this phase: the trail toe is off the ground at 1.208 s and take-off is at 1.708 s, so for the whole 0.500 s that produces the jump there is nothing under the back foot, and it stays airborne for 3.292 s in all. In the 12 frames from 1.208 to 1.667 s, 0.458 s, the lead knee opens from 69.2 to 167.3 degrees, the lead ankle from 77.7 to 153.1 - it peaks at 156.6 two frames later, in the air - and the trunk comes back from 26.6 to 4.5. The heel leaves the box before the toe does, 69 mm up at 1.667 s with the toe still down. Both hands climb 1.540 m, from 0.851 m at the hips to 2.391 m overhead, with the elbows never bending past 159.1 degrees, and the two arms mirror each other to one micrometre. The one measurement published under this name is of force, not of muscle: Glassbrook 2024 put ten professional male rugby league players on a plate under a 41.5 cm box and recorded 63.5 N/kg of peak vertical force for the step-up jump against 23.3 to 28.7 N/kg for three loaded step-up variations, and about 2006 N/s/kg of rate of force development against about 755 for a barbell step-up with a catch. No EMG of a step-up jump exists, so nothing here ranks one muscle against another.",
                 "Keeping the back foot down and springing off the floor with it, so the jump comes out of two legs.",
                 "Put your weight over the box foot and let the back foot go light, then drive that whole foot down into the box until the knee and ankle are straight, jumping straight up rather than forward, and swing both arms up past your head as you leave."),
       "flight": ("In the Air",
                  "For a moment nothing is touching anything, and the back leg adds nothing to the height.",
                  "Both feet are off at once for 0.458 s, from 1.708 to 2.167 s - and that is the only window in the clip when they are. Measured from f40, the last frame the lead toe is on the box, the lead toe rises 0.208 m, the lead ankle 0.217 m, the pelvis 0.216 m and the whole-skeleton centroid 0.210 m; measured against the lifter's own fully extended stance on the box, where the pelvis sits at 1.282 m, the apex pelvis of 1.550 m is 0.268 m of air. The swing leg does much less than the usual coaching line suggests. At its highest, 1.917 s, the right kneecap is still 0.190 m BELOW the pelvis and the right hip angle is 121.05 degrees - it bottoms at 110.8 only later, on the catch at 2.417 s - so that thigh is never horizontal and the knee never reaches hip height. The hands finish 0.154 m above the head joint at their own apex, f44, and reach 0.194 m above it at f40, high enough that the near one leaves the top of the trainer frame for 10 of the 384 frames. One caution: the arc is animated rather than thrown. A 0.458 s hang would need a 0.257 m rise of the centre of mass and the measured rise from take-off is 0.210 m, about 82% of it, so no jump height can be read off the hang time or the other way round. Glassbrook 2024's force figures for this lift were taken at the box, in ten professional men, and say nothing about height. The cue does not ask you to copy that passive swing leg, either: on a one-foot catch onto a box the trail leg is the limb nearest the edge, so keeping it quiet and underneath you is the instruction, and that is a convention rather than anything this clip measures.",
                  "Kicking or tucking the back leg up to try to gain height, or letting it swing loose while you are in the air.",
                  "Stay tall through the middle of the jump with both arms up and your eyes forward, and keep the back leg quiet and underneath you rather than kicking it up for height."),
       "land": ("Land and Stand",
                "The same foot catches you back on the box on its own, and then you stand all the way up on that one leg.",
                "The lead toe is back on the box at 2.167 s and the foot lands on the spot it left: 5.5 mm across and 31.3 mm fore-and-aft from its last contact point. The knee is already re-flexed to 120.0 degrees before it touches and then gives only 3.8 degrees, to a low of 116.2, so almost none of the absorbing happens there - it happens in the trunk, which re-pitches from 13.1 to 24.1 degrees and reaches 25.3 by 2.417 s, and in the ankle, which gives from 110.0 to 88.8, while the pelvis comes down from 1.212 m to 1.163 m - a 4.9 cm give inside the catch itself, at the end of a 38.7 cm fall from the 1.551 m apex. That trunk fold is the animation's shortcut and not the lift: a one-leg catch absorbed at the trunk puts the drop through the lower back, so take it at the knee and the ankle instead of copying what you see here. Then a second, slower extension on the same leg: knee 119.1 to 166.9, hip 127.7 to 164.9, trunk 24.1 back to 3.6, pelvis up to 1.282 m, with a 0.333 s still hold balanced on the left leg at the top. The other foot does not reach the floor until 4.500 s, and it returns to the identical place it left. Landing soft is measured to cost less force, in two groups at the same 40 cm drop: Myers 2011 recorded 1.63 body weights soft against 2.60 stiff in 16 healthy adults, and Guy-Cherry 2018 1.34 soft, 1.50 self-selected and 1.81 stiff in 30 participants. ACE's cue for this lift is to land softly and quietly on the mid-foot and not to lock the knee, which is coaching, as is the knee tracking out over the toes that the cue asks for - nothing in this clip measures that, and the library badges it six times. Neither force study measured an injury outcome, so none is promised here.",
                "Catching the whole landing on a straight knee, letting the knee fall inward, or letting the heel slam down flat on the box.",
                "Let the same foot come back down well inside the edge of the box, let the knee and ankle bend as you catch yourself with that knee pointing out over your toes, then stand all the way tall on that leg before you lower the other foot down."),
   },
   # rows.md 8.2 unchanged: 6 rows, 3 primary, 4 carries and 2 estimates, with
   # the reasoning and the owner's open points in the comment above the entry.
   # Hip Flexors is the legend-only name for the bright Sartorius, which
   # part_of() drops; Quadriceps and Gluteus Maximus are the two primaries the
   # app actually counts.
   activation=[("Quadriceps", P, HI, 0.82), ("Gluteus Maximus", P, MOD, 0.64),
               ("Hip Flexors", P, MOD, 0.40), ("Gastrocnemius", S, LOW, 0.30),
               ("Soleus", S, LOW, 0.30), ("Hamstrings", S, LOW, 0.25)],
   stabilisers=["core", "adductors", "erector spinae", "tibialis anterior"],
   # The badge has to avoid two traps. The parent's own badge is BACK FOOT
   # PUSHING and Dumbbell Lateral Step-Up's is PUSHING OFF THE FLOOR, and both
   # name springing off the floor foot - which is what this lift is for, so
   # neither badge nor either mistakeCue is reusable. And a step-up is a
   # legitimate exercise the app ships separately, so finishing on the box is
   # not a fault either. What is left, and what this lift genuinely owns, is
   # the landing: one leg catches a 38.7 cm fall, 1.551 m to 1.163 m of
   # pelvis height. STIFF-LEG LANDING is new (the library has no such badge;
   # the shape is Plyometric Push-Up's STIFF-ARM LANDING, the library's only
   # landing badge). THE CORRECT NOTE DOES NOT HOLD THE MODEL UP AS THE SOFT
   # LANDING, and the draft's did. A comparison shows the model as the correct
   # side, so a note that offers this clip's 3.8 degrees of knee give as the
   # picture of softness hands the reader a near-locked knee in the same breath
   # as a badge calling a locked knee the fault - and 3.8 degrees is below both
   # cited studies' STIFF conditions (36.8 and, by implication, less). It also
   # broke this module's own rule, the one Jump Rope's badge comment cites from
   # this very entry: no badge for a fault the model performs. The badge itself
   # stays, because a one-leg catch from flight onto a box is exactly where
   # this lift can hurt someone; only the evidence stops pointing at the model.
   # The mistakeNote states the honest limit, because the same study that
   # measured the force found no EMG difference at all between landing styles
   # and a HIGHER reactive strength index for the stiff one.
   comparison=("STIFF-LEG LANDING", "Land soft on the box leg",
               "Catches it on a locked knee",
               "Dropping from 40 cm, Myers 2011 had 16 healthy adults peak at 1.63 body weights of force landing softly against 2.60 landing stiffly, with 55.4 degrees of knee travel from contact against 36.8, and Guy-Cherry 2018 measured 1.34 against 1.81 in 30 participants at the same height. This model gives only 3.8 degrees at the knee on the catch, 120.0 to 116.2, and folds the trunk from 13.1 to 25.3 degrees to take the rest - less knee than either study's soft landing, so take the drop at the knee and ankle rather than copying the trunk.",
               "What it costs is force and joint angle only: Guy-Cherry 2018 put electrodes on five leg muscles across soft, stiff and self-selected landings in 30 participants, found no difference in any of them, and scored the stiff landing higher for reactive strength, 0.93 against 0.64. Neither study tested an injury outcome."),
   # ONE PLAIN glow() PER ROW OF PAINT, six rows and six calls, written out
   # with literal arguments. Bright paint takes A at 0.50-0.55, dim paint SOFT
   # at 0.28-0.30, following the Push Jerk. Every joint named here is one of
   # the 26 in Step-UpJump_A.json. These centres are glow()'s mean of
   # joints.json's EIGHT probed moments, so each one is a STATIC placement on
   # the body and not a phase mean. The dx signs come from the framing, which
   # is measured: the lifter faces the frame's leading edge, so the FRONT of
   # the body reads at lower u (joints.json's eight-sample means, which glow()
   # uses: chest 0.652 against spine 0.665; frame 0 of the clip itself gives
   # 0.699 and 0.711) and the back
   # at higher u - hence the quadriceps and sartorius glows carry a negative
   # dx and the glute and hamstring glows a positive one. All six sit on the
   # LEFT leg except the hip-flexor one, which spans both thighs on purpose:
   # the sartorius is the only two-sided mesh in this paint, and open point
   # 7.9 above is exactly that the work it names is the SWING leg's.
   glows=[glow("Step-Up Jump", ["thigh_L", "patella_L"], A, 0.55, rx=0.075, ry=0.075, dx=-0.012),
          glow("Step-Up Jump", ["pelvis", "thigh_L"], A, 0.55, rx=0.055, ry=0.05, dx=0.026, dy=-0.012),
          glow("Step-Up Jump", ["thigh_L", "thigh_R"], A, 0.50, rx=0.085, ry=0.045, dx=-0.032, dy=-0.014),
          glow("Step-Up Jump", ["shin_L", "foot_L"], SOFT, 0.30, rx=0.045, ry=0.055, dx=0.026, dy=-0.026),
          glow("Step-Up Jump", ["shin_L", "foot_L"], SOFT, 0.28, rx=0.033, ry=0.04, dx=0.03, dy=0.026),
          glow("Step-Up Jump", ["thigh_L", "patella_L"], SOFT, 0.30, rx=0.06, ry=0.065, dx=0.046, dy=0.03)])

# Step 1 carries the stability check, which the draft gave to Box Jump and not
# to this lift - the wrong way round, because this is the one lift of the four
# that drives off one foot, puts 26.8 cm of pelvis height into the air and
# catches the whole descent on that same foot on the box. A box that shifts
# under a two-foot landing is a stumble; under a one-foot landing it puts the
# lifter off the side of it. Step 4 carries the bail, because SETUP is at its
# five-step ceiling and the draft told the reader nothing about a jump that
# comes up short.
SETUP["Step-Up Jump"] = [
    "Set a box a little below knee height in front of you and check that it will not slide, tip or flex when you land on it with one foot.",
    "Place the whole of one foot flat on the box with the heel on the surface.",
    "Lean forward a little over the box foot so your weight sits on it, let your arms hang, and brace your trunk.",
    "Learn it as a step with no jump first, and if a jump comes up short, step down onto the floor rather than reaching for the edge of the box.",
    "Between reps lower the box foot under control and put the other foot back on the same spot on the floor, then reset before the next one.",
]
# ==================================================================== squat jump

# ------------------------------------------------------------------- squat jump
#
# Squat Jump (Legs/SquatJump), yaw -0.8, zoom 0.67, offset
# [0.02, -0.077, -0.021], 192 frames at 24 fps (0.000-7.958 s), 382 x 655 - the
# same framing the app uses (SampleData.swift:3043, jobs.py). THREE identical
# reps of exactly 64 frames = 2.6667 s each: lag 64 agrees to 0.000524 mm on all
# 26 measured joints, the next nearest lag is 276.5 mm (lags 1, 63 and 65) and
# the half-period lags 32 and 96 are 1283.5 mm, so every time below
# is rep 1 and repeats at t + 2.667 s and t + 5.333 s (the three dip-bottom
# frames f24, f88 and f152 are bit-identical). The clip loops, but the loop is
# free rather than engineered: the rig holds a frozen standing pose for 13 frames
# straddling every rep boundary, so frame 191 and frame 0 are two frames inside
# the same still pose. 35 of the 191 frame-to-frame steps move nothing at all -
# 1.458 s of the 8.000 s, 18.2 % of the clip, is that frozen stand.
#
# IT IS THE ONLY BODYWEIGHT LIFT IN THE FAMILY AND IT CARRIES NOTHING. eq_names
# is empty and eqc, eqbox and eqpts are empty on all 192 frames; a read-only
# scan of the stage finds exactly two prims with any mesh in it,
# Anatomy_MasterRig (125 meshes) and DARK_Floor, and the leftover
# GYM_Barbell_ROOT Xform holds no mesh. room.py therefore prints load distance
# 1000000000.0 px and load-inside 0 frames at every one of the ten slots, and no
# label on this lift can ever cross a load. The shoes and shorts in the stills
# are rig garments (Anatomy_Shoes_WhiteSneaker, Anatomy_Shorts_Surface), not
# equipment, and the shorts matter to the paint - see the glows comment.
#
# The five things a writer gets wrong here, all measured:
# (1) THREE REPS, not one. Any tempo claim has to be rep-local.
# (2) THE LEGS PAUSE AT THE BOTTOM AND THE ARMS DO NOT. Over f24-f27 (0.167 s)
#     22 of the 26 measured joints move 0.000 mm while each hand travels
#     367.6 mm and each elbow 196.5 mm. So this is neither the laboratory squat
#     jump (which holds the squat with the hands on the hips) nor a textbook
#     continuous countermovement jump. The rule the measurement supports is
#     about what may be claimed OF THE MODEL: no string may say the hands are
#     held still, and no string may DESCRIBE this clip as running the descent
#     and the drive together without a break. What the lifter is TOLD at the
#     bottom is a separate question, and the dip cue answers it - jump straight
#     back up out of the bottom without settling there, which is Catalyst
#     Athletics' side of the disagreement recorded in that cue's `why` and the
#     exact complement of its own `mistake`. The draft read the rule as a ban
#     on the instruction too, so the free reader was told nothing either way,
#     and then broke its own reading in SETUP step 4 (dip and jump as one
#     movement), which is the forbidden sentence about the model in the one
#     place an ungated reader was certain to see it.
# (3) THE ANKLE IS THE ONLY JOINT THAT GOES PAST ITS STANDING ANGLE, which is
#     not the same thing as the hip and knee stopping short. Measured from the
#     bottom of the dip, where the extension of a jump is measured from, the
#     model extends FULLY: knee_L 84.098 at f24 to 167.008 at f34, take-off,
#     82.91 deg - the value is flat to 1.2e-5 deg through the flight, so argmax
#     lands on f36 by 7e-6 of a degree -
#     and hip_L 93.399 to 166.874, 73.48 deg. And 167 IS this rig's straight -
#     the clip's knee maximum anywhere is 167.008 on the left and 167.277 on
#     the right and its hip maximum 166.910 and 166.918, all within 0.27 deg of
#     take-off, and the standing pose itself is 166.83 / 166.87. (Step-Up Jump
#     reaches the identical ceiling, 167.319, and its drive cue says the knee
#     and ankle are straight there, so the draft's rule was not even applied
#     inside this one file.) So what nothing here may say is that the model
#     extends PAST its standing angle at the hip or knee, or that its knee
#     reaches 180 deg - NOT that it fails to finish. The one joint that does go
#     past standing is the ankle: 104.99 to 146.58 deg, 41.6 deg past standing
#     (76.10 at the bottom of the dip, so 70.48 deg from there and 68.79 deg
#     from f28, where the drive cue starts), held
#     unchanged through the whole flight.
# (4) THE DIP IS ABOVE PARALLEL AND IT HINGES. At the bottom the thigh is 25.9
#     deg BELOW horizontal - so the HIP sits 18.8 cm ABOVE the knee (f24
#     thigh_L y 0.6099 against patella_L y 0.4218, both sides within 0.01 deg)
#     - with the knee at 84.10 deg, the trunk 41.08 deg forward, the hips
#     15.00 cm rearwards and the head 26.30 cm forward of where it started. So
#     it is not a deep squat and an upright-chest cue would contradict the
#     model, which is why Squat (the parent) lending Chest up (8 chars, x10) is
#     NOT reused here. The draft said 28.91 deg and the knee above the hip:
#     the second half contradicted its own above-parallel conclusion, and the
#     number could not be reproduced - thigh_L to patella_L at f24 gives 25.94
#     deg and thigh_R to patella_R 25.95, and from the pelvis joint 23.49.
#     Handed back to measure_SquatJump.md as a correction.
# (5) THE LANDING IS NOT THE DIP. It bottoms at 122.09 deg of knee, 38 deg
#     shallower than the dip's 84.10 and 45 deg of flexion from the standing
#     166.83, and the first frame after touchdown loses 30.5 deg of knee in
#     1/24 s with the heel still 6.85 cm off the floor.
#
# SOURCES. There is no EMG study of a squat jump as a training exercise, so no
# cue below claims a muscle level, a muscle ranking or an outcome, and the five
# fractions are carries (see the activation comment). The measured literature
# cited is: Bobbert, Gerritsen, Litjens & Van Soest 1996 (six male volleyball
# players; CMJ 3.4 cm higher than SJ from the same start position, the
# difference coming from greater joint moments at the start of push-off, with a
# Hill-type model ruling out stored elastic energy); Chiu, Bryanton & Moolyk
# 2014 (sixteen women volleyball players, force plates plus six-camera motion
# capture, no EMG: a longer pelvis-to-knee extension delay went with higher
# jumps, r = 0.82, p < 0.001 with arm swing and r = 0.58, p = 0.02 without, and
# the arm swing raised hip extensor and ankle plantar flexor net joint moments,
# thigh and leg angular accelerations and jump height, p <= 0.05); Myers et al.
# 2011 (sixteen healthy adults, six male and ten female, biplane fluoroscopy,
# 40 cm drop: soft landing peak vertical ground reaction force 1.63 +/- 0.73
# against stiff 2.60 +/- 1.32 body weights, P < .001, knee flexion range from
# contact to peak flexion 55.4 +/- 8.8 against 36.8 +/- 11.1 deg, P < .01, with
# tibial translation and rotation similar between the styles); Guy-Cherry et al.
# 2018 (thirty participants, three 40 cm landing styles: ground reaction force
# soft 1.34, self-selected 1.50, stiff 1.81 body weights, p < 0.001, reactive
# strength index soft 0.64 BELOW stiff 0.93 and self-selected 0.96, p < 0.001,
# and NO difference in EMG for gluteus maximus, quadriceps, hamstrings,
# tibialis anterior or gastrocnemius in any comparison, p > 0.66); Milner et al.
# 2012 (adult female recreational athletes: the instruction to land softly
# reduced peak vertical force and increased peak knee flexion). The coaching
# cited is the NSCA squat jump / static vertical jump TEST protocol (lower to
# roughly 110 deg of knee, hold 2-3 s, hands on the hips throughout, the
# countermovement removed) and Catalyst Athletics Back Squat Jump (change
# direction immediately in the bottom), which disagree with each other about
# whether a squat jump pauses - recorded, not resolved.
# Deliberately NOT used: Ebben, Simenz & Jensen 2008 per-exercise values or its
# ranking (normalisation not stated in the abstract, full text unavailable);
# Heick 2020 gluteal %MVIC (none of its four tasks is this lift, and its own
# authors attribute the 103 % to the normalisation); any claim that a landing
# cue changes muscle activity (Guy-Cherry found none) or prevents an injury
# (no study here tested an intervention); the secondhand 5-15 % CMJ-over-SJ
# figure; any optimal dip depth or jump height, because none is measured.
#
# THE PAINT, re-read from tiers_jump.json key Legs/SquatJump: 13 painted names,
# 10 BRIGHT, 3 DIM, nothing faint; every one resolves to BOTH an _L_Mesh and an
# _R_Mesh, so 26 of the rig's 125 meshes are lit and nothing is one-sided.
# Bright: VastusIntermedius, VastusLateralis, VastusMedialis, RectusFemoris
# (quads); GluteusMaximus, GluteusMedius, GluteusMinimus (glutes);
# GastrocnemiusLateral, GastrocnemiusMedial, Soleus (calves). Dim:
# Semimembranosus, Semitendinosus, BicepsFemoris (hamstrings). Two part_of()
# traps in that list and both are mesh names with the space removed:
# part_of(RectusFemoris) returns None and part_of(BicepsFemoris) returns
# biceps - the ARM - so 2 of the 13 are misfiled by anyone who copies the mesh
# names; written as Rectus Femoris and Biceps Femoris they resolve to quads and
# hamstrings. Rows below use the group names instead, so neither trap is live.
# ROWS AND FRACTIONS ARE ALL CARRIES BAR ONE, and not one is a measurement of a
# jump: Quadriceps P 0.84 and Gluteus Maximus P 0.56 carry from squatContent
# (SampleData.swift:12280, the bodyweight two-leg squat, whose own comment
# reports the same paint - bright quads and glutes); Gastrocnemius P 0.78 and
# Soleus P 0.60 carry from bodyweightStandingCalfRaiseContent (38656), the
# bodyweight tier, because this lift is unloaded; Hamstrings S 0.25 is an
# ESTIMATE - both candidate parents keep hamstrings as a stabiliser, so there is
# nothing to carry, and 0.25 is the squat-and-press family's own value
# (legPressContent, verticalLegPressContent, wideStanceLegPressContent,
# hackSquatStancesContent), bracketed by 0.20 below (eight entries) and 0.30
# above (three). The calf pair is a calf-raise number sitting on a jump.
# OPEN POINTS THIS ENTRY HANDS THE OWNER (rows.md 7, library.md 8):
#  - THE FLIGHT CUE SPENDS A FIFTH OF THE PUBLIC COACHING ON DRIFT while the
#    badged fault is the knees. flight.correct is the shortest string of the
#    twenty (120 characters) and names a fault this clip rules out - the feet
#    land where they left to 0.000 mm in x, y and z - and the badged fault,
#    KNEES CAVING IN, has no cue of its own: knees tracking out over the toes
#    is a mid-sentence clause of land and of dip. Giving the slot to the knees
#    would re-measure five pills and five slots, so it is the owner's call and
#    not this entry's.
#  - rows.md 10, the big one: four primaries. The legend line
#    QUADRICEPS . GASTROCNEMIUS . SOLEUS . GLUTEUS MAXIMUS is 53 characters
#    against a 40-44 character budget, so GLUTEUS MAXIMUS (positions 39-53) is
#    cut on every viewport; and on this model the glutes are ALSO invisible in
#    the render (see the glows comment). Painted bright, drawn nowhere, cut from
#    the legend, and present only in the Muscles Worked sheet. The options are
#    accept it, reorder Gluteus Maximus ahead of Soleus (thin precedent: FIVE
#    of the 462 blocks are non-descending within a rank - reverseCurlContent,
#    declineSitUpContent, barbellPowerCleanContent, hangCleanContent and
#    dumbbellHangCleanContent; the draft said six and named none), or re-paint.
#    Not decided here.
#  - rows.md 2 and 3, for the round rather than this lift: whether a dim soleus
#    takes a row at all. It does not bite here, where the soleus is bright.
#  - rows.md 6: Hamstrings 0.25 is the one estimate in this list.
#  - rows.md 13: all four stabilisers are judgement, not paint - stabilisers are
#    by definition unpainted, so tiers_jump.json can neither confirm nor refute
#    core, erector spinae, anterior deltoid or tibialis anterior. The model does
#    not paint ErectorSpinae, RectusAbdominis, the obliques or either tibialis,
#    although the rig carries all of them, so a core or lower-back row would
#    have no paint behind it; they are named as stabilisers instead.
#  - rows.md 14: nothing in this entry is sourced to a measurement of a squat
#    jump, because none exists.
#  - measure_SquatJump.md 0: the USD scans need
#    PXR_AR_DEFAULT_SEARCH_PATH=.../Resources/Models/Shared - the plain Models
#    path in the round brief does not resolve AnatomyBodyV2.usdc and the rig
#    comes back with zero meshes. Worth fixing in the brief.
ex(name="Squat Jump", var="squatJump",
   # LABEL GEOMETRY. Five pills, five slots, measured at the pill the app DRAWS
   # (half-height 0.025 in v, width (24 + 5.6 * len)/382, pinned EDGE = 0.035
   # from the leading or trailing edge) against the 655-row SKINNED silhouette
   # and the HEAD's own silhouette, over all 192 frames (room.py and lead.py in
   # the round folder). Rows quoted here are the DRAWN rows; `overrides` below
   # carries the RAW 0.14 / 0.32 / 0.50 / 0.68 / 0.86 values that spec_1029.py's
   # row() squeezes to the drawn 0.16 / 0.32 / 0.48 / 0.64 / 0.80. There is no
   # load on this lift, so every load figure is room.py's 1000000000.0 px and
   # 0 inside-frames and no pill crosses anything but the lifter.
   #
   #   dip     0.48 trailing,  9 ch (Hips back) - lifter 18.1 px, 0 of 192
   #           overlap frames; load 1000000000.0 px, inside 0/192; leader to
   #           pelvis CLEAR 0/192 frames, closest 99.2 px at t = 1.00
   #   arms    0.16 trailing, 14 ch (Swing the arms) - lifter 6.8 px, 0/192;
   #           load 1000000000.0 px, 0/192; leader to upper_arm_L CLEAR 0/192,
   #           closest 15.8 px at t = 1.42
   #   drive   0.80 trailing, 10 ch (Heels lift) - lifter 27.6 px, 0/192; load
   #           1000000000.0 px, 0/192; leader to foot_L CLEAR 0/192 (it never
   #           spans the head's own v rows at all)
   #   flight  0.32 trailing, 11 ch (Straight up) - lifter 15.8 px, 0/192; load
   #           1000000000.0 px, 0/192; leader to toe_L CLEAR 0/192, closest
   #           44.7 px at t = 1.38
   #   land    0.80 leading,  10 ch (Soft knees) - lifter 59.7 px, 0 of 192
   #           overlap frames; load 1000000000.0 px, inside 0/192; leader to
   #           patella_L CLEAR 0/192 (never spans the head rows)
   #
   # Why those five and not others, in numbers:
   # - SIX of the ten slots have room at all and FOUR are dead at every label
   #   length, so with five annotations there is exactly one spare. Dead even at
   #   8 characters: 0.32 leading (-14.3 px, 6 frames), 0.48 leading (-29.5 px,
   #   6), 0.64 leading (-12.7 px, 3) and 0.64 trailing (-14.2 px, 24). Row 0.64
   #   is the row the hips and the hands both sweep; the two leading slots at
   #   0.32 and 0.48 fail on the forward arm swing, which reaches u 0.138 at row
   #   0.48. Longest clean label per usable slot: 0.80 leading 20 ch (3.7 px,
   #   failing at 21), 0.16 trailing 15 ch (1.2 px), 0.80 trailing 14 ch
   #   (5.2 px), 0.32 trailing 13 ch (4.6 px), 0.48 trailing 12 ch (1.3 px),
   #   0.16 leading 12 ch (2.3 px).
   # - The landing label is the library's Soft knees (10), the same string Box
   #   Jump uses for the same cue, and 0.80 leading is the roomiest slot in the
   #   frame for it: 59.7 px of lifter clearance at 10 characters against the
   #   next slot's 29.2 (0.80 trailing), with the leader to patella_L never
   #   entering a row the head occupies. The slot would also take a much longer
   #   string - 20 characters is still clean at 3.7 px, and an 18-character
   #   Land on soft knees leaves 14.9 px - but the family rule is that the same
   #   cue carries the same label, and nothing here forces a different one: the
   #   invented 18-character string was dropped for that reason, not for room.
   #   For the record, had it been needed it had exactly one home: at 18
   #   characters 0.48 trailing is -32.3 px and on the lifter in 174 of 192
   #   frames, 0.16 trailing -15.6 px / 15 frames and 0.80 trailing -17.2 px /
   #   192 frames.
   # - arms takes 0.16 trailing because 0.32 trailing - the slot nearest
   #   upper_arm_L (v 0.306-0.532, mean 0.419) - caps at 13 characters: at the
   #   14 this label needs it reads -1.0 px and sits ON the lifter in 18 frames.
   #   0.80 trailing at 14 ch is clean (5.2 px, upper_arm_L never spans the head
   #   rows) but it is 0.40 away in v from the joint and it is the drive's own
   #   slot, which sits 0.019 from foot_L. Stretching this label to 15 ch to use
   #   0.16 trailing's ceiling would leave 1.2 px, so 14 is the ceiling in
   #   practice; it still clears upper_arm_L by 15.8 px and scapula_L by 14.9.
   # - flight takes 0.32 trailing at 15.8 px rather than 0.48 trailing, which is
   #   clean at 11 ch but only by 6.9 px, and rather than 0.16 leading, which is
   #   clean on the lifter at 11 ch (7.9 px) but where the leader to toe_L is ON
   #   THE FACE in 15 of 192 frames (closest -2.0 px at t = 1.00, runs
   #   0.96-1.12, 3.62-3.79, 6.29-6.46). That failed leader is why 0.16 leading
   #   is the spare slot: from it only foot_R (9.4 px), patella_R (24.8),
   #   shin_R (25.1), toe_R (22.3) and upper_arm_R (1.2 px, marginal) are clear,
   #   i.e. nothing on the lifter's left and nothing above the hip.
   # - dip takes 0.48 trailing rather than 0.32 trailing, which has MORE pill
   #   room at 9 ch (27.0 px against 18.1) and whose pelvis leader is also clear
   #   (51.3 px): row 0.48 is the pelvis's own row (v 0.476-0.652, mean 0.577),
   #   so the leader is 0-66 px of vertical reach instead of 102-213 px. Both
   #   are legal; the shorter leader wins.
   # - Anchors. No slot in this frame gives a clean leader to hand_L or
   #   forearm_L: they are on the face from 0.16 trailing (18 and 33 frames),
   #   0.32 trailing (15 and 21), 0.48 trailing (18 and 24) and 0.80 trailing
   #   (18 and 24), always and only while the arms swing overhead in flight. So
   #   the arm cue is anchored at the SHOULDER, which is also where the swing
   #   physically happens - the elbow only moves 13.24 deg all clip. The other
   #   four anchors are safe by construction as well as by measurement: pelvis
   #   (v 0.476-0.652), patella_L (0.609-0.727), foot_L (0.744-0.831) and toe_L
   #   (0.787-0.856) all sit below the head's own drawn silhouette, whose rows
   #   over this clip are 131-328 (v 0.200-0.501), so a leader from a pill at
   #   0.32, 0.48 or 0.80 cannot enter it. upper_arm_L is NOT covered by that
   #   argument and is clear for a per-frame reason instead: lead.py reports it
   #   CLEAR on all 192 frames from row 0.16 trailing at 14 ch with 15.8 px to
   #   spare. That is a property of this clip's poses, so it must be re-measured
   #   if the animation or the framing changes.
   # - Head geometry, for the record: the crown of the drawn head sits 36.9-38.5
   #   px above the head joint (mean 37.6) and the head is 0-38.8 px wide in its
   #   own rows where the full silhouette reaches 165.8 px, so neither a box
   #   round the head joint nor the whole body at head height is the right test,
   #   exactly as the jerk family found.
   #
   # LABEL STRINGS. Two are the library's own, one is a one-word swap of the
   # library's only landing label, two are new because the library has no
   # jumping lift at all:
   #   Hips back (9) - x13 in the library, e.g. dumbbellRomanianDeadliftContent
   #     /hips (SampleData.swift:9743), which uses the same cue, the same pelvis
   #     anchor and the same trailing side, and bStanceRomanianDeadliftContent
   #     /hinge. Reused rather than Dip straight down (17, x5 on the jerk and
   #     push-press family) because this dip hinges: the hips travel 15.00 cm
   #     rearwards and the trunk 41.08 deg forward, so straight down is false.
   #   Heels lift (10) - x1, dumbbellCleanAndPressContent/extend
   #     (SampleData.swift:49433), written this round and deliberately inverting
   #     Heels down. It is the right one here for a measured reason: the ankle
   #     is the ONLY joint that extends past its standing angle on this lift.
   #     Push the floor away (19, x3 including barbellPowerCleanContent/extend)
   #     is the library's triple-extension label and is not used as the label,
   #     because there is no triple extension to name; it survives inside the
   #     drive cue's `correct`, where it is a floor instruction and not a claim
   #     about the joints.
   #   Soft knees (10) - REUSE x3 in the library (the Smith Machine, Cable and
   #     Kettlebell Romanian Deadlift knee cue), and the string Box Jump uses
   #     for its own two-foot landing in this same family, so the two
   #     two-footed landings read identically; Step-Up Jump's Soft knee (9) is
   #     the singular of it because that lift lands on one leg. The library's
   #     only landing label proper is Land on soft elbows (19,
   #     plyometricPushUpContent/land, SampleData.swift:37228), from its only
   #     plyometric entry, and an 18-character Land on soft knees off that
   #     pattern was drafted here and dropped: this slot has room for it
   #     (14.9 px) but the family already had a string for this cue.
   #   Swing the arms (14) - NEW. The library has no arm-swing label: Squat's
   #     own arms label is Arms reach forward (18, x2), which is a counterbalance
   #     in a squat and not a swing, and nothing in the file describes an arm
   #     swing that goes behind the body and then overhead.
   #   Straight up (11) - NEW. Nothing in the library describes a flight path,
   #     because nothing in the library leaves the floor on two feet.
   overrides={"dip": (0.50, "trailing"), "arms": (0.14, "trailing"),
              "drive": (0.86, "trailing"), "flight": (0.32, "trailing"),
              "land": (0.86, "leading")},
   annotations=[
       ("dip", "Hips back", "pelvis"),
       ("arms", "Swing the arms", "upper_arm_L"),
       ("drive", "Heels lift", "foot_L"),
       ("flight", "Straight up", "toe_L"),
       ("land", "Soft knees", "patella_L"),
   ],
   cues={
       "dip": ("The Dip",
               "You bend your knees and send your hips back and down into a shallow squat before you jump.",
               "The dip takes 0.750 s, from the last frozen frame at 0.250 s to 1.000 s. The knee goes 166.83 deg to 84.10 - 82.73 deg at a mean 110 deg/s - the hip 166.87 to 93.40, the trunk 1.58 deg to 41.08 forward and the ankle 105.0 to 76.1, while the pelvis drops 29.28 cm and goes 15.00 cm rearwards. It stays ABOVE PARALLEL: at the bottom the thigh is 25.9 deg below horizontal, the hip 18.8 cm above the knee. The heels are flat the whole way down, the first heel rise coming at f28, after the bottom; and the knees travel out, knee to knee going 0.3022 m standing to 0.5062 m at the bottom with the ankles frozen 0.3000 m apart, so each knee finishes about 10 cm outside its own ankle, 5.89 cm outside its own toe and 6.93 cm ahead of it. (Knee to knee peaks at 0.5151 m at f30, in the drive and not in the dip, which is the figure the draft quoted for this sentence.) Two conventions disagree about what comes next and this model sits between them: the NSCA squat jump test lowers to roughly 110 deg of knee and holds it 2-3 s with the hands on the hips, while Catalyst Athletics teaches changing direction immediately in the bottom; the model pauses the legs 0.167 s and swings the arms right through the pause. Bobbert 1996 measured six male volleyball players jumping 3.4 cm higher with a countermovement than from a held squat, attributing it to joint moments at the start of push-off and not to stored elastic energy. No study measures an optimal dip depth.",
               "Sinking to a full squat, or settling at the bottom long enough that the dip stops helping the jump.",
               "Bend your knees and send your hips back and down until your thighs are just above parallel, keeping your heels flat and your knees travelling out over your toes, then jump straight back up out of the bottom without settling there."),
       "arms": ("The Arm Swing",
                "Your arms swing back behind you as you dip, then forward and up as you jump.",
                "The swing happens at the shoulder, not the elbow: the elbow sits at 171.75 deg standing, its minimum anywhere is 158.51 and its whole range 13.24 deg. Measured against its own shoulder joint, the hand is 36.28 cm BEHIND at f21 (0.875 s, the rearmost point), 52.32 cm IN FRONT at f31 (1.292 s), 36.19 cm ABOVE the shoulder at take-off and 46.86 cm above it at the apex - so the swing is still rising 10.66 cm after the feet have left the floor. It runs straight through the pause in the legs: over f24-f27, 0.167 s, 22 of the 26 measured joints move 0.000 mm while each hand covers 367.6 mm in a straight line - 374.7 mm of path - and each elbow 196.5 mm, 200.2 mm of path. Each hand covers 13.82 m over the clip against the pelvis's 4.39 m, the fastest single frame anywhere in it is 27.65 cm of travel by a hand, and the two arms mirror to under a micrometre. Chiu, Bryanton and Moolyk 2014, sixteen women volleyball players with motion capture, found the arm swing raised hip extensor and ankle plantar flexor joint moments and jump height, p <= 0.05; it recorded no EMG, so nothing here says which muscle the swing recruits. Taking the arms out is not a fault - it is the NSCA test protocol, which pins the hands to the hips to remove them.",
                "Letting the arms hang through the jump, or throwing them by bending the elbows instead of swinging them.",
                "Let your arms swing back behind you as you dip, then throw them forward and overhead as you drive, keeping your elbows long and the swing coming from your shoulders."),
       "drive": ("The Drive",
                 "Out of the bottom you push the floor away and finish up on the balls of your feet.",
                 "The drive takes 0.250 s, 1.167 to 1.417 s. The knee goes 84.70 deg to 167.01 at a mean 329 deg/s peaking at 898 in one frame, the hip 96.24 to 166.87, the trunk 38.82 deg forward to 0.33, and the pelvis rises 34.80 cm. The heels come up in order - 0.47 cm at f28, 1.65 at f29, 3.15 at f30 and 6.85 cm at take-off with both toes still planted - and stay up 0.7917 s a rep. The measurement that governs the cue: the ankle is the only joint that goes PAST its standing angle. From its 77.79 deg at f28, where this drive starts, it runs to 146.58 at take-off, 68.79 deg over the drive - 70.48 deg measured from the 76.10 at the bottom of the dip - and finishes 41.6 deg past the 104.99 it stands at, holding that angle through the entire flight. The hip and the knee do finish, they just stop at the pose the rig stands in: knee 84.70 to 167.01 against 166.83 standing, hip 96.24 to 166.87 against 166.87. That standing pose is also the clip's ceiling - knee maximum 167.01 on the left and 167.28 on the right, hip maximum 166.91 and 166.92 - so 167 is this rig's straight, about 13 deg short of a drawn 180, and nothing here reads the rig as a knee that stops short. Chiu 2014 measured the order rather than the amount: a longer delay between pelvis and knee extension went with higher jumps in sixteen women volleyball players (r = 0.82, p < 0.001 with an arm swing). No EMG of a squat jump exists, so nothing here says which muscle drives it: the calves rank primary because the model paints them bright, a painting decision and not a measurement.",
                 "Driving up flat-footed and leaving the floor with the heels down, so the ankles add nothing to the jump.",
                 "Push the floor away hard and keep pushing until your hips and knees are all the way open, then let your heels come up so you leave the ground off the balls of your feet."),
       "flight": ("Flight",
                  "You leave the floor with both feet at once and come back down on the same patch of floor.",
                  "Nine frames are fully airborne, f35 to f43, 0.3750 s of contact-free frames; fitting the toe height across them gives a parabola clean to 6.0e-08 m that crosses the resting toe height at frame 34.023 and frame 43.977, so the true flight time is 0.4148 s. The implied acceleration is 9.810 m/s2 and the take-off speed 2.035 m/s, which gives the measured IN-FLIGHT rise exactly: from take-off at f34, 21.10 cm at the toe and 21.29 cm at the ankle, the pelvis and the head alike. Measured instead against the standing pose the ankle finishes 28.14 cm higher, the pelvis 27.77 and the head 27.87, the difference being the extension taken before the feet leave. Below the shoulders the body is one rigid block that only translates - knee, hip, trunk and ankle gap are frozen to within 0.00001 deg over f34-f44 - while the ankles splay 3.94 cm as the plantarflexion rolls them outward, the toes staying put. Both feet leave and land together: foot_L and foot_R never differ in height by more than 0.204 mm across all 192 frames. And the feet land exactly where they took off, to 0.000 mm in x, y and z; over the whole 8 s the toes move 2.53 mm sideways and 7.80 mm front to back, so the jump is purely vertical, with no drift and no stance reset between reps. The 21.10 cm is this animation and not a target: no source prescribes a height for a training squat jump.",
                  "Drifting forward, back or sideways in the air, or leaving the floor one foot at a time.",
                  "Jump straight up off both feet together, and land on the same patch of floor you left with your feet where they started."),
       "land": ("The Landing",
                   "You land on the balls of your feet and let your knees bend to absorb the drop.",
                   "The toes touch at f44 with the ankle still at 146.58 deg and the heel 6.85 cm off the floor - a ball-of-foot landing - and the heel is not flat until f47, 0.125 s later. The knee then loses 30.5 deg in a single frame, 167.01 to 136.50 at 732 deg/s, and bottoms at 122.09 deg with the hip at 137.09 and the trunk 20.83 deg forward, the pelvis 10.30 cm below standing. So the landing is 38 deg shallower at the knee than the dip - 122.09 against 84.10, which is 45 deg of flexion from the standing 166.83 - and is absorbed in a quarter of a second; the stand-up then takes 0.333 s. What the softness buys is measured as force and joint angle, never as muscle work. Myers 2011, sixteen healthy adults landing from 40 cm under biplane fluoroscopy: peak vertical ground reaction force 1.63 +/- 0.73 body weights soft against 2.60 +/- 1.32 stiff (P < .001), knee flexion 55.4 +/- 8.8 deg against 36.8 +/- 11.1 (P < .01). Guy-Cherry 2018, thirty participants over three 40 cm landing styles: force 1.34 soft, 1.50 self-selected, 1.81 stiff body weights (p < 0.001), and NO difference in the EMG of five muscles (p > 0.66). A soft landing is about taking the force, not about working a muscle harder, and no study here shows a landing cue changing an injury rate.",
                   "Landing with straight legs, letting the knees fall inward, or slapping both heels down flat instead of rolling through the forefoot.",
                   "Land toes first on the balls of your feet with your knees tracking out over your toes, let your heels settle and your knees bend to take the drop, then stand up and stand still before the next rep."),
   },
   # Rows, stabilisers and fractions exactly as the row stage settled them
   # (rows.md 8.3 and library.md 3): FIVE rows, FOUR of them primary, fraction
   # descending, which is this family's only four-primary list. Bright paint, so
   # primary: the four quadriceps meshes as one Quadriceps row, the two
   # gastrocnemius heads as one Gastrocnemius row, Soleus as its own row (it is
   # painted bright here, so the dim-soleus fork of rows.md 2 does not arise),
   # and the three glutes as ONE Gluteus Maximus row - the rig lights maximus,
   # medius and minimus together and the owner confirmed on 2026-10-30 that the
   # paint is not split, so no list names the medius. Dim paint, so secondary:
   # the three hamstring meshes as one Hamstrings row.
   # Every fraction is a CARRY except one, and NONE is a measurement of a jump:
   # Quadriceps 0.84 and Gluteus Maximus 0.56 from squatContent
   # (SampleData.swift:12280), whose 0.56 is itself an EMG fraction promoted by
   # a rank change; Gastrocnemius 0.78 and Soleus 0.60 from
   # bodyweightStandingCalfRaiseContent (38656) - the BODYWEIGHT tier, because
   # this lift carries nothing - which puts a calf-raise pair above a squat's
   # glute on a jump, and says so; Hamstrings 0.25 is an ESTIMATE, the
   # squat-and-press family's own value (legPressContent and its three
   # siblings), bracketed by 0.20 below and 0.30 above, because both candidate
   # parents keep hamstrings as a stabiliser and there is nothing to carry.
   # The one thing measured here that bears on the tier is the ankle: 41.6 deg
   # of plantarflexion, the only joint that extends. That is consistent with a
   # bright calf; it is not evidence for 0.78 or for ranking the calves above
   # the quadriceps, and the copy does not claim either. The unpainted groups
   # get no rows - the model paints no erector spinae, no abdominal, no oblique
   # and neither tibialis, although the rig carries all of them - and are named
   # among the stabilisers instead, with tibialis anterior there because the
   # toes touch down 0.125 s before the heels and anterior deltoid kept from
   # squatContent because the arm swing is large and measured (each hand travels
   # 13.82 m against the pelvis's 4.39 m).
   activation=[("Quadriceps", P, HI, 0.84), ("Gastrocnemius", P, HI, 0.78),
               ("Soleus", P, MOD, 0.60), ("Gluteus Maximus", P, MOD, 0.56),
               ("Hamstrings", S, LOW, 0.25)],
   stabilisers=["core", "erector spinae", "anterior deltoid", "tibialis anterior"],
   # The badge is the library's own KNEES CAVING IN, which squatContent - this
   # entry's row parent - already carries at SampleData.swift:12347, with five
   # more at 6534, 16842, 31165, 32592 and 47476; five of the six pair it with
   # the mistakeCue `Knees collapse inward` and :32592 with `Knees cave in
   # toward each other`. It is the right badge here for three reasons. The
   # fault is the one a repeated two-foot landing from flight genuinely owns,
   # and the only landing fault in this family with a mechanism behind it. The
   # MODEL DEMONSTRATES THE CORRECT SIDE of it exactly, which is the best thing
   # a comparison can have: knee to knee 0.3022 m standing to 0.5062 m at the
   # bottom of the dip while the ankles stay frozen 0.3000 m apart, so each knee
   # finishes about 10 cm outside its own ankle, on both legs, which never
   # differ by more than 0.269 deg at the knee. And the draft's own badge,
   # FLAT-FOOTED TAKE-OFF with `Heels never leave the floor`, was the weakest
   # of this lift's five slots: in any vertical jump the foot pivots over the
   # forefoot and the heel leaves, so the mistakeCue is close to unperformable
   # (the real version is incomplete plantarflexion, a smaller and different
   # thing); its correctCue `Finish up on your toes` was the drive cue's public
   # `correct` in five words, spending the one comparison slot on restating
   # cue 3; and its own mistakeNote conceded the penalty is unmeasured. That
   # point keeps its home in the drive cue's `mistake`, where it already was.
   # Still not used: SQUATTING THE DIP (17, hangCleanContent), because a
   # deliberately deeper squat jump is a legitimate variant and this dip is
   # already above parallel; and STIFF-LEG LANDING, which Box Jump and Step-Up
   # Jump carry and whose fault this lift's landing cue already states.
   # The mistakeNote claims no injury outcome and no activation, and says what
   # the one study that measured the frontal plane actually found.
   comparison=("KNEES CAVING IN", "Knees out over the toes",
               "Knees collapse inward on landing",
               "In the model the knees travel out, not in: knee to knee goes from 0.3022 m standing to 0.5062 m at the bottom of the dip while the ankles stay 0.3000 m apart, so each knee finishes about 10 cm outside its own ankle, 5.89 cm outside its own toe and 6.93 cm ahead of it, on both legs, which never differ by more than 0.269 deg at the knee.",
               "When the knees fall inward the load twists through the knee joint and the glutes do less to help absorb the landing. That is a different axis from landing softly, not the same one: Myers 2011 measured varus and valgus motion as similar between soft and stiff 40 cm landings in 16 adults, so a soft landing does not by itself keep the knees out. No study here tested a knee cue on a jump, and none shows that any landing cue changes an injury rate."),
   # ONE PLAIN glow PER ROW OF PAINT, five rows and five calls, every joint one
   # of the 26 in this lift's own measure file. glow() averages joints.json's
   # EIGHT probed samples, so each centre is a static placement and not a phase
   # mean. Bright paint takes A, the dim hamstrings SOFT. The centres, computed:
   # quads u 0.565 v 0.634, gastrocnemius u 0.536 v 0.729, soleus u 0.578
   # v 0.792, glutes u 0.598 v 0.592, hamstrings u 0.598 v 0.622. The first
   # three sit inside the measured painted region - across the eight stills the
   # bright pixels cover 3775-4354 px per frame and all of them fall inside
   # v 0.437-0.817 and u 0.385-0.707, the front of the thighs and the calves,
   # with no painted pixel ever above v 0.437.
   # TWO HONEST CAVEATS, both of them rows.md open point 10. The GLUTE glow
   # marks the hip rather than visible paint, and the evidence for that is the
   # PIXEL COUNT, not the camera: whether this yaw -0.8 framing is a front or a
   # rear three-quarter is the open question the family header records and
   # nothing here depends on it. (The draft asserted a three-quarter FRONT view
   # and offered foot_L u 0.626-0.641 against foot_R 0.495-0.525 as the proof.
   # Those two numbers establish only which SIDE reads at high u, which the
   # header already settles for all four clips; they say nothing about front
   # against rear.) What is measured is that the rig wears
   # Anatomy_Shorts_Surface, whose hem reaches mid-thigh, and that the gluteal
   # paint does not reach the render at all: a v band of +/-0.045 centred on
   # the pelvis joint holds
   # 22,428-22,435 non-black lifter pixels on the three standing stills and only
   # 2, 8 and 16 tinted ones, of which 0, 0 and 13 are bright. The HAMSTRINGS
   # glow lands on the same screen region as the quadriceps glow, 0.012 lower in
   # v, because front and back of one thigh project to the same place; it is
   # SOFT and flatter for that reason. Neither is a claim about which side faces
   # the camera: the paint is bilateral on all 13 names, every one resolving to
   # both an _L_Mesh and an _R_Mesh, and the two legs never differ by more than
   # 0.269 deg at the knee.
   glows=[glow("Squat Jump", ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.55, rx=0.11, ry=0.075),
          glow("Squat Jump", ["shin_L", "shin_R"], A, 0.55, rx=0.10, ry=0.05, dy=0.03),
          glow("Squat Jump", ["foot_L", "foot_R"], A, 0.50, rx=0.09, ry=0.04, dy=-0.02),
          glow("Squat Jump", ["pelvis"], A, 0.50, rx=0.07, ry=0.045, dy=0.015),
          glow("Squat Jump", ["thigh_L", "thigh_R"], SOFT, 0.29, rx=0.10, ry=0.055, dy=0.045)])

# Step 1 allows the toes to be turned out, because the draft pinned them
# straight ahead in the one public step and then told the reader in the dip cue
# to travel the knees out over them, with the knee finishing 5.89 cm outside
# its own toe; the model's own feet are toed out, and the Jump Rope entry
# measures the same rig at 6.00 degrees of toe-out, so allowing it costs
# nothing. Step 4 no longer says dip and jump as one movement: that is the
# sentence trap (2) above forbids about this model, which pauses the legs
# 0.167 s at the bottom, and it was the one place an ungated reader met it.
SETUP["Squat Jump"] = [
    "Stand with your feet a little inside shoulder width, toes pointing forward or turned out slightly, weight over the whole foot.",
    "Let your arms hang at your sides with your elbows long, and brace your trunk.",
    "Clear a flat, non-slip patch of floor with room overhead, and jump early in the session while your legs are fresh.",
    "Land with your feet on the same spot and stand still for a moment before the next rep.",
]
# --------------------------------------------------------------- jump rope
# Legs/JumpRope, resource JumpRope, yaw -0.8, zoom 0.575, offset
# [0.049, -0.04, -0.05], 192 frames at 24 fps, 8.000 s (t 0.0000-7.9583).
# REMEMBER 192 FRAMES on this clip - Box Jump and Step-Up Jump run 384, this
# one does not. Everything below is read from measure_JumpRope.md, which reads
# JumpRope_A.json / _SIL.npz / _HEAD.npz / tiers_jump.json; four figures were
# re-measured for this entry alone by w_jr_draft/arm.py off the same
# JumpRope_A.json and are marked RE-MEASURED where they are used.
#
# WHAT THE MODEL IS. Not one rep: SIXTEEN identical bounces. The whole
# skeleton repeats exactly every 12 frames = 0.50000 s - every one of the 26
# probed joints satisfies |J[f] - J[f+12]| = 0.000 mm over all 180 valid pairs
# in x, y and z - so the clip is 16 cycles, 120 bounces a minute, with no
# set-up frame and no finish frame. |J[0] - J[180]| = 0.000000 mm on every
# joint to 0.000 mm (1.7e-5 mm exactly), so it loops as a cycle, but it does
# NOT end on the pose it starts on.
# The cycle is time-symmetric BELOW THE SHOULDERS ONLY: frame i and frame 12-i
# put the legs and trunk in the same pose to under 0.2 mm, but the forearms
# differ by up to 48.6 mm and the hands by 40.0 mm - which is the 18.34 degrees
# the elbow opens and closes, and is body, not rope.
#
# PAINT TOTALS (tiers_jump.json, key Legs/JumpRope): 10 painted meshes, 3
# BRIGHT, 7 DIM, 0 FAINT, and no mesh carries a side suffix, so everything is
# lit on BOTH sides. Bright: GastrocnemiusLateral, GastrocnemiusMedial, Soleus
# - calf only. Dim: VastusIntermedius, VastusLateralis, VastusMedialis,
# RectusFemoris (quads) and Semimembranosus, Semitendinosus, BicepsFemoris
# (hamstrings). This is the only one of the four jump lifts with NO GLUTE
# painted at all and the only one whose bright tier is nothing but calves
# (Box Jump 7 bright glutes+quads, Step-Up Jump 8 bright but all (L) only,
# Squat Jump 10 bright calves+glutes+quads). The library row agrees:
# SampleData.swift:365 lists Jump Rope, category .legs, primaryMuscle
# GASTROCNEMIUS, equipment JUMP ROPE, difficulty .beginner.
# part_of() traps this paint sets, verified 2026-10-30: part_of(RectusFemoris)
# returns None and part_of(BicepsFemoris) returns biceps - THE ARM - because
# both keywords need their space. Neither mesh is named below; both ride inside
# the Quadriceps and Hamstrings rows, which resolve correctly.
#
# FRACTIONS - four rows, ALL FOUR CARRIES, and the only one of the four jump
# lists with no estimate in it (rows.md 8.4, 8.5). Gastrocnemius 0.78 and
# Soleus 0.60 CARRY from bodyweightStandingCalfRaiseContent
# (SampleData.swift:38656), the bodyweight tier of the calf raises, chosen over
# the loaded tier (0.86 / 0.66) because a rope is not a load. Quadriceps 0.25
# and Hamstrings 0.20 CARRY from farmersWalkOnToesContent
# (SampleData.swift:40291) - the only entry in the whole library carrying
# exactly these four muscles in exactly these two ranks, and the library's only
# other continuous, bounding, toes-loaded lift. Nothing here is an estimate and
# nothing here is measured: no EMG study of rope skipping with a %MVIC
# normalisation exists (sources_jump.md G.1, sources_coaching.md 1.5), so no
# fraction is sourced to a number and none is presented as one. The stabilisers
# come from bodyweightStandingCalfRaiseContent rather than from the row-shape
# parent, because farmersWalkOnToesContent leads its list with gluteus medius
# and no glute is painted here, plus the tibialis anterior that the other
# three lifts of this family also name and that Lin 2022 measures as higher in
# this exact bounce - see open point 5.
#
# OPEN POINTS this entry hands the owner.
#  1. The rope never passes under the feet. At the floor frame (i6, t 0.25 of
#     each cycle) the lowest segments sit at y 0.0012-0.0093 m and z
#     +0.2858..+0.2938 while the feet occupy z +0.047 (ankle) to +0.145 (toe
#     joint) - a miss of 14.1 cm in the fore-aft axis. The closest the rope
#     ever comes to toe_L in 3D is 0.1514 m, and a box test under the feet
#     (|x| < 0.16, 0 < z < 0.20, y < 0.12) finds 0/192 frames with any rope
#     mesh in it. In x it does span the feet, so from a dead-front view it
#     would look right. This is a rig issue, not a coaching one; the copy below
#     states it once, in the hands cue, and no cue or mistake depends on the
#     rope passing under the feet.
#  2. The hands do not turn the rope. hand_L.x is +0.3061 and hand_R.x
#     -0.3061 at all 192 frames, handgap is frozen at 0.6122 m, and each
#     handle is rigidly fixed to its own hand (0.098234-0.098235 m, a range of
#     0.0005 mm over the clip). The rope is animated; the arms are passengers.
#     The whole upper body is a pure vertical elevator: trunk frozen at 2.5793
#     degrees forward with 0.00000 range, and pelvis, spine, chest, neck, head,
#     both clavicles, both scapulae and both upper arms each 0.000 mm of x and
#     z range. So no cue about wrist circles can be shown going right or wrong
#     by this model, and no cue about staying tall can be shown going wrong.
#     Taken with open point 1, this is a MODEL DEFECT FOR THE OWNER'S LIST and
#     not a copy problem: the hands cue teaches Lee rather than the rig and says
#     so in its `why`, which is the right call and is not changed here, but the
#     consequence is that the free reader sees a cue (hands low and close to the
#     sides, wrist circles) that the picture contradicts, with the explanation
#     behind the paywall. Nothing in the copy can fix that. What would fix it is
#     a re-animation - hands narrower than 0.6122 m, and the rope's circle
#     brought back over the feet.
#  3. Hand height is unsettled in the sources. Lee gives no hand height, only a
#     positional rule (elbows in at the sides, pointing down at about 45
#     degrees); secondary guides variously say hip height, slightly above, or
#     slightly in front of the hips (sources_coaching.md 1.4, which leaves this
#     to the owner). The model has the wrist 6.5-10.4 cm above the pelvis joint
#     and the elbow about 6.5 cm OUTSIDE the shoulder joint (RE-MEASURED), so
#     the model is wider than Lee coaches. The copy teaches Lee's positional
#     rule and quotes no hand height.
#  4. Four activation rows is below the 6-12 range of the twelve shipped 1029
#     entries, and nothing above the knee is listed although the lifter holds
#     two handles for all 192 frames. That follows the paint and the Step-Up
#     precedent (README 342-343), and it is a decision, not an omission.
#  5. Lin 2022 found the tibialis anterior significantly more active in this
#     exact two-foot bounce than in an alternating step, and this paint does
#     not light it. It gets no ROW: part_of(Tibialis Anterior) resolves to
#     calves, so a row would merge into the Gastrocnemius row rather than add
#     one. It is named among the STABILISERS instead, where part_of() is not
#     applied and where the other three lifts of this family already name it -
#     so the one lift whose own cited source measures it is not the one lift
#     that leaves it out. THIS IS THE ONE PLACE THIS MODULE DEPARTS FROM
#     rows.md SECTION 8, which is headed Paste unchanged: 8.4 settles four
#     stabilisers (tibialis posterior, peroneals, toe flexors, core, the exact
#     four bodyweightStandingCalfRaiseContent carries at SampleData.swift:38656)
#     and this entry ships five. It is a deviation and not a slip, it is a
#     judgement call rather than a paint fact (stabilisers are by definition
#     unpainted, so tiers_jump.json can neither confirm nor refute any of the
#     five), and the row stage has to agree it or the fifth name comes back out.
#     Whether a muscle a source measures and the paint ignores should reach the
#     table at all is the owner's call, not this entry's.
#  6. NO LANDING CUE HERE ASKS FOR ANYTHING AT THE KNEE, and that is on purpose
#     rather than by omission. The other three lifts of this family all carry
#     the knees-track-out convention on their landing cues; this one has no
#     landing to mistrack. The toe joint rises 5.209 cm, the knee's whole range
#     over 192 frames is 15.925 degrees and it never straightens past 154.713,
#     and the descent retraces the ascent frame for frame to 0.2 mm. There is
#     no drop here to absorb and no knee position to get wrong, so the landing
#     cue spends itself on the timing instead.
#  7. All eight stills in stills/ are the same instant - jump-rope_t0.png
#     through _t7 are all 199881 bytes and differ by 17-23 bytes, all past byte
#     273 in the PNG metadata. Eight samples across 192 frames is every 1.000 s
#     and the cycle is 0.5000 s, so every sample lands on frame index 0. Anyone
#     judging this lift from the stills will think the model is standing still.
#     joints.json's eight probes have the same problem: head has 3 distinct
#     values across its 8 samples, differing by 0.001 in v.
#  8. One figure could not be reconciled: the drawn foot hangs 3.81 px below
#     its own toe joint on the contact frames and 10.13 px below it at the
#     apex, although the foot segment vector is frozen over i4-i8.
#     measure_JumpRope.md could not account for that 6 px from the joint data.
#     The safe bound, used below, is that the lifter's lowest drawn row is
#     511-514 at every frame, i.e. 3 rows of travel.
#
ex(name="Jump Rope", var="jumpRope",
   # LABEL GEOMETRY. Rows: raw 0.14/0.32/0.50/0.68/0.86 draw at
   # 0.16/0.32/0.48/0.64/0.80. overrides below are RAW; every number in this block
   # is at the DRAWN row, which is what room.py and lead.py take. Measured with
   #   python3.13 -I room.py "Jump Rope" 10,13,14,17,19   (and 11,12,15,16)
   #   python3.13 -I lead.py "Jump Rope" <joint> <drawn row> <side> <len>
   # Where things are: lifter silhouette u 0.4155-0.7684, rows 176-514; rope
   # u 0.0583-0.9457, v 0.1862-0.7892, i.e. nearly the whole frame. Because the
   # body is a pure vertical elevator with zero sway, a slot is either clean for
   # all 192 frames or dirty for all 192 - there are no partial-overlap slots.
   #
   #   cue      slot (drawn)      len  lifter px/ovl   load px/inside   leader
   #   hands    0.16 trailing     11   no lifter / 0   37.6 / 0         hand_L    CLEAR 0/192, closest 16.6 px at t=0.04
   #   base     0.80 leading      10   104.5 / 0       18.5 / 0         foot_R    CLEAR 0/192, never spans the head rows
   #   ankles   0.80 trailing     10    29.0 / 0       20.9 / 0         foot_L    CLEAR 0/192, never spans the head rows
   #   bounce   0.64 leading      10   102.0 / 0        0.0 / 16        patella_L CLEAR 0/192, never spans the head rows
   #   land     0.16 leading      13   no lifter / 0   21.2 / 0         toe_L     CLEAR 0/192, closest 76.5 px at t=0.00
   #
   # All five pills: lifter-overlap 0/192. All five leaders: 0/192 frames on the
   # head's own silhouette. Four of the five also clear the rope on every frame.
   #
   # THE ONE ROPE CROSSING IS UNAVOIDABLE, and this is the proof. Only four slots
   # on this lift are clean of BOTH the lifter and the rope at a usable length:
   # 0.16 leading (no lifter ever - the crown is row 176 and the band ends at row
   # 121 - and the rope never enters the band, 0.00 s), 0.16 trailing (same), 0.80
   # leading (rope-free to 14ch: 18.5 px at 10ch, 5.5 at 13ch, 3.1 at 14ch, then
   # 16 frames inside at 17ch) and 0.80 trailing (rope-free at every length tried
   # but lifter-bound: 29.0 px at 10ch, 12.2 at 13ch, 6.6 at 14ch, -10.2 with
   # 144/192 overlap at 17ch). The fifth pill therefore has to take a middle row,
   # and the rope is in the 0.32 band for 2.667 s, the 0.48 band for all 8.000 s
   # and the 0.64 band for 3.333 s, spanning u 0.058-0.946 - so every middle slot
   # takes it. The cheapest crossing available is 16 frames (0.667 s), reached at
   # 10ch on 0.32 leading, 0.32 trailing, 0.48 leading and 0.64 leading; at 13ch
   # THREE of the four cost 32 frames instead - 0.32 trailing holds 16 to 13ch
   # and rises to 32 at 14ch, and is rejected on lifter clearance anyway, 15.7
   # px at 13ch - so the 10-character label is doing work.
   # Among the four 16-frame slots the lifter clearances are 0.32 leading 131.0,
   # 0.64 leading 102.0, 0.48 leading 73.7, 0.32 trailing 32.5 px. 0.64 leading
   # was taken over 0.32 leading's extra 29 px because drawn row 0.64 is rows
   # 402-435 and patella_L sits at v 0.6191-0.6477 - the pill is AT knee height
   # for a knee cue, where 0.32 is rows 193-225, head height. 0.48 leading is both
   # nearer the lifter (73.7) and the worst band on the clip (the rope is in it on
   # every frame, and a 23ch pill there overlaps the rope on 192/192). 0.64
   # trailing was rejected outright: 22.0 px of lifter at 10ch but 32 rope frames,
   # twice the cost, and it goes negative at 14ch.
   # Rejected elsewhere, with numbers: 0.48 trailing is unusable at any length
   # (-4.9 px and 112/192 overlap at 10ch, -21.7 and 192/192 at 13ch); 0.16
   # trailing was capped at 11 characters rather than pushed to 14 because the
   # leader to hand_L closes on the face as the pill grows - 16.6 px at 11ch, 10.7
   # at 13ch, 7.7 at 14ch, all CLEAR but tightening, and the rope clearance also
   # falls 37.6 -> 34.8 -> 30.6 -> 18.0 px at 17ch and 10.8 at 19ch; forearm_L
   # from that slot would have given 15.7 px at 14ch but it is the elbow joint,
   # not the hand the label names. 0.16 leading took the 13-character label
   # because it is the only slot with room to spare at that length (rope 21.2 px,
   # and still 16.8 px at 19ch and 23ch) and because toe_L is the joint the
   # label is about: its own face clearance from that slot is 76.5 px, fifth of
   # the 24 clear joints behind toe_R 84.5, patella_R 78.7, shin_R 77.8 and
   # foot_R 77.8. The two joints that are ON the face
   # from 0.16 leading on all 192 frames, scapula_L (-6.5 px) and upper_arm_L
   # (-12.4 px), plus head itself, are not used by any pill here, and neck is
   # clear from it by only 1.5 px and is also not used.
   #
   # LABELS - three of the five are library strings, counted with len() the way
   # validate() counts them, against the 1,299 distinct label strings in
   # SampleData.swift:
   #   Feet close    (10) REUSE x1, cyclistSquatContent - the library's own narrow
   #                 stance string, and this stance is 46.8-48.5% of shoulder
   #                 width, mean 47.9%.
   #   Heels lift    (10) REUSE x1, dumbbellCleanAndPressContent/extend (written
   #                 this round, deliberately inverting Heels down) - and the heel
   #                 peel here is exactly that, 0 to 2.762 cm with the ball pinned.
   #   Steady rhythm (13) REUSE x2, flutterKickContent/tempo and
   #                 scissorKickContent/tempo - the library's own rhythm label,
   #                 and 16 cycles repeating to 0.000 mm is what it describes.
   #   Quiet hands   (11) INVENTED. The library has no rope, skipping or
   #                 conditioning entry with content, and nothing among its 1,299
   #                 labels describes a low fixed hand position on a bounding
   #                 lift. Hands fixed (11, standingCableCrunchContent) fits the
   #                 model but means do not pull with the hands in a cable crunch,
   #                 a different instruction; Hands by the hips (17,
   #                 benchDipContent) is false here, the hands being 0.6122 m
   #                 apart against 0.3922 m at the shoulders; Hands chest high
   #                 (16) is false, the wrist sitting below the chest joint; and
   #                 Elbows in (9, x2 on two curls) is false, the elbow sitting
   #                 about 6.5 cm outside the shoulder joint. Built on the
   #                 library's own pattern - Legs quiet (10, weightedChestDip),
   #                 Free arm stays quiet (20), Elbows stay low (15).
   #   Low bounce    (10) INVENTED. The library has no jumping lift with content
   #                 at all (library.md 8.5), so there is no bounce-height label
   #                 to reuse. Small pulses (12, calfRaisePulseContent/range) is
   #                 the nearest in family and names a static calf pulse, not a
   #                 jump; No bouncing (11, x2 on two calf raises) means the
   #                 opposite, do not rebound out of the bottom. Ten characters
   #                 also buys the cheapest rope crossing on the only middle slot
   #                 a fifth pill can take, 16 frames against 32 at 13ch.
   overrides={"hands": (0.14, "trailing"), "base": (0.86, "leading"),
              "ankles": (0.86, "trailing"), "bounce": (0.68, "leading"),
              "land": (0.14, "leading")},
   annotations=[
       ("hands", "Quiet hands", "hand_L"),
       ("base", "Feet close", "foot_R"),
       ("ankles", "Heels lift", "foot_L"),
       ("bounce", "Low bounce", "patella_L"),
       ("land", "Steady rhythm", "toe_L"),
   ],
   cues={
       "hands": ("Quiet Hands",
                 "The rope is turned by your wrists, not your arms, so your hands stay low and almost still while the rope goes round.",
                 "In this model the hands do not move at all. hand_L.x is +0.3061 m and hand_R.x -0.3061 m at every one of the 192 frames; handgap is frozen at 0.6122 m, 1.56 times the 0.3922 m between the shoulder joints, and each hand covers only 4.85 px of u on screen over the whole clip. The 8.95 cm the hands travel in y is the arm riding the body's 11.539 cm bob, and the elbow opens and closes 18.34 degrees in time with it. Each of the two handles is rigidly fixed to its own hand, 0.098234-0.098235 m from the hand joint across all 192 frames - a range of 0.0005 mm. The rope still turns 16 times, one revolution per bounce, so the turn is animated and the arms are passengers: there is no wrist circle to watch. Nor does the rope pass under the feet - its circle sits 14.1 cm in front of them, a rig artefact and not something to copy. Lee, in the CrossFit Journal (issue 62, 2007), coaches arms close to the sides, elbows pointing down at about 45 degrees and two-inch circles of the wrists. That is a coach's system, not a measurement, and no study of rope-skipping technique was found for this round; measured against it this model is wide, its elbow sitting about 6.5 cm outside the shoulder joint.",
                 "Swinging the whole arm to turn the rope, so the hands drift out wide and the shoulders do the work.",
                 "Keep your hands low and close to your sides, elbows in near your ribs and pointing down at about 45 degrees, and turn the rope with small wrist circles rather than swings of your arms."),
       "base": ("The Bottom",
                "Every bounce starts and finishes in the same narrow stance with your knees softly bent and your feet almost together.",
                "The deepest frame of each cycle is its first. Knee 138.787 degrees, which is 41.2 degrees of bend; hip 156.404; ankle 103.571; trunk 2.579 forward; pelvis 0.88392 m; both heels flat on the floor and the rope directly overhead. The stance never changes: the ankle joints hold 0.1836-0.1900 m apart against 0.3922 m between the shoulder joints, so the feet sit at 46.8-48.5% of shoulder width, mean 47.9%, and each foot is toed out 6.00 degrees, perfectly mirrored. Both feet also leave and land together - the left and right knee never differ by more than 0.108 degrees, the hips by more than 0.205, and the hands are mirror images to 0.0005 mm - so there is no lead leg and nothing alternates. That is the plain two-foot bounce, and it is the version with the lighter landing: Lin and colleagues (2022) put 16 male adolescents through bounced and alternating rope jumping and found the two-foot bounce had the smaller vertical ground reaction force over 11-82% of ground contact (p < 0.001) with a smaller peak force and loading rate, and more hip and knee flexion. Their muscle data is standardised RMS amplitude, not a percentage of a maximum contraction, so it ranks muscles and yields no fraction.",
                "Letting the feet slide apart or turn out, or planting them wide as if for a squat.",
                "Stand with your feet almost touching and your toes pointing straight ahead, knees softly bent and your weight over the balls of your feet with the heels light on the floor, and keep that stance for the whole set."),
       "ankles": ("Ankle Drive",
                  "The bounce comes from your ankles: your heels peel off the floor while the balls of your feet stay down.",
                  "From the bottom of each bounce to 0.1250 s the ball of the foot stays pinned - the toe joint reads exactly 0.015796 m at four consecutive frames - while the ankle opens 103.571 to 126.566 degrees and the heel rises 0 to 2.762 cm. Over the whole clip that ankle travels 25.92 degrees (103.571-129.494) against 15.93 at the knee (138.787-154.713) and 2.56 at the hip (156.404-158.966) - all four figures the left leg, the right agreeing to 0.24 degrees - so the ankle does more than the knee and hip together. The heel peaks 8.362 cm up at the top of the jump and is above the floor on 11 of the 12 frames of each cycle; it is only properly down on the bottom frame. Nothing above the hip contributes: trunk is frozen at 2.5793 degrees forward with a range of 0.00000 over all 192 frames, and the pelvis, spine, chest, neck, head, both clavicles, both scapulae and both upper arms each have 0.000 mm of x and z range - the upper body is a pure vertical elevator. That is why the paint lights the calves alone and brightest: of 10 painted meshes the 3 bright ones are both gastrocnemius heads and the soleus, with the quadriceps and hamstrings dim behind them and nothing above the knee lit at all.",
                  "Driving the bounce from the knees, so the heels stay stuck down and the calves never load.",
                  "Push the floor away with the balls of your feet and let your heels lift clear as you go, then let them settle back down between bounces, so the ankle does the work rather than the knee."),
       "bounce": ("Take-Off",
                  "You only have to clear the rope, so the bounce is tiny - a flick off the floor rather than a jump.",
                  "Take-off falls between 0.1250 and 0.1667 s of each cycle, when the toe joint leaves its pinned 0.015796 m. Flight is 5 frames, 0.2083 s, with the apex at 0.2500, and through all of it every leg angle is frozen: knee 154.713 and 154.820, hip 158.966 and 159.172, ankle 129.441-129.494, trunk 2.579, constant to 0.06 degrees while the whole body translates. The pelvis rises 11.539 cm, but most of that is the ankle opening over a planted forefoot. The toe joint itself rises 5.209 cm, from 0.015796 to 0.067886 m, and the drawn body's lowest pixel row moves only from 514 to 511 - 3 rows, about 1.7 cm at this framing's 5.645 mm per pixel row. Read the pelvis figure as jump height and you are out by a factor of about seven. The knee neither locks nor folds: its whole range is 15.93 degrees on the left leg this entry measures, 16.00 on the right and the deepest it ever gets is 41.2 degrees of bend. Lee's rule in the CrossFit Journal is to jump only high enough to clear the rope, and he gives that height three different ways in the same article - half an inch, three-quarters, and an inch - so barely off the floor is the honest version of it and no single figure is the standard. That is coaching, not a measurement.",
                  "Jumping as high as you can, or tucking the knees up, which costs height and air time on every single turn.",
                  "Bounce barely off the floor, only as high as you need to clear the rope, and keep your knees soft and almost still instead of driving them up."),
       "land": ("Land and Go Again",
                   "Land on the balls of your feet in the same spot and go straight into the next bounce - the rhythm is the exercise.",
                   "Landing falls between 0.3333 and 0.3750 s, when the toe joint comes back to exactly 0.015796 m, and there is no separate absorption phase: the knee goes back down the curve it came up, frame for frame, to 0.2 mm. Ground contact is 7 frames, 0.2917 s, against 5 frames, 0.2083 s, of flight - a 58/42 duty cycle at 120 bounces a minute. Those two times sit right on the measured ones: Kaewjaratwilai and colleagues (2025) had 10 female and 10 male Muay Thai athletes skip at 2.2 Hz on force plates and recorded contact times of 0.280 plus or minus 0.03 s and 0.275 plus or minus 0.05 s and flight times of 0.205 plus or minus 0.03 s and 0.245 plus or minus 0.05 s, none of the sex differences significant; their peak forces are in kN without the body masses, so there is no body-weight figure to quote. The feet also come down exactly where they left, foot_L at take-off and at landing being the same point to 0.0000 mm. Rate is not the dose, either - Town, Sol and Sinning (1980) had 19 males and 11 females skip for 5 minutes at each of 125, 135 and 145 skips a minute and found no difference in oxygen uptake, heart rate, ventilation or energy cost at any rate, averaging 11.7 to 12.5 METs. What the cue asks for - timing the bounce to the rope rather than to the sound of it - is the one genuinely hard part of learning to skip and it is not measured by anything here or in the sources; it is also the one thing this rig cannot show, because its rope circle misses the feet by 14.1 cm and so never hits the floor at all.",
                   "Pausing between bounces, or landing flat and heavy and then resetting the feet before the next turn.",
                   "Land lightly on the balls of your feet in the spot you left, let your ankles and knees give a little, and go straight into the next bounce - time it to the rope coming down in front of you so it passes under your feet while you are off the floor."),
   },
   # Rows exactly as rows.md section 8.4 settles them, pasted unchanged, and
   # they follow the paint re-counted at the top of this block: 3 bright meshes,
   # all calf, so Gastrocnemius and Soleus are the two primaries; 7 dim meshes
   # in two groups, so Quadriceps and Hamstrings are the two secondaries. No
   # glute row (none painted, and the library row itself says GASTROCNEMIUS),
   # no Hip Flexors row (no sartorius lit) and nothing above the knee at all,
   # which the frozen arms and trunk confirm. All four fractions are carries -
   # 0.78 / 0.60 from bodyweightStandingCalfRaiseContent, 0.25 / 0.20 from
   # farmersWalkOnToesContent - so this is the only one of the four jump lists
   # with no estimate in it. Nothing here is measured; see open point 4 on the
   # four-row count and the missing forearm row.
   activation=[("Gastrocnemius", P, HI, 0.78), ("Soleus", P, MOD, 0.60),
               ("Quadriceps", S, LOW, 0.25), ("Hamstrings", S, LOW, 0.20)],
   # DEVIATION FROM rows.md 8.4, declared here and not only in open point 5:
   # that table settles FOUR stabilisers and this list has five. The fifth,
   # tibialis anterior, is the one muscle this lift's own cited source measures
   # as higher in this exact bounce (Lin 2022) and the one the other three
   # lifts of the family all name; part_of(Tibialis Anterior) is calves, so it
   # cannot have a row without merging into Gastrocnemius. It needs the row
   # stage's agreement or it comes back out - see open point 5.
   stabilisers=["tibialis posterior", "peroneals", "toe flexors",
                "tibialis anterior", "core"],
   # The badge names the one fault this model refutes most exactly and which no
   # cue above already carries. The four cue mistakes are arm-swinging, a wide
   # stance, driving from the knees and pausing between bounces; drifting is
   # none of them. It is also a fault and not another exercise: travelling and
   # side-to-side skips are real variations, but DRIFTING says unintentional.
   # Two badges were considered and dropped. HEELS DROPPING (14, the library's
   # own, on Calf Raise Pulse and Farmer's Walk on Toes) is out because this
   # model performs it - the heel reads 0.000 cm above the floor on the bottom
   # frame of every bounce - and no badge in this module may be given for a
   # fault the model does on purpose. (This entry cited that rule from Step-Up
   # Jump, which was itself breaking it: its badge's correctNote offered the
   # model's own 3.8 degrees of knee give as the picture of a soft landing. That
   # is fixed in the Step-Up entry, so the precedent now holds both ways.)
   # JUMPING TOO HIGH (16) is out because a
   # deliberately higher bounce is what a double under needs, so it would call
   # a legitimate exercise a fault; that point is made in the bounce cue
   # instead, where it is about this bounce and not about the lift in general.
   comparison=("DRIFTING OFF THE SPOT", "Lands on the same spot", "Creeps forward with each bounce",
               "The model never moves. foot_L at take-off and at landing is the same point to 0.0000 mm - [0.09462, 0.12398, 0.04393] at both - and across the whole 8.000 s clip the toe joint travels 0.698 mm in x and 6.642 mm in z. The ankle joints hold 0.1836-0.1900 m apart throughout, both feet leave and land together, and the two knees never differ by more than 0.108 degrees. Sixteen bounces, one landing spot, and the pose repeats to 0.000 mm every 12 frames.",
               "Creeping forward is what happens when the bounce is driven by the knee rather than the ankle, and it is why the basic bounce is coached on one spot. There is nothing measured behind the fault: no study of rope-skipping technique - foot contact, jump height or elbow angle - was found for this round, so it is coaching convention, and Lee's own system reaches it only indirectly, by asking for the weight on the balls of the feet and the body upright and balanced."),
   # One plain glow() per row of paint, no shared helper, four calls for the
   # four rows. No mesh in this paint carries a side suffix, so every row is
   # lit on both legs and each glow spans both - rx is set from the two legs
   # separation on screen (the shins run u 0.547-0.637, the thighs u
   # 0.538-0.670 at this three-quarter framing). Bright calf rows get A, the
   # dim thigh rows SOFT, and the two pairs are separated vertically rather
   # than by depth: gastrocnemius high on the shank and soleus below it,
   # hamstrings high on the thigh and quadriceps down over the knee. That is
   # true in any view, which matters because the near/far side of this framing
   # is the one thing the measure stage left open. glow() averages joints.json's
   # eight samples, and on this clip all eight land on the same phase - every
   # 1.000 s against a 0.5000 s cycle, so all eight are frame index 0, the
   # bottom of the bounce (head has 3 distinct values across them, differing by
   # 0.001 in v) - so these centres are a static placement at the bottom frame,
   # not a phase mean.
   glows=[glow("Jump Rope", ["shin_L", "shin_R", "foot_L", "foot_R"], A, 0.55,
               rx=0.085, ry=0.045, dy=-0.015),
          glow("Jump Rope", ["shin_L", "shin_R", "foot_L", "foot_R"], A, 0.50,
               rx=0.072, ry=0.032, dy=0.030),
          glow("Jump Rope", ["thigh_L", "thigh_R", "patella_L", "patella_R"], SOFT, 0.30,
               rx=0.090, ry=0.055, dy=0.010),
          glow("Jump Rope", ["thigh_L", "thigh_R"], SOFT, 0.28,
               rx=0.075, ry=0.040, dy=0.025)])

# Step 1 gained a lower bound: the draft's test had an upper one only, so a
# rope that reached the navel passed it, and a short rope is the commonest
# reason a beginner catches it. Step 5 now says what to do when the rope
# catches, which is the most frequent event in a beginner's set and which the
# draft only gestured at with when a set breaks; the keep-the-same-pace clause
# stays, because it is Town 1980's finding stated as a rule, but it is no
# longer the whole step.
SETUP["Jump Rope"] = [
    "Size the rope: stand on the middle of it with one foot and pull the handles up - the tips should reach your armpits and no higher than your shoulders.",
    "Skip on wood, rubber, a mat or level dirt rather than concrete or tile, in shoes with forefoot padding, with five feet clear each side and two overhead.",
    "Stand tall with your feet almost together and your eyes straight ahead, and let the rope rest on the floor behind your heels.",
    "When the rope catches your feet, stop the turn, step it back behind your heels and start again at the pace you were holding rather than a faster one.",
]
