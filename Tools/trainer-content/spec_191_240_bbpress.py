# Trainer content for batch 191-240 (2026-09-26): barbell, Smith and landmine
# presses, converted from SourceExports/190-240 (191, 192, 193, 199, 200, 201,
# 204, 205). Same format as spec.py, on top of common_191_240.py.
#
# What each model shows, from the rig (joint angles and positions sampled
# across the clip) and the framing screenshots:
# - Seated Barbell Overhead Press: sits upright on a bench near the front of
#   the seat, trunk vertical and clear of the short back pad (~0.12 m gap),
#   knees ~120°, feet flat ~0.42 m apart. Overhand grip ~0.76 m wide (hands a
#   hand's width outside the shoulders). The bar comes down in front of the
#   face to chin height (elbows ~55°) and goes up to ~162° over the top of the
#   head; the head never moves. Two reps in 8 s.
# - Behind-the-Neck Press: standing, feet ~0.30 m apart, knees straight. Grip
#   ~0.72 m. The bar is lowered behind the head to just below the base of the
#   skull, level with the chin, against the back of the upper traps (bar
#   ~9 cm above the shoulder joints, hands ~3 cm), elbows ~37° and ~22 cm
#   below the shoulders, forearms vertical from the side, upper arms just
#   behind the frontal plane, head held ~5 cm forward of the neck all clip;
#   full lockout (180°) with the bar just behind the head.
# - Push Press: standing, feet ~0.34 m apart, knees soft (~157°) when upright.
#   Same arm motion and grip as the seated press: the bar is held in front of
#   the chin (~12 cm in front of the shoulders, elbows behind it), not racked
#   on the shoulders, and the arms stay still through the dip. Each rep dips
#   ~8 cm (knees to ~125°, trunk vertical), drives, and presses while the legs
#   finish; the bar is lowered with the legs still. No re-dip under the bar
#   (not a jerk).
# - Z Press: sitting on a floor mat, legs straight (~171°) and ~0.40 m apart,
#   trunk vertical (hip ~97°), no back support. Arm motion identical to the
#   seated press.
# - Smith Machine Shoulder Press: on an adjustable bench with the back pad
#   ~10° off vertical, back on the pad, knees ~112°, feet flat. Grip ~0.58 m
#   (just outside the shoulders). The bar runs straight up and down ~0.15 m in
#   front of the shoulder joints, from collarbone height (bar ~5 cm above the
#   shoulder joints, ~10 cm below the chin; elbows ~36°, just behind the bar)
#   to ~178°.
# - Landmine Shoulder Press: one bar end in the LEFT hand; split stance with
#   the RIGHT foot forward (the foot opposite the pressing arm), front knee
#   straight (~175°), back knee ~150° and back heel slightly up, trunk ~4°
#   forward; the right hand rests on the right hip. The bar end starts at the
#   front of the shoulder with the elbow folded (~20°), pointing down close to
#   the side (~25° out, level with the shoulder front to back), and finishes
#   up and forward (hand ~0.32 m above and ~0.43 m ahead of the shoulder, elbow
#   ~166°). Compared with the
#   chest Single-Arm Landmine Press model (spec_chest3.py): that one starts at
#   chest height (hand ~0.18 m below the shoulder), finishes a little lower
#   and further forward (upper arm ~119° vs ~130° here), stands with the
#   pressing-side foot forward and hangs the free arm at the side. The two
#   paths are otherwise close (both ~45-50° above horizontal), so the copy
#   ranks the front deltoid first here and the upper chest first there.
# - Half-Kneeling Landmine Press: LEFT knee down under the hip (hip ~170°,
#   back toes tucked), RIGHT foot flat ahead (knee ~92°, shin vertical), LEFT
#   arm presses, right hand on the right hip. Same arm path as the standing
#   landmine press.
# - Viking Press: standing, feet ~0.30 m apart, knees straight, both hands on
#   a landmine Viking handle with neutral grips (palms facing in, ~0.50-0.63 m
#   apart). The handles start at the front of the shoulders (collarbone
#   height, ~10 cm below the chin) with the elbows folded (~21°) and tucked at
#   the sides, open out to the sides mid-press, and finish up and forward
#   (elbows ~160°, hands ~0.41 m ahead of the shoulders, about level with the
#   top of the head).
#
# Framings: yaw -0.8 (seated, behind-the-neck, push press), -1.3 (Z press),
# -0.6 (Smith), -1.0 (landmines, Viking). The lifter's LEFT arm is on the
# RIGHT of the screen in all eight.
#
# Sources (each checked; see notes_191_240_bbpress.md for which claim each
# supports):
# - Saeterbakken AH, Fimland MS 2013, J Strength Cond Res 27(7):1824-1831,
#   doi 10.1519/JSC.0b013e318276b873 — seated vs standing, barbell vs dumbbell
#   shoulder press: seated barbell ~7% lower medial and ~25% lower posterior
#   deltoid than standing; barbell raises triceps and biceps activity.
# - Saeterbakken AH, Fimland MS 2012, Eur J Appl Physiol 112(5):1671-1678,
#   doi 10.1007/s00421-011-2141-7 — core activity in shoulder presses: far
#   higher external oblique activity one-arm than two-arm, and standing than
#   seated.
# - Campos YAC et al. 2020, J Hum Kinet 75:5-14, doi 10.2478/hukin-2020-0033
#   — shoulder press: anterior 33.3%, medial 27.9%, posterior 11.4% MVIC.
# - Paoli A, Marcolin G, Petrone N 2010, J Strength Cond Res 24(6):1578-1583,
#   doi 10.1519/JSC.0b013e3181d756ea — sitting military press: reps finished
#   at full elbow extension (180°) drew more EMG in the deltoids, triceps and
#   upper trapezius than reps stopped at 90° or 135° (partial reps cut at the
#   top, so it backs pressing to straight arms, not the lowering depth).
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2022, Front Physiol
#   13:825880, doi 10.3389/fphys.2022.825880 — seated front vs back barbell
#   press and machine press: back press more medial and posterior deltoid,
#   front press more pectoralis; barbell more deltoid than machine; back
#   press bar lowered to below the external occipital protuberance, grip set
#   for 90° at the elbow with the upper arm at 90°.
# - Padovan R et al. 2026, J Hum Kinet 103:81-96, doi 10.5114/jhk/205466 —
#   HD-EMG front vs back press: front more anterior deltoid and pectoralis in
#   both phases; back more posterior deltoid, upper trapezius and triceps only
#   while lowering; no lateral deltoid amplitude difference.
# - Kebaetse M, McClure P, Pratt NA 1999, Arch Phys Med Rehabil
#   80(8):945-950, doi 10.1016/S0003-9993(99)90088-6 — slouched sitting cut
#   active shoulder abduction by ~24°, reduced scapular posterior tilt near
#   full elevation and lowered abduction force.
# - McKean MR, Burkett BJ 2015, J Sport Health Sci 4(3):250-257, doi
#   10.1016/j.jshs.2013.11.007 — behind-the-head press starts with less
#   thoracic extension; male lifters exceeded passive external rotation;
#   safe for lifters with normal trunk stability and full shoulder range.
# - Kolber MJ, Corrao M, Hanney WJ 2013, J Strength Cond Res 27(5):1333-1339,
#   doi 10.1519/JSC.0b013e318269f776 — high-five position exercises
#   (behind-the-neck pulldown and military press) associated with signs of
#   anterior shoulder instability in weight trainers.
# - Gundersen AH, Krosshaug T, Mausehund L, van den Tillaar R, Larsen S 2026,
#   Sports Biomech 25(6):841-854, doi 10.1080/14763141.2025.2590028 — seated
#   barbell shoulder press grip width: narrower grips lift more with more
#   shoulder and elbow range; wider grips reduce elbow moments.
# - Soriano MA, Suchomel TJ, Comfort P 2019, Sports Med 49(6):867-885, doi
#   10.1007/s40279-019-01096-8 — push press and jerks: dip then drive by
#   triple extension, forces transmitted through the trunk; a strictly
#   vertical dip is a key difference in jerk performance.
# - Lake JP, Mundy PD, Comfort P 2014, J Strength Cond Res 28(9):2552-2559,
#   doi 10.1519/JSC.0000000000000438 — push press power comparable with the
#   jump squat.
# - Everett G, Push Press, Catalyst Athletics exercise library
#   (https://www.catalystathletics.com/exercise/87/Push-Press/) — dip by
#   bending the knees with the trunk vertical, about 10% of height, full foot
#   on the floor; press as the legs finish; the heels rise at least slightly
#   with a full leg drive; starts from the jerk rack on the shoulders.
# - NSCA Kinetic Select, Push Jerk
#   (https://www.nsca.com/education/articles/kinetic-select/push-jerk/) — the
#   same dip: no deeper than a quarter squat, torso erect, bar straight down,
#   hips not moving back but staying under the shoulders.
# - Botton CE, Wilhelm EN, Ughini CC, Pinto RS, Lima CS 2013, Medicina
#   Sportiva 17(2):67-71, doi 10.5604/17342260.1055261 — Smith machine
#   shoulder press at 10RM: anterior deltoid ~70% MVIC, more than the other
#   lifts tested bar the bench press and pec deck; medial deltoid highest in
#   lateral raises, reverse pec deck and seated rows, not the Smith press.
# - Schick EE et al. 2010, J Strength Cond Res 24(3):779-784, doi
#   10.1519/JSC.0b013e3181cc2237 — Smith vs free-weight bench press: less
#   medial deltoid on the Smith machine.
# - Rodríguez-Ridao D et al. 2020, Int J Environ Res Public Health
#   17(19):7339, doi 10.3390/ijerph17197339 — anterior deltoid highest at
#   steep (≥45°) press angles, upper pectoralis at 30°.
# - Sands WA, Wurth JJ, Hewit JK 2012, NSCA Basics of Strength and
#   Conditioning Manual — behind-the-neck press (starts and is lowered to
#   across the shoulders; elbows under the hands, bar just behind the ears at
#   lockout in line with shoulders, hips and heels, no arching) and push
#   press (starts with the weight centred on the feet; no pause in the dip,
#   core braced).
# - Wellman A 2023, Complete Conditioning for Football, Human Kinetics
#   (foreword by T. Allen; published excerpt: half-kneeling landmine one-arm
#   press) — knee down on the pressing side, braced neutral spine, press
#   straight out and not across the body; a middle ground between horizontal
#   and vertical presses.
# - Cressey E, Strength Exercise of the Week: Half-Kneeling 1-arm Landmine
#   Press, EricCressey.com — a slight stretch on the trailing leg's hip
#   flexors with that side's glute on, brace against extension and rotation,
#   press straight out and not across the body.
# - StrengthLog exercise guides (overhead press, push press, behind the neck
#   press, Z press, landmine press) — muscles worked and step lists.
# No EMG study was found for the Z press, the landmine shoulder press, the
# half-kneeling landmine press or the Viking press; their activation rows
# are ranked from the closest studied press and kept modest (see the notes).

