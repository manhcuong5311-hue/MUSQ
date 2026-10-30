# Trainer content for the model-only exercises of 2026-10-29, family "jerk":
# the five lifts that put a load overhead off the shoulders and shipped with a
# model but no coaching - Dumbbell Clean and Press
# (Shoulder/DumbbellCleanAndPress), Kettlebell Clean and Press
# (Shoulder/KettlebellCleanAndPress), Barbell Clean and Jerk
# (Shoulder/BarbellCleanAndJerk), Split Jerk (Shoulder/SplitJerk) and Push Jerk
# (Shoulder/PushJerk). Same format as spec.py on top of common_1_50.py;
# spec_1029.py imports this module and gen.py reads SPEC / SETUP.
# notes_1029_jerk.md maps every claim in the copy to the sources below or to a
# model measurement.
#
# HOW THE MODELS WERE MEASURED. The round folder's meas.py opens each rig with
# pxr, reads every joint's world transform and every equipment mesh's points at
# all 192 integer frames and projects both through that lift's own trainer
# framing (jobs.py, copied from the app's modelByExercise); the measure stage
# reads the equipment sizes as LOCAL extents times the prim's own world scale
# (dcp_size.py and its siblings), which is the honest measure because the bells
# rotate - near.py's world axis-aligned box over-reads the same dumbbell head by
# 1.2 cm (0.172 against 0.160) and reads the 0.032 m handle as 0.34 m across
# because the box follows the tilt, which is where session_facts.md's 0.336 and
# 0.172 come from; room.py, lead.py, slots2.py,
# chk.py, face.py and anchor.py do the label geometry; tiers_jerk.json carries
# the paint. Frame: Y up, the lifter faces +z, their left is +x, metres. Knee,
# hip and elbow are inner angles (180 straight) and trunk is the
# neck-over-pelvis line from vertical, positive forward; the rig joint called
# forearm_* IS the elbow and hand_* is the wrist, so an elbow angle of 43
# degrees means the arm is folded. Heel height is the foot_* joint above its own
# resting 0.0686 m. All five clips run 7.958 s at 24 fps (192 frames), all five
# loop (the last frame matches the first to 0.0001 mm or better on every joint
# on all five), and the shoulder joints are 0.3922 m apart in all five.
#
# THE LIFTER'S SILHOUETTE comes from sil.py, which evaluates UsdSkel
# linear-blend skinning at every frame over all 125 skinned meshes and 184,718
# points and bins the result into 655 v rows, one per rendered pixel row. The
# two easy versions are both wrong. (1) UsdGeom.Mesh.GetPointsAttr().Get(t) on
# a body mesh of these rigs returns the REST pose at every time code, so
# projecting it gives a standing silhouette that never moves - useless on a
# clip where the lifter folds over the floor and then locks out overhead.
# (2) joints.json is not a substitute: it holds only eight samples per joint,
# and gen.py uses them to choose a default row while the app tracks the live
# joint every frame (Exercise3DView.dotPoint). Checked against this session's
# per-frame projection, those eight samples are off by at most 0.016 in uv -
# 6 px of u, on Split Jerk's toe_R - which is probe.py rounding its sample
# times, not a projection error, but it is still eight frames out of 192. A
# third mistake was made and corrected inside this round and is worth recording:
# a pill must clear the lifter at EVERY pixel row inside its band, so the
# per-frame gap is the MINIMUM over rows of max(u0 - umax, umin - u1), as
# chk.py does it; taking the maximum over rows over-reads every slot by
# 10-30 px (measure_DumbbellCleanandPress.md, which transcribes chk.py's loop
# in dcp_xchk.py and agrees to 0.1 px on eight slots).
#
# THE HEAD'S SILHOUETTE comes from headsil.py, which keeps only the 2,928
# skinned vertices whose dominant UsdSkel influence is root/pelvis/spine/chest/
# neck/head - parts of the two sternocleidomastoids, the two splenius capitis,
# the upper trapezius pair and the faceless head-and-neck surface - and bins
# those per row the same way. Here too both easy versions are wrong, in
# opposite directions. A box round the head JOINT is far too small: that joint
# sits at the base of the skull, and measured over these five clips the crown of
# the drawn head is 28.3 to 42.5 px above it (on the Dumbbell Clean and Press,
# 36.5-42.3 px, about 18 cm of world height at that framing), so a
# joint-centred box misses most of the face in exactly the folded-over poses
# where a leader crosses it. The whole body at head height is far too big: in
# the rows the head occupies the head itself is only 35-47 px wide while the
# full silhouette there runs up to 175 px, because at a lockout those rows hold
# a raised arm and a loaded bar as well. A leader is on the FACE only if it
# falls inside the head's own min/max u at some row the head occupies, which is
# what face.py and chk.py test over all 192 frames.
#
# THE VIEW is the one thing the measure stage could not settle and the one thing
# no copy below depends on. All five share yaw -0.8 rad. In framer.py the camera
# sits at screen z +2.05 with dz = D - z, so a larger rotated z is NEARER, and
# after the yaw z = 0.7174*x + 0.6967*zw - which makes both the lifter's facing
# direction (+z) and the lifter's left (+x) nearer the camera. Measured on the
# Split Jerk's first frame, the sternal pectoral sits about 13.7 cm nearer the
# camera than the latissimus and scapula_L about 20.4 cm nearer than scapula_R
# (measure_SplitJerk.md section 0). So this is a three-quarter FRONT view from
# the lifter's left and NOT the view from behind that the round brief and
# notes_1029_snatch.md describe for the snatch family; it is left as a question
# for the owner. What is not in doubt is the side, which is what the labels
# needed: the lifter's LEFT reads at HIGH u, at the frame's trailing (right)
# edge - hand_L sweeps u 0.493-0.624 against hand_R's 0.274-0.404 on the
# Barbell Clean and Jerk, foot_L u 0.672 against foot_R u 0.417 on the
# Kettlebell Clean and Press - and +z, the way the lifter faces, maps to LOW u,
# toward the leading edge. No cue below names a near or a far side, no cue
# claims a muscle faces the camera, and every glow is either placed on both
# sides or marked SOFT for depth alone.
#
# - Dumbbell Clean and Press (zoom 0.724, offset [0.006, -0.051, -0.006]). ONE
#   rep, floor to overhead and back to the floor, not a set; the last frame
#   matches the first to 0.0001 mm. TWO dumbbells, one in each hand, both arms
#   working: six meshes under /root/HG_WeightL and /root/HG_WeightR, each bell a
#   0.340 m handle 0.032 m thick with a 0.160 m head 0.070 m thick at each end,
#   each handle a constant 0.1036 m (left) and 0.1085 m (right) from its own
#   hand joint at every frame. The pair is NOT one implement: centre-to-centre
#   separation runs 0.3822 m at the rack to 1.0832 m at the turnover. The legs
#   are symmetrical to 0.158 degrees at the knee; the arms are not, the left
#   elbow racking 3.97 degrees deeper than the right. Three held poses: the
#   set-up 0.000-0.375 s, the rack 3.542-3.667 s and the lockout 4.500-5.417 s.
#   Set-up: knees 64.21 degrees - 116 degrees of knee bend, deeper than either
#   barbell start here - hips 51.15, trunk 64.75 forward, pelvis 0.4799 m at its
#   clip low, the ankles only 0.1900 m apart, each bell 32.00 cm in front of the
#   ankle joint. First pull: knees 65.20 to 119.94, hips 51.93 to 113.43, trunk
#   64.47 to 38.52, pelvis 0.486 to 0.793 m, the bells 0.009 to 0.505 m, and the
#   elbows do nothing - 173.36 degrees at the floor, 172.44 a second later.
#   Second pull, all of it at 1.875 s: trunk 4.65 degrees behind vertical,
#   pelvis 0.9573 m, both heels up together 5.81 and 5.80 cm with the toes
#   planted, elbows still 172.77; the heels are off the floor 1.583-2.750 s,
#   1.208 s in all, and the only calf the paint lights in this family as the
#   rigs stand today (rows.md open point 8 is whether that is a painting gap).
#   Catch: the elbows fold 171.9 to 30.81 and 34.77 degrees while the hands fly
#   0.698 to 1.063 m apart at 2.250 s and come back to 0.4205 m; the dip bottoms
#   at 3.000 s with the knee 110.73 and the pelvis 0.7600 m, 19.7 cm below where
#   the drive left it, then the lifter stands to 175.22 and holds the rack
#   0.167 s with the hands 1.4739 m up. THE PRESS IS STRICT, and it is the
#   measurement that separates this lift from the three jerks: over 3.708 to
#   4.500 s the elbow travels 143.13 degrees while both knees, the hip and the
#   trunk measure a 0.0000 degree range and the pelvis 0.000 mm, the head moving
#   0.92 mm. The bells rise 198.19 cm (0.0007 to 1.9825 m at their lowest
#   point), finish 20.0 cm above the crown of the head, and the lockout holds
#   0.958 s. Paint: 35 painted meshes, 8 bright and 27 dim, nothing faint and
#   nothing one-sided - the richest of the five, and the only one that paints a
#   calf or a forearm.
# - Kettlebell Clean and Press (zoom 0.74, offset [-0.001, -0.026, 0.001]). ONE
#   rep, floor to overhead and back, looping to 0.0001 mm. TWO kettlebells, six
#   meshes each - a 0.210 m bell body, a 0.150 m handle, two 0.118 m uprights
#   and two 0.033 m beads - the left six nearest hand_L at every frame (the
#   handle a constant 0.1036 m from it) and the right six nearest hand_R
#   (0.109 m). Both arms work: elbow_L and elbow_R agree to 0.1444 degrees at
#   every frame and hand_L.y and hand_R.y to 2.44 mm, so nothing one-armed can
#   be said here and the rig paints no oblique and no abdominal, where the
#   library's single-bell Kettlebell Clean paints bright obliques on the off
#   side. 78 of the 192 frames (40.6%) are a frozen pose, in five windows
#   spanning 3.04 s at 0.00-0.33, 1.92-2.42, 3.33-4.17, 5.00-5.58 and
#   7.17-7.96 s, so no cue asks the reader to watch a tempo. The stance never
#   moves: the ankles 0.600-0.607 m apart, 1.53 times the 0.3922 m at the
#   shoulders, with toe_L and toe_R frozen to 0.0 px in the frame. Set-up: trunk
#   58.8 degrees forward, hips 79.6, knees only 103.4 - a hinge, not a squat -
#   pelvis 0.6199 m, each bell 0.1179 m either side of the midline, 12.0 cm in
#   front of the ankle joint and 0.5 cm behind the toe, each hanging 0.2721 m
#   straight below its hand. Hike: the bells go 15.8 cm REARWARDS (depth
#   +0.1200 to -0.0381 m, 3.8 cm behind the ankle) with the trunk held 58.8 to
#   58.1 and the elbows locked to 180.0, the two bells closing to 1.53 cm apart
#   at 0.917 s and never nearer a leg joint than 0.2000 m. Extension, 0.208 s of
#   it: knees 115.2 to 174.5 at 284 degrees a second, hips 97.8 to 174.5 at 368,
#   trunk 52.9 forward to 4.67 behind vertical by 1.375 s, pelvis 0.711 to
#   0.8938 m, the bells 0.236 to 0.656 m, the elbows 176 to 180 throughout, and
#   the heels lifting just 1.43 cm over 1.125-1.458 s. Rack: the elbows fold
#   176.3 to 38.6 degrees at 451 degrees a second, each bell moves from 0.2721 m
#   below the hand to 0.1154 m from it at 7.6 degrees ABOVE it and 108 degrees
#   forward, the hands come in to 0.293 m, and the rack is held 0.500 s with the
#   hands 2.0 cm BELOW the shoulder joint and the bells 17.2 cm below the head.
#   The press is strict and the leanest-legged in the family: over 2.458 to
#   3.333 s the knee holds 175.96 degrees unchanged and the pelvis 0.8835 m to
#   0.00 mm while the elbow runs 38.5 to 175.0 and each hand rises 55.2 cm; the
#   hands part to 0.928 m at 2.917 s and finish 0.532 m apart. There is no dip,
#   no split and no knee re-bend anywhere: the minimum knee from the clean's
#   turnover to the end of the press is 174.48 degrees. Paint: 7 bright, 16 dim,
#   nothing faint, nothing one-sided - and this is the only lift of the five
#   whose hamstrings are bright while its quadriceps are only dim.
# - Barbell Clean and Jerk (zoom 0.64, offset [-0.023, -0.075, 0.024]). ONE rep
#   and a whole lift: set up over a loaded bar on the floor, clean to the front
#   rack, dip, drive, jerk to a split receive, recover the feet, lock out, lower
#   to the shoulders, lower to the floor. The clean runs 0.333-2.667 s (2.33 s),
#   the jerk 3.042-5.125 s (2.08 s) and the return 5.500-7.833 s (2.33 s); four
#   poses are held to under a micron (0.000-0.292, 2.708-3.000, 5.167-5.458 and
#   7.875-7.958 s) and the clip returns to its own first frame to 0.000 um. One
#   rigid barbell, five meshes - a 2.04 m shaft 0.028 m thick, two 0.45 m plates
#   0.08 m thick and two 0.105 m collars, every inter-mesh distance constant to
#   0.0000 m - travelling 1.834 m with a 4.490 m path. Set-up: trunk 61.6
#   degrees forward, the most in the clip, knees 97.9, hips 57.2, pelvis 0.585 m
#   at its low, the shoulder joint 0.6 cm from the bar, the hands 0.614 m apart
#   (0.713 m in from each end) against 0.392 m at the shoulders, the bar axis at
#   0.225 m and 9.6 cm in front of the ankle. First pull: the bar runs about
#   1.0 cm off the skin of the shins and thighs the whole way (1.06 cm at the
#   set-up, 0.97-1.16 cm to 1.25 s) and comes IN to 6.5 cm in front of the ankle
#   before swinging out to 30.7 cm at 2.000 s; the elbows stay 155.6-158.2
#   degrees through the first pull and 150.9-162.7 through the extension.
#   Catch at 2.000 s, sinking only to 2.208 s: knee 97.8 degrees but the thigh
#   still 43.0 degrees above horizontal, pelvis down to 0.701 m then up to
#   0.909 m by 2.667 s, the bar settling 1.281 to 1.220 m onto a real rack - its
#   surface 0.19 cm off the clavicular pectoral at the catch - with the elbow
#   26.8 cm BELOW the shoulder and 5.6 cm in front of it. Dip 3.042-3.333 s:
#   knees 175.2 to 144.4 (30.8 degrees), the hip OPENING 162.7 to 166.0, the
#   pelvis down 3.9 cm and the bar 4.1 cm, the trunk inside 1 degree of
#   vertical. Drive 3.333-3.583 s (0.250 s): the bar up 24 cm with the elbows
#   still racked at 43 degrees and the heels 4.8 cm off the floor. Split
#   3.625-3.875 s: the elbows open 55.2 to 173.0 degrees while the pelvis drops
#   16.6 cm (0.946 to 0.780 m) under a bar peaking at 1.940 m; the fastest
#   single frame in the clip is 13.24 cm of joint travel at 3.583-3.625 s; the
#   feet land 60.4 cm apart front to back on a 22.0 cm wide stance, the LEFT
#   foot forward and the right heel 8.2 cm up, and the split is held 0.46 s
#   before the front foot comes home by 4.750 s and the rear by 5.125 s. Then a
#   hold: the arms at 170 degrees or more for 1.67 s with the bar 45.5 cm above
#   the head joint and 2.6 cm in front of it. Paint: 22 painted meshes, 11
#   bright and 11 dim, nothing faint, nothing one-sided.
# - Split Jerk (zoom 0.65, offset [-0.03, -0.077, 0.031]). TWO identical reps of
#   exactly 96 frames = 4.000 s (lag 96 agrees to 0.0003 mm on every joint; no
#   other lag under 191 comes within three orders of magnitude), so every figure
#   is rep 1 and repeats at t + 4.000 s. The clip OPENS AND CLOSES IN THE RACK:
#   there is no clean anywhere in it and the plates never come within 1.198 m of
#   the floor, which is the first thing a writer working from the name gets
#   wrong. The same rigid 2.04 m barbell as the Barbell Clean and Jerk. Both
#   arms are one mirrored unit - elbow_L and elbow_R agree to 0.001 degrees on
#   every frame and the hands mirror to 0.8 micrometres - so no cue can tell a
#   working arm from a free one; the whole asymmetry is below the hip, and the
#   split always puts the LEFT foot forward, in both reps. Rack, held 0.708 s a
#   rep, the longest still pose: the bar at 1.465 m, 3.0 cm above the shoulder
#   joint, 7.3 cm above the wrist and 6.6 cm behind it, the elbows folded to
#   43.0 degrees, the grip 0.614 m against 0.392 m at the shoulders. Dip: a
#   knee-only dip, the pelvis down 3.88 cm (0.909 to 0.870 m, 4.27% of the
#   PELVIS's own standing height, which is not the measure the literature's
#   dip depths use) and the knees 175 to 144.4 degrees in 0.33 s, while the
#   trunk moves 0.67 degrees in all, the pelvis travels 0.00 cm front to back,
#   the knees come 8.14 cm forward, the hip angle OPENS 2.98 degrees and the
#   elbows go 43.1 to 43.2. Drive, 0.250 s: knees 144.4 to 172, pelvis 0.870 to
#   0.955 m (4.6 cm above its racked height), the bar 1.423 to 1.653 m, a rise
#   of 23.0 cm, with the elbows still at 41.7 and both heels 4.77 cm up on
#   planted toes; the arms only start after that, the elbow jumping 9.25 degrees
#   in the single frame at 0.875 s and running 43 to 173 degrees in 0.333 s.
#   Split: the feet 61.0 cm apart front to back in 0.333 s (the simultaneous
#   maximum, at f26; each foot's own extreme is 25.0 cm forward at f30 and
#   37.1 cm back at f26, so the two do not add to 61.0) and only 7.3 cm wider, the pelvis down 17.52 cm,
#   the hands 25.9 cm up and 17.1 cm back, the rear heel 8.20 cm up for 1.83 s a
#   rep, and the rear knee the more bent of the two at 110.5 against the front's
#   136.5. Lockout: the bar is at 1.927 m when the split lands and rises a
#   further 12.98 cm to its peak 2.057 m purely from standing up - 59.26 cm
#   above its racked height, 45.50 cm above the head joint, 2.60 cm in front of
#   it and 1.49 cm in front of the mid-stance point - the feet come back one at
#   a time (front 1.625-2.042 s, rear 2.083-2.458 s, 0.42 s apart), and nothing
#   ever locks straight: the elbows stop at 173.0 degrees and the knees at 175.2
#   and 175.3, which is where they stand in the rack too. Paint: 5 bright, 11
#   dim, nothing faint, nothing one-sided - the leanest in the family, and the
#   only one of the five with no hamstring, no erector spinae and no biceps
#   paint anywhere.
# - Push Jerk (zoom 0.659, offset [-0.027, -0.084, 0.028]). TWO identical reps
#   on the same exact 4.000 s period (frame i and frame i+96 agree to
#   0.000478 mm on all 26 measured joints; the next nearest lag is 93.8 mm), the
#   rack held still 0.417 s at the top of every rep and a second 0.250 s freeze
#   inside the receiving dip at 1.167-1.375 s. Again no clean and no floor: the
#   bar opens racked at 1.4645 m and its lowest drawn point in 192 frames is
#   1.1984 m, at the bottom of the dip. The rack has LOW elbows - the elbow
#   closed to 43.0 degrees with the upper arm only 21.5 degrees from hanging, so
#   the elbow sits 26.79 cm BELOW the shoulder joint and 5.57 cm in front of it -
#   which is why the library's `Elbows up in the rack` is not reused anywhere in
#   this family. Dip, 0.292 s: knee 175.2 to 144.40 degrees, pelvis down 3.94 cm
#   to 0.8699 m, the bar to its clip low 1.4234 m, the trunk moving 0.99 degrees
#   and the hip OPENING 162.7 to 166.0, both heels flat until 0.667 s. Drive,
#   0.250 s: knee to 172.07 - 3.2 degrees short of its own clip maximum 175.40,
#   so not full extension - pelvis up 8.49 cm to 0.9548 m, its clip high and
#   4.55 cm above the rack, the bar up 22.94 cm to 1.6528 m, and the elbow
#   CLOSING slightly, 43.2 to 41.7. Press under: the elbow sweeps 41.7 to 173.0
#   degrees in 0.333 s, a mean 394 degrees a second, both feet leave the floor
#   for 0.250 s (0.875-1.083 s, the toes 3.45 cm up) and land 8 cm wider (ankle
#   gap 0.220 to 0.300 m, still inside the 0.3922 m at the shoulders), and the
#   catch at 1.083 s is the deepest moment of the clip - knee 121.83 degrees,
#   the pelvis 9.80 cm below the rack and 5.86 cm lower than the dip. Lockout:
#   the elbow at or above 170 degrees for 1.833 s a rep and flat at its maximum
#   173.0 for 1.792 s, the bar peaking at 2.0574 m, 45.50 cm above the head
#   joint and 1.49 cm in front of the ankle, having travelled 7.55 cm BACK from
#   where it was racked; the quarter squat rebounds to 130.16 degrees of knee,
#   freezes 0.250 s and stands to 175.3 over 0.542 s. IT DOES NOT SPLIT:
#   foot_L.Z minus foot_R.Z never exceeds 0.123 mm on any frame, which is the
#   whole difference between this lift and the Split Jerk and the Barbell Clean
#   and Jerk, both of which receive with the left foot about 0.61 m forward.
#   After the lockout each foot re-sets separately and knee_L and knee_R diverge
#   by up to 25.52 degrees while the body sways 4.95 cm sideways, which is a
#   weight shift in the hold and not a step, so no cue quotes a knee angle after
#   t 2.000. Paint: 16 painted meshes, 8 bright and 8 dim, nothing faint,
#   nothing one-sided.
#
# ONE MORE MEASUREMENT TRAP, on the three barbell lifts: the published eqpts
# cloud samples only each cylinder's two end rings, which leaves a 147.0 px hole
# along the shaft at the lockout, so chk.py and slots2.py can call a pill clear
# while the drawn bar runs through it. The Push Jerk's load figures were
# re-measured from a dense analytic rebuild of the drawn bar
# (PushJerk_BARDENSE.npz, 29,520 points a frame, largest u gap 4.01 px) with
# pj_dense_slots.py and agree with room.py at the five slots used; the Barbell
# Clean and Jerk's dense rebuild gives the same slot ranking and the same
# seconds everywhere except row 0.16 leading, which it makes 0.92 s rather than
# 0.75 s.
#
# How they differ from the library and from each other. The two clean-and-presses
# PRESS - measured, 143.13 degrees of elbow against a 0.0000 degree range at both
# knees, the hip and the trunk on the Dumbbell, and 175.96 degrees of knee held
# UNCHANGED on the Kettlebell - so their shoulder rows follow the parent Clean
# and Press (Anterior Deltoid 0.84) and they are the only two lifts here whose
# arms put the load overhead. The three jerks do not press: across them the bar
# rises 14.40 cm in the half second after the rack, 0.250 to 0.792 s, while the
# elbow moves 3.798 degrees, so their Anterior Deltoid
# takes the snatch round's 0.40 - the Power and Dumbbell Snatch's value,
# re-estimated there for a load the legs throw and the arm only locks, with the
# reasoning anchored on the Overhead Carry, the library's one loaded overhead
# HOLD, which carries no anterior deltoid row of its own - and their Trapezius
# the Push Press's 0.36 rather than the cleans' 0.70, since nothing is pulled
# from the floor and nothing is shrugged. The Barbell Clean and Jerk is the only
# lift here that does both, so its pull rows are the cleans' and its overhead
# rows are the jerks'. Inside the jerks the separation is the receive: the
# Barbell Clean and Jerk and the Split Jerk land in a 0.61 m split with the left
# foot forward, to within 2 mm of each other, while the Push Jerk's feet never
# separate front to back by more than 0.123 mm and jump 8 cm wider instead. The
# library's Push Press is the nearest dip-and-drive lift and never leaves the
# floor; the thrusters squat, where these dip 31 degrees at the knee; and the
# snatches of this round put the load overhead in one movement and never re-grip,
# where every lift here starts or passes through a rack on the shoulders.
#
# HOW THE FIVE READ AS ONE. Where the cue is the same across lifts the label
# string is the same, and it is the library's own string wherever the library
# has one: `Flat back` (9) on all three lifts that set up over a load on the
# floor, on the same spine anchor, under the same Start Position title;
# `Legs up` (7) wherever the legs or the hips raise the load with the arms long
# (Dumbbell Clean and Press first pull, Kettlebell Clean and Press hip drive),
# on the same patella_R anchor; `Dip straight down` (17) on all three lifts that
# dip (Barbell Clean and Jerk, Split Jerk, Push Jerk); `Legs first` (10) on both
# jerk leg drives; `Elbows in front` (15) on both jerk racks, under the same
# `Front Rack` title, on both lifts that open already racked. The cue IDS follow
# the same rule: `catch` is the catch of a clean on both lifts that clean (the
# library's own id for it, as in Clean and Press/catch) and `rack` is the front
# rack on both lifts that start racked. The TITLES follow the library's
# dip-and-drive lifts rather than the snatch round's, so the two jerks both
# read `Dip` and `Lockout` as the Push Press and the Dumbbell Push Press do
# (`The Dip` is the Hang Cleans' title and `Overhead Lockout` the snatches'),
# and the Barbell Clean and Jerk's clean catch is `The Catch`, as it is on the
# four library lifts that catch a clean. The two lifts that press strictly
# share one comparison badge, DIPPING TO PRESS, and the three jerks keep three separate badges
# because the fault each names is different (pressing the jerk off the shoulders
# instead of driving, splitting the feet in a receive that does not split, and
# moving the feet before the drive ends). There is exactly ONE place the family does not share a label for a
# cue it shares: the strict press is `Strict press` (12) on the Dumbbell Clean
# and Press and `No dip` (6) on the Kettlebell Clean and Press, because in the
# kettlebell frame the only slot left for that cue takes six characters and a
# twelve-character press pill would cut the layout's tightest clearance from
# 10.7 px to 1.6 px; the entry's own comment carries the measurement.
# Where the labels differ because the LIFT differs they say so: the first pull
# is `Bar close` on the barbell, where the bar measurably runs 1.0 cm off the
# shins and thighs, and `Legs up` on the dumbbells, which hang outside the legs
# with nothing to brush; and the clean catch is `Catch it high` on the Barbell
# Clean and Jerk, which receives in a quarter squat with the thigh 43.0 degrees
# above horizontal, against `Drop under` on the Dumbbell Clean and Press, which
# dips to 110.73 degrees of knee to meet the bells.
#
# Sources (what each is used for is in notes_1029_jerk.md). THE BOUNDARY FIRST:
# there is NO PEER-REVIEWED EMG study of any jerk anywhere. The 2023 NSCA
# position statement's 323 references cite none, and the only EMG recorded
# during a jerk at all is an unreviewed preprint on track-and-field athletes
# (Liu 2021), which is not used. So no
# fraction in this module is ranked on jerk activation, no cue claims a muscle
# works hardest in any phase of a jerk, and every muscle statement about a jerk
# is paint plus mechanics and says so.
# - Lake J, Lauder M, Dyson R 2006, Exploring the biomechanical characteristics
#   of the weightlifting jerk, XXIVth International Symposium on Biomechanics in
#   Sports (full four-page text read 2026-10-30; no DOI, open access at
#   ojs.ub.uni-konstanz.de/cpa/article/view/275, text extracted locally because
#   the OJS galley serves the wrong file): seven recreational weightlifters, six
#   male and one female, height 1.74 m, mass 81.5 kg, jerk load 65 +/- 20 kg or
#   about 80% of estimated 1RM, two lifts each, two Kistler platforms at 200 Hz
#   with the front foot on its own plate plus 2D sagittal video at 200 Hz.
#   Measured: dip knee flexion 58 +/- 9 degrees at 125 +/- 16 degrees a second;
#   dip depth as HIP vertical displacement 11 +/- 2% of body height; drive knee
#   extension 54 +/- 9 degrees, i.e. less range than the dip flexed; peak drive
#   vertical force 3.5 +/- 1.2 BW; front-foot catch peak 3.4 +/- 1.2 BW. The only
#   force-plate study of the jerk's dip, drive and catch, and the only directly
#   measured dip depth in the literature. It has no EMG, n = 7, and it measures
#   the hip rather than the bar or the centre of mass, so it is cited for dip
#   SHAPE and for scale against this model's 30.8-31 degrees, never for an
#   optimum - nobody has changed dip depth and measured the result.
# - Soriano MA, Lake JP, Comfort P, Suchomel TJ, McMahon JJ, Jimenez-Ormeno E,
#   Sainz de Baranda P 2024, Sports Biomechanics 23(11):2080-2092, doi
#   10.1080/14763141.2021.1993983 (accepted manuscript read in full 2026-10-30
#   from eprints.chi.ac.uk/id/eprint/6053): 16 resistance-trained participants,
#   12 men and 4 women, 2.2 +/- 1.3 years of weightlifting experience and, in the
#   authors own words, no highly skilled weightlifters; three reps each of the
#   push press, push jerk and split jerk at 80% of push press 1RM on a force
#   platform, dip and thrust both analysed. System centre-of-mass dip 0.20 +/-
#   0.05 m, 0.19 +/- 0.04 m and 0.20 +/- 0.05 m (p = 0.98) and NOT ONE kinetic
#   variable differed between the three lifts (p > 0.05, eta squared < 0.01). It
#   measures no muscle and no bar displacement, and the authors ask that it be
#   extrapolated to skilled lifters with caution, so it is cited for dip depth in
#   that population only.
# - NSCA position statement on weightlifting 2023 (open PDF read 2026-10-30 from
#   nsca.com, extracted locally): jerk propulsion phase 259 +/- 24 ms, barbell
#   speeds 1.06-1.9 m/s. Used once, for the scale of this model's 0.250 s drive.
#   Its 323 references contain no EMG of a jerk, which is the boundary above.
# - Nagao H, Ishii Y 2021, characteristics of the shrug motion and trapezius
#   muscle activity in the power clean: 20 trained men, upper trapezius
#   normalised to %MVC, rising with load in the first pull and the transition and
#   falling with load in the second pull. The ONE %MVC-normalised EMG in any lift
#   this family contains. It publishes no percentage and stops at the catch of
#   the clean, and nothing is shrugged in any jerk here, so it is recorded and
#   NOT used to set a Trapezius fraction on any of the five.
# - Saeterbakken AH, Fimland MS 2013, J Strength Cond Res 27(7):1824-1831, doi
#   10.1519/JSC.0b013e318276b873, PMID 23096062 (abstract read in full
#   2026-10-30): 15 healthy men, 80% 1RM, barbell and dumbbell, seated and
#   standing. A standing barbell press drew about 15% LESS anterior deltoid than
#   standing dumbbells (p < 0.001) and allowed about 7% more weight (p = 0.002);
#   a barbell drew about 39% more triceps than dumbbells standing (p < 0.001).
#   The paper publishes its differences with the barbell as the base, which is
#   how they are written here, and they are between-condition differences and not
#   %MVIC, so they order the implements and cannot set a fraction; it measured
#   seated and standing shoulder presses, not a clean and not a lift from a rack,
#   and it records no leg muscle. Cited in the Dumbbell Clean and Press's press
#   cue.
# - Saeterbakken AH, Fimland MS 2012, Eur J Appl Physiol 112(5):1671-1678, doi
#   10.1007/s00421-011-2141-7, PMID 21877146 (abstract read in full 2026-10-30):
#   15 healthy males, dumbbell shoulder press, five reps at 80% 1RM, seated or
#   standing and bilateral or unilateral, rectus abdominis, external oblique and
#   erector spinae only. Rectus abdominis about 81% lower seated than standing
#   bilaterally and external oblique about 58% lower, both p < 0.001, while the
#   erector spinae did not differ with position (p = 0.480 bilaterally). Cited in
#   the Kettlebell Clean and Press's press cue for the brace, with the bilateral
#   condition named, because these models are bilateral; its large oblique
#   effects are the UNILATERAL ones and do not apply, and its erector result
#   argues against claiming a standing press loads the low back more.
# - Campos YAC, Vianna JM, Guimaraes MP, Oliveira JLD, Hernandez-Mosqueira C, da
#   Silva SF, Marchetti PH 2020, J Hum Kinet 75:5-14, doi
#   10.2478/hukin-2020-0033, PMID 33312291, PMCID PMC7706677 (full text read
#   2026-10-30 via PMC): 13 men experienced in strength training, one set of 12
#   reps at 60% 1RM, SEATED barbell shoulder press through a partial range from
#   180 to about 135 degrees, %MVIC. Anterior deltoid 33.3%, medial 27.9%,
#   posterior 11.4%. Used only for the DIRECTION of the Dumbbell Clean and
#   Press's new Posterior Deltoid row, never for its value; it measures only the
#   three deltoid portions, seated, barbell, partial range.
# - Lyons B K et al 2017 (J Strength Cond Res 31(9):2363-2370): 14
#   resistance-trained subjects, ONE-arm kettlebell swing, snatch and clean at a
#   self-selected 8-10RM, eight muscles normalised to MVC. It found NO difference
#   between the three lifts in the gluteus maximus and publishes no percentage,
#   and is used in the Kettlebell Clean and Press's drive cue as that null result
#   only - it measures a one-arm lift, not this two-bell one.
# - Blazkiewicz M, Hadamus A 2022: found no significant difference for any
#   muscle between a kettlebell and a dumbbell press. Recorded, and the reason no
#   cue in this family compares the two implements.
# - The coaching sources, all technique teaching with nothing measured behind
#   them, and labelled as coaching wherever the copy leans on them: Catalyst
#   Athletics Split Jerk and Push Jerk pages (the bar between the throat and the
#   top of the shoulders, the hands as deep under it as possible, the elbows down
#   but in front of the bar; a dip of roughly 10% of height; any depth above a
#   parallel squat is a push jerk, and a lift whose knees rebend at all after the
#   dip and drive is a push jerk and not a push press); Greg Everett, The
#   Jerk Part 1 and Part 2 (a bar held mainly in the arms keeps descending after
#   the legs extend; pressing early stops leg and hip power reaching the bar; the
#   back knee must stay bent; the attempt to press the bar up pushes the lifter
#   down; the last few degrees of extension add little force); Bob Takano via
#   SportsEdTV (front foot back
#   first; moving the feet before the drive is complete cuts the force reaching
#   the bar); CrossFit (the shoulder press as a press from standing without
#   assistance from the legs; the legs and hips extending rapidly and fully in a
#   jerk; the arms locking out slightly before or as the feet land);
#   StrengthLog (the recovery order). CrossFit's unsourced 30%
#   push-jerk-over-push-press figure is deliberately NOT used.
# - The library's own entries, read in SampleData.swift on 2026-10-30 for the
#   fractions that are carried rather than estimated: Clean and Press (Anterior
#   Deltoid 0.84, Trapezius 0.70, Gluteus Maximus 0.70, Quadriceps 0.62, Triceps
#   Brachii 0.55, Erector Spinae 0.55, Hamstrings 0.50, Lateral Deltoid 0.50,
#   Biceps Brachii 0.30), the parent of both clean-and-presses and itself a
#   strict press; Push Press (Trapezius 0.36), the nearest dip-and-drive overhead
#   lift; Overhead Carry (Lateral Deltoid 0.45), the one loaded overhead HOLD;
#   Overhead Squat (Gluteus Maximus 0.50); Suitcase Carry through the Kettlebell
#   Clean and the Kettlebell Snatch (Trapezius 0.44); Deadlift (Posterior Deltoid
#   0.30); the Clean and Press's own Forearms 0.35, removed at cb05540 when its
#   401-500 re-paint unlit the forearms and brought back here on the one model
#   that lights them again; and the library's dim calf rows, 0.30-0.50, for
#   Gastrocnemius 0.30. Section 7 of the round's rows.md recommends changing no
#   shipped library row, so no entry below carries a `library=` override.
# - The owner's two decisions of 2026-10-30, which close two of the round's open
#   points: Anterior Deltoid stays 0.40 on the three jerks rather than taking the
#   Push Press's 0.80, and the glutes stay ONE group - the rig lights gluteus
#   maximus, medius and minimus together, so every lift gets a single Gluteus
#   Maximus row, the copy says glutes, and no entry names the medius anywhere,
#   in a row or in the stabilisers. Of rows.md section 10's fifteen numbered
#   points those two are the ones these decisions close, so THIRTEEN are still
#   open, and no cue below assumes an answer to any of them.

