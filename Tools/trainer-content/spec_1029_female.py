# « # Trainer content for the model-only exercises of 2026-10-29, family
# "female": the three lifts exported from the Desktop "Women exsercise"
# folder on 2026-10-18 and added to the library with their models alone -
# Vertical Hack Squat (Legs/FemaleVerticalHackSquatStandard, the Standard
# model of five stances), Standing Hinge Kickback
# (Legs/StandingHingeKickback) and Incline Bench Cable Kickback
# (Legs/InclineBenchCableKickback). The exercise entries went in at
# SampleData.swift lines 303-312 under a comment that says it plainly -
# models only for now, no trainer content yet - and this is that content.
# They are the app's only three lifts whose model is the female body, which
# is also why the 300-400 swap dropped its own Standing Cable Hip Extension
# on 2026-10-19: these kickbacks cover it, so the standing version's rows
# are carried from Cable Knee-Drive Kickback instead. Being the female model
# changes nothing about the copy. Every lift in the library is written in the
# second person with no gendered framing, and it stays that way here: the
# user-facing strings were grepped for she / her / hers before shipping and
# carry none. Only two of the sources below used female samples (Contreras
# 2015, 13 trained women; Aygun-Polat 2025, 21 trained female athletes),
# neither compared the sexes, and every hack squat and stance-width source
# read for this family is male or male-dominant, so nothing anywhere in
# these three entries is said about women in particular.
# Same format as spec.py on top of common_1_50.py; spec_1029.py imports this
# module and gen.py reads SPEC / SETUP. notes_1029_female.md maps every claim
# in the copy to the sources below or to a model measurement.
#
# Written the way the README asks for a family: drafted from the rigs and the
# literature, with the paint deciding every rank - which is what puts a
# PRIMARY Hamstrings row on the Standing Hinge Kickback, a first for the
# library's kickbacks, and what keeps the quadriceps off the Incline Bench
# Cable Kickback's rows although its knee opens 92 degrees under load. Both
# calls, and the Vertical Hack Squat's bright-but-unrowed gluteus medius, are
# in notes_1029_female.md as open points rather than buried.
#
# What the models show, measured from the rigs with Blender's Python + pxr.
# Every angle, travel and time below was re-measured at INTEGER FRAMES with
# the round folder's fix/rig.py, fix/hip.py, fix/dwell.py and fix/period.py,
# because summ.py steps by fps*0.0417 = 1.0008 frames and so drops a frame
# and mistimes flat series; prop figures come from props2.py (props.py
# differences only two samples) and nearest-joint figures from
# nearest_both.py and fix/nearprop.py (nearest.py's joint list is left-only).
# Frame: Y up, metres. The two kickbacks follow the library's usual
# convention - the lifter faces +z and their left is +x - but THIS FAMILY'S
# THREE RIGS ARE NOT ALIGNED WITH EACH OTHER: the Vertical Hack Squat is
# turned a quarter turn (its left-right axis is Z, shoulders at z -0.196 and
# +0.196, and forward is X), and the Incline Bench Cable Kickback is turned a
# half turn (left is -x, forward is -z). Each bullet names its own axes where
# a figure depends on them. Knee = thigh-shin inner angle (180 straight).
# Hip = the angle at the hip between the trunk line (pelvis to neck) and the
# femur (thigh to shin), so 180 is the thigh in line with the trunk; where a
# figure comes from summ.py's chest-thigh-shin angle instead it is named as
# such, because that one moves when the knee moves. Trunk = the neck-over-
# pelvis line from vertical. All three clips run 7.9583 s at 24 fps, hold
# two identical reps, and repeat exactly every 4.00 s - a 96-frame lag
# reproduces every joint position to 0.000000 m on all three. »
#
# - Vertical Hack Squat (yaw -1.0, zoom 1.021, offset [0.066, -0.177,
#   -0.103]; a rear three-quarter view, from behind the lifter and a little
#   to their left, standing inside the machine). A lever-arm vertical hack
#   squat, fully modelled: 149 machine meshes of the file's 316, every one
#   of them named VHS_*_Mesh, which is why props.py sees none of them.
#   The lifter stands on a footplate that never moves (0.61 x 0.19 x 0.66 m
#   at [-0.42, 0.40, 0.00], travel 0.0 cm) with the feet a fixed 0.2624 m
#   apart - that separation is entirely in Z, this rig's left-right axis -
#   under a shoulder-pad carriage they also grip. The two pads (0.42 x 0.19
#   x 0.14 m each, centres z -0.21 and +0.21) sit across the top of the
#   shoulders: each pad's own volume contains both upper_arm_L and
#   scapula_L, at 0.000 m surface distance, with its centre 0.044 m from the
#   shoulder joint and 0.101 m from the shoulder blade. THERE IS NO BACK
#   PAD: the nearest machine mesh to the spine joint is a lever arm at
#   0.227 m at the top of the rep and 0.303 m at the bottom, and nothing
#   comes nearer at any time, so the back is upright under the pads rather
#   than against the machine. The hand grips (0.14 x 0.04 x 0.04 m) take
#   hand_L as their nearest joint at 0.11 m, the next joint being forearm_L
#   at 0.36 m. Twenty-nine meshes move: both pads, the shoulder crossbar,
#   both grips, the handle elbows and drops, both carrier sides, four
#   working plates, the load horns and the moving axles - 21 in all - drop
#   together as one rigid carriage, 29.6 cm straight down (delta [+0.02,
#   -0.30, -0.00], peak 1.99 s); the lever arms carrying it swing 21.2, 14.8
#   and 6.4 cm; and the two rest pins drop 4.8 cm with it. The other 120
#   meshes - mast, stands, base, rest hooks, release handle, stored plates
#   and all 63 VHS_Tread pads - read 0.0 cm.
#   Top (0, 4 s): knee 166.983 degrees, hip 160.484, the chest-thigh-shin
#   angle 157.534, pelvis 1.3971 m, the knees 0.2400 m apart. Bottom: knee
#   87.677 - a 79.306 degree range - hip 115.511 (44.97), chest-thigh-shin
#   121.934 (35.60), pelvis 1.1009 m, so the hips drop the carriage's own
#   29.62 cm, and the knees 0.3322 m apart: they spread 9.2 cm, start 2.2 cm
#   INSIDE the feet and finish 7.0 cm wider. Each knee also travels 27.9 cm
#   forward along X and 5.4 cm down. The bottom is held nine frames, 2.000 to
#   2.333 s and 6.000 to 6.333 s (0.375 s); descent 2.00 s, ascent 1.67 s,
#   two reps on an exact 4.00 s cycle, 7.9583 s at 24 fps (192 frames).
#   The two sides are identical to five decimal places - max absolute knee_L
#   minus knee_R is 0.000055 degrees over all 192 frames, a property of an
#   export driven from one curve rather than evidence about a lifter.
#   The trunk never leaves vertical: it holds 0.49 degrees off it, unchanged
#   in every frame. (summ.py prints 0.00 to -0.00 for this model because its
#   trunk term reads the Z component, which on this quarter-turned rig is
#   sideways lean, not forward lean.) The arms are frozen: elbow 72.090
#   degrees, upper-arm pitch -36.93, hand separation 0.3588 m and hand z are
#   all single-valued, so the hands fall the carriage's 29.62 cm as
#   passengers. Shoulder separation 0.3922 m never changes either, and in the
#   frame both feet hold one pixel for the whole clip (foot_L 0.580, 0.808;
#   foot_R 0.420, 0.819).
#   Paint: seven bright muscles and no dim or faint tier at all - gluteus
#   maximus, medius and minimus, and all four quadriceps heads (rectus
#   femoris, vastus lateralis, medialis and intermedius) - on both sides.
#   The hamstrings, adductors and calves are unpainted, so they are named
#   among the stabilisers rather than given rows. On screen the bright tier
#   is 5152-5681 px and almost all of it is thigh: only 0.0, 2.8, 13.5 and
#   6.9 per cent of it sits above the pelvis in the four stills.
# - Standing Hinge Kickback (yaw -1.0, zoom 0.556, offset [-0.042, 0.049,
#   0.066]; the lifter faces left across the frame, hinged forward, filling
#   only the left half and the top three quarters - ink is 12.4-13.1% and
#   the bottom 188 px of the 655 are empty in every frame). A cable stack
#   with an ankle cuff on the LEFT ankle, worked from a fixed forward hinge.
#   100 non-body meshes, not props.py's 95: the cable machine under
#   GYM_M29_Root is 87 of them (63 GYM_M29 parts plus 24 Cyl cable beads),
#   the ankle cuff root holds 11 (10 GYM2 pieces plus CSD_SnapClip_Tube) and
#   the right foot stands on a round platform of 2 (CSD_RightFoot_Plate and
#   _PlateHub). props.py drops exactly the five cuff pieces whose names end
#   _Mesh - the parts the whole attachment story is about.
#   Trunk 67.509 degrees forward of vertical and pelvis 1.0901 m, both
#   constant to the frame; both hands still on the machine upright 0.1199 m
#   apart (hand_L [0.060, 1.164, 0.691], hand_R [-0.060, 1.172, 0.690]),
#   0.483 m in front of the shoulders and 0.095-0.096 m below them.
#   The cuff rides the working foot: its lower edge binding stays 0.01 m from
#   foot_L at every sampled moment (next nearest toe_L 0.15 m, shin_L
#   0.48 m), the padded band 0.05-0.06 m, the velcro overlap 0.07 m, the
#   swivel eye 0.09 m and the snap clip 0.08-0.12 m. The cuff cluster
#   travels 109.2-127.9 cm, peaking at 1.99 s, and the stack plates rise
#   54.0 cm - both from props2.py's 17-sample scan, which the rig confirms:
#   the ankle's own straight-line excursion is 1.29 m. (props.py reports
#   45.2-49.5 cm and 23.3 cm for the same meshes because it differences only
#   t0 and t 3.18 s, which lands partway down a descent.) The handle cable's
#   bounding box stretches from 0.73 m at the bottom through 1.35 m at 1.0 s
#   to 1.68 m in Z at the 2.0 s apex. The cable touches nothing, but its
#   nearest joint at the top is on the STANDING leg: toe_L 0.38 m at the
#   bottom, then shin_R 0.18-0.19 m and patella_R 0.21 m at the top, with
#   thigh_L only fourth at 0.46-0.49 m. The stack cable stays 1.25-1.32 m
#   from the lifter.
#   Bottom (0, 4 s): hip 100.491 degrees, chest-thigh-shin 104.413, knee
#   154.000, the ankle at [0.053, 0.153, -0.217]. Apex of the foot (2, 6 s):
#   the ankle at [0.053, 1.041, -1.155] - it rises 88.8 cm and travels
#   93.8 cm rearward with no lateral drift at all, its x fixed at 0.053 -
#   and knee 170.000, its one-frame maximum.
#   The hip and the foot do not peak together, and this is the entry's
#   mechanism: the true hip angle reaches 179.275 degrees at 1.500 s, which
#   is the thigh in line with the trunk, then eases back to 165.509 at the
#   foot's apex half a second later while the knee goes on extending from
#   167.7 to 170.0. So the thigh does come into line with the trunk, and the
#   last of the foot's travel is knee extension, not hip extension.
#   (summ.py's chest-thigh-shin term peaks at 158.825 at 1.4167 s and gives
#   7.3 degrees back by the apex - the same shape, a different quantity, and
#   it is not a hip angle: the knee is 26 degrees bent at the start and
#   feeds straight into it.) And the knee never straightens: 154 degrees at
#   the bottom and still 10 degrees short of straight at the apex.
#   Everything else is frozen for the whole clip. The support side reads
#   knee 160.000 and chest-thigh-shin 106.268 at every sample, both arms
#   hold elbow 137.766 and 150.642 degrees and upper-arm pitch -28.60 and
#   -22.67, and the hand (0.1199 m) and shoulder (0.3922 m) separations
#   never change. In the frame ten of the thirteen probed joints are single
#   static points: only patella_L, shin_L and foot_L move at all. The ankle
#   and knee separations (0.184 m to 1.323 m, 0.184 m to 0.707 m) are 3D
#   distances made almost entirely of the kick's own reach - the across-body
#   component holds 0.183 m and 0.204 m throughout - so they are not stance
#   widths and no copy uses them.
#   Paint: six bright muscles, all on the working (left) side - gluteus
#   maximus, medius and minimus, biceps femoris, semitendinosus and
#   semimembranosus - with nothing dim and nothing faint, which is what
#   makes the hamstring row primary here.
# - Incline Bench Cable Kickback (yaw -1.3, zoom 0.518, offset [-0.023,
#   0.044, 0.081]; the lifter lies chest-down along an incline bench that
#   rises to the right, head high and to the right, both arms reaching
#   forward to the machine upright at the right edge, the working leg
#   sweeping the left half - the whole body spans only v 0.335-0.669 and ink
#   is 14.4-14.7%). This rig is turned a half turn: left is -x and forward
#   is -z. 179 non-body meshes, not props.py's 170: the incline bench is 81
#   of them (under BP34_CTRL, 21 named BP34 parts plus 28 Cube and 26
#   Cylinder prims - the cubes are the bench pad, not loose geometry, and
#   Cube_897 is what the pelvis rests on - plus 6 standalone BP34 feet and
#   posts), the cable machine 87 (63 GYM_M29 parts plus 24 Cyl beads) and
#   the ankle cuff 11 (10 GYM2 pieces plus IBK_SnapClip_Tube). props.py
#   drops the four BP34 and five cuff meshes whose names end _Mesh.
#   Single leg, RIGHT only, from a trunk-supported position: trunk -44.509
#   degrees and pelvis 0.9875 m, both constant in all 192 frames, both hands
#   fixed on the machine (hand_R [0.355, 1.407, -1.016], hand_L [-0.177,
#   1.041, -0.646]) and the resting left leg frozen at knee 116.831 and
#   chest-thigh-shin 158.689 degrees. What that leg rests on is now
#   measured: its KNEE is on the pad, 0.008 m from Cube_897 and 0.020 m from
#   Cube_905, while its FOOT touches nothing at all - the nearest mesh to
#   foot_L is 0.227 m away - so it lies along the pad with the foot hanging
#   free past the end. The pelvis is on the pad at 0.000 m (Cube_897) and
#   0.006 m (BP34_Backrest_Edge_Seam), the chest at 0.037 m.
#   The cuff rides the working foot exactly: the lower edge binding 0.01 m
#   from foot_R at every sampled moment, the velcro overlap 0.07 m and the
#   snap clip 0.11 m, all constant. The cuff pieces travel 98.7-103.2 cm,
#   the snap clip 103.0 cm and the stack plates 46.0 cm. The cable runs past
#   the leg without touching it: nearest shin_R 0.22 m and patella_R 0.24 m
#   at the bottom, thigh_R 0.33 m and pelvis 0.35 m at the top.
#   Bottom (3.750-4.250 s, thirteen frames, 0.542 s, and the wrapped halves
#   at 0.000-0.250 and 7.750-7.958 s): knee 80.000 degrees, hip 73.949, the
#   chest-thigh-shin angle 83.518, the ankle at [0.332, 0.386, -0.294].
#   Finish (1.750-2.083 s and 5.750-6.083 s, nine frames, about a third of a
#   second): knee 172.000 - 92.0 degrees of travel - and the ankle at
#   [0.265, 0.628, 0.704]: 99.8 cm further from the stack (which sits at
#   z -1.40), 24.2 cm up from the bottom and 6.7 cm across. Over the whole
#   clip the ankle's vertical range is 39.4 cm, because it dips to y 0.234
#   around 3.0 s on the way down.
#   As on the standing version the finish is knee rather than hip, but this
#   lift stops further short of the trunk line: the true hip angle peaks at
#   173.973 degrees at 1.375 s and has fallen to 160.217 by the held finish,
#   twenty degrees short of in line, while the knee goes on extending to
#   172. A thigh genuinely in line with this trunk would need about 45
#   degrees of hip hyperextension, which is why the copy cues the hip
#   stopping and not a line. (summ.py's chest-thigh-shin term peaks at
#   166.215 at 1.2917 s and falls to 149.7 by the finish.) Two reps on an
#   exact 4.00 s period, 7.9583 s at 24 fps, 192 frames - not the 3.98 s and
#   191 samples summ.py prints.
#   Nothing above the hips moves, and nothing on the left side: knee_L
#   116.831, chest-thigh-shin_L 158.689, both elbows (75.557 and 166.289),
#   both upper-arm pitches (-20.30 and +6.31), the hand (0.744 m) and
#   shoulder (0.392 m) separations and pelvis height all print min = max =
#   start. In the frame every probed joint but the right leg has eight
#   identical samples. The knee and foot separations are 3D distances
#   dominated by Z (at the bottom ankle_L is [0.060, 0.692, 0.579] and
#   ankle_R [0.332, 0.386, -0.294], so dz 0.873 of the 0.965 m total against
#   dx 0.272), so they are not stance widths and no copy uses them.
#   Paint: the three glutes bright on the working (right) side, the three
#   hamstrings dim on that side, nothing faint. The quadriceps are unpainted
#   although the knee opens 92 degrees under cable load, so they are named
#   among the stabilisers instead of given a row. On screen the bright glute
#   paint is small and goes behind the body at the apex: 60, 70, 0 and 44 px
#   in the four stills. The dim hamstring paint is 454, 585, 418 and 602 px
#   and sweeps 0.38 of the frame's width with the thigh.
#
# Sources (what each is used for is in notes_1029_female.md):
# - Stien N, Saeterbakken AH, Andersen V 2021, J Sports Sci Med 20(1):56-61,
#   doi 10.52082/jssm.2021.56, PMID 33707987, PMC7919354 (full text read
#   2026-10-29): fifteen resistance-trained men, three reps at a unilateral
#   6RM on a leg press, a knee extension and a Technogym kickback whose hip
#   travelled 90 to 180 degrees with the working knee held semi-extended at
#   about 170; EMG of five muscles, normalised to each muscle's own MVIC.
#   Gluteus maximus kickback 77.0% (95% CI 53.4-100.7) against leg press
#   88.0% (47.7-128.3), p = 0.898, ES 0.08 - no difference. Biceps femoris
#   kickback 106.5% (72.4-140.7) against 30.6% (19.7-41.4), 76.0% higher,
#   p < 0.001, ES 2.27. IMPORTANT, and the reason the copy was rewritten:
#   its statistics section says paired samples t-tests compared EMG
#   amplitude BETWEEN EXERCISES, and no comparison was made between muscles
#   within one exercise, so 106.5% against 77.0% is not a test this paper
#   ran - two values normalised to two different maximal efforts, with
#   overlapping confidence intervals. Used for the Gluteus Maximus 0.84 row
#   on both kickbacks, for the Working Knee cue on the Standing Hinge
#   Kickback (its 170 degree working knee is that model's apex), and as the
#   second-named rather than the leading warrant for the primary Hamstrings
#   row.
# - Orishimo KF, McHugh MP 2015, J Strength Cond Res 29(3):772-778,
#   doi 10.1519/JSC.0000000000000666, PMID 25226327 (abstract read
#   2026-10-29): twelve healthy subjects, four eccentrically biased
#   exercises - resisted hip extension, the diver, the glider and the
#   slider. Hamstring activity exceeded gluteus maximus WITHIN the same
#   exercise during resisted standing hip extension, the glider and the
#   slider (p < 0.001), but not the diver (p = 0.087). Reported for the
#   hamstrings as a group, with no %MVIC values. This is the only source in
#   the family that tests hamstring against gluteus maximus inside one
#   exercise, so it is the leading warrant for the Standing Hinge Kickback's
#   primary Hamstrings row and the reason that lift is not written as glute
#   isolation.
# - Contreras B, Vigotsky AD, Schoenfeld BJ, Beardsley C, Cronin J 2015,
#   J Appl Biomech 31(6):452-458, doi 10.1123/jab.2014-0301, PMID 26214739
#   (abstract read 2026-10-29): thirteen trained women at an estimated 10RM.
#   Lower gluteus maximus 86.8% mean MVIC in the barbell hip thrust against
#   45.4% in the back squat, upper 69.5% against 29.4%, biceps femoris 40.8%
#   against 14.9%. Supports a horizontal-vector hip extension - mechanically
#   what a kickback is - as glute-maximus-primary with the hamstrings
#   clearly co-active, and is one of only two female-sample sources here.
# - Aygun-Polat E, Guzel NA, Guruhan S, Polat Y, Karatas N 2025, BMC Sports
#   Sci Med Rehabil 17(1):251, doi 10.1186/s13102-025-01306-z, PMID 40867012,
#   PMC12382192 (full text read 2026-10-29): 21 trained female athletes,
#   trunk flexed 40 degrees by goniometer against upright, eccentric RMS
#   normalised to MVIC. Gluteus maximus 16.25 to 21.32 %MVIC (p = 0.024),
#   biceps femoris 14.46 to 20.98 (p = 0.015), rectus femoris 52.22 to 75.91
#   (p = 0.023), gluteus medius 31.08 to 27.26 (ns), erector spinae 29.95 to
#   35.14 (ns). A Bulgarian split squat, not a kickback - the closest
#   studied variant, and the copy names the exercise, says the hamstrings
#   rose as much as the glute, and says nobody has measured a hinge as deep
#   as this model's 67.5 degrees. Also used three times as counter-evidence:
#   no gluteus medius claim, no claim that the hinge spares the lower back,
#   and no quadriceps row on the bench kickback.
# - Shin SS, Yoo WG 2025, J Back Musculoskelet Rehabil 38(5):1051-1062,
#   doi 10.1177/10538127251323114, PMID 40152282 (abstract read 2026-10-29;
#   full text paywalled, so no %MVIC values or pelvic-tilt degrees were
#   readable): 38 asymptomatic young adults, five prone hip exercises -
#   knee-extended (PHEKE), 90 degrees of knee flexion with the hip abducted
#   0, 15 and 30 degrees, and 90 degrees of knee flexion with the trunk
#   supported on the table (PHEKFTS). Upper and lower gluteus maximus were
#   both highest in PHEKFTS; biceps femoris and the BF/Gmax ratio were both
#   significantly higher in PHEKE, the knee-extended version; the authors
#   recommend PHEKFTS on its erector-spinae-to-Gmax ratio. The premise of
#   the Incline Bench Cable Kickback's Trunk cue, attributed there as a
#   five-way comparison and never restated as a global maximum: the bench
#   lift's trunk is 44.5 degrees from vertical, so it is not prone, and
#   Macadam below lists prone variants above PHEKFTS's own family.
# - Macadam P, Feser EH 2019, Int J Sports Phys Ther 14(1):14-31, PMID
#   30746289, PMC6350668 (full text, Table 3 and Appendix 1, read
#   2026-10-29): systematic review, 39 studies, bodyweight exercises, all
#   normalised to MVIC. Gluteus maximus by force vector: vertical mean
#   33.4%, anteroposterior 32.8%, posteroanterior (the kickback direction)
#   30.4% - and its own posteroanterior average is internally inconsistent
#   across three places (30.4 / 30.5 / 31.5%). Within prone hip extension,
#   Table 3's POOLED values are knee-flexed 90 degrees 18.6 +/- 4.5% against
#   knee-extended 15.5 +/- 2.8%; the often-quoted 23.1% and 12.7% are one
#   included study's figures (Sakamoto, Appendix 1, 23.1 +/- 21.2 and
#   12.7 +/- 8.6) and are attributed that way in the notes. Upper body on a
#   table pools at 53.1 +/- 9.2%, but it is NOT the top of the prone family:
#   body on floor reads 56.5 +/- 20.2% and upper body on a table with the
#   contralateral knee flexed on a chair 66.4 +/- 25.8%. So the review
#   supports the bent-knee direction and a trunk-supported prone hip
#   extension being strong, and nothing here is printed in the copy as this
#   lift's own number or as any kind of maximum.
# - Song HS, Jeon IC 2026, J Back Musculoskelet Rehabil 39(6):2040-2050,
#   doi 10.1177/10538127261457488, PMID 42249789 (abstract read 2026-10-29;
#   full text paywalled, no %MVIC means readable): twenty healthy males,
#   prone hip extension WITH RECIPROCAL INHIBITION using a non-elastic band
#   (PHERI, a rehab protocol rather than plain prone hip extension) at 60,
#   90 and 120 degrees of knee flexion. Gluteus maximus significantly higher
#   at 90 than at either 60 or 120, with 60 and 120 not differing; biceps
#   femoris lower at 90 than at 120. THERE IS NO KNEE-EXTENDED CONDITION and
#   the gluteus maximus result is not monotonic in knee flexion, so this
#   paper cannot support a bent-versus-straight claim and is no longer used
#   for one. It is cited only for what it found: the glute peaked at
#   90 degrees of knee bend and fell at both 60 and 120.
# - Boren K, Conrey C, Le Coguic J, Paprocki L, Voight M, Robinson TK 2011,
#   Int J Sports Phys Ther 6(3):206-223, PMID 22034614, PMC3201064 (abstract
#   read 2026-10-29): 24 healthy subjects, 18 exercises, surface EMG as
#   %MVIC. A single-limb SQUAT - a dynamic descent and rise under
#   bodyweight - put the support leg's gluteus medius at 82% and its gluteus
#   maximus at 71%. The Standing Hinge Kickback's standing-leg glutes
#   stabiliser; its figures are no longer printed in the Standing Leg cue,
#   because that model's support leg is a motionless hold (knee 160.000 and
#   chest-thigh-shin 106.268 at every sample) and a squat is a harder task.
#   Deliberately not applied to the bench kickback at all, whose non-working
#   foot touches nothing.
# - Selkowitz DM, Beneck GJ, Powers CM 2016, J Orthop Sports Phys Ther
#   46(9):794-799, doi 10.2519/jospt.2016.6493, PMID 27494053 (abstract read
#   2026-10-29; no %MVIC values or ranking available): 20 healthy adults,
#   fine-wire EMG of the superior and inferior gluteus maximus across 11
#   exercises. The superior portion had greater relative EMG in 5 of the 11,
#   and all five involved hip abduction or external rotation; hip-extension
#   exercises activated both portions similarly. Why a straight-back
#   kickback gets one Gluteus Maximus row rather than an upper/lower split,
#   no upper-glute claim anywhere in the copy, and part of the case against
#   a gluteus medius row on the Vertical Hack Squat.
# - Kinoshita M, Maeo S, Kobayashi Y, Eihara Y, Nishizawa N, Kusagawa Y,
#   Sugiyama T, Wakahara T, Kanehisa H, Isaka T 2026, Med Sci Sports Exerc
#   58(7):1566-1580, doi 10.1249/MSS.0000000000003957, PMID 41630124,
#   PMC13215645 (full text read 2026-10-29): 17 untrained adults (11 M, 6 F),
#   within-subject legs, 12 weeks, 5 x 10, knee extension through 90-0 degrees
#   against a leg press whose hip moved only 90-60. MRI volumes: gluteus
#   maximus leg press +15.4% (p < 0.001) against knee extension +0.2% (ns),
#   interaction p < 0.001; adductor magnus +6.2% against -0.9%, interaction
#   p = 0.029; rectus femoris +13.2% knee extension against +1.1% leg press.
#   This is a 12-week MRI HYPERTROPHY result, so it cannot establish an
#   activation rank, and its hip window (90 to 120 degrees in this file's
#   convention) barely overlaps the Vertical Hack Squat's 116 to 160. It is
#   therefore no longer offered as evidence about activation: it is cited
#   only for the narrow point that a short hip excursion on a machine still
#   grew the glute, so a 45 degree hip excursion is not by itself a reason
#   to demote the glute to a stabiliser.
# - Clark DR, Lambert MI, Hunter AM 2019, J Strength Cond Res 33(7S):S60-S69,
#   doi 10.1519/JSC.0000000000002144, PMID 28704312 (abstract read
#   2026-10-29; full text paywalled, so no normalised values, effect sizes
#   or machine setup): ten males at 65, 75, 85 and 95% of maximal system
#   mass. Trunk activation was higher in the back squat than the hack squat
#   for every muscle and phase EXCEPT the rectus abdominis in the concentric
#   phase - the exception the copy now carries - with activation rising with
#   load, hack squat 1RM and submaximal loads higher (p < 0.0001) and the
#   eccentric phase longer in the hack squat (p < 0.01). The only primary
#   EMG study of a hack squat that could be found, and it measured trunk
#   muscles only: used for the Pads and Shoulders cue's honest case for the
#   machine and for keeping Erector Spinae out of the rows. It supports no
#   statement about the hack squat's leg muscles, and none is made.
# - Escamilla RF, Fleisig GS, Zheng N, Lander JE, Barrentine SW, Andrews JR,
#   Bergemann BW, Moorman CT 3rd 2001, Med Sci Sports Exerc 33(9):1552-1566,
#   doi 10.1097/00005768-200109000-00020, PMID 11528346 (abstract read
#   2026-10-29): ten experienced male lifters; a barbell squat and high- and
#   low-placement leg presses - NO hack squat - each at wide and narrow
#   stance with the feet straight or turned out 30 degrees. Foot ANGLE had
#   no effect on muscle activity or knee forces. Muscle activity and knee
#   forces were higher in the knee-extending phase and rose with knee
#   flexion. The source that keeps any toes-out claim out of the Foot
#   Placement cue, which now names the three exercises it tested and says
#   nobody has tested a hack squat, and that supports the controlled-depth
#   cue.
# - Bloomquist K, Langberg H, Karlsen S, Madsgaard S, Boesen M, Raastad T
#   2013, Eur J Appl Physiol 113(8):2133-2142, doi 10.1007/s00421-013-2642-7,
#   PMID 23604798 (abstract read 2026-10-29): 17 male students, 12 weeks of
#   repetition-matched squat training, deep 0-120 degrees of knee flexion
#   (n = 8) against shallow 0-60 (n = 9). Deep gave superior front-thigh CSA
#   (+4-7%), isometric knee extension (+6 +/- 2% at 75 degrees, +8 +/- 1% at
#   105) and squat jump (+15 +/- 3%); 1RM gains were strongly range-specific.
#   The Depth cue. It is a free barbell back squat, which the copy says, and
#   the 4-7% figure is not attached to this machine.
# - Schwanbeck S, Chilibeck PD, Binsted G 2009, J Strength Cond Res
#   23(9):2588-2591, doi 10.1519/JSC.0b013e3181b1b181, PMID 19855308
#   (abstract read 2026-10-29): six participants, one set of eight at 8RM,
#   free squat against Smith machine squat, EMG from seven muscles.
#   Gastrocnemius +34, biceps femoris +26 and vastus medialis +49 were higher
#   in the FREE squat (p < 0.05); free-weight EMG averaged 43% higher across
#   all muscles. Supports keeping the hamstrings a stabiliser on a
#   fixed-path machine squat, and sets the direction: the machine's case is
#   support and load, not more activation.
# - Svensson F, Aasa U, Strong A 2022, Front Sports Act Living 4:1021323,
#   doi 10.3389/fspor.2022.1021323, PMID 36524056, PMC9745169 (abstract read
#   2026-10-29): 16 athletes squatting at body mass, free against fixed bar
#   path, textile EMG of quadriceps, hamstrings and gluteus maximus
#   bilaterally. Quadriceps activation greater in the free squat across the
#   movement, hamstrings greater on the free path in parts of both phases, NO
#   significant difference for gluteus maximus. Confirms Schwanbeck with a
#   larger n, and the null for gluteus maximus is what lets the glute
#   fraction carry across from the free-squat and sled neighbours unchanged.
# - Paoli A, Marcolin G, Petrone N 2009, J Strength Cond Res 23(1):246-250,
#   doi 10.1519/JSC.0b013e3181876811, PMID 19130646 (abstract read
#   2026-10-29): six experienced lifters, three stance widths in a BARBELL
#   SQUAT at no load, 30% and 70% 1RM, surface EMG from eight thigh muscles.
#   Only gluteus maximus differed, higher at the widest stance; adductor
#   magnus included, nothing else did. Supports the claim that where the
#   feet sit changes the share of the work - the copy names the exercise -
#   and is half the case against a gluteus medius or adductor row on this
#   squat.
# - Hopkins JE, Hopkins CE, Chiu LZF 2024, J Biomech 177:112391,
#   doi 10.1016/j.jbiomech.2024.112391, PMID 39486379 (abstract read
#   2026-10-29): inverse dynamics, 24 BARBELL squatters (11 M, 13 F),
#   narrow, medium and wide stance. Hip EXTENSOR moments greater at wide
#   than medium or narrow (both P < 0.001); hip ADDUCTOR moments unchanged
#   (P = 0.414); hip lateral rotator moments increased with width. No EMG.
#   The mechanical half of the foot-placement claim, and the second
#   independent source saying stance width does not change adductor demand.
# - StrengthLog, How to Do Machine Glute Kickbacks: Muscles Worked & Proper
#   Form, strengthlog.com/machine-glute-kickbacks/ (commercial practice page
#   with no citations of its own; re-read 2026-10-29). Its actual wording is
#   to push the leg as far UP as you can without rotating in the hips. Only
#   the no-rotation half is borrowed, in both kickbacks' Hips and Pelvis
#   cues; the as-far-as-you-can half is deliberately NOT carried across,
#   because both of this family's range cues tell the reader to stop where
#   the hip stops. No fraction or number anywhere comes from it.
# - The library's own entries for the nearest lifts, written in earlier
#   rounds from the sources in their notes: Hack Squat (Stances) Standard
#   (Quadriceps primary 0.89, Gluteus Maximus primary 0.44, Hamstrings
#   secondary 0.25, SampleData.swift 3136-3140) and the standalone Hack
#   Squat (Quadriceps primary 0.89, Gluteus Maximus SECONDARY 0.44, no
#   hamstring row, 7116-7119) for the Vertical Hack Squat; Cable Knee-Drive
#   Kickback (Gluteus Maximus 0.84, Hamstrings secondary 0.50, 46356-46359)
#   and Cable Glute Kickback (plus Gluteus Medius primary 0.40, 10464-10466)
#   for the Standing Hinge Kickback; and Machine Glute Kickback (0.84 /
#   0.50 / 0.40, 47944+) for the Incline Bench Cable Kickback. No EMG study
#   has ever measured any of these three exercises, so every fraction in
#   this family is one of those carries and is labelled as such in the code.
#   For the record, since the draft got it wrong: no leg press in the
#   library carries Quadriceps 0.89 - Leg Press, 45-Degree, Single-Leg and
#   Narrow-Stance all read 0.87 and Vertical Leg Press 0.86 - and the glute
#   fraction does not track trunk lean, since Leg Press (7033), Vertical Leg
#   Press, 45-Degree, Single-Leg and Narrow-Stance all carry Gluteus Maximus
#   0.48 with the back flat on a pad and Pendulum Squat 0.48 and V-Squat
#   0.45 on fixed paths with no lean.
#
# NOT used, and why, since each was tempting: ExRx could not be re-read this
# round (web.archive.org blocked, exrx.net HTTP 403), so the support-lever
# note the library's Hack Squat (Stances) Top of the Rep cue rests on could
# not be extended here - which is one reason this entry has a Depth cue and
# no top-lockout cue. Contreras et al. 2015 PeerJ 3:e1261 (the 91.9-94.5%
# figures) compares MVIC test positions, so quoting them as an exercise's
# activation would be circular. McCaw & Melrose 1999 (PMID 10188748) and Lee
# et al. 2026 (PMID 42579678) bear on the five stances rather than on the
# Standard model written here, and are listed in the notes against the
# stance-table job instead.

