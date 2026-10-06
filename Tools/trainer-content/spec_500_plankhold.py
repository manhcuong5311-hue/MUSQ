# Trainer content for the 401-500 folder, third round (445-474, 2026-10-05),
# family: plankhold. Four held or slow plank variations from the builder's
# exports: 454 RKC Plank (Abs/RKCPlank), 455 Weighted Plank
# (Abs/WeightedPlank), 456 Side Plank Hip Lift (Abs/SidePlankHipLift) and 457
# Copenhagen Plank (Abs/CopenhagenPlank). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_plankhold.md maps the copy's claims to the sources below
# and records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (SCRATCH/plankhold/rig2.py dumps every joint every frame, skin.py skins the
# meshes at chosen frames, prone.py, tilt.py, side.py, side2.py, legs.py,
# arm.py, low.py, feet.py, profile.py and misc.py measure; the app's Y-up
# space, the lifter facing +z, their left +x, the mat's top at y 0), the
# motion briefs, the trainer stills at 0/1/2/3/5 s, joints.json and tiers.txt.
# Every clip is 7.96 s on one body (neck to pelvis 0.59 m) on a 1.6 x 2.4 m mat
# (HG_Mat). Heights are joint heights unless a mesh is named.
# - RKC Plank: a still forearm plank, head toward +z (the pelvis moves under
#   1 cm). Elbows 113 deg, the elbow joints 10 cm ahead of the shoulder joints
#   (upper arms 20 deg forward of vertical) and 35 cm apart (shoulders 39
#   cm); the forearms angle 20 deg in so the fists (on their sides, palms
#   in) almost meet in front, 1.5 cm apart. Feet together (the shoes touch,
#   ankles 10 cm apart), on the toes, knees 174 deg, a straight line from
#   neck through hip to knee (177 deg),
#   the trunk rising 9 deg toward the head; shoulder joints 33 cm and the
#   pelvis 24 cm up, the abdomen 13 cm off the mat. Elbows to ankles 1.46 m
#   (the Weighted Plank's elbows-under-shoulders set-up on the same rig:
#   1.36 m). Pelvic tilt: against the thighs the pelvis sits 1.4 deg further
#   back than standing (bind pose) and 2.5 deg further back than the Weighted
#   Plank's, and the lower back's dip is the same depth (4.6 vs 4.9 cm below
#   a line from the buttocks to the upper back), so no tuck can be seen. The
#   head is tipped 13 deg back from the trunk line, the eyes on the hands.
#   Paint: rectus abdominis bright; anterior deltoid, external and internal
#   oblique, gluteus maximus, medius and minimus dim.
# - Weighted Plank: a still forearm plank with a plate (HG_BackPlate, 32 cm
#   across) on the upper back: its centre 14 cm toward the hips from the
#   shoulder-blade joints, tilted ~21 deg (about 10 deg steeper than the back),
#   touching around its middle. Elbows 93 deg straight under the shoulders
#   (34 cm apart), forearms parallel, hands 24 cm apart with the palms facing
#   in; feet hip-width (ankles 22 cm apart), on the toes, knees 174 deg, neck
#   through hip to knee 179 deg; shoulders 35 cm, pelvis 27 cm up. Head 14 deg
#   back from the trunk line. Paint: rectus abdominis bright; anterior
#   deltoid, external and internal oblique dim.
# - Side Plank Hip Lift: on the RIGHT forearm (elbow 93 deg, under the
#   shoulder, the forearm pointing forward across the body's line), the left
#   arm straight up (hand ~1.2 m up). Feet staggered, both on the mat: the top
#   (left) foot ~30 cm in front of the bottom one; bottom knee 170 deg, top
#   knee 146 -> 167 deg as the hips rise. The pelvis is rolled ~33 deg toward
#   the floor (the hip line 57 deg from level) and the shoulders ~30 deg
#   less. The hips lower and lift through 11 cm (pelvis joint 31 -> 42 cm):
#   at the bottom the body bends toward the floor at the hips (the bottom
#   hip 15 deg adducted; the hip joints' midpoint ~4 cm below a line from
#   the shoulder joints to the ankles) and the bottom thigh's lowest point,
#   mid-thigh, stays 5.8 cm above the mat (the shorts 9 cm); at the top it
#   bends the other way, the hips ~7 cm above that line. Up 0.42-1.08 s,
#   held 1.08-2.38 s, down 2.38-3.17 s, paused at the bottom 3.17-4.42 s;
#   two reps, the second at 4.42 s.
#   Paint: external and internal oblique, gluteus maximus, medius and
#   minimus and the lateral deltoid bright; rectus abdominis dim.
# - Copenhagen Plank: on the RIGHT forearm (elbow 92 deg, exactly under the
#   shoulder, the forearm pointing forward), the left arm straight up. The
#   top (left) leg rests on a bench (HG_Bench, top 45 cm, 30 cm deep) by the
#   foot and ankle (the shoe on the bench, the calf clear of it; knee 171 deg),
#   the long-lever set-up. The bottom (right) leg hangs straight (knee 180
#   deg) under the bench, 21 deg off the body's line, its shoe 3.5 cm above
#   the mat; it never touches the floor or the bench. Trunk level (0 deg),
#   hips and shoulders stacked, head in line. Still (nothing moves). Paint:
#   adductor longus, adductor magnus, gracilis, lateral deltoid, rhomboid
#   major and the upper, middle and lower trapezius bright; external and
#   internal oblique and rectus abdominis dim.
#
# How they differ from the library: the Plank sets the elbows under the
#   shoulders, forearms parallel, feet apart, with no load; the RKC plank
#   moves the elbows ahead and brings the hands and feet together, the
#   weighted plank adds a plate. The Side Plank holds still on the left
#   forearm with the feet stacked; the hip lift is on the right forearm, feet
#   staggered, and moves the hips down and up. Cable Hip Adduction sweeps one
#   standing leg against a cable; the Copenhagen plank holds the body up on
#   the top leg's adductors from a bench.
#
# Sources (abstracts read on Europe PMC 2026-10-05, full text where noted;
# ExRx through the Wayback Machine; details and what each supports in the
# notes):
# - Schoenfeld BJ, Contreras B, Tiryaki-Sonmez G, Willardson JM, Fontana F
#   2014, Sports Biomech 13(3):296-306, doi:10.1080/14763141.2014.942355,
#   PMID 25325773 (full text, the author's copy on bretcontreras.com) - 19
#   trained men, four 30 s planks: traditional (elbows under the shoulders),
#   long lever (elbows 6 in apart at nose level), posterior tilt (glutes
#   squeezed as hard as possible, pubic bone toward the navel, tailbone toward
#   the feet) and both together. Long-lever posterior-tilt plank: upper
#   rectus abdominis 110% MVC vs 27% traditional, lower abdominal stabilisers
#   154 vs 38%, external oblique 149 vs 50%, erector spinae ~5-7% in all; the
#   long lever tended to contribute more than the tilt; the elbows forward
#   and closer lengthen the lever arm and reduce the base of support.
# - Contreras B 2011, The RKC Plank (bretcontreras.com, read 2026-10-05):
#   arms further out, elbows closer together, quads contracted to lock the
#   knees, glutes contracted as hard as possible to tilt the pelvis back, head
#   and neck neutral looking down.
# - Harris-Fry N, How To Do The RKC Plank (Coach, coachweb.com, first
#   published 2017-02-17, updated 2023-05-17, read 2026-10-05): from Pavel
#   Tsatsouline's programme; from the plank, hands clenched together, quads
#   and glutes tensed, the shoulders squeezed toward the toes and the toes
#   toward the head as if to pike; three to five holds of about 10 s,
#   tension before duration.
# - ExRx.net (Wayback Machine; the live site returns 403): Front Plank
#   (RectusAbdominis/BWFrontPlank, snapshot 2026-01-27: elbows under the
#   shoulders, harder with added weight on the hips or low back, target
#   rectus abdominis, obliques among the stabilisers); Side Bridge
#   (Obliques/BWSideBridge, 2021-04-20: the hips raised by side-bending the
#   spine and lowered; the lower hip abducts and the upper hip adducts;
#   target obliques; synergists gluteus medius and minimus, tensor fasciae
#   latae, quadratus lumborum, psoas major, iliocostalis, the hip adductors
#   (pectineus, gracilis), gluteus maximus lower fibres, lateral deltoid,
#   supraspinatus, middle and lower trapezius, serratus anterior; set-up:
#   forearm under the shoulder perpendicular to the body, legs stacked); Side
#   Plank (Obliques/BWSidePlank, 2022-02-26: the same held still); Gluteus Medius
#   (Muscles/GluteusMedius, 2026-06-24: hip abduction).
# - StrengthLog exercise directory (strengthlog.com, read 2026-10-05):
#   Weighted Plank (plate on the back, a partner to place it, abs primary,
#   obliques secondary), Side Plank (the top foot in front of the other),
#   Copenhagen Plank (top leg on a bench, forearm under the shoulder, bottom
#   leg off the ground hanging under the bench, held for time or done
#   dynamically; adductors primary, abductors, abs and obliques secondary).
# - Ekstrom RA, Donatelli RA, Carp KC 2007, J Orthop Sports Phys Ther
#   37(12):754-762, doi:10.2519/jospt.2007.2471, PMID 18560185 - 30 adults,
#   nine exercises: the side-bridge could be used for strengthening the
#   gluteus medius and the external oblique (abstract only).
# - Serner A, Jakobsen MD, Andersen LL, Holmich P, Sundstrup E, Thorborg K
#   2014, Br J Sports Med 48(14):1108-1114, doi:10.1136/bjsports-2012-091746,
#   PMID 23511698 - 40 elite soccer players, eight hip adduction exercises:
#   adductor longus peak 14-108% nEMG, the Copenhagen adduction among the
#   highest (108%, with the ball squeeze between the knees, as Schaber 2021's
#   full-text review reports it); gluteals and abdominals 5-48%.
# - Schaber M, Guiser Z, Brauer L et al. 2021, Int J Sports Phys Ther
#   16(5):1210-1221, doi:10.26603/001c.27975, PMID 34631242 (PMC8486394, full
#   text) - systematic review of the Copenhagen adduction exercise (side
#   plank, the top leg held by a partner, the bottom leg lowered and raised).
# - Collings TJ, Horsman A, Hams AH et al. 2026, Med Sci Sports Exerc
#   58(8):1751-1763, doi:10.1249/mss.0000000000004002, PMID 41931009 - 15
#   participants, EMG-driven model: the long-lever Copenhagen adduction was in
#   the top tier for adductor brevis, longus, magnus and gracilis forces.
# - Ishoi L, Sorensen CN, Kaae NM et al. 2016, Scand J Med Sci Sports
#   26(11):1334-1342, doi:10.1111/sms.12585, PMID 26589483 - 8 weeks of the
#   Copenhagen adduction in-season: eccentric hip adduction strength +35.7%.
# - Haroy J, Clarsen B, Wiger EG et al. 2019, Br J Sports Med 53(3):150-157,
#   doi:10.1136/bjsports-2017-098937, PMID 29891614 - 35 teams: a programme
#   built on the Copenhagen adduction cut the risk of groin problems by 41%.
# - Polglass G, Burrows A, Willett M 2019, BMJ Open Sport Exerc Med
#   5(1):e000570, doi:10.1136/bmjsem-2019-000570, PMID 31673404 (PMC6797385,
#   full text) - a progression of isometric Copenhagen holds (20 s each) from
#   the knee on a box (short lever) to the foot on it (long lever), the
#   bottom leg first on the floor, then lifted; the box raised to hip height
#   as the hardest hold.
# No EMG study of the RKC plank as such, of a plate-loaded plank or of the
# static Copenhagen plank was found; Schoenfeld 2014 reports %MVC, which the
# app's fractions are not, so every fraction below is a judgement call
# anchored on the library's Plank (rectus abdominis 0.78, obliques 0.56,
# gluteus maximus 0.36), Side Plank (obliques 0.78, gluteus medius 0.46) and
# Cable Hip Adduction (adductor longus 0.85), and on the order the studies give.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- RKC Plank

