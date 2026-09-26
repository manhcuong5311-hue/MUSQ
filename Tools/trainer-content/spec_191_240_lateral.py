# Trainer content for batch 191-240 (2026-09-26), family: lateral and Y
# raises, rotator cuff. Source exports 206, 208-212, 217-219 from the HIKSEMI
# drive's "190-240" folder, converted from SourceExports/190-240. Same format
# as spec.py; collected by spec_191_240.py (see README).
#
# What each model shows, from the rig (joint angles and the dumbbell's handle
# axis sampled across the clip, body axes from the hips and spine):
# - Leaning Lateral Raise (206): standing side-on to a rack upright about
#   0.7 m away, feet almost together, the RIGHT hand holding the upright at
#   chest height with the elbow bent ~95°. The trunk is tilted ~14° TOWARD
#   the rack (away from the dumbbell) with the legs straight under it. Only
#   the LEFT arm raises: elbow fixed at ~165°, from beside the body (the
#   dumbbell then sits ~24° out from vertical, so it already has leverage) to
#   ~12° above horizontal, ~20° in front of the body, palm down at the top.
#   This is the lean-in version (trunk tilted away from the working arm),
#   which loads the bottom of the raise; the lean-away version with the
#   support arm straight does the opposite (see notes).
# - Incline Lateral Raise (208): lying on the RIGHT side against an incline
#   bench's backrest (~32°), bottom hip on the seat, knees bent ~105°, the
#   bottom (right) foot on the floor and the top one resting on it, the right
#   hand holding the top of the backrest. The LEFT arm
#   raises from in front of the hip to 90° from the trunk (54° above
#   horizontal in the room), elbow fixed at ~165°, ~10° in front of the body,
#   palm toward the body at the bottom.
# - Chest-Supported Lateral Raise (209): kneeling on the seat of an incline
#   bench (~37° backrest), chest on the pad, trunk 52° forward of vertical,
#   chin at the top of the pad. Both arms, elbows ~164°, from hanging straight
#   down (palms facing each other) to straight out to the sides, horizontal
#   in the room, thumbs toward the head.
# - Y-Raise (210): the same kneeling, chest-supported position on the same
#   bench. Both arms, elbows ~170°, from hanging straight down to a Y about
#   35° out from the line of the head (~145° of elevation, ~30° above
#   horizontal in the room), thumbs up; at the top the elbows are level with
#   the ears but ~30 cm out to the sides, not beside them.
# - Cable Y-Raise (211): standing between the two LOW pulleys of a cable
#   crossover, facing the machine, the pulleys ~0.45 m ahead and ~1 m to each
#   side; cables crossed (the left hand holds the cable from the right-hand
#   pulley). Feet 0.3 m apart, knees straight, trunk ~10° forward. Hands start
#   crossed in front of the hips and sweep up and out to a Y (~140°), elbows
#   ~165-170°, thumbs up.
# - Lu Raise (212): standing, feet 0.3 m apart, knees straight, a light
#   dumbbell in each hand. Both arms from the sides (palms in) out to the
#   sides, ~10° in front of the body, all the way overhead (~168°), elbows
#   ~166-172°; the palms turn to face forward and in overhead and the
#   shoulders rise ~3.5 cm only near the top.
# - Cable External Rotation (217): standing, the pulley at elbow height
#   (~1.13 m) on the lifter's RIGHT, single handle in the LEFT (far) hand,
#   elbow at 86-95° against the side (upper arm 2-5° from vertical), thumb
#   up; the forearm turns from ~35° across the stomach to ~58° out. The right
#   hand rests on the hip.
# - Cable Internal Rotation (218): the mirror setup, pulley at elbow height on
#   the lifter's LEFT, handle in the LEFT (near) hand; the forearm turns from
#   ~58° out to ~40° across the stomach. Right hand on the hip.
# - Powell Raise (219): lying on the RIGHT side along a flat bench, knees bent
#   and stacked, the right arm stretched past the head as a pillow. The LEFT
#   arm stays at right angles to the trunk (elbow ~170°) and sweeps from
#   about 35° below level in front of the chest (the wrist 0.58 m off the
#   floor, about bench height; it never hangs toward the floor) to pointing
#   at the ceiling (~12° short of vertical, tilted back): side-lying
#   horizontal abduction, palm toward the feet.
#
# Framings: the leaning raise, Lu raise and both cable rotations are nearly
# front-on (yaw -0.25 to -0.3), so the lifter's LEFT arm is on the RIGHT of
# the screen; the chest-supported, Y and cable Y raises are seen from behind
# (yaw -2.5 to -2.8), LEFT arm on the left; the incline (yaw 1.0) and Powell
# (0.8) raises are lying bodies seen from the front and above.
#
# Sources (checked 2026-09-26):
# - Larsen S, Wolf M, Schoenfeld BJ, Sandberg NO, Fredriksen AB, Kristiansen
#   BS, van den Tillaar R, Swinton PA, Falch HN 2025, Front Physiol
#   16:1611468, doi:10.3389/fphys.2025.1611468 — dumbbell and cable lateral
#   raises grew the lateral deltoid alike; the dumbbell raise has an ascending
#   resistance profile with little torque in the lengthened position.
# - Coratella G, Tornatore G, Longo S, Esposito F, Ce E 2020, Int J Environ
#   Res Public Health 17(17):6015, doi:10.3390/ijerph17176015 — lateral raise
#   variations in bodybuilders: neutral humerus gave the most medial deltoid;
#   internal rotation raised posterior deltoid and upper trapezius; external
#   rotation raised anterior and medial deltoid.
# - Wickham J, Pizzari T, Stansfeld K, Burnside A, Watson L 2010,
#   J Electromyogr Kinesiol 20(2):212-222, doi:10.1016/j.jelekin.2009.06.004
#   — abduction 0-166° with a light dumbbell: supraspinatus and middle
#   deltoid are the prime movers (first on, highest %MVC).
# - Escamilla RF, Yamashiro K, Paulos L, Andrews JR 2009, Sports Med
#   39(8):663-685, doi:10.2165/00007256-200939080-00004 — review: the cuff
#   abducts best at low angles and the deltoids at high angles; estimated
#   abduction torque shares (middle deltoid 35-65%, supraspinatus 25%,
#   anterior deltoid 2%); the scapula rotates up 45-55° in full elevation,
#   driven largely by the serratus anterior.
# - Ekstrom RA, Donatelli RA, Soderberg GL 2003, J Orthop Sports Phys Ther
#   33(5):247-258, doi:10.2519/jospt.2003.33.5.247 — the prone overhead arm
#   raise in line with the lower trapezius gave the most lower trapezius
#   activity and, with horizontal extension in external rotation, the most
#   middle trapezius activity; abduction in the scapular plane above 120° (and
#   a diagonal) the most serratus anterior.
# - Arlotta M, LoVasco G, McLean L 2011, J Electromyogr Kinesiol
#   21(3):403-410, doi:10.1016/j.jelekin.2010.11.006 — the modified prone
#   cobra and prone row beat an isometric prone V-raise for the lower
#   trapezius (caveat for the Y).
# - Cools AM, Dewitte V, Lanszweert F, et al. 2007, Am J Sports Med
#   35(10):1744-1751, doi:10.1177/0363546507303560 — side-lying external
#   rotation, side-lying forward flexion, prone horizontal abduction with
#   external rotation and prone extension have the lowest upper-to-middle/
#   lower trapezius ratios (the Powell raise itself was not tested).
# - Reinold MM, Wilk KE, Fleisig GS, et al. 2004, J Orthop Sports Phys Ther
#   34(7):385-394, doi:10.2519/jospt.2004.34.7.385 — external rotation
#   exercises: infraspinatus and teres minor highest in side-lying ER (62%,
#   67% MVIC); prone horizontal abduction at 100° with full ER highest for
#   supraspinatus (82%), middle (87%) and posterior deltoid (88%).
# - Reinold MM, Escamilla RF, Wilk KE 2009, J Orthop Sports Phys Ther
#   39(2):105-117, doi:10.2519/jospt.2009.2835 — review: in Reinold 2004 a
#   towel roll between elbow and ribs raised infraspinatus and teres minor EMG
#   by 20-25% in standing ER at 0° and helps keep the form; in internal
#   rotation at 0° abduction the subscapularis is assisted by the pectoralis
#   major, latissimus dorsi and teres major (Decker 2003); the scapula rotates
#   up about 1° for every 2° of arm elevation up to 120°.
# - Townsend H, Jobe FW, Pink M, Perry J 1991, Am J Sports Med 19(3):264-272,
#   doi:10.1177/036354659101900309 — horizontal abduction with the arms
#   externally rotated was one of four exercises consistently among the most
#   challenging for every glenohumeral muscle studied.
# - Decker MJ, Tokish JM, Ellis HB, Torry MR, Hawkins RJ 2003, Am J Sports Med
#   31(1):126-134, doi:10.1177/03635465030310010601 — subscapularis with
#   latissimus, teres major and pectoralis major recorded; upper
#   subscapularis activity exceeded the lower in every exercise except
#   internal rotation at 0° abduction; push-up plus and diagonal exercises
#   load the subscapularis more than plain internal rotation.
# - Schoenfeld B, Sonmez RG, Kolber MJ, Contreras B, Harris R, Ozen S 2013,
#   J Strength Cond Res 27(10):2644-2649, doi:10.1519/JSC.0b013e318281e1e9 —
#   reverse fly machine: a neutral (thumbs-up) grip gave more posterior
#   deltoid and infraspinatus activity than a pronated grip. The Powell
#   model's palm-toward-the-feet hand is the pronated-grip equivalent.
# - Stokdijk M, Eilers PH, Nagels J, Rozing PM 2003, Clin Biomech
#   18(4):296-302, doi:10.1016/s0268-0033(03)00017-2 — about 55° of humeral
#   external rotation accompanies elevation in every plane.
# - McBride JM 2016, Biomechanics of resistance exercise, in Haff GG,
#   Triplett NT (eds), NSCA Essentials of Strength Training and Conditioning,
#   4th ed, Human Kinetics, ch. 2 — resistive torque is the load times its
#   horizontal distance (moment arm) from the joint.
# - ExRx.net: Dumbbell Incline Lateral Raise (30-45° incline, arm over the
#   bench, raise to perpendicular; lying shifts peak torque toward mid-range),
#   Dumbbell Lying Lateral Raise (synergists posterior deltoid, supraspinatus,
#   middle/lower trapezius), Dumbbell Lying Rear Lateral Raise (chest down,
#   upper arms perpendicular to the torso raised to shoulder height by
#   transverse abduction; target posterior deltoid), Dumbbell Side Lying Rear
#   Delt Raise (lying on the side, upper arm perpendicular to the trunk,
#   raised from the floor until above the shoulder; target posterior
#   deltoid; synergists infraspinatus, teres minor, lateral deltoid,
#   middle/lower trapezius), Dumbbell Incline Y Raise and Cable Y Raise
#   (target lateral deltoid; Y until the elbows are beside the ears; cable
#   synergists include supraspinatus, lower/middle trapezius, serratus
#   anterior), Cable Standing Shoulder External Rotation (elbow-height pulley,
#   far arm, elbow at the side, fixed 90°) and Internal Rotation (target
#   subscapularis; synergists pectoralis major, latissimus dorsi, teres major).
# - NFPT (Bovee R, 2025) incline side lateral raise; Rehab Hero Lean In
#   Lateral Raise (lean 20-30° toward a support, the free arm raises), Powell
#   Raise (on a 30-45° incline, abduction to 90°) and Lu Raises; The Prehab
#   Guys Powell Raise (side-lying on an inclined bench, pull with the shoulder
#   blade, no rocking or shrugging); BOXROX (Hudson R, 2026) Lu
#   raise (neutral grip, sides to overhead, mistakes: heavy load, momentum,
#   lower-back arching).