from common_1_50 import *

NAMES = ["Dumbbell Clean and Press", "Kettlebell Clean and Press",
         "Barbell Clean and Jerk", "Split Jerk", "Push Jerk"]


# ======================================================= dumbbell clean and press

# --------------------------------------------- dumbbell clean and press
#
# Model Shoulder/DumbbellCleanAndPress (framing yaw -0.8, zoom 0.724, offset
# [0.006, -0.051, -0.006]), 192 frames at 24 fps (7.958 s), seen from a
# three-quarter angle off the lifter's left - whether that is a front or a rear
# three-quarter is the open question THE VIEW records in the module header, and
# nothing below depends on it - 382 x 655 points of screen. ONE rep,
# floor to overhead and back to the floor, and the clip loops: the last frame
# matches the first to 0.0001 mm. TWO dumbbells, one in each hand, both arms
# working together - six meshes under /root/HG_WeightL and /root/HG_WeightR,
# each bell a 0.340 m handle 0.032 m thick with a 0.160 m head 0.070 m thick at
# each end (dcp_size.py, local extents times the prim's own world scale, which
# is 1.0 here; session_facts.md's 0.336 / 0.172 are near.py's world
# axis-aligned box, which follows the tilt of a rotating bell and so reads the
# 0.032 m handle as 0.336-0.341 m on all three axes), each handle 0.104 /
# 0.109 m from its own hand joint at every frame. The two
# bells are independent: centre-to-centre separation runs 0.382 m at the rack
# to 1.083 m at the turnover, so this is NOT one rigid implement, and it is
# not a one-arm lift either. The legs are symmetrical to 0.158 degrees at the
# knee; the arms are not - the left elbow racks 3.97 degrees deeper than the
# right. Three held poses: the set-up 0.000-0.375 s, the rack 3.542-3.667 s
# and the lockout 4.500-5.417 s. The press is STRICT: over 3.708-4.500 s the
# elbow travels 143.13 degrees while the knee, hip and trunk ranges are all
# exactly 0.0000 degrees and the pelvis 0.000 mm.
ex(name="Dumbbell Clean and Press", var="dumbbellCleanAndPress",
   # Rows are the raw 0.14-0.86 scale; spec_1029.py renders them at the drawn
   # rows 0.16, 0.32, 0.48, 0.64 and 0.80, and every figure below is at the
   # DRAWN row and at the pill the app draws: half-height 0.025 in v, width
   # (24 + 5.6 * len(label)) / 382, pinned 0.035 from the leading (left) or
   # trailing (right) edge. Lifter clearances are the minimum over all 192
   # frames against the 655-row SKINNED silhouette; face checks are against
   # the head's OWN silhouette (DumbbellCleanandPress_HEAD.npz), not a box
   # round the head joint, which sits at the base of the skull and misses up
   # to 18 cm of crown in a folded-over pose.
   #
   # THE FRAME. The bells travel from 0.0007 m on the floor to 2.1723 m
   # overhead, so they enter every one of the five rows at some moment
   # (row 0.48 cheapest at 0.46 s, row 0.32 worst at 2.25 s) - there is no
   # free row, unlike the Kettlebell Snatch. But they are narrow, so a short
   # pill on the far side of the frame clears them, and the layout below is
   # the one that costs NOTHING: all five pills clear the lifter AND the load
   # at every one of the 192 frames, and no leader touches the face at any
   # frame. Nothing is traded here, which is only possible because the load
   # is two dumbbells and not the 2.04 m bar of the three barbell siblings.
   #
   # Pill by pill, in cue order (slot, label length, lifter clearance, load,
   # leader against the face):
   #   setup  `Flat back`     9  row 0.16 trailing  lifter 26.3 px, load
   #     1.9 px and 0 frames inside, leader to spine 23.3 px off the face.
   #     Row 0.16 trailing is clean only to NINE characters - at ten the
   #     bells are inside the pill for 32 frames (1.33 s) - so the library's
   #     own nine-character `Flat back` is exactly the budget. The top three
   #     rows are empty at the set-up (the lifter spans v 0.524-0.869 there),
   #     and the lifter is in row 0.16 for only 43 of 192 frames.
   #   pull   `Legs up`       7  row 0.48 trailing  lifter 19.9 px, load
   #     3.2 px and 0 frames inside, leader to patella_R 82.4 px off the
   #     face - the calmest leader in the layout. Row 0.48 trailing is clean
   #     only at SEVEN characters (eight puts the load inside for 2 frames),
   #     which is why the seven-character label goes here.
   #   extend `Heels lift`   10  row 0.64 trailing  lifter 7.0 px, load
   #     8.7 px and 0 frames inside, leader to foot_R never spans the head
   #     rows at all. Row 0.64 trailing takes eleven characters as a pill but
   #     with only 1.4 px of lifter clearance, so the label stays at ten.
   #   catch  `Drop under`   10  row 0.16 leading   lifter 68.1 px, load
   #     40.8 px and 0 frames inside, leader to hand_R 4.1 px off the face.
   #     This is the one roomy slot in the frame as a PILL - 17 characters
   #     still clear the lifter by 28.9 px and the load by 4.1 - but the
   #     leader is what binds: from row 0.16 leading, EVERY probed joint
   #     except hand_R lies on the face, and hand_R itself goes on the face
   #     from THIRTEEN characters (-1.8 px, 23 frames) and is 40 frames gone
   #     by sixteen, so the label stays at ten (4.1 px) instead of spending
   #     the room. 4.1 px is the tightest figure in this
   #     layout and it is deliberate.
   #   press  `Strict press` 12  row 0.80 trailing  lifter 32.2 px, load
   #     20.3 px and 0 frames inside, leader to upper_arm_L never spans the
   #     head rows. Row 0.80 trailing is the only slot BESIDES row 0.16
   #     leading - which the catch pill holds - that takes a
   #     twelve-character label clean (it is clean to fifteen), which is why
   #     `Strict press` - the parent Clean and Press's own label for this
   #     same cue, on its own anchor upper_arm_L - sits here rather than
   #     being shortened.
   #
   # WHY THE OTHER FIVE SLOTS ARE EMPTY, in the same measure:
   #   0.32 leading is clean to eight characters (31.2 px lifter, 0.6 px
   #     load) but its leaders are poor: at SEVEN characters only hand_R
   #     (14.1 px) and forearm_R (2.3 px) keep the leader off the face, and at
   #     eight they fall to 11.5 px and 0.3 px. hand_R is the anchor the catch
   #     pill already uses from row 0.16 leading, which has 68.1 px of lifter
   #     room at ten characters against this slot's 36.8 at seven. So the
   #     leading side carries one pill, not two.
   #   0.32 trailing sits ON the lifter from EIGHT characters (-4.4 px,
   #     3 frames, and -10.0 px over 5 frames at nine); seven leaves 1.2 px.
   #   0.48 leading sits on the lifter from eight (-3.8 px, 1 frame; -9.4 px
   #     and 2 frames at nine) and takes the load in 5 frames there.
   #   0.64 leading takes the load in 13 frames at nine characters and 7 at
   #     seven; the bells swing out to u 0.170-0.219 on that side.
   #   0.80 leading takes the load in 35 frames at nine (1.46 s - the bells
   #     on the floor at the set-up and the finish) and is on the lifter from
   #     eleven.
   # Reproduce any figure with, in the jerk data folder,
   #   room.py "Dumbbell Clean and Press" 7,8,9,10,11,12,15,17
   #   lead.py "Dumbbell Clean and Press" - <drawn row> <side> <length>
   #
   # The label strings are the library's where the cue is the same: `Flat
   # back` (9, used twelve times, including Clean and Press/start, Power
   # Snatch/setup and Dumbbell Snatch/setup), `Legs up` (7, Dumbbell
   # Snatch/pull), `Drop under` (10, Power Snatch/catch) and `Strict press`
   # (12, Clean and Press/press). `Heels lift` (10) deliberately inverts the
   # library's `Heels down` (10, Dumbbell Thruster/heels): this model lifts
   # BOTH heels 5.81 cm for 1.208 s, so the usual string would be wrong here.
   overrides={"setup": (0.14, "trailing"), "pull": (0.50, "trailing"),
              "extend": (0.68, "trailing"), "catch": (0.14, "leading"),
              "press": (0.86, "trailing")},
   annotations=[
       ("setup", "Flat back", "spine"),
       ("pull", "Legs up", "patella_R"),
       ("extend", "Heels lift", "foot_R"),
       ("catch", "Drop under", "hand_R"),
       ("press", "Strict press", "upper_arm_L"),
   ],
   cues={
       "setup": ("Start Position",
                 "You start in a deep squat over two dumbbells that stand clear of each foot, a hand's length in front of your toes.",
                 "In the model the first ten frames are identical, so this is a held set position and not a swing: the knees at 64.21 degrees - 116 degrees of knee bend, deeper than the barbell clean and jerk in this app starts with, 97.9 degrees - the hips at 51.15, the trunk 64.75 degrees forward and the pelvis at 0.4799 m, its lowest in the clip. So it is a squatting start, not a hinge. The bells sit well forward of the feet because the folded trunk puts the shoulders 29.2 cm in front of the ankle and the arms hang straight down from there: each bell centre is 32.00 cm in front of the ankle joint, 18.11 cm in front of the toe joint and 20.78 cm outside the ankle. The feet are close together, 0.1900 m between the ankles against 0.3922 m at the shoulders.",
                 "Hinging down to the bells with the hips high and the chest already dropped.",
                 "Set your feet about half a shoulder-width apart, squat down until you can take a handle in each hand with a flat back, and brace your trunk before you pull."),
       "pull": ("First Pull",
                "Both bells leave the floor together while your legs stand up and your arms stay long.",
                "In the model the elbows do nothing at all through the first pull: 173.36 degrees at the floor and still 172.44 a second later, and they do not cross 172 degrees until 1.958 s. Underneath, the knees open from 65.20 to 119.94 degrees, the hips from 51.93 to 113.43, the trunk comes from 64.47 to 38.52 degrees forward and the pelvis rises from 0.486 m to 0.793 m, while the bells go from 0.009 m to 0.505 m, averaging 0.496 m/s. Both heels stay flat for all of it - they do not leave until 1.583 s. The knees never re-bend on the way up; what re-folds is the trunk, 38.01 degrees at 1.417 s back to 42.89 at 1.583 s while the knees keep extending, which reads as a scoop rather than a double knee bend. That reading is mechanics; the angles are measured.",
                "Curling the bells up with the arms while the hips are still bent.",
                "Push the floor away and stand up, keeping both arms long and letting the bells rise straight up outside your knees."),
       "extend": ("Second Pull",
                  "At the top of the pull everything opens at once and both heels come off the floor.",
                  "In the model the pelvis, the trunk and the heels all peak together at 1.875 s: the trunk swings through vertical to 4.65 degrees behind it, the pelvis reaches 0.9573 m, and both heels lift together - 5.81 cm on the left and 5.80 on the right - with the toes still planted, so each ankle swings 4.8 cm forward. The hip peaks one frame later at 162.65 degrees and the knee keeps extending five frames more, to 171.69 at 2.125 s. The elbows are still at 172.77 degrees when the heels are at their highest, so this is all legs. The heels are off the floor for 1.208 s in all, 1.583 to 2.750 s, and that is the calf work in this lift.",
                  "Bending the elbows to help the bells up before your hips have opened.",
                  "Drive through the whole foot until your hips and knees are open and your body is one long line with your arms still long, and let your heels come up as it happens."),
       "catch": ("The Catch",
                 "As your hips finish opening, the elbows whip under and you drop under the bells to catch them at your shoulders.",
                 "In the model the elbows fold from 171.9 degrees to 30.81 and 34.77 in a little under a second, 0.92 s, and the hands fly wide while they do - 0.698 m apart to 1.063 m at 2.250 s - before coming back to 0.4205 m at the shoulders, so the bells do not stay close to you through the turnover - take the shape from the model and keep them closer than it if you can. What you drop into is a dip, not a squat: the knee bottoms at 110.73 degrees and the pelvis at 0.7600 m, 19.7 cm below where the drive left it, and the elbows have already finished folding before the dip bottoms at 3.000 s. Then the lifter stands all the way up to 175.22 degrees and holds the rack still for 4 frames, 3.542 to 3.667 s, the hands 1.4739 m up and 3.92 cm above the shoulder joint. Two bells are not one bar: the left elbow racks 3.97 degrees deeper than the right, so each arm arrives on its own.",
                 "Waiting for the bells with straight legs and letting the elbows take the whole load.",
                 "As the bells peak, whip your elbows under them and bend your knees to meet them, then stand all the way up and settle the rack before you press."),
       "press": ("Strict Press",
                 "From a dead stop at the shoulders the arms alone put the bells overhead - nothing below them moves.",
                 "This is the measurement that separates this lift from the jerks beside it. Over the press, 3.708 to 4.500 s, the elbow travels 143.13 degrees, from 30.87 to 174.00, while the ranges below the shoulders are exactly 0.0000 degrees at both knees, 0.0000 at the hip, 0.0000 at the trunk and 0.000 mm at the pelvis; the head moves 0.92 mm. The rack is held 0.167 s first, so the press also starts from a dead stop - which is how CrossFit defines its shoulder press, a press from standing without assistance from the legs, though that is coaching and not a measurement. The bells finish with their lowest point at 1.9825 m, 20.0 cm above the crown of the head, and the lockout holds 0.958 s. Two bells cost you weight for it: pressing 15 men at 80% of their one-rep maximum, a standing barbell press drew about 15% less anterior deltoid activity than standing dumbbells and allowed about 7% more weight.",
                 "Dipping the knees and driving the bells up with the legs, turning it into a push press.",
                 "Stand tall, hold the rack still, then press both bells straight up to locked elbows above your head, and lower them back to your shoulders before you bring them down."),
   },
   # Rows follow the paint, settled for the whole family in rows.md section 3a
   # and pasted here unchanged. tiers_jerk.json gives this model 35 painted
   # meshes - 8 bright, 27 dim, nothing faint, nothing one-sided - the
   # richest of the five, which is why this is the longest list in the
   # family: 12 rows, 3 primaries. Bright, so primary: the Anterior Deltoid,
   # the three glutes as ONE Gluteus Maximus row (the rig lights maximus,
   # medius and minimus together and the owner confirmed on 2026-10-30 that
   # the paint is not split, so the copy says glutes and no list names the
   # medius) and the four quadriceps. Dim, so secondary: the three trapezius
   # parts with the rhomboid major inside them as one Trapezius row, the
   # erector spinae, the three triceps heads, the lateral and posterior
   # deltoid, the three hamstrings, both biceps heads, the nine forearm
   # meshes as one Forearms row and the calves as one Gastrocnemius row.
   # EVERY FRACTION IS A CARRY, nine of them from the parent Clean and Press
   # itself (Anterior Deltoid 0.84, Gluteus Maximus 0.70, Trapezius 0.70,
   # Quadriceps 0.62, Erector Spinae 0.55, Triceps Brachii 0.55, Lateral
   # Deltoid 0.50, Hamstrings 0.50, Biceps Brachii 0.30), because the parent
   # is itself a strict press and this model presses exactly as strictly -
   # measured, 143.13 degrees of elbow against 0.0000 degrees everywhere
   # below the shoulders. THREE of those nine change rank only, on
   # this model's paint, keeping the fraction as the README's rank-change
   # rule asks: Triceps Brachii, Lateral Deltoid and Hamstrings all move
   # DOWN to secondary. Trapezius is NOT one of them - the parent already
   # ranks it secondary at 0.70 (SampleData.swift cleanAndPressContent, read
   # 2026-10-30), so it is a plain carry, rank included, and rows.md section
   # 3a should be corrected to match. The three remaining rows: Forearms 0.35 is the
   # Clean and Press's OWN removed forearm row coming back (git show
   # cb05540^ has MuscleActivation(name: Forearms, rank: .secondary,
   # fraction: 0.35) on it, dropped when its 401-500 re-paint unlit the
   # forearms; this model lights them again, nine meshes including palmaris
   # longus, which part_of() drops on its own name and so has to ride inside
   # a Forearms row); Posterior Deltoid 0.30 is the Deadlift's rear-delt
   # floor, new to this family, with Campos 2020's posterior deltoid 11.4%
   # MVIC against the anterior's 33.3% in a seated barbell press (13 trained
   # men, 60% 1RM, a partial range from 180 to 135 degrees) supporting the
   # DIRECTION only; and Gastrocnemius 0.30 is the floor of the library's dim
   # calf rows (0.30-0.50) carried from the Power and Dumbbell Snatch, which
   # the measured 5.81 cm heel lift earns. No source measures any of this as
   # a lift: no peer-reviewed study of a clean and press was found in any
   # implement, and there is no EMG study of any jerk anywhere, so nothing
   # here is sourced to a number. Saeterbakken and Fimland 2013 (15 men,
   # 80% 1RM, bilateral, standing and seated) gives the only direction that
   # bears on the implement - dumbbells about 15% higher than a barbell in the
   # anterior deltoid (p < 0.001), the medial deltoid only a non-significant
   # trend (about 7%, p = 0.050), a barbell about 39% higher in the triceps
   # standing (p < 0.001) - and it measured seated and standing shoulder
   # presses, not a clean and not a lift from a rack. Campos 2020's
   # 27.9 against 33.3% MVIC for the medial and anterior heads is the sound
   # support for the Lateral Deltoid direction and is cited above.
   # OPEN POINTS this list hands the owner, from rows.md section 10: the
   # triceps are only DIM on the one lift of the five that takes the elbow
   # through a full strict press with the legs still (10.11); the bright
   # glutes and quadriceps are earned entirely by the clean and the catch and
   # not by the press, whose leg ranges are 0.0000 (a new remark, not one of
   # section 10's points); the Posterior
   # Deltoid row is new to the family and exists only on the paint (10.12);
   # twelve rows with three primaries will make the one-line legend
   # tight (10.13) - the legend's two name lines are lineLimit(1), so about
   # 35-40 characters of a 139-character secondary line render and the
   # Forearms, Posterior Deltoid and Gastrocnemius rows will show only in
   # the Muscles Worked sheet; and the soleus is painted DIM on this model
   # alone yet named among the stabilisers while the gastrocnemius pair
   # gets a row (10.14).
   activation=[("Anterior Deltoid", P, HI, 0.84), ("Gluteus Maximus", P, HI, 0.70),
               ("Trapezius", S, HI, 0.70), ("Quadriceps", P, MOD, 0.62),
               ("Erector Spinae", S, MOD, 0.55), ("Triceps Brachii", S, MOD, 0.55),
               ("Lateral Deltoid", S, MOD, 0.50), ("Hamstrings", S, MOD, 0.50),
               ("Forearms", S, LOW, 0.35), ("Biceps Brachii", S, LOW, 0.30),
               ("Posterior Deltoid", S, LOW, 0.30), ("Gastrocnemius", S, LOW, 0.30)],
   stabilisers=["core", "rhomboids", "serratus anterior", "rotator cuff",
                "latissimus dorsi", "soleus"],
   comparison=("DIPPING TO PRESS", "Legs still, arms press", "Knees dip to start the bells",
               "The arms do the whole press in the model: 143.13 degrees of elbow extension with both knees, the hip and the trunk measuring a 0.0000 degree range and the pelvis 0.000 mm.",
               "Dipping the knees turns it into a push press. The one knee bend in this clip is the clean catch, 110.73 degrees at 3.000 s, and the lifter stands up to 175.22 and holds the rack before the press begins at 3.708 s."),
   # The paint, one glow per row of it: the glutes at the hip and the
   # quadriceps down each thigh (bright, so A), the anterior deltoid on both
   # shoulders (bright on both sides - this is a two-arm lift, not the
   # one-sided paint of the snatches), and the dim calves as a SOFT glow at
   # the shins, which only this model of the five earns.
   glows=[glow("Dumbbell Clean and Press", ["pelvis", "thigh_L"], A, 0.55, rx=0.11, ry=0.07),
          glow("Dumbbell Clean and Press", ["patella_L", "thigh_L"], A, 0.50, rx=0.08, ry=0.08),
          glow("Dumbbell Clean and Press", ["patella_R", "thigh_R"], A, 0.50, rx=0.08, ry=0.08),
          glow("Dumbbell Clean and Press", ["deltoid_arc_clavicle_2_L", "deltoid_arc_scapula_2_L"],
               A, 0.50, rx=0.08, ry=0.06),
          glow("Dumbbell Clean and Press", ["deltoid_arc_clavicle_2_R", "deltoid_arc_scapula_2_R"],
               A, 0.50, rx=0.08, ry=0.06),
          glow("Dumbbell Clean and Press", ["shin_L", "shin_R"], SOFT, 0.28, rx=0.10, ry=0.05)])