from common_1_50 import *

NAMES = ["Vertical Hack Squat", "Standing Hinge Kickback", "Incline Bench Cable Kickback"]

ex(name="Vertical Hack Squat", var="verticalHackSquat",
   # Re-planned against measured per-row budgets, because the draft's
   # quarter-column reading was wrong: the pills are 0.22-0.42 wide and
   # overran the cells it measured. Forbidding the lifter in any still and
   # any machine part that moves, the usable widths are row 0.16 leading
   # none / trailing 4 characters, row 0.32 leading none / trailing 4, row
   # 0.48 leading 12 / trailing 19, row 0.64 leading 16 / trailing 12, and
   # row 0.80 leading 19 / trailing 12. (The squeeze also lands the top row
   # at v 0.138-0.182, straddling the top band the draft measured.) So the
   # top two rows cannot carry a pill at all and all five sit on 0.50, 0.68
   # and 0.86 - the trailing ones over the static mast, the precedent the
   # old grip pill already rested on. Every label is cut to its budget:
   # 11 characters at 0.50 leading, where 12 clips her by 3 px.
   # Pairing is forced by the leaders. pad leads and grip trails on the same
   # row because their targets sit the same way round (upper_arm_L at
   # u 0.530-0.537, hand_L at 0.644-0.652, both above every row); swapping
   # the sides crosses them, as does giving pad a wider slot lower down
   # (0.68 leading crosses the depth leader at sample 2, 0.86 leading puts
   # 7.5% of the pill on her). depth takes 0.68 leading for pelvis
   # (u 0.418-0.425, v 0.423-0.543), knees 0.68 trailing for patella_L
   # (u 0.562-0.696) and feet 0.86 leading for foot_R, pinned at exactly
   # (0.420, 0.819) in all eight samples. Checked: no pill covers one body
   # pixel in any still or any moving part, no cue's own dot falls inside
   # its own pill, every leader is at least 0.045 long at every sample, no
   # leader crosses another at any sample, and no leader passes through
   # another pill.
   overrides={"pad": (0.50, "leading"), "grip": (0.50, "trailing"),
              "depth": (0.68, "leading"), "knees": (0.68, "trailing"),
              "feet": (0.86, "leading")},
   annotations=[
       ("pad", "Pads on top", "upper_arm_L"),
       ("grip", "Hands just hold on", "hand_L"),
       ("depth", "Lower to 90 deg", "pelvis"),
       ("knees", "Knees out", "patella_L"),
       ("feet", "Feet flat, centred", "foot_R"),
   ],
   cues={
       "pad": ("Pads and Shoulders",
               "The pads sit across the top of your shoulders, and you stand tall underneath them.",
               "The pads are what let you move straight up and down under the load. Each one is 0.42 m long and 0.19 m deep, and in the model each pad is in contact with both the shoulder joint and the shoulder blade - its centre sits 0.04 m from one and 0.10 m from the other - so it loads the shelf of muscle across the top of the shoulders rather than the neck. Nothing on the machine touches your back: the nearest part to the spine is a lever arm 0.23 m away, so the trunk is held upright by you, not by a pad. Set under the pads the model never leaves vertical, holding half a degree off it in every one of the 192 frames, and the pads drop the same 29.6 cm as the hips. The honest case for the machine is that it lets you handle more weight - when ten men lifted both at matched relative loads, the hack squat took the heavier loads and drew less trunk muscle activity, for almost every muscle and phase measured, than the back squat - not that it works the legs harder.",
               "Letting the shoulders lift off the pads so the trunk folds forward out of the carriage.",
               "Stand tall with the pads across the top of your shoulders and your trunk straight, and keep it there for every rep."),
       "grip": ("Handles and Arms",
                "The handles beside the pads hold you in position; they are not something to pull on.",
                "In this model the arms do nothing at all. The elbows hold 72.09 degrees and the upper arms -36.93 degrees from horizontal in every one of the 192 frames, the hands stay 0.36 m apart, and they drop 29.6 cm only because the carriage they are holding drops 29.6 cm with them. The grips find the hand as their nearest joint at 0.11 m, with the next joint 0.36 m away, so they reach your hands and nothing else. Pulling on them hands work to your arms and shoulders and lifts your shoulders off the pads, which is the one job the machine is doing for you.",
                "Hauling on the handles to drag yourself out of the bottom of a hard rep.",
                "Take a light hold of the handles beside the pads, keep your arms set where they start, and let your legs move the weight."),
       "depth": ("Depth",
                 "Every rep bends the knees from almost straight down to about a right angle.",
                 "That is 79 degrees of knee travel in this model, 167 degrees at the top to 88 at the bottom, with the hips and the whole carriage dropping 29.6 cm straight down. Training the long range is what pays: over twelve weeks, lifters who squatted to 120 degrees of knee bend gained more front-thigh size and more knee-extension strength than lifters who stopped at 60 degrees, although that was a free barbell squat rather than a guided machine. The deep end is also the loaded end, since knee forces rise as the knee bends further, so build the depth up over sets rather than dropping into it. The model takes 2.0 seconds down, holds the bottom for a third of a second and 1.7 seconds back up.",
                 "Dropping fast into the bottom and bouncing straight back out of it.",
                 "Lower under control until your knees are bent to about a right angle, hold for a beat, then drive back up."),
       "knees": ("Knee Tracking",
                 "The knees travel out over the feet as you come down, never in.",
                 "In the model they spread through the descent: the knees start 0.240 m apart - just inside the feet, which stay pinned at 0.262 m - and finish 0.332 m apart, 7 cm wider than the feet at the bottom. Each knee also travels 28 cm forward over the plate and only 5 cm down. Both legs are doing the same job here, so neither knee should drift: one knee falling inward shortens the line your hip works through, and a fixed path will not correct it for you.",
                 "The knees rolling inward as the weight gets heavy or the depth gets deeper.",
                 "Push your knees out over the middle of each foot on the way down, and keep them there on the way back up."),
       "feet": ("Foot Placement",
                "Both feet sit flat and centred on the plate, about hip-width apart, toes pointing forward.",
                "The model keeps them 0.26 m apart and planted: the plate never moves at all, and in the frame the feet do not shift a single pixel across the whole clip. Where the feet sit does change the share of the work, which is why this machine is worth setting the same way every time and why it carries five stances to choose from - though that has been measured in barbell squats and leg presses, not in a hack squat. What has been tested and changed nothing is the angle of the feet: in ten experienced lifters, feet pointing straight ahead against feet turned out 30 degrees made no difference to muscle activity or to knee forces in a barbell squat or either of two leg presses. Nobody has tested it on this machine.",
                "Turning the toes out to feel the inner thigh, or moving the feet between sets.",
                "Set both feet flat and centred on the plate about hip-width apart with the toes forward, and use the same spot every set."),
   },
   # Rows follow the paint, and this model paints one tier only: seven bright
   # muscles, nothing dim and nothing faint. The four quadriceps heads
   # (rectus femoris, vastus lateralis, medialis and intermedius) are all
   # bright, giving one primary Quadriceps row at 0.89 CARRIED from the Hack
   # Squat (Stances) Standard row - which is also the standalone Hack
   # Squat's figure, and the library has no per-head quadriceps rows to
   # split it over. (It is NOT the leg press family's value: those read
   # 0.86-0.87.)
   # The three glutes are bright too, so Gluteus Maximus is a primary row
   # rather than a stabiliser. 0.44 is the Hack Squat (Stances) Standard
   # carry, this machine family's own nearest neighbour, and that is the
   # whole reason for the number: the draft's trunk-lean rationale was
   # wrong, since the Leg Press, Vertical Leg Press, 45-Degree, Single-Leg
   # and Narrow-Stance Leg Press all carry 0.48 with the back flat on a pad
   # and no lean at all. Kinoshita 2026 is NOT offered as the warrant for
   # the rank: it is a 12-week MRI hypertrophy result, not an activation
   # measurement, and its leg press moved the hip through a deeper window
   # (90-120 degrees here) than this lift's 116-160. It says only that a
   # short hip excursion on a machine still grew the glute 15.4% against
   # 0.2% for knee extension, so this lift's 45 degrees of hip travel is no
   # reason on its own to demote the glute. Neither fraction is an EMG
   # measurement of a hack squat, because none exists - Clark 2019 is the
   # only primary EMG study of one and it recorded trunk muscles only - so
   # both are the library's nearest values, as the README asks.
   # The hamstrings are NOT painted, so they get no row and are named among
   # the stabilisers instead, the same call the Pendulum Squat and the
   # V-Squat make. That is the expected result on a fixed path, not a
   # surprise: Schwanbeck 2009 found biceps femoris higher in a free squat
   # than in a Smith machine squat and Svensson 2022 found hamstring
   # activity greater on a free path in parts of both phases. The adductors
   # and calves are unpainted too and stay stabilisers as on the Hack Squat
   # stances. No Erector Spinae row although the shoulders carry the load:
   # the Smith Machine Squat dropped its row for the same reason, and Clark
   # 2019 found trunk activation lower in the hack squat than in the back
   # squat for every muscle and phase but one.
   # One call for the owner to settle (notes, open point 1): gluteus medius
   # and minimus are painted bright here, and the two kickbacks in this same
   # family read that same three-glute group as two rows (Gluteus Maximus
   # plus Gluteus Medius 0.40). Every squat in the library instead reads it
   # as one Gluteus Maximus row and keeps gluteus medius a stabiliser, which
   # is what this entry does, because no source read this round supports a
   # medius fraction in a straight-ahead squat: Paoli 2009 found gluteus
   # maximus the only one of eight thigh muscles to differ by stance width,
   # Hopkins 2024 found hip adductor moments unchanged by width (P = 0.414),
   # and Selkowitz 2016 found the superior gluteus maximus preferred only by
   # exercises involving abduction or external rotation.
   activation=[("Quadriceps", P, HI, 0.89), ("Gluteus Maximus", P, MOD, 0.44)],
   stabilisers=["hamstrings", "adductors", "gluteus medius", "calves"],
   comparison=("KNEES DIVING IN", "Knees out over the feet", "Knees roll in at the bottom",
               "In the model the knees start just inside the feet and finish 7 cm wider, so the descent is the knees tracking out over them.",
               "Knees drifting inward shorten the line your hip works through, and the fixed path will not correct it for you."),
   # Two glows, one per visible thigh, re-centred against the measured red
   # pixels rather than left on the joint means. The bright tier is one
   # 5152-5681 px blob covering glutes and quadriceps on both legs, and only
   # 0-13.5% of it sits above the pelvis, so almost all the visible paint is
   # thigh and the Gluteus Maximus row has no glow of its own on this
   # framing - worth saying plainly rather than implying otherwise.
   # The blob sweeps right and down through the descent (u 0.285-0.594 /
   # v 0.424-0.640 at t0, u 0.296-0.723 / v 0.519-0.678 at t2), so each
   # centre is set between its own thigh's two positions. Measured: the far
   # (frame-left) thigh glow has 71-86% of its ellipse over painted muscle
   # in the four stills, the near (frame-right) one 31-49%, and both have
   # their centre on paint in all four - against 30-49% and 16-30% with the
   # centre on paint in one still each before.
   glows=[glow("Vertical Hack Squat", ["thigh_R", "patella_R"], A, 0.55, rx=0.07, ry=0.05, dx=-0.0225),
          glow("Vertical Hack Squat", ["thigh_L", "patella_L"], A, 0.55, rx=0.06, ry=0.04, dx=0.030, dy=-0.003)])

