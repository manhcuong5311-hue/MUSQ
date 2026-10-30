# Trainer content for the model-only exercises of 2026-10-29, family
# "core": the two core lifts that shipped with a model but no coaching -
# Pallof Press (Abs/PallofPress) and Kettlebell Windmill
# (Abs/KettlebellWindmill). Same format as spec.py on top of
# common_1_50.py; spec_1029.py imports this module and gen.py reads SPEC /
# SETUP. notes_1029_core.md maps every claim in the copy to the sources
# below or to a model measurement.
#
# Written the way the README asks for a family: drafted from the rig and
# the literature, reviewed by two independent agents (evidence; model
# fidelity and labels), revised, audited by a third, and closed out - the
# per-exercise logs are in notes_1029_core.md.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (the round folder's brief.py, summ.py, props.py, nearest.py, gaps.py and
# palm.py; trainer_shot.py renders the app's own trainer camera at
# 382x655). Frame: Y up, the lifter faces +z, their left is +x, metres.
# Both clips run 7.96 s at 24 fps (192 frames) and hold two identical reps.
# - Pallof Press (yaw -0.3, near front-on; zoom 0.862, offset [0.01, 0.041,
#   -0.003]). Standing side-on to a cable tower 1.20 m to the lifter's left,
#   its exit pulley 0.98 m out and 1.310 m up - level with the bar, 1.4 cm
#   below it. Both hands hold one rigid straight bar across the midline
#   (CORE_TwoHandHandle_Mesh, 0.360 x 0.038 x 0.038 m, centred at x 0.000)
#   with a pronated grip: palm.py dots the hand frame +0.975 against the
#   library's pronated Biceps/ReverseCurl and -0.820 against the supinated
#   Biceps/CableCurl, and a joint-to-handle-bbox pass over all 30 finger
#   joints puts the fingertips of both hands on the bar at matching
#   distances - the index tips at the chest (x +0.083 / -0.083, 0.0 cm) and
#   the little-finger tips pressed out (x +0.152 / -0.153, 0.0 cm) - so the
#   hold is symmetrical. The wrists themselves never touch it: hand_L/R stay
#   4.6 cm off the bar at the chest and 6.1 cm off pressed out.
#   Bottom (0-0.17, 3.50-4.17 and 7.50-7.96 s): elbows 50.72 degrees, the
#   hands 19.6 cm ahead of the shoulder and 0.34 m apart, and the bar's near
#   face (z 0.3527) still 6.7 cm clear of the frontmost chest surface
#   (PectoralisMajor_Sternal, z 0.2853) - it is held in front of the chest,
#   never against it. Top (1.00-2.46 and 5.00-6.46 s, held 1.46 s): elbows
#   162.35 (L) / 163.31 (R), the hands 52.1 cm ahead of the shoulder and
#   0.24 m apart - each wrist slides about 4.8 cm inward along the rigid
#   bar - and the upper arms lift from 49.34 to 13.64 degrees below
#   horizontal. The bar travels 34.0 cm, essentially purely forward: zero
#   rise, up to 4 mm of sideways drift, with the 6-plate stack lifting
#   15.7 cm in step with it. Everything below the shoulders is frozen -
#   pelvis 0.903 m, trunk 3.96 degrees forward, hips 167.98, knees 167.36 /
#   166.88, ankle gap 0.360 m, knee gap 0.288 m, shoulder gap 0.392 m - and
#   not one of them changes by even 0.01 across all 192 frames (1-192 at
#   24 fps, 7.96 s), so there is no rotation, lean or shift to measure and
#   the loaded side is readable only from the rig (the tower at x +1.20 m,
#   the cable on the x +0.20 end of the bar).
#   Paint: External Oblique, Internal Oblique and Rectus Abdominis bright on
#   both sides; nothing dim and nothing faint, so the entry has no secondary
#   row, and the transverse abdominis, which the rig has no mesh for, is
#   named among the stabilisers instead.
# - Kettlebell Windmill (yaw -0.3, almost face-on and turned slightly: at the
#   top of the rep the loaded left arm and the bell sit on the viewer's RIGHT
#   and the free right arm on the left, but at the bottom the whole upper body
#   swings left and the two hands cross - hand_L u 0.425 against hand_R
#   u 0.497). The clip runs 7.96 s at 24 fps and holds two identical reps, one
#   every 4.00 s: read per frame, hand_R sits at its minimum over frames 42-50
#   and 138-146 (96 frames apart), and shifting the clip by that 96 frames
#   leaves a maximum hand_R height difference of 0.00 cm (3.85 cm at 95 or 97
#   frames). One kettlebell, in the LEFT hand overhead: six meshes
#   (HG_KettlebellBell, the handle, two horns and two elbows) that move
#   together 9.9-13.0 cm from hand_L, with nothing within 30 cm of hand_R
#   (nearest part 1.20 m), and nothing else in the scene. The feet never move
#   - the ankle joints hold the same spot in every frame, 0.36 m apart against
#   0.39 m at the shoulders, and the knees stay 0.257-0.273 m apart - and both
#   feet are turned 42 degrees away from the bell side for the whole clip
#   (ankle-to-toe yaw -42.00 on both in all 192 frames, against +8.7 and -8.7
#   on the neutral carry), which is the stance the practice source teaches.
#   Top (the pose is frozen over frames 0-6, 86-102 and 182-191, i.e. 0-0.25,
#   3.58-4.25 and 7.58-7.96 s): trunk upright at -0.4 degrees, hip_L 164 and
#   hip_R 167 degrees, the free right hand 0.91 m up, the overhead hand
#   1.96 m. Bottom (frames 42-50 and 138-146, 1.75-2.08 and 5.75-6.09 s, held
#   0.33 s): the trunk reaches 83 degrees from vertical - near horizontal and
#   on a diagonal, the hips-to-neck line finishing 43 cm forward and 40 cm
#   toward the free side - hip_L 91 and hip_R 80 degrees, the free hand 0.29 m
#   (61 cm lower, 23.0 cm from that ankle) and the pelvis 11 cm toward the
#   loaded side and 9 cm back but only 2.1 cm down. One rep, measured between
#   the last frame of the frozen top pose and the first frame of the bottom
#   hold and back, is 1.50 s down, 0.33 s at the bottom, 1.50 s up and 0.67 s
#   standing (36 / 8 / 36 / 16 frame steps = 96): the descent and the ascent
#   are the same length, as the rig is symmetric. The loaded arm never moves:
#   elbow_L is a constant 175 degrees and its upper-arm pitch holds 81.7-82.3
#   degrees from horizontal (0.62 degrees of change), so the bell's own 60 cm
#   of travel - 50 cm across the body toward the lifter's right, 28 cm down,
#   16 cm forward - comes from the shoulder travelling under it, not from the
#   arm bending; both knees stay near straight (knee_L a constant 177 degrees,
#   knee_R 170-177), so all of it is trunk and hips. The head traces the
#   longest path across the frame of any tracked joint (729 px over the eight
#   probed samples, against 700 for the next), and the head bone's facing axis
#   stays the nearest of its three axes to the bell in all 192 frames, closing
#   to a constant 12.6 degrees through the bottom hold, the tightest of the
#   clip (worst 45.4 degrees, at 0.83 s).
#   Paint: both obliques, the three glutes and the three hamstrings bright on
#   both sides; rectus abdominis and erector spinae dim on both sides, and on
#   the loaded (left) side only the anterior and lateral deltoid, the four
#   rotator-cuff muscles, the three trapezius parts and the rhomboid major dim.
# How they differ from the library: the Cable Wood Chop and the cable
# rotations turn the trunk against the cable, where the Pallof press refuses
# to turn at all and nothing below the shoulders moves; the side bends and
# the Side Plank load the trunk sideways without rotation; the Suitcase
# Carry holds a load at one side while walking, and the Kettlebell Swing is
# a two-handed hinge. The windmill is the only lift in the library that
# holds one arm overhead while the trunk folds away from it.
#
# Sources (what each is used for is in notes_1029_core.md):
# - Juan-Recio C et al. 2025, Medicina (Kaunas) 61(2):312, PMC11857476
#   (full text read 2026-10-29): an anti-rotation test with the arms
#   extended perpendicular to the body at shoulder height, the posture held
#   for 15 s.
# - Franco-Lopez F et al. 2024, Sensors 24(13):4131, PMC11244540 (full text
#   read 2026-10-29): a Pallof press protocol holding the band at chest
#   level and pressing the hands forward in a horizontal plane without
#   twisting the torso, a 5 s maintained contraction; the test stops as soon
#   as compensating movement appears.
# - Stephens T et al. 2021, Int J Exerc Sci Conf Proc 8(9) Art. 12: a
#   four-person methodology pilot. It is the reason the copy quotes no
#   percentage of maximum for this lift - no peer-reviewed EMG study of the
#   Pallof press was found on Europe PMC.
# - Andersson EA, Grundstrom H, Thorstensson A 2002, Spine 27(6):E152-160,
#   PMID 11884920: trunk muscle work in standing anti-rotation and bracing
#   tasks.
# - Cinarli FS, Kafkas ME 2025, Eur J Appl Physiol 125(9):2449-2459, PMID
#   40195160: core training and trunk endurance outcomes.
# - St-Onge E et al. 2019, J Bodyw Mov Ther 23(1):23-31, PMID 30691756
#   (abstract read): in the Turkish get-up the bell-side shoulder muscles
#   were the busier ones in the stages where the free arm was unloaded. It
#   publishes no percentage of maximum, so no number is quoted and no
#   stability or injury claim is made.
# - Fujii R et al. 2007, Eur Spine J 16(11):1867-1874, PMID 17549527
#   (abstract read): 3D MRI of ten people; each lumbar segment turned only
#   1.2 to 1.7 degrees even at 45 degrees of trunk rotation. Supine,
#   unloaded and device-guided, lumbar segments only, so it licenses only
#   where to turn from.
# - Johnson EN, Thomas JS 2010, Arch Phys Med Rehabil 91(7):1140-1142, PMID
#   20599054 (record re-read 2026-10-29): 122 pooled participants; no
#   significant link between straight-leg-raise flexibility and hip or
#   lumbar excursion in the low-back-pain and recovered groups.
# - Allam NM et al. 2023, PMID 37781540: the hamstring-to-trunk-flexion
#   link appeared only in women and not at all to lumbar lordosis.
# Deliberately not used: Bordelon NM et al. 2021, J Strength Cond Res
# 35(Suppl 1):S114-S119, PMID 33298714 (the Suitcase Carry's trapezius
# fraction rests on it; this windmill is not a carry).

