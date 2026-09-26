# Trainer content for batch 191-240 (2026-09-26), family: dumbbell and cable
# presses (exports 194-198, 202, 203 from SourceExports/190-240). Same format
# as spec.py; spec_191_240.py collects the families and gen.py writes them.
#
# What each model shows, from the rig (joint angles sampled across the clip,
# side and front renders of the converted usdc):
# - The six standing and seated pronated presses share one arm motion: palms
#   forward, the dumbbells (or handles) start just above the shoulders (wrist
#   ~5 cm above the shoulder joint, 17 cm ahead of it; the handle ~13 cm
#   above it, about chin height) with the elbows ~19 cm below the shoulders,
#   20 cm out and 9 cm forward, forearms near vertical;
#   the upper arms travel ~25-40° in front of the frontal plane (the scapular
#   plane), up and slightly in, to a soft lockout (elbow ~162°, upper arm
#   ~167° from hanging) with the hands 0.47 m apart over the shoulders (they
#   start 0.71 m apart). Two reps in the 8 s clip. Trunk vertical throughout.
# - Dumbbell Push Press: standing, feet 0.34 m apart, knees soft (157°). Each
#   rep dips ~8 cm (knees to ~122°, trunk vertical, heels down) with the
#   dumbbells held at the shoulders, then the knees extend as the arms press;
#   the dumbbells are lowered with the knees straight.
# - Standing Dumbbell Press: the same stance with the knees still at 157° for
#   the whole clip: a strict press.
# - Seated Dumbbell Press: a flat seat with a short upright back pad (top
#   1.10 m, level with the upper shoulder blades, 5.5 cm below the shoulder
#   joints). The lifter sits upright in the middle of the seat, hips ~13 cm
#   and upper back ~15 cm clear of the pad, feet flat and wide (0.42 m),
#   knees ~121°, the feet a little ahead of the knees. Unlike the older
#   Dumbbell Shoulder Press, the back is not held by a tall pad.
# - Neutral-Grip Dumbbell Shoulder Press: an adjustable bench with the back
#   one notch off upright (trunk reclined ~9°), back on the pad, feet flat.
#   Palms face each other; the dumbbells start at the front of the shoulders
#   with the elbows low (upper arm ~16° from hanging) beside the ribs, ~6 cm
#   in front of the shoulder joints, rise with the elbows travelling forward
#   (24 cm ahead of the shoulders early in the press), and finish overhead
#   close together (hands 0.31 m apart, plates ~10 cm apart), elbows ~168-173°.
# - Single-Arm Dumbbell Shoulder Press: the standing press with only the LEFT
#   arm; the right arm hangs straight by the side. No trunk lean or side bend.
# - Cable Shoulder Press: standing centred between two towers with the pulleys
#   at the floor, ~0.45 m behind the heels and 0.66 m out to each side, so the
#   cables run down and back from the handles. Arm motion as above.
# - Single-Arm Cable Shoulder Press: one tower on the lifter's left; the LEFT
#   arm presses, the right hangs by the side.
# Every framing has yaw -0.5 (neutral grip -0.6) and faces the lifter, so the
# LEFT arm is on the right of the frame.
#
# Sources:
# - Saeterbakken AH, Fimland MS 2013, J Strength Cond Res 27(7):1824-1831,
#   doi:10.1519/JSC.0b013e318276b873 — seated/standing, barbell/dumbbell
#   shoulder press: standing dumbbells gave the highest deltoid activity and
#   the lowest 1-RM; seated dumbbells ~15% less medial and ~24% less posterior
#   deltoid than standing (anterior ~8% less, a trend); 1-RM ~10% lower
#   standing than seated with dumbbells.
# - Saeterbakken AH, Fimland MS 2012, Eur J Appl Physiol 112(5):1671-1678,
#   doi:10.1007/s00421-011-2141-7 — core EMG in seated/standing, bilateral/
#   unilateral dumbbell shoulder presses: rectus abdominis ~81% lower seated
#   than standing (bilateral); external oblique ~68% and erector spinae ~18%
#   lower bilateral than unilateral (standing).
# - Campos YAC et al. 2020, J Hum Kinet 75:5-14, doi:10.2478/hukin-2020-0033 —
#   seated barbell shoulder press at 60% 1-RM: anterior 33.3%, medial 27.9%,
#   posterior 11.4% MVIC; the press led the four exercises for the anterior
#   deltoid. The medial deltoid at ~84% of the anterior is why the lateral
#   deltoid is marked primary here, although StrengthLog and ExRx list it as
#   secondary (as in the older Dumbbell Shoulder Press).
# - Paoli A, Marcolin G, Petrone N 2010, J Strength Cond Res 24(6):1578-1583,
#   doi:10.1519/JSC.0b013e3181d756ea — sitting military press: the widest range
#   (to full elbow extension) raised EMG in every muscle measured (deltoids,
#   upper trapezius, triceps, clavicular pectoralis) at every load, except the
#   middle trapezius, teres minor and posterior deltoid with no load.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2022, Front Physiol
#   13:825880, doi:10.3389/fphys.2022.825880 — front vs back overhead press
#   (EMG as % MVIC): with the barbell, the back press gave more medial and
#   posterior deltoid (and more anterior deltoid while lowering), the front
#   press more clavicular pectoralis (and triceps while lowering); the front
#   machine press used a neutral grip and, against the back machine press,
#   gave far more clavicular pectoralis and less medial and posterior deltoid
#   (and less anterior deltoid while lowering), which the authors put down to
#   the arm rising by combined abduction and flexion. The closest evidence for
#   the elbows-forward neutral-grip press; no study compares neutral and
#   pronated grips in a free-weight shoulder press.
# - Luczak J, Bosak A, Riemann BL 2013, J Sports Med 2013:612650,
#   doi:10.1155/2013/612650 — women, 4.5 kg dumbbells, EMG normalised to the
#   flat press: the 85° shoulder press gave more anterior deltoid and upper
#   trapezius than the incline and flat presses; the sternal pectoralis was
#   low (about a third of the flat-press concentric level) but the clavicular
#   head still reached about 70% of it.
# - Kohler JM, Flanagan SP, Whiting WC 2010, J Strength Cond Res
#   24(2):313-321, doi:10.1519/JSC.0b013e3181c8655a — seated shoulder press:
#   the more unstable the load, the lighter it had to be; triceps activity
#   highest with the barbell on a bench, lowest with dumbbells on a Swiss
#   ball.
# - Durall CJ, Manske RC, Davies GJ 2001, Strength Cond J 23(5):10-18 — a
#   clinical commentary, not an experimental study: abduction with external
#   rotation and horizontal abduction stresses the front of the shoulder
#   capsule, above all in lifters with anterior laxity or instability;
#   presses usually done behind the neck should keep the elbows ~30° forward
#   in the scapular plane, and shoulder presses are best done with the hands
#   and elbows in front of the shoulders, with a bar, dumbbells or a machine.
# - Lake JP, Mundy PD, Comfort P 2014, J Strength Cond Res 28(9):2552-2559,
#   doi:10.1519/JSC.0000000000000438 — push press power and impulse are
#   comparable with the jump squat: a lower-body power lift with upper-body and
#   trunk strength work.
# - Santana JC, Vera-Garcia FJ, McGill SM 2007, J Strength Cond Res
#   21(4):1271-1277, doi:10.1519/R-20476.1 — standing one-arm cable chest
#   press (a horizontal push, not overhead): whole-body stability limited the
#   load, and the internal oblique and latissimus dorsi opposite the pressing
#   arm were as active as the anterior deltoid and pectoralis major (the
#   closest evidence for the single-arm cable press).
# - NSCA Kinetic Select, Push Jerk (the same dip and drive as the push press;
#   https://www.nsca.com/education/articles/kinetic-select/push-jerk/): the
#   dip is no deeper than a quarter squat (or about 10% of body height), torso
#   erect, the hips staying directly under the shoulders rather than moving
#   back, the weight balanced over the middle of the feet. CrossFit
#   Essentials, The Push Press: trunk vertical in the dip, heels down until
#   the legs and hips have extended, then press to directly overhead.
# - ACE Exercise Library, Seated Overhead Press: pronated grip, dumbbells at
#   shoulder level, neutral wrists, press to full elbow extension without
#   arching the low back (ACE sits with the back on a back rest; the seated
#   model sits clear of its short pad). ExRx.net Dumbbell Shoulder Press
#   (elbows below the wrists, lower to the sides of the shoulders), Dumbbell
#   One Arm Shoulder Press (the trunk may lean away for balance or stay
#   upright; the model stays upright) and Cable Isolateral Standing Shoulder
#   Press (formerly Cable Standing Shoulder Press;
#   https://exrx.net/WeightExercises/DeltoidAnterior/CBStandingShoulderPress:
#   stand between two low to medium height pulleys).
# - StrengthLog exercise guides: Dumbbell Shoulder Press and Seated Dumbbell
#   Shoulder Press (front deltoid primary; triceps and lateral deltoid
#   secondary; one arm and standing raise oblique activation), Push Press
#   (front deltoid primary; quads, glutes, adductors, lower back, trapezius,
#   triceps and lateral deltoid secondary).
# No cable shoulder press EMG study was found: the cable rows mirror the
# standing (and single-arm) dumbbell press, and the cable-specific copy is
# reasoned from the model's line of pull (see the notes).

