# Trainer content for the 401-500 folder, third round (445-474, 2026-10-05),
# family: twist. Four rotation exercises from the builder's exports: 462
# Landmine Rotation (Abs/LandmineRotation), 463 Landmine 180
# (Abs/Landmine180), 464 Medicine Ball Russian Twist
# (Abs/MedicineBallRussianTwist) and 465 Weighted Russian Twist
# (Abs/WeightedRussianTwist). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_twist.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, measured on the rigs with Blender's Python + pxr
# (SCRATCH/lab/r3/twist/dump.py writes every joint's world matrix for all 192
# frames, meas.py / feet.py read the turns, angles and foot positions off
# them, meshpts.py the ball's and plate's real mesh extents; the app's Y-up
# space, the lifter facing +z, their left +x), the motion briefs, tiers.txt,
# joints.json and the trainer stills at 0/1/2/3/5 s. Turns are headings of
# the shoulder line (shoulder joints) and the hip line (hip joints) from
# above, from the start of the clip. All four clips are 7.96 s on one body
# (torso, neck to pelvis, 0.59 m standing, 0.57 m reclined).
# - Landmine Rotation: standing facing a landmine whose base (HG_LandmineBase,
#   pivot HG_Pivot) sits on the floor ~1.95 m in front of the heels; the
#   shaft (HG_LandmineShaft) rises to a sleeve (HG_LandmineSleeve) with one
#   plate and collar (HG_Plates) near its end. Both hands are wrapped around
#   the sleeve end, palms facing each other, at ~1.46 m: 5 cm above the
#   shoulder joints and ~49 cm in front of them (about shoulder height), arms
#   long (elbows 144 deg). Ankles 42 cm apart (the shoulder joints 39 cm),
#   toes out ~10 deg, knees 168 deg, trunk 8 deg forward of upright. The bar
#   end sweeps down to the lifter's right at 1.0 s, back through the top at
#   2.0 s, to the left at 3.0 s, back at 4.0 s, and again (2 sweeps a side,
#   about 1 s down and 1 s up, easing for ~0.5 s round each end). At each
#   side the shoulder line has turned 47 deg and the hip line 26 deg (the
#   head turns with the chest); the hands are at 1.03-1.11 m (about waist
#   height; the lumbar joint is at 1.01 m, the hip joints at 0.88 m), ~47 cm
#   in front of that side's hip and ~8 cm outside it in the hips' own frame;
#   elbows 153-159 deg; the trunk leans 13 deg forward and 6 deg toward the
#   bar; both knees bend to 150 deg and the pelvis drops ~2 cm and moves
#   ~7 cm toward the other leg. The balls of both feet stay planted; on the
#   side the bar comes down to, the heel lifts ~5 cm and swings ~5 cm
#   outward (toes turning ~28 deg in), the mirror image of ExRx's cable
#   twist, which raises the heel of the foot on the side the turn comes
#   from, so the copy cues neither heel (see the notes). Paint:
#   external and internal obliques and rectus abdominis bright; anterior and
#   lateral deltoid and gluteus maximus, medius and minimus dim.
# - Landmine 180: the same landmine, grip and setup, but a wider stance
#   (ankles 46 cm apart, toes out ~10 deg), a higher start and a bigger,
#   slower turn: each rep starts with the hands at ~1.64 m, 23 cm above the
#   shoulder joints (arms raised ~120 deg, about eye level), goes down to one
#   side over ~2 s (right 0-4 s, deepest at 2.0 s, easing ~0.5 s there) and
#   back up over ~2 s, then the other side (4-8 s). At the bottom the
#   shoulder line has turned 77 deg and the hip line 42 deg; the hands are at
#   1.03-1.09 m beside that hip (35 cm out to the side in the room, ~41 cm in
#   front of it and ~10 cm outside it in the hips' frame); the arm reaching
#   across bends to 117 deg while the other stays at ~145; the trunk leans
#   10 deg forward and 10 deg toward the bar; knees 143-150 deg; the pelvis
#   drops ~3 cm. The same same-side heel lift as the rotation (~6 cm).
#   Paint as the rotation.
# - Medicine Ball Russian Twist: seated on a mat (HG_Mat), knees bent 63 deg,
#   feet flat on the floor (heels and toes down), ankles 30 cm apart, knees
#   37 cm; the trunk reclined 39 deg behind upright (neck over pelvis, the
#   pelvis rolled back and the back rounded), trunk-to-thigh ~86 deg, held
#   all clip. A medicine ball (HG_MedicineBall, 24 cm across) is held between
#   the palms in front of the chest (elbows 64 deg). The shoulders turn
#   47.5 deg to the right (0.67 s), back (1.33 s), 47.5 deg to the left
#   (2.0 s), back (2.67 s): one twist each way every 2.67 s, three in the
#   clip; the head turns with the chest. At each side the ball is beside the
#   hip, its centre 37 cm out from the midline, its lowest point ~5 cm above
#   the floor, the arms lengthened (elbows 121-142 deg). The pelvis, legs
#   and feet do not move at all. Paint: obliques, rectus abdominis and the
#   hip flexors (Sartorius mesh) bright; lateral deltoid dim.
# - Weighted Russian Twist: the same seat, lean and twist (trunk, head and
#   legs identical; hands within ~3 cm and elbows ~4 cm, the plate wider),
#   with a weight plate (HG_WeightPlate, 28 cm across) held by its rim, one
#   hand on each side; its lowest edge also stops ~5 cm off the floor
#   (elbows 63 deg at the middle, 118-130 deg at the sides). Paint as the
#   medicine-ball twist.
#
# How they differ from the library: Russian Twist (its own older model)
# leans back ~27 deg and turns the shoulders only ~22 deg each way, the ball
# kept at chest height with the elbows fixed, 2 s a side; these two lean
# further, turn about twice as far and take the load down beside each hip
# in ~0.67 s. Cable Wood Chop pulls a handle diagonally from a high pulley,
# stepping side-on; the landmine presses push a landmine with one or two
# arms. The rotation sweeps a landmine from shoulder height to waist height
# on alternate sides at a brisk pace; the 180 starts at eye level and turns
# much further, one slow side at a time.
#
# Sources (abstracts read on Europe PMC, full texts where noted; ExRx on the
# Wayback Machine; details and what each supports are in the notes):
# - ExRx.net (Wayback Machine): Obliques muscle page (Muscles/Obliques,
#   snapshot 2026-02-02) - rotation right uses the left external and right
#   internal oblique, left the reverse; origins on ribs 5-12, the
#   thoracolumbar fascia and iliac crest, insertions on the iliac crest,
#   inguinal ligament, pubis, linea alba and rectus sheath. Rectus Abdominis
#   (2026-05-28) - lumbar flexion. Cable Twist (WeightExercises/Obliques/
#   CBTwist, 2025-08-03) - both arms horizontal and straight, both knees
#   slightly bent, feet wide, the heel of the foot nearest the pulley raised;
#   arguably more hip rotation than spinal rotation, much of the turning
#   force coming from the forward hip, the spine's rotators acting largely
#   as stabilisers; seated
#   twists or those with the hips held still allow more turning through the
#   spine; target obliques, synergists tensor fasciae latae, gluteus medius
#   and minimus, hip adductors, psoas major, quadratus lumborum,
#   iliocostalis; stabilisers include rectus abdominis, erector spinae and
#   the lateral and posterior deltoid. Medicine Ball Russian Twist
#   (Plyometrics/MBRussianTwist, 2025-08-27) - sit with knees and hips bent,
#   recline back slightly balancing on the hips, touch the ball to the floor
#   on each side by turning the torso and reaching the arms to that side;
#   dynamic spinal rotation, static spinal flexion and hip flexion.
# - StrengthLog: Landmine Rotation (strengthlog.com/landmine-rotation/,
#   modified 2025-09-17) - feet slightly wider than shoulder-width, arms
#   straight in front, rotate the hips and torso and lower the bar toward
#   the outside of the hip, alternate in a controlled motion; primary
#   obliques and abs, secondary front deltoids. Core Twist
#   (strengthlog.com/russian-twist/, modified 2026-06-12) - feet on the
#   ground or slightly lifted, a plate, ball or kettlebell held in front of
#   the chest, lean slightly back, twist and bring the weight toward the hip
#   keeping the hips stable; primary obliques and abs.
# - Magnante M 2022 (updated 2024-08-11), Landmine 180, Fitness Volt
#   (fitnessvolt.com/landmine-180/; ACE-certified author) - start with the
#   arms extended, the bar driven back up overhead to the start each rep,
#   lowered to either side with the torso rotating; common mistake:
#   swinging the bar back and forth with little control, do each rep slowly.
#   Its advice to keep the lower body from turning is not followed: the
#   model, StrengthLog and ExRx's cable twist turn the hips.
# - Swie YW, Sakamoto K 2004, Electromyogr Clin Neurophysiol 44(2):111-126,
#   PMID 15061405 - ten men holding standing trunk twists at graded angles:
#   higher activity in the contralateral external and ipsilateral internal
#   oblique, significantly above the untwisted posture only when the twist
#   passed 30 deg.
# - Andersson EA, Grundstrom H, Thorstensson A 2002, Spine 27(6):E152-E160,
#   doi:10.1097/00007632-200203150-00014, PMID 11884920 - fine-wire EMG in
#   seated and standing trunk rotations: the rectus abdominis was little
#   activated in all rotations; the external oblique worked mostly on the
#   side away from the turn.
# - Vinstrup J, Sundstrup E, Brandt M, Jakobsen MD, Calatayud J, Andersen LL
#   2015, Scientifica 2015:403068, doi:10.1155/2015/403068, PMID 26557405
#   (PMC4628648, full text) - 17 untrained men, 10RM standing torso twists
#   with elastic tubing (arms horizontal and extended, feet, legs and hips
#   still) and seated in a machine: rectus abdominis 10 and 16%, external
#   obliques 54 / 47% (elastic) and 77 / 41% (machine), erector spinae
#   24 / 50% (elastic) of MVC EMG; the authors put the standing twist's
#   higher back-muscle activity most likely down to the standing position,
#   adding the elastic set-up's longer lever arm.
# - Andersson EA, Nilsson J, Ma Z, Thorstensson A 1997, Eur J Appl Physiol
#   Occup Physiol 75(2):115-123, doi:10.1007/s004210050135, PMID 9118976 - the hip flexors
#   were highly active only in exercises with hip flexion; the abdominals in
#   both trunk and hip flexion sit-ups.
# No EMG study of a landmine rotation, landmine 180 or loaded Russian twist
# was found (Europe PMC: no abstract mentions a Russian twist; landmine
# studies cover presses, squats and punch throws), so every fraction is a
# judgement call anchored on the library's Cable Wood Chop (obliques 0.78)
# and Russian Twist (obliques 0.76, rectus abdominis 0.52, hip flexors
# 0.38). Activation follows the paint: bright rows primary, dim rows
# secondary; where the dim muscles would overflow the one-line legend they
# are named with the stabilisers (see each entry).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def lit(name, u, v, rx, ry, kind=A, opacity=0.55, anchor=("spine",)):
    """A glow centred on the lit muscles at (u, v), the mean centre of the
    painted pixels in the five trainer stills (SCRATCH/lab/r3/twist/orange.py),
    written as a nudge from the probed `anchor` joints like the other
    families' glows."""
    cu, cv = mean(name, list(anchor))
    return glow(name, list(anchor), kind, opacity, rx, ry, round(u - cu, 3), round(v - cv, 3))


