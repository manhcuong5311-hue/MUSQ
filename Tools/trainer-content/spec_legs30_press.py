# Trainer content for the 30-leg set (2026-09-28), family "press": the
# vertical, 45-degree, single-leg, narrow-stance and wide-stance leg presses
# from the HIKSEMI drive's "300-350/27_9" folder. Same format as spec.py, on
# top of common_legs30.py; spec_legs30.py collects it with the other
# families. The app already has an older "Leg Press" (model LegPress, framed
# at yaw -0.6, legPressContent in SampleData.swift); these entries keep its
# cues, wording and ranks where the models agree with it.
#
# What each model shows, from the rig (joint positions and angles every
# 0.5 s, briefs_legs30/*.md; the foot bone's direction and the footplate's
# bounds read from the USD with pxr) and the framing stills. All five are
# machine presses: the pelvis never moves (hips fixed on the seat, pelvis and
# lumbar bones keep the same orientation all clip), so reps are read from the
# knee angle. Every clip is two reps in 7.96 s with the same timing: the sled
# comes down over ~1.1 s (0.12-1.12 s), the knee stays within ~2° of its
# deepest bend for ~0.9 s (1.17-2.04 s, deepest at 1.4-1.5 s), and the press
# takes ~1.8 s (2.08-3.83 s); second rep 4.12-7.83 s. The top is a SOFT
# knee: 160° (20° short of straight) in every model, never locked. The hands
# hold the handles beside the hips all clip (elbows 108°, hands ~0.31 m from
# the midline). Rig torso (neck to pelvis) 0.59 m, hip joints 0.18 m apart,
# shoulder joints 0.40 m apart. The foot bone points ~24° into the plate in
# all five (measured from foot_L's bone axis against the plate's face; on the
# vertical press the bone is 36° above level, the plate ~12° off level), the
# usual angle of a flat foot, so the heels stay down; no model lifts a heel.
# The sled travels 0.21 m in every model.
# - Vertical Leg Press (yaw -2.2, rear three-quarter from the lifter's left
#   and head end): lying flat on the back pad (trunk 90° back from vertical),
#   hips on the seat pad, the sled running straight up and down above them.
#   Ankles 0.40 m apart (shoulder width), 0.10 m toward the head from the
#   hips, so the feet sit about over the hips; toes turned out ~7°; feet flat
#   on the plate, near the middle of it. Knee 160° -> 95°, hip (trunk-thigh)
#   74° -> 42°, the thighs from 72° to 40° above horizontal: the deepest hip
#   bend of the family. The plate is tilted ~12° off level. At the bottom the
#   knee joint is ~4 cm short of the toe tips along the plate, so the kneecap
#   sits about over the toes. The knees stay in line with the feet (knees
#   ~5 cm inside the ankles, on the hip-to-ankle line).
# - 45-Degree Leg Press (yaw -2.0, rear three-quarter from the left): back
#   pad reclined 60° from vertical, seat under the hips, the sled on 45°
#   rails, the footplate's face 33° back from vertical (0.63 x 1.1 m).
#   Ankles 0.40 m apart (shoulder width), toes out ~7°, feet flat in the
#   middle of the platform (ankle level with its centre line, toes toward the
#   top edge; the foot spans about -5 to +20 cm of the plate's +-31 cm).
#   Knee 160° -> 95°, hip 89° -> 56°; at the bottom the knee joint is ~4 cm
#   short of the toe tips along the platform (the kneecap about over the
#   toes); knees in line with the feet.
# - Single-Leg Press (yaw -2.0): the 45-degree press with the LEFT leg only.
#   The left foot sits where it is in the two-leg press (ankle 0.20 m left of
#   the midline, ~11 cm outside the hip), knee 160° -> 95°, hip 89° -> 56°.
#   The right foot rests on a low side foot rest (0.06-0.10 m off the floor,
#   right of the seat, ankle 0.45 m right of the midline), right knee 82°, hip
#   144°, the thigh level and turned out; it does not move.
# - Narrow-Stance Leg Press (yaw -2.0): as the 45-degree press with the
#   ankles 0.20 m apart (about hip width; the hip joints are 0.18 m apart),
#   toes almost straight (~3° out), the knees straight over the ankles and
#   slightly outside them at the bottom (0.22 m apart). Knee 160° -> 95°, hip
#   89° -> 57°; the thighs finish 85° above horizontal, a touch steeper than
#   the shoulder-width press.
# - Wide-Stance Leg Press (yaw -2.0): ankles 0.68 m apart (1.7 times the
#   shoulder joints), toes turned out ~17°, feet flat near the middle of the
#   platform. Knee 160° -> 95°, hip 89° -> 55°; the knees 0.47-0.51 m apart,
#   inside the ankles but on the hip-to-ankle line, i.e. following the
#   turned-out feet, not caving in.
#
# Sources (each checked; notes_legs30_press.md maps the claims to them):
# - Escamilla RF, Fleisig GS, Zheng N, Lander JE, Barrentine SW, Andrews JR,
#   Bergemann BW, Moorman CT 2001, Med Sci Sports Exerc 33(9):1552-1566, doi
#   10.1097/00005768-200109000-00020 — squat and leg press (high and low foot
#   placement, wide and narrow stance, feet straight or turned out 30°) in 10
#   experienced lifters: no differences in muscle activity or knee forces
#   between foot angles; no knee force differences between high and low
#   placement; the wide stance with a high placement drew more hamstring
#   activity than the narrow; in the leg press the narrow stance produced
#   greater tibiofemoral and patellofemoral compressive forces than the wide,
#   the wide greater PCL tension; all knee forces rose with knee flexion.
# - Martín-Fuentes I, Oliva-Lozano JM, Muyor JM 2020, Int J Environ Res
#   Public Health 17(13):4626, doi 10.3390/ijerph17134626 — systematic review
#   of leg press EMG: the vasti most active, then the rectus femoris;
#   quadriceps activity greater with more knee flexion, peaking around 90° and
#   falling toward full extension, where the biceps femoris and gastrocnemius
#   rise; the unilateral leg press has hardly been studied.
# - Martín-Fuentes I, Oliva-Lozano JM, Muyor JM 2022, Sports Health
#   14(3):317-327, doi 10.1177/19417381211016357 — inclined leg press in
#   trained men and women: stance 100% vs 150% of hip width and feet 0° vs
#   45° turned out made no difference to vastus medialis, vastus lateralis,
#   rectus femoris or gluteus medius activity; activity greater when pressing
#   than lowering and at maximum intended speed; the authors advise the
#   lifter's preferred stance.
# - Martín-Fuentes I, Oliva-Lozano JM, Muyor JM 2020, Int J Environ Res
#   Public Health 17(22):8698, doi 10.3390/ijerph17228698 — the same five
#   conditions in trained women: vastus medialis highest, then rectus
#   femoris, vastus lateralis, gluteus medius, regardless of foot rotation
#   and stance width.
# - Da Silva EM, Brentano MA, Cadore EL, De Almeida AP, Kruel LF 2008,
#   J Strength Cond Res 22(4):1059-1065, doi 10.1519/JSC.0b013e3181739445 —
#   14 women, 45° leg press and high and low foot placements at 40% and 80%
#   1RM: at both loads the rectus femoris and gastrocnemius more active with
#   the low placement than the high; at 80% also the vastus lateralis more
#   active low and the gluteus maximus more active high.
# - Marchetti PH, Gomes WA, Da Silva JJ, Magalhaes RA, Teixeira LFM,
#   Whiting WC 2023, J Strength Cond Res 37(10):e541-e545, doi
#   10.1519/JSC.0000000000004504 — inclined leg press with the seat-back
#   angle at 90° vs 125° (15 trained men): the more reclined back gave a
#   larger hip range and more vastus lateralis, the upright 90° back (the more
#   closed hip) more biceps femoris; gluteus maximus did not differ.
# - Stien N, Saeterbakken AH, Andersen V 2021, J Sports Sci Med 20(1):56-61,
#   doi 10.52082/jssm.2021.56 — unilateral leg press at 6RM (left leg) in
#   trained men: more vastus lateralis than the knee extension, gluteus
#   maximus no different from a kickback, biceps femoris lower.
# - Hay D, de Souza VA, Fukashiro S 2006, Hum Mov Sci 25(2):181-191, doi
#   10.1016/j.humov.2005.11.007 — bilateral deficit in dynamic leg press
#   jumps (two legs less than the sum of each alone); cited in the notes only.
# - Pisz A, Blazek D, Stastny P 2026, J Funct Morphol Kinesiol 11(2):216, doi
#   10.3390/jfmk11020216 — 1RM leg press in 31 resistance-trained men under
#   bilateral, unilateral and split-load conditions: bilateral deficit ratio
#   5.16% (bilateral) and 14.29% (split-load); cited in the notes only.
# - Paoli A, Marcolin G, Petrone N 2009, J Strength Cond Res 23(1):246-250,
#   doi 10.1519/JSC.0b013e3181876811 — back squat at three stance widths:
#   only the gluteus maximus changed, higher at the widest stance.
# - McCaw ST, Melrose DR 1999, Med Sci Sports Exerc 31(3):428-436, doi
#   10.1097/00005768-199903000-00012 — parallel squat at 75%, 100% and 140%
#   of shoulder width: stance did not change the quadriceps but influenced
#   the adductor longus and gluteus maximus.
# - Sinclair J, Taylor PJ, Jones B, Butters B, Bentley I, Edmundson CJ 2022,
#   Sports (Basel) 10(9):136, doi 10.3390/sports10090136 — squats at 1.0,
#   1.25 and 1.5 times greater trochanter width (musculoskeletal model):
#   narrow stance more quadriceps force, wide stance more posterior-chain
#   force.
# - ExRx.net, exrx.net/WeightExercises/Quadriceps/ SL45LegPress,
#   SLLyingLegPress, SLSingleLeg45LegPress, SLSingleLegVerticalLegPress and
#   SLAlternating45LegPress (the last for wide stance may allow a deeper
#   range; 2019-08-24 copy), read through Internet Archive copies (2018-2019
#   snapshots; the live site blocks automated fetches): target quadriceps;
#   synergists gluteus maximus, adductor magnus, soleus; dynamic
#   stabilisers hamstrings, gastrocnemius.
#   Lower until the knees are just short of complete flexion; set the back
#   support so the range does not force the hips to bend at the waist
#   (vertical: stop just before the hips rise from the pad; flexible hips
#   allow a fuller range); knees point the same way as the feet; do not let
#   the heels rise, push with heel and forefoot; feet slightly high emphasise
#   the gluteus maximus, slightly low the quadriceps; single leg: the other
#   foot on the floor, grasp the handles.
# - StrengthLog, Leg Press guide (strengthlog.com/leg-press): feet about
#   shoulder width; as deep as possible without rounding the back and with
#   the glutes on the seat; lower back and butt still all set; knees not
#   falling in; stop before over-extending the knees; quadriceps, glutes and
#   adductors worked; grasp the handles to stabilise the upper body; some
#   people need a slightly wider stance to go deep enough; the vertical press
#   allows deeper hip flexion and demands more technique and control (its
#   suggestion of more glute and hamstring work there is not backed by EMG
#   and is not used for the rows).
# - ExRx.net Q&A, Locking Out Knees on Leg Press (exrx.net/Questions/
#   LegPressLockOut, Internet Archive copy of 2019-11-14): argues that
#   locking out is not inherently dangerous and that the widely shared
#   hyperextension injury came from a far too heavy load and other causes;
#   cited in the notes only, for the balance of the lockout cue.
# No EMG study of the vertical leg press, of a single-leg 45-degree press
# against the two-leg press, or of adductor activity by stance width in the
# leg press was found. Those rows are ranked from the closest studied lifts
# (the 45-degree press, Marchetti 2023 for the hip angle, the leg press and
# squat stance studies) and kept close to the existing Leg Press entry
# (quadriceps 0.87, gluteus maximus 0.48); see the notes.