from common_191_240 import *


def two_arm_glows(name, legs=False):
    """Both front delts, then the near triceps and either the far triceps or
    the quads for the push press's drive."""
    third = (glow(name, ["thigh_L", "patella_L", "thigh_R", "patella_R"], SOFT, 0.28, rx=0.12, ry=0.07) if legs
             else glow(name, ["upper_arm_R", "forearm_R"], SOFT, 0.28, rx=0.06, ry=0.07))
    return [glow(name, ["deltoid_arc_clavicle_2_L", "deltoid_arc_clavicle_2_R"], A, 0.55, rx=0.15, ry=0.06),
            glow(name, ["upper_arm_L", "forearm_L"], SOFT, 0.30, rx=0.06, ry=0.07),
            third]


def one_arm_glows(name):
    """The working (left) front delt and triceps, then the trunk that stops
    the side bend."""
    return [glow(name, ["deltoid_arc_clavicle_2_L"], A, 0.55, rx=0.08, ry=0.06),
            glow(name, ["upper_arm_L", "forearm_L"], SOFT, 0.30, rx=0.06, ry=0.07),
            glow(name, ["spine", "pelvis"], SOFT, 0.28, rx=0.10, ry=0.06)]


# ---------------------------------------------------------------- shared cues

ELBOW_DB = ("Elbow Position",
            "The elbows sit under the dumbbells and a little in front of the body.",
            "Pressing with the upper arms about 30° forward of the sides keeps the shoulder in the scapular plane, away from the turned-out, pulled-back position that stresses the front of the joint.",
            "Elbows flared straight out to the sides and pulled back behind the shoulders at the bottom.",
            "Keep the forearms vertical under the dumbbells and the elbows slightly forward, from the bottom to lockout.")