# Both landmines: obliques and rectus abdominis bright, the deltoids and
# glutes dim. No EMG of either lift. Obliques 0.78 as the library's Cable
# Wood Chop (in standing elastic torso twists the external obliques reached
# 47-54% of MVC EMG, Vinstrup 2015; nEMG is not the app's fraction).
# Rectus abdominis PRIMARY because it is painted bright, but at 0.40, the
# lowest moderate value, as the seated calf raises' gastrocnemius: it was
# little activated in all trunk rotations in Andersson 2002 and at 10-16%
# in Vinstrup 2015, and the copy never says it does the turning. Of the
# five dim muscles, the gluteus medius (an ExRx synergist of the standing
# cable twist) and the anterior deltoid (StrengthLog's secondary muscle,
# holding the arms out in front) are the two secondary rows, 0.30 LOW,
# judgement calls; the gluteus maximus and minimus and the lateral deltoid
# (an ExRx stabiliser) are named with the stabilisers so the legend keeps
# to one line (GLUTEUS MEDIUS . ANTERIOR DELTOID, 33 characters).
LANDMINE_ACTIVATION = [("Obliques", P, HI, 0.78), ("Rectus Abdominis", P, MOD, 0.40),
                       ("Gluteus Medius", S, LOW, 0.30), ("Anterior Deltoid", S, LOW, 0.30)]
