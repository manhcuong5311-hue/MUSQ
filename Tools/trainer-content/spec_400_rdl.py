# Trainer content for the 351-400 folder (2026-09-30), family "rdl": the
# builder's 356-362 and 393 hinges (Single-Leg, Barbell Single-Leg and
# Dumbbell Single-Leg Romanian Deadlifts, B-Stance, Smith Machine, Cable and
# Kettlebell Romanian Deadlifts, Dumbbell Deadlift). Same format as spec.py,
# on top of common_1_50.py; spec_400.py collects it with the other families.
# notes_400_rdl.md maps each claim in the copy to the sources below and
# records the model facts it relies on.
#
# What each model shows, from the briefs (SCRATCH/briefs and briefs_legs:
# joint angles and positions every 0.5 s), the trainer stills at 0/1/2/3/5 s
# (SCRATCH/shots/view), the highlight tiers (SCRATCH/tiers27.json),
# joints.json and the builder's notes (DANH_SACH_356_400.md, REFERENCES.md,
# FIX_/SOURCES_356_360 and _361_362). The rig's frame: Y up, the lifter faces
# +z, their left is +x. Every model does two identical reps in 7.96 s: ~0.6 s
# still at the top, ~1.0 s down, ~0.5 s held at the bottom (deepest 1.75 s;
# the Dumbbell Deadlift 1.2-2.7 s, deepest 2.54 s), ~1.0 s up.
# Tiers (all eight): biceps femoris, semitendinosus, semimembranosus and the
# gluteus maximus, medius and minimus bright = PRIMARY; the erector spinae
# dim = SECONDARY; nothing else is painted.
# - Single-Leg Romanian Deadlift (356, yaw -1.3: side-on from the lifter's
#   left, facing screen-left): bodyweight. The LEFT leg stands and works for
#   both reps, its knee held at 160° (a soft 20° bend) all clip, the foot flat
#   and still. The RIGHT leg is the free leg: at the top it rests just behind
#   (ankle 27 cm behind the standing ankle, toes lightly down, knee 156°); as
#   the trunk tips from 0° to 72° it rises behind, knee nearly straight (175°),
#   in line with the trunk (right hip 180°: trunk and free thigh one line),
#   ending 18° below horizontal with the ankle 0.63 m up and ~1.1 m behind the
#   standing ankle, the toes pointing at the floor. Standing hip 171° to 79°.
#   The pelvis goes 28 cm back and 5 cm down; no sideways tilt at any point
#   (0°), the free foot straight behind its hip. Both arms hang straight down
#   from the shoulders (elbows 175°), palms facing in, the hands ~0.49 m up
#   at the bottom (about knee height), ~25 cm ahead of the standing ankle.
# - Barbell Single-Leg RDL (357, same framing): the same legs, trunk and
#   timing. A loaded barbell in both hands, overhand (palms back), hands
#   0.57 m apart (just outside the thighs), elbows 162°. The bar starts at
#   0.84 m (upper thighs) ~16 cm ahead of the standing ankle and ends at
#   0.43 m, just below the knee, ~6 cm ahead of it (over the front of the
#   foot); it stays level (no tilt) all clip. The plates sweep u 0.15-0.56,
#   v 0.45-0.68 on screen.
# - Dumbbell Single-Leg RDL (358, same framing): the same legs and trunk; a
#   dumbbell in each hand, palms facing in, the arms ~16° out from the sides
#   so the dumbbells hang ~15 cm outside each shoulder, 0.75 m apart: the
#   left one ~29 cm outside the standing ankle, the right one on the free
#   leg's side. Front to back they stay over the standing foot, 6-10 cm
#   ahead of its ankle, and travel straight down from 0.84 m to 0.44 m
#   (just below the knee); the hands 9 cm ahead of the shoulders at the top,
#   13 cm behind them at the bottom.
# - B-Stance RDL (359, yaw -1.3, zoom 0.897): the LEFT (front) foot flat and
#   working, knee held at 162°; the RIGHT foot is the kickstand, fixed all
#   clip: its ankle 20 cm behind and 29 cm to the side of the front ankle
#   (hip-width), heel up on the ball of the foot (foot pitch 56°), its toes
#   about level with the front heel; the back knee bends from 130° to 113° as
#   the hips go back. Trunk 0° to 62°, front hip 172° to 93°, pelvis 24 cm
#   back. Two dumbbells, palms in, ~15 cm outside the shoulders (0.71-0.73 m
#   apart; the left one ~26 cm outside the front ankle, the right one by the
#   kickstand side), 6-10 cm ahead of the front ankle, straight down from
#   0.84 m to 0.54 m (about knee height).
# - Smith Machine RDL (360, yaw -1.0, zoom 0.915): both feet flat, ankles
#   0.28 m apart (hip-width), toes forward. Knees 162° at the top, 150° at the
#   bottom; trunk 0° to 70°, hips 165° to 79°, pelvis 15 cm back. A vertical
#   Smith (the builder's model after the Hammer Strength HSSMV) with a
#   carriage on two upright rails, hooks, and orange safety stops low on
#   the machine (0.20-0.28 m, well under the bar's lowest point); the bar
#   centre stays 10 cm ahead of the ankle joints (over mid-foot, the toe
#   tips ~20 cm ahead) and runs straight down from 0.86 m to 0.46 m (knee
#   height); overhand grip, hands 0.56 m apart, elbows 162°. The plates
#   sweep v 0.40-0.75 at both edges of the frame.
# - Cable Romanian Deadlift (361, yaw -1.0): facing a low-pulley stack; the
#   lower pulley 0.18 m up and ~0.9 m ahead of the ankles, a straight bar on a
#   swivel at the cable's end held overhand, hands 0.54 m apart, elbows 158°.
#   The cable draws the arms forward at the top (hands 25 cm ahead of the
#   shoulders, ~28° from vertical, the bar ~18 cm clear of the thighs); at
#   the bottom they hang about vertical (~5° forward). The hands run from
#   0.97 m, 24 cm ahead of the ankles, to 0.54 m (just above the knees),
#   30 cm ahead; the cable pulls forward and down, ~41° from vertical at the
#   top and ~60° at the bottom; the stack drops ~28 cm as the bar nears the
#   pulley at the bottom and never rests. Feet hip-width (0.28 m), knees
#   162° to 154°,
#   trunk 0° to 68°, hips 171° to 84°, pelvis 23 cm back.
# - Kettlebell RDL (362, yaw -0.8): one kettlebell, both hands overhand on its
#   handle (0.2 m apart), elbows 156-159°, the bell hanging centred between
#   the legs in front of them: its centre from 0.78 m (in front of the
#   thighs, clear of them) to 0.35 m (between mid-shin and knee), 23-27 cm
#   ahead of the ankles all clip, over the toe tips (~21 cm ahead); at the
#   bottom the shins are vertical and the bell's back face ~11 cm in front
#   of them. The arms angle ~30° forward at the top (hands 26 cm ahead of
#   the shoulders) and hang vertical at the bottom. Legs and trunk as the
#   cable RDL (knees 162° to 154°, trunk 68°, hips 84°). Slow and even, no
#   swing.
# - Dumbbell Deadlift (393, yaw -0.8): a dumbbell in each hand at the sides,
#   palms facing in, 0.68 m apart (outside the feet), handles pointing
#   forward. Stands tall at the top (knees 170°, hips 174°), then the hips
#   and knees bend together: knees to 59-67°, hips to 40-48°, thighs about
#   parallel, the pelvis dropping 47 cm (0.91 to 0.44 m) and 24 cm back, the
#   trunk 56° forward at most, knees over the feet (toes out ~7°). The
#   dumbbells go straight down beside the feet to ~8 cm off the floor (their
#   16 cm heads never touch it) beside the front of the feet, then back up.
#   This knee bend and floor-to-hip range is what separates it from an RDL.
#
# Sources (each checked; notes_400_rdl.md maps the claims to them):
# - Diamant W, Geisler S, Havers T, Knicker A 2021, Int J Exerc Sci
#   14(1):187-201, doi 10.70252/mvfy4610 — 15 trained men, barbell single-leg
#   deadlift vs conventional deadlift at 8RM (62.7 vs 112.8 kg): concentric
#   gluteus medius 77.6 vs 59.3 %, biceps femoris 82.1 vs 74.2 %, gluteus
#   maximus 91.7 vs 85.7 % (n.s.); erector spinae lower in the single-leg lift
#   (left 67.4 vs 82.7 %, right 66.2) yet about 0.8 of its biceps femoris;
#   combined phases GMAX 73.4 vs 65.6, GMED 68.1 vs 47.8, BF 68.9 vs 60.2 %.
#   Method: the standing knee bent only as far as needed to keep the back
#   straight; the free leg extended behind; trunk about parallel to the floor.
# - DiStefano LJ, Blackburn JT, Marshall SW, Padua DA 2009, J Orthop Sports
#   Phys Ther 39(7):532-540, doi 10.2519/jospt.2009.2796 — bodyweight
#   single-limb deadlift: gluteus maximus 59 %, gluteus medius 59 % MVIC
#   (abstract values; the full text, and so the exact technique, could not be
#   opened).
# - Mo RCY, Ngai DCW, Ng CCM, Sin KHS, Luk JTC, Ho IMK 2023, Front Physiol
#   14:1264604, doi 10.3389/fphys.2023.1264604 — 12 resistance-trained men,
#   single-leg RDL at maximal speed with one dumbbell (20-32 kg) in one hand
#   or a flywheel, the standing knee held at ~15° of bend throughout, trunk
#   about parallel at the bottom: very high superior gluteus maximus and
#   biceps femoris (concentric BF 113-115 % with the dumbbell), erector
#   75-94 %, gluteus medius 63-80 %; the dumbbell in the hand opposite the
#   standing leg raised superior gluteus maximus (concentric) and gluteus
#   medius, erector and superior gluteus maximus (eccentric).
# - Sørensen B, Aagaard P, Malchow-Møller L, Zebis MK, Bencke J 2021, Int J
#   Sports Phys Ther 16(3):704-714, doi 10.26603/001c.24150 — 23 female elite
#   handball players, explosive reps with the knees near straight: barbell
#   RDL on two legs (8RM) vs one leg (half that load), hamstring activity
#   68.0 vs 63.6 %, both semitendinosus-dominant.
# - Lee S, Schultz J, Timgren J, Staelgraeve K, Miller M, Liu Y 2018, J Exerc
#   Sci Fit 16(3):87-93, doi 10.1016/j.jesf.2018.08.001 — conventional vs
#   Romanian deadlift at 70% RDL 1RM: rectus femoris 58.6 vs 25.3 %peak,
#   gluteus maximus 51.5 vs 46.9 %peak, greater knee torque in the
#   conventional lift.
# - McAllister MJ et al. 2014, J Strength Cond Res 28(6):1573-1580, doi
#   10.1519/JSC.0000000000000302 — leg curl, good morning, glute-ham raise,
#   RDL at 85% 1RM: hamstring activity highest in the RDL and glute-ham raise.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2022, Int J Environ
#   Res Public Health 19(3):1903, doi 10.3390/ijerph19031903 — 10 competitive
#   bodybuilders at 80% 1RM, barbell from the floor, spine kept straight:
#   RDL, RDL on a 15 cm step and stiff-leg deadlift; the step raised gluteus
#   maximus, semitendinosus and longissimus excitation in the ascending
#   phase only, the biceps femoris no different.
# - Zebis MK et al. 2013, Br J Sports Med 47(18):1192-1198, doi
#   10.1136/bjsports-2011-090281 — 16 female elite handball and soccer
#   players: kettlebell swing and RDL both semitendinosus-biased at 73-115 %
#   MVC.
# - Swinton PA, Stewart A, Agouris I, Keogh JW, Lloyd R 2011, J Strength Cond
#   Res 25(7):2000-2009, doi 10.1519/JSC.0b013e3181e73f87 — hexagonal (load
#   at the sides) vs straight bar: lower peak moments at the lumbar spine,
#   hip and ankle, a higher one at the knee.
# - Camara KD, Coburn JW, Dunnick DD, Brown LE, Galpin AJ, Costa PB 2016,
#   J Strength Cond Res 30(5):1183-1188, doi 10.1519/JSC.0000000000001352 —
#   hex bar: more vastus lateralis; straight bar: more biceps femoris
#   (concentric) and erector spinae (eccentric).
# - Schwanbeck S, Chilibeck PD, Binsted G 2009, J Strength Cond Res
#   23(9):2588-2591, doi 10.1519/JSC.0b013e3181b1b181 — six participants,
#   free-weight vs Smith squat at 8RM: biceps femoris 26 % higher in the free
#   squat (the Smith about a fifth lower); all muscles together 43 % higher
#   free. A squat, so used only for the direction of the Smith ranks.
# - Dicus JR et al. 2023, Int J Exerc Sci 16(4):12-22, doi 10.70252/zaoj6139
#   — RDL vs cable pull-through vs reverse hyperextension at 50% 1RM: the
#   pulley-redirected pull-through drew less longissimus, multifidus, biceps
#   femoris and semitendinosus than the RDL. A different cable hinge (facing
#   away, cable between the legs): used only to keep the Cable RDL's rows a
#   step under the free-weight RDL's, not in the copy.
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337 — hip, pelvis and trunk control and knee valgus
#   (review).
# - McCall P 2025, ACE, The ACE Do It Better Series: The Romanian Deadlift
#   (acefitness.org) — slight knee bend; hinge from the hips; spine long, chin
#   tucked, eyes to the floor; rounding one of the most common errors; knees
#   bending as in a squat another; T. Gentilcore: the farther the bar from
#   the body, the greater the stress on the lower back; lower until tension
#   behind the thighs, about knee height or mid-shin.
# - ACE Exercise Library, Single-Arm Single-Leg Romanian Deadlift — standing
#   knee slightly bent, back straight, the free leg straightened with the
#   toes pointed, the weight lowered in front of the standing leg.
# - PureGym, Single-Leg Deadlifts; B-Stance Deadlifts; Dumbbell Deadlift
#   (puregym.com) — single-leg: soft knee, hips back, the free leg straight
#   out behind, not to the side; lower to between just below the knee and
#   mid-shin; start light or with no weight. B-stance: a small step back, the
#   back toes in line with or just behind the working heel, heel up on the
#   ball of the foot, most of the weight on the working foot, the back foot
#   just for balance; weights close to the working leg (the model's hang
#   wider, so the copy does not say it); do not push the hips too far
#   forward. Dumbbell deadlift: neutral grip, dumbbells by the sides, lower
#   toward the floor (no need to touch it if the spine would round), hips and
#   knees extend together, squeeze the glutes at lockout.
# - REP Fitness (Borchert), The Smith Machine Deadlift Guide — Smith RDL: bar
#   just below hip height, feet hip-width, toes forward, bar close to the
#   legs, safety stops all the way at the bottom, lower to about mid-shin;
#   J. Flicker: the fixed path makes it easier to focus on the posterior
#   chain with less demand on balance or coordination. REP Fitness,
#   Kettlebell Deadlift — the kettlebell RDL starts standing, never touches
#   the floor between reps, slight knee bend, bell close, to about mid-shin.
# - StrengthLog, Smith Machine Romanian Deadlift — primary hamstrings, glutes
#   and lower back (the model paints the lower back dim, so it is secondary
#   here).
# No EMG study was found for the B-stance, Smith, cable or kettlebell RDL by
# name, or for a dumbbell deadlift with the dumbbells at the sides; their rows
# are ranked from the closest studied lifts (see the notes). The Cable RDL's
# set-up advice (stand back from the pulley) is the model's own geometry and
# mechanics, not a cited source.