from common_191_240 import *

NAMES = ["Leaning Lateral Raise", "Incline Lateral Raise", "Chest-Supported Lateral Raise", "Y-Raise",
         "Cable Y-Raise", "Lu Raise", "Powell Raise", "Cable External Rotation", "Cable Internal Rotation"]

# ---------------------------------------------------------------- shared cues

TRAPS_ONE = ("Shoulder Position",
             "The working shoulder stays down while the arm rises.",
             "Keeping the shoulder blade down keeps the lateral deltoid lifting the arm instead of the upper trapezius hiking it.",
             "Shrugging the working shoulder up toward the ear as the dumbbell rises.",
             "Keep the shoulder down and the neck long, and lead the raise with the elbow.")
TRAPS_BOTH = ("Shoulder Position",
              "The shoulders stay down while the arms rise.",
              "Keeping the shoulder blades down keeps the lateral deltoids lifting the arms instead of the upper trapezius shrugging them up.",
              "Shrugging the shoulders up toward the ears as the dumbbells rise.",
              "Keep the shoulder blades down and the neck long, and lead with the elbows.")
ELBOW_ONE = ("Elbow Bend",
             "The arm is a fixed lever for the whole raise.",
             "A slight, constant elbow bend keeps the load on the deltoid; bending further as you lift shortens the lever and turns the raise into a pull.",
             "Bending the elbow more as the dumbbell rises.",
             "Set a soft bend at the bottom and hold exactly that angle up and down.")