from common_191_240 import *

NAMES = ["Seated Barbell Overhead Press", "Behind-the-Neck Press", "Push Press", "Z Press",
         "Smith Machine Shoulder Press", "Landmine Shoulder Press", "Half-Kneeling Landmine Press",
         "Viking Press"]

FRONT_DELTS = ["deltoid_arc_clavicle_2_L", "deltoid_arc_clavicle_2_R"]


def press_glows(name, second=None, third=None, rx=0.15):
    """Front delts first, then up to two soft glows on the helpers."""
    out = [glow(name, FRONT_DELTS, A, 0.55, rx=rx, ry=0.07)]
    for joints in (second, third):
        if joints:
            out.append(glow(name, joints, SOFT, 0.30, rx=0.07, ry=0.06))
    return out


def one_arm_glows(name):
    """Left arm presses: its front delt, then the upper chest beside it (the
    triceps glow would sit on top of the delt's in these framings)."""
    return [glow(name, ["deltoid_arc_clavicle_2_L"], A, 0.55, rx=0.09, ry=0.07),
            glow(name, ["support_PectoralisMajor_Clavicular_L"], SOFT, 0.30, rx=0.08, ry=0.05)]


TRICEPS_L = ["upper_arm_L", "forearm_L"]
TRICEPS_R = ["upper_arm_R", "forearm_R"]