from common_1_50 import *

NAMES = ["Single-Leg Romanian Deadlift", "Barbell Single-Leg Romanian Deadlift", "Dumbbell Single-Leg Romanian Deadlift",
         "B-Stance Romanian Deadlift", "Smith Machine Romanian Deadlift", "Cable Romanian Deadlift",
         "Kettlebell Romanian Deadlift", "Dumbbell Deadlift"]


def one_leg_glows(name):
    """The standing (left) leg's hamstrings and glute, behind the thigh (the
    lifter faces screen-left, so behind is to the right), then the lower back."""
    return [glow(name, ["pelvis", "patella_L"], A, 0.55, rx=0.10, ry=0.08, dx=0.02),
            glow(name, ["spine", "pelvis"], SOFT, 0.30, rx=0.07, ry=0.05)]


def two_leg_glows(name):
    """Both legs' hamstrings and glutes behind the thighs, then the lower back."""
    return [glow(name, ["pelvis", "patella_L", "patella_R"], A, 0.55, rx=0.13, ry=0.09, dx=0.03),
            glow(name, ["spine", "chest"], SOFT, 0.30, rx=0.08, ry=0.06)]


# ---------------------------------------------------------------- shared cues

SL_HINGE = ("Hinge and Reach",
            "The hips push back as the free leg reaches behind, the trunk and leg tipping together like a seesaw.",
            "Pushing the hips back is what stretches the standing leg's hamstrings and glute under load, and the free leg reaching behind balances the chest so the hips can travel back without tipping you forward. In the single-leg deadlifts studied, done this way with the trunk close to level at the bottom, the glutes and hamstrings of the standing leg worked hard.",
            "Reaching the hands for the floor while the hips stay over the foot and the free leg hangs down.",
            "Push the free heel back toward the wall behind you as the hips go back, and stop when the trunk and free leg are close to level or the hips will not travel further.")
