# Trainer content for the model-only exercises of 2026-10-29, family
# "snatch": the three snatches that shipped with a model but no coaching -
# Power Snatch (Legs/PowerSnatch), Dumbbell Snatch (Legs/DumbbellSnatch)
# and Kettlebell Snatch (Legs/KettlebellSnatch). Same format as spec.py on
# top of common_1_50.py; spec_1029.py imports this module and gen.py reads
# SPEC / SETUP. notes_1029_snatch.md maps every claim in the copy to the
# sources below or to a model measurement.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (the round folder's snatch2/m.py reads every joint's world transform and
# every equipment mesh's points at all 192 integer frames and projects both
# through each lift's own trainer framing; ph.py, ph2.py, det.py and size.py
# read the phases, the per-mesh geometry and the equipment sizes off that;
# trainer_shot.py renders the app's own trainer camera at 382x655).
# THE LIFTER'S SILHOUETTE comes from snatch2/skin.py, which evaluates
# UsdSkel linear-blend skinning at every frame: these rigs are skinned, so
# UsdGeom.Mesh.GetPointsAttr().Get(t) on a body mesh returns the REST pose
# at every time code and projecting it gives a standing silhouette that
# never moves. joints.json is not a substitute either - it holds only 8
# samples per joint, and gen.py uses them to choose a row while the app
# tracks the live joint every frame (Exercise3DView.dotPoint) - so every
# lifter clearance below is from the skinned silhouette and the per-frame
# joint transforms, checked against joints.json (which snatch2/val.py
# reproduces to 0.02) and with every probed joint inside the hull.
# Frame: Y up, the lifter faces +z, their left is +x, metres. Knee and hip
# are inner angles (180 straight), trunk is the neck-over-pelvis line from
# vertical (+ forward). All three clips run 7.96 s at 24 fps (192 frames)
# and the shoulders are 0.392 m apart in all three; all three are seen from
# behind and a little to the lifter's left (yaw -0.8), so the back, the
# glutes and the hamstrings face the camera and the lifter's left arm - the
# working arm on both one-arm lifts - reads on the viewer's right.
#
# - Power Snatch (zoom 0.598, offset [0.002, -0.055, -0.002]). One rep from
#   the floor to overhead and back to the floor, not a set; the pose is
#   frozen over 0-0.375 s and again 7.625-7.958 s and the last frame matches
#   the first to 0.2 mm, so the clip loops. Both sides are driven
#   identically - elbow_L and elbow_R agree to 0.02 degrees at every frame -
#   and the only left/right difference anywhere is the order the feet step
#   back in after the catch. A 2.04 m bar (shaft 0.028 m thick, two 0.45 m
#   plates 0.08 m thick, two 0.105 m collars) rests with its centre at
#   0.225 m; the hands take it 1.09 m apart against 0.392 m at the
#   shoulders, and the feet start 0.220 m apart. Set-up (0-0.375 s, static):
#   knees 83 degrees, hips 46, trunk 69 forward, pelvis 0.520 m, the bar at
#   0.225 m with the hands 0.098 m above it at 0.323 m; the bar sits 12.4 cm
#   in front of the ankle joint and 1 cm behind the toe joint, and the
#   shoulder joint is 3.5 cm in front of the bar. In the frame the pelvis
#   sits a little above the knee (v 0.647 against 0.671). The bar does not
#   leave the floor until 0.500 s. Pull (to 1.958 s): pelvis 0.520 to
#   0.939 m, trunk 69 to 1 degree, knees to 150, hips to 163, the bar to
#   1.019 m, the heels 6.1 cm up (0.069 to 0.130 m at 1.917 s) and the
#   elbows 152 to 149 degrees the whole way; at 2.000 s the trunk reaches 7
#   degrees behind vertical and the hips 168. Turnover (1.958-2.583 s): the
#   elbow folds to 91 degrees at 2.250 s and snaps out to 177 at 2.583 s -
#   only two frames exceed 174, at 2.542 and 2.583 - as the bar goes to
#   1.794 m. Catch (to 2.958 s): the pelvis dips to 0.760 m with the knees
#   at 111 and the trunk at 5 degrees, the elbows already locked, and the
#   feet jump from 0.220 m to 0.300 m apart (each foot 4 cm out, lifting its
#   heel 3 cm) before stepping back in one at a time, the left by 3.42 s and
#   the right by 3.92 s. Overhead hold (2.958-4.208 s): the elbow flat at
#   173 degrees, the bar at its peak 1.938 m - 0.504 m above the shoulder
#   joint, 0.336 m above the head and 1.5 cm in front of the ankle - held
#   1.75 s at or above 170 degrees of elbow and 1.33 s with the bar at or
#   above 1.90 m. Return (4.208-7.958 s): the elbow folds to 93 degrees at
#   4.542 s, the bar swings 0.54 m forward of where it locked out and
#   settles on the floor by 7.50 s. The bar rises 171.3 cm (0.225 to
#   1.938 m) and all five of its meshes move together, so the bar is rigid;
#   its maximum displacement from the start pose is 171.7 cm and its path
#   length 4.33 m. Paint: the three glutes, the three hamstrings, the four
#   quadriceps and the anterior and lateral deltoid bright on both sides;
#   the three trapezius parts, the rhomboid major, the erector spinae, both
#   biceps heads and the calves (both gastrocnemius heads and the soleus)
#   dim; nothing faint and nothing one-sided.
# - Dumbbell Snatch (zoom 0.721, offset [0.011, -0.048, -0.012]). One rep,
#   one dumbbell under /root/HG_WeightL - a 0.34 m handle 0.032 m thick and
#   two 0.16 m heads 0.07 m thick - in the LEFT hand for the whole clip: the
#   handle stays 0.104 m from hand_L at every frame and the two heads 0.152
#   and 0.158 m. The right arm never works: elbow_R only drifts 146 to 170
#   degrees as the trunk stands up and that hand never gets above 0.965 m.
#   The legs are symmetrical even so (knee_L 66.6-175.3 against knee_R
#   66.6-175.4, both heels leaving the floor together). Set-up (0-0.375 s,
#   the first ten frames identical): trunk 72 degrees forward, knees 67 -
#   i.e. 113 degrees of knee flexion, deeper than the Power Snatch's 83, so
#   a low squatting start and NOT a hinge - hips 56, pelvis 0.500 m, the
#   hand at 0.163 m and 0.43 m in front of the ankle line, the feet
#   0.30-0.32 m apart. Pull (to 1.875 s): knees to 165, hips to 168, trunk
#   to 5 degrees behind vertical, the hand to 1.065 m, the heels 5.8 cm up
#   (0.069 to 0.127 m), and the elbow locked at 174 degrees for all of it.
#   Turnover (1.875-2.50 s): the elbow folds to 76 degrees at 2.29 s and
#   back to 134 as the hand rises to 1.84 m and comes 0.35 m in toward the body (depth
#   +0.28 to -0.08 m). Catch and stand (2.50-3.33 s): the knee dips to 113
#   degrees and the pelvis to 0.770 m at 2.88 s, then both open to 175 and
#   0.908 m. Overhead hold (3.167-4.583 s, 1.46 s, and the whole pose holds
#   to within a millimetre from 3.33 to 4.50 s): elbow 174 degrees, the hand
#   1.967 m, the bell 0.469 m above the head and 0.233 m to the working side
#   of the midline, the trunk upright. Then the bell is racked down to the
#   shoulder before the hips move at all: the elbow folds to 31 degrees at
#   5.29 s while both knees hold 174-175, and only from about 6.1 s does the
#   trunk hinge back to its set-up pose. The dumbbell rises 198.3 cm. Paint:
#   the three glutes, the three hamstrings and the four quadriceps bright on
#   both sides, plus the external oblique, internal oblique and rectus
#   abdominis bright on the RIGHT only - the side away from the working arm;
#   the erector spinae and the calves (both gastrocnemius heads and the
#   soleus) dim on both sides, and on the working LEFT side only the
#   anterior and lateral deltoid, the three trapezius parts and the rhomboid
#   major dim. Nothing faint, and no biceps paint at all, as on the Dumbbell
#   Hang Clean.
# - Kettlebell Snatch (zoom 0.727, offset [0.007, -0.041, -0.007]). Three
#   identical reps on a 2.67 s loop (192 frames / 64 = exactly 3; the
#   bottom-of-swing frames at 0.833, 3.500 and 6.167 s are bit-identical on
#   every joint), and the clip opens and closes in the overhead hold, so the
#   loop seam falls inside a lockout. One bell in the LEFT hand (6 meshes
#   under /root/HG_WeightL: a 0.21 m bell, a 0.033 x 0.15 m handle, two
#   0.033 x 0.115 m uprights and two 0.033 m beads; the handle stays
#   0.104 m from hand_L at every frame), and the right arm is frozen:
#   elbow_R reads 167.931 degrees in all 192 frames, spread 0.0000.
#   Lockout (0.88 s a rep: 1.917-2.75, 4.583-5.417 and 7.25-0.083 s across
#   the seam - 63 of 192 frames, a third of the clip): elbow 174-175
#   degrees, the hand 1.965 m, 0.368 m above the head and 0.536 m above the
#   shoulder joint, and only 1.5 cm to the side of the shoulder and 2.1 cm
#   to the side of the ankle. Drop (0.125-0.625 s): the elbow unlocks to 74
#   degrees at 0.375 s with the legs still straight (knee 166 or more to
#   0.583 s) and the bell swings forward to Z +0.583 m at 0.542 s, 0.23 m in
#   front of the hand. Hinge (0.625-0.833 s): knees 151 to 107, hips 148 to
#   93, trunk 25 to 55 degrees, pelvis 0.875 to 0.720 m - a 0.16 m drop, not
#   the 0.20 m a clip maximum at 1.375 s would suggest - and the bell goes
#   back between the legs to 0.323 m, 0.27 m from the hand and touching
#   nothing. Pull (0.833-1.292 s): knees to 174, hips to 169, trunk to 1
#   degree, pelvis to 0.915 m and then its clip maximum 0.918 m at 1.375 s.
#   Turnover (1.292-1.917 s): the elbow folds to 55 degrees at 1.542 s as
#   the bell passes the head - within 1 px of the head joint in the frame at
#   1.625 s - then opens to 170 by 1.875 s and the lockout is reached at
#   1.917 s. The bell covers 14.82 m over the clip, 4.94 m a rep: 1.709 m up
#   and down, 0.693 m front to back and 0.464 m across the body, and it
#   rotates around the gripped handle rather than being held still (0.268 m
#   from the hand at the drop, 0.115 m at the turnover, 0.121 m through the
#   lockout). The feet never move and the heels barely do: both ankles hold
#   0.0686-0.0829 m, so the heel rises 1.4 cm in phase with each pull (ten
#   frames a rep, at 1.125-1.50, 3.79-4.17 and 6.46-6.83 s) against 6.1 cm
#   in the barbell snatch, 0.38-0.39 m apart against 0.392 m at the
#   shoulders, and in the frame each foot moves under 3 px. Paint: the three
#   glutes and the three hamstrings bright on both sides; the erector spinae
#   and the four quadriceps dim on both sides, and on the working LEFT side
#   only the anterior and lateral deltoid, the three triceps heads, both
#   biceps heads, the three trapezius parts and the rhomboid major dim.
#   Nothing faint; no oblique, no abdominal and no calf paint anywhere.
#
# How they differ from the library: the four cleans of this round finish at
# the shoulders, and the Clean and Press, the Kettlebell Clean and Press and
# the two jerks press or dip under a bar that is already racked - a snatch
# puts the load overhead in one movement and never re-grips. The Barbell
# Overhead Press and Dumbbell Shoulder Press press a load the shoulders have
# to lift; here the legs throw it and the arm only locks, which is why the
# shoulder rows follow the Overhead Carry, the library's one loaded overhead
# hold, rather than the presses - the Clean and Press, the nearest barbell
# lift that does finish overhead, sits beside it at Lateral Deltoid 0.50.
# The Kettlebell Swing is the Kettlebell Snatch without the turnover: the
# same hinge, but the bell stops at chest height on straight arms and is
# never fixed overhead.
#
# Sources (what each is used for is in notes_1029_snatch.md):
# - Geisler S, Havers T, Isenmann E, Schulze J, Lourens LK, Nowak J, Held S,
#   Haff GG 2023, J Sports Sci Med 22(4):778-789, doi 10.52082/jssm.2023.778,
#   PMID 38045750, PMCID PMC10690512 (abstract, Key Points, Results and PMC
#   Table 4 read 2026-10-30): 27 weightlifters at three levels (beginner 11,
#   advanced 10, elite 6), all with at least a year of barbell training, two
#   reps each of the hang power clean, hang power snatch, hang clean pull and
#   hang snatch pull at 50, 70 and 90% 1RM, EMG of the vastus lateralis,
#   gluteus maximus, erector spinae, rectus abdominis and trapezius
#   normalised to each muscle's MVIC. Erector spinae activity was
#   significantly greater in the hang power SNATCH than in the hang snatch
#   pull in all three groups (p < 0.05, g = 0.27-0.98) - though at all three
#   loads only in the elite group, at 50% 1RM only in the advanced and at
#   90% only in the beginners - which is the one published finding that puts
#   the low-back work in the catch rather than the pull. The trapezius
#   differed only at 50% 1RM and favoured the PULL. Its hang-power-snatch
#   erector spinae means run from about 143 to 372% MVIC with standard
#   deviations up to about 322, and the authors call the advanced and elite
#   groups' normalised values highly variable, so no percentage is quoted
#   and no row is ranked on it; it also measured the HANG power snatch, not
#   a snatch from the floor.
# - Wu W-L, Ting Y-T, Huang C-J, Huang C-H, Wang H-J, Chen S-K 2008,
#   26th International Conference on Biomechanics in Sports p. 461 (whole
#   one-page paper read 2026-10-30; no DOI, open access at
#   ojs.ub.uni-konstanz.de/cpa/article/view/1888, PDF at /1888/1757):
#   four weightlifters, two female and two male, 15 to 20 years old, a 50 kg
#   barbell, EMG at 1500 Hz synchronised with motion capture at 100 Hz.
#   Recruitment order latissimus dorsi, then pectoralis major and biceps
#   brachii, then deltoid, then triceps brachii. Its own wording is a
#   shoulder range-of-motion milestone, not a point in time: before the half
#   way point of the shoulder full flexion the contracting muscles are the
#   biceps brachii and pectoralis major, after it the deltoid; after the
#   turnover phase the triceps contract to keep the arm straightened; and
#   after the catch phase the elbow is held at nearly full extension. It
#   publishes no percentage of maximum and n = 4, half of them female and
#   all adolescent, so it is cited for which muscle acts when, never for how
#   much, and its phase list includes rising from the squat, so it measured
#   the full snatch rather than a power snatch.
# - Ernst AT, Jensen RL 2015, 33rd International Conference of Biomechanics
#   in Sports p. 200 (abstract read 2026-10-30; no DOI, open access at
#   ojs.ub.uni-konstanz.de/cpa/article/view/6360): nine male Olympic
#   weightlifters training for competition, two lifts each at 40, 60 and 80%
#   of their maximum snatch, surface EMG of the supraspinatus, infraspinatus
#   and teres minor. The supraspinatus and infraspinatus were most active
#   during the TURNOVER and CATCH and the teres minor during the first pull
#   and transition; shoulder abduction angle at the catch did not differ
#   between loads. No percentage of maximum is published, so the cuff is
#   named among the stabilisers rather than given a row.
# - McGill SM, Marshall LW 2012, J Strength Cond Res 26(1):16-27,
#   doi 10.1519/JSC.0b013e31823b005f (full text with Tables 1 and 2 and the
#   Results statistics read 2026-10-30 from the authors' own PDF; already
#   cited in the library's Kettlebell Swing): seven healthy male
#   participants, mean age 25.6, a convenience sample from the University
#   population, found to be fit and most with kettlebell experience; a 16 kg
#   bell in the right hand; peaks as %MVC. Swing / swing with Kime / swing
#   to snatch: gluteus maximus 76.1, 82.8, 58.1; gluteus medius 70.1, 70.7,
#   42.7; biceps femoris 32.6, 39.7, 29.8; rectus femoris 33.5, 49.4, 53.4;
#   right internal oblique 42.4, 49.3, 53.6 and left 30.2, 80.8, 53.2;
#   loaded-side latissimus dorsi 17.3, 20.3, 25.4 against the free side's
#   56.2, 65.8, 72.4. CRUCIALLY, swing exercise had a significant effect on
#   only three muscles - right external oblique (F = 4.27), right rectus
#   femoris (F = 4.16) and left internal oblique (F = 5.45), all p < 0.05 -
#   and the post hoc tests found NO significant difference in the external
#   oblique between the three exercises and put the rectus femoris and left
#   internal oblique differences on the swing WITH KIME against the plain
#   swing, not on the snatch. The paper's own narrative runs the other way
#   from its glute column: the swing to snatch appears to increase the
#   activation of almost all muscles. L4/L5 compression at the end of the
#   swing was 1,903 N (SD 618), 2,960 N (SD 1,153) and 1,589 N (SD 601);
#   the significant contrast there was Kime against snatch (p = 0.032) while
#   swing against Kime was p = 0.07, compression was under 3,200 N in all
#   styles, which the authors call quite conservative, and they add that
#   these loads are probably not of clinical significance for the spine. So
#   the paper supports no swing-against-snatch ranking of any muscle, and
#   nothing here is ranked on it.
# - Lyons BC, Mayo JJ, Tucker WS, Wax B, Hendrix RC 2017, J Strength Cond
#   Res 31(9):2363-2370, doi 10.1519/JSC.0000000000001771, PMID 28394829
#   (abstract re-read 2026-10-30): 14 resistance-trained subjects, one-arm
#   kettlebell swing, swing-style snatch and clean at a self-selected
#   8-10RM, five reps each, EMG of eight muscles normalised to MVC. Only
#   three differed: erector spinae Swing > Snatch, contralateral external
#   oblique Snatch and Clean > Swing, and vastus lateralis Swing > CLEAN -
#   with no snatch-against-swing difference in the quadriceps. There was no
#   difference between the three in the anterior or posterior deltoid, the
#   biceps brachii, the biceps femoris or the gluteus maximus. No percentage
#   is published, the lift is a swing-style snatch, and the authors note the
#   participants were not experienced kettlebell lifters.
# - Ross JA, Keogh JWL, Wilson CJ, Lorenzen C 2017, PeerJ 5:e3111,
#   doi 10.7717/peerj.3111, PMID 28367368, PMCID PMC5374970 (full text read
#   2026-10-30 via PMC): twelve male amateur kettlebell-sport lifters with
#   at least three years of kettlebell training, one 6-minute set WITH A
#   HAND CHANGE AT THE 3-MINUTE MARK, 24 kg bell, 972 reps on bilateral
#   force plates. It names the rep from fixation through six phases - drop,
#   re-gripping, back swing, forward swing, acceleration pull and hand
#   insertion - and says a valid repetition needs the bell locked out
#   motionless overhead at its conclusion; citing McGill and Marshall it
#   calls the overhead fixation one of two points of relative relaxation in
#   the rep. Anterior-posterior ground force was higher in the ipsilateral
#   leg (165 against 154 N downwards, 6.9%, and 164 against 146 N upwards,
#   11.6%; F(1,11) = 885.15, p < 0.0001). Grip strength OF THE HAND THAT
#   PERFORMED THE LAST 3 MINUTES fell 9.8 +/- 4.4 kg (p = 0.001) - so it is
#   three minutes of work, not six, and the study ranks grip against
#   nothing else. Its peak-force fatigue result does not match its own
#   Table 1, so nothing is claimed from that.
# - Lake JP, Hetzler BS, Lauder MA 2014, J Strength Cond Res 28(11):3063-3072,
#   doi 10.1519/JSC.0000000000000538 (accepted manuscript read 2026-10-30):
#   22 men, 3 sets of 8 kettlebell snatches and 3 sets of 8 TWO-HANDED
#   swings with a 24 kg bell on a force platform. Horizontal impulse was
#   18 +/- 7 N.s in the snatch against 29 +/- 7 in the two-handed swing, an
#   impulse ratio of 14% against 23% (both p < 0.0001), while the authors
#   conclude the mechanical output of the two is otherwise similar and that
#   coaches could use them interchangeably. It is a one-handed snatch
#   against a TWO-handed swing, which the copy says, and it is a
#   between-exercise comparison, so it is never used to price a technique
#   fault inside one lift; its 22 against 18 cm figure is lifter-plus-bell
#   centre-of-mass travel, not bell travel, so neither is used that way.
# - Lake J, Lauder M, Dyson R 2006, Kinetic Analysis of a Unilateral Snatch
#   Movement, 24th International Symposium on Biomechanics in Sports
#   (abstract read 2026-10-30; the PDF IS reachable, at
#   ojs.ub.uni-konstanz.de/cpa/article/view/277/236): seven weightlifters,
#   one-handed DUMBBELL power snatches at 80, 90 and 100% of 1RM, vertical
#   ground reaction force from two Kistler platforms at 500 Hz. There were
#   NO significant load or side effects for pull-phase peak VGRF or catch
#   loading rate (P > 0.05), though non-lifting-side values tended to be
#   larger except for the catch loading rate at the heaviest loads; the
#   lifting side's pull phase was significantly longer (P < 0.001); and the
#   authors conclude the uneven dumbbell load affected pull and catch
#   symmetry. The only source found on the dumbbell snatch itself; a
#   conference abstract, n = 7, no EMG.
# - Petrizzo J, DiMenna FJ, Page R, Smith G, Martins K, Lester J, Kang S,
#   Chandler L, Wygand JW, Otto RM 2016, J Exerc Physiol online 19(3):24-34
#   (full text read 2026-10-30; no DOI): ten subjects, snatches and cleans
#   from a traditional and an experimental start alignment. The experimental
#   alignment cut horizontal bar displacement by about 40.3 mm in the snatch
#   (P < 0.05) with no significant difference in peak power (about 2.2%),
#   which is why the bar-path cue is written as control rather than as more
#   weight.
# - StrengthLog, How to Do Snatch: Muscles Worked and Proper Form,
#   strengthlog.com/snatch/ (practice source, not peer-reviewed; read
#   2026-10-30): step up close to the bar so that it is about over the
#   middle of your foot, grip the bar with a wide overhand grip close to the
#   weight plates, and catch the bar on straight arms over your head. Its
#   muscle list is worth recording against the library's instincts: primary
#   glutes, lower back, ADDUCTORS and quads; secondary hamstrings,
#   trapezius, forearm flexors and CALVES - so it backs the dim calf row the
#   rigs earn, lists no deltoid and no triceps at all, and makes the
#   adductors primary where none of these rigs paints them. Used for the
#   mid-foot bar position, the grip and the straight-arm catch only, never
#   for a number.
# - The library's own entries, read in SampleData.swift on 2026-10-30 for
#   the fractions: Clean and Press (Anterior Deltoid 0.84, Trapezius 0.70,
#   Gluteus Maximus 0.70, Quadriceps 0.62, Triceps Brachii 0.55, Erector
#   Spinae 0.55, Hamstrings 0.50, Lateral Deltoid 0.50, Biceps Brachii
#   0.30), whose pull rows are carried here through spec_1029_clean.py's
#   PULL_ROWS because the pull from the floor is the same; Overhead Carry
#   (Upper Trapezius 0.60, Lateral Deltoid 0.45, Obliques 0.36, Rectus
#   Abdominis 0.30, with the anterior deltoid, rotator cuff and triceps
#   among its stabilisers), the only loaded overhead hold in the library;
#   Suitcase Carry (Obliques 0.60, Trapezius 0.44, Rectus Abdominis 0.30
#   after the 2026-10-18 re-paint removed its forearm, lower-back and glute
#   rows), its one-arm anchor, already reused by the Kettlebell Clean;
#   Kettlebell Swing (Gluteus Maximus 0.80, Erector Spinae 0.50, Hamstrings
#   0.76, Adductors 0.38, with the trapezius among its stabilisers and no
#   quadriceps or forearm row, both removed when they went unlit) for the
#   hinge; Barbell Overhead Press (Anterior Deltoid 0.86, Lateral Deltoid
#   0.74) and Dumbbell Shoulder Press (0.84, 0.72) for the presses this
#   family is NOT following; Pallof Press (Rectus Abdominis 0.44 primary),
#   the Dumbbell Shrug and its five siblings (Middle Trapezius 0.30
#   primary), the Rope Hammer Curl and its two siblings (Forearms 0.30
#   primary) and the Seated Calf Raise (Gastrocnemius 0.30 primary) for the
#   precedent of a LOW primary row; the Deadlift, whose Erector Spinae row
#   was removed when the paint went out and whose comment leaves the
#   paint-against-literature disagreement as a question for the owner; and
#   spec_400_legcurl.py (0.40, 0.40, 0.36, 0.36, 0.34, 0.30),
#   spec_400_hinge.py (0.50, 0.40, 0.32), spec_legs2.py (0.46, 0.46, 0.40)
#   and spec_1029_legs.py (Gastrocnemius 0.46 with Soleus 0.30) for the
#   library's dim calf rows, which run 0.30-0.50.
# - ExRx was NOT read this round: exrx.net returns HTTP 403 from here and
#   web.archive.org is unreachable, so no Target or Synergist list was
#   checked for any of the three snatches. The Clean and Press copy already
#   in the library cites ExRx and CrossFit for its start position and bar
#   path; those citations belong to that entry and are not carried across.