from common_legs30 import *

NAMES = ["Vertical Leg Press", "45-Degree Leg Press", "Single-Leg Press",
         "Narrow-Stance Leg Press", "Wide-Stance Leg Press"]


def press_glows(name, legs=("thigh_L", "patella_L"), glute_dy=0.03):
    """The quadriceps along the near thigh, then the glutes on the seat under
    the hips (lower on screen than the pelvis joint)."""
    return [glow(name, list(legs), A, 0.55, rx=0.10, ry=0.07),
            glow(name, ["pelvis"], SOFT, 0.30, rx=0.07, ry=0.05, dy=glute_dy)]


# ---------------------------------------------------------------- shared cues

KNEE = ("Knee Tracking",
        "The knees travel in line with the feet.",
        "The sled runs on a fixed path, but it does not steer the knees; that is up to you. Knees that follow the toes keep the load lined up through the joint. In leg press studies the toe angle, straight or turned out, made no difference to thigh muscle activity or knee forces, so choose a comfortable angle and let the knees follow it.",
        "The knees caving in toward each other at the bottom or on the way up.",
        "Keep each knee pointing over the middle toes all the way down and up.")
KNEE_ONE = ("Knee Tracking",
            "The working knee travels in line with the foot.",
            "With one leg pressing, the whole load goes through one knee, set off to one side of the sled. A knee that follows the toes keeps that load lined up through the joint instead of taking it at an angle.",
            "The knee caving in toward the midline at the bottom or on the way up.",
            "Keep the knee pointing over the middle toes all the way down and up.")