SL_SQUARE = ("Level Hips",
             "Both hip bones face the floor and the free leg's toes point straight down.",
             "Standing on one leg, the side muscles of the standing hip, the gluteus medius above all, have to hold the pelvis level; a barbell single-leg deadlift drew clearly more gluteus medius than a two-leg deadlift. When the free hip rolls open, the pelvis turns instead of staying square and that control is lost.",
             "The free hip rolling open toward the ceiling, the free leg swinging out to the side with its toes turned out.",
             "Keep the belt buckle pointing at the floor and the free toes pointing down, and let the leg rise straight behind you, not out to the side.")
SL_KNEE = ("Standing Knee",
           "The left, standing knee keeps the same soft bend from top to bottom; the right leg is the free leg.",
           "A small, fixed bend lets the hips travel back so the hamstrings take the stretch. Bending the knee more as you go down turns the hinge into a one-leg squat and hands work to the thigh muscles, as bent-knee deadlifts do. In a single-leg RDL study the standing knee was held at about 15 degrees of bend throughout.",
           "The standing knee bending further as the chest lowers, the hips sinking toward the floor.",
           "Unlock the knee a little before you start, hold that angle and push the hips back, not down.")
BACK = ("Spine Position",
        "The back stays long from the hips to the head, the neck in line and the eyes on the floor.",
        "A neutral spine keeps the bend at the hips, so the hamstrings and glutes lengthen and do the lifting. Letting the back round is one of the most common RDL errors, often once the hips have run out of hinge and the hands keep reaching.",
        "Rounding the upper back and dropping the head to get the weight lower.",
        "Brace before each rep, keep the chest open and the chin lightly tucked, and let the trunk tip only as far as the hips can hinge.")


def hinge(extra, mistake, correct):
    """Two-leg RDLs: the hip hinge, with a set-up specific line, mistake and
    correction (the library Romanian Deadlift and Dumbbell RDL already use the
    closing-a-door image, so these do not)."""
    return ("Hip Hinge",
            "The hips push back while the knees stay soft, and the weight lowers only as the hips go back.",
            "Sending the hips back stretches the hamstrings and glutes under load, which is where an RDL does its work; in comparisons of hamstring exercises the RDL drew some of the highest hamstring activity. " + extra,
            mistake,
            correct)


# ---------------------------------------------------------------- single-leg

# All three single-leg models share the legs and trunk (side-on at yaw -1.3,
# facing screen-left). The pills keep out of three moving zones: the arms
# and load in front of the standing leg (left of centre, v 0.45-0.68), the
# head's arc (u 0.2-0.4, v 0.25-0.47) and the free leg's sweep (right of
# centre, v 0.5-0.72). So the labels take the top row on both sides, the
# second row on the right, a short label on the left at 0.72 (clear of the
# hands, which reach down to v 0.66, and left of the standing foot) and the
# bottom row, under both feet.
SL_OVERRIDES = {"back": (0.14, "leading"), "hinge": (0.32, "trailing"), "square": (0.86, "trailing"),
                "knee": (0.77, "leading"), "balance": (0.86, "leading")}