N = "RKC Plank"
ex(name=N, var="rkcPlank",
   # Side-on (yaw -1.35), head on the left: the body is a band across
   # v ~0.44-0.58 with the mat under it, nothing moves. Three pills above
   # (the hips and the knees at 0.20, the pull to the chest at 0.30, its
   # pill ending left of the hips leader) and two below the mat (elbows
   # left, feet right), each leader meeting the body from the open side.
   overrides={"glutes": (ov(0.20), "leading"), "legs": (ov(0.20), "trailing"),
              "pull": (ov(0.30), "leading"),
              "lever": (ov(0.72), "leading"), "base": (ov(0.72), "trailing")},
   annotations=[
       ("lever", "Elbows ahead of shoulders", "forearm_L"),
       ("glutes", "Glutes squeezed, no sag", "pelvis"),
       ("legs", "Knees locked, quads tight", "patella_L"),
       ("base", "Hands and feet together", "foot_L"),
       ("pull", "Pull shoulders to toes", "chest"),
   ],
   cues={
       "lever": ("Long Lever",
                 "Your elbows sit about 10 cm ahead of your shoulders, the forearms angled in so the fists almost meet.",
                 "Moving the elbows forward lengthens the lever your body makes between elbows and toes. In an EMG study, a plank with the elbows set forward and close together raised upper rectus abdominis activity to more than three times that of a regular plank, and the longer lever tended to do more of that than the pelvic tilt.",
                 "Setting the elbows straight under the shoulders, which shortens the lever and turns it back into a regular plank.",
                 "Place your elbows a hand's width ahead of your shoulders, angle your forearms in and keep them there for the whole hold."),
       "glutes": ("Glutes and Pelvis",
                  "Squeeze your glutes as hard as you can, so your hips stay in line with your shoulders and heels.",
                  "Squeezing the glutes hard draws the tailbone toward the feet, a backward tilt of the pelvis that the abs help hold. In an EMG study of plank variations, adding that squeeze to a regular plank more than doubled external oblique activity, and combined with the long lever it made the hardest plank tested.",
                  "Letting the glutes relax, so the hips sink and the lower back arches.",
                  "Clench your glutes as soon as you are up, think tailbone toward your heels, and keep squeezing until you lower your knees."),
       "legs": ("Legs",
                "Your knees stay locked straight with the thigh muscles tight.",
                "Tensing the quads locks the knees, so the legs become one rigid beam from hips to toes and the trunk has to hold the whole length. Coaching for this plank asks you to tense the quads to lock the knees and to clench the glutes as hard as possible.",
                "Soft, bent knees that let the hips sink toward the mat.",
                "Pull your kneecaps up by tightening your thighs, and keep the legs straight and heavy on your toes."),
       "base": ("Narrow Base",
                "Your fists almost meet in front of you and your feet touch.",
                "Bringing the hands and the feet together shrinks the base you balance on. The authors of an EMG study of the long-lever plank suggest that a smaller base, with the elbows set closer together, adds to what the longer lever does. Here the fists almost meet in front and the shoes touch.",
                "Spreading the feet wide to make the hold easier to balance.",
                "Make fists, bring them together in front of your face and set your feet together before you lift."),
       "pull": ("Full-Body Tension",
                "Brace everything hard for a short hold while nothing moves.",
                "This plank is about tension, not time. Coaching for it has you squeeze the shoulders toward the toes and the toes toward the head, as if to pike, which makes the glutes work harder to keep the body straight, and suggests three to five holds of about 10 seconds, keeping the tension high rather than lasting longer.",
                "Holding a relaxed plank for minutes instead of a hard one for seconds.",
                "Squeeze your shoulders toward your toes and your toes toward your head while your body stays straight, and end the hold when you can no longer keep the tension high."),
   },
   # Rectus abdominis bright (PRIMARY); obliques, gluteus maximus, medius and
   # minimus and the anterior deltoid dim. Schoenfeld 2014: the long-lever
   # posterior-tilt plank drove the upper rectus abdominis to 110% MVC
   # against 27% for a regular plank, so the rectus sits well above the
   # library Plank's 0.78 (0.92). External oblique 149% there, second only
   # to the lower abdominal site (154%), but painted dim, so a high secondary
   # (0.68, over the Plank's 0.56). The glutes are squeezed as hard as
   # possible (Schoenfeld, Contreras); no EMG of them in a plank was read, so
   # the gluteus maximus
   # sits a little over the Plank's 0.36 (0.48). A third secondary row would
   # truncate the one-line legend (round 2), so the dim anterior deltoid,
   # gluteus medius and minimus are named with the stabilisers. All
   # judgement calls.
   activation=[("Rectus Abdominis", P, HI, 0.92), ("Obliques", S, MOD, 0.68),
               ("Gluteus Maximus", S, MOD, 0.48)],
   stabilisers=["transverse abdominis", "quadriceps", "anterior deltoid", "gluteus medius"],
   comparison=("HIPS SAGGING", "Glutes squeezed, body straight", "Glutes loose, hips sink",
               "With the glutes squeezed and the elbows set long, the abs hold a long, rigid body against gravity.",
               "Once the glutes let go the hips drop and the lower back arches, and the hold goes slack."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.03, 0.0, 0.025),
          glow(N, ["pelvis"], SOFT, 0.28, 0.05, 0.03, 0.0, 0.0)])