KNEE_WIDE = ("Knee Tracking",
             "The knees push out in line with the turned-out toes.",
             "With the feet wide and turned out, the thighs have to open to follow them. Knees that follow the toes keep the load lined up through the joint; knees that cave in toward each other take it at an angle. In leg press studies thigh muscle activity and knee forces did not differ between straight and turned-out feet, so the aim is simply that the knees follow the feet.",
             "The knees caving in toward each other, inside the line of the toes, at the bottom or on the way up.",
             "Push the knees out over the middle toes all the way down and up.")
DEPTH = ("Depth",
         "Lower until the knees are bent to about a right angle, the hips still on the seat.",
         "The quadriceps work hardest in the deep part of the press, around 90 degrees of knee bend, and less as the legs straighten. How deep you can go is set by the hips: once they roll up off the seat, the lower back rounds and takes load the legs should carry. Knee forces also rise with depth, so a shorter range is reasonable for sensitive knees.",
         "Lowering so far that the hips curl up off the seat and the lower back rounds at the bottom.",
         "Set the back pad so you can reach about 90 degrees at the knee, stop the sled just before the hips start to lift, then press back up.")
LOCKOUT = ("Top Lockout",
           "Each rep stops just short of straight knees.",
           "Quadriceps activity falls away as the knees near full extension, so the last few degrees add little work for them. Stopping with a slight bend keeps the thighs loaded; technique guides advise against snapping the knees straight under a heavy sled, which rests the load on the joints.",
           "Snapping the knees fully straight at the top of every rep.",
           "Press until the legs are almost straight, keep a slight bend, then start the next rep.")