# ---------------------------------------------------------------- shared cues

TORSO_SEATED = ("Trunk Position",
                "The torso stays upright over the hips.",
                "Sitting tall with the ribs down keeps the press vertical; leaning back turns it into a steep incline press and loads the lower back in extension.",
                "Leaning back and arching the lower back to get the bar up.",
                "Sit tall, brace the abs and keep the ribs stacked over the pelvis for every rep.")
BARPATH_FRONT = ("Bar Path",
                 "The bar travels straight up, close to the face.",
                 "A vertical path keeps the load over the shoulders; a bar that drifts forward lengthens the lever on the shoulders and lower back.",
                 "Pressing the bar out and around the face so it locks out in front of the head.",
                 "Keep the bar close as it passes the face and finish with it over the top of the head, arms beside the ears.")
GRIP_BAR = ("Grip & Wrists",
            "Hands a hand's width outside the shoulders, wrists over the elbows.",
            "Stacked wrists push straight up into the bar. Grip width also shifts the load: narrower grips lift more through a longer range, wider ones ease the elbows.",
            "The bar rolling back into the fingers, bending the wrists back under the load.",
            "Hold the bar low in the palm, knuckles up, wrists straight and stacked over the elbows.")
# The ghost (barHeldHigh) lifts the bar ~9 cm: from the chin to the nose.
DEPTH_FRONT = ("Range of Motion",
               "Each rep comes down to about chin height.",
               "Lowering to at least chin height and pressing to straight arms trains the whole press; in a seated press study, reps pressed to full elbow extension drew more deltoid and triceps activity than reps stopped short of it.",
               "Short reps that stop with the bar at nose height.",
               "Lower under control until the bar is at least level with the chin, then press back up to arms' length over the head.")
# The Smith model comes down lower than the free-bar ones: to the collarbones.
DEPTH_SMITH = ("Range of Motion",
               "Each rep comes down to the collarbones.",
               "Lowering to the collarbones and pressing to straight arms trains the whole press; in a seated press study, reps pressed to full elbow extension drew more deltoid and triceps activity than reps stopped short of it.",
               "Short reps that stop with the bar at chin height.",
               "Lower under control until the bar is just above the collarbones, then press back to straight arms.")
FEET_SEATED = ("Base",
               "The feet anchor the seated body.",
               "Flat feet set wider than the hips give a stable base, so balancing the bar does not pull the hips around.",
               "Feet tucked under the bench or up on the toes, so the hips shift with each rep.",
               "Plant both feet flat, a little wider than the hips, and keep them still for the set.")