from common_1_50 import *

NAMES = ['Pallof Press', 'Kettlebell Windmill']

ex(name="Pallof Press", var="pallofPress",
   # Near front-on. spec_1029.py remaps gen.py's slots, so the overrides
   # below are on the raw 0.14-0.86 scale and render at rows 0.16, 0.32,
   # 0.48, 0.64 and 0.80. Row 0.32 is the one row the subject crosses right
   # over: within 0.035 of it (23 px of 655) the arms run u 0.215-0.780 and
   # the cable carries on out of the frame at u 1.000, so it stays empty - a
   # trailing pill there covers 324 subject pixels at the bottom frame and a
   # leading one 1019. Row 0.16 holds only the head (u 0.448-0.568), so the
   # two hand pills share it, one each side, dropping almost straight onto
   # the fists at hand_R (u 0.30-0.36) and hand_L (u 0.48-0.59). Below that
   # the body is a narrow column - u 0.338-0.686 at row 0.48 - so the hips
   # and trunk pills share that row either side of it. Only the hips leader
   # is near-level (pelvis v 0.463, 11 px above the row); the trunk pill
   # points at chest at v 0.354, so its leader climbs 83 px and crosses the
   # right torso edge, which is ordinary for a chest pill - 84 of the
   # library's 138 probed chest pills sit at least this far from the joint
   # (median 0.167), the same rate as the library's 2040 probed annotations
   # as a whole. Row 0.64 is clear of the silhouette but left empty: a hips
   # pill there would climb 116 px back across the thigh. The feet pill goes
   # trailing on row 0.80 beside foot_L (u 0.642), where the shoes end at
   # u 0.688 and the legend is far away on the other side.
   overrides={"press": (0.14, "leading"), "level": (0.14, "trailing"),
              "square": (0.50, "trailing"), "hips": (0.50, "leading"),
              "stance": (0.86, "trailing")},
   annotations=[
       ("press", "Press straight out", "hand_R"),
       ("level", "Bar stays chest high", "hand_L"),
       ("square", "Stay square", "chest"),
       ("hips", "Hips stay still", "pelvis"),
       ("stance", "Feet planted", "foot_L"),
   ],
   cues={
       "press": ("Press and Hold",
                 "Press the bar straight out from in front of your chest until your arms are long, and hold it out there.",
                 "The press is the only thing that moves in this lift: in the model the elbows open from 51 degrees to 162 and the hands finish 52 cm ahead of the shoulder against 20 cm at the chest, while everything below the shoulders holds one position. The model holds the far position for about 1.5 s of every rep. One published protocol measures a 15-second hold with the arms extended at shoulder height; another measures a 5-second hold with the hands pressed forward from chest level.",
                 "Pumping the bar in and out and never holding it at arm's length.",
                 "Press out until your elbows are straight, hold for a second or two with your shoulders square, then bring it back in front of your chest."),
       "level": ("Bar Height and Path",
                 "The bar starts level with the middle of your chest and travels straight out, level, on one line.",
                 "In the model the bar moves 34 cm and all of it is forward: no rise, and under half a centimetre of drift to either side, so it stays dead level the whole way out. The pulley sits 1.31 m up and the bar 1.32 m, so the cable runs level into it. One published protocol holds the band at chest level with its anchor on the wall at 1 m; another extends the arms at shoulder height and reports no anchor height at all. Level is what keeps the pull across your body rather than up or down it.",
                 "Pressing up and away, so the bar finishes above chest height.",
                 "Set the pulley level with the middle of your chest and push the bar out on that line, hands level the whole way."),
       "square": ("Anti-Rotation",
                  "The cable pulls from one side for the whole set, and the work is not letting it turn you.",
                  "This is what the lift is for. The cable leaves the machine about 1 m to the lifter's left and attaches to that end of the bar, yet the trunk angle, the pelvis height and both hip and knee angles are identical in every frame of the model - there is no turn in it anywhere. One published band test of this press asks for the same thing - the hands press forward in a horizontal plane while the lifter avoids twisting the torso - and the test stops as soon as compensating movement appears.",
                  "Letting your chest turn toward the machine as the bar goes out.",
                  "Point both shoulders and both hip bones straight ahead and keep them there; end the set when you can no longer hold them square."),
       "hips": ("Hips and Pelvis",
                "Your hips stay level and still, and you stay tall over your feet.",
                "Everything below the shoulders is frozen in the model: the pelvis sits at 0.903 m, the trunk leans 3.96 degrees forward and both hips hold 168 degrees, and not one of those changes across the clip. Keeping the pelvis quiet is the part of this exercise that has actually been measured - a study of twelve adults graded five Pallof variations by how much the pelvis accelerated during a 15-second hold, from 0.17 m per second squared kneeling on a foam pad up to 0.61 standing in a tandem stance on a hemisphere ball.",
                "Pushing the hips away from the machine, or leaning away from the cable to hold the bar out.",
                "Stand tall with your ribs down and your hips level, and let the cable pull without leaning or shifting away from it."),
       "stance": ("Stance",
                  "Both feet stay planted about shoulder-width apart, with the knees a little bent.",
                  "The model stands with its ankles 0.36 m apart and its knees 0.29 m apart at about 167 degrees - soft, not locked - and neither foot moves a centimetre in the whole clip. What you stand on changes how much the pelvis moves while you hold: in that same study, feet together on the floor measured 0.22 m per second squared and a tandem stance 0.31, against 0.17 kneeling on a pad and 0.55 and 0.61 for the same two stances on a hemisphere ball.",
                  "Letting a knee lock, or the weight sliding onto the leg nearest the machine.",
                  "Plant both feet about shoulder-width apart, keep a small bend in both knees, and press your weight evenly through them for the whole set."),
   },
   # Paint is abs only and all of it bright: External Oblique, Internal
   # Oblique and Rectus Abdominis lit, nothing dim and nothing faint, so both
   # rows are primary, following the paint. Obliques 0.78 is the library's
   # most-used oblique primary (8 rows, Cable Wood Chop and Reverse Cable
   # Wood Chop among them). Rectus Abdominis is 0.44, the Cable Wood Chop
   # value, rather than the 0.30 that Reverse Cable Wood Chop, Cable Rotation
   # and Cable Side Bend carry, because the bright paint makes it a primary
   # row here and 0.30 would be a new lowest primary in the core set (the
   # floor is Farmer Carry March's Obliques 0.35) - see the open point, which
   # is the owner's call. No percentage of maximum is claimed anywhere in the
   # copy: no peer-reviewed EMG study of the Pallof press was found, and the
   # one conference abstract that measured it is a four-person methodology
   # pilot that publishes no values. Andersson 2002 is only a loose analogy -
   # it found the obliquus externus active on the side contralateral to a
   # resisted maximal twist while the rectus abdominis was little activated
   # in all rotations, reports no %MVC, and measures resisted rotation rather
   # than an isometric anti-rotation hold. The transverse abdominis has no
   # mesh in the rig and so no paint; it is named among the stabilisers, as
   # Side Plank and Russian Twist do, instead of being given a row.
   activation=[("Obliques", P, HI, 0.78), ("Rectus Abdominis", P, MOD, 0.44)],
   stabilisers=["transverse abdominis", "erector spinae", "anterior deltoid",
                "triceps brachii", "gluteus medius"],
   comparison=("LETTING IT TURN YOU", "Shoulders square, bar straight out", "Chest turns toward the machine",
               "Holding square is the whole exercise: in the model nothing below the shoulders moves, and the arms press the bar out on their own.",
               "Turning toward the pull gives the cable the one thing you are there to resist, and one published band test counts hip rotation as a compensation that ends the test."),
   glows=[glow("Pallof Press", ["support_PectoralisMajor_Abdominal_L", "spine"], A, 0.55, rx=0.06, ry=0.055, dx=0.029, dy=-0.01),
          glow("Pallof Press", ["support_PectoralisMajor_Abdominal_R", "spine"], A, 0.55, rx=0.06, ry=0.055, dx=-0.037, dy=-0.01)])

