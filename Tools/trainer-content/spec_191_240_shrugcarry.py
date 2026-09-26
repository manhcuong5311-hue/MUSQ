# Trainer content for batch 191-240 (2026-09-26), shrugs and loaded carries:
# exports 227-235 of the HIKSEMI drive's 190-240 folder, converted from
# SourceExports/190-240. Same format as spec.py; imported by spec_191_240.py
# (see common_191_240.py).
#
# What each model shows, from the rig (joints sampled across the clip):
# - All six shrugs share one body animation: standing tall, feet 0.32 m apart
#   (hip-width), knees soft (174-176°), trunk vertical, head still, elbows
#   straight (175-178°). The shoulders rise 5.4 cm straight up (shoulder to
#   pelvis 0.95 -> 1.03 torso lengths) with almost no forward travel (6 mm),
#   two reps in 8 s: ~1.3 s up, a short hold at the top, ~1.6 s down, a pause
#   at the bottom. Only the arms and the equipment differ:
#   - Dumbbell Shrug: a dumbbell at each side, handles front-to-back (palms
#     facing the thighs), hands 0.59 m apart.
#   - Barbell Shrug: bar in front of the thighs, hands 0.50 m apart (about
#     shoulder-width), 0.12 m ahead of the shoulders. Framed at yaw -0.8.
#   - Smith Machine Shrug: the same grip on a Smith bar, 0.14-0.15 m ahead of
#     the shoulders, the rails and uprights around the lifter.
#   - Cable Shrug: a handle in each hand at the sides (the dumbbell shrug's
#     arm pose), cables running down and out (~23° from vertical) to a low
#     pulley on each side, slightly behind the feet.
#   - Trap Bar Shrug: standing inside the frame, neutral grip on the side
#     handles, hands 0.56 m apart and in line with the body.
#   - Behind-the-Back Barbell Shrug: bar behind the thighs (0.14 m behind the
#     shoulders), hands 0.50 m apart; framed from behind-left (yaw -2.4), so
#     the lifter's LEFT side is on the left of the frame. The shoulder blades
#     do not retract more than in the front shrugs.
# - The carries walk IN PLACE (Tools/model-pipeline/inplace.py) and are
#   logged as timed sets:
#   - Farmer's Carry: a dumbbell in each hand, arms straight (171°) at the
#     sides; the left palm faces in, but the export's right hand is turned
#     palm-out (thumb pointing back), so the copy teaches palms in and the
#     lead should check a close still. Shoulders level, trunk upright (side
#     bend within 1°), feet ~0.30 m apart side to side, knees 123-166°; a
#     slow, deliberate walk, one step every 2 s (a 4 s gait cycle).
#   - Suitcase Carry: ONE dumbbell, in the LEFT hand; the right arm swings
#     freely; trunk upright (3° forward lean, no side bend), a narrow
#     tread (feet ~0.22 m apart), knees 119-173°; one step a second.
#   - Overhead Carry: a dumbbell in each hand locked overhead (elbows 175°,
#     upper arms at 175° elevation, beside the ears, handles side to side,
#     so palms forward), hands 0.46 m apart and 3-5 cm ahead of the
#     shoulders; the same walking legs as the suitcase carry.
#
# Every framing has a negative yaw. The front-on shrugs and carries show the
# lifter's LEFT arm on the RIGHT of the frame; labels are pinned with
# `overrides` so each sits on its joint's side, near its height.
#
# Sources:
# - Ekstrom RA, Donatelli RA, Soderberg GL 2003, J Orthop Sports Phys Ther
#   33(5):247-258, doi:10.2519/jospt.2003.33.5.247 — of 10 exercises, the
#   (unilateral) shoulder shrug gave the highest upper trapezius EMG; the
#   trapezius and serratus anterior are the scapular upward rotators, and
#   the serratus peaked in exercises with the most upward rotation
#   (abduction in the scapular plane above 120°).
# - Pizzari T, Wickham J, Balster S, Ganderton C, Watson L 2014, Clin Biomech
#   29(2):201-205, doi:10.1016/j.clinbiomech.2013.11.011 — standard shrug vs
#   a shrug at 30° abduction: upper, middle, lower trapezius and serratus
#   anterior all measured; the abducted shrug raised them.
# - Castelein B, Cools A, Parlevliet T, Cagnie B 2016, Man Ther 21:250-255,
#   doi:10.1016/j.math.2015.09.005 — fine-wire and surface EMG: a weighted
#   shrug with the arms at the sides gives high upper trapezius activity and
#   also works the levator scapulae and rhomboid major.
# - Swinton PA, Stewart A, Agouris I, Keogh JWL, Lloyd R 2011, J Strength
#   Cond Res 25(7):2000-2009, doi:10.1519/JSC.0b013e3181e73f87 — standing
#   inside a hexagonal (trap) bar lowered lumbar and hip moments and allowed
#   heavier loads than a straight bar (deadlift).
# - McGill SM, McDermott A, Fenwick CMJ 2009, J Strength Cond Res
#   23(4):1148-1161, doi:10.1519/JSC.0b013e318198f8f7 — 3 strongmen, farmer's
#   walk (75 kg a hand) and left- and right-hand suitcase carries: abdominals
#   peaked while walking; in the farmer's walk the external oblique peaks
#   (39-50% MVIC) sat well below the gluteus medius (108) and lumbar erector
#   (106-144) peaks; the external oblique OPPOSITE the load was more active
#   in the suitcase carries; one-handed carries (mainly the right-hand one)
#   produced the largest spine twist, put down to a waddling gait, though the
#   left-hand carry twisted less than the farmer's walk; the obliques and
#   quadratus lumborum buttress the hip in asymmetric carries; short, rapid
#   steps.
# - McGill SM, Marshall L, Andersen J 2013, Ergonomics 56(2):293-302,
#   doi:10.1080/00140139.2012.752528 — 30 kg
#   in one hand loaded the low back more than 15 kg in each hand, and more
#   than 30 kg in each hand.
# - Winwood PW, Cronin JB, Brown SR, Keogh JWL 2014, Int J Sports Sci Coach
#   9(5):1127-1143, doi:10.1260/1747-9541.9.5.1127 — farmer's walk vs
#   unloaded walk: higher stride rate, shorter stride length.
# - Stastny P, Lehnert M, Zaatar A, Svoboda Z, Xaverova Z, Pietraszewski P
#   2015, J Hum Kinet 45:157-165, doi:10.1515/hukin-2015-0016 — gluteus
#   medius 26-47% MVIC (group means) in the farmer's walk.
# - Ellestad SH, Holcomb TP, Swiergol AM, Holmstrup ME, Dicus JR 2024, Int J
#   Exerc Sci 17(1):480-490, doi:10.70252/NWUE9985, PMC11042841 — 18 adults, about 50 kg split over two dumbbells
#   (farmer's) or 25 kg in one hand (suitcase), EMG in %MVIC. The farmer's
#   carry raised rectus abdominis, external oblique, longissimus and
#   multifidus over the same load held still, but the external oblique stayed
#   at 11-14% MVIC and the longissimus at 14-16. The suitcase carry raised the
#   longissimus and multifidus on both sides, and rectus abdominis and
#   external oblique only on the loaded side; on the side away from the load
#   the external oblique reached 33% MVIC and the longissimus 29.
# - Bordelon NM, Wasserberger KW, Cassidy MM, Oliver GD 2021, J Strength Cond
#   Res 35(Suppl 1):S114-S119, doi:10.1519/JSC.0000000000003880 — one-hand
#   suitcase, rack and overhead carries: upper and lower trapezius, latissimus
#   dorsi and serratus anterior measured (no deltoids); most muscles rose with
#   load; in the suitcase carry the gluteus medius and external oblique
#   opposite the load were more active.
# - Neumann DA, Cook TM 1985, Phys Ther 65(3):305-311,
#   doi:10.1093/ptj/65.3.305 — a hand load carried on the opposite side
#   raises gluteus medius EMG of the stance hip most.
# - Taylor J, Reed M 2020, Increase hip and trunk stability with loaded
#   carries for injury prevention, rehabilitation, and performance, NSCA
#   Coach 7(3):50-54 — loaded carries: upright torso, slow controlled
#   walking, no side bend in one-sided carries.
# - ACE Exercise Library: Shrug (barbell) — shoulder-width overhand grip,
#   raise the shoulders straight up to the ears, do not roll them; Standing
#   Shrug (dumbbells) — neutral grip at the thighs, no shoulder rotation or
#   elbow bend, erect torso, head and neck in line.
# - StrengthLog: Barbell Shrug and Dumbbell Shrug (straight up and down,
#   arms straight and passive, short pause at the top, forearm flexors
#   secondary); Farmers Walk (primary: forearm flexors, obliques, glutes,
#   trapezius; keep the body in a straight line, no excessive forward lean).
# - ACE Exercise Library: Suitcase Carry — one dumbbell at the side, back
#   straight; it does not address the free arm. Motra, Dumbbell Suitcase
#   Carry (exercise guide): extend the free arm for balance if needed.
# - BarBend, Dewar M, Overhead Carry (updated 22 Nov 2024): muscles worked
#   listed as scapular stabilisers, then shoulders, then abdominals and
#   obliques; elbows locked, wrists not buckled back, arms vertical, reach up
#   into the weight, ribs not flared, small steps.
#
# Evidence is thin for: the six shrug variations against each other (one
# activation set for all), the forearms in carries (no EMG; ranked by the
# grip demand), the deltoids in an overhead carry (not measured; ranked below
# the scapular upward rotators), and the suitcase carry's free arm (no study;
# the copy frames holding it out as a crutch to outgrow, not an error).