PATH_DB = ("Press Path",
           "The dumbbells travel up and slightly in.",
           "Finishing with the dumbbells over the shoulders keeps the load over the joints the deltoids are moving, so the arms can straighten without the weight pulling them apart.",
           "Letting the dumbbells drift wide at the top, or clanging them together overhead.",
           "Press up and slightly in until the arms are straight and the dumbbells sit over the shoulders, just short of touching.")
DEPTH_DB = ("Range of Motion",
            "Each rep starts with the dumbbells just above the shoulders, about chin height.",
            "Lowering until the dumbbells are just above the shoulders uses the press's full range; turning round higher leaves the bottom of it untrained.",
            "Short reps that turn round with the dumbbells at forehead height.",
            "Lower under control until the dumbbells are just above the shoulders, about chin height, elbows below the wrists, then press.")
WRIST_PRESS = ("Wrist Position",
               "Each wrist stays straight under its load.",
               "A straight wrist sends the weight down the middle of the forearm, so the press is not limited by a joint bent back under it.",
               "Wrists bending back so the weight tips behind the forearms.",
               "Hold the handle low in the palm, knuckles up, and keep the wrist straight as you press.")
BRACE_STAND = ("Trunk Bracing",
               "Standing, the trunk is the base the press pushes from.",
               "Standing makes the abs work far harder than sitting; braced abs and tight glutes keep the ribs over the pelvis, so the shoulders press straight up instead of the lower back arching into an incline press.",
               "Leaning back from the hips with the lower back arched to get the weight up.",
               "Brace the abs, squeeze the glutes and keep the ribs stacked over the pelvis on every rep.")