SETUP[N] = [
    "Lie face down on a mat and set your forearms down with the elbows a hand's width ahead of your shoulders.",
    "Angle your forearms in and bring your fists together in front of your face.",
    "Bring your feet together and tuck your toes under.",
    "Lift your body into a straight line from head to heels, then squeeze your glutes and thighs as hard as you can.",
]

# ---------------------------------------------------------------- Weighted Plank

N = "Weighted Plank"
ex(name=N, var="weightedPlank",
   # Side-on (yaw -1.35), head on the left, the plate on the upper back:
   # the body is a band across v ~0.44-0.58. Two pills above (the head left,
   # the plate right, both leaders running down-left), three below the mat
   # (elbows left and legs right at 0.72, the body line right at 0.80, its
   # leader rising left of the legs pill to the pelvis). Round 1 had the body
   # pill at 0.80 left, where its leader grazed the end of the elbows pill.
   overrides={"head": (ov(0.22), "leading"), "plate": (ov(0.22), "trailing"),
              "elbows": (ov(0.72), "leading"), "legs": (ov(0.72), "trailing"),
              "body": (ov(0.80), "trailing")},
   annotations=[
       ("body", "Straight line under load", "pelvis"),
       ("elbows", "Elbows under shoulders", "forearm_L"),
       ("plate", "Plate flat on upper back", "chest"),
       ("head", "Eyes on your hands", "head"),
       ("legs", "Knees straight, on toes", "patella_L"),
   ],
   cues={
       "body": ("Body Line",
                "Your body stays in one straight line from head to heels under the plate.",
                "The plate adds weight for your abs to hold up: StrengthLog's guide asks for the same straight line from head to feet as a regular plank and says the core has to work harder to keep it under the load. If the hips sag, the lower back bends under the weight instead.",
                "Hips sagging toward the floor under the weight.",
                "Brace your abs and squeeze your glutes before the plate goes on, and end the set as soon as the hips start to drop."),
       "elbows": ("Elbow Position",
                  "Your elbows sit straight under your shoulders, forearms parallel.",
                  "Stacked like this, the upper arms carry your weight and the plate's straight down to the floor; ExRx's front plank also sets the elbows under the shoulders.",
                  "Elbows far in front of the shoulders, so the shoulders drop toward the floor.",
                  "Set each elbow under its shoulder and the forearms parallel, palms facing in, before you lift."),
       "plate": ("Plate Placement",
                 "The plate lies flat on your upper back, centred over your spine.",
                 "Centred, it presses straight down and stays put; off to one side it tips and slides, and you twist to hold it. StrengthLog's guide suggests a partner to set it on your back; ExRx adds weight lower, on the hips or lower back.",
                 "A plate set off to one side or up on the neck, sliding as you hold.",
                 "Have a partner set the plate flat on your upper back, centred over your spine, before you push up, and lower to the mat before it comes off."),
       "head": ("Head Position",
                "Your neck stays long with your eyes on your hands.",
                "Your head is the top end of the straight line from head to heels that StrengthLog's guide asks for; letting it drop bends that line at the neck. Here it stays close to the trunk's line, tipped up just enough to look at the hands.",
                "Letting the head drop toward the floor.",
                "Keep your neck long and look at the floor by your hands for the whole hold."),
       "legs": ("Legs and Feet",
                "Your knees stay straight and you stay up on your toes, feet about hip-width apart.",
                "Straight legs make one rigid beam from the hips to the toes, so the abs hold the whole length; ExRx lists the quadriceps among the plank's stabilisers.",
                "Bending the knees so the hips sink.",
                "Tuck your toes under, feet about hip-width apart, and keep your knees straight and thighs tight."),
   },
   # Rectus abdominis bright (PRIMARY); anterior deltoid and obliques dim.
   # No EMG of a plate-loaded plank was found; StrengthLog says the core works
   # harder under the plate and ExRx that added weight makes the plank more
   # challenging, so the rectus sits a touch over the library Plank's 0.78
   # (0.82). Here the plate rests on the upper back near the elbows, so much
   # of its weight goes down the arms (mechanics),
   # which is why the rise is small. Obliques a touch over the Plank's 0.56
   # (0.60). The anterior deltoid holds the upper arm under the load (dim,
   # LOW 0.36). Gluteus maximus (a Plank secondary, not painted here) and the
   # serratus anterior are named with the stabilisers. Judgement calls.
   activation=[("Rectus Abdominis", P, HI, 0.82), ("Obliques", S, MOD, 0.60),
               ("Anterior Deltoid", S, LOW, 0.36)],
   stabilisers=["transverse abdominis", "serratus anterior", "quadriceps", "gluteus maximus"],
   comparison=("HIPS SAGGING", "Straight line under the plate", "Hips sink under the plate",
               "With the body straight, the abs hold your weight and the plate's against gravity.",
               "When the hips sink under the load the lower back arches and takes the strain the abs should hold."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.03, 0.0, 0.025),
          glow(N, ["upper_arm_L"], SOFT, 0.26, 0.03, 0.03, 0.0, 0.01)])