from common_191_240 import *

# ---------------------------------------------------------------- shrug cues

RANGE_SHRUG = ("Range of Motion",
               "Each rep lifts the shoulders as high as they will go.",
               "The shrug is among the exercises that work the upper trapezius hardest, but its range is short; dropping the shoulders fully and lifting them right up to the ears, with a brief hold, gives the traps all of it.",
               "Short, bouncing reps where the shoulders barely rise.",
               "Let the shoulders drop fully, lift them straight up toward the ears, hold for a moment, then lower under control.")
PATH_SHRUG = ("Shoulder Path",
              "The shoulders move straight up and straight down.",
              "The upper trapezius and levator scapulae lift the shoulder blades vertically; rolling the shoulders adds no lift and drags them forward under the load.",
              "Rolling the shoulders forward and round in a circle at the top.",
              "Lift the tips of the shoulders straight toward the ears, then lower them along the same line.")
PATH_SHRUG_BACK = ("Shoulder Path",
                   "The shoulders move straight up and straight down.",
                   "The upper trapezius and levator scapulae lift the shoulder blades vertically; with the bar behind, rolling the shoulders back at the top adds no lift and only pinches them together under the load.",
                   "Rolling the shoulders up and back in a circle at the top.",
                   "Lift the tips of the shoulders straight toward the ears, then lower them along the same line.")