PAD_CHEST = ("Chest Contact",
             "The chest stays on the pad for every rep.",
             "The pad takes the legs and lower back out of the raise, so no swing can start the dumbbells moving.",
             "Lifting the chest off the pad to heave the dumbbells up.",
             "Rest the chest on the pad with the chin just over its top edge, and keep it there as the arms move.")
ROT_ANGLE = ("Elbow Angle",
             "The elbow stays bent at 90°.",
             "A fixed right angle keeps the forearm as the lever the shoulder turns; letting it open lets the arm swing the handle instead.",
             "The elbow opening and the hand dropping as the handle moves.",
             "Hold the forearm level and the elbow at a right angle from the first rep to the last.")
ROT_TORSO = ("Torso Position",
             "The chest and hips face forward.",
             "The turn has to come from the shoulder; rotating the trunk carries the handle without the rotator cuff doing the work.",
             "Twisting the trunk to carry the hand along.",
             "Keep the hips and chest square to the front and move only the forearm.")


def delt(name, side, kind=A, opacity=0.55, dx=0.0, dy=0.01):
    """A glow on one deltoid, from the probed front and back of the shoulder."""
    return glow(name, [f"deltoid_arc_clavicle_2_{side}", f"deltoid_arc_scapula_2_{side}"], kind, opacity,
                rx=0.08, ry=0.06, dx=dx, dy=dy)


# ---------------------------------------------------------------- one-arm raises

N = "Leaning Lateral Raise"
ex(name=N, var="leaningLateralRaise",
   annotations=[
       ("lean", "Torso tilted to the rack", "spine"),
       ("traps", "Shoulder down, no shrug", "support_TrapeziusUpper_L"),
       ("elbow", "Soft, fixed elbow", "forearm_L"),
       ("range", "Lower all the way down", "hand_L"),
       ("support", "Hold the rack lightly", "hand_R"),
   ],
   cues={
       "lean": ("Torso Lean",
                "The torso tilts toward the rack, away from the dumbbell.",
                "Tilting away from the working arm sets the dumbbell out from the shoulder at the bottom, so it already has leverage there and the side delt works from the start of the rep instead of mostly near the top.",
                "Straightening up out of the lean as the dumbbell rises.",
                "Hold the rack, tilt the torso about 15° toward it and keep that angle fixed for the whole set."),
       "traps": TRAPS_ONE,
       "elbow": ELBOW_ONE,
       "range": ("Range of Motion",
                 "The arm travels from your side to shoulder height.",
                 "The lean loads the bottom of the raise, where an upright raise is almost weightless; stopping short there throws away the reason for leaning.",
                 "Stopping the dumbbell halfway down, or resting it against the thigh between reps.",
                 "Lower until the arm is by your side without letting the dumbbell rest, then raise to about shoulder height."),
       "support": ("Support Arm",
                   "The rack hand holds you in place; it does not pull.",
                   "A still support arm keeps the lean fixed, so the side delt lifts the dumbbell instead of the body rocking it up.",
                   "Pulling on the rack to rock the torso and swing the dumbbell up.",
                   "Hold the upright with a light, steady grip and keep the torso still while only the working arm moves."),
   },
   activation=[("Lateral Deltoid", P, HI, 0.86), ("Supraspinatus", S, MOD, 0.46),
               ("Anterior Deltoid", S, MOD, 0.44), ("Upper Trapezius", S, MOD, 0.40)],
   stabilisers=["obliques", "rotator cuff", "serratus anterior"],
   comparison=("LOSING THE LEAN", "Torso tilted, arm to 90°", "Torso straightens up",
               "Holding the tilt keeps the dumbbell's leverage at the bottom, so the side delt works through the whole arc.",
               "Standing up out of the lean turns it back into an ordinary raise and lets the body help swing the weight."),
   glows=[delt(N, "L", dx=0.02), glow(N, ["attachment_TrapeziusUpper_L", "support_TrapeziusUpper_L"], SOFT, 0.30, rx=0.06, ry=0.04)],
   # The working arm sweeps the right of the frame and the support arm the
   # left, so the elbow cue sits above the arm and the rest below it; the
   # range pill sits under the dumbbell, which reaches row 0.50 at the bottom.
   overrides={"traps": (0.14, "leading"), "elbow": (0.14, "trailing"), "range": (0.68, "trailing"),
              "support": (0.50, "leading"), "lean": (0.68, "leading")})