BRACE_STAND = ("Trunk Bracing",
               "Standing overhead, the trunk has to stay rigid.",
               "Squeezing the glutes and keeping the ribs down stops the lower back arching to chase the bar.",
               "Arching the lower back and pushing the hips forward as the bar goes up.",
               "Brace the abs, squeeze the glutes and keep the ribs stacked over the pelvis for every rep.")

# Landmine presses (the left arm presses).
LM_ELBOW = ("Elbow Position",
            "The elbow starts low and close to the side.",
            "Starting with the elbow pointing down, close to the ribs, sets the up-and-forward path the landmine is built on.",
            "Starting with the elbow flared high out to the side.",
            "Start with the bar end at the front of the shoulder and the elbow pointing down close to the ribs, then drive it forward as you press.")
LM_PATH = ("Press Path",
           "The bar end travels up and forward along its arc.",
           "The landmine's arc sits between a bench press and an overhead press, so the front deltoid drives it with the upper chest helping, without the arm going straight overhead.",
           "Pushing the bar across the body toward the midline instead of straight up and out.",
           "Press up and forward in line with the shoulder until the arm is straight, then lower back to the shoulder.")
LM_CORE = ("Trunk Position",
           "The body stays tall; only the arm moves.",
           "A braced trunk stops the one-sided load from bending you back; leaning back tips the press toward a flatter, chest-led push off an arched lower back.",
           "Leaning back from the hips to push the bar up.",
           "Brace the core, keep the ribs down over the hips and squeeze the glutes before each press.")
LM_TWIST = ("Anti-Rotation",
            "The shoulders and hips stay square while one arm presses.",
            "A one-arm press tries to turn the trunk, so the obliques work to hold it still; one-arm presses bring in far more oblique activity than two-arm presses.",
            "Twisting the pressing shoulder forward to push the bar out.",
            "Keep both shoulders facing the bar and the free hand on the hip, and let only the arm move.")
LM_ACT = [("Anterior Deltoid", P, HI, 0.80), ("Upper Pectoralis", S, MOD, 0.50),
          ("Triceps Brachii", S, MOD, 0.50), ("Obliques", S, LOW, 0.32)]

# ---------------------------------------------------------------- seated and floor presses

ex(name="Seated Barbell Overhead Press", var="seatedBarbellOverheadPress",
   # The hands pass row 0.32 on both sides, so it stays empty; the trunk label
   # goes right, clear of the right shin.
   overrides={"barpath": (0.14, "leading"), "depth": (0.14, "trailing"), "grip": (0.50, "trailing"),
              "torso": (0.68, "trailing"), "feet": (0.86, "leading")},
   annotations=[
       ("torso", "Sit tall, ribs down", "spine"),
       ("barpath", "Bar close to the face", "head"),
       ("grip", "Wrists over elbows", "forearm_L"),
       ("depth", "Lower to chin height", "hand_L"),
       ("feet", "Feet flat, wide base", "foot_L"),
   ],
   cues={"torso": TORSO_SEATED, "barpath": BARPATH_FRONT, "grip": GRIP_BAR, "depth": DEPTH_FRONT,
         "feet": FEET_SEATED},
   activation=[("Anterior Deltoid", P, HI, 0.84), ("Lateral Deltoid", P, MOD, 0.66),
               ("Triceps Brachii", S, MOD, 0.52), ("Upper Trapezius", S, LOW, 0.34)],
   stabilisers=["rotator cuff", "serratus anterior", "erector spinae"],
   comparison=("LEANING BACK", "Sit tall, bar over the head", "Lower back arches to press",
               "Sitting tall with the ribs down lets the deltoids and triceps press the bar straight up over the hips.",
               "Leaning back turns the press into a steep incline press and loads the lower back in extension."),
   glows=press_glows("Seated Barbell Overhead Press", TRICEPS_L, TRICEPS_R))

SETUP["Seated Barbell Overhead Press"] = [
    "Sit on a bench with your torso upright and feet flat, wider than your hips.",
    "Take the bar in front of your chin, hands a hand's width outside your shoulders.",
    "Wrists straight, forearms vertical under the bar.",
    "Brace your core and sit tall.",
]