LOCKOUT_ONE = ("Top Lockout",
               "Each rep stops just short of a straight knee.",
               LOCKOUT[2],
               "Snapping the working knee fully straight at the top of every rep.",
               "Press until the leg is almost straight, keep a slight bend, then start the next rep.")
BACK = ("Back Position",
        "The lower back and hips stay against the pad.",
        "With the back supported, the leg drive goes into the sled. Arching the lower back away from the pad as you strain lets the pelvis rock and turns part of the push into a back bend.",
        "The lower back arching up off the pad as you drive the sled up.",
        "Sit all the way back, brace, and keep the lower back and hips pressed into the pad through the whole set.")
FEET_LOW_WHY = ("Higher on the platform shifts a little work toward the glutes and lower toward the quadriceps, "
                "but set too low the knees have to travel far past the toes and the heels start to lift, "
                "tipping the push onto the balls of the feet.")

# The rows stay close to the existing Leg Press entry (quadriceps 0.87,
# gluteus maximus 0.48): leg press EMG puts the vasti first, then the rectus
# femoris (Martín-Fuentes 2020 review, 2020, 2022); ExRx lists the gluteus
# maximus as the main synergist; the hamstrings and calves are dynamic
# stabilisers, the adductor magnus a synergist with no leg press EMG.
ACT = [("Quadriceps", P, HI, 0.87), ("Gluteus Maximus", S, MOD, 0.48)]