STANCE_STRICT = ("Base",
                 "A strict press gets no help from the legs.",
                 "Hip-width feet and soft, still knees give a steady base and keep the work on the shoulders and triceps.",
                 "Dipping the knees and driving with the legs, which turns the lift into a push press.",
                 "Stand with the feet about hip-width, knees soft but still, weight over the middle of the feet for the whole set.")


def lockout(one_arm=False):
    arms, elbows, load = ("arm", "elbow", "dumbbell") if one_arm else ("arms", "elbows", "dumbbells")
    return ("Lockout",
            f"Every rep finishes with the {arms} straight overhead.",
            "Pressing all the way to straight elbows works the deltoids, triceps and upper traps harder than stopping partway.",
            f"Stopping with the {elbows} still clearly bent, the {load} a few inches short of the top.",
            f"Press until the {elbows} are straight, without snapping them, then lower under control to the shoulders.")


def elbow_one(load):
    return ("Elbow Position",
            f"The working elbow sits under the {load} and a little in front of the body.",
            "Pressing with the upper arm about 30° forward of the side keeps the shoulder in the scapular plane, away from the turned-out, pulled-back position that stresses the front of the joint.",
            "The elbow flaring out to the side and back behind the shoulder at the bottom.",
            f"Keep the forearm vertical under the {load} and the elbow slightly forward, from the bottom to lockout.")


def core_one(load):
    return ("Anti-Lean",
            f"With the {load} on one side, the trunk has to stay upright on its own.",
            "Pressing with one arm makes the obliques work much harder than pressing with two, because they stop the trunk bending to the side; a big lean away lets the trunk tilt the weight up instead of the shoulder pressing it.",
            "Leaning well away from the working arm so the trunk, not the shoulder, lifts the weight.",
            "Brace, keep the shoulders and hips level, and press straight up beside the head.")


# ---------------------------------------------------------------- dumbbell push press

n = "Dumbbell Push Press"
ex(name=n, var="dumbbellPushPress",
   overrides={"lockout": (0.14, "leading"), "elbow": (0.32, "trailing"), "dip": (0.50, "leading"),
              "depth": (0.68, "trailing"), "heels": (0.86, "leading")},
   annotations=[
       ("dip", "Dip straight down", "spine"),
       ("depth", "Quarter-squat dip", "patella_L"),
       ("heels", "Heels down in the dip", "foot_R"),
       ("elbow", "Elbows under dumbbells", "forearm_L"),
       ("lockout", "Lock out over shoulders", "hand_R"),
   ],
   cues={
       "dip": ("Dip",
               "The dip is a short, straight drop of the hips and knees.",
               "A vertical trunk lets the legs drive straight up through it into the dumbbells; a chest that tips forward sends the drive forward, away from the shoulders.",
               "The chest tipping forward as the knees bend.",
               "Keep the trunk upright, the hips under the shoulders and the weight over mid-foot, and bend the knees and hips a few inches."),
       "depth": ("Dip Depth",
                 "The dip goes no deeper than a quarter squat.",
                 "The legs drive the push press much as they drive a jump: a short dip reversed at once keeps that drive quick, while sinking lower slows the turnaround and lets the trunk fold.",
                 "Sinking into a half squat before driving up.",
                 "Dip a few inches with the knees over the toes, then reverse straight into the drive without a pause."),
       "heels": ("Foot Pressure",
                 "The heels stay down through the dip and the start of the drive.",
                 "Pushing through flat feet lets the hips and knees straighten directly under the dumbbells.",
                 "Rocking forward onto the toes as the knees bend.",
                 "Keep the heels down and the weight over mid-foot in the dip, then drive the floor away until the legs are straight."),
       "elbow": ("Rack Position",
                 "The dumbbells wait at the shoulders while the legs dip.",
                 "With the elbows under the dumbbells, the drive from the legs goes straight up into them instead of tipping them forward.",
                 "Elbows dropping back behind the dumbbells, so the drive pushes them out in front.",
                 "Hold the dumbbells just above the shoulders, palms forward, forearms vertical and elbows slightly in front of the body."),
       "lockout": ("Lockout",
                   "The dumbbells finish over the shoulders, arms straight.",
                   "Stacking the dumbbells over the shoulders and hips lets the straight arms hold the weight at the top instead of the front of the shoulders.",
                   "Finishing with the dumbbells in front of the face, arms angled forward.",
                   "Press through to straight arms with the biceps beside the ears, then lower the dumbbells back to the shoulders under control."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.80), ("Lateral Deltoid", S, MOD, 0.60),
               ("Triceps Brachii", S, MOD, 0.55), ("Quadriceps", S, MOD, 0.45)],
   stabilisers=["glutes", "core", "upper trapezius", "rotator cuff"],
   comparison=("CHEST DROPS IN THE DIP", "Upright dip, straight drive", "Chest tips forward in the dip",
               "Dipping with the trunk vertical sends the leg drive straight up through the body into the dumbbells.",
               "Tipping forward in the dip sends the drive forward, so the dumbbells travel out in front and the shoulders have to save them."),
   glows=two_arm_glows(n, legs=True))