ex(name="Z Press", var="zPress",
   # Side-on, facing left with the legs along the floor: labels sit in the
   # open space in front of the body and over the knees, the grip cue on the
   # near (right) arm so its leader does not cross the body.
   overrides={"depth": (0.14, "trailing"), "barpath": (0.32, "leading"), "grip": (0.50, "leading"),
              "brace": (0.68, "leading"), "torso": (0.86, "trailing")},
   annotations=[
       ("torso", "Sit tall, legs straight", "spine"),
       ("brace", "Don't lean back", "chest"),
       ("barpath", "Bar close to the face", "head"),
       ("grip", "Wrists over elbows", "forearm_R"),
       ("depth", "Lower to chin height", "hand_L"),
   ],
   cues={
       "torso": ("Sitting Position",
                 "Sit tall on the sit bones, legs straight out in front.",
                 "With no seat back and no leg drive, the trunk has to hold itself upright; sitting tall keeps the bar stacked over the hips.",
                 "The lower back rounding and the chest sinking as the pelvis rolls back.",
                 "Sit with the legs straight and apart, pull the chest up over the hips and hold that position for every rep."),
       "brace": ("Trunk Bracing",
                 "The torso stays still over the hips.",
                 "With nothing behind you, leaning back to get the bar past the face moves the load behind the hips; the abs have to hold the ribs down.",
                 "Leaning back from the hips to press the bar past the face.",
                 "Brace the abs, keep the ribs down and the torso upright as the bar goes up and comes down."),
       "barpath": BARPATH_FRONT, "grip": GRIP_BAR, "depth": DEPTH_FRONT,
   },
   activation=[("Anterior Deltoid", P, HI, 0.84), ("Lateral Deltoid", P, MOD, 0.66),
               ("Triceps Brachii", S, MOD, 0.52), ("Erector Spinae", S, LOW, 0.32)],
   stabilisers=["core", "hip flexors", "serratus anterior"],
   comparison=("ROUNDED LOWER BACK", "Sit tall over the hips", "Lower back rounds, chest sinks",
               "Sitting tall stacks the bar over the hips, so the shoulders press it straight up with the trunk still.",
               "A rounded lower back lets the chest sink and the bar drift forward, so the shoulders fight a longer lever."),
   glows=press_glows("Z Press", TRICEPS_R, rx=0.08))

SETUP["Z Press"] = [
    "Sit on the floor with your legs straight and apart.",
    "Set the rack's safeties just below chin height and sit under the bar.",
    "Grip the bar a hand's width outside your shoulders, wrists straight.",
    "Sit tall on your sit bones and brace your core.",
]

ex(name="Smith Machine Shoulder Press", var="smithMachineShoulderPress",
   # The left arm fills the right side from 0.15 to 0.48, so its elbow label
   # sits below it; the bench label is kept to 15 characters so its pill
   # (to x 0.318) clears the right forearm at mid-rep (u 0.34, v 0.35).
   overrides={"depth": (0.14, "leading"), "bench": (0.32, "leading"), "elbow": (0.50, "trailing"),
              "back": (0.68, "trailing"), "feet": (0.86, "leading")},
   annotations=[
       ("bench", "Bench under bar", "head"),
       ("back", "Back flat on the pad", "spine"),
       ("elbow", "Elbows under the bar", "forearm_L"),
       ("depth", "Lower to collarbones", "hand_R"),
       ("feet", "Feet flat, wide base", "foot_R"),
   ],
   cues={
       "bench": ("Bench Position",
                 "The bench sits so the bar runs down just in front of the face.",
                 "The Smith bar only moves straight up and down, so where the bench sits decides where the bar meets the body and how far forward the arms reach.",
                 "The bench set too far back, so the arms reach forward to the bar and the press turns into a steep incline press.",
                 "Set the bench just short of upright under the bar so it passes just in front of the nose and comes down to the collarbones."),
       "back": ("Back Support",
                "The pad takes the trunk out of the lift.",
                "With the back flat on the pad the deltoids and triceps move the bar; arching away from it turns the press into an incline press and loads the lower back.",
                "Arching the lower back off the pad to push more weight.",
                "Sit with the hips back and the back flat on the pad for the whole set."),
       "elbow": ("Elbow Position",
                 "The forearms stand straight up under the bar.",
                 "Elbows under the bar send the load straight up the forearms; elbows flared out and back behind it push the bar at an angle and turn the shoulders further out at the bottom.",
                 "Elbows flared out and back behind the bar at the bottom.",
                 "Keep the elbows under the bar, forearms close to vertical, all the way down and up."),
       "depth": DEPTH_SMITH, "feet": FEET_SEATED,
   },
   activation=[("Anterior Deltoid", P, HI, 0.82), ("Lateral Deltoid", P, MOD, 0.60),
               ("Triceps Brachii", S, MOD, 0.50), ("Upper Pectoralis", S, LOW, 0.28)],
   stabilisers=["rotator cuff", "serratus anterior"],
   comparison=("BACK OFF THE PAD", "Back flat on the pad", "Lower back arches off the pad",
               "With the back on the pad and the bar on its fixed track, the deltoids and triceps do the pressing.",
               "Arching off the pad leans the trunk back under the fixed bar, turning the lift into an incline press and loading the lower back."),
   glows=press_glows("Smith Machine Shoulder Press", TRICEPS_L, TRICEPS_R))

SETUP["Smith Machine Shoulder Press"] = [
    "Set a bench under the Smith bar with the back pad just short of upright.",
    "Place it so the bar runs just in front of your face.",
    "Sit with your back on the pad and your feet flat and wide.",
    "Grip the bar just outside your shoulders, then unhook it.",
]

# ---------------------------------------------------------------- standing barbell presses