from common_1_50 import *

NAMES = ["Power Snatch", "Dumbbell Snatch", "Kettlebell Snatch"]


def snatch_glows(name, delt=A, delt_op=0.50, delt_ry=0.06):
    """The shared paint: the glutes at the hip, the hamstrings and quadriceps
    down the thigh, and the working shoulder - bright on the Power Snatch,
    dim on the two one-arm lifts, so A or SOFT by the paint."""
    return [glow(name, ["pelvis", "thigh_L"], A, 0.55, rx=0.11, ry=0.07),
            glow(name, ["patella_L", "thigh_L"], A, 0.50, rx=0.08, ry=0.08),
            glow(name, ["deltoid_arc_clavicle_2_L", "deltoid_arc_scapula_2_L"],
                 delt, delt_op, rx=0.08, ry=delt_ry)]


# --------------------------------------------------------- power snatch

ex(name="Power Snatch", var="powerSnatch",
   # Rows are the raw 0.14-0.86 scale; spec_1029.py renders them at 0.16,
   # 0.32, 0.48, 0.64 and 0.80. Every clearance below is measured at the
   # pill the app DRAWS: CalloutPill is .font(.ui(12, .semibold)) with
   # .padding(.vertical, 7), TrackedCallout centres it on labelPoint.y and
   # the annotation layer scales by stageHeight/567, so its half-height is
   # 0.0218-0.0250 in v on every device and the numbers use 0.025, the worst
   # case (gen.py's covered() band is the looser +/-0.035). The lifter comes
   # from the SKINNED silhouette and the per-frame joint transforms, not
   # from joints.json's 8 samples. The hardest framing of the three: the
   # 2.04 m bar crosses the whole frame, plates included, and sweeps
   # u -0.002-0.942, v 0.157-0.835, so every row is entered at some moment.
   # Exactly ONE slot is free of it - leading at row 0.16, where the load
   # keeps to u 0.653-0.909 while the pill ends at 0.274, and where no part
   # of the lifter appears at any frame - and the lockout pill takes it. Six
   # of the ten slots clear the lifter at every frame at twelve characters,
   # and the layout then maximises LIFTER clearance among the slots that are
   # also cheap in bar-seconds: row 0.80 leading (1.04 s of bar, 18.8 px of
   # lifter), rows 0.16 and 0.48 trailing (1.46 s, no lifter in row 0.16 at
   # any frame and 15.7 px at 0.48) and row 0.80 trailing (2.17 s, 57.5 px).
   # Where the bar does cross a pill it is the plates on the floor at the
   # set-up and the finish (both row-0.80 pills), the bar overhead through
   # the lockout (row 0.16 trailing, 2.88-4.29 s) or the bar in flight past
   # the catch pill, which it passes at chest height on the way up
   # (1.79-2.25 s) and again on the way down (4.54-5.46 s); 0.48 trailing is
   # still the best slot left for that cue, with 15.7 px of lifter clearance
   # and the least bar time of any slot that clears the lifter at all. Row
   # 0.32 trailing is marginally
   # cheaper in bar-seconds at these nine-character labels (2.08 s) but
   # leaves only 7.9 px of lifter clearance, so it is left empty; row 0.64
   # leading is the worst slot in the frame for the bar (4.42 s) and both
   # leading slots at rows 0.32 and 0.48 sit on the lifter.
   # Shortening a label buys nothing against a 2.04 m bar, so `Flat back`
   # and `Bar close` are short for the lifter and the leaders - and are the
   # library's own nine-character labels from the Clean and Press, which
   # places the same two cues. Clearances are measured against the 655-row
   # silhouette, one row per screen pixel: the set-up pill clears the lifter
   # by 57.5 px, the drive pill by 18.8 and the catch pill by 15.7, and no
   # part of the lifter enters either row-0.16 pill at any frame. No LEADER
   # lies on the lifter's head at any frame either. That is tested against
   # the head's OWN silhouette - the vertices the rig weights to the head
   # joint - and not against a box around the joint, which sits at the base
   # of the skull and misses the face in a folded-over pose, nor against the
   # whole body at head height, which at the lockout is mostly raised arm.
   # The closest any leader comes to the head is 17.0 px (the lockout
   # leader, t 0.17), then 28.7 px (the pull leader) and 31.0 (the catch
   # leader, as the bar turns over). Details in the label plan.
   overrides={"setup": (0.86, "trailing"), "pull": (0.14, "trailing"),
              "extend": (0.86, "leading"), "catch": (0.50, "trailing"),
              "lockout": (0.14, "leading")},
   annotations=[
       ("setup", "Flat back", "spine"),
       ("pull", "Bar close", "hand_L"),
       ("extend", "Finish the drive", "foot_R"),
       ("catch", "Drop under", "forearm_L"),
       ("lockout", "Bar overhead", "hand_R"),
   ],
   cues={
       "setup": ("Start Position",
                 "You set up over the bar with a flat back, your shoulders just in front of it and a wide grip out toward the plates.",
                 "In the model the trunk starts 69 degrees forward with the knees at 83 and the hips at 46, the pelvis at 0.520 m, and the shoulder joint sits 3.5 cm in front of the bar - the same relation the library's Barbell Power Clean coaches. The hands are 1.09 m apart against 0.392 m at the shoulders, out by the plates. In the frame the pelvis sits a little above the knee, and nothing moves at all for the first ten frames; the bar does not leave the floor until 0.50 s and then travels 171.3 cm in one go, from 0.225 m to 1.938 m, so there is no second chance to fix a position once it moves.",
                 "Rounding the lower back over the bar, or setting the hips high with the chest already down.",
                 "Set your feet about hip-width, take a wide overhand grip out toward the plates, drop your hips until your back is flat with your shoulders just in front of the bar, and brace before you pull."),
       "pull": ("First Pull",
                "Off the floor the bar comes up close to your legs while your hips and shoulders rise together.",
                "In the model the bar rises from 0.225 m to 1.019 m while the elbows stay almost straight the whole way - 152 degrees at the floor and still 149 at the top of the pull - and the pelvis and trunk come up together, 0.520 to 0.939 m and 69 degrees to 1. Keeping the bar in keeps the load over your feet, where you can push against it. Treat it as control rather than as extra weight: a study of ten lifters that changed the start position to cut horizontal bar travel did cut it, by about 40 mm in the snatch, but found no significant difference in peak power.",
                "Letting the bar swing out in front, or bending the arms to help it up.",
                "Push the floor away steadily, let the bar brush up your shins and thighs, and keep your arms long until it passes your hips."),
       "extend": ("Second Pull",
                  "When the bar reaches your hips you drive hard: the knees and hips open together and the heels come off the floor.",
                  "This is the part that throws the bar. In the model the knees open to 150 degrees and the hips to 168, the trunk comes through vertical to 7 degrees past it, the heels lift 6.1 cm off the floor - 0.069 m to 0.130 m - at 1.92 s, and the arms are still 149 degrees while all of it happens. The heels are back down by 2.42 s, so the drive has them off the floor for 0.79 s, with a second 0.25 s lift later as each foot re-sets under the overhead hold - 1.04 s of the clip in all. That is why the calves are a low row here and no row at all on the kettlebell version, where the heel only ever rises 1.4 cm.",
                  "Pulling with the arms before the legs have finished, so the bar stalls at the hips.",
                  "Drive through the whole foot until your body is one long line, let the heels leave the floor, and keep the arms long until then."),
       "catch": ("The Catch",
                 "Once the legs have finished you pull yourself under the bar and receive it on straight arms.",
                 "In the model the elbow folds from 149 degrees to 91 as the bar turns over and then snaps out to 177 inside a third of a second, while the pelvis drops from 0.939 m to 0.760 and the knees re-bend to 111 - a partial squat, well above parallel. The feet jump from 0.220 m to 0.300 m apart to receive it and step back in one at a time during the hold. The arms are already locked when the bar arrives: in a motion-capture study of the snatch the elbow was held at nearly full extension from the catch onward and the triceps only contracted after the turnover, to keep the arm straightened. StrengthLog says the same thing - catch the bar on straight arms over your head.",
                 "Waiting for the bar with straight legs and trying to press it the last part of the way.",
                 "As the bar peaks, pull yourself under it: punch your arms straight, let your feet jump out a little, and bend your knees to receive it overhead."),
       "lockout": ("Overhead Lockout",
                   "You finish standing tall with the bar locked overhead and stacked over your ankles.",
                   "The model holds it for 1.75 s with the elbows flat at 173 degrees and the bar at its peak 1.938 m - 0.504 m above the shoulder joint and 0.336 m above the head - and 1.5 cm in front of the ankle, so the load sits over the base rather than out in front of it. The hands are 0.098 m below the bar at 1.840 m, because the wrist sits above an overhand grip. The job up there is support, not pressing: the legs and hips put the bar there with the elbows still 149 degrees at the top of the pull, and the one study of the rotator cuff in this lift found the supraspinatus and infraspinatus at their most active during the turnover and the catch rather than the pull.",
                   "Finishing with the bar out in front of your head, or pressing it out the last part of the way.",
                   "Punch the bar up, lock your elbows, and stand tall with it stacked over your ankles until it stops moving."),
   },
   # Rows follow the paint, re-read with tiers.py on 2026-10-30: 12 bright,
   # 10 dim, nothing faint, nothing one-sided. Bright, so primary: the three
   # glutes as ONE Gluteus Maximus row (the rig lights them as one group and
   # the owner confirmed on 2026-10-30 that the paint is not split, so the
   # copy says glutes and never names the medius), the three hamstrings, the
   # four quadriceps, and both the anterior and the lateral deltoid. Dim, so
   # secondary: the three trapezius parts as one Trapezius row (the dim
   # rhomboid major inside it, as on the shoulder presses), the erector
   # spinae, both biceps heads and the calves. Gluteus Maximus 0.70,
   # Quadriceps 0.62, Trapezius 0.70, Erector Spinae 0.55, Hamstrings 0.50
   # and Biceps Brachii 0.30 are carried unchanged from spec_1029_clean.py's
   # PULL_ROWS and through it from the library's Clean and Press, which
   # holds all six at those values, because the pull from the floor is the
   # same movement. Only the QUADRICEPS changes rank - up to primary on this
   # model's brighter paint, keeping 0.62, as the README's rank-change rule
   # asks. Erector Spinae 0.55 is the one carried row with fresh snatch
   # evidence behind it (Geisler 2023 found it greater in the hang power
   # snatch than in the hang snatch pull in all three expertise groups, so
   # it is the catch rather than the pull that loads it), but that paper's
   # hang-power-snatch means run past 370% MVIC with deviations of the same
   # order, so the number stays carried. Trapezius 0.70 is carried and NOT
   # sourced: the same paper's only trapezius finding runs the other way,
   # greater in the PULL.
   # THE OVERHEAD FINISH is where a snatch leaves the cleans, and NEITHER
   # deltoid row is carried from PULL_ROWS. Lateral Deltoid 0.45 is new,
   # from the Overhead Carry, the library's only loaded overhead hold, and
   # not from the Barbell Overhead Press's 0.74, because a snatch supports
   # the bar overhead and never presses it; the Clean and Press, the nearest
   # barbell lift that finishes overhead, sits beside the Overhead Carry at
   # 0.50, which is a better check on 0.45 than any press. Anterior Deltoid
   # is RE-ESTIMATED from the cleans' 0.30, which end at the shoulders, up
   # to 0.40 - below the Dumbbell Shoulder Press's 0.84 and the Barbell
   # Overhead Press's 0.86. Wu 2008 has the deltoid taking over once the
   # shoulder is more than halfway to full flexion (a range-of-motion
   # milestone, not a point in time) but publishes no percentage, and Lyons
   # 2017 found no anterior-deltoid difference between a one-arm swing,
   # snatch and clean. Gastrocnemius 0.30 is the one new leg row the paint
   # earns: it is the floor of the library's dim calf rows, which run
   # 0.30-0.50, and no snatch study read here measured a calf - but the heel
   # lifts 6.1 cm for 1.04 s of the clip and StrengthLog lists the calves
   # among the muscles worked. The rig paints the gastrocnemius AND the
   # soleus dim; this one row carries both and the soleus is named among the
   # stabilisers, because the number is the same judgement call either way -
   # the library splits them only where it has separate evidence
   # (spec_1029_legs.py's leg curl gives Gastrocnemius 0.46 and Soleus 0.30,
   # the gastrocnemius higher because it crosses the loaded knee, which is
   # not what loads either of them here). See the open points. The unpainted
   # triceps, latissimus dorsi and rotator cuff get no rows and are named
   # among the stabilisers, exactly as the Overhead Carry does with all
   # three: Wu 2008 puts the lat first in the recruitment order and the
   # triceps after the turnover, and Ernst and Jensen 2015 put the cuff at
   # the turnover and catch, but none publishes a percentage and the rig
   # lights none of them.
   activation=[("Gluteus Maximus", P, HI, 0.70), ("Trapezius", S, HI, 0.70),
               ("Quadriceps", P, MOD, 0.62), ("Erector Spinae", S, MOD, 0.55),
               ("Hamstrings", P, MOD, 0.50), ("Lateral Deltoid", P, MOD, 0.45),
               ("Anterior Deltoid", P, MOD, 0.40), ("Biceps Brachii", S, LOW, 0.30),
               ("Gastrocnemius", S, LOW, 0.30)],
   stabilisers=["core", "forearms", "latissimus dorsi", "triceps brachii",
                "rotator cuff", "soleus"],
   comparison=("PRESSING IT UP", "Legs throw it, arms just lock", "Arms press the last part up",
               "The legs and hips put the bar overhead: in the model the elbows are still 149 degrees at the top of the pull and only snap straight once the bar is already there.",
               "Pressing it out caps the lift at what your shoulders can press; in the model the elbows are locked before the bar arrives."),
   glows=snatch_glows("Power Snatch"))