SETUP[N] = [
    "Lie face down on a mat with your elbows under your shoulders and your forearms parallel.",
    "Tuck your toes under, feet about hip-width apart.",
    "Have a partner set the plate flat on your upper back, centred over your spine, and brace your abs.",
    "Push up into a straight line from head to heels and hold, keeping the plate level.",
]

# ---------------------------------------------------------------- Side Plank Hip Lift

N = "Side Plank Hip Lift"
ex(name=N, var="sidePlankHipLift",
   # From behind (yaw 1.5), head on the right, feet on the left: the body runs
   # up from the feet (v ~0.65) to the head (v ~0.52), the top arm points up
   # at u ~0.71 (fingers v ~0.32, ~0.23 in the lifted mistake view) and the
   # support forearm sits under the shoulder at the right. Above: the lift
   # pill left (0.22) to the pelvis and the line pill right (0.16, clear of
   # the raised hand in both views) to the spine, its leader left of the
   # arm. Below the mat: the dip left (0.74) to the bottom hip, the elbow
   # right (0.74), and the tempo left (0.80) to the chest, its leader rising
   # between the dip leader and the elbow pill. Round 1 had the tempo pill at
   # 0.80 right, where its leader grazed the end of the elbow pill.
   overrides={"lift": (ov(0.22), "leading"), "line": (ov(0.16), "trailing"),
              "dip": (ov(0.74), "leading"), "elbow": (ov(0.74), "trailing"),
              "tempo": (ov(0.80), "leading")},
   annotations=[
       ("elbow", "Elbow under shoulder", "forearm_R"),
       ("lift", "Lift hips above the line", "pelvis"),
       ("dip", "Dip short of the mat", "thigh_R"),
       ("line", "Hips forward, no pike", "spine"),
       ("tempo", "Steady lift, short hold", "chest"),
   ],
   cues={
       "elbow": ("Support Arm",
                 "Your right forearm lies on the mat with the elbow straight under your shoulder.",
                 "Stacked like this, the upper arm carries the body straight down to the floor, so the side of the trunk does the lifting. ExRx sets the forearm under the shoulder, across the line of the body, as here.",
                 "Placing the elbow well out toward the head, so the shoulder hangs off it.",
                 "Set your elbow under your shoulder, forearm pointing forward, and push the floor away for the whole set."),
       "lift": ("Hip Lift",
                "The hips rise until they are a little above a straight line from shoulders to feet.",
                "ExRx describes the side bridge as raising the hips by bending the spine sideways, with the obliques as its target, while the bottom hip abducts, the gluteus medius's movement. In an EMG study of nine exercises, the side bridge was one that could be used to strengthen the gluteus medius and the external oblique.",
                "Stopping each rep with the hips still sagging below the line.",
                "Drive your bottom hip up toward the ceiling until your body is straight, then a touch higher, and hold it there."),
       "dip": ("Lowering",
               "The hips lower about 11 cm and stop just above the mat.",
               "Stopping short keeps the obliques working through the whole set; resting the hip on the floor hands your weight to the mat between reps. Here the bottom thigh stays about 6 cm off it.",
               "Dropping the hip onto the mat to rest between reps.",
               "Lower under control until your bottom thigh is a few centimetres above the mat, pause there, then lift again."),
       "line": ("Body Line",
                "Your hips stay in line with your shoulders and feet, not pushed back, as they rise and fall.",
                "ExRx describes the lift as a sideways bend of the spine. Folding at the hips instead pushes the buttocks back and turns part of the lift into a bend forward.",
                "Piking the hips back behind the line as you lift.",
                "Keep your hips pressed forward, your top foot in front of the bottom one, and lift straight up toward the ceiling."),
       "tempo": ("Tempo",
                 "Lift in under a second, hold about a second, lower in under a second.",
                 "Here each rep takes about 4 seconds: the lift under a second, a hold of about a second at the top, the lowering under a second and a pause of about a second just above the mat. At that pace the hips stay under control at both ends instead of bouncing off the bottom.",
                 "Bouncing the hips up and down fast.",
                 "Lift smoothly, hold the top for a count of one, lower in under a second, then pause just above the mat before the next rep."),
   },
   # External and internal obliques, gluteus maximus, medius and minimus and
   # the lateral deltoid bright (PRIMARY); rectus abdominis dim. ExRx makes
   # the obliques the target of the side bridge, and Ekstrom 2007 found the
   # side-bridge could be used to strengthen the external oblique and the
   # gluteus medius, so the obliques sit a touch over the library Side
   # Plank's 0.78 (0.82; the lift adds side-bending to the hold) and the gluteus medius
   # well over its 0.46 secondary (0.62; bright here, and ExRx: the bottom
   # hip abducts as the hips rise). Gluteus maximus (ExRx: lower fibres a
   # synergist) and the lateral deltoid (ExRx synergist, the support
   # shoulder) are bright but have no value in what was read, so low
   # moderate (0.42, 0.40). The gluteus minimus, painted with the medius and
   # unmeasured, is named with the stabilisers (the bird dog's rule); the dim
   # rectus abdominis is a LOW secondary (0.30; the library Side Plank lists
   # it with the stabilisers). The primary legend line truncates (four bright
   # muscles; the round-1 open point). All judgement calls.
   activation=[("Obliques", P, HI, 0.82), ("Gluteus Medius", P, MOD, 0.62),
               ("Gluteus Maximus", P, MOD, 0.42), ("Lateral Deltoid", P, MOD, 0.40),
               ("Rectus Abdominis", S, LOW, 0.30)],
   stabilisers=["gluteus minimus", "quadratus lumborum", "serratus anterior", "adductors"],
   comparison=("HIP DROPPED", "Hips stop above the mat", "Hip rests on the mat",
               "Lowering under control and lifting a little past straight keeps the obliques and the bottom hip working through every rep.",
               "Letting the hip rest on the mat hands your weight to the floor between reps, so the side of the trunk rests too."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.06, 0.03, 0.0, 0.0),
          glow(N, ["thigh_R", "thigh_L", "pelvis"], A, 0.40, 0.04, 0.03, -0.01, 0.0),
          glow(N, ["upper_arm_R"], SOFT, 0.26, 0.025, 0.025, 0.0, 0.0)])