ex(name="Behind-the-Neck Press", var="behindTheNeckPress",
   # Both hands above the head at the top: the two hand cues share the top
   # row, one each side, and the right arm keeps the left of row 0.32 busy.
   overrides={"lockout": (0.14, "leading"), "depth": (0.14, "trailing"), "grip": (0.32, "trailing"),
              "head": (0.50, "leading"), "brace": (0.68, "trailing")},
   annotations=[
       ("grip", "Forearms vertical", "forearm_L"),
       ("depth", "Bar to base of skull", "hand_L"),
       ("head", "Chest up, head level", "head"),
       ("brace", "Ribs down, glutes tight", "spine"),
       ("lockout", "Lock out over the neck", "hand_R"),
   ],
   cues={
       "grip": ("Grip & Forearms",
                "Hands wide enough to keep the forearms vertical.",
                "A grip that stands the forearms straight up at the bottom lets the bar pass behind the head without the shoulders turning back further than they need to.",
                "A narrow grip, which folds the elbows and makes the shoulders rotate further to get the bar behind the head.",
                "Grip overhand about a hand's width outside the shoulders, so the forearms stand straight up under the bar at the bottom."),
       "depth": ("Range of Motion",
                 "The bar comes down behind the head to about the base of the skull.",
                 "Behind the head the shoulders turn out near the end of their range, and in one study male lifters went past their passive outward rotation; lowering only as far as the chest stays up and the forearms stay vertical keeps that rotation within your own range.",
                 "Forcing the bar further down the back of the neck than the shoulders comfortably allow.",
                 "Lower under control to about the base of the skull, or only as far as your shoulders comfortably allow, then press straight back up."),
       "head": ("Head & Upper Back",
                "The chest stays up while the bar passes behind the head.",
                "An upright upper back gives the shoulders their full overhead range; slouching tilts the shoulder blades forward and costs overhead range, so getting the bar behind the head asks more of the shoulder joint.",
                "Rounding the upper back and pushing the head forward and down to let the bar pass.",
                "Keep the chest up and the head level, eyes forward, the head just slightly forward so the bar can pass behind it."),
       "brace": BRACE_STAND,
       "lockout": ("Lockout",
                   "The bar finishes straight above the back of the neck.",
                   "Locking out with the bar over the neck stacks it over the shoulders, hips and heels, so the arms hold it without the lower back compensating.",
                   "Pressing the bar forward so it locks out in front of the face.",
                   "Press straight up until the elbows are fully straight, the bar just behind the ears and over the heels."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.80), ("Lateral Deltoid", P, HI, 0.76),
               ("Triceps Brachii", S, MOD, 0.54), ("Posterior Deltoid", S, LOW, 0.38)],
   stabilisers=["rotator cuff", "serratus anterior", "core"],
   comparison=("FORCED DEPTH", "Lower within your range", "Bar forced down the neck",
               "Lowering only as far as the chest stays up and the forearms stay vertical keeps the shoulders inside the rotation they control while the deltoids press.",
               "Forcing the bar lower than the shoulders allow turns them further out at the bottom; behind-the-neck pressing has been associated with signs of anterior shoulder instability in weight trainers."),
   glows=press_glows("Behind-the-Neck Press", TRICEPS_L, TRICEPS_R))

SETUP["Behind-the-Neck Press"] = [
    "Set the bar in a rack at shoulder height.",
    "Grip it overhand, a hand's width outside your shoulders.",
    "Duck under, take it behind your neck on your upper traps and step back.",
    "Stand with your feet hip-width, glutes tight and core braced.",
]

ex(name="Push Press", var="pushPress",
   # The hand cues share the top row; the dip cue points at the near (right)
   # knee so its leader does not cross the other leg.
   overrides={"rack": (0.14, "trailing"), "lockout": (0.14, "leading"), "dip": (0.68, "leading"),
              "brace": (0.68, "trailing"), "heels": (0.86, "trailing")},
   annotations=[
       ("rack", "Arms still in the dip", "hand_L"),
       ("lockout", "Lock out over the head", "hand_R"),
       ("brace", "Ribs down, glutes tight", "spine"),
       ("dip", "Dip straight down", "patella_R"),
       ("heels", "Heels down in the dip", "foot_L"),
   ],
   cues={
       "rack": ("Start Position",
                "The bar starts in front of the chin and the arms stay still through the dip.",
                "Holding the arms still until the legs have driven lets the legs launch the bar, so the arms only finish the press; pressing early wastes the leg drive. Most lifters start with the bar resting on the front of the shoulders; the same rule applies.",
                "Starting to press with the arms during the dip, so the bar rises before the legs drive.",
                "Hold the bar in front of the chin, wrists straight and forearms under it, and keep the arms still until the legs have driven."),
       "lockout": ("Lockout",
                   "The bar finishes straight overhead.",
                   "Locking out with the bar over the head and mid-foot stacks the load over the base, so the arms hold it without the lower back compensating.",
                   "Driving the bar forward so it locks out in front of the face.",
                   "Drive the bar straight up close to the face and finish at arms' length, the bar over the head and the arms beside the ears."),
       "brace": ("Trunk Bracing",
                 "The trunk carries the leg drive into the bar.",
                 "A braced, upright trunk passes the force of the legs into the bar; a soft or arched one leaks it and loads the lower back.",
                 "Leaning back and arching the lower back as the bar goes overhead.",
                 "Brace the abs and squeeze the glutes before the dip, and keep the ribs down over the pelvis as the bar goes up."),
       "dip": ("Dip",
               "A short dip straight down, torso upright.",
               "A quick dip of a few inches loads the legs to drive; keeping it vertical is what sends that drive up through the bar instead of out in front of it.",
               "The chest tipping forward in the dip instead of the body sinking straight down.",
               "Bend the knees straight down a few inches, torso upright and hips under the shoulders, then drive up without pausing."),
       "heels": ("Foot Pressure",
                 "The heels stay down through the dip.",
                 "Flat feet let the legs push straight up through the bar; rising onto the toes in the dip tips the body forward before the drive.",
                 "Rocking onto the toes as the knees bend, the heels lifting off the floor.",
                 "Keep the whole foot on the floor and the heels down through the dip; if they rise at all, it is only as the legs finish the drive."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.80), ("Triceps Brachii", S, MOD, 0.58),
               ("Lateral Deltoid", S, MOD, 0.56), ("Quadriceps", S, MOD, 0.44)],
   stabilisers=["core", "glutes", "rotator cuff", "serratus anterior"],
   comparison=("CHEST DROPS IN THE DIP", "Dip straight down", "Chest tips forward",
               "A short, upright dip drives the legs straight up through the bar, so it rises fast and in line.",
               "Tipping forward in the dip sends the drive out in front, so the bar drifts forward and the arms have to chase it."),
   glows=press_glows("Push Press", TRICEPS_L, ["thigh_L", "patella_L", "thigh_R", "patella_R"]))