ex(name="Single-Leg Romanian Deadlift", var="singleLegRomanianDeadlift",
   overrides=SL_OVERRIDES,
   annotations=[
       ("back", "Long, flat back", "chest"),
       ("hinge", "Hips back, leg back", "pelvis"),
       ("square", "Free toes point down", "foot_R"),
       ("knee", "Soft knee", "patella_L"),
       ("balance", "Weight mid-foot", "foot_L"),
   ],
   # Bodyweight: the hinge and back cues get their own why / mistake here,
   # since the shared ones speak of the loaded lifts studied and a weight.
   cues={
       "hinge": SL_HINGE[:2] + (
           "Pushing the hips back is what stretches the standing leg's hamstrings and glute, and the free leg reaching behind balances the chest so the hips can travel back without tipping you forward. Even with no weight in the hands, a single-leg deadlift worked the standing hip's gluteus maximus and medius moderately in one study.",) + SL_HINGE[3:],
       "square": SL_SQUARE,
       "knee": SL_KNEE,
       "back": BACK[:3] + ("Rounding the upper back and dropping the head to reach lower.",) + BACK[4:],
       "balance": ("Balance",
                   "The whole standing foot stays planted, the weight over its middle.",
                   "One foot is the only base, so the hips moving back has to be matched by the chest and free leg moving the other way to keep the weight over the middle of the foot. Once you rock onto the toes or the heel, the hips stop hinging and the rep turns into a scramble for balance.",
                   "Rocking forward onto the toes, the standing heel lifting, as the chest lowers.",
                   "Grip the floor with the heel, big toe and little toe, move slowly, and master this unloaded version before holding weights."),
   },
   # Bodyweight: DiStefano 2009's bodyweight single-limb deadlift drew 59 %
   # MVIC from both the gluteus maximus and medius, so both MODERATE and
   # level; the hamstrings, not measured there, just above them as the
   # hinge's other prime mover and the library word (loaded, Diamant 2021
   # had BF a little under GMAX, Mo 2023 BF well above the inferior GMAX).
   # The erector spinae holds only the trunk's own weight: LOW 0.34, under
   # the loaded single-leg lifts' 0.50 (an estimate).
   activation=[("Hamstrings", P, MOD, 0.62), ("Gluteus Maximus", P, MOD, 0.60),
               ("Gluteus Medius", P, MOD, 0.60), ("Erector Spinae", S, LOW, 0.34)],
   stabilisers=["adductors", "obliques", "calves", "core"],
   comparison=("HIPS OPEN UP", "Hips square, toes down", "Free hip rolls open",
               "With both hip bones facing the floor, the standing hip holds the pelvis level and the free leg rises straight behind as a counterweight.",
               "When the free hip rolls open, the pelvis turns and the leg swings out to the side, so the hip stops doing the steadying this lift is for."),
   glows=one_leg_glows("Single-Leg Romanian Deadlift"))

SETUP["Single-Leg Romanian Deadlift"] = [
    "Stand on your left foot, the whole foot flat and the knee slightly bent, as the model does.",
    "Rest the right toes lightly on the floor just behind you.",
    "Let both arms hang straight down, palms facing in.",
    "Brace your trunk, hinge for all your reps, then switch to the right leg.",
]

ex(name="Barbell Single-Leg Romanian Deadlift", var="barbellSingleLegRomanianDeadlift",
   overrides={"barpath": (0.14, "leading"), "back": (0.14, "trailing"), "hinge": (0.32, "trailing"),
              "knee": (0.77, "leading"), "square": (0.86, "trailing")},
   annotations=[
       ("barpath", "Bar close to the leg", "hand_L"),
       ("back", "Flat back", "chest"),
       ("hinge", "Hips back, leg back", "pelvis"),
       ("knee", "Soft knee", "patella_L"),
       ("square", "Free toes point down", "foot_R"),
   ],
   cues={
       "barpath": ("Bar Path",
                   "The bar slides down close to the standing leg, to just below the knee.",
                   "The bar has to stay over the standing foot, your only base, and the further it hangs from the body the more it pulls on the lower back. Guides put the bottom between just below the knee and mid-shin, wherever the hips stop travelling back; the model stops just below the knee.",
                   "Letting the bar swing out in front as the chest lowers, pulling you onto the toes.",
                   "Hold the bar overhand about shoulder-width, keep the arms long and the lats tight, and slide it down close to the standing leg."),
       "back": BACK,
       "hinge": SL_HINGE,
       "knee": SL_KNEE,
       "square": ("Level Hips",
                  "The bar stays level, both hip bones face the floor and the free toes point down.",
                  SL_SQUARE[2] + " A barbell shows it at once: when the free hip opens, the bar tips.",
                  "The free hip rolling open toward the ceiling, the bar tipping with it and the free leg swinging out to the side.",
                  "Keep the bar level and the belt buckle pointing at the floor, and let the free leg rise straight behind you, toes down."),
   },
   # Diamant 2021 is this lift (barbell single-leg deadlift, 8RM): gluteus
   # maximus a little above the biceps femoris (concentric 91.7 vs 82.1 %,
   # combined 73.4 vs 68.9 %; not tested against each other) and Mo 2023's
   # dumbbell version the other way (BF 113-115 % over inferior GMAX 78-97
   # %), so the two level-pegged, the hamstrings first as the library word
   # has them. Gluteus medius close behind (77.6 / 68.1 %) and well above a
   # two-leg deadlift's. Sørensen 2021: at half the two-leg load, hamstring
   # activity stayed about as high (63.6 vs 68.0 %), so the hamstrings sit
   # just under the library RDL's 0.88 and the gluteus maximus above its
   # 0.72. The erector spinae was lower than in a conventional deadlift
   # (67.4 vs 82.7 %) but still ~0.8 of the biceps femoris (Diamant; Mo
   # 75-94 % with one dumbbell): secondary as painted, MODERATE 0.50, above
   # the library RDL's 0.42.
   activation=[("Hamstrings", P, HI, 0.86), ("Gluteus Maximus", P, HI, 0.84),
               ("Gluteus Medius", P, HI, 0.74), ("Erector Spinae", S, MOD, 0.50)],
   stabilisers=["adductors", "obliques", "forearms", "core"],
   comparison=("BAR DRIFTS FORWARD", "Bar close, over the foot", "Bar swings out in front",
               "Sliding the bar down close to the standing leg keeps the load over the one foot you balance on and the lever on the lower back short.",
               "A bar that swings out pulls you onto the toes and lengthens the lever on the lower back, so balance goes before the hamstrings are worked."),
   glows=one_leg_glows("Barbell Single-Leg Romanian Deadlift"))

SETUP["Barbell Single-Leg Romanian Deadlift"] = [
    "Take a light barbell from a rack at hip height, overhand, hands about shoulder-width.",
    "Step back and stand on your left foot, knee slightly bent, as the model does.",
    "Rest the right toes lightly on the floor just behind you, the bar against your thighs.",
    "Brace, hinge for all your reps, then switch to the right leg.",
]