ARMS_SHRUG = ("Arm Position",
              "The arms are straps that hold the weight.",
              "Straight, relaxed arms keep the lift in the shoulder girdle; bending the elbows turns the top of the rep into a curl or an upright row and hands it to the biceps and deltoids.",
              "Bending the elbows to pull the weight up.",
              "Keep the elbows straight and the arms relaxed; only the shoulders move.")
HEAD_SHRUG = ("Head and Neck",
              "The head stays level and still.",
              "A neutral neck lets the traps lift the shoulders without the head joining in; poking the chin forward does not raise the shoulders any higher.",
              "Poking the chin forward as the shoulders rise.",
              "Keep the chin level and the back of the neck long, eyes straight ahead, for the whole set.")

SHRUG_ACT = [("Upper Trapezius", P, HI, 0.88), ("Levator Scapulae", S, MOD, 0.52),
             ("Forearm Flexors", S, MOD, 0.45), ("Middle Trapezius", S, LOW, 0.30)]

# Front-on shrugs: two labels share the top row, the rest sit beside their
# joints' height so no leader crosses the body.
FRONT = {"head": (0.14, "leading"), "range": (0.14, "trailing"), "path": (0.32, "leading")}


def shrug_glows(name):
    return [glow(name, ["attachment_TrapeziusUpper_L", "attachment_TrapeziusUpper_R",
                        "support_TrapeziusUpper_L", "support_TrapeziusUpper_R"], A, 0.55, rx=0.11, ry=0.05),
            glow(name, ["forearm_L", "hand_L"], SOFT, 0.30, rx=0.05, ry=0.07),
            glow(name, ["forearm_R", "hand_R"], SOFT, 0.30, rx=0.05, ry=0.07)]