SETUP["Push Press"] = [
    "Hold the bar in front of your chin, hands a hand's width outside your shoulders.",
    "Stand with your feet hip-width, knees soft, weight over mid-foot.",
    "Wrists straight, forearms under the bar.",
    "Brace your core and squeeze your glutes.",
]

# ---------------------------------------------------------------- landmine presses

ex(name="Landmine Shoulder Press", var="landmineShoulderPress",
   # The bar sweeps the upper left and the left shoulder sits at 0.60, 0.30:
   # short elbow label right of the shoulder, trunk label left of the hips.
   # The stance label sits on row 0.68, clear of the right knee (0.40, 0.67)
   # and of the front shoe on row 0.86, its leader running down to the ankle.
   overrides={"path": (0.14, "trailing"), "elbow": (0.32, "trailing"), "twist": (0.32, "leading"),
              "core": (0.50, "leading"), "stance": (0.68, "leading")},
   annotations=[
       ("elbow", "Elbow tucked in", "forearm_L"),
       ("path", "Press up and forward", "hand_L"),
       ("core", "Ribs down, no lean back", "spine"),
       ("twist", "Shoulders stay square", "upper_arm_R"),
       ("stance", "Staggered stance", "foot_R"),
   ],
   cues={
       "elbow": LM_ELBOW, "path": LM_PATH, "core": LM_CORE, "twist": LM_TWIST,
       "stance": ("Stance",
                  "A split stance, the foot opposite the pressing arm forward.",
                  "With one foot ahead of the other, the split stance gives a long base front to back, so the body can press forward into the bar without rocking.",
                  "Letting the feet drift together out of the split, so the body rocks back with every press.",
                  "Step the foot opposite the pressing arm a stride forward, back knee soft and heel slightly up, weight through both feet."),
   },
   activation=LM_ACT,
   stabilisers=["serratus anterior", "rotator cuff", "glutes"],
   comparison=("LEANING BACK", "Tall and braced", "Leaning back to press",
               "Standing tall keeps the press on the landmine's up-and-forward arc, where the front deltoid drives it.",
               "Leaning back tips the press toward a flatter, chest-led push off an arched lower back and cuts the shoulder's share."),
   glows=one_arm_glows("Landmine Shoulder Press"))

SETUP["Landmine Shoulder Press"] = [
    "Wedge one end of a bar in a landmine and load the other end.",
    "Stand at the loaded end facing the landmine, the foot opposite your pressing arm forward.",
    "Hold the end of the bar at the front of your shoulder in one hand.",
    "Rest your free hand on your hip and brace your core.",
]