SETUP[N] = [
    "Stand side-on to a rack upright, about an arm's length away.",
    "Hold the upright at chest height with the near hand.",
    "Tilt your torso about 15° toward the rack, feet close together.",
    "Let the dumbbell hang in the far hand, palm facing in.",
]

N = "Incline Lateral Raise"
ex(name=N, var="inclineLateralRaise",
   annotations=[
       ("body", "Stay stacked, no rolling", "spine"),
       ("traps", "Shoulder down, no shrug", "support_TrapeziusUpper_L"),
       ("elbow", "Soft, fixed elbow", "forearm_L"),
       ("range", "Start low by your hip", "hand_L"),
       ("path", "Arm slightly in front", "upper_arm_L"),
   ],
   cues={
       "body": ("Body Position",
                "You lie on one side, hips and shoulders stacked.",
                "Staying stacked on the pad keeps the arm rising in the side plane and stops the trunk from helping it up.",
                "Rolling the chest back toward the ceiling to swing the dumbbell up.",
                "Keep the bottom hip on the seat and the top shoulder directly over the bottom one for every rep."),
       "traps": TRAPS_ONE,
       "elbow": ELBOW_ONE,
       "range": ("Range of Motion",
                 "Each rep starts with the arm down by the hip.",
                 "Lying on the incline turns the resistance curve round: the dumbbell pulls hardest in the lower half, where a standing raise is light, and least near the top.",
                 "Cutting the bottom short and pumping the top half, where the load is lightest.",
                 "Lower until the dumbbell is back in front of the hip, then raise until the arm is at right angles to your body."),
       "path": ("Arm Path",
                "The arm rises a little in front of the body.",
                "A path slightly in front of the body lines the raise up with the shoulder blade and keeps the joint comfortable.",
                "Sweeping the arm back behind the body at the top.",
                "Keep the dumbbell a little in front of the shoulder all the way up, leading with the elbow."),
   },
   activation=[("Lateral Deltoid", P, HI, 0.84), ("Supraspinatus", S, MOD, 0.52),
               ("Anterior Deltoid", S, MOD, 0.40), ("Upper Trapezius", S, LOW, 0.30)],
   stabilisers=["rotator cuff", "serratus anterior", "lower trapezius"],
   comparison=("CUTTING THE BOTTOM SHORT", "Full arc from the hip", "Pumping the top half",
               "Starting every rep from the hip trains the side delt where this raise loads it most.",
               "Short reps near the top skip the part of the arc the incline makes hardest."),
   glows=[delt(N, "L", dx=0.01), glow(N, ["attachment_TrapeziusUpper_L", "support_TrapeziusUpper_L"], SOFT, 0.30, rx=0.06, ry=0.04)],
   # Lying across the frame, the bottom arm reaching to the top of the bench
   # on the left: the arm cues come from above, the trunk cues from below.
   overrides={"range": (0.14, "trailing"), "elbow": (0.14, "leading"), "path": (0.32, "leading"),
              "traps": (0.68, "leading"), "body": (0.68, "trailing")})

SETUP[N] = [
    "Set an incline bench to about 30°.",
    "Lie on your side against the backrest, bottom hip on the seat.",
    "Rest your bottom arm along the top of the bench, bottom foot on the floor.",
    "Start with the dumbbell in front of your hip, palm facing in.",
]

# ---------------------------------------------------------------- chest-supported raises

N = "Chest-Supported Lateral Raise"
ex(name=N, var="chestSupportedLateralRaise",
   annotations=[
       ("pad", "Chest stays on the pad", "chest"),
       ("traps", "Shoulders down, no shrug", "support_TrapeziusUpper_L"),
       ("elbow", "Soft, fixed elbows", "forearm_R"),
       ("path", "Arms out to the sides", "hand_R"),
       ("height", "Stop at shoulder level", "hand_L"),
   ],
   cues={
       "pad": PAD_CHEST,
       "traps": TRAPS_BOTH,
       "elbow": ("Elbow Bend",
                 "The arms stay long as they rise.",
                 "A soft, fixed elbow bend keeps a long lever on the deltoids; bending further turns the raise into a row for the mid-back.",
                 "Bending the elbows so the dumbbells hang below them, turning the raise into a row.",
                 "Set a slight bend at the bottom and hold that exact angle through the rep."),
       "path": ("Arm Path",
                "The arms travel straight out to the sides.",
                "Raising out to the sides keeps the side delts leading, with the rear delts sharing the work because of the lean; pulling the arms back behind the line of the shoulders turns the lift into a rear-delt fly.",
                "Pulling the arms back toward the ceiling at the top, behind the line of the shoulders.",
                "Raise the dumbbells straight out from the shoulders, in line with the body, not behind it."),
       "height": ("Range of Motion",
                  "The dumbbells rise until the arms are level with the shoulders.",
                  "With the chest supported, the load peaks as the arms reach level; above that the dumbbells lose leverage and more of the effort goes to the traps rotating the shoulder blades up.",
                  "Swinging the dumbbells up above the level of the shoulders.",
                  "Raise until the arms are about level with the floor, pause briefly, then lower until they hang straight down."),
   },
   activation=[("Lateral Deltoid", P, HI, 0.82), ("Posterior Deltoid", S, MOD, 0.68),
               ("Middle Trapezius", S, MOD, 0.46), ("Upper Trapezius", S, LOW, 0.34)],
   stabilisers=["rotator cuff", "lower trapezius", "forearms"],
   comparison=("ROWING THE WEIGHT", "Long arms, out to the sides", "Elbows bend into a row",
               "Long arms sweeping out to the sides keep the lateral deltoid as the prime mover.",
               "Bending the elbows and pulling up turns the raise into a row, handing the work to the rear delts and mid-back."),
   glows=[delt(N, "L", dx=-0.01), delt(N, "R", dx=0.01),
          glow(N, ["scapula_L", "scapula_R"], SOFT, 0.30, rx=0.06, ry=0.05, dy=0.02)],
   # Seen from behind, the arms sweep rows 0.32-0.50 on both sides, so the
   # labels sit above the shoulders and below the hands.
   overrides={"traps": (0.14, "leading"), "elbow": (0.14, "trailing"), "height": (0.68, "leading"),
              "path": (0.68, "trailing"), "pad": (0.86, "trailing")})