SETUP[n] = [
    "Stand with your feet hip-width, a dumbbell in each hand.",
    "Hold the dumbbells just above your shoulders, palms forward.",
    "Elbows under your wrists, slightly in front of your body.",
    "Brace your core, weight over mid-foot.",
]

# ---------------------------------------------------------------- standing dumbbell press

n = "Standing Dumbbell Press"
ex(name=n, var="standingDumbbellPress",
   overrides={"lockout": (0.14, "trailing"), "wrist": (0.14, "leading"), "elbow": (0.32, "trailing"),
              "brace": (0.50, "leading"), "stance": (0.68, "leading")},
   annotations=[
       ("elbow", "Elbows slightly forward", "forearm_L"),
       ("lockout", "Press to straight arms", "hand_L"),
       ("brace", "Ribs down, glutes tight", "spine"),
       ("wrist", "Wrists straight", "hand_R"),
       ("stance", "Knees soft, no dip", "patella_R"),
   ],
   cues={"elbow": ELBOW_DB, "lockout": lockout(), "brace": BRACE_STAND, "wrist": WRIST_PRESS, "stance": STANCE_STRICT},
   activation=[("Anterior Deltoid", P, HI, 0.88), ("Lateral Deltoid", P, HI, 0.76),
               ("Triceps Brachii", S, MOD, 0.52), ("Rectus Abdominis", S, LOW, 0.30)],
   stabilisers=["rotator cuff", "serratus anterior", "upper trapezius", "glutes"],
   comparison=("LEANING BACK", "Ribs down, glutes tight", "Lower back arches to press",
               "Keeping the ribs over the pelvis holds the trunk vertical, so the deltoids and triceps press the dumbbells straight up.",
               "Leaning back turns the press into a steep incline press and loads the lower back in extension."),
   glows=two_arm_glows(n))
SETUP[n] = [
    "Stand with your feet hip-width and your knees soft.",
    "Hold the dumbbells just above your shoulders, palms forward.",
    "Elbows under your wrists, slightly in front of your body.",
    "Squeeze your glutes and brace your core.",
]

# ---------------------------------------------------------------- seated dumbbell press (low-backed seat)

n = "Seated Dumbbell Press"
ex(name=n, var="seatedDumbbellPress",
   overrides={"path": (0.14, "trailing"), "depth": (0.14, "leading"), "elbow": (0.50, "trailing"),
              "torso": (0.50, "leading"), "feet": (0.86, "trailing")},
   annotations=[
       ("elbow", "Elbows slightly forward", "forearm_L"),
       ("path", "Press up and slightly in", "hand_L"),
       ("depth", "Lower to the shoulders", "hand_R"),
       ("torso", "Sit tall, trunk upright", "spine"),
       ("feet", "Feet flat and wide", "foot_L"),
   ],
   cues={
       "elbow": ELBOW_DB, "path": PATH_DB, "depth": DEPTH_DB,
       "torso": ("Torso Position",
                 "The short back pad stops at the shoulder blades, and the lifter sits tall in front of it without leaning on it.",
                 "An upright trunk keeps the press vertical over the shoulders; leaning back tilts it toward an incline press and loads the lower back.",
                 "Leaning back toward the pad with the lower back arched.",
                 "Sit tall in the middle of the seat with the ribs down, and keep the trunk upright over the hips for every rep."),
       "feet": ("Foot Position",
                "The feet anchor the seated body.",
                "Flat feet set wide give a stable base, so balancing two dumbbells does not pull the hips around.",
                "Feet tucked under the seat or up on the toes, so the hips shift with every rep.",
                "Plant both feet flat, wider than the hips and a little in front of the knees, and keep them still."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.84), ("Lateral Deltoid", P, MOD, 0.66),
               ("Triceps Brachii", S, MOD, 0.50), ("Upper Trapezius", S, LOW, 0.36)],
   stabilisers=["rotator cuff", "serratus anterior", "core"],
   comparison=("LEANING BACK", "Trunk upright over the hips", "Leaning back toward the pad",
               "An upright trunk keeps the press vertical, the deltoids moving the dumbbells straight up over the shoulders.",
               "Leaning back from the hips arches the lower back and turns the lift into an incline press; clear of the pad, only the braced trunk keeps the lifter upright."),
   glows=two_arm_glows(n))