ex(name="Dumbbell Single-Leg Romanian Deadlift", var="dumbbellSingleLegRomanianDeadlift",
   # The dumbbell label points at the far (right) hand: its long pill ends at
   # u 0.435, so a leader to the near hand ran through the chest dot (within
   # 0.004 at 1 s and 3 s) and read as a second leader to the back label.
   overrides={"path": (0.14, "leading"), "back": (0.14, "trailing"), "hinge": (0.32, "trailing"),
              "knee": (0.77, "leading"), "square": (0.86, "trailing")},
   annotations=[
       ("path", "Dumbbells hang straight", "hand_R"),
       ("back", "Flat back", "chest"),
       ("hinge", "Hips back, leg back", "pelvis"),
       ("knee", "Soft knee", "patella_L"),
       ("square", "Free toes point down", "foot_R"),
   ],
   cues={
       "path": ("Dumbbell Path",
                "The dumbbells hang from long arms, one each side just outside the shoulders, palms facing in, and travel straight down.",
                "Dumbbells that travel straight down stay over the standing foot, front to back, and keep the lever on the lower back short. With one in each hand the load is balanced side to side, so the hips, not the arms, keep you level.",
                "Letting the dumbbells drift forward toward the toes as the chest lowers.",
                "Keep the arms long and the shoulders back, and lower the dumbbells straight down to just below the knee."),
       "back": BACK,
       "hinge": SL_HINGE,
       "knee": SL_KNEE,
       "square": ("Level Hips",
                  "Both hip bones face the floor, the dumbbells hang level and the free toes point down.",
                  SL_SQUARE[2] + " With a dumbbell in each hand it shows: as the free hip opens, that side's dumbbell rides higher.",
                  "The free hip rolling open toward the ceiling, the free-side dumbbell riding up with it and the free leg swinging out to the side.",
                  "Keep both dumbbells at the same height and the belt buckle pointing at the floor, and let the free leg rise straight behind you, toes down."),
   },
   # Mo 2023 (one dumbbell, 20-32 kg): superior gluteus maximus and biceps
   # femoris very high, gluteus medius 63-80 % concentric, the erector
   # 75-94 %. Ranked with the barbell version (Diamant 2021), hamstrings
   # first: BF 113-115 % over the inferior gluteus maximus there. Gluteus
   # medius as the barbell's 0.74: two dumbbells are a symmetric load like
   # the bar (Mo's one-hand ipsilateral 62.9 and contralateral 79.8 % bracket
   # Diamant's barbell 77.6 %). Erector MODERATE 0.50 as the barbell's.
   activation=[("Hamstrings", P, HI, 0.86), ("Gluteus Maximus", P, HI, 0.84),
               ("Gluteus Medius", P, HI, 0.74), ("Erector Spinae", S, MOD, 0.50)],
   stabilisers=["adductors", "obliques", "forearms", "core"],
   comparison=("ONE SIDE RIDES UP", "Hips square, dumbbells level", "Free hip and dumbbell ride up",
               "With both hip bones facing the floor, the standing hip holds the pelvis level and the two dumbbells hang at the same height.",
               "When the free hip rolls open, the pelvis turns, the free-side dumbbell rides up and the leg swings out, so the hip stops doing the steadying this lift is for."),
   glows=one_leg_glows("Dumbbell Single-Leg Romanian Deadlift"))

SETUP["Dumbbell Single-Leg Romanian Deadlift"] = [
    "Hold a dumbbell in each hand at your sides, palms facing in.",
    "Stand on your left foot, knee slightly bent, as the model does.",
    "Rest the right toes lightly on the floor just behind you.",
    "Brace, hinge for all your reps, then switch to the right leg.",
]

# ---------------------------------------------------------------- B-stance

ex(name="B-Stance Romanian Deadlift", var="bStanceRomanianDeadlift",
   # Side-on (yaw -1.3) and closer than the single-leg lifts: the head rises
   # to v 0.13 at the top, the dumbbells sweep u 0.33-0.76 from v 0.44 to
   # 0.67, the glutes reach u 0.86 at the bottom and the back heel sits at
   # u 0.72-0.75, v 0.76-0.80. So: the back label top left, the hinge label
   # right on the second row (starting right of the back), the dumbbell
   # label short on the left at the third row (ends at u 0.29, clear of the
   # dumbbells at 0.33), the front-foot label bottom left and a nine-letter
   # kickstand label bottom right, starting right of the back heel. The
   # dumbbell label points at the right hand (the dumbbell further left on
   # screen, u 0.46): at the top the left hand hangs on the hip dot, and its
   # leader crossed the hinge label's there.
   overrides={"back": (0.14, "leading"), "hinge": (0.32, "trailing"), "path": (0.50, "leading"),
              "front": (0.86, "leading"), "stance": (0.86, "trailing")},
   annotations=[
       ("back", "Flat back", "chest"),
       ("hinge", "Hips back", "pelvis"),
       ("path", "Hang straight", "hand_R"),
       ("front", "Weight on front foot", "foot_L"),
       ("stance", "Kickstand", "foot_R"),
   ],
   cues={
       "stance": ("Kickstand Foot",
                  "The right foot sits a short step back, its toes level with the left heel and its heel up.",
                  "With the back foot this close and only its toes down, it steadies you side to side while the front leg does the work; stepped far back, it turns the lift into a split-stance RDL.",
                  "Stepping the back foot far behind like a lunge.",
                  "Take a small step back so the back toes are in line with or just behind the front heel, then lift that heel and stand on the ball of the foot."),
       "front": ("Front Leg Works",
                 "The left, front leg carries most of the weight; the right foot is only for balance.",
                 "Loading the front leg is what makes this a near single-leg hinge, while the kickstand spares you most of the balancing of a true single-leg RDL. Leaning into the back foot hands work to the other leg and undoes the point of the stance.",
                 "The back heel dropping and the back leg pushing, so the weight spreads across both feet.",
                 "Keep the front foot flat and pressing into the floor, the back heel up and the back foot light enough to lift at any moment."),
       "hinge": ("Hip Hinge",
                 "The hips push back over the front heel while the front knee stays soft.",
                 "Sending the hips back stretches the front leg's hamstrings and glute under load. Sinking straight down instead bends both knees and turns the rep into a split squat.",
                 "Bending both knees and sinking straight down, the chest staying upright.",
                 "Keep the front knee soft and fixed, push the hips back as far as they will go, and let the dumbbells lower as a result."),
       "path": ("Dumbbell Path",
                "The dumbbells hang from long arms, one on each side, and travel straight down to about the knees.",
                "Weights that travel straight down stay over the front foot and keep the lever on the lower back short. In the model they reach about knee height, where the front hip has hinged as far as it goes.",
                "Letting the dumbbells drift out in front of the knee as the chest lowers.",
                "Keep the arms long and the shoulders back, and lower the dumbbells straight down to about the knee or a little below."),
       "back": BACK,
   },
   # No study of the B-stance RDL: ranked between the two-leg dumbbell RDL
   # (library 0.84 / 0.70 / erector 0.52) and the dumbbell single-leg RDL
   # (0.86 / 0.84 / medius 0.74 / erector 0.50), since the back foot takes a
   # little of the load and most of the side-to-side balance. Hamstrings first
   # as in both; the gluteus maximus above the two-leg RDL's for the front
   # leg's larger share (Diamant 2021 on one leg). Gluteus medius 0.60, an
   # estimate between a two-leg lift (Diamant's conventional deadlift drew
   # 59.3 against the single-leg 77.6 %, about 0.57 on this scale) and the
   # single-leg 0.74, nearer the two-leg end because the kickstand takes the
   # side-to-side balance. Erector 0.50, as the single-leg lifts and just
   # under the two-leg dumbbell RDL; secondary as painted.
   activation=[("Hamstrings", P, HI, 0.84), ("Gluteus Maximus", P, HI, 0.76),
               ("Gluteus Medius", P, MOD, 0.60), ("Erector Spinae", S, MOD, 0.50)],
   stabilisers=["adductors", "obliques", "forearms", "core"],
   comparison=("BACK FOOT TAKES OVER", "Front foot works, back foot light", "Weight spread over both feet",
               "With the back foot just steadying you, the front leg's hamstrings and glute do nearly all the lifting.",
               "When the back heel drops and that leg pushes, the load spreads over both legs and the rep becomes an ordinary split-stance RDL."),
   glows=one_leg_glows("B-Stance Romanian Deadlift"))