def shrug(name, var, extra, comp, stabilisers, overrides, range_joint="attachment_TrapeziusUpper_L",
          path_joint="attachment_TrapeziusUpper_R", arms_joint="forearm_L", path=PATH_SHRUG):
    """extra = (cueID, label, joint, cue): the variation's own cue."""
    cid, label, joint, cue = extra
    ex(name=name, var=var,
       annotations=[
           ("range", "Shoulders up to the ears", range_joint),
           ("path", "Straight up, no rolling", path_joint),
           ("head", "Chin level, neck long", "head"),
           ("arms", "Arms straight", arms_joint),
           (cid, label, joint),
       ],
       cues={"range": RANGE_SHRUG, "path": path, "head": HEAD_SHRUG, "arms": ARMS_SHRUG, cid: cue},
       activation=SHRUG_ACT, stabilisers=stabilisers, comparison=comp,
       glows=shrug_glows(name), overrides=overrides)


ROLLING = ("ROLLING THE SHOULDERS", "Straight up, straight down", "Shoulders roll in a circle",
           "Lifting straight up to the ears keeps the load on the upper traps for the whole rep.",
           "Rolling adds no lift for the traps and drags the shoulders forward under the load.")

shrug("Dumbbell Shrug", "dumbbellShrug",
      ("grip", "Dumbbells at your sides", "hand_R",
       ("Dumbbell Position",
        "The dumbbells hang at your sides, palms in.",
        "Beside the thighs, the weights hang straight down from the shoulders, so they pull against the traps instead of dragging the shoulders forward.",
        "Letting the dumbbells drift in front of the thighs.",
        "Hold the dumbbells at your sides with a neutral grip, palms facing the thighs, wrists straight.")),
      ROLLING, ["core", "erector spinae", "rhomboids"],
      dict(FRONT, arms=(0.32, "trailing"), grip=(0.55, "leading")))

shrug("Barbell Shrug", "barbellShrug",
      ("grip", "Bar against the thighs", "hand_R",
       ("Grip and Bar Position",
        "Overhand, about shoulder-width, the bar against the thighs.",
        "A shoulder-width grip lets the arms hang straight down, and a bar kept brushing the thighs pulls the shoulders forward less than one hanging away from them.",
        "Letting the bar hang away from the thighs, pulling the shoulders round.",
        "Grip overhand at about shoulder-width, thumbs around the bar, and keep it brushing the thighs.")),
      ("SHORT, BOUNCING REPS", "Full lift, brief hold", "Shoulders barely rise",
       "Dropping fully and lifting to the ears, with a brief hold, works the traps through their whole range.",
       "Heavy, bouncing half reps barely move the bar and leave most of the traps' range untrained."),
      ["core", "erector spinae", "rhomboids"],
      dict(FRONT, arms=(0.32, "trailing"), grip=(0.68, "leading")))

shrug("Smith Machine Shrug", "smithMachineShrug",
      ("bar", "Stand close to the bar", "hand_R",
       ("Bar Position",
        "Stand close enough that the bar brushes the thighs.",
        "The Smith bar runs on fixed rails, so where you stand decides where that path sits against your body; standing back makes the body lean to the bar and pulls the shoulders forward instead of up.",
        "Standing too far back, so the body leans forward to the bar.",
        "Step in until the bar touches the thighs, stand tall, and keep that spot so the bar slides straight up and down.")),
      ("LEANING INTO THE BAR", "Bar on the thighs, torso tall", "Standing back, leaning in",
       "Standing close lets the bar run straight up the rails with the body upright.",
       "Standing back makes the body lean to the bar, so the shoulders are pulled forward instead of straight up."),
      ["core", "erector spinae", "rhomboids"],
      dict(FRONT, arms=(0.32, "trailing"), bar=(0.58, "leading")))

shrug("Cable Shrug", "cableShrug",
      ("stance", "Centred, knees soft", "patella_R",
       ("Stance",
        "Stand centred between the pulleys, feet hip-width.",
        "The two low cables pull down and slightly out; a centred, hip-width stance with soft knees keeps them pulling evenly, so the body stays still and the traps do the lifting.",
        "Standing with the feet together and the knees locked, rocking with the cables.",
        "Stand midway between the stacks, feet hip-width, knees soft, torso still.")),
      ("PULLING WITH THE ARMS", "Arms straight, shoulders lift", "Elbows bend to pull it up",
       "With straight arms, the traps lift the handles through the whole shrug.",
       "Bending the elbows hands the top of the rep to the biceps and deltoids and shortens the traps' work."),
      ["core", "latissimus dorsi", "rhomboids"],
      dict(FRONT, arms=(0.32, "trailing"), stance=(0.68, "leading")))