# ---------------------------------------------------------------- vertical

ex(name="Vertical Leg Press", var="verticalLegPress",
   library=("QUADRICEPS", "MACHINE", "intermediate"),
   # Seen from the head end on the left: the plate and feet at the top left,
   # the legs rising from the seat (pelvis 0.28, 0.59), the head at the right
   # (0.70, 0.61). The foot label sits above the plate, the knee labels on the
   # right above the head, and the bottom row holds two: the hip label on the
   # right (a leader across the seat to the pelvis; at 0.64 on screen it
   # covered the near arm on the left or the head on the right) and the hand
   # label on the left, a short leader up to the near hand (0.18, 0.61).
   overrides={"feet": (0.14, "leading"), "lockout": (0.14, "trailing"), "knee": (0.32, "trailing"),
              "depth": (0.86, "trailing"), "grip": (0.86, "leading")},
   annotations=[
       ("feet", "Whole foot on the plate", "foot_L"),
       ("lockout", "Soft knees at the top", "shin_L"),
       ("knee", "Knees track over toes", "patella_L"),
       ("depth", "Stop before hips lift", "pelvis"),
       ("grip", "Hands on the handles", "hand_L"),
   ],
   cues={
       "feet": ("Whole Foot",
                "Both feet stay flat on the plate, above the hips.",
                "Pushing through the heel and forefoot together keeps the sled balanced over the feet while the thighs drive it. At the bottom of a vertical press the knees come down close to the chest, and heels that lift tip the load onto the toes.",
                "The heels peeling off the plate at the bottom, the push coming from the toes.",
                "Set the feet shoulder-width apart, flat on the plate above the hips, and push through the heel and forefoot together."),
       "lockout": LOCKOUT, "knee": KNEE,
       "depth": ("Depth",
                 "Lower until the knees are bent to about a right angle, the hips still down on the pad.",
                 "Lying under the sled, the hips bend further than in a 45-degree press, so they run out of room first. Once they start to lift and curl, the lower back rounds under the load. The quadriceps work hardest around a right angle at the knee, so lower to about there, or less if the hips start to lift first.",
                 "Lowering so far that the hips curl up off the pad and the lower back rounds at the bottom.",
                 "Lower to about 90 degrees at the knee, or stop sooner if the hips start to lift, then press back up."),
       "grip": ("Hands",
                "The hands hold the handles beside the hips.",
                "Holding the handles steadies the upper body and helps keep the hips down on the pad at the bottom, so the legs do all the pressing. Pushing on the knees with the hands takes load off the legs you are training.",
                "Pushing on the knees or thighs with the hands to help the sled up.",
                "Grip the handles at your sides, keep the arms relaxed and let the legs press the sled."),
   },
   # No vertical leg press EMG study. Lying flat closes the hip further
   # (trunk-thigh 42° at the bottom, against 56° on the 45-degree press; the
   # hip range is about the same, 32° against 33°), which is closer to
   # Marchetti 2023's upright 90° seat-back condition (less vastus lateralis,
   # more biceps femoris, gluteus maximus unchanged) than to its reclined one.
   # Since the gluteus maximus did not change with hip angle, the glute row
   # stays at 0.48 and the quadriceps row sits a hair under the 45-degree
   # press (0.86).
   activation=[("Quadriceps", P, HI, 0.86), ("Gluteus Maximus", S, MOD, 0.48)],
   stabilisers=["hamstrings", "adductors", "calves"],
   comparison=("HIPS CURLING UP", "Hips down, knees about 90 degrees", "Hips curl up off the pad",
               "Stopping at about a right angle at the knee, the hips still down, keeps the load on the legs where the quadriceps work hardest.",
               "Going deeper than the hips allow rolls them up off the pad and puts the rounding lower back under the sled."),
   glows=press_glows("Vertical Leg Press", legs=("thigh_L", "patella_L", "thigh_R", "patella_R"), glute_dy=0.02))