SETUP["Pallof Press"] = [
    "Set the pulley at about the middle of your chest and clip on a short straight bar.",
    "Stand side-on with your left side to the machine, about a stride out, so the cable is tight and runs level to the bar.",
    "Take the bar in both hands, palms down, one hand near each end, and pull it in until your hands are in front of the middle of your chest.",
    "Set your feet about shoulder-width apart with the knees soft, and square your shoulders and hips to the front before the first press.",
    "Do the whole set with your left side to the machine, then turn around and do the same number with your right side to it.",
]


ex(name="Kettlebell Windmill", var="kettlebellWindmill",
   # Near face-on, turned slightly: at the top of the rep the loaded left arm
   # and the bell are on the viewer's RIGHT and the free right arm on the
   # left; at the bottom the whole upper body swings left and the two hands
   # cross (hand_L u 0.425, hand_R u 0.497). Measured off the four rendered
   # stills, the lifter and bell span u 0.220-0.848 and v 0.090-0.861 - the
   # bell holds the top right corner (x 268-324 at the top of the rep) and
   # the trunk and head reach x 84 at the bottom - so only the gutters are
   # free. spec_1029.py's row() squeezes the slots to 0.16-0.80, which is
   # where the clearances below were measured: the written 0.14, 0.32, 0.50,
   # 0.68 and 0.86 land at v 0.16, 0.32, 0.48, 0.64 and 0.80. Row 0.48 is
   # the tight one - at the bottom of the rep the body fills x 84-279 of
   # 382 there, leaving about 8 characters on the left and 11 on the right -
   # so it carries the one pill that has to be on the right, the hips, the
   # only slot whose leader reaches the hip without running the length of
   # the trunk. The other four run down the left edge in the order of the
   # joints they point at: the arm pill at 0.14, the head pill at 0.32
   # (about 13 characters, capped by the head at mid-descent at x 111), the
   # free hand at 0.68 and the planted foot at 0.86. Against the four
   # silhouettes no pill touches the lifter: the clearances are 43 px (bell,
   # at mid-descent), 34 (eyes), 15 (hips, at the bottom), 6 (free hand, at
   # the bottom) and 5 (feet, in all four stills), so the two tight ones are
   # the feet and the free hand. The feet pill points at toe_R, the near
   # shoe: at toe_L its leader ran 117 px across the right shin and ankle,
   # 66 px of it over the lifter, where toe_R is 43 px with 19 px over and
   # ends on the shoe it names. The longest run over the body is the bell
   # leader at the bottom, 26 px, ending on the overhead hand.
   overrides={"bell": (0.14, "leading"), "eyes": (0.32, "leading"),
              "hips": (0.50, "trailing"), "reach": (0.68, "leading"), "legs": (0.86, "leading")},
   annotations=[
       ("bell", "Arm straight overhead", "hand_L"),
       ("eyes", "Eyes up", "head"),
       ("hips", "Hips back", "thigh_L"),
       ("reach", "Hand down the leg", "hand_R"),
       ("legs", "Feet stay planted", "toe_R"),
   ],
   cues={
       "bell": ("Overhead Arm",
                "The bell stays up over your shoulder with the elbow straight, and the arm itself does not move.",
                "The arm is the one part of you that holds still: in the model the loaded elbow sits at 175 degrees for the whole clip and the upper arm stays between 81.7 and 82.3 degrees from horizontal, under a degree of change, so it keeps pointing at the ceiling while the trunk tips over. The bell still travels about 60 cm - 50 cm across your body, 28 cm down and 16 cm forward - because your shoulder travels under it, not because the arm bends. In a study of the Turkish get-up, the nearest lift anyone has measured that holds a bell overhead in one hand, the bell-side shoulder muscles were the busier ones in the stages where the free arm was not propping the body up, which is this lift all the way down.",
                "Letting the elbow bend or the arm drift forward as the trunk comes down.",
                "Press the bell up, straighten the elbow, and keep the arm pointing straight up for the whole rep."),
       "eyes": ("Head and Eyes",
                "Your eyes stay on the bell, so the head turns and tips with the trunk.",
                "The model does this the whole way through: the head is tipped back looking up at the bell at the top of the rep, and it traces the longest path across the frame of any joint tracked on this model. The rig keeps the head turned toward the bell in every frame and squarest at the bottom, where the line it faces along sits about 13 degrees off the bell - its closest of the clip. Keeping the eyes on the bell is what StrengthLog's windmill guide teaches, and no study has tested it, so treat it as the standard coaching cue rather than as something that holds the shoulder still for you.",
                "Dropping the head to watch the free hand, or tucking the chin into the chest.",
                "Find the bell with your eyes before the first rep and keep looking at it all the way down and back up."),
       "hips": ("Hip Hinge",
                "The hips push back and over toward the bell side, and that is what lowers your trunk.",
                "The movement is at the hips, not the waist: in the model both hips fold a long way - the left from 164 to 91 degrees, the right from 167 to 80 - while the pelvis drops only 2.1 cm and instead shifts 11 cm toward the loaded side and 9 cm back. The trunk ends up about 83 degrees from vertical, near horizontal and on a diagonal: the line from hips to neck finishes 43 cm forward and 40 cm toward the free side. The turn has to come from the hips, because the low back has little to give: in a 3D MRI study of ten people, each lumbar segment turned only 1.2 to 1.7 degrees even at 45 degrees of trunk rotation.",
                "Bending at the waist with the hips still underneath you, so the back rounds instead.",
                "Push the hips back and toward the bell side, keep the spine long, and let the turn come from your hips."),
       "reach": ("Free Hand",
                 "The empty hand slides down the inside of the leg on its own side and shows you how far you have come.",
                 "It is a marker, not a support: the free hand holds nothing - all six parts of the kettlebell sit 9.9 to 13.0 cm from the other hand and travel with it - and in the model it drops 61 cm, finishing 23 cm from that ankle with the arm hanging near straight at about 176 degrees. Sliding it down the inside of the leg is how StrengthLog's guide describes the descent. The model takes about 1.5 s down, holds a third of a second at the bottom and takes 1.5 s back up.",
                 "Pushing on the leg to get lower, or reaching with the hand while the hips stay where they are.",
                 "Let the hand run down the inside of that leg as the hips go back, stop where the hips stop, pause, then stand up at the same speed."),
       "legs": ("Feet and Legs",
                "Both feet are set before the first rep and never move, and both legs stay long.",
                "The long legs are what leave the hips to do the work: in the model the ankle joints stay 0.36 m apart and hold the same spot in every frame, the left knee holds 177 degrees for the whole clip and the right moves only between 170 and 177 degrees. With the hips folded that far and the knees straight, the hamstrings are held long for the whole descent. The model paints them bright on both legs, with all three glutes.",
                "Bending the knees to get the hand lower, or shuffling a foot as the trunk comes down.",
                "Set both feet about shoulder-width apart and flat, turned away from the bell side, keep both legs long, and let the depth come from your hips."),
   },
   # Rows follow the paint. Bright on both sides: external and internal
   # oblique, the three glutes and the three hamstrings. Dim: rectus
   # abdominis and erector spinae on both sides, and on the loaded (left)
   # side only the anterior and lateral deltoid, the four rotator-cuff
   # muscles, the three trapezius parts and the rhomboid major - so the cuff
   # is one Rotator Cuff row (the README's 101-200 rule) and the upper back
   # one Trapezius row, the rhomboids unnamed, as on the shoulder presses.
   # No EMG, kinematic or range-of-motion study of the windmill exists (a
   # Europe PMC title search for windmill returns softball pitching, a
   # microrobot and a wind-turbine gearbox; none of 104 kettlebell EMG hits
   # tested it), so every fraction here is carried from a named neighbour
   # and every one is a judgement call. Obliques 0.62 is the Suitcase Carry
   # March's value, anchored there on the free-side external oblique at 33%
   # MVIC in a suitcase carry (Ellestad 2024); it leads because this is the
   # library's OBLIQUES lift, and because the one-arm snatch and clean
   # loaded the contralateral external oblique more than the swing did
   # (Lyons 2017; direction only, no %MVC in the abstract). It sits under
   # the Side Plank's and the side bends' 0.78 because the windmill is a
   # slow descent and return, not a sustained side-support hold. The one
   # practice source for this lift disagrees with the lead: StrengthLog's
   # windmill guide ranks glutes, the three deltoids and hamstrings primary
   # and lower back, abs, rotator cuff, lats and traps secondary, and never
   # names the obliques - see the open points. Hamstrings 0.50 and Gluteus
   # Maximus 0.50 are marked down from the Kettlebell Swing's 0.76 and 0.80
   # on purpose: those are ballistic 16 kg values and must not be reused for
   # a slow windmill under a light bell. Erector Spinae 0.45 is the two side
   # bends' value, and the ordering under the obliques is measured -
   # contralateral longissimus 29.1% against external oblique 33.0% MVIC in
   # a suitcase carry (Ellestad 2024), and lumbar erector spinae 8.6% to 16%
   # MVIC walking with a one-hand bell (Graber 2021). Gluteus Medius 0.40 is
   # the MODERATE floor, with Graber 2021 behind its presence (the hip away
   # from the bell rose 14% to 22% MVIC, the bell-side hip not at all); Nam
   # 2025 read 66.67% in a side-bridge but selected its subjects for
   # hip-abductor weakness and printed a quadratus lumborum value above 100%
   # MVIC, so no number is carried from it. The two shoulder rows are set
   # against the Overhead Carry, the library's nearest overhead-hold
   # neighbour (dumbbells locked out overhead for time): its Lateral Deltoid
   # is 0.45 and its Upper Trapezius 0.60, and Lateral Deltoid 0.40,
   # Anterior Deltoid 0.40 and Trapezius 0.36 sit under both because the
   # paint here is dim and the bell is not carried for time. The 0.40 itself
   # is the Side Plank Hip Lift's Lateral Deltoid, with the anterior deltoid
   # matched to it rather than taken from it - that entry has no Anterior
   # Deltoid row. Trapezius 0.36 is the vertical presses' estimate for a dim
   # upper back, used instead of the Suitcase Carry's 0.44 because that row
   # rests on Bordelon 2021 Table 2, which could not be re-read this round
   # (no abstract on Europe PMC, publisher full text HTTP 402). St-Onge 2019
   # supports the bell-side shoulder being the loaded one but publishes no
   # %MVIC. Rotator Cuff 0.34 is the pulldowns' dim-cuff estimate, set under
   # the two deltoid rows. Rectus Abdominis 0.30 is the standing house value
   # for a dim abdominal row (Suitcase Carry, Suitcase Carry March and both
   # side bends), with Ellestad 2024 behind the order: free-side rectus
   # abdominis 18.9% against external oblique 33.0% MVIC.
   activation=[("Obliques", P, MOD, 0.62), ("Hamstrings", P, MOD, 0.50),
               ("Gluteus Maximus", P, MOD, 0.50), ("Erector Spinae", S, MOD, 0.45),
               ("Gluteus Medius", P, MOD, 0.40), ("Lateral Deltoid", S, MOD, 0.40),
               ("Anterior Deltoid", S, MOD, 0.40), ("Trapezius", S, LOW, 0.36),
               ("Rotator Cuff", S, LOW, 0.34), ("Rectus Abdominis", S, LOW, 0.30)],
   stabilisers=["quadratus lumborum", "transverse abdominis", "serratus anterior", "adductors"],
   comparison=("BENDING AT THE WAIST", "Hips travel back, spine long", "Hips stay put, back rounds",
               "The hips make the whole movement: in the model the left hip travels through 72 degrees and the right through 87, while the pelvis shifts back and across and the trunk stays long.",
               "Bending at the waist asks the low back for a turn it cannot give, and takes the work off the hips."),
   # The trunk glow is the one standing on bright paint: measured against the
   # four stills it covers 57-80% painted muscle of the lifter it overlaps,
   # where the two thigh ellipses manage 24-35% (the whole silhouette is
   # 18-24% painted). In this near-face-on framing the bright hamstrings and
   # glutes are on the far side of the leg, so the thigh glows stand over
   # the thighs whose far side is painted rather than on the paint itself,
   # and they overlap each other between u 0.601 and 0.630. All three sit on
   # anchors that hold their place in this framing - spine 8 px of u,
   # patella_L 10, patella_R 15, thigh_L 21, chest 29 and thigh_R 37 - while
   # the head and the arms sweep 110-118 px across the frame. Lifting the
   # trunk glow toward the paint centroid was tried and dropped: dy=-0.03
   # raises its painted share at the top of the rep from 42% to 59% of the
   # ellipse but cuts the bottom of the rep, which is what the cues are
   # about, from 24% to 13%, and the four-still average barely moves.
   glows=[glow("Kettlebell Windmill", ["chest", "spine"], A, 0.55, rx=0.10, ry=0.07),
          glow("Kettlebell Windmill", ["thigh_L", "patella_L"], A, 0.55, rx=0.07, ry=0.09),
          glow("Kettlebell Windmill", ["thigh_R", "patella_R"], A, 0.55, rx=0.07, ry=0.09)])

SETUP["Kettlebell Windmill"] = [
    "Get one kettlebell overhead in your left hand and straighten the arm; the other hand holds nothing.",
    "Stand with your feet about shoulder-width apart and flat, both turned away from the bell side, and leave them there for the whole set.",
    "Straighten both legs, look up at the bell and brace your trunk before the first rep.",
    "Work the set on this side, then put the bell overhead in your right hand and do the same number the other way.",
]