SETUP["B-Stance Romanian Deadlift"] = [
    "Hold a dumbbell in each hand at your sides, palms facing in.",
    "Stand on your left foot and step the right foot back so its toes are level with your left heel, as the model does.",
    "Lift the right heel and keep most of your weight on the left foot, knee slightly bent.",
    "Brace, do all your reps, then switch the feet.",
]

# ---------------------------------------------------------------- two-leg

ex(name="Smith Machine Romanian Deadlift", var="smithMachineRomanianDeadlift",
   # Three-quarter from the front-left (yaw -1.0): the plates sweep both
   # edges of the frame from v 0.40 to 0.75 and the head's arc runs from
   # (0.65, 0.18) at the top to (0.33, 0.39) at the bottom, where the top of
   # the head reaches v 0.326 at u 0.27 and spans u 0.236-0.316 by v 0.334
   # (the 2 s still). So the labels keep to the top row (short on the right,
   # clear of the head), the shortest label on the left of the second row
   # (To knees ends at u 0.215, left of the head at the bottom; Bar to
   # knees there ended at 0.274 and clipped it) and the bottom row, under
   # the plates, beside the feet. The back label takes the top left: on the
   # second row its leader to the chest crossed the range label's leader to
   # the right hand at every moment.
   overrides={"back": (0.14, "leading"), "hinge": (0.14, "trailing"), "range": (0.32, "leading"),
              "stance": (0.86, "leading"), "knee": (0.86, "trailing")},
   annotations=[
       ("back", "Flat back", "chest"),
       ("hinge", "Hips back", "pelvis"),
       ("range", "To knees", "hand_R"),
       ("stance", "Feet under the bar", "foot_R"),
       ("knee", "Soft knees", "patella_L"),
   ],
   cues={
       "stance": ("Foot Position",
                  "Stand so the bar hangs over the middle of your feet, close to the thighs.",
                  "The rails hold the bar to a straight up-and-down path, so where you stand decides where the load sits. With the bar over mid-foot it can stay close to the legs all the way down while the hips travel back behind it.",
                  "Standing too far back, so the bar hangs out over the toes and the arms reach forward to it.",
                  "Set the bar just below hip height, stand under it with the feet hip-width and toes forward, and line it up over the middle of your feet before you unhook it."),
       "hinge": hinge("The track does the balancing, so the whole rep can go into that hinge.",
                      "Bending the knees and sinking under the bar, which turns the rep into a squat.",
                      "Push the hips straight back and let the bar slide down its track close to the thighs, then drive the hips forward to stand."),
       "range": ("Range of Motion",
                 "Lower until the bar reaches about the knees and the hamstrings are stretched.",
                 "The rep ends when the hips stop travelling back; any lower comes from the back rounding, not the hips. Standing on a step for extra range raised glute and inner-hamstring activity in bodybuilders who kept the spine straight, so extra range helps as a longer hinge, not as rounding.",
                 "Chasing the floor by rounding the back and sinking once the stretch runs out.",
                 "Lower until you feel a firm stretch behind the thighs, usually around the knees, then drive the hips forward. Set the safety stops just below that point."),
       "knee": ("Knee Angle",
                "The knees stay soft and bend only slightly as the hips go back.",
                "The hamstrings cross the knee as well as the hip, so locked knees put them on stretch sooner and the hips run out of hinge earlier; a soft bend lets the hips travel further back before the stretch stops them.",
                "Locking the knees straight at the bottom of the rep.",
                "Unlock the knees before you unhook the bar and keep them soft, letting them bend only a little as the hips travel back."),
       "back": BACK,
   },
   # No study of the Smith RDL. The free-weight RDL's ranks (library 0.88 /
   # 0.72 / erector 0.42) a step lower: the free-weight squat drew 26 % more
   # biceps femoris than the Smith squat (Schwanbeck 2009, n=6; a squat,
   # used only for direction), and the fixed path takes over the balance
   # (REP Fitness). StrengthLog lists hamstrings, glutes and lower back as
   # primary; the model paints the erector dim, so it is secondary here.
   activation=[("Hamstrings", P, HI, 0.84), ("Gluteus Maximus", P, MOD, 0.68),
               ("Erector Spinae", S, LOW, 0.38)],
   stabilisers=["forearms", "lats", "core", "adductors"],
   # The comparison takes the Smith's own mistake, where you stand under a
   # bar that cannot move; the library Romanian Deadlift already has the
   # turns-into-a-squat comparison.
   comparison=("STANDING TOO FAR BACK", "Bar over mid-foot", "Bar out over the toes",
               "Standing so the bar runs over the middle of the feet lets it stay close to the legs all the way down while the hips travel back behind it.",
               "Standing back from a bar the rails hold in place puts it out over the toes, so the arms reach forward and the lower back holds the load on a longer lever."),
   glows=two_leg_glows("Smith Machine Romanian Deadlift"))

SETUP["Smith Machine Romanian Deadlift"] = [
    "Set the bar on the hooks just below hip height and the safety stops below the lowest point of your rep.",
    "Stand under the bar, feet hip-width, so it hangs over the middle of your feet.",
    "Grip it overhand just outside your thighs and stand tall with the knees soft.",
    "Brace and twist the bar off the hooks.",
]