SETUP[n] = [
    "Sit tall in the middle of a low-backed seat.",
    "Plant your feet flat and wider than your hips.",
    "Kick the dumbbells up to shoulder height, palms forward.",
    "Elbows under your wrists, ribs down.",
]

# ---------------------------------------------------------------- neutral-grip dumbbell shoulder press

n = "Neutral-Grip Dumbbell Shoulder Press"
ex(name=n, var="neutralGripDumbbellShoulderPress",
   overrides={"grip": (0.14, "trailing"), "lockout": (0.14, "leading"), "elbow": (0.68, "trailing"),
              "back": (0.50, "leading"), "feet": (0.86, "leading")},
   annotations=[
       ("grip", "Palms in, wrists firm", "hand_L"),
       ("elbow", "Elbows forward, not out", "forearm_L"),
       ("lockout", "Lock out by the ears", "hand_R"),
       ("back", "Back on the pad", "spine"),
       ("feet", "Feet flat on the floor", "foot_L"),
   ],
   cues={
       "grip": ("Grip and Wrists",
                "The palms face each other for the whole rep.",
                "A straight wrist stacks each dumbbell over its forearm, so the weight goes straight down the arm.",
                "Wrists bending back so the dumbbells tip out past the forearms.",
                "Hold each handle in the middle, palms in, knuckles up and wrists straight."),
       "elbow": ("Elbow Path",
                 "The elbows start low by the sides, a little forward, and rise forward, not out to the sides.",
                 "With the palms in, the upper arms rise in front of the body, which keeps the shoulder out of the turned-out, pulled-back position that stresses its front; pressing in front of the head also works the upper chest more and the side deltoid less than pressing behind it.",
                 "Flaring the elbows out to the sides as the dumbbells rise.",
                 "Keep the elbows under the dumbbells and a little in front of the shoulders from the bottom to lockout."),
       "lockout": ("Lockout",
                   "The dumbbells finish overhead, close together.",
                   "Pressing all the way to straight arms beside the ears finishes the range where the deltoids and triceps complete the press.",
                   "Stopping with the dumbbells in front of the face, arms still angled forward.",
                   "Press until the arms are straight beside the ears with the dumbbells close together, then lower them to the front of the shoulders."),
       "back": ("Back Support",
                "The bench is upright or one notch back, and the back stays on it.",
                "With the back on the pad, the shoulders do the pressing; arching away from it tilts the press toward an incline and loads the lower back.",
                "Arching the lower back off the pad to push heavier dumbbells.",
                "Sit with the hips back and the whole back against the pad for the whole set."),
       "feet": ("Foot Position",
                "The feet anchor the body on the bench.",
                "Flat feet stop the hips sliding and the back arching as the dumbbells go up.",
                "Feet tucked under the bench or up on the toes.",
                "Plant both feet flat on the floor, about hip-width, and keep them still."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.86), ("Triceps Brachii", S, MOD, 0.54),
               ("Lateral Deltoid", S, MOD, 0.42), ("Upper Pectoralis", S, MOD, 0.40)],
   stabilisers=["rotator cuff", "serratus anterior", "upper trapezius"],
   comparison=("ELBOWS FLARED OUT", "Elbows forward, palms in", "Elbows flared to the sides",
               "Keeping the elbows a little in front of the shoulders lets the front deltoids and upper chest press with the shoulder out of the turned-out, pulled-back position.",
               "Flaring the elbows out while the palms stay in pulls the forearms off vertical and gives up the in-front path that keeps the shoulder out of the turned-out, pulled-back position."),
   glows=two_arm_glows(n))
SETUP[n] = [
    "Set the bench upright or one notch back and sit with your back on the pad.",
    "Plant your feet flat on the floor.",
    "Hold the dumbbells at the front of your shoulders, palms facing each other.",
    "Keep your elbows low, by your sides and a little forward.",
]