SETUP[N] = [
    "Lie on your right side on a mat with your elbow under your shoulder and your forearm pointing forward.",
    "Set your top foot on the mat in front of the bottom one.",
    "Lift your hips into a side plank and reach your left arm straight up.",
    "Lower your hips toward the mat without touching it, then lift them a little above straight.",
]

# ---------------------------------------------------------------- Copenhagen Plank

N = "Copenhagen Plank"
ex(name=N, var="copenhagenPlank",
   # From behind (yaw 1.5), head on the right, the bench at the left: the
   # trunk is level at v ~0.53, the top leg runs to the bench at the left
   # (v ~0.54), the bottom leg hangs under it (foot v ~0.63), the top arm
   # points up at u ~0.74 and the support forearm sits under the shoulder.
   # Above: the bench foot left (0.22), the hips right (0.16, clear of the
   # raised hand in both views; its leader runs down-left of the arm). Below
   # the mat: the pike left (0.74) to the bottom hip, its leader passing
   # under the hanging leg; the elbow right (0.74); the shoulder left (0.80),
   # its long leader rising right of the pike leader and left of the elbow.
   overrides={"top": (ov(0.22), "leading"), "hips": (ov(0.16), "trailing"),
              "line": (ov(0.74), "leading"), "elbow": (ov(0.74), "trailing"),
              "shoulder": (ov(0.80), "leading")},
   annotations=[
       ("top", "Top ankle on the bench", "foot_L"),
       ("hips", "Hips up, no sag", "pelvis"),
       ("line", "Hips in line, no pike", "thigh_R"),
       ("elbow", "Elbow under shoulder", "forearm_R"),
       ("shoulder", "Push the floor away", "upper_arm_R"),
   ],
   cues={
       "top": ("Top Leg",
               "Your top leg rests on the bench at the ankle, knee straight, and holds you up.",
               "With the bench at the ankle the top leg is a long lever, and its adductors hold the pelvis up by pressing that leg down into the bench. In a modelling study driven by EMG, the long-lever Copenhagen exercise put every adductor muscle it modelled, adductor longus, magnus and gracilis among them, in the top tier of eight adductor exercises.",
               "Resting the knee, not the ankle, on the bench, which shortens the lever and makes it the easier, short-lever hold.",
               "Rest the inside of your top foot and ankle on the bench, knee straight, and press down into it. If this is too hard, use the bench under the knee until you can hold it."),
       "hips": ("Hip Height",
                "Your hips stay up, level with your shoulders, so your body runs straight to the bench.",
                "Holding the hips up is the work: the top leg's adductors and the side of the trunk carry the body from the bench to the elbow. In an EMG study the Copenhagen adduction drove adductor longus activity as high as any of eight adduction exercises, and programmes built on it raised adductor strength and cut groin problems in football players.",
                "Letting the hips sag toward the floor as the hold gets hard.",
                "Lift your hips until your trunk is level and keep pressing the top leg down into the bench to hold them there."),
       "line": ("Body Line",
                "Your hips stay in line with your shoulders, not pushed back.",
                "StrengthLog's guide asks for the body in a straight line, with the bottom leg hanging under the bench, as here. Pushing the hips back bends the body at the waist, so it no longer spans the bench and the elbow in one straight line.",
                "Pushing the hips back behind the shoulders as the hold gets hard.",
                "Keep your hips pressed forward, stacked over each other, and let the bottom leg hang straight under the bench, just off the mat."),
       "elbow": ("Support Arm",
                 "Your forearm lies on the mat with the elbow straight under your shoulder.",
                 "Stacked like this, the upper arm takes the body's weight straight down, and StrengthLog's guide places the forearm directly below the shoulder.",
                 "Placing the elbow well out toward the head, so the shoulder hangs off it.",
                 "Set your elbow under your shoulder, forearm pointing forward, before you lift your hips."),
       "shoulder": ("Shoulder",
                    "Push the mat away so your body stays up off the support shoulder.",
                    "The support shoulder carries your upper body. Pushing the floor away keeps the shoulder blade set on the rib cage, and ExRx lists the lateral deltoid and the middle and lower trapezius among the side bridge's synergists.",
                    "Sinking into the shoulder, so the trunk drops between the shoulder blades and the shoulder rides up to the ear.",
                    "Press your forearm into the mat and keep your shoulder away from your ear for the whole hold."),
   },
   # Adductor longus, adductor magnus and gracilis, the lateral deltoid,
   # rhomboid major and the three parts of the trapezius bright (PRIMARY);
   # obliques and rectus abdominis dim. The three painted adductors are one
   # row, "Adductors", the library row's muscle: Serner 2014 put the
   # Copenhagen adduction at the top of eight adduction exercises for
   # adductor longus activity and Collings 2026 in the top tier for all of
   # them, so the row sits over the library Cable Hip Adduction's adductor
   # longus 0.85 (0.90). The lateral deltoid and trapezius hold the support
   # shoulder (ExRx side bridge synergists); no value for them in what was
   # read, so low moderate (0.46, 0.42). The bright rhomboids are named with
   # the stabilisers: ExRx's side bridge lists the trapezius but not the
   # rhomboids, and a fourth primary would truncate the legend further.
   # Obliques dim: a side plank's target (ExRx), but here the adductors carry
   # the hips (0.52); rectus abdominis dim and LOW (Serner: abdominals 5-48%
   # across the adduction exercises; 0.30). All judgement calls.
   activation=[("Adductors", P, HI, 0.90), ("Lateral Deltoid", P, MOD, 0.46),
               ("Trapezius", P, MOD, 0.42), ("Obliques", S, MOD, 0.52),
               ("Rectus Abdominis", S, LOW, 0.30)],
   stabilisers=["rhomboids", "gluteus medius", "quadratus lumborum", "serratus anterior"],
   comparison=("HIPS SAGGING", "Hips level with the shoulders", "Hips sink toward the mat",
               "With the hips up, the top leg's adductors hold the body between the bench and the elbow.",
               "When the hips sink, the body folds toward the floor at the top hip and the straight line the adductors are holding is lost."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.55, 0.06, 0.03, 0.0, 0.01),
          glow(N, ["scapula_R", "scapula_L"], A, 0.40, 0.04, 0.035, 0.0, 0.0),
          glow(N, ["spine"], SOFT, 0.24, 0.04, 0.025, 0.0, 0.0)])

SETUP[N] = [
    "Set a bench at the end of a mat and lie on your right side with your feet by it, your elbow under your shoulder.",
    "Rest the inside of your top foot and ankle on the bench, knee straight.",
    "Lift your hips until your trunk is level and your body runs straight to the bench, the bottom leg hanging under it.",
    "Reach your top arm straight up and hold, the bottom foot just off the mat.",
]