SETUP["Vertical Leg Press"] = [
    "Lie on the back pad with your hips on the seat, right under the sled.",
    "Set the safety stops just below the lowest point you plan to reach.",
    "Place your feet flat on the plate, shoulder-width apart, above your hips.",
    "Press the sled up, release the sled's catch and hold the handles at your sides.",
]

# ---------------------------------------------------------------- 45 degree

ex(name="45-Degree Leg Press", var="legPress45",
   library=("QUADRICEPS", "MACHINE", "beginner"),
   # Rear three-quarter from the left: the platform and feet at the top left
   # (foot_L 0.15-0.22, 0.31-0.36), the knees around (0.32-0.52, 0.38-0.40),
   # the hips at (0.45, 0.53), the head at the right (0.78, 0.41). The foot
   # label goes above the platform, the two knee labels on the right above
   # the head, the hip label on the left just short of the near hand, the
   # back label low on the right below the shoulders.
   overrides={"feet": (0.14, "leading"), "lockout": (0.14, "trailing"), "knee": (0.32, "trailing"),
              "depth": (0.50, "leading"), "back": (0.68, "trailing")},
   annotations=[
       ("feet", "Feet shoulder-width, centred", "foot_L"),
       ("lockout", "Soft knees at the top", "shin_L"),
       ("knee", "Knees track over toes", "patella_L"),
       ("depth", "Hips stay on the seat", "pelvis"),
       ("back", "Lower back on the pad", "chest"),
   ],
   cues={
       "feet": ("Foot Placement",
                "Feet shoulder-width apart in the middle of the platform.",
                "In the middle of the platform the quadriceps and glutes share the press and the whole foot stays flat. " + FEET_LOW_WHY,
                "Setting the feet low on the platform, so at the bottom the knees travel far past the toes and the heels peel up.",
                "Place the feet shoulder-width apart in the middle of the platform, toes turned out slightly, and push through the heel and forefoot together."),
       "lockout": LOCKOUT, "knee": KNEE, "depth": DEPTH, "back": BACK,
   },
   activation=ACT,
   stabilisers=["hamstrings", "adductors", "calves"],
   comparison=("FEET TOO LOW", "Feet mid-platform, heels down", "Feet low, heels peel up",
               "With the feet in the middle of the platform, the whole foot stays flat and the thighs share the press between the quadriceps and glutes.",
               "Set low, the knees have to travel far past the toes at the bottom and the heels lift, tipping the push onto the balls of the feet."),
   glows=press_glows("45-Degree Leg Press"))

SETUP["45-Degree Leg Press"] = [
    "Set the back pad so you can reach about 90 degrees at the knee without your hips lifting.",
    "Sit with your back and hips flat against the pad.",
    "Place your feet shoulder-width apart in the middle of the platform.",
    "Press the platform up, release the safety handles and hold the side handles.",
]

# ---------------------------------------------------------------- single leg