LANDMINE_STABILISERS = ["erector spinae", "gluteus maximus", "gluteus minimus", "lateral deltoid"]

# Both Russian twists: obliques, rectus abdominis and hip flexors bright,
# lateral deltoid dim. No EMG of a Russian twist. Obliques 0.80, a little
# above the library's Russian Twist (0.76): these models turn the shoulders
# ~47 deg against its ~22 (Swie and Sakamoto 2004: oblique activity rose
# clearly only past ~30 deg of twist). Rectus Abdominis 0.60 and Hip Flexors
# 0.55, both PRIMARY as painted and above the library's 0.52 / 0.38 because
# the trunk is reclined 39 deg behind the hips against ~27 there and held
# there (ExRx: static spinal and hip flexion); below the sit-ups' values
# (0.72-0.88), where the trunk is lifted. Lateral Deltoid 0.20 LOW: it holds
# the arm on the load's side out from the body as the load goes down to the
# side (41-55 deg of abduction in the brief). All judgement calls.
TWIST_ACTIVATION = [("Obliques", P, HI, 0.80), ("Rectus Abdominis", P, MOD, 0.60),
                    ("Hip Flexors", P, MOD, 0.55), ("Lateral Deltoid", S, LOW, 0.20)]
TWIST_STABILISERS = ["transverse abdominis", "erector spinae", "anterior deltoid"]