SETUP[N] = [
    "Set an incline bench to about 35°.",
    "Kneel on the seat and rest your chest on the pad.",
    "Let the dumbbells hang straight down, palms facing in.",
    "Keep your chin just over the top of the pad.",
]

N = "Y-Raise"
ex(name=N, var="yRaise",
   annotations=[
       ("pad", "Chest stays on the pad", "chest"),
       ("traps", "Shoulders down and back", "scapula_R"),
       ("neck", "Chin tucked, neck long", "head"),
       ("elbow", "Arms long, elbows soft", "forearm_R"),
       ("height", "Up to a Y, thumbs up", "hand_L"),
   ],
   cues={
       "pad": ("Chest Contact",
               "The chest stays on the pad as the arms go overhead.",
               "The pad stops the lower back arching to fake height, so the shoulder blades and shoulders have to do the lifting.",
               "Arching the lower back and lifting the chest off the pad to get the arms higher.",
               "Keep the chest and stomach on the pad and let the arms stop where the shoulders run out of range."),
       "traps": ("Shoulder Blades",
                 "The shoulder blades move down and back, not up.",
                 "Drawing the shoulder blades down and back as the arms rise brings in the lower trapezius the Y is aimed at; shrugging hands the lift to the upper trapezius.",
                 "Shrugging the shoulders up toward the ears as the arms rise.",
                 "Set the shoulder blades down and back before each rep, then raise the arms without letting the shoulders creep up."),
       "neck": ("Head Position",
                "The head stays in line with the spine.",
                "A neutral neck stops the neck muscles joining in, so the effort stays on the shoulder blades and shoulders.",
                "Craning the head up to watch the dumbbells.",
                "Keep the chin slightly tucked and look at the floor just beyond the bench."),
       "elbow": ("Elbow Bend",
                 "The arms stay nearly straight.",
                 "Long arms make a long lever, so light dumbbells are enough; bending the elbows lets the hands drop and shortens the reach of the Y.",
                 "Bending the elbows so the dumbbells drop toward the floor at the top.",
                 "Keep a slight bend in the elbows and reach long through the thumbs."),
       "height": ("Arm Path",
                  "The arms rise into a Y, thumbs up, until the elbows are level with the ears.",
                  "Raising the arms overhead face down, in line with the lower trapezius fibres, gave the most lower trapezius activity in one EMG study, though another ranked the prone row and prone cobra higher.",
                  "Stopping short with the arms still well below the head.",
                  "Lead with the thumbs and raise the arms up and out, about 35° from the head, until the elbows are level with the ears; pause, then lower under control."),
   },
   activation=[("Lower Trapezius", P, HI, 0.78), ("Lateral Deltoid", P, HI, 0.72),
               ("Middle Trapezius", S, HI, 0.70), ("Posterior Deltoid", S, MOD, 0.46)],
   stabilisers=["serratus anterior", "rotator cuff", "rhomboids"],
   comparison=("SHRUGGING UP", "Shoulders down, arms in a Y", "Shoulders shrug to the ears",
               "Drawing the shoulder blades down as the arms rise keeps the lower trapezius doing the lifting.",
               "Shrugging lets the upper trapezius take over, the opposite of what the Y is meant to train."),
   glows=[glow(N, ["scapula_L", "scapula_R", "chest"], A, 0.55, rx=0.08, ry=0.06, dy=0.03),
          delt(N, "L", SOFT, 0.32, dx=-0.01), delt(N, "R", SOFT, 0.32, dx=0.01)],
   overrides={"neck": (0.14, "leading"), "traps": (0.14, "trailing"), "height": (0.68, "leading"),
              "elbow": (0.68, "trailing"), "pad": (0.86, "trailing")})

SETUP[N] = [
    "Set an incline bench to about 35°.",
    "Kneel on the seat and rest your chest on the pad.",
    "Let light dumbbells hang straight down, palms facing in.",
    "Keep your chin just over the top of the pad.",
]

# ---------------------------------------------------------------- standing overhead raises