ex(name="Single-Leg Press", var="singleLegPress",
   library=("QUADRICEPS", "MACHINE", "intermediate"),
   # The left leg works; the right foot rests low on the right (foot_R 0.43,
   # 0.62). Same layout as the 45-degree press; the hip label points at the
   # pelvis, whose working side lifts in the ghost.
   overrides={"foot": (0.14, "leading"), "lockout": (0.14, "trailing"), "knee": (0.32, "trailing"),
              "hip": (0.50, "leading"), "back": (0.68, "trailing")},
   annotations=[
       ("foot", "Whole foot mid-platform", "foot_L"),
       ("lockout", "Soft knee at the top", "shin_L"),
       ("knee", "Knee tracks over toes", "patella_L"),
       ("hip", "Both hips on the seat", "pelvis"),
       ("back", "Lower back on the pad", "chest"),
   ],
   cues={
       "foot": ("Foot Placement",
                "The working foot sits flat in the middle of the platform, just outside the hip.",
                "Placed where it sits in your two-leg stance, the foot lines up with the hip so the knee can track straight and the whole foot can push. " + FEET_LOW_WHY.replace("the knees have", "the knee has").replace("the heels start", "the heel starts").replace("balls of the feet", "ball of the foot"),
                "Setting the foot low on the platform, so the knee travels far past the toes and the heel peels up at the bottom.",
                "Put the working foot flat in the middle of the platform, about where it goes in your two-leg stance, and push through the heel and forefoot together."),
       "lockout": LOCKOUT_ONE, "knee": KNEE_ONE,
       "hip": ("Hip Position",
               "Both hips stay down on the seat through the rep.",
               "With one leg pressing, the load pushes on one side of the pelvis. If the working hip lifts or the pelvis tilts at the bottom, the lower back makes up the difference. Holding the handles and stopping before the hip lifts keeps the pelvis square so the thigh does the work.",
               "The working hip lifting off the seat and the pelvis tilting at the bottom of the rep.",
               "Hold the handles, keep both hips on the seat and stop the sled before the working hip starts to lift."),
       "back": BACK,
   },
   # One leg at a time: the same ranks as the two-leg press. Stien 2021's
   # unilateral leg press drew high vastus lateralis activity and gluteus
   # maximus no different from a kickback; no study compares the single-leg
   # and two-leg 45-degree press. The seat and handles hold the pelvis, so
   # the gluteus medius sits with the stabilisers.
   activation=ACT,
   stabilisers=["gluteus medius", "hamstrings", "adductors", "calves"],
   comparison=("HIP LIFTING OFF THE SEAT", "Both hips down, knee about 90 degrees", "Working hip lifts and tilts",
               "With both hips on the seat, the pelvis stays square and the working thigh takes the load.",
               "Lowering past the point where the working hip lifts tilts the pelvis and hands part of the load to the lower back."),
   glows=press_glows("Single-Leg Press"))

SETUP["Single-Leg Press"] = [
    "Set a load you can control on one leg.",
    "Sit with your back and hips flat against the pad.",
    "Place one foot flat in the middle of the platform, where it sits in your two-leg stance.",
    "Rest the other foot on the side foot rest or the floor.",
    "Press the platform up, release the safety handles and hold the side handles.",
]

# ---------------------------------------------------------------- narrow stance

ex(name="Narrow-Stance Leg Press", var="narrowStanceLegPress",
   library=("QUADRICEPS", "MACHINE", "beginner"),
   # Same layout as the 45-degree press.
   overrides={"stance": (0.14, "leading"), "lockout": (0.14, "trailing"), "knee": (0.32, "trailing"),
              "depth": (0.50, "leading"), "back": (0.68, "trailing")},
   annotations=[
       ("stance", "Feet hip-width apart", "foot_L"),
       ("lockout", "Soft knees at the top", "shin_L"),
       ("knee", "Knees track over toes", "patella_L"),
       ("depth", "Hips stay on the seat", "pelvis"),
       ("back", "Lower back on the pad", "chest"),
   ],
   cues={
       "stance": ("Stance Width",
                  "Feet about hip-width apart in the middle of the platform.",
                  "A narrow stance keeps each knee travelling in a straight line over its foot. In leg press studies stance width changed quadriceps activity little, and the knee forces shifted rather than fell: in one study the narrow stance put more compressive force on the knee, the wide stance more tension on the ligament at the back of the knee (the PCL). With the feet touching, the knees have no room at the bottom and crowd in against each other.",
                  "Setting the feet so close they touch, the knees crowding in against each other at the bottom.",
                  "Place the feet about hip-width apart, toes straight or turned out slightly, and keep space between the knees all the way down."),
       "lockout": LOCKOUT, "knee": KNEE, "depth": DEPTH, "back": BACK,
   },
   # Quadriceps unchanged at 0.87: stance width did not change quadriceps
   # EMG in the leg press (Martín-Fuentes 2022: 100% vs 150% hip width;
   # Escamilla 2001: only the hamstrings differed) or the squat (Paoli 2009,
   # McCaw & Melrose 1999). No leg press study measured the gluteus maximus
   # by stance, and no squat study shows it lower at a hip-width stance than
   # at shoulder width (Paoli 2009: only the widest stance differed, higher;
   # McCaw & Melrose 1999: a load-by-stance interaction, its direction not
   # given in the abstract), so the glute row stays at the 45-degree press's
   # 0.48.
   activation=[("Quadriceps", P, HI, 0.87), ("Gluteus Maximus", S, MOD, 0.48)],
   stabilisers=["hamstrings", "adductors", "calves"],
   comparison=("FEET TOO CLOSE", "Hip-width, knees over the feet", "Feet touching, knees crowd in",
               "With the feet hip-width apart, each knee tracks straight over its foot and the quadriceps drive the press.",
               "With the feet touching, the knees run out of room at the bottom and press in against each other."),
   glows=press_glows("Narrow-Stance Leg Press"))