SETUP["Dumbbell Clean and Press"] = [
    "Set your feet half a shoulder-width apart and stand a dumbbell clear of each foot, a hand's length in front of your toes.",
    "Squat down with your back flat until you can take a handle in each hand, palms facing in and both arms hanging straight.",
    "Brace your trunk and take the weight of both bells before the first pull.",
    "Between reps, lower the bells to your shoulders, then to the floor, and set your back again rather than dropping them.",
]


# ===================================================== kettlebell clean and press

# ------------------------------------------- kettlebell clean and press
# TWO kettlebells, one in each hand, both arms working together for the
# whole clip (elbow_L and elbow_R agree to 0.1444 degrees at every frame,
# hand_L.y and hand_R.y to 2.44 mm; twelve equipment meshes split six and
# six, every left mesh nearest hand_L and every right mesh nearest hand_R).
# Nothing one-armed can be said here - no working side, no free hand, no
# anti-rotation and no oblique story, and the rig paints no oblique and no
# abdominal, where the single-bell Kettlebell Clean paints bright obliques
# on the off side. ONE rep, floor to overhead and back, on a seamless loop
# (frame 191 matches frame 0 to 0.0001 mm), so no copy implies reps inside
# the clip; 78 of the 192 frames (40.6%, spanning 3.04 s) are a frozen pose
# in five windows at 0.00-0.33, 1.92-2.42, 3.33-4.17, 5.00-5.58 and
# 7.17-7.96 s, so no cue asks the reader to watch a tempo there. The stance
# never moves: anklegap 0.600-0.607 m = 1.53x the 0.3922 m shoulder span,
# front-to-back offset under 0.03 mm, and toe_L and toe_R frozen to 0.0 px
# in the frame. There is no dip, no split and no re-bend of the knees
# anywhere: the minimum knee from the clean's turnover to the rack is
# 174.48 degrees and the press holds 175.96 degrees unchanged.
ex(name="Kettlebell Clean and Press", var="kettlebellCleanAndPress",
   # Rows are the raw 0.14-0.86 scale; spec_1029.py renders them at 0.16,
   # 0.32, 0.48, 0.64 and 0.80, and every figure below is the DRAWN row.
   # Measured at the pill the app draws - half-height 0.025 in v, width
   # (24 + 5.6 * len(label)) / 382, pinned 0.035 from the leading or
   # trailing edge - over all 192 frames against the 3,036 projected
   # equipment points and the SKINNED 655-row silhouette (room.py), with
   # every leader tested against the head's OWN silhouette and not a box
   # round the head joint (lead.py). This is the tightest framing of the
   # family: the load runs floor to overhead, so it enters ALL FIVE rows
   # (1.67 / 2.62 / 0.29 / 0.54 / 2.83 s at rows 0.16 / 0.32 / 0.48 / 0.64
   # / 0.80) and its closest approach to every row centre line is 0.0 px -
   # there is no row it leaves alone, unlike the Kettlebell Snatch (row
   # 0.80 free) or the Hang Clean (0.64 and 0.80 free). What saves the
   # layout is that each crossing is brief and narrow, so short pills on
   # the far side of the frame clear it. The five pills as written, in cue
   # order (slot, label length, lifter clearance, load clearance, frames
   # the load is inside the pill, frames the leader lies on the face):
   #   setup  0.80 trailing, 9 ch  -> lifter 18.4 px, load 40.6 px, 0 in,
   #          leader 0/192 (spine never shares a row with the head)
   #   hike   0.80 leading, 11 ch  -> lifter 10.7 px, load 26.2 px, 0 in,
   #          leader 0/192, closest 33.3 px at t 3.42
   #   drive  0.64 leading, 7 ch   -> lifter 45.8 px, load 16.4 px, 0 in,
   #          leader 0/192 (patella_R never shares a row with the head)
   #   rack   0.48 trailing, 13 ch -> lifter 11.8 px, load 46.7 px, 0 in,
   #          leader 0/192, closest 17.3 px at t 3.38
   #   press  0.32 trailing, 6 ch  -> lifter 19.7 px, load 13.9 px, 0 in,
   #          leader 0/192, closest 112.3 px at t 7.25
   # So nothing is traded: no pill touches the lifter or the load on any
   # frame and no leader touches the face on any frame, on a clip where
   # every row is crossed.
   # WHY EACH SLOT BEAT ITS ALTERNATIVES.
   # Row 0.48 trailing is the slot in the frame the load never comes near -
   # 46.7 px clear at 13 characters, 36.9 px at 15 - and at THIRTEEN
   # characters only two of the ten slots are clear of both the lifter and
   # the load at every frame: this one and row 0.16 leading, which leaves
   # 0.4 px of load. So row 0.48 trailing takes the one label that needs 13
   # characters, the rack. Its leading twin is unusable: 0.48 leading has
   # the load inside the pill at every length from 6 characters up (4 frames
   # at six to nine, 5 at eleven, 6 at thirteen).
   # Row 0.32 trailing takes the press cue because the two higher slots
   # cannot: 0.16 trailing has the load inside the pill on 15 frames at 7
   # characters and 40 from 8 up, and 0.16 leading leaves only 3 of the 26
   # tracked joints with a face-clear leader (toe_R 14.7 px, foot_R 1.6 px,
   # shin_R 0.2 px at 9 characters) - none of them a press joint, and the
   # comfortable one would need a leader down the whole height of the
   # frame. At 0.32 trailing the label has to be short: 9 characters leaves
   # 2.9 px of lifter and 1.4 px of load, 8 leaves 8.5 and 5.4, so it is
   # cut to 6 and leaves 19.7 and 13.9. That is why the label is `No dip`
   # and not the library's 12-character `Strict press`, which the Dumbbell
   # Clean and Press above does use for the same cue. Twelve characters IS
   # placeable in this frame - four slots are clear of the lifter and the
   # load at that length (0.16 leading 9.2 px of lifter, 0.48 trailing 17.4,
   # 0.80 leading 5.1, 0.80 trailing 1.6) - but patella_L and forearm_L both
   # land on the face from 0.16 leading and 0.48 trailing is the rack's, so a
   # 12-character press pill has to take a row-0.80 slot, which pushes the
   # hike onto the other one and the set-up onto 0.32 trailing at 2.9 px.
   # That layout's tightest pill would be 1.6 px against this one's 10.7, so
   # the short label is the cheaper trade and the family's one label
   # divergence is a measured one.
   # Row 0.64 leading takes the drive at 7 characters: 45.8 px of lifter is
   # the widest clearance of any slot in the layout, patella_R sits at
   # v 0.653-0.664 so the leader is a few pixels long, and 11 characters
   # there would put the load inside the pill on 1 frame. Its trailing twin
   # lands ON the lifter from 9 characters up (37 frames).
   # Both row-0.80 slots are used, as the Kettlebell Snatch uses both of
   # its row-0.86 slots, because at these lengths the bottom row's two
   # pills are the farthest from the load of any slot except row 0.48
   # trailing, which the rack label holds (26.2 and 40.6 px clear, 0 frames
   # inside, against the rack pill's 46.7) even though row 0.80 is the row the load
   # spends longest in (2.83 s), and both the set-up and the hike happen
   # down there. 0.80 leading is held to 11 characters (10.7 px
   # of lifter; 13 lands on the lifter in all 192 frames) and 0.80 trailing
   # to 9 (18.4 px; 13 overlaps on 74).
   # Rows 0.16 and 0.32 leading are left empty: 0.16 for the reasons above,
   # and at 0.32 leading the leaders go bad with length: at THIRTEEN
   # characters 25 of the 26 tracked joints give a leader that lies on the
   # face and toe_R is the only exception (5.6 px), at eleven only four are
   # clear (toe_R 14.3 px, foot_R 7.1, shin_R 5.6, patella_R 5.1) and at
   # nine only six, every one of them on the lifter's right - because a pill
   # up there and a shoulder, hand or hip at the same height put the head
   # between them, which is the defect the round exists to catch.
   overrides={"setup": (0.86, "trailing"), "hike": (0.86, "leading"),
              "drive": (0.68, "leading"), "rack": (0.50, "trailing"),
              "press": (0.32, "trailing")},
   annotations=[
       ("setup", "Flat back", "spine"),
       ("hike", "Bells close", "hand_R"),
       ("drive", "Legs up", "patella_R"),
       ("rack", "Bells on arms", "forearm_L"),
       ("press", "No dip", "patella_L"),
   ],
   cues={
       "setup": ("Start Position",
                 "You stand over two bells with your feet wide, hinged at the hips with a flat back and a handle in each hand.",
                 "In the model the trunk starts 58.8 degrees forward with the hips at 79.6 and the knees at only 103.4 - a hinge, not a squat - the pelvis at 0.6199 m and each hand at 0.3604 m. The feet are 0.600-0.607 m apart, 1.53 times the 0.3922 m at the shoulders, and the bells stand between them at 0.1179 m either side of the midline, 12.0 cm in front of the ankle joint and 0.5 cm behind the toe joint, so about over the balls of the feet. Each bell hangs 0.2721 m straight below its hand, 87.3 degrees below horizontal. The first nine frames are identical: it is a set position, not a swing, and both arms are loaded the whole way - the two elbows never differ by more than 0.1444 degrees.",
                 "Rounding the back to reach the handles, or setting the bells out in front of your toes.",
                 "Set your feet about half again wider than your shoulders, stand the bells between them over the balls of your feet, hinge until your back is flat, and take a handle in each hand."),
       "hike": ("Bell Path",
                "The bells go backwards first: hike them between your thighs with long arms, then let them swing through.",
                "This is a swing clean, not a pull from the floor. In the model the bells leave the floor and travel 15.8 cm REARWARDS - bell centre depth +0.1200 to -0.0381 m, ending 3.8 cm behind the ankle joint, between the legs - while the trunk barely changes, 58.8 to 58.1 degrees, and the elbows lock out to 180.0. Then they swing 22.6 cm forward with the pelvis dead still at 0.6998 m, and only after that does the body extend. The two bells nearly touch down there: the gap between them closes to 1.53 cm at 0.917 s, and the nearest the left bell body ever comes to a leg joint is 0.2000 m, at 0.542 s. Each bell covers about 5.6 m of path over the rep, 5.561 m on the left and 5.667 m on the right.",
                "Lifting the bells off the floor like a deadlift, or letting them swing out in front of your knees.",
                "Tip the bells toward you, hike them back between your thighs with your arms long, and let them brush close to you as they swing through."),
       "drive": ("Hip Drive",
                 "The hips snap the bells up: everything opens at once and the arms stay long while it happens.",
                 "The whole extension takes 0.208 s in the model: the knees open 115.2 to 174.5 degrees at 284 degrees a second, the hips 97.8 to 174.5 at 368, the trunk comes from 52.9 degrees forward to 4.5 and then 4.67 behind vertical at 1.375 s, the pelvis rises 0.711 to 0.8938 m and the bells 0.236 to 0.656 m - with the elbows still 176 to 180 degrees through all of it. The heels barely leave: 1.43 cm, over 1.125 s to 1.458 s, and nothing lifts at all during the press. Which muscles do that is paint and mechanics only: no study has measured a muscle in a two-bell kettlebell clean, and the one EMG study of a one-arm kettlebell swing, snatch and clean found no difference between the three lifts in the gluteus maximus and published no percentage.",
                 "Pulling the bells up with the arms before the hips have finished.",
                 "Snap your hips through and stand up hard, keeping both arms long until the bells are already moving up."),
       "rack": ("Kettlebell Rack",
                "At the top of the drive your hands turn inside the handles and the bells roll round onto your forearms.",
                "The bells change place completely: from hanging 0.2721 m straight below the hand at the set-up, each one ends the turnover 0.1154 m from the hand at 7.6 degrees ABOVE it and 108 degrees forward, resting on the arm. Only the handle and the beads are gripped hard - the handle stays 0.1036 m from hand_L at every frame, constant to 0.002 mm - while the bell body swings through 157.6 mm of hand distance. The elbows fold 176.3 to 38.6 degrees, 451 degrees a second over the first five frames, and the hands come in to 0.293 m, inside the 0.3922 m at the shoulders. It is a low rack, held 0.500 s: the hands finish 2.0 cm BELOW the shoulder joint and the bells 17.2 cm below the head, and the knees never re-bend to take it - the minimum over the turnover is 174.48 degrees.",
                "Gripping hard so the bells flip over and bang down on your wrists instead of rolling round onto the forearms.",
                "Let your hands turn inside the handles so the bells roll round onto your forearms, tuck your elbows in to your ribs, and stand tall as they land."),
       "press": ("Strict Press",
                 "From the rack the arms do all of it: no dip, no re-bend of the knees, just press both bells up.",
                 "Measured over the whole press, 2.458 to 3.333 s, the knee holds 175.96 degrees UNCHANGED and the pelvis 0.8835 m, changing by 0.00 mm, while the elbow runs 38.5 to 175.0 degrees and each hand rises 55.2 cm. In a family named for the jerk this is one of the two lifts whose legs contribute nothing to getting the load overhead - the dumbbell version is the other, measured at the same 0.0000 degree ranges. The hands do not travel straight either: they part to 0.928 m at 2.917 s and finish 0.532 m apart, 1.36 times the shoulder span, with the bells 8.5 cm behind the ankle joint and the elbow locked at 175.0 degrees, not 180. Standing is what the brace is for: in 15 healthy men pressing dumbbells two-handed at 80% of one rep maximum, rectus abdominis was about 81% lower seated than standing and external oblique about 58% lower, both p under 0.001.",
                 "Bending the knees to launch the bells, or leaning back to get under them.",
                 "Brace with your ribs down and your glutes tight, keep your legs straight, and press both bells up until your elbows lock."),
   },
   # Rows are rows.md section 3b, unchanged, and they follow the paint
   # re-read with tiers.py on 2026-10-30: 7 bright, 16 dim, nothing faint,
   # nothing one-sided. Bright, so primary: the anterior deltoid, the three
   # glutes as ONE Gluteus Maximus row (the rig lights them as one group
   # and the owner confirmed on 2026-10-30 that the paint is not split, so
   # the copy says hips and glutes and never names the medius), and the
   # three hamstrings. Dim, so secondary: the four quadriceps, the three
   # trapezius parts as one Trapezius row with the dim rhomboid major
   # inside it, the three triceps heads, both biceps heads, the lateral and
   # posterior deltoid and the erector spinae. Every fraction is a CARRY,
   # not a new estimate: Anterior Deltoid 0.84, Gluteus Maximus 0.70,
   # Quadriceps 0.62, Erector Spinae 0.55, Triceps Brachii 0.55, Lateral
   # Deltoid 0.50 and Hamstrings 0.50 from the library's Clean and Press,
   # which is itself a strict press, with Triceps, Lateral Deltoid
   # and Quadriceps ranked DOWN on this model's paint (the README's rank-change rule: a
   # rank change keeps the fraction) and Hamstrings carried unchanged at
   # PRIMARY, which the parent already ranks it (SampleData.swift
   # cleanAndPressContent, read 2026-10-30) and which the bright hamstring
   # paint here agrees with - rows.md section 3b calls it a rank change and
   # should be corrected;
   # Trapezius 0.44 from the Kettlebell Clean and Kettlebell Snatch, and
   # through them from the Suitcase Carry; Biceps Brachii 0.30 from the
   # Clean and Press; Posterior Deltoid 0.30 from the Deadlift.
   # This lift is the only one in the family whose HAMSTRINGS are bright
   # while its QUADRICEPS are only dim - the exact inverse of the Split
   # Jerk and the Push Jerk - and for once the paint agrees with the
   # mechanics: the clean is a hinge (hip to 79.6 degrees, knee only to
   # 103.4) and the press has no knee bend at all, so there is very little
   # quadriceps work to find.
   # NOTHING HERE IS SOURCED TO AN EMG STUDY OF THIS LIFT, because none
   # exists: no peer-reviewed study of the clean and press as a whole lift
   # was found in any implement, there is no peer-reviewed EMG of any jerk
   # anywhere, and no study of a two-kettlebell press exists at all. The ONE
   # measured thing the copy leans on is stated with its population -
   # Saeterbakken and Fimland 2012 (15 healthy males, dumbbell shoulder
   # press at 80% 1RM, rectus abdominis about 81% and external oblique about
   # 58% lower seated than standing two-handed, both p < 0.001) in the press
   # cue - and it is not used to rank a row. The hip-drive cue cites NO
   # study: the nearest is Lyons 2017 (14 resistance-trained subjects, ONE-arm
   # kettlebell swing, snatch and clean at a self-selected 8-10RM), which
   # publishes no glute percentage and found no gluteus maximus difference
   # between the three lifts, so it is given as a null result and no figure. Everything else in the copy is this model's own
   # measurement or plain mechanics, said as mechanics. In particular no
   # cue gives a leg figure for the press (no study anywhere records a leg
   # muscle in any overhead press), no cue compares the kettlebell version
   # with the dumbbell one (Blazkiewicz and Hadamus 2022 found no
   # significant difference for any muscle), and Nagao and Ishii 2021's
   # trapezius result is NOT cited: it measures the shrug of a power clean
   # pulled from the floor, and nothing is shrugged here - the bells go
   # 15.8 cm backwards with the trunk held and the elbows locked at 180.0,
   # which is exactly why the Trapezius row is 0.44 and not the two-handed
   # cleans' 0.70.
   # OPEN POINTS this entry deliberately does not settle (rows.md section
   # 10): the Trapezius 0.44 reaches this lift through a ONE-ARM anchor
   # while both hands here pull, so 0.70 is defensible (point 4); the
   # Gluteus Maximus 0.70 / Hamstrings 0.50 pair could instead be the
   # Kettlebell Swing's 0.80 / 0.76, since this model hinges at least as
   # deep as the Kettlebell Snatch, which took that pair (point 5); a
   # primary Hamstrings 0.50 sits below a secondary Quadriceps 0.62 in the
   # legend, which is what the paint plus the rank-change rule produce and
   # still reads oddly (point 6); the forearms are unpainted on a lift that
   # grips two bells for all 192 frames and the calves are unpainted on a
   # 1.43 cm heel lift, so both are named among the stabilisers and no cue
   # claims a row for either (points 7 and 8); and the Posterior Deltoid
   # row is new to this family (point 12). The copy is written so that any
   # of those five decisions can go either way without a sentence having
   # to change.
   activation=[("Anterior Deltoid", P, HI, 0.84), ("Gluteus Maximus", P, HI, 0.70),
               ("Quadriceps", S, MOD, 0.62), ("Erector Spinae", S, MOD, 0.55),
               ("Triceps Brachii", S, MOD, 0.55), ("Lateral Deltoid", S, MOD, 0.50),
               ("Hamstrings", P, MOD, 0.50), ("Trapezius", S, MOD, 0.44),
               ("Biceps Brachii", S, LOW, 0.30), ("Posterior Deltoid", S, LOW, 0.30)],
   stabilisers=["core", "rhomboids", "serratus anterior", "rotator cuff",
                "latissimus dorsi", "forearms", "calves"],
   comparison=("DIPPING TO PRESS", "Legs locked, arms press it", "Knees dip to launch the bells",
               "The press in this model is strict from the first frame to the last: the knee holds 175.96 degrees unchanged and the pelvis moves 0.00 mm while each bell goes up 55.2 cm on the arms alone.",
               "Bending the knees to start it makes it a push press, which is a different exercise; nothing in the model's legs moves while the bells go overhead."),
   # Bright paint only, one glow a row, both sides because this lift is
   # bilateral and tiers.py finds nothing one-sided: the glutes at the hip,
   # the hamstrings down each thigh (the near one stronger, the far one
   # dimmer because the yaw turns it away from the camera), and the
   # anterior deltoid at each shoulder.
   glows=[glow("Kettlebell Clean and Press", ["pelvis", "thigh_L"], A, 0.55, 0.11, 0.07),
          glow("Kettlebell Clean and Press", ["thigh_L", "patella_L"], A, 0.50, 0.08, 0.08),
          glow("Kettlebell Clean and Press", ["thigh_R", "patella_R"], A, 0.42, 0.08, 0.08),
          glow("Kettlebell Clean and Press", ["deltoid_arc_clavicle_2_L"], A, 0.45, 0.035, 0.035),
          glow("Kettlebell Clean and Press", ["deltoid_arc_clavicle_2_R"], A, 0.40, 0.035, 0.035)])

