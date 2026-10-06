# Trainer content for the 401-500 folder, third round (445-474, 2026-10-05),
# family: carrymarch. Two loaded marches on the spot from the builder's
# exports: 469 Farmer Carry March (Abs/FarmerCarryMarch) and 470 Suitcase
# Carry March (Abs/SuitcaseCarryMarch). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_carrymarch.md maps the copy's claims to the sources below
# and records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (SCRATCH/lab/r3/carrymarch/series.py: every frame, joints, knee, hip and
# elbow angles, thigh and trunk angles, pelvis height, tilt and turn, hand and
# dumbbell positions; the app's Y-up space, the lifter facing +z, their left
# +x), the round's motion briefs, the trainer stills at 0/1/2/3/5 s,
# joints.json and tiers.txt. One body (torso, neck to pelvis, 0.592 m),
# clips of 7.96 s that loop. The two clips share the same legs frame for
# frame:
# - Stance: feet about hip-width (ankle joints 22 cm apart, hip joints 18 cm),
#   toes forward, standing knee 173-174 deg (long, not locked hard), trunk
#   upright (0.4 deg back, side bend 0.1 deg at most), shoulders level, the
#   hips level all clip (pelvis tilt 0.0 deg), the pelvis at the same height
#   all clip and sliding 1.6 cm toward the standing leg on each lift, turning
#   2 deg at most.
# - March on the spot, no travel, LEFT knee first: the left heel leaves the
#   floor at ~0.1 s, the knee rises over ~0.5 s and holds at the top
#   0.6-1.2 s (knee 78 deg, hip 98 deg between trunk and thigh, the thigh
#   7 deg short of level, the knee joint 5.6 cm below the hip joint and 44 cm
#   in front of it, the shin tipped 19 deg back so the foot sits a little
#   behind the knee, the ankle joint 48 cm and the toes ~37 cm off the
#   floor), comes down over ~0.5 s and is down at 1.71 s; both feet on the
#   floor 1.71-2.13 s; the right knee the same 2.13-3.71 s; both down to
#   4.13 s; then again. Four knee lifts in the clip, one every 2 s (each knee
#   every 4 s). The heel is up ~1.6 s (0.08-1.75 s) but the whole foot, the
#   ball included, is off the floor only ~1.3 s (0.25-1.58 s).
# - Farmer Carry March: a dumbbell in each hand (HG_WeightL/R, 0.34 m long,
#   handles front to back, centres 0.82 m up beside the thighs, lowest point
#   0.73 m), palms facing in, arms long (elbows 171 deg) and ~15 deg out from
#   the sides; the dumbbells and arms do not move all clip (centres within
#   7 mm). Paint: ONLY Sartorius bright (the library's "Hip Flexors", a
#   legend-only name); dim: the forearm flexors and extensors,
#   brachioradialis and palmaris longus, external and internal obliques,
#   gluteus maximus, medius and minimus, rectus abdominis, rhomboid major and
#   the three trapezius parts.
# - Suitcase Carry March: ONE dumbbell, in the RIGHT hand (HG_WeightR, as
#   the farmer's right), palm in, arm long (171 deg), not moving. The free
#   left arm hangs relaxed (elbow 163-168 deg, the hand 24-27 cm out from
#   the midline, nearer the body than the loaded hand's 33 cm) and swings a
#   little: from 2 deg behind to 18 deg in front of straight down (rest
#   6 deg), forward while the right knee is up. No lean toward the weight:
#   the shoulders level and the trunk upright every frame. Paint: external
#   and internal obliques and Sartorius bright; dim: the forearm muscles,
#   erector spinae, the three glutei, rectus abdominis, rhomboid major and
#   the trapezius.
#
# How they differ from the library: the Farmer's Carry, Suitcase Carry and
# Overhead Carry walk (on the spot, feet sliding back) with short low steps;
# here the feet do not travel and each knee is driven up to just below hip
# height and held, so every lift is ~1.3 s on one leg under the load. Round
# 2's Farmer's Walk on Toes steps on the spot on the balls of the feet with
# the soles ~3 cm up; here the feet are flat and the knees high.
# Cue sets: knee, posture, hips, grip, shoulders (farmer); level, shoulder,
# knee, hips, tempo (suitcase).
#
# Sources (abstracts read on Europe PMC / PubMed 2026-10-05, full texts where
# noted; web pages read 2026-10-05; details and quotes in the notes):
# - Ellestad SH, Holcomb TP, Swiergol AM, Holmstrup ME, Dicus JR 2024, Int J
#   Exerc Sci 17(1):480-490, doi:10.70252/NWUE9985, PMID 38665162 (full text
#   PMC11042841) - 18 college-aged adults, surface EMG, time- and
#   intensity-matched farmer's carry (two dumbbells, 50.7 kg in all) and
#   suitcase carry (25.3 kg in the RIGHT hand): farmer's carry external
#   oblique 11.1-14.2% MVIC, rectus abdominis 8.4-10.7, longissimus
#   13.7-16.4, multifidus 14.9-16.3; suitcase carry left external oblique
#   33.0 (right 9.6; the plank 34.5-36.1, not different), left longissimus
#   29.1, multifidus 21.0, rectus abdominis 18.9 (Table 2).
# - Bordelon NM, Wasserberger KW, Cassidy MM, Oliver GD 2021, J Strength
#   Cond Res 35(Suppl 1):S114-S119, doi:10.1519/JSC.0000000000003880, PMID
#   33298714 (abstract via Crossref) - 18 resistance-trained adults,
#   one-dumbbell carries: in the suitcase position the gluteus medius and
#   external oblique of the side away from the load were significantly more
#   active; most muscles rose with load.
# - McGill SM, McDermott A, Fenwick CM 2009, J Strength Cond Res
#   23(4):1148-1161, doi:10.1519/JSC.0b013e318198f8f7, PMID 19528856 -
#   strongman events including the farmer's walk and suitcase carry; in
#   the yoke walk, where the hip abductors fall short, muscles such as the
#   quadratus lumborum make up for it with frontal-plane torque that
#   supports the torso and pelvis (the abstract's example; it gives no
#   result for the farmer's walk or suitcase carry); loaded carrying
#   challenges different abilities than lifting.
# - Stastny P, Lehnert M, Zaatar A, Svoboda Z, Xaverova Z, Pietraszewski P
#   2015, J Hum Kinet 45:157-165, doi:10.1515/hukin-2015-0016, PMID 25964819
#   (PMC4415828) - 16 trained men, farmer's walk at 75% of 6RM: gluteus
#   medius 26-47% MVIC (group means).
# - Neumann DA, Cook TM 1985, Phys Ther 65(3):305-311,
#   doi:10.1093/ptj/65.3.305, PMID 3975279 - 24 healthy adults walking with
#   loads of 10 and 20% of body weight: carried in the hand opposite the
#   stance hip, the load gave that hip's gluteus medius its highest EMG.
# - Graber KA, Loverro KL, Baldwin M, Nelson-Wong E, Tanor J, Lewis CL 2021,
#   J Appl Biomech 37(4):351-358, doi:10.1123/jab.2020-0273, PMID 34051700 -
#   26 adults walking with a 15-20% body-weight weight in one hand: hip
#   abductor activity rose on the side away from the weight, not on its
#   side; the abstract opens by tying pelvic drop to low hip abductor
#   activity.
# - Andersson E, Oddsson L, Grundstrom H, Thorstensson A 1995, Scand J Med
#   Sci Sports 5(1):10-16, doi:10.1111/j.1600-0838.1995.tb00004.x, PMID
#   7882121 - fine-wire EMG of psoas and iliacus in 7 adults: both were
#   coactivated, particularly when hip flexor torque was required; the psoas
#   also in contralateral loading needing frontal-plane spine stabilisation.
# - ExRx.net (Internet Archive): Iliopsoas (snapshot 2024-01-05: hip
#   flexion; related muscles include sartorius and rectus femoris), Gluteus
#   Medius (2025-04-18: steadies the pelvis so it does not sag when the
#   opposite side is not supported with a leg).
# - The Prehab Guys (read 2026-10-05): Carry - Suitcase, Bilateral, In Place
#   (a dumbbell in each hand at your sides, shift your weight to one side as
#   you bring the other knee up, march in place keeping the torso as still as
#   possible; feel the forearms, shoulders and hips; back straight up, do not
#   bend over; dumbbells at your side, not moving forward or backward; do not
#   shrug, traps relaxed) and Carry - Suitcase, Unilateral, In Place (one
#   dumbbell; feel the forearms, trap and hips; the same compensations, the
#   trap relaxed while holding the dumbbell). Both say to bring the knee to
#   the chest; the models lift it to just below hip height.
# - Motra (read 2026-10-05): Dumbbell Farmer's March (lift one knee until
#   the thigh is parallel to the floor, pause briefly at the top, lower under
#   control, resist leaning side to side; cues ribs down, drive knee up, grip
#   hard, stay tall, resist swaying; tempo 2-1-2; common mistakes leaning
#   backward, shifting hips sideways, rushing the tempo, shoulders rounding
#   forward; primary abs, obliques, hip flexors, secondary glutes and
#   forearms) and Dumbbell Single-Arm March (marches forward; knees to hip
#   height, shoulders level, upright with no side lean, march controlled;
#   common mistakes leaning toward the weight, shrugging the shoulder,
#   rushing steps, dropping the core; switch hands; primary obliques and
#   abs).
# No EMG study of either march was found. Every fraction below is a
# judgement call anchored on the library's Farmer's Carry and Suitcase Carry
# rows (which rest on Ellestad 2024, Stastny 2015, Bordelon 2021 and McGill
# 2009) and moved for what the march adds: a hip flexor lift and ~1.3 s on
# one leg per step.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# Both marches lift the same legs the same way (the clips share their legs
# frame for frame). Hip Flexors is painted bright on both (the rig's Sartorius
# mesh), so it is a PRIMARY row; it is a legend-only name the app counts for
# no muscle group. The fraction is a judgement: the thigh is driven to just
# short of level and held ~0.6 s, one leg at a time, with only the leg's own
# weight to lift (Andersson 1995: psoas and iliacus work together when hip
# flexor torque is needed). Below the library's hanging knee raise (0.76),
# where both legs hang from the hips.
HIP_FLEXORS = ("Hip Flexors", P, MOD, 0.60)