# ---------------------------------------------------------------- Landmine Rotation

N = "Landmine Rotation"
ex(name=N, var="landmineRotation",
   # Front three-quarter from the lifter's left (yaw -0.3): the lifter
   # stands right of centre (u ~0.47-0.88), the bar runs from the hands down
   # to its base at the bottom left; at 1 s the plate swings out to u ~0.33
   # at v ~0.37-0.45, at 3 s across the body to the right. The right edge is
   # too narrow for pills above the feet, so four pills sit on the left (the
   # two below the plate's path short enough to stay clear of the bar) and
   # the knee pill sits bottom right, below the feet. The top pill is at 0.13
   # (review): at 0.16 the sleeve end grazed its lower edge at ~0.25 s, on
   # the way down from the top.
   overrides={"turn": (ov(0.13), "leading"), "arms": (ov(0.27), "leading"), "range": (ov(0.48), "leading"),
              "tempo": (ov(0.60), "leading"), "knees": (ov(0.80), "trailing")},
   annotations=[
       ("turn", "Chest turns with the bar", "chest"),
       ("arms", "Arms long", "forearm_R"),
       ("range", "Waist height", "spine"),
       ("tempo", "Steady pace", "pelvis"),
       ("knees", "Knees soft", "patella_L"),
   ],
   cues={
       "turn": ("Rotation",
                "Your chest and head turn to follow the bar end, your hips about half as far.",
                "Turning to the right uses the left external and the right internal oblique, which run from the lower ribs to the pelvis, so the ribcage turning over the hips is their work. In a study of standing twists held at set angles, the obliques were clearly more active than standing square only once the turn passed about 30 degrees.",
                "Swinging the bar across with your arms while your chest keeps facing the anchor.",
                "Turn your chest, shoulders and head together toward the side the bar goes to, about 45 degrees, and let your hips follow about half as far."),
       "arms": ("Arm Position",
                "Your arms reach long in front, elbows only softly bent.",
                "StrengthLog keeps the arms straight from side to side, and ExRx's standing cable twist keeps both arms straight. Held on long arms, the bar end stays in front of your chest, so your trunk has to turn to carry it across; bending the elbows lets your arms drag it across instead.",
                "Bending your elbows and pulling the bar across your body with your arms.",
                "Hold the end of the sleeve in both hands with your elbows only softly bent, and keep that bend while your chest carries your arms from side to side."),
       "range": ("Range of Motion",
                 "Each sweep brings the bar end down to about waist height, out in front of your hip and just outside it.",
                 "StrengthLog lowers the bar toward the outside of the hip on each turn. Turning back with the bar end still at chest height keeps both the arc and the turn short.",
                 "Turning back partway round, the bar end still up at chest height.",
                 "Keep turning until the bar end is level with your waist, out in front of your hip and a little outside it, then sweep it back up through the middle and across to the other side."),
       "tempo": ("Tempo",
                 "Sweep at an even pace, about a second down and a second back up.",
                 "StrengthLog alternates the sides in a controlled motion. A loaded bar end swung fast builds momentum that carries it on past the turn you are controlling, so the end of each sweep becomes a catch rather than a controlled turn.",
                 "Swinging the bar fast and letting it whip you round at each side.",
                 "Take about a second to sweep down to one side, ease into the end of the turn, then about a second to bring it back up through the middle."),
       "knees": ("Stance",
                 "Feet about shoulder-width, knees soft and bending a little more as you turn.",
                 "StrengthLog sets the feet slightly wider than shoulder-width, and ExRx's standing cable twist bends both knees slightly and notes that much of its turning comes from the hips rather than the spine. Soft knees let your hips turn and sink a little with each sweep; locked knees make them harder to turn.",
                 "Standing with your knees locked straight as the bar sweeps.",
                 "Stand facing the anchor with your feet about shoulder-width, toes turned out a little, and let your knees bend a little more as the bar comes down."),
   },
   activation=LANDMINE_ACTIVATION,
   stabilisers=LANDMINE_STABILISERS,
   comparison=("PULLING WITH THE ARMS", "Chest carries the bar", "Elbows bend, chest stays put",
               "Turning the chest over the hips moves the bar with the obliques, the arms only holding it long.",
               "Pulling the bar across with bent arms moves it with the shoulders while the trunk barely turns."),
   glows=[lit(N, 0.70, 0.35, 0.07, 0.045), lit(N, 0.70, 0.40, 0.05, 0.03, SOFT, 0.30)])