SETUP["Power Snatch"] = [
    "Load a bar on the floor and stand with your feet about hip-width apart, the bar about over the middle of your feet.",
    "Take a wide overhand grip out toward the plates - wide enough that the bar meets your hip crease when you stand up with it.",
    "Drop your hips until your back is flat, with your shoulders just in front of the bar and your hips a little above your knees.",
    "Brace your trunk and take the slack out of the bar before the first pull.",
    "Between reps, lower the bar under control to the floor and set your back again rather than bouncing it.",
]

# ------------------------------------------------------ dumbbell snatch

ex(name="Dumbbell Snatch", var="dumbbellSnatch",
   # Rows are the raw 0.14-0.86 scale and render at 0.16, 0.32, 0.48, 0.64
   # and 0.80; measured as on the Power Snatch, at the drawn pill
   # (half-height 0.025 in v) over all 192 frames against the equipment's
   # projected points and the skinned silhouette. One dumbbell instead of a
   # 2.04 m bar changes the problem: the three prop meshes sweep only
   # u 0.229-0.881, so NO pill in this layout is ever crossed by the load.
   # What binds is the LIFTER and the LEADERS. The working arm is on the
   # viewer's right - hand_L sweeps u 0.357-0.774 and v 0.169-0.807 over the
   # clip against only u 0.390-0.679 at the eight moments joints.json
   # samples - and the left gutter is narrow below row 0.32 (the silhouette
   # reaches u 0.278 at row 0.48, 0.219 at 0.64, 0.189 at 0.80). So the two
   # left pills point at left-side joints, the free hand and the far knee,
   # and the three right pills at the working arm and the spine. Pointing a
   # left pill at a right-side joint is what drags a leader through the
   # face: a 16-character pill at row 0.16 leading puts its leader on the
   # head on 96 of 192 frames pointing at hand_L and 112 at the shoulder,
   # which is why the lockout cue is not up there. THE FACE TEST is against
   # the DRAWN head - the silhouette between the projected top of the skull
   # and the head joint's own row - and not a box around the head joint,
   # which sits at the base of the skull and misses up to 35 px of face in
   # the folded-over set-up pose. As written, all five pills are clear of
   # the load and of the lifter at every frame (load 104.4 / 11.8 / 18.5 /
   # 109.5 / 112.9 px, lifter 13.4 / 7.2 / 11.4 / 25.5 / 150.9 px, in cue
   # order), and no leader lies on the head at any frame. The closest any
   # comes is the free-hand leader at 1.4 px (t 0.71, as the lifter stands
   # up past it), then the lockout leader at 12.0 px and the turnover leader
   # at 18.5. THE PULL PILL IS WHY THIS LAYOUT CHANGED: at row 0.50 leading,
   # where round 1 put it, its leader lay ON the head for 38 of the 192
   # frames - the whole static set-up (0-0.71 s) and the whole return
   # (7.17-7.96 s), which are the first and last stills anyone sees - and
   # row 0.32 leading is worse at 51 frames. Row 0.68 leading is the one
   # slot whose leader never touches the head, and its gutter is narrow, so
   # the label is seven characters: seven clears the lifter by 7.2 px, eight
   # by 1.6 and nine lands on it. Row 0.32 is empty both sides: trailing,
   # the silhouette is in a pill there at every label length; leading, it is
   # the 51-frame slot above.
   overrides={"setup": (0.68, "trailing"), "pull": (0.68, "leading"),
              "turnover": (0.50, "trailing"), "lockout": (0.86, "trailing"),
              "level": (0.14, "leading")},
   annotations=[
       ("setup", "Flat back", "spine"),
       ("pull", "Legs up", "patella_R"),
       ("turnover", "Turn it over", "forearm_L"),
       ("lockout", "Lock it out", "hand_L"),
       ("level", "Stay level", "hand_R"),
   ],
   cues={
       "setup": ("Start Position",
                 "You start low over the bell with a flat back, one hand on the handle and the other hanging free.",
                 "In the model the trunk starts 72 degrees forward with the hips at 56 and the knees at 67 - that is 113 degrees of knee bend, deeper than the barbell snatch starts with, so this is a low squatting start and not a hinge - the pelvis at 0.500 m and the working hand at 0.163 m with its depth at +0.43 m, half a metre forward of where it ends up at the catch, -0.08 m. The first ten frames are identical: it is a set position, not a swing. The bell stays in the left hand for the whole clip and never changes hands mid-rep. The feet are 0.30-0.32 m apart, a little closer than the 0.392 m at the shoulders.",
                 "Rounding the back to reach the bell, or starting with the shoulders already turned toward it.",
                 "Set your feet about hip-width apart, drop your hips and bend your knees until you can take the handle with a flat back, and square both shoulders before you pull."),
       "pull": ("The Pull",
                "The legs and hips do the lifting; the arm stays long until the bell is already moving.",
                "In the model the elbow is locked at 174 degrees for the whole pull and only folds once the bell is past 1.06 m. Below it the knees open from 67 degrees to 165, the hips from 56 to 168, the trunk comes from 72 degrees forward to 5 behind vertical, and both heels lift 5.8 cm - 0.069 m to 0.127 m - together, even though only one arm is loaded. One arm does not make this an arm exercise.",
                "Curling the bell up with the arm instead of driving with the legs.",
                "Push the floor away and stand up hard, keeping the bell close to you and the arm long until your hips have finished."),
       "turnover": ("Turnover",
                    "At the top of the pull the elbow folds and punches through, so the bell finishes above your hand rather than in front of it.",
                    "This is the fastest part of the lift: in the model the elbow goes from 174 degrees to 76 and back out to 134 in a little over half a second while the hand rises from 1.06 m to 1.84 m, and the hand travels 0.35 m back in toward the body as it happens. A motion-capture study of the barbell snatch has the deltoid taking over once the shoulder is more than halfway to full flexion, and the triceps only contracting after the turnover, to keep the arm straightened - so the punch is a turnover under the load, not a press of it.",
                    "Letting the bell swing out and catching it in front of the shoulder with a bent arm.",
                    "As the bell peaks, turn your elbow under it fast and punch your hand straight up, so the bell lands over that shoulder."),
       "lockout": ("Overhead Lockout",
                   "The rep finishes standing tall with the bell locked out over the working shoulder.",
                   "The model holds it for 1.46 s, and from 3.33 to 4.50 s the whole pose stays put to within a millimetre, so it really is a hold rather than a drift: the elbow at 174 degrees, the knee at 175, the trunk upright, the hand 1.967 m up and the bell 0.47 m above the head and 0.23 m out to the working side - over that shoulder, not over the middle of your head. Coming down it racks the bell to the shoulder first: the elbow folds to 31 degrees while both knees hold 174-175 degrees, and the hips only re-hinge once the bell is back at shoulder height.",
                   "Leaning away from the bell to get under it, or holding it up on a soft elbow.",
                   "Stand all the way up with your elbow locked and the bell over that shoulder, hold it until it stops moving, then bring it down to your shoulder before you hinge."),
       "level": ("Shoulders Level",
                 "One bell on one side wants to turn you; the work is keeping both shoulders and both hips facing the front.",
                 "The free arm does nothing in the model - its elbow only drifts between 146 and 170 degrees as the trunk stands up, and that hand never gets above 0.96 m - while the legs stay symmetrical, both knees moving through the same range and both heels leaving the floor together. The paint shows where the resisting happens: the obliques and the rectus abdominis are bright on the side away from the bell. The asymmetry is measurable: on force platforms the one-handed dumbbell snatch made the pull phase significantly longer on the lifting side, while peak force and catch loading rate tended to be higher on the free side without reaching significance, and the authors put that down to the uneven load changing pull and catch symmetry.",
                 "Throwing the free arm to help the bell up, so the shoulders twist with it.",
                 "Let the free arm hang, keep both shoulders and hip bones facing the front, and do the same number of reps on each side."),
   },
   # Rows follow the paint, re-read with tiers.py on 2026-10-30: 13 bright,
   # 10 dim, nothing faint, and the paint is cross-sided. Bright, so
   # primary: the three glutes as one Gluteus Maximus row (one group, not
   # split - owner confirmed 2026-10-30, so the copy says glutes), the three
   # hamstrings, the four quadriceps, and - on the RIGHT only, the side away
   # from the working arm - the external and internal oblique and the rectus
   # abdominis. One-sided paint still gets a whole-muscle row, as on the
   # Suitcase Carry and the Kettlebell Windmill. Dim, so secondary: the
   # erector spinae and the calves on both sides, and on the working side
   # the anterior and lateral deltoid and the three trapezius parts as one
   # Trapezius row, the dim rhomboid major inside it. No biceps paint at
   # all, so there is no Biceps Brachii row, exactly as on the Dumbbell Hang
   # Clean. Fractions: Gluteus Maximus 0.70, Quadriceps 0.62, Trapezius
   # 0.70, Erector Spinae 0.55 and Hamstrings 0.50 are carried from
   # spec_1029_clean.py's PULL_ROWS and through it from Clean and Press -
   # this is the same pull from the floor, and it keeps the two-handed 0.70
   # trapezius rather than the one-arm 0.44 the Kettlebell Snatch takes,
   # because this bell is pulled from the floor and not swung. Obliques 0.60
   # and Rectus Abdominis 0.30 come from the Suitcase Carry, the library's
   # one-arm anchor, where both are live rows after its 2026-10-18 re-paint
   # and the Kettlebell Clean already reuses them; the oblique row is the
   # best-evidenced new row in this family, with Lyons 2017 finding the
   # contralateral external oblique more active in a one-arm snatch than in
   # a swing - which is the side this rig paints - and Lake, Lauder and
   # Dyson 2006 measuring the one-handed dumbbell snatch's effect on pull
   # and catch symmetry. Rectus Abdominis stays an estimate: no normalised
   # EMG of it in a dumbbell snatch exists, and at 0.30 it is a LOW primary,
   # which the paint asks for and which the library already does on the six
   # shrugs (Middle Trapezius 0.30), the three hammer curls (Forearms 0.30)
   # and the Seated Calf Raise - so it is a precedent, not a first. Both
   # entries it is carried from rank it secondary, which the open points
   # flag. Lateral Deltoid 0.45 is the Overhead Carry's and Anterior Deltoid
   # 0.40 the same re-estimate as on the Power Snatch; both rank secondary
   # here because the paint is dim, and the fractions do not move with the
   # rank. Gastrocnemius 0.30 is the judgement call described on the Power
   # Snatch, with the soleus painted dim beside it and named among the
   # stabilisers; this model lifts the same heel, 5.8 cm. The unpainted
   # biceps, triceps, latissimus dorsi and rotator cuff are named among the
   # stabilisers, with the quadratus lumborum from the Suitcase Carry for
   # the one-sided load.
   activation=[("Gluteus Maximus", P, HI, 0.70), ("Trapezius", S, HI, 0.70),
               ("Quadriceps", P, MOD, 0.62), ("Obliques", P, MOD, 0.60),
               ("Erector Spinae", S, MOD, 0.55), ("Hamstrings", P, MOD, 0.50),
               ("Lateral Deltoid", S, MOD, 0.45), ("Anterior Deltoid", S, MOD, 0.40),
               ("Rectus Abdominis", P, LOW, 0.30), ("Gastrocnemius", S, LOW, 0.30)],
   stabilisers=["quadratus lumborum", "forearms", "latissimus dorsi",
                "triceps brachii", "biceps brachii", "rotator cuff", "soleus"],
   comparison=("TWISTING TO THE BELL", "Shoulders square, hips level", "Chest turns toward the bell",
               "Held square, the legs do the lift: the model drives both knees through the same range and both heels leave the floor together, with the free arm hanging.",
               "Turning toward the bell hands the lift to the trunk, and the one force-plate study of this lift found the one-handed load already lengthening the pull on the lifting side."),
   glows=snatch_glows("Dumbbell Snatch", SOFT, 0.28) +
         [glow("Dumbbell Snatch", ["support_PectoralisMajor_Abdominal_R", "spine"],
               A, 0.50, rx=0.07, ry=0.06, dx=-0.03)])