shrug("Trap Bar Shrug", "trapBarShrug",
      ("posture", "Stand tall, no lean back", "spine",
       ("Posture",
        "The body stays tall and still; only the shoulders move.",
        "The trap bar puts the handles beside the body and takes a heavy load well; standing tall with soft knees keeps that load hanging from the shoulders, while leaning back borrows momentum and loads the lower back.",
        "Leaning back and rocking the hips forward to heave the bar up.",
        "Stand tall in the centre of the frame, brace, and keep the hips and torso still as the shoulders rise.")),
      ("LEANING BACK", "Tall and still, shoulders lift", "Body leans back to heave",
       "Standing tall and still makes the traps lift the heavy bar on their own.",
       "Leaning back and rocking the hips throws the bar up with momentum and loads the lower back instead of the traps."),
      ["core", "erector spinae", "rhomboids"],
      dict(FRONT, arms=(0.32, "trailing"), posture=(0.60, "leading")),
      arms_joint="forearm_L")

# Seen from behind-left: the lifter's left side is on the left of the frame,
# so the left-side joints take the left column.
shrug("Behind-the-Back Barbell Shrug", "behindTheBackBarbellShrug",
      ("bar", "Bar against the legs", "hand_R",
       ("Bar Position",
        "The bar hangs behind you, against the backs of the thighs.",
        "Behind the body, the bar keeps the arms hanging slightly back, so it cannot pull the shoulders forward; it just slides up the backs of the legs.",
        "Letting the bar drift away from the backs of the legs.",
        "Grip overhand at about shoulder-width behind you and keep the bar brushing the backs of the thighs as it rises.")),
      ("ROLLING THE SHOULDERS", "Straight up, straight down", "Shoulders roll back",
       "Lifting straight up to the ears keeps the load on the upper traps for the whole rep.",
       "Rolling the shoulders back at the top adds no lift for the traps and only pinches the shoulder blades together under the bar."),
      ["core", "erector spinae", "rhomboids"],
      {"head": (0.14, "trailing"), "range": (0.14, "leading"), "path": (0.24, "trailing"),
       "arms": (0.32, "leading"), "bar": (0.68, "trailing")},
      path=PATH_SHRUG_BACK)

# ---------------------------------------------------------------- carry cues

STEPS_CARRY = ("Steps",
               "Short, controlled steps.",
               "Loaded walking is done with shorter strides than normal walking; short, controlled steps keep the weights steady and the pelvis supported on each leg.",
               "Long, reaching strides that let the body sway.",
               "Take short, even steps at a slow, steady pace for the whole set time.")