SETUP["Narrow-Stance Leg Press"] = [
    "Set the back pad so you can reach about 90 degrees at the knee without your hips lifting.",
    "Sit with your back and hips flat against the pad.",
    "Place your feet hip-width apart in the middle of the platform.",
    "Press the platform up, release the safety handles and hold the side handles.",
]

# ---------------------------------------------------------------- wide stance

ex(name="Wide-Stance Leg Press", var="wideStanceLegPress",
   library=("QUADRICEPS", "MACHINE", "beginner"),
   # Same layout as the 45-degree press; the stance label is the longest
   # (26 characters) and still ends above the platform's top edge.
   overrides={"stance": (0.14, "leading"), "lockout": (0.14, "trailing"), "knee": (0.32, "trailing"),
              "depth": (0.50, "leading"), "back": (0.68, "trailing")},
   annotations=[
       ("stance", "Feet wide, toes turned out", "foot_L"),
       ("lockout", "Soft knees at the top", "shin_L"),
       ("knee", "Knees out over the toes", "patella_L"),
       ("depth", "Hips stay on the seat", "pelvis"),
       ("back", "Lower back on the pad", "chest"),
   ],
   cues={
       "stance": ("Stance Width",
                  "Feet wider than the shoulders, toes turned out a little.",
                  "A wide stance lets the thighs open out and can make room for a deeper rep. In leg press studies stance width changed quadriceps activity little, and one found more hamstring activity with a wide stance set high on the platform; in squats, the widest stance drew more glute activity. The feet still need to sit high enough on the platform for the heels to stay down.",
                  "Setting the feet wide but low on the platform, so the heels peel up and the knees drive far forward at the bottom.",
                  "Place the feet about one and a half shoulder-widths apart in the middle of the platform, toes turned out a little, and keep the heels down."),
       "lockout": LOCKOUT, "knee": KNEE_WIDE, "depth": DEPTH, "back": BACK,
   },
   # Quadriceps unchanged at 0.87: stance width did not change quadriceps
   # EMG in the leg press (Martín-Fuentes 2022; Escamilla 2001) or the squat
   # (Paoli 2009; McCaw & Melrose 1999). The glutes a step up and an adductor
   # row from the squat stance studies (Paoli 2009: gluteus maximus higher at
   # the widest stance; McCaw 1999: stance changed adductor longus and
   # gluteus maximus activity, not the quadriceps), the adductors kept low:
   # no leg press study measured the glutes or adductors by stance.
   activation=[("Quadriceps", P, HI, 0.87), ("Gluteus Maximus", S, MOD, 0.54),
               ("Adductors", S, LOW, 0.34)],
   stabilisers=["hamstrings", "calves"],
   comparison=("KNEES CAVING IN", "Knees out over the toes", "Knees cave in toward each other",
               "With the knees following the turned-out toes, the wide stance opens the hips and the load stays lined up through the knees.",
               "When the knees cave in toward each other in a wide stance, the knee takes the load at an angle and the hips lose the room the stance was for."),
   glows=press_glows("Wide-Stance Leg Press"))

SETUP["Wide-Stance Leg Press"] = [
    "Set the back pad so you can reach about 90 degrees at the knee without your hips lifting.",
    "Sit with your back and hips flat against the pad.",
    "Place your feet wider than your shoulders in the middle of the platform, toes turned out a little.",
    "Press the platform up, release the safety handles and hold the side handles.",
]

if __name__ == "__main__":
    probs = validate(NAMES) + validate_library(NAMES); print("\n".join(probs) or "OK")