SETUP["Kettlebell Clean and Press"] = [
    "Stand two kettlebells on the floor and set your feet about half again wider than your shoulders, one bell inside each foot.",
    "Hinge at the hips with a flat back, take a handle in each hand and tilt the bells toward you, over the balls of your feet.",
    "Brace your trunk and hike both bells back between your thighs to start the first rep.",
    "Between reps, bring the bells back down to your shoulders first, then let them swing down between your thighs under control rather than dropping them to the floor.",
]


# ========================================================= barbell clean and jerk

ex(name="Barbell Clean and Jerk", var="barbellCleanAndJerk",
   # ---------------------------------------------------------------- labels
   # Rows are written on the raw 0.14-0.86 scale; spec_1029.py renders them
   # at 0.16, 0.32, 0.48, 0.64 and 0.80, and every number below is measured
   # at the DRAWN row and at the pill the app draws: half-height 0.025 in v,
   # width (24 + 5.6 * len(label)) / 382, pinned 0.035 from the leading or
   # trailing edge. The lifter is the SKINNED silhouette binned one row per
   # screen pixel (BarbellCleanandJerk_SIL.npz, 184,718 points over 125
   # meshes), not joints.json's eight samples; the face test is the head's
   # OWN silhouette (BarbellCleanandJerk_HEAD.npz, 2,928 head-weighted
   # vertices), not a box round the head joint. Tools: room.py and lead.py
   # in the round folder, both spec-free - plus s9_leaders.py, which is the
   # only one of the three that reads all 41 probed joints out of
   # BarbellCleanandJerk_J41.npz. lead.py sweeps the 26 joints the per-frame
   # *_A.json carries, so the support_TrapeziusUpper_L counts below come from
   # s9_leaders.py and cannot be reproduced with lead.py.
   #
   # THE FRAME: this is the worst label frame of the round. The drawn load is
   # 77-78% of the frame wide at every one of the 192 frames (295.1-297.5 px
   # of 382; its union over the clip is u 0.009-0.931)
   # and it visits all five rows, so NO slot in this frame is ever free of the
   # bar - the layout can only minimise bar-time. Ranked by frames with the
   # bar inside a nine-character pill: 0.16 leading 18, 0.80 leading 24, 0.80
   # trailing 36, 0.64 trailing 41, 0.64 leading 46, 0.16 trailing 50, 0.48
   # trailing 61, 0.48 leading 70, 0.32 trailing 72, 0.32 leading 94. The
   # five pills below take five of the six cheapest slots: 169 of a possible
   # 960 pill-frames have the bar in them, 7.04 s of 40.00. (room.py counts
   # the rig's rim-only equipment cloud; the dense analytic rebuild of the
   # drawn bar gives the same ranking and the same seconds for every slot
   # except 0.16 leading, which it makes 0.92 s rather than 0.75 s.)
   #
   # Pill by pill - slot, label length, lifter clearance, bar frames inside,
   # leader frames on the face, and what it beat:
   #
   #   pull   Bar close (9)   row 0.16 LEADING   lifter 138.4 px, bar 18/192
   #          frames, leader to hand_R on the face 0/192 (closest 5.0 px at
   #          t=0.08). The cheapest slot in the frame AND the roomiest in the
   #          family, because the lifter puts nothing in row 0.16 except the
   #          top of the left fist at the lockout (10 frames, f123-f132, t 5.125-5.500 s).
   #          Its price is the anchor: at nine characters only hand_R (5.0 px)
   #          and toe_R (0.1 px) keep their leader off the face, every
   #          shoulder-girdle joint runs straight down through it
   #          (support_TrapeziusUpper_L 192/192, neck 166, upper_arm_L 156,
   #          scapula_L 155, hand_L 92), and at twelve characters even hand_R
   #          goes on the face for 13 frames (0.00-0.33 s and 7.83-7.96 s,
   #          where the lifter is folded over the bar and the head is at its
   #          lowest). So this slot can only hold a nine- or ten-character
   #          label on hand_R, and `Bar close` is the library's own
   #          nine-character string for this cue (Clean and Press/pull,
   #          Barbell Power Clean/pull, Power Snatch/pull), anchored at the
   #          same wrist the Clean and Press uses.
   #   split  Punch and split (15)   row 0.16 TRAILING   lifter 33.6 px, bar
   #          50/192, leader to forearm_L 0/192 (closest 10.3 px at t=1.58).
   #          The dearest slot of the five in bar-time, taken because row 0.16
   #          trailing is clean for every midline and lifter-left anchor (the
   #          drawn head never passes u 0.610 and this pill starts at u 0.682)
   #          and because forearm_L is the elbow that opens 55.2 to 173.0
   #          degrees in this cue. 0.64 leading is four frames cheaper (46)
   #          but cannot take fifteen characters at all - the pill sits on the
   #          lifter for 38 frames at that length (-3.7 px) - and it costs
   #          hand_L 49 face-frames and support_TrapeziusUpper_L 25. At this
   #          length 0.16 trailing is clean for ten anchors; forearm_L has
   #          10.3 px, within half a pixel of the roomiest anchor in the slot
   #          (foot_L 10.8 px), and it is the elbow this cue is about - it
   #          opens 55.2 to 173.0 degrees here - where foot_L, toe_L (7.9 px)
   #          and hand_L (2.4 px) are not.
   #   catch  Catch it high (13)   row 0.80 LEADING   lifter 18.8 px, bar
   #          24/192, leader to chest 0/192 (the leader never spans the head
   #          rows at all). Second-cheapest slot in the frame. Thirteen
   #          characters is close to its limit: fifteen leaves 7.6 px and
   #          nineteen puts the pill on the lifter for 161 frames. chest is
   #          the anchor the library's Barbell Power Clean uses for its rack
   #          cue, and here it sits 27.5 px inside the silhouette over the
   #          racked bar.
   #   drive  Dip straight down (17)   row 0.80 TRAILING   lifter 16.8 px,
   #          bar 36/192, leader to patella_R 0/192 (never spans the head
   #          rows). The longest label in the entry goes here because this is
   #          the roomiest of the cheap slots at length: 61.6 px at nine
   #          characters and still positive at nineteen (5.6 px), where 0.64
   #          trailing is already -32.2 px. patella_R is Push Press/dip's own
   #          anchor and sits at v 0.669-0.720, just above this row, so the
   #          leader is short and nearly horizontal.
   #   setup  Flat back (9)   row 0.64 TRAILING   lifter 23.8 px, bar 41/192,
   #          leader to spine 0/192 (never spans the head rows). The last of
   #          the cheap slots, and the one that fits this cue best: spine runs
   #          v 0.512-0.630, so a row-0.64 pill points almost straight at it.
   #          Its ceiling is twelve characters (7.0 px); `Flat back` is the
   #          library's nine-character string, used twelve times including
   #          Clean and Press/start and Power Snatch/setup.
   #
   # WHAT WAS AVOIDED and why: rows 0.32 and 0.48 cost 61-94 bar-frames each
   # (2.54-3.92 s), 0.48 leading sits on the lifter past nine characters
   # (-9.5 px at twelve) and 0.32 leading is the worst slot in the frame at 94
   # frames. Row 0.64 leading is cheap (46) but unusable at the lengths this
   # copy needs. WHAT WAS TRADED: bar-seconds. Shortening a label buys nothing
   # against a 2.04 m bar - at eight of the ten slots the bar-frame count above
   # is identical at 9, 13, 15, 17 and 22 characters, and at the other two it
   # rises by two or three frames and then stops (0.48 trailing 61 at nine
   # characters and 64 from thirteen up, 0.64 trailing 41 and then 43) - so the
   # five pills below carry the nine-character counts, the labels are short for
   # the LIFTER
   # and for the leaders, and the bar crossing a pill is accepted at the
   # cheapest five slots the anchors allow.
   overrides={"setup": (0.68, "trailing"), "pull": (0.14, "leading"),
              "catch": (0.86, "leading"), "drive": (0.86, "trailing"),
              "split": (0.14, "trailing")},
   annotations=[
       ("setup", "Flat back", "spine"),
       ("pull", "Bar close", "hand_R"),
       ("catch", "Catch it high", "chest"),
       ("drive", "Dip straight down", "patella_R"),
       ("split", "Punch and split", "forearm_L"),
   ],
   cues={
       "setup": ("Start Position",
                 "You set up over a loaded bar on the floor with a flat back and your shoulders over the bar.",
                 "In the model the trunk starts 61.6 degrees forward - the most forward it gets in the whole clip - with the knees at 97.9 degrees, the hips at 57.2 and the pelvis at its lowest, 0.585 m. The shoulder joint sits 0.6 cm from the bar, almost directly over it, and the hands are 0.614 m apart against 0.392 m at the shoulders, 0.713 m in from each end of the 2.040 m bar. The plates rest on the floor with the bar axis at 0.225 m, 9.6 cm in front of the ankle joint. Nothing moves for the first eight frames and the bar leaves the floor between 0.333 and 0.375 s; the whole clean and jerk is one rep across 7.96 s, so there is no second chance to fix the position once it moves.",
                 "Rounding the lower back over the bar, or setting the hips high with the chest already down.",
                 "Set your feet about hip-width, take an overhand grip about a hand's width outside each shoulder, drop your hips until your back is flat with your shoulders over it, and brace."),
       "pull": ("The Pull",
                "Off the floor the bar comes up against your legs as your chest comes up and the hips follow.",
                "Measured against the skin, the bar runs about 1.0 cm off the shins and thighs for the whole first pull - 1.06 cm at the set-up, 1.00 to 1.03 cm by 0.88 s, 1.76 cm at 1.00 s, 0.97 to 1.16 cm to 1.25 s - and only brushes the shorts at the hip at 1.375 s. The chest comes up faster than the hips: the trunk opens 61.6 degrees to 38.6 while the pelvis rises only 0.585 to 0.703 m, and the elbows stay long the whole way, 155.6 to 158.2 degrees. Keeping the bar in keeps the load over your feet - it starts 9.6 cm in front of the ankle joint and comes IN to 6.5 cm before the turnover. Past the knee the knees re-bend 119.6 to 108.9 degrees while the hips keep opening, and then everything extends at once: the trunk swings from 18.9 degrees in front of vertical to 14.0 behind it, the hips reach their clip maximum of 169.5 and both heels come 6.1 cm off the floor, the biggest lift of the two heels together in the clip, with the elbows still at 150.9 to 162.7. Only as the bar turns over does it swing out, to 30.7 cm in front of the ankle at 2.000 s.",
                "Letting the bar swing out in front, or bending the arms to help it up.",
                "Push the floor away steadily, let the bar brush up your shins and thighs and keep your arms long until it passes your hips, then open the hips and knees hard and let the heels come up."),
       "catch": ("The Catch",
                "You catch the clean high, in a quarter squat, and stand straight up with it on your shoulders.",
                "The model catches the bar at 2.000 s and sinks only until 2.208 s. The knees bend to 97.8 degrees, which looks deep, but the honest measure is the thigh: it is still 43.0 degrees above horizontal, well above parallel, and the pelvis drops only to 0.701 m before standing to 0.909 m by 2.667 s. The bar settles 6.1 cm from its clean apex, 1.281 m to 1.220 m, onto a real rack: its surface sits 0.19 cm off the clavicular pectoral at the catch and 0.30 cm off the base of the throat at the rack hold. The elbows hang - the elbow joint stays 26.8 cm BELOW the shoulder and 5.6 cm in front of it through the rack - which is the jerk rack Catalyst Athletics describes, elbows down but in front of the bar. That is a coaching description, not a measurement.",
                "Riding the clean down into a deep front squat instead of standing it straight up.",
                "Meet the bar early with your elbows turning under it, let the knees give only a quarter of the way, and stand straight up into the rack."),
       "drive": ("Dip and Drive",
                 "You dip a short way with your trunk vertical, then drive the bar up with your legs.",
                 "The dip here is small and quick: the knees bend 30.8 degrees, 175.2 to 144.4, between 3.042 and 3.333 s, the hip joint actually OPENS a little, 162.7 to 166.0, and the pelvis drops just 3.9 cm with the bar following it 4.1 cm. The trunk stays vertical, 0.4 degrees behind vertical to 0.6 in front. The drive then runs 0.250 s, 3.333 to 3.583 s - beside the 259 plus or minus 24 ms propulsion phase the NSCA 2023 position statement collects for the jerk - and lifts the bar 24 cm on the legs alone, elbows still racked at 43 degrees, heels 4.8 cm off the floor. For scale, the only force-plate study to follow a jerk's dip, drive and catch measured 58 plus or minus 9 degrees of dip knee flexion in seven recreational weightlifters, six men and one woman, so this model dips about half as deep; nobody has changed dip depth and measured the result, so take it as what this model does.",
                 "Letting the chest tip forward in the dip, or dipping down into a half squat.",
                 "Bend only at the knees, keep your trunk upright and the bar on your shoulders, then reverse it hard and let your heels leave the floor."),
       "split": ("Split Receive",
                 "As the legs finish you punch under the bar and land in a split to receive it overhead.",
                 "The punch and the step happen inside a quarter of a second. Between 3.625 and 3.875 s the elbows open from 55.2 to 173.0 degrees while the pelvis drops 16.6 cm, 0.946 m to 0.780 m, under a bar that peaks at 1.940 m, and the fastest motion in the clip is the single frame that starts it, 13.24 cm of joint travel between 3.583 and 3.625 s. The feet land 60.4 cm apart front to back, the LEFT foot forward and the right back and up on its toe with the heel 8.2 cm off the floor, on a stance 22.0 cm wide, and the split is held 0.46 s. The front foot comes home first, by 4.750 s, then the back by 5.125 s - the recovery order Takano teaches and the StrengthLog guide lists, both coaching instructions with nothing measured behind them. Then it is a hold: the arms stay at 170 degrees or more for 1.67 s with the bar 45.5 cm above the head joint and 2.6 cm in front of it, over the body rather than out in front. This receive is the same one the Split Jerk trains on its own: both models hold the split at exactly 60.4 cm front to back with the LEFT foot forward, and peak within 2 mm of each other, 60.8 cm here against 61.0 there. What this lift puts in front of it is the clean from the floor.",
                 "Standing under the bar to press it out, or moving the feet before the legs have finished.",
                 "Punch your arms straight as you jump the feet apart, land with the front heel flat and the back foot on its toe with that knee bent, then bring the front foot back first."),
   },
   # ------------------------------------------------------------ the rows
   # Settled for the whole family before any copy was written (the round's
   # rows stage, section 3c) and used here exactly as written there. Rows
   # follow the paint, re-counted off tiers_jerk.json: 22 painted meshes, 11
   # bright, 11 dim, nothing faint and nothing one-sided. Bright, so primary:
   # the four quadriceps, the three hamstrings, the three glutes as ONE
   # Gluteus Maximus row (the rig lights them together and the owner
   # confirmed on 2026-10-30 that the paint is not split, so the copy says
   # glutes and no list names the medius) and the anterior deltoid. Dim, so
   # secondary: the three trapezius parts with the rhomboid major inside them
   # as one Trapezius row, the three triceps heads, both biceps heads, the
   # lateral deltoid and the erector spinae.
   # This is the only lift in the family that pulls from the floor AND jerks,
   # so its pull rows are the cleans' and its overhead rows are the jerks'.
   # Gluteus Maximus 0.70, Trapezius 0.70, Quadriceps 0.62, Erector Spinae
   # 0.55, Hamstrings 0.50 and Biceps Brachii 0.30 are carried unchanged from
   # the library's Clean and Press, which holds all six at those values,
   # because the pull is the same movement, and all six are carried unchanged,
   # RANK INCLUDED: the parent already ranks Gluteus Maximus, Quadriceps and
   # Hamstrings primary and Trapezius, Erector Spinae and Biceps Brachii
   # secondary (SampleData.swift cleanAndPressContent, read 2026-10-30), which
   # is what this model's paint lights too, so the README's rank-change rule
   # never comes into it here. rows.md section 3c calls Hamstrings a rank
   # change and should be corrected. Trapezius 0.70 is carried and NOT
   # sourced: Nagao and Ishii 2021 is the one %MVC-normalised trapezius
   # measurement in a lift this entry contains - upper trapezius in the power
   # clean, 20 trained men, rising with load in the first pull and the
   # transition and falling with load in the second pull - and it publishes
   # no percentage and stops at the catch of the clean.
   # Triceps Brachii 0.50 is an ESTIMATE, between the Kettlebell Snatch's
   # 0.40 and the Clean and Press's 0.55, and 0.50 is an existing library
   # value (Seated Dumbbell Press, Arnold Press, Machine Shoulder Press).
   # Lateral Deltoid 0.45 is carried from the Overhead Carry through the
   # three snatches - the library's one loaded overhead HOLD, not a press.
   # Anterior Deltoid is RE-ESTIMATED from the cleans' 0.30 up to the snatch
   # round's 0.40, the value for a load the legs throw and the arm only
   # locks, and explicitly NOT the Clean and Press's 0.84: measured here, 24.3
   # of the 63.4 cm from the dip bottom to the lockout comes off the drive
   # with the elbows still at 43 degrees.
   # THE BOUNDARY ON ALL OF IT: there is no PEER-REVIEWED EMG study of any
   # jerk - the 2023 NSCA position statement's 323 references cite none, and
   # the one recording that exists, Liu 2021, is an unreviewed preprint on
   # track and field athletes with no stated normalisation - so no fraction here
   # is ranked on jerk activation and no cue claims a muscle works hardest in
   # any phase of the jerk. The unpainted serratus anterior, rotator cuff and
   # latissimus dorsi get no rows and are named among the stabilisers, as are
   # the unpainted forearms and calves - open points for the owner, since the
   # lift grips a loaded bar for all 7.96 s and the heels lift 6.1 cm in the
   # second pull, 4.7 cm in the jerk drive and 9.4 cm on the back foot in
   # the recovery, out of the split, while the sibling Dumbbell Clean and Press paints both groups dim
   # at a smaller heel lift. Closing either gap would add a Forearms 0.35 or
   # a Gastrocnemius 0.30 row.
   activation=[("Gluteus Maximus", P, HI, 0.70), ("Trapezius", S, HI, 0.70),
               ("Quadriceps", P, MOD, 0.62), ("Erector Spinae", S, MOD, 0.55),
               ("Hamstrings", P, MOD, 0.50), ("Triceps Brachii", S, MOD, 0.50),
               ("Lateral Deltoid", S, MOD, 0.45), ("Anterior Deltoid", P, MOD, 0.40),
               ("Biceps Brachii", S, LOW, 0.30)],
   stabilisers=["core", "rhomboids", "serratus anterior", "rotator cuff",
                "latissimus dorsi", "forearms", "calves"],
   comparison=("PRESSING THE JERK OUT", "Legs drive it, arms lock", "Arms press it off the shoulders",
               "The legs put the bar up: in the model the bar rises 24 cm with the elbows still racked at 43 degrees, and they only open once it is already moving.",
               "Pressing it off the shoulders caps the jerk at what your shoulders can press; here the elbows do not start to open until the bar is 24 cm up."),
   # Glows follow the paint, one plain glow() per row of it and no shared
   # helper: one glow at the hip for the glutes, one down EACH thigh covering
   # the bright quadriceps and hamstrings together (a single glow cannot tell
   # the two rows apart, and the paint is bright on both legs), one on each
   # shoulder arc for the bright anterior deltoid, then the dim upper back,
   # the dim erector spinae and the dim arm (triceps and biceps) as SOFT.
   # Both sides are lit because tiers_jerk.json finds nothing one-sided on
   # this model; whether this framing is a front or a rear three-quarter is
   # the open question THE VIEW records in the module header, and because the
   # glows are on the midline and on both thighs and both shoulders, nothing
   # here rests on the answer.
   glows=[glow("Barbell Clean and Jerk", ["pelvis", "thigh_L"], A, 0.55, rx=0.11, ry=0.07),
          glow("Barbell Clean and Jerk", ["thigh_L", "patella_L"], A, 0.50, rx=0.08, ry=0.08),
          glow("Barbell Clean and Jerk", ["thigh_R", "patella_R"], A, 0.50, rx=0.08, ry=0.08),
          glow("Barbell Clean and Jerk", ["deltoid_arc_clavicle_2_L", "deltoid_arc_scapula_2_L"], A, 0.50, rx=0.08, ry=0.06),
          glow("Barbell Clean and Jerk", ["deltoid_arc_clavicle_2_R", "deltoid_arc_scapula_2_R"], A, 0.50, rx=0.08, ry=0.06),
          glow("Barbell Clean and Jerk", ["attachment_TrapeziusUpper_L", "attachment_TrapeziusUpper_R"], SOFT, 0.30, rx=0.12, ry=0.06),
          glow("Barbell Clean and Jerk", ["spine"], SOFT, 0.28, rx=0.07, ry=0.07, dy=-0.02),
          glow("Barbell Clean and Jerk", ["forearm_L"], SOFT, 0.28, rx=0.06, ry=0.08)])