SETUP[N] = [
    "Set one end of a barbell in a landmine base, slide a plate onto the free end and stand facing the anchor at that end.",
    "Lift the sleeve end and hold it in both hands, palms facing each other, at about shoulder height with your arms reaching long.",
    "Set your feet about shoulder-width apart, toes turned out a little, knees soft.",
    "Brace your trunk, then sweep the bar down to one side; the sweeps alternate from then on.",
]

# ---------------------------------------------------------------- Landmine 180

N = "Landmine 180"
ex(name=N, var="landmine180",
   # Front three-quarter from the lifter's left (yaw -0.3): the lifter stands
   # right of centre (u ~0.52-0.80), the bar runs to its base at the bottom
   # left. The hands start at the top (v ~0.16, u ~0.55); at 1-2 s they and
   # the plate come out to u ~0.37-0.48, v ~0.29-0.50, at 5-6 s across to the
   # right edge. The pills sit on the left: two above the hands' path, one
   # short one level with it, two below, clear of the bar. Review: the long
   # turn pill sits on top (0.12) and the shorter start pill under it (0.17);
   # the other way round the plate and arms swept under the turn pill's right
   # end at ~0.25-0.6 s and the start leader ran across that end ~0.25-3.75 s.
   overrides={"turn": (ov(0.12), "leading"), "top": (ov(0.17), "leading"), "back": (ov(0.40), "leading"),
              "hip": (ov(0.52), "leading"), "tempo": (ov(0.64), "leading")},
   annotations=[
       ("top", "Start up high", "forearm_R"),
       ("turn", "Turn chest and hips", "chest"),
       ("back", "Stay tall", "neck"),
       ("hip", "To your hip", "thigh_R"),
       ("tempo", "Slow arc", "pelvis"),
   ],
   cues={
       "top": ("Start Position",
               "Each rep starts with the bar end up at about eye level, your arms raised long in front.",
               "Fitness Volt's landmine 180 brings the bar back up overhead to the start of every rep. Starting high gives the bar end its longest arc down to your hip, so starting at chest height trims the top off every rep.",
               "Starting each rep with the bar end down at chest height.",
               "Before each turn, raise the sleeve end until your hands are about level with your eyes, arms long."),
       "turn": ("Rotation",
                "Turn until you nearly face the side: your chest goes most of a quarter turn, your hips a little over half as far.",
                "Turning left uses the right external and the left internal oblique (ExRx), so the ribcage turning over the hips is the obliques' work. ExRx's notes on its standing cable twist put much of the turning in the hips rather than the spine, and StrengthLog's landmine rotation turns the hips and torso together.",
                "Keeping your chest facing the anchor and letting your arms carry the bar down.",
                "Turn your chest, head and hips together toward the side the bar is going, the chest turning furthest, until you face nearly sideways."),
       "back": ("Posture",
                "Your trunk stays tall as the bar comes down, leaning only slightly forward.",
                "The bar end comes down as your trunk turns and your arms lower, not by your trunk bending. In a study of torso twists against an elastic band done standing, one side of the lower back worked about as hard as the obliques and harder than in a seated twist machine, which the authors linked mostly to standing. Folding over the bar as it drops lowers it with a bend instead.",
                "Rounding forward over the bar as it comes down to your hip.",
                "Keep your chest up and your head in line with your trunk, turning around a tall spine as the bar end drops."),
       "hip": ("Bottom Position",
               "The bar end comes all the way down to about hip height, out in front of your hip, the arm that reaches across bending more at the elbow.",
               "Fitness Volt lowers the bar to the side with the torso rotating, and StrengthLog's landmine rotation takes it toward the outside of the hip. Turning back with the bar end still high leaves out the lower part of the arc and much of the turn.",
               "Turning back with the bar end still out at chest height.",
               "Keep turning and lowering until the bar end is down at your hip, pause there for a moment, then bring it back up over the top."),
       "tempo": ("Tempo",
                 "Take about two seconds down to each side and two seconds back up.",
                 "Fitness Volt names swinging the bar back and forth with little control as a common mistake and has each rep done slowly. A slow arc lets you stop the heavy end at your hip instead of letting it swing you round.",
                 "Dropping the bar end quickly and swinging it from hip to hip.",
                 "Lower the bar to one hip over about two seconds, pause briefly, take about two seconds to bring it back over the top, then go to the other side."),
   },
   activation=LANDMINE_ACTIVATION,
   stabilisers=LANDMINE_STABILISERS,
   comparison=("STOPPING SHORT", "Bar end down to the hip", "Bar end turns back high",
               "Turning until the bar end reaches your hip takes the trunk through the whole arc.",
               "Turning back with the bar still high leaves out the lower part of the arc and much of the turn."),
   glows=[lit(N, 0.645, 0.386, 0.06, 0.04), lit(N, 0.645, 0.43, 0.05, 0.03, SOFT, 0.30)])