# ---------------------------------------------------------------- single-arm dumbbell shoulder press

n = "Single-Arm Dumbbell Shoulder Press"
ex(name=n, var="singleArmDumbbellShoulderPress",
   overrides={"lockout": (0.14, "leading"), "elbow": (0.32, "trailing"), "core": (0.50, "trailing"),
              "brace": (0.68, "trailing"), "stance": (0.86, "leading")},
   annotations=[
       ("core", "Stay tall, no side lean", "spine"),
       ("elbow", "Elbow under the dumbbell", "forearm_L"),
       ("lockout", "Press to a straight arm", "hand_L"),
       ("brace", "Ribs down, glutes tight", "pelvis"),
       ("stance", "Knees soft, no dip", "patella_R"),
   ],
   cues={"core": core_one("dumbbell"), "elbow": elbow_one("dumbbell"), "lockout": lockout(one_arm=True),
         "brace": BRACE_STAND, "stance": STANCE_STRICT},
   activation=[("Anterior Deltoid", P, HI, 0.88), ("Lateral Deltoid", P, HI, 0.76),
               ("Triceps Brachii", S, MOD, 0.52), ("Obliques", S, MOD, 0.42)],
   stabilisers=["quadratus lumborum", "rotator cuff", "serratus anterior", "glutes"],
   comparison=("LEANING AWAY", "Tall trunk, straight press", "Trunk leans away from the weight",
               "Staying tall makes the obliques hold the trunk still while one shoulder presses the dumbbell.",
               "A big lean away tilts the dumbbell up with the trunk, so the shoulder presses less and the obliques stop holding the trunk still."),
   glows=one_arm_glows(n))
SETUP[n] = [
    "Stand with your feet hip-width and your knees soft.",
    "Hold one dumbbell just above your shoulder, palm forward.",
    "Let your free arm hang by your side.",
    "Brace your core and squeeze your glutes.",
]

# ---------------------------------------------------------------- cable shoulder press (two low pulleys behind)

n = "Cable Shoulder Press"
ex(name=n, var="cableShoulderPress",
   overrides={"wrist": (0.14, "leading"), "lockout": (0.14, "trailing"), "elbow": (0.32, "trailing"),
              "brace": (0.50, "trailing"), "stance": (0.68, "trailing")},
   annotations=[
       ("elbow", "Elbows under the handles", "forearm_L"),
       ("lockout", "Handles over shoulders", "hand_L"),
       ("brace", "Ribs down, glutes tight", "spine"),
       ("stance", "Hip-width, knees soft", "patella_L"),
       ("wrist", "Wrists straight", "hand_R"),
   ],
   cues={
       "elbow": ("Elbow Position",
                 "The elbows stay under the handles while the cables pull back.",
                 "The cables run down and back to the low pulleys, so they pull the handles back as well as down; elbows under the handles and a little forward keep the press in the scapular plane.",
                 "Letting the cables pull the elbows back behind the shoulders at the bottom.",
                 "Hold the handles at the shoulders with the forearms vertical and the elbows slightly in front of the body."),
       "lockout": ("Lockout",
                   "The handles finish over the shoulders, not behind the head.",
                   "Because the cables pull down and back, they draw the arms behind the head at the top; holding the handles over the shoulders keeps the arms in line with the trunk instead of the shoulders and lower back arching back to follow the cables.",
                   "The arms drifting back behind the head at lockout.",
                   "Press up and slightly in until the arms are straight, the handles over the shoulders and the biceps beside the ears."),
       "brace": ("Trunk Bracing",
                 "The cables pull back as well as down, so the trunk stays braced.",
                 "Braced abs and tight glutes keep the ribs over the pelvis; with the pull coming from behind, a loose trunk is drawn into a lean with the lower back arched.",
                 "Leaning back with the lower back arched as the handles go up.",
                 "Brace the abs, squeeze the glutes and keep the ribs stacked over the pelvis on every rep."),
       "stance": ("Stance",
                  "Stand centred between the pulleys, a small step in front of them.",
                  "Hip-width feet and soft knees give a steady base against the cables' backward pull.",
                  "Feet drawn together and knees locked, so the cables rock the body back.",
                  "Stand with the feet hip-width, knees soft and the weight over the middle of the feet, centred between the pulleys."),
       "wrist": WRIST_PRESS,
   },
   activation=[("Anterior Deltoid", P, HI, 0.88), ("Lateral Deltoid", P, HI, 0.76),
               ("Triceps Brachii", S, MOD, 0.50), ("Rectus Abdominis", S, LOW, 0.30)],
   stabilisers=["rotator cuff", "serratus anterior", "upper trapezius", "glutes"],
   comparison=("LEANING BACK", "Ribs down, handles overhead", "Leaning back into the cables",
               "Staying braced and upright keeps the handles rising over the shoulders against the cables' backward pull.",
               "Leaning back lets the cables pull the body into an arch and turns the press into a steep incline press."),
   glows=two_arm_glows(n))