SETUP["Barbell Clean and Jerk"] = [
    "Learn the clean and the jerk on their own, with an empty bar, before you put them together under load.",
    "Load a bar on the floor and stand with your feet about hip-width apart, the bar over the middle of your feet.",
    "Take an overhand grip a hand's width outside each shoulder, then drop your hips until your back is flat over the bar.",
    "Brace your trunk and take the slack out of the bar before the first pull.",
    "Between reps, bring the bar down to the shoulders and then to the floor under control with a light bar; with weight on it, drop it from overhead and set your back again over the bar.",
]


# ==================================================================== split jerk

# --------------------------------------------------------- split jerk
#
# Split Jerk (Shoulder/SplitJerk), yaw -0.8, zoom 0.65, 192 frames at 24 fps
# (7.958 s), 382 x 655. TWO identical reps of exactly 96 frames = 4.000 s
# each; the clip loops (frame 191 matches frame 0 to 0.0003 mm) and it OPENS
# AND CLOSES IN THE RACK - the bar is already on the shoulders at t=0, there
# is no clean anywhere in this clip and the plates never come within 1.198 m
# of the floor. Every time below is rep 1; add 4.000 s for rep 2. Both arms
# are one rigid mirrored unit (elbow_L and elbow_R agree to 0.001 degrees on
# every frame, the hands mirror to 0.8 micrometres), so no cue here can tell
# a working arm from a free one; the whole left/right asymmetry is below the
# hip. The split always puts the LEFT foot forward, in both reps, so the lift
# never shows the other stance.
#
# The copy quotes only measured figures and sourced coaching, kept apart:
# THERE IS NO EMG STUDY OF ANY JERK, so nothing here claims a muscle level,
# a ranking of one muscle against another, or an outcome. The coaching
# citations are Catalyst Athletics' Split Jerk / Push Jerk pages and
# Everett's The Jerk Part 1 and Part 2 (technique teaching, no measurement);
# the measured literature cited is Lake, Lauder & Dyson 2006 (seven
# recreational lifters, six male and one female, at ~80% 1RM: 58 +/- 9
# degrees of dip knee flexion, hip drop 11 +/- 2% of body height) and
# Soriano et al. 2024, Sports Biomechanics (sixteen resistance-trained
# participants, no skilled weightlifters: system-COM dip 0.20 +/- 0.05 m and
# no kinetic difference at all between push press, push jerk and split jerk).
# Deliberately NOT used: any %MVIC for anything, any front-versus-back weight
# split in the receive (nobody has measured it - Lake 2006 put only the front
# foot on its own plate), any split stance dimension from the literature,
# any claim that a deeper or shallower dip drives more, and CrossFit's
# unsourced 30% push-jerk-over-push-press figure.
ex(name="Split Jerk", var="splitJerk",
   # LABEL GEOMETRY. Five pills, five slots, measured at the pill the app DRAWS
   # (half-height 0.025 in v, width (24 + 5.6 * len)/382, pinned 0.035 from the
   # leading or trailing edge) against the 655-row SKINNED silhouette, the whole
   # equipment point cloud and the HEAD's own silhouette, over all 192 frames
   # (room.py, lead.py, sj_gap16.py and sj_win22.py in the round folder). Rows
   # below are the DRAWN rows; `overrides` carries the raw 0.14-0.86 values.
   #
   #   rack    0.64 trailing, 15 chars - lifter 33.2 px, load 95.2 px away and
   #           inside 0 of 192 frames, leader to upper_arm_L on the face 0/192
   #           (it never spans the head's v rows at all)
   #   dip     0.80 trailing, 17 chars - lifter 20.7 px, load 200.0 px away and
   #           inside 0/192, leader to patella_L on the face 0/192 (never spans
   #           the head rows)
   #   drive   0.80 leading, 10 chars - lifter 29.9 px, load 196.4 px away and
   #           inside 0/192, leader to foot_L on the face 0/192 (never spans
   #           the head rows)
   #   split   0.64 leading, 12 chars - lifter 22.8 px, load 91.6 px away and
   #           inside 0/192, leader to foot_R on the face 0/192 (never spans
   #           the head rows)
   #   lockout 0.16 leading, 22 chars - NO part of the lifter enters that band
   #           at any frame or any label length, and inside the pill's own u
   #           span (0.0350-0.4203) the gap from its bottom edge, v 0.185, down
   #           to the lifter's top pixel is 17.3 px at its worst, f59
   #           (t=2.458 s). THE LOAD IS INSIDE THIS PILL in 40 of 192 frames
   #           (1.667 s), 1.917-2.708 s and 5.917-6.708 s. Leader to hand_R on
   #           the face 0/192, closest 30.1 px at t=3.250 s.
   #
   # Why those five and not others, in numbers:
   # - The bar never drops below v 0.475, so rows 0.64 and 0.80 are free of it
   #   for the whole clip on both sides - nearest approach 91.6 / 95.2 / 196.4 /
   #   200.0 px - and all four of those slots are used. Row 0.32 is the opposite:
   #   the bar is inside a leading pill there in 186 of 192 frames and a trailing
   #   one in 138, so row 0.32 stays empty.
   # - The fifth pill has only two candidates. Row 0.16 leading takes 40 frames
   #   of bar and clears the lifter at every label length; row 0.48 trailing
   #   takes 72 frames of bar and, at the 22 characters this label needs, sits
   #   ON the lifter in 118 frames (-10.3 px) - it caps at 19 characters (6.5 px)
   #   and even there hand_R from it is on the face in 88 of 192 frames. Row 0.16
   #   trailing is the same height but 96 frames of bar. So 40 < 72 < 96 and only
   #   one of the three takes the label at all. WHAT THAT TRADES: the bar crosses
   #   the lockout pill for 1.667 s, and it does so exactly while the bar is
   #   overhead (lockout at 2.500 s), i.e. while that cue is the one being read.
   #   Nothing can be done about it - the bar is 298.8-300.0 px wide on EVERY
   #   frame of 382 and leaves 26.2-54.0 px of gutter on the leading edge
   #   and 29.2-55.8 px on the trailing one, 82.0-83.2 px in all, so no horizontal
   #   escape exists at any height it occupies, and shortening the label changes
   #   the 40 frames not at all.
   # - Inside rows 0.64 and 0.80 the trailing slots are the roomier pair (61.2
   #   and 59.9 px at 10 characters against 34.0 and 29.9 leading), so the two
   #   longer labels go trailing and the two shortest go leading. The long ones
   #   could not go the other way: at 15 characters row 0.64 leading leaves
   #   6.0 px and row 0.80 leading 1.9 px, and at 17 both are on the lifter
   #   (-5.2 px / 20 frames and -9.3 px / 124 frames).
   # - Anchors. hand_L is unusable from every leading slot (94, 104, 96 and 86
   #   of 192 frames on the face from rows 0.16, 0.48, 0.64 and 0.80 leading at
   #   twelve characters, and 16 even from the bar row 0.32, which is empty
   #   anyway) and clears a trailing one by only 2.4-2.5 px, and hand_R is
   #   on the face from 0.64 trailing in 78 frames at 15 characters. Of the four
   #   body anchors chosen, patella_L (v 0.680-0.703), foot_L (0.808-0.833) and
   #   foot_R (0.772-0.813) are safe by construction: all three sit well below
   #   the head's own drawn silhouette, whose lowest row over the clip is
   #   v 0.400, so a leader from a pill at row 0.64 or 0.80 cannot enter it.
   #   upper_arm_L is NOT covered by that argument - at v 0.385-0.440 it
   #   overlaps the head's union band, v 0.285-0.400 - and it is clear for a
   #   measured per-frame reason instead: on every one of the 192 frames the
   #   joint sits 0.0343-0.0414 in v, 22-27 px, BELOW the head's own lowest
   #   drawn row on that frame, so the leader never spans a row the head
   #   occupies and lead.py reports it as never spanning the head rows at all.
   #   That is a property of this clip's poses, not of the slot, so it has to
   #   be re-measured if the animation or the framing changes. hand_R from
   #   row 0.16 leading is the roomiest arm leader in the frame (36.6 px at 12
   #   characters, 30.1 px at the 22 this label uses), which is why the lockout
   #   cue is the one that gets an arm.
   # - Every one of the 41 joints joints.json probes for this lift projects
   #   INSIDE the skinned silhouette on all 192 frames, so no dot can be put in
   #   open space; the four body anchors are also the deeper ones (patella_L
   #   9.1 px from the drawn edge at its closest, foot_L well inside), away from
   #   hand_R's 1.3 px.
   #
   # Three labels are the library's own strings for the same cue: `Dip straight
   # down` (Push Press/dip, Dumbbell Push Press/dip), `Legs first` (Dumbbell
   # Thruster/drive, Kettlebell Thruster/drive) and `Lock out over the head`
   # (Push Press/lockout). `Elbows in front` is the Barbell Thruster/rack string
   # and happens to be exactly right for a jerk rack, where the elbows are DOWN
   # and in front of the bar rather than up as in a clean rack. `Back heel up`
   # is new - the library receives no load in a split, so there was nothing to
   # reuse.
   overrides={"rack": (0.68, "trailing"), "dip": (0.86, "trailing"),
              "drive": (0.86, "leading"), "split": (0.68, "leading"),
              "lockout": (0.14, "leading")},
   annotations=[
       ("rack", "Elbows in front", "upper_arm_L"),
       ("dip", "Dip straight down", "patella_L"),
       ("drive", "Legs first", "foot_L"),
       ("split", "Back heel up", "foot_R"),
       ("lockout", "Lock out over the head", "hand_R"),
   ],
   cues={
       "rack": ("Front Rack",
                "The bar starts racked on the front of your shoulders, your hands deep under it and your elbows down.",
                "In the model the bar sits at 1.465 m, 3.0 cm above the shoulder joint, with the elbows folded to 43.0 degrees. At the rack the bar is 7.3 cm above the wrist and 6.6 cm behind it, so the hand is under and in front of the bar rather than holding it up, and the grip is 0.614 m against 0.392 m between the shoulder joints - clean width. Catalyst Athletics teaches exactly this: the bar between the throat and the top of the shoulders, the hands as deep under it as possible, the elbows down but in front of the bar. Everett gives the reason - a bar held mainly in the arms keeps descending after the legs have started to extend again - which is coaching, not a measured outcome. The clip holds the rack 0.708 s a rep, the longest still pose in it. This is the jerk half of a clean and jerk, taken from a rack rather than cleaned: there is no pull from the floor anywhere in the clip and the plates never come within 1.198 m of it.",
                "Carrying the bar on the hands with the elbows driven high, as in a clean rack.",
                "Set the bar across the front of your shoulders, push your hands as deep under it as they will go, and let your elbows hang down in front of the bar."),
       "dip": ("Dip",
               "You bend at the knees and drop a short way straight down, with your trunk staying upright.",
               "In the model this is a knee-only dip. Over 0.250 to 0.583 s the pelvis drops 3.94 cm, 0.909 m to 0.870 m, and the knees go 175.2 degrees to 144.4, about 31 degrees, in 0.33 s. The trunk moves 0.99 degrees in all, the pelvis travels 0.00 cm front to back while the knees come 8.72 cm forward, and the hip angle actually OPENS, 162.7 to 166.0 degrees, so nothing hinges. Both heels stay flat and the elbows do not move: 43.1 degrees to 43.2. This dip is shallower than the coaching standard and than every measured value: Catalyst asks for roughly 10% of your height, Lake 2006 measured 58 plus or minus 9 degrees of dip knee flexion in seven recreational lifters against this model's 31, and Soriano 2024 a centre-of-mass dip of 0.20 m in sixteen resistance-trained participants, none of them a skilled weightlifter. Nobody has shown an optimum, so take the shape from the model and the depth from your own lift.",
               "Tipping the chest forward or sitting the hips back, so the bar rolls off the shoulders.",
               "Keep your trunk upright and your heels flat, bend only at the knees, and sink a few inches - about a third of the way to a quarter squat."),
       "drive": ("Leg Drive",
                 "Out of the bottom you drive the floor away with your legs, and your arms do nothing yet.",
                 "The drive takes 0.250 s in the model. The knees go 144.4 degrees back to 172, the pelvis 0.870 m to 0.955 m - 4.6 cm ABOVE its racked height - and the bar 1.423 m to 1.653 m, a rise of 23.0 cm, while the elbows are still at 41.7 degrees. Both heels leave the floor together and reach 4.77 cm up with both toes still down. The arms only open after all of that: the elbow jumps 9.25 degrees in the single frame at 0.875 s and runs 43 to 173 degrees in 0.333 s. From 0.000 s to 0.833 s it never leaves 39.4-43.2 degrees, so there is no press during the drive to describe. Everett warns that pressing early stops leg and hip power reaching the bar and leaves the work to the weaker arms - technique teaching, not a measured effect.",
                 "Pressing with the arms before the legs have finished opening.",
                 "Push the floor away hard with your legs and leave your arms where they are until the bar is already moving up."),
       "split": ("The Split",
                 "As the bar leaves your shoulders you split your feet and drop under it.",
                 "In the model the feet split 61.0 cm front to back in 0.333 s, measured at the one frame both are at their widest, and widen sideways by only 7.3 cm. The pelvis drops 17.52 cm, 0.955 m to 0.780 m, while the hands go 25.9 cm up and 17.1 cm back. In the hold the front foot is flat and the rear foot stands on the ball of the foot with its heel 8.20 cm up, and that heel stays up for 1.83 s a rep. The rear knee is the more bent of the two, 110.5 degrees against 136.5 at the front - 26.0 degrees apart. Everett teaches that the back knee must stay bent, which stops it being driven into hyperextension as the weight arrives; that is coaching, and nothing in the literature measures a split stance or how the weight divides between the two feet.",
                 "Landing with both feet flat, or moving the feet before the legs have finished driving.",
                 "Punch your arms up as the bar passes your head, jump one foot forward and the other back, and land with the front foot flat, the back heel up and the back knee bent."),
       "lockout": ("Lockout",
                   "You catch the bar with your arms locked overhead, then stand the split up under it.",
                   "The bar is not finished at the catch. In the model it is at 1.927 m when the split lands and rises a further 12.98 cm to its peak 2.057 m, purely from standing up - 59.26 cm above its racked height, 45.50 cm above the head joint and 2.60 cm in front of it, and 1.49 cm in front of the mid-stance point, so the load finishes over the base. The feet come back one at a time, the front one over 1.625-2.042 s and the rear one over 2.083-2.458 s, 0.42 s apart; Takano and the StrengthLog guide both teach the front foot first, which is coaching with nothing measured behind it. It never locks out straight: the elbows stop at 173.0 degrees, 7.0 degrees short, and the knees at 175.2 and 175.3, which is where they sit standing in the rack too. The lockout is held for 4 frames, 2.500 to 2.625 s.",
                   "Finishing with the bar out in front of your head, or standing both feet up at once.",
                   "Punch the bar up until your elbows lock, bring the front foot back first and then the rear, and stand tall with the bar over your head."),
   },
   # Rows, stabilisers and fractions exactly as the row stage settled them
   # (rows.md 3d and 8), re-read from tiers_jerk.json: 5 bright, 11 dim,
   # nothing faint, nothing one-sided - the leanest paint of the five, and
   # the only one of them with no hamstrings, no erector spinae and no biceps
   # anywhere. Bright, so primary: the four quadriceps as one Quadriceps row
   # and the anterior deltoid. Dim, so secondary: the three glutes as ONE
   # Gluteus Maximus row (the rig lights them together and the owner
   # confirmed on 2026-10-30 that the paint is not split, so the copy says
   # glutes and no list names the medius), the three triceps heads, the
   # lateral deltoid, and the three trapezius parts as one Trapezius row with
   # the dim rhomboid major inside it.
   # Quadriceps 0.62 is carried from the library's Clean and Press, the
   # fraction this whole family shares, and NOT the thrusters' 0.86: a
   # thruster squats, this dips 31 degrees at the knee and receives at
   # 136.5 / 110.5. Gluteus Maximus 0.50 is carried from the Push Jerk
   # unchanged - the paint differs between the two models, so under the
   # README's rank-change rule the fraction carries and only the rank moves;
   # the Push Jerk's 0.50 is itself an estimate from the Overhead Squat.
   # Triceps Brachii 0.50 is an ESTIMATE, as on the Barbell Clean and Jerk:
   # below the presses' 0.55, above the Kettlebell Snatch's 0.40, on the
   # measured punch-under and the loaded lockout. Lateral Deltoid 0.45 is
   # carried from the Overhead Carry via the snatches. Anterior Deltoid 0.40
   # is the snatch round's re-estimate for a load the legs throw and the arm
   # only locks, kept as on the Barbell Clean and Jerk - the model supports
   # the direction (the bar rises 23.0 cm in the drive with the elbow moving
   # 1.5 degrees) but not the number. Trapezius 0.36 is carried from the Push
   # Press, the library's nearest dip-and-drive overhead lift, not from the
   # cleans' 0.70: there is no pull here and nothing is shrugged.
   # NONE of these six is sourced to a measurement of a jerk, because none
   # exists: there is no peer-reviewed EMG study of any jerk anywhere (the one
   # recording, Liu 2021, is an unreviewed preprint on track and field
   # athletes with no stated normalisation), and the only
   # %MVC-normalised EMG in any lift this family contains is Nagao & Ishii
   # 2021's upper trapezius in a power clean, which stops at the catch. The
   # unpainted groups get no rows and are named among the stabilisers
   # instead, erector spinae, hamstrings and biceps brachii among them - the
   # three pull rows this model's paint removes. Anterior Deltoid 0.40 is the
   # owner's decision of 2026-10-30 (rows.md OPEN POINT 1, closed in
   # owner_decisions.md with the Push Press's 0.80 named and declined), not an
   # assumption of this copy. The open points the owner still has to settle
   # (rows.md 10) are left open here: nothing in the copy above assumes
   # the dim glutes are right against the Push Jerk's bright ones, or claims
   # anything about the unpainted calves, although both heels rise 4.77 cm in
   # the drive and the rear one is 8.20 cm up for 1.83 s a rep.
   activation=[("Quadriceps", P, MOD, 0.62), ("Gluteus Maximus", S, MOD, 0.50),
               ("Triceps Brachii", S, MOD, 0.50), ("Lateral Deltoid", S, MOD, 0.45),
               ("Anterior Deltoid", P, MOD, 0.40), ("Trapezius", S, LOW, 0.36)],
   stabilisers=["core", "rhomboids", "rotator cuff", "erector spinae",
                "hamstrings", "biceps brachii", "forearms", "calves"],
   # The badge names a split-specific fault, so it does not collide with the
   # Barbell Thruster's PRESSING EARLY or the Power Snatch's PRESSING IT UP,
   # which the sibling jerks may want. The note states the model's ORDER,
   # which is measured, and attributes the cost to Takano, which is coaching.
   comparison=("MOVING THE FEET EARLY", "Drive first, then the feet",
               "Feet split before the drive ends",
               "In the model the feet stay put until the drive is over: the knees are back to 172 degrees and both heels 4.77 cm up at 0.833 s, and only then do the feet leave the floor, the ankle gap opening from 0.238 m to 0.680 m by 1.083 s.",
               "Takano teaches that moving the feet before the drive is complete cuts the force that reaches the bar - a coaching instruction, not a measured outcome, since nothing in the literature times the feet against the drive."),
   # Four glows, following spec_500_thruster.py's thruster_glows shape: the
   # near (lifter's left) quadriceps and anterior deltoid full, the far ones
   # soft. The lifter's left is the nearer side to this camera, measured -
   # at yaw -0.8 scapula_L sits about 20.4 cm nearer than scapula_R - and it
   # reads on the VIEWER'S RIGHT (hand_L sweeps u 0.522-0.612, hand_R
   # u 0.301-0.390). A / SOFT here is depth only: the paint is bright on BOTH
   # quadriceps and the anterior deltoid is a single unsided mesh, and both
   # arms are one mirrored unit, so nothing one-sided is being claimed. The
   # dim glutes, triceps, trapezius and lateral deltoid get no glow, following
   # the thrusters' own set, which glows only bright paint - a reason that does
   # not depend on the view. Whether this framing is a front or a rear
   # three-quarter is the one question the measure stage left open
   # (measure_SplitJerk.md section 0), and no cue above and no glow here rests
   # on the answer.
   glows=[glow("Split Jerk", ["thigh_L", "patella_L"], A, 0.55, 0.05, 0.07, 0.0, 0.0),
          glow("Split Jerk", ["thigh_R", "patella_R"], SOFT, 0.32, 0.045, 0.06, 0.0, 0.0),
          glow("Split Jerk", ["deltoid_arc_clavicle_2_L"], A, 0.45, 0.035, 0.035, 0.0, 0.0),
          glow("Split Jerk", ["deltoid_arc_clavicle_2_R"], SOFT, 0.30, 0.035, 0.035, 0.0, 0.0)])