ex(name="Cable Romanian Deadlift", var="cableRomanianDeadlift",
   # Three-quarter from the front-left (yaw -1.0), the machine's base and low
   # pulley in the bottom-left corner and the cable running from the bar
   # down to it, so no label goes low on the left. The lockout and hinge
   # labels on the right, above and beside the back (lockout on top: its
   # joint, the spine, sits above and left of the pelvis, so the other way
   # round the two leaders crossed at every moment); the arms label short on
   # the left at the third row (ends at u 0.23, left of the bar); the knee
   # and distance labels on the right at the fourth and bottom rows, right
   # of the thighs and feet.
   overrides={"lockout": (0.14, "trailing"), "hinge": (0.32, "trailing"), "arms": (0.50, "leading"),
              "knee": (0.68, "trailing"), "stance": (0.86, "trailing")},
   annotations=[
       ("hinge", "Hips back", "pelvis"),
       ("lockout", "Stand tall", "spine"),
       ("arms", "Arms long", "hand_R"),
       ("knee", "Soft knees", "patella_L"),
       ("stance", "Stand back", "foot_L"),
   ],
   cues={
       "stance": ("Distance",
                  "Stand far enough back that the weight stack stays lifted at the bottom of every rep.",
                  "The bar comes closer to the low pulley as you hinge, so the stack sinks toward its rest at the bottom, right where the hamstrings are stretched. Standing back keeps the load on there; the model stands about a metre from the pulley.",
                  "Standing too close to the pulley, so the stack touches down as you hinge and the hamstrings lose the load at the stretch.",
                  "Hold the bar, then walk back until the stack stays clear of its rest with the bar at your knees."),
       "hinge": hinge("The cable pulls toward the machine as well as down, so the hips also have to hold you back against it.",
                      "Bending the knees and sinking the hips, which turns the rep into a squat and slackens the stretch.",
                      "Push the hips back and sit back against the cable's pull as the chest lowers, then drive the hips forward to stand."),
       "arms": ("Arms",
                "The arms stay long and the lats hold the bar in while the cable draws it toward the machine.",
                "The cable pulls forward as well as down, more so the further you hinge. Holding the bar in with the lats keeps that pull on the hips; if the arms drift out, the shoulders round forward and the upper back takes the strain.",
                "Letting the cable drag the arms out toward the machine, the shoulders rounding with them.",
                "Keep the elbows almost straight and the shoulders pulled back and down, and think of pressing the bar toward your thighs as you lower it."),
       "knee": ("Knee Angle",
                "The knees stay soft and nearly still, bending only a little as the hips go back.",
                "The hamstrings cross the knee as well as the hip: with the knees locked they reach full stretch sooner and the hips stop short, while a soft bend lets the hips sit further back against the cable.",
                "Locking the knees straight at the bottom, where the cable pulls hardest toward the machine.",
                "Unlock the knees before the first rep and keep that soft bend, letting it grow only slightly at the bottom."),
       "lockout": ("Lockout",
                   "Finish tall with the hips straight under the shoulders and the glutes squeezed.",
                   "At the top the cable still pulls you toward the machine, and leaning back to counter it bends the lower back instead of finishing the hip. The rep is complete when the hips are straight.",
                   "Leaning back past upright at the top, the hips pushed forward ahead of the shoulders.",
                   "Drive the hips forward until you are standing straight, squeeze the glutes and stop there, ribs down."),
   },
   # No study of the cable RDL. The free-weight RDL's ranks a step lower:
   # stack loads are lighter and the pull is redirected; the one cable hinge
   # studied, the pull-through (a different set-up), drew less hamstring and
   # erector activity than the RDL (Dicus 2023). Primary rows as lit.
   activation=[("Hamstrings", P, HI, 0.80), ("Gluteus Maximus", P, MOD, 0.66),
               ("Erector Spinae", S, LOW, 0.36)],
   stabilisers=["lats", "forearms", "core", "adductors"],
   comparison=("LEANING BACK AT THE TOP", "Hips straight, stand tall", "Leans back against the cable",
               "Finishing with the hips straight under the shoulders ends the rep on the glutes while the cable keeps pulling forward.",
               "Leaning back to fight the cable bends the lower back at the top instead of finishing the hips."),
   glows=two_leg_glows("Cable Romanian Deadlift"))

SETUP["Cable Romanian Deadlift"] = [
    "Set the pulley at its lowest point and clip on a straight bar.",
    "Face the machine and take the bar overhand, hands just outside your thighs.",
    "Walk back about a metre from the pulley, feet hip-width, until the stack lifts clear.",
    "Stand tall with the knees soft, shoulders back, and brace.",
]

ex(name="Kettlebell Romanian Deadlift", var="kettlebellRomanianDeadlift",
   # Three-quarter from the front-left (yaw -0.8): the bell hangs in front of
   # the thighs and sinks from v 0.52 to 0.80 left of centre, the head's arc
   # runs to (0.36, 0.38) at the bottom and the glutes reach u 0.84. So the
   # back and hinge labels on the right (top rows, clear of the head at the
   # top), the tempo and bell labels short on the left at the third row and
   # at 0.77 (v 0.72; ending at u 0.30 and 0.24, left of the bell) and the
   # knee label bottom right, beside the feet. At the fourth row (v 0.64)
   # the bell label's leader ran level through the right-hand (tempo) dot
   # at the bottom, where both hands sit at v 0.64 on the handle.
   overrides={"back": (0.14, "trailing"), "hinge": (0.32, "trailing"), "tempo": (0.50, "leading"),
              "path": (0.77, "leading"), "knee": (0.86, "trailing")},
   annotations=[
       ("back", "Flat back", "chest"),
       ("hinge", "Hips back", "pelvis"),
       ("tempo", "Slow, no swing", "hand_R"),
       ("path", "Bell close", "hand_L"),
       ("knee", "Soft knees", "patella_L"),
   ],
   cues={
       "hinge": hinge("With one bell hanging in front of the legs, the hips travel back to counterbalance it.",
                      "Bending the knees and sinking the hips toward the bell, the chest rising, which turns the rep into a squat.",
                      "Push the hips back and let the bell hang from long arms as the chest lowers, then drive the hips forward to stand."),
       "tempo": ("Tempo",
                 "Lower the bell under control and stand up smoothly; this is not a swing.",
                 "An RDL starts standing and loads the hamstrings as they lengthen under control, the bell never set down between reps. Snapping the hips so the bell floats forward turns it into a kettlebell swing, a fast, ballistic lift with a different job.",
                 "Snapping the hips through so the bell swings out in front at the top.",
                 "Lower slowly, pause at the stretch, then drive the hips forward to stand and let the bell rise straight up with the body, arms hanging."),
       "path": ("Bell Path",
                "The bell hangs from long arms and travels straight down in front of the legs, never swinging out.",
                "The closer the bell stays to the legs, the shorter the lever on the lower back; the further it hangs from the body, the more the lower back has to hold.",
                "Letting the bell swing out away from the shins as the chest lowers.",
                "Hold the handle overhand with both hands, keep the arms long and the lats tight, and lower the bell straight down to about mid-shin."),
       "knee": ("Knee Angle",
                "The knees stay soft and nearly still, bending only a little as the hips go back.",
                "Straight knees stretch the hamstrings sooner, since they cross the knee as well as the hip, and stop the hips early; a soft bend lets the hips travel further back before the stretch stops them.",
                "Locking the knees straight as the hips go back.",
                "Unlock the knees before the first rep and keep that soft bend, so the bell can hang in front of the shins without the knees pushing into its path."),
       "back": BACK,
   },
   # No study of the kettlebell RDL: the RDL's ranks (library 0.88 / 0.72 /
   # 0.42), the hamstrings and gluteus maximus a step lower for the lighter
   # load one bell allows. Zebis 2013 found the RDL and the kettlebell swing
   # both drew high hamstring activity. The erector spinae kept at the RDL's
   # level: the bell hangs 23-27 cm ahead of the ankles, over the toes,
   # further forward than the library RDL's bar over mid-foot, a longer
   # lever for its weight (an estimate).
   activation=[("Hamstrings", P, HI, 0.82), ("Gluteus Maximus", P, MOD, 0.66),
               ("Erector Spinae", S, MOD, 0.42)],
   stabilisers=["forearms", "lats", "core", "adductors"],
   comparison=("SWINGING THE BELL", "Slow hinge, bell hangs", "Hip snap swings the bell out",
               "Lowering slowly with the bell hanging from long arms keeps the hamstrings loaded as they lengthen.",
               "Snapping the hips to swing the bell turns the rep into a kettlebell swing and throws away the slow stretch this lift is for."),
   glows=two_leg_glows("Kettlebell Romanian Deadlift"))