N = "Cable Y-Raise"
ex(name=N, var="cableYRaise",
   annotations=[
       ("torso", "Ribs down, no lean back", "spine"),
       ("traps", "Shoulders away from ears", "support_TrapeziusUpper_L"),
       ("elbow", "Arms long, elbows soft", "forearm_L"),
       ("height", "Up and out into a Y", "hand_L"),
       ("cross", "Cables crossed at the hips", "hand_R"),
   ],
   cues={
       "torso": ("Torso Position",
                 "A slight forward lean, held still.",
                 "A fixed torso makes the shoulders carry the arms overhead; leaning back and arching lets the lower back fake the top of the Y.",
                 "Leaning back and arching the lower back as the hands go overhead.",
                 "Tilt forward a little from the hips, brace, keep the ribs down and hold that angle for the set."),
       "traps": ("Shoulder Position",
                 "The shoulders stay away from the ears.",
                 "The shoulder blades should rotate up as the arms pass shoulder height, but hiking them to the ears hands the lift to the upper trapezius.",
                 "Shrugging the shoulders up to the ears to finish the rep.",
                 "Keep the neck long and the shoulders down, even with the hands overhead."),
       "elbow": ("Elbow Bend",
                 "The arms stay long from start to finish.",
                 "A slight, fixed elbow bend keeps the cables pulling on the shoulders; bending the elbows turns the Y into a pull toward the face.",
                 "Bending the elbows as the hands rise, so the hands drop in front of the face.",
                 "Hold a soft bend in the elbows and keep the arms long as they sweep up."),
       "height": ("Arm Path",
                  "The hands sweep up and out into a Y above the head.",
                  "Carrying on past shoulder height into the Y makes the shoulder blades rotate up, so the serratus anterior and lower trapezius join the side delts, and the cables keep pulling all the way to the top.",
                  "Stopping at shoulder height, which turns the Y into a lateral raise.",
                  "Raise the arms up and out, thumbs leading, until the elbows are about level with the ears, then lower under control to the hips."),
       "cross": ("Cable Setup",
                 "The cables cross in front of you.",
                 "Crossing the cables makes each one pull its hand down and across the body, so the shoulders are loaded from the very bottom of the rep.",
                 "Taking the handles uncrossed, so the hands start at the sides and the bottom of the rep goes slack.",
                 "Take each handle from the opposite pulley and start with the hands crossed in front of the hips."),
   },
   activation=[("Lateral Deltoid", P, HI, 0.80), ("Serratus Anterior", S, MOD, 0.56),
               ("Lower Trapezius", S, MOD, 0.50), ("Supraspinatus", S, MOD, 0.46)],
   stabilisers=["rotator cuff", "core", "erector spinae"],
   comparison=("LEANING BACK", "Ribs down, arms into a Y", "Back arches to reach overhead",
               "A still, slightly forward torso makes the shoulders raise the cables overhead.",
               "Arching back lets the lower back finish the Y and loads the spine instead of the shoulders."),
   glows=[delt(N, "L", dx=-0.01), delt(N, "R", dx=0.01),
          glow(N, ["scapula_L", "scapula_R", "chest"], SOFT, 0.30, rx=0.07, ry=0.06, dy=0.03)],
   # From behind-left the left arm fills the upper left and the right arm the
   # right: labels go where neither arm passes.
   overrides={"traps": (0.14, "trailing"), "height": (0.32, "leading"), "elbow": (0.50, "leading"),
              "cross": (0.68, "leading"), "torso": (0.86, "trailing")})

SETUP[N] = [
    "Set both pulleys of a cable crossover at the bottom.",
    "Take the right pulley's handle in your left hand and the left one in your right.",
    "Stand between the pulleys facing the machine, feet hip-width.",
    "Lean forward slightly, hands crossed in front of your hips.",
]

N = "Lu Raise"
ex(name=N, var="luRaise",
   annotations=[
       ("traps", "Shoulders down to start", "attachment_TrapeziusUpper_R"),
       ("elbow", "Arms long, elbows soft", "forearm_L"),
       ("torso", "Ribs down, no arching", "spine"),
       ("height", "All the way overhead", "hand_L"),
       ("path", "Out to the sides", "forearm_R"),
   ],
   cues={
       "traps": ("Shoulder Position",
                 "The shoulders stay down until the arms pass shoulder height.",
                 "The shoulder blades rotate up more and more as the arms rise, and overhead the traps and serratus rightly work hard; hiking the shoulders from the first inch takes the start of the lift away from the side delts.",
                 "Shrugging the shoulders up before the arms have left the sides.",
                 "Start with the shoulders down, lift out to the sides, and let the shoulders rise only as the arms go overhead."),
       "elbow": ("Elbow Bend",
                 "Long arms, from the sides to overhead.",
                 "Nearly straight arms keep the load on the shoulders through the whole arc; bending them shortens the lever and turns the top into a press.",
                 "Bending the elbows as the dumbbells go overhead.",
                 "Keep a slight, fixed bend in the elbows and reach long all the way up."),
       "torso": ("Torso Position",
                 "The ribs stay down as the arms go overhead.",
                 "Getting overhead takes full shoulder mobility; arching the lower back fakes the last part of the range with the spine.",
                 "Leaning back and arching the lower back to get the dumbbells overhead.",
                 "Brace, squeeze the glutes, keep the ribs down and stop where the shoulders run out of range."),
       "height": ("Range of Motion",
                  "The dumbbells go all the way overhead.",
                  "A Lu raise carries on past shoulder height into a full overhead arc, training the side delts together with the muscles that rotate the shoulder blade up.",
                  "Stopping at shoulder height, which leaves an ordinary lateral raise.",
                  "Raise out to the sides past shoulder height until the arms are nearly vertical, pause, then lower slowly to the sides."),
       "path": ("Arm Path",
                "The arms travel out to the sides, turning as they rise.",
                "The upper arm naturally turns outward, about 55° over a full raise, as it goes overhead, so letting the palms turn forward and in at the top keeps the movement smooth.",
                "Swinging the dumbbells forward, turning the top half into a front raise.",
                "Raise the arms out to the sides, a little in front of the body, letting the palms turn from facing in to facing forward and in overhead."),
   },
   activation=[("Lateral Deltoid", P, HI, 0.84), ("Supraspinatus", S, MOD, 0.60),
               ("Serratus Anterior", S, MOD, 0.54), ("Upper Trapezius", S, MOD, 0.54)],
   stabilisers=["lower trapezius", "rotator cuff", "core"],
   comparison=("ARCHING BACK", "Ribs down, arms overhead", "Lower back arches to finish",
               "Holding the ribs down makes the shoulders carry the dumbbells through the whole overhead arc.",
               "Arching the back fakes the top of the range with the spine and loads the lower back."),
   glows=[delt(N, "L", dx=0.01), delt(N, "R", dx=-0.01),
          glow(N, ["support_TrapeziusUpper_L", "support_TrapeziusUpper_R"], SOFT, 0.30, rx=0.07, ry=0.03, dy=0.01)],
   # Both arms sweep rows 0.21-0.53 on each side.
   overrides={"traps": (0.14, "leading"), "height": (0.14, "trailing"), "elbow": (0.68, "trailing"),
              "path": (0.68, "leading"), "torso": (0.86, "leading")})