SETUP["Split Jerk"] = [
    "Learn the footwork with an empty bar before you put any weight on it.",
    "Set the bar in a rack at shoulder height and take an overhand grip a hand's width outside your shoulders.",
    "Bring it onto the front of your shoulders, hands as deep under the bar as they go and elbows down and a little in front of it.",
    "Step back and set your feet about hip-width, weight over the whole foot, then brace your trunk.",
    "Pick which foot steps forward and keep it the same foot for the whole set.",
]


# ===================================================================== push jerk

# ------------------------------------------------------------------ push jerk
#
# Shoulder/PushJerk.usdc, framing yaw -0.8 rad, zoom 0.659, offset
# [-0.027, -0.084, 0.028], viewport 382 x 655. 192 frames at 24 fps = 7.958 s,
# seen from a three-quarter angle off the lifter's left - whether that is a
# front or a rear three-quarter is the open question THE VIEW records in the
# module header, and nothing below depends on it - so the lifter's LEFT side
# draws on the viewer's right (the trailing edge) and their right side on the
# leading edge.
#
# TWO identical reps on an exact 4.000 s loop: frame i and frame i+96 agree to
# 0.000478 mm on all 26 measured joints, and frame 191 matches frame 0 to
# 0.0003 mm, so every figure below is from rep 1 and repeats at t + 4.000 s.
# (The three complete lifts of this family - both Clean and Presses and the
# Barbell Clean and Jerk - show ONE rep instead; the Split Jerk shows two, like
# this one.)
#
# What a writer working from the name alone gets wrong, and what the copy
# therefore does NOT say:
#  - There is no clean and the bar never touches the floor. The clip opens with
#    the bar already racked at 1.4645 m and its lowest drawn point in 192
#    frames is 1.1984 m, at the bottom of the DIP. No set-up step and no cue
#    mentions pulling from the floor.
#  - The front rack has LOW elbows: upper arm 21.5 degrees from hanging, the
#    elbow 26.79 cm BELOW the shoulder joint and closed to 43.0 degrees. The
#    library's `Elbows up in the rack` (Barbell Power Clean, Hang Clean) is
#    therefore NOT reused and no cue says elbows high. The cue is titled
#    Front Rack, as the Split Jerk's is - these are the two lifts of the five
#    that open already racked - and it carries the Split Jerk's label too, the
#    Barbell Thruster's `Elbows in front` (15), on this lift's forearm_R, which
#    is the anchor that library string already uses.
#  - The receiving dip is more than twice as deep as the drive dip: knee 144.40
#    degrees at the dip against 121.83 at the catch, pelvis -3.94 cm against
#    -9.80 cm. The deepest moment of the clip is the catch, at t 1.083.
#  - Nothing hinges and nothing leans. hip_L spans 10.01 degrees, hip_R 8.16,
#    trunk 2.99 in all (-1.42 to +1.57) and pelvis.Z 2.00 cm over the whole
#    clip. The dip, the drive and the catch are knee-and-ankle, so no cue
#    claims hip drive, a hinge or a chest-up correction.
#  - The drive stops short: the knee reaches 172.07/172.34 degrees, 3.2 short
#    of its own clip maximum 175.40 and 3.1 short of the rack's 175.23. Nothing
#    says drive to full extension or stand all the way up before pressing.
#  - It does NOT split. foot_L.Z - foot_R.Z never exceeds 0.123 mm on any
#    frame. It lands 8 cm WIDER than the stance it racks in (ankle gap 0.220 m
#    in the rack, 0.238 m at take-off, 0.300 m on landing) and both
#    feet leave the floor for 0.250 s a rep. That is the one thing separating
#    this lift from the Split Jerk and the Barbell Clean and Jerk, which both
#    receive with the left foot 0.61 m forward.
#  - After the lockout each foot re-sets separately, left then right, and
#    knee_L and knee_R diverge by up to 25.52 degrees (t 2.208 and 2.625) while
#    the whole body sways 4.95 cm sideways. No cue quotes a knee angle after
#    t 2.000, and the comparison notes are taken from the lift, not the hold.
#  - THERE IS NO PEER-REVIEWED EMG STUDY OF ANY JERK anywhere (NSCA 2023
#    contains none;
#    Liu 2021 is an unreviewed preprint on track and field athletes). Every
#    muscle statement in this entry is paint plus mechanics and says so; no cue
#    ranks one muscle against another and no cue carries a percentage of
#    maximum.
#
# Label plan. Rows are written on the raw 0.14-0.86 scale and spec_1029.py
# renders them at 0.16 / 0.32 / 0.48 / 0.64 / 0.80; every clearance below is
# measured at the DRAWN row, on the pill the app draws (half-height 0.025 in v,
# width (24 + 5.6 * len) / 382, pinned 0.035 from the leading or trailing
# edge), against the SKINNED 655-row silhouette and against the DENSE bar
# cloud. The dense cloud matters: `eqpts` samples only each cylinder's two end
# rings, leaving a 147.0 px hole along the shaft at the lockout, so chk.py and
# slots2.py can call a pill clear while the drawn bar runs through it. Every
# load figure here is re-measured from PushJerk_BARDENSE.npz (29,520 points a
# frame; largest u gap 4.01 px) with the round folder's pj_dense_slots.py, and it agrees
# with room.py's counts at these five slots exactly.
#
# The frame: the bar crosses 303-306 px of the 382 on every frame and never
# drops below v 0.4794, so rows 0.64 and 0.80 are free of it on both sides - the
# only four of the ten slots clear of BOTH the lifter and the bar at every
# frame - while row 0.32 holds the bar in 184 of 192 frames leading and 96
# trailing and is left EMPTY. The format needs five annotations, so the fifth
# pill must accept a bar crossing.
#
#  rack    row 0.16 leading, 15 ch, pill u 0.0350-0.3177. Lifter: the
#          silhouette never enters this band on ANY frame - the band is pixel
#          rows 88-121 and the lifter's highest row in the whole clip is 125 -
#          so the clearance is unbounded at any label length. Load: the dense
#          bar is inside on 68/192 frames = 2.833 s at every label length from
#          10 to 21 characters, and only in t 1.625-3.000 and 5.625-7.000, i.e.
#          the overhead lockout; the pill is clear of the bar through the entire
#          rack hold, dip, drive, press-under and catch (t 0.000-1.583) and
#          through the whole lowering and re-rack (3.042-5.583). Leader to
#          forearm_R: 0/192 frames on the face, closest 22.1 px at t 2.75 -
#          2.7 px better than the 21-character label the first draft put here,
#          which is one reason this slot now carries the library's fifteen.
#          WHY this slot: it is the fifth pill, so it pays the bar crossing,
#          and it pays it where this cue is never being read. The alternative
#          the frame offers is 0.48 trailing. At 21 characters it was not
#          placeable at all (-8.1 px of lifter, 68 overlap frames; it caps at
#          19 ch and 3.1 px). At FIFTEEN it becomes placeable, 25.5 px, and it
#          is even eight bar-frames cheaper (60/192) - but it loses on the
#          other two tests: those 60 bar frames fall in t 0.000-0.667,
#          3.458-4.667 and 7.458-7.958, the rack hold and the dip, exactly when
#          a start-position cue is on screen, and its forearm_R leader lies ON
#          THE FACE for 14 frames (t 1.25-1.50 and 5.25-5.50). The other
#          candidates are worse in bar time: 0.16 trailing 110/192, 0.32
#          trailing 96/192, 0.32 leading 184/192.
#  dip     row 0.64 trailing, 17 ch, pill u 0.6530-0.9650. Lifter 21.6 px. Load
#          0/192 frames, nearest 91.8 px. Leader to patella_L never spans the
#          head rows at all, so 0/192 on the face by construction.
#          WHY: of the four slots that clear the bar at every frame, the two
#          trailing ones take the long labels (<= 20 ch at row 0.64 and <= 21
#          at 0.80, against <= 14 on either leading slot), and after the
#          21-character rack label went to row 0.16 this 17-character label is
#          the longer of the two that must sit trailing. patella_L also lives
#          just under this row band (v 0.688-0.720), so the leader drops
#          only 31-52 px in v.
#  drive   row 0.80 leading, 10 ch, pill u 0.0350-0.2444. Lifter 25.2 px. Load
#          0/192 frames, nearest 193.6 px - the biggest load clearance of any
#          leading slot. Leader to foot_R never spans the head rows.
#          WHY: the two leading slots on the clear rows cap at 14 characters
#          (at 15 ch the pill overlaps the lifter on 4 frames at row 0.64 and
#          80 frames at row 0.80), so they take the two short labels; this one
#          gets row 0.80 because the foot anchor is in the same band
#          (foot_R v 0.808-0.822) and because 193.6 px beats row 0.64's 88.8.
#  under   row 0.64 leading, 11 ch, pill u 0.0350-0.2591. Lifter 20.3 px. Load
#          0/192 frames, nearest 88.8 px. Leader to hand_R: 0/192 on the face,
#          closest 35.0 px at t 2.21.
#          WHY the anchor: hand_L from this same slot is ON THE FACE for
#          110/192 frames (runs t 0.92-3.17 and 4.92-7.17) as the wrist climbs
#          past the skull, so the press-under cue tracks the RIGHT wrist. Of
#          the 41 probed joints only `head` is ever inside the head
#          silhouette, but a leader can still cross it, which is what this
#          round exists to catch.
#  lockout row 0.80 trailing, 19 ch, pill u 0.6236-0.9650. Lifter 16.0 px. Load
#          0/192 frames, nearest 196.6 px - the largest load clearance in the
#          frame. Leader to foot_L never spans the head rows.
#          WHY the anchor: hand_L from this slot clears the face by only
#          2.1 px at t 0.88 and hand_R by 10.6 px, while foot_L cannot reach
#          the head rows at all - and the ankle is what the label names, the
#          bar locking out 1.49 cm in front of it. The label is the Overhead
#          Squat's own `Bar over the ankles`.
#
# No two pills meet: on row 0.64 the leading pill ends at u 0.2591 and the
# trailing one starts at 0.6530; on row 0.80, 0.2444 against 0.6236. The rack
# pill at row 0.16 ends at u 0.3177 and shares its row with nothing.
#
# Label provenance. Four of the five are the library's own strings for the same
# cue: `Elbows in front` (15) is Barbell Thruster/rack at the same forearm_R
# anchor, and is the Split Jerk's rack label in this family too; `Dip straight
# down` (17) is Push Press/dip and Dumbbell Push Press/dip; `Legs first` (10)
# is Dumbbell Thruster/drive and Kettlebell Thruster/drive; `Bar over the
# ankles` (19) is Overhead Squat/bar, and this rig earns it - the bar locks out
# 1.49 cm in front of the ankle. The Push Press's OWN rack string, `Arms still
# in the dip` (21, anchored at hand_L there), was the first draft's choice here
# and was passed over: the rack cue coaches the rack and leaves the arms-still
# message to `drive`, which carries it with the measurement, and at 21
# characters the forearm_R leader is 2.7 px tighter than at fifteen.
# `Press under` (11) is new - no library lift punches the body down under a
# load.