SETUP["Dumbbell Snatch"] = [
    "Stand one dumbbell on the floor just in front of you, with your feet about hip-width apart.",
    "Drop your hips and bend your knees until you can take the handle in one hand with a flat back, and let the other arm hang.",
    "Square both shoulders to the front and brace your trunk before the first pull.",
    "Work the whole set with one hand, then set the bell down and do the same number with the other.",
]

# ---------------------------------------------------- kettlebell snatch

ex(name="Kettlebell Snatch", var="kettlebellSnatch",
   # Rows are the raw 0.14-0.86 scale and render at 0.16, 0.32, 0.48, 0.64
   # and 0.80; measured at the drawn pill (half-height 0.025 in v) over all
   # 192 frames against the six bell meshes and the skinned silhouette. The
   # load is the smallest of the three and the only one that leaves a whole
   # row alone: the bell sweeps u 0.244-0.794 and v 0.089-0.759, so row 0.80
   # is never reached - 27 px above the row's centre line and 10.5 px above
   # a drawn pill's top edge at the 0.025 half-height used throughout - and
   # the foot and knee pills share it, one each
   # side, as the clean family does with its bottom row. On row 0.16 the
   # bell parks at u 0.421-0.794 through the lockouts, so the top row is
   # clear on the LEFT only. Row 0.32 trailing, which round 1 left empty for
   # the head, is in fact the best remaining slot: the head is in that row on
   # 168 of 192 frames but keeps to u 0.361-0.634 while a trailing pill
   # starts at 0.741, and the whole lifter leaves 10.8 px there at its
   # worst frame. Row 0.64 is empty
   # instead - at the eleven characters this family's labels run to, a pill
   # there leaves only 3.9 px of lifter clearance on the trailing side and
   # lands on the lifter on the leading side, against 10.8 px at row 0.32
   # trailing. Measured against the 655-row silhouette, all five pills are
   # clear of the bell and of the lifter at every frame (bell 103.0 / 56.1 /
   # 60.3 / 23.3 / 61.5 px, lifter 34.9 / 27.1 / 10.8 / 52.2 / 12.6 px, in
   # cue order). Four of the five leaders never touch the lifter's head.
   # THE LOCKOUT LEADER IS THE ONE COMPROMISE: it has to follow a hand that
   # goes from the thigh to overhead three times, so it lies on the head for
   # 24 of 192 frames (1.00 s) in twelve short runs, each a few frames as
   # the hand passes the head on the way up or down. Seventeen characters is
   # as good as any shorter label there (24 frames at seventeen and at
   # fifteen, 39 at eleven, because a longer pill starts nearer the hand),
   # and seventeen is what the words need. One slot does better - row 0.64
   # trailing at eleven characters, 12 frames - but it leaves 3.5 px of
   # lifter clearance against 52.2 px here, so it is not taken. Worth a look
   # on the simulator; see the open points.
   overrides={"hinge": (0.50, "trailing"), "swing": (0.86, "trailing"),
              "insert": (0.32, "trailing"), "lockout": (0.14, "leading"),
              "base": (0.86, "leading")},
   annotations=[
       ("hinge", "Hips back", "pelvis"),
       ("swing", "Bell close", "patella_L"),
       ("insert", "Let it roll", "forearm_L"),
       ("lockout", "Stack it overhead", "hand_L"),
       ("base", "Heels stay down", "foot_R"),
   ],
   cues={
       "hinge": ("Hip Hinge",
                 "Every rep is a hinge: the hips go back, the knees bend only part way, then the hips snap through.",
                 "In the model the trunk folds to 55 degrees from vertical with the hips at 93, and the knees never bend past 107 - about half the bend the barbell snatch starts from - while the pelvis drops only 0.16 m, from 0.875 m to 0.720. Then it all opens again inside half a second: the hips to 169 degrees, the knees to 174 and the trunk to 1 degree from vertical. The bell arrives overhead on that snap. The low back is not heavily loaded either way: in the one study to measure it, a one-arm swing finished overhead kept L4/L5 compression under 3,200 N in every style at every point, which the authors call quite conservative and probably not of clinical significance.",
                 "Squatting the bell down and up, or pulling it overhead with the arm.",
                 "Push your hips back with a flat back, let the bell swing between your thighs, then drive the hips through and let the bell float up."),
       "swing": ("Bell Path",
                 "The bell drops back between your thighs and comes up close to you: drive it up, not out.",
                 "The model's bell covers 4.94 m of path in every rep, through a range of 1.709 m up and down, 0.693 m front to back and 0.464 m across the body, and at the bottom of the backswing it hangs between the legs at 0.323 m, 0.27 m from the working hand and touching nothing - the nearest thing to it is the far foot, 0.30 m away. Up and out are not the same thing: measured on a force platform, a one-handed kettlebell snatch put about 14% of its impulse into horizontal work against 23% for a two-handed swing, so the snatch is the more vertical of the two.",
                 "Swinging the bell out in front, so it loops away from you and flips over at the top.",
                 "Hike the bell back between your thighs, keep it brushing close to you on the way up, and send it straight up over your shoulder."),
       "insert": ("Hand Insertion",
                  "Near the top you let your hand slide through the handle so the bell rolls around onto your forearm.",
                  "The bell turns over around the hand rather than being held still: in the model it sits 0.27 m from the hand at the drop, passes within 0.115 m at the turnover and settles 0.12 m away through the lockout, and the elbow folds to 55 degrees as it goes past the head. Hand insertion is one of the named phases of a competition rep, and your grip is what pays for the set - over a six-minute set with a hand change at halfway, the hand that worked the last three minutes lost about 10 kg of grip strength - so let the bell settle on the forearm instead of gripping it hard.",
                  "Gripping hard all the way up, so the bell flips over the hand and bangs down on the wrist.",
                  "As the bell comes up, open your hand a little and let the handle turn in it so the bell rolls onto your forearm, then close your fingers to hold it."),
       "lockout": ("Overhead Fixation",
                   "Each rep finishes with the bell held still overhead, stacked over your shoulder and your foot.",
                   "The model holds it for 0.88 s a rep, and a third of the whole clip is spent up there: the elbow at 175 degrees, the hand 1.965 m up - 0.368 m above the head and 0.536 m above the shoulder joint - and only 1.5 cm to the side of the shoulder and 2.1 cm to the side of the ankle, so the load is stacked over the base. In kettlebell sport a rep only counts once the bell is locked out motionless overhead, and that overhead fixation is described as one of the two points of relative relaxation in the whole repetition.",
                   "Pressing the bell up at the top, or holding it out in front of the shoulder.",
                   "Punch your hand up as the bell arrives, lock the elbow, and let it sit still over your shoulder for a moment before the next rep."),
       "base": ("Base",
                "Both feet stay planted about shoulder-width apart and the heels barely move.",
                "The model keeps both ankles inside 0.07-0.08 m for all 192 frames: the heel lifts 1.4 cm at the top of each pull against 6.1 cm in the barbell snatch, the feet stay 0.38-0.39 m apart against 0.392 m at the shoulders, and in the frame each foot holds its place to within three pixels. That is the difference between this and the barbell snatch - and the rig paints no calf here, where it paints them on both of the others. Press the floor away evenly: in a six-minute set of kettlebell-sport snatches the two legs were measured carrying different front-to-back loads inside every rep.",
                "Coming up onto the toes, or letting a foot shuffle as the bell swings.",
                "Plant both feet about shoulder-width apart, keep your heels down through the swing, and press evenly through both feet."),
   },
   # Rows follow the paint, re-read with tiers.py on 2026-10-30: 6 bright,
   # 16 dim, nothing faint. The anchor is the Kettlebell Swing rather than
   # the cleans, because this is a hinge and a swing and not a pull from the
   # floor. Bright on both sides, so primary: the three glutes as one
   # Gluteus Maximus row (one group, not split - owner confirmed 2026-10-30)
   # and the three hamstrings. Dim, so secondary: the erector spinae and the
   # four quadriceps on both sides, and on the working LEFT side only the
   # anterior and lateral deltoid, the three triceps heads, both biceps
   # heads, the three trapezius parts as one Trapezius row and the rhomboid
   # major inside it. Gluteus Maximus 0.80, Hamstrings 0.76 and Erector
   # Spinae 0.50 are carried unchanged from the Kettlebell Swing, on that
   # carry and this model's paint and NOT on any swing-against-snatch
   # contrast: McGill and Marshall 2012 found a significant exercise effect
   # on only three muscles, none of them a glute or a hamstring, and its
   # post hoc tests put both significant differences on the swing with Kime
   # rather than on the snatch - its glute column falls from 76.1 to 58.1%
   # MVC with a standard deviation of 48.9, while the paper's own text says
   # the swing to snatch appears to increase the activation of almost all
   # muscles. Lyons 2017 likewise found no difference between swing, snatch
   # and clean in the gluteus maximus or biceps femoris, and the erector
   # spinae GREATER in the swing. So the carried numbers are held where they
   # are because nothing measured moves them. Quadriceps 0.53 is a new row
   # and an estimate: the row exists because this rig paints the four
   # quadriceps dim where the Kettlebell Swing's model does not paint them
   # at all (its quadriceps row was removed when they went unlit), and 0.53
   # is anchored to McGill's rectus femoris mean of 53.4% MVC in the
   # swing-to-snatch against 33.5 in the plain swing - a non-significant
   # table difference in seven subjects with standard deviations of 22, and
   # Lyons 2017's only vastus lateralis finding is Swing > CLEAN with no
   # snatch-against-swing difference at all, so the number may well be too
   # high. See the open points. Trapezius 0.44 is the Suitcase Carry's
   # one-arm value, which the Kettlebell Clean already carries, not the
   # cleans' 0.70: there is no shrug under a bell that is being swung, and
   # the Kettlebell Swing keeps the trapezius a stabiliser. Lateral Deltoid
   # 0.45 is the Overhead Carry's. Triceps Brachii 0.40 is an estimate, and
   # a row here only because this is the one model of the three that paints
   # the triceps; Wu 2008 has the triceps contracting after the turnover to
   # keep the arm straight but publishes no percentage, so 0.40 is set below
   # the library's own loaded-triceps numbers - the Clean and Press's 0.55
   # and the Barbell Overhead Press's 0.58, both of which press a bar - and
   # above nothing, because the two barbell and dumbbell snatches here have
   # no triceps row to compare with. Anterior Deltoid 0.30 is the cleans'
   # estimate and deliberately the lowest of the three snatches: Lyons 2017
   # found no anterior-deltoid difference between swing, snatch and clean,
   # and Ross 2017 calls the overhead fixation a point of relative
   # relaxation, so the bell arrives on hip drive and the shoulder does not
   # press it. Biceps Brachii 0.30 is carried from PULL_ROWS, and so from
   # Clean and Press, with Wu 2008's early-sequence biceps behind it.
   # THE ROWS THIS MODEL DOES NOT GET are the interesting ones: the rig
   # paints no oblique and no rectus abdominis, so the Suitcase Carry's
   # Obliques 0.60 and Rectus Abdominis 0.30 are NOT carried here even
   # though this is the lift the oblique evidence was measured on - Lyons
   # 2017 found the contralateral external oblique higher in the snatch than
   # the swing, and McGill's internal oblique read 53.6 and 53.2% MVC
   # against 42.4 and 30.2 - and both are named among the stabilisers
   # instead, with the paint and the evidence disagreeing, as the Deadlift's
   # removed Erector Spinae row already does in the library. See the open
   # points. The forearms are a stabiliser on measured grounds rather than
   # assumed ones (Ross 2017's 9.8 kg grip-strength drop), the quadratus
   # lumborum on Ross's leg-to-leg force asymmetry inside every rep, the
   # adductors because this rig does not paint them where the Kettlebell
   # Swing's does at 0.38, and the calves because the heel barely leaves the
   # floor in this clip and no calf is painted.
   activation=[("Gluteus Maximus", P, HI, 0.80), ("Hamstrings", P, HI, 0.76),
               ("Quadriceps", S, MOD, 0.53), ("Erector Spinae", S, MOD, 0.50),
               ("Lateral Deltoid", S, MOD, 0.45), ("Trapezius", S, MOD, 0.44),
               ("Triceps Brachii", S, MOD, 0.40), ("Anterior Deltoid", S, LOW, 0.30),
               ("Biceps Brachii", S, LOW, 0.30)],
   stabilisers=["obliques", "rectus abdominis", "quadratus lumborum", "forearms",
                "adductors", "calves"],
   comparison=("SWINGING IT OUT", "Bell close, driven straight up", "Bell loops out and flips down",
               "Kept close and driven up, the bell rolls around the hand and settles on the forearm: the model sends 4.94 m of bell path through every rep without letting it get away.",
               "Let out in a loop, it flips over the hand onto the wrist instead of rolling round it, and the grip pays for that - the hand that finishes a six-minute set has already lost about 10 kg of it."),
   glows=snatch_glows("Kettlebell Snatch", SOFT, 0.28, 0.07))

SETUP["Kettlebell Snatch"] = [
    "Stand a kettlebell on the floor a little in front of you and set your feet about shoulder-width apart.",
    "Hinge at the hips with a flat back, take the handle in one hand and tilt the bell toward you.",
    "Hike it back between your thighs to start the first swing, with the free arm hanging at your side.",
    "Work one side for the whole set, then set the bell down and swap hands.",
]