SETUP[N] = [
    "Stand tall, feet hip-width, a light dumbbell in each hand.",
    "Let the arms hang at your sides, palms facing in.",
    "Keep a slight bend in the elbows.",
    "Brace your core and squeeze your glutes.",
]

# ---------------------------------------------------------------- rotator cuff

N = "Powell Raise"
ex(name=N, var="powellRaise",
   annotations=[
       ("body", "Stay on your side", "spine"),
       ("scapula", "Blade back, not up", "scapula_L"),
       ("elbow", "Arm long, elbow soft", "forearm_L"),
       ("path", "Arm level with shoulder", "upper_arm_L"),
       ("range", "Low to straight up", "hand_L"),
   ],
   cues={
       "body": ("Body Position",
                "You stay on your side, the trunk still.",
                "A still, stacked trunk makes the back of the shoulder lift the dumbbell instead of the body rolling it up.",
                "Rolling the chest back toward the ceiling to swing the dumbbell up.",
                "Keep the top shoulder directly over the bottom one and the knees stacked, and let only the arm move."),
       "scapula": ("Shoulder Blade",
                   "The shoulder blade draws back as the arm rises.",
                   "Starting the lift by drawing the shoulder blade toward the spine brings in the middle trapezius and keeps the upper trapezius from hiking the shoulder.",
                   "Hiking the shoulder up toward the ear as the arm rises.",
                   "Draw the shoulder blade back and down, then lift the arm, keeping the shoulder away from the ear."),
       "elbow": ("Elbow Bend",
                 "The arm stays long.",
                 "A long arm keeps the lever on the back of the shoulder; bending the elbow shortens it and lets the arm curl the weight up.",
                 "Bending the elbow and pulling the dumbbell up toward the chest.",
                 "Keep the elbow almost straight, with the same slight bend from bottom to top."),
       "path": ("Arm Path",
                "The arm stays level with the shoulder.",
                "Lifting with the arm at right angles to the body keeps the work on the rear deltoid and posterior cuff; letting it drift toward the hip turns the lift into a side-lying lateral raise.",
                "Letting the arm drift down toward the hip as it rises.",
                "Keep the arm in line with the shoulder, at right angles to the body, from the bottom of the rep to the top."),
       "range": ("Range of Motion",
                 "The arm travels from angled down in front of the chest to pointing at the ceiling.",
                 "Lying on the side, the dumbbell pulls hardest while the arm points forward and not at all once it points at the ceiling, so the lower half of the arc is where the work is.",
                 "Cutting the bottom short and pumping the arm near the top.",
                 "Lower until the arm angles well below shoulder level in front of the chest, raise it until it points at the ceiling, pause, and lower slowly."),
   },
   activation=[("Posterior Deltoid", P, HI, 0.80), ("Lateral Deltoid", S, MOD, 0.54),
               ("Infraspinatus", S, MOD, 0.50), ("Middle Trapezius", S, MOD, 0.48)],
   stabilisers=["rotator cuff", "lower trapezius", "core"],
   comparison=("ROLLING BACK", "Still trunk, arm to the ceiling", "Body rolls to swing it up",
               "Staying stacked on your side makes the back of the shoulder lift the dumbbell.",
               "Rolling back throws the weight up with the trunk and takes the rear delt and cuff out of the lift."),
   glows=[glow(N, ["deltoid_arc_scapula_2_L"], A, 0.55, rx=0.07, ry=0.06),
          glow(N, ["scapula_L", "chest"], SOFT, 0.30, rx=0.06, ry=0.05)],
   # Lying across the middle of the frame with the arm rising above it.
   overrides={"range": (0.14, "leading"), "elbow": (0.14, "trailing"), "scapula": (0.32, "trailing"),
              "path": (0.68, "leading"), "body": (0.68, "trailing")})

SETUP[N] = [
    "Lie on one side along a flat bench, knees bent and stacked.",
    "Stretch your bottom arm out under your head.",
    "Hold the dumbbell with the arm angled down in front of your chest.",
    "Keep the elbow almost straight, palm facing your feet.",
]