ex(name="Farmer's Carry", var="farmersCarry",
   annotations=[
       ("head", "Eyes ahead, chin level", "head"),
       ("shoulders", "Shoulders back, no slump", "attachment_TrapeziusUpper_L"),
       ("posture", "Walk tall, brace", "spine"),
       ("grip", "Crush the handles", "hand_L"),
       ("steps", "Short, controlled steps", "foot_R"),
   ],
   cues={
       "head": ("Head Position",
                "Eyes ahead, chin level.",
                "Looking ahead keeps the neck and upper back in line with the braced trunk; looking down pulls the head and shoulders forward over the weights.",
                "Looking down at the feet, the head and upper back dropping.",
                "Fix the eyes on a point ahead at head height and keep the chin level."),
       "shoulders": ("Shoulder Position",
                     "The shoulders stay back and level under the load.",
                     "Holding the shoulders set makes the traps and upper back resist the weights pulling down and forward, instead of letting the upper back round.",
                     "Shoulders dragged forward and down, the upper back rounding.",
                     "Draw the shoulders gently back, chest up, and hold them there without shrugging."),
       "posture": ("Posture",
                   "Walk tall, stacked from head to hips.",
                   "An upright, braced trunk lets the core and hips carry the load with every step; leaning forward over the weights hands it to the lower back.",
                   "Leaning forward over the weights as the set goes on.",
                   "Brace the abs, stand tall with the ribs over the hips, and keep that height for the whole set."),
       "grip": ("Grip",
                "Crush the handles, weights still by your sides.",
                "The whole load hangs from the hands for the full set, so grip is often the limit on a heavy carry; a hard grip in the middle of each handle keeps the dumbbells level and quiet, so they do not swing into the legs.",
                "A loose grip that lets the dumbbells swing forward and back.",
                "Grip each handle in the middle, squeeze hard, and let the dumbbells hang still beside the thighs, palms in."),
       "steps": STEPS_CARRY,
   },
   activation=[("Forearm Flexors", P, HI, 0.80), ("Upper Trapezius", S, MOD, 0.45),
               ("Gluteus Medius", S, MOD, 0.40), ("Obliques", S, LOW, 0.35)],
   stabilisers=["erector spinae", "quadratus lumborum", "rectus abdominis"],
   comparison=("SHOULDERS ROUNDED", "Tall, shoulders back", "Shoulders slump forward",
               "Standing tall with the shoulders set lets the grip, traps and core hold the weights still.",
               "Letting the weights drag the shoulders forward rounds the upper back and turns the carry into a slump."),
   glows=[glow("Farmer's Carry", ["forearm_L", "hand_L"], A, 0.55, rx=0.05, ry=0.07),
          glow("Farmer's Carry", ["forearm_R", "hand_R"], A, 0.55, rx=0.05, ry=0.07),
          # The upper trapezius, the next muscle in the panel.
          glow("Farmer's Carry", ["attachment_TrapeziusUpper_L", "attachment_TrapeziusUpper_R",
                                  "support_TrapeziusUpper_L", "support_TrapeziusUpper_R"], SOFT, 0.30, rx=0.10, ry=0.04)],
   overrides={"head": (0.14, "leading"), "shoulders": (0.14, "trailing"), "posture": (0.32, "leading"),
              "grip": (0.58, "trailing"), "steps": (0.86, "leading")})

ex(name="Suitcase Carry", var="suitcaseCarry",
   annotations=[
       ("level", "Shoulders level", "attachment_TrapeziusUpper_L"),
       ("twist", "Chest square, no twist", "chest"),
       ("grip", "Crush the handle", "hand_L"),
       ("free", "Free arm relaxed", "hand_R"),
       ("steps", "Short, even steps", "foot_R"),
   ],
   cues={
       "level": ("Shoulders Level",
                 "The loaded side stays as tall as the free side.",
                 "A one-sided load tries to bend the trunk toward it; the obliques and quadratus lumborum on the other side resist that, which is what the suitcase carry trains.",
                 "Leaning toward the dumbbell, the loaded shoulder dropping.",
                 "Stand tall with both shoulders level and the ribs stacked over the hips, as if there were no weight."),
       "twist": ("Trunk Rotation",
                 "The chest faces straight ahead.",
                 "A one-sided load pulls the trunk sideways and can also turn it as you walk; keeping the chest square makes the core resist rotation as well as the side bend.",
                 "Twisting the shoulders with each step, one shoulder swinging forward.",
                 "Brace and keep both shoulders facing forward, the hips square under them."),
       "grip": ("Grip",
                "The dumbbell hangs still beside the thigh.",
                "A firm grip keeps the dumbbell from swinging, so the trunk resists a steady sideways pull rather than a moving one.",
                "Letting the dumbbell swing forward and back with each step.",
                "Grip the handle in the middle, squeeze hard, and keep the dumbbell beside the thigh, palm in."),
       "free": ("Free Arm",
                "The free arm hangs relaxed at the side.",
                "Held out wide, the free arm shifts a little weight to the free side and eases the side bend the trunk is meant to resist; it can help balance at first, but once you can stay tall let it hang or swing.",
                "Holding the free arm out wide as a counterweight.",
                "Let the free arm hang or swing naturally by the side, hand relaxed."),
       "steps": ("Steps",
                 "Short, even steps.",
                 "Short, even steps keep the load steady and the pelvis level; with the weight on one side, the hip muscles of the other leg work hardest to hold the pelvis up each time that leg takes the weight.",
                 "Long, reaching strides that let the body sway toward the weight.",
                 "Take short, even steps at a steady pace for the set time, then switch hands."),
   },
   activation=[("Obliques", P, MOD, 0.60), ("Forearm Flexors", S, MOD, 0.55),
               ("Erector Spinae", S, MOD, 0.50), ("Gluteus Medius", S, MOD, 0.42)],
   stabilisers=["quadratus lumborum", "rectus abdominis", "upper trapezius"],
   comparison=("LEANING TOWARD THE WEIGHT", "Shoulders level, trunk tall", "Trunk bends to the dumbbell",
               "Standing tall against the one-sided load makes the obliques and hip muscles on the other side do the work.",
               "Leaning toward the weight lets it bend the spine sideways and skips the work the carry is for."),
   # The obliques that work hardest are on the side away from the dumbbell
   # (the lifter's right, the left of the frame): the flank from the lower
   # ribs to the hip, with that side's gluteus medius just below it.
   glows=[glow("Suitcase Carry", ["support_PectoralisMajor_Abdominal_R", "thigh_R"], A, 0.55, rx=0.05, ry=0.07),
          glow("Suitcase Carry", ["forearm_L", "hand_L"], SOFT, 0.30, rx=0.05, ry=0.07),
          glow("Suitcase Carry", ["thigh_R"], SOFT, 0.30, rx=0.05, ry=0.05, dx=-0.03, dy=0.02)],
   overrides={"level": (0.14, "trailing"), "twist": (0.32, "leading"), "grip": (0.62, "trailing"),
              "free": (0.62, "leading"), "steps": (0.86, "leading")})