ex(name="Half-Kneeling Landmine Press", var="halfKneelingLandminePress",
   # As the standing press; the down knee's label goes bottom right, clear of
   # the front shin on the left.
   overrides={"path": (0.14, "trailing"), "elbow": (0.32, "trailing"), "twist": (0.32, "leading"),
              "core": (0.50, "leading"), "stance": (0.86, "trailing")},
   annotations=[
       ("elbow", "Elbow tucked in", "forearm_L"),
       ("path", "Press up and forward", "hand_L"),
       ("core", "Ribs down, no lean back", "spine"),
       ("twist", "Shoulders stay square", "upper_arm_R"),
       ("stance", "Down knee under the hip", "patella_L"),
   ],
   cues={
       "elbow": LM_ELBOW, "path": LM_PATH, "core": LM_CORE, "twist": LM_TWIST,
       "stance": ("Half-Kneeling Base",
                  "Knee down on the pressing side, the other foot flat ahead.",
                  "Kneeling tall with the hip straight and the glute squeezed locks the pelvis, so the trunk, not the legs, holds the press steady.",
                  "Sitting the hips back toward the back heel, so the body bends at the hip.",
                  "Kneel with the down knee under the hip and the front shin vertical, squeeze the glute of the down leg and stay tall."),
   },
   activation=LM_ACT,
   stabilisers=["glutes", "serratus anterior", "rotator cuff"],
   comparison=("LEANING BACK", "Tall kneel, ribs down", "Leaning back to press",
               "Kneeling tall with the glute squeezed keeps the press on its up-and-forward arc while the trunk holds still.",
               "Leaning back arches the lower back over the kneeling hip and tips the press toward a flatter, chest-led push."),
   glows=one_arm_glows("Half-Kneeling Landmine Press"))

SETUP["Half-Kneeling Landmine Press"] = [
    "Wedge one end of a bar in a landmine and load the other end.",
    "Kneel at the loaded end facing the landmine, pressing-side knee down, other foot flat ahead.",
    "Hold the end of the bar at the front of your shoulder in one hand.",
    "Rest your free hand on your hip and squeeze the glute of the down leg.",
]

ex(name="Viking Press", var="vikingPress",
   # Both forearms cross row 0.32 and the hips sit at 0.50 on the right: hand
   # cues on the top row, a short elbow label right of the hips, the leg cue
   # on the near (right) knee.
   overrides={"grip": (0.14, "trailing"), "path": (0.14, "leading"), "elbow": (0.50, "trailing"),
              "core": (0.50, "leading"), "feet": (0.68, "leading")},
   annotations=[
       ("grip", "Palms in, wrists neutral", "hand_L"),
       ("elbow", "Elbows tucked", "forearm_L"),
       ("path", "Press to full reach", "hand_R"),
       ("core", "Ribs down, no lean back", "spine"),
       ("feet", "Legs straight, no dip", "patella_R"),
   ],
   cues={
       "grip": ("Grip",
                "Palms face each other on the handles.",
                "Neutral handles let the elbows start tucked in under them, so the arms drive along the bar's arc.",
                "The wrists bending back under the handles, the backs of the hands tipping out.",
                "Hold both handles deep in the palms, wrists straight."),
       "elbow": ("Elbow Position",
                 "The elbows start tucked in at the sides, under the handles.",
                 "Forearms stacked under the handles push straight along the arc; elbows flared wide at the bottom push the handles sideways, off that line.",
                 "Elbows flaring out to the sides at the bottom of the press.",
                 "Start with the handles at the front of the shoulders, elbows down and tucked in at the sides, then drive them up and forward as you press."),
       "path": ("Finish",
                "Every rep finishes at full reach, up and forward.",
                "The top of the arc is where the triceps finish the press; stopping short leaves part of every rep undone.",
                "Stopping with the elbows still well bent and the handles short of the top.",
                "Press up and forward until the arms reach full length, the handles up in front of the head, then lower to the front of the shoulders."),
       "core": ("Trunk Position",
                "The body stays tall under the handles.",
                "Keeping the ribs down makes the shoulders move the load; leaning back tips the press toward a flatter, chest-led push off an arched lower back.",
                "Leaning back and arching the lower back to push the handles up.",
                "Brace the core, squeeze the glutes and keep the ribs stacked over the hips as you press."),
       "feet": ("Base",
                "A strict press gets no help from the legs.",
                "Straight legs and a hip-width stance keep the work on the shoulders and triceps; dipping the knees turns it into a push press.",
                "Dipping the knees to drive the handles up.",
                "Stand with the feet about hip-width, facing the landmine, knees straight and weight over mid-foot."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.82), ("Triceps Brachii", S, MOD, 0.56),
               ("Upper Pectoralis", S, MOD, 0.44), ("Lateral Deltoid", S, LOW, 0.36)],
   stabilisers=["core", "serratus anterior", "rotator cuff"],
   comparison=("LEANING BACK", "Tall, ribs down", "Leaning back to press",
               "Standing tall keeps the handles on their arc, so the shoulders and triceps do the pressing.",
               "Leaning back hands part of the press to the lower back and chest, tipping it toward a flatter push."),
   glows=press_glows("Viking Press", TRICEPS_R, rx=0.10))

SETUP["Viking Press"] = [
    "Fit a Viking press handle to a landmine bar and load it.",
    "Stand facing the landmine, feet hip-width, knees straight.",
    "Hold both handles at the front of your shoulders, palms facing each other.",
    "Brace your core and squeeze your glutes.",
]

if __name__ == "__main__":
    probs = validate(["Seated Barbell Overhead Press", "Behind-the-Neck Press", "Push Press", "Z Press", "Smith Machine Shoulder Press", "Landmine Shoulder Press", "Half-Kneeling Landmine Press", "Viking Press"]); print("\n".join(probs) or "OK")