ex(name="Push Jerk", var="pushJerk",
   overrides={"rack": (0.14, "leading"), "dip": (0.68, "trailing"),
              "drive": (0.86, "leading"), "under": (0.68, "leading"),
              "lockout": (0.86, "trailing")},
   annotations=[
       ("rack", "Elbows in front", "forearm_R"),
       ("dip", "Dip straight down", "patella_L"),
       ("drive", "Legs first", "foot_R"),
       ("under", "Press under", "hand_R"),
       ("lockout", "Bar over the ankles", "foot_L"),
   ],
   cues={
       "rack": ("Front Rack",
                "The bar starts racked on the front of your shoulders, your hands deep under it and your elbows hanging down.",
                "The clip opens with the bar already racked at 1.4645 m - 3.00 cm above and 9.55 cm in front of the shoulder joint - and holds that pose still for 0.417 s at the top of every rep. There is no clean here and the bar never comes near the floor. The elbow is closed to 43.0 degrees with the upper arm only 21.5 degrees from hanging straight down, so the elbow sits 26.79 cm BELOW the shoulder joint and 5.57 cm in front of it: a jerk rack, not a clean rack, and nothing in the model lifts the elbows in front. The bar is resting across the front of the shoulders, not held up by the hands. Catalyst Athletics teaches the same shape, elbows down but in front of the bar and out to the sides; that is coaching, not measurement.",
                "Carrying the bar on your hands with the elbows driven high, as in a clean rack.",
                "Rack the bar across the front of your shoulders, push your hands as deep under it as they will go, and let your elbows hang down just in front of it with the grip relaxed."),
       "dip": ("Dip",
               "A short dip straight down: the knees bend, the trunk stays upright and the hips barely move.",
               "In the model the dip takes 0.292 s and is all knee and ankle. The knee goes 175.2 to 144.40 degrees - 30.8 degrees of flexion - the pelvis drops 3.94 cm to 0.8699 m, and the bar reaches 1.4234 m, its lowest point in the whole clip. The trunk moves only 0.99 degrees, from 0.42 behind vertical to 0.57 in front, and the hip actually OPENS, 162.7 to 166.0 degrees, so this is not a hinge and there is no chest to keep up. Both heels stay flat; the first one leaves the floor at t 0.667, after the dip has finished. The measured literature dips deeper than this model does - 58 plus or minus 9 degrees of knee flexion in seven recreational lifters (Lake 2006) and a centre-of-mass dip of 0.19 plus or minus 0.04 m in sixteen resistance-trained participants, none of them a skilled weightlifter (Soriano 2024) - and no study has shown an optimum depth.",
               "The chest tipping forward in the dip instead of the body sinking straight down.",
               "Bend at the knees and sink straight down a few inches, trunk vertical and the whole foot on the floor, then reverse it without pausing at the bottom."),
       "drive": ("Leg Drive",
                 "The legs throw the bar: they open fast out of the dip while the arms stay closed.",
                 "In the model the drive takes 0.250 s and does all the work. The knee opens 144.40 to 172.07 degrees, the pelvis rises 8.49 cm to 0.9548 m - its highest point in the clip, 4.55 cm above the rack - and the bar climbs 22.94 cm to 1.6528 m, while the elbow goes 43.2 to 41.7 degrees, closing slightly rather than helping. Both heels lift, peaking at 4.77 cm exactly at the top of the drive. Note what the model does NOT do: the knee stops 3.2 degrees short of its own clip maximum of 175.40, so this is not full extension - and coaches disagree about those last few degrees, CrossFit asking for full extension and Everett saying they add little and cost time under the bar, with nothing measured either way. Which muscles do the work is paint and mechanics only: no peer-reviewed EMG study of any jerk has been published.",
                 "Pressing with the arms before the legs have finished, so the bar stalls on the shoulders.",
                 "Drive the whole foot into the floor and open your knees fast, letting the heels come up as the drive finishes, and keep your arms closed until then."),
       "under": ("Press Under",
                 "Once the bar is moving, the arms punch you down under it rather than pressing it up.",
                 "This is the fastest thing in the clip: the elbow sweeps 41.7 to 173.0 degrees in 0.333 s, a mean 394 degrees per second. While it does, both feet leave the floor for 0.250 s (t 0.875 to 1.083, the toes 3.45 cm up) and land wider, the ankle gap 0.238 m at take-off and 0.300 m on landing - 8 cm wider than the 0.220 m it racks in, and still inside the 0.3922 m between the shoulder joints. The catch at t 1.083 is the deepest moment of the clip: knee 121.83 degrees, the pelvis 9.80 cm below the rack and 5.86 cm lower than the dip. Everett puts the mechanism plainly - in a jerk the attempt to press the bar up pushes the lifter down, so the arms move the body - and CrossFit teaches the arms locking out slightly before or as the feet land, which is what the model shows: on the frame the feet land, t 1.125, the elbow already reads 171.0 degrees, and one frame later it is at its 173.0 maximum.",
                 "Waiting with straight legs and pressing the bar up the last part of the way.",
                 "As the legs finish, punch your arms straight and let that push drive you down under the bar, re-bending your knees as it locks out."),
       "lockout": ("Lockout",
                   "You receive in a quarter squat with the bar locked over your ankles, then stand up with it.",
                   "The model holds the elbow at or above 170 degrees for 1.833 s a rep and flat at its maximum 173.0 degrees for 1.792 s. The bar peaks at 2.0574 m, and at the lockout it sits 45.50 cm above the head joint and only 1.49 cm in front of the ankle, having travelled 7.55 cm BACK from where it was racked, so the load finishes over the base rather than out in front of it. The receive is a quarter squat that rebounds to 130.16 degrees of knee and freezes there for 0.250 s, then stands to 175.3 degrees over 0.542 s; Catalyst Athletics calls any depth above a parallel squat a push jerk, and says that if the knees rebend at all after the dip and drive the lift is a push jerk rather than a push press - definitions from coaching, not measurements. There is no split: foot_L.Z minus foot_R.Z never exceeds 0.123 mm in 192 frames, which is the whole difference between this lift and the Split Jerk.",
                   "Locking the bar out in front of your face, so it drags you forward out of the catch.",
                   "Punch the bar up past your face and push your head through your arms to locked elbows, with the bar over your ankles, then stand up out of the quarter squat before you lower it."),
   },
   # Rows exactly as rows.md section 3e settles them, and they follow the paint
   # re-counted there: 16 painted meshes, 8 bright and 8 dim, nothing faint and
   # nothing one-sided - the leanest paint in the family. Bright, so primary:
   # Anterior Deltoid (1 mesh), the three glutes as ONE Gluteus Maximus row
   # (the rig lights maximus, medius and minimus together and the owner
   # confirmed on 2026-10-30 that the paint is not split, so no lift names the
   # medius anywhere) and the four quadriceps heads. Dim, so secondary:
   # Lateral Deltoid, the three trapezius parts plus rhomboid major as one
   # Trapezius row, and the three triceps heads.
   # Provenance: Quadriceps 0.62 carried from the Clean and Press, the fraction
   # the whole family shares; Lateral Deltoid 0.45 carried from the Overhead
   # Carry through the snatches; Anterior Deltoid 0.40 re-estimated as on the
   # other two jerks; Trapezius 0.36 carried from the Push Press, the library's
   # nearest dip-and-drive overhead lift, and NOT the cleans' 0.70, because
   # there is no pull here and nothing is shrugged. Gluteus Maximus 0.50 and
   # Triceps Brachii 0.50 are the family's only two new numbers and both are
   # ESTIMATES (rows.md OPEN POINTS 2 and 10): the glute figure is the Overhead
   # Squat's, re-estimated down from the thrusters' 0.62 because this lift's
   # hip barely moves, and the cleans' 0.70 was deliberately not carried
   # because it is a pull-from-the-floor number.
   # Two places the paint and the mechanics disagree, left for the owner and
   # NOT resolved in the copy: the glutes are the brightest group although
   # hip_L spans 10.01 degrees and pelvis.Z 2.00 cm, while the Split Jerk -
   # whose split stance does load one hip - paints them dim (OPEN POINT 9); and
   # the triceps are only dim although the elbow sweep and the 1.792 s loaded
   # lockout are the clip's defining arm action (OPEN POINT 11). The unpainted
   # erector spinae, hamstrings, biceps, forearms and calves get no rows and
   # are named among the stabilisers instead, even though the heels lift
   # 4.77 cm, both feet leave the floor and both hands hold a rigid bar for all
   # 192 frames (OPEN POINTS 7 and 8). No fraction here is sourced, because no
   # peer-reviewed EMG of any jerk exists to source it from.
   activation=[("Quadriceps", P, MOD, 0.62), ("Gluteus Maximus", P, MOD, 0.50),
               ("Triceps Brachii", S, MOD, 0.50), ("Lateral Deltoid", S, MOD, 0.45),
               ("Anterior Deltoid", P, MOD, 0.40), ("Trapezius", S, LOW, 0.36)],
   stabilisers=["core", "rhomboids", "rotator cuff", "erector spinae",
                "hamstrings", "biceps brachii", "forearms", "calves"],
   # The badge names the one thing that separates this lift from its two
   # siblings, which is measured: the Barbell Clean and Jerk and the Split Jerk
   # both receive in a 60.4 cm split and this model does not split at all. The
   # press-early fault the first draft spent this badge on is already carried by
   # the `drive` cue, with the same measurement, so the family now names three
   # different faults across its three jerks.
   comparison=("RECEIVING ON STRAIGHT LEGS", "Knees re-bend to catch it", "Knees stay locked straight",
               "The knees re-bend to receive: the catch bottoms at 121.83 degrees of knee at 1.083 s, rebounds to 130.16 and freezes there for 0.250 s before standing to 175.3, so the bar is caught on bent legs. The feet stay level while that happens - foot_L.Z minus foot_R.Z never exceeds 0.123 mm in 192 frames - and only widen, the ankle gap 0.238 m at take-off to 0.300 m on landing.",
               "Punching the bar up and keeping the legs straight turns this into a push press: Catalyst Athletics teaches that if the knees rebend at all after the dip and drive the lift is a push jerk, so a receive with no re-bend is the one that has lost the lift. That is a definition from coaching, not a measurement."),
   # One plain glow() per row of paint lit, no shared helper. Bright (A): the
   # anterior deltoid on each shoulder, the glutes at the pelvis and the
   # quadriceps down the thighs. Dim (SOFT): the triceps, placed on the
   # lifter's left arm only - at this framing the right arm's glow would sit
   # under the right shoulder's. glow() averages joints.json's eight samples,
   # six of which land in the rack hold or the lockout, so these centres are
   # static placements and not phase means.
   glows=[glow("Push Jerk", ["deltoid_arc_clavicle_2_L"], A, 0.55, rx=0.07, ry=0.055),
          glow("Push Jerk", ["deltoid_arc_clavicle_2_R"], A, 0.55, rx=0.07, ry=0.055),
          glow("Push Jerk", ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.11, ry=0.055),
          glow("Push Jerk", ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.50,
               rx=0.10, ry=0.075, dy=0.035),
          glow("Push Jerk", ["upper_arm_L", "forearm_L"], SOFT, 0.30, rx=0.06, ry=0.05, dx=0.03)])

SETUP["Push Jerk"] = [
    "Take the bar from a rack onto the front of your shoulders, hands a hand's width outside your shoulders.",
    "Let your elbows hang down and a little in front of the bar, with its weight on your shoulders rather than your hands.",
    "Stand with your feet about hip-width, the whole foot on the floor and your weight spread evenly across it.",
    "Brace your trunk and squeeze your glutes before you dip.",
    "Between reps, take the bar back on your shoulders with your knees soft and let them bend to absorb it before the next dip.",
]