ex(name="Overhead Carry", var="overheadCarry",
   annotations=[
       ("wrist", "Wrists stacked", "hand_L"),
       ("lockout", "Arms locked by the ears", "forearm_L"),
       ("shoulders", "Reach up into the weight", "attachment_TrapeziusUpper_R"),
       ("ribs", "Ribs down, no arch", "spine"),
       ("steps", "Short, steady steps", "foot_L"),
   ],
   cues={
       "wrist": ("Wrists",
                 "Wrists straight, knuckles to the ceiling.",
                 "A stacked wrist sends the weight straight down the forearm; a wrist bent back puts the load on the joint and lets the dumbbell tip.",
                 "Wrists bent back under the dumbbells.",
                 "Grip the handles hard and keep each wrist straight, the dumbbell over the forearm."),
       "lockout": ("Arm Position",
                   "Arms locked straight, upper arms beside the ears.",
                   "Straight arms stacked over the shoulders and hips keep each dumbbell almost directly above the shoulder joint, so the shoulder muscles hold it on a very short lever; weights drifting forward act on a longer lever and are harder to hold.",
                   "The arms drifting forward, the dumbbells ending up in front of the head.",
                   "Lock the elbows and keep the dumbbells directly over the shoulders, upper arms beside the ears."),
       "shoulders": ("Shoulder Position",
                     "Reach up into the weights.",
                     "Pushing up actively keeps the shoulder blades rotated up under the arms, the job of the trapezius and serratus anterior, and gives the weights a stable base.",
                     "Letting the shoulders sink so the weights sag toward the head.",
                     "Push the dumbbells toward the ceiling as if trying to get taller, and keep reaching for the whole set."),
       "ribs": ("Trunk Position",
                "Ribs down, glutes tight, no arch.",
                "With weight overhead, arching the lower back and flaring the ribs is the easy way to hold the arms up; bracing keeps the spine neutral and the work in the shoulders and core.",
                "Lower back arching and ribs flaring to hold the arms up.",
                "Brace the abs, squeeze the glutes and keep the ribs pulled down over the hips as you walk."),
       "steps": ("Steps",
                 "Short, steady steps.",
                 "Short, controlled steps keep the dumbbells still overhead; long strides make the body bob and sway, and the shoulders and trunk have to chase the weights.",
                 "Long, bouncing strides that make the weights sway.",
                 "Take short, even steps at a steady pace for the whole set time, the weights quiet overhead."),
   },
   activation=[("Upper Trapezius", P, MOD, 0.60), ("Serratus Anterior", S, MOD, 0.55),
               ("Lateral Deltoid", S, MOD, 0.45), ("Obliques", S, LOW, 0.36)],
   stabilisers=["anterior deltoid", "rotator cuff", "triceps", "rectus abdominis"],
   comparison=("RIBS FLARED, BACK ARCHED", "Ribs down, arms by the ears", "Lower back arches",
               "Bracing with the ribs down keeps the spine neutral while the shoulders hold the weights overhead.",
               "Arching the lower back leans the body away from the weights and puts the load on the spine instead of the shoulders and core."),
   # Upper trapezius, between the neck and both shoulders.
   glows=[glow("Overhead Carry", ["attachment_TrapeziusUpper_L", "attachment_TrapeziusUpper_R",
                                  "support_TrapeziusUpper_L", "support_TrapeziusUpper_R"], A, 0.55, rx=0.08, ry=0.05),
          # Serratus anterior: the side of the rib cage under the near (left)
          # arm; the chest faces the left of the frame, so no nudge right
          # (that lands on the lats).
          glow("Overhead Carry", ["deltoid_arc_clavicle_2_L", "support_LatissimusDorsi_L"], SOFT, 0.30, rx=0.04, ry=0.06),
          glow("Overhead Carry", ["spine"], SOFT, 0.30, rx=0.08, ry=0.07)],
   overrides={"wrist": (0.14, "trailing"), "lockout": (0.32, "trailing"), "shoulders": (0.44, "leading"),
              "ribs": (0.55, "leading"), "steps": (0.86, "trailing")})