N = "Cable External Rotation"
ex(name=N, var="cableExternalRotation",
   annotations=[
       ("elbow", "Elbow pinned to side", "forearm_L"),
       ("angle", "Forearm level, elbow 90°", "hand_L"),
       ("shoulder", "Shoulder down, no shrug", "upper_arm_L"),
       ("torso", "Torso square, no twist", "spine"),
       ("stance", "Stand tall, no lean", "foot_L"),
   ],
   cues={
       "elbow": ("Elbow Position",
                 "The elbow stays pinned to your side.",
                 "With the upper arm fixed, the only way to move the handle is to rotate the shoulder outward, which is the infraspinatus and teres minor's job.",
                 "Letting the elbow drift out from the side as the hand swings out.",
                 "Keep the elbow against the ribs for the whole set; a small rolled towel there helps if you have one."),
       "angle": ROT_ANGLE,
       "shoulder": ("Shoulder Position",
                    "The shoulder stays down and back.",
                    "A settled shoulder lets the rotator cuff turn the arm; hiking it up brings in the upper trapezius.",
                    "Shrugging the working shoulder up as the handle moves out.",
                    "Keep the shoulder down, the chest up and the neck long."),
       "torso": ROT_TORSO,
       "stance": ("Stance",
                  "Stand tall, far enough from the stack.",
                  "Standing far enough away keeps the cable tight at the start, and standing tall stops you leaning away to drag the handle out.",
                  "Leaning the body away from the stack to pull the handle out.",
                  "Stand side-on, feet hip-width, where the cable is tight with the hand across the stomach, and stay upright."),
   },
   activation=[("Infraspinatus", P, HI, 0.80), ("Teres Minor", P, HI, 0.76), ("Posterior Deltoid", S, LOW, 0.26)],
   stabilisers=["supraspinatus", "middle trapezius", "core"],
   comparison=("ELBOW LEAVING THE SIDE", "Elbow pinned, forearm turns", "Elbow swings out",
               "With the elbow fixed at the side, the infraspinatus and teres minor turn the arm out.",
               "Letting the elbow leave the side swings the handle out with the deltoid and cuts the rotation short."),
   glows=[glow(N, ["deltoid_arc_scapula_2_L", "scapula_L"], A, 0.55, rx=0.07, ry=0.05, dy=0.01),
          glow(N, ["upper_arm_L"], SOFT, 0.30, rx=0.05, ry=0.04, dx=0.01, dy=0.04)],
   # The hand sweeps across row 0.36: the elbow label sits just above it, the
   # hand's below, the torso's beside the waist.
   overrides={"shoulder": (0.14, "trailing"), "elbow": (0.32, "trailing"), "torso": (0.50, "leading"),
              "angle": (0.68, "trailing"), "stance": (0.86, "trailing")})

SETUP[N] = [
    "Set a single handle at elbow height.",
    "Stand side-on to the stack and take the handle in your far hand.",
    "Elbow bent to 90° against your side, forearm across your stomach.",
    "Rest your free hand on your hip.",
]

N = "Cable Internal Rotation"
ex(name=N, var="cableInternalRotation",
   annotations=[
       ("elbow", "Elbow pinned to side", "forearm_L"),
       ("angle", "Forearm level, elbow 90°", "hand_L"),
       ("shoulder", "Shoulder back, chest up", "upper_arm_L"),
       ("torso", "Torso square, no twist", "spine"),
       ("stance", "Stand tall, no lean", "foot_L"),
   ],
   cues={
       "elbow": ("Elbow Position",
                 "The elbow stays pinned to your side.",
                 "With the upper arm fixed, the handle can only move by the shoulder turning inward, led by the subscapularis with the chest and lats assisting, instead of the arm swinging across the body.",
                 "Letting the elbow drift forward off the side as the hand comes in.",
                 "Keep the elbow against the ribs for the whole set."),
       "angle": ROT_ANGLE,
       "shoulder": ("Shoulder Position",
                    "The shoulder stays back as the hand comes in.",
                    "Rolling the shoulder forward lets the shoulder blade carry the hand across, so the hand travels further while the shoulder itself turns less.",
                    "The working shoulder rolling forward as the handle reaches the stomach.",
                    "Keep the chest up and the shoulder blade set back, and stop when the hand reaches the stomach."),
       "torso": ROT_TORSO,
       "stance": ("Stance",
                  "Stand tall, far enough from the stack.",
                  "Enough distance keeps the cable tight with the hand turned out, and standing tall stops you leaning away to drag the handle in.",
                  "Leaning the body away from the stack to pull the handle in.",
                  "Stand side-on, feet hip-width, where the cable is tight at the start, and stay upright."),
   },
   activation=[("Subscapularis", P, HI, 0.78), ("Pectoralis Major", S, MOD, 0.48), ("Latissimus Dorsi", S, LOW, 0.36)],
   stabilisers=["rotator cuff", "middle trapezius", "core"],
   comparison=("ELBOW LEAVING THE SIDE", "Elbow pinned, forearm turns", "Elbow drifts forward",
               "With the elbow fixed at the side, the subscapularis leads the turn inward.",
               "Letting the elbow drift forward turns the rotation into a chest-led swing across the body and takes work off the cuff."),
   glows=[glow(N, ["deltoid_arc_clavicle_2_L", "support_PectoralisMajor_Clavicular_L"], A, 0.55, rx=0.06, ry=0.05, dy=0.02),
          glow(N, ["support_PectoralisMajor_Sternal_L"], SOFT, 0.30, rx=0.07, ry=0.05)],
   # As the external rotation: elbow label above the hand's row, the hand's
   # below it, the torso's beside the waist.
   overrides={"shoulder": (0.14, "trailing"), "elbow": (0.32, "trailing"), "torso": (0.50, "leading"),
              "angle": (0.68, "trailing"), "stance": (0.86, "trailing")})

SETUP[N] = [
    "Set a single handle at elbow height.",
    "Stand side-on to the stack and take the handle in your near hand.",
    "Elbow bent to 90° against your side, forearm pointing out.",
    "Rest your free hand on your hip.",
]


if __name__ == "__main__":
    probs = validate(["Leaning Lateral Raise", "Incline Lateral Raise", "Chest-Supported Lateral Raise", "Y-Raise", "Cable Y-Raise", "Lu Raise", "Powell Raise", "Cable External Rotation", "Cable Internal Rotation"]); print("\n".join(probs) or "OK")