SETUP["Vertical Hack Squat"] = [
    "Load the machine and set the shoulder pads so you can stand under them with your knees almost straight.",
    "Step onto the plate and set both feet flat and centred, about hip-width apart with the toes forward.",
    "Settle the pads across the top of your shoulders, take the handles beside them and stand the carriage up off its rests.",
    "Release the stops, brace your trunk, and take the first rep from a standing start rather than dropping into it.",
]


ex(name="Standing Hinge Kickback", var="standingHingeKickback",
   # Only 12.4-13.1% of this frame carries ink, but almost none of the empty
   # space is on the side a pill wants. The machine frame, pulley arm and
   # weight stack own the whole left column, which is 28.8-46.8% full in
   # every band from v 0 down to v 0.666, and the hands sit in it too at
   # (0.158, 0.381). Measured per-row budgets, forbidding the lifter in any
   # still and any machine part that moves: row 0.16 leading and trailing
   # both wide open, row 0.32 leading 7 characters / trailing 36, row 0.48
   # leading 20 / trailing 0, row 0.64 leading 5 / trailing 10, row 0.80
   # both wide open.
   # That is what moved the kick pill. At 0.68 trailing its 26-character
   # label spans u 0.521-0.965, which puts 8.7% of the pill on the lifter,
   # swallows foot_L at (0.520, 0.652) in two samples and leaves a 0.021
   # leader; the measured budget there is ten characters. So the kick pill
   # goes to 0.50 leading, where 20 characters are clear - a row the draft
   # left empty on the strength of the right-hand side alone. torso leads
   # and hips trails at 0.14 (chest at u 0.412 is left of pelvis at 0.491,
   # so that is the order that keeps them from crossing), knee trails at
   # 0.32 for patella_L, and stance leads at 0.86 for foot_R.
   # The stance label now names the foot, because the dot is on foot_R:
   # pointing the cue at patella_R instead - the other way to fix it -
   # crosses the kick leader at the bottom of the rep, measured.
   # Ten of this lift's thirteen probed joints are single static points, so
   # the pills are ordered by target height and nothing crosses. Checked: no
   # pill covers one body pixel in any still or any moving part, no dot
   # inside its own pill, every leader at least 0.045 long, no leader
   # crossing another or passing through another pill.
   overrides={"torso": (0.14, "leading"), "hips": (0.14, "trailing"),
              "knee": (0.32, "trailing"), "kick": (0.50, "leading"),
              "stance": (0.86, "leading")},
   annotations=[
       ("kick", "Drive the foot back", "foot_L"),
       ("knee", "Keep the knee bent", "patella_L"),
       ("hips", "Hips level, no twist", "pelvis"),
       ("torso", "Hinge over, back flat", "chest"),
       ("stance", "Standing foot flat", "foot_R"),
   ],
   cues={
       "torso": ("Torso Angle",
                 "You hinge forward from the hips and hold it there: both hands on the upright carry your trunk.",
                 "The hinge is the position, not part of the rep. The model holds its trunk 67.5 degrees forward of vertical and its hips at 1.090 m from the first frame to the last, with both hands still on the machine 0.12 m apart, about 0.48 m in front of the shoulders and a hand below them. Leaning over does change what the hip does: in 21 trained female athletes, flexing the trunk 40 degrees raised gluteus maximus from 16.3 to 21.3 per cent of a maximum contraction - though it raised the hamstrings by as much again, so it is not a glute-specific effect - in a split squat, which is the nearest position anyone has measured, and nobody has measured a hinge as deep as this one. What leaning over does not do is take the lower back out of it: in the same study the erector spinae reading did not fall.",
                 "Starting upright and folding further forward as the set goes on, so the trunk swings with each rep.",
                 "Hold the upright with both hands, hinge forward from the hips until your back is about three quarters of the way to level, and keep it exactly there for every rep."),
       "hips": ("Hips and Pelvis",
                "Both hips stay level and square to the machine, and the leg travels straight back.",
                "The pelvis in the model sits at 1.090 m at every sampled moment, and the working ankle travels 0.94 m backwards with no sideways movement at all - its across-the-body position never leaves 0.05 m. So the whole range comes from the working hip and knee, with nothing borrowed from a twist. Coaching for the machine version asks for the same thing: no rotation at the hips.",
                "The working hip rolling up and open at the top to get the leg higher.",
                "Keep your hip bones level and facing the machine, and end the rep where they start to turn."),
       "knee": ("Working Knee",
                "The working knee keeps a bend in it the whole way: it is never straight.",
                "In the model it starts 26 degrees short of straight and opens only to 170 degrees at the furthest point of the kick, so it is still 10 degrees bent where the leg is highest. That is the position the one loaded kickback anyone has measured was set up in: 15 resistance-trained men on a hip-extension machine at a six-rep maximum, their working knee held near 170 degrees. Each muscle there was measured against its own maximum, and the kickback drove biceps femoris to 106 per cent of it - more than three times what a leg press drew from the same muscle - while gluteus maximus read 77 per cent, no different from the leg press. A near-straight working knee is the setup here rather than a fault, and it is part of why the hamstrings share the top of the legend with the glutes on this lift.",
                "Locking the knee out at the top, or bending it so the heel comes toward you instead of the leg going back.",
                "Set a small bend in the working knee before the first rep and hold the same bend all the way back and all the way down."),
       "kick": ("Range of Motion",
                "Drive the foot back and up until your leg lines up with your trunk, then lower it under control.",
                "In the model the hip opens from 100 to 179 degrees - 179 is the thigh in line with the trunk - and the foot rises 0.89 m and travels 0.94 m behind the lifter. The thigh reaches that line about a second and a half in, and the last half second of the foot's travel is not more hip: the hip eases back to 165 degrees while the knee goes on straightening from 168 to 170. So the leg comes into line with the trunk and stops there; height past that comes from the lower back, not from the hip.",
                "Swinging the leg as high as it will go and letting the lower back arch to allow it.",
                "Push the foot back and up until your leg is in line with your trunk, pause for a beat, then lower it all the way down."),
       "stance": ("Standing Leg",
                  "The standing foot stays flat on its platform with the knee soft.",
                  "It holds the whole body still while the other hip works, and in the model it never changes at all: 160 degrees of knee in every single sample, with the foot planted on a round platform. That is real work on that side - the nearest thing anyone has measured is a single-leg squat, where the support leg's gluteus medius reached 82 per cent of a maximum contraction, a harder job than the still hold this lift asks of it - so expect to feel it there too.",
                  "Rising onto the standing toe, or letting that knee lock, to help the working leg finish.",
                  "Keep a small bend in the standing knee with the whole foot down, and let the working leg do all the moving."),
   },
   # Rows follow the paint, and this model paints one tier only: six bright
   # muscles on the working (left) side, the three glutes and all three
   # hamstrings, with nothing dim and nothing faint. So Hamstrings is a
   # PRIMARY row here, the first kickback in the library where that happens.
   # The warrant is Orishimo 2015, which is the only source in this family
   # that tested hamstring against gluteus maximus INSIDE one exercise:
   # hamstring activity exceeded gluteus maximus in resisted standing hip
   # extension, the glider and the slider (p < 0.001, n = 12; the diver was
   # the one null, p = 0.087). Stien 2021 is the second, weaker leg of it:
   # it put biceps femoris at 106.5% MVIC and gluteus maximus at 77.0% in a
   # loaded machine kickback whose working knee was held near 170 degrees,
   # this model's apex, but every test in that paper is between exercises,
   # so 106.5 against 77.0 is two values normalised to two different maximal
   # efforts and not a comparison it ran. The fraction stays at the 0.50
   # CARRIED from Cable Knee-Drive Kickback: the paint moves the rank, not
   # the number, the way the V-Squat's and the Cable Glute Kickback's
   # promotions did.
   # Gluteus Maximus 0.84 is the same carry, and that lift is the nearest
   # neighbour in every respect - cable, single leg, standing, its setup
   # text already asking for a 30 degree lean from the hips. The obvious
   # donor, Standing Cable Hip Extension, is not available: it was dropped
   # from the library on 2026-10-19 because this female model's kickbacks
   # cover it. The carry is well supported: Stien 2021 put the machine
   # kickback's gluteus maximus at 77.0% MVIC, statistically
   # indistinguishable from the leg press's 88.0% (p = 0.898, ES 0.08), and
   # Contreras 2015 put lower gluteus maximus at 86.8% mean MVIC in a
   # horizontal-vector hip extension in 13 trained women. Gluteus Medius
   # 0.40 is an ESTIMATE carried from Cable Glute Kickback and rests on the
   # paint alone, which lights maximus, medius and minimus as one group on
   # the working leg exactly as that lift does; the evidence is against a
   # mechanical medius effect here, since Aygun-Polat 2025 found gluteus
   # medius did not rise with trunk flexion (31.08 to 27.26 %MVIC, ns) and
   # Selkowitz 2016 found the superior gluteus maximus preferred only by
   # exercises involving abduction or external rotation. No Erector Spinae
   # row although the trunk is held at 67.5 degrees: all three kickback
   # neighbours keep it a stabiliser, and Aygun-Polat found erector spinae
   # activity did not fall with trunk flexion, so the hinge is not a
   # back-sparing position to build a row around. Standing-leg glutes join
   # the stabilisers on Boren 2011 (a single-limb squat puts the support
   # leg's gluteus medius at 82% and its gluteus maximus at 71% MVIC); the
   # rest of the list is Cable Knee-Drive Kickback's, less gluteus medius,
   # which is now a row.
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Hamstrings", P, MOD, 0.50),
               ("Gluteus Medius", P, MOD, 0.40)],
   stabilisers=["standing-leg glutes", "erector spinae", "obliques", "quadratus lumborum"],
   comparison=("HIP TWISTING OPEN", "Hips level, leg straight back", "Hip rolls open at the top",
               "In the model the foot travels 0.94 m behind the lifter without moving sideways at all, so the hip extends and nothing turns.",
               "Rolling the hip open adds height the hip did not make, and it puts the end of every rep into the lower back."),
   # One glow, not two: the paint is a single small blob on the working
   # thigh, 158 red pixels at t0 (u 0.474-0.563, v 0.415-0.542) and 188 at
   # t2 (u 0.576-0.709, v 0.388-0.435), its top edge level with the pelvis,
   # so the bright glutes and the bright hamstrings read as one patch and a
   # second ellipse would have nothing of its own to sit on. It moves a long
   # way for its size - its pixel centroid runs from (0.510, 0.494) to
   # (0.653, 0.415) between the bottom of the rep and the apex - so a small
   # ellipse cannot hold it: the draft's 0.09 by 0.06 at (0.582, 0.442)
   # covered only 25% of the paint at t0 and had 29% of its own area over
   # the lifter, reading as a blob hanging in the black beside her hip.
   # Measured, this centre and these radii cover 100% of the bright paint in
   # all four stills and keep 42-52% of the ellipse on the body, which is
   # the best on-body share any full-coverage candidate reaches.
   # Note for the owner that thigh_L is a single static point in joints.json
   # (0.513, 0.409) even though the thigh plainly swings, so the glow is
   # anchored on the knee end of the pair to pick the motion up.
   glows=[glow("Standing Hinge Kickback", ["thigh_L", "patella_L"], A, 0.55,
               rx=0.165, ry=0.09, dx=0.008, dy=0.008)])