# ---------------------------------------------------------------- Farmer Carry March

N = "Farmer Carry March"
ex(name=N, var="farmerCarryMarch",
   # Three-quarter from the front left (yaw -1.0): the lifter faces
   # screen-left, the near (left) arm and dumbbell on the right of the frame
   # (u ~0.60-0.84, v ~0.24-0.56), the far arm and dumbbell left of the
   # trunk (u ~0.35-0.51); the lifted knees swing out to the left (u
   # ~0.27-0.45, v ~0.45-0.72, the lifted right shoe down to u ~0.21). The
   # open space is the left column above the knees and below the lifted
   # shoe, and the top right. Posture top left to the head; shoulders top
   # right to the near shoulder; grip left to the far hand, above the far
   # dumbbell (0.28: at the draft's 0.34 the pill's corner sat on the lifted
   # near thigh in the grip mistake view, lab round 2); hips left to the far hip, between the lifted thigh and shoe
   # (its leader passes over the lifted near thigh while the left knee is
   # up: no leader reaches the hips from the open side without crossing an
   # arm or a dumbbell); knee bottom left to the far knee.
   overrides={"posture": (ov(0.16), "leading"), "shoulders": (ov(0.16), "trailing"),
              "grip": (ov(0.28), "leading"), "hips": (ov(0.60), "leading"),
              "knee": (ov(0.78), "leading")},
   annotations=[
       ("knee", "Knee up to hip height", "patella_R"),
       ("posture", "Tall, no leaning back", "head"),
       ("hips", "Hips level", "thigh_R"),
       ("grip", "Weights hang still", "hand_R"),
       ("shoulders", "Shoulders back", "upper_arm_L"),
   ],
   cues={
       "knee": ("Knee Height",
                "Drive each knee up until the thigh is about level with the hip, and hold it there a moment.",
                "The high knee is what makes this more than standing with weights: the hip flexors lift the leg and hold it, and for those moments you balance yourself and both dumbbells on one foot. One guide for this march lifts the knee until the thigh is parallel to the floor, pauses briefly at the top and lowers under control, and lists rushing the tempo as a common mistake. Here the thigh stops just short of level, holds about half a second and comes down in about half a second.",
                "Short, hurried lifts with the thigh well below level.",
                "Lift each knee until your thigh is about level with your hip, the foot just behind the knee, hold a beat, then set the foot down where it started: one knee about every two seconds."),
       "posture": ("Posture",
                   "Stay tall, ribs over the hips, as each knee comes up.",
                   "The knee rises because the hip bends. Leaning the shoulders back raises the thigh further off the floor without the hip bending any more, so part of the knee's height comes from the lean instead of the hip. One guide for this march lists leaning backward among its common mistakes; another says to keep the back straight up and not to bend over.",
                   "Leaning the shoulders back behind the hips as the knee rises.",
                   "Brace, keep your ribs down over your hips and your head over your shoulders, and let only the leg move."),
       "hips": ("Level Hips",
                "Keep both hip bones level while one foot is off the floor.",
                "Each lift leaves you on one leg for well over a second with both dumbbells. The hip muscles of the standing leg, the gluteus medius among them, keep the other side of the pelvis from sagging; in one farmer's walk study, group averages for the gluteus medius ran from about 26 to 47 percent of its maximum.",
                "The hip on the lifted side dropping as the foot leaves the floor.",
                "Shift your weight onto the standing foot as the other one lifts, and keep the two sides of your pelvis at the same height until it is back down."),
       "grip": ("Grip and Arms",
                "Grip hard and let the dumbbells hang still beside your thighs.",
                "The dumbbells hang from your hands for the whole set, so the forearms work from the first second to the last. One guide for this march says to grip hard, another to keep the dumbbells at your sides, not moving forward or backward. A dumbbell that swings forward takes its weight out from under the shoulder, so the shoulder and trunk have to hold it out in front.",
                "Dumbbells swinging forward and back as the knees come up.",
                "Squeeze each handle in the middle, palms facing in, arms long, and keep both dumbbells beside your thighs while the legs move."),
       "shoulders": ("Shoulders",
                     "Shoulders back and down, chest up, under the weights.",
                     "Two dumbbells hanging from your hands pull down on the shoulders for the whole set. One guide for this march lists the shoulders rounding forward among its common mistakes, and another says not to shrug either shoulder but to keep the traps relaxed: the shoulders sit back and down, neither slumped nor hitched up.",
                     "Shoulders rounding forward over the dumbbells, the upper back hunching.",
                     "Draw your shoulder blades gently back and down, keep your chest up and your neck long, and hold that while the knees move."),
   },
   # Paint: ONLY the hip flexors (Sartorius) bright; dim the forearms,
   # obliques, glutes, rectus abdominis, rhomboid and trapezius. validate()
   # needs a primary row the app counts, and Hip Flexors counts for no group,
   # so one dim muscle is made PRIMARY: the forearms, a deliberate exception
   # to bright = primary. Of the counted muscles the grip has the best case to
   # lead: the dumbbells hang from the hands for the whole timed set, the
   # library's Farmer's Carry ranks Forearm Flexors first (0.80) for the same
   # job, and The Prehab Guys' in-place version says you feel the forearms;
   # the trunk muscles, the other candidate (the library row says GRIP +
   # CORE), measured low in a farmer's carry (Ellestad 2024: external oblique
   # 11-14%, rectus abdominis 8-11% MVIC). Forearms 0.80 (the Farmer's Carry
   # value; no EMG, a judgement), named as a group because the paint lights
   # the flexors, extensors and brachioradialis alike. Secondary, paint-led:
   # Gluteus Medius 0.45 (Stastny 2015's group means of 26-47% MVIC in the
   # farmer's walk;
   # the library carry's 0.40 raised a little for the ~1.3 s on one leg per
   # lift; a judgement), Trapezius 0.40 (the Farmer's Carry's upper trapezius
   # 0.45, named whole as all three parts are lit; a judgement), Obliques 0.35
   # (the Farmer's Carry's value; Ellestad 2024's 11-14% MVIC). Rectus
   # abdominis and rhomboids, also dim, go in the stabilisers: a fourth
   # secondary name would run the one-line legend past its width (~40 characters).
   activation=[HIP_FLEXORS, ("Forearms", P, HI, 0.80),
               ("Gluteus Medius", S, MOD, 0.45), ("Trapezius", S, MOD, 0.40), ("Obliques", S, LOW, 0.35)],
   stabilisers=["rectus abdominis", "erector spinae", "rhomboids", "quadratus lumborum"],
   comparison=("LEANING BACK", "Tall, thigh up to hip height", "Shoulders tip back as the knee rises",
               "Staying tall, ribs stacked over the hips, makes the hip lift the thigh while you balance the dumbbells on one leg.",
               "Leaning back gets the knee up by tipping the trunk instead of bending the hip further."),
   glows=[glow(N, ["thigh_L", "pelvis"], A, 0.55, 0.045, 0.05, -0.03, 0.03),
          glow(N, ["forearm_L", "hand_L"], A, 0.50, 0.03, 0.05, 0.0, 0.0),
          glow(N, ["forearm_R", "hand_R"], SOFT, 0.30, 0.03, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Stand tall between two dumbbells, feet about hip-width apart.",
    "Squat down with a flat back, grip each handle in the middle, palms facing in, and stand up.",
    "Let the dumbbells hang beside your thighs, arms long, shoulders down and back.",
    "Brace, then march on the spot, one knee about every two seconds, for the set time.",
]

# ---------------------------------------------------------------- Suitcase Carry March

N = "Suitcase Carry March"
ex(name=N, var="suitcaseCarryMarch",
   # Nearly face-on (yaw -0.3): the loaded right arm and dumbbell on the left
   # of the frame (u ~0.22-0.42, v ~0.24-0.56), the free left hand on the
   # right (u ~0.68-0.72, v ~0.46); the lifted knees come forward in the
   # middle (left knee u ~0.50, right knee u ~0.35, v ~0.48). Shoulder top
   # left, above the loaded shoulder (lower, the pill would sit on the
   # loaded arm); level top right to the head. Both top pills are short: in
   # the mistake view the lifted, shrunk model brings the shoulders up to
   # their row (lab round 1: the longer pills touched the shoulders and the
   # shrug ghost). Hips right to the left hip, under the free hand; knee
   # right to the left knee, its leader beside the lifted shin, its label
   # short (the draft's Knee to hip height reached over the standing left
   # calf while the right knee was up, lab round 2); tempo bottom left to
   # the right foot.
   overrides={"level": (ov(0.16), "trailing"), "shoulder": (ov(0.16), "leading"),
              "hips": (ov(0.56), "trailing"), "knee": (ov(0.72), "trailing"),
              "tempo": (ov(0.80), "leading")},
   annotations=[
       ("level", "No side lean", "head"),
       ("shoulder", "Shoulder down", "upper_arm_R"),
       ("knee", "Knee hip-high", "patella_L"),
       ("hips", "Hips stay level", "thigh_L"),
       ("tempo", "Slow, steady march", "foot_R"),
   ],
   cues={
       "level": ("Stay Level",
                 "Stand straight with both shoulders level; the dumbbell does not pull you over.",
                 "A dumbbell in one hand pulls the trunk down toward it, so the muscles on the other side have to hold you upright. In one EMG study of a suitcase carry with the weight in the right hand, the left external oblique worked at about a third of its maximum, about as hard as in a plank and more than three times the right side's level. Leaning toward the weight lets it bend you sideways instead.",
                 "Bending sideways toward the dumbbell as the knees come up, the loaded shoulder sinking.",
                 "Keep your head over the middle of your feet and your ribs over your hips, and let the free side work to hold you straight."),
       "shoulder": ("Loaded Shoulder",
                    "Let the dumbbell hang from a long arm, the shoulder relaxed down.",
                    "One guide for this exercise says not to shrug the shoulder but to keep the trap relaxed while you hold the dumbbell, and a guide to a one-dumbbell march lists shrugging the shoulder among its common mistakes. A shoulder hitched up toward the ear also tips the line of the shoulders out of level.",
                    "The loaded shoulder hitched up toward the ear.",
                    "Hold the handle in the middle, palm facing in, arm long by your side, and keep both shoulders down at the same height."),
       "knee": ("Knee Height",
                "Raise each knee until the thigh is close to level with the hip.",
                "Each high knee leaves you on one foot with the load hanging off to one side, so the trunk and the standing hip hold you up on their own. One guide to a one-dumbbell march takes the knees to hip height; in this model the thigh stops a few degrees short of level and pauses there.",
                "Lazy knee lifts that stop with the thigh angled well down.",
                "Drive each knee up until your thigh is nearly level with your hip, the foot a little behind the knee, then lower it to where it started."),
       "hips": ("Level Hips",
                "Both hip bones stay level, most of all when the dumbbell-side knee lifts.",
                "With the dumbbell in your right hand, the left hip works hardest when you stand on the left foot as the right knee comes up: the load then hangs on the side with no leg under it. In walking studies, a load in the hand opposite the standing leg drew the most from that hip's gluteus medius, and a weight in one hand raised hip abductor activity on the side away from it.",
                "The hip on the lifted side sagging, worst as the dumbbell-side knee comes up.",
                "Hold both sides of the pelvis at the same height as you shift onto the standing foot; take extra care as the knee on the dumbbell side rises."),
       "tempo": ("Tempo",
                 "A steady march: lift, pause briefly, lower under control.",
                 "A controlled pace gives you time to shift onto the standing foot as each knee comes up. One guide to a one-dumbbell march asks for a controlled march and lists rushing the steps among its common mistakes. Here a knee comes up every two seconds and pauses about half a second at the top.",
                 "Hurrying from one knee to the next with no pause at the top.",
                 "Lift, hold a beat, lower softly, then lift the other knee; when the set time is up, switch the dumbbell to the other hand."),
   },
   # Paint: obliques (external and internal) and the hip flexors (Sartorius)
   # bright -> both PRIMARY; dim: forearms, erector spinae, glutes, rectus
   # abdominis, rhomboid, trapezius. Obliques 0.62 (the library Suitcase
   # Carry's 0.60, nudged for the ~1.3 s on one leg per lift; Ellestad 2024:
   # the side away from the load at 33% MVIC, about a plank's level;
   # Bordelon 2021 agrees on the side; a judgement), Hip Flexors 0.60 (shared,
   # above). Secondary, paint-led: Forearms 0.55 (the Suitcase Carry's
   # forearm flexors; the whole load hangs from one hand), Erector Spinae 0.50
   # (the Suitcase Carry's value; Ellestad 2024: left longissimus 29% and
   # multifidus 21% MVIC), Glutes 0.42 (the Suitcase Carry's gluteus medius
   # value; Neumann and Cook 1985, Graber 2021, Bordelon 2021: the gluteus
   # medius away from the load works harder; named "Glutes", as the paint
   # lights all three, because FOREARMS, ERECTOR SPINAE, GLUTEUS MEDIUS
   # truncated the one-line legend on the lab shot). The trapezius, rectus
   # abdominis and rhomboids, also dim, go in the stabilisers: a fourth
   # secondary name would run the legend past its width.
   activation=[("Obliques", P, MOD, 0.62), HIP_FLEXORS,
               ("Forearms", S, MOD, 0.55), ("Erector Spinae", S, MOD, 0.50), ("Glutes", S, MOD, 0.42)],
   stabilisers=["quadratus lumborum", "trapezius", "rectus abdominis", "rhomboids"],
   comparison=("LEANING TOWARD THE WEIGHT", "Shoulders level, knee up", "Shoulders tip toward the dumbbell",
               "Staying upright with a knee up makes the free side's obliques, and the hip you stand on, hold the one-sided load.",
               "Bending toward the dumbbell lets the load bend the spine sideways instead of the trunk muscles holding it straight."),
   glows=[glow(N, ["spine", "thigh_L"], A, 0.55, 0.045, 0.06, 0.05, -0.03),
          glow(N, ["spine", "thigh_R"], SOFT, 0.32, 0.045, 0.06, -0.05, -0.03),
          glow(N, ["thigh_L", "thigh_R"], SOFT, 0.30, 0.09, 0.035, 0.0, 0.04)])

SETUP[N] = [
    "Stand beside a dumbbell with your feet about hip-width apart.",
    "Squat down, back flat, and pick it up in your right hand, palm facing in.",
    "Stand tall with both shoulders level and the free arm hanging relaxed.",
    "March on the spot for the set time, then hold the dumbbell in the left hand for the next set.",
]