# ---------------------------------------------------------------- setup

SETUP["Dumbbell Shrug"] = [
    "Stand tall with your feet hip-width, knees soft.",
    "Hold a dumbbell at each side, palms facing your thighs.",
    "Let your arms hang straight and your shoulders drop.",
]
SETUP["Barbell Shrug"] = [
    "Stand with your feet hip-width, the bar in front of your thighs.",
    "Grip it overhand at about shoulder-width, thumbs around.",
    "Stand tall, arms straight, and let your shoulders drop.",
]
SETUP["Smith Machine Shrug"] = [
    "Set the bar on the hooks at about mid-thigh height.",
    "Stand close, feet hip-width, the bar against your thighs.",
    "Grip it overhand at about shoulder-width.",
    "Twist the bar off the hooks and stand tall, arms straight.",
]
SETUP["Cable Shrug"] = [
    "Set both pulleys at the bottom and take a handle in each hand.",
    "Stand centred between the stacks, feet hip-width, knees soft.",
    "Let the handles hang by your thighs, palms in, arms straight.",
]
SETUP["Trap Bar Shrug"] = [
    "Stand in the centre of the trap bar, feet hip-width.",
    "Grip the middle of the side handles, palms in.",
    "Lift the bar with a flat back and stand tall, arms straight.",
]
SETUP["Behind-the-Back Barbell Shrug"] = [
    "Set the bar in a rack just below hip height.",
    "Stand with your back to it and grip it overhand at about shoulder-width.",
    "Lift it off and step forward, the bar against the backs of your thighs.",
    "Stand tall, arms straight, and let your shoulders drop.",
]
SETUP["Farmer's Carry"] = [
    "Stand between two dumbbells, feet hip-width.",
    "Squat down with a flat back and grip them in the middle, palms in.",
    "Stand tall, shoulders back, arms straight at your sides.",
    "Walk with short, steady steps for the set time.",
]
SETUP["Suitcase Carry"] = [
    "Stand beside one dumbbell, feet hip-width.",
    "Squat down with a flat back and grip it in one hand, palm in.",
    "Stand tall with the shoulders level, free arm relaxed.",
    "Walk with short, even steps for the set time; switch hands next set.",
]
SETUP["Overhead Carry"] = [
    "Clean a dumbbell to each shoulder and press them overhead.",
    "Lock the elbows, palms forward, upper arms beside your ears.",
    "Brace with the ribs down and the glutes tight.",
    "Walk with short, steady steps for the set time.",
]

NAMES = ["Dumbbell Shrug", "Barbell Shrug", "Smith Machine Shrug", "Cable Shrug", "Trap Bar Shrug",
         "Behind-the-Back Barbell Shrug", "Farmer's Carry", "Suitcase Carry", "Overhead Carry"]

if __name__ == "__main__":
    probs = validate(["Dumbbell Shrug", "Barbell Shrug", "Smith Machine Shrug", "Cable Shrug", "Trap Bar Shrug", "Behind-the-Back Barbell Shrug", "Farmer's Carry", "Suitcase Carry", "Overhead Carry"]); print("\n".join(probs) or "OK")