SETUP[N] = [
    "Load a plate onto the free end of a barbell set in a landmine base and stand facing the anchor at that end.",
    "Take your feet a little wider than shoulder-width, toes turned out a little, knees soft.",
    "Hold the sleeve end in both hands, palms facing each other, and raise it until your hands are about level with your eyes.",
    "Pick the side you go to first; each rep goes down to one hip and back up, then the other.",
]

# ---------------------------------------------------------------- Medicine Ball Russian Twist

N = "Medicine Ball Russian Twist"
ex(name=N, var="medicineBallRussianTwist",
   # Front three-quarter from the lifter's left (yaw -0.5): seated, feet to
   # the left (v ~0.6), knees up at v ~0.43-0.45, the head at (0.6, 0.33-0.40);
   # the ball swings out to the right (u ~0.7-0.92, v ~0.45-0.62) on the
   # left twists and behind the body on the right ones. The top band is free:
   # two pills on each side above the head and knees (the right-hand ones
   # below the eye button), and the ball's pill sits bottom right on the
   # floor below the mat. Review: the knees pill is on top (0.18) and the
   # rhythm pill under it (0.30); the other way round the rhythm leader, going
   # down to the right hand on the right twists, ran along the knees pill's
   # right end.
   overrides={"knees": (ov(0.18), "leading"), "tempo": (ov(0.30), "leading"), "lean": (ov(0.19), "trailing"),
              "turn": (ov(0.28), "trailing"), "low": (ov(0.80), "trailing")},
   annotations=[
       ("turn", "Shoulders turn", "upper_arm_L"),
       ("low", "Ball beside your hip", "hand_L"),
       ("lean", "Hold the lean", "head"),
       ("knees", "Knees still", "patella_L"),
       ("tempo", "Even rhythm", "hand_R"),
   ],
   cues={
       "turn": ("Shoulder Turn",
                "Your shoulders turn about 45 degrees to each side, your head following the ball.",
                "Turning left uses the right external and the left internal oblique (ExRx). In a study of standing twists held at set angles, the obliques were clearly more active than with no twist only once the turn passed about 30 degrees, so a twist made mostly with the arms leaves the trunk short of it.",
                "Swinging the ball across with your arms while your shoulders keep facing your knees.",
                "Turn your chest, shoulders and head together until the ball is beside your hip, then turn the whole way back through the middle."),
       "low": ("Range of Motion",
               "Each twist takes the ball from in front of your chest down beside your hip, just off the floor.",
               "In this version the ball goes down nearly to the floor on each side: ExRx's medicine ball Russian twist turns the torso and reaches the arms to that side to touch it down, and StrengthLog's brings the weight toward the hip. Holding the ball up by your ribs cuts that reach short, so less of its weight ends up out at your side, where your trunk has to stop it and turn it back.",
               "Turning with the ball held up by your ribs instead of lowering it beside your hip.",
               "As you turn, let your arms lengthen and lower the ball until it is close beside your hip and almost touching the mat, then bring it back up past your chest."),
       "lean": ("Torso Angle",
                "Lean back about 40 degrees and keep that angle through every twist.",
                "ExRx lists flexion of the spine and hips as held still while the spine rotates: with your trunk leaned back behind your hips, your abdominals and hip flexors hold it there while the obliques turn it. Sitting up between twists lets its weight settle over your hips instead.",
                "Sitting up toward upright as you twist or between twists.",
                "Sit back on your hips, lean your trunk back until it is about 40 degrees from upright, and hold that angle as you turn."),
       "knees": ("Hips and Knees",
                 "Your hips, knees and feet stay where they are while your shoulders turn.",
                 "The obliques turn the ribcage against the pelvis, so with the pelvis still, the whole turn happens in your trunk; ExRx notes that twists with the hips held still allow more turning through the spine. Knees swaying toward the ball turn the hips instead.",
                 "Letting your knees sway toward the ball on each twist.",
                 "Keep your feet flat and your knees pointing up, about hip-width apart, while only your trunk turns."),
       "tempo": ("Rhythm",
                 "Twist at an even rhythm, a little over a second from one side to the other.",
                 "A heavy ball that swings freely carries you on past the turn you are controlling. An even rhythm keeps your obliques turning you to each side and stopping you there.",
                 "Letting the ball swing you past each side and bounce you back the other way.",
                 "Take about two thirds of a second to reach each side, stop the ball beside your hip, then turn back at the same pace."),
   },
   activation=TWIST_ACTIVATION,
   stabilisers=TWIST_STABILISERS,
   comparison=("BALL KEPT HIGH", "Ball down beside the hip", "Ball held up by the ribs",
               "Turning the shoulders about 45 degrees and lowering the ball carries it down beside each hip, just off the mat.",
               "Holding the ball up by the ribs stops each twist short of the hip, so less of its weight is out at the side as you turn."),
   glows=[lit(N, 0.60, 0.49, 0.08, 0.05), lit(N, 0.37, 0.48, 0.10, 0.03, SOFT, 0.30)])