SETUP["Kettlebell Romanian Deadlift"] = [
    "Stand with your feet hip-width, the kettlebell on the floor between them.",
    "Squat down, grip the handle overhand with both hands and stand up with it.",
    "Let the bell hang in front of your thighs, arms long, knees soft.",
    "Brace and pull the shoulders back before the first rep.",
]

ex(name="Dumbbell Deadlift", var="dumbbellDeadlift",
   # Three-quarter from the front-left (yaw -0.8): the dumbbells sweep the
   # middle of the frame from v 0.46 at the top to v 0.90 at the bottom,
   # the head's arc from (0.56, 0.18) to (0.37, 0.51). The chest, hip and
   # pelvis dots line up on a diagonal from the top left through the deep
   # squat (1-3 s), and the left knee swings to u 0.49 there, so: the back
   # label top left; the knee label short on the left at the third row (ends
   # u 0.230, left of the arm and dumbbell); the hips (pelvis) and lockout
   # (hip) labels on the right, the pelvis one on top so their leaders never
   # cross, the lockout one at 0.26 (v 0.267), where its pill starts 0.013
   # right of the left elbow at the top (at 0.32 it touched it); the dumbbell
   # label bottom right, beside the near dumbbell's lowest point. The old
   # layout (hips second row left, knee second row right) crossed three
   # leaders at every moment of the squat.
   overrides={"back": (0.14, "leading"), "hips": (0.14, "trailing"), "lockout": (0.26, "trailing"),
              "knee": (0.50, "leading"), "path": (0.86, "trailing")},
   annotations=[
       ("back", "Chest up, back flat", "chest"),
       ("lockout", "Stand tall", "thigh_L"),
       ("hips", "Rise together", "pelvis"),
       ("knee", "Over toes", "patella_L"),
       ("path", "At sides", "hand_L"),
   ],
   cues={
       "path": ("Dumbbell Path",
                "The dumbbells hang at your sides, palms facing in, and travel straight down beside the feet.",
                "With the load at your sides rather than in front, it sits closer in line with the hips and knees, as in a trap bar; trap-bar studies found less load on the lower back and hips, more on the knees and more thigh-front work than with a straight bar in front of the legs.",
                "Letting the dumbbells drift forward in front of the knees as you lower them.",
                "Keep the arms long and the dumbbells beside the feet, and lower them straight down until they are just above the floor."),
       "hips": ("Hips and Knees",
                "The hips and knees bend together on the way down and straighten together on the way up.",
                "This is a deadlift, not a Romanian deadlift: the knees bend freely so the dumbbells reach down near the floor with the back still flat, and the thighs share the lift with the hips; bent-knee deadlifts drew more thigh-front and glute activity than the RDL. If the hips rise first, the knees straighten early and the lower back is left to finish the rep.",
                "The hips shooting up out of the bottom while the chest stays low, the knees straightening ahead of the back.",
                "Push the floor away with both feet so the hips and chest rise at the same rate, then drive the hips forward to finish."),
       "back": ("Spine Position",
                "The chest stays up and the back flat from the floor to the top.",
                "A flat back lets the hips and legs do the lifting while the spine simply holds its shape. Rounding to reach the floor puts the load on the lower back instead; the dumbbells need not touch the floor if you cannot get there with a flat back.",
                "The lower back rounding at the bottom as the dumbbells near the floor.",
                "Brace before each rep, keep the chest up and the shoulders back, and only go as low as you can with a flat back."),
       "knee": ("Knee Tracking",
                "The knees bend in line with the feet, never caving inward.",
                "Knees that follow the toes take the load straight through the joint; a knee that caves in often shows the hips losing control of the thighs.",
                "The knees caving in toward each other at the bottom or as you stand.",
                "Keep each knee pointing over the middle toes as you sink and as you drive up."),
       "lockout": ("Lockout",
                   "Stand tall at the top with the hips and knees straight and the glutes squeezed.",
                   "The lift is complete when the hips and knees are straight. Leaning back past that only bends the lower back under the load.",
                   "Leaning back at the top, the hips pushed forward past the shoulders.",
                   "Squeeze the glutes as you stand and stop with the shoulders over the hips, ribs down."),
   },
   # Ranked as the model is lit (hamstrings and glutes bright, erector
   # spinae dim), so the erector sits under both primaries. The library
   # Deadlift (0.76 / 0.66 / erector 0.85) moved for the load at the sides,
   # as with a hex bar: less biceps femoris and erector spinae than a
   # straight bar (Camara 2016) and lower lumbar and hip moments (Swinton
   # 2011), and dumbbells lighter than a barbell. Lee 2018: a bent-knee
   # deadlift drew more gluteus maximus than the RDL. No study of a dumbbell
   # deadlift was found: the numbers are estimates. The library Deadlift
   # and Trap Bar put the erector above the hamstrings; the paint and both
   # hex-bar studies point lower, so 0.54 here. The model's deep knee bend
   # (59-67°) also works the quadriceps hard, but the model does not paint
   # them, so they are left out of the rows and named in the copy.
   activation=[("Gluteus Maximus", P, HI, 0.74), ("Hamstrings", P, MOD, 0.56),
               ("Erector Spinae", S, MOD, 0.54)],
   stabilisers=["adductors", "forearms", "trapezius", "core"],
   comparison=("HIPS SHOOT UP", "Hips and chest rise together", "Hips rise first, chest stays low",
               "Pushing the floor away so the hips and chest rise together lets the legs and hips share the lift from the bottom.",
               "When the hips shoot up first, the knees straighten early and the lower back is left to lift the dumbbells the rest of the way."),
   glows=two_leg_glows("Dumbbell Deadlift"))

SETUP["Dumbbell Deadlift"] = [
    "Stand with your feet about hip-width, toes forward, a dumbbell beside each foot.",
    "Push the hips back, bend the knees and grip the dumbbells with the palms facing in.",
    "Chest up, back flat, shoulders over the dumbbells.",
    "Brace and stand up with them to begin.",
]

if __name__ == "__main__":
    print("\n".join(validate(NAMES) + validate_library(NAMES)) or "OK")