SETUP["Standing Hinge Kickback"] = [
    "Set a low pulley with an ankle cuff and strap it above the heel of your working ankle.",
    "Stand facing the machine with the other foot on the platform and that leg carrying your weight.",
    "Take the upright with both hands about a hand apart and hinge forward from the hips until your back is about three quarters of the way to level.",
    "Set a small bend in the working knee, square your hips to the machine and brace before the first rep.",
]


ex(name="Incline Bench Cable Kickback", var="inclineBenchCableKickback",
   # The lifter lies chest-down across the middle third of the frame - the
   # whole body spans only v 0.335 to v 0.669 - with the cable tower filling
   # u 0.80-1 from v 0.10 to v 0.70 and the working leg sweeping the left
   # half. Measured per-row budgets, forbidding the lifter in any still and
   # any machine part that moves: row 0.16 leading and trailing both wide
   # open, row 0.32 leading 35 characters / trailing none, row 0.48 leading
   # 3 / trailing none, row 0.64 leading 14 / trailing 17, row 0.80 both
   # wide open. So the two middle rows are unusable and the five pills take
   # the top and bottom rows plus 0.32 leading, exactly as drafted - this is
   # the one lift in the family whose layout survived the re-measurement
   # unchanged, with every pill at 0.0% body and 0.0% moving machine.
   # Every probed joint but the right leg is a single static point, so four
   # leaders are fixed: chest (0.573, 0.395) from the trailing top pill,
   # pelvis (0.511, 0.440) from the leading one, patella_L (0.395, 0.534) at
   # 0.32 and then the two movers from the bottom. Those two are safe in
   # this order and only this order: patella_R and foot_R keep the same
   # left-right order in all eight samples (foot 0.578 / knee 0.702 at the
   # bottom, foot 0.142 / knee 0.355 at the apex), so the cuff pill takes
   # the bottom left and the finish pill the bottom right and their leaders
   # never cross. Swapping them crosses at sample 0, measured. The working
   # foot's own strip (u 0.142-0.578 at v 0.531-0.632) is why no pill sits
   # at mid height on either side: it is clear at one phase and crossed at
   # the other.
   # Only the finish label changed, and for truth rather than fit: the leg
   # does not finish in line with the body here (see the cue).
   overrides={"hips": (0.14, "leading"), "trunk": (0.14, "trailing"),
              "support": (0.32, "leading"), "cuff": (0.86, "leading"),
              "finish": (0.86, "trailing")},
   annotations=[
       ("cuff", "Cuff above the heel", "foot_R"),
       ("finish", "Back until the hip stops", "patella_R"),
       ("hips", "Hips square to the pad", "pelvis"),
       ("trunk", "Chest down, ribs down", "chest"),
       ("support", "Other knee stays put", "patella_L"),
   ],
   cues={
       "cuff": ("Attachment",
                "The cuff sits above the heel of the working ankle, and the pull comes from there.",
                "It rides that foot exactly: in the model the cuff edge stays 0.01 m from the ankle joint, the velcro overlap 0.07 m and the snap clip 0.11 m, all unchanged at every moment checked, and the cuff travels about a metre through each rep while the stack plates rise 0.46 m. The cable runs past your shin and knee without touching either - 0.22 m off the shin at the bottom and 0.33 m off the thigh at the top - so there is clearance for it the whole way through.",
                "Strapping the cuff over the shin, or loose enough that it slides down toward the heel under load.",
                "Strap the cuff snugly just above the heel, clip it to the low pulley, and check it has not moved before the first rep."),
       "finish": ("Finish Position",
                  "Drive the leg back until the hip stops opening, then stop there and lower it.",
                  "In the model the working ankle travels a metre back and 0.24 m up, and the knee opens from 80 degrees to 172 on the way out. The hip stops before the leg does: it opens to within six degrees of a straight line from trunk to thigh about 1.4 seconds in, then eases back to twenty degrees short of that line while the knee is still straightening, and the model holds that finish for about a third of a second. So the thigh finishes roughly level with your hips, not level with your back - on a bench this steep, a leg genuinely in line with your trunk would need far more hip extension than you have, and the only way to fake it is to lift your chest. How much bend you keep in the working knee shifts the share of the work, and this version straightens it: in prone hip extension a near-straight working knee has been measured with more hamstring and less gluteus maximus than a knee held bent.",
                  "Snapping the leg out and letting the pelvis roll over to get it higher.",
                  "Push the heel back and up until the hip stops opening, with your thigh about level with your hips, hold for a beat, then lower it all the way back down."),
       "hips": ("Hips and Pelvis",
                "Both hips stay square against the pad, and only the working leg moves.",
                "Nothing else in this model moves at all: the pelvis holds 0.987 m and the trunk one angle in every one of the 192 frames, and the resting leg holds a single position to the decimal, so the whole range comes from the working hip and knee. Rolling the pelvis over to lift the leg higher adds height the hip did not make. Coaching for the machine version asks for the same thing: no rotation at the hips.",
                "The working hip rolling up and over to squeeze out the last of the range.",
                "Keep both hip bones flat and square to the pad, and stop the rep where they start to turn."),
       "trunk": ("Trunk",
                 "Your chest rests on the incline pad and stays there, ribs down, for every rep.",
                 "The pad does the job your trunk would otherwise be doing: the model holds the trunk 44.5 degrees from vertical and the hips at 0.987 m, unchanged in all 192 frames, with both hands resting still on the machine. That support is the point of this version. Of five prone hip-extension positions compared in one study of 38 adults, the one with the trunk supported and the knee bent drew the most activity from both the upper and the lower gluteus maximus, and the authors recommend it on its ratio of lower-back to glute activity. Pushing the chest up to reach further turns the end of the rep into a back extension.",
                 "Pushing the chest up off the pad to swing the leg higher on the last reps.",
                 "Settle your chest on the pad with your ribs down and your neck in line with your back, and keep it down for the whole set."),
       "support": ("The Other Leg",
                   "The other leg stays bent and still along the pad: it is not a standing leg.",
                   "In the model it is frozen. The resting knee holds 116.8 degrees, the same to the decimal in every sample, and it rests on the pad itself - 0.008 m from it - while that foot hangs free past the end, with nothing within 0.23 m of it. So the leg is carried by the bench rather than planted on the ground. Leaving it exactly where it is is what keeps your pelvis still, which is the one thing this version gives you over a standing kickback.",
                   "The resting leg drifting or pushing, so the hips shift a little on every rep.",
                   "Settle the other leg along the pad with the knee bent and the foot off the end, and leave it where it is for the whole set."),
   },
   # Rows follow the paint: the three glutes bright on the working (right)
   # side, so a primary Gluteus Maximus row and - as on the Cable Glute
   # Kickback and the Machine Glute Kickback, which light the same group the
   # same way - a primary Gluteus Medius row; the three hamstrings dim, so
   # Hamstrings stays secondary. All three fractions are CARRIED from
   # Machine Glute Kickback, the trunk-supported neighbour: 0.84, 0.50 and
   # 0.40. This is the best-supported glute row of the three lifts in this
   # family. Shin & Yoo 2025 found prone hip extension with the knee flexed
   # AND the trunk supported gave the highest upper and lower gluteus
   # maximus of five prone variants in 38 adults, and recommended it on its
   # erector-spinae-to-glute ratio; Macadam & Feser 2019 put trunk-supported
   # prone hip extension high in the prone family at 53.1% MVIC, though not
   # at its top (body on floor 56.5%, upper body on a table with the other
   # knee on a chair 66.4%). Both are bodyweight %MVIC figures, so no number
   # from either is printed anywhere in the copy as this lift's own, and
   # neither is quoted as a maximum.
   # The hamstring row sitting BELOW the glute row - unlike the Standing
   # Hinge Kickback in this same family, whose paint makes it primary -
   # follows this model's paint, and it is the open point of this entry
   # rather than a settled call, because the mechanics point the other way:
   # Shin & Yoo 2025 found biceps femoris and the hamstring-to-glute ratio
   # both significantly higher in the knee-EXTENDED version, and Macadam &
   # Feser 2019's pooled prone figures put knee-flexed above knee-extended
   # for gluteus maximus (18.6% against 15.5%) - and this model's working
   # knee finishes at 172 degrees, nearly straight. Song & Jeon 2026 is NOT
   # part of that case: it compared 60, 90 and 120 degrees of knee flexion
   # in a banded reciprocal-inhibition protocol with no straight-knee
   # condition, and found gluteus maximus highest at 90 and lower at BOTH
   # 60 and 120, so it says nothing about bent against straight. See notes,
   # open point 1.
   # No Quadriceps row: the knee opens 92 degrees under cable load, so the
   # quadriceps are plainly working, but the model does not paint them, so
   # they are named among the stabilisers instead - the same call the Machine
   # Glute Press made this round for the same reason. No Erector Spinae row
   # either, as on all three kickback neighbours. Standing-leg glutes are
   # NOT in this list, unlike both standing kickbacks: the non-working foot
   # hangs free off the end of the pad with nothing within 0.23 m of it, so
   # there is no standing leg to load, and Boren 2011 does not apply.
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Hamstrings", S, MOD, 0.50),
               ("Gluteus Medius", P, MOD, 0.40)],
   stabilisers=["quadriceps", "core", "erector spinae"],
   comparison=("CHEST COMING OFF THE PAD", "Chest down, leg goes back", "Chest lifts to swing it higher",
               "With the chest and hips flat on the pad the hip and knee make the whole range, which is the position that drew the most glute activity of the five compared in one study.",
               "Lifting the chest turns the end of the rep into a back extension and takes the load off the glute just as it should be working hardest."),
   # The glutes bright at the hip and the hamstrings dim down the thigh, so a
   # full glow and a soft one - and this time both are checked against the
   # measured red pixels, which the draft could not claim.
   # The full glow holds: it covers 100% of the visible bright glute paint at
   # t0, t1 and t3 with 75-90% of the ellipse on the body. But the glute
   # paint is NOT lit throughout - at the apex it goes behind the body
   # entirely, 0 red pixels on screen against 44-70 at the other three
   # stills - and the comment says so rather than implying a glow that is
   # always on something.
   # The soft glow had to grow. The dim hamstring paint tracks the thigh
   # across 0.38 of the frame's width (u 0.482-0.563 at t0 to u 0.319-0.453
   # at t2) while thigh_R is a static point in joints.json, so the drafted
   # 0.10 by 0.055 ellipse covered 52%, 78%, 0% and 80% of it - nothing at
   # all at the apex. Re-centred and widened it covers 100% in all four
   # stills with 40-56% of the ellipse on the body.
   glows=[glow("Incline Bench Cable Kickback", ["pelvis", "thigh_R"], A, 0.55, rx=0.07, ry=0.05),
          glow("Incline Bench Cable Kickback", ["thigh_R", "patella_R"], SOFT, 0.30,
               rx=0.20, ry=0.07, dx=-0.022, dy=0.015)])

SETUP["Incline Bench Cable Kickback"] = [
    "Set an incline bench in front of a low pulley and strap the cuff above the heel of your working ankle.",
    "Lie chest-down along the pad with your hips on it, your head at the high end and both hands on the machine.",
    "Rest the other leg along the pad with its knee bent and that foot hanging off the end, and let the working leg hang with its knee folded up under you.",
    "Square your hips to the pad, brace, and take the first rep from a dead stop.",
]