SETUP[N] = [
    "Sit on a mat with your knees bent and your feet flat, about hip-width apart.",
    "Hold a medicine ball between your palms in front of your chest, elbows bent.",
    "Lean back until your trunk is about 40 degrees from upright and find your balance on your hips.",
    "Twist to one side first; the twists alternate from then on.",
]

# ---------------------------------------------------------------- Weighted Russian Twist

N = "Weighted Russian Twist"
ex(name=N, var="weightedRussianTwist",
   # The same framing and motion as the medicine-ball twist (yaw -0.5), the
   # plate swinging out to the right on the left twists. Same layout: two
   # pills each side in the top band (knees above grip, as the medicine-ball
   # twist), the plate's pill bottom right.
   overrides={"knees": (ov(0.18), "leading"), "grip": (ov(0.30), "leading"), "lean": (ov(0.19), "trailing"),
              "turn": (ov(0.28), "trailing"), "low": (ov(0.80), "trailing")},
   annotations=[
       ("turn", "Ribcage turns", "upper_arm_L"),
       ("low", "Plate down by the hip", "hand_L"),
       ("lean", "Stay leaned back", "head"),
       ("knees", "Knees point up", "patella_L"),
       ("grip", "Plate by its rim", "hand_R"),
   ],
   cues={
       "turn": ("Rotation",
                "Your ribcage turns about 45 degrees each way over hips that stay square.",
                "The obliques run from the lower ribs to the pelvis: turning right uses the left external and the right internal oblique, turning left the reverse (ExRx). In a study of standing twists held at set angles they were clearly more active than with no twist only past about 30 degrees, a turn the arms alone do not make.",
                "Moving the plate side to side with your arms while your chest keeps facing forward.",
                "Lead with your shoulders and turn until the plate is beside your hip, eyes following it, then turn all the way to the other side."),
       "low": ("Range of Motion",
               "The plate travels from your chest down beside your hip on each twist, its edge just clear of the mat.",
               "StrengthLog's version brings the weight toward the hip with every twist, and ExRx's medicine ball version touches the floor on each side. Keeping the plate up by your ribs cuts that reach short, so less of its weight is out at your side at the end of each turn.",
               "Turning with the plate held up by your ribs, never lowering it toward the mat.",
               "Let your arms lengthen as you turn and lower the plate until its edge almost touches the mat beside your hip, then lift it back past your chest."),
       "lean": ("Torso Angle",
                "Hold your trunk about 40 degrees back from upright for the whole set.",
                "With your trunk reclined behind your hips, its weight has to be held by your abdominals and hip flexors; ExRx's medicine ball version lists flexion of the spine and hips as held, not moving, while the spine turns. Rising toward upright between twists lets that load settle onto your hips.",
                "Rising toward upright each time the plate passes the middle.",
                "Lean back until your trunk is about 40 degrees from upright, balance on your hips, and keep that angle as the plate goes from side to side."),
       "knees": ("Hips and Knees",
                 "Your knees keep pointing up and your feet stay flat while the plate moves.",
                 "ExRx's cable twist notes say that keeping the hips still lets more of the turn happen in the spine. If your knees tip toward the plate your hips turn with it, and the trunk turns less over them.",
                 "Letting your knees tip toward the plate on each twist.",
                 "Keep your feet flat, about hip-width apart, and your knees pointing straight up while your trunk turns above them."),
       "grip": ("Plate Grip",
                "Hold the plate by its rim, one hand on each side, close in front of your chest at the middle.",
                "StrengthLog has the weight held with both hands in front of the chest. Gripping the rim on both sides keeps the plate steady as it turns and lowers beside your hip; pinched by its top edge it can tip and swing as it comes down.",
                "Pinching the plate by its top edge so that it swings as you turn.",
                "Wrap your hands around the rim at the sides, about three and nine o'clock, and bring the plate back in front of your chest between twists."),
   },
   activation=TWIST_ACTIVATION,
   stabilisers=TWIST_STABILISERS,
   comparison=("KNEES SWAYING", "Knees still, trunk turns", "Knees tip toward the plate",
               "With the hips and knees still, the ribcage turns over the pelvis, which is the obliques' job.",
               "When the knees tip toward the plate the hips turn with it, and the trunk twists less over them."),
   glows=[lit(N, 0.60, 0.49, 0.08, 0.05), lit(N, 0.37, 0.48, 0.10, 0.03, SOFT, 0.30)])

SETUP[N] = [
    "Sit on a mat, knees bent and feet flat on the floor about hip-width apart.",
    "Hold a weight plate by its rim, one hand on each side, in front of your chest.",
    "Lean back to about 40 degrees from upright, balancing on your hips.",
    "Start by turning to either side, then alternate.",
]