SETUP[n] = [
    "Set both pulleys at the bottom and attach a handle to each.",
    "Stand centred between them, a small step in front.",
    "Bring the handles up to your shoulders, palms forward.",
    "Brace your core, knees soft.",
]

# ---------------------------------------------------------------- single-arm cable shoulder press

n = "Single-Arm Cable Shoulder Press"
ex(name=n, var="singleArmCableShoulderPress",
   overrides={"lockout": (0.14, "leading"), "elbow": (0.32, "trailing"), "core": (0.50, "trailing"),
              "brace": (0.68, "trailing"), "stance": (0.86, "leading")},
   annotations=[
       ("core", "Stay tall, no side lean", "spine"),
       ("elbow", "Elbow under the handle", "forearm_L"),
       ("lockout", "Handle over the shoulder", "hand_L"),
       ("brace", "Ribs down, glutes tight", "pelvis"),
       ("stance", "Hip-width, knees soft", "patella_R"),
   ],
   cues={
       "core": core_one("cable"),
       "elbow": ("Elbow Position",
                 "The working elbow stays under the handle while the cable pulls back.",
                 "The cable runs down and back to the low pulley, so it pulls the handle back as well as down; the elbow under the handle and a little forward keeps the press in the scapular plane.",
                 "Letting the cable pull the elbow back behind the shoulder at the bottom.",
                 "Hold the handle at the shoulder with the forearm vertical and the elbow slightly in front of the body."),
       "lockout": ("Lockout",
                   "The handle finishes over the shoulder, not behind the head.",
                   "Because the cable pulls down and back, it draws the arm behind the head at the top; holding the handle over the shoulder keeps the arm in line with the trunk instead of the shoulder and lower back arching back to follow the cable.",
                   "The arm drifting back behind the head at lockout.",
                   "Press up until the arm is straight, the handle over the shoulder and the biceps beside the ear."),
       "brace": BRACE_STAND,
       "stance": ("Stance",
                  "Stand a small step in front of the pulley, feet hip-width.",
                  "Hip-width feet and soft knees give a steady base against the cable's pull down and back on one side.",
                  "Feet drawn together and knees locked, so the cable rocks the body.",
                  "Stand with the feet hip-width, knees soft and the weight over the middle of the feet."),
   },
   activation=[("Anterior Deltoid", P, HI, 0.88), ("Lateral Deltoid", P, HI, 0.76),
               ("Triceps Brachii", S, MOD, 0.50), ("Obliques", S, MOD, 0.42)],
   stabilisers=["quadratus lumborum", "rotator cuff", "serratus anterior", "glutes"],
   comparison=("LEANING AWAY", "Tall trunk, handle overhead", "Trunk leans away from the cable",
               "Staying tall makes the obliques hold the trunk still while one shoulder presses the handle.",
               "A big lean away tilts the handle up with the trunk, so the shoulder presses less and the obliques stop holding the trunk still."),
   glows=one_arm_glows(n))
SETUP[n] = [
    "Set one pulley at the bottom and attach a handle.",
    "Stand beside it, a small step in front, feet hip-width.",
    "Bring the handle to the near shoulder, palm forward.",
    "Let your free arm hang by your side and brace.",
]

if __name__ == "__main__":
    probs = validate(["Dumbbell Push Press", "Standing Dumbbell Press", "Seated Dumbbell Press", "Neutral-Grip Dumbbell Shoulder Press", "Single-Arm Dumbbell Shoulder Press", "Cable Shoulder Press", "Single-Arm Cable Shoulder Press"]); print("\n".join(probs) or "OK")
